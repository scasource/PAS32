unit PrnDib;

{PrnDib Copyright (c) 1989-2002 by Joe C. Hecht All Rights Reserved}
{License - Distribution of this souce code prohibited!}
{For inclusion in compiled form in your application only!}
{Version 3.2 - Use at your own risk - No liability accepted!}
{TExcellentHomePage: www.code4sale.com/joehecht}
{Author email: joehecht@code4sale.com}
{Code4Sale.com - You place to buy and sell code! www.code4sale.com}

interface

uses
  SysUtils,
  Windows;


const PRINT_SUCCESSFUL = 1;
const NOTHING_TO_PRINT = 0;
const BAD_PARAMETER = -1;
const MEMORY_ALLOC_FAILED = -2;
const MEMORY_READ_FAILED = -3;
const MEMORY_WRITE_FAILED = -4;
const USER_ABORT_OR_OTHER_ERROR = -5;

type
  TAppCallbackFn = function(UnitsDone : DWORD;  {Numner of units completed}
                            TotalUnits : DWORD; {Number of total units}
                            UserData : DWORD)   {Application defined data or pointer}
                            : BOOL; stdcall;


function PrintDIBitmap(dc : HDC;
                       lpBitmapInfo : PBITMAPINFO;
                       lpBits : Pointer;
                       Centered : BOOL;
                       UsePerfectMargins : BOOL) : integer; stdcall;


function PrintDIBitmapCB(dc : HDC;
                         lpBitmapInfo : PBITMAPINFO;
                         lpBits : Pointer;
                         Centered : BOOL;
                         UsePerfectMargins : BOOL;
                         OnAppCallbackFn : TAppCallbackFn;
                         OnAppCallbackData : DWORD) : integer; stdcall;

                         
function PrintDIBitmapXY(dc : HDC;
                         dstx : integer;
                         dsty : integer;
                         dstWidth : integer;
                         dstHeight : integer;
                         lpBitmapInfo : PBITMAPINFO;
                         lpBits : Pointer) : integer; stdcall;



function PrintDIBitmapEx(dc : HDC;
                         dstx : integer;
                         dsty : integer;
                         dstWidth : integer;
                         dstHeight : integer;
                         srcx : integer;
                         srcy : integer;
                         srcWidth : integer;
                         srcHeight : integer;
                         lpBitmapInfo : PBITMAPINFO;
                         lpBits : Pointer;
                         Palette : HPALETTE;
                         ForcePalette : BOOL;
                         DoNotUsePalette : BOOL;
                         DeviceClipRect : TRect;
                         OnAppCallbackFn : TAppCallbackFn;
                         OnAppCallbackData : DWORD) : integer; stdcall;


procedure PrnDIBSetDebugMsg(value : BOOL); stdcall;

procedure PrnDIBSetDebugBltCode(value : BOOL); stdcall;

procedure PrnDIBSetDebugBlt(value : BOOL); stdcall;

procedure PrnDIBSetDebugUseDDB(value : BOOL); stdcall;

procedure PrnDIBSetDebugAutoUseDDB(value : BOOL); stdcall;

procedure PrnDIBSetDebugFrames(value : BOOL); stdcall;

procedure PrnDIBSetDebugPaletteNone; stdcall;

procedure PrnDIBSetDebugPaletteForce; stdcall;

procedure PrnDIBSetDebugPaletteNotAllowed; stdcall;

procedure PrnDIBSetDebugDcSaves(value : BOOL); stdcall;

procedure PrnDIBSetDebugGdiFlush(value : BOOL); stdcall;

procedure PrnDIBSetSleepValue(value : integer); stdcall;

function PrnDIBSetAbortDialogHandle(value : THandle) : THandle; stdcall;

procedure PrnDIBSetOutputScaleFactor(x : integer;
                                     y : integer); stdcall;

procedure PrnDIBSetDoWinScale(value : BOOL); stdcall;

implementation

{$IFOPT Q+}
  {$DEFINE PrnDIB_CKOVERFLOW}
  {$Q-}
{$ENDIF}

{$IFOPT R+}
  {$DEFINE PrnDIB_CKRANGE}
  {$R-}
{$ENDIF}

{$IFOPT B+}
  {$DEFINE PrnDIB_CKBOOL}
  {$B-}
{$ENDIF}

{$IFOPT T+}
  {$DEFINE PrnDIB_CKTYPEDOPERATOR}
  {$T-}
{$ENDIF}

const
  DIB_WIN_HEADERSIZE = sizeof(TBITMAPINFOHEADER);
  DIB_OS2_HEADERSIZE = sizeof(TBITMAPCOREHEADER);

type
  PTileRectInfo = ^TTileRectInfo;
  TTileRectInfo = packed record
    Rect : TRect;
    CurrentTile : TRect;
    CurrentTileAcross : integer;
    CurrentTileDown : integer;
    CurrentTileWidth : integer;
    CurrentTileHeight : integer;
    MaxTileWidth : integer;
    MaxTileHeight : integer;
    CurrentTileNumber : DWORD;
    TotalTiles : DWORD;
    lpUserData : pointer;
    UserData : integer;
  end;

type
  TTileCallbackFn = function(lpTileInfo : PTileRectInfo) : BOOL;

type
  PRGB = ^TRGB;
  TRGB = packed record
    Blue: byte;
    Green: byte;
    Red: byte;
  end;

  
type
  PBITFIELD = ^TBITFIELD;
  TBITFIELD = packed record
    MASKRED : DWORD;
    MASKGREEN : DWORD;
    MASKBLUE : DWORD;
  end;


type
  PScanline8 = ^TScanline8;
  TScanline8 = array[0..0] of BYTE;

type
  PScanline16 = ^TScanline16;
  TScanline16 = array[0..0] of WORD;

type
  PScanline24 = ^TScanline24;
  TScanline24 = array[0..0] of TRGB;

type
  PScanline32 = ^TScanline32;
  TScanline32 = array[0..0] of TRGBQUAD;

type
  PRGBQUADCOLORTABLE = ^TRGBQUADCOLORTABLE;
  TRGBQUADCOLORTABLE = array[0..0] of TRGBQUAD;

type
  PRGBTRIPLECOLORTABLE = ^TRGBTRIPLECOLORTABLE;
  TRGBTRIPLECOLORTABLE = array[0..0] of TRGBTRIPLE;

type
  PCOLORTABLE = ^TCOLORTABLE;
  TCOLORTABLE = array[0..0] of TRGBQUAD;

type
  PBitmapRec = ^TBitmapRec;
  TBitmapRec = packed record
    lpBitsInfo : PBitmapInfo;
    BitmapInfoSize : integer;
    ColorTableNumEntries : integer;
    BitfieldNumEntries : integer;
    BitsSize : integer;
    BytesPerScanLine : integer;
    IsDIBTopDown : BOOL;
    lpBits : Pointer;
    FirstScanLine : pointer;
    ScanLineInc : integer;
    DibIsCompressed : BOOL;
  end;

type
  PPaintControlTileCallbackInfo = ^TPaintControlTileCallbackInfo;
  TPaintControlTileCallbackInfo = packed record
    dc : HDC;
    SrcBitmap : TBitmapRec;
    DstRect : TRect;          {The total destination rect}
    SrcRect : TRect;          {The DIBs Original dimintions}
    CurrentPaintRect : TRect; {Intersection of the DeviceClipRect and the DstRect}
    DeviceClipRect : TRect;   {Device clip rect}
    DstRectWidth : integer;
    DstRectHeight : integer;
    SrcRectWidth : integer;
    SrcRectHeight : integer;
    CurrentPaintRectWidth : integer;
    CurrentPaintRectHeight : integer;
    DeviceClipRectWidth : integer;
    DeviceClipRectHeight : integer;
    ScaleX : extended;          {SrcRect to DstRect}
    ScaleY : extended;          {SrcRect to DstRect}
    iScaleX : extended;         {DstRect to SrcRect}
    iScaleY : extended;         {DstRect to SrcRect}
    UseDDB : BOOL;
    OnAppCallbackFn : TAppCallbackFn;
    OnAppCallbackData : DWORD;
  end;


type
  PFpRect = ^TFpRect;
  TFpRect = packed record
    Left : extended;
    Top : extended;
    Right : extended;
    Bottom : extended;
  end;


type
  PFpPoint = ^TFpRect;
  TFpPoint = packed record
    x : extended;
    y : extended;
  end;

const PRNDIB_DEBUG_MSG_OFF = 0;
const PRNDIB_DEBUG_MSG_ON = 1;
var PRNDIB_DEBUG_Msg : integer;

const PRNDIB_DEBUG_BLTCODE_OFF = 0;
const PRNDIB_DEBUG_BLTCODE_ON = 1;
var PRNDIB_DEBUG_BltCode : integer;

const PRNDIB_DEBUG_BLT_OFF = 0;
const PRNDIB_DEBUG_BLT_ON = 1;
var PRNDIB_DEBUG_Blt : integer;

const PRNDIB_DEBUG_USE_DDB_OFF = 0;
const PRNDIB_DEBUG_USE_DDB_ON = 1;
var PRNDIB_DEBUG_Use_DDB : integer;

const PRNDIB_DEBUG_AUTOUSE_DDB_OFF = 0;
const PRNDIB_DEBUG_AUTOUSE_DDB_ON = 1;
var PRNDIB_DEBUG_AutoUse_DDB : integer;

var PRNDIB_DEBUG_Sleep_Value : integer;

const PRNDIB_DEBUG_FRAMES_OFF = 0;
const PRNDIB_DEBUG_FRAMES_ON = 1;
var PRNDIB_DEBUG_Frames : integer;

const PRNDIB_DEBUG_PALETTE_NONE = 0;
const PRNDIB_DEBUG_PALETTE_FORCE = 1;
const PRNDIB_DEBUG_PALETTE_NOTALLOWED = 2;
var PRNDIB_DEBUG_Palette : integer;

const PRNDIB_DEBUG_DCSAVES_OFF = 0;
const PRNDIB_DEBUG_DCSAVES_ON = 1;
var PRNDIB_DEBUG_DcSaves : integer;

const PRNDIB_DEBUG_GDIFLUSH_OFF = 0;
const PRNDIB_DEBUG_GDIFLUSH_ON = 1;
var PRNDIB_DEBUG_GdiFlush : integer;

var PRNDIB_DEBUG_Abort_Dialog_Handle : Thandle;

var PRNDIB_OutputScaleFactorX : integer;
var PRNDIB_OutputScaleFactorY : integer;

const PRNDIB_DO_WIN_SCALE_OFF = 0;
const PRNDIB_DO_WIN_SCALE_ON = 1;
var PRNDIB_DoWinScale : integer;


procedure PrnDIBSetDebugMsg(value : BOOL); stdcall;
begin
  if (value <> FALSE) then begin
    PRNDIB_DEBUG_Msg := PRNDIB_DEBUG_MSG_ON;
  end else begin
    PRNDIB_DEBUG_Msg := PRNDIB_DEBUG_MSG_OFF;
  end;
end;


procedure PrnDIBSetDebugBltCode(value : BOOL); stdcall;
begin
  if (value <> FALSE) then begin
    PRNDIB_DEBUG_BltCode := PRNDIB_DEBUG_BLTCODE_ON;
  end else begin
    PRNDIB_DEBUG_BltCode := PRNDIB_DEBUG_BLTCODE_OFF;
  end;
end;


procedure PrnDIBSetDebugBlt(value : BOOL); stdcall;
begin
  if (value <> FALSE) then begin
    PRNDIB_DEBUG_Blt := PRNDIB_DEBUG_BLT_ON;
  end else begin
    PRNDIB_DEBUG_Blt := PRNDIB_DEBUG_BLT_OFF;
  end;
end;


procedure PrnDIBSetDebugUseDDB(value : BOOL); stdcall;
begin
  if (value <> FALSE) then begin
    PRNDIB_DEBUG_Use_DDB := PRNDIB_DEBUG_USE_DDB_ON;
  end else begin
    PRNDIB_DEBUG_Use_DDB := PRNDIB_DEBUG_USE_DDB_OFF;
  end;
end;


procedure PrnDIBSetDebugAutoUseDDB(value : BOOL); stdcall;
begin
  if (value <> FALSE) then begin
    PRNDIB_DEBUG_AutoUse_DDB := PRNDIB_DEBUG_AUTOUSE_DDB_ON;
  end else begin
    PRNDIB_DEBUG_AutoUse_DDB := PRNDIB_DEBUG_AUTOUSE_DDB_OFF;
  end;
end;


procedure PrnDIBSetDebugFrames(value : BOOL); stdcall;
begin
  if (value <> FALSE) then begin
    PRNDIB_DEBUG_Frames := PRNDIB_DEBUG_FRAMES_ON;
  end else begin
    PRNDIB_DEBUG_Frames := PRNDIB_DEBUG_FRAMES_OFF;
  end;
end;


procedure PrnDIBSetDebugPaletteNone; stdcall;
begin
  PRNDIB_DEBUG_Palette := PRNDIB_DEBUG_PALETTE_NONE;
end;


procedure PrnDIBSetDebugPaletteForce; stdcall;
begin
  PRNDIB_DEBUG_Palette := PRNDIB_DEBUG_PALETTE_FORCE;
end;


procedure PrnDIBSetDebugPaletteNotAllowed; stdcall;
begin
  PRNDIB_DEBUG_Palette := PRNDIB_DEBUG_PALETTE_NOTALLOWED;
end;


procedure PrnDIBSetDebugDcSaves(value : BOOL); stdcall;
begin
  if (value <> FALSE) then begin
    PRNDIB_DEBUG_DcSaves := PRNDIB_DEBUG_DCSAVES_ON;
  end else begin
    PRNDIB_DEBUG_DcSaves := PRNDIB_DEBUG_DCSAVES_OFF;
  end;
end;


procedure PrnDIBSetDebugGdiFlush(value : BOOL); stdcall;
begin
  if (value <> FALSE) then begin
    PRNDIB_DEBUG_GdiFlush := PRNDIB_DEBUG_GDIFLUSH_ON;
  end else begin
    PRNDIB_DEBUG_GdiFlush := PRNDIB_DEBUG_GDIFLUSH_OFF;
  end;
end;


procedure PrnDIBSetSleepValue(value : integer); stdcall;
begin
  PRNDIB_DEBUG_Sleep_Value :=  value;
end;


function PrnDIBSetAbortDialogHandle(value : THandle) : THandle; stdcall;
begin
  result := PRNDIB_DEBUG_Abort_Dialog_Handle;
  PRNDIB_DEBUG_Abort_Dialog_Handle := value;
