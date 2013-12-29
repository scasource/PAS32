unit RPRemovedExemptions;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, DBCtrls, DBTables, DB, Buttons, Grids,
  Wwdbigrd, Wwdbgrid, ExtCtrls, Wwtable, Wwdatsrc, Menus, RPCanvas,
  RPrinter, RPBase, RPFiler, Types, RPDefine, (*Progress,*) TabNotBk, RPTXFilr,
  PASTypes, Zipcopy, ComCtrls, Mask;

type
  TRemovedExemptionReportForm = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    ScrollBox1: TScrollBox;
    CloseButton: TBitBtn;
    TitleLabel: TLabel;
    RemovedExemptionsTable: TTable;
    ExemptionCodeTable: TTable;
    ParcelTable: TTable;
    SwisCodeTable: TTable;
    PrintButton: TBitBtn;
    PrintDialog: TPrintDialog;
    SortRemovedExemptionsTable: TTable;
    Label2: TLabel;
    Label7: TLabel;
    Label1: TLabel;
    ExemptionLookupTable: TTable;
    ReportPrinter: TReportPrinter;
    ReportFiler: TReportFiler;
    Notebook: TTabbedNotebook;
    Label5: TLabel;
    ExemptionCodeListBox: TListBox;
    Label11: TLabel;
    OptionsGroupBox: TGroupBox;
    Label12: TLabel;
    PrintSection1CheckBox: TCheckBox;
    Label10: TLabel;
    PrintSection2CheckBox: TCheckBox;
    CreateParcelListCheckBox: TCheckBox;
    ZipCopyDlg: TZipCopyDlg;
    LoadButton: TBitBtn;
    SaveButton: TBitBtn;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    LoadFromParcelListCheckBox: TCheckBox;
    Label14: TLabel;
    SchoolCodeListBox: TListBox;
    Label9: TLabel;
    SwisCodeListBox: TListBox;
    Label15: TLabel;
    SchoolCodeTable: TTable;
    PrintRemovedSTARsCheckBox: TCheckBox;
    ExtractToExcelCheckBox: TCheckBox;
    PrintOnlyExemptionsMarkedProrataCheckBox: TCheckBox;
    EditYearRemovedFrom: TEdit;
    Label17: TLabel;
    RollSectionListBox: TListBox;
    PrintOrderRadioGroup: TRadioGroup;
    ActualDateGroupBox: TGroupBox;
    Label3: TLabel;
    Label8: TLabel;
    AllActualDatesCheckBox: TCheckBox;
    ToEndofActualDatesCheckBox: TCheckBox;
    EndActualDateEdit: TMaskEdit;
    StartActualDateEdit: TMaskEdit;
    EffectiveDateGroupBox: TGroupBox;
    Label4: TLabel;
    Label6: TLabel;
    AllEffectiveDatesCheckBox: TCheckBox;
    ToEndOfEffectiveDatesCheckBox: TCheckBox;
    EndEffectiveDateEdit: TMaskEdit;
    StartEffectiveDateEdit: TMaskEdit;
    PrintReasonRemovedCheckBox: TCheckBox;
    Label13: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure PrintButtonClick(Sender: TObject);
    procedure ReportPrint(Sender: TObject);
    procedure LoadButtonClick(Sender: TObject);
    procedure SaveButtonClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure AllActualDatesCheckBoxClick(Sender: TObject);
    procedure AllEffectiveDatesCheckBoxClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    UnitName : String;
    AssessmentYear : String;
    ReportCancelled : Boolean;
    FormAccessRights : Integer;  {Read only or read write, based on security level?}
                                {Values = raReadOnly, raReadWrite}

    ProcessingType : Integer;
    SelectedExemptionCodes,
    SelectedSchoolCodes,
    SelectedSwisCodes : TStringList;

    PrintOrder : Integer;

    LoadFromParcelList,
    CreateParcelList : Boolean;

    OrigSortFileName : String;
    SelectedRollSections : TStringList;
    PrintToExcel : Boolean;
    ExtractFile : TextFile;
    ExemptionsAlreadyExtracted : Boolean;

    PrintProrataOnly,
    PrintSTARExemptions,
    PrintReasonRemoved : Boolean;
    YearRemovedFrom : String;

    PrintAllActualDates,
    PrintToEndOfActualDates : Boolean;
    StartActualDate,
    EndActualDate : TDateTime;
    PrintAllEffectiveDates,
    PrintToEndOfEffectiveDates : Boolean;
    StartEffectiveDate,
    EndEffectiveDate : TDateTime;

    Procedure InitializeForm;  {Open the tables and setup.}

    Procedure FillSortFiles(var Quit : Boolean);
    {Fill all the sort files needed for the assessor's report.}

    Procedure PrintReportHeader(Sender : TObject;
                                ReportTime : TDateTime;
                                PageNum : Integer;
                                SubHeader : String;
                                SwisCode : String);
    {Print the overall report header.}


    Procedure PrintExemptionSection1(    Sender : TObject;
                                         ReportTime : TDateTime;
                                     var PageNum : Integer;
                                     var Quit : Boolean);
    {Print the exemptions by SBL. Break by swis.}

    Procedure PrintExemptionSection2(    Sender : TObject;
                                         ReportTime : TDateTime;
                                     var PageNum : Integer;
                                     var Quit : Boolean);
    {Print the exemptions by EXCode \SBL. Break by swis.}

    Procedure FillListBoxes(ProcessingType : Integer;
                            AssessmentYear : String);
  end;

implementation

uses GlblVars, WinUtils, Utilitys, PASUTILS, UTILEXSD,  GlblCnst,
     PRCLLIST, Prog, EnStarTy, RptDialg,
     Preview;  {Report preview form}

const
  LinesAtBottom = 2;

  poParcelID = 0;
  poName = 1;
  poLegalAddress = 2;

{$R *.DFM}

{========================================================}
Procedure TRemovedExemptionReportForm.FormActivate(Sender: TObject);

begin
  SetFormStateMaximized(Self);
end;

{========================================================}
Procedure TRemovedExemptionReportForm.FillListBoxes(ProcessingType : Integer;
                                                    AssessmentYear : String);

begin
  FillOneListBox(ExemptionCodeListBox, ExemptionCodeTable,
                 'EXCode', 'Description', 10,
                 True, True, ProcessingType, AssessmentYear);

  FillOneListBox(SwisCodeListBox, SwisCodeTable,
                 'SwisCode', 'MunicipalityName', 20,
                 True, True, ProcessingType, AssessmentYear);

  FillOneListBox(SchoolCodeListBox, SchoolCodeTable,
                 'SchoolCode', 'SchoolName', 20,
                 True, True, ProcessingType, AssessmentYear);

end;  {FillListBoxes}

{========================================================}
Procedure TRemovedExemptionReportForm.InitializeForm;

begin
  UnitName := 'RPRemovedExemptions';  {mmm}

  ProcessingType := GlblProcessingType;
  AssessmentYear := GetTaxRlYr;

  OpenTablesForForm(Self, GlblProcessingType);

  FillListBoxes(ProcessingType, AssessmentYear);

  OrigSortFileName := SortRemovedExemptionsTable.TableName;

  SelectedRollSections := TStringList.Create;
  SelectItemsInListBox(RollSectionListBox);

end;  {InitializeForm}

{===================================================================}
Procedure TRemovedExemptionReportForm.AllActualDatesCheckBoxClick(Sender: TObject);

begin
  If AllActualDatesCheckBox.Checked
    then
      begin
        ToEndofActualDatesCheckBox.Checked := False;
        ToEndofActualDatesCheckBox.Enabled := False;
        StartActualDateEdit.Text := '';
        StartActualDateEdit.Enabled := False;
        StartActualDateEdit.Color := clBtnFace;
        EndActualDateEdit.Text := '';
        EndActualDateEdit.Enabled := False;
        EndActualDateEdit.Color := clBtnFace;
      end
    else EnableSelectionsInGroupBoxOrPanel(ActualDateGroupBox);

end;  {AllActualDatesCheckBoxClick}

{===================================================================}
Procedure TRemovedExemptionReportForm.AllEffectiveDatesCheckBoxClick(Sender: TObject);

begin
  If AllEffectiveDatesCheckBox.Checked
    then
      begin
        ToEndofEffectiveDatesCheckBox.Checked := False;
        ToEndofEffectiveDatesCheckBox.Enabled := False;
        StartEffectiveDateEdit.Text := '';
        StartEffectiveDateEdit.Enabled := False;
        StartEffectiveDateEdit.Color := clBtnFace;
        EndEffectiveDateEdit.Text := '';
        EndEffectiveDateEdit.Enabled := False;
        EndEffectiveDateEdit.Color := clBtnFace;
      end
    else EnableSelectionsInGroupBoxOrPanel(EffectiveDateGroupBox);

end;  {AllEffectiveDatesCheckBoxClick}

{===================================================================}
Procedure AddOneSortRecord(    SwisSBLKey : String;
                               ParcelTable,
                               RemovedExemptionsTable,
                               SortRemovedExemptionsTable : TTable;
                               PrintReasonRemoved,
                               PrintToExcel,
                               ExemptionsAlreadyExtracted : Boolean;
                           var ExtractFile : TextFile;
                           var Quit : Boolean);

{Insert one record in the exemption sort table.}

var
  TempStr : String;

begin
  with SortRemovedExemptionsTable do
    try
      Insert;

      FieldByName('SwisCode').Text := Copy(SwisSBLKey, 1, 6);
      FieldByName('SBLKey').Text := Copy(SwisSBLKey, 7, 20);
      FieldByName('Name').Text := Take(20, ParcelTable.FieldByName('Name1').Text);
      FieldByName('Location').Text := GetLegalAddressFromTable(ParcelTable);
      FieldByName('RollSection').Text := ParcelTable.FieldByName('RollSection').Text;
      FieldByName('SchoolCode').Text := Take(6, ParcelTable.FieldByName('SchoolCode').Text);
      FieldByName('ExemptionCode').Text := RemovedExemptionsTable.FieldByName('ExemptionCode').Text;

      FieldByName('CountyAmount').AsInteger := RemovedExemptionsTable.FieldByName('CountyAmount').AsInteger;
      FieldByName('TownAmount').AsInteger := RemovedExemptionsTable.FieldByName('TownAmount').AsInteger;
      FieldByName('SchoolAmount').AsInteger := RemovedExemptionsTable.FieldByName('SchoolAmount').AsInteger;

      try
        FieldByName('VillageAmount').AsInteger := RemovedExemptionsTable.FieldByName('VillageAmount').AsInteger;
      except
      end;

      FieldByName('YearRemovedFrom').Text := RemovedExemptionsTable.FieldByName('YearRemovedFrom').Text;
      FieldByName('ActualDateRemoved').AsDateTime := RemovedExemptionsTable.FieldByName('ActualDateRemoved').AsDateTime;
      FieldByName('EffectiveDateRemoved').AsDateTime := RemovedExemptionsTable.FieldByName('EffectiveDateRemoved').AsDateTime;
      FieldByName('RemovedDueToSale').AsBoolean := RemovedExemptionsTable.FieldByName('RemovedDueToSale').AsBoolean;
      FieldByName('RemovedBy').Text := RemovedExemptionsTable.FieldByName('RemovedBy').Text;
      FieldByName('Reason').AsString := RemovedExemptionsTable.FieldByName('Reason').AsString;

      If (PrintToExcel and
          (not ExemptionsAlreadyExtracted))
        then
          begin
            If FieldByName('RemovedDueToSale').AsBoolean
              then TempStr := 'X'
              else TempStr := '';

            Write(ExtractFile,
                  FieldByName('SwisCode').Text,
                  FormatExtractField(ConvertSBLOnlyToDashDot(FieldByName('SBLKey').Text)),
                  FormatExtractField(FieldByName('ExemptionCode').Text),
                  FormatExtractField(FieldByName('Name').Text),
                  FormatExtractField(FieldByName('Location').Text),
                  FormatExtractField(FieldByName('RollSection').Text),
                  FormatExtractField(FieldByName('SchoolCode').Text),
                  FormatExtractField(FieldByName('YearRemovedFrom').Text),
                  FormatExtractField(FieldByName('ActualDateRemoved').Text),
                  FormatExtractField(FieldByName('EffectiveDateRemoved').Text),
                  FormatExtractField(FieldByName('RemovedBy').Text),
                  FormatExtractField(TempStr),
                  FormatExtractField(FieldByName('CountyAmount').Text),
                  FormatExtractField(FieldByName('TownAmount').Text),
                  FormatExtractField(FieldByName('SchoolAmount').Text));

            {$H+}
            If PrintReasonRemoved
              then Writeln(ExtractFile, FormatExtractField(ExtractPlainTextFromRichText(FieldByName('Reason').AsString, True)))
              else Writeln(ExtractFile);
            {$H-}

          end;  {If (PrintToExcel and ...}

      Post;

    except
      Quit := True;
      SystemSupport(005, SortRemovedExemptionsTable, 'Error inserting exemption sort record.',
                    'RPRemovedExemptions', GlblErrorDlgBox);
    end;

end;  {AddOneEXSortRecord}

{===================================================================}
Function RecMeetsCriteria(RemovedExemptionsTable,
                          ParcelTable : TTable;
                          SwisSBLKey : String;
                          PrintProrataOnly : Boolean;
                          PrintSTARExemptions : Boolean;
                          YearRemovedFrom : String;
                          PrintAllActualDates,
                          PrintToEndOfActualDates : Boolean;
                          StartActualDate,
                          EndActualDate : TDateTime;
                          PrintAllEffectiveDates,
                          PrintToEndOfEffectiveDates : Boolean;
                          StartEffectiveDate,
                          EndEffectiveDate : TDateTime;
                          SelectedSwisCodes,
                          SelectedSchoolCodes,
                          SelectedRollSections,
                          SelectedExemptionCodes : TStringList) : Boolean;

begin
  Result := True;

    {In the selected swis list?}

  If (SelectedSwisCodes.IndexOf(Copy(SwisSBLKey, 1, 6)) = -1)
    then Result := False;

    {In the selected school list?}

  If (SelectedSchoolCodes.IndexOf(ParcelTable.FieldByName('SchoolCode').Text) = -1)
    then Result := False;

    {Don't include rs 9.}

  If (ParcelTable.FieldByName('RollSection').Text = '9')
    then Result := False;

  If (ParcelTable.FieldByName('ActiveFlag').Text = InactiveParcelFlag)
    then Result := False;

  If (Result and
      (SelectedRollSections.IndexOf(ParcelTable.FieldByName('RollSection').Text) = -1))
    then Result := False;

  If (Result and
      PrintProrataOnly and
      (not RemovedExemptionsTable.FieldByName('RemovedDueToSale').AsBoolean))
    then Result := False;

  If (Result and
      (not PrintSTARExemptions) and
      ExemptionIsSTAR(RemovedExemptionsTable.FieldByName('ExemptionCode').Text))
    then Result := False;

  If (Result and
      (Deblank(YearRemovedFrom) <> '') and
      (YearRemovedFrom <> RemovedExemptionsTable.FieldByName('YearRemovedFrom').Text))
    then Result := False;

  If Result
    then Result := InDateRange(RemovedExemptionsTable.FieldByName('ActualDateRemoved').AsDateTime,
                               PrintAllActualDates,
                               PrintToEndOfActualDates,
                               StartActualDate,
                               EndActualDate);

  If Result
    then Result := InDateRange(RemovedExemptionsTable.FieldByName('EffectiveDateRemoved').AsDateTime,
                               PrintAllEffectiveDates,
                               PrintToEndOfEffectiveDates,
                               StartEffectiveDate,
                               EndEffectiveDate);

    {FXX04232009-7(4.20.1.1)[D484]: The Removed Exemptions report is not honoring the selected exemptions.}

  If (Result and
      _Compare(SelectedExemptionCodes.IndexOf(RemovedExemptionsTable.FieldByName('ExemptionCode').AsString), -1, coEqual))
    then Result := False;

end;  {RecMeetsCriteria}

{===================================================================}
Procedure TRemovedExemptionReportForm.FillSortFiles(var Quit : Boolean);

var
  FirstTimeThrough, Done,
  FirstTimeThroughRemovedExemptions, DoneRemovedExemptions : Boolean;
  Index : Integer;
  SwisSBLKey : String;

begin
  Quit := False;
  Index := 1;
  ProgressDialog.UserLabelCaption := 'Sorting Removed Exemption File.';

    {CHG03101999-1: Send info to a list or load from a list.}

  If CreateParcelList
    then ParcelListDialog.ClearParcelGrid(True);

    {Now go through the exemption file.}

  FirstTimeThrough := True;
  Done := False;

  If LoadFromParcelList
    then
      begin
        ParcelListDialog.GetParcel(ParcelTable, Index);
        ProgressDialog.Start(ParcelListDialog.NumItems, True, True);
      end
    else
      begin
        ParcelTable.First;
        ProgressDialog.Start(GetRecordCount(ParcelTable), True, True);
      end;

  repeat
    Application.ProcessMessages;

    If FirstTimeThrough
      then FirstTimeThrough := False
      else
        If LoadFromParcelList
          then
            begin
              Index := Index + 1;
              ParcelListDialog.GetParcel(ParcelTable, Index);
            end
          else ParcelTable.Next;

    If (ParcelTable.EOF or
        (LoadFromParcelList and
         (Index > ParcelListDialog.NumItems)))
      then Done := True;

    If LoadFromParcelList
      then ProgressDialog.Update(Self, ParcelListDialog.GetParcelID(Index))
      else ProgressDialog.Update(Self, ConvertSwisSBLToDashDot(ExtractSSKey(ParcelTable)));

    SwisSBLKey := ExtractSSKey(ParcelTable);

      {Now set a range for all the removed exemptions for this parcel and
       see which ones are in the correct range.}

    If not Done
      then
        begin
          SetRangeOld(RemovedExemptionsTable, ['SwisSBLKey'], [SwisSBLKey], [SwisSBLKey]);

          FirstTimeThroughRemovedExemptions := True;
          DoneRemovedExemptions := False;

          repeat
            If FirstTimeThroughRemovedExemptions
              then FirstTimeThroughRemovedExemptions := False
              else RemovedExemptionsTable.Next;

            If RemovedExemptionsTable.EOF
              then DoneRemovedExemptions := True;

            If ((not DoneRemovedExemptions) and
                RecMeetsCriteria(RemovedExemptionsTable, ParcelTable, SwisSBLKey,
                                 PrintProrataOnly, PrintSTARExemptions, YearRemovedFrom,
                                 PrintAllActualDates, PrintToEndOfActualDates,
                                 StartActualDate, EndActualDate,
                                 PrintAllEffectiveDates, PrintToEndOfEffectiveDates,
                                 StartEffectiveDate, EndEffectiveDate,
                                 SelectedSwisCodes, SelectedSchoolCodes,
                                 SelectedRollSections, SelectedExemptionCodes))
              then AddOneSortRecord(SwisSBLKey, ParcelTable,
                                    RemovedExemptionsTable,
                                    SortRemovedExemptionsTable,
                                    PrintReasonRemoved, PrintToExcel,
                                    ExemptionsAlreadyExtracted,
                                    ExtractFile, Quit);

          until DoneRemovedExemptions;

        end;  {If not Done}

    ReportCancelled := ProgressDialog.Cancelled;

  until (Done or ReportCancelled or Quit);

end;  {FillSortFiles}

{====================================================================}
Procedure TRemovedExemptionReportForm.SaveButtonClick(Sender: TObject);

{FXX04091999-8: Add ability to save and load search report options.}

begin
  SaveReportOptions(Self, OpenDialog, SaveDialog, 'RemovedExemptionReport.rex', 'Removed Exemption Report');

end;  {SaveButtonClick}

{====================================================================}
Procedure TRemovedExemptionReportForm.LoadButtonClick(Sender: TObject);

{FXX04091999-8: Add ability to save and load search report options.}

begin
  LoadReportOptions(Self, OpenDialog, 'RemovedExemptionReport.rex', 'Exemption Report');

end;  {LoadButtonClick}

{===================================================================}
Procedure TRemovedExemptionReportForm.PrintButtonClick(Sender: TObject);

var
  Quit, Proceed : Boolean;
  SpreadsheetFileName, SortFileName, NewFileName : String;
  I : Integer;

begin
  Quit := False;
  ReportCancelled := False;
  Proceed := True;

    {FXX03181999-1: Make sure they select a report type to print.}

  If ((not PrintSection1CheckBox.Checked) and
      (not PrintSection2CheckBox.Checked))
    then
      begin
        Proceed := False;
        MessageDlg('Please select what report type(s) to print.' + #13 +
                   'You can select to view parcels within a special district code,' + #13 +
                   'special districts within a parcel, or both.', mtError, [mbOK], 0)
      end;

  If Proceed
    then
      begin
        If ((StartActualDateEdit.Text = '  /  /    ') and
            (EndActualDateEdit.Text = '  /  /    ') and
            (not AllActualDatesCheckBox.Checked) and
            (not ToEndOfActualDatesCheckBox.Checked))
          then
            begin
              AllActualDatesCheckBox.Checked := True;
              PrintAllActualDates := True;
            end;

        If ((StartEffectiveDateEdit.Text = '  /  /    ') and
            (EndEffectiveDateEdit.Text = '  /  /    ') and
            (not AllEffectiveDatesCheckBox.Checked) and
            (not ToEndOfEffectiveDatesCheckBox.Checked))
          then
            begin
              AllEffectiveDatesCheckBox.Checked := True;
              PrintAllEffectiveDates := True;
            end;

          {CHG10121998-1: Add user options for default destination and show vet max msg.}

        SetPrintToScreenDefault(PrintDialog);

          {CHG03282002-6: Allow for roll section selection on sd, ex reports.}

        SelectedRollSections.Clear;
        with RollSectionListBox do
          For I := 0 to (Items.Count - 1) do
            If Selected[I]
              then SelectedRollSections.Add(Take(1, Items[I]));

        If PrintDialog.Execute
          then
            begin
              CreateParcelList := CreateParcelListCheckBox.Checked;
              LoadFromParcelList := LoadFromParcelListCheckBox.Checked;

                {FXX09301998-1: Disable print button after clicking to avoid clicking twice.}

              PrintButton.Enabled := False;
              Application.ProcessMessages;

                {CHG10131998-1: Set the printer settings based on what printer they selected
                                only - they no longer need to worry about paper or landscape
                                mode.}

              AssignPrinterSettings(PrintDialog, ReportPrinter, ReportFiler, [ptBoth], True, Quit);

              If (ReportPrinter.Orientation = poLandscape)
                then
                  If (MessageDlg('Do you want to print on letter size paper?',
                                 mtConfirmation, [mbYes, mbNo], 0) = idYes)
                    then
                      begin
                        ReportPrinter.SetPaperSize(dmPaper_Letter, 0, 0);
                        ReportFiler.SetPaperSize(dmPaper_Letter, 0, 0);
                        ReportPrinter.Orientation := poLandscape;
                        ReportFiler.Orientation := poLandscape;

                        If (ReportPrinter.SupportDuplex and
                            (MessageDlg('Do you want to print on both sides of the paper?',
                                        mtConfirmation, [mbYes, mbNo], 0) = idYes))
                          then
                            If (MessageDlg('Do you want to vertically duplex this report?',
                                            mtConfirmation, [mbYes, mbNo], 0) = idYes)
                              then ReportPrinter.Duplex := dupVertical
                              else ReportPrinter.Duplex := dupHorizontal;

                        ReportPrinter.ScaleX := 92;
                        ReportPrinter.ScaleY := 90;
                        ReportPrinter.SectionLeft := 1.5;
                        ReportFiler.ScaleX := 92;
                        ReportFiler.ScaleY := 90;
                        ReportFiler.SectionLeft := 1.5;

                      end;  {If (MessageDlg('Do you want to...}

              If not Quit
                then
                  begin
                    SelectedSwisCodes := TStringList.Create;
                    SelectedExemptionCodes := TStringList.Create;
                    SelectedSchoolCodes := TStringList.Create;
                    PrintReasonRemoved := PrintReasonRemovedCheckBox.Checked;
                    PrintProrataOnly := PrintOnlyExemptionsMarkedProrataCheckBox.Checked;
                    PrintSTARExemptions := PrintRemovedSTARsCheckBox.Checked;
                    YearRemovedFrom := EditYearRemovedFrom.Text;

                    PrintAllActualDates := AllActualDatesCheckBox.Checked;
                    PrintToEndOfActualDates := ToEndofActualDatesCheckBox.Checked;

                    try
                      If (StartActualDateEdit.Text <> '  /  /    ')
                        then StartActualDate := StrToDate(StartActualDateEdit.Text);
                    except
                      StartActualDate := 0;
                    end;

                    try
                      If (EndActualDateEdit.Text <> '  /  /    ')
                        then EndActualDate := StrToDate(EndActualDateEdit.Text);
                    except
                      EndActualDate := 0;
                    end;

                    PrintAllEffectiveDates := AllEffectiveDatesCheckBox.Checked;
                    PrintToEndOfEffectiveDates := ToEndofEffectiveDatesCheckBox.Checked;

                    try
                      If (StartEffectiveDateEdit.Text <> '  /  /    ')
                        then StartEffectiveDate := StrToDate(StartEffectiveDateEdit.Text);
                    except
                      StartEffectiveDate := 0;
                    end;

                    try
                      If (EndEffectiveDateEdit.Text <> '  /  /    ')
                        then EndEffectiveDate := StrToDate(EndEffectiveDateEdit.Text);
                    except
                      EndEffectiveDate := 0;
                    end;

                    For I := 0 to (SwisCodeListBox.Items.Count - 1) do
                      If SwisCodeListBox.Selected[I]
                        then SelectedSwisCodes.Add(Take(6, SwisCodeListBox.Items[I]));

                    For I := 0 to (SchoolCodeListBox.Items.Count - 1) do
                      If SchoolCodeListBox.Selected[I]
                        then SelectedSchoolCodes.Add(Take(6, SchoolCodeListBox.Items[I]));

                    For I := 0 to (ExemptionCodeListBox.Items.Count - 1) do
                      If ExemptionCodeListBox.Selected[I]
                         then SelectedExemptionCodes.Add(Take(5, ExemptionCodeListBox.Items[I]));

                      {CHG09222003-1(2.07j): Option to print to Excel.}

                    PrintToExcel := ExtractToExcelCheckBox.Checked;

                    If PrintToExcel
                      then
                        begin
                          ExemptionsAlreadyExtracted := False;
                          SpreadsheetFileName := GetPrintFileName(Self.Caption, True);
                          AssignFile(ExtractFile, SpreadsheetFileName);
                          Rewrite(ExtractFile);

                          Write(ExtractFile, 'Swis Cd,',
                                             'Parcel ID,',
                                             'EX Code,',
                                             'Owner,',
                                             'Legal Address,',
                                             'RS,',
                                             'School,',
                                             'Year Removed From,',
                                             'Date Removed,',
                                             'Effective Date Removed,',
                                             'Removed By,',
                                             'Prorata?,',
                                             'County EX Amt,',
                                             GetMunicipalityTypeName(GlblMunicipalityType) + ' EX Amt,',
                                             'School EX Amt');

                          If PrintReasonRemoved
                            then Writeln(ExtractFile, ',Reason')
                            else Writeln(ExtractFile);

                        end;  {If PrintToExcel}

                    PrintOrder := PrintOrderRadioGroup.ItemIndex;

                      {Copy the sort table and open the tables.}

                       {FXX12011997-1: Name the sort files with the date and time and
                                       extension of .SRT.}

                    CopyAndOpenSortFile(SortRemovedExemptionsTable, 'RemovedExemptionList',
                                        OrigSortFileName, SortFileName,
                                        True, True, Quit);

                    FillSortFiles(Quit);

                      {Now print the report.}

                    If not (Quit or ReportCancelled)
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
                                GlblPreviewPrint := True;

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
                                    Chdir(GlblReportDir);
                                    OldDeleteFile(NewFileName);
                                  finally
                                    {We don't care if it does not get deleted, so we won't put up an
                                     error message.}

                                    ChDir(GlblProgramDir);
                                  end;

                                end;  {try PreviewForm := ...}

                                ShowReportDialog('RemovedExemptionReport.rpt', ReportFiler.FileName, True);

                              end  {If PrintDialog.PrintToFile}
                            else ReportPrinter.Execute;

                        end;  {If not Quit}

                    ProgressDialog.Finish;

                      {FXX10111999-3: Tell people that printing is starting and
                                      done.}

                    DisplayPrintingFinishedMessage(PrintDialog.PrintToFile);

                      {Make sure to close and delete the sort file.}

                    SortRemovedExemptionsTable.Close;

                      {Now delete the file.}
                    try
                      ChDir(GlblDataDir);
                      OldDeleteFile(SortFileName);
                    finally
                      {We don't care if it does not get deleted, so we won't put up an
                       error message.}

                      ChDir(GlblProgramDir);
                    end;

                    SelectedSwisCodes.Free;
                    SelectedExemptionCodes.Free;
                    SelectedSchoolCodes.Free;

                    If CreateParcelList
                      then ParcelListDialog.Show;

                    If PrintToExcel
                      then
                        begin
                          CloseFile(ExtractFile);
                          SendTextFileToExcelSpreadsheet(SpreadsheetFileName, True,
                                                         False, '');

                        end;  {If PrintToExcel}

                  end;  {If not Quit}

            end;  {If PrintDialog.Execute}

        PrintButton.Enabled := True;
        ResetPrinter(ReportPrinter);

      end;  {If ((not PrintSection1CheckBox.Checked) and ...}

end;  {StartButtonClick}

{===================================================================}
{===============  THE FOLLOWING ARE PRINTING PROCEDURES ============}
{===================================================================}
Procedure TRemovedExemptionReportForm.PrintReportHeader(Sender : TObject;
                                                        ReportTime : TDateTime;
                                                        PageNum : Integer;
                                                        SubHeader : String;
                                                        SwisCode : String);

{Print the overall report header.}

begin
  with Sender as TBaseReport do
    begin
      Bold := True;
      ClearTabs;
      SetTab(0.3, pjLeft, 8.0, 0, BoxLineNone, 0);
      SetTab(4.5, pjCenter, 3.0, 0, BoxLineNone, 0);
      SetTab(10.2, pjRight, 0.7, 0, BoxLineNone, 0);

        {Print the date and page number.}
      SectionTop := 0.5;
      SectionLeft := 0.5;
      SectionRight := PageWidth - 0.5;

      SetFont('Times New Roman',8);
      Println(#9 + 'Date: ' + DateToStr(Date) +
                   '  Time: ' + TimeToStr(ReportTime) +
              #9 +
              #9 + 'Page: ' + IntToStr(CurrentPage));

      SetFont('Times New Roman',12);
      Println(#9 +
              #9 + 'Removed Exemption Report');
      Println(#9 +
              #9 + Subheader);
      Println('');

      SetFont('Times New Roman',10);
      ClearTabs;

    end;  {with Sender as TBaseReport do}

end;  {PrintReportHeader}

{===================================================================}
Procedure PrintExemptionSection1Header(Sender : TObject);

{Print the header for the exemption listing by SBL.}

begin
  with Sender as TBaseReport do
    begin
      Bold := True;
      ClearTabs;
      SetTab(0.3, pjCenter, 1.4, 5, BoxLineAll, 0);  {Parcel ID}
      SetTab(1.7, pjCenter, 1.3, 5, BoxLineAll, 0);  {Name}
      SetTab(3.0, pjCenter, 1.3, 5, BoxLineAll, 0);  {Location}
      SetTab(4.3, pjCenter, 0.2, 5, BoxLineAll, 0);  {R\S}
      SetTab(4.5, pjCenter, 0.6, 5, BoxLineAll, 0);  {School code}
      SetTab(5.1, pjCenter, 0.6, 5, BoxLineAll, 0);  {EX Code}
      SetTab(5.7, pjCenter, 0.4, 5, BoxLineAll, 0);  {Year removed from}
      SetTab(6.1, pjCenter, 0.9, 5, BoxLineAll, 0);  {Actual date removed}
      SetTab(7.0, pjCenter, 0.9, 5, BoxLineAll, 0);  {Effective date removed}
      SetTab(7.9, pjCenter, 1.0, 5, BoxLineAll, 0);  {County amt}
      SetTab(8.9, pjCenter, 1.0, 5, BoxLineAll, 0);  {Town amt}
      SetTab(9.9, pjCenter, 1.0, 5, BoxLineAll, 0);  {School amt}

      Print(#9 + #9 + #9 + #9 +
            #9 + 'School' +
            #9 + 'Exempt' +
            #9 + 'Year' +
            #9 + 'Actual' +
            #9 + 'Effective');

      If (rtdCounty in GlblRollTotalsToShow)
        then Print(#9 + 'County')
        else Print(#9);

      If (rtdMunicipal in GlblRollTotalsToShow)
        then Print(#9 + GetMunicipalityTypeName(GlblMunicipalityType))
        else Print(#9);

      If (rtdSchool in GlblRollTotalsToShow)
        then Println(#9 + 'School')
        else Println(#9);

      Print(#9 + 'Parcel ID' +
            #9 + 'Owner' +
            #9 + 'Location' +
            #9 + 'RS' +
            #9 + 'Code' +
            #9 + 'Code' +
            #9 + 'Remv' +
            #9 + 'Date Removed' +
            #9 + 'Date Removed');

      If (rtdCounty in GlblRollTotalsToShow)
        then Print(#9 + 'EX Amount')
        else Print(#9);

      If (rtdMunicipal in GlblRollTotalsToShow)
        then Print(#9 + 'EX Amount')
        else Print(#9);

      If (rtdSchool in GlblRollTotalsToShow)
        then Println(#9 + 'EX Amount')
        else Println(#9);

      ClearTabs;
      SetTab(0.3, pjLeft, 1.4, 5, BoxLineAll, 0);  {Parcel ID}
      SetTab(1.7, pjLeft, 1.3, 5, BoxLineAll, 0);  {Name}
      SetTab(3.0, pjLeft, 1.3, 5, BoxLineAll, 0);  {Location}
      SetTab(4.3, pjLeft, 0.2, 5, BoxLineAll, 0);  {R\S}
      SetTab(4.5, pjLeft, 0.6, 5, BoxLineAll, 0);  {School code}
      SetTab(5.1, pjLeft, 0.6, 5, BoxLineAll, 0);  {EX Code}
      SetTab(5.7, pjLeft, 0.4, 5, BoxLineAll, 0);  {Year removed from}
      SetTab(6.1, pjLeft,  0.9, 5, BoxLineAll, 0);  {Actual date removed}
      SetTab(7.0, pjLeft, 0.9, 5, BoxLineAll, 0);  {Effective date removed}
      SetTab(7.9, pjRight, 1.0, 5, BoxLineAll, 0);  {County amt}
      SetTab(8.9, pjRight, 1.0, 5, BoxLineAll, 0);  {Town amt}
      SetTab(9.9, pjRight, 1.0, 5, BoxLineAll, 0);  {School amt}

      Bold := False;

    end;  {with Sender as TBaseReport do}

end;  {PrintExemptionSection1Header}

{===================================================================}
Procedure PrintEXSection1Totals(Sender : TObject;
                                SwisCode : String;
                                TotalType : Char;  {'S' = Swis, 'M' = munic}
                                CountyAmount,
                                TownAmount,
                                SchoolAmount : LongInt);

begin
  with Sender as TBaseReport do
    begin
      Println('');
      Bold := True;

      case TotalType of
        'M' : Print(#9 + 'Grand Total ' + Copy(SwisCode, 1, 4));
        'S' : Print(#9 + 'Total Swis ' + SwisCode);
      end;

        {CHG01192004-1(2.08): Let each municipality decide what roll totals to display.}

      Print(#9 + #9 + #9 + #9 + #9 + #9 + #9 + #9);

      If (rtdCounty in GlblRollTotalsToShow)
        then Print(#9 + FormatFloat(NoDecimalDisplay_BlankZero, CountyAmount))
        else Print(#9);

      If (rtdMunicipal in GlblRollTotalsToShow)
        then Print(#9 + FormatFloat(NoDecimalDisplay_BlankZero, TownAmount))
        else Print(#9);

      If (rtdSchool in GlblRollTotalsToShow)
        then Println(#9 + FormatFloat(NoDecimalDisplay_BlankZero, SchoolAmount))
        else Println(#9);

      Bold := False;

    end;  {with Sender as TBaseReport do}

end;  {PrintEXSection1Totals}

{===================================================================}
Procedure TRemovedExemptionReportForm.PrintExemptionSection1(    Sender : TObject;
                                                                 ReportTime : TDateTime;
                                                             var PageNum : Integer;
                                                             var Quit : Boolean);

{Print the exemptions by SBL. Break by swis.}

var
  FirstEntryOnPage,
  Done, FirstTimeThrough : Boolean;
  PreviousSBLKey : String;
  PreviousSwisCode : String;
  SwisCountyAmount, SwisTownAmount,
  SwisSchoolAmount, TotalCountyAmount, TotalTownAmount,
  TotalSchoolAmount : LongInt;

begin
  Done := False;
  FirstTimeThrough := True;
  FirstEntryOnPage := True;
  ProgressDialog.Reset;
  ProgressDialog.TotalNumRecords := GetRecordCount(SortRemovedExemptionsTable);
  ProgressDialog.UserLabelCaption := 'Exemptions By S\B\L.';

  SwisCountyAmount := 0;
  SwisTownAmount := 0;
  SwisSchoolAmount := 0;
  TotalCountyAmount := 0;
  TotalTownAmount := 0;
  TotalSchoolAmount := 0;

    {FXX02031999-3: Add print by name and addr.}

  case PrintOrder of
    poParcelID : SortRemovedExemptionsTable.IndexName := 'BYSWIS_SBL_EXCODE';
    poName : SortRemovedExemptionsTable.IndexName := 'BYSWIS_NAME_EXCODE';
    poLegalAddress : SortRemovedExemptionsTable.IndexName := 'BYSWIS_LOCATION_EXCODE';
  end;

  with Sender as TBaseReport do
    begin
      try
        SortRemovedExemptionsTable.First;
      except
        Quit := True;
        SystemSupport(050, SortRemovedExemptionsTable, 'Error getting exemption sort record.',
                      UnitName, GlblErrorDlgBox);
      end;

      PreviousSwisCode := SortRemovedExemptionsTable.FieldByName('SwisCode').Text;
      PreviousSBLKey := '';

      PageNum := PageNum + 1;
      PrintReportHeader(Sender, ReportTime, PageNum,
                        'Exemption Codes Within Parcel',
                        PreviousSwisCode);
      PrintExemptionSection1Header(Sender);

      repeat
        If FirstTimeThrough
          then FirstTimeThrough := False
          else
            try
              SortRemovedExemptionsTable.Next;
            except
              Quit := True;
              SystemSupport(050, SortRemovedExemptionsTable, 'Error getting exemption sort record.',
                            UnitName, GlblErrorDlgBox);
            end;

          {FXX02021998-4: Need an app.procmsgs to allow concurrent processing.}

        Application.ProcessMessages;

        If SortRemovedExemptionsTable.EOF
          then Done := True;

        If (Done or
            (Take(6, PreviousSwisCode) <> Take(6, SortRemovedExemptionsTable.FieldByName('SwisCode').Text)))
          then
            begin
              PrintEXSection1Totals(Sender, PreviousSwisCode, 'S',
                                    SwisCountyAmount,
                                    SwisTownAmount,
                                    SwisSchoolAmount);

              TotalCountyAmount := TotalCountyAmount + SwisCountyAmount;
              TotalTownAmount := TotalTownAmount + SwisTownAmount;
              TotalSchoolAmount := TotalSchoolAmount + SwisSchoolAmount;

              SwisCountyAmount := 0;
              SwisTownAmount := 0;
              SwisSchoolAmount := 0;

            end;  {If (Take(6, PreviousSwisCode) ...}

        If not Done or Quit
          then
            begin
              ProgressDialog.Update(Self,
                                    'S\B\L: ' + ConvertSBLOnlyToDashDot(SortRemovedExemptionsTable.FieldByName('SBLKey').Text));

                {If they switched swis codes or they are at
                 the end of this page, start a new page.}

              If ((Take(6, PreviousSwisCode) <> Take(6, SortRemovedExemptionsTable.FieldByName('SwisCode').Text)) or
                  (LinesLeft < LinesAtBottom))
                then
                  begin
                    NewPage;
                    FirstEntryOnPage := True;
                    PageNum := PageNum + 1;
                    PrintReportHeader(Sender, ReportTime, PageNum,
                                      'Exemption Codes Within Parcel',
                                      SortRemovedExemptionsTable.FieldByName('SwisCode').Text);
                    PrintExemptionSection1Header(Sender);

                  end;  {If (LinesLeft < 5)}

                {Only print the SBL, name ... assessment if this is the
                 first exemption for this parcel.}

              with SortRemovedExemptionsTable do
                begin
                  If ((Take(20, PreviousSBLKey) <> Take(20, FieldByName('SBLKey').Text)) or
                      FirstEntryOnPage)
                    then Print(#9 + ConvertSBLOnlyToDashDot(FieldByName('SBLKey').Text) +
                               #9 + Take(13, FieldByName('Name').Text) +
                               #9 + Take(13, FieldByName('Location').Text) +
                               #9 + FieldByName('RollSection').Text +
                               #9 + FieldByName('SchoolCode').Text)
                    else Print(#9 + #9 + #9 + #9 + #9);  {Skip these fields.}

                    {Now print the exemption amounts.}

                  Print(#9 + FieldByName('ExemptionCode').Text +
                        #9 + FieldByName('YearRemovedFrom').Text +
                        #9 + FieldByName('ActualDateRemoved').Text +
                        #9 + FieldByName('EffectiveDateRemoved').Text);

                    {CHG01192004-1(2.08): Let each municipality decide what roll totals to display.}


                  If (rtdCounty in GlblRollTotalsToShow)
                    then Print(#9 + FormatFloat(NoDecimalDisplay_BlankZero,
                                                TCurrencyField(FieldByName('CountyAmount')).Value))
                    else Print(#9);

                  If (rtdMunicipal in GlblRollTotalsToShow)
                    then Print(#9 + FormatFloat(NoDecimalDisplay_BlankZero,
                                                TCurrencyField(FieldByName('TownAmount')).Value))
                    else Print(#9);

                  If (rtdSchool in GlblRollTotalsToShow)
                    then Println(#9 + FormatFloat(NoDecimalDisplay_BlankZero,
                                                  TCurrencyField(FieldByName('SchoolAmount')).Value))
                    else Println(#9);

                  SwisCountyAmount := SwisCountyAmount + FieldByName('CountyAmount').AsInteger;
                  SwisTownAmount := SwisTownAmount + FieldByName('TownAmount').AsInteger;
                  SwisSchoolAmount := SwisSchoolAmount + FieldByName('SchoolAmount').AsInteger;
                  FirstEntryOnPage := False;

                end;  {with SortRemovedExemptionsTable do}

            end;  {If not Done or Quit}

        PreviousSwisCode := SortRemovedExemptionsTable.FieldByName('SwisCode').Text;
        PreviousSBLKey := SortRemovedExemptionsTable.FieldByName('SBLKey').Text;
        ReportCancelled := ProgressDialog.Cancelled;

      until (Done or Quit or ReportCancelled);

    end;  {with Sender as TBaseReport do}

  PrintEXSection1Totals(Sender, PreviousSwisCode, 'M',
                        TotalCountyAmount,
                        TotalTownAmount,
                        TotalSchoolAmount);

  ExemptionsAlreadyExtracted := True;

end;  {PrintExemptionSection1}

{===================================================================}
Procedure PrintExemptionSection2Header(Sender : TObject);

{Print the header for the exemption listing by SBL.}

begin
  with Sender as TBaseReport do
    begin
      ClearTabs;
      Bold := True;

      SetTab(0.3, pjCenter, 0.6, 5, BoxLineAll, 0);  {EX Code}
      SetTab(0.9, pjCenter, 1.0, 5, BoxLineAll, 0);  {Parcel ID}
      SetTab(1.9, pjCenter, 1.3, 5, BoxLineAll, 0);  {Name}
      SetTab(3.2, pjCenter, 1.3, 5, BoxLineAll, 0);  {Location}
      SetTab(4.5, pjCenter, 0.2, 5, BoxLineAll, 0);  {R\S}
      SetTab(4.7, pjCenter, 0.6, 5, BoxLineAll, 0);  {School code}
      SetTab(5.3, pjCenter, 0.4, 5, BoxLineAll, 0);  {Year removed from}
      SetTab(5.7, pjCenter, 0.8, 5, BoxLineAll, 0);  {Actual date removed}
      SetTab(6.5, pjCenter, 0.8, 5, BoxLineAll, 0);  {Effective date removed}
      SetTab(7.3, pjCenter, 0.5, 5, BoxLineAll, 0);  {Prorate}
      SetTab(7.8, pjCenter, 1.0, 5, BoxLineAll, 0);  {County amt}
      SetTab(8.8, pjCenter, 1.0, 5, BoxLineAll, 0);  {Town amt}
      SetTab(9.8, pjCenter, 1.0, 5, BoxLineAll, 0);  {School amt}

      Print(#9 + 'Exempt' +
            #9 + #9 + #9 + #9 +
            #9 + 'School' +
            #9 + 'Year' +
            #9 + 'Actual' +
            #9 + 'Effective' +
            #9 + 'Pro-');

      If (rtdCounty in GlblRollTotalsToShow)
        then Print(#9 + 'County')
        else Print(#9);

      If (rtdMunicipal in GlblRollTotalsToShow)
        then Print(#9 + GetMunicipalityTypeName(GlblMunicipalityType))
        else Print(#9);

      If (rtdSchool in GlblRollTotalsToShow)
        then Println(#9 + 'School')
        else
          If (rtdVillageReceivingPartialRoll in GlblRollTotalsToShow)
            then Println(#9 + 'Village')
            else Println(#9);

      Print(#9 + 'Code' +
            #9 + 'Parcel ID' +
            #9 + 'Owner' +
            #9 + 'Location' +
            #9 + 'RS' +
            #9 + 'Code' +
            #9 + 'Remv' +
            #9 + 'Date Remv' +
            #9 + 'Date Remv' +
            #9 + 'Rate');

      If (rtdCounty in GlblRollTotalsToShow)
        then Print(#9 + 'Ex Amount')
        else Print(#9);

      If (rtdMunicipal in GlblRollTotalsToShow)
        then Print(#9 + 'Ex Amount')
        else Print(#9);

      If (rtdSchool in GlblRollTotalsToShow)
        then Println(#9 + 'Ex Amount')
        else Println(#9);

      ClearTabs;
      SetTab(0.3, pjLeft, 0.6, 5, BoxLineAll, 0);  {EX Code}
      SetTab(0.9, pjLeft, 1.0, 5, BoxLineAll, 0);  {Parcel ID}
      SetTab(1.9, pjLeft, 1.3, 5, BoxLineAll, 0);  {Name}
      SetTab(3.2, pjLeft, 1.3, 5, BoxLineAll, 0);  {Location}
      SetTab(4.5, pjLeft, 0.2, 5, BoxLineAll, 0);  {R\S}
      SetTab(4.7, pjLeft, 0.6, 5, BoxLineAll, 0);  {School code}
      SetTab(5.3, pjLeft, 0.4, 5, BoxLineAll, 0);  {Year removed from}
      SetTab(5.7, pjLeft, 0.9, 5, BoxLineAll, 0);  {Actual date removed}
      SetTab(6.6, pjLeft, 0.9, 5, BoxLineAll, 0);  {Effective date removed}
      SetTab(7.3, pjCenter, 0.5, 5, BoxLineAll, 0);  {Prorate}
      SetTab(7.8, pjRight, 1.0, 5, BoxLineAll, 0);  {County amt}
      SetTab(8.8, pjRight, 1.0, 5, BoxLineAll, 0);  {Town amt}
      SetTab(9.8, pjRight, 1.0, 5, BoxLineAll, 0);  {School amt}

      Bold := False;

    end;  {with Sender as TBaseReport do}

end;  {PrintExemptionSection2Header}

{===================================================================}
Procedure PrintEXTotals(Sender : TObject;  {Report printer}
                        TotalType : Char;  {'X' = exemption code, 'S' = swis code, 'T' = overall total}
                        TotalCode : String;  {The exemption or swis code this total is for.}
                        TotalNumParcels : LongInt;
                        TotalCountyAmount,
                        TotalTownAmount,
                        TotalSchoolAmount,
                        TotalVillageAmount : LongInt);

var
  TotalHeader : String;

begin
  case TotalType of
    'X' : TotalHeader := 'Total EX ' + Trim(TotalCode) + ':';
    'S' : TotalHeader := 'Total Swis ' + Trim(TotalCode) + ':';
    'T' : TotalHeader := 'Overall Total: ';
  end;

  with Sender as TBaseReport do
    begin
      Bold := True;
      Print(#9 + #9 + TotalHeader + #9 +
            #9 + '# Exemptions:  ' + IntToStr(TotalNumParcels) +
            #9 + #9 + #9 + #9 + #9 + #9);

      If (rtdCounty in GlblRollTotalsToShow)
        then Print(#9 + FormatFloat(NoDecimalDisplay_BlankZero,
                                    TotalCountyAmount))
        else Print(#9);

      If (rtdMunicipal in GlblRollTotalsToShow)
        then Print(#9 + FormatFloat(NoDecimalDisplay_BlankZero,
                                    TotalTownAmount))
        else Print(#9);

      If (rtdSchool in GlblRollTotalsToShow)
        then Println(#9 + FormatFloat(NoDecimalDisplay_BlankZero,
                                      TotalSchoolAmount))
        else
          If (rtdVillageReceivingPartialRoll in GlblRollTotalsToShow)
            then Println(#9 + FormatFloat(NoDecimalDisplay_BlankZero,
                                          TotalVillageAmount))
            else Println(#9);

      Println('');
      Bold := False;

    end;  {with Sender as TBaseReport do}

end;  {PrintEXTotals}

{===================================================================}
Procedure TRemovedExemptionReportForm.PrintExemptionSection2(    Sender : TObject;
                                                                 ReportTime : TDateTime;
                                                             var PageNum : Integer;
                                                             var Quit : Boolean);

{Print the exemptions by EXCode \SBL. Break by swis.}

var
  Done, FirstTimeThrough, FirstLineOnPage : Boolean;
  PreviousSwisCode : String;
  PreviousEXCode : String;
  NumParcelsForEXCode,
  NumParcelsForSwisCode,
  TotalNumParcels : LongInt;

  CountyAmountForEXCode,
  TownAmountForEXCode,
  SchoolAmountForEXCode,
  VillageAmountForEXCode,
  CountyAmountForSwisCode,
  TownAmountForSwisCode,
  SchoolAmountForSwisCode,
  VillageAmountForSwisCode,
  TotalCountyAmount,
  TotalTownAmount,
  TotalSchoolAmount,
  TotalVillageAmount : LongInt;

begin
  Done := False;
  FirstTimeThrough := True;
  FirstLineOnPage := True;

  NumParcelsForEXCode := 0;
  NumParcelsForSwisCode := 0;
  TotalNumParcels := 0;

  CountyAmountForEXCode := 0;
  TownAmountForEXCode := 0;
  SchoolAmountForEXCode := 0;
  VillageAmountForEXCode := 0;
  CountyAmountForSwisCode := 0;
  TownAmountForSwisCode := 0;
  SchoolAmountForSwisCode := 0;
  VillageAmountForSwisCode := 0;
  TotalCountyAmount := 0;
  TotalTownAmount := 0;
  TotalSchoolAmount := 0;
  TotalVillageAmount := 0;

  ProgressDialog.Reset;
  ProgressDialog.TotalNumRecords := GetRecordCount(SortRemovedExemptionsTable);
  ProgressDialog.UserLabelCaption := 'Exemptions By Exemption Code.';

    {FXX02031999-3: Add print by name and addr.}

  case PrintOrder of
    poParcelID : SortRemovedExemptionsTable.IndexName := 'BYSWIS_EXCODE_SBL';
    poName : SortRemovedExemptionsTable.IndexName := 'BYSWIS_EXCODE_NAME';
    poLegalAddress : SortRemovedExemptionsTable.IndexName := 'BYSWIS_EXCODE_LOCATION';
  end;

  with Sender as TBaseReport do
    begin
      SortRemovedExemptionsTable.First;

      PreviousSwisCode := SortRemovedExemptionsTable.FieldByName('SwisCode').Text;
      PreviousEXCode := '';

      PageNum := PageNum + 1;
      PrintReportHeader(Sender, ReportTime, PageNum,
                        'Parcels Within Exemption Code',
                        PreviousSwisCode);
      PrintExemptionSection2Header(Sender);

      repeat
        If FirstTimeThrough
          then FirstTimeThrough := False
          else SortRemovedExemptionsTable.Next;

          {FXX02021998-4: Need an app.procmsgs to allow concurrent processing.}

        Application.ProcessMessages;

        If SortRemovedExemptionsTable.EOF
          then Done := True;

          {Check to see if we need to print totals or start a new page.}

        If not Quit
          then
            begin
                {If we are on a different exemption code, then print out the totals
                 for the last exemption code.}

              If (((Take(5, PreviousEXCode) <> Take(5, SortRemovedExemptionsTable.FieldByName('ExemptionCode').Text)) and
                   (Deblank(PreviousEXCode) <> '')) or
                  Done)
                then
                  begin
                    PrintEXTotals(Sender, 'X', PreviousEXCode,
                                  NumParcelsForEXCode,
                                  CountyAmountForEXCode,
                                  TownAmountForEXCode,
                                  SchoolAmountForEXCode,
                                  VillageAmountForEXCode);

                    NumParcelsForEXCode := 0;
                    CountyAmountForEXCode := 0;
                    TownAmountForEXCode := 0;
                    SchoolAmountForEXCode := 0;
                    VillageAmountForEXCode := 0;

                  end;  {If (Take(5, PreviousEXCode) <> Take(5, SortRemovedExemptionsTable.FieldByName('ExemptionCode').Text))}

                {If this is a different swis code, print out the totals for
                 the swis.}

              If ((Take(6, PreviousSwisCode) <> Take(6, SortRemovedExemptionsTable.FieldByName('SwisCode').Text)) or
                  Done)
                then
                  begin
                      {Print the totals for this swis code.}

                    PrintEXTotals(Sender, 'S', PreviousSwisCode,
                                  NumParcelsForSwisCode,
                                  CountyAmountForSwisCode,
                                  TownAmountForSwisCode,
                                  SchoolAmountForSwisCode,
                                  VillageAmountForSwisCode);

                    NumParcelsForSwisCode := 0;
                    CountyAmountForSwisCode := 0;
                    TownAmountForSwisCode := 0;
                    SchoolAmountForSwisCode := 0;
                    VillageAmountForSwisCode := 0;

                  end;  {If (Take(6, PreviousSwisCode) <> Take(6, SortRemovedExemptionsTable.FieldByName('SwisCode').Text))}

                {If they switched swis codes or they are at
                 the end of this page, start a new page.}

              If ((Take(6, PreviousSwisCode) <> Take(6, SortRemovedExemptionsTable.FieldByName('SwisCode').Text)) or
                  (LinesLeft < LinesAtBottom))
                then
                  begin
                    NewPage;
                    PageNum := PageNum + 1;
                    PrintReportHeader(Sender, ReportTime, PageNum,
                                      'Parcels Within Exemption Code',
                                      SortRemovedExemptionsTable.FieldByName('SwisCode').Text);
                    PrintExemptionSection2Header(Sender);

                    FirstLineOnPage := True;

                  end;  {If (LinesLeft < 5)}

            end;  {If not Quit}

        If not Done or Quit
          then
            begin
              ProgressDialog.Update(Self,
                                    'EX Code: ' +
                                    SortRemovedExemptionsTable.FieldByName('ExemptionCode').Text);

                {Only print the Exemption code if this is the
                 first parcel for this exemption.}

              with SortRemovedExemptionsTable do
                begin
                  Bold := True;
                  If ((Take(5, PreviousEXCode) <> Take(5, FieldByName('ExemptionCode').Text)) or
                      FirstLineOnPage)
                    then Print(#9 + FieldByName('ExemptionCode').Text)
                    else Print(#9);  {Skip the ex code.}
                  Bold := False;

                    {Now print the exemption amounts.}

                  Print(#9 + ConvertSBLOnlyToDashDot(FieldByName('SBLKey').Text) +
                        #9 + Take(13, FieldByName('Name').Text) +
                        #9 + Take(13, FieldByName('Location').Text) +
                        #9 + FieldByName('RollSection').Text +
                        #9 + FieldByName('SchoolCode').Text +
                        #9 + FieldByName('YearRemovedFrom').Text +
                        #9 + FieldByName('ActualDateRemoved').Text +
                        #9 + FieldByName('EffectiveDateRemoved').Text +
                        #9 + BoolToChar_Blank_X(FieldByName('RemovedDueToSale').AsBoolean));

                  If (rtdCounty in GlblRollTotalsToShow)
                    then Print(#9 + FormatFloat(CurrencyDisplayNoDollarSign,
                                                FieldByName('CountyAmount').AsInteger))
                    else Print(#9);

                  If (rtdMunicipal in GlblRollTotalsToShow)
                    then Print(#9 + FormatFloat(NoDecimalDisplay_BlankZero,
                                                FieldByName('TownAmount').AsInteger))
                    else Print(#9);

                  If (rtdSchool in GlblRollTotalsToShow)
                    then Println(#9 + FormatFloat(NoDecimalDisplay_BlankZero,
                                                  FieldByName('SchoolAmount').AsInteger))
                    else
                      If (rtdVillageReceivingPartialRoll in GlblRollTotalsToShow)
                        then Println(#9 + FormatFloat(NoDecimalDisplay_BlankZero,
                                                      FieldByName('VillageAmount').AsInteger))
                        else Println('');

                  FirstLineOnPage := False;

                  NumParcelsForEXCode := NumParcelsForEXCode + 1;

                  CountyAmountForEXCode := CountyAmountForEXCode +
                                           FieldByName('CountyAmount').AsInteger;
                  TownAmountForEXCode := TownAmountForEXCode +
                                         FieldByName('TownAmount').AsInteger;
                  SchoolAmountForEXCode := SchoolAmountForEXCode +
                                           FieldByName('SchoolAmount').AsInteger;
                  VillageAmountForEXCode := VillageAmountForEXCode +
                                            FieldByName('VillageAmount').AsInteger;

                    {FXX05101999-2: Need to update swis totals here so
                                    if one ex code, they get updated.
                                    Same thing for totals.}

                  NumParcelsForSwisCode := NumParcelsForSwisCode + 1;

                  CountyAmountForSwisCode := CountyAmountForSwisCode +
                                             FieldByName('CountyAmount').AsInteger;
                  TownAmountForSwisCode := TownAmountForSwisCode +
                                           FieldByName('TownAmount').AsInteger;
                  SchoolAmountForSwisCode := SchoolAmountForSwisCode +
                                             FieldByName('SchoolAmount').AsInteger;
                  VillageAmountForSwisCode := VillageAmountForSwisCode +
                                              FieldByName('VillageAmount').AsInteger;

                  TotalNumParcels := TotalNumParcels + 1;

                  TotalCountyAmount := TotalCountyAmount +
                                       FieldByName('CountyAmount').AsInteger;
                  TotalTownAmount := TotalTownAmount +
                                     FieldByName('TownAmount').AsInteger;
                  TotalSchoolAmount := TotalSchoolAmount +
                                       FieldByName('SchoolAmount').AsInteger;
                  TotalVillageAmount := TotalVillageAmount +
                                        FieldByName('VillageAmount').AsInteger;

                end;  {with SortRemovedExemptionsTable do}

            end;  {If not Done or Quit}

        PreviousSwisCode := SortRemovedExemptionsTable.FieldByName('SwisCode').Text;
        PreviousEXCode := SortRemovedExemptionsTable.FieldByName('ExemptionCode').Text;

        ReportCancelled := ProgressDialog.Cancelled;

      until (Done or Quit or ReportCancelled);

       {Print out the overall exemption totals.}

      If not (Quit or ReportCancelled)
        then PrintEXTotals(Sender, 'T', PreviousSwisCode,
                           TotalNumParcels,
                           TotalCountyAmount,
                           TotalTownAmount,
                           TotalSchoolAmount,
                           TotalVillageAmount);

    end;  {with Sender as TBaseReport do}

end;  {PrintExemptionSection2}

{===================================================================}
Procedure TRemovedExemptionReportForm.ReportPrint(Sender: TObject);

{To print the report, we will print each of the segments seperately.
 We will not use the normal paging event driven methods.
 We will control all paging.}

var
  Quit : Boolean;
  ReportTime : TDateTime;
  PageNum : Integer;

begin
  Quit := False;
  PageNum := 1;
  ReportTime := Now;

    {FXX10091998-5: Allow them to select which section(s) to print.}

  If ((not (Quit or ReportCancelled)) and
      PrintSection1CheckBox.Checked)
    then PrintExemptionSection1(Sender, ReportTime, PageNum, Quit);

    {FXX06231998-2: Allow them to not print section 2.}

  If ((not (Quit or ReportCancelled)) and
      PrintSection2CheckBox.Checked)
    then
      begin
          {FXX12021998-5: If printing both sections, need to form feed.}

        If PrintSection1CheckBox.Checked
          then TBaseReport(Sender).NewPage;

        PrintExemptionSection2(Sender, ReportTime, PageNum, Quit);

      end;  {If ((not (Quit or ReportCancelled)) and ...}

end;  {TextFilerPrint}

{===================================================================}
Procedure TRemovedExemptionReportForm.FormClose(    Sender: TObject;
                                  var Action: TCloseAction);

begin
  SelectedRollSections.Free;
  CloseTablesForForm(Self);

    {Free up the child window and set the ClosingAForm Boolean to
     true so that we know to delete the tab.}

  Action := caFree;
  GlblClosingAForm := True;
  GlblClosingFormCaption := Caption;

end;  {FormClose}



end.