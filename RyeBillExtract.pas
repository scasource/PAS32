unit RyeBillExtract;

interface

uses
SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, DBCtrls, DBTables, DB, Buttons, Grids,
  Wwdbigrd, Wwdbgrid, ExtCtrls, Wwtable, Wwdatsrc, Menus, Mask, Types,
  ComCtrls;

type
  TRyeBillExtractForm = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    ScrollBox1: TScrollBox;
    TitleLabel: TLabel;
    SaveDialog: TSaveDialog;
    BillCollectionTable: TTable;
    SpecialDistrictRateTable: TTable;
    GeneralRateTable: TTable;
    TaxHeaderTable: TTable;
    GeneralTaxTable: TTable;
    SpecialDistrictTaxTable: TTable;
    ExemptionTaxTable: TTable;
    SwisCodeTable: TTable;
    LastYearGeneralTaxTable: TTable;
    LastYearSpecialDistrictTaxTable: TTable;
    PageControl1: TPageControl;
    OptionsTabSheet: TTabSheet;
    GroupBox1: TGroupBox;
    BillCollectionListView: TListView;
    Panel3: TPanel;
    StartButton: TBitBtn;
    CloseButton: TBitBtn;
    BankCodeSelectionTabSheet: TTabSheet;
    LienMessageTabSheet: TTabSheet;
    LienMessageMemo: TMemo;
    Label1: TLabel;
    WarrantDateEdit: TMaskEdit;
    PropertyClassCodeTable: TTable;
    ExemptionCodeTable: TTable;
    SpecialDistrictRateLookupTable: TTable;
    GeneralRateLookupTable: TTable;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure StartButtonClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    UnitName,
    AssessmentYear, CollectionType, CollectionNumber : String;
    Cancelled : Boolean;

    Procedure InitializeForm;  {Open the tables and setup.}

    Procedure _OpenBillingFiles(    AssessmentYear : String;
                                    CollectionType : String;
                                    CollectionNumber : String;
                                var Quit : Boolean);

    Procedure ExtractOneExemption(var ExtractFile : TextFile;
                                      UniformPercentOfValue : Double;
                                      Amount : LongInt);

    Procedure ExtractExemptions(var ExtractFile : TextFile;
                                    UniformPercentOfValue : Double;
                                    SwisSBLKey : String);

    Procedure ExtractOneGeneralLevyRecord(var ExtractFile : TextFile;
                                              AssessedValue : LongInt);

    Procedure ExtractOneDistrictLevyRecord(var ExtractFile: TextFile;
                                               AssessedValue : LongInt);

    Procedure ExtractLevyRecords(var ExtractFile : TextFile;
                                     AssessedValue : LongInt;
                                     SwisSBLKey : String);

    Procedure ExtractOneGeneralTaxChangeRecord(var ExtractFile : TextFile;
                                               var TotalPriorTax : Double;
                                               var TotalCurrentTax : Double);

    Procedure ExtractOneDistrictTaxChangeRecord(var ExtractFile : TextFile;
                                                var TotalPriorTax : Double;
                                                var TotalCurrentTax : Double);

    Procedure ExtractParcelChangeRecords(var ExtractFile : TextFile;
                                             SwisSBLKey : String);

    Procedure ExtractLevyChangeRecords(var ExtractFile : TextFile);

    Function RecordMeetsCriteria(TaxHeaderTable : TTable) : Boolean;

    Procedure ExtractOneParcel(var ExtractFile : TextFile);

    Procedure FillExtractFile(var ExtractFile : TextFile;
                                  AssessmentYear : String;
                                  CollectionType : String;
                                  CollectionNumber : String);

  end;

implementation

uses GlblVars, WinUtils, Utilitys, GlblCnst, PASUtils, UtilEXSD,
     PASTypes, Prog, UtilBill, DataAccessUnit;

{$R *.DFM}

const
  MaxExemptionRecords = 8;
  ExemptionRecordLength = 61;
  MaxLevyRecords = 12;
  LevyRecordLength = 71;
  MaxTaxChangeRecords = 5;
  TaxChangeRecordLength = 66;
  MaxLevyChangeRecords = 20;
  LevyChangeRecordLength = 63;

{==============================================================================}
procedure TRyeBillExtractForm.FormActivate(Sender: TObject);

begin
  SetFormStateMaximized(Self);
end;

{==============================================================================}
Procedure TRyeBillExtractForm.InitializeForm;