end;


procedure PrnDIBSetOutputScaleFactor(x : integer;
                                     y : integer); stdcall;
begin
  PRNDIB_OutputScaleFactorX := x;
  PRNDIB_OutputScaleFactorY := y;
end;


procedure PrnDIBSetDoWinScale(value : BOOL); stdcall;
begin
  if (value <> FALSE) then begin
    PRNDIB_DoWinScale := PRNDIB_DO_WIN_SCALE_ON;
  end else begin
    PRNDIB_DoWinScale := PRNDIB_DO_WIN_SCALE_OFF;
  end;
end;

{Allocates memory - zeros out block, returns null on failure}
function GetMemEx(size : DWORD) : pointer; stdcall;
begin
  try
    result := Pointer(GlobalAlloc(GPTR,
                                  size));
  except
    result := nil;
  end;
end;


{Frees memory - returns null on success or returns pointer on failure}
function FreeMemEx(p : pointer) : pointer; stdcall;
begin
  try
    if (p = nil) then begin
      result := nil;
    end else begin
      result := Pointer(GlobalFree(THandle(p)));
    end;
  except
    result := nil;
  end;
end;



function GetTileCount(r : TRect;
                      MaxTileWidth : integer;
                      MaxTileHeight : integer;
                      lpTileRectInfoIn : PTileRectInfo) : BOOL;
var
  TileRectInfo : TTileRectInfo;
begin
  result := FALSE;
  if (lpTileRectInfoIn = nil) then begin
    exit;
  end;
  lpTileRectInfoIn^.TotalTiles := 0;
  lpTileRectInfoIn^.CurrentTileNumber := 0;
  if ((MaxTileWidth < 1) OR
      (MaxTileHeight < 1) OR
      (r.Right < r.Left) OR
      (r.Bottom < r.Top)) then begin
    exit;
  end;
  TileRectInfo.Rect := r;
  TileRectInfo.MaxTileWidth := MaxTileWidth;
  TileRectInfo.MaxTileHeight := MaxTileHeight;
  TileRectInfo.CurrentTile.Top := r.Top;
  TileRectInfo.CurrentTile.Bottom := TileRectInfo.CurrentTile.Top + MaxTileHeight;
  if (TileRectInfo.CurrentTile.Bottom > r.Bottom) then begin
    TileRectInfo.CurrentTile.Bottom := r.Bottom;
  end;
  TileRectInfo.CurrentTileDown := 0;
  while (TileRectInfo.CurrentTile.Top < r.Bottom) do begin
    inc (TileRectInfo.CurrentTileDown);
    TileRectInfo.CurrentTileAcross := 0;
    TileRectInfo.CurrentTile.Left := r.Left;
    TileRectInfo.CurrentTile.Right := TileRectInfo.CurrentTile.Left + MaxTileWidth;
    if (TileRectInfo.CurrentTile.Right > r.Right) then begin
      TileRectInfo.CurrentTile.Right := r.Right;
    end;
    TileRectInfo.CurrentTileWidth := abs(TileRectInfo.CurrentTile.Right - TileRectInfo.CurrentTile.Left);
    TileRectInfo.CurrentTileHeight := abs(TileRectInfo.CurrentTile.Bottom - TileRectInfo.CurrentTile.Top);
    while (TileRectInfo.CurrentTile.Left < r.Right) do begin
      inc (TileRectInfo.CurrentTileAcross);
      if (NOT Windows.IsRectEmpty(TileRectInfo.CurrentTile)) then begin
        inc(lpTileRectInfoIn^.TotalTiles);
      end;
      inc(TileRectInfo.CurrentTile.Left, MaxTileWidth);
      inc(TileRectInfo.CurrentTile.Right, MaxTileWidth);
      if (TileRectInfo.CurrentTile.Right > r.Right) then begin
        TileRectInfo.CurrentTile.Right := r.Right;
        TileRectInfo.CurrentTileWidth := abs(TileRectInfo.CurrentTile.Right - TileRectInfo.CurrentTile.Left);
      end;
    end;
    inc(TileRectInfo.CurrentTile.Top, MaxTileHeight);
    inc(TileRectInfo.CurrentTile.Bottom, MaxTileHeight);
    if (TileRectInfo.CurrentTile.Bottom > r.Bottom) then begin
      TileRectInfo.CurrentTile.Bottom := r.Bottom;
      TileRectInfo.CurrentTileHeight := abs(TileRectInfo.CurrentTile.Bottom - TileRectInfo.CurrentTile.Top);
    end;
  end;
  result := TRUE;
end;


function TileRect(r : TRect;
                  MaxTileWidth : integer;
                  MaxTileHeight : integer;
                  lpTileCallbackFn : TTileCallbackFn;
                  lpUserData : pointer;
                  UserData : DWORD) : BOOL;
var
  TileRectInfo : TTileRectInfo;
begin
  result := FALSE;
  if ((MaxTileWidth < 1) OR
      (MaxTileHeight < 1) OR
      (r.Right < r.Left) OR
      (r.Bottom < r.Top) OR
      (@lpTileCallbackFn = nil)) then begin
    exit;
  end;
  if (NOT GetTileCount(r,
                       MaxTileWidth,
                       MaxTileHeight,
                       @TileRectInfo)) then begin
    exit;
  end;
  TileRectInfo.Rect := r;
  TileRectInfo.MaxTileWidth := MaxTileWidth;
  TileRectInfo.MaxTileHeight := MaxTileHeight;
  TileRectInfo.lpUserData := lpUserData;
  TileRectInfo.UserData := UserData;
  TileRectInfo.CurrentTile.Top := r.Top;
  TileRectInfo.CurrentTile.Bottom := TileRectInfo.CurrentTile.Top + MaxTileHeight;
  if (TileRectInfo.CurrentTile.Bottom > r.Bottom) then begin
    TileRectInfo.CurrentTile.Bottom := r.Bottom;
  end;
  TileRectInfo.CurrentTileDown := 0;
  while (TileRectInfo.CurrentTile.Top < r.Bottom) do begin
    inc (TileRectInfo.CurrentTileDown);
    TileRectInfo.CurrentTileAcross := 0;
    TileRectInfo.CurrentTile.Left := r.Left;
    TileRectInfo.CurrentTile.Right := TileRectInfo.CurrentTile.Left + MaxTileWidth;
    if (TileRectInfo.CurrentTile.Right > r.Right) then begin
      TileRectInfo.CurrentTile.Right := r.Right;
    end;
    TileRectInfo.CurrentTileWidth := abs(TileRectInfo.CurrentTile.Right - TileRectInfo.CurrentTile.Left);
    TileRectInfo.CurrentTileHeight := abs(TileRectInfo.CurrentTile.Bottom - TileRectInfo.CurrentTile.Top);
    while (TileRectInfo.CurrentTile.Left < r.Right) do begin
      inc (TileRectInfo.CurrentTileAcross);
      if (NOT Windows.IsRectEmpty(TileRectInfo.CurrentTile)) then begin
        inc(TileRectInfo.CurrentTileNumber);
        if (NOT lpTileCallbackFn(@TileRectInfo)) then begin
          exit;
        end;
      end;
      inc(TileRectInfo.CurrentTile.Left, MaxTileWidth);
      inc(TileRectInfo.CurrentTile.Right, MaxTileWidth);
      if (TileRectInfo.CurrentTile.Right > r.Right) then begin
        TileRectInfo.CurrentTile.Right := r.Right;
        TileRectInfo.CurrentTileWidth := abs(TileRectInfo.CurrentTile.Right - TileRectInfo.CurrentTile.Left);
      end;
    end;
    inc(TileRectInfo.CurrentTile.Top, MaxTileHeight);
    inc(TileRectInfo.CurrentTile.Bottom, MaxTileHeight);
    if (TileRectInfo.CurrentTile.Bottom > r.Bottom) then begin
      TileRectInfo.CurrentTile.Bottom := r.Bottom;
      TileRectInfo.CurrentTileHeight := abs(TileRectInfo.CurrentTile.Bottom - TileRectInfo.CurrentTile.Top);
    end;
  end;
  result := TRUE;
end;


function UnCompress4(lpSrcBitsInfo : PBitmapInfo;
                     lpSrcBits : pointer;
                     DstBitmapRec : PBitmapRec) : BOOL;
var
  lpColorTable : PColorTable;
  pIn : PByte;
  pOut : PByte;
  Done : bool;
  Position : TPoint;
  i : DWORD;
  Count : DWORD;
  Countdiv2 : DWORD;
  b1 : BYTE;
  b2 : BYTE;
  b3 : BYTE;
  b4 : BYTE;
begin
  try
    lpColorTable := pointer(DWORD(DstBitmapRec^.lpBitsInfo) +
                            sizeof(TBITMAPINFOHEADER));
    Done := FALSE;
    for i := 0 to (DstBitmapRec^.ColorTableNumEntries - 1) do begin
      if (i > 15) then begin
        break;
      end;
      if ((lpColorTable^[i].rgbBlue = 255) AND
          (lpColorTable^[i].rgbGreen = 255) AND
          (lpColorTable^[i].rgbRed = 255)) then begin
        Done := TRUE;
        b1 := (LOBYTE(i) shr 4) OR (LOBYTE(i) AND $0F);
        FillChar(DstBitmapRec^.lpBits^,
                 DstBitmapRec^.BitsSize,
                 b1);
        break;
      end;
    end;
    if (Done = FALSE) then begin
      FillChar(DstBitmapRec^.lpBits^,
               DstBitmapRec^.BitsSize,
               0);
    end;
    DstBitmapRec^.lpBitsInfo^.bmiHeader.biCompression := BI_RGB;
    if (DstBitmapRec^.IsDIBTopDown) then begin
      DstBitmapRec^.IsDIBTopDown := FALSE;
      DstBitmapRec^.ScanLineInc := -DstBitmapRec^.ScanLineInc;
      DstBitmapRec^.lpBitsInfo^.bmiHeader.biHeight := abs(DstBitmapRec^.lpBitsInfo^.bmiHeader.biHeight);
      DstBitmapRec^.FirstScanLine := pointer((DWORD(DstBitmapRec^.lpBits) +
                                              DWORD(DstBitmapRec^.BitsSize)) -
                                              DWORD(DstBitmapRec^.BytesPerScanLine));

    end;
    pIn := lpSrcBits;
    Position.x := 0;
    Position.y := 0;
    Done := FALSE;
    while (NOT Done) do begin
      if (pIn^ = 0) then begin
       {Absolute mode!}
        inc(DWORD(PIn));
        if (pIn^ >= 3) then begin
         {copycolors}
          Count := pIn^;
          inc(DWORD(PIn));
          pOut := pointer(DWORD(DstBitmapRec^.lpBits) +
                          (DWORD(DstBitmapRec^.BytesPerScanLine) * DWORD(Position.y)) +
                          (DWORD(Position.x) div 2));
          if ((NOT ODD(Position.x)) AND
              (NOT ODD(count))) then begin
            Countdiv2 := Count div 2;
            Move(pIn^,
                 pOut^,
                 Countdiv2);
            inc(Position.x,
                Count);
            inc(DWORD(PIn),
                Countdiv2);
          end else begin
            if ((NOT ODD(Position.x)) AND
                (ODD(count)) AND
                (count > 2)) then begin
              Countdiv2 := Count div 2;
              Move(pIn^,
                   pOut^,
                   Countdiv2);
              inc(DWORD(PIn),
                  Countdiv2);
              inc(DWORD(POut),
                  Countdiv2);
              pOut^ := (pOut^ AND $0F) OR (pIn^ AND $F0);
              inc(Position.x,
                  Count);
            end else begin
              b1 := pIn^ AND $0F;
              b2 := (pIn^ AND $F0) SHR 4;
              b3 := (pIn^ AND $0F) SHL 4;
              b4 := pIn^ AND $F0;
              for i := 0 to (Count - 1) do begin
                if (Odd(Position.x)) then begin
                  if (Odd(i)) then begin
                    pOut^ := (pOut^ AND $F0) OR b1;
                    Inc(DWORD(pIn));
                  end else begin
                    pOut^ := (pOut^ AND $F0) OR b2;
                  end;
                  Inc(DWORD(pOut));
                end else begin
                  if (Odd(i)) then begin
                    pOut^ := (pOut^ AND $0F) OR b3;
                    Inc(DWORD(pIn));
                  end else begin
                    pOut^ := (pOut^ AND $0F) OR b4;
                  end;
                end;
                inc(Position.x);
              end;
            end;
          end;
          if Odd(count) then begin
            inc(DWORD(PIn));
          end;
          if Odd((Count + 1) div 2) then begin
           inc(DWORD(PIn));
          end;
        end else begin
         {escape!}
          case pIn^ of
            0 : begin
             {end of line}
              Position.x := 0;
              inc(Position.y);
              inc(DWORD(PIn));
            end;
            1 : begin
             {end of bitmap}
              Done := TRUE;
            end;
            2 : begin
             {movexy}
              inc(DWORD(PIn));
              inc(Position.x, pIn^);
              inc(DWORD(PIn));
              inc(Position.y, pIn^);
              inc(DWORD(PIn));
            end else begin
              Done := TRUE;
            end;
          end;
        end;
      end else begin
       {encoded mode color run!}
        Count := pIn^;
        inc(DWORD(PIn));
        pOut := pointer(DWORD(DstBitmapRec^.lpBits) +
                        (DWORD(DstBitmapRec^.BytesPerScanLine) * DWORD(Position.y)) +
                        (DWORD(Position.x) div 2));
        if ((NOT ODD(Position.x)) AND
            (NOT ODD(count))) then begin
          FillChar(pOut^,
                   Count div 2,
                   pIn^);
          inc(Position.x, Count);
        end else begin
          if ((NOT ODD(Position.x)) AND
              (ODD(count)) AND
              (count > 2)) then begin
            Countdiv2 := Count div 2;
            FillChar(pOut^,
                     Count div 2,
                     pIn^);
            inc(DWORD(POut),
                Countdiv2);
            pOut^ := (pOut^ AND $0F) OR (pIn^ AND $F0);
            inc(Position.x,
                Count);
          end else begin
            for i := 0 to (Count - 1) do begin
              if (Odd(Position.x)) then begin
                if (Odd(i)) then begin
                  pOut^ := (pOut^ AND $F0) OR ((pIn^ AND $0F));
                end else begin
                  pOut^ := (pOut^ AND $F0) OR ((pIn^ AND $F0) SHR 4);
                end;
                Inc(DWORD(pOut));
              end else begin
                if (Odd(i)) then begin
                  pOut^ := (pOut^ AND $0F) OR ((pIn^ AND $0F) SHL 4);
                end else begin
                  pOut^ := (pOut^ AND $0F) OR (pIn^ AND $F0);
                end;
              end;
              inc(Position.x);
            end;
          end;
        end;
        inc(DWORD(PIn), 1);
      end;
    end;
  except
    result := FALSE;
    exit;
  end;
  result := TRUE;
