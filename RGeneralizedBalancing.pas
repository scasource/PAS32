unit RGeneralizedBalancing;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, DBCtrls, DBTables, DB, Buttons, Grids,
  Wwdbigrd, Wwdbgrid, ExtCtrls, Wwtable, Wwdatsrc, Menus, wwdblook,
  TabNotBk, Types, RPFiler, RPDefine, RPBase, RPCanvas, RPrinter, Progress,
  RPTXFilr, ComCtrls, Math;

type
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
    lbs_SchoolCode: TListBox;
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
    cbx_Year1Database: TComboBox;
    Label2: TLabel;
    cbx_AssessmentYear1: TComboBox;
    GroupBox3: TGroupBox;
    Label3: TLabel;
    Label4: TLabel;
    cbx_Year2Database: TComboBox;
    cbx_AssessmentYear2: TComboBox;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure btn_PrintClick(Sender: TObject);
    procedure ReportPrintHeader(Sender: TObject);
    procedure ReportPrint(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure ScreenListBoxClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    UnitName : String;
    ReportCancelled, CreateParcelList,
    LoadFromParcelList, ExtractToExcel : Boolean;
    OrigSortFileName, FieldLabelName, TableName,
    FieldName, AssessmentYear1, AssessmentYear2 : String;
    SelectedSchoolCodes, SelectedSwisCodes, SelectedRollSections : TStringList;
    ProcessingType1, ProcessingType2 : Integer;
    ScreenLabelList : TList;
    FieldDataType : TFieldType;
    FieldJustify : TPrintJustify;
    FieldWidth : Double;
    ExtractFile : TextFile;

    Procedure InitializeForm;  {Open the tables and setup.}

    Procedure FillListBoxes;

    Function RecordMeetsCriteria(ParcelTable : TTable;
                                 AssessmentYear : String) : Boolean;

    Function ValuesDifferent(    SwisSBLKey : String;
                             var Field1Value : String;
                             var Field2Value : String) : Boolean;

    Procedure FillSortFile(var Cancelled : Boolean);

  end;

implementation

uses GlblVars, WinUtils, Utilitys, UTILEXSD, GlblCnst, PASUtils,
     PRCLLIST,  {Parcel list}
     Prog, RptDialg,
     Preview, PASTypes;

{$R *.DFM}

{========================================================}
Procedure Tfm_ValueComparisonReport.FormActivate(Sender: TObject);

begin
  SetFormStateMaximized(Self);
end;

{========================================================}
Procedure Tfm_ValueComparisonReport.FillListBoxes;

{Fill in all the list boxes on the various notebook pages.}

var
  Found, Quit : Boolean;
  AssessmentYear : String;
  I, J : Integer;

begin
  AssessmentYear := GetTaxRlYr;

  OpenTableForProcessingType(SchoolCodeTable, SchoolCodeTableName,
                             GlblProcessingType, Quit);

  OpenTableForProcessingType(SwisCodeTable, SwisCodeTableName,
                             GlblProcessingType, Quit);

  FillOneListBox(SwisCodeListBox, SwisCodeTable, 'SwisCode',
                 'MunicipalityName', 25, True, True, GlblProcessingType, AssessmentYear);

  FillOneListBox(SchoolCodeListBox, SchoolCodeTable, 'SchoolCode',
                 'SchoolName', 25, True, True, GlblProcessingType, AssessmentYear);

  SelectItemsInListBox(RollSectionListBox);

    {Now fill in the combo boxes.}

  For J := 0 to (ScreenLabelList.Count - 1) do
    with ScreenLabelPtr(ScreenLabelList[J])^ do
      begin
        Found := False;

        For I := 0 to (ScreenListBox.Items.Count - 1) do
          If (Take(30, ScreenListBox.Items[I]) = Take(30, ScreenName))
            then Found := True;

        If not Found
          then ScreenListBox.Items.Add(Take(30, ScreenName));

      end;  {with ScreenLabelPtr(ScreenLabelList[I])^ do}

end;  {FillListBoxes}

{========================================================}
Procedure Tfm_ValueComparisonReport.InitializeForm;

begin
  UnitName := 'RCompareDataBetweenYears';
  OrigSortFileName := SortTable.TableName;

  SelectedRollSections := TStringList.Create;
  SelectedSwisCodes := TStringList.Create;
  SelectedSchoolCodes := TStringList.Create;
  ScreenLabelList := TList.Create;

  ScreenLabelTable.Open;
  LoadScreenLabelList(ScreenLabelList, ScreenLabelTable, UserFieldDefinitionTable, False,
                      True, True,
                      [slAssessment, slBaseInformation, slClass,
                       slResidentialBuilding, slResidentialSite,
                       slCommercialBuilding, slCommercialSite]);
  FillListBoxes;

end;  {InitializeForm}

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
Procedure Tfm_ValueComparisonReport.ScreenListBoxClick(Sender: TObject);

{Fill in the fields for this screen.}

var
  _ScreenName : String;
  I : Integer;

begin
  LabelListBox.Items.Clear;

  with ScreenListBox do
    For I := 0 to (Items.Count - 1) do
      If Selected[I]
        then _ScreenName := Items[I];

  For I := 0 to (ScreenLabelList.Count - 1) do
    with ScreenLabelPtr(ScreenLabelList[I])^ do
      If (Trim(ScreenName) = Trim(_ScreenName))
        then LabelListBox.Items.Add(LabelName);

end;  {ScreenListBoxClick}

{==============================================================}
Function Tfm_ValueComparisonReport.RecordMeetsCriteria(ParcelTable : TTable;
                                                              AssessmentYear : String) : Boolean;

begin
  Result := ((SelectedRollSections.IndexOf(ParcelTable.FieldByName('RollSection').Text) > -1) and
             (SelectedSchoolCodes.IndexOf(ParcelTable.FieldByName('SchoolCode').Text) > -1) and
             (SelectedSwisCodes.IndexOf(ParcelTable.FieldByName('SwisCode').Text) > -1) and
             (ParcelTable.FieldByName('ActiveFlag').Text <> InactiveParcelFlag) and
             (ParcelTable.FieldByName('TaxRollYr').Text = AssessmentYear));

end;  {RecordMeetsCriteria}

{==============================================================}
Function Tfm_ValueComparisonReport.ValuesDifferent(    SwisSBLKey : String;
                                                          var Field1Value : String;
                                                          var Field2Value : String) : Boolean;

var
  SBLRec : SBLRecord;
  FoundTable1, FoundTable2 : Boolean;
  FieldLength : Integer;

begin
  Result := False;

    {First see if we can find this record in the 2nd table.}

  If (TableName = ParcelTableName)
    then
      begin
        SBLRec := ExtractSwisSBLFromSwisSBLKey(SwisSBLKey);

        with SBLRec do
          begin
            FoundTable1 := FindKeyOld(Table1,
                                      ['TaxRollYr', 'SwisCode', 'Section',
                                       'Subsection', 'Block', 'Lot', 'Sublot', 'Suffix'],
                                      [AssessmentYear1, SwisCode, Section,
                                       Subsection, Block, Lot, Sublot, Suffix]);

            FoundTable2 := FindKeyOld(Table2,
                                      ['TaxRollYr', 'SwisCode', 'Section',
                                       'Subsection', 'Block', 'Lot', 'Sublot', 'Suffix'],
                                      [AssessmentYear2, SwisCode, Section,
                                       Subsection, Block, Lot, Sublot, Suffix]);

          end;  {with SBLRec do}

      end
    else
      begin
        FoundTable1 := FindKeyOld(Table1, ['TaxRollYr', 'SwisSBLKey'], [AssessmentYear1, SwisSBLKey]);
        FoundTable2 := FindKeyOld(Table2, ['TaxRollYr', 'SwisSBLKey'], [AssessmentYear2, SwisSBLKey]);
      end;

  If (FoundTable1 and
      FoundTable2)
    then
      begin
        try
          case FieldDataType of
            ftString,
            ftMemo :
              begin
                If (FieldDataType = ftMemo)
                  then FieldLength := 255
                  else FieldLength := Table1.FieldByName(FieldName).Size;

                Field1Value := Take(FieldLength, Table1.FieldByName(FieldName).Text);
                Field2Value := Take(FieldLength, Table2.FieldByName(FieldName).Text);

                If not _Compare(Field1Value, Field2Value, coEqual)
                  then Result := True;

              end;  {ftString}

            ftSmallInt,
            ftInteger,
            ftWord :
              begin
                Field1Value := Table1.FieldByName(FieldName).Text;
                Field2Value := Table2.FieldByName(FieldName).Text;

                If not _Compare(StrToInt(Field1Value), StrToInt(Field2Value), coEqual)
                  then Result := True;

              end;  {ftSmallInt...}

            ftFloat,
            ftCurrency :
              begin
                Field1Value := Table1.FieldByName(FieldName).Text;
                Field2Value := Table2.FieldByName(FieldName).Text;

                If not _Compare(StrToFloat(Field1Value), StrToFloat(Field2Value), coEqual)
                  then Result := True;

              end;  {ftFloat...}

            ftBoolean :
              begin
                Field1Value := Table1.FieldByName(FieldName).Text;
                Field2Value := Table2.FieldByName(FieldName).Text;

                If not _Compare(StrToBool(Field1Value), Field2Value, coEqual)
                  then Result := True;

              end;  {ftFloat...}

            ftDate,
            ftDateTime,
            ftTime :
              begin
                Field1Value := Table1.FieldByName(FieldName).Text;
                Field2Value := Table2.FieldByName(FieldName).Text;

                If not _Compare(StrToDateTime(Field1Value), StrToDateTime(Field2Value), coEqual)
                  then Result := True;

              end;  {ftDate...}

          end;  {case TempTable.FieldByName(FieldName).DataType of}
        except
          Result := False;
        end;
      end;

  If (FoundTable1 and
      (not FoundTable2))
    then
      begin
        Field1Value := Table1.FieldByName(FieldName).Text;
        Field2Value := 'N/A';
        Result := True;
      end;

  If (FoundTable2 and
      (not FoundTable1))
    then
      begin
        Field2Value := Table2.FieldByName(FieldName).Text;
        Field1Value := 'N/A';
        Result := True;
      end;

end;  {ValuesDifferent}

{==============================================================}
Procedure InsertOneSortRecord(SortTable : TTable;
                              ParcelTable : TTable;
                              Field1Value : String;
                              Field2Value : String);

var
  SwisSBLKey : String;

begin
  SwisSBLKey := ExtractSSKey(ParcelTable);

  with SortTable do
    try
      Insert;
      FieldByName('SwisSBLKey').Text := SwisSBLKey;
      FieldByName('RollSection').Text := ParcelTable.FieldByName('RollSection').Text;
      FieldByName('SchoolCode').Text := ParcelTable.FieldByName('SchoolCode').Text;
      FieldByName('Name1').Text := ParcelTable.FieldByName('Name1').Text;
      FieldByName('LegalAddress').Text := GetLegalAddressFromTable(ParcelTable);
      FieldByName('Field1Value').Text := Field1Value;
      FieldByName('Field2Value').Text := Field2Value;
      Post;
    except
      MessageDlg('Error inserting ' + SwisSBLKey + ' into sort table.',
                 mtError, [mbOk], 0);
    end;

end;  {InsertOneSortRecord}

{==============================================================}
Procedure Tfm_ValueComparisonReport.FillSortFile(var Cancelled : Boolean);

var
  Done, FirstTimeThrough : Boolean;
  SwisSBLKey, Field1Value, Field2Value : String;
  Index : LongInt;

begin
    {Go through the first parcel table.}

  Index := 0;
  FirstTimeThrough := True;
  Done := False;
  ProgressDialog.UserLabelCaption := 'Scanning ' + AssessmentYear1 + '.';

    {CHG08182004-1(2.08.0.08182004): Add option to load from parcel list.}

  If LoadFromParcelList
    then
      begin
        Index := 1;
        ProgressDialog.Start(ParcelListDialog.NumItems, True, True);
        ParcelListDialog.GetParcelWithAssessmentYear(ParcelTable1, Index, AssessmentYear1);
        SwisSBLKey := ParcelListDialog.GetParcelSwisSBLKey(Index);
      end
    else
      begin
        ParcelTable1.First;
        ProgressDialog.Start(GetRecordCount(ParcelTable1) + GetRecordCount(ParcelTable2), True, True);
        SwisSBLKey := ExtractSSKey(ParcelTable1);
      end;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else
        If LoadFromParcelList
          then
            begin
              Index := Index + 1;
              SwisSBLKey := ParcelListDialog.GetParcelSwisSBLKey(Index);
              ParcelListDialog.GetParcelWithAssessmentYear(ParcelTable1, Index, AssessmentYear1);
            end
          else
            begin
              ParcelTable1.Next;
              SwisSBLKey := ExtractSSKey(ParcelTable1);
            end;

    If (ParcelTable1.EOF or
        (LoadFromParcelList and
         (Index > ParcelListDialog.NumItems)))
      then Done := True;

    ProgressDialog.Update(Self, ConvertSwisSBLToDashDot(SwisSBLKey));
    Application.ProcessMessages;

    If ((not Done) and
        RecordMeetsCriteria(ParcelTable1, AssessmentYear1) and
        ValuesDifferent(SwisSBLKey, Field1Value, Field2Value))
      then InsertOneSortRecord(SortTable, ParcelTable1, Field1Value, Field2Value);

  until Done;

    {Go through the second parcel table.}

  FirstTimeThrough := True;
  Done := False;
  ProgressDialog.UserLabelCaption := 'Scanning ' + AssessmentYear2 + '.';

    {CHG08182004-1(2.08.0.08182004): Add option to load from parcel list.}

  If LoadFromParcelList
    then
      begin
        Index := 1;
        ProgressDialog.Start(ParcelListDialog.NumItems, True, True);
        ParcelListDialog.GetParcelWithAssessmentYear(ParcelTable2, Index, AssessmentYear2);
        SwisSBLKey := ParcelListDialog.GetParcelSwisSBLKey(Index);
      end
    else
      begin
        ParcelTable2.First;
        ProgressDialog.Start(GetRecordCount(ParcelTable2) + GetRecordCount(ParcelTable2), True, True);
        SwisSBLKey := ExtractSSKey(ParcelTable2);
      end;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else
        If LoadFromParcelList
          then
            begin
              Index := Index + 1;
              SwisSBLKey := ParcelListDialog.GetParcelSwisSBLKey(Index);
              ParcelListDialog.GetParcelWithAssessmentYear(ParcelTable2, Index, AssessmentYear2);
            end
          else
            begin
              ParcelTable2.Next;
              SwisSBLKey := ExtractSSKey(ParcelTable2);
            end;

    If (ParcelTable2.EOF or
        (LoadFromParcelList and
         (Index > ParcelListDialog.NumItems)))
      then Done := True;

    ProgressDialog.Update(Self, ConvertSwisSBLToDashDot(SwisSBLKey));
    Application.ProcessMessages;

    If ((not Done) and
        RecordMeetsCriteria(ParcelTable2, AssessmentYear2) and
        ValuesDifferent(SwisSBLKey, Field1Value, Field2Value) and
        (Field1Value = 'N/A'))  {Only insert if not found in table 1.}
      then InsertOneSortRecord(SortTable, ParcelTable2, Field1Value, Field2Value);

  until Done;

end;  {FillSortFile}

{==============================================================}
Procedure Tfm_ValueComparisonReport.btn_PrintClick(Sender: TObject);

var
  I : Integer;
  ScreenName, SortFileName,
  NewFileName, SpreadsheetFileName : String;
  Quit : Boolean;

begin
  SetPrintToScreenDefault(PrintDialog);
  ReportCancelled := False;
  ExtractToExcel := ExtractToExcelCheckBox.Checked;
  LoadFromParcelList := LoadFromParcelListCheckBox.Checked;

  AssessmentYear1 := EditYear1.Text;
  AssessmentYear2 := EditYear2.Text;

  with ScreenListBox do
    For I := 0 to (Items.Count - 1) do
      If Selected[I]
        then ScreenName := Items[I];

  with LabelListBox do
    For I := 0 to (Items.Count - 1) do
      If Selected[I]
        then FieldLabelName := Items[I];

  If PrintDialog.Execute
    then
      begin
        AssignPrinterSettings(PrintDialog, ReportPrinter, ReportFiler, [ptBoth], False, Quit);

        ProcessingType1 := GetProcessingTypeForTaxRollYear(AssessmentYear1);
        ProcessingType2 := GetProcessingTypeForTaxRollYear(AssessmentYear2);

           {Range information}

        SelectedSchoolCodes.Clear;
        For I := 0 to (SchoolCodeListBox.Items.Count - 1) do
          If SchoolCodeListBox.Selected[I]
            then SelectedSchoolCodes.Add(Take(6, SchoolCodeListBox.Items[I]));

        SelectedSwisCodes.Clear;
        For I := 0 to (SwisCodeListBox.Items.Count - 1) do
          If SwisCodeListBox.Selected[I]
            then SelectedSwisCodes.Add(Take(6, SwisCodeListBox.Items[I]));

        SelectedRollSections.Clear;
        with RollSectionListBox do
          For I := 0 to (Items.Count - 1) do
            If Selected[I]
              then SelectedRollSections.Add(Take(1, Items[I]));

        ReportCancelled := False;
        CreateParcelList := CreateParcelListCheckBox.Checked;

        If CreateParcelList
          then ParcelListDialog.ClearParcelGrid(True);

        TableName := GetTableNameFromScreenName(ScreenLabelList, ScreenName, FieldLabelName);
        FieldName := GetFieldNameForScreenLabel(ScreenLabelList, ScreenName, FieldLabelName);

        GlblPreviewPrint := False;

        CopyAndOpenSortFile(SortTable, 'GeneralizedCompare',
                            OrigSortFileName, SortFileName,
                            True, True, Quit);

        OpenTableForProcessingType(ParcelTable1, ParcelTableName,
                                   ProcessingType1, Quit);
        OpenTableForProcessingType(ParcelTable2, ParcelTableName,
                                   ProcessingType2, Quit);

        OpenTableForProcessingType(Table1, TableName,
                                   ProcessingType1, Quit);
        OpenTableForProcessingType(Table2, TableName,
                                   ProcessingType2, Quit);

        FieldDataType := Table1.FieldByName(FieldName).DataType;

        case FieldDataType of
          ftString : begin
                       FieldWidth := (Table1.FieldByName(FieldName).Size + 2) / 10;

                       FieldJustify := pjLeft;

                     end;  {ftString}

          ftSmallint,
          ftInteger,
          ftWord,
          ftCurrency,
          ftFloat : begin
                      FieldWidth := 1.2;
                      FieldJustify := pjRight;
                    end;

          ftDate,
          ftTime,
          ftDateTime : begin
                        FieldWidth := 1.0;
                        FieldJustify := pjLeft;
                      end;

          ftBoolean : begin
                        FieldWidth := 1.0;
                        FieldJustify := pjCenter;
                      end;

          ftMemo : begin
                     FieldWidth := 2.5;
                     FieldJustify := pjLeft;
                   end;

        end;  {case FieldDataType of}

        FieldWidth := Max(1, FieldWidth);
        FieldWidth := Max(((Length(Trim(FieldLabelName)) + 1) / 10), FieldWidth);

        If (FieldWidth > 2.5)
          then FieldWidth := 2.5;

        FillSortFile(ReportCancelled);

        If ExtractToExcel
          then
            begin
              SpreadsheetFileName := GetPrintFileName(Self.Caption, True);
              AssignFile(ExtractFile, SpreadsheetFileName);
              Rewrite(ExtractFile);

              Writeln(ExtractFile,
                      ',,,' +
                      AssessmentYear1 + ',' +
                      AssessmentYear2);

              Writeln(ExtractFile,
                      'Parcel ID,' +
                      'School,' +
                      'RS,' +
                      FieldLabelName + ',',
                      FieldLabelName);

            end;  {If PrintToExcel}

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
        ProgressDialog.Finish;

        If ExtractToExcel
          then
            begin
              CloseFile(ExtractFile);
              SendTextFileToExcelSpreadsheet(SpreadsheetFileName, True,
                                             False, '');

            end;  {If PrintToExcel}

      end;  {If PrintDialog.Execute}

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
      PrintCenter('Generalized Comparison Report', (PageWidth / 2));
      Println('');
      Println('');

      SetFont('Times New Roman',12);

      ClearTabs;
      SetTab(3.2, pjCenter, FieldWidth, 5, BOXLINEAll, 25);   {Value 1}
      SetTab((3.2 + FieldWidth), pjCenter, FieldWidth, 5, BOXLINEAll, 25);   {Value 2}

      Println('');
      Println(#9 + AssessmentYear1 +
              #9 + AssessmentYear2);

      ClearTabs;
      SetTab(0.4, pjCenter, 1.8, 5, BOXLINEAll, 25);   {Parcel ID}
      SetTab(2.2, pjCenter, 0.7, 5, BOXLINEAll, 25);   {School Code}
      SetTab(2.9, pjCenter, 0.3, 5, BOXLINEAll, 25);   {RS}
      SetTab(3.2, pjCenter, FieldWidth, 5, BOXLINEAll, 25);   {Value 1}
      SetTab((3.2 + FieldWidth), pjCenter, FieldWidth, 5, BOXLINEAll, 25);   {Value 2}

      Println(#9 + 'Parcel ID' +
              #9 + 'School' +
              #9 + 'RS' +
              #9 + Trim(FieldLabelName) +
              #9 + Trim(FieldLabelName));

      Bold := False;
      ClearTabs;
      SetTab(0.4, pjLeft, 1.8, 5, BOXLINEAll, 0);   {Parcel ID}
      SetTab(2.2, pjLeft, 0.7, 5, BOXLINEAll, 0);   {School Code}
      SetTab(2.9, pjCenter, 0.3, 5, BOXLINEAll, 0);   {RS}
      SetTab(3.2, FieldJustify, FieldWidth, 5, BOXLINEAll, 0);   {Value 1}
      SetTab((3.2 + FieldWidth), FieldJustify, FieldWidth, 5, BOXLINEAll, 0);   {Value 2}

    end;  {with Sender as TBaseReport do}

end;  {ReportPrintHeader}

{==============================================================}
Procedure Tfm_ValueComparisonReport.ReportPrint(Sender: TObject);

var
  Done, FirstTimeThrough : Boolean;
  SwisSBLKey : String;
  TotalDifferences : LongInt;

begin
  TotalDifferences := 0;
  FirstTimeThrough := True;
  Done := False;
  ReportCancelled := False;

  SortTable.First;

  with Sender as TBaseReport do
    repeat
      If FirstTimeThrough
        then FirstTimeThrough := False
        else SortTable.Next;

      If SortTable.EOF
        then Done := True;

      SwisSBLKey := SortTable.FieldByName('SwisSBLKey').Text;

      If CreateParcelList
        then ParcelListDialog.AddOneParcel(SwisSBLKey);

      ProgressDialog.Update(Self, ConvertSwisSBLToDashDot(SwisSBLKey));
      Application.ProcessMessages;

      If not Done
        then
          begin
            TotalDifferences := TotalDifferences + 1;
            If (LinesLeft < 8)
              then NewPage;

            with SortTable do
              begin
                Println(#9 + ConvertSwisSBLToDashDot(SwisSBLKey) +
                        #9 + FieldByName('SchoolCode').Text +
                        #9 + FieldByName('RollSection').Text +
                        #9 + FieldByName('Field1Value').Text +
                        #9 + FieldByName('Field2Value').Text);

                If ExtractToExcel
                  then Writeln(ExtractFile,
                               ConvertSwisSBLToDashDot(SwisSBLKey),
                               FormatExtractField(FieldByName('SchoolCode').Text),
                               FormatExtractField(FieldByName('RollSection').Text),
                               FormatExtractField(FieldByName('Field1Value').Text),
                               FormatExtractField(FieldByName('Field2Value').Text));

              end;  {with SortTable do}

          end;  {If not Done}

      ReportCancelled := ProgressDialog.Cancelled;

    until (Done or ReportCancelled);

  with Sender as TBaseReport do
    begin
      Println('');
      Bold := True;
      Println(#9 + 'Total differences = ' + IntToStr(TotalDifferences));
    end;

end;  {ReportPrint}

{===================================================================}
Procedure Tfm_ValueComparisonReport.FormClose(    Sender: TObject;
                                                     var Action: TCloseAction);

begin
  SelectedSchoolCodes.Free;
  SelectedSwisCodes.Free;
  SelectedRollSections.Free;
  FreeTList(ScreenLabelList, SizeOf(ScreenLabelRecord));
  CloseTablesForForm(Self);

    {Free up the child window and set the ClosingAForm Boolean to
     true so that we know to delete the tab.}

  Action := caFree;
  GlblClosingAForm := True;
  GlblClosingFormCaption := Caption;

end;  {FormClose}


end.