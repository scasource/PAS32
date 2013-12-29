unit ROverallBalance;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, DBCtrls, DBTables, DB, Buttons, Grids,
  Wwdbigrd, Wwdbgrid, ExtCtrls, Wwtable, Wwdatsrc, Menus, wwdblook,
  TabNotBk, Types, RPFiler, RPDefine, RPBase, RPCanvas, RPrinter, Progress,
  RPTXFilr, ComCtrls;

type
  Tfm_OverallBalancing = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    ScrollBox1: TScrollBox;
    TitleLabel: TLabel;
    dlg_Print: TPrintDialog;
    ReportPrinter: TReportPrinter;
    ReportFiler: TReportFiler;
    tb_Roll1SpecialDistrict: TTable;
    tb_Roll1SpecialDistrictCode: TTable;
    Label11: TLabel;
    Label12: TLabel;
    tb_Roll2SpecialDistrict: TTable;
    tb_Roll1ExemptionCode: TTable;
    tb_Roll2ExemptionCode: TTable;
    tb_Roll1ParcelExemption: TTable;
    tb_Roll2ParcelExemption: TTable;
    tb_Roll2SpecialDistrictCode: TTable;
    tb_Roll2Assessment: TTable;
    tb_Roll1Assessment: TTable;
    tb_Sort: TTable;
    tb_Roll1Parcel: TTable;
    tb_Roll2Parcel: TTable;
    tb_SchoolCode: TTable;
    tb_SwisCode: TTable;
    tb_Roll2Class: TTable;
    tb_Roll1Class: TTable;
    Panel3: TPanel;
    btn_Print: TBitBtn;
    btn_Close: TBitBtn;
    pc_Main: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Label10: TLabel;
    Label21: TLabel;
    lb_SwisCode: TListBox;
    lb_SchoolCode: TListBox;
    rg_Roll1AssessmentYear: TRadioGroup;
    ed_Roll1HistoryYear: TEdit;
    rg_Roll2AssessmentYear: TRadioGroup;
    ed_Roll2HistoryYear: TEdit;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    cb_Roll1Year: TComboBox;
    cb_Roll2Year: TComboBox;
    gb_MiscellaneousOptions: TGroupBox;
    cb_CreateParcelList: TCheckBox;
    cb_ExtractToExcel: TCheckBox;
    tb_SortExemption: TTable;
    tb_SortSpecialDistrict: TTable;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure rg_AssessmentYearClick(Sender: TObject);
    procedure btn_PrintClick(Sender: TObject);
    procedure ReportPrintHeader(Sender: TObject);
    procedure ReportPrint(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    UnitName : String;

    Roll1AssessmentYear, Roll2AssessmentYear : String;
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

    OrigSortFileName, OrigSortExemptionFileName,
    OrigSortSpecialDistrictFileName,
    Roll1DataSource, Roll2DataSource : String;

    SelectedSchoolCodes, SelectedSwisCodes : TStringList;
    ExtractToExcel : Boolean;
    ExtractFile : TextFile;

    Procedure InitializeForm;  {Open the tables and setup.}

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
Procedure Tfm_OverallBalancing.FormActivate(Sender: TObject);

begin
  SetFormStateMaximized(Self);
end;

{========================================================}
Procedure Tfm_OverallBalancing.FillListBoxes(AssessmentYear : String);

{Fill in all the list boxes on the various notebook pages.}

var
  ProcessingType : Integer;
  Quit : Boolean;

begin
  ProcessingType := GetProcessingTypeForTaxRollYear(AssessmentYear);

  OpenTableForProcessingType(tb_SchoolCode, SchoolCodeTableName,
                             ProcessingType, Quit);

  OpenTableForProcessingType(tb_SwisCode, SwisCodeTableName,
                             ProcessingType, Quit);

  FillOneListBox(lb_SwisCode, tb_SwisCode, 'SwisCode',
                 'MunicipalityName', 25, True, True, ProcessingType, AssessmentYear);

  FillOneListBox(lb_SchoolCode, tb_SchoolCode, 'SchoolCode',
                 'SchoolName', 25, True, True, ProcessingType, AssessmentYear);

end;  {FillListBoxes}

{========================================================}
Procedure Tfm_OverallBalancing.InitializeForm;

var
  DatabaseList : TStringList;
  I : Integer;

begin
  UnitName := 'ROverallBalance';
  FillListBoxes(GlblThisYear);
  OrigSortFileName := tb_Sort.TableName;
  OrigSortExemptionFileName := tb_SortExemption.TableName;
  OrigSortSpecialDistrictFileName := tb_SortSpecialDistrict.TableName;

  SelectedSwisCodes := TStringList.Create;
  SelectedSchoolCodes := TStringList.Create;

  DatabaseList := TStringList.Create;
  Session.GetDatabaseNames(DatabaseList);

  For I := 0 to (DatabaseList.Count - 1) do
    If ((Pos('PROPERTYASSESSMENTSYSTEM', ANSIUpperCase(DatabaseList[I])) > 0) or
        (Pos('PAS', ANSIUpperCase(DatabaseList[I])) = 1))
      then
        begin
          cb_Roll1Year.Items.Add(DatabaseList[I]);
          cb_Roll2Year.Items.Add(DatabaseList[I]);
        end;

  DatabaseList.Free;

end;  {InitializeForm}

{===================================================================}
Procedure Tfm_OverallBalancing.FormKeyPress(    Sender: TObject;
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
Procedure Tfm_OverallBalancing.rg_AssessmentYearClick(Sender: TObject);

var
  ed_HistoryYear : TEdit;
  rg_AssessmentYear : TRadioGroup;

begin
  If _Compare(TWinControl(Sender).Name, 'rg_Roll1AssessmentYear', coEqual)
    then
      begin
        ed_HistoryYear := ed_Roll1HistoryYear;
        rg_AssessmentYear := rg_Roll1AssessmentYear;
      end
    else
      begin
        ed_HistoryYear := ed_Roll2HistoryYear;
        rg_AssessmentYear := rg_Roll2AssessmentYear;
      end;

  ed_HistoryYear.Visible := False;

  If _Compare(rg_AssessmentYear.ItemIndex, ayHistory, coEqual)
    then
      begin
        ed_HistoryYear.Visible := True;
        ed_HistoryYear.SetFocus;
      end;

end;  {rg_AssessmentYearClick}

{===================================================================}
Function ParcelMeetsCriteria(tb_Parcel : TTable;
                             SelectedSwisCodes : TStringList;
                             SelectedSchoolCodes : TStringList) : Boolean;

begin
  with tb_Parcel do
    Result := _Compare(FieldByName('RollSection').AsString, '9', coNotEqual) and
              _Compare(SelectedSwisCodes.IndexOf(FieldByName('SwisCode').AsString), -1, coGreaterThan) and
              _Compare(SelectedSchoolCodes.IndexOf(FieldByName('SchoolCode').AsString), -1, coGreaterThan) and
              ParcelIsActive(tb_Parcel);

end;  {ParcelMeetsCriteria}

{===================================================================}
Procedure UpdateSortRecord_Exemption(tb_SortExemption : TTable;
                                     AssessmentYear : String;
                                     RollType : String;
                                     SwisSBLKey : String;
                                     Parcel_ID : LongInt;
                                     tb_ParcelExemption : TTable);

var
  FieldName : String;

begin
  _SetRange(tb_ParcelExemption, [AssessmentYear, SwisSBLKey], [], '', [loSameEndingRange]);

  with tb_ParcelExemption do
    begin
      First;

      while not EOF do
        begin
          If not _Locate(tb_SortExemption, [Parcel_ID, FieldByName('ExemptionCode').AsString], '', [])
            then
              try
                tb_SortExemption.Insert;
                InitializeFieldsForRecord(tb_SortExemption);
                tb_SortExemption.FieldByName('Parcel_ID').AsInteger := Parcel_ID;
                tb_SortExemption.FieldByName('ExemptionCode').AsString := FieldByName('ExemptionCode').AsString;
                tb_SortExemption.Post;
              except
              end;

          try
            tb_SortExemption.Edit;
            FieldName := 'ExistsRoll' + RollType;
            FieldByName(FieldName).AsBoolean := True;

            FieldName := 'Roll' + RollType + 'CountyAmount';
            tb_SortExemption.FieldByName(FieldName).AsInteger := FieldByName('CountyAmount').AsInteger;

            FieldName := 'Roll' + RollType + 'MunicipalAmount';
            tb_SortExemption.FieldByName(FieldName).AsInteger := FieldByName('TownAmount').AsInteger;

            If ExemptionIsSTAR(FieldByName('ExemptionCode').AsString)
              then
                begin
                  FieldName := 'Roll' + RollType + 'STARAmount';
                  tb_SortExemption.FieldByName(FieldName).AsInteger := FieldByName('STARAmount').AsInteger;
                end
              else
                begin
                  FieldName := 'Roll' + RollType + 'SchoolAmount';
                  tb_SortExemption.FieldByName(FieldName).AsInteger := FieldByName('SchoolAmount').AsInteger;
                end;

            FieldName := 'Roll' + RollType + 'VillageAmount';
            tb_SortExemption.FieldByName(FieldName).AsInteger := FieldByName('VillageAmount').AsInteger;

            tb_SortExemption.Post;
          except
          end;

          Next;

        end;  {while not EOF do}

    end;  {with tb_ParcelExemption do}

end;  {UpdateSortRecord_Exemption}

{===================================================================}
Procedure UpdateSortRecord_SpecialDistrict(tb_SortSpecialDistrict : TTable;
                                           AssessmentYear : String;
                                           RollType : String;
                                           SwisSBLKey : String;
                                           Parcel_ID : LongInt;
                                           tb_ParcelSpecialDistrict : TTable;
                                           tb_SpecialDistrictCode : TTable;
                                           tb_Parcel : TTable;
                                           tb_Assessment : TTable;
                                           tb_ParcelExemption : TTable;
                                           tb_ExemptionCode : TTable);

var
  SDExtensionType : Char;
  FieldName : String;
  SDAmountList : TList;
  I, J, AdValorumValue : LongInt;
  Units, SecondaryUnits, Acres : Double;

begin
  SDAmountList := TList.Create;

  TotalSpecialDistrictsForParcel(AssessmentYear, SwisSBLKey,
                                 tb_Parcel, tb_Assessment,
                                 tb_ParcelSpecialDistrict, tb_SpecialDistrictCode,
                                 tb_ParcelExemption, tb_ExemptionCode, SDAmountList);

  For I := 0 to (SDAmountList.Count - 1) do
    with tb_SortSpecialDistrict, PParcelSDValuesRecord(SDAmountList[I])^ do
      begin
        If not _Locate(tb_SortSpecialDistrict, [Parcel_ID, SDCode], '', [])
          then
            try
              Insert;
              InitializeFieldsForRecord(tb_SortSpecialDistrict);
              FieldByName('Parcel_ID').AsInteger := Parcel_ID;
              FieldByName('SpecialDistrictCode').AsString := SDCode;
              Post;
            except
            end;

        AdValorumValue := 0;
        Units := 0;
        SecondaryUnits := 0;
        Acres := 0;

        For J := 1 to 10 do
          If _Compare(SDExtensionCodes[J], coNotBlank)
            then
              begin
                SDExtensionType := SDExtType(SDExtensionCodes[J]);

                case SDExtensionType of
                  SDExtCatF,
                  SDExtCatA :  {AdValorum}
                    try
                      AdValorumValue := StrToInt(SDValues[J]);
                    except
                    end;

                  SDExtCatU : {Units}
                    If _Compare(SDExtensionCodes[J], SDistECUn, coEqual)
                      then
                        begin
                          try
                            Units := StrToFloat(SDValues[J]);
                          except
                          end;

                        end
                      else
                        begin
                          try
                            SecondaryUnits := StrToFloat(SDValues[J]);
                          except
                          end;

                        end;

                  SDExtCatD :
                    try
                      Acres := StrToFloat(SDValues[J]);
                    except
                    end;

                end;  {case CurrentSDExtensionCodes[I] of}

              end;  {If _Compare(SDExtensionCodes[J], coNotBlank)}

        try
          Edit;
          FieldName := 'ExistsRoll' + RollType;
          FieldByName(FieldName).AsBoolean := True;

          FieldName := 'Roll' + RollType + 'Value';
          tb_SortSpecialDistrict.FieldByName(FieldName).AsInteger := AdValorumValue;

          FieldName := 'Roll' + RollType + 'Units';
          tb_SortSpecialDistrict.FieldByName(FieldName).AsFloat := Units;

          FieldName := 'Roll' + RollType + 'SecondaryUnits';
          tb_SortSpecialDistrict.FieldByName(FieldName).AsFloat := SecondaryUnits;

          FieldName := 'Roll' + RollType + 'Acres';
          tb_SortSpecialDistrict.FieldByName(FieldName).AsFloat := Acres;

          tb_SortSpecialDistrict.Post;
        except
        end;

      end;  {with tb_SortSpecialDistrict, PParcelSDValuesRecord(SDAmountList[I])^ do}

end;  {UpdateSortRecord_SpecialDistrict}

{===================================================================}
Procedure UpdateSortRecord(tb_Sort : TTable;
                           tb_SortExemption : TTable;
                           tb_SortSpecialDistrict : TTable;
                           AssessmentYear : String;
                           RollType : String;  {'1' or '2'}
                           tb_Parcel : TTable;
                           tb_Assessment : TTable;
                           tb_Class : TTable;
                           tb_ParcelExemption : TTable;
                           tb_ExemptionCode : TTable;
                           tb_ParcelSpecialDistrict : TTable;
                           tb_SpecialDistrictCode : TTable);

var
  SwisSBLKey, FieldName : String;
  Parcel_ID, LandValue, TotalValue : LongInt;

begin
  SwisSBLKey := ExtractSSKey(tb_Parcel);

  with tb_Sort do
    begin
      If not _Locate(tb_Sort, [Copy(SwisSBLKey, 1, 6), Copy(SwisSBLKey, 7, 20)], '', [])
        then
          try
            Insert;
            InitializeFieldsForRecord(tb_Sort);
            FieldByName('SwisCode').AsString := tb_Parcel.FieldByName('SwisCode').AsString;
            FieldByName('SchoolCode').AsString := tb_Parcel.FieldByName('SchoolCode').AsString;
            FieldByName('SBL').AsString := Copy(SwisSBLKey, 7, 20);
            FieldByName('AccountNumber').AsString := tb_Parcel.FieldByName('AccountNo').AsString;
            FieldByName('Name1').AsString := tb_Parcel.FieldByName('Name1').AsString;
            Post;
          except
          end;

      Parcel_ID := FieldByName('Parcel_ID').AsInteger;

         {Get the assessed value.}

      LandValue := 0;
      TotalValue := 0;

      If _Locate(tb_Assessment, [AssessmentYear, SwisSBLKey], '', [])
        then
          begin
            LandValue := tb_Assessment.FieldByName('LandAssessedVal').AsInteger;
            TotalValue := tb_Assessment.FieldByName('TotalAssessedVal').AsInteger;
          end;

      try
        Edit;

        FieldName := 'ExistsRoll' + RollType;
        FieldByName(FieldName).AsBoolean := True;
        FieldName := 'Roll' + RollType + 'LandValue';
        FieldByName(FieldName).AsInteger := LandValue;
        FieldName := 'Roll' + RollType + 'TotalValue';
        FieldByName(FieldName).AsInteger := TotalValue;

        Post;
      except
      end;

    end;  {with tb_Sort do}

  UpdateSortRecord_Exemption(tb_SortExemption, AssessmentYear, RollType,
                             SwisSBLKey, Parcel_ID, tb_ParcelExemption);

  UpdateSortRecord_SpecialDistrict(tb_SortSpecialDistrict, AssessmentYear,
                                   RollType, SwisSBLKey, Parcel_ID,
                                   tb_ParcelSpecialDistrict, tb_SpecialDistrictCode,
                                   tb_Parcel, tb_Assessment,
                                   tb_ParcelExemption, tb_ExemptionCode);

end;  {UpdateSortRecord}

{===================================================================}
Procedure Tfm_OverallBalancing.FillSortFile;

begin
  with tb_Roll1Parcel do
    begin
      First;

      while (not (ReportCancelled or EOF)) do
        begin
          If ParcelMeetsCriteria(tb_Roll1Parcel,
                                 SelectedSwisCodes,
                                 SelectedSchoolCodes)
            then UpdateSortRecord(tb_Sort,
                                  tb_SortExemption,
                                  tb_SortSpecialDistrict,
                                  Roll1AssessmentYear,
                                  '1',
                                  tb_Roll1Parcel,
                                  tb_Roll1Assessment,
                                  tb_Roll1Class,
                                  tb_Roll1ParcelExemption,
                                  tb_Roll1ExemptionCode,
                                  tb_Roll1SpecialDistrict,
                                  tb_Roll1SpecialDistrictCode);

          Next;

        end;  {while (not (ReportCancelled or EOF)) do}

    end;  {with tb_Roll1Parcel do}

  with tb_Roll2Parcel do
    begin
      First;

      while (not (ReportCancelled or EOF)) do
        begin
          If ParcelMeetsCriteria(tb_Roll2Parcel,
                                 SelectedSwisCodes,
                                 SelectedSchoolCodes)
            then UpdateSortRecord(tb_Sort,
                                  tb_SortExemption,
                                  tb_SortSpecialDistrict,
                                  Roll2AssessmentYear,
                                  '2',
                                  tb_Roll2Parcel,
                                  tb_Roll2Assessment,
                                  tb_Roll2Class,
                                  tb_Roll2ParcelExemption,
                                  tb_Roll2ExemptionCode,
                                  tb_Roll2SpecialDistrict,
                                  tb_Roll2SpecialDistrictCode);

          Next;

        end;  {while (not (ReportCancelled or EOF)) do}

    end;  {with tb_Roll2Parcel do}

end;  {FillSortFile}

{==============================================================}
Procedure Tfm_OverallBalancing.btn_PrintClick(Sender: TObject);

var
  I, Roll2ProcessingType, Roll1ProcessingType : Integer;
  NewFileName, SortFileName,
  SortExemptionFileName, SortSpecialDistrictFileName, SpreadsheetFileName : String;
  Quit : Boolean;

begin
  SetPrintToScreenDefault(dlg_Print);
  ExtractToExcel := cb_ExtractToExcel.Checked;
  Roll1DataSource := cb_Roll1Year.Text;
  Roll2DataSource := cb_Roll2Year.Text;
  Roll2ProcessingType := NextYear;
  Roll1ProcessingType := ThisYear;

  case rg_Roll1AssessmentYear.ItemIndex of
    ayNextYear : Roll1ProcessingType := NextYear;
    ayThisYear : Roll1ProcessingType := ThisYear;
    ayHistory : Roll1ProcessingType := History;

  end;  {case rg_Roll1AssessmentYear.ItemIndex of}

  case rg_Roll2AssessmentYear.ItemIndex of
    ayNextYear : Roll2ProcessingType := NextYear;
    ayThisYear : Roll2ProcessingType := ThisYear;
    ayHistory : Roll2ProcessingType := History;

  end;  {case rg_Roll2AssessmentYear.ItemIndex of}

  If dlg_Print.Execute
    then
      begin
        AssignPrinterSettings(dlg_Print, ReportPrinter, ReportFiler, [ptBoth], False, Quit);

           {Range information}

       SelectedSchoolCodes.Clear;

        For I := 0 to (lb_SchoolCode.Items.Count - 1) do
          If lb_SchoolCode.Selected[I]
            then SelectedSchoolCodes.Add(Copy(lb_SchoolCode.Items[I], 1, 6));

        SelectedSwisCodes.Clear;

        For I := 0 to (lb_SwisCode.Items.Count - 1) do
          If lb_SwisCode.Selected[I]
            then SelectedSwisCodes.Add(Copy(lb_SwisCode.Items[I], 1, 6));

        ReportCancelled := False;
        CreateParcelList := cb_CreateParcelList.Checked;

        If CreateParcelList
          then ParcelListDialog.ClearParcelGrid(True);

          {Now print the report and do the EX broadcast.}

        GlblPreviewPrint := False;

        CopyAndOpenSortFile(tb_Sort, 'OverallBalance', OrigSortFileName,
                            SortFileName, True, True, Quit);
        CopyAndOpenSortFile(tb_SortExemption, 'OverallBalance_EX', OrigSortExemptionFileName,
                            SortExemptionFileName, True, True, Quit);
        CopyAndOpenSortFile(tb_SortSpecialDistrict, 'OverallBalance_SD', OrigSortSpecialDistrictFileName,
                            SortSpecialDistrictFileName, True, True, Quit);

        If _Compare(Roll1DataSource, coBlank)
          then Roll1DataSource := 'PASsystem';
        If _Compare(Roll2DataSource, coBlank)
          then Roll2DataSource := 'PASsystem';

        _OpenTable(tb_Roll1Assessment, AssessmentTableName, Roll1DataSource,
                   '', Roll1ProcessingType, []);
        _OpenTable(tb_Roll1Class, ClassTableName, Roll1DataSource,
                   '', Roll1ProcessingType, []);
        _OpenTable(tb_Roll1Parcel, ParcelTableName, Roll1DataSource,
                   '', Roll1ProcessingType, []);
        _OpenTable(tb_Roll1ParcelExemption, ExemptionsTableName, Roll1DataSource,
                   '', Roll1ProcessingType, []);
        _OpenTable(tb_Roll1ExemptionCode, ExemptionCodesTableName, Roll1DataSource,
                   '', Roll1ProcessingType, []);
        _OpenTable(tb_Roll1SpecialDistrictCode, SDistCodeTableName, Roll1DataSource,
                   '', Roll1ProcessingType, []);
        _OpenTable(tb_Roll1SpecialDistrict, SpecialDistrictTableName, Roll1DataSource,
                   '', Roll1ProcessingType, []);

        _OpenTable(tb_Roll2Assessment, AssessmentTableName, Roll2DataSource,
                   '', Roll2ProcessingType, []);
        _OpenTable(tb_Roll2Class, ClassTableName, Roll2DataSource,
                   '', Roll2ProcessingType, []);
        _OpenTable(tb_Roll2Parcel, ParcelTableName, Roll2DataSource,
                   '', Roll2ProcessingType, []);
        _OpenTable(tb_Roll2ParcelExemption, ExemptionsTableName, Roll2DataSource,
                   '', Roll2ProcessingType, []);
        _OpenTable(tb_Roll2ExemptionCode, ExemptionCodesTableName, Roll2DataSource,
                   '', Roll2ProcessingType, []);
        _OpenTable(tb_Roll2SpecialDistrictCode, SDistCodeTableName, Roll2DataSource,
                   '', Roll2ProcessingType, []);
        _OpenTable(tb_Roll2SpecialDistrict, SpecialDistrictTableName, Roll2DataSource,
                   '', Roll2ProcessingType, []);

        case rg_Roll1AssessmentYear.ItemIndex of
          ayNextYear,
          ayThisYear : Roll1AssessmentYear := tb_Roll1Parcel.FieldByName('TaxRollYr').AsString;
          ayHistory : Roll1AssessmentYear := ed_Roll1HistoryYear.Text;

        end;  {case rg_Roll1AssessmentYear.ItemIndex of}

        case rg_Roll2AssessmentYear.ItemIndex of
          ayNextYear,
          ayThisYear : Roll2AssessmentYear := tb_Roll2Parcel.FieldByName('TaxRollYr').AsString;
          ayHistory : Roll2AssessmentYear := ed_Roll2HistoryYear.Text;

        end;  {case rg_Roll2AssessmentYear.ItemIndex of}

        ProgressDialog.Start(GetRecordCount(tb_Roll1Parcel) + GetRecordCount(tb_Roll2Parcel),
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
                                         'Owner',
                                         'Account #',
                                         'Category',
                                         'Code',
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
              ProgressDialog.StartPrinting(dlg_Print.PrintToFile);

              ProgressDialog.Finish;

                {If they want to see it on the screen, start the preview.}

              If dlg_Print.PrintToFile
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

          {Make sure to close and delete the sort file.}

        tb_Sort.Close;
        tb_SortExemption.Close;
        tb_SortSpecialDistrict.Close;

          {Now delete the file.}
        try
          ChDir(GlblDataDir);
          OldDeleteFile(SortFileName);
          OldDeleteFile(SortExemptionFileName);
          OldDeleteFile(SortSpecialDistrictFileName);
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
Procedure Tfm_OverallBalancing.ReportPrintHeader(Sender: TObject);

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
      PrintCenter('Overall Balancing Report', (PageWidth / 2));
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
Procedure Tfm_OverallBalancing.ReportPrint(Sender: TObject);

(*var
  SwisSBLKey : String; *)

begin
  ProgressDialog.Reset;
  ProgressDialog.TotalNumRecords := GetRecordCount(tb_Sort);
  ProgressDialog.UserLabelCaption := 'Printing Differences';

  tb_Sort.First;

(*  with Sender as TBaseReport do
    repeat
      If FirstTimeThrough
        then FirstTimeThrough := False
        else SortTable.Next;

      If SortTable.EOF
        then Done := True;

      If not Done
        then
          begin

            If CreateParcelList
              then ParcelListDialog.AddOneParcel(SwisSBLKey);

            ProgressDialog.Update(Self, ConvertSwisSBLToDashDot(SwisSBLKey));
            Application.ProcessMessages;

            If (LinesLeft < 8)
              then NewPage;

            with tb_Sort do
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

    end;  {with Sender as TBaseReport do} *)

end;  {ReportPrint}

{===================================================================}
Procedure Tfm_OverallBalancing.FormClose(    Sender: TObject;
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
