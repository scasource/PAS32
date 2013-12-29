unit PrnUtils;

{PrnUtils Copyright (c) 1989-2000 by Joe C. Hecht All Rights Reserved}
{License - Distribution of this souce code prohibited!}
{For inclusion in compiled form in your application only!}
{Version 3.1 - Use at your own risk - No liability accepted!}
{TExcellentHomePage: www.code4sale.com/joehecht}
{Author email: joehecht@code4sale.com}
{Code4Sale.com - You place to buy and sell code! www.code4sale.com}

interface

uses
  SysUtils,
  Windows,
  Messages,
  Classes,
  Graphics,
  Controls,
  StdCtrls,
  Forms;


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


type
  PScaleInfo = ^TScaleInfo;
  TScaleInfo = packed record
    OriginalSize_X : double;
    OriginalSize_Y : double;
    ScaledSize_X : double;
    ScaledSize_Y : double;
    ScaleFactor_X : double;
    ScaleFactor_Y : double;
  end;


function ScaleToFitX(lpScaleInfo : PScaleInfo) : BOOL; stdcall;

function ScaleToFitY(lpScaleInfo : PScaleInfo) : BOOL; stdcall;

function ScaleToBestFit(lpScaleInfo : PScaleInfo) : BOOL; stdcall;

type
  PPixelSizeInfo = ^TPixelSizeInfo;
  TPixelSizeInfo = packed record
    DotsPerInch_X : double;
    DotsPerInch_Y : double;
    DotsPerMillimeter_X : double;
    DotsPerMillimeter_Y : double;
    DotsPerPoint_X : double;
    DotsPerPoint_Y : double;
  end;


function GetPixelSizeInfo(dc : HDC;
                          lpPixelSizeInfo : PPixelSizeInfo) : BOOL; stdcall;

function GetNumPagesRequired(PrinterPageSize : DWORD;
                             ImageSize : DWORD) : DWORD; stdcall;

function GetMemEx(size : DWORD) : pointer; stdcall;

function FreeMemEx(p : pointer) : pointer; stdcall;

function LoadDIBFromStream(TheStream : TStream;
                           var lpBitmapInfo : pointer;
                           var lpBits : Pointer;
                           var BitmapWidth : integer;
                           var BitmapHeight : integer) : BOOL; stdcall;


function LoadDIBFromFile(const FileName : string;
                         var lpBitmapInfo : pointer;
                         var lpBits : Pointer;
                         var BitmapWidth : integer;
                         var BitmapHeight : integer) : BOOL; stdcall;


function LoadDIBFromTBitmap(ABitmap : TBitmap;
                            var lpBitmapInfo : pointer;
                            var lpBits : Pointer;
                            var BitmapWidth : integer;
                            var BitmapHeight : integer) : BOOL; stdcall;


type
  TAbortDialog = class(TForm)
    btnCancel: TButton;
    procedure btnCancelClick(Sender: TObject);
  private
    { Private declarations }
    Canceled : BOOL;
  public
    { Public declarations }
    function Aborted : BOOL;
  end;


function CreateAbortDialog(ApplicationHandle : THandle;
                           AOwner: TComponent) : TAbortDialog; stdcall;

procedure FreeAbortDialog(AbortDialog : TAbortDialog); stdcall;
{Frees an abort dialog}


procedure AbortDialogSetCaption(AbortDialog : TAbortDialog;
                                s : pChar); stdcall;

function AbortDialogUserHasCanceled(AbortDialog : TAbortDialog) : BOOL; stdcall;


type
  TPrinterAbortDialog = TAbortDialog;

function CreatePrinterAbortDialog(ApplicationHandle : THandle;
                                  AOwner: TComponent) : TPrinterAbortDialog; stdcall;

procedure FreePrinterAbortDialog(AbortDialog : TPrinterAbortDialog); stdcall;


procedure PrinterAbortDialogSetCaption(AbortDialog : TPrinterAbortDialog;
                                       ACaption : pChar); stdcall;

function PrinterAbortDialogAborted(AbortDialog : TPrinterAbortDialog) : BOOL; stdcall;

implementation

{$R *.DFM}

{$IFOPT Q+}
  {$DEFINE PrnUtils_CKOVERFLOW}
  {$Q-}
{$ENDIF}

{$IFOPT R+}
  {$DEFINE PrnUtils_CKRANGE}
  {$R-}
{$ENDIF}

function RoundWayUp(X: Extended): LongInt;
begin
  if (Frac(X) > 0.0000001) then begin
    x := x + 1;
  end;
  Result := Trunc(X);
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



