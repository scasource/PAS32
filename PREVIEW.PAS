unit Preview;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, ExtCtrls, RPBase, RPCanvas, RPFPrint,
  RPreview, RPDefine, GlblVars, Winutils;

type
  TPreviewForm = class(TForm)
    Panel2: TPanel;
    SBZoomIn: TSpeedButton;
    SBZoomOut: TSpeedButton;
    Label1: TLabel;
    SBPrevPage: TSpeedButton;
    SBNextPage: TSpeedButton;
    Label2: TLabel;
    FilePreview: TFilePreview;
    FilePrinter: TFilePrinter;
    SBDone: TSpeedButton;
    SBPrint: TSpeedButton;
    ScrollBox1: TScrollBox;
    ZoomEdit: TEdit;
    SBZoomPageWidth: TSpeedButton;
    SBZoomPage: TSpeedButton;
    PageEdit: TEdit;
    PageLabel: TLabel;
    PrinterSetupDialog: TPrinterSetupDialog;
    FirstPageButton: TSpeedButton;
    LastPageButton: TSpeedButton;
    PrintDialog: TPrintDialog;
    procedure SBZoomInClick(Sender: TObject);
    procedure SBZoomOutClick(Sender: TObject);
    procedure SBPrevPageClick(Sender: TObject);
    procedure SBNextPageClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure SBPrintClick(Sender: TObject);
    procedure SBDoneClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SBZoomPageWidthClick(Sender: TObject);
    procedure SBZoomPageClick(Sender: TObject);
    procedure FilePreviewPageChange(Sender: TObject);
    procedure FilePreviewZoomChange(Sender: TObject);
    procedure ZoomEditExit(Sender: TObject);
    procedure PageEditExit(Sender: TObject);
    procedure ZoomEditKeyPress(Sender: TObject; var Key: Char);
    procedure PageEditKeyPress(Sender: TObject; var Key: Char);
    procedure FirstPageButtonClick(Sender: TObject);
    procedure LastPageButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  end;

var
  PreviewForm: TPreviewForm;

implementation

{$R *.DFM}

procedure TPreviewForm.SBZoomInClick(Sender: TObject);
begin
  FilePreview.ZoomIn;
end;

procedure TPreviewForm.SBZoomOutClick(Sender: TObject);
begin
  FilePreview.ZoomOut;
end;

procedure TPreviewForm.SBPrevPageClick(Sender: TObject);
begin
  FilePreview.PrevPage;
end;

procedure TPreviewForm.SBNextPageClick(Sender: TObject);
begin
  FilePreview.NextPage;
end;

procedure TPreviewForm.FormActivate(Sender: TObject);
begin
    {FXX04091999-7: The following line is to prevent the progress dialog from appearing
                    when switch from PAS and then back to Preview form.}

  ScrollBox1.SetFocus;
  FilePreview.Start;

   {Make full page visible.}
   {FXX10272001-1: If there is no zoom factor in the user record, make it 100.}

  With FilePreview do
    If (GlblDefaultPreviewZoomPercent = 0)
      then ZoomFactor := 0
      else ZoomFactor := GlblDefaultPreviewZoomPercent;

end;

{======================================================}
Procedure TPreviewForm.SBPrintClick(Sender: TObject);

var
  _Copies, _FirstPage, _LastPage : Integer;

begin
    {FXX08031999-3: Allow users to specify ranges, copies.}

  If PrintDialog.Execute
    then
      begin
        with FilePrinter as TBaseReport do
          begin
            _Copies := PrintDialog.Copies;

            _FirstPage := 1;
            _LastPage := 32000;

            If (PrintDialog.ToPage > 0)
              then
                begin
                  _FirstPage := PrintDialog.FromPage;
                  _LastPage := PrintDialog.ToPage;
                end;

          end;  { with FilePrinter as TBaseReport do}

(*        FilePrinter.Execute; *)

          {FXX04282000-2: Multiple copies from preview screen not working.}
          {FXX04022001-3: Reinstate copies.}

        If (PrintDialog.PrintRange = prAllPages)
          then FilePrinter.Execute
          else FilePrinter.ExecuteCustom(_FirstPage, _LastPage, _Copies);

          {FXX09071999-6: Tell people that printing is starting and
                          done.}

        DisplayPrintingFinishedMessage(PrintDialog.PrintToFile);

      end;  {If PrintDialog.Execute}

end;  {SBPrintClick}

procedure TPreviewForm.SBDoneClick(Sender: TObject);
begin
  Close;
end;

procedure TPreviewForm.FormClose(    Sender: TObject;
                                 var Action: TCloseAction);
begin
  FilePreview.Finish;
end;

procedure TPreviewForm.SBZoomPageWidthClick(Sender: TObject);
begin
  With FilePreview do begin
    ZoomFactor := ZoomPageWidthFactor;
  end; { with }
end;

procedure TPreviewForm.SBZoomPageClick(Sender: TObject);
begin
  With FilePreview do begin
    ZoomFactor := ZoomPageFactor;
  end; { with }
end;

procedure TPreviewForm.FilePreviewPageChange(Sender: TObject);

begin
  With FilePreview do begin
    PageEdit.Text := IntToStr(CurrentPage);
    PageLabel.Caption := 'Page ' + IntToStr(CurrentPage - FirstPage + 1) +
     ' of ' + IntToStr(Pages);
  end; { with }
end;

procedure TPreviewForm.FilePreviewZoomChange(Sender: TObject);

var
  S1: string[10];

begin
  Str(FilePreview.ZoomFactor:1:1,S1);
  ZoomEdit.Text := S1;
  FilePreview.RedrawPage;
end;

procedure TPreviewForm.ZoomEditExit(Sender: TObject);

var
  F1: double;
  ErrCode: integer;

begin
  Val(ZoomEdit.Text,F1,ErrCode);
  If (ErrCode = 0) and (FilePreview.ZoomFactor <> F1) then begin
    FilePreview.ZoomFactor := F1;
  end; { if }
end;

procedure TPreviewForm.PageEditExit(Sender: TObject);

var
  I1: integer;
  ErrCode: integer;

begin
  Val(PageEdit.Text,I1,ErrCode);
  If (ErrCode = 0) and (FilePreview.CurrentPage <> I1) then begin
    FilePreview.PrintPage(I1);
  end; { if }
end;

procedure TPreviewForm.ZoomEditKeyPress(Sender: TObject; var Key: Char);
begin
  If Key = #13 then begin
    ZoomEditExit(Sender);
  end; { if }
end;

procedure TPreviewForm.PageEditKeyPress(Sender: TObject; var Key: Char);
begin
  If Key = #13 then begin
    PageEditExit(Sender);
  end; { if }
end;

{Added by MDT.}

procedure TPreviewForm.FirstPageButtonClick(Sender: TObject);

begin
  If (FilePreview.CurrentPage <> 1) then
    FilePreview.PrintPage(1);
end;

procedure TPreviewForm.LastPageButtonClick(Sender: TObject);

begin
  If (FilePreview.CurrentPage <> FilePreview.Pages) then
    FilePreview.PrintPage(FilePreview.Pages);

end;

procedure TPreviewForm.FormShow(Sender: TObject);
begin
    {FXX04091999-7: Problem where progress dialog would come back up if shifted away from
                    PAS and then back while Preview form was up.}

  ScrollBox1.SetFocus;
end;

end.