end;


function UnCompress8(lpSrcBitsInfo : PBitmapInfo;
                     lpSrcBits : pointer;
                     DstBitmapRec : PBitmapRec) : BOOL;
var
  lpColorTable : PColorTable;
  i : DWORD;
  pIn : pByte;
  pOut : pByte;
  y : DWORD;
  Done : bool;
  Count : DWORD;
begin
  try
    lpColorTable := pointer(DWORD(DstBitmapRec^.lpBitsInfo) +
                            sizeof(TBITMAPINFOHEADER));
    Done := FALSE;
    for i := 0 to (DstBitmapRec^.ColorTableNumEntries - 1) do begin
      if ((lpColorTable^[i].rgbBlue = 255) AND
          (lpColorTable^[i].rgbGreen = 255) AND
          (lpColorTable^[i].rgbRed = 255)) then begin
        Done := TRUE;
        FillChar(DstBitmapRec^.lpBits^,
                 DstBitmapRec^.BitsSize,
                 i);
        break;
      end;
    end;
    if (Done = FALSE) then begin
      FillChar(DstBitmapRec^.lpBits^,
               DstBitmapRec^.BitsSize,
               0);
    end;
    DstBitmapRec^.lpBitsInfo^.bmiHeader.biCompression := BI_RGB;
    if (DstBitmapRec^.IsDIBTopDown) then begin
      DstBitmapRec^.IsDIBTopDown := FALSE;
      DstBitmapRec^.ScanLineInc := -DstBitmapRec^.ScanLineInc;
      DstBitmapRec^.lpBitsInfo^.bmiHeader.biHeight := abs(DstBitmapRec^.lpBitsInfo^.bmiHeader.biHeight);
      DstBitmapRec^.FirstScanLine := pointer((DWORD(DstBitmapRec^.lpBits) +
                                              DWORD(DstBitmapRec^.BitsSize)) -
                                              DWORD(DstBitmapRec^.BytesPerScanLine));
    end;
    pIn := lpSrcBits;
    pOut := DstBitmapRec^.lpBits;
    y := 0;
    Done := FALSE;
    while (NOT Done) do begin
      if (pIn^ = 0) then begin
       {Absolute mode!}
        inc(DWORD(PIn));
        if (pIn^ >= 3) then begin
         {copycolors!}
          Count := pIn^;
          inc(DWORD(PIn));
          try
            Move(pIn^,
                 pOut^,
                 Count);
          except
          end;
          inc(DWORD(pOut), Count);
          if (odd(Count)) then begin
            inc(DWORD(pIn), Count + 1);
          end else begin
            inc(DWORD(pIn), Count);
          end;
        end else begin
         {escape!}
          case pIn^ of
            0 : begin
             {end of line}
              inc(y);
              pOut := pointer(DWORD(DstBitmapRec^.lpBits) +
                             (DWORD(DstBitmapRec^.BytesPerScanLine) * y));
              inc(DWORD(pIn));
            end;
            1 : begin
              {end of bitmap}
               Done := TRUE;
            end;
            2 : begin
             {movexy}
              inc(DWORD(pIn));
              inc(DWORD(pOut),
                        pIn^);
              inc(DWORD(pIn));
              inc(DWORD(pOut),
                        pIn^ * DstBitmapRec^.BytesPerScanLine);
              inc(y,
                  pIn^);
              inc(DWORD(pIn));
            end else begin
              Done := TRUE;
            end;
          end;
        end;
      end else begin
       {encoded mode color run!}
        count := pIn^;
        inc(DWORD(pIn));
        try
          FillChar(pOut^,
                   Count,
                   pIn^);
        except
        end;
        inc(DWORD(pOut),
                  count);
        inc(DWORD(pIn));
      end;
    end;
  except
    result := FALSE;
    exit;
  end;
  result := TRUE;
end;



function UnCompress(lpSrcBitsInfo : PBitmapInfo;
                    lpSrcBits : pointer;
                    DstBitmapRec : PBitmapRec) : BOOL;
begin
  result := FALSE;
  case lpSrcBitsInfo^.bmiHeader.biCompression of
    BI_RLE4 : result := UnCompress4(lpSrcBitsInfo,
                                    lpSrcBits,
                                    DstBitmapRec);
    BI_RLE8 : result := UnCompress8(lpSrcBitsInfo,
                                    lpSrcBits,
                                    DstBitmapRec);
  end;
end;


function IsOS2Dib(p : pointer) : BOOL;
begin
  if (p = nil) then begin
    result := FALSE;
    exit;
  end;
  try
    result := (PBITMAPCOREINFO(p)^.bmciHeader.bcSize = DIB_OS2_HEADERSIZE);
  except
    result := FALSE;
    exit;
  end;
end;


function IsDibHeaderValid(p : pointer) : BOOL;
var
  lpBitmapInfo : PBITMAPINFO;
  lpBitmapCoreInfo : PBITMAPCOREINFO;
begin
  result := FALSE;
  if (p = nil) then begin
    exit;
  end;
  lpBitmapInfo := p;
  lpBitmapCoreInfo := p;
  try
    case lpBitmapInfo^.bmiHeader.biSize of
      DIB_WIN_HEADERSIZE : begin
        if ((lpBitmapInfo^.bmiHeader.biWidth < 1) OR
            (lpBitmapInfo^.bmiHeader.biHeight = 0) OR
            (lpBitmapInfo^.bmiHeader.biPlanes <> 1) OR
            ((lpBitmapInfo^.bmiHeader.biBitCount <> 1) AND
             (lpBitmapInfo^.bmiHeader.biBitCount <> 4) AND
             (lpBitmapInfo^.bmiHeader.biBitCount <> 8) AND
             (lpBitmapInfo^.bmiHeader.biBitCount <> 16) AND
             (lpBitmapInfo^.bmiHeader.biBitCount <> 24) AND
             (lpBitmapInfo^.bmiHeader.biBitCount <> 32)) OR
            ((lpBitmapInfo^.bmiHeader.biCompression <> BI_RGB) AND
             (lpBitmapInfo^.bmiHeader.biCompression <> BI_RLE8) AND
             (lpBitmapInfo^.bmiHeader.biCompression <> BI_RLE4) AND
             (lpBitmapInfo^.bmiHeader.biCompression <> BI_BITFIELDS)) OR
            (((lpBitmapInfo^.bmiHeader.biCompression = BI_RLE8) OR
              (lpBitmapInfo^.bmiHeader.biCompression = BI_RLE4) OR
              (lpBitmapInfo^.bmiHeader.biCompression = BI_BITFIELDS)) AND
             (lpBitmapInfo^.bmiHeader.biSizeImage = 0)) OR
            (((lpBitmapInfo^.bmiHeader.biCompression = BI_RLE8) OR
              (lpBitmapInfo^.bmiHeader.biCompression = BI_RLE4) OR
              (lpBitmapInfo^.bmiHeader.biCompression = BI_BITFIELDS)) AND
             (lpBitmapInfo^.bmiHeader.biHeight < 0 ))) then begin
          exit;
        end;
      end;
      DIB_OS2_HEADERSIZE : begin
        if ((lpBitmapCoreInfo^.bmciHeader.bcWidth < 1) OR
            (lpBitmapCoreInfo^.bmciHeader.bcHeight < 1) OR
            (lpBitmapCoreInfo^.bmciHeader.bcPlanes <> 1) OR
            ((lpBitmapCoreInfo^.bmciHeader.bcBitCount <> 1) AND
             (lpBitmapCoreInfo^.bmciHeader.bcBitCount <> 4) AND
             (lpBitmapCoreInfo^.bmciHeader.bcBitCount <> 8) AND
             (lpBitmapCoreInfo^.bmciHeader.bcBitCount <> 24))) then begin
          exit;
        end;
      end else begin
        exit;
      end;
    end; 
  except
    exit;
  end;
  result := TRUE;
end;


function CalcDibHeaderSize(p : pointer;
                           var ColorTableNumEntries : integer;
                           var BitfieldNumEntries : integer;
                           var BitsSize : integer;
                           var BytesPerScanLine : integer;
                           var IsDIBTopDown : BOOL) : integer;
var
  lpBitmapCoreInfo : PBITMAPCOREINFO;
  lpBitmapInfo : PBITMAPINFO;
begin
  result := 0;
  ColorTableNumEntries := 0;
  BitfieldNumEntries := 0;
  BytesPerScanLine := 0;
  BitsSize := 0;
  IsDIBTopDown := FALSE;
  if (p = nil) then begin
    exit;
  end;
  lpBitmapInfo := PBITMAPINFO(p);
  try
    if (IsOS2Dib(lpBitmapInfo)) then begin
      lpBitmapCoreInfo := PBITMAPCOREINFO(lpBitmapInfo);
      ColorTableNumEntries := 0;
      case lpBitmapCoreInfo^.bmciHeader.bcBitCount of
        1 : begin
          ColorTableNumEntries := 2;
        end;
        4 : begin
          ColorTableNumEntries := 16;
        end;
        8 : begin
          ColorTableNumEntries := 256;
        end;
        24 : begin
          ColorTableNumEntries := 0;
        end;
      end;
      BytesPerScanLine :=((((lpBitmapCoreInfo^.bmciHeader.bcWidth *
                           lpBitmapCoreInfo^.bmciHeader.bcBitCount)
                           + 31)
                           AND NOT 31)
                           div 8);
      BitsSize := BytesPerScanLine *
                  lpBitmapCoreInfo^.bmciHeader.bcHeight;
      result := sizeof(TBITMAPINFOHEADER) +
                (ColorTableNumEntries * sizeof(TRGBQUAD));
      exit;
    end else begin
      ColorTableNumEntries := 0;
      BitfieldNumEntries := 0;
      case lpBitmapInfo^.bmiHeader.biBitCount of
        1 : begin
          if (lpBitmapInfo^.bmiHeader.biClrUsed = 0) then begin
            ColorTableNumEntries := 2;
          end else begin
            ColorTableNumEntries := lpBitmapInfo^.bmiHeader.biClrUsed;
          end;
        end;
        4 : begin
          if (lpBitmapInfo^.bmiHeader.biClrUsed = 0) then begin
            ColorTableNumEntries := 16;
          end else begin
            ColorTableNumEntries := lpBitmapInfo^.bmiHeader.biClrUsed;
          end;
        end;
        8 : begin
          if (lpBitmapInfo^.bmiHeader.biClrUsed = 0) then begin
            ColorTableNumEntries := 256;
          end else begin
            ColorTableNumEntries := lpBitmapInfo^.bmiHeader.biClrUsed;
          end;
        end;
        16 : begin
          if (lpBitmapInfo^.bmiHeader.bicompression = BI_BITFIELDS) then begin
            BitfieldNumEntries := 3;
          end else begin
          end;
          ColorTableNumEntries := lpBitmapInfo^.bmiHeader.biClrUsed;
        end;
        24 : begin
          ColorTableNumEntries := lpBitmapInfo^.bmiHeader.biClrUsed;
        end;
        32 : begin
          if (lpBitmapInfo^.bmiHeader.bicompression = BI_BITFIELDS) then begin
            BitfieldNumEntries := 3;
          end;
          ColorTableNumEntries := lpBitmapInfo^.bmiHeader.biClrUsed;
        end;
      end;
      BytesPerScanLine :=((((lpBitmapInfo^.bmiHeader.biWidth *
                           lpBitmapInfo^.bmiHeader.biBitCount)
                           + 31)
                           AND NOT 31)
                           div 8);
      BitsSize := BytesPerScanLine *
                  ABS(lpBitmapInfo^.bmiHeader.biHeight);
      if (lpBitmapInfo^.bmiHeader.biHeight < 0) then begin
        IsDIBTopDown := TRUE;
      end;
      result := sizeof(TBITMAPINFOHEADER) +
                      (BitfieldNumEntries * sizeof(DWORD)) +
                      (ColorTableNumEntries * sizeof(TRGBQUAD));
      exit;
    end;
  except
  end;
end;


procedure CalcScanlineOffsets(Bits : pointer;
                             BitsSize : integer;
                             BytesPerScanLine : integer;
                             IsTopDown : BOOL;
                             var FirstScanline : pointer;
                             var ScanLineInc : integer);
begin
  if (IsTopDown) then begin
    FirstScanline := Bits;
    ScanLineInc := BytesPerScanLine;
  end else begin
    FirstScanline := pointer((DWORD(Bits) +
                              DWORD(BitsSize)) -
                              DWORD(BytesPerScanLine));
    ScanLineInc := -BytesPerScanLine;
  end;
end;


function ConvertOS2BibHeaderToWinDibHeader(lpSrcBitsInfo : PBITMAPCOREINFO;
                                           lpDstBitsInfo : PBITMAPINFO;
                                           ColorTableNumEntries : integer;
                                           BitsSize : integer) : BOOL;
var
  i : integer;
begin
  try
    lpDstBitsInfo^.bmiHeader.biSize := sizeof(TBITMAPINFOHEADER);
    lpDstBitsInfo^.bmiHeader.biWidth := lpSrcBitsInfo^.bmciHeader.bcWidth;
    lpDstBitsInfo^.bmiHeader.biHeight := lpSrcBitsInfo^.bmciHeader.bcHeight;
    lpDstBitsInfo^.bmiHeader.biPlanes := 1;
    lpDstBitsInfo^.bmiHeader.biBitCount := lpSrcBitsInfo^.bmciHeader.bcBitCount;
    lpDstBitsInfo^.bmiHeader.biCompression := BI_RGB;
    lpDstBitsInfo^.bmiHeader.biSizeImage := BitsSize;
    lpDstBitsInfo^.bmiHeader.biXPelsPerMeter := 0;
    lpDstBitsInfo^.bmiHeader.biYPelsPerMeter := 0;
    lpDstBitsInfo^.bmiHeader.biClrUsed := ColorTableNumEntries;
    lpDstBitsInfo^.bmiHeader.biClrImportant := ColorTableNumEntries;
    for i := 0 to (ColorTableNumEntries - 1) do begin
      lpDstBitsInfo^.bmiColors[i].rgbBlue := lpSrcBitsInfo^.bmciColors[i].rgbtBlue;
      lpDstBitsInfo^.bmiColors[i].rgbGreen := lpSrcBitsInfo^.bmciColors[i].rgbtGreen;
      lpDstBitsInfo^.bmiColors[i].rgbRed := lpSrcBitsInfo^.bmciColors[i].rgbtRed;
      lpDstBitsInfo^.bmiColors[i].rgbReserved := 0;
    end;
  except
    result := FALSE;
    exit;
  end;
  result := TRUE;
