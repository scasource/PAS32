unit Sysrcmnt;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  StdCtrls, Forms, DBCtrls, DB, DBTables, Mask, ExtCtrls, Buttons, Grids,
  Wwdatsrc, Wwtable, Wwdbedit, Wwdotdot, Wwdbcomb, Dialogs, wwdblook,
  TabNotBk, ComCtrls;

type
  TSysRecForm = class(TForm)
    ScrollBox: TScrollBox;
    Panel2: TPanel;
    SysRecTable: TwwTable;
    SysRecDataSource: TwwDataSource;
    SalesDeedTypeTable: TwwTable;
    WarningMessageTable: TTable;
    WarningMessageDataSource: TDataSource;
    MappingOptionsHeaderTable: TTable;
    Panel3: TPanel;
    SaveButton: TBitBtn;
    CancelButton: TBitBtn;
    CloseButton: TBitBtn;
    Panel4: TPanel;
    PageControl: TPageControl;
    SetupTabSheet: TTabSheet;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label19: TLabel;
    Label16: TLabel;
    Label9: TLabel;
    Label17: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label15: TLabel;
    Label25: TLabel;
    Label33: TLabel;
    Label45: TLabel;
    Label46: TLabel;
    Label30: TLabel;
    EditSysMunicipalityName: TDBEdit;
    EditSysProgramDir: TDBEdit;
    EditSysReportDir: TDBEdit;
    EditSysDataDir: TDBEdit;
    EditSysSCAErrorFileDir: TDBEdit;
    EditSysNextYear: TDBEdit;
    EditSysThisYear: TDBEdit;
    ComboBoxMunicipalityType: TwwDBComboBox;
    EditCounty: TDBEdit;
    EditDrive: TDBEdit;
    EditExtractFileDir: TDBEdit;
    SavedReportDirEdit: TDBEdit;
    ListDirEdit: TDBEdit;
    SavedSalesDir: TDBEdit;
    EditPictureDir: TDBEdit;
    DocumentDirEdit: TDBEdit;
    EditCaption: TDBEdit;
    EditIconFileName: TDBEdit;
    EditPictureLoadingDockDirectory: TDBEdit;
    EditApexSketchDirectory: TDBEdit;
    GeneralOptionsTabSheet: TTabSheet;
    OptionsGroupBox: TGroupBox;
    Label18: TLabel;
    Label29: TLabel;
    Label43: TLabel;
    Label47: TLabel;
    Label52: TLabel;
    Label50: TLabel;
    Label51: TLabel;
    UsesTwoTaxRates: TDBCheckBox;
    ClassifiedCheckBox: TDBCheckBox;
    WestchesterLogicCheckBox: TDBCheckBox;
    MoveInactivateCheckBox: TDBCheckBox;
    AllowAuditAccessToAllCheckBox: TDBCheckBox;
    UseRARCheckBox: TDBCheckBox;
    UsesRARToCalcFullMarketValResLandCheckBox: TDBCheckBox;
    SuppressRollTotalsUpdateCheckBox: TDBCheckBox;
    IncludeAdditionalLotsCheckBox: TDBCheckBox;
    PASRunsLocalCheckBox: TDBCheckBox;
    GroupBox7: TGroupBox;
    Label48: TLabel;
    Label49: TLabel;
    DontZeroFillBlankSegmentsDBCheckBox: TDBCheckBox;
    ForceSegmentToFormatLengthDBCheckBox: TDBCheckBox;
    MoreOptionsTabSheet: TTabSheet;
    SalesOptionsGroupBox: TGroupBox;
    Label20: TLabel;
    Label14: TLabel;
    Label26: TLabel;
    Label1: TLabel;
    Label59: TLabel;
    Label60: TLabel;
    Label61: TLabel;
    Label64: TLabel;
    SalesCtlNumRequiresCheckBox: TDBCheckBox;
    DefaultDeedTypeLookupCombo: TwwDBLookupCombo;
    SalesOnThisYearCheckBox: TDBCheckBox;
    UseOldParcelIDForSalesCheckBox: TDBCheckBox;
    UseControlNumberInsteadOfDeedBookAndDeedPageCheckBox: TDBCheckBox;
    HideSalesTransmittalFieldsCheckBox: TDBCheckBox;
    HidePersonalPropertyCheckBox: TDBCheckBox;
    AllowBlankDeedDateCheckBox: TDBCheckBox;
    ExemptionOptionsGroupBox: TGroupBox;
    Label21: TLabel;
    Label23: TLabel;
    Label13: TLabel;
    Label31: TLabel;
    AutoAddEnhancedSTARCheckBox: TDBCheckBox;
    WarnIfEnhancedWithoutSnrDBCheckBox: TDBCheckBox;
    ShowRemovedExemptionsCheckBox: TDBCheckBox;
    UseSeniorPercentCalculatorCheckBox: TDBCheckBox;
    EnableCapOptionCheckBox: TDBCheckBox;
    MoreOptions2TabSheet: TTabSheet;
    GroupBox2: TGroupBox;
    Label12: TLabel;
    SchoolCodePasswordLabel: TLabel;
    SchoolCodePasswordCheckBox: TDBCheckBox;
    SchoolCodePasswordEdit: TDBEdit;
    RollTotalsGroupBox: TGroupBox;
    Label36: TLabel;
    Label38: TLabel;
    Label37: TLabel;
    Label39: TLabel;
    CountyTaxableCheckBox: TDBCheckBox;
    MunicipalTaxableCheckBox: TDBCheckBox;
    SchoolTaxableCheckBox: TDBCheckBox;
    VillageReceivingPartialRollTaxableCheckBox: TDBCheckBox;
    GroupBox1: TGroupBox;
    Label53: TLabel;
    LocateByAccountNumberCheckBox: TDBCheckBox;
    DefaultToNoSwisOnLookupCheckBox: TDBCheckBox;
    LookupByOldParcelIDCheckBox: TDBCheckBox;
    MoreOptionsTabSheet3: TTabSheet;
    ParcelModifyOptionsGroupBox: TGroupBox;
    Label40: TLabel;
    Label22: TLabel;
    Label55: TLabel;
    Label56: TLabel;
    Label41: TLabel;
    Label62: TLabel;
    Label63: TLabel;
    ShowParcelWarningsCheckBox: TDBCheckBox;
    UseMailFieldsCheckBox: TDBCheckBox;
    TurnOffOwnerChangeCheckBox: TDBCheckBox;
    Eq_Phy_Change_Updates_AV_CheckBox: TDBCheckBox;
    ChangeYearsTogetherDefaultCheckBox: TDBCheckBox;
    ShowFullMarketValueCheckBox: TDBCheckBox;
    AlwaysShowPrior2YearsCheckBox: TDBCheckBox;
    BankCodeFrozenCheckBox: TDBCheckBox;
    AllowExemptionRenewalPreventionDBCheckBox: TDBCheckBox;
    ShowUniformPercentInsteadOfSTARCheckBox: TDBCheckBox;
    ShowAssessmentNotesOnHistoryScreenCheckBox: TDBCheckBox;
    CloseButtonIsLocateCheckBox: TDBCheckBox;
    DisplayOldIDCheckBox: TDBCheckBox;
    AccountNumberCheckBox: TDBCheckBox;
    PermanentRetentionCheckBox: TDBCheckBox;
    InventoryOptionsGroupBox: TGroupBox;
    Label42: TLabel;
    Label27: TLabel;
    Label57: TLabel;
    Label58: TLabel;
    ShowInventoryValuesCheckBox: TDBCheckBox;
    RecalculateSFLACheckBox: TDBCheckBox;
    EnforceMeasurementRestrictionsCheckBox: TDBCheckBox;
    SubtractUnfinishedAreaCheckBox: TDBCheckBox;
    AlwaysIncludeFinishedBasementInSFLACheckBox: TDBCheckBox;
    Pictures_DocumentsOptionsTabSheet: TTabSheet;
    GroupBox9: TGroupBox;
    Label71: TLabel;
    Label72: TLabel;
    Label73: TLabel;
    DBEdit2: TDBEdit;
    DBCheckBox28: TDBCheckBox;
    DBCheckBox29: TDBCheckBox;
    GroupBox8: TGroupBox;
    Label68: TLabel;
    Label69: TLabel;
    Label70: TLabel;
    DBCheckBox26: TDBCheckBox;
    DBCheckBox27: TDBCheckBox;
    DBEdit1: TDBEdit;
    AddOnOptionsTabSheet: TTabSheet;
    WarningMessagesTabSheet: TTabSheet;
    Label78: TLabel;
    cb_CalculateExemptionsMixedUseAsResidential: TDBCheckBox;
    Panel5: TPanel;
    Label24: TLabel;
    Label28: TLabel;
    DBCheckBox32: TDBCheckBox;
    cbx_LetterPrint: TDBCheckBox;
    Label79: TLabel;
    cbx_LoadPDFPropCards: TDBCheckBox;
    DBCheckBox34: TDBCheckBox;
    PageControl1: TPageControl;
    tbsMessages: TTabSheet;
    FrozenAssessmenTDBCheckBox: TDBCheckBox;
    ShowZeroAssessmentsCheckBox: TDBCheckBox;
    ShowInactiveParcelsCheckBox: TDBCheckBox;
    ImprovementChangeCheckBox: TDBCheckBox;
    GasAndOilWellCheckBox: TDBCheckBox;
    WhollyExemptNotRS8CheckBox: TDBCheckBox;
    OutOfBalanceCheckBox: TDBCheckBox;
    RS8NoExemptionCheckBox: TDBCheckBox;
    SplitMergeAVChangeCheckBox: TDBCheckBox;
    ChangeInARFieldsCheckBox: TDBCheckBox;
    PhysicalQtyIncAndDecCheckBox: TDBCheckBox;
    EqualizationIncAndDecCheckBox: TDBCheckBox;
    VacantLoTDBCheckBox: TDBCheckBox;
    NonVacanTDBCheckBox: TDBCheckBox;
    AllButton: TBitBtn;
    NoneButton: TBitBtn;
    ShowSeniorWithoutEnhancedCheckBox: TDBCheckBox;
    VacantLandExemptionCheckBox: TDBCheckBox;
    DuplicateExemptionsCheckBox: TDBCheckBox;
    ShowBasicAndEnhancedCheckBox: TDBCheckBox;
    tbsMessages2: TTabSheet;
    tbsSpecialMessages: TTabSheet;
    NonResidentialSTARCheckBox: TDBCheckBox;
    NoTerminationDateCheckBox: TDBCheckBox;
    OnlyCountyOrTownCheckBox: TDBCheckBox;
    ClergyWarningCheckBox: TDBCheckBox;
    ExemptionsGreaterThanAssessedValueCheckBox: TDBCheckBox;
    LandAreaMismatchCheckBox: TDBCheckBox;
    STARonNYnotTYCheckBox: TDBCheckBox;
    RS8PartialExemptionCheckBox: TDBCheckBox;
    cb_AVChangeOnOverrideSD: TDBCheckBox;
    cb_AVChangeOnParcelWithSaleGreaterThan1Parcel: TDBCheckBox;
    cbxColdWarVeteranOnParcelWithOtherVeteran: TDBCheckBox;
    DBCheckBox2: TDBCheckBox;
    cbxDetectPicturesByAccountNumber: TDBCheckBox;
    Label81: TLabel;
    cbDisplayDescription: TDBCheckBox;
    GroupBox20: TGroupBox;
    ShowSDTaxableValuesCheckBox: TDBCheckBox;
    cbxDisplaySpecialDistrictDescriptions: TDBCheckBox;
    cbxAllowExemptionRenewalPrevention: TDBCheckBox;
    Label82: TLabel;
    Label83: TLabel;
    cbxSuppressDocumentAutoload: TDBCheckBox;
    Label84: TLabel;
    cbxSplitSchoolDistrict: TDBCheckBox;
    Label85: TLabel;
    cbxDisplayLeadingSwisID: TDBCheckBox;
    Label86: TLabel;
    edNameAddressFileUpdatePath: TDBEdit;
    GroupBox18: TGroupBox;
    Label77: TLabel;
    DBCheckBox24: TDBCheckBox;
    EditVillageHoldingDockFolder: TDBEdit;
    GroupBox15: TGroupBox;
    DBCheckBox16: TDBCheckBox;
    DBCheckBox17: TDBCheckBox;
    GroupBox16: TGroupBox;
    Label67: TLabel;
    DBCheckBox18: TDBCheckBox;
    SearcherMappingDefaultComboBox: TComboBox;
    DBCheckBox19: TDBCheckBox;
    DBCheckBox20: TDBCheckBox;
    DBCheckBox25: TDBCheckBox;
    DBCheckBox30: TDBCheckBox;
    EditProrataPackageCheckBox: TDBCheckBox;
    EditEstimatedTaxLettersCheckBox: TDBCheckBox;
    DBCheckBox31: TDBCheckBox;
    GroupBox19: TGroupBox;
    DBCheckBox33: TDBCheckBox;
    DBCheckBox15: TDBCheckBox;
    cbx_UsesApexMedina: TDBCheckBox;
    tbsTaxBillOptions: TTabSheet;
    Label88: TLabel;
    cbForceRollTotalsCalculationBeforePrint_View: TDBCheckBox;
    cbSuppressIVP: TDBCheckBox;
    cbShowImprovementValue: TDBCheckBox;
    TabSheet1: TTabSheet;
    NotesOptionsGroupBox: TGroupBox;
    Label54: TLabel;
    ModifyOthersNotesCheckBox: TDBCheckBox;
    UsersCanChangeOpenNotesStatusCheckBox: TDBCheckBox;
    SearcherOptionsGroupBox: TGroupBox;
    Label32: TLabel;
    Label44: TLabel;
    SearcherViewsDenialsCheckBox: TDBCheckBox;
    SearcherViewsNYValsCheckBox: TDBCheckBox;
    SearcherSeesSummaryAndPg1CheckBox: TDBCheckBox;
    SearcherSeesFullMarketValueCheckBox: TDBCheckBox;
    PreventSearcherExitCheckBox: TDBCheckBox;
    GroupBox4: TGroupBox;
    Label80: TLabel;
    lbBillMenuItem1: TLabel;
    Label89: TLabel;
    edtRAVEBillName: TDBEdit;
    cbUsesRave: TDBCheckBox;
    edBillMenuItem1: TDBEdit;
    edBillMenuItem2: TDBEdit;
    GroupBox10: TGroupBox;
    Label74: TLabel;
    Label75: TLabel;
    Label76: TLabel;
    ed_BuildingSystemAlias: TDBEdit;
    rg_BuildingSystemType: TDBRadioGroup;
    ed_BuildingSystemTable: TDBEdit;
    ed_BuildingSystemIndex: TDBEdit;
    NewBuildingPermitPageStyleCheckBox: TDBCheckBox;
    Label90: TLabel;
    cbLastSaleAlwaysAppearsOnSalesPage: TDBCheckBox;
    Label91: TLabel;
    cbShowHistoryOfOwners: TDBCheckBox;
    Label92: TLabel;
    cbShowNewOwnerOnSummaryPage: TDBCheckBox;
    GroupBox5: TGroupBox;
    dbAutoUpdateNamesAndAddresses: TDBCheckBox;
    Label93: TLabel;
    edDatabaseToUpdate1: TDBEdit;
    Label94: TLabel;
    edDatabaseToUpdate2: TDBEdit;
    Label95: TLabel;
    edDatabaseToUpdate3: TDBEdit;
    cbxUsesSQLTax: TDBCheckBox;
    tbsGrievances: TTabSheet;
    GroupBox17: TGroupBox;
    DBCheckBox21: TDBCheckBox;
    DBCheckBox22: TDBCheckBox;
    DBCheckBox23: TDBCheckBox;
    GroupBox3: TGroupBox;
    Label34: TLabel;
    Label35: TLabel;
    Label65: TLabel;
    Label66: TLabel;
    Label87: TLabel;
    cbxUsesSCAInfoForms: TDBCheckBox;
    edCollectionType: TDBEdit;
    edCollectionNumber: TDBEdit;
    edBaseTaxRatePointer: TDBEdit;
    edSCARRebateInfoForm: TDBEdit;
    edCountyTaxAlias: TDBEdit;
    Label96: TLabel;
    DBEdit3: TDBEdit;
    dbFreezeForGrievanceReducation: TDBCheckBox;
    GroupBox6: TGroupBox;
    DBCheckBox3: TDBCheckBox;
    DBCheckBox4: TDBCheckBox;
    DBCheckBox5: TDBCheckBox;
    Label97: TLabel;
    DBCheckBox1: TDBCheckBox;
    cbExactPrintKey: TDBCheckBox;
    cbDisplayPrintKey: TDBCheckBox;
    cbToolbarLaunchesGIS: TDBCheckBox;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SysRecTableAfterPost(DataSet: TDataset);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure CancelButtonClick(Sender: TObject);
    procedure SysRecTableBeforeInsert(DataSet: TDataset);
    procedure SaveButtonClick(Sender: TObject);
    procedure AllButtonClick(Sender: TObject);
    procedure NoneButtonClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure WarningMessageTableAfterPost(DataSet: TDataset);
    procedure FormActivate(Sender: TObject);
    procedure SchoolCodePasswordCheckBoxClick(Sender: TObject);
    procedure UsesMapsCheckBoxClick(Sender: TObject);
    procedure SysRecTableBeforePost(DataSet: TDataSet);
    procedure SearcherMappingDefaultComboBoxChange(Sender: TObject);
  private
    UnitName : String;  {For use with the error dialog box.}
  public
    FormAccessRights : Integer;  {Read only or read write, based on security level?}
                                {Values = raReadOnly, raReadWrite}
    InitializingForm : Boolean;
    Procedure InitializeForm;  {Open the tables}
  end;

