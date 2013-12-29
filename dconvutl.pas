unit Dconvutl;

interface

Uses  SysUtils, WinTypes, WinProcs, Messages, Classes, DB, DBTables,
      Utilitys,WinUtils,GlblVars,PASUTILS, UTILEXSD, PasTypes, GlblCnst,
      Types, Dialogs;

var
  SalesExtractFile, ParcelExtractFile,
  AssessmentExtractFile, ClassExtractFile,
  ExemptionExtractFile, SpecialDistrictExtractFile,
  ResidentialSiteExtractFile, ResidentialBuildingExtractFile,
  ResidentialImprovementExtractFile, ResidentialLandExtractFile,
  CommercialSiteExtractFile, CommercialBuildingExtractFile,
  CommercialImprovementExtractFile, CommercialLandExtractFile,
  CommercialRentExtractFile, CommercialIncomeExpenseExtractFile,
  SalesResidentialSiteExtractFile, SalesResidentialBuildingExtractFile,
  SalesResidentialImprovementExtractFile, SalesResidentialLandExtractFile,
  SalesCommercialSiteExtractFile, SalesCommercialBuildingExtractFile,
  SalesCommercialImprovementExtractFile, SalesCommercialLandExtractFile,
  SalesCommercialRentExtractFile, SalesCommercialIncomeExpenseExtractFile : TextFile;
  ExtractSalesToFile, ExtractAllData : Boolean;

const
  ComBasementTypeTableName = 'ZInvComBasementTbl';
  ResBasementTypeTableName = 'ZInvResBasementTbl';
  BuildingStyleTableName = 'ZInvBuildStyleTbl';
  ExteriorWallTableName = 'ZInvExteriorWallTbl';
  FuelTypeTableName = 'ZInvFuelTbl';
  HeatTypeTableName = 'ZInvHeatTbl';
  PorchTypeTableName = 'ZInvPorchTypeTbl';
  QualityTableName = 'ZInvQualityTbl';
  MeasurementTableName = 'ZInvMeasurementTbl';
  StructureTableName = 'ZInvStructureTbl';
  InfluenceTableName = 'ZInvInfluenceTbl';
  LandTypeTableName = 'ZInvLandTypeTbl';
  SoilRatingTableName = 'ZInvSoilRatingTbl';
  WaterfrontTypeTableName = 'ZInvWtrfrntTypeTbl';
  ElevationTableName = 'ZInvElevationCodeTbl';
  EntryTableName = 'ZInvEntryCodeTbl';
  NeighborhoodTableName = 'ZInvNghbrhdCodeTbl';
  NeighborhoodRatingTableName = 'ZInvNghbrhdRatingTbl';
  NeighborhoodTypeTableName = 'ZInvNghbrhdTypeTbl';
  PhysicalChangeTableName = 'ZInvPhysicalChgTbl';
  PropertyClassTableName = 'ZPropClsTbl';
  RoadTableName = 'ZInvRoadTypeTbl';
  SewerTableName = 'ZInvSewerTbl';

      {FXX01211998-3: The site desirability codes are different for
                      commercial and residential.}

  ComSiteDesirabilityTableName = 'ZInvComSiteDesireTbl';
  ResSiteDesirabilityTableName = 'ZInvResSiteDesireTbl';
  TrafficTableName = 'ZInvTrafficCodeTbl';
  UtilityTableName = 'ZInvUtilityTbl';
  WaterTableName = 'ZInvWaterTbl';
  ZoningTableName = 'ZInvZoningCodeTbl';
  ConditionTableName = 'ZInvConditionTbl';
  GradeTableName = 'ZInvGradeTbl';
  ForestRegionTableName = 'ZInvForestRegionTbl';   {LLL3}
  ForestTypeTableName = 'ZInvForestTypeTbl';   {LLL3}
  LoggingEaseTableName = 'ZInvLoggingEaseTbl';   {LLL3}
  AccessibilityTableName = 'ZInvAccessibilityTbl';   {LLL3}
  NominalValueTableName = 'ZInvNominalValueTbl';   {LLL3}
  SiteClassTableName = 'ZInvSiteClassTbl';   {LLL3}
  CutClassTableName = 'ZInvCutClassTbl';   {LLL3}
  VolAcreClassTableName = 'ZInvVolAcreClassTbl';   {LLL3}
  UsedAsTableName = 'ZInvUsedAsTbl';
  BoeckhModelTableName = 'ZInvBoeckhModelTbl';
  ConstructionQualityTableName = 'ZInvConstQualTbl';
  AppDepTableName = 'ZInvAppDepTbl';
  DataUseTableName = 'ZInvDataUseTbl';
  ExpenseTableName = 'ZInvExpenseTbl';
  InvestmentSetTableName = 'ZInvInvestmentSetTbl';
  RentTypeTableName = 'ZInvRentTypeTbl';
  UnitTableName = 'ZInvUnitTbl';
  ValuationDistTableName = 'ZInvValuationDistTbl';

Procedure WriteInformationToExtractFile(var ExtractFile : TextFile;
                                            Table : TTable);

Function GetField(ItemLen,Start,Stop : Integer;
		  SourceStr : RPSImportRec) : String;
{Get one field from the extract record based on the length, start and stop position.}

Function ConvYYDate(X,Y : Integer;
                    ReadBuff : RPSImportRec) : String;
{Convert from MMDDYY format to YYYYMMDD format.}

Function ConvNumTo2Dec(Len,X,Y : Integer;
                        ReadBuff : RPSImportRec) : String;
{Given a starting and ending position in the extract buffer, get the number and
 assume the last 2 places are actually after the decimal point.}

Function ConvNumToDec(Len,X,Y : Integer;
                      ReadBuff : RPSImportRec) : String;
{Given a starting and ending position in the extract buffer, get the number and
 assume the last place is actually after the decimal point.}

Function MoveStateToStateField(var CityFld : String) : String;

{Look through the city field to see if the state is in it. If so, take it out of
 the city field and return it.}