end;


function CustomFormTileCallbackFn(lpTileInfo : PTileRectInfo) : BOOL;
var
  cbInfo : PPaintControlTileCallbackInfo;
  WinChunkOffsetX : Extended;
  WinChunkOffsetY : Extended;
  i : integer;
  j : integer;
  bmiOut : PBitmapInfo;
  bmiOutBits : pointer;
  bmiOutScanLineInc : integer;
  bmiOutFirstScanLine : pointer;
  pOut : pointer;
  pIn : pointer;
  pxOut : pointer;
  pxIn : pointer;
  x : integer;
  NewPen : HPen;
  OldPen : HPen;
  scanlines : integer;
  MemDc : HDC;
  MemBitmap : HBitmap;
  OldBitmap : HBitmap;
begin
  result := FALSE;
  bmiOut := nil;
  bmiOutBits := nil;
  try
    cbInfo := lpTileInfo^.lpUserData;
    if (PRNDIB_DEBUG_BltCode <> PRNDIB_DEBUG_BLTCODE_OFF) then begin
      bmiOut := GetMemEx(cbInfo^.SrcBitmap.BitmapInfoSize);
      if (bmiOut = nil) then begin
        exit;
      end;
      Move(cbInfo^.SrcBitmap.lpBitsInfo^,
           bmiOut^,
           cbInfo^.SrcBitmap.BitmapInfoSize);
      bmiOut^.bmiHeader.biSize := sizeof(bmiOut^.bmiHeader);
      bmiOut^.bmiHeader.biWidth := lpTileInfo^.CurrentTileWidth div PRNDIB_OutputScaleFactorX;
      bmiOut^.bmiHeader.biHeight := lpTileInfo^.CurrentTileHeight div PRNDIB_OutputScaleFactorY;
      if (bmiOut^.bmiHeader.biWidth < 1) then begin
        bmiOut^.bmiHeader.biWidth := 1;
      end;
      if (bmiOut^.bmiHeader.biHeight < 1) then begin
        bmiOut^.bmiHeader.biHeight := 1;
      end;
      bmiOut^.bmiHeader.biPlanes := 1;
      bmiOut^.bmiHeader.biBitCount := cbInfo^.SrcBitmap.lpBitsInfo^.bmiHeader.biBitCount;
      bmiOut^.bmiHeader.biCompression := cbInfo^.SrcBitmap.lpBitsInfo^.bmiHeader.biCompression;
      bmiOutScanLineInc := -((((bmiOut^.bmiHeader.biWidth *
                                bmiOut^.bmiHeader.biBitCount)
                                + 31)
                                AND NOT 31)
                                div 8);
      bmiOut^.bmiHeader.biSizeImage := abs(bmiOutScanLineInc) *
                                      bmiOut^.bmiHeader.biHeight;
      bmiOut^.bmiHeader.biClrUsed := cbInfo^.SrcBitmap.lpBitsInfo^.bmiHeader.biClrUsed;
      bmiOut^.bmiHeader.biClrImportant := cbInfo^.SrcBitmap.lpBitsInfo^.bmiHeader.biClrImportant;
      bmiOutBits := GetMemEx(bmiOut^.bmiHeader.biSizeImage);
      if (bmiOutBits = nil) then begin
        FreeMemEx(bmiOut);
        exit;
      end;
      bmiOutFirstScanLine := Pointer((DWORD(bmiOutBits) +
                                      bmiOut^.bmiHeader.biSizeImage));
      inc(DWORD(bmiOutFirstScanLine),
                bmiOutScanLineInc);
      WinChunkOffsetx := (lpTileInfo^.CurrentTile.Left -
                          cbInfo^.DstRect.Left) * cbInfo^.iScaleX;
      WinChunkOffsety := (lpTileInfo^.CurrentTile.Top  -
                          cbInfo^.DstRect.Top) * cbInfo^.iScaleY;
      for i := 0 to (bmiOut^.bmiHeader.biHeight - 1) do begin
        pIn := cbInfo^.SrcBitmap.FirstScanLine;
        Inc(DWORD(pIn),
            (trunc( (cbInfo^.iScaleY * (i * PRNDIB_OutputScaleFactorY)) + WinChunkOffsety ) +
             cbInfo^.SrcRect.Top) *
            cbInfo^.SrcBitmap.ScanLineInc);
        pOut := bmiOutFirstScanLine;
        Inc(DWORD(pOut),
            i * bmiOutScanLineInc);
        case bmiOut^.bmiHeader.biBitCount of
          1 : begin
            for j := 0 to (bmiOut^.bmiHeader.biWidth - 1) do begin
              x := trunc((cbInfo^.iScaleX * (j * PRNDIB_OutputScaleFactorX)) + WinChunkOffsetx) +
                   cbInfo^.SrcRect.Left;
              PxIn := PIn;
              Inc(DWORD(PxIn),
                  (x div 8));
              PxOut := POut;
              Inc(DWORD(PxOut),
                  (j div 8));
              if ((PBYTE(PxIn)^ AND (1 SHL (7 - (x mod 8)))) <> 0) then begin
                PBYTE(PxOut)^ := PBYTE(PxOut)^ OR (1 shl (7 - (j mod 8)));
              end else begin
                PBYTE(PxOut)^ := PBYTE(PxOut)^ AND NOT (1 SHL (7 - (j mod 8)));
              end;
            end;  
          end;
          4 : begin
            for j := 0 to (bmiOut^.bmiHeader.biWidth - 1) do begin
              x := trunc((cbInfo^.iScaleX * (j * PRNDIB_OutputScaleFactorX)) + WinChunkOffsetx) +
                   cbInfo^.SrcRect.Left;
              PxIn := PIn;
              Inc(DWORD(PxIn),
                  (x div 2));
              PxOut := POut;
              Inc(DWORD(PxOut),
                  (j div 2));
              if ((Odd(j)) AND
                  (Odd(x))) then begin
                PBYTE(pXOut)^ := (PBYTE(pXOut)^ AND $F0) OR (PBYTE(pXIn)^ AND $0F);
                continue;
              end;
              if ((NOT Odd(j)) AND
                  (NOT Odd(x))) then begin
                PBYTE(pXOut)^ := (PBYTE(pXOut)^ AND $0F) OR (PBYTE(pXIn)^ AND $F0);
                continue;
              end;
              if ((Odd(j)) AND
                  (NOT Odd(x))) then begin
                PBYTE(pXOut)^ := (PBYTE(pXOut)^ AND $F0) OR (PBYTE(pXIn)^ SHR 4);
                continue;
              end;
              if ((NOT Odd(j)) AND
                  (Odd(x))) then begin
                PBYTE(pXOut)^ := (PBYTE(pXOut)^ AND $0F) OR (PBYTE(pXIn)^ SHL 4);
                continue;
              end;
            end;
          end;
          8 : begin
            for j := 0 to (bmiOut^.bmiHeader.biWidth - 1) do begin
              x := trunc((cbInfo^.iScaleX * (j * PRNDIB_OutputScaleFactorX)) + WinChunkOffsetx) +
                   cbInfo^.SrcRect.Left;
              PScanLine8(pOut)^[j] := PScanLine8(pIn)^[x];
            end;
          end;
          16 : begin
            for j := 0 to (bmiOut^.bmiHeader.biWidth - 1) do begin
              x := trunc((cbInfo^.iScaleX * (j * PRNDIB_OutputScaleFactorX)) + WinChunkOffsetx) +
                   cbInfo^.SrcRect.Left;
              PScanLine16(pOut)^[j] := PScanLine16(pIn)^[x];
            end;
          end;
          24 : begin
            for j := 0 to (bmiOut^.bmiHeader.biWidth - 1) do begin
              x := trunc((cbInfo^.iScaleX * (j * PRNDIB_OutputScaleFactorX)) + WinChunkOffsetx) +
                   cbInfo^.SrcRect.Left;
              PScanLine24(pOut)^[j] := PScanLine24(pIn)^[x];
            end;
          end;
          32 : begin
            for j := 0 to (bmiOut^.bmiHeader.biWidth - 1) do begin
              x := trunc((cbInfo^.iScaleX * (j * PRNDIB_OutputScaleFactorX)) + WinChunkOffsetx) +
                   cbInfo^.SrcRect.Left;
              PScanLine32(pOut)^[j] := PScanLine32(pIn)^[x];
            end;
          end;
        end;
        if (((i mod 64) = 0) AND
            (@cbInfo^.OnAppCallbackFn <> nil) AND
            (NOT cbInfo^.OnAppCallbackFn(lpTileInfo^.CurrentTileNumber,
                                         lpTileInfo^.TotalTiles,
                                         cbInfo^.OnAppCallbackData))) then begin
          FreeMemEx(bmiOutBits);
          FreeMemEx(bmiOut);
          exit;
        end;
      end;
      scanlines := 0;
      if (PRNDIB_DEBUG_Blt <> PRNDIB_DEBUG_BLT_OFF) then begin
        if (cbInfo^.UseDDB = FALSE) then begin
          scanlines := StretchDIBits(cbInfo^.dc,
                            lpTileInfo^.CurrentTile.Left,
                            lpTileInfo^.CurrentTile.Top,
                            bmiOut^.bmiHeader.biWidth * PRNDIB_OutputScaleFactorX,
                            abs(bmiOut^.bmiHeader.biHeight * PRNDIB_OutputScaleFactorY),
                            0,
                            0,
                            bmiOut^.bmiHeader.biWidth,
                            abs(bmiOut^.bmiHeader.biHeight),
                            bmiOutBits,
                            bmiOut^,
                            DIB_RGB_COLORS,
                            SRCCOPY);
          if (scanlines <> abs(bmiOut^.bmiHeader.biHeight)) then begin
            if (PRNDIB_DEBUG_AutoUse_DDB = PRNDIB_DEBUG_AUTOUSE_DDB_ON) then begin
              cbInfo^.UseDDB := TRUE;
              if (PRNDIB_DEBUG_Msg <> PRNDIB_DEBUG_MSG_OFF) then begin
                if ((PRNDIB_OutputScaleFactorX = 1) AND
                    (PRNDIB_OutputScaleFactorY = 1)) then begin
                  MessageBox(PRNDIB_DEBUG_Abort_Dialog_Handle,
                             'StretchDIBits failed! Trying BitBlt',
                             'TExcellentImagePrinter',
                             MB_OK);
                end else begin
                  MessageBox(PRNDIB_DEBUG_Abort_Dialog_Handle,
                             'StretchDIBits failed! Trying StretchBlt',
                             'TExcellentImagePrinter',
                             MB_OK);
                end;
              end;
            end else begin
              if (PRNDIB_DEBUG_Msg <> PRNDIB_DEBUG_MSG_OFF) then begin
                MessageBox(PRNDIB_DEBUG_Abort_Dialog_Handle,
                           'StretchDIBits failed',
                           'TExcellentImagePrinter',
                           MB_OK);
              end;
            end;
          end;
        end;
        if (cbInfo^.UseDDB <> FALSE) then begin
          memdc := CreateCompatibleDc(cbInfo^.dc);
          membitmap := CreateDIBitmap(cbInfo^.dc,
                                      TBitmapInfoHeader(pointer(bmiOut)^),
                                      CBM_INIT,
                                      bmiOutBits,
                                      bmiOut^,
                                      DIB_RGB_COLORS);
          oldbitmap := SelectObject(memdc,
                                    membitmap);
          if ((PRNDIB_OutputScaleFactorX = 1) AND
              (PRNDIB_OutputScaleFactorY = 1)) then begin
            if (BitBlt(cbInfo^.dc,
                       lpTileInfo^.CurrentTile.Left,
                       lpTileInfo^.CurrentTile.Top,
                       bmiOut^.bmiHeader.biWidth,
                       abs(bmiOut^.bmiHeader.biHeight),
                       memdc,
                       0,
                       0,
                       SRCCOPY) <> FALSE) then begin
              scanlines := abs(bmiOut^.bmiHeader.biHeight);
            end else begin
              if (PRNDIB_DEBUG_Msg <> PRNDIB_DEBUG_MSG_OFF) then begin
                MessageBox(PRNDIB_DEBUG_Abort_Dialog_Handle, 'BitBlt failed', 'TExcellentImagePrinter', MB_OK);
              end;
              scanlines := 0;
            end;
          end else begin
            if (StretchBlt(cbInfo^.dc,
                           lpTileInfo^.CurrentTile.Left,
                           lpTileInfo^.CurrentTile.Top,
                           (bmiOut^.bmiHeader.biWidth * PRNDIB_OutputScaleFactorX),
                           abs(bmiOut^.bmiHeader.biHeight * PRNDIB_OutputScaleFactorY),
                           memdc,
                           0,
                           0,
                           bmiOut^.bmiHeader.biWidth,
                           abs(bmiOut^.bmiHeader.biHeight),
                           SRCCOPY) <> FALSE) then begin
              scanlines := abs(bmiOut^.bmiHeader.biHeight);
            end else begin
              if (PRNDIB_DEBUG_Msg <> PRNDIB_DEBUG_MSG_OFF) then begin
                MessageBox(PRNDIB_DEBUG_Abort_Dialog_Handle, 'StretchBlt failed', 'TExcellentImagePrinter', MB_OK);
              end;
              scanlines := 0;
            end;
          end;
          SelectObject(memdc, oldbitmap);
          DeleteObject(membitmap);
          DeleteDc(MemDc);
        end;
        if (PRNDIB_DEBUG_Sleep_Value > -1) then begin
          Sleep(PRNDIB_DEBUG_Sleep_Value);
        end;
        if (scanlines <> abs(bmiOut^.bmiHeader.biHeight)) then begin
          if (PRNDIB_DEBUG_GdiFlush <> PRNDIB_DEBUG_GDIFLUSH_OFF) then begin
            GdiFlush;
          end;
          FreeMemEx(bmiOutBits);
          bmiOutBits := nil;
          FreeMemEx(bmiOut);
          bmiOut := nil;
          exit;
        end;
      end;
    end; {(PRNDIB_DEBUG_Blt <> PRNDIB_DEBUG_BLT_NOBLTCODE)}

    {PRNDIB_DEBUG_Frames := PRNDIB_DEBUG_FRAMES_ON;}

    if (PRNDIB_DEBUG_Frames = PRNDIB_DEBUG_FRAMES_ON) then begin
      i := Trunc((GetDeviceCaps(cbInfo^.dc,
                  LOGPIXELSX) / 72) * 0.5);
      j := Trunc((GetDeviceCaps(cbInfo^.dc,
                  LOGPIXELSY) / 72) * 0.5);
      if (i < 1) then begin
        i := 1;
      end;
      if (j < 1) then begin
        j := 1;
      end;
      if (i > j) then begin
        NewPen := CreatePen(PS_SOLID,
                            i,
                            RGB(0, 0, 0));
      end else begin
        NewPen := CreatePen(PS_SOLID,
                            j,
                            RGB(0, 0, 0));
      end;
      OldPen := SelectObject(cbInfo^.dc,
                             NewPen);
      i := lpTileInfo^.CurrentTile.Left + ((lpTileInfo^.CurrentTile.Right - lpTileInfo^.CurrentTile.Left) div 2);
      j := lpTileInfo^.CurrentTile.Top + ((lpTileInfo^.CurrentTile.Bottom - lpTileInfo^.CurrentTile.Top) div 2);
      if (
          (NOT MoveToEx(cbInfo^.dc,
                         lpTileInfo^.CurrentTile.Left,
                         j,
                         nil)) OR
          (NOT LineTo(cbInfo^.dc,
                      lpTileInfo^.CurrentTile.Right,
                      j)) OR
          (NOT MoveToEx(cbInfo^.dc,
                       i,
                       lpTileInfo^.CurrentTile.Top,
                       nil)) OR
          (NOT LineTo(cbInfo^.dc,
                      i,
                      lpTileInfo^.CurrentTile.Bottom))
         ) then begin
        if (PRNDIB_DEBUG_Msg <> PRNDIB_DEBUG_MSG_OFF) then begin
          MessageBox(PRNDIB_DEBUG_Abort_Dialog_Handle, 'Frames failed', 'TExcellentImagePrinter', MB_OK);
        end;
      end;
      SelectObject(cbInfo^.dc,
                   OldPen);
      DeleteObject(NewPen);
    end;
    if (PRNDIB_DEBUG_GdiFlush <> PRNDIB_DEBUG_GDIFLUSH_OFF) then begin
      GdiFlush;
    end;
    FreeMemEx(bmiOutBits);
    bmiOutBits := nil;
    FreeMemEx(bmiOut);
    bmiOut := nil;
    if ((@cbInfo^.OnAppCallbackFn <> nil) AND
        (NOT cbInfo^.OnAppCallbackFn(lpTileInfo^.CurrentTileNumber,
                                     lpTileInfo^.TotalTiles,
                                     cbInfo^.OnAppCallbackData))) then begin
      exit;
    end;
  except
    if (PRNDIB_DEBUG_Msg <> PRNDIB_DEBUG_MSG_OFF) then begin
       MessageBox(PRNDIB_DEBUG_Abort_Dialog_Handle, 'CustomFormTileCallbackFn Exception', 'TExcellentImagePrinter', MB_OK);
    end;
    if (bmiOutBits <> nil) then begin
      FreeMemEx(bmiOutBits);
    end;
    if (bmiOut <> nil) then begin
      FreeMemEx(bmiOut);
    end;
    exit;
  end;
  result := TRUE;
