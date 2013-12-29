unit Utilrtot;

{$N+}

{Procedures specific to roll total updating.}

interface
USES Types, Glblvars, SysUtils, WinTypes, WinProcs, BtrvDlg,
     Messages, Dialogs, Forms, wwTable, Classes, DB, DBTables,
     Controls,DBCtrls,StdCtrls, PASTypes, WinUtils, GlblCnst, Utilitys,
     wwDBLook, Graphics, PASUtils, UTILEXSD, DataAccessUnit, DataModule;

Procedure AdjustRollTotalsForParcel_New(    AssessmentYear : String;
                                            ProcessingType : Integer;
                                            SwisSBLKey : String;
                                        var EXAmounts : ExemptionTotalsArrayType;
                                            AdjustmentTypeSet : Charset;  {Adjust (S)wis, s(C)hool, (E)xemption, s(D)}
                                            Mode : Char);  {(D)elete, (A)dd}

Procedure AdjustRollTotalsForParcel(TaxRollYr : String;
                                    SwisCode,
                                    SchoolCode : String;
                                    HomesteadCode,
                                    RollSection : String;
                                    HstdLandVal,
                                    NonhstdLandVal,
                                    HstdAssessedVal,
                                    NonhstdAssessedVal : Comp;
                                    ExemptionCodes,
                                    ExemptionHomesteadCodes,
                                    CountyExemptionAmounts,
                                    TownExemptionAmounts,
                                    SchoolExemptionAmounts,
                                    VillageExemptionAmounts : TStringList;
                                    ParcelTable : TTable;
                                    BasicSTARAmount,
                                    EnhancedSTARAmount : Comp;
                                    SDAmounts : TList;
                                    AdjustmentTypeSet : Charset;  {Adjust (S)wis, s(C)hool, (E)xemption, s(D)}
                                    AdjustmentType : Char);  {(A)dd or (D)elete}
{Either add the roll total amounts or delete the roll total amounts
 depending on what should be adjusted.
 To see what should be adjusted, look at the AdjustmentTypeSet:
 S = swis roll totals, C = school roll totals, E = exemption roll totals,
 D = special district roll totals.
 The exemption codes and the exemption amount lists are string lists
 where for each exemption code in the list, the amount is in the same
 position in each of the amount lists.
 SDAmounts is a TList where each element is of type PParcelSDRecord.

 The amount arrays are filled in by calling TotalExemptionsForParcel
 and TotalSpecialDistrictsForParcel.}

{The following procedures are for displaying and printing roll totals.}

Procedure LoadTotalsBySchoolList(TotalsBySchoolList : TList;
                                 TotalsBySchoolTable : TTable;
                                 SelectedSwisCodes : TStringList;
                                 TotalsOnly,
                                 ShowHomesteadCodes : Boolean;
                                 TaxRollYear : String);
{Return a list with the school totals.}

Procedure LoadTotalsByExemptionList(TotalsByExemptionList : TList;
                                    TotalsByExemptionTable : TTable;
                                    SelectedSwisCodes : TStringList;
                                    TotalsOnly,
                                    ShowHomesteadCodes : Boolean;
                                    TaxRollYear : String);
{Return a list with the Exemption totals.}

Procedure LoadTotalsBySpecialDistrictList(TotalsBySpecialDistrictList : TList;
                                          TotalsBySpecialDistrictTable : TTable;
                                          SelectedSwisCodes : TStringList;
                                          TotalsOnly,
                                          ShowHomesteadCode,
                                          ProratasOnly : Boolean;
                                          AssessmentYear : String);
{Return a list with the Special District totals.}

Procedure LoadTotalsByProrataList(TotalsByRS9List : TList;
                                  TotalsByRS9Table : TTable;
                                  SelectedSwisCodes : TStringList;
                                  TotalsOnly : Boolean;
                                  TaxRollYear : String);
{Return a list with the Special District totals.}

Procedure LoadTotalsByRollSectionList(TotalsByRollSectionList : TList;
                                      TotalsByRollSectionTable : TTable;
                                      SelectedSwisCodes : TStringList;
                                      TotalsOnly,
                                      ShowHomesteadCodes : Boolean;
                                      TaxRollYear : String);
{Return a list with the Roll section totals.}

Procedure LoadTotalsByVillageRelevyList(TotalsByVillageRelevyList : TList;
                                        TotalsByVillageRelevyTable : TTable;
                                        SelectedSwisCodes : TStringList;
                                        TotalsOnly,
                                        ShowHomesteadCodes : Boolean;
                                        TaxRollYear : String);
{Return a list with the VillageRelevy totals.}


implementation
{==========================================================================}
Procedure AdjustExemptionRollTotals(EXTotalTable : TTable;
                                    SwisCode : String;
                                    ExemptionCode : String;
                                    HomesteadCode : String;
                                    CountyExAmount,
                                    TownExAmount,
                                    SchoolExAmount,
                                    VillageExAmount : Comp;
                                    ProcessingType : Integer;  {ThisYear, NextYear}
                                    SplitParcel : Boolean;
                                    AdjustmentType : Char);  {(A)dd or (D)elete}

{See if there were any changes to this exemption. If this is the delete state, we will
 subtract the amount of this exemption from all cases which it applies to (county, town,
 village, school). We will also subtract one from the parcel count. If this is the edit or
 insert state, we will subtract the old amount from whatever amount case it applies to. If
 this is the insert state, we will add one to the parcel count.}

var
  ExRecFound : Boolean;
  AddOrSubtractMultiplier : Integer;

begin
    {If there are any changes or they are deleting this record, then
     we will need to open the corresponding roll total file.}
    {FXX10061999-4: Actually, if we get here, always adjust the exemption roll total,
                    even if the amount is 0 which can happen in an exemption broadcast
                    of a STAR, vet or aged to a coop or mobile home.}

  If (Deblank(ExemptionCode) <> '')
    then
      begin
        ExRecFound := FindKeyOld(ExTotalTable,
                                 ['TaxRollYr', 'SwisCode', 'EXCode', 'HomesteadCode'],
                                 [GetTaxRollYearForProcessingType(ProcessingType),
                                  SwisCode,
                                  ExemptionCode,
                                  Take(1, HomesteadCode)]);

        If ExRecFound
          then
            begin
              ExTotalTable.Edit;

                {If this is the add case, add one to the parcel count.
                 Otherwise (delete case) subtract one from the parcel count.}

                {FXX11071997-4: Store the part amounts for split parcels
                                seperate from the parcel count.}

              with ExTotalTable do
                If (AdjustmentType = 'A')
                  then
                    begin
                      If SplitParcel
                        then FieldByName('PartCount').AsInteger :=
                                FieldByName('PartCount').AsInteger + 1
                        else FieldByName('ParcelCount').AsInteger :=
                                FieldByName('ParcelCount').AsInteger + 1;
                    end
                  else
                    begin
                      If SplitParcel
                        then FieldByName('PartCount').AsInteger :=
                                FieldByName('PartCount').AsInteger - 1
                        else FieldByName('ParcelCount').AsInteger :=
                                FieldByName('ParcelCount').AsInteger - 1;

                    end;  {else of If (AdjustmentType = 'A')}

            end
          else
            begin
               {This is the first exemption roll total of this type, so let's create
                a new record.}

              with ExTotalTable do
                begin
                  Insert;

                  FieldByName('TaxRollYr').Text := GetTaxRollYearForProcessingType(ProcessingType);
                  FieldByName('SwisCode').Text := SwisCode;
                  FieldByName('HomesteadCode').Text := HomesteadCode;
                  FieldByName('ExCode').Text := ExemptionCode;

                  If SplitParcel
                    then FieldByName('PartCount').AsInteger := 1
                    else FieldByName('ParcelCount').AsInteger := 1;

                end;  {with ExTotalTable do}

            end;  {else of If ExRecFound}

        with ExTotalTable do
          begin
              {If this is the add case, we will add the exemption amounts.
               Otherwise, we will subtract the exemption amounts.
               To do this, we will multiplty the exemption amounts by 1
               or -1, respectively.}

            If (AdjustmentType = 'A')
              then AddOrSubtractMultiplier := 1
              else AddOrSubtractMultiplier := -1;

            TCurrencyField(FieldByName('CountyExAmount')).Value :=
                   TCurrencyField(FieldByName('CountyExAmount')).Value +
                   AddOrSubtractMultiplier * CountyExAmount;

            TCurrencyField(FieldByName('TownExAmount')).Value :=
                   TCurrencyField(FieldByName('TownExAmount')).Value +
                   AddOrSubtractMultiplier * TownExAmount;

            TCurrencyField(FieldByName('VillageExAmount')).Value :=
                   TCurrencyField(FieldByName('VillageExAmount')).Value +
                   AddOrSubtractMultiplier * VillageExAmount;

            TCurrencyField(FieldByName('SchoolExAmount')).Value :=
                   TCurrencyField(FieldByName('SchoolExAmount')).Value +
                   AddOrSubtractMultiplier * SchoolExAmount;

            try
              Post;
            except
              SystemSupport(940, ExTotalTable, 'Error posting exemption roll total record.',
                            'PASUTILS.PAS', GlblErrorDlgBox);
            end;

          end;  {with ExTotalTable do}

      end;  {If (Deblank(ExemptionCode) <> '')}

end;  {AdjustExemptionRollTotals}

{==========================================================================}
Procedure AdjustSwisRollTotals(SwisCode : String;
                               HomesteadCode,  {Homestead code of the parcel.}
                               RollSection : String;
                               HstdLandVal,
                               NonhstdLandVal,
                               HstdAssessedVal,
                               NonhstdAssessedVal : Comp;
                               HstdEXAmounts,  {The hstd and nonhstd exemption totals for this parcel.}
                               NonhstdEXAmounts : ExemptionTotalsArrayType;
                               ProcessingType : Integer;  {ThisYear, NextYear}
                               SplitParcel : Boolean;
                               AdjustmentType : Char);  {(A)dd or (D)elete}

{Depending on which assessed value is filled in, we will adjust that
 particular value. That is, if the homestead value is filled in, we
 will adjust the homestead record for this swis code and roll section.
 Similarly if the nonhomestead part is filled in. Note that both
 may be filled in if this is a split parcel.
 The AdjustmentType variable says whether or not we will add or delete
 the information.

 Note that if this is not a classified municipality or the homestead code is
 blank, then the value is stored in the HstdAssessedVal.}

var
  SwisTotalTable : TTable;
  Quit, SwisRecFound, SwisTableOpened : Boolean;
  TempHomesteadCode : String;
  I, AddOrSubtractMultiplier : Integer;

