unit MapPrintDialogUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  TMultiP, ExtCtrls, ilmitb, Dll96v1, Dllsp96, MMOpen, ILDocImg, StdCtrls,
  Buttons, RPDefine, RPBase, RPCanvas, RPrinter, Printers, ilDibCls, Mask,
  wwdbedit, Wwdotdot, Wwdbcomb, WinSpool, PrnDIB, PrnUtils;


type
  TMapPrintDialog = class(TForm)
    Panel1: TPanel;
    Image: TPMultiImage;
    Label1: TLabel;
    Label2: TLabel;
    OrientationComboBox: TComboBox;
    Label3: TLabel;
    PrintButton: TBitBtn;
    ReportPrinter: TReportPrinter;
    PrinterComboBox: TwwDBComboBox;
    PaperSizeComboBox: TwwDBComboBox;
    procedure PrinterComboBoxChange(Sender: TObject);
    procedure PrintButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    FileName : String;
    procedure PrintBitmap(X, Y, pWidth, pHeight: Integer; DibClass : ILTDib);

    Procedure ScaleBitmapToWindow;
  end;

Procedure ExecuteMapPrintDialog(MapFileName : String);

var
  MapPrintDialog: TMapPrintDialog;

implementation

{$R *.DFM}

const
  orPortrait = 0;
  orLandscape = 1;

{======================================================================}
Procedure TMapPrintDialog.PrintBitmap(X, Y, pWidth, pHeight: Integer; DibClass : ILTDib);

var
  lHorzRes, lVertRes : Integer;
  (*FDriver: PChar;
  FPort: PChar;
  FDevice: PChar;*)
  FDevice : array[0..255] of char;
  FDriver : array[0..255] of char;
  FPort : array[0..255] of char;
  DeviceMode: THandle;
  DevMode: PDeviceMode;
  hPrinter: THandle;
  PaperSize : String;
  BitmapInfo : PBITMAPINFO;      {A pointer to a BitmapInfo structure}
  Bits : pointer;                {A pointer to the bitmap bits}
  BitmapWidth : integer;         {The bitmap width}
  BitmapHeight : integer;        {The bitmap height}

begin
  Printer.PrinterIndex := PrinterComboBox.ItemIndex;

  If (OrientationComboBox.ItemIndex = orLandscape)
    then Printer.Orientation := poLandscape
    else Printer.Orientation := poPortrait;

    {FXX08202003-1(2.07i): After doing a print to screen and then doing an F3 print screen,
                           it asked for the Output File Name.  A simple refresh cures that
                           problem.}
                           
  Printer.Refresh;
    
     {Set the paper size.}
  {to get a current printer settings}

  Printer().GetPrinter(FDevice, FDriver, FPort, DeviceMode);

  If (DeviceMode = 0)
    then Printer().GetPrinter(FDevice, FDriver, FPort, DeviceMode);

  OpenPrinter(FDevice, hPrinter, nil);
  {lock a printer device}
  DevMode := GlobalLock(DeviceMode);

  If ((DevMode^.dmFields and DM_PAPERSIZE) = DM_PAPERSIZE)
    then
      begin
        DevMode^.dmFields := DevMode^.dmFields or DM_PAPERSIZE;

        PaperSize := ANSIUpperCase(PaperSizeComboBox.Items[PaperSizeComboBox.ItemIndex]);

        DevMode^.dmPaperSize := DMPAPER_LETTER;

        If ((PaperSize = 'LETTER') or
            (Pos('ANSI A', PaperSize) > 0))
          then DevMode^.dmPaperSize := DMPAPER_LETTER;

        If (PaperSize = 'LEGAL')
          then DevMode^.dmPaperSize := DMPAPER_LEGAL;

        If ((Pos('11X17', PaperSize) > 0) or
            (Pos('11 X 17', PaperSize) > 0) or
            (Pos('11" x 17"', PaperSize) > 0) or
            (Pos('11"x17"', PaperSize) > 0) or
            (Pos('LEDGER', PaperSize) > 0) or
            (Pos('TABLOID', PaperSize) > 0) or
            ((Pos('11', PaperSize) > 0) and
             (Pos('17', PaperSize) > 0)))
          then DevMode^.dmPaperSize := DMPAPER_11x17;

        If (Pos('ANSI C', PaperSize) > 0)
          then DevMode^.dmPaperSize := DMPAPER_CSHEET;

        If (Pos('ANSI D', PaperSize) > 0)
          then DevMode^.dmPaperSize := DMPAPER_DSHEET;

        If (Pos('ANSI E', PaperSize) > 0)
          then DevMode^.dmPaperSize := DMPAPER_ESHEET;

      end;  {If ((DevMode^.dmFields and DM_PAPERSIZE) = DM_PAPERSIZE)}

  {set a printer settings}
  Printer.SetPrinter(FDevice, FDriver, FPort, DeviceMode);

  {unlock a device}
  GlobalUnlock(DeviceMode);

  If (NOT LoadDIBFromFile({'test.bmp'}FileName,
                          pointer(BitmapInfo),
                          Bits,
                          BitmapWidth,
                          BitmapHeight)) then begin
      ShowMessage('Bitmap load error');
    exit;
  end;

 {Create the abort dialog}
(*  AbortDialog := CreateAbortDialog(Application.Handle, self);
  PrnDIBSetAbortDialogHandle(AbortDialog.Handle);*)

 {Lets show messages if there are problems printing the form}
  PrnDIBSetDebugMsg(TRUE);

 {Allow user to force the use of DDBs for problem printers or speed up the print job}