end;



function CustomFormTileCallbackFn2(lpTileInfo : PTileRectInfo) : BOOL;
var
  cbInfo : PPaintControlTileCallbackInfo;
  WinChunkOffsetX : integer;
  WinChunkOffsetY : integer;
  i : integer;
  j : integer;
  bmiOut : PBitmapInfo;
  bmiOutBits : pointer;
  bmiOutScanLineInc : integer;
  bmiOutFirstScanLine : pointer;
  pOut : pointer;
  pIn : pointer;
  pxOut : pointer;
  pxIn : pointer;
  x : integer;
  NewPen : HPen;
  OldPen : HPen;
  scanlines : integer;
  MemDc : HDC;
  MemBitmap : HBitmap;
  OldBitmap : HBitmap;
begin
  result := FALSE;
  bmiOut := nil;
  bmiOutBits := nil;
  try
    cbInfo := lpTileInfo^.lpUserData;
    if (PRNDIB_DEBUG_BltCode <> PRNDIB_DEBUG_BLTCODE_OFF) then begin
      bmiOut := GetMemEx(cbInfo^.SrcBitmap.BitmapInfoSize);
      if (bmiOut = nil) then begin
        exit;
      end;
      Move(cbInfo^.SrcBitmap.lpBitsInfo^,
           bmiOut^,
           cbInfo^.SrcBitmap.BitmapInfoSize);
      bmiOut^.bmiHeader.biSize := sizeof(bmiOut^.bmiHeader);
      bmiOut^.bmiHeader.biWidth := trunc((lpTileInfo^.CurrentTileWidth * cbInfo^.iScaleX) / PRNDIB_OutputScaleFactorX);
      bmiOut^.bmiHeader.biHeight := trunc((lpTileInfo^.CurrentTileHeight * cbInfo^.iScaleY) / PRNDIB_OutputScaleFactorY);
      if (bmiOut^.bmiHeader.biWidth < 1) then begin
        bmiOut^.bmiHeader.biWidth := 1;
      end;
      if (bmiOut^.bmiHeader.biHeight < 1) then begin
        bmiOut^.bmiHeader.biHeight := 1;
      end;
      bmiOut^.bmiHeader.biPlanes := 1;
      bmiOut^.bmiHeader.biBitCount := cbInfo^.SrcBitmap.lpBitsInfo^.bmiHeader.biBitCount;
      bmiOut^.bmiHeader.biCompression := cbInfo^.SrcBitmap.lpBitsInfo^.bmiHeader.biCompression;
      bmiOutScanLineInc := -((((bmiOut^.bmiHeader.biWidth *
                                bmiOut^.bmiHeader.biBitCount)
                                + 31)
                                AND NOT 31)
                                div 8);
      bmiOut^.bmiHeader.biSizeImage := abs(bmiOutScanLineInc) *
                                      bmiOut^.bmiHeader.biHeight;
      bmiOut^.bmiHeader.biClrUsed := cbInfo^.SrcBitmap.lpBitsInfo^.bmiHeader.biClrUsed;
      bmiOut^.bmiHeader.biClrImportant := cbInfo^.SrcBitmap.lpBitsInfo^.bmiHeader.biClrImportant;
      bmiOutBits := GetMemEx(bmiOut^.bmiHeader.biSizeImage);
      if (bmiOutBits = nil) then begin
        FreeMemEx(bmiOut);
        exit;
      end;
      bmiOutFirstScanLine := Pointer((DWORD(bmiOutBits) +
                                      bmiOut^.bmiHeader.biSizeImage));
      inc(DWORD(bmiOutFirstScanLine),
                bmiOutScanLineInc);
      WinChunkOffsetx := Trunc((lpTileInfo^.CurrentTile.Left -
                           cbInfo^.DstRect.Left) * cbInfo^.iScaleX);
      WinChunkOffsety := Trunc((lpTileInfo^.CurrentTile.Top  -
                           cbInfo^.DstRect.Top) * cbInfo^.iScaleY);

      for i := 0 to (bmiOut^.bmiHeader.biHeight - 1) do begin
        pIn := cbInfo^.SrcBitmap.FirstScanLine;
        Inc(DWORD(pIn),
            (((i * PRNDIB_OutputScaleFactorY) + WinChunkOffsety) +
             cbInfo^.SrcRect.Top) *
            cbInfo^.SrcBitmap.ScanLineInc);

        pOut := bmiOutFirstScanLine;
        Inc(DWORD(pOut),
            i * bmiOutScanLineInc);
        case bmiOut^.bmiHeader.biBitCount of
          1 : begin
            for j := 0 to (bmiOut^.bmiHeader.biWidth - 1) do begin
              x := (j * PRNDIB_OutputScaleFactorX) +
                   WinChunkOffsetx +
                   cbInfo^.SrcRect.Left;
              PxIn := PIn;
              Inc(DWORD(PxIn),
                  (x div 8));
              PxOut := POut;
              Inc(DWORD(PxOut),
                  (j div 8));
              if ((PBYTE(PxIn)^ AND (1 SHL (7 - (x mod 8)))) <> 0) then begin
                PBYTE(PxOut)^ := PBYTE(PxOut)^ OR (1 shl (7 - (j mod 8)));
              end else begin
                PBYTE(PxOut)^ := PBYTE(PxOut)^ AND NOT (1 SHL (7 - (j mod 8)));
              end;
            end;  
          end;
          4 : begin
            for j := 0 to (bmiOut^.bmiHeader.biWidth - 1) do begin
              x := (j * PRNDIB_OutputScaleFactorX) +
                   WinChunkOffsetx +
                   cbInfo^.SrcRect.Left;
              PxIn := PIn;
              Inc(DWORD(PxIn),
                  (x div 2));
              PxOut := POut;
              Inc(DWORD(PxOut),
                  (j div 2));
              if ((Odd(j)) AND
                  (Odd(x))) then begin
                PBYTE(pXOut)^ := (PBYTE(pXOut)^ AND $F0) OR (PBYTE(pXIn)^ AND $0F);
                continue;
              end;
              if ((NOT Odd(j)) AND
                  (NOT Odd(x))) then begin
                PBYTE(pXOut)^ := (PBYTE(pXOut)^ AND $0F) OR (PBYTE(pXIn)^ AND $F0);
                continue;
              end;
              if ((Odd(j)) AND
                  (NOT Odd(x))) then begin
                PBYTE(pXOut)^ := (PBYTE(pXOut)^ AND $F0) OR (PBYTE(pXIn)^ SHR 4);
                continue;
              end;
              if ((NOT Odd(j)) AND
                  (Odd(x))) then begin
                PBYTE(pXOut)^ := (PBYTE(pXOut)^ AND $0F) OR (PBYTE(pXIn)^ SHL 4);
                continue;
              end;
            end;
          end;
          8 : begin
            for j := 0 to (bmiOut^.bmiHeader.biWidth - 1) do begin
              x := (j * PRNDIB_OutputScaleFactorX) +
                   WinChunkOffsetx +
                   cbInfo^.SrcRect.Left;
              PScanLine8(pOut)^[j] := PScanLine8(pIn)^[x];
            end;
          end;
          16 : begin
            for j := 0 to (bmiOut^.bmiHeader.biWidth - 1) do begin
              x := (j * PRNDIB_OutputScaleFactorX) +
                   WinChunkOffsetx +
                   cbInfo^.SrcRect.Left;
              PScanLine16(pOut)^[j] := PScanLine16(pIn)^[x];
            end;
          end;
          24 : begin
            for j := 0 to (bmiOut^.bmiHeader.biWidth - 1) do begin
              x := (j * PRNDIB_OutputScaleFactorX) +
                   WinChunkOffsetx +
                   cbInfo^.SrcRect.Left;
              PScanLine24(pOut)^[j] := PScanLine24(pIn)^[x];
            end;
          end;
          32 : begin
            for j := 0 to (bmiOut^.bmiHeader.biWidth - 1) do begin
              x := (j * PRNDIB_OutputScaleFactorX) +
                   WinChunkOffsetx +
                   cbInfo^.SrcRect.Left;
              PScanLine32(pOut)^[j] := PScanLine32(pIn)^[x];
            end;
          end;
        end;
        if (((i mod 64) = 0) AND
            (@cbInfo^.OnAppCallbackFn <> nil) AND
            (NOT cbInfo^.OnAppCallbackFn(lpTileInfo^.CurrentTileNumber,
                                         lpTileInfo^.TotalTiles,
                                         cbInfo^.OnAppCallbackData))) then begin
          FreeMemEx(bmiOutBits);
          FreeMemEx(bmiOut);
          exit;
        end;
      end;
      scanlines := 0;
      if (PRNDIB_DEBUG_Blt <> PRNDIB_DEBUG_BLT_OFF) then begin
        if (cbInfo^.UseDDB = FALSE) then begin
          scanlines := StretchDIBits(cbInfo^.dc,
                            lpTileInfo^.CurrentTile.Left,
                            lpTileInfo^.CurrentTile.Top,
                            lpTileInfo^.CurrentTile.Right - lpTileInfo^.CurrentTile.Left,
                            lpTileInfo^.CurrentTile.Bottom - lpTileInfo^.CurrentTile.Top,
                            0,
                            0,
                            bmiOut^.bmiHeader.biWidth,
                            abs(bmiOut^.bmiHeader.biHeight),
                            bmiOutBits,
                            bmiOut^,
                            DIB_RGB_COLORS,
                            SRCCOPY);
          if (scanlines <> abs(bmiOut^.bmiHeader.biHeight)) then begin
            if (PRNDIB_DEBUG_AutoUse_DDB = PRNDIB_DEBUG_AUTOUSE_DDB_ON) then begin
              cbInfo^.UseDDB := TRUE;
              if (PRNDIB_DEBUG_Msg <> PRNDIB_DEBUG_MSG_OFF) then begin
                if ((PRNDIB_OutputScaleFactorX = 1) AND
                    (PRNDIB_OutputScaleFactorY = 1)) then begin
                  MessageBox(PRNDIB_DEBUG_Abort_Dialog_Handle,
                             'StretchDIBits failed! Trying BitBlt',
                             'TExcellentImagePrinter',
                             MB_OK);
                end else begin
                  MessageBox(PRNDIB_DEBUG_Abort_Dialog_Handle,
                             'StretchDIBits failed! Trying StretchBlt',
                             'TExcellentImagePrinter',
                             MB_OK);
                end;
              end;
            end else begin
              if (PRNDIB_DEBUG_Msg <> PRNDIB_DEBUG_MSG_OFF) then begin
                MessageBox(PRNDIB_DEBUG_Abort_Dialog_Handle,
                           'StretchDIBits failed',
                           'TExcellentImagePrinter',
                           MB_OK);
              end;
            end;
          end;
        end;
        if (cbInfo^.UseDDB <> FALSE) then begin
          memdc := CreateCompatibleDc(cbInfo^.dc);
          membitmap := CreateDIBitmap(cbInfo^.dc,
                                      TBitmapInfoHeader(pointer(bmiOut)^),
                                      CBM_INIT,
                                      bmiOutBits,
                                      bmiOut^,
                                      DIB_RGB_COLORS);
          oldbitmap := SelectObject(memdc,
                                    membitmap);
          if ((PRNDIB_OutputScaleFactorX = 1) AND
              (PRNDIB_OutputScaleFactorY = 1) AND
              ((lpTileInfo^.CurrentTile.Right - lpTileInfo^.CurrentTile.Left) = bmiOut^.bmiHeader.biWidth) AND
              ((lpTileInfo^.CurrentTile.Bottom - lpTileInfo^.CurrentTile.Top) = abs(bmiOut^.bmiHeader.biHeight))) then begin
            if (BitBlt(cbInfo^.dc,
                       lpTileInfo^.CurrentTile.Left,
                       lpTileInfo^.CurrentTile.Top,
                       lpTileInfo^.CurrentTile.Right - lpTileInfo^.CurrentTile.Left,
                       lpTileInfo^.CurrentTile.Bottom - lpTileInfo^.CurrentTile.Top,
                       memdc,
                       0,
                       0,
                       SRCCOPY) <> FALSE) then begin
              scanlines := abs(bmiOut^.bmiHeader.biHeight);
            end else begin
              if (PRNDIB_DEBUG_Msg <> PRNDIB_DEBUG_MSG_OFF) then begin
                MessageBox(PRNDIB_DEBUG_Abort_Dialog_Handle, 'BitBlt failed', 'TExcellentImagePrinter', MB_OK);
              end;
              scanlines := 0;
            end;
          end else begin
            if (StretchBlt(cbInfo^.dc,
                           lpTileInfo^.CurrentTile.Left,
                           lpTileInfo^.CurrentTile.Top,
                           lpTileInfo^.CurrentTile.Right - lpTileInfo^.CurrentTile.Left,
                           lpTileInfo^.CurrentTile.Bottom - lpTileInfo^.CurrentTile.Top,
                           memdc,
                           0,
                           0,
                           bmiOut^.bmiHeader.biWidth,
                           abs(bmiOut^.bmiHeader.biHeight),
                           SRCCOPY) <> FALSE) then begin
              scanlines := abs(bmiOut^.bmiHeader.biHeight);
            end else begin
              if (PRNDIB_DEBUG_Msg <> PRNDIB_DEBUG_MSG_OFF) then begin
                MessageBox(PRNDIB_DEBUG_Abort_Dialog_Handle, 'StretchBlt failed', 'TExcellentImagePrinter', MB_OK);
              end;
              scanlines := 0;
            end;
          end;
          SelectObject(memdc, oldbitmap);
          DeleteObject(membitmap);
          DeleteDc(MemDc);
        end;
        if (PRNDIB_DEBUG_Sleep_Value > -1) then begin
          Sleep(PRNDIB_DEBUG_Sleep_Value);
        end;
        if (scanlines <> abs(bmiOut^.bmiHeader.biHeight)) then begin
          if (PRNDIB_DEBUG_GdiFlush <> PRNDIB_DEBUG_GDIFLUSH_OFF) then begin
            GdiFlush;
          end;
          FreeMemEx(bmiOutBits);
          bmiOutBits := nil;
          FreeMemEx(bmiOut);
          bmiOut := nil;
          exit;
        end;
      end;
    end; {(PRNDIB_DEBUG_Blt <> PRNDIB_DEBUG_BLT_NOBLTCODE)}

    {PRNDIB_DEBUG_Frames := PRNDIB_DEBUG_FRAMES_ON;}

    if (PRNDIB_DEBUG_Frames = PRNDIB_DEBUG_FRAMES_ON) then begin
      i := Trunc((GetDeviceCaps(cbInfo^.dc,
                  LOGPIXELSX) / 72) * 0.5);
      j := Trunc((GetDeviceCaps(cbInfo^.dc,
                  LOGPIXELSY) / 72) * 0.5);
      if (i < 1) then begin
        i := 1;
      end;
      if (j < 1) then begin
        j := 1;
      end;
      if (i > j) then begin
        NewPen := CreatePen(PS_SOLID,
                            i,
                            RGB(0, 0, 0));
      end else begin
        NewPen := CreatePen(PS_SOLID,
                            j,
                            RGB(0, 0, 0));
      end;
      OldPen := SelectObject(cbInfo^.dc,
                             NewPen);
      i := lpTileInfo^.CurrentTile.Left + ((lpTileInfo^.CurrentTile.Right - lpTileInfo^.CurrentTile.Left) div 2);
      j := lpTileInfo^.CurrentTile.Top + ((lpTileInfo^.CurrentTile.Bottom - lpTileInfo^.CurrentTile.Top) div 2);
      if (
          (NOT MoveToEx(cbInfo^.dc,
                         lpTileInfo^.CurrentTile.Left,
                         j,
                         nil)) OR
          (NOT LineTo(cbInfo^.dc,
                      lpTileInfo^.CurrentTile.Right,
                      j)) OR
          (NOT MoveToEx(cbInfo^.dc,
                       i,
                       lpTileInfo^.CurrentTile.Top,
                       nil)) OR
          (NOT LineTo(cbInfo^.dc,
                      i,
                      lpTileInfo^.CurrentTile.Bottom))
         ) then begin
        if (PRNDIB_DEBUG_Msg <> PRNDIB_DEBUG_MSG_OFF) then begin
          MessageBox(PRNDIB_DEBUG_Abort_Dialog_Handle, 'Frames failed', 'TExcellentImagePrinter', MB_OK);
        end;
      end;
      SelectObject(cbInfo^.dc,
                   OldPen);
      DeleteObject(NewPen);
    end;
    if (PRNDIB_DEBUG_GdiFlush <> PRNDIB_DEBUG_GDIFLUSH_OFF) then begin
      GdiFlush;
    end;
    FreeMemEx(bmiOutBits);
    bmiOutBits := nil;
    FreeMemEx(bmiOut);
    bmiOut := nil;
    if ((@cbInfo^.OnAppCallbackFn <> nil) AND
        (NOT cbInfo^.OnAppCallbackFn(lpTileInfo^.CurrentTileNumber,
                                     lpTileInfo^.TotalTiles,
                                     cbInfo^.OnAppCallbackData))) then begin
      exit;
    end;
  except
    if (PRNDIB_DEBUG_Msg <> PRNDIB_DEBUG_MSG_OFF) then begin
       MessageBox(PRNDIB_DEBUG_Abort_Dialog_Handle, 'CustomFormTileCallbackFn Exception', 'TExcellentImagePrinter', MB_OK);
    end;
    if (bmiOutBits <> nil) then begin
      FreeMemEx(bmiOutBits);
    end;
    if (bmiOut <> nil) then begin
      FreeMemEx(bmiOut);
    end;
    exit;
  end;
  result := TRUE;
