unit Pexcdmnt;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  StdCtrls, ExtCtrls, Forms, Dialogs, DB, Grids, DBGrids,
  DBTables, Mask, DBCtrls, Wwtable, Wwdatsrc, Wwdbcomb, Wwdbigrd, Wwdbgrid,
  Btrvdlg, Types, wwdblook, Buttons, PASTypes, Wwdbedit, Wwdotdot, Tabs;

type
  TParcelExemptionCodeForm = class(TForm)
    ExemptionDataSource: TwwDataSource;
    ExemptionTable: TwwTable;
    TitlePanel: TPanel;
    TitleLabel: TLabel;
    Panel2: TPanel;
    ScrollBox: TScrollBox;
    ParcelDataSource: TDataSource;
    ParcelTable: TTable;
    YearLabel: TLabel;
    ExemptionCodeLookupTable: TwwTable;
    ExCodeDBLookupCombo: TwwDBLookupCombo;
    AssessmentTable: TwwTable;
    ParcelExLookupTable: TwwTable;
    AssessedValDataSource: TwwDataSource;
    InactiveLabel: TLabel;
    ParcelSDTable: TTable;
    ClassTable: TTable;
    SwisCodeTable: TTable;
    SDCodeTable: TTable;
    HomesteadCombo: TwwDBCombobox;
    OppositeYearExemptionTable: TTable;
    LandLabel: TLabel;
    TotalLabel: TLabel;
    TotalAVLabel: TLabel;
    LandAVLabel: TLabel;
    AuditEXChangeTable: TTable;
    EditBIEPanel: TPanel;
    Label29: TLabel;
    BIEAmountEdit: TDBEdit;
    DoneBIEButton: TBitBtn;
    OriginalBIEAmountLabel: TLabel;
    AssessmentYearControlTable: TTable;
    OldParcelIDLabel: TLabel;
    ParcelExLookupTableTaxRollYr: TStringField;
    ParcelExLookupTableSwisSBLKey: TStringField;
    ParcelExLookupTableExemptionCode: TStringField;
    ParcelExLookupTableAmount: TIntegerField;
    ParcelExLookupTableCountyAmount: TIntegerField;
    ParcelExLookupTableTownAmount: TIntegerField;
    ParcelExLookupTableSchoolAmount: TIntegerField;
    ParcelExLookupTableVillageAmount: TIntegerField;
    ParcelExLookupTablePercent: TFloatField;
    ParcelExLookupTableInitialDate: TDateField;
    ParcelExLookupTableTerminationDate: TDateField;
    ParcelExLookupTableOwnerPercent: TFloatField;
    ParcelExLookupTableApplyToVillage: TBooleanField;
    ParcelExLookupTableHomesteadCode: TStringField;
    ParcelExLookupTableExemptionApproved: TBooleanField;
    ParcelExLookupTableApprovalPrinted: TBooleanField;
    ParcelExLookupTableRenewalPrinted: TBooleanField;
    ParcelExLookupTableRenewalReceived: TBooleanField;
    ParcelExLookupTableReminderPrinted: TBooleanField;
    ParcelExLookupTableAutoIncrementID: TAutoIncField;
    ParcelExLookupTableDateApprovalPrinted: TDateField;
    ParcelExLookupTableDateRenewalPrinted: TDateField;
    ParcelExLookupTableDateReminderPrinted: TDateField;
    ParcelExLookupTableDateRenewalReceived: TDateField;
    ParcelExLookupTableOriginalBIEAmount: TIntegerField;
    ParcelExLookupTableReserved: TStringField;
    ExemptionTableTaxRollYr: TStringField;
    ExemptionTableSwisSBLKey: TStringField;
    ExemptionTableExemptionCode: TStringField;
    ExemptionTableAmount: TIntegerField;
    ExemptionTableCountyAmount: TIntegerField;
    ExemptionTableTownAmount: TIntegerField;
    ExemptionTableSchoolAmount: TIntegerField;
    ExemptionTableVillageAmount: TIntegerField;
    ExemptionTablePercent: TFloatField;
    ExemptionTableInitialDate: TDateField;
    ExemptionTableTerminationDate: TDateField;
    ExemptionTableOwnerPercent: TFloatField;
    ExemptionTableApplyToVillage: TBooleanField;
    ExemptionTableHomesteadCode: TStringField;
    ExemptionTableExemptionApproved: TBooleanField;
    ExemptionTableApprovalPrinted: TBooleanField;
    ExemptionTableRenewalPrinted: TBooleanField;
    ExemptionTableRenewalReceived: TBooleanField;
    ExemptionTableReminderPrinted: TBooleanField;
    ExemptionTableAutoIncrementID: TAutoIncField;
    ExemptionTableDateApprovalPrinted: TDateField;
    ExemptionTableDateRenewalPrinted: TDateField;
    ExemptionTableDateReminderPrinted: TDateField;
    ExemptionTableDateRenewalReceived: TDateField;
    ExemptionTableOriginalBIEAmount: TIntegerField;
    ExemptionDenialTable: TTable;
    PartialAssessmentLabel: TLabel;
    SalesTable: TTable;
    RemovedExemptionsTable: TTable;
    ExemptionTableAutoRenew: TBooleanField;
    ParcelExLookupTableAutoRenew: TBooleanField;
    ExemptionTablePreventRenewal: TBooleanField;
    FooterPanel: TPanel;
    CloseButton: TBitBtn;
    Navigator: TDBNavigator;
    EditBIEButton: TBitBtn;
    RenewButton: TBitBtn;
    HeaderPanel: TPanel;
    Label15: TLabel;
    Label3: TLabel;
    Label19: TLabel;
    PropClassDesc: TDBText;
    EditResidentialPercent: TDBEdit;
    EditOwnershipCode: TDBEdit;
    DBEdit2: TDBEdit;
    GroupBox1: TGroupBox;
    Label27: TLabel;
    Label28: TLabel;
    EditApprovalDate: TDBEdit;
    EditRenewalDate: TDBEdit;
    Panel5: TPanel;
    ExemptionGrid: TwwDBGrid;
    ExemptionTableExemptionDescription: TStringField;
    TaxableValuesPanel: TPanel;
    Label10: TLabel;
    CountyAmountLabel: TLabel;
    MunicipalAmountLabel: TLabel;
    VillageAmountLabel: TLabel;
    SchoolAmountLabel: TLabel;
    Label18: TLabel;
    STARFootnoteLabel: TLabel;
    SchoolAsteriskLabel: TLabel;
    EditCountyTaxableVal: TEdit;
    EditCityTaxableVal: TEdit;
    EditSchoolTaxableVal: TEdit;
    EditVillageTaxableVal: TEdit;
    EditCountyAgedTotal: TEdit;
    EditCityAgedTotal: TEdit;
    EditSchoolAgedTotal: TEdit;
    EditVillageAgedTotal: TEdit;
    Panel1: TPanel;
    OwnerNameLabel: TLabel;
    Label7: TLabel;
    Label4: TLabel;
    LastChangeByLabel: TLabel;
    ChangeByLabel: TLabel;
    EditName: TDBEdit;
    EditSBL: TMaskEdit;
    EditLocation: TEdit;
    EditLastChangeDate: TDBEdit;
    EditLastChangeByName: TDBEdit;
    lbIVPStatus: TLabel;
    cbxIVPStatus: TDBComboBox;
    lbBasicIVPStatus: TLabel;
    tbBasicIVPStatuses: TTable;
    cbxBasicIVPStatuses: TwwDBLookupCombo;
    ExemptionTableExemptionFilingName2: TStringField;
    ExemptionTableExemptionFilingDate2: TDateField;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure CloseButtonClick(Sender: TObject);
    procedure ExemptionTableAfterEdit(DataSet: TDataset);
    procedure ExemptionTableBeforePost(DataSet: TDataset);
    procedure ExemptionTableAfterPost(DataSet: TDataset);
    procedure ExemptionGridColEnter(Sender: TObject);
    procedure ExemptionTableBeforeDelete(DataSet: TDataset);
    procedure ExemptionGridColExit(Sender: TObject);
    procedure EditBIEButtonClick(Sender: TObject);
    procedure ExemptionDataSourceDataChange(Sender: TObject;
      Field: TField);
    procedure EditBIEPanelExit(Sender: TObject);
    procedure DoneBIEButtonClick(Sender: TObject);
    procedure ExCodeDBLookupComboCloseUp(Sender: TObject; LookupTable,
      FillTable: TDataSet; modified: Boolean);
    procedure FormActivate(Sender: TObject);
    procedure ExemptionTableAfterScroll(DataSet: TDataSet);
    procedure RenewButtonClick(Sender: TObject);
    procedure ExemptionTableNewRecord(DataSet: TDataSet);
    procedure FormResize(Sender: TObject);
    procedure ExemptionTableCalcFields(DataSet: TDataSet);

  protected
    procedure CreateParams(var Params: TCreateParams); override;
  public
    { public declarations }
    UnitName : String;  {For use with error dialog box.}

      {These will be set in the ParcelTabForm.}

    EditMode : Char;  {A = Add; M = Modify; V = View}
    TaxRollYr : String;
    SwisSBLKey : String;
    ProcessingType : Integer;  {NextYear, ThisYear, History}

        {These var.'s are for tracing changes.}

    FieldValuesList,
    FieldLabelsList : TStringList;

      {Have there been any changes?}

    BIEDoneButtonPressed,
    ParcelChanged : Boolean;
    FormIsInitializing,
    DeletingARecord,  {Are we deleting a record now?}
    ClosingForm : Boolean;  {Are we closing a form right now?}
    FormAccessRights : Integer;  {Read only or read write, based on security level?}
                                {Values = raReadOnly, raReadWrite}

    MoveToRollSection1,
    MoveToRollSection8 : Boolean;

    OrigRollSection : String;

      {These variables are for keeping track of exemption
       and SD roll total changes.}

    OrigTotalAssessedVal,
    OrigLandAssessedVal : Comp;
    OrigExemptionCodes,
    OrigExemptionHomesteadCodes,
    OrigResidentialTypes,
    OrigCountyExemptionAmounts,
    OrigTownExemptionAmounts,
    OrigSchoolExemptionAmounts,
    OrigVillageExemptionAmounts : TStringList;
    OrigBasicSTARAmount, OrigEnhancedSTARAmount : Comp;
    OrigSDAmounts : TList;
    OrigExAmounts : ExemptionTotalsArrayType;
    OrigExemptionAmount : Comp;
    OrigSchoolExemptionAmount,
    OrigTownExemptionAmount,
    OrigCountyExemptionAmount,
    OrigVillageExemptionAmount : Comp;
    OrigInitialDate : TDateTime;
    OrigPercent : Double;

      {CHG10281997-1: Dual mode processing.}

    RecordAction,
    OppositeProcessingType : Integer;
    OppositeTaxYear : String;
    OppositeYearParcelChanged,
    OppositeYearExemptionFound : Boolean;
    ExemptionCodeId : LongInt;
    AuditEXChangeList  : TList;
    OrigEXCode : String;
    ParcelTabSet : TTabSet;  {The tabs along the bottom. We need them for
                              so that we can refresh the tabs when
                              the first exemption denial or removal is added.}
    TabTypeList : TStringList; {The corresponding tab processing types. "  "   "  "}
    RenewalReceivedChecked : Boolean;

    OriginalGridWidth : Integer;
    FieldTraceInformationList : TList;

    Procedure DisplayTaxableValues(ExAmounts : ExemptionTotalsArrayType);
    {Display the taxable values in the header fields for reference.}

    Procedure DisplayAgedValues(ExemptionCodes,
                                CountyExemptionAmounts,
                                TownExemptionAmounts,
                                SchoolExemptionAmounts,
                                VillageExemptionAmounts : TStringList);
   {Display all the aged amounts.}

    Procedure InitializeForm;

    Function FindOppositeYearExemptionRecord : Boolean;
    {Search the parcel in the opposite year for this exemption.}

    Procedure SetRangeForTable(Table : TTable);

    Procedure SetReadOnlyFields;
    {Set the fields readonly or required for this parcel based on the exemption and
     calculation codes.}

    Procedure ResetReadOnlyFields;
    {Set the fields not readonly or required.}

    Procedure AutoAddEnhancedSTAR(TaxRollYr : String;
                                  SwisSBLKey : String;
                                  ExemptionCodeLookupTable,
                                  ExemptionTable,
                                  AssessmentTable,
                                  ParcelEXLookupTable,
                                  ParcelTable : TTable;
                                  OrigBasicSTARAmount,
                                  OrigEnhancedSTARAmount : Comp;
                                  OrigSchoolExemptionAmounts : TStringList;
                                  DisplayMessage, OppositeYear : Boolean);

  end;

implementation

uses GlblVars, WinUtils, PASUTILS, UTILEXSD,  Utilitys, UtilPrcl,
     UTILRTOT,  {Roll total update unit.}
     DataAccessUnit,
     SeniorPercentCalculationForm,
     EnterDateDialog, GlblCnst;


{$R *.DFM}

{=====================================================================}
Procedure TParcelExemptionCodeForm.CreateParams(var Params: TCreateParams);

begin
 inherited CreateParams(Params);

  with Params do
    begin
      WndParent := Application.Mainform.Handle;
      Style := (Style or WS_Child) and not WS_Popup;
    end;

end;  {CreateParams}

{==============================================================}
Procedure TParcelExemptionCodeForm.FormResize(Sender: TObject);

{CHG09102004-1(2.8.0.11): Resize the grid font for a change.}

begin
  If ((not FormIsInitializing) and
      (ExemptionGrid.Width <> OriginalGridWidth))
    then
      begin
        (*ResizeGridFontForWidthChange(ExemptionGrid, OriginalGridWidth); *)

        OriginalGridWidth := ExemptionGrid.Width;

        ResizeTitleInformation(Self);
        ResizeHeaderInformation(Self);
        ResizeFooterInformation(Self);

      end;  {If ((not FormIsInitializing) and ...}

end;  {FormResize}

{========================================================================}
Procedure TParcelExemptionCodeForm.FormActivate(Sender: TObject);

begin
  Refresh;
  Update;
end;

{========================================================================}
Procedure TParcelExemptionCodeForm.SetRangeForTable(Table : TTable);

{Now set the range on the exemption so that it is sychronized to this parcel. Note
 that all segments of the key must be set.}

begin
  SetRangeOld(Table, ['TaxRollYr', 'SwisSBLKey', 'ExemptionCode'],
              [TaxRollYr, SwisSBLKey, '     '],
              [TaxRollYr, SwisSBLKey, 'ZZZZZ']);

end;  {SetRangeForTable}

{====================================================================}
Procedure TParcelExemptionCodeForm.DisplayTaxableValues(ExAmounts : ExemptionTotalsArrayType);

{Display the taxable values in the header fields for reference.}

var
  FormatString : String;

begin
    {CHG04262007-1(2.11.1.26): Allow for option to suppress $ on assessments.}

  FormatString := GetAssessmentDisplayFormat;

  with AssessmentTable do
    begin
      EditCountyTaxableVal.Text := FormatFloat(FormatString,
                                               CalculateTaxableVal(FieldByName('TotalAssessedVal').AsInteger,
                                                                   ExAmounts[RTCounty]));
      EditCityTaxableVal.Text := FormatFloat(FormatString,
                                             CalculateTaxableVal(FieldByName('TotalAssessedVal').AsInteger,
                                                                 ExAmounts[RTTown]));
      EditSchoolTaxableVal.Text := FormatFloat(FormatString,
                                               CalculateTaxableVal(FieldByName('TotalAssessedVal').AsInteger,
                                                                   ExAmounts[RTSchool]));
      EditVillageTaxableVal.Text := FormatFloat(FormatString,
                                                CalculateTaxableVal(FieldByName('TotalAssessedVal').AsInteger,
                                                                    ExAmounts[RTVillage]));

    end;  {with AssessmentTable do}

end;  {DisplayTaxableValues}

{====================================================================}
Procedure TParcelExemptionCodeForm.DisplayAgedValues(ExemptionCodes,
                                                     CountyExemptionAmounts,
                                                     TownExemptionAmounts,
                                                     SchoolExemptionAmounts,
                                                     VillageExemptionAmounts : TStringList);
{Display all the aged amounts.}

var
  I : Integer;
  CountyAged, TownAged,
  SchoolAged, VillageAged : Comp;
  FormatString : String;

begin
    {CHG04262007-1(2.11.1.26): Allow for option to suppress $ on assessments.}

  FormatString := GetAssessmentDisplayFormat;
  CountyAged := 0;
  TownAged := 0;
  SchoolAged := 0;
  VillageAged := 0;

  For I := 0 to (ExemptionCodes.Count - 1) do
    If (Take(4, ExemptionCodes[I]) = '4180')
      then
        begin
          CountyAged := CountyAged + StrToFloat(CountyExemptionAmounts[I]);
          TownAged := TownAged + StrToFloat(TownExemptionAmounts[I]);
          SchoolAged := SchoolAged + StrToFloat(SchoolExemptionAmounts[I]);
          VillageAged := VillageAged + StrToFloat(VillageExemptionAmounts[I]);

        end;  {If (Take(4, ExemptionCodes[I]) = '4180')}

  EditCountyAgedTotal.Text := FormatFloat(FormatString, CountyAged);
  EditCityAgedTotal.Text := FormatFloat(FormatString, TownAged);
  EditSchoolAgedTotal.Text := FormatFloat(FormatString, SchoolAged);
  EditVillageAgedTotal.Text := FormatFloat(FormatString, VillageAged);

end;  {DisplayAgedAmounts}

{====================================================================}
Procedure TParcelExemptionCodeForm.InitializeForm;

{This procedure opens the tables for this form and synchronizes
 them to this parcel. Also, we set the title and year
 labels.

 Note that this code is in this seperate procedure rather
 than any of the OnShow events so that we could have
 complete control over when this procedure is run.
 The problem with any of the OnShow events is that when
 the form is created, they are called, but it is not possible to
 have the SwisSBLKey, etc. set.
 This way, we can call InitializeForm after we know that
 the SwisSBLKey, etc. has been set.}

var
  Quit, Found : Boolean;
  SBLRec : SBLRecord;
  ExAmounts : ExemptionTotalsArrayType;

begin
  OriginalGridWidth := ExemptionGrid.Width;
  UnitName := 'PEXCDMNT.PAS';  {mmm1}
  ClosingForm := False;
  FormIsInitializing := True;

  If (Deblank(SwisSBLKey) <> '')
    then
      begin
          {CHG06092010-1(2.26.1)[I7395]: Suppress the IVP option.}

        If glblSuppressIVP
        then
        begin
          lbIVPStatus.Visible := False;
          cbxIVPStatus.Visible := False;
          ExemptionTableAutoRenew.Visible := False;
          lbBasicIVPStatus.Visible := False;
          cbxIVPStatus.Visible := False;
        end;

        FieldTraceInformationList := TList.Create;

          {If this is the history file, or they do not have read access,
           then we want to set the files to read only.}

          {CHG03222004-2(2.08): Option to prevent user from changing exemptions.}
          {FXX04232009-3(2.20.1.1)[D143]: Don't allow delete of exemptions in history.}

        If ((not ModifyAccessAllowed(FormAccessRights)) or
            GlblUserCannotChangeExemptions or
            (EditMode = 'V') or
            _Compare(GlblTaxYearFlg, 'H', coEqual))
          then
            begin
              ExemptionTable.ReadOnly := True;
              EditMode := 'V';
            end;

            {FXX03031998-6: Was allowing exemption mods in view or
                            opposite year.}
            {If this is inquire mode or the processing type is not the the
             main (i.e. Glbl Tax Year), let's open it in
             readonly mode.}

            {CHG10251998-1: For MTPL and MTVER, need to allow modification in
                            opposite year so can delete senior STAR on sale due
                            to extension of deadline.}

          {CHG12022004-6(2.8.1.1): Option to show the exemption description.}

        If not GlblShowExemptionFilingInformation
          then
            try
              ExemptionTable.FieldByName('ExemptionFilingDate2').Visible := False;
              ExemptionTable.FieldByName('ExemptionFilingName2').Visible := False;
            except
            end;

          {There are so many tables on this form, we will
           set the table name and open them implicitly (except the
           trace table. OpenTablesForForm is a method in PASUTILS}

        OpenTablesForForm(Self, ProcessingType);

            {If this is the history file, or they do not have read access,
           then we want to set the files to read only.}

        If (GlblTaxYearFlg = 'H')
          then SetRangeForHistoryTaxYear(ExemptionCodeLookupTable, 'TaxRollYr', 'ExCode');


        Found := FindKeyOld(AssessmentTable, ['TaxRollYr', 'SwisSBLKey'],
                            [TaxRollYr,SwisSBLKey]);

        If not Found
          then SystemSupport(012, AssessmentTable, 'Error getting assessment record.',
                             UnitName, GlblErrorDlgBox);

          {First let's find this parcel in the parcel table.}

        SBLRec := ExtractSwisSBLFromSwisSBLKey(SwisSBLKey);

        with SBLRec do
          Found := FindKeyOld(ParcelTable,
                              ['TaxRollYr', 'SwisCode', 'Section',
                               'Subsection', 'Block', 'Lot', 'Sublot',
                               'Suffix'],
                              [TaxRollYr, SwisCode, Section,
                               SubSection, Block, Lot, Sublot, Suffix]);

        If not Found
          then SystemSupport(015, ParcelTable, 'Error finding key in parcel table.', UnitName, GlblErrorDlgBox);

        SetRangeForTable(ExemptionTable);

        SetRangeOld(ParcelExLookupTable,
                    ['TaxRollYr', 'SwisSBLKey', 'ExemptionCode'],
                    [TaxRollYr, SwisSBLKey, '     '],
                    [TaxRollYr, SwisSBLKey, 'ZZZZZ']);

          {Also, set the title label to reflect the mode.
           We will then center it in the panel.}

        case EditMode of   {mmm5}
          'A' : TitleLabel.Caption := 'Add Exemptions';
          'M' : TitleLabel.Caption := 'Modify Exemptions';
          'V' : TitleLabel.Caption := 'View Exemptions';

        end;  {case EditMode of}

        TitleLabel.Left := (TitlePanel.Width - TitleLabel.Width) DIV 2;

          {Now, for some reason the table is marked as
           Modified after we look it up (in modify mode).
           So, we will cancel the modify and set it in
           the proper mode.}

        If ((not ExemptionTable.ReadOnly) and
            ExemptionTable.Modified and
            (EditMode = 'M'))
          then
            begin
              ExemptionTable.Edit;
              ExemptionTable.Cancel;
            end;

          {Note that we will not automatically put them
           in edit mode or insert mode. We will make them
           take that action themselves since even though
           they are in an edit or insert session, they
           may not want to actually make any changes, and
           if they do not, they should not have to cancel.}

        If ExemptionTable.ReadOnly
          then Navigator.Visible := False;

          {Set the location label.}

        EditLocation.Text := GetLegalAddressFromTable(ParcelTable);

          {Now set the year label.}

        SetTaxYearLabelForProcessingType(YearLabel, ProcessingType);

          {Set the SBL in the SBL edit so that it is visible.
           Note that it is not data aware since if there are
           no records, we have nothing to get the SBL from.}

        EditSBL.Text := ConvertSwisSBLToDashDot(SwisSBLKey);

        ExemptionTablePercent.Currency := False;
        ExemptionTableOwnerPercent.Currency := False;

          {Set the display for currency fields.}

          {CHG10091997-1: Display blanks for zeroes.}
        SetDisplayFormatForCurrencyFields(Self, True);

          {FXX03041998-2: Blank zeroes for owner percent.}
        ExemptionTableOwnerPercent.DisplayFormat := DecimalDisplay_BlankZero;

        ExemptionTableDateRenewalPrinted.DisplayFormat := DateFormat;
        ExemptionTableDateApprovalPrinted.DisplayFormat := DateFormat;

          {Allow hstd code edit only if parcel is split, then must specify.}

        If (ParcelTable.FieldByName('HomeSteadCode').Text = 'S')
          then ExemptionTableHomesteadCode.Required := True
          else ExemptionTableHomesteadCode.ReadOnly := True;

          {Calculate the total exemptions for this parcel and fill them in on the
           screen.}

        OrigExemptionCodes := TStringList.Create;
        OrigExemptionHomesteadCodes := TStringList.Create;
        OrigResidentialTypes := TStringList.Create;
        OrigCountyExemptionAmounts := TStringList.Create;
        OrigTownExemptionAmounts := TStringList.Create;
        OrigSchoolExemptionAmounts := TStringList.Create;
        OrigVillageExemptionAmounts := TStringList.Create;
        OrigSDAmounts := TList.Create;

          {CHG12011997-2: STAR support}
          {FXX02091998-1: Pass the residential type of each exemption.}

        ExAmounts := TotalExemptionsForParcel(TaxRollYr, SwisSBLKey,
                                              ParcelExLookupTable,
                                              ExemptionCodeLookupTable,
                                              ParcelTable.FieldByName('HomesteadCode').Text,
                                              'A',
                                              OrigExemptionCodes,
                                              OrigExemptionHomesteadCodes,
                                              OrigResidentialTypes,
                                              OrigCountyExemptionAmounts,
                                              OrigTownExemptionAmounts,
                                              OrigSchoolExemptionAmounts,
                                              OrigVillageExemptionAmounts,
                                              OrigBasicSTARAmount,
                                              OrigEnhancedSTARAmount);

        DisplayTaxableValues(ExAmounts);
        DisplayAgedValues(OrigExemptionCodes,
                          OrigCountyExemptionAmounts,
                          OrigTownExemptionAmounts,
                          OrigSchoolExemptionAmounts,
                          OrigVillageExemptionAmounts);

        MoveToRollSection1 := False;
        MoveToRollSection8 := False;
        DeletingARecord := False;

        If (ParcelTable.FieldByName('ActiveFlag').Text = InactiveParcelFlag)
          then InactiveLabel.Visible := True;

          {CHG10281997-1: Dual mode processing.}

        If (ProcessingType = ThisYear)
          then OppositeProcessingType := NextYear
          else OppositeProcessingType := ThisYear;

        OppositeTaxYear := GetTaxRollYearForProcessingType(OppositeProcessingType);

        OpenTableForProcessingType(OppositeYearExemptionTable,
                                   ExemptionsTableName,
                                   OppositeProcessingType, Quit);

          {FXX02061998-4: Make the residential percent blank if zero.}

        TNumericField(ParcelTable.FieldByName('ResidentialPercent')).DisplayFormat := NoDecimalDisplay_BlankZero;

          {CHG03241998-1: Show all exemptions before and after for trace.}

        AuditEXChangeList := TList.Create;

          {CHG11171999-1: BIE Exemption support}
          {Display the original BIE exemption amount in the hint.}

        ExemptionGrid.ShowHint := True;

        If GlblLocateByOldParcelID
          then SetOldParcelIDLabel(OldParcelIDLabel, ParcelTable,
                                   AssessmentYearControlTable);

          {CHG10012002-1: Allow them to renew seniors by re-entering the income level.}
          {CHG03112009-2(2.17.1.7): Allow renewal based on income for low-income disabled.}

        If GlblUserIsSearcher
          then RenewButton.Visible := False
          else RenewButton.Visible := (ExemptionIsSenior(ExemptionTable.FieldByName('ExemptionCode').AsString) or
                                       ExemptionIsLowIncomeDisabled(ExemptionTable.FieldByName('ExemptionCode').AsString));

          {CHG01192004-1(2.08): Let each municipality decide what roll totals to display.}

        If not (rtdCounty in GlblRollTotalsToShow)
          then
            begin
              CountyAmountLabel.Visible := False;
              EditCountyTaxableVal.Visible := False;
              EditCountyAgedTotal.Visible := False;
            end;

        If (rtdMunicipal in GlblRollTotalsToShow)
          then MunicipalAmountLabel.Caption := GetMunicipalityTypeName(GlblMunicipalityType)
          else
            begin
              MunicipalAmountLabel.Visible := False;
              EditCityTaxableVal.Visible := False;
              EditCityAgedTotal.Visible := False;
            end;

        If not (rtdSchool in GlblRollTotalsToShow)
          then
            begin
              SchoolAmountLabel.Visible := False;
              EditSchoolTaxableVal.Visible := False;
              EditSchoolAgedTotal.Visible := False;
              SchoolAsteriskLabel.Visible := False;
              STARFootnoteLabel.Visible := False;
            end;

          {FXX09112008-1(2.15.1.11): Only check to see if the exemption applies to the village
                                     if this is an assessing unit.  Otherwise, it always does.}

        If (VillageIsAssessingUnit(Copy(SwisSBLKey, 1, 6)) and
            (rtdVillageReceivingPartialRoll in GlblRollTotalsToShow))
          then
            begin
              VillageAmountLabel.Visible := True;
              EditVillageTaxableVal.Visible := True;
              EditVillageAgedTotal.Visible := True;
            end;

          {CHG03132004-3(2.08): If this municipality does not have a village that takes a partial roll,
                                hide the AppliesToVillage flag.}

        If not (rtdVillageReceivingPartialRoll in GlblRollTotalsToShow)
          then
            with ExemptionTable do
              begin
                FieldByName('ApplyToVillage').Visible := False;

                If not GlblCanPreventExemptionRenewal
                  then
                    begin
                      FieldByName('ExemptionCode').DisplayWidth := FieldByName('ExemptionCode').DisplayWidth + 2;
                      FieldByName('Amount').DisplayWidth := FieldByName('Amount').DisplayWidth + 2;
                      FieldByName('InitialDate').DisplayWidth := FieldByName('InitialDate').DisplayWidth + 1;
                      FieldByName('TerminationDate').DisplayWidth := FieldByName('TerminationDate').DisplayWidth + 1;

                    end;  {If not GlblCanPreventExemptionRenewal}

              end;  {with ExemptionTable do}

          {CHG03182004-1(2.08): Allow for prevention of renewals on individual exemptions.
                                Used for volunteer firefighter.}

        with ExemptionTable do
          If GlblCanPreventExemptionRenewal
            then FieldByName('TerminationDate').DisplayWidth := FieldByName('TerminationDate').DisplayWidth - 1
            else FieldByName('PreventRenewal').Visible := False;

          {In the case that both the apply to village and prevent renewal flags are on,
           turn off the approval printed box.}

        If ((rtdVillageReceivingPartialRoll in GlblRollTotalsToShow) and
            GlblCanPreventExemptionRenewal)
          then ExemptionTable.FieldByName('ApprovalPrinted').Visible := False;

          {CHG12022004-5(2.8.1.1): Option to show the exemption description.}

        If not GlblDisplayExemptionDescriptions
          then
            try
              ExemptionTable.FieldByName('ExemptionDescription').Visible := False;
            except
            end;

        If not GlblMunicipalityIsClassified
          then ExemptionTable.FieldByName('HomesteadCode').Visible := False;

      end;  {If (Deblank(SwisSBLKey) <> '')}

  FormIsInitializing := False;

    {CHG11162004-7(2.8.0.21): Option to make the close button locate.}

  If GlblCloseButtonIsLocate
    then MakeCloseButtonLocate(CloseButton);

    {CHG12022004-5(2.8.1.1): Option to show the exemption description.}

  If GlblShowExemptionDescription
    then ExemptionTable.Refresh;

end;  {InitializeForm}

{==============================================================================}
Procedure TParcelExemptionCodeForm.ExemptionTableCalcFields(DataSet: TDataSet);

begin
    {CHG12022004-5(2.8.1.1): Option to show the exemption description.}

  If (GlblDisplayExemptionDescriptions and
      _Compare(ExemptionTable.FieldByName('ExemptionCode').AsString, coNotBlank))
    then
      begin
        If not ExemptionCodeLookupTable.Active
          then _OpenTable(ExemptionCodeLookupTable, ExemptionCodesTableName, '', 'ByEXCode', ProcessingType, []);
        _Locate(ExemptionCodeLookupTable, [ExemptionTable.FieldByName('ExemptionCode').AsString], '', []);
        ExemptionTable.FieldByName('ExemptionDescription').AsString := ExemptionCodeLookupTable.FieldByName('Description').AsString;

      end;  {If ((not FormIsInitializing) and ...}

end;  {ExemptionTableCalcFields}

{==============================================================================}
Procedure TParcelExemptionCodeForm.ExemptionDataSourceDataChange(Sender: TObject;
                                                                 Field: TField);

{CHG11171999-1: BIE support}

begin
    {FXX12081999-4: Need function to test for BIE in case not 47600.}

  If (Field = nil)
    then
      If IsBIEExemptionCode(ExemptionTable.FieldByName('ExemptionCode').Text)
        then
          begin
            ExemptionGrid.Hint := 'Original BIE Amount = ' +
                                        FormatFloat(CurrencyNormalDisplay,
                                                    ExemptionTable.FieldByName('OriginalBIEAmount').AsFloat);

              {FXX11301999-1: Don't show the BIE button unless it is a BIE exemption.}

            If (not ExemptionTable.ReadOnly)
              then EditBIEButton.Visible := True;

          end
        else
          begin
            ExemptionGrid.Hint := '';
            EditBIEButton.Visible := False;
          end;

end;  {ExemptionDataSourceDataChange}

{==============================================================================}
Procedure TParcelExemptionCodeForm.ExemptionTableAfterScroll(DataSet: TDataSet);

{CHG10012002-1: Allow them to renew seniors by re-entering the income level.}

begin
  If ((not FormIsInitializing) and
      (not GlblUserIsSearcher))
    then RenewButton.Visible := (ExemptionIsSenior(ExemptionTable.FieldByName('ExemptionCode').AsString) or
                                 ExemptionIsLowIncomeDisabled(ExemptionTable.FieldByName('ExemptionCode').AsString));

end;  {ExemptionTableAfterScroll}

{==============================================================================}
Procedure TParcelExemptionCodeForm.RenewButtonClick(Sender: TObject);

{CHG10012002-1: Allow them to renew seniors by re-entering the income level.}

var
  OriginalPercent : Double;

begin
  try
    SeniorIncomePercentCalculationForm := TSeniorIncomePercentCalculationForm.Create(nil);

    If (SeniorIncomePercentCalculationForm.ShowModal = idOK)
      then
        begin
          If (ExemptionTable.State = dsBrowse)
            then ExemptionTable.Edit;

          OriginalPercent := ExemptionTable.FieldByName('Percent').AsFloat;

          ExemptionTable.FieldByName('Percent').AsFloat := SeniorIncomePercentCalculationForm.ExemptionPercent;

            {If this exemption has not already been marked as renewal received, do so now.}

          If not ExemptionTable.FieldByName('RenewalReceived').AsBoolean
            then
              begin
                ExemptionTable.FieldByName('RenewalReceived').AsBoolean := True;
                ExemptionTable.FieldByName('DateRenewalReceived').AsDateTime := Date;
              end;

          ExemptionTable.FieldByName('ExemptionApproved').AsBoolean := True;

            {If the senior percent did not change, just mark as renewed and approved
             and automatically post.  If it did change, set everything up and let them
             post so that they have an opportunity to cancel.}

          If (Roundoff(SeniorIncomePercentCalculationForm.ExemptionPercent, 2) =
              Roundoff(OriginalPercent, 2))
            then
              begin
                try
                  ExemptionTable.Post;
                except
                  SystemSupport(030, ExemptionTable, 'Error posting exemption table to renew senior exemption.',
                                UnitName, GlblErrorDlgBox);
                end;

                MessageDlg('The senior exemption percentage did not change.' + #13 +
                           'This exemption has been marked to show that the' + #13 +
                           'renewal was received and approved.',
                           mtInformation, [mbOK], 0);

              end
            else
              begin
                MessageDlg('The senior exemption percentage changed from ' +
                           FormatFloat(PercentageDisplay, OriginalPercent) + ' to ' +
                           FormatFloat(PercentageDisplay, SeniorIncomePercentCalculationForm.ExemptionPercent) + '.' + #13 +
                           'Please review the change and click the check at the bottom to accept the change' + #13 +
                           'or click the ''X'' to cancel.',
                           mtWarning, [mbOK], 0);

                ExemptionGrid.SetActiveField('Percent');
                ExemptionGridColExit(Sender);

              end;  {else of If (Roundoff(SeniorIncomePercentCalculationForm.ExemptionPercent, 2) =...}

        end;  {If (SeniorIncomePercentCalculationForm.ShowModal = idOK)}

  finally
    SeniorIncomePercentCalculationForm.Free;
  end;

end;  {RenewButtonClick}

{==============================================================================}
Function TParcelExemptionCodeForm.FindOppositeYearExemptionRecord : Boolean;

{Search the parcel in the opposite year for this exemption.}

{FXX11131997-11: The auto increment ID's will probably not
                 be the same between TY and NY files, so have
                 to compare on a record by record basis,
                 we will use code and amount as the keys.}

var
  Done, FirstTimeThrough : Boolean;
  NumFoundThisExemption : Integer;
  OppositeYearBookmark : TBookmark;

begin
  OppositeYearBookmark := nil;
  NumFoundThisExemption := 0;
  OppositeYearExemptionTable.CancelRange;
  SetRangeOld(OppositeYearExemptionTable,
              ['TaxRollYr', 'SwisSBLKey', 'ExemptionCode'],
              [OppositeTaxYear, SwisSBLKey, '     '],
              [OppositeTaxYear, SwisSBLKey, 'ZZZZZ']);

  Done := False;
  FirstTimeThrough := True;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else OppositeYearExemptionTable.Next;

    If OppositeYearExemptionTable.EOF
      then Done := True;

      {FXX02261998-2: We need to keep track of the original amount
                      in order to do dual year modification.}
      {FXX03312003-1(2.06q1): Comparing by exemption amount is not accurate.
                              The correct way is to see if the exemption exists in
                              next year and is the only one of its kind.  If it is,
                              delete it and don't worry about it.  If it isn't don't do
                              anything and give a warning message.}

    If not Done
      then
        with OppositeYearExemptionTable do
          If (ExemptionTableExemptionCode.Text = FieldByName('ExemptionCode').Text)
            then
              begin
                NumFoundThisExemption := NumFoundThisExemption + 1;
                OppositeYearBookmark := OppositeYearExemptionTable.GetBookmark;
              end;

  until Done;

  If (NumFoundThisExemption > 1)
    then MessageDlg('The exemption code ' + ExemptionTableExemptionCode.Text +
                    ' is on this parcel twice in Next Year.' + #13 +
                    'Please delete the correct corresponding exemption in Next Year manually.',
                    mtWarning, [mbOK], 0);

    {If there was only 1 exemption found of this type, go to it.}

  If (NumFoundThisExemption = 1)
    then
      begin
        OppositeYearExemptionTable.GotoBookmark(OppositeYearBookmark);
        OppositeYearExemptionTable.FreeBookmark(OppositeYearBookmark);
      end;

  Result := (NumFoundThisExemption = 1);

end;  {FindOppositeYearExemptionRecord}

{==============================================================================}
Procedure TParcelExemptionCodeForm.ExemptionTableBeforeDelete(DataSet: TDataset);

{We will call the AfterEdit routine with a flag saying that this is
 the delete case.}

var
  ReturnCode : Integer;

begin
  DeletingARecord := False;

    {Confirm the delete.}

  If (OrigRollSection = '8')
    then ReturnCode := MessageDlg('This parcel is in roll section 8.' + #13 +
                                  'If you delete this exemption, it will be moved to roll section 1.' + #13 +
                                  'Do you want to delete it anyway?',
                                  mtConfirmation, [mbYes, mbNo], 0)
    else ReturnCode := MessageDlg('Delete exemption ' +
                                  ExemptionTable.FieldByName('ExemptionCode').Text +
                                  '?', mtConfirmation, [mbYes, mbNo], 0);

  If (ReturnCode = idYes)
    then
      begin
          {CHG03241998-1: Show whole exemption picture for audit trail -
                          before and after.}
          {This is the before for the opposite year.}
          {We won't actually write out unless they actually delete.}

        ClearTList(AuditEXChangeList, SizeOf(AuditEXRecord));
        GetAuditEXList(SwisSBLKey, TaxRollYr, ParcelEXLookupTable, AuditEXChangeList);

        DeletingARecord := True;
        MoveToRollSection1 := True;

          {CHG10281997-1: Dual processing}
          {FXX11131997-11: The auto increment ID's will probably not
                           be the same between TY and NY files, so have
                           to compare on a record by record basis,
                           we will use code and amount as the keys.}

          {FXX03021998-8: Need to set the original exemption amount
                          before delete so we can find it.}

        with ExemptionTable do
          begin
            OrigExemptionAmount := FieldByName('Amount').AsFloat;
            OrigSchoolExemptionAmount := FieldByName('SchoolAmount').AsFloat;
            OrigTownExemptionAmount := FieldByName('TownAmount').AsFloat;
            OrigCountyExemptionAmount := FieldByName('CountyAmount').AsFloat;
            OrigVillageExemptionAmount := FieldByName('VillageAmount').AsFloat;
            OrigEXCode := FieldByName('ExemptionCode').Text;
            OrigInitialDate := FieldByName('InitialDate').AsDateTime;
            OrigPercent := FieldByName('Percent').AsFloat;

          end;  {with ExemptionTable do}

        OppositeYearExemptionFound := FindOppositeYearExemptionRecord;

        ExemptionTableAfterEdit(DataSet);

          {FXX12021999-3: Trace deletes of exemptions, sds in audit table.}

        AddToTraceFile(SwisSBLKey, 'Exemption', 'Exempt Code',
                       ExemptionTable.FieldByName('ExemptionCode').Text,
                       '(Deleted)', Time, ExemptionTable);

      end
    else Abort;

end;  {ExemptionTableBeforeDelete}

{=====================================================================}
Procedure TParcelExemptionCodeForm.ExemptionTableNewRecord(DataSet: TDataSet);

{FXX11142003-1: Make sure that all float and integer fields are initialized to 0.}

begin
  InitializeFieldsForRecord(DataSet);

    {CHG03132004-2(2.08): If this municipality does not have a village that takes a partial roll,
                          default applies to village to true.}

  If not (rtdVillageReceivingPartialRoll in GlblRollTotalsToShow)
    then ExemptionTable.FieldByName('ApplyToVillage').AsBoolean := True;

end;  {ExemptionTableNewRecord}

{==============================================================}
Procedure TParcelExemptionCodeForm.ExemptionTableAfterEdit(DataSet: TDataset);

{We will initialize the field values for this record. This will be used in the trace
 logic. In the AfterPost event, we will pass the values into the Record Changes procedure
 in PASUTILS and a record will be inserted into the trace file if any differences exist.
 Note that this is a shared event handler with the AfterInsert event.
 Also note that we can not pass in the form variable (i.e. BaseParcelPg1Form) since
 it is not initialized. Instead, we have to pass in the Delphi defined "Self".}

var
  CurrentReadOnlyState : Boolean;

begin
  If not FormIsInitializing
    then
      begin
        ResetReadOnlyFields;

          {CHG10281997-1: Dual mode processing.}

        If (ExemptionTable.State = dsInsert)
          then
            begin
                {CHG10012002-1: Allow them to renew seniors by re-entering the income level.}

              RenewButton.Visible := False;
              RecordAction := raInserted;
            end
          else RecordAction := raEdited;

          {If we are deleting a record, we aren't tracing this information.}

        If not DeletingARecord
          then
            begin
              CreateFieldValuesAndLabels(Self, ExemptionTable, FieldTraceInformationList);

              If (ExemptionTable.State = dsEdit)
                 then ExCodeDBLookupCombo.ReadOnly := True;

              If (ExemptionTable.State = dsInsert)
                 then
                   begin
                     ExCodeDBLookupCombo.ReadOnly := False;

                       {Default the initial date to today.}

                     ExemptionTableInitialDate.AsDateTime := Date;

                     ExemptionTableTaxRollYr.Text := Take(4, TaxRollYr);
                     ExemptionTableSwisSBLKey.Text := Take(26, SwisSBLKey);

                   end;  {If (ExemptionTable.State = dsInsert)}

                {Figure out which fields should be read only.}

              SetReadOnlyFields;

            end;  {If not DeletingARecord}

          {Set the original values for roll total adjustments.}

        OrigRollSection := ParcelTable.FieldByName('RollSection').Text;

          {Now figure out the original exemption and special district
           amounts.}
          {CHG12011997-2: STAR support}
          {FXX02091998-1: Pass the residential type of each exemption.}

        OrigExAmounts := TotalExemptionsForParcel(TaxRollYr, SwisSBLKey,
                                                  ParcelExLookupTable,
                                                  ExemptionCodeLookupTable,
                                                  ParcelTable.FieldByName('HomesteadCode').Text,
                                                  'A',
                                                  OrigExemptionCodes,
                                                  OrigExemptionHomesteadCodes,
                                                  OrigResidentialTypes,
                                                  OrigCountyExemptionAmounts,
                                                  OrigTownExemptionAmounts,
                                                  OrigSchoolExemptionAmounts,
                                                  OrigVillageExemptionAmounts,
                                                  OrigBasicSTARAmount,
                                                  OrigEnhancedSTARAmount);

          {FXX02261998-2: We need to keep track of the original amount
                          in order to do dual year modification.}

        OrigExemptionAmount := ExemptionTable.FieldByName('Amount').AsFloat;

        ClearTList(OrigSDAmounts, SizeOf(ParcelSDValuesRecord));

        TotalSpecialDistrictsForParcel(TaxRollYr,
                                       SwisSBLKey,
                                       ParcelTable,
                                       AssessmentTable,
                                       ParcelSDTable,
                                       SDCodeTable,
                                       ParcelExLookupTable,
                                       ExemptionCodeLookupTable,
                                       OrigSDAmounts);

          {FXX02061998-1: After insert make sure the cursor is in
                          the exemption code field.}

        If (ExemptionTable.State = dsInsert)
          then
            begin
                {FXX09162003-1(2.07j): Make sure to initialize the owner percent and percent.}

              CurrentReadOnlyState := ExemptionTable.FieldByName('OwnerPercent').ReadOnly;
              ExemptionTable.FieldByName('OwnerPercent').ReadOnly := False;
              ExemptionTable.FieldByName('OwnerPercent').AsFloat := 0;
              ExemptionTable.FieldByName('OwnerPercent').ReadOnly := CurrentReadOnlyState;

              CurrentReadOnlyState := ExemptionTable.FieldByName('Percent').ReadOnly;
              ExemptionTable.FieldByName('Percent').ReadOnly := False;
              ExemptionTable.FieldByName('Percent').AsFloat := 0;
              ExemptionTable.FieldByName('Percent').ReadOnly := CurrentReadOnlyState;
              ExemptionGrid.SetFocus;
              ExemptionGrid.SetActiveField('ExemptionCode');

                {FXX06291999-6: Default exemption approved to true.}

              ExemptionTableExemptionApproved.AsBoolean := True;

            end;  {If (ExemptionTable.State = dsInsert)}

          {CHG03241998-1: Show whole exemption picture for audit trail -
                          before and after.}
          {This is the before for the opposite year.}
          {Note that we won't actually write it out unless they actually post a
           change.}

        ClearTList(AuditEXChangeList, SizeOf(AuditEXRecord));
        GetAuditEXList(SwisSBLKey, TaxRollYr, ParcelEXLookupTable, AuditEXChangeList);

          {FXX09132001-8: The renewal received date was not being checked.}

        RenewalReceivedChecked := ExemptionTable.FieldByName('RenewalReceived').AsBoolean;

      end;  {If not FormIsInitializing}

        {FXX11061997-1: There was code here to set the exemption drop
                        down box to be a control of the grid which
                        caused a screen flicker if the user did not
                        hit insert first, so I commented it out.}

     {retie combo box to grid before each edit, readonly seems to mess up}

  (*with ExemptionGrid do
    If (SelectedField.FieldName = 'ExemptionCode')
      then
        begin
          ExemptionGrid.SetControlType(SelectedField.FieldName,
                                       fctLookupCombo,
                                       'ExCodeDBLookupCombo');
          ExemptionGrid.RefreshDisplay;
        end; *)

end;  {ExemptionTableAfterEdit}

{==============================================================}
Procedure TParcelExemptionCodeForm.ResetReadOnlyFields;

{Reset the fields ro not readonly or required.}

begin
    {Start off with none of the fields read-only or required.}

  ExemptionTableAmount.ReadOnly := False;
  ExemptionTableAmount.Required := False;
  ExemptionTablePercent.ReadOnly := False;
  ExemptionTablePercent.Required := False;
  ExemptionTableOwnerPercent.ReadOnly := False;
  ExemptionTableOwnerPercent.Required := False;
  ExemptionTableTerminationDate.Required := False;

end;  {ResetReadOnlyFields}

{==============================================================}
Procedure TParcelExemptionCodeForm.SetReadOnlyFields;

{Set the fields readonly or required for this parcel based on the exemption and
 calculation codes.}

var
  AmountFieldRequired, AmountFieldReadOnly,
  PercentFieldRequired, PercentFieldReadOnly,
  OwnerPercentFieldRequired, OwnerPercentFieldReadOnly,
  TerminationDateRequired : Boolean;

begin
    {FXX09292003-1(2.07j): Move this to a common procedure so that grievance
                           entry can follow the same rules for exemption entry.}

  DetermineExemptionReadOnlyAndRequiredFields(ExemptionCodeLookupTable,
                                              ParcelTable,
                                              ExemptionTable.FieldByName('ExemptionCode').Text,
                                              AmountFieldRequired,
                                              AmountFieldReadOnly,
                                              PercentFieldRequired,
                                              PercentFieldReadOnly,
                                              OwnerPercentFieldRequired,
                                              OwnerPercentFieldReadOnly,
                                              TerminationDateRequired);

  ExemptionTable.FieldByName('Amount').ReadOnly := AmountFieldReadOnly;
  ExemptionTable.FieldByName('Amount').Required := AmountFieldRequired;
  ExemptionTable.FieldByName('Percent').ReadOnly := PercentFieldReadOnly;
  ExemptionTable.FieldByName('Percent').Required := PercentFieldRequired;
  ExemptionTable.FieldByName('OwnerPercent').ReadOnly := OwnerPercentFieldReadOnly;
  ExemptionTable.FieldByName('OwnerPercent').Required := OwnerPercentFieldRequired;
  ExemptionTable.FieldByName('TerminationDate').Required := TerminationDateRequired;

end;  {SetReadOnlyFields}

{==============================================================}
Procedure TParcelExemptionCodeForm.ExCodeDBLookupComboCloseUp(Sender: TObject;
                                                              LookupTable,
                                                              FillTable: TDataSet;
                                                              Modified: Boolean);

{On close up if the table is not readonly, is in insert state, the field is not read only
 and was modified, then we will try to fill in the amount and\or percent.}

var
  I, EXIdx : Integer;
  FixedPercent : Comp;
  ExemptionRecalculated,
  ExemptionCodeOK, VetMaxSet, EqualizationRateFilledIn : Boolean;
  SwisList : TStringList;
  TempStr : String;
  EXAmountsArray : ExemptionTotalsArrayType;
  ExAppliesArray : ExemptionAppliesArrayType;

  ExemptionAlreadyFilledIn,
  BasicSTARExists, EnhancedSTARExists : Boolean;
  EXCode : String;

begin
  ExemptionAlreadyFilledIn := False;

  If ((not ExemptionTable.ReadOnly) and
      (ExemptionTable.State = dsInsert) and
      (not ExemptionTableExemptionCode.ReadOnly) and
      Modified)
    then
      begin
        EXCode := ExemptionCodeLookupTable.FieldByName('EXCode').Text;
        ExemptionCodeOK := True;

        If ExemptionExistsForParcel(EXCode, TaxRollYr, SwisSBLKey, 5,
                                    ParcelEXLookupTable)
          then MessageDlg('Warning! There is another exemption of type ' +
                          ExemptionCodeLookupTable.FieldByName('ExCode').Text + ' for this parcel.' + #13 +
                          'Please make sure that this is correct.', mtWarning, [mbOK], 0);

          {CHG04161998-2: Add the 4193x limited income diabled
                          exemption. Can not have 4180x and 4193x on same
                          parcel.}
          {FXX04272000-3: Co-ops and mobile homes can have both.}
          {CHG08132008-1(2.15.1.5): Add 4191x as a low income disabled exemption.}

        If ((not PropertyIsCoopOrMobileHomePark(ParcelTable)) and
            (((Take(4, EXCode) = '4180') and
              (ExemptionExistsForParcel('4191', TaxRollYr, SwisSBLKey, 4,
                                        ParcelEXLookupTable) or
               ExemptionExistsForParcel('4193', TaxRollYr, SwisSBLKey, 4,
                                        ParcelEXLookupTable))) or
             (ExemptionIsLowIncomeDisabled(EXCode) and
(*             ((Take(4, EXCode) = '4193') and *)
              ExemptionExistsForParcel('4180', TaxRollYr, SwisSBLKey, 4,
                                       ParcelEXLookupTable))))
          then
            begin
              MessageDlg('There can not be a senior (4180x) and limited income disabled ' + #13 +
                         'exemption on the same parcel.', mtError, [mbOK], 0);
              ExemptionCodeOK := False;
            end;

          {CHG12011997-2: STAR support. Only one STAR allowed per parcel,
                          unless this is a co-op or mobile home, in which
                          case there can be one of each.}

        EnhancedSTARExists := False;

        If (Roundoff(OrigEnhancedSTARAmount, 0) > 0)
          then EnhancedSTARExists := True;

        BasicSTARExists := False;

        If (Roundoff(OrigBasicSTARAmount, 0) > 0)
          then BasicSTARExists := True;

        If PropertyIsCoopOrMobileHomePark(ParcelTable)
          then
            begin
                {Can have one of each type.}

              If (((Take(4, EXCode) = '4183') and
                   EnhancedSTARExists) or
                  ((Take(4, EXCode) = '4185') and
                   BasicSTARExists))
                then
                  begin
                    MessageDlg('Co-ops and mobile home parks can only have' + #13 +
                               'one of each kind of STAR exemption.',
                               mtError, [mbOK], 0);
                    ExemptionCodeOK := False;
                  end;

            end
          else
            If (ExemptionIsSTAR(EXCode) and
                (BasicSTARExists or EnhancedSTARExists))
              then
                begin
                  MessageDlg('There is already a STAR exemption on this property.' + #13 +
                             'Only one STAR exemption is allowed on properties other than co-ops or mobile home parks.',
                             mtError, [mbOK], 0);
                  ExemptionCodeOK := False;
                end;

          {If this is a non-homestead parcel, they can not add a residential exemption.}
          {FXX03191998-2: Make this a warning instead.}

        If ((Deblank(ExemptionCodeLookupTable.FieldByName('ResidentialType').Text) = 'R') and
            (ParcelTable.FieldByName('HomesteadCode').Text = 'N') and
            (Roundoff(ParcelTable.FieldByName('ResidentialPercent').AsFloat, 0) = 0))
          then
            If (MessageDlg('Warning! You are trying to enter a residential exemption on a non-homestead parcel.' + #13 +
                           'Is this correct?', mtWarning, [mbYes, mbNo], 0) = idNo)
              then ExemptionCodeOK := False;

          {If this is a homestead parcel, warn them if they try to add a non-residential exemption.}

        If ((Deblank(ExemptionCodeLookupTable.FieldByName('ResidentialType').Text) = 'N') and
            (ParcelTable.FieldByName('HomesteadCode').Text = 'H'))
          then
            If (MessageDlg('Warning! You are trying to enter a non-residential exemption on a homestead parcel.' + #13 +
                           'Is this correct?', mtWarning, [mbYes, mbNo], 0) = idNo)
              then ExemptionCodeOK := False;

          {CHG04272008(2.12.1.1): Add Cold War veteran exemption.
                                  The Cold War vet cannot be added if a different exemption exists.}
          {FXX09172008-1(2.15.1.14)[D1381]: Cold War and alternate vets need to coexist on coops.}

        If (ExemptionCodeOK and
            (not PropertyIsCoopOrMobileHomePark(ParcelTable)))
          then
            begin
              _SetRange(ParcelEXLookupTable, [TaxRollYr, SwisSBLKey], [], '', [loSameEndingRange]);

              with ParcelEXLookupTable do
                while not EOF do
                  begin
                    If (ExemptionIsColdWarVeteran(ExemptionTable.FieldByName('ExemptionCode').AsString) and
                         (ExemptionIsBasicVeteran(FieldByName('ExemptionCode').AsString) or
                          ExemptionIsAlternativeVeteran(FieldByName('ExemptionCode').AsString)))
                      then
                        begin
                          ExemptionCodeOK := False;
                          MessageDlg('You cannot add a Cold War veteran exemption to a parcel with ' + #13 +
                                     'a basic or alternative veteran exemption already on it.',
                                     mtError, [mbOK], 0);
                        end;

                    If ((ExemptionIsBasicVeteran(ExemptionTable.FieldByName('ExemptionCode').AsString) or
                         ExemptionIsAlternativeVeteran(ExemptionTable.FieldByName('ExemptionCode').AsString)) and
                        ExemptionIsColdWarVeteran(FieldByName('ExemptionCode').AsString))
                      then
                        begin
                          ExemptionCodeOK := False;
                          MessageDlg('You cannot add a basic or alternative veteran exemption to a ' + #13 +
                                     'parcel with a Cold War veteran exemption already on it.',
                                     mtError, [mbOK], 0);
                        end;

                    Next;

                  end;  {while not EOF do}

            end;  {If ExemptionCodeOK}

          {If this municipality is not classified, they can not enter a non-residential exemption
           unless there is a residential percent on the parcel.}

(*        If ((not GlblMunicipalityIsClassified) and
            (Deblank(ExemptionCodeLookupTable.FieldByName('ResidentialType').Text) = 'N') and
            (Roundoff(TFloatField(ParcelTable.FieldByName('ResidentialPercent')).Value, 2) = 100))
          then
            begin
              MessageDlg('You can not enter a non-residential exemption on a parcel with a residential percent of 100.' + #13 +
                         'Please check your information.', mtError, [mbOK], 0);
              ExemptionTable.Cancel;
              ExemptionCodeOK := False;
            end; *)

          {Now make sure that they can put this exemption code on for this swis.}

        If ExemptionCodeOK
          then
            begin
              SwisList := TStringList.Create;

              For I := 1 to 20 do
                begin
                  TempStr := 'SW' + IntToStr(I);

                  If (Deblank(ExemptionCodeLookupTable.FieldByName(TempStr).Text) <> '')
                    then SwisList.Add(ExemptionCodeLookupTable.FieldByName(TempStr).Text);

                end;  {For I := 1 to 20 do}

                {Now if there are any swis restrictions, let's compare them versus
                 the swis code for this parcel and see if it fits.}

              If not ValidSwisCodeForExemptionOrSpecialDistrictCode(SwisList,
                                                                    ParcelTable.FieldByName('SwisCode').Text)
                then
                  begin
                    MessageDlg('This exemption code can not be placed on a parcel in this swis code.' + #13 +
                               'Please check your information.', mtError, [mbOK], 0);
                    ExemptionCodeOK := False;
                  end;

              SwisList.Free;

            end;  {If ExemptionCodeOK}

          {CHG12122000-1: Make sure they do not enter a STAR on a vacant land.}
          {CHG05142006-1(2.9.7.3): Allow add of STAR to vacant land, but with a warning.}

        If (ExemptionCodeOK and
            ExemptionIsSTAR(EXCode) and
            (ParcelTable.FieldByName('PropertyClassCode').Text[1] = '3') and
            (MessageDlg('STAR exemptions do not apply to vacant land.' + #13 +
                        'Do you want to add this anyway?', mtWarning, [mbYes, mbNo], 0) = idNo))
          then ExemptionCodeOK := False;

          {CHG03212001-2: Only allow wholly exempt exemptions on vacant lands.}

        If (ExemptionCodeOK and
            GlblAllowOnlyWhollyExemptsOnVacantLand and
            (ParcelTable.FieldByName('PropertyClassCode').Text[1] = '3') and
            (ExemptionCodeLookupTable.FieldByName('CalcMethod').Text <> 'T'))
          then
            begin
              ExemptionCodeOK := False;
              MessageDlg('You can not add an exemption to vacant land that is not wholly exempt.' + #13 +
                         'If you need to add this exemption anyway, you must turn off the' + #13 +
                         '''No Partial Exempts on Vacant Lands'' option in the System Record Maintenance' + #13 +
                         'and try again.', mtError, [mbOK], 0);
            end;

          {CHG04172001-1: Senior percent calculator.}
          {FXX10282002-1: Don't use senior calculator for coops or any 400
                          that is getting a senior.}
          {CHG10072003-1(2.07j): Actually, allow 412 or 411C to be autocalculated.}
          {FXX03232009-1(2.17.1.11): Show the dialog on add of disabled exemption.}

        If (GlblUseSeniorExemptionPercentCalculator and
            ExemptionCodeOK and
            (ExemptionIsSenior(ExemptionTable.FieldByName('ExemptionCode').AsString) or
             ExemptionIsLowIncomeDisabled(ExemptionTable.FieldByName('ExemptionCode').AsString)) and
            (not PropertyIsCoopOrMobileHomePark(ParcelTable)))(* and
            (ParcelTable.FieldByName('PropertyClassCode').Text[1] <> '4'))*)
          then
            begin
              try
                SeniorIncomePercentCalculationForm := TSeniorIncomePercentCalculationForm.Create(nil);

                If (SeniorIncomePercentCalculationForm.ShowModal = idOK)
                  then
                    begin
                      ExemptionTablePercent.ReadOnly  := False;
                      ExemptionTablePercent.AsFloat := SeniorIncomePercentCalculationForm.ExemptionPercent;
                      ExemptionGrid.SetActiveField('Percent');
                      ExemptionGridColExit(Sender);
                      ExemptionAlreadyFilledIn := True;
                    end
                  else ExemptionCodeOK := False;

              finally
                SeniorIncomePercentCalculationForm.Free;
              end;

            end;  {If (ExemptionCodeOK and ...}

          {Set the fields to not read only for now so that they can be filled in.}

        If ExemptionCodeOK
          then
            begin
              If not ExemptionAlreadyFilledIn
                then
                  begin
                    ExemptionTableAmount.ReadOnly  := False;
                    ExemptionTableAmount.Required  := False;
                    ExemptionTablePercent.ReadOnly  := False;
                    ExemptionTablePercent.Required  := False;
                    ExemptionTableOwnerPercent.ReadOnly := False;
                    ExemptionTableOwnerPercent.Required := False;

                    VetMaxSet := False;
                    EqualizationRateFilledIn := False;

                    ExAppliesArray := ExApplies(ExemptionCodeLookupTable.FieldByName('EXCode').Text,
                                                ExemptionTable.FieldByName('ApplyToVillage').AsBoolean);

                    EXAmountsArray := CalculateExemptionAmount(ExemptionCodeLookupTable,
                                                               ExemptionTable,
                                                               ParcelExLookupTable,
                                                               AssessmentTable,
                                                               ClassTable,
                                                               SwisCodeTable,
                                                               ParcelTable,
                                                               TaxRollYr,
                                                               SwisSBLKey,
                                                               FixedPercent,
                                                               VetMaxSet,
                                                               EqualizationRateFilledIn,
                                                               ExemptionRecalculated,
                                                               0, 0, False);

                      {FXX01201998-14: Don't default senior to 50%.
                                       This is to prevent data entry error - they
                                       must enter.}
                      {CHG04161998-1: Add the 4193x limited income diabled
                                      exemption. It is the same as 4180x.}
                      {CHG08132008-1(2.15.1.5): Add 4191x as a low income disabled exemption.}

                    If ((Take(4, ExemptionCodeLookupTable.FieldByName('EXCode').Text) = '4180') or
                        ExemptionIsLowIncomeDisabled(ExemptionCodeLookupTable.FieldByName('EXCode').AsString))
(*                        (Take(4, ExemptionCodeLookupTable.FieldByName('EXCode').Text) = '4193'))*)
                      then
                        begin
                          For I := 1 to 4 do
                            EXAmountsArray[I] := 0;

                          FixedPercent := 0;

                        end;  {If (Take(4, ExemptionCodeLookupTable ...}

                      {Only show the exemption amount for this municipality.}
                      {CHG10151997-3: The amount field in the grid is now a "calculated" field
                                      which is not part of the database. This is because
                                      if we show just town amount, a county only exemption
                                      will have an amount of zero.}

                    ExemptionTablePercent.Value := FixedPercent;

                    ExAppliesArray := ExApplies(ExemptionTable.FieldByName('ExemptionCode').Text,
                                                ExemptionTable.FieldByName('ApplyToVillage').AsBoolean);
                    ExIdx := GetExemptionAmountToDisplay(EXAppliesArray);
                    TCurrencyField(ExemptionTable.FieldByName('Amount')).Value := EXAmountsArray[ExIdx];

                    If (Take(4, ExemptionTableExemptionCode.Text) = '4111')
                      then MessageDlg('Warning! New York state does not allow new 4111x (ratio) veteran exemptions.' + #13 +
                                      'Please make sure that this is correct.', mtWarning, [mbOK], 0);

                      {If the maximum was set for a war veteran, or the vet equalization
                       rate was not filled in, then tell the user.}

                      {CHG04272008(2.12.1.1): Add Cold War veteran exemption.}

                    If (ExemptionIsColdWarVeteran(ExemptionTable.FieldByName('ExemptionCode').AsString) or
                        ExemptionIsAlternativeVeteran(ExemptionTable.FieldByName('ExemptionCode').AsString))
                      then
                        begin
                          If (VetMaxSet and
                              GlblShowVetMaxMessage)
                            then MessageDlg('The exemption amount has been set to the state maximum ' +
                                            'for a veteran of this type.' ,
                                            mtInformation, [mbOK], 0);

                            {If the fixed percent was zero, then the rate was not set and
                             this is an error.}

                          If not EqualizationRateFilledIn
                            then
                              begin
                                MessageDlg('The equalization rate is not' + #13 +
                                           'specified for this swis code.' + #13 +
                                           'Please enter this value in the swis code maintenance.',
                                           mtError, [mbOK], 0);

                                ExemptionTable.Cancel;
                                Abort;

                              end;  {If not EqualizationRateFilledIn}

                        end;  {If (ExemptionIsColdWarVeteran...}

                  end;  {If not ExemptionAlreadyFilledIn}

                {Now set the fields read only or required based on the calculation and
                 exemption codes.}

              SetReadOnlyFields;

            end  {If ExemptionCodeOK}
          else
            begin
              ExemptionTable.Cancel;
              Abort;
            end;

      end;  {If ((not ExemptionTable.ReadOnly) and ...}

end;  {ExCodeDBLookupComboCloseUp}

{============================================================================}
Procedure TParcelExemptionCodeForm.ExemptionGridColEnter(Sender: TObject);

var
  TempField : TCurrencyField;

begin
    {If the field is a currency field, then we will remove the $ and , so that they do not
     get in the way of editing.}

  If (ExemptionGrid.SelectedField is TCurrencyField)
    then
      begin
        TempField := TCurrencyField(ExemptionGrid.SelectedField);

        with TempField do
          If ((DataType = ftCurrency) and
               Currency)
            then DisplayFormat := CurrencyEditDisplay;

      end;  {If (ExemptionGrid.SelectedField is TCurrencyField)}

end;  {ExemptionGridColEnter}

{============================================================================}
Procedure TParcelExemptionCodeForm.ExemptionGridColExit(Sender: TObject);

var
  TempField : TCurrencyField;
  Percent, FixedPercent : Comp;
  Quit, RecalculateExemption,
  VetMaxSet, EqualizationRateFilledIn : Boolean;
  TempStr, CalcCode : String;
  EXAmountsArray : ExemptionTotalsArrayType;
  ExAppliesArray : ExemptionAppliesArrayType;
  ExIdx, I : Integer;
  ExemptionRecalculated : Boolean;

begin
  Quit := False;

    {CHG10151997-3: The amount field in the grid is now a "calculated" field
                    which is not part of the database. This is because
                    if we show just town amount, a county only exemption
                    will have an amount of zero.}

    {If the field is a currency field, then we will set the display back to normal.}

  If (ExemptionGrid.SelectedField is TCurrencyField)
    then
      begin
        TempField := TCurrencyField(ExemptionGrid.SelectedField);

        with TempField do
          If ((DataType = ftCurrency) and
               Currency)
            then DisplayFormat := CurrencyNormalDisplay;

      end;  {If (ExemptionGrid.SelectedField is TCurrencyField)}

    {If this is an aged exemption, make sure that the percent is between 10 and
     50 in increments of 5%.}
    {CHG04161998-1: Add the 4193x limited income diabled
                    exemption. It is the same as 4180x.}
    {CHG08132008-1(2.15.1.5): Add 4191x as a low income disabled exemption.}

  If ((ExemptionGrid.SelectedField.FieldName = 'Percent') and
      (not ExemptionTable.ReadOnly) and
      (not ExemptionTablePercent.ReadOnly) and
      ((Take(4, ExemptionTableExemptionCode.Text) = '4180') or
       ExemptionIsLowIncomeDisabled(ExemptionTableExemptionCode.AsString)))
(*       (Take(4, ExemptionTableExemptionCode.Text) = '4193'))) *)
    then
      begin
        Percent := ExemptionTablePercent.Value;

          {To see if the percent was entered in an increment of 5, we will compare
           the result of 100 * truncating the percent divided by 5 versus
           trucating the percent divided by 5 times 100. If the number is not divisible
           by five, they should not match, i.e. if they entered 17, the left side of
           the equation would be 300 and the right side would be 340, so we would know
           that they did not enter the percent correctly.}

          {FXX02131998-3: Mt. Pleasant allows 5% senior exemption.}
          {FXX03111999-4: Don't worry about % for co-ops or mobile homes.}

        If ((not PropertyIsCoopOrMobileHomePark(ParcelTable)) and
            (Roundoff(Percent, 2) < 5) or
            (Roundoff(Percent, 2) > 50) or
            ((Trunc(Percent / 5) * 100) <> Trunc(Roundoff((Percent / 5), 2) * 100)))
          then
            begin
              Quit := True;
              MessageDlg('Please enter a percent between 5% and 50% in increments of 5% for ' +
                         'this exemption.', mtError, [mbOK], 0);
              Abort;
            end;

      end;  {If ((ExemptionGrid.SelectedField.FieldName = 'Percent') and ...}

    {If they just exited the percent field and this is an exception case,
     then we want to calculate the amount. However, we will only do this if
     the exemption table and the percent field are not read only and the
     calculation code is blank (i.e. variable percent). Note that 4112 and 4113
     (war and combat) veterans exemptions have already been calculated and the
     percent field is read-only}

    {In some cases the calc method is blank (i.e. null), so let's force it to one
     blank space for the case statement below.}

    {We will also recalulate if they just exited the owner percent
     field.}

    {FXX04031998-1: We need to make sure that the exemption code lookup
                    table is pointing to the right exemption before
                    figuring out the calc code. Otherwise, who knows
                    what calc code we will get.}

  FindKeyOld(ExemptionCodeLookupTable, ['EXCode'],
             [ExemptionTableExemptionCode.Text]);

  CalcCode := ExemptionCodeLookupTable.FieldByName('CalcMethod').Text;

  If (Deblank(CalcCode) = '')
    then CalcCode := ' ';

  RecalculateExemption := False;

  ExAppliesArray := ExApplies(ExemptionTable.FieldByName('ExemptionCode').Text,
                              ExemptionTable.FieldByName('ApplyToVillage').AsBoolean);

  If ((ExemptionGrid.SelectedField.FieldName = 'Percent') and
      (not ExemptionTable.ReadOnly) and
      (not ExemptionTablePercent.ReadOnly) and
      (CalcCode =  ' ') and
      (Deblank(ExemptionTableExemptionCode.Text) <> '') and
      (not Quit))
    then RecalculateExemption := True;

  If ((ExemptionGrid.SelectedField.FieldName = 'OwnerPercent') and
      (not ExemptionTable.ReadOnly) and
      (not ExemptionTableOwnerPercent.ReadOnly) and
      (Deblank(ExemptionTableExemptionCode.Text) <> '') and
      (not Quit))
    then RecalculateExemption := True;

  If ((ExemptionGrid.SelectedField.FieldName = 'HomesteadCode') and
      (not ExemptionTable.ReadOnly) and
      (not ExemptionTableHomesteadCode.ReadOnly) and
      (Deblank(ExemptionTableExemptionCode.Text) <> '') and
      (not Quit))
    then RecalculateExemption := True;

    {Ramapo has some total exemptions (type T) where they put a percent
     on the exemption rather than in the res. percent.}

  If ((ExemptionGrid.SelectedField.FieldName = 'Percent') and
      (not ExemptionTable.ReadOnly) and
      (not ExemptionTablePercent.ReadOnly) and
      (CalcCode[1] in [EXCMethT, EXCMethI, EXCMethL]) and
      (Deblank(ExemptionTableExemptionCode.Text) <> '') and
      (not Quit))
    then RecalculateExemption := True;

    {FXX03231998-1: Need to recalculate when leave amount field if
                    variable amount exemption.}

  If ((ExemptionGrid.SelectedField.FieldName = 'Amount') and
      (not ExemptionTable.ReadOnly) and
      (not ExemptionTableAmount.ReadOnly) and
      (CalcCode[1] = EXCMethV) and
      (Deblank(ExemptionTableExemptionCode.Text) <> '') and
      (not Quit))
    then RecalculateExemption := True;

    {CHG01292008(2.11.7.4): STAR can now have a percent.}

  If (_Compare(ExemptionGrid.SelectedField.FieldName, 'Percent', coEqual) and
      (not ExemptionTable.ReadOnly) and
      (not ExemptionTablePercent.ReadOnly) and
      ExemptionIsSTAR(ExemptionTableExemptionCode.Text) and
      (not Quit))
    then RecalculateExemption := True;

    {FXX03261998-3: Only recalc if in edit or insert mode so don't get
                    error in re-edit case.}

  If (RecalculateExemption and
      (ExemptionTable.State in [dsEdit, dsInsert]))
    then
      begin
          {Set the fields to not read only for now so that they can be filled in.}

        ExemptionTableAmount.ReadOnly  := False;
        ExemptionTableAmount.Required  := False;
        ExemptionTablePercent.ReadOnly  := False;
        ExemptionTablePercent.Required  := False;

        VetMaxSet := False;
        EqualizationRateFilledIn := False;

        EXAmountsArray := CalculateExemptionAmount(ExemptionCodeLookupTable,
                                                   ExemptionTable,
                                                   ParcelExLookupTable,
                                                   AssessmentTable,
                                                   ClassTable,
                                                   SwisCodeTable,
                                                   ParcelTable,
                                                   TaxRollYr,
                                                   SwisSBLKey,
                                                   FixedPercent,
                                                   VetMaxSet,
                                                   EqualizationRateFilledIn,
                                                   ExemptionRecalculated,
                                                   0, 0, False);

          {Only show the exemption amount for this municipality.}

        ExIdx := GetExemptionAmountToDisplay(EXAppliesArray);
        TCurrencyField(ExemptionTable.FieldByName('Amount')).Value := EXAmountsArray[ExIdx];

        {If the maximum was set for a war veteran, or the vet equalization
         rate was not filled in, then tell the user.}

          {CHG04272008(2.12.1.1): Add Cold War veteran exemption.}

        If (ExemptionIsColdWarVeteran(ExemptionTable.FieldByName('ExemptionCode').AsString) or
            ExemptionIsAlternativeVeteran(ExemptionTable.FieldByName('ExemptionCode').AsString))
          then
            begin
                {CHG10121998-1: Add user options for default destination and show vet max msg.}

              If (VetMaxSet and
                  GlblShowVetMaxMessage)
                then MessageDlg('The exemption amount has been set to the state maximum ' +
                                'for a disabled veteran.' ,
                                mtInformation, [mbOK], 0);

                {If the fixed percent was zero, then the rate was not set and
                 this is an error.}

              If not EqualizationRateFilledIn
                then
                  begin
                    MessageDlg('The equalization rate is not' + #13 +
                               'specified for this swis code.' + #13 +
                               'Please enter this value in the swis code maintenance.',
                               mtError, [mbOK], 0);

                    ExemptionTable.Cancel;
                    Abort;

                  end;  {If not EqualizationRateFilledIn}

            end;  {If (Take(4, ExemptionTableExemptionCode.Text) = '4112')}

      end;  {If ((ExemptionGrid.SelectedField.FieldName = 'Percent') and ...}

    {Make sure that they only enter an 'N' or 'H' in the homestead column and that this is a split
     parcel.}

  If ((ExemptionGrid.SelectedField.FieldName = 'HomesteadCode') and
      (not ExemptionTable.ReadOnly))
    then
      begin
        TempStr := ExemptionTable.FieldByName('HomesteadCode').Text;
        TempStr := UpcaseStr(TempStr);

        If (Deblank(TempStr) <> '')
          then
            If (TempStr[1] in ['H', 'N'])
              then
                begin
                    {They entered a homestead code, so make sure that this is a split parcel.}

                  If (ParcelTable.FieldByName('HomesteadCode').Text[1] = 'S')
                    then
                      begin
                           {Make sure that the entry is capitalized.}

                        If (TempStr <> ExemptionTable.FieldByName('HomesteadCode').Text)
                          then ExemptionTable.FieldByName('HomesteadCode').Text := TempStr;

                      end
                    else
                      begin
                        MessageDlg('You can only enter a homestead code for an exemption on a split parcel.',
                                   mtError, [mbOK], 0);
                        Abort;
                      end;

                end
              else
                begin
                    {They did not enter the correct homestead code.}

                  MessageDlg('Please enter an ''H'' or ''N'' for the homestead code.', mtError, [mbOK], 0);
                  Abort;
                end;

      end;  {If ((ExemptionGrid.SelectedField.FieldName = 'HomesteadCode') and ...}

    {FXX03021998-7: Need to set county, town, or school amounts to the
                    variable amount just entered by the user.  Worked
                    fine for exemption adds, but had problems if decreased
                    variable amount.}

  If ((ExemptionGrid.SelectedField.FieldName = 'Amount') and
      (not ExemptionTable.ReadOnly) and
      (CalcCode[1] = EXCMethV))
    then
      begin
        with ExemptionTable do
          For I := 1 to 3 do
            If ExAppliesArray[I]
              then
                case I of
                  EXCounty : FieldByName('CountyAmount').AsFloat := FieldByName('Amount').AsFloat;
                  EXTown : FieldByName('TownAmount').AsFloat := FieldByName('Amount').AsFloat;
                  EXSchool : FieldByName('SchoolAmount').AsFloat := FieldByName('Amount').AsFloat;

                end;  {case I of}

      end;  {If ((ExemptionGrid.SelectedField.FieldName = 'Amount') ...}

end;  {ExemptionGridColExit}

{==============================================================}
Procedure TParcelExemptionCodeForm.EditBIEButtonClick(Sender: TObject);

{CHG11171999-1: BIE support.}

begin
  If ((not ExemptionTable.ReadOnly) and
      IsBIEExemptionCode(ExemptionTable.FieldByName('ExemptionCode').Text))
    then
      begin
        BIEDoneButtonPressed := False;
        ExemptionTableOriginalBIEAmount.DisplayFormat := CurrencyEditDisplay;
        EditBIEPanel.Show;

          {If the table is not in edit mode, put it there.}

        If (ExemptionTable.State = dsBrowse)
          then ExemptionTable.Edit;

      end;  {If ((not ExemptionTable.ReadOnly) and ...}

end;  {EditBIEButtonClick}

{==============================================================}
Procedure TParcelExemptionCodeForm.EditBIEPanelExit(Sender: TObject);

begin
  If not BIEDoneButtonPressed
    then Abort;

end;  {EditBIEPanelExit}

{==============================================================}
Procedure TParcelExemptionCodeForm.DoneBIEButtonClick(Sender: TObject);

begin
  BIEDoneButtonPressed := True;
  EditBIEPanel.Hide;
end;

{==============================================================}
Procedure TParcelExemptionCodeForm.ExemptionTableBeforePost(DataSet: TDataset);

{If this user wants save confirmation, then ask it here.
 Otherwise, do not. If we are closing the form, then we want
 to ask the question no matter what.}
{We will see if they are switching a parcel to\from roll section 8 and
 ask for confirmation if they are. Further, we will make sure that the
 total of the exemptions do not exceed the assessed value of the parcel.}

var
  ExIdx, I, ReturnCode : Integer;
  AllCodesAreWhollyExempt, TurnOffAutoRenew,
  FirstTimeThrough, Done,
  VetMaxSet, EqualizationRateFilledIn, ProceedWithPost : Boolean;
  TotalExemption : LongInt;
  EXAmountsArray : ExemptionTotalsArrayType;
  ExAppliesArray : ExemptionAppliesArrayType;
  FixedPercent : Comp;
  PropertyClass : String;
  ExemptionRecalculated : Boolean;

begin
  ProceedWithPost := True;
  ExAppliesArray := ExApplies(ExemptionTable.FieldByName('ExemptionCode').Text,
                              ExemptionTable.FieldByName('ApplyToVillage').AsBoolean);

  If (Deblank(ExemptionTableExemptionCode.Text) = '')
    then
      begin
        ProceedWithPost := False;
        MessageDlg('Please enter an exemption code.', mtError, [mbOK], 0);
        ExemptionGrid.SetFocus;
        Abort;

      end;  {If (Deblank(ExemptionTableExemptionCode.Text) = '')}

    {FXX03041998-3: The exemption amount may be zero because they never
                    left the field (amount or %) that would set the
                    amount.  So, before saying there is no amount, let's
                    recalculate and see if we still end up with zero.}

  If (Roundoff(ExemptionTableAmount.Value, 2) = 0)
    then
      begin
          {Set the fields to not read only for now so that they can be filled in.}

        ExemptionTableAmount.ReadOnly  := False;
        ExemptionTableAmount.Required  := False;
        ExemptionTablePercent.ReadOnly  := False;
        ExemptionTablePercent.Required  := False;

        VetMaxSet := False;
        EqualizationRateFilledIn := False;

        EXAmountsArray := CalculateExemptionAmount(ExemptionCodeLookupTable,
                                                   ExemptionTable,
                                                   ParcelExLookupTable,
                                                   AssessmentTable,
                                                   ClassTable,
                                                   SwisCodeTable,
                                                   ParcelTable,
                                                   TaxRollYr,
                                                   SwisSBLKey,
                                                   FixedPercent,
                                                   VetMaxSet,
                                                   EqualizationRateFilledIn,
                                                   ExemptionRecalculated,
                                                   0, 0, False);

          {Only show the exemption amount for this municipality.}

        ExIdx := GetExemptionAmountToDisplay(EXAppliesArray);
        TCurrencyField(ExemptionTable.FieldByName('Amount')).Value := EXAmountsArray[ExIdx];

          {FXX04272006-1(2.9.6.6): Fix the case where a parcel is already exempt for 1 or more juristdictions due to
                                   a different exemption, but a new exemption should apply to a different, non-main
                                   juristdiction.

                                   For example, a condo with a low AV has a vet making it exemption for county \ town.
                                   They now are going to get an Aged-All, but PAS would not allow it because it
                                   calculated to 0 for the main jurisdiction (town).}

        with ExemptionTable do
          If _Compare(FieldByName('Amount').AsInteger, 0, coEqual)
            then
              begin
                If _Compare(Trunc(EXAmountsArray[ExCounty]), 0, coGreaterThan)
                  then FieldByName('Amount').AsInteger := Trunc(EXAmountsArray[ExCounty]);

                If (_Compare(FieldByName('Amount').AsInteger, 0, coEqual) and
                    _Compare(Trunc(EXAmountsArray[ExTown]), 0, coGreaterThan))
                  then FieldByName('Amount').AsInteger := Trunc(EXAmountsArray[ExTown]);

                If (_Compare(FieldByName('Amount').AsInteger, 0, coEqual) and
                    _Compare(Trunc(EXAmountsArray[ExSchool]), 0, coGreaterThan))
                  then FieldByName('Amount').AsInteger := Trunc(EXAmountsArray[ExSchool]);

              end;  {If _Compare(FieldByName('Amount').AsFloat, coEqual, 0)}

          {If the maximum was set for a war veteran, or the vet equalization
           rate was not filled in, then tell the user.}

          {CHG04272008(2.12.1.1): Add Cold War veteran exemption.}

        If (ExemptionIsColdWarVeteran(ExemptionTable.FieldByName('ExemptionCode').AsString) or
            ExemptionIsAlternativeVeteran(ExemptionTable.FieldByName('ExemptionCode').AsString))
          then
            begin
              If (VetMaxSet and
                  GlblShowVetMaxMessage)
                then MessageDlg('The exemption amount has been set to the state maximum ' +
                                'for a disabled veteran.' ,
                                mtInformation, [mbOK], 0);

                {If the fixed percent was zero, then the rate was not set and
                 this is an error.}

              If not EqualizationRateFilledIn
                then
                  begin
                    MessageDlg('The equalization rate is not' + #13 +
                               'specified for this swis code.' + #13 +
                               'Please enter this value in the swis code maintenance.',
                               mtError, [mbOK], 0);

                    ExemptionTable.Cancel;
                    Abort;

                  end;  {If not EqualizationRateFilledIn}

            end;  {If (Take(4, ExemptionTableExemptionCode.Text) = '4112')}

      end;  {If (Roundoff(ExemptionTableAmount.Value, 2) = 0)}


  If (Roundoff(ExemptionTableAmount.Value, 2) = 0)
    then
      begin
        ProceedWithPost := False;
        MessageDlg('Please enter an amount.', mtError, [mbOK], 0);
        ExemptionGrid.SetFocus;
        Abort;

      end;  {If (Roundoff(ExemptionTableAmount, 2) = 0)}

  If ProceedWithPost
    then
      begin
        ExemptionGridColExit(ExemptionGrid);

          {Figure out what the original exemption total was (for the
           municipality type, subtract the old amount of this type, and
           add the new amount so that we can see if they are now wholly
           exempt or are going to lose their wholly exempt status.}
          {FXX11161999-1: Redo computation of original exemption.}

        FirstTimeThrough := True;
        Done := False;
        TotalExemption := 0;
        ParcelExLookupTable.CancelRange;
        SetRangeOld(ParcelExLookupTable,
                    ['TaxRollYr', 'SwisSBLKey', 'ExemptionCode'],
                    [TaxRollYr, SwisSBLKey, '     '],
                    [TaxRollYr, SwisSBLKey, 'ZZZZZ']);

        repeat
          If FirstTimeThrough
            then FirstTimeThrough := False
            else ParcelExLookupTable.Next;

          If ParcelExLookupTable.EOF
            then Done := True;

            {If autoincrement ID matches, it is the exemption they are on and use
             most recent.}

          If not Done
            then
              If (ParcelEXLookupTable.FieldByName('AutoIncrementID').AsInteger =
                  ExemptionTable.FieldByName('AutoIncrementID').AsInteger)
                then TotalExemption := TotalExemption + ExemptionTable.FieldByName('TownAmount').AsInteger
                else TotalExemption := TotalExemption + ParcelEXLookupTable.FieldByName('TownAmount').AsInteger

        until Done;

          {If insert state, not in lookup table yet, so not included in totals.}
          {FXX05012000-7: At this point, the exemption amounts for the individual
                          entities (i.e. school, town) have not been filled in,
                          so must pull from the amount field, but only if it applies
                          to town purposes.}

        If ((ExemptionTable.State = dsInsert) and
            EXAppliesArray[RTTown])
          then TotalExemption := TotalExemption + ExemptionTable.FieldByName('Amount').AsInteger;

        (*TotalExemption := OrigExAmounts[GetMunicipalityType(GlblMunicipalityType)];

          {FXX03261998-8: Look at the Amount field to see if this is now
                          wholly exempt, not just the town amount field.}

        NewExemptionAmount := TCurrencyField(ExemptionTable.FieldByName('Amount')).Value;

          {FXX11021999-11: Was asking if RS 8 for wholly exempt even if it was a STAR.}

        If (ExemptionCodeLookupTable.FieldByName('CalcMethod').Text = EXCMethT)
          then TotalExemption := TotalExemption - OrigExAmounts[GetMunicipalityType(GlblMunicipalityType)] +
                                 NewExemptionAmount; *)

          {Now see if the exemption amounts equal the assessed value.}
          {FXX07281998-2: Make this an option - if they say no, do not cancel.
                          Also if this is a STAR exemption and they now owe no taxes, don't
                          make rs 8.}

(*        AddingSTAR := (ExemptionTable.State = dsInsert) and
                      ((ExemptionTable.FieldByName('ExemptionCode').Text = BasicSTARExemptionCode) or
                       (ExemptionTable.FieldByName('ExemptionCode').Text = EnhancedSTARExemptionCode)); *)

          {FXX04272000-5: Only test for rs 1->8 or 8->1 if all ex codes on
                          the parcel are wholly exempt codes, i.e. start
                          with 1,2,3 or 5.}
          {FXX05012000-6: Need to look at first char only to determine if wholly
                          exempt code, not whole thing.}

        AllCodesAreWhollyExempt := True;
        For I := 0 to (OrigExemptionCodes.Count - 1) do
          If (OrigExemptionCodes[I][1] = '4')
            then AllCodesAreWhollyExempt := False;

        If ((ExemptionTable.State = dsInsert) and
            AllCodesAreWhollyExempt and
            (ExemptionTable.FieldByName('ExemptionCode').Text[1] = '4'))
          then AllCodesAreWhollyExempt := False;

        If ((TotalExemption = AssessmentTable.FieldByName('TotalAssessedVal').AsInteger) and
            (Take(1, ParcelTable.FieldByName('RollSection').Text) <> '8') and
            AllCodesAreWhollyExempt)
          then
            begin
              ProceedWithPost := False;

              ReturnCode := MessageDlg('This parcel is now wholly exempt.' + #13 +
                                       'Do you want to move this parcel to roll section 8?',
                                       mtConfirmation, [mbYes, mbNo, mbCancel], 0);

              case ReturnCode of
                idYes : begin
                          MoveToRollSection8 := True;
                          ProceedWithPost := True;
                        end;

                idNo : ProceedWithPost := True;  {Post but don't move to rs 8.}

                idCancel : Abort;

              end;  {case ReturnCode of}

            end;  {If ((Roundoff(DefaultTotalExemption, 0) = ...}

          {Now see if the exemption amounts equal the assessed value.}

        If ((TotalExemption < AssessmentTable.FieldByName('TotalAssessedVal').AsInteger) and
            (Take(1, ParcelTable.FieldByName('RollSection').Text) = '8') and
            AllCodesAreWhollyExempt)
          then
            begin
              ProceedWithPost := False;

              ReturnCode := MessageDlg('This parcel is no longer wholly exempt.' + #13 +
                                       'Do you want to move this parcel to roll section 1?',
                                       mtConfirmation, [mbYes, mbNo, mbCancel], 0);

              case ReturnCode of
                idYes : begin
                          MoveToRollSection1 := True;
                          ProceedWithPost := True;
                        end;

                  {FXX05121999-1: If they say no, do not cancel post - continue.}

                idNo : ProceedWithPost := True;  {Post but don't move to rs 1.}

                idCancel : Abort;

              end;  {case ReturnCode of}

            end;  {If ((Roundoff(DefaultTotalExemption, 0) < ...}

            {Must make sure that the total of the exemptions is not > assessed value.}
            {FXX1117199-1: For now remove this test - move it to warnings.}

        (*If (Roundoff(TotalExemption, 0) > Roundoff(AssessmentTableTotalAssessedVal.Value, 0))
          then
            begin
              MessageDlg('The total of the exemptions can not be greater than the total assessed value.',
                         mtError, [mbOK], 0);

              If (ExemptionTable.State = dsInsert)
                then ExemptionTable.Cancel
                else RefreshNoPost(ExemptionTable);

              ProceedWithPost := False;

            end
          else ProceedWithPost := True; *)

          {FXX12011998-19: Don't allow them to have exemption approved and
                           denied checked.}

(*        with ExemptionTable do
          If (ProceedWithPost and
              FieldByName('ExemptionApproved').AsBoolean and
              FieldByName('ExemptionDenied').AsBoolean)
            then
              begin
                MessageDlg('You can not mark an exemption both approved and denied.' + #13 +
                           'Please review.', mtError, [mbOK], 0);
                ProceedWithPost := False;
              end; *)

          {FXX04181999-3: 4 Exemptions got out without a code.}

        If (ProceedWithPost and
            ((Deblank(ExemptionTableExemptionCode.Text) = '') or
             (Deblank(ExemptionTableTaxRollYr.Text) = '') or
             (Deblank(ExemptionTableSwisSBLKey.Text) = '')))
          then
            begin
              NonBtrvSystemSupport(098, 999, 'Blank exemption code, tax roll yr, or parcel ID. Call SCA immediatly.',
                                   UnitName, GlblErrorDlgBox);
              ProceedWithPost := False;
            end;

          {CHG06062001-1: STAR can now be placed on mixed use 400 prop class.}

        PropertyClass := ParcelTable.FieldByName('PropertyClassCode').Text;

        If (ProceedWithPost and
            ExemptionIsSTAR(ExemptionTable.FieldByName('ExemptionCode').Text) and
            ((PropertyClass[1] = '4') and
             (PropertyClass <> '411')) and
            (MessageDlg('Warning! You are about to add a STAR exemption to a' + #13 +
                        'commercial / mixed-use property class that is not a condominium.' + #13 +
                        'Is this correct?', mtConfirmation, [mbYes, mbNo], 0) = idNo))
          then
            begin
              ProceedWithPost := False;
              ExemptionTable.Cancel;
              Abort;
            end;

          {CHG11171999-1: BIE exemption support.}
          {If they are inserting a new BIE exemption, record the original amount.}
          {FXX12112005-1(2.9.4.3): Only set the original BIE if this is a new exemption, not an edit.}

        If (ProceedWithPost and
            (ExemptionTable.State = dsInsert) and
            IsBIEExemptionCode(ExemptionTable.FieldByName('ExemptionCode').Text))
          then ExemptionTable.FieldByName('OriginalBIEAmount').AsFloat :=
                            ExemptionTable.FieldByName('Amount').AsFloat;

          {FXX09132001-8: The renewal received date was not being checked.}

        If (ProceedWithPost and
            (not RenewalReceivedChecked) and
            ExemptionTable.FieldByName('RenewalReceived').AsBoolean)
          then ExemptionTable.FieldByName('DateRenewalReceived').AsDateTime := Date;

          {CHG10242002-1: If they selected auto renew, make sure it is on an
                          enhanced STAR with no additional senior.}

        If (ProceedWithPost and
            ExemptionTable.FieldByName('AutoRenew').AsBoolean)
          then
            begin
              TurnOffAutoRenew := False;

                {FXX09062007-1(2.11.3.9)[D]: The basic STAR can have the IVP mark.}

              If _Compare(ExemptionTable.FieldByName('ExemptionCode').AsString, EnhancedSTARExemptionCode, coEqual)
                then
                  begin
                    FindNearestOld(ParcelExLookupTable,
                                   ['TaxRollYr', 'SwisSBLKey', 'ExemptionCode'],
                                   [TaxRollYr, SwisSBLKey, '4180 ']);

                    If (Take(4, ParcelExLookupTable.FieldByName('ExemptionCode').Text) = '4180')
                      then TurnOffAutoRenew := True;

                  end
                else
                  If _Compare(ExemptionTable.FieldByName('ExemptionCode').AsString, BasicSTARExemptionCode, coNotEqual)
                    then TurnOffAutoRenew := True;

              If TurnOffAutoRenew
                then
                  begin
                    ExemptionTable.FieldByName('AutoRenew').AsBoolean := False;
                    MessageDlg('The auto renew flag has been turned off for this exemption.' + #13 +
                               'This feature only applies to people enrolled in the state' + #13 +
                               ' auto renewal program for enhanced STARs who do not also have senior exemptions.',
                               mtError, [mbOK], 0);

                  end;  {If TurnOffAutoRenew}


            end;  {If (ProceedWithPost and ...}

          {Now confirm that they want to save this record.}
          {FXX05151998-3: Don't ask save on close form if don't want to see save.}

        If (ProceedWithPost and
            GlblAskSave)
          then
            begin
                 {FXX11061997-2: Remove the "save before exiting" prompt because it
                                 is confusing. Use only "Do you want to save.}

              ReturnCode := MessageDlg('Do you wish to save your exemption changes?', mtConfirmation,
                                       [mbYes, mbNo, mbCancel], 0);

              case ReturnCode of
                idNo : If (ExemptionTable.State = dsInsert)
                         then ExemptionTable.Cancel
                         else RefreshNoPost(ExemptionTable);

                idCancel : Abort;

              end;  {case ReturnCode of}

            end;  {If GlblAskSave}

    end;  {else of If (Deblank(ExemptionTableExemptionCode.Text) = '')}

end;  {ExemptionTableBeforePost}

{==============================================================}
Function CheckIfOppositeYearHasSTAROrDuplicate(ExemptionTable,
                                               OppositeYearExemptionTable,
                                               OppositeYearParcelTable : TTable;
                                               OppositeTaxYear : String;
                                               SwisSBLKey : String) : Boolean;

{FXX02221999-1: Make sure not to put a STAR on opposite year if already exists.}

var
  BasicSTARFound, EnhancedSTARFound,
  DuplicateFound, Done, FirstTimeThrough : Boolean;

begin
  BasicSTARFound := False;
  EnhancedSTARFound := False;

  OppositeYearExemptionTable.CancelRange;
  SetRangeOld(OppositeYearExemptionTable,
              ['TaxRollYr', 'SwisSBLKey', 'ExemptionCode'],
              [OppositeTaxYear, SwisSBLKey, '     '],
              [OppositeTaxYear, SwisSBLKey, 'ZZZZZ']);

  FirstTimeThrough := True;
  Done := False;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else OppositeYearExemptionTable.Next;

    If OppositeYearExemptionTable.EOF
      then Done := True;

    If not Done
      then
        begin
          If (OppositeYearExemptionTable.FieldByName('ExemptionCode').Text = BasicSTARExemptionCode)
            then BasicSTARFound := True;

          If (OppositeYearExemptionTable.FieldByName('ExemptionCode').Text = EnhancedSTARExemptionCode)
            then EnhancedSTARFound := True;

(*          If (OppositeYearExemptionTable.FieldByName('ExemptionCode').Text =
              ExemptionTable.FieldByName('ExemptionCode').Text)
            then DuplicateFound := True; *)

        end;  {If not Done}

  until Done;

     {FXX12101999-1: Do not check to see if opposite year has duplicate (non STAR) -
                     if they are adding a second exemption on TY, add it on NY.}

  DuplicateFound := False;
  Result := False;

  If (PropertyIsCoopOrMobileHomePark(OppositeYearParcelTable) and
      (BasicSTARFound or EnhancedSTARFound))
    then
      begin
          {For co-ops and mobile homes, can have both STARs.}

        If ((ExemptionTable.FieldByName('ExemptionCode').Text = BasicSTARExemptionCode) and
            BasicSTARFound)
          then Result := True;

        If ((ExemptionTable.FieldByName('ExemptionCode').Text = EnhancedSTARExemptionCode) and
            EnhancedSTARFound)
          then Result := True;

      end
    else
      If ((ExemptionIsSTAR(ExemptionTable.FieldByName('ExemptionCode').Text) and
           (BasicSTARFound or EnhancedSTARFound)) or
          DuplicateFound)
        then Result := True;

end;  {CheckIfOppositeYearHasSTARorDuplicate}

{==============================================================}
Procedure TParcelExemptionCodeForm.AutoAddEnhancedSTAR(TaxRollYr : String;
                                                       SwisSBLKey : String;
                                                       ExemptionCodeLookupTable,
                                                       ExemptionTable,
                                                       AssessmentTable,
                                                       ParcelEXLookupTable,
                                                       ParcelTable : TTable;
                                                       OrigBasicSTARAmount,
                                                       OrigEnhancedSTARAmount : Comp;
                                                       OrigSchoolExemptionAmounts : TStringList;
                                                       DisplayMessage,
                                                       OppositeYear : Boolean);

{FXX07281999-4: Make sure auto add of STAR goes from TY to NY.}

var
  EnhancedSTARExists, BasicSTARExists : Boolean;
  TempSchoolExemptionAmounts : TStringList;
  FullSTARAmount, STARAmount,
  BasicSTARAmount, EnhancedSTARAmount : Comp;
  ResidentialPercent : Real;
  I : Integer;
  TempStr : String;
  ExemptionCodes,
  ExemptionHomesteadCodes,
  ResidentialTypes,
  CountyExemptionAmounts,
  TownExemptionAmounts,
  SchoolExemptionAmounts,
  VillageExemptionAmounts : TStringList;
  ResidentialExemptionAmounts,
  FullParcelExemptionAmounts,
  NonResidentialExemptionAmounts : ExemptionTotalsArrayType;

begin
  EnhancedSTARExists := False;

    {FXX12041997-1: To check to see if STAR exists,
                    must see if STAR amounts > 0, not
                    check the ex codes list since it won't
                    be in there.}

  If (Roundoff(OrigEnhancedSTARAmount, 0) > 0)
    then EnhancedSTARExists := True;

  If not EnhancedSTARExists
    then
      begin
        with ParcelEXLookupTable do
          try
              {We need to create a copy of the original school
               exemption amounts and add the new aged exemption
               amount to it. We do not want to get all exemptions
               again, because we only want the exemption totals
               again for roll total adjustment after we are done
               with all of these changes.}

            TempSchoolExemptionAmounts := TStringList.Create;

            For I := 0 to (OrigSchoolExemptionAmounts.Count - 1) do
              TempSchoolExemptionAmounts.Add(OrigSchoolExemptionAmounts[I]);

            FindKeyOld(ParcelExLookupTable,
                       ['TaxRollYr', 'SwisSBLKey', 'ExemptionCode'],
                       [TaxRollYr, SwisSBLKey,
                        ExemptionTableExemptionCode.Text]);

            ParcelEXLookupTableSchoolAmount.DisplayFormat := CurrencyEditDisplay;
            TempSchoolExemptionAmounts.Add(ParcelEXLookupTable.FieldByName('SchoolAmount').Text);

            FindKeyOld(ExemptionCodeLookupTable, ['EXCode'],
                       [EnhancedSTARExemptionCode]);

            ResidentialPercent := GetResidentialPercent(ParcelTable,
                                                        ExemptionCodeLookupTable,
                                                        FieldByName('ExemptionCode').Text);

              {FXX05172010-1(2.24.2.4)[I7209]: Only take residential amounts in to account
                                              for calculating STAR.}

            ExemptionCodes := TStringList.Create;
            ExemptionHomesteadCodes := TStringList.Create;
            ResidentialTypes := TStringList.Create;
            CountyExemptionAmounts := TStringList.Create;
            TownExemptionAmounts := TStringList.Create;
            SchoolExemptionAmounts := TStringList.Create;
            VillageExemptionAmounts := TStringList.Create;

            TotalExemptionsForParcel(ExemptionTable.FieldByName('TaxRollYr').Text,
                                     ExemptionTable.FieldByName('SwisSBLKey').Text,
                                     ParcelEXLookupTable,
                                     ExemptionCodeLookupTable,
                                     ParcelTable.FieldByName('HomesteadCode').Text,
                                     'A',
                                     ExemptionCodes,
                                     ExemptionHomesteadCodes,
                                     ResidentialTypes,
                                     CountyExemptionAmounts,
                                     TownExemptionAmounts,
                                     SchoolExemptionAmounts,
                                     VillageExemptionAmounts,
                                     BasicSTARAmount,
                                     EnhancedSTARAmount);

            GetResidentialExemptionAmounts(ResidentialExemptionAmounts,
                                           FullParcelExemptionAmounts,
                                           NonResidentialExemptionAmounts,
                                           ResidentialTypes,
                                           CountyExemptionAmounts,
                                           TownExemptionAmounts,
                                           SchoolExemptionAmounts,
                                           VillageExemptionAmounts);

              {FXX05202010-1(2.24.2.6): Make sure to reaccess the STAR exemption code.}

            FindKeyOld(ExemptionCodeLookupTable, ['EXCode'],
                       [EnhancedSTARExemptionCode]);

            STARAmount := CalculateSTARAmount(ExemptionCodeLookupTable,
                                              ExemptionTable,
                                              ParcelTable,
                                              AssessmentTable.FieldByName('TotalAssessedVal').AsFloat,
                                              ResidentialPercent, 0,
                                              Trunc(ResidentialExemptionAmounts[EXSchool]),
                                              FullSTARAmount);

            ExemptionCodes.Free;
            ExemptionHomesteadCodes.Free;
            ResidentialTypes.Free;
            CountyExemptionAmounts.Free;
            TownExemptionAmounts.Free;
            SchoolExemptionAmounts.Free;
            VillageExemptionAmounts.Free;

            Insert;

            FieldByName('ExemptionCode').Text := EnhancedSTARExemptionCode;
            FieldByName('Amount').AsFloat := STARAmount;
            FieldByName('SchoolAmount').AsFloat := STARAmount;
            FieldByName('InitialDate').AsDateTime := Date;
            FieldByName('TaxRollYr').Text := TaxRollYr;
            FieldByName('SwisSBLKey').Text := SwisSBLKey;

              {FXX03272003-1(2.06q1): The other amounts for the auto-added enhanced STAR were not
                                      being filled in as 0.}

            FieldByName('CountyAmount').AsFloat := 0;
            FieldByName('TownAmount').AsFloat := 0;
            FieldByName('VillageAmount').AsFloat := 0;
            FieldByName('ApplyToVillage').AsBoolean := False;

              {Do not mark an NY exemption approved automatically.}

            If not OppositeYear
              then FieldByName('ExemptionApproved').AsBoolean := True;

              {If this is a split parcel make sure that the
               exemption goes on the homestead part.}

            If (ParcelTable.FieldByName('HomesteadCode').Text = 'S')
              then FieldByName('HomesteadCode').Text := 'H';

            Post;

            TempSchoolExemptionAmounts.Free;
          except
            SystemSupport(061, ParcelEXLookupTable, 'Error auto-adding Enhanced STAR exemption.',
                          UnitName, GlblErrorDlgBox);
          end;

        TempStr := 'An enhanced STAR exemption has automatically been added.';

          {FXX12041997-1: To check to see if STAR exists,
                          must see if STAR amounts > 0, not
                          check the ex codes list since it won't
                          be in there.}

        BasicSTARExists := False;

        If (Roundoff(OrigBasicSTARAmount, 0) > 0)
          then BasicSTARExists := True;

          {Delete the basic star.}

        If (BasicSTARExists and
            (not PropertyIsCoopOrMobileHomePark(ParcelTable)))
          then
            with ParcelEXLookupTable do
              try
                FindKeyOld(ParcelEXLookupTable,
                           ['TaxRollYr', 'SwisSBLKey', 'ExemptionCode'],
                           [TaxRollYr, SwisSBLKey, '41854']);

                Delete;

                TempStr := TempStr + #13 +
                           'Also, the basic STAR exemption has been deleted.';

              except
                on E:Exception do
                  SystemSupport(062, ParcelEXLookupTable,
                                'Error deleting basic STAR exemption.' + #13 +
                                E.Message,
                                UnitName, GlblErrorDlgBox);
              end;

        If DisplayMessage
          then MessageDlg(TempStr, mtInformation, [mbOK], 0);

      end;  {If not EnhancedSTARExists}

end;  {AutoAddEnhancedSTAR}

{==============================================================}
Procedure TParcelExemptionCodeForm.ExemptionTableAfterPost(DataSet: TDataset);

{Now let's call RecordChanges which will insert a record into the trace file if any differences
 exist.
 Note that RecordChanges returns an integer saying how many changes there
 were. If this number is greater than 0, then we will update the
 name and date changed fields of the parcel record.}

var
  HstdAssessedVal, NonhstdAssessedVal,
  HstdLandVal, NonhstdLandVal : Comp;
  TotalOwnerPercent,
  HstdAcres, NonhstdAcres : Real;
  Done, FirstTimeThrough,
  AssessmentRecordFound, ClassRecordFound : Boolean;
  NewRollSection : String;  {The roll section might have changed.}
  NewExemptionCodes,
  NewExemptionHomesteadCodes,
  NewResidentialTypes,
  NewCountyExemptionAmounts,
  NewTownExemptionAmounts,
  NewSchoolExemptionAmounts,
  NewVillageExemptionAmounts : TStringList;
  NewBasicSTARAmount, NewEnhancedSTARAmount : Comp;
  NewSDAmounts : TList;
  ExAmounts : ExemptionTotalsArrayType;

    {CHG10281997-1: Dual mode processing.}

  Found, Quit, ExemptionDenied, ResultedFromSale : Boolean;

  OppositeYearExemptionCodeTable,
  OppositeYearParcelSDTable,
  OppositeYearAssessmentTable,
  OppositeYearParcelTable,
  OppositeYearClassTable,
  OppositeYearSwisCodeTable,
  OppositeYearSDCodeTable : TTable;

  SBLRec : SBLRecord;
  FieldNamesList : TStringList;

  TempSchoolExemptionAmounts : TStringList;
  STARAmount, FullSTARAmount, TotalAssessedValue : Comp;
  OppositeYearHasSTAR, AgedExists, EnhancedSTARExists, BasicSTARExists, AddEnhancedSTAR : Boolean;
  TempStr : String;
  BasicSTARCode : String;
  I : Integer;
  AutoIncrementID : LongInt;
  NewAuditEXChangeList : TList;
  OppositeYearBookmark, Bookmark : TBookmark;
  NumChanges : Integer;
  EffectiveDateRemoved : TDateTime;
  ExemptionRecalculated : Boolean;

begin
  NewAuditEXChangeList := TList.Create;

    {FXX03261998-7: Bookmark the original exemption so don't lose it
                    when do audit trail.}
    {FXX12301999-3: Make sure to always carry changes forward if they want them.}

  Bookmark := ExemptionTable.GetBookmark;

      {FXX11101997-3: Pass the screen name into RecordChanges so
                      the screen names are more readable.}

  NumChanges := RecordChanges(Self, 'Exemption', ExemptionTable, SwisSBLKey,
                              FieldTraceInformationList);

  If (DeletingARecord or
      (NumChanges > 0))
    then ParcelChanged := True;

    {CHG07192004-2(2.08): Add reminder to check garbage discount.}

  If (DeletingARecord and
      ExemptionIsSenior(OrigEXCode) and
      (wtGarbageDiscountReminder in GlblWarningOptions))
    then MessageDlg('Please remember to remove the discounted garbage district.',
                    mtError, [mbOK], 0);

    {CHG07192004-2(2.08): Add reminder to check garbage discount.}

  If ((RecordAction = raInserted) and
      ExemptionIsSenior(ExemptionTable.FieldByName('ExemptionCode').Text) and
      (wtGarbageDiscountReminder in GlblWarningOptions))
    then MessageDlg('Please remember to add the discounted garbage district.',
                    mtError, [mbOK], 0);

    {Unless the parcel has changed to roll section 1 or 8, the
     new roll section is the same as the old one.}

  NewRollSection := ParcelTable.FieldByName('RollSection').Text;

  If MoveToRollSection1
    then NewRollSection := '1';
  If MoveToRollSection8
    then NewRollSection := '8';

  NewExemptionCodes := TStringList.Create;
  NewExemptionHomesteadCodes := TStringList.Create;
  NewResidentialTypes := TStringList.Create;
  NewCountyExemptionAmounts := TStringList.Create;
  NewTownExemptionAmounts := TStringList.Create;
  NewSchoolExemptionAmounts := TStringList.Create;
  NewVillageExemptionAmounts := TStringList.Create;
  NewSDAmounts := TList.Create;

    {Since there has been a change to one exemption, we will
     have to recalculate all exemptions, thus we will have to
     recalculate the swis and school totals since these might
     be affected, too.}

  RecalculateExemptionsForParcel(ExemptionCodeLookupTable,
                                 ParcelExLookupTable,
                                 AssessmentTable,
                                 ClassTable,
                                 SwisCodeTable,
                                 ParcelTable,
                                 TaxRollYr, SwisSBLKey, nil,
                                 0, 0, False);

    {CHG12011997-2: STAR support.  If they add a 4180x and there
                    is not yet an enhanced STAR exemption, add it
                    (and delete any basic STAR unless this is a
                     co-op).}
     {FXX02061998-5: Allow the automatic addition of enhanced STAR exemptions
              when a senior exemption is added be a municipality
              decision.}
     {FXX07281999-4: Make sure auto add of STAR goes from TY to NY.}

  AddEnhancedSTAR := False;

  If ((RecordAction = raInserted) and
      GlblAutomaticallyAddEnhancedSTARExemptions and
      (Take(4, ExemptionTableExemptionCode.Text) = '4180'))
    then
      begin
        AutoAddEnhancedSTAR(TaxRollYr, SwisSBLKey,
                            ExemptionCodeLookupTable, ExemptionTable,
                            AssessmentTable,
                            ParcelEXLookupTable, ParcelTable,
                            OrigBasicSTARAmount, OrigEnhancedSTARAmount,
                            OrigSchoolExemptionAmounts, True, False);
        AddEnhancedSTAR := True;
      end;

    {CHG12011997-2: STAR support.  If they add an enhanced STAR
                    and no aged exists, warn them.}

  If ((RecordAction = raInserted) and
      (Take(4, ExemptionTableExemptionCode.Text) = '4183'))
    then
      begin
        AgedExists := False;

        For I := 0 to (OrigExemptionCodes.Count - 1) do
          If (Take(4, OrigExemptionCodes[I]) = '4180')
            then AgedExists := True;

        If ((not AgedExists) and
            GlblWarnIfAddEnhancedSTARWithoutSenior)
          then MessageDlg('You have entered an enhanced STAR exemption,' + #13 +
                          'but there is no senior exemption on the property.' + #13 +
                          'Please check that this is correct.', mtWarning, [mbOK], 0);

      end;

    {FXX11031997-8: Only update the parcel table if the roll sections
                    are different.}
    {FXX03261998-4: Need to reset the parcel roll section 1st so
                    that roll totals are correct.}

  If (OrigRollSection <> NewRollSection)
    then
      begin
          {If they moved from roll section 8 to roll section 1 or
           vice-versa, then we will change the parcel record and
           tell them.}

        with ParcelTable do
          try
            Edit;
            FieldByName('RollSection').Text := NewRollSection;
            Post;
          except
            SystemSupport(050, ParcelTable, 'Error posting roll section change to parcel record.',
                          UnitName, GlblErrorDlgBox);
          end;

         {FXX03261998-5: Put the increase into the equalization increase
                         or decrease field.}

        with AssessmentTable do
         try
           FindKeyOld(AssessmentTable, ['TaxRollYr', 'SwisSBLKey'],
                      [TaxRollYr, SwisSBLKey]);
           Edit;

           TotalAssessedValue := FieldByName('TotalAssessedVal').AsFloat;

           If MoveToRollSection1
             then FieldByName('IncreaseForEqual').AsFloat := TotalAssessedValue
             else FieldByName('DecreaseForEqual').AsFloat := TotalAssessedValue;

           Post;

         except
            SystemSupport(051, AssessmentTable, 'Error posting equalization inc/dec.',
                          UnitName, GlblErrorDlgBox);
         end;

        MessageDlg('The roll section of this parcel has changed from ' +
                    OrigRollSection + ' to ' + NewRollSection + '.',
                    mtInformation, [mbOK], 0);

      end;  {If (OrigRollSection <> NewRollSection)}

  MoveToRollSection1 := False;
  MoveToRollSection8 := False;

    {Now figure out the new exemption totals.}
    {CHG12011997-2: STAR support}
    {FXX02091998-1: Pass the residential type of each exemption.}

  EXAmounts := TotalExemptionsForParcel(TaxRollYr, SwisSBLKey,
                                        ParcelExLookupTable,
                                        ExemptionCodeLookupTable,
                                        ParcelTable.FieldByName('HomesteadCode').Text,
                                        'A',
                                        NewExemptionCodes,
                                        NewExemptionHomesteadCodes,
                                        NewResidentialTypes,
                                        NewCountyExemptionAmounts,
                                        NewTownExemptionAmounts,
                                        NewSchoolExemptionAmounts,
                                        NewVillageExemptionAmounts,
                                        NewBasicSTARAmount,
                                        NewEnhancedSTARAmount);

    {The special district amounts may have changed, so
     calculate the new special district amounts, too.}

  TotalSpecialDistrictsForParcel(TaxRollYr,
                                 SwisSBLKey,
                                 ParcelTable,
                                 AssessmentTable,
                                 ParcelSDTable,
                                 SDCodeTable,
                                 ParcelExLookupTable,
                                 ExemptionCodeLookupTable,
                                 NewSDAmounts);

    {Delete all the old roll totals for this parcel.}

 CalculateHstdAndNonhstdAmounts(TaxRollYr, SwisSBLKey,
                                AssessmentTable,
                                ClassTable, ParcelTable,
                                HstdAssessedVal, NonhstdAssessedVal,
                                HstdLandVal, NonhstdLandVal,
                                HstdAcres, NonhstdAcres,
                                AssessmentRecordFound,
                                ClassRecordFound);

  {FXX12041997-4: Record full, unadjusted STAR amount. Need to pass
                  the parcel table for that.}

  If not GlblSuppressRollTotalsUpdate
    then AdjustRollTotalsForParcel(TaxRollYr,
                                  ParcelTable.FieldByName('SwisCode').Text,
                                  ParcelTable.FieldByName('SchoolCode').Text,
                                  ParcelTable.FieldByName('HomesteadCode').Text,
                                  OrigRollSection,
                                  HstdLandVal, NonhstdLandVal,
                                  HstdAssessedVal,
                                  NonhstdAssessedVal,
                                  OrigExemptionCodes,
                                  OrigExemptionHomesteadCodes,
                                  OrigCountyExemptionAmounts,
                                  OrigTownExemptionAmounts,
                                  OrigSchoolExemptionAmounts,
                                  OrigVillageExemptionAmounts,
                                  ParcelTable,
                                  OrigBasicSTARAmount,
                                  OrigEnhancedSTARAmount,
                                  OrigSDAmounts,
                                  ['S', 'C', 'E', 'D'],  {Adjust swis, school, exemption, sd}
                                  'D');  {Delete the totals.}

    {Add the new roll totals for this parcel.}

  If not GlblSuppressRollTotalsUpdate
    then AdjustRollTotalsForParcel(TaxRollYr,
                                  ParcelTable.FieldByName('SwisCode').Text,
                                  ParcelTable.FieldByName('SchoolCode').Text,
                                  ParcelTable.FieldByName('HomesteadCode').Text,
                                  NewRollSection,
                                  HstdLandVal, NonhstdLandVal,
                                  HstdAssessedVal,
                                  NonhstdAssessedVal,
                                  NewExemptionCodes,
                                  NewExemptionHomesteadCodes,
                                  NewCountyExemptionAmounts,
                                  NewTownExemptionAmounts,
                                  NewSchoolExemptionAmounts,
                                  NewVillageExemptionAmounts,
                                  ParcelTable,
                                  NewBasicSTARAmount,
                                  NewEnhancedSTARAmount,
                                  NewSDAmounts,
                                  ['S', 'C', 'E', 'D'],  {Adjust swis, school, exemption, sd}
                                  'A');  {Add the totals.}

          {Calculate the total exemptions for this parcel and fill them in on the
           screen.}

  DisplayTaxableValues(EXAmounts);
  DisplayAgedValues(NewExemptionCodes,
                    NewCountyExemptionAmounts,
                    NewTownExemptionAmounts,
                    NewSchoolExemptionAmounts,
                    NewVillageExemptionAmounts);

  NewExemptionCodes.Free;
  NewExemptionHomesteadCodes.Free;
  NewResidentialTypes.Free;
  NewCountyExemptionAmounts.Free;
  NewTownExemptionAmounts.Free;
  NewSchoolExemptionAmounts.Free;
  NewVillageExemptionAmounts.Free;
  ClearTList(NewSDAmounts, SizeOf(ParcelSDValuesRecord));
  FreeTList(NewSDAmounts, SizeOf(ParcelSDValuesRecord));


    {Reset all the fields to editable so that if they want to go to
     a different type of exemption they can. As soon as the person tries
     to edit it, we will determine what fields they can edit.
     The problem was that if there was an exemption with say percentage
     read-only and you tried to add a percentage based exemption,
     it would stay read-only.}

  ResetReadOnlyFields;

    {Now, let's check all the exemptions of this kind and make
     sure that the owner percent does not exceed 100. If it does,
     we will put them back at the first exemption code of this type
     and put it in edit mode.}

  TotalOwnerPercent := 0;
  FirstTimeThrough := True;
  Done := False;

  SetRangeOld(ParcelExLookupTable,
              ['TaxRollYr', 'SwisSBLKey', 'ExemptionCode'],
              [TaxRollYr, SwisSBLKey,
               ExemptionTableExemptionCode.Text],
              [TaxRollYr, SwisSBLKey,
               ExemptionTableExemptionCode.Text]);

  ParcelExLookupTable.First;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else ParcelExLookupTable.Next;

    If ParcelExLookupTable.EOF
      then Done := True;

    If not Done
      then TotalOwnerPercent := TotalOwnerPercent +
                                ParcelExLookupTableOwnerPercent.Value;

  until Done;

  If (Roundoff(TotalOwnerPercent, 2) > 100)
    then
      begin
        MessageDlg('The total owner percent for exemption code ' +
                   ExemptionTableExemptionCode.Text + #13 +
                   'is greater than 100%.' + #13 + #13 +
                   'Please correct this.', mtError, [mbOK], 0);

        ExemptionTable.Edit;

      end;  {If (Roundoff(TotalOwnerPercent, 2) > 100)}

  {They actually changed something so let's save the original exemptions.}

  InsertAuditEXChanges(SwisSBLKey, TaxRollYr, AuditEXChangeList,
                      AuditEXChangeTable, 'B');

    {CHG03241998-1: Show whole exemption picture for audit trail -
                    before and after.}
    {This is the after picture.}

  ClearTList(NewAuditEXChangeList, SizeOf(AuditEXRecord));
  GetAuditEXList(SwisSBLKey, TaxRollYr, ExemptionTable, NewAuditEXChangeList);
  InsertAuditEXChanges(SwisSBLKey, TaxRollYr, NewAuditEXChangeList,
                       AuditEXChangeTable, 'A');

    {CHG10281997-1: Dual mode processing.}
    {FXX02281999-6: If person was in This Year, brought up Next Year,
                    did a change in Next Year, change carried back
                    to This Year. So, only do if in This Year.}

  If (GlblModifyBothYears and
      (ProcessingType = ThisYear))
    then
      begin
          {FXX03261998-7: Bookmark the original exemption so don't lose it
                          when do audit trail.}

        ExemptionTable.GotoBookmark(Bookmark);

          {FXX02221999-4: Sometimes, if there is a bunch of parcels, deleting
                          the opposite year exemption did not work.}

        If DeletingARecord
          then OppositeYearBookmark := OppositeYearExemptionTable.GetBookmark;

          {Open the tables for adjusting the opposite year roll totals.}

          {FXX11131997-7: The exemption code table was not initialized.}

        OppositeYearExemptionCodeTable := FindTableInDataModuleForProcessingType(DataModuleExemptionCodeTableName,
                                                                                 NextYear);
        OppositeYearAssessmentTable := FindTableInDataModuleForProcessingType(DataModuleAssessmentTableName,
                                                                              NextYear);
        OppositeYearSwisCodeTable := FindTableInDataModuleForProcessingType(DataModuleSwisCodeTableName,
                                                                            NextYear);
        OppositeYearSDCodeTable := FindTableInDataModuleForProcessingType(DataModuleSpecialDistrictCodeTableName,
                                                                          NextYear);
        OppositeYearParcelSDTable := FindTableInDataModuleForProcessingType(DataModuleSpecialDistrictTableName,
                                                                            NextYear);
        OppositeYearClassTable := FindTableInDataModuleForProcessingType(DataModuleClassTableName,
                                                                         NextYear);
        OppositeYearParcelTable := TTable.Create(nil);
        OppositeYearParcelTable.IndexName := 'BYTAXROLLYR_SWISSBLKEY';
        OpenTableForProcessingType(OppositeYearParcelTable, ParcelTableName,
                                   NextYear, Quit);

        FindKeyOld(OppositeYearAssessmentTable,
                   ['TaxRollYr', 'SwisSBLKey'],
                   [OppositeTaxYear, SwisSBLKey]);

        SBLRec := ExtractSwisSBLFromSwisSBLKey(SwisSBLKey);

        with SBLRec do
          FindKeyOld(OppositeYearParcelTable,
                     ['TaxRollYr', 'SwisCode', 'Section',
                      'Subsection', 'Block', 'Lot', 'Sublot', 'Suffix'],
                     [OppositeTaxYear, SwisCode, Section,
                      SubSection, Block, Lot, Sublot, Suffix]);

          {FXX06222001-1: Don't move changes forward if NY parcel is inactive.}

        If (OppositeYearParcelTable.FieldByName('ActiveFlag').Text = InactiveParcelFlag)
          then MessageDlg('The exemption change was not moved forward to next year' + #13 +
                          'because the next year parcel is inactive.' + #13 +
                          'Please make sure that this is correct.', mtWarning, [mbOK], 0)
           else
             begin
                 {Get the original SD values so that we can adjust the roll totals
                  after any changes.}

              ClearTList(OrigSDAmounts, SizeOf(ParcelSDValuesRecord));

              TotalSpecialDistrictsForParcel(OppositeTaxYear,
                                             SwisSBLKey,
                                             OppositeYearParcelTable,
                                             OppositeYearAssessmentTable,
                                             OppositeYearParcelSDTable,
                                             OppositeYearSDCodeTable,
                                             OppositeYearExemptionTable,
                                             OppositeYearExemptionCodeTable,
                                             OrigSDAmounts);

                {Figure out the original exemption totals.}
                {CHG12011997-2: STAR support}
                {FXX02091998-1: Pass the residential type of each exemption.}

              TotalExemptionsForParcel(OppositeTaxYear, SwisSBLKey,
                                       OppositeYearExemptionTable,
                                       OppositeYearExemptionCodeTable,
                                       OppositeYearParcelTable.FieldByName('HomesteadCode').Text,
                                       'A',
                                       OrigExemptionCodes,
                                       OrigExemptionHomesteadCodes,
                                       OrigResidentialTypes,
                                       OrigCountyExemptionAmounts,
                                       OrigTownExemptionAmounts,
                                       OrigSchoolExemptionAmounts,
                                       OrigVillageExemptionAmounts,
                                       OrigBasicSTARAmount,
                                       OrigEnhancedSTARAmount);

                {Delete, edit or insert the record.}
                {FXX11021997-2: The table should be set up for deletion, editing,
                                or inserting after getting the original amounts
                                since this alters the record position.}
                {CHG03241998-1: Show whole exemption picture for audit trail -
                                before and after.}
                {This is the before for the opposite year.}

              ClearTList(AuditEXChangeList, SizeOf(AuditEXRecord));
              GetAuditEXList(SwisSBLKey, OppositeTaxYear, OppositeYearExemptionTable,
                             AuditEXChangeList);

              If DeletingARecord
                then Found := OppositeYearExemptionFound
                else
                  begin
                      {Set the table in insert or edit mode depending on what action
                       the user did.}
                      {FXX10271998-2: Not setting opposite year parcel changed flag.}

                    case RecordAction of
                      raInserted : begin
                                     Found := True;
                                     AutoIncrementID := 0;
                                     OppositeYearParcelChanged := True;

                                   end;  {raInserted}

                      raEdited : begin
                                   Found := FindOppositeYearExemptionRecord;

                                   If Found
                                     then
                                       with OppositeYearExemptionTable do
                                         begin
                                           Edit;
                                           AutoIncrementID := FieldByName('AutoIncrementID').AsInteger;
                                           OppositeYearParcelChanged := True;
                                         end;  {with OppositeYearExemptionTable do}

                                 end;  {raEdited}

                    end;  {case RecordAction of}

                  end;  {else of If DeletingARecord}

                {Now either delete the record or copy it to the opposite year.}

              If Found
                then
                  begin
                    If DeletingARecord
                      then
                        begin
                             {FXX02221999-4: Sometimes, if there is a bunch of parcels, deleting
                                             the opposite year exemption did not work.}

                          OppositeYearExemptionTable.GotoBookmark(OppositeYearBookmark);
                          OppositeYearExemptionTable.FreeBookmark(OppositeYearBookmark);

                            {FXX12021999-3: Trace deletes of exemptions in audit table.}

                          AddToTraceFile(SwisSBLKey, 'Exemption', 'Exempt Code',
                                         OppositeYearExemptionTable.FieldByName('ExemptionCode').Text,
                                         '(Deleted)', Time, OppositeYearExemptionTable);

                          OppositeYearExemptionTable.Delete;
                          OppositeYearParcelChanged := True;
                        end
                      else
                        begin
                           {FXX11101997-6: Combined the CreateFieldValuesAndLabels from UGenSclb
                                           and PASUtils for compatibility.}

                          FieldNamesList := TStringList.Create;

                          CreateFieldValuesAndLabels(Self, OppositeYearExemptionTable,
                                                     FieldTraceInformationList);

                          FieldNamesList.Free;
                          OppositeYearHasSTAR := False;

                            {FXX02221999-1: Make sure not to put a STAR on opposite year if already exists.}
                            {FXX12101999-1: Do not check to see if opposite year has duplicate (non STAR) -
                                            if they are adding a second exemption on TY, add it on NY.}

                          If (RecordAction = raInserted)
                            then OppositeYearHasSTAR := CheckIfOppositeYearHasSTAROrDuplicate(
                                                                                   ExemptionTable,
                                                                                   OppositeYearExemptionTable,
                                                                                   OppositeYearParcelTable,
                                                                                   OppositeTaxYear,
                                                                                   SwisSBLKey);

                          If OppositeYearHasSTAR
                            then
                              begin
                                OppositeYearParcelChanged := False;
                                MoveToRollSection1 := False;
                                MoveToRollSection8 := False;

                                If ((ExemptionTableExemptionCode.Text = BasicSTARExemptionCode) or
                                    (ExemptionTableExemptionCode.Text = EnhancedSTARExemptionCode))
                                  then MessageDlg('A STAR exemption was not added to Next Year because it already had one.' + #13 +
                                                  'Please review.', mtInformation, [mbOK], 0)
                                  else MessageDlg('The exemption ' + ExemptionTableExemptionCode.Text +
                                                  ' already exists in Next Year.' + #13 +
                                                  'It was not added to Next Year.' + #13 +
                                                  'Please review.', mtInformation, [mbOK], 0);

                              end
                            else
                              begin
                                If (RecordAction = raInserted)
                                  then OppositeYearExemptionTable.Insert;

                                  {Copy the fields from the main table to the new table, but make
                                   sure that we do not copy the tax roll year.}

                                  {FXX02261998-3: Copying the autoincrement ID
                                                  as '0' when this is edit mode causes
                                                  a dup key on that index, so must
                                                  preserve original autoincrement ID
                                                  for edit mode.}
                                  {FXX07211999-1: Make sure exemption flags do not get
                                                  copied forward.}

                                CopyFields(ExemptionTable, OppositeYearExemptionTable,
                                           ['TaxRollYr', 'ExemptionApproved',
                                            'ApprovalPrinted', 'RenewalPrinted',
                                            'RenewalReceived', 'ReminderPrinted',
                                            'DateApprovalPrinted', 'DateRenewalPrinted',
                                            'DateReminderPrinted'],
                                           [OppositeTaxYear, 'False',
                                            'False', 'False', 'False', 'False',
                                            '', '', '']);

                                try
                                  OppositeYearExemptionTable.Post;
                                except
                                  SystemSupport(050, OppositeYearExemptionTable,
                                                'Error posting opposite year record.', UnitName,
                                                GlblErrorDlgBox);
                                end;

                                If (RecordChanges(Self, 'Exemption',
                                                  OppositeYearExemptionTable, SwisSBLKey,
                                                  FieldTraceInformationList) > 0)
                                  then OppositeYearParcelChanged := True;

                              end;  {else of If OppositeYearHasSTAR}

                             {FXX07281999-4: Make sure auto add of STAR goes from TY to NY.}

                          If AddEnhancedSTAR
                            then AutoAddEnhancedSTAR(OppositeTaxYear, SwisSBLKey,
                                                     OppositeYearExemptionCodeTable,
                                                     OppositeYearExemptionTable,
                                                     OppositeYearAssessmentTable,
                                                     OppositeYearExemptionTable,
                                                     OppositeYearParcelTable, OrigBasicSTARAmount,
                                                     OrigEnhancedSTARAmount, OrigSchoolExemptionAmounts,
                                                     False, True);

                        end;  {else of If DeletingARecord}

                      {FXX03261998-6: Carry switches in roll section forward.}

                    If (MoveToRollSection1 or MoveToRollSection8)
                      then
                        with OppositeYearParcelTable do
                          try
                            OppositeYearParcelChanged := True;
                            Edit;
                            If MoveToRollSection1
                              then FieldByName('RollSection').Text := '1'
                              else FieldByName('RollSection').Text := '8';

                            Post;
                          except
                            SystemSupport(051, OppositeYearParcelTable,
                                          'Error posting roll section change.',
                                          UnitName, GlblErrorDlgBox);
                          end;

                    MoveToRollSection1 := False;
                    MoveToRollSection8 := False;

                      {Reset the index.}

                    OppositeYearExemptionTable.IndexName := 'BYYEAR_SWISSBLKEY_EXCODE';

                      {Since there has been a change to one exemption, we will
                       have to recalculate all exemptions, thus we will have to
                       recalculate the swis and school totals since these might
                       be affected, too.}

                    If OppositeYearParcelChanged
                      then
                        begin
                          RecalculateExemptionsForParcel(OppositeYearExemptionCodeTable,
                                                         OppositeYearExemptionTable,
                                                         OppositeYearAssessmentTable,
                                                         OppositeYearClassTable,
                                                         OppositeYearSwisCodeTable,
                                                         OppositeYearParcelTable,
                                                         OppositeTaxYear, SwisSBLKey, nil,
                                                         0, 0, False);

                            {CHG03241998-1: Show whole exemption picture for audit trail -
                                            before and after.}

                            {FXX12101999-2: Only insert the before records if there will be an after.}

                          InsertAuditEXChanges(SwisSBLKey, OppositeTaxYear,
                                               AuditEXChangeList, AuditEXChangeTable, 'B');
                          ClearTList(NewAuditEXChangeList, SizeOf(AuditEXRecord));
                          GetAuditEXList(SwisSBLKey, OppositeTaxYear, OppositeYearExemptionTable,
                                         NewAuditEXChangeList);
                          InsertAuditEXChanges(SwisSBLKey, OppositeTaxYear,
                                               NewAuditEXChangeList, AuditEXChangeTable,
                                               'A');

                                  {Now get the new SD amounts and adjust.}

                          NewExemptionCodes := TStringList.Create;
                          NewExemptionHomesteadCodes := TStringList.Create;
                          NewResidentialTypes := TStringList.Create;
                          NewCountyExemptionAmounts := TStringList.Create;
                          NewTownExemptionAmounts := TStringList.Create;
                          NewSchoolExemptionAmounts := TStringList.Create;
                          NewVillageExemptionAmounts := TStringList.Create;
                          NewSDAmounts := TList.Create;

                          TotalSpecialDistrictsForParcel(OppositeTaxYear,
                                                         SwisSBLKey,
                                                         OppositeYearParcelTable,
                                                         OppositeYearAssessmentTable,
                                                         OppositeYearParcelSDTable,
                                                         OppositeYearSDCodeTable,
                                                         OppositeYearExemptionTable,
                                                         OppositeYearExemptionCodeTable,
                                                         NewSDAmounts);

                            {Figure out the new exemption totals.}
                            {FXX11131997-9: We were getting the new exemption amounts,
                                            but putting them in the vars for the
                                            original amounts.}

                            {CHG12011997-2: STAR support}
                            {FXX02091998-1: Pass the residential type of each exemption.}

                          TotalExemptionsForParcel(OppositeTaxYear, SwisSBLKey,
                                                   OppositeYearExemptionTable,
                                                   OppositeYearExemptionCodeTable,
                                                   OppositeYearParcelTable.FieldByName('HomesteadCode').Text,
                                                   'A',
                                                   NewExemptionCodes,
                                                   NewExemptionHomesteadCodes,
                                                   NewResidentialTypes,
                                                   NewCountyExemptionAmounts,
                                                   NewTownExemptionAmounts,
                                                   NewSchoolExemptionAmounts,
                                                   NewVillageExemptionAmounts,
                                                   NewBasicSTARAmount,
                                                   NewEnhancedSTARAmount);

                          CalculateHstdAndNonhstdAmounts(OppositeTaxYear, SwisSBLKey,
                                                         OppositeYearAssessmentTable,
                                                         OppositeYearClassTable,
                                                         OppositeYearParcelTable,
                                                         HstdAssessedVal, NonhstdAssessedVal,
                                                         HstdLandVal, NonhstdLandVal,
                                                         HstdAcres, NonhstdAcres,
                                                         AssessmentRecordFound,
                                                         ClassRecordFound);

                            {Delete all the old roll totals for this parcel.
                             We are only going to adjust the special district roll
                             totals since these are the only totals affected by
                             an SD change.}

                          {FXX12041997-4: Record full, unadjusted STAR amount. Need to pass
                                          the parcel table for that.}

                          If not GlblSuppressRollTotalsUpdate
                            then AdjustRollTotalsForParcel(OppositeTaxYear,
                                                          OppositeYearParcelTable.FieldByName('SwisCode').Text,
                                                          OppositeYearParcelTable.FieldByName('SchoolCode').Text,
                                                          OppositeYearParcelTable.FieldByName('HomesteadCode').Text,
                                                          OppositeYearParcelTable.FieldByName('RollSection').Text,
                                                          HstdLandVal, NonhstdLandVal,
                                                          HstdAssessedVal, NonhstdAssessedVal,
                                                          OrigExemptionCodes,
                                                          OrigExemptionHomesteadCodes,
                                                          OrigCountyExemptionAmounts,
                                                          OrigTownExemptionAmounts,
                                                          OrigSchoolExemptionAmounts,
                                                          OrigVillageExemptionAmounts,
                                                          OppositeYearParcelTable,
                                                          OrigBasicSTARAmount,
                                                          OrigEnhancedSTARAmount,
                                                          OrigSDAmounts,
                                                          ['S', 'C', 'E', 'D'],  {Adjust swis, school, exemption, sd}
                                                          'D');  {Delete the totals.}

                            {Add the new roll totals for this parcel.}

                          If not GlblSuppressRollTotalsUpdate
                            then AdjustRollTotalsForParcel(OppositeTaxYear,
                                                          OppositeYearParcelTable.FieldByName('SwisCode').Text,
                                                          OppositeYearParcelTable.FieldByName('SchoolCode').Text,
                                                          OppositeYearParcelTable.FieldByName('HomesteadCode').Text,
                                                          OppositeYearParcelTable.FieldByName('RollSection').Text,
                                                          HstdLandVal, NonhstdLandVal,
                                                          HstdAssessedVal, NonhstdAssessedVal,
                                                          NewExemptionCodes,
                                                          NewExemptionHomesteadCodes,
                                                          NewCountyExemptionAmounts,
                                                          NewTownExemptionAmounts,
                                                          NewSchoolExemptionAmounts,
                                                          NewVillageExemptionAmounts,
                                                          OppositeYearParcelTable,
                                                          NewBasicSTARAmount,
                                                          NewEnhancedSTARAmount,
                                                          NewSDAmounts,
                                                          ['S', 'C', 'E', 'D'],  {Adjust swis, school, exemption, sd}
                                                          'A');  {Add the totals.}

                          NewExemptionCodes.Free;
                          NewExemptionHomesteadCodes.Free;
                          NewResidentialTypes.Free;
                          NewCountyExemptionAmounts.Free;
                          NewTownExemptionAmounts.Free;
                          NewSchoolExemptionAmounts.Free;
                          NewVillageExemptionAmounts.Free;
                          ClearTList(NewSDAmounts, SizeOf(ParcelSDValuesRecord));
                          FreeTList(NewSDAmounts, SizeOf(ParcelSDValuesRecord));

                            {If they moved from roll section 8 to roll section 1 or
                             vice-versa, then we will change the parcel record and
                             tell them.}

                          If (OrigRollSection <> NewRollSection)
                            then
                              begin
                                with OppositeYearParcelTable do
                                  try
                                    Edit;
                                    FieldByName('RollSection').Text := NewRollSection;
                                    Post;
                                  except
                                    SystemSupport(050, OppositeYearParcelTable,
                                                  'Error posting roll section change to parcel record.',
                                                  UnitName, GlblErrorDlgBox);
                                  end;

                               end;  {If (OrigRollSection <> NewRollSection)}

                        end;  {If OppositeYearParcelChanged}

                  end;  {If Found}

             end;  {If (OppositeYearParcelTable.FieldByName('ActiveFlag ...}

        OppositeYearParcelTable.Close;
        OppositeYearParcelTable.Free;

      end;  {If GlblModifyBothYears}

    {FXX11131997-10: Reset the range after the opposite year copy since
                     it changes the file position in the base table.}

  ExemptionTable.FreeBookmark(Bookmark);
  ExemptionTable.DisableControls;
  ExemptionTable.CancelRange;
  SetRangeForTable(ExemptionTable);  {This is a method that we have written to avoid having two copies of the setrange.}
  ExemptionTable.EnableControls;

    {CHG09071999-3: Ask if they want a denial record inserted.}
    {CHG01142002-2: Do not ask denial information on a deleted
                    exemption. That should be added seperately.}

(*  ExemptionDenied := False;

  If (DeletingARecord and
      (MessageDlg('Do you want to create a denial record for this exemption?',
                  mtConfirmation, [mbYes, mbNo], 0) = idYes))
    then
      begin
        with ExemptionDenialTable do
          try
            ExemptionDenied := True;
            Insert;
            FieldByName('TaxRollYr').Text  := Take(4, TaxRollYr);
            FieldByName('SwisSBLKey').Text := Take(26, SwisSBLKey);
            FieldByName('DenialDate').AsDateTime := Date;
            FieldByName('ExemptionCode').Text := OrigEXCode;

              {CHG04022001-1: Have flag for pro-rata calculation.}

            If (MessageDlg('Do you want to mark the denial record for pro-rata calculation?',
                           mtconfirmation, [mbYes, mbNo], 0) = idYes)
              then FieldByName('ProRata').AsBoolean := True;

            Post;
          except
            SystemSupport(75, ExemptionDenialTable, 'Error inserting into exemption denial table.',
                          UnitName, GlblErrorDlgBox);
          end;

          {FXX06222001-4: If a denial or removed exemption tab does not exist and we
                          create it, put up a tab right away.}

        If (ParcelTabset.Tabs.IndexOf(ExemptionsDenialTabName) = -1)
          then AddExemptionDenialTab(ExemptionDenialTable, ParcelTabset, ProcessingType, 0,
                                     TabTypeList, TaxRollYr, SwisSBLKey);

      end;  {If (DeletingARecord and ...} *)

    {FXX11131997-12: Need to reset DeletingARecord AFTER doing dual processing.}

  FreeTList(NewAuditEXChangeList, SizeOf(AuditEXRecord));

    {FXX02212001-2: If they added a new record and a denial already exists,
                    get rid of it if they want}

  If (RecordAction = raInserted)
    then
      begin
          try
            SetRangeOld(ExemptionDenialTable, ['TaxRollYr', 'SwisSBLKey'],
                        [TaxRollYr, SwisSBLKey], [TaxRollYr, SwisSBLKey]);

            FirstTimeThrough := True;
            Done := False;
            ExemptionDenialTable.First;

            repeat
              If FirstTimeThrough
                then FirstTimeThrough := False
                else ExemptionDenialTable.Next;

              If ExemptionDenialTable.EOF
                then Done := True;

              If ((not Done) and
                  (ExemptionDenialTable.FieldByName('ExemptionCode').Text =
                   ExemptionTable.FieldByName('ExemptionCode').Text) and
                  (MessageDlg('The exemption that you just added (' +
                              ExemptionTable.FieldByName('ExemptionCode').Text + ')' +
                              ' has already been denied.' + #13 +
                              'Do you want to remove the denial record?', mtWarning,
                              [mbYes, mbNo], 0) = idYes))
                then
                  begin
                    ExemptionDenialTable.Delete;
                    If ExemptionDenialTable.EOF
                      then Done := True;

                  end;

            until Done;

          except
            SystemSupport(75, ExemptionDenialTable, 'Error inserting into exemption denial table.',
                          UnitName, GlblErrorDlgBox);
          end;

      end;  {If (RecordAction = raInserted)}

{CHG04122001-1(MDT): Record removed exemptions.}

  If (DeletingARecord and
      GlblRecordRemovedExemptions)
    then
      begin
        EffectiveDateRemoved := 0;
        ResultedFromSale := False;
        SetRangeOld(SalesTable, ['SwisSBLKey', 'SaleNumber'],
                    [SwisSBLKey, '0'],
                    [SwisSBLKey, '32000']);

          {CHG01142002-1: If this should trigger a pro-rata calculation,
                          put up a default effective removal date, but
                          let them override it.}
          {CHG10252002-1: Don't ask prorated if this is a STAR.}

        If ((not ExemptionIsSTAR(OrigEXCode)) and
            (MessageDlg('Does this exemption removal require a pro-rata calculation?',
                       mtConfirmation, [mbYes, mbNo], 0) = idYes))
          then
            begin
              SalesTable.First;

              If SalesTable.EOF
                then EffectiveDateRemoved := Date
                else
                  begin
                      {FXX10192001-1: Make sure to move it to the last sale so that
                                      it asks the most recent sale date.}

                    SalesTable.Last;
                    EffectiveDateRemoved := SalesTable.FieldByName('SaleDate').AsDateTime;
                  end;

              ResultedFromSale := True;
              EnterDateDialogForm := TEnterDateDialogForm.Create(nil);

              with EnterDateDialogForm do
                try
                  PromptLabel.Caption := 'Please enter the effective date of removal:';
                  Caption := 'Enter the effective date.';
                  DateEdit.Text := DateToStr(EffectiveDateRemoved);

                  If (ShowModal = idOK)
                    then EffectiveDateRemoved := DateEntered;

                finally
                  Free;
                end;

            end;  {If (MessageDlg( ...}

        with RemovedExemptionsTable do
          try
            Insert;
            FieldByName('SwisSBLKey').Text := Take(26, SwisSBLKey);
            FieldByName('ActualDateRemoved').AsDateTime := Date;
            FieldByName('RemovedBy').Text := GlblUserName;
            FieldByName('ExemptionCode').Text := OrigEXCode;
            FieldByName('CountyAmount').AsFloat := OrigCountyExemptionAmount;
            FieldByName('TownAmount').AsFloat := OrigTownExemptionAmount;
            FieldByName('SchoolAmount').AsFloat := OrigSchoolExemptionAmount;
            FieldByName('VillageAmount').AsFloat := OrigVillageExemptionAmount;
            FieldByName('YearRemovedFrom').Text := TaxRollYr;

            If ResultedFromSale
              then
                begin
                  FieldByName('RemovedDueToSale').AsBoolean := True;
                  FieldByName('EffectiveDateRemoved').AsDateTime := EffectiveDateRemoved;
                end
              else FieldByName('EffectiveDateRemoved').AsDateTime := Date;

              {CHG04302006-1(2.9.7.1): Record the initial date and percent of the original exemption.}

            try
              FieldByName('InitialDate').AsDateTime := OrigInitialDate;
            except
            end;

            try
              FieldByName('Percent').AsFloat := OrigPercent;
            except
            end;

            Post;
          except
            SystemSupport(010, RemovedExemptionsTable,
                          'Error inserting an exemption removal record.',
                          UnitName, GlblErrorDlgBox);
          end;

          {FXX06222001-4: If a denial or removed exemption tab does not exist and we
                          create it, put up a tab right away.}

        If (ParcelTabset.Tabs.IndexOf(ExemptionsRemovedTabName) = -1)
          then AddExemptionRemovalTab(RemovedExemptionsTable, ParcelTabset, ProcessingType, 0,
                                      TabTypeList, TaxRollYr, SwisSBLKey);

      end;  {If (DeletingARecord and ...}

    {FXX06222001-3: Put in an extra warning to prevent exemptions greater than av.}

  TempStr := '';

  If (EXAmounts[EXCounty] > (HstdAssessedVal + NonhstdAssessedVal))
    then TempStr := 'county';

  If (EXAmounts[EXTown] > (HstdAssessedVal + NonhstdAssessedVal))
    then
      If (Deblank(TempStr) = '')
        then TempStr := GetMunicipalityTypeName(GlblMunicipalityType)
        else TempStr := TempStr + ', ' + GetMunicipalityTypeName(GlblMunicipalityType);

  If ((EXAmounts[EXSchool] + NewBasicSTARAmount + NewEnhancedSTARAmount) >
      (HstdAssessedVal + NonhstdAssessedVal))
    then
      If (Deblank(TempStr) = '')
        then TempStr := 'school'
        else TempStr := TempStr + ' and school';

  If (Deblank(TempStr) <> '')
    then MessageDlg('The total exemption amount(s) for ' + TempStr + #13 +
                    'are larger than the total assessed value.' + #13 +
                    'Please correct.', mtError, [mbOK], 0);

  DeletingARecord := False;

    {Now, if the parcel changed, then update the parcel table.}
    {FXX10152004-2(2.8.0.14): Move the call to MarkRecChanged to after post so that it updates right away.}

  If ParcelChanged
    then MarkRecChanged(ParcelTable, UnitName);

end;  {ExemptionTableAfterPost}

{==============================================================}
Procedure TParcelExemptionCodeForm.CloseButtonClick(Sender: TObject);

{Note that the close button is a close for the whole
 parcel maintenance.}

{To close the whole parcel maintenance, we will once again use
 the base popup menu. We will simulate a click on the
 "Exit Parcel Maintenance" of the BasePopupMenu which will
 then call the Close of ParcelTabForm. See the locate button
 click above for more information on how this works.}

var
  I : Integer;
  CanClose : Boolean;

begin
    {Search for the name of the menu item that has "Exit"
     in it, and click it.}

  For I := 0 to (PopupMenu.Items.Count - 1) do
    If (Pos('Exit', PopupMenu.Items[I].Name) <> 0)
      then
        begin
            {FXX06141999-5: Ask if person wants to save before exiting
                            to locate dialog.}

          FormCloseQuery(Sender, CanClose);

          If CanClose
            then PopupMenu.Items[I].Click;

        end;  {If (Pos('Exit',  ...}

end;  {CloseButtonClick}

{====================================================================}
Procedure TParcelExemptionCodeForm.FormCloseQuery(    Sender: TObject;
                                         var CanClose: Boolean);

begin
  CanClose := True;
  ClosingForm := True;
  GlblParcelPageCloseCancelled := False;

    {First see if anything needs to be saved. In order to
     determine if there are any changes, we need to sychronize
     the fields with what is in the DB edit boxes. To do this,
     we call the UpdateRecord. Then, if there are any changes,
     the Modified flag will be set to True.}

  If (ExemptionTable.State in [dsInsert, dsEdit])
    then ExemptionTable.UpdateRecord;

    {Now, if they are closing the table, let's see if they want to
     save any changes. However, we won't check this if
     they are in inquire mode. Note that sometimes a record can be marked even
     if there were no changes if a person clicks on a drop down box (even without changing
     the value). So, since we are recording field values before any changes, we
     will compare them to now and if there are no changes, we will cancel this
     edit or insert.}

  If ((not ExemptionTable.ReadOnly) and
      (ExemptionTable.State in [dsInsert, dsEdit]) and
      ExemptionTable.Modified)
    then
      If (NumRecordChanges(Self, ExemptionTable, FieldTraceInformationList) = 0)
        then ExemptionTable.Cancel
        else
          begin
            try
              ExemptionTable.Post;
            except
              CanClose := False;
              GlblParcelPageCloseCancelled := True;
            end;

          end;  {else of If (NumRecordChanges(Self, ...}

  ClosingForm := False;

end;  {FormCloseQuery}

{====================================================================}
Procedure TParcelExemptionCodeForm.FormClose(    Sender: TObject;
                                             var Action: TCloseAction);

var
  Quit : Boolean;
  SBLRec : SBLRecord;

begin
    {FXX03112009-1(2.17.1.7): Make sure to save the parcel table if needed due to the IVP status.}

  If (ParcelTable.State = dsEdit)
    then
      try
        ParcelTable.Post;
      except
      end;

    {Now, if the parcel changed, then update the parcel table.}

  If ParcelChanged
    then MarkRecChanged(ParcelTable, UnitName);

    {CHG10281997-1: Dual mode processing.}

  If OppositeYearParcelChanged
    then
      begin
          {Close the parcel and reopen it for the opposite year.}

        ParcelTable.Close;

        OpenTableForProcessingType(ParcelTable, ParcelTableName,
                                   OppositeProcessingType, Quit);

          {FXX10271998-3: Need to access the parcel in opposite year before
                          marking.}

        SBLRec := ExtractSwisSBLFromSwisSBLKey(SwisSBLKey);

        with SBLRec do
          FindKeyOld(ParcelTable,
                     ['TaxRollYr', 'SwisCode', 'Section',
                      'Subsection', 'Block', 'Lot', 'Sublot', 'Suffix'],
                     [OppositeTaxYear, SwisCode, Section,
                      SubSection, Block, Lot, Sublot, Suffix]);

        MarkRecChanged(ParcelTable, UnitName);

      end;  {If OppositeYearParcelChanged}

    {Close all tables here.}

  CloseTablesForForm(Self);

  OrigExemptionCodes.Free;
  OrigExemptionHomesteadCodes.Free;
  OrigResidentialTypes.Free;
  OrigCountyExemptionAmounts.Free;
  OrigTownExemptionAmounts.Free;
  OrigSchoolExemptionAmounts.Free;
  OrigVillageExemptionAmounts.Free;
  ClearTList(OrigSDAmounts, SizeOf(ParcelSDValuesRecord));
  FreeTList(OrigSDAmounts, SizeOf(ParcelSDValuesRecord));

  FreeTList(AuditEXChangeList, SizeOf(AuditEXRecord));
  FreeTList(FieldTraceInformationList, SizeOf(FieldTraceInformationRecord));

  Action := caFree;

end;  {FormClose}

end.
