unit GrievanceUtilitys;

interface

uses DB, DBTables, Tabs, Classes, Dialogs, SysUtils, Windows, PASTypes, RPBase,
     RPDBUtil, RPDefine;

Procedure SetPetitionerNameAndAddress(MainTable : TTable;
                                      LawyerCodeTable : TTable;
                                      LawyerCode : String);

Procedure SetAttorneyNameAndAddress(MainTable : TTable;
                                    LawyerCodeTable : TTable;
                                    LawyerCode : String);

Function DetermineGrievanceYear : String;

Procedure DetermineGrantedValues(    GrievanceResultsTable : TTable;
                                 var GrantedLandValue : LongInt;
                                 var GrantedTotalValue : LongInt;
                                 var GrantedExemptionAmount : LongInt;
                                 var GrantedExemptionPercent : Double;
                                 var GrantedExemptionCode : String);

Procedure MoveGrantedValuesToMainParcel(OrigGrantedLandValue : LongInt;
                                        OrigGrantedTotalValue : LongInt;
                                        OrigGrantedExemptionAmount : LongInt;
                                        OrigGrantedExemptionPercent : Double;
                                        OrigGrantedExemptionCode : String;
                                        NewGrantedLandValue : LongInt;
                                        NewGrantedTotalValue : LongInt;
                                        NewGrantedExemptionAmount : LongInt;
                                        NewGrantedExemptionPercent : Double;
                                        NewGrantedExemptionCode : String;
                                        GrievanceProcessingType : Integer;
                                        SwisSBLKey : String;
                                        GrievanceYear : String;
                                        ParcelTabSet : TTabSet;
                                        TabTypeList : TStringList;
                                        GrievanceNumber : Integer;
                                        ResultNumber : Integer;
                                        Disposition : String;
                                        DecisionDate : String;
                                        UpdatedInBulkJob : Boolean;
                                        ShowMessage : Boolean;
                                        AutomaticallyMoveWhollyExemptsToRS8 : Boolean;
                                        FreezeAssessment : Boolean;
                                    var NowWhollyExempt : Boolean;
                                    var Updated : Boolean;
                                    var ErrorMessage : String;
                                    var LandValueChange : Comp;
                                    var TotalValueChange : Comp;
                                    var CountyTaxableChange : Comp;
                                    var TownTaxableChange : Comp;
                                    var SchoolTaxableChange : Comp;
                                    var VillageTaxableChange : Comp);

Function GetGrievanceStatus(    GrievanceTable : TTable;
                                GrievanceExemptionsAskedTable : TTable;
                                GrievanceResultsTable : TTable;
                                GrievanceDispositionCodeTable : TTable;
                                GrievanceYear : String;
                                SwisSBLKey : String;
                                ShortDescription : Boolean;
                            var StatusStr : String) : Integer;

Function GetGrievanceNumberToDisplay(GrievanceTable : TTable) : String;

Function GetCert_Or_SmallClaimStatus(    Table : TTable;
                                     var StatusCode : Integer) : String;

Function CopyGrievanceToCert_Or_SmallClaim(IndexNumber : LongInt;
                                           GrievanceNumber : Integer;
                                           CurrentYear : String;
                                           PriorYear : String;
                                           SwisSBLKey : String;
                                           LawyerCode : String;
                                           NumberOfParcels : Integer;
                                           GrievanceTable,
                                           DestinationTable,
                                           LawyerCodeTable,
                                           ParcelTable,
                                           CurrentAssessmentTable,
                                           PriorAssessmentTable,
                                           SwisCodeTable,
                                           PriorSwisCodeTable,
                                           CurrentExemptionsTable,
                                           DestinationExemptionsTable,
                                           CurrentSpecialDistrictsTable,
                                           DestinationSpecialDistrictsTable,
                                           CurrentSalesTable,
                                           DestinationSalesTable,
                                           GrievanceExemptionsAskedTable,
                                           DestinationExemptionsAskedTable,
                                           GrievanceResultsTable,
                                           GrievanceDispositionCodeTable : TTable;
                                           Source : Char {(C)ert or (S)mall claim}) : Boolean;

Function IsGrievance_SmallClaims_CertiorariScreen(ScreenName : String) : Boolean;

Function UserCanViewGrievance_SmallClaims_CertiorariInformation(ScreenName : String) : Boolean;

Procedure InitGrievanceTotalsRecord(var TotalsRec : GrievanceTotalsRecord);

Procedure UpdateSmallClaims_Certiorari_TotalsRecord(var TotalsRec : GrievanceTotalsRecord;
                                                        Status : Integer);

Procedure UpdateGrievanceTotalsRecord(var TotalsRec : GrievanceTotalsRecord;
                                           Status : Integer);

Procedure PrintGrievanceTotals(Sender : TObject;
                               TotalsRec : GrievanceTotalsRecord);

Function ParcelHasOpenCertiorari(tbCertiorari : TTable;
                                 sSwisSBLKey : String) : Boolean;

implementation

uses
  Types, Utilitys, PASUtils, GlblCnst, GlblVars, WinUtils,
  UtilRTot, UtilEXSD, UtilPRCL, DataAccessUnit;

{===============================================================}
Procedure SetPetitionerNameAndAddress(MainTable : TTable;
                                      LawyerCodeTable : TTable;
                                      LawyerCode : String);

begin
  If FindKeyOld(LawyerCodeTable, ['Code'], [LawyerCode])
    then
      begin
        MainTable.FieldByName('PetitName1').Text := LawyerCodeTable.FieldByName('Name1').Text;
        MainTable.FieldByName('PetitName2').Text := LawyerCodeTable.FieldByName('Name2').Text;
        MainTable.FieldByName('PetitAddress1').Text := LawyerCodeTable.FieldByName('Address1').Text;
        MainTable.FieldByName('PetitAddress2').Text := LawyerCodeTable.FieldByName('Address2').Text;
        MainTable.FieldByName('PetitStreet').Text := LawyerCodeTable.FieldByName('Street').Text;
        MainTable.FieldByName('PetitCity').Text := LawyerCodeTable.FieldByName('City').Text;
        MainTable.FieldByName('PetitState').Text := LawyerCodeTable.FieldByName('State').Text;
        MainTable.FieldByName('PetitZip').Text := LawyerCodeTable.FieldByName('Zip').Text;
        MainTable.FieldByName('PetitZipPlus4').Text := LawyerCodeTable.FieldByName('ZipPlus4').Text;
        MainTable.FieldByName('PetitPhoneNumber').Text := LawyerCodeTable.FieldByName('PhoneNumber').Text;

        try
          MainTable.FieldByName('PetitFaxNumber').Text := LawyerCodeTable.FieldByName('FaxNumber').Text;
          MainTable.FieldByName('PetitAttorneyName').Text := LawyerCodeTable.FieldByName('AttorneyName').Text;
          MainTable.FieldByName('PetitEmail').Text := LawyerCodeTable.FieldByName('Email').Text;
        except
        end;

      end
    else MessageDlg('Error finding lawyer code ' + LawyerCode + '.', mtError, [mbOK], 0);

end;  {SetPetitionerNameAndAddress}

{===============================================================}
Procedure SetAttorneyNameAndAddress(MainTable : TTable;
                                    LawyerCodeTable : TTable;
                                    LawyerCode : String);

begin
  If FindKeyOld(LawyerCodeTable, ['Code'], [LawyerCode])
    then
      begin
        MainTable.FieldByName('AttyName1').Text := LawyerCodeTable.FieldByName('Name1').Text;
        MainTable.FieldByName('AttyName2').Text := LawyerCodeTable.FieldByName('Name2').Text;
        MainTable.FieldByName('AttyAddress1').Text := LawyerCodeTable.FieldByName('Address1').Text;
        MainTable.FieldByName('AttyAddress2').Text := LawyerCodeTable.FieldByName('Address2').Text;
        MainTable.FieldByName('AttyStreet').Text := LawyerCodeTable.FieldByName('Street').Text;
        MainTable.FieldByName('AttyCity').Text := LawyerCodeTable.FieldByName('City').Text;
        MainTable.FieldByName('AttyState').Text := LawyerCodeTable.FieldByName('State').Text;
        MainTable.FieldByName('AttyZip').Text := LawyerCodeTable.FieldByName('Zip').Text;
        MainTable.FieldByName('AttyZipPlus4').Text := LawyerCodeTable.FieldByName('ZipPlus4').Text;
        MainTable.FieldByName('AttyPhoneNumber').Text := LawyerCodeTable.FieldByName('PhoneNumber').Text;

        try
          MainTable.FieldByName('AttyFaxNumber').Text := LawyerCodeTable.FieldByName('FaxNumber').Text;
          MainTable.FieldByName('AttyAttorneyName').Text := LawyerCodeTable.FieldByName('AttorneyName').Text;
          MainTable.FieldByName('AttyEmail').Text := LawyerCodeTable.FieldByName('Email').Text;
        except
        end;

      end
    else MessageDlg('Error finding lawyer code ' + LawyerCode + '.', mtError, [mbOK], 0);

