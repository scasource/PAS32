unit Psummary;

interface

uses
  DataModule, SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  StdCtrls, ExtCtrls, Forms, Dialogs, DB, Grids, DBGrids,
  DBTables, Mask, DBCtrls, Wwtable, Wwdatsrc, Wwdbcomb, Wwdbigrd, Wwdbgrid,
  Btrvdlg, Types, wwdblook, Buttons;

type
  TParcelSummaryForm = class(TForm)
    Panel2: TPanel;
    ParcelDataSource: TDataSource;
    ParcelGroupBox: TGroupBox;
    ExemptionGroupBox: TGroupBox;
    SpecialDistrictGroupBox: TGroupBox;
    ExemptionGrid: TwwDBGrid;
    SpecialDistrictGrid: TwwDBGrid;
    Label1: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    SwisSBLEdit: TEdit;
    EditName1: TDBEdit;
    EditName2: TDBEdit;
    EditAddr1: TDBEdit;
    EditAddr2: TDBEdit;
    EditStreet: TDBEdit;
    EditRollSection: TDBEdit;
    EditHomesteadCode: TDBEdit;
    EditBankCode: TDBEdit;
    Label8: TLabel;
    Label9: TLabel;
    NYLabel: TLabel;
    TYLabel: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    EditAcreage: TDBEdit;
    EditDepth: TDBEdit;
    EditFrontage: TDBEdit;
    ExemptionDataSource: TwwDataSource;
    SpecialDistrictDataSource: TwwDataSource;
    SiteGroupBox: TGroupBox;
    CommercialSiteGrid: TwwDBGrid;
    ResidentialSiteDataSource: TwwDataSource;
    EditLegalAddress: TEdit;
    EditThisYearLandVal: TEdit;
    EditThisYearTotalVal: TEdit;
    EditNextYearTotalVal: TEdit;
    EditNextYearLandVal: TEdit;
    SalesGroupBox: TGroupBox;
    SalesGrid: TwwDBGrid;
    EditCountyTaxableVal: TEdit;
    EditTownTaxableVal: TEdit;
    EditSchoolTaxableVal: TEdit;
    EditFullMarketVal: TEdit;
    SalesDataSource: TwwDataSource;
    CountyTaxableLabel: TLabel;
    TownTaxableLabel: TLabel;
    SchoolTaxableLabel: TLabel;
    FullMarketValueLabel: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    EditSchoolCode: TDBEdit;
    EditCity: TDBEdit;
    DBEdit1: TDBEdit;
    Label16: TLabel;
    InactiveLabel: TLabel;
    YearLabel: TLabel;
    Label2: TLabel;
    Label14: TLabel;
    Bevel1: TBevel;
    LandGroupBox: TGroupBox;
    LandGrid: TwwDBGrid;
    Bevel2: TBevel;
    LandDataSource: TwwDataSource;
    ImprovementGroupBox: TGroupBox;
    ImprovementGrid: TwwDBGrid;
    ImprovementsDataSource: TwwDataSource;
    BuildingGroupBox: TGroupBox;
    ResidentialBldgGrid: TwwDBGrid;
    ResidentialBldgDataSource: TwwDataSource;
    CloseButton: TBitBtn;
    ResidentialSiteGrid: TwwDBGrid;
    CommercialBldgGrid: TwwDBGrid;
    CommercialBldgDataSource: TwwDataSource;
    CommercialSiteDataSource: TwwDataSource;
    EditPriorLandVal: TEdit;
    EditPriorTotalVal: TEdit;
    PriorLabel: TLabel;
    STARAmountOrUniformPercentEdit: TEdit;
    STARAmountOrUniformPercentLabel: TLabel;
    SwisCodeLabel: TLabel;
    HistoryButton: TBitBtn;
    PropertyClassEdit: TEdit;
    OldParcelIDLabel: TLabel;
    EditStateZip: TEdit;
    NameAddressDataSource: TDataSource;
    PriorYearPartiallyAssessedLabel: TLabel;
    ThisYearPartiallyAssessedLabel: TLabel;
    NextYearPartiallyAssessedLabel: TLabel;
    ExemptionTable: TwwTable;
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
    ExemptionTableReserved: TStringField;
    ExemptionTableAutoRenew: TBooleanField;
    ExemptionTableDisplayedPercent: TStringField;
    tb_ExemptionsTemp: TTable;
    tbSchool: TwwTable;
    dsSchool: TwwDataSource;

    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure CloseButtonClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure SpecialDistrictTableCalcFields(DataSet: TDataset);
    procedure HistoryButtonClick(Sender: TObject);
    procedure ExemptionTableCalcFields(DataSet: TDataSet);

  protected
    procedure CreateParams(var Params: TCreateParams); override;
  public
    { public declarations }
    UnitName : String;  {For use with error dialog box.}
    bInitializingForm : Boolean;

      {These will be set in the ParcelTabForm.}

    TaxRollYr, SwisSBLKey : String;
    ProcessingType : Integer;  {ThisYear, NextYear, History}
    PrevHeight, PrevWidth : Integer;

    SalesTable,
    AssessmentTable,
    ExemptionCodeTable,
    SpecialDistrictTable,
    ParcelTable,
    NYParcelTable,
    SwisCodeTable,
    AssessmentYearControlTable,
    ResidentialSiteTable,
    CommercialSiteTable,
    CommercialBldgTable,
    ResidentialBldgTable,
    LandTable, ImprovementsTable : TwwTable;

    Function ConvertSwisSBLToOldDashDotNoSwis(SwisSBLKey : String) : String;

    Procedure InitializeForm;
    Procedure SetRangeForTable(Table : TTable);
      {Now set the range on this table so that it is sychronized to this parcel. Note
      that all segments of the key must be set.}

   Procedure FillInValues(SwisSBLKey : String;
                          ProcessingType : Integer;
                          TaxRollYear,
                          YearToDisplay : String;
                          EditLandVal,
                          EditTotalVal : TEdit;
                          YearLabel : TLabel;
                          UsePriorFields : Boolean;
                          PartiallyAssessedLabelIndex : Integer);

    Procedure DisplayTaxableAndAssessedValues;


  end;

implementation

uses GlblVars, PASTypes, WinUtils, PASUTILS, UTILEXSD,  Utilitys,
     GlblCnst, DataAccessUnit,