begin
  Quit := False;

  HomesteadCode := Take(1, HomesteadCode);

    {If the homestead or nonhomestead value is greater than 0,
     then create and open the swis code table.}

  SwisTotalTable := TTable.Create(nil);
  SwisTotalTable.IndexName := 'BYYEAR_SWIS_RS_HC';
  OpenTableForProcessingType(SwisTotalTable, RTBySwisCodeTableName,
                             ProcessingType, Quit);
  SwisTableOpened := True;

    {First we will see if the homestead (or no hstd code)
     roll total needs to be adjusted.}
    {FXX06181999-13: Should be including parcels with 0 value in the count.}

  If (HomesteadCode[1] in [' ', 'H', 'S'])
    then
      begin
           {FXX04151998-7: If this is not a split parcel, combine all exemption
                           amounts into the same exemption array since the
                           other piece of the parcel will have zero value.
                           This is in the case where a hstd ex is on a
                           nonhstd parcel and vice-versa.}

        If (HomesteadCode <> 'S')
          then
            For I := 1 to 4 do
              HstdEXAmounts[I] := HstdEXAmounts[I] + NonhstdEXAmounts[I];

        If (HomesteadCode = 'S')
          then TempHomesteadCode := 'H'  {This is the homestead part of the split parcel.}
          else TempHomesteadCode := Take(1, HomesteadCode);

          {Get the homestead swis record for this roll total or blank
           if this municipality is not classified.}

        SwisRecFound := FindKeyOld(SwisTotalTable,
                                   ['TaxRollYr', 'SwisCode', 'RollSection', 'HomesteadCode'],
                                   [GetTaxRollYearForProcessingType(ProcessingType),
                                    SwisCode,
                                    RollSection,
                                    Take(1, TempHomesteadCode)]);

          {If the Swis totals record was found, edit the existing record.
           Otherwise, create a new Swis totals record.}

        If SwisRecFound
          then
            begin
                {The swis total record was found, so just edit the amounts.}

              SwisTotalTable.Edit;

                {If this is the add case, add one to the parcel count.
                 Otherwise (delete case) subtract one from the parcel count.}

                {FXX11071997-4: Store the part amounts for split parcels
                                seperate from the parcel count.}

              with SwisTotalTable do
                If (AdjustmentType = 'A')
                  then
                    begin
                      If SplitParcel
                        then FieldByName('PartCount').AsInteger :=
                                FieldByName('PartCount').AsInteger + 1
                        else FieldByName('ParcelCount').AsInteger :=
                                FieldByName('ParcelCount').AsInteger + 1;
                    end
                  else
                    begin
                      If SplitParcel
                        then FieldByName('PartCount').AsInteger :=
                                FieldByName('PartCount').AsInteger - 1
                        else FieldByName('ParcelCount').AsInteger :=
                                FieldByName('ParcelCount').AsInteger - 1;

                    end;  {else of If (AdjustmentType = 'A')}

            end
          else
            begin
               {This is the first Swis roll total of this type, so let's create
                a new record.}

              with SwisTotalTable do
                begin
                  Insert;

                  FieldByName('TaxRollYr').Text := GetTaxRollYearForProcessingType(ProcessingType);
                  FieldByName('SwisCode').Text := SwisCode;
                  FieldByName('HomesteadCode').Text := Take(1, TempHomesteadCode);
                  FieldByName('RollSection').Text := RollSection;

                  If SplitParcel
                    then FieldByName('PartCount').AsInteger := 1
                    else FieldByName('ParcelCount').AsInteger := 1;

                end;  {with SwisTotalTable do}

            end;  {else of If SwisRecFound}

          {Now adjust the assessment amounts by adding the new assessment
           amount.}

        with SwisTotalTable do
          begin
              {If this is the add case, we will add the exemption amounts.
               Otherwise, we will subtract the exemption amounts.
               To do this, we will multiplty the exemption amounts by 1
               or -1, respectively.}

            If (AdjustmentType = 'A')
              then AddOrSubtractMultiplier := 1
              else AddOrSubtractMultiplier := -1;

              {FXX02101999-4: Add land value to swis and school totals.}

            TCurrencyField(FieldByName('LandValue')).Value :=
                TCurrencyField(FieldByName('LandValue')).Value +
                AddOrSubtractMultiplier * HstdLandVal;

            TCurrencyField(FieldByName('AssessedValue')).Value :=
                TCurrencyField(FieldByName('AssessedValue')).Value +
                AddOrSubtractMultiplier * HstdAssessedVal;

            TCurrencyField(FieldByName('CountyTaxable')).Value :=
                TCurrencyField(FieldByName('CountyTaxable')).Value +
                AddOrSubtractMultiplier * (HstdAssessedVal - HstdExAmounts[ExCounty]);

            TCurrencyField(FieldByName('TownTaxable')).Value :=
                TCurrencyField(FieldByName('TownTaxable')).Value +
                AddOrSubtractMultiplier * (HstdAssessedVal - HstdExAmounts[ExTown]);

            TCurrencyField(FieldByName('VillageTaxable')).Value :=
                TCurrencyField(FieldByName('VillageTaxable')).Value +
                AddOrSubtractMultiplier * (HstdAssessedVal - HstdExAmounts[ExVillage]);

            try
              Post;
            except
              SystemSupport(940, SwisTotalTable, 'Error posting swis roll total record.',
                            'PASUTILS.PAS', GlblErrorDlgBox);
            end;

          end;  {with SwisTotalTable do}

      end;  {If (Roundoff(HstdAssessedVal, 0) > 0)}

    {Now we will see if the nonhomestead roll total needs to be adjusted.}
    {FXX06181999-13: Should be including parcels with 0 value in the count.}

  If (HomesteadCode[1] in ['S', 'N'])
    then
      begin
           {FXX04151998-7: If this is not a split parcel, combine all exemption
                           amounts into the same exemption array since the
                           other piece of the parcel will have zero value.
                           This is in the case where a hstd ex is on a
                           nonhstd parcel and vice-versa.}

        If (HomesteadCode <> 'S')
          then
            For I := 1 to 4 do
              NonhstdEXAmounts[I] := NonhstdEXAmounts[I] + HstdEXAmounts[I];

          {Get the nonhomestead swis record for this roll total.}

        SwisRecFound := FindKeyOld(SwisTotalTable,
                                   ['TaxRollYr', 'SwisCode', 'RollSection', 'HomesteadCode'],
                                   [GetTaxRollYearForProcessingType(ProcessingType),
                                    SwisCode,
                                    RollSection,
                                    'N']);

          {If the Swis totals record was found, edit the existing record.
           Otherwise, create a new Swis totals record.}

        If SwisRecFound
          then
            begin
                {The swis total record was found, so just edit the amounts.}

              SwisTotalTable.Edit;

                {If this is the add case, add one to the parcel count.
                 Otherwise (delete case) subtract one from the parcel count.}

              If (AdjustmentType = 'A')
                then SwisTotalTable.FieldByName('ParcelCount').AsInteger :=
                          SwisTotalTable.FieldByName('ParcelCount').AsInteger + 1
                else SwisTotalTable.FieldByName('ParcelCount').AsInteger :=
                          SwisTotalTable.FieldByName('ParcelCount').AsInteger - 1;

            end
          else
            begin
               {This is the first Swis roll total of this type, so let's create
                a new record.}

              with SwisTotalTable do
                begin
                  Insert;

                  FieldByName('TaxRollYr').Text := GetTaxRollYearForProcessingType(ProcessingType);
                  FieldByName('SwisCode').Text := SwisCode;
                  FieldByName('HomesteadCode').Text := 'N';
                  FieldByName('RollSection').Text := RollSection;
                  TIntegerField(FieldByName('ParcelCount')).AsInteger := 1;

                end;  {with SwisTotalTable do}

            end;  {else of If SwisRecFound}

          {Now adjust the assessment amounts by adding the new assessment
           amount.}

        with SwisTotalTable do
          begin
              {If this is the add case, we will add the exemption amounts.
               Otherwise, we will subtract the exemption amounts.
               To do this, we will multiplty the exemption amounts by 1
               or -1, respectively.}

            If (AdjustmentType = 'A')
              then AddOrSubtractMultiplier := 1
              else AddOrSubtractMultiplier := -1;

              {FXX02101999-4: Add land value to swis and school totals.}

            TCurrencyField(FieldByName('LandValue')).Value :=
                TCurrencyField(FieldByName('LandValue')).Value +
                AddOrSubtractMultiplier * NonhstdLandVal;

            TCurrencyField(FieldByName('AssessedValue')).Value :=
                TCurrencyField(FieldByName('AssessedValue')).Value +
                AddOrSubtractMultiplier * NonhstdAssessedVal;

            TCurrencyField(FieldByName('CountyTaxable')).Value :=
                TCurrencyField(FieldByName('CountyTaxable')).Value +
                AddOrSubtractMultiplier * (NonhstdAssessedVal - NonhstdExAmounts[ExCounty]);

            TCurrencyField(FieldByName('TownTaxable')).Value :=
                TCurrencyField(FieldByName('TownTaxable')).Value +
                AddOrSubtractMultiplier * (NonhstdAssessedVal - NonhstdExAmounts[ExTown]);

            TCurrencyField(FieldByName('VillageTaxable')).Value :=
                TCurrencyField(FieldByName('VillageTaxable')).Value +
                AddOrSubtractMultiplier * (NonhstdAssessedVal - NonhstdExAmounts[ExVillage]);

            try
              Post;
            except
              SystemSupport(940, SwisTotalTable, 'Error posting nonhstd swis roll total record.',
                            'PASUTILS.PAS', GlblErrorDlgBox);
            end;

          end;  {with SwisTotalTable do}

      end;  {If (Roundoff(NonhstdAssessedVal, 0) > 0)}

    {FXX02021998-1: For some reason in parcel add, the swis table,
                    although unused was not nil and we were trying to
                    close it since we were testing on nil.}

  If SwisTableOpened
    then
      begin
        SwisTotalTable.Close;
        SwisTotalTable.Free;
      end;  {If (SwisTotalTable <> nil)}

end;  {AdjustSwisRollTotals}

{==========================================================================}
Procedure AdjustSchoolRollTotals(SwisCode,
                                 SchoolCode : String;
                                 HomesteadCode : String;  {Homestead code of the parcel.}
                                 HstdLandVal,
                                 NonhstdLandVal,
                                 HstdAssessedVal,
                                 NonhstdAssessedVal : Comp;
                                 HstdEXAmounts,  {The hstd and nonhstd exemption totals for this parcel.}
                                 NonhstdEXAmounts : ExemptionTotalsArrayType;
                                 BasicSTARAmount,
                                 EnhancedSTARAmount : Comp;
                                 SchoolRelevyAmount : Extended;
                                 ProcessingType : Integer;  {ThisYear, NextYear}
                                 SplitParcel : Boolean;
                                 AdjustmentType : Char);  {(A)dd or (D)elete}

{Depending on which assessed value is filled in, we will adjust that
 particular value. That is, if the homestead value is filled in, we
 will adjust the homestead record for this school code and roll section.
 Similarly if the nonhomestead part is filled in. Note that both
 may be filled in if this is a split parcel.
 The AdjustmentType variable says whether or not we will add or delete
 the information.

 Note that if this is not a classified municipality or the homestead code is
 blank, then the value is stored in the HstdAssessedVal.}
{CHG07291999-1: Add STAR values and taxable vals to on-line totals.}

var
  SchoolTotalTable : TTable;
  Quit, SchoolRecFound, SchoolTableCreated : Boolean;
  TempHomesteadCode : String;
  I, AddOrSubtractMultiplier : Integer;

