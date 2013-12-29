UNIT UTILEXSD;

{$N+}

INTERFACE

USES Types, Glblvars, SysUtils, WinTypes, WinProcs, BtrvDlg,
     Messages, Dialogs, Forms, wwTable, Classes, DB, DBTables,
     Controls,DBCtrls,StdCtrls, PASTypes, WinUtils, GlblCnst, Utilitys,
     wwDBLook, Graphics, RPBase, RPDefine,  Prog, wwdbGrid, DataAccessUnit;

Procedure GetAuditEXList(SwisSBLKey : String;
                         TaxRollYr : String;
                         ExemptionTable : TTable;
                         AuditEXChangeList : TList);
{Fill a TList with the exemption information for all exemptions at this time.}

Procedure InsertAuditEXChanges(SwisSBLKey : String;
                               TaxRollYr : String;
                               AuditEXList : TList;
                               AuditEXChangeTable : TTable;
                               BeforeOrAfter : Char);
{CHG03241998-1: Track the exemption changes as a whole picture - before and after.}

Function GetExemptionAmountToDisplay(EXAppliesArray : ExemptionAppliesArrayType) : Integer;

Function ValidSwisCodeForExemptionOrSpecialDistrictCode(SwisList : TStringList;
                                                        SwisCode : String) : Boolean;