{INVENTORY PROCEDURES}
{We will preload all the codes into code lists for quicker load and saving of resources
 (i.e. we don't need a table for each code.}

Function SetDescription(    RecordNo : LongInt;  {In case of an error.}
                            Code : String;
                            List : TList;
                        var ErrorLog : Text) : String;
{Look through the list for the code if it is non blank. Return the description
 for this code. If we can not find the code, then we will put a message in the
 error file.}

Procedure LoadCodeTableLists(CodeTable : TTable);
{Load in all the codes and descriptions needed for inventory data conversion.}

Procedure OpenInventoryTables(ResidentialSiteTable,
                              ResidentialBldgTable,
                              ResidentialImprovementsTable,
                              ResidentialLandTable,
                              ResidentialForestTable,
                              CommercialSiteTable,
                              CommercialBldgTable,
                              CommercialImprovementsTable,
                              CommercialLandTable,
                              CommercialRentTable,
                              CommercialIncomeExpenseTable : TTable;
                              ProcessingType : Integer);
{Open a set of inventory tables for a processing type.}

Procedure CloseInventoryTables(ResidentialSiteTable,
                               ResidentialBldgTable,
                               ResidentialImprovementsTable,
                               ResidentialLandTable,
                               ResidentialForestTable,
                               CommercialSiteTable,
                               CommercialBldgTable,
                               CommercialImprovementsTable,
                               CommercialLandTable,
                               CommercialRentTable,
                               CommercialIncomeExpenseTable : TTable);
{Close a set of inventory tables for a processing type.}

Procedure AddCommercialUseRecord(    ThisYearParcelTable,
                                     ThisYearTable,
                                     NextYearTable,
                                     SalesTable : TTable;
                                     ReadBuff : RPSImportRec;
                                     Base,
                                     Offset,
                                     SalesNumber : Integer;
                                     RecordNo : LongInt;
                                     CopyToNextYear : Boolean;
                                 var ErrorLog : Text);
{Extract the information for one commercial use record and insert it in the commercial
 use table.}

Procedure AddCommercialIncomeExpenseRecord(    ThisYearParcelTable,
                                               ThisYearTable,
                                               NextYearTable,
                                               SalesTable : TTable;
                                               ReadBuff : RPSImportRec;
                                               SalesNumber : Integer;
                                               RecordNo : LongInt;
                                               CopyToNextYear : Boolean;
                                           var ErrorLog : Text);
{Extract the information for one commercial bldg record and insert it in the commercial
 bldg table.}

Procedure AddResidentialForestRecord(    ThisYearParcelTable,
                                         ThisYearTable,
                                         NextYearTable,
                                         SalesTable : TTable;
                                         ReadBuff : RPSImportRec;
                                         Base,
                                         Offset,
                                         SalesNumber : Integer;
                                         RecordNo : LongInt;
                                         CopyToNextYear : Boolean;
                                     var ErrorLog : Text);
{Extract the information for one residential forest record and insert it in the residential
 forest table.}

Procedure AddLandRecord(    ThisYearParcelTable,
                            ThisYearTable,
                            NextYearTable,
                            SalesTable : TTable;
                            ReadBuff : RPSImportRec;
                            Base,
                            Offset : Integer;
                            SalesNumber : Integer;
                            RecordNo : LongInt;
                            CopyToNextYear : Boolean;
                            Residential : Boolean;
                        var ErrorLog : Text);
{Extract the information for one land record and insert it in the land table.}
{Note that the land record layout is identical between residential and commercial, so we are
 using the same procedure for each by passing in the table.}

Procedure AddImprovementRecord(    ThisYearParcelTable,
                                   ThisYearTable,
                                   NextYearTable,
                                   SalesTable : TTable;
                                   ReadBuff : RPSImportRec;
                                   Base,
                                   Offset,
                                   SalesNumber : Integer;
                                   RecordNo : LongInt;
                                   CopyToNextYear : Boolean;
                                   Residential : Boolean;
                               var ErrorLog : Text);
{Extract the information for one improvement record and insert it in the improvement table.}
{Note that the improvement record layout is identical between residential and commercial, so we are
 using the same procedure for each by passing in the table.}

Procedure AddCommercialBldgRecord(    ThisYearParcelTable,
                                      ThisYearTable,
                                      NextYearTable,
                                      SalesTable : TTable;
                                      ReadBuff : RPSImportRec;
                                      Base,
                                      Offset,
                                      SalesNumber : Integer;
                                      RecordNo : LongInt;
                                      CopyToNextYear : Boolean;
                                  var ErrorLog : Text);
{Extract the information for one commercial income expense record and insert it in
 the commercial income expense table.}

Procedure AddCommercialSite(    ThisYearParcelTable,
                                ThisYearTable,
                                NextYearTable,
                                SalesTable : TTable;
                                ReadBuff : RPSImportRec;
                                SalesNumber : Integer;
                                RecordNo : LongInt;
                            var TYSiteCount,
                                NYSiteCount,
                                SalesSiteCount : LongInt;
                                CopyToNextYear : Boolean;
                            var ErrorLog : Text);
{Extract the information for one commercial site record and insert it in the
 commercial site table.}

Procedure AddResidentialBuilding(    ThisYearParcelTable,
                                     ThisYearTable,
                                     NextYearTable,
                                     SalesTable : TTable;
                                     ReadBuff : RPSImportRec;
                                     SalesNumber : Integer;
                                     RecordNo : LongInt;
                                     CopyToNextYear : Boolean;
                                 var ErrorLog : Text);
{Extract the information for one residential bldg record and insert it in the
 residential bldg table.}

Procedure AddResidentialSite(    ThisYearParcelTable,
                                 ThisYearTable,
                                 NextYearTable,
                                 SalesTable : TTable;
                                 ReadBuff : RPSImportRec;
                                 SalesNumber : Integer;
                                 RecordNo : LongInt;
                             var TYSiteCount,
                                 NYSiteCount,
                                 SalesSiteCount : LongInt;
                                 CopyToNextYear : Boolean;
                             var ErrorLog : Text);
{Extract the information for one residential site record and insert it in the
 residential site table.}

Procedure FreeCodeTableLists;
{Free up the code table lists that we have loaded.}


implementation



const
  CodeDescriptionFieldLen = 20;
  UnitName = 'UTILCONV.PAS';

var
  ComBasementTypeList, ResBasementTypeList, BuildingStyleList, ExteriorWallList, FuelTypeList,
  HeatTypeList, PorchTypeList, QualityList, MeasurementList,
  StructureList, InfluenceList, LandTypeList, SoilRatingList,
  WaterfrontTypeList, ElevationList, EntryList, NeighborhoodList,
  NeighborhoodRatingList, NeighborhoodTypeList, PhysicalChangeList, PropertyClassList,
  RoadList, SewerList, ComSiteDesirabilityList,
  ResSiteDesirabilityList, TrafficList,
  UtilityList, WaterList, ZoningList, ConditionList, GradeList,
  ForestRegionList, ForestTypeList, LoggingEaseList,
  AccessibilityList, NominalValueList, SiteClassList,
  CutClassList, VolAcreClassList, UsedAsList, BoeckhModelList,
  AppDepList, DataUseList, ExpenseList, InvestmentSetList,
  ConstructionQualityList, RentTypeList, UnitList, ValuationDistList : TList;

{=================================================================}
Procedure WriteInformationToExtractFile(var ExtractFile : TextFile;
                                            Table : TTable);

var
  TempStr : String;
  I : Integer;

begin
  with Table do
    For I := 0 to (FieldCount - 1) do
      begin
        TempStr := FormatExtractField(FieldByName(Fields[I].FieldName).Text);

        If (I = 0)
          then System.Delete(TempStr, 1, 1);

        Write(ExtractFile, TempStr);

      end;  {For I := 0 to (FieldCount - 1) do}

  Writeln(ExtractFile);

end;  {WriteInformationToExtractFile}

{============================================================================}
Function GetField(ItemLen,Start,Stop : Integer;
		  SourceStr : RPSImportRec) : String;

{Get one field from the extract record based on the length, start and stop position.}


var
  OneChar : Char;
  I, TargetPointer, Llen : Integer;
  Target : String;

begin
  TargetPointer := 1;         {start with first position of target}

  Target := Take(ItemLen, Target);

  For I := Start to Stop do
    begin
      OneChar := SourceStr[I];  {get one char from source field}
      Target[TargetPointer] := OneChar;{to target field}
      TargetPointer := TargetPointer +1;
    end;

  GetField := Target; { Set Function value...}

end;  {GetField}

{=================================================================}
Function ConvYYDate(X,Y : Integer;
                    ReadBuff : RPSImportRec) : String;

{Convert from MMDDYY format to YYYYMMDD format.}

var
  FullDate : String;
  TempStr,
  TempStr2 : String;
  I : Integer;

begin
  FullDate := Take(8,' ');
  TempStr2 := GetField(2, (X+4), (X+5), ReadBuff); {get 2 digit yr}

    {FXX11021998-1: Make sure that we don't have Y2K problem. Assume anything with
                    year under 20 is 21st century.}

  If (StrToInt(TempStr2) < 20)
    then TempStr := '20  '
    else TempStr := '19  ';

   For I := 1 to 2 do
     TempStr[I+2] := TempStr2[I]; {insert last 2 digs of yr}

                   {YYYY}             {MMDD}
   FullDate := Take(4, TempStr) + GetField(4, X, Y, ReadBuff);

   ConvYYDate := Take(8, FullDate);

end;  {ConvYYDate}

{=================================================================}
 Function ConvNumTo2Dec(Len,X,Y : Integer;
                        ReadBuff : RPSImportRec) : String;

{Given a starting and ending position in the extract buffer, get the number and
 assume the last 2 places are actually after the decimal point.}

var
  TempStr2, TempStr : String;
  Temp : Real;
  I : Integer;

begin
  TempStr := GetField(Len,X,Y,ReadBuff);

  try
    Temp := StrToFloat(TempStr);
  except
    Temp := 0;
  end;

  Temp := Temp/100;
  Temp := RoundOff(Temp, 2);
  TempStr := Take((Len+1),' ');
  TempStr := Take((Len+1),FloatToStr(Temp));
  TempStr2 := Take((Len+1),Tempstr);
  ConvNumTo2Dec := Take((Len+1),Tempstr);

end;  {ConvNumTo2Dec}

{=================================================================}
Function ConvNumToDec(Len,X,Y : Integer;
                      ReadBuff : RPSImportRec) : String;

{Given a starting and ending position in the extract buffer, get the number and
 assume the last place is actually after the decimal point.}

var
  TempStr : String;
  Temp : Real;
  I : Integer;

begin
  TempStr := GetField(Len,X,Y,ReadBuff);

  try
    Temp := StrToFloat(TempStr);
  except
    Temp := 0;
  end;

  TempStr := Take( (Len),' ');
  TempStr := Take( (Len),FloatToStr(Temp));

  ConvNumToDec := Take( (Len),Tempstr);

end;  {ConvNumToDec}

{=================================================================}
Function MoveStateToStateField(var CityFld : String) : String;

{Look through the city field to see if the state is in it. If so, take it out of
 the city field and return it.}

var
  I, J :Integer;
  Done : Boolean;
  St : String;

begin
  Done := False;
  I := 25;
  CityFld := Take(25,CityFld);
  St := '';

  repeat
    If (Deblank(CityFld[I]) = '')
      then I := I - 1
      else
        begin
          If (I >=3)  {dont run off start of buffer}
                AND
         {if find 2 chars with blank preceding them, assume it is}
         {a state code}
    (Deblank(CityFld[I-1]) <> '')
        AND
    (Deblank(CityFld[I-2])  =  '')

           AND
    (  ((CityFld[I]) >= 'A')
           AND
       ((CityFld[I]) <= 'Z')
    )
           AND
    (  ((CityFld[I-1]) >= 'A')
           AND
       ((CityFld[I-1]) <= 'Z')
    )

        then
        begin
        St := Take(2,' ');
        I := I -1;
        St[1] := CityFld[I];
        St[2] := CityFld[I+1];
        CityFld[I] := ' ';     {clear state abbrev from city field}
        CityFld[I+1] := ' ';
        Done := True;
        end
        else done := True;  {give up anyway}

   end;
  Until (I <= 1) Or (Done);

  MoveStateToStateField := Take(2,St);

end;  {MoveStateToStateField}

{====================================================================================}
{=========================== INVENTORY SPECIFIC UTILITIES ===========================}
{====================================================================================}
{====================================================================================}
Function SetDescription(    RecordNo : LongInt;  {In case of an error.}
                            Code : String;
                            List : TList;
                        var ErrorLog : Text) : String;

{Look through the list for the code if it is non blank. Return the description
 for this code. If we can not find the code, then we will put a message in the
 error file.}

var
  I : Integer;
  Found : Boolean;
  TempStr : String;

begin
  I := 0;
  Found := False;
  Code := Take(10, Code);
  Result := '';

  If ((Deblank(Code) <> '') and
      (Deblank(DezeroOnLeft(Code)) <> ''))
    then
      while ((I <= (List.Count - 1)) and (not Found)) do
        begin
          TempStr := PCodeRecord(List[I])^.Code;

          If (Take(10, TempStr) = Take(10, Code))
            then
              begin
                Result := PCodeRecord(List[I])^.Description;
                Found := True;
              end;

          I := I + 1;

        end;  {while ((I <= List.Count - 1) and (not Found)) do}

  If ((not Found) and
      (Deblank(Code) <> '') and
      (Deblank(DezeroOnLeft(Code)) <> ''))
    then
      begin
        If (List.Count > 0)
          then TempStr := PCodeRecord(List[0])^.CodeTableName
          else TempStr := 'Unknown';

        Writeln(ErrorLog, 'Could not find code ' + Code + '. Record = ' + IntToStr(RecordNo),
                  '. TableName = ' + TempStr);

      end;

  Result := Take(CodeDescriptionFieldLen, Result);

end;  {SetDescription}

{======================================================================}
Procedure LoadCodeTableLists(CodeTable : TTable);

{Load in all the codes and descriptions needed for inventory data conversion.}

var
  Quit : Boolean;

begin
  Quit := False;

  ComBasementTypeList := TList.Create;
  ResBasementTypeList := TList.Create;
  BuildingStyleList := TList.Create;
  ExteriorWallList := TList.Create;
  FuelTypeList := TList.Create;
  HeatTypeList := TList.Create;
  PorchTypeList := TList.Create;
  QualityList := TList.Create;
  MeasurementList := TList.Create;
  StructureList := TList.Create;
  InfluenceList := TList.Create;
  LandTypeList := TList.Create;
  SoilRatingList := TList.Create;
  WaterfrontTypeList := TList.Create;
  ElevationList := TList.Create;
  EntryList := TList.Create;
  NeighborhoodList := TList.Create;
  NeighborhoodRatingList := TList.Create;
  NeighborhoodTypeList := TList.Create;
  PhysicalChangeList := TList.Create;
  PropertyClassList := TList.Create;
  RoadList := TList.Create;
  SewerList := TList.Create;
  ComSiteDesirabilityList := TList.Create;
  ResSiteDesirabilityList := TList.Create;
  TrafficList := TList.Create;
  UtilityList := TList.Create;
  WaterList := TList.Create;
  ZoningList := TList.Create;
  ConditionList := TList.Create;
  GradeList := TList.Create;
  ForestRegionList := TList.Create;
  ForestTypeList := TList.Create;
  LoggingEaseList := TList.Create;
  AccessibilityList := TList.Create;
  NominalValueList := TList.Create;
  SiteClassList := TList.Create;
  CutClassList := TList.Create;
  VolAcreClassList := TList.Create;
  UsedAsList := TList.Create;
  BoeckhModelList := TList.Create;
  ConstructionQualityList := TList.Create;
  AppDepList := TList.Create;
  DataUseList := TList.Create;
  ExpenseList := TList.Create;
  InvestmentSetList := TList.Create;
  UnitList := TList.Create;
  RentTypeList := TList.Create;
  ValuationDistList := TList.Create;

  LoadCodeList(ComBasementTypeList, ComBasementTypeTableName, 'MainCode', 'Description', Quit);
  LoadCodeList(ResBasementTypeList, ResBasementTypeTableName, 'MainCode', 'Description', Quit);
  LoadCodeList(BuildingStyleList, BuildingStyleTableName, 'MainCode', 'Description', Quit);
  LoadCodeList(ExteriorWallList, ExteriorWallTableName, 'MainCode', 'Description', Quit);
  LoadCodeList(FuelTypeList, FuelTypeTableName, 'MainCode', 'Description', Quit);
  LoadCodeList(HeatTypeList, HeatTypeTableName, 'MainCode', 'Description', Quit);
  LoadCodeList(PorchTypeList, PorchTypeTableName, 'MainCode', 'Description', Quit);
  LoadCodeList(QualityList, QualityTableName, 'MainCode', 'Description', Quit);
  LoadCodeList(MeasurementList, MeasurementTableName, 'MainCode', 'Description', Quit);
  LoadCodeList(StructureList, StructureTableName, 'MainCode', 'Description', Quit);
  LoadCodeList(InfluenceList, InfluenceTableName, 'MainCode', 'Description', Quit);
  LoadCodeList(LandTypeList, LandTypeTableName, 'MainCode', 'Description', Quit);
  LoadCodeList(SoilRatingList, SoilRatingTableName, 'MainCode', 'Description', Quit);
  LoadCodeList(WaterfrontTypeList, WaterfrontTypeTableName, 'MainCode', 'Description', Quit);
  LoadCodeList(ElevationList, ElevationTableName, 'MainCode', 'Description', Quit);
  LoadCodeList(EntryList, EntryTableName, 'MainCode', 'Description', Quit);
  LoadCodeList(NeighborhoodList, NeighborhoodTableName, 'MainCode', 'Description', Quit);
  LoadCodeList(NeighborhoodRatingList, NeighborhoodRatingTableName, 'MainCode', 'Description', Quit);
  LoadCodeList(NeighborhoodTypeList, NeighborhoodTypeTableName, 'MainCode', 'Description', Quit);
  LoadCodeList(PhysicalChangeList, PhysicalChangeTableName, 'MainCode', 'Description', Quit);
  LoadCodeList(PropertyClassList, PropertyClassTableName, 'MainCode', 'Description', Quit);
  LoadCodeList(RoadList, RoadTableName, 'MainCode', 'Description', Quit);
  LoadCodeList(SewerList, SewerTableName, 'MainCode', 'Description', Quit);

      {FXX01211998-3: The site desirability codes are different for
                      commercial and residential.}

  LoadCodeList(ComSiteDesirabilityList, ComSiteDesirabilityTableName, 'MainCode', 'Description', Quit);
  LoadCodeList(ResSiteDesirabilityList, ResSiteDesirabilityTableName, 'MainCode', 'Description', Quit);

  LoadCodeList(TrafficList, TrafficTableName, 'MainCode', 'Description', Quit);
  LoadCodeList(UtilityList, UtilityTableName, 'MainCode', 'Description', Quit);
  LoadCodeList(WaterList, WaterTableName, 'MainCode', 'Description', Quit);
  LoadCodeList(ZoningList, ZoningTableName, 'MainCode', 'Description', Quit);
  LoadCodeList(ConditionList, ConditionTableName, 'MainCode', 'Description', Quit);
  LoadCodeList(GradeList, GradeTableName, 'MainCode', 'Description', Quit);
  LoadCodeList(ForestRegionList, ForestRegionTableName, 'MainCode', 'Description', Quit);
  LoadCodeList(ForestTypeList, ForestTypeTableName, 'MainCode', 'Description', Quit);
  LoadCodeList(LoggingEaseList, LoggingEaseTableName, 'MainCode', 'Description', Quit);
  LoadCodeList(AccessibilityList, AccessibilityTableName, 'MainCode', 'Description', Quit);
  LoadCodeList(NominalValueList, NominalValueTableName, 'MainCode', 'Description', Quit);
  LoadCodeList(SiteClassList, SiteClassTableName, 'MainCode', 'Description', Quit);
  LoadCodeList(CutClassList, CutClassTableName, 'MainCode', 'Description', Quit);
  LoadCodeList(VolAcreClassList, VolAcreClassTableName, 'MainCode', 'Description', Quit);
  LoadCodeList(UsedAsList, UsedAsTableName, 'MainCode', 'Description', Quit);
  LoadCodeList(BoeckhModelList, BoeckhModelTableName, 'MainCode', 'Description', Quit);
  LoadCodeList(ConstructionQualityList, ConstructionQualityTableName, 'MainCode', 'Description', Quit);
  LoadCodeList(AppDepList, AppDepTableName, 'MainCode', 'Description', Quit);
  LoadCodeList(DataUseList, DataUseTableName, 'MainCode', 'Description', Quit);
  LoadCodeList(ExpenseList, ExpenseTableName, 'MainCode', 'Description', Quit);
  LoadCodeList(InvestmentSetList, InvestmentSetTableName, 'MainCode', 'Description', Quit);
  LoadCodeList(UnitList, UnitTableName, 'MainCode', 'Description', Quit);
  LoadCodeList(RentTypeList, RentTypeTableName, 'MainCode', 'Description', Quit);
  LoadCodeList(ValuationDistList, ValuationDistTableName, 'MainCode', 'Description', Quit);

end;  {LoadCodeTables}

{====================================================================================}
Procedure OpenInventoryTables(ResidentialSiteTable,
                              ResidentialBldgTable,
                              ResidentialImprovementsTable,
                              ResidentialLandTable,
                              ResidentialForestTable,
                              CommercialSiteTable,
                              CommercialBldgTable,
                              CommercialImprovementsTable,
                              CommercialLandTable,
                              CommercialRentTable,
                              CommercialIncomeExpenseTable : TTable;
                              ProcessingType : Integer);

{Open a set of inventory tables for a processing type.}

var
  Quit : Boolean;

begin
  Quit := False;

     {Now open the  tables.}

  OpenTableForProcessingType(ResidentialForestTable, ResidentialForestTableName,
                             ProcessingType, Quit);
  OpenTableForProcessingType(ResidentialSiteTable, ResidentialSiteTableName,
                             ProcessingType, Quit);
  OpenTableForProcessingType(ResidentialBldgTable, ResidentialBldgTableName,
                             ProcessingType, Quit);
  OpenTableForProcessingType(ResidentialImprovementsTable, ResidentialImprovementsTableName,
                             ProcessingType, Quit);
  OpenTableForProcessingType(ResidentialLandTable, ResidentialLandTableName,
                             ProcessingType, Quit);
  OpenTableForProcessingType(CommercialSiteTable, CommercialSiteTableName,
                             ProcessingType, Quit);
  OpenTableForProcessingType(CommercialBldgTable, CommercialBldgTableName,
                             ProcessingType, Quit);
  OpenTableForProcessingType(CommercialImprovementsTable, CommercialImprovementsTableName,
                             ProcessingType, Quit);
  OpenTableForProcessingType(CommercialLandTable, CommercialLandTableName,
                             ProcessingType, Quit);
  OpenTableForProcessingType(CommercialRentTable, CommercialRentTableName,
                             ProcessingType, Quit);
  OpenTableForProcessingType(CommercialIncomeExpenseTable, CommercialIncomeExpenseTableName,
                             ProcessingType, Quit);

end;  {OpenInventoryTables}

{====================================================================================}
Procedure CloseInventoryTables(ResidentialSiteTable,
                               ResidentialBldgTable,
                               ResidentialImprovementsTable,
                               ResidentialLandTable,
                               ResidentialForestTable,
                               CommercialSiteTable,
                               CommercialBldgTable,
                               CommercialImprovementsTable,
                               CommercialLandTable,
                               CommercialRentTable,
                               CommercialIncomeExpenseTable : TTable);

{Close a set of inventory tables for a processing type.}

begin
    {Close the inventory tables.}

  ResidentialSiteTable.Close;
  ResidentialBldgTable.Close;
  ResidentialImprovementsTable.Close;
  ResidentialLandTable.Close;
  ResidentialForestTable.Close;
  CommercialSiteTable.Close;
  CommercialBldgTable.Close;
  CommercialImprovementsTable.Close;
  CommercialLandTable.Close;
  CommercialIncomeExpenseTable.Close;
  CommercialRentTable.Close;

end;  {CloseInventoryTables}

{====================================================================================}
Procedure AddResidentialSite(    ThisYearParcelTable,
                                 ThisYearTable,
                                 NextYearTable,
                                 SalesTable : TTable;
                                 ReadBuff : RPSImportRec;
                                 SalesNumber : Integer;
                                 RecordNo : LongInt;
                             var TYSiteCount,
                                 NYSiteCount,
                                 SalesSiteCount : LongInt;
                                 CopyToNextYear : Boolean;
                             var ErrorLog : Text);

{Extract the information for one residential site record and insert it in the
 residential site table.}

var
  E : TObject;
  TempTable : TTable;
  Found : Boolean;
  SwisSBLKey : SBLRecord;
  TaxRollYr : String;

begin
  If (SalesNumber > 0)
    then
      begin
        TempTable := SalesTable;
        SalesSiteCount := SalesSiteCount + 1;
        TaxRollYr := GlblThisYear;  {Tax roll year does not really matter for sales inv.}
      end
    else
      begin
        TempTable := ThisYearTable;
        TYSiteCount := TYSiteCount + 1;
        TaxRollYr := GlblThisYear;

      end;  {else of If (SalesNumber > 0)}

  with TempTable do
    try
        {Insert the residential site.}

      Insert;

      FieldByName('TaxRollYr').Text := Take(4, TaxRollYr);
      FieldByName('SwisSBLKey').Text := GetField(26, 1, 26, ReadBuff);

      try
        FieldByName('Site').AsInteger := StrToInt(GetField(2, 30, 31, ReadBuff));
      except
        FieldByName('Site').AsInteger := 0;
        Writeln(ErrorLog, 'Error in res site record ' + IntToStr(RecordNo) + ' error = ' +
                'No site number.');

      end;

      FieldByName('SalesNumber').AsInteger := SalesNumber;

      FieldByName('PropertyClassCode').Text := GetField(3, 59, 61, ReadBuff);
      FieldByName('PropertyClassDesc').Text := SetDescription(
                                        RecordNo,
                                        FieldByName('PropertyClassCode').Text,
                                        PropertyClassList,
                                        ErrorLog);

      FieldByName('NeighborhoodCode').Text := DezeroOnLeft(GetField(5, 71, 75, ReadBuff));
      FieldByName('NeighborhoodDesc').Text := SetDescription(
                                        RecordNo,
                                        FieldByName('NeighborhoodCode').Text,
                                        NeighborhoodList,
                                        ErrorLog);

      FieldByName('NghbrhdRatingCode').Text := GetField(1, 172, 172, ReadBuff);
      FieldByName('NghbrhdRatingDesc').Text := SetDescription(
                                        RecordNo,
                                        FieldByName('NghbrhdRatingCode').Text,
                                        NeighborhoodRatingList,
                                        ErrorLog);

      FieldByName('NghbrhdTypeCode').Text := GetField(1, 171, 171, ReadBuff);
      FieldByName('NghbrhdTypeDesc').Text := SetDescription(
                                        RecordNo,
                                        FieldByName('NghbrhdTypeCode').Text,
                                        NeighborhoodTypeList,
                                        ErrorLog);

      {FXX01211998-3: The site desirability codes are different for
                      commercial and residential.}

      FieldByName('DesirabilityCode').Text := GetField(1, 84, 84, ReadBuff);
      FieldByName('DesirabilityDesc').Text := SetDescription(
                                        RecordNo,
                                        FieldByName('DesirabilityCode').Text,
                                        ResSiteDesirabilityList,
                                        ErrorLog);

      FieldByName('ZoningCode').Text := GetField(5, 76, 80, ReadBuff);
      FieldByName('ZoningDesc').Text := SetDescription(
                                        RecordNo,
                                        FieldByName('ZoningCode').Text,
                                        ZoningList,
                                        ErrorLog);

      FieldByName('SewerTypeCode').Text := GetField(1, 81, 81, ReadBuff);
      FieldByName('SewerTypeDesc').Text := SetDescription(
                                        RecordNo,
                                        FieldByName('SewerTypeCode').Text,
                                        SewerList,
                                        ErrorLog);

      FieldByName('WaterSupplyCode').Text := GetField(1, 82, 82, ReadBuff);
      FieldByName('WaterSupplyDesc').Text := SetDescription(
                                        RecordNo,
                                        FieldByName('WaterSupplyCode').Text,
                                        WaterList,
                                        ErrorLog);

      FieldByName('RoadTypeCode').Text := GetField(1, 173, 173, ReadBuff);
      FieldByName('RoadTypeDesc').Text := SetDescription(
                                        RecordNo,
                                        FieldByName('RoadTypeCode').Text,
                                        RoadList,
                                        ErrorLog);

      FieldByName('UtilityTypeCode').Text := GetField(1, 83, 83, ReadBuff);
      FieldByName('UtilityTypeDesc').Text := SetDescription(
                                        RecordNo,
                                        FieldByName('UtilityTypeCode').Text,
                                        UtilityList,
                                        ErrorLog);

      FieldByName('D_CEntryTypeCode').Text := GetField(1, 85, 85, ReadBuff);
      FieldByName('D_CEntryTypeDesc').Text := SetDescription(
                                        RecordNo,
                                        FieldByName('D_CEntryTypeCode').Text,
                                        EntryList,
                                        ErrorLog);

      FieldByName('RouteNumber').Text := GetField(9, 62, 70, ReadBuff);

      try
        FieldByName('ReplacementCost').AsFloat := StrToFloat(GetField(12, 111, 122, ReadBuff));
      except
        FieldByName('ReplacementCost').AsFloat := 0;
      end;

      try
        FieldByName('RCNLessDepreciation').AsFloat := StrToFloat(GetField(12, 123, 134, ReadBuff));
      except
        FieldByName('RCNLessDepreciation').AsFloat := 0;
      end;

      try
        FieldByName('LandValue').AsFloat := StrToFloat(GetField(12, 135, 146, ReadBuff));
      except
        FieldByName('LandValue').AsFloat := 0;
      end;

      try
        FieldByName('ModelEstimate').AsFloat := StrToFloat(GetField(12, 147, 158, ReadBuff));
      except
        FieldByName('ModelEstimate').AsFloat := 0;
      end;

      try
        FieldByName('MarketEstimate').AsFloat := StrToFloat(GetField(12, 159, 170, ReadBuff));
      except
        FieldByName('MarketEstimate').AsFloat := 0;
      end;

      try
        FieldByName('FinalLandValue').AsFloat := StrToFloat(GetField(12, 99, 110, ReadBuff));
      except
        FieldByName('FinalLandValue').AsFloat := 0;
      end;

      try
        FieldByName('FinalTotalValue').AsFloat := StrToFloat(GetField(12, 87, 98, ReadBuff));
      except
        FieldByName('FinalTotalValue').AsFloat := 0;
      end;

      FieldByName('LastChangeDate').Text := MakeYYYYMMDDSlashed(ConvYYDate(40,45,ReadBuff));
      FieldByName('MailerSent').AsBoolean := StrToBool_Blank_1(GetField(1, 86, 86, ReadBuff));
      FieldByName('LaserDiskFrameNo').Text := GetField(9, 174, 182, ReadBuff);

        {No RPS fields for these 3 fields.}

      (*FieldByName('Traffic').Text := GetField(, , , ReadBuff);
      FieldByName('Elevation').Text := GetField(, , , ReadBuff);
      FieldByName('PhysicalChange').Text := GetField(, , , ReadBuff);*)

      try
        If ExtractAllData
          then
            begin
              If (SalesNumber > 0)
                then WriteInformationToExtractFile(SalesResidentialSiteExtractFile, TempTable)
                else WriteInformationToExtractFile(ResidentialSiteExtractFile, TempTable);
              Cancel;
            end
          else Post;
      except
        SystemSupport(002, TempTable, 'Error Attempting to Post Res Site Rec',
                      UnitName, GlblErrorDlgBox);
      end;

    except
      E := ExceptObject;
      Writeln(ErrorLog, 'Error in res site record ' + IntToStr(RecordNo) + ' error = ' +
              Exception(E).Message);
    end;

     {If this was a ThisYear inventory record, then copy it to NextYear
      inventory, but only if the parcel is active in ThisYear.}

  If ((SalesNumber = 0) and
      CopyToNextYear)
    then
      begin
(*        SwisSBLKey := ExtractSwisSBLFromSwisSBLKey(ThisYearTable.FieldByName('SwisSBLKey').Text);

        with SwisSBLKey do
          Found := FindKeyOld(ThisYearParcelTable,
                              ['TaxRollYr', 'SwisCode', 'Section',
                               'Subsection', 'Block', 'Lot', 'Sublot'],
                              [GlblThisYear, SwisCode,
                               Section, Subsection,
                               Block, Lot, Sublot, Suffix]);

        If (Found and
            (ThisYearParcelTable.FieldByName('ActiveFlag').Text <> InactiveParcelFlag))
          then
            begin*)
(*              CopyTable_OneRecord(ThisYearTable, NextYearTable,
                                  ['TaxRollYr'], [GlblNextYear]);*)
              NYSiteCount := NYSiteCount + 1;
(*            end;*)

      end;  {If (SalesNumber = 0)}

end;  {AddResidentialSite}

{====================================================================================}
Procedure AddResidentialBuilding(    ThisYearParcelTable,
                                     ThisYearTable,
                                     NextYearTable,
                                     SalesTable : TTable;
                                     ReadBuff : RPSImportRec;
                                     SalesNumber : Integer;
                                     RecordNo : LongInt;
                                     CopyToNextYear : Boolean;
                                 var ErrorLog : Text);

{Extract the information for one residential bldg record and insert it in the
 residential bldg table.}

var
  E : TObject;
  TempTable : TTable;
  Found : Boolean;
  SwisSBLKey : SBLRecord;
  TaxRollYr : String;
  TempStr : String;

begin
  If (SalesNumber > 0)
    then
      begin
        TempTable := SalesTable;
        TaxRollYr := GlblThisYear;  {Tax roll year does not really matter for sales inv.}
      end
    else
      begin
        TempTable := ThisYearTable;
        TaxRollYr := GlblThisYear;

      end;  {else of If (SalesNumber > 0)}

  with TempTable do
    try
        {Insert the residential building.}

      Insert;

      FieldByName('TaxRollYr').Text := Take(4, TaxRollYr);
      FieldByName('SwisSBLKey').Text := GetField(26, 1, 26, ReadBuff);
      FieldByName('Site').AsInteger := StrToInt(GetField(2, 30, 31, ReadBuff));
      FieldByName('SalesNumber').AsInteger := SalesNumber;

        {Sometimes the building style is zero filled when it is blank -
         we don't want to save such a code since there is no building
         style zero.}

      TempStr := GetField(2, 295, 296, ReadBuff);

      If (TempStr <> '00')
        then
          begin
            FieldByName('BuildingStyleCode').Text := GetField(2, 295, 296, ReadBuff);
            FieldByName('BuildingStyleDesc').Text := SetDescription(
                                              RecordNo,
                                              FieldByName('BuildingStyleCode').Text,
                                              BuildingStyleList,
                                              ErrorLog);

          end;

      try
        FieldByName('NumberOfStories').AsFloat := (StrToFloat(GetField(2, 297, 298, ReadBuff)) / 10);
      except
        FieldByName('NumberOfStories').AsFloat := 0;
      end;

      (*FieldByName('NumberOfRooms').AsInteger := StrToInt(GetField(, , , ReadBuff));*)  {Not in 995}

      FieldByName('ExtWallMaterialCode').Text := GetField(2, 299, 300, ReadBuff);
      FieldByName('ExtWallMaterialDesc').Text := SetDescription(
                                        RecordNo,
                                        FieldByName('ExtWallMaterialCode').Text,
                                        ExteriorWallList,
                                        ErrorLog);

      FieldByName('ActualYearBuilt').Text := GetField(4, 301, 304, ReadBuff);

        {FXX11131997-5: Sometimes blank years are being stored as '0000'.}

      If (FieldByName('ActualYearBuilt').Text = '0000')
        then FieldByName('ActualYearBuilt').Text := '';

      try
        FieldByName('NumberOfKitchens').AsInteger := StrToInt(GetField(1, 305, 305, ReadBuff));
      except
        FieldByName('NumberOfKitchens').AsInteger := 0;
      end;

      (*FieldByName('KitchenQuality').Text := GetField(, , , ReadBuff);*)  {Not in RPS}

      try
        FieldByName('NumberOfBathrooms').AsFloat := StrToFloat(GetField(3, 306, 308, ReadBuff)) / 10;
      except
        FieldByName('NumberOfBathrooms').AsFloat := 0;
      end;

      (*FieldByName('BathroomQuality').Text := GetField(, , , ReadBuff);*)  {Not is RPS}

      try
        FieldByName('NumberOfBedrooms').AsInteger := StrToInt(GetField(2, 309, 310, ReadBuff));
      except
        FieldByName('NumberOfBedrooms').AsInteger := 0;
      end;

      try
        FieldByName('NumberOfFireplaces').AsInteger := StrToInt(GetField(2, 311, 312, ReadBuff));
      except
        FieldByName('NumberOfFireplaces').AsInteger := 0;
      end;

      FieldByName('HeatTypeCode').Text := GetField(1, 313, 313, ReadBuff);
      FieldByName('HeatTypeDesc').Text := SetDescription(
                                        RecordNo,
                                        FieldByName('HeatTypeCode').Text,
                                        HeatTypeList,
                                        ErrorLog);

        {Sometimes the fuel type is zero filled when it is blank -
         we don't want to save such a code since there is no fuel type zero.}

      TempStr := GetField(1, 314, 314, ReadBuff);

      If (TempStr <> '0')
        then
          begin
            FieldByName('FuelTypeCode').Text := TempStr;
            FieldByName('FuelTypeDesc').Text := SetDescription(
                                              RecordNo,
                                              FieldByName('FuelTypeCode').Text,
                                              FuelTypeList,
                                              ErrorLog);
          end;

      FieldByName('CentralAir').AsBoolean := StrToBool_Blank_1(GetField(1, 315, 315, ReadBuff));

        {Sometimes the  is zero filled when it is blank -
         we don't want to save such a code since there is no zero.}

      TempStr := GetField(1, 318, 318, ReadBuff);

      If (TempStr <> '0')
        then
          begin
            FieldByName('ConditionCode').Text := TempStr;
            FieldByName('ConditionDesc').Text := SetDescription(
                                              RecordNo,
                                              FieldByName('ConditionCode').Text,
                                              ConditionList,
                                              ErrorLog);
          end;


        {Sometimes the  is zero filled when it is blank -
         we don't want to save such a code since there is no zero.}

      TempStr := GetField(1, 316, 316, ReadBuff);

      If (TempStr <> '0')
        then
          begin
            FieldByName('BasementTypeCode').Text := TempStr;
            FieldByName('BasementTypeDesc').Text := SetDescription(
                                              RecordNo,
                                              FieldByName('BasementTypeCode').Text,
                                              ResBasementTypeList,
                                              ErrorLog);
          end;

      try
        FieldByName('BasementGarCapacity').AsInteger := StrToInt(GetField(1, 317, 317, ReadBuff));
      except
        FieldByName('BasementGarCapacity').AsInteger := 0;
      end;

      try
        FieldByName('AttachedGarCapacity').AsInteger := StrToInt(GetField(1, 328, 328, ReadBuff));
      except
        FieldByName('AttachedGarCapacity').AsInteger := 0;
      end;

      FieldByName('PorchTypeCode').Text := GetField(1, 323, 323, ReadBuff);
      FieldByName('PorchTypeDesc').Text := SetDescription(
                                        RecordNo,
                                        FieldByName('PorchTypeCode').Text,
                                        PorchTypeList,
                                        ErrorLog);

      try
        FieldByName('PorchArea').AsInteger := StrToInt(GetField(4, 324, 327, ReadBuff));
      except
        FieldByName('PorchArea').AsInteger := 0;
      end;

      FieldByName('OverallGradeCode').Text := GetField(1, 319, 319, ReadBuff);
      FieldByName('OverallGradeDesc').Text := SetDescription(
                                        RecordNo,
                                        FieldByName('OverallGradeCode').Text,
                                        GradeList,
                                        ErrorLog);

      try
        FieldByName('FirstStoryArea').AsInteger := StrToInt(GetField(5, 329, 333, ReadBuff));
      except
        FieldByName('FirstStoryArea').AsInteger := 0;
      end;

      try
        FieldByName('SecondStoryArea').AsInteger := StrToInt(GetField(5, 334, 338, ReadBuff));
      except
        FieldByName('SecondStoryArea').AsInteger := 0;
      end;

      try
        FieldByName('ThirdStoryArea').AsInteger := StrToInt(GetField(5, 339, 343, ReadBuff));
      except
        FieldByName('ThirdStoryArea').AsInteger := 0;
      end;

        {FXX02021998-2: When importing 1/2 and 3/4 stories, need to
                        adjust RPS amounts since they are stored as full
                        amounts but displayed as less and the displayed
                        amount is what it should be.}

      try
        FieldByName('HalfStoryArea').AsInteger := Trunc(Roundoff(StrToFloat(GetField(5, 344, 348, ReadBuff)) * 0.5, 0));
      except
        FieldByName('HalfStoryArea').AsInteger := 0;
      end;

      try
        FieldByName('ThreeQuarterStoryAre').AsInteger :=
                    Trunc(Roundoff(StrToFloat(GetField(5, 349, 353, ReadBuff)) * 0.75, 0));
      except
        FieldByName('ThreeQuarterStoryAre').AsInteger := 0;
      end;

      try
        FieldByName('FinishedAreaOverGara').AsInteger := StrToInt(GetField(5, 354, 358, ReadBuff));
      except
        FieldByName('FinishedAreaOverGara').AsInteger := 0;
      end;

      try
        FieldByName('FinishedAtticArea').AsInteger := StrToInt(GetField(5, 359, 363, ReadBuff));
      except
        FieldByName('FinishedAtticArea').AsInteger := 0;
      end;

      try
        FieldByName('FinishedBasementArea').AsInteger := StrToInt(GetField(5, 364, 368, ReadBuff));
      except
        FieldByName('FinishedBasementArea').AsInteger := 0;
      end;

        {FXX02021998-2: When importing 1/2 and 3/4 stories, need to
                        adjust RPS amounts since they are stored as full
                        amounts but displayed as less and the displayed
                        amount is what it should be.}

      try
        FieldByName('UnfinishedHalfStory').AsInteger :=
              Trunc(Roundoff(StrToFloat(GetField(5, 369, 373, ReadBuff)) * 0.5, 0));
      except
        FieldByName('UnfinishedHalfStory').AsInteger := 0;
      end;

      try
        FieldByName('Unfinished3_4Story').AsInteger :=
              Trunc(Roundoff(StrToFloat(GetField(5, 374, 378, ReadBuff)) * 0.75, 0));
      except
        FieldByName('Unfinished3_4Story').AsInteger := 0;
      end;

      try
        FieldByName('UnfinishedRoom').AsInteger := StrToInt(GetField(5, 379, 383, ReadBuff));
      except
        FieldByName('UnfinishedRoom').AsInteger := 0;
      end;

      try
        FieldByName('SqFootLivingArea').AsInteger := StrToInt(GetField(5, 384, 388, ReadBuff));
      except
        FieldByName('SqFootLivingArea').AsInteger := 0;
      end;

      try
        FieldByName('FinishedRecRoom').AsInteger := StrToInt(GetField(5, 389, 393, ReadBuff));
      except
        FieldByName('FinishedRecRoom').AsInteger := 0;
      end;

      try
        FieldByName('FunctionalObsolescen').AsFloat := StrToFloat(GetField(3, 415, 417, ReadBuff));
      except
        FieldByName('FunctionalObsolescen').AsFloat := 0;
      end;

      try
        FieldByName('ReplacementCostNew').AsFloat := StrToFloat(GetField(9, 394, 402, ReadBuff));
      except
        FieldByName('ReplacementCostNew').AsFloat := 0;
      end;

      try
        FieldByName('RCNLessDepreciation').AsFloat := StrToFloat(GetField(9, 403, 411, ReadBuff));
      except
        FieldByName('RCNLessDepreciation').AsFloat := 0;
      end;

      try
        FieldByName('PercentGood').AsFloat := StrToFloat(GetField(3, 412, 414, ReadBuff));
      except
        FieldByName('PercentGood').AsFloat := 0;
      end;

      try
        If ExtractAllData
          then
            begin
              If (SalesNumber > 0)
                then WriteInformationToExtractFile(SalesResidentialBuildingExtractFile, TempTable)
                else WriteInformationToExtractFile(ResidentialBuildingExtractFile, TempTable);
              Cancel;
            end
          else Post;
      except
        SystemSupport(002, TempTable, 'Error Attempting to Post Res Bldg Rec',
                      UnitName, GlblErrorDlgBox);
      end;

    except
      E := ExceptObject;
      Writeln(ErrorLog, 'Error in res bldg record ' + IntToStr(RecordNo) + ' error = ' +
              Exception(E).Message);
    end;

     {If this was a ThisYear inventory record, then copy it to NextYear
      inventory, but only if the parcel is active in ThisYear.}

  If ((SalesNumber = 0) and
      CopyToNextYear)
    then
      begin
(*        SwisSBLKey := ExtractSwisSBLFromSwisSBLKey(ThisYearTable.FieldByName('SwisSBLKey').Text);

        with SwisSBLKey do
          Found := FindKeyOld(ThisYearParcelTable,
                              ['TaxRollYr', 'SwisCode', 'Section',
                               'Subsection', 'Block', 'Lot', 'Sublot'],
                              [GlblThisYear, SwisCode,
                               Section, Subsection,
                               Block, Lot, Sublot, Suffix]);


        If (Found and
            (ThisYearParcelTable.FieldByName('ActiveFlag').Text <> InactiveParcelFlag))
          then
            begin*)
(*              CopyTable_OneRecord(ThisYearTable, NextYearTable,
                                   ['TaxRollYr'], [GlblNextYear]);*)

(*            end;*)

      end;  {If (SalesNumber = 0)}

end;  {AddResidentialBuilding}

{====================================================================================}
Procedure AddCommercialSite(    ThisYearParcelTable,
                                ThisYearTable,
                                NextYearTable,
                                SalesTable : TTable;
                                ReadBuff : RPSImportRec;
                                SalesNumber : Integer;
                                RecordNo : LongInt;
                            var TYSiteCount,
                                NYSiteCount,
                                SalesSiteCount : LongInt;
                                CopyToNextYear : Boolean;
                            var ErrorLog : Text);

{Extract the information for one commercial site record and insert it in the
 commercial site table.}

var
  E : TObject;
  TempStr : String;
  TempTable : TTable;
  Found : Boolean;
  SwisSBLKey : SBLRecord;
  TaxRollYr : String;

begin
  If (SalesNumber > 0)
    then
      begin
        TempTable := SalesTable;
        SalesSiteCount := SalesSiteCount + 1;
        TaxRollYr := GlblThisYear;  {Tax roll year does not really matter for sales inv.}
      end
    else
      begin
        TempTable := ThisYearTable;
        TYSiteCount := TYSiteCount + 1;
        TaxRollYr := GlblThisYear;

      end;  {else of If (SalesNumber > 0)}

  with TempTable do
    try
      Insert;

      FieldByName('TaxRollYr').Text := Take(4, TaxRollYr);
      FieldByName('SwisSBLKey').Text := GetField(26, 1, 26, ReadBuff);
      FieldByName('Site').AsInteger := StrToInt(GetField(2, 30, 31, ReadBuff));
      FieldByName('SalesNumber').AsInteger := SalesNumber;

      FieldByName('PropertyClassCode').Text := GetField(3, 59, 61, ReadBuff);
      FieldByName('PropertyClassDesc').Text := SetDescription(
                                        RecordNo,
                                        FieldByName('PropertyClassCode').Text,
                                        PropertyClassList,
                                        ErrorLog);

      FieldByName('UsedAsCode').Text := GetField(3, 62, 64, ReadBuff);

        {FXX11131997-4: Sometimes a blank used as code was being stored as
                        '000' in the 995.}

      If (FieldByName('UsedAsCode').Text = '000')
        then FieldByName('UsedAsCode').Text := ''
        else FieldByName('UsedAsDesc').Text := SetDescription(
                                                   RecordNo,
                                                   FieldByName('UsedAsCode').Text,
                                                   UsedAsList,
                                                   ErrorLog);

      FieldByName('RouteNumber').Text := GetField(9, 65, 73, ReadBuff);

      FieldByName('NeighborhoodCode').Text := DezeroOnLeft(GetField(5, 74, 78, ReadBuff));
      FieldByName('NeighborhoodDesc').Text := SetDescription(
                                        RecordNo,
                                        FieldByName('NeighborhoodCode').Text,
                                        NeighborhoodList,
                                        ErrorLog);

      FieldByName('ZoningCode').Text := GetField(5, 79, 83, ReadBuff);
      FieldByName('ZoningDesc').Text := SetDescription(
                                        RecordNo,
                                        FieldByName('ZoningCode').Text,
                                        ZoningList,
                                        ErrorLog);

      FieldByName('ValuationDistCode').Text := GetField(2, 84, 85, ReadBuff);
      FieldByName('ValuationDistDesc').Text := SetDescription(RecordNo,
                                                              FieldByName('ValuationDistCode').Text,
                                                              ValuationDistList,
                                                              ErrorLog);

      FieldByName('SewerTypeCode').Text := GetField(1, 86, 86, ReadBuff);
      FieldByName('SewerTypeDesc').Text := SetDescription(
                                        RecordNo,
                                        FieldByName('SewerTypeCode').Text,
                                        SewerList,
                                        ErrorLog);

      FieldByName('WaterSupplyCode').Text := GetField(1, 87, 87, ReadBuff);
      FieldByName('WaterSupplyDesc').Text := SetDescription(
                                        RecordNo,
                                        FieldByName('WaterSupplyCode').Text,
                                        WaterList,
                                        ErrorLog);

      FieldByName('UtilitiesCode').Text := GetField(1, 88, 88, ReadBuff);
      FieldByName('UtilitiesDesc').Text := SetDescription(
                                        RecordNo,
                                        FieldByName('UtilitiesCode').Text,
                                        UtilityList,
                                        ErrorLog);

      {FXX01211998-3: The site desirability codes are different for
                      commercial and residential.}

      FieldByName('DesirabilityCode').Text := GetField(1, 89, 89, ReadBuff);
      FieldByName('DesirabilityDesc').Text := SetDescription(
                                        RecordNo,
                                        FieldByName('DesirabilityCode').Text,
                                        ComSiteDesirabilityList,
                                        ErrorLog);

      FieldByName('ConditionCode').Text := GetField(1, 90, 90, ReadBuff);
      FieldByName('ConditionDesc').Text := SetDescription(
                                        RecordNo,
                                        FieldByName('ConditionCode').Text,
                                        ConditionList,
                                        ErrorLog);

      FieldByName('GradeCode').Text := GetField(1, 95, 95, ReadBuff);
      FieldByName('GradeDesc').Text := SetDescription(
                                        RecordNo,
                                        FieldByName('GradeCode').Text,
                                        GradeList,
                                        ErrorLog);

      FieldByName('EffectiveYearBuilt').Text := GetField(4, 91, 94, ReadBuff);

        {FXX11131997-5: Sometimes blank years are being stored as '0000'.}

      If (FieldByName('EffectiveYearBuilt').Text = '0000')
        then FieldByName('EffectiveYearBuilt').Text := '';

      FieldByName('EntryCode').Text := GetField(1, 96, 96, ReadBuff);
      FieldByName('EntryDesc').Text := SetDescription(
                                        RecordNo,
                                        FieldByName('EntryCode').Text,
                                        EntryList,
                                        ErrorLog);

      try
        FieldByName('ReplacementCostNew').AsFloat := StrToFloat(GetField(12, 122, 133, ReadBuff));
      except
        FieldByName('ReplacementCostNew').AsFloat := 0
      end;

      try
        FieldByName('RCNLessDeprec').AsFloat := StrToFloat(GetField(12, 134, 145, ReadBuff));
      except
        FieldByName('RCNLessDeprec').AsFloat := 0;
      end;

      try
        FieldByName('LandEstimate').AsFloat := StrToFloat(GetField(12, 146, 157, ReadBuff));
      except
        FieldByName('LandEstimate').AsFloat := 0;
      end;

      try
        FieldByName('TotalEstimate').AsFloat := StrToFloat(GetField(12, 158, 169, ReadBuff));
      except
        FieldByName('TotalEstimate').AsFloat := 0;
      end;

      try
        FieldByName('ExcessValue').AsFloat := StrToFloat(GetField(9, 170, 178, ReadBuff));
      except
        FieldByName('ExcessValue').AsFloat := 0;
      end;

      try
        FieldByName('FinalLandValue').AsFloat := StrToFloat(GetField(12, 110, 121, ReadBuff));
      except
        FieldByName('FinalLandValue').AsFloat := 0;
      end;

      try
        FieldByName('FinalTotalValue').AsFloat := StrToFloat(GetField(12, 98, 109, ReadBuff));
      except
        FieldByName('FinalTotalValue').AsFloat := 0;
      end;

      FieldByName('LastChangeDate').Text := MakeYYYYMMDDSlashed(ConvYYDate(40,45,ReadBuff));
      FieldByName('MailerSent').AsBoolean := StrToBool_Blank_1(GetField(1, 86, 86, ReadBuff));
      FieldByName('LaserDiskFrameNo').Text := GetField(9, 179, 187, ReadBuff);

      try
        If ExtractAllData
          then
            begin
              If (SalesNumber > 0)
                then WriteInformationToExtractFile(SalesCommercialSiteExtractFile, TempTable)
                else WriteInformationToExtractFile(CommercialSiteExtractFile, TempTable);
              Cancel;
            end
          else Post;
      except
        SystemSupport(002, TempTable, 'Error Attempting to Post Com Site Rec',
                      UnitName, GlblErrorDlgBox);
      end;

    except
      E := ExceptObject;
      Writeln(ErrorLog, 'Error in com site record ' + IntToStr(RecordNo) + ' error = ' +
              Exception(E).Message);
    end;

     {If this was a ThisYear inventory record, then copy it to NextYear
      inventory, but only if the parcel is active in ThisYear.}

  If ((SalesNumber = 0) and
      CopyToNextYear)
    then
      begin
        SwisSBLKey := ExtractSwisSBLFromSwisSBLKey(ThisYearTable.FieldByName('SwisSBLKey').Text);

        with SwisSBLKey do
          Found := FindKeyOld(ThisYearParcelTable,
                              ['TaxRollYr', 'SwisCode', 'Section',
                               'Subsection', 'Block', 'Lot', 'Sublot'],
                              [GlblThisYear, SwisCode,
                               Section, Subsection,
                               Block, Lot, Sublot, Suffix]);

(*        If (Found and
            (ThisYearParcelTable.FieldByName('ActiveFlag').Text <> InactiveParcelFlag))
          then
            begin*)
(*              CopyTable_OneRecord(ThisYearTable, NextYearTable,
                                  ['TaxRollYr'], [GlblNextYear]);*)
              NYSiteCount := NYSiteCount + 1;
(*            end;*)

      end;  {If (SalesNumber = 0)}

end;  {AddCommercialSite}

{====================================================================================}
Procedure AddCommercialIncomeExpenseRecord(    ThisYearParcelTable,
                                               ThisYearTable,
                                               NextYearTable,
                                               SalesTable : TTable;
                                               ReadBuff : RPSImportRec;
                                               SalesNumber : Integer;
                                               RecordNo : LongInt;
                                               CopyToNextYear : Boolean;
                                           var ErrorLog : Text);

{Extract the information for one commercial income expense record and insert it in
 the commercial income expense table.}

var
  E : TObject;
  TempTable : TTable;
  Found : Boolean;
  SwisSBLKey : SBLRecord;
  TaxRollYr : String;

begin
  If (SalesNumber > 0)
    then
      begin
        TempTable := SalesTable;
        TaxRollYr := GlblThisYear;  {Tax roll year does not really matter for sales inv.}
      end
    else
      begin
        TempTable := ThisYearTable;
        TaxRollYr := GlblThisYear;

      end;  {else of If (SalesNumber > 0)}

  with TempTable do
    try
        {Insert the Commercial IncomeExpense.}

      Insert;

      FieldByName('TaxRollYr').Text := Take(4, TaxRollYr);
      FieldByName('SwisSBLKey').Text := GetField(26, 1, 26, ReadBuff);
      FieldByName('SalesNumber').AsInteger := SalesNumber;

      FieldByName('Site').AsInteger := StrToInt(GetField(2, 30, 31, ReadBuff));

      FieldByName('DataUseCode').Text := GetField(1, 49, 49, ReadBuff);
      FieldByName('DataUseDesc').Text := SetDescription(RecordNo,
                                                        FieldByName('DataUseCode').Text,
                                                        DataUseList,
                                                        ErrorLog);

      try
        FieldByName('GrossRentalIncome').AsFloat := StrToFloat(GetField(8, 50, 57, ReadBuff));
      except
        FieldByName('GrossRentalIncome').AsFloat := 0;
      end;

      try
        FieldByName('AdditionalIncome').AsFloat := StrToFloat(GetField(8, 58, 65, ReadBuff));
      except
        FieldByName('AdditionalIncome').AsFloat := 0;
      end;

      FieldByName('ExpenseTypeCode').Text := GetField(1, 66, 66, ReadBuff);
      FieldByName('ExpenseTypeDesc').Text := SetDescription(RecordNo,
                                                            FieldByName('ExpenseTypeCode').Text,
                                                            ExpenseList,
                                                            ErrorLog);
      try
        FieldByName('VacanyOrCreditLoss').AsFloat := StrToFloat(GetField(8, 67, 74, ReadBuff));
      except
        FieldByName('VacanyOrCreditLoss').AsFloat := 0;
      end;
      try
        FieldByName('TotalExpenses').AsFloat := StrToFloat(GetField(8, 75, 82, ReadBuff));
      except
        FieldByName('TotalExpenses').AsFloat := 0;
      end;

      try
        FieldByName('InsuranceExpenses').AsFloat := StrToFloat(GetField(8, 83, 90, ReadBuff));
      except
        FieldByName('InsuranceExpenses').AsFloat := 0;
      end;

      try
        FieldByName('BldgSvcExpenses').AsFloat := StrToFloat(GetField(8, 91, 98, ReadBuff));
      except
        FieldByName('BldgSvcExpenses').AsFloat := 0;
      end;

      try
        FieldByName('UtilityExpenses').AsFloat := StrToFloat(GetField(8, 99, 106, ReadBuff));
      except
        FieldByName('UtilityExpenses').AsFloat := 0;
      end;

      try
        FieldByName('MaintenanceExpenses').AsFloat := StrToFloat(GetField(8, 107, 114, ReadBuff));
      except
        FieldByName('MaintenanceExpenses').AsFloat := 0;
      end;

      try
        FieldByName('ReserveForReplacemen').AsFloat := StrToFloat(GetField(8, 115, 122, ReadBuff));
      except
        FieldByName('ReserveForReplacemen').AsFloat := 0;
      end;

      try
        FieldByName('ManagementExpenses').AsFloat := StrToFloat(GetField(8, 123, 130, ReadBuff));
      except
        FieldByName('ManagementExpenses').AsFloat := 0;
      end;

      try
        FieldByName('MiscCosts').AsFloat := StrToFloat(GetField(8, 131, 138, ReadBuff));
      except
        FieldByName('MiscCosts').AsFloat := 0;
      end;

      FieldByName('AppDepCode').Text := GetField(1, 139, 139, ReadBuff);
      FieldByName('AppDepDesc').Text := SetDescription(RecordNo,
                                                       FieldByName('AppDepCode').Text,
                                                       AppDepList,
                                                       ErrorLog);

      FieldByName('InvestmentSetCode').Text := GetField(2, 140, 141, ReadBuff);
      FieldByName('InvestmentSetDesc').Text := SetDescription(RecordNo,
                                                              FieldByName('InvestmentSetCode').Text,
                                                              InvestmentSetList,
                                                              ErrorLog);

      try
        FieldByName('InvestmentPeriod').AsFloat := StrToFloat(GetField(2, 142, 143, ReadBuff));
      except
        FieldByName('InvestmentPeriod').AsFloat := 0;
      end;

      try
        FieldByName('EquityYieldPercent').AsFloat := StrToFloat(GetField(4, 144, 147, ReadBuff)) / 100;
      except
        FieldByName('EquityYieldPercent').AsFloat := 0;
      end;

      try
        FieldByName('EquityDividend').AsFloat := StrToFloat(GetField(5, 148, 152, ReadBuff));
      except
        FieldByName('EquityDividend').AsFloat := 0;
      end;

      try
        FieldByName('CurrencyField1stMortPercentTotInv').AsFloat := StrToFloat(GetField(4, 153, 156, ReadBuff));
      except
        FieldByName('CurrencyField1stMortPercentTotInv').AsFloat := 0;
      end;

      try
        FieldByName('FloatField1stMortTerm').AsFloat := StrToFloat(GetField(2, 157, 158, ReadBuff));
      except
        FieldByName('FloatField1stMortTerm').AsFloat := 0;
      end;

      try
        FieldByName('CurrencyField1stMortIntRate').AsFloat := StrToFloat(GetField(4, 159, 162, ReadBuff)) / 100;
      except
        FieldByName('CurrencyField1stMortIntRate').AsFloat := 0;
      end;

      try
        FieldByName('CurrencyField2ndMortPercentTotInv').AsFloat := StrToFloat(GetField(4, 163, 166, ReadBuff)) / 100;
      except
        FieldByName('CurrencyField2ndMortPercentTotInv').AsFloat := 0;
      end;

      try
        FieldByName('FloatField2ndMortTerm').AsFloat := StrToFloat(GetField(2, 167, 168, ReadBuff));
      except
        FieldByName('FloatField2ndMortTerm').AsFloat := 0;
      end;

      try
        FieldByName('CurrencyField2ndMortIntRate').AsFloat := StrToFloat(GetField(4, 169, 172, ReadBuff));
      except
        FieldByName('CurrencyField2ndMortIntRate').AsFloat := 0;
      end;

      try
        FieldByName('AppDepPercent').AsFloat := StrToFloat(GetField(4, 173, 176, ReadBuff)) / 100;
      except
        FieldByName('AppDepPercent').AsFloat := 0;
      end;

      FieldByName('RentRestricted').AsBoolean := StrToBool(GetField(1, 177, 177, ReadBuff));

      try
        FieldByName('EffectiveGrossInc').AsFloat := StrToFloat(GetField(8, 178, 185, ReadBuff));
      except
        FieldByName('EffectiveGrossInc').AsFloat := 0;
      end;

      try
        FieldByName('NetOperatingIncome').AsFloat := StrToFloat(GetField(8, 186, 193, ReadBuff));
      except
        FieldByName('NetOperatingIncome').AsFloat := 0;
      end;

      FieldByName('AlternateName').Text := GetField(20, 194, 213, ReadBuff);
      FieldByName('AlternateAddress').Text := GetField(20, 214, 233, ReadBuff);

      try
        If ExtractAllData
          then
            begin
              If (SalesNumber > 0)
                then WriteInformationToExtractFile(SalesCommercialIncomeExpenseExtractFile, TempTable)
                else WriteInformationToExtractFile(CommercialIncomeExpenseExtractFile, TempTable);
              Cancel;
            end
          else Post;
      except
        SystemSupport(002, TempTable, 'Error Attempting to Post Com Inc\Exp Rec',
                      UnitName, GlblErrorDlgBox);
      end;

    except
      E := ExceptObject;
      Writeln(ErrorLog, 'Error in com inc\exp record ' + IntToStr(RecordNo) + ' error = ' +
              Exception(E).Message);
    end;

     {If this was a ThisYear inventory record, then copy it to NextYear
      inventory, but only if the parcel is active in ThisYear.}

  If ((SalesNumber = 0) and
      CopyToNextYear)
    then
      begin
(*        SwisSBLKey := ExtractSwisSBLFromSwisSBLKey(ThisYearTable.FieldByName('SwisSBLKey').Text);

        with SwisSBLKey do
          Found := FindKeyOld(ThisYearParcelTable,
                              ['TaxRollYr', 'SwisCode', 'Section',
                               'Subsection', 'Block', 'Lot',
                               'Sublot'],
                              [GlblThisYear, SwisCode, Section, Subsection,
                               Block, Lot, Sublot, Suffix]);

        If (Found and
            (ThisYearParcelTable.FieldByName('ActiveFlag').Text <> InactiveParcelFlag))
          then *)(*CopyTable_OneRecord(ThisYearTable, NextYearTable,
                                   ['TaxRollYr'], [GlblNextYear]);*)

      end;  {If (SalesNumber = 0)}

end;  {AddCommercialIncomeExpense}

{====================================================================================}
Procedure AddImprovementRecord(    ThisYearParcelTable,
                                   ThisYearTable,
                                   NextYearTable,
                                   SalesTable : TTable;
                                   ReadBuff : RPSImportRec;
                                   Base,
                                   Offset,
                                   SalesNumber : Integer;
                                   RecordNo : LongInt;
                                   CopyToNextYear : Boolean;
                                   Residential : Boolean;
                               var ErrorLog : Text);

{Extract the information for one improvement record and insert it in the improvement table.}
{Note that the improvement record layout is identical between residential and commercial, so we are
 using the same procedure for each by passing in the table.}

var
  E : TObject;
  TempTable : TTable;
  Found : Boolean;
  SwisSBLKey : SBLRecord;
  TaxRollYr : String;

begin
  If (SalesNumber > 0)
    then
      begin
        TempTable := SalesTable;
        TaxRollYr := GlblThisYear;  {Tax roll year does not really matter for sales inv.}
      end
    else
      begin
        TempTable := ThisYearTable;
        TaxRollYr := GlblThisYear;

      end;  {else of If (SalesNumber > 0)}

  with TempTable do
    try
      Insert;

      FieldByName('TaxRollYr').Text := Take(4, TaxRollYr);
      FieldByName('SwisSBLKey').Text := GetField(26, 1, 26,ReadBuff);
      FieldByName('Site').AsInteger := StrToInt(GetField(2, 30, 31, ReadBuff));
      FieldByName('SalesNumber').AsInteger := SalesNumber;

      FieldByName('YearBuilt').Text := GetField(4, (Base + Offset + 23),
                                                (Base + Offset + 26), ReadBuff);

        {FXX11131997-5: Sometimes blank years are being stored as '0000'.}

      If (FieldByName('YearBuilt').Text = '0000')
        then FieldByName('YearBuilt').Text := '';

      FieldByName('ImprovementNumber').AsInteger := StrToInt(GetField(2, (Base + Offset),
                                                                      (Base + Offset + 1), ReadBuff));
      FieldByName('StructureCode').Text := GetField(3, (Base + Offset + 2),
                                                    (Base + Offset + 4), ReadBuff);
      FieldByName('StructureDesc').Text := SetDescription(RecordNo,
                                                          FieldByName('StructureCode').Text,
                                                          StructureList,
                                                          ErrorLog);

      FieldByName('MeasureCode').Text := GetField(1, (Base + Offset + 5),
                                                  (Base + Offset + 5), ReadBuff);
      FieldByName('MeasureDesc').Text := SetDescription(RecordNo,
                                                        FieldByName('MeasureCode').Text,
                                                        MeasurementList,
                                                        ErrorLog);

      FieldByName('Dimension1').Text := GetField(6, (Base + Offset + 6),
                                                 (Base + Offset + 11), ReadBuff);
      FieldByName('Dimension2').Text := GetField(6, (Base + Offset + 12),
                                                 (Base + Offset + 17), ReadBuff);
      FieldByName('Quantity').Text := GetField(3, (Base + Offset + 18),
                                                 (Base + Offset + 20), ReadBuff);

      FieldByName('GradeCode').Text := GetField(1, (Base + Offset + 21),
                                                (Base + Offset + 21), ReadBuff);
      FieldByName('GradeDesc').Text := SetDescription(RecordNo,
                                                      FieldByName('GradeCode').Text,
                                                      GradeList,
                                                      ErrorLog);

      FieldByName('ConditionCode').Text := GetField(1, (Base + Offset + 22),
                                                    (Base + Offset + 22), ReadBuff);
      FieldByName('ConditionDesc').Text := SetDescription(RecordNo,
                                                          FieldByName('ConditionCode').Text,
                                                          ConditionList,
                                                          ErrorLog);

      FieldByName('PercentGood').Text := GetField(3, (Base + Offset + 27),
                                                  (Base + Offset + 29), ReadBuff);
      FieldByName('FunctionalObsolescen').Text := GetField(3, (Base + Offset + 30),
                                                           (Base + Offset + 32), ReadBuff);
      FieldByName('ReplacementCostNew').Text := GetField(9, (Base + Offset + 33),
                                                         (Base + Offset + 41), ReadBuff);
      FieldByName('RCNLessDepreciation').Text := GetField(9, (Base + Offset + 42),
                                                          (Base + Offset + 50), ReadBuff);

      try
        If ExtractAllData
          then
            begin
              If Residential
                then
                  begin
                    If (SalesNumber > 0)
                      then WriteInformationToExtractFile(SalesResidentialImprovementExtractFile, TempTable)
                      else WriteInformationToExtractFile(ResidentialImprovementExtractFile, TempTable);
                  end
                else
                  begin
                    If (SalesNumber > 0)
                      then WriteInformationToExtractFile(SalesCommercialImprovementExtractFile, TempTable)
                      else WriteInformationToExtractFile(CommercialImprovementExtractFile, TempTable);
                  end;

              Cancel;
            end
          else Post;
      except
        SystemSupport(003, TempTable, 'Error posting improvements record.',
                      UnitName, GlblErrorDlgBox);
      end;

    except
      E := ExceptObject;
      Writeln(ErrorLog, 'Error in imp record ' + IntToStr(RecordNo) + ' error = ' +
              Exception(E).Message);
    end;

     {If this was a ThisYear inventory record, then copy it to NextYear
      inventory, but only if the parcel is active in ThisYear.}

  If ((SalesNumber = 0) and
      CopyToNextYear)
    then
      begin
(*        SwisSBLKey := ExtractSwisSBLFromSwisSBLKey(ThisYearTable.FieldByName('SwisSBLKey').Text);

        with SwisSBLKey do
          Found := FindKeyOld(ThisYearParcelTable,
                              ['TaxRollYr', 'SwisCode', 'Section',
                               'Subsection', 'Block', 'Lot',
                               'Sublot'],
                              [GlblThisYear, SwisCode, Section, Subsection,
                               Block, Lot, Sublot, Suffix]);

        If (Found and
            (ThisYearParcelTable.FieldByName('ActiveFlag').Text <> InactiveParcelFlag))
          then *)(*CopyTable_OneRecord(ThisYearTable, NextYearTable,
                                   ['TaxRollYr'], [GlblNextYear]);*)

      end;  {If (SalesNumber = 0)}

end;  {AddImprovementRecord}

{====================================================================================}
Procedure AddLandRecord(    ThisYearParcelTable,
                            ThisYearTable,
                            NextYearTable,
                            SalesTable : TTable;
                            ReadBuff : RPSImportRec;
                            Base,
                            Offset : Integer;
                            SalesNumber : Integer;
                            RecordNo : LongInt;
                            CopyToNextYear : Boolean;
                            Residential : Boolean;
                        var ErrorLog : Text);

{Extract the information for one land record and insert it in the land table.}
{Note that the land record layout is identical between residential and commercial, so we are
 using the same procedure for each by passing in the table.}

var
  E : TObject;
  TempStr : String;
  TempNum : Double;
  ReturnCode : Integer;
  TempTable : TTable;
  Found : Boolean;
  SwisSBLKey : SBLRecord;
  TaxRollYr : String;

begin
  If (SalesNumber > 0)
    then
      begin
        TempTable := SalesTable;
        TaxRollYr := GlblThisYear;  {Tax roll year does not really matter for sales inv.}
      end
    else
      begin
        TempTable := ThisYearTable;
        TaxRollYr := GlblThisYear;

      end;  {else of If (SalesNumber > 0)}

  with TempTable do
    try
      Insert;

      FieldByName('TaxRollYr').Text := Take(4, TaxRollYr);
      FieldByName('SwisSBLKey').Text := GetField(26, 1, 26,ReadBuff);
      FieldByName('Site').AsInteger := StrToInt(GetField(2, 30, 31, ReadBuff));
      FieldByName('SalesNumber').AsInteger := SalesNumber;

      FieldByName('LandNumber').AsInteger := StrToInt(GetField(2, (Base + Offset),
                                                               (Base + Offset + 1), ReadBuff));
      FieldByName('LandTypeCode').Text := GetField(2, (Base + Offset + 2),
                                                   (Base + Offset + 3), ReadBuff);
      FieldByName('LandTypeDesc').Text := SetDescription(RecordNo,
                                                         FieldByName('LandTypeCode').Text,
                                                         LandTypeList,
                                                         ErrorLog);

      FieldByName('Frontage').Text := GetField(4, (Base + Offset + 4),
                                               (Base + Offset + 7), ReadBuff);
      FieldByName('Depth').Text := GetField(4, (Base + Offset + 8),
                                            (Base + Offset + 11), ReadBuff);

          {Acreage has two decimal places to the right.}

      TempStr := GetField(7, (Base + Offset + 12),
                          (Base + Offset + 18), ReadBuff);
      try
        TempNum := StrToFloat(TempStr);
      except
        TempNum := 0;
      end;

      TempStr := FloatToStr(TempNum/100);
      FieldByName('Acreage').Text := TempStr;

      FieldByName('SquareFootage').Text := GetField(8, (Base + Offset + 19),
                                                    (Base + Offset + 26), ReadBuff);

      FieldByName('SoilRatingCode').Text := GetField(2, (Base + Offset + 27),
                                                     (Base + Offset + 28), ReadBuff);
      FieldByName('SoilRatingDesc').Text := SetDescription(RecordNo,
                                                           FieldByName('SoilRatingCode').Text,
                                                           SoilRatingList,
                                                           ErrorLog);

      FieldByName('InfluenceCode').Text := GetField(1, (Base + Offset + 29),
                                                    (Base + Offset + 29), ReadBuff);
      FieldByName('InfluenceDesc').Text := SetDescription(RecordNo,
                                                          FieldByName('InfluenceCode').Text,
                                                          InfluenceList,
                                                          ErrorLog);

      FieldByName('InfluencePercent').Text := GetField(3, (Base + Offset + 30),
                                                       (Base + Offset + 32), ReadBuff);
      FieldByName('DepthFactor').Text := GetField(3, (Base + Offset + 33),
                                                  (Base + Offset + 35), ReadBuff);
      FieldByName('LandValue').Text := GetField(9, (Base + Offset + 36),
                                                (Base + Offset + 44), ReadBuff);

         {The last three digits of unit price are actually after the decimal.}

      TempStr := GetField(10, (Base + Offset + 45),
                              (Base + Offset + 54), ReadBuff);

      try
        TempNum := StrToFloat(TempStr);
      except
        TempNum := 0;
      end;

      TempStr := FloatToStr(TempNum/1000);

      FieldByName('UnitPrice').Text := TempStr;
      TempStr := FieldByName('UnitPrice').Text;
      TempStr := FieldByName('SwisSBLKey').Text;

      FieldByName('WaterfrontTypeCode').Text := GetField(1, (Base + Offset + 55),
                                                         (Base + Offset + 55), ReadBuff);
      FieldByName('WaterfrontTypeDesc').Text := SetDescription(RecordNo,
                                                               FieldByName('WaterfrontTypeCode').Text,
                                                               WaterfrontTypeList,
                                                               ErrorLog);

      try
        If ExtractAllData
          then
            begin
              If Residential
                then
                  begin
                    If (SalesNumber > 0)
                      then WriteInformationToExtractFile(SalesResidentialLandExtractFile, TempTable)
                      else WriteInformationToExtractFile(ResidentialLandExtractFile, TempTable);
                  end
                else
                  begin
                    If (SalesNumber > 0)
                      then WriteInformationToExtractFile(SalesCommercialLandExtractFile, TempTable)
                      else WriteInformationToExtractFile(CommercialLandExtractFile, TempTable);
                  end;

              Cancel;
            end
          else Post;
      except
        SystemSupport(003, TempTable, 'Error posting land record.',
                      UnitName, GlblErrorDlgBox);
      end;

    except
      E := ExceptObject;
      Writeln(ErrorLog, 'Error in land record ' + IntToStr(RecordNo) + ' error = ' +
              Exception(E).Message);
    end;

     {If this was a ThisYear inventory record, then copy it to NextYear
      inventory, but only if the parcel is active in ThisYear.}

  If ((SalesNumber = 0) and
      CopyToNextYear)
    then
      begin
(*        SwisSBLKey := ExtractSwisSBLFromSwisSBLKey(ThisYearTable.FieldByName('SwisSBLKey').Text);

        with SwisSBLKey do
          Found := FindKeyOld(ThisYearParcelTable,
                              ['TaxRollYr', 'SwisCode', 'Section',
                               'Subsection', 'Block', 'Lot', 'Sublot'],
                              [GlblThisYear, SwisCode,
                               Section, Subsection,
                               Block, Lot, Sublot, Suffix]);

        If (Found and
            (ThisYearParcelTable.FieldByName('ActiveFlag').Text <> InactiveParcelFlag))
          then *)(*CopyTable_OneRecord(ThisYearTable, NextYearTable,
                                   ['TaxRollYr'], [GlblNextYear]);*)

      end;  {If (SalesNumber = 0)}

end;  {AddLandRecord}

{====================================================================================}
Procedure AddResidentialForestRecord(    ThisYearParcelTable,
                                         ThisYearTable,
                                         NextYearTable,
                                         SalesTable : TTable;
                                         ReadBuff : RPSImportRec;
                                         Base,
                                         Offset,
                                         SalesNumber : Integer;
                                         RecordNo : LongInt;
                                         CopyToNextYear : Boolean;
                                     var ErrorLog : Text);

{Extract the information for one residential forest record and insert it in the residential
 forest table.}

var
  E : TObject;
  TempTable : TTable;
  Found : Boolean;
  SwisSBLKey : SBLRecord;
  TaxRollYr : String;

begin
  If (SalesNumber > 0)
    then
      begin
        TempTable := SalesTable;
        TaxRollYr := GlblThisYear;  {Tax roll year does not really matter for sales inv.}
      end
    else
      begin
        TempTable := ThisYearTable;
        TaxRollYr := GlblThisYear;

      end;  {else of If (SalesNumber > 0)}

  with TempTable do
    try
      Insert;

      FieldByName('TaxRollYr').Text := Take(4, TaxRollYr);
      FieldByName('SwisSBLKey').Text := GetField(26, 1, 26,ReadBuff);
      FieldByName('Site').AsInteger := StrToInt(GetField(2, 30, 31, ReadBuff));
      FieldByName('SalesNumber').AsInteger := SalesNumber;

      FieldByName('ForestNumber').AsInteger := StrToInt(GetField(2, (Base + Offset),
                                                                 (Base + Offset + 1), ReadBuff));

      FieldByName('RegionCode').Text := GetField(1, (Base + Offset + 2),
                                                 (Base + Offset + 2), ReadBuff);
      FieldByName('RegionDesc').Text := SetDescription(RecordNo,
                                                       FieldByName('RegionCode').Text,
                                                       ForestRegionList,
                                                       ErrorLog);

      FieldByName('ForestTypeCode').Text := GetField(2, (Base + Offset + 3),
                                                     (Base + Offset + 4), ReadBuff);
      FieldByName('ForestTypeDesc').Text := SetDescription(RecordNo,
                                                           FieldByName('ForestTypeCode').Text,
                                                           ForestTypeList,
                                                           ErrorLog);

      FieldByName('LoggingEaseCode').Text := GetField(1, (Base + Offset + 10),
                                                      (Base + Offset + 10), ReadBuff);
      FieldByName('LoggingEaseDesc').Text := SetDescription(RecordNo,
                                                            FieldByName('LoggingEaseCode').Text,
                                                            LoggingEaseList,
                                                            ErrorLog);

      FieldByName('AccessibilityCode').Text := GetField(1, (Base + Offset + 9),
                                                        (Base + Offset + 9), ReadBuff);
      FieldByName('AccessibilityDesc').Text := SetDescription(RecordNo,
                                                              FieldByName('AccessibilityCode').Text,
                                                              AccessibilityList,
                                                              ErrorLog);

      FieldByName('NominalValueCode').Text := GetField(1, (Base + Offset + 11),
                                                       (Base + Offset + 11), ReadBuff);
      FieldByName('NominalValueDesc').Text := SetDescription(RecordNo,
                                                             FieldByName('NominalValueCode').Text,
                                                             NominalValueList,
                                                             ErrorLog);

      FieldByName('SiteClassCode').Text := GetField(2, (Base + Offset + 5),
                                                    (Base + Offset + 6), ReadBuff);
      FieldByName('SiteClassDesc').Text := SetDescription(RecordNo,
                                                          FieldByName('SiteClassCode').Text,
                                                          SiteClassList,
                                                          ErrorLog);

      FieldByName('CutClassCode').Text := GetField(1, (Base + Offset + 8),
                                                   (Base + Offset + 8), ReadBuff);
      FieldByName('CutClassDesc').Text := SetDescription(RecordNo,
                                                         FieldByName('CutClassCode').Text,
                                                         CutClassList,
                                                         ErrorLog);

      FieldByName('VolAcreClassCode').Text := GetField(1, (Base + Offset + 7),
                                                       (Base + Offset + 7), ReadBuff);
      FieldByName('VolAcreClassDesc').Text := SetDescription(RecordNo,
                                                             FieldByName('VolAcreClassCode').Text,
                                                             VolAcreClassList,
                                                             ErrorLog);

      try
        FieldByName('ShorelineFrontage').AsFloat := StrToFloat(GetField(5, (Base + Offset + 12),
                                                                      (Base + Offset + 16), ReadBuff));
      except
        FieldByName('ShorelineFrontage').AsFloat := 0
      end;

      try
        FieldByName('Acres').AsFloat := StrToFloat(GetField(6, (Base + Offset + 17),
                                                          (Base + Offset + 22), ReadBuff))/100;
      except
        FieldByName('Acres').AsFloat := 0;
      end;

      try
        FieldByName('Value').AsFloat := StrToFloat(GetField(9, (Base + Offset + 23),
                                                          (Base + Offset + 31), ReadBuff));
      except
        FieldByName('Value').AsFloat := 0;
      end;

      try
        Post;
      except
        SystemSupport(002, TempTable, 'Error Attempting to Post Res. Forest Rec',
                      UnitName, GlblErrorDlgBox);
      end;

    except
      E := ExceptObject;
      Writeln(ErrorLog, 'Error in forest record ' + IntToStr(RecordNo) + ' error = ' +
              Exception(E).Message);
    end;

     {If this was a ThisYear inventory record, then copy it to NextYear
      inventory, but only if the parcel is active in ThisYear.}

  If ((SalesNumber = 0) and
      CopyToNextYear)
    then
      begin
(*        SwisSBLKey := ExtractSwisSBLFromSwisSBLKey(ThisYearTable.FieldByName('SwisSBLKey').Text);

        with SwisSBLKey do
          Found := FindKeyOld(ThisYearParcelTable,
                              ['TaxRollYr', 'SwisCode', 'Section',
                               'Subsection', 'Block', 'Lot', 'Sublot'],
                              [GlblThisYear, SwisCode,
                               Section, Subsection,
                               Block, Lot, Sublot, Suffix]);

        If (Found and
            (ThisYearParcelTable.FieldByName('ActiveFlag').Text <> InactiveParcelFlag))
          then *)(*CopyTable_OneRecord(ThisYearTable, NextYearTable,
                                   ['TaxRollYr'], [GlblNextYear]);*)

      end;  {If (SalesNumber = 0)}

end;  {AddResidentialForestRecord}

{====================================================================================}
Procedure AddCommercialBldgRecord(    ThisYearParcelTable,
                                      ThisYearTable,
                                      NextYearTable,
                                      SalesTable : TTable;
                                      ReadBuff : RPSImportRec;
                                      Base,
                                      Offset,
                                      SalesNumber : Integer;
                                      RecordNo : LongInt;
                                      CopyToNextYear : Boolean;
                                  var ErrorLog : Text);

{Extract the information for one commercial bldg record and insert it in the commercial
 bldg table.}

var
  E : TObject;
  TempStr : String;
  TempTable : TTable;
  Found : Boolean;
  SwisSBLKey : SBLRecord;
  TaxRollYr : String;

begin
  If (SalesNumber > 0)
    then
      begin
        TempTable := SalesTable;
        TaxRollYr := GlblThisYear;  {Tax roll year does not really matter for sales inv.}
      end
    else
      begin
        TempTable := ThisYearTable;
        TaxRollYr := GlblThisYear;

      end;  {else of If (SalesNumber > 0)}

  with TempTable do
    try
      Insert;

      FieldByName('TaxRollYr').Text := Take(4, TaxRollYr);
      FieldByName('SwisSBLKey').Text := GetField(26, 1, 26,ReadBuff);
      FieldByName('Site').AsInteger := StrToInt(GetField(2, 30, 31, ReadBuff));
      FieldByName('SalesNumber').AsInteger := SalesNumber;

      FieldByName('BuildingNumber').AsInteger := StrToInt(GetField(2, (Base + Offset + 0),
                                                                   (Base + Offset + 1), ReadBuff));

      try
        FieldByName('BuildingSection').AsInteger := StrToInt(GetField(1, (Base + Offset + 2),
                                                                    (Base + Offset + 2), ReadBuff));
      except
        FieldByName('BuildingSection').AsInteger := 0;
      end;

      try
        FieldByName('NumberIdentBldgs').AsInteger := StrToInt(GetField(3, (Base + Offset + 3),
                                                                     (Base + Offset + 5), ReadBuff));
      except
        FieldByName('NumberIdentBldgs').AsInteger := 0;
      end;

      FieldByName('BoeckhModelCode').Text := GetField(4, (Base + Offset + 6),
                                                      (Base + Offset + 9), ReadBuff);
      FieldByName('BoeckhModelDesc').Text := SetDescription(RecordNo,
                                                            FieldByName('BoeckhModelCode').Text,
                                                            BoeckhModelList,
                                                            ErrorLog);

      FieldByName('EffectiveYearBuilt').Text := GetField(4, (Base + Offset + 10),
                                                         (Base + Offset + 13), ReadBuff);

        {FXX11131997-5: Sometimes blank years are being stored as '0000'.}

      If (FieldByName('EffectiveYearBuilt').Text = '0000')
        then FieldByName('EffectiveYearBuilt').Text := '';

      try
        FieldByName('NumberStories').AsInteger := StrToInt(GetField(2, (Base + Offset + 33),
                                                                  (Base + Offset + 34), ReadBuff));
      except
        FieldByName('NumberStories').AsInteger := 0;
      end;

      try
        FieldByName('StoryHeight').AsInteger := StrToInt(GetField(2, (Base + Offset + 35),
                                                                (Base + Offset + 36), ReadBuff));
      except
        FieldByName('StoryHeight').AsInteger := 0;
      end;

      TempStr := GetField(2, (Base + Offset + 14), (Base + Offset + 15),
                          ReadBuff);

        {Sometimes the construction quality is zero filled rather than
         blank.}

      If (TempStr <> '00')
        then
          begin
            TempStr := TempStr[1] + '.' + TempStr[2];
            FieldByName('ConstructionQualCode').Text := TempStr;
            FieldByName('ConstructionQualDesc').Text := SetDescription(RecordNo,
                                                                       FieldByName('ConstructionQualCode').Text,
                                                                       ConstructionQualityList,
                                                                       ErrorLog);

          end;  {If (TempStr <> '00')}

      FieldByName('ConditionCode').Text := GetField(1, (Base + Offset + 19),
                                                    (Base + Offset + 19), ReadBuff);
      FieldByName('ConditionDesc').Text := SetDescription(RecordNo,
                                                          FieldByName('ConditionCode').Text,
                                                          ConditionList,
                                                          ErrorLog);

      try
        FieldByName('UserAdjustment').AsFloat := StrToFloat(GetField(3, (Base + Offset + 16),
                                                                    (Base + Offset + 18), ReadBuff))/100;
      except
        FieldByName('UserAdjustment').AsFloat := 0;
      end;

      try
        FieldByName('BuildingPerimeter').AsFloat := StrToFloat(GetField(6, (Base + Offset + 20),
                                                                      (Base + Offset + 25), ReadBuff));
      except
        FieldByName('BuildingPerimeter').AsFloat := 0;
      end;

      try
        FieldByName('GrossFloorArea').AsFloat := StrToFloat(GetField(7, (Base + Offset + 26),
                                                                   (Base + Offset + 32), ReadBuff));
      except
        FieldByName('GrossFloorArea').AsFloat := 0;
      end;

      try
        FieldByName('WallAPercent').AsFloat := StrToFloat(GetField(3, (Base + Offset + 37),
                                                                 (Base + Offset + 39), ReadBuff));
      except
        FieldByName('WallAPercent').AsFloat := 0
      end;

      try
        FieldByName('WallBPercent').AsFloat := StrToFloat(GetField(3, (Base + Offset + 40),
                                                                 (Base + Offset + 42), ReadBuff));
      except
        FieldByName('WallBPercent').AsFloat := 0;
      end;

      try
        FieldByName('WallCPercent').AsFloat := StrToFloat(GetField(3, (Base + Offset + 43),
                                                                 (Base + Offset + 45), ReadBuff));
      except
        FieldByName('WallCPercent').AsFloat := 0;
      end;

      try
        FieldByName('AirCondPercent').AsFloat := StrToFloat(GetField(3, (Base + Offset + 46),
                                                                   (Base + Offset + 48), ReadBuff));
      except
        FieldByName('AirCondPercent').AsFloat := 0;
      end;

      try
        FieldByName('SprinklerPercent').AsFloat := StrToFloat(GetField(3, (Base + Offset + 49),
                                                                     (Base + Offset + 51), ReadBuff));
      except
        FieldByName('SprinklerPercent').AsFloat := 0;
      end;

      try
        FieldByName('AlarmPercent').AsFloat := StrToFloat(GetField(3, (Base + Offset + 52),
                                                                 (Base + Offset + 54), ReadBuff));
      except
        FieldByName('AlarmPercent').AsFloat := 0;
      end;

      try
        FieldByName('NumberOfElevators').AsInteger := StrToInt(GetField(2, (Base + Offset + 55),
                                                                      (Base + Offset + 56), ReadBuff));
      except
        FieldByName('NumberOfElevators').AsInteger := 0;
      end;

      FieldByName('BasementTypeCode').Text := GetField(1, (Base + Offset + 57),
                                                       (Base + Offset + 57), ReadBuff);
      FieldByName('BasementTypeDesc').Text := SetDescription(RecordNo,
                                                             FieldByName('BasementTypeCode').Text,
                                                             ComBasementTypeList,
                                                             ErrorLog);

      try
        FieldByName('BasementPerimeter').AsFloat := StrToFloat(GetField(6, (Base + Offset + 58),
                                                                      (Base + Offset + 63), ReadBuff));
      except
        FieldByName('BasementPerimeter').AsFloat := 0;
      end;

      try
        FieldByName('BasementSquareFeet').AsFloat := StrToFloat(GetField(7, (Base + Offset + 64),
                                                                       (Base + Offset + 70), ReadBuff));
      except
        FieldByName('BasementSquareFeet').AsFloat := 0;
      end;

      try
        If ExtractAllData
          then
            begin
              If (SalesNumber > 0)
                then WriteInformationToExtractFile(SalesCommercialBuildingExtractFile, TempTable)
                else WriteInformationToExtractFile(CommercialBuildingExtractFile, TempTable);

              Cancel;
            end
          else Post;
      except
        SystemSupport(002, TempTable, 'Error Attempting to Post Comm Bldg Rec',
                      UnitName, GlblErrorDlgBox);
      end;

    except
      E := ExceptObject;
      Writeln(ErrorLog, 'Error in com bldg record ' + IntToStr(RecordNo) + ' error = ' +
              Exception(E).Message);
    end;

     {If this was a ThisYear inventory record, then copy it to NextYear
      inventory, but only if the parcel is active in ThisYear.}

  If ((SalesNumber = 0) and
      CopyToNextYear)
    then
      begin
(*        SwisSBLKey := ExtractSwisSBLFromSwisSBLKey(ThisYearTable.FieldByName('SwisSBLKey').Text);

        with SwisSBLKey do
          Found := FindKeyOld(ThisYearParcelTable,
                              ['TaxRollYr', 'SwisCode', 'Section',
                               'Subsection', 'Block', 'Lot', 'Sublot'],
                              [GlblThisYear, SwisCode,
                               Section, Subsection,
                               Block, Lot, Sublot, Suffix]);

        If (Found and
            (ThisYearParcelTable.FieldByName('ActiveFlag').Text <> InactiveParcelFlag))
          then *)(*CopyTable_OneRecord(ThisYearTable, NextYearTable,
                                   ['TaxRollYr'], [GlblNextYear]);*)

      end;  {If (SalesNumber = 0)}

end;  {AddCommercialBldgRecord}

{====================================================================================}
Procedure AddCommercialUseRecord(    ThisYearParcelTable,
                                     ThisYearTable,
                                     NextYearTable,
                                     SalesTable : TTable;
                                     ReadBuff : RPSImportRec;
                                     Base,
                                     Offset,
                                     SalesNumber : Integer;
                                     RecordNo : LongInt;
                                     CopyToNextYear : Boolean;
                                 var ErrorLog : Text);

{Extract the information for one commercial use record and insert it in the commercial
 use table.}

var
  E : TObject;
  TempTable : TTable;
  Found : Boolean;
  SwisSBLKey : SBLRecord;
  TaxRollYr : String;

begin
  If (SalesNumber > 0)
    then
      begin
        TempTable := SalesTable;
        TaxRollYr := GlblThisYear;  {Tax roll year does not really matter for sales inv.}
      end
    else
      begin
        TempTable := ThisYearTable;
        TaxRollYr := GlblThisYear;

      end;  {else of If (SalesNumber > 0)}

  with TempTable do
    try
      Insert;

      FieldByName('TaxRollYr').Text := Take(4, TaxRollYr);
      FieldByName('SwisSBLKey').Text := GetField(26, 1, 26,ReadBuff);
      FieldByName('Site').AsInteger := StrToInt(GetField(2, 30, 31, ReadBuff));
      FieldByName('SalesNumber').AsInteger := SalesNumber;

      FieldByName('UseNumber').AsInteger := StrToInt(GetField(2, (Base + Offset),
                                                              (Base + Offset + 1), ReadBuff));

      FieldByName('UsedAsCode').Text := GetField(3, (Base + Offset + 2),
                                                 (Base + Offset + 4), ReadBuff);
      FieldByName('UsedAsDesc').Text := SetDescription(RecordNo,
                                                       FieldByName('UsedAsCode').Text,
                                                       UsedAsList,
                                                       ErrorLog);

      FieldByName('ValuationDistCode').Text := GetField(2, (Base + Offset + 5),
                                                 (Base + Offset + 6), ReadBuff);
      FieldByName('ValuationDistDesc').Text := SetDescription(RecordNo,
                                                              FieldByName('ValuationDistCode').Text,
                                                              ValuationDistList,
                                                              ErrorLog);

      try
        FieldByName('TotalRentableArea').AsFloat := StrToFloat(GetField(7, (Base + Offset + 7),
                                                                        (Base + Offset + 13), ReadBuff));
      except
        FieldByName('TotalRentableArea').AsFloat := 0;
      end;

      try
        FieldByName('AreaEff1BedApt').AsFloat := StrToFloat(GetField(7, (Base + Offset + 14),
                                                                     (Base + Offset + 20), ReadBuff));
      except
        FieldByName('AreaEff1BedApt').AsFloat := 0;
      end;

      try
        FieldByName('Area2BedApt').AsFloat := StrToFloat(GetField(7, (Base + Offset + 21),
                                                                  (Base + Offset + 27), ReadBuff));
      except
        FieldByName('Area2BedApt').AsFloat := 0;
      end;

      try
        FieldByName('Area3BedApt').AsFloat := StrToFloat(GetField(7, (Base + Offset + 28),
                                                                  (Base + Offset + 34), ReadBuff));
      except
        FieldByName('Area3BedApt').AsFloat := 0;
      end;

        {Note that this unit type is actually a measurement type,
         i.e. Quantity or Square Feet, not the unit type like
         Courts or Bays.}

      FieldByName('UnitType_NonAptCode').Text := GetField(2, (Base + Offset + 35),
                                                          (Base + Offset + 36), ReadBuff);
      FieldByName('UnitType_NonAptDesc').Text := SetDescription(RecordNo,
                                                                FieldByName('UnitType_NonAptCode').Text,
                                                                UnitList,
                                                                ErrorLog);

      try
        FieldByName('TotalUnits').AsFloat := StrToFloat(GetField(5, (Base + Offset + 37),
                                                                        (Base + Offset + 41), ReadBuff));
      except
        FieldByName('TotalUnits').AsFloat := 0;
      end;

      try
        FieldByName('TotalEff1Bed').AsFloat := StrToFloat(GetField(5, (Base + Offset + 42),
                                                                   (Base + Offset + 46), ReadBuff));
      except
        FieldByName('TotalEff1Bed').AsFloat := 0;
      end;

      try
        FieldByName('Total2Bed').AsFloat := StrToFloat(GetField(5, (Base + Offset + 47),
                                                                (Base + Offset + 51), ReadBuff));
      except
        FieldByName('Total2Bed').AsFloat := 0;
      end;

      try
        FieldByName('Total3Bed').AsFloat := StrToFloat(GetField(5, (Base + Offset + 52),
                                                                (Base + Offset + 56), ReadBuff));
      except
        FieldByName('Total3Bed').AsFloat := 0;
      end;

      try
        FieldByName('TotalRent').AsFloat := StrToFloat(GetField(8, (Base + Offset + 57),
                                                                (Base + Offset + 64), ReadBuff));
      except
        FieldByName('TotalRent').AsFloat := 0;
      end;

      FieldByName('RentTypeCode').Text := GetField(1, (Base + Offset + 65),
                                                   (Base + Offset + 65), ReadBuff);
      FieldByName('RentTypeDesc').Text := SetDescription(RecordNo,
                                                         FieldByName('RentTypeCode').Text,
                                                         RentTypeList,
                                                         ErrorLog);
      try
        If ExtractAllData
          then
            begin
              If (SalesNumber > 0)
                then WriteInformationToExtractFile(SalesCommercialRentExtractFile, TempTable)
                else WriteInformationToExtractFile(CommercialRentExtractFile, TempTable);

              Cancel;
            end
          else Post;
      except
        SystemSupport(002, TempTable, 'Error Attempting to Post Comm Use Rec',
                      UnitName, GlblErrorDlgBox);
      end;
    except
      E := ExceptObject;
      Writeln(ErrorLog, 'Error in com use record ' + IntToStr(RecordNo) + ' error = ' +
              Exception(E).Message);
    end;

     {If this was a ThisYear inventory record, then copy it to NextYear
      inventory, but only if the parcel is active in ThisYear.}

  If ((SalesNumber = 0) and
      CopyToNextYear)
    then
      begin
(*        SwisSBLKey := ExtractSwisSBLFromSwisSBLKey(ThisYearTable.FieldByName('SwisSBLKey').Text);

        with SwisSBLKey do
          Found := FindKeyOld(ThisYearParcelTable,
                              ['TaxRollYr', 'SwisCode', 'Section',
                               'Subsection', 'Block', 'Lot', 'Sublot'],
                              [GlblThisYear, SwisCode,
                               Section, Subsection,
                               Block, Lot, Sublot, Suffix]);

        If (Found and
            (ThisYearParcelTable.FieldByName('ActiveFlag').Text <> InactiveParcelFlag))
          then *)(*CopyTable_OneRecord(ThisYearTable, NextYearTable,
                                   ['TaxRollYr'], [GlblNextYear]);*)

      end;  {If (SalesNumber = 0)}


end;  {AddCommercialUseRecord}

{==================================================================================}
Procedure FreeCodeTableLists;

{Free up the code table lists that we have loaded.}

begin
  FreeTList(ComBasementTypeList, SizeOf(PCodeRecord));
  FreeTList(ResBasementTypeList, SizeOf(PCodeRecord));
  FreeTList(BuildingStyleList, SizeOf(PCodeRecord));
  FreeTList(ExteriorWallList, SizeOf(PCodeRecord));
  FreeTList(FuelTypeList, SizeOf(PCodeRecord));
  FreeTList(HeatTypeList, SizeOf(PCodeRecord));
  FreeTList(PorchTypeList, SizeOf(PCodeRecord));
  FreeTList(QualityList, SizeOf(PCodeRecord));
  FreeTList(MeasurementList, SizeOf(PCodeRecord));
  FreeTList(StructureList, SizeOf(PCodeRecord));
  FreeTList(InfluenceList, SizeOf(PCodeRecord));
  FreeTList(LandTypeList, SizeOf(PCodeRecord));
  FreeTList(SoilRatingList, SizeOf(PCodeRecord));
  FreeTList(WaterfrontTypeList, SizeOf(PCodeRecord));
  FreeTList(ElevationList, SizeOf(PCodeRecord));
  FreeTList(EntryList, SizeOf(PCodeRecord));
  FreeTList(NeighborhoodList, SizeOf(PCodeRecord));
  FreeTList(NeighborhoodRatingList, SizeOf(PCodeRecord));
  FreeTList(NeighborhoodTypeList, SizeOf(PCodeRecord));
  FreeTList(PhysicalChangeList, SizeOf(PCodeRecord));
  FreeTList(PropertyClassList, SizeOf(PCodeRecord));
  FreeTList(RoadList, SizeOf(PCodeRecord));
  FreeTList(SewerList, SizeOf(PCodeRecord));

      {FXX01211998-3: The site desirability codes are different for
                      commercial and residential.}

  FreeTList(ComSiteDesirabilityList, SizeOf(PCodeRecord));
  FreeTList(ResSiteDesirabilityList, SizeOf(PCodeRecord));
  FreeTList(TrafficList, SizeOf(PCodeRecord));
  FreeTList(UtilityList, SizeOf(PCodeRecord));
  FreeTList(WaterList, SizeOf(PCodeRecord));
  FreeTList(ZoningList, SizeOf(PCodeRecord));
  FreeTList(ConditionList, SizeOf(PCodeRecord));
  FreeTList(GradeList, SizeOf(PCodeRecord));
  FreeTList(ForestRegionList, SizeOf(PCodeRecord));
  FreeTList(ForestTypeList, SizeOf(PCodeRecord));
  FreeTList(LoggingEaseList, SizeOf(PCodeRecord));
  FreeTList(AccessibilityList, SizeOf(PCodeRecord));
  FreeTList(NominalValueList, SizeOf(PCodeRecord));
  FreeTList(SiteClassList, SizeOf(PCodeRecord));
  FreeTList(CutClassList, SizeOf(PCodeRecord));
  FreeTList(VolAcreClassList, SizeOf(PCodeRecord));
  FreeTList(BoeckhModelList, SizeOf(PCodeRecord));
  FreeTList(ConstructionQualityList, SizeOf(PCodeRecord));
  FreeTList(RentTypeList, SizeOf(PCodeRecord));
  FreeTList(UnitList, SizeOf(PCodeRecord));
  FreeTList(ValuationDistList, SizeOf(PCodeRecord));

end;  {FreeCodeTableLists}

end.