end;




function IsPaletteDevice(dc : HDC) : BOOL; stdcall;
var
  adc : hdc;
begin
  if (dc = 0) then begin
    adc := GetDc(0);
  end else begin
    adc := dc;
  end;
  result := ((GetDeviceCaps(adc, BITSPIXEL) *
              GetDeviceCaps(adc, PLANES) <= 8) AND
             ((GetDeviceCaps(adc, RC_PALETTE) AND RC_PALETTE) = RC_PALETTE));

  if (dc = 0) then begin
    ReleaseDc(0, adc);
  end;
end;


function CreateDIBPalette(lpBitmapInfo : pointer) : HPALETTE; stdcall;
var
  TheBitmapInfo : PBITMAPINFO;
  TheBitmapCoreInfo : PBITMAPCOREINFO;
  ppal : PLOGPALETTE;
  ColorTableNumEntries : integer;
  ColorTableOffset: integer;
  lpRgbQuadColorTable : PRGBQUADCOLORTABLE;
  lpRgbTripleColorTable : PRGBTRIPLECOLORTABLE;
  i : integer;
begin
  result := 0;
  if (lpBitMapInfo = nil) then begin
    exit;
  end;
  ppal := nil;
  try
    TheBitMapInfo := lpBitMapInfo;
    ColorTableOffset := 0;
    if (TheBitMapInfo^.bmiHeader.biSize = sizeof(TBITMAPINFOHEADER)) then begin
      case (TheBitMapInfo^.bmiHeader.biBitCount) of
        1 : begin
          if (TheBitMapInfo^.bmiHeader.biClrUsed = 0) then begin
            ColorTableNumEntries := 2;
          end else begin
            ColorTableNumEntries := TheBitMapInfo^.bmiHeader.biClrUsed;
          end;
        end;
        4 : begin
          if (TheBitMapInfo^.bmiHeader.biClrUsed = 0) then begin
            ColorTableNumEntries := 16;
          end else begin
            ColorTableNumEntries := TheBitMapInfo^.bmiHeader.biClrUsed;
          end;
        end;
        8 : begin
          if (TheBitMapInfo^.bmiHeader.biClrUsed = 0) then begin
            ColorTableNumEntries := 256;
          end else begin
            ColorTableNumEntries := TheBitMapInfo^.bmiHeader.biClrUsed;
          end;
        end;
        16 : begin
          if (TheBitMapInfo^.bmiHeader.biClrUsed = 0) then begin
            ColorTableNumEntries := 0;
          end else begin
            ColorTableNumEntries := TheBitMapInfo^.bmiHeader.biClrUsed;
          end;
          ColorTableOffset := 3 * sizeof(DWORD);
        end;
        24 : begin
          if (TheBitMapInfo^.bmiHeader.biClrUsed = 0) then begin
            ColorTableNumEntries := 0;
          end else begin
            ColorTableNumEntries := TheBitMapInfo^.bmiHeader.biClrUsed;
          end;
        end;
        32 : begin
          if (TheBitMapInfo^.bmiHeader.biClrUsed = 0) then begin
            ColorTableNumEntries := 0;
          end else begin
            ColorTableNumEntries := TheBitMapInfo^.bmiHeader.biClrUsed;
          end;
          ColorTableOffset := 3 * sizeof(DWORD);
        end else begin
          exit;
        end;
      end;
      if (ColorTableNumEntries = 0) then begin
        exit;
      end;
      if (ColorTableOffset = 0) then begin
        lpRgbQuadColorTable := @TheBitMapInfo^.bmiColors;
      end else begin
        lpRgbQuadColorTable := Pointer(DWORD(@TheBitMapInfo^.bmiColors) +
                                       DWORD(ColorTableOffset));
      end;
      ppal := GetMemEx(sizeof(TLOGPALETTE) +
                      (sizeof(TPALETTEENTRY) * ColorTableNumEntries));
      if (pPal = nil) then begin
        exit;
      end;
      for i := 0 to (ColorTableNumEntries - 1) do begin
        ppal^.palPalEntry[i].peRed := lpRgbQuadColorTable^[i].rgbRed;
        ppal^.palPalEntry[i].peGreen := lpRgbQuadColorTable^[i].rgbGreen;
        ppal^.palPalEntry[i].peBlue := lpRgbQuadColorTable^[i].rgbBlue;
        ppal^.palPalEntry[i].peFlags := 0;
      end;
      ppal^.palVersion := $300;
      ppal^.palNumEntries := ColorTableNumEntries;
      Result := CreatePalette(ppal^);
      FreeMemEx(ppal);
      exit;
    end;
    TheBitmapCoreInfo := lpBitMapInfo;
    if (TheBitmapCoreInfo^.bmciHeader.bcSize = sizeof(TBITMAPCOREHEADER)) then begin
      case (TheBitmapCoreInfo^.bmciHeader.bcBitCount) of
        1 : begin
          ColorTableNumEntries := 2;
        end;
        4 : begin
          ColorTableNumEntries := 16;
        end;
        8 : begin
          ColorTableNumEntries := 256;
        end;
        24 : begin
         ColorTableNumEntries := 0;
        end else begin
          exit;
        end;
      end;
      if (ColorTableNumEntries = 0) then begin
        exit;
      end;
      lpRgbTripleColorTable := @TheBitmapCoreInfo^.bmciColors;
      ppal := GetMemEx(sizeof(TLOGPALETTE) +
                       (sizeof(TPALETTEENTRY) * ColorTableNumEntries));
      if (pPal = nil) then begin
        exit;
      end;
      for i := 0 to (ColorTableNumEntries - 1) do begin
        ppal^.palPalEntry[i].peRed := lpRgbTripleColorTable^[i].rgbtRed;
        ppal^.palPalEntry[i].peGreen := lpRgbTripleColorTable^[i].rgbtGreen;
        ppal^.palPalEntry[i].peBlue := lpRgbTripleColorTable^[i].rgbtBlue;
        ppal^.palPalEntry[i].peFlags := 0;
      end;
      ppal^.palVersion := $300;
      ppal^.palNumEntries := ColorTableNumEntries;
      Result := CreatePalette(ppal^);
      FreeMemEx(ppal);
      exit;
    end;
  except
    if (ppal <> nil) then begin
      FreeMemEx(ppal);
    end;
    exit;
  end;
end;

type
  PPrnPageInfo = ^TPrnPageInfo;
  TPrnPageInfo = packed record
    Margin : TRect;                { normal margins to printing area }
    PageSize : TPoint;             { normal page (paper) size }
    PageArea : TPoint;             { normal page image size }
    AdjustedMargin : TRect;        { adjusted margins (equal on all sizes) }
    AdjustedPageArea : TPoint;     { page image size adjusted for equal margins }
    AdjustedMarginOffset : TPoint; { amount to offset output for adjusted margins }
    DPI : TPoint;                  { pixels per inch }
  end;


function GetPrnPageInfo(dc : HDC;
                        lpPrnPageInfo : PPrnPageInfo) : BOOL; stdcall;
var
  Max : integer;