{Based on the list of swis restrictions in SwisList, see if the SwisCode fits in.
 Note that each restriction can be 2 char.'s (county), 4 char.'s (city), or
 6 char.'s (village).}

Procedure GetHomesteadAndNonhstdExemptionAmounts(    ExemptionCodes,
                                                     ExemptionHomesteadCodes,  {What is the homestead code for each exemption?}
                                                     CountyExemptionAmounts,
                                                     TownExemptionAmounts,
                                                     SchoolExemptionAmounts,
                                                     VillageExemptionAmounts : TStringList;
                                                 var HstdEXAmounts,
                                                     NonhstdEXAmounts : ExemptionTotalsArrayType);
{Given the exemption amounts and the corresponding homestead codes array,
 divide the amounts into homestead and nonhomestead totals arrays. For parcels
 that are not split, all of the amounts will go into either the homestead
 or nonhomestead array. If this is a split parcel, the totals may be split
 between the two. If this is not a designated parcel, the exemptions amounts
 will go into the homestead exemption totals array.}

Function TotalExemptionsForParcel(    TaxRollYear : String;
                                      SwisSBLKey : String;
                                      ParcelExemptionTable,
                                      EXCodeTable : TTable;
                                      ParcelHomesteadCode : String;
                                      ExemptionType : Char;  {(A)ll,(F)ixed,a(G)eds,(N)onresidential}
                                      ExemptionCodes,
                                      ExemptionHomesteadCodes,  {What is the homestead code for each exemption?}
                                      ResidentialTypes,  {What are the residential types for each exemption?}
                                      CountyExemptionAmounts,
                                      TownExemptionAmounts,
                                      SchoolExemptionAmounts,
                                      VillageExemptionAmounts : TStringList;
                                  var BasicSTARAmount,
                                      EnhancedSTARAmount : Comp) : ExemptionTotalsArrayType;
{CHG12011997 - STAR support.
               Note that the STAR amounts are never returned in the total
               exemptions. They are always treated seperately.}
{ExemptionType is 'A' for all, 'N' for all except nonresidential exemptions, 'F' for
 fixed exemption, or 'G' for all ageds.
 'N' is used to calculate aged exemption, and 'F' is used to calculate
 percentage exemptions since the fixed exemptions are applied first.}

{Go through all the exemptions and add the exemption amount. Note that
 we will check each exemption to see which it applies to.}

{Also, we will return a string list with the exemption codes. For each
 entry in the ExemptionCodes list, 4 values are returned in the Amounts
 lists (county, town, village, school) in the corresponding positions.
 That is, if exemption code 41180 is in position 2 in the ExemptionCodes
 list, position 2 of the Amounts lists gives the corresponding amount
 breakdown.
 We will also return a list of the homestead codes for each exemption.
 If this is not a split parcel, the homestead codes will be that of
 the parcel. Otherwise, it will be the homestead code of the particular
 exemption.}

Function PropertyIsCoopOrMobileHomePark(ParcelTable : TTable) : Boolean;

Function ExemptionIsBasicVeteran(sExemptionCode : String) : Boolean;

Function ExemptionIsColdWarVeteran(sExemptionCode : String) : Boolean;

Function ExemptionIsAlternativeVeteran(sExemptionCode : String) : Boolean;

Function ExemptionIsSTAR(EXCode : String) : Boolean;

Function ExemptionIsSenior(EXCode : String) : Boolean;

Function ExemptionIsLowIncomeDisabled(EXCode : String) : Boolean;

Function ExemptionIsEnhancedSTAR(EXCode : String) : Boolean;

Function ExemptionIsVolunteerFirefighter(EXCode : String) : Boolean;

Function CalculateSTARAmount(    ExemptionCodeTable,
                                 ParcelExemptionTable,
                                 ParcelTable : TTable;
                                 AssessedValue : Comp;
                                 ResidentialPercent : Real;
                                 Percent : Real;
                                 iSchoolExemptionAmount : LongInt;
                             var FullSTARAmount : Comp) : Comp;
{Given a STAR exemption code, calculate the STAR amount.
 Two items are returned - the full STAR amount (for exemption totals) and
 the actual STAR amount for this parcel. This can be different if the
 school taxable value before STAR is less than the full STAR amount.}
{CHG12011997-2: STAR support}

Procedure GetResidentialExemptionAmounts(var ResidentialExemptionAmounts,
                                             FullParcelExemptionAmounts,
                                             NonResidentialExemptionAmounts : ExemptionTotalsArrayType;
                                             ResidentialTypes,
                                             CountyExemptionAmounts,
                                             TownExemptionAmounts,
                                             SchoolExemptionAmounts,
                                             VillageExemptionAmounts : TStringList);

Function CalculateTaxableVal(AssessedValue,
                             ExemptionAmount : Comp) : Comp;
{FXX05261998-3: Don't let a taxable value decrease below 0.}
{Return the taxable value of the property for a tax type, returning
 0 if the taxable value is below 0.}

Function CalculateExemptionAmount(    ExemptionCodeTable,
                                      ParcelExemptionTable,  {Table with the current parcel exemption}
                                      ParcelExemptionLookupTable,  {Lookup table to find other exemptions.}
                                      AssessmentTable,
                                      ClassTable,
                                      SwisCodeTable,
                                      ParcelTable : TTable;
                                      TaxRollYr : String;
                                      SwisSBLKey : String;
                                  var FixedPercent : Comp;
                                  var VetMaxSet,
                                      EqualizationRateFilledIn,
                                      ExemptionRecalculated : Boolean;
                                      iLandValue : LongInt;
                                      iAssessedValue : LongInt;
                                      bUseOverrideAssessedValue : Boolean) : ExemptionTotalsArrayType;
{Calculate the amount for this exemption based on the exemption calc code and the exemption code
 itself.}

Procedure RecalculateExemptionsForParcel(ExemptionCodeTable,
                                         ParcelExemptionTable,
                                         AssessmentTable,
                                         ClassTable,
                                         SwisCodeTable,
                                         ParcelTable : TTable;
                                         TaxRollYear : String;
                                         SwisSBLKey : String;
                                         ExemptionsNotRecalculatedList : TStringList;
                                         iLandValue : LongInt;
                                         iAssessedValue : LongInt;
                                         bUseOverrideAssessedValue : Boolean);
{Recalculate all the exemptions for this parcel.}

Function ExApplies(ExCode : String;
                   AppliesToVillage : Boolean) : ExemptionAppliesArrayType;
{Determine if the exemption applies to county, town, village, or school. An array of
 Booleans is returned with 1=County, 2=Town, 3=Village, 4=School.}

Function GetResidentialPercent(ParcelTable,
                               ExemptionCodeTable : TTable;
                               EXCode : String) : Real;
 
Function ExemptionExistsForParcel(ExemptionCode : String;
                                  TaxRollYear : String;
                                  SwisSBLKey : String;
                                  ComparisonLength : Integer;  {Number of chars to compare on}
                                  ParcelExemptionTable : TTable) : Boolean;
{Go through all the exemptions and see if this exemption code exists.}

Procedure GetExemptionCodesForParcel(TaxRollYr : String;
                                     SwisSBLKey : String;
                                     ExemptionTable : TTable;
                                     ExemptionList : TStringList);
{Return a list of the exemption codes on a parcel.}

Procedure DisplayExemptionsNotRecalculatedForm(MasterExemptionsNotRecalculatedList : TStringList);

Procedure RecalculateAllExemptions(    Form : TForm;
                                       ProgressDialog : TProgressDialog;
                                       ProcessingType : Integer;
                                       AssessmentYear : String;
                                       DisplayExemptionsNotRecalculated : Boolean;
                                   var Quit : Boolean);

Function IsBIEExemptionCode(ExemptionCode : String) : Boolean;

Function ParcelHasSTAR(ExemptionTable : TTable;
                       SwisSBLKey : String;
                       AssessmentYear : String) : Boolean;

Procedure DetermineExemptionReadOnlyAndRequiredFields(    ExemptionCodeLookupTable : TTable;
                                                          ParcelTable : TTable;
                                                          ExemptionCode : String;
                                                      var AmountFieldRequired : Boolean;
                                                      var AmountFieldReadOnly : Boolean;
                                                      var PercentFieldRequired : Boolean;
                                                      var PercentFieldReadOnly : Boolean;
                                                      var OwnerPercentFieldRequired : Boolean;
                                                      var OwnerPercentFieldReadOnly : Boolean;
                                                      var TerminationDateRequired : Boolean);

Procedure DetermineAssessedAndTaxableValues(    AssessmentYear : String;
                                                SwisSBLKey : String;
                                                HomesteadCode : String;
                                                ExemptionTable : TTable;
                                                ExemptionCodeTable : TTable;
                                                AssessmentTable : TTable;
                                            var LandAssessedValue : LongInt;
                                            var TotalAssessedValue : LongInt;
                                            var CountyTaxableValue : LongInt;
                                            var MunicipalTaxableValue : LongInt;
                                            var SchoolTaxableValue : LongInt;
                                            var VillageTaxableValue : LongInt;
                                            var BasicSTARAmount : LongInt;
                                            var EnhancedSTARAmount : LongInt);

Function ProjectExemptions(tbSourceExemptions : TTable;
                           sTaxYear : String;
                           sSwisSBLKey : String;
                           iLandValue : LongInt;
                           iAssessedValue : LongInt;
                           iProcessingType : Integer) : ExemptionTotalsArrayType;

Procedure InsertOneSDChangeTrace(SwisSBLKey : String;
                                 TaxRollYr : String;
                                 ParcelSDistTable,
                                 AuditSDChangeTable : TTable;
                                 RecordType : Char;
                                 OrigSDRec : AuditSDRecord);
{CHG03161998-1: Track exemption, SD adds, av changes, parcel add/del.}

Procedure InsertAuditSDChanges(SwisSBLKey : String;
                               TaxRollYr : String;
                               ParcelSDTable,
                               AuditSDChangeTable : TTable;
                               RecordType : Char);
{CHG03301998-1: Trace SD, EX changes from everywhere.}
{Insert an add or delete trace record for all sd's for this parcel.}

Function SdExtType (ExtCode : String): Char;

Function ExemptionAppliesToSpecialDistrict(DistrictType : String;
                                           ExemptionCodeRec : ExemptionCodeRecord;
                                           CMFlag : String;
                                           SDAppliesToSection490,
                                           FireDistrict,
                                           VolunteerFirefighterOrAmbulanceExemptionApplies : Boolean) : Boolean; overload;

Function ExemptionAppliesToSpecialDistrict(ExemptionCodeRec : ExemptionCodeRecord;
                                           SpecialDistrictCodeRec : SpecialDistrictCodeRecord) : Boolean; overload;

Function ExemptionAppliesToSpecialDistrict(SpecialDistrictCodeTable : TTable;
                                           ExemptionCodeTable : TTable;
                                           SpecialDistrictCode : String;
                                           ExemptionCode : String) : Boolean; overload;

Procedure CalculateSpecialDistrictAmounts(ParcelTable,
                                          AssessmentTable,
                                          ClassTable,
                                          ParcelSDTable,
                                          SDCodeTable : TTable;
                                          ParcelExemptionList,
                                          ExemptionCodeList : TList;
                                          SDExtensionCodes,  {Return lists}
                                          SDCC_OMFlags,
                                          slAssessedValues,
                                          SDValues,
                                          HomesteadCodesList : TStringList);
{Based on the special district code, calculate the "values" of this special district. This can mean
 many different things based on the type of district it is. The values returned will always be in
 correspondence to the type of the district itself. That is, if this is unitary, units will be returned.
 If this is acreage based, acres will be returned, etc.

 Note that since a special district may have many extension codes, what is return is a TStringList where each
 entry is of type extended in string format and corresponds in order to the extension codes. That is, the first
 entry in the TStringList is the value of the first extension code in the SDExtensionCodes list, etc.
 Also, for roll totals purposes, we will return the corresponding CC_OM Flags in the list SDCC_OMFlags.}

Procedure LoadExemptions(TaxRollYear : String;
                         SwisSBLKey : String;
                         ParcelExemptionList,
                         ExemptionCodeList : TList;
                         ParcelExemptionTable,
                         ExemptionCodeTable : TTable);
{CHG02221998-1 : For quicker roll total calcs,
                 only read exemptions 1 time.}

Procedure TotalSpecialDistrictsForParcel(TaxRollYr : String;
                                         SwisSBLKey : String;
                                         ParcelTable,
                                         AssessmentTable,
                                         ParcelSDTable,
                                         SDCodeTable,
                                         ParcelEXTable,
                                         EXCodeTable : TTable;
                                         SDAmounts : TList);  {This is the return list of type PParcelExemptionRecord.}

{This calculates all values for all special districts on one parcel.
 The information is returned in a TList where each element is of type
 PParcelSDValuesRecord.}

Function SpecialDistrictIsMoveTax(SDCodeTable : TTable) : Boolean;

Procedure AddOneSpecialDistrict(      SpecialDistrictTable : TTable;
                                const FieldNames : Array of const;
                                const FieldValues : Array of const;
                                      UserName : String);

Function GetExemptionTypeDescription(ExemptionCode : String) : String;

Procedure DeleteAnExemption(tb_Exemptions : TTable;
                            tb_ExemptionsLookup : TTable;
                            tb_RemovedExemptions : TTable;
                            tb_AuditEXChange : TTable;
                            tb_Audit : TTable;
                            tb_Assessment : TTable;
                            tb_Class : TTable;
                            tb_SwisCode : TTable;
                            tb_Parcel : TTable;
                            tb_ExemptionCode : TTable;
                            AssessmentYear : String;
                            SwisSBLKey : String;
                            ExemptionsNotRecalculatedList : TStringList);

Function ParcelHasOverrideSpecialDistricts(tbParcelSpecialDistricts : TTable;
                                           sAssessmentYear : String;
                                           sSwisSBLKey : String) : Boolean;
                            
IMPLEMENTATION

uses PASUTILS, ExemptionsNotRecalculatedFormUnit;

{==========================================================================}
{=============    EXEMPTION CALCULATION ===================================}
{==========================================================================}
{=============================================================}
Procedure GetAuditEXList(SwisSBLKey : String;
                         TaxRollYr : String;
                         ExemptionTable : TTable;
                         AuditEXChangeList : TList);

{Fill a TList with the exemption information for all exemptions at this time.}

var
  Done, Quit, FirstTimeThrough : Boolean;
  PAuditEXRec : PAuditEXRecord;

begin
  Done := False;
  Quit := False;
  FirstTimeThrough := True;
  ExemptionTable.CancelRange;

  SetRangeOld(ExemptionTable, ['TaxRollYr', 'SwisSBLKey', 'ExemptionCode'],
              [TaxRollYr, SwisSBLKey, '     '],
              [TaxRollYr, SwisSBLKey, 'ZZZZZ']);
  ExemptionTable.First;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else
        try
          ExemptionTable.Next;
        except
          Quit := False;
          SystemSupport(950, ExemptionTable, 'Error getting next exemption record.',
                        GlblUnitName, GlblErrorDlgBox);
        end;

    If ExemptionTable.EOF
      then Done := True;

    If not (Done or Quit)
      then
        begin
          New(PAuditEXRec);

          with PAuditEXRec^, ExemptionTable do
            begin
              ExemptionCode := FieldByName('ExemptionCode').Text;
              CountyAmount := FieldByName('CountyAmount').AsFloat;
              TownAmount := FieldByName('TownAmount').AsFloat;
              SchoolAmount := FieldByName('SchoolAmount').AsFloat;
              VillageAmount := FieldByName('VillageAmount').AsFloat;
              Percent := FieldByName('Percent').AsFloat;
              OwnerPercent := FieldByName('OwnerPercent').AsFloat;
              InitialDate := FieldByName('InitialDate').AsDateTime;
              TerminationDate := FieldByName('TerminationDate').AsDateTime;

            end;  {with PAuditEXRec^, ExemptionTable do}

          AuditEXChangeList.Add(PAuditEXRec);

        end;  {If not (Done or Quit)}

  until (Done or Quit);

    {FXX07172001-1: The range was not being cancelled.}

  ExemptionTable.CancelRange;

end;  {GetAuditEXList}

{=============================================================}
Procedure InsertAuditEXChanges(SwisSBLKey : String;
                               TaxRollYr : String;
                               AuditEXList : TList;
                               AuditEXChangeTable : TTable;
                               BeforeOrAfter : Char);

{CHG03241998-1: Track the exemption changes as a whole picture - before and after.}
{For each exemption, store all the information in the audit ex list to get a
 complete picture of all exemption before any changes and after.}

var
  I : Integer;

begin
  For I := 0 to (AuditEXList.Count - 1) do
    with PAuditEXRecord(AuditEXList[I])^, AuditEXChangeTable do
      begin
        Insert;

        FieldByName('SwisSBLKey').Text := SwisSBLKey;
        FieldByName('TaxRollYr').Text := TaxRollYr;
        FieldByName('ExemptionCode').Text := ExemptionCode;
        FieldByName('Date').AsDateTime := Date;
        FieldByName('Time').AsDateTime := Now;
        FieldByName('User').Text := GlblUserName;
        FieldByName('BeforeOrAfter').Text := BeforeOrAfter;

        FieldByName('Percent').AsFloat := Percent;
        FieldByName('CountyAmount').AsFloat := CountyAmount;
        FieldByName('TownAmount').AsFloat := TownAmount;
        FieldByName('SchoolAmount').AsFloat := SchoolAmount;
        FieldByName('VillageAmount').AsFloat := VillageAmount;
        FieldByName('OwnerPercent').AsFloat := OwnerPercent;
        FieldByName('InitialDate').AsDateTime := InitialDate;
        FieldByName('TerminationDate').AsDateTime := TerminationDate;

        try
          Post;
        except
          SystemSupport(951, AuditEXChangeTable, 'Error inserting exemption add\deletion trace rec.',
                        GlblUnitName, GlblErrorDlgBox);
        end;

      end;  {with PAuditEXRecord(AuditEXList[I])^, AuditEXChangeTable do}

end;  {InsertEXChangeTrace}

{==============================================================}
Function GetExemptionAmountToDisplay(EXAppliesArray : ExemptionAppliesArrayType) : Integer;

{CHG10151997-3: The amount field in the grid is now a "calculated" field
                which is not part of the database. This is because
                if we show just town amount, a county only exemption
                will have an amount of zero.}
{Show the town amount if there is one. Otherwise, county,
 school, or village in that order.}

begin
  If EXAppliesArray[ExTown]
    then Result := EXTown
    else
      If EXAppliesArray[ExCounty]
        then Result := EXCounty
        else
          If EXAppliesArray[ExSchool]
            then Result := EXSchool
            else Result := EXVillage;

end;  {GetExemptionAmountToDisplay}

{====================================================================================}
Function ValidSwisCodeForExemptionOrSpecialDistrictCode(SwisList : TStringList;
                                                        SwisCode : String) : Boolean;

{Based on the list of swis restrictions in SwisList, see if the SwisCode fits in.
 Note that each restriction can be 2 char.'s (county), 4 char.'s (city), or
 6 char.'s (village).}

var
  I, SwisLength : Integer;

begin
  If (SwisList.Count = 0)
    then Result := True  {There are no restrictions, so any swis is valid.}
    else
      begin
          {Search through the list comparing the swis code to the restrictions.}

        Result := False;

        For I := 0 to (SwisList.Count - 1) do
          begin
            SwisLength := Length(Trim(SwisList[I]));

            If (Take(SwisLength, SwisList[I]) = Take(SwisLength, SwisCode))
              then Result := True;

          end;  {For I := 0 to (SwisList.Count - 1) do}

      end;  {else of If (SwisList.Count = 0)}

end;  {ValidSwisCodeForExemptionOrSpecialDistrictCode}

{===========================================================================}
Procedure GetHomesteadAndNonhstdExemptionAmounts(    ExemptionCodes,
                                                     ExemptionHomesteadCodes,  {What is the homestead code for each exemption?}
                                                     CountyExemptionAmounts,
                                                     TownExemptionAmounts,
                                                     SchoolExemptionAmounts,
                                                     VillageExemptionAmounts : TStringList;
                                                 var HstdEXAmounts,
                                                     NonhstdEXAmounts : ExemptionTotalsArrayType);

{Given the exemption amounts and the corresponding homestead codes array,
 divide the amounts into homestead and nonhomestead totals arrays. For parcels
 that are not split, all of the amounts will go into either the homestead
 or nonhomestead array. If this is a split parcel, the totals may be split
 between the two. If this is not a designated parcel, the exemptions amounts
 will go into the homestead exemption totals array.}

var
  I  : Integer;

begin
  For I := 1 to 4 do
    begin
      HstdExAmounts[I] := 0;
      NonhstdExAmounts[I] := 0;
    end;

  For I := 0 to (ExemptionCodes.Count - 1) do
    If (ExemptionHomesteadCodes[I] = 'N')
      then
        begin
          NonhstdExAmounts[ExCounty] := NonHstdEXAmounts[EXCounty] +
                                        StrToFloat(CountyExemptionAmounts[I]);
          NonhstdExAmounts[ExTown] := NonHstdEXAmounts[EXTown] +
                                      StrToFloat(TownExemptionAmounts[I]);
          NonhstdExAmounts[ExSchool] := NonHstdEXAmounts[EXSchool] +
                                        StrToFloat(SchoolExemptionAmounts[I]);
          NonhstdExAmounts[ExVillage] := NonHstdEXAmounts[EXVillage] +
                                         StrToFloat(VillageExemptionAmounts[I]);

        end
      else
        begin
            {If the homestead code is ' ' or 'H'.}

          HstdExAmounts[ExCounty] := HstdExAmounts[ExCounty] +
                                     StrToFloat(CountyExemptionAmounts[I]);
          HstdExAmounts[ExTown] := HstdExAmounts[ExTown] +
                                   StrToFloat(TownExemptionAmounts[I]);
          HstdExAmounts[ExSchool] := HstdExAmounts[ExSchool] +
                                     StrToFloat(SchoolExemptionAmounts[I]);
          HstdExAmounts[ExVillage] := HstdExAmounts[ExVillage] +
                                      StrToFloat(VillageExemptionAmounts[I]);

        end;  {else of If (ExemptionHomesteadCodes[I] = 'N')}

end;  {GetHomesteadAndNonhstdExemptionAmounts}

{===========================================================================}
Function TotalExemptionsForParcel(    TaxRollYear : String;
                                      SwisSBLKey : String;
                                      ParcelExemptionTable,
                                      EXCodeTable : TTable;
                                      ParcelHomesteadCode : String;
                                      ExemptionType : Char;  {(A)ll,(F)ixed,a(G)eds,(N)onresidential}
                                      ExemptionCodes,
                                      ExemptionHomesteadCodes,  {What is the homestead code for each exemption?}
                                      ResidentialTypes,  {What are the residential types for each exemption?}
                                      CountyExemptionAmounts,
                                      TownExemptionAmounts,
                                      SchoolExemptionAmounts,
                                      VillageExemptionAmounts : TStringList;
                                  var BasicSTARAmount,
                                      EnhancedSTARAmount : Comp) : ExemptionTotalsArrayType;

{CHG12011997 - STAR support.
               Note that the STAR amounts are never returned in the total
               exemptions. They are always treated seperately.}

{ExemptionType is 'A' for all, 'N' for all except nonresidential exemptions,
'F' for fixed exemption, or 'G' for all ageds.
 'N' is used to calculate aged exemption, and 'F' is used to calculate
 percentage exemptions since the fixed exemptions are applied first.}

{Go through all the exemptions and add the exemption amount. Note that
 we will check each exemption to see which it applies to.}

{Also, we will return a string list with the exemption codes. For each
 entry in the ExemptionCodes list, 4 values are returned in the Amounts
 lists (county, town, village, school) in the corresponding positions.
 That is, if exemption code 41180 is in position 2 in the ExemptionCodes
 list, position 2 of the Amounts lists gives the corresponding amount
 breakdown.}

var
  ExemptArray : ExemptionTotalsArrayType;
  ApplyThisExemption, Done, Quit, FirstTimeThrough : Boolean;
  I, ProcessingType : Integer;
  OrigIndexName, TempStr : String;
  CalcMethod, TempHomesteadCode : String;
  EXCode : String;

begin
  ExemptionCodes.Clear;
  ExemptionHomesteadCodes.Clear;
  CountyExemptionAmounts.Clear;
  TownExemptionAmounts.Clear;
  VillageExemptionAmounts.Clear;
  SchoolExemptionAmounts.Clear;
    {FXX02091998-1: Pass the residential type of each exemption.}
  ResidentialTypes.Clear;

  For I := 1 to 4 do
    ExemptArray[I] := 0;

  BasicSTARAmount := 0;
  EnhancedSTARAmount := 0;

  OrigIndexName := ParcelExemptionTable.IndexName;
  ParcelExemptionTable.IndexName := 'BYTAXROLLYR_SWISSBLKEY';

  ParcelExemptionTable.CancelRange;
  LogTime('c:\trace.txt', 'Before TotalExemptionForParcel SetRange - ' + TaxRollYear + '/' + SwisSBLKey);
  SetRangeOld(ParcelExemptionTable,
              ['TaxRollYr', 'SwisSBLKey'],
              [TaxRollYear, SwisSBLKey],
              [TaxRollYear, SwisSBLKey]);
  LogTime('c:\trace.txt', 'After TotalExemptionForParcel SetRange');


  Done := False;
  Quit := False;
  FirstTimeThrough := True;

  ParcelExemptionTable.First;

  If not (Done or Quit)
    then
      repeat
        If FirstTimeThrough
          then FirstTimeThrough := False
          else ParcelExemptionTable.Next;

          {If the SBL changes or we are at the end of the range, we are done.}

        TempStr := ParcelExemptionTable.FieldByName('SwisSBLKey').Text;

        If ParcelExemptionTable.EOF
          then Done := True;

          {We have an exemption record, so get the totals.}

        If not (Done or Quit)
          then
            begin
              ApplyThisExemption := True;

              FindKeyOld(EXCodeTable, ['EXCode'],
                         [ParcelExemptionTable.FieldByName('ExemptionCode').Text]);

                {Now see if this exemption should be applied or not. If ExemptionType
                 is 'N', then we do not want to apply any exemptions which are non-residential
                 i.e. ResidentialType = 'N'. Also, if this is an aged, we don't want to
                 apply it.
                 If ExemptionType = 'F', then we only want to apply amount exemptions - these
                 are exemptions with CalcMethod = F,T,I,L, or V.}

              If (ExemptionType in ['N', 'F'])
                then
                  begin
                      {CHG04161998-1: Add the 4193x limited income diabled
                                      exemption. It is the same as 4180x.}
                      {CHG12291998-1: Malta has 4190x physically disabled limited income
                                      which is same as senior.}
                      {FXX04281999-1: 41900 is calculated before 41800.}
                      {CHG08132008-1(2.15.1.5): Add 4191x as a low income disabled exemption.}

                    If ((ExemptionType = 'N') and
                        ((Deblank(EXCodeTable.FieldByName('ResidentialType').Text) = 'N') or
                         ExemptionIsLowIncomeDisabled(ParcelExemptionTable.FieldByName('ExemptionCode').AsString) or
                         (*(Take(4, ParcelExemptionTable.FieldByName('ExemptionCode').Text) = '4190') or *)
                         (Take(4, ParcelExemptionTable.FieldByName('ExemptionCode').Text) = '4180')))
                      then ApplyThisExemption := False;

                    CalcMethod := Take(1, EXCodeTable.FieldByName('CalcMethod').Text);

                    If ((ExemptionType = 'F') and
                         (not (CalcMethod[1] in ['F', 'T', 'I', 'L', 'V'])))
                      then ApplyThisExemption := False;

                  end;  {If (ExemptionType in ['N', 'F'])}

                {Is this an aged exemption?}

              EXCode := ParcelExemptionTable.FieldByName('ExemptionCode').Text;

              If ((ExemptionType = 'G') and
                  (Take(4, EXCode) <> '4180'))
                then ApplyThisExemption := False;

                {FXX07142010-1(2.26.1.7)[I7782]: Don't include the senior exemption even if the calc code is odd.}

              If (_Compare(ExemptionType, 'F', coEqual) and
                  _Compare(EXCode, '4180', coStartsWith))
              then ApplyThisExemption := False;

                {CHG12011997-2: STAR support.}
                {Do not add STAR exemptions to the overall exemption amounts -
                 they are treated seperately.}

              with ParcelExemptionTable do
                If ((Take(4, EXCode) = '4183') or
                    (Take(4, EXCode) = '4185'))
                  then
                    begin
                      ApplyThisExemption := False;

                      If (Take(4, EXCode) = '4183')
                        then EnhancedSTARAmount := EnhancedSTARAmount +
                                                   TCurrencyField(FieldByName('SchoolAmount')).Value;

                      If (Take(4, EXCode) = '4185')
                        then BasicSTARAmount := BasicSTARAmount +
                                                TCurrencyField(FieldByName('SchoolAmount')).Value;

                    end;  {If ((Take(4, EXCode) = '4183') or ...}

                {If we want to add this exemption to the exemption total, then do so.}

              If ApplyThisExemption
                then
                  with ParcelExemptionTable do
                    begin
                      ExemptionCodes.Add(FieldByName('ExemptionCode').Text);

                        {If this is not a split parcel, just use the
                         homestead code of the overall parcel.
                         Otherwise, if the homestead code is filled in
                         for this exemption, use this homestead code.}

                      TempHomesteadCode := Take(1, ParcelHomesteadCode);

                      If ((ParcelHomesteadCode = 'S') and
                          (Deblank(TempHomesteadCode) <> ''))
                        then TempHomesteadCode := FieldByName('HomesteadCode').Text;

                      ExemptionHomesteadCodes.Add(TempHomesteadCode);

                      ExemptArray[EXCounty] := ExemptArray[EXCounty] + TCurrencyField(FieldByName('CountyAmount')).Value;
                      ExemptArray[EXTown] := ExemptArray[EXTown] + TCurrencyField(FieldByName('TownAmount')).Value;
                      ExemptArray[EXSchool] := ExemptArray[EXSchool] + TCurrencyField(FieldByName('SchoolAmount')).Value;

                        {CHG05142002-1: Village processing}
                        {CHG03132004-2(2.08): If this municipality does not have a village that takes a partial roll,
                                              use the town amount for the village.}
                        {FXX02112005-1(2.8.3.7): If this is a municipality that has a village with
                                                 different exemptions, only apply to the village
                                                 if the apply to village flag is on.}

                      If (VillageIsAssessingUnit(Copy(SwisSBLKey, 1, 6)) and
                          (rtdVillageReceivingPartialRoll in GlblRollTotalsToShow))
                        then
                          begin
                            If (FieldByName('ApplyToVillage').AsBoolean or
                                (FieldByName('ExemptionCode').Text[5] = '7'))
                              then ExemptArray[EXVillage] := ExemptArray[EXVillage] + TCurrencyField(FieldByName('VillageAmount')).Value;

                          end
                        else ExemptArray[EXVillage] := ExemptArray[EXVillage] + TCurrencyField(FieldByName('TownAmount')).Value;

                      CountyExemptionAmounts.Add(FloatToStr(TCurrencyField(FieldByName('CountyAmount')).Value));
                      TownExemptionAmounts.Add(FloatToStr(TCurrencyField(FieldByName('TownAmount')).Value));
                      SchoolExemptionAmounts.Add(FloatToStr(TCurrencyField(FieldByName('SchoolAmount')).Value));

                        {CHG05142002-1: Village processing}
                        {CHG03132004-2(2.08): If this municipality does not have a village that takes a partial roll,
                                              use the town amount for the village.}

                        {FXX02112005-1(2.8.3.7): If this is a municipality that has a village with
                                                 different exemptions, only apply to the village
                                                 if the apply to village flag is on.}
                        {FXX09112008-1(2.15.1.11): Only check to see if the exemption applies to the village
                                                   if this is an assessing unit.  Otherwise, it always does.}

                      If (VillageIsAssessingUnit(Copy(SwisSBLKey, 1, 6)) and
                          (rtdVillageReceivingPartialRoll in GlblRollTotalsToShow))
                        then
                          begin
                            If (FieldByName('ApplyToVillage').AsBoolean or
                                (FieldByName('ExemptionCode').Text[5] = '7'))
                              then VillageExemptionAmounts.Add(FloatToStr(TCurrencyField(FieldByName('VillageAmount')).Value))
                              else VillageExemptionAmounts.Add('0');

                          end
                        else VillageExemptionAmounts.Add(FloatToStr(TCurrencyField(FieldByName('TownAmount')).Value));

                        {FXX02091998-1: Pass the residential type of each exemption.}

                      ResidentialTypes.Add(EXCodeTable.FieldByName('ResidentialType').Text);

                    end;  {with ParcelExemptionTable do}

            end;  {If not (Done or Quit)}

      until (Done or Quit);

  LogTime('c:\trace.txt', 'After TotalExemptionForParcel loop');
  If (OrigIndexName <> ParcelExemptionTable.IndexName)
    then ParcelExemptionTable.IndexName := OrigIndexName;
  LogTime('c:\trace.txt', 'After TotalExemptionForParcel loop2');

  Result := ExemptArray;

end;  {TotalExemptionsForParcel}

{==========================================================================}
Function ExApplies(ExCode : String;
                   AppliesToVillage : Boolean) : ExemptionAppliesArrayType;

{Determine if the exemption applies to county, town, village, or school. An array of
 Booleans is returned with 1=County, 2=Town, 3=Village, 4=School.
 Note that the exemption applies to the village only if the village flag is on at the
 parcel exemption level.}

var
  I : Integer;
  ExemptAppliesArray : ExemptionAppliesArrayType;

begin
  For I := 1 to 4 do
    ExemptAppliesArray[I] := False;

  If (ExCode[5] in ['0','1','2','5'])
    then ExemptAppliesArray[RTCounty] := True;

    {FXX12161998-6: If an exemption applies in the town, it applies in the village.}

    {FXX02192004-1(2.07l1): An exemption code with a '7' applies to village only.
                            Also, don't make it so that a town automatically applies to
                            a village. Only applies if it is a '7' or AppliesToVillage is true.}

  If (EXCode[5] in ['0','1','3','6'])
    then ExemptAppliesArray[RTTown] := True;

   {CHG03132004-2(2.08): If this municipality does not have a village that takes a partial roll,
                         use the town applies status for the village.}

  If (rtdVillageReceivingPartialRoll in GlblRollTotalsToShow)
    then
      begin
        If AppliesToVillage
          then ExemptAppliesArray[RTVillage] := True;

        If (ExCode[5] in ['7'])
          then ExemptAppliesArray[RTVillage] := True;
      end
    else ExemptAppliesArray[RTVillage] := ExemptAppliesArray[RTTown];

  If (ExCode[5] in ['0','4','5','6'])
    then ExemptAppliesArray[RTSchool] := True;

  Result := ExemptAppliesArray;

end;  {ExApplies}

{==========================================================================}
Function GetResidentialPercent(ParcelTable,
                               ExemptionCodeTable : TTable;
                               EXCode : String) : Real;

{If there is a residential percent and this is a residential or
 non-residential exemption, then only part of the land and total
 value is used for the exemption calculation. Notice that this is
 applied to the assessed value minus the other exemptions "above"
 this exemption have been applied.

 For example, if a property has a total value of $10,000 and an 41101
 (vet elig fund) exemption for $2,000 and an aged 41800 of 50% with
 a residential percent of 40%, the 41800 is (10000 - 2000) * 0.5 * 0.4 = $1600.}

var
  ResidentialPercent : Real;
  ResType : Char;

begin
  Result := 1;

    {FXX02031998-1: Need to make sure the exemption table is pointing
                    to the correct exemption.}

  FindKeyOld(ExemptionCodeTable, ['EXCode'], [EXCode]);

  ResidentialPercent := TFloatField(ParcelTable.FieldByName('ResidentialPercent')).Value;

     {This is not a classified municipality, so if this is a residential exemption, we need
      to multiply the assessed values by the residential percent. If this is a non-residential
      exemption, we need to multiply the assessed values by 100 - residential percent.}

  If (Roundoff(ResidentialPercent, 0) <> 0)
    then
      begin
        ResType := ExemptionCodeTable.FieldByName('ResidentialType').Text[1];

          {FXX02021998-5: Apply residential percent correctly on a per
                          exemption basis based on what the exemption
                          applies to.}

        If (ResType = 'R')
          then Result := Roundoff((ResidentialPercent/100), 2);

        If (ResType = 'N')
          then Result := Roundoff(((100 - ResidentialPercent)/100), 2);

          {If it applies to both residential and non-residential,
           the percent should be 100 regardless of whether or not there
           is a percent.}

        If (ResType = 'B')
          then Result := 1;

      end  {If (Roundoff(ResidentialPercent, 0) <> 0)}
    else Result := 1;

end;  {GetResidentialPercent}

{==========================================================================}
Function ExemptionIsSTAR(EXCode : String) : Boolean;

begin
  Result := (Take(4, EXCode) = '4183') or
             (Take(4, EXCode) = '4185');

end;  {ExemptionIsSTAR}

{==========================================================================}
Function ExemptionIsSenior(EXCode : String) : Boolean;

begin
  Result := (Take(4, EXCode) = '4180');

end;  {ExemptionIsSenior}

{==========================================================================}
Function ExemptionIsLowIncomeDisabled(EXCode : String) : Boolean;

{CHG08132008-1(2.15.1.5): Add 4191x as a low income disabled exemption.}
{FXX01102013(MDT): 4190 exemption is not income based.}

begin
  Result := (*_Compare(EXCode, '4190', coStartsWith) or *)
            _Compare(EXCode, '4191', coStartsWith) or
            _Compare(EXCode, '4193', coStartsWith);

end;  {ExemptionIsLowIncomeDisabledr}

{==========================================================================}
Function ExemptionIsEnhancedSTAR(EXCode : String) : Boolean;

begin
  Result := (Take(4, EXCode) = '4183');

end;  {ExemptionIsEnhancedSTAR}

{==========================================================================}
Function ExemptionIsBasicVeteran(sExemptionCode : String) : Boolean;

begin
  Result := (_Compare(sExemptionCode, '4100', coStartsWith) or
             _Compare(sExemptionCode, '4110', coStartsWith) or
             _Compare(sExemptionCode, '4111', coStartsWith) or
             _Compare(sExemptionCode, '4120', coStartsWith) or
             _Compare(sExemptionCode, '4130', coStartsWith));

end;  {ExemptionIsBasicVeteran}

{==========================================================================}
Function ExemptionIsAlternativeVeteran(sExemptionCode : String) : Boolean;

begin
  Result := (_Compare(sExemptionCode, '4112', coStartsWith) or
             _Compare(sExemptionCode, '4113', coStartsWith) or
             _Compare(sExemptionCode, '4114', coStartsWith));

end;  {ExemptionIsAlternativeVeteran}

{==========================================================================}
Function ExemptionIsColdWarVeteran(sExemptionCode : String) : Boolean;

begin
  Result := (_Compare(sExemptionCode, '4115', coStartsWith) or
             _Compare(sExemptionCode, '4116', coStartsWith) or
             _Compare(sExemptionCode, '4117', coStartsWith))

end;  {ExemptionIsColdWarVeteran}

{==========================================================================}
Function ExemptionIsDisabledColdWarVeteran(sExemptionCode : String) : Boolean;

begin
  Result := _Compare(sExemptionCode, '4117', coStartsWith);

end;  {ExemptionIsDisabledWarVeteran}

{==========================================================================}
Function ExemptionIsVolunteerFirefighter(EXCode : String) : Boolean;

{CHG03242004-1(2.07l2): Firefighter exemption is 41681 not 41661 for Westchester.}
{FXX06022008-1(2.13.1.6): 4164 is the start of the firefighter code in New Castle.}
{FXX03092008-1(2.17.1.5): 4163x is, too.}

begin
  Result := ((Take(4, EXCode) = '4163') or
             (Take(4, EXCode) = '4164') or
             (Take(4, EXCode) = '4166') or
             (Take(4, EXCode) = '4167') or
             (Take(4, EXCode) = '4168'));

end;  {ExemptionIsVolunteerFirefighter}

{==========================================================================}
Function PropertyIsCoopOrMobileHomePark(ParcelTable : TTable) : Boolean;

{FXX12011998-18: Ownership code of C (condo) counts the same as P (co-op) for
                 vets, senior, STARs.}
{FXX01201999-1: Actually, condos are not the same as co-ops.}
{CHG09152003-1: Actually extend this to any 400 property class.}
{CHG10072003-1(2.07j): Actually, don't include 412 or 411C in this group.}

begin
  with ParcelTable do
    begin
        {CHG01222006-1(2.9.5.1): Allow a municipality to treat all mixed-use parcels as residentials for
                                 exemption calculation purposes.}
        {CHG12122006-1(2.11.1.5): Accomodate waterfront ownership codes.}

      Result := (_Compare(FieldByName('OwnershipCode').AsString, ['P', 'Q'], coEqual) or  {Co-op, waterfront co-op}
                 _Compare(FieldByName('PropertyClassCode').AsString, MobileHomePropertyClass, coEqual) or
                 ((not GlblTreatMixedUseParcelsAsResidential) and
                  _Compare(FieldByName('PropertyClassCode').AsString, '4', coStartsWith)));  {Commercial, at user discretion}

        {FXX07262004-2(2.07l5): Treat 483 (Converted Residence) as a regular 210.}

      If (Result and
          _Compare(FieldByName('PropertyClassCode').AsString, ['412', '483'], coEqual) or
          (_Compare(FieldByName('PropertyClassCode').AsString, '411', coEqual) and
           _Compare(FieldByName('OwnershipCode').AsString, ['C', 'D'], coEqual)))  {Condo, condo waterfront}
        then Result := False;

    end;  {with ParcelTable do}

end;  {PropertyIsCoopOrMobileHomePark}

{==========================================================================}
Procedure GetColdWarVetPercentandLimit(    tbAssessmentYearControl : TTable;
                                           tbSwisCodes : TTable;
                                           iColdWarVeteranType : Integer;
                                           iJurisdiction : Integer;
                                           sSwisCode : String;
                                       var fPercent : Double;
                                       var iLimit : LongInt);

var
  tbColdWarVeteranLimts : TTable;
  sLimitSet : String;

begin
  iLimit := 0;
  fPercent := 0;
  tbColdWarVeteranLimts := nil;
  tbAssessmentYearControl.Refresh;

  try
    tbColdWarVeteranLimts := TTable.Create(nil);

    _OpenTable(tbColdWarVeteranLimts, 'zcoldwarvetlimits', '', 'BYVETLIMITCODE',
               NoProcessingType, []);

    case iJurisdiction of
      EXCounty : sLimitSet := tbAssessmentYearControl.FieldByName('ColdWarVetCntyLimitSet').AsString;
      
      EXMunicipal,
      EXVillage :
        begin
          _Locate(tbSwisCodes, [sSwisCode], '', []);
          sLimitSet := tbSwisCodes.FieldByName('ColdWarVetMunicLimitSet').AsString;
        end;

    end;  {case iJurisdiction of}

    _Locate(tbColdWarVeteranLimts, [sLimitSet], '', []);

    with tbColdWarVeteranLimts do
      begin
        case iColdWarVeteranType of
          cwvBasic :
            begin
              fPercent := FieldByName('BasicPercent').AsFloat;
              iLimit := FieldByName('BasicLimit').AsInteger;
            end;

          cwvDisabled : iLimit := FieldByName('DisabledVetLimit').AsInteger;

        end;  {case iColdWarVeteranType of}

        Close;

      end;  {with tbColdWarVeteranLimts do}

  finally
    tbColdWarVeteranLimts.Free;
  end;

end;  {GetColdWarVetLimit}

{==========================================================================}
Function CalculateSTARAmount(    ExemptionCodeTable,
                                 ParcelExemptionTable,
                                 ParcelTable : TTable;
                                 AssessedValue : Comp;
                                 ResidentialPercent : Real;
                                 Percent : Real;
                                 iSchoolExemptionAmount : LongInt;
                             var FullSTARAmount : Comp) : Comp;

{Given a STAR exemption code, calculate the STAR amount.
 Two items are returned - the full STAR amount (for exemption totals) and
 the actual STAR amount for this parcel. This can be different if the
 school taxable value before STAR is less than the full STAR amount.}
{CHG12011997-2: STAR support}

var
  SchoolTaxableVal : Comp;
  I : Integer;

begin
(*    {Get the equalization rate for this swis.}

  SwisCodeTable.FindKey([TaxRollYr, SwisCode]);

  EqualizationRate := SwisCodeTable.FieldByName('EqualizationRate').AsFloat / 100;

    {FXX02051998-1: Need to figure out the processing type since this
                    could be a STAR added to This Year or Next Year.}

  ProcessingType := GetProcessingTypeForTaxRollYear(TaxRollYr);

    {FXX02041998-1: The sales differential factor is different for
                    basic and enhanced.}

  If (ProcessingType = ThisYear)
    then
      begin
        ResSalesPriceDifferentialFactor := GlblThisYearBasicSalesDifferential;
        ResSTARLimit := GlblThisYearBasicLimit;
        EnhSalesPriceDifferentialFactor := GlblThisYearEnhancedSalesDifferential;
        EnhSTARLimit := GlblThisYearEnhancedLimit;

      end;  {If (ProcessingType = ThisYear)}

  If (ProcessingType = NextYear)
    then
      begin
        ResSalesPriceDifferentialFactor := GlblNextYearBasicSalesDifferential;
        ResSTARLimit := GlblNextYearBasicLimit;
        EnhSalesPriceDifferentialFactor := GlblNextYearEnhancedSalesDifferential;
        EnhSTARLimit := GlblNextYearEnhancedLimit;

      end;  {If (ProcessingType = NextYear)}

  If (Take(4, EXCode) = '4183')
    then Result := EnhSTARLimit *
                   EnhSalesPriceDifferentialFactor * EqualizationRate
    else Result := ResSTARLimit *
                   ResSalesPriceDifferentialFactor * EqualizationRate;

    {Note that the STAR amount is always rounded to the nearest $10.}

  Result := Roundoff((Result / 10), 0) * 10;
  Result := Roundoff(Result, 0); *)

    {CHG04152007-1(2.11.1.25): The residential percent should be applied to the
                               assessed value prior to calculating the STAR value
                               - per Ramapo.}

    {FXX01272013: Residential percent does not apply to STAR.}
    {HXX05142013: Yes it is:
      Per RPTL Section 425:

      If the STAR exemption is to be applied to a non-residential type of parcel, a portion of which is used by the owner as a primary residence,
      it must be applied solely to that portion of the property used for residential purposes.
      Under no circumstances may the exempt value exceed the assessed value attributable to that portion.  }

  If _Compare(ResidentialPercent, 0, coNotEqual)
    then AssessedValue := Trunc(AssessedValue * ResidentialPercent);

  Result := ExemptionCodeTable.FieldByName('FixedAmount').AsInteger;

    {CHG01292008(2.11.7.4): STAR can now have a percent.}

  If _Compare(Percent, 0, coGreaterThan)
    then Result := Result * (Percent / 100);
  Result := Roundoff(Result, 0);

  FullStarAmount := Result;

    {Now see if we need to adjust the result either because
       1. This is a co-op or mobile home park
       2. The STAR amount is greater than the school taxable value before STAR.}

   {FXX05172010-1(2.24.2.4)[I7209]: Only take residential amounts in to account
                                    for calculating STAR.}

  SchoolTaxableVal := AssessedValue - iSchoolExemptionAmount;

(*  For I := 0 to (SchoolExemptionAmounts.Count - 1) do
    begin
      try
        iSchoolExemptionAmount := StrToInt(SchoolExemptionAmounts[I]);
      except
      end;

      SchoolTaxableVal := SchoolTaxableVal - iSchoolExemptionAmount;

    end;  {For I := 0 to (SchoolExemptionAmounts.Count - 1) do} *)

  If (SchoolTaxableVal < FullStarAmount)
    then Result := SchoolTaxableVal;

    {If it is a co-op or mobile home park, they must fill in the amount by
     hand.}
    {FXX08051998-1: If there is an amount already in the town or amount field,
                    then use this amount for condos.}
    {CHG06062001-1: STAR can now be placed on mixed use 400 prop class.}
    {FXX07102001-1: If the 411 is a condo, we want to autocalc, not let them fill it in.}

  If (PropertyIsCoopOrMobileHomePark(ParcelTable) or
      ((not GlblTreatMixedUseParcelsAsResidential) and
       (ParcelTable.FieldByName('PropertyClassCode').Text[1] = '4') and
       (Trim(ParcelTable.FieldByName('OwnershipCode').Text) <> 'C')))
    then
      with ParcelExemptionTable do
        If (Roundoff(FieldByName('Amount').AsFloat, 0) > 0)
          then Result := FieldByName('Amount').AsFloat
          else
            If (Roundoff(FieldByName('TownAmount').AsFloat, 0) > 0)
              then Result := FieldByName('TownAmount').AsFloat
              else Result := 0;

end;  {CalculateSTARAmount}

{==========================================================================}
Procedure GetResidentialExemptionAmounts(var ResidentialExemptionAmounts,
                                             FullParcelExemptionAmounts,
                                             NonResidentialExemptionAmounts : ExemptionTotalsArrayType;
                                             ResidentialTypes,
                                             CountyExemptionAmounts,
                                             TownExemptionAmounts,
                                             SchoolExemptionAmounts,
                                             VillageExemptionAmounts : TStringList);

{FXX02091998-1: Seperate the exemption amounts into amounts that only apply
                to the residential portion, non-residential portion and
                those that apply to the whole parcel regardless of
                residential percent.}

var
  I : Integer;

begin
  For I := 1 to 4 do
    begin
      ResidentialExemptionAmounts[I] := 0;
      FullParcelExemptionAmounts[I] := 0;
      NonResidentialExemptionAmounts[I] := 0;

    end;  {For I := 1 to 4 do}

    {FXX06252001-1: If there is no ResidentialType filled in for an EX code, caused
                    an error.  Assume 'B' if not filled in.}

  For I := 0 to (ResidentialTypes.Count - 1) do
    case Take(1, ResidentialTypes[I])[1] of
      'R' : begin
              ResidentialExemptionAmounts[EXCounty] := ResidentialExemptionAmounts[EXCounty] +
                                                       StrToFloat(CountyExemptionAmounts[I]);
              ResidentialExemptionAmounts[EXTown] := ResidentialExemptionAmounts[EXTown] +
                                                     StrToFloat(TownExemptionAmounts[I]);
              ResidentialExemptionAmounts[EXSchool] := ResidentialExemptionAmounts[EXSchool] +
                                                       StrToFloat(SchoolExemptionAmounts[I]);
              ResidentialExemptionAmounts[EXVillage] := ResidentialExemptionAmounts[EXVillage] +
                                                        StrToFloat(VillageExemptionAmounts[I]);

            end;  {'R' : begin}

      ' ',
      'B' : begin
              FullParcelExemptionAmounts[EXCounty] := FullParcelExemptionAmounts[EXCounty] +
                                                      StrToFloat(CountyExemptionAmounts[I]);
              FullParcelExemptionAmounts[EXTown] := FullParcelExemptionAmounts[EXTown] +
                                                    StrToFloat(TownExemptionAmounts[I]);
              FullParcelExemptionAmounts[EXSchool] := FullParcelExemptionAmounts[EXSchool] +
                                                      StrToFloat(SchoolExemptionAmounts[I]);
              FullParcelExemptionAmounts[EXVillage] := FullParcelExemptionAmounts[EXVillage] +
                                                       StrToFloat(VillageExemptionAmounts[I]);

            end;  {'B' : begin}

      'F' : begin
              NonResidentialExemptionAmounts[EXCounty] := NonResidentialExemptionAmounts[EXCounty] +
                                                          StrToFloat(CountyExemptionAmounts[I]);
              NonResidentialExemptionAmounts[EXTown] := NonResidentialExemptionAmounts[EXTown] +
                                                        StrToFloat(TownExemptionAmounts[I]);
              NonResidentialExemptionAmounts[EXSchool] := NonResidentialExemptionAmounts[EXSchool] +
                                                          StrToFloat(SchoolExemptionAmounts[I]);
              NonResidentialExemptionAmounts[EXVillage] := NonResidentialExemptionAmounts[EXVillage] +
                                                           StrToFloat(VillageExemptionAmounts[I]);

            end;  {'F' : begin}

    end;  {case ResidentialTypes[I][1] of}

end;  {GetResidentialExemptionAmounts}

{==========================================================================}
Function CalculateTaxableVal(AssessedValue,
                             ExemptionAmount : Comp) : Comp;

{FXX05261998-3: Don't let a taxable value decrease below 0.}
{Return the taxable value of the property for a tax type, returning
 0 if the taxable value is below 0.}

begin
  Result := AssessedValue - ExemptionAmount;

  If (Result < 0)
    then Result := 0;

end;  {CalculateTaxableVal}

{==========================================================================}
Function CalculateExemptionWithResidentialPercent(AssessedVal : Comp;
                                                  ResidentialExemptionAmounts,
                                                  FullParcelExemptionAmounts,
                                                  NonResidentialExemptionAmounts : ExemptionTotalsArrayType;
                                                  ResidentialPercent,
                                                  CalcPercent : Real;
                                                  ResidentialType : String;
                                                  ExIdx : Integer) : Extended;

{FXX02091998-1. For exemptions where the residential percent applies,
                the exemption amounts must be seperated into those
                that apply to the residential part, non-residential part
                and full parcel.  The exemptions are calculated based on
                these amounts.}

begin
  Result := 0;
  ResidentialType := Take(1, ResidentialType);

    {FXX02131998-1: Roundoff to 4 decimal places since percent sometimes
                    gets divided.}

  case ResidentialType[1] of
    'R' : Result := ((AssessedVal - FullParcelExemptionAmounts[ExIdx]) *
                     ResidentialPercent -
                     ResidentialExemptionAmounts[ExIdx]) *
                     Roundoff((CalcPercent / 100), 4);

       {Both -> no residential percent.}

    ' ',
    'B' : Result := (AssessedVal -
                     (FullParcelExemptionAmounts[ExIdx] +
                      ResidentialExemptionAmounts[ExIdx] +
                      NonResidentialExemptionAmounts[ExIdx])) *
                      Roundoff((CalcPercent / 100), 4);

    'N' : Result := ((AssessedVal - FullParcelExemptionAmounts[ExIdx]) *
                     ResidentialPercent -  {This is already 1 - Res Percent.}
                     NonResidentialExemptionAmounts[ExIdx]) *
                     Roundoff((CalcPercent / 100), 4);

  end;  {case ResidentialType of}

    {FXX05261998-2: If this is a negative result, return 0.}

  If (Roundoff(Result, 0) < 0)
    then Result := 0;

end;  {CalculateExemptionWithResidentialPercent}

{==========================================================================}
Function CalculateExemptionAmount(    ExemptionCodeTable,
                                      ParcelExemptionTable,  {Table with the current parcel exemption}
                                      ParcelExemptionLookupTable,  {Lookup table to find other exemptions.}
                                      AssessmentTable,
                                      ClassTable,
                                      SwisCodeTable,
                                      ParcelTable : TTable;
                                      TaxRollYr : String;
                                      SwisSBLKey : String;
                                  var FixedPercent : Comp;
                                  var VetMaxSet,
                                      EqualizationRateFilledIn,
                                      ExemptionRecalculated : Boolean;
                                      iLandValue : LongInt;
                                      iAssessedValue : LongInt;
                                      bUseOverrideAssessedValue : Boolean): ExemptionTotalsArrayType;

{Calculate the amount for this exemption based on the exemption calc code and the exemption code
 itself. The calculations are (by calc code):

   F: Fixed amount set in the exemption code table.
   L: Exemption is land assessed value.
   I: Exemption is improvement value (total assessed - land assessed).
   T: Exemption is total assessed value.
   P: Exemption is a fixed percent of the total assessed value (for now).
      The fixed percent is set in the exemption code table.
   V: Exemption is the amount which is entered in the parcel exemption record. (variable amount)
   blank : Variable percent (set on a per parcel basis) or
           Special Rule (i.e. veteran)
             Veteran exemptions:
               4112 (War vet): Min(State Max, Vet % * Total Assessed Val) * Equalization Rate
               4113 (Combat vet): Min(State Combat Max, Combat Vet % * Total Assessed Val) * Equalization Rate
               4114 (Disab vet): Min(State Disab Max, User Entered % * Total Assessed Val) * Equalization Rate.

 Here are some of the other rules:
   1. Amount based exemptions are calculated first.
   2. Percentage based exemptions are calculated second (i.e. they use the taxable value after
                                                              the fixed amounts are subtracted.
   3. Ageds are calculated last. Only non-residential exemptions are not applied before calculating
            the aged amount.

  Note that at this point we do not prevent them from entering them in the wrong order which
  will cause incorrect calculations, but we will fix this.}

{CHG12011997-2: STAR support.}

var
  ClassRecordFound, Found, Quit, SpecialCase, AppliesToVillage : Boolean;
  Percent, OwnerPercent : Double;  {FXX04292004-1(2.07l3): Change the type to Double so that exemption percents don't have to be integer.}
  AltVetRate,
  LandAssessedVal, TotalAssessedVal,
  VetMax, DisabledVetMax,
  CombatVetMax,
  BasicSTARAmount, EnhancedSTARAmount,
  STARAmount, FullSTARAmount, EqualizedMaximum : Comp;
  EqualizationRate : Extended;
  CalcCode : String;
  HstdEXAmounts,
  NonhstdEXAmounts,
  ExemptionTotalsArray : ExemptionTotalsArrayType;  {Exemption amount totals used for calculating certain exemptions.}
  ThisExemptionAmountsArray : ExemptionTotalsArrayType;  {The array with the exemption amounts for this exemption.}
  EXAppliesArray : ExemptionAppliesArrayType;  {Does the exemption apply to county, town, school or village?}
  ResidentialPercent : Real;
  EXAmount : Extended;
  ExemptionCodes,
  ExemptionHomesteadCodes,
  ResidentialTypes,
  CountyExemptionAmounts,
  TownExemptionAmounts,
  SchoolExemptionAmounts,
  VillageExemptionAmounts : TStringList;
  I, J, EXIdx, ProcessingType : Integer;
  ResType : Char;
  EXCode : String;
  ResidentialType : String;
  ResidentialExemptionAmounts,
  FullParcelExemptionAmounts,
  NonResidentialExemptionAmounts : ExemptionTotalsArrayType;
  InitialYear, InitialMonth, InitialDay,
  CurrentYear, CurrentMonth, CurrentDay, YearsDifference : Word;
  AssessmentYearControlTable : TTable;
  iColdWarVetLimit, iColdWarVeteranType : LongInt;

begin
  VetMax := 0;
  DisabledVetMax := 0;
  ProcessingType := GetProcessingTypeForTaxRollYear(TaxRollYr);

    {CHG01282004-1(2.08): Display exemptions not recalculated.  Can be nil if don't care.}

  ExemptionRecalculated := True;
  FixedPercent := 0;
  Quit := False;

  For I := 1 to 4 do
    ThisExemptionAmountsArray[I] := 0;

    {Which municipality types does this exemption apply to
     (county, town, school, village)?}

  EXAppliesArray := ExApplies(ParcelExemptionTable.FieldByName('ExemptionCode').Text,
                              TBooleanField(ParcelExemptionTable.FieldByName('ApplyToVillage')).AsBoolean);

   {CHG03132004-2(2.08): If this municipality does not have a village that takes a partial roll,
                         use the town amount for the village.}

  If (rtdVillageReceivingPartialRoll in GlblRollTotalsToShow)
    then AppliesToVillage := ParcelExemptionTable.FieldByName('ApplyToVillage').AsBoolean
    else AppliesToVillage := ExAppliesArray[EXTown];

  ExemptionCodes := TStringList.Create;
  ExemptionHomesteadCodes := TStringList.Create;
  ResidentialTypes := TStringList.Create;
  CountyExemptionAmounts := TStringList.Create;
  TownExemptionAmounts := TStringList.Create;
  SchoolExemptionAmounts := TStringList.Create;
  VillageExemptionAmounts := TStringList.Create;

    {Make sure that we have the right assessment, class, exemption code,
     and swis code records.}

  Found := FindKeyOld(AssessmentTable, ['TaxRollYr', 'SwisSBLKey'],
                      [TaxRollYr, SwisSBLKey]);

  If not Found
    then SystemSupport(955, AssessmentTable, 'Error getting assessment record.',
                       'PASUTILS.PAS', GlblErrorDlgBox);

  ClassRecordFound := FindKeyOld(ClassTable, ['TaxRollYr', 'SwisSBLKey'],
                                 [TaxRollYr, SwisSBLKey]);

  Found := FindKeyOld(SwisCodeTable, ['SwisCode'],
                      [ParcelTable.FieldByName('SwisCode').Text]);

  If not Found
    then SystemSupport(958, SwisCodeTable, 'Error getting swis code record.',
                       'PASUTILS.PAS', GlblErrorDlgBox);

  Found := FindKeyOld(ExemptionCodeTable, ['EXCode'],
                      [ParcelExemptionTable.FieldByName('ExemptionCode').Text]);

  If not Found
    then SystemSupport(960, ExemptionCodeTable, 'Error getting Exemption Code record.',
                       'PASUTILS.PAS', GlblErrorDlgBox);

    {Figure out the land and total assessed values. We will use the
     amounts in the assessment records unless the parcel is split,
     there is a class record, and they have specified a homestead code
     for this exemption.}

  If ((ParcelTable.FieldByName('HomesteadCode').Text = 'S') and
      ClassRecordFound and
      (Deblank(ParcelExemptionTable.FieldByName('HomesteadCode').Text) <> ''))
    then
      begin
        with ClassTable do
          If (ParcelExemptionTable.FieldByName('HomesteadCode').Text = 'H')
            then
              begin  {Use homestead class value}
                LandAssessedVal := TCurrencyField(FieldByName('HstdLandVal')).Value;
                TotalAssessedVal := TCurrencyField(FieldByName('HstdTotalVal')).Value;
              end
            else
              begin  {Use nonhomestead class value}
                LandAssessedVal := TCurrencyField(FieldByName('NonhstdLandVal')).Value;
                TotalAssessedVal := TCurrencyField(FieldByName('NonhstdTotalVal')).Value;
              end;

      end
    else
      begin
        If bUseOverrideAssessedValue
          then
          begin
            LandAssessedVal := iLandValue;
            TotalAssessedVal := iAssessedValue;
          end
          else
          begin
            LandAssessedVal := TCurrencyField(AssessmentTable.FieldByName('LandAssessedVal')).Value;
            TotalAssessedVal := TCurrencyField(AssessmentTable.FieldByName('TotalAssessedVal')).Value;
          end;

      end;

  LandAssessedVal := Roundoff(LandAssessedVal, 0);
  TotalAssessedVal := Roundoff(TotalAssessedVal, 0);

    {If this is a swis that has different vet limits for county, town\city, and
     school, then we must choose which maximums to use. Otherwise, we will use the
     county limits, even though they are all the same.}

    {FXX06241998-1: The veterans maximums need to be at the county and swis level.}
    {FXX07192006-1(2.9.7.11): If the current year county vet maximums are different
                              then the next year ones and a person changes an exemption
                              on a parcel with a vet, then it uses the wrong county vet
                              maximum set for the next year.}

  AssessmentYearControlTable := FindTableInDataModuleForProcessingType(DataModuleAssessmentYearControlTableName,
                                                                       ProcessingType);

  If EXAppliesArray[EXCounty]
    then
      with AssessmentYearControlTable do
        begin
          VetMax := FieldByName('VeteranCntyMax').AsInteger;
          CombatVetMax := FieldByName('CombatVetCntyMax').AsInteger;
          DisabledVetMax := FieldByName('DisabledVetCntyMax').AsInteger;

        end;  {with AssessmentYearControlTable do}

  If ExAppliesArray[EXTown]
    then
      begin
        VetMax := TCurrencyField(SwisCodeTable.FieldByName('VeteranTownMax')).Value;
        CombatVetMax := TCurrencyField(SwisCodeTable.FieldByName('CombatVetTownMax')).Value;
        DisabledVetMax := TCurrencyField(SwisCodeTable.FieldByName('DisabledVetTownMax')).Value;

      end;  {If ExAppliesArray[EXTown]}

  EqualizationRateFilledIn := True;

    {In some cases the calc method is blank (i.e. null), so let's force it to one
     blank space for the case statement below.}

  CalcCode := ExemptionCodeTable.FieldByName('CalcMethod').Text;

  If (Deblank(CalcCode) = '')
    then CalcCode := ' ';

  EXCode := ParcelExemptionTable.FieldByName('ExemptionCode').Text;
  ResidentialType := ExemptionCodeTable.FieldByName('ResidentialType').Text;
  EqualizationRate := SwisCodeTable.FieldByName('EqualizationRate').AsFloat;

  OwnerPercent := Roundoff(ParcelExemptionTable.FieldByName('OwnerPercent').AsFloat, 2);

    {If the owner percent is not filled in, assume it is
     100%.}

  If (Roundoff(OwnerPercent, 2) = 0)
    then OwnerPercent := 100;
  
  If (Deblank(ParcelExemptionTable.FieldByName('ExemptionCode').Text) <> '')
    then
      case CalcCode[1] of
          {CHG12011997-2: STAR support.}

        EXCMethF : If ExemptionIsSTAR(EXCode)
                     then
                       begin
                          {Since the star exemption is applied last,
                           we will get all the exemptions. Note that the
                           STAR amount is not included in the school amount,
                           we will get all the exemptions (which is really
                           all except STAR).}
                           {FXX02091998-1: Pass the residential type of each exemption.}

                         TotalExemptionsForParcel(ParcelExemptionTable.FieldByName('TaxRollYr').Text,
                                                  ParcelExemptionTable.FieldByName('SwisSBLKey').Text,
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

                           {FXX06161998-1: The above messes up the position
                                           of the ex code table, must refresh.}

                         FindKeyOld(ExemptionCodeTable, ['EXCode'],
                                    [EXCode]);

                          {FXX05141998-1: Instead of calculating the STAR
                                          amount each time, let's just use
                                          the fixed amount in the amount field
                                          of the exemption code.}
                          {FXX05281998-1: Need to use the calculate STAR
                                          routine to account for parcels
                                          where full STAR would make school
                                          TV 0.}

                         ResidentialPercent := GetResidentialPercent(ParcelTable,
                                                                     ExemptionCodeTable,
                                                                     EXCode);

                           {FXX05172010-1(2.24.2.4)[I7209]: Only take residential amounts in to account
                                                            for calculating STAR.}

                         GetResidentialExemptionAmounts(ResidentialExemptionAmounts,
                                                        FullParcelExemptionAmounts,
                                                        NonResidentialExemptionAmounts,
                                                        ResidentialTypes,
                                                        CountyExemptionAmounts,
                                                        TownExemptionAmounts,
                                                        SchoolExemptionAmounts,
                                                        VillageExemptionAmounts);

                         STARAmount := CalculateSTARAmount(ExemptionCodeTable,
                                                           ParcelExemptionTable,
                                                           ParcelTable,
                                                           TotalAssessedVal,
                                                           ResidentialPercent,
                                                           ParcelExemptionTable.FieldByName('OwnerPercent').AsFloat,
                                                           Trunc(ResidentialExemptionAmounts[EXSchool]),
                                                           FullSTARAmount);

                           {If the property is a coop or mobile home, just
                            take the amount that they entered and never recalc.}

                           {FXX12041997-2: Need to get the amount from
                                           the parcel ex table,
                                           not the ex code tbl.}

                           {CHG06062001-1: STAR can now be placed on mixed use 400 prop class.}

                          {FXX07102001-1: If the 411 is a condo, we want to autocalc, not let them fill it in.}

                         If (PropertyIsCoopOrMobileHomePark(ParcelTable) or
                             ((not GlblTreatMixedUseParcelsAsResidential) and
                              (ParcelTable.FieldByName('PropertyClassCode').Text[1] = '4') and
                              (Take(1, ParcelTable.FieldByName('OwnershipCode').Text)[1] <> 'C')))
                           then
                             begin
                               STARAmount := Roundoff(ParcelExemptionTable.FieldByName('Amount').AsFloat, 0);
                               ExemptionRecalculated := False;
                             end;

                         ThisExemptionAmountsArray[EXSchool] := STARAmount;

                       end
                     else
                       begin  {Fixed amount}
                         EXAmount := TCurrencyField(ExemptionCodeTable.FieldByName('FixedAmount')).Value;
                         EXAmount := Roundoff(EXAmount, 0);

                           {Now fill in the amounts on a per municipality
                            type basis (county, town, school, village).}

                         For I := 1 to 4 do
                           If EXAppliesArray[I]
                             then ThisExemptionAmountsArray[I] := EXAmount;

                       end;  {Fixed amount}

        EXCMethL : begin  {Land assessed value}
                       {They can have a percent on a land, improvement or
                        total exemption.}

                     Percent := ParcelExemptionTable.FieldByName('Percent').AsFloat;

                       {If the percent is zero, then they are just adding this exemption,
                        so we should default it to 50%. Otherwise, we will just use the
                        percent that they already entered.}

                     If (Roundoff(Percent, 0) = 0)
                       then Percent := 100;

                       {FXX02091998-4: No residential percent for land,
                                       improvement or total.}

                     EXAmount := LandAssessedVal * (Percent / 100);
                     EXAmount := Roundoff(EXAmount, 0);

                       {Now fill in the amounts on a per municipality
                        type basis (county, town, school, village).}

                     For I := 1 to 4 do
                       If EXAppliesArray[I]
                         then ThisExemptionAmountsArray[I] := EXAmount;

                   end;   {Land assessed value}

        EXCMethI : begin  {Improvement value}
                       {They can have a percent on a land, improvement or
                        total exemption.}

                     Percent := ParcelExemptionTable.FieldByName('Percent').AsFloat;

                       {If the percent is zero, then they are just adding this exemption,
                        so we should default it to 50%. Otherwise, we will just use the
                        percent that they already entered.}

                     If (Roundoff(Percent, 0) = 0)
                       then Percent := 100;

                       {FXX02091998-4: No residential percent for land,
                                       improvement or total.}

                     EXAmount := (TotalAssessedVal - LandAssessedVal) *
                                 (Percent / 100);
                     EXAmount := Roundoff(EXAmount, 0);

                       {Now fill in the amounts on a per municipality
                        type basis (county, town, school, village).}

                     For I := 1 to 4 do
                       If EXAppliesArray[I]
                         then ThisExemptionAmountsArray[I] := EXAmount;

                   end;   {Improvement value}

        EXCMethT : begin  {Total assessed value}
                       {They can have a percent on a land, improvement or
                        total exemption.}

                     Percent := ParcelExemptionTable.FieldByName('Percent').AsFloat;

                       {FXX02091998-4: No residential percent for land,
                                       improvement or total.}

                       {If the percent is zero, then they are just adding this exemption,
                        so we should default it to 50%. Otherwise, we will just use the
                        percent that they already entered.}

                     If (Roundoff(Percent, 0) = 0)
                       then Percent := 100;

                     EXAmount := TotalAssessedVal *
                                 (Percent / 100);
                     EXAmount := Roundoff(EXAmount, 0);

                       {Now fill in the amounts on a per municipality
                        type basis (county, town, school, village).}

                     For I := 1 to 4 do
                       If EXAppliesArray[I]
                         then ThisExemptionAmountsArray[I] := EXAmount;

                   end;   {Total assessed value}

        EXCMethV : begin  {Variable amount}
                       {The variable amount may only be stored in the county
                        or school field if that is all it is applied to, so
                        we have to find it.}

                       {FXX04161999-1: Recalc BIE amounts.}
                       {FXX04191999-6: Only calc BIE exemption amount if
                                       this is first time entered. Otherwise,
                                       5% per year reduction is taken in year end rollover
                                       since must be off initial amount.}

                     If ((Take(4, EXCode) = '4760') and
                         (ParcelExemptionTable.FieldByName('Amount').AsFloat = 0))
                       then
                         begin
                           DecodeDate(ParcelExemptionTable.FieldByName('InitialDate').AsDateTime,
                                      InitialYear, InitialMonth, InitialDay);
                           DecodeDate(Date, CurrentYear, CurrentMonth, CurrentDay);

                           YearsDifference := CurrentYear - InitialYear;

                             {5% per year decreasing exemption starting at 50%.}

                           Percent := 50 - 5 * YearsDifference;

                             {FXX04181999-4: Make sure percent does not
                                             go below zero if exemption on
                                             too long.}

                           If (Roundoff(Percent, 0) < 0)
                             then EXAmount := 0
                             else EXAmount := (TotalAssessedVal - LandAssessedVal) * (Percent / 100);

                         end  {If (Take(4, EXCode) = '4760')}
                       else
                         begin
                             {FXX03231998-2: It will always be the amount in the
                                             ex amount field unless the amount field is zero.}

                           If (TCurrencyField(ParcelExemptionTable.FieldByName('Amount')).Value = 0)
                             then
                               begin
                                 EXAmount := TCurrencyField(ParcelExemptionTable.FieldByName('TownAmount')).Value;
                                 ExAmount := MaxComp(ExAmount,
                                                     TCurrencyField(ParcelExemptionTable.FieldByName('CountyAmount')).Value);
                                 ExAmount := MaxComp(ExAmount,
                                                     TCurrencyField(ParcelExemptionTable.FieldByName('SchoolAmount')).Value);

                               end
                             else ExAmount := TCurrencyField(ParcelExemptionTable.FieldByName('Amount')).Value;

                         end;  {else of If (Take(4, EXCode) = '4760')}

                     EXAmount := Roundoff(EXAmount, 0);

                       {Now fill in the amounts on a per municipality
                        type basis (county, town, school, village).}

                     For I := 1 to 4 do
                       If EXAppliesArray[I]
                         then ThisExemptionAmountsArray[I] := EXAmount;

                   end;   {Variable amount}

        EXCMethP : begin  {Fixed percentage}
                     FixedPercent := ExemptionCodeTable.FieldByName('FixedPercentage').AsFloat;

                       {First, let's figure out the total of all amount based exemptions. This will
                        be subtracted from the total assessed value before applying the percentage
                        exemptions. Note that the array will be recalculated for the aged exmeptions
                        since they come after ALL other exemptions which are not non-residential.}
                       {FXX02091998-1: Pass the residential type of each exemption.}

                     ExemptionTotalsArray := TotalExemptionsForParcel(ParcelExemptionTable.FieldByName('TaxRollYr').Text,
                                                             ParcelExemptionTable.FieldByName('SwisSBLKey').Text,
                                                             ParcelExemptionLookupTable,
                                                             ExemptionCodeTable,
                                                             ParcelTable.FieldByName('HomesteadCode').Text,
                                                             'F',
                                                             ExemptionCodes,
                                                             ExemptionHomesteadCodes,
                                                             ResidentialTypes,
                                                             CountyExemptionAmounts,
                                                             TownExemptionAmounts,
                                                             SchoolExemptionAmounts,
                                                             VillageExemptionAmounts,
                                                             BasicSTARAmount,
                                                             EnhancedSTARAmount);

                       {FXX02091998-1: Calculate the amount of the exemptions
                                       that apply to residential, nonresidential
                                       or both if there is a residential percent.}

                     GetResidentialExemptionAmounts(ResidentialExemptionAmounts,
                                                    FullParcelExemptionAmounts,
                                                    NonResidentialExemptionAmounts,
                                                    ResidentialTypes,
                                                    CountyExemptionAmounts,
                                                    TownExemptionAmounts,
                                                    SchoolExemptionAmounts,
                                                    VillageExemptionAmounts);

                     ResidentialPercent := GetResidentialPercent(ParcelTable,
                                                                 ExemptionCodeTable,
                                                                 EXCode);

                     GetHomesteadAndNonhstdExemptionAmounts(ExemptionCodes,
                                                            ExemptionHomesteadCodes,
                                                            CountyExemptionAmounts,
                                                            TownExemptionAmounts,
                                                            SchoolExemptionAmounts,
                                                            VillageExemptionAmounts,
                                                            HstdEXAmounts,
                                                            NonhstdEXAmounts);

                       {If this is a split parcel, we only want to subtract
                        homestead or non-homestead exemptions depending on
                        what this exemption applies to.}

                     If (ParcelTable.FieldByName('HomesteadCode').Text = SplitParcel)
                       then
                         If (ParcelExemptionTable.FieldByName('HomesteadCode').Text = NonhomesteadParcel)
                           then ExemptionTotalsArray := NonhstdEXAmounts
                           else ExemptionTotalsArray := HstdEXAmounts;

                       {Now fill in the amounts on a per municipality
                        type basis (county, town, school, village).
                        Note that if the exemption applies to this
                        municipality type, we will figure out the
                        exemption amount for THIS municipality basis
                        only since the totals may be different.}

                       {CHG07262004-2(2.07l5): Allow for override on the firefighter exemptions.}

                     If (ExemptionIsVolunteerFirefighter(EXCode) and
                         PropertyIsCoopOrMobileHomePark(ParcelTable))
                       then
                         begin
                           ExemptionRecalculated := False;

                           For I := 1 to 4 do
                             If EXAppliesArray[I]
                               then
                                 begin
                                   ExAmount := Roundoff(ParcelExemptionTable.FieldByName('Amount').AsFloat, 0);

                                   ThisExemptionAmountsArray[I] := EXAmount;

                                 end;  {If EXAppliesArray[I]}

                         end
                       else
                         begin
                           For I := 1 to 4 do
                             If EXAppliesArray[I]
                               then
                                 begin
                                   EXAmount := CalculateExemptionWithResidentialPercent(
                                                          TotalAssessedVal,
                                                          ResidentialExemptionAmounts,
                                                          FullParcelExemptionAmounts,
                                                          NonResidentialExemptionAmounts,
                                                          ResidentialPercent,
                                                          FixedPercent,
                                                          ResidentialType, I);

                                     {CHG02122000-1: Add volunteer firefighter exemption.}
                                     {CHG03252005-1(2.8.3.14)[2088]: Westchester no longer has the cap.}
                                     {FXX06072009-1(2.17.1.24): The volunteer firefighter (if non-capped) is
                                                                10% off the total assessed value.}

                                   If ExemptionIsVolunteerFirefighter(EXCode)
                                     then
                                       If ((not GlblEnableExemptionCapOption) or
                                           (GlblEnableExemptionCapOption and
                                            ExemptionCodeTable.FieldByName('ApplyCap').AsBoolean))
                                         then
                                       begin
                                           {The maximum for this exemption is 3000 equalized.}

                                         EqualizedMaximum := Roundoff((3000 * (EqualizationRate / 100)), 0);

                                         If (Roundoff(EXAmount, 0) > Roundoff(EqualizedMaximum, 0))
                                           then EXAmount := Roundoff(EqualizedMaximum, 0);

                                           end  {If ExemptionIsVolunteerFirefighter(EXCode)}
                                         else EXAmount := (TotalAssessedVal - FullParcelExemptionAmounts[I] -
                                                           ResidentialExemptionAmounts[I]) * (FixedPercent / 100);

                                   EXAmount := Roundoff(EXAmount, 0);

                                   ThisExemptionAmountsArray[I] := EXAmount;

                                 end;  {If EXAppliesArray[I]}

                         end;  {If (ExemptionIsVolunteerFirefighter(EXCode) and ...}

                   end;  {Fixed percentage}

        ' ' :
          begin {Exception cases - percent based for the most part.}
            SpecialCase := False;

            EqualizationRate := SwisCodeTable.FieldByName('EqualizationRate').AsFloat;

              {FXX10161998-1: The equalization rate filled in flag was not being set
                              for condos.}

            If (Roundoff(EqualizationRate, 2) > 0)
              then EqualizationRateFilledIn := True;

              {First, let's figure out the total of all amount based exemptions. This will
               be subtracted from the total assessed value before applying the percentage
               exemptions. Note that the array will be recalculated for the aged exmeptions
               since they come after ALL other exemptions which are not non-residential.}
              {FXX02091998-1: Pass the residential type of each exemption.}
              {CHG04161998-1: Add the 4193x limited income diabled
                              exemption. It is the same as 4180x.}
              {CHG12291998-1: Malta has 4190x physically disabled limited income
                              which is same as senior.}
              {CHG08132008-1(2.15.1.5): Add 4191x as a low income disabled exemption.}

            If ((Take(4, ParcelExemptionTable.FieldByName('ExemptionCode').Text) <> '4180') and
                (not ExemptionIsLowIncomeDisabled(ParcelExemptionTable.FieldByName('ExemptionCode').AsString))and
(*                (Take(4, ParcelExemptionTable.FieldByName('ExemptionCode').Text) <> '4193') and *)
                (Take(4, ParcelExemptionTable.FieldByName('ExemptionCode').Text) <> '4190'))
              then
                begin
                  ExemptionTotalsArray := TotalExemptionsForParcel(ParcelExemptionTable.FieldByName('TaxRollYr').Text,
                                                          ParcelExemptionTable.FieldByName('SwisSBLKey').Text,
                                                          ParcelExemptionLookupTable,
                                                          ExemptionCodeTable,
                                                          ParcelTable.FieldByName('HomesteadCode').Text,
                                                          'F',
                                                          ExemptionCodes,
                                                          ExemptionHomesteadCodes,
                                                          ResidentialTypes,
                                                          CountyExemptionAmounts,
                                                          TownExemptionAmounts,
                                                          SchoolExemptionAmounts,
                                                          VillageExemptionAmounts,
                                                          BasicSTARAmount,
                                                          EnhancedSTARAmount);

                    {FXX02091998-1: Calculate the amount of the exemptions
                                    that apply to residential, nonresidential
                                    or both if there is a residential percent.}

                  GetResidentialExemptionAmounts(ResidentialExemptionAmounts,
                                                 FullParcelExemptionAmounts,
                                                 NonResidentialExemptionAmounts,
                                                 ResidentialTypes,
                                                 CountyExemptionAmounts,
                                                 TownExemptionAmounts,
                                                 SchoolExemptionAmounts,
                                                 VillageExemptionAmounts);

                  ResidentialPercent := GetResidentialPercent(ParcelTable,
                                                              ExemptionCodeTable,
                                                              EXCode);

                  GetHomesteadAndNonhstdExemptionAmounts(ExemptionCodes,
                                                         ExemptionHomesteadCodes,
                                                         CountyExemptionAmounts,
                                                         TownExemptionAmounts,
                                                         SchoolExemptionAmounts,
                                                         VillageExemptionAmounts,
                                                         HstdEXAmounts,
                                                         NonhstdEXAmounts);

                    {If this is a split parcel, we only want to subtract
                     homestead or non-homestead exemptions depending on
                     what this exemption applies to.}

                  If (ParcelTable.FieldByName('HomesteadCode').Text = SplitParcel)
                    then
                      If (ParcelExemptionTable.FieldByName('HomesteadCode').Text = NonhomesteadParcel)
                        then ExemptionTotalsArray := NonhstdEXAmounts
                        else ExemptionTotalsArray := HstdEXAmounts;

                end;  {If (Take(4, ParcelExemptionTable.FieldByName('ExemptionCode').Text) ...}

              {Eligible funds. The amount is whatever they have entered.
               Note that there is no residential percent.}

            If (Take(4, ParcelExemptionTable.FieldByName('ExemptionCode').Text) = '4110')
              then
                begin
                  EXAmount := TCurrencyField(ParcelExemptionTable.FieldByName('TownAmount')).Value *
                              (OwnerPercent / 100);
                  EXAmount := Roundoff(EXAmount, 0);

                  For I := 1 to 4 do
                    If EXAppliesArray[I]
                      then ThisExemptionAmountsArray[I] := EXAmount;

                end;  {If (Take(4, ParcelExemptionTable. ...}

              {Ratio exemption.}
              {FXX07061999-1: Don't touch ratio vet amounts.}

            If (Take(4, ParcelExemptionTable.FieldByName('ExemptionCode').Text) = '4111')
              then
                begin
(*                  Percent := ParcelExemptionTable.FieldByName('Percent').AsFloat;
                  EXAmount := TCurrencyField(ParcelExemptionTable.FieldByName('TownAmount')).Value *
                              (Percent / 100) * (OwnerPercent / 100);*)
                  SpecialCase := True;
                  EXAmount := TCurrencyField(ParcelExemptionTable.FieldByName('TownAmount')).Value;

                    {FXX08301999-1: Sometimes the amount may be in the county field if this
                                    is a county exemption.}

                  If (Roundoff(EXAmount, 0) = 0)
                    then EXAmount := TCurrencyField(ParcelExemptionTable.FieldByName('CountyAmount')).Value;

                  If (Roundoff(EXAmount, 0) = 0)
                    then EXAmount := TCurrencyField(ParcelExemptionTable.FieldByName('Amount')).Value;

                  EXAmount := Roundoff(EXAmount, 0);

                  For I := 1 to 4 do
                    If EXAppliesArray[I]
                      then ThisExemptionAmountsArray[I] := EXAmount;

                end;  {If (Take(4, ParcelExemptionTable. ...}

              {Veteran exemption.}

            If (Take(4, ParcelExemptionTable.FieldByName('ExemptionCode').Text) = '4112')
              then
                begin
                  SpecialCase := True;

                    {FXX09151998-1: Just use the flat amount given in the exemption
                                    record for condos.}

                    {FXX12291998-2: LB does not use override amounts for condos and we must calc
                                    amount.}
                    {FXX03111999-2: Remove condo exemption override and
                                    was using ParcelIsCondo routine.}

                  If PropertyIsCoopOrMobileHomePark(ParcelTable)
                    then
                      begin
                        ExemptionRecalculated := False;
                        For I := 1 to 4 do
                          If EXAppliesArray[I]
                            then
                              begin
                                ExAmount := Roundoff(ParcelExemptionTable.FieldByName('Amount').AsFloat, 0);

                                ThisExemptionAmountsArray[I] := EXAmount;

                              end;  {If EXAppliesArray[I]}

                      end
                    else
                      begin
                        FixedPercent := SwisCodeTable.FieldByName('VeteranCalcPercent').AsFloat;

                        If ((Roundoff(FixedPercent, 2) > 0) and
                            (Roundoff(EqualizationRate, 2) > 0))
                          then
                            begin
                              EqualizationRateFilledIn := True;

                               {Set exemption amount to total asssessed * percent
                                for each municipality type.}

                              For I := 1 to 4 do
                                If EXAppliesArray[I]
                                  then
                                    begin
                                        {Apply the residential percent before comparing
                                         to the max.}

                                      EXAmount := CalculateExemptionWithResidentialPercent(
                                                             TotalAssessedVal,
                                                             ResidentialExemptionAmounts,
                                                             FullParcelExemptionAmounts,
                                                             NonResidentialExemptionAmounts,
                                                             ResidentialPercent,
                                                             FixedPercent,
                                                             ResidentialType, I);

                                      ExAmount := Roundoff(ExAmount, 0);

                                        {FXX04081998-2: Need to apply owner percent
                                                        before comparing to equalized
                                                        maximum.}

                                      EXAmount := EXAmount * (OwnerPercent / 100);

                                        {If we are above the equalized max,
                                         then set it to the max.}
                                        {FXX0302011(MDT)[I8689]: The vet exemptions were not calculating correctly for different county / town vet limits.}

                                      If _Compare(I, EXCounty, coEqual)
                                      then VetMax := AssessmentYearControlTable.FieldByName('VeteranCntyMax').AsInteger
                                      else VetMax := SwisCodeTable.FieldByName('VeteranTownMax').AsInteger;

                                      If (EXAmount >
                                            (VetMax * (EqualizationRate / 100)))
                                        then
                                          begin
                                            EXAmount := VetMax * (EqualizationRate / 100);
                                            VetMaxSet := True;

                                          end;  {If (EXAmount > ...}

                                      EXAmount := Roundoff(EXAmount, 0);

                                      ThisExemptionAmountsArray[I] := EXAmount;

                                    end;  {If EXAppliesArray[I]}

                            end;  {If (FixedPercent > 0)}

                      end;  {else of If ParcelIsCondo(ParcelTable)}

                end;  {If (Take(4, ParcelExemptionTable.FieldByName('ExemptionCode').Text) = '4113')}

              {Calculate the combat veteran exemption amount and %.}

            If (Take(4, ParcelExemptionTable.FieldByName('ExemptionCode').Text) = '4113')
              then
                begin
                  SpecialCase := True;

                    {FXX09151998-1: Just use the flat amount given in the exemption
                                    record for condos.}

                    {FXX12291998-2: LB does not use override amounts for condos and we must calc
                                    amount.}

                    {FXX03111999-2: Remove condo exemption override and
                                    was using ParcelIsCondo routine.}

                  If PropertyIsCoopOrMobileHomePark(ParcelTable)
                    then
                      begin
                        ExemptionRecalculated := False;
                        For I := 1 to 4 do
                          If EXAppliesArray[I]
                            then
                              begin
                                ExAmount := Roundoff(ParcelExemptionTable.FieldByName('Amount').AsFloat, 0);

                                ThisExemptionAmountsArray[I] := EXAmount;

                              end;  {If EXAppliesArray[I]}

                      end
                    else
                      begin
                        FixedPercent := SwisCodeTable.FieldByName('CombatVetCalcPercent').AsFloat;

                        If ((Roundoff(FixedPercent, 2) > 0) and
                            (Roundoff(EqualizationRate, 2) > 0))
                          then
                            begin
                              EqualizationRateFilledIn := True;

                               {Set exemption amount to total asssessed * percent
                                for each municipality type.}

                              For I := 1 to 4 do
                                If EXAppliesArray[I]
                                  then
                                    begin
                                        {Apply the residential percent before comparing
                                         to the max.}

                                      EXAmount := CalculateExemptionWithResidentialPercent(
                                                             TotalAssessedVal,
                                                             ResidentialExemptionAmounts,
                                                             FullParcelExemptionAmounts,
                                                             NonResidentialExemptionAmounts,
                                                             ResidentialPercent,
                                                             FixedPercent,
                                                             ResidentialType, I);

                                        {FXX04081998-2: Need to apply owner percent
                                                        before comparing to equalized
                                                        maximum.}

                                      EXAmount := EXAmount * (OwnerPercent / 100);

                                      If _Compare(I, EXCounty, coEqual)
                                      then CombatVetMax := AssessmentYearControlTable.FieldByName('CombatVetCntyMax').AsInteger
                                      else CombatVetMax := SwisCodeTable.FieldByName('CombatVetTownMax').AsInteger;

                                        {If we are above the equalized max,
                                         then set it to the max.}

                                      If (EXAmount >
                                            (CombatVetMax * (EqualizationRate / 100)))
                                        then
                                          begin
                                            EXAmount := CombatVetMax * (EqualizationRate / 100);
                                            VetMaxSet := True;

                                          end;  {If (EXAmount > ...}

                                      EXAmount := Roundoff(EXAmount, 0);

                                      ThisExemptionAmountsArray[I] := EXAmount;

                                    end;  {If EXAppliesArray[I]}

                            end;  {If (FixedPercent > 0)}

                      end;  {else of If ParcelIsCondo(ParcelTable)}

                end;  {If (Take(4, ParcelExemptionTable.FieldByName('ExemptionCode').Text) = '4113')}

              {Calculate the disabled veteran exemption amount.
               The percent is entered by the user.}

            If (Take(4, ParcelExemptionTable.FieldByName('ExemptionCode').Text) = '4114')
              then
                begin
                  SpecialCase := True;

                    {FXX09151998-1: Just use the flat amount given in the exemption
                                    record for condos.}

                    {FXX12291998-2: LB does not use override amounts for condos and we must calc
                                    amount.}

                    {FXX03111999-2: Remove condo exemption override and
                                    was using ParcelIsCondo routine.}

                  If PropertyIsCoopOrMobileHomePark(ParcelTable)
                    then
                      begin
                        ExemptionRecalculated := False;
                        For I := 1 to 4 do
                          If EXAppliesArray[I]
                            then
                              begin
                                ExAmount := Roundoff(ParcelExemptionTable.FieldByName('Amount').AsFloat, 0);

                                ThisExemptionAmountsArray[I] := EXAmount;

                              end;  {If EXAppliesArray[I]}

                      end
                    else
                      begin
                          {For disabled veterans exemption, the percent is entered by the user.}

                        If (Roundoff(EqualizationRate, 2) > 0)
                          then
                            begin
                              EqualizationRateFilledIn := True;

                               {Set exemption amount to percent they enter * total assessed.
                                Note that the percent that the user enters in the parcel
                                exemption is the full disabled percent. The actual exemption
                                is half of that percent. We will set the exemption
                                amount for each municipality type.}

                              For I := 1 to 4 do
                                If EXAppliesArray[I]
                                  then
                                    begin
                                        {Apply the residential percent before
                                         comparing to the maximum.}

                                      Percent := ParcelExemptionTable.FieldByName('Percent').AsFloat;

                                      EXAmount := CalculateExemptionWithResidentialPercent(
                                                             TotalAssessedVal,
                                                             ResidentialExemptionAmounts,
                                                             FullParcelExemptionAmounts,
                                                             NonResidentialExemptionAmounts,
                                                             ResidentialPercent,
                                                             Percent * 0.5,
                                                             ResidentialType, I);

                                        {If we are above the equalized max,
                                         then set it to the max.}

                                        {FXX04081998-2: Need to apply owner percent
                                                        before comparing to equalized
                                                        maximum.}

                                      EXAmount := EXAmount * (OwnerPercent / 100);

                                      If _Compare(I, EXCounty, coEqual)
                                      then DisabledVetMax := AssessmentYearControlTable.FieldByName('DisabledVetCntyMax').AsInteger
                                      else DisabledVetMax := SwisCodeTable.FieldByName('DisabledVetTownMax').AsInteger;

                                      If (EXAmount >
                                            (DisabledVetMax * (EqualizationRate / 100)))
                                        then
                                          begin
                                            EXAmount := DisabledVetMax * (EqualizationRate / 100);
                                            VetMaxSet := True;

                                          end;  {If (EXAmount > ...}

                                      EXAmount := Roundoff(EXAmount, 0);

                                      ThisExemptionAmountsArray[I] := EXAmount;

                                    end;  {If EXAppliesArray[I]}

                            end;  {If (Roundoff(AltVetRate, 2) > 0)}

                      end;  {else of If ParcelIsCondo(ParcelTable)}

                end;  {If (Take(4, ParcelExemptionTable.FieldByName('ExemptionCode').Text) = ...)}

            with ParcelExemptionTable do
              If ExemptionIsColdWarVeteran(FieldByName('ExemptionCode').AsString)
                then
                  begin
                    SpecialCase := True;

                    If PropertyIsCoopOrMobileHomePark(ParcelTable)
                      then
                        begin
                          ExemptionRecalculated := False;
                          For I := 1 to 4 do
                            If EXAppliesArray[I]
                              then
                                begin
                                  ExAmount := Roundoff(FieldByName('Amount').AsFloat, 0);

                                  ThisExemptionAmountsArray[I] := EXAmount;

                                end;  {If EXAppliesArray[I]}

                        end
                      else
                        begin
                            {For disabled veterans exemption, the percent is entered by the user.}

                           {Set exemption amount to percent they enter * total assessed.
                            Note that the percent that the user enters in the parcel
                            exemption is the full disabled percent. The actual exemption
                            is half of that percent. We will set the exemption
                            amount for each municipality type.}

                          For I := 1 to 4 do
                            If EXAppliesArray[I]
                              then
                                begin
                                  If ExemptionIsDisabledColdWarVeteran(FieldByName('ExemptionCode').AsString)
                                    then iColdWarVeteranType := cwvDisabled
                                    else iColdWarVeteranType := cwvBasic;

                                  GetColdWarVetPercentandLimit(AssessmentYearControlTable,
                                                               SwisCodeTable,
                                                               iColdWarVeteranType,
                                                               I,
                                                               ParcelTable.FieldByName('SwisCode').AsString,
                                                               Percent,
                                                               iColdWarVetLimit);

                                  FixedPercent := Percent;

                                  If ExemptionIsDisabledColdWarVeteran(FieldByName('ExemptionCode').AsString)
                                    then Percent := FieldByName('Percent').AsFloat * 0.5;

                                    {FXX01132012[PAS-125]: No exemptions should be calculated before Cold War.}

                                  For J := 1 to 4 do
                                  begin
                                    ResidentialExemptionAmounts[J] := 0;
                                    FullParcelExemptionAmounts[J] := 0;
                                    NonResidentialExemptionAmounts[J] := 0;
                                  end;

                                    {Apply the residential percent before
                                     comparing to the maximum.}

                                  EXAmount := CalculateExemptionWithResidentialPercent(
                                                         TotalAssessedVal,
                                                         ResidentialExemptionAmounts,
                                                         FullParcelExemptionAmounts,
                                                         NonResidentialExemptionAmounts,
                                                         ResidentialPercent,
                                                         Percent,
                                                         ResidentialType, I);

                                    {If we are above the equalized max,
                                     then set it to the max.}

                                    {FXX04081998-2: Need to apply owner percent
                                                    before comparing to equalized
                                                    maximum.}

                                  EXAmount := EXAmount * (OwnerPercent / 100);

                                  If (EXAmount >
                                        (iColdWarVetLimit * (EqualizationRate / 100)))
                                    then
                                      begin
                                        EXAmount := iColdWarVetLimit * (EqualizationRate / 100);
                                        VetMaxSet := True;

                                      end;  {If (EXAmount > ...}

                                  EXAmount := Roundoff(EXAmount, 0);

                                  ThisExemptionAmountsArray[I] := EXAmount;

                                end;  {If EXAppliesArray[I]}

                        end;  {else of If ParcelIsCondo(ParcelTable)}

                  end;  {If ExemptionIsColdWarVeteran(FieldByName('ExemptionCode').AsString)}

              {For aged exemptions, the percent must be between 10% and 50% in increments
               of 5%. The default is 50%.}
              {CHG04161998-1: Add the 4193x limited income diabled
                              exemption. It is the same as 4180x.}
              {CHG12291998-1: Malta has 4190x physically disabled limited income
                              which is same as senior.}
              {CHG08132008-1(2.15.1.5): Add 4191x as a low income disabled exemption.}

            If ((Take(4, ParcelExemptionTable.FieldByName('ExemptionCode').Text) = '4180') or
                ExemptionIsLowIncomeDisabled(ParcelExemptionTable.FieldByName('ExemptionCode').AsString) or
(*              (Take(4, ParcelExemptionTable.FieldByName('ExemptionCode').Text) = '4193') or *)
                (Take(4, ParcelExemptionTable.FieldByName('ExemptionCode').Text) = '4190'))
              then
                begin
                  SpecialCase := True;

                    {FXX09151998-1: Just use the flat amount given in the exemption
                                    record for condos.}

                    {FXX12291998-2: LB does not use override amounts for condos and we must calc
                                    amount.}

                    {FXX03111999-2: Remove condo exemption override and
                                    was using ParcelIsCondo routine.}

                  If PropertyIsCoopOrMobileHomePark(ParcelTable)
                    then
                      begin
                        ExemptionRecalculated := False;
                        For I := 1 to 4 do
                          If EXAppliesArray[I]
                            then
                              begin
                                ExAmount := Roundoff(ParcelExemptionTable.FieldByName('Amount').AsFloat, 0);

                                ThisExemptionAmountsArray[I] := EXAmount;

                              end;  {If EXAppliesArray[I]}

                      end
                    else
                      begin
                        Percent := ParcelExemptionTable.FieldByName('Percent').AsFloat;

                          {If the percent is zero, then they are just adding this exemption,
                           so we should default it to 50%. Otherwise, we will just use the
                           percent that they already entered.}

                        If (Roundoff(Percent, 0) = 0)
                          then FixedPercent := 50
                          else FixedPercent := Roundoff(Percent, 0);

                          {To figure out the aged amount, first apply all other non aged and non non-residential
                           only exemptions. Then subtract the amount for this municpality type.}
                          {FXX02091998-1: Pass the residential type of each exemption.}

                        ExemptionTotalsArray := TotalExemptionsForParcel(TaxRollYr,
                                                                SwisSBLKey,
                                                                ParcelExemptionLookupTable,
                                                                ExemptionCodeTable,
                                                                ParcelTable.FieldByName('HomesteadCode').Text,
                                                                'N',
                                                                ExemptionCodes,
                                                                ExemptionHomesteadCodes,
                                                                ResidentialTypes,
                                                                CountyExemptionAmounts,
                                                                TownExemptionAmounts,
                                                                SchoolExemptionAmounts,
                                                                VillageExemptionAmounts,
                                                                BasicSTARAmount,
                                                                EnhancedSTARAmount);

                          {FXX02091998-1: Calculate the amount of the exemptions
                                          that apply to residential, nonresidential
                                          or both if there is a residential percent.}

                        GetResidentialExemptionAmounts(ResidentialExemptionAmounts,
                                                       FullParcelExemptionAmounts,
                                                       NonResidentialExemptionAmounts,
                                                       ResidentialTypes,
                                                       CountyExemptionAmounts,
                                                       TownExemptionAmounts,
                                                       SchoolExemptionAmounts,
                                                       VillageExemptionAmounts);

                        ResidentialPercent := GetResidentialPercent(ParcelTable,
                                                                    ExemptionCodeTable,
                                                                    EXCode);

                        GetHomesteadAndNonhstdExemptionAmounts(ExemptionCodes,
                                                               ExemptionHomesteadCodes,
                                                               CountyExemptionAmounts,
                                                               TownExemptionAmounts,
                                                               SchoolExemptionAmounts,
                                                               VillageExemptionAmounts,
                                                               HstdEXAmounts,
                                                               NonhstdEXAmounts);

                          {If this is a split parcel, we only want to subtract
                           homestead or non-homestead exemptions depending on
                           what this exemption applies to.}

                        If (ParcelTable.FieldByName('HomesteadCode').Text = SplitParcel)
                          then
                            If (ParcelExemptionTable.FieldByName('HomesteadCode').Text = NonhomesteadParcel)
                              then ExemptionTotalsArray := NonhstdEXAmounts
                              else ExemptionTotalsArray := HstdEXAmounts;

                             {Now fill in the amounts on a per municipality
                              type basis (county, town, school, village).
                              Note that if the exemption applies to this
                              municipality type, we will figure out the
                              exemption amount for THIS municipality basis
                              only since the totals may be different.}

                           For I := 1 to 4 do
                             If EXAppliesArray[I]
                               then
                                 begin
                                      {FXX10151997-3: Apply the residential percent after
                                                      subtracting the exemption amount -
                                                      to make MP totals balance.}

      (*                             EXAmount := (TotalAssessedVal - ExemptionTotalsArray[I]) *
                                               ResidentialPercent *
                                               Roundoff((FixedPercent/100), 2); {MP}

                                   EXAmount := ((TotalAssessedVal * ResidentialPercent) -
                                                ExemptionTotalsArray[I]) *
                                               Roundoff((FixedPercent/100), 2);  {Ramapo & LB} *)

                                    EXAmount := CalculateExemptionWithResidentialPercent(
                                                           TotalAssessedVal,
                                                           ResidentialExemptionAmounts,
                                                           FullParcelExemptionAmounts,
                                                           NonResidentialExemptionAmounts,
                                                           ResidentialPercent,
                                                           FixedPercent,
                                                           ResidentialType, I);

                                   EXAmount := Roundoff((EXAmount * (OwnerPercent / 100)), 0);
                                   ThisExemptionAmountsArray[I] := EXAmount;

                                 end;  {If EXAppliesArray[I]}

                      end;  {else of If ParcelIsCondo(ParcelTable)}

                end;  {If (Take(4, ParcelExemptionTable.FieldByName('ExemptionCode').Text) = '4180')}

              {System exemptions. The amount is the difference
               between the total assessed value and any exemptions
               so far.}

            If (Take(1, ParcelExemptionTable.FieldByName('ExemptionCode').Text) = '5')
              then
                begin
                  SpecialCase := True;

                  For I := 1 to 4 do
                    If EXAppliesArray[I]
                      then
                        begin
                          EXAmount := TotalAssessedVal - ExemptionTotalsArray[I];

                          EXAmount := Roundoff(EXAmount, 0);
                          ThisExemptionAmountsArray[I] := EXAmount;

                        end;  {If EXAppliesArray[I]}

                end;  {If (Take(1, ParcelExemptionTable.FieldByName('ExemptionCode').Text) = '5')}

              {If this is not a special case, calculate as a percent
               of the total value.}

            If not SpecialCase
              then
                begin
                    {If the percent is zero, then they are just adding this exemption,
                     so we should default it to 100%. Otherwise, we will just use the
                     percent that they already entered.}

                  Percent := ParcelExemptionTable.FieldByName('Percent').AsFloat;

                  If (Roundoff(Percent, 0) = 0)
                    then FixedPercent := 100
                    else FixedPercent := Roundoff(Percent, 0);

                  For I := 1 to 4 do
                    If EXAppliesArray[I]
                      then
                        begin
                          EXAmount := (TotalAssessedVal - ExemptionTotalsArray[I]) *
                                      Roundoff((Percent / 100), 2);
                          EXAmount := Roundoff(EXAmount, 0);

                          ThisExemptionAmountsArray[I] := EXAmount;

                        end;  {If EXAppliesArray[I]}

                end;  {If not SpecialCase}

          end;  {blank}

      end;  {case CalcCode[1] of}

  For I := 1 to 4 do
    Result[I] := Roundoff(ThisExemptionAmountsArray[I], 0);  {Whole dollars only.}

  ExemptionCodes.Free;
  ExemptionHomesteadCodes.Free;
  ResidentialTypes.Free;
  CountyExemptionAmounts.Free;
  TownExemptionAmounts.Free;
  SchoolExemptionAmounts.Free;
  VillageExemptionAmounts.Free;

end;  {CalculateExemptionAmount}

{===========================================================================}
Procedure RecalculateExemptionsForParcel(ExemptionCodeTable,
                                         ParcelExemptionTable,
                                         AssessmentTable,
                                         ClassTable,
                                         SwisCodeTable,
                                         ParcelTable : TTable;
                                         TaxRollYear : String;
                                         SwisSBLKey : String;
                                         ExemptionsNotRecalculatedList : TStringList;
                                         iLandValue : LongInt;
                                         iAssessedValue : LongInt;
                                         bUseOverrideAssessedValue : Boolean);

{Recalculate all the exemptions for this parcel.}

type
  ExemptionSortRecord = record
    ExemptionCode : String;
    ExemptionType : Char;  {(F)ixed, (P)ercentage,
                            (X) = Aged and limited income disabled, (Z)=STAR}
  end;

  PExemptionSortRecord = ^ExemptionSortRecord;

var
  EXAmountsArray, TotalEXAmountsArray : ExemptionTotalsArrayType;

  Found,
  SpecialCase, Done, Quit, FirstTimeThrough,
  VetMaxSet, EqualizationRateFilledIn : Boolean;

  FixedPercent : Comp;
  I, J, ExIdx : Integer;
  TempStr : String;
  ExemptionList,
  BookmarkList : TList;
  PExemptionSortRec : PExemptionSortRecord;
  TempBookmark : TBookmark;
  CalcCode : String;
  ParcelExemptionLookupTable : TTable;
  ExAppliesArray : ExemptionAppliesArrayType;
  ExemptionRecalculated : Boolean;

begin
    {CHG01282004-1(2.08): Display exemptions not recalculated.  Can be nil if don't care.}

  If (ExemptionsNotRecalculatedList <> nil)
    then ExemptionsNotRecalculatedList.Clear;

  ExemptionList := TList.Create;
  BookmarkList := TList.Create;

  For I := 1 to 4 do
    begin
      EXAmountsArray[I] := 0;
      TotalEXAmountsArray[I] := 0;
    end;

  ParcelExemptionTable.CancelRange;
  SetRangeOld(ParcelExemptionTable,
              ['TaxRollYr', 'SwisSBLKey', 'ExemptionCode'],
              [TaxRollYear, SwisSBLKey, '     '],
              [TaxRollYear, SwisSBLKey, 'ZZZZZ']);

  Done := False;
  Quit := False;
  FirstTimeThrough := True;

  ParcelExemptionTable.First;

  If not (Done or Quit)
    then
      repeat
        If FirstTimeThrough
          then FirstTimeThrough := False
          else ParcelExemptionTable.Next;

          {If the SBL changes or we are at the end of the range, we are done.}

        TempStr := ParcelExemptionTable.FieldByName('SwisSBLKey').Text;

        If ParcelExemptionTable.EOF
          then Done := True;

          {We have an exemption record, so get the totals.}
          {FXX04181999-1: Some exemptions got out with a blank code.}

        If ((not (Done or Quit)) and
            (Deblank(ParcelExemptionTable.FieldByName('ExemptionCode').Text) <> ''))
          then
            begin
              New(PExemptionSortRec);
              PExemptionSortRec^.ExemptionCode := ParcelExemptionTable.FieldByName('ExemptionCode').Text;

                {Look up the exemption code in the exemption code table
                 so that we can figure out what kind it is.}

              Found := FindKeyOld(ExemptionCodeTable, ['EXCode'],
                                  [PExemptionSortRec^.ExemptionCode]);

              If not Found
                then
                  begin
                    Quit := True;
                    SystemSupport(964, ExemptionCodeTable,
                      'Error getting exemption code record. ' +
                      PExemptionSortRec^.ExemptionCode +' - ' +
                      Swissblkey,
                                  'PASUTILS.PAS', GlblErrorDlgBox);
                  end;

              CalcCode := ExemptionCodeTable.FieldByName('CalcMethod').Text;

              If (Deblank(CalcCode) = '')
                then CalcCode := ' ';

                {CHG12011997-2: STAR support}

              case CalcCode[1] of
                EXCMethF : If ExemptionIsSTAR(PExemptionSortRec^.ExemptionCode)
                             then PExemptionSortRec^.ExemptionType := 'Z'  {Always last}
                             else PExemptionSortRec^.ExemptionType := 'F';  {Fixed}

                EXCMethI,  {Improve val}
                EXCMethL,  {land val}
                EXCMethT,  {total val}
                EXCMethV : {variable amount}
                  PExemptionSortRec^.ExemptionType := 'F';

                EXCMethP : {Fixed %}
                  PExemptionSortRec^.ExemptionType := 'P';

                ' ' : begin  {Special case}
                        SpecialCase := False;

                          {Ratio vet is fixed.}

                        If (Take(4, PExemptionSortRec^.ExemptionCode) = '4110')
                          then
                            begin
                              PExemptionSortRec^.ExemptionType := 'F';
                              SpecialCase := True;
                            end;

                           {Vet, combat vet, and disabled vet are percentage.}

                        If ((Take(4, PExemptionSortRec^.ExemptionCode) = '4112') or
                            (Take(4, PExemptionSortRec^.ExemptionCode) = '4113') or
                            (Take(4, PExemptionSortRec^.ExemptionCode) = '4114'))
                          then
                            begin
                              PExemptionSortRec^.ExemptionType := 'P';
                              SpecialCase := True;
                            end;

                          {Aged and limited income disabled.}

                          {CHG04161998-1: Add the 4193x limited income diabled
                                          exemption. It is the same as 4180x.}
                          {CHG12291998-1: Malta has 4190x physically disabled limited income
                                          which is same as senior.}
                          {CHG08132008-1(2.15.1.5): Add 4191x as a low income disabled exemption.}

                        If ((Take(4, PExemptionSortRec^.ExemptionCode) = '4180') or
                            ExemptionIsLowIncomeDisabled(PExemptionSortRec^.ExemptionCode) or
(*                            (Take(4, PExemptionSortRec^.ExemptionCode) = '4193') or *)
                            (Take(4, PExemptionSortRec^.ExemptionCode) = '4190'))
                          then
                            begin
                              PExemptionSortRec^.ExemptionType := 'X';
                              SpecialCase := True;
                            end;

                          {Anything else is percentage.}

                        If not SpecialCase
                          then PExemptionSortRec^.ExemptionType := 'P';

                      end;  {' ' : begin  (Special case)}

              end;  {case CalcCode of}

                {Add a bookmark on the list for this exemption code record.
                 This is in case there are 2 exemptions of the same code.
                 If we did a find key, we would always get the 1st one
                 twice. Instead, we will look up the exemptions by
                 bookmark whend we recalculate.}

              BookmarkList.Add(ParcelExemptionTable.GetBookmark);

              ExemptionList.Add(PExemptionSortRec);

            end;  {If not (Done or Quit)}

      until (Done or Quit);

    {Now sort the exemption list.}

  For I := 0 to (ExemptionList.Count - 1) do
    For J := (I + 1) to (ExemptionList.Count - 1) do
      If (PExemptionSortRecord(ExemptionList[J])^.ExemptionType <
          PExemptionSortRecord(ExemptionList[I])^.ExemptionType)
        then
          begin
              {The Jth exemption should be calculated before the Ith exemption
               So, we will swap the exemptions and the bookmarks that
               point to the exemption records.}

            PExemptionSortRec := ExemptionList[I];
            ExemptionList[I] := ExemptionList[J];
            ExemptionList[J] := PExemptionSortRec;

            TempBookmark := BookmarkList[I];
            BookmarkList[I] := BookmarkList[J];
            BookmarkList[J] := TempBookmark;

          end;  {If (PExemptionSortRec(ExemptionList[J])^.ExemptionType ...}

    {Now go through the exemptions and recalculate each one.}

  I := 0;

  ParcelExemptionLookupTable := nil;

  If (ExemptionList.Count > 0)
    then
      begin
        ParcelExemptionLookupTable := TTable.Create(nil);

        OpenTableForProcessingType(ParcelExemptionLookupTable, ExemptionsTableName,
                                   GetProcessingTypeForTaxRollYear(TaxRollYear),
                                   Quit);

      end;  {If (ExemptionList.Count > 0)}

  while ((I <= (ExemptionList.Count - 1)) and
         (not Quit)) do
    begin
      ParcelExemptionTable.GotoBookmark(BookmarkList[I]);

        {Recalculate the exemption amounts and store them.}

      EXAmountsArray := CalculateExemptionAmount(ExemptionCodeTable,
                                                 ParcelExemptionTable,
                                                 ParcelExemptionLookupTable,
                                                 AssessmentTable,
                                                 ClassTable,
                                                 SwisCodeTable,
                                                 ParcelTable,
                                                 TaxRollYear, SwisSBLKey,
                                                 FixedPercent,
                                                 VetMaxSet,
                                                 EqualizationRateFilledIn,
                                                 ExemptionRecalculated,
                                                 iLandValue,
                                                 iAssessedValue,
                                                 bUseOverrideAssessedValue);

        {CHG01282004-1(2.08): Display exemptions not recalculated.  Can be nil if don't care.}

      If ((not ExemptionRecalculated) and
          (ExemptionsNotRecalculatedList <> nil))
        then ExemptionsNotRecalculatedList.Add(ParcelExemptionTable.FieldByName('ExemptionCode').Text);

      with ParcelExemptionTable do
        try
          Edit;

            {Let's make sure that the town amount field has not been
             set to read only.}

          FieldByName('TownAmount').ReadOnly := False;

            {CHG10161997-1: Fill in the amount field with an exemption amount.
                            This is what will display on screen.}

          ExAppliesArray := ExApplies(FieldByName('ExemptionCode').Text,
                                      FieldByName('ApplyToVillage').AsBoolean);
          ExIdx := GetExemptionAmountToDisplay(EXAppliesArray);
          TCurrencyField(FieldByName('Amount')).Value := EXAmountsArray[ExIdx];

          TCurrencyField(FieldByName('CountyAmount')).Value := EXAmountsArray[EXCounty];
          TCurrencyField(FieldByName('TownAmount')).Value := EXAmountsArray[EXTown];
          TCurrencyField(FieldByName('SchoolAmount')).Value := EXAmountsArray[EXSchool];
          TCurrencyField(FieldByName('VillageAmount')).Value := EXAmountsArray[EXVillage];

          TotalEXAmountsArray[EXCounty] := TotalEXAmountsArray[EXCounty] + EXAmountsArray[EXCounty];
          TotalEXAmountsArray[EXTown] := TotalEXAmountsArray[EXTown] + EXAmountsArray[EXTown];
          TotalEXAmountsArray[EXSchool] := TotalEXAmountsArray[EXSchool] + EXAmountsArray[EXSchool];
          TotalEXAmountsArray[EXVillage] := TotalEXAmountsArray[EXVillage] + EXAmountsArray[EXVillage];

          Post;
        except
          Quit := True;
          SystemSupport(965, ParcelExemptionTable, 'Error updating parcel exemption record.',
                        'PASUTILS.PAS', GlblErrorDlgBox);
        end;

      I := I + 1;

    end;  {For I := 0 to (ExemptionList.Count - 1) do}

  If (ExemptionList.Count > 0)
    then
      begin
        ParcelExemptionLookupTable.Close;
        ParcelExemptionLookupTable.Free;
      end;

  FreeTList(ExemptionList, SizeOf(ExemptionSortRecord));

  For I := BookMarkList.Count-1 downto 0 do
    ParcelExemptionTable.FreeBookMark(BookmarkList[I]);

  BookmarkList.Free;

end;  {RecalculateExemptionsForParcel}

{===========================================================================}
Function ExemptionExistsForParcel(ExemptionCode : String;
                                  TaxRollYear : String;
                                  SwisSBLKey : String;
                                  ComparisonLength : Integer;  {Number of chars to compare on}
                                  ParcelExemptionTable : TTable) : Boolean;

{Go through all the exemptions and see if this exemption code exists.}

var
  Done, Quit, FirstTimeThrough : Boolean;
  TempStr : String;

begin
  Result := False;
  ParcelExemptionTable.CancelRange;
  SetRangeOld(ParcelExemptionTable,
              ['TaxRollYr', 'SwisSBLKey', 'ExemptionCode'],
              [TaxRollYear, SwisSBLKey, '     '],
              [TaxRollYear, SwisSBLKey, 'ZZZZZ']);

  Done := False;
  Quit := False;
  FirstTimeThrough := True;

  ParcelExemptionTable.First;

  If not (Done or Quit)
    then
      repeat
        If FirstTimeThrough
          then FirstTimeThrough := False
          else ParcelExemptionTable.Next;

          {If the SBL changes or we are at the end of the range, we are done.}

        TempStr := ParcelExemptionTable.FieldByName('SwisSBLKey').Text;

        If ParcelExemptionTable.EOF
          then Done := True;

          {We have an exemption record, so get the totals.}

        If not (Done or Quit)
          then
            begin
              If (Take(ComparisonLength, ParcelExemptionTable.FieldByName('ExemptionCode').Text) =
                  Take(ComparisonLength, ExemptionCode))
                then Result := True;

            end;  {If not (Done or Quit)}

      until (Done or Quit);

end;  {ExemptionExistsForParcel}

{=================================================================================}
Procedure GetExemptionCodesForParcel(TaxRollYr : String;
                                     SwisSBLKey : String;
                                     ExemptionTable : TTable;
                                     ExemptionList : TStringList);

{Return a list of the exemption codes on a parcel.}

var
  Done, FirstTimeThrough : Boolean;

begin
  Done := False;
  FirstTimeThrough := True;

  SetRangeOld(ExemptionTable, ['TaxRollYr', 'SwisSBLKey', 'ExemptionCode'],
              [TaxRollYr, SwisSBLKey, '     '],
              [TaxRollYr, SwisSBLKey, 'ZZZZZ']);

  ExemptionTable.First;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else ExemptionTable.Next;

    If ExemptionTable.EOF
      then Done := True;

    If not Done
      then ExemptionList.Add(Take(5, ExemptionTable.FieldByName('ExemptionCode').Text));

  until Done;

end;  {GetExemptionCodesForParcel}

{=================================================================================================}
Procedure DisplayExemptionsNotRecalculatedForm(MasterExemptionsNotRecalculatedList : TStringList);

{CHG01282004-1(2.08): Display exemptions not recalculated.  Can be nil if don't care.}

begin
  If _Compare(MasterExemptionsNotRecalculatedList.Count, 0, coGreaterThan)
    then
      try
        ExemptionsNotRecalculatedForm := TExemptionsNotRecalculatedForm.Create(nil);
        ExemptionsNotRecalculatedForm.ExemptionsNotRecalculatedList := MasterExemptionsNotRecalculatedList;
        ExemptionsNotRecalculatedForm.InitializeForm;
        ExemptionsNotRecalculatedForm.ShowModal;
      finally
        ExemptionsNotRecalculatedForm.Free;
      end;

end;  {DisplayExemptionsNotRecalculatedForm}

{=================================================================================================}
Procedure RecalculateAllExemptions(    Form : TForm;
                                       ProgressDialog : TProgressDialog;
                                       ProcessingType : Integer;
                                       AssessmentYear : String;
                                       DisplayExemptionsNotRecalculated : Boolean;
                                   var Quit : Boolean);

var
  Done, FirstTimeThrough, ExemptionAmountsChanged : Boolean;
  I, RecCount : LongInt;
  SwisSBLKey : String;
  ParcelTable, ExemptionCodeTable, ParcelExemptionTable,
  AssessmentTable, ClassTable, SwisCodeTable, AuditEXChangeTable : TTable;
  AuditEXChangeList, NewAuditEXChangeList : TList;

  OrigExemptionCodes,
  OrigExemptionHomesteadCodes,
  OrigResidentialTypes,
  OrigCountyExemptionAmounts,
  OrigTownExemptionAmounts,
  OrigSchoolExemptionAmounts,
  OrigVillageExemptionAmounts,
  NewExemptionCodes,
  NewExemptionHomesteadCodes,
  NewResidentialTypes,
  NewCountyExemptionAmounts,
  NewTownExemptionAmounts,
  NewSchoolExemptionAmounts,
  NewVillageExemptionAmounts : TStringList;

  TotalOrigExemptionAmount,
  TotalNewExemptionAmount,
  TotalOrigCountyExemptionAmount,
  TotalOrigTownExemptionAmount,
  TotalOrigSchoolExemptionAmount,
  TotalOrigVillageExemptionAmount,
  TotalOrigBasicSTARAmount,
  TotalOrigEnhancedSTARAmount,
  TotalNewCountyExemptionAmount,
  TotalNewTownExemptionAmount,
  TotalNewSchoolExemptionAmount,
  TotalNewVillageExemptionAmount,
  TotalNewBasicSTARAmount,
  TotalNewEnhancedSTARAmount : Comp;

  OrigBasicSTARAmount, OrigEnhancedSTARAmount,
  NewBasicSTARAmount, NewEnhancedSTARAmount : Comp;
  ExemptionsNotRecalculatedList, MasterExemptionsNotRecalculatedList : TStringList;

begin
  AuditEXChangeList := TList.Create;
  NewAuditEXChangeList := TList.Create;
  ExemptionsNotRecalculatedList := TStringList.Create;
  MasterExemptionsNotRecalculatedList := TStringList.Create;
  FirstTimeThrough := True;
  Done := False;

  OrigExemptionCodes := TStringList.Create;
  OrigExemptionHomesteadCodes := TStringList.Create;
  OrigResidentialTypes := TStringList.Create;
  OrigCountyExemptionAmounts := TStringList.Create;
  OrigTownExemptionAmounts := TStringList.Create;
  OrigSchoolExemptionAmounts := TStringList.Create;
  OrigVillageExemptionAmounts := TStringList.Create;

  NewExemptionCodes := TStringList.Create;
  NewExemptionHomesteadCodes := TStringList.Create;
  NewResidentialTypes := TStringList.Create;
  NewCountyExemptionAmounts := TStringList.Create;
  NewTownExemptionAmounts := TStringList.Create;
  NewSchoolExemptionAmounts := TStringList.Create;
  NewVillageExemptionAmounts := TStringList.Create;

  TotalOrigCountyExemptionAmount := 0;
  TotalOrigTownExemptionAmount := 0;
  TotalOrigSchoolExemptionAmount := 0;
  TotalOrigVillageExemptionAmount := 0;
  TotalNewCountyExemptionAmount := 0;
  TotalNewTownExemptionAmount := 0;
  TotalNewSchoolExemptionAmount := 0;
  TotalNewVillageExemptionAmount := 0;

  TotalOrigBasicSTARAmount := 0;
  TotalOrigEnhancedSTARAmount := 0;
  TotalNewBasicSTARAmount := 0;
  TotalNewEnhancedSTARAmount := 0;

  ExemptionCodeTable := TTable.Create(nil);
  ParcelExemptionTable := TTable.Create(nil);
  AssessmentTable := TTable.Create(nil);
  ClassTable := TTable.Create(nil);
  SwisCodeTable := TTable.Create(nil);
  ParcelTable := TTable.Create(nil);
  AuditEXChangeTable := TTable.Create(nil);

  OpenTableForProcessingType(ExemptionCodeTable, ExemptionCodesTableName,
                             ProcessingType, Quit);
  OpenTableForProcessingType(ParcelExemptionTable, ExemptionsTableName,
                             ProcessingType, Quit);
  OpenTableForProcessingType(AssessmentTable, AssessmentTableName,
                             ProcessingType, Quit);
  OpenTableForProcessingType(ClassTable, ClassTableName,
                             ProcessingType, Quit);
  OpenTableForProcessingType(SwisCodeTable, SwisCodeTableName,
                             ProcessingType, Quit);
  OpenTableForProcessingType(ParcelTable, ParcelTableName,
                             ProcessingType, Quit);
  OpenTableForProcessingType(AuditEXChangeTable, 'AuditEXChangeTbl',
                             ProcessingType, Quit);

  ExemptionCodeTable.IndexName := 'BYEXCode';
  ParcelExemptionTable.IndexName := 'BYYEAR_SWISSBLKEY_EXCODE';
  AssessmentTable.IndexName := 'BYTAXROLLYR_SWISSBLKEY';
  ClassTable.IndexName := 'BYTAXROLLYR_SWISSBLKEY';
  SwisCodeTable.IndexName := 'BYSWISCODE';
  ParcelTable.IndexName := 'BYTAXROLLYR_SWISSBLKEY';

    {FXX03152004-1(2.08): Make sure to limit the swis code records for history exemption recalc.}

  If (ProcessingType = History)
    then
      begin
        SwisCodeTable.Filter := 'TaxRollYr = ' + GlblHistYear;
        SwisCodeTable.Filtered := True;
      end;

  ParcelTable.First;

  ProgressDialog.Reset;
  ProgressDialog.TotalNumRecords := GetRecordCount(ParcelTable);
  ProgressDialog.UserLabelCaption := 'Recalculating Exemptions.';

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else ParcelTable.Next;

    If ParcelTable.EOF
      then Done := True;

    Application.ProcessMessages;

    If not Done
      then
        begin
          SwisSBLKey := ExtractSSKey(ParcelTable);

          If (ProgressDialog <> nil)
            then ProgressDialog.Update(Form, ConvertSwisSBLToDashDot(SwisSBLKey));

          TotalExemptionsForParcel(AssessmentYear, SwisSBLKey,
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

            {CHG06222003-2(2.07e): Audit exemptions that are recalculated.}

          ClearTList(AuditEXChangeList, SizeOf(AuditEXRecord));
          GetAuditEXList(SwisSBLKey, AssessmentYear, ParcelExemptionTable, AuditEXChangeList);

          RecalculateExemptionsForParcel(ExemptionCodeTable,
                                         ParcelExemptionTable,
                                         AssessmentTable,
                                         ClassTable,
                                         SwisCodeTable,
                                         ParcelTable,
                                         AssessmentYear,
                                         SwisSBLKey, ExemptionsNotRecalculatedList,
                                         0, 0, False);

          If (ExemptionsNotRecalculatedList.Count > 0)
            then
              For I := 0 to (ExemptionsNotRecalculatedList.Count - 1) do
                begin
                  MasterExemptionsNotRecalculatedList.Add(SwisSBLKey);
                  MasterExemptionsNotRecalculatedList.Add(ExemptionsNotRecalculatedList[I]);
                end;

          TotalExemptionsForParcel(AssessmentYear, SwisSBLKey,
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

            {Now see if anything changed. Note that the # of exemptions
             and their positions in the list will be the same.}

          ExemptionAmountsChanged := False;

          For I := 0 to (OrigExemptionCodes.Count - 1) do
            If ((OrigCountyExemptionAmounts[I] <> NewCountyExemptionAmounts[I]) or
                (OrigTownExemptionAmounts[I] <> NewTownExemptionAmounts[I]) or
                (OrigSchoolExemptionAmounts[I] <> NewSchoolExemptionAmounts[I]) or
                (OrigVillageExemptionAmounts[I] <> NewVillageExemptionAmounts[I]))
              then ExemptionAmountsChanged := True;

          If ((OrigBasicSTARAmount <> NewBasicSTARAmount) or
              (OrigEnhancedSTARAmount <> NewEnhancedSTARAmount))
            then ExemptionAmountsChanged := True;

          If ExemptionAmountsChanged
            then
              begin
                InsertAuditEXChanges(SwisSBLKey, AssessmentYear, AuditEXChangeList,
                                     AuditEXChangeTable, 'B');

                ClearTList(NewAuditEXChangeList, SizeOf(AuditEXRecord));
                GetAuditEXList(SwisSBLKey, AssessmentYear, ParcelExemptionTable, NewAuditEXChangeList);
                InsertAuditEXChanges(SwisSBLKey, AssessmentYear, NewAuditEXChangeList,
                                     AuditEXChangeTable, 'A');

              end;  {If ExemptionAmountsChanged}

        end;  {If not Done}

  until Done;

  ExemptionCodeTable.Close;
  ParcelExemptionTable.Close;
  AssessmentTable.Close;
  ClassTable.Close;
  SwisCodeTable.Close;
  ParcelTable.Close;
  AuditEXChangeTable.Close;

  ExemptionCodeTable.Free;
  ParcelExemptionTable.Free;
  AssessmentTable.Free;
  ClassTable.Free;
  SwisCodeTable.Free;
  ParcelTable.Free;
  AuditEXChangeTable.Free;

  FreeTList(AuditEXChangeList, SizeOf(AuditEXRecord));
  FreeTList(NewAuditEXChangeList, SizeOf(AuditEXRecord));

    {CHG01282004-1(2.08): Display exemptions not recalculated.  Can be nil if don't care.}

  If DisplayExemptionsNotRecalculated
    then DisplayExemptionsNotRecalculatedForm(MasterExemptionsNotRecalculatedList);

  ExemptionsNotRecalculatedList.Free;
  MasterExemptionsNotRecalculatedList.Free;

end;  {RecalculateAllExemptions}

{==========================================================================}
Function IsBIEExemptionCode(ExemptionCode : String) : Boolean;

{FXX12081999-4: Need function to test for BIE in case not 47600.}
{CHG07172004-2(2.08): Exemptions starting with 4761 are BIE, also.}

begin
  Result := ((Take(4, ExemptionCode) = '4760') or
             (Take(4, ExemptionCode) = '4761'));
end;

{==========================================================================}
Function ParcelHasSTAR(ExemptionTable : TTable;
                       SwisSBLKey : String;
                       AssessmentYear : String) : Boolean;

begin
  Result := FindKeyOld(ExemptionTable, ['TaxRollYr', 'SwisSBLKey', 'ExemptionCode'],
                       [AssessmentYear, SwisSBLKey, BasicSTARExemptionCode]);

  Result := Result or FindKeyOld(ExemptionTable, ['TaxRollYr', 'SwisSBLKey', 'ExemptionCode'],
                                 [AssessmentYear, SwisSBLKey, EnhancedSTARExemptionCode]);

end;  {ParcelHasSTAR}

{==========================================================================}
Procedure DetermineExemptionReadOnlyAndRequiredFields(    ExemptionCodeLookupTable : TTable;
                                                          ParcelTable : TTable;
                                                          ExemptionCode : String;
                                                      var AmountFieldRequired : Boolean;
                                                      var AmountFieldReadOnly : Boolean;
                                                      var PercentFieldRequired : Boolean;
                                                      var PercentFieldReadOnly : Boolean;
                                                      var OwnerPercentFieldRequired : Boolean;
                                                      var OwnerPercentFieldReadOnly : Boolean;
                                                      var TerminationDateRequired : Boolean);

{FXX09292003-1(2.07j): Move this to a common procedure so that grievance
                       entry can follow the same rules for exemption entry.}

var
  ReadOnlyFieldsSet : Boolean;
  CalcCode : String;

begin
  AmountFieldRequired := False;
  AmountFieldReadOnly := False;
  PercentFieldRequired := False;
  PercentFieldReadOnly := False;
  OwnerPercentFieldRequired := False;
  OwnerPercentFieldReadOnly := False;
  TerminationDateRequired := False;

    {In some cases the calc method is blank (i.e. null), so let's force it to one
     blank space for the case statement below.}

  FindKeyOld(ExemptionCodeLookupTable, ['EXCode'], [ExemptionCode]);

  CalcCode := ExemptionCodeLookupTable.FieldByName('CalcMethod').Text;

  If (Deblank(CalcCode) = '')
    then CalcCode := ' ';

  case CalcCode[1] of
    ExCMethF :
     begin
         {CHG12011997-2: STAR support.  If this property is a co-op or
                         mobile home park, allow them to edit
                         the amount, since this is calculated by hand.}
         {CHG06062001-1: STAR can now be placed on mixed use 400 prop class.}

       If not ExemptionIsSTAR(ExemptionCode)
         then AmountFieldReadOnly := True;

       If (ExemptionIsSTAR(ExemptionCode) and
           (not PropertyIsCoopOrMobileHomePark(ParcelTable)) and
           (ParcelTable.FieldByName('PropertyClassCode').Text[1] <> '4'))
         then AmountFieldReadOnly := True;

       OwnerPercentFieldReadOnly := False;

     end;  {ExCMethF}

   ExCMethP,
   ExCMethL,
   ExCMethI,
   ExCMethT :
     begin
    {Ramapo has some total exemptions (type T) where they put a percent
     on the exemption rather than in the res. percent,
     so we will leave percent as changable.}

       AmountFieldReadOnly := True;
       OwnerPercentFieldReadOnly := True;
     end;  {ExCMethF, ...}

   ExCMethV :  {Variable amount}
     begin
      AmountFieldRequired := True;
      PercentFieldReadOnly := True;

        {If this is a veteran, they can enter the owner percent.
         Otherwise, they can not.}

       If (Take(4, ExemptionCode) <> '4110')
         then OwnerPercentFieldReadOnly := True;

         {11012013:  Allow percent entry for seniors that are being entered as variable flat amounts.}

       If _Compare(ExemptionCode, '4180', coStartsWith)
       then PercentFieldReadOnly := False;

     end;  {ExCMethV}

   ' ':  {Exception cases}
     begin
          {Exception cases such as business improvement, alt veteran, and
           aged are percent based.}

       ReadOnlyFieldsSet := False;

          {For ratio vets., they should enter % and the fixed amount. Note
           that the percent may not match the amount. That is, they may enter
           10% for a parcel with AV 30,000 but only have an amount of $2,500 since
           the exemption amount can never exceed the original, but they want to
           bring that ratio percent with them in case they move again to a parcel
           with AV under $25,000.}

       If (Take(4, ExemptionCode) = '4111')
         then
           begin
             ReadOnlyFieldsSet := True;
             AmountFieldRequired := True;

           end;  {If (Take(4, ExemptionCode) ...}

         {For war and combat veterans exemptions, the amount and % is read only.}
         {FXX10161998-2: Can have flat amount for co-op or mobile home.}

       If (((Take(4, ExemptionCode) = '4112') or
            (Take(4, ExemptionCode) = '4113')) and
           (not PropertyIsCoopOrMobileHomePark(ParcelTable)))
         then
           begin
             ReadOnlyFieldsSet := True;
             AmountFieldReadOnly := True;
             PercentFieldReadOnly := True;

           end;  {If (Take(4, ExemptionCode) ...}

          {For disabled vets., they enter a % and the fixed amount is calculated.}

       If ((Take(4, ExemptionCode) = '4114') and
           (not PropertyIsCoopOrMobileHomePark(ParcelTable)))
         then
           begin
             ReadOnlyFieldsSet := True;
             AmountFieldReadOnly := True;
             PercentFieldRequired := True;

           end;  {If (Take(4, ExemptionCode) ...}

         {For a exception exemption, make the owner percent and amount read only and
          make the percent required.}

       If ((not ReadOnlyFieldsSet) and
           (not PropertyIsCoopOrMobileHomePark(ParcelTable)))
         then
           begin
             AmountFieldReadOnly := True;
             PercentFieldRequired := True;

             {FXX04102012-1(MDT)[PAS-260]: Users should be able to enter an owner percent for special case exemptions.}
             
             (*OwnerPercentFieldReadOnly := True;  *)

           end;  {If not ReadOnlyFieldsSet}

     end;  {Exception cases}

  end;  {case CalcCode[1] of}

    {CHG07262004-2(2.07l5): Allow for override on the firefighter exemptions.}

  If (ExemptionIsVolunteerFirefighter(ExemptionCode) and
      PropertyIsCoopOrMobileHomePark(ParcelTable))
    then AmountFieldReadOnly := False;

    {If this exemption requires an expiration date, then make sure they enter it.}

  If ExemptionCodeLookupTable.FieldByName('ExpirationDateReqd').AsBoolean
    then TerminationDateRequired := True;

end;  {DetermineExemptionReadOnlyAndRequiredFields}

{==========================================================================}
Procedure DetermineAssessedAndTaxableValues(    AssessmentYear : String;
                                                SwisSBLKey : String;
                                                HomesteadCode : String;
                                                ExemptionTable : TTable;
                                                ExemptionCodeTable : TTable;
                                                AssessmentTable : TTable;
                                            var LandAssessedValue : LongInt;
                                            var TotalAssessedValue : LongInt;
                                            var CountyTaxableValue : LongInt;
                                            var MunicipalTaxableValue : LongInt;
                                            var SchoolTaxableValue : LongInt;
                                            var VillageTaxableValue : LongInt;
                                            var BasicSTARAmount : LongInt;
                                            var EnhancedSTARAmount : LongInt);

var
  ExemptArray : ExemptionTotalsArrayType;
  ExemptionCodes,
  ExemptionHomesteadCodes,
  ResidentialTypes,
  CountyExemptionAmounts,
  TownExemptionAmounts,
  SchoolExemptionAmounts,
  VillageExemptionAmounts : TStringList;
  _BasicSTARAmount, _EnhancedSTARAmount : Comp;

begin
  ExemptionCodes := TStringList.Create;
  ExemptionHomesteadCodes := TStringList.Create;
  ResidentialTypes := TStringList.Create;
  CountyExemptionAmounts := TStringList.Create;
  TownExemptionAmounts := TStringList.Create;
  SchoolExemptionAmounts := TStringList.Create;
  VillageExemptionAmounts := TStringList.Create;

  LandAssessedValue := 0;
  TotalAssessedValue := 0;
  CountyTaxableValue := 0;
  MunicipalTaxableValue := 0;
  SchoolTaxableValue := 0;
  VillageTaxableValue := 0;
  BasicSTARAmount := 0;
  EnhancedSTARAmount := 0;

  If FindKeyOld(AssessmentTable, ['TaxRollYr', 'SwisSBLKey'], [AssessmentYear, SwisSBLKey])
    then
      begin
        with AssessmentTable do
          begin
            LandAssessedValue := FieldByName('LandAssessedVal').AsInteger;
            TotalAssessedValue := FieldByName('TotalAssessedVal').AsInteger;
          end;

        ExemptArray := TotalExemptionsForParcel(AssessmentYear, SwisSBLKey,
                                                ExemptionTable,
                                                ExemptionCodeTable,
                                                HomesteadCode,
                                                'A',
                                                ExemptionCodes,
                                                ExemptionHomesteadCodes,
                                                ResidentialTypes,
                                                CountyExemptionAmounts,
                                                TownExemptionAmounts,
                                                SchoolExemptionAmounts,
                                                VillageExemptionAmounts,
                                                _BasicSTARAmount, _EnhancedSTARAmount);

        BasicSTARAmount := Trunc(_BasicSTARAmount);
        EnhancedSTARAmount := Trunc(_EnhancedSTARAmount);

        CountyTaxableValue := Trunc(CalculateTaxableVal(TotalAssessedValue, ExemptArray[EXCounty]));
        MunicipalTaxableValue := Trunc(CalculateTaxableVal(TotalAssessedValue, ExemptArray[EXTown]));
        SchoolTaxableValue := Trunc(CalculateTaxableVal(TotalAssessedValue, ExemptArray[EXSchool]));
        VillageTaxableValue := Trunc(CalculateTaxableVal(TotalAssessedValue, ExemptArray[EXVillage]));

      end;  {If FindKeyOld(AssessmentTable ...}

  ExemptionCodes.Free;
  ExemptionHomesteadCodes.Free;
  ResidentialTypes.Free;
  CountyExemptionAmounts.Free;
  TownExemptionAmounts.Free;
  SchoolExemptionAmounts.Free;
  VillageExemptionAmounts.Free;

end;  {DetermineTaxableValues}

{==========================================================================}
Function ProjectExemptions(tbSourceExemptions : TTable;
                           sTaxYear : String;
                           sSwisSBLKey : String;
                           iLandValue : LongInt;
                           iAssessedValue : LongInt;
                           iProcessingType : Integer) : ExemptionTotalsArrayType;

var
  tbTempExemptions, tbExemptionCodes, tbAssessments,
  tbClass, tbSwisCodes, tbParcels : TTable;
  slExemptionsNotRecalculated,
  slOrigExemptionCodes,
  slOrigExemptionHomesteadCodes,
  slOrigResidentialTypes,
  slOrigCountyExemptionAmounts,
  slOrigTownExemptionAmounts,
  slOrigSchoolExemptionAmounts,
  slOrigVillageExemptionAmounts : TStringList;
  I : Integer;
  OrigBasicSTARAmount, OrigEnhancedSTARAmount : Comp;


begin
  For I := 1 to 4 do
    Result[I] := 0;

  slOrigExemptionCodes := TStringList.Create;
  slOrigExemptionHomesteadCodes := TStringList.Create;
  slOrigResidentialTypes := TStringList.Create;
  slOrigCountyExemptionAmounts := TStringList.Create;
  slOrigTownExemptionAmounts := TStringList.Create;
  slOrigSchoolExemptionAmounts := TStringList.Create;
  slOrigVillageExemptionAmounts := TStringList.Create;

  slExemptionsNotRecalculated := TStringList.Create;
  tbTempExemptions := TTable.Create(nil);
  tbExemptionCodes := TTable.Create(nil);
  tbAssessments := TTable.Create(nil);
  tbClass := TTable.Create(nil);
  tbSwisCodes := TTable.Create(nil);
  tbParcels := TTable.Create(nil);

  _OpenTable(tbTempExemptions, 'SortTempExemptions', '', 'BYYEAR_SWISSBLKEY_EXCODE', NoProcessingType, []);

  _SetRange(tbTempExemptions, [sTaxYear, sSwisSBLKey, ''], [sTaxYear, sSwisSBlKey, '99999'], '', []);
  DeleteTableRange(tbTempExemptions);
  CopyTableRange(tbSourceExemptions, tbTempExemptions, 'SwisSBLKey', [], []);

  If _Compare(iProcessingType, NoProcessingType, coEqual)
    then iProcessingType := GetProcessingTypeForTaxRollYear(sTaxYear);
  _OpenTable(tbExemptionCodes, ExemptionCodesTableName, '', 'BYEXCODE', iProcessingType, []);
  _OpenTable(tbAssessments, AssessmentTableName, '', 'BYTAXROLLYR_SWISSBLKEY', iProcessingType, []);
  _OpenTable(tbClass, ClassTableName, '', 'BYTAXROLLYR_SWISSBLKEY', iProcessingType, []);
  _OpenTable(tbSwisCodes, SwisCodeTableName, '', 'BYSWISCODE', iProcessingType, []);
  _OpenTable(tbParcels, ParcelTableName, '', 'BYTAXROLLYR_SWISSBLKEY', iProcessingType, []);

  If _Locate(tbParcels, [sTaxYear, sSwisSBLKey], '', [loParseSwisSBLKey])
    then
      begin
        RecalculateExemptionsForParcel(tbExemptionCodes,
                                       tbTempExemptions,
                                       tbAssessments,
                                       tbClass,
                                       tbSwisCodes,
                                       tbParcels,
                                       sTaxYear,
                                       sSwisSBLKey,
                                       slExemptionsNotRecalculated,
                                       iLandValue,
                                       iAssessedValue,
                                       True);

        Result := TotalExemptionsForParcel(sTaxYear, sSwisSBLKey,
                                           tbTempExemptions,
                                           tbExemptionCodes,
                                           tbParcels.FieldByName('HomesteadCode').Text,
                                           'A',
                                           slOrigExemptionCodes,
                                           slOrigExemptionHomesteadCodes,
                                           slOrigResidentialTypes,
                                           slOrigCountyExemptionAmounts,
                                           slOrigTownExemptionAmounts,
                                           slOrigSchoolExemptionAmounts,
                                           slOrigVillageExemptionAmounts,
                                           OrigBasicSTARAmount,
                                           OrigEnhancedSTARAmount);

      end;  {If _Locate(tbParcels ...}

  tbTempExemptions.Close;
  tbExemptionCodes.Close;
  tbAssessments.Close;
  tbClass.Close;
  tbSwisCodes.Close;
  tbParcels.Close;

  tbTempExemptions.Free;
  tbExemptionCodes.Free;
  tbAssessments.Free;
  tbClass.Free;
  tbSwisCodes.Free;
  tbParcels.Free;

  slExemptionsNotRecalculated.Free;
  slOrigExemptionCodes.Free;
  slOrigExemptionHomesteadCodes.Free;
  slOrigResidentialTypes.Free;
  slOrigCountyExemptionAmounts.Free;
  slOrigTownExemptionAmounts.Free;
  slOrigSchoolExemptionAmounts.Free;
  slOrigVillageExemptionAmounts.Free;

end;  {ProjectExemptions}

{==========================================================================}
{=============    SPECIAL DISTRICT CALCULATION   ==========================}
{==========================================================================}
Procedure InsertOneSDChangeTrace(SwisSBLKey : String;
                                 TaxRollYr : String;
                                 ParcelSDistTable,
                                 AuditSDChangeTable : TTable;
                                 RecordType : Char;
                                 OrigSDRec : AuditSDRecord);
{CHG03161998-1: Track exemption, SD adds, av changes, parcel add/del.}

begin
  with AuditSDChangeTable do
    begin
      Insert;

      FieldByName('SwisSBLKey').Text := SwisSBLKey;
      FieldByName('TaxRollYr').Text := TaxRollYr;
      FieldByName('SDistCode').Text := ParcelSDistTable.FieldByName('SDistCode').Text;
      FieldByName('Date').AsDateTime := Date;
      FieldByName('Time').AsDateTime := Now;
      FieldByName('User').Text := GlblUserName;
      FieldByName('RecordType').Text := RecordType;

      If (RecordType in ['A', 'C'])
        then
          begin
            FieldByName('NewPrimaryUnits').AsFloat := ParcelSDistTable.FieldByName('PrimaryUnits').AsFloat;
            FieldByName('NewSecondaryUnits').AsFloat := ParcelSDistTable.FieldByName('SecondaryUnits').AsFloat;
            FieldByName('NewCalcAmount').AsFloat := ParcelSDistTable.FieldByName('CalcAmount').AsFloat;
            FieldByName('NewSDPercentage').AsFloat := ParcelSDistTable.FieldByName('SDPercentage').AsFloat;
            FieldByName('NewCalcCode').Text := ParcelSDistTable.FieldByName('CalcCode').Text;
          end
        else
          begin
            FieldByName('OldPrimaryUnits').AsFloat := ParcelSDistTable.FieldByName('PrimaryUnits').AsFloat;
            FieldByName('OldSecondaryUnits').AsFloat := ParcelSDistTable.FieldByName('SecondaryUnits').AsFloat;
            FieldByName('OldCalcAmount').AsFloat := ParcelSDistTable.FieldByName('CalcAmount').AsFloat;
            FieldByName('OldSDPercentage').AsFloat := ParcelSDistTable.FieldByName('SDPercentage').AsFloat;
            FieldByName('OldCalcCode').Text := ParcelSDistTable.FieldByName('CalcCode').Text;

          end;  {else of If ((RecordType in ['A', 'C'])}

        {In order to figure out what changed in the SD, we will look in the
         OrigSDAmounts list for this special district and then record those
         amounts.}

      If (RecordType = 'C')
        then
          with OrigSDRec do
            begin
              FieldByName('OldPrimaryUnits').AsFloat := PrimaryUnits;
              FieldByName('OldSecondaryUnits').AsFloat := SecondaryUnits;
              FieldByName('OldCalcAmount').AsFloat := CalcAmount;
              FieldByName('OldSDPercentage').AsFloat := SDPercentage;
              FieldByName('OldCalcCode').Text := CalcCode;

            end;  {with OrigSDRec do}

      try
        Post;
      except
        SystemSupport(969, AuditSDChangeTable, 'Error adding SD deletion trace rec.',
                      GlblUnitName, GlblErrorDlgBox);
      end;

    end;  {with AuditSDChangeTable do}

end;  {InsertOneSDChangeTrace}

{==========================================================================}
Procedure InsertAuditSDChanges(SwisSBLKey : String;
                               TaxRollYr : String;
                               ParcelSDTable,
                               AuditSDChangeTable : TTable;
                               RecordType : Char);

{CHG03301998-1: Trace SD, EX changes from everywhere.}
{Insert an add or delete trace record for all sd's for this parcel.}

var
  FirstTimeThrough, Done, Quit : Boolean;
  OrigSDRec : AuditSDRecord;

begin
  FirstTimeThrough := True;
  Done := False;
  Quit := False;

  SetRangeOld(ParcelSDTable,
              ['TaxRollYr', 'SwisSBLKey', 'SDistCode'],
              [TaxRollYr, SwisSBLKey, '     '],
              [TaxRollYr, SwisSBLKey, 'ZZZZZ']);

  ParcelSDTable.First;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else
        try
          ParcelSDTable.Next;
        except
          Quit := True;
          SystemSupport(970, ParcelSDTable, 'Error getting parcel SD rec.',
                        GlblUnitName, GlblErrorDlgBox);
        end;

    If ParcelSDTable.EOF
      then Done := True;

    If not (Done or Quit)
      then
        begin
          with OrigSDRec do
            begin
              PrimaryUnits := ParcelSDTable.FieldByName('PrimaryUnits').AsFloat;
              SecondaryUnits := ParcelSDTable.FieldByName('SecondaryUnits').AsFloat;
              CalcAmount := ParcelSDTable.FieldByName('CalcAmount').AsFloat;
              SDPercentage := ParcelSDTable.FieldByName('SDPercentage').AsFloat;
              CalcCode := Take(1, ParcelSDTable.FieldByName('CalcCode').Text)[1];

            end;  {with OrigSDRecord do}

          InsertOneSDChangeTrace(SwisSBLKey, TaxRollYr,
                                 ParcelSDTable,
                                 AuditSDChangeTable,
                                 RecordType, OrigSDRec);

        end;  {If not (Done or Quit)}

  until (Done or Quit);

end;  {InsertAuditSDChanges}

{==========================================================================}
Function SdExtType(ExtCode : String) : Char;

{input is ext code for spcl dist, output is ordinal constant as follows:
  'A' = Advalorum, 'U' = Unitary, 'D' = dimension, 'S' = stepped unitary,
  'F' = Fixed }

Begin
If (ExtCode = SDistEcIM)
            OR
   (ExtCode = SDistEcLD)
            OR
   (ExtCode = SDistEcTO)
   then SdExtType := SDExtCatA {Ad Valorum}
else If (ExtCode = SDistEcUN)
            OR
        (ExtCode = SDistEcSU)
   then SdExtType := SDExtCatU   {Unitary}
else If (ExtCode = SDistEcAC)
            OR
   (ExtCode = SDistEcFR)
            OR
   (ExtCode = SDistEcSQ)
   then SdExtType := SDExtCatD   {Dimension}
else If (ExtCode = SDistEcMT)
            OR
   (ExtCode = SDistEcFE)
   then SdExtType := SDExtCatF   {Fixed}
Else If (ExtCode = SDistEcF1)
            OR
   (ExtCode = SDistEcF2)
            OR
   (ExtCode = SDistEcF3)
            OR
   (ExtCode = SDistEcF4)
            OR
   (ExtCode = SDistEcU1)
            OR
   (ExtCode = SDistEcU2)
            OR
   (ExtCode = SDistEcU3)
            OR
   (ExtCode = SDistEcU4)
            OR
   (ExtCode = SDistEcS1)
            OR
   (ExtCode = SDistEcS2)
            OR
   (ExtCode = SDistEcS3)
            OR
   (ExtCode = SDistEcS4)
   then SdExtType := SdExtCatS  {Stepped Unitary}
   Else SDExtType := ' ';

end;  {SdExtType}

{===========================================================================}
Function ExemptionAppliesToSpecialDistrict(DistrictType : String;
                                           ExemptionCodeRec : ExemptionCodeRecord;
                                           CMFlag : String;
                                           SDAppliesToSection490,
                                           FireDistrict,
                                           VolunteerFirefighterOrAmbulanceExemptionApplies : Boolean) : Boolean; overload;

{Apply rules for what exemptions apply to what spcl districts and
 return results as a boolean  2/12/97 version.}

{CHG02221998-1 : For quicker roll total calcs,
                 only read exemptions 1 time.}

Var
   Applies : Boolean;

Begin
    {FXX12101998-5: Need to default applies to false.  In some cases, it was not
                    getting set.}

  Applies := False;

       {Case 1}
   If ExemptionCodeRec.AppliesToSection490
      then
      begin
      If ((DistrictType = SDAdValorumType)   {'A'}
                             OR
           (DistrictType = SDSpclAssessmentType)  {'S'}
         )
         then If SDAppliesToSection490
             then
             begin
             If CMFlag = SDMaintenanceCostType
                then Applies := True;  {Ex=490, SD = A/S, and
                                        (SD = 490 and Maint)}

             end
             else Applies := True;  {Ex=490, SD = A/S, and NOT 490}
      end
           {Case 2: Ex applies to  Advalorum}
      else If ExemptionCodeRec.AppliesToAdValorumDistrict
      then
      begin

           {Case 2a: Ex applies to ADvalorum, but not Spcl Assessment distr.}
      If (NOT ExemptionCodeRec.AppliesToSpecialAssessmentDistrict)
           then If  (DistrictType = SDAdValorumType)   {'A'}
               then Applies := True  {ex = AD but not spcl ass dist, and SD is advalorum}
               else Applies := False
             {Case 2b: Ex  Ex applies to ADvalorum, AND Spcl Assessment distr.}
           else Applies := True; {EX = Adv and SpclAs so always applies}
      end
        {case 3}
        {EX Does NOT apply to Advalorum districts}
        {but if it DOES apply to spcl ass dist, apply it: Case 3}
      else  If ExemptionCodeRec.AppliesToSpecialAssessmentDistrict
            then
            begin
            IF ((DistrictType = SDSpclAssessmentType)  {'S'}
                                      OR
                  (DistrictType = SDVillageSpclAssessmentType)  {'V'}
                 )

            then Applies := True;   {EX NOT 490 or Adv, but IS spclAss,
                                     and SD is spcl Assessment ,(C3)}
            end
             {Case 4: ex is NOT 490, NOT AD, & NOT Spcl Ass dist}
            else Applies := False;

    {CHG04161998-3: Add FireDistrict and AppliesToSchool flag.}
    {Business incentive exemptions (4761x) never apply to fire districts
     as per RPS memo.}

  If ((Take(4, ExemptionCodeRec.ExemptionCode) = '4761') and
      FireDistrict)
    then Applies := False;

    {CHG10252004-1(2.8.0.15): Allow for application of 4168x to selected SDs.}

  If (ExemptionCodeRec.IsVolunteerFirefighterOrAmbulanceExemption and
      VolunteerFirefighterOrAmbulanceExemptionApplies)
    then Applies := True;

  ExemptionAppliesToSpecialDistrict := Applies;

end;  {ExAppliesToSpecialDistrict}

{===========================================================================}
Function GetExemptionType(ExemptionCode : String) : TExemptionTypes;

begin
  Result := extOther;

  If ExemptionIsSTAR(ExemptionCode)
    then Result := extBasicSTAR;

  If ExemptionIsEnhancedSTAR(ExemptionCode)
    then Result := extEnhancedSTAR;

  If ExemptionIsSenior(ExemptionCode)
    then Result := extSenior;

  If IsBIEExemptionCode(ExemptionCode)
    then Result := extBIE;

  If ExemptionIsVolunteerFirefighter(ExemptionCode)
    then Result := extVolunteerFirefighterOrAmbulance;

end;  {GetExemptionType}

{===========================================================================}
Procedure FillInExemptionCodeRec(    ExemptionCodeTable : TTable;
                                 var ExemptionCodeRec : ExemptionCodeRecord);

begin
  with ExemptionCodeRec, ExemptionCodeTable do
    begin
      ExemptionCode := FieldByName('EXCode').Text;
      ExemptionType := GetExemptionType(ExemptionCode);
      CalculationMethod := FieldByName('CalcMethod').Text;
      ResidentialType := FieldByName('ResidentialType').Text;
      AppliesToSection490 := FieldByName('Section490').AsBoolean;
      AppliesToAdValorumDistrict := FieldByName('AdValorum').AsBoolean;
      AppliesToSpecialAssessmentDistrict := FieldByName('ApplySpclAssessmentD').AsBoolean;
      IsVolunteerFirefighterOrAmbulanceExemption := FieldByName('VolFireAmbExemption').AsBoolean;

    end;  {with ExemptionCodeRec, ExemptionCodeTable do}

end;  {FillInExemptionCodeRec}


{===========================================================================}
Procedure FillInSpecialDistrictCodeRec(    SpecialDistrictCodeTable : TTable;
                                       var SpecialDistrictCodeRec : SpecialDistrictCodeRecord);

var
  I : Integer;
  TempFieldName : String;

begin
  with SpecialDistrictCodeRec, SpecialDistrictCodeTable do
    begin
      SpecialDistrictCode := FieldByName('SDistCode').Text;
      Description := FieldByName('Description').Text;
      HomesteadCode := FieldByName('SDHomestead').Text;
      DistrictType := FieldByName('DistrictType').Text;
      Section490 := FieldByName('Section490').AsBoolean;
      Chapter562 := FieldByName('Chapter562').AsBoolean;
      RollSection9 := FieldByName('SDRS9').AsBoolean;
      FireDistrict := FieldByName('FireDistrict').AsBoolean;
      Prorata_Omitted_District := FieldByName('ProrataOmit').AsBoolean;

      try
        DefaultUnits := FieldByName('DefaultUnits').AsFloat;
      except
        DefaultUnits := 0;
      end;

      try
        DefaultSecondaryUnits := FieldByName('Default2ndUnits').AsFloat;
      except
        DefaultSecondaryUnits := 0;
      end;

      VolunteerFirefighterOrAmbulanceExemptionApplies := FieldByName('VolFireAmbApplies').AsBoolean;
      LateralDistrict := FieldByName('LateralDistrict').AsBoolean;
      OperatingDistrict := FieldByName('OperatingDistrict').AsBoolean;
      TreatmentDistrict := FieldByName('TreatmentDistrict').AsBoolean;

      try
        Step1 := FieldByName('Step1').AsFloat;
      except
        Step1 := 0;
      end;

      try
        Step2 := FieldByName('Step2').AsFloat;
      except
        Step2 := 0;
      end;

      try
        Step3 := FieldByName('Step3').AsFloat;
      except
      end;

      For I := 1 to MaximumSpecialDistrictExtensions do
        begin
          TempFieldName := 'ECd' + IntToStr(I);
          ExtensionCodes[I] := FieldByName(TempFieldName).Text;
          TempFieldName := 'ECFlg' + IntToStr(I);
          CapitalCostOrMaintenanceCodes[I] := FieldByName(TempFieldName).Text;

        end;  {For I := 1 to MaximumSpecialDistrictExtensions do}

    end;  {with SpecialDistrictCodeRec, SpecialDistrictCodeTable do}

end;  {FillInSpecialDistrictCodeRec}

{===========================================================================}
Function ExemptionAppliesToSpecialDistrict(ExemptionCodeRec : ExemptionCodeRecord;
                                           SpecialDistrictCodeRec : SpecialDistrictCodeRecord) : Boolean; overload;

begin
  Result := False;

  If (ExemptionCodeRec.AppliesToSection490 and
      _Compare(SpecialDistrictCodeRec.DistrictType, [SDAdValorumType, SDSpclAssessmentType], coEqual) and
      SpecialDistrictCodeRec.Section490 and
      _Compare(SpecialDistrictCodeRec.CapitalCostOrMaintenanceCodes[1], SDMaintenanceCostType, coEqual))
    then Result := True;

  If (ExemptionCodeRec.AppliesToSection490 and
      _Compare(SpecialDistrictCodeRec.DistrictType, [SDAdValorumType, SDSpclAssessmentType], coEqual) and
      (not SpecialDistrictCodeRec.Section490))
    then Result := True;

  If ((not ExemptionCodeRec.AppliesToSection490) and
      ExemptionCodeRec.AppliesToAdValorumDistrict and
      (not ExemptionCodeRec.AppliesToSpecialAssessmentDistrict) and
      _Compare(SpecialDistrictCodeRec.DistrictType, SDAdValorumType, coEqual))
    then Result := True;

  If ((not ExemptionCodeRec.AppliesToSection490) and
      ExemptionCodeRec.AppliesToAdValorumDistrict and
      ExemptionCodeRec.AppliesToSpecialAssessmentDistrict)
    then Result := True;

  If ((not ExemptionCodeRec.AppliesToSection490) and
      (not ExemptionCodeRec.AppliesToAdValorumDistrict) and
      ExemptionCodeRec.AppliesToSpecialAssessmentDistrict and
      _Compare(SpecialDistrictCodeRec.DistrictType, SDSpclAssessmentType, coEqual))
    then Result := True;

    {Business incentive exemptions (4761x) never apply to fire districts
     as per RPS memo.}

  If (IsBIEExemptionCode(ExemptionCodeRec.ExemptionCode) and
      SpecialDistrictCodeRec.FireDistrict)
    then Result := False;

    {CHG10252004-1(2.8.0.15): Allow for application of 4168x to selected SDs.}

  If (ExemptionCodeRec.IsVolunteerFirefighterOrAmbulanceExemption and
      SpecialDistrictCodeRec.VolunteerFirefighterOrAmbulanceExemptionApplies)
    then Result := True;

end;  {ExemptionAppliesToSpecialDistrict}

{===========================================================================}
Function ExemptionAppliesToSpecialDistrict(SpecialDistrictCodeTable : TTable;
                                           ExemptionCodeTable : TTable;
                                           SpecialDistrictCode : String;
                                           ExemptionCode : String) : Boolean; overload;

var
  ExemptionCodeRec : ExemptionCodeRecord;
  SpecialDistrictCodeRec : SpecialDistrictCodeRecord;

begin
  _Locate(SpecialDistrictCodeTable, [SpecialDistrictCode], '', []);
  _Locate(ExemptionCodeTable, [ExemptionCode], '', []);

  FillInExemptionCodeRec(ExemptionCodeTable, ExemptionCodeRec);
  FillInSpecialDistrictCodeRec(SpecialDistrictCodeTable, SpecialDistrictCodeRec);

  Result := ExemptionAppliesToSpecialDistrict(ExemptionCodeRec, SpecialDistrictCodeRec);

end;  {ExemptionAppliesToSpecialDistrict}

{===========================================================================}
Function RTTotalSDApplicableExemptionsForParcel(ParcelExemptionList,
                                                ExemptionCodeList : TList;
                                                DistrictType : String;
                                                SDAppliesToSection490,
                                                FireDistrict,
                                                VolunteerFirefighterOrAmbulanceExemptionApplies : Boolean;
                                                CMFlag : String;
                                                _HomesteadCode : String;
                                                SplitDistrict,
                                                ParcelIsSplit : Boolean) : ExemptionTotalsArrayType;

{Go through all the exemptions and add the exemption amount. Note that
 we will check each exemption to see which munic. type it applies to
 and also be sure it applies to the sd type passed in}

{CHG02221998-1 : For quicker roll total calcs,
                 only read exemptions 1 time.}

var
  ExemptArray : ExemptionTotalsArrayType;
  I, J : Integer;
  Applies : Boolean;

begin
  For I := 1 to 4 do
    ExemptArray[I] := 0;

   {CHG04161998-3: Add FireDistrict and AppliesToSchool flag.}
   {CHG09122004-1(2.8.0.11): Add homestead split to SD Calcs}

  For J := 0 to (ParcelExemptionList.Count - 1) do
    If ExemptionAppliesToSpecialDistrict(DistrictType,
                                         PExemptionCodeRecord(ExemptionCodeList[J])^,
                                         CMFlag, SDAppliesToSection490,
                                         FireDistrict,
                                         VolunteerFirefighterOrAmbulanceExemptionApplies)
      then
        begin
                 {ExemptAppliesArray index indicates munic type, which then}
                 {governs exemption amount field to be referenced;  }
                 {1 = County, 2 = Town, 3 = Village, 4 = School, see also }
                 {ExemptionAppliesArrayType  in Pastypes}

          For I := 1 to 4 do
            with PParcelExemptionRecord(ParcelExemptionList[J])^ do
              begin
                Applies := True;

                If (SplitDistrict and
                    ParcelIsSplit and
                    (HomesteadCode <> _HomesteadCode))
                  then Applies := False;

                If Applies
                  then
                    case I of
                      RTCounty: ExemptArray[I] := ExemptArray[I] + CountyAmount;
                      RTTown: ExemptArray[I] := ExemptArray[I] + TownAmount;
                      RTSchool: ExemptArray[I] := ExemptArray[I] + SchoolAmount;
                      RTVillage: ExemptArray[I] := ExemptArray[I] + VillageAmount;

                    end;  {case I of}

              end;  {with PParcelExemptionRecord(ParcelExemptionList[J])^ do}

        end;  {If ExAppliesToSpecialDistrict ...}

  Result := ExemptArray;

end;  {RTTotalSDApplicableExemptionsForParcel}

{=========================================================================}
Procedure CalculateSpecialDistrictAmounts(ParcelTable,
                                          AssessmentTable,
                                          ClassTable,
                                          ParcelSDTable,
                                          SDCodeTable : TTable;
                                          ParcelExemptionList,
                                          ExemptionCodeList : TList;
                                          SDExtensionCodes,  {Return lists}
                                          SDCC_OMFlags,
                                          slAssessedValues,
                                          SDValues,
                                          HomesteadCodesList : TStringList);

{Based on the special district code, calculate the "values" of this special district. This can mean
 many different things based on the type of district it is. The values returned will always be in
 correspondence to the type of the district itself. That is, if this is unitary, units will be returned.
 If this is acreage based, acres will be returned, etc.

 Note that since a special district may have many extension codes, what is return is a TStringList where each
 entry is of type extended in string format and corresponds in order to the extension codes. That is, the first
 entry in the TStringList is the value of the first extension code in the SDExtensionCodes list, etc.
 Also, for roll totals purposes, we will return the corresponding CC_OM Flags in the list SDCC_OMFlags.}

var
  SDExtensionType : Char;
  ExtensionIndex : Integer;
  OrigIndex, CC_OMFlag, TempFieldName : String;
  SDExtension : String;
  CalcAmount, Value : Extended;
  ExemptionTotArray : ExemptionTotalsArrayType;
  TempSDCd : String;
  TempPct : Double;
  DistrictType : String;
  SDAppliesToSection490, FireDistrict,
  SplitDistrict, ParcelIsSplit, VolunteerFirefighterOrAmbulanceExemptionApplies : Boolean;
  HomesteadCode : String;
  AssessedValue : Extended;
  HstdLandVal, NonhstdLandVal,
  HstdAssessedVal, NonhstdAssessedVal : Comp;
  BaseValue : Double;

  HstdAcres, NonhstdAcres : Real;
  AssessmentRecordFound, ClassRecordFound, SDFormated : Boolean;

begin
  SDExtensionType := ' ';
  Value := 0;

    {CHG09122004-1(2.8.0.11): Add homestead split to SD Calcs}
    {First look up this special district code in the code table in order to look at its extensions.}
  OrigIndex := SDCodeTable.IndexName;

  If (SDCodeTable.IndexName <> 'BYSDISTCODE')
    then SDCodeTable.IndexName := 'BYSDISTCODE';

  FindKeyOld(SDCodeTable, ['SDistCode'],
             [ParcelSDTable.FieldByName('SDistCode').Text]);

   {Clear the return lists so that there are no previous results left over.}

  SDValues.Clear;
  SDExtensionCodes.Clear;
  SDCC_OMFlags.Clear;
  HomesteadCodesList.Clear;

    {FXX02221998-2: Only get the district type 1 time for this SD code.}

  DistrictType := SDCodeTable.FieldByName('DistrictType').Text;
  SDAppliesToSection490 := SDCodeTable.FieldByName('Section490').AsBoolean;

   {CHG04161998-3: Add FireDistrict and AppliesToSchool flag.}

  FireDistrict := SDCodeTable.FieldByName('FireDistrict').AsBoolean;
  SplitDistrict := SDCodeTable.FieldByName('SDHomestead').AsBoolean;

    {CHG10252004-1(2.8.0.15): Allow for application of 4168x to selected SDs.}

  VolunteerFirefighterOrAmbulanceExemptionApplies := SDCodeTable.FieldByName('VolFireAmbApplies').AsBoolean;

  ParcelIsSplit := False;

  CalculateHstdAndNonhstdAmounts(ParcelTable.FieldByName('TaxRollYr').Text,
                                 ExtractSSKey(ParcelTable),
                                 AssessmentTable,
                                 ClassTable,
                                 ParcelTable,
                                 HstdAssessedVal,
                                 NonhstdAssessedVal,
                                 HstdLandVal, NonhstdLandVal,
                                 HstdAcres, NonhstdAcres,
                                 AssessmentRecordFound,
                                 ClassRecordFound);

  AssessedValue := HstdAssessedVal + NonhstdAssessedVal;

  If SplitDistrict
    then
      begin
        HomesteadCode := ParcelTable.FieldByName('HomesteadCode').Text;

        If (HomesteadCode = SplitParcel)
          then
            begin
              HomesteadCode := 'H';
              AssessedValue := HstdAssessedVal;
              ParcelIsSplit := True;
            end;

      end
    else HomesteadCode := '';

  ExtensionIndex := 1;

  while (ExtensionIndex <= 10) do
    begin
      TempFieldName := 'ECd' + IntToStr(ExtensionIndex);
      SDExtension := Take(2, SDCodeTable.FieldByName(TempFieldName).Text);
      TempFieldName := 'ECFlg' + IntToStr(ExtensionIndex);
      CC_OMFlag := SDCodeTable.FieldByName(TempFieldName).Text;

      If (Deblank(SDExtension) <> '')
        then
          begin
               {determine Sd extension type that will govern processing}
            SDExtensionType := SDExtType(SDExtension);

            case SDExtensionType of
                {AdValorum}
              SDExtCatA :
               begin
                 ExemptionTotArray :=
                   RTTotalSDApplicableExemptionsForParcel(ParcelExemptionList,
                                                          ExemptionCodeList,
                                                          DistrictType,
                                                          SDAppliesToSection490,
                                                          FireDistrict,
                                                          VolunteerFirefighterOrAmbulanceExemptionApplies,
                                                          CC_OMFlag,
                                                          HomesteadCode,
                                                          SplitDistrict,
                                                          ParcelIsSplit);

                   {If the special district record has a value amount, it overrides the
                    assessed value of the parcel.}

                    {FXX07251997-1, if parcel sd calc code = 'E', it overrides}
                    {base valuation of parcel}
                    {S = assessed val override, E = taxable val override}

                 CalcAmount := 0;
                 If ((ParcelSDTable.FieldByName('CalcCode').Text = PrclSDCcE) or {'E'}
                     (ParcelSDTable.FieldByName('CalcCode').Text = PrclSDCcS))  {'S'}
                   then CalcAmount := TCurrencyField(ParcelSDTable.FieldByName('CalcAmount')).Value;

                        {If they specify an overriding ad valorum amount, BUT ONLY IF
                         they put in a calc. code of 'S', then we need to
                         subtract any applicable exemptions from the amount
                         that they have entered. Otherwise, we just take the
                         amount that they have entered.}
                     {process advalorum overried}

                 If (ParcelSDTable.FieldByName('CalcCode').Text = 'S')
                   then
                     begin
                       Value := CalcAmount - ExemptionTotArray[GetMunicipalityType(GlblMunicipalityType)];

                         {FXX07142004-1(2.08): Make sure the value does not go below 0.}

                       If (Value < 0)
                         then Value := 0;

                     end
                   else
                     begin
                          {if no percentage specified for Adval. SD then calc val}
                       If (RoundOff(ParcelSDTable.FieldByName('SDPercentage').AsFloat,2) <= 0)
                         then
                           begin
                                {FXX07251997-1, if parcel sd calc code = 'E', it overrides}
                                {base valuation of parcel. process taxable val override}
                                {FXX01282002-1: Need to add the calculation for a land
                                 based ad valorum.}

                             If (ParcelSDTable.FieldByName('CalcCode').Text = PrclSDCcE)  {'E'}
                               then Value := CalcAmount
                               else
                                 If (SDExtension = SDistEcLD)
                                   then
                                     begin
                                       Value := AssessmentTable.FieldByName('LandAssessedVal').AsFloat -
                                                ExemptionTotArray[GetMunicipalityType(GlblMunicipalityType)];

                                       If (Roundoff(Value, 0) < 0)
                                         then Value := 0;

                                     end
                                   else Value := AssessedValue -
                                                 ExemptionTotArray[GetMunicipalityType(GlblMunicipalityType)];

                           end
                         else
                           begin
                               {percentage  is applied to both Assesed val and exempt amts}
                               {for parcels where percentage is applied RPS pg 3.2A-31}

                             TempPct := (RoundOff(ParcelSDTable.FieldByName('SDPercentage').AsFloat,2)/100);
                                 {round off to 4 places for this percentage}
                             TempPct := RoundOff(TempPct,4);

                                {FXX10112012(MDT): The percentage calculation always used the total AV, even if this was a land AV dist.}

                             If (SDExtension = SDistEcLD)
                             then BaseValue := AssessmentTable.FieldByName('LandAssessedVal').AsFloat
                             else BaseValue := AssessmentTable.FieldByName('TotalAssessedVal').AsFloat;

                             Value := RoundOff((BaseValue*TempPct), 0) -
                                      RoundOff((ExemptionTotArray[GetMunicipalityType(GlblMunicipalityType)]*TempPct), 0);

                           end;  {else of If (RoundOff(ParcelSDTable.FieldByName('SDPercentage').AsFloat,2) <= 0)}

                     end;  {else of If (ParcelSDTable.FieldByName('CalcCode').Text = 'S')}

               end;  {SDExtCatA}

                {Unitary category}
              SDExtCatU : If SDExtension = SDistECUn     {primary units}
                           then Value := TCurrencyField(ParcelSDTable.FieldByName('PrimaryUnits')).Value
                           else If SDExtension = SDistECSU     {secondary units}
                           then
                           begin  {debug}
                           TempSDCd := ParcelSDTable.FieldByName('SDistCode').Text;
                           Value := TCurrencyField(ParcelSDTable.FieldByName('SecondaryUnits')).Value;
                           end;

                {Fixed}
              SDExtCatF : Value := TCurrencyField(ParcelSDTable.FieldByName('CalcAmount')).Value;


                {Dimension}
              SDExtCatD : begin
                            If (SDExtension = SDistECAC)
                              then Value := TFloatField(ParcelTable.FieldByName('Acreage')).Value;

                            If (SDExtension = SDistECFR)
                              then Value := TFloatField(ParcelTable.FieldByName('Frontage')).Value;

                            If (SDExtension = SDistECSQ)
                              then Value := TFloatField(ParcelTable.FieldByName('Frontage')).Value *
                                            TFloatField(ParcelTable.FieldByName('Depth')).Value;

                          end;   {Dimension}

            end;  {case SDExtensionType of}

              {Now add this value to the list.}
              {FXX11172004-1(2.8.0.21): Format the SD value when it is put in the SD list.}
              {FXX12202004-1(2.8.1.5): Make sure that move taxes do not get rounded.}

            SDFormated := False;

            If ((SDExtension = SDistECAC) or
                (SDExtension = SDistECFR) or
                (SDExtension = SDistECSQ) or
                (SDExtension = SDistECUN) or
                (SDExtension = SDistECSU))
              then
                begin
                  SDValues.Add(FormatFloat(_3DecimalEditDisplay, Value));
                  slAssessedValues.Add('0');
                  SDFormated := True;
                end;

            If ((SDExtension = SDistEcIM) or
                (SDExtension = SDistEcLD) or
                (SDExtension = SDistEcTO))
              then
                begin
                  SDValues.Add(FormatFloat(NoDecimalDisplay, Value));

                    {FXX03082010-1(2.22.2.3)[]: The assessed value for a type 'S' override should be the override amount.}

                  If _Compare(ParcelSDTable.FieldByName('CalcCode').AsString, PrclSDCcS, coEqual)
                    then slAssessedValues.Add(FormatFloat(NoDecimalDisplay, ParcelSDTable.FieldByName('CalcAmount').AsInteger))
                    else slAssessedValues.Add(FormatFloat(NoDecimalDisplay, AssessedValue));

                  SDFormated := True;
                end;

            If not SDFormated
              then
                begin
                  SDValues.Add(FormatFloat(DecimalEditDisplay, Value));
                  slAssessedValues.Add(FormatFloat(DecimalEditDisplay, Value));
                end;

            SDExtensionCodes.Add(SDExtension);
            SDCC_OMFlags.Add(CC_OMFlag);
            HomesteadCodesList.Add(HomesteadCode);

          end;  {If (Deblank(SDCodeTable) <> '')}

        {If the parcel is split and this is an AdValorum district,
         go back through this extension and compute the non-homestead value.}

      If ((SDExtensionType = SDExtCatA) and
          ParcelIsSplit and
          (HomesteadCode <> 'N'))
        then
          begin
            HomesteadCode := 'N';
            AssessedValue := NonhstdAssessedVal;
          end
        else ExtensionIndex := ExtensionIndex + 1;

    end;  {while (ExtensionIndex <= 10) do}

  If (OrigIndex <> 'BYSDISTCODE')
    then SDCodeTable.IndexName := OrigIndex;

end;  {CalculateSpecialDistrictAmount}

{================================================================}
Procedure FillInParcelSDValuesRecord(ParcelTable,
                                     AssessmentTable,
                                     ClassTable,
                                     ParcelSDTable,
                                     SDCodeTable : TTable;
                                     ParcelExemptionList,
                                     ExemptionCodeList : TList;
                                     PParcelSDValuesRec : PParcelSDValuesRecord);

{Calculate the SD values for this sd code and fill in a parcel SD values record.}

var
  slAssessedValues, SDValuesList, SDExtensionCodesList,
  SDCC_OMFlagsList, HomesteadCodesList : TStringList;
  I : Integer;

begin
    {CHG09122004-1(2.8.0.11): Add homestead split to SD Calcs}

  SDValuesList := TStringList.Create;
  SDExtensionCodesList := TStringList.Create;
  SDCC_OMFlagsList := TStringList.Create;
  HomesteadCodesList := TStringList.Create;
  slAssessedValues := TStringList.Create;

  CalculateSpecialDistrictAmounts(ParcelTable, AssessmentTable,
                                  ClassTable, ParcelSDTable, SDCodeTable,
                                  ParcelExemptionList, ExemptionCodeList,
                                  SDExtensionCodesList, SDCC_OMFlagsList,
                                  slAssessedValues, SDValuesList, HomesteadCodesList);

  with PParcelSDValuesRec^ do
    begin
       {Initialize the values.}

      For I := 1 to 10 do
        begin
          SDExtensionCodes[I] := Take(2, '');
          SDCC_OMFlags[I] := Take(1, '');
          SDValues[I] := Take(15, '');
          AssessedValues[I] := Take(15, '');
          HomesteadCodes[I] := '';
        end;

      SDCode := ParcelSDTable.FieldByName('SDistCode').Text;

        {Now fill in the lists.}

      For I := 0 to (SDExtensionCodesList.Count - 1) do
       SDExtensionCodes[I + 1] := Take(2, SDExtensionCodesList[I]);

        {FXX12221997-1: We were setting SDCC_OMFlags to itself rather
                        than from the list.}

      For I := 0 to (SDCC_OMFlagsList.Count - 1) do
        SDCC_OMFlags[I + 1] := Take(1, SDCC_OMFlagsList[I]);

      For I := 0 to (SDValuesList.Count - 1) do
        SDValues[I + 1] := SDValuesList[I];

      For I := 0 to (SDValuesList.Count - 1) do
        AssessedValues[I + 1] := slAssessedValues[I];

      For I := 0 to (HomesteadCodesList.Count - 1) do
        HomesteadCodes[I + 1] := HomesteadCodesList[I];

      SplitDistrict := SDCodeTable.FieldByName('SDHomestead').AsBoolean;

    end;  {with PParcelSDValuesRec^ do}

  SDValuesList.Free;
  SDExtensionCodesList.Free;
  SDCC_OMFlagsList.Free;
  HomesteadCodesList.Free;
  slAssessedValues.Free;

end;  {FillInParcelSDValueRecord}

{=======================================================}
Procedure LoadExemptions(TaxRollYear : String;
                         SwisSBLKey : String;
                         ParcelExemptionList,
                         ExemptionCodeList : TList;
                         ParcelExemptionTable,
                         ExemptionCodeTable : TTable);

{CHG02221998-1 : For quicker roll total calcs,
                 only read exemptions 1 time.}

var
  Done, Quit, FirstTimeThrough : Boolean;
  ExemptionCodeRec : PExemptionCodeRecord;
  ParcelExemptionRec : PParcelExemptionRecord;

begin
  If (ExemptionCodeTable.IndexName <> 'BYEXCODE')
    then ExemptionCodeTable.IndexName := 'BYEXCODE';

  ParcelExemptionTable.IndexName := 'BYTAXROLLYR_SWISSBLKEY';
  ParcelExemptionTable.CancelRange;
  SetRangeOld(ParcelExemptionTable,
              ['TaxRollYr', 'SwisSBLKey'],
              [TaxRollYear, SwisSBLKey],
              [TaxRollYear, SwisSBLKey]);

  Done := False;
  Quit := False;
  FirstTimeThrough := True;

  ParcelExemptionTable.First;

  If not (Done or Quit)
    then
      repeat
        If FirstTimeThrough
          then FirstTimeThrough := False
          else ParcelExemptionTable.Next;

        If ParcelExemptionTable.EOF
          then Done := True;

          {We have an exemption record, so put it in the list.}

        If not (Done or Quit)
          then
            begin
              New(ParcelExemptionRec);

                {CHG09122004-1(2.8.0.11): Add homestead split to SD Calcs}

              with ParcelExemptionTable, ParcelExemptionRec^ do
                begin
                  EXCode := FieldByName('ExemptionCode').Text;
                  CountyAmount := FieldByName('CountyAmount').AsFloat;
                  TownAmount := FieldByName('TownAmount').AsFloat;
                  SchoolAmount := FieldByName('SchoolAmount').AsFloat;
                  VillageAmount := FieldByName('VillageAmount').AsFloat;
                  HomesteadCode := FieldByName('HomesteadCode').Text;

                end;  {with ParcelExemptionTable, ParcelExemptionRec^ do}

              ParcelExemptionList.Add(ParcelExemptionRec);

                {Now add the corresponding exemption code record.}

              FindKeyOld(ExemptionCodeTable, ['EXCode'],
                         [ParcelExemptionRec^.EXCode]);

              New(ExemptionCodeRec);

              with ExemptionCodeTable, ExemptionCodeRec^ do
                begin
                  ExemptionCode := ParcelExemptionRec^.EXCode;
                  AppliesToSection490 := FieldByName('Section490').AsBoolean;
                  AppliesToAdValorumDistrict := FieldByName('AdValorum').AsBoolean;
                  AppliesToSpecialAssessmentDistrict := FieldByName('ApplySpclAssessmentD').AsBoolean;

                    {CHG10252004-1(2.8.0.15): Allow for application of 4168x to selected SDs.}

                  IsVolunteerFirefighterOrAmbulanceExemption := ExemptionIsVolunteerFirefighter(ExemptionCode);

                end;  {with ParcelExemptionTable, PExemptionCodeRec^ do}

              ExemptionCodeList.Add(ExemptionCodeRec);

            end;  {If not (Done or Quit)}

      until (Done or Quit);

end;  {LoadExemptions}

{=======================================================}
Procedure TotalSpecialDistrictsForParcel(TaxRollYr : String;
                                         SwisSBLKey : String;
                                         ParcelTable,
                                         AssessmentTable,
                                         ParcelSDTable,
                                         SDCodeTable,
                                         ParcelEXTable,
                                         EXCodeTable : TTable;
                                         SDAmounts : TList);  {This is the return list of type PParcelExemptionRecord.}

{This calculates all values for all special districts on one parcel.
 The information is returned in a TList where each element is of type
 PParcelSDValuesRecord.}

var
  ParcelExemptionList, ExemptionCodeList : TList;
  FirstTimeThrough, Done, Quit,
  ExemptionListsCreated : Boolean;
  PParcelSDValuesRec : PParcelSDValuesRecord;
  ClassTable : TTable;
  I : Integer;

begin
  ParcelExemptionList := nil;
  ExemptionCodeList := nil;
  ClearTList(SDAmounts, SizeOf(PParcelSDValuesRecord));
  ClassTable := TTable.Create(nil);

  with ClassTable do
    begin
      TableType := ttDBase;
      DatabaseName := 'PASSystem';
      IndexName := 'BYTAXROLLYR_SWISSBLKEY';

    end;  {with ClassTable do}

  OpenTableForProcessingType(ClassTable, ClassTableName,
                             GetProcessingTypeForTaxRollYear(TaxRollYr), Quit);

  ParcelSDTable.CancelRange;
  SetRangeOld(ParcelSDTable,
              ['TaxRollYr', 'SwisSBLKey', 'SDistCode'],
              [TaxRollYr, SwisSBLKey, '     '],
              [TaxRollYr, SwisSBLKey, 'ZZZZZ']);

  Done := False;
  Quit := False;
  FirstTimeThrough := True;
  ExemptionListsCreated := False;

  ParcelSDTable.First;

  repeat
    If FirstTimeThrough
      then
        begin
          FirstTimeThrough := False;

            {CHG02221998-1 : For quicker roll total calcs,
                             only read exemptions 1 time.}

          ParcelExemptionList := TList.Create;
          ExemptionCodeList := TList.Create;
          LoadExemptions(TaxRollYr, SwisSBLKey,
                         ParcelExemptionList, ExemptionCodeList,
                         ParcelEXTable, EXCodeTable);
          ExemptionListsCreated := True;
        end
      else ParcelSDTable.Next;

    If ParcelSDTable.EOF
      then Done := True;

      {We have an exemption record, so adjust the exemption roll totals.}

    If not (Done or Quit)
      then
        begin
          New(PParcelSDValuesRec);
          FillInParcelSDValuesRecord(ParcelTable, AssessmentTable,
                                     ClassTable, ParcelSDTable, SDCodeTable,
                                     ParcelExemptionList,
                                     ExemptionCodeList,
                                     PParcelSDValuesRec);

          For I := 1 to 10 do
            If _Compare(PParcelSDValuesRec.SDValues[I], coBlank)
              then PParcelSDValuesRec.SDValues[I] := '0';

          SDAmounts.Add(PParcelSDValuesRec);

        end;  {If not (Done or Quit)}

  until (Done or Quit);

  If ExemptionListsCreated
    then
      begin
        FreeTList(ParcelExemptionList, SizeOf(ParcelExemptionRecord));
        FreeTList(ExemptionCodeList, SizeOf(ExemptionCodeRecord));
      end;

  ClassTable.Close;
  ClassTable.Free;

end;  {TotalSpecialDistrictsForParcel}

{===========================================================================}
Function SpecialDistrictIsMoveTax(SDCodeTable : TTable) : Boolean;

var
  FieldName : String;
  I : Integer;

begin
  Result := False;

  with SDCodeTable do
    For I := 1 to 10 do
      begin
        FieldName := 'Ecd' + IntToStr(I);
        If (FieldByName(FieldName).Text = SdistEcMT)
          then Result := True;

      end;  {For I := 1 to 10 do}

end;  {SpecialDistrictIsMoveTax}

{====================================================================}
Procedure AddOneSpecialDistrict(      SpecialDistrictTable : TTable;
                                const FieldNames : Array of const;
                                const FieldValues : Array of const;
                                      UserName : String);

begin
  _InsertRecord(SpecialDistrictTable, FieldNames, FieldValues, []);

    {Now add the audit information and update the roll totals.}

end;  {AddOneSpecialDistrict}

{================================================================}
Function GetExemptionTypeDescription(ExemptionCode : String) : String;

begin
  Result := '';

  If _Compare(ExemptionCode[5], ['0','1','2','5'], coEqual)
    then Result := 'County';

  If _Compare(ExemptionCode[5], ['0','1','3','6'], coEqual)
    then
      begin
        If _Compare(Result, coNotBlank)
          then Result := Result + ',';

        Result := Result + GetMunicipalityTypeName(GlblMunicipalityType);

      end;  {If _Compare(ExemptionCode[5] ...}

  If _Compare(ExemptionCode[5], ['0','4','5','6'], coEqual)
    then
      begin
        If _Compare(Result, coNotBlank)
          then Result := Result + ',';

        Result := Result + 'School';

      end;  {If _Compare(ExemptionCode[5] ...}

  If _Compare(ExemptionCode[5], '0', coEqual)
    then Result := 'Cty\' +
                   GetMunicipalityTypeName(GlblMunicipalityType) +
                   '\Schl';

  If _Compare(ExemptionCode[5], '7', coEqual)
    then
      begin
        If _Compare(Result, coNotBlank)
          then Result := Result + ',';

        Result := Result + 'Village';

      end;  {If _Compare(ExemptionCode[5] ...}

end;  {GetExemptionTypeDescription}

{===========================================================================}
Procedure DeleteAnExemption(tb_Exemptions : TTable;
                            tb_ExemptionsLookup : TTable;
                            tb_RemovedExemptions : TTable;
                            tb_AuditEXChange : TTable;
                            tb_Audit : TTable;
                            tb_Assessment : TTable;
                            tb_Class : TTable;
                            tb_SwisCode : TTable;
                            tb_Parcel : TTable;
                            tb_ExemptionCode : TTable;
                            AssessmentYear : String;
                            SwisSBLKey : String;
                            ExemptionsNotRecalculatedList : TStringList);

{The steps to delete an exemption are:
  1. Record all the current exemption values in the AuditEXChange table.
  2. Place the exemption in the RemovedExemptions table.
  3. Add deleted exemption records to the Audit table.
  4. Delete the exemption.
  5. Recalculate exemptions for the parcel.
  6. Record the new exemption values in the AuditEXChange table.}

var
  AuditEXChangeList, AuditList : TList;

begin
    {Step 1.}

  AuditEXChangeList := TList.Create;
  GetAuditEXList(SwisSBLKey, AssessmentYear, tb_ExemptionsLookup, AuditEXChangeList);
  InsertAuditEXChanges(SwisSBLKey, AssessmentYear, AuditEXChangeList,
                       tb_AuditEXChange, 'B');

    {Step 2.}

  with tb_RemovedExemptions do
    try
      Insert;
      FieldByName('SwisSBLKey').AsString := SwisSBLKey;
      FieldByName('ActualDateRemoved').AsDateTime := Date;
      FieldByName('RemovedBy').AsString := GlblUserName;
      FieldByName('ExemptionCode').AsString := tb_Exemptions.FieldByName('ExemptionCode').AsString;
      FieldByName('CountyAmount').AsInteger := tb_Exemptions.FieldByName('CountyAmount').AsInteger;
      FieldByName('TownAmount').AsInteger := tb_Exemptions.FieldByName('TownAmount').AsInteger;
      FieldByName('SchoolAmount').AsInteger := tb_Exemptions.FieldByName('SchoolAmount').AsInteger;
      FieldByName('YearRemovedFrom').AsString := AssessmentYear;
      FieldByName('EffectiveDateRemoved').AsDateTime := Date;

      try
        FieldByName('InitialDate').AsDateTime := tb_Exemptions.FieldByName('InitialDate').AsDateTime;
      except
      end;

      try
        FieldByName('Percent').AsFloat := tb_Exemptions.FieldByName('Percent').AsFloat;
      except
      end;

      Post;
    except
      SystemSupport(010, tb_RemovedExemptions,
                    'Error inserting an exemption removal record.',
                    'UTILEXSD', GlblErrorDlgBox);
    end;

    {Step 3.}

(*  AuditList := TList.Create;
  GetAuditInformation(tb_Exemptions, AuditList);
  StoreAuditInformation(AuditList, nil, GlblUserName, emDelete, kfSwisSBLKey);
  FreeTList(AuditList, SizeOf(AuditRecord)); *)

    {Step 4.}

  try
    tb_Exemptions.Delete;
  except
    SystemSupport(010, tb_Exemptions,
                  'Error deleting exemption ' +
                  SwisSBLKey + '\' + tb_Exemptions.FieldByName('ExemptionCode').AsString,
                  'UTILEXSD', GlblErrorDlgBox);
  end;

    {Step 5.}

  RecalculateExemptionsForParcel(tb_ExemptionCode, tb_ExemptionsLookup,
                                 tb_Assessment, tb_Class,
                                 tb_SwisCode, tb_Parcel,
                                 AssessmentYear, SwisSBLKey, nil,
                                 0, 0, False);

    {Step 6.}

  ClearTList(AuditEXChangeList, SizeOf(AuditEXRecord));
  GetAuditEXList(SwisSBLKey, AssessmentYear, tb_ExemptionsLookup, AuditEXChangeList);
  InsertAuditEXChanges(SwisSBLKey, AssessmentYear, AuditEXChangeList,
                       tb_AuditEXChange, 'A');

  FreeTList(AuditEXChangeList, SizeOf(AuditEXRecord));

end;  {DeleteAnExemption}

{==================================================================================}
Function ParcelHasOverrideSpecialDistricts(tbParcelSpecialDistricts : TTable;
                                           sAssessmentYear : String;
                                           sSwisSBLKey : String) : Boolean;

begin
  Result := False;
  _SetRange(tbParcelSpecialDistricts, [sAssessmentYear, sSwisSBLKey], [], '', [loSameEndingRange]);

  with tbParcelSpecialDistricts do
    begin
      First;

      while not EOF do
        begin
          If _Compare(FieldByName('CalcCode').AsString, ['E', 'S'], coEqual)
            then Result := True;

          Next;

        end;  {while not EOF do}

    end;  {with tbParcelSpecialDistricts do}

end;  {ParcelHasOverrideSpecialDistricts}

{INITIALIZATION CODE IS VACUOUS }

BEGIN
END.