(*  PrnDIBSetDebugUseDDB(CheckBoxUseDDB.Checked);

  {Set print job size reduction factor}
  if (CheckBoxCompress.Checked) then begin
    PrnDIBSetOutputScaleFactor(2, 2);
  end else begin
    PrnDIBSetOutputScaleFactor(1, 1);
  end;*)

  PrnDIBSetOutputScaleFactor(1, 1);

  {Set WinScale}
(*  if (CheckBoxWinStretch.Checked) then begin
    PrnDIBSetDoWinScale(TRUE);
    PrnDIBSetOutputScaleFactor(1, 1);
  end else begin
    PrnDIBSetDoWinScale(FALSE);
  end;*)

  PrnDIBSetDoWinScale(FALSE);

  Printer.BeginDoc;

  lHORZRES:=GetDeviceCaps(Printer.Canvas.Handle, HORZRES);
  lVERTRES:=GetDeviceCaps(Printer.Canvas.Handle, VERTRES);

  PrintDIBitmapXY(Printer.Canvas.Handle,
                  0, 0,
                  lHorzRes, lVertRes,
                  BitmapInfo,
                  Bits);

   Printer.Enddoc;

end;  {PrintBitmap}

{======================================================================}
Procedure TMapPrintDialog.ScaleBitmapToWindow;

var
  BitMap      : TBitmap;
  H           : THandle;
  HPAL        : HPalette;
  hDIB        : THandle;
  F           : Integer;
  TH_w,
  TH_h        : Integer;
  Continue : Boolean;

begin
  Continue := True;
   TH_w := Image.Width; //Resize width
   TH_h := Image.Height; //Resize height
   HPAL := 0;
   F := 24;//Bits

   If (Image.Picture.Bitmap = nil)
     then Exit;

   //Get the dib

   try
     DDBTODIB(Image.Picture.Bitmap, HPAL, F, 0, hdib, 1, LongInt(Self), nil);
   except
   end;

   //Resize it here
   try
     if F >2 then begin
        H:=ScaleDibImage(hdib, TH_w, TH_h, F);  //Resize a Color  dib (AntiAliased)
     end else begin
        H:=dScaleToGray(hdib, 6, TH_w, TH_h);  //Resize a B/W dib (AntiAliased)
     end;
   except
     Continue := False;
   end;

   If Continue
     then
       begin
         //Free the dib
         GlobalFree(hdib);
         BitMap:=TBitmap.Create;

         //Get the bitmap

         try
           DibToBitmap(H, BitMap);
         except
         end;

         //Free the dib
         GlobalFree(H);

         //Assign the bitmap
         try
           Image.Picture.Bitmap.Assign(BitMap);
         except
         end;

         BitMap.Free;

       end;  {If Continue}

end;  {ScaleBitmapToWindow}

{======================================================================}
Procedure ExecuteMapPrintDialog(MapFileName : String);

begin
  try
    MapPrintDialog := TMapPrintDialog.Create(nil);

    with MapPrintDialog do
      begin
        try
          Image.ImageName := MapFileName;
          FileName := MapFileName;

          PrinterComboBox.Items.Assign(Printer.Printers);
          PrinterComboBox.Text := Printer.Printers[Printer.PrinterIndex];
          PrinterComboBoxChange(PrinterComboBox);

          OrientationComboBox.ItemIndex := orLandscape;

          ScaleBitmapToWindow;

        except
          MessageDlg('Unable to display map image ' + MapFileName + '.',
                     mtError, [mbOK], 0);
        end;

        ShowModal;

      end;  {with MapPrintDialog do}

  finally
    MapPrintDialog.Free;
  end;

  try
    DeleteFile(MapFileName);
  except
  end;

end;  {ExecuteMapPrintDialog}

{===============================================================}
Procedure TMapPrintDialog.PrinterComboBoxChange(Sender: TObject);

begin
  ReportPrinter.SelectPrinter(PrinterComboBox.Text);
  PaperSizeComboBox.Items.Assign(ReportPrinter.Papers);
  PaperSizeComboBox.ItemIndex := 0;

end;  {PrinterComboBoxChange}

{===============================================================}
Procedure TMapPrintDialog.PrintButtonClick(Sender: TObject);

{$H+}
var
   PasteHDib     : THandle;
   HIPAL         : HPalette;
   Fwidth        : SmallInt;
   FHeight       : SmallInt;
   Fbitspixel    : SmallInt;
   Fplanes       : SmallInt;
   Fnumcolors    : SmallInt;
   Filetype      : String;
   Fcompression  : String;
   DibClass      : ILTDib;

begin
   HIPAL:=0;

   GetFileInfo (Image.ImageName,Filetype,Fwidth, FHeight, Fbitspixel,Fplanes,Fnumcolors,Fcompression);

   if Uppercase(Filetype) =  'BMP' then begin
    BmpDib(Image.ImageName,
           Fbitspixel,
           0,
           @PasteHDib,
           HIPAL,
           LongInt(Self),
           Nil);
   end;

   if GlobalSize(PasteHDib) > 0 then begin
      DibClass :=ILTDib.Create;

      DibClass.DibBitmap:=PBitmapInfo(GlobalLock(PasteHDib));

      PrintBitmap(0,
                  0,
                  DibClass.Width,
                  DibClass.Height,
                  DibClass);

      DibClass.Free;
    end;

  {$H-}

  ModalResult := mrOK;

end;  {PrintButtonClick}

end.
