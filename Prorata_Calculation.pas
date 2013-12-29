unit Prorata_Calculation;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, DBCtrls, DBTables, DB, Buttons, Grids,
  Wwdbigrd, Wwdbgrid, ExtCtrls, Wwtable, Wwdatsrc, Menus, RPCanvas,
  RPrinter, RPDefine, RPBase, RPFiler, locatdir, Mask, CheckLst, PASTypes;

type
  TCalculateProrataInformationForm = class(TForm)
    Panel2: TPanel;
    ScrollBox1: TScrollBox;
    ReportFiler: TReportFiler;
    PrintDialog: TPrintDialog;
    ReportPrinter: TReportPrinter;
    ParcelTable: TTable;
    RemovedExemptionsTable: TTable;
    ProrataHeaderTable: TTable;
    ProrataDetailsTable: TTable;
    ProrataExemptionsTable: TTable;
    Panel1: TPanel;
    Label1: TLabel;
    Panel4: TPanel;
    StartButton: TBitBtn;
    CloseButton: TBitBtn;
    OptionsGroupBox: TGroupBox;
    Label2: TLabel;
    CollectionTypeComboBox: TComboBox;
    Panel3: TPanel;
    Panel5: TPanel;
    Label3: TLabel;
    LeviesToProrateCheckBox: TCheckListBox;
    Label4: TLabel;
    Label5: TLabel;
    TrialRunCheckBox: TCheckBox;
    CalculationDateMaskEdit: TMaskEdit;
    Label6: TLabel;
    EditProrataYear: TEdit;
    EditCollectionStartDay: TEdit;
    Label7: TLabel;
    EditCollectionStartMonth: TEdit;
    LeviesToProrateTable: TTable;
    BillingGeneralRateTable: TTable;
    BillingExemptionDetailsTable: TTable;
    ExtractToExcelCheckBox: TCheckBox;
    ClearPriorProrataInformationCheckBox: TCheckBox;
    Label8: TLabel;
    BillingSpecialDistrictRateTable: TTable;
    ExemptionCodeTable: TTable;
    SpecialDistrictCodeTable: TTable;
    BillingSpecialDistrictDetailsTable: TTable;
    NYParcelTable: TTable;
    Label9: TLabel;
    edCutOffEffectiveDate: TMaskEdit;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure StartButtonClick(Sender: TObject);
    procedure ReportPrintHeader(Sender: TObject);
    procedure ReportPrint(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure CollectionTypeComboBoxChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    UnitName, ProrataYear, CollectionType, _Category : String;
    TrialRun, ReportCancelled, ExtractToExcel,
    ProrataYearIsNextYear, ClearProrataInformation : Boolean;
    CollectionStartDay, CollectionStartMonth, ReportSection : Integer;
    CalculationDate, dCutoffEffectiveDate : TDateTime;
    RejectList, WarningList, LeviesToProrateList, BillingRateList : TList;
    ExtractFile : TextFile;

    Procedure InitializeForm;  {Open the tables and setup.}

    Procedure LoadLeviesToProrateCheckBox(CollectionType : String);

    Procedure PrintProrataTotals(Sender : TObject;
                                 ProrataTotalsList : TList);

    Procedure PrintRejectOrWarningSectionHeaders(Sender : TObject);

    Procedure PrintRejectOrWarningSection(Sender : TObject;
                                          RejectOrWarningList : TList);

  end;

  RejectOrWarningRecord = record
    ParcelID : String;
    SchoolCode : String;
    ExemptionCode : String;
    EffectiveDate : TDateTime;
    RemovalDate : TDateTime;
    Reason : String;
  end;

  RejectOrWarningPointer = ^RejectOrWarningRecord;


implementation

uses GlblVars, WinUtils, Utilitys, GlblCnst, PASUtils, Prog, Preview,
     Types, DataAccessUnit, UtilBill, UtilEXSD;

{$R *.DFM}

const
  rsMain = 1;
  rsDetail = 2;
  rsReject = 3;
  rsWarning = 4;

{========================================================}
Procedure TCalculateProrataInformationForm.FormActivate(Sender: TObject);

begin
  SetFormStateMaximized(Self);
end;

{========================================================}
Procedure TCalculateProrataInformationForm.InitializeForm;

begin
  UnitName := 'Prorata_Calculation';  {mmm}
  ProrataYearIsNextYear := False;

  _OpenTablesForForm(Self, ThisYear, []);

  _OpenTable(NYParcelTable, ParcelTableName, '', '', NextYear, []);

  CalculationDateMaskEdit.Text := DateToStr(Date);
  EditProrataYear.Text := IntToStr(GetYearFromDate(Date));

  LeviesToProrateList := TList.Create;
  BillingRateList := TList.Create;
  RejectList := TList.Create;
  WarningList := TList.Create;

end;  {InitializeForm}

{===================================================================}
Procedure TCalculateProrataInformationForm.FormKeyPress(    Sender: TObject;
                                                        var Key: Char);

begin
  If (Key = #13)
    then
      begin
        Key := #0;
        Perform(WM_NEXTDLGCTL, 0, 0);
      end;

end;  {FormKeyPress}

{===================================================================}
Function LeviesToProrateEntryExists(    LeviesToProrateList : TList;
                                        _PrintOrder : Integer;
                                        _SwisCode : String;
                                        _SchoolCode : String;
                                        _GeneralTaxType : String;
                                        _SpecialDistrictCode : String;
                                    var Index : Integer) : Boolean;

var
  I : Integer;

begin
  Index := -1;
  Result := False;

  For I := 0 to (LeviesToProrateList.Count - 1) do
    with LeviesToProratePointer(LeviesToProrateList[I])^ do
      If ((_Compare(_SpecialDistrictCode, coNotBlank) and
           _Compare(SpecialDistrictCode, _SpecialDistrictCode, coEqual)) or
          (_Compare(PrintOrder, _PrintOrder, coEqual) and
           _Compare(SwisCode, _SwisCode, coEqual) and
           _Compare(SchoolCode, _SchoolCode, coEqual) and
           _Compare(GeneralTaxType, _GeneralTaxType, coEqual)))
        then
          begin
            Result := True;
            Index := I;
          end;

end;  {LeviesToProrateEntryExists}

{===================================================================}
Procedure AddBillingRatesToList(LeviesToProrateList : TList;
                                BillingRateList : TList;
                                BillingRateTable : TTable;
                                SpecialDistrictRates : Boolean);

var
  BillingRatePtr : BillingRatePointer;
  Done, FirstTimeThrough : Boolean;
  Index, SwisOrSchoolCodePos, TempPrintOrder : Integer;
  TempSwisCode, TempSchoolCode,
  TempSpecialDistrictCode, TempGeneralTaxType, TempLevyDescription : String;

begin
  BillingRateTable.First;
  FirstTimeThrough := True;
  Done := False;

  with BillingRateTable do
    repeat
      If FirstTimeThrough
        then FirstTimeThrough := False
        else Next;

      If EOF
        then Done := True;

      If SpecialDistrictRates
        then
          begin
            TempSwisCode := '';
            TempSchoolCode := '';
            TempPrintOrder := 0;
            TempGeneralTaxType := '';
            TempSpecialDistrictCode := FieldByName('SDistCode').Text;
          end
        else
          begin
            TempSwisCode := FieldByName('SwisCode').Text;
            TempSchoolCode := FieldByName('SchoolCode').Text;
            TempPrintOrder := FieldByName('PrintOrder').AsInteger;
            TempGeneralTaxType := FieldByName('GeneralTaxType').Text;
            TempSpecialDistrictCode := '';

          end;  {else of If SpecialDistrictRates}

      If ((not Done) and
          LeviesToProrateEntryExists(LeviesToProrateList,
                                     TempPrintOrder,
                                     TempSwisCode,
                                     TempSchoolCode,
                                     TempGeneralTaxType,
                                     TempSpecialDistrictCode,
                                     Index))
        then
          begin
            New(BillingRatePtr);

            with BillingRatePtr^ do
              begin
                AssessmentYear := FieldByName('TaxRollYr').Text;
                LevyType := LeviesToProratePointer(LeviesToProrateList[Index])^.LevyType;

                If (((LevyType = ltCounty) and
                     (not GlblAssessmentYearIsSameAsTaxYearForCounty)) or
                    ((LevyType in [ltMunicipal, ltSpecialDistrict]) and
                     (not GlblAssessmentYearIsSameAsTaxYearForMunicipal)) or
                    ((LevyType = ltSchool) and
                     (not GlblAssessmentYearIsSameAsTaxYearForSchool)))
                  then AssessmentYear := IntToStr(StrToInt(AssessmentYear) + 1);

                AssessmentYearBilledFrom := FieldByName('TaxRollYr').Text;
                CollectionType := FieldByName('CollectionType').Text;
                CollectionNumber := FieldByName('CollectionNo').AsInteger;

                If SpecialDistrictRates
                  then
                    begin
                      PrintOrder := 0;
                      GeneralTaxType := '';
                      SwisCode := '';
                      SchoolCode := '';
                      SpecialDistrictCode := FieldByName('SDistCode').Text;
                      LevyDescription := LeviesToProratePointer(LeviesToProrateList[Index])^.LevyDescription;
                      HomesteadCode := '';
                      ExtensionCode := FieldByName('ExtCode').Text;

                    end
                  else
                    begin
                      PrintOrder := FieldByName('PrintOrder').AsInteger;
                      GeneralTaxType := FieldByName('GeneralTaxType').Text;
                      SwisCode := FieldByName('SwisCode').Text;
                      SchoolCode := FieldByName('SchoolCode').Text;
                      SpecialDistrictCode := '';
                      HomesteadCode := '';
                      ExtensionCode := '';

                      TempLevyDescription := LeviesToProratePointer(LeviesToProrateList[Index])^.LevyDescription;
                      SwisOrSchoolCodePos := Pos(')', TempLevyDescription);
                      System.Delete(TempLevyDescription, 1, (SwisOrSchoolCodePos + 1));
                      LevyDescription := TempLevyDescription;

                    end;  {else of If SpecialDistrictRates}

                HomesteadRate := FieldByName('HomesteadRate').AsFloat;
                NonhomesteadRate := FieldByName('NonhomesteadRate').AsFloat;

              end;  {with BillingRatePtr^ do}

            BillingRateList.Add(BillingRatePtr);

          end;  {with BillingGeneralRateTable do}

  until Done;

end;  {AddBillingRatesToList}

{===================================================================}
Procedure LoadLeviesToProrate(LeviesToProrateTable : TTable;
                              BillingGeneralRateTable : TTable;
                              BillingSpecialDistrictRateTable : TTable;
                              LeviesToProrateList : TList;
                              BillingRateList : TList);

var
  LeviesToProratePtr : LeviesToProratePointer;
  Done, FirstTimeThrough : Boolean;

begin
  Done := False;
  FirstTimeThrough := True;

  ClearTList(LeviesToProrateList, SizeOf(LeviesToProrateRecord));

  with LeviesToProrateTable do
    begin
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
              New(LeviesToProratePtr);

              with LeviesToProratePtr^ do
                begin
                  PrintOrder := FieldByName('PrintOrder').AsInteger;
                  GeneralTaxType := FieldByName('GeneralTaxType').Text;

                  If _Compare(GeneralTaxType, CountyTaxType, coEqual)
                    then LevyType := ltCounty;

                  If (_Compare(GeneralTaxType, MunicipalTaxType, coEqual) or
                      _Compare(GeneralTaxType, TownTaxType, coEqual) or
                      _Compare(GeneralTaxType, VillageTaxType, coEqual))
                    then LevyType := ltMunicipal;

                  If _Compare(GeneralTaxType, SchoolTaxType, coEqual)
                    then LevyType := ltSchool;

                  If _Compare(GeneralTaxType, SpecialDistrictTaxType, coEqual)
                    then LevyType := ltSpecialDistrict;

                  SchoolCode := FieldByName('SchoolCode').Text;
                  SwisCode := FieldByName('SwisCode').Text;

                  try
                    SpecialDistrictCode := FieldByName('SpecialDistrictCode').Text;
                  except
                    SpecialDistrictCode := '';
                  end;

                  ProrateThisLevy := FieldByName('ProrateThisLevy').AsBoolean;
                  Description := FieldByName('Description').Text;
                  LevyDescription := Description;

                  If (LevyType = ltSchool)
                    then LevyDescription := '(' + SchoolCode + ') ' + Description;

                  If (LevyType in [ltCounty, ltMunicipal])
                    then LevyDescription := '(' + SwisCode + ') ' + Description;

                end;  {with LeviesToProratePtr^ do}

              LeviesToProrateList.Add(LeviesToProratePtr);

            end;  {If not Done}

      until Done;

    end;  {with LeviesToProrateDetailsTable do}

    {Now go through the billing rates and load all rates that match the levies
     to prorate list (from any year).}

  ClearTList(BillingRateList, SizeOf(BillingRateRecord));
  AddBillingRatesToList(LeviesToProrateList, BillingRateList, BillingGeneralRateTable, False);

    {Now check the special district rates for applicable levies to bill.}

  AddBillingRatesToList(LeviesToProrateList, BillingRateList, BillingSpecialDistrictRateTable, True);

end;  {LoadLeviesToProrate}

{===================================================================}
Procedure TCalculateProrataInformationForm.LoadLeviesToProrateCheckBox(CollectionType : String);

var
  I : Integer;

begin
  _SetRange(LeviesToProrateTable, [CollectionType, 0],
            [CollectionType, 9999], '', []);

  LoadLeviesToProrate(LeviesToProrateTable, BillingGeneralRateTable,
                      BillingSpecialDistrictRateTable, LeviesToProrateList, BillingRateList);
  LeviesToProrateCheckBox.Items.Clear;

  For I := 0 to (LeviesToProrateList.Count - 1) do
    with LeviesToProratePointer(LeviesToProrateList[I])^ do
      begin
        LeviesToProrateCheckBox.Items.Add(LevyDescription);

        If ProrateThisLevy
          then LeviesToProrateCheckBox.Checked[I] := True;

      end;  {with LeviesToProratePointer(LeviesToProrateList[I])^ do}

end;  {LoadLeviesToProrateCheckBox}

{===================================================================}
Procedure TCalculateProrataInformationForm.CollectionTypeComboBoxChange(Sender: TObject);

begin
  case CollectionTypeComboBox.ItemIndex of
    0, 1 : CollectionType := MunicipalTaxType;
    2 : CollectionType := CountyTaxType;
    3 : CollectionType := SchoolTaxType;
    4 : CollectionType := VillageTaxType;

  end;  {case CollectionTypeComboBox of}

  If _Compare(CollectionType, MunicipalTaxType, coEqual)
    then
      If _Compare(CollectionTypeComboBox.ItemIndex, 0, coEqual)
        then
          begin
            If GlblIsWestchesterCounty
              then
              begin
                EditCollectionStartMonth.Text := '4';
                EditCollectionStartDay.Text := '1';
                GlblAssessmentYearIsSameAsTaxYearForMunicipal := False;
                GlblAssessmentYearIsSameAsTaxYearForCounty := False;
              end
              else
              begin
                EditCollectionStartMonth.Text := '1';
                EditCollectionStartDay.Text := '1';
                GlblAssessmentYearIsSameAsTaxYearForMunicipal := False;
                GlblAssessmentYearIsSameAsTaxYearForCounty := False;
              end;  {If GlblIsWestchesterCounty}
              
          end
        else
          begin
            EditCollectionStartMonth.Text := '7';
            EditCollectionStartDay.Text := '1';
            GlblAssessmentYearIsSameAsTaxYearForMunicipal := True;
            ProrataYearIsNextYear := True;
            EditProrataYear.Text := IncrementNumericString(EditProrataYear.Text, 1);

          end;  {else of If _Compare(CollectionTypeComboBox.ItemIndex, 0, coEqual)}

  If _Compare(CollectionType, SchoolTaxType, coEqual)
    then
      begin
        If GlblIsWestchesterCounty
          then GlblAssessmentYearIsSameAsTaxYearForSchool := False
          else GlblAssessmentYearIsSameAsTaxYearForSchool := True;
          
        EditCollectionStartMonth.Text := '9';
        EditCollectionStartDay.Text := '1';

      end;  {If _Compare(CollectionType, SchoolTaxType, coEqual)}

  LoadLeviesToProrateCheckBox(CollectionType);

end;  {CollectionTypeComboBoxChange}

{===================================================================}
Procedure AddRejectOrWarningItem(RejectOrWarningList : TList;
                                 _SwisSBLKey : String;
                                 _SchoolCode : String;
                                 _ExemptionCode : String;
                                 _EffectiveDate : TDateTime;
                                 _RemovalDate : TDateTime;
                                 _Reason : String);

var
  RejectOrWarningPtr : RejectOrWarningPointer;

begin
  New(RejectOrWarningPtr);

  with RejectOrWarningPtr^ do
    begin
      ParcelID := ConvertSBLOnlyToDashDot(Copy(_SwisSBLKey, 7, 20));
      SchoolCode := _SchoolCode;
      ExemptionCode := _ExemptionCode;
      EffectiveDate := _EffectiveDate;
      RemovalDate := _RemovalDate;
      Reason := _Reason;

    end;  {with RejectPtr^ do}

  RejectOrWarningList.Add(RejectOrWarningPtr);

end;  {AddRejectOrWarningItem}

{===================================================================}
Function ExemptionCalculatedForThisCollectionType(RemovedExemptionsTable : TTable;
                                                  CollectionType : String;
                                                  ClearProrataInformation : Boolean;
                                                  ProrataYear : String) : Boolean;

begin
  Result := False;

  with RemovedExemptionsTable do
    begin
      If ((CollectionType = MunicipalTaxType) and
          _Compare(FieldByName('MunicipalProrataCalcYear').Text, coNotBlank))
        then Result := True;

      If ((CollectionType = CountyTaxType) and
          _Compare(FieldByName('CountyProrataCalcYear').Text, coNotBlank))
        then Result := True;

      If ((CollectionType = SchoolTaxType) and
          _Compare(FieldByName('SchoolProrataCalcYear').Text, coNotBlank))
        then Result := True;

    end;  {with RemovedExemptionsTable do}

end;  {ExemptionCalculatedForThisCollectionType}

{===================================================================}
Function RemovedExemptionSortEntryExists(RemovedExemptionSortList : TList;
                                         _ExemptionCode : String) : Boolean;

var
  I : Integer;

begin
  Result := False;

  For I := 0 to (RemovedExemptionSortList.Count - 1) do
    with RemovedExemptionSortPointer(RemovedExemptionSortList[I])^ do
      If _Compare(_ExemptionCode, ExemptionCode, coEqual)
        then Result := True;

end;  {RemovedExemptionSortEntryExists}

{===================================================================}
Function ExemptionAppliesToCollection(CollectionType : String;
                                      ExemptionCode : String) : Boolean;

begin
  Result := False;

  case ExemptionCode[5] of
    '0' : Result := True;
    '1' : Result := _Compare(CollectionType, [CountyTaxType, TownTaxType, MunicipalTaxType], coEqual);
    '2' : Result := _Compare(CollectionType, [CountyTaxType, MunicipalTaxType], coEqual);
    '3' : Result := _Compare(CollectionType, [TownTaxType, MunicipalTaxType], coEqual);
    '4' : Result := _Compare(CollectionType, SchoolTaxType, coEqual);
    '5' : Result := _Compare(CollectionType, [CountyTaxType, SchoolTaxType], coEqual);
    '6' : Result := _Compare(CollectionType, [TownTaxType, MunicipalTaxType, SchoolTaxType], coEqual);
    '7' : Result := _Compare(CollectionType, VillageTaxType, coEqual);

  end;  {case ExemptionCode[5] of}

end;  {ExemptionAppliesToCollection}

{===================================================================}
Function AddRemovedExemptionInformationForOneExemption_OneYear(RemovedExemptionsList : TList;
                                                               BillingExemptionDetailsTable : TTable;
                                                               BillingRateList : TList;
                                                               RejectList : TList;
                                                               _SwisSBLKey : String;
                                                               _SchoolCode : String;
                                                               _ExemptionCode : String;
                                                               _HomesteadCode : String;
                                                               _AssessmentYear : String;
                                                               _EffectiveDate : TDateTime;
                                                               _RemovalDate : TDateTime;
                                                               CollectionType : String) : Boolean;

var
  BillingInformationExists : Boolean;
  ProrataRemovedExemptionPtr : ProrataRemovedExemptionPointer;
  ExemptionBillingTableName, TempStr, _CollectionNumber : String;
  I : Integer;

begin
  BillingInformationExists := True;
  Result := False;

  If _Compare(CollectionType, [CountyTaxType, TownTaxType, VillageTaxType, MunicipalTaxType], coEqual)
    then _CollectionNumber := '01';

  If _Compare(CollectionType, SchoolTaxType, coEqual)
    then
      For I := 0 to (BillingRateList.Count - 1) do
        with BillingRatePointer(BillingRateList[I])^ do
          If ((SchoolCode = _SchoolCode) and
              _Compare(CollectionType, SchoolTaxType, coEqual))
            then _CollectionNumber := ShiftRightAddZeroes(IntToStr(CollectionNumber), 2);

  GetBillingFileNames(_AssessmentYear, CollectionType, _CollectionNumber,
                      TempStr, TempStr, ExemptionBillingTableName,
                      TempStr, TempStr);

  BillingExemptionDetailsTable.Close;
  BillingExemptionDetailsTable.TableName := ExemptionBillingTableName;

  try
    BillingExemptionDetailsTable.Open;
  except
    BillingInformationExists := False;
  end;

  If BillingInformationExists
    then
      begin
          {CHG07102006-1(2.9.7.8): Temporary fix for split vet codes.}

        If (_Compare(_ExemptionCode, '41122', coEqual) and
           (not _Locate(BillingExemptionDetailsTable, [_SwisSBLKey, _ExemptionCode], '', [])))
          then _ExemptionCode := '41121';

        If (_Compare(_ExemptionCode, '41132', coEqual) and
            (not _Locate(BillingExemptionDetailsTable, [_SwisSBLKey, _ExemptionCode], '', [])))
          then _ExemptionCode := '41131';

        If (_Compare(_ExemptionCode, '41142', coEqual) and
            (not _Locate(BillingExemptionDetailsTable, [_SwisSBLKey, _ExemptionCode], '', [])))
          then _ExemptionCode := '41141';

        If _Locate(BillingExemptionDetailsTable, [_SwisSBLKey, _ExemptionCode], '', [])
          then
            with BillingExemptionDetailsTable do
              begin
                New(ProrataRemovedExemptionPtr);

                with ProrataRemovedExemptionPtr^ do
                  begin
                    ExemptionCode := _ExemptionCode;
                    AssessmentYear := _AssessmentYear;
                    HomesteadCode := _HomesteadCode;
                    CountyAmount := FieldByName('CountyAmount').AsInteger;
                    MunicipalAmount := FieldByName('TownAmount').AsInteger;
                    SchoolAmount := FieldByName('SchoolAmount').AsInteger;
                    EffectiveDate := _EffectiveDate;
                    RemovalDate := _RemovalDate;
                    CountyCalculated := False;
                    MunicipalCalculated := False;
                    SchoolCalculated := False;

                  end;  {with ProrataRemovedExemptionPtr^ do}

                RemovedExemptionsList.Add(ProrataRemovedExemptionPtr);
                Result := True;

              end;  {with BillingExemptionDetailsTable do}

      end  {If BillingInformationExists}
    else AddRejectOrWarningItem(RejectList, _SwisSBLKey, _SchoolCode, _ExemptionCode,
                                _EffectiveDate, _RemovalDate,
                                'No billing information found for the ' + _AssessmentYear + ' roll year.');

end;  {AddRemovedExemptionInformationForOneExemption_OneYear}

{===================================================================}
Procedure GetCollectionRangeForDate(    _Date : TDateTime;
                                        CollectionStartMonth : Integer;
                                        CollectionStartDay : Integer;
                                        CollectionType : String;
                                    var BillingYear : String);

var
  _Year, _Month, _Day : Word;
  CollectionYearStartDate, CollectionYearEndDate : TDateTime;

begin
  BillingYear := '';

  DecodeDate(_Date, _Year, _Month, _Day);
  CollectionYearStartDate := EncodeDate(_Year, CollectionStartMonth, CollectionStartDay);
  CollectionYearEndDate := EncodeDate((_Year + 1), CollectionStartMonth, CollectionStartDay);
  CollectionYearEndDate := CollectionYearEndDate - 1;

  If (_Compare(_Date, CollectionYearStartDate, coGreaterThanOrEqual) and
      _Compare(_Date, CollectionYearEndDate, coLessThanOrEqual))
    then BillingYear := IntToStr(_Year)
    else
      begin
        CollectionYearStartDate := EncodeDate((_Year - 1), CollectionStartMonth, CollectionStartDay);
        CollectionYearEndDate := EncodeDate(_Year, CollectionStartMonth, CollectionStartDay);
        CollectionYearEndDate := CollectionYearEndDate - 1;

        If (_Compare(_Date, CollectionYearStartDate, coGreaterThanOrEqual) and
            _Compare(_Date, CollectionYearEndDate, coLessThanOrEqual))
          then BillingYear := IntToStr(_Year - 1);

      end;  {If (_Compare(_Date, ...}

  If ((_Compare(CollectionType, CountyTaxType, coEqual) and
       (not GlblAssessmentYearIsSameAsTaxYearForCounty)) or
      (_Compare(CollectionType, [TownTaxType, VillageTaxType, MunicipalTaxType], coEqual) and
       (not GlblAssessmentYearIsSameAsTaxYearForMunicipal)) or
      (_Compare(CollectionType, SchoolTaxType, coEqual) and
       (not GlblAssessmentYearIsSameAsTaxYearForSchool)))
      then BillingYear := IntToStr(StrToInt(BillingYear) - 1);

end;  {GetCollectionRangeForDate}

{===================================================================}
Procedure AddRemovedExemptionInformationForOneExemption(RemovedExemptionsList : TList;
                                                        BillingExemptionDetailsTable : TTable;
                                                        BillingRateList : TList;
                                                        RejectList : TList;
                                                        WarningList : TList;
                                                        SwisSBLKey : String;
                                                        SchoolCode : String;
                                                        ExemptionCode : String;
                                                        HomesteadCode : String;
                                                        EffectiveDate : TDateTime;
                                                        RemovalDate : TDateTime;
                                                        CollectionStartMonth : Integer;
                                                        CollectionStartDay : Integer;
                                                        CollectionType : String);

var
  EffectiveDateBillingYear, RemovalDateBillingYear : String;
(*  RemovalSpansYears, ExemptionAdded : Boolean; *)

begin
  GetCollectionRangeForDate(EffectiveDate, CollectionStartMonth, CollectionStartDay,
                            CollectionType, EffectiveDateBillingYear);

  GetCollectionRangeForDate(RemovalDate, CollectionStartMonth, CollectionStartDay,
                            CollectionType, RemovalDateBillingYear);

  AddRemovedExemptionInformationForOneExemption_OneYear(RemovedExemptionsList,
                                                        BillingExemptionDetailsTable,
                                                        BillingRateList,
                                                        RejectList,
                                                        SwisSBLKey,
                                                        SchoolCode,
                                                        ExemptionCode,
                                                        HomesteadCode,
                                                        EffectiveDateBillingYear,
                                                        EffectiveDate,
                                                        RemovalDate,
                                                        CollectionType);

    {Now check the next billing year (if not greater than the current frozen
     roll) even if the removal date does not span years just in case
     they did not remove the exemption when they should have.
     However, warn them since this could be a case where the new owner got the
     exemption, too.}

(*  RemovalSpansYears := _Compare(EffectiveDateBillingYear, RemovalDateBillingYear, coNotEqual); *)
  EffectiveDateBillingYear := IncrementNumericString(EffectiveDateBillingYear, 1);
(*  ExemptionAdded := False; *)

  If ((_Compare(CollectionType, SchoolTaxType, coEqual) and
       _Compare(EffectiveDateBillingYear, GlblThisYear, coLessThan)) or
      (_Compare(CollectionType, [CountyTaxType, TownTaxType, MunicipalTaxType], coEqual) and
       _Compare(EffectiveDateBillingYear, GlblThisYear, coLessThan)) or
      (_Compare(CollectionType, [TownTaxType, VillageTaxType, MunicipalTaxType], coEqual) and
       GlblAssessmentYearIsSameAsTaxYearForMunicipal and
       _Compare(EffectiveDateBillingYear, GlblThisYear, coLessThanOrEqual)))
    then (*ExemptionAdded := *)AddRemovedExemptionInformationForOneExemption_OneYear(RemovedExemptionsList,
                                                                                 BillingExemptionDetailsTable,
                                                                                 BillingRateList,
                                                                                 RejectList,
                                                                                 SwisSBLKey,
                                                                                 SchoolCode,
                                                                                 ExemptionCode,
                                                                                 HomesteadCode,
                                                                                 EffectiveDateBillingYear,
                                                                                 EffectiveDate,
                                                                                 RemovalDate,
                                                                                 CollectionType);

(*  If ((not RemovalSpansYears) and
      ExemptionAdded)
    then AddRejectOrWarningItem(WarningList, SwisSBLKey, SchoolCode, ExemptionCode,
                                EffectiveDate, RemovalDate,
                                'Exemption found for ' + EffectiveDateBillingYear + ' roll year, but should have been removed.'); *)


end;  {AddRemovedExemptionInformationForOneExemption}

{===================================================================}
Procedure LoadRemovedExemptions(    RemovedExemptionsTable : TTable;
                                    BillingExemptionDetailsTable : TTable;
                                    BillingRateList : TList;
                                    RejectList : TList;
                                    WarningList : TList;
                                    SwisSBLKey : String;
                                    SchoolCode : String;
                                    CollectionType : String;
                                    CollectionStartMonth : Integer;
                                    CollectionStartDay : Integer;
                                    ParcelHomesteadCode : String;
                                    RemovedExemptionsList : TList;
                                    RemovedExemptionsToMarkCalculatedList : TStringList;
                                    ClearProrataInformation : Boolean;
                                    ProrataYear : String;
                                    dCutoffEffectiveDate : TDateTime;
                                var EffectiveDate : TDateTime;
                                var RemovalDate : TDateTime);

var
  Done, FirstTimeThrough : Boolean;
  RemovedExemptionSortPtr : RemovedExemptionSortPointer;
  RemovedExemptionSortList : TList;
  _EffectiveDate, _RemovalDate : TDateTime;
  _ExemptionCode : String;
  I : Integer;

begin
  RemovedExemptionSortList := TList.Create;

  Done := False;
  FirstTimeThrough := True;
  EffectiveDate := 0;
  _SetRange(RemovedExemptionsTable, [SwisSBLKey], [], '', [loSameEndingRange]);

  with RemovedExemptionsTable do
    repeat
      If FirstTimeThrough
        then FirstTimeThrough := False
        else Next;

      If EOF
        then Done := True;

        {CHG07142010-1(2.26.1.7)[I7779]: Add cut off effective date.}

      If ((not Done) and
          FieldByName('RemovedDueToSale').AsBoolean and
          _Compare(FieldByName('EffectiveDateRemoved').AsDateTime, dCutoffEffectiveDate, coLessThan) and
          (not ExemptionCalculatedForThisCollectionType(RemovedExemptionsTable, CollectionType,
                                                        ClearProrataInformation, ProrataYear)) and
          ExemptionAppliesToCollection(CollectionType, FieldByName('ExemptionCode').Text))
        then
          begin
            _ExemptionCode := FieldByName('ExemptionCode').Text;
            _EffectiveDate := FieldByName('EffectiveDateRemoved').AsDateTime;
            _RemovalDate := FieldByName('ActualDateRemoved').AsDateTime;

            If _Compare(_RemovalDate, _EffectiveDate, coLessThan)
              then AddRejectOrWarningItem(RejectList, SwisSBLKey, SchoolCode, _ExemptionCode,
                                          _EffectiveDate, _RemovalDate,
                                          'Removal date earlier than effective date.')
              else
                If not RemovedExemptionSortEntryExists(RemovedExemptionSortList, _ExemptionCode)
                  then
                    begin
                      New(RemovedExemptionSortPtr);

                      with RemovedExemptionSortPtr^ do
                        begin
                          ExemptionCode := _ExemptionCode;
                          EffectiveDate := _EffectiveDate;
                          HomesteadCode := FieldByName('HomesteadCode').Text;

                            {If there is no homestead code specified on the exemption,
                             then use the homestead code of the parcel.  The homestead
                             code will eventually be used to determine which rate to use.}

                          If _Compare(HomesteadCode, coBlank)
                            then HomesteadCode := ParcelHomesteadCode;

                          RemovalDate := _RemovalDate;

                        end;  {with RemovedExemptionSortPtr^ do}

                      RemovedExemptionSortList.Add(RemovedExemptionSortPtr);
                      RemovedExemptionsToMarkCalculatedList.Add(FieldByName('AutoIncrementID').Text);

                    end;  {If not RemovedExemptionSortEntryExists ...}

          end;  {If not Done}

    until Done;

    {Now go through the list of exemptions to prorate and load in the exemption
     information as of the time of billing.}

  ClearTList(RemovedExemptionsList, SizeOf(ProrataRemovedExemptionRecord));

  For I := 0 to (RemovedExemptionSortList.Count - 1) do
    with RemovedExemptionSortPointer(RemovedExemptionSortList[I])^ do
      AddRemovedExemptionInformationForOneExemption(RemovedExemptionsList,
                                                    BillingExemptionDetailsTable,
                                                    BillingRateList,
                                                    RejectList,
                                                    WarningList,
                                                    SwisSBLKey,
                                                    SchoolCode,
                                                    ExemptionCode,
                                                    HomesteadCode,
                                                    EffectiveDate,
                                                    RemovalDate,
                                                    CollectionStartMonth,
                                                    CollectionStartDay,
                                                    CollectionType);

  FreeTList(RemovedExemptionSortList, SizeOf(RemovedExemptionSortRecord));

end;  {LoadRemovedExemptions}

{===================================================================}
Function ProrateThisLevy(RemovedExemptionsRec : ProrataRemovedExemptionRecord;
                         _SwisCode : String;
                         _SchoolCode : String;
                         LeviesToProrateRec : LeviesToProrateRecord) : Boolean;

begin
  Result := False;

  If (LeviesToProrateRec.ProrateThisLevy and
      _Compare(LeviesToProrateRec.SwisCode, _SwisCode, coMatchesPartialOrFirstItemBlank) and
      _Compare(LeviesToProrateRec.SchoolCode, _SchoolCode, coMatchesPartialOrFirstItemBlank))
    then
      begin
        If ((LeviesToProrateRec.LevyType = ltCounty) and
            _Compare(RemovedExemptionsRec.CountyAmount, 0, coGreaterThan))
          then Result := True;

        If ((LeviesToProrateRec.LevyType in [ltMunicipal, ltVillage, ltTown, ltSpecialDistrict]) and
            _Compare(RemovedExemptionsRec.MunicipalAmount, 0, coGreaterThan))
          then Result := True;

        If ((LeviesToProrateRec.LevyType = ltSchool) and
            _Compare(RemovedExemptionsRec.SchoolAmount, 0, coGreaterThan))
          then Result := True;

      end;  {If LeviesToProrateRec.ProrateThisLevy}

end;  {ProrateThisLevy}

{===================================================================}
Function CalculateProrataDays(AssessmentYear : String;
                              EffectiveDate : TDateTime;
                              CollectionStartDay : Integer;
                              CollectionStartMonth : Integer) : Integer;

var                                       
  StartOfCollectionYear, StartOfNextCollectionYear : TDateTime;

begin
  StartOfCollectionYear := EncodeDate(StrToInt(AssessmentYear), CollectionStartMonth, CollectionStartDay);
  StartOfNextCollectionYear := EncodeDate(StrToInt(AssessmentYear) + 1, CollectionStartMonth, CollectionStartDay);

  If _Compare(EffectiveDate, StartOfCollectionYear, coLessThanOrEqual)
    then Result := Trunc(StartOfNextCollectionYear - StartOfCollectionYear)
    else
      If _Compare(EffectiveDate, StartOfNextCollectionYear, coLessThanOrEqual)
        then Result := Trunc((StartOfNextCollectionYear - 1) - EffectiveDate + 1)  {Apply until end of year and 1 day to make sure it is inclusive.}
        else Result := CalculateProrataDays(IncrementNumericString(AssessmentYear, 1),
                                            EffectiveDate, CollectionStartDay, CollectionStartMonth);

end;  {CalculateProrataDays}

{===================================================================}
Procedure CalculateProrataAmountAndAddToList(ProrataDetailsList : TList;
                                             BillingRateRec : BillingRateRecord;
                                             _ProrataYear : String;
                                             _AssessmentYear : String;
                                             _HomesteadCode : String;
                                             _ExemptionCode : String;
                                             _EffectiveDate : TDateTime;
                                             _RemovalDate : TDateTime;
                                             _ExemptionAmount : LongInt;
                                             _CalculationDays : LongInt;
                                             CollectionStartMonth : Integer;
                                             CollectionStartDay : Integer);

var
  ProrataDetailPtr : ProrataDetailPointer;
  _TaxRate, _TaxAmount : Double;
  DaysInCollection : Integer;
  CollectionYearStartDate, CollectionYearEndDate : TDateTime;

begin
  with BillingRateRec do
    begin
      CollectionYearStartDate := EncodeDate(StrToInt(AssessmentYear), CollectionStartMonth, CollectionStartDay);
      CollectionYearEndDate := EncodeDate(StrToInt(AssessmentYear) + 1, CollectionStartMonth, CollectionStartDay);

      DaysInCollection := Trunc(CollectionYearEndDate - CollectionYearStartDate);

      If (_Compare(_HomesteadCode, 'H', coMatchesOrFirstItemBlank) or
          (not GlblMunicipalityUsesTwoTaxRates))
        then _TaxRate := HomesteadRate
        else _TaxRate := NonHomesteadRate;

      _TaxAmount := (_ExemptionAmount / 1000) * _TaxRate * (_CalculationDays / DaysInCollection);
      _TaxAmount := Roundoff(_TaxAmount, 2);

    end;  {with BillingRateRec do}

  New(ProrataDetailPtr);

  with ProrataDetailPtr^ do
    begin
      ProrataYear := _ProrataYear;
      AssessmentYear := _AssessmentYear;
      GeneralTaxType := BillingRateRec.GeneralTaxType;
      HomesteadCode := _HomesteadCode;
      ExemptionCode := _ExemptionCode;
      LevyDescription := BillingRateRec.LevyDescription;
      EffectiveDate := _EffectiveDate;
      RemovalDate := _RemovalDate;
      CalculationDays := _CalculationDays;
      TaxRate := _TaxRate;
      ExemptionAmount := _ExemptionAmount;
      TaxAmount := _TaxAmount;

    end;  {with ProrataDetailPtr^ do}

  ProrataDetailsList.Add(ProrataDetailPtr);

end;  {CalculateProrataAmountAndAddToList}

{===================================================================}
Function FindBillingRateForCollection(BillingRateList : TList;
                                      _AssessmentYear : String;
                                      _PrintOrder : Integer;
                                      _SwisCode : String;
                                      _SchoolCode : String;
                                      _GeneralTaxType : String;
                                      _SpecialDistrictCode : String) : Integer;

var
  I : Integer;

begin
  Result := -1;

  For I := 0 to (BillingRateList.Count - 1) do
    with BillingRatePointer(BillingRateList[I])^ do
      If (_Compare(AssessmentYearBilledFrom, _AssessmentYear, coEqual) and
          ((_Compare(_SpecialDistrictCode, coNotBlank) and
            _Compare(_SpecialDistrictCode, SpecialDistrictCode, coEqual)) or
           (_Compare(_SpecialDistrictCode, coBlank) and
            _Compare(PrintOrder, _PrintOrder, coEqual) and
            _Compare(SwisCode, _SwisCode, coEqual) and
            _Compare(SchoolCode, _SchoolCode, coEqual) and
            _Compare(GeneralTaxType, _GeneralTaxType, coEqual))))
        then Result := I;

end;  {FindBillingRateForCollection}

{===================================================================}
Function SpecialDistrictInBilling(BillingSpecialDistrictDetailsTable : TTable;
                                  BillingRateRec : BillingRateRecord;
                                  SwisSBLKey : String) : Boolean;

var
  TempStr, SpecialDistrictBillingTableName : String;
  Continue : Boolean;

begin
  Result := False;
  Continue := True;

  with BillingSpecialDistrictDetailsTable, BillingRateRec do
    begin
      try
        GetBillingFileNames(AssessmentYearBilledFrom, CollectionType, '0' + IntToStr(CollectionNumber),
                            TempStr, TempStr, TempStr,
                            SpecialDistrictBillingTableName, TempStr);
        Close;
        TableName := SpecialDistrictBillingTableName;
        Open;
      except
        Continue := False;
      end;

      If Continue
        then Result := _Locate(BillingSpecialDistrictDetailsTable,
                               [SwisSBLKey, SpecialDistrictCode, ExtensionCode], '', []);

    end;  {with BillingSpecialDistrictDetailsTable, BillingRateRec do}

end;  {SpecialDistrictInBilling}

{===================================================================}
Procedure CalculateProrataDetailsForOneRemovedExemption(RemovedExemptionRec : ProrataRemovedExemptionRecord;
                                                        SpecialDistrictCodeTable : TTable;
                                                        ExemptionCodeTable : TTable;
                                                        BillingSpecialDistrictDetailsTable : TTable;
                                                        ProrataYear : String;
                                                        SwisCode : String;
                                                        SchoolCode : String;
                                                        SwisSBLKey : String;
                                                        ProrataDetailsList : TList;
                                                        LeviesToProrateList : TList;
                                                        BillingRateList : TList;
                                                        CalculationDate : TDateTime;
                                                        CollectionStartDay : Integer;
                                                        CollectionStartMonth : Integer);

var
  I, Index, ProrataDays : Integer;

begin
  For I := 0 to (LeviesToProrateList.Count - 1) do
    If ProrateThisLevy(RemovedExemptionRec, SwisCode, SchoolCode,
                       LeviesToProratePointer(LeviesToProrateList[I])^)
      then
        begin
          with LeviesToProratePointer(LeviesToProrateList[I])^ do
            Index := FindBillingRateForCollection(BillingRateList,
                                                  RemovedExemptionRec.AssessmentYear,
                                                  PrintOrder,
                                                  SwisCode,
                                                  SchoolCode,
                                                  GeneralTaxType,
                                                  SpecialDistrictCode);

          If ((Index > -1) and
              (_Compare(BillingRatePointer(BillingRateList[Index])^.HomesteadRate, 0, coGreaterThan) or
               _Compare(BillingRatePointer(BillingRateList[Index])^.NonHomesteadRate, 0, coGreaterThan)))
            then
              begin
                ProrataDays := CalculateProrataDays(BillingRatePointer(BillingRateList[Index])^.AssessmentYear,
                                                    RemovedExemptionRec.EffectiveDate,
                                                    CollectionStartDay,
                                                    CollectionStartMonth);

                If (LeviesToProratePointer(LeviesToProrateList[I])^.LevyType = ltCounty)
                  then
                    begin
                      CalculateProrataAmountAndAddToList(ProrataDetailsList,
                                                         BillingRatePointer(BillingRateList[Index])^,
                                                         ProrataYear,
                                                         BillingRatePointer(BillingRateList[Index])^.AssessmentYearBilledFrom,
                                                         RemovedExemptionRec.HomesteadCode,
                                                         RemovedExemptionRec.ExemptionCode,
                                                         RemovedExemptionRec.EffectiveDate,
                                                         RemovedExemptionRec.RemovalDate,
                                                         RemovedExemptionRec.CountyAmount,
                                                         ProrataDays,
                                                         CollectionStartMonth,
                                                         CollectionStartDay);

                      RemovedExemptionRec.CountyCalculated := True;

                    end;  {If ((LeviesToProratePointer(LeviesToProrateList[I])...}

                If ((LeviesToProratePointer(LeviesToProrateList[I])^.LevyType = ltMunicipal) or
                    ((LeviesToProratePointer(LeviesToProrateList[I])^.LevyType = ltSpecialDistrict) and
                     ExemptionAppliesToSpecialDistrict(SpecialDistrictCodeTable,
                                                       ExemptionCodeTable,
                                                       LeviesToProratePointer(LeviesToProrateList[I])^.SpecialDistrictCode,
                                                       RemovedExemptionRec.ExemptionCode)) and
                     SpecialDistrictInBilling(BillingSpecialDistrictDetailsTable,
                                              BillingRatePointer(BillingRateList[Index])^,
                                              SwisSBLKey))
                  then
                    begin
                      CalculateProrataAmountAndAddToList(ProrataDetailsList,
                                                         BillingRatePointer(BillingRateList[Index])^,
                                                         ProrataYear,
                                                         BillingRatePointer(BillingRateList[Index])^.AssessmentYearBilledFrom,
                                                         RemovedExemptionRec.HomesteadCode,
                                                         RemovedExemptionRec.ExemptionCode,
                                                         RemovedExemptionRec.EffectiveDate,
                                                         RemovedExemptionRec.RemovalDate,
                                                         RemovedExemptionRec.MunicipalAmount,
                                                         ProrataDays,
                                                         CollectionStartMonth,
                                                         CollectionStartDay);

                      RemovedExemptionRec.MunicipalCalculated := True;

                    end;  {If ((LeviesToProratePointer(LeviesToProrateList[I])...}

                If (LeviesToProratePointer(LeviesToProrateList[I])^.LevyType = ltSchool)
                  then
                    begin
                      CalculateProrataAmountAndAddToList(ProrataDetailsList,
                                                         BillingRatePointer(BillingRateList[Index])^,
                                                         ProrataYear,
                                                         BillingRatePointer(BillingRateList[Index])^.AssessmentYearBilledFrom,
                                                         RemovedExemptionRec.HomesteadCode,
                                                         RemovedExemptionRec.ExemptionCode,
                                                         RemovedExemptionRec.EffectiveDate,
                                                         RemovedExemptionRec.RemovalDate,
                                                         RemovedExemptionRec.SchoolAmount,
                                                         ProrataDays,
                                                         CollectionStartMonth,
                                                         CollectionStartDay);

                      RemovedExemptionRec.SchoolCalculated := True;

                    end;  {If ((LeviesToProratePointer(LeviesToProrateList[I])...}

              end;  {If (Index > -1)}

        end;  {If ProrateThisLevy...}

end;  {CalculateProrataDetailsForOneRemovedExemption}

{===================================================================}
Procedure CalculateProrataDetails(    ProrataDetailsList : TList;
                                      RemovedExemptionsList : TList;
                                      LeviesToProrateList : TList;
                                      BillingRateList : TList;
                                      SpecialDistrictCodeTable : TTable;
                                      ExemptionCodeTable : TTable;
                                      BillingSpecialDistrictDetailsTable : TTable;
                                      ProrataYear : String;
                                      SwisCode : String;
                                      SchoolCode : String;
                                      SwisSBLKey : String;
                                      CalculationDate : TDateTime;
                                      CollectionStartDay : Integer;
                                      CollectionStartMonth : Integer;
                                  var EffectiveDate : TDateTime);

var
  I : Integer;

begin
  ClearTList(ProrataDetailsList, SizeOf(ProrataDetailRecord));

  For I := 0 to (RemovedExemptionsList.Count - 1) do
    begin
      EffectiveDate := ProrataRemovedExemptionPointer(RemovedExemptionsList[I])^.EffectiveDate;

      CalculateProrataDetailsForOneRemovedExemption(ProrataRemovedExemptionPointer(RemovedExemptionsList[I])^,
                                                    SpecialDistrictCodeTable,
                                                    ExemptionCodeTable,
                                                    BillingSpecialDistrictDetailsTable,
                                                    ProrataYear,
                                                    SwisCode,
                                                    SchoolCode,
                                                    SwisSBLKey,
                                                    ProrataDetailsList,
                                                    LeviesToProrateList,
                                                    BillingRateList,
                                                    CalculationDate,
                                                    CollectionStartDay,
                                                    CollectionStartMonth);

    end;  {For I := 0 to (RemovedExemptionsList.Count - 1) do}

end;  {CalculateProrataDetails}

{===================================================================}
Procedure StoreProrataExemptions(ProrataExemptionsTable : TTable;
                                 SwisSBLKey : String;
                                 ProrataYear : String;
                                 _Category : String;
                                 RemovedExemptionsList : TList);

var
  I : Integer;

begin
  For I := 0 to (RemovedExemptionsList.Count - 1) do
    with ProrataRemovedExemptionPointer(RemovedExemptionsList[I])^ do
      _InsertRecord(ProrataExemptionsTable,
                    ['SwisSBLKey', 'ProrataYear', 'TaxRollYr', 'ExemptionCode',
                     'HomesteadCode', 'CountyAmount', 'TownAmount', 'SchoolAmount',
                     'Category'],
                    [SwisSBLKey, ProrataYear, AssessmentYear, ExemptionCode,
                     HomesteadCode, CountyAmount, MunicipalAmount, SchoolAmount,
                     _Category], []);

end;  {StoreProrataExemptions}

{===================================================================}
Procedure StoreProrataDetails(ProrataDetailsTable : TTable;
                              SwisSBLKey : String;
                              _ProrataYear : String;
                              _Category : String;
                              ProrataDetailsList : TList);

var
  I : Integer;

begin
  For I := 0 to (ProrataDetailsList.Count - 1) do
    with ProrataDetailPointer(ProrataDetailsList[I])^ do
      _InsertRecord(ProrataDetailsTable,
                    ['SwisSBLKey', 'ProrataYear', 'Category', 'TaxRollYr',
                     'GeneralTaxType', 'HomesteadCode', 'Days', 'TaxRate',
                     'ExemptionAmount', 'TaxAmount', 'LevyDescription'],
                    [SwisSBLKey, _ProrataYear, _Category, AssessmentYear,
                     GeneralTaxType, HomesteadCode, CalculationDays, TaxRate,
                     ExemptionAmount, TaxAmount, LevyDescription], []);

end;  {StoreProrataDetails}

{===================================================================}
Procedure StoreProrataHeader(ProrataHeaderTable : TTable;
                             ParcelTable : TTable;
                             SwisSBLKey : String;
                             ProrataYear : String;
                             _Category : String;
                             CalculationDate : TDateTime;
                             EffectiveDate : TDateTime;
                             RemovalDate : TDateTime);

begin
  with ParcelTable do
    _InsertRecord(ProrataHeaderTable,
                  ['SwisSBLKey', 'ProrataYear', 'Name1', 'Name2',
                   'Address1', 'Address2', 'Street', 'City',
                   'State', 'Zip', 'ZipPlus4', 'CalculationDate',
                   'SaleDate', 'SchoolCode', 'Category', 'RemovalDate',
                   'ManualEntry'],
                  [SwisSBLKey, ProrataYear, FieldByName('Name1').Text, FieldByName('Name2').Text,
                   FieldByName('Address1').Text, FieldByName('Address2').Text, FieldByName('Street').Text, FieldByName('City').Text,
                   FieldByName('State').Text, FieldByName('Zip').Text, FieldByName('ZipPlus4').Text, DateToStr(CalculationDate),
                   DateToStr(EffectiveDate), FieldByName('SchoolCode').Text, _Category, DateToStr(RemovalDate),
                   'False'], []);

end;  {StoreProrataHeader}

{===================================================================}
Procedure PrintMainSectionHeaders(Sender : TObject);

begin
  with Sender as TBaseReport do
    begin
      ClearTabs;
      SetTab(0.4, pjCenter, 1.4, 0, BOXLINENone, 0);   {Parcel ID}
      SetTab(1.9, pjCenter, 1.1, 0, BOXLINENone, 0);   {Owner}
      SetTab(3.1, pjCenter, 0.5, 0, BOXLINENone, 0);   {School code}
      SetTab(3.7, pjCenter, 0.3, 0, BOXLINENone, 0);   {Assessment Year}
      SetTab(4.1, pjCenter, 0.7, 0, BOXLINENone, 0);   {Effective Date}
      SetTab(4.9, pjCenter, 0.7, 0, BOXLINENone, 0);   {Removal Date}
      SetTab(5.7, pjCenter, 0.3, 0, BOXLINENone, 0);   {General Tax Type}
      SetTab(6.1, pjCenter, 1.3, 0, BOXLINENone, 0);   {Levy Description}
      SetTab(7.5, pjCenter, 0.5, 0, BOXLINENone, 0);   {Exemption Code}
      SetTab(8.1, pjCenter, 0.3, 0, BOXLINENone, 0);   {Calculation days}
      SetTab(8.5, pjCenter, 0.7, 0, BOXLINENone, 0);   {Exemption amount}
      SetTab(9.3, pjCenter, 0.7, 0, BOXLINENone, 0);   {Tax Rate}
      SetTab(10.1, pjCenter, 0.7, 0, BOXLINENone, 0);   {Tax amount}

      Println(#9 + #9 +
              #9 + 'School' +
              #9 + 'Roll' +
              #9 + 'Effective' +
              #9 + 'Removal' +
              #9 + 'Tax' +
              #9 + 'Levy' +
              #9 + 'Exempt' +
              #9 + 'Calc' +
              #9 + 'Exemption' +
              #9 + 'Tax' +
              #9 + 'Prorata');

      ClearTabs;
      SetTab(0.4, pjCenter, 1.4, 0, BOXLINEBottom, 0);   {Parcel ID}
      SetTab(1.9, pjCenter, 1.1, 0, BOXLINEBottom, 0);   {Owner}
      SetTab(3.1, pjCenter, 0.5, 0, BOXLINEBottom, 0);   {School code}
      SetTab(3.7, pjCenter, 0.3, 0, BOXLINEBottom, 0);   {Assessment Year}
      SetTab(4.1, pjCenter, 0.7, 0, BOXLINEBottom, 0);   {Effective Date}
      SetTab(4.9, pjCenter, 0.7, 0, BOXLINEBottom, 0);   {Removal Date}
      SetTab(5.7, pjCenter, 0.3, 0, BOXLINEBottom, 0);   {General Tax Type}
      SetTab(6.1, pjCenter, 1.3, 0, BOXLINEBottom, 0);   {Levy Description}
      SetTab(7.5, pjCenter, 0.5, 0, BOXLINEBottom, 0);   {Exemption Code}
      SetTab(8.1, pjCenter, 0.3, 0, BOXLINEBottom, 0);   {Calculation days}
      SetTab(8.5, pjCenter, 0.7, 0, BOXLINEBottom, 0);   {Exemption amount}
      SetTab(9.3, pjCenter, 0.7, 0, BOXLINEBottom, 0);   {Tax Rate}
      SetTab(10.1, pjCenter, 0.7, 0, BOXLINEBottom, 0);   {Tax amount}

      Println(#9 + 'Parcel ID' +
              #9 + 'Owner' +
              #9 + 'Code' +
              #9 + 'Year' +
              #9 + 'Date' +
              #9 + 'Date' +
              #9 + 'Type' +
              #9 + 'Description' +
              #9 + 'Code' +
              #9 + 'Days' +
              #9 + 'Amount' +
              #9 + 'Rate' +
              #9 + 'Amount');

      ClearTabs;
      SetTab(0.4, pjLeft, 1.4, 0, BOXLINENone, 0);   {Parcel ID}
      SetTab(1.9, pjLeft, 1.9, 0, BOXLINENone, 0);   {Owner}
      SetTab(3.1, pjLeft, 0.5, 0, BOXLINENone, 0);   {School code}
      SetTab(3.7, pjLeft, 0.3, 0, BOXLINENone, 0);   {Assessment Year}
      SetTab(4.1, pjLeft, 0.7, 0, BOXLINENone, 0);   {Effective Date}
      SetTab(4.9, pjLeft, 0.7, 0, BOXLINENone, 0);   {Removal Date}
      SetTab(5.7, pjLeft, 0.3, 0, BOXLINENone, 0);   {General Tax Type}
      SetTab(6.1, pjLeft, 1.3, 0, BOXLINENone, 0);   {Levy Description}
      SetTab(7.5, pjLeft, 0.5, 0, BOXLINENone, 0);   {Exemption Code}
      SetTab(8.1, pjRight, 0.3, 0, BOXLINENone, 0);   {Calculation days}
      SetTab(8.5, pjRight, 0.7, 0, BOXLINENone, 0);   {Exemption amount}
      SetTab(9.3, pjRight, 0.7, 0, BOXLINENone, 0);   {Tax Rate}
      SetTab(10.1, pjRight, 0.7, 0, BOXLINENone, 0);   {Tax amount}

    end;  {with Sender as TBaseReport do}

end;  {PrintMainSectionHeaders}

{===================================================================}
Procedure TCalculateProrataInformationForm.PrintRejectOrWarningSectionHeaders(Sender : TObject);

begin
  with Sender as TBaseReport do
    begin
      Println('');
      ClearTabs;
      SetTab(0.4, pjLeft, 5.0, 0, BOXLINENone, 0);   {Header}

      Underline := True;
      Bold := True;

      case ReportSection of
        rsReject : Println(#9 + 'Rejected removed exemptions:');
        rsWarning : Println(#9 + 'Prorata calculation warnings:');
      end;

      Underline := False;
      Bold := False;

      Println('');

      ClearTabs;
      SetTab(0.4, pjCenter, 1.0, 0, BOXLINENone, 0);   {Parcel ID}
      SetTab(1.5, pjCenter, 0.5, 0, BOXLINENone, 0);   {School code}
      SetTab(2.1, pjCenter, 0.5, 0, BOXLINENone, 0);   {Exemption code}
      SetTab(2.7, pjCenter, 0.8, 0, BOXLINENone, 0);   {Effective Date}
      SetTab(3.6, pjCenter, 0.8, 0, BOXLINENone, 0);   {Removal Date}
      SetTab(4.5, pjCenter, 3.6, 0, BOXLINENone, 0);   {Reason}

      Println(#9 +
              #9 + 'School' +
              #9 + 'EX' +
              #9 + 'Effective' +
              #9 + 'Removal');

      ClearTabs;
      SetTab(0.4, pjCenter, 1.0, 0, BOXLINEBottom, 0);   {Parcel ID}
      SetTab(1.5, pjCenter, 0.5, 0, BOXLINEBottom, 0);   {School code}
      SetTab(2.1, pjCenter, 0.5, 0, BOXLINEBottom, 0);   {Exemption code}
      SetTab(2.7, pjCenter, 0.8, 0, BOXLINEBottom, 0);   {Effective Date}
      SetTab(3.6, pjCenter, 0.8, 0, BOXLINEBottom, 0);   {Removal Date}
      SetTab(4.5, pjCenter, 3.6, 0, BOXLINEBottom, 0);   {Reason}

      Println(#9 + 'Parcel ID' +
              #9 + 'Code' +
              #9 + 'Code' +
              #9 + 'Date' +
              #9 + 'Date' +
              #9 + 'Reason');

      ClearTabs;
      SetTab(0.4, pjLeft, 1.0, 0, BOXLINENone, 0);   {Parcel ID}
      SetTab(1.5, pjLeft, 0.5, 0, BOXLINENone, 0);   {School code}
      SetTab(2.1, pjLeft, 0.5, 0, BOXLINENone, 0);   {Exemption code}
      SetTab(2.7, pjLeft, 0.8, 0, BOXLINENone, 0);   {Effective Date}
      SetTab(3.6, pjLeft, 0.8, 0, BOXLINENone, 0);   {Removal Date}
      SetTab(4.5, pjLeft, 3.6, 0, BOXLINENone, 0);   {Reason}

    end;  {with Sender as TBaseReport do}

end;  {PrintRejectOrWarningSectionHeaders}

{===================================================================}
Procedure TCalculateProrataInformationForm.ReportPrintHeader(Sender: TObject);

begin
  with Sender as TBaseReport do
    begin
        {Print the date and page number.}

      SectionTop := 0.25;
      SectionLeft := 0.5;
      SectionRight := PageWidth - 0.5;
      SetFont('Times New Roman',8);
      PrintHeader('Page: ' + IntToStr(CurrentPage), pjRight);
      PrintHeader('Date: ' + DateToStr(Date) + '  Time: ' + TimeToStr(Now), pjLeft);

      SectionTop := 0.5;
      SetFont('Arial',12);
      Bold := True;
      Home;
      PrintCenter('Prorata Information', (PageWidth / 2));
      SetFont('Times New Roman', 9);
      CRLF;
      Println('');

      case ReportSection of
        rsMain : PrintMainSectionHeaders(Sender);
        rsReject : PrintRejectOrWarningSectionHeaders(Sender);
        rsWarning : PrintRejectOrWarningSectionHeaders(Sender);

      end;  {case ReportSection of}

    end;  {with Sender as TBaseReport do}

end;  {ReportPrintHeader}

{===================================================================}
Procedure ClearProrataInformationForCollection(ProrataYear : String;
                                               _Category : String;
                                               CollectionType : String;
                                               ProrataHeaderTable : TTable;
                                               ProrataDetailsTable : TTable;
                                               ProrataExemptionsTable : TTable;
                                               RemovedExemptionsTable : TTable);

var
  Done, FirstTimeThrough : Boolean;
  SwisSBLKey : String;

begin
  with ProrataHeaderTable do
    begin
      First;

        {FXX06282007-1(2.11.1.40)[D868]: Only clear the appropriate category.}

      while (not EOF) do
        begin
          If ((not FieldByName('ManualEntry').AsBoolean) and
              _Compare(FieldByName('Category').AsString, _Category, coEqual))
            then
              begin
                SwisSBLKey := FieldByName('SwisSBLKey').AsString;

                _SetRange(ProrataDetailsTable, [SwisSBLKey, ProrataYear, _Category], [], '', [loSameEndingRange]);
                DeleteTableRange(ProrataDetailsTable);

                _SetRange(ProrataExemptionsTable, [SwisSBLKey, ProrataYear, _Category], [], '', [loSameEndingRange]);
                DeleteTableRange(ProrataExemptionsTable);

                try
                  Delete;
                except
                end;

              end  {If not FieldByName('ManualEntry').AsBoolean}
            else Next;

        end;  {while (not EOF) do}

    end;  {with ProrataHeaderTable do}

    {Go through the removed exemptions and clear all prorata calculation years for this category.}

  Done := False;
  FirstTimeThrough := True;
  RemovedExemptionsTable.First;

  with RemovedExemptionsTable do
    repeat
      If FirstTimeThrough
        then FirstTimeThrough := False
        else Next;

      If EOF
        then Done := True;

      If not Done
        then
          try
            Edit;

            If (_Compare(CollectionType, SchoolTaxType, coEqual) and
                _Compare(FieldByName('SchoolProrataCalcYear').Text, ProrataYear, coEqual))
              then FieldByName('SchoolProrataCalcYear').Text := '';

            If (_Compare(CollectionType, [CountyTaxType, MunicipalTaxType], coEqual) and
                _Compare(FieldByName('CountyProrataCalcYear').Text, ProrataYear, coEqual))
              then FieldByName('CountyProrataCalcYear').Text := '';

            If (_Compare(CollectionType, [TownTaxType, MunicipalTaxType], coEqual) and
                _Compare(FieldByName('MunicipalProrataCalcYear').Text, ProrataYear, coEqual))
              then FieldByName('MunicipalProrataCalcYear').Text := '';

            Post;
          except
          end;

    until Done;

end;  {ClearProrataInformation}

{===================================================================}
Function FindTotalsRecordInTotalsList(ProrataTotalsList : TList;
                                      _LevyDescription : String) : Integer;

var
  I : Integer;

begin
  Result := -1;

  For I := 0 to (ProrataTotalsList.Count - 1) do
    with ProrataTotalsPointer(ProrataTotalsList[I])^ do
      If _Compare(LevyDescription, _LevyDescription, coEqual)
        then Result := I;

end;  {FindTotalsRecordInTotalsList}

{===================================================================}
Procedure UpdateTotalsList(ProrataTotalsList : TList;
                           _LevyDescription : String;
                           _ExemptionAmount : LongInt;
                           _TaxRate : Double;
                           _TaxAmount : Double);

var
  Index : Integer;
  ProrataTotalsPtr : ProrataTotalsPointer;

begin
  Index := FindTotalsRecordInTotalsList(ProrataTotalsList, _LevyDescription);

  If _Compare(Index, -1, coEqual)
    then
      begin
        New(ProrataTotalsPtr);

        with ProrataTotalsPtr^ do
          begin
            LevyDescription := _LevyDescription;
            AssessedValue := 0;
            TaxAmount := 0;
            TaxRate := _TaxRate;
            Count := 0;

          end;  {with ProrataTotalsPtr^ do}

        ProrataTotalsList.Add(ProrataTotalsPtr);

        Index := FindTotalsRecordInTotalsList(ProrataTotalsList, _LevyDescription);

      end;  {If _Compare(Index, -1, coEqual)}

  with ProrataTotalsPointer(ProrataTotalsList[Index])^ do
    begin
      Inc(Count);
      AssessedValue := AssessedValue + _ExemptionAmount;
      TaxAmount := TaxAmount + _TaxAmount;
    end;

end;  {UpdateTotalsList}

{===================================================================}
Procedure PrintProrataTotalsHeader(Sender : TObject);

begin
  with Sender as TBaseReport do
    begin
      Bold := True;
      Underline := True;
      Println(#9 + 'Prorata Total Details:');
      Bold := False;
      Underline := False;

      ClearTabs;
      SetTab(0.4, pjCenter, 2.0, 0, BOXLINEBottom, 0);   {Levy Description}
      SetTab(2.5, pjCenter, 0.5, 0, BOXLINEBottom, 0);   {Count}
      SetTab(3.1, pjCenter, 1.0, 0, BOXLINEBottom, 0);   {Assessed Value}
      SetTab(4.2, pjCenter, 0.7, 0, BOXLINEBottom, 0);   {Tax Rate}
      SetTab(5.0, pjCenter, 1.0, 0, BOXLINEBottom, 0);   {Amount}

      Println(#9 + 'Levy Description' +
              #9 + 'Count' +
              #9 + 'Assessed Value' +
              #9 + 'Tax Rate' +
              #9 + 'Amount');

      ClearTabs;
      SetTab(0.4, pjLeft, 2.0, 0, BOXLINENone, 0);   {Levy Description}
      SetTab(2.5, pjRight, 0.5, 0, BOXLINENone, 0);   {Count}
      SetTab(3.1, pjRight, 1.0, 0, BOXLINENone, 0);   {Assessed Value}
      SetTab(4.2, pjRight, 0.7, 0, BOXLINENone, 0);   {Tax Rate}
      SetTab(5.0, pjRight, 1.0, 0, BOXLINENone, 0);   {Amount}

    end;  {with Sender as TBaseReport do}

end;  {PrintProrataTotalsHeader}

{===================================================================}
Procedure TCalculateProrataInformationForm.PrintProrataTotals(Sender : TObject;
                                                              ProrataTotalsList : TList);

var
  I : Integer;

begin
  with Sender as TBaseReport do
    begin
      Println('');
      If (LinesLeft < 12)
        then NewPage;
      PrintProrataTotalsHeader(Sender);

      If ExtractToExcel
        then
          begin
            WritelnCommaDelimitedLine(ExtractFile, ['']);
            WritelnCommaDelimitedLine(ExtractFile,
                                      ['Levy Description',
                                       'Count',
                                       'Assessed Value',
                                       'Tax Rate',
                                       'Amount']);

          end;  {If ExtractToExcel}

      For I := 0 to (ProrataTotalsList.Count - 1) do
        with ProrataTotalsPointer(ProrataTotalsList[I])^ do
          begin
            If (LinesLeft < 5)
              then
                begin
                  NewPage;
                  PrintProrataTotalsHeader(Sender);
                end;

            Println(#9 + LevyDescription +
                    #9 + IntToStr(Count) +
                    #9 + FormatFloat(IntegerDisplay, AssessedValue) +
                    #9 + FormatFloat(ExtendedDecimalDisplay, TaxRate) +
                    #9 + FormatFloat(DecimalDisplay, TaxAmount));

            If ExtractToExcel
              then WritelnCommaDelimitedLine(ExtractFile,
                                             [LevyDescription,
                                              Count,
                                              AssessedValue,
                                              TaxRate,
                                              TaxAmount]);

          end;  {with ProrataTotalsPointer(ProrataTotalsList[I])^ do}

    end;  {with Sender as TBaseReport do}

end;  {PrintProrataTotals}

{===================================================================}
Procedure TCalculateProrataInformationForm.PrintRejectOrWarningSection(Sender : TObject;
                                                                       RejectOrWarningList : TList);

var
  I : Integer;

begin
  with Sender as TBaseReport do
    begin
      If (LinesLeft > 12)
        then PrintRejectOrWarningSectionHeaders(Sender)
        else NewPage;

      If ExtractToExcel
        then
          begin
            WritelnCommaDelimitedLine(ExtractFile, ['']);
            WritelnCommaDelimitedLine(ExtractFile,
                                      ['Parcel ID',
                                       'School Code',
                                       'EX Code',
                                       'Effective Date',
                                       'Removal Date',
                                       'Reason']);

          end;  {If ExtractToExcel}

      For I := 0 to (RejectOrWarningList.Count - 1) do
        with RejectOrWarningPointer(RejectOrWarningList[I])^ do
          begin
            If (LinesLeft < 10)
              then NewPage;

            Println(#9 + ParcelID +
                    #9 + SchoolCode +
                    #9 + ExemptionCode +
                    #9 + DateToStr(EffectiveDate) +
                    #9 + DateToStr(RemovalDate) +
                    #9 + Reason);

            If ExtractToExcel
              then WritelnCommaDelimitedLine(ExtractFile,
                                             [ParcelID,
                                              SchoolCode,
                                              ExemptionCode,
                                              DateToStr(EffectiveDate),
                                              DateToStr(RemovalDate),
                                              Reason]);

          end;  {with RejectOrWarningPointer(RejectOrWarningList[I])^ do}

    end;  {with Sender as TBaseReport do}

end;  {PrintRejectOrWarningSection}

{===================================================================}
Procedure MarkExemptionsCalculated(RemovedExemptionsTable : TTable;
                                   RemovedExemptionsToMarkCalculatedList : TStringList;
                                   CollectionType : String;
                                   ProrataYear : String);

var
  I : Integer;

begin
  RemovedExemptionsTable.IndexName := 'BYAUTOINCREMENTID';
  For I := 0 to (RemovedExemptionsToMarkCalculatedList.Count - 1) do
    If _Locate(RemovedExemptionsTable, [RemovedExemptionsToMarkCalculatedList[I]], '', [])
      then
        with RemovedExemptionsTable do
          try
            Edit;

            If _Compare(CollectionType, SchoolTaxType, coEqual)
              then FieldByName('SchoolProrataCalcYear').Text := ProrataYear;

            If _Compare(CollectionType, [CountyTaxType, MunicipalTaxType], coEqual)
              then FieldByName('CountyProrataCalcYear').Text := ProrataYear;

            If _Compare(CollectionType, [TownTaxType, MunicipalTaxType], coEqual)
              then FieldByName('MunicipalProrataCalcYear').Text := ProrataYear;

            Post;
          except
          end;

  RemovedExemptionsTable.IndexName := 'BYSWISSBLKEY';

end;  {MarkExemptionsCalculated}

{===================================================================}
Procedure TCalculateProrataInformationForm.ReportPrint(Sender: TObject);

var
  Done, FirstTimeThrough, _PrintHeader : Boolean;
  SwisSBLKey, SchoolCode, StoredProrataYear : String;
  RemovedExemptionsList, ProrataDetailsList, ProrataTotalsList : TList;
  RemovedExemptionsToMarkCalculatedList : TStringList;
  EffectiveDate, RemovalDate : TDateTime;
  I, ProratasFound : Integer;
  TotalProrata, ProrataThisParcel : Double;
  TempParcelTable : TTable;

begin
  TotalProrata := 0;
  ProratasFound := 0;
  ParcelTable.First;
  Done := False;
  FirstTimeThrough := True;
  RemovedExemptionsList := TList.Create;
  ProrataDetailsList := TList.Create;
  ProrataTotalsList := TList.Create;
  RemovedExemptionsToMarkCalculatedList := TStringList.Create;
  StoredProrataYear := ProrataYear;

  If ProrataYearIsNextYear
    then ProrataYear := IncrementNumericString(ProrataYear, -1);

    {FXX11152005-1(2.9.4.1): Don't do this if it is trial run!}

  If (ClearProrataInformation and
      (not TrialRun))
    then ClearProrataInformationForCollection(StoredProrataYear, _Category,
                                              CollectionType,
                                              ProrataHeaderTable,
                                              ProrataDetailsTable,
                                              ProrataExemptionsTable,
                                              RemovedExemptionsTable);

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else ParcelTable.Next;

    If ParcelTable.EOF
      then Done := True;

    SwisSBLKey := ExtractSSKey(ParcelTable);
    ProgressDialog.Update(Self, ConvertSwisSBLToDashDot(SwisSBLKey));
    ProgressDialog.UserLabelCaption := 'Proratas Added = ' + IntToStr(ProratasFound);
    Application.ProcessMessages;

    If not Done
      then
        begin
          LoadRemovedExemptions(RemovedExemptionsTable, BillingExemptionDetailsTable,
                                BillingRateList, RejectList, WarningList, SwisSBLKey,
                                ParcelTable.FieldByName('SchoolCode').Text, CollectionType,
                                CollectionStartMonth, CollectionStartDay,
                                ParcelTable.FieldByName('HomesteadCode').Text,
                                RemovedExemptionsList,
                                RemovedExemptionsToMarkCalculatedList,
                                ClearProrataInformation, ProrataYear,
                                dCutoffEffectiveDate, EffectiveDate, RemovalDate);

          If (RemovedExemptionsList.Count > 0)
            then
              begin
                ProratasFound := ProratasFound + 1;

                If _Compare(CollectionType, SchoolTaxType, coEqual)
                  then SchoolCode := ParcelTable.FieldByName('SchoolCode').Text
                  else SchoolCode := '';

                CalculateProrataDetails(ProrataDetailsList,
                                        RemovedExemptionsList,
                                        LeviesToProrateList,
                                        BillingRateList,
                                        SpecialDistrictCodeTable,
                                        ExemptionCodeTable,
                                        BillingSpecialDistrictDetailsTable,
                                        ProrataYear,
                                        Copy(SwisSBLKey, 1, 6),
                                        SchoolCode,
                                        SwisSBLKey,
                                        CalculationDate,
                                        CollectionStartDay,
                                        CollectionStartMonth,
                                        EffectiveDate);

                  {FXX08032006-1(2.10.1.2): Make sure to use the most recent owner.}

                If _Locate(NYParcelTable, [GlblNextYear, SwisSBLKey], '', [loParseSwisSBLKey])
                  then TempParcelTable := NYParcelTable
                  else TempParcelTable := ParcelTable;

                If not TrialRun
                  then
                    begin
                      StoreProrataExemptions(ProrataExemptionsTable, SwisSBLKey,
                                             StoredProrataYear, _Category, RemovedExemptionsList);
                      StoreProrataDetails(ProrataDetailsTable, SwisSBLKey,
                                          StoredProrataYear, _Category, ProrataDetailsList);

                      StoreProrataHeader(ProrataHeaderTable, TempParcelTable,
                                         SwisSBLKey, StoredProrataYear, _Category,
                                         CalculationDate, EffectiveDate, RemovalDate);

                    end;  {If not TrialRun}

                with Sender as TBaseReport do
                  case ReportSection of
                    rsMain :
                      begin
                        ProrataThisParcel := 0;
                        _PrintHeader := True;

                        If (LinesLeft < 8)
                          then NewPage;

                        For I := 0 to (ProrataDetailsList.Count - 1) do
                          with ProrataDetailPointer(ProrataDetailsList[I])^ do
                            begin
                              If (LinesLeft < 3)
                                then
                                  begin
                                    NewPage;
                                    _PrintHeader := True;
                                  end;

                              If _PrintHeader
                                then
                                  begin
                                    Print(#9 + ConvertSwisSBLToDashDot(SwisSBLKey) + (*'  ' +
                                             TempParcelTable.FieldByName('AccountNo').AsString +  *)
                                          #9 + Copy(TempParcelTable.FieldByName('Name1').Text, 1, 12) +
                                          #9 + TempParcelTable.FieldByName('SchoolCode').Text);
                                    _PrintHeader := False;
                                  end
                                else Print(#9 + #9 + #9);

                              Println(#9 + AssessmentYear +
                                      #9 + DateToStr(EffectiveDate) +
                                      #9 + DateToStr(RemovalDate) +
                                      #9 + Trim(GeneralTaxType) +
                                      #9 + Copy(LevyDescription, 1, 20) +
                                      #9 + ExemptionCode +
                                      #9 + IntToStr(CalculationDays) +
                                      #9 + FormatFloat(IntegerDisplay, ExemptionAmount) +
                                      #9 + FormatFloat(ExtendedDecimalDisplay, TaxRate) +
                                      #9 + FormatFloat(DecimalDisplay, TaxAmount));

                              If ExtractToExcel
                                then WritelnCommaDelimitedLine(ExtractFile,
                                                               [ConvertSBLOnlyToDashDot(Copy(SwisSBLKey, 7, 20)),
                                                                TempParcelTable.FieldByName('AccountNo').AsString,
                                                                TempParcelTable.FieldByName('Name1').Text,
                                                                TempParcelTable.FieldByName('SchoolCode').Text,
                                                                AssessmentYear,
                                                                DateToStr(EffectiveDate),
                                                                DateToStr(RemovalDate),
                                                                GeneralTaxType,
                                                                LevyDescription,
                                                                ExemptionCode,
                                                                CalculationDays,
                                                                ExemptionAmount,
                                                                TaxRate,
                                                                TaxAmount]);

                              ProrataThisParcel := ProrataThisParcel + TaxAmount;

                              UpdateTotalsList(ProrataTotalsList, LevyDescription,
                                               ExemptionAmount, TaxRate, TaxAmount);

                            end;  {with ProrataDetailPointer(ProrataDetailsList[I])^ do}

                        Bold := True;
                        Println(#9 + #9 + #9 + #9 + #9 + #9 + #9 + #9 + #9 + #9 + #9 + #9 +
                                #9 + FormatFloat(DecimalDisplay, ProrataThisParcel));
                        Bold := False;
                        Println('');

                        TotalProrata := TotalProrata + ProrataThisParcel;

                      end;  {rsMain}

                    end;  {case ReportSection of}

              end;  {If (RemovedExemptionsList.Count > 0)}

        end;  {If not Done}

    ReportCancelled := ProgressDialog.Cancelled;

  until (Done or ReportCancelled);

  with Sender as TBaseReport do
    begin
      Bold := True;
      Println(#9 + 'Total Prorata:' +
              #9 + #9 + #9 + #9 + #9 + #9 + #9 + #9 + #9 + #9 + #9 +
              #9 + FormatFloat(DecimalDisplay, TotalProrata));
      Bold := False;

      PrintProrataTotals(Sender, ProrataTotalsList);

    end;  {with Sender as TBaseReport do}

  If (RejectList.Count > 0)
    then
      begin
        ReportSection := rsReject;
        PrintRejectOrWarningSection(Sender, RejectList);
      end;

  If (WarningList.Count > 0)
    then
      begin
        ReportSection := rsWarning;
        PrintRejectOrWarningSection(Sender, WarningList);
      end;

  If not TrialRun
    then MarkExemptionsCalculated(RemovedExemptionsTable, RemovedExemptionsToMarkCalculatedList,
                                  CollectionType, StoredProrataYear);

  FreeTList(RemovedExemptionsList, SizeOf(ProrataRemovedExemptionRecord));
  FreeTList(ProrataDetailsList, SizeOf(ProrataDetailRecord));
  FreeTList(ProrataTotalsList, SizeOf(ProrataTotalsRecord));
  RemovedExemptionsToMarkCalculatedList.Free;

end;  {ReportPrint}

{===================================================================}
Procedure TCalculateProrataInformationForm.StartButtonClick(Sender: TObject);

var
  Quit, Continue : Boolean;
  NewFileName, SpreadsheetFileName : String;
  TempFile : File;

begin
  Continue := True;
  Quit := False;
  ReportCancelled := False;
  ReportSection := rsMain;
  ExtractToExcel := ExtractToExcelCheckBox.Checked;

  try
    dCutoffEffectiveDate := StrToDate(edCutOffEffectiveDate.Text);
  except
    dCutoffEffectiveDate := StrToDate('1/1/2999');
  end;

  ClearTList(RejectList, SizeOf(RejectOrWarningRecord));
  ClearTList(WarningList, SizeOf(RejectOrWarningRecord));

  StartButton.Enabled := False;
  Application.ProcessMessages;
  Quit := False;

  SetPrintToScreenDefault(PrintDialog);

  If _Compare(CollectionTypeComboBox.Text, coBlank)
    then
      begin
        MessageDlg('Please select a collection type.', mtError, [mbOK], 0);
        CollectionTypeComboBox.SetFocus;
        Continue := False;

      end;  {If _Compare ...}

  try
    CalculationDate := StrToDate(CalculationDateMaskEdit.Text);
  except
    CalculationDateMaskEdit.SetFocus;
    MessageDlg('Please enter a valid date.', mtError, [mbOK], 0);
    Continue := False;
  end;

  try
    CollectionStartDay := StrToInt(EditCollectionStartDay.Text);
  except
    EditCollectionStartDay.SetFocus;
    MessageDlg('Please enter a collection start day.', mtError, [mbOK], 0);
    Continue := False;
  end;

  try
    CollectionStartMonth := StrToInt(EditCollectionStartMonth.Text);
  except
    EditCollectionStartMonth.SetFocus;
    MessageDlg('Please enter a collection start month.', mtError, [mbOK], 0);
    Continue := False;
  end;

  ProrataYear := EditProrataYear.Text;
  TrialRun := TrialRunCheckBox.Checked;
  ClearProrataInformation := ClearPriorProrataInformationCheckBox.Checked;

  If (Continue and
      PrintDialog.Execute)
    then
      begin
        _Category := GetCollectionTypeCategory(CollectionType);
        AssignPrinterSettings(PrintDialog, ReportPrinter, ReportFiler,
                              [ptLaser], False, Quit);

        ReportFiler.Orientation := poLandscape;
        ReportPrinter.Orientation := poLandscape;
        ProgressDialog.Start(GetRecordCount(ParcelTable), True, True);

          {Now print the report.}

        If not (Quit or ReportCancelled)
          then
            begin
              If ExtractToExcel
                then
                  begin
                    SpreadsheetFileName := GetPrintFileName('Prorata_Calc_', True);
                    AssignFile(ExtractFile, SpreadsheetFileName);
                    Rewrite(ExtractFile);

                    WritelnCommaDelimitedLine(ExtractFile,
                                              ['Parcel ID',
                                               'Account #',
                                               'Owner',
                                               'School Code',
                                               'Assessment Year',
                                               'Effective Date',
                                               'Removal Date',
                                               'Tax Type',
                                               'Levy Description',
                                               'EX Code',
                                               'Calc Days',
                                               'EX Amount',
                                               'Tax Rate',
                                               'Tax Amount']);

                  end;  {If ExtractToExcel}

              If PrintDialog.PrintToFile
                then
                  begin
                    NewFileName := GetPrintFileName(Self.Caption, True);
                    ReportFiler.FileName := NewFileName;

                    try
                      PreviewForm := TPreviewForm.Create(self);
                      PreviewForm.FilePrinter.FileName := NewFileName;
                      PreviewForm.FilePreview.FileName := NewFileName;

                      ReportFiler.Execute;

                      ProgressDialog.StartPrinting(PrintDialog.PrintToFile);

                      PreviewForm.ShowModal;
                    finally
                      PreviewForm.Free;

                        {Now delete the file.}
                      try
                        AssignFile(TempFile, NewFileName);
                        OldDeleteFile(NewFileName);
                      finally
                        ChDir(GlblProgramDir);
                      end;

                    end;  {try PreviewForm := ...}

                  end  {If PrintDialog.PrintToFile}
                else ReportPrinter.Execute;

              ProgressDialog.Finish;

              ResetPrinter(ReportPrinter);

              If ExtractToExcel
                then
                  begin
                    CloseFile(ExtractFile);
                    SendTextFileToExcelSpreadsheet(SpreadsheetFileName, True,
                                                   False, '');

                  end;  {If PrintToExcel}

            end;  {If not Quit}

        DisplayPrintingFinishedMessage(PrintDialog.PrintToFile);

      end;  {If PrintDialog.Execute}

  StartButton.Enabled := True;

end; {PrintButtonClick}

{===================================================================}
Procedure TCalculateProrataInformationForm.FormClose(    Sender: TObject;
                                                     var Action: TCloseAction);

begin
  CloseTablesForForm(Self);
  FreeTList(LeviesToProrateList, SizeOf(LeviesToProrateRecord));
  FreeTList(BillingRateList, SizeOf(BillingRateRecord));
  FreeTList(RejectList, SizeOf(RejectOrWarningRecord));
  FreeTList(WarningList, SizeOf(RejectOrWarningRecord));

    {Free up the child window and set the ClosingAForm Boolean to
     true so that we know to delete the tab.}

  Action := caFree;
  GlblClosingAForm := True;
  GlblClosingFormCaption := Caption;

end;  {FormClose}

end.