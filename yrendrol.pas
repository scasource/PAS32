unit Yrendrol;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, DBCtrls, DBTables, DB, Buttons, Grids,
  Wwdbigrd, Wwdbgrid, ExtCtrls, Wwtable, Wwdatsrc, Menus,pastypes,
  GlblCnst,Types, RPFiler, RPBase, RPCanvas, RPrinter, (*Progress, *)RPDefine,
  wwdblook, Mask, RPTXFilr, FileCtrl, Zipcopy;

type
  SortRecordTypes = (stEraseSplitMerge, stClearSchoolRelevy, stClearEqualIncChange,
                     stClearEqualDecChange, stClearQtyIncChange, stClearVillageRelevy,
                     stClearQtyDecChange, stDeleteInactiveParcel,
                     stDeleteRS9, stDeleteExemption, stClearExemptionPrintKeys,
                     stDeleteProRataSpecialDistrict, stDeleteSpecialAssessmentSD,
                     stTypeESpecialDistrict, stTypeSSpecialDistrict,
                     stFrozenAssessment, stReduceBIEAmount);
  SortRecordTypesSet = set of SortRecordTypes;

type
  TYearEndRollOverForm = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    ScrollBox1: TScrollBox;
    CloseButton: TBitBtn;
    TitleLabel: TLabel;
    SysrecTable: TTable;
    ReportPrinter: TReportPrinter;
    ReportFiler: TReportFiler;
    PrintDialog: TPrintDialog;
    ParcelTable: TTable;
    DestTable: TTable;
    SourceTable: TTable;
    ExemptionCodeTable: TTable;
    AssmtYrCtlTable: TTable;
    CopyStatusPanel: TPanel;
    TYProgLabel: TLabel;
    RolloverButton: TBitBtn;
    SortTable: TTable;
    InformationGroupBox: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    TaxableStatusDateEdit: TMaskEdit;
    FinalRollDateEdit: TMaskEdit;
    ValuationDateEdit: TMaskEdit;
    CountyVeteransLimitsDropdown: TwwDBLookupCombo;
    TownVeteransLimitsDropdown: TwwDBLookupCombo;
    BasicSTARAmountEdit: TEdit;
    EnhancedSTARAmountEdit: TEdit;
    EqualizationRateEdit: TEdit;
    UniformPercentOfValueEdit: TEdit;
    StartingSplitMergeNumberEdit: TEdit;
    VeteransLimitsTable: TwwTable;
    Label11: TLabel;
    SwisCodeTable: TTable;
    PrintExemptionFlagsClearedCheckBox: TCheckBox;
    TextFiler: TTextFiler;
    SDCodeTable: TTable;
    AddOneYearToProrataSDsCheckBox: TCheckBox;
    Label12: TLabel;
    SDCodeLookupTable: TTable;
    NYDeniedExemptionsTable: TTable;
    ZipCopyDlg: TZipCopyDlg;
    NameAddressAuditTable: TTable;
    ClearPartialAssessmentsCheckBox: TCheckBox;
    Label13: TLabel;
    Label14: TLabel;
    ResetOwnerChangeLabelsCheckBox: TCheckBox;
    AutoReduceBIECheckBox: TCheckBox;
    cb_MoveDataToHistory: TCheckBox;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CloseButtonClick(Sender: TObject);
    procedure TextFilerPrintHeader(Sender: TObject);
    procedure RolloverButtonClick(Sender: TObject);
    procedure TextFilerPrint(Sender: TObject);
    procedure ReportPrint(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    UnitName : String;
    FormAccessRights : Integer;  {Read only or read write, based on security level?}
                                {Values = raReadOnly, raReadWrite}

    OrigSortFileName : String;
    ReportSection : Integer;
    AutoReduceBIEExemptions, MoveDataToHistory,
    ResetOwnerChangeLabels, ClearPartialAssessments : Boolean;

    Procedure InitializeForm;  {Open the tables and setup.}

    Function ExemptionRequiresRenewal(ExCd : String) : Boolean;

    Procedure ScanForExemptionErrors(    Sender : TObject;
                                     var EXErrorCount : LongInt;
                                     var Quit : Boolean);

    Procedure CopyOneTableNextYearToThisYear(    TYTableName : String;
                                             var Quit : Boolean);

    Procedure CopyNextYearToThisYear(var Quit : Boolean);

    Procedure OpenSourceDestTables(    TableName : String;
                                   var Quit : Boolean);

    Procedure CopyRecordsFromSourceToDestsOneTable(    TableName : String;
                                                       SourceTable,
                                                       DestTable : TTable;
                                                   var Quit : Boolean);

    Procedure CopyThisYearToHist(var Quit : Boolean);

    Procedure DeleteRecordsForThisTable(    TableName : String;
                                            TaxRollYear : String;
                                            ProcessingType : Integer;
                                            SwisSBLKey : String;
                                        var Quit : Boolean);

    Procedure DeleteRecordsInAllTablesForThisParcel(    ParcelTable : TTable;
                                                        TaxRollYear : String;   {next year}
                                                        SwisSBLKey : String;
                                                    var Quit : Boolean);

    Procedure UpdateTaxRollYrRecordsForTable(    TableName : String;
                                                 IndexName : String;
                                                 OldTaxRollYr,
                                                 NewTaxRollYr : String;
                                             var Quit : Boolean);
    {Change the tax roll year in all records.}

    Procedure UpdateTaxRollYearForAllRecordsInNewYearFile(    OldTaxRollYr,
                                                              NewTaxRollYr : String;
                                                          var Quit : Boolean);

    Procedure InsertSortRecord(    SortTable,
                                   ParcelTable,
                                   AssessmentTable,
                                   ExemptionTable,
                                   SpecialDistrictTable : TTable;
                                   SortRecordType : SortRecordTypesSet;
                               var Quit : Boolean);

    Procedure DeleteSpecialDistricts(    SDCode : String;
                                         OldTaxRollYr : String;
                                         SortTable,
                                         SpecialDistrictTable,
                                         ParcelTable,
                                         AssessmentTable,
                                         ExemptionTable : TTable;
                                         SortRecordType : SortRecordTypesSet;
                                     var Quit : Boolean);

    Procedure CleanUpNYParcels(    OldTaxRollYr,
                                   NewTaxRollYr : String;
                               var NumParcels : LongInt;
                               var TotalAssessedVal,
                                   LandAssessedVal : Comp;
                               var Quit : Boolean);

    Procedure PrintChanges(Sender : TObject;
                           NumParcels : LongInt;
                           TotalAssessedVal,
                           LandAssessedVal : Comp);

    Procedure UpdateValuesFromScreen(var Quit : Boolean);

    Procedure UpdateProratedSpecialDistricts(Sender : TObject);

    Procedure DeleteNextYearParcelsInBothYears(var Quit : Boolean);

    Procedure ResetNameAddressChangeLabels;

    Procedure ClearARChangeFields(    ProcessingType : Integer;
                                  var Quit : Boolean);

    Procedure ClearExemptionFlags(ExemptionTable : TTable);

  end;

{$R *.DFM}

implementation

uses GlblVars, WinUtils, Utilitys,PASUTILS, UTILEXSD, Preview, Prog,
     PRCLLIST,
     DataModule,
     RPS995EX,
     RTCALCUL;  {Roll total full recalc}

const
  rsExemption = 0;
  rsDetail = 1;
  rsSummary = 2;
  rsChangeSDCodes = 3;

var
  TempTextFile : TextFile;

{========================================================}
Procedure TYearEndRollOverForm.FormActivate(Sender: TObject);

begin
  SetFormStateMaximized(Self);
end;

{========================================================}
Procedure TYearEndRollOverForm.InitializeForm;

var
  Quit : Boolean;
  AssmtYrCtlTable, ExemptionCodeTable, SwisCodeTable : TTable;
  NewAssessmentYear : String;

begin
  ReportSection := rsDetail;
  UnitName := 'YRENDROL';  {mmm}
  SysrecTable.Open;
  AssignFile(TempTextFile, 'COPY.OUT');
  Rewrite(TempTextFile);

  AssmtYrCtlTable := TTable.Create(nil);
  ExemptionCodeTable := TTable.Create(nil);
  SwisCodeTable := TTable.Create(nil);

    {CHG01201999-1: Add the fields for setting the Next Year values.}

  OpenTableForProcessingType(AssmtYrCtlTable, AssessmentYearControlTableName,
                             NextYear, Quit);
  OpenTableForProcessingType(ExemptionCodeTable, ExemptionCodesTableName,
                             NextYear, Quit);
  OpenTableForProcessingType(SwisCodeTable, SwisCodeTableName,
                             NextYear, Quit);

  VeteransLimitsTable.Open;

  try
    TaxableStatusDateEdit.Text := DateToStr(MoveDateTimeAhead(
                                               AssmtYrCtlTable.FieldByName('TaxableStatusDate').AsDateTime,
                                               1, 0, 0));
    FinalRollDateEdit.Text := DateToStr(MoveDateTimeAhead(
                                           AssmtYrCtlTable.FieldByName('FinalRollDate').AsDateTime,
                                           1, 0, 0));
    ValuationDateEdit.Text := DateToStr(MoveDateTimeAhead(
                                           AssmtYrCtlTable.FieldByName('ValuationDate').AsDateTime,
                                           1, 0, 0));
  except
  end;

  CountyVeteransLimitsDropdown.Text := AssmtYrCtlTable.FieldByName('VeteransLimitSet').Text;
  TownVeteransLimitsDropdown.Text := SwisCodeTable.FieldByName('VeteransLimitSet').Text;

  ExemptionCodeTable.IndexName := 'BYEXCODE';
  FindKeyOld(ExemptionCodeTable, ['EXCode'], [BasicSTARExemptionCode]);
  BasicSTARAmountEdit.Text := ExemptionCodeTable.FieldByName('FixedAmount').Text;
  FindKeyOld(ExemptionCodeTable, ['EXCode'],
             [EnhancedSTARExemptionCode]);
  EnhancedSTARAmountEdit.Text := ExemptionCodeTable.FieldByName('FixedAmount').Text;
  EqualizationRateEdit.Text := FormatFloat(ExtendedDecimalDisplay,
                                           SwisCodeTable.FieldByName('EqualizationRate').AsFloat);
  UniformPercentOfValueEdit.Text := FormatFloat(ExtendedDecimalDisplay,
                                                SwisCodeTable.FieldByName('UniformPercentValue').AsFloat);
  StartingSplitMergeNumberEdit.Text := '1';

  AssmtYrCtlTable.Close;
  ExemptionCodeTable.Close;
  SwisCodeTable.Close;

  AssmtYrCtlTable.Free;
  ExemptionCodeTable.Free;
  SwisCodeTable.Free;

  NewAssessmentYear := IntToStr(StrToInt(GlblNextYear) + 1);
  InformationGroupBox.Caption := ' Information for ' + NewAssessmentYear + ': ';
  OrigSortFileName := SortTable.TableName;

end;  {InitializeForm}

{==============================================================================}
Procedure TYearEndRollOverForm.RolloverButtonClick(Sender: TObject);

var
  NewYearZipFileName,
  ReportFileName, TextFileName,
  EndOfYearZipFileName, SortFileName,
  NewFileName, TempZipUtilityCommandLine, BackupDirectory : String;
  ZipUtilityPChar : PChar;
  TempFile : File;
  Quit, CloseApplication : Boolean;
  TempLen : Integer;
  SelectedSwisCodes : TStringList;

begin
  Quit := False;
  MoveDataToHistory := cb_MoveDataToHistory.Checked;
  SelectedSwisCodes := TStringList.Create;
  ClearPartialAssessments := ClearPartialAssessmentsCheckBox.Checked;
  ResetOwnerChangeLabels := ResetOwnerChangeLabelsCheckBox.Checked;
  AutoReduceBIEExemptions := AutoReduceBIECheckBox.Checked;

    {CHG09032001-1: Check for a zip back up.  If not, then quit the application
                    and bring up the zip application.}

  BackupDirectory := GlblProgramDir + 'EndOfYearZips\';

  If not DirectoryExists(BackupDirectory)
    then MkDir(BackupDirectory);

  EndOfYearZipFileName := 'EndOfYear' + GlblThisYear + '_' + GlblNextYear + '.zip';
  CloseApplication := False;

  If not FileExists(BackupDirectory + EndOfYearZipFileName)
    then
      begin
        MessageDlg('Before doing the year end rollover, you should make a backup' + #13 +
                   'of the data.  To do this, click OK.' + #13 +
                   'PAS will shut down and a backup utility will appear.' + #13 +
                   'When you have made a backup, start PAS again and run the rollover again.',
                   mtInformation, [mbOK], 0);

        TempZipUtilityCommandLine := 'BackupPAS.EXE FILE=' + EndOfYearZipFileName +
                                     ' BASE=' + GlblDataDir +
                                     ' DIRECTORY=' + BackupDirectory +
                                     ' ONEXIT=' + GlblProgramDir + 'PAS32.EXE';

        TempLen := Length(TempZipUtilityCommandLine);
        ZipUtilityPChar := StrAlloc(TempLen + 1);
        StrPCopy(ZipUtilityPChar, TempZipUtilityCommandLine);

        GlblApplicationIsTerminatingToDoBackup := True;
        WinExec(ZipUtilityPChar, SW_SHOW);
        StrDispose(ZipUtilityPChar);

        SelectedSwisCodes.Free;

          {FXX09202002-1: There should not be an Application.MainForm.Close
                          since it causes problems in Application.Terminate.}

        Close;
(*        Application.MainForm.Close;*)
        Application.Terminate;
        CloseApplication := True;

      end;  {If not FileExists(EndOfYearZipFileName)}

  If not CloseApplication
    then
      begin
(*        If (MessageDlg('Do you want to generate a final full file (995) extract' + #13 +
                       'before doing the rollover?', mtConfirmation, [mbYes, mbNo], 0) = idYes)
          then
            begin
              SelectedSwisCodes := TStringList.Create;
              SwisCodeTable.Open;

              FillStringListFromFile(SelectedSwisCodes, SwisCodeTable,
                                     'SwisCode', '', 0, False,
                                     NextYear, GlblNextYear);

              SwisCodeTable.Close;

              Generate995File(Self, SelectedSwisCodes, 'RPS995T1',
                              ftParcelAndSales, False, True, True, False, False,
                              False, ProgressDialog, ZipCopyDlg);

            end;  {If (MessageDlg( ...} *)

        If PrintDialog.Execute
          then
            begin
              ParcelListDialog.CloseFiles;

                {CHG10131998-1: Set the printer settings based on what printer they selected
                                only - they no longer need to worry about paper or landscape
                                mode.}

              AssignPrinterSettings(PrintDialog, ReportPrinter, ReportFiler, [ptBoth], True, Quit);

              If not Quit
                then
                  begin
                      {CHG09031998-1: Add audit trail report.}

                    CopyAndOpenSortFile(SortTable, 'YearendRollover',
                                        OrigSortFileName, SortFileName,
                                        True, True, Quit);

                      {FXX10071999-1: To solve the problem of printing to the high speed,
                                      we need to set the font to a TrueType even though it
                                      doesn't matter in the actual printing.  The reason for this
                                      is that without setting it, the default font is System for
                                      the Generic printer which has a baseline descent of 0.5
                                      which messes up printing to a text file.  We needed a font
                                      with no descent.}

                    TextFiler.SetFont('Courier New', 10);

                    TextFileName := GetPrintFileName(Self.Caption, True);
                    TextFiler.FileName := TextFileName;

                      {FXX01211998-1: Need to set the LastPage property so that
                                      long rolls aren't a problem.}

                    TextFiler.LastPage := 30000;

                    TextFiler.Execute;

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

                    ProgressDialog.Finish;

                      {Now rename the text file to a recognizable
                       name, but to do so, erase the original first.
                       This is so that several people can run this job
                       at once.}

                    ReportFileName := 'YRENDROL.RPT';
                    try
                      Chdir(GlblReportDir);
                      OldDeleteFile(ReportFileName);
                    except
                    end;

                    try
                      AssignFile(TempFile, TextFileName);
                      Rename(TempFile, ReportFileName);

                        {FXX02171999-3: Need to do a CloseFile even though no
                                       Reset or Rewrite in order to get Novell
                                       to release.}

                      Reset(TempFile);
                      CloseFile(TempFile);
                    finally
                      {We don't care if it does not get deleted, so we won't put up an
                       error message.}

                      ChDir(GlblProgramDir);
                    end;

                  end;  {If not Quit}

              MessageDlg('The rollover is now complete.' + #13 +
                         'Please run the Assessor''s Verification report to check' + #13 +
                         'for any errors on the new Next Year.', mtInformation, [mbOK], 0);

              MessageDlg('PAS will now make a backup of the data after the rollover.',
                         mtInformation, [mbOK], 0);

              NewYearZipFileName := 'NewYear' + GlblThisYear + '_' + GlblNextYear + '.zip';
              TempZipUtilityCommandLine := 'BackupPAS.EXE FILE=' + NewYearZipFileName +
                                           ' BASE=' + GlblDataDir +
                                           ' DIRECTORY=' + BackupDirectory +
                                           ' ONEXIT=' + GlblProgramDir + 'PAS32.EXE';

              TempLen := Length(TempZipUtilityCommandLine);
              ZipUtilityPChar := StrAlloc(TempLen + 1);
              StrPCopy(ZipUtilityPChar, TempZipUtilityCommandLine);

              GlblApplicationIsTerminatingToDoBackup := True;
              WinExec(ZipUtilityPChar, SW_SHOW);
              StrDispose(ZipUtilityPChar);

              Close;
(*              Application.MainForm.Close;*)
              Application.Terminate;

            end;  {If PrintDialog.Execute}

          SelectedSwisCodes.Free;

        end;  {If not CloseApplication}

end;  {RolloverButtonClick}

{============================================================================}
Function TYearEndRollOverForm.ExemptionRequiresRenewal(ExCd : String) : Boolean;

var
 Found : Boolean;

begin
  Result := False;
  Found := FindKeyOld(ExemptionCodeTable, ['EXCode'], [Excd]);

  If Found
    then
      begin
        If ExemptionCodeTable.FieldByName('RenewalRequired').AsBoolean
          then Result := True;

      end
    else SystemSupport(007, ExemptionCodeTable,'Find Error on Exemption Table, Code = ' +
                            Excd, UnitName, GlblErrorDlgBox);

end;  {ExemptionRequiresRenewal}

{===========================================================================================}
Procedure TYearEndRollOverForm.ScanForExemptionErrors(    Sender : TObject;
                                                      var EXErrorCount : LongInt;
                                                      var Quit : Boolean);

var
  FirstTimeThrough, Done : Boolean;
  SwisSBLKey : String;
  ParcelExemptionTable : TTable;

begin
  with Sender as TBaseReport do
    begin
      Bold := False;
          {Set up the tabs for the info.}
          {SCAN EXEMPTION TABLE}
          {first scan parcel file for completeness, ie be sure all exemptions are }
          {approved or denied, or AV = 0}

      SetTab(0.5, pjCenter, 0.5, 0, BOXLINENONE, 0);   {swis}
      SetTab(1.0, pjCenter, 2.6, 0, BOXLINENONE, 0);   {SBL}
      SetTab(3.7, pjCenter, 0.5, 0, BOXLINENONE, 0);   {ExCode}
      SetTab(4.3, pjCenter, 3.0, 0, BOXLINENONE, 0);   {msg}

      ParcelExemptionTable := TTable.Create(nil);
      OpenTableForProcessingType(ParcelExemptionTable, ExemptionsTableName, NextYear, Quit);
      OpenTableForProcessingType(ExemptionCodeTable, ExemptionCodesTableName, NextYear, Quit);

      Application.ProcessMessages;
      ProgressDialog.Start(GetRecordCount(ParcelExemptionTable), False, False);
      ProgressDialog.UserLabelCaption := 'Scanning Parcel Exemptions For Completeness';

      ParcelExemptionTable.First;
      FirstTimeThrough := True;

      repeat
        If FirstTimeThrough
          then FirstTimeThrough := False
          else ParcelExemptionTable.Next;

        SwisSBLKey := ParcelExemptionTable.FieldByName('SwisSBLKey').Text;

        ProgressDialog.Update(Self, ConvertSwisSBLToDashDot(SwisSBLKey));
        Application.ProcessMessages;

        Done := ParcelExemptionTable.EOF;

          {only look at exemptions the municipality deems to require renewal, they }
          {must set this up in the town-wide exem. code table}

        If ((not Done) and
            ExemptionRequiresRenewal(ParcelExemptionTable.FieldByName('ExemptionCode').Text))
          then
            begin
              If not (ParcelExemptionTable.FieldByName('ExemptionApproved').AsBoolean or
                      ParcelExemptionTable.FieldByName('ExemptionDenied').AsBoolean)
                then
                  begin
                    ExErrorCount := ExErrorCount + 1;
                    Println(#9 + ConvertSwisSBLToDashDot(SwisSBLKey) +
                            #9 +  ParcelExemptionTable.FieldByName('ExemptionCode').Text +
                            #9 + 'Error: Renewable Exemption Not Approved Or Denied.');
                  end;

              If (ParcelExemptionTable.FieldByName('ExemptionApproved').AsBoolean and
                  (not ParcelExemptionTable.FieldByName('ApprovalPrinted').AsBoolean))
                then
                  begin
                    ExErrorCount := ExErrorCount + 1;
                    Println(#9 + ConvertSwisSBLToDashDot(SwisSBLKey) +
                            #9 +  ParcelExemptionTable.FieldByName('ExemptionCode').Text +
                            #9 + 'Error: Exemption Approval Letter Not Printed.');
                 end;

              If (ParcelExemptionTable.FieldByName('ExemptionDenied').AsBoolean and
                  (not ParcelExemptionTable.FieldByName('DenialPrinted').AsBoolean))
                then
                  begin
                    ExErrorCount := ExErrorCount + 1;
                    Println(#9 + ConvertSwisSBLToDashDot(SwisSBLKey) +
                            #9 +  ParcelExemptionTable.FieldByName('ExemptionCode').Text +
                            #9 + 'Error: Exemption Denial Letter Not Printed.');
                  end;

            end;  {If ExemptionRequiresRenewal(ParcelExemptionTable.FieldByName('ExemptionCode').Text)}

      until Done;

      If (EXErrorCount = 0)
        then
          begin
            Println('');
            Bold := True;
            Println(#9 + 'There were no exemption errors.');
            Bold := False;

          end;  {If (EXErrorCount = 0)}

    end;  {with Sender as TBaseReport do}

  ParcelExemptionTable.Close;
  ExemptionCodeTable.Close;
  ParcelExemptionTable.Free;

end;  {ScanForExemptionErrors}

{============================================================================}
Procedure GetTYNYTableNames(    TableName : String;
                            var TYDatName,
                                NYDatName : String);

begin
  TYDatName := TableName;
  NYDatName := TableName;
  NYDatName[1] := 'N';

end;  {GetTYNYTableNames}

{===========================================================================}
Procedure TYearEndRollOverForm.CopyOneTableNextYearToThisYear(    TYTableName : String;
                                                              var Quit : Boolean);

var
  Successful : Boolean;
  ThisYearDatName, NextYearDatName : String;
  Table : TTable;

begin
  Successful := True;
  TyProgLabel.Caption := 'File: ' + TYTableName;
  TyProgLabel.Repaint;
  Application.ProcessMessages;

  GetTYNYTableNames(TYTableName, ThisYearDatName, NextYearDatName);
  ThisYearDatName := ExpandPASPath(GlblDataDir) + ThisYearDatName;

    {FXX09211998-1: Delete the this year file so the copy works OK.}
    {Due to a problem copying NextYear to ThisYear when both files have same
     date and size, we are first deleting the ThisYear file, renaming the
     NextYear to ThisYear and then copying ThisYear to NextYear.  What we want
     is 2 identical files for ThisYear and NextYear.}

  try
    ChDir(ExpandPASPath(GlblDataDir));
    Successful := OldDeleteFile(ThisYearDatName);
  except
    MessageDlg('Error changing directory to ' + ExpandPASPath(GlblDataDir) + '.',
               mtError, [mbOK], 0);
  end;
  
  If Successful
    then
      begin
        Table := TTable.Create(nil);
        with Table do
          begin
            TableType := ttDBase;
            DatabaseName := PASDataModule.PASDatabase.AliasName;{'PASSystem';}
            TableName := NextYearDatName;
            Table.Open;
          end;

        CopyTable(Table, ThisYearDatName, True);

        Writeln(TempTextFile, NextYearDatName, ' to ', ThisYearDatName);

        Table.Close;
        Table.Free;

      end;  {If Successfu}

  If not Successful
    then
      begin
        Quit := True;
        NonBtrvSystemSupport(027, 999, 'Error copying ' + ThisYearDatName,
                       UnitName, GlblErrorDlgBox);
      end;

end;  {CopyOneTableNextYearToThisYear}

{===========================================================================}
Procedure TYearEndRollOverForm.CopyNextYearToThisYear(var Quit : Boolean);

var
  I : Integer;

begin
  TyProgLabel.Visible := True;
  CopyStatusPanel.Visible := True;
  Application.ProcessMessages;

   {Close all the tables in the data module.}

  with PASDataModule do
    For I := 0 to (ComponentCount - 1) do
      If ((Components[I] is TwwTable) and
          (Deblank(TwwTable(Components[I]).TableName) <> ''))
        then TwwTable(Components[I]).Close;

  CopyOneTableNextYearToThisYear(ParcelTableName, Quit);

  If not Quit
    then CopyOneTableNextYearToThisYear(AssessmentTableName, Quit);

  If not Quit
    then CopyOneTableNextYearToThisYear(ClassTableName, Quit);

  If not Quit
    then CopyOneTableNextYearToThisYear(SpecialDistrictTableName, Quit);

  If not Quit
     then CopyOneTableNextYearToThisYear(ExemptionsTableName, Quit);

  If not Quit
    then CopyOneTableNextYearToThisYear(ExemptionsDenialTableName, Quit);

  If not Quit
     then CopyOneTableNextYearToThisYear(ResidentialSiteTableName, Quit);

  If not Quit
     then CopyOneTableNextYearToThisYear(ResidentialBldgTableName, Quit);

  If not Quit
     then CopyOneTableNextYearToThisYear(ResidentialForestTableName, Quit);

  If not Quit
     then CopyOneTableNextYearToThisYear(ResidentialLandTableName, Quit);

  If not Quit
     then CopyOneTableNextYearToThisYear(ResidentialImprovementsTableName, Quit);

  If not Quit
     then CopyOneTableNextYearToThisYear(CommercialSiteTableName, Quit);

  If not Quit
    then CopyOneTableNextYearToThisYear(CommercialBldgTableName, Quit);

  If not Quit
    then  CopyOneTableNextYearToThisYear(CommercialLandTableName, Quit);

  If not Quit
    then CopyOneTableNextYearToThisYear(CommercialImprovementsTableName, Quit);

  If not Quit
    then CopyOneTableNextYearToThisYear(CommercialIncomeExpenseTableName, Quit);

  If not Quit
    then CopyOneTableNextYearToThisYear(CommercialRentTableName, Quit);

  If not Quit
    then CopyOneTableNextYearToThisYear(AssessmentYearControlTableName, Quit);

  If not Quit
    then CopyOneTableNextYearToThisYear(ExemptionCodesTableName, Quit);

  If not Quit
    then CopyOneTableNextYearToThisYear(AssessmentNotesTableName, Quit);

  If not Quit
    then CopyOneTableNextYearToThisYear(AssessmentLetterTextTableName, Quit);

  If not Quit
     then CopyOneTableNextYearToThisYear(UserDefinitionsTableName, Quit);

  If not Quit
    then CopyOneTableNextYearToThisYear(UserDataTableName, Quit);

  If not Quit
    then CopyOneTableNextYearToThisYear(RTByExCodeTableName, Quit);

  If not Quit
    then CopyOneTableNextYearToThisYear(RTBySchoolCodeTableName, Quit);

  If not Quit
    then CopyOneTableNextYearToThisYear(RTBySDCodeTableName, Quit);

  If not Quit
    then CopyOneTableNextYearToThisYear(RTBySwisCodeTableName, Quit);

  If not Quit
    then CopyOneTableNextYearToThisYear(RTByVillageRelevyTableName, Quit);

  If not Quit
    then CopyOneTableNextYearToThisYear(RTByRS9TableName, Quit);

  If not Quit
    then CopyOneTableNextYearToThisYear(SchoolCodeTableName, Quit);

  If not Quit
    then CopyOneTableNextYearToThisYear(SDistCodeTableName, Quit);

  If not Quit
    then CopyOneTableNextYearToThisYear(SwisCodeTableName, Quit);

  TyProgLabel.Visible := False;
  CopyStatusPanel.Visible := False;

   {Reopen all the tables in the data module.}
   {FXX03252007-1(2.11.1.21): For some reason, the number of components no
                              longer matches the ComponentCount???.
                              So, add a try...except and don't worry about not reopening all of them.} 

  with PASDataModule do
    try
      For I := 0 to (ComponentCount - 1) do
        If ((Components[I] is TwwTable) and
            (Deblank(TwwTable(Components[I]).TableName) <> ''))
          then TwwTable(Components[I]).Open;
    except
    end;


end;  {CopyNextYearToThisYear}

{=========================================================================}
Procedure TYearEndRollOverForm.OpenSourceDestTables(    TableName : String;
                                                    var Quit : Boolean);

{Open the source and destination tables with the given TableName using the ProcessingType
 for this form. the source is always the 'Thisyear' file and the destination is
 always the 'History' file}

begin
  SourceTable.Close;
  DestTable.Close;
  DestTable.Exclusive := False;

  SourceTable.TableName := TableName;
  DestTable.TableName := TableName;
(*  SourceTable.IndexName := 'BYTAXROLLYR_SBLKEY';
  DestTable.IndexName := 'BYTAXROLLYR_SBLKEY'; *)

  SetTableNameForProcessingType(SourceTable, ThisYear);
  SetTableNameForProcessingType(DestTable, History);

  try
    SourceTable.Open;
  except
    Quit := True;
    SystemSupport(005, SourceTable, 'Error opening source table ' + TableName + '.',
                  UnitName, GlblErrorDlgBox);
  end;

  try
    DestTable.Open;
  except
    Quit := True;
    SystemSupport(006, DestTable, 'Error opening dest table ' + TableName + '.',
                  UnitName, GlblErrorDlgBox);
  end;

end;  {OpenSourceDestTables}

{======================================================================}
Procedure TYearEndRollOverForm.CopyRecordsFromSourceToDestsOneTable(    TableName : String;
                                                                        SourceTable,
                                                                        DestTable : TTable;
                                                                    var Quit : Boolean);

{Given a source and destination tables (both pointing to the same type of table), along
 with a source parcel ID and destination list (both in 26 char SwisSBL format), copy all
 the records in the source table with this SwisSBL to each destination parcel ID.
 Note that if the var RecordShouldBePresentInSource is True and we could not find one record
 for the parcel, then we will give an error. Otherwise, if we do not find a record for this
 parcel ID in this table, we will ignore it.
 Also, if this is the assessment table, we only want to copy the last assessment record.}

var
  FirstTimeThrough, IsParcelTable, Done : Boolean;
  J : Integer;
  FName : String;
  RecordNo : LongInt;
  FieldType : TFieldType;

begin
  FirstTimeThrough := True;
  Done := False;
  RecordNo := 0;

  IsParcelTable := (Pos('Parcel', TableName) <> 0);

  ProgressDialog.UserLabelCaption :='Copying File To History (' +  TableName + ')'   ;

  OpenSourceDestTables(TableName, Quit);

  ProgressDialog.Reset;
  ProgressDialog.TotalNumRecords := GetRecordCount(SourceTable);

  try
    SourceTable.First;
  except
    Quit := True;
    SystemSupport(002, SourceTable, 'Error getting record in ' + SourceTable.TableName + '.',
                  UnitName, GlblErrorDlgBox);
  end;

  repeat
    RecordNo := RecordNo + 1;

    If FirstTimeThrough
      then FirstTimeThrough := False
      else
        try
          SourceTable.Next;
        except
          SystemSupport(003, SourceTable, 'Error getting next record in ' + SourceTable.TableName + '.',
                        UnitName, GlblErrorDlgBox);
        end;

    If SourceTable.EOF
      then Done := True;

    If IsParcelTable
       then ProgressDialog.Update(Self, ConvertSwisSBLToDashDot(ExtractSSKey(SourceTable)))
       else
         If ((Take(2, UpCaseStr(SourceTable.TableName)) = 'TP') and
             (Take(4, UpCaseStr(SourceTable.TableName)) <> 'TPUS'))
           then ProgressDialog.Update(Self, ConvertSwisSBLToDashDot(SourceTable.FieldByName('SwisSBLKey').AsString))
           else ProgressDialog.Update(Self, IntToStr(RecordNo));

    Application.ProcessMessages;

      {If we got a record for this source parcel id ok, then we will insert it in
       destination parcel file}
      {FXX09122002-1: Sometimes old years of data were in the This Year file
                      and caused errors.  Ignore records from years other than
                      This Year.}

    If ((not (Done or Quit)) and
        (SourceTable.FieldByName('TaxRollYr').Text = GlblThisYear))
      then
        begin
          DestTable.Insert;

             {Loop through all the fields of the source table and copy them into
              the destination table.}

           For J := 0 to (SourceTable.FieldCount - 1) do
             begin
               FName := SourceTable.Fields[J].FieldName;

               FieldType := SourceTable.FieldByName(FName).DataType;

                 {FXX09122000-1: Do not copy autoincrement IDs.}

               If (FieldType = ftMemo)
                 then CopyMemoField(SourceTable.FieldByName(FName),
                                    DestTable.FieldByName(FName))
                 else
                   If (UpcaseStr(FName) <> 'AUTOINCREMENTID')
                     then
                       try
                         DestTable.FieldByName(FName).Text := SourceTable.FieldByName(FName).Text;
                       except
                       end;

             end;  {For J := 0 to (SourceTable.FieldCount - 1) do}

           (*try *)
             DestTable.Post;
           (*except
             DestTable.Cancel;  {Ignore it for now.}
             SystemSupport(004, DestTable, 'Error posting into table ' + DestTable.TableName,
                           UnitName, GlblErrorDlgBox);
           end;  *)

        end;  {If not (Done or Quit)}

  until (Done or Quit);

  SourceTable.Close;
  DestTable.Close;

end;  {CopyRecordsFromSourceToDestsOneTable}

{======================================================================}
Procedure TYearEndRollOverForm.CopyThisYearToHist(var Quit : Boolean);

{Given a source parcel ID, copy it to all the parcels in the destination list.}

begin
  Quit := False;

  ProgressDialog.Start(1, False, False);

  CopyRecordsFromSourceToDestsOneTable(ParcelTableName,
                                       SourceTable, DestTable, Quit);

  If not Quit
    then CopyRecordsFromSourceToDestsOneTable(AssessmentTableName,
                                              SourceTable, DestTable, Quit);

  If not Quit
    then CopyRecordsFromSourceToDestsOneTable(ClassTableName,
                                              SourceTable, DestTable, Quit);

  If not Quit
    then CopyRecordsFromSourceToDestsOneTable(SpecialDistrictTableName,
                                              SourceTable, DestTable, Quit);

  If not Quit
     then CopyRecordsFromSourceToDestsOneTable(ExemptionsTableName,
                                               SourceTable, DestTable, Quit);   

  If not Quit
     then CopyRecordsFromSourceToDestsOneTable(ExemptionsDenialTableName,
                                               SourceTable, DestTable, Quit);

  If not Quit
     then CopyRecordsFromSourceToDestsOneTable(ResidentialSiteTableName,
                                               SourceTable, DestTable, Quit);

  If not Quit
     then CopyRecordsFromSourceToDestsOneTable(ResidentialBldgTableName,
                                               SourceTable, DestTable, Quit);  

  If not Quit
     then CopyRecordsFromSourceToDestsOneTable(ResidentialForestTableName,
                                               SourceTable, DestTable, Quit);

  If not Quit
     then CopyRecordsFromSourceToDestsOneTable(ResidentialLandTableName,
                                               SourceTable, DestTable, Quit); 

  If not Quit
     then CopyRecordsFromSourceToDestsOneTable(ResidentialImprovementsTableName,
                                               SourceTable, DestTable, Quit);

  If not Quit
     then CopyRecordsFromSourceToDestsOneTable(CommercialSiteTableName,
                                               SourceTable, DestTable, Quit);

  If not Quit
    then CopyRecordsFromSourceToDestsOneTable(CommercialBldgTableName,
                                              SourceTable, DestTable, Quit);

  If not Quit
    then CopyRecordsFromSourceToDestsOneTable(CommercialLandTableName,
                                              SourceTable, DestTable, Quit);

  If not Quit
    then CopyRecordsFromSourceToDestsOneTable(CommercialImprovementsTableName,
                                              SourceTable, DestTable, Quit);

  If not Quit
    then CopyRecordsFromSourceToDestsOneTable(CommercialIncomeExpenseTableName,
                                              SourceTable, DestTable, Quit);

  If not Quit
    then CopyRecordsFromSourceToDestsOneTable(CommercialRentTableName,
                                              SourceTable, DestTable, Quit);

  If not Quit
    then CopyRecordsFromSourceToDestsOneTable(AssessmentYearControlTableName,
                                              SourceTable, DestTable, Quit);

  If not Quit
    then CopyRecordsFromSourceToDestsOneTable(ExemptionCodesTableName,
                                              SourceTable, DestTable, Quit);

  If not Quit
    then CopyRecordsFromSourceToDestsOneTable(AssessmentNotesTableName,
                                              SourceTable, DestTable, Quit);

  If not Quit
    then CopyRecordsFromSourceToDestsOneTable(AssessmentLetterTextTableName,
                                              SourceTable, DestTable, Quit);

  If not Quit
     then CopyRecordsFromSourceToDestsOneTable(UserDefinitionsTableName,
                                               SourceTable, DestTable, Quit);

  If not Quit
    then CopyRecordsFromSourceToDestsOneTable(UserDataTableName,
                                              SourceTable, DestTable, Quit);

  If not Quit
    then CopyRecordsFromSourceToDestsOneTable(RTByExCodeTableName,
                                              SourceTable, DestTable, Quit);

  If not Quit
    then CopyRecordsFromSourceToDestsOneTable(RTBySchoolCodeTableName,
                                              SourceTable, DestTable, Quit);

  If not Quit
    then CopyRecordsFromSourceToDestsOneTable(RTBySDCodeTableName,
                                              SourceTable, DestTable, Quit);

  If not Quit
    then CopyRecordsFromSourceToDestsOneTable(RTBySwisCodeTableName,
                                              SourceTable, DestTable, Quit);

  If not Quit
    then CopyRecordsFromSourceToDestsOneTable(RTByRS9TableName,
                                              SourceTable, DestTable, Quit);

  If not Quit
    then CopyRecordsFromSourceToDestsOneTable(RTByVillageRelevyTableName,
                                              SourceTable, DestTable, Quit);

  If not Quit
    then CopyRecordsFromSourceToDestsOneTable(SchoolCodeTableName,
                                              SourceTable, DestTable, Quit);

  If not Quit
    then CopyRecordsFromSourceToDestsOneTable(SDistCodeTableName,
                                              SourceTable, DestTable, Quit);

  If not Quit
    then CopyRecordsFromSourceToDestsOneTable(SwisCodeTableName,
                                              SourceTable, DestTable, Quit);

end;  {CopySourceToNewParcels}

{=============================================================================}
Procedure TYearEndRollOverForm.DeleteRecordsForThisTable(    TableName : String;
                                                             TaxRollYear : String;
                                                             ProcessingType : Integer;
                                                             SwisSBLKey : String;
                                                         var Quit : Boolean);

begin
  OpenTableForProcessingType(DestTable, TableName, ProcessingType, Quit);

  If not Quit
    then DeleteRecordsForParcel(DestTable, TaxRollYear, SwisSBLKey, Quit);

  DestTable.Close;

end;   {DeleteRecordsForThisTable}

{============================================================================}
Procedure TYearEndRollOverForm.DeleteRecordsInAllTablesForThisParcel(    ParcelTable : TTable;
                                                                         TaxRollYear : String;   {next year}
                                                                         SwisSBLKey : String;
                                                                     var Quit : Boolean);

begin
  Quit := False;

  ParcelTable.Delete;

  DeleteRecordsForThisTable(AssessmentTableName,
                            TaxRollYear, NextYear, SwisSBLKey, Quit);

  If not Quit
    then DeleteRecordsForThisTable(ClassTableName,
                                   TaxRollYear, NextYear, SwisSBLKey, Quit);

  If not Quit
    then DeleteRecordsForThisTable(SpecialDistrictTableName,
                                   TaxRollYear, NextYear, SwisSBLKey, Quit);

  If not Quit
    then DeleteRecordsForThisTable(ExemptionsTableName,
                                   TaxRollYear, NextYear, SwisSBLKey, Quit);

  If not Quit
    then DeleteRecordsForThisTable(ExemptionsDenialTableName,
                                   TaxRollYear, NextYear, SwisSBLKey, Quit);

  If not Quit
    then DeleteRecordsForThisTable(ResidentialSiteTableName,
                                   TaxRollYear, NextYear, SwisSBLKey, Quit);

  If not Quit
    then DeleteRecordsForThisTable(ResidentialBldgTableName,
                                   TaxRollYear, NextYear, SwisSBLKey, Quit);

  If not Quit
    then DeleteRecordsForThisTable(ResidentialForestTableName,
                                   TaxRollYear, NextYear, SwisSBLKey, Quit);

  If not Quit
    then DeleteRecordsForThisTable(ResidentialLandTableName,
                                   TaxRollYear, NextYear, SwisSBLKey, Quit);

  If not Quit
    then DeleteRecordsForThisTable(ResidentialImprovementsTableName,
                                   TaxRollYear, NextYear, SwisSBLKey, Quit);

  If not Quit
    then DeleteRecordsForThisTable(CommercialSiteTableName,
                                   TaxRollYear, NextYear, SwisSBLKey, Quit);

  If not Quit
    then DeleteRecordsForThisTable(CommercialBldgTableName,
                                   TaxRollYear, NextYear, SwisSBLKey, Quit);

  If not Quit
    then DeleteRecordsForThisTable(CommercialLandTableName,
                                  TaxRollYear, NextYear, SwisSBLKey, Quit);

  If not Quit
    then DeleteRecordsForThisTable(CommercialImprovementsTableName,
                                   TaxRollYear, NextYear, SwisSBLKey, Quit);

  If not Quit
    then DeleteRecordsForThisTable(CommercialIncomeExpenseTableName,
                                   TaxRollYear, NextYear, SwisSBLKey, Quit);

  If not Quit
    then DeleteRecordsForThisTable(CommercialRentTableName,
                                   TaxRollYear, NextYear, SwisSBLKey, Quit);

  If not Quit
    then DeleteRecordsForThisTable(AssessmentNotesTableName,
                                   TaxRollYear, NextYear, SwisSBLKey, Quit);

  If not Quit
    then DeleteRecordsForThisTable(AssessmentLetterTextTableName,
                                   TaxRollYear, NextYear, SwisSBLKey, Quit);

  If not Quit
    then DeleteRecordsForThisTable(UserDataTableName,
                                   TaxRollYear, NextYear, SwisSBLKey, Quit);

end;  {DeleteRecordsInAllTablesForThisParcel}

{================================================================================}
Procedure TYearEndRollOverForm.UpdateTaxRollYrRecordsForTable(    TableName : String;
                                                                  IndexName : String;
                                                                  OldTaxRollYr,
                                                                  NewTaxRollYr : String;
                                                              var Quit : Boolean);

{Change the tax roll year in all records.}

var
(*  FoundRec, FirstTimeThrough, Done,
  IsParcelTable, IsExemptionTable : Boolean;
  RecordNo : LongInt;*)
  TempQuery : TQuery;

begin
(*  RecordNo := 0;
  FirstTimeThrough := True;
  Done := False;
  IsParcelTable := (Pos('Parcel', TableName) <> 0);
  IsExemptionTable := (TableName = ExemptionsTableName);
  DestTable.IndexName := IndexName;

  OpenTableForProcessingType(DestTable, TableName, NextYear, Quit);

   {The logic to loop thru a file requires that we setrange the file to the 'old' }
   {next year value so that the Table.first keeps getting the next parcel in the}
   {next year file which has yet to have its taxrollyr value altered>  }
   {This technique is used cause if we simply change the Taxrollyr value and then}
   {do a .Next, we get eof cause the indexes have been realigned}

  If not Quit
    then
      begin
        ProgressDialog.Reset;
        ProgressDialog.TotalNumRecords := GetRecordCount(DestTable);
        ProgressDialog.UserLabelCaption :='Roll Yr Update (' +  DestTable.TableName + ')'   ;

        repeat
          DestTable.CancelRange;

          If IsParcelTable
            then SetRangeOld(ParcelTable,
                             ['TaxRollYr', 'SwisCode', 'Section',
                              'Subsection', 'Block', 'Lot', 'Sublot', 'Suffix'],
                             [OldTaxRollYr, '000000', '', '', '', '', '', ''],
                             [OldTaxRollYr, '999999', '', '', '', '', '', ''])
            else
              If (UpcaseStr(IndexName) = 'BYTAXROLLYR')
                then SetRangeOld(DestTable, ['TaxRollYr'],
                                 [OldTaxRollYr], [OldTaxRollYr])
                else SetRangeOld(DestTable,
                                 ['TaxRollYr', 'SwisSBLKey'],
                                 [OldTaxRollYr, Take(26, '')],
                                 [OldTaxRollYr, ConstStr('Z', 26)]);

          DestTable.First;

          If (DestTable.EOF or
              (DestTable.FieldByName('TaxRollYr').Text <> OldTaxRollYr))
            then Done := True;

          If not (Done or Quit)
            then
              begin
                RecordNo := RecordNo + 1;

                If IsParcelTable
                   then ProgressDialog.Update(Self, ConvertSwisSBLToDashDot(ExtractSSKey(DestTable)))
                   else
                     If ((Take(2, UpCaseStr(DestTable.TableName)) = 'TP') and
                         (Take(4, UpCaseStr(DestTable.TableName)) <> 'TPUS'))
                       then ProgressDialog.Update(Self,
                                                  ConvertSwisSBLToDashDot(DestTable.FieldByName('SwisSBLKey').Text))
                       else ProgressDialog.Update(Self, IntToStr(RecordNo));

                Application.ProcessMessages;
                DestTable.Edit;
                DestTable.FieldByName('TaxRollYr').AsString := NewTaxRollYr;

                If IsExemptionTable
                  then
                    begin
                      DestTable.FieldByName('ExemptionApproved').AsBoolean := False;
                      DestTable.FieldByName('ApprovalPrinted').AsBoolean := False;

                        {FXX08011999-1: Also reset the exemption renewal printed
                                        and received flags.}

                      DestTable.FieldByName('RenewalPrinted').AsBoolean := False;
                      DestTable.FieldByName('RenewalReceived').AsBoolean := False;
                      DestTable.FieldByName('DateApprovalPrinted').Text := '';
                      DestTable.FieldByName('DateRenewalPrinted').Text := '';
                      DestTable.FieldByName('DateReminderPrinted').Text := '';
                      DestTable.FieldByName('DateRenewalReceived').Text := '';

                    end;  {If IsExemptionTable}

                try
                  DestTable.Post;
                except
                  Quit := True;
                  SystemSupport(016, DestTable, 'Error updating record in ' + DestTable.TableName + '.',
                                UnitName, GlblErrorDlgBox);
                end;

              end;  {If not (Done or Quit)}

        until (Done or Quit);

      end;  {If not Quit}

  DestTable.Close;  *)

    {CHG01162003-2: Does this through a SQL statement for increased speed.}

  TableName[1] := 'N';
  CopyStatusPanel.Visible := True;
  TYProgLabel.Visible := True;
  TYProgLabel.Caption := 'Updating NY Roll Year for ' + TableName + '.';
  Application.ProcessMessages;

  TempQuery := TQuery.Create(nil);
  TempQuery.DatabaseName := 'PASSystem';
  TempQuery.SQL.Clear;
  TempQuery.SQL.Add('UPDATE ' + TableName +
                    ' SET TAXROLLYR' +
                    ' = ''' + NewTaxRollYr +
                    ''' ');

  try
    TempQuery.Prepare;
    TempQuery.ExecSQL;
  except
    MessageDlg('Error updating tax roll year for table ' + TableName + '.', mtError,
               [mbOK], 0);
  end;

  TempQuery.Free;
  CopyStatusPanel.Visible := False;

end;  {UpdateTaxRollYrRecordsForTable}

{============================================================================}
Procedure TYearEndRollOverForm.UpdateTaxRollYearForAllRecordsInNewYearFile(    OldTaxRollYr,
                                                                               NewTaxRollYr : String;
                                                                           var Quit : Boolean);

begin
  UpdateTaxRollYrRecordsForTable(ParcelTableName, 'BYTAXROLLYR_SWISSBLKEY',
                                 OldTaxRollYr, NewTaxRollYr, Quit);

  If not Quit
    then UpdateTaxRollYrRecordsForTable(AssessmentTableName, 'BYTAXROLLYR_SWISSBLKEY',
                                        OldTaxRollYr, NewTaxRollYr, Quit);

  If not Quit
    then UpdateTaxRollYrRecordsForTable(ClassTableName, 'BYTAXROLLYR_SWISSBLKEY',
                                        OldTaxRollYr, NewTaxRollYr, Quit);

  If not Quit
    then UpdateTaxRollYrRecordsForTable(SpecialDistrictTableName, 'BYTAXROLLYR_SWISSBLKEY',
                                        OldTaxRollYr, NewTaxRollYr, Quit);

  If not Quit
    then UpdateTaxRollYrRecordsForTable(ExemptionsTableName, 'BYTAXROLLYR_SWISSBLKEY',
                                        OldTaxRollYr, NewTaxRollYr, Quit);

  If not Quit
    then UpdateTaxRollYrRecordsForTable(ResidentialSiteTableName, 'BYTAXROLLYR_SWISSBLKEY',
                                        OldTaxRollYr, NewTaxRollYr, Quit);

  If not Quit
    then UpdateTaxRollYrRecordsForTable(ResidentialBldgTableName, 'BYTAXROLLYR_SWISSBLKEY',
                                        OldTaxRollYr, NewTaxRollYr, Quit);

  If not Quit
    then UpdateTaxRollYrRecordsForTable(ResidentialForestTableName, 'BYTAXROLLYR_SWISSBLKEY',
                                        OldTaxRollYr, NewTaxRollYr, Quit);

  If not Quit
    then UpdateTaxRollYrRecordsForTable(ResidentialLandTableName, 'BYTAXROLLYR_SWISSBLKEY',
                                        OldTaxRollYr, NewTaxRollYr, Quit);

  If not Quit
    then UpdateTaxRollYrRecordsForTable(ResidentialImprovementsTableName, 'BYTAXROLLYR_SWISSBLKEY',
                                        OldTaxRollYr, NewTaxRollYr, Quit);

  If not Quit
    then UpdateTaxRollYrRecordsForTable(CommercialSiteTableName, 'BYTAXROLLYR_SWISSBLKEY',
                                        OldTaxRollYr, NewTaxRollYr, Quit);

  If not Quit
    then UpdateTaxRollYrRecordsForTable(CommercialBldgTableName, 'BYTAXROLLYR_SWISSBLKEY',
                                        OldTaxRollYr, NewTaxRollYr, Quit);

  If not Quit
    then UpdateTaxRollYrRecordsForTable(CommercialLandTableName, 'BYTAXROLLYR_SWISSBLKEY',
                                        OldTaxRollYr, NewTaxRollYr, Quit);

  If not Quit
    then UpdateTaxRollYrRecordsForTable(CommercialImprovementsTableName, 'BYTAXROLLYR_SWISSBLKEY',
                                        OldTaxRollYr, NewTaxRollYr, Quit);

  If not Quit
    then UpdateTaxRollYrRecordsForTable(CommercialIncomeExpenseTableName, 'BYTAXROLLYR_SWISSBLKEY',
                                        OldTaxRollYr, NewTaxRollYr, Quit);

  If not Quit
    then UpdateTaxRollYrRecordsForTable(CommercialRentTableName, 'BYTAXROLLYR_SWISSBLKEY',
                                        OldTaxRollYr, NewTaxRollYr, Quit);

  If not Quit
    then UpdateTaxRollYrRecordsForTable(AssessmentYearControlTableName, 'ByTaxRollYr',
                                        OldTaxRollYr, NewTaxRollYr, Quit);

  If not Quit
    then UpdateTaxRollYrRecordsForTable(ExemptionCodesTableName, 'ByTaxRollYr',
                                        OldTaxRollYr, NewTaxRollYr, Quit);

  If not Quit
    then UpdateTaxRollYrRecordsForTable(AssessmentNotesTableName, 'BYTAXROLLYR_SWISSBLKEY',
                                        OldTaxRollYr, NewTaxRollYr, Quit);

  If not Quit
    then UpdateTaxRollYrRecordsForTable(AssessmentLetterTextTableName, 'BYTAXROLLYR_SWISSBLKEY',
                                        OldTaxRollYr, NewTaxRollYr, Quit);

  If not Quit
    then UpdateTaxRollYrRecordsForTable(UserDefinitionsTableName, 'ByTaxRollYr',
                                        OldTaxRollYr, NewTaxRollYr, Quit);

  If not Quit
    then UpdateTaxRollYrRecordsForTable(UserDataTableName, 'BYTAXROLLYR_SWISSBLKEY',
                                        OldTaxRollYr, NewTaxRollYr, Quit);

  If not Quit
    then UpdateTaxRollYrRecordsForTable(RTByExCodeTableName, 'ByTaxRollYr',
                                        OldTaxRollYr, NewTaxRollYr, Quit);

  If not Quit
    then UpdateTaxRollYrRecordsForTable(RTBySchoolCodeTableName, 'ByTaxRollYr',
                                        OldTaxRollYr, NewTaxRollYr, Quit);

  If not Quit
    then UpdateTaxRollYrRecordsForTable(RTBySDCodeTableName, 'ByTaxRollYr',
                                        OldTaxRollYr, NewTaxRollYr, Quit);

  If not Quit
    then UpdateTaxRollYrRecordsForTable(RTBySwisCodeTableName, 'ByTaxRollYr',
                                        OldTaxRollYr, NewTaxRollYr, Quit);

  If not Quit
    then UpdateTaxRollYrRecordsForTable(RTByVillageRelevyTableName, 'ByTaxRollYr',
                                        OldTaxRollYr, NewTaxRollYr, Quit);

  If not Quit
    then UpdateTaxRollYrRecordsForTable(RTByRS9TableName, 'ByTaxRollYr',
                                        OldTaxRollYr, NewTaxRollYr, Quit);

  If not Quit
    then UpdateTaxRollYrRecordsForTable(SchoolCodeTableName, 'ByTaxRollYr',
                                        OldTaxRollYr, NewTaxRollYr, Quit);

  If not Quit
    then UpdateTaxRollYrRecordsForTable(SDistCodeTableName, 'ByTaxRollYr',
                                        OldTaxRollYr, NewTaxRollYr, Quit);

  If not Quit
    then UpdateTaxRollYrRecordsForTable(SwisCodeTableName, 'ByTaxRollYr',
                                        OldTaxRollYr, NewTaxRollYr, Quit);

end;  {UpdateTaxRollYearForAllRecordsInNewYearFile}

{============================================================================}
Procedure TYearEndRollOverForm.ClearExemptionFlags(ExemptionTable : TTable);

var
  Done, FirstTimeThrough : Boolean;

begin
  Done := False;
  FirstTimeThrough := True;
  ExemptionTable.First;

  ProgressDialog.UserLabelCaption := 'Reseting exemption flags.';
  ProgressDialog.Reset;
  ProgressDialog.Start(GetRecordCount(ExemptionTable), False, False);

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else ExemptionTable.Next;

    If ExemptionTable.EOF
      then Done := True;

    ProgressDialog.Update(Self, ConvertSwisSBLToDashDot(ExemptionTable.FieldByName('SwisSBLKey').Text));
    Application.ProcessMessages;

    If Done
      then
        with ExemptionTable do
          try
            Edit;

            FieldByName('ExemptionApproved').AsBoolean := False;
            FieldByName('ApprovalPrinted').AsBoolean := False;

            FieldByName('RenewalPrinted').AsBoolean := False;
            FieldByName('RenewalReceived').AsBoolean := False;
            FieldByName('DateApprovalPrinted').Text := '';
            FieldByName('DateRenewalPrinted').Text := '';
            FieldByName('DateReminderPrinted').Text := '';
            FieldByName('DateRenewalReceived').Text := '';

            Post;
          except
            SystemSupport(039, ExemptionTable, 'Error clearing exemption flag for ' +
                          ExemptionTable.FieldByName('SwisSBLKey').Text + '.',
                          UnitName, GlblErrorDlgBox);
          end;

  until Done;

end;  {ClearExemptionFlags}


{============================================================================}
Procedure TYearEndRollOverForm.InsertSortRecord(    SortTable,
                                                    ParcelTable,
                                                    AssessmentTable,
                                                    ExemptionTable,
                                                    SpecialDistrictTable : TTable;
                                                    SortRecordType : SortRecordTypesSet;
                                                var Quit : Boolean);

var
  SwisSBLKey : String;

begin
  SwisSBLKey := ExtractSSKey(ParcelTable);

  with SortTable do
    try
      Insert;

      FieldByName('SwisCode').Text := Copy(SwisSBLKey, 1, 6);
      FieldByName('SBLKey').Text := Copy(SwisSBLKey, 7, 20);
      FieldByName('Name').Text := Take(10, ParcelTable.FieldByName('Name1').Text);
      FieldByName('HomesteadCode').Text := ParcelTable.FieldByName('HomesteadCode').Text;
      FieldByName('RollSection').Text := ParcelTable.FieldByName('RollSection').Text;
      FieldByName('ActiveFlag').Text := ParcelTable.FieldByName('ActiveFlag').Text;

      If (stEraseSplitMerge in SortRecordType)
        then
          begin
            FieldByName('SplitMergeNo').Text := ParcelTable.FieldByName('SplitMergeNo').Text;
            FieldByName('Message').Text := 'Split\Merge Init';
          end;

      If (stClearSchoolRelevy in SortRecordType)
        then
          begin
            FieldByName('SchoolRelevy').AsFloat := ParcelTable.FieldByName('SchoolRelevy').AsFloat;
            FieldByName('Message').Text := 'Clear Schl Relevy';
          end;

      If (stClearVillageRelevy in SortRecordType)
        then
          begin
            FieldByName('VillageRelevy').AsFloat := ParcelTable.FieldByName('VillageRelevy').AsFloat;
            FieldByName('Message').Text := 'Clear Vill Relevy';
          end;

      If (stClearQtyIncChange in SortRecordType)
        then
          begin
            FieldByName('PhysicalQtyIncrease').AsFloat := AssessmentTable.FieldByName('PhysicalQtyIncrease').AsFloat;
            FieldByName('Message').Text := 'Clear Phys Inc';
          end;

      If (stClearQtyDecChange in SortRecordType)
        then
          begin
            FieldByName('PhysicalQtyDecrease').AsFloat := AssessmentTable.FieldByName('PhysicalQtyDecrease').AsFloat;
            FieldByName('Message').Text := 'Clear Phys Dec';
          end;

      If (stClearEqualIncChange in SortRecordType)
        then
          begin
            FieldByName('IncreaseForEqual').AsFloat := AssessmentTable.FieldByName('IncreaseForEqual').AsFloat;
            FieldByName('Message').Text := 'Clear Equal Inc';
          end;

      If (stClearEqualDecChange in SortRecordType)
        then
          begin
            FieldByName('DecreaseForEqual').AsFloat := AssessmentTable.FieldByName('DecreaseForEqual').AsFloat;
            FieldByName('Message').Text := 'Clear Equal Dec';
          end;

      If (stDeleteInactiveParcel in SortRecordType)
        then
          begin
            FieldByName('LandAssessedVal').AsFloat := AssessmentTable.FieldByName('LandAssessedVal').AsFloat;
            FieldByName('TotalAssessedVal').AsFloat := AssessmentTable.FieldByName('TotalAssessedVal').AsFloat;
            FieldByName('Message').Text := 'Remove Inactive Prcl';
          end;

      If (stDeleteRS9 in SortRecordType)
        then
          begin
            FieldByName('LandAssessedVal').AsFloat := AssessmentTable.FieldByName('LandAssessedVal').AsFloat;
            FieldByName('TotalAssessedVal').AsFloat := AssessmentTable.FieldByName('TotalAssessedVal').AsFloat;
            FieldByName('Message').Text := 'Remove RS9 Parcel';
          end;

      If (stDeleteExemption in SortRecordType)
        then
          begin
            FieldByName('EXCode').Text := ExemptionTable.FieldByName('ExemptionCode').Text;
            FieldByName('EXAmount').Text := ExemptionTable.FieldByName('Amount').Text;
            FieldByName('Message').Text := 'Exemption Removed';
          end;

      If (stClearExemptionPrintKeys in SortRecordType)
        then
          begin
            FieldByName('EXCode').Text := ExemptionTable.FieldByName('ExemptionCode').Text;
            FieldByName('EXAmount').AsFloat := ExemptionTable.FieldByName('Amount').AsFloat;
            FieldByName('EXPrintFlagsCleared').AsBoolean := True;
            FieldByName('Message').Text := 'EX Print Flags Cleared';
          end;

        {CHG08011999-3: Warn people about type 'E' special districts.}
        {FXX09132001-3: Also search for type 'S' special districts.}

      If ((stDeleteSpecialAssessmentSD in SortRecordType) or
          (stDeleteProRataSpecialDistrict in SortRecordType) or
          (stTypeESpecialDistrict in SortRecordType) or
          (stTypeSSpecialDistrict in SortRecordType))
        then
          begin
            FieldByName('SDCode').Text := SpecialDistrictTable.FieldByName('SDistCode').Text;
            FieldByName('SDCalcCode').Text := SpecialDistrictTable.FieldByName('CalcCode').Text;
            FieldByName('SDAmount').AsFloat := SpecialDistrictTable.FieldByName('CalcAmount').AsFloat;

            If (stDeleteSpecialAssessmentSD in SortRecordType)
              then FieldByName('Message').Text := 'Delete Spc Asmt SD';

            If (stDeleteProRataSpecialDistrict in SortRecordType)
              then FieldByName('Message').Text := 'Delete Prorata SD';

            If (stTypeESpecialDistrict in SortRecordType)
              then FieldByName('Message').Text := 'SD Calc code is ''E''.';

            If (stTypeSSpecialDistrict in SortRecordType)
              then FieldByName('Message').Text := 'SD Calc code is ''S''.';

          end;  {If ((stDeleteSpecialAssessmentSD in SortRecordType) or ..}

        {CHG11011999-3: Frozen assessment needs to be removed.}

      If (stFrozenAssessment in SortRecordType)
        then FieldByName('Message').Text := 'Review Frozen Date';

        {CHG11171999-1: BIE reduction support.}

      If (stReduceBIEAmount in SortRecordType)
        then
          begin
            FieldByName('EXCode').Text := ExemptionTable.FieldByName('ExemptionCode').Text;
            FieldByName('EXAmount').Text := ExemptionTable.FieldByName('Amount').Text;
            FieldByName('Message').Text := 'New BIE amt shown';

          end;  {If (stReduceBIEAmount in SortRecordType)}

      Post;
    except
      Quit := True;
      SystemSupport(010, SortTable, 'Error inserting sort record.', UnitName, GlblErrorDlgBox);
    end;

end;  {InsertSortRecord}

{============================================================================}
Procedure TYearEndRollOverForm.DeleteSpecialDistricts(    SDCode : String;
                                                          OldTaxRollYr : String;
                                                          SortTable,
                                                          SpecialDistrictTable,
                                                          ParcelTable,
                                                          AssessmentTable,
                                                          ExemptionTable : TTable;
                                                          SortRecordType : SortRecordTypesSet;
                                                      var Quit : Boolean);

{Delete all special districts with this special district.}

var
  Done : Boolean;
  SwisSBLKey : String;
  SBLRec : SBLRecord;

begin
  Done := False;

  SetRangeOld(SpecialDistrictTable, ['SDistCode'],
              [SDCode], [SDCode]);
  SpecialDistrictTable.First;

    {Note that we do not move to the next rec since delete does it for us.}

  repeat
    If SpecialDistrictTable.EOF
      then Done := True;

    If not Done
      then
        begin
          SwisSBLKey := SpecialDistrictTable.FieldByName('SwisSBLKey').Text;
          SBLRec := ExtractSwisSBLFromSwisSBLKey(SwisSBLKey);

          with SBLRec do
            FindKeyOld(ParcelTable,
                       ['TaxRollYr', 'SwisCode', 'Section',
                        'Subsection', 'Block', 'Lot', 'Sublot',
                        'Suffix'],
                       [OldTaxRollYr, SwisCode, Section, Subsection, Block, Lot,
                        Sublot, Suffix]);

          InsertSortRecord(SortTable, ParcelTable, AssessmentTable,
                           ExemptionTable, SpecialDistrictTable, SortRecordType, Quit);

          SpecialDistrictTable.Delete;

        end;  {If not Done}

  until (Quit or Done);

  SpecialDistrictTable.CancelRange;

end;  {DeleteSpecialDistricts}

{============================================================================}
Procedure TYearEndRollOverForm.CleanUpNYParcels(    OldTaxRollYr,
                                                    NewTaxRollYr : String;
                                                var NumParcels : LongInt;
                                                var TotalAssessedVal,
                                                    LandAssessedVal : Comp;
                                                var Quit : Boolean);

var
  Done, FirstTimeThrough, BeginningOfFile : Boolean;
  SwisSBLKey  : String;
  SBLRec : SBLRecord;
  AssessmentTable, ExemptionTable,
  SpecialDistrictTable, SDCodeTable,
  tbAssessmentNotes, tbExemptionsLookup,
  tbRemovedExemptions, tbAuditEXChange,
  tbAudit, tbClass,
  tbSwisCodes, tbExemptionCodes : TTable;
  OriginalBIEAmount, NewBIEAmount : Comp;
  ExemptionsNotRecalculatedList : TStringList;

begin
  ExemptionsNotRecalculatedList := TStringList.Create;
  Done := False;
  FirstTimeThrough := True;
  BeginningOfFile := False;
  NumParcels := 0;
  TotalAssessedVal := 0;
  LandAssessedVal := 0;

  AssessmentTable := TTable.Create(nil);
  ExemptionTable := TTable.Create(nil);
  SpecialDistrictTable := TTable.Create(nil);
  SDCodeTable := TTable.Create(nil);
  tbAssessmentNotes := TTable.Create(nil);
  tbExemptionsLookup := TTable.Create(nil);
  tbRemovedExemptions := TTable.Create(nil);
  tbAuditEXChange := TTable.Create(nil);
  tbAudit := TTable.Create(nil);
  tbClass := TTable.Create(nil);
  tbSwisCodes := TTable.Create(nil);
  tbExemptionCodes := TTable.Create(nil);

  SpecialDistrictTable.IndexName := 'BYSDCODE';
  AssessmentTable.IndexName := 'BYTAXROLLYR_SWISSBLKEY';
  ExemptionTable.IndexName := 'BYTAXROLLYR_SWISSBLKEY';
  SDCodeTable.IndexName := 'BYSDISTCODE';
  tbExemptionsLookup.IndexName := 'BYYEAR_SWISSBLKEY_EXCODE';
  tbClass.IndexName := 'BYTAXROLLYR_SWISSBLKEY';
  tbSwisCodes.IndexName := 'BYSWISCODE';
  tbExemptionCodes.IndexName := 'BYEXCODE';

  OpenTableForProcessingType(AssessmentTable, AssessmentTableName, NextYear, Quit);
  OpenTableForProcessingType(ExemptionTable, ExemptionsTableName, NextYear, Quit);
  OpenTableForProcessingType(SpecialDistrictTable, SpecialDistrictTableName, NextYear, Quit);
  OpenTableForProcessingType(SDCodeTable, SDistCodeTableName, NextYear, Quit);
  OpenTableForProcessingType(tbAssessmentNotes, AssessmentNotesTableName, NextYear, Quit);
  OpenTableForProcessingType(ParcelTable, ParcelTableName, NextYear, Quit);
  OpenTableForProcessingType(tbExemptionsLookup, ExemptionsTableName, NextYear, Quit);
  OpenTableForProcessingType(tbRemovedExemptions, ExemptionsRemovedTableName, NextYear, Quit);
  OpenTableForProcessingType(tbAuditEXChange, AuditEXChangesTableName, NextYear, Quit);
  OpenTableForProcessingType(tbAudit, AuditTableName, NextYear, Quit);
  OpenTableForProcessingType(tbClass, ClassTableName, NextYear, Quit);
  OpenTableForProcessingType(tbSwisCodes, SwisCodeTableName, NextYear, Quit);
  OpenTableForProcessingType(tbExemptionCodes, ExemptionCodesTableName, NextYear, Quit);


  ProgressDialog.Reset;
  ProgressDialog.TotalNumRecords := GetRecordCount(ParcelTable);
  ProgressDialog.UserLabelCaption := 'Update-Next Year Dtl. File';

  ParcelTable.First;

  repeat
      {FXX08231999-1: Do not go to the next parcel if it is inactive or rs 9
                      so that it gets deleted.}

    If FirstTimeThrough
      then FirstTimeThrough := False
      else
        If ((ParcelTable.FieldByName('ActiveFlag').Text <> InactiveParcelFlag) and
           (* ((not GlblEnablePermanentRetentionFeature) or
             (GlblEnablePermanentRetentionFeature and
              (not ParcelTable.FieldByName('RetainPermanently').AsBoolean))) and *)
            (ParcelTable.FieldByName('RollSection').Text <> '9') and
            (not BeginningOfFile))
          then ParcelTable.Next;

    BeginningOfFile := False;  {Reset}

    SwisSBLKey := ExtractSSKey(ParcelTable);
    ProgressDialog.Update(Self, ConvertSwisSBLToDashDot(SwisSBLKey));
    Application.ProcessMessages;

    If ParcelTable.EOF
      then Done := True;

      {CHG04082005-1(2.8.3.16)[2093]: Add feature to permanently retain parcels.}

    If not Done
      then
        If ((ParcelTable.FieldByName('ActiveFlag').Text = InactiveParcelFlag) and
            ((not GlblEnablePermanentRetentionFeature) or
             (GlblEnablePermanentRetentionFeature and
              ParcelTable.FieldByName('RetainPermanently').AsBoolean)))
          then ParcelTable.Next
          else
            begin
              NumParcels := NumParcels + 1;

                {Clear split merge number.}

              If ((ParcelTable.FieldByName('ActiveFlag').Text <> InactiveParcelFlag) and
                  (ParcelTable.FieldByName('RollSection').Text <> '9') and
                  (Deblank(ParcelTable.FieldByName('SplitMergeNo').Text) <> ''))
                then
                  begin
                    InsertSortRecord(SortTable, ParcelTable, AssessmentTable,
                                     ExemptionTable, SpecialDistrictTable, [stEraseSplitMerge], Quit);

                    with ParcelTable do
                      try
                        Edit;
                        FieldByName('SplitMergeNo').Text := '';
                        FieldByName('RelatedSBL').Text := '';
                        FieldByName('SBLRelationship').Text := '';

                        Post;
                      except
                        Quit := True;
                        SystemSupport(80, ParcelTable, 'Error erasing split merge fields.',
                                      UnitName, GlblErrorDlgBox);
                      end;

                  end;  {(Roundoff(ParcelTable.FieldByName('SchoolRelevy').AsFloat, 2) > 0) ...}

                {CHG09012001-2: Clear the extract fields.}

              with ParcelTable do
                try
                  Edit;

                  FieldByName('AddressExtracted').AsBoolean := False;
                  FieldByName('DateAddressChanged').Text := '';
                  FieldByName('ChangeExtracted').AsBoolean := False;
                  FieldByName('DateChangedForExtract').Text := '';
                  Post;
                except
                  Quit := True;
                  SystemSupport(80, ParcelTable, 'Error erasing split merge fields.',
                                UnitName, GlblErrorDlgBox);
                end;

                {Clear relevy fields}

              If ((ParcelTable.FieldByName('ActiveFlag').Text <> InactiveParcelFlag) and
                  (ParcelTable.FieldByName('RollSection').Text <> '9') and
                  ((Roundoff(ParcelTable.FieldByName('SchoolRelevy').AsFloat, 2) > 0) or
                   (Roundoff(ParcelTable.FieldByName('VillageRelevy').AsFloat, 2) > 0)))
                then
                  begin
                    If (Roundoff(ParcelTable.FieldByName('SchoolRelevy').AsFloat, 2) > 0)
                      then InsertSortRecord(SortTable, ParcelTable, AssessmentTable,
                                            ExemptionTable, SpecialDistrictTable,
                                            [stClearSchoolRelevy], Quit);

                    If (Roundoff(ParcelTable.FieldByName('VillageRelevy').AsFloat, 2) > 0)
                      then InsertSortRecord(SortTable, ParcelTable, AssessmentTable,
                                            ExemptionTable, SpecialDistrictTable,
                                            [stClearVillageRelevy], Quit);

                    with ParcelTable do
                      try
                        Edit;
                        FieldByName('VillageRelevy').AsFloat := 0;
                        FieldByName('SchoolRelevy').AsFloat := 0;
                        Post;
                      except
                        Quit := True;
                        SystemSupport(80, ParcelTable, 'Error erasing split merge fields.',
                                      UnitName, GlblErrorDlgBox);
                      end;

                  end;  {If ((ParcelTable.FieldByName('ActiveFlag').Text = InactiveParcelFlag) and ...}

                {Clear assessed value change fields.}

              SwisSBLKey := ExtractSSKey(ParcelTable);

              with AssessmentTable do
                begin
                  FindKeyOld(AssessmentTable,
                             ['TaxRollYr', 'SwisSBLKey'],
                             [OldTaxRollYr, SwisSBLKey]);

                  TotalAssessedVal := TotalAssessedVal + FieldByName('TotalAssessedVal').AsFloat;
                  LandAssessedVal := LandAssessedVal + FieldByName('LandAssessedVal').AsFloat;

                end;  {with AssessmentTable do}

                {CHG11011999-3: Frozen assessment needs to be removed.}
                {FXX04302006-1(2.9.7.1): Clear the frozen information as part of the rollover.}

              with AssessmentTable do
                If (_Compare(FieldByName('DateFrozen').Text, coNotBlank) and
                    _Compare(FieldByName('DateFrozen').AsDateTime, Date, coLessThanOrEqual))
                  then
                    begin
                      InsertSortRecord(SortTable, ParcelTable, AssessmentTable,
                                       ExemptionTable, SpecialDistrictTable,
                                       [stFrozenAssessment], Quit);

                      try
                        Edit;
                        FieldByName('DateFrozen').Text := '';
                        FieldByName('ReasonFrozen').Text := '';
                        Post;
                      except
                      end;

                    end;  {If (_Compare(FieldByName('DateFrozen').Text, coNotBlank) and ...}

                {CHG05292000-1: Make sure to clear partial assessment.}
                {FXX09132001-2: Actually, make it an option.}

              If ((ParcelTable.FieldByName('ActiveFlag').Text <> InactiveParcelFlag) and
                  (ParcelTable.FieldByName('RollSection').Text <> '9') and
                  ((Roundoff(AssessmentTable.FieldByName('IncreaseForEqual').AsFloat, 2) > 0) or
                   (Roundoff(AssessmentTable.FieldByName('DecreaseForEqual').AsFloat, 2) > 0) or
                   (Roundoff(AssessmentTable.FieldByName('PhysicalQtyIncrease').AsFloat, 2) > 0) or
                   (Roundoff(AssessmentTable.FieldByName('PhysicalQtyDecrease').AsFloat, 2) > 0)) or
                   (ClearPartialAssessments and
                    AssessmentTable.FieldByName('PartialAssessment').AsBoolean))
                then
                  begin
                    If (AssessmentTable.FieldByName('IncreaseForEqual').AsFloat > 0)
                      then InsertSortRecord(SortTable, ParcelTable, AssessmentTable,
                                            ExemptionTable, SpecialDistrictTable,
                                            [stClearEqualIncChange], Quit);

                    If (AssessmentTable.FieldByName('DecreaseForEqual').AsFloat > 0)
                      then InsertSortRecord(SortTable, ParcelTable, AssessmentTable,
                                            ExemptionTable, SpecialDistrictTable,
                                            [stClearEqualDecChange], Quit);

                    If (AssessmentTable.FieldByName('PhysicalQtyIncrease').AsFloat > 0)
                      then InsertSortRecord(SortTable, ParcelTable, AssessmentTable,
                                            ExemptionTable, SpecialDistrictTable,
                                            [stClearQtyIncChange], Quit);

                    If (AssessmentTable.FieldByName('PhysicalQtyDecrease').AsFloat > 0)
                      then InsertSortRecord(SortTable, ParcelTable, AssessmentTable,
                                            ExemptionTable, SpecialDistrictTable,
                                            [stClearQtyDecChange], Quit);

                    with AssessmentTable do
                      try
                        Edit;
                        FieldByName('IncreaseForEqual').AsFloat := 0;
                        FieldByName('DecreaseForEqual').AsFloat := 0;
                        FieldByName('PhysicalQtyIncrease').AsFloat := 0;
                        FieldByName('PhysicalQtyDecrease').AsFloat := 0;

                        If ClearPartialAssessments
                          then FieldByName('PartialAssessment').AsBoolean := False;
                        Post;
                      except
                        Quit := True;
                        SystemSupport(80, AssessmentTable, 'Error erasing split merge fields.',
                                      UnitName, GlblErrorDlgBox);
                      end;

                  end;  {If ((ParcelTable.FieldByName('ActiveFlag').Text = InactiveParcelFlag) and ...}

                 {Delete inactive parcels from the NY file.}
                 {CHG04082005-1(2.8.3.16)[2093]: Add feature to permanently retain parcels.}

              If ((ParcelTable.FieldByName('ActiveFlag').Text = InactiveParcelFlag) and
                  ((not GlblEnablePermanentRetentionFeature) or
                   (GlblEnablePermanentRetentionFeature and
                    (not ParcelTable.FieldByName('RetainPermanently').AsBoolean))))
                then
                  begin
                    BeginningOfFile := ParcelTable.BOF;

                    InsertSortRecord(SortTable, ParcelTable, AssessmentTable,
                                     ExemptionTable, SpecialDistrictTable, [stDeleteInactiveParcel], Quit);
                    DeleteRecordsInAllTablesForThisParcel(ParcelTable, OldTaxRollYr,
                                                          SwisSBLKey, Quit);

                      {FXX09221998-1: Make up for the fact that delete already puts us on the
                      next record.}

                    If BeginningOfFile
                      then ParcelTable.First  {Reset to first parcel}
                      else ParcelTable.Prior;

                  end;  {If (ParcelTable.FieldByName('ActiveFlag').Text = InactiveParcelFlag)}

                 {Delete roll section 9 parcels.}

              If (ParcelTable.FieldByName('RollSection').Text = '9')
                then
                  begin
                    BeginningOfFile := ParcelTable.BOF;
                    InsertSortRecord(SortTable, ParcelTable, AssessmentTable,
                                     ExemptionTable, SpecialDistrictTable, [stDeleteRS9], Quit);
                    DeleteRecordsInAllTablesForThisParcel(ParcelTable, OldTaxRollYr,
                                                          SwisSBLKey, Quit);

                      {FXX09221998-1: Make up for the fact that delete already puts us on the
                      next record.}

                    If BeginningOfFile
                      then ParcelTable.First  {Reset to first parcel}
                      else ParcelTable.Prior;

                  end;  {If (ParcelTable.FieldByName('RollSection').Text = '9')}

            end;  {else of If ((ParcelTable.FieldByName('ActiveFlag').Text...}

  until (Done or Quit);

    {FXX04232009-18(2.20.1.1)[D1166]: Clear the assessment notes.}

  DeleteTable(tbAssessmentNotes);

   {Now go through and remove any exemption which is past the expiration date.}
   {FXX11191999-1: Also reduce the BIE exemptions and remove if now 0.}

  ProgressDialog.Reset;
  ProgressDialog.TotalNumRecords := GetRecordCount(ExemptionTable);
  ProgressDialog.UserLabelCaption := 'Delete terminated exemptions \ Update BIEs';

  If not Quit
    then
      begin
        Done := False;
        FirstTimeThrough := True;

        ExemptionTable.First;

        repeat
          If FirstTimeThrough
            then FirstTimeThrough := False
            else ExemptionTable.Next;

          If ExemptionTable.EOF
            then Done := True;

          Application.ProcessMessages;
          ProgressDialog.Update(Self, ConvertSwisSBLToDashDot(ExemptionTable.FieldByName('SwisSBLKey').Text));

          If not Done
            then
              with ExemptionTable do
                begin
                  If ((Deblank(FieldByName('TerminationDate').Text) <> '') and
                      (FieldByName('TerminationDate').AsDateTime < Date))
                    then
                      begin
                        SwisSBLKey := ExemptionTable.FieldByName('SwisSBLKey').Text;
                        SBLRec := ExtractSwisSBLFromSwisSBLKey(SwisSBLKey);

                        with SBLRec do
                          FindKeyOld(ParcelTable,
                                     ['TaxRollYr', 'SwisCode', 'Section',
                                      'Subsection', 'Block', 'Lot', 'Sublot',
                                      'Suffix'],
                                     [OldTaxRollYr, SwisCode, Section, Subsection, Block, Lot,
                                      Sublot, Suffix]);

                        InsertSortRecord(SortTable, ParcelTable, AssessmentTable,
                                         ExemptionTable, SpecialDistrictTable, [stDeleteExemption], Quit);

                          {FXX04232009-19(2.20.1.1)[D962]: Insert a removed exemption if an exemption is deleted
                                                           because it is terminated.}
                          {FXX04232009-20(2.20.1.1)[D963]: Insert an audit if an exemption is deleted
                                                           because it is terminated.}

                        DeleteAnExemption(ExemptionTable,
                                          tbExemptionsLookup,
                                          tbRemovedExemptions,
                                          tbAuditEXChange,
                                          tbAudit,
                                          AssessmentTable,
                                          tbClass,
                                          tbSwisCodes,
                                          ParcelTable,
                                          tbExemptionCodes,
                                          GlblNextYear,
                                          SwisSBLKey,
                                          ExemptionsNotRecalculatedList);

                      end;  {If ((Deblank(FieldByName('TerminationDate').Text) <> '') ...}

                    {Remove any print flags that are on.}

                  If (FieldByName('ExemptionApproved').AsBoolean or
                      FieldByName('ApprovalPrinted').AsBoolean or
                      FieldByName('RenewalReceived').AsBoolean or
                      FieldByName('RenewalPrinted').AsBoolean or
                      FieldByName('ReminderPrinted').AsBoolean or
                      (Deblank(FieldByName('DateApprovalPrinted').Text) <> '') or
                      (Deblank(FieldByName('DateReminderPrinted').Text) <> '') or
                      (Deblank(FieldByName('DateRenewalReceived').Text) <> '') or
                      (Deblank(FieldByName('DateRenewalPrinted').Text) <> ''))
                    then
                      begin
                        try
                          SwisSBLKey := ExemptionTable.FieldByName('SwisSBLKey').Text;
                          SBLRec := ExtractSwisSBLFromSwisSBLKey(SwisSBLKey);

                          with SBLRec do
                            FindKeyOld(ParcelTable,
                                       ['TaxRollYr', 'SwisCode', 'Section',
                                        'Subsection', 'Block', 'Lot', 'Sublot',
                                        'Suffix'],
                                       [OldTaxRollYr, SwisCode, Section, Subsection, Block, Lot,
                                        Sublot, Suffix]);

                          Edit;

                          FieldByName('ExemptionApproved').AsBoolean := False;
                          FieldByName('ApprovalPrinted').AsBoolean := False;
                          FieldByName('RenewalReceived').AsBoolean := False;
                          FieldByName('RenewalPrinted').AsBoolean := False;
                          FieldByName('ReminderPrinted').AsBoolean := False;
                          FieldByName('DateApprovalPrinted').Text := '';
                          FieldByName('DateReminderPrinted').Text := '';
                          FieldByName('DateRenewalReceived').Text := '';
                          FieldByName('DateRenewalPrinted').Text := '';

                          Post;
                        except
                          Quit := True;
                          SystemSupport(80, ExemptionTable, 'Error clearing exemption print flags.',
                                        UnitName, GlblErrorDlgBox);
                        end;

                          {CHG08011999-1: Give option to print the exemption
                                          flags cleared.}

                        If PrintExemptionFlagsClearedCheckBox.Checked
                          then InsertSortRecord(SortTable, ParcelTable, AssessmentTable,
                                                ExemptionTable, SpecialDistrictTable,
                                                [stClearExemptionPrintKeys], Quit);

                      end;  {If (FieldByName('ExemptionApproved').AsBoolean or ...}

                    {CHG11171999-1: Reduce BIE Exemptions.}
                    {FXX12081999-4: Need function to test for BIE in case not 47600.}

                  If (AutoReduceBIEExemptions and
                      IsBIEExemptionCode(FieldByName('ExemptionCode').Text))
                    then
                      begin
                        NewBIEAmount := 0;
                        try
                          SwisSBLKey := ExemptionTable.FieldByName('SwisSBLKey').Text;
                          SBLRec := ExtractSwisSBLFromSwisSBLKey(SwisSBLKey);

                          with SBLRec do
                            FindKeyOld(ParcelTable,
                                       ['TaxRollYr', 'SwisCode', 'Section',
                                        'Subsection', 'Block', 'Lot',
                                        'Sublot', 'Suffix'],
                                       [OldTaxRollYr, SwisCode, Section, Subsection,
                                        Block, Lot, Sublot, Suffix]);

                          Edit;

                          OriginalBIEAmount := FieldByName('OriginalBIEAmount').AsFloat;
                          NewBIEAmount := Roundoff((FieldByName('Amount').AsFloat -
                                                    (OriginalBIEAmount / 10)), 0);

                          FieldByName('Amount').AsFloat := NewBIEAmount;
                          FieldByName('TownAmount').AsFloat := NewBIEAmount;
                          FieldByName('CountyAmount').AsFloat := NewBIEAmount;
                          FieldByName('SchoolAmount').AsFloat := NewBIEAmount;
                          FieldByName('VillageAmount').AsFloat := NewBIEAmount;

                          Post;
                        except
                          Quit := True;
                          SystemSupport(80, ExemptionTable, 'Error updating BIE amount.',
                                        UnitName, GlblErrorDlgBox);
                        end;

                        InsertSortRecord(SortTable, ParcelTable, AssessmentTable,
                                         ExemptionTable, SpecialDistrictTable,
                                         [stReduceBIEAmount], Quit);

                          {If the new BIE amount is 0, then delete it.}

                        If (Roundoff(NewBIEAmount, 0) = 0)
                          then
                            begin
                              InsertSortRecord(SortTable, ParcelTable, AssessmentTable,
                                               ExemptionTable, SpecialDistrictTable,
                                               [stReduceBIEAmount], Quit);

                              try
                                Delete;
                              except
                                Quit := True;
                                SystemSupport(80, ExemptionTable, 'Error deleting exemption.',
                                              UnitName, GlblErrorDlgBox);
                              end;

                            end;  {If (Roundoff(NewBIEAmount, 0) = 0)}

                      end;  {If (FieldByName('ExemptionCode').Text = BIEExemptionCode)}

                end;  {with ExemptionTable do}

        until (Done or Quit);

      end;  {If not Quit}

    ClearExemptionFlags(ExemptionTable);

   {Now search through the special district code table to look for pro-rata special districts.
    Then search through the parcel special district table and delete them all.}

  If not Quit
    then
      begin
        Done := False;
        FirstTimeThrough := True;
        SDCodeTable.First;

        ProgressDialog.Reset;
        ProgressDialog.TotalNumRecords := GetRecordCount(SDCodeTable);
        ProgressDialog.UserLabelCaption := 'Delete prorata special districts';

        repeat
          If FirstTimeThrough
            then FirstTimeThrough := False
            else SDCodeTable.Next;

          If SDCodeTable.EOF
            then Done := True;

          Application.ProcessMessages;
          ProgressDialog.Update(Self, 'SD Code: ' + SDCodeTable.FieldByName('SDistCode').Text);

          If ((not Done) and
              SDCodeTable.FieldByName('SDRs9').AsBoolean)
            then DeleteSpecialDistricts(SDCodeTable.FieldByName('SDistCode').Text,
                                        OldTaxRollYr, SortTable,
                                        SpecialDistrictTable,
                                        ParcelTable, AssessmentTable,
                                        ExemptionTable,
                                        [stDeleteProRataSpecialDistrict], Quit);

          If ((not Done) and
              (SDCodeTable.FieldByName('DistrictType').Text = SDSpclAssessmentType) and
              (SDCodeTable.FieldByName('ECd1').Text = SdistEcMT))
            then DeleteSpecialDistricts(SDCodeTable.FieldByName('SDistCode').Text,
                                        OldTaxRollYr, SortTable,
                                        SpecialDistrictTable,
                                        ParcelTable, AssessmentTable,
                                        ExemptionTable,
                                        [stDeleteSpecialAssessmentSD], Quit);

        until (Quit or Done);

      end;  {If not Quit}

    {CHG08011999-3: Warn people about type 'E' special districts.}

  If not Quit
    then
      begin
        Done := False;
        FirstTimeThrough := True;
        SpecialDistrictTable.First;

        ProgressDialog.Reset;
        ProgressDialog.TotalNumRecords := GetRecordCount(SpecialDistrictTable);

          {FXX09132001-3: Also search for type 'S' special districts.}

        ProgressDialog.UserLabelCaption := 'Find type ''E'' and ''S'' special districts.';

        repeat
          If FirstTimeThrough
            then FirstTimeThrough := False
            else SpecialDistrictTable.Next;

          If SpecialDistrictTable.EOF
            then Done := True;

          Application.ProcessMessages;
          SwisSBLKey := SpecialDistrictTable.FieldByName('SwisSBLKey').Text;
          ProgressDialog.Update(Self, 'SD for Parcel: ' +
                                ConvertSwisSBLToDashDot(SpecialDistrictTable.FieldByName('SwisSBLKey').Text));

          If ((not Done) and
              (Take(1, SpecialDistrictTable.FieldByName('CalcCode').Text)[1] in ['E', 'S']))
            then
              begin
                SwisSBLKey := SpecialDistrictTable.FieldByName('SwisSBLKey').Text;
                SBLRec := ExtractSwisSBLFromSwisSBLKey(SwisSBLKey);

                with SBLRec do
                  FindKeyOld(ParcelTable,
                             ['TaxRollYr', 'SwisCode', 'Section',
                              'Subsection', 'Block', 'Lot',
                              'Sublot', 'Suffix'],
                             [OldTaxRollYr, SwisCode, Section, Subsection,
                              Block, Lot, Sublot, Suffix]);

                If (SpecialDistrictTable.FieldByName('CalcCode').Text = 'E')
                  then InsertSortRecord(SortTable, ParcelTable, AssessmentTable,
                                        ExemptionTable, SpecialDistrictTable,
                                        [stTypeESpecialDistrict], Quit);

                If (SpecialDistrictTable.FieldByName('CalcCode').Text = 'S')
                  then InsertSortRecord(SortTable, ParcelTable, AssessmentTable,
                                        ExemptionTable, SpecialDistrictTable,
                                        [stTypeSSpecialDistrict], Quit);

              end;  {If ((not Done) and ...}

        until (Quit or Done);

      end;  {If not Quit}

    {CHG09012001-1: Empty out the denied exemptions table.}

  If not Quit
    then
      begin
        NYDeniedExemptionsTable.Close;
        NYDeniedExemptionsTable.Exclusive := True;

        try
          NYDeniedExemptionsTable.Open;
        except
          SystemSupport(040, NYDeniedExemptionsTable, 'Error opening NY Denied exemptions table.' +
                        'Processing will continue.' ,
                        UnitName, GlblErrorDlgBox);
        end;

        ProgressDialog.Update(Self, 'Clearing denied exemptions table.');
        Application.ProcessMessages;

        If NYDeniedExemptionsTable.Active
          then NYDeniedExemptionsTable.EmptyTable;

      end;  {If not Quit}

   {Alter the taxrollyr variable in all year-dependent recs in new year file}

  If not Quit
    then UpdateTaxRollYearForAllRecordsInNewYearFile(OldTaxRollYr, NewTaxRollYr, Quit);

  ParcelTable.Close;

  AssessmentTable.Close;
  ExemptionTable.Close;
  SpecialDistrictTable.Close;
  SDCodeTable.Close;
  tbAssessmentNotes.Close;
  tbExemptionsLookup.Close;
  tbRemovedExemptions.Close;
  tbAuditEXChange.Close;
  tbAudit.Close;
  tbClass.Close;
  tbSwisCodes.Close;
  tbExemptionCodes.Close;

  AssessmentTable.Free;
  ExemptionTable.Free;
  SpecialDistrictTable.Free;
  SDCodeTable.Free;
  tbAssessmentNotes.Free;
  tbExemptionsLookup.Free;
  tbRemovedExemptions.Free;
  tbAuditEXChange.Free;
  tbAudit.Free;
  tbClass.Free;
  tbSwisCodes.Free;
  tbExemptionCodes.Free;

  ExemptionsNotRecalculatedList.Free;

end;  {CleanUpNYParcels}

{==============================================================================================}
Procedure TYearEndRollOverForm.UpdateValuesFromScreen(var Quit : Boolean);

var
  Done, FirstTimeThrough : Boolean;

begin
    {CHG01201999-1: Add the fields for setting the Next Year values.}

  OpenTableForProcessingType(AssmtYrCtlTable, AssessmentYearControlTableName,
                             NextYear, Quit);
  OpenTableForProcessingType(ExemptionCodeTable, ExemptionCodesTableName,
                             NextYear, Quit);
  OpenTableForProcessingType(SwisCodeTable, SwisCodeTableName,
                             NextYear, Quit);

  with AssmtYrCtlTable do
    try
      Edit;
      FieldByName('TaxableStatusDate').Text := TaxableStatusDateEdit.Text;
      FieldByName('FinalRollDate').Text := FinalRollDateEdit.Text;
      FieldByName('ValuationDate').Text := ValuationDateEdit.Text;
      FieldByName('VeteransLimitSet').Text := CountyVeteransLimitsDropdown.Text;
      FieldByName('NextSplitMergeNo').AsInteger := StrToInt(StartingSplitMergeNumberEdit.Text);

        {Don't forget to blank out the next billing numbers, too.}

      FieldByName('NxtMunTaxCollNo').AsInteger := 0;
      FieldByName('NextVilTaxCollNo').AsInteger := 0;
      FieldByName('NextSchTaxCollNo').AsInteger := 0;

      Post;
    except
      Quit := True;
      SystemSupport(087, AssmtYrCtlTable, 'Error updating assessment year control table.',
                    UnitName, GlblErrorDlgBox);
    end;

    {Update the STAR amounts.}

  try
    FindKeyOld(ExemptionCodeTable, ['EXCode'], [BasicSTARExemptionCode]);
    ExemptionCodeTable.Edit;
    ExemptionCodeTable.FieldByName('FixedAmount').Text := BasicSTARAmountEdit.Text;
    ExemptionCodeTable.Post;
  except
    Quit := True;
    SystemSupport(088, ExemptionCodeTable, 'Error updating basic STAR amount.',
                  UnitName, GlblErrorDlgBox);
  end;

  try
    FindKeyOld(ExemptionCodeTable, ['EXCode'], [EnhancedSTARExemptionCode]);
    ExemptionCodeTable.Edit;
    ExemptionCodeTable.FieldByName('FixedAmount').Text := EnhancedSTARAmountEdit.Text;
    ExemptionCodeTable.Post;
  except
    Quit := True;
    SystemSupport(088, ExemptionCodeTable, 'Error updating enhanced STAR amount.',
                  UnitName, GlblErrorDlgBox);
  end;

    {Now for each swis, set the vet limit, eq rate and unif % of val.}

  Done := False;
  FirstTimeThrough := True;
  SwisCodeTable.First;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else SwisCodeTable.Next;

    If SwisCodeTable.EOF
      then Done := True;

    If not Done
      then
        with SwisCodeTable do
          try
            Edit;
            FieldByName('VeteransLimitSet').Text := TownVeteransLimitsDropdown.Text;
            FieldByName('EqualizationRate').AsFloat := StrToFloat(EqualizationRateEdit.Text);
            FieldByName('UniformPercentValue').AsFloat := StrToFloat(UniformPercentOfValueEdit.Text);
            Post;
          except
            Quit := True;
            SystemSupport(089, SwisCodeTable, 'Error updating swis records.',
                          UnitName, GlblErrorDlgBox);

          end;

  until (Done or Quit);

end;  {UpdateValuesFromScreen}

{====================================================================================}
Procedure TYearEndRollOverForm.UpdateProratedSpecialDistricts(Sender : TObject);

var
  Found, Done, FirstTimeThrough, Quit : Boolean;
  OldSDCode, NewSdCode, TempStr : String;
  TempInt : Integer;

begin
  ReportSection := rsChangeSDCodes;
  TBaseReport(Sender).NewPage;

  OpenTableForProcessingType(SDCodeTable, SdistCodeTableName,
                             NextYear, Quit);
  OpenTableForProcessingType(SDCodeLookupTable, SdistCodeTableName,
                             NextYear, Quit);

  Done := False;
  FirstTimeThrough := True;
  NewSDCode := '';
  SDCodeTable.IndexName := 'BYSDISTCODE';
  SDCodeLookupTable.IndexName := 'BYSDISTCODE';
  SDCodeTable.First;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else SDCodeTable.Next;

    If SDCodeTable.EOF
      then Done := True;

    OldSDCode := SDCodeTable.FieldByName('SDistCode').Text;

    If ((not Done) and
        SpecialDistrictIsMoveTax(SDCodeTable) and
        SDCodeTable.FieldByName('ProRataOmit').AsBoolean)
      then
        begin
            {Are the last 2 chars a number? If so, then we will delete the old, insert
             the new.}

          TempStr := Copy(OldSDCode, 4, 2);

          try
            TempInt := StrToInt(TempStr);

              {Force 1999 to go to 00.}

            If (TempInt = 99)
              then TempInt := -1;

            NewSDCode := Copy(OldSDCode, 1, 3) +
                         ShiftRightAddZeroes(Take(2, IntToStr(TempInt + 1)));

            Found := FindKeyOld(SDCodeLookupTable, ['SDistCode'],
                                [NewSDCode]);

            If not Found
              then
                begin
                    {Copy to new year.}

                  CopyTable_OneRecord(SDCodeTable, SDCodeLookupTable,
                                      ['SDistCode'], [NewSDCode]);

                    {Now delete the old prorata SD code.}

                  SDCodeTable.Delete;

                  with Sender as TBaseReport do
                    begin
                      ClearTabs;
                      SetTab(0.5, pjLeft, 3.5, 0, BOXLINENone, 0);   {swis}
                      Println(#9 + 'Deleted: ' + OldSDCode);
                      Println(#9 + 'Added: ' + NewSDCode);

                    end;  { with Sender as TBaseReport do}

                end;  {If not Found}

          except
          end;

        end;  {If ((not Done) and ...}

  until Done;

end;  {UpdateProratedSpecialDistricts}

{====================================================================================}
Procedure TYearEndRollOverForm.DeleteNextYearParcelsInBothYears(var Quit : Boolean);

var
  _Found, Done, FirstTimeThrough : Boolean;
  ThisYearParcelTable, NextYearParcelTable : TTable;
  SwisSBLKey : String;

begin
  Quit := False;
  ThisYearParcelTable := TTable.Create(nil);
  OpenTableForProcessingType(ThisYearParcelTable, ParcelTableName,
                             ThisYear, Quit);

  NextYearParcelTable := TTable.Create(nil);
  OpenTableForProcessingType(NextYearParcelTable, ParcelTableName,
                             NextYear, Quit);

  NextYearParcelTable.IndexName := 'BYTAXROLLYR_SWISSBLKEY';

  ProgressDialog.Start(GetRecordCount(ThisYearParcelTable), False, False);
  ProgressDialog.UserLabelCaption := 'Deleting Inactive Parcels in NY in Both Years.';

  Done := False;
  FirstTimeThrough := True;
  ThisYearParcelTable.First;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else ThisYearParcelTable.Next;

    If ThisYearParcelTable.EOF
      then Done := True;

    SwisSBLKey := ExtractSSKey(ThisYearParcelTable);
    ProgressDialog.Update(Self, ConvertSwisSBLToDashDot(SwisSBLKey));
    Application.ProcessMessages;

      {CHG04082005-1(2.8.3.16)[2093]: Add feature to permanently retain parcels.}

    If ((not Done) and
        (ThisYearParcelTable.FieldByName('ActiveFlag').Text = InactiveParcelFlag) and
        ((not GlblEnablePermanentRetentionFeature) or
         (GlblEnablePermanentRetentionFeature and
          (not ThisYearParcelTable.FieldByName('RetainPermanently').AsBoolean))))
      then
        begin
          with ThisYearParcelTable do
            _Found := FindKeyOld(NextYearParcelTable,
                                 ['TaxRollYr', 'SwisCode', 'Section', 'Subsection',
                                  'Block', 'Lot', 'Sublot', 'Suffix'],
                                 [GlblNextYear,
                                  FieldByName('SwisCode').Text,
                                  FieldByName('Section').Text,
                                  FieldByName('Subsection').Text,
                                  FieldByName('Block').Text,
                                  FieldByName('Lot').Text,
                                  FieldByName('Sublot').Text,
                                  FieldByName('Suffix').Text]);

          If (_Found and
              (NextYearParcelTable.FieldByName('ActiveFlag').Text = InactiveParcelFlag) and
              ((not GlblEnablePermanentRetentionFeature) or
               (GlblEnablePermanentRetentionFeature and
                (not NextYearParcelTable.FieldByName('RetainPermanently').AsBoolean))))
            then DeleteRecordsInAllTablesForThisParcel(NextYearParcelTable,
                                                       GlblNextYear,
                                                       SwisSBLKey, Quit);

        end;  {If ((not Done) and ...}

  until Done;

  ThisYearParcelTable.Close;
  ThisYearParcelTable.Free;

  NextYearParcelTable.Close;
  NextYearParcelTable.Free;

end;  {DeleteNextYearParcelsInBothYears}

{====================================================================================}
Procedure TYearEndRollOverForm.ResetNameAddressChangeLabels;

{Ignore any errors - this is not that important.}
{Mark all Name\Address records as checked off so that they won't appear on
 the parcels.}

var
  Done, FirstTimeThrough : Boolean;

begin
  NameAddressAuditTable.Open;
  ProgressDialog.Reset;
  ProgressDialog.TotalNumRecords := GetRecordCount(NameAddressAuditTable);
  ProgressDialog.UserLabelCaption := 'Resetting name\address change audit flags.';

  Done := False;
  FirstTimeThrough := True;

  NameAddressAuditTable.First;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else NameAddressAuditTable.Next;

    If NameAddressAuditTable.EOF
      then Done := True;

    ProgressDialog.Update(Self, ConvertSwisSBLToDashDot(NameAddressAuditTable.FieldByName('SwisSBLKey').Text));
    Application.ProcessMessages;

    If not Done
      then
        with NameAddressAuditTable do
          try
            Edit;
            FieldByName('CheckedOff').AsBoolean := True;
            FieldByName('DateCheckedOff').AsDateTime := Date;
            Post;
          except
          end;

  until Done;

  NameAddressAuditTable.Close;

end;  {ResetNameAddressChangeLabels}

{====================================================================================}
Procedure TYearEndRollOverForm.ClearARChangeFields(    ProcessingType : Integer;
                                                   var Quit : Boolean);

var
  Done, FirstTimeThrough : Boolean;

begin
  Done := False;
  FirstTimeThrough := True;

  OpenTableForProcessingType(DestTable, AssessmentTableName,
                             ProcessingType, Quit);

  DestTable.First;

  ProgressDialog.Reset;
  ProgressDialog.TotalNumRecords := GetRecordCount(DestTable);
  ProgressDialog.UserLabelCaption := 'Clearing Next Year A/R change fields.';

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else DestTable.Next;

    If DestTable.EOF
      then Done := True;

    If not Done
      then
        with DestTable do
          try
            Edit;
            FieldByName('IncreaseForEqual').AsFloat := 0;
            FieldByName('DecreaseForEqual').AsFloat := 0;
            FieldByName('PhysicalQtyIncrease').AsFloat := 0;
            FieldByName('PhysicalQtyDecrease').AsFloat := 0;
            Post;
          except
            SystemSupport(110, DestTable, 'Error clearing out A/R fields.',
                          UnitName, GlblErrorDlgBox);
          end;

  until Done;

  DestTable.Close;

end;  {ClearARChangeFields}

{====================================================================================}
Procedure TYearEndRollOverForm.TextFilerPrintHeader(Sender: TObject);

var
  TempStr, TempStr2, LineStr : String;
  I : Integer;

begin
  with Sender as TBaseReport do
    begin
      TempStr := 'COUNTY OF ' + Trim(GlblCountyName);
      TempStr2 := 'DATE: ' + DateToStr(Date) + '  TIME: ' + TimeToStr(Now);

      LineStr := UpcaseStr(TempStr) +
                 Center('YEAR END ROLLOVER REPORT', (130 - 2 * Length(TempStr)));
      LineStr := Take(130, LineStr);

        {Put the date and time on the end.}

      For I := Length(TempStr2) downto 1 do
        LineStr[130 - (Length(TempStr2) - I)] := TempStr2[I];
      Println(LineStr);

      TempStr := Trim(UpcaseStr(GetMunicipalityName));
      TempStr2 := 'PAGE: ' + IntToStr(CurrentPage);
      LineStr := Take(130, UpcaseStr(TempStr));

        {Put the page # on the end.}

      For I := Length(TempStr2) downto 1 do
        LineStr[130 - (Length(TempStr2) - I)] := TempStr2[I];
      Println(LineStr);

      Println('');

      ClearTabs;
      SetTab(0.5, pjLeft, 3.5, 0, BOXLINENone, 0);   {swis}

      case ReportSection of
        rsExemption : Println(#9 + 'Exemption Completeness Status');
        rsDetail : Println(#9 + 'Detail Change Listing');
        rsSummary : Println(#9 + 'Summary of Changes');
        rsChangeSDCodes : Println(#9 + 'Prorated special district codes changed:');
      end;  {case ReportSection of}

      Bold := False;

        {Print column headers.}

      If (ReportSection = rsExemption)
        then
          begin
            ClearTabs;
            SetTab(0.5, pjLeft, 2.6, 0, BoxLineNone, 0);   {SBL}
            SetTab(3.2, pjLeft, 0.7, 0, BoxLineNone, 0);   {ExCode}
            SetTab(4.0, pjLeft, 3.0, 0, BoxLineNone, 0);   {msg}

            Println(#9 + 'Parcel ID' +
                    #9 + 'EX Code' +
                    #9 + 'Error Message');

            Println('');

          end;  {If (ReportSection = rsExemption)}

      If (ReportSection = rsDetail)
        then
          begin
            ClearTabs;
            SetTab(0.2, pjCenter, 0.6, 0, BoxLineNone, 0);   {Swis}
            SetTab(0.9, pjCenter, 2.0, 0, BoxLineNone, 0);   {SBL}
            SetTab(3.0, pjCenter, 1.0, 0, BoxLineNone, 0);   {Name}
            SetTab(4.1, pjCenter, 0.2, 0, BoxLineNone, 0);   {HC}
            SetTab(4.4, pjCenter, 0.2, 0, BoxLineNone, 0);   {RS}
            SetTab(4.7, pjCenter, 0.5, 0, BoxLineNone, 0);   {SD Code}
            SetTab(5.3, pjCenter, 0.6, 0, BoxLineNone, 0);   {SD Calc code}
            SetTab(6.0, pjCenter, 1.0, 0, BoxLineNone, 0);   {SD amount}
            SetTab(7.1, pjCenter, 0.5, 0, BoxLineNone, 0);   {EX Code}
            SetTab(7.7, pjCenter, 1.0, 0, BoxLineNone, 0);   {EX amount}
            SetTab(8.8, pjCenter, 1.0, 0, BoxLineNone, 0);   {Relevy amt}
            SetTab(10.0, pjCenter, 1.2, 0, BoxLineNone, 0);   {Total AR change}
            SetTab(11.3, pjLeft, 2.0, 0, BoxLineNone, 0);   {Message}

            Println(#9 + 'SWIS' +
                    #9 + 'PARCEL ID' +
                    #9 + 'NAME' +
                    #9 + 'HC' +
                    #9 + 'RS' +
                    #9 + 'SD CD' +
                    #9 + 'CLC CD' +
                    #9 + 'SD AMOUNT' +
                    #9 + 'EX CD' +
                    #9 + 'EX AMOUNT' +
                    #9 + 'SCHL RLVY' +
                    #9 + 'AR CHANGE' +
                    #9 + 'MESSAGE');

            Println('');

            ClearTabs;
            SetTab(0.2, pjLeft, 0.6, 0, BoxLineNone, 0);   {Swis}
            SetTab(0.9, pjLeft, 2.0, 0, BoxLineNone, 0);   {SBL}
            SetTab(3.0, pjLeft, 1.0, 0, BoxLineNone, 0);   {Name}
            SetTab(4.1, pjRight, 0.2, 0, BoxLineNone, 0);   {HC}
            SetTab(4.4, pjRight, 0.2, 0, BoxLineNone, 0);   {RS}
            SetTab(4.7, pjLeft, 0.5, 0, BoxLineNone, 0);   {SD Code}
            SetTab(5.3, pjCenter, 0.6, 0, BoxLineNone, 0);   {SD calc Code}
            SetTab(6.0, pjRight, 1.0, 0, BoxLineNone, 0);   {SD amount}
            SetTab(7.1, pjLeft, 0.5, 0, BoxLineNone, 0);   {EX Code}
            SetTab(7.7, pjRight, 1.0, 0, BoxLineNone, 0);   {EX amount}            SetTab(8.8, pjRight, 1.0, 0, BoxLineNone, 0);   {Relevy amt}
            SetTab(10.0, pjRight, 1.2, 0, BoxLineNone, 0);   {Total AR change}
            SetTab(11.3, pjLeft, 2.0, 0, BoxLineNone, 0);   {Message}

          end;  {If (ReportSection = rsExemption)}

    end;  {with Sender as TBaseReport do}

end;  {ReportFilerPrintHeader}

{============================================================================}
Procedure TYearEndRollOverForm.TextFilerPrint(Sender: TObject);

var
  I : Integer;
  Quit : Boolean;
  NumParcels, ExErrorCount : LongInt;
  OldTaxRollYr, NewTaxRollYr, sSmallClaimsDefaultYear : String;
  TotalAssessedVal, LandAssessedVal : Comp;

begin
  Quit := False;
  ExErrorCount := 0;
  glblUseExactPrintKey := False;

    {First scan for exemption errors.}
    {CHG08011999-2: Don't scan for exemption errors.}

(*  ScanForExemptionErrors(Sender, EXErrorCount, Quit); *)

  If ((ExErrorCount = 0) and
      (not Quit))
    then
      begin
        with PASDataModule do
          For I := 0 to (ComponentCount - 1) do
            If ((Components[I] is TwwTable) and
                TwwTable(Components[I]).Active)
              then TwwTable(Components[I]).Close;

          {Now copy all of This Years File to History}

        If MoveDataToHistory
          then CopyThisYearToHist(Quit);

          {CHG09062001-2: If a parcel is inactive in ThisYear and NextYear, delete
                          the NextYear parcel so it doesn't stick around.}

        If not Quit
          then DeleteNextYearParcelsInBothYears(Quit);

          {FXX11262001-1: Delete NY AR change fields before rollover so not picked up
                          again the next year.}

        If ((not Quit) and
            GlblIsWestchesterCounty)
          then ClearARChangeFields(NextYear, Quit);

         {now copy NY files to this year INCLUDING INACTIVE PARCELS}

        If not Quit
          then CopyNextYearToThisYear(Quit);

        ProgressDialog.Reset;
        ProgressDialog.TotalNumRecords := SysRecTable.RecordCount;

         {Update system record to new tax years.}

        If not Quit
          then
            with SysRecTable do
              begin
                Edit;
                FieldByName('SysThisYear').AsString := Take(4, IntToStr(StrToInt(FieldByName('SysThisYear').Text) + 1));
                FieldByName('SysNextYear').AsString := Take(4, IntToStr(StrToInt(FieldByName('SysNextYear').Text) + 1));

                  {set up update ty and ny vars for ny data file updates and so }
                  {glbl vars are correct exiting this program}

               NewTaxRollYr := FieldByName('SysNextYear').Text;
               OldTaxRollYr := FieldByName('SysThisYear').Text;

               GlblThisYear := FieldByName('SysThisYear').Text;
               GlblNextYear := FieldByName('SysNextYear').Text;

                 {CHG10172011-1(2.28.1v): Allow for a small claims default year.}

               sSmallClaimsDefaultYear := FieldByName('SmallClaimsDefaultYear').AsString;

               If _Compare(sSmallClaimsDefaultYear, coNotBlank)
               then
               try
                 IncrementNumericString(sSmallClaimsDefaultYear, 1);
                 FieldByName('SmallClaimsDefaultYear').AsString := sSmallClaimsDefaultYear;
               except
               end;

               try
                 Post;
               except
                 SystemSupport(055, SysrecTable, 'Post Error on Sysrec Table.',
                               UnitName, GlblErrorDlgBox);
                 Quit := True;
               end;

             end;  {with SysRecTable do}

             {CLEAN UP NY FILE FOR NEW ACTIVITY :
               1. DELETE ALL RECORDS INACTIVE RECORDS
               2. SET TAX ROLL YEAR IN NY RECORDS TO NEW NY VALUE
               3. RESET PRINT FLAGS IN PARCEL EXEMPTION RECORDS}

          If not Quit
            then CleanUpNYParcels(OldTaxRollYr, NewTaxRollYr,
                                  NumParcels, TotalAssessedVal, LandAssessedVal, Quit);

            {CHG09062001-1: Make sure to reset the change flags for the owner change.}

          If ((not Quit) and
              ResetOwnerChangeLabels)
            then ResetNameAddressChangeLabels;

          PrintChanges(Sender, NumParcels, TotalAssessedVal, LandAssessedVal);

          UpdateValuesFromScreen(Quit);

          ProgressDialog.UserLabelCaption := 'Recalculating Next Year Exemptions.';
          If not Quit
            then RecalculateAllExemptions(Self, ProgressDialog,
                                          NextYear, GlblNextYear, False, Quit);

          ProgressDialog.Reset;

          If not Quit
            then CreateRollTotals(NextYear, GlblNextYear,
                                  ProgressDialog, Self, False, False);

            {CHG11262001-3: Recalculate ThisYear roll totals, too.}

          If not Quit
            then CreateRollTotals(ThisYear, GlblThisYear,
                                  ProgressDialog, Self, False, False);

            {FXX11301999-3: Run the assessor's verification report.}

            {CHG12011999-1: Update prorated special districts.}
            {FXX12171999-4: LB does not want to do this.}

          If ((not Quit) and
              AddOneYearToProrataSDsCheckBox.Checked)
            then UpdateProratedSpecialDistricts(Sender);

        end;  {If ((ExErrorCount = 0) and ...}      

end;  {ReportPrinterPrint}

{===================================================================}
Procedure TYearEndRollOverForm.PrintChanges(Sender : TObject;
                                            NumParcels : LongInt;
                                            TotalAssessedVal,
                                            LandAssessedVal : Comp);

{Print the change details by swis code and then a summary.}

var
  Done, FirstTimeThrough : Boolean;
  NumInactiveParcelsRemoved,
  NumSplitMergeNumbersErased,
  NumEXPrintFlagsCleared,
  NumExemptionsDeleted,
  NumSpecialDistrictsDeleted : LongInt;
  PhysicalQtyIncreaseErased,
  PhysicalQtyDecreaseErased,
  IncreaseForEqualErased,
  DecreaseForEqualErased,
  InactiveLandAssessedVal, RS9LandAssessedVal,
  InactiveTotalAssessedVal, RS9TotalAssessedVal,
  TotalARChange : Comp;
  RelevyAmount,
  SchoolRelevyErased,
  VillageRelevyErased : Extended;
  LastSBLKey : String;

begin
  ProgressDialog.Reset;
  ProgressDialog.TotalNumRecords := GetRecordCount(SortTable);
  ProgressDialog.UserLabelCaption := 'Printing change report';

  ReportSection := rsDetail;

(*  with Sender as TBaseReport do
    NewPage; *)

  NumInactiveParcelsRemoved := 0;
  NumSplitMergeNumbersErased := 0;
  NumEXPrintFlagsCleared := 0;
  NumExemptionsDeleted := 0;
  NumSpecialDistrictsDeleted := 0;
  PhysicalQtyIncreaseErased := 0;
  PhysicalQtyDecreaseErased := 0;
  IncreaseForEqualErased := 0;
  DecreaseForEqualErased := 0;
  SchoolRelevyErased := 0;
  VillageRelevyErased := 0;
  InactiveLandAssessedVal := 0;
  InactiveTotalAssessedVal := 0;
  RS9LandAssessedVal := 0;
  RS9TotalAssessedVal := 0;

  FirstTimeThrough := True;
  Done := False;

  SortTable.First;

  LastSBLKey := '';

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else SortTable.Next;

    If SortTable.EOF
      then Done := True;

    Application.ProcessMessages;
    ProgressDialog.Update(Self, ConvertSBLOnlyToDashDot(SortTable.FieldByName('SBLKey').Text));

    If not Done
      then
        with SortTable, Sender as TBaseReport do
          begin
            If (SortTable.FieldByName('SBLKey').Text <> LastSBLKey)
              then Print(#9 + FieldByName('SwisCode').Text +
                         #9 + ConvertSBLOnlyToDashDot(FieldByName('SBLKey').Text) +
                         #9 + FieldByName('Name').Text +
                         #9 + FieldByName('HomesteadCode').Text +
                         #9 + FieldByName('RollSection').Text)
              else Print(#9 + #9 + #9 + #9 + #9);

            TotalARChange := FieldByName('PhysicalQtyIncrease').AsFloat -
                             FieldByName('PhysicalQtyDecrease').AsFloat +
                             FieldByName('IncreaseForEqual').AsFloat +
                             FieldByName('DecreaseForEqual').AsFloat;

            RelevyAmount := 0;

            If (Roundoff(FieldByName('SchoolRelevy').AsFloat, 2) > 0)
              then RelevyAmount := FieldByName('SchoolRelevy').AsFloat;

            If (Roundoff(FieldByName('VillageRelevy').AsFloat, 2) > 0)
              then RelevyAmount := FieldByName('VillageRelevy').AsFloat;

            Println(#9 + FieldByName('SDCode').Text +
                    #9 + FieldByName('SDCalcCode').Text +
                    #9 + FormatFloat(DecimalDisplay_BlankZero, FieldByName('SDAmount').AsFloat) +
                    #9 + FieldByName('EXCode').Text +
                    #9 + FormatFloat(CurrencyEditDisplay, FieldByName('EXAmount').AsFloat) +
                    #9 + FormatFloat(DecimalDisplay_BlankZero, RelevyAmount) +
                    #9 + FormatFloat(CurrencyEditDisplay, TotalARChange) +
                    #9 + FieldByName('Message').Text);

            If (LinesLeft < 8)
              then NewPage;

              {Update the totals.}

            If (FieldByName('ActiveFlag').Text = InactiveParcelFlag)
              then
                begin
                  NumInactiveParcelsRemoved := NumInactiveParcelsRemoved + 1;
                  InactiveLandAssessedVal := InactiveLandAssessedVal + FieldByName('LandAssessedVal').AsFloat;
                  InactiveTotalAssessedVal := InactiveTotalAssessedVal + FieldByName('TotalAssessedVal').AsFloat;
                end;

            If (FieldByName('RollSection').Text = '9')
              then
                begin
                  RS9LandAssessedVal := RS9LandAssessedVal + FieldByName('LandAssessedVal').AsFloat;
                  RS9TotalAssessedVal := RS9TotalAssessedVal + FieldByName('TotalAssessedVal').AsFloat;
                end;

            If (Deblank(FieldByName('SplitMergeNo').Text) <> '')
              then NumSplitMergeNumbersErased := NumSplitMergeNumbersErased + 1;

              {If the exemption code is filled in, either the print flags were cleared or the
               exemption was deleted.}

            If ((Deblank(FieldByName('EXCode').Text) <> '') and
                (not IsBIEExemptionCode(FieldByName('EXCode').Text)))
              then
                If FieldByName('EXPrintFlagsCleared').AsBoolean
                  then NumEXPrintFlagsCleared := NumEXPrintFlagsCleared + 1
                  else NumExemptionsDeleted := NumExemptionsDeleted + 1;

            If (Deblank(FieldByName('SDCode').Text) <> '')
              then NumSpecialDistrictsDeleted := NumSpecialDistrictsDeleted + 1;

            PhysicalQtyIncreaseErased := PhysicalQtyIncreaseErased + FieldByName('PhysicalQtyIncrease').AsFloat;
            PhysicalQtyDecreaseErased := PhysicalQtyDecreaseErased + FieldByName('PhysicalQtyDecrease').AsFloat;
            IncreaseForEqualErased := IncreaseForEqualErased + FieldByName('IncreaseForEqual').AsFloat;
            DecreaseForEqualErased := DecreaseForEqualErased + FieldByName('DecreaseForEqual').AsFloat;
            SchoolRelevyErased := SchoolRelevyErased + FieldByName('SchoolRelevy').AsFloat;
            VillageRelevyErased := VillageRelevyErased + FieldByName('VillageRelevy').AsFloat;
            LastSBLKey := FieldByName('SBLKey').Text;

          end;  {with SortTable, Sender as TBaseReport do}

  until Done;

    {Now print the totals}

  with Sender as TBaseReport do
    begin
      ReportSection := rsSummary;

      NewPage;

      ClearTabs;
      SetTab(1.5, pjLeft, 3.0, 0, BOXLINENone, 0);   {Header}
      SetTab(4.6, pjRight, 1.5, 0, BOXLINENone, 0);   {Amount}

      Println(#9 + 'Total Physical Qty Increase Erased' +
              #9 + FormatFloat(CurrencyDisplayNoDollarSign, PhysicalQtyIncreaseErased));
      Println(#9 + 'Total Physical Qty Decrease Erased' +
              #9 + FormatFloat(CurrencyDisplayNoDollarSign, PhysicalQtyDecreaseErased));
      Println(#9 + 'Total Increase For Equalization Erased' +
              #9 + FormatFloat(CurrencyDisplayNoDollarSign, IncreaseForEqualErased));
      Println(#9 + 'Total Decrease For Equalization Erased' +
              #9 + FormatFloat(CurrencyDisplayNoDollarSign, DecreaseForEqualErased));
      Println('');
      Println(#9 + 'Total Village Relevy Erased' +
              #9 + FormatFloat(CurrencyDecimalDisplay, VillageRelevyErased));
      Println(#9 + 'Total School Relevy Erased' +
              #9 + FormatFloat(CurrencyDecimalDisplay, SchoolRelevyErased));
      Println('');
      Println(#9 + 'Split Merge Numbers Erased:' +
              #9 + IntToStr(NumSplitMergeNumbersErased));
      Println('');
      Println(#9 + 'Num Inactive Parcels Removed:' +
              #9 + IntToStr(NumInactiveParcelsRemoved));
      Println('');
      Println(#9 + 'Exemptions Deleted:' +
              #9 + IntToStr(NumExemptionsDeleted));
      Println('');
      Println(#9 + 'Exemption Flags Cleared:' +
              #9 + IntToStr(NumEXPrintFlagsCleared));
      Println('');
      Println(#9 + 'Special Districts Deleted:' +
              #9 + IntToStr(NumSpecialDistrictsDeleted));
      Println('');
      Println('');

        {CHG03242005-1(2.8.3.14): The roll total stuff is meaningless.}

(*      ClearTabs;
      SetTab(1.5, pjLeft, 5.0, 0, BOXLINENone, 0);   {Header}
      Println(#9 + '***************  ROLLOVER SUMMARY  *******************');
      Println('');
      ClearTabs;
      SetTab(1.5, pjLeft, 3.0, 0, BOXLINENone, 0);   {Header}
      SetTab(4.6, pjCenter, 1.2, 0, BOXLINENone, 0);   {Land}
      SetTab(5.9, pjCenter, 1.2, 0, BOXLINENone, 0);   {Total}
      SetTab(7.2, pjCenter, 1.2, 0, BOXLINENone, 0);   {Count}

      Println(#9 +
              #9 + 'LAND' +
              #9 + 'TOTAL' +
              #9 + 'NUM');
      Println(#9 + #9 + 'ASSESSED' +
              #9 + 'ASSESSED' +
              #9 + 'PARCELS');
      Println('');
      ClearTabs;
      SetTab(1.5, pjLeft, 3.0, 0, BOXLINENone, 0);   {Header}
      SetTab(4.6, pjRight, 1.2, 0, BOXLINENone, 0);   {Land}
      SetTab(5.9, pjRight, 1.2, 0, BOXLINENone, 0);   {Total}
      SetTab(7.2, pjRight, 1.2, 0, BOXLINENone, 0);   {Count}

      Println(#9 + 'ORIG NY PARCELS' +
              #9 + FormatFloat(NoDecimalDisplay_BlankZero, LandAssessedVal) +
              #9 + FormatFloat(NoDecimalDisplay_BlankZero, TotalAssessedVal) +
              #9 + IntToStr(NumParcels));
      Println('');
      Println(#9 + 'INACTIVE PARCELS DELETED' +
              #9 + FormatFloat(NoDecimalDisplay_BlankZero, InactiveLandAssessedVal) +
              #9 + FormatFloat(NoDecimalDisplay_BlankZero, InactiveTotalAssessedVal) +
              #9 + IntToStr(NumInactiveParcelsRemoved));
      Println('');
      Println(#9 + 'RS 9 PARCELS DELETED' +
              #9 + FormatFloat(NoDecimalDisplay_BlankZero, RS9LandAssessedVal) +
              #9 + FormatFloat(NoDecimalDisplay_BlankZero, RS9TotalAssessedVal) +
              #9 + IntToStr(NumRS9ParcelsRemoved));
      Println('');

      NewLandAssessedVal := LandAssessedVal -
                            InactiveLandAssessedVal -
                            RS9LandAssessedVal;

      NewTotalAssessedVal := TotalAssessedVal -
                             InactiveTotalAssessedVal -
                             RS9TotalAssessedVal;

      NewNumParcels := NumParcels - NumInactiveParcelsRemoved - NumRS9ParcelsRemoved;

      Println(#9 + 'NEW NY ROLL TOTALS' +
              #9 + FormatFloat(NoDecimalDisplay_BlankZero, NewLandAssessedVal) +
              #9 + FormatFloat(NoDecimalDisplay_BlankZero, NewTotalAssessedVal) +
              #9 + IntToStr(NewNumParcels)); *)

    end;  {with Sender as TBaseReport do}

end;  {PrintChanges}

{==================================================================}
Procedure TYearEndRollOverForm.ReportPrint(Sender: TObject);

var
  TempTextFile : TextFile;

begin
  AssignFile(TempTextFile, TextFiler.FileName);
  Reset(TempTextFile);

        {CHG12211998-1: Add ability to select print range.}

  PrintTextReport(Sender, TempTextFile, PrintDialog.FromPage,
                  PrintDialog.ToPage);

  CloseFile(TempTextFile);

end;  {ReportPrint}

{====================================================================}
Procedure TYearEndRollOverForm.CloseButtonClick(Sender: TObject);

begin
  Close;
end;

{===================================================================}
Procedure TYearEndRollOverForm.FormClose(    Sender: TObject;
                                         var Action: TCloseAction);

begin
  try
    CloseFile(TempTextFile);
  except
  end;
  
  CloseTablesForForm(Self);
    {Free up the child window and set the ClosingAForm Boolean to
     true so that we know to delete the tab.}

  Action := caFree;
  GlblClosingAForm := True;
  GlblClosingFormCaption := Caption;

end;  {FormClose}

end.
