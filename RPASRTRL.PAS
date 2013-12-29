unit Rpasrtrl;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, DBCtrls, DBTables, DB, Buttons, Grids, Math,
  Wwdbigrd, Wwdbgrid, ExtCtrls, Wwtable, Wwdatsrc, Menus, Mask, (*Progress,*)
  RPCanvas, RPrinter, RPDefine, RPBase, RPFiler, Types, TabNotBk, ComCtrls;

type
  ExemptionChangeHeaderRecord = record
    TransactionNumber : LongInt;
    SwisSBLKey : String;
    Date : TDateTime;
    Time : TTime;
    User : String;
    AssessmentYear : String;
  end;

  ExemptionChangeHeaderPointer  = ^ExemptionChangeHeaderRecord;


  ExemptionChangeDetailRecord = record
    TransactionNumber : LongInt;
    DetailNumber : LongInt;
    ExemptionCode : String;
    CountyAmount : LongInt;
    MunicipalAmount : LongInt;
    SchoolAmount : LongInt;
    VillageAmount : LongInt;
    Percent : Double;
    OwnerPercent : Double;
    InitialDate : TDateTime;
    TerminationDate : TDateTime;
    BeforeTransaction : Boolean;
  end;

  ExemptionChangeDetailPointer = ^ExemptionChangeDetailRecord;

type
  TAssessorsTrialBalanceReportForm = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    ScrollBox1: TScrollBox;
    TitleLabel: TLabel;
    AuditParcelChangeTable: TTable;
    AuditEXChangeTable: TTable;
    AuditSDChangeTable: TTable;
    PrintDialog: TPrintDialog;
    ReportFiler: TReportFiler;
    ReportPrinter: TReportPrinter;
    AuditAVChangeTable: TTable;
    SwisCodeTable: TTable;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    SDCodeTable: TTable;
    ExemptionCodeTable: TTable;
    ParcelTable: TTable;
    SchoolCodeTable: TTable;
    Panel3: TPanel;
    LoadButton: TBitBtn;
    SaveButton: TBitBtn;
    PrintButton: TBitBtn;
    CloseButton: TBitBtn;
    PageControl1: TPageControl;
    tbsOptions: TTabSheet;
    TaxYearRadioGroup: TRadioGroup;
    IndexRadioGroup: TRadioGroup;
    SectionsToPrintGroupBox: TGroupBox;
    ExemptionChangeCheckBox: TCheckBox;
    AssessedValueChangesCheckBox: TCheckBox;
    ParcelChangesCheckBox: TCheckBox;
    SpecialDistrictChangesCheckBox: TCheckBox;
    SBLGroupBox: TGroupBox;
    Label11: TLabel;
    Label12: TLabel;
    StartSBLEdit: TEdit;
    EndSBLEdit: TEdit;
    AllSBLCheckBox: TCheckBox;
    ToEndOfSBLCheckBox: TCheckBox;
    DateGroupBox: TGroupBox;
    Label7: TLabel;
    Label8: TLabel;
    AllDatesCheckBox: TCheckBox;
    ToEndofDatesCheckBox: TCheckBox;
    EndDateEdit: TMaskEdit;
    StartDateEdit: TMaskEdit;
    UserIDGroupBox: TGroupBox;
    Label9: TLabel;
    Label10: TLabel;
    StartUserEdit: TEdit;
    AllUsersCheckBox: TCheckBox;
    ToEndOfUsersCheckBox: TCheckBox;
    EndUserEdit: TEdit;
    tbsMoreOptions: TTabSheet;
    tbsSwisSchoolCodes: TTabSheet;
    tbsSDCodes: TTabSheet;
    tbsEXCodes: TTabSheet;
    GroupBox1: TGroupBox;
    Label2: TLabel;
    CreateParcelListCheckBox: TCheckBox;
    SuppressTaxableValueInAVSectionCheckBox: TCheckBox;
    cbx_ExtractToExcel: TCheckBox;
    SpecialDistrictListBox: TListBox;
    ExemptionListBox: TListBox;
    Panel4: TPanel;
    SwisCodeListBox: TListBox;
    Panel5: TPanel;
    SchoolCodeListBox: TListBox;
    Panel6: TPanel;
    Label1: TLabel;
    Panel7: TPanel;
    Label21: TLabel;
    Panel8: TPanel;
    Label20: TLabel;
    Panel9: TPanel;
    Label19: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure AllDatesCheckBoxClick(Sender: TObject);
    procedure AllSBLCheckBoxClick(Sender: TObject);
    procedure AllUsersCheckBoxClick(Sender: TObject);
    procedure PrintButtonClick(Sender: TObject);
    procedure ReportFilerBeforePrint(Sender: TObject);
    procedure ReportFilerPrintHeader(Sender: TObject);
    procedure ReportFilerPrint(Sender: TObject);
    procedure CloseButtonClick(Sender: TObject);
    procedure LoadButtonClick(Sender: TObject);
    procedure SaveButtonClick(Sender: TObject);
    procedure TaxYearRadioGroupClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    UnitName : String;
    FormAccessRights : Integer;  {Read only or read write, based on security level?}
                                {Values = raReadOnly, raReadWrite}

    PrintAllExemptions,
    PrintAllSpecialDistricts,
    PrintAllUsers,
    PrintToEndOfUsers,
    CreateParcelList : Boolean;
    StartUser,
    EndUser : String;
    StartingSwisSBL,
    EndingSwisSBL : String;
    ReportCancelled : Boolean;
    SelectedExemptionCodes,
    SelectedSpecialDistricts : TStringList;
    AssessmentYear : String;

    AssessmentYearChoosen : Integer;
    ReportSection : String;  {What section of the report are we printing?
                            (E)xemption (A)dd,
                            (E)xemption (D)elete,
                            (S)pecial district (A)dd,
                            (S)pecial district (D)elete.}

    SelectedSchoolCodes,
    SelectedSwisCodes : TStringList;
    SuppressTaxableValueInAVSection, ExtractToExcel : Boolean;
    ExtractFile : TextFile;

    Procedure FillListBoxes(ProcessingType : Integer;
                            AssessmentYear : String);

    Procedure InitializeForm;  {Open the tables and setup.}

    Function ValidSelectionInformation : Boolean;
    {Have they filled in enough information in the selection boxes to print?}

    Function RecordInEX_SDRange(RecordType : Char) : Boolean;

    Function RecordInRange(TempDate : TDateTime;
                           SwisSBLKey : String;
                           SchoolCode : String;
                           Users : String;
                           AssessmentYear : String) : Boolean;
    {Does this record fall within the set of parameters that they selected?}
    {CHG01211998-3: Allow tracking of EX, SD deletions.}

    Procedure PrintOneExemptionTransaction(    Sender : TObject;
                                               ExemptionChangeHeaderList : TList;
                                               ExemptionChangeDetailList : TList;
                                               Index : LongInt;
                                           var NumPrinted : LongInt;
                                           var TotalCountyAmountBefore : LongInt;
                                           var TotalSchoolAmountBefore : LongInt;
                                           var TotalMunicipalAmountBefore : LongInt;
                                           var TotalCountyAmountAfter : LongInt;
                                           var TotalSchoolAmountAfter : LongInt;
                                           var TotalMunicipalAmountAfter : LongInt);

    Procedure PrintExemptionSection(    Sender : TObject;
                                        AuditEXChangeTable : TTable;
                                    var GrandTotalCountyTaxableChange,
                                        GrandTotalTownTaxableChange,
                                        GrandTotalSchoolTaxableChange : LongInt);
    {Print either the exemption adds or deletes.}
    {CHG03161998-1: Track exemption, SD adds, av changes, parcel add/del.}

    Procedure PrintSpecialDistrictSection(Sender : TObject;
                                          AuditSDChangeTable : TTable;
                                          SectionType : String;
                                          RecordType : Char);
    {Print either the SD adds or deletes.}

    Procedure PrintAVChangeSection(    Sender : TObject;
                                       AuditAVChangeTable : TTable;
                                   var GrandTotalAVChange,
                                       GrandTotalCountyTaxableChange,
                                       GrandTotalTownTaxableChange,
                                       GrandTotalSchoolTaxableChange : LongInt);
    {Print either the assessed value changes.}

    Procedure PrintParcelChangeSection(    Sender : TObject;
                                           AuditParcelChangeTable : TTable;
                                           RecordType : Char;
                                       var GrandTotalAVChange,
                                           GrandTotalCountyTaxableChange,
                                           GrandTotalTownTaxableChange,
                                           GrandTotalSchoolTaxableChange : LongInt);
    {Print either the parcel adds or deletes.}
    {CHG03161998-1: Track exemption, SD adds, av changes, parcel add/del.}

  end;

implementation

uses GlblVars, WinUtils, Utilitys, GlblCnst, PASUtils, PASTypes,
     Prog, PRCLLIST, Preview, RptDialg, DataAccessUnit;

{$R *.DFM}

const
  ayThisYear = 0;
  ayNextYear = 1;
  ayAllYears = 2;

{========================================================}
Procedure TAssessorsTrialBalanceReportForm.FillListBoxes(ProcessingType : Integer;
                                                         AssessmentYear : String);

var
  Quit : Boolean;

begin
  OpenTableForProcessingType(ExemptionCodeTable, ExemptionCodesTableName,
                             ProcessingType, Quit);

  OpenTableForProcessingType(SDCodeTable, SDistCodeTableName,
                             ProcessingType, Quit);

  FillOneListBox(ExemptionListBox, ExemptionCodeTable, 'EXCode',
                 'Description', 10, True, False, ProcessingType, AssessmentYear);

  FillOneListBox(SpecialDistrictListBox, SDCodeTable, 'SDistCode',
                 'Description', 10, True, False, ProcessingType, AssessmentYear);

  SelectItemsInListBox(ExemptionListBox);
  SelectItemsInListBox(SpecialDistrictListBox);

end;  {FillListBoxes}

{========================================================}
Procedure TAssessorsTrialBalanceReportForm.FormActivate(Sender: TObject);

begin
  WindowState := wsMaximized;
end;

{========================================================}
Procedure TAssessorsTrialBalanceReportForm.InitializeForm;

begin
  UnitName := 'RPASRTRL';  {mmm}

  OpenTablesForForm(Self, GlblProcessingType);

    {FXX01201998-10: Only let user Supervisor choose other users to
                     see the changes for.}

    {CHG06092010-3(2.26.1)[I7208]: Allow for supervisor equivalents.}

  If ((not UserIsSupervisor(GlblUserName)) and
      (not GlblAllowAuditAccessToAll))
    then
      begin
        UserIDGroupBox.Visible := False;

          {If not the supervisor, set the start and end ranges the same.}

        PrintAllUsers := False;
        PrintToEndOfUsers := False;
        StartUser := Take(10, GlblUserName);
        EndUser := Take(10, GlblUserName);

      end;  {If (GlblUserName <> 'SUPERVISOR')}

  AssessmentYear := GetTaxRollYearForProcessingType(GlblProcessingType);

  FillListBoxes(GlblProcessingType, AssessmentYear);

    {CHG12291999-1: Add swis \ school selection to audit reports.}

  FillOneListBox(SwisCodeListBox, SwisCodeTable, 'SwisCode',
                 'MunicipalityName', 25, True, True, GlblProcessingType, AssessmentYear);

  FillOneListBox(SchoolCodeListBox, SchoolCodeTable, 'SchoolCode',
                 'SchoolName', 25, True, True, GlblProcessingType, AssessmentYear);

end;  {InitializeForm}

{===================================================================}
Procedure TAssessorsTrialBalanceReportForm.TaxYearRadioGroupClick(Sender: TObject);

var
  ProcessingType : Integer;

begin
  ProcessingType := GlblProcessingType;
  case TaxYearRadioGroup.ItemIndex of
    0 : begin
          ProcessingType := ThisYear;
          AssessmentYear := GlblThisYear;
        end;

    1, 2 : begin
             ProcessingType := NextYear;
             AssessmentYear := GlblNextYear;
           end;

  end;  {case TaxYearRadioGroup.ItemIndex of}

  FillListBoxes(ProcessingType, AssessmentYear);

end;  {TaxYearRadioGroupClick}

{===================================================================}
Procedure TAssessorsTrialBalanceReportForm.FormKeyPress(    Sender: TObject;
                                     var Key: Char);

