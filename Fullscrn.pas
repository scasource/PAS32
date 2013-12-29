unit Fullscrn;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, ExtCtrls, RPBase, RPCanvas, RPFPrint,
  RPreview, RPDefine, GlblVars, TMultiP, Printers, Math;

type
  TFullScreenViewForm = class(TForm)
    Panel2: TPanel;
    SBZoomIn: TSpeedButton;
    SBZoomOut: TSpeedButton;
    Label1: TLabel;
    SBDone: TSpeedButton;
    SBPrint: TSpeedButton;
    ScrollBox: TScrollBox;
    ZoomEdit: TEdit;
    PrintDialog: TPrintDialog;
    Image: TPMultiImage;
    SBPrevPage: TSpeedButton;
    SBNextPage: TSpeedButton;
    FirstPageButton: TSpeedButton;
    LastPageButton: TSpeedButton;
    PageEditLabel: TLabel;
    PageLabel: TLabel;
    PageEdit: TEdit;
    ZoomDisplayTimer: TTimer;
    tmrAutomaticPrint: TTimer;
    procedure SBZoomInClick(Sender: TObject);
    procedure SBZoomOutClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure SBPrintClick(Sender: TObject);
    procedure SBDoneClick(Sender: TObject);
    procedure ZoomEditExit(Sender: TObject);
    procedure ZoomEditKeyPress(Sender: TObject; var Key: Char);
    procedure SBPrevPageClick(Sender: TObject);
    procedure SBNextPageClick(Sender: TObject);
    procedure FirstPageButtonClick(Sender: TObject);
    procedure LastPageButtonClick(Sender: TObject);
    procedure PageEditExit(Sender: TObject);
    procedure PageEditKeyPress(Sender: TObject; var Key: Char);
    procedure ZoomDisplayTimerTimer(Sender: TObject);
    procedure tmrAutomaticPrintTimer(Sender: TObject);

  public
    bAutomaticPrint : Boolean;
  private
    ZoomPercent : Double;
    ImageHeight, ImageWidth : Integer;
    CurrentTiffPage, TotalTiffPages : Integer;
    ImageIsTIFF : Boolean;

    Procedure Zoom(ZoomPercent : Double);
   {Set the picture to the corresponding zoom amount.}

    Procedure RefreshPageInfo(CurrentTiffPage : Integer;
                              TotalTiffPages : Integer);

  end;

implementation

uses Utilitys, Glblcnst, WinUtils;

{$R *.DFM}

{===================================================================}
Procedure TFullScreenViewForm.RefreshPageInfo(CurrentTiffPage : Integer;
                                              TotalTiffPages : Integer);

begin
  PageLabel.Caption := 'Page ' + IntToStr(CurrentTiffPage + 1) + ' of ' +
                       IntToStr(TotalTiffPages);

  PageEdit.Text :=  IntToStr(CurrentTiffPage + 1);

end;  {RefreshPageInfo}

{===================================================================}
Procedure TFullScreenViewForm.Zoom(ZoomPercent : Double);

{Set the picture to the corresponding zoom amount.}

begin
  Image.AutoSize := False;

  Image.Width := Trunc(Roundoff((ImageWidth * (ZoomPercent / 100)), 0));
  Image.Height := Trunc(Roundoff((ImageHeight * (ZoomPercent / 100)), 0));

    {CHG07262002-1: Support for Multipage TIFF files.}

  Image.GetInfoAndType(Image.ImageName);

  ImageIsTiff := (ANSIUpperCase(Image.BFileType) = 'TIF');

  If (ImageIsTIFF and
      (Image.BTiffPages > 1))
    then
      begin
        TotalTiffPages := Image.BTiffPages;
        Image.TiffPage := 0;
        CurrentTiffPage := 0;
        SBPrevPage.Enabled := True;
        SBNextPage.Enabled := True;
        FirstPageButton.Enabled := True;
        LastPageButton.Enabled := True;
        PageLabel.Enabled := True;
        PageEditLabel.Enabled := True;
        PageEdit.Enabled := True;

        RefreshPageInfo(CurrentTiffPage, TotalTiffPages);

      end;  {If (ANSIUpperCase(Image.BFileType) = 'TIF')}

  (*Image.AutoSize := True;*)

(*  TempNum := Trunc(Roundoff((ImageWidth * (ZoomPercent / 100)), 0));
  TempNum := Trunc(Roundoff((ImageHeight * (ZoomPercent / 100)), 0));
  ScrollBox.HorzScrollBar.Range := Trunc(Roundoff((ImageWidth * (ZoomPercent / 100)), 0));
  ScrollBox.VertScrollBar.Range := Trunc(Roundoff((ImageHeight * (ZoomPercent / 100)), 0))*);

  with ScrollBox do
    begin
      If (Image.Width > ScrollBox.Width)
        then ScrollBox.HorzScrollBar.Range := Image.Width
        else ScrollBox.HorzScrollBar.Range := 0;

      If (Image.Height > ScrollBox.Height)
        then ScrollBox.VertScrollBar.Range := Image.Height
        else ScrollBox.VertScrollBar.Range := 0;

    end;  {with ScrollBox do}

  ZoomEdit.Text := FormatFloat(CurrencyEditDisplay, ZoomPercent);

end;  {Zoom}

{===================================================================}
Procedure TFullScreenViewForm.FormActivate(Sender: TObject);

begin
  WindowState := wsMaximized;
  ZoomDisplayTimer.Enabled := True;
end;  {FormActivate}

{===================================================================}
Procedure TFullScreenViewForm.ZoomDisplayTimerTimer(Sender: TObject);

