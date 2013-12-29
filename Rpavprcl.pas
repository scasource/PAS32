unit Rpavprcl;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, DBCtrls, DBTables, DB, Buttons, Grids,
  Wwdbigrd, Wwdbgrid, ExtCtrls, Wwtable, Wwdatsrc, Menus, RPCanvas,
  RPrinter, RPBase, RPFiler, Types, RPDefine, (*Progress, *)RPTXFilr,
  TabNotBk, ComCtrls;

type
  SortRecord = record
    SwisCode : String;
    RollSection : String;
    PropertyClass : String;
    OwnershipCode : String;
    HomesteadCode : String;
    Count : LongInt;
    LandAssessedVal,
    TotalAssessedVal,
    CountyTaxableVal,
    TownTaxableVal,
    SchoolTaxableVal,
    VillageTaxableVal,
    VeteranEXAmt,
    ParapalegicEXAmt,
    ClergyEXAmt,
    STAREXAmt,
    AgedCountyEXAmt,
    AgedTownEXAmt,
    AgedSchoolEXAmt,
    AgedVillageEXAmt,
    OtherCountyEXAmt,
    OtherTownEXAmt,
    OtherSchoolEXAmt,
    OtherVillageEXAmt,
    SystemCountyEXAmt,
    SystemTownEXAmt,
    SystemSchoolEXAmt,
    SystemVillageEXAmt : Comp;
    TotalNumSTARs : LongInt;

  end;  {SortRecord = record}

  PSortRecord = ^SortRecord;

  TotalsRecord = record
    SwisCode : String;
    PropertyClass : String;
    RollSection : String;
    OwnershipCode : String;
    Count : LongInt;
    LandVal,
    AssessedVal,
    CountyTaxableVal,
    TownTaxableVal,
    SchoolTaxableVal,
    VillageTaxableVal,
    VeteranEXAmt,
    ParapalegicEXAmt,
    ClergyEXAmt,
    STAREXAmt,
    AgedCountyEXAmt,
    AgedTownEXAmt,
    AgedSchoolEXAmt,
    AgedVillageEXAmt,
    OtherCountyEXAmt,
    OtherTownEXAmt,
    OtherSchoolEXAmt,
    OtherVillageEXAmt,
    SystemCountyEXAmt,
    SystemTownEXAmt,
    SystemSchoolEXAmt,
    SystemVillageEXAmt : Comp;
    TotalNumSTARs : LongInt;


  end;  {TotalsRecord = record}

type
  TAssessmentByPropertyClassReportForm = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    ScrollBox1: TScrollBox;
    CloseButton: TBitBtn;
    TitleLabel: TLabel;
    ParcelTable: TTable;
    AssessmentTable: TTable;
    SwisCodeTable: TTable;
    PrintButton: TBitBtn;
    PrintDialog: TPrintDialog;
    ReportFiler: TReportFiler;
    ReportPrinter: TReportPrinter;
    SortTable: TwwTable;
    ExemptionTable: TTable;
    PropertyClassTable: TTable;
    EXCodeTable: TTable;
    Label10: TLabel;
    TextFiler: TTextFiler;
    ClassTable: TTable;
    Label21: TLabel;
    LoadButton: TBitBtn;
    SaveButton: TBitBtn;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    TabbedNotebook1: TTabbedNotebook;
    Label2: TLabel;
    PropertyClassListBox: TListBox;
    AssessmentYearRadioGroup: TRadioGroup;
    PropertyClassTypeRadioGroup: TRadioGroup;
    Label6: TLabel;
    SwisCodeListBox: TListBox;
    Label8: TLabel;
    SchoolCodeListBox: TListBox;
    SchoolCodeTable: TTable;
    EditHistoryYear: TEdit;
    OptionsGroupBox: TGroupBox;
    ShowHomesteadTotalsCheckBox: TCheckBox;
    PrintBySwisCodeCheckBox: TCheckBox;
    LoadFromParcelListCheckBox: TCheckBox;
    ExtractToExcelCheckBox: TCheckBox;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure PrintButtonClick(Sender: TObject);
    procedure ReportPrint(Sender: TObject);
    procedure TextFilerPrint(Sender: TObject);
    procedure TextFilerBeforePrint(Sender: TObject);
    procedure LoadButtonClick(Sender: TObject);
    procedure SaveButtonClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure AssessmentYearRadioGroupClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    UnitName : String;
    ReportCancelled : Boolean;
    PropertyClassCodes,
    OwnershipCodesList,
    SwisCodesList : TList;  {List of descriptions of codes to save time later.}
    SelectedSchoolCodes,
    SelectedPropertyClassCodes,  {What property classes did they select?}
    SelectedPropertyClassCodes2,  {Used for displaying selections.}
    SelectedSwisCodes : TStringList;  {What swis codes did they select?}
    AssessmentYear : String;
    PrintOrder, NumDigitsOfPropertyClassShown : Integer;
    ShowHstdNonhstdTotals, PrintBySwisCode, LoadFromParcelList : Boolean;
    LastSwisCode : String;
    OrigSortFileName : String;
    ExtractToExcel : Boolean;
    ExtractFile : TextFile;

    Procedure InitializeForm;  {Open the tables and setup.}

    Procedure FillSortFile(var Quit : Boolean);
   {Fill the sort file with the variance information.}

    Procedure PrintLine(Sender : TObject;
                        TotalsRec : TotalsRecord;
                        TotalsDescription : String;
                        PrintRollSection,
                        PrintPropertyClass : Boolean;
                        _HomesteadCode : Char);

    Procedure PrintSelections(Sender : TObject);

    Procedure PrintHeader(Sender : TObject;
                          _HomesteadCode : Char);

    Procedure PrintRollSections(Sender : TObject;
                                NewSwisCode,
                                OldSwisCode : String;
                                SortTable : TwwTable;
                                SwisCodeDescriptionList : TList;
                                DoneWithReport : Boolean;
                                _HomesteadCode : Char);

    Procedure AV_PCPrintReport(Sender: TObject;
                               _HomesteadCode : Char);

  end;

implementation

uses GlblVars, WinUtils, Utilitys, PASUTILS, UTILEXSD,  GlblCnst, PasTypes,
     Prog, PRCLLIST, RptDialg,
     Preview;  {Report preview form}

const
  TrialRun = False;


{$R *.DFM}

{========================================================}
Procedure TAssessmentByPropertyClassReportForm.FormActivate(Sender: TObject);

begin
  SetFormStateMaximized(Self);
end;

{========================================================}
Procedure TAssessmentByPropertyClassReportForm.InitializeForm;

var
  Quit : Boolean;

begin
  UnitName := 'RPAVPRCL.PAS';  {mmm}

    {FXX09092001-1: We don't want to open all the tables right now - just
                    then swis and school code so that we don't have a problem
                    later with which year the tables point to.}

  OpenTableForProcessingType(SwisCodeTable, SwisCodeTableName,
                             NextYear, Quit);
  OpenTableForProcessingType(SchoolCodeTable, SchoolCodeTableName,
                             NextYear, Quit);

  FillOneListBox(SwisCodeListBox, SwisCodeTable, 'SwisCode',
                 'MunicipalityName', 25, True, True, GlblProcessingType,
                 GetTaxRlYr);

    {CHG05162000-1: Add school codes option.}

  FillOneListBox(SchoolCodeListBox, SchoolCodeTable, 'SchoolCode',
                 'SchoolName', 25, True, True, GlblProcessingType,
                 GetTaxRlYr);

  SelectItemsInListBox(SwisCodeListBox);
  SelectItemsInListBox(SchoolCodeListBox);
  SelectItemsInListBox(PropertyClassListBox);

  PropertyClassCodes := TList.Create;
  SwisCodesList := TList.Create;
  OwnershipCodesList := TList.Create;
  LoadCodeList(PropertyClassCodes, 'ZPropClsTbl', 'MainCode', 'Description', Quit);
  LoadCodeList(OwnershipCodesList, 'ZOwnershipTbl', 'MainCode', 'Description', Quit);
  LoadCodeList(SwisCodesList, SwisCodeTableName, 'SwisCode', 'MunicipalityName', Quit);

  OrigSortFileName := SortTable.TableName;

    {FXX12072004-1(2.8.1.2): Default assessment year.}

  If (GlblProcessingType = NextYear)
    then AssessmentYearRadioGroup.ItemIndex := 1
    else AssessmentYearRadioGroup.ItemIndex := 0;

end;  {InitializeForm}

{===================================================================}
Procedure TAssessmentByPropertyClassReportForm.AssessmentYearRadioGroupClick(Sender: TObject);

begin
  case AssessmentYearRadioGroup.ItemIndex of
    0, 1 : EditHistoryYear.Visible := False;
    2 : begin
          EditHistoryYear.Visible := True;
          EditHistoryYear.SetFocus;
        end;

  end;  {case AssessmentYearRadioGroup.ItemIndex of}

end;  {AssessmentYearRadioGroupClick}

{===================================================================}
Function SortEntryFound(    SortList : TList;
                            _SwisCode : String;
                            _RollSection : String;
                            _PropertyClass : String;
                            _OwnershipCode : String;
                            _HomesteadCode : String;
                        var Index : Integer) : Boolean;

var
  I : Integer;

begin
  Result := False;

  For I := 0 to (SortList.Count - 1) do
    with PSortRecord(SortList[I])^ do
      If ((Take(6, _SwisCode) = Take(6, SwisCode)) and
          (Take(1, _RollSection) = Take(1, RollSection)) and
          (Take(3, _PropertyClass) = Take(3, PropertyClass)) and
          (Take(1, _OwnershipCode) = Take(1, OwnershipCode)) and
          (Take(1, _HomesteadCode) = Take(1, HomesteadCode)))
        then
          begin
            Index := I;
            Result := True;
          end;

