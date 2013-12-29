unit Uasmwarn;

{Given a parcel, return a list of warnings for that parcel.}

interface

uses Types, DBCtrls, DBTables, DB, PASUtils, RPBase, Utilitys, RPCanvas,
     SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
     RPDefine, Glblcnst, PASTypes, Forms, GlblVars, UtilEXSD, WinUtils, DataAccessUnit;

  {CHG09021999-1: Add new warnings: 18-21.}


{Warnings:
   1. Inactive parcel
   2. Parcel out of balance
   3. Roll section 8 without exemption
   4. Wholly exempt and roll section does not equal 8.
   5. Zero assessed value.
   6. Frozen assessment.
   7. Property class 731, 732, 733 should have physical +/- if av change
   8. Addition or removal of imp should cause av change.
   9. Parcel with sm# should have change in av
   10. Change in ar fields without change in av
   11. A parcel does not usually have both a physical qty inc and dec
   12. Parcel should not have equal inc and dec
   13. Assessed value should equal land value for vacant land
   14. Assessed value should be greater than land value for non-vacant land.
   15. Duplicate exemptions.
   16. Basic and enhanced on same parcel (not coop or mobile home park).
   17. Senior without enhanced.
   18. Exemption on vacant land.
   19. STAR on non-res.
   20. No termination date for exemption that requires it.
   21. Only county or only town exemption (i.e. veterans).
   22. Clergy exemption warning
   23. Exemption amount greater than assessed value.
   24. Acreage on land records does not match the overall amount.
   25. STAR on NY, not TY
   26. Partial exemption on RS 8
   27. Assessment changed on parcel with 'S' or 'E' override special district code.
   28. Assessment changed on parcel where most recent sale applied to more than 1 parcel.
   29. Cold war vet on parcel with other type of veteran exemption.}

{The actual definition of WarningTypesSet is located in PASTypes to
 avoid circular references.}

Function WarningSelected(WarningOptions : WarningTypesSet;
                         I : Integer) : Boolean;

Function GetParcelWarningMessage(WarningNumber : Integer) : String;
{Given the warning number, return the text message.}

Procedure GetParcelWarnings(AssessmentYear : String;
                            SwisSBLKey : String;
                            WarningCodeList,
                            WarningDescList : TStringList;
                            WarningOptions : WarningTypesSet);

Procedure CloseParcelWarningTables;

var
  WarningEXCodeTable,
  WarningParcelTable,
  WarningCurrentAssessmentTable,
  WarningPriorAssessmentTable,
  WarningClassTable,
  WarningExemptionTable,
  WarningTYExemptionTable,
  WarningNYExemptionTable,
  WarningCurrentResImprovementTable,
  WarningPriorResImprovementTable,
  WarningResidentialLandTable : TTable;

implementation

{===================================================================}
Function GetParcelWarningMessage(WarningNumber : Integer) : String;

{Given the warning number, return the text message.}

begin
  case WarningNumber of
    1 : Result := 'Parcel is inactive.';
    2 : Result := 'Parcel is out of balance.';
    3 : Result := 'Parcel is roll section 8 but has no exemptions.';
    4 : Result := 'Parcel is wholly exempt but not roll section 8.';
    5 : Result := 'Parcel has zero assessed value.';
    6 : Result := 'Parcel has frozen assessed value.';
    7 : Result := 'If parcel val with prop class 731, 732, 733 changes' +
                  ' the phys qty fields should change.';
    8 : Result := 'Adding\removing improvements should cause a change in the physical qty fields.';
    9 : Result := 'A parcel with a split merge number should have a change in assessment.';
    10: Result := 'Parcel has AR fields filled in, but no change in assessed value.';
    11: Result := 'A parcel does not usually have both a physical qty increase and decrease.';
    12: Result := 'A parcel should not have both an equalization qty increase and decrease.';
    13: Result := 'The assessed value should equal the land value for vacant land.';
    14: Result := 'The assessed value should not equal the land value for improved parcels.';

       {CHG05131999-1: Warn if duplicate exemptions on parcel or basic and enhanced.}

    15: Result := 'The parcel has more than one exemption with the same code.';
    16: Result := 'The parcel has both a basic and enhanced STAR exemption.';
    17: Result := 'The parcel has a senior exemption without an enhanced STAR.';

      {CHG09061999-1: Add new exemptions.}

    18: Result := 'The parcel is vacant land and has an exemption.';
    19: Result := 'The parcel has a non-Residential prop class and a STAR exemption.';
    20: Result := 'No termination date for an exemption that requires it.';
    21: Result := 'Only county or town exemption on a parcel.';
    22: Result := 'Clergy exemption of more than $1500.';
    23: Result := 'Total exemption amount greater than assessed value.';
    24: Result := 'Total size in land records <> size of whole parcel.';
    25: Result := 'STAR on Next Year but not This Year.';
    26: Result := 'Partial exemption on roll section 8 parcel.';
    27: Result := 'Override district(s) on parcel with AV change.';
    28: Result := 'AV change on parcel with sale covering multiple parcels.';
    29: Result := 'Cold War veteran on parcel with other vet exemption.';

  end;  {case WarningNumber of}

end;  {GetParcelWarningMessage}

{==================================================================}
Function WarningSelected(WarningOptions : WarningTypesSet;
                         I : Integer) : Boolean;