begin
  UnitName := 'RyeBillExtract';

  OpenTablesForForm(Self, ThisYear);

  FillInListView(BillCollectionListView, BillCollectionTable,
                 ['TaxRollYr', 'CollectionType', 'CollectionNo'],
                 False, True);

end;  {InitializeForm}

{==============================================================================}
Procedure TRyeBillExtractForm._OpenBillingFiles(    AssessmentYear : String;
                                                    CollectionType : String;
                                                    CollectionNumber : String;
                                                var Quit : Boolean);

var
  HeaderFileName, GeneralTaxFileName,
  ExemptionFileName, SpecialDistrictFileName, SpecialFeeFileName : String;

begin
  GetBillingFileNames(AssessmentYear, CollectionType, CollectionNumber,
                      HeaderFileName, GeneralTaxFileName,
                      ExemptionFileName, SpecialDistrictFileName,
                      SpecialFeeFileName);

  OpenBillingFiles(HeaderFileName, GeneralTaxFileName,
                   ExemptionFileName, SpecialDistrictFileName,
                   SpecialFeeFileName,
                   TaxHeaderTable,
                   GeneralTaxTable,
                   ExemptionTaxTable,
                   SpecialDistrictTaxTable,
                   nil, Quit);

  GetBillingFileNames(IncrementNumericString(AssessmentYear, -1),
                      CollectionType, CollectionNumber,
                      HeaderFileName, GeneralTaxFileName,
                      ExemptionFileName, SpecialDistrictFileName,
                      SpecialFeeFileName);

  OpenBillingFiles(HeaderFileName, GeneralTaxFileName,
                   ExemptionFileName, SpecialDistrictFileName,
                   SpecialFeeFileName,
                   nil,
                   LastYearGeneralTaxTable,
                   nil,
                   LastYearSpecialDistrictTaxTable,
                   nil, Quit);

end;  {_OpenBillingFiles}

{==============================================================================}
Function TRyeBillExtractForm.RecordMeetsCriteria(TaxHeaderTable : TTable) : Boolean;

begin
  Result := True;
end;  {RecordMeetsCriteria}

{==============================================================================}
Procedure TRyeBillExtractForm.ExtractOneExemption(var ExtractFile : TextFile;
                                                      UniformPercentOfValue : Double;
                                                      Amount : LongInt);
var
  Rate, ExemptionSavings : Double;

