unit RPTopTaxPayers;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, DBCtrls, DBTables, DB, Buttons, Grids,
  Wwdbigrd, Wwdbgrid, ExtCtrls, Wwtable, Wwdatsrc, Menus, RPCanvas,
  RPrinter, RPBase, RPFiler, Types, RPDefine, (*Progress, *)RPTXFilr,
  ComCtrls;

type
  TTopTaxpayerReportForm = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    ScrollBox1: TScrollBox;
    TitleLabel: TLabel;
    SwisCodeTable: TTable;
    PrintDialog: TPrintDialog;
    ReportFiler: TReportFiler;
    ReportPrinter: TReportPrinter;
    ExemptionTable: TTable;
    SortHeaderTable: TTable;
    AssessmentTable: TTable;
    ParcelTable: TTable;
    Label8: TLabel;
    Label10: TLabel;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    SortDetailTable: TTable;
    ExemptionCodeTable: TTable;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    AssessmentYearRadioGroup: TRadioGroup;
    DeterminedByRadioGroup: TRadioGroup;
    Label5: TLabel;
    RollSectionListBox: TListBox;
    TabSheet2: TTabSheet;
    Label6: TLabel;
    Label2: TLabel;
    SwisCodeListBox: TListBox;
    SchoolCodeListBox: TListBox;
    MiscellaneousGroupBox: TGroupBox;
    Label1: TLabel;
    NumberOfTaxpayersToShowEdit: TEdit;
    ShowDetailsCheckBox: TCheckBox;
    LoadFromParcelListCheckBox: TCheckBox;
    CreateParcelListCheckBox: TCheckBox;
    SchoolCodeTable: TTable;
    ExtractToExcelCheckBox: TCheckBox;
    OnlyShowRelevantCheckBox: TCheckBox;
    Panel3: TPanel;
    LoadButton: TBitBtn;
    SaveButton: TBitBtn;
    StartButton: TBitBtn;
    CloseButton: TBitBtn;
    cbDontCombineTaxpayers: TCheckBox;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure StartButtonClick(Sender: TObject);
    procedure ReportHeader(Sender: TObject);
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
    SelectedSchoolCodes,
    SelectedRollSections,
    SelectedSwisCodes : TStringList;  {What swis codes did they select?}
    PrintOrder : Integer;  {What order are we printing in?}
    OrigSortHeaderFileName,
    OrigSortDetailFileName : String;
    ProcessingType, NumberOfTaxpayersToShow : Integer;
    ShowDetails,
    LoadFromParcelList,
    CreateParcelList : Boolean;
    AssessmentYear : String;
    ExtractToExcel, OnlyShowRelevantColumns, bDontCombineTaxpayers : Boolean;
    ExtractFile : TextFile;
    LinesAtBottom, NumLinesPerPage,
    ReportType, CurrentLineNumber : Integer;

    Procedure InitializeForm;  {Open the tables and setup.}

    Procedure UpdateSortTable(    SwisSBLKey : String;
                                  AssessmentYear : String;
                                  ParcelTable,
                                  AssessmentTable,
                                  ExemptionTable,
                                  ExemptionCodeTable : TTable;
                              var Quit : Boolean);
    {Insert a record for this parcel.}

    Procedure FillSortFile(var Quit : Boolean);   {Fill the sort file with the variance information.}

    Procedure PrintExcelReportSummaryHeader(var ExtractFile : TextFile);

    Procedure PrintHeaderTabs(Sender : TObject);

    Procedure PrintDetailTabs(Sender : TObject);

  end;

implementation

uses GlblVars, WinUtils, Utilitys, PASUTILS, UTILEXSD,  GlblCnst, PasTypes,
     PRCLLIST, RptDialg,
     Prog,
     Preview;  {Report preview form}

const
  poAssessedValue = 0;
  poCountyTaxableValue = 1;
  poTownTaxableValue = 2;
  poSchoolTaxableValue = 3;

  rtAssessedValue = 0;
  rtCountyTaxable = 1;
  rtMunicipalTaxable = 2;
  rtSchoolTaxable = 3;

{$R *.DFM}

{========================================================}
Procedure TTopTaxpayerReportForm.FormActivate(Sender: TObject);

begin
  SetFormStateMaximized(Self);
end;

{========================================================}
Procedure TTopTaxpayerReportForm.InitializeForm;

var
  Quit : Boolean;

begin
  Quit := False;
  UnitName := 'RPTopTaxPayers';  {mmm}

    {Default swis code table to NY esp. since it rarely changes.}

  OpenTableForProcessingType(SwisCodeTable, SwisCodeTableName,
                             NextYear, Quit);

  FillOneListBox(SwisCodeListBox, SwisCodeTable, 'SwisCode',
                 'MunicipalityName', 25, True, True, ProcessingType,
                 GlblNextYear);

  OpenTableForProcessingType(SchoolCodeTable, SchoolCodeTableName,
                             NextYear, Quit);

  FillOneListBox(SchoolCodeListBox, SchoolCodeTable, 'SchoolCode',
                 'SchoolName', 25, True, True, ProcessingType, GlblNextYear);

  SelectedSwisCodes := TStringList.Create;
  SelectedRollSections := TStringList.Create;
  SelectedSchoolCodes := TStringList.Create;

  SelectItemsInListBox(RollSectionListBox);

  OrigSortHeaderFileName := SortHeaderTable.TableName;
  OrigSortDetailFileName := SortDetailTable.TableName;

end;  {InitializeForm}

{===================================================================}
Procedure TTopTaxpayerReportForm.UpdateSortTable(    SwisSBLKey : String;
                                                     AssessmentYear : String;
                                                     ParcelTable,
                                                     AssessmentTable,
                                                     ExemptionTable,
                                                     ExemptionCodeTable : TTable;
                                                 var Quit : Boolean);
{Insert a record for this parcel.}

