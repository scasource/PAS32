unit UtilEstimatedTaxComputation;

interface

uses Classes, PASTypes, DBTables, DataAccessUnit, WinUtils, Utilitys,
     GlblCnst, SysUtils;

Function GetProjectedTaxInformation(HomesteadAssessedValue : LongInt;
                                    NonHomesteadAssessedValue : LongInt;
                                    SwisSBLKey : String;
                                    SchoolCode : String;
                                    TaxInformationList : TList;
                                    LeviesToInclude : TLevyTypeSet;
                                    TaxTotalType : TTaxRateType;
                                    IncludeExemptions : Boolean) : Double;

implementation

type
  CollectionHeaderInformationRecord = record
    AssessmentYear : String;
    CollectionType : String;
    CollectionNumber : Integer;
    SchoolCode : String;
    LevyType : TLevyTypes;
  end;

  CollectionHeaderInformationPointer = ^CollectionHeaderInformationRecord;

{=================================================================}
Procedure AddCollectionHeaderPointerInformation(CollectionHeaderInformationPtr : CollectionHeaderInformationPointer;
                                                CollectionHeaderTable : TTable;
                                                _SchoolCode : String;
                                                _LevyType : TLevyTypes;
                                                CollectionHeaderInformationList : TList);

begin
  with CollectionHeaderInformationPtr^, CollectionHeaderTable do
    begin
      AssessmentYear := FieldByName('TaxRollYr').Text;
      CollectionType := FieldByName('CollectionType').Text;
      CollectionNumber := FieldByName('CollectionNo').AsInteger;
      SchoolCode := _SchoolCode;
      LevyType := _LevyType;

    end;  {with CollectionHeaderInformationPtr^ ...}

  CollectionHeaderInformationList.Add(CollectionHeaderInformationPtr);

end;  {AddCollectionHeaderPointerInformation}

{=================================================================}
Procedure FillCollectionHeaderInformationList(CollectionHeaderTable : TTable;
                                              CollectionDetailTable : TTable;
                                              CollectionHeaderInformationList : TList);

var
  Done, FirstTimeThrough : Boolean;
  SchoolCollectionFound, TownCollectionFound : Boolean;
  SchoolCollectionYear, SchoolCode, CollectionType : String;
  CollectionHeaderInformationPtr : CollectionHeaderInformationPointer;