begin
  result := FALSE;
  if (lpPrnPageInfo = nil) then begin
    exit;
  end;
  try
    lpPrnPageInfo^.Margin.Left := GetDeviceCaps(dc,
                                                PHYSICALOFFSETX);
    lpPrnPageInfo^.Margin.Top := GetDeviceCaps(dc,
                                               PHYSICALOFFSETY);
    lpPrnPageInfo^.PageSize.x := GetDeviceCaps(dc,
                                               PHYSICALWIDTH);
    lpPrnPageInfo^.PageSize.y := GetDeviceCaps(dc,
                                               PHYSICALHEIGHT);
    lpPrnPageInfo^.PageArea.x := GetDeviceCaps(dc,
                                               HORZRES);
    lpPrnPageInfo^.PageArea.y := GetDeviceCaps(dc,
                                                VERTRES);
    if (lpPrnPageInfo^.PageSize.x = 0) then begin
      lpPrnPageInfo^.PageSize.x := lpPrnPageInfo^.PageArea.x;
    end;                                                
    if (lpPrnPageInfo^.PageSize.y = 0) then begin
      lpPrnPageInfo^.PageSize.y := lpPrnPageInfo^.PageArea.y;
    end;
    if (NOT Win32Platform = VER_PLATFORM_WIN32_NT) then begin
      while (lpPrnPageInfo^.PageArea.x > 32000) do begin
        Dec(lpPrnPageInfo^.PageArea.x);
      end;
      while (lpPrnPageInfo^.PageArea.y > 32000) do begin
        Dec(lpPrnPageInfo^.PageArea.y);
      end;
    end;
    lpPrnPageInfo^.Margin.Right := (lpPrnPageInfo^.PageSize.x -
                                    lpPrnPageInfo^.PageArea.x) -
                                    lpPrnPageInfo^.Margin.Left;
    lpPrnPageInfo^.Margin.Bottom := (lpPrnPageInfo^.PageSize.y -
                                     lpPrnPageInfo^.PageArea.y) -
                                     lpPrnPageInfo^.Margin.Top;
    if (lpPrnPageInfo^.Margin.Right > lpPrnPageInfo^.Margin.Left) then begin
      Max := lpPrnPageInfo^.Margin.Right;
    end else begin
      Max := lpPrnPageInfo^.Margin.Left;
    end;
    if (lpPrnPageInfo^.Margin.Top > Max) then begin
      Max := lpPrnPageInfo^.Margin.Top;
    end;
    if (lpPrnPageInfo^.Margin.Bottom > Max) then begin
      Max := lpPrnPageInfo^.Margin.Bottom;
    end;
    lpPrnPageInfo^.AdjustedMargin.Left := Max;
    lpPrnPageInfo^.AdjustedMargin.Top := Max;
    lpPrnPageInfo^.AdjustedMargin.Right := Max;
    lpPrnPageInfo^.AdjustedMargin.Bottom := Max;
    lpPrnPageInfo^.AdjustedMarginOffset.x := Max - lpPrnPageInfo^.Margin.Left;
    lpPrnPageInfo^.AdjustedMarginOffset.y := Max - lpPrnPageInfo^.Margin.Top;
    Max := Max * 2;
    lpPrnPageInfo^.AdjustedPageArea.x := lpPrnPageInfo^.PageSize.x - Max;
    lpPrnPageInfo^.AdjustedPageArea.y := lpPrnPageInfo^.PageSize.y - Max;
    lpPrnPageInfo^.DPI.x := GetDeviceCaps(dc,
                                          LOGPIXELSX);
    lpPrnPageInfo^.DPI.y := GetDeviceCaps(dc,
                                          LOGPIXELSY);
  except
    exit;
  end;
  result := TRUE;
end;


function PrintDIBitmap(dc : HDC;
                       lpBitmapInfo : PBITMAPINFO;
                       lpBits : Pointer;
                       Centered : BOOL;
                       UsePerfectMargins : BOOL) : integer; stdcall;
var
  PrnPageInfo : TPrnPageInfo;
  ABitmapWidth : integer;
  ABitmapHeight : integer;
  TotalImageWidth : integer;
  TotalImageHeight : integer;
  ScaleX : Extended;
  ScaleY : Extended;
  PrintedImageWidth : integer;
  PrintedImageHeight : integer;
  PrintedImageOffset : TPoint;
  PageRect : TRect;
  SaveIndex : integer;
  P: TPoint;
  ReturnValue : integer;
begin
  if (
      (NOT IsDibHeaderValid(lpBitmapInfo)) OR
      (lpBits = nil)
     ) then begin
    result := BAD_PARAMETER;
    exit;
  end;
  if (NOT GetPrnPageInfo(dc,
                         @PrnPageInfo)) then begin
    result := BAD_PARAMETER;
    exit;
  end;
  if (PRNDIB_DEBUG_DcSaves = PRNDIB_DEBUG_DCSAVES_ON) then begin
    UsePerfectMargins := FALSE;
    Centered := FALSE;
  end;  
  if (NOT UsePerfectMargins) then begin
    PrnPageInfo.AdjustedMargin := PrnPageInfo.Margin;
    PrnPageInfo.AdjustedPageArea := PrnPageInfo.PageArea;
    PrnPageInfo.AdjustedMarginOffset.x := 0;
    PrnPageInfo.AdjustedMarginOffset.y := 0;
  end;
  try
    if (IsOS2Dib(lpBitmapInfo)) then begin
      ABitmapWidth := PBITMAPCOREINFO(lpBitmapInfo)^.bmciHeader.bcWidth;
      ABitmapHeight := PBITMAPCOREINFO(lpBitmapInfo)^.bmciHeader.bcHeight;
    end else begin
      ABitmapWidth := lpBitmapInfo^.bmiHeader.biWidth;
      ABitmapHeight := abs(lpBitmapInfo^.bmiHeader.biHeight);
    end;
  except
    result := BAD_PARAMETER;
    exit;
  end;
  PageRect.Left := 0;
  PageRect.Top := 0;
  PageRect.Right := PrnPageInfo.AdjustedPageArea.x;
  PageRect.Bottom := PrnPageInfo.AdjustedPageArea.y;
  TotalImageWidth := PrnPageInfo.AdjustedPageArea.x;
  TotalImageHeight := PrnPageInfo.AdjustedPageArea.y;
  ScaleX := TotalImageWidth / ABitmapWidth;
  ScaleY := TotalImageHeight / ABitmapHeight;
  if (ScaleX < ScaleY) then begin
    PrintedImageWidth := TotalImageWidth;
    PrintedImageHeight := Trunc(ABitmapHeight * ScaleX);
    PrintedImageOffset.x := 0;
    PrintedImageOffset.y := (TotalImageHeight div 2) - (PrintedImageHeight div 2);
  end else begin
    PrintedImageHeight := TotalImageHeight;
    PrintedImageWidth := Trunc(ABitmapWidth * ScaleY);
    PrintedImageOffset.x := (TotalImageWidth div 2) - (PrintedImageWidth div 2);
    PrintedImageOffset.y := 0;
  end;
  if (NOT Centered) then begin
    PrintedImageOffset.x := 0;
    PrintedImageOffset.y := 0;
  end;
  SaveIndex := 0;
  if (PRNDIB_DEBUG_DcSaves = PRNDIB_DEBUG_DCSAVES_OFF) then begin
    SaveIndex := SaveDc(dc);
    GetWindowOrgEx(dc, p);
    SetWindowOrgEx(dc,
                   p.x - PrnPageInfo.AdjustedMarginOffset.x,
                   p.y - PrnPageInfo.AdjustedMarginOffset.y,
                   nil);
    IntersectClipRect(dc,
                      0,
                      0,
                      PrnPageInfo.AdjustedPageArea.x,
                      PrnPageInfo.AdjustedPageArea.y);
   end;
   ReturnValue :=
     PrintDIBitmapEx(dc,
                     PrintedImageOffset.x,
                     PrintedImageOffset.y,
                     PrintedImageWidth,
                     PrintedImageHeight,
                     0,
                     0,
                     ABitmapWidth,
                     ABitmapHeight,
                     lpBitmapInfo,
                     lpBits,
                     0,
                     TRUE,
                     FALSE,
                     PageRect,
                     nil,
                     0);
  if (PRNDIB_DEBUG_DcSaves = PRNDIB_DEBUG_DCSAVES_OFF) then begin
    RestoreDc(dc,
              SaveIndex);
  end;            
  result := ReturnValue;
end;


function PrintDIBitmapCB(dc : HDC;
                         lpBitmapInfo : PBITMAPINFO;
                         lpBits : Pointer;
                         Centered : BOOL;
                         UsePerfectMargins : BOOL;
                         OnAppCallbackFn : TAppCallbackFn;
                         OnAppCallbackData : DWORD) : integer; stdcall;
var
  PrnPageInfo : TPrnPageInfo;
  ABitmapWidth : integer;
  ABitmapHeight : integer;
  TotalImageWidth : integer;
  TotalImageHeight : integer;
  ScaleX : Extended;
  ScaleY : Extended;
  PrintedImageWidth : integer;
  PrintedImageHeight : integer;
  PrintedImageOffset : TPoint;
  PageRect : TRect;
  SaveIndex : integer;
  P: TPoint;
  ReturnValue : integer;
begin
  if (
      (NOT IsDibHeaderValid(lpBitmapInfo)) OR
      (lpBits = nil)
     ) then begin
    result := BAD_PARAMETER;
    exit;
  end;
  if (NOT GetPrnPageInfo(dc,
                         @PrnPageInfo)) then begin
    result := BAD_PARAMETER;
    exit;
  end;
  if (PRNDIB_DEBUG_DcSaves = PRNDIB_DEBUG_DCSAVES_ON) then begin
    UsePerfectMargins := FALSE;
    Centered := FALSE;
  end;  
  if (NOT UsePerfectMargins) then begin
    PrnPageInfo.AdjustedMargin := PrnPageInfo.Margin;
    PrnPageInfo.AdjustedPageArea := PrnPageInfo.PageArea;
    PrnPageInfo.AdjustedMarginOffset.x := 0;
    PrnPageInfo.AdjustedMarginOffset.y := 0;
  end;
  try
    if (IsOS2Dib(lpBitmapInfo)) then begin
      ABitmapWidth := PBITMAPCOREINFO(lpBitmapInfo)^.bmciHeader.bcWidth;
      ABitmapHeight := PBITMAPCOREINFO(lpBitmapInfo)^.bmciHeader.bcHeight;
    end else begin
      ABitmapWidth := lpBitmapInfo^.bmiHeader.biWidth;
      ABitmapHeight := abs(lpBitmapInfo^.bmiHeader.biHeight);
    end;
  except
    result := BAD_PARAMETER;
    exit;
  end;
  PageRect.Left := 0;
  PageRect.Top := 0;
  PageRect.Right := PrnPageInfo.AdjustedPageArea.x;
  PageRect.Bottom := PrnPageInfo.AdjustedPageArea.y;
  TotalImageWidth := PrnPageInfo.AdjustedPageArea.x;
  TotalImageHeight := PrnPageInfo.AdjustedPageArea.y;
  ScaleX := TotalImageWidth / ABitmapWidth;
  ScaleY := TotalImageHeight / ABitmapHeight;
  if (ScaleX < ScaleY) then begin
    PrintedImageWidth := TotalImageWidth;
    PrintedImageHeight := Trunc(ABitmapHeight * ScaleX);
    PrintedImageOffset.x := 0;
    PrintedImageOffset.y := (TotalImageHeight div 2) - (PrintedImageHeight div 2);
  end else begin
    PrintedImageHeight := TotalImageHeight;
    PrintedImageWidth := Trunc(ABitmapWidth * ScaleY);
    PrintedImageOffset.x := (TotalImageWidth div 2) - (PrintedImageWidth div 2);
    PrintedImageOffset.y := 0;
  end;
  if (NOT Centered) then begin
    PrintedImageOffset.x := 0;
    PrintedImageOffset.y := 0;
  end;
  SaveIndex := 0;
  if (PRNDIB_DEBUG_DcSaves = PRNDIB_DEBUG_DCSAVES_OFF) then begin
    SaveIndex := SaveDc(dc);
    GetWindowOrgEx(dc, p);
    SetWindowOrgEx(dc,
                   p.x - PrnPageInfo.AdjustedMarginOffset.x,
                   p.y - PrnPageInfo.AdjustedMarginOffset.y,
                   nil);
    IntersectClipRect(dc,
                      0,
                      0,
                      PrnPageInfo.AdjustedPageArea.x,
                      PrnPageInfo.AdjustedPageArea.y);
   end;                    
   ReturnValue :=
     PrintDIBitmapEx(dc,
                     PrintedImageOffset.x,
                     PrintedImageOffset.y,
                     PrintedImageWidth,
                     PrintedImageHeight,
                     0,
                     0,
                     ABitmapWidth,
                     ABitmapHeight,
                     lpBitmapInfo,
                     lpBits,
                     0,
                     TRUE,
                     FALSE,
                     PageRect,
                     OnAppCallbackFn,
                     OnAppCallbackData);
  if (PRNDIB_DEBUG_DcSaves = PRNDIB_DEBUG_DCSAVES_OFF) then begin
    RestoreDc(dc,
              SaveIndex);
  end;
  result := ReturnValue;
end;


function PrintDIBitmapXY(dc : HDC;
                         dstx : integer;
                         dsty : integer;
                         dstWidth : integer;
                         dstHeight : integer;
                         lpBitmapInfo : PBITMAPINFO;
                         lpBits : Pointer) : integer; stdcall;
var
  ABitmapWidth : integer;
  ABitmapHeight : integer;
  ClipRect : TRect;
  PrnPageInfo : TPrnPageInfo;
begin
  if (
      (NOT IsDibHeaderValid(lpBitmapInfo)) OR
      (lpBits = nil)
     ) then begin
    result := BAD_PARAMETER;
    exit;
  end;
  try
    if (IsOS2Dib(lpBitmapInfo)) then begin
      ABitmapWidth := PBITMAPCOREINFO(lpBitmapInfo)^.bmciHeader.bcWidth;
      ABitmapHeight := PBITMAPCOREINFO(lpBitmapInfo)^.bmciHeader.bcHeight;
    end else begin
      ABitmapWidth := lpBitmapInfo^.bmiHeader.biWidth;
      ABitmapHeight := abs(lpBitmapInfo^.bmiHeader.biHeight);
    end;
  except
    result := BAD_PARAMETER;
    exit;
  end;
  if (NOT GetPrnPageInfo(dc,
                         @PrnPageInfo)) then begin
    result := BAD_PARAMETER;
    exit;
  end;
  ClipRect.Left := 0;
  ClipRect.Top := 0;
  ClipRect.Right := PrnPageInfo.PageArea.x;
  ClipRect.Bottom := PrnPageInfo.PageArea.y;
  try
    result := PrintDIBitmapEx(dc,
                              dstx,
                              dsty,
                              dstWidth,
                              dstHeight,
                              0,
                              0,
                              ABitmapWidth,
                              ABitmapHeight,
                              lpBitmapInfo,
                              lpBits,
                              0,
                              TRUE,
                              FALSE,
                              ClipRect,
                              nil,
                              0);
  except
    result := BAD_PARAMETER;
  end;
end;


function PrintDIBitmapEx(dc : HDC;
                         dstx : integer;
                         dsty : integer;
                         dstWidth : integer;
                         dstHeight : integer;
                         srcx : integer;
                         srcy : integer;
                         srcWidth : integer;
                         srcHeight : integer;
                         lpBitmapInfo : PBITMAPINFO;
                         lpBits : Pointer;
                         palette : HPALETTE;
                         ForcePalette : BOOL;
                         DoNotUsePalette : BOOL;
                         DeviceClipRect : TRect;
                         OnAppCallbackFn : TAppCallbackFn;
                         OnAppCallbackData : DWORD) : integer; stdcall;
