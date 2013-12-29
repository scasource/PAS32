unit Rpcompsd;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, DBCtrls, DBTables, DB, Buttons, Grids,
  Wwdbigrd, Wwdbgrid, ExtCtrls, Wwtable, Wwdatsrc, Menus, wwdblook,
  TabNotBk, Types, RPFiler, RPDefine, RPBase, RPCanvas, RPrinter, Progress,
  RPTXFilr, ComCtrls;

type
  TCompareSpecialDistrictsForm = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    ScrollBox1: TScrollBox;
    TitleLabel: TLabel;
    PrintDialog: TPrintDialog;
    ReportPrinter: TReportPrinter;
    ReportFiler: TReportFiler;
    NotebookChangeTimer: TTimer;
    OpenDialog: TOpenDialog;
    PriorSDTable: TTable;
    SDCodeTable: TTable;
    Label11: TLabel;
    Label12: TLabel;
    CurrentSDTable: TTable;
    PriorEXCodeTable: TTable;
    CurrentEXCodeTable: TTable;
    PriorParcelEXTable: TTable;
    CurrentParcelEXTable: TTable;
    PriorSDCodeTable: TTable;
    CurrentSDCodeTable: TTable;
    CurrentAssessmentTable: TTable;
    PriorAssessmentTable: TTable;
    SortTable: TTable;
    PriorParcelTable: TTable;
    CurrentParcelTable: TTable;
    SchoolCodeTable: TTable;
    SwisCodeTable: TTable;
    CurrentClassTable: TTable;
    PriorClassTable: TTable;
    Panel3: TPanel;
    PrintButton: TBitBtn;
    CloseButton: TBitBtn;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Label10: TLabel;
    Label21: TLabel;
    SwisCodeListBox: TListBox;
    SchoolCodeListBox: TListBox;
    Panel6: TPanel;
    SpecialDistrictListBox: TListBox;
    Panel4: TPanel;
    Label3: TLabel;
    Panel5: TPanel;
    rg_FirstAssessmentYear: TRadioGroup;
    MiscellaneousOptionsGroupBox: TGroupBox;
    CreateParcelListCheckBox: TCheckBox;
    ExtractToExcelCheckBox: TCheckBox;
    GroupBox1: TGroupBox;
    cb_FirstYear: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    cb_SecondYear: TComboBox;
    ed_FirstHistoryYear: TEdit;
    rg_SecondAssessmentYear: TRadioGroup;
    ed_SecondHistoryYear: TEdit;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure rg_AssessmentYearClick(Sender: TObject);
    procedure PrintButtonClick(Sender: TObject);
    procedure ReportPrintHeader(Sender: TObject);
    procedure ReportPrint(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    UnitName : String;

    PriorAssessmentYear, CurrentAssessmentYear : String;
    SelectedSpecialDistricts : TStringList;
    ReportCancelled : Boolean;

    PriorTotalValue,
    PriorTotalUnits,
    PriorTotalSecondaryUnits,
    PriorTotalAcres,
    CurrentTotalValue,
    CurrentTotalUnits,
    CurrentTotalSecondaryUnits,
    CurrentTotalAcres : Extended;
    PriorNumParcels,
    CurrentNumParcels : LongInt;

    CreateParcelList : Boolean;

    OrigSortFileName, FirstYearDataSource, SecondYearDataSource : String;

    SelectedSchoolCodes, SelectedSwisCodes : TStringList;
    ExtractToExcel : Boolean;
    ExtractFile : TextFile;

    Procedure InitializeForm;  {Open the tables and setup.}

    Procedure FillSortFile_OneSpecialDistrict(SDCode : String);

    Procedure FillSortFile;

    Procedure FillListBoxes(AssessmentYear : String);

  end;

implementation

uses GlblVars, WinUtils, Utilitys, UTILEXSD, GlblCnst, PASUtils,
     PRCLLIST,  {Parcel list}
     Prog, RptDialg,
     Preview, PASTypes, DataAccessUnit;

const
    {Assessment Years}
  ayNextYear = 0;
  ayThisYear = 1;
  ayHistory = 2;

{$R *.DFM}

{========================================================}
Procedure TCompareSpecialDistrictsForm.FormActivate(Sender: TObject);

begin
  SetFormStateMaximized(Self);
end;

{========================================================}
Procedure TCompareSpecialDistrictsForm.FillListBoxes(AssessmentYear : String);

{Fill in all the list boxes on the various notebook pages.}

var
  ProcessingType : Integer;
  Quit : Boolean;

begin
  ProcessingType := GetProcessingTypeForTaxRollYear(AssessmentYear);

  OpenTableForProcessingType(SDCodeTable, SdistCodeTableName,
                             ProcessingType, Quit);

  OpenTableForProcessingType(SchoolCodeTable, SchoolCodeTableName,
                             ProcessingType, Quit);

  OpenTableForProcessingType(SwisCodeTable, SwisCodeTableName,
                             ProcessingType, Quit);

  FillOneListBox(SpecialDistrictListBox, SDCodeTable, 'SDistCode',
                 'Description', 10, False, False, ProcessingType, AssessmentYear);

    {CHG10262001-1: Add swis and school selection.}

  FillOneListBox(SwisCodeListBox, SwisCodeTable, 'SwisCode',
                 'MunicipalityName', 25, True, True, ProcessingType, AssessmentYear);

  FillOneListBox(SchoolCodeListBox, SchoolCodeTable, 'SchoolCode',
                 'SchoolName', 25, True, True, ProcessingType, AssessmentYear);

  FillOneListBox(SpecialDistrictListBox, SDCodeTable, 'SDistCode',
                 'Description', 10, False, False, ProcessingType, AssessmentYear);

end;  {FillListBoxes}

{========================================================}
Procedure TCompareSpecialDistrictsForm.InitializeForm;

var
  DatabaseList : TStringList;
  I : Integer;

begin
  UnitName := 'RPCOMPSD';
  FillListBoxes(GlblThisYear);
  OrigSortFileName := SortTable.TableName;

  SelectedSwisCodes := TStringList.Create;
  SelectedSchoolCodes := TStringList.Create;

  DatabaseList := TStringList.Create;
  Session.GetDatabaseNames(DatabaseList);

  For I := 0 to (DatabaseList.Count - 1) do
    If ((Pos('PROPERTYASSESSMENTSYSTEM', ANSIUpperCase(DatabaseList[I])) > 0) or
        (Pos('PAS', ANSIUpperCase(DatabaseList[I])) = 1))
      then
        begin
          cb_FirstYear.Items.Add(DatabaseList[I]);
          cb_SecondYear.Items.Add(DatabaseList[I]);
        end;

  DatabaseList.Free;

end;  {InitializeForm}

{===================================================================}
Procedure TCompareSpecialDistrictsForm.FormKeyPress(    Sender: TObject;
                                     var Key: Char);

begin
  If (Key = #13)
    then
      begin
        Key := #0;
        Perform(WM_NEXTDLGCTL, 0, 0);
      end;

end;  {FormKeyPress}

{==========================================================}
Procedure TCompareSpecialDistrictsForm.rg_AssessmentYearClick(Sender: TObject);

var
  ed_HistoryYear : TEdit;
  rg_AssessmentYear : TRadioGroup;

begin
  If _Compare(TWinControl(Sender).Name, 'rg_FirstAssessmentYear', coEqual)
    then
      begin
        ed_HistoryYear := ed_FirstHistoryYear;
        rg_AssessmentYear := rg_FirstAssessmentYear;
      end
    else
      begin
        ed_HistoryYear := ed_SecondHistoryYear;
        rg_AssessmentYear := rg_SecondAssessmentYear;
      end;

  ed_HistoryYear.Visible := False;

  case rg_AssessmentYear.ItemIndex of
    ayNextYear : FillListBoxes(GlblNextYear);
    ayThisYear : FillListBoxes(GlblThisYear);
    ayHistory :
      begin
        ed_HistoryYear.Visible := True;
        ed_HistoryYear.SetFocus;
      end;

  end;  {case rg_AssessmentYear.ItemIndex of}

end;  {rg_AssessmentYearClick}

{===================================================================}
Procedure TCompareSpecialDistrictsForm.FillSortFile_OneSpecialDistrict(SDCode : String);

var
  PriorActive, CurrentActive, FoundPrior,
  AddRecord, FoundCurrent, Done, FirstTimeThrough, CurrentParcelFound : Boolean;
  ParcelExemptionList, ExemptionCodeList : TList;
  PriorSDValuesList, PriorSDExtensionCodesList,
  PriorSDCC_OMFlagsList, PriorHomesteadCodesList, slPriorAssessedValues,
  CurrentSDValuesList, CurrentSDExtensionCodesList,
  CurrentSDCC_OMFlagsList, CurrentHomesteadCodesList, slCurrentAssessedValues : TStringList;
  SDExtensionType : Char;
  SwisSBLKey : String;
  SBLRec : SBLRecord;
  I : Integer;
  SwisCode, SchoolCode : String;

begin
  CurrentSDValuesList := nil;
  CurrentSDExtensionCodesList := nil;
  CurrentSDCC_OMFlagsList := nil;
  slCurrentAssessedValues := nil;
  Done := False;
  FirstTimeThrough := True;
  ProgressDialog.UserLabelCaption := 'Filling Sort File - Pass 1';

  PriorTotalValue := 0;
  PriorTotalUnits := 0;
  PriorTotalSecondaryUnits := 0;
  PriorTotalAcres := 0;
  PriorNumParcels := 0;
  CurrentTotalValue := 0;
  CurrentTotalUnits := 0;
  CurrentTotalSecondaryUnits := 0;
  CurrentTotalAcres := 0;
  CurrentNumParcels := 0;

  CurrentSDTable.IndexName := 'BYTAXROLLYR_SWISSBLKEY_SD';
  PriorSDTable.IndexName := 'BYSDCODE';
  SetRangeOld(PriorSDTable, ['SDistCode'], [SDCode], [SDCode]);
  PriorSDTable.First;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else PriorSDTable.Next;

    If PriorSDTable.EOF
      then Done := True;

    SwisSBLKey := PriorSDTable.FieldByName('SwisSBLKey').Text;
    FoundPrior := False;

    If ((not Done) and
        (PriorSDTable.FieldByName('TaxRollYr').Text = PriorAssessmentYear))
      then
        begin
          SBLRec := ExtractSwisSBLFromSwisSBLKey(SwisSBLKey);

            {Make sure the prior parcel is active.}
            {FXX11082007(2.11.4.13): Make sure to check that the prior parcel exists
                                     for this special district and it is active.}

          with SBLRec do
            FoundPrior := FindKeyOld(PriorParcelTable,
                                     ['TaxRollYr', 'SwisCode', 'Section',
                                      'Subsection', 'Block', 'Lot', 'Sublot',
                                      'Suffix'],
                                     [PriorAssessmentYear, SwisCode, Section,
                                      Subsection, Block, Lot, Sublot, Suffix]);

          SwisCode := Copy(SwisSBLKey, 1, 6);
          SchoolCode := PriorParcelTable.FieldByName('SchoolCode').Text;

        end;  {If ((not Done) and ...}

    If ((not Done) and
        FoundPrior and
        (PriorSDTable.FieldByName('TaxRollYr').Text = PriorAssessmentYear) and
        ParcelIsActive(PriorParcelTable) and
        (SelectedSwisCodes.IndexOf(SwisCode) > -1) and
        (SelectedSchoolCodes.IndexOf(SchoolCode) > -1))
      then
        begin
          ProgressDialog.Update(Self, ConvertSwisSBLToDashDot(SwisSBLKey));
          Application.ProcessMessages;

          FindKeyOld(PriorAssessmentTable, ['TaxRollYr', 'SwisSBLKey'],
                     [PriorAssessmentYear, SwisSBLKey]);

            {FXX12011999-2: Filter out roll section 9.}

          PriorActive := ((PriorParcelTable.FieldByName('ActiveFlag').Text <> 'D') and
                          (PriorParcelTable.FieldByName('RollSection').Text <> '9'));

          PriorSDValuesList := TStringList.Create;
          PriorSDExtensionCodesList := TStringList.Create;
          PriorSDCC_OMFlagsList := TStringList.Create;
          PriorHomesteadCodesList := TStringList.Create;
          slPriorAssessedValues := TStringList.Create;

          ParcelExemptionList := TList.Create;
          ExemptionCodeList := TList.Create;
          LoadExemptions(PriorAssessmentYear, SwisSBLKey,
                         ParcelExemptionList, ExemptionCodeList,
                         PriorParcelEXTable, PriorEXCodeTable);

            {CHG09122004-1(2.8.0.11): Add homestead split to SD Calcs}

          CalculateSpecialDistrictAmounts(PriorParcelTable,
                                          PriorAssessmentTable,
                                          PriorClassTable,
                                          PriorSDTable,
                                          PriorSDCodeTable,
                                          ParcelExemptionList,
                                          ExemptionCodeList,
                                          PriorSDExtensionCodesList,  {Return lists}
                                          PriorSDCC_OMFlagsList,
                                          slPriorAssessedValues,
                                          PriorSDValuesList,
                                          PriorHomesteadCodesList);

          FreeTList(ParcelExemptionList, SizeOf(ParcelExemptionRecord));
          FreeTList(ExemptionCodeList, SizeOf(ExemptionCodeRecord));

          FoundCurrent := FindKeyOld(CurrentSDTable,
                                     ['TaxRollYr', 'SwisSBLKey', 'SDistCode'],
                                     [CurrentAssessmentYear, SwisSBLKey, SDCode]);

          with SBLRec do
            CurrentParcelFound := FindKeyOld(CurrentParcelTable,
                                             ['TaxRollYr', 'SwisCode', 'Section',
                                              'Subsection', 'Block', 'Lot', 'Sublot',
                                              'Suffix'],
                                             [CurrentAssessmentYear, SwisCode, Section,
                                              Subsection, Block, Lot, Sublot, Suffix]);

          CurrentActive := ((CurrentParcelTable.FieldByName('ActiveFlag').Text <> 'D') and
                            (CurrentParcelTable.FieldByName('RollSection').Text <> '9'));

            {FXX03092005-1(2.8.3.11): Don't count the values if the parcel is inactive.}

          If (FoundCurrent and
              CurrentActive and
              CurrentParcelFound)
            then
              begin
                   {Make sure the Current parcel is active.}

                FindKeyOld(CurrentAssessmentTable, ['TaxRollYr', 'SwisSBLKey'],
                           [CurrentAssessmentYear, SwisSBLKey]);

                CurrentSDValuesList := TStringList.Create;
                CurrentSDExtensionCodesList := TStringList.Create;
                CurrentSDCC_OMFlagsList := TStringList.Create;
                CurrentHomesteadCodesList := TStringList.Create;
                slCurrentAssessedValues := TStringList.Create;

                ParcelExemptionList := TList.Create;
                ExemptionCodeList := TList.Create;
                LoadExemptions(CurrentAssessmentYear, SwisSBLKey,
                               ParcelExemptionList, ExemptionCodeList,
                               CurrentParcelEXTable, CurrentEXCodeTable);

                CalculateSpecialDistrictAmounts(CurrentParcelTable,
                                                CurrentAssessmentTable,
                                                CurrentClassTable,
                                                CurrentSDTable,
                                                CurrentSDCodeTable,
                                                ParcelExemptionList,
                                                ExemptionCodeList,
                                                CurrentSDExtensionCodesList,  {Return lists}
                                                CurrentSDCC_OMFlagsList,
                                                slCurrentAssessedValues,
                                                CurrentSDValuesList,
                                                CurrentHomesteadCodesList);

                FreeTList(ParcelExemptionList, SizeOf(ParcelExemptionRecord));
                FreeTList(ExemptionCodeList, SizeOf(ExemptionCodeRecord));

              end;  {If FoundCurrent}

          If not PriorActive
            then
              For I := 0 to (PriorSDValuesList.Count - 1) do
                PriorSDValuesList[I] := '0';

            {If no current SD, fill in with zero amounts.}
            {FXX11012005-1(2.9.3.10): If the current is not found or it is not active, do the following.}

          If ((not FoundCurrent) or
              (not CurrentActive) or
              (not CurrentParcelFound))
            then
              begin
                slCurrentAssessedValues := TStringList.Create;
                CurrentSDValuesList := TStringList.Create;
                CurrentSDExtensionCodesList := TStringList.Create;
                CurrentSDCC_OMFlagsList := TStringList.Create;

                For I := 0 to (PriorSDValuesList.Count - 1) do
                  begin
                    CurrentSDValuesList.Add('0');
                    slCurrentAssessedValues.Add('0');
                  end;

              end;  {If not FoundCurrent}

            {Now compare the prior and current for differences.}

          AddRecord := False;

          For I := 0 to (PriorSDValuesList.Count - 1) do
            If ((((PriorActive or
                  (FoundCurrent and
                   CurrentActive)) and
                 (PriorSDValuesList[I] <> CurrentSDValuesList[I])) or
                 (not FoundCurrent)))
              then AddRecord := True;

            {FXX03042005-1(2.8.3.10)[3072]: Make sure to catch all blank values so that they don't cause an exception.}

          For I := 0 to (PriorSDValuesList.Count - 1) do
            begin
              If _Compare(PriorSDValuesList[I], coBlank)
                then PriorSDValuesList[I] := '0';

              If _Compare(CurrentSDValuesList[I], coBlank)
                then CurrentSDValuesList[I] := '0';

            end;  {For I := 0 to (PriorSDValuesList.Count - 1) do}

          If AddRecord
            then
              with SortTable do
                try
                  Insert;
                  FieldByName('SDCode').Text := SDCode;
                  FieldByName('SwisSBLKey').Text := SwisSBLKey;

                  For I := 0 to (PriorSDExtensionCodesList.Count - 1) do
                    begin
                      SDExtensionType := SDExtType(PriorSDExtensionCodesList[I]);

                      case SDExtensionType of
                        SDExtCatF,
                        SDExtCatA :  {AdValorum}
                          begin
                            FieldByName('ValuePrior').Text := PriorSDValuesList[I];
                            FieldByName('ValueCurrent').Text := CurrentSDValuesList[I];
                          end;

                          {FXX03032003-1(2.06p6): Misspelled field name for second units.}

                        SDExtCatU : {Units}
                          begin
                            If (PriorSDExtensionCodesList[I] = SDistECUn)
                              then
                                begin
                                  FieldByName('UnitsPrior').Text := PriorSDValuesList[I];
                                  FieldByName('UnitsCurrent').Text := CurrentSDValuesList[I];

                                end
                              else
                                begin
                                  FieldByName('SecondUnitsPrior').Text := PriorSDValuesList[I];
                                  FieldByName('SecondUnitsCurrent').Text := CurrentSDValuesList[I];
                                end;

                          end;  {SDExtCatU}

                        SDExtCatD :
                          begin
                            FieldByName('AcresPrior').Text := PriorSDValuesList[I];
                            FieldByName('AcresCurrent').Text := CurrentSDValuesList[I];
                          end;

                      end;  {case PriorSDExtensionCodes[I] of}

                      FieldByName('ParcelExistsPrior').AsBoolean := True;
                      FieldByName('ParcelExistsCurrent').AsBoolean := FoundCurrent;

                    end;  {For I := 0 to (PriorSDExtensionCodesList.Count - 1) do}

                  Post;
                except
                  SystemSupport(001, SortTable, 'Error posting record ' + SwisSBLKey + ' in sort table.',
                                UnitName, GlblErrorDlgBox);
                end;

            {Update totals}

          For I := 0 to (PriorSDExtensionCodesList.Count - 1) do
            begin
              SDExtensionType := SDExtType(PriorSDExtensionCodesList[I]);

              case SDExtensionType of
                SDExtCatF,
                SDExtCatA :  {AdValorum}
                  begin
                    If PriorActive
                      then PriorTotalValue := PriorTotalValue + StrToFloat(PriorSDValuesList[I]);
                    If CurrentActive
                      then CurrentTotalValue := CurrentTotalValue + StrToFloat(CurrentSDValuesList[I]);
                  end;

                SDExtCatU : {Units}
                  begin
                    If (PriorSDExtensionCodesList[I] = SDistECUn)
                      then
                        begin
                          If PriorActive
                            then PriorTotalUnits := PriorTotalUnits + StrToFloat(PriorSDValuesList[I]);
                          If CurrentActive
                            then CurrentTotalUnits := CurrentTotalUnits + StrToFloat(CurrentSDValuesList[I]);

                        end
                      else
                        begin
                          If PriorActive
                            then PriorTotalSecondaryUnits := PriorTotalSecondaryUnits +
                                                             StrToFloat(PriorSDValuesList[I]);
                          If CurrentActive
                            then CurrentTotalSecondaryUnits := CurrentTotalSecondaryUnits +
                                                               StrToFloat(CurrentSDValuesList[I]);
                        end;

                  end;  {SDExtCatU}

                SDExtCatD :
                  begin
                    If PriorActive
                      then PriorTotalAcres := PriorTotalAcres + StrToFloat(PriorSDValuesList[I]);
                    If CurrentActive
                      then CurrentTotalAcres := CurrentTotalAcres + StrToFloat(CurrentSDValuesList[I]);
                  end;

              end;  {case PriorSDExtensionCodes[I] of}

            end;  {For I := 0 to (PriorSDExtensionCodesList.Count - 1) do}

          PriorSDValuesList.Free;
          PriorSDExtensionCodesList.Free;
          PriorSDCC_OMFlagsList.Free;
          slPriorAssessedValues.Free;

          CurrentSDValuesList.Free;
          CurrentSDExtensionCodesList.Free;
          CurrentSDCC_OMFlagsList.Free;
          slCurrentAssessedValues.Free;

          If PriorActive
            then PriorNumParcels := PriorNumParcels + 1;

          If CurrentActive
            then CurrentNumParcels := CurrentNumParcels + 1;

        end;  {If not Done}

    ReportCancelled := ProgressDialog.Cancelled;

  until (Done or ReportCancelled);

    {Now search for parcels in current but not prior.}

  Done := False;
  FirstTimeThrough := True;
  ProgressDialog.UserLabelCaption := 'Filling Sort File - Pass 2';

  CurrentSDTable.IndexName := 'BYSDCODE';
  PriorSDTable.IndexName := 'BYTAXROLLYR_SWISSBLKEY_SD';

    {FXX11012007(2.11.4.11): Make sure to check against the assessment year.}

  SetRangeOld(CurrentSDTable, ['SDistCode'], [SDCode], [SDCode]);
  CurrentSDTable.Filter := 'TaxRollYr = ' + FormatFilterString(CurrentAssessmentYear);
  CurrentSDTable.Filtered := True;

  CurrentSDTable.First;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else CurrentSDTable.Next;

    If CurrentSDTable.EOF
      then Done := True;

    SwisSBLKey := CurrentSDTable.FieldByName('SwisSBLKey').Text;

    SBLRec := ExtractSwisSBLFromSwisSBLKey(SwisSBLKey);

      {Make sure the current parcel is active.}

    with SBLRec do
      FoundCurrent := FindKeyOld(CurrentParcelTable,
                                 ['TaxRollYr', 'SwisCode', 'Section',
                                  'Subsection', 'Block', 'Lot', 'Sublot', 'Suffix'],
                                 [CurrentAssessmentYear, SwisCode, Section,
                                  Subsection, Block, Lot, Sublot, Suffix]);

    SchoolCode := CurrentParcelTable.FieldByName('SchoolCode').Text;
    SwisCode := Copy(SwisSBLKey, 1, 6);

    If ((not Done) and
        FoundCurrent and
        ParcelIsActive(CurrentParcelTable) and
        (SelectedSwisCodes.IndexOf(SwisCode) > -1) and
        (SelectedSchoolCodes.IndexOf(SchoolCode) > -1))
      then
        begin
          ProgressDialog.Update(Self, ConvertSwisSBLToDashDot(SwisSBLKey));
          Application.ProcessMessages;

          FindKeyOld(CurrentAssessmentTable,
                     ['TaxRollYr', 'SwisSBLKey'],
                     [CurrentAssessmentYear, SwisSBLKey]);

            {FXX12011999-2: Filter out roll section 9.}

          CurrentActive := ((CurrentParcelTable.FieldByName('ActiveFlag').Text <> 'D') and
                            (CurrentParcelTable.FieldByName('RollSection').Text <> '9'));

          FoundPrior := FindKeyOld(PriorSDTable,
                                   ['TaxRollYr', 'SwisSBLKey', 'SDistCode'],
                                   [PriorAssessmentYear, SwisSBLKey, SDCode]);

          If (CurrentActive and
              (not FoundPrior))
            then
              begin
                CurrentSDValuesList := TStringList.Create;
                CurrentSDExtensionCodesList := TStringList.Create;
                CurrentSDCC_OMFlagsList := TStringList.Create;
                slCurrentAssessedValues := TStringList.Create;
                CurrentHomesteadCodesList := TStringlIst.Create;

                ParcelExemptionList := TList.Create;
                ExemptionCodeList := TList.Create;
                LoadExemptions(CurrentAssessmentYear, SwisSBLKey,
                               ParcelExemptionList, ExemptionCodeList,
                               CurrentParcelEXTable, CurrentEXCodeTable);

                CalculateSpecialDistrictAmounts(CurrentParcelTable,
                                                CurrentAssessmentTable,
                                                CurrentClassTable,
                                                CurrentSDTable,
                                                CurrentSDCodeTable,
                                                ParcelExemptionList,
                                                ExemptionCodeList,
                                                CurrentSDExtensionCodesList,  {Return lists}
                                                CurrentSDCC_OMFlagsList,
                                                slCurrentAssessedValues,
                                                CurrentSDValuesList,
                                                CurrentHomesteadCodesList);

                FreeTList(ParcelExemptionList, SizeOf(ParcelExemptionRecord));
                FreeTList(ExemptionCodeList, SizeOf(ExemptionCodeRecord));

                  {FXX03042005-1(2.8.3.10)[3072]: Make sure to catch all blank values so that they don't cause an exception.}

                For I := 0 to (CurrentSDValuesList.Count - 1) do
                  If _Compare(CurrentSDValuesList[I], coBlank)
                    then CurrentSDValuesList[I] := '0';

                with SortTable do
                  try
                    Insert;
                    FieldByName('SDCode').Text := SDCode;
                    FieldByName('SwisSBLKey').Text := SwisSBLKey;

                    For I := 0 to (CurrentSDExtensionCodesList.Count - 1) do
                      begin
                        SDExtensionType := SDExtType(CurrentSDExtensionCodesList[I]);

                        case SDExtensionType of
                          SDExtCatF,
                          SDExtCatA :  {AdValorum}
                            begin
                              FieldByName('ValuePrior').AsFloat := 0;
                              FieldByName('ValueCurrent').Text := CurrentSDValuesList[I];
                            end;

                          SDExtCatU : {Units}
                            begin
                              If (CurrentSDExtensionCodesList[I] = SDistECUn)
                                then
                                  begin
                                    FieldByName('UnitsPrior').AsFloat := 0;
                                    FieldByName('UnitsCurrent').Text := CurrentSDValuesList[I];
                                  end
                                else
                                  begin
                                    FieldByName('SecondUnitsPrior').AsFloat := 0;
                                    FieldByName('SecondUnitsCurrent').Text := CurrentSDValuesList[I];
                                  end;

                            end;  {SDExtCatU}

                          SDExtCatD :
                            begin
                              FieldByName('AcresPrior').AsFloat := 0;
                              FieldByName('AcresCurrent').Text := CurrentSDValuesList[I];
                            end;

                        end;  {case CurrentSDExtensionCodes[I] of}

                        FieldByName('ParcelExistsPrior').AsBoolean := False;
                        FieldByName('ParcelExistsCurrent').AsBoolean := True;

                      end;  {For I := 0 to (CurrentSDExtensionCodesList.Count - 1) do}

                    Post;
                  except
                    SystemSupport(001, SortTable, 'Error posting record ' + SwisSBLKey + ' in sort table.',
                                  UnitName, GlblErrorDlgBox);
                  end;

                  {Update totals}

                For I := 0 to (CurrentSDExtensionCodesList.Count - 1) do
                  begin
                    SDExtensionType := SDExtType(CurrentSDExtensionCodesList[I]);

                    case SDExtensionType of
                      SDExtCatF,
                      SDExtCatA :  {AdValorum}
                        CurrentTotalValue := CurrentTotalValue + StrToFloat(CurrentSDValuesList[I]);

                      SDExtCatU : {Units}
                        begin
                          If (CurrentSDExtensionCodesList[I] = SDistECUn)
                            then CurrentTotalUnits := CurrentTotalUnits + StrToFloat(CurrentSDValuesList[I])
                            else CurrentTotalSecondaryUnits := CurrentTotalSecondaryUnits +
                                                               StrToFloat(CurrentSDValuesList[I]);

                        end;  {SDExtCatU}

                      SDExtCatD :
                        CurrentTotalAcres := CurrentTotalAcres + StrToFloat(CurrentSDValuesList[I]);

                    end;  {case CurrentSDExtensionCodes[I] of}

                  end;  {For I := 0 to (CurrentSDExtensionCodesList.Count - 1) do}

                CurrentSDValuesList.Free;
                CurrentSDExtensionCodesList.Free;
                CurrentSDCC_OMFlagsList.Free;
                slCurrentAssessedValues.Free;

                CurrentNumParcels := CurrentNumParcels + 1;

              end;  {If (CurrentActive and ...}

        end;  {If not Done}

    ReportCancelled := ProgressDialog.Cancelled;

  until (Done or ReportCancelled);

  CurrentSDTable.Filtered := False;

end;  {FillSortFile_OneSpecialDistrict}

{===================================================================}
Procedure TCompareSpecialDistrictsForm.FillSortFile;

var
  I : Integer;

begin
  I := 0;

  while ((I <= (SelectedSpecialDistricts.Count - 1)) and
         (not ReportCancelled)) do
    begin
      FillSortFile_OneSpecialDistrict(SelectedSpecialDistricts[I]);
      I := I + 1;
    end;

end;  {FillSortFile}

{==============================================================}
Procedure TCompareSpecialDistrictsForm.PrintButtonClick(Sender: TObject);

var
  I, CurrentProcessingType, PriorProcessingType : Integer;
  NewFileName, SortFileName, SpreadsheetFileName : String;
  Quit, bContinue : Boolean;

begin
  SetPrintToScreenDefault(PrintDialog);
  ExtractToExcel := ExtractToExcelCheckBox.Checked;
  FirstYearDataSource := cb_FirstYear.Text;
  SecondYearDataSource := cb_SecondYear.Text;
  CurrentProcessingType := NextYear;
  PriorProcessingType := ThisYear;

  case rg_FirstAssessmentYear.ItemIndex of
    ayNextYear : PriorProcessingType := NextYear;
    ayThisYear : PriorProcessingType := ThisYear;
    ayHistory : PriorProcessingType := History;

  end;  {case rg_FirstAssessmentYear.ItemIndex of}

  case rg_SecondAssessmentYear.ItemIndex of
    ayNextYear : CurrentProcessingType := NextYear;
    ayThisYear : CurrentProcessingType := ThisYear;
    ayHistory : CurrentProcessingType := History;

  end;  {case rg_SecondAssessmentYear.ItemIndex of}

  bContinue := True;
  case rg_FirstAssessmentYear.ItemIndex of
    ayHistory :
      begin
        PriorAssessmentYear := ed_FirstHistoryYear.Text;

          {FXX05272009-1(2.20.1.1)[D1052]: Make sure that they fill in a history year.}

        If _Compare(PriorAssessmentYear, coBlank)
          then
            begin
              bContinue := False;
              MessageDlg('Please enter the prior history assessment year.', mtError, [mbOK], 0);
              ed_FirstHistoryYear.SetFocus;
            end;

      end;

  end;  {case rg_FirstAssessmentYear.ItemIndex of}

  case rg_SecondAssessmentYear.ItemIndex of
    ayHistory :
      begin
        CurrentAssessmentYear := ed_SecondHistoryYear.Text;

          {FXX05272009-1(2.20.1.1)[D1052]: Make sure that they fill in a history year.}

        If _Compare(CurrentAssessmentYear, coBlank)
          then
            begin
              bContinue := False;
              MessageDlg('Please enter the current history assessment year.', mtError, [mbOK], 0);
              ed_SecondHistoryYear.SetFocus;
            end;

      end;

  end;  {case rg_SecondAssessmentYear.ItemIndex of}

  If (bContinue and
      PrintDialog.Execute)
    then
      begin
        AssignPrinterSettings(PrintDialog, ReportPrinter, ReportFiler, [ptBoth], False, Quit);

           {Range information}

        SelectedSpecialDistricts := TStringList.Create;

        For I := 0 to (SpecialDistrictListBox.Items.Count - 1) do
          If SpecialDistrictListBox.Selected[I]
            then SelectedSpecialDistricts.Add(Take(5, SpecialDistrictListBox.Items[I]));

       SelectedSchoolCodes.Clear;

        For I := 0 to (SchoolCodeListBox.Items.Count - 1) do
          If SchoolCodeListBox.Selected[I]
            then SelectedSchoolCodes.Add(Take(6, SchoolCodeListBox.Items[I]));

        SelectedSwisCodes.Clear;

        For I := 0 to (SwisCodeListBox.Items.Count - 1) do
          If SwisCodeListBox.Selected[I]
            then SelectedSwisCodes.Add(Take(6, SwisCodeListBox.Items[I]));

        ReportCancelled := False;
        CreateParcelList := CreateParcelListCheckBox.Checked;

        If CreateParcelList
          then ParcelListDialog.ClearParcelGrid(True);

          {Now print the report and do the EX broadcast.}

        GlblPreviewPrint := False;

        CopyAndOpenSortFile(SortTable, 'CompareSD', OrigSortFileName,
                            SortFileName, True, True, Quit);

        If _Compare(FirstYearDataSource, coBlank)
          then FirstYearDataSource := 'PASsystem';
        If _Compare(SecondYearDataSource, coBlank)
          then SecondYearDataSource := 'PASsystem';

        _OpenTable(PriorAssessmentTable, AssessmentTableName, FirstYearDataSource,
                   '', PriorProcessingType, []);
        _OpenTable(PriorClassTable, ClassTableName, FirstYearDataSource,
                   '', PriorProcessingType, []);
        _OpenTable(PriorParcelTable, ParcelTableName, FirstYearDataSource,
                   '', PriorProcessingType, []);
        _OpenTable(PriorParcelEXTable, ExemptionsTableName, FirstYearDataSource,
                   '', PriorProcessingType, []);
        _OpenTable(PriorEXCodeTable, ExemptionCodesTableName, FirstYearDataSource,
                   '', PriorProcessingType, []);
        _OpenTable(PriorSDCodeTable, SDistCodeTableName, FirstYearDataSource,
                   '', PriorProcessingType, []);
        _OpenTable(PriorSDTable, SpecialDistrictTableName, FirstYearDataSource,
                   '', PriorProcessingType, []);

        _OpenTable(CurrentAssessmentTable, AssessmentTableName, SecondYearDataSource,
                   '', CurrentProcessingType, []);
        _OpenTable(CurrentClassTable, ClassTableName, SecondYearDataSource,
                   '', CurrentProcessingType, []);
        _OpenTable(CurrentParcelTable, ParcelTableName, SecondYearDataSource,
                   '', CurrentProcessingType, []);
        _OpenTable(CurrentParcelEXTable, ExemptionsTableName, SecondYearDataSource,
                   '', CurrentProcessingType, []);
        _OpenTable(CurrentEXCodeTable, ExemptionCodesTableName, SecondYearDataSource,
                   '', CurrentProcessingType, []);
        _OpenTable(CurrentSDCodeTable, SDistCodeTableName, SecondYearDataSource,
                   '', CurrentProcessingType, []);
        _OpenTable(CurrentSDTable, SpecialDistrictTableName, SecondYearDataSource,
                   '', CurrentProcessingType, []);

        case rg_FirstAssessmentYear.ItemIndex of
          ayNextYear,
          ayThisYear : PriorAssessmentYear := PriorParcelTable.FieldByName('TaxRollYr').AsString;

        end;  {case rg_FirstAssessmentYear.ItemIndex of}

        case rg_SecondAssessmentYear.ItemIndex of
          ayNextYear,
          ayThisYear : CurrentAssessmentYear := CurrentParcelTable.FieldByName('TaxRollYr').AsString;

        end;  {case rg_SecondAssessmentYear.ItemIndex of}

        ProgressDialog.Start(GetRecordCount(PriorSDTable) + GetRecordCount(CurrentSDTable),
                             True, True);

        FillSortFile;

        If ExtractToExcel
          then
            begin
              SpreadsheetFileName := GetPrintFileName('SD', True);
              AssignFile(ExtractFile, SpreadsheetFileName);
              Rewrite(ExtractFile);

              WritelnCommaDelimitedLine(ExtractFile,
                                        ['Parcel ID',
                                         'SD Code',
                                         'Year',
                                         'Prior Value',
                                         'Current Value',
                                         'Value Difference',
                                         'Prior Units',
                                         'Current Units',
                                         'Units Difference',
                                         'Prior 2nd Units',
                                         'Current 2nd Units',
                                         '2nd Units Difference',
                                         'Current Acres',
                                         'Prior Acres',
                                         'Acres Difference']);

            end;  {If ExtractToExcel}

        If not ReportCancelled
          then
            begin
              ProgressDialog.StartPrinting(PrintDialog.PrintToFile);

              ProgressDialog.Finish;

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

              ProgressDialog.Finish;

              If ExtractToExcel
                then
                  begin
                    CloseFile(ExtractFile);
                    SendTextFileToExcelSpreadsheet(SpreadsheetFileName, True,
                                                   False, '');

                  end;  {If PrintToExcel}

            end;  {If not ReportCancelled}

        SelectedSpecialDistricts.Free;

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

        If CreateParcelList
          then ParcelListDialog.Show;
        ResetPrinter(ReportPrinter);

      end;  {If PrintDialog.Execute}

end;  {StartButtonClick}

{==============================================================}
Procedure TCompareSpecialDistrictsForm.ReportPrintHeader(Sender: TObject);

begin
  with Sender as TBaseReport do
    begin
      SectionTop := 0.25;
      SectionLeft := 0.5;
      SectionRight := PageWidth - 0.5;
      SetFont('Times New Roman',8);
      PrintHeader('Page: ' + IntToStr(CurrentPage), pjRight);
      PrintHeader('Date: ' + DateToStr(Date) + '  Time: ' + TimeToStr(Now), pjLeft);

      SectionTop := 0.5;

      ClearTabs;
      SetTab(0.3, pjLeft, 8.0, 0, BoxLineNone, 0);

      SetFont('Times New Roman',14);
      Bold := True;
      Home;
      Println('');
      PrintCenter('Special District Comparison Report', (PageWidth / 2));
      Println('');

      SetFont('Times New Roman', 12);
      ClearTabs;
      SetTab(0.3, pjCenter, 2.0, 5, BoxLineAll, 25);   {Parcel ID}
      SetTab(2.3, pjCenter, 0.7, 5, BoxLineAll, 25);   {SDCode}
      SetTab(3.0, pjCenter, 0.5, 5, BoxLineAll, 25);   {Year}
      SetTab(3.5, pjCenter, 1.7, 5, BoxLineAll, 25);   {Value}
      SetTab(5.2, pjCenter, 0.8, 5, BoxLineAll, 25);   {Units}
      SetTab(6.0, pjCenter, 0.8, 5, BoxLineAll, 25);   {2nd Units}
      SetTab(6.8, pjCenter, 0.8, 5, BoxLineAll, 25);   {Acres}

      Println('');
      Bold := True;
      Println(#9 + 'Parcel ID' +
              #9 + 'SD' +
              #9 + 'Year' +
              #9 + 'Value' +
              #9 + 'Units' +
              #9 + '2nd Units' +
              #9 + 'Acres');

      Bold := False;

     end;  {with Sender as TBaseReport do}

end;  {ReportPrintHeader}

{==============================================================}
Procedure SetHeadersForFirstParcelLine(Sender : TObject);

begin
  with Sender as TBaseReport do
    begin
      ClearTabs;
      SetTab(0.3, pjLeft, 2.0, 5, BoxLineAll, 0);   {Parcel ID}
      SetTab(2.3, pjLeft, 0.7, 5, BoxLineAll, 0);   {SDCode}
      SetTab(3.0, pjLeft, 0.5, 5, BoxLineAll, 0);   {Year}
      SetTab(3.5, pjRight, 1.7, 5, BoxLineAll, 0);   {Value}
      SetTab(5.2, pjRight, 0.8, 5, BoxLineAll, 0);   {Units}
      SetTab(6.0, pjRight, 0.8, 5, BoxLineAll, 0);   {2nd Units}
      SetTab(6.8, pjRight, 0.8, 5, BoxLineAll, 0);   {Acres}

    end;  {with Sender as TBaseReport do}

end;  {SetHeadersForFirstParcelLine}

{==============================================================}
Procedure SetHeadersForOtherParcelLines(Sender : TObject);

begin
  with Sender as TBaseReport do
    begin
      ClearTabs;
      SetTab(3.0, pjLeft, 0.5, 5, BoxLineAll, 0);   {Year}
      SetTab(3.5, pjRight, 1.7, 5, BoxLineAll, 0);   {Value}
      SetTab(5.2, pjRight, 0.8, 5, BoxLineAll, 0);   {Units}
      SetTab(6.0, pjRight, 0.8, 5, BoxLineAll, 0);   {2nd Units}
      SetTab(6.8, pjRight, 0.8, 5, BoxLineAll, 0);   {Acres}

    end;  {with Sender as TBaseReport do}

end;  {SetHeadersForOtherParcelLines}

{==============================================================}
Procedure TCompareSpecialDistrictsForm.ReportPrint(Sender: TObject);

var
  Done, FirstTimeThrough : Boolean;
  SwisSBLKey : String;

begin
  FirstTimeThrough := True;
  Done := False;
  ProgressDialog.Reset;
  ProgressDialog.TotalNumRecords := GetRecordCount(SortTable);
  ProgressDialog.UserLabelCaption := 'Printing Differences';

  SortTable.First;

  with Sender as TBaseReport do
    repeat
      If FirstTimeThrough
        then FirstTimeThrough := False
        else SortTable.Next;

      If SortTable.EOF
        then Done := True;

      If not Done
        then
          begin
            SwisSBLKey := SortTable.FieldByName('SwisSBLKey').Text;

            If CreateParcelList
              then ParcelListDialog.AddOneParcel(SwisSBLKey);

            ProgressDialog.Update(Self, ConvertSwisSBLToDashDot(SwisSBLKey));
            Application.ProcessMessages;

            If (LinesLeft < 8)
              then NewPage;

            with SortTable do
              begin
                SetHeadersForFirstParcelLine(Sender);
                Bold := True;
                Print(#9 + ConvertSwisSBLToDashDot(SwisSBLKey));
                Bold := False;

                Print(#9 + FieldByName('SDCode').Text +
                      #9 + PriorAssessmentYear);

                If FieldByName('ParcelExistsPrior').AsBoolean
                  then Println(#9 + FormatFloat(DecimalDisplay_BlankZero, FieldByName('ValuePrior').AsFloat) +
                               #9 + FormatFloat(DecimalDisplay_BlankZero, FieldByName('UnitsPrior').AsFloat) +
                               #9 + FormatFloat(DecimalDisplay_BlankZero, FieldByName('SecondUnitsPrior').AsFloat) +
                               #9 + FormatFloat(DecimalDisplay_BlankZero, FieldByName('AcresPrior').AsFloat))
                  else Println(#9 + 'Does not exist');

                SetHeadersForOtherParcelLines(Sender);
                Print(#9 + CurrentAssessmentYear);

                If FieldByName('ParcelExistsCurrent').AsBoolean
                  then Println(#9 + FormatFloat(DecimalDisplay_BlankZero, FieldByName('ValueCurrent').AsFloat) +
                               #9 + FormatFloat(DecimalDisplay_BlankZero, FieldByName('UnitsCurrent').AsFloat) +
                               #9 + FormatFloat(DecimalDisplay_BlankZero, FieldByName('SecondUnitsCurrent').AsFloat) +
                               #9 + FormatFloat(DecimalDisplay_BlankZero, FieldByName('AcresCurrent').AsFloat))
                  else Println(#9 + 'Does not exist');

                  {CHG03102005-1(2.8.3.11): Add a totals line.}

                Bold := True;
                Println(#9 + 'Diff' +
                        #9 + FormatFloat(DecimalDisplay_BlankZero,
                                         (FieldByName('ValuePrior').AsFloat -
                                          FieldByName('ValueCurrent').AsFloat)) +
                        #9 + FormatFloat(DecimalDisplay_BlankZero,
                                         (FieldByName('UnitsPrior').AsFloat -
                                          FieldByName('UnitsCurrent').AsFloat)) +
                        #9 + FormatFloat(DecimalDisplay_BlankZero,
                                         (FieldByName('SecondUnitsPrior').AsFloat -
                                          FieldByName('SecondUnitsCurrent').AsFloat)) +
                        #9 + FormatFloat(DecimalDisplay_BlankZero,
                                         (FieldByName('AcresPrior').AsFloat -
                                          FieldByName('AcresCurrent').AsFloat)));
                Bold := False;

                If ExtractToExcel
                  then WritelnCommaDelimitedLine(ExtractFile,
                                                 [ConvertSwisSBLToDashDot(SwisSBLKey),
                                                  FieldByName('SDCode').Text,
                                                  PriorAssessmentYear + '/' + CurrentAssessmentYear,
                                                  FieldByName('ValuePrior').AsInteger,
                                                  FieldByName('ValueCurrent').AsInteger,
                                                  (FieldByName('ValueCurrent').AsInteger -
                                                   FieldByName('ValuePrior').AsInteger),
                                                  FieldByName('UnitsPrior').AsInteger,
                                                  FieldByName('UnitsCurrent').AsInteger,
                                                  (FieldByName('UnitsCurrent').AsInteger -
                                                   FieldByName('UnitsPrior').AsInteger),
                                                  FieldByName('SecondUnitsPrior').AsInteger,
                                                  FieldByName('SecondUnitsCurrent').AsInteger,
                                                  (FieldByName('SecondUnitsCurrent').AsInteger -
                                                   FieldByName('SecondUnitsPrior').AsInteger),
                                                  FieldByName('AcresPrior').AsInteger,
                                                  FieldByName('AcresCurrent').AsInteger,
                                                  (FieldByName('AcresCurrent').AsInteger -
                                                   FieldByName('AcresPrior').AsInteger)]);

              end;  {with SortTable do}

            Println('');

          end;  {If not Done}

    until Done;

    {Totals}

  with Sender as TBaseReport do
    begin
      SetHeadersForFirstParcelLine(Sender);
      Bold := True;
      Print(#9 + 'Total (' + IntToStr(PriorNumParcels) + ')');
      Bold := False;

      Println(#9 + SortTable.FieldByName('SDCode').Text +
              #9 + PriorAssessmentYear +
              #9 + FormatFloat(DecimalDisplay_BlankZero, PriorTotalValue) +
              #9 + FormatFloat(DecimalDisplay_BlankZero, PriorTotalUnits) +
              #9 + FormatFloat(DecimalDisplay_BlankZero, PriorTotalSecondaryUnits) +
              #9 + FormatFloat(DecimalDisplay_BlankZero, PriorTotalAcres));

      Bold := True;
      Print(#9 + 'Total (' + IntToStr(CurrentNumParcels) + ')');
      Bold := False;

      Println(#9 +
              #9 + CurrentAssessmentYear +
              #9 + FormatFloat(DecimalDisplay_BlankZero, CurrentTotalValue) +
              #9 + FormatFloat(DecimalDisplay_BlankZero, CurrentTotalUnits) +
              #9 + FormatFloat(DecimalDisplay_BlankZero, CurrentTotalSecondaryUnits) +
              #9 + FormatFloat(DecimalDisplay_BlankZero, CurrentTotalAcres));

      SetHeadersForOtherParcelLines(Sender);
      Bold := True;
      Println(#9 + 'Diff' +
              #9 + FormatFloat(DecimalDisplay_BlankZero,
                               (PriorTotalValue - CurrentTotalValue)) +
              #9 + FormatFloat(DecimalDisplay_BlankZero,
                               (PriorTotalUnits - CurrentTotalUnits)) +
              #9 + FormatFloat(DecimalDisplay_BlankZero,
                               (PriorTotalSecondaryUnits - CurrentTotalSecondaryUnits)) +
              #9 + FormatFloat(DecimalDisplay_BlankZero,
                               (PriorTotalAcres - CurrentTotalAcres)));

    end;  {with Sender as TBaseReport do}

end;  {ReportPrint}

{===================================================================}
Procedure TCompareSpecialDistrictsForm.FormClose(    Sender: TObject;
                                  var Action: TCloseAction);

begin
  SelectedSchoolCodes.Free;
  SelectedSwisCodes.Free;
  CloseTablesForForm(Self);

    {Free up the child window and set the ClosingAForm Boolean to
     true so that we know to delete the tab.}

  Action := caFree;
  GlblClosingAForm := True;
  GlblClosingFormCaption := Caption;

end;  {FormClose}

end.