function ScaleToFitX(lpScaleInfo : PScaleInfo) : BOOL; stdcall;
begin
  if ((lpScaleInfo = nil) OR
      (lpScaleInfo^.OriginalSize_X = 0)) then begin
    result := FALSE;
    exit;
  end;
  try
    lpScaleInfo^.ScaleFactor_X := lpScaleInfo^.ScaledSize_X / lpScaleInfo^.OriginalSize_X;
    lpScaleInfo^.ScaleFactor_Y := lpScaleInfo^.ScaleFactor_X;
    lpScaleInfo^.ScaledSize_Y := lpScaleInfo^.OriginalSize_Y * lpScaleInfo^.ScaleFactor_Y;
  except
    result := FALSE;
    exit;
  end;
  result := TRUE;
end;


function ScaleToFitY(lpScaleInfo : PScaleInfo) : BOOL; stdcall;
begin
  if ((lpScaleInfo = nil) OR
      (lpScaleInfo^.OriginalSize_Y = 0)) then begin
    result := FALSE;
    exit;
  end;
  try
    lpScaleInfo^.ScaleFactor_Y := lpScaleInfo^.ScaledSize_Y / lpScaleInfo^.OriginalSize_Y;
    lpScaleInfo^.ScaleFactor_X := lpScaleInfo^.ScaleFactor_Y;
    lpScaleInfo^.ScaledSize_X := lpScaleInfo^.OriginalSize_X * lpScaleInfo^.ScaleFactor_Y;
  except
    result := FALSE;
    exit;
  end;
  result := TRUE;
end;


function ScaleToBestFit(lpScaleInfo : PScaleInfo) : BOOL; stdcall;
begin
  if ((lpScaleInfo = nil) OR
      (lpScaleInfo^.OriginalSize_X = 0) OR
      (lpScaleInfo^.OriginalSize_Y = 0)) then begin
    result := FALSE;
    exit;
  end;
  try
    lpScaleInfo^.ScaleFactor_X := lpScaleInfo^.ScaledSize_X / lpScaleInfo^.OriginalSize_X;
    lpScaleInfo^.ScaleFactor_Y := lpScaleInfo^.ScaledSize_Y / lpScaleInfo^.OriginalSize_Y;
    if (lpScaleInfo^.ScaleFactor_X < lpScaleInfo^.ScaleFactor_Y) then begin
      lpScaleInfo^.ScaledSize_Y := lpScaleInfo^.OriginalSize_Y * lpScaleInfo^.ScaleFactor_X;
    end else begin
      lpScaleInfo^.ScaledSize_X := lpScaleInfo^.OriginalSize_X * lpScaleInfo^.ScaleFactor_Y;
    end;
  except
    result := FALSE;
    exit;
  end;
  result := TRUE;
end;


function GetPixelSizeInfo(dc : HDC;
                          lpPixelSizeInfo : PPixelSizeInfo) : BOOL; stdcall;
begin
  if (lpPixelSizeInfo = nil) then begin
    result := FALSE;
    exit;
  end;
  try
    if (dc = 0) then begin
      dc := GetDC(0);
      lpPixelSizeInfo^.DotsPerInch_X := GetDeviceCaps(dc,
                                                      LOGPIXELSX);
      lpPixelSizeInfo^.DotsPerInch_Y := GetDeviceCaps(dc,
                                                      LOGPIXELSY);
      ReleaseDc(0,
                dc);
    end else begin
      lpPixelSizeInfo^.DotsPerInch_X := GetDeviceCaps(dc,
                                                      LOGPIXELSX);
      lpPixelSizeInfo^.DotsPerInch_Y := GetDeviceCaps(dc,
                                                      LOGPIXELSY);
    end;
    lpPixelSizeInfo^.DotsPerMillimeter_X := lpPixelSizeInfo^.DotsPerInch_X / 25.4;
    lpPixelSizeInfo^.DotsPerMillimeter_Y := lpPixelSizeInfo^.DotsPerInch_Y / 25.4;
    lpPixelSizeInfo^.DotsPerPoint_X := lpPixelSizeInfo^.DotsPerInch_X / 72;
    lpPixelSizeInfo^.DotsPerPoint_Y := lpPixelSizeInfo^.DotsPerInch_Y / 72;
  except
    result := FALSE;
    exit;
  end;
  result := TRUE;
end;


function GetNumPagesRequired(PrinterPageSize : DWORD;
                             ImageSize : DWORD) : DWORD; stdcall;
begin
  if (PrinterPageSize = 0) then begin
    result := 0;
    exit;
  end;
  result := RoundWayUp(ImageSize / PrinterPageSize);
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


function LoadDIBFromStream(TheStream : TStream;
                           var lpBitmapInfo : pointer;
                           var lpBits : Pointer;
                           var BitmapWidth : integer;
                           var BitmapHeight : integer) : BOOL; stdcall;
