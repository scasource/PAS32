unit Rps995ut;

{This unit contains utilities to create RPS compatible file extracts.}

interface

USES Types, Glblvars, SysUtils, WinTypes, WinProcs, BtrvDlg,
     Messages, Dialogs, Forms, wwTable, Classes, DB, DBTables,
     Controls,DBCtrls,StdCtrls, PASTypes, WinUtils, GlblCnst, Utilitys,
     PasUtils, UTILEXSD;

type
  StrException = class(Exception);

  BaseInfoRecord = record
    TotalAssessedVal,
    LandVal,
    HstdAssessedVal,
    HstdLandVal,
    NonhstdAssessedVal,
    NonhstdLandVal,
    PriorHoldValue : Comp;
    RollSection,
    HomesteadCode,
    OwnershipCode : String;
    SchoolDistrict : String;
    ResidentialPercent : Real;
    PropertyClass : String;
    PriorHoldPropertyClass : String;
    PriorHoldStatus : String;
    PriorHoldHomesteadCode : String;
    PriorHoldRollSection : String;

  end;  {BaseInfoRecord = record}

Procedure InitializeRPSExtractString(RPSString : PRPSExtractRec);
{Initialize all the characters in the string to #0. This
 will let us know how far into the string we have copied
 (See the next function).}

Procedure RPSExtractStrCat(RPSSourceString : PRPSExtractRec;
                           StringToAdd : String);

Procedure WriteOneRPSExtractRecToFile(var RPSFile : TextFile;
                                          RPSRec : PRPSExtractRec;
                                          OldSwisSBLKey : String;
                                          UseOldSwisSBLKey : Boolean);
{Write one record of type RPSExtractRec to the given file.}

Procedure ExtractExemptionRecord(    ExemptionRec : PRPSExtractRec;
                                     ExemptionTable : TTable;
                                     TaxRollYear : String;
                                     ProcessingType : Integer;
                                     SwisSBLKey : String;
                                 var NumExemptionRecords : Integer;
                                     SetVillageExemptionFlagsToTrue : Boolean);

(*Procedure ExtractSDRecords(    SDTable : TTable;
                               TaxRollYear : String;
                               ProcessingType : Integer;
                               SwisSBLKey : String;
                               SDRecords : TList;
                           var NumSDRecords : Integer); {This is the number of physical SD records we have gone through.} *)

Procedure ExtractOneParcelRecord(    ParcelRec : PRPSExtractRec;
                                     ParcelTable,
                                     AssessmentTable,
                                     ExTable,
                                     EXCodeTable,
                                     SortAVChangesTable : TTable;
                                     SwisSBLKey : String;
                                     NumResSites,
                                     NumComSites,
                                     NumEXRecs,
                                     NumSDRecs,
                                     NumSaleRecs,
                                     ProcessingType : Integer;
                                     TaxableStatusDate : String;
                                     PriorValues,
                                     TYValues,
                                     NYValues : BaseInfoRecord;
                                 var EqualizationInc,
                                     PhysicalQtyInc,
                                     EqualizationDec,
                                     PhysicalQtyDec,
                                     PriorHoldValue : Comp;
                                 var HoldPriorRollSection,
                                     HoldPriorStatus,
                                     HoldPriorHomestead : String;
                                 var HoldPriorPropClass : String;
                                     PrintTYAndNY,
                                     Is210File : Boolean);

Procedure ExtractClassRecord(ClassTable,
                             ParcelTable,
                             ExemptionTable,
                             ExemptionCodeTable : TTable;
                             TaxRollYear : String;
                             ProcessingType : Integer;
                             SwisSBLKey : String;
                             ClassRec : PRPSExtractRec;
                             PriorValues,
                             TYValues,
                             NYValues : BaseInfoRecord);

Procedure ExtractLandRecords(LandTable : TTable;
                             LandRecords : TStringList;
                             SwisSBLKey : String;
                             SiteNumber,
                             SalesNumber : Integer;
                             IsSalesInventory : Boolean;
                             TaxRollYear : String);

Procedure ExtractImprovementRecords(ImprovementTable : TTable;
                                    ImprovementRecords : TStringList;
                                    SwisSBLKey : String;
                                    SiteNumber,
                                    SalesNumber : Integer;
                                    IsSalesInventory : Boolean;
                                    TaxRollYear : String);

Procedure ExtractForestRecords(ForestTable : TTable;
                               ForestRecords : TStringList;
                               SwisSBLKey : String;
                               SiteNumber,
                               SalesNumber : Integer;
                               IsSalesInventory : Boolean;
                               TaxRollYear : String);

Function ExtractResBldgRecord(BldgTable : TTable) : String;

Procedure ExtractRentRecords(RentTable : TTable;
                             RentRecords : TStringList;
                             SwisSBLKey : String;
                             SiteNumber,
                             SalesNumber : Integer;
                             IsSalesInventory : Boolean;
                             TaxRollYear : String);

Procedure ExtractComBldgRecords(BldgTable : TTable;
                                BldgRecords : TStringList;
                                SwisSBLKey : String;
                                SiteNumber,
                                SalesNumber : Integer;
                                IsSalesInventory : Boolean;
                                TaxRollYear : String);

Function ExtractIncExpRecord(IncExpTable : TTable) : String;

Procedure ExtractResInventoryRecords(ResInventoryRecords : TList;
                                     SiteTable,
                                     BldgTable,
                                     LandTable,
                                     ImprovementTable,
                                     ForestTable : TTable;
                                     SwisSBLKey : String;
                                     NumResSites,
                                     SalesNumber : Integer;
                                     IsSalesInventory : Boolean;
                                     TaxRollYear : String);

Procedure ExtractComInventoryRecords(ComInventoryRecords : TList;
                                     SiteTable,
                                     BldgTable,
                                     RentTable,
                                     LandTable,
                                     ImprovementTable,
                                     IncExpTable : TTable;
                                     SwisSBLKey : String;
                                     NumComSites,
                                     SalesNumber : Integer;
                                     IsSalesInventory : Boolean;
                                     TaxRollYear : String);

Procedure ExtractInformationForOneSale(var RPSFile : TextFile;
                                           SalesTable,
                                           ParcelTable,
                                           AssessmentTable,
                                           AssessmentYearCtlTable : TTable;
                                           SwisSBLKey,
                                           OldSwisSBLKey : String;
                                           UseOldSwisSBLKey : Boolean;
                                           SalesNumber : Integer;
                                           IncludeInventoryExtracts,
                                           SuppressSalesPrice,
                                           SalesReportExtract : Boolean);
{Given a sales table, SBL key, and a sales number, generate a sales extract
 record for this sales.}

{FXX10021997-2: Pass in the record so not alloc'ed 2x.}
Procedure ExtractOneSalesRecord(SalesRec : PRPSExtractRec;
                                SalesTable,
                                ParcelTable,
                                AssessmentTable,
                                AssessmentYearCtlTable : TTable;
                                SuppressSalesPrice,
                                SalesReportExtract : Boolean);
{Given a parcel sales table, create a text RPS 995 sales record.}

Procedure MarkLastRecordForSale(SalesRec : PRPSExtractRec;
                                ResInventoryRecords,
                                ComInventoryRecords : TList);

Procedure MarkLastRecordForParcel(ParcelExtractRecs,
                                  ClassExtractRecs,
                                  EXExtractRecs,
                                  SDExtractRecs,
                                  ResInventoryRecords,
                                  ComInventoryRecords : TList);

{Put a '999' in positions 37-39 of the last record (i.e. print order -
 which is the order they are passed in) for this parcel.}

implementation


{===========================================================}
Procedure InitializeRPSExtractString(RPSString : PRPSExtractRec);

{Initialize all the characters in the string to #0. This
 will let us know how far into the string we have copied
 (See the next function).}

var
  I : Integer;

begin
  For I := 1 to RPSExtractRecordLength do
    RPSString^[I] := #0;

end;  {InitializeRPSExtractString}

{===========================================================}
Procedure RPSExtractStrCat(RPSSourceString : PRPSExtractRec;
                           StringToAdd : String);

{Add the StringToAdd to the end of RPSSourceString. We will
 start with wherever the first #0 occurs. If we go past the
 end of the string, we will raise an exception.}

var
  I, StartPos : Integer;
  RaiseException : Boolean;

begin
  I := 1;
  RaiseException := False;
  StartPos := 1;