begin
  ZoomDisplayTimer.Enabled := False;
   {Set up the original size of the picture.}

  Image.GetInfoAndType(Image.ImageName);
  ImageWidth := Image.BWidth;
  ImageHeight := Image.BHeight;

  ZoomPercent := Min(Trunc((ScrollBox.Width / ImageWidth) * 100),
                     Trunc((ScrollBox.Height / ImageHeight) * 100));
  Zoom(ZoomPercent);

  If bAutomaticPrint
    then tmrAutomaticPrint.Enabled := True;

end;  {ZoomDisplayTimerTimer}

{===================================================================}
Procedure TFullScreenViewForm.SBZoomInClick(Sender: TObject);

begin
  If (ZoomPercent < 200)
    then
      begin
        ZoomPercent := ZoomPercent + 10;
        Zoom(ZoomPercent);
      end;

end;  {SBZoomInClick}

{===================================================================}
Procedure TFullScreenViewForm.SBZoomOutClick(Sender: TObject);

begin
  If (ZoomPercent > 10)
    then
      begin
        ZoomPercent := ZoomPercent - 10;
        Zoom(ZoomPercent);
      end;

end;  {SBZoomOutClick}

{===================================================================}
Procedure TFullScreenViewForm.ZoomEditExit(Sender: TObject);

var
  NewValue : Double;
  ErrCode: Integer;

begin
  Val(ZoomEdit.Text, NewValue, ErrCode);

  If ((ErrCode = 0) and
      (ZoomPercent <> NewValue))
    then
      begin
        ZoomPercent := NewValue;
        Zoom(ZoomPercent);
      end;

end;  {ZoomEditExit}

{===================================================================}
Procedure TFullScreenViewForm.ZoomEditKeyPress(    Sender: TObject;
                                               var Key: Char);

begin
  If (Key = #13)
    then ZoomEditExit(Sender);

end;  {ZoomEditKeyPress}

{===================================================================}
Procedure TFullScreenViewForm.SBPrevPageClick(Sender: TObject);

begin
  If (CurrentTiffPage > 0)
    then
      begin
        CurrentTiffPage := CurrentTiffPage - 1;
        Image.TiffPage := CurrentTiffPage;
        Image.ImageName := Image.ImageName;
        RefreshPageInfo(CurrentTiffPage, TotalTiffPages);

      end;  {If (CurrentTiffPage > 0)}

end;  {SBPrevPageClick}

{===================================================================}
Procedure TFullScreenViewForm.SBNextPageClick(Sender: TObject);

begin
  If (CurrentTiffPage < (TotalTiffPages - 1))
    then
      begin
        CurrentTiffPage := CurrentTiffPage + 1;
        Image.TiffPage := CurrentTiffPage;
        Image.ImageName := Image.ImageName;
        RefreshPageInfo(CurrentTiffPage, TotalTiffPages);

      end;  {If (CurrentTiffPage < (TotalTiffPages - 1))}

end;  {SBNextPageClick}

{===================================================================}
Procedure TFullScreenViewForm.FirstPageButtonClick(Sender: TObject);

begin
  CurrentTiffPage := 0;
  Image.TiffPage := CurrentTiffPage;
  Image.ImageName := Image.ImageName;
  RefreshPageInfo(CurrentTiffPage, TotalTiffPages);

end;  {FirstPageButtonClick}

{===================================================================}
Procedure TFullScreenViewForm.LastPageButtonClick(Sender: TObject);

begin
  CurrentTiffPage := TotalTiffPages;
  Image.TiffPage := CurrentTiffPage;
  Image.ImageName := Image.ImageName;
  RefreshPageInfo(CurrentTiffPage, TotalTiffPages);

end;  {LastPageButtonClick}

{===================================================================}
Procedure TFullScreenViewForm.PageEditExit(Sender: TObject);

var
  NewPage : Integer;
  Continue : Boolean;

begin
  Continue := True;
  NewPage := 0;

  try
    NewPage := StrToInt(PageEdit.Text);
  except
    Continue := False;
  end;

  If (Continue and
      (NewPage >= 0) and
      (NewPage <= (TotalTiffPages - 1)))
    then
      begin
        CurrentTiffPage := NewPage;
        Image.TiffPage := CurrentTiffPage;
        Image.ImageName := Image.ImageName;
        RefreshPageInfo(CurrentTiffPage, TotalTiffPages);

      end;  {If (Continue and ...}

end;  {PageEditExit}

{===================================================================}
Procedure TFullScreenViewForm.PageEditKeyPress(    Sender: TObject;
                                               var Key: Char);

begin
  If (Key = #13)
    then PageEditExit(Sender);
end;

{===================================================================}
Procedure TFullScreenViewForm.SBPrintClick(Sender: TObject);

{FXX08172002-1: Don't scale the print for TIFF images - these
                are documents that should print full screen.}

begin
  try
    Printer.Refresh;
  except
  end;

  try
    Printer.PrinterIndex := 0;
  except
  end;

  If PrintDialog.Execute
    then PrintImage(Image, Handle, 0, 0, 6360, 4900,(*Printer.PageWidth, Printer.PageHeight, *)
                    0, 999, (not ImageIsTIFF));

end;  {SBPrintClick}

{===================================================================}
Procedure TFullScreenViewForm.SBDoneClick(Sender: TObject);

begin
  Close;
end;

{=====================================================================}
Procedure TFullScreenViewForm.tmrAutomaticPrintTimer(Sender: TObject);

begin
  tmrAutomaticPrint.Enabled := False;
  SBPrintClick(nil);
  Close;
end;

end.


