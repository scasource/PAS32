unit Rpavsmry;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, DBCtrls, DBTables, DB, Buttons, Grids,
  Wwdbigrd, Wwdbgrid, ExtCtrls, Wwtable, Wwdatsrc, Menus, RPCanvas,
  RPrinter, RPBase, RPFiler, Types, RPDefine, (*Progress,*) PASTypes, DBGrids,
  Wwkeycb, RPTXFilr, ComCtrls;

type
  TotalsRecord = record
    TaxRollYr : String;
    NumHstdActiveParcels,
    NumHstdInactiveParcels,
    NumNonhstdActiveParcels,
    NumNonhstdInactiveParcels : LongInt;
    HstdCurrentTotalAV,
    HstdCurrentLandAV,
    NonhstdCurrentTotalAV,
    NonhstdCurrentLandAV,
    HstdNYTotalAV,
    HstdNYLandAV,
    NonhstdNYTotalAV,
    NonhstdNYLandAV,
    PriorTotalAV,
    HstdTownTaxableVal,
    HstdCountyTaxableVal,
    HstdSchoolTaxableVal,
    HstdVillageTaxableVal,
    NonhstdTownTaxableVal,
    NonhstdCountyTaxableVal,
    NonhstdSchoolTaxableVal,
    NonhstdVillageTaxableVal : Comp;

  end;  {TotalsRecord = record}

type
  TAssessmentSummaryReportForm = class(TForm)
    TYParcelTable: TTable;
    TYAssessmentTable: TTable;
    SwisCodeTable: TTable;
    PrintDialog: TPrintDialog;
    ReportFiler: TReportFiler;
    ReportPrinter: TReportPrinter;
    TYExemptionTable: TTable;
    TYEXCodeTable: TTable;
    PropertyClassTable: TTable;
    SchoolCodeTable: TTable;
    TYClassTable: TTable;
    NYParcelTable: TTable;
    NYAssessmentTable: TTable;
    NYClassTable: TTable;
    PriorAssessmentTable: TTable;
    SortTable: TwwTable;
    AssessmentYearControlTable: TTable;
    CodeTable: TTable;
    TextFiler: TTextFiler;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    NYExemptionTable: TTable;
    NYEXCodeTable: TTable;
    PageControl1: TPageControl;
    ts_Options: TTabSheet;
    rg_PrintOrder: TRadioGroup;
    AssessmentYearRadioGroup: TRadioGroup;
    AssessedValueTypeRadioGroup: TRadioGroup;
    rg_Totals: TRadioGroup;
    GroupBox1: TGroupBox;
    Label18: TLabel;
    CheckBox1: TCheckBox;
    LoadFromParcelListCheckBox: TCheckBox;
    CreateParcelListCheckBox: TCheckBox;
    ShowHistoryValuesCheckBox: TCheckBox;
    PrintOwnerName2CheckBox: TCheckBox;
    ExtractToExcelCheckBox: TCheckBox;
    PrintUniformPercentCheckBox: TCheckBox;
    rg_Suborder: TRadioGroup;
    ts_SwisSchool: TTabSheet;
    Label9: TLabel;
    Label5: TLabel;
    SwisCodeListBox: TListBox;
    SchoolCodeListBox: TListBox;
    ts_RollSection_PropertyClass: TTabSheet;
    Label8: TLabel;
    Label10: TLabel;
    RollSectionListBox: TListBox;
    PropertyClassListBox: TListBox;
    Panel3: TPanel;
    CloseButton: TBitBtn;
    LoadButton: TBitBtn;
    SaveButton: TBitBtn;
    btn_Print: TBitBtn;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btn_PrintClick(Sender: TObject);
    procedure TextReportPrint(Sender: TObject);
    procedure TextReportPrintHeader(Sender: TObject);
    procedure ReportPrint(Sender: TObject);
    procedure LoadButtonClick(Sender: TObject);
    procedure SaveButtonClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    UnitName : String;
    ReportCancelled : Boolean;
    LastSwisCode : String;
    SelectedSwisCodes,
    SelectedSchoolCodes,
    SelectedPropertyClasses,
    SelectedRollSections : TStringList;  {What swis codes did they select?}

      {Other ranges.}

    PrintOrder,
    PrintSubOrder,
    AssessmentYear,
    AssessedValueType,
    SchoolCodePrintType : Integer;
    PrintNextYearValues,
    ShowHomesteadAmounts,
    PrintGrandTotals,
    SuppressValues, ShowHistoryValues : Boolean;

    LastAssessmentYear : Integer;

    PrintUniformPercentOfValue : Boolean;

    RollSectionList,
    SchoolCodeList,
    SwisCodeList,
    PropertyClassList : TList;
    LoadFromParcelList,
    CreateParcelList : Boolean;
    OrigSortFileName : String;
    PrintSecondOwnerName, ExtractToExcel : Boolean;
    LinesLeftAtBottom : Integer;
    ExtractFile : TextFile;

    Procedure InitializeForm;  {Open the tables and setup.}

    Procedure AddOneSortRecord(    SwisSBLKey : String;
                                   TaxRollYr : String;
                                   ParcelTable : TTable;
                                   LandAssessedVal,
                                   TotalAssessedVal,
                                   NYLandAssessedVal,
                                   NYTotalAssessedVal,
                                   PriorTotalAssessedVal : Comp;
                                   EXAmounts : ExemptionTotalsArrayType;
                                   HomesteadCode : Char;
                               var Quit : Boolean);
    {Add one sort record.}

    Procedure UpdateSortTable(    SwisSBLKey : String;
                                  TaxRollYr : String;
                                  ParcelTable : TTable;
                                  HstdLandAssessedVal,
                                  HstdTotalAssessedVal,
                                  NonhstdLandAssessedVal,
                                  NonhstdTotalAssessedVal,
                                  NYHstdLandAssessedVal,
                                  NYHstdTotalAssessedVal,
                                  NYNonhstdLandAssessedVal,
                                  NYNonhstdTotalAssessedVal,
                                  PriorTotalAssessedVal : Comp;
                                  HstdEXAmounts,
                                  NonhstdEXAmounts : ExemptionTotalsArrayType;
                              var Quit : Boolean);
    {Insert a record for this parcel.}

    Procedure UpdateTotals(    SortTable : TTable;
                               _TaxRollYr : String;
                           var TotalsRec : TotalsRecord);

    Procedure PrintOneLand_TotalValTotal(Sender : TObject;
                                         TotalsType : Char; {(H)std, (N)hstd, (G)rand}
                                         PrintOrder : Integer;
                                         AssessmentYear : Integer;
                                         Totals : TotalsRecord);
    {Print the totals for a section in a report that shows taxable values.}

    Procedure PrintTotals(Sender : TObject;
                          TotalType : Integer;  {ttGrandTotal, ttSwisTotal, ttSectionTotal}
                          BreakCode : String;
                          Totals : TotalsRecord);

    Function RecordInRange(ParcelTable : TTable) : Boolean;

    Procedure FillSortFile(var Quit : Boolean);
   {Fill the sort file with the variance information.}

    Procedure PrintOneLine(Sender : TObject);

  end;

implementation

uses GlblVars, WinUtils, Utilitys, PASUTILS, UTILEXSD,  GlblCnst, Prog,
     PRCLLIST, RptDialg,
     Preview;  {Report preview form}