end;  {SortEntryFound}

{===================================================================}
Procedure UpdateEXTotalsForSortRec(PSortRec : PSortRecord;
                                   HomesteadCode : String;
                                   ExemptionCodes,
                                   ExemptionHomesteadCodes,
                                   CountyExemptionAmounts,
                                   TownExemptionAmounts,
                                   SchoolExemptionAmounts,
                                   VillageExemptionAmounts : TStringList;
                                   BasicSTARAmount,
                                   EnhancedSTARAmount : Comp);

{Update the exemption totals in this sort record by classifying the
 different exemptions.}

var
  I : Integer;
  EXCodeHandled : Boolean;

begin
  For I := 0 to (ExemptionCodes.Count - 1) do
    If (Take(1, HomesteadCode) = Take(1, ExemptionHomesteadCodes[I]))
      then
        begin
          EXCodeHandled := False;

            {System exemptions.}

          If (Take(1, ExemptionCodes[I]) = '5')
            then
              begin
                EXCodeHandled := True;

                with PSortRec^ do
                  begin
                    SystemCountyEXAmt := SystemCountyEXAmt + StrToFloat(CountyExemptionAmounts[I]);
                    SystemTownEXAmt := SystemTownEXAmt + StrToFloat(TownExemptionAmounts[I]);
                    SystemSchoolEXAmt := SystemSchoolEXAmt + StrToFloat(SchoolExemptionAmounts[I]);
                    SystemVillageEXAmt := SystemVillageEXAmt + StrToFloat(VillageExemptionAmounts[I]);

                  end;  {with PSortRec^ do}

              end;  {If (Take(1, ExemptionCodes[I]) = '5')}

            {Aged exemptions.}

          If (Take(4, ExemptionCodes[I]) = '4180')
            then
              begin
                EXCodeHandled := True;

                with PSortRec^ do
                  begin
                    AgedCountyEXAmt := AgedCountyEXAmt + StrToFloat(CountyExemptionAmounts[I]);
                    AgedTownEXAmt := AgedTownEXAmt + StrToFloat(TownExemptionAmounts[I]);
                    AgedSchoolEXAmt := AgedSchoolEXAmt + StrToFloat(SchoolExemptionAmounts[I]);
                    AgedVillageEXAmt := AgedVillageEXAmt + StrToFloat(VillageExemptionAmounts[I]);

                  end;  {with PSortRec^ do}

              end;  {If (Take(4, ExemptionCodes[I]) = '4180')}

            {Veterans}

          If (Take(3, ExemptionCodes[I]) = '411')
            then
              begin
                EXCodeHandled := True;

                with PSortRec^ do
                  case GetMunicipalityType(GlblMunicipalityType) of
                    MTCounty : VeteranEXAmt := VeteranEXAmt + StrToFloat(CountyExemptionAmounts[I]);
                    MTTown : VeteranEXAmt := VeteranEXAmt + StrToFloat(TownExemptionAmounts[I]);
                    MTSchool : VeteranEXAmt := VeteranEXAmt + StrToFloat(SchoolExemptionAmounts[I]);
                    MTVillage : VeteranEXAmt := VeteranEXAmt + StrToFloat(VillageExemptionAmounts[I]);

                  end;  {case GetMunicipalityType(GlblMunicipalityType) of}

              end;  {If (Take(3, ExemptionCodes[I]) = '4111')}

            {Parapalegic}

          If (Take(4, ExemptionCodes[I]) = '4130')
            then
              begin
                EXCodeHandled := True;

                with PSortRec^ do
                  case GetMunicipalityType(GlblMunicipalityType) of
                    MTCounty : ParapalegicEXAmt := ParapalegicEXAmt + StrToFloat(CountyExemptionAmounts[I]);
                    MTTown : ParapalegicEXAmt := ParapalegicEXAmt + StrToFloat(TownExemptionAmounts[I]);
                    MTSchool : ParapalegicEXAmt := ParapalegicEXAmt + StrToFloat(SchoolExemptionAmounts[I]);
                    MTVillage : ParapalegicEXAmt := ParapalegicEXAmt + StrToFloat(VillageExemptionAmounts[I]);

                  end;  {case GetMunicipalityType(GlblMunicipalityType) of}

              end;  {If (Take(4, ExemptionCodes[I]) = '4130')}

            {Clergy}

          If (Take(4, ExemptionCodes[I]) = '4140')
            then
              begin
                EXCodeHandled := True;

                with PSortRec^ do
                  case GetMunicipalityType(GlblMunicipalityType) of
                    MTCounty : ClergyEXAmt := ClergyEXAmt + StrToFloat(CountyExemptionAmounts[I]);
                    MTTown : ClergyEXAmt := ClergyEXAmt + StrToFloat(TownExemptionAmounts[I]);
                    MTSchool : ClergyEXAmt := ClergyEXAmt + StrToFloat(SchoolExemptionAmounts[I]);
                    MTVillage : ClergyEXAmt := ClergyEXAmt + StrToFloat(VillageExemptionAmounts[I]);

                  end;  {case GetMunicipalityType(GlblMunicipalityType) of}

              end;  {If (Take(4, ExemptionCodes[I]) = '4140')}

             {Don't save STAR amounts in the other category. Instead, save below.}

          If ((ExemptionCodes[I] = BasicSTARExemptionCode) or
              (ExemptionCodes[I] = EnhancedSTARExemptionCode))
            then EXCodeHandled := True;

            {All other exemptions.}

          If not EXCodeHandled
            then
              begin
                with PSortRec^ do
                  begin
                    OtherCountyEXAmt := OtherCountyEXAmt + StrToFloat(CountyExemptionAmounts[I]);
                    OtherTownEXAmt := OtherTownEXAmt + StrToFloat(TownExemptionAmounts[I]);
                    OtherSchoolEXAmt := OtherSchoolEXAmt + StrToFloat(SchoolExemptionAmounts[I]);
                    OtherVillageEXAmt := OtherVillageEXAmt + StrToFloat(VillageExemptionAmounts[I]);

                  end;  {with PSortRec^ do}

              end;  {If not EXCodeHandled}

        end;  {If (Take(1, HomesteadCode) = Take(1, ExemptionHomesteadCodes[I]))}

  with PSortRec^ do
    begin
      STAREXAmt := STAREXAmt + BasicSTARAmount + EnhancedSTARAmount;

        {CHG05162000-2: Show the total number of STARS.}

      If (Roundoff(BasicSTARAmount, 0) > 0)
        then TotalNumSTARs := TotalNumSTARs + 1;

      If (Roundoff(EnhancedSTARAmount, 0) > 0)
        then TotalNumSTARs := TotalNumSTARs + 1;

    end;  {with PSortRec^ do}

end;  {UpdateEXTotalsForSortRec}

{===================================================================}
Function AdjustPropertyClassForDigitsShown(_PropertyClass : String;
                                           NumDigitsOfPropertyClassShown : Integer) : String;

begin
  case NumDigitsOfPropertyClassShown of
    1 : Result := Take(1, _PropertyClass) + '00';
    2 : Result := Take(2, _PropertyClass) + '0';
    3 : Result := Take(3, _PropertyClass);
  end;  {case NumDigitsOfPropertyClassShown of}

end;  {AdjustPropertyClassForDigitsShown}

{===================================================================}
Procedure TAssessmentByPropertyClassReportForm.FillSortFile(var Quit : Boolean);

{Fill the sort file with the variance information.}

var
  FirstTimeThrough, Done,
  AssessmentRecordFound, ClassRecordFound : Boolean;
  I, Index, ParcelIndex : Integer;
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
  HstdAssessedVal, NonhstdAssessedVal,
  HstdLandVal, NonhstdLandVal : Comp;
  HstdAcres, NonhstdAcres : Real;
  SortList : TList;
  _SwisCode : String;
  _PropertyClass : String;
  TempHomesteadCode, _RollSection, _HomesteadCode, _OwnershipCode : String;
  PSortRec : PSortRecord;

begin
  ParcelIndex := 0;
  PSortRec := nil;
  SortList := TList.Create;
  ExemptionCodes := TStringList.Create;
  ExemptionHomesteadCodes := TStringList.Create;
  ResidentialTypes := TStringList.Create;
  CountyExemptionAmounts := TStringList.Create;
  TownExemptionAmounts := TStringList.Create;
  SchoolExemptionAmounts := TStringList.Create;
  VillageExemptionAmounts := TStringList.Create;

    {FXX11191999-3: Add load from parcel list option.}

  If LoadFromParcelList
    then
      begin
        ParcelIndex := 1;
        ParcelListDialog.GetParcel(ParcelTable, ParcelIndex);
        ProgressDialog.Start(ParcelListDialog.NumItems, True, True);
      end
    else
      begin
        ParcelTable.First;
        ProgressDialog.Start(GetRecordCount(ParcelTable), True, True);
      end;

  For I := 0 to (SwisCodeListBox.Items.Count - 1) do
    If SwisCodeListBox.Selected[I]
      then SelectedSwisCodes.Add(Take(6, SwisCodeListBox.Items[I]));

    {CHG05162000-1: Add school codes option.}

  For I := 0 to (SchoolCodeListBox.Items.Count - 1) do
    If SchoolCodeListBox.Selected[I]
      then SelectedSchoolCodes.Add(Take(6, SchoolCodeListBox.Items[I]));

   {Only store the first char of the selected property classes since this is what we will compare on.}

  For I := 0 to (PropertyClassListBox.Items.Count - 1) do
    If PropertyClassListBox.Selected[I]
      then
        begin
          SelectedPropertyClassCodes.Add(Take(1, PropertyClassListBox.Items[I]));
          SelectedPropertyClassCodes2.Add(Take(5, PropertyClassListBox.Items[I]));
        end;

    {Now go through the parcel file.}

  FirstTimeThrough := True;
  Done := False;
  ProgressDialog.UserLabelCaption := 'Filling sort file.';

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else
        If LoadFromParcelList
          then
            begin
              ParcelIndex := ParcelIndex + 1;
              ParcelListDialog.GetParcel(ParcelTable, ParcelIndex);
            end
          else ParcelTable.Next;

    If (ParcelTable.EOF or
        (LoadFromParcelList and
         (ParcelIndex > ParcelListDialog.NumItems)))
      then Done := True;

    If LoadFromParcelList
      then ProgressDialog.Update(Self, ParcelListDialog.GetParcelID(ParcelIndex))
      else ProgressDialog.Update(Self, ConvertSwisSBLToDashDot(ExtractSSKey(ParcelTable)));

    SwisSBLKey := ExtractSSKey(ParcelTable);

    Application.ProcessMessages;

      {CHG05162000-1: Add school codes option.}

    If ((not Done) and
        (ParcelTable.FieldByName('ActiveFlag').Text <> InactiveParcelFlag) and
        (SelectedSwisCodes.IndexOf(Copy(SwisSBLKey, 1, 6)) > -1) and  {In the selected list.}
        (SelectedSchoolCodes.IndexOf(ParcelTable.FieldByName('SchoolCode').Text) > -1) and  {In the selected list.}
        (SelectedPropertyClassCodes.IndexOf(Take(1, ParcelTable.FieldByName('PropertyClassCode').Text)) > -1)) {In PC lst}
      then
        begin
          CalculateHstdAndNonhstdAmounts(AssessmentYear, SwisSBLKey,
                                         AssessmentTable,
                                         ClassTable, ParcelTable,
                                         HstdAssessedVal,
                                         NonhstdAssessedVal,
                                         HstdLandVal, NonhstdLandVal,
                                         HstdAcres, NonhstdAcres,
                                         AssessmentRecordFound,
                                         ClassRecordFound);

            {CHG12011997-2: STAR support}
            {FXX02091998-1: Pass the residential type of each exemption.}

          TotalExemptionsForParcel(AssessmentYear, SwisSBLKey,
                                   ExemptionTable, EXCodeTable,
                                   ParcelTable.FieldByName('HomesteadCode').Text,
                                   'A', ExemptionCodes,
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

          with ParcelTable do
            begin
              _SwisCode := Copy(SwisSBLKey, 1, 6);
              If not PrintBySwisCode
                then _SwisCode := Take(4, _SwisCode);

              _RollSection := FieldByName('RollSection').Text;
              _PropertyClass := FieldByName('PropertyClassCode').Text;

                 {Now based on the number of digits of the property class they want to see,
                  fill in zeroes for the excess, i.e. 213 becomes 200 if they only want to see one
                  digit.}

              _PropertyClass := AdjustPropertyClassForDigitsShown(_PropertyClass,
                                                                  NumDigitsOfPropertyClassShown);
              _OwnershipCode := FieldByName('OwnershipCode').Text;
              _HomesteadCode := Take(1, FieldByName('HomesteadCode').Text);

            end;  {with ParcelTable do}

            {Update the homestead values.}

          If (_HomesteadCode[1] in ['S', 'H', ' '])
            then
              begin
                TempHomesteadCode := _HomesteadCode;
                If (TempHomesteadCode = 'S')
                  then TempHomesteadCode := 'H';

                If SortEntryFound(SortList, _SwisCode, _RollSection,
                                  _PropertyClass, _OwnershipCode, TempHomesteadCode, Index)
                  then
                    begin
                        {Update the totals.}

                      PSortRec := PSortRecord(SortList[Index]);

                      with PSortRecord(SortList[Index])^ do
                        begin
                          Count := Count + 1;
                          LandAssessedVal := LandAssessedVal + HstdLandVal;
                          TotalAssessedVal := TotalAssessedVal + HstdAssessedVal;
                          CountyTaxableVal := CountyTaxableVal +
                                              (HstdAssessedVal - HstdEXAmounts[EXCounty]);
                          TownTaxableVal := TownTaxableVal +
                                            (HstdAssessedVal - HstdEXAmounts[EXTown]);
                          SchoolTaxableVal := SchoolTaxableVal +
                                              (HstdAssessedVal - HstdEXAmounts[EXSchool]);
                          VillageTaxableVal := VillageTaxableVal +
                                               (HstdAssessedVal - HstdEXAmounts[EXVillage]);

                        end;  {with PSortRecord(SortList[Index])^ do}
                    end
                  else
                    begin
                      New(PSortRec);

                      with PSortRec^ do
                        begin
                          SwisCode := _SwisCode;
                          RollSection := _RollSection;
                          PropertyClass := _PropertyClass;
                          OwnershipCode := _OwnershipCode;
                          HomesteadCode := TempHomesteadCode;
                          Count := 1;
                          LandAssessedVal := HstdLandVal;
                          TotalAssessedVal := HstdAssessedVal;
                          CountyTaxableVal := HstdAssessedVal - HstdEXAmounts[EXCounty];
                          TownTaxableVal := HstdAssessedVal - HstdEXAmounts[EXTown];
                          SchoolTaxableVal := HstdAssessedVal - HstdEXAmounts[EXSchool];
                          VillageTaxableVal := HstdAssessedVal - HstdEXAmounts[EXVillage];
                          VeteranEXAmt := 0;
                          ParapalegicEXAmt := 0;
                          ClergyEXAmt := 0;
                          STAREXAmt := 0;
                          TotalNumSTARs := 0;
                          AgedCountyEXAmt := 0;
                          AgedTownEXAmt := 0;
                          AgedSchoolEXAmt := 0;
                          AgedVillageEXAmt := 0;
                          OtherCountyEXAmt := 0;
                          OtherTownEXAmt := 0;
                          OtherSchoolEXAmt := 0;
                          OtherVillageEXAmt := 0;
                          SystemCountyEXAmt := 0;
                          SystemTownEXAmt := 0;
                          SystemSchoolEXAmt := 0;
                          SystemVillageEXAmt := 0;

                        end;  {with PSortRecord^ do}

                      SortList.Add(PSortRec);

                    end;  {else of If SortEntryFound(SortList, _SwisCode...}

                  {Update the exemption totals with the amounts for this
                   parcel.}

                UpdateEXTotalsForSortRec(PSortRec, TempHomesteadCode, ExemptionCodes,
                                         ExemptionHomesteadCodes,
                                         CountyExemptionAmounts,
                                         TownExemptionAmounts,
                                         SchoolExemptionAmounts,
                                         VillageExemptionAmounts,
                                         BasicSTARAmount, EnhancedSTARAmount);

              end;  {If (Roundoff(HstdAssessedVal, 0) > 0)}

            {Update the nonhomestead values.}

          If (_HomesteadCode[1] in ['N', 'S'])
            then
              begin
                If SortEntryFound(SortList, _SwisCode, _RollSection,
                                  _PropertyClass, _OwnershipCode, 'N', Index)
                  then
                    begin
                        {Update the totals.}

                      with PSortRecord(SortList[Index])^ do
                        begin
                          Count := Count + 1;
                          LandAssessedVal := LandAssessedVal + NonhstdLandVal;
                          TotalAssessedVal := TotalAssessedVal + NonhstdAssessedVal;
                          CountyTaxableVal := CountyTaxableVal +
                                              (NonhstdAssessedVal - NonhstdEXAmounts[EXCounty]);
                          TownTaxableVal := TownTaxableVal +
                                            (NonhstdAssessedVal - NonhstdEXAmounts[EXTown]);
                          SchoolTaxableVal := SchoolTaxableVal +
                                              (NonhstdAssessedVal - NonhstdEXAmounts[EXSchool]);
                          VillageTaxableVal := VillageTaxableVal +
                                               (NonhstdAssessedVal - NonhstdEXAmounts[EXVillage]);

                        end;  {with PSortRecord(SortList[Index])^ do}
                    end
                  else
                    begin
                      New(PSortRec);

                      with PSortRec^ do
                        begin
                          SwisCode := _SwisCode;
                          RollSection := _RollSection;
                          PropertyClass := _PropertyClass;
                          OwnershipCode := _OwnershipCode;
                          HomesteadCode := 'N';
                          Count := 1;
                          LandAssessedVal := NonhstdLandVal;
                          TotalAssessedVal := NonhstdAssessedVal;
                          CountyTaxableVal := NonhstdAssessedVal - NonhstdEXAmounts[EXCounty];
                          TownTaxableVal := NonhstdAssessedVal - NonhstdEXAmounts[EXTown];
                          SchoolTaxableVal := NonhstdAssessedVal - NonhstdEXAmounts[EXSchool];
                          VillageTaxableVal := NonhstdAssessedVal - NonhstdEXAmounts[EXVillage];
                          VeteranEXAmt := 0;
                          ParapalegicEXAmt := 0;
                          ClergyEXAmt := 0;
                          STAREXAmt := 0;
                          TotalNumSTARs := 0;
                          AgedCountyEXAmt := 0;
                          AgedTownEXAmt := 0;
                          AgedSchoolEXAmt := 0;
                          AgedVillageEXAmt := 0;
                          OtherCountyEXAmt := 0;
                          OtherTownEXAmt := 0;
                          OtherSchoolEXAmt := 0;
                          OtherVillageEXAmt := 0;
                          SystemCountyEXAmt := 0;
                          SystemTownEXAmt := 0;
                          SystemSchoolEXAmt := 0;
                          SystemVillageEXAmt := 0;

                        end;  {with PSortRec^ do}

                      SortList.Add(PSortRec);

                    end;  {else of If SortEntryFound(SortList, _SwisCode...}

                  {Update the exemption totals with the amounts for this
                   parcel.}

                UpdateEXTotalsForSortRec(PSortRec, 'N', ExemptionCodes,
                                         ExemptionHomesteadCodes,
                                         CountyExemptionAmounts,
                                         TownExemptionAmounts,
                                         SchoolExemptionAmounts,
                                         VillageExemptionAmounts,
                                         BasicSTARAmount, EnhancedSTARAmount);

              end;  {If (Roundoff(NonhstdAssessedVal, 0) > 0)}

        end;  {If not Done}

    ReportCancelled := ProgressDialog.Cancelled;

  until (Done or Quit or ReportCancelled);

    {Actually fill in the sort file.}

  If Done
    then
      For I := 0 to (SortList.Count - 1) do
        with PSortRecord(SortList[I])^, SortTable do
          try
            Insert;

            FieldByName('SwisCode').Text := Take(6, SwisCode);
            FieldByName('RollSection').Text := Take(1, RollSection);
            FieldByName('PropertyClass').Text := Take(3, PropertyClass);
            FieldByName('HomesteadCode').Text := Take(1, HomesteadCode);
            FieldByName('OwnershipCode').Text := Take(1, OwnershipCode);
            FieldByName('Count').AsInteger := Count;
            TCurrencyField(FieldByName('LandAssessedVal')).Value := LandAssessedVal;
            TCurrencyField(FieldByName('TotalAssessedVal')).Value := TotalAssessedVal;
            TCurrencyField(FieldByName('CountyTaxableVal')).Value := CountyTaxableVal;
            TCurrencyField(FieldByName('TownTaxableVal')).Value := TownTaxableVal;
            TCurrencyField(FieldByName('SchoolTaxableVal')).Value := SchoolTaxableVal;
            TCurrencyField(FieldByName('VillageTaxableVal')).Value := VillageTaxableVal;
            TCurrencyField(FieldByName('VeteransEXAmt')).Value := VeteranEXAmt;
            TCurrencyField(FieldByName('ParapalegicEXAmt')).Value := ParapalegicEXAmt;
            TCurrencyField(FieldByName('ClergyEXAmt')).Value := ClergyEXAmt;
            TCurrencyField(FieldByName('STAREXAmt')).Value := STAREXAmt;
            TCurrencyField(FieldByName('AgedCountyEXAmt')).Value := AgedCountyEXAmt;
            TCurrencyField(FieldByName('AgedTownEXAmt')).Value := AgedTownEXAmt;
            TCurrencyField(FieldByName('AgedSchoolEXAmt')).Value := AgedSchoolEXAmt;
            TCurrencyField(FieldByName('AgedVillageEXAmt')).Value := AgedVillageEXAmt;
            TCurrencyField(FieldByName('OtherCountyEXAmt')).Value := OtherCountyEXAmt;
            TCurrencyField(FieldByName('OtherTownEXAmt')).Value := OtherTownEXAmt;
            TCurrencyField(FieldByName('OtherSchoolEXAmt')).Value := OtherSchoolEXAmt;
            TCurrencyField(FieldByName('OtherVillageEXAmt')).Value := OtherVillageEXAmt;
            TCurrencyField(FieldByName('SystemCountyEXAmt')).Value := SystemCountyEXAmt;
            TCurrencyField(FieldByName('SystemTownEXAmt')).Value := SystemTownEXAmt;
            TCurrencyField(FieldByName('SystemSchoolEXAmt')).Value := SystemSchoolEXAmt;
            TCurrencyField(FieldByName('SystemVillageEXAmt')).Value := SystemVillageEXAmt;

              {CHG05162000-2: Show the total number of STARS.}
            FieldByName('TotalNumSTARs').AsInteger := TotalNumSTARs;

            Post;

          except
            Quit := True;
            SystemSupport(003, SortTable, 'Error inserting sort record.',
                          UnitName, GlblErrorDlgBox);
          end;

  ExemptionCodes.Free;
  ExemptionHomesteadCodes.Free;
  ResidentialTypes.Free;
  CountyExemptionAmounts.Free;
  TownExemptionAmounts.Free;
  SchoolExemptionAmounts.Free;
  VillageExemptionAmounts.Free;

  FreeTList(SortList, SizeOf(SortRecord));

end;  {FillSortFile}

{====================================================================}
Procedure TAssessmentByPropertyClassReportForm.SaveButtonClick(Sender: TObject);

{FXX04091999-8: Add ability to save and load search report options.}

begin
  SaveReportOptions(Self, OpenDialog, SaveDialog, 'avprpcls.prp', 'Assessment by Property Class Report');

end;  {SaveButtonClick}

{====================================================================}
Procedure TAssessmentByPropertyClassReportForm.LoadButtonClick(Sender: TObject);

{FXX04091999-8: Add ability to save and load search report options.}

begin
  LoadReportOptions(Self, OpenDialog, 'avprpcls.prp', 'Assessment by Property Class Report');

end;  {LoadButtonClick}

{===================================================================}
Procedure TAssessmentByPropertyClassReportForm.PrintButtonClick(Sender: TObject);

var
  Quit : Boolean;
  MunicipalityType, SortFileName,
  SpreadsheetFileName, NewFileName, TextFileName : String;
  ProcessingType : Integer;

begin
  Quit := False;
  ReportCancelled := False;

    {CHG10121998-1: Add user options for default destination and show vet max msg.}

  SetPrintToScreenDefault(PrintDialog);

    {FXX09301998-1: Disable print button after clicking to avoid clicking twice.}

  PrintButton.Enabled := False;
  Application.ProcessMessages;

  If PrintDialog.Execute
    then
      begin
         {CHG11042005-2(2.9.3.12): Add the ability to Extract to Excel.}

        ExtractToExcel := ExtractToExcelCheckBox.Checked;

        If ExtractToExcel
          then
            begin
              SpreadsheetFileName := GetPrintFileName(Self.Caption, True);
              AssignFile(ExtractFile, SpreadsheetFileName);
              Rewrite(ExtractFile);

              WriteCommaDelimitedLine(ExtractFile,
                                      ['Swis Code',
                                       'Roll Sec',
                                       'Prop Class',
                                       'Description',
                                       '# Parcels',
                                       'Land Value',
                                       'Assessed Value']);

              MunicipalityType := GetMunicipalityTypeName(GlblMunicipalityType);

              If (rtdCounty in GlblRollTotalsToShow)
                then WriteCommaDelimitedLine(ExtractFile, ['County Taxable']);

              If (rtdMunicipal in GlblRollTotalsToShow)
                then WriteCommaDelimitedLine(ExtractFile, [MunicipalityType + ' Taxable']);

              If (rtdSchool in GlblRollTotalsToShow)
                then WriteCommaDelimitedLine(ExtractFile, ['School Taxable']);

              If (rtdVillageReceivingPartialRoll in GlblRollTotalsToShow)
                then WriteCommaDelimitedLine(ExtractFile, ['Village Taxable']);

              WriteCommaDelimitedLine(ExtractFile,
                                      ['Veterans',
                                       'Parapalegic',
                                       'Clergy']);

              If (rtdSchool in GlblRollTotalsToShow)
                then WriteCommaDelimitedLine(ExtractFile,
                                             ['STAR',
                                              'STAR Count']);

              If (rtdCounty in GlblRollTotalsToShow)
                then WriteCommaDelimitedLine(ExtractFile, ['County Senior']);

              If (rtdMunicipal in GlblRollTotalsToShow)
                then WriteCommaDelimitedLine(ExtractFile, [MunicipalityType + ' Senior']);

              If (rtdSchool in GlblRollTotalsToShow)
                then WriteCommaDelimitedLine(ExtractFile, ['School Senior']);

              If (rtdVillageReceivingPartialRoll in GlblRollTotalsToShow)
                then WriteCommaDelimitedLine(ExtractFile, ['Village Senior']);

              If (rtdCounty in GlblRollTotalsToShow)
                then WriteCommaDelimitedLine(ExtractFile, ['County Other']);

              If (rtdMunicipal in GlblRollTotalsToShow)
                then WriteCommaDelimitedLine(ExtractFile, [MunicipalityType + ' Other']);

              If (rtdSchool in GlblRollTotalsToShow)
                then WriteCommaDelimitedLine(ExtractFile, ['School Other']);

              If (rtdVillageReceivingPartialRoll in GlblRollTotalsToShow)
                then WriteCommaDelimitedLine(ExtractFile, ['Village Other']);

              If (rtdCounty in GlblRollTotalsToShow)
                then WriteCommaDelimitedLine(ExtractFile, ['County System']);

              If (rtdMunicipal in GlblRollTotalsToShow)
                then WriteCommaDelimitedLine(ExtractFile, [MunicipalityType + ' System']);

              If (rtdSchool in GlblRollTotalsToShow)
                then WriteCommaDelimitedLine(ExtractFile, ['School System']);

              If (rtdVillageReceivingPartialRoll in GlblRollTotalsToShow)
                then WritelnCommaDelimitedLine(ExtractFile,
                                               ['Village System'])
                else WritelnCommaDelimitedLine(ExtractFile, ['']);

            end; {If ExtractToExcel}

       TextFiler.SetFont('Courier New', 10);

          {CHG10131998-1: Set the printer settings based on what printer they selected
                          only - they no longer need to worry about paper or landscape
                          mode.}

        AssignPrinterSettings(PrintDialog, ReportFiler, ReportPrinter, [ptBoth], True, Quit);

          {CHG11042005-1(2.9.3.12): Option to print on letter size paper.}

        If (ReportPrinter.Orientation = poLandscape)
          then
            If (MessageDlg('Do you want to print on letter size paper?',
                           mtConfirmation, [mbYes, mbNo], 0) = idYes)
              then
                begin
                  ReportPrinter.SetPaperSize(dmPaper_Letter, 0, 0);
                  ReportFiler.SetPaperSize(dmPaper_Letter, 0, 0);
                  ReportPrinter.Orientation := poLandscape;
                  ReportFiler.Orientation := poLandscape;

                  If (ReportPrinter.SupportDuplex and
                      (MessageDlg('Do you want to print on both sides of the paper?',
                                  mtConfirmation, [mbYes, mbNo], 0) = idYes))
                    then
                      If (MessageDlg('Do you want to vertically duplex this report?',
                                      mtConfirmation, [mbYes, mbNo], 0) = idYes)
                        then ReportPrinter.Duplex := dupVertical
                        else ReportPrinter.Duplex := dupHorizontal;

                  ReportPrinter.ScaleX := 77;
                  ReportPrinter.ScaleY := 70;
                  ReportPrinter.SectionLeft := 1.5;
                  ReportFiler.ScaleX := 77;
                  ReportFiler.ScaleY := 70;
                  ReportFiler.SectionLeft := 1.5;

                end;  {If (MessageDlg('Do you want to...}

        If not Quit
          then
            begin
              ProcessingType := GlblProcessingType;
              case AssessmentYearRadioGroup.ItemIndex of
                0 : begin
                      AssessmentYear := GlblThisYear;
                      ProcessingType := ThisYear;
                    end;

                1 : begin
                      AssessmentYear := GlblNextYear;
                      ProcessingType := NextYear;
                    end;

                2 : begin
                      AssessmentYear := EditHistoryYear.Text;
                      ProcessingType := History;
                    end;

              end;  {case AssessmentYearRadioGroup.ItemIndex of}

                {FXX11191999-3: Add load from parcel list option.}

              LoadFromParcelList := LoadFromParcelListCheckBox.Checked;

              OpenTablesForForm(Self, ProcessingType);

                {FXX09092001-1: We don't want to open all the tables right now - just
                                then swis and school code so that we don't have a problem
                                later with which year the tables point to.}

              OpenTableForProcessingType(SwisCodeTable, SwisCodeTableName,
                                         ProcessingType, Quit);
              OpenTableForProcessingType(SchoolCodeTable, SchoolCodeTableName,
                                         ProcessingType, Quit);

                {Copy the sort table and open the tables.}

                 {FXX12011997-1: Name the sort files with the date and time and
                                 extension of .SRT.}

              CopyAndOpenSortFile(SortTable, 'AVByPropertyClass',
                                  OrigSortFileName, SortFileName,
                                  True, True, Quit);

              ProgressDialog.Start(GetRecordCount(ParcelTable), True, True);

              SelectedSwisCodes := TStringList.Create;
              SelectedSchoolCodes := TStringList.Create;
              SelectedPropertyClassCodes := TStringList.Create;
              SelectedPropertyClassCodes2 := TStringList.Create;

              NumDigitsOfPropertyClassShown := PropertyClassTypeRadioGroup.ItemIndex + 1;
              ShowHstdNonhstdTotals := ShowHomesteadTotalsCheckBox.Checked;
              PrintBySwisCode := PrintBySwisCodeCheckBox.Checked;

                {FXX01082004-1(2.07l): Fix up for history.}

              If (ProcessingType = History)
                then
                  begin
                    ParcelTable.Filter := 'TaxRollYr = ' + AssessmentYear;
                    ParcelTable.Filtered := True;
                  end;

              FillSortFile(Quit);

              ProgressDialog.Reset;
              ProgressDialog.TotalNumRecords := GetRecordCount(SortTable);

                {Now print the report.}

              If not (Quit or ReportCancelled)
                then
                  begin
                    ProgressDialog.UserLabelCaption := 'Printing AV by property class report.';

                    TextFileName := GetPrintFileName(Self.Caption, True);
                    TextFiler.FileName := TextFileName;

                      {FXX01211998-1: Need to set the LastPage property so that
                                      long rolls aren't a problem.}

                    TextFiler.LastPage := 30000;

                    TextFiler.Execute;

                      {FXX09071999-6: Tell people that printing is starting and
                                      done.}

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

                    ShowReportDialog('AVPRPCLS.RPT', TextFiler.FileName, True);

                  end;  {If not Quit}

                {Make sure to close and delete the sort file.}

              SortTable.Close;

              ProgressDialog.Finish;
              SelectedSwisCodes.Free;
              SelectedSchoolCodes.Free;
              SelectedPropertyClassCodes.Free;
              SelectedPropertyClassCodes2.Free;

                {FXX09071999-6: Tell people that printing is starting and
                                done.}

              DisplayPrintingFinishedMessage(PrintDialog.PrintToFile);
              ResetPrinter(ReportPrinter);
              ParcelTable.Filtered := False;

              If ExtractToExcel
                then
                  begin
                    CloseFile(ExtractFile);
                    SendTextFileToExcelSpreadsheet(SpreadsheetFileName, True,
                                                   False, '');

                  end;  {If ExtractToExcel}
              
            end;  {If not Quit}

      end;  {If PrintDialog.Execute}

  PrintButton.Enabled := True;

end;  {StartButtonClick}

{===================================================================}
{===============  THE FOLLOWING ARE PRINTING PROCEDURES ============}
{===================================================================}
Procedure InitTotalsRec(var TotalsRec : TotalsRecord);

begin
  with TotalsRec do
    begin
      PropertyClass := '';
      RollSection := '';
      Count := 0;
      LandVal := 0;
      AssessedVal := 0;
      CountyTaxableVal := 0;
      TownTaxableVal := 0;
      SchoolTaxableVal := 0;
      VillageTaxableVal := 0;
      VeteranEXAmt := 0;
      ParapalegicEXAmt := 0;
      ClergyEXAmt := 0;
      STARExAmt := 0;
      TotalNumSTARs := 0;
      AgedCountyEXAmt := 0;
      AgedTownEXAmt := 0;
      AgedSchoolEXAmt := 0;
      AgedVillageEXAmt := 0;
      OtherCountyEXAmt := 0;
      OtherTownEXAmt := 0;
      OtherSchoolEXAmt := 0;
      OtherVillageEXAmt := 0;
      SystemCountyEXAmt := 0;
      SystemTownEXAmt := 0;
      SystemSchoolEXAmt := 0;
      SystemVillageEXAmt := 0;

    end;  {TotalsRecord = record}

end;  {InitTotalsRec);

{===================================================================}
Procedure TAssessmentByPropertyClassReportForm.PrintLine(Sender : TObject;
                                                         TotalsRec : TotalsRecord;
                                                         TotalsDescription : String;
                                                         PrintRollSection,
                                                         PrintPropertyClass : Boolean;
                                                         _HomesteadCode : Char);

var
  TempStr : String;
  TempRollSection : String;

begin
  If (TBaseReport(Sender).LinesLeft < 8)
    then
      begin
        TBaseReport(Sender).NewPage;
        PrintHeader(Sender, _HomesteadCode);
      end;

  with Sender as TBaseReport, TotalsRec do
    begin
      TempStr := PropertyClass;
      If (Deblank(OwnershipCode) <> '')
        then TempStr := TempStr + '-' + OwnershipCode;

      If not PrintPropertyClass
        then TempStr := '';

      TempRollSection := RollSection;
      If not PrintRollSection
        then TempRollSection := '';

      Print(#9 + LastSwisCode +
            #9 + TempRollSection +
            #9 + TempStr +
            #9 + Take(20, UpcaseStr(TotalsDescription)) +
            #9 + IntToStr(Count) +
            #9 + FormatFloat(CurrencyDisplayNoDollarSign, LandVal));

      If (rtdCounty in GlblRollTotalsToShow)
        then Print(#9 + FormatFloat(CurrencyDisplayNoDollarSign, CountyTaxableVal))
        else Print(#9);

      Print(#9 + FormatFloat(CurrencyDisplayNoDollarSign, VeteranEXAmt) +
            #9 + FormatFloat(CurrencyDisplayNoDollarSign, ParapalegicEXAmt) +
            #9 + FormatFloat(CurrencyDisplayNoDollarSign, ClergyEXAmt));

      If (rtdSchool in GlblRollTotalsToShow)
        then Println(#9 + FormatFloat(CurrencyDisplayNoDollarSign, STAREXAmt) +
                     #9 + '(' + IntToStr(TotalNumSTARs) + ')')
        else Println('');

      Print(#9 + #9 + #9 + #9 + #9 +
            #9 + FormatFloat(CurrencyDisplayNoDollarSign, AssessedVal));

      If (rtdMunicipal in GlblRollTotalsToShow)
        then Print(#9 + FormatFloat(CurrencyDisplayNoDollarSign, TownTaxableVal))
        else Print(#9);

      If (rtdCounty in GlblRollTotalsToShow)
        then Print(#9 + FormatFloat(CurrencyDisplayNoDollarSign, AgedCountyEXAmt))
        else Print(#9);

      If (rtdMunicipal in GlblRollTotalsToShow)
        then Print(#9 + FormatFloat(CurrencyDisplayNoDollarSign, AgedTownEXAmt))
        else Print(#9);

      If (rtdSchool in GlblRollTotalsToShow)
        then Print(#9 + FormatFloat(CurrencyDisplayNoDollarSign, AgedSchoolEXAmt))
        else Print(#9);

      If (rtdVillageReceivingPartialRoll in GlblRollTotalsToShow)
        then Println(#9 + FormatFloat(CurrencyDisplayNoDollarSign, AgedVillageEXAmt))
        else Println('');

      Print(#9 + #9 + #9 + #9 + #9 + #9);

      If (rtdSchool in GlblRollTotalsToShow)
        then Print(#9 + FormatFloat(CurrencyDisplayNoDollarSign, SchoolTaxableVal))
        else Print(#9);

      If (rtdCounty in GlblRollTotalsToShow)
        then Print(#9 + FormatFloat(CurrencyDisplayNoDollarSign, OtherCountyEXAmt))
        else Print(#9);

      If (rtdMunicipal in GlblRollTotalsToShow)
        then Print(#9 + FormatFloat(CurrencyDisplayNoDollarSign, OtherTownEXAmt))
        else Print(#9);

      If (rtdSchool in GlblRollTotalsToShow)
        then Print(#9 + FormatFloat(CurrencyDisplayNoDollarSign, OtherSchoolEXAmt))
        else Print(#9);

      If (rtdVillageReceivingPartialRoll in GlblRollTotalsToShow)
        then Println(#9 + FormatFloat(CurrencyDisplayNoDollarSign, OtherVillageEXAmt))
        else Println('');

      Print(#9 + #9 + #9 + #9 + #9 + #9);

      If (rtdVillageReceivingPartialRoll in GlblRollTotalsToShow)
        then Print(#9 + FormatFloat(CurrencyDisplayNoDollarSign, VillageTaxableVal))
        else Print(#9);

      If (rtdCounty in GlblRollTotalsToShow)
        then Print(#9 + FormatFloat(CurrencyDisplayNoDollarSign, SystemCountyEXAmt))
        else Print(#9);

      If (rtdMunicipal in GlblRollTotalsToShow)
        then Print(#9 + FormatFloat(CurrencyDisplayNoDollarSign, SystemTownEXAmt))
        else Print(#9);

      If (rtdSchool in GlblRollTotalsToShow)
        then Print(#9 + FormatFloat(CurrencyDisplayNoDollarSign, SystemSchoolEXAmt))
        else Print(#9);

      If (rtdVillageReceivingPartialRoll in GlblRollTotalsToShow)
        then Println(#9 + FormatFloat(CurrencyDisplayNoDollarSign, SystemVillageEXAmt))
        else Println('');

      Println('');

      If ExtractToExcel
        then
          begin
            WriteCommaDelimitedLine(ExtractFile,
                                    [LastSwisCode,
                                     TempRollSection,
                                     TempStr,
                                     UpcaseStr(TotalsDescription),
                                     Count,
                                     LandVal,
                                     AssessedVal]);

            If (rtdCounty in GlblRollTotalsToShow)
              then WriteCommaDelimitedLine(ExtractFile, [CountyTaxableVal]);

            If (rtdMunicipal in GlblRollTotalsToShow)
              then WriteCommaDelimitedLine(ExtractFile, [TownTaxableVal]);

            If (rtdSchool in GlblRollTotalsToShow)
              then WriteCommaDelimitedLine(ExtractFile, [SchoolTaxableVal]);

            If (rtdVillageReceivingPartialRoll in GlblRollTotalsToShow)
              then WriteCommaDelimitedLine(ExtractFile, [VillageTaxableVal]);

            WriteCommaDelimitedLine(ExtractFile,
                                    [FormatFloat(CurrencyDisplayNoDollarSign, VeteranEXAmt),
                                     FormatFloat(CurrencyDisplayNoDollarSign, ParapalegicEXAmt),
                                     FormatFloat(CurrencyDisplayNoDollarSign, ClergyEXAmt)]);

            If (rtdSchool in GlblRollTotalsToShow)
              then WriteCommaDelimitedLine(ExtractFile,
                                           [STAREXAmt,
                                            TotalNumSTARs]);

            If (rtdCounty in GlblRollTotalsToShow)
              then WriteCommaDelimitedLine(ExtractFile, [AgedCountyEXAmt]);

            If (rtdMunicipal in GlblRollTotalsToShow)
              then WriteCommaDelimitedLine(ExtractFile, [AgedTownEXAmt]);

            If (rtdSchool in GlblRollTotalsToShow)
              then WriteCommaDelimitedLine(ExtractFile, [AgedSchoolEXAmt]);

            If (rtdVillageReceivingPartialRoll in GlblRollTotalsToShow)
              then WriteCommaDelimitedLine(ExtractFile, [AgedVillageEXAmt]);

            If (rtdCounty in GlblRollTotalsToShow)
              then WriteCommaDelimitedLine(ExtractFile, [OtherCountyEXAmt]);

            If (rtdMunicipal in GlblRollTotalsToShow)
              then WriteCommaDelimitedLine(ExtractFile, [OtherTownEXAmt]);

            If (rtdSchool in GlblRollTotalsToShow)
              then WriteCommaDelimitedLine(ExtractFile, [OtherSchoolEXAmt]);

            If (rtdVillageReceivingPartialRoll in GlblRollTotalsToShow)
              then WriteCommaDelimitedLine(ExtractFile, [OtherVillageEXAmt]);

            If (rtdCounty in GlblRollTotalsToShow)
              then WriteCommaDelimitedLine(ExtractFile, [SystemCountyEXAmt]);

            If (rtdMunicipal in GlblRollTotalsToShow)
              then WriteCommaDelimitedLine(ExtractFile, [SystemTownEXAmt]);

            If (rtdSchool in GlblRollTotalsToShow)
              then WriteCommaDelimitedLine(ExtractFile, [SystemSchoolEXAmt]);

            If (rtdVillageReceivingPartialRoll in GlblRollTotalsToShow)
              then WritelnCommaDelimitedLine(ExtractFile, [SystemVillageEXAmt])
              else WritelnCommaDelimitedLine(ExtractFile, ['']);

          end;  {If ExtractToExcel}

    end;  {with Sender as TBaseReport do}

end;  {PrintLine}

{========================================================================================}
Procedure UpdateTotals(var TotalsRec : TotalsRecord;
                           SortTable : TTable);

begin
  with SortTable, TotalsRec do
    begin
      SwisCode := FieldByName('SwisCode').Text;
      PropertyClass := FieldByName('PropertyClass').Text;
      RollSection := FieldByName('RollSection').Text;
      OwnershipCode := FieldByName('OwnershipCode').Text;
      LandVal := LandVal + TCurrencyField(FieldByName('LandAssessedVal')).Value;
      AssessedVal := AssessedVal + TCurrencyField(FieldByName('TotalAssessedVal')).Value;
      CountyTaxableVal := CountyTaxableVal + TCurrencyField(FieldByName('CountyTaxableVal')).Value;
      TownTaxableVal := TownTaxableVal + TCurrencyField(FieldByName('TownTaxableVal')).Value;
      SchoolTaxableVal := SchoolTaxableVal + TCurrencyField(FieldByName('SchoolTaxableVal')).Value;
      VillageTaxableVal := VillageTaxableVal + TCurrencyField(FieldByName('VillageTaxableVal')).Value;
      VeteranEXAmt := VeteranEXAmt + FieldByName('VeteransEXAmt').AsFloat;
      ParapalegicEXAmt := ParapalegicEXAmt + FieldByName('ParapalegicEXAmt').AsFloat;
      ClergyEXAmt := ClergyEXAmt + FieldByName('ClergyEXAmt').AsFloat;
      STAREXAmt := STAREXAmt + FieldByName('STARExAmt').ASFloat;
      AgedCountyEXAmt := AgedCountyEXAmt + FieldByName('AgedCountyEXAmt').AsFloat;
      AgedTownEXAmt := AgedTownEXAmt + FieldByName('AgedTownEXAmt').AsFloat;
      AgedSchoolEXAmt := AgedSchoolEXAmt + FieldByName('AgedSchoolEXAmt').AsFloat;
      AgedVillageEXAmt := AgedVillageEXAmt + FieldByName('AgedVillageEXAmt').AsFloat;
      OtherCountyEXAmt := OtherCountyEXAmt + FieldByName('OtherCountyEXAmt').AsFloat;
      OtherTownEXAmt := OtherTownEXAmt + FieldByName('OtherTownEXAmt').AsFloat;
      OtherSchoolEXAmt := OtherSchoolEXAmt + FieldByName('OtherSchoolEXAmt').AsFloat;
      OtherVillageEXAmt := OtherVillageEXAmt + FieldByName('OtherVillageEXAmt').AsFloat;
      SystemCountyEXAmt := SystemCountyEXAmt + FieldByName('SystemCountyEXAmt').AsFloat;
      SystemTownEXAmt := SystemTownEXAmt + FieldByName('SystemTownEXAmt').AsFloat;
      SystemSchoolEXAmt := SystemSchoolEXAmt + FieldByName('SystemSchoolEXAmt').AsFloat;
      SystemVillageEXAmt := SystemVillageEXAmt + FieldByName('SystemVillageEXAmt').AsFloat;
        {CHG05162000-2: Show the total number of STARS.}
      TotalNumSTARs := TotalNumSTARs + FieldByName('TotalNumSTARs').AsInteger;
      Count := Count + FieldByName('Count').AsInteger;

    end;  {with SortTable do}

end;  {UpdateTotals}

{==================================================================================}
Procedure TAssessmentByPropertyClassReportForm.TextFilerBeforePrint(Sender: TObject);

begin
  SortTable.First;
  LastSwisCode := SortTable.FieldByName('SwisCode').Text;

  If not PrintBySwisCode
    then LastSwisCode := Take(4, LastSwisCode);

end;  {TextFilerBeforePrint}

{========================================================================================}
Procedure TAssessmentByPropertyClassReportForm.PrintHeader(Sender: TObject;
                                                           _HomesteadCode : Char);

var
  TempStr, TempHstdStr, MunicipalityType : String;
  I : Integer;

begin
  with Sender as TBaseReport do
    begin
      ClearTabs;
      SetTab(0.2, pjLeft, 13.0, 0, BoxLineNone, 0);

      Println('');
      Println(Take(43, 'COUNTY OF ' + GlblCountyName) +
              Center('ASSESSMENT BY PROPERTY CLASS REPORT', 43) +
              RightJustify('Page: ' + IntToStr(CurrentPage), 43));

      Println(Take(43, UpcaseStr(GetMunicipalityName)) +
              Center('ASSESSMENT YEAR ' + AssessmentYear, 43) +
              RightJustify('Date: ' + DateToStr(Date) +
                           '  Time: ' + TimeToStr(Now), 43));

      TempStr := '';
      If (Length(Trim(LastSwisCode)) = 6)
        then TempStr := '(' + Trim(GetDescriptionFromList(LastSwisCode, SwisCodesList)) + ')';

      case _HomesteadCode of
        'H' : TempHstdStr := 'HOMESTEAD PARCELS';
        'N' : TempHstdStr := 'NON-HOMESTEAD PARCELS';
        ' ' : TempHstdStr := '';
      end;  {case HomesteadCode of}

      Println(Take(43, 'SWIS CODE: ' + LastSwisCode + TempStr) +
              Center(TempHstdStr, 43));

        {CHG05162000-1: Allow for selection of school codes.}

      If (SelectedSchoolCodes.Count <> GetRecordCount(SchoolCodeTable))
        then
          begin
            TempStr := '';
            For I := 0 to (SelectedSchoolCodes.Count - 1) do
              TempStr := TempStr + SelectedSchoolCodes[I] + ' ';
            Println('SCHOOL CODES: ' + TempStr);
          end
        else Println('');

      ClearTabs;
      SetTab(6.2, pjLeft, 1.3, 0, BoxLineBottom, 0);  {Taxables}
      SetTab(7.6, pjLeft, 6.0, 0, BoxLineBottom, 0);  {Veterans \ County amts}

      Println(#9 + '> TAXABLE <' +
              #9 + '>>>>>>>>>>>>>>>>>  E X E M P T I O N S  <<<<<<<<<<<<<<<<<');

      ClearTabs;
      SetTab(0.3, pjLeft, 0.7, 0, BoxLineBottom, 0);  {Swis Code}
      SetTab(1.1, pjLeft, 0.1, 0, BoxLineBottom, 0);  {Roll Section}
      SetTab(1.3, pjLeft, 0.5, 0, BoxLineBottom, 0);  {Property Class}
      SetTab(1.9, pjLeft, 2.0, 0, BoxLineBottom, 0);  {Description}
      SetTab(4.0, pjCenter, 0.7, 0, BoxLineBottom, 0);  {Count}
      SetTab(4.8, pjRight, 1.3, 0, BoxLineBottom, 0);  {Land AV\Total AV}
      SetTab(6.2, pjRight, 1.3, 0, BoxLineBottom, 0);  {Taxables}
      SetTab(7.6, pjRight, 1.3, 0, BoxLineBottom, 0);  {Veterans \ County amts}
      SetTab(9.0, pjRight, 1.3, 0, BoxLineBottom, 0);  {Parapalegic \ Town amts}
      SetTab(10.4, pjRight, 1.3, 0, BoxLineBottom, 0);  {Clergy \ School amts}
      SetTab(11.8, pjRight, 1.3, 0, BoxLineBottom, 0);  {Village amts}

      MunicipalityType := ANSIUpperCase(GetMunicipalityTypeName(GlblMunicipalityType));

      Print(#9 + 'SWIS' +
            #9 + 'R' +
            #9 + 'PROP' +
            #9 + #9 + '#' +
            #9 + 'LAND VAL');

      If (rtdCounty in GlblRollTotalsToShow)
        then Print(#9 + 'COUNTY')
        else Print(#9);

      Print(#9 + 'VETERANS' +
            #9 + 'PARAPALEGIC' +
            #9 + 'CLERGY');

      If (rtdSchool in GlblRollTotalsToShow)
        then Println(#9 + 'STAR')
        else Println('');

      Print(#9 + 'CODE' +
            #9 + 'S' +
            #9 + 'CLASS' +
            #9 + 'DESCRIPTION' +
            #9 + 'PARCELS' +
            #9 + 'TOTAL VAL');

      If (rtdMunicipal in GlblRollTotalsToShow)
        then Print(#9 + MunicipalityType)
        else Print(#9);

      If (rtdCounty in GlblRollTotalsToShow)
        then Print(#9 + 'SNR CNTY')
        else Print(#9);

      If (rtdMunicipal in GlblRollTotalsToShow)
        then Print(#9 + 'SNR ' + MunicipalityType)
        else Print(#9);

      If (rtdSchool in GlblRollTotalsToShow)
        then Print(#9 + 'SNR SCHL')
        else Print(#9);

      If (rtdVillageReceivingPartialRoll in GlblRollTotalsToShow)
        then Println(#9 + 'SNR VILL')
        else Println('');

      Print(#9 + #9 + #9 + #9 + #9 + #9);

      If (rtdSchool in GlblRollTotalsToShow)
        then Print(#9 + 'SCHOOL')
        else Print(#9);

      If (rtdCounty in GlblRollTotalsToShow)
        then Print(#9 + 'OTHER CNTY')
        else Print(#9);

      If (rtdMunicipal in GlblRollTotalsToShow)
        then Print(#9 + 'OTHER ' + MunicipalityType)
        else Print(#9);

      If (rtdSchool in GlblRollTotalsToShow)
        then Print(#9 + 'OTHER SCHL')
        else Print(#9);

      If (rtdVillageReceivingPartialRoll in GlblRollTotalsToShow)
        then Println(#9 + 'OTHER VILL')
        else Println('');

      Print(#9 + #9 + #9 + #9 + #9 + #9 + #9);

      If (rtdCounty in GlblRollTotalsToShow)
        then Print(#9 + 'SYSTEM CNTY')
        else Print(#9);

      If (rtdMunicipal in GlblRollTotalsToShow)
        then Print(#9 + 'SYSTEM ' + MunicipalityType)
        else Print(#9);

      If (rtdSchool in GlblRollTotalsToShow)
        then Print(#9 + 'SYSTEM SCHL')
        else Print(#9);

      If (rtdVillageReceivingPartialRoll in GlblRollTotalsToShow)
        then Println(#9 + 'SYSTEM VILL')
        else Println('');

      Println('');

      ClearTabs;
      SetTab(0.3, pjLeft, 0.7, 0, BoxLineBottom, 0);  {Swis Code}
      SetTab(1.1, pjLeft, 0.1, 0, BoxLineBottom, 0);  {Roll Section}
      SetTab(1.3, pjLeft, 0.5, 0, BoxLineBottom, 0);  {Property Class}
      SetTab(1.9, pjLeft, 2.0, 0, BoxLineBottom, 0);  {Description}
      SetTab(4.0, pjRight, 0.7, 0, BoxLineBottom, 0);  {Count}
      SetTab(4.8, pjRight, 1.3, 0, BoxLineBottom, 0);  {Land AV\Total AV}
      SetTab(6.2, pjRight, 1.3, 0, BoxLineBottom, 0);  {Taxables}
      SetTab(7.6, pjRight, 1.3, 0, BoxLineBottom, 0);  {Veterans \ County amts}
      SetTab(9.0, pjRight, 1.3, 0, BoxLineBottom, 0);  {Parapalegic \ Town amts}
      SetTab(10.4, pjRight, 1.3, 0, BoxLineBottom, 0);  {Clergy \ School amts}
      SetTab(11.8, pjRight, 1.3, 0, BoxLineBottom, 0);  {Village amts}
      SetTab(13.2, pjRight, 0.7, 0, BoxLineBottom, 0);  {STAR count}

    end;  {with Sender as TBaseReport do}

end;  {PrintHeader}

{========================================================================================}
Procedure TAssessmentByPropertyClassReportForm.PrintRollSections(Sender : TObject;
                                                                 NewSwisCode,
                                                                 OldSwisCode : String;
                                                                 SortTable : TwwTable;
                                                                 SwisCodeDescriptionList : TList;
                                                                 DoneWithReport : Boolean;
                                                                 _HomesteadCode : Char);

{Print all the roll sections for this swis code.}

type
  RSTotalsArrayType = Array[1..9] of TotalsRecord;

var
  FirstTimeThrough, Done : Boolean;
  RSTotalsArray : RSTotalsArrayType;
  OverallTotalsRec : TotalsRecord;
  I, RollSection, SwisCodeLen : Integer;
  Bookmark : TBookmark;
  TempStr : String;

begin
  FirstTimeThrough := True;
  Done := False;
  For I := 1 to 9 do
    InitTotalsRec(RSTotalsArray[I]);

  If ExtractToExcel
    then WritelnCommaDelimitedLine(ExtractFile, ['']);
    
  InitTotalsRec(OverallTotalsRec);

  TBaseReport(Sender).NewPage;
  PrintHeader(Sender, _HomesteadCode);

  Bookmark := SortTable.GetBookmark;

  SwisCodeLen := 6;
  SortTable.First;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else SortTable.Next;

    If SortTable.EOF
      then Done := True;

    If not Done
      then
        begin
          SwisCodeLen := Length(Trim(OldSwisCode));

          If (Take(SwisCodeLen, OldSwisCode) = Take(SwisCodeLen, SortTable.FieldByName('SwisCode').Text))
            then
              begin
                RollSection := SortTable.FieldByName('RollSection').AsInteger;;
                UpdateTotals(RSTotalsArray[RollSection], SortTable);
                UpdateTotals(OverallTotalsRec, SortTable);
              end;

        end;  {If not Done}

  until Done;

  For I := 1 to 9 do
    If (RSTotalsArray[I].Count > 0)
     then PrintLine(Sender, RSTotalsArray[I],
                   'ROLL SEC ' + RSTotalsArray[I].RollSection + ' TOTAL', False, False,
                   _HomesteadCode);

   {Print the grand totals.}

  If (SwisCodeLen = 4)
    then TempStr := 'MUNICIPALITY TOTALS'
    else TempStr := 'SWIS ' + Trim(OldSwisCode) + ' TOTAL';

  PrintLine(Sender, OverallTotalsRec, TempStr, False, False, _HomesteadCode);

  SortTable.GotoBookmark(Bookmark);
  SortTable.FreeBookmark(Bookmark);

  If not DoneWithReport
    then
      begin
        with Sender as TBaseReport do
          NewPage;
        LastSwisCode := NewSwisCode;
        PrintHeader(Sender, _HomesteadCode);
      end;

end;  {PrintRollSections}

{===================================================================}
Procedure TAssessmentByPropertyClassReportForm.AV_PCPrintReport(Sender: TObject;
                                                                _HomesteadCode : Char);

var
  LastClassHadOwnershipCode,
  Quit, Done, FirstTimeThrough : Boolean;
  ThisPropertyClass, LastPropertyClass, Description,
  ThisSwisCode, ThisRollSection, LastRollSection : String;
  MajorClassTotalsRec, RollSectionTotalsRec, PropertyClassTotalsRec : TotalsRecord;

 begin
  Done := False;
  Quit := False;
  FirstTimeThrough := True;

  InitTotalsRec(MajorClassTotalsRec);
  InitTotalsRec(RollSectionTotalsRec);
  InitTotalsRec(PropertyClassTotalsRec);
  PrintHeader(Sender, _HomesteadCode);

(*  SortTable.wwFilter.Clear;

  If (_HomesteadCode in ['H', 'N'])
    then
      with SortTable do
        begin
          wwFilter.Add('HomesteadCode = _HomesteadCode');
          FilterActivate;
        end; *)

  with Sender as TBaseReport do
    begin
      try
        SortTable.First;
      except
        Quit := True;
        SystemSupport(050, SortTable, 'Error getting sort record.',
                      UnitName, GlblErrorDlgBox);
      end;

      LastPropertyClass := '';
      LastSwisCode := '';
      LastRollSection := '';
      LastClassHadOwnershipCode := False;

      repeat
        If FirstTimeThrough
          then FirstTimeThrough := False
          else
            try
              SortTable.Next;
            except
              Quit := True;
              SystemSupport(050, SortTable, 'Error getting sort record.',
                            UnitName, GlblErrorDlgBox);
            end;

        If SortTable.EOF
          then Done := True;

        If not Quit
          then
            begin
              ThisPropertyClass := SortTable.FieldByName('PropertyClass').Text;
              ThisSwisCode := SortTable.FieldByName('SwisCode').Text;
              ThisRollSection := SortTable.FieldByName('RollSection').Text;

              ProgressDialog.Update(Self,
                                    'Prop Class: ' +
                                    SortTable.FieldByName('PropertyClass').Text);

                {If the ownership code changed or the property class changed, print the last property class\
                 ownership code.}

              If (((LastPropertyClass = ThisPropertyClass) and
                   (Deblank(SortTable.FieldByName('OwnershipCode').Text) <> '')) or
                 ((LastPropertyClass <> ThisPropertyClass) and
                   (Deblank(LastPropertyClass) <> '')) or
                 ((LastRollSection <> ThisRollSection) and
                  (Deblank(LastRollSection) <> '')) or
                 ((LastSwisCode <> ThisSwisCode) and
                  (Deblank(LastSwisCode) <> '')) or
                  Done)
                then
                  begin
                    If (Deblank(PropertyClassTotalsRec.OwnershipCode) = '')
                      then Description := GetDescriptionFromList(PropertyClassTotalsRec.PropertyClass, PropertyClassCodes)
                      else Description := GetDescriptionFromList(PropertyClassTotalsRec.OwnershipCode, OwnershipCodesList);

                    PrintLine(Sender, PropertyClassTotalsRec, Description, True, True,
                              _HomesteadCode);

                    InitTotalsRec(PropertyClassTotalsRec);

                  end;  {If (((LastPropertyClass = ThisPropertyClass) and}

                {If we are going to a new property class, check to see if we need to print a class
                 summary total if there were ownership subclasses.}

              If (((LastPropertyClass <> ThisPropertyClass) and
                   (Deblank(LastPropertyClass) <> '')) or
                 ((LastRollSection <> ThisRollSection) and
                  (Deblank(LastRollSection) <> '')) or
                 ((LastSwisCode <> ThisSwisCode) and
                  (Deblank(LastSwisCode) <> '')) or
                  Done)
                then
                  begin
                    If LastClassHadOwnershipCode
                      then
                        begin
                          PrintLine(Sender, MajorClassTotalsRec,
                                    MajorClassTotalsRec.PropertyClass + ' CLASS TOTAL',
                                    True, False, _HomesteadCode);

                          If ExtractToExcel
                            then WritelnCommaDelimitedLine(ExtractFile, ['']);
                                    
                        end;  {If (NumEntriesThisClas > 1)}

                    LastClassHadOwnershipCode := False;
                    InitTotalsRec(MajorClassTotalsRec);

                  end;  {If (((LastPropertyClass <> ThisPropertyClass) and ...}

                 {If the roll section changed, print the last one.}

              If (((LastRollSection <> ThisRollSection) and
                   (Deblank(LastRollSection) <> '')) or
                  Done)
                then
                  begin
                    PrintLine(Sender, RollSectionTotalsRec,
                              'ROLL SEC ' + RollSectionTotalsRec.RollSection + ' TOTAL',
                              False, False, _HomesteadCode);

                    If ExtractToExcel
                      then WritelnCommaDelimitedLine(ExtractFile, ['']);

                    InitTotalsRec(RollSectionTotalsRec);

                  end;  {If (((LastRollSection <> ThisRollSection) and ...}

                {If the swis code changed, print all the roll sections for it.}

              If (((LastSwisCode <> ThisSwisCode) and
                   (Deblank(LastSwisCode) <> '')) or
                  (Done and
                   PrintBySwisCode))
                then PrintRollSections(Sender, ThisSwisCode, LastSwisCode, SortTable, SwisCodesList,
                                       Done, _HomesteadCode);

              UpdateTotals(PropertyClassTotalsRec, SortTable);
              UpdateTotals(MajorClassTotalsRec, SortTable);
              UpdateTotals(RollSectionTotalsRec, SortTable);

            end;  {If not Done or Quit}

        LastPropertyClass := ThisPropertyClass;
        LastRollSection := ThisRollSection;
        LastSwisCode := ThisSwisCode;

        If (Deblank(SortTable.FieldByName('OwnershipCode').Text) <> '')
          then LastClassHadOwnershipCode := True;

        ReportCancelled := ProgressDialog.Cancelled;

      until (Done or Quit or ReportCancelled);

        {Print the municipality totals.}

      LastSwisCode := Take(4, LastSwisCode);

      PrintRollSections(Sender, ThisSwisCode, LastSwisCode, SortTable, SwisCodesList,
                        True, _HomesteadCode);

    end;  {with Sender as TBaseReport do}

end;  {PrintReport}

{===================================================================}
Procedure TAssessmentByPropertyClassReportForm.PrintSelections(Sender : TObject);

begin
  TBaseReport(Sender).NewPage;
  PrintHeader(Sender, ' ');

  with Sender as TBaseReport do
    begin
      Println('');
      ClearTabs;
      SetTab(0.3, pjLeft, 5.0, 0, BoxLineBottom, 0);  {Swis Code}

      Println('Selections:');
      Println('');

      If PrintBySwisCode
        then Println(#9 + 'Print by swis code.')
        else Println(#9 + 'Print grand totals.');

      If ShowHstdNonhstdTotals
        then Println(#9 + 'Show homestead and nonhomestead amounts.');

      If (SwisCodeListBox.Items.Count = SwisCodeListBox.SelCount)
        then Println(#9 + 'All swis codes.')
        else PrintSelectedList(Sender, SelectedSwisCodes, 'swis codes: ');

      If (PropertyClassListBox.Items.Count = PropertyClassListBox.SelCount)
        then Println(#9 + 'All property class codes.')
        else PrintSelectedList(Sender, SelectedPropertyClassCodes2, 'property class codes: ');

    end;  {with Sender as TBaseReport do}

end;  {PrintSelections}

{===================================================================}
Procedure TAssessmentByPropertyClassReportForm.TextFilerPrint(Sender: TObject);

begin
    {If they want to see homestead and non-hstd breakdown, print those reports next.}

  If ShowHstdNonhstdTotals
    then
      begin
        SortTable.IndexName := 'BYHC_SWIS_RS_PC_OC';
        SetRangeOld(SortTable,
                    ['HomesteadCode', 'SwisCode', 'RollSection', 'PropertyClass', 'OwnershipCode'],
                    ['H', '      '], ['H', 'ZZZZZZ']);
        AV_PCPrintReport(Sender, 'H');
        TBaseReport(Sender).NewPage;

        SortTable.CancelRange;
        SetRangeOld(SortTable,
                    ['HomesteadCode', 'SwisCode', 'RollSection', 'PropertyClass', 'OwnershipCode'],
                    ['N', '      '], ['N', 'ZZZZZZ']);
        AV_PCPrintReport(Sender, 'N');
        TBaseReport(Sender).NewPage;

      end;  {If ShowHstdNonhstdTotals}

  SortTable.IndexName := 'BYSWIS_RS_PC_OC_HC';
  AV_PCPrintReport(Sender, ' ');

  PrintSelections(Sender);

end;  {TextFilerPrint}

{==================================================================}
Procedure TAssessmentByPropertyClassReportForm.ReportPrint(Sender: TObject);

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
Procedure TAssessmentByPropertyClassReportForm.FormClose(    Sender: TObject;
                                                 var Action: TCloseAction);

begin
  CloseTablesForForm(Self);

  FreeTList(PropertyClassCodes, SizeOf(CodeRecord));
  FreeTList(OwnershipCodesList, SizeOf(CodeRecord));
  FreeTList(SwisCodesList, SizeOf(CodeRecord));

    {Free up the child window and set the ClosingAForm Boolean to
     true so that we know to delete the tab.}

  Action := caFree;
  GlblClosingAForm := True;
  GlblClosingFormCaption := Caption;

end;  {FormClose}



end.