(*     PEnhancedHistoryForm, *)
     Phistfrm;

const
  ScreenHeight : Longint = 393;
  ScreenWidth : LongInt = 632;

{$R *.DFM}

{=====================================================================}
Procedure TParcelSummaryForm.CreateParams(var Params: TCreateParams);

begin
 inherited CreateParams(Params);

  with Params do
    begin
      WndParent := Application.Mainform.Handle;
      Style := (Style or WS_Child) and not WS_Popup;
    end;

end;  {CreateParams}

{========================================================================}
Procedure TParcelSummaryForm.SetRangeForTable(Table : TTable);

{Now set the range on this table so that it is sychronized to this parcel. Note
 that all segments of the key must be set.}
{mmm4 - Make sure to set range on all keys.}

begin
  try
    Table.SetRange([TaxRollYr, SwisSBLKey], [TaxRollYr, SwisSBLKey]);
  except
    SystemSupport(001, Table, 'Error setting range in ' + Table.Name, UnitName, GlblErrorDlgBox);
  end;

end;  {SetRangeForTable}

{========================================================================}
Procedure TParcelSummaryForm.FillInValues(SwisSBLKey : String;
                                          ProcessingType : Integer;
                                          TaxRollYear,
                                          YearToDisplay : String;
                                          EditLandVal,
                                          EditTotalVal : TEdit;
                                          YearLabel : TLabel;
                                          UsePriorFields : Boolean;
                                          PartiallyAssessedLabelIndex : Integer);

var
  bFound, PartiallyAssessed : Boolean;
  TotalVal, LandVal : Comp;