implementation

uses GlblVars, WinUtils, PASUTILS, UTILEXSD,  Types, Utilitys, GlblCnst, PasTypes;

{$R *.DFM}

{=============================================================}
Procedure TSysRecForm.FormActivate(Sender: TObject);

begin
  SetFormStateMaximized(Self);
end;

{=============================================================}
Procedure TSysRecForm.InitializeForm;

var
  HasMapTables, Done, FirstTimeThrough : Boolean;

begin
  UnitName := 'SYSRCMNT';
  InitializingForm := True;
  PageControl.ActivePage := SetupTabSheet;

    {Note that since this does not have anything to do with tax
     roll year, the only thing that determines the access rights
     for this form are the menu security levels.}

    {Only let the supervisor at the navigator bar.}
    {CHG06092010-3(2.26.1)[I7208]: Allow for supervisor equivalents.}

  If UserIsSupervisor(GlblUserName)
    then
      begin
        SaveButton.Visible := True;
        CancelButton.Visible := True;
      end
    else
      begin
        SysRecTable.ReadOnly := True;
        WarningMessageTable.ReadOnly := True;
      end;

  OpenTablesForForm(Self, GlblProcessingType);

    {CHG11112003-1(M1.4): Allow for choosing of default map setup for searcher.}

  HasMapTables := True;
  try
    MappingOptionsHeaderTable.TableName := 'mappingoptionsheader';
    MappingOptionsHeaderTable.Open;
  except
    HasMapTables := False;
  end;

  If HasMapTables
    then
      begin
        MappingOptionsHeaderTable.First;
        Done := False;
        FirstTimeThrough := True;

        repeat
          If FirstTimeThrough
            then FirstTimeThrough := False
            else MappingOptionsHeaderTable.Next;

          If MappingOptionsHeaderTable.EOF
            then Done := True;

          If not Done
            then SearcherMappingDefaultComboBox.Items.Add(MappingOptionsHeaderTable.FieldByName('MappingSetupName').Text);

        until Done;

        SearcherMappingDefaultComboBox.Items.Add(MapSetupDefaultNone);

      end;  {If HasMapTables}

  SearcherMappingDefaultComboBox.Text := SysRecTable.FieldByName('SearcherMapDefault').Text;

  InitializingForm := False;