end;  {SetPetitionerNameAndAddress}

{===================================================================}
{===================  GRIEVANCE  ===================================}
{===================================================================}
Function DetermineGrievanceYear : String;

begin
  If GlblIsWestchesterCounty
    then Result := GlblNextYear
    else Result := GlblThisYear;

end;  {DetermineGrievanceYear}

{==================================================================}
Procedure DetermineGrantedValues(    GrievanceResultsTable : TTable;
                                 var GrantedLandValue : LongInt;
                                 var GrantedTotalValue : LongInt;
                                 var GrantedExemptionAmount : LongInt;
                                 var GrantedExemptionPercent : Double;
                                 var GrantedExemptionCode : String);

begin
  GrantedLandValue := 0;
  GrantedTotalValue := 0;
  GrantedExemptionAmount := 0;
  GrantedExemptionPercent := 0;
  GrantedExemptionCode := '';

  with GrievanceResultsTable do
    begin
      GrantedLandValue := FieldByName('LandValue').AsInteger;
      GrantedTotalValue := FieldByName('TotalValue').AsInteger;
      GrantedExemptionAmount := FieldByName('ExAmount').AsInteger;
      GrantedExemptionCode := FieldByName('ExGranted').Text;
      GrantedExemptionPercent := FieldByName('ExPercent').AsFloat;

    end;  {with GrievanceResultsTable do}

end;  {DetermineGrantedValues}

{==================================================================}
Procedure MoveGrantedValuesToMainParcel(OrigGrantedLandValue : LongInt;
                                        OrigGrantedTotalValue : LongInt;
                                        OrigGrantedExemptionAmount : LongInt;
                                        OrigGrantedExemptionPercent : Double;
                                        OrigGrantedExemptionCode : String;
                                        NewGrantedLandValue : LongInt;
                                        NewGrantedTotalValue : LongInt;
                                        NewGrantedExemptionAmount : LongInt;
                                        NewGrantedExemptionPercent : Double;
                                        NewGrantedExemptionCode : String;
                                        GrievanceProcessingType : Integer;
                                        SwisSBLKey : String;
                                        GrievanceYear : String;
                                        ParcelTabSet : TTabSet;
                                        TabTypeList : TStringList;
                                        GrievanceNumber : Integer;
                                        ResultNumber : Integer;
                                        Disposition : String;
                                        DecisionDate : String;
                                        UpdatedInBulkJob : Boolean;
                                        ShowMessage : Boolean;
                                        AutomaticallyMoveWhollyExemptsToRS8 : Boolean;
                                        FreezeAssessment : Boolean;
                                    var NowWhollyExempt : Boolean;
                                    var Updated : Boolean;
                                    var ErrorMessage : String;
                                    var LandValueChange : Comp;
                                    var TotalValueChange : Comp;
                                    var CountyTaxableChange : Comp;
                                    var TownTaxableChange : Comp;
                                    var SchoolTaxableChange : Comp;
                                    var VillageTaxableChange : Comp);


{Move the values to the main assessment (amd/or) exemption table, update the
 roll totals, add a record to the main audit table, add records to the assessor's
 trial balance audit tables, and add a record to the grievance audit table.}

var
  Quit, FoundExemption,
  SplitParcel, AlreadyRollSection8 : Boolean;
  Difference,
  OrigLandAssessedVal, OrigTotalAssessedVal,
  OrigPhysicalQtyInc, OrigPhysicalQtyDec,
  OrigEqualizationInc, OrigEqualizationDec,
  NewLandAssessedVal, NewTotalAssessedVal,
  NewPhysicalQtyInc, NewPhysicalQtyDec,
  NewEqualizationInc, NewEqualizationDec : Comp;  {Based on the assessment table.}

  AssessmentTable, ExemptionTable,
  ExemptionCodeTable, ClassTable,
  ParcelTable, SwisCodeTable,
  AuditAVChangeTable, AuditEXChangeTable,
  AuditGrievanceTable  : TTable;

  SBLRec : SBLRecord;

  AuditEXChangeList : TList;
  EXAmounts, OrigEXAmounts, NewEXAmounts : ExemptionTotalsArrayType;

  CurrentTime : TDateTime;
  PriorAssessmentDate, ResultString,
  PropertyClass, OriginalRollSection : String;

  BasicSTARAmount, EnhancedSTARAmount,
  OrigCountyTaxableValue, OrigTownTaxableValue,
  OrigSchoolTaxableValue, OrigVillageTaxableValue : Comp;
  ExemptionCodes,
  ExemptionHomesteadCodes,
  ResidentialTypes,
  CountyExemptionAmounts,
  TownExemptionAmounts,
  SchoolExemptionAmounts,
  VillageExemptionAmounts : TStringList;