var
  cbInfo : TPaintControlTileCallbackInfo;
  ChunkSizeX : integer;
  ChunkSizeY : integer;
  BytesPerScanLine : integer;
  ScreenDc : HDC;
  PaletteCreated : BOOL;
  OldPalette : HPALETTE;
  TheTileCallbackFn : TTileCallbackFn;
begin
  if (
      (NOT IsDibHeaderValid(lpBitmapInfo)) OR
      (lpBits = nil) OR
      (srcx < 0) OR
      (srcy < 0) OR
      (srcWidth < 1) OR
      (srcHeight < 1) OR
      (dstWidth < 1) OR
      (dstHeight < 1)
     ) then begin
    result := BAD_PARAMETER;
    exit;
  end;
  FillChar(cbInfo,
           sizeof(cbInfo),
           0);
  cbInfo.SrcBitmap.BitmapInfoSize := CalcDibHeaderSize(lpBitmapInfo,
                                                       cbInfo.SrcBitmap.ColorTableNumEntries,
                                                       cbInfo.SrcBitmap.BitfieldNumEntries,
                                                       cbInfo.SrcBitmap.BitsSize,
                                                       cbInfo.SrcBitmap.BytesPerScanLine,
                                                       cbInfo.SrcBitmap.IsDIBTopDown);

  if (
       (cbInfo.SrcBitmap.BitmapInfoSize < 1) OR
       (cbInfo.SrcBitmap.BitsSize < 1) OR
       (cbInfo.SrcBitmap.BytesPerScanLine < 1)
     ) then begin
    result := BAD_PARAMETER;
    exit;
  end;
  cbInfo.SrcBitmap.lpBitsInfo := GetMemEx(cbInfo.SrcBitmap.BitmapInfoSize);
  if (cbInfo.SrcBitmap.lpBitsInfo = nil) then begin
    result := MEMORY_ALLOC_FAILED;
    exit;
  end;
  if (IsOS2Dib(lpBitmapInfo)) then begin
    if (NOT ConvertOS2BibHeaderToWinDibHeader(PBITMAPCOREINFO(lpBitmapInfo),
                                              cbInfo.SrcBitmap.lpBitsInfo,
                                              cbInfo.SrcBitmap.ColorTableNumEntries,
                                              cbInfo.SrcBitmap.BitsSize)) then begin
      FreeMemEx(cbInfo.SrcBitmap.lpBitsInfo);
      result := MEMORY_READ_FAILED;
      exit;
    end;
  end else begin
    try
      Move(lpBitmapInfo^,
           cbInfo.SrcBitmap.lpBitsInfo^,
           cbInfo.SrcBitmap.BitmapInfoSize);
    except
      FreeMemEx(cbInfo.SrcBitmap.lpBitsInfo);
      result := MEMORY_READ_FAILED;
      exit;
    end;
  end;
  if (
      (srcWidth > cbInfo.SrcBitmap.lpBitsInfo^.bmiHeader.biWidth) OR
      (srcHeight > abs(cbInfo.SrcBitmap.lpBitsInfo^.bmiHeader.biHeight)) OR
      ((srcx + srcWidth) > cbInfo.SrcBitmap.lpBitsInfo^.bmiHeader.biWidth) OR
      ((srcy + srcHeight) > abs(cbInfo.SrcBitmap.lpBitsInfo^.bmiHeader.biHeight))
     ) then begin
    FreeMemEx(cbInfo.SrcBitmap.lpBitsInfo);
    result := BAD_PARAMETER;
    exit;
  end;
  cbInfo.DeviceClipRect := DeviceClipRect;
  cbInfo.DstRect.Left := dstx;
  cbInfo.DstRect.Top := dsty;
  cbInfo.DstRect.Right := dstx + dstWidth;
  cbInfo.DstRect.Bottom := dsty + dstHeight;
  if (Windows.IsRectEmpty(cbInfo.DstRect)) then begin
    FreeMemEx(cbInfo.SrcBitmap.lpBitsInfo);
    result := NOTHING_TO_PRINT;
    exit;
  end;
  if (NOT Windows.IntersectRect(cbInfo.CurrentPaintRect,
                                cbInfo.DstRect,
                                cbInfo.DeviceClipRect)) then begin
    FreeMemEx(cbInfo.SrcBitmap.lpBitsInfo);
    result := NOTHING_TO_PRINT;
    exit;
  end;
  if (Windows.IsRectEmpty(cbInfo.CurrentPaintRect)) then begin
    FreeMemEx(cbInfo.SrcBitmap.lpBitsInfo);
    result := NOTHING_TO_PRINT;
    exit;
  end;
  cbInfo.SrcRect.Left := srcx;
  cbInfo.SrcRect.Top := srcy;
  cbInfo.SrcRect.Right := srcx + srcWidth;
  cbInfo.SrcRect.Bottom := srcy + srcHeight;
  if (Windows.IsRectEmpty(cbInfo.SrcRect)) then begin
    FreeMemEx(cbInfo.SrcBitmap.lpBitsInfo);
    result := NOTHING_TO_PRINT;
    exit;
  end;
  if ((cbInfo.SrcBitmap.lpBitsInfo^.bmiHeader.biCompression = BI_RLE8) OR
      (cbInfo.SrcBitmap.lpBitsInfo^.bmiHeader.biCompression = BI_RLE4)) then begin
    cbInfo.SrcBitmap.DibIsCompressed := TRUE;
    if (cbInfo.SrcBitmap.lpBitsInfo^.bmiHeader.biSizeImage < 1) then begin
      FreeMemEx(cbInfo.SrcBitmap.lpBitsInfo);
      result := BAD_PARAMETER;
      exit;
    end;
    cbInfo.SrcBitmap.lpBits := GetMemEx(cbInfo.SrcBitmap.BitsSize);
    if (cbInfo.SrcBitmap.lpBits = nil) then begin
      FreeMemEx(cbInfo.SrcBitmap.lpBitsInfo);
      result := MEMORY_ALLOC_FAILED;
      exit;
    end;
    if (NOT UnCompress(lpBitmapInfo,
                       lpBits,
                       @cbInfo.SrcBitmap)) then begin
      FreeMemEx(cbInfo.SrcBitmap.lpBits);
      FreeMemEx(cbInfo.SrcBitmap.lpBitsInfo);
      result := MEMORY_READ_FAILED;
      exit;
    end;
  end else begin
    cbInfo.SrcBitmap.lpBits := lpBits;
  end;
  CalcScanlineOffsets(cbInfo.SrcBitmap.lpBits,
                      cbInfo.SrcBitmap.BitsSize,
                      cbInfo.SrcBitmap.BytesPerScanLine,
                      cbInfo.SrcBitmap.IsDIBTopDown,
                      cbInfo.SrcBitmap.FirstScanline,
                      cbInfo.SrcBitmap.ScanLineInc);
  if ((cbInfo.SrcBitmap.FirstScanline = nil) OR
       (cbInfo.SrcBitmap.ScanLineInc = 0)) then begin
    if (cbInfo.SrcBitmap.DibIsCompressed) then begin
      FreeMemEx(cbInfo.SrcBitmap.lpBits);
    end;
    FreeMemEx(cbInfo.SrcBitmap.lpBitsInfo);
    result := BAD_PARAMETER;
    exit;
  end;
  cbInfo.Dc := dc;
  cbInfo.DstRectWidth := cbInfo.DstRect.Right - cbInfo.DstRect.Left;
  cbInfo.DstRectHeight := cbInfo.DstRect.Bottom - cbInfo.DstRect.Top;
  cbInfo.SrcRectWidth := cbInfo.SrcRect.Right - cbInfo.SrcRect.Left;
  cbInfo.SrcRectHeight := cbInfo.SrcRect.Bottom - cbInfo.SrcRect.Top;
  cbInfo.CurrentPaintRectWidth := cbInfo.CurrentPaintRect.Right - cbInfo.CurrentPaintRect.Left;
  cbInfo.CurrentPaintRectHeight := cbInfo.CurrentPaintRect.Bottom - cbInfo.CurrentPaintRect.Top;
  cbInfo.DeviceClipRectWidth := cbInfo.DeviceClipRect.Right - cbInfo.DeviceClipRect.Left;
  cbInfo.DeviceClipRectHeight := cbInfo.DeviceClipRect.Bottom - cbInfo.DeviceClipRect.Top;
  cbInfo.ScaleX := cbInfo.DstRectWidth / cbInfo.SrcRectWidth;
  cbInfo.ScaleY := cbInfo.DstRectHeight / cbInfo.SrcRectHeight;
  cbInfo.iScaleX := cbInfo.SrcRectWidth / cbInfo.DstRectWidth;
  cbInfo.iScaleY := cbInfo.SrcRectHeight / cbInfo.DstRectHeight;
  cbInfo.OnAppCallbackFn := OnAppCallbackFn;
  cbInfo.OnAppCallbackData := OnAppCallbackData;
  ScreenDc := GetDC(0);
  ChunkSizeX := GetDeviceCaps(ScreenDc,
                              HORZRES);
  ChunkSizeY := GetDeviceCaps(ScreenDc,
                              VERTRES);
  ReleaseDC(0,
            ScreenDc);
  if (NOT((GetDeviceCaps(dc,
                         RASTERCAPS) AND RC_BITMAP64) = RC_BITMAP64)) then begin
    BytesPerScanLine := -((((ChunkSizeX *
                             cbInfo.SrcBitmap.lpBitsInfo^.bmiHeader.biBitCount)
                             + 31)
                             AND NOT 31)
                             div 8);
    ChunkSizeY := abs($FFDF div BytesPerScanLine);
  end;
  PaletteCreated := FALSE;
  OldPalette := 0;
  case (PRNDIB_DEBUG_Palette) of
    PRNDIB_DEBUG_PALETTE_NOTALLOWED : begin
      Palette := 0;
      DoNotUsePalette := TRUE;
    end;
    PRNDIB_DEBUG_PALETTE_FORCE : begin
      DoNotUsePalette := FALSE;
    end;
  end;
  if (Palette <> 0) then begin
    if (
        (IsPaletteDevice(dc)) OR
        (PRNDIB_DEBUG_Palette = PRNDIB_DEBUG_PALETTE_FORCE)
       ) then begin
      OldPalette := SelectPalette(dc,
                                  Palette,
                                  ForcePalette);
      RealizePalette(dc);
    end;
  end else begin
    if (DoNotUsePalette <> FALSE) then begin
      if (
          (IsPaletteDevice(dc)) OR
          (PRNDIB_DEBUG_Palette = PRNDIB_DEBUG_PALETTE_FORCE)
         ) then begin
        Palette := CreateDIBPalette(lpBitmapInfo);
        if (Palette <> 0) then begin
          PaletteCreated := TRUE;
          OldPalette := SelectPalette(dc,
                                      Palette,
                                      ForcePalette);
          RealizePalette(dc);
        end;
      end;
    end;  
  end;
  cbInfo.UseDDB := (PRNDIB_DEBUG_Use_DDB = PRNDIB_DEBUG_USE_DDB_ON);
  if (PRNDIB_DoWinScale = PRNDIB_DO_WIN_SCALE_OFF) then begin
    TheTileCallbackFn := @CustomFormTileCallbackFn;
  end else begin
    TheTileCallbackFn := @CustomFormTileCallbackFn2;
  end;
  if (NOT TileRect(cbInfo.CurrentPaintRect,
                   ChunkSizeX,
                   ChunkSizeY,
                   TheTileCallbackFn,
                   @cbInfo,
                   0)) then begin
    if (Palette <> 0) then begin
      SelectPalette(dc,
                    OldPalette,
                    FALSE);
    end;
    if (PaletteCreated) then begin
      DeleteObject(Palette);
    end;
    if (cbInfo.SrcBitmap.DibIsCompressed) then begin
      FreeMemEx(cbInfo.SrcBitmap.lpBits);
    end;
    FreeMemEx(cbInfo.SrcBitmap.lpBitsInfo);
    result := USER_ABORT_OR_OTHER_ERROR;
    exit;
  end;
  if (Palette <> 0) then begin
    SelectPalette(dc,
                  OldPalette,
                  FALSE);
  end;
  if (PaletteCreated) then begin
    DeleteObject(Palette);
  end;
  if (cbInfo.SrcBitmap.DibIsCompressed) then begin
    FreeMemEx(cbInfo.SrcBitmap.lpBits);
  end;
  FreeMemEx(cbInfo.SrcBitmap.lpBitsInfo);
  result := PRINT_SUCCESSFUL;
end;

{$IFDEF PrnDIB_CKTYPEDOPERATOR}
  {$UNDEF PrnDIB_CKTYPEDOPERATOR}
  {$T+}
{$ENDIF}

{$IFDEF PrnDIB_CKBOOL}
  {$UNDEF PrnDIB_CKBOOL}
  {$B+}
{$ENDIF}

{$IFDEF PrnDIB_CKRANGE}
  {$UNDEF PrnDIB_CKRANGE}
  {$R+}
{$ENDIF}

{$IFDEF PrnDIB_CKOVERFLOW}
  {$UNDEF PrnDIB_CKOVERFLOW}
  {$Q+}
{$ENDIF}

initialization
  PRNDIB_DEBUG_Msg := PRNDIB_DEBUG_MSG_OFF;
  PRNDIB_DEBUG_BltCode := PRNDIB_DEBUG_BLTCODE_ON;
  PRNDIB_DEBUG_Blt := PRNDIB_DEBUG_BLT_ON;
  PRNDIB_DEBUG_Use_DDB := PRNDIB_DEBUG_USE_DDB_OFF;
  PRNDIB_DEBUG_AutoUse_DDB := PRNDIB_DEBUG_AUTOUSE_DDB_ON;
  PRNDIB_DEBUG_Sleep_Value := -1;
  PRNDIB_DEBUG_Frames := PRNDIB_DEBUG_FRAMES_OFF;
  PRNDIB_DEBUG_Palette := PRNDIB_DEBUG_PALETTE_NONE;
  PRNDIB_DEBUG_DcSaves := PRNDIB_DEBUG_DCSAVES_OFF;
  PRNDIB_DEBUG_GdiFlush := PRNDIB_DEBUG_GDIFLUSH_ON;
  PRNDIB_DEBUG_Abort_Dialog_Handle := 0;
  PRNDIB_OutputScaleFactorX := 1;
  PRNDIB_OutputScaleFactorY := 1;
  PRNDIB_DoWinScale := PRNDIB_DO_WIN_SCALE_OFF;
finalization
end.