  If (Pos(#0, StringToAdd) > 0)
    then Raise StrException.Create('A string was passed in with a null char.' +
                                   StringToAdd);

  while ((RPSSourceString^[I] <> #0) and
         (I <= RPSExtractRecordLength)) do
    I := I + 1;

  If (I > RPSExtractRecordLength)
    then RaiseException := True
    else StartPos := I;

  If not RaiseException
    then
      begin
        If ((StartPos + Length(StringToAdd) - 1) > RPSExtractRecordLength)
          then RaiseException := True
          else
            For I := 1 to Length(StringToAdd) do
              RPSSourceString^[I + StartPos - 1] := StringToAdd[I];

      end;  {If not RaiseException}

  If RaiseException
    then Raise StrException.Create('Source string is too long for RPS extract record.');

end;  {RPSExtractStrCat}

{============================================================}
Procedure WriteOneRPSExtractRecToFile(var RPSFile : TextFile;
                                          RPSRec : PRPSExtractRec;
                                          OldSwisSBLKey : String;
                                          UseOldSwisSBLKey : Boolean);

{Write one record of type RPSExtractRec to the given file.}

var
  I : Integer;

begin
    {CHG04062000-1: Use old parcel ID in sales.}

  If UseOldSwisSBLKey
    then
      For I := 1 to 26 do
        RPSRec^[I] := OldSwisSBLKey[I];

  For I := 1 to RPSExtractRecordLength do
    Write(RPSFile, RPSRec^[I]);

  Writeln(RPSFile);

end;  {WriteOneRPSExtractRecToFile}

{=======================================================================}
Function ExtractOneLandRecord(LandTable : TTable) : String;

{Extract the land record that is presently pointed to in the land table.}
{Note that the offsets are only within this record.}

begin
  Result := '';

  with LandTable do
    begin
      Result := ShiftRightAddZeroes(Take(2, FieldByName('LandNumber').Text));  {1-2}
      Result := Result + Take(2, FieldByName('LandTypeCode').Text);  {3-4}
      Result := Result + ShiftRightAddZeroes(Take(4, FieldByName('Frontage').Text)); {5-8}
      Result := Result + ShiftRightAddZeroes(Take(4, FieldByName('Depth').Text));  {9-12}
      Result := Result + FormatRPSNumericString(FieldByName('Acreage').Text, 7, 2);  {13-19}
      Result := Result + FormatRPSNumericString(FieldByName('SquareFootage').Text, 8, 0);  {20-27}
      Result := Result + Take(2, FieldByName('SoilRatingCode').Text);  {28-29}
      Result := Result + Take(1, FieldByName('InfluenceCode').Text);  {30-30}
      Result := Result + FormatRPSNumericString(FieldByName('InfluencePercent').Text, 3, 2); {31-33}
      Result := Result + FormatRPSNumericString(FieldByName('DepthFactor').Text, 3, 2);  {34-36}
      Result := Result + FormatRPSNumericString(FieldByName('LandValue').Text, 9, 0);  {37-45}
      Result := Result + FormatRPSNumericString(FieldByName('UnitPrice').Text, 10, 3);  {46-55}
      Result := Result + Take(1, FieldByName('WaterfrontTypeCode').Text);  {56-56}

    end;  {with LandTable do}

end;  {ExtractOneLandRecord}

{=======================================================================}
Function CreateBlankLandRecord : String;

{Create a blank land record to be compatible with RPS995 - put zeroes in
 numeric fields and blanks in non-numeric fields.}
{Note that the offsets are only within this record.}

begin
  Result := Take(2, '');  {1-2}
  Result := Result + Take(2, '');  {3-4}
  Result := Result + ShiftRightAddZeroes(Take(4, '')); {5-8}
  Result := Result + ShiftRightAddZeroes(Take(4, ''));  {9-12}
  Result := Result + ShiftRightAddZeroes(Take(7, ''));  {13-19}
  Result := Result + ShiftRightAddZeroes(Take(8, ''));  {20-27}
  Result := Result + Take(2, '');  {28-29}
  Result := Result + Take(1, '');  {30-30}
  Result := Result + ShiftRightAddZeroes(Take(3, '')); {31-33}
  Result := Result + ShiftRightAddZeroes(Take(3, ''));  {34-36}
  Result := Result + ShiftRightAddZeroes(Take(9, ''));  {37-45}
  Result := Result + ShiftRightAddZeroes(Take(10, ''));  {46-55}
  Result := Result + ShiftRightAddZeroes(Take(1, ''));  {56-56}

end;  {CreateBlankLandRecord}

{==============================================================================}
Procedure ExtractLandRecords(LandTable : TTable;
                             LandRecords : TStringList;
                             SwisSBLKey : String;
                             SiteNumber,
                             SalesNumber : Integer;
                             IsSalesInventory : Boolean;
                             TaxRollYear : String);

var
  Done, Quit, FirstTimeThrough : Boolean;
  TempStr : String;

begin
  Done := False;
  Quit := False;
  FirstTimeThrough := True;

  If IsSalesInventory
    then SetRangeOld(LandTable,
                     ['SwisSBLKey', 'SalesNumber', 'Site', 'LandNumber'],
                     [SwisSBLKey, IntToStr(SalesNumber), IntToStr(SiteNumber), '0'],
                     [SwisSBLKey, IntToStr(SalesNumber), IntToStr(SiteNumber), '32000'])
    else SetRangeOld(LandTable,
                     ['TaxRollYr', 'SwisSBLKey', 'Site', 'LandNumber'],
                     [TaxRollYear, SwisSBLKey, IntToStr(SiteNumber), '0'],
                     [TaxRollYear, SwisSBLKey, IntToStr(SiteNumber), '32000']);

  TempStr := LandTable.FieldByName('SwisSBLKey').Text;

  try
    LandTable.First;
  except
    Quit := True;
    SystemSupport(001, LandTable, 'Error getting first Land record.', 'EXTRUTIL.PAS',
                  GlblErrorDlgBox);
  end;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else
        try
          LandTable.Next;
        except
          Quit := True;
          SystemSupport(002, LandTable, 'Error getting first next record.', 'EXTRUTIL.PAS',
                        GlblErrorDlgBox);
        end;

    If LandTable.EOF
      then Done := True;

      {If this is a good Land record and should be extracted, then we will extract it.
       If we are including inventory, then we will add that, too.}

    If not (Done or Quit)
      then LandRecords.Add(ExtractOneLandRecord(LandTable));

  until (Done or Quit);

end;  {ExtractLandRecords}

{=======================================================================}
Function ExtractOneImprovementRecord(ImprovementTable : TTable) : String;

{Extract the Improvement record that is presently pointed to in the Improvement table.}
{Note that the offsets are only within this record.}

begin
  Result := '';

  with ImprovementTable do
    begin
      Result := ShiftRightAddZeroes(Take(2, FieldByName('ImprovementNumber').Text));  {1-2}
      Result := Result + Take(3, FieldByName('StructureCode').Text);  {3-5}
      Result := Result + Take(1, FieldByName('MeasureCode').Text);  {6-6}
      Result := Result + ShiftRightAddZeroes(Take(6, FieldByName('Dimension1').Text));  {7-12}
      Result := Result + ShiftRightAddZeroes(Take(6, FieldByName('Dimension2').Text));  {13-18}
      Result := Result + ShiftRightAddZeroes(Take(3, FieldByName('Quantity').Text));  {19-21}
      Result := Result + Take(1, FieldByName('GradeCode').Text);  {22-22}
      Result := Result + Take(1, FieldByName('ConditionCode').Text);  {23-23}
      Result := Result + ShiftRightAddZeroes(Take(4, FieldByName('YearBuilt').Text));  {24-27}
      Result := Result + FormatRPSNumericString(FieldByName('PercentGood').Text, 3, 0);  {28-30}
      Result := Result + FormatRPSNumericString(FieldByName('FunctionalObsolescen').Text, 3, 0);  {31-33}
      Result := Result + FormatRPSNumericString(FieldByName('ReplacementCostNew').Text, 9, 0);  {34-42}
      Result := Result + FormatRPSNumericString(FieldByName('RCNLessDepreciation').Text, 9, 0);  {43-51}

    end;  {with ImprovementTable do}

end;  {ExtractOneImprovementRecord}

{=======================================================================}
Function CreateBlankImprovementRecord : String;

{Create a blank improvement record to be compatible with RPS995 - put zeroes in
 numeric fields and blanks in non-numeric fields.}
{Note that the offsets are only within this record.}

begin
  Result := Take(2, '');
  Result := Result + Take(3, '');  {3-5}
  Result := Result + Take(1, '');  {6-6}
  Result := Result + ShiftRightAddZeroes(Take(6, ''));  {7-12}
  Result := Result + ShiftRightAddZeroes(Take(6, ''));  {13-18}
  Result := Result + ShiftRightAddZeroes(Take(3, ''));  {19-21}
  Result := Result + Take(1, '');  {22-22}
  Result := Result + Take(1, '');  {23-23}
  Result := Result + ShiftRightAddZeroes(Take(4, ''));  {24-27}
  Result := Result + ShiftRightAddZeroes(Take(3, ''));  {28-30}
  Result := Result + ShiftRightAddZeroes(Take(3, ''));  {31-33}
  Result := Result + ShiftRightAddZeroes(Take(9, ''));  {34-42}
  Result := Result + ShiftRightAddZeroes(Take(9, ''));  {43-51}

end;  {CreateBlankImprovementRecord}

{==============================================================================}
Procedure ExtractImprovementRecords(ImprovementTable : TTable;
                                    ImprovementRecords : TStringList;
                                    SwisSBLKey : String;
                                    SiteNumber,
                                    SalesNumber : Integer;
                                    IsSalesInventory : Boolean;
                                    TaxRollYear : String);

var
  Done, Quit, FirstTimeThrough : Boolean;

begin
  Done := False;
  Quit := False;
  FirstTimeThrough := True;

  If IsSalesInventory
    then SetRangeOld(ImprovementTable,
                     ['SwisSBLKey', 'SalesNumber', 'Site', 'ImprovementNumber'],
                     [SwisSBLKey, IntToStr(SalesNumber), IntToStr(SiteNumber), '0'],
                     [SwisSBLKey, IntToStr(SalesNumber), IntToStr(SiteNumber), '32000'])
    else SetRangeOld(ImprovementTable,
                     ['TaxRollYr', 'SwisSBLKey', 'Site', 'ImprovementNumber'],
                     [TaxRollYear, SwisSBLKey, IntToStr(SiteNumber), '0'],
                     [TaxRollYear, SwisSBLKey, IntToStr(SiteNumber), '32000']);

  try
    ImprovementTable.First;
  except
    Quit := True;
    SystemSupport(001, ImprovementTable, 'Error getting first Improvement record.', 'EXTRUTIL.PAS',
                  GlblErrorDlgBox);
  end;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else
        try
          ImprovementTable.Next;
        except
          Quit := True;
          SystemSupport(002, ImprovementTable, 'Error getting first next record.', 'EXTRUTIL.PAS',
                        GlblErrorDlgBox);
        end;

    If ImprovementTable.EOF
      then Done := True;

      {If this is a good Improvement record and should be extracted, then we will extract it.
       If we are including inventory, then we will add that, too.}

    If not (Done or Quit)
      then ImprovementRecords.Add(ExtractOneImprovementRecord(ImprovementTable));

  until (Done or Quit);

end;  {ExtractImprovementRecords}

{=======================================================================}
Function ExtractOneForestRecord(ForestTable : TTable) : String;

{Extract the Forest record that is presently pointed to in the Forest table.}
{Note that the offsets are only within this record.}

begin
  Result := '';

  with ForestTable do
    begin
      Result := ShiftRightAddZeroes(Take(2, FieldByName('ForestNumber').Text));  {1-2}
      Result := Result + Take(1, FieldByName('RegionCode').Text);  {3-3}
      Result := Result + Take(2, FieldByName('ForestTypeCode').Text);  {4-5}
      Result := Result + Take(2, FieldByName('SiteClassCode').Text);  {6-7}
      Result := Result + Take(1, FieldByName('VolAcreClassCode').Text);  {8-8}
      Result := Result + Take(1, FieldByName('CutClassCode').Text);  {9-9}
      Result := Result + Take(1, FieldByName('AccessibilityCode').Text);  {10-10}
      Result := Result + Take(1, FieldByName('LoggingEaseCode').Text);  {11-11}
      Result := Result + Take(1, FieldByName('NominalValueCode').Text);  {12-12}
      Result := Result + FormatRPSNumericString(FieldByName('ShorelineFrontage').Text, 5, 0);  {13-17}
      Result := Result + FormatRPSNumericString(FieldByName('Acres').Text, 6, 0);  {18-23}
      Result := Result + FormatRPSNumericString(FieldByName('Value').Text, 9, 0);  {24-32}

    end;  {with ForestTable do}

end;  {ExtractOneForestRecord}

{=======================================================================}
Function CreateBlankForestRecord : String;

{Create a blank improvement record to be compatible with RPS995 - put zeroes in
 numeric fields and blanks in non-numeric fields.}
{Note that the offsets are only within this record.}

begin
  Result := Take(2, '');  {1-2}
  Result := Result + Take(1, '');  {3-3}
  Result := Result + Take(2, '');  {4-5}
  Result := Result + Take(2, '');  {6-7}
  Result := Result + Take(1, '');  {8-8}
  Result := Result + Take(1, '');  {9-9}
  Result := Result + Take(1, '');  {10-10}
  Result := Result + Take(1, '');  {11-11}
  Result := Result + Take(1, '');  {12-12}
  Result := Result + ShiftRightAddZeroes(Take(5, ''));  {13-17}
  Result := Result + ShiftRightAddZeroes(Take(6, ''));  {18-23}
  Result := Result + ShiftRightAddZeroes(Take(9, ''));  {24-32}

end;  {CreateBlankForestRecord}

{==============================================================================}
Procedure ExtractForestRecords(ForestTable : TTable;
                               ForestRecords : TStringList;
                               SwisSBLKey : String;
                               SiteNumber,
                               SalesNumber : Integer;
                               IsSalesInventory : Boolean;
                               TaxRollYear : String);

var
  Done, Quit, FirstTimeThrough : Boolean;

begin
  Done := False;
  Quit := False;
  FirstTimeThrough := True;

  If IsSalesInventory
    then SetRangeOld(ForestTable,
                     ['SwisSBLKey', 'SalesNumber', 'Site', 'ForestNumber'],
                     [SwisSBLKey, IntToStr(SalesNumber), IntToStr(SiteNumber), '0'],
                     [SwisSBLKey, IntToStr(SalesNumber), IntToStr(SiteNumber), '32000'])
    else SetRangeOld(ForestTable,
                     ['TaxRollYr', 'SwisSBLKey', 'Site', 'ForestNumber'],
                     [TaxRollYear, SwisSBLKey, IntToStr(SiteNumber), '0'],
                     [TaxRollYear, SwisSBLKey, IntToStr(SiteNumber), '32000']);

  try
    ForestTable.First;
  except
    Quit := True;
    SystemSupport(001, ForestTable, 'Error getting first Forest record.', 'EXTRUTIL.PAS',
                  GlblErrorDlgBox);
  end;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else
        try
          ForestTable.Next;
        except
          Quit := True;
          SystemSupport(002, ForestTable, 'Error getting first next record.', 'EXTRUTIL.PAS',
                        GlblErrorDlgBox);
        end;

    If ForestTable.EOF
      then Done := True;

      {If this is a good Forest record and should be extracted, then we will extract it.
       If we are including inventory, then we will add that, too.}

    If not (Done or Quit)
      then ForestRecords.Add(ExtractOneForestRecord(ForestTable));

  until (Done or Quit);

end;  {ExtractForestRecords}

{==============================================================================}
Function ExtractResSiteRecord(SiteTable : TTable) : String;

begin
  Result := '';

  with SiteTable do
    begin
      Result := Take(3, FieldByName('PropertyClassCode').Text);  {59-61}
      Result := Result + Take(9, FieldByName('RouteNumber').Text);  {62-70}
      Result := Result + ShiftRightAddZeroes(Take(5, FieldByName('NeighborhoodCode').Text));  {71-75}
      Result := Result + Take(5, FieldByName('ZoningCode').Text);  {76-80}
      Result := Result + Take(1, FieldByName('SewerTypeCode').Text);  {81-81}
      Result := Result + Take(1, FieldByName('WaterSupplyCode').Text);  {82-82}
      Result := Result + Take(1, FieldByName('UtilityTypeCode').Text);  {83-83}
      Result := Result + Take(1, FieldByName('DesirabilityCode').Text);  {84-84}
      Result := Result + Take(1, FieldByName('D_CEntryTypeCode').Text);  {85-85}
      Result := Result + BoolToChar_Blank_1(TBooleanField(FieldByName('MailerSent')).AsBoolean);  {86-86}  {blank, 1}
      Result := Result + FormatRPSNumericString(FieldByName('FinalTotalValue').Text, 12, 0);  {87-98}
      Result := Result + FormatRPSNumericString(FieldByName('FinalLandValue').Text, 12, 0);  {99-110}
      Result := Result + FormatRPSNumericString(FieldByName('ReplacementCost').Text, 12, 0);  {111-122}
      Result := Result + FormatRPSNumericString(FieldByName('RCNLessDepreciation').Text, 12, 0);  {123-134}
      Result := Result + FormatRPSNumericString(FieldByName('LandValue').Text, 12, 0);  {135-146}
      Result := Result + FormatRPSNumericString(FieldByName('ModelEstimate').Text, 12, 0);  {147-158}
      Result := Result + FormatRPSNumericString(FieldByName('MarketEstimate').Text, 12, 0);  {159-170}
      Result := Result + Take(1, FieldByName('NghbrhdTypeCode').Text);  {171-171}
      Result := Result + Take(1, FieldByName('NghbrhdRatingCode').Text);  {172-172}
      Result := Result + Take(1, FieldByName('RoadTypeCode').Text);  {173-173}
      Result := Result + Take(9, FieldByName('LaserDiskFrameNo').Text);  {174-182}

    end;  {with SiteTable do}

end;  {ExtractResSiteRecord}

{==========================================================}
Function ExtractResBldgRecord(BldgTable : TTable) : String;

{Extract the information for one residential bldg.}

begin
  Result := '';

  with BldgTable do
    begin
      Result := Result + Take(2, FieldByName('BuildingStyleCode').Text);  {295-296}
      Result := Result + FormatRPSNumericString(FieldByName('NumberOfStories').Text, 2, 1);  {297-298}
      Result := Result + Take(2, FieldByName('ExtWallMaterialCode').Text);  {299-300}
      Result := Result + Take(4, FieldByName('ActualYearBuilt').Text);  {301-304}
      Result := Result + ShiftRightAddZeroes(Take(1, FieldByName('NumberOfKitchens').Text));  {305-305}
      Result := Result + FormatRPSNumericString(FieldByName('NumberOfBathrooms').Text, 3, 1);  {306-308}
      Result := Result + ShiftRightAddZeroes(Take(2, FieldByName('NumberOfBedrooms').Text));  {309-310}
      Result := Result + ShiftRightAddZeroes(Take(2, FieldByName('NumberOfFireplaces').Text));  {311-312}
      Result := Result + Take(1, FieldByName('HeatTypeCode').Text);  {313-313}
      Result := Result + Take(1, FieldByName('FuelTypeCode').Text);  {314-314}
      Result := Result + BoolToChar_Blank_1(TBooleanField(FieldByName('CentralAir')).AsBoolean);  {315-315}  {blank, 1}
      Result := Result + Take(1, FieldByName('BasementTypeCode').Text);  {316-316}
      Result := Result + ShiftRightAddZeroes(Take(1, FieldByName('BasementGarCapacity').Text));  {317-317}
      Result := Result + Take(1, FieldByName('ConditionCode').Text);  {318-318}
      Result := Result + Take(1, FieldByName('OverallGradeCode').Text);  {319-319}
      Result := Result + FormatRPSNumericString(FieldByName('GradeAdjustment').Text, 3, 2);  {320-322}
      Result := Result + Take(1, FieldByName('PorchTypeCode').Text);  {323-323}
      Result := Result + ShiftRightAddZeroes(Take(4, FieldByName('PorchArea').Text));  {324-327}
      Result := Result + ShiftRightAddZeroes(Take(1, FieldByName('AttachedGarCapacity').Text));  {328-328}
      Result := Result + ShiftRightAddZeroes(Take(5, FieldByName('FirstStoryArea').Text));  {329-333}
      Result := Result + ShiftRightAddZeroes(Take(5, FieldByName('SecondStoryArea').Text));  {334-338}
      Result := Result + ShiftRightAddZeroes(Take(5, FieldByName('ThirdStoryArea').Text));  {339-343}
      Result := Result + ShiftRightAddZeroes(Take(5, FieldByName('HalfStoryArea').Text));  {344-348}
      Result := Result + ShiftRightAddZeroes(Take(5, FieldByName('ThreeQuarterStoryAre').Text));  {349-353}
      Result := Result + ShiftRightAddZeroes(Take(5, FieldByName('FinishedAreaOverGara').Text));  {354-358}
      Result := Result + ShiftRightAddZeroes(Take(5, FieldByName('FinishedAtticArea').Text));  {359-363}
      Result := Result + ShiftRightAddZeroes(Take(5, FieldByName('FinishedBasementArea').Text));  {364-368}
      Result := Result + ShiftRightAddZeroes(Take(5, FieldByName('UnfinishedHalfStory').Text));  {369-373}
      Result := Result + ShiftRightAddZeroes(Take(5, FieldByName('Unfinished3_4Story').Text));  {374-378}
      Result := Result + ShiftRightAddZeroes(Take(5, FieldByName('UnfinishedRoom').Text));  {379-383}
      Result := Result + ShiftRightAddZeroes(Take(5, FieldByName('SqFootLivingArea').Text));  {384-388}
      Result := Result + ShiftRightAddZeroes(Take(5, FieldByName('FinishedRecRoom').Text));  {389-393}
      Result := Result + FormatRPSNumericString(FieldByName('ReplacementCostNew').Text, 9, 0);  {394-402}
      Result := Result + FormatRPSNumericString(FieldByName('RCNLessDepreciation').Text, 9, 0);  {403-411}
      Result := Result + FormatRPSNumericString(FieldByName('PercentGood').Text, 3, 0);  {412-414}
      Result := Result + FormatRPSNumericString(FieldByName('FunctionalObsolescen').Text, 3, 0);  {415-417}

    end;  {with BldgTable do}

end;  {ExtractResBldgRecord}

{==============================================================================}
Function ExtractResSiteHdrRecord(SiteTable : TTable;
                                 NumResSites,
                                 SalesNumber,
                                 TotalOverflowRecs,
                                 LastLandItem,
                                 LastImprovementItem,
                                 TotalForestStands,
                                 LastForestItem : Integer;
                                 IsSalesInventory : Boolean) : String;

{Return a string with the header information for a base
 residential site record.}

begin
  Result := '';

  with SiteTable do
    begin
      Result := Result + Take(26, FieldByName('SwisSBLKey').Text);  {1-26}

      If IsSalesInventory
        then Result := Result + ShiftRightAddZeroes(Take(2, IntToStr(SalesNumber)))  {27-28}
        else Result := Result + Take(2, '00');  {27-28}

      Result := Result + Take(1, '2');  {29-29}
      Result := Result + ShiftRightAddZeroes(Take(2, FieldByName('Site').Text));  {30-31}
      Result := Result + Take(1, 'R'); {32-32}
      Result := Result + Take(2, '00');  {33-34}
      Result := Result + Take(2, '');  {35-36}
      Result := Result + Take(3, '');  {37-39}

      Result := Result + Take(6, MakeMMDDYY(TDateField(FieldByName('LastChangeDate')).AsDateTime));  {40-45}
      Result := Result + Take(3, FieldByName('LastChangeByName').Text);  {46-48}
      Result := Result + ShiftRightAddZeroes(Take(2, IntToStr(TotalOverflowRecs)));  {49-50}
      Result := Result + ShiftRightAddZeroes(Take(2, IntToStr(LastLandItem)));  {51-52}
      Result := Result + ShiftRightAddZeroes(Take(2, IntToStr(LastImprovementItem)));  {53-54}
      Result := Result + ShiftRightAddZeroes(Take(2, IntToStr(TotalForestStands)));  {55-56}
      Result := Result + ShiftRightAddZeroes(Take(2, IntToStr(LastForestItem)));  {57-58}

    end;  {with SiteTable do}

end;  {ExtractResSiteHdrRecord}

{==============================================================================}
Function ExtractSiteOverflowHdrRecord(SiteTable : TTable;
                                      InvType : Char;  {'R' -> Res, 'C' -> 'Com'}
                                      RecordNo,
                                      SalesNumber,
                                      TotalOverflowRecs,
                                      TotalForestStands : Integer;
                                      IsSalesInventory,
                                      ParcelHasComIncExpRec : Boolean) : String;

{Return a string with the header for a residential inventory overflow record.}

begin
  Result := '';

  with SiteTable do
    begin
      Result := Result + Take(26, FieldByName('SwisSBLKey').Text);  {1-25}

      If IsSalesInventory
        then Result := Result + ShiftRightAddZeroes(Take(2, IntToStr(SalesNumber)))  {26-27}
        else Result := Result + Take(2, '00');  {26-27}

      Result := Result + Take(1, '2');  {28-28}
      Result := Result + ShiftRightAddZeroes(Take(2, FieldByName('Site').Text));  {29-30}
      Result := Result + Take(1, InvType);  {31-32}
      Result := Result + ShiftRightAddZeroes(Take(2, IntToStr(RecordNo)));  {33-34}
      Result := Result + Take(2, '');  {35-36}
      Result := Result + Take(3, '');  {37-39}

      Result := Result + Take(6, MakeMMDDYY(TDateField(FieldByName('LastChangeDate')).AsDateTime));  {40-45}
      Result := Result + Take(3, FieldByName('LastChangeByName').Text);  {46-48}

    end;  {with SiteTable do}

end;  {ExtractSiteOverflowHdrRecord}

{==============================================================================}
Function ExtractForestHdrRecord(SiteTable : TTable;
                                RecordNo,
                                SalesNumber,
                                TotalForestStands : Integer;
                                IsSalesInventory : Boolean) : String;

{Return a string with the header for an inventory overflow
 record.}

begin
  Result := '';

  with SiteTable do
    begin
      Result := Result + Take(26, FieldByName('SwisSBLKey').Text);  {1-25}

      If IsSalesInventory
        then Result := Result + ShiftRightAddZeroes(Take(2, IntToStr(SalesNumber)))  {26-27}
        else Result := Result + Take(2, '00');  {26-27}

      Result := Result + '2';  {28-28}
      Result := Result + ShiftRightAddZeroes(Take(2, FieldByName('Site').Text));  {29-30}
      Result := Result + 'R';  {31-32}
      Result := Result + ShiftRightAddZeroes(Take(2, IntToStr(RecordNo)));  {33-34}
      Result := Result + Take(2, '');  {35-36}
      Result := Result + Take(3, '');  {37-39}

      Result := Result + Take(6, MakeMMDDYY(TDateField(FieldByName('LastChangeDate')).AsDateTime));  {40-45}
      Result := Result + Take(3, FieldByName('LastChangeByName').Text);  {46-48}
      Result := Result + Take(2, '');  {49-50}

    end;  {with SiteTable do}

end;  {ExtractForestHdrRecord}

{==============================================================================}
Function ExtractComSiteHdrRecord(SiteTable : TTable;
                                 NumComSites,
                                 SalesNumber,
                                 TotalOverflowRecs,
                                 LastLandItem,
                                 LastImprovementItem,
                                 LastRentItem,
                                 LastBldgItem : Integer;
                                 IsSalesInventory,
                                 ParcelHasIncExpRec : Boolean) : String;

{Return a string with the header information for a base
 residential site record.}

begin
  Result := '';

  with SiteTable do
    begin
      Result := Result + Take(26, FieldByName('SwisSBLKey').Text);  {1-26}

      If IsSalesInventory
        then Result := Result + ShiftRightAddZeroes(Take(2, IntToStr(SalesNumber)))  {27-28}
        else Result := Result + Take(2, '00');  {27-28}

      Result := Result + Take(1, '2');  {29-29}
      Result := Result + ShiftRightAddZeroes(Take(2, FieldByName('Site').Text));  {30-31}
      Result := Result + Take(1, 'C'); {32-32}
      Result := Result + Take(2, '00');  {33-34}
      Result := Result + Take(2, '');  {35-36}
      Result := Result + Take(3, '');  {37-39}

      Result := Result + Take(6, MakeMMDDYY(TDateField(FieldByName('LastChangeDate')).AsDateTime));  {40-45}
      Result := Result + Take(3, FieldByName('LastChangeByName').Text);  {46-48}
      Result := Result + ShiftRightAddZeroes(Take(2, IntToStr(TotalOverflowRecs)));  {49-50}
      Result := Result + ShiftRightAddZeroes(Take(2, IntToStr(LastLandItem)));  {51-52}
      Result := Result + ShiftRightAddZeroes(Take(2, IntToStr(LastImprovementItem)));  {53-54}
      Result := Result + ShiftRightAddZeroes(Take(2, IntToStr(LastBldgItem)));  {55-56}
      Result := Result + ShiftRightAddZeroes(Take(2, IntToStr(LastRentItem)));  {57-58}

    end;  {with SiteTable do}

end;  {ExtractComSiteHdrRecord}

{==============================================================================}
Function ExtractComSiteRecord(SiteTable : TTable) : String;

begin
  Result := '';

  with SiteTable do
    begin
      Result := Take(3, FieldByName('PropertyClassCode').Text);  {59-61}
      Result := Result + Take(3, FieldByName('UsedAsCode').Text);  {62-64}
      Result := Result + Take(9, FieldByName('RouteNumber').Text);  {65-73}
      Result := Result + ShiftRightAddZeroes(Take(5, FieldByName('NeighborhoodCode').Text));  {74-78}
      Result := Result + Take(5, FieldByName('ZoningCode').Text);  {79-83}
      Result := Result + Take(2, FieldByName('ValuationDistCode').Text);  {84-85}
      Result := Result + Take(1, FieldByName('SewerTypeCode').Text);  {86-86}
      Result := Result + Take(1, FieldByName('WaterSupplyCode').Text);  {87-87}
      Result := Result + Take(1, FieldByName('UtilitiesCode').Text);  {88-88}
      Result := Result + Take(1, FieldByName('DesirabilityCode').Text);  {89-89}
      Result := Result + Take(1, FieldByName('ConditionCode').Text);  {90-90}
      Result := Result + Take(4, FieldByName('EffectiveYearBuilt').Text);  {91-94}
      Result := Result + Take(1, FieldByName('GradeCode').Text);  {95-95}
      Result := Result + Take(1, FieldByName('EntryCode').Text);  {96-96}
      Result := Result + BoolToChar_Blank_1(TBooleanField(FieldByName('MailerSent')).AsBoolean);  {97-97}  {blank, 1}
      Result := Result + FormatRPSNumericString(FieldByName('FinalTotalValue').Text, 12, 0);  {98-109}
      Result := Result + FormatRPSNumericString(FieldByName('FinalLandValue').Text, 12, 0);  {110-121}
      Result := Result + FormatRPSNumericString(FieldByName('ReplacementCostNew').Text, 12, 0);  {122-133}
      Result := Result + FormatRPSNumericString(FieldByName('RCNLessDeprec').Text, 12, 0);  {134-145}
      Result := Result + FormatRPSNumericString(FieldByName('LandEstimate').Text, 12, 0);  {146-157}
      Result := Result + FormatRPSNumericString(FieldByName('TotalEstimate').Text, 12, 0);  {158-169}
      Result := Result + FormatRPSNumericString(FieldByName('ExcessValue').Text, 9, 0);  {170-178}
      Result := Result + Take(9, FieldByName('LaserDiskFrameNo').Text);  {179-187}

    end;  {with SiteTable do}

end;  {ExtractComSiteRecord}

{=======================================================================}
Function ExtractOneComBldgRecord(BldgTable : TTable) : String;

{Extract the commercial bldg record that is presently pointed to in the Bldg table.}
{Note that the offsets are only within this record.}

begin
  Result := '';

  with BldgTable do
    begin
      Result := ShiftRightAddZeroes(Take(2, FieldByName('BuildingNumber').Text));  {1-2}
      Result := Result + Take(1, FieldByName('BuildingSection').Text);  {3-3}
      Result := Result + ShiftRightAddZeroes(Take(3, FieldByName('NumberIdentBldgs').Text)); {4-6}
      Result := Result + Take(4, FieldByName('BoeckhModelCode').Text);  {7-10}
      Result := Result + Take(4, FieldByName('EffectiveYearBuilt').Text);  {11-14}
      Result := Result + FormatRPSNumericString(FieldByName('ConstructionQualCode').Text, 2, 1);  {15-16}
      Result := Result + FormatRPSNumericString(FieldByName('UserAdjustment').Text, 3, 2);  {17-19}
      Result := Result + Take(1, FieldByName('ConditionCode').Text);  {20-20}
      Result := Result + FormatRPSNumericString(FieldByName('BuildingPerimeter').Text, 6, 0); {21-26}
      Result := Result + FormatRPSNumericString(FieldByName('GrossFloorArea').Text, 7, 0);  {27-33}
      Result := Result + ShiftRightAddZeroes(Take(2, FieldByName('NumberStories').Text)); {34-35}
      Result := Result + ShiftRightAddZeroes(Take(2, FieldByName('StoryHeight').Text)); {36-37}
      Result := Result + FormatRPSNumericString(FieldByName('WallAPercent').Text, 3, 0);  {38-40}
      Result := Result + FormatRPSNumericString(FieldByName('WallBPercent').Text, 3, 0);  {41-43}
      Result := Result + FormatRPSNumericString(FieldByName('WallCPercent').Text, 3, 0);  {44-46}
      Result := Result + FormatRPSNumericString(FieldByName('AirCondPercent').Text, 3, 0);  {47-49}
      Result := Result + FormatRPSNumericString(FieldByName('SprinklerPercent').Text, 3, 0);  {50-52}
      Result := Result + FormatRPSNumericString(FieldByName('AlarmPercent').Text, 3, 0);  {53-55}
      Result := Result + ShiftRightAddZeroes(Take(2, FieldByName('NumberOfElevators').Text)); {56-57}
      Result := Result + Take(1, FieldByName('BasementTypeCode').Text);  {58-58}
      Result := Result + FormatRPSNumericString(FieldByName('BasementPerimeter').Text, 6, 0); {59-64}
      Result := Result + FormatRPSNumericString(FieldByName('BasementSquareFeet').Text, 7, 0); {65-71}

    end;  {with BldgTable do}

end;  {ExtractOneComBldgRecord}

{=======================================================================}
Function CreateBlankComBldgRecord : String;

{Create a blank land record to be compatible with RPS995 - put zeroes in
 numeric fields and blanks in non-numeric fields.}
{Note that the offsets are only within this record.}

begin
  Result := Take(2, '');  {1-2}
  Result := Result + Take(1, '');  {3-3}
  Result := Result + ShiftRightAddZeroes(Take(3, '')); {4-6}
  Result := Result + ShiftRightAddZeroes(Take(4, ''));  {7-10}
  Result := Result + ShiftRightAddZeroes(Take(4, ''));  {11-14}
  Result := Result + ShiftRightAddZeroes(Take(2, ''));  {15-16}
  Result := Result + ShiftRightAddZeroes(Take(3, ''));  {17-19}
  Result := Result + Take(1, '');  {20-20}
  Result := Result + ShiftRightAddZeroes(Take(6, '')); {21-26}
  Result := Result + ShiftRightAddZeroes(Take(7, ''));  {27-33}
  Result := Result + ShiftRightAddZeroes(Take(2, '')); {34-35}
  Result := Result + ShiftRightAddZeroes(Take(2, '')); {36-37}
  Result := Result + ShiftRightAddZeroes(Take(3, ''));  {38-40}
  Result := Result + ShiftRightAddZeroes(Take(3, ''));  {41-43}
  Result := Result + ShiftRightAddZeroes(Take(3, ''));  {44-46}
  Result := Result + ShiftRightAddZeroes(Take(3, ''));  {47-49}
  Result := Result + ShiftRightAddZeroes(Take(3, ''));  {50-52}
  Result := Result + ShiftRightAddZeroes(Take(3, ''));  {53-55}
  Result := Result + ShiftRightAddZeroes(Take(2, '')); {56-57}
  Result := Result + Take(1, '');  {58-58}
  Result := Result + ShiftRightAddZeroes(Take(6, '')); {59-64}
  Result := Result + ShiftRightAddZeroes(Take(7, '')); {65-71}

end;  {CreateBlankComBldgRecord}

{=======================================================================}
Function ExtractOneRentRecord(RentTable : TTable) : String;

{Extract the Rent record that is presently pointed to in the Rent table.}
{Note that the offsets are only within this record.}

begin
  Result := '';

  with RentTable do
    begin
      Result := ShiftRightAddZeroes(Take(2, FieldByName('UseNumber').Text));  {1-2}
      Result := Result + Take(3, FieldByName('UsedAsCode').Text);  {3-5}
      Result := Result + Take(2, FieldByName('ValuationDistCode').Text);  {6-7}
      Result := Result + FormatRPSNumericString(FieldByName('TotalRentableArea').Text, 7, 0);  {8-14}
      Result := Result + FormatRPSNumericString(FieldByName('AreaEff1BedApt').Text, 7, 0);  {15-21}
      Result := Result + FormatRPSNumericString(FieldByName('Area2BedApt').Text, 7, 0);  {22-28}
      Result := Result + FormatRPSNumericString(FieldByName('Area3BedApt').Text, 7, 0);  {29-35}
      Result := Result + Take(2, FieldByName('UnitType_NonAptCode').Text);  {36-37}
      Result := Result + FormatRPSNumericString(FieldByName('TotalUnits').Text, 5, 0);  {38-42}
      Result := Result + FormatRPSNumericString(FieldByName('TotalEff1Bed').Text, 5, 0);  {43-47}
      Result := Result + FormatRPSNumericString(FieldByName('Total2Bed').Text, 5, 0);  {48-52}
      Result := Result + FormatRPSNumericString(FieldByName('Total3Bed').Text, 5, 0);  {53-57}
      Result := Result + FormatRPSNumericString(FieldByName('TotalRent').Text, 8, 0);  {58-65}
      Result := Result + Take(1, FieldByName('RentTypeCode').Text);  {66-66}

    end;  {with RentTable do}

end;  {ExtractOneRentRecord}

{=======================================================================}
Function CreateBlankRentRecord : String;

{Create a blank Rent record to be compatible with RPS995 - put zeroes in
 numeric fields and blanks in non-numeric fields.}
{Note that the offsets are only within this record.}

begin
  Result := Take(2, '');  {1-2}
  Result := Result + Take(3, '');  {3-5}
  Result := Result + Take(2, '');  {6-7}
  Result := Result + ShiftRightAddZeroes(Take(7, ''));  {8-14}
  Result := Result + ShiftRightAddZeroes(Take(7, ''));  {15-21}
  Result := Result + ShiftRightAddZeroes(Take(7, ''));  {22-28}
  Result := Result + ShiftRightAddZeroes(Take(7, ''));  {29-35}
  Result := Result + Take(2, '');  {36-37}
  Result := Result + ShiftRightAddZeroes(Take(5, ''));  {38-42}
  Result := Result + ShiftRightAddZeroes(Take(5, ''));  {43-47}
  Result := Result + ShiftRightAddZeroes(Take(5, ''));  {48-52}
  Result := Result + ShiftRightAddZeroes(Take(5, ''));  {53-57}
  Result := Result + ShiftRightAddZeroes(Take(8, ''));  {58-65}
  Result := Result + ShiftRightAddZeroes(Take(1, ''));  {66-66}

end;  {CreateBlankRentRecord}

{==============================================================================}
Procedure ExtractRentRecords(RentTable : TTable;
                             RentRecords : TStringList;
                             SwisSBLKey : String;
                             SiteNumber,
                             SalesNumber : Integer;
                             IsSalesInventory : Boolean;
                             TaxRollYear : String);

var
  Done, Quit, FirstTimeThrough : Boolean;
  TempStr : String;

begin
  Done := False;
  Quit := False;
  FirstTimeThrough := True;

  If IsSalesInventory
    then SetRangeOld(RentTable,
                     ['SwisSBLKey', 'SalesNumber', 'Site', 'UseNumber'],
                     [SwisSBLKey, IntToStr(SalesNumber), IntToStr(SiteNumber), '0'],
                     [SwisSBLKey, IntToStr(SalesNumber), IntToStr(SiteNumber), '32000'])
    else SetRangeOld(RentTable,
                     ['TaxRollYr', 'SwisSBLKey', 'Site', 'UseNumber'],
                     [TaxRollYear, SwisSBLKey, IntToStr(SiteNumber), '0'],
                     [TaxRollYear, SwisSBLKey, IntToStr(SiteNumber), '32000']);

  TempStr := RentTable.FieldByName('SwisSBLKey').Text;

  try
    RentTable.First;
  except
    Quit := True;
    SystemSupport(001, RentTable, 'Error getting first Rent record.', 'EXTRUTIL.PAS',
                  GlblErrorDlgBox);
  end;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else
        try
          RentTable.Next;
        except
          Quit := True;
          SystemSupport(002, RentTable, 'Error getting first next record.', 'EXTRUTIL.PAS',
                        GlblErrorDlgBox);
        end;

    If RentTable.EOF
      then Done := True;

      {If this is a good Rent record and should be extracted, then we will extract it.
       If we are including inventory, then we will add that, too.}

    If not (Done or Quit)
      then RentRecords.Add(ExtractOneRentRecord(RentTable));

  until (Done or Quit);

end;  {ExtractRentRecords}

{==============================================================================}
Procedure ExtractComBldgRecords(BldgTable : TTable;
                                BldgRecords : TStringList;
                                SwisSBLKey : String;
                                SiteNumber,
                                SalesNumber : Integer;
                                IsSalesInventory : Boolean;
                                TaxRollYear : String);

var
  Done, Quit, FirstTimeThrough : Boolean;
  TempStr : String;

begin
  Done := False;
  Quit := False;
  FirstTimeThrough := True;

  If IsSalesInventory
    then SetRangeOld(BldgTable,
                     ['SwisSBLKey', 'SalesNumber', 'Site', 'BuildingNumber', 'BuildingSection'],
                     [SwisSBLKey, IntToStr(SalesNumber), IntToStr(SiteNumber), '0', '0'],
                     [SwisSBLKey, IntToStr(SalesNumber), IntToStr(SiteNumber), '32000', '32000'])
    else SetRangeOld(BldgTable,
                     ['TaxRollYr', 'SwisSBLKey', 'Site', 'BuildingNumber', 'BuildingSection'],
                     [TaxRollYear, SwisSBLKey, IntToStr(SiteNumber), '0', '0'],
                     [TaxRollYear, SwisSBLKey, IntToStr(SiteNumber), '32000', '32000']);

  TempStr := BldgTable.FieldByName('SwisSBLKey').Text;

  try
    BldgTable.First;
  except
    Quit := True;
    SystemSupport(001, BldgTable, 'Error getting first Bldg record.', 'EXTRUTIL.PAS',
                  GlblErrorDlgBox);
  end;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else
        try
          BldgTable.Next;
        except
          Quit := True;
          SystemSupport(002, BldgTable, 'Error getting first next record.', 'EXTRUTIL.PAS',
                        GlblErrorDlgBox);
        end;

    If BldgTable.EOF
      then Done := True;

      {If this is a good Bldg record and should be extracted, then we will extract it.
       If we are including inventory, then we will add that, too.}

    If not (Done or Quit)
      then BldgRecords.Add(ExtractOneComBldgRecord(BldgTable));

  until (Done or Quit);

end;  {ExtractComBldgRecords}

{==============================================================================}
Function ExtractIncExpRecord(IncExpTable : TTable) : String;

{Extract the commercial income expense record.}

begin
  Result := '';

  with IncExpTable do
    begin
      Result := Result + Take(1, FieldByName('DataUseCode').Text);  {1-1}
      Result := Result + FormatRPSNumericString(FieldByName('GrossRentalIncome').Text, 8, 0);  {2-9}
      Result := Result + FormatRPSNumericString(FieldByName('AdditionalIncome').Text, 8, 0);  {10-17}
      Result := Result + Take(1, FieldByName('ExpenseTypeCode').Text);  {18-18}
      Result := Result + FormatRPSNumericString(FieldByName('VacancyOrCreditLoss').Text, 8, 0);  {19-26}
      Result := Result + FormatRPSNumericString(FieldByName('TotalExpenses').Text, 8, 0);  {27-34}
      Result := Result + FormatRPSNumericString(FieldByName('InsuranceExpenses').Text, 8, 0);  {35-42}
      Result := Result + FormatRPSNumericString(FieldByName('BldgSvcExpenses').Text, 8, 0);  {43-50}
      Result := Result + FormatRPSNumericString(FieldByName('UtilityExpenses').Text, 8, 0);  {51-58}
      Result := Result + FormatRPSNumericString(FieldByName('MaintenanceExpenses').Text, 8, 0);  {59-66}
      Result := Result + FormatRPSNumericString(FieldByName('ReserveForReplacemen').Text, 8, 0);  {67-74}
      Result := Result + FormatRPSNumericString(FieldByName('ManagementExpenses').Text, 8, 0);  {75-82}
      Result := Result + FormatRPSNumericString(FieldByName('MiscCosts').Text, 8, 0);  {83-90}
      Result := Result + Take(1, FieldByName('AppDepCode').Text);  {91-91}
      Result := Result + Take(2, FieldByName('InvestmentSetCode').Text);  {92-93}
      Result := Result + FormatRPSNumericString(FieldByName('InvestmentPeriod').Text, 2, 0);  {94-95}
      Result := Result + FormatRPSNumericString(FieldByName('EquityYieldPercent').Text, 4, 2);  {96-99}
      Result := Result + FormatRPSNumericString(FieldByName('EquityDividend').Text, 5, 0);  {100-104}
      Result := Result + FormatRPSNumericString(FieldByName('1stMortPercentTotInv').Text, 4, 2);  {105-108}
      Result := Result + FormatRPSNumericString(FieldByName('1stMortTerm').Text, 2, 0);  {109-110}
      Result := Result + FormatRPSNumericString(FieldByName('1stMortIntRate').Text, 4, 2);  {111-114}
      Result := Result + FormatRPSNumericString(FieldByName('2ndMortPercentTotInv').Text, 4, 2);  {115-118}
      Result := Result + FormatRPSNumericString(FieldByName('2ndMortTerm').Text, 2, 0);  {119-120}
      Result := Result + FormatRPSNumericString(FieldByName('2ndMortIntRate').Text, 4, 2);  {121-124}
      Result := Result + FormatRPSNumericString(FieldByName('AppDepPercent').Text, 4, 2);  {125-128}
      Result := Result + BoolToChar_Blank_1(TBooleanField(FieldByName('RentRestricted')).AsBoolean);  {129-129}
      Result := Result + FormatRPSNumericString(FieldByName('EffectiveGrossInc').Text, 8, 0);  {130-137}
      Result := Result + FormatRPSNumericString(FieldByName('NetOperatingIncome').Text, 8, 0);  {138-145}
      Result := Result + Take(20, FieldByName('AlternateName').Text);  {146-165}
      Result := Result + Take(20, FieldByName('AlternateAddress').Text);  {166-185}

    end;  {with IncExpTable do}

end;  {ExtractIncExpRecord}

{==============================================================================}
Procedure ExtractResInventoryRecords(ResInventoryRecords : TList;
                                     SiteTable,
                                     BldgTable,
                                     LandTable,
                                     ImprovementTable,
                                     ForestTable : TTable;
                                     SwisSBLKey : String;
                                     NumResSites,
                                     SalesNumber : Integer;
                                     IsSalesInventory : Boolean;
                                     TaxRollYear : String);

var
  LandItemNum, ImprovementItemNum, ForestItemNum,
  I, RecordNo, TotalOverflowRecs, LastLandItem,
  LastImprovementItem, TotalForestStands, LastForestItem : Integer;
  LandRecords, ForestRecords, ImprovementRecords : TStringList;
  SiteHdrRecord, OverflowHdrRecord,
  ForestHdrRecord, SiteRecord, BldgRecord, TempStr : String;
  BaseInventoryRec, OverflowInventoryRec, ForestInventoryRec : PRPSExtractRec;
  FoundBldg, Done, Quit, FirstTimeThrough : Boolean;

begin
  If IsSalesInventory
    then SetRangeOld(SiteTable,
                     ['SwisSBLKey', 'SalesNumber', 'Site'],
                     [SwisSBLKey, IntToStr(SalesNumber), '0'],
                     [SwisSBLKey, IntToStr(SalesNumber), '32000'])
    else SetRangeOld(SiteTable,
                     ['TaxRollYr', 'SwisSBLKey', 'Site'],
                     [TaxRollYear, SwisSBLKey, '0'],
                     [TaxRollYear, SwisSBLKey, '32000']);

  Done := False;
  Quit := False;
  FirstTimeThrough := True;

  try
    SiteTable.First;
  except
    Quit := True;
    SystemSupport(001, SiteTable, 'Error getting first Site record.', 'EXTRUTIL.PAS',
                  GlblErrorDlgBox);
  end;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else
        try
          SiteTable.Next;
        except
          Quit := True;
          SystemSupport(002, SiteTable, 'Error getting first next site record.', 'EXTRUTIL.PAS',
                        GlblErrorDlgBox);
        end;

      {FXX12011998-5: Don't do a deblank on the parcel ID before comparing because
                      it will cause problems if the suffix is blank.}
      {FXX11112010-1(2.26.1.19)[I8290]: This comparison failed because the SBL is not 20 chars.}

    If (SiteTable.EOF or
        _Compare(SiteTable.FieldByName('SwisSBLKey').AsString, SwisSBLKey, coNotEqual))
      then Done := True;

      {If this is a good Site record and should be extracted, then we will extract it.
       If we are including inventory, then we will add that, too.}

    If not (Done or Quit)
      then
        begin
          LandRecords := TStringList.Create;
          ImprovementRecords := TStringList.Create;
          ForestRecords := TStringList.Create;

          ExtractLandRecords(LandTable, LandRecords,
                             SwisSBLKey,
                             TIntegerField(SiteTable.FieldByName('Site')).AsInteger,
                             SalesNumber, IsSalesInventory, TaxRollYear);
          ExtractImprovementRecords(ImprovementTable, ImprovementRecords,
                                    SwisSBLKey,
                                    TIntegerField(SiteTable.FieldByName('Site')).AsInteger,
                                    SalesNumber, IsSalesInventory, TaxRollYear);
          ExtractForestRecords(ForestTable, ForestRecords,
                               SwisSBLKey,
                               TIntegerField(SiteTable.FieldByName('Site')).AsInteger,
                               SalesNumber, IsSalesInventory, TaxRollYear);

            {Determine the number of overflow and forest records.}

          If ((LandRecords.Count <= 2) and
              (ImprovementRecords.Count <= 4))
            then TotalOverflowRecs := 0
            else TotalOverflowRecs := MaxInt2([1,
                                               ((LandRecords.Count - 3) DIV 5) + 1,
                                               ((ImprovementRecords.Count - 5) DIV 6) + 1]);

          If (ForestRecords.Count = 0)
            then TotalForestStands := 0
            else TotalForestStands := (ForestRecords.Count DIV 19) + 1;

            {Now, figure out the last land, improvement, and forest
             records by looking the first two char.'s of the last
             record of each since this is the land, improvement, or
             forest number, respectively.}

          If (LandRecords.Count = 0)
            then LastLandItem := 0
            else
              try
                TempStr := LandRecords[LandRecords.Count - 1][1] +
                           LandRecords[LandRecords.Count - 1][2];
                LastLandItem := StrToInt(Copy(TempStr, 1, 2));
              except
                LastLandItem := 0;
              end;

          If (ImprovementRecords.Count = 0)
            then LastImprovementItem := 0
            else
              try
                TempStr := ImprovementRecords[ImprovementRecords.Count - 1][1] +
                           ImprovementRecords[ImprovementRecords.Count - 1][2];
                LastImprovementItem := StrToInt(Copy(TempStr, 1, 2));
              except
                LastImprovementItem := 0;
              end;

          If (ForestRecords.Count = 0)
            then LastForestItem := 0
            else
              try
                TempStr := ForestRecords[ForestRecords.Count - 1][1] +
                           ForestRecords[ForestRecords.Count - 1][2];
                LastForestItem := StrToInt(Copy(TempStr, 1, 2));
              except
                LastForestItem := 0;
              end;

            {Now start creating the base record for this residential site.}

          SiteHdrRecord := ExtractResSiteHdrRecord(SiteTable,
                                                   NumResSites,
                                                   SalesNumber,
                                                   TotalOverflowRecs,
                                                   LastLandItem,
                                                   LastImprovementItem,
                                                   TotalForestStands,
                                                   LastForestItem,
                                                   IsSalesInventory);
          SiteRecord := ExtractResSiteRecord(SiteTable);

            {Get the building record and extract the information.}

          If IsSalesInventory
            then FoundBldg := FindKeyOld(BldgTable,
                                         ['SwisSBLKey', 'SalesNumber', 'Site'],
                                         [SwisSBLKey, IntToStr(SalesNumber),
                                          SiteTable.FieldByName('Site').Text])
            else FoundBldg := FindKeyOld(BldgTable,
                                         ['TaxRollYr', 'SwisSBLKey', 'Site'],
                                         [TaxRollYear, SwisSBLKey,
                                          SiteTable.FieldByName('Site').Text]);

          If FoundBldg
            then BldgRecord := ExtractResBldgRecord(BldgTable)
            else BldgRecord := Take(123, '');

          LandItemNum := 0;
          ImprovementItemNum := 0;
          ForestItemNum := 0;

          New(BaseInventoryRec);
          InitializeRPSExtractString(BaseInventoryRec);

          RPSExtractStrCat(BaseInventoryRec, SiteHdrRecord);
          RPSExtractStrCat(BaseInventoryRec, SiteRecord);

            {2 land breakdowns in the base.}

          For I := 1 to 2 do
            If (LandItemNum <= (LandRecords.Count - 1))
              then
                begin
                  RPSExtractStrCat(BaseInventoryRec, LandRecords[LandItemNum]);
                  LandItemNum := LandItemNum + 1;
                end
              else
                begin
                    {No more land records, so add blanks.}

                  TempStr := CreateBlankLandRecord;
                  RPSExtractStrCat(BaseInventoryRec, TempStr);

                end;  {else of If (LandItemNum < (LandRecords.Count - 1))}

            {Now put the bldg record in the base.}

          RPSExtractStrCat(BaseInventoryRec, BldgRecord);

            {4 improvement breakdowns in the base.}

          For I := 1 to 4 do
            If (ImprovementItemNum <= (ImprovementRecords.Count - 1))
              then
                begin
                  RPSExtractStrCat(BaseInventoryRec, ImprovementRecords[ImprovementItemNum]);
                  ImprovementItemNum := ImprovementItemNum + 1;
                end
              else
                begin
                    {No more Improvement records, so add blanks.}

                  TempStr := CreateBlankImprovementRecord;
                  RPSExtractStrCat(BaseInventoryRec, TempStr);

                end;  {else of If (ImprovementItemNum < (ImprovementRecords.Count - 1))}

            {Now do the footer - user defined data and filler.}

          If IsSalesInventory
            then TempStr := Take(42, '') + Take(157, '') + '22'
            else TempStr := Take(42, '') + Take(157, '') + '54';
          RPSExtractStrCat(BaseInventoryRec, TempStr);

          ResInventoryRecords.Add(BaseInventoryRec);

            {Now create overflow records until we are done with
             land and improvement records.}

          RecordNo := 1;

          while (((LandItemNum <= (LandRecords.Count - 1)) or
                  (ImprovementItemNum <= (ImprovementRecords.Count - 1))) and
                 (RecordNo <= 92)) do
            begin
              New(OverflowInventoryRec);
              InitializeRPSExtractString(OverflowInventoryRec);

                {Create the header.}

              OverflowHdrRecord := ExtractSiteOverflowHdrRecord(SiteTable, 'R', RecordNo,
                                                                SalesNumber,
                                                                TotalOverflowRecs,
                                                                TotalForestStands,
                                                                IsSalesInventory,
                                                                False);
              RPSExtractStrCat(OverflowInventoryRec, OverflowHdrRecord);

                {5 land breakdowns in the overflow.}

              For I := 1 to 5 do
                If (LandItemNum <= (LandRecords.Count - 1))
                  then
                    begin
                      RPSExtractStrCat(OverflowInventoryRec, LandRecords[LandItemNum]);
                      LandItemNum := LandItemNum + 1;
                    end
                  else
                    begin
                        {No more land records, so add blanks.}

                      TempStr := CreateBlankLandRecord;
                      RPSExtractStrCat(OverflowInventoryRec, TempStr);

                    end;  {else of If (LandItemNum < (LandRecords.Count - 1))}

                {6 improvement breakdowns in the Overflow.}

              For I := 1 to 6 do
                If (ImprovementItemNum <= (ImprovementRecords.Count - 1))
                  then
                    begin
                      RPSExtractStrCat(OverflowInventoryRec,
                                       ImprovementRecords[ImprovementItemNum]);
                      ImprovementItemNum := ImprovementItemNum + 1;
                    end
                  else
                    begin
                        {No more Improvement records, so add blanks.}

                      TempStr := CreateBlankImprovementRecord;
                      RPSExtractStrCat(OverflowInventoryRec, TempStr);

                    end;  {else of If (ImprovementItemNum < (ImprovementRecords.Count - 1))}

                {Now do the footer - user defined data and filler.}

              If IsSalesInventory
                then TempStr := Take(186, '') + '22'
                else TempStr := Take(186, '') + '54';
              RPSExtractStrCat(OverflowInventoryRec, TempStr);

              ResInventoryRecords.Add(OverflowInventoryRec);

              RecordNo := RecordNo + 1;

            end;  {while ((LandItemNum < (LandRecords.Count - 1)) or}

            {Now create the forest records.}

          RecordNo := 94;

          while ((ForestItemNum <= (ForestRecords.Count - 1)) and
                 (RecordNo <= 99)) do
            begin
              New(ForestInventoryRec);
              InitializeRPSExtractString(ForestInventoryRec);

                {Create the header.}

              ForestHdrRecord := ExtractForestHdrRecord(SiteTable, RecordNo,
                                                        SalesNumber,
                                                        TotalForestStands,
                                                        IsSalesInventory);
              RPSExtractStrCat(ForestInventoryRec, ForestHdrRecord);

                {19 Forest breakdowns in the Forest.}

              For I := 1 to 19 do
                If (ForestItemNum <= (ForestRecords.Count - 1))
                  then
                    begin
                      RPSExtractStrCat(ForestInventoryRec, ForestRecords[ForestItemNum]);
                      ForestItemNum := ForestItemNum + 1;
                    end
                  else
                    begin
                        {No more Forest records, so add blanks.}

                      TempStr := CreateBlankForestRecord;
                      RPSExtractStrCat(ForestInventoryRec, TempStr);

                    end;  {else of If (ForestItemNum < (ForestRecords.Count - 1))}

                {Now do the footer - user defined data and filler.}

              If IsSalesInventory
                then TempStr := Take(162, '') + '22'
                else TempStr := Take(162, '') + '54';
              RPSExtractStrCat(ForestInventoryRec, TempStr);

              ResInventoryRecords.Add(ForestInventoryRec);

              RecordNo := RecordNo + 1;

            end;  {while ((ForestItemNum < (ForestRecords.Count - 1)) or}

            {Now free the residential inventory record TLists.
             Note that we did not free the PChar items on these lists since
             we still need to use them. So, when we free the overall extract list,
             we must be sure to also free each item.}

          LandRecords.Free;
          ImprovementRecords.Free;
          ForestRecords.Free;

        end;  {If not (Done or Quit}

  until (Done or Quit);

end;  {ExtractResInventoryRecords}

{==============================================================================}
Procedure ExtractComInventoryRecords(ComInventoryRecords : TList;
                                     SiteTable,
                                     BldgTable,
                                     RentTable,
                                     LandTable,
                                     ImprovementTable,
                                     IncExpTable : TTable;
                                     SwisSBLKey : String;
                                     NumComSites,
                                     SalesNumber : Integer;
                                     IsSalesInventory : Boolean;
                                     TaxRollYear : String);

var
  LandItemNum, ImprovementItemNum, RentItemNum, BldgItemNum,
  I, RecordNo, TotalOverflowRecs, LastLandItem,
  LastImprovementItem, LastBldgItem, LastRentItem : Integer;
  LandRecords, BldgRecords, RentRecords, ImprovementRecords : TStringList;
  SiteHdrRecord, OverflowHdrRecord,
  IncExpHdrRecord, SiteRecord, TempStr : String;
  BaseInventoryRec, OverflowInventoryRec, IncExpInventoryRec : PRPSExtractRec;
  FoundIncExp, Done, Quit, FirstTimeThrough : Boolean;

begin
  If IsSalesInventory
    then SetRangeOld(SiteTable,
                     ['SwisSBLKey', 'SalesNumber', 'Site'],
                     [SwisSBLKey, IntToStr(SalesNumber), '0'],
                     [SwisSBLKey, IntToStr(SalesNumber), '32000'])
    else SetRangeOld(SiteTable,
                     ['TaxRollYr', 'SwisSBLKey', 'Site'],
                     [TaxRollYear, SwisSBLKey, '0'],
                     [TaxRollYear, SwisSBLKey, '32000']);

  Done := False;
  Quit := False;
  FirstTimeThrough := True;

  try
    SiteTable.First;
  except
    Quit := True;
    SystemSupport(001, SiteTable, 'Error getting first Site record.', 'EXTRUTIL.PAS',
                  GlblErrorDlgBox);
  end;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else
        try
          SiteTable.Next;
        except
          Quit := True;
          SystemSupport(002, SiteTable, 'Error getting first next site record.', 'EXTRUTIL.PAS',
                        GlblErrorDlgBox);
        end;

      {FXX12011998-5: Don't do a deblank on the parcel ID before comparing because
                      it will cause problems if the suffix is blank.}

      {FXX11112010-1(2.26.1.19)[I8290]: This comparison failed because the SBL is not 20 chars.}

    If (SiteTable.EOF or
        _Compare(SiteTable.FieldByName('SwisSBLKey').AsString, SwisSBLKey, coNotEqual))
      then Done := True;

      {If this is a good Site record and should be extracted, then we will extract it.
       If we are including inventory, then we will add that, too.}

    If not (Done or Quit)
      then
        begin
          LandRecords := TStringList.Create;
          ImprovementRecords := TStringList.Create;
          RentRecords := TStringList.Create;
          BldgRecords := TStringList.Create;

          ExtractLandRecords(LandTable, LandRecords, SwisSBLKey,
                             TIntegerField(SiteTable.FieldByName('Site')).AsInteger,
                             SalesNumber, IsSalesInventory, TaxRollYear);
          ExtractImprovementRecords(ImprovementTable, ImprovementRecords, SwisSBLKey,
                                    TIntegerField(SiteTable.FieldByName('Site')).AsInteger,
                                    SalesNumber, IsSalesInventory, TaxRollYear);
          ExtractRentRecords(RentTable, RentRecords, SwisSBLKey,
                             TIntegerField(SiteTable.FieldByName('Site')).AsInteger,
                             SalesNumber, IsSalesInventory, TaxRollYear);
          ExtractComBldgRecords(BldgTable, BldgRecords, SwisSBLKey,
                                TIntegerField(SiteTable.FieldByName('Site')).AsInteger,
                                SalesNumber, IsSalesInventory, TaxRollYear);


            {See if there is an income expense record.}

          If IsSalesInventory
            then FoundIncExp := FindKeyOld(IncExpTable,
                                           ['SwisSBLKey', 'SalesNumber', 'Site'],
                                           [SwisSBLKey, IntToStr(SalesNumber),
                                            SiteTable.FieldByName('Site').Text])
            else FoundIncExp := FindKeyOld(IncExpTable,
                                           ['TaxRollYr', 'SwisSBLKey', 'Site'],
                                           [TaxRollYear, SwisSBLKey,
                                            SiteTable.FieldByName('Site').Text]);

            {Determine the number of overflow records.}

          If ((LandRecords.Count <= 2) and
              (ImprovementRecords.Count <= 4) and
              (RentRecords.Count <= 2) and
              (BldgRecords.Count <= 2))
            then TotalOverflowRecs := 0
            else TotalOverflowRecs := MaxInt2([1,
                                              (LandRecords.Count - 2),
                                              (((ImprovementRecords.Count - 5) DIV 7) + 1),
                                              (((RentRecords.Count - 3) DIV 3) + 1),
                                              (((BldgRecords.Count - 3) DIV 2) + 1)]);

            {Income\expense records count as overflows.}

          If FoundIncExp
            then TotalOverFlowRecs := TotalOverflowRecs + 1;

            {Now, figure out the last land, improvement, bldg, and rent
             records by looking the first two char.'s of the last
             record of each since this is the land, improvement, or
             forest number, respectively.}

          If (LandRecords.Count = 0)
            then LastLandItem := 0
            else
              try
                TempStr := LandRecords[LandRecords.Count - 1][1] +
                           LandRecords[LandRecords.Count - 1][2];
                LastLandItem := StrToInt(Copy(TempStr, 1, 2));
              except
                LastLandItem := 0;
              end;

          If (ImprovementRecords.Count = 0)
            then LastImprovementItem := 0
            else
              try
                TempStr := ImprovementRecords[ImprovementRecords.Count - 1][1] +
                           ImprovementRecords[ImprovementRecords.Count - 1][2];
                LastImprovementItem := StrToInt(Copy(TempStr, 1, 2));
              except
                LastImprovementItem := 0;
              end;

          If (RentRecords.Count = 0)
            then LastRentItem := 0
            else
              try
                TempStr := RentRecords[RentRecords.Count - 1][1] +
                           RentRecords[RentRecords.Count - 1][2];
                LastRentItem := StrToInt(Copy(TempStr, 1, 2));
              except
                LastRentItem := 0;
              end;

          If (BldgRecords.Count = 0)
            then LastBldgItem := 0
            else
              try
                TempStr := BldgRecords[BldgRecords.Count - 1][1] +
                           BldgRecords[BldgRecords.Count - 1][2];
                LastBldgItem := StrToInt(Copy(TempStr, 1, 2));
              except
                LastBldgItem := 0;
              end;

            {Now start creating the base record for this Commercial site.}

          SiteHdrRecord := ExtractComSiteHdrRecord(SiteTable,
                                                   NumComSites,
                                                   SalesNumber,
                                                   TotalOverflowRecs,
                                                   LastLandItem,
                                                   LastImprovementItem,
                                                   LastRentItem,
                                                   LastBldgItem,
                                                   IsSalesInventory,
                                                   FoundIncExp);
          SiteRecord := ExtractComSiteRecord(SiteTable);

          LandItemNum := 0;
          ImprovementItemNum := 0;
          RentItemNum := 0;
          BldgItemNum := 0;

          New(BaseInventoryRec);
          InitializeRPSExtractString(BaseInventoryRec);

          RPSExtractStrCat(BaseInventoryRec, SiteHdrRecord);
          RPSExtractStrCat(BaseInventoryRec, SiteRecord);

            {2 land breakdowns in the base.}

          For I := 1 to 2 do
            If (LandItemNum <= (LandRecords.Count - 1))
              then
                begin
                  RPSExtractStrCat(BaseInventoryRec, LandRecords[LandItemNum]);
                  LandItemNum := LandItemNum + 1;
                end
              else
                begin
                    {No more land records, so add blanks.}

                  TempStr := CreateBlankLandRecord;
                  RPSExtractStrCat(BaseInventoryRec, TempStr);

                end;  {else of If (LandItemNum < (LandRecords.Count - 1))}

            {2 Bldg breakdowns in the base.}

          For I := 1 to 2 do
            If (BldgItemNum <= (BldgRecords.Count - 1))
              then
                begin
                  RPSExtractStrCat(BaseInventoryRec, BldgRecords[BldgItemNum]);
                  BldgItemNum := BldgItemNum + 1;
                end
              else
                begin
                    {No more Bldg records, so add blanks.}

                  TempStr := CreateBlankComBldgRecord;
                  RPSExtractStrCat(BaseInventoryRec, TempStr);

                end;  {else of If (BldgItemNum < (BldgRecords.Count - 1))}

            {4 improvement breakdowns in the base.}

          For I := 1 to 4 do
            If (ImprovementItemNum <= (ImprovementRecords.Count - 1))
              then
                begin
                  RPSExtractStrCat(BaseInventoryRec, ImprovementRecords[ImprovementItemNum]);
                  ImprovementItemNum := ImprovementItemNum + 1;
                end
              else
                begin
                    {No more Improvement records, so add blanks.}

                  TempStr := CreateBlankImprovementRecord;
                  RPSExtractStrCat(BaseInventoryRec, TempStr);

                end;  {else of If (ImprovementItemNum < (ImprovementRecords.Count - 1))}

            {2 Rent breakdowns in the base.}

          For I := 1 to 2 do
            If (RentItemNum <= (RentRecords.Count - 1))
              then
                begin
                  RPSExtractStrCat(BaseInventoryRec, RentRecords[RentItemNum]);
                  RentItemNum := RentItemNum + 1;
                end
              else
                begin
                    {No more Rent records, so add blanks.}

                  TempStr := CreateBlankRentRecord;
                  RPSExtractStrCat(BaseInventoryRec, TempStr);

                end;  {else of If (RentItemNum < (RentRecords.Count - 1))}

            {Now do the footer - user defined data and filler.}

          If IsSalesInventory
            then TempStr := Take(36, '') + Take(7, '') + '22'
            else TempStr := Take(36, '') + Take(7, '') + '54';
          RPSExtractStrCat(BaseInventoryRec, TempStr);

          ComInventoryRecords.Add(BaseInventoryRec);

            {Now create overflow records until we are done with
             land and improvement records.}

          RecordNo := 1;

          while (((LandItemNum <= (LandRecords.Count - 1)) or
                  (ImprovementItemNum <= (ImprovementRecords.Count - 1)) or
                  (RentItemNum <= (RentRecords.Count - 1)) or
                  (BldgItemNum <= (BldgRecords.Count - 1))) and
                 (RecordNo <= 97)) do
            begin
              New(OverflowInventoryRec);
              InitializeRPSExtractString(OverflowInventoryRec);

                {Create the header.}

              OverflowHdrRecord := ExtractSiteOverflowHdrRecord(SiteTable, 'C', RecordNo,
                                                                SalesNumber,
                                                                TotalOverflowRecs,
                                                                0, IsSalesInventory,
                                                                FoundIncExp);
              RPSExtractStrCat(OverflowInventoryRec, OverflowHdrRecord);

                {1 land breakdown in the overflow.}

              If (LandItemNum <= (LandRecords.Count - 1))
                then
                  begin
                    RPSExtractStrCat(OverflowInventoryRec, LandRecords[LandItemNum]);
                    LandItemNum := LandItemNum + 1;
                  end
                else
                  begin
                      {No more land records, so add blanks.}

                    TempStr := CreateBlankLandRecord;
                    RPSExtractStrCat(OverflowInventoryRec, TempStr);

                  end;  {else of If (LandItemNum < (LandRecords.Count - 1))}

                {2 Bldg breakdowns in the base.}

              For I := 1 to 2 do
                If (BldgItemNum <= (BldgRecords.Count - 1))
                  then
                    begin
                      RPSExtractStrCat(OverflowInventoryRec, BldgRecords[BldgItemNum]);
                      BldgItemNum := BldgItemNum + 1;
                    end
                  else
                    begin
                        {No more Bldg records, so add blanks.}

                      TempStr := CreateBlankComBldgRecord;
                      RPSExtractStrCat(OverflowInventoryRec, TempStr);

                    end;  {else of If (BldgItemNum < (BldgRecords.Count - 1))}

                {7 improvement breakdowns in the Overflow.}

              For I := 1 to 7 do
                If (ImprovementItemNum <= (ImprovementRecords.Count - 1))
                  then
                    begin
                      RPSExtractStrCat(OverflowInventoryRec,
                                       ImprovementRecords[ImprovementItemNum]);
                      ImprovementItemNum := ImprovementItemNum + 1;
                    end
                  else
                    begin
                        {No more Improvement records, so add blanks.}

                      TempStr := CreateBlankImprovementRecord;
                      RPSExtractStrCat(OverflowInventoryRec, TempStr);

                    end;  {else of If (ImprovementItemNum < (ImprovementRecords.Count - 1))}

                {3 Rent breakdowns in the base.}

              For I := 1 to 3 do
                If (RentItemNum <= (RentRecords.Count - 1))
                  then
                    begin
                      RPSExtractStrCat(OverflowInventoryRec, RentRecords[RentItemNum]);
                      RentItemNum := RentItemNum + 1;
                    end
                  else
                    begin
                        {No more Rent records, so add blanks.}

                      TempStr := CreateBlankRentRecord;
                      RPSExtractStrCat(OverflowInventoryRec, TempStr);

                    end;  {else of If (RentItemNum < (RentRecords.Count - 1))}

                {Now do the footer - user defined data and filler.}

              If IsSalesInventory
                then TempStr := Take(19, '') + '22'
                else TempStr := Take(19, '') + '54';
              RPSExtractStrCat(OverflowInventoryRec, TempStr);

              ComInventoryRecords.Add(OverflowInventoryRec);

              RecordNo := RecordNo + 1;

            end;  {while ((LandItemNum < (LandRecords.Count - 1)) or ...}

            {Now create the income expense record if there is one.}

          RecordNo := 99;

            {Only write a commercial income expense record if one exists. Otherwise, we
             will not write an income expense record at all.}

          If FoundIncExp
            then
              begin
                New(IncExpInventoryRec);
                InitializeRPSExtractString(IncExpInventoryRec);

                  {Create the header. Note that the income expense header is the same as
                   the site overflow record header. If this ever changes, just create a new
                   procedure to create the income expense header.}

                IncExpHdrRecord := ExtractSiteOverflowHdrRecord(SiteTable, 'C', RecordNo,
                                                                SalesNumber, TotalOverflowRecs,
                                                                0, IsSalesInventory,
                                                                FoundIncExp);

                RPSExtractStrCat(IncExpInventoryRec, IncExpHdrRecord);
                RPSExtractStrCat(IncExpInventoryRec, ExtractIncExpRecord(IncExpTable));

                  {Now do the footer - user defined data and filler.
                   Note that we have to divide the filler up into several strings.}

                TempStr := Take(255, '');
                RPSExtractStrCat(IncExpInventoryRec, TempStr);
                TempStr := Take(255, '');
                RPSExtractStrCat(IncExpInventoryRec, TempStr);

                If IsSalesInventory
                  then TempStr := Take(77, '') + '22'
                  else TempStr := Take(77, '') + '54';
                RPSExtractStrCat(IncExpInventoryRec, TempStr);

                ComInventoryRecords.Add(IncExpInventoryRec);

              end;  {If FoundIncExp}

            {Now free the Commercial inventory record TLists.
             Note that we did not free the PChar items on these lists since
             we still need to use them. So, when we free the overall extract list,
             we must be sure to also free each item.}

          LandRecords.Free;
          ImprovementRecords.Free;
          RentRecords.Free;
          BldgRecords.Free;

        end;  {If not (Done or Quit}

  until (Done or Quit);

end;  {ExtractComInventoryRecords}

{==============================================================================}
Procedure ExtractInformationForOneSale(var RPSFile : TextFile;
                                           SalesTable,
                                           ParcelTable,
                                           AssessmentTable,
                                           AssessmentYearCtlTable : TTable;
                                           SwisSBLKey,
                                           OldSwisSBLKey : String;
                                           UseOldSwisSBLKey : Boolean;
                                           SalesNumber : Integer;
                                           IncludeInventoryExtracts,
                                           SuppressSalesPrice,
                                           SalesReportExtract : Boolean);

{Given a sales table, SBL key, and a sales number, generate a sales extract
 record for this sales.}

var
  ResInventoryRecords, ComInventoryRecords : TList;
  I : Integer;
  SalesRec : PRPSExtractRec;
  ResSiteTable, ResBldgTable,
  ResLandTable, ResImprovementTable, ResForestTable,
  ComSiteTable, ComBldgTable,
  ComRentTable, ComLandTable,
  ComImprovementTable, ComIncExpTable : TTable;


begin
  ResSiteTable := FindTableInDataModuleForProcessingType(DataModuleResidentialSiteTableName,
                                                         SalesInventory);
  ResBldgTable := FindTableInDataModuleForProcessingType(DataModuleResidentialBuildingTableName,
                                                         SalesInventory);
  ResLandTable := FindTableInDataModuleForProcessingType(DataModuleResidentialLandTableName,
                                                         SalesInventory);
  ResImprovementTable := FindTableInDataModuleForProcessingType(DataModuleResidentialImprovementTableName,
                                                                SalesInventory);
  ResForestTable := FindTableInDataModuleForProcessingType(DataModuleResidentialForestTableName,
                                                           SalesInventory);

    {Commercial inventory tables.}

  ComSiteTable := FindTableInDataModuleForProcessingType(DataModuleCommercialSiteTableName,
                                                         SalesInventory);
  ComBldgTable := FindTableInDataModuleForProcessingType(DataModuleCommercialBuildingTableName,
                                                         SalesInventory);
  ComLandTable := FindTableInDataModuleForProcessingType(DataModuleCommercialLandTableName,
                                                         SalesInventory);
  ComImprovementTable := FindTableInDataModuleForProcessingType(DataModuleCommercialImprovementTableName,
                                                                SalesInventory);
  ComRentTable := FindTableInDataModuleForProcessingType(DataModuleCommercialRentTableName,
                                                         SalesInventory);
  ComIncExpTable := FindTableInDataModuleForProcessingType(DataModuleCommercialIncomeExpenseTableName,
                                                           SalesInventory);

  New(SalesRec);
    {FXX10121997-2: Pass in the sales rec - was being alloced 2x.}
    {FXX09231999-1: Need to include the final roll date in
                                              the sales extract.}
  ExtractOneSalesRecord(SalesRec, SalesTable, ParcelTable,
                        AssessmentTable, AssessmentYearCtlTable,
                        SuppressSalesPrice, SalesReportExtract);
  ResInventoryRecords := TList.Create;
  ComInventoryRecords := TList.Create;

  If IncludeInventoryExtracts
    then
      begin
        ExtractResInventoryRecords(ResInventoryRecords,
                                   ResSiteTable,
                                   ResBldgTable,
                                   ResLandTable,
                                   ResImprovementTable,
                                   ResForestTable,
                                   SwisSBLKey,
                                   TIntegerField(SalesTable.FieldByName('NumResSites')).AsInteger,
                                   TIntegerField(SalesTable.FieldByName('SaleNumber')).AsInteger,
                                   True, '');

        ExtractComInventoryRecords(ComInventoryRecords,
                                   ComSiteTable,
                                   ComBldgTable,
                                   ComRentTable,
                                   ComLandTable,
                                   ComImprovementTable,
                                   ComIncExpTable,
                                   SwisSBLKey,
                                   TIntegerField(SalesTable.FieldByName('NumComSites')).AsInteger,
                                   TIntegerField(SalesTable.FieldByName('SaleNumber')).AsInteger,
                                   True, '');

      end;  {If IncludeInventoryExtracts}

  If not SalesReportExtract
    then MarkLastRecordForSale(SalesRec, ResInventoryRecords,
                               ComInventoryRecords);

    {CHG04062000-1: Use old parcel ID in sales.}

  WriteOneRPSExtractRecToFile(RPSFile, SalesRec, OldSwisSBLKey, UseOldSwisSBLKey);

    {FXX10081997-1: - Use FreeMem instead of Dispose in order to free the
                       exact amount.}

  FreeMem(SalesRec, SizeOf(RPSExtractRec));

     {First add the residential inventory records
      to the file.}
     {CHG04062000-1: Use old parcel ID in sales.}

  For I := 0 to (ResInventoryRecords.Count - 1) do
    WriteOneRPSExtractRecToFile(RPSFile, ResInventoryRecords.Items[I],
                                OldSwisSBLKey, UseOldSwisSBLKey);

     {Now add the commercial inventory records.}

  For I := 0 to (ComInventoryRecords.Count - 1) do
    WriteOneRPSExtractRecToFile(RPSFile, ComInventoryRecords.Items[I],
                                OldSwisSBLKey, UseOldSwisSBLKey);

     {Now free the residential and commercial inventory record TLists.}

  FreeTList(ResInventoryRecords, SizeOf(RPSExtractRec));
  FreeTList(ComInventoryRecords, SizeOf(RPSExtractRec));

end;  {ExtractInformationForOneSale}

{FXX10021997-2: Pass in the record so not alloc'ed 2x.}
{==============================================================================}
Procedure ExtractOneSalesRecord(SalesRec : PRPSExtractRec;
                                SalesTable,
                                ParcelTable,
                                AssessmentTable,
                                AssessmentYearCtlTable : TTable;
                                SuppressSalesPrice,
                                SalesReportExtract : Boolean);

{Given a parcel sales table, create a text RPS 995 sales record.}

var
  SwisSBLKey, LegalAddrNo, TempStr : String;
  FullSalesPrice : Comp;
  SBLRec : SBLRecord;
  ParcelFound,
  DifferentSwisSBLKey,
  FoundAnotherRecForParcel : Boolean;
  TempBookmark : TBookmark;

begin
  InitializeRPSExtractString(SalesRec);

  with SalesTable do
    begin
      RPSExtractStrCat(SalesRec, Take(26, FieldByName('SwisSBLKey').Text));  {1-26}

      TempStr := FieldByName('SwisSBLKey').Text;

      RPSExtractStrCat(SalesRec, ShiftRightAddZeroes(Take(2, FieldByName('SaleNumber').Text))); {27-28}
      RPSExtractStrCat(SalesRec, Take(1, '1')); {29}
      RPSExtractStrCat(SalesRec, Take(2, '00')); {30-31}
      RPSExtractStrCat(SalesRec, Take(1, 'S')); {32}
      RPSExtractStrCat(SalesRec, Take(2, '00')); {33-34}

      RPSExtractStrCat(SalesRec, Take(2, FieldByName('CheckDigit').Text)); {35-36}
      RPSExtractStrCat(SalesRec, Take(3, '')); {37-39}

      RPSExtractStrCat(SalesRec,
                      Take(25, ConvertSwisSBLToDashDotNoSwis(FieldByName('SwisSBLKey').Text))); {40-64}
      RPSExtractStrCat(SalesRec, ShiftRightAddZeroes(Take(7, FieldByName('EastCoord').Text))); {65-71}
      RPSExtractStrCat(SalesRec, ShiftRightAddZeroes(Take(7, FieldByName('NorthCoord').Text))); {72-78}
      RPSExtractStrCat(SalesRec, Copy(FieldByName('SwisSBLKey').Text, 1, 4)); {79-82}
      RPSExtractStrCat(SalesRec, Take(25, FieldByName('LegalAddr').Text)); {83-107}

        {Note: To be compatible with a quirk in the present RPS 995
         with the legal address number. The rules is:
         If the last part of the legal address number is a character,
         i.e. '42A', then the legal address number is right justified,
         blank filled in 10 spaces.
         If the last part of the legal address number is NOT
         a character, then the legal address number is right justified,
         blank filled in 9 spaces with 1 trailing blank space.

         I don't know why this is, but I am replicating it.}

      LegalAddrNo := Trim(FieldByName('LegalAddrNo').Text);

      If (LegalAddrNo[Length(LegalAddrNo)] in Letters)
        then RPSExtractStrCat(SalesRec, ShiftRightAddBlanks(Take(10, LegalAddrNo))) {108-117}
        else RPSExtractStrCat(SalesRec, ShiftRightAddBlanks(Take(9, LegalAddrNo)) + ' '); {108-117}

      RPSExtractStrCat(SalesRec, Take(6, FieldByName('SchoolDistCode').Text)); {118-123}

      If FieldByName('IrregularShape').AsBoolean
        then TempStr := 'I'
        else TempStr := '';
      RPSExtractStrCat(SalesRec, Take(1, TempStr)); {124}

      RPSExtractStrCat(SalesRec, FormatRPSNumericString(FieldByName('Frontage').Text, 7, 2)); {125-131}
      RPSExtractStrCat(SalesRec, FormatRPSNumericString(FieldByName('Depth').Text, 7, 2)); {132-138}
      RPSExtractStrCat(SalesRec, FormatRPSNumericString(FieldByName('Acreage').Text, 7, 2)); {139-145}
      RPSExtractStrCat(SalesRec, Take(1, FieldByName('OwnershipCode').Text)); {146-146}
      RPSExtractStrCat(SalesRec, Take(3, FieldByName('PropClass').Text)); {147-149}
      RPSExtractStrCat(SalesRec, Take(1, FieldByName('HomesteadCode').Text)); {150-150}
      RPSExtractStrCat(SalesRec, Copy(FieldByName('SwisSBLKey').Text, 1, 4)); {151-154}
      RPSExtractStrCat(SalesRec, Take(25, FieldByName('NewOwnerName').Text)); {155-179}
      RPSExtractStrCat(SalesRec, Take(11, FieldByName('AccountNo').Text)); {180-190}
      RPSExtractStrCat(SalesRec, Take(1, FieldByName('RollSection').Text)); {191-191}
      RPSExtractStrCat(SalesRec, Take(1, FieldByName('RollSubsection').Text));  {192-192}
      RPSExtractStrCat(SalesRec, Take(5, FieldByName('DeedBook').Text)); {193-197}
      RPSExtractStrCat(SalesRec, Take(5, FieldByName('DeedPage').Text)); {198-202}
      RPSExtractStrCat(SalesRec, Take(1, FieldByName('DeedTypeCode').Text)); {203-203}
      RPSExtractStrCat(SalesRec,
                   ShiftRightAddZeroes(Take(6, MakeMMDDYY(TDateField(FieldByName('DeedDate')).AsDateTime)))); {204-209}
      RPSExtractStrCat(SalesRec, Take(7, FieldByName('ControlNo').Text)); {210-216}
      RPSExtractStrCat(SalesRec,
               ShiftRightAddZeroes(Take(6, MakeMMDDYY(TDateField(FieldByName('SaleDate')).AsDateTime))));  {217-222}

      RPSExtractStrCat(SalesRec, FormatRPSNumericString(FieldByName('SalePrice').Text, 12, 0)); {223-234}
      RPSExtractStrCat(SalesRec, Take(1, FieldByName('SaleTypeCode').Text)); {235-235}

        {FXX02201998-1: Adjust to the valid sale and ArmsLength fields
                        being Booleans.}

      RPSExtractStrCat(SalesRec, BoolToChar_0_1(FieldByName('ValidSale').AsBoolean)); {236-236}

        {FXX06221998-2: Don't extract arms length for sales report extract.}

      If SalesReportExtract
        then RPSExtractStrCat(SalesRec, Take(1, '')) {237-237}
        else RPSExtractStrCat(SalesRec, BoolToChar_0_1(FieldByName('ArmsLength').AsBoolean)); {237-237}

      RPSExtractStrCat(SalesRec, Take(4, FieldByName('SaleConditionCode').Text)); {238-241}

        {FXX03152005-1(2.8.3.11): Make sure the sale status code is 'R' if this is a retransmit.}

      If SalesReportExtract
        then
          begin
            If (FieldByName('SaleStatusCode').Text = 'R')
              then RPSExtractStrCat(SalesRec, Take(1, 'R'))
              else RPSExtractStrCat(SalesRec, Take(1, 'T'));  {Transmitted for rpt.}
          end
        else RPSExtractStrCat(SalesRec, Take(1, FieldByName('SaleStatusCode').Text)); {242-242}
      RPSExtractStrCat(SalesRec, Take(4, FieldByName('AssessorChangeFlag').Text)); {243-246}
      RPSExtractStrCat(SalesRec, Take(1, FieldByName('VerifyCode').Text)); {247-247}
      RPSExtractStrCat(SalesRec, ShiftRightAddZeroes(Take(3, FieldByName('NoParcels').Text))); {248-250}
      RPSExtractStrCat(SalesRec, FormatRPSNumericString(FieldByName('PersonalPropVal').Text, 9, 0)); {251-259}
      RPSExtractStrCat(SalesRec, FormatRPSNumericString(FieldByName('LandAssessedVal').Text, 12, 0)); {260-271}
      RPSExtractStrCat(SalesRec, FormatRPSNumericString(FieldByName('TotAssessedVal').Text,12, 0)); {272-283}

        {FXX11072012-1(MDT)[PAS709]: Need to do a take on the Assessment Year in case it is blank.}

      RPSExtractStrCat(SalesRec, Copy(Take(4, FieldByName('SaleAssessmentYear').Text), 3, 2)); {284-285}
      RPSExtractStrCat(SalesRec, Take(25, FieldByName('OldOwnerName').Text)); {286-310}

      RPSExtractStrCat(SalesRec, Take(1, FieldByName('ActiveFlag').Text)); {311-311}

      RPSExtractStrCat(SalesRec, Take(3, '')); {312-314}

      If SalesReportExtract
        then RPSExtractStrCat(SalesRec, MakeMMDDYY(Date))  {For extract put today's date.}
        else RPSExtractStrCat(SalesRec, Take(6, ''));  {315-320}
      RPSExtractStrCat(SalesRec, Take(27, ''));  {321-347}
      RPSExtractStrCat(SalesRec, ShiftRightAddZeroes(Take(2, FieldByName('NumResSites').Text))); {348-349}
      RPSExtractStrCat(SalesRec, ShiftRightAddZeroes(Take(2, FieldByName('NumComSites').Text))); {350-351}

        {FXX06221998-2: Some additional fields for the sales report extract.}

      If SalesReportExtract
        then
          begin
            SwisSBLKey := SalesTable.FieldByName('SwisSBLKey').Text;
            SBLRec := ExtractSwisSBLFromSwisSBLKey(SwisSBLKey);

            with SBLRec do
              ParcelFound := FindKeyOld(ParcelTable,
                                        ['TaxRollYr', 'SwisCode', 'Section',
                                         'Subsection', 'Block', 'Lot',
                                         'Sublot', 'Suffix'],
                                        [GlblNextYear, SwisCode, Section,
                                         Subsection, Block, Lot,
                                         Sublot, Suffix]);
            FindKeyOld(AssessmentTable,
                       ['TaxRollYr', 'SwisSBLKey'],
                       [GlblNextYear, SwisSBLKey]);

              {Just leave the following info blank if parcel no longer exists.}

            If ParcelFound
              then
                begin
                  with ParcelTable do
                    begin
                      RPSExtractStrCat(SalesRec, Take(3, FieldByName('PropertyClassCode').Text)); {352-354}
                      RPSExtractStrCat(SalesRec, Take(1, FieldByName('OwnershipCode').Text)); {355-355}

                        {Only print out the owner info on the last sale for this property
                         that will appear in the extract file. To figure this out,
                         we will bookmark the present position and search forward
                         for a different SBL or another rec that will be transmitted for
                         this SBL.}

                      TempBookmark := SalesTable.GetBookmark;
                      DifferentSwisSBLKey := False;
                      FoundAnotherRecForParcel := False;

                      repeat
                        SalesTable.Next;

                        If (SwisSBLKey = SalesTable.FieldByName('SwisSBLKey').Text)
                          then
                            begin
                              TempStr := Take(1, SalesTable.FieldByName('SaleStatusCode').Text);
                              If (TempStr[1] in ['A', 'R', 'M'])
                                then FoundAnotherRecForParcel := True;
                            end
                          else DifferentSwisSBLKey := True;

                      until (DifferentSwisSBLKey or FoundAnotherRecForParcel);

                      If FoundAnotherRecForParcel
                        then RPSExtractStrCat(SalesRec, Take(134, ''))
                        else
                          begin
                            RPSExtractStrCat(SalesRec, Take(25, FieldByName('Name2').Text)); {356-380}
                            RPSExtractStrCat(SalesRec, Take(25, FieldByName('Address1').Text)); {381-405}
                            RPSExtractStrCat(SalesRec, Take(25, FieldByName('Address2').Text)); {406-430}
                            RPSExtractStrCat(SalesRec, Take(25, FieldByName('Street').Text)); {431-455}

                            TempStr := FieldByName('City').Text;
                            If (Deblank(TempStr) <> '')
                              then TempStr := TempStr + ' ';
                            TempStr := TempStr + FieldByName('State').Text;

                            RPSExtractStrCat(SalesRec, Take(25, TempStr)); {456-480}
                            RPSExtractStrCat(SalesRec, Take(5, FieldByName('Zip').Text)); {481-485}
                            RPSExtractStrCat(SalesRec, Take(4, FieldByName('ZipPlus4').Text)); {486-489}

                          end;  {If FoundAnotherRecForParcel}

                      SalesTable.GotoBookmark(TempBookmark);
                      SalesTable.FreeBookmark(TempBookmark);

                    end;  {with ParcelTable do}

                  RPSExtractStrCat(SalesRec,
                      FormatRPSNumericString(AssessmentTable.FieldByName('TotalAssessedVal').Text,12, 0)); {490-501}

                end  {If ParcelFound}
              else RPSExtractStrCat(SalesRec, Take(150, ''));

            with SalesTable do
              FullSalesPrice := FieldByName('SalePrice').AsFloat + FieldByName('PersonalPropVal').AsFloat;

            RPSExtractStrCat(SalesRec, FormatRPSNumericString(FloatToStr(FullSalesPrice),12, 0)); {502-513}

              {FXX09231999-1: Need to include the final roll date in the sales extract.}

            RPSExtractStrCat(SalesRec,  {Final roll date}  {514-519}
                             Take(6, MakeMMDDYY(AssessmentYearCtlTable.FieldByName('FinalRollDate').AsDateTime)));
            RPSExtractStrCat(SalesRec, Take(15, 'PAS'));  {520-534}
            RPSExtractStrCat(SalesRec, Take(255, ''));  {535-789}
            RPSExtractStrCat(SalesRec, Take(31, ''));  {790-820}

          end
        else
          begin
            RPSExtractStrCat(SalesRec, Take(255, ''));  {Split the filler into 2 strings.} {352-820}
            RPSExtractStrCat(SalesRec, Take(214, ''));
          end;

      RPSExtractStrCat(SalesRec, Take(2, '12'));  {821-822}

    end;  {with SalesTable do}

end;  {ExtractOneSalesRecord}

{==============================================================================}
Procedure MarkLastRecordForSale(SalesRec : PRPSExtractRec;
                                ResInventoryRecords,
                                ComInventoryRecords : TList);

{Put a '999' in positions 37-39 of the last record (i.e. print order -
 which is the order they are passed in) for this sales.}

var
  Index : Integer;
  RecMarked : Boolean;

begin
  RecMarked := False;

  If (ComInventoryRecords.Count > 0)
    then
      begin
        RecMarked := True;
        Index := ComInventoryRecords.Count - 1;

        PRPSExtractRec(ComInventoryRecords[Index])^[37] := '9';
        PRPSExtractRec(ComInventoryRecords[Index])^[38] := '9';
        PRPSExtractRec(ComInventoryRecords[Index])^[39] := '9';

      end;  {If (ComInventory.Count > 0)}

  If ((not RecMarked) and
      (ResInventoryRecords.Count > 0))
    then
      begin
        RecMarked := True;
        Index := ResInventoryRecords.Count - 1;

        PRPSExtractRec(ResInventoryRecords[Index])^[37] := '9';
        PRPSExtractRec(ResInventoryRecords[Index])^[38] := '9';
        PRPSExtractRec(ResInventoryRecords[Index])^[39] := '9';

      end;  {If (ResInventory.Count > 0)}

  If not RecMarked
    then
      begin
        PRPSExtractRec(SalesRec)^[37] := '9';
        PRPSExtractRec(SalesRec)^[38] := '9';
        PRPSExtractRec(SalesRec)^[39] := '9';

      end;  {If not RecMarked}

end;  {MarkLastRecordForParcel}

{==============================================================================}
{=====================  PARCEL EXTRACT ========================================}
{==============================================================================}
Function ExtractParcelHdrRecord(ParcelTable : TTable;
                                SwisSBLKey : String;
                                ProcessingType : Integer) : String;

{Return a string with the header for the Parcel record.}

begin
  Result := '';

  with ParcelTable do
    begin
      Result := Result + Take(26, SwisSBLKey);  {1-26}
      Result := Result + Take(2, '00');  {27-28}

      If (ProcessingType = ThisYear)
        then Result := Result + Take(1, '1')  {29-29}
        else Result := Result + Take(1, '3');  {29-29}

      Result := Result + Take(2, '00');  {30-31}
      Result := Result + Take(1, 'P');  {32-32}
      Result := Result + Take(2, '00');  {33-34}
      Result := Result + Take(2, FieldByName('CheckDigit').Text);  {35-36}
      Result := Result + Take(3, '');  {37-39}

    end;  {with ParcelTable do}

end;  {ExtractParcelHdrRecord}

{FXX10021997-2: Pass in the record so not alloc'ed 2x.}
{==============================================================================}
Procedure ExtractOneParcelRecord(    ParcelRec : PRPSExtractRec;
                                     ParcelTable,
                                     AssessmentTable,
                                     ExTable,
                                     EXCodeTable,
                                     SortAVChangesTable : TTable;
                                     SwisSBLKey : String;
                                     NumResSites,
                                     NumComSites,
                                     NumEXRecs,
                                     NumSDRecs,
                                     NumSaleRecs,
                                     ProcessingType : Integer;
                                     TaxableStatusDate : String;
                                     PriorValues,
                                     TYValues,
                                     NYValues : BaseInfoRecord;
                                 var EqualizationInc,
                                     PhysicalQtyInc,
                                     EqualizationDec,
                                     PhysicalQtyDec,
                                     PriorHoldValue : Comp;
                                 var HoldPriorRollSection,
                                     HoldPriorStatus,
                                     HoldPriorHomestead : String;
                                 var HoldPriorPropClass : String;
                                     PrintTYAndNY,
                                     Is210File : Boolean);

var
  Year, Month, Day : Word;
  YearStr, TaxRollYear : String;
  ExemptionTotArray : ExemptionTotalsArrayType;
  TempNum : Extended;
  ExemptionCodes,
  ExemptionHomesteadCodes,
  ResidentialTypes,
  CountyExemptionAmounts,
  TownExemptionAmounts,
  SchoolExemptionAmounts,
  VillageExemptionAmounts : TStringList;
  BasicSTARAmount, EnhancedSTARAmount,
  TempEqualizationInc, TempEqualizationDec,
  TempPhysicalQtyInc, TempPhysicalQtyDec : Comp;
  TempStr : String;
  _Found, AssessmentRecordFound : Boolean;
  LegalAddrNo : String;
  CurrentResPercent, PriorResPercent : Real;
  CurrentOwnershipCode, PriorOwnershipCode,
  CurrentHomesteadCode, PriorHomesteadCode,
  CurrentRollSection, PriorRollSection : String;
  CurrentPropertyClass, PriorPropertyClass : String;
  _2ndPriorLandVal, PriorLandVal, CurrentLandVal, PriorValue,
  _2ndPriorTotalAssessedVal, PriorTotalAssessedVal, CurrentTotalAssessedVal : Comp;
  PriorSchoolDistrict, CurrentSchoolDistrict : String;

begin
  ExemptionCodes := TStringList.Create;
  ExemptionHomesteadCodes := TStringList.Create;
  ResidentialTypes := TStringList.Create;
  CountyExemptionAmounts := TStringList.Create;
  TownExemptionAmounts := TStringList.Create;
  SchoolExemptionAmounts := TStringList.Create;
  VillageExemptionAmounts := TStringList.Create;

  If (ProcessingType = ThisYear)
    then
      begin
        CurrentResPercent := TYValues.ResidentialPercent;
        PriorResPercent := PriorValues.ResidentialPercent;
        CurrentOwnershipCode := TYValues.OwnershipCode;
        PriorOwnershipCode := PriorValues.OwnershipCode;
        CurrentPropertyClass := TYValues.PropertyClass;
        PriorPropertyClass := PriorValues.PropertyClass;
        CurrentHomesteadCode := TYValues.HomesteadCode;
        PriorHomesteadCode := PriorValues.HomesteadCode;
        CurrentRollSection := TYValues.RollSection;
        PriorRollSection := PriorValues.RollSection;
        _2ndPriorLandVal := 0;
        PriorLandVal := PriorValues.LandVal;
        CurrentLandVal := TYValues.LandVal;
        _2ndPriorTotalAssessedVal := 0;
        PriorTotalAssessedVal := PriorValues.TotalAssessedVal;
        CurrentTotalAssessedVal := TYValues.TotalAssessedVal;
        PriorSchoolDistrict := PriorValues.SchoolDistrict;
        CurrentSchoolDistrict := TYValues.SchoolDistrict;
      end
    else
      begin
        CurrentResPercent := NYValues.ResidentialPercent;
        PriorResPercent := TYValues.ResidentialPercent;
        CurrentOwnershipCode := NYValues.OwnershipCode;
        PriorOwnershipCode := TYValues.OwnershipCode;
        CurrentPropertyClass := NYValues.PropertyClass;
        PriorPropertyClass := TYValues.PropertyClass;
        CurrentHomesteadCode := NYValues.HomesteadCode;
        PriorHomesteadCode := TYValues.HomesteadCode;
        CurrentRollSection := NYValues.RollSection;
        PriorRollSection := TYValues.RollSection;
        _2ndPriorLandVal := PriorValues.LandVal;
        PriorLandVal := TYValues.LandVal;
        CurrentLandVal := NYValues.LandVal;
        _2ndPriorTotalAssessedVal := PriorValues.TotalAssessedVal;
        PriorTotalAssessedVal := TYValues.TotalAssessedVal;
        CurrentTotalAssessedVal := NYValues.TotalAssessedVal;
        PriorSchoolDistrict := TYValues.SchoolDistrict;
        CurrentSchoolDistrict := NYValues.SchoolDistrict;

      end;  {else of If (ProcessingType = ThisYear)}

    {FXX03152000-1: Fix the way the hold values are gotten.}

  If (Is210File and
      GlblIsWestchesterCounty and
      (ProcessingType = ThisYear))
    then
      begin
        PriorHoldValue := TYValues.PriorHoldValue;

        HoldPriorRollSection := TYValues.PriorHoldRollSection;
        HoldPriorStatus := TYValues.PriorHoldStatus;
        HoldPriorPropClass := TYValues.PriorHoldPropertyClass;
        HoldPriorHomestead := TYValues.PriorHoldHomesteadCode;

      end;  {If (Is210File and ...}

  If (Is210File and
      (not GlblIsWestchesterCounty) and
      (ProcessingType = ThisYear))
    then
      begin
        PriorHoldValue := PriorValues.PriorHoldValue;

        HoldPriorRollSection := PriorValues.PriorHoldRollSection;
        HoldPriorStatus := PriorValues.PriorHoldStatus;
        HoldPriorPropClass := PriorValues.PriorHoldPropertyClass;
        HoldPriorHomestead := PriorValues.PriorHoldHomesteadCode;

      end;  {If (Is210File and ...}


  If Is210File
    then
      begin
        PriorRollSection := HoldPriorRollSection;
        PriorPropertyClass := HoldPriorPropClass;
        PriorHomesteadCode := HoldPriorHomestead;
      end;

  TaxRollYear := GetTaxRollYearForProcessingType(ProcessingType);

    {Get the assessment record for this parcel.}

  try
    AssessmentRecordFound := FindKeyOld(AssessmentTable,
                                        ['TaxRollYr', 'SwisSBLKey'],
                                        [TaxRollYear, SwisSBLKey]);
  except
    AssessmentRecordFound := False;
    SystemSupport(870, AssessmentTable, 'Error getting assessment record for parcel ' +
                  ConvertSwisSBLToDashDot(SwisSBLKey),
                  'RPS995UT.PAS', GlblErrorDlgBox);
  end;

  InitializeRPSExtractString(ParcelRec);

    {First do the header.}

  RPSExtractStrCat(ParcelRec, ExtractParcelHdrRecord(ParcelTable, SwisSBLKey,
                                                  ProcessingType));

    {Now do the rest of the information.}

  with ParcelTable do
    begin
      If (Deblank(FieldByName('RemapOldSBL').Text) = '')
        then RPSExtractStrCat(ParcelRec, Take(25, 'NONE'))
        else RPSExtractStrCat(ParcelRec, Take(25, FieldByName('RemapOldSBL').Text));  {40-64}

      RPSExtractStrCat(ParcelRec, Take(25, ConvertSwisSBLToDashDotNoSwis(SwisSBLKey)));  {65-89}
      RPSExtractStrCat(ParcelRec, ShiftRightAddZeroes(Take(7, FieldByName('GridCordEast').Text)));  {90-96}
      RPSExtractStrCat(ParcelRec, ShiftRightAddZeroes(Take(7, FieldByName('GridCordNorth').Text)));  {97-103}
      RPSExtractStrCat(ParcelRec, Copy(FieldByName('SwisCode').Text, 1, 4));  {104-107}
      RPSExtractStrCat(ParcelRec, Take(25, FieldByName('LegalAddr').Text));  {108-132}

        {We will conform to present 155\995 legal addr number format for
         file comparison purposes. The rule is: If this is a numeric legal
         addr number, put it to the right in nine spaces and leave one
         blank space. Otherwise, put it to the right in 10 spaces.}

      LegalAddrNo := Trim(FieldByName('LegalAddrNo').Text);

      If (LegalAddrNo[Length(LegalAddrNo)] in Numbers)
        then LegalAddrNo := ShiftRightAddBlanks(Take(9, LegalAddrNo)) + ' '
        else LegalAddrNo := ShiftRightAddBlanks(Take(10, LegalAddrNo));

      RPSExtractStrCat(ParcelRec, LegalAddrNo);  {133-142}
      RPSExtractStrCat(ParcelRec, Take(6, PriorSchoolDistrict));  {143-148}
      RPSExtractStrCat(ParcelRec, Take(6, CurrentSchoolDistrict));  {149-154}
      RPSExtractStrCat(ParcelRec, Take(6, FieldByName('ConsolidatedSchlDist').Text));  {155-160}
      RPSExtractStrCat(ParcelRec, Take(1, FieldByname('DescriptionPrintCode').Text));  {161-161}
      RPSExtractStrCat(ParcelRec, Take(25, FieldByName('PropDescr1').Text));  {162-186}
      RPSExtractStrCat(ParcelRec, Take(25, FieldByName('PropDescr2').Text));  {187-211}
      RPSExtractStrCat(ParcelRec, Take(25, FieldByName('PropDescr3').Text));  {212-236}

        {IrregularShape in PAS is T\F and is DimensionsCode in RPS with
         values of I/blank.}

      If FieldByName('IrregularShape').AsBoolean
        then RPSExtractStrCat(ParcelRec, 'I')  {237-237}
        else RPSExtractStrCat(ParcelRec, ' ');

      RPSExtractStrCat(ParcelRec, FormatRPSNumericString(FieldByName('Frontage').Text, 7, 2));  {238-244}
      RPSExtractStrCat(ParcelRec, FormatRPSNumericString(FieldByName('Depth').Text, 7, 2));  {245-251}
      RPSExtractStrCat(ParcelRec, FormatRPSNumericString(FieldByName('Acreage').Text, 7, 2));  {252-258}

      RPSExtractStrCat(ParcelRec, FormatRPSNumericString(FloatToStr(PriorResPercent), 2, 0));  {259-260}
      RPSExtractStrCat(ParcelRec, FormatRPSNumericString(FloatToStr(CurrentResPercent), 2, 0));  {261-262}
      RPSExtractStrCat(ParcelRec, Take(1, PriorOwnershipCode));  {263-263}
      RPSExtractStrCat(ParcelRec, Take(1, CurrentOwnershipCode));  {264-264}
      RPSExtractStrCat(ParcelRec, Take(3, PriorPropertyClass));  {265-267}
      RPSExtractStrCat(ParcelRec, Take(3, CurrentPropertyClass));  {268-270}
      RPSExtractStrCat(ParcelRec, Take(1, PriorHomesteadCode));  {271-271}
      RPSExtractStrCat(ParcelRec, Take(1, CurrentHomesteadCode));  {272-272}
      RPSExtractStrCat(ParcelRec, Copy(FieldByName('SwisCode').Text, 1, 4));  {273-276}
      RPSExtractStrCat(ParcelRec, Take(25, FieldByName('Name1').Text));  {277-301}
      RPSExtractStrCat(ParcelRec, Take(25, FieldByName('Name2').Text));  {302-326}
      RPSExtractStrCat(ParcelRec, Take(25, FieldByName('Address1').Text));  {327-351}
      RPSExtractStrCat(ParcelRec, Take(25, FieldByName('Address2').Text));  {352-376}
      RPSExtractStrCat(ParcelRec, Take(25, FieldByName('Street').Text));  {377-401}
      RPSExtractStrCat(ParcelRec, Take(25, (RTrim(FieldByName('City').Text) + '  ' +
                                         RTrim(FieldByName('State').Text))));  {402-426}
      RPSExtractStrCat(ParcelRec, Take(5, FieldByName('Zip').Text));  {427-431}
      RPSExtractStrCat(ParcelRec, Take(4, FieldByName('ZipPlus4').Text));  {432-435}
      RPSExtractStrCat(ParcelRec, Take(11, FieldByName('AccountNo').Text));  {436-446}
      RPSExtractStrCat(ParcelRec, Take(1, PriorRollSection));  {447-447}
      RPSExtractStrCat(ParcelRec, Take(1, CurrentRollSection));  {448-448}
      RPSExtractStrCat(ParcelRec, Take(1, FieldByName('RollSubsection').Text));  {449-449}
      RPSExtractStrCat(ParcelRec, Take(7, FieldByName('BankCode').Text));  {450-456}
      RPSExtractStrCat(ParcelRec, Take(9, FieldByName('MortgageNumber').Text));  {457-465}

          {FXX10121997-5: Right justify deed book and page.}
      RPSExtractStrCat(ParcelRec, ShiftRightAddBlanks(Take(5, FieldByName('DeedBook').Text)));  {466-470}
      RPSExtractStrCat(ParcelRec, ShiftRightAddBlanks(Take(5, FieldByName('DeedPage').Text)));  {471-475}
      RPSExtractStrCat(ParcelRec, Take(1, FieldByName('EasementCode').Text));  {476-476}
      RPSExtractStrCat(ParcelRec, Take(1, FieldByName('LandCommitmentCode').Text));  {477-477}

      If (Deblank(FieldByName('CommitmentTermYear').Text) = '')
        then YearStr := Take(4, '    ')
        else
          try
            DecodeDate(FieldByName('CommitmentTermYear').AsDateTime, Year, Month, Day);
            YearStr := IntToStr(Year);
          except
            YearStr := Take(4, '    ');
          end;

      RPSExtractStrCat(ParcelRec, Copy(YearStr, 3, 2));  {478-479}

    end;  {with ParcelTable do}

    {FXX09091999-6: Instead of giving an error for no assessment record, skip the
                    extract for this section.}

  If AssessmentRecordFound
    then
      with AssessmentTable do
        begin
          RPSExtractStrCat(ParcelRec, Take(1, FieldByName('OrigCurrYrValCode').Text));  {480-480}
          RPSExtractStrCat(ParcelRec, Take(1, FieldByName('RevisedCurrYrValCode').Text));  {481-481}

            {Building permits in RPS is a T/F field, so if there is anything
             in the permit field, we will put a 1 in the extract record.
             Otherwise, we will leave it blank.}

          If (Deblank(FieldByName('BuildingPermits').Text) = '')
            then RPSExtractStrCat(ParcelRec, ' ')  {482-482}
            else RPSExtractStrCat(ParcelRec, '1');  {482-482}

            {FXX11011999-4: For the 210 file, need to carry over inc and decreases
                           from ThisYear assessment rec.}

          If Is210File
            then
              begin
                _Found := FindKeyOld(SortAVChangesTable, ['SwisSBLKey'],
                                     [SwisSBLKey]);

                If _Found
                  then
                    begin
                      TempEqualizationInc := SortAVChangesTable.FieldByName('HstdEqualInc').AsFloat +
                                             SortAVChangesTable.FieldByName('NonHstdEqualInc').AsFloat;
                      TempEqualizationDec := SortAVChangesTable.FieldByName('HstdEqualDec').AsFloat +
                                             SortAVChangesTable.FieldByName('NonHstdEqualDec').AsFloat;
                      TempPhysicalQtyInc := SortAVChangesTable.FieldByName('HstdPhysQtyInc').AsFloat +
                                            SortAVChangesTable.FieldByName('NonHstdPhysQtyInc').AsFloat;
                      TempPhysicalQtyDec := SortAVChangesTable.FieldByName('HstdPhysQtyDec').AsFloat +
                                            SortAVChangesTable.FieldByName('NonHstdPhysQtyDec').AsFloat;
                    end
                  else
                    begin
                      TempEqualizationInc := 0;
                      TempEqualizationDec := 0;
                      TempPhysicalQtyInc := 0;
                      TempPhysicalQtyDec := 0;

                    end;  {else of If Found}

                PriorValue := PriorHoldValue;

                  {If the prior is deleted, show no prior value.}

                If (HoldPriorStatus = InactiveParcelFlag)
                  then
                    begin
                      PriorValue := 0;
                      PriorLandVal := 0;
                      PriorHoldValue := 0;
                    end;

              end
            else
              begin
                TempEqualizationInc := FieldByName('IncreaseForEqual').AsFloat;
                TempEqualizationDec := FieldByName('DecreaseForEqual').AsFloat;
                TempPhysicalQtyInc := FieldByName('PhysicalQtyIncrease').AsFloat;
                TempPhysicalQtyDec := FieldByName('PhysicalQtyDecrease').AsFloat;
                PriorValue := PriorTotalAssessedVal;
              end;

          RPSExtractStrCat(ParcelRec, FormatRPSNumericString(FloatToStr(_2ndPriorLandVal), 12, 0));  {483-494}
          RPSExtractStrCat(ParcelRec, FormatRPSNumericString(FloatToStr(_2ndPriorTotalAssessedVal), 12, 0));  {495-506}
          RPSExtractStrCat(ParcelRec, FormatRPSNumericString(FloatToStr(PriorLandVal), 12, 0));  {507-518}
            {FXX11091999-1: For 210, use prior hold value.}
          RPSExtractStrCat(ParcelRec, FormatRPSNumericString(FloatToStr(PriorValue), 12, 0));  {519-530}
          RPSExtractStrCat(ParcelRec, FormatRPSNumericString(FloatToStr(CurrentLandVal), 12, 0));  {531-542}
          RPSExtractStrCat(ParcelRec, FormatRPSNumericString(FloatToStr(CurrentTotalAssessedVal), 12, 0));  {543-554}
          RPSExtractStrCat(ParcelRec, FormatRPSNumericString(FloatToStr(TempEqualizationInc), 12, 0));  {555-566}
          RPSExtractStrCat(ParcelRec, FormatRPSNumericString(FloatToStr(TempEqualizationDec), 12, 0));  {567-578}
          RPSExtractStrCat(ParcelRec, FormatRPSNumericString(FloatToStr(TempPhysicalQtyInc), 12, 0));  {579-590}
          RPSExtractStrCat(ParcelRec, FormatRPSNumericString(FloatToStr(TempPhysicalQtyDec), 12, 0));  {591-602}
          RPSExtractStrCat(ParcelRec, FormatRPSNumericString(FieldByName('RevalLandVal').Text, 12, 0));  {603-614}
          RPSExtractStrCat(ParcelRec, FormatRPSNumericString(FieldByName('RevalTotalVal').Text, 12, 0));  {615-626}
          RPSExtractStrCat(ParcelRec, FormatRPSNumericString(FieldByName('ImpactTotalVal').Text, 12, 0));  {627-638}
          RPSExtractStrCat(ParcelRec, FormatRPSNumericString(FloatToStr(PriorHoldValue), 12, 0));  {639-650}

             {Figure out the exemption totals.}
             {CHG12011997-2: STAR support}
             {FXX02091998-1: Pass the residential type of each exemption.}

          ExemptionTotArray := TotalExemptionsForParcel(TaxRollYear, SwisSBLKey,
                                                        ExTable, EXCodeTable,
                                                        ParcelTable.FieldByName('HomesteadCode').Text,
                                                        'A', ExemptionCodes,
                                                        ExemptionHomesteadCodes,
                                                        ResidentialTypes,
                                                        CountyExemptionAmounts,
                                                        TownExemptionAmounts,
                                                        SchoolExemptionAmounts,
                                                        VillageExemptionAmounts,
                                                        BasicSTARAmount,
                                                        EnhancedSTARAmount);

          If ParcelIsActive(ParcelTable)
            then TempNum := CurrentTotalAssessedVal - ExemptionTotArray[ExCounty]
            else TempNum := 0;
          RPSExtractStrCat(ParcelRec, FormatRPSNumericString(FloatToStr(TempNum), 12, 0));  {651-662}

          If ParcelIsActive(ParcelTable)
            then TempNum := CurrentTotalAssessedVal - ExemptionTotArray[ExTown]
            else TempNum := 0;
          RPSExtractStrCat(ParcelRec, FormatRPSNumericString(FloatToStr(TempNum), 12, 0));  {663-674}

          If ParcelIsActive(ParcelTable)
            then TempNum := CurrentTotalAssessedVal - ExemptionTotArray[ExSchool]
            else TempNum := 0;
          RPSExtractStrCat(ParcelRec, FormatRPSNumericString(FloatToStr(TempNum), 12, 0));  {675-686}

            {FXX05162002-1: Always show the village taxable value.}
            {CHG03132004-1(2.08): If this municipality does not have village roll totals, show town totals here.}

          If ParcelIsActive(ParcelTable)
(*              (GlblMunicipalityType = MTVillage))  {Only print village taxable if munic is vill}*)
            then
              begin
                If (rtdVillageReceivingPartialRoll in GlblRollTotalsToShow)
                  then TempNum := CurrentTotalAssessedVal - ExemptionTotArray[ExVillage]
                  else TempNum := CurrentTotalAssessedVal - ExemptionTotArray[ExTown];

              end
            else TempNum := 0;
          RPSExtractStrCat(ParcelRec, FormatRPSNumericString(FloatToStr(TempNum), 12, 0));  {687-698}

        end  {with AssessmentTable do}
      else RPSExtractStrCat(ParcelRec, Take(219, ''));  {No assessment rec.}

    {Total aged exemptions.}
    {FXX02091998-1: Pass the residential type of each exemption.}

  ExemptionTotArray := TotalExemptionsForParcel(TaxRollYear, SwisSBLKey,
                                                ExTable, EXCodeTable,
                                                ParcelTable.FieldByName('HomesteadCode').Text,
                                                'G', ExemptionCodes,
                                                ExemptionHomesteadCodes,
                                                ResidentialTypes,
                                                CountyExemptionAmounts,
                                                TownExemptionAmounts,
                                                SchoolExemptionAmounts,
                                                VillageExemptionAmounts,
                                                BasicSTARAmount,
                                                EnhancedSTARAmount);

  RPSExtractStrCat(ParcelRec, FormatRPSNumericString(FloatToStr(ExemptionTotArray[ExCounty]), 9, 0));  {699-707}
  RPSExtractStrCat(ParcelRec, FormatRPSNumericString(FloatToStr(ExemptionTotArray[ExSchool]), 9, 0));  {708-716}
  RPSExtractStrCat(ParcelRec, FormatRPSNumericString(FloatToStr(ExemptionTotArray[ExVillage]), 9, 0));  {717-725}

  with ParcelTable do
    begin
      RPSExtractStrCat(ParcelRec, FormatRPSNumericString(FieldByName('AllocationFactor').Text, 4, 0));  {726-729}
      RPSExtractStrCat(ParcelRec, ShiftRightAddZeroes(Take(8, FieldByName('SplitMergeNo').Text)));  {730-737}

      RPSExtractStrCat(ParcelRec, Copy(TaxableStatusDate, 5, 2));  {738-739}
      RPSExtractStrCat(ParcelRec, Take(1, FieldByName('ActiveFlag').Text));  {740-740}

      If (ProcessingType = ThisYear)
        then
          begin
            If PrintTYAndNY
              then TempStr := '1'
              else TempStr := '0';
          end
        else TempStr := '0';

      RPSExtractStrCat(ParcelRec, Take(1, TempStr));  {741}
        {FXX12201998-1: Relevy amounts need 2 decimal points.}
      RPSExtractStrCat(ParcelRec, FormatRPSNumericString(FieldByName('SchoolRelevy').Text, 9, 2));  {742-750}
          {FXX10121997-1: Should be "VillageRelevy" not 'TownRelevy".}
      RPSExtractStrCat(ParcelRec, FormatRPSNumericString(FieldByName('VillageRelevy').Text, 9, 2));  {751-759}
      RPSExtractStrCat(ParcelRec, MakeMMDDYY(FieldByName('ParcelCreatedDate').AsDateTime));  {760-765}
      RPSExtractStrCat(ParcelRec, ShiftRightAddZeroes(Take(6, '')));  {766-771}  {No termination date}
      RPSExtractStrCat(ParcelRec, MakeMMDDYY(FieldByName('LastChangeDate').AsDateTime));  {772-777}
      RPSExtractStrCat(ParcelRec, Take(3, FieldByName('LastChangeByName').Text));  {778-780}
      RPSExtractStrCat(ParcelRec, Take(2, ''));  {781-782}  {No trans code}
      RPSExtractStrCat(ParcelRec, Take(1, PriorHomesteadCode));  {783-783}
      RPSExtractStrCat(ParcelRec, Take(24, ''));  {784-807}  {No user data}
      RPSExtractStrCat(ParcelRec, ShiftRightAddZeroes(Take(2, IntToStr(NumResSites))));  {808-809}
      RPSExtractStrCat(ParcelRec, ShiftRightAddZeroes(Take(2, IntToStr(NumComSites))));  {810-811}
      RPSExtractStrCat(ParcelRec, ShiftRightAddZeroes(Take(2, IntToStr(NumExRecs))));  {812-813}
      RPSExtractStrCat(ParcelRec, ShiftRightAddZeroes(Take(2, IntToStr(NumSDRecs))));  {814-815}
      RPSExtractStrCat(ParcelRec, ShiftRightAddZeroes(Take(2, IntToStr(NumSaleRecs))));  {816-817}
      RPSExtractStrCat(ParcelRec, ShiftRightAddZeroes(Take(2, IntToStr(NumSaleRecs))));  {818-819}
      RPSExtractStrCat(ParcelRec, Take(1, ''));  {820-820}  {Filler}

      If (ProcessingType = ThisYear)
        then RPSExtractStrCat(ParcelRec, Take(2, '14')) {821-822}
        else RPSExtractStrCat(ParcelRec, Take(2, '34')); {821-822}

    end;  {with ParcelTable do}

  ExemptionCodes.Free;
  ExemptionHomesteadCodes.Free;
  ResidentialTypes.Free;
  CountyExemptionAmounts.Free;
  TownExemptionAmounts.Free;
  SchoolExemptionAmounts.Free;
  VillageExemptionAmounts.Free;

end;  {ExtractOneParcelRecord}

{==============================================================================}
Function ExtractExemptionHdrRecord(ExemptionTable : TTable;
                                   ProcessingType : Integer) : String;

{Return a string with the header for the exemption record.}

begin
  Result := '';

  with ExemptionTable do
    begin
      Result := Result + Take(26, FieldByName('SwisSBLKey').Text);  {1-26}
      Result := Result + Take(2, '00');  {27-28}

      If (ProcessingType = ThisYear)
        then Result := Result + Take(1, '2')  {29-29}
        else Result := Result + Take(1, '4');  {29-29}

      Result := Result + Take(2, '00');  {30-31}
      Result := Result + Take(1, 'E');  {32-32}
      Result := Result + Take(2, '00');  {33-34}
      Result := Result + Take(2, '');  {35-36}
      Result := Result + Take(3, '');  {37-39}

    end;  {with ExemptionTable do}

end;  {ExtractExemptionHdrRecord}

{=======================================================================}
Function ExtractOneExemptionRecord(ExemptionTable : TTable;
                                   SetVillageExemptionFlagsToTrue : Boolean) : String;

{Extract the Exemption record that is presently pointed to in the Exemption table.}
{Note that the offsets are only within this record.}

var
  ExAppliesArray : ExemptionAppliesArrayType;
  TempStr, Amount : String;
  EXIdx : Integer;

begin
  Result := '';

  ExAppliesArray := ExApplies(ExemptionTable.FieldByName('ExemptionCode').Text,
                              ExemptionTable.FieldByName('ApplyToVillage').AsBoolean);

  with ExemptionTable do
    begin
      Result := Result + Take(5, FieldByName('ExemptionCode').Text);  {1-5}
        {FXX10211998-10: Store the amount field here for the case of a county or
                         school only exemption.}
        {FXX03031999-4: Need to put in the proper amount for this exemption type - if
                        this is a school only, put school - if this is a county, do county. Otherwise,
                        default to town.}

      ExIdx := GetExemptionAmountToDisplay(EXAppliesArray);

      case EXIdx of
        EXTown : Amount := FieldByName('TownAmount').Text;
        EXCounty : Amount := FieldByName('CountyAmount').Text;
        EXSchool : Amount := FieldByName('SchoolAmount').Text;
        EXVillage : Amount := FieldByName('VillageAmount').Text;
      end;

      Result := Result + FormatRPSNumericString(Amount, 12, 0);  {6-17}
      Result := Result + FormatRPSNumericString(FieldByName('Percent').Text, 3, 0);  {18-20}
      Result := Result + Copy(MakeMMDDYY(FieldByName('InitialDate').AsDateTime), 5, 2);  {21-22}
      Result := Result + Copy(MakeMMDDYY(FieldByName('TerminationDate').AsDateTime), 5, 2);  {23-24}

        {CHG05072002-2: Allow them to force all exemptions to apply to the village.}

      TempStr := BoolToChar_Blank_Y(TBooleanField(FieldByName('ApplyToVillage')).AsBoolean);

      If SetVillageExemptionFlagsToTrue
        then TempStr := 'Y';

      Result := Result + TempStr;{25-25} {blank, 1}
      Result := Result + Take(1, FieldByName('HomesteadCode').Text);  {26-26}

        {FXX08172004-1(2.08.0.08182004): Make sure that the owner percent is not garbage.}

      try
        Result := Result + FormatRPSNumericString(FieldByName('OwnerPercent').Text, 2, 0);  {27-28}
      except
        Result := Result + '00'  {27-28}
      end;

    end;  {with ExemptionTable do}

end;  {ExtractOneExemptionRecord}

{=======================================================================}
Function CreateBlankExemptionRecord : String;

{Create a blank exemption record to be compatible with RPS995 - put
 zeroes in numeric fields and blanks in non-numeric fields.}
{Note that the offsets are only within this record.}

begin
  Result := '';
  Result := Result + ShiftRightAddZeroes(Take(5, ''));  {1-5}
  Result := Result + ShiftRightAddZeroes(Take(12, ''));  {6-17}
  Result := Result + ShiftRightAddZeroes(Take(3, ''));  {18-20}
  Result := Result + ShiftRightAddZeroes(Take(2, ''));  {21-22}
  Result := Result + Take(2, '');  {23-24}
  Result := Result + Take(1, '');{25-25} {blank, 1}
  Result := Result + Take(1, '');  {26-26}
  Result := Result + Take(2, '');  {27-28}

end;  {CreateBlankExemptionRecord}

{FXX10021997-2: Pass in the record so not alloc'ed 2x.}
{==============================================================================}
Procedure ExtractExemptionRecord(    ExemptionRec : PRPSExtractRec;
                                     ExemptionTable : TTable;
                                     TaxRollYear : String;
                                     ProcessingType : Integer;
                                     SwisSBLKey : String;
                                 var NumExemptionRecords : Integer;
                                     SetVillageExemptionFlagsToTrue : Boolean);

var
  Done, Quit, FirstTimeThrough : Boolean;
  TempStr : String;
  I : Integer;

begin
  Done := False;
  Quit := False;
  FirstTimeThrough := True;
  NumExemptionRecords := 0;

  InitializeRPSExtractString(ExemptionRec);

    {Create the header.}

  SetRangeOld(ExemptionTable,
              ['TaxRollYr', 'SwisSBLKey', 'ExemptionCode'],
              [TaxRollYear, SwisSBLKey, '     '],
              [TaxRollYear, SwisSBLKey, 'ZZZZZ']);

  RPSExtractStrCat(ExemptionRec, ExtractExemptionHdrRecord(ExemptionTable,
                                                           ProcessingType));
  try
    ExemptionTable.First;
  except
    Quit := True;
    SystemSupport(001, ExemptionTable, 'Error getting first Exemption record.', 'EXTRUTIL.PAS',
                  GlblErrorDlgBox);
  end;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else
        try
          ExemptionTable.Next;
        except
          Quit := True;
          SystemSupport(002, ExemptionTable, 'Error getting first next record.', 'EXTRUTIL.PAS',
                        GlblErrorDlgBox);
        end;

    If (ExemptionTable.EOF or
        (Deblank(ExemptionTable.FieldByName('SwisSBLKey').Text) = ''))
      then Done := True;

      {If this is a good Exemption record and should be extracted, then we will extract it.
       If we are including inventory, then we will add that, too.}

    If not (Done or Quit)
      then
        begin
          RPSExtractStrCat(ExemptionRec, ExtractOneExemptionRecord(ExemptionTable,
                                                                   SetVillageExemptionFlagsToTrue));
          NumExemptionRecords := NumExemptionRecords + 1;
        end;

  until (Done or Quit);

    {There are 27 exemptions in the exemption record, so we need
     to fill out any unused spaces with blank exemption records.}

  For I := (NumExemptionRecords + 1) to 27 do
    RPSExtractStrCat(ExemptionRec, CreateBlankExemptionRecord);

    {Now do the footer.}

  If (ProcessingType = ThisYear)
    then TempStr := Take(25, '') + Take(2, '24')
    else TempStr := Take(25, '') + Take(2, '44');

  RPSExtractStrCat(ExemptionRec, TempStr);

end;  {ExtractExemptionRecord}

{==============================================================================}
Function ExtractClassHdrRecord(ClassTable : TTable;
                               ProcessingType : Integer;
                               ClassRec : PRPSExtractRec) : String;

{Return a string with the header for the Class record.}

begin
  with ClassTable do
    begin
      RPSExtractStrCat(ClassRec, Take(26, FieldByName('SwisSBLKey').Text));  {1-26}
      RPSExtractStrCat(ClassRec, Take(2, '00'));  {27-28}

      If (ProcessingType = ThisYear)
        then RPSExtractStrCat(ClassRec, Take(1, '2'))  {29-29}
        else RPSExtractStrCat(ClassRec, Take(1, '4'));  {29-29}

      RPSExtractStrCat(ClassRec, Take(2, '00'));  {30-31}
      RPSExtractStrCat(ClassRec, Take(1, 'H'));  {32-32}
      RPSExtractStrCat(ClassRec, Take(2, '00'));  {33-34}
      RPSExtractStrCat(ClassRec, Take(2, ''));  {35-36}
      RPSExtractStrCat(ClassRec, Take(3, ''));  {37-39}

    end;  {with ClassTable do}

end;  {ExtractClassHdrRecord}

{==============================================================================}
Procedure ExtractClassRecord(ClassTable,
                             ParcelTable,
                             ExemptionTable,
                             ExemptionCodeTable : TTable;
                             TaxRollYear : String;
                             ProcessingType : Integer;
                             SwisSBLKey : String;
                             ClassRec : PRPSExtractRec;
                             PriorValues,
                             TYValues,
                             NYValues : BaseInfoRecord);

{We already know there is a class record, so extract it.}

var
  ExemptionCodes,
  ExemptionHomesteadCodes,  {What is the homestead code for each exemption?}
  ResidentialTypes,
  CountyExemptionAmounts,
  TownExemptionAmounts,
  SchoolExemptionAmounts,
  VillageExemptionAmounts : TStringList;
  ExAmounts, HstdEXAmounts, NonhstdEXAmounts : ExemptionTotalsArrayType;
  BasicSTARAmount, EnhancedSTARAmount,
  TempNum, HstdAssessedVal, NonhstdAssessedVal,
  CountyAgedTotal, SchoolAgedTotal, VillageAgedTotal,
  _2ndPriorHstdLandVal, _2ndPriorHstdAssessedVal,
  PriorHstdLandVal, PriorHstdAssessedVal,
  CurrentHstdLandVal, CurrentHstdAssessedVal,
  _2ndPriorNonhstdLandVal, _2ndPriorNonhstdAssessedVal,
  PriorNonhstdLandVal, PriorNonhstdAssessedVal,
  CurrentNonhstdLandVal, CurrentNonhstdAssessedVal : Comp;
  I : Integer;
  TempReal : Real;
  TempStr : String;

begin
  ExemptionCodes := TStringList.Create;
  ExemptionHomesteadCodes := TStringList.Create;
  ResidentialTypes := TStringList.Create;
  CountyExemptionAmounts := TStringList.Create;
  TownExemptionAmounts := TStringList.Create;
  SchoolExemptionAmounts := TStringList.Create;
  VillageExemptionAmounts := TStringList.Create;

    {FXX02271998-1: Not initializing class record.}

  InitializeRPSExtractString(ClassRec);

  TempStr := ConvertSwisSBLToDashDot(SwisSBLkey);

  ExtractClassHdrRecord(ClassTable, ProcessingType, ClassRec);

    {CHG12011997-2: STAR support}
    {FXX02091998-1: Pass the residential type of each exemption.}

  EXAmounts := TotalExemptionsForParcel(TaxRollYear, SwisSBLKey,
                                        ExemptionTable,
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
                                        BasicSTARAmount, EnhancedSTARAmount);

  GetHomesteadAndNonhstdExemptionAmounts(ExemptionCodes,
                                         ExemptionHomesteadCodes,
                                         CountyExemptionAmounts,
                                         TownExemptionAmounts,
                                         SchoolExemptionAmounts,
                                         VillageExemptionAmounts,
                                         HstdEXAmounts,
                                         NonhstdEXAmounts);

    {FXX10211998-12: Extract the prior and 2nd prior values, too.}

  If (ProcessingType = ThisYear)
    then
      begin
        _2ndPriorHstdLandVal := 0;
        PriorHstdLandVal := PriorValues.HstdLandVal;
        CurrentHstdLandVal := TYValues.HstdLandVal;
        _2ndPriorHstdAssessedVal := 0;
        PriorHstdAssessedVal := PriorValues.HstdAssessedVal;
        CurrentHstdAssessedVal := TYValues.HstdAssessedVal;
        _2ndPriorNonhstdLandVal := 0;
        PriorNonhstdLandVal := PriorValues.NonhstdLandVal;
        CurrentNonhstdLandVal := TYValues.NonhstdLandVal;
        _2ndPriorNonhstdAssessedVal := 0;
        PriorNonhstdAssessedVal := PriorValues.NonhstdAssessedVal;
        CurrentNonhstdAssessedVal := TYValues.NonhstdAssessedVal;
      end
    else
      begin
        _2ndPriorHstdLandVal := PriorValues.HstdLandVal;
        PriorHstdLandVal := TYValues.HstdLandVal;
        CurrentHstdLandVal := NYValues.HstdLandVal;
        _2ndPriorHstdAssessedVal := PriorValues.HstdAssessedVal;
        PriorHstdAssessedVal := TYValues.HstdAssessedVal;
        CurrentHstdAssessedVal := NYValues.HstdAssessedVal;
        _2ndPriorNonhstdLandVal := PriorValues.NonhstdLandVal;
        PriorNonhstdLandVal := TYValues.NonhstdLandVal;
        CurrentNonhstdLandVal := NYValues.NonhstdLandVal;
        _2ndPriorNonhstdAssessedVal := PriorValues.NonhstdAssessedVal;
        PriorNonhstdAssessedVal := TYValues.NonhstdAssessedVal;
        CurrentNonhstdAssessedVal := NYValues.NonhstdAssessedVal;

      end;  {else of If (ProcessingType = ThisYear)}

  with ClassTable do
    begin
        {FXX03031998-13: Had hstd total % instead of val.}

      HstdAssessedVal := FieldByName('HstdTotalVal').AsFloat;

      RPSExtractStrCat(ClassRec, 'H');  {40-40}
      RPSExtractStrCat(ClassRec, Take(1, FieldByName('HstdStatusCode').Text));  {41-41}
      RPSExtractStrCat(ClassRec, FormatRPSNumericString(FieldByName('HstdAcres').Text, 7, 2)); {42-48}

        {FXX03031998-11: Land and total % were switched in RPS layout docs
                         compared to real file.}
        {FXX03031998-12: The percents are decimal in RPS, so need to divide
                         by 100 to be compatible.}

      TempReal := FieldByName('HstdLandPercent').AsFloat / 100;
      RPSExtractStrCat(ClassRec, FormatRPSNumericString(FloatToStr(TempReal), 3, 2)); {52-54}

      TempReal := FieldByName('HstdTotalPercent').AsFloat / 100;
      RPSExtractStrCat(ClassRec, FormatRPSNumericString(FloatToStr(TempReal), 3, 2)); {49-51}

      RPSExtractStrCat(ClassRec, FormatRPSNumericString(FloatToStr(_2ndPriorHstdLandVal), 12, 0));  {55-66}
      RPSExtractStrCat(ClassRec, FormatRPSNumericString(FloatToStr(_2ndPriorHstdAssessedVal), 12, 0));  {67-78}
      RPSExtractStrCat(ClassRec, FormatRPSNumericString(FloatToStr(PriorHstdLandVal), 12, 0));  {79-90}
      RPSExtractStrCat(ClassRec, FormatRPSNumericString(FloatToStr(PriorHstdAssessedVal), 12, 0));  {91-102}
      RPSExtractStrCat(ClassRec, FormatRPSNumericString(FloatToStr(CurrentHstdLandVal), 12, 0)); {103-114}
      RPSExtractStrCat(ClassRec, FormatRPSNumericString(FloatToStr(CurrentHstdAssessedVal), 12, 0)); {115-126}
      RPSExtractStrCat(ClassRec, FormatRPSNumericString(FieldByName('HstdEqualInc').Text, 12, 0)); {127-138}
      RPSExtractStrCat(ClassRec, FormatRPSNumericString(FieldByName('HstdEqualDec').Text, 12, 0)); {139-150}
      RPSExtractStrCat(ClassRec, FormatRPSNumericString(FieldByName('HstdPhysQtyInc').Text, 12, 0)); {151-162}
      RPSExtractStrCat(ClassRec, FormatRPSNumericString(FieldByName('HstdPhysQtyDec').Text, 12, 0)); {163-174}
      RPSExtractStrCat(ClassRec, ShiftRightAddZeroes(Take(12, '')));  {175-186}
      RPSExtractStrCat(ClassRec, ShiftRightAddZeroes(Take(12, '')));  {187-198}
      RPSExtractStrCat(ClassRec, FormatRPSNumericString(FieldByName('HstdImpactVal').Text, 12, 0)); {199-210}
      RPSExtractStrCat(ClassRec, FormatRPSNumericString(FieldByName('HstdHoldPriorVal').Text, 12, 0)); {211-222}

        {Figure out the 4 taxable values.}

      If ParcelIsActive(ParcelTable)
        then TempNum := HstdAssessedVal - HstdExAmounts[ExCounty]
        else TempNum := 0;
      RPSExtractStrCat(ClassRec, FormatRPSNumericString(FloatToStr(TempNum), 12, 0)); {223-234}

      If ParcelIsActive(ParcelTable)
        then TempNum := HstdAssessedVal - HstdExAmounts[ExTown]
        else TempNum := 0;
      RPSExtractStrCat(ClassRec, FormatRPSNumericString(FloatToStr(TempNum), 12, 0)); {235-246}

      If ParcelIsActive(ParcelTable)
        then TempNum := HstdAssessedVal - HstdExAmounts[ExSchool]
        else TempNum := 0;
      RPSExtractStrCat(ClassRec, FormatRPSNumericString(FloatToStr(TempNum), 12, 0)); {247-258}

      If ParcelIsActive(ParcelTable)
        then TempNum := HstdAssessedVal - HstdExAmounts[ExVillage]
        else TempNum := 0;
      RPSExtractStrCat(ClassRec, FormatRPSNumericString(FloatToStr(TempNum), 12, 0)); {259-270}

        {Since we already have the exemptions, just go through the list to
         see what the aged totals are.}

      CountyAgedTotal := 0;
      SchoolAgedTotal := 0;
      VillageAgedTotal := 0;

      For I := 0 to (ExemptionCodes.Count - 1) do
        If ((Take(4, ExemptionCodes[I]) = '4180') and
            (ExemptionHomesteadCodes[I] = 'H'))
          then
            begin
              CountyAgedTotal := CountyAgedTotal + StrToFloat(CountyExemptionAmounts[I]);
              SchoolAgedTotal := SchoolAgedTotal + StrToFloat(SchoolExemptionAmounts[I]);
              VillageAgedTotal := VillageAgedTotal + StrToFloat(VillageExemptionAmounts[I]);

            end;  {If ((Take(4, ExemptionCode[I]) = '4180') and ...}

      RPSExtractStrCat(ClassRec, FormatRPSNumericString(FloatToStr(CountyAgedTotal), 9, 0)); {271-279}
      RPSExtractStrCat(ClassRec, FormatRPSNumericString(FloatToStr(SchoolAgedTotal), 9, 0)); {280-288}
      RPSExtractStrCat(ClassRec, FormatRPSNumericString(FloatToStr(VillageAgedTotal), 9, 0)); {289-297}

          {Now the nonhstd section.}
          {FXX03031998-13: Had hstd total % instead of val.}

      NonhstdAssessedVal := FieldByName('NonhstdTotalVal').AsFloat;

      RPSExtractStrCat(ClassRec, 'N');  {298-298}

        {FXX03031998-14: For some reason, the non homestead status code
                         was not being filled in, so we will just use
                         the homestead status code since it must be the
                         same.}

      RPSExtractStrCat(ClassRec, Take(1, FieldByName('HstdStatusCode').Text));  {299-299}
      RPSExtractStrCat(ClassRec, FormatRPSNumericString(FieldByName('NonhstdAcres').Text, 7, 2)); {300-306}

        {FXX03031998-11: Land and total % were switched in RPS layout docs
                         compared to real file.}
        {FXX03031998-12: The percents are decimal in RPS, so need to divide
                         by 100 to be compatible.}

      TempReal := FieldByName('NonhstdLandPercent').AsFloat / 100;
      RPSExtractStrCat(ClassRec, FormatRPSNumericString(FloatToStr(TempReal), 3, 2)); {52-54}

      TempReal := FieldByName('NonhstdTotalPercent').AsFloat / 100;
      RPSExtractStrCat(ClassRec, FormatRPSNumericString(FloatToStr(TempReal), 3, 2)); {49-51}

      RPSExtractStrCat(ClassRec, FormatRPSNumericString(FloatToStr(_2ndPriorNonhstdLandVal), 12, 0));  {313-324}
      RPSExtractStrCat(ClassRec, FormatRPSNumericString(FloatToStr(_2ndPriorNonhstdAssessedVal), 12, 0));  {325-336}
      RPSExtractStrCat(ClassRec, FormatRPSNumericString(FloatToStr(PriorNonhstdLandVal), 12, 0));  {337-348}
      RPSExtractStrCat(ClassRec, FormatRPSNumericString(FloatToStr(PriorNonhstdAssessedVal), 12, 0));  {349-360}
      RPSExtractStrCat(ClassRec, FormatRPSNumericString(FloatToStr(CurrentNonhstdLandVal), 12, 0)); {361-372}
      RPSExtractStrCat(ClassRec, FormatRPSNumericString(FloatToStr(CurrentNonhstdAssessedVal), 12, 0)); {373-384}
      RPSExtractStrCat(ClassRec, FormatRPSNumericString(FieldByName('NonhstdEqualInc').Text, 12, 0)); {385-396}
      RPSExtractStrCat(ClassRec, FormatRPSNumericString(FieldByName('NonhstdEqualDec').Text, 12, 0)); {397-408}
      RPSExtractStrCat(ClassRec, FormatRPSNumericString(FieldByName('NonhstdPhysQtyInc').Text, 12, 0)); {409-420}
      RPSExtractStrCat(ClassRec, FormatRPSNumericString(FieldByName('NonhstdPhysQtyDec').Text, 12, 0)); {421-432}
      RPSExtractStrCat(ClassRec, ShiftRightAddZeroes(Take(12, '')));  {433-444}
      RPSExtractStrCat(ClassRec, ShiftRightAddZeroes(Take(12, '')));  {445-456}
      RPSExtractStrCat(ClassRec, FormatRPSNumericString(FieldByName('NonhstdImpactVal').Text, 12, 0)); {457-468}
      RPSExtractStrCat(ClassRec, FormatRPSNumericString(FieldByName('NonhstdHoldPriorVal').Text, 12, 0)); {469-480}

        {Figure out the 4 taxable values.}

      If ParcelIsActive(ParcelTable)
        then TempNum := NonhstdAssessedVal - NonhstdExAmounts[ExCounty]
        else TempNum := 0;
      RPSExtractStrCat(ClassRec, FormatRPSNumericString(FloatToStr(TempNum), 12, 0)); {481-492}

      If ParcelIsActive(ParcelTable)
        then TempNum := NonhstdAssessedVal - NonhstdExAmounts[ExTown]
        else TempNum := 0;
      RPSExtractStrCat(ClassRec, FormatRPSNumericString(FloatToStr(TempNum), 12, 0)); {493-504}

      If ParcelIsActive(ParcelTable)
        then TempNum := NonhstdAssessedVal - NonhstdExAmounts[ExSchool]
        else TempNum := 0;
      RPSExtractStrCat(ClassRec, FormatRPSNumericString(FloatToStr(TempNum), 12, 0)); {505-516}

      If ParcelIsActive(ParcelTable)
        then TempNum := NonhstdAssessedVal - NonhstdExAmounts[ExVillage]
        else TempNum := 0;
      RPSExtractStrCat(ClassRec, FormatRPSNumericString(FloatToStr(TempNum), 12, 0)); {517-528}

        {Since we already have the exemptions, just go through the list to
         see what the aged totals are.}

      CountyAgedTotal := 0;
      SchoolAgedTotal := 0;
      VillageAgedTotal := 0;

      For I := 0 to (ExemptionCodes.Count - 1) do
        If ((Take(4, ExemptionCodes[I]) = '4180') and
            (ExemptionHomesteadCodes[I] = 'N'))
          then
            begin
              CountyAgedTotal := CountyAgedTotal + StrToFloat(CountyExemptionAmounts[I]);
              SchoolAgedTotal := SchoolAgedTotal + StrToFloat(SchoolExemptionAmounts[I]);
              VillageAgedTotal := VillageAgedTotal + StrToFloat(VillageExemptionAmounts[I]);

            end;  {If ((Take(4, ExemptionCode[I]) = '4180') and ...}

      RPSExtractStrCat(ClassRec, FormatRPSNumericString(FloatToStr(CountyAgedTotal), 9, 0)); {529-537}
      RPSExtractStrCat(ClassRec, FormatRPSNumericString(FloatToStr(SchoolAgedTotal), 9, 0)); {538-546}
      RPSExtractStrCat(ClassRec, FormatRPSNumericString(FloatToStr(VillageAgedTotal), 9, 0)); {547-555}

    end;  {with ClassTable do}

  RPSExtractStrCat(ClassRec, Take(255, ''));
  RPSExtractStrCat(ClassRec, Take(10, ''));

  If (ProcessingType = ThisYear)
    then RPSExtractStrCat(ClassRec, '24')
    else RPSExtractStrCat(ClassRec, '44');

  ExemptionCodes.Free;
  ExemptionHomesteadCodes.Free;
  ResidentialTypes.Free;
  CountyExemptionAmounts.Free;
  TownExemptionAmounts.Free;
  SchoolExemptionAmounts.Free;
  VillageExemptionAmounts.Free;

end;  {ExtractClassRecord}

{==============================================================================}
Procedure MarkLastRecordForParcel(ParcelExtractRecs,
                                  ClassExtractRecs,
                                  EXExtractRecs,
                                  SDExtractRecs,
                                  ResInventoryRecords,
                                  ComInventoryRecords : TList);

{Put a '999' in positions 37-39 of the last record (i.e. print order -
 which is the order they are passed in) for this parcel.}

var
  Index : Integer;
  RecMarked : Boolean;

begin
  RecMarked := False;

  If (ComInventoryRecords.Count > 0)
    then
      begin
        RecMarked := True;
        Index := ComInventoryRecords.Count - 1;

        PRPSExtractRec(ComInventoryRecords[Index])^[37] := '9';
        PRPSExtractRec(ComInventoryRecords[Index])^[38] := '9';
        PRPSExtractRec(ComInventoryRecords[Index])^[39] := '9';

      end;  {If (ComInventory.Count > 0)}

  If ((not RecMarked) and
      (ResInventoryRecords.Count > 0))
    then
      begin
        RecMarked := True;
        Index := ResInventoryRecords.Count - 1;

        PRPSExtractRec(ResInventoryRecords[Index])^[37] := '9';
        PRPSExtractRec(ResInventoryRecords[Index])^[38] := '9';
        PRPSExtractRec(ResInventoryRecords[Index])^[39] := '9';

      end;  {If (ResInventory.Count > 0)}


  If ((not RecMarked) and
      (SDExtractRecs.Count > 0))
    then
      begin
        RecMarked := True;
        Index := SDExtractRecs.Count - 1;

        PRPSExtractRec(SDExtractRecs[Index])^[37] := '9';
        PRPSExtractRec(SDExtractRecs[Index])^[38] := '9';
        PRPSExtractRec(SDExtractRecs[Index])^[39] := '9';

      end;  {If (SDExtractRecs.Count > 0)}

  If ((not RecMarked) and
      (EXExtractRecs.Count > 0))
    then
      begin
        RecMarked := True;
        Index := EXExtractRecs.Count - 1;

        PRPSExtractRec(EXExtractRecs[Index])^[37] := '9';
        PRPSExtractRec(EXExtractRecs[Index])^[38] := '9';
        PRPSExtractRec(EXExtractRecs[Index])^[39] := '9';

      end;  {If (EXExtractRecs.Count > 0)}

  If ((not RecMarked) and
      (ClassExtractRecs.Count > 0))
    then
      begin
        RecMarked := True;
        Index := ClassExtractRecs.Count - 1;

        PRPSExtractRec(ClassExtractRecs[Index])^[37] := '9';
        PRPSExtractRec(ClassExtractRecs[Index])^[38] := '9';
        PRPSExtractRec(ClassExtractRecs[Index])^[39] := '9';

      end;  {If (ClassExtractRecs.Count > 0)}

  If ((not RecMarked) and
      (ParcelExtractRecs.Count > 0))
    then
      begin
        Index := ParcelExtractRecs.Count - 1;

        PRPSExtractRec(ParcelExtractRecs[Index])^[37] := '9';
        PRPSExtractRec(ParcelExtractRecs[Index])^[38] := '9';
        PRPSExtractRec(ParcelExtractRecs[Index])^[39] := '9';

      end;  {If (ParcelExtractRecs.Count > 0)}

end;  {MarkLastRecordForParcel}


end.