begin
  with ExemptionTaxTable do
    begin
      _Locate(ExemptionCodeTable, [FieldByName('EXCode').Text], '', []);

        {The exemption savings is only based on the base tax levy.}
        {Locate the general rate for this general tax detail.}

      ExemptionSavings := 0;
      If _Locate(GeneralRateTable,
                 [AssessmentYear, CollectionType, CollectionNumber, 1], '', [])
        then
          begin
            If _Compare(FieldByName('HomesteadCode').AsString, NonhomesteadParcel, coEqual)
              then Rate := GeneralRateTable.FieldByName('NonhomesteadRate').AsFloat
              else Rate := GeneralRateTable.FieldByName('HomesteadRate').AsFloat;

            ExemptionSavings := Roundoff(((Amount / 1000) * Rate), 2);

          end;  {If _Locate(GeneralRateTable, ...}

      Write(ExtractFile, LeftJustify(FieldByName('EXCode').AsString, 5),
                         LeftJustify(ExemptionCodeTable.FieldByName('Description').Text, 20),
                         RightJustify(FormatFloat(CurrencyDisplayNoDollarSign, Amount), 11),
                         RightJustify(FormatFloat(CurrencyDisplayNoDollarSign,
                                                  ComputeFullValue(Amount, SwisCodeTable, '', '', False)), 11),
                         RightJustify(FormatFloat(DecimalDisplay, ExemptionSavings), 14));

    end;  {with ExemptionTaxTable do}

end;  {ExtractOneExemption}

{==============================================================================}
Procedure TRyeBillExtractForm.ExtractExemptions(var ExtractFile : TextFile;
                                                    UniformPercentOfValue : Double;
                                                    SwisSBLKey : String);

var
  Done, FirstTimeThrough : Boolean;
  Amount, NumExtracted : LongInt;
  I: Integer;

begin
  NumExtracted := 0;
  Amount := 0;
  FirstTimeThrough := True;

  with TaxHeaderTable do
    _SetRange(ExemptionTaxTable,
              [SwisSBLKey, '', ''],
              [SwisSBLKey, 'zzzzz', ''], '', []);

  ExemptionTaxTable.First;

  with ExemptionTaxTable do
    repeat
      If FirstTimeThrough
        then FirstTimeThrough := False
        else Next;

      Done := EOF;

      If not Done
        then
          begin
              {Get the amount for this exemption based on the collection type.}

            If _Compare(CollectionType, CountyTaxType, coEqual)
              then Amount := FieldByName('CountyAmount').AsInteger;

            If _Compare(CollectionType, VillageTaxType, coEqual)
              then Amount := FieldByName('VillageAmount').AsInteger;

            If _Compare(CollectionType, SchoolTaxType, coEqual)
              then Amount := FieldByName('SchoolAmount').AsInteger;

              {Don't use the town amount if it is 0 since this will mess up
               county only exemptions.}

            If (_Compare(CollectionType, [TownTaxType, MunicipalTaxType], coEqual) and
                _Compare(FieldByName('TownAmount').AsInteger, 0, coGreaterThan))
              then Amount := FieldByName('TownAmount').AsInteger;

              {Only extract this exemption if this exemption applies to this collection,
               i.e. there is an amount that applies to this collection.}

            If _Compare(Amount, 0, coGreaterThan)
              then
                begin
                  Inc(NumExtracted);
                  ExtractOneExemption(ExtractFile, UniformPercentOfValue, Amount);

                end;  {If _Compare(Amount, 0, coGreaterThan)}

          end;  {If not Done}

    until Done;

  For I := (NumExtracted + 1) to MaxExemptionRecords do
    Write(ExtractFile, LeftJustify('', ExemptionRecordLength));

end;  {ExtractExemptions}

{==============================================================================}
Procedure WriteOneLevyRecord(var ExtractFile : TextFile;
                                 LevyDescription : String;
                                 AssessedValue : LongInt;
                                 TaxableValue : String;
                                 LevyRate : Extended;
                                 TaxAmount: Double);

begin
  Write(ExtractFile, LeftJustify(LevyDescription, 20),
                     RightJustify(FormatFloat(CurrencyDisplayNoDollarSign, AssessedValue), 11),
                     RightJustify(TaxableValue, 16),
                     RightJustify(FormatFloat(ExtendedDecimalDisplay, LevyRate), 12),
                     RightJustify(FormatFloat(DecimalDisplay, TaxAmount), 12));

end;  {WriteOneLevyRecord}

{==============================================================================}
Procedure TRyeBillExtractForm.ExtractOneGeneralLevyRecord(var ExtractFile : TextFile;
                                                              AssessedValue : LongInt);

var
  LevyDescription : String;
  LevyRate : Extended;

begin
  with GeneralTaxTable do
    begin
        {Locate the general rate for this general tax detail.}
      _Locate(GeneralRateTable,
              [AssessmentYear, CollectionType, CollectionNumber, FieldByName('PrintOrder').Text], '', []);

         {Get the levy description, rate, and amount.}
      LevyDescription := GeneralRateTable.FieldByName('Description').AsString;

      If (FieldByName('HomesteadCode').AsString = NonhomesteadParcel)
        then LevyRate := GeneralRateTable.FieldByName('NonhomesteadRate').AsFloat
        else LevyRate := GeneralRateTable.FieldByName('HomesteadRate').AsFloat;

         {Write the record.}

      WriteOneLevyRecord(ExtractFile, LevyDescription,
                                      AssessedValue,
                                      FormatFloat(CurrencyDisplayNoDollarSign,
                                                  FieldByName('TaxableValue').AsInteger),
                                      LevyRate,
                                      FieldByName('TaxAmount').AsFloat);

    end;  {with GeneralTaxTable do}

end;  {ExtractOneGeneralLevyRecord}

{==============================================================================}
Procedure TRyeBillExtractForm.ExtractOneDistrictLevyRecord(var ExtractFile: TextFile;
                                                               AssessedValue : LongInt);
var
  LevyDescription, TaxableValueString : String;
  LevyRate : Extended;

begin
  with SpecialDistrictTaxTable do
    begin
        {Locate the Special District rate for this Special District tax detail.}

      _Locate(SpecialDistrictRateTable,
              [AssessmentYear, CollectionType, CollectionNumber,
               FieldByName('SDistCode').Text, FieldByName('ExtCode').Text, FieldByName('CMFlag').Text], '', []);

        {Get the levy description, rate, and amount.}

      LevyDescription := SpecialDistrictRateTable.FieldByName('SDistDescr').AsString;

      If (FieldByName('HomesteadCode').AsString = NonhomesteadParcel)
        then LevyRate := SpecialDistrictRateTable.FieldByName('NonhomesteadRate').AsFloat
        else LevyRate := SpecialDistrictRateTable.FieldByName('HomesteadRate').AsFloat;

        {Write the record.}

      TaxableValueString := '';

      If _Compare(FieldByName('ExtCode').Text, SDistEcTO, coEqual)
        then TaxableValueString := FormatFloat(CurrencyDisplayNoDollarSign, FieldByName('AVAmtUnitDim').AsFloat);

      If _Compare(FieldByName('ExtCode').Text, [SDistEcUN, SDistEcSU, SdistEcMT], coEqual)
        then TaxableValueString := FormatFloat(DecimalDisplay, FieldByName('AVAmtUnitDim').AsFloat);

      TaxableValueString := TaxableValueString + FieldByName('ExtCode').Text;

      WriteOneLevyRecord(ExtractFile, LevyDescription,
                                      AssessedValue,
                                      TaxableValueString,
                                      LevyRate,
                                      FieldByName('TaxAmount').AsFloat);

    end;  {with SpecialDistrictTaxTable do}

end; {ExtractOneDistrictLevyRecord}

{==============================================================================}
Procedure TRyeBillExtractForm.ExtractLevyRecords(var ExtractFile : TextFile;
                                                     AssessedValue : LongInt;
                                                     SwisSBLKey : String);

var
  Done, FirstTimeThrough : Boolean;
  NumExtracted : LongInt;
  I : Integer;

begin
  NumExtracted := 0;
  FirstTimeThrough := True;

  _SetRange(GeneralTaxTable, [SwisSBLKey, '', ''], [SwisSBLKey, 'z', ''], '', []);

  GeneralTaxTable.First;

  with GeneralTaxTable do
    repeat
      If FirstTimeThrough
        then FirstTimeThrough := False
        else Next;

      Done := EOF;

      If not Done
        then
          begin
             Inc(NumExtracted);
             ExtractOneGeneralLevyRecord(ExtractFile, AssessedValue);
          end;

   until Done;

    {Now go through the special districts.}

  FirstTimeThrough := True;

  _SetRange(SpecialDistrictTaxTable, [SwisSBLKey, '', ''], [SwisSBLKey, 'zzzzz', ''], '', []);

  SpecialDistrictTaxTable.First;

  with SpecialDistrictTaxTable do
    repeat
      If FirstTimeThrough
        then FirstTimeThrough := False
        else Next;

      Done := EOF;

      If not Done
        then
          begin
             Inc(NumExtracted);
             ExtractOneDistrictLevyRecord(ExtractFile, AssessedValue);
          end;

    until Done;

  For I := (NumExtracted + 1) to MaxLevyRecords do
    Write(ExtractFile, LeftJustify('', LevyRecordLength));

end; {ExtractLevyRecords}

{==============================================================================}
Procedure ExtractNameAddress(var ExtractFile : TextFile;
                                 TaxHeaderTable : TTable);

var
  I : Integer;
  NameAddressArray : NameAddrArray;

begin
  GetNameAddress(TaxHeaderTable, NameAddressArray);

  For I := 1 to 6 do
    Write(ExtractFile, LeftJustify(NameAddressArray[I], 30));

end; {ExtractNameAddress}

{==============================================================================}
Procedure WriteOneTaxChangeRecord(var ExtractFile : TextFile;
                                      Description : String;
                                      PriorTaxAmount : Double;
                                      CurrentTaxAmount : Double);

var
  DollarChange, PercentChange : Double;

begin
  DollarChange := CurrentTaxAmount - PriorTaxAmount;
  PercentChange := ComputePercent(CurrentTaxAmount, PriorTaxAmount);

  Write(ExtractFile, LeftJustify(Description, 20),
                     RightJustify(FormatFloat(DecimalDisplay, CurrentTaxAmount), 12),
                     RightJustify(FormatFloat(DecimalDisplay, PriorTaxAmount), 12),
                     RightJustify(FormatFloat(DecimalDisplay, DollarChange), 12),
                     RightJustify(FormatFloat(DecimalDisplay, PercentChange), 10));

end;  {WriteOneTaxChangeRecord}

{==============================================================================}
Procedure TRyeBillExtractForm.ExtractOneGeneralTaxChangeRecord(var ExtractFile : TextFile;
                                                               var TotalPriorTax : Double;
                                                               var TotalCurrentTax : Double);

var
  PriorTax : Double;

begin
  PriorTax := 0;

    {First see if we can find last year's tax amount.}

  with GeneralTaxTable do
    begin
      If _Locate(LastYearGeneralTaxTable,
                 [FieldByName('SwisSBLKey').Text, FieldByName('HomesteadCode').Text, FieldByName('PrintOrder').Text], '', [])
        then PriorTax := LastYearGeneralTaxTable.FieldByName('TaxAmount').AsFloat;

      _Locate(GeneralRateTable,
              [AssessmentYear, CollectionType, CollectionNumber, FieldByName('PrintOrder').Text], '', []);

      WriteOneTaxChangeRecord(ExtractFile, GeneralRateTable.FieldByName('Description').Text,
                              PriorTax, GeneralTaxTable.FieldByName('TaxAmount').AsFloat);

      TotalPriorTax := TotalPriorTax + PriorTax;
      TotalCurrentTax := TotalCurrentTax + GeneralTaxTable.FieldByName('TaxAmount').AsFloat;

    end;  {with GeneralTaxTable do}

end;  {ExtractOneGeneralTaxChangeRecord}

{==============================================================================}
Procedure TRyeBillExtractForm.ExtractOneDistrictTaxChangeRecord(var ExtractFile : TextFile;
                                                                var TotalPriorTax : Double;
                                                                var TotalCurrentTax : Double);

var
  PriorTax : Double;

begin
  PriorTax := 0;

    {First see if we can find last year's tax amount.}

  with SpecialDistrictTaxTable do
    begin
      If _Locate(LastYearSpecialDistrictTaxTable,
                 [FieldByName('SwisSBLKey').Text, FieldByName('SDistCode').Text,
                  FieldByName('HomesteadCode').Text, FieldByName('ExtCode').Text], '', [])
        then PriorTax := LastYearSpecialDistrictTaxTable.FieldByName('TaxAmount').AsFloat;

      _Locate(SpecialDistrictRateTable,
              [AssessmentYear, CollectionType, CollectionNumber,
               FieldByName('SDistCode').Text, FieldByName('ExtCode').Text, FieldByName('CMFlag').Text], '', []);

      WriteOneTaxChangeRecord(ExtractFile, SpecialDistrictRateTable.FieldByName('SDistDescr').Text,
                              PriorTax, SpecialDistrictTaxTable.FieldByName('TaxAmount').AsFloat);

      TotalPriorTax := TotalPriorTax + PriorTax;
      TotalCurrentTax := TotalCurrentTax + SpecialDistrictTaxTable.FieldByName('TaxAmount').AsFloat;

    end;  {with SpecialDistrictTaxTable do}

end;  {ExtractOneDistrictTaxChangeRecord}

{==============================================================================}
Procedure TRyeBillExtractForm.ExtractParcelChangeRecords(var ExtractFile : TextFile;
                                                             SwisSBLKey : String);

var
  Done, FirstTimeThrough : Boolean;
  NumExtracted : LongInt;
  I : Integer;
  TotalPriorTax, TotalCurrentTax : Double;

begin
  NumExtracted := 0;
  TotalPriorTax := 0;
  TotalCurrentTax := 0;
  FirstTimeThrough := True;

  _SetRange(GeneralTaxTable, [SwisSBLKey, '', ''], [SwisSBLKey, 'z', ''], '', []);

  GeneralTaxTable.First;

  with GeneralTaxTable do
    repeat
      If FirstTimeThrough
        then FirstTimeThrough := False
        else Next;

      Done := EOF;

      If not Done
        then
          begin
            Inc(NumExtracted);
            ExtractOneGeneralTaxChangeRecord(ExtractFile, TotalPriorTax, TotalCurrentTax);

          end;  {If not Done}

    until Done;

    {Now go through the special districts.}

  FirstTimeThrough := True;

  _SetRange(SpecialDistrictTaxTable, [SwisSBLKey, '', ''], [SwisSBLKey, 'zzzzz', ''], '', []);

  SpecialDistrictTaxTable.First;

  with SpecialDistrictTaxTable do
    repeat
      If FirstTimeThrough
        then FirstTimeThrough := False
        else Next;

      Done := EOF;

        {Don't include any move taxes in the changed tax grid since there is no year to year
         comparison for them.}

      If ((not Done) and
          _Compare(SpecialDistrictTaxTable.FieldByName('ExtCode').AsString, SdistEcMT, coNotEqual))
        then
          begin
            Inc(NumExtracted);
            ExtractOneDistrictTaxChangeRecord(ExtractFile, TotalPriorTax, TotalCurrentTax);
          end;

    until Done;

  For I := (NumExtracted + 1) to MaxTaxChangeRecords do
    Write(ExtractFile, LeftJustify('', TaxChangeRecordLength));

    {Write the total record.}

  WriteOneTaxChangeRecord(ExtractFile, 'Total', TotalPriorTax, TotalCurrentTax);

end;  {ExtractParcelChangeRecords}

{==============================================================================}
Procedure ExtractOneLevyChangeRecord(var ExtractFile : TextFile;
                                         Description : String;
                                         CurrentTaxLevy : LongInt;
                                         PriorTaxLevy : LongInt;
                                         CurrentTaxRate : Double;
                                         PriorTaxRate : Double);

var
  LevyPercentChange, RatePercentChange : Double;

begin
  LevyPercentChange := ComputePercent(CurrentTaxLevy, PriorTaxLevy);
  RatePercentChange := ComputePercent(CurrentTaxRate, PriorTaxRate);

  Write(ExtractFile, LeftJustify(Description, 20),
                     RightJustify(FormatFloat(CurrencyDisplayNoDollarSign, CurrentTaxLevy), 11),
                     RightJustify(FormatFloat(DecimalDisplay, LevyPercentChange), 10),
                     RightJustify(FormatFloat(ExtendedDecimalDisplay, CurrentTaxRate), 12),
                     RightJustify(FormatFloat(DecimalDisplay, RatePercentChange), 10));

end;  {ExtractOneLevyChangeRecord}

{==============================================================================}
Procedure TRyeBillExtractForm.ExtractLevyChangeRecords(var ExtractFile : TextFile);

var
  Done, FirstTimeThrough : Boolean;
  NumExtracted : LongInt;
  I : Integer;
  PriorTaxRate : Double;

begin
  NumExtracted := 0;
  FirstTimeThrough := False;

    {Extract the general rate change records first.}

  _SetRange(GeneralRateTable,
            [AssessmentYear, CollectionType, CollectionNumber, 0],
            [AssessmentYear, CollectionType, CollectionNumber, 9999], '', []);

  GeneralRateTable.First;

  with GeneralRateTable do
    repeat
      If FirstTimeThrough
        then FirstTimeThrough := False
        else Next;

      Done := EOF;

      If not Done
        then
          begin
            Inc(NumExtracted);

            PriorTaxRate := 0;

            If _Locate(GeneralRateLookupTable,
                       [IncrementNumericString(AssessmentYear, -1),
                        CollectionType, CollectionNumber, FieldByName('PrintOrder').Text], '', [])
              then PriorTaxRate := GeneralRateLookupTable.FieldByName('HomesteadRate').AsFloat;

            ExtractOneLevyChangeRecord(ExtractFile, FieldByName('Description').Text,
                                                    FieldByName('CurrentTaxLevy').AsInteger,
                                                    FieldByName('PriorTaxLevy').AsInteger,
                                                    FieldByName('HomesteadRate').AsFloat,
                                                    PriorTaxRate);

          end;  {If not Done}

    until Done;

    {Now go through the special district rates.}

  _SetRange(SpecialDistrictTaxTable,
            [AssessmentYear, CollectionType, CollectionNumber, '', '', ''],
            [AssessmentYear, CollectionType, CollectionNumber, 'zzzzz', '', ''], '', []);

  SpecialDistrictRateTable.First;

  with SpecialDistrictRateTable do
    repeat
      If FirstTimeThrough
        then FirstTimeThrough := False
        else Next;

      Done := EOF;

      If not Done
        then
          begin
            Inc(NumExtracted);

            PriorTaxRate := 0;

            If _Locate(SpecialDistrictRateLookupTable,
                       [IncrementNumericString(AssessmentYear, -1),
                        CollectionType, CollectionNumber,
                        FieldByName('SDistDescr').Text,
                        FieldByName('ExtCode').Text,
                        FieldByName('CMFlag').Text], '', [])
              then PriorTaxRate := SpecialDistrictRateLookupTable.FieldByName('HomesteadRate').AsFloat;

            ExtractOneLevyChangeRecord(ExtractFile, FieldByName('Description').Text,
                                                    FieldByName('CurrentTaxLevy').AsInteger,
                                                    FieldByName('PriorTaxLevy').AsInteger,
                                                    FieldByName('HomesteadRate').AsFloat,
                                                    PriorTaxRate);

          end;  {If not Done}

    until Done;

  For I := (NumExtracted + 1) to MaxLevyChangeRecords do
    Write(ExtractFile, LeftJustify('', LevyChangeRecordLength));

end;  {ExtractLevyChangeRecords}

{==============================================================================}
Procedure GetFormattedDimensions(    Table : TTable;
                                 var Dimension1 : String;
                                 var Dimension2 : String);

var
  Frontage, Depth, Acreage : Double;

begin
  Dimension1 := '';
  Dimension2 := '';

  with Table do
    begin
      Frontage := FieldByName('Frontage').AsFloat;
      Depth := FieldByName('Depth').AsFloat;
      Acreage := (FieldByName('HstdAcreage').AsFloat + FieldByName('NonHstdAcreage').AsFloat);

      If _Compare(Acreage, 0, coGreaterThan)
        then Dimension1 := 'ACREAGE: ' + FormatFloat(DecimalDisplay, Acreage)
        else
          If (_Compare(Frontage, 0, coGreaterThan) or
              _Compare(Depth, 0, coGreaterThan))
            then
              begin
                Dimension1 := 'FRONTAGE: ' + FormatFloat(DecimalDisplay, Frontage);
                Dimension2 := 'DEPTH: ' + FormatFloat(DecimalDisplay, Depth);
              end;

    end;  {with Table do}
    
end;  {GetFormattedDimensions}

{==============================================================================}
Procedure TRyeBillExtractForm.ExtractOneParcel(var ExtractFile : TextFile);

var
  Dimension1, Dimension2, WarrantDate, SwisSBLKey : String;
  I, AssessedValue, EstimatedStateAid : LongInt;
  UniformPercentOfValue : Double;

begin
  try
    WarrantDate := DateToStr(StrToDate(WarrantDateEdit.Text));
  except
    WarrantDate := '';
  end;

  GetFormattedDimensions(TaxHeaderTable, Dimension1, Dimension2);
  UniformPercentOfValue := SwisCodeTable.FieldByName('UniformPercentValue').AsFloat;

  _Locate(BillCollectionTable, [AssessmentYear, CollectionType, CollectionNumber], '', []);

  with TaxHeaderTable do
    begin
      SwisSBLKey := FieldByName('SwisCode').AsString + FieldByName('SBLKey').AsString;
      AssessedValue := FieldByName('HstdTotalVal').AsInteger +
                       FieldByName('NonhstdTotalVal').AsInteger;

      Write(ExtractFile, LeftJustify(ConvertSBLOnlyToDashDot(FieldByName('SBLKey').AsString), 30),  {1-30: Parcel ID}
                         LeftJustify(FieldByName('CheckDigit').AsString, 2),  {31-32: Check digit}
                         LeftJustify(FieldByName('LegalAddr').AsString, 35),  {33-67: Legal address}
                         LeftJustify(Dimension1, 20),  {68-87: Dimension 1}
                         LeftJustify(Dimension2, 20),  {88-107: Dimension 2}
                         LeftJustify(FieldByName('PropertyClassCode').AsString, 3),  {108-110: Property class code}
                         LeftJustify(GetDescriptionForCode(PropertyClassCodeTable,
                                                           FieldByName('PropertyClassCode').AsString,
                                                           'Description'), 30),  {111-140: Property class description}
                         RightJustify(FormatFloat(CurrencyDisplayNoDollarSign,
                                                  AssessedValue), 13));  {141-153:  Assessed value}

    end;  {with TaxHeaderTable do}

    {154-488: 8 exemption records of 61 bytes}

  ExtractExemptions(ExtractFile, UniformPercentOfValue, SwisSBLKey);

  with TaxHeaderTable do
    Write(ExtractFile, LeftJustify(FieldByName('BankCode').AsString, 7),  {642-648: Bank code}
                       LeftJustify(FieldByName('BillNo').AsString, 6));  {649-654: Bill #}

    {655-1506: 12 tax detail (levy) records of 71 bytes each.}

  ExtractLevyRecords(ExtractFile, AssessedValue, SwisSBLKey);

    {1507-1686: 6 lines of 30 char name \ address.}

  ExtractNameAddress(ExtractFile, TaxHeaderTable);

  with TaxHeaderTable do
    Write(ExtractFile, RightJustify(FormatFloat(DecimalDisplay,
                                                FieldByName('TotalTaxOwed').AsFloat), 12),  {1687-1698: Total tax owed}
                       RightJustify(FormatFloat(CurrencyDisplayNoDollarSign,
                                                ComputeFullValue(AssessedValue,
                                                                 SwisCodeTable,
                                                                 FieldByName('PropertyClassCode').AsString,
                                                                 '', False)), 13),  {1699-1711: Full market value}
                       RightJustify(FormatFloat(DecimalDisplay, UniformPercentOfValue), 6),  {1712-1717: Uniform % of value}
                       LeftJustify(FieldByName('RollSection').AsString, 1));  {1718-1718: Roll section}


    {1719-2114: 5 records of 66 bytes each and 1 total change line.}

  ExtractParcelChangeRecords(ExtractFile, SwisSBLKey);

    {The individual levy change records are not printed since they are printed
     on the backer.}

  (* ExtractLevyChangeRecords(ExtractFile); *)

  with TaxHeaderTable do
    Write(ExtractFile, RightJustify(WarrantDate, 10),  {2115-2124: Warrant date - entered by user}
                       BoolToChar_Blank_Y(FieldByName('ArrearsFlag').AsBoolean));  {2125-2125: Arrears?}

    {2126-2575: 6 lines of 75 char lien message.}

  For I := 0 to 5 do
    If TaxHeaderTable.FieldByName('ArrearsFlag').AsBoolean
      then Write(ExtractFile, LeftJustify(LienMessageMemo.Lines[I], 75))
      else Write(ExtractFile, LeftJustify('', 75));

  If _Locate(GeneralRateTable, [AssessmentYear, CollectionType, CollectionNumber, 1], '', [])
    then EstimatedStateAid := GeneralRateTable.FieldByName('EstimatedStateAid').AsInteger
    else EstimatedStateAid := 0;

  Writeln(ExtractFile, RightJustify(BillCollectionTable.FieldByName('PayDate1').Text, 10), {2576-2585: Due date}
                       RightJustify(FormatFloat(CurrencyNormalDisplay_BlankZero, EstimatedStateAid), 14));  {2586-2599: Estimate state aid}

end;  {ExtractOneParcel}

{==============================================================================}
Procedure TRyeBillExtractForm.FillExtractFile(var ExtractFile : TextFile;
                                                  AssessmentYear : String;
                                                  CollectionType : String;
                                                  CollectionNumber : String);

var
  Done, FirstTimeThrough : Boolean;

begin
  FirstTimeThrough := True;

  with TaxHeaderTable do
    begin
      ProgressDialog.Start(RecordCount, True, True);

      First;

      repeat
        If FirstTimeThrough then
           FirstTimeThrough := False
        else Next;

        Done := EOF;

        ProgressDialog.Update(Self, ConvertSBLOnlyToDashDot(FieldByName('SBLKey').Text));
        Application.ProcessMessages;

        If ((not Done) and
            RecordMeetsCriteria(TaxHeaderTable))
          then
            begin
              ExtractOneParcel(ExtractFile);

                {Update totals}

            end;  {If ((not Done) and ...}

      until (Done or ProgressDialog.Cancelled);

    end;  {with TaxHeaderTable do}

  ProgressDialog.Finish;

    {Display totals}

end;  {FillExtractFile}

{==============================================================================}
Procedure TRyeBillExtractForm.StartButtonClick(Sender: TObject);

var
  ExtractFile : TextFile;
  FileName, DefaultFileName : String;
  Quit : Boolean;

begin
    {First get the collection they chose to extract and set up a default file name.}

  AssessmentYear := GetColumnValueForItem(BillCollectionListView, 0, -1);
  CollectionType := GetColumnValueForItem(BillCollectionListView, 1, -1);
  CollectionNumber := GetColumnValueForItem(BillCollectionListView, 2, -1);

  DefaultFileName := 'Rye Bill File ' +
                     GetCollectionTypeCategory(CollectionType) + '_' +
                     AssessmentYear + '_' +
                     CollectionNumber + '.txt';

  SaveDialog.FileName := DefaultFileName;
  SaveDialog.InitialDir := GlblExportDir;

  If SaveDialog.Execute
    then
      begin
        FileName := SaveDialog.FileName;

        AssignFile(ExtractFile, FileName);
        Rewrite(ExtractFile);

          {Now open the billing files for the year they selected and the prior year
           (in order to get dollar and percent changes).}

        _OpenBillingFiles(AssessmentYear, CollectionType, CollectionNumber, Quit);

          {Now go through the tax header file and extract any parcels that
           meet the specified criteria.}

        If not Quit
          then FillExtractFile(ExtractFile, AssessmentYear, CollectionType, CollectionNumber);

        CloseFile(ExtractFile);

      end;  {If SaveDialog.Execute}

end;  {StartButtonClick}

{==============================================================================}
Procedure TRyeBillExtractForm.FormClose(    Sender: TObject;
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