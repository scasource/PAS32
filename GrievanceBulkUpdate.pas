unit GrievanceBulkUpdate;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, DBCtrls,  DB, Buttons, Grids,
  Wwdbigrd, Wwdbgrid, ExtCtrls, Wwdatsrc, Menus,
  DBTables, Wwtable, Btrvdlg, RPFiler, RPBase, RPCanvas, RPrinter, Mask,
  Gauges, RPMemo, RPDBUtil, RPDefine, (*Progress,*) Types, RPTXFilr, PASTypes,
  Progress, TabNotBk, ComCtrls, Tabs;

type
  TGrievanceResultsBulkUpdateForm = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    ScrollBox: TScrollBox;
    CloseButton: TBitBtn;
    TitleLabel: TLabel;
    ReportPrinter: TReportPrinter;
    ReportFiler: TReportFiler;
    PrintDialog: TPrintDialog;
    StartButton: TBitBtn;
    GrievanceResultsTable: TwwTable;
    Label1: TLabel;
    Label2: TLabel;
    TrialRunCheckBox: TCheckBox;
    GrievanceTable: TTable;
    GrievanceDispositionCodeTable: TwwTable;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure ReportPrintHeader(Sender: TObject);
    procedure StartButtonClick(Sender: TObject);
    procedure CloseButtonClick(Sender: TObject);
    procedure ReportPrint(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    ReportCancelled : Boolean;

    { Public declarations }
    UnitName : String;

    GrievanceYear : String;
    TrialRun : Boolean;
    ReportSection : Char;

    Procedure InitializeForm;  {Open the ScreenLabelTables and setup.}

  end;

implementation

Uses Utilitys,  {General utilitys}
     PASUTILS, UTILEXSD,   {PAS specific utilitys}
     GlblCnst,  {Global constants}
     GlblVars,  {Global variables}
     WinUtils,  {General Windows utilitys}
     Prog,
     RptDialg,
     GrievanceUtilitys,
     Preview;

type
  ErrorRecord = record
    SwisSBLKey : String;
    GrievanceNumber : Integer;
    ErrorMessage : String;
  end;

  ErrorPointer = ^ErrorRecord;

{$R *.DFM}

{========================================================}
Procedure TGrievanceResultsBulkUpdateForm.FormActivate(Sender: TObject);

begin
  SetFormStateMaximized(Self);
end;

{========================================================}
Procedure TGrievanceResultsBulkUpdateForm.InitializeForm;

begin
  UnitName := 'GrievanceBulkUpdate';  {mmm}
  GrievanceYear := DetermineGrievanceYear;

  OpenTablesForForm(Self, GlblProcessingType);

end;  {InitializeForm}

{===================================================================}
Procedure TGrievanceResultsBulkUpdateForm.FormKeyPress(    Sender: TObject;
                                     var Key: Char);

begin
  If (Key = #13)
    then
      begin
        Key := #0;
        Perform(WM_NEXTDLGCTL, 0, 0);
      end;

end;  {FormKeyPress}

{======================================================================}
Procedure TGrievanceResultsBulkUpdateForm.StartButtonClick(Sender: TObject);

var
  NewFileName : String;
  Quit : Boolean;

begin
  ReportCancelled := False;
  Quit := False;

    {CHG10121998-1: Add user options for default destination and show vet max msg.}

  SetPrintToScreenDefault(PrintDialog);

  If PrintDialog.Execute
    then
      begin
        TrialRun := TrialRunCheckBox.Checked;
        ReportSection := 'M';

          {CHG10131998-1: Set the printer settings based on what printer they selected
                          only - they no longer need to worry about paper or landscape
                          mode.}

        AssignPrinterSettings(PrintDialog, ReportPrinter, ReportFiler, [ptBoth], True, Quit);

        If not Quit
          then
            begin
              ProgressDialog.UserLabelCaption := '';
              ProgressDialog.Start(GetRecordCount(GrievanceResultsTable), True, True);

                {Now print the report.}

              If not (Quit or ReportCancelled)
                then
                  begin
                    GlblPreviewPrint := False;

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

                      {FXX07221998-1: So that more than one person can run the report
                                      at once, use a time based name first and then
                                      rename.}

                      {If they want to see it on the screen, start the preview.}

                    If PrintDialog.PrintToFile
                      then
                        begin
                          GlblPreviewPrint := True;
                          NewFileName := GetPrintFileName(Self.Caption, True);
                          ReportFiler.FileName := NewFileName;

                          try
                            PreviewForm := TPreviewForm.Create(self);
                            PreviewForm.FilePrinter.FileName := NewFileName;
                            PreviewForm.FilePreview.FileName := NewFileName;

                            PreviewForm.FilePreview.ZoomFactor := 130;

                            ReportFiler.Execute;

                              {FXX09071999-6: Tell people that printing is starting and
                                              done.}

                            ProgressDialog.StartPrinting(PrintDialog.PrintToFile);

                            PreviewForm.ShowModal;
                          finally
                            PreviewForm.Free;
                          end;

                            {Delete the report printer file.}

                          try
                            Chdir(GlblReportDir);
                            OldDeleteFile(NewFileName);
                          except
                          end;

                        end
                      else ReportPrinter.Execute;

                  end;  {If not Quit}

                {Clear the selections.}

              ProgressDialog.Finish;

                {FXX09071999-6: Tell people that printing is starting and
                                done.}

              DisplayPrintingFinishedMessage(PrintDialog.PrintToFile);

            end;  {If not Quit}

        ResetPrinter(ReportPrinter);

      end;  {If PrintDialog.Execute}

end;  {PrintButtonClick}

{====================================================================}
Procedure AddErrorRecord(ErrorList : TList;
                         _SwisSBLKey : String;
                         _GrievanceNumber : Integer;
                         _ErrorMessage : String);

var
  ErrorPtr : ErrorPointer;

begin
  New(ErrorPtr);

  with ErrorPtr^ do
    begin
      SwisSBLKey := _SwisSBLKey;
      GrievanceNumber := _GrievanceNumber;
      ErrorMessage := _ErrorMessage;

    end;  {with ErrorPtr^ do}

  ErrorList.Add(ErrorPtr);

end;  {AddErrorRecord}

{====================================================================}
Procedure PrintTotals(Sender : TObject;
                      OverallLandValueChange,
                      OverallTotalValueChange,
                      OverallCountyTaxableChange,
                      OverallTownTaxableChange,
                      OverallSchoolTaxableChange,
                      OverallVillageTaxableChange : Comp);

begin
  with Sender as TBaseReport do
    begin
      Bold := True;
      ClearTabs;
      SetTab(1.0, pjCenter, 1.0, 0, BOXLINEBottom, 0);   {Land Change}
      SetTab(2.1, pjCenter, 1.2, 0, BOXLINEBottom, 0);   {Total Change}
      SetTab(3.4, pjCenter, 1.2, 0, BOXLINEBottom, 0);   {County Change}
      SetTab(4.7, pjCenter, 1.2, 0, BOXLINEBottom, 0);   {Town Change}
      SetTab(6.0, pjCenter, 1.2, 0, BOXLINEBottom, 0);   {School Change}
      SetTab(7.3, pjCenter, 1.2, 0, BOXLINEBottom, 0);   {Village Change}

      Println(#9 + '    Overall Changes:');
      Println(#9 + 'Land AV' +
              #9 + 'Total AV' +
              #9 + 'County Txbl' +
              #9 + 'Town Txbl' +
              #9 + 'School Txbl' +
              #9 + 'Village Txbl');

      Bold := False;

      ClearTabs;
      SetTab(1.0, pjRight, 1.0, 0, BOXLINENone, 0);   {Land Change}
      SetTab(2.1, pjRight, 1.2, 0, BOXLINENone, 0);   {Total Change}
      SetTab(3.4, pjRight, 1.2, 0, BOXLINENone, 0);   {County Change}
      SetTab(4.7, pjRight, 1.2, 0, BOXLINENone, 0);   {Town Change}
      SetTab(6.0, pjRight, 1.2, 0, BOXLINENone, 0);   {School Change}
      SetTab(7.3, pjRight, 1.2, 0, BOXLINENone, 0);   {Village Change}

      Println(#9 + FormatFloat(NoDecimalDisplay_BlankZero,
                               OverallLandValueChange) +
              #9 + FormatFloat(NoDecimalDisplay_BlankZero,
                               OverallTotalValueChange) +
              #9 + FormatFloat(NoDecimalDisplay_BlankZero,
                               OverallCountyTaxableChange) +
              #9 + FormatFloat(NoDecimalDisplay_BlankZero,
                               OverallTownTaxableChange) +
              #9 + FormatFloat(NoDecimalDisplay_BlankZero,
                               OverallSchoolTaxableChange) +
              #9 + FormatFloat(NoDecimalDisplay_BlankZero,
                               OverallVillageTaxableChange));

    end;  {with Sender as TBaseReport do}