var
  bmf : TBITMAPFILEHEADER;
  TheFileSize : integer;
  TheHeaderSize : integer;
  TheImageSize : integer;
  TheBitmapInfo : PBITMAPINFO;
  TheBitmapCoreInfo : PBITMAPCOREINFO;
begin
  lpBitmapInfo := nil;
  lpBits := nil;
  BitmapWidth := 0;
  BitmapHeight := 0;
  if (TheStream = nil) then begin
    result := FALSE;
    exit;
  end;
  try
    TheFileSize := TheStream.Size - TheStream.Position;
    TheStream.ReadBuffer(bmf,
                         sizeof(TBITMAPFILEHEADER));
  except
    result := FALSE;
    exit;
  end;
  TheHeaderSize := bmf.bfOffBits - sizeof(TBITMAPFILEHEADER);
  TheImageSize := TheFileSize - integer(bmf.bfOffBits);
  if ((bmf.bfType <> $4D42) OR
      (integer(bmf.bfOffBits) < 1) OR
      (TheFileSize < 1) OR
      (TheHeaderSize < 1) OR
      (TheImageSize < 1) OR
      (TheFileSize < (sizeof(TBITMAPFILEHEADER) + TheHeaderSize + TheImageSize))) then begin
    result := FALSE;
    exit;
  end;
  try
    lpBitmapInfo := GetMemEx(TheHeaderSize);
  except
    lpBitmapInfo := nil;
    result := FALSE;
    exit;
  end;
  if (lpBitmapInfo = nil) then begin
    try
      FreeMemEx(lpBitmapInfo);
    except
    end;
    lpBitmapInfo := nil;
    result := FALSE;
    exit;
  end;
  try
    TheStream.ReadBuffer(lpBitmapInfo^,
                         TheHeaderSize);
  except
    try
      FreeMemEx(lpBitmapInfo);
    except
    end;
    lpBitmapInfo := nil;
    result := FALSE;
    exit;
  end;
  try
    TheBitmapInfo := lpBitmapInfo;
    case (TheBitmapInfo^.bmiHeader.biSize) of
      sizeof(TBITMAPINFOHEADER) : begin
        BitmapWidth := TheBitmapInfo^.bmiHeader.biWidth;
        BitmapHeight := abs(TheBitmapInfo^.bmiHeader.biHeight);
        if (TheBitmapInfo^.bmiHeader.biSizeImage <> 0) then begin
          TheImageSize := TheBitmapInfo^.bmiHeader.biSizeImage;
        end else begin
          TheImageSize := (((((TheBitmapInfo^.bmiHeader.biWidth *
                               TheBitmapInfo^.bmiHeader.biBitCount)
                               + 31)
                               AND NOT 31)
                               div 8) *
                               ABS(TheBitmapInfo^.bmiHeader.biHeight));
        end;
      end;
      sizeof(TBITMAPCOREHEADER) : begin
        TheBitmapCoreInfo := PBITMAPCOREINFO(lpBitmapInfo);
        BitmapWidth := TheBitmapCoreInfo^.bmciHeader.bcWidth;
        BitmapHeight := TheBitmapCoreInfo^.bmciHeader.bcHeight;
        TheImageSize := (((((TheBitmapCoreInfo^.bmciHeader.bcWidth *
                             TheBitmapCoreInfo^.bmciHeader.bcBitCount)
                             + 31)
                             AND NOT 31)
                             div 8) *
                             ABS(TheBitmapCoreInfo^.bmciHeader.bcHeight));
      end;
      else begin
        try
          FreeMemEx(lpBitmapInfo);
        except
        end;
        lpBits := nil;
        lpBitmapInfo := nil;
        BitmapWidth := 0;
        BitmapHeight := 0;
        result := FALSE;
        exit;
      end;
    end;
  except
    try
      FreeMemEx(lpBitmapInfo);
    except
    end;
    lpBitmapInfo := nil;
    BitmapWidth := 0;
    BitmapHeight := 0;
    result := FALSE;
    exit;
  end;
  if ((BitmapWidth < 1) OR
      (BitmapHeight < 1) OR
      (TheImageSize < 32)) then begin
    try
      FreeMemEx(lpBitmapInfo);
    except
    end;
    lpBitmapInfo := nil;
    BitmapWidth := 0;
    BitmapHeight := 0;
    result := FALSE;
    exit;
  end;
  try
    lpBits := GetMemEx(TheImageSize);
  except
    try
      FreeMemEx(lpBitmapInfo);
    except
    end;
    lpBits := nil;
    lpBitmapInfo := nil;
    result := FALSE;
    exit;
  end;
  try
    TheStream.ReadBuffer(lpBits^,
                         TheImageSize);
  except
    try
      FreeMemEx(lpBits);
    except
    end;
    try
      FreeMemEx(lpBitmapInfo);
    except
    end;
    lpBits := nil;
    lpBitmapInfo := nil;
    result := FALSE;
    exit;
  end;
  result := TRUE;