begin
  Result := False;
  
  case I of
    1 : Result := wtInactiveParcels in WarningOptions;
    2 : Result := wtOutOfBalance in WarningOptions;
    3 : Result := wtRS8NoExemption in WarningOptions;
    4 : Result := wtWhollyExemptNotRS8 in WarningOptions;
    5 : Result := wtZeroAssessments in WarningOptions;
    6 : Result := wtFrozenAssessments in WarningOptions;
    7 : Result := wtGasAndOilWells in WarningOptions;
    8 : Result := wtImprovementChange in WarningOptions;
    9 : Result := wtSplitMerge in WarningOptions;
    10: Result := wtARFilledIn_NoAVChange in WarningOptions;
    11: Result := wtPhysIncAndDec in WarningOptions;
    12: Result := wtEqualIncAndDec in WarningOptions;
    13: Result := wtVacantLand in WarningOptions;
    14: Result := wtNonVacantLand in WarningOptions;
    15: Result := wtDuplicateExemptions in WarningOptions;
    16: Result := wtBasicAndEnhanced in WarningOptions;
    17: Result := wtSeniorWithoutEnhanced in WarningOptions;

      {CHG09061999-1: Add new exemptions.}

    18: Result := wtExemptionOnVacant in WarningOptions;
    19: Result := wtSTARonNonResidential in WarningOptions;
    20: Result := wtNoTerminationDate in WarningOptions;
    21: Result := wtCountyOrTownExemptionOnly in WarningOptions;
    22: Result := wtClergyExemptionTooHigh in WarningOptions;
    23: Result := wtExemptionsGreaterThanAV in WarningOptions;
    24: Result := wtLandRecordSizeNotEqualToOverallSize in WarningOptions;
    25: Result := wtSTARonNYnotTY in WarningOptions;
    26: Result := wtPartialExemptionOnRS8 in WarningOptions;
    27: Result := wtAVChangeWithOverrideSpecialDistricts in WarningOptions;
    28: Result := wtAVChangeWithSaleForMultipleParcels in WarningOptions;
    29: Result := wtColdWarVetAndRegularVetOnParcel in warningOptions;

  end;  {case I of}

end;  {WarningSelected}

{==================================================================}
Function DuplicateExemption(ExemptionCodes : TStringList) : Boolean;

var
  I, J : Integer;

begin
  Result := False;

  For I := 0 to (ExemptionCodes.Count - 1) do
    For J := (I + 1) to (ExemptionCodes.Count - 1) do
      If (ExemptionCodes[I] = ExemptionCodes[J])
        then Result := True;

end;  {DuplicateExemption}

{==================================================================}
Procedure GetParcelWarnings(AssessmentYear : String;
                            SwisSBLKey : String;
                            WarningCodeList,
                            WarningDescList : TStringList;
                            WarningOptions : WarningTypesSet);

var
  SBLRec : SBLRecord;
  FirstTimeThrough, Done, LandRecordFound,
  HasResidentialExemption, STAROnNY, STAROnTY,
  DisplayWarning, CountyOrTownOnly,
  ParcelHasSenior, ParcelIsResidential,
  _ParcelHasSTAR, InactiveParcel, Found,
  Quit, FoundPriorAssessment,
  WarningFound, AddTerminationWarning,
  bColdWarVeteranFound, bBasicOrAlternativeVeteranFound : Boolean;
  ProcessingType, I,
  PriorNumImprovements, CurrentNumImprovements,
  PriorProcessingType, CurrentProcessingType, LastProcessingType : Integer;
  PriorTaxRollYr, CurrentTaxRollYr : String;
  BasicSTARAmount, EnhancedSTARAmount,
  PhysicalQtyIncrease, PhysicalQtyDecrease,
  IncreaseForEqual, DecreaseForEqual,
  CurrentAssessedVal, PriorAssessedVal, CurrentLandVal : Comp;
  ExemptionCodes,
  ExemptionHomesteadCodes,  {What is the homestead code for each exemption?}
  ResidentialTypes,  {What are the residential types for each exemption?}
  CountyExemptionAmounts,
  TownExemptionAmounts,
  SchoolExemptionAmounts,
  VillageExemptionAmounts : TStringList;
  EXTotalsArray : ExemptionTotalsArrayType;
  PropertyClass : String;
  OwnershipCode, RollSection : String;
  EXCode : String;
  TotalParcelAcreage, TotalLandRecordAcreage : Double;
  SpecialDistrictTable, tb_Sales : TTable;

