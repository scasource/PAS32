unit RValueComparison;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, DBCtrls, DBTables, DB, Buttons, Grids,
  Wwdbigrd, Wwdbgrid, ExtCtrls, Wwtable, Wwdatsrc, Menus, wwdblook,
  TabNotBk, Types, RPFiler, RPDefine, RPBase, RPCanvas, RPrinter, Progress,
  RPTXFilr, ComCtrls, Math;

type
  TValueComparisonTypes = (vcAssessedValue, vcCountyTaxableValue,
                           vcMunicipalTaxableValue, vcSchoolTaxableValue);
  TValueComparisonType = set of TValueComparisonTypes;

  Tfm_ValueComparisonReport = class(TForm)
    Panel1: TPanel;
    TitleLabel: TLabel;
    PrintDialog: TPrintDialog;
    ReportPrinter: TReportPrinter;
    ReportFiler: TReportFiler;
    Label11: TLabel;
    Label12: TLabel;
    Panel2: TPanel;
    ScrollBox1: TScrollBox;
    PageControl1: TPageControl;
    OptionsTabSheet: TTabSheet;
    Swis_School_RS_TabSheet: TTabSheet;
    Label15: TLabel;
    Label9: TLabel;
    Label18: TLabel;
    lbx_RollSection: TListBox;
    lbx_SwisCode: TListBox;
    lbx_SchoolCode: TListBox;
    GroupBox1: TGroupBox;
    cb_CreateParcelList: TCheckBox;
    cb_ExtractToExcel: TCheckBox;
    tb_ParcelYear1: TTable;
    tb_ParcelYear2: TTable;
    ReportFiler1: TReportFiler;
    tb_SwisCode: TTable;
    tb_SchoolCode: TTable;
    cb_LoadFromParcelList: TCheckBox;
    Panel3: TPanel;
    btn_Print: TBitBtn;
    btn_Close: TBitBtn;
    gbx_ValuesToCompare: TGroupBox;
    cb_AssessedValue: TCheckBox;
    cb_CountyTaxableValue: TCheckBox;
    cb_MunicipalTaxableValue: TCheckBox;
    cb_SchoolTaxableValue: TCheckBox;
    cb_VillageTaxableValue: TCheckBox;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    cbx_DatabaseYear1: TComboBox;
    Label2: TLabel;
    cbx_AssessmentYear1: TComboBox;
    GroupBox3: TGroupBox;
    Label3: TLabel;
    Label4: TLabel;
    cbx_DatabaseYear2: TComboBox;
    cbx_AssessmentYear2: TComboBox;
    tb_Sort: TTable;
    tb_AssessmentYear1: TTable;
    tb_AssessmentYear2: TTable;
    tb_ExemptionYear1: TTable;
    tb_ExemptionYear2: TTable;
    tb_ExemptionCodeYear1: TTable;
    tb_ExemptionCodeYear2: TTable;
    cb_PrintDetails: TCheckBox;
    ed_AssessmentYearLabel1: TEdit;
    Label5: TLabel;
    Label6: TLabel;
    ed_AssessmentYearLabel2: TEdit;    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure btn_PrintClick(Sender: TObject);
    procedure ReportPrintHeader(Sender: TObject);
    procedure ReportPrint(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure cbx_DatabaseYearChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    UnitName : String;
    ReportCancelled, CreateParcelList,
    LoadFromParcelList, ExtractToExcel : Boolean;
    OrigSortFileName,
    AssessmentYear1, AssessmentYear2,
    AssessmentYearLabel1, AssessmentYearLabel2,
    DatabaseNameYear1, DatabaseNameYear2 : String;
    SelectedSchoolCodes, SelectedSwisCodes, SelectedRollSections : TStringList;
    ExtractFile : TextFile;
    ValueComparisonSections : TValueComparisonType;

    Procedure InitializeForm;  {Open the tables and setup.}

    Procedure FillListBoxes;

    Procedure SortFiles;

    Function RecordMeetsCriteria(tb_Parcel : TTable;
                                 AssessmentYear : String) : Boolean;

    Procedure InsertOneSortRecord(tb_Sort : TTable;
                                  SwisSBLKey : String;
                                  tb_Parcel : TTable;
                                  tb_Assessment : TTable;
                                  tb_Exemption : TTable;
                                  tb_ExemptionCode : TTable;
                                  AssessmentYear : String;
                                  FirstYear : Boolean);

    Procedure LoadSortFileOneYear(tb_Sort : TTable;
                                  tb_Parcel : TTable;
                                  tb_Assessment : TTable;
                                  tb_Exemption : TTable;
                                  tb_ExemptionCode : TTable;
                                  DatabaseName : String;
                                  AssessmentYear : String;
                                  FirstYear : Boolean);

    Procedure PrintOneDifference(    Sender : TObject;
                                     tb_Sort : TTable;
                                     AssessmentYearLabel1 : String;
                                     AssessmentYearLabel2 : String;
                                 var AssessedValueDifference : LongInt;
                                 var CountyTaxableDifference : LongInt;
                                 var MunicipalTaxableDifference : LongInt;
                                 var SchoolTaxableDifference : LongInt);

  end;


implementation

uses GlblVars, WinUtils, Utilitys, UTILEXSD, GlblCnst, PASUtils,
     PRCLLIST,  {Parcel list}
     Prog, RptDialg,
     Preview, PASTypes, DataAccessUnit;

{$R *.DFM}

{========================================================}
Procedure Tfm_ValueComparisonReport.FormActivate(Sender: TObject);

begin
  SetFormStateMaximized(Self);
end;

{========================================================}
Procedure Tfm_ValueComparisonReport.FillListBoxes;

var
  AssessmentYear : String;
  Quit : Boolean;
  DatabaseNamesList : TStringList;
  I : Integer;

begin
  DatabaseNamesList := TStringList.Create;
  AssessmentYear := GetTaxRlYr;

  OpenTableForProcessingType(tb_SchoolCode, SchoolCodeTableName,
                             GlblProcessingType, Quit);

  OpenTableForProcessingType(tb_SwisCode, SwisCodeTableName,
                             GlblProcessingType, Quit);

  FillOneListBox(lbx_SwisCode, tb_SwisCode, 'SwisCode',
                 'MunicipalityName', 25, True, True, GlblProcessingType, AssessmentYear);

  FillOneListBox(lbx_SchoolCode, tb_SchoolCode, 'SchoolCode',
                 'SchoolName', 25, True, True, GlblProcessingType, AssessmentYear);

  SelectItemsInListBox(lbx_RollSection);

  Session.GetDatabaseNames(DatabaseNamesList);

  For I := (DatabaseNamesList.Count - 1) downto 0 do
    If not (_Compare(DatabaseNamesList[I], 'PROPERTY', coStartsWith) or
            _Compare(DatabaseNamesList[I], 'PAS', coStartsWith))
      then DatabaseNamesList.Delete(I);

  cbx_DatabaseYear1.Items.Assign(DatabaseNamesList);
  cbx_DatabaseYear2.Items.Assign(DatabaseNamesList);

  DatabaseNamesList.Free;

end;  {FillListBoxes}

{========================================================}
Procedure Tfm_ValueComparisonReport.InitializeForm;

begin
  UnitName := 'RValueComparison';

  SelectedRollSections := TStringList.Create;
  SelectedSwisCodes := TStringList.Create;
  SelectedSchoolCodes := TStringList.Create;
  FillListBoxes;

end;  {InitializeForm}

{===================================================================}
Procedure Tfm_ValueComparisonReport.cbx_DatabaseYearChange(Sender: TObject);

var
  DatabaseName : String;
  AssessmentYears : TStringList;

begin
  AssessmentYears := TStringList.Create;

  with Sender as TComboBox do
    begin
      DatabaseName := Text;
      GetAllAssessmentYears(AssessmentYears, DatabaseName);

      If _Compare(Name, '1', coContains)
        then cbx_AssessmentYear1.Items.Assign(AssessmentYears)
        else cbx_AssessmentYear2.Items.Assign(AssessmentYears);

    end;  {with Sender as TComboBox do}

  AssessmentYears.Free;

end;  {cbx_DatabaseYearChange}

{===================================================================}
Procedure Tfm_ValueComparisonReport.FormKeyPress(    Sender: TObject;
                                                 var Key: Char);

begin
  If (Key = #13)
    then
      begin
        Key := #0;
        Perform(WM_NEXTDLGCTL, 0, 0);
      end;

end;  {FormKeyPress}

{==============================================================}
Function Tfm_ValueComparisonReport.RecordMeetsCriteria(tb_Parcel : TTable;
                                                       AssessmentYear : String) : Boolean;

begin
  Result := ((SelectedRollSections.IndexOf(tb_Parcel.FieldByName('RollSection').Text) > -1) and
             (SelectedSchoolCodes.IndexOf(tb_Parcel.FieldByName('SchoolCode').Text) > -1) and
             (SelectedSwisCodes.IndexOf(tb_Parcel.FieldByName('SwisCode').Text) > -1) and
             (tb_Parcel.FieldByName('TaxRollYr').Text = AssessmentYear));

end;  {RecordMeetsCriteria}

{==============================================================}
Procedure Tfm_ValueComparisonReport.InsertOneSortRecord(tb_Sort : TTable;
                                                        SwisSBLKey : String;
                                                        tb_Parcel : TTable;
                                                        tb_Assessment : TTable;
                                                        tb_Exemption : TTable;
                                                        tb_ExemptionCode : TTable;
                                                        AssessmentYear : String;
                                                        FirstYear : Boolean);

var
  RollSection, ActiveStatus,
  SchoolCode, HomesteadCode, YearNumber : String;
  LandAssessedValue, TotalAssessedValue,
  CountyTaxableValue, MunicipalTaxableValue,
  SchoolTaxableValue, VillageTaxableValue,
  BasicSTARAmount, EnhancedSTARAmount : LongInt;

begin
  _Locate(tb_Assessment, [AssessmentYear, SwisSBLKey], '', []);

  with tb_Sort do
    try
      If FirstYear
        then
          begin
            YearNumber := 'Year1';
            Insert;
            FieldByName('ParcelExistsYear1').AsBoolean := True;
          end
        else
          begin
            YearNumber := 'Year2';

            If _Locate(tb_Sort, [SwisSBLKey], '', [])
              then Edit
              else Insert;

            FieldByName('ParcelExistsYear2').AsBoolean := True;

          end;  {else of If FirstYear}

      FieldByName('SwisSBLKey').AsString := SwisSBLKey;
      RollSection := tb_Parcel.FieldByName('RollSection').AsString;
      ActiveStatus := tb_Parcel.FieldByName('ActiveFlag').AsString;
      SchoolCode := tb_Parcel.FieldByName('SchoolCode').AsString;
      HomesteadCode := tb_Parcel.FieldByName('HomesteadCode').AsString;

      DetermineAssessedAndTaxableValues(AssessmentYear, SwisSBLKey,
                                        HomesteadCode, tb_Exemption,
                                        tb_ExemptionCode, tb_Assessment,
                                        LandAssessedValue, TotalAssessedValue,
                                        CountyTaxableValue, MunicipalTaxableValue,
                                        SchoolTaxableValue, VillageTaxableValue,
                                        BasicSTARAmount, EnhancedSTARAmount);

      If _Compare(ActiveStatus, InactiveParcelFlag, coEqual)
        then
          begin
            LandAssessedValue:= 0;
            TotalAssessedValue:= 0;
            CountyTaxableValue:= 0;
            MunicipalTaxableValue:= 0;
            SchoolTaxableValue:= 0;
            VillageTaxableValue:= 0;
            BasicSTARAmount:= 0;
            EnhancedSTARAmount := 0;

          end;  {If _Compare(ActiveStatus, InactiveParcelFlag)}

      FieldByName('Status' + YearNumber).AsString := ActiveStatus;
      FieldByName('RollSection' + YearNumber).AsString := RollSection;
      FieldByName('SchoolCode' + YearNumber).AsString := SchoolCode;
      FieldByName('HomesteadCode' + YearNumber).AsString := HomesteadCode;
      FieldByName('AssessedValue' + YearNumber).AsInteger := TotalAssessedValue;
      FieldByName('CountyTaxable' + YearNumber).AsInteger := CountyTaxableValue;
      FieldByName('MunicipalTaxable' + YearNumber).AsInteger := MunicipalTaxableValue;
      FieldByName('SchoolTaxable' + YearNumber).AsInteger := SchoolTaxableValue;
      FieldByName('VillageTaxable' + YearNumber).AsInteger := VillageTaxableValue;

      Post;
    except
    end;

end;  {InsertOneSortRecord}

{==============================================================}
Procedure Tfm_ValueComparisonReport.LoadSortFileOneYear(tb_Sort : TTable;
                                                        tb_Parcel : TTable;
                                                        tb_Assessment : TTable;
                                                        tb_Exemption : TTable;
                                                        tb_ExemptionCode : TTable;
                                                        DatabaseName : String;
                                                        AssessmentYear : String;
                                                        FirstYear : Boolean);

var
  Index : Integer;
  SwisSBLKey : String;
  Done : Boolean;

begin
  Index := 0;
  Done := False;
  ProgressDialog.UserLabelCaption := 'Scanning ' + AssessmentYear + ' in ' + DatabaseName + '.';

  If LoadFromParcelList
    then
      begin
        Index := 1;
        ParcelListDialog.GetParcelWithAssessmentYear(tb_Parcel, Index, AssessmentYear);
        SwisSBLKey := ParcelListDialog.GetParcelSwisSBLKey(Index);
      end
    else
      begin
        tb_Parcel.First;
        SwisSBLKey := ExtractSSKey(tb_Parcel);
      end;

  with tb_Parcel do
    while (not (Done or ReportCancelled)) do
      begin
        ProgressDialog.Update(Self, ConvertSwisSBLToDashDot(SwisSBLKey));
        Application.ProcessMessages;

        If RecordMeetsCriteria(tb_Parcel, AssessmentYear)
          then InsertOneSortRecord(tb_Sort, SwisSBLKey,
                                   tb_Parcel, tb_Assessment,
                                   tb_Exemption, tb_ExemptionCode,
                                   AssessmentYear, FirstYear);

        If LoadFromParcelList
          then
            begin
              Inc(Index);
              SwisSBLKey := ParcelListDialog.GetParcelSwisSBLKey(Index);
              ParcelListDialog.GetParcelWithAssessmentYear(tb_Parcel, Index, AssessmentYear);
            end
          else
            begin
              Next;
              SwisSBLKey := ExtractSSKey(tb_Parcel);
            end;

        ReportCancelled := ProgressDialog.Cancelled;

        Done := EOF or
               (LoadFromParcelList and
                _Compare(Index, ParcelListDialog.NumItems, coGreaterThan));

      end;  {while (not (EOF or ReportCancelled)) do}

end;  {LoadSortFileOneYear}

{==============================================================}
Procedure Tfm_ValueComparisonReport.SortFiles;

begin
  ProgressDialog.Start((tb_ParcelYear1.RecordCount + tb_ParcelYear2.RecordCount), True, True);

  LoadSortFileOneYear(tb_Sort, tb_ParcelYear1, tb_AssessmentYear1,
                      tb_ExemptionYear1, tb_ExemptionCodeYear1,
                      DatabaseNameYear1, AssessmentYear1, True);

  LoadSortFileOneYear(tb_Sort, tb_ParcelYear2, tb_AssessmentYear2,
                      tb_ExemptionYear2, tb_ExemptionCodeYear2,
                      DatabaseNameYear2, AssessmentYear2, False);

  ProgressDialog.Finish;

end;  {SortFiles}

{==============================================================}
Procedure OpenTablesForYear(tb_Parcel : TTable;
                            tb_Assessment : TTable;
                            tb_Exemption : TTable;
                            tb_ExemptionCode : TTable;
                            DatabaseName : String;
                            ProcessingType : Integer);

begin
  _OpenTable(tb_Parcel, ParcelTableName, DatabaseName,
             '', ProcessingType, []);
  _OpenTable(tb_Assessment, AssessmentTableName, DatabaseName,
             '', ProcessingType, []);
  _OpenTable(tb_Exemption, ExemptionsTableName, DatabaseName,
             '', ProcessingType, []);
  _OpenTable(tb_ExemptionCode, ExemptionCodesTableName, DatabaseName,
             '', ProcessingType, []);

end;  {OpenTablesForYear}

{==============================================================}
Procedure Tfm_ValueComparisonReport.btn_PrintClick(Sender: TObject);

var
  ProcessingTypeYear1, ProcessingTypeYear2 : Integer;
  SortFileName, NewFileName, SpreadsheetFileName : String;
  Quit : Boolean;

begin
  OrigSortFileName := tb_Sort.TableName;
  SetPrintToScreenDefault(PrintDialog);
  ReportCancelled := False;
  ExtractToExcel := cb_ExtractToExcel.Checked;
  LoadFromParcelList := cb_LoadFromParcelList.Checked;

  AssessmentYear1 := cbx_AssessmentYear1.Text;
  AssessmentYear2 := cbx_AssessmentYear2.Text;
  AssessmentYearLabel1 := ed_AssessmentYearLabel1.Text;
  AssessmentYearLabel2 := ed_AssessmentYearLabel2.Text;
  DatabaseNameYear1 := cbx_DatabaseYear1.Text;
  DatabaseNameYear2 := cbx_DatabaseYear2.Text;

  If _Compare(AssessmentYearLabel1, coBlank)
    then AssessmentYearLabel1 := AssessmentYear1;
  If _Compare(AssessmentYearLabel2, coBlank)
    then AssessmentYearLabel2 := AssessmentYear2;

  ValueComparisonSections := [];
  If cb_AssessedValue.Checked
    then ValueComparisonSections := ValueComparisonSections + [vcAssessedValue];
  If cb_CountyTaxableValue.Checked
    then ValueComparisonSections := ValueComparisonSections + [vcCountyTaxableValue];
  If cb_MunicipalTaxableValue.Checked
    then ValueComparisonSections := ValueComparisonSections + [vcMunicipalTaxableValue];
  If cb_SchoolTaxableValue.Checked
    then ValueComparisonSections := ValueComparisonSections + [vcSchoolTaxableValue];

  case cbx_AssessmentYear1.Items.IndexOf(AssessmentYear1) of
    0 : ProcessingTypeYear1 := NextYear;
    1 : ProcessingTypeYear1 := ThisYear;
    else ProcessingTypeYear1 := History;
  end;

  case cbx_AssessmentYear2.Items.IndexOf(AssessmentYear2) of
    0 : ProcessingTypeYear2 := NextYear;
    1 : ProcessingTypeYear2 := ThisYear;
    else ProcessingTypeYear2 := History;
  end;

  FillSelectedItemList(lbx_SchoolCode, SelectedSchoolCodes, 6);
  FillSelectedItemList(lbx_SwisCode, SelectedSwisCodes, 6);
  FillSelectedItemList(lbx_RollSection, SelectedRollSections, 1);

  If PrintDialog.Execute
    then
      begin
        AssignPrinterSettings(PrintDialog, ReportPrinter, ReportFiler, [ptBoth], True, Quit);

        ReportPrinter.SetPaperSize(dmPaper_Letter, 0, 0);
        ReportFiler.SetPaperSize(dmPaper_Letter, 0, 0);
        ReportPrinter.Orientation := poLandscape;
        ReportFiler.Orientation := poLandscape;
        ReportPrinter.ScaleX := 90;
        ReportPrinter.ScaleY := 90;
        ReportFiler.ScaleX := 90;
        ReportFiler.ScaleY := 90;

        ReportCancelled := False;
        CreateParcelList := cb_CreateParcelList.Checked;

        If CreateParcelList
          then ParcelListDialog.ClearParcelGrid(True);

        GlblPreviewPrint := False;

        CopyAndOpenSortFile(tb_Sort, 'ValueCompare',
                            OrigSortFileName, SortFileName,
                            True, True, Quit);

        OpenTablesForYear(tb_ParcelYear1, tb_AssessmentYear1,
                          tb_ExemptionYear1, tb_ExemptionCodeYear1,
                          DatabaseNameYear1, ProcessingTypeYear1);

        OpenTablesForYear(tb_ParcelYear2, tb_AssessmentYear2,
                          tb_ExemptionYear2, tb_ExemptionCodeYear2,
                          DatabaseNameYear2, ProcessingTypeYear2);

        SortFiles;

        If ExtractToExcel
          then
            begin
              SpreadsheetFileName := GetPrintFileName(Self.Caption, True);
              AssignFile(ExtractFile, SpreadsheetFileName);
              Rewrite(ExtractFile);

            end;  {If PrintToExcel}

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

          {Make sure to close and delete the sort file.}

        tb_Sort.Close;

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
        ProgressDialog.Finish;

        If ExtractToExcel
          then
            begin
              CloseFile(ExtractFile);
              SendTextFileToExcelSpreadsheet(SpreadsheetFileName, True,
                                             False, '');

            end;  {If PrintToExcel}

      end;  {If PrintDialog.Execute}

  tb_Sort.TableName := OrigSortFileName;

end;  {StartButtonClick}

{==============================================================}
Procedure Tfm_ValueComparisonReport.ReportPrintHeader(Sender: TObject);

begin
  with Sender as TBaseReport do
    begin
      SectionTop := 0.25;
      SectionLeft := 0.5;
      SectionRight := PageWidth - 0.5;

      SetFont('Times New Roman',8);
      PrintHeader('Page: ' + IntToStr(CurrentPage) + '    ', pjRight);
      PrintHeader('    Date: ' + DateToStr(Date) + '  Time: ' + TimeToStr(Now), pjLeft);

      SetFont('Times New Roman',12);
      Bold := True;
      Home;
      Println('');
      PrintCenter('Value Comparison Report', (PageWidth / 2));
      Println('');
      Println('');

      SetFont('Times New Roman',10);

      Bold := True;
      ClearTabs;
      SetTab(0.3, pjCenter, 1.2, 0, BoxLineBottom, 0);  {Parcel ID}
      SetTab(1.6, pjCenter, 1.4, 0, BoxLineBottom, 0);  {Year}
      SetTab(3.1, pjCenter, 0.5, 0, BoxLineBottom, 0);  {Status}
      SetTab(3.7, pjCenter, 0.2, 0, BoxLineBottom, 0);  {RS}
      SetTab(4.0, pjCenter, 0.2, 0, BoxLineBottom, 0);  {HC}
      SetTab(4.3, pjCenter, 0.6, 0, BoxLineBottom, 0);  {School Code}
      SetTab(5.0, pjCenter, 1.0, 0, BoxLineBottom, 0);  {Assessed Value}
      SetTab(6.1, pjCenter, 1.0, 0, BoxLineBottom, 0);  {County Taxable}
      SetTab(7.2, pjCenter, 1.0, 0, BoxLineBottom, 0);  {Municipal Taxable}
      SetTab(8.3, pjCenter, 1.0, 0, BoxLineBottom, 0);  {School Taxable}

      Print(#9 + 'Parcel ID' +
            #9 + 'Year' +
            #9 + 'Status' +
            #9 + 'RS' +
            #9 + 'HC' +
            #9 + 'School');

      If (vcAssessedValue in ValueComparisonSections)
        then Print(#9 + 'Total Value')
        else Print(#9);

      If (vcCountyTaxableValue in ValueComparisonSections)
        then Print(#9 + 'County Taxable')
        else Print(#9);

      If (vcMunicipalTaxableValue in ValueComparisonSections)
        then Print(#9 + GetMunicipalityTypeName(GlblMunicipalityType) + ' Taxable')
        else Print(#9);

      If (vcSchoolTaxableValue in ValueComparisonSections)
        then Println(#9 + 'School Taxable')
        else Println(#9);

      Bold := False;
      ClearTabs;
      SetTab(0.3, pjLeft, 1.2, 0, BoxLineNone, 0);  {Parcel ID}
      SetTab(1.6, pjLeft, 1.4, 0, BoxLineNone, 0);  {Year}
      SetTab(3.1, pjLeft, 0.5, 0, BoxLineNone, 0);  {Status}
      SetTab(3.7, pjLeft, 0.2, 0, BoxLineNone, 0);  {RS}
      SetTab(4.0, pjLeft, 0.2, 0, BoxLineNone, 0);  {HC}
      SetTab(4.3, pjLeft, 0.6, 0, BoxLineNone, 0);  {School Code}
      SetTab(5.0, pjRight, 1.0, 0, BoxLineNone, 0);  {Assessed Value}
      SetTab(6.1, pjRight, 1.0, 0, BoxLineNone, 0);  {County Taxable}
      SetTab(7.2, pjRight, 1.0, 0, BoxLineNone, 0);  {Municipal Taxable}
      SetTab(8.3, pjRight, 1.0, 0, BoxLineNone, 0);  {School Taxable}

    end;  {with Sender as TBaseReport do}

end;  {ReportPrintHeader}

{==============================================================}
Function DifferencesExist(tb_Sort : TTable;
                          ValueComparisonSections : TValueComparisonType) : Boolean;

begin
  Result := False;

  with tb_Sort do
    begin
      If not (FieldByName('ParcelExistsYear1').AsBoolean and
              FieldByName('ParcelExistsYear2').AsBoolean)
        then Result := True;

      If (_Compare(FieldByName('StatusYear1').AsString, FieldByName('StatusYear2').AsString, coNotEqual) or
          _Compare(FieldByName('RollSectionYear1').AsString, FieldByName('RollSectionYear2').AsString, coNotEqual) or
          _Compare(FieldByName('SchoolCodeYear1').AsString, FieldByName('SchoolCodeYear2').AsString, coNotEqual) or
          _Compare(FieldByName('HomesteadCodeYear1').AsString, FieldByName('HomesteadCodeYear2').AsString, coNotEqual))
        then Result := True;

      If ((vcAssessedValue in ValueComparisonSections) and
          _Compare(FieldByName('AssessedValueYear1').AsInteger, FieldByName('AssessedValueYear2').AsInteger, coNotEqual))
        then Result := True;

      If ((vcCountyTaxableValue in ValueComparisonSections) and
          _Compare(FieldByName('CountyTaxableYear1').AsInteger, FieldByName('CountyTaxableYear2').AsInteger, coNotEqual))
        then Result := True;

      If ((vcMunicipalTaxableValue in ValueComparisonSections) and
          _Compare(FieldByName('MunicipalTaxableYear1').AsInteger, FieldByName('MunicipalTaxableYear2').AsInteger, coNotEqual))
        then Result := True;

      If ((vcSchoolTaxableValue in ValueComparisonSections) and
          _Compare(FieldByName('SchoolTaxableYear1').AsInteger, FieldByName('SchoolTaxableYear2').AsInteger, coNotEqual))
        then Result := True;

        {If the parcel does not exist in 1 year and is inactive in the other, don't print it.}

      If ((not FieldByName('ParcelExistsYear1').AsBoolean) and
          _Compare(FieldByName('StatusYear2').AsString, InactiveParcelFlag, coEqual))
        then Result := False;

      If ((not FieldByName('ParcelExistsYear2').AsBoolean) and
          _Compare(FieldByName('StatusYear1').AsString, InactiveParcelFlag, coEqual))
        then Result := False;

    end;  {with tb_Sort do}

end;  {DifferencesExist}

{==============================================================}
Procedure Tfm_ValueComparisonReport.PrintOneDifference(    Sender : TObject;
                                                           tb_Sort : TTable;
                                                           AssessmentYearLabel1 : String;
                                                           AssessmentYearLabel2 : String;
                                                       var AssessedValueDifference : LongInt;
                                                       var CountyTaxableDifference : LongInt;
                                                       var MunicipalTaxableDifference : LongInt;
                                                       var SchoolTaxableDifference : LongInt);

var
  Difference : LongInt;

begin
  with Sender as TBaseReport, tb_Sort do
    begin
      Bold := True;
      Print(#9 + ConvertSwisSBLToDashDot(FieldByName('SwisSBLKey').AsString) +
            #9 + AssessmentYearLabel1);
      Bold := False;

      If FieldByName('ParcelExistsYear1').AsBoolean
        then
          begin
            Print(#9 + FieldByName('StatusYear1').AsString +
                  #9 + FieldByName('RollSectionYear1').AsString +
                  #9 + FieldByName('HomesteadCodeYear1').AsString +
                  #9 + FieldByName('SchoolCodeYear1').AsString);

            If (vcAssessedValue in ValueComparisonSections)
              then Print(#9 + FormatFloat(IntegerDisplay, FieldByName('AssessedValueYear1').AsInteger))
              else Print(#9);

            If (vcCountyTaxableValue in ValueComparisonSections)
              then Print(#9 + FormatFloat(IntegerDisplay, FieldByName('CountyTaxableYear1').AsInteger))
              else Print(#9);

            If (vcMunicipalTaxableValue in ValueComparisonSections)
              then Print(#9 + FormatFloat(IntegerDisplay, FieldByName('MunicipalTaxableYear1').AsInteger))
              else Print(#9);

            If (vcSchoolTaxableValue in ValueComparisonSections)
              then Println(#9 + FormatFloat(IntegerDisplay, FieldByName('SchoolTaxableYear1').AsInteger))
              else Println('');

          end
        else Println(#9 + 'Does not exist.');

      Bold := True;
      Print(#9 +
            #9 + AssessmentYearLabel2);
      Bold := False;

      If FieldByName('ParcelExistsYear2').AsBoolean
        then
          begin
            Print(#9 + FieldByName('StatusYear2').AsString +
                  #9 + FieldByName('RollSectionYear2').AsString +
                  #9 + FieldByName('HomesteadCodeYear2').AsString +
                  #9 + FieldByName('SchoolCodeYear2').AsString);

            If (vcAssessedValue in ValueComparisonSections)
              then Print(#9 + FormatFloat(IntegerDisplay, FieldByName('AssessedValueYear2').AsInteger))
              else Print(#9);

            If (vcCountyTaxableValue in ValueComparisonSections)
              then Print(#9 + FormatFloat(IntegerDisplay, FieldByName('CountyTaxableYear2').AsInteger))
              else Print(#9);

            If (vcMunicipalTaxableValue in ValueComparisonSections)
              then Print(#9 + FormatFloat(IntegerDisplay, FieldByName('MunicipalTaxableYear2').AsInteger))
              else Print(#9);

            If (vcSchoolTaxableValue in ValueComparisonSections)
              then Println(#9 + FormatFloat(IntegerDisplay, FieldByName('SchoolTaxableYear2').AsInteger))
              else Println('');

          end
        else Println(#9 + 'Does not exist.');

      Bold := True;
      Print(#9 +
            #9 + 'Difference');

      Underline := True;
      If _Compare(FieldByName('StatusYear1').AsString, FieldByName('StatusYear2').AsString, coNotEqual)
        then Print(#9 + '*')
        else Print(#9);

      If _Compare(FieldByName('RollSectionYear1').AsString, FieldByName('RollSectionYear2').AsString, coNotEqual)
        then Print(#9 + '*')
        else Print(#9);

      If _Compare(FieldByName('HomesteadCodeYear1').AsString, FieldByName('HomesteadCodeYear2').AsString, coNotEqual)
        then Print(#9 + '*')
        else Print(#9);

      If _Compare(FieldByName('SchoolCodeYear1').AsString, FieldByName('SchoolCodeYear2').AsString, coNotEqual)
        then Print(#9 + '*')
        else Print(#9);

      If ((vcAssessedValue in ValueComparisonSections) and
          _Compare(FieldByName('AssessedValueYear1').AsInteger, FieldByName('AssessedValueYear2').AsInteger, coNotEqual))
        then
          begin
            Difference := FieldByName('AssessedValueYear1').AsInteger - FieldByName('AssessedValueYear2').AsInteger;
            AssessedValueDifference := AssessedValueDifference + Difference;
            Print(#9 + FormatFloat(IntegerDisplay, Difference));
          end
        else Print(#9);

      If ((vcCountyTaxableValue in ValueComparisonSections) and
          _Compare(FieldByName('CountyTaxableYear1').AsInteger, FieldByName('CountyTaxableYear2').AsInteger, coNotEqual))
        then
          begin
            Difference := FieldByName('CountyTaxableYear1').AsInteger - FieldByName('CountyTaxableYear2').AsInteger;
            CountyTaxableDifference := CountyTaxableDifference + Difference;
            Print(#9 + FormatFloat(IntegerDisplay, Difference));
          end
        else Print(#9);

      If ((vcMunicipalTaxableValue in ValueComparisonSections) and
          _Compare(FieldByName('MunicipalTaxableYear1').AsInteger, FieldByName('MunicipalTaxableYear2').AsInteger, coNotEqual))
        then
          begin
            Difference := FieldByName('MunicipalTaxableYear1').AsInteger - FieldByName('MunicipalTaxableYear2').AsInteger;
            MunicipalTaxableDifference := MunicipalTaxableDifference + Difference;
            Print(#9 + FormatFloat(IntegerDisplay, Difference));
          end
        else Print(#9);

      If ((vcSchoolTaxableValue in ValueComparisonSections) and
          _Compare(FieldByName('SchoolTaxableYear1').AsInteger, FieldByName('SchoolTaxableYear2').AsInteger, coNotEqual))
        then
          begin
            Difference := FieldByName('SchoolTaxableYear1').AsInteger - FieldByName('SchoolTaxableYear2').AsInteger;
            SchoolTaxableDifference := SchoolTaxableDifference + Difference;
            Println(#9 + FormatFloat(IntegerDisplay, Difference));
          end
        else Println(#9);

      Bold := False;
      Underline := False;

      Println('');

    end;  {with Sender as TBaseReport do}

end;  {PrintOneDifference}

{==============================================================}
Procedure Tfm_ValueComparisonReport.ReportPrint(Sender: TObject);

var
  AssessedValueDifference, CountyTaxableDifference,
  MunicipalTaxableDifference, SchoolTaxableDifference : LongInt;

begin
  ReportCancelled := False;
  AssessedValueDifference := 0;
  CountyTaxableDifference := 0;
  MunicipalTaxableDifference := 0;
  SchoolTaxableDifference := 0;
  tb_Sort.First;
  ProgressDialog.UserLabelCaption := 'Printing Sort Results';
  ProgressDialog.Start(tb_Sort.RecordCount, True, True);

  with tb_Sort do
    while not (EOF or ReportCancelled) do
      begin
        ProgressDialog.Update(Self, ConvertSwisSBLToDashDot(FieldByName('SwisSBLKey').AsString));
        Application.ProcessMessages;

        If DifferencesExist(tb_Sort, ValueComparisonSections)
          then
            begin
              PrintOneDifference(Sender, tb_Sort,
                                 AssessmentYearLabel1, AssessmentYearLabel2,
                                 AssessedValueDifference, CountyTaxableDifference,
                                 MunicipalTaxableDifference, SchoolTaxableDifference);

              with Sender as TBaseReport do
                If (LinesLeft < 5)
                  then NewPage;

            end;  {If DifferencesExist(tb_Sort)}

        Next;
        ReportCancelled := ProgressDialog.Cancelled;

      end;  {while not (EOF or ReportCancelled) do}

  with Sender as TBaseReport do
    begin
      Bold := True;
      Underline := True;
      Println(#9 + 'Total Difference:' +
              #9 + #9 + #9 + #9 + #9 +
              #9 + FormatFloat(IntegerDisplay, AssessedValueDifference) +
              #9 + FormatFloat(IntegerDisplay, CountyTaxableDifference) +
              #9 + FormatFloat(IntegerDisplay, MunicipalTaxableDifference) +
              #9 + FormatFloat(IntegerDisplay, SchoolTaxableDifference));

      Underline := False;

    end;  {with Sender as TBaseReport do}

end;  {ReportPrint}

{===================================================================}
Procedure Tfm_ValueComparisonReport.FormClose(    Sender: TObject;
                                                     var Action: TCloseAction);

begin
  SelectedSchoolCodes.Free;
  SelectedSwisCodes.Free;
  SelectedRollSections.Free;
  CloseTablesForForm(Self);

    {Free up the child window and set the ClosingAForm Boolean to
     true so that we know to delete the tab.}

  Action := caFree;
  GlblClosingAForm := True;
  GlblClosingFormCaption := Caption;

end;  {FormClose}

end.