begin
  If (Key = #13)
    then
      begin
        Key := #0;
        Perform(WM_NEXTDLGCTL, 0, 0);
      end;

end;  {FormKeyPress}

{=================================================================}
Procedure TAssessorsTrialBalanceReportForm.AllDatesCheckBoxClick(Sender: TObject);

begin
  If AllDatesCheckBox.Checked
    then
      begin
        ToEndofDatesCheckBox.Checked := False;
        ToEndofDatesCheckBox.Enabled := False;
        StartDateEdit.Text := '';
        StartDateEdit.Enabled := False;
        StartDateEdit.Color := clBtnFace;
        EndDateEdit.Text := '';
        EndDateEdit.Enabled := False;
        EndDateEdit.Color := clBtnFace;
      end
    else EnableSelectionsInGroupBoxOrPanel(DateGroupBox);

end;  {AllDatesCheckBoxClick}

{=================================================================}
Procedure TAssessorsTrialBalanceReportForm.AllSBLCheckBoxClick(Sender: TObject);

begin
  If AllSBLCheckBox.Checked
    then
      begin
        ToEndofSBLCheckBox.Checked := False;
        ToEndofSBLCheckBox.Enabled := False;
        StartSBLEdit.Text := '';
        StartSBLEdit.Enabled := False;
        StartSBLEdit.Color := clBtnFace;
        EndSBLEdit.Text := '';
        EndSBLEdit.Enabled := False;
        EndSBLEdit.Color := clBtnFace;
      end
    else EnableSelectionsInGroupBoxOrPanel(SBLGroupBox);

end;  {AllSBLCheckBoxClick}

{=================================================================}
Procedure TAssessorsTrialBalanceReportForm.AllUsersCheckBoxClick(Sender: TObject);

begin
  If AllUsersCheckBox.Checked
    then
      begin
        ToEndofUsersCheckBox.Checked := False;
        ToEndofUsersCheckBox.Enabled := False;
        StartUserEdit.Text := '';
        StartUserEdit.Enabled := False;
        StartUserEdit.Color := clBtnFace;
        EndUserEdit.Text := '';
        EndUserEdit.Enabled := False;
        EndUserEdit.Color := clBtnFace;
      end
    else EnableSelectionsInGroupBoxOrPanel(UserIdGroupBox);

end;  {AllUsersCheckBoxClick}

{================================================================}
Function TAssessorsTrialBalanceReportForm.RecordInEX_SDRange(RecordType : Char) : Boolean;

begin
  Result := False;

  case RecordType of
    'E' : If PrintAllExemptions
            then Result := True
            else Result := (SelectedExemptionCodes.IndexOf(AuditEXChangeTable.FieldByName('ExemptionCode').Text) > -1);

    'S' : If PrintAllSpecialDistricts
            then Result := True
            else Result := (SelectedSpecialDistricts.IndexOf(AuditSDChangeTable.FieldByName('SDistCode').Text) > -1);

  end;  {case RecordType of}

end;  {RecordInEX_SDRange}

{================================================================}
Function TAssessorsTrialBalanceReportForm.RecordInRange(TempDate : TDateTime;
                                                        SwisSBLKey : String;
                                                        SchoolCode : String;
                                                        Users : String;
                                                        AssessmentYear : String) : Boolean;

{Does this record fall within the set of parameters that they selected?}
{CHG01211998-3: Allow tracking of EX, SD deletions.}

var
  SwisCode, FieldName : String;

begin
  Result := True;
  SwisCode := Take(6, SwisSBLKey);

    {Now see if they are in the date range (if any) specified.}

  If not AllDatesCheckBox.Checked
    then
      begin
      FieldName := 'Date';

        If (TempDate < StrToDate(StartDateEdit.Text))
          then Result := False;

        If ((not ToEndOfDatesCheckBox.Checked) and
            (TempDate > StrToDate(EndDateEdit.Text)))
          then Result := False;

      end;  {else of If AllDatesCheckBox.Checked}

    {Now see if they are in the notes code range (if any) specified.}

  If not AllSBLCheckBox.Checked
    then
      begin
        If (Take(26, SwisSBLKey) < Take(26, StartingSWISSBL))
          then Result := False;

        If ((not ToEndOfSBLCheckBox.Checked) and
            (Take(26, SwisSBLKey) > Take(26, EndingSWISSBL)))
          then Result := False;

      end;  {else of If AllNotesCodesCheckBox.Checked}

    {Now see if they are in the user range (if any) specified.}

  If not PrintAllUsers
    then
      begin
        If (Take(10, Users) < StartUser)
          then Result := False;

        If ((not ToEndOfUsersCheckBox.Checked) and
            (Take(10, Users) > EndUser))
          then Result := False;

      end;  {else of If AllUsersCheckBox.Checked}

    {FXX03021998-1: Choose based on year that they selected.}

  If (Result and
      (AssessmentYearChoosen <> ayAllYears))
    then
      begin
        Result := False;

        If ((AssessmentYearChoosen = ayThisYear) and
            (AssessmentYear = GlblThisYear))
          then Result := True;

        If ((AssessmentYearChoosen = ayNextYear) and
            (AssessmentYear = GlblNextYear))
          then Result := True;

      end;  {If (Result and ...}

    {CHG12291999-1: Allow swis \ school selections in audits.}

  If (Result and
      ((SelectedSwisCodes.IndexOf(SwisCode) = -1) or
       (SelectedSchoolCodes.IndexOf(SchoolCode) = -1)))
    then Result := False;

end;  {RecordInRange}

{=====================================================================}
Function TAssessorsTrialBalanceReportForm.ValidSelectionInformation : Boolean;

{Have they filled in enough information in the selection boxes to print?}

begin
  Result := True;

    {They have to select an assessment year.}

  If (TaxYearRadioGroup.ItemIndex = -1)
    then
      begin
        MessageDlg('Please select an assessment year. ', mtError, [mbOK], 0);
        Result := False;
      end;

    {Make sure that they select an index.}

  If ((Result and
      (TaxYearRadioGroup.ItemIndex in [1, 2]) and
      (IndexRadioGroup.ItemIndex = -1)))
    then
      begin
        MessageDlg('Please select a sort order (SBL, Date, or User)',
                   mtError, [mbOK], 0);
        Result := False;
      end;

    {Now make sure that the selections that they chose make sense. Note that if they do not
     select anything in a box, all is assumed, so we will check it.}

  If Result
    then
      If ((StartDateEdit.Text <> '  /  /    ') or
           (EndDateEdit.Text <> '  /  /    ') or
           AllDatesCheckBox.Checked or
           ToEndofDatesCheckBox.Checked)
        then
          begin
              {Make sure if they clicked to end of range that they put in a start range.}

            If ((ToEndofDatesCheckBox.Checked or
                 (EndDateEdit.Text <> '  /  /    ')) and
                (StartDateEdit.Text = '  /  /    '))
              then
                begin
                  MessageDlg('Please select a starting date or chose all dates.', mtError, [mbOK], 0);
                  Result := False;
                end;

              {Make sure that if they entered a start range, there is an end range.}

            If ((StartDateEdit.Text <> '  /  /    ') and
                ((EndDateEdit.Text = '  /  /    ') and
                 (not ToEndofDatesCheckBox.Checked)))
              then
                begin
                  MessageDlg('Please select an ending date or chose to print to the end of the dates on file.',
                             mtError, [mbOK], 0);
                  Result := False;
                end;

          end
        else AllDatesCheckBox.Checked := True;

  If Result
    then
      If ((Deblank(StartSBLEdit.Text) <> '') or
          (Deblank(EndSBLEdit.Text) <> '') or
          AllSBLCheckBox.Checked or
          ToEndofSBLCheckBox.Checked)
        then
          begin
              {Make sure if they clicked to end of range that they put in a start range.}

            If ((ToEndofSBLCheckBox.Checked or
                 (Deblank(EndSBLEdit.Text) <> '')) and
                (Deblank(StartSBLEdit.Text) = ''))
              then
                begin
                  MessageDlg('Please select a starting SBL or chose all SBL"s.', mtError, [mbOK], 0);
                  Result := False;
                end;

              {Make sure that if they entered a start range, there is an end range.}

            If ((Deblank(StartSBLEdit.Text) <> '') and
                ((Deblank(EndSBLEdit.Text) = '') and
                 (not ToEndofSBLCheckBox.Checked)))
              then
                begin
                  MessageDlg('Please select an ending SBL or chose to print to the end of the SBL"s on file.',
                             mtError, [mbOK], 0);
                  Result := False;
                end;

          end
        else AllSBLCheckBox.Checked := True;

    {Now check the user selections.}

  If Result
    then
      If ((Deblank(StartUserEdit.Text) <> '') or
           (Deblank(EndUserEdit.Text) <> '') or
           AllUsersCheckBox.Checked or
           ToEndofUsersCheckBox.Checked)
        then
          begin
              {Make sure if they clicked to end of range that they put in a start range.}

            If ((ToEndofUsersCheckBox.Checked or
                 (Deblank(EndUserEdit.Text) <> '')) and
                (Deblank(StartUserEdit.Text) = ''))
              then
                begin
                  MessageDlg('Please select a starting user or chose all users.', mtError, [mbOK], 0);
                  Result := False;
                end;

              {Make sure that if they entered a start range, there is an end range.}

            If ((Deblank(StartUserEdit.Text) <> '') and
                ((Deblank(EndUserEdit.Text) = '') and
                 (not ToEndofUsersCheckBox.Checked)))
              then
                begin
                  MessageDlg('Please select an ending user or chose to print to the end of the users on file.',
                             mtError, [mbOK], 0);
                  Result := False;
                end;

          end
        else AllUsersCheckBox.Checked := True;

end;  {ValidSelectionInformation}

{====================================================================}
Procedure TAssessorsTrialBalanceReportForm.SaveButtonClick(Sender: TObject);

{FXX04091999-8: Add ability to save and load search report options.}

begin
  SaveReportOptions(Self, OpenDialog, SaveDialog, 'trial.bal', 'Assessor''s Trial Balance Report');

end;  {SaveButtonClick}

{====================================================================}
Procedure TAssessorsTrialBalanceReportForm.LoadButtonClick(Sender: TObject);

{FXX04091999-8: Add ability to save and load search report options.}

begin
  LoadReportOptions(Self, OpenDialog, 'trial.bal', 'Assessor''s Trial Balance Report');

end;  {LoadButtonClick}

{=================================================================}
Procedure TAssessorsTrialBalanceReportForm.PrintButtonClick(Sender: TObject);

var
  NewFileName, SpreadsheetFileName : String;
  Quit : Boolean;
  I : Integer;

begin
    {CHG10152004-2(2.8.0.14): Add option to suppress the taxable value in the AV change section.}

  SuppressTaxableValueInAVSection := SuppressTaxableValueInAVSectionCheckBox.Checked;
  ReportCancelled := False;
  Quit := False;
  ExtractToExcel := cbx_ExtractToExcel.Checked;

    {CHG10121998-1: Add user options for default destination and show vet max msg.}

  SetPrintToScreenDefault(PrintDialog);

  If (ValidSelectionInformation and
      PrintDialog.Execute)
    then
      begin
        CreateParcelList := CreateParcelListCheckBox.Checked;
        If CreateParcelList
          then ParcelListDialog.ClearParcelGrid(True);

          {CHG11151999-2: Allow select of exemptions and special districts.}

        PrintAllExemptions := False;
        PrintAllSpecialDistricts := False;

        SelectedExemptionCodes := TStringList.Create;
        SelectedSpecialDistricts := TStringList.Create;
        SelectedSwisCodes := TStringList.Create;
        SelectedSchoolCodes := TStringList.Create;

        with ExemptionListBox do
          If (SelCount = Items.Count)
            then PrintAllExemptions := True
            else
              For I := 0 to (Items.Count - 1) do
                If Selected[I]
                  then SelectedExemptionCodes.Add(Take(5, Items[I]));

        with SpecialDistrictListBox do
          If (SelCount = Items.Count)
            then PrintAllSpecialDistricts := True
            else
              For I := 0 to (Items.Count - 1) do
                If Selected[I]
                  then SelectedSpecialDistricts.Add(Take(5, Items[I]));

          {CHG12291999-1: Allow for school \ swis selection.}

        SelectedSwisCodes.Clear;

        For I := 0 to (SwisCodeListBox.Items.Count - 1) do
          If SwisCodeListBox.Selected[I]
            then SelectedSwisCodes.Add(Take(6, SwisCodeListBox.Items[I]));

        SelectedSchoolCodes.Clear;

        For I := 0 to (SchoolCodeListBox.Items.Count - 1) do
          If SchoolCodeListBox.Selected[I]
            then SelectedSchoolCodes.Add(Take(6, SchoolCodeListBox.Items[I]));

          {CHG10131998-1: Set the printer settings based on what printer they selected
                          only - they no longer need to worry about paper or landscape
                          mode.}

        AssignPrinterSettings(PrintDialog, ReportPrinter, ReportFiler, [ptLaser], False, Quit);

        If not Quit
          then
            begin
              If ExtractToExcel
                then
                  begin
                    SpreadsheetFileName := GetPrintFileName('ASRTRL', True);
                    AssignFile(ExtractFile, SpreadsheetFileName);
                    Rewrite(ExtractFile);
                  end;  {If ExtractToExcel}

               {FXX01201998-10: Only let user Supervisor choose other users to
                                see the changes for.}
               {FXX09062006-1(2.10.1.9): Allow audit access to all is equivalent to
                                         logging in as supervisor.}

                {CHG06092010-3(2.26.1)[I7208]: Allow for supervisor equivalents.}

              If (UserIsSupervisor(GlblUserName) or
                  GlblAllowAuditAccessToAll)
                then
                  begin
                    PrintAllUsers := AllUsersCheckBox.Checked;
                    PrintToEndOfUsers := ToEndOfUsersCheckBox.Checked;
                    StartUser := Take(10, StartUserEdit.Text);
                    EndUser := Take(10, EndUserEdit.Text);

                  end;  {If (GlblUserName = Take(10, 'SUPERVISOR')}

                {CHG02282001-1: Allow everybody to everyone elses changes.}

             (* If GlblAllowAuditAccessToAll
                then PrintAllUsers := True; *)

              ProgressDialog.Start(GetRecordCount(AuditEXChangeTable) * 2 +
                                   GetRecordCount(AuditSDChangeTable) * 2 +
                                   GetRecordCount(AuditAVChangeTable), True, True);

                {FXX03021998-1: Choose based on year that they selected.}

              AssessmentYearChoosen := TaxYearRadioGroup.ItemIndex;

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

                        {CHG01182000-3: Allow them to choose a different name or copy right away.}
                        {However, we can only do it if they print to screen first since
                         report printer does not generate a file.}

                      ShowReportDialog('ASRTRIAL.RPT', ReportFiler.FileName, True);

                    end;  {If PrintRangeDlg.PreviewPrint}

                  end  {They did not select preview, so we will go
                        right to the printer.}
                else ReportPrinter.Execute;

                {Clear the selections.}

              ProgressDialog.Finish;

                {FXX10111999-3: Tell people that printing is starting and
                                done.}

              DisplayPrintingFinishedMessage(PrintDialog.PrintToFile);

              SelectedExemptionCodes.Free;
              SelectedSpecialDistricts.Free;

              ResetPrinter(ReportPrinter);

            end;  {If not Quit}

        If CreateParcelList
          then ParcelListDialog.Show;

        SelectedSwisCodes.Free;
        SelectedSchoolCodes.Free;

        If ExtractToExcel
          then
            begin
              CloseFile(ExtractFile);
              SendTextFileToExcelSpreadsheet(SpreadsheetFileName, True,
                                             False, '');

            end;  {If PrintToExcel}

      end;  {If PrintDialog.Execute}

end;  {PrintButtonClick}

{=========================================================================}
Procedure TAssessorsTrialBalanceReportForm.ReportFilerBeforePrint(Sender: TObject);

var
  ValidEntry : Boolean;

begin
  ReportSection := 'E';

  If not AllSBLCheckBox.Checked
    then
      begin
        StartingSwisSBL := ConvertSwisDashDotToSwisSBL(StartSBLEdit.Text,
                                                       SwisCodeTable, ValidEntry);

        If ToEndOfSBLCheckBox.Checked
          then EndingSwisSBL := TAke(26,'ZZZZZZZZZZZZZZZZZZZZZZZZZZ')
          else EndingSwisSBL := ConvertSwisDashDotToSwisSBL(EndSBLEdit.Text,
                                                            SwisCodeTable, ValidEntry);
      end;

     {FXX01211998-9: Removed taxrollyear from key - they want to see
                     changes from either year.}
     {CHG01211998-3: Allow tracking of EX, SD deletions.}

  with Sender as TBaseReport do
    begin
      MarginTop := 0.5;
      MarginBottom := 0.75;

        {FXX12101999-3: Need to cancel range in case they change.}
        {FXX01132000-3: Not doing ranges and setting indexes for av change table
                        and parcel change table.}

      AuditEXChangeTable.CancelRange;
      AuditSDChangeTable.CancelRange;
      AuditAVChangeTable.CancelRange;
      AuditParcelChangeTable.CancelRange;

        {FXX06282001-1: Not setting the ranges correctly for by user or SBL
                        when specify a start and end range.}

      with AuditEXChangeTable do
        case IndexRadioGroup.ItemIndex of
          0 : begin  {SBL}
                IndexName := 'BYSWISSBLKEY_DATE_TIME';

                If not AllSBLCheckBox.Checked
                  then SetRangeOld(AuditEXChangeTable,
                                   ['SwisSBLKey', 'Date', 'Time'],
                                   [StartingSwisSBL, '1/1/1850', ''],
                                   [EndingSwisSBL, '1/1/3000', '']);

              end;   {SBL}

          1 : begin  {Date }
                IndexName := 'BYDATE_TIME_SWISSBLKEY';

                  {Set a range if they specified a range.}
                  {FXX01132000-1: Don't put an end range if they want to end of range.}
                  {FXX01132000-2: Actually as a Y2K fix, will just search until after end of
                                  end date.}

                If not AllDatesCheckBox.Checked
                  then FindNearestOld(AuditEXChangeTable,
                                      ['Date', 'Time', 'SwisSBLKey'],
                                      [StartDateEdit.Text, '', '']);

              end;   {Date }

          2 : begin  {User}
                IndexName := 'BYUSER_DATE_TIME';

                  {Set a range if they specified a range.}

                If not AllUsersCheckBox.Checked
                  then
                    If ToEndofDatesCheckBox.Checked
                      then SetRangeOld(AuditEXChangeTable,
                                       ['User', 'Date', 'Time'],
                                       [StartUserEdit.Text, '', ''],
                                       [ConstStr('Z', 10), '', ''])
                      else SetRangeOld(AuditEXChangeTable,
                                       ['User', 'Date', 'Time'],
                                       [StartUserEdit.Text, '1/1/1850', ''],
                                       [EndUserEdit.Text, '1/1/3000', '']);

              end; {User}

        end;  {case IndexRadioGroup of}

      with AuditAVChangeTable do
        case IndexRadioGroup.ItemIndex of
          0 : begin  {SBL}
                IndexName := 'BYSWISSBLKEY_DATE_TIME';

                If not AllSBLCheckBox.Checked
                  then SetRangeOld(AuditAVChangeTable,
                                   ['SwisSBLKey', 'Date', 'Time'],
                                   [StartingSwisSBL, '1/1/1850', ''],
                                   [EndingSwisSBL, '1/1/3000', '']);

              end;   {SBL}

          1 : begin  {Date }
                IndexName := 'BYDATE_TIME_SWISSBLKEY';

                  {Set a range if they specified a range.}
                  {FXX01132000-1: Don't put an end range if they want to end of range.}

                If not AllDatesCheckBox.Checked
                  then FindNearestOld(AuditAVChangeTable,
                                      ['Date', 'Time', 'SwisSBLKey'],
                                      [StartDateEdit.Text, '', '']);

              end;   {Date }

          2 : begin  {User}
                IndexName := 'BYUSER_DATE_TIME';

                  {Set a range if they specified a range.}

                If not AllUsersCheckBox.Checked
                  then
                    If ToEndofDatesCheckBox.Checked
                      then SetRangeOld(AuditAVChangeTable,
                                       ['User', 'Date', 'Time'],
                                       [StartUserEdit.Text, '', ''],
                                       [ConstStr('Z', 10), '', ''])
                      else SetRangeOld(AuditAVChangeTable,
                                       ['User', 'Date', 'Time'],
                                       [StartUserEdit.Text, '1/1/1850', ''],
                                       [EndUserEdit.Text, '1/1/3000', '']);

              end; {User}

        end;  {case IndexRadioGroup of}


    end;  {with Sender as TBaseReport do}

end;  {ReportFilerBeforePrint}

{=====================================================================}
Procedure SetupExemptionSection(Sender : TObject;
                                _PrintHeader : Boolean);

{FXX03021998-2: Only set the tabs and header in one place.}
{CHG03161998-1: Track exemption, SD adds, av changes, parcel add/del.}

begin
  with Sender as TBaseReport do
    begin
      Bold := True;
      ClearTabs;
      Println('');

      If _PrintHeader
        then
          begin
            Bold := True;

            Println('The following exemption changes occurred:');

            Println('');
            ClearTabs;
            SetTab(0.3, pjCenter, 1.2, 0, BOXLINENone, 0);   {SBL}
            SetTab(1.6, pjCenter, 0.8, 0, BOXLINENone, 0);   {Date Entered}
            SetTab(2.5, pjCenter, 0.5, 0, BOXLINENone, 0);   {Time/EX code}
            SetTab(3.1, pjCenter, 1.0, 0, BOXLINENone, 0);   {User/County amt}
            SetTab(4.2, pjCenter, 1.0, 0, BOXLINENone, 0);   {Year/Town amt}

            Println(#9 + 'Parcel ID' +
                    #9 + 'Date' +
                    #9 + 'Time' +
                    #9 + 'User' +
                    #9 + 'Assess Yr');

            ClearTabs;
            SetTab(0.3, pjCenter, 1.2, 0, BOXLINEBOTTOM, 0);   {SBL}
            SetTab(1.6, pjCenter, 0.8, 0, BOXLINEBOTTOM, 0);   {Date Entered}
            SetTab(2.5, pjCenter, 0.5, 0, BOXLINEBOTTOM, 0);   {Time/EX code}
            SetTab(3.1, pjCenter, 1.0, 0, BOXLINEBOTTOM, 0);   {User/County amt}
            SetTab(4.2, pjCenter, 1.0, 0, BOXLINEBOTTOM, 0);   {Year/Town amt}
            SetTab(5.3, pjCenter, 1.0, 0, BOXLINEBOTTOM, 0);   {Schl amt}
            SetTab(6.4, pjCenter, 0.5, 0, BOXLINEBOTTOM, 0);   {Percent}
            SetTab(7.0, pjCenter, 0.5, 0, BOXLINEBOTTOM, 0);   {Owner Percent}
            SetTab(7.6, pjCenter, 0.4, 0, BOXLINEBOTTOM, 0);   {Yr added}

            Print(#9 + #9 +
                  #9 + 'Code');

              {CHG01192004-1(2.08): Let each municipality decide what roll totals to display.}

            If (rtdCounty in GlblRollTotalsToShow)
              then Print(#9 + 'County Amt')
              else Print('');

            If (rtdMunicipal in GlblRollTotalsToShow)
              then Print(#9 + GetShortMunicipalityTypeName(GlblMunicipalityType) + ' Amt')
              else Print('');

           If (rtdSchool in GlblRollTotalsToShow)
             then Print(#9 + 'School Amt')
             else Print('');

            Println(#9 + 'Pct' +
                    #9 + 'Own %' +
                    #9 + 'Init');

          end;  {If _PrintHeader}

      ClearTabs;

      SetTab(0.3, pjLeft, 1.2, 0, BOXLINENone, 0);   {SBL}
      SetTab(1.6, pjLeft, 0.8, 0, BOXLINENone, 0);   {Date Entered}
      SetTab(2.5, pjLeft, 0.5, 0, BOXLINENone, 0);   {Time/EX code}
      SetTab(3.1, pjRight, 1.0, 0, BOXLINENone, 0);   {User/County amt}
      SetTab(4.2, pjRight, 1.0, 0, BOXLINENone, 0);   {Year/Town amt}
      SetTab(5.3, pjRight, 1.0, 0, BOXLINENone, 0);   {Schl amt}
      SetTab(6.4, pjRight, 0.5, 0, BOXLINENone, 0);   {Percent}
      SetTab(7.0, pjRight, 0.5, 0, BOXLINENone, 0);   {Owner Percent}
      SetTab(7.6, pjRight, 0.4, 0, BOXLINENone, 0);   {Yr added}

      Bold := False;

    end;  {with Sender as TBaseReport do}

end;  {SetupExemptionSection}

{=====================================================================}
Procedure SetupSpecialDistrictSection(Sender : TObject;
                                      RecordType : Char;
                                      _PrintHeader : Boolean);

{FXX03021998-2: Only set the tabs and header in one place.}
{CHG03161998-1: Track exemption, SD adds, av changes, parcel add/del.}

begin
  with Sender as TBaseReport do
    begin
      Bold := True;
      ClearTabs;
      Println('');

      If _PrintHeader
        then
          begin
            Bold := True;
            case RecordType of
              'A' : Println('The following special districts were added:');
              'C' : Println('The following special districts were changed:');
              'D' : Println('The following special districts were deleted:');
            end;

            Println('');
            ClearTabs;
            SetTab(0.3, pjCenter, 1.2, 0, BOXLINEBOTTOM, 0);   {SBL}
            SetTab(1.6, pjCenter, 0.5, 0, BOXLINEBOTTOM, 0);   {Date Entered}
            SetTab(2.4, pjCenter, 0.5, 0, BOXLINEBOTTOM, 0);   {Time}
            SetTab(3.1, pjCenter, 0.7, 0, BOXLINEBOTTOM, 0);   {User}
            SetTab(3.9, pjCenter, 0.2, 0, BOXLINEBOTTOM, 0);   {Year}
            SetTab(4.2, pjCenter, 0.5, 0, BOXLINEBOTTOM, 0);   {SD Code}
            SetTab(4.8, pjCenter, 0.8, 0, BOXLINEBOTTOM, 0);   {Primary units}
            SetTab(5.7, pjCenter, 0.8, 0, BOXLINEBOTTOM, 0);   {2nd units}
            SetTab(6.6, pjCenter, 0.8, 0, BOXLINEBOTTOM, 0);   {Calc amount}
            SetTab(7.5, pjCenter, 0.4, 0, BOXLINEBOTTOM, 0);   {SD %}

            Println(#9 + 'Parcel ID' +
                    #9 + 'Date ' +
                    #9 + 'Time' +
                    #9 + 'User' +
                    #9 + 'Yr' +
                    #9 + 'SD Cd' +
                    #9 + 'Units' +
                    #9 + '2nd Unit' +
                    #9 + 'Amount' +
                    #9 + 'Pct');

          end;  {If _PrintHeader}

      ClearTabs;
      SetTab(0.3, pjLeft, 1.2, 0, BOXLINENone, 0);   {SBL}
      SetTab(1.6, pjLeft, 0.5, 0, BOXLINENone, 0);   {Date Entered}
      SetTab(2.4, pjLeft, 0.5, 0, BOXLINENone, 0);   {Time}
      SetTab(3.1, pjLeft, 0.7, 0, BOXLINENone, 0);   {User}
      SetTab(3.9, pjRight, 0.2, 0, BOXLINENone, 0);   {Year}
      SetTab(4.2, pjLeft, 0.5, 0, BOXLINENone, 0);   {SD Code}
      SetTab(4.8, pjRight, 0.8, 0, BOXLINENone, 0);   {Primary units}
      SetTab(5.7, pjRight, 0.8, 0, BOXLINENone, 0);   {2nd units}
      SetTab(6.6, pjRight, 0.8, 0, BOXLINENone, 0);   {Calc amount}
      SetTab(7.5, pjRight, 0.4, 0, BOXLINENone, 0);   {SD %}

      Bold := False;

    end;  {with Sender as TBaseReport do}

end;  {SetupSpecialDistrictDeletionSection}

{=====================================================================}
Procedure SetupAVChangeSection(Sender : TObject;
                               _PrintHeader : Boolean;
                               SuppressTaxableValueInAVSection : Boolean);

{FXX03021998-2: Only set the tabs and header in one place.}
{CHG03161998-1: Track exemption, SD adds, av changes, parcel add/del.}

var
  ColumnLines : Byte;

begin
  with Sender as TBaseReport do
    begin
      Bold := True;
      ClearTabs;
      Println('');

      If _PrintHeader
        then
          begin
            Bold := True;
            Println('The following assessed value changes occurred:');

            Println('');

            If SuppressTaxableValueInAVSection
              then ColumnLines := BOXLINEBOTTOM
              else ColumnLines := BOXLINENone;

            ClearTabs;
            SetTab(0.3, pjCenter, 1.2, 0, ColumnLines, 0);   {SBL}
            SetTab(1.6, pjCenter, 0.5, 0, ColumnLines, 0);   {Date Entered}
            SetTab(2.4, pjCenter, 0.5, 0, ColumnLines, 0);   {Time}
            SetTab(3.1, pjCenter, 0.7, 0, ColumnLines, 0);   {User}
            SetTab(3.9, pjCenter, 0.2, 0, ColumnLines, 0);   {Year}
            SetTab(4.2, pjCenter, 1.1, 0, ColumnLines, 0);   {Old AV / Cnty TV change}
            SetTab(5.4, pjCenter, 1.1, 0, ColumnLines, 0);   {New AV / Town TV change}
            SetTab(6.6, pjCenter, 1.1, 0, ColumnLines, 0);   {AV change / School TV change}

            Println(#9 + 'Parcel ID' +
                    #9 + 'Date ' +
                    #9 + 'Time' +
                    #9 + 'User' +
                    #9 + 'Yr' +
                    #9 + 'Old AV' +
                    #9 + 'New AV' +
                    #9 + 'AV Change');

              {CHG10152004-2(2.8.0.14): Add option to suppress the taxable value in the AV change section.}

            If not SuppressTaxableValueInAVSection
              then
                begin
                  ClearTabs;
                  SetTab(0.3, pjCenter, 1.2, 0, BOXLINEBOTTOM, 0);   {SBL}
                  SetTab(1.6, pjCenter, 0.5, 0, BOXLINEBOTTOM, 0);   {Date Entered}
                  SetTab(2.4, pjCenter, 0.5, 0, BOXLINEBOTTOM, 0);   {Time}
                  SetTab(3.1, pjCenter, 0.7, 0, BOXLINEBOTTOM, 0);   {User}
                  SetTab(3.9, pjCenter, 0.2, 0, BOXLINEBOTTOM, 0);   {Year}
                  SetTab(4.2, pjCenter, 1.1, 0, BOXLINEBOTTOM, 0);   {Old AV / Cnty TV change}
                  SetTab(5.4, pjCenter, 1.1, 0, BOXLINEBOTTOM, 0);   {New AV / Town TV change}
                  SetTab(6.6, pjCenter, 1.1, 0, BOXLINEBOTTOM, 0);   {AV change / School TV change}

                  Print(#9 + #9 + #9 + #9 + #9);

                    {CHG01192004-1(2.08): Let each municipality decide what roll totals to display.}

                  If (rtdCounty in GlblRollTotalsToShow)
                    then Print(#9 + 'Cnty TV Chg')
                    else Print('');

                  If (rtdMunicipal in GlblRollTotalsToShow)
                    then Print(#9 + GetShortMunicipalityTypeName(GlblMunicipalityType) + ' TV Chg')
                    else Print('');

                 If (rtdSchool in GlblRollTotalsToShow)
                   then Println(#9 + 'School TV Chg')
                   else Println('');

                end;  {If not SuppressTaxableValueInAVSection}

          end;  {If _PrintHeader}

      ClearTabs;
      SetTab(0.3, pjLeft, 1.2, 0, BOXLINENone, 0);   {SBL}
      SetTab(1.6, pjLeft, 0.5, 0, BOXLINENone, 0);   {Date Entered}
      SetTab(2.4, pjLeft, 0.5, 0, BOXLINENone, 0);   {Time}
      SetTab(3.1, pjLeft, 0.7, 0, BOXLINENone, 0);   {User}
      SetTab(3.9, pjRight, 0.2, 0, BOXLINENone, 0);   {Year}
      SetTab(4.2, pjRight, 1.1, 0, BOXLINENone, 0);   {Old AV / Cnty TV change}
      SetTab(5.4, pjRight, 1.1, 0, BOXLINENone, 0);   {New AV / Town TV change}
      SetTab(6.6, pjRight, 1.1, 0, BOXLINENone, 0);   {AV change / School TV change}

      Bold := False;

    end;  {with Sender as TBaseReport do}

end;  {SetupSpecialDistrictDeletionSection}

{=====================================================================}
Procedure SetupParcelChangeSection(Sender : TObject;
                                   RecordType : Char;
                                   _PrintHeader : Boolean);

{FXX03021998-2: Only set the tabs and header in one place.}
{CHG03161998-1: Track exemption, SD adds, av changes, parcel add/del.}

begin
  with Sender as TBaseReport do
    begin
      Bold := True;
      ClearTabs;
      Println('');

      If _PrintHeader
        then
          begin
            Bold := True;
            case RecordType of
              'A' : Println('The following parcels were added:');
              'C' : Println('The following parcels were changed:');
              'D' : Println('The following parcels were deleted:');
            end;

            Println('');
            ClearTabs;
            SetTab(0.3, pjCenter, 1.2, 0, BOXLINENone, 0);   {SBL}
            SetTab(1.6, pjCenter, 0.5, 0, BOXLINENone, 0);   {Date Entered}
            SetTab(2.4, pjCenter, 0.5, 0, BOXLINENone, 0);   {Time\HC}
            SetTab(3.1, pjCenter, 0.7, 0, BOXLINENone, 0);   {User\Schl}
            SetTab(3.9, pjCenter, 0.2, 0, BOXLINENone, 0);   {Year\RS}
            SetTab(4.2, pjCenter, 1.1, 0, BOXLINENone, 0);   {AV\County TV}
            SetTab(5.4, pjCenter, 1.1, 0, BOXLINENone, 0);   {Res %\Town TV}
            SetTab(6.6, pjCenter, 1.1, 0, BOXLINENone, 0);   {S\M #\Schl TV}

            Println(#9 + 'Parcel ID' +
                    #9 + 'Date ' +
                    #9 + 'Time' +
                    #9 + 'User' +
                    #9 + 'Yr' +
                    #9 + 'Assessed Val' +
                    #9 + 'Res %' +
                    #9 + 'S\M #');

            ClearTabs;
            SetTab(0.3, pjCenter, 1.2, 0, BOXLINEBottom, 0);   {SBL}
            SetTab(1.6, pjCenter, 0.5, 0, BOXLINEBottom, 0);   {Date Entered}
            SetTab(2.4, pjCenter, 0.5, 0, BOXLINEBottom, 0);   {Time\HC}
            SetTab(3.1, pjCenter, 0.7, 0, BOXLINEBottom, 0);   {User\Res%}
            SetTab(3.9, pjCenter, 0.2, 0, BOXLINEBottom, 0);   {Year\RS}
            SetTab(4.2, pjCenter, 1.1, 0, BOXLINEBottom, 0);   {AV\County TV}
            SetTab(5.4, pjCenter, 1.1, 0, BOXLINEBottom, 0);   {Res %\Town TV}
            SetTab(6.6, pjCenter, 1.1, 0, BOXLINEBottom, 0);   {S\M #\Schl TV}

            Print(#9 + #9 +
                  #9 + 'HC' +
                  #9 + 'Schl Cd' +
                  #9 + 'RS');

              {CHG01192004-1(2.08): Let each municipality decide what roll totals to display.}

            If (rtdCounty in GlblRollTotalsToShow)
              then Print(#9 + 'Cnty Tx Val')
              else Print('');

            If (rtdMunicipal in GlblRollTotalsToShow)
              then Print(#9 + GetShortMunicipalityTypeName(GlblMunicipalityType) + ' Tx Val')
              else Print('');

           If (rtdSchool in GlblRollTotalsToShow)
             then Println(#9 + 'School Tx Val')
             else Println('');

          end;  {If _PrintHeader}

      ClearTabs;
      SetTab(0.3, pjLeft, 1.2, 0, BOXLINENone, 0);   {SBL}
      SetTab(1.6, pjLeft, 0.5, 0, BOXLINENone, 0);   {Date Entered}
      SetTab(2.4, pjLeft, 0.5, 0, BOXLINENone, 0);   {Time}
      SetTab(3.1, pjLeft, 0.7, 0, BOXLINENone, 0);   {User}
      SetTab(3.9, pjRight, 0.2, 0, BOXLINENone, 0);   {Year}
      SetTab(4.2, pjRight, 1.1, 0, BOXLINENone, 0);   {AV}
      SetTab(5.4, pjRight, 1.1, 0, BOXLINENone, 0);   {TV}
      SetTab(6.6, pjCenter, 1.1, 0, BOXLINENone, 0);   {S\M #}

      Bold := False;

    end;  {with Sender as TBaseReport do}

end;  {SetupParcelChangeSection}

{====================================================================}
Procedure TAssessorsTrialBalanceReportForm.ReportFilerPrintHeader(Sender: TObject);

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
      SetFont('Times New Roman',12);
      Bold := True;
      Home;
      PrintCenter('Assessor''s Trial Balance Report', (PageWidth / 2));
      Bold := False;
      CRLF;
      CRLF;

      Underline := False;
      ClearTabs;
      SetTab(0.5, pjLeft, 1.5, 0, BOXLINENONE, 0);   {Index}
      SetTab(2.1, pjLeft, 1.7, 0, BOXLINENONE, 0);   {Tax roll yr}
      SetTab(3.9, pjLeft, 1.5, 0, BOXLINENONE, 0);   {Dates}
      SetTab(5.5, pjLeft, 1.5, 0, BOXLINENONE, 0);   {Users}

        {Print the selection information.}

      SetFont('Times New Roman',10);
      Bold := True;
      Print(#9 + 'Index:  ');
      Bold := False;

      case IndexRadioGroup.ItemIndex of
        0 : Print(' SBL');
        1 : Print(' Date');
        2 : Print(' User');
      end;  {case IndexRadioGroup of}

      Bold := True;
      Print(#9 + 'Assessment Year:');
      Bold := False;

      case TaxYearRadioGroup.ItemIndex of
        0 : Print(' This Year');
        1 : Print(' Next Year');
        2 : Print(' All');
      end;  {case NoteTypeRadioGroup.ItemIndex of}

      Bold := True;
      Print(#9 + 'For Dates: ');
      Bold := False;

      If AllDatesCheckBox.Checked
        then Print(' All')
        else
          begin
            Print(' ' + StartDateEdit.Text + ' to ');

            If ToEndOfDatesCheckBox.Checked
              then Print(' End')
              else Print(' ' + EndDateEdit.Text);
          end;  {else of If AllDatesCheckBox.Checked}

      Println('');

      Bold := True;
      Print(#9 + #9 + 'For Users: ');
      Bold := False;

      If PrintAllUsers
        then Println(' All')
        else
          begin
            Print(' ' + StartUser + ' to ');

            If PrintToEndOfUsers
              then Println(' End')
              else Println(' ' + EndUser);

          end;  {else of If PrintAllUsers}

      Bold := True;
      Print(#9 + #9 + 'For SBL''s: ');
      Bold := False;

      If AllSBLCheckBox.Checked
        then Println(' All')
        else
          begin
            Print(' ' + StartSBlEdit.Text + ' to ');

            If ToEndOfSBLCheckBox.Checked
              then Println(' End')
              else Println(' ' + EndSBLEdit.Text);

          end;  {else of If AllSBLSCheckBox.Checked}

      SectionTop := 1.2;

        {Print column headers.}

      Home;
      SetPen(clBlack, psSolid, 1, pmCopy); { Set pen to 1 dot width }
      SetFont('Times New Roman', 10);

        {Don't print the header if this is the first page. Otherwise,
         we will print the first header 2x.}

      If (CurrentPage <> 1)
        then
          If (ReportSection = 'E')  {Change}
            then SetupExemptionSection(Sender, True);

      If (ReportSection = 'SA')  {Add}
        then SetupSpecialDistrictSection(Sender, 'A', True);

      If (ReportSection = 'SC')  {Add}
        then SetupSpecialDistrictSection(Sender, 'C', True);

      If (ReportSection = 'SD')  {Delete}
        then SetupSpecialDistrictSection(Sender, 'D', True);

      If (ReportSection = 'AV')  {Assessed value changes}
        then SetupAVChangeSection(Sender, True, SuppressTaxableValueInAVSection);

      If (ReportSection = 'PA')  {Parcel adds}
        then SetupParcelChangeSection(Sender, 'A', True);

      If (ReportSection = 'PD')  {Parcel deletes}
        then SetupParcelChangeSection(Sender, 'D', True);

      If (ReportSection = 'PC')  {Parcel change}
        then SetupParcelChangeSection(Sender, 'C', True);

    end;  {with Sender as TBaseReport do}

end;  {ReportFilerPrintHeader}

{====================================================================}
Procedure PrintSectionChangeTotals(Sender : TObject;
                                   TotalAVChange,
                                   TotalCountyTaxableChange,
                                   TotalTownTaxableChange,
                                   TotalSchoolTaxableChange : LongInt);

{Print the AV and TV changes for this section.}

begin
  with Sender as TBaseReport do
    begin
        {Print totals}
      Println('');
      Bold := True;
      ClearTabs;
      SetTab(1.8, pjCenter, 1.1, 0, BOXLINENone, 0);   {Hdr}
      SetTab(3.1, pjCenter, 1.1, 0, BOXLINEBottom, 0);   {AV change}
      SetTab(4.3, pjCenter, 1.1, 0, BOXLINEBottom, 0);   {County TV change}
      SetTab(5.5, pjCenter, 1.1, 0, BOXLINEBottom, 0);   {Town TV change}
      SetTab(6.7, pjCenter, 1.1, 0, BOXLINEBottom, 0);   {School TV change}

        {CHG01192004-1(2.08): Let each municipality decide what roll totals to display.}

      Print(#9 + 'Net Change:' +
            #9 + 'AV Change');

      If (rtdCounty in GlblRollTotalsToShow)
        then Print(#9 + 'Cnty Tx Chg')
        else Print(#9);

      If (rtdMunicipal in GlblRollTotalsToShow)
        then Print(#9 + GetShortMunicipalityTypeName(GlblMunicipalityType) + ' Tx Chg')
        else Print(#9);

      If (rtdSchool in GlblRollTotalsToShow)
        then Println(#9 + 'Schl Tx Chg')
        else Println('');

      ClearTabs;
      SetTab(1.8, pjLeft, 1.1, 0, BOXLINENone, 0);   {Hdr}
      SetTab(3.1, pjRight, 1.1, 0, BOXLINENone, 0);   {AV change}
      SetTab(4.3, pjRight, 1.1, 0, BOXLINENone, 0);   {County TV change}
      SetTab(5.4, pjRight, 1.1, 0, BOXLINENone, 0);   {Town TV change}
      SetTab(6.5, pjRight, 1.1, 0, BOXLINENone, 0);   {School TV change}

        {CHG01192004-1(2.08): Let each municipality decide what roll totals to display.}

      Print(#9 +
            #9 + FormatFloat(CurrencyNormalDisplay_BlankZero,
                             TotalAVChange));

      If (rtdCounty in GlblRollTotalsToShow)
        then Print(#9 + FormatFloat(CurrencyNormalDisplay_BlankZero,
                                    TotalCountyTaxableChange))
        else Print(#9);

      If (rtdMunicipal in GlblRollTotalsToShow)
        then Print(#9 + FormatFloat(CurrencyNormalDisplay_BlankZero,
                                    TotalTownTaxableChange))
        else Print(#9);

      If (rtdSchool in GlblRollTotalsToShow)
        then Println(#9 + FormatFloat(CurrencyNormalDisplay_BlankZero,
                                      TotalSchoolTaxableChange))
        else Println('');

      Bold := False;

    end;  {with Sender as TBaseReport do}

end;  {else of If (NumChanged = 0)}

{=============================================================================}
Procedure PrintExemptionTotals(    Sender : TObject;
                                   BeforeCountyAmount,
                                   BeforeTownAmount,
                                   BeforeSchoolAmount,
                                   AfterCountyAmount,
                                   AfterTownAmount,
                                   AfterSchoolAmount : LongInt;
                               var TotalBeforeCountyAmount,
                                   TotalBeforeSchoolAmount,
                                   TotalBeforeTownAmount,
                                   TotalAfterCountyAmount,
                                   TotalAfterSchoolAmount,
                                   TotalAfterTownAmount : LongInt);

begin
  with Sender as TBaseReport do
    begin
      Bold := True;

        {CHG01192004-1(2.08): Let each municipality decide what roll totals to display.}

      Print(#9 + #9 + #9 + 'Net Change:');

      If (rtdCounty in GlblRollTotalsToShow)
        then Print(#9 + FormatFloat(CurrencyNormalDisplay,
                                    (AfterCountyAmount - BeforeCountyAmount)))
        else Print(#9);

      If (rtdMunicipal in GlblRollTotalsToShow)
        then Print(#9 + FormatFloat(CurrencyNormalDisplay,
                                    (AfterTownAmount - BeforeTownAmount)))
        else Print(#9);

      If (rtdSchool in GlblRollTotalsToShow)
        then Println(#9 + FormatFloat(CurrencyNormalDisplay,
                                      (AfterSchoolAmount - BeforeSchoolAmount)))
        else Println('');

      Bold := False;

    end;  {with Sender as TBaseReport do}

    {Update running totals.}

  TotalBeforeCountyAmount := TotalBeforeCountyAmount + BeforeCountyAmount;
  TotalBeforeSchoolAmount := TotalBeforeSchoolAmount + BeforeSchoolAmount;
  TotalBeforeTownAmount := TotalBeforeTownAmount + BeforeTownAmount;
  TotalAfterCountyAmount := TotalAfterCountyAmount + AfterCountyAmount;
  TotalAfterSchoolAmount := TotalAfterSchoolAmount + AfterSchoolAmount;
  TotalAfterTownAmount := TotalAfterTownAmount + AfterTownAmount;

end;  {PrintExemptionTotals}

(*
{====================================================================}
Procedure TAssessorsTrialBalanceReportForm.PrintExemptionSection(     Sender : TObject;
                                                                      AuditEXChangeTable : TTable;
                                                                  var GrandTotalCountyTaxableChange,
                                                                      GrandTotalTownTaxableChange,
                                                                      GrandTotalSchoolTaxableChange : LongInt);

{CHG03241998-1: Print the exemptions before and after as a whole picture.}

type
  ExemptionChangeHeaderRecord = record
    TransactionNumber : LongInt;
    SwisSBLKey : String;
    Date : TDateTime;
    Time : TTime;
    User : String;
    AssessmentYear : String;
  end;

  ExemptionChangeHeaderPointer  = ^ExemptionChangeHeaderRecord;


  ExemptionChangeRecord = record
    TransactionNumber : LongInt;
    ExemptionCode : String;
    CountyAmount : LongInt;
    MunicipalAmount : LongInt;
    SchoolAmount : LongInt;
    VillageAmount : LongInt;
    Percent : Double;
    OwnerPercent : Double;
    InitialDate : TDateTime;
    TerminationDate : TDateTime;
  end;

var
  Done, Quit, FirstTimeThrough : Boolean;
  NumChanged : Integer;
  SwisSBLKey, LastSwisSBLKey : String;
  LastBeforeOrAfter : String;
  LastTaxRollYr : String;
  TempDate, TempStr : String;
  BeforeCountyAmount, BeforeSchoolAmount, BeforeTownAmount,
  AfterCountyAmount, AfterSchoolAmount, AfterTownAmount,
  TotalBeforeCountyAmount, TotalBeforeSchoolAmount,
  TotalBeforeTownAmount, TotalAfterCountyAmount,
  TotalAfterSchoolAmount, TotalAfterTownAmount : LongInt;
  SBLRec : SBLRecord;
  TempDate2 : TDateTime;

begin
    {If they are searching by date range and have specified a range, then don't
     do a get first - we already did a FindNearest.}

  If ((IndexRadioGroup.ItemIndex in [0, 2]) or
      AllDatesCheckBox.Checked)
    then AuditEXChangeTable.First;

  Done := False;
  FirstTimeThrough := True;
  Quit := False;
  ReportSection := 'E';
  NumChanged := 0;

  with Sender as TBaseReport do
    If (LinesLeft < 10)
      then NewPage
      else SetupExemptionSection(Sender, True);

  LastSwisSBLKey := '';
  LastBeforeOrAfter := '';
  LastTaxRollYr := '';

  TotalBeforeCountyAmount := 0;
  TotalBeforeSchoolAmount := 0;
  TotalBeforeTownAmount := 0;
  TotalAfterCountyAmount := 0;
  TotalAfterSchoolAmount := 0;
  TotalAfterTownAmount := 0;

    {FXX04151998-5: Not initializing amount variables.}

  BeforeCountyAmount := 0;
  BeforeSchoolAmount := 0;
  BeforeTownAmount := 0;
  AfterCountyAmount := 0;
  AfterSchoolAmount := 0;
  AfterTownAmount := 0;

  with Sender as TBaseReport do
    begin
        {First print the individual changes.}

      repeat
        If FirstTimeThrough
          then FirstTimeThrough := False
          else AuditEXChangeTable.Next;

        TempDate2 := AuditEXChangeTable.FieldByName('Date').AsDateTime;

        If (AuditEXChangeTable.EOF or
            ((IndexRadioGroup.ItemIndex = 1) and
             (not AllDatesCheckBox.Checked) and
             (not ToEndofDatesCheckBox.Checked) and
             (TempDate2 > StrToDate(EndDateEdit.Text))))
          then Done := True;

          {Print the present record.}

        If not (Done or Quit)
          then
            begin
              {Update the progress panel.}

              with AuditEXChangeTable do
                case IndexRadioGroup.ItemIndex of
                  0 : ProgressDialog.Update(Self,
                                            ConvertSwisSBLToDashDot(FieldByName('SwisSBLKey').Text));
                  1 : ProgressDialog.Update(Self, FieldByName('Date').Text);
                  2 : ProgressDialog.Update(Self, FieldByName('User').Text);

                end;  {case IndexRadioGroup.ItemIndex of}

                {CHG01211998-3: Allow tracking of EX, SD deletions.}
                {CHG11151999-2: Allow selection of EX, SD codes.}

              SBLRec := ExtractSwisSBLFromSwisSBLKey(AuditEXChangeTable.FieldByName('SwisSBLKey').Text);

              with SBLRec do
                FindKeyOld(ParcelTable,
                           ['TaxRollYr', 'SwisCode', 'Section',
                             'Subsection', 'Block', 'Lot', 'Sublot',
                             'Suffix'],
                           [GetTaxRlYr, SwisCode, Section, Subsection,
                            Block, Lot, Sublot, Suffix]);

              with AuditEXChangeTable do
                If (RecordInRange(FieldByName('Date').AsDateTime,
                                   FieldByName('SwisSBLKey').Text,
                                   ParcelTable.FieldByName('SchoolCode').Text,
                                   FieldByName('User').Text,
                                   FieldByName('TaxRollYr').Text) and
                    RecordInEX_SDRange('E'))
                  then
                    begin
                      NumChanged := NumChanged + 1;

                      If ((FieldByName('SwisSBLKey').Text <> LastSwisSBLKey) or
                          (FieldByName('TaxRollYr').Text <> LastTaxRollYr))
                        then
                          begin
                              {Print totals for the last parcel.}

                            If (Deblank(LastSwisSBLKey) <> '')
                              then PrintExemptionTotals(Sender,
                                                        BeforeCountyAmount,
                                                        BeforeTownAmount,
                                                        BeforeSchoolAmount,
                                                        AfterCountyAmount,
                                                        AfterTownAmount,
                                                        AfterSchoolAmount,
                                                        TotalBeforeCountyAmount,
                                                        TotalBeforeSchoolAmount,
                                                        TotalBeforeTownAmount,
                                                        TotalAfterCountyAmount,
                                                        TotalAfterSchoolAmount,
                                                        TotalAfterTownAmount);

                            Println('');
                            Println(#9 + ConvertSwisSBLToDashDot(FieldByName('SwisSBLKey').Text) +
                                    #9 + FieldByName('Date').Text +
                                    #9 + FormatDateTime(TimeFormat, FieldByName('Time').AsDateTime) +
                                    #9 + FieldByName('User').Text +
                                    #9 + FieldByName('TaxRollYr').Text);

                            BeforeCountyAmount := 0;
                            BeforeSchoolAmount := 0;
                            BeforeTownAmount := 0;
                            AfterCountyAmount := 0;
                            AfterSchoolAmount := 0;
                            AfterTownAmount := 0;

                              {CHG11151999-3: Add create parcel list to audits, ex letters.}

                            SwisSBLKey := FieldByName('SwisSBLKey').Text;
                            If (CreateParcelList and
                                (not ParcelListDialog.ParcelExistsInList(SwisSBLKey)))
                              then ParcelListDialog.AddOneParcel(SwisSBLKey);

                          end;  {If ((FieldByName('SwisSBLKey').Text <> ...}

                      If ((FieldByName('SwisSBLKey').Text <> LastSwisSBLKey) or
                          (FieldByName('TaxRollYr').Text <> LastTaxRollYr) or
                          (FieldByName('BeforeOrAfter').Text <> LastBeforeOrAfter))
                        then
                          begin
                            If (FieldByName('BeforeOrAfter').Text = 'B')
                              then TempStr := 'Before:'
                              else TempStr := 'After:';
                          end
                        else TempStr := '';

                      Bold := True;
                      Print(#9 + #9 + TempStr);
                      Bold := False;

                      TempDate := Trim(DateTimetoMMDDYYYY(FieldByName('InitialDate').AsDateTime));
                      TempDate := Copy(TempDate, SizeOf(TempDate) - 3, 4);

                        {CHG01192004-1(2.08): Let each municipality decide what roll totals to display.}

                      Print(#9 + FieldByName('ExemptionCode').Text);

                      If (rtdCounty in GlblRollTotalsToShow)
                        then Print(#9 + FormatFloat(CurrencyNormalDisplay,
                                                    FieldByName('CountyAmount').AsFloat))
                        else Print(#9);

                      If (rtdMunicipal in GlblRollTotalsToShow)
                        then Print(#9 + FormatFloat(CurrencyNormalDisplay,
                                                    FieldByName('TownAmount').AsFloat))
                        else Print(#9);

                      If (rtdSchool in GlblRollTotalsToShow)
                        then Print(#9 + FormatFloat(CurrencyNormalDisplay,
                                                    FieldByName('SchoolAmount').AsFloat))
                        else Print(#9);

                      Println(#9 + FormatFloat(NoDecimalDisplay_BlankZero,
                                               FieldByName('Percent').AsFloat) +
                              #9 + FormatFloat(NoDecimalDisplay_BlankZero,
                                               FieldByName('OwnerPercent').AsFloat) +
                              #9 + TempDate);

                        {Update the totals}

                      If (FieldByName('BeforeOrAfter').Text = 'B')
                        then
                          begin
                            BeforeCountyAmount := BeforeCountyAmount + FieldByName('CountyAmount').AsFloat;
                            BeforeTownAmount := BeforeTownAmount + FieldByName('TownAmount').AsFloat;
                            BeforeSchoolAmount := BeforeSchoolAmount + FieldByName('SchoolAmount').AsFloat;
                          end
                        else
                          begin
                            AfterCountyAmount := AfterCountyAmount + FieldByName('CountyAmount').AsFloat;
                            AfterTownAmount := AfterTownAmount + FieldByName('TownAmount').AsFloat;
                            AfterSchoolAmount := AfterSchoolAmount + FieldByName('SchoolAmount').AsFloat;

                          end;  {else of If (FieldByName('BeforeOrAfter').Text = 'B')}

                        {FXX11221999-2: Need to reset last vars only when actually print.}

                      LastSwisSBLKey := AuditEXChangeTable.FieldByName('SwisSBLKey').Text;
                      LastBeforeOrAfter := AuditEXChangeTable.FieldByName('BeforeOrAfter').Text;
                      LastTaxRollYr := AuditEXChangeTable.FieldByName('TaxRollYr').Text;

                    end;  {with AuditEXChangeTable do}

                {If there is only one line left to print, then we
                 want to go to the next page.}

              If (LinesLeft < 3)
                then NewPage;

            end;  {If not (Done or Quit)}

          {Print the totals for the last one.}

        If Done
          then PrintExemptionTotals(Sender, BeforeCountyAmount,
                                    BeforeTownAmount, BeforeSchoolAmount,
                                    AfterCountyAmount, AfterTownAmount,
                                    AfterSchoolAmount, TotalBeforeCountyAmount,
                                    TotalBeforeSchoolAmount, TotalBeforeTownAmount,
                                    TotalAfterCountyAmount, TotalAfterSchoolAmount,
                                    TotalAfterTownAmount);

        ReportCancelled := ProgressDialog.Cancelled;

      until (Done or Quit or ReportCancelled);

        {Print the grand totals.}
        {Note that we are showing taxable value change, so this will be
         the inverse of the exemption amount.}

      PrintSectionChangeTotals(Sender, 0,
                               -1 *(TotalAfterCountyAmount -
                                TotalBeforeCountyAmount),
                               -1 * (TotalAfterTownAmount -
                                TotalBeforeTownAmount),
                               -1 * (TotalAfterSchoolAmount -
                                TotalBeforeSchoolAmount));

        {Note that positive total exemption changes will reduce taxable
         value and vice versa.}

      GrandTotalCountyTaxableChange := -1 * (TotalAfterCountyAmount - TotalBeforeCountyAmount);
      GrandTotalTownTaxableChange := -1 * (TotalAfterTownAmount - TotalBeforeTownAmount);
      GrandTotalSchoolTaxableChange := -1 * (TotalAfterSchoolAmount - TotalBeforeSchoolAmount);

        {FXX01231998-5: Tell them if nothing in range.}

      If (NumChanged = 0)
        then Println('None.');

      Println('');

    end;  {with Sender as TBaseReport do}

end;  {PrintExemptionSection} *)

{======================================================================}
Procedure PrintOneExemptionChangeLine(    Sender : TObject;
                                          HeaderPrinted : Boolean;
                                          BeforeTransaction : Boolean;
                                          ExemptionChangeDetailRec : ExemptionChangeDetailRecord;
                                      var ExtractFile : TextFile;
                                          ExtractToExcel : Boolean);

var
  TempDate : String;

begin
  If ExtractToExcel
    then WriteCommaDelimitedLine(ExtractFile,
                                 ['', '', '', '', '']);

  with Sender as TBaseReport, ExemptionChangeDetailRec do
    begin
      If HeaderPrinted
        then
          begin
            Print(#9 + #9);

            If ExtractToExcel
              then WriteCommaDelimitedLine(ExtractFile,
                                           ['']);

          end
        else
          begin
            Bold := True;

            If BeforeTransaction
              then
                begin
                  Print(#9 + #9 + 'Before:');

                  If ExtractToExcel
                    then WriteCommaDelimitedLine(ExtractFile,
                                                 ['Before']);
                end
              else
                begin
                  Println('');
                  Print(#9 + #9 + 'After:');

                  If ExtractToExcel
                    then WriteCommaDelimitedLine(ExtractFile,
                                                 ['After']);

                end;  {else of If BeforeTransaction}

            Bold := False;

          end;  {else of If HeaderPrinted}

      TempDate := Trim(DateTimetoMMDDYYYY(InitialDate));
      TempDate := Copy(TempDate, SizeOf(TempDate) - 3, 4);

      Print(#9 + ExemptionCode);

      If (rtdCounty in GlblRollTotalsToShow)
        then Print(#9 + FormatFloat(CurrencyNormalDisplay, CountyAmount))
        else Print(#9);

      If (rtdMunicipal in GlblRollTotalsToShow)
        then Print(#9 + FormatFloat(CurrencyNormalDisplay, MunicipalAmount))
        else Print(#9);

      If (rtdSchool in GlblRollTotalsToShow)
        then Print(#9 + FormatFloat(CurrencyNormalDisplay, SchoolAmount))
        else Print(#9);

      Println(#9 + FormatFloat(NoDecimalDisplay_BlankZero, Percent) +
              #9 + FormatFloat(NoDecimalDisplay_BlankZero, OwnerPercent) +
              #9 + TempDate);

      If (LinesLeft < 7)
        then NewPage;

      If ExtractToExcel
        then WritelnCommaDelimitedLine(ExtractFile,
                                       [ExemptionCode,
                                        CountyAmount,
                                        MunicipalAmount,
                                        SchoolAmount]);

    end;  {with Sender as TBaseReport do}

end;  {PrintOneExemptionChangeLine}

{======================================================================}
Procedure TAssessorsTrialBalanceReportForm.PrintOneExemptionTransaction(    Sender : TObject;
                                                                            ExemptionChangeHeaderList : TList;
                                                                            ExemptionChangeDetailList : TList;
                                                                            Index : LongInt;
                                                                        var NumPrinted : LongInt;
                                                                        var TotalCountyAmountBefore : LongInt;
                                                                        var TotalSchoolAmountBefore : LongInt;
                                                                        var TotalMunicipalAmountBefore : LongInt;
                                                                        var TotalCountyAmountAfter : LongInt;
                                                                        var TotalSchoolAmountAfter : LongInt;
                                                                        var TotalMunicipalAmountAfter : LongInt);

var
  I, HeaderTransactionNumber, StartIndex, EndIndex,
  CountyAmountBefore, MunicipalAmountBefore, SchoolAmountBefore,
  CountyAmountAfter, MunicipalAmountAfter, SchoolAmountAfter : LongInt;
  HeaderPrinted, AfterFound, BeforeFound : Boolean;

begin
  CountyAmountBefore := 0;
  MunicipalAmountBefore := 0;
  SchoolAmountBefore := 0;
  CountyAmountAfter := 0;
  MunicipalAmountAfter := 0;
  SchoolAmountAfter := 0;
  StartIndex := 999999;
  EndIndex := 0;

  HeaderTransactionNumber := ExemptionChangeHeaderPointer(ExemptionChangeHeaderList[Index])^.TransactionNumber;

  For I := 0 to (ExemptionChangeDetailList.Count - 1) do
    with ExemptionChangeDetailPointer(ExemptionChangeDetailList[I])^ do
      If _Compare(HeaderTransactionNumber, TransactionNumber, coEqual)
        then
          begin
            StartIndex := Min(I, StartIndex);
            EndIndex := Max(I, EndIndex);

            If BeforeTransaction
              then
                begin
                  Inc(CountyAmountBefore, CountyAmount);
                  Inc(MunicipalAmountBefore, MunicipalAmount);
                  Inc(SchoolAmountBefore, SchoolAmount);
                end
              else
                begin
                  Inc(CountyAmountAfter, CountyAmount);
                  Inc(MunicipalAmountAfter, MunicipalAmount);
                  Inc(SchoolAmountAfter, SchoolAmount);
                end;  {else of If BeforeTransaction}

          end;  {If _Compare(HeaderTransactionNumber, TransactionNumber, coEqual)}

    {Now, only print it if there was actually a change.}

  If (_Compare(CountyAmountBefore, CountyAmountAfter, coNotEqual) or
      _Compare(MunicipalAmountBefore, MunicipalAmountAfter, coNotEqual) or
      _Compare(SchoolAmountBefore, SchoolAmountAfter, coNotEqual))
    then
      with Sender as TBaseReport do
        begin
          Inc(NumPrinted);

          Println('');

          with ExemptionChangeHeaderPointer(ExemptionChangeHeaderList[Index])^ do
            begin
              Bold := True;
              Println(#9 + ConstStr('_', 100));
              Println(#9 + ConvertSBLOnlyToDashDot(Copy(SwisSBLKey, 7, 20)) +
                      #9 + DateToStr(Date) +
                      #9 + FormatDateTime(TimeFormat, Time) +
                      #9 + User +
                      #9 + AssessmentYear);

              If ExtractToExcel
                then WritelnCommaDelimitedLine(ExtractFile,
                                               [ConvertSwisSBLToDashDot(SwisSBLKey),
                                                DateToStr(Date),
                                                FormatDateTime(TimeFormat, Time),
                                                User,
                                                AssessmentYear]);

              Bold := False;

              If (CreateParcelList and
                  (not ParcelListDialog.ParcelExistsInList(SwisSBLKey)))
                then ParcelListDialog.AddOneParcel(SwisSBLKey);

            end;  {with ExemptionChangeHeaderPointer(ExemptionChangeHeaderList[Index])^ do}

            {Print the first before lines.}

          I := StartIndex;
          BeforeFound := False;
          AfterFound := False;
          HeaderPrinted := False;

          while (_Compare(I, EndIndex, coLessThanOrEqual) and
                 (not AfterFound)) do
            with ExemptionChangeDetailPointer(ExemptionChangeDetailList[I])^ do
              begin
                If BeforeTransaction
                  then BeforeFound := True
                  else AfterFound := True;

                If not AfterFound
                  then
                    begin
                      PrintOneExemptionChangeLine(Sender,
                                                  HeaderPrinted,
                                                  True,
                                                  ExemptionChangeDetailPointer(ExemptionChangeDetailList[I])^,
                                                  ExtractFile,
                                                  ExtractToExcel);

                      HeaderPrinted := True;

                    end;  {If not AfterFound}

                Inc(I);

              end;  {with ExemptionChangeDetailPointer(ExemptionChangeDetailList[I])^ do}

          If not BeforeFound
            then
              begin
                Bold := True;
                Print(#9 + #9 + 'Before:');
                Bold := False;
                Println(#9 + 'None.');

                If ExtractToExcel
                  then WritelnCommaDelimitedLine(ExtractFile,
                                                 ['', '', '', '', '',
                                                  'Before',
                                                  'None']);

              end;  {If not BeforeFound}

            {Now do the after transactions.}

          I := EndIndex;
          BeforeFound := False;
          AfterFound := False;
          HeaderPrinted := False;

          while (_Compare(I, StartIndex, coGreaterThanOrEqual) and
                 (not BeforeFound)) do
            with ExemptionChangeDetailPointer(ExemptionChangeDetailList[I])^ do
              begin
                If BeforeTransaction
                  then BeforeFound := True
                  else AfterFound := True;

                If not BeforeFound
                  then
                    begin
                      PrintOneExemptionChangeLine(Sender,
                                                  HeaderPrinted,
                                                  False,
                                                  ExemptionChangeDetailPointer(ExemptionChangeDetailList[I])^,
                                                  ExtractFile,
                                                  ExtractToExcel);

                      HeaderPrinted := True;

                    end;  {If not AfterFound}

                Dec(I);

              end;  {with ExemptionChangeDetailPointer(ExemptionChangeDetailList[I])^ do}

          If not AfterFound
            then
              begin
                Bold := True;
                Print(#9 + #9 + 'After:');
                Bold := False;
                Println(#9 + 'None.');

                If ExtractToExcel
                  then WritelnCommaDelimitedLine(ExtractFile,
                                                 ['', '', '', '', '',
                                                  'After',
                                                  'None']);

              end;  {If not AfterFound}

          Println('');
          PrintExemptionTotals(Sender, CountyAmountBefore,
                               MunicipalAmountBefore, SchoolAmountBefore,
                               CountyAmountAfter, MunicipalAmountAfter,
                               SchoolAmountAfter, TotalCountyAmountBefore,
                               TotalSchoolAmountBefore, TotalMunicipalAmountBefore,
                               TotalCountyAmountAfter, TotalSchoolAmountAfter,
                               TotalMunicipalAmountAfter);

          If ExtractToExcel
            then WritelnCommaDelimitedLine(ExtractFile, []);

        end;  {with Sender as TBaseReport do}

end;  {PrintOneExemptionTransaction}

{====================================================================}
Procedure TAssessorsTrialBalanceReportForm.PrintExemptionSection(     Sender : TObject;
                                                                      AuditEXChangeTable : TTable;
                                                                  var GrandTotalCountyTaxableChange,
                                                                      GrandTotalTownTaxableChange,
                                                                      GrandTotalSchoolTaxableChange : LongInt);

var
  Done, FirstTimeThrough : Boolean;
  _SwisSBLKey, LastSwisSBLKey,
  LastAssessmentYear, LastUser : String;
  _TransactionNumber, _DetailNumber, NumPrinted, I,
  TotalBeforeCountyAmount, TotalBeforeSchoolAmount,
  TotalBeforeTownAmount, TotalAfterCountyAmount,
  TotalAfterSchoolAmount, TotalAfterTownAmount : LongInt;
  ExemptionChangeHeaderList, ExemptionChangeDetailList : TList;
  ExemptionChangeHeaderPtr : ExemptionChangeHeaderPointer;
  ExemptionChangeDetailPtr : ExemptionChangeDetailPointer;
  LastDate : TDateTime;

begin
  ExemptionChangeHeaderList := TList.Create;
  ExemptionChangeDetailList := TList.Create;

    {FXX05262009-1(2.17.1.21)[D1540]: Extend the Excel extract to all sections.}

  If ExtractToExcel
    then WritelnCommaDelimitedLine(ExtractFile,
                                   ['Parcel ID',
                                    'Date',
                                    'Time',
                                    'User',
                                    'Year',
                                    'Sequence',
                                    'EX Code',
                                    'County Amt',
                                    GetMunicipalityTypeName(GlblMunicipalityType) + ' Amt',
                                    'School Amt']);

    {If they are searching by date range and have specified a range, then don't
     do a get first - we already did a FindNearest.}

  If ((IndexRadioGroup.ItemIndex in [0, 2]) or
      AllDatesCheckBox.Checked)
    then AuditEXChangeTable.First;

  Done := False;
  FirstTimeThrough := True;
  ReportSection := 'E';

  with Sender as TBaseReport do
    If (LinesLeft < 10)
      then NewPage
      else SetupExemptionSection(Sender, True);

  LastSwisSBLKey := '';
  LastAssessmentYear := '';
  LastUser := '';
  LastDate := StrToDate('1/1/1990');

  TotalBeforeCountyAmount := 0;
  TotalBeforeSchoolAmount := 0;
  TotalBeforeTownAmount := 0;
  TotalAfterCountyAmount := 0;
  TotalAfterSchoolAmount := 0;
  TotalAfterTownAmount := 0;

  _TransactionNumber := 0;
  _DetailNumber := 0;
  NumPrinted := 0;

  with Sender as TBaseReport, AuditEXChangeTable do
    begin
        {First assemble any possible changes.}

      repeat
        If FirstTimeThrough
          then FirstTimeThrough := False
          else Next;

        If (EOF or
            ((IndexRadioGroup.ItemIndex = 1) and
             (not AllDatesCheckBox.Checked) and
             (not ToEndofDatesCheckBox.Checked) and
             (FieldByName('Date').AsDateTime > StrToDate(EndDateEdit.Text))))
          then Done := True;

          {Print the present record.}

        If not Done
          then
            begin
              _SwisSBLKey := FieldByName('SwisSBLKey').Text;

              case IndexRadioGroup.ItemIndex of
                0 : ProgressDialog.Update(Self, ConvertSwisSBLToDashDot(_SwisSBLKey));
                1 : ProgressDialog.Update(Self, FieldByName('Date').Text);
                2 : ProgressDialog.Update(Self, FieldByName('User').Text);

              end;  {case IndexRadioGroup.ItemIndex of}

              _Locate(ParcelTable, [GetTaxRlYr, _SwisSBLKey], '', [loParseSwisSBLKey]);

              If (RecordInRange(FieldByName('Date').AsDateTime,
                                FieldByName('SwisSBLKey').Text,
                                ParcelTable.FieldByName('SchoolCode').Text,
                                FieldByName('User').Text,
                                FieldByName('TaxRollYr').Text) and
                  RecordInEX_SDRange('E'))
                then
                  begin
                      {FXX07022007-1(2.11.1.45)[D882]: Need to break on user and date, too.}

                    If (_Compare(_SwisSBLKey, LastSwisSBLKey, coNotEqual) or
                        _Compare(FieldByName('TaxRollYr').Text, LastAssessmentYear, coNotEqual) or
                        _Compare(FieldByName('User').AsString, LastUser, coNotEqual) or
                        _Compare(FieldByName('Date').AsDateTime, LastDate, coNotEqual) or
                        _Compare(_TransactionNumber, 0, coEqual))
                      then
                        begin
                          Inc(_TransactionNumber);
                          New(ExemptionChangeHeaderPtr);

                          with ExemptionChangeHeaderPtr^ do
                            begin
                              TransactionNumber := _TransactionNumber;
                              SwisSBLKey := _SwisSBLKey;
                              Date := FieldByName('Date').AsDateTime;
                              Time := FieldByName('Time').AsDateTime;
                              User := FieldByName('User').AsString;
                              AssessmentYear := FieldByName('TaxRollYr').AsString;

                            end;  {with ExemptionChangeHeaderPtr^ do}

                          ExemptionChangeHeaderList.Add(ExemptionChangeHeaderPtr);
                          _DetailNumber := 0;

                        end;  {If (_Compare(_SwisSBLKey, LastSwisSBLKey, ...}

                    New(ExemptionChangeDetailPtr);
                    Inc(_DetailNumber);

                    with ExemptionChangeDetailPtr^ do
                      begin
                        TransactionNumber := _TransactionNumber;
                        DetailNumber := _DetailNumber;
                        ExemptionCode := FieldByName('ExemptionCode').AsString;
                        CountyAmount := FieldByName('CountyAmount').AsInteger;
                        MunicipalAmount := FieldByName('TownAmount').AsInteger;
                        SchoolAmount := FieldByName('SchoolAmount').AsInteger;
                        VillageAmount := FieldByName('VillageAmount').AsInteger;
                        Percent := FieldByName('Percent').AsFloat;
                        OwnerPercent := FieldByName('OwnerPercent').AsFloat;
                        InitialDate := FieldByName('InitialDate').AsDateTime;
                        TerminationDate := FieldByName('TerminationDate').AsDateTime;
                        BeforeTransaction := _Compare(FieldByName('BeforeOrAfter').AsString, 'B', coEqual);

                      end;  {with ExemptionChangeDetailPtr^ do}

                    ExemptionChangeDetailList.Add(ExemptionChangeDetailPtr);

                    LastSwisSBLKey := _SwisSBLKey;
                    LastAssessmentYear := FieldByName('TaxRollYr').Text;
                    LastDate := FieldByName('Date').AsDateTime;
                    LastUser := FieldByName('User').AsString;
                    
                  end;  {If (RecordInRange(FieldByName('Date').AsDateTime, ...}

            end;  {If not Done}

        ReportCancelled := ProgressDialog.Cancelled;

      until (Done or ReportCancelled);

        {Now print the changes.}

      For I := 0 to (ExemptionChangeHeaderList.Count - 1) do
        PrintOneExemptionTransaction(Sender,
                                     ExemptionChangeHeaderList,
                                     ExemptionChangeDetailList,
                                     I, NumPrinted,
                                     TotalBeforeCountyAmount,
                                     TotalBeforeSchoolAmount,
                                     TotalBeforeTownAmount,
                                     TotalAfterCountyAmount,
                                     TotalAfterSchoolAmount,
                                     TotalAfterTownAmount);

        {Print the grand totals.}
        {Note that we are showing taxable value change, so this will be
         the inverse of the exemption amount.}

      PrintSectionChangeTotals(Sender, 0,
                               -1 *(TotalAfterCountyAmount -
                                TotalBeforeCountyAmount),
                               -1 * (TotalAfterTownAmount -
                                TotalBeforeTownAmount),
                               -1 * (TotalAfterSchoolAmount -
                                TotalBeforeSchoolAmount));

        {Note that positive total exemption changes will reduce taxable
         value and vice versa.}

      GrandTotalCountyTaxableChange := -1 * (TotalAfterCountyAmount - TotalBeforeCountyAmount);
      GrandTotalTownTaxableChange := -1 * (TotalAfterTownAmount - TotalBeforeTownAmount);
      GrandTotalSchoolTaxableChange := -1 * (TotalAfterSchoolAmount - TotalBeforeSchoolAmount);

        {FXX01231998-5: Tell them if nothing in range.}

      If _Compare(NumPrinted, 0, coEqual)
        then Println('None.');

      Println('');

    end;  {with Sender as TBaseReport do}

  FreeTList(ExemptionChangeHeaderList, SizeOf(ExemptionChangeHeaderRecord));
  FreeTList(ExemptionChangeDetailList, SizeOf(ExemptionChangeDetailRecord));

end;  {PrintExemptionSection}

{====================================================================}
Procedure TAssessorsTrialBalanceReportForm.PrintSpecialDistrictSection(Sender : TObject;
                                                         AuditSDChangeTable : TTable;
                                                         SectionType : String;
                                                         RecordType : Char);

{Print either the SD adds or deletes.}
{CHG03161998-1: Track exemption, SD adds, av changes, parcel add/del.}

var
  Done, Quit, FirstTimeThrough : Boolean;
  NumChanged : Integer;
  SwisSBLKey : String;
  SBLRec : SBLRecord;
  TempDate : TDateTime;

begin
  with AuditSDChangeTable do
    case IndexRadioGroup.ItemIndex of
      0 : begin  {SBL}
            IndexName := 'BYSWISSBLKEY_DATE_TIME';

            If not AllSBLCheckBox.Checked
              then SetRangeOld(AuditSDChangeTable,
                               ['SwisSBLKey', 'Date', 'Time'],
                               [StartingSwisSBL, '1/1/1850', ''],
                               [EndingSwisSBL, '1/1/3000', '']);

          end;   {SBL}

      1 : begin  {Date }
            IndexName := 'BYDATE_TIME_SWISSBLKEY';

              {Set a range if they specified a range.}
              {FXX01132000-1: Don't put an end range if they want to end of range.}

            If not AllDatesCheckBox.Checked
              then FindNearestOld(AuditSDChangeTable,
                                  ['Date', 'Time', 'SwisSBLKey'],
                                  [StartDateEdit.Text, '', '']);

          end;   {Date }

      2 : begin  {User}
            IndexName := 'BYUSER_DATE_TIME';

              {Set a range if they specified a range.}

            If not AllUsersCheckBox.Checked
              then
                If ToEndofDatesCheckBox.Checked
                  then SetRangeOld(AuditSDChangeTable,
                                   ['User', 'Date', 'Time'],
                                   [StartUserEdit.Text, '', ''],
                                   [ConstStr('Z', 10), '', ''])
                  else SetRangeOld(AuditSDChangeTable,
                                   ['User', 'Date', 'Time'],
                                   [StartUserEdit.Text, '1/1/1850', ''],
                                   [EndUserEdit.Text, '1/1/3000', '']);

          end; {User}

    end;  {case IndexRadioGroup of}

    {If they are searching by date range and have specified a range, then don't
     do a get first - we already did a FindNearest.}

  If ((IndexRadioGroup.ItemIndex in [0, 2]) or
      AllDatesCheckBox.Checked)
    then AuditSDChangeTable.First;

  Done := False;
  FirstTimeThrough := True;
  Quit := False;
  ReportSection := SectionType;
  NumChanged := 0;

  with Sender as TBaseReport do
    If (LinesLeft < 10)
      then NewPage
      else SetupSpecialDistrictSection(Sender, RecordType, True);

  with Sender as TBaseReport do
    begin
        {First print the individual changes.}

      repeat
        If FirstTimeThrough
          then FirstTimeThrough := False
          else AuditSDChangeTable.Next;

        TempDate := AuditSDChangeTable.FieldByName('Date').AsDateTime;

        If (AuditSDChangeTable.EOF or
            ((IndexRadioGroup.ItemIndex = 1) and
             (not AllDatesCheckBox.Checked) and
             (not ToEndofDatesCheckBox.Checked) and
             (TempDate > StrToDate(EndDateEdit.Text))))
          then Done := True;

          {Print the present record.}

        If not (Done or Quit)
          then
            begin
              {Update the progress panel.}

              with AuditSDChangeTable do
                case IndexRadioGroup.ItemIndex of
                  0 : ProgressDialog.Update(Self,
                                            ConvertSwisSBLToDashDot(FieldByName('SwisSBLKey').Text));
                  1 : ProgressDialog.Update(Self, FieldByName('Date').Text);
                  2 : ProgressDialog.Update(Self, FieldByName('User').Text);

                end;  {case IndexRadioGroup.ItemIndex of}

                {CHG01211998-3: Allow tracking of EX, SD deletions.}
                {CHG11151999-2: Allow selection of EX, SD codes.}

              SBLRec := ExtractSwisSBLFromSwisSBLKey(AuditSDChangeTable.FieldByName('SwisSBLKey').Text);

              with SBLRec do
                FindKeyOld(ParcelTable,
                           ['TaxRollYr', 'SwisCode', 'Section',
                            'Subsection', 'Block', 'Lot', 'Sublot',
                            'Suffix'],
                           [GetTaxRlYr, SwisCode, Section, Subsection,
                            Block, Lot, Sublot, Suffix]);

              with AuditSDChangeTable do
                If (RecordInRange(FieldByName('Date').AsDateTime,
                                  FieldByName('SwisSBLKey').Text,
                                  ParcelTable.FieldByName('SchoolCode').Text,
                                  FieldByName('User').Text,
                                  FieldByName('TaxRollYr').Text) and
                    (FieldByName('RecordType').Text = RecordType) and
                    RecordInEX_SDRange('S'))
                  then
                    begin
                        {CHG11151999-3: Add create parcel list to audits, ex letters.}

                      SwisSBLKey := FieldByName('SwisSBLKey').Text;
                      If (CreateParcelList and
                          (not ParcelListDialog.ParcelExistsInList(SwisSBLKey)))
                        then ParcelListDialog.AddOneParcel(SwisSBLKey);

                      NumChanged := NumChanged + 1;
                      Print(#9 + ConvertSwisSBLToDashDot(FieldByName('SwisSBLKey').Text) +
                            #9 + FieldByName('Date').Text +
                            #9 + FormatDateTime(TimeFormat, FieldByName('Time').AsDateTime) +
                            #9 + FieldByName('User').Text +
                            #9 + Copy(FieldByName('TaxRollYr').Text, 3, 2) +
                            #9 + FieldByName('SDistCode').Text);

                      If (RecordType in ['D', 'C'])
                        then Println(#9 + FormatFloat(DecimalDisplay_BlankZero,
                                                      FieldByName('OldPrimaryUnits').AsFloat) +
                                     #9 + FormatFloat(DecimalDisplay_BlankZero,
                                                      FieldByName('OldSecondaryUnits').AsFloat) +
                                     #9 + FormatFloat(DecimalDisplay_BlankZero,
                                                      FieldByName('OldCalcAmount').AsFloat) +
                                     #9 + FormatFloat(NoDecimalDisplay_BlankZero,
                                                      FieldByName('OldSDPercentage').AsFloat))
                        else Println(#9 + FormatFloat(DecimalDisplay_BlankZero,
                                                      FieldByName('NewPrimaryUnits').AsFloat) +
                                     #9 + FormatFloat(DecimalDisplay_BlankZero,
                                                      FieldByName('NewSecondaryUnits').AsFloat) +
                                     #9 + FormatFloat(DecimalDisplay_BlankZero,
                                                      FieldByName('NewCalcAmount').AsFloat) +
                                     #9 + FormatFloat(NoDecimalDisplay_BlankZero,
                                                      FieldByName('NewSDPercentage').AsFloat));

                        {CHG03231998-1: Show EX and SD changes.}
                        {Note that we only show info that has changed.}

                      If (RecordType = 'C')
                        then
                          begin
                            Print(#9 + '   Values changed:' +
                                  #9 + #9 + #9 + #9 + #9);

                            If (FieldByName('NewPrimaryUnits').AsFloat <>
                                FieldByName('OldPrimaryUnits').AsFloat)
                              then Print(#9 + FormatFloat(DecimalDisplay_BlankZero,
                                                          FieldByName('NewPrimaryUnits').AsFloat))
                              else Print(#9);

                            If (FieldByName('NewSecondaryUnits').AsFloat <>
                                FieldByName('OldSecondaryUnits').AsFloat)
                              then Print(#9 + FormatFloat(DecimalDisplay_BlankZero,
                                                          FieldByName('NewSecondaryUnits').AsFloat))
                              else Print(#9);

                            If (FieldByName('NewCalcAmount').AsFloat <>
                                FieldByName('OldCalcAmount').AsFloat)
                              then Print(#9 + FormatFloat(DecimalDisplay_BlankZero,
                                                          FieldByName('NewCalcAmount').AsFloat))
                              else Print(#9);

                            If (FieldByName('NewSDPercentage').AsFloat <>
                                FieldByName('OldSDPercentage').AsFloat)
                              then Print(#9 + FormatFloat(DecimalDisplay_BlankZero,
                                                          FieldByName('NewSDPercentage').AsFloat))
                              else Print(#9);

                            Println('');
                            Println('');

                          end;  {If (RecordType = 'C')}

                    end;  {with AuditSDChangeTable do}

                {If there is only one line left to print, then we
                 want to go to the next page.}

              If (LinesLeft < 3)
                then NewPage;

            end;  {If not (Done or Quit)}

        ReportCancelled := ProgressDialog.Cancelled;

      until (Done or Quit or ReportCancelled);

        {FXX01231998-5: Tell them if nothing in range.}

      If (NumChanged = 0)
        then Println('None.');

      Println('');

    end;  {with Sender as TBaseReport do}

end;  {PrintSpecialDistrictSection}

{====================================================================}
Procedure TAssessorsTrialBalanceReportForm.PrintAVChangeSection(    Sender : TObject;
                                                                    AuditAVChangeTable : TTable;
                                                                var GrandTotalAVChange,
                                                                    GrandTotalCountyTaxableChange,
                                                                    GrandTotalTownTaxableChange,
                                                                    GrandTotalSchoolTaxableChange : LongInt);

{Print either the assessed value changes.}
{CHG03161998-1: Track exemption, SD adds, av changes, parcel add/del.}

var
  Done, Quit, FirstTimeThrough : Boolean;
  NumChanged : Integer;
  AVChange, CountyTVChange,
  SchoolTVChange, TownTVChange,
  TotalAVChange, TotalCountyTVChange,
  TotalSchoolTVChange, TotalTownTVChange : LongInt;
  SwisSBLKey : String;
  SBLRec : SBLRecord;
  TempDate : TDateTime;

begin
    {FXX05262009-1(2.17.1.21)[D1540]: Extend the Excel extract to all sections.}

  If ExtractToExcel
    then WritelnCommaDelimitedLine(ExtractFile,
                                   ['Parcel ID',
                                    'Date',
                                    'Time',
                                    'User',
                                    'Year',
                                    'Old AV',
                                    'New AV',
                                    'AV Change']);

    {If they are searching by date range and have specified a range, then don't
     do a get first - we already did a FindNearest.}

  If ((IndexRadioGroup.ItemIndex in [0, 2]) or
      AllDatesCheckBox.Checked)
    then AuditAVChangeTable.First;

  Done := False;
  FirstTimeThrough := True;
  Quit := False;
  ReportSection := 'AV';
  NumChanged := 0;
  TotalAVChange := 0;
  TotalCountyTVChange := 0;
  TotalSchoolTVChange := 0;
  TotalTownTVChange := 0;

  with Sender as TBaseReport do
    If (LinesLeft < 12)
      then NewPage
      else SetupAVChangeSection(Sender, True, SuppressTaxableValueInAVSection);

  with Sender as TBaseReport do
    begin
        {First print the individual changes.}

      repeat
        If FirstTimeThrough
          then FirstTimeThrough := False
          else AuditAVChangeTable.Next;

        TempDate := AuditAVChangeTable.FieldByName('Date').AsDateTime;

        If (AuditAVChangeTable.EOF or
            ((IndexRadioGroup.ItemIndex = 1) and
             (not AllDatesCheckBox.Checked) and
             (not ToEndofDatesCheckBox.Checked) and
             (TempDate > StrToDate(EndDateEdit.Text))))
          then Done := True;

          {Print the present record.}

        If not (Done or Quit)
          then
            begin
              {Update the progress panel.}

              with AuditAVChangeTable do
                case IndexRadioGroup.ItemIndex of
                  0 : ProgressDialog.Update(Self,
                                            ConvertSwisSBLToDashDot(FieldByName('SwisSBLKey').Text));
                  1 : ProgressDialog.Update(Self, FieldByName('Date').Text);
                  2 : ProgressDialog.Update(Self, FieldByName('User').Text);

                end;  {case IndexRadioGroup.ItemIndex of}

              SBLRec := ExtractSwisSBLFromSwisSBLKey(AuditAVChangeTable.FieldByName('SwisSBLKey').Text);

              with SBLRec do
                FindKeyOld(ParcelTable,
                           ['TaxRollYr', 'SwisCode', 'Section',
                            'Subsection', 'Block', 'Lot', 'Sublot',
                            'Suffix'],
                           [GetTaxRlYr, SwisCode, Section, Subsection,
                            Block, Lot, Sublot, Suffix]);

              with AuditAVChangeTable do
                If RecordInRange(FieldByName('Date').AsDateTime,
                                 FieldByName('SwisSBLKey').Text,
                                 ParcelTable.FieldByName('SchoolCode').Text,
                                 FieldByName('User').Text,
                                 FieldByName('TaxRollYr').Text)
                  then
                    begin
                        {CHG11151999-3: Add create parcel list to audits, ex letters.}

                      SwisSBLKey := FieldByName('SwisSBLKey').Text;
                      If (CreateParcelList and
                          (not ParcelListDialog.ParcelExistsInList(SwisSBLKey)))
                        then ParcelListDialog.AddOneParcel(SwisSBLKey);

                      NumChanged := NumChanged + 1;
                      AVChange := FieldByName('NewAssessedValue').AsInteger -
                                  FieldByName('OldAssessedValue').AsInteger;
                      CountyTVChange := FieldByName('NewCountyTaxableVal').AsInteger -
                                        FieldByName('OldCountyTaxableVal').AsInteger;
                      TownTVChange := FieldByName('NewTownTaxableVal').AsInteger -
                                        FieldByName('OldTownTaxableVal').AsInteger;
                      SchoolTVChange := FieldByName('NewSchlTaxableVal').AsInteger -
                                        FieldByName('OldSchlTaxableVal').AsInteger;

                      Println(#9 + ConvertSwisSBLToDashDot(FieldByName('SwisSBLKey').Text) +
                              #9 + FieldByName('Date').Text +
                              #9 + FormatDateTime(TimeFormat, FieldByName('Time').AsDateTime) +
                              #9 + FieldByName('User').Text +
                              #9 + Copy(FieldByName('TaxRollYr').Text, 3, 2) +
                              #9 + FormatFloat(CurrencyNormalDisplay_BlankZero,
                                               FieldByName('OldAssessedValue').AsFloat) +
                              #9 + FormatFloat(CurrencyNormalDisplay_BlankZero,
                                               FieldByName('NewAssessedValue').AsFloat) +
                              #9 + FormatFloat(CurrencyNormalDisplay_BlankZero,
                                               AVChange));

                        {FXX12092009-1(MDT)[I]: The extract of AV changes was only showing AV increases.}

                      If (ExtractToExcel and
                          _Compare(AVChange, 0, coNotEqual))
                        then WritelnCommaDelimitedLine(ExtractFile,
                                                       [ConvertSwisSBLToDashDot(FieldByName('SwisSBLKey').AsString),
                                                        FieldByName('Date').AsString,
                                                        FormatDateTime(TimeFormat, FieldByName('Time').AsDateTime),
                                                        FieldByName('User').AsString,
                                                        FieldByName('TaxRollYr').AsString,
                                                        FieldByName('OldAssessedValue').AsInteger,
                                                        FieldByName('NewAssessedValue').AsInteger,
                                                        AVChange]);

                        {CHG01192004-1(2.08): Let each municipality decide what roll totals to display.}
                        {FXX04302004-2(2.07l3): It should print these amounts if they are not 0, not if
                                                they are only greater than 0.}
                        {CHG10152004-2(2.8.0.14): Add option to suppress the taxable value in the AV change section.}

                      If ((not SuppressTaxableValueInAVSection) and
                          ((Roundoff(CountyTVChange, 0) <> 0) or
                           (Roundoff(TownTVChange, 0) <> 0) or
                           (Roundoff(SchoolTVChange, 0) <> 0)))
                        then
                          begin
                            Print(#9 + #9 + #9 + #9 + #9);

                            If (rtdCounty in GlblRollTotalsToShow)
                              then Print(#9 + FormatFloat(CurrencyNormalDisplay_BlankZero,
                                                          CountyTVChange))
                              else Print(#9);

                            If (rtdMunicipal in GlblRollTotalsToShow)
                              then Print(#9 + FormatFloat(CurrencyNormalDisplay_BlankZero,
                                                          TownTVChange))
                              else Print(#9);

                            If (rtdSchool in GlblRollTotalsToShow)
                              then Println(#9 + FormatFloat(CurrencyNormalDisplay_BlankZero,
                                                            SchoolTVChange))
                              else Println('');

                          end;  {If ((Roundoff(CountyTVChange, 0) > 0) or ...}

                      TotalAVChange := TotalAVChange + AVChange;
                      TotalCountyTVChange := TotalCountyTVChange + CountyTVChange;
                      TotalSchoolTVChange := TotalSchoolTVChange + SchoolTVChange;
                      TotalTownTVChange := TotalTownTVChange + TownTVChange;

                    end;  {with AuditAVChangeTable do}

                {If there is only one line left to print, then we
                 want to go to the next page.}

              If (LinesLeft < 3)
                then NewPage;

            end;  {If not (Done or Quit)}

        ReportCancelled := ProgressDialog.Cancelled;

      until (Done or Quit or ReportCancelled);

        {FXX01231998-5: Tell them if nothing in range.}

      If (NumChanged = 0)
        then Println('None.')
        else PrintSectionChangeTotals(Sender, TotalAVChange,
                                      TotalCountyTVChange,
                                      TotalTownTVChange,
                                      TotalSchoolTVChange);

      Println('');

    end;  {with Sender as TBaseReport do}

    {Update the overall changes.}

  GrandTotalAVChange := GrandTotalAVChange + TotalAVChange;
  GrandTotalCountyTaxableChange := GrandTotalCountyTaxableChange + TotalCountyTVChange;
  GrandTotalTownTaxableChange := GrandTotalTownTaxableChange + TotalTownTVChange;
  GrandTotalSchoolTaxableChange := GrandTotalSchoolTaxableChange + TotalSchoolTVChange;

end;  {PrintAVChangeSection}

{=====================================================================}
Procedure PrintParcelChangeLine(Sender : TObject;
                                AuditParcelChangeTable : TTable;
                                ResPercent : Real;
                                AssessedVal,
                                CountyTaxableVal,
                                TownTaxableVal,
                                SchoolTaxableVal : LongInt;
                                RollSection,
                                HomesteadCode : String;
                                SchoolCode : String;
                                TempStr : String);

{Print one parcel.}

begin
  with Sender as TBaseReport, AuditParcelChangeTable do
    begin
      Println(#9 + ConvertSwisSBLToDashDot(FieldByName('SwisSBLKey').Text) +
              #9 + FieldByName('Date').Text +
              #9 + FormatDateTime(TimeFormat, FieldByName('Time').AsDateTime) +
              #9 + FieldByName('User').Text +
              #9 + Copy(FieldByName('TaxRollYr').Text, 3, 2) +
              #9 + FormatFloat(CurrencyNormalDisplay_BlankZero,
                               AssessedVal) +
              #9 + FormatFloat(CurrencyNormalDisplay_BlankZero,
                               ResPercent) +
              #9 + FieldByName('SplitMergeNo').Text);

      Print(#9 + #9 + TempStr +
            #9 + HomesteadCode +
            #9 + SchoolCode +
            #9 + RollSection);

        {CHG01192004-1(2.08): Let each municipality decide what roll totals to display.}

      If (rtdCounty in GlblRollTotalsToShow)
        then Print(#9 + FormatFloat(CurrencyNormalDisplay_BlankZero,
                                    CountyTaxableVal))
        else Print('');

      If (rtdMunicipal in GlblRollTotalsToShow)
        then Print(#9 + FormatFloat(CurrencyNormalDisplay_BlankZero,
                                    TownTaxableVal))
        else Print('');

     If (rtdSchool in GlblRollTotalsToShow)
       then Println(#9 + FormatFloat(CurrencyNormalDisplay_BlankZero,
                                     SchoolTaxableVal))
       else Println('');

    end;  {with Sender as TBaseReport do}

end;  {PrintParcelChangeLine}

{====================================================================}
Procedure TAssessorsTrialBalanceReportForm.PrintParcelChangeSection(    Sender : TObject;
                                                          AuditParcelChangeTable : TTable;
                                                          RecordType : Char;
                                                      var GrandTotalAVChange,
                                                          GrandTotalCountyTaxableChange,
                                                          GrandTotalTownTaxableChange,
                                                          GrandTotalSchoolTaxableChange : LongInt);

{Print either the parcel adds or deletes.}
{CHG03161998-1: Track exemption, SD adds, av changes, parcel add/del.}

var
  Done, Quit, FirstTimeThrough : Boolean;
  NumChanged, Multiplier : Integer;
  ResPercent : Real;
  AssessedVal, CountyTaxableVal,
  TownTaxableVal, SchoolTaxableVal,
  TotalAVChange, TotalCountyTaxableChange,
  TotalTownTaxableChange, TotalSchoolTaxableChange : LongInt;
  RollSection, HomesteadCode, SchoolCode,
  TempStr, SwisSBLKey : String;
  SBLRec : SBLRecord;
  TempDate : TDateTime;

begin
  with AuditParcelChangeTable do
    case IndexRadioGroup.ItemIndex of
      0 : begin  {SBL}
            IndexName := 'BYSWISSBLKEY_DATE_TIME';

            If not AllSBLCheckBox.Checked
              then SetRangeOld(AuditParcelChangeTable,
                               ['SwisSBLKey', 'Date', 'Time'],
                               [StartingSwisSBL, '1/1/1850', ''],
                               [EndingSwisSBL, '1/1/3000', '']);

          end;   {SBL}

      1 : begin  {Date }
            IndexName := 'BYDATE_TIME_SWISSBLKEY';

              {Set a range if they specified a range.}
              {FXX01132000-1: Don't put an end range if they want to end of range.}

            If not AllDatesCheckBox.Checked
              then FindNearestOld(AuditParcelChangeTable,
                                  ['Date', 'Time', 'SwisSBLKey'],
                                  [StartDateEdit.Text, '', '']);

          end;   {Date }

      2 : begin  {User}
            IndexName := 'BYUSER_DATE_TIME';

              {Set a range if they specified a range.}

            If not AllUsersCheckBox.Checked
              then
                If ToEndofDatesCheckBox.Checked
                  then SetRangeOld(AuditParcelChangeTable,
                                   ['User', 'Date', 'Time'],
                                   [StartUserEdit.Text, '', ''],
                                   [ConstStr('Z', 10), '', ''])
                  else SetRangeOld(AuditParcelChangeTable,
                                   ['User', 'Date', 'Time'],
                                   [StartUserEdit.Text, '1/1/1850', ''],
                                   [EndUserEdit.Text, '1/1/3000', '']);

          end; {User}

    end;  {case IndexRadioGroup of}

    {If they are searching by date range and have specified a range, then don't
     do a get first - we already did a FindNearest.}

  If ((IndexRadioGroup.ItemIndex in [0, 2]) or
      AllDatesCheckBox.Checked)
    then AuditParcelChangeTable.First;

  Done := False;
  FirstTimeThrough := True;
  Quit := False;
  NumChanged := 0;

  case RecordType of
    'A' : ReportSection := 'PA';
    'C' : ReportSection := 'PC';
    'D' : ReportSection := 'PD';
  end;  {case RecordType of}

  TotalAVChange := 0;
  TotalCountyTaxableChange := 0;
  TotalTownTaxableChange := 0;
  TotalSchoolTaxableChange := 0;

  with Sender as TBaseReport do
    If (LinesLeft < 10)
      then NewPage
      else SetupParcelChangeSection(Sender, RecordType, True);

  with Sender as TBaseReport do
    begin
        {First print the individual changes.}

      repeat
        If FirstTimeThrough
          then FirstTimeThrough := False
          else AuditParcelChangeTable.Next;

        TempDate := AuditParcelChangeTable.FieldByName('Date').AsDateTime;

        If (AuditParcelChangeTable.EOF or
            ((IndexRadioGroup.ItemIndex = 1) and
             (not AllDatesCheckBox.Checked) and
             (not ToEndofDatesCheckBox.Checked) and
             (TempDate > StrToDate(EndDateEdit.Text))))
          then Done := True;

          {Print the present record.}

        If not (Done or Quit)
          then
            begin
              {Update the progress panel.}

              with AuditParcelChangeTable do
                case IndexRadioGroup.ItemIndex of
                  0 : ProgressDialog.Update(Self,
                                            ConvertSwisSBLToDashDot(FieldByName('SwisSBLKey').Text));
                  1 : ProgressDialog.Update(Self, FieldByName('Date').Text);
                  2 : ProgressDialog.Update(Self, FieldByName('User').Text);

                end;  {case IndexRadioGroup.ItemIndex of}

                {CHG01211998-3: Allow tracking of EX, SD deletions.}

              SBLRec := ExtractSwisSBLFromSwisSBLKey(AuditParcelChangeTable.FieldByName('SwisSBLKey').Text);

              with SBLRec do
                FindKeyOld(ParcelTable,
                           ['TaxRollYr', 'SwisCode', 'Section',
                            'Subsection', 'Block', 'Lot', 'Sublot',
                            'Suffix'],
                           [GetTaxRlYr, SwisCode, Section, Subsection,
                            Block, Lot, Sublot, Suffix]);

              with AuditParcelChangeTable do
                If (RecordInRange(FieldByName('Date').AsDateTime,
                                  FieldByName('SwisSBLKey').Text,
                                  ParcelTable.FieldByName('SchoolCode').Text,
                                  FieldByName('User').Text,
                                  FieldByName('TaxRollYr').Text) and
                    (FieldByName('RecordType').Text = RecordType))
                  then
                    begin
                      NumChanged := NumChanged + 1;

                      If (RecordType in ['C', 'D'])
                        then
                          begin
                            ResPercent := FieldByName('OldResPercent').AsFloat;
                            AssessedVal := FieldByName('OldAssessedVal').AsInteger;
                            CountyTaxableVal := FieldByName('OldCountyTaxableVal').AsInteger;
                            TownTaxableVal := FieldByName('OldTownTaxableVal').AsInteger;
                            SchoolTaxableVal := FieldByName('OldSchlTaxableVal').AsInteger;
                            RollSection := FieldByName('OldRollSection').Text;
                            HomesteadCode := FieldByName('OldHstdCode').Text;
                            SchoolCode := FieldByName('OldSchoolCode').Text;
                          end
                        else
                          begin
                            ResPercent := FieldByName('NewResPercent').AsFloat;
                            AssessedVal := FieldByName('NewAssessedVal').AsInteger;
                            CountyTaxableVal := FieldByName('NewCountyTaxableVal').AsInteger;
                            TownTaxableVal := FieldByName('NewTownTaxableVal').AsInteger;
                            SchoolTaxableVal := FieldByName('NewSchlTaxableVal').AsInteger;
                            RollSection := FieldByName('NewRollSection').Text;
                            HomesteadCode := FieldByName('NewHstdCode').Text;
                            SchoolCode := FieldByName('NewSchoolCode').Text;

                          end;  {If (RecordType in ['C', 'D'])}

                      TempStr := '';

                      If (RecordType = 'C')
                        then TempStr := 'Before:';

                        {CHG11151999-3: Add create parcel list to audits, ex letters.}

                      SwisSBLKey := FieldByName('SwisSBLKey').Text;
                      If (CreateParcelList and
                          (not ParcelListDialog.ParcelExistsInList(SwisSBLKey)))
                        then ParcelListDialog.AddOneParcel(SwisSBLKey);

                      PrintParcelChangeLine(Sender, AuditParcelChangeTable,
                                            ResPercent, AssessedVal, CountyTaxableVal,
                                            TownTaxableVal, SchoolTaxableVal,
                                            RollSection, HomesteadCode, SchoolCode,
                                            TempStr);

                      If (RecordType = 'C')
                        then
                          begin
                            ResPercent := FieldByName('NewResPercent').AsFloat;
                            AssessedVal := FieldByName('NewAssessedVal').AsInteger;
                            CountyTaxableVal := FieldByName('NewCountyTaxableVal').AsInteger;
                            TownTaxableVal := FieldByName('NewTownTaxableVal').AsInteger;
                            SchoolTaxableVal := FieldByName('NewSchlTaxableVal').AsInteger;
                            RollSection := FieldByName('NewRollSection').Text;
                            HomesteadCode := FieldByName('NewHstdCode').Text;
                            SchoolCode := FieldByName('NewSchoolCode').Text;

                            PrintParcelChangeLine(Sender, AuditParcelChangeTable,
                                                  ResPercent, AssessedVal, CountyTaxableVal,
                                                  TownTaxableVal, SchoolTaxableVal,
                                                  RollSection, HomesteadCode, SchoolCode,
                                                  'After:');

                          end;  {If (FieldByName('RecordType').Text[1] in ['C', 'D'])}

                        {Update totals.}

                      If (RecordType in ['A', 'D'])
                        then
                          begin
                            If (RecordType = 'D')
                              then Multiplier := -1
                              else Multiplier := 1;

                            TotalAVChange := TotalAVChange +
                                             Multiplier * AssessedVal;
                            TotalCountyTaxableChange := TotalCountyTaxableChange +
                                                        Multiplier * CountyTaxableVal;
                            TotalTownTaxableChange := TotalTownTaxableChange +
                                                      Multiplier * TownTaxableVal;
                            TotalSchoolTaxableChange := TotalSchoolTaxableChange +
                                                        Multiplier * SchoolTaxableVal;

                          end;  {If (RecordType in ['A', 'D'])}

                        {In the case of a parcel change, we only want to record
                         differences in TV (there will never be AV).
                         This will only occur if there is a difference in res
                         percent and there are exemptions affected by the
                         residential percent.}

                      If (RecordType = 'C')
                        then
                          begin
                            TotalCountyTaxableChange := TotalCountyTaxableChange +
                                                        FieldByName('NewCountyTaxableVal').AsInteger -
                                                        FieldByName('OldCountyTaxableVal').AsInteger;

                            TotalTownTaxableChange := TotalTownTaxableChange +
                                                      FieldByName('NewTownTaxableVal').AsInteger -
                                                      FieldByName('OldTownTaxableVal').AsInteger;

                            TotalSchoolTaxableChange := TotalSchoolTaxableChange +
                                                        FieldByName('NewSchlTaxableVal').AsInteger -
                                                        FieldByName('OldSchlTaxableVal').AsInteger;

                          end;  {If (RecordType = 'C')}

                    end;  {with AuditParcelTable do}

                {If there is only one line left to print, then we
                 want to go to the next page.}

              If (LinesLeft < 3)
                then NewPage;

            end;  {If not (Done or Quit)}

        ReportCancelled := ProgressDialog.Cancelled;

      until (Done or Quit or ReportCancelled);

        {FXX01231998-5: Tell them if nothing in range.}

      If (NumChanged = 0)
        then Println('None.')
        else PrintSectionChangeTotals(Sender, TotalAVChange,
                                      TotalCountyTaxableChange,
                                      TotalTownTaxableChange,
                                      TotalSchoolTaxableChange);

      GrandTotalAVChange := GrandTotalAVChange + TotalAVChange;
      GrandTotalCountyTaxableChange := GrandTotalCountyTaxableChange +
                                       TotalCountyTaxableChange;
      GrandTotalTownTaxableChange := GrandTotalTownTaxableChange +
                                     TotalTownTaxableChange;
      GrandTotalSchoolTaxableChange := GrandTotalSchoolTaxableChange +
                                       TotalSchoolTaxableChange;

        {Because the exemption amounts for adds and deletes are tracked in
         the exemption section, we don't want to double count. We
         can correct this by adding back the assessed value change to
         the taxable values for deletes and subtracting for the adds.}

      Multiplier := 0;
      case RecordType of
        'A' : Multiplier := -1;
        'C' : Multiplier := 0;
        'D' : Multiplier := 1;
      end;

        {FXX10011998-1: Don't want to add full AV back - do diff btw av and ex}

      GrandTotalCountyTaxableChange := GrandTotalCountyTaxableChange +
                                       Multiplier * (TotalAVChange - TotalCountyTaxableChange);
      GrandTotalTownTaxableChange := GrandTotalTownTaxableChange +
                                     Multiplier * (TotalAVChange - TotalTownTaxableChange);
      GrandTotalSchoolTaxableChange := GrandTotalSchoolTaxableChange +
                                       Multiplier * (TotalAVChange - TotalSchoolTaxableChange);

      Println('');

    end;  {with Sender as TBaseReport do}

end;  {PrintParcelChangeSection}

{====================================================================}
Procedure TAssessorsTrialBalanceReportForm.ReportFilerPrint(Sender: TObject);

var
  GrandTotalAVChange, GrandTotalCountyTaxableChange,
  GrandTotalTownTaxableChange, GrandTotalSchoolTaxableChange : LongInt;

begin
  GrandTotalAVChange := 0;
  GrandTotalCountyTaxableChange := 0;
  GrandTotalTownTaxableChange := 0;
  GrandTotalSchoolTaxableChange := 0;

  with Sender as TBaseReport do
  If (LinesLeft < 15)
  then NewPage;

    {CHG03241998-1: Show exemptions before and after for each parcel as
                    a whole picture each time.}
    {CHG04251999-1: Allow them to chose which section to print.}

  ProgressDialog.UserLabelCaption := 'Printing exemption section.';

  If ExemptionChangeCheckBox.Checked
    then PrintExemptionSection(Sender, AuditEXChangeTable,
                               GrandTotalCountyTaxableChange,
                               GrandTotalTownTaxableChange,
                               GrandTotalSchoolTaxableChange);

    {AV changes}

  ProgressDialog.UserLabelCaption := 'Printing assessed value changes section.';

  If ((not ReportCancelled) and
      AssessedValueChangesCheckBox.Checked)
    then PrintAVChangeSection(Sender, AuditAVChangeTable,
                              GrandTotalAVChange,
                              GrandTotalCountyTaxableChange,
                              GrandTotalTownTaxableChange,
                              GrandTotalSchoolTaxableChange);

    {Parcel adds.}

  ProgressDialog.UserLabelCaption := 'Printing parcel add section.';

  If ((not ReportCancelled) and
      ParcelChangesCheckBox.Checked)
    then PrintParcelChangeSection(Sender, AuditParcelChangeTable, 'A',
                                  GrandTotalAVChange,
                                  GrandTotalCountyTaxableChange,
                                  GrandTotalTownTaxableChange,
                                  GrandTotalSchoolTaxableChange);

    {Parcel delete.}

  ProgressDialog.UserLabelCaption := 'Printing parcel deletion section.';

  If ((not ReportCancelled) and
      ParcelChangesCheckBox.Checked)
    then PrintParcelChangeSection(Sender, AuditParcelChangeTable, 'D',
                                  GrandTotalAVChange,
                                  GrandTotalCountyTaxableChange,
                                  GrandTotalTownTaxableChange,
                                  GrandTotalSchoolTaxableChange);

    {Parcel change.}

  ProgressDialog.UserLabelCaption := 'Printing parcel change section.';

  If ((not ReportCancelled) and
      ParcelChangesCheckBox.Checked)
    then PrintParcelChangeSection(Sender, AuditParcelChangeTable, 'C',
                                  GrandTotalAVChange,
                                  GrandTotalCountyTaxableChange,
                                  GrandTotalTownTaxableChange,
                                  GrandTotalSchoolTaxableChange);

    {Print the overall totals.}

  If (not ReportCancelled)
    then
      begin
        with Sender as TBaseReport do
          begin
            Println('');
            Bold := True;
            PrintCenter('Overall Changes', (PageWidth/2));
            Bold := False;
            Println('');

          end;  {with Sender as TBaseReport do}

        PrintSectionChangeTotals(Sender, GrandTotalAVChange,
                                 GrandTotalCountyTaxableChange,
                                 GrandTotalTownTaxableChange,
                                 GrandTotalSchoolTaxableChange);

      end;  {If ((not ReportCancelled) and ...}

    {SD adds.}

  ProgressDialog.UserLabelCaption := 'Printing special district section.';

  If ((not ReportCancelled) and
      SpecialDistrictChangesCheckBox.Checked)
    then
      begin
        PrintSpecialDistrictSection(Sender, AuditSDChangeTable, 'SA', 'A');

          {CHG03231998-1: Print ex and SD changes.}
          {SD changes.}

        If (not ReportCancelled)
          then PrintSpecialDistrictSection(Sender, AuditSDChangeTable, 'SC', 'C');

          {SD deletions.}

        If (not ReportCancelled)
          then PrintSpecialDistrictSection(Sender, AuditSDChangeTable, 'SD', 'D');

      end;  {If ((not ReportCancelled) and ...}

end;  {ReportPrinterPrint}

{===================================================================}
Procedure TAssessorsTrialBalanceReportForm.CloseButtonClick(Sender: TObject);

begin
  Close;
end;

{===================================================================}
Procedure TAssessorsTrialBalanceReportForm.FormClose(    Sender: TObject;
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