var
  ExemptionCodes,
  ExemptionHomesteadCodes,
  ResidentialTypes,
  CountyExemptionAmounts,
  TownExemptionAmounts,
  SchoolExemptionAmounts,
  VillageExemptionAmounts : TStringList;
  TotalAssessedVal, LandAssessedVal,
  BasicSTARAmount, EnhancedSTARAmount : Comp;
  EXAmounts : ExemptionTotalsArrayType;
  _Owner, OwnerKey : String;
  _Found : Boolean;

begin
  _Owner := ParcelTable.FieldByName('Name1').Text;

  ExemptionCodes := TStringList.Create;
  ExemptionHomesteadCodes := TStringList.Create;
  ResidentialTypes := TStringList.Create;
  CountyExemptionAmounts := TStringList.Create;
  TownExemptionAmounts := TStringList.Create;
  SchoolExemptionAmounts := TStringList.Create;
  VillageExemptionAmounts := TStringList.Create;

  FindKeyOld(AssessmentTable, ['TaxRollYr', 'SwisSBLKey'],
             [AssessmentYear, SwisSBLKey]);

  with AssessmentTable do
    begin
      LandAssessedVal := FieldByName('LandAssessedVal').AsFloat;
      TotalAssessedVal := FieldByName('TotalAssessedVal').AsFloat;
    end;

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

    {First try to find this name by owner without spaces.}

  OwnerKey := StringReplace(_Owner, ' ', '', [rfReplaceAll]);

    {FXX01282004-3(2.08): Ignore all punctuation when comparing names.}

  OwnerKey := StringReplace(_Owner, '.', '', [rfReplaceAll]);
  OwnerKey := StringReplace(_Owner, ',', '', [rfReplaceAll]);
  OwnerKey := StringReplace(_Owner, '&', '', [rfReplaceAll]);
  OwnerKey := StringReplace(_Owner, '#', '', [rfReplaceAll]);
  OwnerKey := StringReplace(_Owner, '''', '', [rfReplaceAll]);
  OwnerKey := StringReplace(_Owner, '"', '', [rfReplaceAll]);
  OwnerKey := StringReplace(_Owner, ':', '', [rfReplaceAll]);
  OwnerKey := StringReplace(_Owner, ';', '', [rfReplaceAll]);

  _Found := FindKeyOld(SortHeaderTable, ['OwnerKey'], [OwnerKey]);

    {CHG06092010-6(2.26.1)[I7400]: Option to not combine taxpayers.}

  If bDontCombineTaxpayers
  then _Found := False;

  If not _Found
    then
      with SortHeaderTable do
        try
          Insert;
          FieldByName('OwnerKey').Text := OwnerKey;
          FieldByName('Owner').Text := _Owner;
          Post;
        except
          SystemSupport(001, SortHeaderTable, 'Error inserting owner ' + _Owner + '.',
                        UnitName, GlblErrorDlgBox);
        end;

  with SortHeaderTable do
    try
      Edit;
      FieldByName('ParcelCount').AsInteger := FieldByName('ParcelCount').AsInteger + 1;
      FieldByName('TotalAssessedVal').AsFloat := FieldByName('TotalAssessedVal').AsFloat +
                                                 TotalAssessedVal;
      FieldByName('LandAssessedVal').AsFloat := FieldByName('LandAssessedVal').AsFloat +
                                                LandAssessedVal;
      FieldByName('CountyTaxableValue').AsFloat := FieldByName('CountyTaxableValue').AsFloat +
                                                   (TotalAssessedVal - EXAmounts[EXCounty]);
      FieldByName('TownTaxableValue').AsFloat := FieldByName('TownTaxableValue').AsFloat +
                                                 (TotalAssessedVal - EXAmounts[EXTown]);
      FieldByName('SchoolTaxableValue').AsFloat := FieldByName('SchoolTaxableValue').AsFloat +
                                                  (TotalAssessedVal - EXAmounts[EXSchool]);

      Post;
    except
      SystemSupport(002, SortHeaderTable, 'Error updating owner ' + _Owner + '.',
                    UnitName, GlblErrorDlgBox);
    end;

  with SortDetailTable do
    try
      Insert;
      FieldByName('OwnerKey').Text := OwnerKey;
      FieldByName('SwisSBLKey').Text := SwisSBLKey;
      FieldByName('Location').Text := GetLegalAddressFromTable(ParcelTable);
      FieldByName('RollSection').Text := ParcelTable.FieldByName('RollSection').Text;
      FieldByName('PropertyClass').Text := ParcelTable.FieldByName('PropertyClassCode').Text +
                                           ParcelTable.FieldByName('OwnershipCode').Text;
      FieldByName('TotalAssessedVal').AsFloat := TotalAssessedVal;
      FieldByName('LandAssessedVal').AsFloat := LandAssessedVal;
      FieldByName('CountyTaxableValue').AsFloat := TotalAssessedVal - EXAmounts[EXCounty];
      FieldByName('TownTaxableValue').AsFloat := TotalAssessedVal - EXAmounts[EXTown];
      FieldByName('SchoolTaxableValue').AsFloat := TotalAssessedVal - EXAmounts[EXSchool];
      Post;
    except
      SystemSupport(003, SortDetailTable, 'Error inserting detail for owner ' + _Owner + '.',
                    UnitName, GlblErrorDlgBox);
    end;

  ExemptionCodes.Free;
  ExemptionHomesteadCodes.Free;
  ResidentialTypes.Free;
  CountyExemptionAmounts.Free;
  TownExemptionAmounts.Free;
  SchoolExemptionAmounts.Free;
  VillageExemptionAmounts.Free;

end;  {UpdateSortTable}

{===================================================================}
Procedure TTopTaxpayerReportForm.FillSortFile(var Quit : Boolean);

{Fill the sort file with the variance information.}

var
  FirstTimeThrough, Done : Boolean;
  Index : Integer;
  SwisSBLKey : String;

begin
  ProgressDialog.UserLabelCaption := 'Sorting Parcel File.';
  Index := 1;

  FirstTimeThrough := True;
  Done := False;

    {CHG03101999-1: Send info to a list or load from a list.}

  If CreateParcelList
    then ParcelListDialog.ClearParcelGrid(True);

  If LoadFromParcelList
    then
      begin
        ParcelListDialog.GetParcel(ParcelTable, Index);
        ProgressDialog.Start(ParcelListDialog.NumItems, True, True);
      end
    else
      begin
        ParcelTable.First;
        ProgressDialog.Start(GetRecordCount(ParcelTable), True, True);
      end;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else
        If LoadFromParcelList
          then
            begin
              Index := Index + 1;
              ParcelListDialog.GetParcel(ParcelTable, Index);
            end
          else ParcelTable.Next;

    If (ParcelTable.EOF or
        (LoadFromParcelList and
         (Index > ParcelListDialog.NumItems)))
      then Done := True;

    If LoadFromParcelList
      then ProgressDialog.Update(Self, ParcelListDialog.GetParcelID(Index))
      else ProgressDialog.Update(Self, ConvertSwisSBLToDashDot(ExtractSSKey(ParcelTable)));

    SwisSBLKey := ExtractSSKey(ParcelTable);

    Application.ProcessMessages;

      {FXX1192004-1(2.8.1.0)[1977]: Need to make sure we only include active parcels.}

    If ((not Done) and
        ParcelIsActive(ParcelTable) and
        (SelectedSwisCodes.IndexOf(Copy(SwisSBLKey, 1, 6)) > -1) and  {In the selected list.}
        (SelectedSchoolCodes.IndexOf(ParcelTable.FieldByName('SchoolCode').Text) > -1) and  {In the selected list.}
        (SelectedRollSections.IndexOf(ParcelTable.FieldByName('RollSection').Text) > -1))
      then UpdateSortTable(SwisSBLKey, AssessmentYear, ParcelTable,
                           AssessmentTable, ExemptionTable, ExemptionCodeTable, Quit);

    ReportCancelled := ProgressDialog.Cancelled;

  until (Done or Quit or ReportCancelled);

end;  {FillSortFiles}

{====================================================================}
Procedure TTopTaxpayerReportForm.SaveButtonClick(Sender: TObject);

{FXX04091999-8: Add ability to save and load search report options.}

begin
  SaveReportOptions(Self, OpenDialog, SaveDialog, 'taxpayer.txp', 'Top Tax Payer Report');

end;  {SaveButtonClick}

{====================================================================}
Procedure TTopTaxpayerReportForm.LoadButtonClick(Sender: TObject);

{FXX04091999-8: Add ability to save and load search report options.}

begin
  LoadReportOptions(Self, OpenDialog, 'taxpayer.txp', 'Top Tax Payer Report');

end;  {LoadButtonClick}

{===================================================================}
Procedure TTopTaxpayerReportForm.PrintExcelReportSummaryHeader(var ExtractFile : TextFile);

{CHG02242004-1(2.08): Option to print to Excel.}

begin
  If ShowDetails
    then
      begin
        Writeln(ExtractFile);
        Writeln(ExtractFile);
        Writeln(ExtractFile);

      end;  {If ShowDetails}

  Write(ExtractFile, 'Owner,',
                     'Parcels,',
                     'Land Value,',
                     'Assessed Value');

   If (rtdCounty in GlblRollTotalsToShow)
     then Write(ExtractFile, ',County Taxable');

   If (rtdMunicipal in GlblRollTotalsToShow)
     then Write(ExtractFile, ',' + GetMunicipalityTypeName(GlblMunicipalityType));

   If (rtdSchool in GlblRollTotalsToShow)
     then Writeln(ExtractFile, ',School Taxable')
     else Writeln(ExtractFile);

end;  {PrintExcelReportSummaryHeader}

{===================================================================}
Procedure PrintExcelReportDetailHeader(var ExtractFile : TextFile);

{CHG02242004-1(2.08): Option to print to Excel.}

begin
  Writeln(ExtractFile);
  Write(ExtractFile, 'Parcel ID,',
                     'Location,',
                     'RS,',
                     'Prop Cls,',
                     'Land Value,',
                     'Assessed Value');

   If (rtdCounty in GlblRollTotalsToShow)
     then Write(ExtractFile, ',County Taxable');

   If (rtdMunicipal in GlblRollTotalsToShow)
     then Write(ExtractFile, ',' + GetMunicipalityTypeName(GlblMunicipalityType));

   If (rtdSchool in GlblRollTotalsToShow)
     then Writeln(ExtractFile, ',School Taxable')
     else Writeln(ExtractFile);

end;  {PrintExcelReportHeader}

{===================================================================}
Procedure TTopTaxpayerReportForm.StartButtonClick(Sender: TObject);

var
  Quit : Boolean;
  SpreadsheetFileName, TempIndex,
  SortHeaderFileName, SortDetailFileName, NewFileName : String;
  I : Integer;
  ReducedSize, WideCarriage : Boolean;
  DuplexType : TDuplex;

begin
  Quit := False;
  ReportCancelled := False;
  CurrentLineNumber := 0;
  OnlyShowRelevantColumns := OnlyShowRelevantCheckBox.Checked;
  ReportType := DeterminedByRadioGroup.ItemIndex;
  ShowDetails := ShowDetailsCheckBox.Checked;
  bDontCombineTaxpayers := cbDontCombineTaxpayers.Checked;

    {It does not make sense to show details if they aren't combining taxpayers.}

  If bDontCombineTaxpayers
  then ShowDetails := False;

    {FXX09301998-1: Disable print button after clicking to avoid clicking twice.}

  StartButton.Enabled := False;
  Application.ProcessMessages;

    {CHG10121998-1: Add user options for default destination and show vet max msg.}

  SetPrintToScreenDefault(PrintDialog);

  If PrintDialog.Execute
    then
      begin
          {CHG02242004-1(2.08): Option to print to Excel.}

        ExtractToExcel := ExtractToExcelCheckBox.Checked;

        If ExtractToExcel
          then
            begin
              SpreadsheetFileName := GetPrintFileName(Self.Caption, True);
              AssignFile(ExtractFile, SpreadsheetFileName);
              Rewrite(ExtractFile);

            end;  {If PrintToExcel}

        SelectedSwisCodes.Clear;

        For I := 0 to (SwisCodeListBox.Items.Count - 1) do
          If SwisCodeListBox.Selected[I]
            then SelectedSwisCodes.Add(Take(6, SwisCodeListBox.Items[I]));

        SelectedSchoolCodes.Clear;

        For I := 0 to (SchoolCodeListBox.Items.Count - 1) do
          If SchoolCodeListBox.Selected[I]
            then SelectedSchoolCodes.Add(Take(6, SchoolCodeListBox.Items[I]));

          {CHG10131999-1: Allow for selection of roll sections.}

        SelectedRollSections.Clear;

        For I := 0 to (RollSectionListBox.Items.Count - 1) do
          If RollSectionListBox.Selected[I]
            then SelectedRollSections.Add(RollSectionListBox.Items[I][1]);

        LoadFromParcelList := LoadFromParcelListCheckBox.Checked;
        CreateParcelList := CreateParcelListCheckBox.Checked;

        try
          NumberOfTaxpayersToShow := StrToInt(NumberOfTaxpayersToShowEdit.Text);
        except
          NumberOfTaxpayersToShow := 10;
        end;

        case AssessmentYearRadioGroup.ItemIndex of
          0 : begin
                ProcessingType := ThisYear;
                AssessmentYear := GlblThisYear;
              end;

          1 : begin
                ProcessingType := NextYear;
                AssessmentYear := GlblNextYear;
              end;

        end;  {case AssessmentYearRadioGroup.ItemIndex of}

          {CHG10131998-1: Set the printer settings based on what printer they selected
                          only - they no longer need to worry about paper or landscape
                          mode.}
          {CHG11162004-4(2.8.1.0)[1977]: Option to only show relevant columns.  If they choose this option,
                                         print in letter mode.}

        WideCarriage := not OnlyShowRelevantColumns;
        AssignPrinterSettings(PrintDialog, ReportPrinter, ReportFiler, [ptLaser], WideCarriage, Quit);

          {CHG02242004-2(2.08): Offer to print on letter size paper.}

        If WideCarriage
          then PromptForLetterSizePaper(ReportPrinter, ReportFiler, NumLinesPerPage, LinesAtBottom,
                                        ReducedSize, DuplexType)
          else
            begin
              NumLinesPerPage := 60;
              LinesAtBottom := GlblLinesLeftOnRollLaserJet;
            end;

        If not Quit
          then
            begin
              If (ExtractToExcel and
                  (not ShowDetails))
                then PrintExcelReportSummaryHeader(ExtractFile);

                {FXX04102003-3(2.06r): Make it so that the top taxpayer report can be run 2x in a row.}

              SortHeaderTable.Close;
              SortHeaderTable.TableName := '';
              SortHeaderTable.IndexName := '';
              SortDetailTable.Close;
              SortDetailTable.TableName := '';

              OpenTablesForForm(Self, ProcessingType);

                {Copy the sort table and open the tables.}

              CopyAndOpenSortFile(SortHeaderTable, 'TopPayerHdr',
                                  OrigSortHeaderFileName, SortHeaderFileName,
                                  True, True, Quit);

              CopyAndOpenSortFile(SortDetailTable, 'TopPayerDtl',
                                  OrigSortDetailFileName, SortDetailFileName,
                                  True, True, Quit);

              SortHeaderTable.IndexName := 'BYOWNERKEY';
              FillSortFile(Quit);

                {FXX10212005-1(2.9.3.6): For speed issues, only add the index that we need after the sort.}

              case ReportType of
                rtAssessedValue : TempIndex := 'TotalAssessedVal';
                rtCountyTaxable : TempIndex := 'CountyTaxableValue';
                rtMunicipalTaxable : TempIndex := 'TownTaxableValue';
                rtSchoolTaxable : TempIndex := 'SchoolTaxableValue';

              end;  {case ReportType of}

              SortHeaderTable.Close;

              try
                SortHeaderTable.AddIndex('TopTaxPayerHeaderIndex',
                                         TempIndex, [ixExpression, ixDescending]);
              except
              end;
              SortHeaderTable.IndexName := 'TopTaxPayerHeaderIndex';
              SortHeaderTable.Open;

                {Now print the report.}

              If not (Quit or ReportCancelled)
                then
                  begin
                    ProgressDialog.Reset;
                    ProgressDialog.TotalNumRecords := NumberOfTaxpayersToShow;
                    ProgressDialog.UserLabelCaption := 'Printing report.';
                    GlblPreviewPrint := False;

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

                      {CHG01182000-3: Allow them to choose a different name or copy right away.}

                    ShowReportDialog('TOPPAYER.RPT', ReportFiler.FileName, True);

                  end;  {If not Quit}

                {Make sure to close and delete the sort file.}

              SortHeaderTable.Close;
              SortDetailTable.Close;

                {Now delete the file.}
             try
                ChDir(GlblDataDir);
                OldDeleteFile(SortHeaderFileName);
                OldDeleteFile(SortDetailFileName);
              finally
                {We don't care if it does not get deleted, so we won't put up an
                 error message.}

                ChDir(GlblProgramDir);
              end;

              If CreateParcelList
                then ParcelListDialog.Show;

                {FXX09071999-6: Tell people that printing is starting and
                                done.}

              DisplayPrintingFinishedMessage(PrintDialog.PrintToFile);
              ResetPrinter(ReportPrinter);
              ProgressDialog.Finish;

              If ExtractToExcel
                then
                  begin
                    CloseFile(ExtractFile);
                    SendTextFileToExcelSpreadsheet(SpreadsheetFileName, True,
                                                   False, '');

                  end;  {If PrintToExcel}

            end;  {If not Quit}

      end;  {If PrintDialog.Execute}

  StartButton.Enabled := True;

end;  {StartButtonClick}

{===================================================================}
{===============  THE FOLLOWING ARE PRINTING PROCEDURES ============}
{===================================================================}
Procedure TTopTaxpayerReportForm.PrintHeaderTabs(Sender : TObject);

begin
  with Sender as TBaseReport do
    begin
      Bold := True;
      ClearTabs;
      SetTab(0.4, pjCenter, 2.0, 0, BoxLineNone, 0);  {Owner}
      SetTab(2.5, pjCenter, 0.5, 0, BoxLineNone, 0);  {Parcel Count}
      SetTab(3.1, pjCenter, 1.2, 0, BoxLineNone, 0);  {Land AV}
      SetTab(4.4, pjCenter, 1.2, 0, BoxLineNone, 0);  {Total AV}
      SetTab(5.7, pjCenter, 1.2, 0, BoxLineNone, 0);  {County taxable}
      SetTab(7.0, pjCenter, 1.2, 0, BoxLineNone, 0);  {Town taxable}
      SetTab(8.3, pjCenter, 1.2, 0, BoxLineNone, 0);  {School Taxable}

        {CHG02242004-3(2.08): Only show selected roll totals.}

      Print(#9 +
            #9 + 'Prcls' +
            #9 + 'Land' +
            #9 + 'Assessed');

       {CHG11162004-4(2.8.1.0)[1977]: Option to only show relevant columns.  If they choose this option,
                                      print in letter mode.}

      If OnlyShowRelevantColumns
        then
          begin
            case ReportType of
              rtAssessedValue : Println('');
              rtCountyTaxable : Println(#9 + 'County');
              rtMunicipalTaxable : Println(#9 + GetMunicipalityTypeName(GlblMunicipalityType));
              rtSchoolTaxable : Println(#9 + 'School');
            end;

          end
        else
          begin
            If (rtdCounty in GlblRollTotalsToShow)
              then Print(#9 + 'County')
              else Print(#9);

            If (rtdMunicipal in GlblRollTotalsToShow)
              then Print(#9 + GetMunicipalityTypeName(GlblMunicipalityType))
              else Print(#9);

            If (rtdSchool in GlblRollTotalsToShow)
              then Println(#9 + 'School')
              else Println(#9);

          end;  {else of If OnlyShowRelevantColumns}

      ClearTabs;
      SetTab(0.4, pjCenter, 2.0, 0, BoxLineBottom, 0);  {Owner}
      SetTab(2.5, pjCenter, 0.5, 0, BoxLineBottom, 0);  {Parcel Count}
      SetTab(3.1, pjCenter, 1.2, 0, BoxLineBottom, 0);  {Land AV}
      SetTab(4.4, pjCenter, 1.2, 0, BoxLineBottom, 0);  {Total AV}
      SetTab(5.7, pjCenter, 1.2, 0, BoxLineBottom, 0);  {County taxable}
      SetTab(7.0, pjCenter, 1.2, 0, BoxLineBottom, 0);  {Town taxable}
      SetTab(8.3, pjCenter, 1.2, 0, BoxLineBottom, 0);  {School Taxable}

        {CHG02242004-3(2.08): Only show selected roll totals.}

      Print(#9 + 'Owner' +
            #9 + 'Owned' +
            #9 + 'Value' +
            #9 + 'Value');

       {CHG11162004-4(2.8.1.0)[1977]: Option to only show relevant columns.  If they choose this option,
                                      print in letter mode.}

      If OnlyShowRelevantColumns
        then
          begin
            If (ReportType = rtAssessedValue)
              then Println('')
              else Println(#9 + 'Taxable');
          end
        else
          begin
            If (rtdCounty in GlblRollTotalsToShow)
              then Print(#9 + 'Taxable')
              else Print(#9);

            If (rtdMunicipal in GlblRollTotalsToShow)
              then Print(#9 + 'Taxable')
              else Print(#9);

            If (rtdSchool in GlblRollTotalsToShow)
              then Println(#9 + 'Taxable')
              else Println(#9);

          end;  {If OnlyShowRelevantColumns}

      Bold := False;
      ClearTabs;
      SetTab(0.4, pjLeft, 2.0, 0, BoxLineNone, 0);  {Owner}
      SetTab(2.5, pjRight, 0.5, 0, BoxLineNone, 0);  {Parcel Count}
      SetTab(3.1, pjRight, 1.2, 0, BoxLineNone, 0);  {Land AV}
      SetTab(4.4, pjRight, 1.2, 0, BoxLineNone, 0);  {Total AV}
      SetTab(5.7, pjRight, 1.2, 0, BoxLineNone, 0);  {County taxable}
      SetTab(7.0, pjRight, 1.2, 0, BoxLineNone, 0);  {Town taxable}
      SetTab(8.3, pjRight, 1.2, 0, BoxLineNone, 0);  {School Taxable}

      CurrentLineNumber := CurrentLineNumber + 2;

    end;  {with Sender as TBaseReport do}

end;  {PrintHeaderTabs}

{===================================================================}
Procedure TTopTaxpayerReportForm.PrintDetailTabs(Sender : TObject);

begin
  with Sender as TBaseReport do
    begin
      Println('');
      Bold := True;
      ClearTabs;
      SetTab(0.6, pjCenter, 1.6, 0, BoxLineNone, 0);  {SwisSBLKey}
      SetTab(2.3, pjCenter, 1.8, 0, BoxLineNone, 0);  {Location}
      SetTab(4.2, pjCenter, 0.1, 0, BoxLineNone, 0);  {Roll sec}
      SetTab(4.4, pjCenter, 0.3, 0, BoxLineNone, 0);  {Prop class}
      SetTab(4.8, pjCenter, 0.9, 0, BoxLineNone, 0);  {Land AV}
      SetTab(5.8, pjCenter, 1.1, 0, BoxLineNone, 0);  {Total AV}
      SetTab(7.0, pjCenter, 1.1, 0, BoxLineNone, 0);  {County taxable}
      SetTab(8.2, pjCenter, 1.1, 0, BoxLineNone, 0);  {Town taxable}
      SetTab(9.4, pjCenter, 1.1, 0, BoxLineNone, 0);  {School Taxable}

        {CHG02242004-3(2.08): Only show selected roll totals.}

      Print(#9 +
            #9 +
            #9 + 'R' +
            #9 + 'Prp' +
            #9 + 'Land' +
            #9 + 'Assessed');

       {CHG11162004-4(2.8.1.0)[1977]: Option to only show relevant columns.  If they choose this option,
                                      print in letter mode.}

      If OnlyShowRelevantColumns
        then
          begin
            case ReportType of
              rtAssessedValue : Println('');
              rtCountyTaxable : Println(#9 + 'County');
              rtMunicipalTaxable : Println(#9 + GetMunicipalityTypeName(GlblMunicipalityType));
              rtSchoolTaxable : Println(#9 + 'School');
            end;

          end
        else
          begin
            If (rtdCounty in GlblRollTotalsToShow)
              then Print(#9 + 'County')
              else Print(#9);

            If (rtdMunicipal in GlblRollTotalsToShow)
              then Print(#9 + GetMunicipalityTypeName(GlblMunicipalityType))
              else Print(#9);

            If (rtdSchool in GlblRollTotalsToShow)
              then Println(#9 + 'School')
              else Println(#9);

          end;  {else of If OnlyShowRelevantColumns}

      ClearTabs;
      SetTab(0.6, pjCenter, 1.6, 0, BoxLineBottom, 0);  {SwisSBLKey}
      SetTab(2.3, pjCenter, 1.8, 0, BoxLineBottom, 0);  {Location}
      SetTab(4.2, pjCenter, 0.1, 0, BoxLineBottom, 0);  {Roll sec}
      SetTab(4.4, pjCenter, 0.3, 0, BoxLineBottom, 0);  {Prop class}
      SetTab(4.8, pjCenter, 0.9, 0, BoxLineBottom, 0);  {Land AV}
      SetTab(5.8, pjCenter, 1.1, 0, BoxLineBottom, 0);  {Total AV}
      SetTab(7.0, pjCenter, 1.1, 0, BoxLineBottom, 0);  {County taxable}
      SetTab(8.2, pjCenter, 1.1, 0, BoxLineBottom, 0);  {Town taxable}
      SetTab(9.4, pjCenter, 1.1, 0, BoxLineBottom, 0);  {School Taxable}

        {CHG02242004-3(2.08): Only show selected roll totals.}

      Print(#9 + 'Parcel ID' +
            #9 + 'Location' +
            #9 + 'S' +
            #9 + 'Cls' +
            #9 + 'Value' +
            #9 + 'Value');

       {CHG11162004-4(2.8.1.0)[1977]: Option to only show relevant columns.  If they choose this option,
                                      print in letter mode.}

      If OnlyShowRelevantColumns
        then
          begin
            If (ReportType = rtAssessedValue)
              then Println('')
              else Println(#9 + 'Taxable');
          end
        else
          begin
            If (rtdCounty in GlblRollTotalsToShow)
              then Print(#9 + 'Taxable')
              else Print(#9);

            If (rtdMunicipal in GlblRollTotalsToShow)
              then Print(#9 + 'Taxable')
              else Print(#9);

            If (rtdSchool in GlblRollTotalsToShow)
              then Println(#9 + 'Taxable')
              else Println(#9);

          end;  {else of If OnlyShowRelevantColumns}

      Bold := False;
      ClearTabs;
      SetTab(0.6, pjLeft, 1.6, 0, BoxLineNone, 0);  {SwisSBLKey}
      SetTab(2.3, pjLeft, 1.8, 0, BoxLineNone, 0);  {Location}
      SetTab(4.2, pjLeft, 0.1, 0, BoxLineNone, 0);  {Roll sec}
      SetTab(4.4, pjLeft, 0.3, 0, BoxLineNone, 0);  {Prop class}
      SetTab(4.8, pjRight, 0.9, 0, BoxLineNone, 0);  {Land AV}
      SetTab(5.8, pjRight, 1.1, 0, BoxLineNone, 0);  {Total AV}
      SetTab(7.0, pjRight, 1.1, 0, BoxLineNone, 0);  {County taxable}
      SetTab(8.2, pjRight, 1.1, 0, BoxLineNone, 0);  {Town taxable}
      SetTab(9.4, pjRight, 1.1, 0, BoxLineNone, 0);  {School Taxable}

      CurrentLineNumber := CurrentLineNumber + 3;

    end;  {with Sender as TBaseReport do}

end;  {PrintDetailTabs}

{===================================================================}
Procedure TTopTaxpayerReportForm.ReportHeader(Sender: TObject);

{FXX09081999-5: Add in year of printing and skip one line at beginning.}

var
  TempStr : String;

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
      SetFont('Times New Roman',12);
      Bold := True;
      Home;
      PrintCenter('Top Tax Payers Report', (PageWidth / 2));
      Bold := False;
      CRLF;
      CRLF;

      SetFont('Times New Roman',10);

      ClearTabs;
      SetTab(0.4, pjLeft, 2.0, 0, BoxLineNone, 0);  {SwisSBLKey}
      Bold := True;

      case AssessmentYearRadioGroup.ItemIndex of
        0 : TempStr := 'This Year';
        1 : TempStr := 'Next Year';
      end;  {case AssessmentYearRadioGroup.ItemIndex of}

      Print(#9 + 'Assessment Year: ' + TempStr);
      Bold := False;

      If (SchoolCodeListBox.Items.Count <> SelectedSchoolCodes.Count)
        then
          begin
            Bold := True;
            Print(#9 + 'School Code(s): ');
            Bold := False;
            Println(ConvertStringListToString(SelectedSchoolCodes, ' '));
            CurrentLineNumber := CurrentLineNumber + 1;

          end;  {If (SchoolCodeListBox.Items.Count <> ...}

      If (SwisCodeListBox.Items.Count <> SelectedSwisCodes.Count)
        then
          begin
            Bold := True;
            Print(#9 + 'Swis Code(s): ');
            Bold := False;
            Println(ConvertStringListToString(SelectedSwisCodes, ' '));
            CurrentLineNumber := CurrentLineNumber + 1;

          end;  {If (SwisCodeListBox.Items.Count <> ...}

      Println('');

      CurrentLineNumber := CurrentLineNumber + 3;

    end;  {with Sender as TBaseReport do}

end;  {ReportFilerPrintHeader}

{===================================================================}
Procedure TTopTaxpayerReportForm.ReportPrint(Sender: TObject);

var
  Quit, Done, FirstItemOnPage, FirstTimeThrough,
  DoneDetails, FirstTimeThroughDetails, FirstDetailItemOnPage : Boolean;
  RecCount : LongInt;

begin
  RecCount := 1;
  Done := False;
  FirstTimeThrough := True;
  Quit := False;
  FirstItemOnPage := True;

  SortHeaderTable.First;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else SortHeaderTable.Next;

    If (SortHeaderTable.EOF or
        (RecCount > NumberOfTaxpayersToShow))
      then Done := True;

    ProgressDialog.Update(Self, SortHeaderTable.FieldByName('Owner').Text);
    Application.ProcessMessages;

    If not Done
      then
        with Sender as TBaseReport do
          begin
            RecCount := RecCount + 1;

            If (CurrentLineNumber > (NumLinesPerPage - (LinesAtBottom + 6)))
              then
                begin
                  CurrentLineNumber := 0;
                  NewPage;
                  FirstItemOnPage := True;
                end;

            If FirstItemOnPage
              then
                begin
                  PrintHeaderTabs(Sender);
                  FirstItemOnPage := False;
                end;

            with SortHeaderTable do
              begin
                Print(#9 + Take(20, FieldByName('Owner').Text) +
                      #9 + FormatFloat(IntegerDisplay,
                                       FieldByName('ParcelCount').AsInteger) +
                      #9 + FormatFloat(IntegerDisplay,
                                       FieldByName('LandAssessedVal').AsInteger) +
                      #9 + FormatFloat(IntegerDisplay,
                                       FieldByName('TotalAssessedVal').AsInteger));

                   {CHG02242004-3(2.08): Only show selected roll totals.}

                   {CHG11162004-4(2.8.1.0)[1977]: Option to only show relevant columns.  If they choose this option,
                                                  print in letter mode.}

                  If OnlyShowRelevantColumns
                    then
                      begin
                        case ReportType of
                          rtAssessedValue : Println('');
                          rtCountyTaxable : Println(#9 + FormatFloat(IntegerDisplay,
                                                                     FieldByName('CountyTaxableValue').AsInteger));
                          rtMunicipalTaxable : Println(#9 + FormatFloat(IntegerDisplay,
                                                                        FieldByName('TownTaxableValue').AsInteger));
                          rtSchoolTaxable : Println(#9 + FormatFloat(IntegerDisplay,
                                                                     FieldByName('SchoolTaxableValue').AsInteger));
                        end;
                      end
                    else
                      begin
                        If (rtdCounty in GlblRollTotalsToShow)
                          then Print(#9 + FormatFloat(IntegerDisplay,
                                                      FieldByName('CountyTaxableValue').AsInteger))
                          else Print(#9);

                        If (rtdMunicipal in GlblRollTotalsToShow)
                          then Print(#9 + FormatFloat(IntegerDisplay,
                                                      FieldByName('TownTaxableValue').AsInteger))
                          else Print(#9);

                        If (rtdSchool in GlblRollTotalsToShow)
                          then Println(#9 + FormatFloat(IntegerDisplay,
                                                        FieldByName('SchoolTaxableValue').AsInteger))
                          else Println('');

                      end;  {else of If OnlyShowRelevantColumns}

                CurrentLineNumber := CurrentLineNumber + 1;

                {CHG02242004-1(2.08): Option to print to Excel.}

              If ExtractToExcel
                then
                  begin
                    If ShowDetails
                      then PrintExcelReportSummaryHeader(ExtractFile);

                    Write(ExtractFile, FieldByName('Owner').Text,
                                       FormatExtractField(FieldByName('ParcelCount').Text),
                                       FormatExtractField(FormatFloat(IntegerDisplay,
                                                                      FieldByName('LandAssessedVal').AsInteger)),
                                       FormatExtractField(FormatFloat(IntegerDisplay,
                                                                      FieldByName('TotalAssessedVal').AsInteger)));

                    If (rtdCounty in GlblRollTotalsToShow)
                      then Write(ExtractFile, FormatExtractField(FormatFloat(NoDecimalDisplay_BlankZero,
                                                                             FieldByName('CountyTaxableValue').AsFloat)));

                    If (rtdMunicipal in GlblRollTotalsToShow)
                      then Write(ExtractFile, FormatExtractField(FormatFloat(NoDecimalDisplay_BlankZero,
                                                                             FieldByName('TownTaxableValue').AsFloat)));

                    If (rtdSchool in GlblRollTotalsToShow)
                      then Writeln(ExtractFile, FormatExtractField(FormatFloat(NoDecimalDisplay_BlankZero,
                                                                               FieldByName('SchoolTaxableValue').AsFloat)))
                      else Writeln(ExtractFile);

                  end;  {If ExtractToExcel}

              end;  {with SortHeaderTable do}

            If ShowDetails
              then
                begin
                  SortDetailTable.CancelRange;
                  SetRangeOld(SortDetailTable, ['OwnerKey', 'SwisSBLKey'],
                              [SortHeaderTable.FieldByName('OwnerKey').Text, ''],
                              [SortHeaderTable.FieldByName('OwnerKey').Text, ConstStr('Z', 26)]);
                  FirstTimeThroughDetails := True;
                  DoneDetails := False;
                  FirstDetailItemOnPage := True;

                  repeat
                    If FirstTimeThroughDetails
                      then FirstTimeThroughDetails := False
                      else SortDetailTable.Next;

                    If SortDetailTable.EOF
                      then DoneDetails := True;

                    Application.ProcessMessages;

                    If CreateParcelList
                      then ParcelListDialog.AddOneParcel(SortDetailTable.FieldByName('SwisSBLKey').Text);

                    If not DoneDetails
                      then
                        begin
                          If (CurrentLineNumber > (NumLinesPerPage - (LinesAtBottom + 6)))
                            then
                              begin
                                CurrentLineNumber := 0;
                                NewPage;

                                PrintDetailTabs(Sender);
                                If _Compare(CurrentPage, 1, coGreaterThan)
                                  then Println(#9 + '(continued)');

                              end
                            else
                              If FirstDetailItemOnPage
                                then PrintDetailTabs(Sender);

                          with SortDetailTable do
                            begin
                              Print(#9 + Take(16, ConvertSwisSBLToDashDot(FieldByName('SwisSBLKey').Text)) +
                                    #9 + FieldByName('Location').Text +
                                    #9 + FieldByName('RollSection').Text +
                                    #9 + FieldByName('PropertyClass').Text +
                                    #9 + FormatFloat(IntegerDisplay,
                                                     FieldByName('LandAssessedVal').AsInteger) +
                                    #9 + FormatFloat(IntegerDisplay,
                                                     FieldByName('TotalAssessedVal').AsInteger));

                               {CHG02242004-3(2.08): Only show selected roll totals.}
                               {CHG11162004-4(2.8.1.0)[1977]: Option to only show relevant columns.  If they choose this option,
                                                              print in letter mode.}

                              If OnlyShowRelevantColumns
                                then
                                  begin
                                    case ReportType of
                                      rtAssessedValue : Println('');
                                      rtCountyTaxable : Println(#9 + FormatFloat(IntegerDisplay,
                                                                                 FieldByName('CountyTaxableValue').AsInteger));
                                      rtMunicipalTaxable : Println(#9 + FormatFloat(IntegerDisplay,
                                                                                    FieldByName('TownTaxableValue').AsInteger));
                                      rtSchoolTaxable : Println(#9 + FormatFloat(IntegerDisplay,
                                                                                 FieldByName('SchoolTaxableValue').AsInteger));
                                    end;
                                  end
                                else
                                  begin
                                    If (rtdCounty in GlblRollTotalsToShow)
                                      then Print(#9 + FormatFloat(IntegerDisplay,
                                                                  FieldByName('CountyTaxableValue').AsInteger))
                                      else Print(#9);

                                    If (rtdMunicipal in GlblRollTotalsToShow)
                                      then Print(#9 + FormatFloat(IntegerDisplay,
                                                                  FieldByName('TownTaxableValue').AsInteger))
                                      else Print(#9);

                                    If (rtdSchool in GlblRollTotalsToShow)
                                      then Println(#9 + FormatFloat(IntegerDisplay,
                                                                    FieldByName('SchoolTaxableValue').AsInteger))
                                      else Println('');

                                  end;  {else of If OnlyShowRelevantColumns}

                              CurrentLineNumber := CurrentLineNumber + 1;

                                {CHG02242004-1(2.08): Option to print to Excel.}

                              If ExtractToExcel
                                then
                                  begin
                                    PrintExcelReportDetailHeader(ExtractFile);

                                    Write(ExtractFile, ConvertSwisSBLToDashDot(FieldByName('SwisSBLKey').Text),
                                                       FormatExtractField(FieldByName('Location').Text),
                                                       FormatExtractField(FieldByName('RollSection').Text),
                                                       FormatExtractField(FieldByName('PropertyClass').Text),
                                                       FormatExtractField(FormatFloat(IntegerDisplay,
                                                                                      FieldByName('LandAssessedVal').AsInteger)),
                                                       FormatExtractField(FormatFloat(IntegerDisplay,
                                                                                      FieldByName('TotalAssessedVal').AsInteger)));

                                    If (rtdCounty in GlblRollTotalsToShow)
                                      then Write(ExtractFile, FormatExtractField(FormatFloat(NoDecimalDisplay_BlankZero,
                                                                                             FieldByName('CountyTaxableValue').AsFloat)));

                                    If (rtdMunicipal in GlblRollTotalsToShow)
                                      then Write(ExtractFile, FormatExtractField(FormatFloat(NoDecimalDisplay_BlankZero,
                                                                                             FieldByName('TownTaxableValue').AsFloat)));

                                    If (rtdSchool in GlblRollTotalsToShow)
                                      then Writeln(ExtractFile, FormatExtractField(FormatFloat(NoDecimalDisplay_BlankZero,
                                                                                               FieldByName('SchoolTaxableValue').AsFloat)))
                                      else Writeln(ExtractFile);

                                  end;  {If ExtractToExcel}

                            end;  {with SortDetailTable do}

                        end;  {If not DoneDetails}

                    FirstDetailItemOnPage := False;

                  until DoneDetails;

                  Println('');
                  FirstItemOnPage := True;

                end;  {If ShowDetails}

          end;  {with Sender as TBaseReport do}

    ReportCancelled := ProgressDialog.Cancelled;

  until (Done or Quit or ReportCancelled);

end;  {ReportPrint}

{===================================================================}
Procedure TTopTaxpayerReportForm.FormClose(    Sender: TObject;
                                           var Action: TCloseAction);

begin
  CloseTablesForForm(Self);

  SelectedSwisCodes.Free;

    {Free up the child window and set the ClosingAForm Boolean to
     true so that we know to delete the tab.}

  Action := caFree;
  GlblClosingAForm := True;
  GlblClosingFormCaption := Caption;

end;  {FormClose}


end.