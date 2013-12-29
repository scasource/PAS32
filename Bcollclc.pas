unit Bcollclc;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, DBCtrls, DBTables, DB, Buttons, Grids,
  Wwdbigrd, Wwdbgrid, ExtCtrls, Wwtable, Wwdatsrc, Menus,PasTypes,types,
  wwdblook, Mask, TabNotBk, Prog,
  GlblVars, WinUtils, Utilitys,GlblCnst,PASUTILS, UTILEXSD,  UtilBill,
  ComCtrls(*, Progress*);

type
  TBillCalcForm = class(TForm)
    BillCtlDataSource: TwwDataSource;
    Panel1: TPanel;
    Panel2: TPanel;
    ScrollBox1: TScrollBox;
    TitleLabel: TLabel;
    BillCollTypeLookupTable: TwwTable;
    SwisCodeTable: TwwTable;
    SchoolCodeTable: TwwTable;
    ExCodeTable: TwwTable;
    TYParcelTable: TwwTable;
    AssessmentTable: TwwTable;
    ParcelExemptionTable: TwwTable;
    ParcelSDTable: TwwTable;
    Label5: TLabel;
    CollectionControlTable: TwwTable;
    SDCodeTable: TwwTable;
    ClassTable: TTable;
    BLExemptionTaxTable: TTable;
    BLSpecialDistrictTaxTable: TTable;
    BLGeneralTaxTable: TTable;
    BLHeaderTaxTable: TTable;
    BLSpecialFeeTaxTable: TTable;
    BillCollTypeLookupTableMainCode: TStringField;
    BillCollTypeLookupTableDescription: TStringField;
    NYParcelTable: TwwTable;
    GeneralTotalTable: TwwTable;
    SchoolTotalTable: TTable;
    EXTotalTable: TTable;
    SDTotalTable: TTable;
    SpecialFeeTotalTable: TTable;
    AssessmentYearCtlTable: TTable;
    BankCodeAuditDataSource: TwwDataSource;
    BankCodeAuditTable: TwwTable;
    PageControl1: TPageControl;
    OptionsTabSheet: TTabSheet;
    PreviouslyImportedBankCodesTabSheet: TTabSheet;
    BankCodeAuditGrid: TwwDBGrid;
    BillNumbersAreAccountNumbersCheckBox: TCheckBox;
    NYLegalAddressCheckBox: TCheckBox;
    IncludeStateLandsCheckBox: TCheckBox;
    Panel3: TPanel;
    Label18: TLabel;
    EditTaxRollYear: TEdit;
    Label1: TLabel;
    LookupCollectionType: TwwDBLookupCombo;
    label16: TLabel;
    EditCollectionNumber: TEdit;
    Panel4: TPanel;
    StartButton: TBitBtn;
    CloseButton: TBitBtn;
    IncludeWhollyExemptCheckBox: TCheckBox;
    cb_OnlyCreateBillsForPositiveAmounts: TCheckBox;
    cbxBillZeroSDRates: TCheckBox;
    cbxWarnAboutBillsWithoutSpecialDistricts: TCheckBox;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CloseButtonClick(Sender: TObject);
    procedure StartButtonClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);

  private
    { Private declarations }
  public
    CalculationCancelled : Boolean;
    CalcMessageFile : TextFile;

    { Public declarations }
    UnitName : String;
    CollectionType : String;  {(MU)nicipal, {SC)hool, or (VI)llage}
    TaxRollYr : String;  {What tax roll year should we use for this collection?}
    ProcessingType : Integer;
    UseArrearsFlag : Boolean;
    RS9BankCode : String;
    BillNumbersAreAccountNumbers : Boolean;
    GetLegalAddressFromNextYear, bWarnAboutBillsWithoutSpecialDistricts : Boolean;
    IncludeStateLands, bBillZeroSDRates,
    IncludeWhollyExempt, OnlyBillPositiveAmounts : Boolean;

    Procedure InitializeForm;  {Open the tables and setup.}

    Procedure SaveGenTaxTotals(LandAssessedVal,
                               TotalAssessedVal,
                               ExemptionAmount : Comp;
                               _HomesteadCode : String;
                               CollectionType : String;
                               BasicSTARAmount,
                               EnhancedSTARAmount : Comp;
                               BasicSTARSavings,
                               EnhancedSTARSavings : Double;
                               ClassRecordFound : Boolean;
                               ApplySTAR : Boolean;
                               GeneralTotList : TList);
    {Save one general tax total for this parcel.}

    Function SaveThisSD(ParcelTable : TTable;
                        SDCode : String;
                        SDRateList : TList) : Boolean;
    {If this is a roll section 9, only save special districts with the
     roll section 9 flag turned on.}
    {FXX04291998-9: Don't store records for special districts where all extensions
                    are zero.}

    Procedure SaveSchTaxTotals(LandAssessedVal,
                               TotalAssessedVal,
                               ExemptionAmount : Comp;
                               _HomesteadCode : String;
                               CollectionType : String;
                               BasicSTARAmount,
                               EnhancedSTARAmount : Comp;
                               BasicSTARSavings,
                               EnhancedSTARSavings : Double;
                               ClassRecordFound : Boolean;
                               SchoolTotList : TList);
    {Save one school tax total.}

    Function ConvertSDValue(     ExtCode : String;
                                 SDValue : String;
                                 ExtCatList : Tlist;
                             var ExtensionCategory : String) : Double;
    {convert the spcl dist string list value to numeric depending on }
    {spcl dist type, with appropriate decimal points, eg all types but}
    {advalorum get 2 decimal points, eg acreage, fixed, unitary}


    Function CalcSDTax(SDCode : String;
                       HomesteadCode : String;
                       ExtCode: String;
                       CmFlg  : String;
                       SDValue : Extended;
                       SDRateList : TList;
                       SDExtCategory : String) : Extended;
    {get correct rate record for this sd and calc tax}

    Procedure GetSDValues(    SDExtCategory : String;
                              HomesteadCode : String;
                              HstdAssessedVal,
                              NonhstdAssessedVal : Comp;
                              TaxableVal : Double;
                          var ExemptionAmount : Comp;
                          var ADValorumAmount,
                              ValueAmount,
                              TotalTaxAmount : Extended);
    {Given the extension category, figure out the advalorum amount or value amount,
     exemption amount and total tax for this special district.}

    Procedure SaveSDistTaxTotals(ExtCode : String;
                                 TaxableValAmount : Double;
                                 _HomesteadCode : String;
                                 SDExtCategory: String;
                                 HstdAssessedVal,
                                 NonhstdAssessedVal : Comp;
                                 SDTotList : TList);

    {Save the special district totals for this extension.}

    Procedure SaveEXTaxTotals(ExemptionCodes,
                              ExemptionHomesteadCodes,
                              CountyExemptionAmounts,
                              TownExemptionAmounts,
                              SchoolExemptionAmounts,
                              VillageExemptionAmounts : TStringList;
                              ClassRecordFound : Boolean;
                              EXTotList : TList);
    {Save the exemption totals for this parcel.}

    Procedure SaveSPFeeTaxTotals(_PrintOrder : Integer;
                                 TaxAmount : Extended;
                                 _AmountInFirstPayment : Boolean;
                                 SpecialFeeTotList : TList);
    {Save one special fee total.}

    Function ParcelToBeBilled(    CollectionType : String;
                                  BillControlDetailList,
                                  SDRateList : TList;
                                  SwisSBLKey : String;
                              var NumInactive : Integer) : Boolean;
    {Check to see if this parcel should get a bill or not. The criteria are:
       1. The parcel must be active.
       2. If this is a municipal or village collection,
          the parcel must be in the swis codes that they specified.
       3. If this is a school collection, the parcel must be in the
          school and swis codes that they specified.}

    Function CalculateGeneralTax(GeneralRateRec : GeneralRateRecord;
                                 HomesteadCode : String;
                                 TaxableVal : Comp) : Extended;
    {FXX05111998-2: In order to figure out the STAR tax savings, need to calculate
                    the tax 2 times - once with STAR and once without. So, we needed
                    to make the tax calculation of an individual line a seperate
                    proc.}

    Function CalculateSTARSavingsAmount(GeneralRateRec : GeneralRateRecord;
                                        sHomesteadCode : String;
                                        iExemptionAmount : Comp;
                                        iSTARCap : Double;
                                        iNonHstdSTARCap : Double) : Double;


    Procedure InsertGeneralTaxRecord(    GeneralRateRec : GeneralRateRecord;
                                         HomesteadCode : String;
                                         EXTotArray : ExemptionTotalsArrayType;
                                         LandAssessedVal,
                                         TotalAssessedVal : Comp;
                                     var TaxableVal,
                                         TaxAmount,
                                         STARSavings : Extended;
                                     var BasicSTARSavings,
                                         EnhancedSTARSavings : Double;
                                         GeneralTotalsList,
                                         SchoolTotalsList : TList;
                                         ClassRecordFound : Boolean;
                                         CollectionType : String;
                                         BasicSTARAmount,
                                         EnhancedSTARAmount : Comp;
                                         bSplitParcel : Boolean;
                                     var FirstTaxLineForParcel,
                                         Quit : Boolean);
    {Insert one general tax record for this parcel.}

   Procedure DivideTaxAmountIntoPayments(SpecialFeeList,
                                         SpecialFeeRateList : TList;
                                         TotalGeneralTax,
                                         TotalSDMoveTax,
                                         TotalSDOtherTax : Double);
   {Divide up the special fees, special districts and general taxes according
    to the distribution options that they have selected.}

    Procedure CalcBillThisParcel(     CollectionType : String;
                                      GeneralRateList,
                                      SDRateList,
                                      SpecialFeeRateList,
                                      SDExtCategoryList,
                                      BillControlDetailList,
                                      GeneralTotalsList,
                                      SDTotalsList,
                                      SchoolTotalsList,
                                      EXTotalsList,
                                      SpecialFeeTotalsList : TList;
                                  var Quit : Boolean);
    {Calculate the bill for one parcel and store the totals in the totals lists.}

    Procedure NumberBills(    CtlDtlList : TList;
                              CollectionType : String;
                          var Quit,
                              CalculationCancelled : Boolean);
    {Go back through the bills and number them in the order that they
     want them numbered.}

    Procedure CalculateBills(    CollectionType : String;
                                 GeneralRateList,
                                 SDRateList,
                                 SpecialFeeRateList,
                                 SDExtCategoryList,
                                 BillControlDetailList,
                                 GeneralTotalsList,
                                 SDTotalsList,
                                 SchoolTotalsList,
                                 EXTotalsList,
                                 SpecialFeeTotalsList : TList;
                             var NumBillsCalculated : LongInt;
                             var NumInactive : Integer;
                             var Quit : Boolean);
    {Calculate all the bills.}

    Procedure SaveBillingTotals(    TaxRollYear : String;
                                    CollectionType : String;
                                    CollectionNum : Integer;
                                    GeneralTotalsList,
                                    SDTotalsList,
                                    SchoolTotalsList,
                                    EXTotalsList,
                                    SpecialFeeTotalsList : TList;
                                var Quit : Boolean);
    {Save the billing totals in the totals files}

  end;


implementation

const
  ApplySDAmountsEqually = 0;  {Split all SD amounts between all payments.}
  ApplyMoveTaxToFirstPayment = 1;  {Apply the move tax to the 1st payment,
                                    split the rest of the SD amount equally
                                    between all payments.}
  ApplySDAmountToFirstPayment = 2; {Apply the whole SD amount to the 1st payment.}

  TrialRun = False;

var
  CollectionHasSchoolTax : Boolean;

{$R *.DFM}

{========================================================}
Procedure TBillCalcForm.FormActivate(Sender: TObject);

begin
  SetFormStateMaximized(Self);
end;

{========================================================}
Procedure TBillCalcForm.InitializeForm;

var
  Quit : Boolean;

begin
  UnitName := 'BCOLLCLC.PAS';  {mmm}

    {FXX06231998-3: Put in changes to allow for Westchester billing off NY.}

  TaxRollYr := DetermineBillingTaxYear;
  ProcessingType := GetProcessingTypeForTaxRollYear(TaxRollYr);

          {Note that the billing tax and totals files do not get opened below.
           They get opened once the person fills in the collection type and
           number.}

  OpenTablesForForm(Self, ProcessingType);

  OpenTableForProcessingType(NYParcelTable, ParcelTableName, NextYear, Quit);

    {CHG06292003-1(2.07e): Keep track of when bank codes are imported.}
    {FXX05202004-1(2.08): Make sure that it does not cause a problem to not have the bank code audit file.}

  with BankCodeAuditTable do
    try
      TableName := 'AuditBankCodeDisks';
      Open;
    except
      PreviouslyImportedBankCodesTabSheet.TabVisible := False;
    end;

  EditTaxRollYear.Text := TaxRollYr;

  try
    TTimeField(BankCodeAuditTable.FieldByName('TimeImported')).DisplayFormat := TimeFormat;
  except
  end;
  
end;  {InitializeForm}

{===================================================================}
Function GetEXIdx(GeneralTaxType : String) : Integer;

{Given the type of tax, return the index into the exemption amounts array which
 returns that amount. That is, if this is a town tax, return the index of
 the town exemption amount in the exemption array.}

begin
  Result := -1;

  If (Trim(GeneralTaxType) = 'CO')
    then GetEXIdx := EXCounty;

  If (Trim(GeneralTaxType) = 'TO')
    then GetEXIdx := EXTown;

  If (Trim(GeneralTaxType) = 'VI')
    then GetEXIdx := EXVillage;

  If (Trim(GeneralTaxType) = 'SC')
    then GetEXIdx := EXSchool;

end;  {GetEXIdx}

{===================================================================}
Function FoundGeneralEntry(    SwisCode : String;
                               SchoolCode : String;
                               RollSection : String;
                               HomesteadCode : String;
                               PrintOrder : Integer;
                               GNTotList : Tlist;
                           var TLIdx : Integer) : Boolean;

{Look through the general totals list for this particular general tax.}

Var
   Found : Boolean;
   I : Integer;
begin
TLIdx := -1;
Found := False;
For I := 0 to (GNTotList.Count - 1)
    do if  (Take(6,SwisCode) = GeneralTotPtr(GnTotList[I])^.SwisCode )
                             AND
           (Take(6,SchoolCode) = GeneralTotPtr(GnTotList[I])^.SchoolCode )
                             AND
           (Take(1,RollSection) = GeneralTotPtr(GnTotList[I])^.RollSection )
                             AND
           (Take(1,HomesteadCode) = GeneralTotPtr(GnTotList[I])^.HomesteadCode )
                             AND
           (PrintOrder = GeneralTotPtr(GnTotList[I])^.PrintOrder )
           then
           begin
           TlIdx := I;
           Found := True;
           end;
FoundGeneralEntry := Found;

end;  {FoundGeneralEntry}

{===================================================================}
Procedure TBillCalcForm.SaveGenTaxTotals(LandAssessedVal,
                                         TotalAssessedVal,
                                         ExemptionAmount : Comp;
                                         _HomesteadCode : String;
                                         CollectionType : String;
                                         BasicSTARAmount,
                                         EnhancedSTARAmount : Comp;
                                         BasicSTARSavings,
                                         EnhancedSTARSavings : Double;
                                         ClassRecordFound : Boolean;
                                         ApplySTAR : Boolean;
                                         GeneralTotList : TList);

{Save one general tax total for this parcel.}

var
  TLIdx : Integer;
  GnTotPtr : GeneralTotPtr;
  _SchoolCode : String;
  TempSTARAmount : Comp;