begin
  Quit := False;
  InactiveParcel := False;
  ProcessingType := GetProcessingTypeForTaxRollYear(AssessmentYear);
  LastProcessingType := 5;
  WarningCodeList.Clear;
  WarningDescList.Clear;

  ExemptionCodes := TStringList.Create;
  ExemptionHomesteadCodes := TStringList.Create;
  ResidentialTypes := TStringList.Create;
  CountyExemptionAmounts := TStringList.Create;
  TownExemptionAmounts := TStringList.Create;
  SchoolExemptionAmounts := TStringList.Create;
  VillageExemptionAmounts := TStringList.Create;

    {To determine if a parcel is in balance, we will check from the year
     that they are checking back one year.}

  If (ProcessingType = ThisYear)
    then
      begin
        PriorProcessingType := History;
        CurrentProcessingType := ThisYear;
        PriorTaxRollYr := IntToStr(StrToInt(GlblThisYear) - 1);
        CurrentTaxRollYr := GlblThisYear;
      end
    else
      begin
        PriorProcessingType := ThisYear;
        CurrentProcessingType := NextYear;
        PriorTaxRollYr := GlblThisYear;
        CurrentTaxRollYr := GlblNextYear;

      end;  {else of If (ProcessingType = ThisYear)}

  If (WarningParcelTable = nil)
    then
      begin
        WarningParcelTable := TTable.Create(nil);
        WarningCurrentAssessmentTable := TTable.Create(nil);
        WarningPriorAssessmentTable := TTable.Create(nil);
        WarningClassTable := TTable.Create(nil);
        WarningExemptionTable := TTable.Create(nil);
        WarningTYExemptionTable := TTable.Create(nil);
        WarningNYExemptionTable := TTable.Create(nil);
        WarningCurrentResImprovementTable := TTable.Create(nil);
        WarningPriorResImprovementTable := TTable.Create(nil);
        WarningEXCodeTable := TTable.Create(nil);
        WarningResidentialLandTable := TTable.Create(nil);

      end  {If (WarningParcelTable = nil)}
    else
      case WarningParcelTable.TableName[1] of
        'N' : LastProcessingType := NextYear;
        'T' : LastProcessingType := ThisYear;
        'H' : LastProcessingType := History;
      end;

  If ((WarningParcelTable = nil) or
      (LastProcessingType <> ProcessingType))
    then
      begin
        OpenTableForProcessingType(WarningParcelTable, ParcelTableName,
                                   ProcessingType, Quit);
        OpenTableForProcessingType(WarningCurrentAssessmentTable, AssessmentTableName,
                                   CurrentProcessingType, Quit);
        OpenTableForProcessingType(WarningPriorAssessmentTable, AssessmentTableName,
                                   PriorProcessingType, Quit);
        OpenTableForProcessingType(WarningClassTable, ClassTableName,
                                   ProcessingType, Quit);
        OpenTableForProcessingType(WarningExemptionTable, ExemptionsTableName,
                                   ProcessingType, Quit);
        OpenTableForProcessingType(WarningTYExemptionTable, ExemptionsTableName,
                                   ThisYear, Quit);
        OpenTableForProcessingType(WarningNYExemptionTable, ExemptionsTableName,
                                   NextYear, Quit);
        OpenTableForProcessingType(WarningPriorResImprovementTable, ResidentialImprovementsTableName,
                                   PriorProcessingType, Quit);
        OpenTableForProcessingType(WarningCurrentResImprovementTable, ResidentialImprovementsTableName,
                                   CurrentProcessingType, Quit);
        OpenTableForProcessingType(WarningEXCodeTable, ExemptionCodesTableName,
                                   ProcessingType, Quit);
        OpenTableForProcessingType(WarningResidentialLandTable, ResidentialLandTableName,
                                   ProcessingType, Quit);

        WarningParcelTable.IndexName := ParcelTable_Year_Swis_SBLKey;
        WarningCurrentAssessmentTable.IndexName := OtherTableYear_SwisSBLKey;
        WarningPriorAssessmentTable.IndexName := OtherTableYear_SwisSBLKey;
        WarningClassTable.IndexName := OtherTableYear_SwisSBLKey;
        WarningExemptionTable.IndexName := ExemptionTableYear_SwisSBL_EXKey;
        WarningTYExemptionTable.IndexName := ExemptionTableYear_SwisSBL_EXKey;
        WarningNYExemptionTable.IndexName := ExemptionTableYear_SwisSBL_EXKey;
        WarningCurrentResImprovementTable.IndexName := InventoryYear_SwisSBLKey;
        WarningPriorResImprovementTable.IndexName := InventoryYear_SwisSBLKey;
        WarningResidentialLandTable.IndexName := InventoryYear_SwisSBLKey;
        WarningEXCodeTable.IndexName := 'BYEXCODE';

      end;  {If (WarningParcelTable = nil)}

  SBLRec := ExtractSwisSBLFromSwisSBLKey(SwisSBLKey);

  with SBLRec do
    FindKeyOld(WarningParcelTable,
               ['TaxRollYr', 'SwisCode', 'Section',
                'Subsection', 'Block', 'Lot', 'Sublot', 'Suffix'],
               [AssessmentYear, SwisCode, Section, Subsection,
                Block, Lot, Sublot, Suffix]);

  PropertyClass := WarningParcelTable.FieldByName('PropertyClassCode').Text;
  OwnershipCode := WarningParcelTable.FieldByName('OwnershipCode').Text;

  FindKeyOld(WarningCurrentAssessmentTable, ['TaxRollYr', 'SwisSBLKey'],
             [CurrentTaxRollYr, SwisSBLKey]);

  with WarningCurrentAssessmentTable do
    begin
      PhysicalQtyIncrease := FieldByName('PhysicalQtyIncrease').AsFloat;
      PhysicalQtyDecrease := FieldByName('PhysicalQtyDecrease').AsFloat;
      IncreaseForEqual := FieldByName('IncreaseForEqual').AsFloat;
      DecreaseForEqual := FieldByName('DecreaseForEqual').AsFloat;
      CurrentAssessedVal := FieldByName('TotalAssessedVal').AsFloat;
      CurrentLandVal := FieldByName('LandAssessedVal').AsFloat;

    end;  {with WarningCurrentAssessmentTable do}

  FoundPriorAssessment := FindKeyOld(WarningPriorAssessmentTable,
                                     ['TaxRollYr', 'SwisSBLKey'],
                                     [PriorTaxRollYr, SwisSBLKey]);

    {If there is no history yet, then we will use the prior value field of
     the TY record.}
    {FXX03212000-2: If not found in prior assessment table, but history exists,
                    then must not have existed.}

  PriorAssessedVal := 0;

  If FoundPriorAssessment
    then PriorAssessedVal := WarningPriorAssessmentTable.FieldByName('TotalAssessedVal').AsFloat
    else
      If (GetRecordCount(WarningPriorAssessmentTable) = 0)
        then PriorAssessedVal := WarningCurrentAssessmentTable.FieldByName('PriorTotalValue').AsFloat;

  EXTotalsArray := TotalExemptionsForParcel(AssessmentYear, SwisSBLKey,
                                            WarningExemptionTable, WarningEXCodeTable,
                                            WarningParcelTable.FieldByName('HomesteadCode').Text,
                                            'A',
                                            ExemptionCodes,
                                            ExemptionHomesteadCodes,  {What is the homestead code for each exemption?}
                                            ResidentialTypes,  {What are the residential types for each exemption?}
                                            CountyExemptionAmounts,
                                            TownExemptionAmounts,
                                            SchoolExemptionAmounts,
                                            VillageExemptionAmounts,
                                            BasicSTARAmount,
                                            EnhancedSTARAmount);

  RollSection := WarningParcelTable.FieldByName('RollSection').Text;

     {CHG060101999-2: Allow the user to select exactly which messages to show.}
     {1. Inactive parcel}

  If (RollSection <> '9')
    then
      begin
        If (((wtInactiveParcels in WarningOptions) or
             (wtAll in WarningOptions)) and
            (WarningParcelTable.FieldByName('ActiveFlag').Text = InactiveParcelFlag))
          then
            begin
              WarningCodeList.Add('1');
              WarningDescList.Add(GetParcelWarningMessage(1));
              InactiveParcel := True;
            end;  {If (wtInactiveParcel in WarningOptions) ...}

      end;  {If (RollSection <> '9')}

    {FXX04091999-4: Do not show other warnings if the parcel is inactive.}

  If ((RollSection <> '9') and
      (not InactiveParcel))
    then
      begin
           {2. Parcel out of balance}
           {FXX09111999-1: Only show if parcel is rs 1.}
           {FXX03242001-1: Don't print OOB message on TY if no history exists.}
           {FXX05112001-3: Check for

        If (((wtOutOfBalance in WarningOptions) or
             (wtAll in WarningOptions)) and
            (RollSection = '1') and
            ((PriorAssessedVal +
             (PhysicalQtyIncrease + IncreaseForEqual) -
             (PhysicalQtyDecrease + DecreaseForEqual)) <> CurrentAssessedVal) and
            ((ProcessingType <> ThisYear) or
             (WarningPriorAssessmentTable.RecordCount > 0)))
          then
            begin
              WarningCodeList.Add('2');
              WarningDescList.Add(GetParcelWarningMessage(2));
            end;  {If ((PriorAssessedVal + ...}

           {3. Roll section 8 without exemption}

        If (((wtRS8NoExemption in WarningOptions) or
             (wtAll in WarningOptions)) and
            (WarningParcelTable.FieldByName('RollSection').Text = '8') and
            (ExemptionCodes.Count = 0))
          then
            begin
              WarningCodeList.Add('3');
              WarningDescList.Add(GetParcelWarningMessage(3));
            end;

           {4. Wholly exempt and roll section does not equal 8.}
           {FXX10091998-2: Don't do if AV = 0. This does not mean it is
                           wholly exempt.}
           {FXX03212001-2: If there are any residential exemptions in this list,
                           do not count as wholly exempt.
                           Residential exemptions start with '4'}

        HasResidentialExemption := False;

        For I := 0 to (ExemptionCodes.Count - 1) do
          If (ExemptionCodes[I][1] = '4')
            then HasResidentialExemption := True;

        If (((wtWhollyExemptNotRS8 in WarningOptions) or
             (wtAll in WarningOptions)) and
            (EXTotalsArray[EXTown] = CurrentAssessedVal) and
            (not HasResidentialExemption) and
            (CurrentAssessedVal > 0) and
            (WarningParcelTable.FieldByName('RollSection').Text <> '8'))
          then
            begin
              WarningCodeList.Add('4');
              WarningDescList.Add(GetParcelWarningMessage(4));
            end;

           {5. Zero assessed value.}

        If (((wtZeroAssessments in WarningOptions) or
             (wtAll in WarningOptions)) and
            (Roundoff(CurrentAssessedVal, 0) = 0))
          then
            begin
              WarningCodeList.Add('5');
              WarningDescList.Add(GetParcelWarningMessage(5));
            end;

           {6. Frozen assessment.}

        If (((wtFrozenAssessments in WarningOptions) or
             (wtAll in WarningOptions)) and
            (Deblank(WarningCurrentAssessmentTable.FieldByName('DateFrozen').Text) <> ''))
          then
            begin
              WarningCodeList.Add('6');
              WarningDescList.Add(GetParcelWarningMessage(6));
            end;

           {7. Property class 731, 732, 733 should have physical +/- if av change}

        If (((wtGasAndOilWells in WarningOptions) or
             (wtAll in WarningOptions)) and
            ((PropertyClass = '731') or
             (PropertyClass = '732') or
             (PropertyClass = '733')) and
            (Roundoff(CurrentAssessedVal, 0) <> Roundoff(PriorAssessedVal, 0)) and
            (Roundoff(PhysicalQtyIncrease, 0) = 0) and
            (Roundoff(PhysicalQtyDecrease, 0) = 0))
          then
            begin
              WarningCodeList.Add('7');
              WarningDescList.Add(GetParcelWarningMessage(7));
            end;

           {8. Addition or removal of imp should cause av change.}
           {Only do this one if there is a history year.}

        If (((wtImprovementChange in WarningOptions) or
             (wtAll in WarningOptions)) and
            FoundPriorAssessment)
          then
            begin
              PriorNumImprovements := NumRecordsInRange(WarningPriorResImprovementTable,
                                                        ['TaxRollYr', 'SwisSBLKey'],
                                                        [PriorTaxRollYr, SwisSBLKey],
                                                        [PriorTaxRollYr, SwisSBLKey]);

              CurrentNumImprovements := NumRecordsInRange(WarningCurrentResImprovementTable,
                                                          ['TaxRollYr', 'SwisSBLKey'],
                                                          [CurrentTaxRollYr, SwisSBLKey],
                                                          [CurrentTaxRollYr, SwisSBLKey]);

              If ((PriorNumImprovements <> CurrentNumImprovements) and
                  (Roundoff(PhysicalQtyIncrease, 0) = 0) and
                  (Roundoff(PhysicalQtyDecrease, 0) = 0))
                then
                  begin
                    WarningCodeList.Add('8');
                    WarningDescList.Add(GetParcelWarningMessage(8));
                  end;

            end;  {If FoundPriorAssessment}

           {9. Parcel with sm# should have change in av}

        If (((wtSplitMerge in WarningOptions) or
             (wtAll in WarningOptions)) and
            (Deblank(WarningParcelTable.FieldByName('SplitMergeNo').Text) <> '') and
            (WarningParcelTable.FieldByName('RollSection').Text <> '9') and
            (Roundoff(CurrentAssessedVal, 0) = Roundoff(PriorAssessedVal, 0)))
          then
            begin
              WarningCodeList.Add('9');
              WarningDescList.Add(GetParcelWarningMessage(9));
            end;

           {10. Change in ar fields without change in av}

        If (((wtARFilledIn_NoAVChange in WarningOptions) or
             (wtAll in WarningOptions)) and
            (Roundoff(CurrentAssessedVal, 0) = Roundoff(PriorAssessedVal, 0)) and
            ((Roundoff(PhysicalQtyIncrease, 0) > 0) or
             (Roundoff(PhysicalQtyDecrease, 0) > 0) or
             (Roundoff(IncreaseForEqual, 0) > 0) or
             (Roundoff(DecreaseForEqual, 0) > 0)))
          then
            begin
              WarningCodeList.Add('10');
              WarningDescList.Add(GetParcelWarningMessage(10));
            end;

           {11. A parcel does not usually have both a physical qty inc and dec}

        If (((wtPhysIncAndDec in WarningOptions) or
             (wtAll in WarningOptions)) and
            (Roundoff(PhysicalQtyIncrease, 0) > 0) and
            (Roundoff(PhysicalQtyDecrease, 0) > 0))
          then
            begin
              WarningCodeList.Add('11');
              WarningDescList.Add(GetParcelWarningMessage(11));
            end;

           {12. Parcel should not have equal inc and dec}

        If (((wtEqualIncAndDec in WarningOptions) or
             (wtAll in WarningOptions)) and
            (Roundoff(IncreaseForEqual, 0) > 0) and
            (Roundoff(DecreaseForEqual, 0) > 0))
          then
            begin
              WarningCodeList.Add('12');
              WarningDescList.Add(GetParcelWarningMessage(12));
            end;

           {13. Assessed value should equal land value for vacant land}
           {FXX04091999-5: Property class 312 and 316 are vacant with small improvements.}
           {FXX03212001-1: Property class 331 can have small improvements.}

        If (((wtVacantLand in WarningOptions) or
             (wtAll in WarningOptions)) and
            (PropertyClass[1] = '3') and {Vacant land}
            (PropertyClass <> '312') and
            (PropertyClass <> '316') and
            (PropertyClass <> '331') and
            (CurrentAssessedVal <> CurrentLandVal))
          then
            begin
              WarningCodeList.Add('13');
              WarningDescList.Add(GetParcelWarningMessage(13));
            end;

           {14. Assessed value should be greater than land value for non-vacant land.}
           {FXX10091998-1: Do not test this for rs 3, 6, or 7 since they are state owned
                           and state assessed.}
           {FXX10091998-3: Property class 312 is vacant with small improvements.}
           {FXX05052001-1: There are no improvements on 692 - roadways.}
           {FXX06042001-4: No improvements on 590 - parks.}
           {CHG05072003-1(2.07): No improvements needed on cemetaries.}

        If (((wtNonVacantLand in WarningOptions) or
             (wtAll in WarningOptions)) and
            (PropertyClass[1] <> '3') and {Vacant land}
            (PropertyClass <> '312') and
            (PropertyClass <> '692') and {Roadways}
            (PropertyClass <> '695') and {Cemetaries}
            (PropertyClass <> '590') and {Parks}
            (CurrentAssessedVal = CurrentLandVal) and
            (not (RollSection[1] in ['3', '6'])))
          then
            begin
              WarningCodeList.Add('14');
              WarningDescList.Add(GetParcelWarningMessage(14));
            end;

          {CHG05131999-1: Warn if duplicate exemptions on parcel or basic and enhanced.}
          {15. Duplicate exemptions.}

        If (((wtDuplicateExemptions in WarningOptions) or
             (wtAll in WarningOptions)) and
            DuplicateExemption(ExemptionCodes))
          then
            begin
              WarningCodeList.Add('15');
              WarningDescList.Add(GetParcelWarningMessage(15));
            end;

          {16. Basic and enhanced, but not co-op or mobile home.}

        If (((wtBasicAndEnhanced in WarningOptions) or
             (wtAll in WarningOptions)) and
            (Roundoff(BasicSTARAmount, 0) > 0) and
            (Roundoff(EnhancedSTARAmount, 0) > 0) and
            (not PropertyIsCoopOrMobileHomePark(WarningParcelTable)))
          then
            begin
              WarningCodeList.Add('16');
              WarningDescList.Add(GetParcelWarningMessage(16));
            end;

          {17. Senior, but no enhanced STAR.}

        If ((wtSeniorWithoutEnhanced in WarningOptions) or
             (wtAll in WarningOptions))
          then
            begin
              ParcelHasSenior := False;

                {FXX05171999-1: Need to test the Pos against 0 instead of -1.}

              For I := 0 to (ExemptionCodes.Count - 1) do
                If (Pos('4180', ExemptionCodes[I]) > 0)
                  then ParcelHasSenior := True;

              If (ParcelHasSenior and
                  (Roundoff(EnhancedSTARAmount, 0) = 0))
                then
                  begin
                    WarningCodeList.Add('17');
                    WarningDescList.Add(GetParcelWarningMessage(17));
                  end;

            end;  {If (wtSeniorWithoutEnhanced ...}

          {18. Exemption on vacant land.}
          {FXX09231999-4: Was not actually checking for an exemption.}

        If (((wtExemptionOnVacant in WarningOptions) or
             (wtAll in WarningOptions)) and
            (PropertyClass[1] = '3') and  {Property class}
            (RollSection = '1') and  {Only check taxable land}
            (ExemptionCodes.Count > 0))  {Has an exemption.}
          then
            begin
              WarningCodeList.Add('18');
              WarningDescList.Add(GetParcelWarningMessage(18));
            end;

          {19. STAR on non-residential}

        If ((wtSeniorWithoutEnhanced in WarningOptions) or
             (wtAll in WarningOptions))
          then
            begin
              _ParcelHasSTAR := False;
              ParcelIsResidential := False;

              For I := 0 to (ExemptionCodes.Count - 1) do
                If ((Pos('4183', ExemptionCodes[I]) > 0) or
                    (Pos('4185', ExemptionCodes[I]) > 0))
                  then _ParcelHasSTAR := True;

              If ((PropertyClass = '210') or
                  (PropertyClass = '220') or
                  (PropertyClass = '230') or
                  ((PropertyClass = '411') and
                   (OwnershipCode = 'C')))
                then ParcelIsResidential := True;

              If (_ParcelHasSTAR and
                  (not ParcelIsResidential))
                then
                  begin
                    WarningCodeList.Add('19');
                    WarningDescList.Add(GetParcelWarningMessage(19));
                  end;

            end;  {If ((wtSeniorWithoutEnhanced ...}

          {20. Exemption requires term date}

        If ((wtNoTerminationDate in WarningOptions) or
             (wtAll in WarningOptions))
          then
            begin
              AddTerminationWarning := False;
              WarningEXCodeTable.IndexName := 'BYEXCODE';

              For I := 0 to (ExemptionCodes.Count - 1) do
                begin
                  FindKeyOld(WarningEXCodeTable, ['EXCode'],
                             [ExemptionCodes[I]]);

                  If WarningEXCodeTable.FieldByName('ExpirationDateReqd').AsBoolean
                    then
                      begin
                        Found := FindKeyOld(WarningExemptionTable,
                                            ['TaxRollYr', 'SwisSBLKey', 'ExemptionCode'],
                                            [CurrentTaxRollYr, SwisSBLKey, ExemptionCodes[I]]);

                        If (Found and
                            (Deblank(WarningExemptionTable.FieldByName('TerminationDate').Text) = ''))
                          then AddTerminationWarning := True;

                      end;  {If WarningEXCodeTable.FieldByName('ExpirationDateReqd').AsBoolean}

                end;  {For I := 0 to (ExemptionCodes.Count - 1) do}

              If AddTerminationWarning
                then
                  begin
                    WarningCodeList.Add('20');
                    WarningDescList.Add(GetParcelWarningMessage(20));

                  end;

            end;  {If ((wtSeniorWithoutEnhanced ...}

          {21. County or town only}

        If ((wtCountyOrTownExemptionOnly in WarningOptions) or
             (wtAll in WarningOptions))
          then
            begin
              DisplayWarning := False;

              For I := 0 to (ExemptionCodes.Count - 1) do
                begin
                  EXCode := ExemptionCodes[I];

                    {If the exemption code ends in 2, 3, 5 or 6 need to check for error.}

                  If (EXCode[5] in ['2', '3', '5', '6'])
                    then CountyOrTownOnly := True
                    else CountyOrTownOnly := False;

                    {If town only, search for county only or county\school}

                  If (EXCode[5] = '3')
                    then
                      begin
                        If (ExemptionCodes.IndexOf(Copy(EXCode, 1, 4) + '2') > -1)
                          then CountyOrTownOnly := False;
                        If (ExemptionCodes.IndexOf(Copy(EXCode, 1, 4) + '5') > -1)
                          then CountyOrTownOnly := False;

                      end;  {If (EXCode[5] = '3')}

                    {Town\school, search for county only.}

                  If ((EXCode[5] = '6') and
                      (ExemptionCodes.IndexOf(Copy(EXCode, 1, 4) + '2') > -1))
                    then CountyOrTownOnly := False;

                    {If county only, search for town only or town\school}

                  If (EXCode[5] = '2')
                    then
                      begin
                        If (ExemptionCodes.IndexOf(Copy(EXCode, 1, 4) + '3') > -1)
                          then CountyOrTownOnly := False;
                        If (ExemptionCodes.IndexOf(Copy(EXCode, 1, 4) + '6') > -1)
                          then CountyOrTownOnly := False;

                      end;  {If (EXCode[5] = '3')}

                    {County\school, search for town only.}

                  If ((EXCode[5] = '5') and
                      (ExemptionCodes.IndexOf(Copy(EXCode, 1, 4) + '3') > -1))
                    then CountyOrTownOnly := False;

                  If CountyOrTownOnly
                    then DisplayWarning := True;

                end;  {For I := 0 to (ExemptionCodes.Count - 1) do}

              If DisplayWarning
                then
                  begin
                    WarningCodeList.Add('21');
                    WarningDescList.Add(GetParcelWarningMessage(21));

                  end;

            end;  {If ((wtSeniorWithoutEnhanced ...}

        If ((wtClergyExemptionTooHigh in WarningOptions) or
            (wtAll in WarningOptions))
          then
            begin
              DisplayWarning := False;

              For I := 0 to (ExemptionCodes.Count - 1) do
                If ((ExemptionCodes[I] = '41400') and
                    (Roundoff(StrToFloat(TownExemptionAmounts[I]), 0) > 1500))
                  then DisplayWarning := True;

              If DisplayWarning
                then
                  begin
                    WarningCodeList.Add('22');
                    WarningDescList.Add(GetParcelWarningMessage(22));

                  end;

            end;  {If ((wtClergyExemptionTooHigh in WarningOptions) or ...}

          {CHG12021999-2: Add exemptions greater than AV to warning list.}

        If (((wtExemptionsGreaterThanAV in WarningOptions) or
             (wtAll in WarningOptions)) and
            ((Roundoff(EXTotalsArray[EXCounty], 0) > Roundoff(CurrentAssessedVal, 0)) or
             (Roundoff(EXTotalsArray[EXTown], 0) > Roundoff(CurrentAssessedVal, 0)) or
             (Roundoff((EXTotalsArray[EXSchool] +
                        BasicSTARAmount +
                        EnhancedSTARAmount), 0) > Roundoff(CurrentAssessedVal, 0))))
          then
            begin
              WarningCodeList.Add('23');
              WarningDescList.Add(GetParcelWarningMessage(23));
            end;

          {CHG05112001-2: Check the total of the land records versus the
                          overall acreage.}

        If ((wtLandRecordSizeNotEqualToOverallSize in WarningOptions) or
            (wtAll in WarningOptions))
          then
            begin
              TotalLandRecordAcreage := 0;
              LandRecordFound := False;

              with WarningResidentialLandTable do
                begin
                  CancelRange;
                  SetRangeOld(WarningResidentialLandTable,
                              ['TaxRollYr', 'SwisSBLKey'],
                              [CurrentTaxRollYr, SwisSBLKey],
                              [CurrentTaxRollYr, SwisSBLKey]);

                  FirstTimeThrough := True;
                  Done := False;
                  First;

                  repeat
                    If FirstTimeThrough
                      then FirstTimeThrough := False
                      else Next;

                    If EOF
                      then Done := True;

                    If not Done
                      then
                        begin
                          LandRecordFound := True;
                          TotalLandRecordAcreage := TotalLandRecordAcreage +
                                                    GetAcres(FieldByName('Acreage').AsFloat,
                                                             FieldByName('Frontage').AsFloat,
                                                             FieldByName('Depth').AsFloat);

                        end;  {If not Done}

                  until Done;

                end;  {with WarningResidentialLandTable do}

              with WarningParcelTable do
                TotalParcelAcreage := GetAcres(FieldByName('Acreage').AsFloat,
                                               FieldByName('Frontage').AsFloat,
                                               FieldByName('Depth').AsFloat);

              If (LandRecordFound and
                  (Roundoff(TotalLandRecordAcreage, 2) <>
                   Roundoff(TotalParcelAcreage, 2)))
                then
                  begin
                    WarningCodeList.Add('24');
                    WarningDescList.Add(GetParcelWarningMessage(24));
                  end;

            end;  {If (((wtLandRecordSizeNotEqualToOverallSize in WarningOptions) ...}

          {CHG06072003-2(2.07c)}
          {25. Some local laws require STAR put on NY to go on TY, too.}

        If ((wtSTARonNYnotTY in WarningOptions) or
            (wtAll in WarningOptions))
          then
            begin
              STAROnNY := ParcelHasSTAR(WarningNYExemptionTable,
                                        SwisSBLKey, GlblNextYear);

              STAROnTY := ParcelHasSTAR(WarningTYExemptionTable,
                                        SwisSBLKey, GlblThisYear);

              If (STAROnNY and
                  (not STAROnTY))
                then
                  begin
                    WarningCodeList.Add('25');
                    WarningDescList.Add(GetParcelWarningMessage(25));
                  end;

            end;  {If ((wtSTARonNYnotTY in WarningOptions) or ...}

          {CHG06072003-3(2.07c)}
          {26. Warning that a partial exemption exists on a roll section 8.}

        If ((wtPartialExemptionOnRS8 in WarningOptions) or
            (wtAll in WarningOptions))
          then
            If ((RollSection = '8') and
                ((EXTotalsArray[EXCounty] > 0) or
                 (EXTotalsArray[EXTown] > 0)) and
                ((EXTotalsArray[EXCounty] <> CurrentAssessedVal) or
                 (EXTotalsArray[EXTown] <> CurrentAssessedVal)))
              then
                begin
                  WarningCodeList.Add('26');
                  WarningDescList.Add(GetParcelWarningMessage(26));
                end;  {If ((RollSection = '8') and ...}

          {CHG06302006-2(2.9.7.8): Add warning for an assessment change on a parcel
                                   that has override districts.}

        If (((wtAVChangeWithOverrideSpecialDistricts in WarningOptions) or
             (wtAll in WarningOptions)) and
            _Compare(CurrentAssessedVal, PriorAssessedVal, coNotEqual))
          then
            begin
              WarningFound := False;
              SpecialDistrictTable := TTable.Create(nil);

              _OpenTable(SpecialDistrictTable, SpecialDistrictTableName, '',
                         'BYTAXROLLYR_SWISSBLKEY_SD', ProcessingType, []);

              _SetRange(SpecialDistrictTable, [AssessmentYear, SwisSBLKey, ''], [AssessmentYear, SwisSBLKey, 'zzzzz'], '', []);

              with SpecialDistrictTable do
                while not EOF do
                  begin
                    If _Compare(FieldByName('CalcCode').AsString, [PrclSDCcE, PrclSDCcS], coEqual)
                      then WarningFound := True;

                    Next;

                  end;  {while not EOF do}

              If WarningFound
                then
                  begin
                    WarningCodeList.Add('27');
                    WarningDescList.Add(GetParcelWarningMessage(27));
                  end;

              SpecialDistrictTable.Close;
              SpecialDistrictTable.Free;

            end;  {If ((wtAVChangeWithOverrideSpecialDistricts in WarningOptions) or ...}

          {CHG01112008-2(2.11.7.1): Add warning for an assessment change on a parcel
                                    that has a sale that applies to multiple parcels.}

        If (((wtAVChangeWithSaleForMultipleParcels in WarningOptions) or
             (wtAll in WarningOptions)) and
            _Compare(CurrentAssessedVal, PriorAssessedVal, coNotEqual))
          then
            begin
              WarningFound := False;
              tb_Sales := TTable.Create(nil);

              _OpenTable(tb_Sales, SalesTableName, '',
                         'BYSWISSBLKEY_SALENUMBER', ProcessingType, []);

              _SetRange(tb_Sales, [SwisSBLKey, ''], [SwisSBLKey, '999'], '', []);

              with tb_Sales do
                begin
                  Last;

                  If _Compare(FieldByName('NoParcels').AsInteger, 1, coGreaterThan)
                    then WarningFound := True;

                end;  {with tb_Sales do}

              If WarningFound
                then
                  begin
                    WarningCodeList.Add('28');
                    WarningDescList.Add(GetParcelWarningMessage(28));
                  end;

              tb_Sales.Close;
              tb_Sales.Free;

            end;  {If ((wtAVChangeWithOverrideSpecialDistricts in WarningOptions) or ...}

          {CHG04272008(2.12.1.1): Add Cold War veteran exemption.}

        If ((wtColdWarVetAndRegularVetOnParcel in WarningOptions) or
            (wtAll in WarningOptions))
          then
            begin
              bColdWarVeteranFound := False;
              bBasicOrAlternativeVeteranFound := False;

              For I := 0 to (ExemptionCodes.Count - 1) do
                begin
                  If (ExemptionIsBasicVeteran(ExemptionCodes[I]) or
                      ExemptionIsAlternativeVeteran(ExemptionCodes[I]))
                    then bBasicOrAlternativeVeteranFound := True;

                  If ExemptionIsColdWarVeteran(ExemptionCodes[I])
                    then bColdWarVeteranFound := True;

                end;  {For I := 0 to (ExemptionCodes.Count - 1) do}

              If (bColdWarVeteranFound and
                  bBasicOrAlternativeVeteranFound)
                then
                  begin
                    WarningCodeList.Add('29');
                    WarningDescList.Add(GetParcelWarningMessage(29));
                  end;

            end;  {If ((wtColdWarVetAndRegularVetOnParcel in WarningOptions) or ...}

      end;  {If (WarningParcelTable.FieldByName('RollSection').Text <> '9')}

  ExemptionCodes.Free;
  ExemptionHomesteadCodes.Free;
  ResidentialTypes.Free;
  CountyExemptionAmounts.Free;
  TownExemptionAmounts.Free;
  SchoolExemptionAmounts.Free;
  VillageExemptionAmounts.Free;

end;  {GetParcelWarnings}

{=================================================================}
Procedure CloseParcelWarningTables;

{FXX11301999-2: Allow the parcel warning tables to stay open so
                that warning report does not take so long.}

begin
  WarningEXCodeTable.Close;
  WarningParcelTable.Close;
  WarningCurrentAssessmentTable.Close;
  WarningPriorAssessmentTable.Close;
  WarningClassTable.Close;
  WarningExemptionTable.Close;
  WarningTYExemptionTable.Close;
  WarningNYExemptionTable.Close;
  WarningCurrentResImprovementTable.Close;
  WarningPriorResImprovementTable.Close;
  WarningResidentialLandTable.Close;

  WarningEXCodeTable.Free;
  WarningParcelTable.Free;
  WarningCurrentAssessmentTable.Free;
  WarningPriorAssessmentTable.Free;
  WarningClassTable.Free;
  WarningExemptionTable.Free;
  WarningTYExemptionTable.Free;
  WarningNYExemptionTable.Free;
  WarningCurrentResImprovementTable.Free;
  WarningPriorResImprovementTable.Free;
  WarningResidentialLandTable.Free;

  WarningEXCodeTable := nil;
  WarningParcelTable := nil;
  WarningCurrentAssessmentTable := nil;
  WarningPriorAssessmentTable := nil;
  WarningClassTable := nil;
  WarningExemptionTable := nil;
  WarningTYExemptionTable := nil;
  WarningNYExemptionTable := nil;
  WarningCurrentResImprovementTable := nil;
  WarningPriorResImprovementTable := nil;
  WarningResidentialLandTable := nil;

end;  {CloseParcelWarningTables}


end.