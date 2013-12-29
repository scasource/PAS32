unit Coop_AssessmentRoll;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, DBCtrls, DBTables, DB, Buttons, Grids,
  Wwdbigrd, Wwdbgrid, ExtCtrls, Wwtable, Wwdatsrc, Menus, RPCanvas,
  RPrinter, RPBase, RPFiler, Btrvdlg, wwdblook, Mask,types,pastypes,
  Glblcnst, Gauges,Printrng, RPMemo, RPDBUtil, RPDefine, (*Progress, *)RPTXFilr,
  RPFPrint, RPreview;

type
  TfmCooperativeAssessmentRoll = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    ScrollBox1: TScrollBox;
    TitleLabel: TLabel;
    Panel3: TPanel;
    Label1: TLabel;
    PrintDialog: TPrintDialog;
    Label18: TLabel;
    CollectionLookupTable: TwwTable;
    label16: TLabel;
    Label2: TLabel;
    ScrollBox2: TScrollBox;
    BillCollTypeLookupTable: TwwTable;
    BLSpecialDistrictTaxTable: TTable;
    BLExemptionTaxTable: TTable;
    BLGeneralTaxTable: TTable;
    BLHeaderTaxTable: TTable;
    BLSpecialFeeTaxTable: TTable;
    SchoolTotalsTable: TTable;
    EXTotalsTable: TTable;
    SDTotalsTable: TTable;
    SpecialFeeTotalsTable: TTable;
    AssessmentYearCtlTable: TTable;
    TextFiler: TTextFiler;
    SDCodeTable: TTable;
    ReportPrinter: TReportPrinter;
    ReportFiler: TReportFiler;
    GeneralTotalsTable: TwwTable;
    SwisCodeTable: TTable;
    EXCodeTable: TTable;
    Label6: TLabel;
    RollHeaderTitleEdit: TEdit;
    ParcelTable: TTable;
    Panel5: TPanel;
    PrintButton: TBitBtn;
    CloseButton: TBitBtn;
    rg_PrintOrder: TRadioGroup;
    Label3: TLabel;
    edAssessmentYear: TEdit;
    GroupBox1: TGroupBox;
    PrintFullMarketValueCheckBox: TCheckBox;
    PrintAdditionalLotsCheckBox: TCheckBox;
    ExtractToExcelCheckBox: TCheckBox;
    cb_TotalsOnly: TCheckBox;
    Label27: TLabel;
    DatePrintedEdit: TMaskEdit;
    AssessmentTable: TTable;

    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure PrintButtonClick(Sender: TObject);
    procedure CloseButtonClick(Sender: TObject);
    procedure TextFilerPrint(Sender: TObject);
    procedure ReportPrint(Sender: TObject);
    procedure HeaderInformationExit(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    UnitName : String;
    PrintingCancelled : Boolean;

    GeneralRateList,
    SDRateList,
    SpecialFeeRateList,
    BillControlDetailList,
    SDExtCategoryList,
    PropertyClassDescList,
    RollSectionDescList,
    EXCodeDescList,
    SDCodeDescList,
    SDExtCodeDescList,
    SwisCodeDescList,
    SchoolCodeDescList : TList;

    SelectedRollSections,
    CL1List,
    CL2List,
    CL3List,
    CL4List,
    CL5List,
    CL6List,
    CL7List : TStringList;

    FoundCollectionRec : Boolean;
    CollectionType : String;
    NumBillsPrinted : LongInt;
    LastRollSection : String;
    LastSwisCode,
    LastSchoolCode : String;
    SequenceStr : String;  {Text of what order the roll is printing in.}
    RollPrintingYear : String;
    TaxRollYr : String;  {What tax roll year should we use for this collection?}
    ProcessingType, NumberGeneralRates, PrintOrder : Integer;
    TotalsOnly : Boolean;
    CollectionHasSchoolTax, PrintAdditionalLots, ExtractToExcel : Boolean;
    ExtractFile : TextFile;
    Duplexing, SuppressSDExtensions, GroupByAccountNumber : Boolean;

    Procedure InitializeForm;  {Open the tables and setup.}

    Procedure LoadSDRateList(    SDRateList : TList;
                                 SelectedRollSections : TStringList;
                             var Quit : Boolean);

    Function ParcelToBeBilled(    ParcelTable : TTable;
                                  RollSectionsSelected : TStringList;
                              var NumInactive : LongInt) : Boolean;
    {Check to see if this parcel should get a bill or not. The criteria are:
       1. The parcel must be active.
       2. This is a roll section that they want to see.}

    Procedure SaveEXTaxTotals(ExemptionCodes,
                              ExemptionHomesteadCodes,
                              CountyExemptionAmounts,
                              TownExemptionAmounts,
                              SchoolExemptionAmounts,
                              VillageExemptionAmounts : TStringList;
                              CollectionType : String;
                              EXTotList : TList);
    {Save the exemption totals for this parcel.}

    Procedure SaveGenTaxTotals(LandAssessedVal,
                               TotalAssessedVal,
                               _TaxableVal,
                               ExemptionAmount,
                               BasicSTARAmount,
                               EnhancedSTARAmount : Comp;
                               CollectionType : String;
                               PrintOrder : Integer;
                               _HomesteadCode : String;
                               ClassRecordFound,
                               FirstTimeForParcel : Boolean;
                               GeneralTotList : TList);
    {Save one general tax total for this parcel.}

    Procedure SaveSchTaxTotals(LandAssessedVal,
                               TotalAssessedVal,
                               ExemptionAmount,
                               BasicSTARAmount,
                               EnhancedSTARAmount : Comp;
                               CollectionType : String;
                               _HomesteadCode : String;
                               ClassRecordFound,
                               FirstTimeForParcel : Boolean;
                               SchoolTotList : TList);
    {Save one school tax total.}

    Procedure InsertGeneralTaxRecord(    ParcelTable : TTable;
                                         TaxRollYr : String;
                                         GeneralRateRec : GeneralRateRecord;
                                         HomesteadCode : String;
                                         EXTotArray : ExemptionTotalsArrayType;
                                         EXIdx : Integer;  {EXCounty, EXTown, EXSchool, EXVillage}
                                         LandAssessedVal,
                                         TotalAssessedVal,
                                         BasicSTARAmount,
                                         EnhancedSTARAmount : Comp;
                                         CollectionType : String;
                                         GeneralTotalsList,
                                         SchoolTotalsList : TList;
                                         ClassRecordFound,
                                         FirstTimeForParcel : Boolean;
                                     var Quit : Boolean);
    {Insert one general tax record for this parcel.}

    Function ConvertSDValue(     ExtCode : String;
                                 SDValue : String;
                                 ExtCatList : TList;
                             var ExtCategory : String) : Double;
    {convert the spcl dist string list value to numeric depending on }
    {spcl dist type, with appropriate decimal points, eg all types but}
    {advalorum get 2 decimal points, eg acreage, fixed, unitary}

    Procedure GetSDValues(    SDExtCategory : String;
                              SDExtension : String;
                              HomesteadCode : String;
                              HstdLandVal,
                              NonhstdLandVal,
                              HstdAssessedVal,
                              NonhstdAssessedVal,
                              TaxableVal : Comp;
                          var ExemptionAmount : Comp;
                          var ADValorumAmount,
                              ValueAmount : Extended);

    {Given the extension category, figure out the advalorum amount or value amount,
     exemption amount and total tax for this special district.}

    Procedure SaveSDistTaxTotals(ExtCode : String;
                                 TaxableValAmount : Double;
                                 _HomesteadCode : String;
                                 SDExtCategory: String;
                                 HstdLandVal,
                                 NonhstdLandVal,
                                 HstdAssessedVal,
                                 NonhstdAssessedVal : Comp;
                                 ParcelHomesteadCode : String;
                                 SDTotList : TList);
    {Save the special district totals for this extension.}

    Procedure SaveInfoThisParcel(     CollectionType : String;
                                      GeneralRateList,
                                      SDRateList,
                                      SDExtCategoryList,
                                      GeneralTotalsList,
                                      SDTotalsList,
                                      SchoolTotalsList,
                                      EXTotalsList : TList;
                                      ParcelTable : TTable;
                                      TaxRollYear : String;
                                      ProcessingType : Integer;
                                      PrintCoopTotals : Boolean;
                                      CoopTotalsList : TList;
                                      PrintPermits : Boolean;
                                  var Quit : Boolean);
    {Calculate the bill for one parcel and store the totals in the totals lists.}

    Procedure SaveBillingTotals(    GeneralTotalsList,
                                    SDTotalsList,
                                    SchoolTotalsList,
                                    EXTotalsList : TList;
                                var Quit : Boolean);
    {Save the billing totals in the totals files}

    Procedure SortFiles(    GeneralRateList,
                            SDRateList,
                            SDExtCategoryList : TList;
                            ParcelTable : TTable;
                            TaxRollYear : String;
                            ProcessingType : Integer;
                        var Quit : Boolean);

    Procedure PrintTotalsByBuilding(Sender : TObject;
                                    lst_TotalsByCooperative : TList);

  end;

  rec_TotalsByCooperative = record
    BuildingID : String;
    Amount : Double;
  end;

  ptr_TotalsByCooperative = ^rec_TotalsByCooperative;


implementation

uses GlblVars, WinUtils, Utilitys,PASUTILS, UTILEXSD, Preview,
     Prog, RptDialg,
     UtilBill,  {Billing specific utilities.}
     Utrtotpt, Prcllist;  {Section totals print unit}

const
  poParcelID = 0;
  poAccountNumber = 1;

{$R *.DFM}

{========================================================}
Procedure TfmCooperativeAssessmentRoll.FormActivate(Sender: TObject);

begin
  SetFormStateMaximized(Self);
end;

{========================================================}
Procedure TfmCooperativeAssessmentRoll.InitializeForm;

var
  I : Integer;

begin
  UnitName := 'Coop_TaxRoll';  {mmm}

    {FXX06231998-3: Put in changes to allow for Westchester billing off NY.}

  TaxRollYr := DetermineBillingTaxYear;
  ProcessingType := GetProcessingTypeForTaxRollYear(TaxRollYr);

    {Note that the billing tax and totals files do not get opened below.
     They get opened once the person fills in the collection type and
     number.}

  OpenTablesForForm(Self, ProcessingType);

  edAssessmentYear.Text := TaxRollYr;

  If GlblIsWestchesterCounty
    then edAssessmentYear.Text := GlblNextYear
    else edAssessmentYear.Text := GlblThisYear;

   {FXX06181999-12: Allow the user to select the date of the roll printing.}

  DatePrintedEdit.Text := DateToStr(Date);

end;  {InitializeForm}

Procedure TfmCooperativeAssessmentRoll.HeaderInformationExit(Sender: TObject);

begin

end;  {HeaderInformationExit}

{===================================================================}
Procedure TfmCooperativeAssessmentRoll.FormKeyPress(    Sender: TObject;
                                     var Key: Char);

begin
  If (Key = #13)
    then
      begin
        Key := #0;
        Perform(WM_NEXTDLGCTL, 0, 0);
      end;

end;  {FormKeyPress}

{==================================================================}
Procedure LoadGeneralRateList(_SwisCode : String;
                              GeneralRateList : TList;
                              CollectionType : String);

{Add the following "General" taxes - county taxable val, town, school,
 village. This is because the tenative and final rolls show the
 taxable values rather than any general tax amount.}

var
  PGeneralRatePtr : GeneralRatePointer;

begin
    {FXX05271998-2: Only show school taxable value for school roll.}
    {FXX06021998-2: Actually show school taxable val in all cases,
                    but only show county and town in munic.}
    {FXX03241999-1: Need to add in the general tax type.}
    {FXX03241999-2: Need to add in swis - do 1st 4 digits since no actual rate.}

    {FXX10312001-1: Not limiting the individual values printed.}

  If (mtpSchool in MunicipalitiesToPrint)
    then
      begin
        New(PGeneralRatePtr);
        with PGeneralRatePtr^ do
          begin
            SwisCode := _SwisCode;
            PrintOrder := 4;
            Description := 'SCHOOL TAXABLE';
            HomesteadRate := 0;
            NonhomesteadRate := 0;
            GeneralTaxType := 'SC';
          end;  {with PGeneralRatePtr^ do}

        GeneralRateList.Add(PGeneralRatePtr);

      end;  {If (mtpSchool in MunicipalitiesToPrint)}

  If (mtpCounty in MunicipalitiesToPrint)
    then
      begin
        New(PGeneralRatePtr);
        with PGeneralRatePtr^ do
          begin
            SwisCode := _SwisCode;
            PrintOrder := 1;
            Description := 'COUNTY TAXABLE';
            HomesteadRate := 0;
            NonhomesteadRate := 0;
            GeneralTaxType := 'CO';
          end;  {with PGeneralRatePtr^ do}

        GeneralRateList.Add(PGeneralRatePtr);

      end;  {If (mtpCounty in MunicipalitiesToPrint)}

  If (mtpTown in MunicipalitiesToPrint)
    then
      begin
        New(PGeneralRatePtr);
        with PGeneralRatePtr^ do
          begin
            SwisCode := _SwisCode;
            PrintOrder := 2;

            case GlblMunicipalityType of
              MTCity : Description := 'CITY TAXABLE';
              MTVillage : Description := 'VILLAGE TAXABLE';
              else Description := 'TOWN TAXABLE';
            end;  {case GlblMunicipalityType of}

            HomesteadRate := 0;
            NonhomesteadRate := 0;

            GeneralTaxType := 'TO';

          end;  {with PGeneralRatePtr^ do}
        GeneralRateList.Add(PGeneralRatePtr);

      end;  {If (mtpTown in MunicipalitiesToPrint)}

    {CHG03232004-1(2.08): Fix up taxable value type selection \ printing on rolls.}

  If (mtpPartialVillage in MunicipalitiesToPrint)
    then
      begin
        New(PGeneralRatePtr);
        with PGeneralRatePtr^ do
          begin
            SwisCode := _SwisCode;
            PrintOrder := 3;
            Description := 'VILLAGE TAXABLE';
            HomesteadRate := 0;
            NonhomesteadRate := 0;
            GeneralTaxType := 'VI';

          end;  {with PGeneralRatePtr^ do}
          
        GeneralRateList.Add(PGeneralRatePtr);

      end;  {If (mtpPartialVillage in MunicipalitiesToPrint)}

end;  {LoadGeneralRateList}

{==================================================================}
Procedure TfmCooperativeAssessmentRoll.LoadSDRateList(    SDRateList : TList;
                                                 SelectedRollSections : TStringList;
                                             var Quit : Boolean);

var
  Done, FirstTimeThrough, AddSDRateToList : Boolean;
  TempFieldName : String;
  I : Integer;
  SDRatePtr : SDRatePointer;
  ExtensionCode : String;

begin
  Done := False;
  FirstTimeThrough := True;

  SDCodeTable.First;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else
        try
          SDCodeTable.Next;
        except
          Quit := True;
          SystemSupport(003, SDCodeTable, 'Error getting parcel record.',
                        UnitName, GlblErrorDlgBox);
        end;

    If SDCodeTable.EOF
      then Done := True;

      {FXX052 71998-5: Only include SDs in the list for school if
                      they apply to school.}

    AddSDRateToList := False;

    If (CollectionType = 'SC')
      then
        begin
          If SDCodeTable.FieldByName('AppliesToSchool').AsBoolean
            then AddSDRateToList := True;
        end
      else AddSDRateToList := True;

      {If rs 9 print, only show pro-rata sd's.}

    If (AddSDRateToList and
        (SelectedRollSections.Count = 1) and
        (SelectedRollSections[0] = '9'))
      then AddSDRateToList :=  SDCodeTable.FieldByName('SDRs9').AsBoolean;

    If ((not (Done or Quit)) and
        AddSDRateToList)
      then
        For I := 1 to 10 do
          begin
            TempFieldName := 'ECd' + IntToStr(I);
            ExtensionCode := SDCodeTable.FieldByName(TempFieldName).Text;

            TempFieldName := 'ECFlg' + IntToStr(I);

            If (Deblank(ExtensionCode) <> '')
              then
                begin
                  New(SDRatePtr);

                  with SDRatePtr^ do
                    begin
                      SDistCode := SDCodeTable.FieldByName('SDistCode').Text;
                      ExtCode := Take(2, ExtensionCode);
                      CMFlag := Take(1, SDCodeTable.FieldByName(TempFieldName).Text);
                      Description := Take(20, SDCodeTable.FieldByName('Description').Text);
                      HomesteadRate := 0;
                      NonhomesteadRate := 0;

                    end;  {with SDRatePtr^ do}

                  SDRateList.Add(SDRatePtr);

                end;  {If (Deblank(ExtensionCode) <> '')}

          end;  {For I := 1 to 10 do}

  until (Done or Quit);

end;  {LoadSDRateList}

{==================================================================}
{===============   FILL THE SORT FILES ============================}
{===================================================================}
Function TfmCooperativeAssessmentRoll.ParcelToBeBilled(    ParcelTable : TTable;
                                                  RollSectionsSelected : TStringList;
                                              var NumInactive : LongInt) : Boolean;

{Check to see if this parcel should get a bill or not. The criteria are:
   1. The parcel must be active.
   2. This is a roll section that they want to see.}

var
  I : Integer;
  Found : Boolean;
  SwisSBLKey : String;

begin
  Result := False;

  For I := 0 to (RollSectionsSelected.Count - 1) do
    If (ParcelTable.FieldByName('RollSection').Text = RollSectionsSelected[I])
      then Result := True;

    {Make sure that the parcel is active.}

  If (ParcelTable.FieldByName('ActiveFlag').Text = InactiveParcelFlag)
    then
      begin
        Result := False;
        NumInactive := NumInactive + 1;
      end;

end;  {ParcelToBeBilled}

{===================================================================}
Function FoundEXEntry(    SwisCode : String;
                          SchoolCode : String;
                          RollSection : String;
                          HomeSteadCode : String;
                          ExCode : String;
                          EXTotList : Tlist;
                      var Index : Integer) : Boolean;

var
  I : Integer;

begin
  Index := -1;
  Result := False;

  For I := 0 to (EXTotList.Count - 1) do
    If ((Take(6, SwisCode) = ExemptTotPtr(EXTotList[I])^.SwisCode) and
        (Take(6, SchoolCode) = ExemptTotPtr(EXTotList[I])^.SchoolCode) and
        (Take(1, RollSection) = ExemptTotPtr(EXTotList[I])^.RollSection) and
        (Take(1, HomesteadCode) = ExemptTotPtr(EXTotList[I])^.HomesteadCode) and
        (Take(5, EXCode) = ExemptTotPtr(EXTotList[I])^.EXCode))
       then
         begin
           Index := I;
           Result := True;
         end;

end;  {FoundEXEntry}

{===================================================================}
Procedure TfmCooperativeAssessmentRoll.SaveEXTaxTotals(ExemptionCodes,
                                              ExemptionHomesteadCodes,
                                              CountyExemptionAmounts,
                                              TownExemptionAmounts,
                                              SchoolExemptionAmounts,
                                              VillageExemptionAmounts : TStringList;
                                              CollectionType : String;
                                              EXTotList : TList);

{Save the exemption totals for this parcel.}

var
  Index, I : Integer;
  EXTotPtr : ExemptTotPtr;
  _SchoolCode : String;
  Amount1, Amount2, Amount3 : Comp;

begin
     {We will only fill in the school code if this is a school
      collection for this totals type. This way, we don't end up
      with totals records broken down by swis and school for
      municipal or village collections.}

  If (CollectionType = 'SC')
    then _SchoolCode := BLHeaderTaxTable.FieldByName('SchoolDistCode').Text
    else _SchoolCode := Take(6, '');

  For I := 0 to (ExemptionCodes.Count - 1) do
    begin
        {FXX05301998-2: Don't show the exemption if it is zero for this
                        taxing purpose.}

      Amount1 := 0;
      Amount2 := 0;
      Amount3 := 0;

      If (CollectionType = 'MU')
        then
          begin
            Amount1 := StrToFloat(CountyExemptionAmounts[I]);
            Amount2 := StrToFloat(TownExemptionAmounts[I]);
            Amount3 := StrToFloat(SchoolExemptionAmounts[I]);
          end;

      If (CollectionType = 'SC')
        then Amount1 := StrToFloat(SchoolExemptionAmounts[I]);

      If (CollectionType = 'VI')
        then Amount1 := StrToFloat(VillageExemptionAmounts[I]);

      If ((Amount1 > 0) or
          (Amount2 > 0) or
          (Amount3 > 0))
        then
          with BLHeaderTaxTable do
            If FoundEXEntry(FieldByName('SwisCode').Text,
                            _SchoolCode,
                            FieldByName('RollSection').Text,
                            ExemptionHomesteadCodes[I],
                            ExemptionCodes[I], EXTotList, Index)
              then
                with ExemptTotPtr(EXTotList[Index])^ do
                  begin
                       {Item exists so add to totals}

                    ParcelCt := ParcelCt + 1;
                    CountyExAmt := CountyExAmt + StrToFloat(CountyExemptionAmounts[I]);
                    TownExAmt := TownExAmt + StrToFloat(TownExemptionAmounts[I]);
                    SchoolExAmt := SchoolExAmt + StrToFloat(SchoolExemptionAmounts[I]);
                    VillageExAmt := VillageExAmt + StrToFloat(VillageExemptionAmounts[I]);

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

                     end;  {with EXTotPtr^. do}

                  EXTotList.add(EXTotPtr);

                end;  {else of If FoundEXEntry(FieldByName('SwisCode').Text, ...}

    end;  {For I := 0 to (ExemptionCodes.Count - 1) do}

end;  {SaveEXTaxTotals}

{===================================================================}
Function FoundGeneralEntry(    SwisCode : String;
                               SchoolCode : String;
                               RollSection : String;
                               HomesteadCode : String;
                               GNTotList : Tlist;
                           var Index : Integer) : Boolean;

{Look through the general totals list for this particular general tax.}

var
  I : Integer;

begin
  Index := -1;
  Result := False;

  For I := 0 to (GNTotList.Count - 1) do
    If ((Take(6, SwisCode) = GeneralAssessmentTotPtr(GnTotList[I])^.SwisCode) and
        (Take(6,SchoolCode) = GeneralAssessmentTotPtr(GnTotList[I])^.SchoolCode) and
        (Take(1, RollSection) = GeneralAssessmentTotPtr(GnTotList[I])^.RollSection) and
        (Take(1, HomesteadCode) = GeneralAssessmentTotPtr(GnTotList[I])^.HomesteadCode))
      then
        begin
          Index := I;
          Result := True;
        end;

end;  {FoundGeneralEntry}

{===================================================================}
Procedure TfmCooperativeAssessmentRoll.SaveGenTaxTotals(LandAssessedVal,
                                               TotalAssessedVal,
                                               _TaxableVal,
                                               ExemptionAmount,
                                               BasicSTARAmount,
                                               EnhancedSTARAmount : Comp;
                                               CollectionType : String;
                                               PrintOrder : Integer;
                                               _HomesteadCode : String;
                                               ClassRecordFound,
                                               FirstTimeForParcel : Boolean;
                                               GeneralTotList : TList);

{Save one general tax total for this parcel.}

var
  Index : Integer;
  GnTotPtr : GeneralAssessmentTotPtr;
  _SchoolCode : String;
  TempSTARAmount : Comp;

begin
     {We will only fill in the school code if this is a school
      collection for this totals type. This way, we don't end up
      with totals records broken down by swis and school for
      municipal or village collections.}

  If (CollectionType = 'SC')
    then _SchoolCode := BLHeaderTaxTable.FieldByName('SchoolDistCode').Text
    else _SchoolCode := Take(6, '');

  If FoundGeneralEntry(BLHeaderTaxTable.FieldByName('SwisCode').Text,
                       _SchoolCode,
                       BLHeaderTaxTable.FieldByName('RollSection').Text,
                       _HomesteadCode,
                       GeneralTotList, Index)
    then
      with GeneralAssessmentTotPtr(GeneralTotList[Index])^ do
        begin
             {item exists so add to totals}
             {FXX01191998-9: Don't increase the parcel count or AV
                             since this was already recorded.}

          If FirstTimeForParcel
            then
              begin
                ParcelCt := ParcelCt + 1;
                LandAV := LandAV + LandAssessedVal;
                TotalAV := TotalAV + TotalAssessedVal;

                  {FXX01191998-10: Track splits.}

                If ClassRecordFound
                  then PartCt := PartCt + 1;

              end;  {If FirstTimeForParcel}

          case PrintOrder of
            EXCounty : CountyTaxableVal := CountyTaxableVal + _TaxableVal;
            EXTown : TownTaxableVal := TownTaxableVal + _TaxableVal;
            EXSchool :
              begin
                   {FXX06021998-5: Show STAR amounts for all rolls.}

                TempSTARAmount := BasicSTARAmount + EnhancedSTARAmount;
                STARAmount := STARAmount + TempSTARAmount;

                  {FXX05141998-5: Don't subtract the variable STARAmount since
                                  it is a total of STAR so far.}

                ExemptAmt := ExemptAmt + ExemptionAmount - TempSTARAmount;

                  {FXX05141998-4: Need to subtract ExemptionAmount - STARAmount
                                  rather than
                                  ExemptionAmount because ExemptionAmount includes
                                  STAR and we want to get TV before STAR.}

                SchoolTaxableVal := SchoolTaxableVal + TotalAssessedVal -
                                    (ExemptionAmount - TempSTARAmount);

                  {FXX05141998-3: Should be subtracting, not adding exemption
                                  amt. since taking from orig AV.}

                TaxableValAfterSTAR := TaxableValAfterSTAR +
                                       (TotalAssessedVal - ExemptionAmount);

              end;  {EXSchool}

            EXVillage : VillageTaxableVal := VillageTaxableVal + _TaxableVal;

          end;  {case BLHeaderTaxTable.FieldByName('PrintOrder')AsInteger of}


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
            ParcelCt := 1;

              {FXX01191998-10: Track parcel split count.}

            If ClassRecordFound
              then PartCt := 1
              else PartCt := 0;

            LandAV := LandAssessedVal;
            TotalAV := TotalAssessedVal;
            ExemptAmt := 0;
            CountyTaxableVal := 0;
            TownTaxableVal := 0;
            SchoolTaxableVal := 0;

              {FXX06021998-5: Show STAR amounts for all rolls.}

            case PrintOrder of
              EXCounty : CountyTaxableVal := _TaxableVal;
              EXTown : TownTaxableVal := _TaxableVal;
              EXSchool :
                begin
                  STARAmount := BasicSTARAmount + EnhancedSTARAmount;
                  ExemptAmt := ExemptionAmount - STARAmount;

                    {FXX05141998-4: Need to subtract ExemptAmt above rather than
                                    ExemptionAmount because ExemptionAmount includes
                                    STAR and we want to get TV before STAR.}

                  SchoolTaxableVal := TotalAssessedVal - ExemptAmt;
                  TaxableValAfterSTAR := TotalAssessedVal - ExemptionAmount -
                                         STARAmount;

                end;  {EXSchool}

              EXVillage : VillageTaxableVal := _TaxableVal;

            end;  {case PrintOrder of}

          end;  {with GnTotPtr^ do}

        GeneralTotList.Add(GNTotPtr);

      end;  {else of If FoundGeneralEntry(BLHeaderTaxTable.FieldByName('SwisCode').Text, ...}

end;  {SaveGenTaxTotals}

{===================================================================}
Procedure TfmCooperativeAssessmentRoll.InsertGeneralTaxRecord(    ParcelTable : TTable;
                                                         TaxRollYr : String;
                                                         GeneralRateRec : GeneralRateRecord;
                                                         HomesteadCode : String;
                                                         EXTotArray : ExemptionTotalsArrayType;
                                                         EXIdx : Integer;  {EXCounty, EXTown, EXSchool, EXVillage}
                                                         LandAssessedVal,
                                                         TotalAssessedVal,
                                                         BasicSTARAmount,
                                                         EnhancedSTARAmount : Comp;
                                                         CollectionType : String;
                                                         GeneralTotalsList,
                                                         SchoolTotalsList : TList;
                                                         ClassRecordFound,
                                                         FirstTimeForParcel : Boolean;
                                                     var Quit : Boolean);

{Insert one general tax record for this parcel.}

begin
  with BLGeneralTaxTable do
    try
      Insert;

      FieldByName('TaxRollYr').Text := TaxRollYr;
      FieldByName('SwisSBLKey').Text := Take(26, ExtractSSKey(ParcelTable));
      FieldByName('PrintOrder').AsInteger := GeneralRateRec.PrintOrder;
      FieldByName('HomesteadCode').Text := Take(1, HomesteadCode);

        {subtract exemption amt from assessed val to get taxable val}

      FieldByName('TaxableValue').AsFloat := (TotalAssessedVal - ExTotArray[ExIdx]);

      Post;
    except
      Quit := True;
      SystemSupport(051, BLGeneralTaxTable, 'Error inserting general tax record.',
                    UnitName, GlblErrorDlgBox);
    end;

        {Save this general tax in tax totals memory array.}

  SaveGenTaxTotals(LandAssessedVal, TotalAssessedVal,
                   TotalAssessedVal - ExTotArray[ExIdx], EXTotArray[EXIdx],
                   BasicSTARAmount, EnhancedSTARAmount, CollectionType,
                   BLGeneralTaxTable.FieldByName('PrintOrder').AsInteger,
                   HomesteadCode, ClassRecordFound,
                   FirstTimeForParcel, GeneralTotalsList);

    {Save school totals even though this may be a munic collection
     because school av, tv, ex are reported on city/town roll}

  SaveSchTaxTotals(LandAssessedVal, TotalAssessedVal, ExTotArray[ExSchool],
                   BasicSTARAmount, EnhancedSTARAmount, CollectionType,
                   HomesteadCode, ClassRecordFound,
                   FirstTimeForParcel, SchoolTotalsList);

end;  {InsertGeneralTaxRecord}

{===================================================================}
Function FoundSchoolEntry(    SwisCode : String;
                              RollSection : String;
                              HomeSteadCode : String;
                              SchoolCode : String;
                              ScTotList : TList;
                          var Index : Integer) : Boolean;

var
  I : Integer;

begin
  Index := -1;
  Result := False;

  For I := 0 to (ScTotList.Count - 1) do
    If ((Take(6, SwisCode) = SchoolTotPtr(ScTotList[I])^.SwisCode) and
        (Take(1,RollSection) = SchoolTotPtr(ScTotList[I])^.RollSection) and
        (Take(1,HomeSteadCode) = SchoolTotPtr(ScTotList[I])^.HomesteadCode) and
        (Take(6,Schoolcode) = SchoolTotPtr(ScTotList[I])^.SchoolCode))
      then
        begin
           Index := I;
           Result := True;
         end;

end;  {FoundSchoolEntry}

{===================================================================}
Procedure TfmCooperativeAssessmentRoll.SaveSchTaxTotals(LandAssessedVal,
                                               TotalAssessedVal,
                                               ExemptionAmount,
                                               BasicSTARAmount,
                                               EnhancedSTARAmount : Comp;
                                               CollectionType : String;
                                               _HomesteadCode : String;
                                               ClassRecordFound,
                                               FirstTimeForParcel : Boolean;
                                               SchoolTotList : TList);

{Save one school tax total.}

var
  Index : Integer;
  ScTotPtr : SchoolTotPtr;
  TempSTARAmount : Comp;

begin
  If FoundSchoolEntry(BLHeaderTaxTable.FieldByName('SwisCode').Text,
                      BLHeaderTaxTable.FieldByName('RollSection').Text,
                      _HomesteadCode,
                      BLHeaderTaxTable.FieldByName('SchoolDistCode').Text,
                      SchoolTotList, Index)
    then
      begin
          {item exists so add to totals}
        with SchoolTotPtr(SchoolTotList[Index])^ do
          begin
               {FXX01191998-9: Don't increase the parcel count or AV
                               since this was already recorded.}

            If FirstTimeForParcel
              then
                begin
                  ParcelCt := ParcelCt + 1;
                  LandAV := LandAV + LandAssessedVal;
                  TotalAV := TotalAV + TotalAssessedVal;

                    {FXX06021998-5: PrintSTAR amounts for all rolls.}

                  TempSTARAmount := BasicSTARAmount + EnhancedSTARAmount;
                  STARAmount := STARAmount + TempSTARAmount;

                    {FXX05141998-5: Don't subtract the variable STARAmount since
                                    it is a total of STAR so far.}

                  ExemptAmt := ExemptAmt + ExemptionAmount - TempSTARAmount;

                    {FXX05141998-4: Need to subtract ExemptionAmount - STARAmount
                                    rather than
                                    ExemptionAmount because ExemptionAmount includes
                                    STAR and we want to get TV before STAR.}

                  TaxableVal := TaxableVal + TotalAssessedVal -
                                (ExemptionAmount - TempSTARAmount);

                    {FXX05141998-3: Should be subtracting, not adding exemption
                                    amt. since taking from orig AV.}

                  TaxableValAfterSTAR := TaxableValAfterSTAR +
                                         (TotalAssessedVal - ExemptionAmount);

                    {FXX01191998-10: Track splits.}

                  If ClassRecordFound
                    then PartCt := PartCt + 1;

                end;  {If FirstTimeForParcel}

          end;  {with SchoolTotPtr(SchoolTotList[Index])^ do}

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

              {FXX01191998-10: Track split count.}

            If ClassRecordFound
              then PartCt := 1
              else PartCt := 0;

            LandAV := LandAssessedVal;
            TotalAV := TotalAssessedVal;

              {Print STAR amounts for all rolls.}

            STARAmount := BasicSTARAmount + EnhancedSTARAmount;
            ExemptAmt := ExemptionAmount - STARAmount;

              {FXX05141998-4: Need to subtract ExemptAmt above rather than
                              ExemptionAmount because ExemptionAmount includes
                              STAR and we want to get TV before STAR.}

            TaxableVal := TotalAssessedVal - ExemptAmt;
            TaxableValAfterSTAR := TotalAssessedVal - ExemptionAmount -
                                   STARAmount;

            TotalTax := 0;

          end;  {with SCTotPtr do}

        SchoolTotList.Add(ScTotPtr);

      end;  {If FoundScEntry(BLHeaderTaxTable.FieldByName('SwisCode').Text, ...}

end;  {SaveSchTaxTotals}

{===================================================================}
Function TfmCooperativeAssessmentRoll.ConvertSDValue(     ExtCode : String;
                                                 SDValue : String;
                                                 ExtCatList : Tlist;
                                             var ExtCategory : String) : Double;

{convert the spcl dist string list value to numeric depending on }
{spcl dist type, with appropriate decimal points, eg all types but}
{advalorum get 2 decimal points, eg acreage, fixed, unitary}

var
  TempReal : Double;

begin
  Result := 0;

  ExtCategory := GetSDExtCategory(ExtCode, ExtCatList);

  If (Deblank(ExtCategory) <> '')
    then
      begin
           {Ad Valorum assessval has no decimal pts, all other do}

        If _Compare(SDValue, coNotBlank)
          then
            try
              TempReal := StrToFloat(Trim(SDValue));
            except
              TempReal := 0;
            end
          else TempReal := 0;

        If (Take(4, ExtCategory) = SDistCategoryADVL)
          then Result := RoundOff(TempReal, 0)
          else Result := RoundOff(TempReal, 3);

      end
    else
      begin
        NonBtrvSystemSupport(998, 99,
                             'SD Ext Code TAble Lacks Category Code: code =  ' + ExtCode ,
                             UnitName, GlblErrorDlgBox);
        Abort;
     end;

end;  {ConvertSDValue}

{===================================================================}
Function FoundSDEntry(    SwisCode : String;
                          SchoolCode : String;
                          RollSection : String;
                          HomeSteadCode : String;
                          SDCode : String;
                          ExtCode : String;
                          CMFlag : String;
                          SDTotList : TList;
                      var Index : Integer) : Boolean;

var
  I : Integer;

begin
  Index := -1;
  Result := False;

  For I := 0 to (SdTotList.Count - 1) do
    If ((Take(6, SwisCode) = Take(6, SDistTotPtr(SdTotList[I])^.SwisCode)) and
        (Take(6, SchoolCode) = Take(6, SDistTotPtr(SdTotList[I])^.SchoolCode)) and
        (Take(1, RollSection) = Take(1, SDistTotPtr(SdTotList[I])^.RollSection)) and
        (Take(1, HomeSteadCode) = Take(1, SDistTotPtr(SdTotList[I])^.HomesteadCode)) and
        (Take(5, SDCode) = Take(5, SDistTotPtr(SdTotList[I])^.SDCode)) and
        (Take(2, ExtCode) = Take(2, SDistTotPtr(SdTotList[I])^.ExtCode)) and
        (Take(1, CMFlag) = Take(1, SDistTotPtr(SdTotList[I])^.CMFlag)))
      then
        begin
          Index := I;
          Result := True;
        end;

end;  {FoundSDEntry}

{===================================================================}
Procedure TfmCooperativeAssessmentRoll.GetSDValues(    SDExtCategory : String;
                                              SDExtension : String;
                                              HomesteadCode : String;
                                              HstdLandVal,
                                              NonhstdLandVal,
                                              HstdAssessedVal,
                                              NonhstdAssessedVal,
                                              TaxableVal : Comp;
                                          var ExemptionAmount : Comp;
                                          var ADValorumAmount,
                                              ValueAmount : Extended);

{Given the extension category, figure out the advalorum amount or value amount,
 exemption amount and total tax for this special district.}

begin
  ADValorumAmount := 0;
  ValueAmount := 0;
  ExemptionAmount := 0;

   {get AV value override from SD record if > 0,
    else get it from parcel assesssed value}

  with BLSpecialDistrictTaxTable do
    If (SDExtCategory = SDistCategoryADVL)
      then
        begin
          If (RoundOff(FieldByName('AVAmtUnitDim').AsFloat, 2) > 0)
            then
              begin
                ADValorumAmount := FieldByName('AVAmtUnitDim').AsFloat;

                  {infer exmpt amt from assed val - taxable val}

                ExemptionAmount := (FieldByName('AVAmtUnitDim').AsFloat -
                                    TaxableVal);

              end
            else
              begin
                  {Now, if this is a nonhomestead special district,
                   we will get the nonhomestead assessed value.
                   Otherwise (if it is homestead or blank), we
                   will use the homestead assessed value.}
                  {FXX01292002-1: Change for land value special district.}

                If (SDExtension = SDistEcLD)
                  then
                    begin
                      If (HomesteadCode = 'N')
                        then
                          begin
                              {Use the nonhomestead value.}

                            ADValorumAmount := NonhstdLandVal;

                               {infer exmpt amt from assed val - taxable val}

                            ExemptionAmount := NonhstdLandVal - TaxableVal;

                          end
                        else
                          begin
                              {Use the homestead value.}

                            ADValorumAmount := ADValorumAmount + HstdLandVal;

                               {infer exmpt amt from assed val - taxable val}

                            ExemptionAmount := HstdLandVal - TaxableVal;

                          end;  {else of If (HomesteadCode = 'N')}
                    end
                  else
                    begin
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

                    end;  {else of If (SDExtension = SDistEcLD)}

              end;  {else of If (RoundOff(FieldByName('AVAmtUnitDim').AsFloat, 2) > 0)}

        end
      else
        begin
             {all non-advalorums go in value field}
          ValueAmount := FieldByName('AVAmtUnitDim').AsFloat;

        end;  {else of If (SDExtCategory = SDistCategoryADVL)}

end;  {GetSDValues}

{===================================================================}
Procedure TfmCooperativeAssessmentRoll.SaveSDistTaxTotals(ExtCode : String;
                                                 TaxableValAmount : Double;
                                                 _HomesteadCode : String;
                                                 SDExtCategory: String;
                                                 HstdLandVal,
                                                 NonhstdLandVal,
                                                 HstdAssessedVal,
                                                 NonhstdAssessedVal : Comp;
                                                 ParcelHomesteadCode : String;
                                                 SDTotList : TList);

{Save the special district totals for this extension.}

var
  Index : Integer;
  ExemptionAmount : Comp;
  ADValorumAmount, ValueAmount : Extended;
  SDTotPtr : SDistTotPtr;
  _SchoolCode : String;

begin
     {We will only fill in the school code if this is a school
      collection for this totals type. This way, we don't end up
      with totals records broken down by swis and school for
      municipal or village collections.}

  If (CollectionType = 'SC')
    then _SchoolCode := BLHeaderTaxTable.FieldByName('SchoolDistCode').Text
    else _SchoolCode := Take(6, '');

  GetSDValues(SDExtCategory, ExtCode, _HomesteadCode,
              HstdLandVal, NonhstdLandVal,
              HstdAssessedVal, NonhstdAssessedVal,
              TaxableValAmount, ExemptionAmount,
              ADValorumAmount, ValueAmount);

  If FoundSDEntry(BLHeaderTaxTable.FieldByName('SwisCode').Text,
                  _SchoolCode,
                  BLHeaderTaxTable.FieldByName('RollSection').Text,
                  _HomesteadCode,
                  BLSpecialDistrictTaxTable.FieldByName('SDistCode').Text,
                  BLSpecialDistrictTaxTable.FieldByName('ExtCode').Text,
                  BLSpecialDistrictTaxTable.FieldByName('CMFlag').Text,
                  SDTotList, Index)
    then
      begin
          {item exists so add to totals}

        with SDistTotPtr(SDTotList[Index])^ do
          begin
            ParcelCt := ParcelCt + 1;
            Value := Value + ValueAmount;
            ADValue := ADValue + ADValorumAmount;
            ExemptAmt := ExemptAmt + ExemptionAmount;
            TaxableVal := TaxableVal + TaxableValAmount;

            If (_Compare(ParcelHomesteadCode, 'S', coEqual) and
                _Compare(_HomesteadCode, 'H', coEqual))
              then PartCount := PartCount + 1;

          end;  {with SDistTotPtr(SDTotList[TLIdx])^ do}

      end
    else
      begin
        New(SDTotPtr);

        with SDTotPtr^ do
          begin
            SwisCode := BLHeaderTaxTable.FieldByName('SwisCode').Text;
            SchoolCode := _SchoolCode;
            RollSection := BLHeaderTaxTable.FieldByName('RollSection').Text;
            HomesteadCode := _HomesteadCode;
            SDCode := BLSpecialDistrictTaxTable.FieldByName('SDistCode').Text;
            ExtCode := Take(6, BLSpecialDistrictTaxTable.FieldByName('ExtCode').Text);
            CMFlag := Take(1, BLSpecialDistrictTaxTable.FieldByName('CMFlag').Text);
            ParcelCt := 1;

            If (_Compare(ParcelHomesteadCode, 'S', coEqual) and
                _Compare(_HomesteadCode, 'H', coEqual))
              then PartCount := 1
              else PartCount := 0;

            Value := ValueAmount;
            ADValue := ADValorumAmount;
            ExemptAmt := ExemptionAmount;
            TaxableVal := TaxableValAmount;
            TotalTax := 0;

          end;  {with SDTotPtr^ do}

        SDTotList.Add(SDTotPtr);

    end;  {If FoundSDEntry(BLHeaderTaxTable.FieldByName('SwisCode').Text, ...}

end;  {SaveSDistTaxTotals}

{===================================================================}
Function FoundSDRateEntry(SDCode : String;
                          SDRateList : TList) : Boolean;

{FXX05281998-6: Don't store SD records if not in rate list.}

var
  I : Integer;

begin
  Result := False;

  For I := 0 to (SDRateList.Count - 1) do
    If (SDRatePointer(SDRateList[I])^.SDistCode = SDCode)
      then Result := True;

end;  {FoundSDRateEntry}

{===================================================================}
Procedure TfmCooperativeAssessmentRoll.SaveInfoThisParcel(     CollectionType : String;
                                                      GeneralRateList,
                                                      SDRateList,
                                                      SDExtCategoryList,
                                                      GeneralTotalsList,
                                                      SDTotalsList,
                                                      SchoolTotalsList,
                                                      EXTotalsList : TList;
                                                      ParcelTable : TTable;
                                                      TaxRollYear : String;
                                                      ProcessingType : Integer;
                                                      PrintCoopTotals : Boolean;
                                                      CoopTotalsList : TList;
                                                      PrintPermits : Boolean;
                                                  var Quit : Boolean);

{Calculate the bill for one parcel and store the totals in the totals lists.}

var
  I, J, EXIdx, NumResSites, NumComSites : Integer;
  HstdAssessedVal, NonhstdAssessedVal,
  HstdLandVal, NonhstdLandVal, EXAmount : Comp;
  HstdAcres, NonhstdAcres : Real;
  AssessmentRecordFound, ClassRecordFound,
  _Found, FoundTYParcel, FoundNYParcel : Boolean;
  HstdEXTotArray, NonhstdEXTotArray, ExTotArray : ExemptionTotalsArrayType;
  SDAmounts : TList;
  ExemptionCodes,
  ExemptionHomesteadCodes,
  ResidentialTypes,
  CountyExemptionAmounts,
  TownExemptionAmounts,
  SchoolExemptionAmounts,
  VillageExemptionAmounts : TStringList;
  SwisSBLKey : String;
  TempHomesteadCode : String;
  SDExtCategory, HomesteadCode : String;
  BasicSTARAmount, EnhancedSTARAmount,
  CountyAmount, TownAmount,
  SchoolAmount, VillageAmount : Comp;
  TempParcelTable : TTable;
  SBLRec : SBLRecord;
  FirstTimeForParcel : Boolean;
  TempStr, TempDate, TempYear, ZoningCode : String;
  ResidentialSiteTable, CommercialSiteTable : TTable;

begin
  SwisSBLKey := ExtractSSKey(ParcelTable);
  HomesteadCode := ParcelTable.FieldByName('HomesteadCode').AsString;

  SDAmounts := TList.Create;
  ExemptionCodes := TStringList.Create;
  ExemptionHomesteadCodes := TStringList.Create;
  ResidentialTypes := TStringList.Create;
  CountyExemptionAmounts := TStringList.Create;
  TownExemptionAmounts := TStringList.Create;
  SchoolExemptionAmounts := TStringList.Create;
  VillageExemptionAmounts := TStringList.Create;

    {Get the assessed values.}
    {CHG01121998-1: Allow for the user to choose roll off of This Year or
                    Next Year.}

  CalculateHstdAndNonhstdAmounts(TaxRollYear,
                                 ExtractSSKey(ParcelTable),
                                 AssessmentTable,
                                 ClassTable, ParcelTable,
                                 HstdAssessedVal, NonhstdAssessedVal,
                                 HstdLandVal, NonhstdLandVal,
                                 HstdAcres, NonhstdAcres,
                                 AssessmentRecordFound,
                                 ClassRecordFound);

    {Set up the informational part of the header tax table.}

  with BLHeaderTaxTable do
    try
      Insert;

        {CHG01121998-1: Allow for the user to choose roll of This Year or
                        Next Year.}

      FieldByName('TaxRollYr').Text := Take(4, TaxRollYear);
      FieldByName('SwisCode').Text := ParcelTable.FieldByName('SwisCode').Text;
      FieldByName('RollSection').Text := ParcelTable.FieldByName('RollSection').Text;
      FieldByName('SBLKey').Text := ExtractSBL(ParcelTable);
      FieldByName('CheckDigit').Text := ParcelTable.FieldByName('CheckDigit').Text;
      FieldByName('SchoolDistCode').Text := ParcelTable.FieldByName('SchoolCode').Text;

      If (CollectionType = 'SC')
        then FieldByName('SchoolCodeKey').Text := ParcelTable.FieldByName('SchoolCode').Text
        else FieldByName('SchoolCodeKey').Text := '999999';

      FieldByName('PropertyClassCode').Text := ParcelTable.FieldByName('PropertyClassCode').Text;

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
          If (ParcelTable.FieldByName('HomesteadCode').Text = 'N')
            then FieldByName('NonhstdAcreage').Text := ParcelTable.FieldByName('Acreage').Text
            else FieldByName('HstdAcreage').Text := ParcelTable.FieldByName('Acreage').Text;

      FieldByName('Frontage').Text := ParcelTable.FieldByName('Frontage').Text;
      FieldByName('Depth').Text := ParcelTable.FieldByName('Depth').Text;
      FieldByName('GridCordNorth').Text := ParcelTable.FieldByName('GridCordNorth').Text;
      FieldByName('GridCordEast').Text := ParcelTable.FieldByName('GridCordEast').Text;
      FieldByName('DeedBook').Text := ParcelTable.FieldByName('DeedBook').Text;
      FieldByName('DeedPage').Text := ParcelTable.FieldByName('DeedPage').Text;
      FieldByName('LegalAddr').Text := ParcelTable.FieldByName('LegalAddr').Text;
      FieldByName('LegalAddrNo').Text := ParcelTable.FieldByName('LegalAddrNo').Text;
      FieldByName('HomesteadCode').Text := ParcelTable.FieldByName('HomesteadCode').Text;
      FieldByName('AccountNumber').Text := ParcelTable.FieldByName('AccountNo').Text;
      FieldByName('MortgageNumber').Text := ParcelTable.FieldByName('MortgageNumber').Text;

      TCurrencyField(FieldByName('HstdTotalVal')).Value := HstdAssessedVal;
      TCurrencyField(FieldByName('NonhstdTotalVal')).Value := NonhstdAssessedVal;
      TCurrencyField(FieldByName('HstdLandVal')).Value := HstdLandVal;
      TCurrencyField(FieldByName('NonhstdLandVal')).Value := NonhstdLandVal;

        {CHG01282004-4(2.07l1): Allow them to print the physical increase as
                                a building permit.}

      If (PrintPermits and
          (AssessmentTable.FieldByName('PhysicalQtyIncrease').AsInteger > 0))
        then FieldByName('BuildingPermitAmount').AsInteger := AssessmentTable.FieldByName('PhysicalQtyIncrease').AsInteger;

        {The name, address, and bank code fields come from the next
         year parcel file if this parcel exists in NY. Otherwise, it
         comes from the TY file.}

       {CHG01121998-1: Allow for the user to choose roll off of This Year or
                       Next Year.}

      SBLRec := ExtractSwisSBLFromSwisSBLKey(SwisSBLKey);
      FoundTYParcel := False;
      FoundNYParcel := False;

      If (ProcessingType = ThisYear)
        then
          begin
            FoundTYParcel := True;

            with SBLRec do
              FoundNYParcel := FindKeyOld(NYParcelTable,
                                          ['TaxRollYr', 'SwisCode', 'Section',
                                           'Subsection', 'Block', 'Lot', 'Sublot',
                                           'Suffix'],
                                          [GlblNextYear, SwisCode,
                                           Section, Subsection,
                                           Block, Lot, Sublot, Suffix]);

            If FoundNYParcel
              then TempParcelTable := NYParcelTable
              else TempParcelTable := TYParcelTable;

          end  {If (ProcessingType = ThisYear)}
        else
          begin
              {Get the TY parcel record to print change of ownership.}

            FoundNYParcel := True;

            with SBLRec do
              FoundTYParcel := FindKeyOld(TYParcelTable,
                                          ['TaxRollYr', 'SwisCode', 'Section',
                                           'Subsection', 'Block', 'Lot', 'Sublot',
                                           'Suffix'],
                                          [GlblThisYear, SwisCode,
                                           Section, Subsection,
                                           Block, Lot, Sublot,
                                           Suffix]);

            TempParcelTable := NYParcelTable;

          end;  {else of If (ProcessingType = ThisYear)}

      FieldByName('Name1').Text := TempParcelTable.FieldByName('Name1').Text;
      FieldByName('Name2').Text := TempParcelTable.FieldByName('Name2').Text;
      FieldByName('Address1').Text := TempParcelTable.FieldByName('Address1').Text;
      FieldByName('Address2').Text := TempParcelTable.FieldByName('Address2').Text;
      FieldByName('Street').Text := TempParcelTable.FieldByName('Street').Text;
      FieldByName('City').Text := TempParcelTable.FieldByName('City').Text;
      FieldByName('State').Text := TempParcelTable.FieldByName('State').Text;
      FieldByName('Zip').Text := TempParcelTable.FieldByName('Zip').Text;
      FieldByName('ZipPlus4').Text := TempParcelTable.FieldByName('ZipPlus4').Text;
      FieldByName('BankCode').Text := TempParcelTable.FieldByName('BankCode').Text;
      FieldByName('PropDescr1').Text := TempParcelTable.FieldByName('PropDescr1').Text;
      FieldByName('PropDescr2').Text := TempParcelTable.FieldByName('PropDescr2').Text;
      FieldByName('PropDescr3').Text := TempParcelTable.FieldByName('PropDescr3').Text;

        {FXX01201998-1: Add land commitment warnings.}

      FieldByName('CommitmentCode').Text := TempParcelTable.FieldByName('LandCommitmentCode').Text;
      FieldByName('CommTermYear').Text := TempParcelTable.FieldByName('CommitmentTermYear').Text;

        {CHG03082003-1: Allow for printing zoning code on the roll and in
                        the extract.}

      If PrintZoningCode
        then
          begin
            ZoningCode := '';
            ResidentialSiteTable := FindTableInDataModuleForProcessingType(DataModuleResidentialSiteTableName,
                                                                           ProcessingType);

            NumResSites := CalculateNumSites(ResidentialSiteTable, TaxRollYear,
                                             SwisSBLKey, 0, False);

            If (NumResSites > 0)
              then ZoningCode := ResidentialSiteTable.FieldByName('ZoningCode').Text
              else
                begin
                  CommercialSiteTable := FindTableInDataModuleForProcessingType(DataModuleCommercialSiteTableName,
                                                                                ProcessingType);

                  NumComSites := CalculateNumSites(CommercialSiteTable, TaxRollYear,
                                                   SwisSBLKey, 0, False);

                  If (NumComSites > 0)
                    then ZoningCode := CommercialSiteTable.FieldByName('ZoningCode').Text;

                end;  {else of If (NumResSites > 0)}

            try
              FieldByName('ZoningCode').Text := ZoningCode;
            except
            end;

          end;  {If PrintZoningCode}

      If PrintAdditionalLots
        then
          try
            FieldByName('AdditionalLots').Text := ParcelTable.FieldByName('AdditionalLots').text;
          except
          end;

        {CHG04042004-1(2.07l2): Allow for Nassau formatting and ordering on assessment roll.}

      If UseNassauPrintKeyFormat
        then FieldByName('PrintKey').Text := ConvertSwisSBLToNassauDashDot(SwisSBLKey)
        else FieldByName('PrintKey').Text := '';

        {If the next year name is different from the this year name, we
         will print it, but only if they are doing the roll for ThisYear.}

   (*   If ((ProcessingType = NextYear) and
          (Take(30, TYParcelTable.FieldByName('Name1').Text) <>
           Take(30, NYParcelTable.FieldByName('Name1').Text)) and
          (FoundTYParcel and FoundNYParcel))
        then FieldByName('PriorOwner').Text := TYParcelTable.FieldByName('Name1').Text; *)

      Post;
    except
      Quit := True;
      SystemSupport(070, BLHeaderTaxTable, 'Error inserting tax header record.',
                    UnitName, GlblErrorDlgBox);
    end;

    {Make sure that there is an assessment record for this parcel.}

  If not AssessmentRecordFound
    then
      begin
(*        Writeln(CalcMessageFile, 'No Assessment Record For Parcel ' +
                ExtractSSKey(ParcelTable), '.');*)
(*        Quit := True;*)

      end;  {If not AssessmentRecordFound}

    {If the parcel is split, it should have a class record.}

  If ((ParcelTable.FieldByName('HomesteadCode').Text = 'S') and
      (not ClassRecordFound))
    then
      begin
(*        Writeln(CalcMessageFile, 'Parcel is split and has no class record. Parcel = ' +
                ExtractSSKey(ParcelTable), '. No Bill Generated.');
        Quit := True;*)

      end;  {If ((ParcelTable.FieldByName('HomesteadCode').Text = 'S') and ...}

    {Calc exemption amounts, county, town schl, village for this parcel.}
    {CHg12011997-2: STAR support}

        {CHG01121998-1: Allow for the user to choose roll of This Year or
                        Next Year.}
        {FXX02091998-1: Pass the residential type of each exemption.}

  EXTotArray := TotalExemptionsForParcel(TaxRollYear,
                                         Take(26, ExtractSSKey(ParcelTable)),
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

    {FXX06021998-5: Print STAR amounts for all rolls.}

  If (Roundoff(BasicSTARAmount, 0) > 0)
    then
      begin
        ExemptionCodes.Add(BasicSTARExemptionCode);
        ExemptionHomesteadCodes.Add('H');
        CountyExemptionAmounts.Add('0');
        TownExemptionAmounts.Add('0');
        SchoolExemptionAmounts.Add(FloatToStr(BasicSTARAmount));
        VillageExemptionAmounts.Add('0');

      end;  {If (Roundoff(BasicSTARAmount, 0) > 0)}

  If (Roundoff(EnhancedSTARAmount, 0) > 0)
    then
      begin
        ExemptionCodes.Add(EnhancedSTARExemptionCode);
        ExemptionHomesteadCodes.Add('H');
        CountyExemptionAmounts.Add('0');
        TownExemptionAmounts.Add('0');
        SchoolExemptionAmounts.Add(FloatToStr(EnhancedSTARAmount));
        VillageExemptionAmounts.Add('0');

      end;  {If (Roundoff(EnhancedSTARAmount, 0) > 0)}

   {Now save the exemptions for this parcel in the totals record.}

  SaveEXTaxTotals(ExemptionCodes, ExemptionHomesteadCodes,
                  CountyExemptionAmounts, TownExemptionAmounts,
                  SchoolExemptionAmounts, VillageExemptionAmounts,
                  CollectionType, ExTotalsList);

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
   {FXX06011998-1: Don't print exemptions for rs9.}

  If (BLHeaderTaxTable.FieldByName('RollSection').Text <> '9')
    then
      For I := 0 to (ExemptionCodes.Count - 1) do
        with BLExemptionTaxTable do
          try
            Insert;

            CountyAmount := StrToFloat(CountyExemptionAmounts[I]);
            TownAmount := StrToFloat(TownExemptionAmounts[I]);
            SchoolAmount := StrToFloat(SchoolExemptionAmounts[I]);
            VillageAmount := StrToFloat(VillageExemptionAmounts[I]);

            FieldByName('HomesteadCode').Text := ExemptionHomesteadCodes[I];

            {CHG01121998-1: Allow for the user to choose roll of This Year or
                            Next Year.}

            FieldByName('TaxRollYr').Text := TaxRollYear;
            FieldByName('SwisSBLKey').Text := Take(26, SwisSBLKey);
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
                                       [GlblThisYear,
                                        Take(26, SwisSBLKey),
                                        FieldByName('EXCode').Text]);

                  If _Found
                    then
                      begin
                        TempDate := ParcelExemptionTable.FieldByName('InitialDate').Text;

                        TempYear := Copy(TempDate, (Length(TempDate) - 3), 4);

                        FieldByName('InitialYear').Text := TempYear;

                      end;  {If Found}

                end;  {If ((FieldByName('EXCode').Text = '41720') or ...}

            Post;
          except
            Quit := True;
          end;

    {Now do the general taxes, i.e. Town, County, etc.}

  FirstTimeForParcel := True;

  For I := 0 to (GeneralRateList.Count - 1) do
    begin
        {FXX05311999-1: Forgot to do a take and caused a problem in
                        non-classified municipalities.}

      TempHomesteadCode := Take(1, ParcelTable.FieldByName('HomesteadCode').Text);
      ExIDX := GeneralRatePointer(GeneralRateList[I])^.PrintOrder;

        {If there is any homestead assessed value, insert it.
         This may be a nonclassified parcel, a homestead parcel,
         or the homestead part of a split parcel.}

      If (TempHomesteadCode <> 'N')
        then
          begin
              {FXX04191999-4: Accidently setting TempHomesteadCode to 'H' here
                              and causing split parcels to skip non-hstd
                              portion.}

            InsertGeneralTaxRecord(ParcelTable, TaxRollYear,
                                   GeneralRatePointer(GeneralRateList[I])^,
                                   'H', HstdEXTotArray,
                                   EXIdx, HstdLandVal, HstdAssessedVal,
                                   BasicSTARAmount, EnhancedSTARAmount,
                                   CollectionType,
                                   GeneralTotalsList, SchoolTotalsList,
                                   ClassRecordFound,
                                   FirstTimeForParcel, Quit);

          end;  {If (Roundoff(HstdAssessedVal, 0) > 0)}

        {If there is any nonhomestead assessed value, insert it.
         Note that this will always get stored with a homestead code of 'N'.}

      If (TempHomesteadCode[1] in ['S', 'N'])
        then
          begin
            InsertGeneralTaxRecord(ParcelTable, TaxRollYear,
                                   GeneralRatePointer(GeneralRateList[I])^,
                                   'N', NonhstdEXTotArray,
                                   EXIdx, NonhstdLandVal, NonhstdAssessedVal,
                                   0, 0, CollectionType,  {Nonhstd can not have STAR}
                                   GeneralTotalsList, SchoolTotalsList,
                                   ClassRecordFound,
                                   FirstTimeForParcel, Quit);

          end;  {If (Roundoff(NonhstdAssessedVal, 0) > 0)}

      FirstTimeForParcel := False;

    end;  {For I := 0 to (GeneralRateList.Count - 1) do}

    {Get all the special districts - see PASTYPES for the layout of
     the elements in the SDAmounts list.}

        {CHG01121998-1: Allow for the user to choose roll of This Year or
                        Next Year.}

  TotalSpecialDistrictsForParcel(TaxRollYear, SwisSBLKey,
                                 ParcelTable, AssessmentTable,
                                 ParcelSDTable, SDCodeTable,
                                 ParcelExemptionTable,
                                 ExCodeTable,
                                 SDAmounts);

  TempStr := ExtractSBL(ParcelTable);

    {Now go through each of the entries in the SDAmounts list and
     calculate the tax and store a record in the SD tax table.}
    {FXX05281998-6: Don't store SD records if not in rate list.}
    {FXX09111998-2: Don't check for sd rate - there are no rates in the
                    assessment roll.}

  For I := 0 to (SDAmounts.Count - 1) do
    If FoundSDRateEntry(PParcelSDValuesRecord(SDAmounts[I])^.SDCode,
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
                         {CHG01121998-1: Allow for the user to choose roll of This Year or
                                         Next Year.}

                        FieldByName('TaxRollYr').Text := Take(4, TaxRollYear);
                        FieldByName('SwisSBLKey').Text := SwisSBLKey;
                        FieldByName('SdistCode').Text := Take(5, SDCode);
                        FieldByName('ExtCode').Text := Take(2, SDExtensionCodes[J]);
                        FieldByName('CMFlag').Text := Take(1, SDCC_OMFlags[J]);

                          {convert value to appropriate type, eg for advalorum ext code}
                          {convert sdvalue to taxable value, no decimal pts, for }
                          {acreage convert to 2 decimal points, etc}

                        FieldByName('AVAmtUnitDIM').AsFloat :=
                                 ConvertSDValue(Take(2, SDExtensionCodes[J]),
                                                SDValues[J],
                                                SDExtCategoryList, SDExtCategory);

                      end;  {with PParcelSDValuesRecord(SDAmounts[I])^ do}

                    Post;
                  except
                    Quit := True;
                    SystemSupport(050, BLSpecialDistrictTaxTable, 'Error posting SD tax amount.',
                                  UnitName, GlblErrorDlgBox);
                  end;  {with BLSpecialDistrictTaxTable do}

                    {Save this SDist tax in tax totals memory array.}
                    {FXX07102007-1(2.11.2.2)[D905]: The assessment roll homestead \ non-homestead amounts
                                                    are incorrect.  The parcel homestead code was being
                                                    used instead of the SD homestead code.}

                with PParcelSDValuesRecord(SDAmounts[I])^ do
                  SaveSDistTaxTotals(SDExtensionCodes[J],
                                     BLSpecialDistrictTaxTable.FieldByName('AVAmtUnitDIM').AsFloat,
(*                                     ParcelTable.FieldByName('HomesteadCode').Text, *)
                                     HomesteadCodes[J], 
                                     SDExtCategory,
                                     HstdLandVal, NonhstdLandVal,
                                     HstdAssessedVal, NonhstdAssessedVal,
                                     HomesteadCode,
                                     SDTotalsList);

              end;  {If (Deblank(PParcelSDValuesRecord(SDAmounts[I])^.SDExtensionCodes[J]) <> '')}

    {CHG05292001-1: Add totals by coop.}
    {FXX10182007-1(2.11.4.8): For coop rolls, don't worry about ownership code.}

  If (PrintCoopTotals and
      (_Compare(ParcelTable.FieldByName('OwnershipCode').AsString, 'P', coEqual) or
       GlblIsCoopRoll))
    then UpdateCoopTotals(CoopTotalsList, SwisSBLKey, (HstdLandVal + NonhstdLandVal),
                          (HstdAssessedVal + NonhstdAssessedVal),
                          EXTotArray[EXCounty], EXTotArray[EXTown],
                          (EXTotArray[EXSchool] + BasicSTARAmount + EnhancedSTARAmount),
                          EnhancedSTARAmount, BasicSTARAmount);

  FreeTList(SDAmounts, SizeOf(ParcelSDValuesRecord));
  ExemptionCodes.Free;
  ExemptionHomesteadCodes.Free;
  ResidentialTypes.Free;
  CountyExemptionAmounts.Free;
  TownExemptionAmounts.Free;
  SchoolExemptionAmounts.Free;
  VillageExemptionAmounts.Free;

end;  {SaveInfoThisParcel}

{===================================================================}
Procedure TfmCooperativeAssessmentRoll.SaveBillingTotals(    GeneralTotalsList,
                                                    SDTotalsList,
                                                    SchoolTotalsList,
                                                    EXTotalsList : TList;
                                                var Quit : Boolean);

{Save the billing totals in the totals files}

var
  I : Integer;

begin
     {SAVE GENERAL TAX TOTALS}

  For I := 0 to (GeneralTotalsList.Count - 1) do
    begin
      GeneralTotalsTable.Insert;

        {The items on the left are fields of the table.
         The items on the right are fields in the pointer record.}

      with GeneralTotalsTable, GeneralAssessmentTotPtr(GeneralTotalsList[I])^ do
        begin
          FieldByName('SwisCode').Text := SwisCode;
          FieldByName('SchoolCode').Text := SchoolCode;
          FieldByName('RollSection').Text := RollSection;
          FieldByName('HomesteadCode').Text := HomesteadCode;
          FieldByName('ParcelCt').AsInteger := ParcelCt;

            {FXX01191998-10: Track split count.}

          FieldByName('SplitParcelCt').AsInteger := PartCt;
          FieldByName('LandAV').AsFloat := LandAV;
          FieldByName('TotalAV').AsFloat := TotalAV;
          FieldByName('CountyTaxableVal').AsFloat := CountyTaxableVal;
          FieldByName('TownTaxableVal').AsFloat := TownTaxableVal;
          FieldByName('SchoolTaxableVal').AsFloat := SchoolTaxableVal;
          FieldByName('VillageTaxableVal').AsFloat := VillageTaxableVal;

          FieldByName('STARAmount').AsFloat := STARAmount;
          FieldByName('TaxableValAfterSTAR').AsFloat := TaxableValAfterSTAR;

        end;  {with GeneralTotalsTable, GeneralTotPtr(GeneralTotalsList[I])^ do}

      try
        GeneralTotalsTable.Post;
      except
        Quit := True;
        SystemSupport(043, GeneralTotalsTable,
                      'Post Error on General Tax Total Table, PrintOrder =  ' +
                      GeneralTotalsTable.FieldByName('PrintOrder').Text,
                      UnitName, GlblErrorDlgBox);
      end;  {end try}

    end;  {For I := 0 to (GeneralTotalsList.Count - 1) do}

     {SAVE SDIST TAX TOTALS}

  For I := 0 to (SdTotalsList.Count - 1) do
    begin
       {The items on the left are fields of the table.
        The items on the right are fields in the pointer record.}

      with SDTotalsTable, SDistTotPtr(SDTotalsList[I])^ do
        try
          Insert;

          FieldByName('SwisCode').Text := SwisCode;
          FieldByName('SchoolCode').Text := SchoolCode;
          FieldByName('RollSection').Text := RollSection;
          FieldByName('HomesteadCode').Text := HomesteadCode;
          FieldByName('SdCode').Text := SdCode;
          FieldByName('ExtCode').Text := ExtCode;
          FieldByName('ParcelCt').AsInteger := ParcelCt;
          FieldByName('SplitParcelCt').AsInteger := PartCount;
          FieldByName('Value').AsFloat := Value;
          FieldByName('AdValue').AsFloat := ADValue;
          FieldByName('ExemptAmt').AsFloat := ExemptAmt;
          FieldByName('TaxableVal').AsFloat := TaxableVal;
          FieldByName('TotalTax').AsFloat := 0;

          Post;
        except
          Quit := True;
          SystemSupport(044, SDTotalsTable,
                        'Post Error on Sdist Total Table, SdCode  =  ' +
                        FieldByName('SdCode').Text +
                        ' - ' + FieldByName('ExtCode').Text,
                        UnitName, GlblErrorDlgBox);
        end;

    end;  {For I := 0 to (SdTotalsList.Count - 1) do}

     {SAVE SCHOOL TAX TOTALS}

  For I := 0 to (SchoolTotalsList.Count - 1) do
    begin
       {The items on the left are fields of the table.
        The items on the right are fields in the pointer record.}

      with SchoolTotalsTable, SchoolTotPtr(SchoolTotalsList[I])^ do
        try
          Insert;

          FieldByName('SwisCode').Text := SwisCode;
          FieldByName('SchoolCode').Text := SchoolCode;
          FieldByName('RollSection').Text := RollSection ;
          FieldByName('HomesteadCode').Text := HomesteadCode ;
          FieldByName('SchoolCode').Text := SchoolCode ;
          FieldByName('ParcelCt').AsInteger := ParcelCt;

            {FXX01191998-10: Track split count.}

          FieldByName('SplitParcelCt').AsInteger := PartCt;
          FieldByName('LandAV').AsFloat := LandAV;
          FieldByName('TotalAV').AsFloat := TotalAV;
          FieldByName('ExemptAmt').AsFloat := ExemptAmt;
          FieldByName('TaxableVal').AsFloat := TaxableVal;
          FieldByName('TotalTax').AsFloat := 0;

          FieldByName('STARAmount').AsFloat := STARAmount;
          FieldByName('TaxableValAfterSTAR').AsFloat := TaxableValAfterSTAR;

          Post;
        except
          Quit := True;
          SystemSupport(045, SchoolTotalsTable,
                        'Post Error on School Total Table, PrintOrder =  ' +
                        FieldByName('PrintOrder').Text,
                        UnitName, GlblErrorDlgBox);
        end;  {end try}

    end;  {For I := 0 to (SchoolTotalsList.Count - 1) do}

     {SAVE EXEMPTION  TAX TOTALS}

  For I := 0 to (ExTotalsList.Count - 1) do
    begin
       {The items on the left are fields of the table.
        The items on the right are fields in the pointer record.}

      with EXTotalsTable, ExemptTotPtr(ExTotalsList[I])^ do
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

          Post;
        except
          Quit := True;
          SystemSupport(046, EXTotalsTable,
                        'Post Error on Exemption Total Table, ExCode  =  ' +
                        FieldByName('ExCode').Text, UnitName,
                        GlblErrorDlgBox);
        end;

    end;  {For I := 0 to (ExTotalsList.Count - 1) do}

end;  {SaveBillingTotals}

{===================================================================}
Procedure TfmCooperativeAssessmentRoll.SortFiles(    GeneralRateList,
                                            SDRateList,
                                            SDExtCategoryList : TList;
                                            ParcelTable : TTable;
                                            TaxRollYear : String;
                                            ProcessingType : Integer;
                                        var Quit : Boolean);

{Place the roll information into the temporary billing files.}

var
  Done, FirstTimeThrough : Boolean;
  NumInactive : LongInt;
  RollSectionsSelected : TStringList;
  I, Index : Integer;
  GeneralTotalsList,
  SDTotalsList,
  SchoolTotalsList,
  EXTotalsList : TList;
  TempStr : String;

begin
  Done := False;
  FirstTimeThrough := True;
  NumInactive := 0;
  RollSectionsSelected := TStringList.Create;
  Application.ProcessMessages;

  GeneralTotalsList := TList.Create;
  SDTotalsList := TList.Create;
  SchoolTotalsList := TList.Create;
  EXTotalsList := TList.Create;
  Index := 1;

  with RollSectionListBox do
    For I := 0 to (Items.Count - 1) do
      If Selected[I]
        then RollSectionsSelected.Add(Items[I][1]);

  ProgressDialog.UserLabelCaption := 'Creating Sort Files.';

    {FXX04181999-2: Let the assessment roll be loaded from a list, too.}

  If LoadFromParcelList
    then
      begin
        ParcelListDialog.GetParcel(ParcelTable, Index);
        ProgressDialog.Start(ParcelListDialog.NumItems, True, True);
      end
    else
      begin
        ParcelTable.First;
        ProgressDialog.Start(GetRecordCount(NYParcelTable), True, True);
      end;

    {CHG01121998-1: Allow for the user to choose roll of This Year or
                    Next Year.}

  repeat
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
        PrintingCancelled or
        (LoadFromParcelList and
         (Index > ParcelListDialog.NumItems)))
      then Done := True;

    TempStr := ConvertSwisSBLToDashDot(ExtractSSKey(ParcelTable));
    PrintingCancelled := ProgressDialog.Cancelled;

    Application.ProcessMessages;
    If LoadFromParcelList
      then ProgressDialog.Update(Self, ParcelListDialog.GetParcelID(Index))
      else ProgressDialog.Update(Self, ConvertSwisSBLToDashDot(ExtractSSKey(ParcelTable)));

    If (not (Done or Quit) and
        (ParcelToBeBilled(ParcelTable, RollSectionsSelected, NumInactive) or
         LoadFromParcelList))
      then
        begin
          SaveInfoThisParcel(CollectionType, GeneralRateList, SDRateList,
                             SDExtCategoryList, GeneralTotalsList,
                             SDTotalsList, SchoolTotalsList, EXTotalsList,
                             ParcelTable, TaxRollYear, ProcessingType,
                             PrintCoopTotals, CoopTotalsList,
                             PrintPermits, Quit);

        end;  {If not (Done or Quit)}

  until (Done or Quit or PrintingCancelled);

  RollSectionsSelected.Free;

  SaveBillingTotals(GeneralTotalsList, SDTotalsList, SchoolTotalsList,
                    EXTotalsList, Quit);

  FreeTList(GeneralTotalsList, SizeOf(GeneralAssessmentTotRecord));
  FreeTList(SDTotalsList, SizeOf(SDistTotRecord));
  FreeTList(SchoolTotalsList, SizeOf(SchoolTotRecord));
  FreeTList(EXTotalsList, SizeOf(ExemptTotRecord));

  Application.ProcessMessages;

end;  {SortFiles}

{=====================================================================}
Procedure TfmCooperativeAssessmentRoll.PrintButtonClick(Sender: TObject);

var
  TextFileName, NewFileName,
  TaxRollYear, SpreadsheetFileName,
  HeaderFileName, GeneralFileName,
  EXFileName, SDFileName, SpecialFeeFileName,
  GeneralTotFileName, SDTotFileName,
  SchoolTotFileName, EXTotFileName,
  SpecialFeeTotFileName, IndexName : String;

  Found, OKToStartPrinting, Quit : Boolean;
  I, CollectionNum : Integer;
  UniformPercentOfValue, EqualizationRate : Real;

begin
  Duplexing := False;
  ExtractToExcel := ExtractToExcelCheckBox.Checked;
  OKToStartPrinting := True;
  GlblCurrentTabNo := 0;
  TotalsOnly := cb_TotalsOnly.Checked;

  TaxRollYear := edAssessmentYear.Text;
    {If they have entered all the information, look it up in the bill
     control file to make sure that a collection exists for what they
     entered.}

  If OKToStartPrinting
    then
      begin
        If (CollectionType = 'SC')
          then MunicipalitiesToPrint := [mtpSchool]
          else MunicipalitiesToPrint := [mtpCounty, mtpTown];

        try
          Found := FindKeyOld(CollectionLookupTable,
                              ['TaxRollYr', 'CollectionType',
                               'CollectionNo'],
                              [TaxRollYear, CollectionType,
                               IntToStr(CollectionNum)]);
        except
          Found := False;
          OKToStartPrinting := False;
          SystemSupport(010, CollectionLookupTable, 'Error getting bill control record.',
                        UnitName, GlblErrorDlgBox);
        end;

        If Found
          then
            begin
              If (MessageDlg('You are going to print the roll for collection type ' + CollectionType + ',' + #13 +
                             'collection number ' + IntToStr(CollectionNum) + '.' + #13
                             + #13 +
                             'Do you want to proceed?',
                             mtConfirmation, [mbYes, mbNo], 0) = idNo)
                then OKToStartPrinting := False;

            end
          else
            begin
              MessageDlg('The collection that you entered does not exist.' + #13 +
                         'Please try again.', mtError, [mbOK], 0);
              OKToStartPrinting := False;
            end;

      end;  {If OKToStartPrinting}

    {FXX12171998-7: Make sure that the dates in the assessment year control
                    file are filled in and the uniform % of value.}
    {FXX07191999-6: Display all info for verification before printing.}

  If OKToStartPrinting
    then
      begin
        PrintOrder := rg_PrintOrder.ItemIndex;
        OKToStartPrinting := VerifyDatesAndPercentOfValueFilledIn(AssessmentYearCtlTable,
                                                                   SwisCodeTable,
                                                                   UniformPercentOfValue,
                                                                   EqualizationRate);

      end;  {If OKToStartPrinting}

    {FXX06181999-12: Allow the user to select the date of the roll printing.}

  If OKToStartPrinting
    then
      try
        RollPrintingDate := StrToDate(DatePrintedEdit.Text);
      except
        MessageDlg('Please enter a valid tax roll printing date.', mtError, [mbOK], 0);
        OKToStartPrinting := False;
      end;

  If (OKToStartPrinting and
      (not ConfirmRollSetup(AssessmentYearCtlTable, EXCodeTable, SwisCodeTable,
                            RollHeaderTitleEdit.Text, 'print', DatePrintedEdit.Text)))
    then OKToStartPrinting := False;

    {If they entered a collection that exists, then open the billing and
     totals files, get the rates, and start the billing.}

  Quit := False;

    {CHG10121998-1: Add user options for default destination and show vet max msg.}

  SetPrintToScreenDefault(PrintDialog);

  If (OKToStartPrinting and
      PrintDialog.Execute)
    then
      begin
        If (CollectionType = 'SC')
          then MunicipalitiesToPrint := [mtpSchool];

        If (CollectionType = 'MU')
          then MunicipalitiesToPrint := [mtpCounty, mtpTown];

        If (CollectionType = 'VI')
          then MunicipalitiesToPrint := [mtpTown];

          {CHG04032000-1: Print full market value on rolls.}
        GlblPrintFullMarketValue := PrintFullMarketValueCheckBox.Checked;

          {CHG02122000-1: Allow them to edit the title on the roll.}

        RollHeaderTitle := RollHeaderTitleEdit.Text;
        PrintAdditionalLots := PrintAdditionalLotsCheckBox.Checked;

        SetRollTabs(GlblReportReprintLeftMargin);

          {CHG10131998-1: Set the printer settings based on what printer they selected
                          only - they no longer need to worry about paper or landscape
                          mode.}

        AssignPrinterSettings(PrintDialog, ReportPrinter, ReportFiler, [ptLaser], True, Quit);

          {FXX12291999-1: Allow them to specify the number of blank lines at
                          the bottom of the roll. Note that we can tell if it
                          is going to a dot matrix or laser jet by looking at the
                          print orientation - it will be landscape for laser and
                          portrait for dot matrix.}

        If (ReportPrinter.Orientation = poLandscape)
          then LinesAtBottom := GlblLinesLeftOnRollLaserJet
          else LinesAtBottom := GlblLinesLeftOnRollDotMatrix;

          {FXX10071999-1: To solve the problem of printing to the high speed,
                          we need to set the font to a TrueType even though it
                          doesn't matter in the actual printing.  The reason for this
                          is that without setting it, the default font is System for
                          the Generic printer which has a baseline descent of 0.5
                          which messes up printing to a text file.  We needed a font
                          with no descent.}

        TextFiler.SetFont('Courier New', 10);

        Quit := False;
        NumBillsPrinted := 0;
        PrintingCancelled := False;

          {Create the rate lists.}

        GeneralRateList := TList.Create;
        SDRateList := TList.Create;
        SpecialFeeRateList := TList.Create;
        BillControlDetailList := TList.Create;

          {Description lists}

        SDExtCategoryList := TList.Create;
        PropertyClassDescList := TList.Create;
        EXCodeDescList := TList.Create;
        SDCodeDescList := TList.Create;
        SwisCodeDescList := TList.Create;
        SchoolCodeDescList := TList.Create;
        SDExtCodeDescList := TList.Create;
        RollSectionDescList := TList.Create;

          {create string list for each bill image}
          {columns 1 -7 spread across each line of tax bill}

        CL1List := TStringList.Create;
        CL2List := TStringList.Create;
        CL3List := TStringList.Create;
        CL4List := TStringList.Create;
        CL5List := TStringList.Create;
        CL6List := TStringList.Create;
        CL7List := TStringList.Create;

          {CHG07172004-3(2.08): Allow print of history assessment rolls.}

        CopyAndOpenBillingFiles(TaxRollYear, CollectionType, ShortRollType,
                                BLHeaderTaxTable,
                                BLGeneralTaxTable, BLExemptionTaxTable,
                                BLSpecialDistrictTaxTable,
                                BLSpecialFeeTaxTable,
                                HeaderFileName, GeneralFileName, EXFileName,
                                SDFileName, SpecialFeeFileName,
                                True, Quit);

          {Get the file names and open the totals files for this
           tax year\municipal type\collection #.}

        If not Quit
          then
            begin
              GeneralTotalsTable.Close;
              SDTotalsTable.Close;
              SchoolTotalsTable.Close;
              EXTotalsTable.Close;
              SpecialFeeTotalsTable.Close;

              GeneralTotalsTable.TableName := OrigGeneralTotFileName;
              SDTotalsTable.TableName := OrigSDTotFileName;
              SchoolTotalsTable.TableName := OrigSchoolTotFileName;
              EXTotalsTable.TableName := OrigEXTotFileName;
              SpecialFeeTotalsTable.TableName := OrigSpecialFeeTotFileName;

              CopyAndOpenTotalsFiles(TaxRollYear, CollectionType, ShortRollType,
                                     RollType, GeneralTotalsTable, SDTotalsTable,
                                     SchoolTotalsTable, EXTotalsTable,
                                     SpecialFeeTotalsTable,
                                     GeneralTotFileName, SchoolTotFileName,
                                     SDTotFileName, EXTotFileName,
                                     SpecialFeeTotFileName, True,
                                     True, Quit);

            end;  {If not Quit}

        case PrintOrder of
          poParcelID : BLHeaderTaxTable.IndexName := 'BYSCHOOL_SWIS_RS_SBL';

          poAccountNumber :
            begin
              IndexName := 'BYACCOUNTNUMBER';

              If _Compare(BLHeaderTaxTable.IndexDefs.IndexOf(IndexName), -1, coEqual)
                then
                  try
                    BLHeaderTaxTable.AddIndex(IndexName,
                                              'AccountNumber',
                                              [ixExpression]);
                  except
                  end;

              BLHeaderTaxTable.IndexName := IndexName;

            end;  {poAccountNumber}

          end;  {case PrintOrder of}

          {Now load the rate and description lists.}

        If not Quit
          then
            begin
              LoadGeneralRateList(Take(2, TYParcelTable.FieldByName('SwisCode').Text),
                                  GeneralRateList, CollectionType);
              LoadSDRateList(SDRateList, SelectedRollSections, Quit);

              LoadSDExtCategoryList(SDExtCategoryList, Quit);

              LoadCodeList(PropertyClassDescList, 'ZPropClsTbl',
                           'MainCode', 'Description', Quit);

              LoadCodeList(EXCodeDescList, 'TExCodeTbl',
                           'ExCode', 'Description', Quit);

              LoadCodeList(SDCodeDescList, 'TSDCodeTbl',
                           'SDistCode', 'Description', Quit);

              LoadCodeList(RollSectionDescList, 'ZRollSectionTbl',
                           'MainCode', 'Description', Quit);

              LoadCodeListWithProcessingType(SwisCodeDescList, 'TSwisTbl',
                                             'SwisCode', 'MunicipalityName',
                                             ProcessingType, Quit);

              LoadCodeList(SchoolCodeDescList, 'TSchoolTbl',
                           'SchoolCode', 'SchoolName', Quit);

              LoadCodeList(SDExtCodeDescList, 'ZSDExtCodeTbl',
                           'MainCode', 'Description', Quit);

            end;  {If not Quit}

          {Now, print the roll.}

        If not Quit
          then
            begin
              AssignPrinterSettings(PrintDialog, ReportPrinter, ReportFiler, [ptBoth], True, Quit);

              If (ReportPrinter.Orientation = poLandscape)
                then
                  begin
                    If (MessageDlg('Do you want to print on letter size paper?',
                                   mtConfirmation, [mbYes, mbNo], 0) = idYes)
                      then
                        begin
                          Duplexing := True;
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

                          ReportPrinter.ScaleX := 77;
                          ReportPrinter.ScaleY := 70;
                          ReportPrinter.SectionLeft := 1.5;
                          ReportFiler.ScaleX := 77;
                          ReportFiler.ScaleY := 70;
                          ReportFiler.SectionLeft := 1.5;
                          NumLinesPerPage := 66;
                          LinesAtBottom := GlblLinesLeftOnRollDotMatrix;
                        end
                      else
                        begin
                          LinesAtBottom := GlblLinesLeftOnRollLaserJet;
                          NumLinesPerPage := 51;
                        end;


                  end
                else
                  begin
                    LinesAtBottom := GlblLinesLeftOnRollDotMatrix;
                    NumLinesPerPage := 66;
                  end;

              PrintingCancelled := False;
              GlblPreviewPrint := False;

              If ExtractToExcel
                then
                  begin
                    SpreadsheetFileName := GetPrintFileName(Self.Caption, True);
                    AssignFile(ExtractFile, SpreadsheetFileName);
                    Rewrite(ExtractFile);

                    Write(ExtractFile, 'SwisCode,',
                                       'SBL,',
                                       'ParcelID,',
                                       'CheckDigit,',
                                       'NameAddr1,',
                                       'NameAddr2,',
                                       'NameAddr3,',
                                       'NameAddr4,',
                                       'NameAddr5,',
                                       'NameAddr6,',
                                       'LegalAddress,',
                                       'PropertyClass,',
                                       'PropertyClassDesc,',
                                       'SchoolCode,',
                                       'SchoolDistrictName,',
                                       'OldParcelID,',
                                       'Acreage,',
                                       'Frontage,',
                                       'Depth,',
                                       'EastCoord,',
                                       'NorthCoord,',
                                       'DeedBook,',
                                       'DeedPage,',
                                       'BankCode,',
                                       'HomesteadCode,',
                                       'AccountNumber,',
                                       'PropertyDescription1,',
                                       'PropertyDescription2,',
                                       'PropertyDescription3,');

                      {CHG03082003-1: Allow for printing zoning code on the roll and in
                                      the extract.}

                    If PrintZoningCode
                      then Write(ExtractFile, 'Zoning,');

                    Write(ExtractFile, 'LandValue,',
                                       'TotalValue,',
                                       'FullMarketValue,',
                                       'CountyTaxableValue,',
                                       'TownTaxableValue,',
                                       'SchoolTaxableValue,',
                                       'VillageTaxableValue');

                      {Now allow 8 slots for exemptions.}

                    For I := 1 to 8 do
                      Write(ExtractFile, ',ExCode' + IntToStr(I) + ',',
                                         'ExDesc' + IntToStr(I) + ',',
                                         'ExCountyAmount' + IntToStr(I) + ',',
                                         'ExTownAmount' + IntToStr(I) + ',',
                                         'ExSchoolAmount' + IntToStr(I));

                    MaxSpecialDistricts := GetRecordCount(SDCodeTable);

                    For I := 1 to MaxSpecialDistricts do
                      Write(ExtractFile, ',SDCode' + IntToStr(I) + ',',
                                         'SDDesc' + IntToStr(I) + ',',
                                         'SDExtension' + IntToStr(I) + ',',
                                         'SD_CMFlag' + IntToStr(I) + ',',
                                         'SDAmount' + IntToStr(I) + ',');

                    Writeln(ExtractFile);

                  end;  {If PrintToExcel}

              SortFiles(GeneralRateList, SDRateList, SDExtCategoryList,
                        ParcelTable, TaxRollYear, ProcessingType, Quit);

              TextFileName := GetPrintFileName(Self.Caption, True);
              TextFiler.FileName := TextFileName;

                {FXX01211998-1: Need to set the LastPage property so that
                                long rolls aren't a problem.}

              TextFiler.LastPage := 30000;

              TextFiler.Execute;
              ProgressDialog.StartPrinting(PrintDialog.PrintToFile);

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

                {CHG01182000-3: Allow them to choose a different name or copy right away.}

              ShowReportDialog('XROLL.RPT', TextFiler.FileName, True);

            end;  {If not Quit}

        If ExtractToExcel
          then
            begin
              CloseFile(ExtractFile);
              SendTextFileToExcelSpreadsheet(SpreadsheetFileName, True,
                                             False, '');

            end;  {If ExtractToExcel}

        BLHeaderTaxTable.Close;
        BLGeneralTaxTable.Close;
        BLExemptionTaxTable.Close;
        BLSpecialDistrictTaxTable.Close;
        BLSpecialFeeTaxTable.Close;

        GeneralTotalsTable.Close;
        SchoolTotalsTable.Close;
        EXTotalsTable.Close;
        SDTotalsTable.Close;
        SpecialFeeTotalsTable.Close;

          {Finally free up the rate and totals TLists.}

        FreeTList(GeneralRateList, SizeOf(GeneralRateRecord));
        FreeTList(SDRateList, SizeOf(SDRateRecord));
        FreeTList(SpecialFeeRateList, SizeOf(SpecialFeeRecord));
        FreeTList(BillControlDetailList, SizeOf(ControlDetailRecord));

        FreeTList(SDExtCategoryList, SizeOf(SDExtCategoryRecord));

          {FXX01191998-2: Freeing the wrong record size.}
          {FXX01211998-2: Was freeing the RollSectionDescList 2x.}

        FreeTList(RollSectionDescList, SizeOf(CodeRecord));
        FreeTList(EXCodeDescList, SizeOf(CodeRecord));
        FreeTList(SDCodeDescList, SizeOf(CodeRecord));
        FreeTList(SwisCodeDescList, SizeOf(CodeRecord));
        FreeTList(SchoolCodeDescList, SizeOf(CodeRecord));
        FreeTList(SDExtCodeDescList, SizeOf(CodeRecord));
        FreeTList(PropertyClassDescList, SizeOf(CodeRecord));

        CL1List.Free;
        CL2List.Free;
        CL3List.Free;
        CL4List.Free;
        CL5List.Free;
        CL6List.Free;
        CL7List.Free;

        ResetPrinter(ReportPrinter);

      end;  {If OKToStartPrinting}

end;  {PrintButtonClick}

{====================================================================}
Procedure TfmCooperativeAssessmentRoll.ReportPrint(Sender: TObject);

{FXX01051998-1: Go through the text file generated by text filer and
                either print to screen or to printer.}

var
  RollTextFile : TextFile;

begin
  AssignFile(RollTextFile, TextFiler.FileName);
  Reset(RollTextFile);

        {CHG12211998-1: Add ability to select print range.}

  PrintTextReport(Sender, RollTextFile, PrintDialog.FromPage,
                  PrintDialog.ToPage);

  CloseFile(RollTextFile);

end;  {ReportFilerPrint}

{===================================================================}
Function TfmCooperativeAssessmentRoll.ParcelShouldBePrinted : Boolean;

{We should print this parcel if
  1. They are not showing just roll totals.
  2. It is in a roll section that they want to see.}

begin
  Result := True;

    {If they only want totals, don't print the parcel.}

  If TotalsOnly
    then Result := False;

    {Make sure that the roll section is not blank.}

  If (Deblank(BLHeaderTaxTable.FieldByName('RollSection').AsString) = '')
    then Result := False;

    {FXX08131998-6: If this is roll section 9 with no bill amount - don't print it.}

  with BLHeaderTaxTable do
    If ((Deblank(FieldByName('RollSection').AsString) = '9') and
        (Roundoff(FieldByName('TotalTaxOwed').AsFloat, 2) = 0))
      then Result := False;

end;  {ParcelShouldBePrinted}

{===================================================================}
{=====================  PRINTING LOGIC  ============================}
{===================================================================}
Procedure TfmCooperativeAssessmentRoll.AddRecordToExtractFile(var ExtractFile : TextFile;
                                                        BLHeaderTaxTable : TTable;
                                                        BaseTaxList,
                                                        ExemptionTaxList,
                                                        SpecialDistrictTaxList,
                                                        SpecialFeeTaxList : TList);

{CHG09152004-1(2.8.0.11): Extract the tax roll to Excel.}

var
  NAddrArray : NameAddrArray;
  I, ExemptionsExtracted,
  BaseTaxesExtracted: Integer;
  TempSDValue,
  TempPayAmountField, TempPayDateField,
  PropertyClassDescription, SchoolName : String;
  FullMarketValue : Extended;

begin
    {Add the general information first.}

  with BLHeaderTaxTable do
    begin
      Write(ExtractFile, FieldByName('SwisCode').AsString,
                         '''' +
                         FormatExtractField(FieldByName('SBLKey').AsString) +
                         '''',
                         FormatExtractField(ConvertSBLOnlyToDashDot(FieldByName('SBLKey').AsString)),
                         FormatExtractField(FieldByName('CheckDigit').AsString));

      GetNameAddress(BLHeaderTaxTable, NAddrArray);

      For I := 1 to 6 do
        Write(ExtractFile, FormatExtractField(NAddrArray[I]));

      PropertyClassDescription := UpcaseStr(GetDescriptionFromList(FieldByName('PropertyClassCode').AsString,
                                                                   PropertyClassDescList));

      SchoolName := UpcaseStr(GetDescriptionFromList(FieldByName('SchoolDistCode').AsString,
                                                     SchoolCodeDescList));

      FindKeyOld(SwisCodeTable, ['SwisCode'], [FieldByName('SwisCode').AsString]);
      FullMarketValue := ComputeFullValue((FieldByName('HstdTotalVal').AsFloat +
                                           FieldByName('NonhstdTotalVal').AsFloat),
                                          SwisCodeTable,
                                          FieldByName('PropertyClassCode').AsString,
                                          ' ', True);

      Write(ExtractFile, FormatExtractField(GetLegalAddressFromTable(BLHeaderTaxTable)),
                         FormatExtractField(FieldByName('PropertyClassCode').AsString),
                         FormatExtractField(PropertyClassDescription),
                         FormatExtractField(FieldByName('SchoolDistCode').AsString),
                         FormatExtractField(SchoolName),
                         FormatExtractField(''),  {Old ID not used for now.}
                         FormatExtractField(FormatFloat(DecimalEditDisplay,
                                                        (FieldByName('HstdAcreage').AsFloat +
                                                         FieldByName('NonhstdAcreage').AsFloat))),
                         FormatExtractField(FormatFloat(DecimalEditDisplay,
                                                        FieldByName('Frontage').AsFloat)),
                         FormatExtractField(FormatFloat(DecimalEditDisplay,
                                                        FieldByName('Depth').AsFloat)),
                         FormatExtractField(FieldByName('GridCordEast').AsString),
                         FormatExtractField(FieldByName('GridCordNorth').AsString),
                         FormatExtractField(FieldByName('DeedBook').AsString),
                         FormatExtractField(FieldByName('DeedPage').AsString),
                         FormatExtractField(FieldByName('BankCode').AsString),
                         FormatExtractField(FieldByName('HomesteadCode').AsString),
                         FormatExtractField(FieldByName('AccountNumber').AsString),
                         FormatExtractField(FieldByName('PropDescr1').AsString),
                         FormatExtractField(FieldByName('PropDescr2').AsString),
                         FormatExtractField(FieldByName('PropDescr3').AsString));

      Write(ExtractFile, FormatExtractField(FormatFloat(NoDecimalDisplay,
                                                        (FieldByName('HstdLandVal').AsFloat +
                                                         FieldByName('NonhstdLandVal').AsFloat))),
                         FormatExtractField(FormatFloat(NoDecimalDisplay,
                                                        (FieldByName('HstdTotalVal').AsFloat +
                                                         FieldByName('NonhstdTotalVal').AsFloat))),
                         FormatExtractField(FormatFloat(NoDecimalDisplay,
                                                        FullMarketValue)),
                         FormatExtractField(FormatFloat(DecimalEditDisplay,
                                                        FieldByName('TotalTaxOwed').AsFloat)));

        {Individual payment amounts.}

      For I := 1 to CollectionLookupTable.FieldByName('NumberOfPayments').AsInteger do
        begin
          TempPayAmountField := 'TaxPayment' + IntToStr(I);
          TempPayDateField := 'PayDate' + IntToStr(I);

          Write(ExtractFile, FormatExtractField(FormatFloat(DecimalEditDisplay,
                                                            FieldByName(TempPayAmountField).AsFloat)),
                             FormatExtractField(CollectionLookupTable.FieldByName(TempPayDateField).AsString));

        end;  {For I := 1 to CollectionLookupTable.FieldByName('NumberOfPayments').AsInteger do}

    end;  {with BLHeaderTaxTable do}

    {Now do the exemptions.}

  ExemptionsExtracted := 0;

  For I := 0 to (ExemptionTaxList.Count - 1) do
    with ExemptTaxPtr(ExemptionTaxList[I])^ do
      begin
        Write(ExtractFile, FormatExtractField(EXCode),
                           FormatExtractField(Description),
                           FormatExtractField(FormatFloat(CurrencyEditDisplay,
                                                          CountyAmount)),
                           FormatExtractField(FormatFloat(CurrencyEditDisplay,
                                                          TownAmount)),
                           FormatExtractField(FormatFloat(CurrencyEditDisplay,
                                                          SchoolAmount)));

        ExemptionsExtracted := ExemptionsExtracted + 1;

      end;  {with ExemptTaxRecord(ExemptionTaxList)^ do}

  For I := (ExemptionsExtracted + 1) to 8 do
    Write(ExtractFile, FormatExtractField(''),
                       FormatExtractField(''),
                       FormatExtractField(''),
                       FormatExtractField(''),
                       FormatExtractField(''));

  BaseTaxesExtracted := 0;
  For I := 0 to (BaseTaxList.Count - 1) do
    with GeneralTaxPtr(BaseTaxList[I])^ do
      begin
        Write(ExtractFile, FormatExtractField(Description),
                           FormatExtractField(FormatFloat(NoDecimalDisplay, TaxableVal)),
                           FormatExtractField(FormatFloat(DecimalDisplay, TaxAmount)));

        BaseTaxesExtracted := BaseTaxesExtracted + 1;

      end;  {with GeneralTaxPtr(BaseTaxList[I])^ do}

  For I := (BaseTaxesExtracted + 1) to NumberGeneralRates do
    Write(ExtractFile, FormatExtractField(''),
                       FormatExtractField(''),
                       FormatExtractField(''));

    {Now write special districts.}

  For I := 0 to (SpecialDistrictTaxList.Count - 1) do
    with SDistTaxPtr(SpecialDistrictTaxList[I])^ do
      begin
        If (ExtCode = 'TO')
          then TempSDValue := FormatFloat(NoDecimalDisplay,
                                          SDValue)
          else TempSDValue := FormatFloat(DecimalEditDisplay,
                                          SDValue);

        Write(ExtractFile, FormatExtractField(SDistCode),
                           FormatExtractField(Description),
                           FormatExtractField(ExtCode),
                           FormatExtractField(CMFlag),
                           FormatExtractField(TempSDValue),
                           FormatExtractField(FormatFloat(DecimalEditDisplay, SDAmount)));

      end;  {For I := 0 to (SpecialDistrictTaxList.Count - 1) do}

  For I := 0 to (SpecialFeeTaxList.Count - 1) do
    with SPFeeTaxPtr(SpecialFeeTaxList[I])^ do
      Write(ExtractFile, FormatExtractField(Description),
                         FormatExtractField(FormatFloat(DecimalEditDisplay, SPAmount)));

  Writeln(ExtractFile);

end;  {AddRecordToExtractFile}

{===============================================================}
Function GetBaseTaxTotalItemFromList(CooperativeBaseTaxTotalsList : TList;
                                     _PrintOrder : Integer) : Integer;

var
  I : Integer;

begin
  Result := -1;

  For I := 0 to (CooperativeBaseTaxTotalsList.Count - 1) do
    with GeneralTotPtr(CooperativeBaseTaxTotalsList[I])^ do
      If _Compare(PrintOrder, _PrintOrder, coEqual)
        then Result := I;

end;  {GetBaseTaxTotalItemFromList}

{===============================================================}
Function GetSpecialDistrictTaxItemFromList(CooperativeSpecialDistrictTaxTotalsList : TList;
                                           _SDistCode : String;
                                           _ExtCode : String;
                                           _CMFlag : String) : Integer;

var
  I : Integer;

begin
  Result := -1;

  For I := 0 to (CooperativeSpecialDistrictTaxTotalsList.Count - 1) do
    with SDistTotPtr(CooperativeSpecialDistrictTaxTotalsList[I])^ do
      If (_Compare(SDCode, _SDistCode, coEqual) and
          _Compare(ExtCode, _ExtCode, coEqual) and
          _Compare(CMFlag, _CMFlag, coEqual))
        then Result := I;

end;  {GetSpecialDistrictTaxItemFromList}

{===============================================================}
Function GetExemptionTotalItemFromList(CooperativeExemptionTotalsList : TList;
                                       _EXCode : String) : Integer;

var
  I : Integer;

begin
  Result := -1;

  For I := 0 to (CooperativeExemptionTotalsList.Count - 1) do
    with ExemptTotPtr(CooperativeExemptionTotalsList[I])^ do
      If _Compare(EXCode, _EXCode, coEqual)
        then Result := I;

end;  {GetExemptionTotalItemFromList}

{===============================================================}
Procedure UpdateCooperativeTotals(BLHeaderTaxTable : TTable;
                                  CooperativeBaseTaxTotalsList : TList;
                                  CooperativeSpecialDistrictTaxTotalsList : TList;
                                  CooperativeExemptionTotalsList : TList;
                                  BaseTaxList : TList;
                                  SpecialDistrictTaxList : TList;
                                  ExemptionList : TList);

var
  I, ItemIndex : Integer;
  CooperativeBaseTaxTotalPtr : GeneralTotPtr;
  CooperativeSpecialDistrictTaxTotalPtr : SDistTotPtr;
  CooperativeExemptionTotalPtr : ExemptTotPtr;
  AssessedValue, _STARAmount : LongInt;

begin
  _STARAmount := 0;

  For I := 0 to (ExemptionList.Count - 1) do
    begin
      ItemIndex := GetExemptionTotalItemFromList(CooperativeExemptionTotalsList,
                                                 ExemptTaxPtr(ExemptionList[I])^.EXCode);

      If _Compare(ItemIndex, -1, coEqual)
        then
          begin
            New(CooperativeExemptionTotalPtr);

            with CooperativeExemptionTotalPtr^ do
              begin
                EXCode := ExemptTaxPtr(ExemptionList[I])^.EXCode;
                HomesteadCode := ExemptTaxPtr(ExemptionList[I])^.HomesteadCode;
                PartCt := 0;
                ParcelCt := 0;
                CountyExAmt := 0;
                TownExAmt := 0;
                SchoolExAmt := 0;
                VillageExAmt := 0;

                CooperativeExemptionTotalsList.Add(CooperativeExemptionTotalPtr);

                ItemIndex := GetExemptionTotalItemFromList(CooperativeExemptionTotalsList, EXCode);

              end;  {with CooperativeExemptionTotalPtr^ do}

          end;  {If _Compare(ItemIndex, -1, coEqual)}

      with ExemptTotPtr(CooperativeExemptionTotalsList[ItemIndex])^ do
        begin
          ParcelCt := ParcelCt + 1;
          CountyExAmt := CountyExAmt + ExemptTaxPtr(ExemptionList[I])^.CountyAmount;
          TownExAmt := TownExAmt + ExemptTaxPtr(ExemptionList[I])^.TownAmount;
          SchoolExAmt := SchoolExAmt + ExemptTaxPtr(ExemptionList[I])^.SchoolAmount;
          VillageExAmt := VillageExAmt + ExemptTaxPtr(ExemptionList[I])^.VillageAmount;

        end;  {with ExemptTaxPtr(CooperativeExemptionTotalsList[ItemIndex])^ do}

      with ExemptTaxPtr(ExemptionList[I])^ do
        If ExemptionIsSTAR(EXCode)
          then _STARAmount := _STARAmount + Trunc(SchoolAmount);

    end;  {For I := 0 to (ExemptionTaxList.Count - 1) do}

  For I := 0 to (BaseTaxList.Count - 1) do
    begin
      ItemIndex := GetBaseTaxTotalItemFromList(CooperativeBaseTaxTotalsList,
                                               GeneralTaxPtr(BaseTaxList[I])^.PrintOrder);

      If _Compare(ItemIndex, -1, coEqual)
        then
          begin
            New(CooperativeBaseTaxTotalPtr);

            with CooperativeBaseTaxTotalPtr^, BLHeaderTaxTable do
              begin
                SwisCode := FieldByName('SwisCode').AsString;
                RollSection := FieldByName('RollSection').AsString;
                HomesteadCode := GeneralTaxPtr(BaseTaxList[I])^.HomesteadCode;
                PrintOrder := GeneralTaxPtr(BaseTaxList[I])^.PrintOrder;
                PartCt := 0;
                ParcelCt := 0;
                LandAv := 0;
                TotalAV := 0;
                ExemptAmt := 0;
                TaxableVal := 0;
                STARAmount := 0;
                TaxableValAfterSTAR := 0;
                TotalTax := 0;
                STARSavings := 0;

              end;  {with CooperativeBaseTaxPtr^, BLHeaderTaxTable do}

            CooperativeBaseTaxTotalsList.Add(CooperativeBaseTaxTotalPtr);

            ItemIndex := GetBaseTaxTotalItemFromList(CooperativeBaseTaxTotalsList,
                                                     CooperativeBaseTaxTotalPtr^.PrintOrder);

          end;  {If _Compare(ItemIndex, -1, coEqual)}

      with GeneralTotPtr(CooperativeBaseTaxTotalsList[ItemIndex])^, BLHeaderTaxTable do
        begin
          AssessedValue := FieldByName('HstdTotalVal').AsInteger + FieldByName('NonHstdTotalVal').AsInteger;
          ParcelCt := ParcelCt + 1;
          LandAV := LandAV + FieldByName('HstdLandVal').AsInteger + FieldByName('NonHstdLandVal').AsInteger;
          TotalAV := TotalAV + AssessedValue;
          ExemptAmt := ExemptAmt + (AssessedValue - GeneralTaxPtr(BaseTaxList[I])^.TaxableVal - _STARAmount);
          TaxableVal := TaxableVal + (GeneralTaxPtr(BaseTaxList[I])^.TaxableVal + _STARAmount);
          STARAmount := STARAmount + _STARAmount;
          TaxableValAfterSTAR := TaxableValAfterSTAR + GeneralTaxPtr(BaseTaxList[I])^.TaxableVal;
          TotalTax := TotalTax + GeneralTaxPtr(BaseTaxList[I])^.TaxAmount;
          STARSavings := STARSavings + GeneralTaxPtr(BaseTaxList[I])^.STARSavings;

        end;  {with GeneralTaxPtr(CooperativeBaseTaxPtr[ItemIndex])^ do}

    end;  {For I := 0 to (BaseTaxList.Count - 1) do}

  For I := 0 to (SpecialDistrictTaxList.Count - 1) do
    begin
      with SDistTaxPtr(SpecialDistrictTaxList[I])^ do
        ItemIndex := GetSpecialDistrictTaxItemFromList(CooperativeSpecialDistrictTaxTotalsList,
                                                       SDistCode, ExtCode, CMFlag);

      If _Compare(ItemIndex, -1, coEqual)
        then
          begin
            New(CooperativeSpecialDistrictTaxTotalPtr);

            with CooperativeSpecialDistrictTaxTotalPtr^ do
              begin
                SwisCode := BLHeaderTaxTable.FieldByName('SwisCode').AsString;
                RollSection := BLHeaderTaxTable.FieldByName('RollSection').AsString;
                SchoolCode := '';
                SDCode := SDistTaxPtr(SpecialDistrictTaxList[I])^.SDistCode;
                ExtCode := SDistTaxPtr(SpecialDistrictTaxList[I])^.ExtCode;
                CMFlag := SDistTaxPtr(SpecialDistrictTaxList[I])^.CMFlag;
                HomesteadCode := SDistTaxPtr(SpecialDistrictTaxList[I])^.HomesteadCode;
                Value := 0;
                ADValue := 0;
                TaxableVal := 0;
                ExemptAmt := 0;
                TotalTax := 0;

                CooperativeSpecialDistrictTaxTotalsList.Add(CooperativeSpecialDistrictTaxTotalPtr);

                ItemIndex := GetSpecialDistrictTaxItemFromList(CooperativeSpecialDistrictTaxTotalsList,
                                                               SDCode, ExtCode, CMFlag);

              end;  {with CooperativeSpecialDistrictTaxTotalPtr^ do}

          end;  {If _Compare(ItemIndex, -1, coEqual)}

      with SDistTotPtr(CooperativeSpecialDistrictTaxTotalsList[ItemIndex])^ do
        begin
          Value := Value + SDistTaxPtr(SpecialDistrictTaxList[I])^.SDValue;
          ADValue := 0;
          TaxableVal := 0;
          ExemptAmt := 0;
          TotalTax := TotalTax + SDistTaxPtr(SpecialDistrictTaxList[I])^.SDAmount;;

        end;  {with SDistTaxPtr(CooperativeSpecialDistrictTaxTotalsList[ItemIndex])^ do}

    end;  {with SDistTaxPtr(BaseTaxList[I])^ do}

end;  {UpdateCooperativeTotals}

{===============================================================}
Procedure TfmCooperativeAssessmentRoll.PrintSelectedRollSections(    Sender : TObject;
                                                                 SelectedRollSections : TStringList;
                                                             var FirstPageOfReport : Boolean;
                                                             var TotalTax : Extended;
                                                                 lst_TotalsByCooperative : TList);


{FXX01061998-2: Print only the roll sections they choose and print
                sections 7 and 9 seperately.}

var
  HeaderPrinted, ParcelSubheaderPrinted,
  ParcelPrintedThisPage, FirstTimeThrough, Quit, Done : Boolean;
  CurrentSchoolCode, CurrentSwisCode, CurrentRollSection,
  SwisSBLKey, CurrentCooperative, LastCooperative : String;
  TotalAssessedVal : Comp;
  LineTypeList : TStringList;  {What type of line is each tax line?}
  TaxAmount : Double;

  PageNo, LineNo, MaxLines : Integer;
  CooperativeBaseTaxTotalsList,
  CooperativeSpecialDistrictTaxTotalsList,
  CooperativeExemptionTotalsList,
  CooperativeSchoolTotalsList,
  CooperativeSpecialFeeTotalsList,
  BaseTaxList, SpecialDistrictTaxList, SpecialFeeTaxList, ExemptionTaxList : TList;
  ptrTotalsByCooperative : ptr_TotalsByCooperative;

begin
  TotalTax := 0;
  LineNo := 1;
  PageNo := 1;
  Done := False;
  Quit := False;
  ParcelSubheaderPrinted := False;
  FirstTimeThrough := True;
  HeaderPrinted := False;
  ParcelPrintedThisPage := False;

  BaseTaxList := TList.Create;
  SpecialDistrictTaxList := TList.Create;
  SpecialFeeTaxList := TList.Create;
  ExemptionTaxList := TList.Create;
  LineTypeList := TStringList.Create;

  CooperativeBaseTaxTotalsList := TList.Create;
  CooperativeSpecialDistrictTaxTotalsList := TList.Create;
  CooperativeExemptionTotalsList := TList.Create;
  CooperativeSchoolTotalsList := TList.Create;
  CooperativeSpecialFeeTotalsList := TList.Create;

  case PrintOrder of
    poParcelID : SequenceStr := 'PARCEL ID ORDER';
    poAccountNumber : SequenceStr := 'ACCOUNT NUMBER ORDER';
  end;

  with Sender as TBaseReport, BLHeaderTaxTable do
    begin
      Bold := False;
      First;

      repeat
        If FirstTimeThrough
          then FirstTimeThrough := False
          else Next;

        If EOF
          then Done := True;

        case PrintOrder of
          poParcelID : ProgressDialog.Update(Self, ConvertSBLOnlyToDashDot(FieldByName('SBLKey').AsString));
          poAccountNumber : ProgressDialog.Update(Self, FieldByName('AccountNumber').AsString);
        end;
        Application.ProcessMessages;

          {FXX08192007-1(2.11.3.4)[D972]: GetCooperativeBase needs the sublot for Eastchester.}

        SwisSBLKey := FieldByName('SwisCode').AsString + FieldByName('SBLKey').AsString;
        CurrentCooperative := GetCooperativeBase(FieldByName('SBLKey').AsString,
                                                 FieldByName('AccountNumber').AsString,
                                                 _Compare(PrintOrder, poParcelID, coEqual),
                                                 GlblCoopBaseSBLHasSubblock);

        If (Done or
            (_Compare(CurrentCooperative, LastCooperative, coNotEqual) and
             _Compare(LastCooperative, coNotBlank)))
          then
            begin
(*              with Sender as TBaseReport do
                begin
                  PrintEndingParcelLine(Sender);
                  ClearTabs;
                  SetTab(0.1, pjLeft, 2.0, 0, BOXLINENONE, 0);   {Cooperative}
                  Println(#9 + 'Cooperative: ' + LastCooperative);
                  Println('');

                end;  {with Sender as TBaseReport do} *)

              TaxAmount := PrintSectionTotals_FromTotalsLists(Sender, 'X', 'S',
                                                              LastRollSection, LastSwisCode, LastSchoolCode,
                                                              ConvertSBLOnlyToDashDot(LastCooperative),
                                                              GeneralRateList, SDRateList, SpecialFeeRateList,
                                                              CooperativeSpecialDistrictTaxTotalsList,
                                                              CooperativeExemptionTotalsList,
                                                              CooperativeSchoolTotalsList,
                                                              CooperativeBaseTaxTotalsList,
                                                              CooperativeSpecialFeeTotalsList,
                                                              CollectionType, RollPrintingYear,
                                                              SDCodeTable,
                                                              AssessmentYearCtlTable,
                                                              SDCodeDescList,
                                                              SDExtCodeDescList,
                                                              EXCodeDescList,
                                                              SchoolCodeDescList,
                                                              SwisCodeDescList,
                                                              RollSectionDescList,
                                                              SelectedRollSections,
                                                              SequenceStr, ParcelPrintedThisPage,
                                                              PageNo, LineNo, Quit);

                {CHG08192007-1(2.11.3.4)[F666]: Add a totals summary by building at the end of the coop tax roll.}

              New(ptrTotalsByCooperative);
              ptrTotalsByCooperative^.BuildingID := LastCooperative;
              ptrTotalsByCooperative^.Amount := TaxAmount;
              lst_TotalsByCooperative.Add(ptrTotalsByCooperative);

              ClearTList(CooperativeBaseTaxTotalsList, SizeOf(GeneralTaxRecord));
              ClearTList(CooperativeSpecialDistrictTaxTotalsList, SizeOf(SDistTaxRecord));
              ClearTList(CooperativeExemptionTotalsList, SizeOf(ExemptTaxRecord));

              If not Done
                then
                  begin
                    If not TotalsOnly
                      then
                        with Sender as TBaseReport do
                          begin
                            NewPage;

                              {CHG08192007-2(2.11.3.4)[F667]: If they are duplexing, make sure they start each building on an odd page.}

                            If (Duplexing and
                                Even(CurrentPage))
                              then NewPage;

                          end;  {with Sender as TBaseReport do}

                    LineNo := 1;
                    HeaderPrinted := False;
                    ParcelPrintedThisPage := False;

                  end;  {If not Done}

            end;  {If (Done or ...}

        If not Done
          then
            begin
              CurrentSwisCode := FieldByName('SwisCode').AsString;
              CurrentSchoolCode := FieldByName('SchoolDistCode').AsString;
              CurrentRollSection := FieldByName('RollSection').AsString;
              
              If (not (HeaderPrinted or TotalsOnly))
                then
                  begin
                    HeaderPrinted := True;

                    If FirstPageOfReport
                      then
                        begin
                          PrintRollHeader(Sender, 'X', CurrentSchoolCode, CurrentSwisCode,
                                          CurrentRollSection,
                                          CollectionLookupTable.FieldByName('CollectionType').AsString,
                                          RollPrintingYear,
                                          AssessmentYearCtlTable,
                                          SchoolCodeDescList,
                                          SwisCodeDescList, SequenceStr,
                                          PageNo, LineNo);
                          FirstPageOfReport := False;
                        end
                      else StartNewPage(Sender, 'X', CurrentSchoolCode, CurrentSwisCode,
                                 CurrentRollSection,
                                 CollectionLookupTable.FieldByName('CollectionType').AsString,
                                 RollPrintingYear,
                                 AssessmentYearCtlTable,
                                 SchoolCodeDescList,
                                 SwisCodeDescList, SequenceStr,
                                 PageNo, LineNo);

                    FirstPageOfReport := False;

                     {Set up the tabs for the info.}

                    ClearTabs;

                  end;  {If not HeaderPrinted}

                 {clear out print stringlists for this parcel}
              CL1List.Clear;
              CL2List.Clear;
              CL3List.Clear;
              CL4List.Clear;
              CL5List.Clear;
              CL6List.Clear;
              CL7List.Clear;

                 {clear out tax details for this parcel}
                 {FXX04241998-4: Need to clear lists with ClearTList proc
                                 to avoid memory probs.}

              ClearTList(BaseTaxList, SizeOf(GeneralTaxRecord));
              ClearTList(SpecialDistrictTaxList, SizeOf(SDistTaxRecord));
              ClearTList(SpecialFeeTaxList, SizeOf(SPFeeTaxRecord));
              ClearTList(ExemptionTaxList, SizeOf(ExemptTaxRecord));

                {FXX01111998-2: I forgot to clear the line type list
                                each time.}

              LineTypeList.Clear;

              LoadTaxesForParcel(SwisSBLKey, BLGeneralTaxTable,
                                 BLSpecialDistrictTaxTable,
                                 BLExemptionTaxTable,
                                 BLSpecialFeeTaxTable,
                                 SDCodeDescList, EXCodeDescList,
                                 GeneralRateList, SDRateList,
                                 SpecialFeeRateList, BaseTaxList,
                                 SpecialDistrictTaxList, SpecialFeeTaxList, ExemptionTaxList, Quit);

              UpdateCooperativeTotals(BLHeaderTaxTable,
                                      CooperativeBaseTaxTotalsList,
                                      CooperativeSpecialDistrictTaxTotalsList,
                                      CooperativeExemptionTotalsList,
                                      BaseTaxList, SpecialDistrictTaxList, ExemptionTaxList);

                {CHG09152004-1(2.8.0.11): Extract the tax roll to Excel.}

              If ExtractToExcel
                then AddRecordToExtractFile(ExtractFile,
                                            BLHeaderTaxTable,
                                            BaseTaxList,
                                            ExemptionTaxList, SpecialDistrictTaxList, SpecialFeeTaxList);

                {FXX01061998-4: Print the prior owner - pass in ass year ctl tbl.}
                {CHG04032000-1: Pass in the swis code table to show full value.}

              FillInPropertyInformation(BLHeaderTaxTable, AssessmentYearCtlTable,
                                        SwisCodeTable, ParcelTable, SwisSBLKey, 'X',
                                        PropertyClassDescList, SchoolCodeDescList,
                                        ExemptionTaxList, CL1List, CL2List, CL3List,
                                        CL4List, CL5List, CL6List, CL7List,
                                        LineTypeList, False, PrintAdditionalLots, False, False);

                {NOW FILL IN REST OF COLUMNS FOR THIS PARCEL}

                {column 4, tax descriptions}
                {Column 5, taxable vals}
                {column 6, sd flgs or null}
                {column 7, billno, amts}

               {FXX12231997-3: If this is a school exemption don't show town ex
                               amount and vice-versa, so we need to pass
                               in the collection type.}

                {FXX01061998-8: If class, do seperately.}

              If (BLHeaderTaxTable.FieldByName('HomesteadCode').AsString = 'S')
                then
                  begin
                    FillInClassInformation(CL1List, CL2List,
                                           CL3List, CL4List, CL5List,
                                           CL6List, CL7List,
                                           LineTypeList,
                                           BLHeaderTaxTable,
                                           CollectionType, 'X',
                                           SuppressSDExtensions,
                                           ExemptionTaxList, BaseTaxList,
                                           SDExtCategoryList, SpecialDistrictTaxList,
                                           SpecialFeeTaxList);
                  end
                else
                  begin
                    FillInExemptions(CL4List, CL5List, CL6List, CL7List,
                                     LineTypeList, ' ', CollectionType,
                                     ExemptionTaxList);
                    FillInGeneralTaxes(CL2List, CL4List, CL5List, CL6List, CL7List,
                                       LineTypeList, 'X', ' ', BaseTaxList);

                       {FXX12231997-4: Figure out the SD exemption amount so that
                                       we can print it.}

                    with BLHeaderTaxTable do
                      TotalAssessedVal := FieldByName('HstdTotalVal').AsFloat +
                                          FieldByName('NonhstdTotalVal').AsFloat;

                    FillInSDTaxes(CL4List, CL5List, CL6List, CL7List,
                                  LineTypeList, 'X', TotalAssessedVal,
                                  SuppressSDExtensions, SDExtCategoryList,
                                  SpecialDistrictTaxList, '');
                    FillInSPFeeTaxes(CL4List, CL5List, CL6List, CL7List,
                                     LineTypeList, SpecialFeeTaxList);

                  end;  {If (BLHeaderTaxTable.FieldByName ...}

                 {figure out max lines to print from longest column then
                  add lines so all string lists of equal length}

              MaxLines := GetAndSetMaxLines(CL1List, CL2List, CL3List, CL4List,
                                            CL5List, CL6List, CL7List, LineTypeList);

              with Sender as TBaseReport do
                If (((NumLinesPerPage - LineNo) - (MaxLines + 2)) < LinesAtBottom)
                   then
                     begin
                         {First print an ending line.}

                       PrintEndingParcelLine(Sender);

                       StartNewPage(Sender, 'X', LastSchoolCode, LastSwisCode,
                                    LastRollSection,
                                    CollectionLookupTable.FieldByName('CollectionType').AsString,
                                    RollPrintingYear,
                                    AssessmentYearCtlTable,
                                    SchoolCodeDescList,
                                    SwisCodeDescList, SequenceStr,
                                    PageNo, LineNo);

                       ParcelSubheaderPrinted := False;
                       ParcelPrintedThisPage := False;

                     end;  {If (LinesLeft < (MaxLines + 4))}

                  {If they don't want to do just totals and this roll
                   section is in the section that they wanted, then print it.}

                If ParcelShouldBePrinted
                  then
                    begin
                      If not ParcelSubheaderPrinted
                       then
                         begin
                           PrintParcelPageSubheader(Sender, 'X',
                                                    CollectionType, LineNo);
                           ParcelSubheaderPrinted := True;
                         end;

                      PrintOneParcel(Sender, 'X', BLHeaderTaxTable,
                                     CollectionLookupTable, MaxLines, CL1List, CL2List,
                                     CL3List, CL4List, CL5List, CL6List, CL7List,
                                     LineTypeList, ExemptionTaxList.Count, LineNo);
                      NumBillsPrinted := NumBillsPrinted + 1;
                      ParcelPrintedThisPage := True;

                    end;  {If ParcelShouldBePrinted}

            end;  {If not Done}

        LastCooperative := CurrentCooperative;

      until (Done or ProgressDialog.Cancelled);

    end;  {with Sender as TBaseReport do}

    {FXX04241998-5: Need to free the tax TLists.}

  FreeTList(BaseTaxList, SizeOf(GeneralTaxRecord));
  FreeTList(SpecialDistrictTaxList, SizeOf(SDistTaxRecord));
  FreeTList(SpecialFeeTaxList, SizeOf(SPFeeTaxRecord));
  FreeTList(ExemptionTaxList, SizeOf(ExemptTaxRecord));

  FreeTList(CooperativeBaseTaxTotalsList, SizeOf(GeneralTaxRecord));
  FreeTList(CooperativeSpecialDistrictTaxTotalsList, SizeOf(SDistTaxRecord));
  FreeTList(CooperativeExemptionTotalsList, SizeOf(ExemptTaxRecord));

end;  {PrintSelectedRollSections}

{===============================================================}
Procedure PrintTotalsHeader(Sender : TObject);

begin
  with Sender as TBaseReport do
    begin
      ClearTabs;
      SetTab(0.3, pjCenter, 8.0, 0, BoxLineBottom, 0);   {Title}
      Println(#9 + RollHeaderTitle);
      Println('');

      ClearTabs;
      SetTab(0.3, pjCenter, 1.5, 0, BoxLineBottom, 0);   {Building ID}
      SetTab(1.9, pjCenter, 1.2, 0, BoxLineBottom, 0);   {Amount}

      Println(#9 + 'Cooperative ID' +
              #9 + 'Amount');
      Println('');

      ClearTabs;
      SetTab(0.3, pjLeft, 1.5, 0, BoxLineNone, 0);   {Building ID}
      SetTab(1.9, pjRight, 1.2, 0, BoxLineNone, 0);   {Amount}

    end;  {with Sender as TBaseReport do}

end;  {PrintTotalsHeader}

{===============================================================}
Procedure TfmCooperativeAssessmentRoll.PrintTotalsByBuilding(Sender : TObject;
                                                         lst_TotalsByCooperative : TList);

{CHG08192007-1(2.11.3.4)[F666]: Add a totals summary by building at the end of the coop tax roll.}

var
  I : Integer;

begin
  I := 0;

  with Sender as TBaseReport do
    begin
      NewPage;

        {CHG08192007-2(2.11.3.4)[F667]: If they are duplexing, make sure they start each building on an odd page.}

      If (Duplexing and
          Even(CurrentPage))
        then NewPage;

      PrintTotalsHeader(Sender);

      while _Compare(I, (lst_TotalsByCooperative.Count - 1), coLessThanOrEqual) do
        begin
          If _Compare(LinesLeft, 5, coLessThan)
            then
              begin
                NewPage;
                PrintTotalsHeader(Sender);
              end;

          with ptr_TotalsByCooperative(lst_TotalsByCooperative[I])^ do
            Println(#9 + ConvertSBLOnlyToDashDot(BuildingID) +
                    #9 + FormatFloat(DecimalDisplay, Amount));

          Inc(I);

        end;  {while _Compare(I, (lst_TotalsByCooperative.Count - 1), coLessThanOrEqual) do}

    end;  {with Sender as TBaseReport do}

end;  {PrintTotalsByBuilding}

{===============================================================}
Procedure TfmCooperativeAssessmentRoll.TextFilerPrint(Sender: TObject);

var
  SelectedRollSections : TStringList;
  TaxTheseRollSections : Extended;
  FirstPageOfReport : Boolean;
  lst_TotalsByCooperative : TList;

begin
  lst_TotalsByCooperative := TList.Create;
  GlblCurrentTabNo := 1;
  GlblCurrentLinePos := 1;
  ProgressDialog.Start(GetRecordCount(BLHeaderTaxTable), True, True);

  NumColsPerPage := 130;

  RollPrintingYear := edAssessmentYear.Text;
  TaxTheseRollSections := 0;
  SelectedRollSections := TStringList.Create;
  SelectedRollSections.Add('1');
  FirstPageOfReport := True;

  If ((SelectedRollSections.Count > 0) and
      (not ProgressDialog.Cancelled))
    then PrintSelectedRollSections(Sender, SelectedRollSections,
                                   FirstPageOfReport, TaxTheseRollSections,
                                   lst_TotalsByCooperative);

    {CHG08192007-1(2.11.3.4)[F666]: Add a totals summary by building at the end of the coop tax roll.}

  PrintTotalsByBuilding(Sender, lst_TotalsByCooperative);

  SelectedRollSections.Free;
  FreeTList(lst_TotalsByCooperative, SizeOf(rec_TotalsByCooperative));

end;  {ReportFilerPrint}

{===============================================================}
Procedure TfmCooperativeAssessmentRoll.CloseButtonClick(Sender: TObject);

begin
  Close;
end;

{===================================================================}
Procedure TfmCooperativeAssessmentRoll.FormClose(    Sender: TObject;
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