end;



function LoadDIBFromFile(const FileName : string;
                         var lpBitmapInfo : pointer;
                         var lpBits : Pointer;
                         var BitmapWidth : integer;
                         var BitmapHeight : integer) : BOOL; stdcall;
var
  TheFileStream : TFileStream;
begin
  lpBitmapInfo := nil;
  lpBits := nil;
  BitmapWidth := 0;
  BitmapHeight := 0;
  try
    TheFileStream := TFileStream.Create(FileName,
                                        fmOpenRead OR
                                        fmShareDenyWrite);
  except
    result := FALSE;
    exit;
  end;
  if (TheFileStream = nil) then begin
    result := FALSE;
    exit;
  end;
  result := LoadDIBFromStream(TheFileStream,
                              lpBitmapInfo,
                              lpBits,
                              BitmapWidth,
                              BitmapHeight);

  try
    TheFileStream.Free;
  except
  end;
end;


function LoadDIBFromTBitmap(ABitmap : TBitmap;
                            var lpBitmapInfo : pointer;
                            var lpBits : Pointer;
                            var BitmapWidth : integer;
                            var BitmapHeight : integer) : BOOL; stdcall;
var
  TheStream : TMemoryStream;
begin
  lpBitmapInfo := nil;
  lpBits := nil;
  BitmapWidth := 0;
  BitmapHeight := 0;
  try
    TheStream := TMemoryStream.Create;

  except
    result := FALSE;
    exit;
  end;
  if (TheStream = nil) then begin
    result := FALSE;
    exit;
  end;
  try
    ABitmap.SaveToStream(TheStream);
    TheStream.Position := 0;
  except
    result := FALSE;
    exit;
    try
      TheStream.Free;
    except
    end;
  end;
  result := LoadDIBFromStream(TheStream,
                              lpBitmapInfo,
                              lpBits,
                              BitmapWidth,
                              BitmapHeight);
  try
    TheStream.Free;
  except
  end;
end;



function TAbortDialog.Aborted : BOOL;
var
  Msg : TMsg;
begin
  while (PeekMessage(Msg,
                     Handle,
                     0,
                     0,
                     PM_REMOVE)) do begin
    DispatchMessage(Msg);
  end;
  result := Canceled;
end;


procedure TAbortDialog.btnCancelClick(Sender: TObject);
begin
  try
    Canceled := TRUE;
  except
  end;  
end;


function CreateAbortDialog(ApplicationHandle : THandle;
                           AOwner: TComponent) : TAbortDialog; stdcall;
begin
  try
    Application.Handle := ApplicationHandle;
    result := TAbortDialog.Create(Aowner);
    result.Show;
    result.Aborted;
  except
    result := nil;
  end;
end;


procedure FreeAbortDialog(AbortDialog : TAbortDialog); stdcall;
begin
  try
    AbortDialog.Free;
  except
  end;  
end;


procedure AbortDialogSetCaption(AbortDialog : TAbortDialog;
                                s : pChar); stdcall;
begin
  try
    AbortDialog.Caption := s;
    AbortDialog.Aborted;
  except
  end;  
end;


function AbortDialogUserHasCanceled(AbortDialog : TAbortDialog) : BOOL; stdcall;
begin
  try
    result := AbortDialog.Aborted;
  except
    result := FALSE;
  end;
end;

{backwards compatible printer abort dialog functions}

function CreatePrinterAbortDialog(ApplicationHandle : THandle;
                                  AOwner: TComponent) : TPrinterAbortDialog; stdcall;
begin
  try
    result := CreateAbortDialog(ApplicationHandle,
                                AOwner);
  except
    result := nil;
  end;
end;


procedure FreePrinterAbortDialog(AbortDialog : TPrinterAbortDialog); stdcall;
begin
  try
    FreeAbortDialog(AbortDialog);
  except
  end;
end;


function PrinterAbortDialogAborted(AbortDialog : TPrinterAbortDialog) : BOOL; stdcall;
begin
  try
    result := AbortDialogUserHasCanceled(AbortDialog);
  except
    result := FALSE;
  end;
end;


procedure PrinterAbortDialogSetCaption(AbortDialog : TPrinterAbortDialog;
                                       ACaption : pChar); stdcall;
begin
  try
    AbortDialogSetCaption(AbortDialog,
                          ACaption);
  except
  end;
end;


{$IFDEF PrnUtils_CKRANGE}
  {$UNDEF PrnUtils_CKRANGE}
  {$R+}
{$ENDIF}

{$IFDEF PrnUtils_CKOVERFLOW}
  {$UNDEF PrnUtils_CKOVERFLOW}
  {$Q+}
{$ENDIF}

end.
