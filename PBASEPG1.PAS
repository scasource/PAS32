unit PBasePg1;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, DBCtrls, DB, DBTables, Mask, ExtCtrls, Dialogs, Buttons,
  Types, Wwtable, wwdblook, Wwdatsrc, BtrvDlg, Tabs, PASTypes, StdCtrls,
  Password;

type
  TBaseParcelPg1Form = class(TForm)
    ScrollBox: TScrollBox;
    Label10: TLabel;
    Label11: TLabel;
    EditName: TDBEdit;
    Label12: TLabel;
    EditName2: TDBEdit;
    Label13: TLabel;
    EditAddress: TDBEdit;
    Label14: TLabel;
    EditAddress2: TDBEdit;
    Label15: TLabel;
    EditStreet: TDBEdit;
    SwisLabel: TLabel;
    EditCity: TDBEdit;
    Label17: TLabel;
    EditState: TDBEdit;
    EditZip: TDBEdit;
    Label19: TLabel;
    EditPropDescr: TDBEdit;
    Label20: TLabel;
    EditPropDescr2: TDBEdit;
    Label21: TLabel;
    EditPropDescr3: TDBEdit;
    Label22: TLabel;
    Label23: TLabel;
    Label25: TLabel;
    EditLegalAddrNo: TDBEdit;
    Label26: TLabel;
    EditLegalAddr: TDBEdit;
    Panel1: TPanel;
    Panel2: TPanel;
    Label2: TLabel;
    EditSwis: TDBEdit;
    Label30: TLabel;
    EditZipPlus4: TDBEdit;
    Label3: TLabel;
    YearLabel: TLabel;
    Label4: TLabel;
    EditSection: TDBEdit;
    Label5: TLabel;
    EditSubsection: TDBEdit;
    Label6: TLabel;
    EditBlock: TDBEdit;
    Label7: TLabel;
    EditLot: TDBEdit;
    Label8: TLabel;
    EditSublot: TDBEdit;
    Label16: TLabel;
    EditSuffix: TDBEdit;
    Label18: TLabel;
    EditCheckDigit: TDBEdit;
    CloseButton: TBitBtn;
    SaveButton: TBitBtn;
    CancelButton: TBitBtn;
    TitleLabel: TLabel;
    Label1: TLabel;
    Label28: TLabel;
    PropClassDBLookupCombo: TwwDBLookupCombo;
    CodeTable: TwwTable;
    HomesteadDBLookupCombo: TwwDBLookupCombo;
    EditBankCode: TDBEdit;
    StatusLabel: TDBEdit;
    Label9: TLabel;
    EditCreationDate: TDBEdit;
    Label29: TLabel;
    Label32: TLabel;
    EditLastChangeDate: TDBEdit;
    Label33: TLabel;
    EditLastChangeByName: TDBEdit;
    Label34: TLabel;
    EditNumResSites: TEdit;
    Label35: TLabel;
    EditNumComSites: TEdit;
    PropertyClassDesc: TLabel;
    HomeSteadDesc: TLabel;
    SchoolCodeLookup: TwwDBLookupCombo;
    SchoolCodeTable: TwwTable;
    Label36: TLabel;
    Label37: TLabel;
    ThisYearAVLabel: TLabel;
    NextYearAVLabel: TLabel;
    EditTYTaxableVal: TEdit;
    EditNYTaxableVal: TEdit;
    EditTYAssessedVal: TEdit;
    EditNYAssessedVal: TEdit;
    RollSectionLabel: TLabel;
    RollSectionDBLookupCombo: TwwDBLookupCombo;
    Label42: TLabel;
    RollSectionTable: TwwTable;
    EditFrontage: TDBEdit;
    Label40: TLabel;
    Label41: TLabel;
    EditDepth: TDBEdit;
    AcreLabel: TLabel;
    EditAcreage: TDBEdit;
    InactiveLabel: TLabel;
    Label27: TLabel;
    Label43: TLabel;
    EditRollSubsection: TDBEdit;
    ResidentialPercentLabel: TLabel;
    ResidentialPercentDBEdit: TDBEdit;
    ClassTable: TTable;
    ParcelSplitPanel: TPanel;
    Label54: TLabel;
    GroupBox1: TGroupBox;
    EditHstdLandPercent: TEdit;
    EditHstdTotalPercent: TEdit;
    Label51: TLabel;
    Label52: TLabel;
    SplitParcelCancelButton: TBitBtn;
    SplitParcelOKButton: TBitBtn;
    ParcelTable: TwwTable;
    ParcelDataSource: TwwDataSource;
    EditPriorAssessedVal: TEdit;
    EditPriorTaxableVal: TEdit;
    PriorYearAVLabel: TLabel;
    OppositeYearParcelTable: TTable;
    OppositeYearClassTable: TTable;
    SchoolNameDBText: TDBText;
    SchoolCodeDataSource: TwwDataSource;
    Label53: TLabel;
    Label55: TLabel;
    TotalAVLabel: TLabel;
    LandAVLabel: TLabel;
    Label31: TLabel;
    Label56: TLabel;
    SetFocusTimer: TTimer;
    SwisCodeLabel: TLabel;
    RollSection9Label: TLabel;
    OwnerChangeLabel: TLabel;
    Label59: TLabel;
    OwnershipCodeLookupCombo: TwwDBLookupCombo;
    OwnershipDesc: TLabel;
    OldParcelIDLabel: TLabel;
    ParcelExemptionTable: TTable;
    AuditParcelChangeTable: TTable;
    AuditEXChangeTable: TTable;
    SchoolPasswordDlg: TPasswordDlg;
    PartialAssessmentLabel: TLabel;
    BankCodeFreezeButton: TBitBtn;
    MortgageNumberPanel: TPanel;
    Label24: TLabel;
    EditMortgage: TDBEdit;

    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SaveButtonClick(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject);
    procedure CloseButtonClick(Sender: TObject);
    procedure ParcelTableAfterEdit(DataSet: TDataset);
    procedure ParcelTableAfterPost(DataSet: TDataset);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure CodeLookupEnter(Sender: TObject);
    procedure ParcelTableBeforePost(DataSet: TDataset);
    procedure EditHstdPercentExit(Sender: TObject);
    procedure SplitParcelCancelButtonClick(Sender: TObject);
    procedure SplitParcelOKButtonClick(Sender: TObject);
    procedure ParcelSplitPanelExit(Sender: TObject);
    procedure EditNameAddrKeyPress(Sender: TObject; var Key: Char);
    procedure EditAcreageExit(Sender: TObject);
    procedure SetFocusTimerTimer(Sender: TObject);
    procedure OwnerChangeLabelClick(Sender: TObject);
    procedure SetCodeOnLookupCloseUp(Sender: TObject; LookupTable,
      FillTable: TDataSet; modified: Boolean);
    procedure RollSectionDBLookupComboCloseUp(Sender: TObject; LookupTable,
      FillTable: TDataSet; modified: Boolean);
    procedure EditBankCodeExit(Sender: TObject);
    procedure BankCodeFreezeButtonClick(Sender: TObject);
    procedure AnyTableNewRecord(DataSet: TDataSet);
    procedure EditMortgageExit(Sender: TObject);
    procedure OwnershipCodeLookupComboExit(Sender: TObject);

      {override method of parent object so we can set parent and style of}
    {this 'nested' forms}
  protected
    procedure CreateParams(var Params: TCreateParams); override;

  private
    { private declarations }
  public
    { public declarations }
    UnitName : String;  {For use with error dialog box.}

      {These will be set in the ParcelTabForm.}

    EditMode : Char;  {A = Add; M = Modify; V = View; D = Delete; R = Reactivate}
    TaxRollYr : String;
    SwisSBLKey : String;
    ProcessingType : Integer;  {NextYear, ThisYear, History}
    NumResSites,
    NumComSites : Integer;  {Number of commercial and residential sites for this
                             parcel.}

        {These var.'s are for tracing changes.}

    FieldTraceInformationList : TList;

      {Have there been any changes?}

    ParcelChanged : Boolean;

    FormAccessRights : Integer;  {Read only or read write, based on security level?}
                                {Values = raReadOnly, raReadWrite}
    FormIsInitializing,
    AssessmentRecordFound,
    ClassRecordFound : Boolean;  {Is there a class record for this parcel?}

      {For keeping track of roll total changes.}

    OrigSchoolCode : String;
    OrigRollSection,
    OrigHomesteadCode : String;
    OrigHomesteadDesc : String;
    OrigResidentialPercent, OrigFrontage,
    OrigDepth, OrigAcreage : Real;
    OrigPropertyClass : String;

      {These variables are for keeping track of exemption
       and SD roll total changes.}

    OrigTotalAssessedVal,
    OrigLandAssessedVal,
    OrigHstdLandVal,
    OrigNonhstdLandVal,
    OrigHstdAssessedVal,
    OrigNonHstdAssessedVal : Comp;
    OrigExemptionCodes,
    OrigExemptionHomesteadCodes,
    OrigResidentialTypes,
    OrigCountyExemptionAmounts,
    OrigTownExemptionAmounts,
    OrigSchoolExemptionAmounts,
    OrigVillageExemptionAmounts : TStringList;
    OrigBasicSTARAmount, OrigEnhancedSTARAmount : Comp;
    OrigSDAmounts : TList;
    OrigAuditParcelRec : AuditParcelRecord;

    ParcelTabSet : TTabSet;  {The tab set from PARCLTAB - we need this so that if they
                              want to add sales inventory tabs, we add them on to the
                              actual tab object.}

    TabTypeList :  TStringList;  {This is the list corresponding to the parcel tab set
                                  which tells us what processing type each tab is, i.e.
                                  ThisYear, NextYear, History, or SalesInventory.}
    PanelButtonPressed : Boolean;  {This is to make that they don't exit the panel by a way
                                    other than pressing a button.}

      {CHG10281997-1: Dual mode processing.}

    OppositeProcessingType : Integer;
    OppositeTaxYear : String;
    OppositeYearParcelChanged : Boolean;

    OrigNameAddressBankCodeRec,
    NewNameAddressBankCodeRec : NameAddressBankCodeRecord;

    OriginalFieldValues,
    NewFieldValues : TStringList;

    OrigNameAddressRec,
    NewNameAddressRec : NameAddressRecord;

    AssessmentTable, SDCodeTable,
    ParcelSDTable, AssessmentYearControlTable,
    SwisCodeTable, ExemptionCodeTable : TTable;
    PasswordAlreadyAttempted, PasswordEnteredCorrectly : Boolean;
    DefaultEdit : TDBEdit;

    Procedure InitializeForm;
    Procedure SetFocusToFirstField;

    Procedure GetHistoryValues(var PriorAssessedValue,
                                   PriorTaxableValue : Comp;
                               var PriorActiveStatus : Integer;
                               var PriorAssessedValueFound : Boolean);
    {Determine the assessed and taxable value for the prior year.
     We may not find them. In this case, we will use the values from the ThisYear
     assessed value and we will not display the taxable value since there is no
     way to recover the exemptions from the prior year.}

    Procedure DisplayNextYearTaxableAndAssessedValue;
    {Determine the assessed and taxable value for next year and display them.}
    Procedure DisplayThisYearTaxableAndAssessedValue(var PriorAssessedVal,
                                                         PriorTaxableVal : Comp;
                                                         PriorAssessedValFound : Boolean);
    {Determine the assessed and taxable value for this year and display them.}

    Function DetermineCodeTableName(Tag : Integer) : String;
    Procedure SetCodeTableName(Tag : Integer);
    Procedure DisplayAssessedAndTaxableValues;
    Procedure DisplayOwnerChangeFlag;

    Procedure SetBankCodeFreezeStatus;

    Procedure FillInAssessedAndTaxableValues(ProcessingType : Integer;
                                             AssessmentYear : String;
                                             ProcessingTypeFlag : Char;
                                             AVLabel : TLabel;
                                             AssessedValueEdit : TEdit;
                                             TaxableValueEdit : TEdit);
end;

implementation

{$R *.DFM}

Uses Glblvars, PASUTILS, UTILEXSD,  WinUtils, Utilitys, GlblCnst,
     DataModule,
     DataAccessUnit,
     UtilPrcl,  {Utilitys for parcel maintenance only - VERY IMPORTANT!}
     UTILRTOT;  {Roll total update unit.}

const
    {This is a unique number for each lookup box stored in that
     lookup's tag field. This is because we have only one code table and
     as they enter each lookup, we change the name of the code table to be
     the table for this lookup. To use this, set the tag field of each
     lookup combo box to a unique number and list it below.}

    {To use the hints, create unique numerical tags for each lookup combo box
     and list them below (LLL1).
     Also, put the constants of the lookups that will be description based
     in the DescriptionIndexedLookups array (LLL2).
     Then go to the DetermineCodeTableName procedure
     (LLL3) and change the table name assignments. Then set the OnEnter event
     for all LookupCombo boxes to CodeLookupEnter and the OnCloseUp for all
     LookupCombo boxes to SetCodeOnLookupCloseUp.}

  PropertyClass = 10;  {LLL1}
  Homestead = 20;
  OwnershipCode = 30;

    {Now we will put the lookups that are description based in a set for later
     reference.}

  DescriptionIndexedLookups : DropdownTagIDSetType = [];

{===========================================================================}
Procedure TBaseParcelPg1Form.CreateParams(var Params: TCreateParams);

begin
  inherited CreateParams(Params);

  with Params do
    begin
                    {?????????}
      WndParent := Application.Mainform.Handle;
      Style := (Style or WS_Child) and not WS_Popup;
    end;

end;  {CreateParams}

{========================================================================}
Procedure TBaseParcelPg1Form.GetHistoryValues(var PriorAssessedValue,
                                                  PriorTaxableValue : Comp;
                                              var PriorActiveStatus : Integer;
                                              var PriorAssessedValueFound : Boolean);

{Determine the assessed and taxable value for the prior year.
 We may not find them. In this case, we will use the values from the ThisYear
 assessed value and we will not display the taxable value since there is no
 way to recover the exemptions from the prior year.}

var
  BasicSTARAmount, EnhancedSTARAmount : Comp;
  Found : Boolean;
  ExemptArray : ExemptionTotalsArrayType;
  ExemptionCodes,
  ExemptionHomesteadCodes,
  ResidentialTypes,
  CountyExemptionAmounts,
  TownExemptionAmounts,
  SchoolExemptionAmounts,
  VillageExemptionAmounts : TStringList;
  TempYear : Integer;
  PriorYear : String;
  ParcelExemptionLookupTable : TTable;

begin
  ExemptionCodes := TStringList.Create;
  ExemptionHomesteadCodes := TStringList.Create;
  ResidentialTypes := TStringList.Create;
  CountyExemptionAmounts := TStringList.Create;
  TownExemptionAmounts := TStringList.Create;
  SchoolExemptionAmounts := TStringList.Create;
  VillageExemptionAmounts := TStringList.Create;

  PriorAssessedValue := 0;
  PriorTaxableValue := 0;
  PriorAssessedValueFound := False;

  TempYear := StrToInt(GlblThisYear);
  PriorYear := IntToStr(TempYear - 1);
  PriorAssessedValue := 0;
  PriorTaxableValue := 0;

  AssessmentTable := FindTableInDataModuleForProcessingType(DataModuleAssessmentTableName,
                                                            History);
  ParcelExemptionLookupTable := FindTableInDataModuleForProcessingType(DataModuleExemptionTableName,
                                                                       History);

  Found := FindKeyOld(AssessmentTable, ['TaxRollYr', 'SwisSBLKey'], [PriorYear, SwisSBLKey]);

  If not Found
    then
      begin
        PriorAssessedValue := 0;
        PriorTaxableValue := 0;
      end
    else
      begin
        PriorAssessedValue := TCurrencyField(AssessmentTable.FieldByName('TotalAssessedVal')).AsFloat;

          {Get the total exemptions for the parcel so that we can figure
           out the assessed value.}
          {CHG12011997-2: STAR support}
          {FXX02091998-1: Pass the residential type of each exemption.}

        ExemptArray := TotalExemptionsForParcel(PriorYear, SwisSBLKey,
                                                ParcelExemptionLookupTable,
                                                ExemptionCodeTable,
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

          {Note that we will display the taxable value of the
           municipality type that is running PAS.}

        PriorTaxableValue := PriorAssessedValue - ExemptArray[GetMunicipalityType(GlblMunicipalityType)];

        PriorAssessedValueFound := True;

      end;  {If not Found}

  PriorYearAVLabel.Caption := 'Prior Year ''' + Copy(PriorYear, 3, 2);

  PriorActiveStatus := CheckIfParcelIsActive(PriorYear, History, SwisSBLKey);

  ExemptionCodes.Free;
  ExemptionHomesteadCodes.Free;
  ResidentialTypes.Free;
  CountyExemptionAmounts.Free;
  TownExemptionAmounts.Free;
  SchoolExemptionAmounts.Free;
  VillageExemptionAmounts.Free;

end;  {GetHistoryValues}

{========================================================================}
Procedure TBaseParcelPg1Form.DisplayNextYearTaxableAndAssessedValue;

{Determine the assessed and taxable value for next year and display them.}

var
  BasicSTARAmount, EnhancedSTARAmount,
  AssessedVal, TaxableVal : Comp;
  Found : Boolean;
  ActiveParcel : Integer;
  ExemptArray : ExemptionTotalsArrayType;
  ExemptionCodes,
  ExemptionHomesteadCodes,
  ResidentialTypes,
  CountyExemptionAmounts,
  TownExemptionAmounts,
  SchoolExemptionAmounts,
  VillageExemptionAmounts : TStringList;
  TempStr : String;
  ParcelExemptionLookupTable : TTable;

begin
  ExemptionCodes := TStringList.Create;
  ExemptionHomesteadCodes := TStringList.Create;
  ResidentialTypes := TStringList.Create;
  CountyExemptionAmounts := TStringList.Create;
  TownExemptionAmounts := TStringList.Create;
  SchoolExemptionAmounts := TStringList.Create;
  VillageExemptionAmounts := TStringList.Create;

  AssessmentTable := FindTableInDataModuleForProcessingType(DataModuleAssessmentTableName,
                                                            NextYear);
  ParcelExemptionLookupTable := FindTableInDataModuleForProcessingType(DataModuleExemptionTableName,
                                                                       NextYear);

  Found := FindKeyOld(AssessmentTable, ['TaxRollYr', 'SwisSBLKey'],
                      [GlblNextYear, SwisSBLKey]);

  If not Found
    then
      begin
        AssessedVal := 0;
        TaxableVal := 0;
      end
    else
      begin
        AssessedVal := TCurrencyField(AssessmentTable.FieldByName('TotalAssessedVal')).AsFloat;

          {Get the total exemptions for the parcel so that we can figure
           out the assessed value.}
          {CHG12011997-2: STAR support}
          {FXX02091998-1: Pass the residential type of each exemption.}

        ExemptArray := TotalExemptionsForParcel(GlblNextYear, SwisSBLKey,
                                                ParcelExemptionLookupTable,
                                                ExemptionCodeTable,
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

          {Note that we will display the taxable value of the
           municipality type that is running PAS.}
         {FXX05261998-3: Don't let a taxable value decrease below 0.}

        TaxableVal := CalculateTaxableVal(AssessedVal, ExemptArray[GetMunicipalityType(GlblMunicipalityType)]);

      end;  {If not Found}

    {CHG06291999-1: Keep the searcher from seeing next year values.}
    {FXX05012000-8: If the parcel is inactive, then say so.}

  ActiveParcel := CheckIfParcelIsActive(GlblNextYear, NextYear, SwisSBLKey);

  If ((not GlblUserIsSearcher) or
      (GlblUserIsSearcher and
       SearcherCanSeeNYValues))
    then
      If (ActiveParcel = atActive)
        then
          begin
            EditNYAssessedVal.Text := FormatFloat(CurrencyNormalDisplay, AssessedVal);
            EditNYTaxableVal.Text := FormatFloat(CurrencyNormalDisplay, TaxableVal);
          end
        else
          begin
            If (ActiveParcel = atInactive)
              then TempStr := InactiveLabelText
              else TempStr := DoesNotExistLabelText;

            EditNYAssessedVal.Text := TempStr;
            EditNYTaxableVal.Text := TempStr;

          end;  {else of If (ActiveParcel = atActive)}

  NextYearAVLabel.Caption := 'Next Year ''' + Copy(GlblNextYear, 3, 2);

  ExemptionCodes.Free;
  ExemptionHomesteadCodes.Free;
  ResidentialTypes.Free;
  CountyExemptionAmounts.Free;
  TownExemptionAmounts.Free;
  SchoolExemptionAmounts.Free;
  VillageExemptionAmounts.Free;

end;  {DisplayNextYearTaxableAndAssessedValue}

{========================================================================}
Procedure TBaseParcelPg1Form.DisplayThisYearTaxableAndAssessedValue(var PriorAssessedVal,
                                                                        PriorTaxableVal : Comp;
                                                                        PriorAssessedValFound : Boolean);

{Determine the assessed and taxable value for this year and display them.}

var
  BasicSTARAmount, EnhancedSTARAmount,
  AssessedVal, TaxableVal : Comp;
  Found : Boolean;
  ActiveParcel : Integer;
  ExemptArray : ExemptionTotalsArrayType;
  ExemptionCodes,
  ExemptionHomesteadCodes,
  ResidentialTypes,
  CountyExemptionAmounts,
  TownExemptionAmounts,
  SchoolExemptionAmounts,
  VillageExemptionAmounts : TStringList;
  TempStr, FormatString : String;
  ParcelExemptionLookupTable : TTable;

begin
  ExemptionCodes := TStringList.Create;
  ExemptionHomesteadCodes := TStringList.Create;
  ResidentialTypes := TStringList.Create;
  CountyExemptionAmounts := TStringList.Create;
  TownExemptionAmounts := TStringList.Create;
  SchoolExemptionAmounts := TStringList.Create;
  VillageExemptionAmounts := TStringList.Create;

  AssessmentTable := FindTableInDataModuleForProcessingType(DataModuleAssessmentTableName,
                                                            ThisYear);
  ParcelExemptionLookupTable := FindTableInDataModuleForProcessingType(DataModuleExemptionTableName,
                                                                       ThisYear);

  Found := FindKeyOld(AssessmentTable, ['TaxRollYr', 'SwisSBLKey'],
                      [GlblThisYear, SwisSBLKey]);

  If not Found
    then
      begin
        AssessedVal := 0;
        TaxableVal := 0;
      end
    else
      begin
        AssessedVal := TCurrencyField(AssessmentTable.FieldByName('TotalAssessedVal')).AsFloat;

          {If there was no history record for this parcel, take the assessed
           value from the prior field and there is no taxable since we do
           not know what the exemptions were.}

        If not PriorAssessedValFound
          then PriorAssessedVal := TCurrencyField(AssessmentTable.FieldByName('PriorTotalValue')).AsFloat;

          {Get the total exemptions for the parcel so that we can figure
           out the assessed value.}
          {CHG12011997-2: STAR support}
          {FXX02091998-1: Pass the residential type of each exemption.}

        ExemptArray := TotalExemptionsForParcel(GlblThisYear, SwisSBLKey,
                                                ParcelExemptionLookupTable,
                                                ExemptionCodeTable,
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

          {Note that we will display the taxable value of the
           municipality type that is running PAS.}
         {FXX05261998-3: Don't let a taxable value decrease below 0.}

        TaxableVal := CalculateTaxableVal(AssessedVal, ExemptArray[GetMunicipalityType(GlblMunicipalityType)]);

      end;  {else of If not Found}

    {FXX05012000-8: If the parcel is inactive, then say so.}

  ActiveParcel := CheckIfParcelIsActive(GlblThisYear, ThisYear, SwisSBLKey);

    {CHG04262007-1(2.11.1.26): Allow for option to suppress $ on assessments.}

  FormatString := GetAssessmentDisplayFormat;

  If (ActiveParcel = atActive)
    then
      begin
        EditTYAssessedVal.Text := FormatFloat(FormatString, AssessedVal);
        EditTYTaxableVal.Text := FormatFloat(FormatString, TaxableVal);
      end
    else
      begin
        If (ActiveParcel = atInactive)
          then TempStr := InactiveLabelText
          else TempStr := DoesNotExistLabelText;

        EditTYAssessedVal.Text := TempStr;
        EditTYTaxableVal.Text := TempStr;

      end;  {If (ActiveParcel = atActive)}

  ThisYearAVLabel.Caption := 'This Year ''' + Copy(GlblThisYear, 3, 2);

  ExemptionCodes.Free;
  ExemptionHomesteadCodes.Free;
  ResidentialTypes.Free;
  CountyExemptionAmounts.Free;
  TownExemptionAmounts.Free;
  SchoolExemptionAmounts.Free;
  VillageExemptionAmounts.Free;

end;  {DisplayThisYearTaxableAndAssessedValue}

{===========================================================================}
Procedure TBaseParcelPg1Form.FillInAssessedAndTaxableValues(ProcessingType : Integer;
                                                            AssessmentYear : String;
                                                            ProcessingTypeFlag : Char;
                                                            AVLabel : TLabel;
                                                            AssessedValueEdit : TEdit;
                                                            TaxableValueEdit : TEdit);

{CHG04302003-3(2.07a): Option to always show 2 years prior from year that
                       they are in.}

var
  Found : Boolean;
  ActiveParcel : Integer;
  AssessedVal, TaxableVal,
  BasicSTARAmount, EnhancedSTARAmount : Comp;
  ExemptArray : ExemptionTotalsArrayType;
  ExemptionCodes,
  ExemptionHomesteadCodes,
  ResidentialTypes,
  CountyExemptionAmounts,
  TownExemptionAmounts,
  SchoolExemptionAmounts,
  VillageExemptionAmounts : TStringList;
  TempStr, FormatString : String;
  AssessmentTable, ParcelExemptionLookupTable : TTable;

begin
  ExemptionCodes := TStringList.Create;
  ExemptionHomesteadCodes := TStringList.Create;
  ResidentialTypes := TStringList.Create;
  CountyExemptionAmounts := TStringList.Create;
  TownExemptionAmounts := TStringList.Create;
  SchoolExemptionAmounts := TStringList.Create;
  VillageExemptionAmounts := TStringList.Create;

  AssessmentTable := FindTableInDataModuleForProcessingType(DataModuleAssessmentTableName,
                                                            ProcessingType);
  ParcelExemptionLookupTable := FindTableInDataModuleForProcessingType(DataModuleExemptionTableName,
                                                                       ProcessingType);

  Found := FindKeyOld(AssessmentTable, ['TaxRollYr', 'SwisSBLKey'],
                      [AssessmentYear, SwisSBLKey]);

  If not Found
    then
      begin
        AssessedVal := 0;
        TaxableVal := 0;
      end
    else
      begin
        AssessedVal := TCurrencyField(AssessmentTable.FieldByName('TotalAssessedVal')).AsFloat;

          {Get the total exemptions for the parcel so that we can figure
           out the assessed value.}
          {CHG12011997-2: STAR support}
          {FXX02091998-1: Pass the residential type of each exemption.}

        ExemptArray := TotalExemptionsForParcel(AssessmentYear, SwisSBLKey,
                                                ParcelExemptionLookupTable,
                                                ExemptionCodeTable,
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

          {Note that we will display the taxable value of the
           municipality type that is running PAS.}
         {FXX05261998-3: Don't let a taxable value decrease below 0.}

        TaxableVal := CalculateTaxableVal(AssessedVal, ExemptArray[GetMunicipalityType(GlblMunicipalityType)]);

      end;  {else of If not Found}

    {FXX05012000-8: If the parcel is inactive, then say so.}

  ActiveParcel := CheckIfParcelIsActive(AssessmentYear, ProcessingType, SwisSBLKey);

    {CHG04262007-1(2.11.1.26): Allow for option to suppress $ on assessments.}

  FormatString := GetAssessmentDisplayFormat;

  If (ActiveParcel = atActive)
    then
      begin
        If Found
          then
            begin
              AssessedValueEdit.Text := FormatFloat(FormatString, AssessedVal);
              TaxableValueEdit.Text := FormatFloat(FormatString, TaxableVal);
            end
          else
            begin
              AssessedValueEdit.Text := '';
              TaxableValueEdit.Text := '';
            end;  {else of If Found}

      end
    else
      begin
        If (ActiveParcel = atInactive)
          then TempStr := InactiveLabelText
          else TempStr := DoesNotExistLabelText;

        AssessedValueEdit.Text := TempStr;
        TaxableValueEdit.Text := TempStr;

      end;  {If (ActiveParcel = atActive)}

  AVLabel.Caption := ConvertYearBeingProcessedToText(ProcessingTypeFlag) + ' ''' +
                     Copy(AssessmentYear, 3, 2);

  ExemptionCodes.Free;
  ExemptionHomesteadCodes.Free;
  ResidentialTypes.Free;
  CountyExemptionAmounts.Free;
  TownExemptionAmounts.Free;
  SchoolExemptionAmounts.Free;
  VillageExemptionAmounts.Free;

end;  {FillInAssessedAndTaxableValues}

{===========================================================================}
Procedure TBaseParcelPg1Form.DisplayAssessedAndTaxableValues;

{FXX05181999-1: Update the taxable vals based on recalculating exemptions.}

var
  PriorAssessedValueFound : Boolean;
  PriorAssessedValue, PriorTaxableValue : Comp;
  TempStr : String;
  PriorActiveStatus : Integer;
  CurrentYear, PriorYear, SecondPriorYear : String;
  CurrentYearProcessingType,
  PriorYearProcessingType,
  SecondPriorYearProcessingType : Integer;
  CurrentYearTaxFlag, PriorYearTaxFlag, SecondPriorYearTaxFlag : Char;

begin
  PriorAssessedValueFound := False;

  CurrentYearProcessingType := ThisYear;
  CurrentYear := GlblThisYear;
  CurrentYearTaxFlag := 'T';
  PriorYearProcessingType := History;
  PriorYear := IntToStr(StrToInt(GlblThisYear) - 1);
  PriorYearTaxFlag := 'H';
  SecondPriorYearProcessingType := History;
  SecondPriorYear := IntToStr(StrToInt(GlblThisYear) - 2);
  SecondPriorYearTaxFlag := 'H';

    {FXX10061999-2: Make sure that when they are in a history year, the TY and NY
                    are displayed also.}
    {CHG04302003-3(2.07a): Option to always show 2 years prior from year that
                           they are in.}

  If GlblSummaryAndPage1ValueInformationIsAlwaysPrior2Years
    then
      begin
        case GlblProcessingType of
          NextYear :
            begin
              CurrentYearProcessingType := NextYear;
              CurrentYear := GlblNextYear;
              CurrentYearTaxFlag := 'N';
              PriorYearProcessingType := ThisYear;
              PriorYear := GlblThisYear;
              PriorYearTaxFlag := 'T';
              SecondPriorYearProcessingType := History;
              SecondPriorYear := IntToStr(StrToInt(GlblThisYear) - 1);
              SecondPriorYearTaxFlag := 'H';

            end;  {NextYear}

          ThisYear :
            begin
              CurrentYearProcessingType := ThisYear;
              CurrentYear := GlblThisYear;
              CurrentYearTaxFlag := 'T';
              PriorYearProcessingType := History;
              PriorYear := IntToStr(StrToInt(GlblThisYear) - 1);
              PriorYearTaxFlag := 'H';
              SecondPriorYearProcessingType := History;
              SecondPriorYear := IntToStr(StrToInt(GlblThisYear) - 2);
              SecondPriorYearTaxFlag := 'H';

            end;  {ThisYear}

          History :
            begin
              CurrentYearProcessingType := History;
              CurrentYear := IntToStr(StrToInt(GlblThisYear) - 1);
              CurrentYearTaxFlag := 'H';
              PriorYearProcessingType := History;
              PriorYear := IntToStr(StrToInt(GlblThisYear) - 2);
              PriorYearTaxFlag := 'H';
              SecondPriorYearProcessingType := History;
              SecondPriorYear := IntToStr(StrToInt(GlblThisYear) - 3);
              SecondPriorYearTaxFlag := 'H';

            end;  {History}

        end;  {case GlblProcessingType of}

        FillInAssessedAndTaxableValues(CurrentYearProcessingType,
                                       CurrentYear,
                                       CurrentYearTaxFlag,
                                       NextYearAVLabel,
                                       EditNYAssessedVal,
                                       EditNYTaxableVal);

        FillInAssessedAndTaxableValues(PriorYearProcessingType,
                                       PriorYear,
                                       PriorYearTaxFlag,
                                       ThisYearAVLabel,
                                       EditTYAssessedVal,
                                       EditTYTaxableVal);

        FillInAssessedAndTaxableValues(SecondPriorYearProcessingType,
                                       SecondPriorYear,
                                       SecondPriorYearTaxFlag,
                                       PriorYearAVLabel,
                                       EditPriorAssessedVal,
                                       EditPriorTaxableVal);

      end
    else
      begin
        GetHistoryValues(PriorAssessedValue, PriorTaxableValue, PriorActiveStatus,
                         PriorAssessedValueFound);

        case GlblTaxYearFlg of
          'H',
          'T' : begin
                  DisplayNextYearTaxableAndAssessedValue;
                  DisplayThisYearTaxableAndAssessedValue(PriorAssessedValue,
                                                         PriorTaxableValue,
                                                         PriorAssessedValueFound);
                end;  {This Year}

          'N' : begin
                  DisplayThisYearTaxableAndAssessedValue(PriorAssessedValue,
                                                         PriorTaxableValue,
                                                         PriorAssessedValueFound);
                  DisplayNextYearTaxableAndAssessedValue;

                end;  {Next Year}

        end;  {case GlblTaxYearFlg of}

            {FXX02081999-4: Only display prior info if the parcel was created
                          before TY.}

        Tempstr := ParcelTable.FieldByName('SplitMergeNo').Text;
        TempStr := ParcelTable.FieldByName('ParcelCreatedDate').Text;
        If (ParcelTable.FieldByName('ParcelCreatedDate').AsDateTime >=
            StrToDate('1/1/' + GlblThisYear))
          then
            begin
              PriorAssessedValue := 0;
              PriorTaxableValue := 0;
            end;

          {FXX05012000-8: If the parcel is inactive, then say so.}
          {Fill in the prior assessed and taxable values.}

        If ((PriorActiveStatus = atActive) or
            (Roundoff(PriorAssessedValue, 0) > 0))  {Gotten from prior fields?}
          then
            begin
              EditPriorAssessedVal.Text := FormatFloat(CurrencyNormalDisplay, PriorAssessedValue);

              If PriorAssessedValueFound
                then EditPriorTaxableVal.Text := FormatFloat(CurrencyNormalDisplay, PriorTaxableValue);
            end
          else
            begin
              If (PriorActiveStatus = atInactive)
                then TempStr := InactiveLabelText
                else TempStr := DoesNotExistLabelText;

              EditPriorAssessedVal.Text := TempStr;
              EditPriorTaxableVal.Text := TempStr;

            end;  {else of If ((PriorActiveStatus = atActive) or ...}

      end;  {else of If GlblSummaryAndPage1ValueInformationIsAlwaysPrior2Years}

end;  {DisplayAssessedAndTaxableValues}

{===========================================================================}
Procedure TBaseParcelPg1Form.DisplayOwnerChangeFlag;

var
  TempStr : String;

begin
  GlblNameAddressTraceTable.CancelRange;
  SetRangeOld(GlblNameAddressTraceTable,
              ['SwisSBLKey', 'Date', 'Time'],
              [SwisSBLKey, '1/1/1900', '12:00 PM'],
              [SwisSBLKey, '1/1/3000', '12:00 PM']);
  GlblNameAddressTraceTable.Last;
  TempStr := GlblNameAddressTraceTable.FieldByName('CheckedOff').Text;

    {FXX03292000-1: Only display if actual owner change - not any change.}

  OwnerChangeLabel.Visible := ((Deblank(TempStr) <> '') and
                               (not GlblNameAddressTraceTable.FieldByName('CheckedOff').AsBoolean) and
                               _Compare(GlblNameAddressTraceTable.FieldByName('OldName1').Text,
                                        GlblNameAddressTraceTable.FieldByName('NewName1').Text, coNotEqual));

end;  {DisplayOwnerChangeFlag}

{===========================================================================}
Procedure DisplayUnlockStatus(BankCodeFreezeButton : TBitBtn);

{CHG04192003-1(2.07b): Allow for bank codes to be frozen.}

begin
  with BankCodeFreezeButton do
    try
      Caption := 'Unlock';
      Glyph.LoadFromFile(GlblDrive + ':' + GlblProgramDir + 'Graphics\LockOpen.BMP');
    except
    end;

end;  {DisplayUnlockStatus}

{===========================================================================}
Procedure DisplayLockStatus(BankCodeFreezeButton : TBitBtn);

{CHG04192003-1(2.07b): Allow for bank codes to be frozen.}

begin
  with BankCodeFreezeButton do
    try
      Caption := 'Lock';
      Glyph.LoadFromFile(GlblDrive + ':' + GlblProgramDir + 'Graphics\LockShut.BMP');
    except
    end;

end;  {DisplayLockStatus}

{===========================================================================}
Procedure TBaseParcelPg1Form.SetBankCodeFreezeStatus;

{CHG04192003-1(2.07b): Allow for bank codes to be frozen.}

begin
  If (GlblAllowBankCodeFreeze and
      (Deblank(ParcelTable.FieldByName('BankCode').Text) = ''))
    then
      begin
        BankCodeFreezeButton.Visible := True;

        If ParcelTable.FieldByName('BankCodeFrozen').AsBoolean
          then
            begin
              DisplayUnlockStatus(BankCodeFreezeButton);
              MakeEditReadOnly(EditBankCode, ParcelTable, False, '');
            end
          else
            begin
              DisplayLockStatus(BankCodeFreezeButton);
              MakeEditNotReadOnly(EditBankCode);

            end  {else of If ParcelTable.FieldByName('BankCodeFrozen').AsBoolean}

        end
      else BankCodeFreezeButton.Visible := False;

end;  {SetBankCodeFreezeStatus}

{===========================================================================}
Procedure TBaseParcelPg1Form.InitializeForm;

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
  SBLRec : SBLRecord;
  Quit, Found : Boolean;
  I : Integer;
  DimensionsFormat : String;

begin
  UnitName := 'PBASEPG1';
  ParcelChanged := False;
  FormIsInitializing := True;
  PanelButtonPressed := False;

  If (Deblank(SwisSBLKey) <> '')
    then
      begin
        PasswordAlreadyAttempted := False;
        PasswordEnteredCorrectly := False;
        OriginalFieldValues := TStringList.Create;
        NewFieldValues := TStringList.Create;

          {This string lists will hold the labels and values of each field and will be used
           to insert changes into the trace file.}

    (*    FieldValuesList := TStringList.Create;
        FieldLabelsList := TStringList.Create; *)

        FieldTraceInformationList := TList.Create;

          {If this is the history file, or they do not have read access,
           then we want to set the files to read only.}

        If not ModifyAccessAllowed(FormAccessRights)
          then ParcelTable.ReadOnly := True;

          {If this is inquire mode or the processing type is not the main type
          (i.e. GlblTaxYearFlg), let's open it in readonly mode.}

        If ((EditMode = 'V') or
            (ProcessingType <> DetermineProcessingType(GlblTaxYearFlg)))
          then ParcelTable.ReadOnly := True;

         {CHG12011998-1: Allow user ID's that only allow name and addr changes on pg 1.}
         {FXX02031999-2: Don't restrict to NY here - do in the user profile.}

          {If they are allowed to change the name and address, then set the parcel
           table to not read only, then set all fields to read only and turn
           back on only the name and address fields.}

        If GlblNameAddressUpdateOnly
          then ParcelTable.ReadOnly := False;

        OpenTablesForForm(Self, ProcessingType);
        DefaultEdit := EditName;

          {CHG01122005-1(2.8.2.2)[]: Show the mortgage # on page 1.}

        If GlblShowMortgageOnPage1
          then
            begin
              with MortgageNumberPanel do
                begin
                  Visible := True;
                  Left := 278;
                  Top := 216;
                end;

              EditMortgage.TabStop := True;
              EditMortgage.TabOrder := 32;

            end;  {If GlblShowMortgageOnPage1}

          {CHG01042005-2(2.8.2.1)[2036]: User security restriction for bank code change only.}

        If GlblUser_BankCodeUpdateOnly
          then
            begin
              with ParcelTable do
                For I := 0 to (FieldCount - 1) do
                  Fields[I].ReadOnly := True;

              with ParcelTable do
                begin
                  FieldByName('BankCode').ReadOnly := False;
                  FieldByName('LastChangeDate').ReadOnly := False;
                  FieldByName('LastChangeByName').ReadOnly := False;
                  FieldByName('DateAddressChanged').ReadOnly := False;
                  FieldByName('AddressExtracted').ReadOnly := False;
                  FieldByName('ChangeExtracted').ReadOnly := False;
                  FieldByName('DateChangedForExtract').ReadOnly := False;
                  FieldByName('DisplayOwnerChange').ReadOnly := False;
                  FieldByName('BankCodeFrozen').ReadOnly := False;
                  FieldByName('MortgageNumber').ReadOnly := False;

                end;  {with ParcelTable do}

              MakeAllReadOnlyComponentsGray(Self);

              DefaultEdit := EditBankCode;

            end;  {If GlblUser_BankCodeUpdateOnly}

        If GlblNameAddressUpdateOnly
          then
            begin
                {Set all fields to read only.}

              with ParcelTable do
                For I := 0 to (FieldCount - 1) do
                  Fields[I].ReadOnly := True;

                {Now turn back on the name and address fields.}
                {FXX12011998-10: Don't actually allow them to modify name.}

              with ParcelTable do
                begin
                    {CHG11222004-1(2.8.1.0): Allow restricted users to change the owner.}

                  If GlblUser_Restricted_To_Name_Addr_Change_Can_Change_Owner
                    then
                      begin
                        FieldByName('Name1').ReadOnly := False;
                        FieldByName('Name2').ReadOnly := False;
                      end
                    else DefaultEdit := EditAddress;

                  FieldByName('Address1').ReadOnly := False;
                  FieldByName('Address2').ReadOnly := False;
                  FieldByName('Street').ReadOnly := False;
                  FieldByName('City').ReadOnly := False;
                  FieldByName('State').ReadOnly := False;
                  FieldByName('Zip').ReadOnly := False;
                  FieldByName('ZipPlus4').ReadOnly := False;
                  FieldByName('BankCode').ReadOnly := False;
                  FieldByName('LastChangeDate').ReadOnly := False;
                  FieldByName('LastChangeByName').ReadOnly := False;
                  FieldByName('MortgageNumber').ReadOnly := False;

                    {FXX02191999-1: Make sure to set the date address changed read only
                                    fields to false so can do modifies.}

                  FieldByName('DateAddressChanged').ReadOnly := False;
                  FieldByName('AddressExtracted').ReadOnly := False;

                    {FXX04242000-1: Need to make sure this gets set to not
                                    read only for name \ addr modifies.}

                  FieldByName('DisplayOwnerChange').ReadOnly := False;

                    {FXX05092001-1: Make sure to set new extract fields to not read only.}

                  FieldByName('ChangeExtracted').ReadOnly := False;
                  FieldByName('DateChangedForExtract').ReadOnly := False;

                    {FXX10152004-3(2.8.0.14): Make sure that BankCodeFrozen is not read only
                                              so that NameAddressOnly users can lock \ unlock the bank code.}

                  FieldByName('BankCodeFrozen').ReadOnly := False;

                end;  {with ParcelTable do}

              MakeAllReadOnlyComponentsGray(Self);

            end;  {If GlblNameAddressUpdateOnly}

          {Now look up this parcel.}

        SBLRec := ExtractSwisSBLFromSwisSBLKey(SwisSBLKey);

        with SBLRec do
          Found := FindKeyOld(ParcelTable,
                              ['TaxRollYr', 'SwisCode', 'Section',
                               'Subsection', 'Block', 'Lot', 'Sublot',
                               'Suffix'],
                              [TaxRollYr, SwisCode, Section, SubSection,
                               Block, Lot, Sublot, Suffix]);

        If not Found
          then SystemSupport(003, ParcelTable, 'Error finding key in parcel table.', UnitName, GlblErrorDlgBox);

          {Now set the year label.}

        SetTaxYearLabelForProcessingType(YearLabel, ProcessingType);

          {Also, set the title label to reflect the mode.
           We will then center it in the panel.}

        case EditMode of
          'A' : TitleLabel.Caption := 'Parcel Add';
          'M' : TitleLabel.Caption := 'Parcel Modify';
          'V' : TitleLabel.Caption := 'Parcel View';
          'D' : TitleLabel.Caption := 'Parcel Inactivate';
          'R' : TitleLabel.Caption := 'Parcel Reactivate';

        end;  {case EditMode of}

        TitleLabel.Left := (Panel1.Width - TitleLabel.Width) DIV 2;

          {Now, for some reason the table is marked as
           Modified after we look it up (in modify mode).
           So, we will cancel the modify and set it in
           the proper mode.}

        If ((not ParcelTable.ReadOnly) and
            ParcelTable.Modified and
            (EditMode = 'M'))
          then
            begin
              ParcelTable.Edit;
              ParcelTable.Cancel;
            end;

        If ParcelTable.ReadOnly
          then
            begin
              SaveButton.Visible := False;
              CancelButton.Visible := False;
            end;

        EditNumResSites.Text := IntToStr(NumResSites);
        EditNumComSites.Text := IntToStr(NumComSites);

          {For some reason the lookup boxes were not being filled in with the
           value in the underlying MainTable field when the form was initialized,
           so this fills in the fields so that the data is visible. Note that this
           does not cause the table to be marked modified. Also, we will fill
           in any labels for code based dropdowns. Note that the label names (not captions)
           must be EXACTLY the description field name in the table.}

        RefreshDropdownsAndLabels(Self, ParcelTable, DescriptionIndexedLookups);

        AssessmentTable := FindTableInDataModuleForProcessingType(DataModuleAssessmentTableName,
                                                                  ProcessingType);
        ParcelSDTable := FindTableInDataModuleForProcessingType(DataModuleSpecialDistrictTableName,
                                                                ProcessingType);
        AssessmentYearControlTable := FindTableInDataModuleForProcessingType(DataModuleAssessmentYearControlTableName,
                                                                             ProcessingType);
        SwisCodeTable := FindTableInDataModuleForProcessingType(DataModuleSwisCodeTableName,
                                                                ProcessingType);
        ExemptionCodeTable := FindTableInDataModuleForProcessingType(DataModuleExemptionCodeTableName,
                                                                     ProcessingType);
        SDCodeTable := FindTableInDataModuleForProcessingType(DataModuleSpecialDistrictCodeTableName,
                                                              ProcessingType);

          {Now determine the prior, next year and this year assessed and taxable values.
           Note that we will do the opposite year first so that the assessed and
           exemption tables are set to the current year when we are done.}

          {FXX05181999-1: Update the taxable vals based on recalculating exemptions.}

        DisplayAssessedAndTaxableValues;

          {Make sure that the parcel exemption table does not stay read only.}

        OpenTableForProcessingType(ParcelExemptionTable, ExemptionsTableName,
                                   ProcessingType, Quit);

        If (ParcelTable.FieldByName('ActiveFlag').Text = InactiveParcelFlag)
          then InactiveLabel.Visible := True;

        try
          ClassRecordFound := FindKeyOld(ClassTable, ['TaxRollYr', 'SwisSBLKey'],
                                         [TaxRollYr, Take(26, SwisSBLKey)]);
        except
          SystemSupport(006, ClassTable, 'Error finding class record.', UnitName, GlblErrorDlgBox);
        end;

        OrigExemptionCodes := TStringList.Create;
        OrigExemptionHomesteadCodes := TStringList.Create;
        OrigResidentialTypes := TStringList.Create;
        OrigCountyExemptionAmounts := TStringList.Create;
        OrigTownExemptionAmounts := TStringList.Create;
        OrigSchoolExemptionAmounts := TStringList.Create;
        OrigVillageExemptionAmounts := TStringList.Create;
        OrigSDAmounts := TList.Create;

          {Make sure that the parcel split table is centered.}

        ParcelSplitPanel.Left := (Width - ParcelSplitPanel.Width) DIV 2;
        ParcelSplitPanel.Top := (Height - ParcelSplitPanel.Height) DIV 2;

          {Now see if this is a designated swis. If it is, they must
           enter an 'H', 'N', or 'S'. If not, the homestead field is read
           only.}

        try
          FindKeyOld(SwisCodeTable, ['SwisCode'],
                     [ParcelTable.FieldByName('SwisCode').Text]);
        except
          SystemSupport(001, SwisCodeTable, 'Error getting swis code record.',
                        UnitName, GlblErrorDlgBox);
        end;

          {CHG01071999-1: Add village label.}

        SwisCodeLabel.Caption := SwisCodeTable.FieldByName('MunicipalityName').Text;

        If SwisCodeTable.FieldByName('Classified').AsBoolean
          then ParcelTable.FieldByName('HomesteadCode').Required := True
          else
            begin
              HomesteadDBLookupCombo.ReadOnly := True;
              HomesteadDBLookupCombo.Color := clBtnFace;
              HomesteadDBLookupCombo.Font.Color := clBlue;

            end;  {If SwisCodeTable.FieldByName('Classified').AsBoolean}

          {If this is roll section 9, do not allow them to alter the roll section - it
           must stay on this roll section. Also, turn on the RS9 label.}

        If (ParcelTable.FieldByName('RollSection').Text = '9')
          then
            begin
              {CHG03191998-1: Comment out for now so Colleen can change back
                              to rs1.}
(*              RollSectionDBLookupCombo.ReadOnly := True; *)
              RollSection9Label.Visible := True;
              RollSection9Label.Hint := 'This parcel has an associated roll section 1 parcel. Press F9 to go to it.';

            end;  {If (ParcelTable.FieldByName('RollSection').Text = '9')}

        If ((ParcelTable.FieldByName('RollSection').Text = '1') and
            (Deblank(ParcelTable.FIeldByName('RS9LinkedSBL').Text) <> ''))
          then RollSection9Label.Visible := True;

          {CHG10281997-1: Dual mode processing.
                          Note that there is only edit for assessment page,
                          no delete or insert.}

        If (ProcessingType = ThisYear)
          then OppositeProcessingType := NextYear
          else OppositeProcessingType := ThisYear;

        OppositeTaxYear := GetTaxRollYearForProcessingType(OppositeProcessingType);

        OpenTableForProcessingType(OppositeYearParcelTable,
                                   ParcelTableName,
                                   OppositeProcessingType, Quit);

        OpenTableForProcessingType(OppositeYearClassTable,
                                   ClassTableName,
                                   OppositeProcessingType, Quit);

        SBLRec := ExtractSwisSBLFromSwisSBLKey(SwisSBLKey);

        with SBLRec do
          FindKeyOld(OppositeYearParcelTable,
                     ['TaxRollYr', 'SwisCode', 'Section',
                      'Subsection', 'Block', 'Lot', 'Sublot',
                      'Suffix'],
                     [OppositeTaxYear, SwisCode, Section, SubSection,
                      Block, Lot, Sublot, Suffix]);

          {FXX11211997-1: Add the school name to the page and make sure
                          that the school code table is synched up with
                          the correct school code.}

        FindKeyOld(SchoolCodeTable, ['SchoolCode'],
                   [ParcelTable.FieldByName('SchoolCode').Text]);

          {FXX02061998-4: Make the residential percent blank if zero.}
          {FXX02161999-3: Make sure the depth, acreage, and frontage are
                          formatted correctly.}
          {CHG12302004-1(2.8.1.7): Allow for 3 decimals on frontage, acreage, depth.}

        with ParcelTable do
          begin
            If GlblUse3DecimalsForDimensions
              then DimensionsFormat := _3DecimalEditDisplay
              else DimensionsFormat := DecimalDisplay_BlankZero;

            TNumericField(FieldByName('ResidentialPercent')).DisplayFormat := NoDecimalDisplay_BlankZero;
            TNumericField(FieldByName('Frontage')).DisplayFormat := DimensionsFormat;
            TNumericField(FieldByName('Acreage')).DisplayFormat := DimensionsFormat;
            TNumericField(FieldByName('Depth')).DisplayFormat := DimensionsFormat;

          end;  {with ParcelTable do}

          {FXX03031998-2: Set focus to the first field. Note that we must
                          do this on a timer so that the form is showing
                          by the time we try to set focus.  Otherwise,
                          we get an error trying to set focus in an invisible
                          window.}

        SetFocusTimer.Enabled := True;

          {FXX02101999-1: Display if the owner name is different between TY and NY.}
          {CHG02122000-3: Insert a name\addr audit change record.}
          {CHG02242000-1: Actually, make the owner change flag always refer to the
                          Name Address trace table.}

        DisplayOwnerChangeFlag;

        If GlblLocateByOldParcelID
          then SetOldParcelIDLabel(OldParcelIDLabel, ParcelTable,
                                   AssessmentYearControlTable);

         {CHG04192003-1(2.07b): Allow for bank codes to be frozen.}

        If GlblAllowBankCodeFreeze
          then SetBankCodeFreezeStatus
          else
            begin
              with RollSectionLabel do
                begin
                  Left := 425;
                  Top := 169;
                  Height := 15;
                  Width := 49;
                  WordWrap := False;
                  AutoSize := True;

                end;  {with RollSectionLeft do}

              with RollSectionDBLookupCombo do
                begin
                  Left := 485;
                  Width := 45;
                end;

            end;  {else of If GlblAllowBankCodeFreeze}

          {CHG12022004-1(2.8.1.1): Make sure that only active fields are tab stops.}

        SetTabStopsForDBEdits(Self);

      end;  {If (Deblank(SwisSBLKey) <> '')}

  FormIsInitializing := False;

    {CHG11162004-7(2.8.0.21): Option to make the close button locate.}

  If GlblCloseButtonIsLocate
    then MakeCloseButtonLocate(CloseButton);

end;  {InitializeForm}

{===========================================================}
Procedure TBaseParcelPg1Form.SetFocusToFirstField;

{FXX03031998-2: Set focus to the first field after insert, any post,
                and upon coming into the form.}
{FXX07191999-6: Set focus to name first.}

begin
  with DefaultEdit do
    begin
      SetFocus;
      SelectAll;
    end;

end;  {SetFocusToFirstField}

{===========================================================}
Procedure TBaseParcelPg1Form.SetFocusTimerTimer(Sender: TObject);

{FXX03031998-2: Set focus to the first field. Note that we must
                do this on a timer so that the form is showing
                by the time we try to set focus.  Otherwise,
                we get an error trying to set focus in an invisible
                window.}

begin
  SetFocusTimer.Enabled := False;
  SetFocusToFirstField;
end;  {SetFocusTimerTimer}

{================================================================}
Procedure TBaseParcelPg1Form.RollSectionDBLookupComboCloseUp(Sender: TObject;
                                                             LookupTable,
                                                             FillTable: TDataSet;
                                                             modified: Boolean);

begin
    {FXX03191998-1: Don't let them change a parcel to roll section 9.}

  If ((OrigRollSection <> '9') and
      (RollSectionDBLookupCombo.Text = '9'))
    then
      begin
        MessageDlg('You can not change a parcel to roll section 9.' + #13 +
                   'Please create using the Split/Merge/SBL Change/Copy/RS 9' + #13 +
                   'menu item under the Parcels menu.', mtError, [mbOK], 0);
        RollSectionDBLookupCombo.Text := OrigRollSection;
        ParcelTable.FieldByName('RollSection').Text := OrigRollSection;
        RollSectionDBLookupCombo.SetFocus;

      end;  {If ((OrigRollSection <> '9') and}

end;  {RollSectionDBLookupComboCloseUp}

{====================================================================}
Function TBaseParcelPg1Form.DetermineCodeTableName(Tag : Integer) : String;

{Based on the tag of the lookup combo box, what table should we open in the
 code table? Note that the constants below are declared right after the
 IMPLEMENTATION directive.}

begin
  case Tag of  {LLL3}
    PropertyClass : Result := 'ZPropClsTbl';
    Homestead : Result := 'ZHomesteadCodeTbl';

      {FXX10041999-1: Put the ownership code on pg.1}

    OwnershipCode : Result := 'ZOwnershipTbl';

  end;  {case Tag of}

end;  {DetermineCodeTableName}

{========================================================================}
Procedure TBaseParcelPg1Form.SetCodeTableName(Tag : Integer);

{Based on the tag of the lookup combo box, what table should we open in the
 code table? Actually set the table name. Note that the constants below are
 declared right after the IMPLEMENTATION directive.}

var
  LookupFieldName : String;  {Which key is this lookup by desc. or main code?}

begin
  CodeTable.TableName := DetermineCodeTableName(Tag);

  If (Tag in DescriptionIndexedLookups)
    then LookupFieldName := 'Description'
    else LookupFieldName := 'MainCode';

  SetIndexForCodeTable(CodeTable, LookupFieldName);

end;  {SetCodeTableName}

{========================================================================}
Procedure TBaseParcelPg1Form.CodeLookupEnter(Sender: TObject);

{Close the code table and rename the table to the table for this lookup.
 Then we will rename it according to tax year and open it.}

begin
    {Only close and reopen the table if they are on a lookup that needs a
     different code table opened.}

  with Sender as TwwDBLookupCombo do
    begin
      If (CodeTable.TableName <> DetermineCodeTableName(Tag))
        then
          begin
            CodeTable.Close;
            SetCodeTableName(Tag);

            If (Tag in DescriptionIndexedLookups)
              then LookupField := 'Description'
              else LookupField := 'MainCode';

            CodeTable.Open;

            {Also, change the selected in the lookup to match the index type.}

            If (Tag in DescriptionIndexedLookups)
              then
                begin
                  Selected.Clear;
                  Selected.Add('Description' + #9 + '30' + #9 + 'Description Description');
                  Selected.Add('MainCode' + #9 +
                               IntToStr(CodeTable.FieldByName('MainCode').DataSize) +
                               #9 + 'MainCode Code');
                end
              else
                begin
                  Selected.Clear;
                  Selected.Add('MainCode' + #9 +
                               IntToStr(CodeTable.FieldByName('MainCode').DataSize) +
                               #9 + 'MainCode Code');
                  Selected.Add('Description' + #9 + '30' + #9 + 'Description Description');

                end;  {else of If (Tag in DescriptionIndexedLookups)}

          end;  {If (CodeTable.TableName <> DetermineCode}

    end;  {with Sender as TwwDBLookupCombo do}

end;  {CodeLookupEnter}

{==============================================================}
Procedure TBaseParcelPg1Form.SetCodeOnLookupCloseUp(Sender: TObject;
                                                    LookupTable,
                                                    FillTable: TDataSet;
                                                    Modified: Boolean);

{If this is a lookup combo box which looks up by description then we
 need to fill in the actual code in the record. If this is a lookup combo box
 which looks up by code, then let's fill in the description.
 Note that in order for this to work the DDF field names must end in 'Code' and
 'Desc' and the first part must be the same, i.e. 'PropertyClassCode' and
 'PropertyClassDescription'.}

var
  DescFieldName, CodeFieldName, FieldName : String;
  FieldSize : Integer;
  TempLabel : TLabel;

begin
  If ((ParcelTable.State in [dsInsert, dsEdit]) and
      ParcelTable.Modified)
    then
      begin
        If (TComponent(Sender).Tag in DescriptionIndexedLookups)
          then
            begin  {Description keyed look up.}
                {This is a description based lookup, so let's find the corresponding
                 code field and fill it in.}

              with Sender as TwwDBLookupCombo do
                begin
                   {First, figure out which field this lookup box connects to in the
                    main table.}

                  FieldName := DataField;
                  CodeFieldName := FieldName;
                  Delete(CodeFieldName, Pos('Desc', FieldName), 50);  {Delete 'Desc' from the field name.}
                  CodeFieldName := CodeFieldName + 'Code';  {Now add 'Code' to get the code field name.}

                  (*FieldSize := ParcelTable.FieldByName(CodeFieldName).DataSize - 1; {Minus 1 because it includes #0.}*)

                end;  {If (Tag in DescriptionIndexedLookups)}

                {Now, if the field is now blank, then blank out the code.
                 Otherwise, fill in the code in the table.}

              If (Deblank(ParcelTable.FieldByName(FieldName).Text) = '')
                then ParcelTable.FieldByName(CodeFieldName).Text := ''
                else ParcelTable.FieldByName(CodeFieldName).Text :=
                     TwwDBLookupCombo(Sender).LookupTable.FieldByName('MainCode').Text;

            end
          else
            begin
                {This is a code based lookup, so let's fill in the description
                 for this code.}

              with Sender as TwwDBLookupCombo do
                begin
                   {First, figure out which field this lookup box connects to in the
                    main table. Then delete 'Code' from the end and add 'Desc' to
                    get the decsription field.}

                  FieldName := DataField;
                  DescFieldName := FieldName;
                  Delete(DescFieldName, Pos('Code', FieldName), 50);  {Delete 'Code' from the field name.}
                  DescFieldName := DescFieldName + 'Desc';  {Now add 'Desc' to get the code field name.}

                  FieldSize := ParcelTable.FieldByName(DescFieldName).DataSize - 1;  {Minus 1 because it includes #0.}

                end;  {If (Tag in DescriptionIndexedLookups)}

                {Now, if the field is now blank, then blank out the code.
                 Otherwise, fill in the code in the table.}

              If (Deblank(ParcelTable.FieldByName(FieldName).Text) = '')
                then ParcelTable.FieldByName(DescFieldName).Text := ''
                else ParcelTable.FieldByName(DescFieldName).Text :=
                     Take(FieldSize, TwwDBLookupCombo(Sender).LookupTable.FieldByName('Description').Text);

                 {Set the description label for the code based dropdown.}

              TempLabel := TLabel(FindComponent(DescFieldName));
              TempLabel.Caption := ParcelTable.FieldByName(DescFieldName).Text;
              TempLabel.Hint := CodeTable.FieldByName('Description').Text;

            end;  {else of If (TComponent(Sender).Tag in DescriptionIndexedLookups)}

          {They can't mark a parcel split unless it has 10 or more acres.}

        with Sender as TwwDBLookupCombo do
          If ((Name = 'HomesteadDBLookupCombo') and
              (ParcelTable.FieldByName('HomesteadCode').Text = 'S') and
              (Roundoff(ParcelTable.FieldByName('Acreage').AsFloat, 2) < 10))
            then
              begin
                MessageDlg('A parcel with less than 10 acres can not' + #13 +
                           'be split into homestead and non-homestead.' + #13 + #13 +
                           'Please change the homestead status of this parcel.',
                           mtInformation, [mbOK], 0);

                HomesteadDBLookupCombo.SetFocus;

              end;  {If ((Name = 'HomesteadDBLookupCombo') and ...}

      end;  {If ((ParcelTable.State in [dsInsert, dsEdit]) and ...}

end;  {SetCodeOnLookupCloseUp}

{=====================================================================================}
Procedure TBaseParcelPg1Form.AnyTableNewRecord(DataSet: TDataSet);

{FXX11142003-1(2.07k): Make sure that all fields are initialized to 0.}

begin
  InitializeFieldsForRecord(Dataset);
end;  {AnyTableNewRecord}

{=====================================================================================}
Procedure TBaseParcelPg1Form.ParcelTableAfterEdit(DataSet: TDataset);

{We will initialize the field values for this record. This will be used in the trace
 logic. In the AfterPost event, we will pass the values into the Record Changes procedure
 in PASUTILS and a record will be inserted into the trace file if any differences exist.
 Note that this is a shared event handler with the AfterInsert event.
 Also note that we can not pass in the form variable (i.e. BaseParcelPg1Form) since
 it is not initialized. Instead, we have to pass in the Self var.}

var
  EXAmounts : ExemptionTotalsArrayType;
  HstdAcres, NonhstdAcres : Real;
  I : Integer;

begin
  If not FormIsInitializing
    then
      begin
         {FXX11101997-6: Combined the CreateFieldValuesAndLabels from UGenSclb
                         and PASUtils for compatibility.}

        CreateFieldValuesAndLabels(Self, ParcelTable, FieldTraceInformationList);

          {FXX01202000-2: Copy information forward for parcel record on a field
                          by field basis only.}

        OriginalFieldValues.Clear;

        with ParcelTable do
          For I := 0 to (FieldCount - 1) do
            OriginalFieldValues.Add(Fields[I].Text);

          {FXX02171999-7: Store the name address information to see if it changed.}

        OrigNameAddressBankCodeRec := GetNameAddressBankCodeInfo(ParcelTable);

          {Determine the Orig values of the roll section, school code,
           homestead code, frontage, depth, and acreage.}

        OrigRollSection := ParcelTable.FieldByName('RollSection').Text;
        OrigHomesteadCode := ParcelTable.FieldByName('HomesteadCode').Text;
        OrigHomesteadDesc := ParcelTable.FieldByName('HomesteadDesc').Text;
        OrigSchoolCode := ParcelTable.FieldByName('SchoolCode').Text;

        OrigResidentialPercent := ParcelTable.FieldByName('ResidentialPercent').AsFloat;
        OrigFrontage := ParcelTable.FieldByName('Frontage').AsFloat;
        OrigDepth := ParcelTable.FieldByName('Depth').AsFloat;
        OrigAcreage := ParcelTable.FieldByName('Acreage').AsFloat;
        OrigPropertyClass := ParcelTable.FieldByName('PropertyClassCode').Text;

          {Now figure out the original exemption and special district
           amounts.}
          {CHG12011997-2: STAR support}
          {FXX02091998-1: Pass the residential type of each exemption.}

        EXAmounts := TotalExemptionsForParcel(TaxRollYr, SwisSBLKey,
                                 ParcelExemptionTable,
                                 ExemptionCodeTable,
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

        ClearTList(OrigSDAmounts, SizeOf(ParcelSDValuesRecord));

        TotalSpecialDistrictsForParcel(TaxRollYr,
                                       SwisSBLKey,
                                       ParcelTable,
                                       AssessmentTable,
                                       ParcelSDTable,
                                       SDCodeTable,
                                       ParcelExemptionTable,
                                       ExemptionCodeTable,
                                       OrigSDAmounts);

          {CHG03301998-1: Trace SD, EX changes from everywhere. Also more parcel info.}

        GetAuditParcelRec(ParcelTable,
                          AssessmentTable.FieldByName('TotalAssessedVal').AsFloat,
                          EXAmounts, OrigAuditParcelRec);

          {FXX04151998-7:  Need to figure out orig hstd and nonhstd amounts
                           before any possible changes to the hstd code.}

        CalculateHstdAndNonhstdAmounts(TaxRollYr,
                                       SwisSBLKey,
                                       AssessmentTable,
                                       ClassTable,
                                       ParcelTable,
                                       OrigHstdAssessedVal,
                                       OrigNonhstdAssessedVal,
                                       OrigHstdLandVal, OrigNonhstdLandVal,
                                       HstdAcres, NonhstdAcres,
                                       AssessmentRecordFound,
                                       ClassRecordFound);

          {CHG02122000-3: Insert a name\addr audit change record.}

        OrigNameAddressRec := GetNameAddressInfo(ParcelTable);

      end;  {If not FormIsInitializing}

end;  {ParcelTableAfterEdit}

{=====================================================================================}
Procedure TBaseParcelPg1Form.EditNameAddrKeyPress(    Sender: TObject;
                                              var Key: Char);

{Make sure that name and address is all upper case.}

begin
  Key := Upcase(Key);
end;

{=====================================================================================}
Procedure TBaseParcelPg1Form.EditHstdPercentExit(Sender: TObject);

{Make sure that they enter a valid percent.}

var
  TempNum : Real;
  PercentageOK : Boolean;

begin
  PercentageOK := True;

    {If they are going to cancel the split, then don't worry about
     checking for a valid number.}

  If (Screen.ActiveControl.Name <> 'SplitParcelCancelButton')
    then
      try
        TempNum := StrToFloat(TEdit(Sender).Text);

        If ((Roundoff(TempNum, 0) < 1) or
            (Roundoff(TempNum, 0) > 99))
          then PercentageOK := False;

      except
        PercentageOK := False;
      end;

    {FXX02272000-1: This message was showing up when the edit was blank upon
                    entering the panel.}

  If ((not PercentageOK) and
      (Deblank(TEdit(Sender).Text) <> ''))
    then
      begin
        MessageDlg(TEdit(Sender).Text + 'is not a valid number.' + #13 +
                   'Please enter a number between 1 and 99 for the percentage.',
                   mtError, [mbOK], 0);
        Abort;

      end;  {If not PercentageOK}

end;  {EditHstdPercentExit}

{=====================================================================================}
Procedure TBaseParcelPg1Form.SplitParcelCancelButtonClick(Sender: TObject);

{If they cancel splitting the parcel, then restore the homestead code to
 the original value, along with the description. This way, they can not
 split without entering the land and total homestead percentages.}

begin
  PanelButtonPressed := True;
  ParcelTable.FieldByName('HomesteadCode').Text := OrigHomesteadCode;
  ParcelTable.FieldByName('HomesteadDesc').Text := OrigHomesteadDesc;
  HomesteadDesc.Caption := OrigHomesteadDesc;
  ParcelSplitPanel.Visible := False;

end;  {SplitParcelCancelButtonClick}

{=====================================================================================}
Procedure TBaseParcelPg1Form.SplitParcelOKButtonClick(Sender: TObject);

var
  AssessmentRecordFound,
  ClassRecordFound, ValuesOK : Boolean;
  HstdLandPercent, HstdTotalPercent, TempNum : Real;
  TabPos : Integer;
  NewHstdAssessedVal,
  NewNonhstdAssessedVal,
  HstdLandVal, NonhstdLandVal : Comp;
  HstdAcres, NonhstdAcres : Real;

    {CHG10281997-1: Dual mode processing.}

  Quit, Found : Boolean;

  OppositeYearExemptionCodeTable,
  OppositeYearExemptionTable,
  OppositeYearAssessmentTable,
  OppositeYearSwisCodeTable,
  OppositeYearSDCodeTable,
  OppositeYearParcelSDTable : TTable;

begin
  ValuesOK := True;

    {First let's make sure that they entered values for both percentages.}

  try
    TempNum := StrToFloat(EditHstdLandPercent.Text);

    If ((Roundoff(TempNum, 0) < 1) or
        (Roundoff(TempNum, 0) > 99))
      then ValuesOK := False;

  except
    ValuesOK := False;
  end;

  try
    TempNum := StrToFloat(EditHstdTotalPercent.Text);

    If ((Roundoff(TempNum, 0) < 1) or
        (Roundoff(TempNum, 0) > 99))
      then ValuesOK := False;

  except
    ValuesOK := False;
  end;

    {If so, then we will exit the panel.}

  If ValuesOK
    then
      begin
        PanelButtonPressed := True;
        ParcelSplitPanel.Visible := False;

          {Store the class record and add the tab.}

        with ClassTable do
          try
            Insert;

            HstdLandPercent := StrToFloat(EditHstdLandPercent.Text);
            HstdTotalPercent := StrToFloat(EditHstdTotalPercent.Text);

            FieldByName('SwisSBLKey').Text := ExtractSSKey(ParcelTable);
            FieldByName('TaxRollYr').Text := TaxRollYr;

              {The first portion is homestead based on the percentages
               that they entered.}

            FieldByName('HstdAcres').AsFloat := Roundoff((ParcelTable.FieldByName('Acreage').AsFloat *
                                                          (HstdLandPercent / 100)), 2);
            FieldByName('HstdLandPercent').AsFloat := Roundoff(HstdLandPercent, 2);
            FieldByName('HstdTotalPercent').AsFloat := Roundoff(HstdTotalPercent, 2);
            TCurrencyField(FieldByName('HstdLandVal')).Value :=
                         Roundoff((TCurrencyField(AssessmentTable.FieldByName('LandAssessedVal')).Value *
                                  (HstdLandPercent / 100)), 0);
            TCurrencyField(FieldByName('HstdTotalVal')).Value :=
                         Roundoff((TCurrencyField(AssessmentTable.FieldByName('TotalAssessedVal')).Value *
                                  (HstdTotalPercent / 100)), 0);

              {The other portion of the original amount is non homestead.}

            FieldByName('NonhstdAcres').AsFloat := Roundoff((ParcelTable.FieldByName('Acreage').AsFloat -
                                                             FieldByName('HstdAcres').AsFloat), 2);
            FieldByName('NonhstdLandPercent').AsFloat := 100 - Roundoff(HstdLandPercent, 2);
            FieldByName('NonhstdTotalPercent').AsFloat := 100 - Roundoff(HstdTotalPercent, 2);
            TCurrencyField(FieldByName('NonhstdLandVal')).Value :=
                         Roundoff((TCurrencyField(AssessmentTable.FieldByName('LandAssessedVal')).Value -
                                  TCurrencyField(FieldByName('HstdLandVal')).Value), 0);
            TCurrencyField(FieldByName('NonhstdTotalVal')).Value :=
                         Roundoff((TCurrencyField(AssessmentTable.FieldByName('TotalAssessedVal')).Value -
                                   TCurrencyField(FieldByName('HstdTotalVal')).Value), 0);

            Post;
          except
            SystemSupport(001, ClassTable, 'Error inserting class record.',
                          UnitName, GlblErrorDlgBox);
          end;

        ClassRecordFound := True;

          {Adjust the roll totals.}

          {Delete all the old roll totals for this parcel.}

        CalculateHstdAndNonhstdAmounts(TaxRollYr,
                                       SwisSBLKey,
                                       AssessmentTable,
                                       ClassTable,
                                       ParcelTable,
                                       NewHstdAssessedVal,
                                       NewNonhstdAssessedVal,
                                       HstdLandVal, NonhstdLandVal,
                                       HstdAcres, NonhstdAcres,
                                       AssessmentRecordFound,
                                       ClassRecordFound);

          {CHG12011997-2: STAR support.}
        {FXX12041997-4: Record full, unadjusted STAR amount. Need to pass
                        the parcel table for that.}
          {FXX02101999-4: Add land value to swis and school totals.}

        HstdLandVal := 0;
        NonhstdLandVal := 0;

        If (OrigHomesteadCode = 'N')
          then NonhstdLandVal := OrigLandAssessedVal
          else HstdLandVal := OrigLandAssessedVal;

        AdjustRollTotalsForParcel(TaxRollYr,
                                  ParcelTable.FieldByName('SwisCode').Text,
                                  OrigSchoolCode,
                                  OrigHomesteadCode,
                                  OrigRollSection,
                                  HstdLandVal, NonhstdLandVal,
                                  OrigHstdAssessedVal,
                                  OrigNonhstdAssessedVal,
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
                                  ['S', 'C'],  {Adjust swis, school}
                                  'D');  {Delete the totals.}

          {Add the new roll totals for this parcel.}

        AdjustRollTotalsForParcel(TaxRollYr,
                                  ParcelTable.FieldByName('SwisCode').Text,
                                  OrigSchoolCode,
                                  ParcelTable.FieldByName('HomesteadCode').Text,
                                  OrigRollSection,
                                  ClassTable.FieldByName('HstdLandVal').AsFloat,
                                  ClassTable.FieldByName('NonhstdLandVal').AsFloat,
                                  NewHstdAssessedVal,
                                  NewNonhstdAssessedVal,
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
                                  ['S', 'C'],  {Adjust swis, school}
                                  'A');  {Add the totals.}

        MessageDlg('The parcel has been split.' + #13 +
                    'A class record has been created.' + #13 + #13 +
                    'Please check the homestead and non-homestead values.' + #13 +
                    'Also check the exemptions for applicability.',
                    mtInformation, [mbOK], 0);

          {Add a class tab.}

        TabPos := DetermineTabPos(ParcelTabset.Tabs, ClassTabName, 0);
        ParcelTabset.Tabs.Insert(TabPos, ClassTabName);
        TabTypeList.Insert(TabPos, GlblTaxYearFlg);

         {CHG10281997-1: Dual mode processing - add the class record to
                         the next year.}

        If GlblModifyBothYears
          then
            begin
                {Copy the fields from the main table to the new table, but make
                 sure that we do not copy the tax roll year.
                 If the class record already exists, don't add another one.}

              Found := FindKeyOld(OppositeYearClassTable,
                                  ['TaxRollYr', 'SwisSBLKey'],
                                  [OppositeTaxYear,
                                   SwisSBLKey]);

              If not Found
                then
                  begin
                      {Get the original amounts so we can adjust the totals
                       if necessary.}

                    OppositeYearExemptionCodeTable := TTable.Create(nil);
                    OppositeYearExemptionTable := TTable.Create(nil);
                    OppositeYearAssessmentTable := TTable.Create(nil);
                    OppositeYearSwisCodeTable := TTable.Create(nil);
                    OppositeYearSDCodeTable := TTable.Create(nil);
                    OppositeYearParcelSDTable := TTable.Create(nil);

                    OpenTableForProcessingType(OppositeYearExemptionCodeTable,
                                               ExemptionCodesTableName,
                                               OppositeProcessingType, Quit);
                    OppositeYearExemptionCodeTable.IndexName := 'BYEXCODE';

                    OpenTableForProcessingType(OppositeYearExemptionTable,
                                               ExemptionsTableName,
                                               OppositeProcessingType, Quit);
                    OppositeYearExemptionTable.IndexName := 'BYYEAR_SWISSBLKEY_EXCODE';

                    OpenTableForProcessingType(OppositeYearAssessmentTable,
                                               AssessmentTableName,
                                               OppositeProcessingType, Quit);
                    OppositeYearAssessmentTable.IndexName := 'BYTAXROLLYR_SWISSBLKEY';

                    FindKeyOld(OppositeYearAssessmentTable,
                               ['TaxRollYr', 'SwisSBLKey'],
                               [OppositeTaxYear, SwisSBLKey]);

                    OpenTableForProcessingType(OppositeYearSwisCodeTable,
                                               SwisCodeTableName,
                                               OppositeProcessingType, Quit);
                    OppositeYearSwisCodeTable.IndexName := 'BYSWISCODE';

                    OpenTableForProcessingType(OppositeYearSDCodeTable,
                                               SdistCodeTableName,
                                               OppositeProcessingType, Quit);
                    OppositeYearSDCodeTable.IndexName := 'BYSDISTCODE';

                    OpenTableForProcessingType(OppositeYearParcelSDTable,
                                               SpecialDistrictTableName,
                                               OppositeProcessingType, Quit);
                    OppositeYearParcelSDTable.IndexName := 'BYTAXROLLYR_SWISSBLKEY_SD';

                    CalculateHstdAndNonhstdAmounts(OppositeTaxYear,
                                                   SwisSBLKey,
                                                   OppositeYearAssessmentTable,
                                                   OppositeYearClassTable,
                                                   OppositeYearParcelTable,
                                                   OrigHstdAssessedVal,
                                                   OrigNonhstdAssessedVal,
                                                   HstdLandVal, NonhstdLandVal,
                                                   HstdAcres, NonhstdAcres,
                                                   AssessmentRecordFound,
                                                   ClassRecordFound);

                      {Now figure out the original exemption and special district
                       amounts.}
                      {CHG12011997-2: STAR support}

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

                       {Now copy the changes to the other year.}

                    OppositeYearClassTable.Insert;

                    CopyFields(ClassTable, OppositeYearClassTable,
                               ['TaxRollYr'], [OppositeTaxYear]);

                    try
                      OppositeYearClassTable.Post;
                    except
                      SystemSupport(050, OppositeYearClassTable,
                                    'Error posting opposite year record.', UnitName,
                                    GlblErrorDlgBox);
                    end;

                            {Delete all the old roll totals for this parcel.}

                    CalculateHstdAndNonhstdAmounts(OppositeTaxYear,
                                                   SwisSBLKey,
                                                   OppositeYearAssessmentTable,
                                                   OppositeYearClassTable,
                                                   OppositeYearParcelTable,
                                                   NewHstdAssessedVal,
                                                   NewNonhstdAssessedVal,
                                                   HstdLandVal, NonhstdLandVal,
                                                   HstdAcres, NonhstdAcres,
                                                   AssessmentRecordFound,
                                                   ClassRecordFound);

                      {CHG12011997-2: STAR support.}
                      {FXX12041997-4: Record full, unadjusted STAR amount. Need to pass
                                      the parcel table for that.}
                      {FXX02101999-4: Add land value to swis and school totals.}

                    HstdLandVal := 0;
                    NonhstdLandVal := 0;

                    If (OrigHomesteadCode = 'N')
                      then NonhstdLandVal := OrigLandAssessedVal
                      else HstdLandVal := OrigLandAssessedVal;

                    AdjustRollTotalsForParcel(OppositeTaxYear,
                                              OppositeYearParcelTable.FieldByName('SwisCode').Text,
                                              OrigSchoolCode,
                                              OrigHomesteadCode,
                                              OrigRollSection,
                                              HstdLandVal, NonhstdLandVal,
                                              OrigHstdAssessedVal,
                                              OrigNonhstdAssessedVal,
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
                                              ['S', 'C'],  {Adjust swis, school}
                                              'D');  {Delete the totals.}

                      {Add the new roll totals for this parcel.}

                    AdjustRollTotalsForParcel(OppositeTaxYear,
                                              OppositeYearParcelTable.FieldByName('SwisCode').Text,
                                              OrigSchoolCode,
                                              OppositeYearParcelTable.FieldByName('HomesteadCode').Text,
                                              OrigRollSection,
                                              OppositeYearClassTable.FieldByName('HstdLandVal').AsFloat,
                                              OppositeYearClassTable.FieldByName('NonhstdLandVal').AsFloat,
                                              NewHstdAssessedVal,
                                              NewNonhstdAssessedVal,
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
                                              ['S', 'C'],  {Adjust swis, school}
                                              'A');  {Add the totals.}

                    OppositeYearExemptionCodeTable.Close;
                    OppositeYearExemptionTable.Close;
                    OppositeYearAssessmentTable.Close;
                    OppositeYearSwisCodeTable.Close;
                    OppositeYearSDCodeTable.Close;
                    OppositeYearParcelSDTable.Close;

                    OppositeYearExemptionCodeTable.Free;
                    OppositeYearExemptionTable.Free;
                    OppositeYearAssessmentTable.Free;
                    OppositeYearSwisCodeTable.Free;
                    OppositeYearSDCodeTable.Free;
                    OppositeYearParcelSDTable.Free;

                  end;  {If not Found}

            end;  {If GlblModifyBothYears}

      end
    else MessageDlg('Please enter a valid percentage for both' + #13 +
                    'the land and total amounts.', mtError, [mbOK], 0);

end;  {SplitParcelOKButtonClick}

{=====================================================================================}
Procedure TBaseParcelPg1Form.ParcelSplitPanelExit(Sender: TObject);

{Make sure that they don't exit the parcel split panel without pressing
 a button.}

begin
  If not PanelButtonPressed
    then ParcelSplitPanel.SetFocus;

  PanelButtonPressed := False;

end;  {ParcelSplitPanelExit}

{=====================================================================================}
Procedure TBaseParcelPg1Form.EditAcreageExit(Sender: TObject);

{If the parcel is split and they have reduced the acreage to less than 10
 acres, make them change the homestead status - it can no longer be split.}

begin
  If ((ParcelTable.FieldByName('HomesteadCode').Text = 'S') and
      (Roundoff(ParcelTable.FieldByName('Acreage').AsFloat, 2) < 10))
    then
      begin
        MessageDlg('A parcel with less than 10 acres can not' + #13 +
                   'be split into homestead and non-homestead.' + #13 + #13 +
                   'Please change the homestead status of this parcel.',
                   mtInformation, [mbOK], 0);

        HomesteadDBLookupCombo.SetFocus;

      end;  {If ((ParcelTableHomesteadCode.Text = 'S') and ...}

end;  {EditAcreageExit}

{====================================================================}
Procedure TBaseParcelPg1Form.OwnerChangeLabelClick(Sender: TObject);

{CHG01182000-2: Allow users to click off the owner change button.}

begin
  If ((not ParcelTable.ReadOnly) and
      GlblCanTurnOffOwnerChangeFlag)
    then
      with GlblNameAddressTraceTable do
        try
          Edit;
          FieldByName('CheckedOff').AsBoolean := True;
          FieldByName('DateCheckedOff').AsDateTime := Date;
          OwnerChangeLabel.Visible := False;
          Post;
        except
          SystemSupport(020, GlblNameAddressTraceTable, 'Error updating name\address trace table.',
                        UnitName, GlblErrorDlgBox);
        end;

end;  {OwnerChangeLabelClick}

{=====================================================================================}
Procedure TBaseParcelPg1Form.EditBankCodeExit(Sender: TObject);

{CHG04192003-1(2.07b): Allow for bank codes to be frozen.}

begin
  SetBankCodeFreezeStatus;

    {CHG01122005-1(2.8.2.2)[]: Show the mortgage # on page 1.}

  If (GlblShowMortgageOnPage1 and
      GlblNameAddressUpdateOnly)
    then EditMortgage.SetFocus;

end;  {EditBankCodeExit}

{=====================================================================================}
Procedure TBaseParcelPg1Form.OwnershipCodeLookupComboExit(Sender: TObject);

begin
    {CHG01122005-1(2.8.2.2)[]: Show the mortgage # on page 1.}

  If GlblShowMortgageOnPage1
    then EditMortgage.SetFocus;

end;  {OwnershipCodeLookupComboExit}

{=====================================================================================}
Procedure TBaseParcelPg1Form.EditMortgageExit(Sender: TObject);

begin
    {CHG01122005-1(2.8.2.2)[]: Show the mortgage # on page 1.}

  If GlblShowMortgageOnPage1
    then
      If GlblNameAddressUpdateOnly
        then SaveButton.SetFocus
        else ResidentialPercentDBEdit.SetFocus;

end;  {EditMortgageExit}

{=====================================================================================}
Procedure TBaseParcelPg1Form.BankCodeFreezeButtonClick(Sender: TObject);

{CHG04192003-1(2.07b): Allow for bank codes to be frozen.}

begin
  If (ParcelTable.State = dsBrowse)
    then
      try
        ParcelTable.Edit;
      except
        SystemSupport(075, ParcelTable, 'Error putting parcel table in edit mode.',
                      UnitName, GlblErrorDlgBox);

      end;

    {CHG06092003-3(2.07c): Verify removal of freeze.}

  with ParcelTable do
    If ((not FieldByName('BankCodeFrozen').AsBoolean) or
        (MessageDlg('Are you sure you want to remove the lock from this bank code?',
                    mtConfirmation, [mbYes, mbNo], 0) = idYes))
      then
        try
          FieldByName('BankCodeFrozen').AsBoolean := not FieldByName('BankCodeFrozen').AsBoolean;
        except
          SystemSupport(076, ParcelTable, 'Error settion bank code frozen status.',
                        UnitName, GlblErrorDlgBox);
        end;

  SetBankCodeFreezeStatus;

end;  {BankCodeFreezeButtonClick}

{=====================================================================================}
Procedure TBaseParcelPg1Form.ParcelTableBeforePost(DataSet: TDataset);

{Make sure that they have key fields filled in - can be a problem if they
 filled them in, saved, then blanked them - this would not be picked up
 be Delphi, so we will force it here.  The fields that we need to worry about are
 name1 and legal addr name. All other required fields are code fields which will
 be handled by the Delphi handler because once they are filled in, they can not
 be replaced with a blank value since the style is csDropDownList and thus they
 must pick from the list.}

var
  ProceedWithPost : Boolean;

begin
  ProceedWithPost := True;

  If (Deblank(ParcelTable.FieldByName('Name1').Text) = '')
    then
      begin
        MessageDlg('Please enter name 1 before saving.', mtError, [mbOK], 0);
        EditName.SetFocus;
        ProceedWithPost := False;

      end;  {If (Deblank(ParcelTable.FieldByName('Name1').Text) = '')}

    {FXX08031999-1: Some parcels, i.e. utilitys, do have a blank legal addr.}

  If (ProceedWithPost and
      (Deblank(ParcelTable.FieldByName('LegalAddr').Text) = '') and
      (MessageDlg('The legal address is blank.' + #13 +
                  'Is this correct?', mtConfirmation, [mbYes, mbNo], 0) = idNo))
    then
      begin
        EditLegalAddr.SetFocus;
        ProceedWithPost := False;

      end;  {If (Deblank(ParcelTable.FieldByName('LegalAddr').Text) = '')}

    {FXX11191998-1: Make sure that school, property class, hstd code and
                    roll section are not blanked out.}

  If (ProceedWithPost and
      (Deblank(ParcelTable.FieldByName('SchoolCode').Text) = ''))
    then
      begin
        MessageDlg('Please enter the school code before saving.', mtError, [mbOK], 0);
        SchoolCodeLookup.SetFocus;
        ProceedWithPost := False;

      end;  {If (Deblank(ParcelTable.FieldByName('SchoolCode').Text) = '')}

  If (ProceedWithPost and
      (Deblank(ParcelTable.FieldByName('RollSection').Text) = ''))
    then
      begin
        MessageDlg('Please enter the roll section before saving.', mtError, [mbOK], 0);
        RollSectionDBLookupCombo.SetFocus;
        ProceedWithPost := False;

      end;  {If (Deblank(ParcelTable.FieldByName('RollSection').Text) = '')}

  If (ProceedWithPost and
      (Deblank(ParcelTable.FieldByName('PropertyClassCode').Text) = ''))
    then
      begin
        MessageDlg('Please enter the property class before saving.', mtError, [mbOK], 0);
        PropClassDBLookupCombo.SetFocus;
        ProceedWithPost := False;

      end;  {If (Deblank(ParcelTable.FieldByName('PropertyClassCode').Text) = '')}

  If (ProceedWithPost and
      GlblMunicipalityIsClassified and
      (Deblank(ParcelTable.FieldByName('HomesteadCode').Text) = ''))
    then
      begin
        MessageDlg('Please enter the homestead code before saving.', mtError, [mbOK], 0);
        HomesteadDBLookupCombo.SetFocus;
        ProceedWithPost := False;

      end;  {If (Deblank(ParcelTable.FieldByName('HomesteadCode').Text) = '')}

  If (ProceedWithPost and
      ((ParcelTable.FieldByName('ResidentialPercent').AsFloat < 1) and
       (ParcelTable.FieldByName('ResidentialPercent').AsFloat > 0)))
    then
      begin
        MessageDlg('Please enter the residential percent as a number between 0 and 100.',
                   mtError, [mbOK], 0);
        ResidentialPercentDBEdit.SetFocus;
        ProceedWithPost := False;
      end;

    {CHG08121999-1: Warn if they change the school code.}
    {FXX12172004-1[2029]: Don't ask this if the school or roll section is blank.}

  If (ProceedWithPost and
      (Trim(ParcelTable.FieldByName('SchoolCode').Text) <> '') and
      (OrigSchoolCode <> ParcelTable.FieldByName('SchoolCode').Text) and
      _Compare(OrigSchoolCode, coNotBlank) and
      (MessageDlg('Are you sure that you want to change the school code from ' +
                  OrigSchoolCode + ' to ' +
                  ParcelTable.FieldByName('SchoolCode').Text + '?',
                  mtConfirmation, [mbYes, mbNo], 0) = idNo))
    then ProceedWithPost := False;

    {CHG12122000-2: Verify that they want to change roll sections.}
    {FXX12172004-1[2029]: Don't ask this if the school or roll section is blank.}

  If (ProceedWithPost and
      (Trim(ParcelTable.FieldByName('RollSection').Text) <> '') and
      (OrigRollSection <> ParcelTable.FieldByName('RollSection').Text) and
      _Compare(OrigRollSection, coNotBlank) and
      (MessageDlg('Are you sure that you want to change the roll section from ' +
                  OrigRollSection + ' to ' +
                  ParcelTable.FieldByName('RollSection').Text + '?',
                  mtConfirmation, [mbYes, mbNo], 0) = idNo))
    then ProceedWithPost := False;


    {CHG03212001-1: Password protect school code changes.}

  If (ProceedWithPost and
      GlblPasswordProtectSchoolCode and
      (OrigSchoolCode <> ParcelTable.FieldByName('SchoolCode').Text))
    then
      begin
        MessageDlg('The school code changed from ' + OrigSchoolCode +
                   ' to ' + ParcelTable.FieldByName('SchoolCode').Text + '.' + #13 +
                   'You must enter a password for this change to be accepted.',
                   mtWarning, [mbOK], 0);

        SchoolPasswordDlg.Password := GlblSchoolCodeChangePassword;

        If not SchoolPasswordDlg.Execute
          then
            begin
              MessageDlg('Sorry, you did not enter the correct password to change the school code.' + #13 +
                         'The school code will be left as ' + OrigSchoolCode + '.',
                         mtError, [mbOK], 0);
              ParcelTable.FieldByName('SchoolCode').Text := OrigSchoolCode;

            end;  {If not SchoolPasswordDlg.Execute}

      end;  {If (ProceedWithPost and}


  If ProceedWithPost
    then
      begin
          {FXX11031997-4: The update of changed time and name should be done in
                          before post since they can save without clicking save by
                          switching pages.}

        ParcelTable.FieldByName('LastChangeByName').Text := GlblUserName;
        ParcelTable.FieldByName('LastChangeDate').AsDateTime := Date;

          {FXX02171999-7: Store the name address information to see if it changed.}
          {CHG01182000-2: Allow users to click off the owner change button.}

        NewNameAddressBankCodeRec := GetNameAddressBankCodeInfo(ParcelTable);

        If NameAddressBankCodeDifferent(OrigNameAddressBankCodeRec,
                                        NewNameAddressBankCodeRec)
          then
            begin
              ParcelTable.FieldByName('DateAddressChanged').AsDateTime := Date;
              ParcelTable.FieldByName('AddressExtracted').AsBoolean := False;
              ParcelTable.FieldByName('DisplayOwnerChange').AsBoolean := True;

                {CHG03302000-1: Expand the capabilites of the extract.}

              ParcelTable.FieldByName('DateChangedForExtract').AsDateTime := Date;
              ParcelTable.FieldByName('ChangeExtracted').AsBoolean := False;

            end;  {If NameAddressBankCodeDifferent(OrigNameAddressBankCodeRec, ...}

          {CHG03042001-1: Look up by LegalAddrInt instead of the text addr #.}
          {FXX05102001-1: Don't set the legal addr int if they are in name\addr change mode only.}

        with ParcelTable do
          If not FieldByName('LegalAddrInt').ReadOnly
            then FieldByName('LegalAddrInt').AsInteger := GetLegalAddressInt(FieldByName('LegalAddrNo').Text);

      end;  {If ProceedWithPost}

  If not ProceedWithPost
    then Abort;

end;  {ParcelTableBeforePost}

{=====================================================================================}
Procedure TBaseParcelPg1Form.ParcelTableAfterPost(DataSet: TDataset);

{Now let's call RecordChanges which will insert a record into the trace file if any differences
 exist.
 Note that RecordChanges returns an integer saying how many changes there
 were. If this number is greater than 0, then we will update the
 name and date changed fields of the parcel record.}

var
  NumChanges, I, TabPos : Integer;
  NewSchoolCode : String;
  NewRollSection,
  NewHomesteadCode : String;
  NewResidentialPercent, NewFrontage,
  NewDepth, NewAcreage : Real;
  NewHstdAssessedVal,
  NewNonhstdAssessedVal : Comp;
  NewHstdLandVal, NewNonhstdLandVal : Comp;
  HstdAcres, NonhstdAcres : Real;
  NewExemptionCodes,
  NewExemptionHomesteadCodes,
  NewResidentialTypes,
  NewCountyExemptionAmounts,
  NewTownExemptionAmounts,
  NewSchoolExemptionAmounts,
  NewVillageExemptionAmounts : TStringList;
  NewBasicSTARAmount, NewEnhancedSTARAmount : Comp;
  NewSDAmounts : TList;

  AdjustmentTypeSet : Charset;  {Adjust (S)wis, s(C)hool, (E)xemption, s(D)}

  Quit,
  AssessmentRecordFound,
  RollSectionChanged,  {Was there a roll sect, hmstd or schl change?}
  HomesteadCodeChanged, SchoolCodeChanged,
  FrontageChanged, DepthChanged,
  ResidentialPercentChanged, AcreageChanged : Boolean;

    {CHG10281997-1: Dual mode processing.}

  Found : Boolean;

  OppositeYearExemptionCodeTable,
  OppositeYearExemptionTable,
  OppositeYearAssessmentTable,
  OppositeYearSwisCodeTable,
  OppositeYearSDCodeTable,
  OppositeYearParcelSDTable : TTable;
  SBLRec : SBLRecord;
  ChangedFields : TStringList;
  EXAmounts : ExemptionTotalsArrayType;
  NewAuditParcelRec : AuditParcelRecord;
  AuditEXChangeList : TList;

begin
      {FXX11101997-3: Pass the screen name into RecordChanges so
                      the screen names are more readable.}
    {FXX12301999-3: Make sure to always carry changes forward if they want them.}

  NumChanges := RecordChanges(Self, 'Base Information', ParcelTable, SwisSBLKey,
                              FieldTraceInformationList);

  If (NumChanges > 0)
    then ParcelChanged := True;

  Cursor := crHourglass;
  Application.ProcessMessages;

    {Determine the new values of the roll section, school code,
     homestead code, frontage, depth, and acreage.}

  NewRollSection := ParcelTable.FieldByName('RollSection').Text;
  NewHomesteadCode := ParcelTable.FieldByName('HomesteadCode').Text;
  NewSchoolCode := ParcelTable.FieldByName('SchoolCode').Text;

  NewResidentialPercent := ParcelTable.FieldByName('ResidentialPercent').AsFloat;
  NewFrontage := ParcelTable.FieldByName('Frontage').AsFloat;
  NewDepth := ParcelTable.FieldByName('Depth').AsFloat;
  NewAcreage := ParcelTable.FieldByName('Acreage').AsFloat;

    {Figure out what changed.}

  HomesteadCodeChanged := (Take(1, OrigHomesteadCode) <> Take(1, NewHomesteadCode));
  RollSectionChanged := (Take(1, OrigRollSection) <> Take(1, NewRollSection));
  SchoolCodeChanged := (Take(6, OrigSchoolCode) <> Take(6, NewSchoolCode));
  FrontageChanged := (Roundoff(OrigFrontage, 2) <> Roundoff(NewFrontage, 2));
  DepthChanged := (Roundoff(OrigDepth, 2) <> Roundoff(NewDepth, 2));
  AcreageChanged := (Roundoff(OrigAcreage, 2) <> Roundoff(NewAcreage, 2));
  ResidentialPercentChanged := (Roundoff(OrigResidentialPercent, 2) <> Roundoff(NewResidentialPercent, 2));

    {CHG02122000-3: Insert a name\addr audit change record.}

  NewNameAddressRec := GetNameAddressInfo(ParcelTable);
  If InsertNameAddressTraceRecord(ExtractSSKey(ParcelTable),
                                  OrigNameAddressRec,
                                  NewNameAddressRec)
  then
  begin
    OwnerChangeLabel.Visible := True;

      {CHG06102010-2(2.26.1)[I7591]: Autoupdate of names / addrs.}

    If glblAutoUpdateNamesAddrs
    then AutoUpdateNamesAndAddressesInOtherSystems(ParcelTable,
                                                   SwisSBLKey,
                                                   TaxRollYr);

  end;  {If InsertNameAddressTraceRecord...}

    {If the homestead code changed from split to non=split, then tell them the
     class record was deleted.}

  If (HomesteadCodeChanged and
      (OrigHomesteadCode = 'S') and
      ClassRecordFound)
    then
      begin
        try
          ClassTable.Delete;
        except
          SystemSupport(030, ClassTable, 'Error deleting class record.',
                        UnitName, GlblErrorDlgBox);
        end;

        MessageDlg('The parcel is no longer split.' + #13 +
                   'The class record has been deleted.',
                    mtInformation, [mbOK], 0);

          {Remove the class tab.}

        TabPos := ParcelTabset.Tabs.IndexOf(ClassTabName);
        ParcelTabset.Tabs.Delete(TabPos);
        TabTypeList.Delete(TabPos);

      end;  {If (HomesteadCodeChanged and ...}

    {Now, if anything changed, adjust the roll totals.}

  If (HomesteadCodeChanged or
      RollSectionChanged or
      SchoolCodeChanged or
      FrontageChanged or
      DepthChanged or
      AcreageChanged or
      ResidentialPercentChanged)
    then
      begin
        NewExemptionCodes := TStringList.Create;
        NewExemptionHomesteadCodes := TStringList.Create;
        NewResidentialTypes := TStringList.Create;
        NewCountyExemptionAmounts := TStringList.Create;
        NewTownExemptionAmounts := TStringList.Create;
        NewSchoolExemptionAmounts := TStringList.Create;
        NewVillageExemptionAmounts := TStringList.Create;
        NewSDAmounts := TList.Create;
        AdjustmentTypeSet := [];

          {Only the swis roll totals need to be adjusted if
           the roll section changed.}
          {FXX11031997-2: Need to combine the adjustment types
                          rather then just assign a single one.}

        If RollSectionChanged
          then AdjustmentTypeSet := AdjustmentTypeSet + ['S'];

          {Only the school roll totals need to be adjusted if
           the school code changed.}

        If SchoolCodeChanged
          then AdjustmentTypeSet := AdjustmentTypeSet + ['C'];

        If (FrontageChanged or
            DepthChanged or
            AcreageChanged)
          then AdjustmentTypeSet := AdjustmentTypeSet + ['D'];

          {If the homestead code changed, we will need to adjust
           all roll totals since homestead code is part of the
           key for all 4 roll total types.
           If the residential % changed, then the exemptions may have
           changed. Since any exemption change could affect another
           roll total, we will have to redo all the roll totals.
           So, we will recalculate all of }
          {FXX04271999-2: Also may need to recalc on r.s. change.}

        If (HomesteadCodeChanged or
            RollSectionChanged or
            ResidentialPercentChanged)
          then
            begin
              AdjustmentTypeSet := ['S', 'C', 'E', 'D'];

                {If the exemptions change because of a change in
                 hstd or res %, put out ex audit records.}

              AuditEXChangeList := TList.Create;
              GetAuditEXList(SwisSBLKey, TaxRollYr, ParcelExemptionTable,
                             AuditEXChangeList);
              InsertAuditEXChanges(SwisSBLKey, TaxRollYr, AuditEXChangeList,
                                   AuditEXChangeTable, 'B');
              FreeTList(AuditEXChangeList, SizeOf(AuditEXRecord));

                {Since there has been an assessed value change,
                 it is very possible that an exemption amount will change,
                 too. So, we will recalculate all exemptions and redo the
                 totals.}

              RecalculateExemptionsForParcel(ExemptionCodeTable,
                                             ParcelExemptionTable,
                                             AssessmentTable,
                                             ClassTable,
                                             SwisCodeTable,
                                             ParcelTable,
                                             TaxRollYr, SwisSBLKey, nil,
                                             0, 0, False);

                {If the exemptions change because of a change in
                 hstd or res %, put out ex audit records.}

              AuditEXChangeList := TList.Create;
              GetAuditEXList(SwisSBLKey, TaxRollYr, ParcelExemptionTable,
                             AuditEXChangeList);
              InsertAuditEXChanges(SwisSBLKey, TaxRollYr, AuditEXChangeList,
                                   AuditEXChangeTable, 'A');
              FreeTList(AuditEXChangeList, SizeOf(AuditEXRecord));

            end;  {If (HomesteadCodeChanged or ...}

          {Delete all the old roll totals for this parcel,
           but first get the new hstd and nonhstd amounts.}

        CalculateHstdAndNonhstdAmounts(TaxRollYr,
                                       SwisSBLKey,
                                       AssessmentTable,
                                       ClassTable,
                                       ParcelTable,
                                       NewHstdAssessedVal,
                                       NewNonhstdAssessedVal,
                                       NewHstdLandVal, NewNonhstdLandVal,
                                       HstdAcres, NonhstdAcres,
                                       AssessmentRecordFound,
                                       ClassRecordFound);

          {FXX11031997-5: Always calc the new ex and SD
                          amounts, not just on a case
                          by case basis.}

          {Now figure out the new exemption totals.}
          {CHG12011997-2: STAR support}
          {FXX02091998-1: Pass the residential type of each exemption.}

        EXAmounts := TotalExemptionsForParcel(TaxRollYr, SwisSBLKey,
                                 ParcelExemptionTable,
                                 ExemptionCodeTable,
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
                                       ParcelExemptionTable,
                                       ExemptionCodeTable,
                                       NewSDAmounts);

          {CHG12011997-2: STAR support}
          {FXX12041997-4: Record full, unadjusted STAR amount. Need to pass
                          the parcel table for that.}
          {FXX02101999-4: Add land value to swis and school totals.}
          {FXX11021999-9: Don't delete out old totals if this is a parcel
                          done through Add a Parcel - it will have no roll
                          section and nothing to reverse out.}

        If (Deblank(OrigRollSection) <> '')
          then AdjustRollTotalsForParcel(TaxRollYr,
                                         ParcelTable.FieldByName('SwisCode').Text,
                                         OrigSchoolCode,
                                         OrigHomesteadCode,
                                         OrigRollSection,
                                         OrigHstdLandVal, OrigNonhstdLandVal,
                                         OrigHstdAssessedVal,
                                         OrigNonhstdAssessedVal,
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
                                         AdjustmentTypeSet,  {Adjust swis, school, exemption, sd}
                                         'D');  {Delete the totals.}

          {Add the new roll totals for this parcel.}
          {FXX04151998-8: Using the original hstd and nonhstd av's
                          instead of the new hstd and nonhstd av's which
                          could have changed if the hstd code was
                          changes.}

        AdjustRollTotalsForParcel(TaxRollYr,
                                  ParcelTable.FieldByName('SwisCode').Text,
                                  NewSchoolCode,
                                  NewHomesteadCode,
                                  NewRollSection,
                                  NewHstdLandVal, NewNonhstdLandVal,
                                  NewHstdAssessedVal,
                                  NewNonhstdAssessedVal,
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
                                  AdjustmentTypeSet,  {Adjust swis, school, exemption, sd}
                                  'A');  {Add the totals.}

         {CHG03301998-1: Trace SD, EX changes from everywhere. Also more parcel info.}

        GetAuditParcelRec(ParcelTable,
                          AssessmentTable.FieldByName('TotalAssessedVal').AsFloat,
                          EXAmounts,
                          NewAuditParcelRec);

        InsertParcelChangeRec(SwisSBLKey, TaxRollYr, AuditParcelChangeTable,
                              OrigAuditParcelRec, NewAuditParcelRec,
                              'C');

        NewExemptionCodes.Free;
        NewExemptionHomesteadCodes.Free;
        NewResidentialTypes.Free;
        NewCountyExemptionAmounts.Free;
        NewTownExemptionAmounts.Free;
        NewSchoolExemptionAmounts.Free;
        NewVillageExemptionAmounts.Free;
        ClearTList(NewSDAmounts, SizeOf(ParcelSDValuesRecord));
        FreeTList(NewSDAmounts, SizeOf(ParcelSDValuesRecord));

      end;  {If (HomesteadCodeChanged or ...}

    {CHG10281997-1: Dual mode processing.}

  If GlblModifyBothYears
    then
      begin
          {FXX01202000-2: Copy information forward for parcel record on a field
                          by field basis only.}

        NewFieldValues.Clear;

        with ParcelTable do
          For I := 0 to (FieldCount - 1) do
            NewFieldValues.Add(Fields[I].Text);

           {Now go through the list and compare on a field by field basis
            any changes.}

        ChangedFields := TStringList.Create;
        For I := 0 to (OriginalFieldValues.Count - 1) do
          If (NewFieldValues[I] <> OriginalFieldValues[I])
            then ChangedFields.Add(ParcelTable.Fields[I].FieldName);

        CreateFieldValuesAndLabels(Self, OppositeYearParcelTable,
                                   FieldTraceInformationList);

          {Copy the fields from the main table to the new table, but make
           sure that we do not copy the tax roll year.}

        SBLRec := ExtractSwisSBLFromSwisSBLKey(SwisSBLKey);

        with SBLRec do
          Found := FindKeyOld(OppositeYearParcelTable,
                              ['TaxRollYr', 'SwisCode', 'Section',
                               'Subsection', 'Block', 'Lot', 'Sublot',
                               'Suffix'],
                              [OppositeTaxYear,
                               SwisCode, Section, SubSection,
                               Block, Lot, Sublot, Suffix]);

          {FXX06222001-1: Don't move changes forward if NY parcel is inactive.}

        If (Found and
            (OppositeYearParcelTable.FieldByName('ActiveFlag').Text <> InactiveParcelFlag))
          then
            begin
                {Get the original amounts so we can adjust the totals
                 if necessary.}

              OppositeYearExemptionCodeTable := FindTableInDataModuleForProcessingType(DataModuleExemptionCodeTableName,
                                                                                       NextYear);
              OppositeYearExemptionTable := TTable.Create(nil);
              OpenTableForProcessingType(OppositeYearExemptionTable,
                                         ExemptionsTableName,
                                         NextYear, Quit);
              OppositeYearExemptionTable.IndexName := 'BYYEAR_SWISSBLKEY_EXCODE';

              OppositeYearAssessmentTable := FindTableInDataModuleForProcessingType(DataModuleAssessmentTableName,
                                                                                    NextYear);
              OppositeYearSwisCodeTable := FindTableInDataModuleForProcessingType(DataModuleSwisCodeTableName,
                                                                                  NextYear);
              OppositeYearSDCodeTable := FindTableInDataModuleForProcessingType(DataModuleSpecialDistrictCodeTableName,
                                                                                NextYear);
              OppositeYearParcelSDTable := FindTableInDataModuleForProcessingType(DataModuleSpecialDistrictTableName,
                                                                                  NextYear);

              FindKeyOld(OppositeYearAssessmentTable,
                         ['TaxRollYr', 'SwisSBLKey'],
                         [OppositeTaxYear, SwisSBLKey]);

              CreateFieldValuesAndLabels(Self, OppositeYearParcelTable,
                                         FieldTraceInformationList);

                {Determine the Orig values of the roll section, school code,
                 homestead code, frontage, depth, and acreage.}

              with OppositeYearParcelTable do
                begin
                  OrigRollSection := FieldByName('RollSection').Text;
                  OrigHomesteadCode := FieldByName('HomesteadCode').Text;
                  OrigHomesteadDesc := FieldByName('HomesteadDesc').Text;
                  OrigSchoolCode := FieldByName('SchoolCode').Text;

                  OrigResidentialPercent := FieldByName('ResidentialPercent').AsFloat;
                  OrigFrontage := FieldByName('Frontage').AsFloat;
                  OrigDepth := FieldByName('Depth').AsFloat;
                  OrigAcreage := FieldByName('Acreage').AsFloat;

                end;  {with OppositeYearParcelTable do}

                {Now figure out the original exemption and special district
                 amounts.}
                {CHG12011997-2: STAR support}
                {FXX02091998-1: Pass the residential type of each exemption.}

              EXAmounts := TotalExemptionsForParcel(OppositeTaxYear, SwisSBLKey,
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

               {CHG03301998-1: Trace SD, EX changes from everywhere. Also more parcel info.}

              GetAuditParcelRec(OppositeYearParcelTable,
                                OppositeYearAssessmentTable.FieldByName('TotalAssessedVal').AsFloat,
                                EXAmounts,
                                OrigAuditParcelRec);

                {FXX02171999-7: Store the name address information to see if it changed.}

              OrigNameAddressBankCodeRec := GetNameAddressBankCodeInfo(OppositeYearParcelTable);

                 {Now copy the changes to the other year.}

              OppositeYearParcelTable.Edit;

                {FXX01202000-2: Copy information forward for parcel record on a field
                                by field basis only.}

              For I := 0 to (ChangedFields.Count - 1) do
                OppositeYearParcelTable.FieldByName(ChangedFields[I]).Text :=
                                         ParcelTable.FieldByName(ChangedFields[I]).Text;

              If (RecordChanges(Self, 'Base Information',
                                OppositeYearParcelTable, SwisSBLKey,
                                FieldTraceInformationList) > 0)
                then
                  with OppositeYearParcelTable do
                    begin
                      FieldByName('LastChangeByName').Text := GlblUserName;
                      FieldByName('LastChangeDate').AsDateTime := Date;

                    end;

                  {FXX02171999-7: Store the name address information to see if it changed.}

                NewNameAddressBankCodeRec := GetNameAddressBankCodeInfo(OppositeYearParcelTable);

                If NameAddressBankCodeDifferent(OrigNameAddressBankCodeRec,
                                                NewNameAddressBankCodeRec)
                  then
                    begin
                      OppositeYearParcelTable.FieldByName('DateAddressChanged').AsDateTime := Date;
                      OppositeYearParcelTable.FieldByName('AddressExtracted').AsBoolean := False;

                        {FXX03112002-1: Don't forget to clear the flag in NY.}

                      OppositeYearParcelTable.FieldByName('DateChangedForExtract').AsDateTime := Date;
                      OppositeYearParcelTable.FieldByName('ChangeExtracted').AsBoolean := False;

                    end;  {If NameAddressBankCodeDifferent ...}

              try
                OppositeYearParcelTable.Post;
              except
                SystemSupport(050, OppositeYearParcelTable,
                              'Error posting opposite year record.', UnitName,
                              GlblErrorDlgBox);
              end;

                {Determine the new values of the roll section, school code,
                 homestead code, frontage, depth, and acreage.}

              with OppositeYearParcelTable do
                begin
                  NewRollSection := FieldByName('RollSection').Text;
                  NewHomesteadCode := FieldByName('HomesteadCode').Text;
                  NewSchoolCode := FieldByName('SchoolCode').Text;

                  NewResidentialPercent := FieldByName('ResidentialPercent').AsFloat;
                  NewFrontage := FieldByName('Frontage').AsFloat;
                  NewDepth := FieldByName('Depth').AsFloat;
                  NewAcreage := FieldByName('Acreage').AsFloat;

                end;  {with OppositeYearParcelTable do}

                {Figure out what changed.}

              HomesteadCodeChanged := (Take(1, OrigHomesteadCode) <> Take(1, NewHomesteadCode));
              RollSectionChanged := (Take(1, OrigRollSection) <> Take(1, NewRollSection));
              SchoolCodeChanged := (Take(6, OrigSchoolCode) <> Take(6, NewSchoolCode));
              FrontageChanged := (Roundoff(OrigFrontage, 2) <> Roundoff(NewFrontage, 2));
              DepthChanged := (Roundoff(OrigDepth, 2) <> Roundoff(NewDepth, 2));
              AcreageChanged := (Roundoff(OrigAcreage, 2) <> Roundoff(NewAcreage, 2));
              ResidentialPercentChanged := (Roundoff(OrigResidentialPercent, 2) <> Roundoff(NewResidentialPercent, 2));

              CalculateHstdAndNonhstdAmounts(OppositeTaxYear,
                                             SwisSBLKey,
                                             OppositeYearAssessmentTable,
                                             OppositeYearClassTable,
                                             OppositeYearParcelTable,
                                             OrigHstdAssessedVal,
                                             OrigNonhstdAssessedVal,
                                             OrigHstdLandVal, OrigNonhstdLandVal,
                                             HstdAcres, NonhstdAcres,
                                             AssessmentRecordFound,
                                             ClassRecordFound);

                {If the homestead code changed from split to non=split, then tell them the
                 class record was deleted.}

              If (HomesteadCodeChanged and
                  (OrigHomesteadCode = 'S') and
                  ClassRecordFound)
                then
                  begin
                    try
                      OppositeYearClassTable.Delete;
                    except
                      SystemSupport(030, ClassTable, 'Error deleting class record.',
                                    UnitName, GlblErrorDlgBox);
                    end;

                  end;  {If (HomesteadCodeChanged and ...}

                {Now, if anything changed, adjust the roll totals.}

              If (HomesteadCodeChanged or
                  RollSectionChanged or
                  SchoolCodeChanged or
                  FrontageChanged or
                  DepthChanged or
                  AcreageChanged or
                  ResidentialPercentChanged)
                then
                  begin
                    NewExemptionCodes := TStringList.Create;
                    NewExemptionHomesteadCodes := TStringList.Create;
                    NewResidentialTypes := TStringList.Create;
                    NewCountyExemptionAmounts := TStringList.Create;
                    NewTownExemptionAmounts := TStringList.Create;
                    NewSchoolExemptionAmounts := TStringList.Create;
                    NewVillageExemptionAmounts := TStringList.Create;
                    NewSDAmounts := TList.Create;
                    AdjustmentTypeSet := [];

                      {Only the swis roll totals need to be adjusted if
                       the roll section changed.}
                      {FXX11031997-2: Need to combine the adjustment types
                                      rather then just assign a single one.}

                    If RollSectionChanged
                      then AdjustmentTypeSet := AdjustmentTypeSet + ['S'];

                      {Only the school roll totals need to be adjusted if
                       the school code changed.}

                    If SchoolCodeChanged
                      then AdjustmentTypeSet := AdjustmentTypeSet + ['C'];

                    If (FrontageChanged or
                        DepthChanged or
                        AcreageChanged)
                      then AdjustmentTypeSet := AdjustmentTypeSet + ['D'];

                      {If the homestead code changed, we will need to adjust
                       all roll totals since homestead code is part of the
                       key for all 4 roll total types.
                       If the residential % changed, then the exemptions may have
                       changed. Since any exemption change could affect another
                       roll total, we will have to redo all the roll totals.
                       So, we will recalculate all of }

                    If (HomesteadCodeChanged or
                        RollSectionChanged or
                        ResidentialPercentChanged)
                      then
                        begin
                          AdjustmentTypeSet := ['S', 'C', 'E', 'D'];

                            {If the exemptions change because of a change in
                             hstd or res %, put out ex audit records.}

                          AuditEXChangeList := TList.Create;
                          GetAuditEXList(SwisSBLKey, OppositeTaxYear,
                                         OppositeYearExemptionTable,
                                         AuditEXChangeList);
                          InsertAuditEXChanges(SwisSBLKey,
                                               OppositeTaxYear,
                                               AuditEXChangeList,
                                               AuditEXChangeTable, 'B');
                          FreeTList(AuditEXChangeList, SizeOf(AuditEXRecord));

                            {Since there has been an assessed value change,
                             it is very possible that an exemption amount will change,
                             too. So, we will recalculate all exemptions and redo the
                             totals.}

                          RecalculateExemptionsForParcel(OppositeYearExemptionCodeTable,
                                                         OppositeYearExemptionTable,
                                                         OppositeYearAssessmentTable,
                                                         OppositeYearClassTable,
                                                         OppositeYearSwisCodeTable,
                                                         OppositeYearParcelTable,
                                                         OppositeTaxYear,
                                                         SwisSBLKey, nil,
                                                         0, 0, False);

                            {If the exemptions change because of a change in
                             hstd or res %, put out ex audit records.}

                          AuditEXChangeList := TList.Create;
                          GetAuditEXList(SwisSBLKey, OppositeTaxYear,
                                         OppositeYearExemptionTable,
                                         AuditEXChangeList);
                          InsertAuditEXChanges(SwisSBLKey,
                                               OppositeTaxYear,
                                               AuditEXChangeList,
                                               AuditEXChangeTable, 'A');
                          FreeTList(AuditEXChangeList, SizeOf(AuditEXRecord));

                        end;  {If (HomesteadCodeChanged or ...}

                      {Delete all the old roll totals for this parcel.}

                    CalculateHstdAndNonhstdAmounts(OppositeTaxYear,
                                                   SwisSBLKey,
                                                   OppositeYearAssessmentTable,
                                                   OppositeYearClassTable,
                                                   OppositeYearParcelTable,
                                                   NewHstdAssessedVal,
                                                   NewNonhstdAssessedVal,
                                                   NewHstdLandVal, NewNonhstdLandVal,
                                                   HstdAcres, NonhstdAcres,
                                                   AssessmentRecordFound,
                                                   ClassRecordFound);

                      {FXX11031997-5: Always calc the new ex and SD
                                      amounts, not just on a case
                                      by case basis.}

                      {Now figure out the new exemption totals.}
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

                      {The special district amounts may have changed, so
                       calculate the new special district amounts, too.}

                    TotalSpecialDistrictsForParcel(OppositeTaxYear,
                                                   SwisSBLKey,
                                                   OppositeYearParcelTable,
                                                   OppositeYearAssessmentTable,
                                                   OppositeYearParcelSDTable,
                                                   OppositeYearSDCodeTable,
                                                   OppositeYearExemptionTable,
                                                   OppositeYearExemptionCodeTable,
                                                   NewSDAmounts);

                      {CHG12011997-2: STAR support}
                      {FXX12041997-4: Record full, unadjusted STAR amount. Need to pass
                                      the parcel table for that.}
                      {FXX11021999-9: Don't delete out old totals if this is a parcel
                                      done through Add a Parcel - it will have no roll
                                      section and nothing to reverse out.}

                    If (Deblank(OrigRollSection) <> '')
                      then AdjustRollTotalsForParcel(OppositeTaxYear,
                                              OppositeYearParcelTable.FieldByName('SwisCode').Text,
                                              OrigSchoolCode,
                                              OrigHomesteadCode,
                                              OrigRollSection,
                                              OrigHstdLandVal,
                                              OrigNonhstdLandVal,
                                              OrigHstdAssessedVal,
                                              OrigNonhstdAssessedVal,
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
                                              AdjustmentTypeSet,  {Adjust swis, school, exemption, sd}
                                              'D');  {Delete the totals.}

                      {Add the new roll totals for this parcel.}

                    AdjustRollTotalsForParcel(OppositeTaxYear,
                                              OppositeYearParcelTable.FieldByName('SwisCode').Text,
                                              NewSchoolCode,
                                              NewHomesteadCode,
                                              NewRollSection,
                                              NewHstdLandVal,
                                              NewNonhstdLandVal,
                                              OrigHstdAssessedVal,
                                              OrigNonhstdAssessedVal,
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
                                              AdjustmentTypeSet,  {Adjust swis, school, exemption, sd}
                                              'A');  {Add the totals.}

                      {CHG03301998-1: Trace SD, EX changes from everywhere. Also more parcel info.}

                    GetAuditParcelRec(OppositeYearParcelTable,
                                      OppositeYearAssessmentTable.FieldByName('TotalAssessedVal').AsFloat,
                                      EXAmounts,
                                      NewAuditParcelRec);

                    InsertParcelChangeRec(SwisSBLKey, OppositeTaxYear,
                                          AuditParcelChangeTable,
                                          OrigAuditParcelRec,
                                          NewAuditParcelRec, 'C');

                    NewExemptionCodes.Free;
                    NewExemptionHomesteadCodes.Free;
                    NewResidentialTypes.Free;
                    NewCountyExemptionAmounts.Free;
                    NewTownExemptionAmounts.Free;
                    NewSchoolExemptionAmounts.Free;
                    NewVillageExemptionAmounts.Free;
                    ClearTList(NewSDAmounts, SizeOf(ParcelSDValuesRecord));
                    FreeTList(NewSDAmounts, SizeOf(ParcelSDValuesRecord));

                  end;  {If (HomesteadCodeChanged or ...}

              OppositeYearExemptionTable.Close;
              OppositeYearExemptionTable.Free;

            end;  {If Found}

          {FXX06222001-1: Don't move changes forward if NY parcel is inactive.}

        If (Found and
            (OppositeYearParcelTable.FieldByName('ActiveFlag').Text = InactiveParcelFlag))
          then MessageDlg('The parcel change was not moved forward to next year' + #13 +
                          'because the next year parcel is inactive.' + #13 +
                          'Please make sure that this is correct.', mtWarning, [mbOK], 0);

        ChangedFields.Free;

      end;  {If GlblModifyBothYears}

    {FXX11021998-4: If the major property class changes, warn them to check for
                    SD and exemption applicability.}
    {FXX03111999-5: Move to within change clause so does not
                    accidently appear on start up.}

  If ((Deblank(OrigPropertyClass) <> '') and
      (OrigPropertyClass[1] <> ParcelTable.FieldByName('PropertyClassCode').Text[1]))
    then MessageDlg('The property class changed major categories.' + #13 +
                    'Please check the special districts and exemptions for applicability.',
                    mtWarning, [mbOK], 0);

    {FXX05181999-1: Update the taxable vals based on recalculating exemptions.}

  DisplayAssessedAndTaxableValues;

    {If the homestead code changed to split, then we will create a class record
     with the amounts based on the land total homestead percentages
     that they entered.}

  If (HomesteadCodeChanged and
      (NewHomesteadCode = 'S'))
    then
      begin
         MessageDlg('You have split this parcel into' + #13 +
                    'homestead and nonhomestead portions.' + #13 + #13 +
                    'Please specify the percent of the original ' + #13 +
                    'parcel that will now be homestead.',
                    mtInformation, [mbOK], 0);

         ParcelSplitPanel.Visible := True;
         EditHstdLandPercent.SetFocus;

       end;  {If (HomesteadCodeChanged and ...}

    {FXX03031998-2: Set focus back to the first field.}

  SetFocusToFirstField;

    {FXX02101999-1: Display if the owner name is different between TY and NY.}

  DisplayOwnerChangeFlag;

end;  {ParcelTableAfterPost}

{===========================================================================}
Procedure TBaseParcelPg1Form.SaveButtonClick(Sender: TObject);

{FXX11031997-4: The update of changed time and name should be done in
                before post since they can save without clicking save by
                switching pages.}

begin
  If (ParcelTable.Modified and  {Table is modified.}
      (ParcelTable.State = dsEdit) and
      ((not GlblAskSave) or     {We should not confirm a save or...}
       (GlblAskSave and        {We should confirm a save and...}
        (MessageDlg('Do you want to save this parcel?', mtConfirmation,
                    [mbYes, mbCancel], 0) = mrYes))))  {They want to save it.}
    then ParcelTable.Post;

end;  {SaveButtonClick}

{===========================================================================}
Procedure TBaseParcelPg1Form.CancelButtonClick(Sender: TObject);

begin
  If (ParcelTable.Modified and
      (ParcelTable.State in [dsEdit, dsInsert]) and
      (MessageDlg('Warning! You will lose all changes.' + #13 +
                  'Cancel anyway?', mtWarning, [mbYes, mbNo], 0) = mrYes))
    then ParcelTable.Cancel;

end;  {CancelButtonClick}

{===========================================================================}
Procedure TBaseParcelPg1Form.CloseButtonClick(Sender: TObject);

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

{===========================================================================}
Procedure TBaseParcelPg1Form.FormCloseQuery(    Sender: TObject;
                                            var CanClose: Boolean);

var
  ReturnCode : Integer;

begin
  CanClose := True;
  GlblParcelPageCloseCancelled := False;

    {First see if anything needs to be saved. In order to
     determine if there are any changes, we need to sychronize
     the fields with what is in the DB edit boxes. To do this,
     we call the UpdateRecord. Then, if there are any changes,
     the Modified flag will be set to True.}

  If (ParcelTable.State in [dsInsert, dsEdit])
    then ParcelTable.UpdateRecord;

    {Now, if they are closing the table, let's see if they want to
     save any changes. However, we won't check this if
     they are in inquire mode. Note that sometimes a record can be marked even
     if there were no changes if a person clicks on a drop down box (even without changing
     the value). So, since we are recording field values before any changes, we
     will compare them to now and if there are no changes, we will cancel this
     edit or insert.}
    {FXX05151998-3: Don't ask save on close form if don't want to see save.}

  If ((not ParcelTable.ReadOnly) and
      (ParcelTable.State in [dsEdit, dsInsert]) and
      ParcelTable.Modified)
    then
      If (NumRecordChanges(Self, ParcelTable, FieldTraceInformationList) = 0)
        then ParcelTable.Cancel
        else
          If GlblAskSave
            then
              begin
                ReturnCode := MessageDlg('Do you wish to save your parcel changes?', mtConfirmation,
                                         [mbYes, mbNo, mbCancel], 0);

                case ReturnCode of
                  idYes : ParcelTable.Post;

                  idNo : ParcelTable.Cancel;

                  idCancel : begin
                               GlblParcelPageCloseCancelled := True;
                               CanClose := False;
                             end;

                end;  {case ReturnCode of}

              end
            else ParcelTable.Post;

end;  {FormCloseQuery}

{===========================================================================}
Procedure TBaseParcelPg1Form.FormClose(    Sender: TObject;
                                       var Action: TCloseAction);

begin
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

    {Free up the trace lists.}
  FreeTList(FieldTraceInformationList, SizeOf(FieldTraceInformationRecord));

  OriginalFieldValues.Free;
  NewFieldValues.Free;

  Action := caFree;

end;  {FormClose}

end.