begin
  Quit := False;
  HomesteadCode := Take(1, HomesteadCode);

    {If this is the add case, we will add the exemption amounts.
     Otherwise, we will subtract the exemption amounts.
     To do this, we will multiplty the exemption amounts by 1
     or -1, respectively.}

  If (AdjustmentType = 'A')
    then AddOrSubtractMultiplier := 1
    else AddOrSubtractMultiplier := -1;

    {If the homestead or nonhomestead value is greater than 0,
     then create and open the swis code table.}

  SchoolTableCreated := True;
  SchoolTotalTable := TTable.Create(nil);
  SchoolTotalTable.IndexName := 'BYYEAR_SWIS_SCHOOL_HC';
  OpenTableForProcessingType(SchoolTotalTable, RTBySchoolCodeTableName,
                             ProcessingType, Quit);

    {First we will see if the homestead (or no hstd code)
     roll total needs to be adjusted.}
    {FXX06181999-13: Should be including parcels with 0 value in the count.}

  If (HomesteadCode[1] in ['H', 'S', ' '])
    then
      begin
           {FXX04151998-7: If this is not a split parcel, combine all exemption
                           amounts into the same exemption array since the
                           other piece of the parcel will have zero value.
                           This is in the case where a hstd ex is on a
                           nonhstd parcel and vice-versa.}

        If (HomesteadCode <> 'S')
          then
            For I := 1 to 4 do
              HstdEXAmounts[I] := HstdEXAmounts[I] + NonhstdEXAmounts[I];

        If (HomesteadCode = 'S')
          then TempHomesteadCode := 'H'  {This is the homestead part of the split parcel.}
          else TempHomesteadCode := Take(1, HomesteadCode);

          {Get the homestead swis record for this roll total or blank
           if this municipality is not classified.}

        SchoolRecFound := FindKeyOld(SchoolTotalTable,
                                     ['TaxRollYr', 'SwisCode', 'SchoolCode', 'HomesteadCode'],
                                     [GetTaxRollYearForProcessingType(ProcessingType),
                                      SwisCode,
                                      SchoolCode,
                                      Take(1, TempHomesteadCode)]);

          {If the Swis totals record was found, edit the existing record.
           Otherwise, create a new Swis totals record.}

        If SchoolRecFound
          then
            begin
                {The swis total record was found, so just edit the amounts.}

              SchoolTotalTable.Edit;

                {If this is the add case, add one to the parcel count.
                 Otherwise (delete case) subtract one from the parcel count.}

                {FXX11071997-4: Store the part amounts for split parcels
                                seperate from the parcel count.}
                {CHG12091998-1:  Village relevy totals.}

              with SchoolTotalTable do
                begin
                  If SplitParcel
                    then FieldByName('PartCount').AsInteger :=
                            FieldByName('PartCount').AsInteger + 1 * AddOrSubtractMultiplier
                    else FieldByName('ParcelCount').AsInteger :=
                            FieldByName('ParcelCount').AsInteger + 1 * AddOrSubtractMultiplier;

                  If (Roundoff(SchoolRelevyAmount, 2) > 0)
                    then FieldByName('RelevyCount').AsInteger :=
                                      FieldByName('RelevyCount').AsInteger + 1 * AddOrSubtractMultiplier;

                  If (Roundoff(BasicSTARAmount, 2) > 0)
                    then FieldByName('BasicSTARCount').AsInteger :=
                                      FieldByName('BasicSTARCount').AsInteger + 1 * AddOrSubtractMultiplier;

                  If (Roundoff(EnhancedSTARAmount, 2) > 0)
                    then FieldByName('EnhancedSTARCount').AsInteger :=
                                      FieldByName('EnhancedSTARCount').AsInteger + 1 * AddOrSubtractMultiplier;

                end;  {with SchoolTotalTable do}

            end
          else
            begin
               {This is the first Swis roll total of this type, so let's create
                a new record.}

              with SchoolTotalTable do
                begin
                  Insert;

                  FieldByName('TaxRollYr').Text := GetTaxRollYearForProcessingType(ProcessingType);
                  FieldByName('SwisCode').Text := SwisCode;
                  FieldByName('SchoolCode').Text := SchoolCode;
                  FieldByName('HomesteadCode').Text := Take(1, TempHomesteadCode);

                  If (Roundoff(SchoolRelevyAmount, 2) > 0)
                    then
                      begin
                        FieldByName('RelevyCount').AsInteger := 1;
                        FieldByName('SchoolRelevyAmt').AsFloat := SchoolRelevyAmount;
                      end;

                  If (Roundoff(BasicSTARAmount, 0) > 0)
                    then
                      begin
                        FieldByName('BasicSTARCount').AsInteger := 1;
                        FieldByName('BasicSTARAmount').AsFloat := BasicSTARAmount;
                      end;

                  If (Roundoff(EnhancedSTARAmount, 0) > 0)
                    then
                      begin
                        FieldByName('EnhancedSTARCount').AsInteger := 1;
                        FieldByName('EnhancedSTARAmount').AsFloat := EnhancedSTARAmount;
                      end;

                  If SplitParcel
                    then FieldByName('PartCount').AsInteger := 1
                    else FieldByName('ParcelCount').AsInteger := 1;

                end;  {with SchoolTotalTable do}

            end;  {else of If SchoolRecFound}

          {Now adjust the assessment amounts by adding the new assessment
           amount.}

        with SchoolTotalTable do
          begin
              {FXX11031997-6: The amount needs to be multiplied
                              by the AddOrSubtractMultiplier.}
              {FXX02101999-4: Add land value to swis and school totals.}

            TCurrencyField(FieldByName('LandValue')).Value :=
              TCurrencyField(FieldByName('LandValue')).Value +
              HstdLandVal * AddOrSubtractMultiplier;

            TCurrencyField(FieldByName('AssessedValue')).Value :=
              TCurrencyField(FieldByName('AssessedValue')).Value +
              HstdAssessedVal * AddOrSubtractMultiplier;

            TCurrencyField(FieldByName('BasicSTARAmount')).Value :=
              TCurrencyField(FieldByName('BasicSTARAmount')).Value +
              BasicSTARAmount * AddOrSubtractMultiplier;

            TCurrencyField(FieldByName('EnhancedSTARAmount')).Value :=
              TCurrencyField(FieldByName('EnhancedSTARAmount')).Value +
              EnhancedSTARAmount * AddOrSubtractMultiplier;

              {FXX02131998-4: We were not subtracting the exemption amounts
                              from the assessed value to get the taxable
                              value.}

            TCurrencyField(FieldByName('SchoolTaxable')).Value :=
              TCurrencyField(FieldByName('SchoolTaxable')).Value +
              (HstdAssessedVal - HstdEXAmounts[EXSchool]) * AddOrSubtractMultiplier;

            If (Roundoff(SchoolRelevyAmount, 2) > 0)
              then FieldByName('SchoolRelevyAmt').AsFloat :=
                         FieldByName('SchoolRelevyAmt').AsFloat +
                         SchoolRelevyAmount * AddOrSubtractMultiplier;

            try
              Post;
            except
              SystemSupport(940, SchoolTotalTable, 'Error posting swis roll total record.',
                            'PASUTILS.PAS', GlblErrorDlgBox);
            end;

          end;  {with SchoolTotalTable do}

      end;  {If (Roundoff(HstdAssessedVal, 0) > 0)}

    {Now we will see if the nonhomestead roll total needs to be adjusted.}

    {FXX06181999-13: Should be including parcels with 0 value in the count.}
    {Note that there are no STAR values for nonhstd portions.}

  If (HomesteadCode[1] in ['N', 'S'])
    then
      begin
           {FXX04151998-7: If this is not a split parcel, combine all exemption
                           amounts into the same exemption array since the
                           other piece of the parcel will have zero value.
                           This is in the case where a hstd ex is on a
                           nonhstd parcel and vice-versa.}

        If (HomesteadCode <> 'S')
          then
            For I := 1 to 4 do
              NonhstdEXAmounts[I] := NonhstdEXAmounts[I] + HstdEXAmounts[I];

          {Get the nonhomestead swis record for this roll total.}

        SchoolRecFound := FindKeyOld(SchoolTotalTable,
                                     ['TaxRollYr', 'SwisCode', 'SchoolCode', 'HomesteadCode'],
                                     [GetTaxRollYearForProcessingType(ProcessingType),
                                      SwisCode,
                                      SchoolCode,
                                      'N']);

          {If this is the add case, add one to the parcel count.
           Otherwise (delete case) subtract one from the parcel count.}
          {FXX08181999-9: Some Nonhstd residences get STAR (i.e. 411),
                          but don't double count for splits.}

        If SplitParcel
          then
            begin
              EnhancedSTARAmount := 0;
              BasicSTARAmount := 0;
            end;

        If (AdjustmentType = 'A')
          then AddOrSubtractMultiplier := 1
          else AddOrSubtractMultiplier := -1;

          {If the Swis totals record was found, edit the existing record.
           Otherwise, create a new Swis totals record.}

        If SchoolRecFound
          then
            begin
                {The swis total record was found, so just edit the amounts.}

              SchoolTotalTable.Edit;

              SchoolTotalTable.FieldByName('ParcelCount').AsInteger :=
                        SchoolTotalTable.FieldByName('ParcelCount').AsInteger + 1 * AddOrSubtractMultiplier;

              with SchoolTotalTable do
                begin
                  If (Roundoff(SchoolRelevyAmount, 2) > 0)
                    then FieldByName('RelevyCount').AsInteger :=
                                   FieldByName('RelevyCount').AsInteger + 1 * AddOrSubtractMultiplier;

                  If (Roundoff(BasicSTARAmount, 2) > 0)
                    then FieldByName('BasicSTARCount').AsInteger :=
                                      FieldByName('BasicSTARCount').AsInteger + 1 * AddOrSubtractMultiplier;

                  If (Roundoff(EnhancedSTARAmount, 2) > 0)
                    then FieldByName('EnhancedSTARCount').AsInteger :=
                                      FieldByName('EnhancedSTARCount').AsInteger + 1 * AddOrSubtractMultiplier;

                end;  {with SchoolTotalTable do}

            end
          else
            begin
               {This is the first Swis roll total of this type, so let's create
                a new record.}

              with SchoolTotalTable do
                begin
                  Insert;

                  FieldByName('TaxRollYr').Text := GetTaxRollYearForProcessingType(ProcessingType);
                  FieldByName('SwisCode').Text := SwisCode;
                  FieldByName('SchoolCode').Text := SchoolCode;
                  FieldByName('HomesteadCode').Text := 'N';
                  TIntegerField(FieldByName('ParcelCount')).AsInteger := 1;

                  If (Roundoff(SchoolRelevyAmount, 2) > 0)
                    then
                      begin
                        FieldByName('RelevyCount').AsInteger := 1;
                        FieldByName('SchoolRelevyAmt').AsFloat := SchoolRelevyAmount;
                      end;

                  If (Roundoff(BasicSTARAmount, 0) > 0)
                    then
                      begin
                        FieldByName('BasicSTARCount').AsInteger := 1;
                        FieldByName('BasicSTARAmount').AsFloat := BasicSTARAmount;
                      end;

                  If (Roundoff(EnhancedSTARAmount, 0) > 0)
                    then
                      begin
                        FieldByName('EnhancedSTARCount').AsInteger := 1;
                        FieldByName('EnhancedSTARAmount').AsFloat := EnhancedSTARAmount;
                      end;

                end;  {with SchoolTotalTable do}

            end;  {else of If SchoolRecFound}

          {Now adjust the assessment amounts by adding the new assessment
           amount.}

        with SchoolTotalTable do
          begin
              {If this is the add case, we will add the exemption amounts.
               Otherwise, we will subtract the exemption amounts.
               To do this, we will multiplty the exemption amounts by 1
               or -1, respectively.}

            If (AdjustmentType = 'A')
              then AddOrSubtractMultiplier := 1
              else AddOrSubtractMultiplier := -1;

              {FXX11031997-6: The amount needs to be multiplied
                              by the AddOrSubtractMultiplier.}
              {FXX02101999-4: Add land value to swis and school totals.}

            TCurrencyField(FieldByName('LandValue')).Value :=
              TCurrencyField(FieldByName('LandValue')).Value +
              NonhstdLandVal * AddOrSubtractMultiplier;

            TCurrencyField(FieldByName('AssessedValue')).Value :=
              TCurrencyField(FieldByName('AssessedValue')).Value +
              NonhstdAssessedVal * AddOrSubtractMultiplier;

            TCurrencyField(FieldByName('SchoolTaxable')).Value :=
              TCurrencyField(FieldByName('SchoolTaxable')).Value +
              (NonhstdAssessedVal - NonhstdEXAmounts[EXSchool]) * AddOrSubtractMultiplier;

            If (Roundoff(SchoolRelevyAmount, 2) > 0)
              then FieldByName('SchoolRelevyAmt').AsFloat :=
                         FieldByName('SchoolRelevyAmt').AsFloat +
                         SchoolRelevyAmount * AddOrSubtractMultiplier;

            TCurrencyField(FieldByName('BasicSTARAmount')).Value :=
              TCurrencyField(FieldByName('BasicSTARAmount')).Value +
              BasicSTARAmount * AddOrSubtractMultiplier;

            TCurrencyField(FieldByName('EnhancedSTARAmount')).Value :=
              TCurrencyField(FieldByName('EnhancedSTARAmount')).Value +
              EnhancedSTARAmount * AddOrSubtractMultiplier;

            try
              Post;
            except
              SystemSupport(940, SchoolTotalTable, 'Error posting nonhstd swis roll total record.',
                            'PASUTILS.PAS', GlblErrorDlgBox);
            end;

          end;  {with SchoolTotalTable do}

      end;  {If (Roundoff(NonhstdAssessedVal, 0) > 0)}

    {FXX03021998-5: Sometimes even if the school total table was not created,
                    it was not nil, so must use boolean.}

  If SchoolTableCreated
    then
      begin
        SchoolTotalTable.Close;
        SchoolTotalTable.Free;
      end;  {If (SchoolTotalTable <> nil)}

end;  {AdjustSchoolRollTotals}

{==========================================================================}
Procedure AdjustSDRollTotals(SDTotalTable,
                             RS9TotalTable : TTable;
                             RollSection : String;
                             Amount : Double;  {FXX11031997-1: Amount should be dbl not comp to avoid rounding prob.}
                             SwisCode : String;
                             SDCode : String;
                             ExtensionCode : String;
                             CCOMFlag : String;
                             HomesteadCode : String;
                             SplitDistrict : Boolean;
                             ProcessingType : Integer;  {ThisYear or NextYear}
                             AdjustmentType : Char);  {(A)dd or (D)elete}

{See if there were any changes to this SD. If this is the delete state, we will
 subtract the amount of this taxable value from the TaxableValue for this roll
 total. We will also subtract one from the parcel count. If
 this is the add state, we will add one to the parcel count. Note that the
 TaxableValue is not just the taxable value. This is an amount depending
 on what type of special district this is. It could be a taxable value,
 a units amount, a dimension, or a flat value.}

var
  SDRecFound, RS9RecFound : Boolean;
  AddOrSubtractMultiplier : Integer;
  TaxRollYr : String;

begin
  TaxRollYr := GetTaxRollYearForProcessingType(ProcessingType);

    {FXX11021997-1: Adjust the SD totals even if the amount is zero since
                    an SD may have several parts, i.e. ad valorum, units and
                    secondary units but have secondary units of zero. However,
                    this is still counted in the parcel count.}

    {FXX11041997-1: SD Totals should not have a homestead code.}

  If _Compare(ExtensionCode, coNotBlank)
    then
      begin
        _Locate(SDTotalTable,
                [TaxRollYr, SwisCode, SDCode, ExtensionCode, CCOMFlag], '', [loPartialKey]);

        with SDTotalTable do
          begin
            If (_Compare(SwisCode, FieldByName('SwisCode').AsString, coEqual) and
                _Compare(SDCode, FieldByName('SDCode').AsString, coEqual) and
                _Compare(ExtensionCode, FieldByName('ExtensionCode').AsString, coEqual) and
                _Compare(CCOMFlag, FieldByName('CCOMFlg').AsString, coEqual))
              then SDRecFound := True
              else SDRecFound := False;

              {If the SD totals record was found, edit the existing record.
               Otherwise, create a new SD totals record.}

            If SDRecFound
              then
                begin
                    {The exemption roll total record was found, so just edit the amounts.}

                  Edit;

                    {If this is the add case, add one to the parcel count.
                     Otherwise (delete case) subtract one from the parcel count.}

                  If (AdjustmentType = 'A')
                    then FieldByName('ParcelCount').AsInteger :=
                              FieldByName('ParcelCount').AsInteger + 1
                    else FieldByName('ParcelCount').AsInteger :=
                              FieldByName('ParcelCount').AsInteger - 1;

                end
              else
                begin
                  Insert;

                  FieldByName('TaxRollYr').Text := TaxRollYr;
                  FieldByName('SDCode').Text := SDCode;
                  FieldByName('SwisCode').Text := SwisCode;
                  FieldByName('ExtensionCode').Text := Take(2, ExtensionCode);
                  FieldByName('CCOMflg').Text := Take(1, CCOMFlag);
                  TIntegerField(FieldByName('ParcelCount')).AsInteger := 1;

                    {CHG09302004-1(2.8.0.13): Continued work on hstd\non-hstd SD totals.}

                  try
                    FieldByName('HomesteadCode').Text := HomesteadCode;
                    FieldByName('SplitDistrict').AsBoolean := SplitDistrict;
                  except
                  end;

                end;  {else of If SDRecFound}

              {Now adjust the assessment amounts by adding the new assessment
               amount if this is the add case or subtract the amount if this
               is the delete case.}

              {If this is the add case, we will add the exemption amounts.
               Otherwise, we will subtract the exemption amounts.
               To do this, we will multiplty the exemption amounts by 1
               or -1, respectively.}

            If (AdjustmentType = 'A')
              then AddOrSubtractMultiplier := 1
              else AddOrSubtractMultiplier := -1;

            FieldByName('TaxableValue').AsFloat :=
                 FieldByName('TaxableValue').AsFloat +
                 AddOrSubtractMultiplier * Amount;

            try
              Post;
            except
              Cancel;
              SystemSupport(940, SDTotalTable, 'Error posting SD roll total record.',
                            'PASUTILS.PAS', GlblErrorDlgBox);
            end;

          end;  {with SDTotalTable do}

      end;  {If _Compare(ExtensionCode, coNotBlank)}

    {CHG08021999-2: Add roll section 9 totals.}

  If _Compare(RollSection, '9', coEqual)
    then
      begin
        RS9RecFound := FindKeyOld(RS9TotalTable,
                                  ['TaxRollYr', 'SwisCode', 'SDCode'],
                                  [TaxRollYr, SwisCode, SDCode]);

        If RS9RecFound
          then
            begin
                {The RS9 roll total record was found, so just edit the amounts.}

              RS9TotalTable.Edit;

                {If this is the add case, add one to the parcel count.
                 Otherwise (delete case) subtract one from the parcel count.}

              If (AdjustmentType = 'A')
                then RS9TotalTable.FieldByName('ParcelCount').AsInteger :=
                          RS9TotalTable.FieldByName('ParcelCount').AsInteger + 1
                else RS9TotalTable.FieldByName('ParcelCount').AsInteger :=
                          RS9TotalTable.FieldByName('ParcelCount').AsInteger - 1;

            end
          else
            begin
               {This is the first RS9 roll total of this type, so let's create
                a new record.}

              with RS9TotalTable do
                begin
                  Insert;

                  FieldByName('TaxRollYr').Text := TaxRollYr;
                  FieldByName('SDCode').Text := SDCode;
                  FieldByName('SwisCode').Text := SwisCode;
                  TIntegerField(FieldByName('ParcelCount')).AsInteger := 1;

                end;  {with RS9TotalTable do}

            end;  {else of If RS9RecFound}

          {Now adjust the assessment amounts by adding the new assessment
           amount if this is the add case or subtract the amount if this
           is the delete case.}

        with RS9TotalTable do
          begin
              {If this is the add case, we will add the exemption amounts.
               Otherwise, we will subtract the exemption amounts.
               To do this, we will multiplty the exemption amounts by 1
               or -1, respectively.}

            If (AdjustmentType = 'A')
              then AddOrSubtractMultiplier := 1
              else AddOrSubtractMultiplier := -1;

            TCurrencyField(FieldByName('Amount')).Value :=
                 TCurrencyField(FieldByName('Amount')).Value +
                 AddOrSubtractMultiplier * Amount;

            try
              Post;
            except
              SystemSupport(940, RS9TotalTable, 'Error posting RS9 roll total record.',
                            'PASUTILS.PAS', GlblErrorDlgBox);
            end;

          end;  {with RS9TotalTable do}

      end;

end;  {AdjustSDRollTotals}

{============================================================================}
Procedure AdjustAllExRollTotals(TaxRollYr : String;
                                SwisCode : String;
                                ExemptionCodes,
                                ExemptionHomesteadCodes,
                                CountyExemptionAmounts,
                                TownExemptionAmounts,
                                SchoolExemptionAmounts,
                                VillageExemptionAmounts : TStringList;
                                AssessedValue,
                                BasicSTARAmount,
                                EnhancedSTARAmount : Comp;
                                ParcelTable : TTable;
                                ProcessingType : Integer;  {ThisYear or NextYear}
                                SplitParcel : Boolean;
                                AdjustmentType : Char);  {(A)dd or (D)elete}

{Either add or delete the amounts for each exemption depending on the
 AdjustmentType.}

var
  I : Integer;
  ExTotalTable : TTable;
  Quit : Boolean;

begin
  Quit := False;

    {We will open the exemption roll total table here and pass it into
     AdjustExemptionRollTotals so that we don't have to open it for each
     exemption roll total calculation.}

  ExTotalTable := TTable.Create(nil);

  EXTotalTable.IndexName := 'BYTAXROLLYR_SWISCODE_EX_HC';
  OpenTableForProcessingType(ExTotalTable, RTByExCodeTableName,
                             ProcessingType, Quit);

  For I := 0 to (ExemptionCodes.Count - 1) do
    AdjustExemptionRollTotals(ExTotalTable, SwisCode,
                              ExemptionCodes[I],
                              ExemptionHomesteadCodes[I],
                              StrToFloat(CountyExemptionAmounts[I]),
                              StrToFloat(TownExemptionAmounts[I]),
                              StrToFloat(SchoolExemptionAmounts[I]),
                              StrToFloat(VillageExemptionAmounts[I]),
                              ProcessingType, SplitParcel,
                              AdjustmentType);

    {CHG12011997-2: STAR support. Adjust STAR exemptions as separate since
                    they are not stored in the SchoolExemptionAmounts.}

    {FXX12041997-4: Record full, unadjusted STAR amount.}
    {FXX05281998-2: Actually record the adjustemd amount.}

  If (Roundoff(BasicSTARAmount, 0) > 0)
    then
      begin
        (*
        SwisCodeTable := TTable.Create(nil);

        OpenTableForProcessingType(SwisCodeTable, SwisCodeTableName,
                                   ProcessingType, Quit);

          {Get the full basic STAR amount. If this is greater than the
           amount of the basic STAR, then use it.}

        CalculateSTARAmount(TaxRollYr, '41854', SwisCode,
                            SwisCodeTable, ParcelTable,
                            AssessedValue, SchoolExemptionAmounts,
                            FullSTARAmount);

          {If this is a coop or mobile home, use the amount that they
           entered. If it is not, use the full amount, since it will
           always be at least the full amount.}

        If not PropertyIsCoopOrMobileHomePark(ParcelTable)
          then BasicSTARAmount := FullSTARAmount; *)

        AdjustExemptionRollTotals(ExTotalTable, SwisCode,
                                  BasicSTARExemptionCode, '', 0, 0,
                                  BasicSTARAmount, 0,
                                  ProcessingType, SplitParcel,
                                  AdjustmentType);

(*        SwisCodeTable.Close;
        SwisCodeTable.Free; *)

      end;  {If (Roundoff(BasicSTARAmount, 0) > 0)}

  If (Roundoff(EnhancedSTARAmount, 0) > 0)
    then
      begin
(*        SwisCodeTable := TTable.Create(nil);

        OpenTableForProcessingType(SwisCodeTable, SwisCodeTableName,
                                   ProcessingType, Quit);

          {Get the full Enhanced STAR amount. If this is greater than the
           amount of the Enhanced STAR, then use it.}

        CalculateSTARAmount(TaxRollYr, '41834', SwisCode,
                            SwisCodeTable, ParcelTable,
                            AssessedValue, SchoolExemptionAmounts,
                            FullSTARAmount);

          {If this is a coop or mobile home, use the amount that they
           entered. If it is not, use the full amount, since it will
           always be at least the full amount.}

        If not PropertyIsCoopOrMobileHomePark(ParcelTable)
          then EnhancedSTARAmount := FullSTARAmount; *)

        AdjustExemptionRollTotals(ExTotalTable, SwisCode,
                                  EnhancedSTARExemptionCode, '', 0, 0,
                                  EnhancedSTARAmount, 0,
                                  ProcessingType, SplitParcel,
                                  AdjustmentType);

(*        SwisCodeTable.Close;
        SwisCodeTable.Free; *)

      end;  {If (Roundoff(EnhancedSTARAmount, 0) > 0)}

  ExTotalTable.Close;
  ExTotalTable.Free;

end;  {AdjustAllExRollTotals}

{============================================================================}
Procedure AdjustAllSDRollTotals(SwisCode : String;
                                RollSection : String;
                                HomesteadCode : String;
                                SDAmounts : TList;  {Each element is of PParcelSDValuesRecord.}
                                ProcessingType : Integer;  {ThisYear or NextYear}
                                AdjustmentType : Char);  {(A)dd or (D)elete}

{Either add the SD totals in the SDAmounts list or delete them depending
 on the AdjustmentType.}

var
  I, J : Integer;
  RS9TotalTable, SDTotalTable : TTable;
  Quit : Boolean;

begin
  Quit := False;

    {We will open the exemption roll total table here and pass it into
     AdjustExemptionRollTotals so that we don't have to open it for each
     exemption roll total calculation.}

  SDTotalTable := TTable.Create(nil);
  SDTotalTable.IndexName := 'BYYR_SWIS_SD_EXTENSION_CCOM';

  OpenTableForProcessingType(SDTotalTable, RTBySDCodeTableName,
                             ProcessingType, Quit);

  RS9TotalTable := TTable.Create(nil);
  RS9TotalTable.IndexName := 'BYTAXROLLYR_SWISCODE_SD';

  OpenTableForProcessingType(RS9TotalTable, RTByRS9TableName,
                             ProcessingType, Quit);

    {Now go through and adjust the roll totals for all extensions.}
    {CHG08021999-2: Add roll section 9 totals.}
    {CHG09302004-1(2.8.0.13): Continued work on hstd\non-hstd SD totals.}

  For I := 0 to (SDAmounts.Count - 1) do  {For each SD code}
    with PParcelSDValuesRecord(SDAmounts[I])^ do
      For J := 1 to 10 do
        If (Deblank(SDValues[J]) <> '')
          then AdjustSDRollTotals(SDTotalTable,
                                  RS9TotalTable,
                                  RollSection,
                                  StrToFloat(SDValues[J]),
                                  SwisCode, SDCode,
                                  SDExtensionCodes[J],
                                  SDCC_OMFlags[J],
                                  HomesteadCodes[J],
                                  SplitDistrict,
                                  ProcessingType,
                                  AdjustmentType);

  SDTotalTable.Close;
  SDTotalTable.Free;
  RS9TotalTable.Close;
  RS9TotalTable.Free;

end;  {AdjustAllSpecialDistricts}

{===============================================================}
Procedure AdjustAllVillageRelevyRollTotals(SwisCode : String;
                                           HomesteadCode : String;
                                           VillageRelevyAmount : Extended;
                                           ProcessingType : Integer;
                                           AdjustmentType : Char);

 {Adjust
 The AdjustmentType variable says whether or not we will add or delete
 the information.}

var
  VillageRelevyTotalTable : TTable;
  Quit, VillageRelevyRecFound, VillageRelevyTableCreated : Boolean;
  TempHomesteadCode : String;
  AddOrSubtractMultiplier : Integer;

begin
  Quit := False;
  VillageRelevyTableCreated := False;
  VillageRelevyTotalTable := nil;

    {If the homestead or nonhomestead value is greater than 0,
     then create and open the swis code table.}

  If (Roundoff(VillageRelevyAmount, 0) > 0)
    then
      begin
        VillageRelevyTableCreated := True;
        VillageRelevyTotalTable := TTable.Create(nil);
        VillageRelevyTotalTable.IndexName := 'BYYEAR_SWIS_HC';
        OpenTableForProcessingType(VillageRelevyTotalTable, RTByVillageRelevyTableName,
                                   ProcessingType, Quit);

        If (HomesteadCode = 'S')
          then TempHomesteadCode := 'H'  {This is the homestead part of the split parcel.}
          else TempHomesteadCode := Take(1, HomesteadCode);

          {Get the homestead swis record for this roll total or blank
           if this municipality is not classified.}

        VillageRelevyRecFound := FindKeyOld(VillageRelevyTotalTable,
                                            ['TaxRollYr', 'SwisCode', 'HomesteadCode'],
                                            [GetTaxRollYearForProcessingType(ProcessingType),
                                             SwisCode,
                                             Take(1, TempHomesteadCode)]);

          {If this is the add case, we will add the exemption amounts.
           Otherwise, we will subtract the exemption amounts.
           To do this, we will multiplty the exemption amounts by 1
           or -1, respectively.}

        If (AdjustmentType = 'A')
          then AddOrSubtractMultiplier := 1
          else AddOrSubtractMultiplier := -1;

          {If the Swis totals record was found, edit the existing record.
           Otherwise, create a new Swis totals record.}

        If VillageRelevyRecFound
          then
            begin
                {The swis total record was found, so just edit the amounts.}

              VillageRelevyTotalTable.Edit;

                {If this is the add case, add one to the parcel count.
                 Otherwise (delete case) subtract one from the parcel count.}

              with VillageRelevyTotalTable do
                FieldByName('VillageRelevyCount').AsInteger :=
                            FieldByName('VillageRelevyCount').AsInteger + 1 * AddOrSubtractMultiplier;

            end
          else
            begin
               {This is the first Swis roll total of this type, so let's create
                a new record.}

              with VillageRelevyTotalTable do
                begin
                  Insert;

                  FieldByName('TaxRollYr').Text := GetTaxRollYearForProcessingType(ProcessingType);
                  FieldByName('SwisCode').Text := SwisCode;
                  FieldByName('HomesteadCode').Text := Take(1, TempHomesteadCode);

                  If (Roundoff(VillageRelevyAmount, 2) > 0)
                    then FieldByName('VillageRelevyCount').AsInteger := 1;

                end;  {with VillageRelevyTotalTable do}

            end;  {else of If VillageRelevyRecFound}

          {Now adjust the assessment amounts by adding the new assessment
           amount.}

        with VillageRelevyTotalTable do
          begin
            If (Roundoff(VillageRelevyAmount, 2) > 0)
              then FieldByName('VillageRelevyAmount').AsFloat :=
                         FieldByName('VillageRelevyAmount').AsFloat +
                         VillageRelevyAmount * AddOrSubtractMultiplier;

            try
              Post;
            except
              SystemSupport(940, VillageRelevyTotalTable, 'Error posting swis roll total record.',
                            'PASUTILS.PAS', GlblErrorDlgBox);
            end;

          end;  {with VillageRelevyTotalTable do}

      end;  {If (Roundoff(VillageRelevyAmount, 0) > 0)}

  If VillageRelevyTableCreated
    then
      begin
        VillageRelevyTotalTable.Close;
        VillageRelevyTotalTable.Free;
      end;  {If (VillageRelevyTotalTable <> nil)}

end;  {AdjustAllVillageRelevyRollTotals}

{=========================================================================}
Procedure AdjustAllSchoolRelevyRollTotals(SwisCode : String;
                                          SchoolCode : String;
                                           HomesteadCode : String;
                                           SchoolRelevyAmount : Extended;
                                           ProcessingType : Integer;
                                           AdjustmentType : Char);

 {Adjust
 The AdjustmentType variable says whether or not we will add or delete
 the information.}

var
  SchoolRelevyTotalTable : TTable;
  Quit, SchoolRelevyRecFound, SchoolRelevyTableCreated : Boolean;
  TempHomesteadCode : String;
  AddOrSubtractMultiplier : Integer;

begin
  Quit := False;
  SchoolRelevyTableCreated := False;
  SchoolRelevyTotalTable := nil;

    {If the homestead or nonhomestead value is greater than 0,
     then create and open the swis code table.}

  If (Roundoff(SchoolRelevyAmount, 0) > 0)
    then
      begin
        SchoolRelevyTableCreated := True;
        SchoolRelevyTotalTable := TTable.Create(nil);
        SchoolRelevyTotalTable.IndexName := 'BYYEAR_SWIS_SCHOOL_HC';
        OpenTableForProcessingType(SchoolRelevyTotalTable, RTBySchoolCodeTableName,
                                   ProcessingType, Quit);

        If (HomesteadCode = 'S')
          then TempHomesteadCode := 'H'  {This is the homestead part of the split parcel.}
          else TempHomesteadCode := Take(1, HomesteadCode);

          {Get the homestead swis record for this roll total or blank
           if this municipality is not classified.}

        SchoolRelevyRecFound := FindKeyOld(SchoolRelevyTotalTable,
                                           ['TaxRollYr', 'SwisCode', 'SchoolCode', 'HomesteadCode'],
                                           [GetTaxRollYearForProcessingType(ProcessingType),
                                            SwisCode,
                                            SchoolCode,
                                            Take(1, TempHomesteadCode)]);

          {If this is the add case, we will add the exemption amounts.
           Otherwise, we will subtract the exemption amounts.
           To do this, we will multiplty the exemption amounts by 1
           or -1, respectively.}

        If (AdjustmentType = 'A')
          then AddOrSubtractMultiplier := 1
          else AddOrSubtractMultiplier := -1;

          {If the Swis totals record was found, edit the existing record.
           Otherwise, create a new Swis totals record.}

        If SchoolRelevyRecFound
          then
            begin
                {The swis total record was found, so just edit the amounts.}

              SchoolRelevyTotalTable.Edit;

                {If this is the add case, add one to the parcel count.
                 Otherwise (delete case) subtract one from the parcel count.}

              with SchoolRelevyTotalTable do
                FieldByName('RelevyCount').AsInteger :=
                            FieldByName('RelevyCount').AsInteger + 1 * AddOrSubtractMultiplier;

            end
          else
            begin
               {This is the first Swis roll total of this type, so let's create
                a new record.}

              with SchoolRelevyTotalTable do
                begin
                  Insert;

                  FieldByName('TaxRollYr').Text := GetTaxRollYearForProcessingType(ProcessingType);
                  FieldByName('SwisCode').Text := SwisCode;
                  FieldByName('SchoolCode').Text := SchoolCode;
                  FieldByName('HomesteadCode').Text := Take(1, TempHomesteadCode);

                  If (Roundoff(SchoolRelevyAmount, 2) > 0)
                    then FieldByName('RelevyCount').AsInteger := 1;

                end;  {with SchoolRelevyTotalTable do}

            end;  {else of If SchoolRelevyRecFound}

          {Now adjust the assessment amounts by adding the new assessment
           amount.}

        with SchoolRelevyTotalTable do
          begin
            If (Roundoff(SchoolRelevyAmount, 2) > 0)
              then FieldByName('SchoolRelevyAmt').AsFloat :=
                         FieldByName('SchoolRelevyAmt').AsFloat +
                         SchoolRelevyAmount * AddOrSubtractMultiplier;

            try
              Post;
            except
              SystemSupport(940, SchoolRelevyTotalTable, 'Error posting swis roll total record.',
                            'PASUTILS.PAS', GlblErrorDlgBox);
            end;

          end;  {with SchoolRelevyTotalTable do}

      end;  {If (Roundoff(SchoolRelevyAmount, 0) > 0)}

  If SchoolRelevyTableCreated
    then
      begin
        SchoolRelevyTotalTable.Close;
        SchoolRelevyTotalTable.Free;
      end;  {If (SchoolRelevyTotalTable <> nil)}

end;  {AdjustAllSchoolRelevyRollTotals}

{===============================================================}
Procedure AdjustRollTotalsForParcel(TaxRollYr : String;
                                    SwisCode,
                                    SchoolCode : String;
                                    HomesteadCode,
                                    RollSection : String;
                                    HstdLandVal,
                                    NonhstdLandVal,
                                    HstdAssessedVal,
                                    NonhstdAssessedVal : Comp;
                                    ExemptionCodes,
                                    ExemptionHomesteadCodes,
                                    CountyExemptionAmounts,
                                    TownExemptionAmounts,
                                    SchoolExemptionAmounts,
                                    VillageExemptionAmounts : TStringList;
                                    ParcelTable : TTable;
                                    BasicSTARAmount,
                                    EnhancedSTARAmount : Comp;
                                    SDAmounts : TList;
                                    AdjustmentTypeSet : Charset;  {Adjust (S)wis, s(C)hool, (E)xemption, s(D)}
                                    AdjustmentType : Char);  {(A)dd or (D)elete}

{CHG12011997-2: STAR support}

{Either add the roll total amounts or delete the roll total amounts
 depending on what should be adjusted.
 To see what should be adjusted, look at the AdjustmentTypeSet:
 S = swis roll totals, C = school roll totals, E = exemption roll totals,
 D = special district roll totals.
 The exemption codes and the exemption amount lists are string lists
 where for each exemption code in the list, the amount is in the same
 position in each of the amount lists.
 SDAmounts is a TList where each element is of type PParcelSDRecord.

 The amount arrays are filled in by calling TotalExemptionsForParcel
 and TotalSpecialDistrictsForParcel.}

var
  ProcessingType : Integer;  {ThisYear, NextYear}
  HstdExAmounts,
  NonhstdExAmounts : ExemptionTotalsArrayType;
  SplitParcel : Boolean;
  SchoolRelevy, VillageRelevy : Extended;

begin
  ProcessingType := GetProcessingTypeForTaxRollYear(TaxRollYr);

  SchoolRelevy := ParcelTable.FieldByName('SchoolRelevy').AsFloat;
  VillageRelevy := ParcelTable.FieldByName('VillageRelevy').AsFloat;

    {Let's figure out what the total homestead and nonhomestead
     exemption amounts are since they could be split between them
     if this is a split parcel.}

  If (AdjustmentTypeSet <> ['V', 'Z'])
    then GetHomesteadAndNonhstdExemptionAmounts(ExemptionCodes,
                                         ExemptionHomesteadCodes,
                                         CountyExemptionAmounts,
                                         TownExemptionAmounts,
                                         SchoolExemptionAmounts,
                                         VillageExemptionAmounts,
                                         HstdEXAmounts,
                                         NonhstdEXAmounts);

    {FXX11071997-4: Store the part amounts for split parcels seperate
                    from the parcel count.}

  SplitParcel := (HomesteadCode = 'S');

    {Adjust the exemption amounts.}
    {CHG12011997-2: STAR support.  Adjust the STAR exemptions.}

  If ('E' in AdjustmentTypeSet)
    then AdjustAllExRollTotals(TaxRollYr, SwisCode,
                               ExemptionCodes,
                               ExemptionHomesteadCodes,
                               CountyExemptionAmounts,
                               TownExemptionAmounts,
                               SchoolExemptionAmounts,
                               VillageExemptionAmounts,
                               (HstdAssessedVal + NonhstdAssessedVal),
                               BasicSTARAmount,
                               EnhancedSTARAmount,
                               ParcelTable,
                               ProcessingType, SplitParcel,
                               AdjustmentType);

    {Now adjust the swis roll totals.}
    {FXX02101999-4: Add land value to swis and school totals.}
    {FXX09132001-4: Exclude roll section 9.}

  If (('S' in AdjustmentTypeSet) and
      (RollSection <> '9'))
    then AdjustSwisRollTotals(SwisCode,
                              HomesteadCode, RollSection,
                              HstdLandVal, NonhstdLandVal,
                              HstdAssessedVal, NonhstdAssessedVal,
                              HstdExAmounts, NonhstdExAmounts,
                              ProcessingType, SplitParcel,
                              AdjustmentType);

    {Now adjust the school roll totals.}
    {FXX02101999-4: Add land value to swis and school totals.}
    {FXX09132001-4: Exclude roll section 9.}

  If (('C' in AdjustmentTypeSet) and
      (RollSection <> '9'))
    then AdjustSchoolRollTotals(SwisCode,
                                SchoolCode, HomesteadCode,
                                HstdLandVal, NonhstdLandVal,
                                HstdAssessedVal, NonhstdAssessedVal,
                                HstdExAmounts, NonhstdExAmounts,
                                BasicSTARAmount, EnhancedSTARAmount,
                                SchoolRelevy,
                                ProcessingType, SplitParcel,
                                AdjustmentType);

    {Delete the old special district values.}
    {CHG08021999-2: Add roll section 9 totals.}

  If ('D' in AdjustmentTypeSet)
    then AdjustAllSDRollTotals(SwisCode, ParcelTable.FieldByName('RollSection').Text,
                               HomesteadCode, SDAmounts, ProcessingType, AdjustmentType);

  If ('V' in AdjustmentTypeSet)
    then AdjustAllVillageRelevyRollTotals(SwisCode, HomesteadCode,
                                          VillageRelevy, ProcessingType, AdjustmentType);

  If ('Z' in AdjustmentTypeSet)
    then AdjustAllSchoolRelevyRollTotals(SwisCode, SchoolCode, HomesteadCode,
                                         SchoolRelevy, ProcessingType, AdjustmentType);

end;  {AdjustRollTotalsForParcel}

{=============================================================================}
{========================  LOAD THE LISTS FOR DISPLAY ========================}
{=============================================================================}

{===================================================================}
{=============   SCHOOL TOTALS =====================================}
{===================================================================}
Function FoundSchoolCodeTotRec(    TotalsBySchoolList : TList;
                                   TotalsBySchoolTable : TTable;
                                   ShowHomesteadCodes,  {Do they want to see totals by homestead code?}
                                   TotalsOnly : Boolean;  {Are these totals by swis or overall?}
                               var TotIdx : Integer) : Boolean;

{FXX11041997-1: School code totals should not have homestead code.}

{See if this entry is already in the list. If so, return the index.}

var
  I : Integer;

begin
  Result := False;

  For I := 0 to (TotalsBySchoolList.Count - 1) do
    with RTSchoolCodeTotalsPtr(TotalsBySchoolList[I])^ do
      If ((Take(6, SchoolCode) = Take(6, TotalsBySchoolTable.FieldByName('SchoolCode').Text)) and
          ((not ShowHomesteadCodes) or
           (Take(1, HomesteadCode) = Take(1, TotalsBySchoolTable.FieldByName('HomesteadCode').Text))) and
          (TotalsOnly or
           (Take(6, SwisCode) = Take(6, TotalsBySchoolTable.FieldByName('SwisCode').Text))))
        then
          begin
            TotIdx := I;
            Result := True;
          end;

end;  {FoundSchoolCodeTotRec}

{==========================================================================================}
Procedure SortSchoolList(TotalsBySchoolList : TList);

{FXX11041997-5: Sort the School totals by swis\Schoolcode\extension}

var
  MainKey, NewKey : String;
  I, J : Integer;
  TempPtr : RTSchoolCodeTotalsPtr;

begin
  For I := 0 to (TotalsBySchoolList.Count - 1) do
    begin
      with RTSchoolCodeTotalsPtr(TotalsBySchoolList[I])^ do
        MainKey := Take(6, SwisCode) + Take(6, SchoolCode) + Take(1, HomesteadCode);

      For J := (I + 1) to (TotalsBySchoolList.Count - 1) do
        begin
          with RTSchoolCodeTotalsPtr(TotalsBySchoolList[J])^ do
            NewKey := Take(6, SwisCode) + Take(6, SchoolCode) + Take(1, HomesteadCode);

          If (NewKey < MainKey)
            then
              begin
                TempPtr := TotalsBySchoolList[I];
                TotalsBySchoolList[I] := TotalsBySchoolList[J];
                TotalsBySchoolList[J] := TempPtr;
                MainKey := NewKey;

              end;  {If (NewKey < MainKey)}

        end;  {For J := (I + 1) to (TotalsBySchoolList.Count - 1) do}

    end;  {For I := 0 to (TotalsBySchoolList.Count - 1) do}

end;  {SortSchoolList}

{=============================================================================}
Procedure LoadTotalsBySchoolList(TotalsBySchoolList : TList;
                                 TotalsBySchoolTable : TTable;
                                 SelectedSwisCodes : TStringList;
                                 TotalsOnly,
                                 ShowHomesteadCodes : Boolean;
                                 TaxRollYear : String);

{Return a list with the school totals.}

var
  SchoolCodePtr : RTSchoolCodeTotalsPtr;
  FirstTimeThrough, Done : Boolean;
  TotIdx : Integer;

begin
    {Go through all the School totals records.}

  Done := False;
  FirstTimeThrough := True;
  TotalsBySchoolTable.IndexName := 'BYYEAR_SWIS_SCHOOL_HC';
  TotalsBySchoolTable.First;

    {Fill the list.}

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else TotalsBySchoolTable.Next;

    If TotalsBySchoolTable.EOF
      then Done := True;

     {If they want overall totals or they want this swis code, then
      put it in the list.}

      {FXX11071997-1: Forgot to test for done condition.}
      {FXX10041999-7: Make sure to pass the year in for history load.}

   If ((not Done) and
       (*(TotalsOnly or*)
        (SelectedSwisCodes.IndexOf(TotalsBySchoolTable.FieldByName('SwisCode').Text) <> -1) and
       (TotalsBySchoolTable.FieldByName('TaxRollYr').Text = TaxRollYear))
     then
       If FoundSchoolCodeTotRec(TotalsBySchoolList, TotalsBySchoolTable, ShowHomesteadCodes,
                                TotalsOnly, TotIdx)
          then
            begin
                 {if existing record keyd by taxyr,swis,rs & hstd cd}
                 {..update it with info from this parcel}

              with RTSchoolCodeTotalsPtr(TotalsBySchoolList[TotIdx])^ do
                begin
                    {FXX11071997-4: Display the parts amounts for split parcels.}

                  PartCount := PartCount +
                                 TotalsBySchoolTable.FieldByName('PartCount').AsInteger;
                  ParcelCount := ParcelCount +
                                 TotalsBySchoolTable.FieldByName('ParcelCount').AsInteger;

                    {FXX02101999-4: Add land value to swis and school totals.}

                  LandValue := LandValue +
                                   TotalsBySchoolTable.FieldByName('LandValue').AsFloat;
                  AssessedValue := AssessedValue +
                                   TotalsBySchoolTable.FieldByName('AssessedValue').AsFloat;
                  SchoolTaxable := SchoolTaxable +
                                   TotalsBySchoolTable.FieldByName('SchoolTaxable').AsFloat;
                  RelevyCount   := RelevyCount +
                                   TotalsBySchoolTable.FieldByName('RelevyCount').AsInteger;
                  SchoolRelevyAmt := SchoolRelevyAmt +
                                     TotalsBySchoolTable.FieldByName('SchoolRelevyAmt').AsFloat;
                  BasicSTARAmount := BasicSTARAmount +
                                     TotalsBySchoolTable.FieldByName('BasicSTARAmount').AsFloat;
                  EnhancedSTARAmount := EnhancedSTARAmount +
                                        TotalsBySchoolTable.FieldByName('EnhancedSTARAmount').AsFloat;
                  BasicSTARCount := BasicSTARCount +
                                     TotalsBySchoolTable.FieldByName('BasicSTARCount').AsInteger;
                  EnhancedSTARCount := EnhancedSTARCount +
                                        TotalsBySchoolTable.FieldByName('EnhancedSTARCount').AsInteger;

                end;  {with RTSchoolCodeTotalsPtr(TotalsBySchoolList[TotIdx])^ do}

            end
          else
            begin
                {Add a new entry.}

              New(SchoolCodePtr);

              with SchoolCodePtr^ do
                begin
                  TaxRollYr := TotalsBySchoolTable.FieldByName('TaxRollYr').Text;

                    {Only 4 dig of swis for grand totals}

                    {FXX12172001-2: Only do a take 2 on the swis code for villages
                                    that go across 2 towns.}

                  If TotalsOnly
                    then SwisCode := Take(2, TotalsBySchoolTable.FieldByName('SwisCode').Text)
                    else SwisCode := TotalsBySchoolTable.FieldByName('SwisCode').Text;

                    {If they do not want to see the homestead code, we will leave it
                     blank.}

                  If ShowHomesteadCodes
                    then HomesteadCode := TotalsBySchoolTable.FieldByName('HomesteadCode').Text
                    else HomesteadCode := '';

                  SchoolCode := TotalsBySchoolTable.FieldByName('SchoolCode').Text;

                    {FXX11071997-4: Display the parts amounts for split parcels.}

                  PartCount := TotalsBySchoolTable.FieldByName('PartCount').AsInteger;
                  ParcelCount := TotalsBySchoolTable.FieldByName('ParcelCount').AsInteger;

                    {FXX02101999-4: Add land value to swis and school totals.}

                  LandValue := TotalsBySchoolTable.FieldByName('LandValue').AsFloat;
                  AssessedValue := TotalsBySchoolTable.FieldByName('AssessedValue').AsFloat;
                  SchoolTaxable := TotalsBySchoolTable.FieldByName('SchoolTaxable').AsFloat;
                  RelevyCount   := TotalsBySchoolTable.FieldByName('RelevyCount').AsInteger;
                  SchoolRelevyAmt := TotalsBySchoolTable.FieldByName('SchoolRelevyAmt').AsFloat;
                  BasicSTARAmount := TotalsBySchoolTable.FieldByName('BasicSTARAmount').AsFloat;
                  EnhancedSTARAmount := TotalsBySchoolTable.FieldByName('EnhancedSTARAmount').AsFloat;
                  BasicSTARCount := TotalsBySchoolTable.FieldByName('BasicSTARCount').AsInteger;
                  EnhancedSTARCount := TotalsBySchoolTable.FieldByName('EnhancedSTARCount').AsInteger;

                end;  {with SchoolCodePtr^ do}

              TotalsBySchoolList.Add(SchoolCodePtr);

            end;  {else of If FoundSwisSchoolCodeRec ...}

  until Done;

    {Now sort the display list.}

  SortSchoolList(TotalsBySchoolList);

end;  {LoadTotalsBySchoolList}

{===================================================================}
{=============   EXEMPTION TOTALS ==================================}
{===================================================================}
Function FoundEXCodeTotRec(    TotalsByExemptionList : TList;
                               TotalsByExemptionTable : TTable;
                               ShowHomesteadCodes,  {Do they want to see totals by homestead code?}
                               TotalsOnly : Boolean;  {Are these totals by swis or overall?}
                           var TotIdx : Integer) : Boolean;

{See if this entry is already in the list. If so, return the index.}

var
  I : Integer;

begin
  Result := False;

  For I := 0 to (TotalsByExemptionList.Count - 1) do
    with RTEXCodeTotalsPtr(TotalsByExemptionList[I])^ do
      If ((Take(5, EXCode) = Take(5, TotalsByExemptionTable.FieldByName('EXCode').Text)) and
           ((not ShowHomesteadCodes) or
            (Take(1, HomesteadCode) = Take(1, TotalsByExemptionTable.FieldByName('HomesteadCode').Text))) and
           (TotalsOnly or
            (Take(6, SwisCode) = Take(6, TotalsByExemptionTable.FieldByName('SwisCode').Text))))
        then
          begin
            TotIdx := I;
            Result := True;
          end;

end;  {FoundEXCodeTotRec}

{==========================================================================================}
Procedure SortEXList(TotalsByExemptionList : TList);

{FXX11041997-5: Sort the totals.}

var
  MainKey, NewKey : String;
  I, J : Integer;
  TempPtr : RTEXCodeTotalsPtr;

begin
  For I := 0 to (TotalsByExemptionList.Count - 1) do
    begin
      with RTEXCodeTotalsPtr(TotalsByExemptionList[I])^ do
        MainKey := Take(6, SwisCode) + Take(5, EXCode) + Take(1, HomesteadCode);

      For J := (I + 1) to (TotalsByExemptionList.Count - 1) do
        begin
          with RTEXCodeTotalsPtr(TotalsByExemptionList[J])^ do
            NewKey := Take(6, SwisCode) + Take(5, EXCode) + Take(1, HomesteadCode);

          If (NewKey < MainKey)
            then
              begin
                TempPtr := TotalsByExemptionList[I];
                TotalsByExemptionList[I] := TotalsByExemptionList[J];
                TotalsByExemptionList[J] := TempPtr;
                MainKey := NewKey;

              end;  {If (NewKey < MainKey)}

        end;  {For J := (I + 1) to (TotalsByExemptionList.Count - 1) do}

    end;  {For I := 0 to (TotalsByExemptionList.Count - 1) do}

end;  {SortEXList}

{=============================================================================}
Procedure LoadTotalsByExemptionList(TotalsByExemptionList : TList;
                                    TotalsByExemptionTable : TTable;
                                    SelectedSwisCodes : TStringList;
                                    TotalsOnly,
                                    ShowHomesteadCodes : Boolean;
                                    TaxRollYear : String);

{Return a list with the Exemption totals.}

var
  EXCodePtr : RTEXCodeTotalsPtr;
  FirstTimeThrough, Done : Boolean;
  TotIdx : Integer;

begin
    {Go through all the EX totals records.}

  Done := False;
  FirstTimeThrough := True;

  TotalsByExemptionTable.IndexName := 'BYTAXROLLYR_SWISCODE_EX_HC';
  TotalsByExemptionTable.First;

    {Fill the list.}

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else TotalsByExemptionTable.Next;

   If TotalsByExemptionTable.Eof
     then Done := True;

     {If they want overall totals or they want this swis code, then
      put it in the list.}

      {FXX11071997-1: Forgot to test for done condition.}
      {FXX10041999-7: Make sure to pass the year in for history load.}

   If ((not Done) and
       (*(TotalsOnly or *)
       (SelectedSwisCodes.IndexOf(TotalsByExemptionTable.FieldByName('SwisCode').Text) <> -1) and
       (TotalsByExemptionTable.FieldByName('TaxRollYr').Text = TaxRollYear))
     then
       If FoundEXCodeTotRec(TotalsByExemptionList, TotalsByExemptionTable, ShowHomesteadCodes,
                            TotalsOnly, TotIdx)
          then
            begin
                 {if existing record keyd by taxyr,swis,rs & hstd cd}
                 {..update it with info from this parcel}

              with RTEXCodeTotalsPtr(TotalsByExemptionList[TotIdx])^ do
                begin
                    {FXX11071997-4: Display the parts amounts for split parcels.}

                  PartCount := PartCount +
                                 TotalsByExemptionTable.FieldByName('PartCount').AsInteger;
                  ParcelCount := ParcelCount +
                                 TotalsByExemptionTable.FieldByName('ParcelCount').AsInteger;
                  CountyExAmount := CountyExAmount +
                                    TotalsByExemptionTable.FieldByName('CountyExAmount').AsFloat;
                  TownExAmount := TownExAmount +
                                  TotalsByExemptionTable.FieldByName('TownExAmount').AsFloat;
                  SchoolExAmount := SchoolExAmount +
                                    TotalsByExemptionTable.FieldByName('SchoolExAmount').AsFloat;
                  VillageExAmount := VillageExAmount +
                                     TotalsByExemptionTable.FieldByName('VillageExAmount').AsFloat;

                end;  {with RTEXCodeTotalsPtr(TotalsByExemptionList[TotIdx])^ do}

            end
          else
            begin
                {Add a new entry.}

              New(EXCodePtr);

              with EXCodePtr^ do
                 begin
                  TaxRollYr := TotalsByExemptionTable.FieldByName('TaxRollYr').Text;

                     {Only 4 dig of swis for grand totals}
                    {FXX12172001-2: Only do a take 2 on the swis code for villages
                                    that go across 2 towns.}

                   If TotalsOnly
                     then SwisCode := Take(2, TotalsByExemptionTable.FieldByName('SwisCode').Text)
                     else SwisCode := TotalsByExemptionTable.FieldByName('SwisCode').Text;

                   EXCode := TotalsByExemptionTable.FieldByName('EXCode').Text;

                     {If they do not want to see the homestead code, we will leave it
                      blank.}

                   If ShowHomesteadCodes
                     then HomesteadCode := TotalsByExemptionTable.FieldByName('HomesteadCode').Text
                     else HomesteadCode := '';

                     {FXX11071997-4: Display the parts amounts for split parcels.}

                   PartCount := TotalsByExemptionTable.FieldByName('PartCount').AsInteger;
                   ParcelCount := TotalsByExemptionTable.FieldByName('ParcelCount').AsInteger;
                   CountyEXAmount := TotalsByExemptionTable.FieldByName('CountyEXAmount').AsFloat;
                   TownEXAmount := TotalsByExemptionTable.FieldByName('TownEXAmount').AsFloat;
                   SchoolEXAmount := TotalsByExemptionTable.FieldByName('SchoolEXAmount').AsFloat;
                   VillageEXAmount := TotalsByExemptionTable.FieldByName('VillageEXAmount').AsFloat;

                 end;  {with EXCodePtr^ do}

              TotalsByExemptionList.Add(EXCodePtr);

            end;  {else of If FoundSwisEXCodeRec ...}

  until Done;

    {Now sort the display list.}

  SortEXList(TotalsByExemptionList);

end;  {LoadTotalsByExemptionList}

{===================================================================}
{=====================  SD TOTALS ==================================}
{===================================================================}
Function FoundSDCodeTotRec(    TotalsBySpecialDistrictList : TList;
                               TotalsBySpecialDistrictTable : TTable;
                               TotalsOnly : Boolean;  {Are these totals by swis or overall?}
                               ShowHomesteadCode : Boolean;
                           var TotIdx : Integer) : Boolean;

{FXX11041997-1: SD code totals should not have homestead code.}

{See if this entry is already in the list. If so, return the index.}

var
  I : Integer;

begin
  Result := False;

    {CHG09122004-1(2.8.0.11): Add homestead split to SD Calcs}

  For I := 0 to (TotalsBySpecialDistrictList.Count - 1) do
    with RTSDCodeTotalsPtr(TotalsBySpecialDistrictList[I])^ do
      If ((Take(5, SDCode) = Take(5, TotalsBySpecialDistrictTable.FieldByName('SDCode').Text)) and
          (Take(2, ExtensionCode) = Take(2, TotalsBySpecialDistrictTable.FieldByName('ExtensionCode').Text)) and
          ((not (SplitDistrict or ShowHomesteadCode)) or
           (Take(1, HomesteadCode) = Take(1, TotalsBySpecialDistrictTable.FieldByName('HomesteadCode').Text))) and
          (TotalsOnly or
           (Take(6, SwisCode) = Take(6, TotalsBySpecialDistrictTable.FieldByName('SwisCode').Text))))
        then
          begin
            TotIdx := I;
            Result := True;
          end;

end;  {FoundSDCodeTotRec}

{==========================================================================================}
Procedure SortSDList(TotalsBySpecialDistrictList : TList);

{FXX11041997-5: Sort the SD totals by swis\SDcode\extension}

var
  MainKey, NewKey : String;
  I, J : Integer;
  TempPtr : RTSDCodeTotalsPtr;

begin
  For I := 0 to (TotalsBySpecialDistrictList.Count - 1) do
    begin
      with RTSDCodeTotalsPtr(TotalsBySpecialDistrictList[I])^ do
        MainKey := Take(6, SwisCode) + Take(5, SDCode) + Take(2, ExtensionCode);

      For J := (I + 1) to (TotalsBySpecialDistrictList.Count - 1) do
        begin
          with RTSDCodeTotalsPtr(TotalsBySpecialDistrictList[J])^ do
            NewKey := Take(6, SwisCode) + Take(5, SDCode) + Take(2, ExtensionCode);

          If (NewKey < MainKey)
            then
              begin
                TempPtr := TotalsBySpecialDistrictList[I];
                TotalsBySpecialDistrictList[I] := TotalsBySpecialDistrictList[J];
                TotalsBySpecialDistrictList[J] := TempPtr;
                MainKey := NewKey;

              end;  {If (NewKey < MainKey)}

        end;  {For J := (I + 1) to (TotalsBySpecialDistrictList.Count - 1) do}

    end;  {For I := 0 to (TotalsBySpecialDistrictList.Count - 1) do}

end;  {SortSDList}

{=============================================================================}
Procedure LoadTotalsBySpecialDistrictList(TotalsBySpecialDistrictList : TList;
                                          TotalsBySpecialDistrictTable : TTable;
                                          SelectedSwisCodes : TStringList;
                                          TotalsOnly,
                                          ShowHomesteadCode,
                                          ProratasOnly : Boolean;
                                          AssessmentYear : String);

{Return a list with the special district totals.}

var
  Done, FirstTimeThrough : Boolean;
  SDCodePtr : RTSDCodeTotalsPtr;
  TotIdx : Integer;

begin
    {Go through all the SD totals records.}

  Done := False;
  FirstTimeThrough := True;

  TotalsBySpecialDistrictTable.IndexName := 'BYYR_SWIS_SD_EXTENSION_CCOM';
  TotalsBySpecialDistrictTable.First;

    {Fill the list.}

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else TotalsBySpecialDistrictTable.Next;

    If TotalsBySpecialDistrictTable.EOF
      then Done := True;

      {If they want overall totals or they want this swis code, then
       put it in the list.}

      {FXX11071997-1: Forgot to test for done condition.}
      {FXX12161998-2: Display proratas\omitteds. For now cheat and just
                      go on the first letter of the sd code - Ramapo uses 'P'
                      for all proratas.}
       {FXX10041999-7: Make sure to pass the year in for history load.}
       {FXX10041999-7: Make sure to pass the year in for history load.}

    If ((not Done) and
        (TotalsBySpecialDistrictTable.FieldByName('TaxRollYr').Text = AssessmentYear) and
        (TotalsOnly or
         (SelectedSwisCodes.IndexOf(TotalsBySpecialDistrictTable.FieldByName('SwisCode').Text) <> -1)))
      then
        If FoundSDCodeTotRec(TotalsBySpecialDistrictList, TotalsBySpecialDistrictTable,
                             TotalsOnly, ShowHomesteadCode, TotIdx)
           then
             begin
                  {if existing record keyd by taxyr,swis,rs & hstd cd}
                  {..update it with info from this parcel}

               with RTSDCodeTotalsPtr(TotalsBySpecialDistrictList[TotIdx])^ do
                 begin
                     {FXX07112007(2.11.2.2)[D906]: The overall total was being double counted
                                                   for split districts.  So, don't add in the
                                                   non-homestead portion when doing the total
                                                   parcel count for the district.}

                    ParcelCount := ParcelCount +
                                   TotalsBySpecialDistrictTable.FieldByName('ParcelCount').AsInteger;

                    If ((not ShowHomesteadCode) and
                        _Compare(TotalsBySpecialDistrictTable.FieldByName('HomesteadCode').AsString, 'N', coEqual))
                      then ParcelCount := ParcelCount -
                                          TotalsBySpecialDistrictTable.FieldByName('PartCount').AsInteger;

                   TaxableValue := TaxableValue +
                                   TotalsBySpecialDistrictTable.FieldByName('TaxableValue').AsFloat;

                     {CHG05102009-1(2.20.1.1)[F925]: Add the assessed value to the roll totals print.}

                   AssessedValue := AssessedValue +
                                    TotalsBySpecialDistrictTable.FieldByName('AssessedValue').AsFloat;

                 end;  {with RTSDCodeTotalsPtr(TotalsBySpecialDistrictList[TotIdx])^ do}

             end
           else
             begin
                 {Add a new entry.}

               New(SDCodePtr);

               with SDCodePtr^ do
                  begin
                   TaxRollYr := AssessmentYear;

                      {Only 4 dig of swis for grand totals}
                    {FXX12172001-2: Only do a take 2 on the swis code for villages
                                    that go across 2 towns.}

                    If TotalsOnly
                      then SwisCode := Take(2, TotalsBySpecialDistrictTable.FieldByName('SwisCode').Text)
                      else SwisCode := TotalsBySpecialDistrictTable.FieldByName('SwisCode').Text;

                    SDCode := TotalsBySpecialDistrictTable.FieldByName('SDCode').Text;
                    ExtensionCode := TotalsBySpecialDistrictTable.FieldByName('ExtensionCode').Text;
                    CCOMFlg := TotalsBySpecialDistrictTable.FieldByName('CCOMFlg').Text;
                    ParcelCount := TotalsBySpecialDistrictTable.FieldByName('ParcelCount').AsInteger;

                    If ((not ShowHomesteadCode) and
                        _Compare(TotalsBySpecialDistrictTable.FieldByName('HomesteadCode').AsString, 'N', coEqual))
                      then ParcelCount := ParcelCount -
                                          TotalsBySpecialDistrictTable.FieldByName('PartCount').AsInteger;

                      {FXX11171997-6: Was being read AsInteger, but should be AsFloat.}

                    TaxableValue := TotalsBySpecialDistrictTable.FieldByName('TaxableValue').AsFloat;

                     {CHG05102009-1(2.20.1.1)[F925]: Add the assessed value to the roll totals print.}

                    AssessedValue := TotalsBySpecialDistrictTable.FieldByName('AssessedValue').AsFloat;

                      {CHG09122004-1(2.8.0.11): Add homestead split to SD Calcs}

                    If ShowHomesteadCode
                      then
                        begin
                          HomesteadCode := TotalsBySpecialDistrictTable.FieldByName('HomesteadCode').Text;
                          SplitDistrict := TotalsBySpecialDistrictTable.FieldByName('SplitDistrict').AsBoolean;
                        end
                      else
                        begin
                          HomesteadCode := '';
                          SplitDistrict := False;
                        end;

                  end;  {with SDCodePtr^ do}

               TotalsBySpecialDistrictList.Add(SDCodePtr);

             end;  {else of If FoundSwisSDCodeRec ...}

  until Done;

    {Now sort the display list.}

  SortSDList(TotalsBySpecialDistrictList);

end;  {LoadTotalsBySpecialDistrictList}

{CHG08021999-2: Add roll section 9 totals.}
{===================================================================}
{=====================  RS9 TOTALS ==================================}
{===================================================================}
Function FoundRS9TotRec(    TotalsByRS9List : TList;
                            TotalsByRS9Table : TTable;
                            TotalsOnly : Boolean;  {Are these totals by swis or overall?}
                        var TotIdx : Integer) : Boolean;

{FXX11041997-1: RS9 code totals should not have homestead code.}

{See if this entry is already in the list. If so, return the index.}

var
  I : Integer;

begin
  Result := False;

  For I := 0 to (TotalsByRS9List.Count - 1) do
    with RTRS9TotalsPtr(TotalsByRS9List[I])^ do
      If ((Take(5, SDCode) = Take(5, TotalsByRS9Table.FieldByName('SDCode').Text)) and
          (TotalsOnly or
           (Take(6, SwisCode) = Take(6, TotalsByRS9Table.FieldByName('SwisCode').Text))))
        then
          begin
            TotIdx := I;
            Result := True;
          end;

end;  {FoundRS9TotRec}

{==========================================================================================}
Procedure SortRS9List(TotalsByRS9List : TList);

{FXX11041997-5: Sort the RS9 totals by swis\RS9\extension}

var
  MainKey, NewKey : String;
  I, J : Integer;
  TempPtr : RTRS9TotalsPtr;

begin
  For I := 0 to (TotalsByRS9List.Count - 1) do
    begin
      with RTRS9TotalsPtr(TotalsByRS9List[I])^ do
        MainKey := Take(6, SwisCode) + Take(5, SDCode);

      For J := (I + 1) to (TotalsByRS9List.Count - 1) do
        begin
          with RTRS9TotalsPtr(TotalsByRS9List[J])^ do
            NewKey := Take(6, SwisCode) + Take(5, SDCode);

          If (NewKey < MainKey)
            then
              begin
                TempPtr := TotalsByRS9List[I];
                TotalsByRS9List[I] := TotalsByRS9List[J];
                TotalsByRS9List[J] := TempPtr;
                MainKey := NewKey;

              end;  {If (NewKey < MainKey)}

        end;  {For J := (I + 1) to (TotalsByRS9List.Count - 1) do}

    end;  {For I := 0 to (TotalsByRS9List.Count - 1) do}

end;  {SortRS9List}

{=============================================================================}
Procedure LoadTotalsByProrataList(TotalsByRS9List : TList;
                                  TotalsByRS9Table : TTable;
                                  SelectedSwisCodes : TStringList;
                                  TotalsOnly : Boolean;
                                  TaxRollYear : String);

{Return a list with the special district totals.}

var
  Done, FirstTimeThrough : Boolean;
  RS9Ptr : RTRS9TotalsPtr;
  TotIdx : Integer;

begin
    {Go through all the RS9 totals records.}

  Done := False;
  FirstTimeThrough := True;

  TotalsByRS9Table.IndexName := 'BYTAXROLLYR_SWISCODE_SD';
  TotalsByRS9Table.First;

    {Fill the list.}

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else TotalsByRS9Table.Next;

    If TotalsByRS9Table.EOF
      then Done := True;

      {If they want overall totals or they want this swis code, then
       put it in the list.}

      {FXX11071997-1: Forgot to test for done condition.}
      {FXX12161998-2: Display proratas\omitteds. For now cheat and just
                      go on the first letter of the RS9 code - Ramapo uses 'P'
                      for all proratas.}
       {FXX10041999-7: Make sure to pass the year in for history load.}

    If ((not Done) and
        (TotalsByRS9Table.FieldByName('TaxRollYr').Text = TaxRollYear) and
        (TotalsOnly or
         (SelectedSwisCodes.IndexOf(TotalsByRS9Table.FieldByName('SwisCode').Text) <> -1)))
      then
        If FoundRS9TotRec(TotalsByRS9List, TotalsByRS9Table, TotalsOnly, TotIdx)
           then
             begin
                  {if existing record keyd by taxyr,swis,rs & hstd cd}
                  {..update it with info from this parcel}

               with RTRS9TotalsPtr(TotalsByRS9List[TotIdx])^ do
                 begin
                   ParcelCount := ParcelCount +
                                  TotalsByRS9Table.FieldByName('ParcelCount').AsInteger;
                   Amount := Amount + TotalsByRS9Table.FieldByName('Amount').AsFloat;

                 end;  {with RTRS9TotalsPtr(TotalsByRS9List[TotIdx])^ do}

             end
           else
             begin
                 {Add a new entry.}

               New(RS9Ptr);

               with RS9Ptr^ do
                  begin
                   TaxRollYr := TotalsByRS9Table.FieldByName('TaxRollYr').Text;

                      {Only 4 dig of swis for grand totals}
                    {FXX12172001-2: Only do a take 2 on the swis code for villages
                                    that go across 2 towns.}

                    If TotalsOnly
                      then SwisCode := Take(2, TotalsByRS9Table.FieldByName('SwisCode').Text)
                      else SwisCode := TotalsByRS9Table.FieldByName('SwisCode').Text;

                    SDCode := TotalsByRS9Table.FieldByName('SDCode').Text;
                    ParcelCount := TotalsByRS9Table.FieldByName('ParcelCount').AsInteger;

                      {FXX11171997-6: Was being read AsInteger, but should be AsFloat.}

                    Amount := TotalsByRS9Table.FieldByName('Amount').AsFloat;

                  end;  {with RS9Ptr^ do}

               TotalsByRS9List.Add(RS9Ptr);

             end;  {else of If FoundSwisRS9Rec ...}

  until Done;

    {Now sort the display list.}

  SortRS9List(TotalsByRS9List);

end;  {LoadTotalsByRS9List}

{===================================================================}
{=====================  RS TOTALS ==================================}
{===================================================================}
Function FoundSwisCodeTotRec(    TotalsByRollSectionList : TList;
                                 TotalsByRollSectionTable : TTable;
                                 ShowHomesteadCodes,  {Do they want to see totals by homestead code?}
                                 TotalsOnly : Boolean;  {Are these totals by swis or overall?}
                             var TotIdx : Integer) : Boolean;

{See if this entry is already in the list. If so, return the indSwis.}

var
  I : Integer;

begin
  Result := False;

  For I := 0 to (TotalsByRollSectionList.Count - 1) do
    with RTSwisCodeTotalsPtr(TotalsByRollSectionList[I])^ do
      If ((Take(1, RollSection) = Take(1, TotalsByRollSectionTable.FieldByName('RollSection').Text)) and
           ((not ShowHomesteadCodes) or
            (Take(1, HomesteadCode) = Take(1, TotalsByRollSectionTable.FieldByName('HomesteadCode').Text))) and
           (TotalsOnly or
            (Take(6, SwisCode) = Take(6, TotalsByRollSectionTable.FieldByName('SwisCode').Text))))
        then
          begin
            TotIdx := I;
            Result := True;
          end;

end;  {FoundSwisCodeTotRec}

{==========================================================================================}
Procedure SortSwisList(TotalsByRollSectionList : TList);

{FXX11041997-5: Sort the totals.}
{FXX11071997-1: The length of the search key was wrong and it
                was not sorting by homestead code.}

var
  MainKey, NewKey : String;
  I, J : Integer;
  TempPtr : RTSwisCodeTotalsPtr;

begin
  For I := 0 to (TotalsByRollSectionList.Count - 1) do
    begin
      with RTSwisCodeTotalsPtr(TotalsByRollSectionList[I])^ do
        MainKey := Take(6, SwisCode) + Take(1, RollSection) + Take(1, HomesteadCode);

      For J := (I + 1) to (TotalsByRollSectionList.Count - 1) do
        begin
          with RTSwisCodeTotalsPtr(TotalsByRollSectionList[J])^ do
            NewKey := Take(6, SwisCode) + Take(1, RollSection) + Take(1, HomesteadCode);

          If (NewKey < MainKey)
            then
              begin
                TempPtr := TotalsByRollSectionList[I];
                TotalsByRollSectionList[I] := TotalsByRollSectionList[J];
                TotalsByRollSectionList[J] := TempPtr;
                MainKey := NewKey;

              end;  {If (NewKey < MainKey)}

        end;  {For J := (I + 1) to (TotalsByRollSectionList.Count - 1) do}

    end;  {For I := 0 to (TotalsByRollSectionList.Count - 1) do}

end;  {SortSwisList}

{=============================================================================}
Procedure LoadTotalsByRollSectionList(TotalsByRollSectionList : TList;
                                      TotalsByRollSectionTable : TTable;
                                      SelectedSwisCodes : TStringList;
                                      TotalsOnly,
                                      ShowHomesteadCodes : Boolean;
                                      TaxRollYear : String);

{Return a list with the Roll section totals.}

var
  Done, FirstTimeThrough : Boolean;
  SwisCodePtr : RTSwisCodeTotalsPtr;
  TotIdx : Integer;

begin
    {Go through all the Swis totals records.}

  Done := False;
  FirstTimeThrough := True;

  TotalsByRollSectionTable.IndexName := 'BYYEAR_SWIS_RS_HC';
  TotalsByRollSectionTable.First;

    {Fill the list.}

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else TotalsByRollSectionTable.Next;

   If TotalsByRollSectionTable.Eof
     then Done := True;

     {If they want overall totals or they want this swis code, then
      put it in the list.}

     {FXX11071997-1: Forgot to test for done condition.}
     {FXX10041999-7: Make sure to pass the year in for history load.}

   If ((not Done) and
       (TotalsByRollSectionTable.FieldByName('TaxRollYr').Text = TaxRollYear) and
       (*(TotalsOnly or*)
        (SelectedSwisCodes.IndexOf(TotalsByRollSectionTable.FieldByName('SwisCode').Text) <> -1))
     then
       If FoundSwisCodeTotRec(TotalsByRollSectionList, TotalsByRollSectionTable, ShowHomesteadCodes,
                              TotalsOnly, TotIdx)
          then
            begin
                 {if existing record keyd by taxyr,swis,rs & hstd cd}
                 {..update it with info from this parcel}

              with RTSwisCodeTotalsPtr(TotalsByRollSectionList[TotIdx])^ do
                begin
                     {FXX11071997-4: Display the parts amounts for split parcels.}

                  PartCount := PartCount +
                                 TotalsByRollSectionTable.FieldByName('PartCount').AsInteger;
                  ParcelCount := ParcelCount +
                                 TotalsByRollSectionTable.FieldByName('ParcelCount').AsInteger;

                    {FXX02101999-4: Add land value to swis and school totals.}

                  LandValue := LandValue +
                                   TotalsByRollSectionTable.FieldByName('LandValue').AsFloat;
                  AssessedValue := AssessedValue +
                                   TotalsByRollSectionTable.FieldByName('AssessedValue').AsFloat;
                  CountyTaxable := CountyTaxable +
                                   TotalsByRollSectionTable.FieldByName('CountyTaxable').AsFloat;
                  TownTaxable := TownTaxable +
                                 TotalsByRollSectionTable.FieldByName('TownTaxable').AsFloat;
                  VillageTaxable := VillageTaxable +
                                    TotalsByRollSectionTable.FieldByName('VillageTaxable').AsFloat;

                end;  {with RTSwisCodeTotalsPtr(TotalsByRollSectionList[TotIdx])^ do}

            end
          else
            begin
                {Add a new entry.}

              New(SwisCodePtr);

              with SwisCodePtr^ do
                begin
                  TaxRollYr := TotalsByRollSectionTable.FieldByName('TaxRollYr').Text;

                    {Only 4 dig of swis for grand totals}
                    {FXX12172001-2: Only do a take 2 on the swis code for villages
                                    that go across 2 towns.}

                  If TotalsOnly
                    then SwisCode := Take(2, TotalsByRollSectionTable.FieldByName('SwisCode').Text)
                    else SwisCode := TotalsByRollSectionTable.FieldByName('SwisCode').Text;

                    {If they do not want to see the homestead code, we will leave it
                     blank.}

                  If ShowHomesteadCodes
                    then HomesteadCode := TotalsByRollSectionTable.FieldByName('HomesteadCode').Text
                    else HomesteadCode := '';

                  RollSection := TotalsByRollSectionTable.FieldByName('RollSection').Text;

                     {FXX11071997-4: Display the parts amounts for split parcels.}

                  PartCount := TotalsByRollSectionTable.FieldByName('PartCount').AsInteger;
                  ParcelCount := TotalsByRollSectionTable.FieldByName('ParcelCount').AsInteger;

                    {FXX02101999-4: Add land value to swis and school totals.}

                  LandValue := TotalsByRollSectionTable.FieldByName('LandValue').AsFloat;
                  AssessedValue := TotalsByRollSectionTable.FieldByName('AssessedValue').AsFloat;
                  CountyTaxable := TotalsByRollSectionTable.FieldByName('CountyTaxable').AsFloat;
                  TownTaxable := TotalsByRollSectionTable.FieldByName('TownTaxable').AsFloat;
                  VillageTaxable := TotalsByRollSectionTable.FieldByName('VillageTaxable').AsFloat;

                end;  {with SwisCodePtr^ do}

              TotalsByRollSectionList.Add(SwisCodePtr);

            end;  {else of If FoundSwisSwisCodeRec ...}

  until Done;

    {Now sort the display list.}

  SortSwisList(TotalsByRollSectionList);

end;  {LoadTotalsByRollSectionList}

{CHG12091998-1:  Village relevy totals.}
{===================================================================}
{=============   VILLAGE RELEVY TOTALS =============================}
{===================================================================}
Function FoundVillageRelevyTotRec(    TotalsByVillageRelevyList : TList;
                                      TotalsByVillageRelevyTable : TTable;
                                      ShowHomesteadCodes,  {Do they want to see totals by homestead code?}
                                      TotalsOnly : Boolean;  {Are these totals by swis or overall?}
                                  var TotIdx : Integer) : Boolean;

{FXX11041997-1: VillageRelevy code totals should not have homestead code.}

{See if this entry is already in the list. If so, return the index.}

var
  I : Integer;

begin
  Result := False;

  For I := 0 to (TotalsByVillageRelevyList.Count - 1) do
    with RTVillageRelevyTotalsPtr(TotalsByVillageRelevyList[I])^ do
      If (((ShowHomesteadCodes and
            (Take(1, HomesteadCode) = Take(1, TotalsByVillageRelevyTable.FieldByName('HomesteadCode').Text))) or
           (not ShowHomesteadCodes)) and
          (TotalsOnly or
           (Take(6, SwisCode) = Take(6, TotalsByVillageRelevyTable.FieldByName('SwisCode').Text))))
        then
          begin
            TotIdx := I;
            Result := True;
          end;

end;  {FoundVillageRelevyTotRec}

{==========================================================================================}
Procedure SortVillageRelevyList(TotalsByVillageRelevyList : TList);

{FXX11041997-5: Sort the VillageRelevy totals by swis\VillageRelevy\extension}

var
  MainKey, NewKey : String;
  I, J : Integer;
  TempPtr : RTVillageRelevyTotalsPtr;

begin
  For I := 0 to (TotalsByVillageRelevyList.Count - 1) do
    begin
      with RTVillageRelevyTotalsPtr(TotalsByVillageRelevyList[I])^ do
        MainKey := Take(6, SwisCode) + Take(1, HomesteadCode);

      For J := (I + 1) to (TotalsByVillageRelevyList.Count - 1) do
        begin
          with RTVillageRelevyTotalsPtr(TotalsByVillageRelevyList[J])^ do
            NewKey := Take(6, SwisCode) + Take(1, HomesteadCode);

          If (NewKey < MainKey)
            then
              begin
                TempPtr := TotalsByVillageRelevyList[I];
                TotalsByVillageRelevyList[I] := TotalsByVillageRelevyList[J];
                TotalsByVillageRelevyList[J] := TempPtr;
                MainKey := NewKey;

              end;  {If (NewKey < MainKey)}

        end;  {For J := (I + 1) to (TotalsByVillageRelevyList.Count - 1) do}

    end;  {For I := 0 to (TotalsByVillageRelevyList.Count - 1) do}

end;  {SortVillageRelevyList}

{=============================================================================}
Procedure LoadTotalsByVillageRelevyList(TotalsByVillageRelevyList : TList;
                                        TotalsByVillageRelevyTable : TTable;
                                        SelectedSwisCodes : TStringList;
                                        TotalsOnly,
                                        ShowHomesteadCodes : Boolean;
                                        TaxRollYear : String);

{Return a list with the VillageRelevy totals.}

var
  VillageRelevyPtr : RTVillageRelevyTotalsPtr;
  FirstTimeThrough, Done : Boolean;
  TotIdx : Integer;

begin
    {Go through all the VillageRelevy totals records.}

  Done := False;
  FirstTimeThrough := True;

  TotalsByVillageRelevyTable.IndexName := 'BYYEAR_SWIS_HC';
  TotalsByVillageRelevyTable.First;

    {Fill the list.}

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else TotalsByVillageRelevyTable.Next;

    If TotalsByVillageRelevyTable.EOF
      then Done := True;

     {If they want overall totals or they want this swis code, then
      put it in the list.}
     {FXX10041999-7: Make sure to pass the year in for history load.}

   If ((not Done) and
       (TotalsByVillageRelevyTable.FieldByName('TaxRollYr').Text = TaxRollYear) and
       (SelectedSwisCodes.IndexOf(TotalsByVillageRelevyTable.FieldByName('SwisCode').Text) <> -1))
     then
       If FoundVillageRelevyTotRec(TotalsByVillageRelevyList, TotalsByVillageRelevyTable, ShowHomesteadCodes,
                                   TotalsOnly, TotIdx)
          then
            begin
                 {if existing record keyd by taxyr,swis,rs & hstd cd}
                 {..update it with info from this parcel}

              with RTVillageRelevyTotalsPtr(TotalsByVillageRelevyList[TotIdx])^ do
                begin
                  RelevyCount := RelevyCount +
                                 TotalsByVillageRelevyTable.FieldByName('VillageRelevyCount').AsInteger;
                  RelevyAmount := RelevyAmount +
                                  TotalsByVillageRelevyTable.FieldByName('VillageRelevyAmount').AsFloat;

                end;  {with RTVillageRelevyTotalsPtr(TotalsByVillageRelevyList[TotIdx])^ do}

            end
          else
            begin
                {Add a new entry.}

              New(VillageRelevyPtr);

              with VillageRelevyPtr^ do
                begin
                  TaxRollYr := TotalsByVillageRelevyTable.FieldByName('TaxRollYr').Text;

                    {Only 4 dig of swis for grand totals}
                    {FXX12172001-2: Only do a take 2 on the swis code for villages
                                    that go across 2 towns.}

                  If TotalsOnly
                    then SwisCode := Take(2, TotalsByVillageRelevyTable.FieldByName('SwisCode').Text)
                    else SwisCode := TotalsByVillageRelevyTable.FieldByName('SwisCode').Text;

                    {If they do not want to see the homestead code, we will leave it
                     blank.}

                  If ShowHomesteadCodes
                    then HomesteadCode := TotalsByVillageRelevyTable.FieldByName('HomesteadCode').Text
                    else HomesteadCode := '';

                  RelevyCount := TotalsByVillageRelevyTable.FieldByName('VillageRelevyCount').AsInteger;
                  RelevyAmount := TotalsByVillageRelevyTable.FieldByName('VillageRelevyAmount').AsFloat;

                end;  {with VillageRelevyPtr^ do}

              TotalsByVillageRelevyList.Add(VillageRelevyPtr);

            end;  {else of If FoundSwisVillageRelevyRec ...}

  until Done;

    {Now sort the display list.}

  SortVillageRelevyList(TotalsByVillageRelevyList);

end;  {LoadTotalsByVillageRelevyList}

{==============================================================}
Procedure AdjustRollTotalsForParcel_New(    AssessmentYear : String;
                                            ProcessingType : Integer;
                                            SwisSBLKey : String;
                                        var EXAmounts : ExemptionTotalsArrayType;
                                            AdjustmentTypeSet : Charset;  {Adjust (S)wis, s(C)hool, (E)xemption, s(D)}
                                            Mode : Char);  {(D)elete, (A)dd}

var
  HstdLandVal, NonhstdLandVal,
  HstdAssessedVal, NonhstdAssessedVal : Comp;

  HstdAcres, NonhstdAcres : Real;
  AssessmentRecordFound, ClassRecordFound : Boolean;

  ExemptionCodeTable, ExemptionTable,
  ClassTable, ParcelTable, AssessmentTable,
  SDCodeTable, ParcelSDTable : TTable;

  ExemptionCodes,
  ExemptionHomesteadCodes,
  ResidentialTypes,
  CountyExemptionAmounts,
  TownExemptionAmounts,
  SchoolExemptionAmounts,
  VillageExemptionAmounts : TStringList;
  SDAmounts : TList;
  BasicSTARAmount, EnhancedSTARAmount : Comp;
  SBLRec : SBLRecord;

begin
  ExemptionCodes := TStringList.Create;
  ExemptionHomesteadCodes := TStringList.Create;
  ResidentialTypes := TStringList.Create;
  CountyExemptionAmounts := TStringList.Create;
  TownExemptionAmounts := TStringList.Create;
  SchoolExemptionAmounts := TStringList.Create;
  VillageExemptionAmounts := TStringList.Create;
  SDAmounts := TList.Create;

  ExemptionCodeTable := FindTableInDataModuleForProcessingType(DataModuleExemptionCodeTableName,
                                                               ProcessingType);
  ExemptionTable := FindTableInDataModuleForProcessingType(DataModuleExemptionTableName,
                                                           ProcessingType);
  SDCodeTable := FindTableInDataModuleForProcessingType(DataModuleSpecialDistrictCodeTableName,
                                                        ProcessingType);
  ParcelSDTable := FindTableInDataModuleForProcessingType(DataModuleSpecialDistrictTableName,
                                                          ProcessingType);
  ParcelTable := FindTableInDataModuleForProcessingType(DataModuleParcelTableName,
                                                        ProcessingType);
  ClassTable := FindTableInDataModuleForProcessingType(DataModuleClassTableName,
                                                       ProcessingType);
  AssessmentTable := FindTableInDataModuleForProcessingType(DataModuleAssessmentTableName,
                                                            ProcessingType);

  FindKeyOld(AssessmentTable, ['TaxRollYr', 'SwisSBLKey'],
             [AssessmentYear, SwisSBLKey]);

  SBLRec := ExtractSwisSBLFromSwisSBLKey(SwisSBLKey);

  with SBLRec do
    FindKeyOld(ParcelTable,
               ['TaxRollYr', 'SwisCode', 'Section', 'Subsection',
                'Block', 'Lot', 'Sublot', 'Suffix'],
               [AssessmentYear, SwisCode, Section, SubSection,
                Block, Lot, Sublot, Suffix]);

  CalculateHstdAndNonhstdAmounts(AssessmentYear,
                                 SwisSBLKey,
                                 AssessmentTable,
                                 ClassTable,
                                 ParcelTable,
                                 HstdAssessedVal,
                                 NonhstdAssessedVal,
                                 HstdLandVal, NonhstdLandVal,
                                 HstdAcres, NonhstdAcres,
                                 AssessmentRecordFound,
                                 ClassRecordFound);

  EXAmounts := TotalExemptionsForParcel(AssessmentYear, SwisSBLKey,
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

  ClearTList(SDAmounts, SizeOf(ParcelSDValuesRecord));

  TotalSpecialDistrictsForParcel(AssessmentYear,
                                 SwisSBLKey,
                                 ParcelTable,
                                 AssessmentTable,
                                 ParcelSDTable,
                                 SDCodeTable,
                                 ExemptionTable,
                                 ExemptionCodeTable,
                                 SDAmounts);

  AdjustRollTotalsForParcel(AssessmentYear,
                            ParcelTable.FieldByName('SwisCode').Text,
                            ParcelTable.FieldByName('SchoolCode').Text,
                            ParcelTable.FieldByName('HomesteadCode').Text,
                            ParcelTable.FieldByName('RollSection').Text,
                            HstdLandVal, NonhstdLandVal,
                            HstdAssessedVal,
                            NonhstdAssessedVal,
                            ExemptionCodes,
                            ExemptionHomesteadCodes,
                            CountyExemptionAmounts,
                            TownExemptionAmounts,
                            SchoolExemptionAmounts,
                            VillageExemptionAmounts,
                            ParcelTable,
                            BasicSTARAmount,
                            EnhancedSTARAmount,
                            SDAmounts,
                            ['S', 'C', 'E', 'D'],  {Adjust swis, school, exemption, sd}
                            Mode);

  ExemptionCodes.Free;
  ExemptionHomesteadCodes.Free;
  ResidentialTypes.Free;
  CountyExemptionAmounts.Free;
  TownExemptionAmounts.Free;
  SchoolExemptionAmounts.Free;
  VillageExemptionAmounts.Free;
  ClearTList(SDAmounts, SizeOf(ParcelSDValuesRecord));
  FreeTList(SDAmounts, SizeOf(ParcelSDValuesRecord));

end;  {AdjustRollTotalsForParcel_New}


end.