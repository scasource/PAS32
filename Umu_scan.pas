(*/////////////////////////////////////////////////////////////////////////////
//                                                                           //
//   Part of Imagelib VCL/DLL Library Corporate Suite 4.0                    //
//                                                                           //
//   All rights reserved. (c) Copyright 1995, 1996, 1997, 1998.              //
//   SkyLine Tools a division by Creative Development LTD.                   //
//                                                                           //
//   Created by: Jan Dekkers,                                                //
//               Jillian Pinsker,                                            //
//               Reginald Armond,                                            //
//               Che-Chern Lin,                                              //
//               Alex Zitser,                                                //
//               Charles Ye,                                                 //
//               Song Han,                                                   //
//               Vitaly Bondarenko,                                          //
//               Jane Scarano,                                               //
//               Misha Popov;                                                //
//                                                                           //
//   and many others who provided feedback, gave tips and comments.          //
//                                                                           //
//   Call 1-800 404-3832  or 1-818 346-4200 to order ImageLib Corp. Suite.   //
//                                                                           //
/////////////////////////////////////////////////////////////////////////////*)

unit UMU_Scan;

{Includes settings to compile in either 16 or 32 bit}
{$I DEFILIB.INC}

interface
(*---------------------------------------------------------------------------

---------------------------------------------------------------------------*)
uses
  Windows,
  ComCtrls,
  Messages,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  Forms,
  DLL96V1,
  DLLSP96,
  Dialogs,
  StdCtrls,
  Buttons,
  ExtCtrls,
  TMultiP,
  Gauges,
  Spin,
  Mask,
  Utw_cap,
  Printers,
  MMOpen,
  MMSave;



type
  TTwainForm = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Label1: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    nPages: TSpinEdit;
    NBright: TSpinEdit;
    NCont: TSpinEdit;
    SelectSourceBtn: TSpeedButton;
    ScanImagesBtn: TSpeedButton;
    Panel4: TPanel;
    Label2: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    TopE: TMaskEdit;
    LeftE: TMaskEdit;
    RightE: TMaskEdit;
    BotE: TMaskEdit;
    DPI: TSpinEdit;
    Label9: TLabel;
    Scol: TComboBox;
    SaveBtn: TSpeedButton;
    SaveDialog: TMMSaveDialog;
    Label10: TLabel;
    StretchImagewithRatioBtn: TSpeedButton;
    ExitBtn: TSpeedButton;
    Panel5: TPanel;
    PrevTif: TSpeedButton;
    NextTif: TSpeedButton;
    TiffCounter: TEdit;
    OpenBtn: TSpeedButton;
    ScanDocumentsBtn: TSpeedButton;
    OpenDialog1: TMMOpenDialog;
    PrintDialog1: TPrintDialog;
    PrinterSetupDialog1: TPrinterSetupDialog;
    CheckBox1: TCheckBox;
    Label11: TLabel;
    CheckBox4: TCheckBox;
    PMultiImage1: TPMultiImage;
    Button1: TButton;
    StatusBar1: TStatusBar;
    ProgressBar1: TProgressBar;
    UIC: TComboBox;
    Label12: TLabel;
    Label13: TLabel;
    procedure ScanImages(Sender: TObject);
    procedure SelectSource(Sender: TObject);
    procedure MultiplePagesClick(Sender: TObject);
    procedure PMultiImage1Rubberband(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y, XX, YY: Integer);
    procedure ScanLoc(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SaveBtnClick(Sender: TObject);
    procedure ExitBtnClick(Sender: TObject);
    procedure StretchImageClick(Sender: TObject);
    procedure NexPrevTif(Sender: TObject);
    procedure OpenBtnClick(Sender: TObject);
    procedure PMultiImage1Progress(Sender        : TObject;
                                   Progress      : Smallint;
                                                                      PMessage      : String;
                               var CancelProcess : Boolean);
    procedure CheckBox4Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    scLeft,
    scTop,
    scRight,
    scBottom : Real;
    InCallBackCall : Boolean;
    TiffAppend : Boolean;
    CurrentTiffPage : SmallInt;
    procedure DisEn(Enb : Boolean);
    function Get_SetTiffPages(var GotoPage : SmallInt) : SmallInt;
  end;

var
  TwainForm: TTwainForm;

implementation


{$R *.DFM}

(******************************************************************

******************************************************************)
procedure TTwainForm.PMultiImage1Progress(Sender        : TObject;
                                          Progress      : Smallint;
                                          PMessage      : String;
                                      var CancelProcess : Boolean);
begin
    CancelProcess := Application.Terminated;
    {Process the First call}
    if Progress = 0  then begin
     ProgressBar1.Position:=0;
     Application.ProcessMessages;
    end;

    {Process the Last call}
    if Progress > 99  then begin
     ProgressBar1.Position:=Progress;
    {Set the message caption}
     StatusBar1.Panels[0].Text := '';
     Application.ProcessMessages;
     exit;
    end;

    {Some speed improvement when only processing each fifth call}
    if Progress > ProgressBar1.Position+5 then begin
     ProgressBar1.Position:=Progress;
     {Set the message caption}
     StatusBar1.Panels[0].Text:='Status '+PMessage;
     Application.ProcessMessages;
    end;
end;

(******************************************************************

******************************************************************)
procedure TTwainForm.FormCreate(Sender: TObject);
begin
    scLeft :=0;
    scTop :=0;
    scRight :=8.5;
    scBottom :=11;
    Scol.ItemIndex:=0;
    UIC.ItemIndex:=1;


    {This function will set a name when lowlevel scan is applied in the twain progress window}
    //SetNameForTwain('Bogus_Name_Here');
end;

(******************************************************************
Scan one page
******************************************************************)
procedure TTwainForm.ScanImages(Sender: TObject);
begin
  DisEn(false);
  try
   PMultiImage1.ScanImage(Handle);
  finally
   DisEn(True);
  end;
end;

(******************************************************************
select scanner
******************************************************************)
procedure TTwainForm.SelectSource(Sender: TObject);
begin
  DisEn(false);
  try
   PMultiImage1.SelectScanner(Handle);
  finally
   DisEn(True);
  end;
end;

(******************************************************************************
{This is a twain callback routine used when Low Level scanning multiple pages
 from a scanner with a ADF sheetfeeder or with user interface.}
********************************************************************************)
function TwainDibCall(HDIB : Thandle; d_object : longint): Smallint; CDECL; export;
var
   My_Tc : TTiffCompression;
   Resolution : SmallInt;
   Skew : Double;
(*   hBMP : HBitmap;
   HPAL : HPalette; *)
   hBMP : LongInt;
   HPAL : LongInt;
begin
  {Indicate that we are inside the call back and doing something}
  TwainForm.InCallBackCall := True;
    {Set options to save the file}
    My_Tc:=sFAXCCITT4;
    Resolution:=1;
    case TwainForm.Scol.ItemIndex of
      0: begin
            Resolution:=1;
            My_Tc:=sFAXCCITT4;
         end;
      1: begin
            Resolution:=8;
            My_Tc:=sPACKBITS;
         end;
      2: begin
            Resolution:=8;
            My_Tc:=sPACKBITS;
         end;
      3: begin
            Resolution:=GetDeviceRes(TwainForm.PMultiImage1.Canvas.Handle);
            My_Tc:=sPACKBITS;
         end;
    end;

    if TwainForm.CheckBox1.Checked then begin
       TwainForm.Label11.Caption:= 'DESKEWING';
       Application.ProcessMessages;
       Skew := DeskewDib(HDib,1, 90, 0.1, 4.0, 0);
       rotateDegreeDib(HDib,0,0,0,0,-Skew, clWhite);
       TwainForm.Label11.Caption:= 'Skew value (in degree) is ' + Format('%8.2f', [Skew]);
       Application.ProcessMessages;
    end;

    {Save it to a tiff file. This is faster then displaying it first }
    puttiffiledib(ExtractFilePath(Application.Exename)+'TEMP.TIF',
                  GetTiffCompression(My_Tc),
                  TwainForm.TiffAppend,
                  Resolution,
                  HDIB,
                  0,
                  nil);


    //This will display the DIB {******It is faster to save it without displying it******}
    //SLOW
    if HDIB > 0 then begin
       hDIBTODDB(HDIB, hBMP, HPAL);
       TwainForm.PMultiImage1.Picture.Bitmap.Handle:=hBMP;
       TwainForm.PMultiImage1.Picture.Bitmap.Palette:=HPAL;
    end;


    {Unlock DIB Handle and Free Memory of DIB}
    if (GMEM_LOCKCOUNT AND GlobalFlags(HDIB) > 0) then
     GlobalUnlock(HDIB);
    GlobalFree(HDIB);

    {Now we set append to true {We set it to false to generate a new file in the beginning}
    TwainForm.TiffAppend:=True;
    {Let the app know we are not in the callbac anymore}
    TwainForm.InCallBackCall := False;

    TwainForm.ProgressBar1.Position:=0;
    result:=1;
end;

(******************************************************************
Scan multiple pages
******************************************************************)
procedure TTwainForm.MultiplePagesClick(Sender: TObject);
var
  MyPixType, Resolution : Integer;
  Bitmap : TBitmap;
  nFlags : Integer;
begin
 Resolution:=GetDeviceRes(PMultiImage1.Picture.Bitmap.Canvas.Handle);

 MyPixType:=TW_BW;

 case Scol.ItemIndex of
      0: begin
             MyPixType:=TW_BW;
             Resolution:=1;
         end;
      1: MyPixType:=TW_GRAY;
      2: MyPixType:=TW_PALETTE;
      3: MyPixType:=TW_RGB;
 end;
 DisEn(false);

 nFlags:=0;

 case UIC.ItemIndex of
  {In the DLL we check it as follow
  ->ShowUI = nFlags & TWAIN_SHOWUI;
  ->UseADF = nFlags & TWAIN_USEADF;}
      0 : nFlags:=0;
      1 : nFlags := TW_SHOWUI;
      2 : nFlags:=0;
      3 : nFlags := TW_SHOWUI or TW_USEADF;
      4 : nFlags := TW_USEADF;
 end;


 try
    {Now we set append to False {This generate a new tifile. In the calback we will set it to true}
    {to generate a multipage tiff file.}
    TiffAppend:=False;

 {Reset in callback}
 InCallBackCall := False;

 //NOTE: FOR DIGITAL CAMARAS SET PAGES TO 10000 EXACTLY AND FLAG WITH TW_SHOWUI.
 //SOME CAMARAS (E.G. THE DC120) DON'T LIKE TO NEGOTIATE THE CAP_XFERCOUNT
 //WHICH RESULTS IN A LOCK-UP.

 //Most digital camaras do IGNORE the scleft, sctop, scright, scbottom, DPI, Bright and Contrast
 //values simple because they have their own way of setting these in their datasource.

 if not LowLevelDibScan(Bitmap,       {Return bitmap if scanning 1 page without Twain callback}
                        scLeft,       {Left in Inches or Centimeter depending on country}
                        scTop,        {Top  in Inches or Centimeter depending on country}
                        scRight,      {Right in Inches or Centimeter depending on country}
                        scBottom,     {Bottom in Inches or Centimeter depending on country}
                        DPI.Value,    {dpi resolution}
                        Resolution,   {Resolution  1,0,8,16,24}
                        0,            {Dither 0 or 1}
                        NBright.Value,{Brightness -1000 to 1000}
                        NCont.Value,  {Contrast -1000 to 1000}
                        nPages.Value, {Pages}
                        MyPixType,    {PixTypes}
                        nFlags,       {Flags  TW_USEADF and / or TW_SHOWUI to show user interface}
                        TwainDibCall, {TWAINCallBackFunction for multiple pages  }
                        nil,          {TWainCallBackFunction for progress bar etc}
                        0)            {Pointer of the calling object}   then begin
                                                                               exit;
                                                                             end;
 finally
   DisEn(True);
   {While we are doing something in the call back we will wait}
   While InCallBackCall do
    Application.ProcessMessages; {do nothing}     

   {Load in the temporary tiff file}
//   PMultiImage1.ImageName:=ExtractFilePath(Application.Exename)+'TEMP.TIF';
   {reset tiff counter}
   CurrentTiffPage:=1;
   Get_SetTiffPages(CurrentTiffPage);
 end;
end;


(******************************************************************
Zoom in image
******************************************************************)
procedure TTwainForm.PMultiImage1Rubberband(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y, XX, YY: Integer);
begin
   PMultiImage1.ZoomArea(Rect(X, Y, XX, YY));
end;

(******************************************************************
Set the scanning location
******************************************************************)

procedure TTwainForm.ScanLoc(Sender: TObject);
var
 S : String;
 F : Real;
begin
    {get the string}
    S:=TMaskEdit(Sender).Text;
    {delete the blanks}
    while Pos(' ', S) > 0 do
     Delete(S, Pos(' ', S),1);
    {Convert to float}
    F:=StrToFloat(S);
    if TMaskEdit(Sender) = TopE then
       scTop :=F;
    if TMaskEdit(Sender) = LeftE then
       scLeft :=F;
    if TMaskEdit(Sender) = RightE then
       scRight :=F;
    if TMaskEdit(Sender) = BotE then
       scBottom :=F;
end;


(******************************************************************
Save Image
******************************************************************)
procedure TTwainForm.SaveBtnClick(Sender: TObject);
var i          : integer;
    pExtension : string[4];
    BTiffPages  : SmallInt;
begin
 {Get the number of tiff pages}
 BTiffPages:=PMultiImage1.BTiffPages;
  {execute SaveDialog}
  if SaveDialog.Execute then begin

    pExtension:=UpperCase(ExtractFileExt(SaveDialog.FileName));
    {Create a new tiff file}
    PMultiImage1.TiffAppend:=False;

    {Start Looping and Save All tif page to a new tiff file}
    if pExtension =  '.TIF' then for i:=1 to BTiffPages do begin
        PMultiImage1.TifSaveCompress:=sFAXCCITT4;
        PMultiImage1.SaveAsTIF(SaveDialog.FileName);
        {From now on start appending}
        PMultiImage1.TiffAppend:=True;
    end;

    ProgressBar1.Position:=0;
  end;
end;


(******************************************************************
Close window
******************************************************************)
procedure TTwainForm.ExitBtnClick(Sender: TObject);
begin
  Close;
end;

(******************************************************************
Stretch or Stretch ratio image
When stretched we set the parent to the panel else to a scroll box
to enable scrollbars
******************************************************************)

procedure TTwainForm.StretchImageClick(Sender: TObject);
begin
    PMultiImage1.StretchRatio:= TSpeedButton(Sender).Down;
end;


(******************************************************************
Disable or enable buttons
******************************************************************)
procedure TTwainForm.DisEn(Enb : Boolean);
begin
    nPages.Enabled:=Enb;
    NBright.Enabled:=Enb;
    NCont.Enabled:=Enb;
    SelectSourceBtn.Enabled:=Enb;
    ScanImagesBtn.Enabled:=Enb;
    ScanDocumentsBtn.Enabled:=Enb;
    TopE.Enabled:=Enb;
    LeftE.Enabled:=Enb;
    RightE.Enabled:=Enb;
    BotE.Enabled:=Enb;
    DPI.Enabled:=Enb;
    SaveBtn.Enabled:=Enb;
    StretchImagewithRatioBtn.Enabled:=Enb;
    ExitBtn.Enabled:=Enb;
    PrevTif.Enabled:=Enb;
    NextTif.Enabled:=Enb;
end;

(******************************************************************
Manage the tiffpages:  Returns The number of tif pages in a file
******************************************************************)

function TTwainForm.Get_SetTiffPages(var GotoPage : SmallInt) : SmallInt;
 Var
  BTiffPages          : SmallInt;
begin
 {Get the number of tiff pages}
 BTiffPages:=PMultiImage1.BTiffPages;
 {Cycle the pages}
 if GotoPage > BTiffPages then GotoPage:=1;
 if GotoPage < 1 then GotoPage:=BTiffPages;

 {Set the text}
 TiffCounter.Text:='Page '+IntToStr(GotoPage)+' of '+IntToStr(BTiffPages)+' page(s)';

 {Let ImageLib know which page to goto}
 PMultiImage1.TiffPage:=GotoPage;

 {Return the number of pages}
 result:=BTiffPages;
end;

(******************************************************************
Goto next or previous tif page
******************************************************************)
procedure TTwainForm.NexPrevTif(Sender: TObject);
begin
  {Depending who's clicling set the counter}
  if TSpeedButton(Sender)= NextTif then
    Inc(CurrentTiffPage)
  else
    Dec(CurrentTiffPage);
  {only when more then one page we can read in another}
  if Get_SetTiffPages(CurrentTiffPage) > 0 then begin
    PMultiImage1.ImageName:=ExtractFilePath(Application.Exename)+'TEMP.TIF';
  end;
end;


(******************************************************************
Open the Temporary file
******************************************************************)
procedure TTwainForm.OpenBtnClick(Sender: TObject);
begin
  {set the image directory}
  OpenDialog1.InitialDir:=ExtractFilePath(Application.Exename);
  {execute opendialog}
  if OpenDialog1.Execute then
    {load image}
    PMultiImage1.ImageName:= OpenDialog1.FileName;
   {reset the progressbar}
  ProgressBar1.Position:=0;
  {reset tiff counter}
  CurrentTiffPage:=1;
  Get_SetTiffPages(CurrentTiffPage);
end;



procedure TTwainForm.CheckBox4Click(Sender: TObject);
begin
     PMultiImage1.ResetImage;

     if CheckBox4.Checked then
       CheckBox4.Caption:='Panning'
     else
       CheckBox4.Caption:='Zooming';

     PMultiImage1.AllowRubberBand := not CheckBox4.Checked;
end;


procedure TTwainForm.Button1Click(Sender: TObject);
begin
     TwainCaps:=TTwainCaps.Create(Self);
     TwainCaps.ShowModal;
     TwainCaps.Free;
end;

end.