const
  TrialRun = False;

    {Print Order constants}
    {FXX05011998-4: Have to adjust constants since took out account # as option.}

  poRollSection = 0;
  poSchoolCode = 1;
  poParcelID = 2;
  poName = 3;
  poAddress = 4;
  poPropertyClass = 5;
  poAddressSpecialFormat = 6;

    {Assessment year types}

  atThisYear = 0;
  atNextYear = 1;
  atBoth = 2;

    {Assessed Value types}

  avLand_Total = 0;
  avTaxableValues = 1;
  avNoValues = 2;

    {Print suborder}

  psParcelID = 0;
  psName = 1;
  psAddress = 2;
  psAccountNumber = 2;

    {School code print type}

  scTownWithinSchool = 0;
  scSchoolWithinTown = 1;

    {Notebook pages}

  pgMainPage = 0;
  pgSwisCodePage = 1;
  pgSchoolCodePage = 2;
  pgRollSectionPage = 3;
  pgPropertyClassPage = 4;

    {Totals type}

  ttSectionTotal = 0;
  ttSwisTotal = 1;
  ttGrandTotal = 2;

{$R *.DFM}

{========================================================}
Procedure TAssessmentSummaryReportForm.FormActivate(Sender: TObject);

begin
  SetFormStateMaximized(Self);
end;

{========================================================}
Procedure TAssessmentSummaryReportForm.InitializeForm;

var
  Quit : Boolean;
  I, ProcessingType : Integer;
  AssessmentYearStr : String;

begin
  UnitName := 'RPAVSMRY.PAS';  {mmm}

  SelectedSwisCodes := TStringList.Create;
  SelectedSchoolCodes := TStringList.Create;
  SelectedPropertyClasses := TStringList.Create;
  SelectedRollSections := TStringList.Create;

  OpenTablesForForm(Self, GlblProcessingType);

  OpenTableForProcessingType(NYParcelTable, ParcelTableName,
                             NextYear, Quit);

  OpenTableForProcessingType(NYAssessmentTable, AssessmentTableName,
                             NextYear, Quit);

  OpenTableForProcessingType(NYClassTable, ClassTableName, NextYear, Quit);

  OpenTableForProcessingType(PriorAssessmentTable, AssessmentTableName,
                             History, Quit);

    {Fill in the list boxes for the first time.}

  ProcessingType := GlblProcessingType;
  AssessmentYearStr := GetTaxRollYearForProcessingType(ProcessingType);

  FillOneListBox(SwisCodeListBox, SwisCodeTable,
                 'SwisCode', 'MunicipalityName',
                 25, True, True, ProcessingType, AssessmentYearStr);

  FillOneListBox(SchoolCodeListBox, SchoolCodeTable,
                 'SchoolCode', 'SchoolName',
                 25, True, True, ProcessingType, AssessmentYearStr);

  FillOneListBox(PropertyClassListBox, PropertyClassTable,
                 'MainCode', 'Description',
                 15, True, True, ProcessingType, AssessmentYearStr);

  For I := 0 to (RollSectionListBox.Items.Count - 1) do
    RollSectionListBox.Selected[I] := True;

  OrigSortFileName := SortTable.TableName;

end;  {InitializeForm}

{===================================================================}
Procedure TAssessmentSummaryReportForm.AddOneSortRecord(    SwisSBLKey : String;
                                                            TaxRollYr : String;
                                                            ParcelTable : TTable;
                                                            LandAssessedVal,
                                                            TotalAssessedVal,
                                                            NYLandAssessedVal,
                                                            NYTotalAssessedVal,
                                                            PriorTotalAssessedVal : Comp;
                                                            EXAmounts : ExemptionTotalsArrayType;
                                                            HomesteadCode : Char;
                                                        var Quit : Boolean);

{Add one sort record.}

var
  TempTotalAssessedVal : Comp;

begin
  with SortTable do
    try
      Insert;

      FieldByName('SBLKey').Text := Copy(SwisSBLKey, 7, 20);
      FieldByName('SwisCode').Text := Copy(SwisSBLKey, 1, 6);
      FieldByName('TaxRollYr').Text := TaxRollYr;

      FieldByName('Name').Text := Take(25, ParcelTable.FieldByName('Name1').Text);

        {FXX07151998-1: Save both legal addr number and name - don't condense into
                        one field.}

      FieldByName('LegalAddrNo').Text := ParcelTable.FieldByName('LegalAddrNo').Text;
      FieldByName('LegalAddr').Text := ParcelTable.FieldByName('LegalAddr').Text;

        {CHG01072002-1: Make legal address order by legal addr #.}

      try
        FieldByName('LegalAddrInt').AsInteger := ParcelTable.FieldByName('LegalAddrInt').AsInteger;
      except
      end;

      FieldByName('HomesteadCode').Text := HomesteadCode;
      FieldByName('RollSection').Text := ParcelTable.FieldByName('RollSection').Text;
      FieldByName('RollSubsection').Text := ParcelTable.FieldByName('RollSubsection').Text;
      FieldByName('ResidentialPercent').Text := ParcelTable.FieldByName('ResidentialPercent').Text;
      FieldByName('PropertyClass').Text := Take(3, ParcelTable.FieldByName('PropertyClassCode').Text);
      FieldByName('SchoolCode').Text := Take(6, ParcelTable.FieldByName('SchoolCode').Text);
      FieldByName('Active').AsBoolean := (ParcelTable.FieldByName('ActiveFlag').Text <> InactiveParcelFlag);
      FieldByName('OwnershipCode').Text := ParcelTable.FieldByName('OwnershipCode').Text;

      If (AssessedValueType = avTaxableValues)
        then
          begin
            TCurrencyField(FieldByName('CurrTotalAssessedVal')).Value := TotalAssessedVal;
            TCurrencyField(FieldByName('NYTotalAssessedVal')).Value := NYTotalAssessedVal;

            If (TaxRollYr = GlblThisYear)
              then TempTotalAssessedVal := TotalAssessedVal
              else TempTotalAssessedVal := NYTotalAssessedVal;

            TCurrencyField(FieldByName('CountyTaxableVal')).Value := (TempTotalAssessedVal - EXAmounts[EXCounty]);
            TCurrencyField(FieldByName('TownTaxableVal')).Value := (TempTotalAssessedVal - EXAmounts[EXTown]);
            TCurrencyField(FieldByName('SchoolTaxableVal')).Value := (TempTotalAssessedVal - EXAmounts[EXSchool]);
            TCurrencyField(FieldByName('VillageTaxableVal')).Value := (TempTotalAssessedVal - EXAmounts[EXVillage]);
          end
        else
          begin
            TCurrencyField(FieldByName('CurrLandAssessedVal')).Value := LandAssessedVal;
            TCurrencyField(FieldByName('CurrTotalAssessedVal')).Value := TotalAssessedVal;
            TCurrencyField(FieldByName('NYLandAssessedVal')).Value := NYLandAssessedVal;
            TCurrencyField(FieldByName('NYTotalAssessedVal')).Value := NYTotalAssessedVal;
            TCurrencyField(FieldByName('PriorTotAssessedVal')).Value := PriorTotalAssessedVal;

          end;  {else of If (AssessedValueType = avTaxableValues)}

        {CHG09262002-1: Option to include 2nd owner name.}

      If PrintSecondOwnerName
        then
          try
            FieldByName('Name2').Text := ParcelTable.FieldByName('Name2').Text;
          except
          end;

      Post;

    except
      Quit := True;
      SystemSupport(005, SortTable, 'Error inserting sort record.',
                    UnitName, GlblErrorDlgBox);
    end;

end;  {AddOneSortRecord}

{===================================================================}
Procedure TAssessmentSummaryReportForm.UpdateSortTable(    SwisSBLKey : String;
                                                           TaxRollYr : String;
                                                           ParcelTable : TTable;
                                                           HstdLandAssessedVal,
                                                           HstdTotalAssessedVal,
                                                           NonhstdLandAssessedVal,
                                                           NonhstdTotalAssessedVal,
                                                           NYHstdLandAssessedVal,
                                                           NYHstdTotalAssessedVal,
                                                           NYNonhstdLandAssessedVal,
                                                           NYNonhstdTotalAssessedVal,
                                                           PriorTotalAssessedVal : Comp;
                                                           HstdEXAmounts,
                                                           NonhstdEXAmounts : ExemptionTotalsArrayType;
                                                       var Quit : Boolean);

{Insert a record for this parcel.}

var
  I : Integer;
  HomesteadCode, TempHomesteadCode : Char;
  EXAmounts : ExemptionTotalsArrayType;

begin
  If ShowHomesteadAmounts
    then
      begin
        HomesteadCode := Take(1, ParcelTable.FieldByName('HomesteadCode').Text)[1];

          {Store a record for the homestead part.}

        If (HomesteadCode in ['H', 'S', ' '])
          then
            begin
              TempHomesteadCode := HomesteadCode;

              If (TempHomesteadCode = 'S')
                then TempHomesteadCode := 'H';  {Hstd part of split.}

              AddOneSortRecord(SwisSBLKey, TaxRollYr, ParcelTable,
                                HstdLandAssessedVal,
                                HstdTotalAssessedVal,
                                NYHstdLandAssessedVal,
                                NYHstdTotalAssessedVal,
                                PriorTotalAssessedVal,
                                HstdEXAmounts,
                                TempHomesteadCode, Quit);

            end;  {If (HomesteadCode in ['H', 'S', ' '])}

          {Now store a record for the nonhstd part.}

        If (HomesteadCode in ['N', 'S'])
          then
            begin
              TempHomesteadCode := HomesteadCode;

              If (TempHomesteadCode = 'S')
                then TempHomesteadCode := 'N';  {Nonhstd part of split.}

              AddOneSortRecord(SwisSBLKey, TaxRollYr, ParcelTable,
                               NonhstdLandAssessedVal,
                               NonhstdTotalAssessedVal,
                               NYNonhstdLandAssessedVal,
                               NYNonhstdTotalAssessedVal,
                               PriorTotalAssessedVal,
                               NonhstdEXAmounts,
                               TempHomesteadCode, Quit);

            end;  {If (HomesteadCode in ['H', 'S', ' '])}

      end
    else
      begin
          {Combine the hstd and non-hstd ex amounts.}

        For I := 1 to 4 do
          EXAmounts[I] := HstdEXAmounts[I] + NonhstdEXAmounts[I];

        AddOneSortRecord(SwisSBLKey,TaxRollYr, ParcelTable,
                         (HstdLandAssessedVal +
                          NonhstdLandAssessedVal),
                         (HstdTotalAssessedVal +
                          NonhstdTotalAssessedVal),
                         (NYHstdLandAssessedVal +
                          NYNonhstdLandAssessedVal),
                         (NYHstdTotalAssessedVal +
                          NYNonhstdTotalAssessedVal),
                         PriorTotalAssessedVal,
                         EXAmounts,
                         Take(1, ParcelTable.FieldByName('HomesteadCode').Text)[1],
                         Quit);

      end;  {else of If ShowHomesteadAmounts}

end;  {UpdateSortTable}

{===================================================================}
Function TAssessmentSummaryReportForm.RecordInRange(ParcelTable : TTable) : Boolean;

{Does this record fall in the range of selections the user wanted?}

var
  SwisCode,
  SchoolCode,
  PropertyClass,
  RollSection : String;

begin
  with ParcelTable do
    begin
      SwisCode := FieldByName('SwisCode').Text;
      SchoolCode := FieldByName('SchoolCode').Text;
      PropertyClass := FieldByName('PropertyClassCode').Text;
      RollSection := FieldByName('RollSection').Text;

    end;  {with ParcelTable do}

    {If not grand totals, do they meet the swis code selection?}
    {FXX03232005-1(2.8.3.12)[2086]: If all of the items in a list box are selected, don't bother checking
                                    for individual items.}

  Result := (_Compare(SelectedSwisCodes.Count, SwisCodeListBox.Items.Count, coEqual) or
             _Compare(SelectedSwisCodes.IndexOf(SwisCode), -1, coGreaterThan));

  Result := Result and
            (_Compare(SelectedSchoolCodes.Count, SchoolCodeListBox.Items.Count, coEqual) or
             _Compare(SelectedSchoolCodes.IndexOf(SchoolCode), -1, coGreaterThan));
  Result := Result and
            (_Compare(SelectedPropertyClasses.Count, PropertyClassListBox.Items.Count, coEqual) or
             _Compare(SelectedPropertyClasses.IndexOf(PropertyClass), -1, coGreaterThan));
  Result := Result and (SelectedRollSections.IndexOf(RollSection) <> -1);

  If LoadFromParcelList
    then Result := True;

end;  {RecordInRange}

{===================================================================}
Procedure TAssessmentSummaryReportForm.FillSortFile(var Quit : Boolean);

{Fill the sort file with the variance information.}

var
  AssessmentRecordFound, ClassRecordFound,
  Found, FirstTimeThrough, Done, ParcelDifferencesExist : Boolean;
  I, Index, TempYear : Integer;
  SwisSBLKey : String;
  ExemptionCodes,
  ExemptionHomesteadCodes,
  ResidentialTypes,
  CountyExemptionAmounts,
  TownExemptionAmounts,
  SchoolExemptionAmounts,
  VillageExemptionAmounts : TStringList;
  HstdEXAmounts, NonhstdEXAmounts : ExemptionTotalsArrayType;
  BasicSTARAmount, EnhancedSTARAmount,
  HstdLandAssessedVal, HstdTotalAssessedVal,
  NonhstdLandAssessedVal, NonhstdTotalAssessedVal,
  TYHstdLandAssessedVal, TYHstdTotalAssessedVal,
  TYNonhstdLandAssessedVal, TYNonhstdTotalAssessedVal,
  NYHstdTotalAssessedVal, NYNonhstdTotalAssessedVal,
  NYHstdLandAssessedVal, NYNonhstdLandAssessedVal,
  PriorTotalAssessedVal : Comp;
  PriorYear, TaxRollYr, OppositeTaxYear : String;
  HstdAcres, NonhstdAcres : Real;
  SBLRec : SBLRecord;
  TempParcelTable, TempAssessmentTable, TempClassTable,
  OppositeYearParcelTable,
  OppositeYearAssessmentTable, OppositeYearClassTable,
  TempExemptionTable, TempEXCodeTable : TTable;

begin
  Index := 1;
  ExemptionCodes := TStringList.Create;
  ExemptionHomesteadCodes := TStringList.Create;
  ResidentialTypes := TStringList.Create;
  CountyExemptionAmounts := TStringList.Create;
  TownExemptionAmounts := TStringList.Create;
  SchoolExemptionAmounts := TStringList.Create;
  VillageExemptionAmounts := TStringList.Create;

  case AssessmentYear of
    atThisYear,
    atBoth : TaxRollYr := GlblThisYear;
    atNextYear : TaxRollYr := GlblNextYear;
  end;  {case AssessmentYear of}

  For I := 1 to 4 do
    begin
      HstdEXAmounts[I] := 0;
      NonhstdEXAmounts[I] := 0;
    end;

  ProgressDialog.UserLabelCaption := 'Sorting Parcel File.';

    {If they want to see only NY info, loop on the NY table.  Otherwise, loop on the TY
     table.}

  If (AssessmentYear = atNextYear)
    then
      begin
        TempParcelTable := NYParcelTable;
        TempAssessmentTable := NYAssessmentTable;
        TempClassTable := NYClassTable;
        TempExemptionTable := NYExemptionTable;
        TempEXCodeTable := NYEXCodeTable;
      end
    else
      begin
        TempParcelTable := TYParcelTable;
        TempAssessmentTable := TYAssessmentTable;
        TempClassTable := TYClassTable;
        TempExemptionTable := TYExemptionTable;
        TempEXCodeTable := TYEXCodeTable;
      end;

    {Now go through the next year parcel file.}

  FirstTimeThrough := True;
  Done := False;

    {CHG03101999-1: Send info to a list or load from a list.}

  If CreateParcelList
    then ParcelListDialog.ClearParcelGrid(True);

  If LoadFromParcelList
    then
      begin
        ParcelListDialog.GetParcel(TempParcelTable, Index);
        ProgressDialog.Start(ParcelListDialog.NumItems, True, True);
      end
    else
      begin
        TempParcelTable.First;

        If (AssessmentYear = atBoth)
          then ProgressDialog.Start(GetRecordCount(TYParcelTable) +
                                    GetRecordCount(NYParcelTable), True, True)
          else ProgressDialog.Start(GetRecordCount(TempParcelTable), True, True);

        ProgressDialog.Start(GetRecordCount(TempParcelTable), True, True);

      end;  {else of If LoadFromParcelList}

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else
        If LoadFromParcelList
          then
            begin
              Index := Index + 1;
              ParcelListDialog.GetParcel(TempParcelTable, Index);
            end
          else TempParcelTable.Next;

    If (TempParcelTable.EOF or
        (LoadFromParcelList and
         (Index > ParcelListDialog.NumItems)))
      then Done := True;

    If LoadFromParcelList
      then ProgressDialog.Update(Self, ParcelListDialog.GetParcelID(Index))
      else ProgressDialog.Update(Self, ConvertSwisSBLToDashDot(ExtractSSKey(TempParcelTable)));

    SwisSBLKey := ExtractSSKey(TempParcelTable);

    Application.ProcessMessages;

    SBLRec := ExtractSwisSBLFromSwisSBLKey(ExtractSSKey(TempParcelTable));

      {Insert records into the sort files where appropriate.}
      {FXX09131999-4: Do not allow rs 9 print.}

    If ((not Done) and
        RecordInRange(TempParcelTable) and
        (TempParcelTable.FieldByName('RollSection').Text <> '9'))
      then
        begin
          TYHstdTotalAssessedVal := 0;
          TYNonhstdTotalAssessedVal := 0;
          TYHstdLandAssessedVal := 0;
          TYNonhstdLandAssessedVal := 0;

          NYHstdTotalAssessedVal := 0;
          NYNonhstdTotalAssessedVal := 0;
          NYHstdLandAssessedVal := 0;
          NYNonhstdLandAssessedVal := 0;

          PriorTotalAssessedVal := 0;

             {CHG03101999-1: Send info to a list.}

           If CreateParcelList
             then ParcelListDialog.AddOneParcel(SwisSBLKey);

            {Get values for the year that we are looping on.}

          CalculateHstdAndNonhstdAmounts(TaxRollYr,
                                         SwisSBLKey,
                                         TempAssessmentTable,
                                         TempClassTable,
                                         TempParcelTable,
                                         HstdTotalAssessedVal,
                                         NonhstdTotalAssessedVal,
                                         HstdLandAssessedVal,
                                         NonhstdLandAssessedVal,
                                         HstdAcres, NonhstdAcres,
                                         AssessmentRecordFound,
                                         ClassRecordFound);

          If ((TempParcelTable.FieldByName('ActiveFlag').Text = InactiveParcelFlag) or
              (not AssessmentRecordFound))
            then
              begin
                 HstdTotalAssessedVal := 0;
                 NonhstdTotalAssessedVal := 0;
                 HstdLandAssessedVal := 0;
                 NonhstdLandAssessedVal := 0;
              end;
                                         
               {If we are looping on the NY table, then the values we got above
                are NY values. Otherwise, they are TY.}

          If (AssessmentYear = atNextYear)
            then
              begin
                NYHstdTotalAssessedVal := HstdTotalAssessedVal;
                NYNonhstdTotalAssessedVal := NonhstdTotalAssessedVal;
                NYHstdLandAssessedVal := HstdLandAssessedVal;
                NYNonhstdLandAssessedVal := NonhstdLandAssessedVal;
              end
            else
              begin
                TYHstdTotalAssessedVal := HstdTotalAssessedVal;
                TYNonhstdTotalAssessedVal := NonhstdTotalAssessedVal;
                TYHstdLandAssessedVal := HstdLandAssessedVal;
                TYNonhstdLandAssessedVal := NonhstdLandAssessedVal;
              end;

             {Get the opposite and prior year assessments.}

          If (AssessmentYear = atNextYear)
            then
              begin
                OppositeYearParcelTable := TYParcelTable;
                OppositeYearAssessmentTable := TYAssessmentTable;
                OppositeYearClassTable := TYClassTable;
                OppositeTaxYear := GlblThisYear;
              end
            else
              begin
                OppositeYearParcelTable := NYParcelTable;
                OppositeYearAssessmentTable := NYAssessmentTable;
                OppositeYearClassTable := NYClassTable;
                OppositeTaxYear := GlblNextYear;
              end;

          with SBLRec do
            Found := FindKeyOld(OppositeYearParcelTable,
                                ['TaxRollYr', 'SwisCode', 'Section',
                                 'Subsection', 'Block', 'Lot',
                                 'Sublot', 'Suffix'],
                                [OppositeTaxYear,
                                 SwisCode, Section, Subsection,
                                 Block, Lot, Sublot, Suffix]);

          If Found
            then
              begin
                CalculateHstdAndNonhstdAmounts(OppositeTaxYear,
                                               SwisSBLKey,
                                               OppositeYearAssessmentTable,
                                               OppositeYearClassTable,
                                               OppositeYearParcelTable,
                                               HstdTotalAssessedVal,
                                               NonhstdTotalAssessedVal,
                                               HstdLandAssessedVal,
                                               NonhstdLandAssessedVal,
                                               HstdAcres, NonhstdAcres,
                                               AssessmentRecordFound,
                                               ClassRecordFound);

                  {If they want to only see NY info, the info we just got is TY.
                   Otherwise, it is NY.}

                If (AssessmentYear = atNextYear)
                  then
                    begin
                      TYHstdTotalAssessedVal := HstdTotalAssessedVal;
                      TYNonhstdTotalAssessedVal := NonhstdTotalAssessedVal;
                      TYHstdLandAssessedVal := HstdLandAssessedVal;
                      TYNonhstdLandAssessedVal := NonhstdLandAssessedVal;
                    end
                  else
                    begin
                      NYHstdTotalAssessedVal := HstdTotalAssessedVal;
                      NYNonhstdTotalAssessedVal := NonhstdTotalAssessedVal;
                      NYHstdLandAssessedVal := HstdLandAssessedVal;
                      NYNonhstdLandAssessedVal := NonhstdLandAssessedVal;
                    end;

              end;  {If Found}

          If (AssessedValueType = avTaxableValues)
            then
              begin
                TotalExemptionsForParcel(TaxRollYr,
                                         SwisSBLKey,
                                         TempExemptionTable,
                                         TempEXCodeTable,
                                         TempParcelTable.FieldByName('HomesteadCode').Text,
                                         'A', ExemptionCodes,
                                         ExemptionHomesteadCodes,
                                         ResidentialTypes,
                                         CountyExemptionAmounts,
                                         TownExemptionAmounts,
                                         SchoolExemptionAmounts,
                                         VillageExemptionAmounts,
                                         BasicSTARAmount,
                                         EnhancedSTARAmount);

                GetHomesteadAndNonhstdExemptionAmounts(ExemptionCodes,
                                                       ExemptionHomesteadCodes,
                                                       CountyExemptionAmounts,
                                                       TownExemptionAmounts,
                                                       SchoolExemptionAmounts,
                                                       VillageExemptionAmounts,
                                                       HstdEXAmounts,
                                                       NonhstdEXAmounts);

              end  {If (AssessedValueType = avTaxableValues)}
            else
              begin
                   {Get the prior (i.e. first history) year tot value.
                    If there is no record, we will use the prior value
                    stored in the this year assessment table.}

                TempYear := StrToInt(GlblThisYear);
                PriorYear := IntToStr(TempYear - 1);

                try
                  Found := FindKeyOld(PriorAssessmentTable,
                                      ['TaxRollYr', 'SwisSBLKey'],
                                      [PriorYear, SwisSBLKey]);
                except
                  SystemSupport(003, PriorAssessmentTable, 'Error finding key in assessment table.',
                                UnitName, GlblErrorDlgBox);
                end;

                If Found
                  then PriorTotalAssessedVal := PriorAssessmentTable.FieldByName('TotalAssessedVal').AsFloat
                  else PriorTotalAssessedVal := TYAssessmentTable.FieldByName('PriorTotalValue').AsFloat;

              end;  {else of If (AssessedValueType = avTaxableValues)}

          If (AssessmentYear = atNextYear)
            then TempParcelTable := NYParcelTable
            else TempParcelTable := TYParcelTable;

          UpdateSortTable(SwisSBLKey, TaxRollYr, TempParcelTable,
                          TYHstdLandAssessedVal, TYHstdTotalAssessedVal,
                          TYNonhstdLandAssessedVal, TYNonhstdTotalAssessedVal,
                          NYHstdLandAssessedVal, NYHstdTotalAssessedVal,
                          NYNonhstdLandAssessedVal, NYNonhstdTotalAssessedVal,
                          PriorTotalAssessedVal, HstdEXAmounts,
                          NonhstdEXAmounts, Quit);

           {CHG09141998-1: Do TY and NY together. Search for change in
                           NY table.}

          ParcelDifferencesExist := RecordsAreDifferent(TYParcelTable, NYParcelTable);

          If ((AssessmentYear = atBoth) and
              ((TYParcelTable.FieldByName('LastChangeDate').AsDateTime <>
                NYParcelTable.FieldByName('LastChangeDate').AsDateTime) or
               ParcelDifferencesExist))
            then
              begin
                If Found
                  then
                    begin
                      If (AssessedValueType = avTaxableValues)
                        then
                          begin
                            CalculateHstdAndNonhstdAmounts(GlblNextYear,
                                                           SwisSBLKey,
                                                           NYAssessmentTable,
                                                           NYClassTable,
                                                           NYParcelTable,
                                                           NYHstdTotalAssessedVal,
                                                           NYNonhstdTotalAssessedVal,
                                                           NYHstdLandAssessedVal,
                                                           NYNonhstdLandAssessedVal,
                                                           HstdAcres, NonhstdAcres,
                                                           AssessmentRecordFound,
                                                           ClassRecordFound);

                            TotalExemptionsForParcel(GlblNextYear,
                                                     SwisSBLKey,
                                                     NYExemptionTable,
                                                     NYEXCodeTable,
                                                     NYParcelTable.FieldByName('HomesteadCode').Text,
                                                     'A', ExemptionCodes,
                                                     ExemptionHomesteadCodes,
                                                     ResidentialTypes,
                                                     CountyExemptionAmounts,
                                                     TownExemptionAmounts,
                                                     SchoolExemptionAmounts,
                                                     VillageExemptionAmounts,
                                                     BasicSTARAmount,
                                                     EnhancedSTARAmount);

                            GetHomesteadAndNonhstdExemptionAmounts(ExemptionCodes,
                                                                   ExemptionHomesteadCodes,
                                                                   CountyExemptionAmounts,
                                                                   TownExemptionAmounts,
                                                                   SchoolExemptionAmounts,
                                                                   VillageExemptionAmounts,
                                                                   HstdEXAmounts,
                                                                   NonhstdEXAmounts);

                          end;  {If (AssessedValueType = avTaxableValues)}

                    end;  {If Found}

                  {Now insert a sort record for the NY rec.
                   Note that for av values summaries, the prior, TY, and
                   NY have already been calculated above.}

                UpdateSortTable(SwisSBLKey, GlblNextYear, NYParcelTable,
                                TYHstdLandAssessedVal, TYHstdTotalAssessedVal,
                                TYNonhstdLandAssessedVal, TYNonhstdTotalAssessedVal,
                                NYHstdLandAssessedVal, NYHstdTotalAssessedVal,
                                NYNonhstdLandAssessedVal, NYNonhstdTotalAssessedVal,
                                PriorTotalAssessedVal, HstdEXAmounts,
                                NonhstdEXAmounts, Quit);

              end;  {If ((AssessmentYear = ayBoth) and ...}

        end;  {If not Done}

    ReportCancelled := ProgressDialog.Cancelled;

  until (Done or Quit or ReportCancelled);

   {CHG09141998-1: Do TY and NY together. Search for change in
                   NY table.}
   {Now we have to go through the NY file looking for parcels that are
    only in NY.}

  If (AssessmentYear = atBoth)
    then
      begin
        For I := 1 to 4 do
          begin
            HstdEXAmounts[I] := 0;
            NonhstdEXAmounts[I] := 0;
          end;

        TaxRollYr := GlblNextYear;

        ProgressDialog.UserLabelCaption := 'Sorting Parcel File - Pass 2.';

          {Now go through the next year parcel file.}

        FirstTimeThrough := True;
        Done := False;

        NYParcelTable.First;

        repeat
          If FirstTimeThrough
            then FirstTimeThrough := False
            else NYParcelTable.Next;

          If NYParcelTable.EOF
            then Done := True;

          SwisSBLKey := ExtractSSKey(NYParcelTable);

          ProgressDialog.Update(Self, ConvertSwisSBLToDashDot(SwisSBLKey));
          Application.ProcessMessages;

          SBLRec := ExtractSwisSBLFromSwisSBLKey(ExtractSSKey(NYParcelTable));

            {Look for a TY rec. If there is none, then store this record.}

          with SBLRec do
            Found := FindKeyOld(TYParcelTable,
                                ['TaxRollYr', 'SwisCode', 'Section',
                                 'Subsection', 'Block', 'Lot',
                                 'Sublot', 'Suffix'],
                                [GlblThisYear, SwisCode, Section,
                                 Subsection, Block, Lot, Sublot,
                                 Suffix]);

            {Insert records into the sort files where appropriate.}

          If ((not Done) and
              RecordInRange(NYParcelTable) and
              (not Found))
            then
              begin
                TYHstdTotalAssessedVal := 0;
                TYNonhstdTotalAssessedVal := 0;
                TYHstdLandAssessedVal := 0;
                TYNonhstdLandAssessedVal := 0;

                NYHstdTotalAssessedVal := 0;
                NYNonhstdTotalAssessedVal := 0;
                NYHstdLandAssessedVal := 0;
                NYNonhstdLandAssessedVal := 0;

                PriorTotalAssessedVal := 0;

                CalculateHstdAndNonhstdAmounts(TaxRollYr,
                                               SwisSBLKey,
                                               NYAssessmentTable,
                                               NYClassTable,
                                               NYParcelTable,
                                               NYHstdTotalAssessedVal,
                                               NYNonhstdTotalAssessedVal,
                                               NYHstdLandAssessedVal,
                                               NYNonhstdLandAssessedVal,
                                               HstdAcres, NonhstdAcres,
                                               AssessmentRecordFound,
                                               ClassRecordFound);

                If (AssessedValueType = avTaxableValues)
                  then
                    begin
                      TotalExemptionsForParcel(TaxRollYr,
                                               SwisSBLKey,
                                               NYExemptionTable,
                                               NYEXCodeTable,
                                               NYParcelTable.FieldByName('HomesteadCode').Text,
                                               'A', ExemptionCodes,
                                               ExemptionHomesteadCodes,
                                               ResidentialTypes,
                                               CountyExemptionAmounts,
                                               TownExemptionAmounts,
                                               SchoolExemptionAmounts,
                                               VillageExemptionAmounts,
                                               BasicSTARAmount,
                                               EnhancedSTARAmount);

                      GetHomesteadAndNonhstdExemptionAmounts(ExemptionCodes,
                                                             ExemptionHomesteadCodes,
                                                             CountyExemptionAmounts,
                                                             TownExemptionAmounts,
                                                             SchoolExemptionAmounts,
                                                             VillageExemptionAmounts,
                                                             HstdEXAmounts,
                                                             NonhstdEXAmounts);

                    end;  {If (AssessedValueType = avTaxableValues)}

                  {Note that since this parcel only exists in NY, there should be no prior
                   or TY values which are initialized to 0 above.}

                UpdateSortTable(SwisSBLKey, TaxRollYr, NYParcelTable,
                                TYHstdLandAssessedVal, TYHstdTotalAssessedVal,
                                TYNonhstdLandAssessedVal, TYNonhstdTotalAssessedVal,
                                NYHstdLandAssessedVal, NYHstdTotalAssessedVal,
                                NYNonhstdLandAssessedVal, NYNonhstdTotalAssessedVal,
                                PriorTotalAssessedVal, HstdEXAmounts,
                                NonhstdEXAmounts, Quit);

              end;  {If not Done}

          ReportCancelled := ProgressDialog.Cancelled;

        until (Done or Quit or ReportCancelled);

      end;  {If (AssessmentYear = ayBoth)}

  ExemptionCodes.Free;
  ExemptionHomesteadCodes.Free;
  ResidentialTypes.Free;
  CountyExemptionAmounts.Free;
  TownExemptionAmounts.Free;
  SchoolExemptionAmounts.Free;
  VillageExemptionAmounts.Free;

(*  If (AssessmentYear = atBoth)
    then
      begin
        NYExemptionTable.Close;
        NYEXCodeTable.Close;

        NYExemptionTable.Free;
        NYEXCodeTable.Free;

      end;  {If (AssessmentYear = atBoth)} *)

end;  {FillSortFiles}

{====================================================================}
Procedure TAssessmentSummaryReportForm.SaveButtonClick(Sender: TObject);

{FXX04091999-8: Add ability to save and load search report options.}

begin
  SaveReportOptions(Self, OpenDialog, SaveDialog, 'avsummry.sum', 'Assessment Summary Report');

end;  {SaveButtonClick}

{====================================================================}
Procedure TAssessmentSummaryReportForm.LoadButtonClick(Sender: TObject);

{FXX04091999-8: Add ability to save and load search report options.}

begin
  LoadReportOptions(Self, OpenDialog, 'avsummry.sum', 'Assessment Summary Report');

end;  {LoadButtonClick}

{===================================================================}
Procedure TAssessmentSummaryReportForm.btn_PrintClick(Sender: TObject);

var
  Quit, WideCarriage : Boolean;
  TextFileName, TempIndex,
  SortFileName, NewFileName, SpreadsheetFileName : String;

begin
  Quit := False;
  ReportCancelled := False;
  LinesLeftAtBottom := GlblLinesLeftOnRollDotMatrix;
  AssessedValueType := AssessedValueTypeRadioGroup.ItemIndex;

  If _Compare(rg_Suborder.ItemIndex, -1, coEqual)
    then rg_Suborder.ItemIndex := 0;

  PrintOrder := rg_PrintOrder.ItemIndex;
  PrintSuborder := rg_Suborder.ItemIndex;
  PrintGrandTotals := _Compare(rg_Totals.ItemIndex, 1, coEqual);

  Application.ProcessMessages;

    {CHG10121998-1: Add user options for default destination and show vet max msg.}

  SetPrintToScreenDefault(PrintDialog);

    {FXX0021999-2: Need to make sure assessment year is set.}

  with AssessmentYearRadioGroup do
    If (ItemIndex <> -1)
      then AssessmentYear := ItemIndex;

    {FXX07211999-8: Fix up assessment summary for TY vs. NY issues.}

  PrintNextYearValues := True;

  If ((AssessmentYear = atThisYear) and
      (AssessedValueTypeRadioGroup.ItemIndex = avLand_Total))
    then PrintNextYearValues := (MessageDlg('Do you want to display Next Year values?',
                                            mtConfirmation, [mbYes, mbNo], 0) = idYes);

  If PrintDialog.Execute
    then
      begin
          {FXX10071999-1: To solve the problem of printing to the high speed,
                          we need to set the font to a TrueType even though it
                          doesn't matter in the actual printing.  The reason for this
                          is that without setting it, the default font is System for
                          the Generic printer which has a baseline descent of 0.5
                          which messes up printing to a text file.  We needed a font
                          with no descent.}

        TextFiler.SetFont('Courier New', 10);

        LoadFromParcelList := LoadFromParcelListCheckBox.Checked;
        CreateParcelList := CreateParcelListCheckBox.Checked;
        Quit := False;
        RollSectionList := TList.Create;
        SchoolCodeList := TList.Create;
        SwisCodeList := TList.Create;
        PropertyClassList := TList.Create;

        LoadCodeList(RollSectionList, 'ZRollSectionTbl',
                     'MainCode', 'Description', Quit);
        LoadCodeList(SchoolCodeList, SchoolCodeTableName,
                     'SchoolCode', 'SchoolName', Quit);
        LoadCodeList(SwisCodeList, SwisCodeTableName,
                     'SwisCode', 'MunicipalityName', Quit);
        LoadCodeList(PropertyClassList, 'ZPropClsTbl',
                     'MainCode', 'Description', Quit);

          {FXX07131998-6: Make sure that the tables are opened for the correct assessment
                          year.}
          {Fxx07221999-1: Open all tables to TY first, then set those to NY that
                          need to be NY.}

        If not TYParcelTable.Active
          then OpenTablesForForm(Self, ThisYear);

        OpenTableForProcessingType(TYParcelTable, ParcelTableName,
                                   ThisYear, Quit);

        OpenTableForProcessingType(TYAssessmentTable, AssessmentTableName,
                                   ThisYear, Quit);

        OpenTableForProcessingType(TYClassTable, ClassTableName, ThisYear, Quit);

        OpenTableForProcessingType(TYExemptionTable, ExemptionsTableName,
                                   ThisYear, Quit);

        OpenTableForProcessingType(TYEXCodeTable, ExemptionCodesTableName,
                                   ThisYear, Quit);

        OpenTableForProcessingType(NYParcelTable, ParcelTableName,
                                   NextYear, Quit);

        OpenTableForProcessingType(NYAssessmentTable, AssessmentTableName,
                                   NextYear, Quit);

        OpenTableForProcessingType(NYClassTable, ClassTableName, NextYear, Quit);

        OpenTableForProcessingType(NYExemptionTable, ExemptionsTableName,
                                   NextYear, Quit);

        OpenTableForProcessingType(NYEXCodeTable, ExemptionCodesTableName,
                                   NextYear, Quit);

        OpenTableForProcessingType(PriorAssessmentTable, AssessmentTableName,
                                   History, Quit);

        TYParcelTable.IndexName := ParcelTable_Year_Swis_SBLKey;
        TYAssessmentTable.IndexName := 'BYTAXROLLYR_SWISSBLKEY';
        TYClassTable.IndexName := 'BYTAXROLLYR_SWISSBLKEY';
        TYExemptionTable.IndexName := 'BYYEAR_SWISSBLKEY_EXCODE';
        NYParcelTable.IndexName := ParcelTable_Year_Swis_SBLKey;
        NYAssessmentTable.IndexName := 'BYTAXROLLYR_SWISSBLKEY';
        NYClassTable.IndexName := 'BYTAXROLLYR_SWISSBLKEY';
        NYExemptionTable.IndexName := 'BYYEAR_SWISSBLKEY_EXCODE';
        NYEXCodeTable.IndexName := 'BYEXCODE';
        PriorAssessmentTable.IndexName := 'BYTAXROLLYR_SWISSBLKEY';

          {CHG03282002-7: Allow them to suppress history values.}

        ShowHistoryValues := ShowHistoryValuesCheckBox.Checked;

          {CHG10131998-1: Set the printer settings based on what printer they selected
                          only - they no longer need to worry about paper or landscape
                          mode.}

        WideCarriage := (PrintOrder <> poAddressSpecialFormat);

        AssignPrinterSettings(PrintDialog, ReportPrinter, ReportFiler, [ptBoth], WideCarriage, Quit);

        If not Quit
          then
            begin
                {FXX02252008-1(2.11.7.10): Make sure to clear the list between runs.}

              FillSelectedItemList(SwisCodeListBox, SelectedSwisCodes, 6);
              FillSelectedItemList(SchoolCodeListBox, SelectedSchoolCodes, 6);
              FillSelectedItemList(PropertyClassListBox, SelectedPropertyClasses, 3);
              FillSelectedItemList(RollSectionListBox, SelectedRollSections, 1);

                {CHG11042000-2: Allow them to not print any values.}

              SuppressValues := False;

              If (AssessedValueTypeRadioGroup.ItemIndex = avNoValues)
                then
                  begin
                    SuppressValues := True;

                      {Use the Land and Total Assessed Values format.}

                    AssessedValueTypeRadioGroup.ItemIndex := avLand_Total;

                  end;  {If (AssessedValueTypeRadioGroup.ItemIndex = avNoValues)}

              TempIndex := '';

                {FXX07091998-4: Only 1 table now - use dummy field SwisCodeKey, filled
                                in if printing by swis code.}
                {FXX-7131998-5: Need 'SBLKey' at end of name and address keys.}
                {FXX08032006-2(2.10.1.2): If printing grand totals, don't print by swis code.}

              If not PrintGrandTotals
                then TempIndex := 'SwisCode+';

              case PrintOrder of
                poRollSection : TempIndex := TempIndex + 'RollSection';
      (*          poAccountNumber : TempIndex := TempIndex + 'AccountNumber';*)
                poParcelID : TempIndex := TempIndex + 'SBLKey';
                poName : TempIndex := TempIndex + 'Name+SBLKey';
                poSchoolCode : TempIndex := TempIndex + 'SchoolCode';

                 {FXX07151998-1: Save both legal addr number and name - don't condense into
                                 one field.}
                 {CHG01072002-1: Make legal address order by legal addr #.}

                poAddress,
                poAddressSpecialFormat : TempIndex := TempIndex + 'LegalAddr+STR(LegalAddrInt)+SBLKey';
                poPropertyClass : TempIndex := TempIndex + 'PropertyClass';

              end;  {case PrintOrder of}

               {Special case for school code since can print town w/in school
                and vice-versa.}

(*              If (_Compare(PrintOrder, poSchoolCode, coEqual) and
                  (not PrintGrandTotals))
                then
                  If (SchoolCodePrintType = scTownWithinSchool)
                    then TempIndex := 'SchoolCode+SwisCodeKey'
                    else TempIndex := 'SwisCodeKey+SchoolCode'; *)

                {If there is a suborder for roll section, property class, or
                 school code, add it on. Note that a suborder of parcel ID means
                 SBLKey only - no swis code.}

              If ((PrintSuborder > -1) and
                  (PrintOrder in [poRollSection, poPropertyClass, poSchoolCode]))
                then
                  case PrintSuborder of
                    psParcelID : TempIndex := TempIndex + '+SBLKey';
                    psName : TempIndex := TempIndex + '+Name';
                      {FXX12081999-3: Allow suborder of address.}
                      {CHG01072002-1: Make legal address order by legal addr #.}

                    psAddress : TempIndex := TempIndex + '+LegalAddr+STR(LegalAddrInt)';

                      {Account number not used for now.}
      (*              psAccountNumber : TempIndex := TempIndex + ';AccountNumber'; *)

                  end;  {case PrintSuborder of}

              If (PrintSuborder = psAddress)
                then PrintOrder := poAddress;

              PrintUniformPercentOfValue := PrintUniformPercentCheckBox.Checked;

                {CHG09262002-1: Option to include 2nd owner name.}

              PrintSecondOwnerName := PrintOwnerName2CheckBox.Checked;

                {Copy the sort table and open the tables.}

                 {FXX12011997-1: Name the sort files with the date and time and
                                 extension of .SRT.}
                 {CHG04211998-1: Print to text file first.}

              SortTable.Close;
              SortTable.TableName := OrigSortFileName;

              SortFileName := GetSortFileName('AssessmentSummary');

                {FXX04211998-1: I had to split the sort table into two tables
                                since AddIndex was not working - one table which
                                has indices for grand totals (i.e not by swis) and
                                one table which has indices for by swis totals.}
                {FXX07091998-4: Only 1 table now - use dummy field SwisCodeKey, filled
                                in if printing by swis code.}

              SortTable.IndexName := '';
              CopySortFile(SortTable, SortFileName);
              SortTable.Close;
              SortTable.TableName := SortFileName;

              SortTable.AddIndex('AssessmentSummarySearchIndex',
                                 TempIndex, [ixExpression]);
              SortTable.Exclusive := True;

              try
                SortTable.Open;
              except
                Quit := True;
                SystemSupport(060, SortTable, 'Error opening sort table.',
                              UnitName, GlblErrorDlgBox);
              end;

              SortTable.IndexName := 'AssessmentSummarySearchIndex';

                {CHG07102005-1(2.8.5.5): Option to extract to Excel.}

              ExtractToExcel := ExtractToExcelCheckBox.Checked;

              If ExtractToExcel
                then
                  begin
                    SpreadsheetFileName := GetPrintFileName(Self.Caption, True);
                    AssignFile(ExtractFile, SpreadsheetFileName);
                    Rewrite(ExtractFile);

                    WritelnCommaDelimitedLine(ExtractFile,
                                              ['Assessment Year',
                                               'Swis Code',
                                               'Parcel ID',
                                               'Account #',
                                               'Owner',
                                               'Name 2',
                                               'Legal Addr #',
                                               'Legal Addr',
                                               'Roll Sect',
                                               'Ownership',
                                               'Homestead Code',
                                               'Property Class',
                                               'School Code',
                                               'Prior Total Value',
                                               GlblThisYear + ' Land Value',
                                               GlblThisYear + ' Total Value',
                                               GlblNextYear + ' Land Value',
                                               GlblNextYear + ' Total Value',
                                               'County Taxable',
                                               GetMunicipalityTypeName(GlblMunicipalityType) + ' Taxable',
                                               'School Taxable',
                                               'Village Taxable',
                                               'Residential %',
                                               'Inactive']);

                  end;  {If ExtractToExcel}

                {CHG10052002-1: Allow for printing on letter sized paper.}

              ReportPrinter.ScaleX := 100;
              ReportPrinter.ScaleY := 100;
              ReportFiler.ScaleX := 100;
              ReportFiler.ScaleY := 100;

              If (PrintOrder = poAddressSpecialFormat)
                then
                  begin
                    ReportPrinter.Orientation := poLandscape;
                    ReportFiler.Orientation := poLandscape;
                  end;

              If ((ReportPrinter.Orientation = poLandscape) and
                  (PrintOrder <> poAddressSpecialFormat))
                then
                  begin
                    If (MessageDlg('Do you want to print on letter size paper?',
                                   mtConfirmation, [mbYes, mbNo], 0) = idYes)
                      then
                        begin
                          ReportPrinter.SetPaperSize(dmPaper_Letter, 0, 0);
                          ReportFiler.SetPaperSize(dmPaper_Letter, 0, 0);
                          ReportPrinter.Orientation := poLandscape;
                          ReportFiler.Orientation := poLandscape;
                          ReportPrinter.Duplex := dupSimplex;

                          If (ReportPrinter.SupportDuplex and
                              (MessageDlg('Do you want to print on both sides of the paper?',
                                          mtConfirmation, [mbYes, mbNo], 0) = idYes))
                            then
                              If (MessageDlg('Do you want to vertically duplex this report?',
                                              mtConfirmation, [mbYes, mbNo], 0) = idYes)
                                then ReportPrinter.Duplex := dupVertical
                                else ReportPrinter.Duplex := dupHorizontal;

                          ReportPrinter.ScaleX := 83;
                          ReportPrinter.ScaleY := 80;
                          ReportPrinter.SectionLeft := 1.5;
                          ReportFiler.ScaleX := 83;
                          ReportFiler.ScaleY := 80;
                          ReportFiler.SectionLeft := 1.5;

                          LinesLeftAtBottom := GlblLinesLeftOnRollDotMatrix;
                        end
                      else LinesLeftAtBottom := GlblLinesLeftOnRollLaserJet;

                  end
                else LinesLeftAtBottom := GlblLinesLeftOnRollDotMatrix;

              If (PrintOrder = poAddressSpecialFormat)
                then LinesLeftAtBottom := 6;

              FillSortFile(Quit);
              ReportCancelled := False;

              SortTable.First;
              LastSwisCode := SortTable.FieldByName('SwisCode').Text;

                {FXX01102002-1: Taxable values for by address not supported.}

            (*  If ((PrintOrder = poAddress) and
                  (AssessedValueTypeRadioGroup.ItemIndex = avTaxableValues))
                then AssessedValueTypeRadioGroup.ItemIndex := avLand_Total;  *)

                {Now print the report.}

              If not Quit
                then
                  begin
                    ProgressDialog.Reset;
                    ProgressDialog.TotalNumRecords := GetRecordCount(SortTable);
                    ProgressDialog.UserLabelCaption := 'Printing report.';
                    GlblPreviewPrint := False;

                      {FXX10071999-1: To solve the problem of printing to the high speed,
                                      we need to set the font to a TrueType even though it
                                      doesn't matter in the actual printing.  The reason for this
                                      is that without setting it, the default font is System for
                                      the Generic printer which has a baseline descent of 0.5
                                      which messes up printing to a text file.  We needed a font
                                      with no descent.}

                    TextFiler.SetFont('Courier New', 10);

                      {If they want to preview the print (i.e. have it
                       go to the screen), then we need to come up with
                       a unique file name to tell the ReportFiler
                       component where to put the output.
                       Once we have done that, we will execute the
                       report filer which will print the report to
                       that file. Then we will create and show the
                       preview print form and give it the name of the
                       file. When we are done, we will delete the file
                       and make sure that we go back to the original
                       directory.}

                      {FXX07221998-1: So that more than one person can run the report
                                      at once, use a time based name first and then
                                      rename.}

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

                      {CHG01182000-3: Allow them to choose a different name or copy right away.}

                    ShowReportDialog('AVSUMMRY.RPT', TextFiler.FileName, True);

                  end;  {If not Quit}

                {Make sure to close and delete the sort file.}

              SortTable.Close;

                {Now delete the file.}
              try
                ChDir(GlblDataDir);
                OldDeleteFile(SortFileName);
              finally
                {We don't care if it does not get deleted, so we won't put up an
                 error message.}

                ChDir(GlblProgramDir);
              end;

                {FXX04291998-12: The finish was in the wrong place.}

              ProgressDialog.Finish;
              ResetPrinter(ReportPrinter);

            end;  {If not Quit}

        FreeTList(RollSectionList, SizeOf(CodeRecord));
        FreeTList(SchoolCodeList, SizeOf(CodeRecord));
        FreeTList(SwisCodeList, SizeOf(CodeRecord));
        FreeTList(PropertyClassList, SizeOf(CodeRecord));

        If CreateParcelList
          then ParcelListDialog.Show;

        If ExtractToExcel
          then
            begin
              CloseFile(ExtractFile);
              SendTextFileToExcelSpreadsheet(SpreadsheetFileName, True,
                                             False, '');

            end;  {If PrintToExcel}

      end;  {If PrintDialog.Execute}

end;  {PrintButtonClick}

{===================================================================}
{===============  THE FOLLOWING ARE PRINTING PROCEDURES ============}
{===================================================================}
Procedure TAssessmentSummaryReportForm.TextReportPrintHeader(Sender: TObject);

var
  TempYear : Integer;
  TempStr1, TempStr2, TempStr3, SwisStr,
  TempStr, TempSwisCode, ReportTypeString : String;
  PriorTaxYear, TaxYear : String;
  CL1, CL2, CL3, CL4, CL5 : Double;

begin
    {FXX12041998-3: Assigning tax roll year wrong.}

  case AssessmentYear of
    atThisYear,
    atBoth : TaxYear := GlblThisYear;
    atNextYear : TaxYear := GlblNextYear;
  end;  {case AssessmentYear of}

  TempYear := StrToInt(GlblThisYear);
  PriorTaxYear := IntToStr(TempYear - 1);

    {Print the date and page number.}

  with Sender as TBaseReport do
    begin
      ClearTabs;
      SetTab(0.2, pjLeft, 13.0, 0, BoxLineNone, 0);

        {FXX08242005-2(2.9.2.4): Need a blank line prior to the header so that the page break
                                 is not on the same line as the header.}
                                 
      Println('');

      If (PrintOrder = poAddressSpecialFormat)
        then Println(Take(30, 'COUNTY OF ' + GlblCountyName) +
                     Center('ASSESSMENT SUMMARY REPORT', 30) +
                     RightJustify('Page: ' + IntToStr(CurrentPage), 30))
        else Println(Take(43, 'COUNTY OF ' + GlblCountyName) +
                     Center('ASSESSMENT SUMMARY REPORT', 43) +
                     RightJustify('Page: ' + IntToStr(CurrentPage), 43));

      If PrintGrandTotals
        then TempSwisCode := Take(4, LastSwisCode)
        else TempSwisCode := LastSwisCode;

      case PrintOrder of
        poRollSection : ReportTypeString := 'ROLL SECTION';
        poSchoolCode : If (SchoolCodePrintType = scTownWithinSchool)
                         then ReportTypeString := 'TOWN WITHIN SCHOOL DISTRICT'
                         else ReportTypeString := 'SCHOOL DISTRICT WITHIN TOWN';
        poParcelID : ReportTypeString := 'PARCEL ID';
        poName : ReportTypeString := 'OWNER NAME';
        poAddress,
        poAddressSpecialFormat : ReportTypeString := 'LEGAL ADDRESS';
        poPropertyClass : ReportTypeString := 'PROPERTY CLASS';

      end;  {case PrintOrder of}

      If (PrintOrder in [poRollSection, poPropertyClass])
        then
          case PrintSuborder of
            psParcelID : ReportTypeString := ReportTypeString + '\PARCEL ID';
            psName : ReportTypeString := ReportTypeString + '\NAME';
            psAccountNumber : ReportTypeString := ReportTypeString + '\ACCOUNT NUMBER';

          end;  {case PrintSuborder of}

      ReportTypeString := ReportTypeString + ' ORDER';

      If (PrintOrder = poAddressSpecialFormat)
        then Println(Take(30, UpcaseStr(GetMunicipalityName)) +
                     Center(ReportTypeString, 30) +
                     RightJustify('Date: ' + DateToStr(Date), 30))
        else Println(Take(43, UpcaseStr(GetMunicipalityName)) +
                     Center(ReportTypeString, 43) +
                     RightJustify('Date: ' + DateToStr(Date) +
                                  '  Time: ' + TimeToStr(Now), 43));

      If PrintUniformPercentOfValue
        then
          begin
            FindNearestOld(SwisCodeTable, ['SwisCode'], [TempSwisCode]);
              {FXX04242000-3: Format messed up for percent of value.}
            TempStr1 := 'UNIFORM % OF VALUE = ' +
                       FormatFloat(DecimalEditDisplay, SwisCodeTable.FieldByName('UniformPercentValue').AsFloat) + '%';
            TempStr2 := 'TAXABLE STATUS: ' +
                        AssessmentYearControlTable.FieldByName('TaxableStatusDate').Text;
            TempStr3 := 'VALUATION DATE: ' +
                        AssessmentYearControlTable.FieldByName('ValuationDate').Text;
          end
        else
          begin
            TempStr1 := '';
            TempStr2 := '';
            TempStr3 := '';
          end;

        {FXX07151998-4: Add county and village description to header.}

      If PrintGrandTotals
        then SwisStr := ''
        else
          begin
            If (Length(Trim(TempSwisCode)) = 6)
              then
                begin
                  FindKeyOld(SwisCodeTable, ['SwisCode'], [TempSwisCode]);
                  TempStr := SwisCodeTable.FieldByName('MunicipalityName').Text;
                end
              else TempStr := '';

            SwisStr := 'SWIS - ' + TempSwisCode;

            If (Length(Trim(TempSwisCode)) <> 4)
              then SwisStr := SwisStr + ' (' + Trim(TempStr) + ')';

          end;  {else of If PrintGrandTotals}

      Println(Take(43, SwisStr) +
              Center(TempStr1, 43) +
              RightJustify(TempStr2, 43));

      If PrintUniformPercentOfValue
        then Println(Take(86, '') +
                     RightJustify(TempStr3, 43));

        {FXX07101998-4: Print the school code in the header.}

      If (PrintOrder = poSchoolCode)
        then
          begin
            FindKeyOld(SchoolCodeTable, ['SchoolCode'], [SortTable.FieldByName('SchoolCode').Text]);
            TempStr := SchoolCodeTable.FieldByName('SchoolName').Text;

            Println(Center('SCHOOL CODE = ' + Trim(TempStr), 132));

          end;  {If (PrintOrder = SchoolCode)}

      Println('');

    end;  {with Sender as TBaseReport do}

    {Set the tabs for the different header types.}
    {FXX07131998-4: Different format for address reports.}
    {CHG10112002-1: Special address report format for Rye.}

  with Sender as TBaseReport do
    If (PrintOrder <> poAddressSpecialFormat)
      then
        begin
          If (PrintOrder = poAddress)
            then
              begin
                  {If they are suppressing the values, then increase the size of
                   the name field.}
                  {CHG09262002-1: Option to include 2nd owner name.
                                  Also, on by address report make name field larger by suppressing values.}

                If SuppressValues
                  then
                    begin
                      ClearTabs;
                      SetTab(0.2, pjLeft, 0.1, 0, BoxLineNone, 0);  {Inactive?}
                      SetTab(0.4, pjLeft, 2.0, 0, BoxLineNone, 0);  {Parcel ID}
                      SetTab(2.5, pjLeft, 0.2, 0, BoxLineNone, 0);  {YR}
                      SetTab(2.8, pjLeft, 2.5, 0, BoxLineNone, 0);  {Name}
                      SetTab(5.4, pjRight, 1.0, 0, BoxLineNone, 0);  {Legal addr #}
                      SetTab(6.5, pjLeft, 2.0, 0, BoxLineNone, 0);  {Legal addr}
                      SetTab(8.6, pjLeft, 0.3, 0, BoxLineNone, 0);  {Res %}
                      SetTab(9.0, pjLeft, 0.4, 0, BoxLineNone, 0);  {Prop class}
                      SetTab(9.5, pjLeft, 0.2, 0, BoxLineNone, 0);  {R/S}
                      SetTab(9.8, pjLeft, 0.1, 0, BoxLineNone, 0);  {Homestead code}
                      SetTab(10.0, pjLeft, 0.1, 0, BoxLineNone, 0);  {Ownership code}

                      Println(#9 + #9 + #9 + #9 +
                              #9 + '     -----' +
                              #9 + 'LEGAL ADDRESS -----' +
                              #9 + 'RES' +
                              #9 + 'PRP' +
                              #9 + 'R' +
                              #9 + 'H' +
                              #9 + 'O');

                      Print(#9 + #9 + 'PARCEL ID' +
                            #9 + 'YR' +
                            #9 + 'OWNER NAME' +
                            #9 + 'NUM' +
                            #9 + '     NAME');

                      Println(#9 + '%' +
                              #9 + 'CLS' +
                              #9 + 'S' +
                              #9 + 'C' +
                              #9 + 'C');

                    end
                  else
                    begin
                      ClearTabs;
                      SetTab(0.2, pjLeft, 0.1, 0, BoxLineNone, 0);  {Inactive?}
                      SetTab(0.4, pjLeft, 1.7, 0, BoxLineNone, 0);  {Parcel ID}
                      SetTab(2.2, pjLeft, 0.6, 0, BoxLineNone, 0);  {School code}
                      SetTab(2.9, pjLeft, 0.2, 0, BoxLineNone, 0);  {YR}
                      SetTab(3.2, pjLeft, 1.1, 0, BoxLineNone, 0);  {Name}
                      SetTab(4.5, pjRight, 1.0, 0, BoxLineNone, 0);  {Legal addr #}
                      SetTab(5.6, pjLeft, 2.0, 0, BoxLineNone, 0);  {Legal addr}
                      //SetTab(7.7, pjRight, 1.2, 0, BoxLineNone, 0);  {Curr Total AV}
                      SetTab(9.1, pjRight, 1.0, 0, BoxLineNone, 0);  {NY Land AV}
                      SetTab(10.2, pjRight, 1.2, 0, BoxLineNone, 0);  {NY Total AV}
                      SetTab(11.5, pjLeft, 0.3, 0, BoxLineNone, 0);  {Res %}
                      SetTab(11.9, pjLeft, 0.4, 0, BoxLineNone, 0);  {Prop class}
                      SetTab(12.4, pjLeft, 0.2, 0, BoxLineNone, 0);  {R/S}
                      SetTab(12.7, pjLeft, 0.1, 0, BoxLineNone, 0);  {Homestead code}
                      SetTab(12.9, pjLeft, 0.1, 0, BoxLineNone, 0);  {Ownership code}

                      Println(#9 + #9 + #9 + #9 + #9 +
                              #9 + '     -----' +
                              #9 + 'LEGAL ADDRESS -----' +
                              //#9 +
                              #9 + #9 +
                              #9 + 'RES' +
                              #9 + 'PRP' +
                              #9 + 'R' +
                              #9 + 'H' +
                              #9 + 'O');

                      Print(#9 + #9 + 'PARCEL ID' +
                            #9 + 'SCHOOL' +
                            #9 + 'YR' +
                            #9 + 'OWNER NAME' +
                            #9 + 'NUM' +
                            #9 + '     NAME');

                          {FXX07211999-8: Fix up assessment summary for TY vs. NY issues.}

                      If PrintNextYearValues
                        then Print(//#9 + GlblThisYear + ' TOTAL' +
                                   #9 + GlblNextYear + ' LAND' +
                                   #9 + GlblNextYear + ' TOTAL')
                        else Print(//#9 + PriorTaxYear + ' TOTAL' +
                                   #9 + GlblThisYear + ' LAND' +
                                   #9 + GlblThisYear + ' TOTAL');

                      Println(#9 + ' %' +
                              #9 + 'CLS' +
                              #9 + 'S' +
                              #9 + 'C' +
                              #9 + 'C');

                    end;  {else of If SuppressValues}

                Println('');

              end
            else
              If (AssessedValueType = avTaxableValues)
                then
                  begin
                    ClearTabs;
                    SetTab(0.2, pjLeft, 0.1, 0, BoxLineNone, 0);  {Inactive?}
                    SetTab(0.4, pjLeft, 1.7, 0, BoxLineNone, 0);  {Parcel ID}
                    SetTab(2.2, pjLeft, 0.6, 0, BoxLineNone, 0);  {School}
                    SetTab(2.9, pjLeft, 0.2, 0, BoxLineNone, 0);  {YR}
                    SetTab(3.2, pjLeft, 1.8, 0, BoxLineNone, 0);  {Name}
                    SetTab(5.1, pjRight, 1.2, 0, BoxLineNone, 0);  {Total AV}
                    SetTab(6.4, pjRight, 1.2, 0, BoxLineNone, 0);  {County taxable}
                    SetTab(7.7, pjRight, 1.2, 0, BoxLineNone, 0);  {Town taxable}
                    SetTab(9.0, pjRight, 1.2, 0, BoxLineNone, 0);  {School taxable}
                    SetTab(10.3, pjRight, 1.2, 0, BoxLineNone, 0);  {Village taxable}
                    SetTab(11.6, pjLeft, 0.3, 0, BoxLineNone, 0);  {Res %}
                    SetTab(12.0, pjLeft, 0.3, 0, BoxLineNone, 0);  {Prop class}
                    SetTab(12.4, pjRight, 0.2, 0, BoxLineNone, 0);  {R\S}
                    SetTab(12.7, pjRight, 0.2, 0, BoxLineNone, 0);  {Homestead code}
                    SetTab(13.0, pjLeft, 0.1, 0, BoxLineNone, 0);  {Ownership code}

                    Println(#9 + #9 + #9 + #9 + #9 + #9 +
                            #9 + ConstStr('-', 11) +
                            #9 + '--- TAXABLE' +
                            #9 + 'VALUES -----' +
                            #9 + ConstStr('-', 11) +
                            #9 + 'RES' +
                            #9 + 'PRP' +
                            #9 + 'R' +
                            #9 + 'H' +
                            #9 + 'O');

                      {CHG01192004-1(2.08): Let each municipality decide what roll totals to display.}

                    Print(#9 + #9 + 'PARCEL ID' +
                          #9 + 'SCHOOL' +
                          #9 + 'YR' +
                          #9 + 'OWNER NAME' +
                          #9 + {TaxYear + }' TOTAL');

                    If (rtdCounty in GlblRollTotalsToShow)
                      then Print(#9 + 'COUNTY')
                      else Print(#9);

                    If (rtdMunicipal in GlblRollTotalsToShow)
                      then Print(#9 + UpcaseStr(GetMunicipalityTypeName(GlblMunicipalityType)))
                      else Print(#9);

                    If (rtdSchool in GlblRollTotalsToShow)
                      then Print(#9 + 'SCHOOL')
                      else Print(#9);

                    If (rtdVillageReceivingPartialRoll in GlblRollTotalsToShow)
                      then Print(#9 + 'VILLAGE')
                      else Print(#9);

                    Println(#9 + ' %' +
                            #9 + 'CLS' +
                            #9 + 'S' +
                            #9 + 'C' +
                            #9 + 'C');

                    Println('');

                  end
                else
                  begin
                       {Land \ Total assessed value.}
                       {FXX07211999-8: Fix up assessment summary for TY vs. NY issues.}

                    If PrintNextYearValues
                      then
                        begin
                          CL1 := 11.7;
                          CL2 := 12.1;
                          CL3 := 12.6;
                          CL4 := 12.9;
                          CL5 := 13.1;
                        end
                      else
                        begin
                          CL1 := 9.2;
                          CL2 := 9.6;
                          CL3 := 10.1;
                          CL4 := 10.4;
                          CL5 := 11.6;
                        end;

                    ClearTabs;
                    SetTab(0.2, pjLeft, 0.1, 0, BoxLineNone, 0);  {Inactive?}
                    SetTab(0.4, pjLeft, 1.7, 0, BoxLineNone, 0);  {Parcel ID}
                    SetTab(2.2, pjLeft, 0.6, 0, BoxLineNone, 0);  {Parcel ID}
                    SetTab(2.9, pjLeft, 0.2, 0, BoxLineNone, 0);  {YR}
                    SetTab(3.2, pjLeft, 1.9, 0, BoxLineNone, 0);  {Name}
                    SetTab(5.3, pjRight, 1.3, 0, BoxLineNone, 0);  {Prior Total AV}
                    SetTab(6.7, pjRight, 1.0, 0, BoxLineNone, 0);  {Curr Land AV}
                    SetTab(7.8, pjRight, 1.3, 0, BoxLineNone, 0);  {Curr Total AV}

                    If PrintNextYearValues
                      then
                        begin
                          SetTab(9.2, pjRight, 1.0, 0, BoxLineNone, 0);  {NY Land AV}
                          SetTab(10.3, pjRight, 1.3, 0, BoxLineNone, 0);  {NY Total AV}
                        end;

                    SetTab(CL1, pjLeft, 0.3, 0, BoxLineNone, 0);  {Res %}
                    SetTab(CL2, pjLeft, 0.4, 0, BoxLineNone, 0);  {Prop class}
                    SetTab(CL3, pjLeft, 0.2, 0, BoxLineNone, 0);  {R/S}
                    SetTab(CL4, pjLeft, 0.1, 0, BoxLineNone, 0);  {Homestead code}
                    SetTab(CL5, pjLeft, 0.1, 0, BoxLineNone, 0);  {Ownership code}

                    Print(#9 + #9 + #9 + #9 + #9 + #9 + #9 + #9);

                    If PrintNextYearValues
                      then Print(#9 + #9);

                    Println(#9 + 'RES' +
                            #9 + 'PRP' +
                            #9 + 'R' +
                            #9 + 'H' +
                            #9 + 'O');

                    Print(#9 + #9 + 'PARCEL ID' +
                          #9 + 'SCHOOL' +
                          #9 + 'YR' +
                          #9 + 'OWNER NAME' +
                          #9 + PriorTaxYear + ' TOTAL' +
                          #9 + GlblThisYear + ' LAND' +
                          #9 + GlblThisYear + ' TOTAL');

                    If PrintNextYearValues
                      then Print(#9 + GlblNextYear + ' LAND' +
                                 #9 + GlblNextYear + ' TOTAL');

                    Println(#9 + ' %' +
                            #9 + 'CLS' +
                            #9 + 'S' +
                            #9 + 'C' +
                            #9 + 'C');

                    Println('');

                  end;  {else of If (AssessedValueType = avTaxableValues)}

        end;  {If (PrintOrder <> poAddressSpecialFormat)}

end;  {ReportFilerPrintHeader}

{===================================================================}
Procedure TAssessmentSummaryReportForm.PrintOneLine(Sender : TObject);

var
  PriorValueString, InactiveString : String;

begin
    {CHG10112002-1: Special address report format for Rye.}

  with Sender as TBaseReport, SortTable do
    If (PrintOrder = poAddressSpecialFormat)
      then
        begin
          ClearTabs;
          SetTab(0.2, pjLeft, 8.0, 0, BoxLineNone, 0);  {}
          Println(#9 + ConstStr('-', 108));

          ClearTabs;
          SetTab(0.5, pjLeft, 3.0, 0, BoxLineNone, 0);  {Owner}
          SetTab(3.6, pjLeft, 2.5, 0, BoxLineNone, 0);  {2nd Owner}
          SetTab(6.1, pjLeft, 2.0, 0, BoxLineNone, 0);  {Parcel ID}

          Println(#9 + 'OWNER: ' + FieldByName('Name').Text +
                  #9 + FieldByName('Name2').Text +
                  #9 + 'PARCEL ID: ' +  ConvertSBLOnlyToDashDot(FieldByName('SBLKey').Text) );
          Println('');

          ClearTabs;
          SetTab(0.5, pjLeft, 3.0, 0, BoxLineNone, 0);  {Addr #}
          SetTab(3.6, pjLeft, 2.5, 0, BoxLineNone, 0);  {Legal Addr}

          Println(#9 + 'PROPERTY LOCATION: ' +
                       FieldByName('LegalAddrNo').Text +
                  #9 + FieldByName('LegalAddr').Text);
          Println('');
        end
      else
        begin
          If FieldByName('Active').AsBoolean
            then InactiveString := ''
            else InactiveString := '*';

          Print(#9 + InactiveString +
                #9 + ConvertSBLOnlyToDashDot(FieldByName('SBLKey').Text) +
                #9 + FieldByName('SchoolCode').AsString);

          If (FieldByName('TaxRollYr').Text = GlblThisYear)
            then Print(#9 + 'T')
            else Print(#9 + 'N');

            {FXX07131998-4: Different format for address reports.}
            {CHG09262002-1: Option to include 2nd owner name.
                            Also, on by address report make name field larger by suppressing values.}

          If (PrintOrder = poAddress)
            then
              begin
                If SuppressValues
                  then Print(#9 + FieldByName('Name').Text)
                  else Print(#9 + Take(11, FieldByName('Name').Text));

               end
            else
              If (AssessedValueType = avTaxableValues)
                then Print(#9 + Take(18, FieldByName('Name').Text))
                else Print(#9 + Take(21, FieldByName('Name').Text));

          If (PrintOrder = poAddress)
          then Print(#9 + Trim(Take(10, FieldByName('LegalAddrNo').Text)) +
                     #9 + Take(19, FieldByName('LegalAddr').Text));

          If (AssessedValueType = avTaxableValues)
            then
              begin
                If SuppressValues
                  then Print(#9 + #9 + #9 + #9 + #9)
                  else
                    begin
                      If (SortTable.FieldByName('TaxRollYr').Text = GlblThisYear)
                        then Print(#9 + FormatFloat(CurrencyDisplayNoDollarSign,
                                                    TCurrencyField(FieldByName('CurrTotalAssessedVal')).Value))
                        else Print(#9 + FormatFloat(CurrencyDisplayNoDollarSign,
                                                    TCurrencyField(FieldByName('NYTotalAssessedVal')).Value));

                        {CHG01192004-1(2.08): Let each municipality decide what roll totals to display.}

                      If (rtdCounty in GlblRollTotalsToShow)
                        then Print(#9 + FormatFloat(CurrencyDisplayNoDollarSign,
                                                    TCurrencyField(FieldByName('CountyTaxableVal')).Value))
                        else Print(#9);

                     If (rtdMunicipal in GlblRollTotalsToShow)
                       then Print(#9 + FormatFloat(CurrencyDisplayNoDollarSign,
                                                   TCurrencyField(FieldByName('TownTaxableVal')).Value))
                       else Print(#9);

                     If (rtdSchool in GlblRollTotalsToShow)
                       then Print(#9 + FormatFloat(CurrencyDisplayNoDollarSign,
                                                   TCurrencyField(FieldByName('SchoolTaxableVal')).Value))
                       else Print(#9);

                        {FXX07151998-3: Only print village amount if this is a village munic.}

                      If (rtdVillageReceivingPartialRoll in GlblRollTotalsToShow)
                        then Print(#9 + FormatFloat(CurrencyDisplayNoDollarSign,
                                                    TCurrencyField(FieldByName('VillageTaxableVal')).Value))
                        else Print(#9 + '0');

                    end;  {else of If SuppressValues}

              end
            else
              If (PrintOrder = poAddress)
                then
                  begin
                    (*Print(#9 + Trim(Take(10, FieldByName('LegalAddrNo').Text)) +
                          #9 + Take(19, FieldByName('LegalAddr').Text));  *)

                      {CHG09262002-1: Option to include 2nd owner name.
                                      Also, on by address report, make name field larger by suppressing values.}

                    If not SuppressValues
                      then
                        If PrintNextYearValues
                          then Print((*#9 + FormatFloat(CurrencyDisplayNoDollarSign,
                                                      TCurrencyField(FieldByName('CurrTotalAssessedVal')).Value) + *)
                                     #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                                                      TCurrencyField(FieldByName('NYLandAssessedVal')).Value) +
                                     #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                                                      TCurrencyField(FieldByName('NYTotalAssessedVal')).Value))
                          else
                            begin
                                {CHG03282002-7: Allow them to suppress history values.}

                              If ShowHistoryValues
                                then PriorValueString := FormatFloat(CurrencyDisplayNoDollarSign,
                                                                     FieldByName('PriorTotAssessedVal').AsFloat)
                                else PriorValueString := '';

                              Print(//#9 + PriorValueString +
                                    #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                                                     TCurrencyField(FieldByName('CurrLandAssessedVal')).Value) +
                                    #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                                                     TCurrencyField(FieldByName('CurrTotalAssessedVal')).Value))

                            end;  {else of If PrintNextYearValues}

                  end
                else
              begin
                  {FXX07131998-4: Different format for address reports.}
                  {FXX07151998-1: Save both legal addr number and name - don't condense into
                                  one field.}
                  {FXX07151998-6: The legal address is so big, have to take out current land.}
                  {FXX07211999-8: Fix up assessment summary for TY vs. NY issues.}

                If SuppressValues
                  then
                    begin
                      If PrintNextYearValues
                        then Print(#9 + #9 + #9 + #9 + #9)
                        else Print(#9 + #9 + #9);

                    end
                  else
                    begin
                        {CHG03282002-7: Allow them to suppress history values.}

                      If ShowHistoryValues
                        then PriorValueString := FormatFloat(CurrencyDisplayNoDollarSign,
                                                             FieldByName('PriorTotAssessedVal').AsFloat)
                        else PriorValueString := '';

                      Print(#9 + PriorValueString +
                            #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                                             TCurrencyField(FieldByName('CurrLandAssessedVal')).Value) +
                            #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                                             TCurrencyField(FieldByName('CurrTotalAssessedVal')).Value));

                      If PrintNextYearValues
                        then Print(#9 + FormatFloat(CurrencyDisplayNoDollarSign,
                                                    TCurrencyField(FieldByName('NYLandAssessedVal')).Value) +
                                   #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                                                    TCurrencyField(FieldByName('NYTotalAssessedVal')).Value));

                    end;  {else of If SuppressValues}

              end;  {else of If (AssessedValueType = avTaxableValues)}

          Println(#9 + FormatFloat(NoDecimalDisplay_BlankZero,
                                   FieldByName('ResidentialPercent').AsFloat) +
                  #9 + FieldByName('PropertyClass').Text +
                  #9 + FieldByName('RollSection').Text +
                       FieldByName('RollSubsection').Text +
                  #9 + FieldByName('HomesteadCode').Text +
                  #9 + FieldByName('OwnershipCode').Text);

           {CHG09262002-1: Option to include 2nd owner name.}

          If (PrintSecondOwnerName and
              (Deblank(FieldByName('Name2').Text) <> ''))
            then Println(#9 + #9 + #9 +
                         #9 + FieldByName('Name2').Text);

        end;  {else If (PrintOrder = poAddressSpecialFormat)}

    {CHG07102005-1(2.8.5.5): Option to extract to Excel.}

  If ExtractToExcel
    then
      with SortTable do
        WritelnCommaDelimitedLine(ExtractFile,
                                  [FieldByName('TaxRollYr').Text,
                                   FieldByName('SwisCode').Text,
                                   ConvertSBLOnlyToDashDot(FieldByName('SBLKey').Text),
                                   FieldByName('AccountNumber').Text,
                                   FieldByName('Name').Text,
                                   FieldByName('Name2').Text,
                                   FieldByName('LegalAddrNo').Text,
                                   FieldByName('LegalAddr').Text,
                                   FieldByName('RollSection').Text,
                                   FieldByName('OwnershipCode').Text,
                                   FieldByName('HomesteadCode').Text,
                                   FieldByName('PropertyClass').Text,
                                   FieldByName('SchoolCode').Text,
                                   FieldByName('PriorTotAssessedVal').Text,
                                   FieldByName('CurrLandAssessedVal').Text,
                                   FieldByName('CurrTotalAssessedVal').Text,
                                   FieldByName('NYLandAssessedVal').Text,
                                   FieldByName('NYTotalAssessedVal').Text,
                                   FieldByName('CountyTaxableVal').Text,
                                   FieldByName('TownTaxableVal').Text,
                                   FieldByName('SchoolTaxableVal').Text,
                                   FieldByName('VillageTaxableVal').Text,
                                   FieldByName('ResidentialPercent').Text,
                                   InactiveString]);

end;  {PrintOneLine}

{===================================================================}
Function InitializeTotalsRecord(var TotalsRec : TotalsRecord) : TotalsRecord;

begin
  with TotalsRec do
    begin
      TaxRollYr := '';
      NumHstdActiveParcels := 0;
      NumHstdInactiveParcels := 0;
      NumNonhstdActiveParcels := 0;
      NumNonhstdInactiveParcels := 0;
      HstdCurrentTotalAV := 0;
      HstdCurrentLandAV := 0;
      NonhstdCurrentTotalAV := 0;
      NonhstdCurrentLandAV := 0;
      HstdNYTotalAV := 0;
      HstdNYLandAV := 0;
      NonhstdNYTotalAV := 0;
      NonhstdNYLandAV := 0;
      PriorTotalAV := 0;
      HstdTownTaxableVal := 0;
      HstdCountyTaxableVal := 0;
      HstdSchoolTaxableVal := 0;
      HstdVillageTaxableVal := 0;
      NonhstdTownTaxableVal := 0;
      NonhstdCountyTaxableVal := 0;
      NonhstdSchoolTaxableVal := 0;
      NonhstdVillageTaxableVal := 0;

    end;  {with TotalsRec do}

end;  {InitializeTotalsRecord}

{===================================================================}
Procedure TAssessmentSummaryReportForm.UpdateTotals(    SortTable : TTable;
                                                        _TaxRollYr : String;
                                                    var TotalsRec : TotalsRecord);

var
  HomesteadCode : Char;

begin
  If (SortTable.FieldByName('TaxRollYr').Text = _TaxRollYr)
    then
      with TotalsRec, SortTable do
        begin
          TaxRollYr := _TaxRollYr;
          HomesteadCode := Take(1, SortTable.FieldByName('HomesteadCode').Text)[1];

            {If they do not want to see homestead amounts, or this is a homestead
             part, use the homestead totals.}

          If ((not ShowHomesteadAmounts) or
              (HomesteadCode in ['H', ' ']))
            then
              begin
                If FieldByName('Active').AsBoolean
                  then NumHstdActiveParcels := NumHstdActiveParcels + 1
                  else NumHstdInactiveParcels := NumHstdInactiveParcels + 1;

                        {FXX07081998-3: Only update totals if this is an active parcel.}

                If (AssessedValueType = avTaxableValues)
                  then
                    begin
                      HstdTownTaxableVal := HstdTownTaxableVal + FieldByName('TownTaxableVal').AsFloat;
                      HstdCountyTaxableVal := HstdCountyTaxableVal + FieldByName('CountyTaxableVal').AsFloat;
                      HstdSchoolTaxableVal := HstdSchoolTaxableVal + FieldByName('SchoolTaxableVal').AsFloat;
                      HstdVillageTaxableVal := HstdVillageTaxableVal + FieldByName('VillageTaxableVal').AsFloat;

                        {FXX04301998-1: Update the current total AV.}

                      HstdCurrentTotalAV := HstdCurrentTotalAV + FieldByName('CurrTotalAssessedVal').AsFloat;
                    end
                  else
                    begin
                      HstdCurrentTotalAV := HstdCurrentTotalAV + FieldByName('CurrTotalAssessedVal').AsFloat;
                      HstdCurrentLandAV := HstdCurrentLandAV + FieldByName('CurrLandAssessedVal').AsFloat;
                      HstdNYTotalAV := HstdNYTotalAV + FieldByName('NYTotalAssessedVal').AsFloat;
                      HstdNYLandAV := HstdNYLandAV + FieldByName('NYLandAssessedVal').AsFloat;

                    end;  {else of If (AssessedValueType = avTaxableValues)}

              end;  {If ((not ShowHomesteadAmounts) or ...}

            {FXX07081998-2: Only keep nonhstd tots if showing homestead amounts.}

          If (ShowHomesteadAmounts and
              (HomesteadCode = 'N'))
            then
              begin
                If FieldByName('Active').AsBoolean
                  then
                    begin
                      NumNonhstdActiveParcels := NumNonhstdActiveParcels + 1;

                        {FXX07081998-3: Only update totals if this is an active parcel.}

                      If (AssessedValueType = avTaxableValues)
                        then
                          begin
                            NonhstdTownTaxableVal := NonhstdTownTaxableVal + FieldByName('TownTaxableVal').AsFloat;
                            NonhstdCountyTaxableVal := NonhstdCountyTaxableVal + FieldByName('CountyTaxableVal').AsFloat;
                            NonhstdSchoolTaxableVal := NonhstdSchoolTaxableVal + FieldByName('SchoolTaxableVal').AsFloat;
                            NonhstdVillageTaxableVal := NonhstdVillageTaxableVal + FieldByName('VillageTaxableVal').AsFloat;

                              {FXX04301998-1: Update the current total AV.}

                            NonhstdCurrentTotalAV := NonhstdCurrentTotalAV + FieldByName('CurrTotalAssessedVal').AsFloat;
                          end
                        else
                          begin
                            NonhstdCurrentTotalAV := NonhstdCurrentTotalAV + FieldByName('CurrTotalAssessedVal').AsFloat;
                            NonhstdCurrentLandAV := NonhstdCurrentLandAV + FieldByName('CurrLandAssessedVal').AsFloat;
                            NonhstdNYTotalAV := NonhstdNYTotalAV + FieldByName('NYTotalAssessedVal').AsFloat;
                            NonhstdNYLandAV := NonhstdNYLandAV + FieldByName('NYLandAssessedVal').AsFloat;

                          end;  {else of If (AssessedValueType = avTaxableValues)}

                    end
                  else NumNonhstdInactiveParcels := NumNonhstdInactiveParcels + 1;

              end;  {If (HomesteadCode = 'N')}

            {FXX07091998-2: Don't update prior AV if not active.}

          If FieldByName('Active').AsBoolean
            then PriorTotalAV := PriorTotalAV + FieldByName('PriorTotAssessedVal').AsFloat;

        end;  {with TotalsRec do}

end;  {UpdateTotals}

{===================================================================}
Procedure PrintOneTaxableValTotal(Sender : TObject;
                                  TotalsType : Char; {(H)std, (N)hstd, (G)rand}
                                  Totals : TotalsRecord);

{Print the totals for a section in a report that shows taxable values.}

var
  NumActive, NumInactive : LongInt;
  TotalAV, TotalCountyTaxable,
  TotalTownTaxable, TotalSchoolTaxable, TotalVillageTaxable : Comp;
  TempStr : String;

begin
  NumActive := 0;
  NumInactive := 0;
  TotalAV := 0;
  TotalCountyTaxable := 0;
  TotalTownTaxable := 0;
  TotalSchoolTaxable := 0;
  TotalVillageTaxable := 0;

  with Sender as TBaseReport do
    begin
      with Totals do
        case TotalsType of
          'H' : begin
                  NumActive := NumHstdActiveParcels;
                  NumInactive := NumHstdInactiveParcels;
                  TotalAV := HstdCurrentTotalAV;
                  TotalCountyTaxable := HstdCountyTaxableVal;
                  TotalTownTaxable := HstdTownTaxableVal;
                  TotalSchoolTaxable := HstdSchoolTaxableVal;
                  TotalVillageTaxable := HstdVillageTaxableVal;
                  TempStr := '  HSTD';

                end;  {Hstd}

          'N' : begin
                  NumActive := NumNonhstdActiveParcels;
                  NumInactive := NumNonhstdInactiveParcels;
                  TotalAV := NonhstdCurrentTotalAV;
                  TotalCountyTaxable := NonhstdCountyTaxableVal;
                  TotalTownTaxable := NonhstdTownTaxableVal;
                  TotalSchoolTaxable := NonhstdSchoolTaxableVal;
                  TotalVillageTaxable := NonhstdVillageTaxableVal;
                  TempStr := '  NONHSTD';

                end;  {Nonhstd}

               {FXX07131998-5: Print 'TOTAL' instead of grand.}

          'G' : begin
                  NumActive := NumHstdActiveParcels + NumNonhstdActiveParcels;
                  NumInactive := NumHstdInactiveParcels + NumNonhstdInactiveParcels;
                  TotalAV := HstdCurrentTotalAV + NonhstdCurrentTotalAV;
                  TotalCountyTaxable := HstdCountyTaxableVal + NonhstdCountyTaxableVal;
                  TotalTownTaxable := HstdTownTaxableVal + NonhstdTownTaxableVal;
                  TotalSchoolTaxable := HstdSchoolTaxableVal + NonhstdSchoolTaxableVal;
                  TotalVillageTaxable := HstdVillageTaxableVal + NonhstdVillageTaxableVal;
                  TempStr := '  TOTAL';

                end;  {Grand}

        end;  {case TotalsType of}

        {FXX07151998-3: Only print village amount if this is a village munic.}

      If (GlblMunicipalityType = mtVillage)
        then TotalVillageTaxable := 0;

        {CHG01192004-1(2.08): Let each municipality decide what roll totals to display.}

      with Totals do
        begin
          Print(#9 + #9 + TempStr +
                #9 +
                #9 + 'ACT=' + IntToStr(NumActive) + '  ' +
                     'INACT=' + IntToStr(NumInactive) +
                #9 + FormatFloat(CurrencyDisplayNoDollarSign, TotalAV));

          If (rtdCounty in GlblRollTotalsToShow)
            then Print(#9 + FormatFloat(CurrencyDisplayNoDollarSign, TotalCountyTaxable))
            else Print(#9);

          If (rtdMunicipal in GlblRollTotalsToShow)
            then Print(#9 + FormatFloat(CurrencyDisplayNoDollarSign, TotalTownTaxable))
            else Print(#9);

          If (rtdSchool in GlblRollTotalsToShow)
            then Print(#9 + FormatFloat(CurrencyDisplayNoDollarSign, TotalSchoolTaxable))
            else Print(#9);

          If (rtdVillageReceivingPartialRoll in GlblRollTotalsToShow)
            then Println(#9 + FormatFloat(CurrencyDisplayNoDollarSign, TotalVillageTaxable))
            else Println('');

        end;  {with Totals do}

    end;  {with Sender as TBaseReport do}

end;  {PrintOneTaxableValTotal}

{===================================================================}
Procedure TAssessmentSummaryReportForm.PrintOneLand_TotalValTotal(Sender : TObject;
                                                                  TotalsType : Char; {(H)std, (N)hstd, (G)rand}
                                                                  PrintOrder : Integer;
                                                                  AssessmentYear : Integer;
                                                                  Totals : TotalsRecord);

{Print the totals for a section in a report that shows taxable values.}

var
  NumActive, NumInactive : LongInt;
  TotalCurrentLandAV, TotalCurrentTotalAV, TotalNYLandAV, TotalNYTotalAV : Comp;
  TempStr : String;

begin
  NumActive := 0;
  NumInactive := 0;
  TotalCurrentLandAV := 0;
  TotalCurrentTotalAV := 0;
  TotalNYLandAV := 0;
  TotalNYTotalAV := 0;

  with Sender as TBaseReport do
    begin
      with Totals do
        case TotalsType of
          'H' : begin
                  NumActive := NumHstdActiveParcels;
                  NumInactive := NumHstdInactiveParcels;
                  TotalCurrentTotalAV := HstdCurrentTotalAV;
                  TotalCurrentLandAV := HstdCurrentLandAV;
                  TotalNYTotalAV := HstdNYTotalAV;
                  TotalNYLandAV := HstdNYLandAV;
                  TempStr := '  HSTD';

                end;  {Hstd}

          'N' : begin
                  NumActive := NumNonhstdActiveParcels;
                  NumInactive := NumNonhstdInactiveParcels;
                  TotalCurrentTotalAV := NonhstdCurrentTotalAV;
                  TotalCurrentLandAV := NonhstdCurrentLandAV;
                  TotalNYTotalAV := NonhstdNYTotalAV;
                  TotalNYLandAV := NonhstdNYLandAV;
                  TempStr := '  NONHSTD';

                end;  {Nonhstd}

          'G' : begin
                  NumActive := NumHstdActiveParcels + NumNonhstdActiveParcels;
                  NumInactive := NumHstdInactiveParcels + NumNonhstdInactiveParcels;
                  TotalCurrentTotalAV := HstdCurrentTotalAV + NonhstdCurrentTotalAV;
                  TotalCurrentLandAV := HstdCurrentLandAV + NonhstdCurrentLandAV;
                  TotalNYTotalAV := HstdNYTotalAV + NonhstdNYTotalAV;
                  TotalNYLandAV := HstdNYLandAV + NonhstdNYLandAV;
                  TempStr := '  TOTAL';

                end;  {Grand}

        end;  {case TotalsType of}

      with Totals do
        Print(#9 + #9 +
              #9 + TempStr + #9 +
              #9 + 'ACT=' + IntToStr(NumActive) + '  ' +
                   'INAC=' + IntToStr(NumInactive));

        {FXX07131998-4: Different format for address reports.}
        {FXX07211999-8: Fix up assessment summary for TY vs. NY issues.}

      If (PrintOrder = poAddress)
        then Print(#9 + '' +
                   #9 + '' +
                   #9 + '')
        else Print(#9 + FormatFloat(CurrencyDisplayNoDollarSign, Totals.PriorTotalAV) +
                   #9 + FormatFloat(CurrencyDisplayNoDollarSign, TotalCurrentLandAV));

      with Totals do
        Print(#9 + FormatFloat(CurrencyDisplayNoDollarSign, TotalCurrentTotalAV));

       {FXX09161998-2: Don't print NY totals if printing both years since not
                       all NY totals are printed.}

      with Totals do
        If ((AssessmentYear = atBoth) or
            (not PrintNextYearValues))
          then Println('')
          else Println(#9 + FormatFloat(CurrencyDisplayNoDollarSign, TotalNYLandAV) +
                       #9 + FormatFloat(CurrencyDisplayNoDollarSign, TotalNYTotalAV));

    end;  {with Sender as TBaseReport do}

end;  {PrintOneTaxableValTotal}

{===================================================================}
Procedure TAssessmentSummaryReportForm.PrintTotals(Sender : TObject;
                                                   TotalType : Integer;  {ttGrandTotal, ttSwisTotal, ttSectionTotal}
                                                   BreakCode : String;
                                                   Totals : TotalsRecord);

var
  TempStr, TempHdr, Description : String;

begin
  with Sender as TBaseReport do
    begin
      Println('');

      If (LinesLeft < LinesLeftAtBottom)
        then NewPage;

      If (AssessedValueType = avTaxableValues)
        then TempStr := Totals.TaxRollYr
        else TempStr := '';

        {FXX07151998-5: Print a description for the break.}

      case TotalType of
        ttSectionTotal :
          begin
            case PrintOrder of
              poRollSection :
                begin
                  TempHdr := 'ROLL SECTION ';
                  Description := GetDescriptionFromList(BreakCode,
                                                        RollSectionList);
                end;

              poSchoolCode :
                begin
                  TempHdr := 'SCHOOL CODE ';
                  Description := GetDescriptionFromList(BreakCode,
                                                        SchoolCodeList);
                end;

              poPropertyClass :
                begin
                  TempHdr := 'PROPERTY CLASS ';
                  Description := GetDescriptionFromList(BreakCode,
                                                        PropertyClassList);
                end;

            end;  {case PrintOrder of}

            Println(#9 + #9 +
                    #9 + TempStr + ' ' +
                    TempHdr + Trim(BreakCode) + ' (' +
                    Trim(Description) + '):');

          end;  {ttSectionTotal : }

        ttSwisTotal :
          begin
            Description := GetDescriptionFromList(BreakCode,
                                                  SwisCodeList);

            Println(#9 + #9 +
                    #9 + TempStr + ' ' +
                    'SWIS ' + Trim(BreakCode) + ' (' +
                    Trim(Description) + '):');

          end;  {ttSwisTotal :}

        ttGrandTotal : Println(#9 + #9 +
                               #9 + TempStr + ' ' + 'OVERALL TOTAL:');

      end;  {case TotalType of}

       {Now display the totals based on what type of values they are seeing
        and if they want to see class totals.}

     If (AssessedValueType = avTaxableValues)
       then
         begin
           If ShowHomesteadAmounts
             then
               begin
                 PrintOneTaxableValTotal(Sender, 'H', Totals);
                 PrintOneTaxableValTotal(Sender, 'N', Totals);
               end;  {If ShowHomesteadTotals}

           PrintOneTaxableValTotal(Sender, 'G', Totals);

         end
       else
         begin
           If ShowHomesteadAmounts
             then
               begin
                 PrintOneLand_TotalValTotal(Sender, 'H', PrintOrder, AssessmentYear, Totals);
                 PrintOneLand_TotalValTotal(Sender, 'N', PrintOrder, AssessmentYear, Totals);
               end;  {If ShowHomesteadTotals}

           PrintOneLand_TotalValTotal(Sender, 'G', PrintOrder, AssessmentYear, Totals);

         end;  {else of If (AssessedValueType = avTaxableValues)}

    end;  {with Sender as TBaseReport do}

end;  {PrintTotals}

{===================================================================}
Procedure TAssessmentSummaryReportForm.TextReportPrint(Sender: TObject);

var
  TaxRollYr : String;
  SwisCodeChanged,
  SchoolCodeChanged,
  Quit, Done, FirstTimeThrough : Boolean;
  LastRollSection : String;
  LastPropertyClass : String;
  LastSchoolCode : String;
  BySwisTotals, BySectionTotals, GrandTotals : TotalsRecord;

begin
  Done := False;
  Quit := False;
  LastRollSection := '';
  LastPropertyClass := '';
  LastSchoolCode := '';

  SortTable.First;

  LastSwisCode := SortTable.FieldByName('SwisCode').Text;
  FirstTimeThrough := True;

  case AssessmentYear of
    atThisYear,
    atBoth : TaxRollYr := GlblThisYear;
    atNextYear : TaxRollYr := GlblNextYear;
  end;  {case AssessmentYear of}

  InitializeTotalsRecord(BySwisTotals);
  InitializeTotalsRecord(BySectionTotals);
  InitializeTotalsRecord(GrandTotals);

  with Sender as TBaseReport do
    begin
      repeat
        If FirstTimeThrough
          then FirstTimeThrough := False
          else SortTable.Next;

        If SortTable.EOF
          then Done := True;

        SwisCodeChanged := False;

        If ((Deblank(LastSwisCode) <> '') and
            (SortTable.FieldByName('SwisCode').Text <> LastSwisCode) and
            (not PrintGrandTotals))
          then SwisCodeChanged := True;

        SchoolCodeChanged := False;

        If ((Deblank(LastSchoolCode) <> '') and
            (SortTable.FieldByName('SchoolCode').Text <> LastSchoolCode))
          then SchoolCodeChanged := True;

           {Print roll section totals.}

        If ((PrintOrder = poRollSection) and
            (Done or
             ((Deblank(LastRollSection) <> '') and
              (SortTable.FieldByName('RollSection').Text <> LastRollSection))))
          then
            begin
              PrintTotals(Sender, ttSectionTotal, LastRollSection, BySectionTotals);

              InitializeTotalsRecord(BySectionTotals);

                {Go to a new page if this is going to be the only total on
                 the page. We don't want to page if this is the last page
                 since there will be grand totals or if this is a swis
                 break since there will be swis totals.}

              If (not (Done or
                       (SwisCodeChanged and
                        (not PrintGrandTotals))))
                then NewPage;

            end;  {If ((Deblank(LastSwisCode) <> '') and ...}

           {Print School code totals.}
           {FXX07101998-2: Also need to do school\swis totals if swis changes.}

        If ((PrintOrder = poSchoolCode) and
            (Done or
             SwisCodeChanged or
             SchoolCodeChanged))
          then
            begin
                 {FXX07101998-1: If printing by town within school,
                                 print swis totals first and
                                 page break on each school change. Otherwise,
                                 print school totals then swis totals.}

              If (SchoolCodePrintType = scTownWithinSchool)
                then
                  begin
                       {FXX07151998-7: Don't print swis totals if grand totals.}

                    If not PrintGrandTotals
                      then PrintTotals(Sender, ttSwisTotal, LastSwisCode, BySwisTotals);

                    InitializeTotalsRecord(BySwisTotals);

                    LastSwisCode := SortTable.FieldByName('SwisCode').Text;

                      {FXX07151998-2: Page break in print by twon in school even on
                                      just swis change.}
                      {FXX07161998-2: Don't print school totals unless the school changed.}

                    If (SchoolCodeChanged or Done)
                      then
                        begin
                          PrintTotals(Sender, ttSectionTotal, LastSchoolCode, BySectionTotals);

                          InitializeTotalsRecord(BySectionTotals);
                        end;

                    NewPage;

                  end;  {If (SchoolCodePrintType = scTownWithinSchool)}

              If (SchoolCodePrintType = scSchoolWithinTown)
                then
                  begin
                    PrintTotals(Sender, ttSectionTotal, LastSchoolCode, BySectionTotals);

                    InitializeTotalsRecord(BySectionTotals);

                    If (Done or SwisCodeChanged)
                      then
                        begin
                          If not PrintGrandTotals
                            then PrintTotals(Sender, ttSwisTotal, LastSwisCode, BySwisTotals);

                          InitializeTotalsRecord(BySwisTotals);

                          LastSwisCode := SortTable.FieldByName('SwisCode').Text;

                          NewPage;

                        end  {If (Done or SchoolCodeChanged)}
                      else NewPage;

                  end;  {If (SchoolCodePrintType = scTownWithinSchool)}

            end;  {If ((PrintOrder = poSchoolCode) and ...}

           {Print property class totals.}

        If ((PrintOrder = poPropertyClass) and
            (Done or
             ((Deblank(LastPropertyClass) <> '') and
              (SortTable.FieldByName('PropertyClass').Text <> LastPropertyClass))))
          then
            begin
              PrintTotals(Sender, ttSectionTotal, LastPropertyClass, BySectionTotals);

              InitializeTotalsRecord(BySectionTotals);

                {Go to a new page if this is going to be the only total on
                 the page. We don't want to page if this is the last page
                 since there will be grand totals or if this is a swis
                 break since there will be swis totals.}

              If (not (Done or
                       (SwisCodeChanged and
                        (not PrintGrandTotals))))
                then NewPage;

            end;  {If ((PrintOrder = poPropertyClass) and ...}

          {Have we changed swis codes? If so, print out totals and page break
           if they want totals by swis.}
          {FXX07101998-3: School\swis totals are taken care of above.}

        If ((not PrintGrandTotals) and
            (PrintOrder <> poSchoolCode) and
            (Done or
             ((Deblank(LastSwisCode) <> '') and
              (SortTable.FieldByName('SwisCode').Text <> LastSwisCode))))
          then
            begin
              PrintTotals(Sender, ttSwisTotal, LastSwisCode, BySwisTotals);

              InitializeTotalsRecord(BySwisTotals);

              LastSwisCode := SortTable.FieldByName('SwisCode').Text;

              If not Done
                then NewPage;

            end;  {If ((Deblank(LastSwisCode) <> '') and ...}

        If not Done or Quit
          then
            begin
              with SortTable do
                case PrintOrder of
                  0 : ProgressDialog.Update(Self,
                                            'RS: ' + FieldByName('RollSection').Text +
                                            '  SBL: ' + ConvertSBLOnlyToDashDot(FieldByName('SBLKey').Text));
                  1 : ProgressDialog.Update(Self,
                                            'Schl: ' + FieldByName('SchoolCode').Text +
                                            '  SBL: ' + ConvertSBLOnlyToDashDot(FieldByName('SBLKey').Text));
                  2 : ProgressDialog.Update(Self,
                                            ConvertSBLOnlyToDashDot(FieldByName('SBLKey').Text));
                  3 : ProgressDialog.Update(Self,
                                            FieldByName('Name').Text);
                   {FXX07151998-1: Save both legal addr number and name - don't condense
                                   into one field.}

                  4 : ProgressDialog.Update(Self,
                                            GetLegalAddressFromTable(SortTable));
                  5 : ProgressDialog.Update(Self,
                                            'Prp: ' + FieldByName('PropertyClass').Text +
                                            '  SBL: ' + ConvertSBLOnlyToDashDot(FieldByName('SBLKey').Text));

                end;  {case PrintOrderRadioGroup.ItemIndex of}

              If (LinesLeft <= LinesLeftAtBottom)
                then
                  begin
                    If (PrintOrder = poAddressSpecialFormat)
                      then
                        begin
                          ClearTabs;
                          SetTab(0.2, pjLeft, 8.0, 0, BoxLineNone, 0);  {}
                          Println(#9 + ConstStr('-', 108));
                        end;

                    NewPage;

                  end;  {If (LinesLeft <= LinesLeftAtBottom)}

                {Print the line.}

              PrintOneLine(Sender);

              with SortTable do
                begin
                  LastRollSection := FieldByName('RollSection').Text;
                  LastPropertyClass := FieldByName('PropertyClass').Text;
                  LastSchoolCode := FieldByName('SchoolCode').Text;

                end;  {with SortTable do}

              UpdateTotals(SortTable, TaxRollYr, BySwisTotals);
              UpdateTotals(SortTable, TaxRollYr, BySectionTotals);
              UpdateTotals(SortTable, TaxRollYr, GrandTotals);

            end;  {If not Done or Quit}

        ReportCancelled := ProgressDialog.Cancelled;

      until (Done or Quit or ReportCancelled);

      PrintTotals(Sender, ttGrandTotal, '', GrandTotals);

    end;  {with Sender as TBaseReport do}

end;  {ReportPrint}

{==================================================================}
Procedure TAssessmentSummaryReportForm.ReportPrint(Sender: TObject);

var
  TempTextFile : TextFile;

begin
  AssignFile(TempTextFile, TextFiler.FileName);
  Reset(TempTextFile);

        {CHG12211998-1: Add ability to select print range.}

  PrintTextReport(Sender, TempTextFile, PrintDialog.FromPage,
                  PrintDialog.ToPage);

  CloseFile(TempTextFile);

end;  {ReportPrint}

{===================================================================}
Procedure TAssessmentSummaryReportForm.FormClose(    Sender: TObject;
                                                 var Action: TCloseAction);

begin
  CloseTablesForForm(Self);

    {FXX04291998-13: Freeing SelectedPropertyClasses 2x.}

  SelectedSwisCodes.Free;
  SelectedSchoolCodes.Free;
  SelectedPropertyClasses.Free;
  SelectedRollSections.Free;

    {Free up the child window and set the ClosingAForm Boolean to
     true so that we know to delete the tab.}

  Action := caFree;
  GlblClosingAForm := True;
  GlblClosingFormCaption := Caption;

end;  {FormClose}


end.