begin
  CurrentTime := Now;
  NowWhollyExempt := False;
  AlreadyRollSection8 := False;
  FoundExemption := False;
  Difference := 0;
  Updated := True;
  ErrorMessage := '';

  LandValueChange := 0;
  TotalValueChange := 0;
  CountyTaxableChange := 0;
  TownTaxableChange := 0;
  SchoolTaxableChange := 0;
  VillageTaxableChange := 0;

  AuditEXChangeList := TList.Create;

  ParcelTable := TTable.Create(nil);
  AssessmentTable := TTable.Create(nil);
  ExemptionTable := TTable.Create(nil);
  AuditAVChangeTable := TTable.Create(nil);
  AuditEXChangeTable := TTable.Create(nil);
  AuditGrievanceTable := TTable.Create(nil);

  OpenTableForProcessingType(AssessmentTable, AssessmentTableName,
                             GrievanceProcessingType, Quit);
  AssessmentTable.IndexName := 'BYTAXROLLYR_SWISSBLKEY';
  FindKeyOld(AssessmentTable, ['TaxRollYr', 'SwisSBLKey'],
             [GrievanceYear, SwisSBLKey]);

  OpenTableForProcessingType(ExemptionTable,
                             ExemptionsTableName,
                             GrievanceProcessingType, Quit);
  ExemptionTable.IndexName := 'BYYEAR_SWISSBLKEY_EXCODE';

  OpenTableForProcessingType(ParcelTable, ParcelTableName,
                             GrievanceProcessingType, Quit);

  OpenTableForProcessingType(AuditAVChangeTable, 'AuditAVChangeTbl',
                             GrievanceProcessingType, Quit);

  OpenTableForProcessingType(AuditEXChangeTable, 'AuditEXChangeTbl',
                             GrievanceProcessingType, Quit);

  OpenTableForProcessingType(AuditGrievanceTable, 'gauditgrantedvalues',
                             GrievanceProcessingType, Quit);

    {Now recalculate the exemptions.}

  ExemptionCodeTable := FindTableInDataModuleForProcessingType(DataModuleExemptionCodeTableName,
                                                               GrievanceProcessingType);
  SwisCodeTable := FindTableInDataModuleForProcessingType(DataModuleSwisCodeTableName,
                                                          GrievanceProcessingType);
  ClassTable := FindTableInDataModuleForProcessingType(DataModuleClassTableName,
                                                       GrievanceProcessingType);

  ParcelTable.IndexName := 'BYTAXROLLYR_SWISSBLKEY';
  SBLRec := ExtractSwisSBLFromSwisSBLKey(SwisSBLKey);

  with SBLRec do
    FindKeyOld(ParcelTable,
               ['TaxRollYr', 'SwisCode', 'Section', 'Subsection',
                'Block', 'Lot', 'Sublot', 'Suffix'],
               [GrievanceYear, SwisCode, Section, SubSection,
                Block, Lot, Sublot, Suffix]);

  OriginalRollSection := ParcelTable.FieldByName('RollSection').Text;
  PropertyClass := ParcelTable.FieldByName('PropertyClassCode').Text;

  FindKeyOld(ClassTable, ['TaxRollYr', 'SwisSBLKey'],
             [GrievanceYear, SwisSBLKey]);

  with AssessmentTable do
    begin
      OrigLandAssessedVal := FieldByName('LandAssessedVal').AsInteger;
      OrigTotalAssessedVal := FieldByName('TotalAssessedVal').AsInteger;
      OrigPhysicalQtyInc := FieldByName('PhysicalQtyIncrease').AsInteger;
      OrigPhysicalQtyDec := FieldByName('PhysicalQtyDecrease').AsInteger;
      OrigEqualizationInc := FieldByName('IncreaseForEqual').AsInteger;
      OrigEqualizationDec := FieldByName('DecreaseForEqual').AsInteger;

    end;  {with AssessmentTable do}

  OrigCountyTaxableValue := OrigTotalAssessedVal - OrigEXAmounts[EXCounty];
  OrigTownTaxableValue := OrigTotalAssessedVal - OrigEXAmounts[EXTown];
  OrigSchoolTaxableValue := OrigTotalAssessedVal - OrigEXAmounts[EXSchool];
  OrigVillageTaxableValue := OrigTotalAssessedVal - OrigEXAmounts[EXVillage];

  NewLandAssessedVal := OrigLandAssessedVal;
  NewTotalAssessedVal := OrigTotalAssessedVal;

    {Make them update it manually if this is a split parcel.}

  SplitParcel := (ParcelTable.FieldByName('HomesteadCode').Text = 'S');

  If SplitParcel
    then
      begin
        Updated := False;
        ErrorMessage := 'The AV was not updated because it is a split parcel.';

        If ShowMessage
          then MessageDlg(ErrorMessage + #13 +
                          'Please determine and enter the homestead and non-homestead amounts manually.', mtWarning, [mbOK], 0);

      end  {If SplitParcel}
    else
      begin
          {First get all the values before the changes.}

        AdjustRollTotalsForParcel_New(GrievanceYear, GrievanceProcessingType,
                                      SwisSBLKey, OrigEXAmounts,
                                      ['S', 'C', 'E', 'D'], 'D');

        GetAuditEXList(SwisSBLKey, GrievanceYear, ExemptionTable, AuditEXChangeList);
        InsertAuditEXChanges(SwisSBLKey, GrievanceYear, AuditEXChangeList,
                             AuditEXChangeTable, 'B');

          {Now make the change in assessment and\or exemption.}

        If ((NewGrantedTotalValue > 0) and  {Don't do it if they didn't change AV.}
             ((NewGrantedLandValue <> OrigLandAssessedVal) or
              (NewGrantedTotalValue <> OrigTotalAssessedVal)))
          then
            begin
              with AssessmentTable do
                try
                  Difference := NewGrantedTotalValue - OrigTotalAssessedVal;

                  Edit;

                  If (Difference > 0)
                    then FieldByName('IncreaseForEqual').AsFloat := FieldByName('IncreaseForEqual').AsFloat +
                                                                     Difference
                    else FieldByName('DecreaseForEqual').AsFloat := FieldByName('DecreaseForEqual').AsFloat +
                                                                    -1 * Difference;

                    {FXX06022002-1: If they do not fill in a land value on the grievance,
                                    assume that the land value stays the same.}
                    {FXX08132007-1(2.11.3.1)[D968]: If the total value is reduced on vacant land,
                                                    reduce the land value, too.}

                  If _Compare(NewGrantedLandValue, 0, coEqual)
                    then
                      begin
                        If ParcelIsNonImprovedVacantLand(PropertyClass)
                          then
                            begin
                              FieldByName('LandAssessedVal').AsInteger := NewGrantedTotalValue;
                              NewGrantedLandValue := NewGrantedTotalValue;
                            end
                          else NewGrantedLandValue := FieldByName('LandAssessedVal').AsInteger;

                      end
                    else FieldByName('LandAssessedVal').AsInteger := NewGrantedLandValue;

                  FieldByName('TotalAssessedVal').AsInteger := NewGrantedTotalValue;

                    {FXX04232009-11(4.20.1.1)[D161]: Do not let the total value become less than the
                                                     land value.  Also, give warning.}

                  If _Compare(FieldByName('TotalAssessedVal').AsInteger, FieldByName('LandAssessedVal').AsInteger, coLessThan)
                    then
                      begin
                        FieldByName('LandAssessedVal').AsInteger :=  FieldByName('TotalAssessedVal').AsInteger;
                        MessageDlg('The total assessed value is now less than the land value.' + #13 +
                                   'The land value has been adjusted to be the same as the total value.' + #13 +
                                   'Please review the land value.', mtError, [mbOK], 0);

                      end;  {If _Compare(FieldByName('TotalAssessedVal').AsInteger ...}

                  PriorAssessmentDate := FieldByName('AssessmentDate').Text;
                  FieldByName('AssessmentDate').AsDateTime := Date;

                    {FXX05182012-1[PAS-359](2.28.4.25): Allow freeze to be an option.}

                  If FreezeAssessment
                    then FieldByName('DateFrozen').AsDateTime := AddOneYear(Date);

                  Post;

                  LandValueChange := NewGrantedLandValue - OrigLandAssessedVal;
                  TotalValueChange := NewGrantedTotalValue - OrigTotalAssessedVal;
                except
                  SystemSupport(010, AssessmentTable, 'Error updating assessment table for parcel ' + SwisSBLKey + '.',
                                'PASUTILS', GlblErrorDlgBox);
                end;

              If (NewGrantedLandValue <> OrigLandAssessedVal)
                then AddToTraceFile(SwisSBLKey,
                                    'Assessment', 'Land Assessed Val',
                                    FormatFloat(CurrencyDisplayNoDollarSign,
                                                OrigLandAssessedVal),
                                    FormatFloat(CurrencyDisplayNoDollarSign,
                                                NewGrantedLandValue),
                                    CurrentTime, AssessmentTable);

              AddToTraceFile(SwisSBLKey,
                             'Assessment', 'Total Assessed Val',
                             FormatFloat(CurrencyDisplayNoDollarSign,
                                         OrigTotalAssessedVal),
                             FormatFloat(CurrencyDisplayNoDollarSign,
                                         NewGrantedTotalValue),
                             CurrentTime, AssessmentTable);

              AddToTraceFile(SwisSBLKey,
                             'Assessment', 'AssessmentDate',
                             PriorAssessmentDate,
                             DateToStr(Date),
                             CurrentTime, AssessmentTable);

              AddToTraceFile(SwisSBLKey,
                             'Assessment', 'Date Frozen Until',
                             '',
                             AssessmentTable.FieldByName('DateFrozen').Text,
                             CurrentTime, AssessmentTable);

              If (Difference > 0)
                then AddToTraceFile(SwisSBLKey,
                                    'Assessment', 'Increase For Equal',
                                    FormatFloat(CurrencyDisplayNoDollarSign,
                                                OrigEqualizationDec),
                                    FormatFloat(CurrencyDisplayNoDollarSign,
                                                AssessmentTable.FieldByName('DecreaseForEqual').AsFloat),
                                    CurrentTime, AssessmentTable)
                else AddToTraceFile(SwisSBLKey,
                                    'Assessment', 'Decrease For Equal',
                                    FormatFloat(CurrencyDisplayNoDollarSign,
                                                OrigEqualizationDec),
                                    FormatFloat(CurrencyDisplayNoDollarSign,
                                                AssessmentTable.FieldByName('DecreaseForEqual').AsFloat),
                                    CurrentTime, AssessmentTable);

            end;  {If ((NewGrantedLandValue <> OrigLandAssessedVal) or ...}

          {Add the granted exemption if there is one.}

        If ((Deblank(NewGrantedExemptionCode) <> '') and
            (Deblank(OrigGrantedExemptionCode) = ''))
          then
            begin
                {FXX06072002-1: If the exemption already exists, make them
                                update it manually.}

              If (ParcelTable.FieldByName('RollSection').Text = '8')
                then
                  begin
                    AlreadyRollSection8 := True;
                    Updated := False;
                    ErrorMessage := 'Exemption ' +  NewGrantedExemptionCode +
                                    ' was not added because the parcel is already RS 8.';

                    If ShowMessage
                      then MessageDlg(ErrorMessage + #13 +
                                      'Please investigate.', mtWarning, [mbOK], 0);

                  end;  {If (ParcelTable.FieldByName('RollSection').Text = '8')}

              If not AlreadyRollSection8
                then
                  begin
                    ExemptionTable.CancelRange;

                    FoundExemption := FindKeyOld(ExemptionTable,
                                                 ['TaxRollYr', 'SwisSBLKey','ExemptionCode'],
                                                 [GrievanceYear, SwisSBLKey, NewGrantedExemptionCode]);

                    If FoundExemption
                      then
                        begin
                          Updated := False;
                          ErrorMessage := 'The exemption ' + NewGrantedExemptionCode + ' was not updated because it already exists.';
                          If ShowMessage
                            then MessageDlg(ErrorMessage + #13 +
                                            'Please update it manually.', mtWarning, [mbOK], 0);

                        end
                      else
                        begin
                          with ExemptionTable do
                            try
                              Insert;
                              FieldByName('TaxRollYr').Text := GrievanceYear;
                              FieldByName('SwisSBLKey').Text := SwisSBLKey;
                              FieldByName('ExemptionCode').Text := NewGrantedExemptionCode;
                              FieldByName('Amount').AsFloat := NewGrantedExemptionAmount;
                              FieldByName('Percent').AsFloat := NewGrantedExemptionPercent;
                              FieldByName('InitialDate').AsDateTime := Date;
                              Post;
                            except
                              SystemSupport(011, ExemptionTable,
                                            'Error inserting exemption code ' + NewGrantedExemptionCode + '.',
                                            'PASUTILS', GlblErrorDlgBox);
                            end;

                          If ((ParcelTabset <> nil) and
                              (ParcelTabset.Tabs.IndexOf(ExemptionsTabName) = -1))
                            then AddExemptionTab(ExemptionTable, ParcelTabset,
                                                 GrievanceProcessingType, 0,
                                                 TabTypeList, GrievanceYear,
                                                 SwisSBLKey);

                          AddToTraceFile(SwisSBLKey,
                                         'Exemption', 'Exempt Code',
                                         '', NewGrantedExemptionCode,
                                         Now, ExemptionTable);

                        end;  {else of If FoundExemption}

                  end;  {If not AlreadyRollSection8}

                {If the parcel was not updated due to an existing EX or already in RS 8,
                 we must add the totals back in since they were already taken out.}

              If not Updated
                then AdjustRollTotalsForParcel_New(GrievanceYear, GrievanceProcessingType,
                                                   SwisSBLKey, NewEXAmounts,
                                                   ['S', 'C', 'E', 'D'], 'A');

            end;  {If ((Deblank(NewGrantedExemptionCode) <> '') and ...}

      end;  {else of If SplitParcel}

  If Updated
    then
      begin
        RecalculateExemptionsForParcel(ExemptionCodeTable,
                                       ExemptionTable,
                                       AssessmentTable,
                                       ClassTable,
                                       SwisCodeTable,
                                       ParcelTable,
                                       GrievanceYear, SwisSBLKey, nil,
                                       0, 0, False);

          {If it is now wholly exempt, offer to move the parcel to roll section 8.}

        ExemptionCodes := TStringList.Create;
        ExemptionHomesteadCodes := TStringList.Create;
        ResidentialTypes := TStringList.Create;
        CountyExemptionAmounts := TStringList.Create;
        TownExemptionAmounts := TStringList.Create;
        SchoolExemptionAmounts := TStringList.Create;
        VillageExemptionAmounts := TStringList.Create;

        EXAmounts := TotalExemptionsForParcel(GrievanceYear, SwisSBLKey,
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

        If ((Roundoff(AssessmentTable.FieldByName('TotalAssessedVal').AsFloat, 0) =
             Roundoff(EXAmounts[EXTown], 0)) and
            (OriginalRollSection <> '8'))
          then NowWhollyExempt := True;

        ExemptionCodes.Free;
        ExemptionHomesteadCodes.Free;
        ResidentialTypes.Free;
        CountyExemptionAmounts.Free;
        TownExemptionAmounts.Free;
        SchoolExemptionAmounts.Free;
        VillageExemptionAmounts.Free;

        If (NowWhollyExempt and
            ((ShowMessage and
              (MessageDlg('The granted exemption has now made the parcel wholly exempt.' + #13 +
                          'Do you want to move the parcel to roll section 8?',
                          mtConfirmation, [mbYes, mbNo], 0) = idYes)) or
             ((not ShowMessage) and
              AutomaticallyMoveWhollyExemptsToRS8)))
          then
            begin
              with ParcelTable do
                try
                  Edit;
                  FieldByName('RollSection').Text := '8';
                  Post;
                except
                  SystemSupport(960, ParcelTable, 'Error moving parcel to roll section 8.',
                                'PASUTILS', GlblErrorDlgBox);
                end;

              AddToTraceFile(SwisSBLKey,
                             'Base Information', 'RollSection',
                             OriginalRollSection,
                             '8', CurrentTime, ParcelTable);

            end  {If NowWhollyExempt}
          else NowWhollyExempt := False;

          {Adjust the roll totals for the new values.}

        AdjustRollTotalsForParcel_New(GrievanceYear, GrievanceProcessingType,
                                      SwisSBLKey, NewEXAmounts,
                                      ['S', 'C', 'E', 'D'], 'A');

        If ((NewGrantedTotalValue > 0) and  {Don't do it if they didn't change AV.}
             ((NewGrantedLandValue <> OrigLandAssessedVal) or
              (NewGrantedTotalValue <> OrigTotalAssessedVal)))
          then
            begin
              with AssessmentTable do
                begin
                  NewLandAssessedVal := FieldByName('LandAssessedVal').AsInteger;
                  NewTotalAssessedVal := FieldByName('TotalAssessedVal').AsInteger;
                  NewPhysicalQtyInc := FieldByName('PhysicalQtyIncrease').AsInteger;
                  NewPhysicalQtyDec := FieldByName('PhysicalQtyDecrease').AsInteger;
                  NewEqualizationInc := FieldByName('IncreaseForEqual').AsInteger;
                  NewEqualizationDec := FieldByName('DecreaseForEqual').AsInteger;

                end;  {with AssessmentTable do}

              InsertAuditAVChangeRec(AuditAVChangeTable,
                                     SwisSBLKey,
                                     GrievanceYear,
                                     OrigLandAssessedVal,
                                     OrigTotalAssessedVal,
                                     OrigPhysicalQtyInc,
                                     OrigPhysicalQtyDec,
                                     OrigEqualizationInc,
                                     OrigEqualizationDec,
                                     OrigEXAmounts,
                                     NewLandAssessedVal,
                                     NewTotalAssessedVal,
                                     NewPhysicalQtyInc,
                                     NewPhysicalQtyDec,
                                     NewEqualizationInc,
                                     NewEqualizationDec,
                                     NewEXAmounts);

            end;  {If ((NewGrantedTotalValue > 0) and ...}

(*        If ((Deblank(NewGrantedExemptionCode) <> '') and
            (Deblank(OrigGrantedExemptionCode) = ''))
          then
            begin  *)
              ClearTList(AuditEXChangeList, SizeOf(AuditEXRecord));
              GetAuditEXList(SwisSBLKey, GrievanceYear, ExemptionTable, AuditEXChangeList);
              InsertAuditEXChanges(SwisSBLKey, GrievanceYear, AuditEXChangeList,
                                   AuditEXChangeTable, 'A');

 (*           end;  {If ((Deblank(NewGrantedExemptionCode) <> '') and ...} *)

        with AuditGrievanceTable do
          try
            Insert;
            FieldByName('TaxRollYr').Text := GrievanceYear;
            FieldByName('GrievanceNumber').AsInteger := GrievanceNumber;
            FieldByName('ResultNumber').AsInteger := ResultNumber;
            FieldByName('SwisSBLKey').Text := SwisSBLKey;
            FieldByName('Date').AsDateTime := Date;
            FieldByName('Time').AsDateTime := Now;
            FieldByName('User').Text := GlblUserName;
            FieldByName('Disposition').Text := Disposition;
            FieldByName('DecisionDate').Text := DecisionDate;
            FieldByName('OrigGrantedLandVal').AsInteger := OrigGrantedLandValue;
            FieldByName('OrigGrantedLandVal').AsInteger := OrigGrantedLandValue;
            FieldByName('OrigGrantedEXCode').Text := OrigGrantedExemptionCode;
            FieldByName('OrigGrantedEXPercent').AsFloat := OrigGrantedExemptionPercent;
            FieldByName('OrigGrantedEXAmt').AsInteger := OrigGrantedExemptionAmount;
            FieldByName('NewGrantedLandVal').AsInteger := NewGrantedLandValue;
            FieldByName('NewGrantedTotalVal').AsInteger := NewGrantedTotalValue;
            FieldByName('NewGrantedEXCode').Text := NewGrantedExemptionCode;
            FieldByName('NewGrantedEXPercent').AsFloat := NewGrantedExemptionPercent;
            FieldByName('NewGrantedEXAmt').AsInteger := NewGrantedExemptionAmount;
            FieldByName('UpdatedInBulkJob').AsBoolean := UpdatedInBulkJob;
            Post;
          except
            SystemSupport(012, AuditGrievanceTable,
                          'Error inserting into audit grievance table.',
                          'PASUTILS', GlblErrorDlgBox);
          end;

          {Update the changed flags on the parcel.}

        MarkRecChanged(ParcelTable, 'PASUTILS');

        SetExtractFlags(SwisSBLKey);

        ParcelTable.Close;
        AssessmentTable.Close;
        ExemptionTable.Close;
        AuditAVChangeTable.Close;
        AuditEXChangeTable.Close;
        AuditGrievanceTable.Close;

        ParcelTable.Free;
        AssessmentTable.Free;
        ExemptionTable.Free;
        AuditAVChangeTable.Free;
        AuditEXChangeTable.Free;
        AuditGrievanceTable.Free;

        FreeTList(AuditEXChangeList, SizeOf(AuditEXRecord));

        If ShowMessage
          then
            begin
              ResultString := '';

              If ((OrigLandAssessedVal <> NewGrantedLandValue) and
                  (NewGrantedLandValue <> 0))
                then ResultString := #13 + 'Land value reduced from ' +
                                     FormatFloat(CurrencyDisplayNoDollarSign,
                                                 OrigLandAssessedVal) +
                                     ' to ' +
                                     FormatFloat(IntegerDisplay,
                                                 NewGrantedLandValue) +
                                     '.';

              If ((OrigTotalAssessedVal <> NewGrantedTotalValue) and
                  (NewGrantedTotalValue <> 0))
                then
                  begin
                    If ((OrigLandAssessedVal = 0) and
                        (NewGrantedLandValue = 0))
                      then ResultString := #13 + 'The land value remained unchanged.';

                    ResultString := ResultString + #13 +
                                    'Total value reduced from ' +
                                    FormatFloat(CurrencyDisplayNoDollarSign,
                                                OrigTotalAssessedVal) +
                                    ' to ' +
                                    FormatFloat(IntegerDisplay,
                                                NewGrantedTotalValue) +
                                    '.';

                  end;  {If (OrigTotalAssessedVal <> NewGrantedTotalValue)}

              If (OrigGrantedExemptionCode <> NewGrantedExemptionCode)
                then ResultString := #13 + ResultString +
                                    'Exemption ' + NewGrantedExemptionCode +
                                    ' was added.';

              If not FoundExemption
                then MessageDlg('The following actions were taken: ' +
                                ResultString, mtInformation, [mbOK], 0);

            end;  {If ShowMessage}

        CountyTaxableChange := (NewTotalAssessedVal - NewEXAmounts[EXCounty]) -
                               (OrigTotalAssessedVal - OrigEXAmounts[EXCounty]);
        TownTaxableChange := (NewTotalAssessedVal - NewEXAmounts[EXTown]) -
                             (OrigTotalAssessedVal - OrigEXAmounts[EXTown]);
        SchoolTaxableChange := (NewTotalAssessedVal - NewEXAmounts[EXSchool]) -
                               (OrigTotalAssessedVal - OrigEXAmounts[EXSchool]);
        VillageTaxableChange := (NewTotalAssessedVal - NewEXAmounts[EXVillage]) -
                                (OrigTotalAssessedVal - OrigEXAmounts[EXVillage]);

      end;  {If Updated}

end;  {MoveGrantedValuesToMainParcel}

{==============================================================}
Procedure AddToGrievanceStatusString(var StatusStr : String;
                                         TempStr : String);

begin
  If (Deblank(StatusStr) <> '')
    then StatusStr := StatusStr + ', ';

  StatusStr := StatusStr + TempStr;

end;  {AddToGrievanceStatusString}

{==============================================================}
Function GetGrievanceStatus(    GrievanceTable : TTable;
                                GrievanceExemptionsAskedTable : TTable;
                                GrievanceResultsTable : TTable;
                                GrievanceDispositionCodeTable : TTable;
                                GrievanceYear : String;
                                SwisSBLKey : String;
                                ShortDescription : Boolean;
                            var StatusStr : String) : Integer;

var
  Done, FirstTimeThrough : Boolean;
  GrievanceNumber, NumComplaints,
  NumNotApproved, NumApproved, NumDismissed : LongInt;
  (*NumDenied, *) NumWithdrawn : LongInt;

begin
  StatusStr := '';
  GrievanceNumber := GrievanceTable.FieldByName('GrievanceNumber').AsInteger;

    {First figure out how many grievance items there are.}

  NumComplaints := 0;

  If (Roundoff(GrievanceTable.FieldByName('PetitTotalValue').AsFloat, 0) > 0)
    then NumComplaints := NumComplaints + 1;

  NumComplaints := NumComplaints +
                   NumRecordsInRange(GrievanceExemptionsAskedTable,
                                     ['SwisSBLKey', 'TaxRollYr', 'GrievanceNumber', 'ExemptionCode'],
                                     [SwisSBLKey, GrievanceYear, IntToStr(GrievanceNumber), '     '],
                                     [SwisSBLKey, GrievanceYear, IntToStr(GrievanceNumber), '99999']);

    {Now figure out how many results there are.}

  SetRangeOld(GrievanceResultsTable,
              ['TaxRollYr', 'SwisSBLKey', 'GrievanceNumber', 'ResultNumber'],
              [GrievanceYear, SwisSBLKey, IntToStr(GrievanceNumber), '0'],
              [GrievanceYear, SwisSBLKey, IntToStr(GrievanceNumber), '9999']);

  GrievanceResultsTable.First;

  NumNotApproved := 0;
  NumApproved := 0;
  (*NumDenied := 0;*)
  NumDismissed := 0;
  NumWithdrawn := 0;

  Done := False;
  FirstTimeThrough := True;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else GrievanceResultsTable.Next;

    If GrievanceResultsTable.EOF
      then Done := True;

    If ((not Done) and
        FindKeyOld(GrievanceDispositionCodeTable, ['Code'],
                   [GrievanceResultsTable.FieldByName('Disposition').Text]))
      then
        begin
          (*Approved := (GrievanceDispositionCodeTable.FieldByName('ResultType').AsInteger = gtApproved); *)

            {FXX10232002-1: If it is dismissed, the status should say dismissed.}

          If (Pos('AV', GrievanceResultsTable.FieldByName('ComplaintReason').Text) > 0)
            then
              begin
                  {FXX03122003-1(2.06q): If there is no asking value, but there is a disposition
                                         code, then count it as a complaint.}

                If ((Roundoff(GrievanceTable.FieldByName('PetitTotalValue').AsFloat, 0) = 0) and
                    (NumComplaints = 0))
                  then NumComplaints := NumComplaints + 1;

                case GrievanceDispositionCodeTable.FieldByName('ResultType').AsInteger of
                  gtApproved : AddToGrievanceStatusString(StatusStr,
                                                          'AV ' +
                                                          FormatFloat(CurrencyDisplayNoDollarSign,
                                                                      GrievanceResultsTable.FieldByName('TotalValue').AsFloat) +
                                                          ' granted');

                  gtDenied : AddToGrievanceStatusString(StatusStr,
                                                        'AV denied');

                  gtDismissed : AddToGrievanceStatusString(StatusStr,
                                                           'AV dismissed');

                  gtWithdrawn : AddToGrievanceStatusString(StatusStr,
                                                           'AV withdrawn');

                end;  {case GrievanceDispositionCodeTable...}

              end
            else
              begin
                case GrievanceDispositionCodeTable.FieldByName('ResultType').AsInteger of
                  gtApproved : AddToGrievanceStatusString(StatusStr,
                                                          'EX ' +
                                                          GrievanceResultsTable.FieldByName('EXGranted').Text +
                                                          ' granted');

                  gtDenied : AddToGrievanceStatusString(StatusStr,
                                                        'EX denied');

                  gtDismissed : AddToGrievanceStatusString(StatusStr,
                                                        'EX dismissed');

                  gtWithdrawn : AddToGrievanceStatusString(StatusStr,
                                                           'EX withdrawn');

                end;  {case GrievanceDispositionCodeTable...}

              end;  {If (Pos('AV', GrievanceResults.FieldByName('ComplaintReason').Text) > -1)}

          case GrievanceDispositionCodeTable.FieldByName('ResultType').AsInteger of
            gtApproved : NumApproved := NumApproved + 1;
            gtDenied : begin
                         NumNotApproved := NumNotApproved + 1;
                         (*NumDenied := NumDenied + 1; *)
                       end;

            gtDismissed : begin
                            NumNotApproved := NumNotApproved + 1;
                            NumDismissed := NumDismissed + 1;
                          end;

            gtWithdrawn : begin
                            NumNotApproved := NumNotApproved + 1;
                            NumWithdrawn := NumWithdrawn + 1;
                          end;

          end;  {case GrievanceDispositionCodeTable.FieldByName('ResultType').AsInteger of}

        end;  {If ((not Done) and ...}

  until Done;

    {Now compare the two to find the status.}

  If ShortDescription
    then StatusStr := 'OPEN';
  Result := gsOpen;

  If (((NumApproved + NumNotApproved) > 0) and
      ((NumApproved + NumNotApproved) < NumComplaints))
    then
      begin
        If ShortDescription
          then StatusStr := 'MIXED';
        Result := gsMixed;
      end;

  If (((NumApproved + NumNotApproved) = NumComplaints) and
      (NumApproved > 0) and
      (NumNotApproved > 0))
    then
      begin
        If ShortDescription
          then StatusStr := 'CLOSED';
        Result := gsClosed;
      end;

  If (((NumApproved + NumNotApproved) = NumComplaints) and
      (NumApproved = NumComplaints))
    then
      begin
        If ShortDescription
          then StatusStr := 'APPROVED';
        Result := gsApproved;
      end;

  If (((NumApproved + NumNotApproved) = NumComplaints) and
      (NumNotApproved = NumComplaints))
    then
      If (NumDismissed = NumComplaints)
        then
          begin
            If ShortDescription
              then StatusStr := 'DISMISSED';
            Result := gsDismissed;
          end
        else
          begin
            If ShortDescription
              then StatusStr := 'DENIED';
            Result := gsDenied;

          end;  {else of If (NumDismissed = NumComplaints)}

  If _Compare(NumWithdrawn, 0, coGreaterThan)
    then
      begin
        If ShortDescription
          then StatusStr := 'WITHDRAWN';
        Result := gsWithdrawn;
      end;

  If _Compare((NumApproved + NumNotApproved), 0, coEqual)
    then
      begin
        StatusStr := 'OPEN';
        Result := gsOpen;
      end;

end;  {GetGrievanceStatus}

{=============================================================}
Function GetGrievanceNumberToDisplay(GrievanceTable : TTable) : String;

var
  TempStr : String;

begin
    {CHG07192002-2: Add No Hearing flag.}

  TempStr := '';

  try
    If GrievanceTable.FieldByName('NoHearing').AsBoolean
      then TempStr := 'NH';
  except
  end;

  Result := IntToStr(GrievanceTable.FieldByName('GrievanceNumber').AsInteger) +
            TempStr;

end;  {GetGrievanceNumberToDisplay}

{===========================================================}
{=================  CERTIORARI  ============================}
{===========================================================}
Function GetCert_Or_SmallClaimStatus(    Table : TTable;
                                     var StatusCode : Integer) : String;

begin
  with Table do
    begin
      Result := 'Open';
      StatusCode := csOpen;

      If ((FieldByName('GrantedTotalValue').AsInteger > 0) or
          _Compare(FieldByName('Disposition').Text, 'COURT ORDER', coEqual))
        then
          begin
            StatusCode := csApproved;
            Result := 'AV ' +
                       FormatFloat(CurrencyDisplayNoDollarSign,
                                   FieldByName('GrantedTotalValue').AsFloat) +
                       ' granted';

          end;  {If (FieldByName('GrantedTotalValue').AsInteger > 0)}

      If (Deblank(FieldByName('GrantedEXCode').Text) <> '')
        then
          begin
            StatusCode := csApproved;
            Result := 'EX ' + FieldByName('GrantedEXCode').Text +
                      ' granted';

          end;  {If (Deblank(FieldByName('GrantedEXCode').Text) <> '')}

      If (FieldByName('Disposition').Text = 'DISCONTINUED')
        then
          begin
            StatusCode := csDiscontinued;
            Result := 'Discontinued ' + FieldByName('DispositionDate').Text;
          end;

      If _Compare(FieldByName('Disposition').Text, 'WITHDRAWN', coEqual)
        then
          begin
            StatusCode := csWithdrawn;
            Result := 'Withdrawn ' + FieldByName('DispositionDate').Text;
          end;

      If (FieldByName('Disposition').Text = 'DENIED')
        then
          begin
            StatusCode := csDenied;
            Result := 'Denied ' + FieldByName('DispositionDate').Text;
          end;

      If (FieldByName('Disposition').Text = 'DISMISSED')
        then
          begin
            StatusCode := csDenied;
            Result := 'Dismissed ' + FieldByName('DispositionDate').Text;
          end;

      If _Compare(FieldByName('Disposition').Text, 'DEN-NO GRV', coEqual)
        then
          begin
            StatusCode := csDenied;
            Result := 'Denied - no grievance';
          end;

    end;  {with CertiorariTable do}

end;  {GetCertiorariStatus}

{===============================================================}
Function CopyGrievanceToCert_Or_SmallClaim(IndexNumber : LongInt;
                                           GrievanceNumber : Integer;
                                           CurrentYear : String;
                                           PriorYear : String;
                                           SwisSBLKey : String;
                                           LawyerCode : String;
                                           NumberOfParcels : Integer;
                                           GrievanceTable,
                                           DestinationTable,
                                           LawyerCodeTable,
                                           ParcelTable,
                                           CurrentAssessmentTable,
                                           PriorAssessmentTable,
                                           SwisCodeTable,
                                           PriorSwisCodeTable,
                                           CurrentExemptionsTable,
                                           DestinationExemptionsTable,
                                           CurrentSpecialDistrictsTable,
                                           DestinationSpecialDistrictsTable,
                                           CurrentSalesTable,
                                           DestinationSalesTable,
                                           GrievanceExemptionsAskedTable,
                                           DestinationExemptionsAskedTable,
                                           GrievanceResultsTable,
                                           GrievanceDispositionCodeTable : TTable;
                                           Source : Char {(C)ert or (S)mall claim}) : Boolean;

var
  PriorAssessmentFound : Boolean;
  StatusStr, TempIndexNumberFieldName : String;

begin
  case Source of
    'C' : TempIndexNumberFieldName := 'CertiorariNumber';
    'S' : TempIndexNumberFieldName := 'IndexNumber';
  end;

  Result := True;
  FindKeyOld(SwisCodeTable, ['SwisCode'], [Copy(SwisSBLKey, 1, 6)]);

  FindKeyOld(CurrentAssessmentTable, ['TaxRollYr', 'SwisSBLKey'],
             [CurrentYear, SwisSBLKey]);

  PriorAssessmentFound := FindKeyOld(PriorAssessmentTable,
                                     ['TaxRollYr', 'SwisSBLKey'],
                                     [PriorYear, SwisSBLKey]);

  SetRangeOld(CurrentExemptionsTable, ['TaxRollYr', 'SwisSBLKey'],
              [CurrentYear, SwisSBLKey], [CurrentYear, SwisSBLKey]);

  SetRangeOld(CurrentSpecialDistrictsTable, ['TaxRollYr', 'SwisSBLKey'],
              [CurrentYear, SwisSBLKey], [CurrentYear, SwisSBLKey]);

  SetRangeOld(CurrentSalesTable, ['SwisSBLKey', 'SaleNumber'],
              [SwisSBLKey, '0'], [SwisSBLKey, '9999']);

  SetRangeOld(GrievanceExemptionsAskedTable,
              ['TaxRollYr', 'SwisSBLKey', 'GrievanceNumber', 'ExemptionCode'],
              [CurrentYear, SwisSBLKey, IntToStr(GrievanceNumber), '00000'],
              [CurrentYear, SwisSBLKey, IntToStr(GrievanceNumber), '9999']);

  with DestinationTable do
    try
      Append;
      FieldByName('TaxRollYr').Text := CurrentYear;
      FieldByName(TempIndexNumberFieldName).AsInteger := IndexNumber;
      FieldByName('SwisSBLKey').Text := SwisSBLKey;
      FieldByName('CurrentName1').Text := GrievanceTable.FieldByName('CurrentName1').Text;
      FieldByName('CurrentName2').Text := GrievanceTable.FieldByName('CurrentName2').Text;
      FieldByName('CurrentAddress1').Text := GrievanceTable.FieldByName('CurrentAddress1').Text;
      FieldByName('CurrentAddress2').Text := GrievanceTable.FieldByName('CurrentAddress2').Text;
      FieldByName('CurrentStreet').Text := GrievanceTable.FieldByName('CurrentStreet').Text;
      FieldByName('CurrentCity').Text := GrievanceTable.FieldByName('CurrentCity').Text;
      FieldByName('CurrentState').Text := GrievanceTable.FieldByName('CurrentState').Text;
      FieldByName('CurrentZip').Text := GrievanceTable.FieldByName('CurrentZip').Text;
      FieldByName('CurrentZipPlus4').Text := GrievanceTable.FieldByName('CurrentZipPlus4').Text;
      FieldByName('LawyerCode').Text := LawyerCode;

      If ((Deblank(LawyerCode) = '') or
          GlblGrievanceSeperateRepresentativeInfo)
        then
          begin
              {They are representing themselves.}

            FieldByName('PetitName1').Text := GrievanceTable.FieldByName('PetitName1').Text;
            FieldByName('PetitName2').Text := GrievanceTable.FieldByName('PetitName2').Text;
            FieldByName('PetitAddress1').Text := GrievanceTable.FieldByName('PetitAddress1').Text;
            FieldByName('PetitAddress2').Text := GrievanceTable.FieldByName('PetitAddress2').Text;
            FieldByName('PetitStreet').Text := GrievanceTable.FieldByName('PetitStreet').Text;
            FieldByName('PetitCity').Text := GrievanceTable.FieldByName('PetitCity').Text;
            FieldByName('PetitState').Text := GrievanceTable.FieldByName('PetitState').Text;
            FieldByName('PetitZip').Text := GrievanceTable.FieldByName('PetitZip').Text;
            FieldByName('PetitZipPlus4').Text := GrievanceTable.FieldByName('PetitZipPlus4').Text;

          end
        else SetPetitionerNameAndAddress(DestinationTable, LawyerCodeTable, LawyerCode);

      FieldByName('PropertyClassCode').Text := GrievanceTable.FieldByName('PropertyClassCode').Text;
      FieldByName('OwnershipCode').Text := GrievanceTable.FieldByName('OwnershipCode').Text;
      FieldByName('ResidentialPercent').AsFloat := GrievanceTable.FieldByName('ResidentialPercent').AsFloat;
      FieldByName('RollSection').Text := GrievanceTable.FieldByName('RollSection').Text;
      FieldByName('HomesteadCode').Text := GrievanceTable.FieldByName('HomesteadCode').Text;
      FieldByName('LegalAddr').Text := GrievanceTable.FieldByName('LegalAddr').Text;
      FieldByName('LegalAddrNo').Text := GrievanceTable.FieldByName('LegalAddrNo').Text;
      FieldByName('LegalAddrInt').AsInteger := GrievanceTable.FieldByName('LegalAddrInt').AsInteger;
      FieldByName('CurrentLandValue').AsInteger := CurrentAssessmentTable.FieldByName('LandAssessedVal').AsInteger;
      FieldByName('CurrentTotalValue').AsInteger := CurrentAssessmentTable.FieldByName('TotalAssessedVal').AsInteger;
      FieldByName('CurrentFullMarketVal').AsInteger := Round(ComputeFullValue(CurrentAssessmentTable.FieldByName('TotalAssessedVal').AsInteger,
                                                                              SwisCodeTable,
                                                                              GrievanceTable.FieldByName('PropertyClassCode').Text,
                                                                              GrievanceTable.FieldByName('OwnershipCode').Text,
                                                                              False));
      If PriorAssessmentFound
        then
          begin
            FindKeyOld(PriorSwisCodeTable, ['TaxRollYr', 'SwisCode'],
                       [PriorYear, Copy(SwisSBLKey, 1, 6)]);
            FieldByName('PriorLandValue').AsInteger := PriorAssessmentTable.FieldByName('LandAssessedVal').AsInteger;
            FieldByName('PriorTotalValue').AsInteger := PriorAssessmentTable.FieldByName('TotalAssessedVal').AsInteger;

            try
              FieldByName('PriorFullMarketVal').AsInteger := Round(ComputeFullValue(PriorAssessmentTable.FieldByName('TotalAssessedVal').AsInteger,
                                                                                    PriorSwisCodeTable,
                                                                                    GrievanceTable.FieldByName('PropertyClassCode').Text,
                                                                                    GrievanceTable.FieldByName('OwnershipCode').Text,
                                                                                    False));
            except
            end;

          end;  {If PriorAssessmentFound}

      FieldByName('CurrentEqRate').AsFloat := SwisCodeTable.FieldByName('EqualizationRate').AsFloat;
      FieldByName('CurrentUniformPercent').AsFloat := SwisCodeTable.FieldByName('UniformPercentValue').AsFloat;
      FieldByName('CurrentRAR').AsFloat := SwisCodeTable.FieldByName('ResAssmntRatio').AsFloat;
      FieldByName('SchoolCode').Text := ParcelTable.FieldByName('SchoolCode').Text;
      FieldByName('OldParcelID').Text := ParcelTable.FieldByName('RemapOldSBL').Text;
      FieldByName('NumberOfParcels').AsInteger := NumberOfParcels;

      FieldByName('PetitLandValue').AsInteger := GrievanceTable.FieldByName('PetitLandValue').AsInteger;
      FieldByName('PetitTotalValue').AsInteger := GrievanceTable.FieldByName('PetitTotalValue').AsInteger;
      FieldByname('PetitFullMarketVal').AsInteger := Round(ComputeFullValue(FieldByName('PetitTotalValue').AsInteger,
                                                                                        SwisCodeTable,
                                                                                        FieldByName('PropertyClassCode').Text,
                                                                                        FieldByName('OwnershipCode').Text,
                                                                                        False));

      FieldByName('PetitReason').Text := GrievanceTable.FieldByName('PetitReason').Text;
      TMemoField(FieldByName('PetitSubReason')).Value := TMemoField(GrievanceTable.FieldByName('PetitSubReason')).Value;
      FieldByName('PetitSubReasonCode').Text := GrievanceTable.FieldByName('PetitSubReasonCode').Text;

      GetGrievanceStatus(GrievanceTable, GrievanceExemptionsAskedTable,
                         GrievanceResultsTable, GrievanceDispositionCodeTable,
                         GrievanceTable.FieldByName('TaxRollYr').Text, SwisSBLKey,
                         False, StatusStr);

      FieldByName('GrievanceDecision').Text := StatusStr;

        {CHG07262004-1(2.08): Option to have attorney information seperate.}

      If GlblGrievanceSeperateRepresentativeInfo
        then
          try
            FieldByName('AttyName1').Text := GrievanceTable.FieldByName('AttyName1').Text;
            FieldByName('AttyName2').Text := GrievanceTable.FieldByName('AttyName2').Text;
            FieldByName('AttyAddress1').Text := GrievanceTable.FieldByName('AttyAddress1').Text;
            FieldByName('AttyAddress2').Text := GrievanceTable.FieldByName('AttyAddress2').Text;
            FieldByName('AttyStreet').Text := GrievanceTable.FieldByName('AttyStreet').Text;
            FieldByName('AttyCity').Text := GrievanceTable.FieldByName('AttyCity').Text;
            FieldByName('AttyState').Text := GrievanceTable.FieldByName('AttyState').Text;
            FieldByName('AttyZip').Text := GrievanceTable.FieldByName('AttyZip').Text;
            FieldByName('AttyZipPlus4').Text := GrievanceTable.FieldByName('AttyZipPlus4').Text;
            FieldByName('AttyPhoneNumber').Text := GrievanceTable.FieldByName('AttyPhoneNumber').Text;

          except
          end;

      Post;

    except
      Result := False;
      Cancel;
      (*SystemSupport(002, DestinationTable,
                    'Error adding index # ' + IntToStr(IndexNumber) +
                    ' to parcel ' + SwisSBLKey + '.',
                    'GrievanceUtilitys', GlblErrorDlgBox);  *)
    end;


  If Result
  then
  begin
    CopyTableRange(CurrentExemptionsTable, DestinationExemptionsTable,
                   'TaxRollYr', [TempIndexNumberFieldName], [IntToStr(IndexNumber)]);

    CopyTableRange(CurrentSpecialDistrictsTable, DestinationSpecialDistrictsTable,
                   'TaxRollYr', [TempIndexNumberFieldName], [IntToStr(IndexNumber)]);

    CopyTableRange(CurrentSalesTable, DestinationSalesTable,
                   'SwisSBLKey', [TempIndexNumberFieldName], [IntToStr(IndexNumber)]);

    CopyTableRange(GrievanceExemptionsAskedTable, DestinationExemptionsAskedTable,
                   'SwisSBLKey', [TempIndexNumberFieldName], [IntToStr(IndexNumber)]);
  end;

end;  {CopyGrievanceToCert_Or_SmallClaim}

{========================================================================================}
Function IsGrievance_SmallClaims_CertiorariScreen(ScreenName : String) : Boolean;

{CHG02152004-1(2.07l): Add grievance, small claims and cert info. to search report.}

begin
  Result := ((ScreenName = GrievanceScreenName) or
             (ScreenName = SmallClaimsScreenName) or
             (ScreenName = SmallClaimsAppraisalsScreenName) or
             (ScreenName = SmallClaimsCalendarScreenName) or
             (ScreenName = SmallClaimsNotesScreenName) or
             (ScreenName = CertiorariScreenName) or
             (ScreenName = CertiorariAppraisalsScreenName) or
             (ScreenName = CertiorariCalendarScreenName) or
             (ScreenName = CertiorariNotesScreenName));

end;  {IsGrievance_SmallClaims_CertiorariScreen}

{========================================================================================}
Function UserCanViewGrievance_SmallClaims_CertiorariInformation(ScreenName : String) : Boolean;

{CHG02152004-1(2.07l): Add grievance, small claims and cert info. to search report.}

begin
  Result := True;

  If ((not GlblCanSeeCertiorari) and
      ((ScreenName = CertiorariScreenName) or
       (ScreenName = CertiorariAppraisalsScreenName) or
       (ScreenName = CertiorariCalendarScreenName) or
       (ScreenName = CertiorariNotesScreenName)))
    then Result := False;

  If (Result and
      (not GlblCanSeeCertNotes) and
      (ScreenName = CertiorariNotesScreenName))
    then Result := False;

  If (Result and
      (not GlblCanSeeCertAppraisals) and
      (ScreenName = CertiorariAppraisalsScreenName))
    then Result := False;

end;  {UserCanViewGrievance_SmallClaims_CertiorariInformation}

{====================================================================}
Procedure InitGrievanceTotalsRecord(var TotalsRec : GrievanceTotalsRecord);

begin
  with TotalsRec do
    begin
      TotalCount := 0;
      _Open := 0;
      _Closed := 0;
      _Approved := 0;
      _Denied := 0;
      _Dismissed := 0;
      _Withdrawn := 0;

    end;  {with TotalsRec do}

end;  {InitGrievanceTotalsRecord}

{====================================================================}
Procedure UpdateSmallClaims_Certiorari_TotalsRecord(var TotalsRec : GrievanceTotalsRecord;
                                                        Status : Integer);

begin
  Inc(TotalsRec.TotalCount);

  If _Compare(Status, csOpen, coEqual)
    then Inc(TotalsRec._Open);

  If _Compare(Status,
              [csApproved, csDenied, csWithdrawn, csDismissed], coEqual)
    then Inc(TotalsRec._Closed);

  If _Compare(Status, csApproved, coEqual)
    then Inc(TotalsRec._Approved);

  If _Compare(Status, csDenied, coEqual)
    then Inc(TotalsRec._Denied);

  If _Compare(Status, csWithdrawn, coEqual)
    then Inc(TotalsRec._Withdrawn);

  If _Compare(Status, csDismissed, coEqual)
    then Inc(TotalsRec._Dismissed);

end;  {UpdateSmallClaims_Certiorari_TotalsRecord}

{====================================================================}
Procedure UpdateGrievanceTotalsRecord(var TotalsRec : GrievanceTotalsRecord;
                                          Status : Integer);

begin
  Inc(TotalsRec.TotalCount);

  If _Compare(Status, [gsOpen, gsMixed], coEqual)
    then Inc(TotalsRec._Open);

  If _Compare(Status,
              [gsClosed, gsApproved, gsDenied, gsDismissed], coEqual)
    then Inc(TotalsRec._Closed);

  If _Compare(Status, gsApproved, coEqual)
    then Inc(TotalsRec._Approved);

  If _Compare(Status, gsDenied, coEqual)
    then Inc(TotalsRec._Denied);

  If _Compare(Status, gsWithdrawn, coEqual)
    then Inc(TotalsRec._Withdrawn);

  If _Compare(Status, gsDismissed, coEqual)
    then Inc(TotalsRec._Dismissed);

end;  {UpdateGrievanceTotalsRecord}

{====================================================================}
Procedure PrintGrievanceTotals(Sender : TObject;
                               TotalsRec : GrievanceTotalsRecord);

begin
  with Sender as TBaseReport, TotalsRec do
    begin
      If (LinesLeft < 10)
        then NewPage;

      Println('');
      ClearTabs;
      SetTab(0.3, pjCenter, 1.7, 5, BoxLineAll, 25);
      SetTab(2.0, pjCenter, 0.5, 5, BoxLineAll, 25);

      Bold := True;
      Println(#9 + 'Category' +
              #9 + 'Count');

      ClearTabs;
      SetTab(0.3, pjLeft, 1.7, 5, BoxLineAll, 0);
      SetTab(2.0, pjRight, 0.5, 5, BoxLineAll, 0);
      Bold := False;

      Bold := True;
      Println(#9 + 'Total:' +
              #9 + IntToStr(TotalCount));
      Bold := False;

      Println(#9 + '  Open:' +
              #9 + IntToStr(_Open));
      Println(#9 + '  Closed:' +
              #9 + '');
      Println(#9 + '    Approved:' +
              #9 + IntToStr(_Approved));
      Println(#9 + '    Denied:' +
              #9 + IntToStr(_Denied));
      Println(#9 + '    Dismissed:' +
              #9 + IntToStr(_Dismissed));
      Println(#9 + '    Withdrawn:' +
              #9 + IntToStr(_Withdrawn));

    end;  {with Sender as TBaseReport, TotalsRec do}

end;  {PrintGrievanceTotals}

{============================================================================}
Function ParcelHasOpenCertiorari(tbCertiorari : TTable;
                                 sSwisSBLKey : String) : Boolean;

begin
  Result := False;
  _SetRange(tbCertiorari, [sSwisSBLKey], [], '', [loSameEndingRange]);

  with tbCertiorari do
    begin
      First;

      while (not EOF) do
        begin
          If _Compare(FieldByName('Disposition').AsString, coBlank)
            then Result := True;

          Next;

        end;  {while (not EOF) do}

    end;  {with tbCertiorari do}

end;  {ParcelHasOpenCertiorari}

end.