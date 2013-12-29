unit RecalculateSquareFootLivingArea;

{To use this template:
  1. Save the form it under a new name.
  2. Rename the form in the Object Inspector.
  3. Rename the table in the Object Inspector. Then switch
     to the code and do a blanket replace of "Table" with the new name.
  4. Change UnitName to the new unit name.}

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, DBCtrls, DBTables, DB, Buttons, Grids,
  Wwdbigrd, Wwdbgrid, ExtCtrls, Wwtable, Wwdatsrc, Menus, (*Progress,*)
  RPCanvas, RPrinter, RPDefine, RPBase, RPFiler;

type
  TRecalculateSquareFootLivingAreaForm = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    ScrollBox1: TScrollBox;
    CloseButton: TBitBtn;
    TitleLabel: TLabel;
    StartButton: TBitBtn;
    Label7: TLabel;
    ReportFiler: TReportFiler;
    ReportPrinter: TReportPrinter;
    ChooseTaxYearRadioGroup: TRadioGroup;
    PrintDialog: TPrintDialog;
    ResidentialBuildingTable: TTable;
    ParcelTable: TTable;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure StartButtonClick(Sender: TObject);
    procedure ReportPrint(Sender: TObject);
    procedure ReportHeader(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    UnitName : String;
    ProcessingType : Integer;
    Procedure InitializeForm;  {Open the tables and setup.}

  end;

implementation

uses GlblVars, WinUtils, Utilitys, GlblCnst, PASUTILS, Types,
     PASTypes, Prog,
     Preview;

const
  TrialRun = False;

{$R *.DFM}

{========================================================}
Procedure TRecalculateSquareFootLivingAreaForm.FormActivate(Sender: TObject);

begin
  SetFormStateMaximized(Self);
end;

{========================================================}
Procedure TRecalculateSquareFootLivingAreaForm.InitializeForm;

begin
  UnitName := 'RecalculateSquareFootLivingAreaForm.PAS';  {mmm}
end;  {InitializeForm}

{=================================================================}
Procedure TRecalculateSquareFootLivingAreaForm.StartButtonClick(Sender: TObject);

var
  NewFileName : String;
  TempFile : File;
  Quit : Boolean;

begin
  ProcessingType := -1;

  case ChooseTaxYearRadioGroup.ItemIndex of
    0 : ProcessingType := ThisYear;
    1 : ProcessingType := NextYear;
    else MessageDlg('Please choose an assessment year.', mtError, [mbOK], 0);

  end;  {case ChooseTaxYearRadioGroup.ItemIndex of}

  If ((ProcessingType <> -1) and
      (MessageDlg('Are you sure you want to recalculate the square foot living area?',
                  mtConfirmation, [mbYes, mbNo], 0) = idYes) and
      PrintDialog.Execute)
    then
      begin
        OpenTableForProcessingType(ResidentialBuildingTable, ResidentialBldgTableName,
                                   ProcessingType, Quit);
        OpenTableForProcessingType(parcelTable, ParcelTableName,
                                   ProcessingType, Quit);

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

                  {Now delete the file.}
                try
                  AssignFile(TempFile, NewFileName);
                  OldDeleteFile(NewFileName);
                finally
                  {We don't care if it does not get deleted, so we won't put up an
                   error message.}

                  ChDir(GlblProgramDir);
                end;

              end;  {If PrintRangeDlg.PreviewPrint}

            end  {They did not select preview, so we will go
                  right to the printer.}
          else ReportPrinter.Execute;

        CloseTablesForForm(Self);

      end;  {If ((MessageDlg(' ...}

end;  {StartButtonClick}

{===================================================================}
Procedure TRecalculateSquareFootLivingAreaForm.ReportHeader(Sender: TObject);

begin
  with Sender as TBaseReport do
    begin
        {Print the date and page number.}

      SectionTop := 0.25;
      SectionLeft := 0.5;
      SectionRight := PageWidth - 0.5;
      SetFont('Times New Roman',8);
      PrintHeader('Page: ' + IntToStr(CurrentPage), pjRight);
      PrintHeader('Date: ' + DateToStr(Date) + '  Time: ' + TimeToStr(Now), pjLeft);

      SectionTop := 0.5;
      SetFont('Arial',12);
      Bold := True;
      Home;
      PrintCenter('Square Foot Living Areas Changed Due To Recalculation', (PageWidth / 2));
      SetFont('Times New Roman', 9);
      CRLF;

      Underline := False;
      ClearTabs;
      SetTab(0.2, pjCenter, 1.5, 0, BOXLINEBOTTOM, 0);   {Parcel ID}
      SetTab(1.8, pjCenter, 1.5, 0, BOXLINEBOTTOM, 0);   {Name}
      SetTab(3.4, pjCenter, 1.0, 0, BOXLINEBOTTOM, 0);   {Orig lving area}
      SetTab(4.5, pjCenter, 1.0, 0, BOXLINEBottom, 0);     {New Lving Area}

      Println(#9 + 'Parcel ID' +
              #9 + 'Name' +
              #9 + 'Orig SFLA' +
              #9 + 'New SFLA');

      ClearTabs;
      SetTab(0.2, pjLeft, 1.5, 0, BOXLINENone, 0);   {Parcel ID}
      SetTab(1.8, pjLeft, 1.5, 0, BOXLINENone, 0);   {Name}
      SetTab(3.4, pjRight, 1.0, 0, BOXLINENone, 0);   {Orig lving area}
      SetTab(4.5, pjRight, 1.0, 0, BOXLINENone, 0);     {New Lving Area}

    end;  {with Sender as TBaseReport do}

end;  {ReportHeader}

{===================================================================}
Procedure TRecalculateSquareFootLivingAreaForm.ReportPrint(Sender: TObject);

{CHG11241997-2: Print an audit trail.}

var
  FirstTimeThrough, Done : Boolean;
  AssessmentYear : String;
  SwisSBLKey : String;
  OldSFLA, NewSFLA : LongInt;
  SBLRec : SBLRecord;

begin
  FirstTimeThrough := True;
  Done := False;
  AssessmentYear := GetTaxRollYearForProcessingType(ProcessingType);

  ProgressDialog.UserLabelCaption := 'Recalculating Square Foot Living Area.';
  ProgressDialog.Start(GetRecordCount(ResidentialBuildingTable), True, True);

  ResidentialBuildingTable.First;

  with Sender as TBaseReport do
    repeat
      If FirstTimeThrough
        then FirstTimeThrough := False
        else ResidentialBuildingTable.Next;

      If ResidentialBuildingTable.EOF
        then Done := True;

      SwisSBLKey := ResidentialBuildingTable.FieldByName('SwisSBLKey').Text;
      ProgressDialog.Update(Self, ConvertSwisSBLToDashDot(SwisSBLKey));
      Application.ProcessMessages;

      OldSFLA := ResidentialBuildingTable.FieldByName('SqFootLivingArea').AsInteger;
      NewSFLA := CalculateSquareFootLivingArea(ResidentialBuildingTable);

      If ((not Done) and
          (OldSFLA <> NewSFLA))
        then
          begin
            SBLRec := ExtractSwisSBLFromSwisSBLKey(SwisSBLKey);

            with SBLRec do
              FindKeyOld(ParcelTable,
                         ['TaxRollYr', 'SwisCode', 'Section', 'Subsection',
                          'Block', 'Lot', 'Sublot', 'Suffix'],
                         [AssessmentYear, SwisCode, Section, Subsection,
                          Block, Lot, Sublot, Suffix]);

            If (LinesLeft < 5)
              then NewPage;

            Println(#9 + ConvertSwisSBLToDashDot(SwisSBLKey) +
                    #9 + Take(15, ParcelTable.FieldByName('Name1').Text) +
                    #9 + IntToStr(OldSFLA) +
                    #9 + IntToStr(NewSFLA));

            with ResidentialBuildingTable do
              try
                Edit;
                FieldByName('SqFootLivingArea').AsInteger := NewSFLA;
                Post;
              except
                SystemSupport(001, ResidentialBuildingTable,
                              'Error updating square foot living area for parcel ' +
                              ConvertSwisSBLToDashDot(SwisSBLKey) + '.',
                              UnitName, GlblErrorDlgBox);

              end;


          end;  {If ((not Done) and ...}

    until (Done or ProgressDialog.Cancelled);

  ProgressDialog.Finish;

  MessageDlg('The square foot living areas have now been recalculated.',
             mtInformation, [mbOK], 0);

end;  {ReportPrint}

{===================================================================}
Procedure TRecalculateSquareFootLivingAreaForm.FormClose(    Sender: TObject;
                                                var Action: TCloseAction);

begin
    {Free up the child window and set the ClosingAForm Boolean to
     true so that we know to delete the tab.}

  Action := caFree;
  GlblClosingAForm := True;
  GlblClosingFormCaption := Caption;

end;  {FormClose}

end.