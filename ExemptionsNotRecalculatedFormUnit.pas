unit ExemptionsNotRecalculatedFormUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Grids, RPCanvas, RPrinter, RPDefine, RPBase, RPFiler, Buttons,
  ComCtrls;

type
  TExemptionsNotRecalculatedForm = class(TForm)
    Label1: TLabel;
    PrintButton: TBitBtn;
    ReportFiler: TReportFiler;
    ReportPrinter: TReportPrinter;
    PrintDialog: TPrintDialog;
    ExemptionsListView: TListView;
    procedure ReportPrintHeader(Sender: TObject);
    procedure ReportPrint(Sender: TObject);
    procedure PrintButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    ExemptionsNotRecalculatedList : TStringList;

    Procedure InitializeForm;
  end;

var
  ExemptionsNotRecalculatedForm: TExemptionsNotRecalculatedForm;

implementation

{$R *.DFM}

uses PASUtils, GlblCnst, Preview, WinUtils, PASTypes, Utilitys;

{=====================================================================}
Procedure TExemptionsNotRecalculatedForm.InitializeForm;

var
  Index : Integer;
  ParcelID, ExemptionCode : String;

begin
  Index := 0;

  while(Index < (ExemptionsNotRecalculatedList.Count - 1)) do
    begin
      ParcelID := ConvertSBLOnlyToDashDot(Copy(ExemptionsNotRecalculatedList[Index], 7, 20));
      Inc(Index);
      ExemptionCode := ExemptionsNotRecalculatedList[Index];
      Inc(Index);

      FillInListViewRow(ExemptionsListView, [ParcelID, ExemptionCode], False);

    end;  {while(Index < (ExemptionsNotRecalculatedList.Count - 1)) do}

end;  {InitializeForm}

{========================================================}
Procedure TExemptionsNotRecalculatedForm.ReportPrintHeader(Sender: TObject);

begin
  with Sender as TBaseReport do
    begin
        {Print the date and page number.}

      SectionTop := 0.25;
      SectionLeft := 0.5;
      SectionRight := PageWidth - 0.5;
      SetFont('Times New Roman',8);
      PrintHeader('Page: ' + IntToStr(CurrentPage), pjRight);
      PrintHeader('Date: ' + DateToStr(Date) +
                  '  Time: ' + FormatDateTime(TimeFormat, Now), pjLeft);

      SectionTop := 0.5;
      SetFont('Arial',14);
      Underline := True;
      Home;
      CRLF;
      PrintCenter('Exemptions not Recalculated ', (PageWidth / 2));
      SetFont('Times New Roman', 12);
      CRLF;
      CRLF;

      Underline := False;
      ClearTabs;
      Bold := True;
      SetTab(0.5, pjCenter, 1.5, 0, BoxLineBottom, 0);   {Parcel 1}
      SetTab(2.1, pjCenter, 0.5, 0, BoxLineBottom, 0);   {Exemption Code}
      SetTab(3.0, pjCenter, 1.5, 0, BoxLineBottom, 0);   {Parcel 2}
      SetTab(4.6, pjCenter, 0.5, 0, BoxLineBottom, 0);   {Exemption Code}
      SetTab(5.5, pjCenter, 1.5, 0, BoxLineBottom, 0);   {Parcel 3}
      SetTab(7.1, pjCenter, 0.5, 0, BoxLineBottom, 0);   {Exemption Code}

      Println(#9 + 'Parcel ID' +
              #9 + 'Code' +
              #9 + 'Parcel ID' +
              #9 + 'Code' +
              #9 + 'Parcel ID' +
              #9 + 'Code');

      Bold := False;

      ClearTabs;
      SetTab(0.5, pjLeft, 1.5, 0, BOXLINENONE, 0);   {Parcel 1}
      SetTab(2.1, pjLeft, 0.5, 0, BOXLINENONE, 0);   {Exemption Code}
      SetTab(3.0, pjLeft, 1.5, 0, BOXLINENONE, 0);   {Parcel 2}
      SetTab(4.6, pjLeft, 0.5, 0, BOXLINENONE, 0);   {Exemption Code}
      SetTab(5.5, pjLeft, 1.5, 0, BOXLINENONE, 0);   {Parcel 3}
      SetTab(7.1, pjLeft, 0.5, 0, BOXLINENONE, 0);   {Exemption Code}

    end;  {with Sender as TBaseReport do}

end;  {ReportPrintHeader}

{========================================================================}
Procedure TExemptionsNotRecalculatedForm.ReportPrint(Sender: TObject);

var
  I, Index : Integer;

begin
  Index := 0;

  with Sender as TBaseReport do
    while _Compare(Index, (ExemptionsNotRecalculatedList.Count - 1), coLessThan) do
      begin
        For I := 1 to 3 do
          begin
            If _Compare(Index, (ExemptionsNotRecalculatedList.Count - 1), coLessThan)
              then
                begin
                  Print(#9 + ConvertSBLOnlyToDashDot(Copy(ExemptionsNotRecalculatedList[Index], 7, 20)));
                  Inc(Index);
                  Print(#9 + ExemptionsNotRecalculatedList[Index]);
                  Inc(Index);

                end;  {If _Compare(Index, ...}

          end;  {For I := 1 to 3 do}

        Println('');

        If (LinesLeft < 5)
          then NewPage;

      end;  {while _Compare(Index, (ExemptionsNotRecalculatedList.Count - 1), coLessThan) do}

end;  {ReportPrint}

{=====================================================================}
Procedure TExemptionsNotRecalculatedForm.PrintButtonClick(Sender: TObject);

var
  NewFileName : String;
  Quit : Boolean;

begin
  If PrintDialog.Execute
    then
      begin
        AssignPrinterSettings(PrintDialog, ReportPrinter, ReportFiler, [ptBoth], False, Quit);

        If not Quit
          then
            begin
                {If they want to preview the print (i.e. have it
                 go to the screen), then we need to come up with
                 a unique file name to tell the ReportFiler
                 component where to put the output.
                 Once we have done that, we will execute the
                 report filer which will print the report to
                 that file. Then we will create and show the
                 preview print form and give it the name of the
                 file. When we are done, we will delete the file
                 and make sure that we go back to the original
                 directory.}

              If PrintDialog.PrintToFile
                then
                  begin
                    NewFileName := GetPrintFileName(Self.Caption, True);
                    ReportFiler.FileName := NewFileName;

                    try
                      PreviewForm := TPreviewForm.Create(self);
                      PreviewForm.FilePrinter.FileName := NewFileName;
                      PreviewForm.FilePreview.FileName := NewFileName;

                      ReportFiler.Execute;

                      PreviewForm.ShowModal;
                    finally
                      PreviewForm.Free;
                    end;  {If PrintRangeDlg.PreviewPrint}

                  end  {They did not select preview, so we will go
                        right to the printer.}
                else ReportPrinter.Execute;

            end;  {If not Quit}

        ResetPrinter(ReportPrinter);

      end;  {If PrintDialog.Execute}

end;  {PrintButtonClick}

end.