end;  {PrintTotals}

{====================================================================}
Procedure TGrievanceResultsBulkUpdateForm.ReportPrintHeader(Sender: TObject);

begin
  with Sender as TBaseReport do
    begin
      ClearTabs;
      Bold := True;

      SetTab(0.3, pjLeft, 13.0, 0, BoxLineNone, 0);

        {Print the date and page number.}

      SectionTop := 0.25;
      SectionLeft := 0.5;
      SectionRight := PageWidth - 0.5;
      SetFont('Times New Roman',8);
      PrintHeader('Page: ' + IntToStr(CurrentPage), pjRight);
      PrintHeader('Date: ' + DateToStr(Date) + '  Time: ' + TimeToStr(Now), pjLeft);
      Println('');

      SetFont('Times New Roman',14);
      ClearTabs;
      SetTab(0.3, pjCenter, 13.0, 0, BoxLineNone, 0);
      Println(#9 + 'Grievance Results Bulk Update Report');
      SetFont('Times New Roman',10);

      Println('');

        {Print the headers.}

        {FXX09142009-1(2.20.1.17)[D1554]: The left margin is too far left.}

      case ReportSection of
        'M' : begin  {Main}
                Bold := True;
                ClearTabs;
                SetTab(0.3, pjCenter, 1.2, 0, BOXLINENone, 0);   {SBL}
                SetTab(1.6, pjCenter, 1.4, 0, BoxLineNone, 0);   {Description}
                SetTab(3.1, pjCenter, 0.8, 0, BOXLINENone, 0);   {Decision Date}
                SetTab(4.0, pjCenter, 1.0, 0, BOXLINENone, 0);   {Disposition}
                SetTab(5.1, pjCenter, 1.0, 0, BOXLINENone, 0);   {land Val}
                SetTab(6.2, pjCenter, 1.2, 0, BOXLINENone, 0);   {Total Val}
                SetTab(7.5, pjCenter, 0.5, 0, BOXLINENone, 0);   {EX Code}
                SetTab(8.1, pjCenter, 0.4, 0, BOXLINENone, 0);   {EX %}
                SetTab(8.6, pjCenter, 1.1, 0, BOXLINENone, 0);   {EX Amt}
                SetTab(9.8, pjCenter, 0.7, 0, BOXLINENone, 0);   {Moved to RS8}
                SetTab(10.6, pjCenter, 1.0, 0, BOXLINENone, 0);   {Land \ Total Change}
                SetTab(11.7, pjCenter, 1.0, 0, BOXLINENone, 0);   {County \ Town Taxable Change}
                SetTab(12.8, pjCenter, 1.0, 0, BOXLINENone, 0);   {School \ Village Change}

                Println(#9 +
                        #9 + #9 + 'Decision' +
                        #9 +
                        #9 + 'Granted' +
                        #9 + 'Granted' +
                        #9 + 'Granted' +
                        #9 + 'Granted' +
                        #9 + 'Granted' +
                        #9 + 'Moved' +
                        #9 + 'Land Chg' +
                        #9 + 'County Chg' +
                        #9 + 'School Chg');

                ClearTabs;
                SetTab(0.3, pjCenter, 1.2, 0, BOXLINEBottom, 0);   {SBL}
                SetTab(1.6, pjCenter, 1.4, 0, BoxLineBottom, 0);   {Description}
                SetTab(3.1, pjCenter, 0.8, 0, BOXLINEBottom, 0);   {Decision Date}
                SetTab(4.0, pjCenter, 1.0, 0, BOXLINEBottom, 0);   {Disposition}
                SetTab(5.1, pjCenter, 1.0, 0, BOXLINEBottom, 0);   {land Val}
                SetTab(6.2, pjCenter, 1.2, 0, BOXLINEBottom, 0);   {Total Val}
                SetTab(7.5, pjCenter, 0.5, 0, BOXLINEBottom, 0);   {EX Code}
                SetTab(8.1, pjCenter, 0.4, 0, BOXLINEBottom, 0);   {EX %}
                SetTab(8.6, pjCenter, 1.1, 0, BOXLINEBottom, 0);   {EX Amt}
                SetTab(9.8, pjCenter, 0.7, 0, BOXLINEBottom, 0);   {Moved to RS 8}
                SetTab(10.6, pjCenter, 1.0, 0, BOXLINEBottom, 0);   {Land \ Total Change}
                SetTab(11.7, pjCenter, 1.0, 0, BOXLINEBottom, 0);   {County \ Town Taxable Change}
                SetTab(12.8, pjCenter, 1.0, 0, BOXLINEBottom, 0);   {School \ Village Change}

                Println(#9 + 'Parcel ID' +
                        #9 + 'Description' +
                        #9 + 'Date' +
                        #9 + 'Disposition' +
                        #9 + 'Land Val' +
                        #9 + 'Total Val' +
                        #9 + 'EX Cd' +
                        #9 + 'EX %' +
                        #9 + 'EX Amt' +
                        #9 + 'to RS8' +
                        #9 + 'Total Chg' +
                        #9 + 'Town Chg' +
                        #9 + 'Vill Chg');

                ClearTabs;
                SetTab(0.3, pjLeft, 1.2, 0, BOXLINENone, 0);   {SBL}
                SetTab(1.6, pjLeft, 1.4, 0, BoxLineNone, 0);   {Description}
                SetTab(3.1, pjLeft, 0.8, 0, BOXLINENone, 0);   {Decision Date}
                SetTab(4.0, pjLeft, 1.0, 0, BOXLINENone, 0);   {Disposition}
                SetTab(5.1, pjRight, 1.0, 0, BOXLINENone, 0);   {land Val}
                SetTab(6.2, pjRight, 1.2, 0, BOXLINENone, 0);   {Total Val}
                SetTab(7.5, pjLeft, 0.5, 0, BOXLINENone, 0);   {EX Code}
                SetTab(8.1, pjRight, 0.4, 0, BOXLINENone, 0);   {EX %}
                SetTab(8.6, pjRight, 1.1, 0, BOXLINENone, 0);   {EX Amt}
                SetTab(9.8, pjRight, 0.7, 0, BOXLINENone, 0);   {Moved to RS8}
                SetTab(10.6, pjRight, 1.0, 0, BOXLINENone, 0);   {Land \ Total Change}
                SetTab(11.7, pjRight, 1.0, 0, BOXLINENone, 0);   {County \ Town Taxable Change}
                SetTab(12.8, pjRight, 1.0, 0, BOXLINENone, 0);   {School \ Village Change}
                Bold := False;

              end;  {M - main}

        'E' : begin  {Error}
                Bold := True;
                Println('');
                Underline := True;
                ClearTabs;
                SetTab(0.4, pjLeft, 8.0, 0, BOXLINENONE, 0);
                Println('The following parcels were not updated and must be done manually:');
                Underline := False;
                Println('');

                ClearTabs;
                SetTab(0.3, pjCenter, 1.2, 0, BOXLINENone, 0);   {SBL}
                SetTab(1.6, pjCenter, 0.4, 0, BoxLineNone, 0);   {Grievance Number}
                SetTab(2.1, pjCenter, 6.4, 0, BOXLINENone, 0);   {Error Message}

                Println(#9 + #9 + 'Grv');

                ClearTabs;
                SetTab(0.3, pjCenter, 1.2, 0, BOXLINEBottom, 0);   {SBL}
                SetTab(1.6, pjCenter, 0.4, 0, BoxLineBottom, 0);   {Grievance Number}
                SetTab(2.1, pjCenter, 6.4, 0, BOXLINEBottom, 0);   {Error Message}

                Println(#9 + 'Parcel ID' +
                        #9 + '#' +
                        #9 + 'Error Message');

                ClearTabs;
                SetTab(0.3, pjLeft, 1.2, 0, BOXLINENone, 0);   {SBL}
                SetTab(1.6, pjRight, 0.4, 0, BoxLineNone, 0);  {Grievance Number}
                SetTab(2.1, pjLeft, 6.4, 0, BOXLINENone, 0);   {Error Message}
                Bold := False;

              end;  {'E'}

        end;  {case ReportSection of}

    end;  {with Sender as TBaseReport do}

end;  {ReportPrintHeader}

{====================================================================}
Procedure TGrievanceResultsBulkUpdateForm.ReportPrint(Sender: TObject);

var
  Done, FirstTimeThrough, Quit,
  NowWhollyExempt, Updated, UpdateThisParcel : Boolean;
  I, NumFound : LongInt;
  ErrorMessage, SwisSBLKey : String;

  OriginalGrantedLandValue,
  OriginalGrantedTotalValue,
  OriginalGrantedExemptionAmount,
  NewGrantedLandValue,
  NewGrantedTotalValue,
  NewGrantedExemptionAmount : LongInt;

  OriginalGrantedExemptionCode,
  NewGrantedExemptionCode : String;

  OriginalGrantedExemptionPercent,
  NewGrantedExemptionPercent : Double;
  GrievanceProcessingType : Integer;

  ErrorList : TList;

  LandValueChange, TotalValueChange,
  CountyTaxableChange, TownTaxableChange,
  SchoolTaxableChange, VillageTaxableChange,
  OverallLandValueChange, OverallTotalValueChange,
  OverallCountyTaxableChange, OverallTownTaxableChange,
  OverallSchoolTaxableChange, OverallVillageTaxableChange : Comp;

begin
  Done := False;
  FirstTimeThrough := True;
  Quit := False;
  NumFound := 0;
  GrievanceProcessingType := GetProcessingTypeForTaxRollYear(GrievanceYear);

  SetRangeOld(GrievanceResultsTable, ['TaxRollYr', 'SwisSBLKey', 'GrievanceNumber'],
              [GrievanceYear, '', ''], [GrievanceYear, '999999', '']);

  OverallLandValueChange := 0;
  OverallTotalValueChange := 0;
  OverallCountyTaxableChange := 0;
  OverallTownTaxableChange := 0;
  OverallSchoolTaxableChange := 0;
  OverallVillageTaxableChange := 0;

  OriginalGrantedLandValue := 0;
  OriginalGrantedTotalValue := 0;
  OriginalGrantedExemptionAmount := 0;
  OriginalGrantedExemptionPercent := 0;
  OriginalGrantedExemptionCode := '';

  ErrorList := TList.Create;

  with Sender as TBaseReport do
    begin
      repeat
        If FirstTimeThrough
          then FirstTimeThrough := False
          else GrievanceResultsTable.Next;

        If GrievanceResultsTable.EOF
          then Done := True;

          {Print the present record.}

        If not (Done or Quit)
          then
            begin
              UpdateThisParcel := True;

              {Update the progress panel.}

              with GrievanceResultsTable do
                ProgressDialog.Update(Self,
                                      ConvertSwisSBLToDashDot(FieldByName('SwisSBLKey').Text));
              Application.ProcessMessages;

              with GrievanceResultsTable do
                begin
                  If not FindKeyOld(GrievanceTable,
                                    ['TaxRollYr', 'SwisSBLKey', 'GrievanceNumber'],
                                    [GrievanceYear,
                                     FieldByName('SwisSBLKey').Text,
                                     FieldByName('GrievanceNumber').Text])
                    then
                      begin
                        UpdateThisParcel := False;
                        SystemSupport(003, GrievanceTable,
                                      'Error finding grievance record ' + FieldByName('GrievanceNumber').Text + '.',
                                      UnitName, GlblErrorDlgBox);

                      end;  {If not FindKeyOld...}

                  with GrievanceTable do
                    If FieldByName('PreventUpdate').AsBoolean
                      then
                        begin
                          UpdateThisParcel := False;
                          AddErrorRecord(ErrorList, FieldByName('SwisSBLKey').Text,
                                         FieldByName('GrievanceNumber').AsInteger,
                                         'The lock update flag was on.');

                        end;  {If FieldByName('PreventUpdate').AsBoolean}

                  FindKeyOld(GrievanceDispositionCodeTable,
                             ['Code'],
                             [FieldByName('Disposition').Text]);

                  If (FieldByName('ValuesTransferred').AsBoolean or
                      (Deblank(FieldByName('Disposition').Text) = '') or
                      (GrievanceDispositionCodeTable.FieldByName('ResultType').AsInteger <> gtApproved))
                    then UpdateThisParcel := False;

                  If UpdateThisParcel
                    then
                      begin
                        SwisSBLKey := FieldByName('SwisSBLKey').Text;

                        DetermineGrantedValues(GrievanceResultsTable, NewGrantedLandValue,
                                               NewGrantedTotalValue,
                                               NewGrantedExemptionAmount,
                                               NewGrantedExemptionPercent,
                                               NewGrantedExemptionCode);

                        MoveGrantedValuesToMainParcel(OriginalGrantedLandValue,
                                                      OriginalGrantedTotalValue,
                                                      OriginalGrantedExemptionAmount,
                                                      OriginalGrantedExemptionPercent,
                                                      OriginalGrantedExemptionCode,
                                                      NewGrantedLandValue,
                                                      NewGrantedTotalValue,
                                                      NewGrantedExemptionAmount,
                                                      NewGrantedExemptionPercent,
                                                      NewGrantedExemptionCode,
                                                      GrievanceProcessingType,
                                                      SwisSBLKey,
                                                      GrievanceYear,
                                                      nil, nil,
                                                      FieldByName('GrievanceNumber').AsInteger,
                                                      FieldByName('ResultNumber').AsInteger,
                                                      FieldByName('Disposition').Text,
                                                      FieldByName('DecisionDate').Text,
                                                      True, False,
                                                      True, True, NowWhollyExempt,
                                                      Updated, ErrorMessage,
                                                      LandValueChange, TotalValueChange,
                                                      CountyTaxableChange, TownTaxableChange,
                                                      SchoolTaxableChange, VillageTaxableChange);

                        If Updated
                          then
                            begin
                              OverallLandValueChange := OverallLandValueChange + LandValueChange;
                              OverallTotalValueChange := OverallTotalValueChange + TotalValueChange;
                              OverallCountyTaxableChange := OverallCountyTaxableChange + CountyTaxableChange;
                              OverallTownTaxableChange := OverallTownTaxableChange + TownTaxableChange;
                              OverallSchoolTaxableChange := OverallSchoolTaxableChange + SchoolTaxableChange;
                              OverallVillageTaxableChange := OverallVillageTaxableChange + VillageTaxableChange;

                            end;  {If Updated}

                        If not Updated
                          then AddErrorRecord(ErrorList, FieldByName('SwisSBLKey').Text,
                                              FieldByName('GrievanceNumber').AsInteger,
                                              ErrorMessage);

                        If (Updated and
                            GlblModifyBothYears and
                            (GrievanceProcessingType = ThisYear))
                          then MoveGrantedValuesToMainParcel(OriginalGrantedLandValue,
                                                             OriginalGrantedTotalValue,
                                                             OriginalGrantedExemptionAmount,
                                                             OriginalGrantedExemptionPercent,
                                                             OriginalGrantedExemptionCode,
                                                             NewGrantedLandValue,
                                                             NewGrantedTotalValue,
                                                             NewGrantedExemptionAmount,
                                                             NewGrantedExemptionPercent,
                                                             NewGrantedExemptionCode,
                                                             NextYear,
                                                             SwisSBLKey,
                                                             GlblNextYear,
                                                             nil, nil,
                                                             FieldByName('GrievanceNumber').AsInteger,
                                                             FieldByName('ResultNumber').AsInteger,
                                                             FieldByName('Disposition').Text,
                                                             FieldByName('DecisionDate').Text,
                                                             True, False,
                                                             True, glblFreezeAssessmentDueToGrievance, NowWhollyExempt,
                                                             Updated, ErrorMessage,
                                                             LandValueChange, TotalValueChange,
                                                             CountyTaxableChange, TownTaxableChange,
                                                             SchoolTaxableChange, VillageTaxableChange);

                        If Updated
                          then
                            begin
                              NumFound := NumFound + 1;
                              ProgressDialog.UserLabelCaption := 'Num Updated = ' + IntToStr(NumFound);

                              Println(#9 + ConvertSwisSBLToDashDot(SwisSBLKey) +
                                      #9 + FieldByName('ComplaintReason').Text +
                                      #9 + FieldByName('DecisionDate').Text +
                                      #9 + FieldByName('Disposition').Text +
                                      #9 + FormatFloat(NoDecimalDisplay_BlankZero,
                                                       NewGrantedLandValue) +
                                      #9 + FormatFloat(NoDecimalDisplay_BlankZero,
                                                       NewGrantedTotalValue) +
                                      #9 + NewGrantedExemptionCode +
                                      #9 + FormatFloat(PercentDisplay_BlankZero,
                                                       NewGrantedExemptionPercent) +
                                      #9 + FormatFloat(NoDecimalDisplay_BlankZero,
                                                       NewGrantedExemptionAmount) +
                                      #9 + BoolToChar_Blank_Y(NowWhollyExempt) +
                                      #9 + FormatFloat(NoDecimalDisplay_BlankZero,
                                                       LandValueChange) +
                                      #9 + FormatFloat(NoDecimalDisplay_BlankZero,
                                                       CountyTaxableChange) +
                                      #9 + FormatFloat(NoDecimalDisplay_BlankZero,
                                                       SchoolTaxableChange));

                              Println(#9 + #9 + #9 + #9 + #9 +
                                      #9 + #9 + #9 + #9 + #9 +
                                      #9 + FormatFloat(NoDecimalDisplay_BlankZero,
                                                       TotalValueChange) +
                                      #9 + FormatFloat(NoDecimalDisplay_BlankZero,
                                                       TownTaxableChange) +
                                      #9 + FormatFloat(NoDecimalDisplay_BlankZero,
                                                       VillageTaxableChange));

                                {Mark this parcel as being updated.}

                              try
                                Edit;
                                FieldByName('ValuesTransferred').AsBoolean := True;
                                FieldByName('ValuesTransferredDate').AsDateTime := Date;
                                Post;
                              except
                                SystemSupport(004, GrievanceTable,
                                              'Error marking grievance results record updated for ' +
                                              SwisSBLKey + '.',
                                              UnitName, GlblErrorDlgBox);
                              end;

                            end;  {If Updated}

                      end;  {If UpdateThisParcel}

                end;  {with GrievanceResultsTable do}

                {If there is only one line left to print, then we
                 want to go to the next page.}

              If (LinesLeft < 8)
                then NewPage;

            end;  {If not (Done or Quit)}

        ReportCancelled := ProgressDialog.Cancelled;

      until (Done or Quit or ReportCancelled);

        {Print the totals.}

      PrintTotals(Sender, OverallLandValueChange, OverallTotalValueChange,
                  OverallCountyTaxableChange, OverallTownTaxableChange,
                  OverallSchoolTaxableChange, OverallVillageTaxableChange);

        {Print the error list.}

      If (ErrorList.Count > 0)
        then
          begin
            ReportSection := 'E';
            NewPage;

            For I := 0 to (ErrorList.Count - 1) do
              begin
                with ErrorPointer(ErrorList[I])^ do
                  Println(#9 + ConvertSwisSBLToDashDot(SwisSBLKey) +
                          #9 + IntToStr(GrievanceNumber) +
                          #9 + ErrorMessage);

                If (LinesLeft < 5)
                  then NewPage;

              end;  {For I := 0 to (ErrorList.Count - 1) do}

          end;  {If (ErrorList.Count > 0)}

      If (NumFound = 0)
        then Println('No results to update.');

    end;  {with Sender as TBaseReport do}

  FreeTList(ErrorList, SizeOf(ErrorRecord));

end;  {ReportPrinterPrint}

{=====================================================================}
Procedure TGrievanceResultsBulkUpdateForm.CloseButtonClick(Sender: TObject);

begin
  Close;
end;

{===================================================================}
Procedure TGrievanceResultsBulkUpdateForm.FormClose(    Sender: TObject;
                                  var Action: TCloseAction);

begin
  CloseTablesForForm(Self);

    {Free up the child window and set the ClosingAForm Boolean to
     true so that we know to delete the tab.}

  Action := caFree;

  GlblClosingAForm := True;
  GlblClosingFormCaption := Caption;

end;  {FormClose}


end.