begin
  PartiallyAssessed := False;
  AssessmentTable := FindTableInDataModuleForProcessingType(DataModuleAssessmentTableName,
                                                            ProcessingType);

  LogTime('c:\trace.txt', '27a');

  bFound := FindKeyOld(AssessmentTable,
                       ['TaxRollYr', 'SwisSBLKey'],
                       [TaxRollYear, SwisSBLKey]);

  LogTime('c:\trace.txt', '27b');

  LandVal := 0;
  TotalVal := 0;

  If bFound
    then
      with AssessmentTable do
        If UsePriorFields
          then
            begin
              LandVal := FieldByName('PriorLandValue').AsFloat;
              TotalVal := FieldByName('PriorTotalValue').AsFloat;
            end
          else
            begin
              LandVal := FieldByName('LandAssessedVal').AsFloat;
              TotalVal := FieldByName('TotalAssessedVal').AsFloat;
              PartiallyAssessed := FieldByName('PartialAssessment').AsBoolean;
            end;

  LogTime('c:\trace.txt', '27c');

  EditLandVal.Text := FormatFloat(CurrencyDisplayNoDollarSign, LandVal);
  EditTotalVal.Text := FormatFloat(CurrencyDisplayNoDollarSign, TotalVal);

    {CHG03282002-3: Display partially assessed logic on summary screen.}

  If PartiallyAssessed
    then
      case PartiallyAssessedLabelIndex of
        1 : PriorYearPartiallyAssessedLabel.Visible := True;
        2 : ThisYearPartiallyAssessedLabel.Visible := True;
        3 : NextYearPartiallyAssessedLabel.Visible := True;

      end;  {case ProcessingType of}

  YearLabel.Caption := '''' + Copy(YearToDisplay, 3, 2);

  LogTime('c:\trace.txt', '27d');

end;  {FillInValues}

{========================================================================}
Procedure TParcelSummaryForm.DisplayTaxableAndAssessedValues;

var
(*  PriorLandVal, PriorTotalVal, LandAssessedVal, VillageTaxableVal*)
  BasicSTARAmount, EnhancedSTARAmount, TotalSTAR,
  TotalAssessedVal, CountyTaxableVal,
  TownTaxableVal, SchoolTaxableVal : Comp;
  PriorTaxYearFound, Found : Boolean;
  ExemptArray : ExemptionTotalsArrayType;
  ExemptionCodes,
  ExemptionHomesteadCodes,
  ResidentialTypes,
  CountyExemptionAmounts,
  TownExemptionAmounts,
  SchoolExemptionAmounts,
  VillageExemptionAmounts : TStringList;
  TempYear : Integer;
  HistoryYearPlusOne, PriorYear, SecondPriorYear, FormatString : String;
  Bookmark : TBookmark;

begin
(*  PriorLandVal := 0;
  PriorTotalVal := 0;*)
  Found := False;

  ExemptionCodes := TStringList.Create;
  ExemptionHomesteadCodes := TStringList.Create;
  ResidentialTypes := TStringList.Create;
  CountyExemptionAmounts := TStringList.Create;
  TownExemptionAmounts := TStringList.Create;
  SchoolExemptionAmounts := TStringList.Create;
  VillageExemptionAmounts := TStringList.Create;

  try
    Found := FindKeyOld(AssessmentTable, ['TaxRollYr', 'SwisSBLKey'],
                        [TaxRollYr, SwisSBLKey]);
  except
    SystemSupport(003, AssessmentTable, 'Error finding key in assessment table.', UnitName, GlblErrorDlgBox);
  end;

  If not Found
    then
      begin
(*        LandAssessedVal := 0;*)
        TotalAssessedVal := 0;
        CountyTaxableVal := 0;
        TownTaxableVal := 0;
        SchoolTaxableVal := 0;
(*        VillageTaxableVal := 0;*)
      end
    else
      begin
(*        LandAssessedVal := TCurrencyField(AssessmentTable.FieldByName('LandAssessedVal')).AsFloat;*)
        TotalAssessedVal := TCurrencyField(AssessmentTable.FieldByName('TotalAssessedVal')).AsFloat;

          {If this is the this year , let's make note of the prior values
           in case there is no history year.}

(*        If (TaxRollYr = GlblThisYear)
          then
            begin
              PriorLandVal := TCurrencyField(AssessmentTable.FieldByName('PriorLandValue')).AsFloat;
              PriorTotalVal := TCurrencyField(AssessmentTable.FieldByName('PriorTotalValue')).AsFloat;
            end; *)

          {Get the total exemptions for the parcel so that we can figure
           out the assessed value.}

          {CHG12011997-2: STAR support}
          {FXX02091998-1: Pass the residential type of each exemption.}

        LogTime('c:\trace.txt', '1');
        ExemptArray := TotalExemptionsForParcel(TaxRollYr, SwisSBLKey,
                                                tb_ExemptionsTemp,
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
        LogTime('c:\trace.txt', '2');

          {Note that we will display the taxable value of the
           municipality type that is running PAS.}
          {FXX05261998-3: Don't let a taxable value decrease below 0.}

        CountyTaxableVal := CalculateTaxableVal(TotalAssessedVal, ExemptArray[EXCounty]);
        TownTaxableVal := CalculateTaxableVal(TotalAssessedVal, ExemptArray[EXTown]);
        SchoolTaxableVal := CalculateTaxableVal(TotalAssessedVal, ExemptArray[EXSchool]);
(*        VillageTaxableVal := CalculateTaxableVal(TotalAssessedVal, ExemptArray[EXVillage]);*)

      end;  {If not Found}

  EditCountyTaxableVal.Text := FormatFloat(CurrencyDisplayNoDollarSign, CountyTaxableVal);
  EditTownTaxableVal.Text := FormatFloat(CurrencyDisplayNoDollarSign, TownTaxableVal);
  EditSchoolTaxableVal.Text := FormatFloat(CurrencyDisplayNoDollarSign, SchoolTaxableVal);
(*  EditVillageTaxableVal.Text := FormatFloat(CurrencyNormalDisplay, VillageTaxableVal);*)

     {CHG01192004-1(2.08): Let each municipality decide what roll totals to display.}

  LogTime('c:\trace.txt', '3');

  If not (rtdCounty in GlblRollTotalsToShow)
    then
      begin
        EditCountyTaxableVal.Visible := False;
        CountyTaxableLabel.Visible := False;
      end;

  If (rtdMunicipal in GlblRollTotalsToShow)
    then TownTaxableLabel.Caption := GetMunicipalityTypeName(GlblMunicipalityType)
    else
      begin
        EditTownTaxableVal.Visible := False;
        TownTaxableLabel.Visible := False;
      end;

  If not (rtdSchool in GlblRollTotalsToShow)
    then
      begin
        EditSchoolTaxableVal.Visible := False;
        SchoolTaxableLabel.Visible := False;
      end;

    {CHG03282002-2: Display full market value.}

  LogTime('c:\trace.txt', '4');

    {FXX07252012-1[PAS-469]: Make sure to get the correct year if it is history.}

  If (ProcessingType = History)
  then
    with SwisCodeTable do
    begin
      Filtered := False;
      Filter := 'TaxRollYr = ' + FormatFilterString(glblHistYear);
      Filtered := True;
    end;

  FindKeyOld(SwisCodeTable, ['SwisCode'], [ParcelTable.FieldByName('SwisCode').Text]);

  EditFullMarketVal.Text := FormatFloat(CurrencyDisplayNoDollarSign,
                                        ComputeFullValue(TotalAssessedVal,
                                                         SwisCodeTable,
                                                         ParcelTable.FieldByName('PropertyClassCode').Text,
                                                         ParcelTable.FieldByName('OwnershipCode').Text,
                                                         False));

  SwisCodeTable.Filtered := False;

  LogTime('c:\trace.txt', '5');

    {CHG12011997-2: STAR support. Display the star amount. The TV with
                    STAR is in the hint.}

    {CHG10112004-1(2.8.0.14): Option to show the uniform % (or RAR) instead of the STAR amount.}

  If not GlblShowUniformPercentInsteadOfSTARAmountOnSummaryScreen
    then
      begin
        TotalSTAR := BasicSTARAmount + EnhancedSTARAmount;

          {CHG04262007-1(2.11.1.26): Allow for option to suppress $ on assessments.}

        FormatString := GetAssessmentDisplayFormat;

        STARAmountOrUniformPercentEdit.Text := FormatFloat(FormatString, TotalSTAR);
        STARAmountOrUniformPercentEdit.Hint := 'The school taxable value with STAR is = ' +
                                               FormatFloat(CurrencyNormalDisplay, (SchoolTaxableVal - TotalSTAR));

      end;  {If not GlblShowUniformPercentInsteadOfSTARAmountOnSummaryScreen}

    {Fill in the labels for the assessed value amounts.}
    {Now fill in the year amounts.}
    {CHG04302003-3(2.07a): Option to always show 2 years prior from year that
                           they are in.}

  LogTime('c:\trace.txt', '6');

  If (ProcessingType in [ThisYear, NextYear])
    then
      begin
        If (GlblSummaryAndPage1ValueInformationIsAlwaysPrior2Years and
            (ProcessingType = ThisYear))
          then
            begin
              TempYear := StrToInt(GlblThisYear);

              PriorYear := IntToStr(TempYear - 1);
              SecondPriorYear := IntToStr(TempYear - 2);

              FillInValues(SwisSBLKey, ThisYear, GlblThisYear,
                           GlblThisYear, EditNextYearLandVal,
                           EditNextYearTotalVal, NYLabel, False, 3);

              If HistoryExists
                then
                  begin
                    FillInValues(SwisSBLKey, History, PriorYear,
                                 PriorYear, EditThisYearLandVal,
                                 EditThisYearTotalVal, TYLabel, False, 2);

                    FillInValues(SwisSBLKey, History, SecondPriorYear,
                                 SecondPriorYear, EditPriorLandVal,
                                 EditPriorTotalVal, PriorLabel, False, 1);

                  end
                else
                  begin
                    FillInValues(SwisSBLKey, ThisYear, GlblThisYear,
                                 PriorYear, EditThisYearLandVal,
                                 EditThisYearTotalVal, TYLabel, False, 2);

                    EditPriorLandVal.Text := '';
                    EditPriorTotalVal.Text := '';
                    PriorLabel.Caption := '';

                  end;  {else of If HistoryExists}

            end
          else
            begin
              TempYear := StrToInt(GlblThisYear);

              PriorYear := IntToStr(TempYear - 1);

                {CHG06291999-1: Keep the searcher from seeing next year values.}


              If ((not GlblUserIsSearcher) or
                  (GlblUserIsSearcher and
                   SearcherCanSeeNYValues))
                then FillInValues(SwisSBLKey, NextYear, GlblNextYear,
                                  GlblNextYear, EditNextYearLandVal,
                                  EditNextYearTotalVal, NYLabel, False, 3);

              FillInValues(SwisSBLKey, ThisYear, GlblThisYear,
                           GlblThisYear, EditThisYearLandVal,
                           EditThisYearTotalVal, TYLabel, False, 2);

              If HistoryExists
                then FillInValues(SwisSBLKey, History, PriorYear,
                                  PriorYear, EditPriorLandVal,
                                  EditPriorTotalVal, PriorLabel, False, 1)
                else FillInValues(SwisSBLKey, ThisYear, GlblThisYear,
                                  PriorYear, EditPriorLandVal,
                                  EditPriorTotalVal, PriorLabel, True, 1);

            end;  {If (GlblSummaryAndPage1ValueInformationIsAlwaysPrior2Years and ...}

      end
    else
      begin
        TempYear := StrToInt(TaxRollYr);
        PriorYear := IntToStr(TempYear - 1);

        LogTime('c:\trace.txt', '6a - Before History');

           {Farther back in history - put the year they are looking at
            in the middle}

        FillInValues(SwisSBLKey, History, TaxRollYr, TaxRollYr,
                     EditThisYearLandVal, EditThisYearTotalVal, TYLabel, False, 2);

        LogTime('c:\trace.txt', '6b - After history');
        HistoryYearPlusOne := IntToStr(TempYear + 1);

          {FXX11031999-5: Was not saving our place in the parcel table before testing
                          to see if there was a prior year.}

        Bookmark := ParcelTable.GetBookmark;

        LogTime('c:\trace.txt', '6c - Before Parcel Table Find Nearest');
        FindNearestOld(ParcelTable, ['TaxRollYr'], [PriorYear]);
        PriorTaxYearFound := (ParcelTable.FieldByName('TaxRollYr').Text = PriorYear);
        LogTime('c:\trace.txt', '6d - After Parcel Table Find Nearest');

          {FXX03192008-1(2.11.7.16): If the prior tax year was found, don't use the prior values for the NY value.}

        If (HistoryYearPlusOne = GlblThisYear)  {Only one year back in history.}
          then FillInValues(SwisSBLKey, ThisYear, GlblThisYear,
                            GlblThisYear, EditNextYearLandVal,
                            EditNextYearTotalVal, NYLabel, False, 3)
          else
            If PriorTaxYearFound
              then FillInValues(SwisSBLKey, History, HistoryYearPlusOne,
                                HistoryYearPlusOne, EditNextYearLandVal,
                                EditNextYearTotalVal, NYLabel, False, 3)
              else FillInValues(SwisSBLKey, History, HistoryYearPlusOne,
                                HistoryYearPlusOne, EditNextYearLandVal,
                                EditNextYearTotalVal, NYLabel, True, 3);

        LogTime('c:\trace.txt', '6e');

        If PriorTaxYearFound
          then FillInValues(SwisSBLKey, History, PriorYear, PriorYear, EditPriorLandVal,
                            EditPriorTotalVal, PriorLabel, False, 1)
          else FillInValues(SwisSBLKey, History, TaxRollYr, PriorYear, EditPriorLandVal,
                            EditPriorTotalVal, PriorLabel, True, 1);

        LogTime('c:\trace.txt', '6f');

        ParcelTable.GotoBookmark(Bookmark);
        ParcelTable.FreeBookmark(Bookmark);

        LogTime('c:\trace.txt', '6g');

      end;  {else of If ((ProcessingType in [ThisYear, NextYear]) or ...}

  LogTime('c:\trace.txt', '7');

     {CHG10161997-1: Display blanks for zeroes.}
  SetDisplayFormatForCurrencyFields(Self, True);

    {FXX10281997-3: The units and percentage should not be currency display.}

  TFloatField(SpecialDistrictTable.FieldByName('SDPercentage')).DisplayFormat := NoDecimalDisplay_BlankZero;
  TFloatField(SpecialDistrictTable.FieldByName('PrimaryUnits')).DisplayFormat := DecimalDisplay_BlankZero;
  TFloatField(SpecialDistrictTable.FieldByName('SecondaryUnits')).DisplayFormat := DecimalDisplay_BlankZero;

    {FXX12161997-3: The calc amount needs to have 2 decimals to show pro-rata
                    amount.}

  TFloatField(SpecialDistrictTable.FieldByName('CalcAmount')).DisplayFormat := DecimalDisplay_BlankZero;

    {FXX10221997-7: Had currency dec display where should be currency norm disp.}
    {FXX11251997-1: Owner and regular percent are not currency.}

    {CHG04262007-1(2.11.1.26): Allow for option to suppress $ on assessments.}

  FormatString := GetAssessmentDisplayFormat;

  TFloatField(ExemptionTable.FieldByName('Amount')).DisplayFormat := FormatString;
  TFloatField(ExemptionTable.FieldByName('OwnerPercent')).DisplayFormat := NoDecimalDisplay_BlankZero;
  TFloatField(ExemptionTable.FieldByName('Percent')).DisplayFormat := NoDecimalDisplay_BlankZero;

  ExemptionCodes.Free;
  ExemptionHomesteadCodes.Free;
  ResidentialTypes.Free;
  CountyExemptionAmounts.Free;
  TownExemptionAmounts.Free;
  SchoolExemptionAmounts.Free;
  VillageExemptionAmounts.Free;

  LogTime('c:\trace.txt', '8');

end;  {DisplayNextYearTaxableAndAssessedValue}

{===============================================================}
Function TParcelSummaryForm.ConvertSwisSBLToOldDashDotNoSwis(SwisSBLKey : String) : String;

begin
    {Switch to old segment formats}
  SetOldSegmentFormats;

  Result := ConvertSwisSBLToDashDotNoSwis(SwisSBLKey);

    {Switch back}
  SetGlobalSBLSegmentFormats(AssessmentYearControlTable);

end;  {ConvertSwisSBLToOldDashDotNoSwis}

{====================================================================}
Procedure TParcelSummaryForm.InitializeForm;

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
  ParcelHasResidentialInventory,
  ParcelHasCommercialInventory,
  Quit, Found, IsUniformPercent : Boolean;
  SBLRec : SBLRecord;
  TempParcelTable : TTable;
  Site : String;
  TempPercent : Double;

begin
  UnitName := 'PSUMMARY.PAS';  {mmm1}
  Quit := False;
  Found := False;
  bInitializingForm := True;

  If (Deblank(SwisSBLKey) <> '')
    then
      begin
        SetTaxYearLabelForProcessingType(YearLabel, ProcessingType);

        tbSchool.Open;

          {Set the tables to point to tables in the data module.}

        SalesTable := PASDataModule.SalesTable;
        ExemptionCodeTable := FindTableInDataModuleForProcessingType(DataModuleExemptionCodeTableName,
                                                                     ProcessingType);
        AssessmentTable := FindTableInDataModuleForProcessingType(DataModuleAssessmentTableName,
                                                                  ProcessingType);

          {FXX01082003-1: Put the exemption table on the form so that we can suppress the
                          exemption percent on veterans.}

        LogTime('c:\trace.txt', 'Summary - before exemption table open');
        OpenTableForProcessingType(ExemptionTable, ExemptionsTableName,
                                   ProcessingType, Quit);
        OpenTableForProcessingType(tb_ExemptionsTemp, ExemptionsTableName,
                                   ProcessingType, Quit);
        LogTime('c:\trace.txt', 'Summary - after exemption table open');

        (*ExemptionTable := FindTableInDataModuleForProcessingType(DataModuleExemptionTableName,
                                                                 ProcessingType);*)
        ExemptionDataSource.DataSet := ExemptionTable;
        SpecialDistrictTable := FindTableInDataModuleForProcessingType(DataModuleSpecialDistrictTableName,
                                                                       ProcessingType);
        SpecialDistrictDataSource.DataSet := SpecialDistrictTable;
        ParcelTable := FindTableInDataModuleForProcessingType(DataModuleParcelTableName,
                                                              ProcessingType);
        ParcelDataSource.DataSet := ParcelTable;

        NYParcelTable := FindTableInDataModuleForProcessingType(DataModuleParcelTableName,
                                                                NextYear);

        SwisCodeTable := FindTableInDataModuleForProcessingType(DataModuleSwisCodeTableName,
                                                                ProcessingType);

        AssessmentYearControlTable := FindTableInDataModuleForProcessingType(DataModuleAssessmentYearControlTableName,
                                                                             ProcessingType);

        ResidentialSiteTable := FindTableInDataModuleForProcessingType(DataModuleResidentialSiteTableName,
                                                                       ProcessingType);
        ResidentialSiteDataSource.DataSet := ResidentialSiteTable;

        CommercialSiteTable := FindTableInDataModuleForProcessingType(DataModuleCommercialSiteTableName,
                                                                       ProcessingType);
        CommercialSiteDataSource.DataSet := CommercialSiteTable;

          {FXX03072002-1: Make sure to refresh the information to reflect
                          changes to the data.}

        SalesTable.Refresh;
        AssessmentTable.Refresh;
        ExemptionTable.Refresh;
        SpecialDistrictTable.Refresh;
        ParcelTable.Refresh;
        NYParcelTable.Refresh;
        ResidentialSiteTable.Refresh;
        CommercialSiteTable.Refresh;

          {First let's find this parcel in the parcel table.}

        SBLRec := ExtractSwisSBLFromSwisSBLKey(SwisSBLKey);

        try
          with SBLRec do
            Found := FindKeyOld(ParcelTable,
                                ['TaxRollYr', 'SwisCode', 'Section',
                                 'Subsection', 'Block', 'Lot', 'Sublot',
                                 'Suffix'],
                                [TaxRollYr, SwisCode, Section,
                                 SubSection, Block, Lot, Sublot, Suffix]);
        except
          SystemSupport(004, ParcelTable, 'Error finding key in parcel table.', UnitName, GlblErrorDlgBox);
        end;

        If not Found
          then SystemSupport(005, ParcelTable, 'Error finding key in parcel table.', UnitName, GlblErrorDlgBox);

          {FXX11211997-11: The inactive label was being set before the
                           table was open.}

        If (ParcelTable.FieldByName('ActiveFlag').Text = InactiveParcelFlag)
          then InactiveLabel.Visible := True;

          {CHG02052006-1(2.9.5.4): 3 decimal display on acreage as per Yorktown.}

        TFloatField(ParcelTable.FieldByName('Acreage')).DisplayFormat := _3DecimalEditDisplay;
        TFloatField(ParcelTable.FieldByName('Frontage')).DisplayFormat := CurrencyDisplayNoDollarSign;
        TFloatField(ParcelTable.FieldByName('Depth')).DisplayFormat := CurrencyDisplayNoDollarSign;

        TCurrencyField(ExemptionTable.FieldByName('TownAmount')).DisplayFormat := CurrencyNormalDisplay;
        TFloatField(ExemptionTable.FieldByName('Percent')).DisplayFormat := '0.';
        TFloatField(ExemptionTable.FieldByName('OwnerPercent')).DisplayFormat := '0.';
        TCurrencyField(ResidentialSiteTable.FieldByName('FinalTotalValue')).DisplayFormat := CurrencyNormalDisplay;
        TFloatField(SpecialDistrictTable.FieldByName('PrimaryUnits')).DisplayFormat := DecimalDisplay;
        TFloatField(SpecialDistrictTable.FieldByName('SecondaryUnits')).DisplayFormat := DecimalDisplay;
        TCurrencyField(SalesTable.FieldByName('SalePrice')).DisplayFormat := CurrencyNormalDisplay;
        NameAddressDataSource.DataSet := ParcelTable;

          {CHG03112002-1: Allow for suppression of inventory values.}

        If not GlblShowInventoryValues
          then
          begin
            ResidentialSiteTable.FieldByName('FinalTotalValue').Visible := False;
            TStringField(ResidentialSiteTable.FieldByName('ZoningCode')).DisplayWidth := 12;
            TStringField(CommercialSiteTable.FieldByName('ZoningCode')).DisplayWidth := 12;
          end;

          {FXX03062000-2: Allow searcher to login to TY but see NY name\addr.}

        If GlblUserIsSearcher
          then
            begin
              with SBLRec do
                Found := FindKeyOld(NYParcelTable,
                                    ['TaxRollYr', 'SwisCode', 'Section',
                                     'Subsection', 'Block', 'Lot', 'Sublot',
                                     'Suffix'],
                                    [GlblNextYear, SwisCode, Section,
                                     SubSection, Block, Lot, Sublot, Suffix]);

              If Found
                then
                  begin
                    NameAddressDataSource.DataSet := NYParcelTable;
                    TempParcelTable := NYParcelTable;
                  end
                else
                  begin
                    TempParcelTable := ParcelTable;
                    NameAddressDataSource.DataSet := ParcelTable;
                  end;

            end
          else TempParcelTable := ParcelTable;

        SwisSBLEdit.Text := ConvertSwisSBLToDashDot(ExtractSSKey(ParcelTable));
        EditStateZip.Text := TempParcelTable.FieldByName('State').Text + ' ' +
                             TempParcelTable.FieldByName('Zip').Text;

        If (Deblank(ParcelTable.FieldByName('ZipPlus4').Text) <> '')
          then EditStateZip.Text := EditStateZip.Text + '-' + ParcelTable.FieldByName('ZipPlus4').Text;

        EditLegalAddress.Text := Trim(ParcelTable.FieldByName('LegalAddrNo').Text) + ' ' +
                                 Trim(ParcelTable.FieldByName('LegalAddr').Text);

        DisplayTaxableAndAssessedValues;

          {Set the ranges for the exemption, sales, sd and site tables.}

        LogTime('c:\trace.txt', '10');

        SetRangeOld(SalesTable, ['SwisSBLKey', 'SaleNumber'],
                    [SwisSBLKey, '0'], [SwisSBLKey, '32000']);

          {FXX02091999-3: Set it to the last sale in the range.}

        LogTime('c:\trace.txt', '11');
        SalesTable.Last;
        LogTime('c:\trace.txt', '12');

        (*ExemptionTable.CancelRange; *)
        bInitializingForm := False;
        LogTime('c:\trace.txt', 'Summary - before exemption table set range');
        SetRangeOld(ExemptionTable,
                    ['TaxRollYr', 'SwisSBLKey', 'ExemptionCode'],
                    [TaxRollYr, SwisSBLKey, '     '],
                    [TaxRollYr, SwisSBLKey, 'ZZZZZ']);
        LogTime('c:\trace.txt', 'Summary - after exemption table open');

        SetRangeOld(SpecialDistrictTable,
                    ['TaxRollYr', 'SwisSBLKey', 'SDistCode'],
                    [TaxRollYr, SwisSBLKey, '     '],
                    [TaxRollYr, SwisSBLKey, 'ZZZZZ']);
        SetRangeOld(ResidentialSiteTable,
                    ['TaxRollYr', 'SwisSBLKey', 'Site'],
                    [TaxRollYr, SwisSBLKey, '0'],
                    [TaxRollYr, SwisSBLKey, '32000']);
        SetRangeOld(CommercialSiteTable,
                    ['TaxRollYr', 'SwisSBLKey', 'Site'],
                    [TaxRollYr, SwisSBLKey, '0'],
                    [TaxRollYr, SwisSBLKey, '32000']);

        If (Take(26, ResidentialSiteTable.FieldByName('SwisSBLKey').Text) = Take(26, SwisSBLKey))
          then ParcelHasResidentialInventory := True
          else
            begin
              ParcelHasResidentialInventory := False;

                {FXX10242002-1: Make sure that the residential bldg does
                                not point to the wrong data if no inv for
                                this parcel.}

              ResidentialBldgDataSource.DataSet := nil;

            end;  {If (Take(26, ResidentialSiteTable.FieldByName..}


        If (Take(26, CommercialSiteTable.FieldByName('SwisSBLKey').Text) = Take(26, SwisSBLKey))
          then ParcelHasCommercialInventory := True
          else
            begin
              ParcelHasCommercialInventory := False;

                {FXX10242002-1: Make sure that the commercial bldg does
                                not point to the wrong data if no inv for
                                this parcel.}

              CommercialBldgDataSource.DataSet := nil;
            end;

          {Now open the commercial and residential site tables to
           see if this parcel has residential or commercial inv.}

        If ParcelHasResidentialInventory
          then
            begin
                {Open the residential bldg, land and improvement tables.
                 They will automatically show the correct information for
                 this site since the tables are linked by master\detail.}

              ResidentialBldgTable := FindTableInDataModuleForProcessingType(DataModuleResidentialBuildingTableName,
                                                                             ProcessingType);
              LandTable := FindTableInDataModuleForProcessingType(DataModuleResidentialLandTableName,
                                                                  ProcessingType);
              ImprovementsTable := FindTableInDataModuleForProcessingType(DataModuleResidentialImprovementTableName,
                                                                          ProcessingType);

              LandDataSource.DataSet := LandTable;
              ImprovementsDataSource.DataSet := ImprovementsTable;
              ResidentialBldgDataSource.DataSet := ResidentialBldgTable;

              Site := ResidentialSiteTable.FieldByName('Site').Text;

              SetRangeOld(ResidentialBldgTable,
                          ['TaxRollYr', 'SwisSBLKey', 'Site'],
                          [TaxRollYr, SwisSBLKey, Site],
                          [TaxRollYr, SwisSBLKey, Site]);

              SetRangeOld(LandTable,
                          ['TaxRollYr', 'SwisSBLKey', 'Site', 'LandNumber'],
                          [TaxRollYr, SwisSBLKey, Site, '0'],
                          [TaxRollYr, SwisSBLKey, Site, '32000']);

              SetRangeOld(ImprovementsTable,
                          ['TaxRollYr', 'SwisSBLKey', 'Site', 'ImprovementNumber'],
                          [TaxRollYr, SwisSBLKey, Site, '0'],
                          [TaxRollYr, SwisSBLKey, Site, '32000']);

              TFloatField(LandTable.FieldByName('Acreage')).DisplayFormat := DecimalDisplay;
              TFloatField(LandTable.FieldByName('SquareFootage')).DisplayFormat := '0.';

                {FXX03242001-1: Format the # of bathrooms.}

              TFloatField(ResidentialBldgTable.FieldByName('NumberOfBathrooms')).DisplayFormat := '0.0';

              ResidentialBldgTable.Refresh;
              LandTable.Refresh;
              ImprovementsTable.Refresh;


            end
          else
            If ParcelHasCommercialInventory
              then
                begin
                    {Show the commercial inventory.}

                  ResidentialSiteGrid.Visible := False;
                  ResidentialBldgGrid.Visible := False;

                  CommercialSiteGrid.Visible := True;
                  CommercialBldgGrid.Visible := True;

                  CommercialSiteGrid.Left := 3;
                  CommercialBldgGrid.Left := 3;
                  CommercialSiteGrid.Top := 14;
                  CommercialBldgGrid.Top := 14;

                    {Now open the commercial bldg, land, and improvement tables.}

                  LandTable := FindTableInDataModuleForProcessingType(DataModuleCommercialLandTableName,
                                                                      ProcessingType);
                  ImprovementsTable := FindTableInDataModuleForProcessingType(DataModuleCommercialImprovementTableName,
                                                                              ProcessingType);
                  CommercialBldgTable := FindTableInDataModuleForProcessingType(DataModuleCommercialBuildingTableName,
                                                                                ProcessingType);
                  LandDataSource.DataSet := LandTable;
                  ImprovementsDataSource.DataSet := ImprovementsTable;
                  CommercialBldgDataSource.DataSet := CommercialBldgTable;

                  Site := CommercialSiteTable.FieldByName('Site').Text;

                  SetRangeOld(CommercialBldgTable,
                              ['TaxRollYr', 'SwisSBLKey', 'Site', 'BuildingNumber', 'BuildingSection'],
                              [TaxRollYr, SwisSBLKey, Site, '0', '0'],
                              [TaxRollYr, SwisSBLKey, Site, '32000', '32000']);

                  SetRangeOld(LandTable,
                              ['TaxRollYr', 'SwisSBLKey', 'Site', 'LandNumber'],
                              [TaxRollYr, SwisSBLKey, Site, '0'],
                              [TaxRollYr, SwisSBLKey, Site, '32000']);

                  SetRangeOld(ImprovementsTable,
                              ['TaxRollYr', 'SwisSBLKey', 'Site', 'ImprovementNumber'],
                              [TaxRollYr, SwisSBLKey, Site, '0'],
                              [TaxRollYr, SwisSBLKey, Site, '32000']);

                  TFloatField(LandTable.FieldByName('Acreage')).DisplayFormat := DecimalDisplay;
                  TFloatField(LandTable.FieldByName('SquareFootage')).DisplayFormat := '0.';

                    {FXX09071999-5: Comm bldg floor area displaying $.}

                  TFloatField(CommercialBldgTable.FieldByName('GrossFloorArea')).DisplayFormat := NoDecimalDisplay;

                  CommercialBldgTable.Refresh;
                  LandTable.Refresh;
                  ImprovementsTable.Refresh;

                end;  {If ParcelHasCommercialInventory}

        PrevHeight := Height;
        PrevWidth := Width;

          {CHG01071999-1: Add village label.}

        try
          FindKeyOld(SwisCodeTable, ['SwisCode'],
                     [ParcelTable.FieldByName('SwisCode').Text]);
        except
          SystemSupport(001, SwisCodeTable, 'Error getting swis code record.',
                        UnitName, GlblErrorDlgBox);
        end;

        SwisCodeLabel.Caption := SwisCodeTable.FieldByName('MunicipalityName').Text;

          {FXX11291999-3: Add the ownership code to the property class.}

        with ParcelTable do
          PropertyClassEdit.Text := FieldByName('PropertyClassCode').Text +
                                    FieldByName('OwnershipCode').Text;

        If GlblLocateByOldParcelID
          then SetOldParcelIDLabel(OldParcelIDLabel, ParcelTable,
                                   AssessmentYearControlTable);

          {CHG05312002-1: Allow them to not show the full market value.}

        If ((not GlblShowFullMarketValue) or
            (GlblUserIsSearcher and
             (not GlblSearcherCanSeeFullMarketValue)))
          then
            begin
              EditFullMarketVal.Visible := False;
              FullMarketValueLabel.Visible := False;
            end;

          {CHG10112004-1(2.8.0.14): Option to show the uniform % (or RAR) instead of the STAR amount.}

        If GlblShowUniformPercentInsteadOfSTARAmountOnSummaryScreen
          then
            begin
              STARAmountOrUniformPercentLabel.Hint := '';
              STARAmountOrUniformPercentEdit.Hint := '';

              If (ProcessingType = History)
              then
                with SwisCodeTable do
                begin
                  Filtered := False;
                  Filter := 'TaxRollYr = ' + FormatFilterString(glblHistYear);
                  Filtered := True;
                end;

              with ParcelTable do
                TempPercent := GetUniformPercentOrRAR(SwisCodeTable,
                                                      FieldByName('PropertyClassCode').Text,
                                                      FieldByName('OwnershipCode').Text,
                                                      False, IsUniformPercent);

              If IsUniformPercent
                then STARAmountOrUniformPercentLabel.Caption := 'Unif %:'
                else STARAmountOrUniformPercentLabel.Caption := 'RAR:';

              STARAmountOrUniformPercentEdit.Text := FormatFloat(DecimalEditDisplay, TempPercent);

              SwisCodeTable.Filtered := False;

            end;  {If GlblShowUniformPercentInsteadOfSTARAmountOnSummaryScreen}

          {CHG11192004-6(2.8.1.0)[1940]: If using control # instead of book \ page, display it.}

        with PASDataModule.SalesTable do
        begin
          If GlblUseControlNumInsteadOfBook_Page
            then
              begin
                FieldByName('DeedBook').Visible := False;
                FieldByName('DeedPage').Visible := False;
              end
            else FieldByName('ControlNo').Visible := False;

            {CHG06042010-1[I7589](2.25.1.4): Add option to show new owner under sales summary screen.}

          If glblShowNewOwnerOnSummaryTab
          then FieldByName('OldOwnerName').Visible := False
          else FieldByName('NewOwnerName').Visible := False;

        end;  {with PASDataModule.SalesTable do}

        If glblDisplaySchoolShortCodeInSummary
        then
        begin
          _Locate(tbSchool, [ParcelTable.FieldByName('SchoolCode').AsString], '', []);
          EditSchoolCode.DataSource := dsSchool;
          EditSchoolCode.DataField := 'SchoolShortCode';
        end;

      end;  {If (Deblank(SwisSBLKey) <> '')}

    {CHG11162004-7(2.8.0.21): Option to make the close button locate.}

  If GlblCloseButtonIsLocate
    then MakeCloseButtonLocate(CloseButton);

end;  {InitializeForm}

{==============================================================}
Procedure TParcelSummaryForm.ExemptionTableCalcFields(DataSet: TDataSet);

{FXX01082003-1: Put the exemption table on the form so that we can suppress the
                exemption percent on veterans.}
{FXX06062008-1(2.13.1.9)[I3342]: The event handler was disconnected.}

begin
  If not bInitializingForm
    then
      with DataSet do
        If ((Roundoff(FieldByName('Percent').AsFloat, 2) = 0) or
            ExemptionIsCalculatedAlternativeVeteran(FieldByName('ExemptionCode').Text))
          then FieldByName('DisplayedPercent').Text := ''
          else FieldByName('DisplayedPercent').Text := FieldByName('Percent').Text;

end;  {ExemptionTableCalcFields}

{==============================================================}
Procedure TParcelSummaryForm.SpecialDistrictTableCalcFields(DataSet: TDataset);

{FXX10121998-1: Show pro-rata amounts with decimals.  All other amounts should have
                no zeroes.}

var
  Format : String;
  TempNum : Extended;

begin
 SpecialDistrictTable.FieldByName('Amount').AsFloat := SpecialDistrictTable.FieldByName('CalcAmount').AsFloat;

  TempNum := SpecialDistrictTable.FieldByName('Amount').AsFloat;

  If (Roundoff(TempNum, 0) = Roundoff(TempNum, 2))
    then Format := CurrencyNormalDisplay_BlankZero
    else Format := CurrencyDecimalDisplay_BlankZero;

  TFloatField(SpecialDistrictTable.FieldByName('Amount')).DisplayFormat := Format;

end;  {SpecialDistrictTableCalcFields}

{==============================================================}
Procedure TParcelSummaryForm.HistoryButtonClick(Sender: TObject);

{FXX10041999-9: Add a history summary screen.}

begin
  HistorySummaryForm.InitializeForm(SwisSBLKey);
  HistorySummaryForm.ShowModal;

(*  try
    EnhancedHistoryForm := TEnhancedHistoryForm.Create(nil);

    with EnhancedHistoryForm do
      begin
        InitializeForm(SwisSBLKey);
        ShowModal;
      end;

  finally
    EnhancedHistoryForm.Free;
  end;*)

    {FXX03152001-1: Was not refreshing screen after viewing history.}
  InitializeForm;

end;  {HistoryButtonClick}

{==============================================================}
Procedure TParcelSummaryForm.CloseButtonClick(Sender: TObject);

{Note that the close button is a close for the whole
 parcel maintenance.}

{To close the whole parcel maintenance, we will once again use
 the base popup menu. We will simulate a click on the
 "Exit Parcel Maintenance" of the BasePopupMenu which will
 then call the Close of ParcelTabForm. See the locate button
 click above for more information on how this works.}

var
  I : Integer;

begin
    {Search for the name of the menu item that has "Exit"
     in it, and click it.}

  For I := 0 to (PopupMenu.Items.Count - 1) do
    If (Pos('Exit', PopupMenu.Items[I].Name) <> 0)
      then PopupMenu.Items[I].Click;

end;  {CloseButtonClick}

{====================================================================}
Procedure TParcelSummaryForm.FormCloseQuery(    Sender: TObject;
                                            var CanClose: Boolean);

begin
  CanClose := True;
end;  {FormCloseQuery}

{====================================================================}
Procedure TParcelSummaryForm.FormClose(    Sender: TObject;
                                    var Action: TCloseAction);

begin
    {Close all tables here.}

  CloseTablesForForm(Self);

  Action := caFree;

end;  {FormClose}

{============================================================}
Procedure TParcelSummaryForm.FormResize(Sender: TObject);

(*var
  WidthRatio, HeightRatio : Double;
  AdditionalHeight, OrigHeight, OrigWidth : Integer;*)

begin
(*  If ((PrevHeight > 0) and
      ((Width <> PrevWidth) or
       (Height <> PrevHeight)))
    then
      begin
        WidthRatio := Width/PrevWidth;
        HeightRatio := Height/PrevHeight;

        with ParcelGroupBox do
          begin
            OrigHeight := Height;
            OrigWidth := Width;
            Height := Trunc(Height * HeightRatio);
            Width := Trunc(Width * WidthRatio);
          end;  {with ParcelGroupBox do}

        Bevel1.Top := ParcelGroupBox.Top + ParcelGroupBox.Height;
        Bevel1.Width := Width - 4;

        Bevel2.Left := ParcelGroupBox.Left + ParcelGroupBox.Width + 2;
        Bevel2.Height := Bevel1.Top - 1;

        AdditionalHeight := (ParcelGroupBox.Height - OrigHeight) DIV 3;
        SalesGroupBox.Left := Bevel2.Left + 3;
        SalesGroupBox.Width := Width - SalesGroupBox.Left - 6;
        SalesGroupBox.Height := SalesGroupBox.Height + AdditionalHeight;

        ExemptionGroupBox.Left := Bevel2.Left + 3;
        ExemptionGroupBox.Top := SalesGroupBox.Top + SalesGroupBox.Height;
        ExemptionGroupBox.Width := Width - ExemptionGroupBox.Left - 6;
        ExemptionGroupBox.Height := ExemptionGroupBox.Height + AdditionalHeight;

        SpecialDistrictGroupBox.Left := Bevel2.Left + 3;
        SpecialDistrictGroupBox.Top := ExemptionGroupBox.Top + ExemptionGroupBox.Height;
        SpecialDistrictGroupBox.Width := Width - SpecialDistrictGroupBox.Left - 6;
        SpecialDistrictGroupBox.Height := SpecialDistrictGroupBox.Height + AdditionalHeight;

        SiteGroupBox.Top := Bevel1.Top + 5;
        SiteGroupBox.Width := Trunc(SiteGroupBox.Width * WidthRatio);
        SiteGroupBox.Height := Trunc(SiteGroupBox.Height * HeightRatio);

        BuildingGroupBox.Top := SiteGroupBox.Top + SiteGroupBox.Top;
        BuildingGroupBox.Width := Trunc(BuildingGroupBox.Width * WidthRatio);
        BuildingGroupBox.Height := SiteGroupBox.Height;

      end;  {If ((Width <> PrevWidth) or ...} *)

end;


end.