end;  {InitializeForm}

{===============================================================}
Procedure TSysRecForm.FormKeyPress(    Sender: TObject;
                                   var Key: Char);

begin
  If (Key = #13)
    then
      begin
        Perform(WM_NEXTDLGCTL, 0, 0);
        Key := #0;
      end;

end;  {FormKeyPress}

{==========================================================}
Procedure TSysRecForm.SysRecTableBeforeInsert(DataSet: TDataset);

{FXX05131999-6: Don't allow insert of another system record.}

begin
  If (SysRecTable.RecordCount = 1)
    then
      begin
        MessageDlg('Sorry, there already is a system record.' + #13 +
                   'You may not insert another.', mtError, [mbOK], 0);
        (*Abort;*)
      end;

end;  {SysRecTableBeforeInsert}

{==========================================================}
Procedure TSysRecForm.SchoolCodePasswordCheckBoxClick(Sender: TObject);

begin
  If not InitializingForm
    then
      If SchoolCodePasswordCheckBox.Checked
        then
          begin
            SchoolCodePasswordEdit.Enabled := True;
            SchoolCodePasswordEdit.SetFocus;
            SchoolCodePasswordLabel.Enabled := True;
          end
        else
          begin
            SchoolCodePasswordEdit.Text := '';
            SchoolCodePasswordEdit.Enabled := False;
            SchoolCodePasswordLabel.Enabled := False;

          end;  {else of If SchoolCodePasswordCheckBox.Checked}

end;  {SchoolCodePasswordCheckBoxClick}

{==========================================================}
Procedure TSysRecForm.AllButtonClick(Sender: TObject);

{Select all the warnings.}
{CHG09071999-3: Allow selection of what warning messages are displayed.}

var
  I : Integer;

begin
  with WarningMessageTable do
    begin
      If not (State in [dsEdit, dsInsert])
        then
          If (RecordCount = 0)
            then Insert
            else Edit;

      For I := 0 to (FieldCount - 1) do
        If (Fields[I] is TBooleanField)
          then TBooleanField(Fields[I]).AsBoolean := True;

    end;  {with WarningMessageTable do}

end;  {AllButtonClick}

{==========================================================}
Procedure TSysRecForm.NoneButtonClick(Sender: TObject);

{Unselect all the warnings.}

var
  I : Integer;

begin
  with WarningMessageTable do
    begin
      If not (State in [dsEdit, dsInsert])
        then
          If (RecordCount = 0)
            then Insert
            else Edit;

      For I := 0 to (FieldCount - 1) do
        If (Fields[I] is TBooleanField)
          then TBooleanField(Fields[I]).AsBoolean := False;

    end;  {with WarningMessageTable do}

end;  {NoneButtonClick}

{FXX04161999-5: Allow people to modify other's notes if they want.}
{Had to go to a panel for all options to fit.}

{==========================================================}
Procedure TSysRecForm.CancelButtonClick(Sender: TObject);

begin
  SysRecTable.Cancel;
  WarningMessageTable.Cancel;
end;

{========================================================}
Procedure TSysRecForm.SaveButtonClick(Sender: TObject);

begin
  If (SysRecTable.State = dsEdit)
    then SysRecTable.Post;

  If (WarningMessageTable.State in [dsEdit, dsInsert])
    then WarningMessageTable.Post;

end;  {SaveButtonClick}

{========================================================}
Procedure TSysRecForm.SysRecTableBeforePost(DataSet: TDataSet);

{CHG11112003-1(M1.4): Allow for choosing of default map setup for searcher.}

begin
  SysRecTable.FieldByName('SearcherMapDefault').Text := SearcherMappingDefaultComboBox.Text;
end;

{========================================================}
Procedure TSysRecForm.SearcherMappingDefaultComboBoxChange(Sender: TObject);

begin
  If (SysRecTable.State = dsBrowse)
    then SysRecTable.Edit;

  SysRecTableBeforePost(nil);

end;  {SearcherMappingDefaultComboBoxChange}

{========================================================}
Procedure TSysRecForm.SysRecTableAfterPost(DataSet: TDataset);

{Reset the global variables.}

begin
  SetGlobalSystemVariables(SysRecTable);

end;  {SysRecTableAfterPost}

{=====================================================}
Procedure TSysRecForm.WarningMessageTableAfterPost(DataSet: TDataset);

begin
  SetGlobalWarningOptions(WarningMessageTable);
end;

{=====================================================}
Procedure TSysRecForm.UsesMapsCheckBoxClick(Sender: TObject);

{CHG11112003-1(M1.4): Allow for choosing of default map setup for searcher.}

begin
  If SysRecTable.FieldByName('UsesMaps').AsBoolean
    then SearcherMappingDefaultComboBox.Enabled := True
    else
      begin
        SearcherMappingDefaultComboBox.Text := '';
        SearcherMappingDefaultComboBox.Enabled := False;
      end;

end;  {UsesMapsCheckBoxClick}

{=====================================================}
Procedure TSysRecForm.FormCloseQuery(    Sender: TObject;
                                     var CanClose: Boolean);

var
  ReturnCode : Integer;

begin
  If SysRecTable.Modified
    then
      begin
        ReturnCode := MessageDlg('Do you want to save the changes to the system record?',
                                 mtConfirmation, [mbYes, mbNo, mbCancel], 0);

        case ReturnCode of
          idYes : SaveButtonClick(Sender);
          idNo : CancelButtonClick(Sender);
          idCancel : CanClose := False;
        end;

      end;  {If SysRecTable.Modified}

end;  {FormCloseQuery}

{=====================================================}
Procedure TSysRecForm.FormClose(    Sender: TObject;
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