begin
  CollectionHeaderTable.Last;
  SchoolCollectionYear := '';
  SchoolCollectionFound := False;
  TownCollectionFound := False;
  Done := False;
  FirstTimeThrough := True;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else CollectionHeaderTable.Prior;

    If CollectionHeaderTable.BOF
      then Done := True;

    If not Done
      then
        begin
          CollectionType := CollectionHeaderTable.FieldByName('CollectionType').Text;

          If ((not TownCollectionFound) and
              ((CollectionType = 'MU') or
               (CollectionType = 'TO')))
            then
              begin
                TownCollectionFound := True;

                New(CollectionHeaderInformationPtr);

                AddCollectionHeaderPointerInformation(CollectionHeaderInformationPtr,
                                                      CollectionHeaderTable,
                                                      '', ltMunicipal,
                                                      CollectionHeaderInformationList);

              end;  {If ((not TownCollectionFound) and ...}

          If ((CollectionType = 'SC') and
              ((not SchoolCollectionFound) or
               (CollectionHeaderTable.FieldByName('TaxRollYr').Text = SchoolCollectionYear)))
            then
              begin
                SchoolCollectionFound := True;
                SchoolCollectionYear := CollectionHeaderTable.FieldByName('TaxRollYr').Text;
                SchoolCode := '';

                with CollectionHeaderTable do
                  If _Locate(CollectionDetailTable,
                             [FieldByName('TaxRollYr').Text,
                              CollectionType,
                              FieldByName('CollectionNo').AsInteger], '', [])
                    then SchoolCode := CollectionDetailTable.FieldByName('SchoolCode').Text;

                New(CollectionHeaderInformationPtr);

                AddCollectionHeaderPointerInformation(CollectionHeaderInformationPtr,
                                                      CollectionHeaderTable,
                                                      SchoolCode, ltSchool,
                                                      CollectionHeaderInformationList);

              end;  {If ((not TownCollectionFound) and ...}

        end;  {If not Done}

  until Done;

end;  {FillCollectionHeaderInformationList}

{=================================================================}
Function FindCollectionHeaderInformationForLevy(CollectionHeaderInformationList : TList;
                                                _LevyType : TLevyTypes;
                                                _SchoolCode : String) : Integer;

var
  I : Integer;

begin
  Result := -1;

  For I := 0 to (CollectionHeaderInformationList.Count - 1) do
    with CollectionHeaderInformationPointer(CollectionHeaderInformationList[I])^ do
      If ((_LevyType = LevyType) and
          ((_LevyType <> ltSchool) or
           _Compare(_SchoolCode, SchoolCode, coEqual)))
        then Result := I;

end;  {FindCollectionHeaderInformationForLevy}

{=================================================================}
Function GetTaxRateTypeDescription(_TaxRateType : TTaxRateType) : String;

begin
  Result := '';

  case _TaxRateType of
    trAny,
    trPerThousand : Result := 'per thousand';
    trPerUnit : Result := 'per unit';
    trPerSecondaryUnit : Result := 'per 2nd unit';

  end;  {case _TaxRateType of}

end;  {GetTaxRateTypeDescription}

{=================================================================}
Function AddOneTaxInformationPointer(TaxInformationList : TList;
                                     _LevyCode : String;
                                     _LevyDescription : String;
                                     _HomesteadCode : String;
                                     _TaxableValue : Double;
                                     _TaxRate : Double;
                                     _ExtensionCode : String;
                                     _TaxRateType : TTaxRateType) : Double;

var
  TaxInformationPtr : TaxInformationPointer;

begin
  Result := 0;
  case _TaxRateType of
    trPerThousand : Result := ((_TaxableValue / 1000) * _TaxRate);
    trPerUnit,
    trPerSecondaryUnit : Result := (_TaxableValue * _TaxRate);

  end;  {case _TaxRateType of}

  Result := Roundoff(Result, 2);

  New(TaxInformationPtr);

  with TaxInformationPtr^ do
    begin
      LevyCode := _LevyCode;
      LevyDescription := ANSIUpperCase(_LevyDescription);
      HomesteadCode := _HomesteadCode;
      ExtensionCode := _ExtensionCode;
      TaxableValue := _TaxableValue;
      TaxRate := _TaxRate;
      TaxRateType := _TaxRateType;
      TaxRateDescription := GetTaxRateTypeDescription(_TaxRateType);
      TaxAmount := Result;

    end;  {with TaxInformationPtr^ do}

  TaxInformationList.Add(TaxInformationPtr);

end;  {AddOneTaxInformationPointer}

{=================================================================}
Function AddTaxInformation(TaxInformationList : TList;
                           _LevyCode : String;
                           _LevyDescription : String;
                           _HomesteadTaxableValue : Double;
                           _NonHomesteadTaxableValue : Double;
                           _HomesteadRate : Double;
                           _NonHomesteadRate : Double;
                           _ExtensionCode : String;
                           _TaxRateType : TTaxRateType) : Double;

begin
  Result := 0;

  If _Compare(_HomesteadTaxableValue, 0, coGreaterThan)
    then Result := Result +
                   AddOneTaxInformationPointer(TaxInformationList,
                                               _LevyCode,
                                               _LevyDescription,
                                               'H',
                                               _HomesteadTaxableValue,
                                               _HomesteadRate,
                                               _ExtensionCode,
                                               _TaxRateType);

  If _Compare(_NonHomesteadTaxableValue, 0, coGreaterThan)
    then Result := Result +
                   AddOneTaxInformationPointer(TaxInformationList,
                                               _LevyCode,
                                               _LevyDescription,
                                               'N',
                                               _NonHomesteadTaxableValue,
                                               _NonHomesteadRate,
                                               _ExtensionCode,
                                               _TaxRateType);

end;  {AddTaxInformation}

{=================================================================}
Function LevyTypeShouldBeIncluded(LeviesToInclude : TLevyTypeSet;
                                  ThisLevyType : String) : Boolean;

begin
  Result := False;

  If (ltAll in LeviesToInclude)
    then Result := True
    else
      begin
        If ((ThisLevyType = 'CO') and
            ((ltCounty in LeviesToInclude) or
             (ltMunicipal in LeviesToInclude)))
          then Result := True;

        If ((ThisLevyType = 'TO') and
            ((ltTown in LeviesToInclude) or
             (ltMunicipal in LeviesToInclude)))
          then Result := True;

        If ((ThisLevyType = 'VI') and
            ((ltVillage in LeviesToInclude) or
             (ltMunicipal in LeviesToInclude)))
          then Result := True;

        If ((ThisLevyType = 'SC') and
            (ltSchool in LeviesToInclude))
          then Result := True;

        If ((ThisLevyType = 'UN') and
            ((ltUnitarySpecialDistrict in LeviesToInclude) or
             (not (ltNoUnitary in LeviesToInclude))))
          then Result := True;

        If ((ThisLevyType = 'TO') and
            ((ltAdValorumSpecialDistrict in LeviesToInclude) or
             (ltNoUnitary in LeviesToInclude)))
          then Result := True;

        If (_Compare(ThisLevyType, 'FE', coEqual) and
            (ltFlatFeeDistrict in LeviesToInclude))
          then Result := True;

      end;  {else of If (ltAll in LeviesToInclude)}

end;  {LevyTypeShouldBeIncluded}

{=================================================================}
Function ComputeTaxForCollectionType(GeneralRateTable : TTable;
                                     SpecialDistrictRateTable : TTable;
                                     SpecialDistrictTable : TTable;
                                     AssessmentYear : String;
                                     CollectionType : String;
                                     CollectionNumber : Integer;
                                     HomesteadAssessedValue : LongInt;
                                     NonHomesteadAssessedValue : LongInt;
                                     SwisSBLKey : String;
                                     TaxInformationList : TList;
                                     LeviesToInclude : TLevyTypeSet;
                                     TaxTotalType : TTaxRateType;
                                     tb_SchoolCode : TTable) : Double;

var
  Done, FirstTimeThrough : Boolean;
  TaxAmount, Units : Double;
  ExtensionCode, TempDescription : String;

begin
  Result := 0;
  Done := False;
  FirstTimeThrough := True;

    {Now go through the base tax rates for this collection.}

  _SetRange(GeneralRateTable, [AssessmentYear, CollectionType, CollectionNumber, 1],
            [AssessmentYear, CollectionType, CollectionNumber, 9999], '', []);

  GeneralRateTable.First;

  with GeneralRateTable do
    repeat
      If FirstTimeThrough
        then FirstTimeThrough := False
        else Next;

      If EOF
        then Done := True;

      If ((not Done) and
          _Compare(FieldByName('SwisCode').Text,
                   Copy(SwisSBLKey, 1, 6), coMatchesPartialOrFirstItemBlank) and
          LevyTypeShouldBeIncluded(LeviesToInclude, FieldByName('GeneralTaxType').Text))
      then
        begin
          TempDescription := FieldByName('Description').Text;

          If _Compare(FieldByName('GeneralTaxType').AsString, 'SC', coEqual)
            then
              begin
                _Locate(tb_SchoolCode, [FieldByName('SchoolCode').AsString], '', []);
                TempDescription := UpperCaseFirstChars(LowerCase(tb_SchoolCode.FieldByName('SchoolName').AsString)) + ' School Tax';
              end;

          TaxAmount := AddTaxInformation(TaxInformationList,
                                         FieldByName('GeneralTaxType').Text,
                                         FieldByName('Description').Text,
                                         HomesteadAssessedValue,
                                         NonhomesteadAssessedValue,
                                         FieldByName('HomesteadRate').AsFloat,
                                         FieldByName('NonHomesteadRate').AsFloat,
                                         'TO', trPerThousand);

          If (TaxTotalType in [trAny, trPerThousand])
            then Result := Result + TaxAmount;

        end;  {If not Done}

    until Done;

    {Now go through the special district tax rates for this collection.}

  Done := False;
  FirstTimeThrough := True;

  _SetRange(SpecialDistrictRateTable, [AssessmentYear, CollectionType, CollectionNumber, '', '', ''],
            [AssessmentYear, CollectionType, CollectionNumber, 'zzzzz', '', ''], '', []);

  SpecialDistrictRateTable.First;

  with SpecialDistrictRateTable do
    repeat
      If FirstTimeThrough
        then FirstTimeThrough := False
        else Next;

      If EOF
        then Done := True;

      If ((not Done) and
          (_Compare(FieldByName('HomesteadRate').AsFloat, 0, coNotEqual) or
           _Compare(FieldByName('NonHomesteadRate').AsFloat, 0, coNotEqual)) and
          _Locate(SpecialDistrictTable, [SpecialDistrictTable.FieldByName('TaxRollYr').AsString,
                                         SwisSBLKey, FieldByName('SDistCode').Text], '', []) and
          LevyTypeShouldBeIncluded(LeviesToInclude, FieldByName('ExtCode').Text))
        then
          begin
            ExtensionCode := FieldByName('ExtCode').Text;

            If _Compare(ExtensionCode, SDistEcTO, coEqual)
              then
                begin
                  TaxAmount := AddTaxInformation(TaxInformationList,
                                                 FieldByName('SDistCode').Text,
                                                 FieldByName('SDistDescr').Text,
                                                 HomesteadAssessedValue,
                                                 NonhomesteadAssessedValue,
                                                 FieldByName('HomesteadRate').AsFloat,
                                                 FieldByName('NonHomesteadRate').AsFloat,
                                                 ExtensionCode, trPerThousand);

                  If (TaxTotalType in [trAny, trPerThousand])
                    then Result := Result + TaxAmount;

                end;  {If _Compare(ExtensionCode, SDistEcTO, coEqual)}

            If (_Compare(ExtensionCode, SDistEcUN, coEqual) or
                _Compare(ExtensionCode, SDistEcSU, coEqual))
              then
                begin
                  with SpecialDistrictTable do
                    If _Compare(ExtensionCode, SDistEcUN, coEqual)
                      then Units := FieldByName('PrimaryUnits').AsFloat
                      else Units := FieldByName('SecondaryUnits').AsFloat;

                    {FXX08012007-1(2.11.2.11)[D948] : Include fixed expense districts.}
                    
                  If _Compare(ExtensionCode, SDistEcFE, coEqual)
                    then Units := 1;

                  TaxAmount := AddTaxInformation(TaxInformationList,
                                                 FieldByName('SDistCode').Text,
                                                 FieldByName('SDistDescr').Text,
                                                 Units, 0,
                                                 FieldByName('HomesteadRate').AsFloat,
                                                 FieldByName('NonHomesteadRate').AsFloat,
                                                 ExtensionCode, trPerUnit);

                  If (TaxTotalType in [trAny, trPerUnit])
                    then Result := Result + TaxAmount;

                end;  {If _Compare(ExtensionCode, SDistEcTO, coEqual)}

          end;  {If ((not Done) and ...}

    until Done;

end;  {ComputeTaxForCollectionType}

{=================================================================}
Function GetProjectedTaxInformation(HomesteadAssessedValue : LongInt;
                                    NonHomesteadAssessedValue : LongInt;
                                    SwisSBLKey : String;
                                    SchoolCode : String;
                                    TaxInformationList : TList;
                                    LeviesToInclude : TLevyTypeSet;
                                    TaxTotalType : TTaxRateType;
                                    IncludeExemptions : Boolean) : Double;

var
  SpecialDistrictTable, tb_SchoolCode,
  GeneralRateTable, SpecialDistrictRateTable,
  CollectionHeaderTable, CollectionDetailTable : TTable;
  CollectionHeaderInformationList : TList;
  Index : Integer;

begin
  Result := 0;
  CollectionHeaderInformationList := TList.Create;
  ClearTList(TaxInformationList, SizeOf(TaxInformationRecord));

    {Create and open bill rate tables.}

  GeneralRateTable := TTable.Create(nil);
  SpecialDistrictRateTable := TTable.Create(nil);
  CollectionHeaderTable := TTable.Create(nil);
  CollectionDetailTable := TTable.Create(nil);
  SpecialDistrictTable := TTable.Create(nil);
  tb_SchoolCode := TTable.Create(nil);

  _OpenTable(SpecialDistrictTable, SpecialDistrictTableName, '',
             'BYTAXROLLYR_SWISSBLKEY_SD', ThisYear, []);
  _OpenTable(GeneralRateTable, BillGeneralRateTableName, '',
             'BYYEAR_COLLTYPE_NUM_ORDER', NoProcessingType, []);
  _OpenTable(SpecialDistrictRateTable, BillSpecialDistrictRateTableName, '',
             'BYYEAR_TYPE_NUM_SD_EX_CM', NoProcessingType, []);
  _OpenTable(CollectionHeaderTable, BillControlHeaderTableName, '',
             'BYYEAR_COLLTYPE_NUM', NoProcessingType, []);
  _OpenTable(CollectionDetailTable, BillControlDetailTableName, '',
             'BYYEAR_COLLTYPE_NUM', NoProcessingType, []);
  _OpenTable(tb_SchoolCode, SchoolCodeTableName, '',
             'BYSCHOOLCODE', ThisYear, []);

    {Figure out which collection goes with which school.}

  FillCollectionHeaderInformationList(CollectionHeaderTable, CollectionDetailTable,
                                      CollectionHeaderInformationList);

    {Find the most recent tax header record for town.}

  Index := FindCollectionHeaderInformationForLevy(CollectionHeaderInformationList, ltMunicipal, '');

  with CollectionHeaderInformationPointer(CollectionHeaderInformationList[Index])^ do
    Result := Result +
              ComputeTaxForCollectionType(GeneralRateTable, SpecialDistrictRateTable, SpecialDistrictTable,
                                          AssessmentYear, CollectionType, CollectionNumber,
                                          HomesteadAssessedValue, NonHomesteadAssessedValue,
                                          SwisSBLKey, TaxInformationList,
                                          LeviesToInclude, TaxTotalType,
                                          tb_SchoolCode);

    {Now do the school.}

  Index := FindCollectionHeaderInformationForLevy(CollectionHeaderInformationList, ltSchool, SchoolCode);

  with CollectionHeaderInformationPointer(CollectionHeaderInformationList[Index])^ do
    Result := Result +
              ComputeTaxForCollectionType(GeneralRateTable, SpecialDistrictRateTable, SpecialDistrictTable,
                                          AssessmentYear, CollectionType, CollectionNumber,
                                          HomesteadAssessedValue, NonHomesteadAssessedValue,
                                          SwisSBLKey, TaxInformationList,
                                          LeviesToInclude, TaxTotalType,
                                          tb_SchoolCode);

  GeneralRateTable.Close;
  SpecialDistrictRateTable.Close;
  CollectionHeaderTable.Close;
  CollectionDetailTable.Close;
  SpecialDistrictTable.Close;
  tb_SchoolCode.Close;

  GeneralRateTable.Free;
  SpecialDistrictRateTable.Free;
  CollectionHeaderTable.Free;
  CollectionDetailTable.Free;
  SpecialDistrictTable.Free;
  tb_SchoolCode.Free;

end;  {GetProjectedTaxInformation}

end.