begin
     {We will only fill in the school code if this is a school
      collection for this totals type. This way, we don't end up
      with totals records broken down by swis and school for
      municipal or village collections.}

  If CollectionHasSchoolTax
    then _SchoolCode := BLHeaderTaxTable.FieldByName('SchoolDistCode').Text
    else _SchoolCode := Take(6, '');

  If FoundGeneralEntry(BLHeaderTaxTable.FieldByName('SwisCode').Text,
                       _SchoolCode,
                       BLHeaderTaxTable.FieldByName('RollSection').Text,
                       _HomesteadCode,
                       BLGeneralTaxTable.FieldByName('PrintOrder').ASInteger,
                       GeneralTotList, TLIdx)
    then
      with GeneralTotPtr(GeneralTotList[TLIdx])^ do
        begin
             {item exists so add to totals}

          ParcelCt := ParcelCt + 1;
          LandAV := LandAV + LandAssessedVal;
          TotalAV := TotalAV + TotalAssessedVal;
          TotalTax := TotalTax + BLGeneralTaxTable.FieldByName('TaxAmount').AsFloat;

            {FXX01061998-5: Track split count.}

          If ClassRecordFound
            then PartCt := PartCt + 1;

            {FXX05061998-3: Save the STAR amounts for school billings.}

          If CollectionHasSchoolTax
            then
              begin
                  {FXX08171999-2: Make sure there are no STAR amounts if there is
                                  no STAR applies.}

                If ApplySTAR
                  then TempSTARAmount := BasicSTARAmount + EnhancedSTARAmount
                  else TempSTARAmount := 0;

                STARAmount := STARAmount + TempSTARAmount;

                  {FXX05141998-5: Don't subtract the variable STARAmount since
                                  it is a total of STAR so far.}

                ExemptAmt := ExemptAmt + ExemptionAmount - TempSTARAmount;

                  {FXX05141998-4: Need to subtract ExemptionAmount - STARAmount
                                  rather than
                                  ExemptionAmount because ExemptionAmount includes
                                  STAR and we want to get TV before STAR.}

                TaxableVal := TaxableVal + TotalAssessedVal - ExemptionAmount;

                  {FXX05141998-3: Should be subtracting, not adding exemption
                                  amt. since taking from orig AV.}

                TaxableValAfterSTAR := TaxableValAfterSTAR +
                                       (TotalAssessedVal -
                                        ExemptionAmount);

                 {FXX05141998-6: Save total STARSavings amount.}

                STARSavings := STARSavings +
                               BLGeneralTaxTable.FieldByName('STARSavings').AsFloat;
                BasicSTARSavings := BasicSTARSavings +
                                    BLGeneralTaxTable.FieldByName('BasicSTARSavings').AsFloat;
                EnhancedSTARSavings := EnhancedSTARSavings +
                                       BLGeneralTaxTable.FieldByName('EnhancedSTARSavings').AsFloat;
              end
           else
             begin
               ExemptAmt := ExemptAmt + ExemptionAmount;
               TaxableVal := TaxableVal + TotalAssessedVal - ExemptionAmount;
             end;  {If CollectionHasSchoolTax}

        end
    else
      begin
        New(GnTotPtr);

        with GnTotPtr^ do
          begin
            SwisCode := BLHeaderTaxTable.FieldByName('SwisCode').Text;
            SchoolCode := _SchoolCode;
            RollSection := BLHeaderTaxTable.FieldByName('RollSection').Text;
            HomesteadCode := _HomesteadCode;
            PrintOrder := BLGeneralTaxTable.FieldByName('PrintOrder').AsInteger;
            ParcelCt := 1;
            LandAV := LandAssessedVal;
            TotalAV := TotalAssessedVal;

            TotalTax := BLGeneralTaxTable.FieldByName('TaxAmount').AsFloat;

              {FXX01061998-5: Track split count.}

            If ClassRecordFound
              then PartCt := 1
              else PartCt := 0;

              {FXX05061998-3: Save the STAR amounts for school billings as
                              seperate.}

            If CollectionHasSchoolTax
              then
                begin
                    {FXX08171999-2: Make sure there are no STAR amounts if there is
                                    no STAR applies.}

                  If ApplySTAR
                    then TempSTARAmount := BasicSTARAmount + EnhancedSTARAmount
                    else TempSTARAmount := 0;

                  STARAmount := TempSTARAmount;
                  ExemptAmt := ExemptionAmount - STARAmount;

                    {FXX05141998-4: Need to subtract ExemptAmt above rather than
                                    ExemptionAmount because ExemptionAmount includes
                                    STAR and we want to get TV before STAR.}

                  TaxableVal := TotalAssessedVal - ExemptionAmount;

                    {FXX08181999-1: Double subtracting STAR amount since it is already
                                    in the exemption amount.}

                  TaxableValAfterSTAR := TotalAssessedVal - ExemptionAmount{ -
                                         STARAmount};

                   {FXX05141998-6: Save total STARSavings amount.}

                  STARSavings := BLGeneralTaxTable.FieldByName('STARSavings').AsFloat;
                  BasicSTARSavings := BLGeneralTaxTable.FieldByName('BasicSTARSavings').AsFloat;
                  EnhancedSTARSavings := BLGeneralTaxTable.FieldByName('EnhancedSTARSavings').AsFloat;

                end
             else
               begin
                 ExemptAmt := ExemptionAmount;
                 TaxableVal := TotalAssessedVal - ExemptionAmount;
                 STARAmount := 0;
                 TaxableValAfterSTAR := 0;

                   {FXX06181998-3: Don't forget to set STAR savings to 0 if not
                                   school collection.}

                 STARSavings := 0;
                 BasicSTARSavings := 0;
                 EnhancedSTARSavings := 0;

               end;  {else of If CollectionHasSchoolTax}

          end;  {with GnTotPtr^ do}

        GeneralTotList.Add(GNTotPtr);

      end;  {else of If FoundGeneralEntry(BLHeaderTaxTable.FieldByName('SwisCode').Text, ...}

end;  {SaveGenTaxTotals}

{===================================================================}
Function FoundSchoolEntry(    SwisCode : String;
                              RollSection : String;
                              HomeSteadCode : String;
                              SchoolCode : String;
                              ScTotList : TList;
                          var TLIdx : Integer) : Boolean;
Var
   Found : Boolean;
   I : Integer;
begin
TLIdx := -1;
Found := False;
For I := 0 to (ScTotList.Count - 1)
    do if  (Take(6,SwisCode) = SchoolTotPtr(ScTotList[I])^.SwisCode )
                             AND
           (Take(1,RollSection) = SchoolTotPtr(ScTotList[I])^.RollSection )
                             AND
           (Take(1,HomeSteadCode) = SchoolTotPtr(ScTotList[I])^.HomesteadCode )
                             AND
           (Take(6,Schoolcode) = SchoolTotPtr(ScTotList[I])^.SchoolCode )
           then
           begin
           TlIdx := I;
           Found := True;
           end;
FoundSchoolEntry := Found;

end;  {FoundSchoolEntry}

{===================================================================}
Procedure TBillCalcForm.SaveSchTaxTotals(LandAssessedVal,
                                         TotalAssessedVal,
                                         ExemptionAmount : Comp;
                                         _HomesteadCode : String;
                                         CollectionType : String;
                                         BasicSTARAmount,
                                         EnhancedSTARAmount : Comp;
                                         BasicSTARSavings,
                                         EnhancedSTARSavings : Double;
                                         ClassRecordFound : Boolean;
                                         SchoolTotList : TList);

{Save one school tax total.}

var
  TLIdx : Integer;
  ScTotPtr : SchoolTotPtr;
  TempSTARAmount : Comp;

begin
  If FoundSchoolEntry(BLHeaderTaxTable.FieldByName('SwisCode').Text,
                      BLHeaderTaxTable.FieldByName('RollSection').Text,
                      _HomesteadCode,
                      BLHeaderTaxTable.FieldByName('SchoolDistCode').Text,
                      SchoolTotList, TLIdx)
    then
      begin
          {item exists so add to totals}
        with SchoolTotPtr(SchoolTotList[TLIdx])^ do
          begin
            ParcelCt := ParcelCt + 1;
            LandAV := LandAV + LandAssessedVal;
            TotalAV := TotalAV + TotalAssessedVal;
            TotalTax := TotalTax +
                        BLGeneralTaxTable.FieldByName('TaxAmount').AsFloat;

              {FXX01061998-5: Track split count.}

            If ClassRecordFound
              then PartCt := PartCt + 1;

              {FXX05061998-3: Save the STAR amounts for school billings as
                              seperate.}

            If CollectionHasSchoolTax
              then
                begin
                  TempSTARAmount := BasicSTARAmount + EnhancedSTARAmount;
                  STARAmount := STARAmount + TempSTARAmount;

                    {FXX05141998-5: Don't subtract the variable STARAmount since
                                    it is a total of STAR so far.}

                  //ExemptAmt := ExemptAmt + ExemptionAmount - TempSTARAmount;
                  ExemptAmt := ExemptAmt + ExemptionAmount;

                    {FXX05141998-4: Need to subtract ExemptionAmount - STARAmount
                                    rather than
                                    ExemptionAmount because ExemptionAmount includes
                                    STAR and we want to get TV before STAR.}

                  (*TaxableVal := TaxableVal + TotalAssessedVal -
                                (ExemptionAmount - TempSTARAmount); *)
                  TaxableVal := TaxableVal + TotalAssessedVal - ExemptionAmount;

                    {FXX05061998-3: Save the STAR amounts for school billings as
                                    seperate.}

                  (*TaxableValAfterSTAR := TaxableValAfterSTAR +
                                         TotalAssessedVal -
                                         ExemptionAmount; *)

                  BasicSTARSavings := BasicSTARSavings +
                                    BLGeneralTaxTable.FieldByName('BasicSTARSavings').AsFloat;
                  EnhancedSTARSavings := EnhancedSTARSavings +
                                       BLGeneralTaxTable.FieldByName('EnhancedSTARSavings').AsFloat;
                end
             else
               begin
                 ExemptAmt := ExemptAmt + ExemptionAmount;
                 TaxableVal := TaxableVal + TotalAssessedVal - ExemptionAmount;
               end;  {else of If CollectionHasSchoolTax}

          end;  {with SchoolTotPtr(SchoolTotList[TLIdx])^ do}

      end
    else
      begin
          {Add a new item.}

        New(ScTotPtr);

        with SCTotPtr^ do
          begin
            SwisCode := BLHeaderTaxTable.FieldByName('SwisCode').Text;
            SchoolCode := BLHeaderTaxTable.FieldByName('SchoolDistCode').Text;
            RollSection := BLHeaderTaxTable.FieldByName('RollSection').Text;
            HomesteadCode := _HomesteadCode;
            ParcelCt := 1;
            LandAV := LandAssessedVal;
            TotalAV := TotalAssessedVal;
            ExemptAmt := ExemptionAmount;
            TaxableVal := TotalAssessedVal - ExemptionAmount;
            TotalTax := BLGeneralTaxTable.FieldByName('TaxAmount').AsFloat;

              {FXX01061998-5: Track split count.}

            If ClassRecordFound
              then PartCt := 1
              else PartCt := 0;

              {FXX05061998-3: Save the STAR amounts for school billings as
                              seperate.}

            If CollectionHasSchoolTax
              then
                begin
                  STARAmount := BasicSTARAmount + EnhancedSTARAmount;
                  //ExemptAmt := ExemptionAmount - STARAmount;
                  ExemptAmt := ExemptionAmount;

                  {FXX05141998-4: Need to subtract ExemptAmt above rather than
                                  ExemptionAmount because ExemptionAmount includes
                                  STAR and we want to get TV before STAR.}

                  TaxableVal := TotalAssessedVal - ExemptAmt;
                  TaxableValAfterSTAR := TotalAssessedVal - ExemptionAmount;
                  BasicSTARSavings := BasicSTARSavings +
                                      BLGeneralTaxTable.FieldByName('BasicSTARSavings').AsFloat;
                  EnhancedSTARSavings := EnhancedSTARSavings +
                                         BLGeneralTaxTable.FieldByName('EnhancedSTARSavings').AsFloat;
                end
             else
               begin
                 ExemptAmt := ExemptionAmount;
                 TaxableVal := TotalAssessedVal - ExemptionAmount;
                 STARAmount := 0;
                 BasicSTARSavings := 0;
                 EnhancedSTARSavings := 0;
                 TaxableValAfterSTAR := 0;

               end;  {else of If CollectionHasSchoolTax}

          end;  {with SCTotPtr do}

        SchoolTotList.Add(ScTotPtr);

      end;  {If FoundScEntry(BLHeaderTaxTable.FieldByName('SwisCode').Text, ...}

end;  {SaveSchTaxTotals}

{===================================================================}
Function TBillCalcForm.ConvertSDValue(     ExtCode : String;
                                           SDValue : String;
                                           ExtCatList : Tlist;
                                       var ExtensionCategory : String) : Double;

{convert the spcl dist string list value to numeric depending on }
{spcl dist type, with appropriate decimal points, eg all types but}
{advalorum get 2 decimal points, eg acreage, fixed, unitary}

var
  TempValue : Double;

begin
  TempValue := 0;
  ExtensionCategory := GetSDExtCategory(ExtCode, ExtCatList);

    {FXX12132004-2(2.8.1.3): Sometimes the SD Value may be blank in which case it should be 0.}

  If _Compare(ExtensionCategory, coNotBlank)
    then
      begin
        If (Trim(SDValue) = '')
          then TempValue := 0
          else
            try
              TempValue := StrToFloat(SDValue);
            except
              TempValue := 0;
            end;

          {FXX03222007(2.11.1.20): Allow for 3 decimals for units.}

        If _Compare(ExtensionCategory, SDistCategoryADVL, coEqual)
          then TempValue := RoundOff(TempValue, 0)
          else
            If _Compare(ExtensionCategory, SdistCategoryUNIT, coEqual)
              then TempValue := RoundOff(TempValue, 3)
              else TempValue := RoundOff(TempValue, 2);

          {FXX04281998-10: Special logic for fixed expenses SDs.
                           In this case, the amount in the parcel SD record is
                           0, but we need to force it to 1 so that when
                           multiplied by the rate, is not 0.}

        If (ExtCode = SDistEcFE)
          then TempValue := 1;

      end;  {If (Trim(ExtensionCategory) <> '')}

  Result := TempValue;

end;  {ConvertSDValue}

{===================================================================}
Function TBillCalcForm.CalcSDTax(SDCode : String;
                                 HomesteadCode : String;
                                 ExtCode: String;
                                 CmFlg  : String;
                                 SDValue : Extended;
                                 SDRateList : TList;
                                 SDExtCategory : String) : Extended;

{get correct rate record for this sd and calc tax}

var
  RteIdx : Integer;
  TempVal, TotTax : Double;

begin
  TotTax := 0;

    {match sd code, ext code and cm flag to get rate record}

  If FoundSDRate(SDRateList, Take(5, SDCode), Take(2, ExtCode),
                 Take(1, CMFlg), RteIdx)
    then
      begin
         {If advalorum, we need to divide by 1000 since the rate is
          per $1000. Otherwise, use the value as is.}

       If _Compare(SdExtCategory, SDistCategoryADVL, coEqual)
         then TempVal := (SDValue/1000)
         else TempVal := SDValue;

         {FXX12221997-3: If there is only one tax rate, it is stored in
                         the hstd rate, so use it.}

       If ((HomesteadCode = HstdCnst) or
           (Deblank(HomesteadCode) = '') or
           (not GlblMunicipalityUsesTwoTaxRates))
          then
            begin
              TotTax := TempVal * SDRatePointer(SDRateList[RteIdx])^.HomeSteadRate;
              TotTax := RoundOff(TotTax,2);
            end
          else
            begin
              TotTax := TempVal * SDRatePointer(SDRateList[RteIdx])^.NonhomeSteadRate;
              TotTax := RoundOff(TotTax,2);
           end;

      end
    else NonBtrvSystemSupport(997, 999,
                              'SD Rate Record Missing, key =' +
                              SDCode + '-' + ExtCode + '-' +CmFlg + '  SBL= ' +
                              ExtractSSKey(TYParcelTable),
                              UnitName, GlblErrorDlgBox);

  CalcSDTax := TotTax;

end;  {CalcSDTax}

{===================================================================}
Function FoundSDEntry(    SwisCode : String;
                          SchoolCode : String;
                          RollSection : String;
                          HomeSteadCode : String;
                          SDCode : String;
                          ExtCode : String;
                          CMFlag : String;
                          SDTotList : Tlist;
                      var TLIdx : Integer) : Boolean;
Var
   Found : Boolean;
   I : Integer;

begin
TLIdx := -1;
Found := False;
For I := 0 to (SdTotList.Count - 1) do
  begin
    if  (Take(6,SwisCode) = Take(6, SDistTotPtr(SdTotList[I])^.SwisCode))
                             AND
           (Take(6,SchoolCode) = Take(6, SDistTotPtr(SdTotList[I])^.SchoolCode))
                             AND
           (Take(1,RollSection) = Take(1, SDistTotPtr(SdTotList[I])^.RollSection))
                             AND
           ((Trim(HomesteadCode) = '') or
            (Trim(HomeSteadCode) = Trim(SDistTotPtr(SdTotList[I])^.HomesteadCode)))
                             AND
           (Take(5,SDCode) = Take(5, SDistTotPtr(SdTotList[I])^.SDCode))
                            AND
           (Take(2,ExtCode) = Take(2, SDistTotPtr(SdTotList[I])^.ExtCode))
                            AND
           (Take(1,CMFlag) = Take(1, SDistTotPtr(SdTotList[I])^.CMFlag))

           then
           begin
           TlIdx := I;
           Found := True;
           end;

    end;

FoundSDEntry := Found;

end;  {FoundSDEntry}

{===================================================================}
Procedure TBillCalcForm.GetSDValues(    SDExtCategory : String;
                                        HomesteadCode : String;
                                        HstdAssessedVal,
                                        NonhstdAssessedVal : Comp;
                                        TaxableVal : Double;
                                    var ExemptionAmount : Comp;
                                    var ADValorumAmount,
                                        ValueAmount,
                                        TotalTaxAmount : Extended);

{Given the extension category, figure out the advalorum amount or value amount,
 exemption amount and total tax for this special district.}
{FXX01142005-2(2.8.2.4)[2046]: The taxable value for unitary SDs was being rounded off.}

begin
  ADValorumAmount := 0;
  ValueAmount := 0;
  ExemptionAmount := 0;
  TotalTaxAmount := 0;

   {get AV value override from SD record if > 0,
    else get it from parcel assesssed value}

  with BLSpecialDistrictTaxTable do
    If _Compare(SdExtCategory, SDistCategoryADVL, coEqual)
      then
        begin
          If (RoundOff(FieldByName('AVAmtUnitDim').AsFloat, 2) > 0)
            then
              begin
                 {FXX12101998-2: For exemptions which only partially exempt a SD,
                                 the ADValorum amount should be full value.}

                (*ADValorumAmount := FieldByName('AVAmtUnitDim').AsFloat;*)

                ADValorumAmount := HstdAssessedVal + NonhstdAssessedVal;

                  {infer exmpt amt from assed val - taxable val}

                ExemptionAmount := (ADValorumAmount - TaxableVal);

              end
            else
              begin
                  {Now, if this is a nonhomestead special district,
                   we will get the nonhomestead assessed value.
                   Otherwise (if it is homestead or blank), we
                   will use the homestead assessed value.}

                If (HomesteadCode = 'N')
                  then
                    begin
                        {Use the nonhomestead value.}

                      ADValorumAmount := NonhstdAssessedVal;

                         {infer exmpt amt from assed val - taxable val}

                      ExemptionAmount := NonhstdAssessedVal - TaxableVal;

                    end
                  else
                    begin
                        {Use the homestead value.}

                      ADValorumAmount := ADValorumAmount + HstdAssessedVal;

                         {infer exmpt amt from assed val - taxable val}

                      ExemptionAmount := HstdAssessedVal - TaxableVal;

                    end;  {else of If (HomesteadCode = 'N')}

              end;  {else of If (RoundOff(FieldByName('AVAmtUnitDim').AsFloat, 2) > 0)}

        end
      else
        begin
             {all non-advalorums go in value field}
          ValueAmount := FieldByName('AVAmtUnitDim').AsFloat;

        end;  {else of If (SDExtCategory = SDistCategoryADVL)}

  TotalTaxAmount := BLSpecialDistrictTaxTable.FieldByName('TaxAmount').AsFloat;

end;  {GetSDValues}

{===================================================================}
Procedure TBillCalcForm.SaveSDistTaxTotals(ExtCode : String;
                                           TaxableValAmount : Double;
                                           _HomesteadCode : String;
                                           SDExtCategory: String;
                                           HstdAssessedVal,
                                           NonhstdAssessedVal : Comp;
                                           SDTotList : TList);

{Save the special district totals for this extension.}

var
  TLIdx : Integer;
  ExemptionAmount : Comp;
  ADValorumAmount, ValueAmount,
  TotalTaxAmount : Extended;
  SDTotPtr : SDistTotPtr;
  _SchoolCode : String;

begin
     {We will only fill in the school code if this is a school
      collection for this totals type. This way, we don't end up
      with totals records broken down by swis and school for
      municipal or village collections.}

  If CollectionHasSchoolTax
    then _SchoolCode := BLHeaderTaxTable.FieldByName('SchoolDistCode').Text
    else _SchoolCode := Take(6, '');

  GetSDValues(SDExtCategory, _HomesteadCode, HstdAssessedVal,
              NonhstdAssessedVal, TaxableValAmount, ExemptionAmount,
              ADValorumAmount, ValueAmount, TotalTaxAmount);

  If FoundSDEntry(BLHeaderTaxTable.FieldByName('SwisCode').Text,
                  _SchoolCode,
                  BLHeaderTaxTable.FieldByName('RollSection').Text,
                  _HomesteadCode,
                  BLSpecialDistrictTaxTable.FieldByName('SDistCode').Text,
                  BLSpecialDistrictTaxTable.FieldByName('ExtCode').Text,
                  BLSpecialDistrictTaxTable.FieldByName('CMFlag').Text,
                  SDTotList, TLIdx)
    then
      begin
          {item exists so add to totals}

        with SDistTotPtr(SDTotList[TLIdx])^ do
          begin
            ParcelCt := ParcelCt + 1;
            Value := Value + ValueAmount;
            ADValue := ADValue + ADValorumAmount;
            ExemptAmt := ExemptAmt + ExemptionAmount;
            TaxableVal := TaxableVal + TaxableValAmount;
            TotalTax := TotalTax + TotalTaxAmount;

          end;  {with SDistTotPtr(SDTotList[TLIdx])^ do}

      end
    else
      begin
        New(SDTotPtr);

          {FXX010151998-4: Don't save the SD homestead code.}

        with SDTotPtr^ do
          begin
            SwisCode := BLHeaderTaxTable.FieldByName('SwisCode').Text;
            SchoolCode := _SchoolCode;
            RollSection := BLHeaderTaxTable.FieldByName('RollSection').Text;
            SDCode := BLSpecialDistrictTaxTable.FieldByName('SDistCode').Text;
            ExtCode := BLSpecialDistrictTaxTable.FieldByName('ExtCode').Text;
            CMFlag := BLSpecialDistrictTaxTable.FieldByName('CMFlag').Text;
            ParcelCt := 1;
            Value := ValueAmount;
            ADValue := ADValorumAmount;
            ExemptAmt := ExemptionAmount;
            TaxableVal := TaxableValAmount;
            TotalTax := TotalTaxAmount;
            HomesteadCode := _HomesteadCode;

          end;  {with SDTotPtr^ do}

        SDTotList.Add(SDTotPtr);

    end;  {If FoundSDEntry(BLHeaderTaxTable.FieldByName('SwisCode').Text, ...}

end;  {SaveSDistTaxTotals}

{===================================================================}
Function FoundEXEntry(    SwisCode : String;
                          SchoolCode : String;
                          RollSection : String;
                          HomeSteadCode : String;
                          ExCode : String;
                          EXTotList : Tlist;
                      var TLIdx : Integer) : Boolean;

var
  Found : Boolean;
  I : Integer;

begin
  TLIdx := -1;
  Found := False;
  For I := 0 to (EXTotList.Count - 1)
      do if  (Take(6,SwisCode) = ExemptTotPtr(EXTotList[I])^.SwisCode )
                               AND
             (Take(6,SchoolCode) = ExemptTotPtr(EXTotList[I])^.SchoolCode )
                               AND
             (Take(1,RollSection) = ExemptTotPtr(EXTotList[I])^.RollSection )
                               AND
             (Take(1,HomeSteadCode) = Take(1, ExemptTotPtr(EXTotList[I])^.HomesteadCode))
                               AND
             (Take(5,EXCode) = ExemptTotPtr(EXTotList[I])^.EXCode )

             then
             begin
             TlIdx := I;
             Found := True;
             end;
  FoundEXEntry := Found;

end;  {FoundEXEntry}

{===================================================================}
Function SaveThisExemption(ExemptionCode : String;
                           CountyExemptionAmount,
                           TownExemptionAmount,
                           SchoolExemptionAmount,
                           VillageExemptionAmount : Comp;
                           CollectionType : String) : Boolean;

{FXX06301998-7: Only print an exemption or save it if it has amounts for
                this roll type.}

var
  Amount1, Amount2, Amount3 : Comp;

begin
  Result := False;
  Amount1 := 0;
  Amount2 := 0;
  Amount3 := 0;

    {FXX06162008-1(2.13.1.12)[I3445]: Include collection type TO.}

  If _Compare(CollectionType, 'TO', coEqual)
    then Amount1 := TownExemptionAmount;

  If _Compare(CollectionType, 'MU', coEqual)
    then
      begin
        Amount1 := CountyExemptionAmount;
        Amount2 := TownExemptionAmount;
        Amount3 := SchoolExemptionAmount;
      end;

  If _Compare(CollectionType, 'CO', coEqual)
    then Amount1 := CountyExemptionAmount;

  If _Compare(CollectionType, 'SC', coEqual)
    then Amount1 := SchoolExemptionAmount;

  If _Compare(CollectionType, 'VI', coEqual)
    then Amount1 := VillageExemptionAmount;

  If (_Compare(Amount1, 0, coGreaterThan) or
      _Compare(Amount2, 0, coGreaterThan) or
      _Compare(Amount3, 0, coGreaterThan))
    then Result := True;

end;  {SaveThisExemption}

{===================================================================}
Procedure TBillCalcForm.SaveEXTaxTotals(ExemptionCodes,
                                        ExemptionHomesteadCodes,
                                        CountyExemptionAmounts,
                                        TownExemptionAmounts,
                                        SchoolExemptionAmounts,
                                        VillageExemptionAmounts : TStringList;
                                        ClassRecordFound : Boolean;
                                        EXTotList : TList);

{Save the exemption totals for this parcel.}

var
  TLIdx, I : Integer;
  EXTotPtr : ExemptTotPtr;
  _SchoolCode : String;

begin
     {We will only fill in the school code if this is a school
      collection for this totals type. This way, we don't end up
      with totals records broken down by swis and school for
      municipal or village collections.}

  If CollectionHasSchoolTax
    then _SchoolCode := BLHeaderTaxTable.FieldByName('SchoolDistCode').Text
    else _SchoolCode := Take(6, '');

  For I := 0 to (ExemptionCodes.Count - 1) do
    begin
        {FXX05301998-2: Don't show the exemption if it is zero for this
                        taxing purpose.}
      If SaveThisExemption(ExemptionCodes[I],
                           StrToFloat(CountyExemptionAmounts[I]),
                           StrToFloat(TownExemptionAmounts[I]),
                           StrToFloat(SchoolExemptionAmounts[I]),
                           StrToFloat(VillageExemptionAmounts[I]),
                           CollectionType)
        then
          with BLHeaderTaxTable do
            If FoundEXEntry(FieldByName('SwisCode').Text,
                            _SchoolCode,
                            FieldByName('RollSection').Text,
                            ExemptionHomesteadCodes[I],
                            ExemptionCodes[I], EXTotList, TLIdx)
              then
                with ExemptTotPtr(EXTotList[TLIdx])^ do
                  begin
                       {Item exists so add to totals}

                    ParcelCt := ParcelCt + 1;
                    CountyExAmt := CountyExAmt + StrToFloat(CountyExemptionAmounts[I]);
                    TownExAmt := TownExAmt + StrToFloat(TownExemptionAmounts[I]);
                    SchoolExAmt := SchoolExAmt + StrToFloat(SchoolExemptionAmounts[I]);
                    VillageExAmt := VillageExAmt + StrToFloat(VillageExemptionAmounts[I]);

                      {FXX01061998-5: Track split count.}

                    If ClassRecordFound
                      then PartCt := PartCt + 1;

                  end
              else
                begin
                    {Add a new item to the list.}

                  New(EXTotPtr);

                  with EXTotPtr^ do
                     begin
                       SwisCode := FieldByName('SwisCode').Text;
                       SchoolCode := _SchoolCode;
                       RollSection := FieldByName('RollSection').Text;
                       HomesteadCode := ExemptionHomesteadCodes[I];
                       EXCode := ExemptionCodes[I];
                       ParcelCt := 1;
                       CountyExAmt := StrToFloat(CountyExemptionAmounts[I]);
                       TownExAmt := StrToFloat(TownExemptionAmounts[I]);
                       SchoolExAmt := StrToFloat(SchoolExemptionAmounts[I]);
                       VillageExAmt := StrToFloat(VillageExemptionAmounts[I]);

                         {FXX01061998-5: Track split count.}

                       If ClassRecordFound
                         then PartCt := 1
                         else PartCt := 0;

                     end;  {with EXTotPtr^. do}

                  EXTotList.add(EXTotPtr);

                end;  {else of If FoundEXEntry(FieldByName('SwisCode').Text, ...}

    end;  {For I := 0 to (ExemptionCodes.Count - 1) do}

end;  {SaveEXTaxTotals}

{===================================================================}
Function FoundSpecialFeeEntry(    SwisCode : String;
                                  SchoolCode : String;
                                  RollSection : String;
                                  PrintOrder : Integer;
                                  SfTotList : Tlist;
                              var TLIdx : Integer) : Boolean;

var
  Found : Boolean;
  I : Integer;

begin
  TLIdx := -1;
  Found := False;
  For I := 0 to (SfTotList.Count - 1)
      do if  (Take(6,SwisCode) = SpFeeTotPtr(SfTotList[I])^.SwisCode )
                               AND
             (Take(6, SchoolCode) = SpFeeTotPtr(SfTotList[I])^.SchoolCode )
                               AND
             (Take(1,RollSection) = SpFeeTotPtr(SfTotList[I])^.RollSection )
                               AND
             (PrintOrder = SpFeeTotPtr(SfTotList[I])^.PrintOrder)
             then
             begin
             TlIdx := I;
             Found := True;
             end;

  FoundSpecialFeeEntry := Found;

end;  {FoundSpecialFeeEntry}

{===================================================================}
Procedure TBillCalcForm.SaveSPFeeTaxTotals(_PrintOrder : Integer;
                                           TaxAmount : Extended;
                                           _AmountInFirstPayment : Boolean;
                                           SpecialFeeTotList : TList);

{Save one special fee total.}

var
  TLIdx : Integer;
  SFTotPtr : SpFeeTotPtr;
  _SchoolCode : String;

begin
     {We will only fill in the school code if this is a school
      collection for this totals type. This way, we don't end up
      with totals records broken down by swis and school for
      municipal or village collections.}

  If CollectionHasSchoolTax
    then _SchoolCode := BLHeaderTaxTable.FieldByName('SchoolDistCode').Text
    else _SchoolCode := Take(6, '');

  If FoundSpecialFeeEntry(BLHeaderTaxTable.FieldByName('SwisCode').Text,
                          _SchoolCode,
                          BLHeaderTaxTable.FieldByName('RollSection').Text,
                          _PrintOrder, SpecialFeeTotList, TLIdx)
    then
      begin
           {item exists so add to totals}

        with SpFeeTotPtr(SpecialFeeTotList[TLIdx])^ do
          begin
            ParcelCt := ParcelCt + 1;
            TotalTax := TotalTax + TaxAmount;
          end;  {with SpFeeTotPtr(SFTotList[TLIdx])^ do}

      end
    else
      begin
          {Add new item.}

        New(SfTotPtr);

        with SFTotPtr^ do
          begin
            SwisCode := BLHeaderTaxTable.FieldByName('SwisCode').Text;
            SchoolCode := _SchoolCode;
            RollSection := BLHeaderTaxTable.FieldByName('RollSection').Text;
            PrintOrder := _PrintOrder;
            ParcelCt := 1;
            TotalTax := TaxAmount;
            AmtInFirstPayment := _AmountInFirstPayment;

          end;  {with SFTotPtr^ do}

        SpecialFeeTotList.Add(SfTotPtr);

      end;  {If FoundSpecialFeeEntry(BLHeaderTaxTable.FieldByName('SwisCode').Text, ...}

end;  {SaveSPFeeTaxTotals}

{===================================================================}
Function TBillCalcForm.ParcelToBeBilled(    CollectionType : String;
                                            BillControlDetailList,
                                            SDRateList : TList;
                                            SwisSBLKey : String;
                                        var NumInactive : Integer) : Boolean;

{Check to see if this parcel should get a bill or not. The criteria are:
   1. The parcel must be active.
   2. If this is a municipal or village collection,
      the parcel must be in the swis codes that they specified.
   3. If this is a school collection, the parcel must be in the
      school and swis codes that they specified.}

var
  I, SchLen, SwLen, RateIndex : Integer;
  TempStr : String;
  Done, FirstTimeThrough, HasPositiveRateSD : Boolean;

begin
  Result := False;

    {Make sure that this is in the correct swis or school code.}
    {FXX12201997-2: We should check swis codes if this is a town billing,
                    too.}

  If ((Take(2, CollectionType) = 'MU') or
      (Take(2, CollectionType) = 'TO') or
      (Take(2, CollectionType) = 'VI'))
    then
      begin
          {Check for a swis match. Be sure to only check as many digits
           as they specified for the swis (2, 4, or 6 numbers).}

        For I := 0 to (BillControlDetailList.Count - 1) do
          with ControlDetailRecordPointer(BillControlDetailList[I])^ do
            begin
              SwLen := Length(Deblank(SwisCode));

              If (Take(SwLen, TYParcelTable.FieldByName('SwisCode').Text) =
                  Take(SwLen, SwisCode))
                then Result := True;

              TempStr := SwisCode;

            end;  {with ControlDetailRecordPointer(BillControlDetailList[I])^ do}

      end
        else
          begin
               {match school & swis by 2 , 4 or 6 numbers}

            For I := 0 to (BillControlDetailList.Count - 1) do
              with ControlDetailRecordPointer(BillControlDetailList[I])^ do
                begin
                  SwLen := Length(Deblank(SwisCode));
                  SchLen := Length(Deblank(SchoolCode));

                    {FXX05091998-2. For a school collection, it is not necessary
                                    to fill in a swis code unless the user is
                                    limiting it to a swis within a school.}
                    {FXX05091998-3: Also, we were comparing the school code to the
                                    swis code.}

                  If (((Deblank(SwisCode) = '') or
                       (Take(SwLen, TYParcelTable.FieldByName('SwisCode').Text) =
                        Take(SwLen, SwisCode))) and
                      (Take(SchLen, TYParcelTable.FieldByName('SchoolCode').Text) =
                       Take(SchLen, SchoolCode)))
                    then Result := True;

                end;  {with ControlDetailRecordPointer(BillControlDetailList[I])^ do}

          end;  {else of If ((Take(2, FieldByName('CollectionType').Text) = 'MU') or ...}

    {Make sure that the parcel is active.}

  If (TYParcelTable.FieldByName('ActiveFlag').Text = InactiveParcelFlag)
    then
      begin
        Result := False;
        NumInactive := NumInactive + 1;
      end;

    {FXX11062001-3: Don't include roll section 9 parcels that are not being
                    billed this cycle.}

  If (Result and
      (Take(2, CollectionType) = 'SC') and
      (TYParcelTable.FieldByName('RollSection').Text = '9'))
    then
      begin
        HasPositiveRateSD := False;

        SetRangeOld(ParcelSDTable,
                    ['TaxRollYr', 'SwisSBLKey', 'SDistCode'],
                    [TaxRollYr, SwisSBLKey, '     '],
                    [TaxRollYr, SwisSBLKey, 'ZZZZZ']);

        Done := False;
        FirstTimeThrough := True;

        ParcelSDTable.First;

        repeat
          If FirstTimeThrough
            then FirstTimeThrough := False
            else ParcelSDTable.Next;

          If ParcelSDTable.EOF
            then Done := True;

          If not Done
            then
              with ParcelSDTable do
                begin
                  FindKeyOld(SDCodeTable, ['SDistCode'], [FieldByName('SDistCode').Text]);

                  If (FoundSDRate(SDRateList,
                                  SDCodeTable.FieldByName('SDistCode').Text,
                                  Take(2, SDCodeTable.FieldByName('ECd1').Text),
                                  Take(1, SDCodeTable.FieldByName('ECFlg1').Text),
                                  RateIndex) and
                      (Roundoff(SDRatePointer(SDRateList[RateIndex])^.HomeSteadRate, 2) > 0))
                    then HasPositiveRateSD := True;

              end;  {If not Done}

        until Done;

        Result := HasPositiveRateSD; 

      end;  {If ((Take(2, CollectionType) = 'SC') and ...}

    {FXX04232009-8(2.20.1.1)[D365]: Give a warning if a parcel does not have a roll section or school code.}
    {FXX07082009-1(2.20.1.10)[D1552]: Don't give a warning if the parcel is inactive.}

  If (ParcelIsActive(TYParcelTable) and
      _Compare(TYParcelTable.FieldByName('RollSection').AsString, coBlank))
    then
      begin
        MessageDlg('Parcel ' + ConvertSwisSBLToDashDot(SwisSBLKey) + ' does not have a roll section.' + #13 +
                   'Please correct this and recalculate the bills.', mtError, [mbOK], 0);
        Result := False;
      end;

  If (ParcelIsActive(TYParcelTable) and
      _Compare(TYParcelTable.FieldByName('SchoolCode').AsString, coBlank))
    then
      begin
        MessageDlg('Parcel ' + ConvertSwisSBLToDashDot(SwisSBLKey) + ' does not have a school code.' + #13 +
                   'Please correct this and recalculate the bills.', mtError, [mbOK], 0);
        Result := False;
      end;

    {FXX04232009-9(2.20.1.1)[D795]: Give a warning if the user numbers bills by account number and the
                                    account number on the parcel is zero or blank.}

  If (BillNumbersAreAccountNumbers and
      (_Compare(TYParcelTable.FieldByName('AccountNo').AsString, coBlank) or
       _Compare(TYParcelTable.FieldByName('AccountNo').AsString, '0', coEqual)))
    then
      begin
        MessageDlg('Parcel ' + ConvertSwisSBLToDashDot(SwisSBLKey) + ' has a zero or blank account number.' + #13 +
                   'Please correct this and recalculate the bills.', mtError, [mbOK], 0);
        Result := False;
      end;

end;  {ParcelToBeBilled}

{===================================================================}
Function TBillCalcForm.CalculateGeneralTax(GeneralRateRec : GeneralRateRecord;
                                           HomesteadCode : String;
                                           TaxableVal : Comp) : Extended;

{FXX05111998-2: In order to figure out the STAR tax savings, need to calculate
                the tax 2 times - once with STAR and once without. So, we needed
                to make the tax calculation of an individual line a seperate
                proc.}

begin
  Result := 0;
     {FXX12221997-3: If there is only one tax rate, it is stored in
                     the hstd rate, so use it.}

  If (RoundOff(TaxableVal, 0) > 0)
    then
      If (GlblMunicipalityUsesTwoTaxRates and
          (HomesteadCode = 'N'))
        then Result := (TaxableVal/1000) * GeneralRateRec.NonhomesteadRate
        else Result := (TaxableVal/1000) * GeneralRateRec.HomesteadRate;

  Result := Roundoff(Result, 2);

end;  {CalculateGeneralTax}

{===================================================================}
Function TBillCalcForm.CalculateSTARSavingsAmount(GeneralRateRec : GeneralRateRecord;
                                                  sHomesteadCode : String;
                                                  iExemptionAmount : Comp;
                                                  iSTARCap : Double;
                                                  iNonHstdSTARCap : Double) : Double;

begin
  Result := Roundoff(CalculateGeneralTax(GeneralRateRec, sHomesteadCode, iExemptionAmount), 2);

  If (GlblMunicipalityUsesTwoTaxRates and
      _Compare(sHomesteadCode, 'N', coEqual))
  then
  begin
    If _Compare(Result, iNonHstdSTARCap, coGreaterThan)
    then Result := iNonHstdSTARCap;
  end
  else
  begin
    If _Compare(Result, iSTARCap, coGreaterThan)
    then Result := iSTARCap;
  end;

end;  {CalculateSTARSavingsAmount}

{===================================================================}
Procedure TBillCalcForm.InsertGeneralTaxRecord(    GeneralRateRec : GeneralRateRecord;
                                                   HomesteadCode : String;
                                                   EXTotArray : ExemptionTotalsArrayType;
                                                   LandAssessedVal,
                                                   TotalAssessedVal : Comp;
                                               var TaxableVal,
                                                   TaxAmount,
                                                   STARSavings : Extended;
                                               var BasicSTARSavings,
                                                   EnhancedSTARSavings : Double;
                                                   GeneralTotalsList,
                                                   SchoolTotalsList : TList;
                                                   ClassRecordFound : Boolean;
                                                   CollectionType : String;
                                                   BasicSTARAmount,
                                                   EnhancedSTARAmount : Comp;
                                                   bSplitParcel : Boolean;
                                               var FirstTaxLineForParcel,
                                                   Quit : Boolean);

{Insert one general tax record for this parcel.}

var
  EXIdx : Integer;
  //TaxAmountBeforeSTAR : Extended;

begin
  EXIdx := 0;

  with BLGeneralTaxTable do
    try
      Insert;

      FieldByName('TaxRollYr').Text := TaxRollYr;
      FieldByName('SwisSBLKey').Text := Take(26, ExtractSSKey(TYParcelTable));
      FieldByName('PrintOrder').AsInteger := GeneralRateRec.PrintOrder;
      FieldByName('HomesteadCode').Text := Take(1, HomesteadCode);

        {????? if RS 8 should we calc general at all?}

         {if taxable val <= 0 then store real 0's to avoid getting}
         {fractions due to math calculations}

         {figure out exemp idx from tax type ingeneral rate tbl}
         {ie county, town village, school so can get the right}
         {exmption total for the tax type}

      EXIdx := GetEXIdx(GeneralRateRec.GeneralTaxType);

        {FXX03232004-1(2.08): If the GeneralTaxType is village and this
                              municipality does not have a partial village roll,
                              treat it as a municipal.}

      If ((EXIdx = EXVillage) and
          (not (rtdVillageReceivingPartialRoll in GlblRollTotalsToShow)))
        then EXIdx := EXTown;

        {FXX11101998-1: Add apply STAR field.}
        {If this is a rate that does not apply the STAR amounts and this
         is a school taxing entity, then subtract out the STAR amounts.}

      (*If ((EXIdx = EXSchool) and
          (not GeneralRateRec.ApplySTAR) and
          ((Roundoff(BasicSTARAmount, 0) > 0) or
           (Roundoff(EnhancedSTARAmount, 0) > 0)))
        then ExTotArray[ExIdx] := ExTotArray[ExIdx] - BasicSTARAmount -
                                  EnhancedSTARAmount; *)

        {Don't include STAR in the taxable value ever.}

      If ((EXIdx = EXSchool) and
          ((Roundoff(BasicSTARAmount, 0) > 0) or
           (Roundoff(EnhancedSTARAmount, 0) > 0)))
        then ExTotArray[ExIdx] := ExTotArray[ExIdx] - BasicSTARAmount -
                                  EnhancedSTARAmount;

        {subtract exemption amt from assessed val to get taxable val}

      TaxableVal := (TotalAssessedVal - ExTotArray[ExIdx]);

        {strip pennies and mills for more accurate number}

      TaxableVal := RoundOff(TaxableVal, 0);
      TCurrencyField(FieldByName('TaxableValue')).Value := TaxableVal;

      TaxAmount := CalculateGeneralTax(GeneralRateRec, HomesteadCode,
                                       TaxableVal);

      STARSavings := 0;
      BasicSTARSavings := 0;
      EnhancedSTARSavings := 0;

        {FXX05111998-2: Figure out the tax savings for STAR, but this only
                        applies to bill lines which are tax type 'SC'.
                        To do this, we figured out the tax with STAR applied
                        above, now we will remove it subtract the two amounts.
                        So, the STAR savings will be on a per line basis. This
                        information may be shown on a per line basis or summed
                        on the bill.}

      STARSavings := 0;

        {FXX08171999-1: Don't compute STAR savings if no STAR for this tax rate.}

      If (CollectionHasSchoolTax and
          GeneralRateRec.ApplySTAR)
        then
          begin
              {Add back the STAR amount.}
              {CHG06162011(2.28.1): STAR amount no longer comes out of the taxable value.}

            (*TaxableVal := TaxableVal + (BasicSTARAmount + EnhancedSTARAmount);

            TaxAmountBeforeSTAR := CalculateGeneralTax(GeneralRateRec, HomesteadCode,
                                                       TaxableVal); *)

            If (_Compare(TYParcelTable.FieldByName('OwnershipCode').AsString, ['P', 'Q'], coEqual) or  {Co-op, waterfront co-op}
                _Compare(TYParcelTable.FieldByName('PropertyClassCode').AsString, MobileHomePropertyClass, coEqual))
            then
            begin
              If ((not bSplitParcel) or
                  (HomesteadCode <> 'N'))
              then
              begin
                  {Load the already calculated STAR savings from this coop.}

                BasicSTARSavings := TYParcelTable.FieldByName('BasicSTARSavings').AsFloat;
                EnhancedSTARSavings := TYParcelTable.FieldByName('EnhancedSTARSavings').AsFloat;
                STARSavings := BasicSTARSavings + EnhancedSTARSavings;

                If _Compare((TaxAmount - STARSavings), 0, coLessThanOrEqual)
                then
                begin
                  If _Compare(EnhancedSTARSavings, 0, coGreaterThan)
                  then EnhancedSTARSavings := Roundoff((EnhancedSTARSavings + TaxAmount - STARSavings), 2);

                  If (_Compare(EnhancedSTARSavings, 0, coEqual) and
                      _Compare(BasicSTARSavings, 0, coGreaterThan))
                  then BasicSTARSavings := Roundoff((BasicSTARSavings + TaxAmount - STARSavings), 2);
                end;

              end;  {If ((not bSplitParcel) or ...}

            end
            else
            begin
              BasicSTARSavings := CalculateSTARSavingsAmount(GeneralRateRec, HomesteadCode,
                                                             BasicSTARAmount, GeneralRateRec.BasicSTARCap,
                                                             GeneralRateRec.NonHstdBasicSTARCap);
              EnhancedSTARSavings := CalculateSTARSavingsAmount(GeneralRateRec, HomesteadCode,
                                                                EnhancedSTARAmount,
                                                                GeneralRateRec.EnhancedSTARCap,
                                                                GeneralRateRec.NonHstdEnhancedSTARCap);

              STARSavings := BasicSTARSavings + EnhancedSTARSavings;

              If _Compare((TaxAmount - STARSavings), 0, coLessThanOrEqual)
              then
              begin
                If _Compare(EnhancedSTARSavings, 0, coGreaterThan)
                then EnhancedSTARSavings := TaxAmount
                else BasicSTARSavings := TaxAmount;
              end;

            end;  {else of If _Compare(TYParcelTable...}


            with TYParcelTable do
            try
              Edit;
              FieldByName('BasicSTARSavings').AsFloat := BasicSTARSavings;
              FieldByName('EnhancedSTARSavings').AsFloat := EnhancedSTARSavings;
              Post;
            except
              Cancel;
              SystemSupport(005, TYParcelTable, 'Error inserting\updating main parcel record.',
                            UnitName, GlblErrorDlgBox);
            end;

          end;  {If CollectionHasSchoolTax}

      STARSavings := BasicSTARSavings + EnhancedSTARSavings;

      TCurrencyField(FieldByName('TaxAmount')).Value := Roundoff(TaxAmount, 2);
      TCurrencyField(FieldByName('STARSavings')).Value := Roundoff(STARSavings, 2);
      FieldByName('BasicSTARSavings').AsFloat := BasicSTARSavings;
      FieldByName('EnhancedSTARSavings').AsFloat := EnhancedSTARSavings;

      Post;
    except
      Quit := True;
      SystemSupport(051, BLGeneralTaxTable, 'Error inserting general tax record.',
                    UnitName, GlblErrorDlgBox);
    end;

    {Save this general tax in tax totals memory array.}
    {FXX05061998-3: Save the STAR amounts for school billings.}

  SaveGenTaxTotals(LandAssessedVal, TotalAssessedVal, ExTotArray[ExIdx],
                   HomesteadCode, CollectionType,
                   BasicSTARAmount, EnhancedSTARAmount,
                   BasicSTARSavings, EnhancedSTARSavings,
                   ClassRecordFound, GeneralRateRec.ApplySTAR, GeneralTotalsList);

    {Save school totals even though this may be a munic collection
     because school av, tv, ex are reported on city/town roll}
    {FXX05061998-3: Save the STAR amounts for school billings.}

  If FirstTaxLineForParcel
    then SaveSchTaxTotals(LandAssessedVal, TotalAssessedVal, ExTotArray[ExSchool],
                          HomesteadCode, CollectionType,
                          BasicSTARAmount, EnhancedSTARAmount,
                          BasicSTARSavings, EnhancedSTARSavings,
                          ClassRecordFound, SchoolTotalsList);

    {Reset the FirstTaxLine flag, unless this is the homestead section
     of a split parcel since we want to record both parts.}

  If ((HomesteadCode <> 'H') or
      (not ClassRecordFound))
    then FirstTaxLineForParcel := False;

end;  {InsertGeneralTaxRecord}

{===================================================================}
Function PaymentShouldBeInOnePayment(CollectionControlTable : TTable;
                                     TotalTaxOwed : Extended;
                                     OwnershipCode : String) : Boolean;

{See if they want to use minimum or maximum payment limits where if they
 are under the minimum or over the maximum, the tax is all in one payment.}

begin
  Result := False;

  with CollectionControlTable do
    begin
      If (FieldByName('UseMinimumPayment').AsBoolean and
          (Roundoff(TotalTaxOwed, 2) <= Roundoff(FieldByName('MinPaymentAmount').AsFloat, 2)))
        then Result := True;

        {CHG06132007-1(2.11.1.36): Add option to billing for coops to be billed in
                                   2 payments even if they are higher than the maximum.}

      If (FieldByName('UseMaximumPayment').AsBoolean and
          (Roundoff(TotalTaxOwed, 2) >= Roundoff(FieldByName('MaxPaymentAmount').AsFloat, 2)) and
          _Compare(OwnershipCode, ocCooperative, coNotEqual) and
          _Compare(OwnershipCode, ocCooperative_Waterfront, coNotEqual))
        then Result := True;

    end;  {with CollectionControlTable do}

end;  {PaymentShouldBeInOnePayment}

{===================================================================}
Procedure TBillCalcForm.DivideTaxAmountIntoPayments(SpecialFeeList,
                                                    SpecialFeeRateList : TList;
                                                    TotalGeneralTax,
                                                    TotalSDMoveTax,
                                                    TotalSDOtherTax : Double);

{Divide up the special fees, special districts and general taxes according
 to the distribution options that they have selected.}

var
  I, J, Index, NumPayments : Integer;
  LeftToDistribute, TempReal,
  Remainder, SpecialFeeTotal : Extended;
  DistributeRemainderForwards : Boolean;
  TempFieldName, OwnershipCode : String;

begin
  LeftToDistribute := 0;
  SpecialFeeTotal := 0;
  NumPayments := CollectionControlTable.FieldByName('NumberOfPayments').AsInteger;
  DistributeRemainderForwards := (CollectionControlTable.FieldByName('PennyDistOption').AsInteger = 0);

    {Distribute each of the special fees. They can either be applied to
     only the first payment or split between the payments.}
    {FXX08201999-1: Missing index from special fee totals list.}

  For I := 0 to (SpecialFeeList.Count - 1) do
    with SpFeeTaxPtr(SpecialFeeList[I])^ do
      begin
        SpecialFeeTotal := SpecialFeeTotal + Roundoff(SPAmount, 2);

        Index := FindSpecialFeeRate(PrintOrder, SpecialFeeRateList);

          {Put fee in approprite payment slot based on user request}

        with BLHeaderTaxTable do
          If SpecialFeePointer(SpecialFeeRateList[Index])^.AmtInFirstPayment
            then
              begin
                FieldByName('TaxPayment1').AsFloat :=
                           FieldByName('TaxPayment1').AsFloat +
                           Roundoff(SPAmount, 2);
              end
            else
              begin
                     {Distribute fee among the total number of payments}

                TempReal := Roundoff(SPAmount, 2) / NumPayments;
                TempReal := RoundOff(TempReal, 2);

                    {if distrib payments leaves us short, add pennies to first n}
                    {payments to reach back to special fee amount}

                Remainder := Roundoff(SPAmount, 2) - (TempReal * NumPayments);
                Remainder := RoundOff(Remainder, 2);

                  {Now distribute the special fees over the number of payments,
                   either forwards or backwards depending on what option they
                   picked.}

                If DistributeRemainderForwards
                  then J := 1  {Start with the first payment}
                  else J := NumPayments;  {Start with the last payment}

                while ((J >= 1) and (J <= NumPayments)) do
                  begin
                    TempFieldName := 'TaxPayment' + IntToStr(J);

                    TCurrencyField(FieldByName(TempFieldName)).Value :=
                        TCurrencyField(FieldByName(TempFieldName)).Value +
                        TempReal;

                      {If there is any remainder, add one penny to each payment
                       until we use the remainder up.}

                    If (Roundoff(Remainder, 2) > 0)
                      then TCurrencyField(FieldByName(TempFieldName)).Value :=
                                TCurrencyField(FieldByName(TempFieldName)).Value +
                                0.01;

                    Remainder := Remainder - 0.01;

                   If DistributeRemainderForwards
                     then J := J + 1   {Next payment}
                     else J := J - 1;  {Previous payment}

                  end;  {while ((J >= 1) and (J <= NumPayments)) do}

              end;  {If AmtInFirstPayment}

      end;  {with SpFeeTotPtr(SpecialFeeTotalsList)^ do}

    {If they want to apply SD amounts equally, we the amount left to
     distribute is everything except special fees.
     If they want to put the move tax on the 1st payment, do it and
     then put the rest of the tax in the left to dist.
     If they want all SD's on 1st payment, do it.}

  with BLHeaderTaxTable do
    case CollectionControlTable.FieldByName('SDApplicationOption').AsInteger of
      ApplySDAmountsEqually : LeftToDistribute := TotalGeneralTax +
                                                  TotalSDMoveTax +
                                                  TotalSDOtherTax;

      ApplyMoveTaxToFirstPayment :
        begin
          FieldByName('TaxPayment1').AsFloat := FieldByName('TaxPayment1').AsFloat +
                                                TotalSDMoveTax;
          LeftToDistribute := TotalGeneralTax + TotalSDOtherTax;

        end;  {ApplyMoveTaxToFirstPayment}

      ApplySDAmountToFirstPayment :
        begin
          FieldByName('TaxPayment1').AsFloat := FieldByName('TaxPayment1').AsFloat +
                                                TotalSDMoveTax +
                                                TotalSDOtherTax;

          LeftToDistribute := TotalGeneralTax;

        end;  {ApplySDAmountToFirstPayment}

    end;  {case CollectionControlTable.}

  with BLHeaderTaxTable do
    begin
       {First let's see if the total tax due is under a minimum amount
        or over a maximum amount which they want to be in one payment only.}
       {CHG06132007-1(2.11.1.36): Add option to billing for coops to be billed in
                                  2 payments even if they are higher than the maximum.}

      try
        OwnershipCode := FieldByName('OwnershipCode').AsString;
      except
        OwnershipCode := '';
      end;

      If PaymentShouldBeInOnePayment(CollectionControlTable,
                                     TotalGeneralTax,
                                     OwnershipCode)
        then
          begin
            TCurrencyField(FieldByName('TaxPayment1')).Value :=
                                             TotalGeneralTax +
                                             TotalSDMoveTax +
                                             TotalSDOtherTax +
                                             SpecialFeeTotal;

              {Clear out the other fields.}

            For I := 2 to NumPayments do
              begin
                TempFieldName := 'TaxPayment' + IntToStr(I);

                TCurrencyField(FieldByName(TempFieldName)).Value := 0;

              end;  {For I := 2 to NumPayments do}

          end
        else
          begin
             {get amount of divided payments}

            TempReal := LeftToDistribute / NumPayments;
            TempReal := RoundOff(TempReal, 2);

              { mult the half payment by no payments and subtract from orig tax,
                 and remove minus sign via Abs  ... hope this works for 3+ payments}

            Remainder := LeftToDistribute - (TempReal * NumPayments);
            Remainder := RoundOff(Remainder, 2);

              {If we end up with a negative remainder, then the installment payment
               rounded up and the installment payment is one penny too high (not
               including remainder). So, to make this look like the other case,
               we will subtract one penny from the TempReal (i.e. the installment)
               and recalculate the remainder.}

            If (Roundoff(Remainder, 2) < 0)
              then
                begin
                  TempReal := Roundoff((TempReal - 0.01), 2);
                  Remainder := LeftToDistribute - (TempReal * NumPayments);
                  Remainder := RoundOff(Remainder, 2);

                end;  {If (Roundoff(Remainder, 2) < 0)}

            {Now distribute the tax over the number of payments, either forwards
             or backwards depending on what option they picked.}

            If DistributeRemainderForwards
              then I := 1  {Start with the first payment}
              else I := NumPayments;  {Start with the last payment}

            while ((I >= 1) and (I <= NumPayments)) do
              begin
                TempFieldName := 'TaxPayment' + IntToStr(I);

                TCurrencyField(FieldByName(TempFieldName)).Value :=
                    TCurrencyField(FieldByName(TempFieldName)).Value +
                    TempReal;

                  {If there is any remainder, add one penny to each payment
                   until we use the remainder up.}

                If (Roundoff(Remainder, 2) > 0)
                  then TCurrencyField(FieldByName(TempFieldName)).Value :=
                            TCurrencyField(FieldByName(TempFieldName)).Value +
                            0.01;

                Remainder := Remainder - 0.01;

                If DistributeRemainderForwards
                  then I := I + 1   {Next payment}
                  else I := I - 1;  {Previous payment}

              end;  {while ((I >= 1) and (I <= NumPayments)) do}

          end;  {else of If PaymentShouldBeInOnePayment}

        {Compute the total tax.}

      FieldByName('TotalTaxOwed').AsFloat := TotalGeneralTax +
                                             TotalSDMoveTax +
                                             TotalSDOtherTax +
                                             SpecialFeeTotal;

    end;  {with BLHeaderTaxTable do}

end;  {DivideTaxAmountIntoPayments}

{===================================================================}
Function GeneralRateApplies(ParcelTable : TTable;
                            GeneralRateRec : GeneralRateRecord;
                            CollectionType : String) : Boolean;

{FXX12221997-4: We need to check to see if this general tax applies
                to this swis/school code.}

begin
    {FXX05141998-2: Need to do swis and school seperate.}

    {Need to check the school code if this is a school billing.}

  If CollectionHasSchoolTax
    then
      begin
        Result := (SwisCodesMatch_FullOrPartial(ParcelTable.FieldByName('SwisCode').Text,
                                                GeneralRateRec.SwisCode) and
                   SchoolCodesMatch_FullOrPartial(ParcelTable.FieldByName('SchoolCode').Text,
                                                  GeneralRateRec.SchoolCode));

      end  {If CollectionHasSchoolTax}
    else Result := (SwisCodesMatch_FullOrPartial(ParcelTable.FieldByName('SwisCode').Text,
                                                 GeneralRateRec.SwisCode));

    {FXX12221997-7: General taxes never apply to roll section 9.}

  If (ParcelTable.FieldByName('RollSection').Text = '9')
    then Result := False;

end;  {GeneralRateApplies}

{===================================================================}
Function TBillCalcForm.SaveThisSD(ParcelTable : TTable;
                                  SDCode : String;
                                  SDRateList : TList) : Boolean;

{If this is a roll section 9, only save special districts with the
 roll section 9 flag turned on.}
{FXX12221997-8: If this is a roll section 9 parcel, only save rs 9
                    special districts.}

var
  SDIsZeroRate : Boolean;
  I : Integer;

begin
  Result := True;

  FindKeyOld(SDCodeTable, ['SDistCode'], [SDCode]);

    {FXX04291998-9: Don't store records for special districts where all extensions
                    are zero.}
    {CHG03262009-1: Allow user to bill zero special district rates.}

  If bBillZeroSDRates
    then SDIsZeroRate := False
    else SDIsZeroRate := True;

  For I := 0 to (SDRateList.Count - 1) do
    with SDRatePointer(SDRateList[I])^ do
      If (_Compare(SDistCode, SDCode, coEqual) and
          ((Roundoff(HomesteadRate, 6) > 0) or
           (Roundoff(NonhomesteadRate, 6) > 0)))
        then SDIsZeroRate := False;

    {FXX05051998-1: Testing incorrectly for zero SD rate.}
    {FXX11062001-2: Need to include test of AppliesToSchool and
                    ProrataOmit when checking for SD applicability.}

  If (((ParcelTable.FieldByName('RollSection').Text = '9') and
       (not (SDCodeTable.FieldByName('SDRS9').AsBoolean or
             SDCodeTable.FieldByName('AppliesToSchool').AsBoolean or
             SDCodeTable.FieldByName('ProrataOmit').AsBoolean))) or
      SDIsZeroRate)
    then Result := False;

end;  {SaveThisSD}

{===================================================================}
Procedure TBillCalcForm.CalcBillThisParcel(     CollectionType : String;
                                                GeneralRateList,
                                                SDRateList,
                                                SpecialFeeRateList,
                                                SDExtCategoryList,
                                                BillControlDetailList,
                                                GeneralTotalsList,
                                                SDTotalsList,
                                                SchoolTotalsList,
                                                EXTotalsList,
                                                SpecialFeeTotalsList : TList;
                                            var Quit : Boolean);

{Calculate the bill for one parcel and store the totals in the totals lists.}

var
  I, J, EXIdx, TLIdx : Integer;  {tlist index}
  TotalSDMoveTax, TotalSDOtherTax,
  GeneralTaxOwed, TaxableVal, TaxAmount, STARSavings : Extended;
  BasicSTARSavings, EnhancedSTARSavings : Double;
  HstdAssessedVal, NonhstdAssessedVal,
  HstdLandVal, NonhstdLandVal, EXAmount : Comp;
  HstdAcres, NonhstdAcres : Real;
  FirstTaxLineForParcel,
  AssessmentRecordFound, ClassRecordFound, _Found : Boolean;
  HstdEXTotArray, NonhstdEXTotArray, ExTotArray : ExemptionTotalsArrayType;
  SDAmounts, SPFeeList : TList;
  ExemptionCodes,
  ExemptionHomesteadCodes,
  ResidentialTypes,
  CountyExemptionAmounts,
  TownExemptionAmounts,
  SchoolExemptionAmounts,
  VillageExemptionAmounts : TStringList;
  SwisSBLKey : String;
  TempHomesteadCode, TempSTARHomesteadCode : String;
  SDExtCategory : String;
  BasicSTARAmount, EnhancedSTARAmount,
  TempBasicSTARAmount, TempEnhancedSTARAmount,
  CountyAmount, TownAmount,
  SchoolAmount, VillageAmount, ExemptionAmount : Comp;
  TempParcelTable : TTable;
  SBLRec : SBLRecord;
  GeneralRateRec : GeneralRateRecord;
  TempStr : String;
  TempDate : String;
  TempYear, SDHomesteadCode : String;
  SPFeePtr : SPFeeTaxPtr;
  fTaxAmount : Double;

begin
    {FXX11291999-4: In order to allow city and school at the same time,
                    check the tax type of the individual line.}

  CollectionHasSchoolTax := False;
  For I := 0 to (GeneralRateList.Count - 1) do
    with GeneralRatePointer(GeneralRateList[I])^ do
      If (GeneralTaxType = 'SC')
        then CollectionHasSchoolTax := True;

  SwisSBLKey := ExtractSSKey(TYParcelTable);

  SDAmounts := TList.Create;
  ExemptionCodes := TStringList.Create;
  ExemptionHomesteadCodes := TStringList.Create;
  ResidentialTypes := TStringList.Create;
  CountyExemptionAmounts := TStringList.Create;
  TownExemptionAmounts := TStringList.Create;
  SchoolExemptionAmounts := TStringList.Create;
  VillageExemptionAmounts := TStringList.Create;

    {Get the assessed values.}

  CalculateHstdAndNonhstdAmounts(TaxRollYr,
                                 ExtractSSKey(TYParcelTable),
                                 AssessmentTable,
                                 ClassTable, TYParcelTable,
                                 HstdAssessedVal, NonhstdAssessedVal,
                                 HstdLandVal, NonhstdLandVal,
                                 HstdAcres, NonhstdAcres,
                                 AssessmentRecordFound,
                                 ClassRecordFound);

  TempStr := ConvertSwisSBLToDashDot(ExtractSSKey(TYParcelTable));

    {Set up the informational part of the header tax table.}

  with BLHeaderTaxTable do
    try
      Insert;

      FieldByName('TaxRollYr').Text := TaxRollYr;
      FieldByName('SwisCode').Text := TYParcelTable.FieldByName('SwisCode').Text;
      FieldByName('RollSection').Text := TYParcelTable.FieldByName('RollSection').Text;
      FieldByName('SBLKey').Text := ExtractSBL(TYParcelTable);
      FieldByName('CheckDigit').Text := TYParcelTable.FieldByName('CheckDigit').Text;
      FieldByName('SwisCode').Text := TYParcelTable.FieldByName('SwisCode').Text;
      FieldByName('SchoolDistCode').Text := TYParcelTable.FieldByName('SchoolCode').Text;

        {FXX07021998-7: Add the tax finance code.}
        {FXX08131998-1: Need to get the school district in the school table.}

      FindKeyOld(SchoolCodeTable, ['SchoolCode'],
                 [FieldByName('SchoolDistCode').Text]);
      FieldByName('TaxFinanceCode').Text := SchoolCodeTable.FieldByName('TaxFinanceCode').Text;

        {FXX05061998-4: In order to avoid having 2 sets of keys - one
                        starting with swis and one with school\swis,
                        I created a dummy SchoolCodeKey field which is blank
                        in a municipal billing and has no effect and filled
                        in in a school billing.  We can't just use the regular
                        school code field since we need it in municipal billings
                        to show what school this is.}
        {FXX12171998-5: For billings other than school, fill in 999999 for the dummy
                        SchoolCodeKey field since it is the first part of a key and if
                        the first part of a key is blank, the search is not correct -
                        this matters for numbering proratas after the base.}

      If CollectionHasSchoolTax
        then FieldByName('SchoolCodeKey').Text := FieldByName('SchoolDistCode').Text
        else FieldByName('SchoolCodeKey').Text := '999999';

      FieldByName('PropertyClassCode').Text := TYParcelTable.FieldByName('PropertyClassCode').Text;

      try
        FieldByName('OwnershipCode').AsString := TYParcelTable.FieldByName('OwnershipCode').AsString;
      except
      end;

        {If there is no class record, put the acreage in the homestead amount
         if it is 'H' or blank. Put the acreage in non-homestead if this
         is a non-homestead parcel.}

      If ClassRecordFound
        then
          begin
            FieldByName('HstdAcreage').Text := ClassTable.FieldByName('HstdAcres').Text;
            FieldByName('NonhstdAcreage').Text := ClassTable.FieldByName('NonhstdAcres').Text;
          end
        else
          If (TYParcelTable.FieldByName('HomesteadCode').Text = 'N')
            then FieldByName('NonhstdAcreage').Text := TYParcelTable.FieldByName('Acreage').Text
            else FieldByName('HstdAcreage').Text := TYParcelTable.FieldByName('Acreage').Text;

      FieldByName('Frontage').Text := TYParcelTable.FieldByName('Frontage').Text;
      FieldByName('Depth').Text := TYParcelTable.FieldByName('Depth').Text;
      FieldByName('GridCordNorth').Text := TYParcelTable.FieldByName('GridCordNorth').Text;
      FieldByName('GridCordEast').Text := TYParcelTable.FieldByName('GridCordEast').Text;
      FieldByName('DeedBook').Text := TYParcelTable.FieldByName('DeedBook').Text;
      FieldByName('DeedPage').Text := TYParcelTable.FieldByName('DeedPage').Text;
      FieldByName('HomesteadCode').Text := TYParcelTable.FieldByName('HomesteadCode').Text;
      FieldByName('AccountNumber').Text := TYParcelTable.FieldByName('AccountNo').Text;
      FieldByName('MortgageNumber').Text := TYParcelTable.FieldByName('MortgageNumber').Text;

        {FXX03161999-2: Need to make sure the arrears flag gets set in the billing header file.}

      FieldByName('ArrearsFlag').AsBoolean := TYParcelTable.FieldByName('Arrears').AsBoolean;

      TCurrencyField(FieldByName('HstdTotalVal')).Value := HstdAssessedVal;
      TCurrencyField(FieldByName('NonhstdTotalVal')).Value := NonhstdAssessedVal;
      TCurrencyField(FieldByName('HstdLandVal')).Value := HstdLandVal;
      TCurrencyField(FieldByName('NonhstdLandVal')).Value := NonhstdLandVal;

        {The name, address, and bank code fields come from the next
         year parcel file if this parcel exists in NY. Otherwise, it
         comes from the TY file.}

      SBLRec := ExtractSwisSBLFromSwisSBLKey(SwisSBLKey);

      with SBLRec do
        _Found := FindKeyOld(NYParcelTable,
                             ['TaxRollYr', 'SwisCode', 'Section',
                              'Subsection', 'Block', 'Lot', 'Sublot',
                              'Suffix'],
                             [GlblNextYear, SwisCode, Section,
                              Subsection, Block, Lot, Sublot, Suffix]);

      If _Found
        then TempParcelTable := NYParcelTable
        else TempParcelTable := TYParcelTable;

      FieldByName('Name1').Text := TempParcelTable.FieldByName('Name1').Text;
      FieldByName('Name2').Text := TempParcelTable.FieldByName('Name2').Text;
      FieldByName('Address1').Text := TempParcelTable.FieldByName('Address1').Text;
      FieldByName('Address2').Text := TempParcelTable.FieldByName('Address2').Text;
      FieldByName('Street').Text := TempParcelTable.FieldByName('Street').Text;
      FieldByName('City').Text := TempParcelTable.FieldByName('City').Text;
      FieldByName('State').Text := TempParcelTable.FieldByName('State').Text;
      FieldByName('Zip').Text := TempParcelTable.FieldByName('Zip').Text;
      FieldByName('ZipPlus4').Text := TempParcelTable.FieldByName('ZipPlus4').Text;

        {FXX07061998-5: Assign bank code "ARREARS" if arrears flag on.}
        {CHG12171998-1: If the person wants to assign a special bank code to rs 9,
                        do it here.}

      If (UseArrearsFlag and
          TYParcelTable.FieldByName('Arrears').AsBoolean)
        then FieldByName('BankCode').Text := 'ARREARS'
        else
          If ((TYParcelTable.FieldByName('RollSection').Text = '9') and
               (Deblank(RS9BankCode) <> ''))
            then FieldByName('BankCode').Text := RS9BankCode
            else FieldByName('BankCode').Text := TempParcelTable.FieldByName('BankCode').Text;

        {FXX01131998-2: The property descriptions should come from NY
                        if it exists as per Evelyn Evans at Ramapo.}

      FieldByName('PropDescr1').Text := TempParcelTable.FieldByName('PropDescr1').Text;
      FieldByName('PropDescr2').Text := TempParcelTable.FieldByName('PropDescr2').Text;
      FieldByName('PropDescr3').Text := TempParcelTable.FieldByName('PropDescr3').Text;

        {FXX01131998-1: Add land commitment warnings.}

      FieldByName('CommitmentCode').Text := TempParcelTable.FieldByName('LandCommitmentCode').Text;
      FieldByName('CommTermYear').Text := TempParcelTable.FieldByName('CommitmentTermYear').Text;

        {FXX01061998-4: Print the prior owner.}
        {If the next year name is different from the this year name, we
         will print it.}
        {FXX06251998-4: The prior owner should be the this year name.}

      If (Take(30, TYParcelTable.FieldByName('Name1').Text) <>
          Take(30, NYParcelTable.FieldByName('Name1').Text))
        then FieldByName('PriorOwner').Text := TYParcelTable.FieldByName('Name1').Text;

        {FXX05092003-3(2.07a): Add the additional lot to the billing file.}

      FieldByName('AdditionalLots').Text := TYParcelTable.FieldByName('AdditionalLots').Text;

        {FXX12272004-1(2.8.1.6): The TempParcelTable switch should only occur after getting the bank code.}
        {CHG08172004-2(2.08.0.08182004): Option to have the legal address come from NY.}

      If (GetLegalAddressFromNextYear and _Found)
        then TempParcelTable := NYParcelTable
        else TempParcelTable := TYParcelTable;

      FieldByName('LegalAddr').Text := TempParcelTable.FieldByName('LegalAddr').Text;
      FieldByName('LegalAddrNo').Text := TempParcelTable.FieldByName('LegalAddrNo').Text;

      try
        FieldByName('PrintKey').AsString := TYParcelTable.FieldByName('PrintKey').AsString;
      except
      end;

    except
      Quit := True;
      SystemSupport(070, BLHeaderTaxTable, 'Error inserting tax header record.',
                    UnitName, GlblErrorDlgBox);
    end;

    {Make sure that there is an assessment record for this parcel.}

(*  If not AssessmentRecordFound
    then
      begin
        Writeln(CalcMessageFile, 'No Assessment Record For Parcel ' +
                ExtractSSKey(TYParcelTable), '. No Bill Generated.');
        Quit := True;

      end;  {If not AssessmentRecordFound} *)

    {If the parcel is split, it should have a class record.}

(*  If ((TYParcelTable.FieldByName('HomesteadCode').Text = 'S') and
      (not ClassRecordFound))
    then
      begin
        Writeln(CalcMessageFile, 'Parcel is split and has no class record. Parcel = ' +
                ExtractSSKey(TYParcelTable), '. No Bill Generated.');
        Quit := True;

      end;  {If ((TYParcelTable.FieldByName('HomesteadCode').Text = 'S') and ...}*)

    {Calc exemption amounts, county, town schl, village for this parcel.}
    {CHG12011997-2: STAR support}
    {FXX02091998-1: Pass the residential type of each exemption.}

  SwisSBLKey := ExtractSSKey(TYParcelTable);

  EXTotArray := TotalExemptionsForParcel(TaxRollYr,
                                         ExtractSSKey(TYParcelTable),
                                         ParcelExemptionTable,
                                         ExCodeTable,
                                         BLHeaderTaxTable.FieldByName('HomesteadCode').Text,
                                         'A',
                                         ExemptionCodes,
                                         ExemptionHomesteadCodes,
                                         ResidentialTypes,
                                         CountyExemptionAmounts,
                                         TownExemptionAmounts,
                                         SchoolExemptionAmounts,
                                         VillageExemptionAmounts,
                                         BasicSTARAmount, EnhancedSTARAmount);

   {Now save the exemptions for this parcel in the totals record.}
   {FXX05061998-3: Save the STAR amounts for school billings.
                   To do this, we will insert a STAR exemption code
                   if the amount > 0 and we are in a school billing.
                   This is because on an individual parcel, a STAR exemption
                   is treated like any other exemption, but is seperate for
                   roll totals.}

    {FXX07241998-1: Determine the homestead exemption code for the STAR exemption.}

  TempSTARHomesteadCode := TYParcelTable.FieldByName('HomesteadCode').Text;

  If (TempSTARHomesteadCode = 'S')
    then TempSTARHomesteadCode := 'H';

  TempSTARHomesteadCode := TempSTARHomesteadCode;

  If (CollectionHasSchoolTax and
      (Roundoff(BasicSTARAmount, 0) > 0))
    then
      begin
        ExemptionCodes.Add(BasicSTARExemptionCode);
        ExemptionHomesteadCodes.Add(TempSTARHomesteadCode);
        CountyExemptionAmounts.Add('0');
        TownExemptionAmounts.Add('0');
        SchoolExemptionAmounts.Add(FloatToStr(BasicSTARAmount));
        VillageExemptionAmounts.Add('0');

      end;  {If (Roundoff(BasicSTARAmount, 0) > 0)}

  If (CollectionHasSchoolTax and
      (Roundoff(EnhancedSTARAmount, 0) > 0))
    then
      begin
        ExemptionCodes.Add(EnhancedSTARExemptionCode);
        ExemptionHomesteadCodes.Add(TempSTARHomesteadCode);
        CountyExemptionAmounts.Add('0');
        TownExemptionAmounts.Add('0');
        SchoolExemptionAmounts.Add(FloatToStr(EnhancedSTARAmount));
        VillageExemptionAmounts.Add('0');

      end;  {If (Roundoff(EnhancedSTARAmount, 0) > 0)}

  SaveEXTaxTotals(ExemptionCodes, ExemptionHomesteadCodes,
                  CountyExemptionAmounts, TownExemptionAmounts,
                  SchoolExemptionAmounts, VillageExemptionAmounts,
                  ClassRecordFound, ExTotalsList);

    {A single exemptions may apply to homestead or non-homestead, so
     the totals will be different on a split parcel. If this is not
     a designated parcel, the total exemption amount will go in
     the HstdEXTotArray - that is, the homestead amount.}

  GetHomesteadAndNonhstdExemptionAmounts(ExemptionCodes,
                                         ExemptionHomesteadCodes,
                                         CountyExemptionAmounts,
                                         TownExemptionAmounts,
                                         SchoolExemptionAmounts,
                                         VillageExemptionAmounts,
                                         HstdEXTotArray,
                                         NonhstdEXTotArray);

   {Save the individual exemptions.}
   {FXX06301998-7: Only print an exemption or save it if it has amounts for
                   this roll type.}

  For I := 0 to (ExemptionCodes.Count - 1) do
    If SaveThisExemption(ExemptionCodes[I],
                         StrToFloat(CountyExemptionAmounts[I]),
                         StrToFloat(TownExemptionAmounts[I]),
                         StrToFloat(SchoolExemptionAmounts[I]),
                         StrToFloat(VillageExemptionAmounts[I]),
                         CollectionType)
      then
        with BLExemptionTaxTable do
          try
            Insert;

            CountyAmount := StrToFloat(CountyExemptionAmounts[I]);
            TownAmount := StrToFloat(TownExemptionAmounts[I]);
            SchoolAmount := StrToFloat(SchoolExemptionAmounts[I]);
            VillageAmount := StrToFloat(VillageExemptionAmounts[I]);

            FieldByName('HomesteadCode').Text := ExemptionHomesteadCodes[I];

            FieldByName('TaxRollYr').Text := TaxRollYr;
            FieldByName('SwisSBLKey').Text := SwisSBLKey;
            FieldByName('EXCode').Text := ExemptionCodes[I];
            TCurrencyField(FieldByName('CountyAmount')).Value := CountyAmount;
            TCurrencyField(FieldByName('TownAmount')).Value := TownAmount;
            TCurrencyField(FieldByName('SchoolAmount')).Value := SchoolAmount;
            TCurrencyField(FieldByName('VillageAmount')).Value := VillageAmount;

              {FXX01131998-1: Add land commitment warnings.}
              {To do this, we will look up the exemption in the exemption
               table rather than returning it in GetExemptionCode.}

            If ((FieldByName('EXCode').Text = '41720') or
                (FieldByName('EXCode').Text = '41730') or
                (FieldByName('EXCode').Text = '47460') or
                (FieldByName('EXCode').Text = '41700'))
              then
                begin
                  _Found := FindKeyOld(ParcelExemptionTable,
                                       ['TaxRollYr', 'SwisSBLKey', 'ExemptionCode'],
                                       [TaxRollYr, SwisSBLKey,
                                        FieldByName('EXCode').Text]);

                  If _Found
                    then
                      begin
                        TempDate := ParcelExemptionTable.FieldByName('InitialDate').Text;

                        TempYear := Copy(TempDate, (Length(TempDate) - 3), 4);

                        FieldByName('InitialYear').Text := TempYear;

                      end;  {If Found}

                end;  {If ((FieldByName('EXCode').Text = '41720') or ...}

            try
              ExemptionAmount := 0;

              If _Compare(CollectionType, VillageTaxType, coEqual)
                then ExemptionAmount := VillageAmount;

                {FXX06182008-1(2.13.1.15): In the case that there is an exemption that applies
                                           to more than 1 jurisdiction, choose the town first.}

              If _Compare(ExemptionAmount, 0, coEqual)
                then ExemptionAmount := TownAmount;

              If _Compare(ExemptionAmount, 0, coEqual)
                then ExemptionAmount := CountyAmount;

              If (_Compare(ExemptionAmount, 0, coEqual) and
                  _Compare(CollectionType, [SchoolTaxType, MunicipalTaxType], coEqual))
                then ExemptionAmount := SchoolAmount;

              FieldByName('FullValue').AsInteger := Trunc(ComputeFullValue(ExemptionAmount,
                                                                           SwisCodeTable,
                                                                           TYParcelTable.FieldByName('PropertyClassCode').AsString,
                                                                           TYParcelTable.FieldByName('OwnershipCode').AsString,
                                                                           True));
            except
            end;

            try
              FieldByName('TaxSavings').AsFloat := 0;
            except
            end;

            Post;
          except
            Quit := True;
          end;

    {Now do the general taxes, i.e. Town, County, etc.}
    {FXX12221997-4: We need to check to see if this general tax applies
                    to this swis/school code.}

  GeneralTaxOwed := 0;

    {FXX01061998-5: If this is a split parcel, add one to the split parcel
                    count for hstd and nonhstd totals for ex, gen, schl.}

    {FXX01071998-6: The # of school parcels was being increased for
                    each tax line - only do for first occurence.}

  FirstTaxLineForParcel := True;

  For TLIdx := 0 to (GeneralRateList.Count - 1) do
    If GeneralRateApplies(TYParcelTable,
                          GeneralRatePointer(GeneralRateList[TLIdx])^,
                          CollectionType)
      then
        begin
          TempHomesteadCode := TYParcelTable.FieldByName('HomesteadCode').Text;

            {FXX01061998-3: Add support for school and village relevies.
                            The user indicates the line is a school or
                            village relevy by selecting the general tax
                            type SR or VR.}

          with GeneralRatePointer(GeneralRateList[TLIdx])^ do
            If ((GeneralTaxType = 'SR') or {School relevy}
                (GeneralTaxType = 'VR'))
              then
                begin
                  GeneralRateRec := GeneralRatePointer(GeneralRateList[TLIdx])^;

                  with BLGeneralTaxTable do
                    try
                      Insert;

                      FieldByName('TaxRollYr').Text := TaxRollYr;
                      FieldByName('SwisSBLKey').Text := ExtractSSKey(TYParcelTable);
                      FieldByName('PrintOrder').AsInteger := GeneralRateRec.PrintOrder;
                      FieldByName('HomesteadCode').Text := '';
                      TaxableVal := 0;  {No TV for relevy}
                      TCurrencyField(FieldByName('TaxableValue')).Value := TaxableVal;

                      If (GeneralTaxType = 'SR')
                        then TaxAmount := TYParcelTable.FieldByName('SchoolRelevy').AsFloat
                        else TaxAmount := TYParcelTable.FieldByName('VillageRelevy').AsFloat;

                      If (RoundOff(TaxableVal, 0) > 0)
                        then TaxAmount := (TaxableVal/1000) * GeneralRateRec.HomesteadRate;

                      TaxAmount := Roundoff(TaxAmount, 2);

                      TCurrencyField(FieldByName('TaxAmount')).Value := Roundoff(TaxAmount, 2);

                        {Only save a relevy tax if there actually is an amount.}

                      If (TaxAmount > 0)
                        then Post
                        else Cancel;

                    except
                      Quit := True;
                      SystemSupport(051, BLGeneralTaxTable, 'Error inserting general tax record.',
                                    UnitName, GlblErrorDlgBox);
                    end;

                    {Save this general tax in tax totals memory array.
                     Note for relevies there is no av, land av, exemptions
                     and it only shows up in the general totals.}

                    {FXX01071998-5: Only update the school and general totals
                                    if the relevy amount is greater than 0.}

                  If (TaxAmount > 0)
                    then
                      begin
                        SaveGenTaxTotals(0, 0, 0, ' ', CollectionType,
                                         0, 0, 0, 0,
                                         ClassRecordFound, False, GeneralTotalsList);

                        GeneralTaxOwed := GeneralTaxOwed + Roundoff(TaxAmount, 2);

                      end;  {If (TaxAmount > 0)}

                end
              else
                begin
                    {If there is any homestead assessed value, insert it.
                     This may be a nonclassified parcel, a homestead parcel,
                     or the homestead part of a split parcel.}

                    {FXX01071998-3: We were resetting the TempHomesteadCode
                                    so non-homestead amounts were not
                                    being added for splits.}

                  If (TempHomesteadCode <> 'N')
                    then
                      begin
                          {FXX05061998-3: Save the STAR amounts for school billings.}
                          {FXX05111998-3: Record STAR savings.}

                        InsertGeneralTaxRecord(GeneralRatePointer(GeneralRateList[TLIdx])^,
                                               'H', HstdEXTotArray,
                                               HstdLandVal, HstdAssessedVal,
                                               TaxableVal, TaxAmount, STARSavings,
                                               BasicSTARSavings, EnhancedSTARSavings,
                                               GeneralTotalsList, SchoolTotalsList,
                                               ClassRecordFound,
                                               CollectionType, BasicSTARAmount,
                                               EnhancedSTARAmount,
                                               False,
                                               FirstTaxLineForParcel,
                                               Quit);

                          {CHG07122011(MDT)[2.28]: STAR cap changes.}

                        If GeneralRatePointer(GeneralRateList[TLIdx])^.ApplySTAR
                        then
                        begin
                          STARSavings := BasicSTARSavings + EnhancedSTARSavings;
                          TaxAmount := TaxAmount - STARSavings;

                          If (TaxAmount < 0)
                          then TaxAmount := 0;
                        end;

                        GeneralTaxOwed := GeneralTaxOwed + Roundoff(TaxAmount, 2);

                      end;  {If (Roundoff(HstdAssessedVal, 0) > 0)}

                    {If there is any nonhomestead assessed value, insert it.
                     Note that this will always get stored with a homestead code of 'N'.}
                    {We will pass in zero amounts for STAR since STAR can only apply
                     to homestead.}

                  If (TempHomesteadCode[1] in ['S', 'N'])
                    then
                      begin
                          {FXX05061998-3: Save the STAR amounts for school billings.
                                          Note that since STAR is homestead, we will
                                          save 0 amounts for STAR.}
                          {FXX05111998-3: Record STAR savings.}
                          {FXX11051998-6: Sometimes there is STAR on non-homestead
                                          parcels.}
                          {FXX08161999-1: Make sure STAR amouns are 0 for non-hstd -
                                          only if this is a split parcel since the totals
                                          are counted in the hstd part.}

                        If (TempHomesteadCode = 'S')
                          then
                            begin
                              TempBasicSTARAmount := 0;
                              TempEnhancedSTARAmount := 0;
                            end
                          else
                            begin
                              TempBasicSTARAmount := BasicSTARAmount;
                              TempEnhancedSTARAmount := EnhancedSTARAmount;
                            end;

                        InsertGeneralTaxRecord(GeneralRatePointer(GeneralRateList[TLIdx])^,
                                               'N', NonhstdEXTotArray,
                                               NonhstdLandVal, NonhstdAssessedVal,
                                               TaxableVal, TaxAmount, STARSavings,
                                               BasicSTARSavings, EnhancedSTARSavings,
                                               GeneralTotalsList, SchoolTotalsList,
                                               ClassRecordFound,
                                               CollectionType, TempBasicSTARAmount,
                                               TempEnhancedSTARAmount,
                                               (TempHomesteadCode = 'S'),
                                               FirstTaxLineForParcel,
                                               Quit);

                          {CHG07122011(MDT)[2.28]: STAR cap changes.}
                          {If this is a split parcel, the STAR would have applied to the homestead portion.}

                        If ((TempHomesteadCode[1] = 'N') and
                            GeneralRatePointer(GeneralRateList[TLIdx])^.ApplySTAR)
                        then
                        begin
                          STARSavings := BasicSTARSavings + EnhancedSTARSavings;
                          TaxAmount := TaxAmount - STARSavings;
                        end;

                          {Add the calculated tax amount to the total of what they owe.}

                        GeneralTaxOwed := GeneralTaxOwed + Roundoff(TaxAmount, 2);

                      end;  {If (Roundoff(NonhstdAssessedVal, 0) > 0)}

                end;  {else of If ((GeneralTaxType = 'SR') or ...}

        end;  {If GeneralRateApplies(TYParcelTable, GeneralRateList[TLIdx)}


    {Get all the special districts - see PASTYPES for the layout of
     the elements in the SDAmounts list.}

  TotalSpecialDistrictsForParcel(TaxRollYr, SwisSBLKey,
                                 TYParcelTable, AssessmentTable,
                                 ParcelSDTable, SDCodeTable,
                                 ParcelExemptionTable,
                                 ExCodeTable,
                                 SDAmounts);

     {CHG06102009-3(2.20.1.1)[F966]: Warn users if there are no special districts on a parcel.} 

   If (bWarnAboutBillsWithoutSpecialDistricts and
       _Compare(SDAmounts.Count, 0, coEqual))
     then MessageDlg('Warning: ' + ConvertSBLOnlyToDashDot(Copy(SwisSBLKey, 7, 20)) +
                     ' does not have any special districts.',
                     mtWarning, [mbOK], 0);

    {Because of the different ways that the SD amounts can be applied, we
     need to keep track of the Move Tax total and other total seperately.}

  TotalSDMoveTax := 0;
  TotalSDOtherTax := 0;

    {Now go through each of the entries in the SDAmounts list and
     calculate the tax and store a record in the SD tax table.}

    {FXX12221997-8: If this is a roll section 9 parcel, only save rs 9
                    special districts.}
    {FXX04291998-9: Don't store records for special districts where all extensions
                    are zero.}

  SDHomesteadCode := '';

  For I := 0 to (SDAmounts.Count - 1) do
    If SaveThisSD(TYParcelTable,
                  PParcelSDValuesRecord(SDAmounts[I])^.SDCode,
                  SDRateList)
      then
        For J := 1 to 10 do {For each of the possible extension codes insert a record if it is filled in.}
          If (Deblank(PParcelSDValuesRecord(SDAmounts[I])^.SDExtensionCodes[J]) <> '')
            then
              begin
                with BLSpecialDistrictTaxTable do
                  try
                    Insert;

                    with PParcelSDValuesRecord(SDAmounts[I])^ do
                      begin
                        FieldByName('TaxRollYr').Text := TaxRollYr;
                        FieldByName('SwisSBLKey').Text := SwisSBLKey;
                        FieldByName('SdistCode').Text := SDCode;
                        FieldByName('ExtCode').Text := SDExtensionCodes[J];
                        FieldByName('CMFlag').Text := SDCC_OMFlags[J];

                          {FXX12132004-1(2.8.1.3): Make sure that the homestead code is filled in.}

                        FieldByName('HomesteadCode').Text := HomesteadCodes[J];

                          {convert value to appropriate type, eg for advalorum ext code}
                          {convert sdvalue to taxable value, no decimal pts, for }
                          {acreage convert to 2 decimal points, etc}

                        FieldByName('AVAmtUnitDIM').AsFloat :=
                                 ConvertSDValue(SDExtensionCodes[J],
                                                SDValues[J],
                                                SDExtCategoryList, SDExtCategory);

                          {amt of tax is in sd record directly, eg MT or Fixed amt}
                          {or actually calculate the tax amount based on the ext code}
                          {FXX12231997-8: Even move taxes have a rate (0 or 1),
                                          so must calc them.}

                        FieldByName('TaxAmount').AsFloat :=
                                    CalcSDTax(FieldByName('SDistCode').Text,
                                              HomesteadCodes[J],
                                              SDExtensionCodes[J],
                                              SDCC_OMFlags[J],
                                              FieldByName('AVAmtUnitDIM').AsFloat,
                                              SDRateList, SdExtCategory);

                          {Keep track of the total move tax and other SD tax.}

                        If (Trim(SDExtensionCodes[J]) = SdistEcMT)
                          then TotalSDMoveTax := TotalSDMoveTax + FieldByName('TaxAmount').AsFloat
                          else TotalSDOtherTax := TotalSDOtherTax + FieldByName('TaxAmount').AsFloat;

                      end;  {with PParcelSDValuesRecord(SDAmounts[I])^ do}

                    Post;
                  except
                    Cancel;
                    Quit := True;
                    SystemSupport(050, BLSpecialDistrictTaxTable, 'Error posting SD tax amount.',
                                  UnitName, GlblErrorDlgBox);
                  end;  {with BLSpecialDistrictTaxTable do}

                    {Save this SDist tax in tax totals memory array.}
                    {FXX01061998-6: Don't store a homestead code for SD.}
                    {CHG12172004-1(2.8.1.4): Actually, do store it.}

                with PParcelSDValuesRecord(SDAmounts[I])^ do
                  SaveSDistTaxTotals(SDExtensionCodes[J],
                                     BLSpecialDistrictTaxTable.FieldByName('AVAmtUnitDIM').AsFloat,
                                     HomesteadCodes[J],
                                     SDExtCategory,
                                     HstdAssessedVal, NonhstdAssessedVal,
                                     SDTotalsList);

              end;  {If (Deblank(PParcelSDValuesRecord(SDAmounts[I])^.SDExtensionCodes[J]) <> '')}

       {If there are spcl fees bill them.}

  SPFeeList := TList.Create;

  For I := 0 to (SpecialFeeRateList.Count - 1) do
    with BLSpecialFeeTaxTable, SpecialFeePointer(SpecialFeeRateList.Items[I])^ do
      try
        Insert;

        FieldByName('TaxRollYr').Text := TaxRollYr;
        FieldByName('SwisSBLKey').Text := SwisSBLKey;
        FieldByName('PrintOrder').AsInteger := PrintOrder;

        If (RoundOff(FixedAmount, 2) > 0)
          then FieldByName('TaxAmount').AsFloat := FixedAmount
          else
            begin
                 {must be percentage amount based on total tax}

                {FXX07172001-2: Make sure that the special district amounts are added in
                                when calculating special fees.}

              fTaxAmount := (GeneralTaxOwed + TotalSDMoveTax + TotalSDOtherTax) *
                            (Percentage / 100);
              If _Compare(fTaxAmount, 0, coLessThan)
              then fTaxAmount := 0;

              FieldByName('TaxAmount').AsFloat := fTaxAmount;

              FieldByName('TaxAmount').AsFloat :=
                   RoundOff(FieldByName('TaxAmount').AsFloat, 2);

            end;  {If (RoundOff(FixedAmount, 2) > 0)}

        New(SPFeePtr);

        with SPFeePtr^ do
          begin
            PrintOrder := FieldByName('PrintOrder').AsInteger;
            SPAmount :=  Roundoff(FieldByName('TaxAmount').AsFloat, 2);
          end;

        SPFeeList.Add(SPFeePtr);

           {save this Spcl Fee tax in tax totals memory array}
           {Note that the special fees are added to the total tax owed
            below since we may need to distribute special fees differently
            than regular tax.}

        SaveSpFeeTaxTotals(FieldByName('PrintOrder').AsInteger,
                           Roundoff(FieldByName('TaxAmount').AsFloat, 2),
                           AmtInFirstPayment, SpecialFeeTotalsList);

        Post;
      except
        Quit := True;
        SystemSupport(027, BLSpecialFeeTaxTable,
                      'Post Error on Special Fee Table, SBL =  ' +
                      ExtractSSKey(TYParcelTable),
                      UnitName, GlblErrorDlgBox);
      end;

  DivideTaxAmountIntoPayments(SPFeeList, SpecialFeeRateList, GeneralTaxOwed,
                              TotalSDMoveTax, TotalSDOtherTax);

  FreeTList(SPFeeList, SizeOf(SPFeeTaxRecord));

    {Note that later we will go back through and set the bill numbers after
     they are all done.}

  If (Quit or
      (OnlyBillPositiveAmounts and
       _Compare(BLHeaderTaxTable.FieldByName('TaxPayment1').AsFloat, 0, coEqual)))
    then BLHeaderTaxTable.Cancel
    else BLHeaderTaxTable.Post;

  FreeTList(SDAmounts, SizeOf(ParcelSDValuesRecord));
  ExemptionCodes.Free;
  ExemptionHomesteadCodes.Free;
  ResidentialTypes.Free;
  CountyExemptionAmounts.Free;
  TownExemptionAmounts.Free;
  SchoolExemptionAmounts.Free;
  VillageExemptionAmounts.Free;

end;  {CalcBillThisParcel}

{===================================================================}
Function GetBillNumber(BLHeaderTaxTable : TTable;
                       TaxDue : Double;
                       CollectionType : String;
                       _SwisCode,
                       _SchoolCode : String;
                       IncludeStateLands,
                       IncludeWhollyExempt : Boolean;
                       CtlDtlList : TList) : String;

{Figure out the bill number for this parcel.}

var
  I : Integer;
  NextBillNo : LongInt;
  RollSection : String;

begin
  NextBillNo := 0;

    {If this is roll section 8 and there is no tax due,
     it gets a bill number of zero.
     If not, we will find the detail with this school or swis code and
     get the bill number from there.}

    {FXX12221997-5: Must match on partial or full swis and school code.}
    {FXX01201998-7: Roll section 3 (state taxable lands) does not get bill
                    numbers.}
    {CHG01042006-1(2.9.4.7): Option to number state lands.}

  RollSection := BLHeaderTaxTable.FieldByName('RollSection').Text;

  If ((_Compare(RollSection, '8', coEqual) and
       _Compare(TaxDue, 0, coEqual) and
       (not IncludeWhollyExempt)) or
      (_Compare(RollSection, '3', coEqual) and
       (not IncludeStateLands)))
    then NextBillNo := 0
    else
      If _Compare(CollectionType, SchoolTaxType, coEqual)
        then
          begin
            For I := 0 to (CtlDtlList.Count - 1) do
              with ControlDetailRecordPointer(CtlDtlList[I])^ do
                If SchoolCodesMatch_FullOrPartial(SchoolCode,
                                                  BLHeaderTaxTable.FieldByName('SchoolDistCode').Text)
                  then
                    begin
                      If (CurrentBillNo = 0)
                        then
                          begin
                            NextBillNo := 1;
                            CurrentBillNo := 2;
                          end
                        else
                          begin
                            NextBillNo := CurrentBillNo;
                            CurrentBillNo := CurrentBillNo + 1;
                          end;

                    end;  {If (Take(6, SchoolCode) = Take(6, _SchoolCode))}

          end
        else
          begin
            For I := 0 to (CtlDtlList.Count - 1) do
              with ControlDetailRecordPointer(CtlDtlList[I])^ do
                If SwisCodesMatch_FullOrPartial(SwisCode,
                                                BLHeaderTaxTable.FieldByName('SwisCode').Text)
                  then
                    begin
                      If (CurrentBillNo = 0)
                        then
                          begin
                            NextBillNo := 1;
                            CurrentBillNo := 2;
                          end
                        else
                          begin
                            NextBillNo := CurrentBillNo;
                            CurrentBillNo := CurrentBillNo + 1;
                          end;

                    end;  {If (Take(6, SwisCode) = Take(6, _SwisCode))}

          end;  {else of If (Take(2, CollectionType) = 'SC')}

  If (NextBillNo = 0)
    then Result := ''
    else Result := ShiftRightAddZeroes(Take(6, IntToStr(NextBillNo)));

end;  {GetBillNumber}

{==================================================================}
Procedure TBillCalcForm.NumberBills(    CtlDtlList : TList;
                                        CollectionType : String;
                                    var Quit,
                                        CalculationCancelled : Boolean);

{Go back through the bills and number them in the order that they
 want them numbered.}

var
  ProrataFound, BaseFound,
  NumberProrataAfterBase, Done, FirstTimeThrough : Boolean;
  Index : Integer;
  ProrataSwisSBLKey, SwisSBLKey : String;
  TempBookmark : TBookmark;
  OrigIndexName : String;
  MainBillNo, ProrataBillNo : String;
  SBLRec : SBLRecord;

begin
  Done := False;
  FirstTimeThrough := True;

  ProgressDialog.Reset;
  ProgressDialog.UserLabelCaption := 'Numbering bills.';

    {FXX06301998-7: Reset the progress dialog to the actual number of bills in this
                    run.}

  ProgressDialog.TotalNumRecords := GetRecordCount(BLHeaderTaxTable);

  NumberProrataAfterBase := CollectionControlTable.FieldByName('NumberRS9AfterBase').AsBoolean;

    {Set the index based on the numbering option that they chose.}

  Index := CollectionControlTable.FieldByName('BillingOrder').AsInteger;

     {FXX05061998-4: In order to avoid having 2 sets of keys - one
                     starting with swis and one with school\swis,
                     I created a dummy SchoolCodeKey field which is blank
                     in a municipal billing and has no effect and filled
                     in in a school billing.  We can't just use the regular
                     school code field since we need it in municipal billings
                     to show what school this is.}
     {FXX06301998-8: Restore number by school\swis\rs. keys.}

  with BLHeaderTaxTable do
    case Index of
      0 : IndexName := 'BYSCHOOL_SWIS_RS_SBL';
      1 : IndexName := 'BYSCHOOL_SWIS_RS_NAME';
      2 : IndexName := 'BYSCHOOL_SWIS_RS_ADDR';
      3 : IndexName := 'BYSCHOOL_SWIS_RS_ZIP_SBL';
      4 : IndexName := 'BYSCHOOL_SWIS_RS_ZIP_NAME';
      5 : IndexName := 'BYSCHOOL_SWIS_RS_ZIP_ADDR';
      6 : IndexName := 'BYSCHOOL_SWIS_RS_BANK_SBL';
      7 : IndexName := 'BYSCHOOL_SWIS_RS_BANK_NAME';
      8 : IndexName := 'BYSCHOOL_SWIS_RS_BANK_ADDR';
    end;  {case Index of}

  BLHeaderTaxTable.First;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else BLHeaderTaxTable.Next;

    If BLHeaderTaxTable.EOF
      then Done := True;

    with BLHeaderTaxTable do
      SwisSBLKey := FieldByName('SwisCode').Text + FieldByName('SBLKey').Text;

      {Update the progress dialog.}

    with BLHeaderTaxTable do
      case Index of
        0 : ProgressDialog.Update(Self, ConvertSwisSBLToDashDot(SwisSBLKey));
        1 : ProgressDialog.Update(Self, FieldByName('Name1').Text);
        2 : ProgressDialog.Update(Self, RTrim(FieldByName('LegalAddr').Text) + ' ' +
                                        FieldByName('LegalAddrNo').Text);
        3 : ProgressDialog.Update(Self, FieldByName('ZipCode').Text + '\' +
                                        ConvertSwisSBLToDashDot(SwisSBLKey));
        4 : ProgressDialog.Update(Self, FieldByName('ZipCode').Text + '\' +
                                        FieldByName('Name1').Text);
        5 : ProgressDialog.Update(Self, FieldByName('ZipCode').Text + '\' +
                                        RTrim(FieldByName('LegalAddr').Text) + ' ' +
                                        FieldByName('LegalAddrNo').Text);
        6 : ProgressDialog.Update(Self, FieldByName('BankCode').Text + '\' +
                                        ConvertSwisSBLToDashDot(SwisSBLKey));
        7 : ProgressDialog.Update(Self, FieldByName('BankCode').Text + '\' +
                                        FieldByName('Name1').Text);
        8 : ProgressDialog.Update(Self, FieldByName('BankCode').Text + '\' +
                                        RTrim(FieldByName('LegalAddr').Text) + ' ' +
                                        FieldByName('LegalAddrNo').Text);

      end;  {case Index of}

    CalculationCancelled := ProgressDialog.Cancelled;

    If not (Done or Quit)
      then
        with BLHeaderTaxTable do
          begin
            MainBillNo := '';

              {Set the bill number for this parcel.}
              {FXX04221998-1: Testing on bill number in field, but not set.}
              {CHG04282004-1(2.08): Add option to number bills with account numbers.}

            If (FieldByName('BillNo').Text = '')  {Don't set it if already set.}
              then
                If BillNumbersAreAccountNumbers
                  then MainBillNo := ShiftRightAddZeroes(Take(6, Trim(FieldByName('AccountNumber').Text)))
                  else MainBillNo := GetBillNumber(BLHeaderTaxTable,
                                                   FieldByName('TotalTaxOwed').AsFloat,
                                                   CollectionType,
                                                   FieldByName('SwisCode').Text,
                                                   FieldByName('SchoolDistCode').Text,
                                                   IncludeStateLands,
                                                   IncludeWhollyExempt,
                                                   CtlDtlList);

              {FXX04221998-2: Only look for proratas if the bill number is NOT
                              blank.}

            If (NumberProrataAfterBase and
                (FieldByName('RollSection').Text <> '9') and  {If this is prorata bill, don't renumber base bill.}
                (Deblank(MainBillNo) <> ''))
              then
                begin
                  ProrataSwisSBLKey := '';

                    {Get prorata SBL.}
                    {FXX04221998-3: When looking up in parcel table, must
                                    break up into parts.}

                  SBLRec := ExtractSwisSBLFromSwisSBLKey(SwisSBLKey);

                  with SBLRec do
                    BaseFound := FindKeyOld(TYParcelTable,
                                            ['TaxRollYr', 'SwisCode', 'Section',
                                             'Subsection', 'Block', 'Lot', 'Sublot',
                                             'Suffix'],
                                            [TaxRollYr,
                                             SwisCode, Section,
                                             Subsection, Block,
                                             Lot, Sublot, Suffix]);

                    {FXX04221998-4: Write errors to a message file instead of
                                    to dialog box on the screen.}

                  If BaseFound
                    then ProrataSwisSBLKey := TYParcelTable.FieldByName('RS9LinkedSBL').Text;
(*                    else Writeln(CalcMessageFile, 'Warning! Could not find prorata bill for bill ' +
                                    PresentBillNumber + '.');*)

                    {FXX04221998-5: Only try to get the prorata if found a prorata
                                    SBL key.}

                  If (Deblank(ProrataSwisSBLKey) <> '')
                    then
                      begin
                        TempBookmark := GetBookmark;

                          {Switch to SBL index.}

                        OrigIndexName := IndexName;
                        IndexName := 'BYSCHOOLCODEKEY_SWISCODE_SBL';

                          {FXX12171998-4: Need to only send in the SBLKey part for the
                                          4th part of they key - not the whole swis SBL.}

                        ProrataFound := FindKeyOld(BLHeaderTaxTable,
                                                   ['SchoolCodeKey', 'SwisCode', 'SBLKey'],
                                                   [Take(6, '999999'),
                                                    FieldByName('SwisCode').Text, '9',
                                                    Copy(ProrataSwisSBLKey, 7, 20)]);

                           {FXX04221998-4: Write errors to a message file instead of
                                           to dialog box on the screen.}


(*                        If not ProrataFound
                          then Writeln(CalcMessageFile, 'Warning! Could not find prorata bill for bill ' +
                                          PresentBillNumber + '.');*)

                        If (ProrataFound and
                            (FieldByName('BillNo').Text = ''))  {Don't set it if already set.}
                          then ProrataBillNo := GetBillNumber(BLHeaderTaxTable,
                                                       FieldByName('TotalTaxOwed').AsFloat,
                                                       CollectionType,
                                                       FieldByName('SwisCode').Text,
                                                       FieldByName('SchoolDistCode').Text,
                                                       IncludeStateLands,
                                                       IncludeWhollyExempt,
                                                       CtlDtlList);

                        Edit;
                        FieldByName('BillNo').Text := ProrataBillNo;

                        try
                          Post;
                        except
                          SystemSupport(103, BLHeaderTaxTable, 'Error numbering bill.',
                                        UnitName, GlblErrorDlgBox);
                        end;

                          {Go back to the base bill with the original index.}

                        IndexName := OrigIndexName;

                        GotoBookmark(TempBookmark);
                        FreeBookmark(TempBookmark);

                      end;  {If (Deblank(ProrataSwisSBLKey) <> '')}

                end;  {If (NumberProrataAfterBase and}

              {FXX12221997-6: We were not actually setting the bill number.}

            If (Deblank(MainBillNo) <> '')
              then
                begin
                  Edit;
                  FieldByName('BillNo').Text := MainBillNo;

                  try
                    Post;
                  except
                    SystemSupport(103, BLHeaderTaxTable, 'Error numbering bill.',
                                  UnitName, GlblErrorDlgBox);
                  end;

                end;  {If (Deblank(BillNo) = '')}

          end;  {with BLHeaderTaxTable do}

  until (Done or Quit or CalculationCancelled);

end;  {NumberBills}

{==================================================================}
Procedure TBillCalcForm.CalculateBills(    CollectionType : String;
                                           GeneralRateList,
                                           SDRateList,
                                           SpecialFeeRateList,
                                           SDExtCategoryList,
                                           BillControlDetailList,
                                           GeneralTotalsList,
                                           SDTotalsList,
                                           SchoolTotalsList,
                                           EXTotalsList,
                                           SpecialFeeTotalsList : TList;
                                       var NumBillsCalculated : LongInt;
                                       var NumInactive : Integer;
                                       var Quit : Boolean);

{Calculate all the bills.}

var
  Done, FirstTimeThrough : Boolean;
  TempStr, SwisSBLKey : String;

begin
  Done := False;
  FirstTimeThrough := True;
  ProgressDialog.UserLabelCaption := 'Calculating Bills.';
  ProgressDialog.Start(GetRecordCount(TYParcelTable), True, True);

  UseArrearsFlag := CollectionControlTable.FieldByName('UseArrearsFlag').AsBoolean;

        {CHG12171998-1: If the person wants to assign a special bank code to rs 9,
                        do it here.}

  RS9BankCode := CollectionControlTable.FieldByName('RS9BankCode').Text;

  try
    TYParcelTable.First;
  except
    Quit := True;
    SystemSupport(050, TYParcelTable, 'Error getting first parcel record.',
                  UnitName, GlblErrorDlgBox);
  end;

  repeat
    Application.ProcessMessages;

    If FirstTimeThrough
      then FirstTimeThrough := False
      else
        try
          TYParcelTable.Next;
        except
          Quit := True;
          SystemSupport(050, TYParcelTable, 'Error getting next parcel record.',
                        UnitName, GlblErrorDlgBox);
        end;

    If (TYParcelTable.EOF or
        (TrialRun and
         (NumBillsCalculated > 1000)))
      then Done := True;

    SwisSBLKey := ExtractSSKey(TYParcelTable);

    TempStr := ConvertSwisSBLToDashDot(SwisSBLKey);

      {If we got the parcel record OK and this parcel should get a bill,
       then bill it.}

    If ((not (Done or Quit)) and
        ParcelToBeBilled(CollectionType, BillControlDetailList, SDRateList,
                         SwisSBLKey, NumInactive))
      then
        begin
          NumBillsCalculated := NumBillsCalculated + 1;
          CalcBillThisParcel(CollectionType, GeneralRateList, SDRateList,
                             SpecialFeeRateList, SDExtCategoryList,
                             BillControlDetailList,
                             GeneralTotalsList, SDTotalsList,
                             SchoolTotalsList, EXTotalsList,
                             SpecialFeeTotalsList, Quit);

        end;  {If not (Done or Quit)}

    ProgressDialog.Update(Self, ConvertSwisSBLToDashDot(ExtractSSKey(TYParcelTable)));

    CalculationCancelled := ProgressDialog.Cancelled;

  until (Done or Quit or CalculationCancelled);

    {Now go back and number the bills.}

  If Done
    then NumberBills(BillControlDetailList, CollectionType,
                     Quit, CalculationCancelled);

end;  {CalculateBills}

{===================================================================}
Procedure TBillCalcForm.SaveBillingTotals(    TaxRollYear : String;
                                              CollectionType : String;
                                              CollectionNum : Integer;
                                              GeneralTotalsList,
                                              SDTotalsList,
                                              SchoolTotalsList,
                                              EXTotalsList,
                                              SpecialFeeTotalsList : TList;
                                          var Quit : Boolean);

{Save the billing totals in the totals files}

var
  GeneralTotFileName, SchoolTotFileName,
  SDTotFileName, EXTotFileName,
  SpecialFeeTotFileName : String;
  I : Integer;

begin
  CopyAndOpenTotalsFiles(TaxRollYear, CollectionType,
                         ShiftRightAddZeroes(Take(2, IntToStr(CollectionNum))),
                         'X', GeneralTotalTable, SDTotalTable, SchoolTotalTable,
                         EXTotalTable, SpecialFeeTotalTable,
                         GeneralTotFileName, SchoolTotFileName,
                         SDTotFileName, EXTotFileName,
                         SpecialFeeTotFileName, False, True, Quit);

     {SAVE GENERAL TAX TOTALS}

  For I := 0 to (GeneralTotalsList.Count - 1) do
    begin
      GeneralTotalTable.Insert;

        {The items on the left are fields of the table.
         The items on the right are fields in the pointer record.}

      with GeneralTotalTable, GeneralTotPtr(GeneralTotalsList[I])^ do
        begin
          FieldByName('SwisCode').Text := SwisCode;
          FieldByName('SchoolCode').Text := SchoolCode;
          FieldByName('RollSection').Text := RollSection;
          FieldByName('HomesteadCode').Text := HomesteadCode;
          FieldByName('PrintOrder').AsInteger := PrintOrder;
          FieldByName('ParcelCt').AsInteger := ParcelCt;
          FieldByName('LandAV').AsFloat := LandAV;
          FieldByName('TotalAV').AsFloat := TotalAV;
          FieldByName('ExemptAmt').AsFloat := ExemptAmt;
          FieldByName('TaxableVal').AsFloat := TaxableVal;
          FieldByName('TotalTax').AsFloat := TotalTAx;

             {FXX01061998-5: Track split count.}

          FieldByName('SplitParcelCt').AsInteger := PartCt;

            {FXX05061998-3: Save the STAR amounts for school billings.}

          FieldByName('STARAmount').AsFloat := STARAmount;
          FieldByName('TaxableValAfterSTAR').AsFloat := TaxableValAfterSTAR;

            {FXX05141998-6: Save total STARSavings amount.}

          FieldByName('STARSavings').AsFloat := STARSavings;
          FieldByName('BasicSTARSavings').AsFloat := BasicSTARSavings;
          FieldByName('EnhancedSTARSavings').AsFloat := EnhancedSTARSavings;

        end;  {with GeneralTotalTable, GeneralTotPtr(GeneralTotalsList[I])^ do}

      try
        GeneralTotalTable.Post;
      except
(*        Quit := True; *)
        GeneralTotalTable.Cancel;
(*        SystemSupport(043, GeneralTotalTable,
                      'Post Error on General Tax Total Table, PrintOrder =  ' +
                      GeneralTotalTable.FieldByName('PrintOrder').Text,
                      UnitName, GlblErrorDlgBox); *)
      end;  {end try}

    end;  {For I := 0 to (GeneralTotalsList.Count - 1) do}

     {SAVE SDIST TAX TOTALS}

  For I := 0 to (SdTotalsList.Count - 1) do
    begin
       {The items on the left are fields of the table.
        The items on the right are fields in the pointer record.}

      with SDTotalTable, SDistTotPtr(SDTotalsList[I])^ do
        try
          Insert;

          FieldByName('SwisCode').Text := SwisCode;
          FieldByName('SchoolCode').Text := SchoolCode;
          FieldByName('RollSection').Text := RollSection;
          FieldByName('HomesteadCode').Text := HomesteadCode;
          FieldByName('SdCode').Text := SdCode;
          FieldByName('ExtCode').Text := ExtCode;
          FieldByName('ParcelCt').AsInteger := ParcelCt;
          FieldByName('Value').AsFloat := Value;
          FieldByName('AdValue').AsFloat := ADValue;
          FieldByName('ExemptAmt').AsFloat := ExemptAmt;
          FieldByName('TaxableVal').AsFloat := TaxableVal;
          FieldByName('TotalTax').AsFloat := TotalTAx;

            {FXX01021998-11: The CCOM flag was not being saved.}

          FieldByName('CMFlag').Text := CMFlag;

          Post;
        except
(*          Quit := True; *)
          SDTotalTable.Cancel;
(*          SystemSupport(044, SDTotalTable,
                        'Post Error on Sdist Total Table, SdCode  =  ' +
                        FieldByName('SdCode').Text +
                        ' - ' + FieldByName('ExtCode').Text,
                        UnitName, GlblErrorDlgBox); *)
        end;

    end;  {For I := 0 to (SdTotalsList.Count - 1) do}

     {SAVE SCHOOL TAX TOTALS}

  For I := 0 to (SchoolTotalsList.Count - 1) do
    begin
       {The items on the left are fields of the table.
        The items on the right are fields in the pointer record.}

      with SchoolTotalTable, SchoolTotPtr(SchoolTotalsList[I])^ do
        try
          Insert;

          FieldByName('SwisCode').Text := SwisCode;
          FieldByName('SchoolCode').Text := SchoolCode;
          FieldByName('RollSection').Text := RollSection ;
          FieldByName('HomesteadCode').Text := HomesteadCode ;
          FieldByName('SchoolCode').Text := SchoolCode ;
          FieldByName('ParcelCt').AsInteger := ParcelCt;
          FieldByName('LandAV').AsFloat := LandAV;
          FieldByName('TotalAV').AsFloat := TotalAV;
          FieldByName('ExemptAmt').AsFloat := ExemptAmt;
          FieldByName('TaxableVal').AsFloat := TaxableVal;
          FieldByName('TotalTax').AsFloat := TotalTax;

             {FXX01061998-5: Track split count.}

          FieldByName('SplitParcelCt').AsInteger := PartCt;

            {FXX05061998-3: Save the STAR amounts for school billings.}

          FieldByName('STARAmount').AsFloat := STARAmount;
          FieldByName('TaxableValAfterSTAR').AsFloat := TaxableValAfterSTAR;
          FieldByName('BasicSTARSavings').AsFloat := BasicSTARSavings;
          FieldByName('EnhancedSTARSavings').AsFloat := EnhancedSTARSavings;

          Post;
        except
(*          Quit := True; *)
          SchoolTotalTable.Cancel;
(*          SystemSupport(045, SchoolTotalTable,
                        'Post Error on School Total Table, PrintOrder =  ' +
                        FieldByName('SchoolCode').Text,
                        UnitName, GlblErrorDlgBox); *)
        end;  {end try}

    end;  {For I := 0 to (SchoolTotalsList.Count - 1) do}

     {SAVE EXEMPTION  TAX TOTALS}

  For I := 0 to (ExTotalsList.Count - 1) do
    begin
       {The items on the left are fields of the table.
        The items on the right are fields in the pointer record.}

      with EXTotalTable, ExemptTotPtr(ExTotalsList[I])^ do
        try
          Insert;

          FieldByName('SwisCode').Text := SwisCode;
          FieldByName('SchoolCode').Text := SchoolCode;
          FieldByName('RollSection').Text := RollSection;
          FieldByName('HomesteadCode').Text := HomesteadCode;
          FieldByName('ExCode').Text := ExCode;
          FieldByName('ParcelCt').AsInteger := ParcelCt;
          FieldByName('CountyExAmt').AsFloat := CountyExAmt;
          FieldByName('TownExAmt').AsFloat := TownExAmt;
          FieldByName('VillageExAmt').AsFloat := VillageExAmt;
          FieldByName('SchoolExAmt').AsFloat := SchoolExAmt;

             {FXX01061998-5: Track split count.}

          FieldByName('SplitParcelCt').AsInteger := PartCt;

          Post;
        except
(*          Quit := True;*)
          EXTotalTable.Cancel;
(*          SystemSupport(046, ExTotalTable,
                        'Post Error on Exemption Total Table, ExCode  =  ' +
                        FieldByName('ExCode').Text, UnitName,
                        GlblErrorDlgBox);*)
        end;

    end;  {For I := 0 to (ExTotalsList.Count - 1) do}

    {SAVE SPECIAL FEE TAX TOTALS}

  For I := 0 to (SpecialFeeTotalsList.Count - 1) do
    begin
       {The items on the left are fields of the table.
        The items on the right are fields in the pointer record.}

      with SpecialFeeTotalTable, SpFeeTotPtr(SpecialFeeTotalsList[I])^ do
        try
          Insert;

          FieldByName('SwisCode').Text := SwisCode;
          FieldByName('SchoolCode').Text := SchoolCode;
          FieldByName('RollSection').Text := RollSection;
          FieldByName('PrintOrder').AsInteger := PrintOrder;
          FieldByName('ParcelCt').AsInteger := ParcelCt;
          FieldByName('TotalTax').AsFloat := TotalTax;

          Post;
        except
          Quit := True;
          SystemSupport(047, SpecialFeeTotalTable,
                        'Post Error on Special Fee Tax Total Table, PrintOrder =  ' +
                        FieldByName('PrintOrder').Text,
                        UnitName, GlblErrorDlgBox);
        end;

    end;  {For I := 0 to (SpecialFeeTotalsList.Count - 1) do}

end;  {SaveBillingTotals}

{==================================================================}
Procedure TBillCalcForm.StartButtonClick(Sender: TObject);

{First confirm that this is the collection that they want to calculate
 bills for. If this calculation already exists, then tell them that they
 will lose the data from before. If they still want to continue, delete
 the old file, copy the templates to new files, open the
 files and start the calculation.}

var
  HeaderFileName,
  GeneralFileName,
  EXFileName,
  SDFileName,
  SpecialFeeFileName : String;

  GeneralRateList,
  SDRateList,
  SpecialFeeRateList,
  SDExtCategoryList,
  BillControlDetailList,
  GeneralTotalsList,
  SDTotalsList,
  SchoolTotalsList,
  EXTotalsList,
  SpecialFeeTotalsList : TList;

  Found, OKToStartCalculation, Quit : Boolean;
  NumInactive, CollectionNum : Integer;
  TaxRollYear : String;
  NumBillsCalculated : LongInt;

begin
  bBillZeroSDRates := cbxBillZeroSDRates.Checked;
  IncludeStateLands := IncludeStateLandsCheckBox.Checked;
  IncludeWhollyExempt := IncludeWhollyExemptCheckBox.Checked;
  bWarnAboutBillsWithoutSpecialDistricts := cbxWarnAboutBillsWithoutSpecialDistricts.Checked;
  OKToStartCalculation := True;
  CollectionNum := 1;
  OnlyBillPositiveAmounts := cb_OnlyCreateBillsForPositiveAmounts.Checked;

    {CHG04282004-1(2.08): Add option to number bills with account numbers.}

  BillNumbersAreAccountNumbers := BillNumbersAreAccountNumbersCheckBox.Checked;

   {CHG08172004-2(2.08.0.08182004): Option to have the legal address come from NY.}

  GetLegalAddressFromNextYear := NYLegalAddressCheckBox.Checked;

  If (Deblank(EditTaxRollYear.Text) = '')
    then
      begin
        MessageDlg('Please enter the tax roll year.', mtError, [mbOK], 0);
        OKToStartCalculation := False;
      end;

  If (Deblank(EditCollectionNumber.Text) = '')
    then
      begin
        MessageDlg('Please enter the collection number.', mtError, [mbOK], 0);
        OKToStartCalculation := False;
      end;

  If (Deblank(LookupCollectionType.Text) = '')
    then
      begin
        MessageDlg('Please enter the collection type.', mtError, [mbOK], 0);
        OKToStartCalculation := False;
      end;

    {CHG06302003-5(2.07e): Double check that they have done their bank code imports.}

  If (OKToStartCalculation and
      (MessageDlg('Please make sure that all bank codes have been properly updated before proceeding.' + #13 +
                  'Do you want to continue?', mtConfirmation, [mbYes, mbNo], 0) = idNo))
    then OKToStartCalculation := False;

    {If they have entered all the information, look it up in the bill
     control file to make sure that a collection exists for what they
     entered.}

  If OKToStartCalculation
    then
      begin
        TaxRollYear := Take(4, EditTaxRollYear.Text);
        CollectionType := Take(2, LookupCollectionType.Text);
        CollectionNum := StrToInt(Deblank(EditCollectionNumber.Text));

        try
          Found := FindKeyOld(CollectionControlTable,
                              ['TaxRollYr', 'CollectionType', 'CollectionNo'],
                              [TaxRollYear, CollectionType,
                               IntToStr(CollectionNum)]);
        except
          Found := False;
          OKToStartCalculation := False;
          SystemSupport(010, CollectionControlTable, 'Error getting bill control record.',
                        UnitName, GlblErrorDlgBox);
        end;

        If Found
          then
            begin
(*              If (MessageDlg('You are going to calculate bills for collection type ' + CollectionType + ',' + #13 +
                             'collection number ' + IntToStr(CollectionNum) + '.' + #13 +
                             'All the billing information for prior calculations of ' + #13 +
                             'this billing cycle will be lost.' + #13 +
                             #13 +
                             'Do you want to proceed?',
                             mtConfirmation, [mbYes, mbNo], 0) = idNo)
                then OKToStartCalculation := False; *)

            end
          else
            begin
              MessageDlg('The collection that you entered does not exist.' + #13 +
                         'Please try again.', mtError, [mbOK], 0);
              OKToStartCalculation := False;
            end;

      end;  {If OKToStartCalculation}

    {CHG11062001-1: Confirm the billing \ roll values.}

  If (OKToStartCalculation and
      (not ConfirmRollSetup(AssessmentYearCtlTable, EXCodeTable, SwisCodeTable,
                            'tax', 'calculate', '')))
    then OKToStartCalculation := False;

    {If they entered a collection that exists, then open the billing and
     totals files, get the rates, and start the billing.}

  If OKToStartCalculation
    then
      begin
        Quit := False;
        NumBillsCalculated := 0;
        NumInactive := 0;
        CalculationCancelled := False;

(*        AssignFile(CalcMessageFile, GlblErrorFileDir + 'BLCLCMSG.RPT');  {file for errors}
        Rewrite(CalcMessageFile);*)

         {Create the rate and totals TLists.}

        GeneralRateList := TList.Create;
        SDRateList := TList.Create;
        SpecialFeeRateList := TList.Create;
        SDExtCategoryList := TList.Create;
        BillControlDetailList := TList.Create;
        GeneralTotalsList := TList.Create;
        SDTotalsList := TList.Create;
        SchoolTotalsList := TList.Create;
        EXTotalsList := TList.Create;
        SpecialFeeTotalsList := TList.Create;

          {Copy and open the files for this tax year\municipal type\
           collection #.}

        CopyAndOpenBillingFiles(TaxRollYear, CollectionType,
                                ShiftRightAddZeroes(Take(2, IntToStr(CollectionNum))),
                                BLHeaderTaxTable,
                                BLGeneralTaxTable,
                                BLExemptionTaxTable,
                                BLSpecialDistrictTaxTable,
                                BLSpecialFeeTaxTable,
                                HeaderFileName,
                                GeneralFileName,
                                EXFileName,
                                SDFileName,
                                SpecialFeeFileName, True, Quit);

        If not Quit
          then LoadRateListsFromRateFiles(TaxRollYear, CollectionType,
                                          CollectionNum, GeneralRateList,
                                          SDRateList,
                                          SpecialFeeRateList,
                                          BillControlDetailList, 'C', Quit);

        If not Quit
          then LoadSDExtCategoryList(SDExtCategoryList, Quit);

        If not Quit
          then CalculateBills(CollectionType, GeneralRateList, SDRateList,
                              SpecialFeeRateList,
                              SDExtCategoryList,
                              BillControlDetailList,
                              GeneralTotalsList, SDTotalsList,
                              SchoolTotalsList, EXTotalsList,
                              SpecialFeeTotalsList,
                              NumBillsCalculated, NumInactive, Quit);

         If not (Quit or CalculationCancelled)
           then SaveBillingTotals(TaxRollYear, CollectionType,
                                  CollectionNum, GeneralTotalsList,
                                  SDTotalsList,
                                  SchoolTotalsList, EXTotalsList,
                                  SpecialFeeTotalsList, Quit);

          {Now mark that this calculation is complete or not complete
           in the tax collection header record.}

         with CollectionControlTable do
           try
             Edit;

             If (Quit or CalculationCancelled)
               then FieldByName('CalculationComplete').AsBoolean := False
               else FieldByName('CalculationComplete').AsBoolean := True;

             Post;
           except
             Quit := True;
             SystemSupport(100, CollectionControlTable, 'Error marking collection complete.',
                           UnitName, GlblErrorDlgBox);
           end;

        ProgressDialog.Finish;

        If not (Quit or CalculationCancelled)
          then MessageDlg('The bills were calculated sucessfully.' + #13 +
                          'There were ' + IntToStr(NumBillsCalculated) + ' in this bill calculation.',
                          mtInformation, [mbOK], 0)
          else MessageDlg('The bills were NOT calculated successfully.' + #13 +
                          'Please note that the bills can not be printed until the ' + #13 +
                          'bill calculation has run to completion.',
                          mtError, [mbOK], 0);

          {Close the billing files.}

        BLHeaderTaxTable.Close;
        BLGeneralTaxTable.Close;
        BLExemptionTaxTable.Close;
        BLSpecialDistrictTaxTable.Close;
        BLSpecialFeeTaxTable.Close;

          {Finally free up the rate and totals TLists.}

        FreeTList(GeneralRateList, SizeOf(GeneralRateRecord));
        FreeTList(SDRateList, SizeOf(SDRateRecord));
        FreeTList(SpecialFeeRateList, SizeOf(SpecialFeeRecord));
        FreeTList(SDExtCategoryList, SizeOf(SDExtCategoryRecord));
        FreeTList(BillControlDetailList, SizeOf(ControlDetailRecord));
        FreeTList(GeneralTotalsList, SizeOf(GeneralTotRecord));
        FreeTList(SDTotalsList, SizeOf(SDistTotRecord));
        FreeTList(SchoolTotalsList, SizeOf(SchoolTotRecord));
        FreeTList(EXTotalsList, SizeOf(ExemptTotRecord));
        FreeTList(SpecialFeeTotalsList, SizeOf(SPFeeTotRecord));

(*        CloseFile(CalcMessageFile);*)

      end;  {If OKToStartCalculation}

end;  {StartButtonClick}

{===================================================================}
Procedure TBillCalcForm.CloseButtonClick(Sender: TObject);

begin
  Close;
end;

{===================================================================}
Procedure TBillCalcForm.FormClose(    Sender: TObject;
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