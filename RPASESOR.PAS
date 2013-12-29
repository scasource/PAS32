unit Rpasesor;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, DBCtrls, DBTables, DB, Buttons, Grids, Printers,
  Wwdbigrd, Wwdbgrid, ExtCtrls, Wwtable, Wwdatsrc, Menus, RPCanvas,
  RPrinter, RPBase, RPFiler, Types, RPDefine, Progress, Zipcopy, RPTXFilr,
  ComCtrls, wwdbedit, Wwdotdot, Wwdbcomb, Mask;

type
  AssessorsReportTotalsRecord = record
    TotalRS1 : LongInt;
    TotalRS3 : LongInt;
    TotalRS5 : LongInt;
    TotalRS6 : LongInt;
    TotalRS7 : LongInt;
    TotalRS8 : LongInt;
    TotalPhysInc : LongInt;
    TotalEqInc : LongInt;
    TotalPhysDec : LongInt;
    TotalEqDec : LongInt;
    TotalClass100 : LongInt;
    TotalClass100Parcels : LongInt;
    TotalClass200a : LongInt;
    TotalClass200aParcels : LongInt;
    TotalClass200b : LongInt;
    TotalClass200bParcels : LongInt;
    TotalClass200c : LongInt;
    TotalClass200cParcels : LongInt;
    TotalClass300 : LongInt;
    TotalClass300Parcels : LongInt;
    TotalClass400 : LongInt;
    TotalClass400Parcels : LongInt;
    TotalClass500 : LongInt;
    TotalClass500Parcels : LongInt;
    TotalClass600 : LongInt;
    TotalClass600Parcels : LongInt;
    TotalClass700 : LongInt;
    TotalClass700Parcels : LongInt;
    TotalClass800 : LongInt;
    TotalClass800Parcels : LongInt;
    TotalClass900 : LongInt;
    TotalClass900Parcels : LongInt;

  end;  {AssessorsReportTotalsRecord}

  TAssessorsReportForm = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    TitleLabel: TLabel;
    ParcelTable: TTable;
    AssessmentTable: TTable;
    SwisCodeTable: TTable;
    PrintDialog: TPrintDialog;
    ReportFiler: TReportFiler;
    ReportPrinter: TReportPrinter;
    SortTotalAssessedValTable: TTable;
    SortAssessedValChangesTable: TTable;
    SortAVByPropClass_RS_Table: TTable;
    AssessmentYearCtlFile: TTable;
    SchoolTable: TTable;
    ClassTable: TTable;
    ParcelExemptionTable: TTable;
    EXCodeTable: TTable;
    SortExemptionTable: TTable;
    Label22: TLabel;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    ZipCopyDlg: TZipCopyDlg;
    SortComputedChangesTable: TTable;
    SortSummaryTable: TTable;
    SortAVChangesTable: TTable;
    TextFiler: TTextFiler;
    ScrollBox1: TScrollBox;
    Label5: TLabel;
    CloseButton: TBitBtn;
    StartButton: TBitBtn;
    LoadButton: TBitBtn;
    SaveButton: TBitBtn;
    ReportPageControl: TPageControl;
    OptionsTabSheet: TTabSheet;
    Label9: TLabel;
    SwisCodeListBox: TListBox;
    MiscellaneousOptionsGroupBox: TGroupBox;
    Label16: TLabel;
    Label13: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    RPS225Label: TLabel;
    Label6: TLabel;
    Label10: TLabel;
    Label24: TLabel;
    ReportComputedChangeCheckBox: TCheckBox;
    PrintTotalsByBlockCheckBox: TCheckBox;
    PrintMunicipalCodeListingCheckBox: TCheckBox;
    PrintTransmittalLetterCheckBox: TCheckBox;
    RPS225ReportRunCheckBox: TCheckBox;
    CreateParcelListOfOOBParcelsCheckBox: TCheckBox;
    IncludeInventoryCheckBox: TCheckBox;
    AttributeInactivationsOrNewParcelsToPhysicalCheckBox: TCheckBox;
    PrintingOptionsTabSheet: TTabSheet;
    Label1: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label2: TLabel;
    EditSectionTop: TDBEdit;
    EditLeftMargin: TDBEdit;
    EditPrinterOrientation: TDBRadioGroup;
    PaperSizeComboBox: TwwDBComboBox;
    OverridePrinterDefaultsCheckBox: TCheckBox;
    PrinterComboBox: TComboBox;
    PrinterSettingsTable: TwwTable;
    PrintToScreenCheckBox: TCheckBox;
    PrinterSettingsDataSource: TwwDataSource;
    Label3: TLabel;
    AttributeNonPhysicalChangeToEqualizationCheckBox: TCheckBox;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure StartButtonClick(Sender: TObject);
    procedure TextReportPrint(Sender: TObject);
    procedure LoadButtonClick(Sender: TObject);
    procedure SaveButtonClick(Sender: TObject);
    procedure ReportPrint(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure PrinterComboBoxChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    UnitName : String;
    FormAccessRights : Integer;  {Read only or read write, based on security level?}
                                {Values = raReadOnly, raReadWrite}
    PriorYear : String;  {What is the first year before ThisYear?}

    PriorProcessingType,
    CurrentProcessingType : Integer;
    PriorAssessmentYear,
    CurrentAssessmentYear : String;

    CountyTownCode : String;
    SelectedSwisCodes : TStringList;
    RPS225ReportRun, ReportBalanced, CreateParcelList : Boolean;

    OrigSortValChgFileName,
    OrigSortAVPC_RSFileName,
    OrigSortTotValFileName,
    OrigSortEXFileName,
    OrigSortComputedChangesFileName,
    OrigSortSummaryFileName,
    OrigSortAVChangesFileName : String;
    AttributeImbalancesToEqualization : Boolean;

    IncludeInventory, AttributeInactivationsOrNewParcelsToPhysicalChange : Boolean;

    Procedure InitializeForm;  {Open the tables and setup.}

    Procedure PrintReportHeader(Sender : TObject;
                                ReportTime : TDateTime;
                                PageNum : Integer;
                                PartName,
                                SubHeader : String;
                                SwisCode : String);
    {Print the overall report header.}

    Procedure CalculateTotalValues(    RecType,  {(S)wis or S(c)hool}
                                       RollSection : Char;
                                       AllMunicipalityCodes : Boolean;  {The total of all Swis or school codes or}
                                       MunicipalityCode : String;  {Just this municipality code}
                                   var PriorTotal,
                                       CurrentTotal,
                                       EqualizationIncrease,
                                       EqualizationDecrease,
                                       PhysicalQtyIncrease,
                                       PhysicalQtyDecrease : Comp;
                                   var Quit : Boolean);
    {Sort procedure for printing part 1 section 1.}

    Procedure PrintPart1Section1(    Sender : TObject;
                                     ReportTime : TDateTime;
                                 var TotalEqualizationIncrease,
                                     TotalPhysicalQtyIncrease,
                                     TotalEqualizationDecrease,
                                     TotalPhysicalQtyDecrease,
                                     PriorAssessedValue : Comp;
                                 var PageNum : Integer;
                                 var Quit : Boolean);
    {This section is the first part which gives overall prior and assessed
     value breakdowns and total increase and decreases due to equalization
     and physical change.}

     Procedure PrintPart1Section2(    Sender : TObject;
                                      ReportTime : TDateTime;
                                      AssessmentFactorChange : Double;
                                      MunicipalityHasVillages : Boolean;
                                  var PageNum : Integer;
                                  var Quit : Boolean);
     {Print the homestead status of the municipality, assessing status of the
      villages and change in assessment factor.}

    Procedure PrintPart1Section3(    Sender : TObject;
                                     ReportTime : TDateTime;
                                 var PageNum : Integer;
                                 var Quit : Boolean);
    {Print the agricultural penalty tax reporting prose.}

    Procedure PrintPart1Section4(    Sender : TObject;
                                     ReportTime : TDateTime;
                                 var PageNum : Integer;
                                 var Quit : Boolean);
    {Print the names and addresses section.}

    Procedure PrintPart1Section5(    Sender : TObject;
                                 var Quit : Boolean);
    {Print the verification and signature lines.}

    Procedure PrintARTotalsSection1(    Sender : TObject;
                                        ReportTime : TDateTime;
                                    var PageNum : Integer;
                                    var Quit : Boolean);
    {Print the AR totals section 1, i.e. the property class breakdown.}

    Procedure PrintARTotalsSections2And3(    Sender : TObject;
                                         var Quit : Boolean);
    {Print the AR totals section 2, i.e. the roll section breakdown.}
    {We will put one line per roll section (except 9).}
    {Also print AR totals section 3 - just a 1 line total.}

    Procedure PrintARSection4Or5Subheader(Sender : TObject;
                                          MunicipalityCode : String;
                                          MunicipalityName : String);
    {Print the informational section 4 and 5 sub header with
     school or swis code and school or swis name.}

    Procedure PrintARSection4Header(Sender : TObject);
    {Print the header for AR section 4 - totals by school code.}

    Procedure PrintARSection4Or5Entry(Sender : TObject;
                                      SwisCodeTable : TTable;
                                      RS1PriorHomesteadVal,
                                      RS1PriorNonhomesteadVal,
                                      RS1CurrentHomesteadVal,
                                      RS1CurrentNonhomesteadVal,
                                      RS6PriorHomesteadVal,
                                      RS6PriorNonhomesteadVal,
                                      RS6CurrentHomesteadVal,
                                      RS6CurrentNonhomesteadVal : Comp);
    {Print the information for one swis or school code.}

    Procedure PrintARTotalsSection4(    Sender : TObject;
                                        ReportTime : TDateTime;
                                    var PageNum : Integer;
                                    var Quit : Boolean);
    {Print the AR totals section 4, i.e. the homestead\nonhomestead
     totals breakdown for schools.}

    Procedure PrintARSection5Header(Sender : TObject);
    {Print the header for AR section 5 - totals by swis code.}

    Procedure PrintARTotalsSection5(    Sender : TObject;
                                        ReportTime : TDateTime;
                                    var PageNum : Integer;
                                    var Quit : Boolean);
    {Print the AR totals section 5, i.e. the homestead\nonhomestead
     totals breakdown for villages, town-outside.}

    Procedure PrintSection6Totals(Sender : TObject;
                                  PortionType,
                                  MunicipalityCode,
                                  MunicipalityName : String;
                                  HstdPhysicalQtyIncrease,
                                  HstdEqualizationIncrease,
                                  HstdPhysicalQtyDecrease,
                                  HstdEqualizationDecrease,
                                  HstdPriorAssessed,
                                  HstdCurrentAssessed,
                                  NonhstdPhysicalQtyIncrease,
                                  NonhstdEqualizationIncrease,
                                  NonhstdPhysicalQtyDecrease,
                                  NonhstdEqualizationDecrease,
                                  NonhstdPriorAssessed,
                                  NonhstdCurrentAssessed : Comp);
    {Print one entry for the totals by portion.}

    Procedure PrintARTotalsSection6(    Sender : TObject;
                                        ReportTime : TDateTime;
                                    var PageNum : Integer;
                                    var Quit : Boolean);
    {Print the AR totals section 6, i.e. the homestead\nonhomestead
     totals breakdown by portion.}

    Procedure PrintSection7Subheader(Sender : TObject;
                                     SwisCode : String);

    Procedure PrintARTotalsSection7(    Sender : TObject;
                                        ReportTime : TDateTime;
                                    var PageNum : Integer;
                                    var Quit : Boolean);
    {Print the new AR totals section 7, i.e. by swis \ block.}

    Procedure PrintSwisTotals(    Sender : TObject;
                                  SwisCode : String;
                                  PriorAssessedVal,
                                  CurrAssessedVal,
                                  EqualizationIncrease,
                                  EqualizationDecrease,
                                  PhysicalQtyIncrease,
                                  PhysicalQtyDecrease : Comp;
                                  OverallTotal : Boolean;
                                  ReportTime : TDateTime;
                                  PartName,
                                  Subheader : String;
                              var PageNum : Integer);
    {Print the detail assessment changes for one swis.}

    Procedure PrintARPart2DetailChanges(    Sender : TObject;
                                            Part1TotalEqualizationIncrease,
                                            Part1TotalPhysicalQtyIncrease,
                                            Part1TotalEqualizationDecrease,
                                            Part1TotalPhysicalQtyDecrease : Comp;
                                            ReportTime : TDateTime;
                                        var PageNum : Integer;
                                        var Quit : Boolean);
    {Print part 2 - the AR detail changes.}

    Procedure PrintExemptionSummary(    Sender : TObject;
                                        ReportTime : TDateTime;
                                    var PageNum : Integer;
                                    var Quit : Boolean);
    {Print the exemption summary listing - on line per ex code.}

    Procedure GetTransmittalLetterTotals(    _RecType : Char;  {(S)wis, S(c)hool}
                                             _MunicipalityCode : String;
                                         var HstdTaxableVal,
                                             NonhstdTaxableVal : Comp;
                                         var Quit : Boolean);
    {Get the taxable values for this rec type and municipality code.}

    Procedure PrintTransmittalLetter(    Sender : TObject;
                                         ReportTime : TDateTime;
                                     var PageNum : Integer;
                                     var Quit : Boolean);
    {Print the transmittal letter - taxable values by portion.}

  end;

implementation

uses GlblVars, WinUtils, Utilitys, PASUTILS, UTILEXSD,  GlblCnst, PasTypes,
     RPASRUTL, {Utility to fill sort files for assessor's report since code seg too big}
     RPS995EX,  {To generate the 210T1}
     Prog,
     RptDialg,
     Preview, Prcllist;  {Report preview form}

{$R *.DFM}

{========================================================}
Procedure TAssessorsReportForm.FormActivate(Sender: TObject);

begin
  SetFormStateMaximized(Self);
end;

{========================================================}
Procedure TAssessorsReportForm.InitializeForm;

var
  FirstTimeThrough, Done, Quit : Boolean;
  TempYear, I : Integer;

begin
  Quit := False;
  UnitName := 'RPASESOR.PAS';  {mmm}

  TempYear := StrToInt(GlblThisYear);
  PriorYear := IntToStr(TempYear - 1);

    {FXX08121998-1: In Westchester county, assessor report compares TY to NY.  Everywhere else, prior
                    year to TY.}

  If GlblIsWestchesterCounty
    then
      begin
          {FXX09081998-1: The prior types are prior just like other municipalities.}

        PriorProcessingType := History;
        CurrentProcessingType := NextYear;
        PriorAssessmentYear := PriorYear;
        CurrentAssessmentYear := GlblNextYear;
      end
    else
      begin
        PriorProcessingType := History;
        CurrentProcessingType := ThisYear;
        PriorAssessmentYear := PriorYear;
        CurrentAssessmentYear := GlblThisYear;
      end;

  OpenTableForProcessingType(SwisCodeTable, SwisCodeTableName,
                             CurrentProcessingType, Quit);

    {Fill in the swis code list.}

  SwisCodeTable.First;

  FirstTimeThrough := True;
  Done := False;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else SwisCodeTable.Next;

    If SwisCodeTable.EOF
      then Done := True;

    If not Done
      then SwisCodeListBox.Items.Add(SwisCodeTable.FieldByName('SwisCode').Text);

  until Done;

    {Default to all swis codes.}

  For I := 0 to (SwisCodeListBox.Items.Count - 1) do
    SwisCodeListBox.Selected[I] := True;

    {CHG02282000-1: Add fields for 225 run.}

  If GlblMunicipalityUsesTwoTaxRates
    then
      begin
        RPS225Label.Visible := True;
        RPS225ReportRunCheckBox.Visible := True;
        RPS225ReportRunCheckBox.Checked := True;
      end;

  OrigSortValChgFileName := SortAssessedValChangesTable.TableName;
  OrigSortAVPC_RSFileName := SortAVByPropClass_RS_Table.TableName;
  OrigSortTotValFileName := SortTotalAssessedValTable.TableName;
  OrigSortEXFileName := SortExemptionTable.TableName;
  OrigSortComputedChangesFileName := SortComputedChangesTable.TableName;
  OrigSortSummaryFileName := SortSummaryTable.TableName;
  OrigSortAVChangesFileName := SortAVChangesTable.TableName;

  PrinterComboBox.Items.Assign(Printer.Printers);
  PrinterComboBox.Text := Printer.Printers[Printer.PrinterIndex];
  PrinterComboBoxChange(PrinterComboBox);

  try
    PrinterSettingsTable.TableName := PrinterSettingsTableName;
    PrinterSettingsTable.Open;
    FindKeyOld(PrinterSettingsTable, ['ReportName'], ['ASSESSORSREPORT']);
  except
    PrintingOptionsTabSheet.TabVisible := False;
  end;

end;  {InitializeForm}

{====================================================================}
Procedure TAssessorsReportForm.PrinterComboBoxChange(Sender: TObject);

begin
  ReportPrinter.SelectPrinter(PrinterComboBox.Text);
  PaperSizeComboBox.Items.Assign(ReportPrinter.Papers);
  PaperSizeComboBox.ItemIndex := 0;

end;  {PrinterComboBoxChange}

{====================================================================}
Procedure TAssessorsReportForm.SaveButtonClick(Sender: TObject);

{FXX04091999-8: Add ability to save and load search report options.}

begin
  SaveReportOptions(Self, OpenDialog, SaveDialog, 'Assessor.asr', 'Assessor''s Report');

end;  {SaveButtonClick}

{====================================================================}
Procedure TAssessorsReportForm.LoadButtonClick(Sender: TObject);

{FXX04091999-8: Add ability to save and load search report options.}

begin
  LoadReportOptions(Self, OpenDialog, 'Assessor.asr', 'Assessor''s Report');

end;  {LoadButtonClick}

{===================================================================}
Procedure TAssessorsReportForm.StartButtonClick(Sender: TObject);

var
  FinishDialog, Quit,
  PrintToScreen, OverridePrintingDefaults : Boolean;
  SortValChgFileName,
  SortAVPC_RSFileName,
  SortTotValFileName,
  SortEXFileName,
  SortComputedChangesFileName,
  SortSummaryFileName,
  NewFileName, TextFileName : String;
  I, LinesAtBottom, NumLinesPerPage : Integer;
  slSelectedRollSections : TStringList;

begin
  Quit := False;
  ReportCancelled := False;
  ReportBalanced := False;
  SelectedSwisCodes := TStringList.Create;
  CreateParcelList := CreateParcelListOfOOBParcelsCheckBox.Checked;
  IncludeInventory := IncludeInventoryCheckBox.Checked;
  slSelectedRollSections := TStringList.Create;
  slSelectedRollSections.Add('1');
  slSelectedRollSections.Add('3');
  slSelectedRollSections.Add('5');
  slSelectedRollSections.Add('6');
  slSelectedRollSections.Add('7');
  slSelectedRollSections.Add('8');
  slSelectedRollSections.Add('9');

  AttributeInactivationsOrNewParcelsToPhysicalChange := AttributeInactivationsOrNewParcelsToPhysicalCheckBox.Checked;

    {CHG04152004-1(2.07l3): Attribute out of balance extra value to equalization.}

  AttributeImbalancesToEqualization := AttributeNonPhysicalChangeToEqualizationCheckBox.Checked;

    {CHG12182003-1(2.07l): Add printing default options.}

  OverridePrintingDefaults := OverridePrinterDefaultsCheckBox.Checked;

  with SwisCodeListBox do
    For I := 0 to (Items.Count - 1) do
      If Selected[I]
        then SelectedSwisCodes.Add(Items[I]);

    {CHG10121998-1: Add user options for default destination and show vet max msg.}

  SetPrintToScreenDefault(PrintDialog);

    {FXX09301998-1: Disable print button after clicking to avoid clicking twice.}

  StartButton.Enabled := False;
  Application.ProcessMessages;

  If PrintDialog.Execute
    then
      begin
        If CreateParcelList
          then ParcelListDialog.ClearParcelGrid(True);

          {CHG02282000-1: Add fields for 225 run.}

        RPS225ReportRun := RPS225ReportRunCheckBox.Checked;

          {CHG10131998-1: Set the printer settings based on what printer they selected
                          only - they no longer need to worry about paper or landscape
                          mode.}


        If OverridePrintingDefaults
          then
            begin
              If PrinterSettingsTable.Modified
                then
                  try
                    PrinterSettingsTable.Post;
                  except
                  end;

              SetPrinterOverrides(PrinterSettingsTable, ReportPrinter, ReportFiler,
                                  PrintToScreenCheckBox, PrintToScreen,
                                  LinesAtBottom, NumLinesPerPage);

            end
          else
            begin
              AssignPrinterSettings(PrintDialog, ReportPrinter, ReportFiler, [ptBoth], True, Quit);
              PrintToScreen := PrintDialog.PrintToFile;

                {CHG04072004-1(2.07l3): Allow for printing to letter size paper.}

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

                        ReportPrinter.ScaleX := 80;
                        ReportPrinter.ScaleY := 78;
                        ReportPrinter.SectionLeft := 1.5;
                        ReportFiler.ScaleX := 80;
                        ReportFiler.ScaleY := 78;
                        ReportFiler.SectionLeft := 1.5;

                      end;  {If (MessageDlg('Do you want to...}

            end;  {else of If OverridePrintingDefaults}

        OpenTableForProcessingType(SchoolTable, SchoolCodeTableName,
                                   ThisYear, Quit);
        OpenTableForProcessingType(AssessmentYearCtlFile, AssessmentYearControlTableName,
                                   ThisYear, Quit);

          {Copy the sort tables to a temp file and open them.}
          {FXX01231998-3: Use sort file name proc to determine sort file
                          names.}

        CopyAndOpenSortFile(SortTotalAssessedValTable, 'AssessorRptTotalAV',
                            OrigSortTotValFileName, SortTotValFileName,
                            True, True, Quit);

        CopyAndOpenSortFile(SortAssessedValChangesTable, 'AssessorRptValueChanges',
                            OrigSortValChgFileName, SortValChgFileName,
                            True, True, Quit);

        CopyAndOpenSortFile(SortAVByPropClass_RS_Table, 'AssessorRptByPropClass_RS',
                            OrigSortAVPC_RSFileName, SortAVPC_RSFileName,
                            True, True, Quit);

        CopyAndOpenSortFile(SortExemptionTable, 'AssessorRptExemptions',
                            OrigSortEXFileName, SortEXFileName,
                            True, True, Quit);

        CopyAndOpenSortFile(SortComputedChangesTable, 'AssessorRptComputedChanges',
                            OrigSortComputedChangesFileName,
                            SortComputedChangesFileName,
                            True, True, Quit);

        CopyAndOpenSortFile(SortSummaryTable, 'AssessorRptSummary',
                            OrigSortSummaryFileName,
                            SortSummaryFileName,
                            False, True, Quit);
        SortSummaryTable.IndexName := 'BySwisSBLKey';

      (*  SortSummaryTable.Close;
        SortSummaryTable.AddIndex('BySwisSBLKey', 'SwisSBLKey',
                                  [ixExpression]);
        SortSummaryTable.IndexName := 'BySwisSBLKey';
        SortSummaryTable.Open; *)

(*        CopyAndOpenSortFile(SortAVChangesTable, 'AssessorRptAVChanges',
                            OrigSortAVChangesFileName,
                            SortAVChangesFileName,
                            False, Quit); *)

          {FXX09172001-1: Don't copy the Sort AV Changes table to a sort file since
                          this is used in the 995.}

        try
          SortAVChangesTable.Open;
          DeleteTable(SortAVChangesTable);
        except
          SystemSupport(031, SortAVChangesTable, 'Error opening and emptying Sort AV Changes Table.',
                        UnitName, GlblErrorDlgBox);
        end;

        OpenTableForProcessingType(ParcelTable, ParcelTableName, ThisYear, Quit);

        If GlblIsWestchesterCounty
          then ProgressDialog.Start(4 * GetRecordCount(ParcelTable), True, True)
          else ProgressDialog.Start(3 * GetRecordCount(ParcelTable), True, True);

          {CHG02282000-1: Add fields for 225 run.}

        FillSortFiles(AssessmentTable, ParcelTable, SwisCodeTable,
                      SortTotalAssessedValTable,
                      SortAssessedValChangesTable,
                      SortAVByPropClass_RS_Table,
                      SortExemptionTable,
                      SortComputedChangesTable,
                      SortSummaryTable,
                      SortAVChangesTable,
                      AssessmentYearCtlFile,
                      SchoolTable, ClassTable,
                      ParcelExemptionTable, EXCodeTable,
                      SwisCodeListBox, ProgressDialog, Self,
                      RPS225ReportRun, AttributeInactivationsOrNewParcelsToPhysicalChange,
                      AttributeImbalancesToEqualization, Quit);

          {FXX10211998-8: Do not hardcode CountyTownCode, i.e first 4 chars of swis.}

        CountyTownCode := Take(4, SwisCodeTable.FieldByName('SwisCode').Text);

        ProgressDialog.Reset;

        ProgressDialog.TotalNumRecords := (GetRecordCount(SortTotalAssessedValTable) +
                                           GetRecordCount(SortAssessedValChangesTable) +
                                           2 * GetRecordCount(SortAVByPropClass_RS_Table));

          {Now print the report.}

        If not (Quit or ReportCancelled)
          then
            begin
              ProgressDialog.Reset;
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

                {FXX09071999-6: Tell people that printing is starting and
                                done.}

              ProgressDialog.StartPrinting(PrintDialog.PrintToFile);

              ProgressDialog.Finish;

                {If they want to see it on the screen, start the preview.}

              If PrintToScreen
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

              ShowReportDialog('ASSESSOR.RPT', TextFiler.FileName, True);

            end;  {If not Quit}

        FinishDialog := True;

        If ReportBalanced
          then
            If RPS225ReportRun
              then PostHoldValues(ParcelTable, AssessmentTable, ClassTable,
                                  Self, CurrentProcessingType,
                                  ProgressDialog, True)
              else
                begin
                    {FXX10152006-1(2.10.2.2): Don't make saving of values an option!}

                  PostComputedChanges(SortComputedChangesTable, Self, ProgressDialog);

                    {FXX12271999-1: Post back hold value. Note that westchester posts back
                                    to next year, all others to this year.}

                  If GlblIsWestchesterCounty
                    then
                      begin
                        OpenTableForProcessingType(ParcelTable, ParcelTableName,
                                                   NextYear, Quit);
                        OpenTableForProcessingType(AssessmentTable, AssessmentTableName,
                                                   NextYear, Quit);
                      end
                    else
                      begin
                        OpenTableForProcessingType(ParcelTable, ParcelTableName,
                                                   ThisYear, Quit);
                        OpenTableForProcessingType(AssessmentTable, AssessmentTableName,
                                                   ThisYear, Quit);

                      end;  {else of If GlblIsWestchesterCounty}

                  PostHoldValues(ParcelTable, AssessmentTable, ClassTable,
                                 Self, CurrentProcessingType,
                                 ProgressDialog, False);

                    {FXX10201999-1: Need to include TY and NY if it is Westchester.}

                  SortAVChangesTable.Close;

                    {CHG11262001-3: Make a backup of the final assessor's report.}

                  CopyOneFile(GlblReportDir + TextFiler.FileName,
                              GlblReportDir + 'AssessorReportFinal' + GlblThisYear + '.RPT');

                  FinishDialog := False;

                  If (MessageDlg('The Assessor''s Report is balanced.' + #13 +
                                 'Do you want to post the computed assessment changes and create the 210T1' +
                                 ' extract file for transmittal to the state?', mtConfirmation, [mbYes, mbNo], 0) = idYes)
                    then
                      begin
                          {CHG05082002-1: Make inclusion of inventory an option.}

                        Generate995File(Self, SelectedSwisCodes,
                                        slSelectedRollSections,
                                        GlblDrive + ':' + GlblExportDir + 'RPS060I1',
                                        GlblDrive + ':' + GlblExportDir + 'RPS210T1',
                                        ftParcelAndSales, False,
                                        GlblIsWestchesterCounty, False,
                                        IncludeInventory, False, True, False,
                                        ProgressDialog, ZipCopyDlg);

                          {FXX05022000-2: Make sure the assessor report gets copied to a disk.}

                        MessageDlg('Please insert another disk for PAS to put' + #13 +
                                   'the Assessor''s Report on.' + #13 +
                                   'Press the OK button when you are ready to proceed.',
                                   mtInformation, [mbOK], 0);

                        with ZipCopyDlg do
                          begin
                            SelectFile(ExpandPASPath(GlblReportDir) + 'ASSESSOR.RPT');
                            FileName := 'ASSESSOR.RPT';
                            Execute;

                          end;  {with ZipCopyDlg do}

                      end;  {If (ReportBalanced and ...}

                end;  {else of If RPS225ReportRun}

          {FXX05011998-2: There were 2 progress dialog finishes.}

          {Delete the sort files.}

        SortTotalAssessedValTable.Close;
        SortAssessedValChangesTable.Close;
        SortAVByPropClass_RS_Table.Close;
        SortExemptionTable.Close;
        SortComputedChangesTable.Close;
        SortSummaryTable.Close;
        SortAVChangesTable.Close;

        try
          ChDir(ExpandPASPath(GlblDataDir));
          OldDeleteFile(SortValChgFileName);
          OldDeleteFile(SortAVPC_RSFileName);
          OldDeleteFile(SortTotValFileName);
          OldDeleteFile(SortEXFileName);
          OldDeleteFile(SortComputedChangesFileName);
          OldDeleteFile(SortSummaryFileName);
        finally
          ChDir(GlblProgramDir);
        end;

          {If they generate the 210, there is a finish dialog already there.}

        If FinishDialog
          then ProgressDialog.Finish;

       ResetPrinter(ReportPrinter);

        If CreateParcelList
          then ParcelListDialog.Show;

      end;  {If PrintDialog.Execute}

  StartButton.Enabled := True;

  SelectedSwisCodes.Free;
  slSelectedRollSections.Free;

end;  {StartButtonClick}

{===================================================================}
{===============  THE FOLLOWING ARE PRINTING PROCEDURES ============}
{===================================================================}
Function ConvertSwisCodeToMunicipalitySwisCode(SwisCode : String) : String;

{FXX04192004-1(2.07l3): Adjust the header so that for a village, it always shows
                        the full SWIS code.}

begin
  If (GlblMunicipalityType = MTVillage)
    then Result := SwisCode
    else Result := Copy(SwisCode, 1, 4);

end;  {ConvertSwisCodeToMunicipalitySwisCode}

{===================================================================}
Procedure TAssessorsReportForm.PrintReportHeader(Sender : TObject;
                                                 ReportTime : TDateTime;
                                                 PageNum : Integer;
                                                 PartName,
                                                 SubHeader : String;
                                                 SwisCode : String);

{Print the overall report header.}

begin
  with Sender as TBaseReport do
    begin
        {FXX09081998-2: Set the section top a little lower so doesn't get cut off.}
      ClearTabs;
      SetTab(0.3, pjLeft, 13.0, 0, BoxLineNone, 0);

      Println('');
      Println(#9 + Take(43, 'COUNTY OF ' + GlblCountyName) +
              Center('ASSESSOR''S REPORT', 43) +
              RightJustify('Page: ' + IntToStr(CurrentPage), 43));

      Println(#9 + Take(43, UpcaseStr(GetMunicipalityName)) +
              Center(PartName, 43) +
              RightJustify('Date: ' + DateToStr(Date) +
                           '  Time: ' + TimeToStr(Now), 43));

      Println(#9 + Take(43, 'Swis - ' + SwisCode) +
              Center(SubHeader, 43));

      Println('');

    end;  {with Sender as TBaseReport do}

end;  {PrintReportHeader}

{===================================================================}
Procedure TAssessorsReportForm.CalculateTotalValues(    RecType,  {(S)wis or S(c)hool}
                                                        RollSection : Char;
                                                        AllMunicipalityCodes : Boolean;  {The total of all Swis or
                                                                                          school codes or}
                                                        MunicipalityCode : String;  {Just this municipality code}
                                                    var PriorTotal,
                                                        CurrentTotal,
                                                        EqualizationIncrease,
                                                        EqualizationDecrease,
                                                        PhysicalQtyIncrease,
                                                        PhysicalQtyDecrease : Comp;
                                                    var Quit : Boolean);

{Sort procedure for printing part 1 section 1.}

var
  FirstTimeThrough, Done : Boolean;

begin
  FirstTimeThrough := True;
  Done := False;

  PriorTotal := 0;
  CurrentTotal := 0;
  EqualizationIncrease := 0;
  EqualizationDecrease := 0;
  PhysicalQtyIncrease := 0;
  PhysicalQtyDecrease := 0;

  SortTotalAssessedValTable.First;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else SortTotalAssessedValTable.Next;

    If SortTotalAssessedValTable.EOF
      then Done := True;

      {If this record has the right record type, roll section, and
       municipality code, add the totals in.}

    with SortTotalAssessedValTable do
      If ((not Done) and
          (Take(1, FieldByName('RecType').Text)[1] = RecType) and
          (Take(1, FieldByName('RollSection').Text)[1] = RollSection) and
          (AllMunicipalityCodes or
           (FieldByName('MunicipalityCode').Text = MunicipalityCode)))
        then
          begin
            ProgressDialog.Update(Self,
                                  'Swis: ' + FieldByName('MunicipalityCode').Text +
                                  '  R\S: ' + FieldByName('RollSection').Text);

            PriorTotal := PriorTotal +
                          TCurrencyField(FieldByName('HomestdPriorVal')).Value +
                          TCurrencyField(FieldByName('NonhomestdPriorVal')).Value;
            CurrentTotal := CurrentTotal +
                            TCurrencyField(FieldByName('HomestdCurrentVal')).Value +
                            TCurrencyField(FieldByName('NonhomestdCurrentVal')).Value;

            EqualizationIncrease := EqualizationIncrease +
                                    TCurrencyField(FieldByName('HstdEqualInc')).Value +
                                    TCurrencyField(FieldByName('NonhstdEqualInc')).Value;
            EqualizationDecrease := EqualizationDecrease +
                                    TCurrencyField(FieldByName('HstdEqualDec')).Value +
                                    TCurrencyField(FieldByName('NonhstdEqualDec')).Value;
            PhysicalQtyIncrease := PhysicalQtyIncrease +
                                   TCurrencyField(FieldByName('HstdPhysQtyInc')).Value +
                                   TCurrencyField(FieldByName('NonhstdPhysQtyInc')).Value;
            PhysicalQtyDecrease := PhysicalQtyDecrease +
                                   TCurrencyField(FieldByName('HstdPhysQtyDec')).Value +
                                   TCurrencyField(FieldByName('NonhstdPhysQtyDec')).Value;

          end;  {If ((FieldByName('RecType') ...}

  until (Done or Quit or ReportCancelled);

end;  {CalculateTotalValues}

{===================================================================}
Procedure TAssessorsReportForm.PrintPart1Section1(    Sender : TObject;
                                                      ReportTime : TDateTime;
                                                  var TotalEqualizationIncrease,
                                                      TotalPhysicalQtyIncrease,
                                                      TotalEqualizationDecrease,
                                                      TotalPhysicalQtyDecrease,
                                                      PriorAssessedValue : Comp;
                                                  var PageNum : Integer;
                                                  var Quit : Boolean);

{This section is the first part which gives overall prior and assessed
 value breakdowns and total increase and decreases due to equalization
 and physical change.}

var
  RS1PriorTotal, RS1CurrentTotal,
  RS3PriorTotal, RS3CurrentTotal,
  RS6PriorTotal, RS6CurrentTotal,
  TotalRS136Prior, TotalRS136Current,
  RS1EqualizationIncrease, RS1EqualizationDecrease,
  RS1PhysicalQtyIncrease, RS1PhysicalQtyDecrease,
  RS3EqualizationIncrease, RS3EqualizationDecrease,
  RS3PhysicalQtyIncrease, RS3PhysicalQtyDecrease,
  RS6EqualizationIncrease, RS6EqualizationDecrease,
  RS6PhysicalQtyIncrease, RS6PhysicalQtyDecrease,
  RS1AssessmentChange, RS3AssessmentChange, RS6AssessmentChange,
  TempDifference1, TempDifference2 : Comp;

begin
  TotalEqualizationIncrease := 0;
  TotalPhysicalQtyIncrease := 0;
  TotalEqualizationDecrease := 0;
  TotalPhysicalQtyDecrease := 0;

  ProgressDialog.UserLabelCaption := 'Part 1 - Summary of Inc\Dec';

  with Sender as TBaseReport do
    begin
      PrintReportHeader(Sender, ReportTime, PageNum,
                        'PART 1 - ASSESSOR''S REPORT',
                        'FOR THE ' + CurrentAssessmentYear + ' ASSESSMENT ROLL',
                        ConvertSwisCodeToMunicipalitySwisCode(SwisCodeTable.FieldByName('SwisCode').Text));
      ClearTabs;
      SetPen(clBlack, psSolid, 1, pmCopy); { Set pen to 1 dot width }
      SetTab(0.5, pjLeft, 10, 0, BoxLineNone, 0);

      Println(#9 + 'THE PART 1 AND PART 2 REQUIREMENTS ARE FULFILLED WHEN THIS REPORT IS COMPLETED, SIGNED AND SUBMITTED');
      Println(#9 + 'ALONG WITH THE TOTALS REPORT AND THE SEQUENTIAL MASTER FILE TO THE STATE BOARD.');
      Println('');
      Println(#9 + 'I. SUMMARY OF INCREASES AND DECREASES IN TOTAL ASSESSED VALUE OF LOCALLY ASSESSED PROPERTIES');
      Println(#9 + 'FROM PRIOR ROLL TO CURRENT ROLL.');

      ClearTabs;
      SetTab(0.7, pjLeft, 0.4, 0, BoxLineNone, 0);  {Number on left}
      SetTab(1.2, pjLeft, 3.5, 0, BoxLineNone, 0);  {Text}
      SetTab(6.5, pjRight, 1.5, 0, BoxLineNone, 0);  {Prior amounts}
      SetTab(8.5, pjRight, 1.5, 0, BoxLineNone, 0);  {Current amounts}

      CalculateTotalValues('S', '1', True, '',
                           RS1PriorTotal, RS1CurrentTotal,
                           RS1EqualizationIncrease, RS1EqualizationDecrease,
                           RS1PhysicalQtyIncrease, RS1PhysicalQtyDecrease,
                           Quit);

      If not (Quit or ReportCancelled)
        then CalculateTotalValues('S', '3', True, '',
                           RS3PriorTotal, RS3CurrentTotal,
                           RS3EqualizationIncrease, RS3EqualizationDecrease,
                           RS3PhysicalQtyIncrease, RS3PhysicalQtyDecrease,
                           Quit);

      If not (Quit or ReportCancelled)
        then CalculateTotalValues('S', '6', True, '',
                                  RS6PriorTotal, RS6CurrentTotal,
                                  RS6EqualizationIncrease, RS6EqualizationDecrease,
                                  RS6PhysicalQtyIncrease, RS6PhysicalQtyDecrease,
                                  Quit);

      If not (Quit or ReportCancelled)
        then
          begin
            Underline := True;
            Println(#9 + #9 + #9 + 'PRIOR ROLL' +
                    #9 + 'CURRENT ROLL');
            Underline := False;
            Println('');

            Println(#9 + '(1)' +
                    #9 + 'Locally Assessed Properties (Ordinary  RS 1)' +
                    #9 + FormatFloat(CurrencyDisplayNoDollarSign, RS1PriorTotal) +
                    #9 + FormatFloat(CurrencyDisplayNoDollarSign, RS1CurrentTotal));

            Println(#9 + '(2)' +
                    #9 + 'Locally Assessed Properties (Utilities RS 6)' +
                    #9 + FormatFloat(CurrencyDisplayNoDollarSign, RS6PriorTotal) +
                    #9 + FormatFloat(CurrencyDisplayNoDollarSign, RS6CurrentTotal));
            Println(#9 + #9 +
                    #9 + ConstStr('_', 14) +
                    #9 + ConstStr('_', 14));

            Println(#9 + '(3)' +
                    #9 + '   Subtotal Locally Assessed Properties (RS 1, 6)' +
                    #9 + FormatFloat(CurrencyDisplayNoDollarSign, (RS1PriorTotal + RS6PriorTotal)) +
                    #9 + FormatFloat(CurrencyDisplayNoDollarSign, (RS1CurrentTotal + RS6CurrentTotal)));
            Println('');

              {FXX10211998-4: Need to print rs 3, not rs 6 here.}

            Println(#9 + '(4)' +
                    #9 + 'Locally Assessed Properties (T.S.L. RS 3)' +
                    #9 + FormatFloat(CurrencyDisplayNoDollarSign, RS3PriorTotal) +
                    #9 + FormatFloat(CurrencyDisplayNoDollarSign, RS3CurrentTotal));

            Println(#9 + #9 +
                    #9 + ConstStr('_', 14) +
                    #9 + ConstStr('_', 14));
            TotalRS136Prior := RS1PriorTotal + RS3PriorTotal + RS6PriorTotal;
            TotalRS136Current := RS1CurrentTotal + RS3CurrentTotal + RS6CurrentTotal;

            Println(#9 + '(5)' +
                    #9 + '   Total Locally Asssessed Properties (RS 1, 3, 6)' +
                    #9 + FormatFloat(CurrencyDisplayNoDollarSign, TotalRS136Prior) +
                    #9 + FormatFloat(CurrencyDisplayNoDollarSign, TotalRS136Current));
            Println('');

            ClearTabs;
            SetTab(0.7, pjLeft, 0.4, 0, BoxLineNone, 0);  {Number on left}
            SetTab(1.2, pjLeft, 3.5, 0, BoxLineNone, 0);  {Text}
            SetTab(7, pjRight, 1.5, 0, BoxLineNone, 0);  {Prior amounts}
            SetTab(9, pjRight, 1.5, 0, BoxLineNone, 0);  {Current amounts}

            Println('');
            Underline := True;
            Println(#9 + #9 + #9 + 'ROLL SEC 1, 6' +
                    #9 + 'ROLL SEC 1, 3, 6');
            Underline := False;
            Println('');

            Println(#9 + '(6)' +
                    #9 + 'Change In Total Assessed Value From Prior To Current Roll' +
                    #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                                     ((RS1CurrentTotal + RS6CurrentTotal) -
                                      (RS1PriorTotal + RS6PriorTotal))) +
                    #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                                     (TotalRS136Current - TotalRS136Prior)));

            Println('');

            Println(#9 + '(7)' +
                    #9 + 'Increases Due To Physical Or Quantity Changes' +
                    #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                                     (RS1PhysicalQtyIncrease +
                                      RS6PhysicalQtyIncrease)) +
                    #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                                     (RS1PhysicalQtyIncrease +
                                      RS6PhysicalQtyIncrease +
                                      RS3PhysicalQtyIncrease)));
            Println(#9 + '(8)' +
                    #9 + 'Increases For Equalization' +
                    #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                                     (RS1EqualizationIncrease +
                                      RS6EqualizationIncrease)) +
                    #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                                     (RS1EqualizationIncrease +
                                      RS6EqualizationIncrease +
                                      RS3EqualizationIncrease)));

            Println(#9 + #9 +
                    #9 + ConstStr('_', 14) +
                    #9 + ConstStr('_', 14));

            Println(#9 + '(9)' +
                    #9 + '   Summary Of Increases (Lines 7 + 8)' +
                    #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                                     (RS1PhysicalQtyIncrease +
                                      RS6PhysicalQtyIncrease +
                                      RS1EqualizationIncrease +
                                      RS6EqualizationIncrease)) +
                    #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                                     (RS1PhysicalQtyIncrease +
                                      RS6PhysicalQtyIncrease +
                                      RS3PhysicalQtyIncrease +
                                      RS1EqualizationIncrease +
                                      RS3EqualizationIncrease +
                                      RS6EqualizationIncrease)));
            Println('');

            Println(#9 + '(10)' +
                    #9 + 'Decreases Due To Physical Or Quantity Changes' +
                    #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                                     (RS1PhysicalQtyDecrease +
                                      RS6PhysicalQtyDecrease)) +
                    #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                                     (RS1PhysicalQtyDecrease +
                                      RS6PhysicalQtyDecrease +
                                      RS3PhysicalQtyDecrease)));

              {FXX10211998-5: Had RS6EqualizationIncrease instead of Decrease in
                              first col on line below.}

            Println(#9 + '(11)' +
                    #9 + 'Decreases For Equalization' +
                    #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                                     (RS1EqualizationDecrease +
                                      RS6EqualizationDecrease)) +
                    #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                                     (RS1EqualizationDecrease +
                                      RS6EqualizationDecrease +
                                      RS3EqualizationDecrease)));

            Println(#9 + #9 +
                    #9 + ConstStr('_', 14) +
                    #9 + ConstStr('_', 14));
            Println(#9 + '(12)' +
                    #9 + '   Summary Of Decreases (Lines 10 + 11)' +
                    #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                                     (RS1PhysicalQtyDecrease +
                                      RS6PhysicalQtyDecrease +
                                      RS1EqualizationDecrease +
                                      RS6EqualizationDecrease)) +
                    #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                                     (RS1PhysicalQtyDecrease +
                                      RS6PhysicalQtyDecrease +
                                      RS3PhysicalQtyDecrease +
                                      RS1EqualizationDecrease +
                                      RS3EqualizationDecrease +
                                      RS6EqualizationDecrease)));
            Println('');
            RS1AssessmentChange := RS1PhysicalQtyIncrease + RS1EqualizationIncrease -
                                   RS1PhysicalQtyDecrease - RS1EqualizationDecrease;
            RS3AssessmentChange := RS3PhysicalQtyIncrease + RS3EqualizationIncrease -
                                   RS3PhysicalQtyDecrease - RS3EqualizationDecrease;
            RS6AssessmentChange := RS6PhysicalQtyIncrease + RS6EqualizationIncrease -
                                   RS6PhysicalQtyDecrease - RS6EqualizationDecrease;

            Println(#9 + '(13)' +
                    #9 + 'Net Change In Total Assessed Value (Line 9 Less Line 12)' +
                    #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                                     (RS1AssessmentChange +
                                      RS6AssessmentChange)) +
                    #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                                     (RS1AssessmentChange +
                                      RS3AssessmentChange +
                                      RS6AssessmentChange)));

            Println('');
            Bold := True;
            TempDifference1 := (RS1CurrentTotal + RS6CurrentTotal) -
                               (RS1PriorTotal + RS6PriorTotal) -
                               (RS1AssessmentChange + RS6AssessmentChange);
            TempDifference2 := (RS1CurrentTotal + RS3CurrentTotal + RS6CurrentTotal) -
                               (RS1PriorTotal + RS3PriorTotal + RS6PriorTotal) -
                               (RS1AssessmentChange +
                                RS3AssessmentChange +
                                RS6AssessmentChange);

              {FXX07102008-1(2.13.1.25)[D1304]: The Assessor's Report is balanced if rs. 1&6 are in balance.}

            If (Roundoff(TempDifference1, 0) = 0)
              then ReportBalanced := True;

            Println(#9 + #9 +
                    #9 + ConstStr('_', 14) +
                    #9 + ConstStr('_', 14));
            Println(#9 + '(14)' +
                    #9 + 'Difference In Change (Line 6 Less Line 13)' +
                    #9 + FormatFloat(CurrencyDisplayNoDollarSign, TempDifference1) +
                    #9 + FormatFloat(CurrencyDisplayNoDollarSign, TempDifference2));
            Println(#9 + #9 +
                    #9 + ConstStr('-', 14) +
                    #9 + ConstStr('-', 14));

            Bold := False;

            TotalPhysicalQtyIncrease := RS1PhysicalQtyIncrease +
                                        RS6PhysicalQtyIncrease +
                                        RS3PhysicalQtyIncrease;

            TotalEqualizationIncrease := RS1EqualizationIncrease +
                                         RS3EqualizationIncrease +
                                         RS6EqualizationIncrease;

            TotalPhysicalQtyDecrease := RS1PhysicalQtyDecrease +
                                        RS6PhysicalQtyDecrease +
                                        RS3PhysicalQtyDecrease;

            TotalEqualizationDecrease := RS1EqualizationDecrease +
                                         RS3EqualizationDecrease +
                                         RS6EqualizationDecrease;

            PriorAssessedValue := TotalRS136Prior;

          end;  {If not (Quit or ReportCancelled)}

      NewPage;

    end;  {with Sender as TBaseReport do}

end;  {PrintPart1Section1}

{===================================================================}
Procedure TAssessorsReportForm.PrintPart1Section2(    Sender : TObject;
                                                      ReportTime : TDateTime;
                                                      AssessmentFactorChange : Double;
                                                      MunicipalityHasVillages : Boolean;
                                                  var PageNum : Integer;
                                                  var Quit : Boolean);

{Print the homestead status of the municipality, assessing status of the
 villages and change in assessment factor.}

var
  TempStr : String;
  Done, FirstTimeThrough, FirstAssessingVillage : Boolean;
  NumAssessingVillages : Integer;

begin
  NumAssessingVillages := 0;

  with Sender as TBaseReport do
    begin
      PageNum := PageNum + 1;
      PrintReportHeader(Sender, ReportTime, PageNum,
                        'PART 1 - ASSESSOR''S REPORT',
                        'FOR THE ' + CurrentAssessmentYear + ' ASSESSMENT ROLL',
                        ConvertSwisCodeToMunicipalitySwisCode(SwisCodeTable.FieldByName('SwisCode').Text));
      ClearTabs;
      SetTab(0.3, pjLeft, 0.5, 0, BoxLineNone, 0);  {Number on left}

      Println('');
      Println('');
      Println('II  ASSESSING UNIT STATUS');

      ClearTabs;
      SetTab(0.5, pjLeft, 0.5, 0, BoxLineNone, 0);  {1st margin}
      SetTab(1.1, pjLeft, 0.8, 0, BoxLineNone, 0);  {Swis Code}
      SetTab(2.0, pjLeft, 3.0, 0, BoxLineNone, 0);  {Description}

        {FXX10211998-10: Make the municipality name upper case.}

      Println('');
      Println(#9 + 'THE ' + UpcaseStr(GetMunicipalityName) + ' IS AN APPROVED ASSESSING UNIT AS DEFINED IN ' +
              'SECTION 1901 OF THE RPTL.');

      If SwisCodeTable.FieldByName('Classified').AsBoolean
        then TempStr := 'HAVE'
        else TempStr := 'HAVE NOT';

      Println(#9 + '    THE HOMESTEAD BASE PROVISIONS OF SECTION 1903 OF THE RPTL ' +
              TempStr + ' BEEN ADOPTED.');

      Println('');
      Println(ConstStr('*', 80));
      Println(#9 + 'ESTIMATED CHANGE IN LEVEL OF ASSESSMENT FACTOR AS OF ' + DateToStr(Date) + ':  ' +
              FormatFloat(ExtendedDecimalDisplay, AssessmentFactorChange));
      Println('');

      Println(ConstStr('*', 80));

        {Now, if there are any villages in this municipality, list if
         any are assessing.}

      If MunicipalityHasVillages
        then
          begin
            FirstAssessingVillage := True;
            Done := False;
            FirstTimeThrough := True;

            SwisCodeTable.First;

            repeat
              If FirstTimeThrough
                then FirstTimeThrough := False
                else SwisCodeTable.Next;

              If SwisCodeTable.EOF
                then Done := True;

              with SwisCodeTable do
                If ((not Done) and
                    (Copy(FieldByName('SwisCode').Text, 5, 2) <> '00') and
                    FieldByName('AssessingVillage').AsBoolean)
                  then
                    begin
                      If FirstAssessingVillage
                        then
                          begin
                            FirstAssessingVillage := False;
                            Println(#9 + 'THE FOLLOWING VILLAGES HAVE ENACTED A LOCAL LAW PURSUANT' +
                                          'TO SECTION 1402, SUBDIVISION 3, RPTL:');

                          end;  {If FirstAssessingVillage}

                      Println(#9 + #9 + FieldByName('SwisCode').Text +
                              #9 + FieldByName('MunicipalityName').Text);

                      NumAssessingVillages := NumAssessingVillages + 1;

                    end;  {If ((not Done) and ...}

            until Done;

            If (NumAssessingVillages = 0)
              then Println(#9 + 'NO VILLAGES HAVE ENACTED A LOCAL LAW PURSUANT TO SECTION 1402, SUBDIVISION 3, RPTL.');

          end;  {If MunicipalityHasVillages}

    end;  {with Sender as TBaseReport do}

end;  {PrintPart1Section2}

{===================================================================}
Procedure TAssessorsReportForm.PrintPart1Section3(    Sender : TObject;
                                                      ReportTime : TDateTime;
                                                  var PageNum : Integer;
                                                  var Quit : Boolean);

{Print the agricultural penalty tax reporting prose.}

begin
  with Sender as TBaseReport do
    If not ReportCancelled
      then
        begin
          ClearTabs;
          SetPen(clBlack, psSolid, 1, pmCopy); { Set pen to 1 dot width }
          SetTab(0.5, pjLeft, 0.5, 0, BoxLineNone, 0);
          SetTab(1.1, pjLeft, 6, 0, BoxLineNone, 0);

          Println(#9 + 'III.' +
                  #9 + 'PENALTY TAXES IMPOSED ON A PARCEL OR PARCELS WHICH WERE PREVIOUSLY GRANTED AN AGRICULTURAL' +
                       ' EXEMPTION PURSUANT TO');
          Println(#9 + #9 +
                  'SECTION 305 OR 306 OF THE AGRICULTURE AND MARKETS LAW AND WERE CONVERTED TO NONAGRICULTURAL USE:');

          ClearTabs;
          SetTab(11.2, pjLeft, 0.4, 0, BoxLineNone, 0);
          SetTab(11.7, pjLeft, 0.4, 0, BoxLineNone, 0);
          Println(#9 + 'YES' +
                  #9 + 'NO');

          ClearTabs;
          SetTab(1.5, pjLeft, 8.4, 0, BoxLineNone, 0);
          SetTab(11.2, pjLeft, 0.4, 0, BoxLineBottom, 0);
          SetTab(11.7, pjLeft, 0.4, 0, BoxLineBottom, 0);

          Println(#9 + 'ARE THERE PARCEL(S) WHICH RECEIVED AN AGRICULTURAL EXEMPTION UNDER SECTIONS 305 OR 306 OF THE');
          Println(#9 + 'AGRICULTURE AND MARKETS LAW WHICH WERE CONVERTED TO A NONAGRICULTURAL USE? (INCLUDE BOTH');
          Println(#9 + 'PARCELS CONVERTED ON THE CURRENT ROLL AND THOSE CONVERTED ON A PRIOR ROLL BUT NOT REPORTED');
          Println(#9 + 'TO THE STATE BOARD).' +
                  #9 + '____' +
                  #9 + '____');
          Println('');
          Println(#9 + 'IF YES, WERE PENALTY TAXES IMPOSED ON ONE OR MORE OF THE CONVERTED PARCELS?' +
                  #9 + '____' +
                  #9 + '____');
          Println(#9 + 'IF PENALTY TAXES WERE IMPOSED, YOU MUST REPORT USING FORM RP-305-pr)');
          Println('');

          NewPage;

        end;  {If not ReportCancelled}

end;  {PrintPart1Section3}

{===================================================================}
Procedure TAssessorsReportForm.PrintPart1Section4(    Sender : TObject;
                                                      ReportTime : TDateTime;
                                                  var PageNum : Integer;
                                                  var Quit : Boolean);

{Print the names and addresses section.}

begin
  with Sender as TBaseReport do
    If not ReportCancelled
      then
        begin
          PageNum := PageNum + 1;
          PrintReportHeader(Sender, ReportTime, PageNum,
                            'PART 1 - ASSESSOR''S REPORT',
                            'FOR THE ' + CurrentAssessmentYear + ' ASSESSMENT ROLL',
                            ConvertSwisCodeToMunicipalitySwisCode(SwisCodeTable.FieldByName('SwisCode').Text));
          ClearTabs;
          SetPen(clBlack, psSolid, 1, pmCopy); { Set pen to 1 dot width }
          SetTab(0.5, pjLeft, 0.5, 0, BoxLineNone, 0);
          SetTab(1.1, pjLeft, 6, 0, BoxLineNone, 0);

          Println(#9 + 'IV.' +
                  #9 + 'NAMES AND ADDRESSES');
          Println(#9 + #9 + 'NAME, ADDRESS, AND TELEPHONE NUMBER OF THE SERVICE BUREAU WHICH' +
                            ' PREPARES THE ASSESSMENT ROLL:');

          ClearTabs;
          SetTab(3.3, pjLeft, 1.2, 0, BoxLineNone, 0);  {2nd column}
          Println(#9 + 'OFFICIAL');

          ClearTabs;
          SetTab(1.1, pjLeft, 0.4, 0, BoxLineNone, 0);  {Left column}
          SetTab(1.6, pjLeft, 1.5, 0, BoxLineBottom, 0);  {Underline}
          SetTab(3.3, pjLeft, 1.1, 0, BoxLineNone, 0);  {2nd column}
          SetTab(4.6, pjLeft, 2.1, 0, BoxLineBottom, 0);  {Underline}
          SetTab(6.8, pjLeft, 1.5, 0, BoxLineNone, 0);  {Phone #}
          SetTab(8.5, pjLeft, 1.5, 0, BoxLineNone, 0);  {Underline}

          Println(#9 + 'NAME' +
                  #9 + ConstStr('_', 15) +
                  #9 + 'MAILING ADDR' +
                  #9 + ConstStr('_', 20) +
                  #9 + 'BUSINESS PHONE' +
                  #9 + '(____)____________');
          Println('');
          Println(#9 + #9 + ConstStr('_', 15) +
                  #9 + #9 + ConstStr('_', 20));
          Println('');

          ClearTabs;
          SetTab(1.1, pjLeft, 9, 0, BoxLineNone, 0);  {Left column}

          Println(#9 + 'PERSON TO CONTACT IF THERE ARE QUESTIONS ABOUT THIS REPORT ' +
                       '(BETWEEN 8:00 AM AND 4:15 PM)  TIME:_______________');

          ClearTabs;
          SetTab(3.3, pjLeft, 1.2, 0, BoxLineNone, 0);  {2nd column}
          Println(#9 + 'OFFICIAL');

          ClearTabs;
          SetTab(1.1, pjLeft, 0.4, 0, BoxLineNone, 0);  {Left column}
          SetTab(1.6, pjLeft, 1.5, 0, BoxLineBottom, 0);  {Underline}
          SetTab(3.3, pjLeft, 1.1, 0, BoxLineNone, 0);  {2nd column}
          SetTab(4.6, pjLeft, 2.1, 0, BoxLineBottom, 0);  {Underline}
          SetTab(6.8, pjLeft, 1.5, 0, BoxLineNone, 0);  {Phone #}
          SetTab(8.5, pjLeft, 1.5, 0, BoxLineNone, 0);  {Underline}

          Println(#9 + 'NAME' +
                  #9 + ConstStr('_', 15) +
                  #9 + 'MAILING ADDR' +
                  #9 + ConstStr('_', 20) +
                  #9 + 'BUSINESS PHONE' +
                  #9 + '(____)____________');
          Println('');
          Println(#9 + #9 + ConstStr('_', 15) +
                  #9 + #9 + ConstStr('_', 20) +
                  #9 + 'HOME PHONE #' +
                  #9 + '(____)____________');
          Println('');

          ClearTabs;
          SetTab(1.1, pjLeft, 9, 0, BoxLineNone, 0);  {Left column}
          Println(#9 + 'VILLAGE ASSESSOR, SOLE ASSESSOR OR CHAIR, BOARD OF ASSESSORS (IF DIFFERENT FROM ABOVE)');

          ClearTabs;
          SetTab(3.3, pjLeft, 1.2, 0, BoxLineNone, 0);  {2nd column}
          Println(#9 + 'OFFICIAL');

          ClearTabs;
          SetTab(1.1, pjLeft, 0.4, 0, BoxLineNone, 0);  {Left column}
          SetTab(1.6, pjLeft, 1.5, 0, BoxLineBottom, 0);  {Underline}
          SetTab(3.3, pjLeft, 1.1, 0, BoxLineNone, 0);  {2nd column}
          SetTab(4.6, pjLeft, 2.1, 0, BoxLineBottom, 0);  {Underline}
          SetTab(6.8, pjLeft, 1.5, 0, BoxLineNone, 0);  {Phone #}
          SetTab(8.5, pjLeft, 1.5, 0, BoxLineNone, 0);  {Underline}

          Println(#9 + 'NAME' +
                  #9 + ConstStr('_', 15) +
                  #9 + 'MAILING ADDR' +
                  #9 + ConstStr('_', 20) +
                  #9 + 'BUSINESS PHONE' +
                  #9 + '(____)____________');
          Println('');
          Println(#9 + #9 + ConstStr('_', 15) +
                  #9 + #9 + ConstStr('_', 20) +
                  #9 + 'HOME PHONE #' +
                  #9 + '(____)____________');
          Println('');

          ClearTabs;
          SetTab(1.1, pjLeft, 9, 0, BoxLineNone, 0);  {Left column}
          Println(#9 + 'MEMBERS OF THE BOARD OF ASSESSORS EXCLUDING CHAIR');

          ClearTabs;
          SetTab(3.3, pjLeft, 1.2, 0, BoxLineNone, 0);  {2nd column}
          Println(#9 + 'OFFICIAL');

          ClearTabs;
          SetTab(1.1, pjLeft, 0.4, 0, BoxLineNone, 0);  {Left column}
          SetTab(1.6, pjLeft, 1.5, 0, BoxLineBottom, 0);  {Underline}
          SetTab(3.3, pjLeft, 1.1, 0, BoxLineNone, 0);  {2nd column}
          SetTab(4.6, pjLeft, 2.1, 0, BoxLineBottom, 0);  {Underline}
          SetTab(6.8, pjLeft, 1.5, 0, BoxLineNone, 0);  {Phone #}
          SetTab(8.5, pjLeft, 1.5, 0, BoxLineNone, 0);  {Underline}

          Println(#9 + 'NAME' +
                  #9 + ConstStr('_', 15) +
                  #9 + 'MAILING ADDR' +
                  #9 + ConstStr('_', 20) +
                  #9 + 'BUSINESS PHONE' +
                  #9 + '(____)____________');

          ClearTabs;
          SetTab(3.3, pjLeft, 1.2, 0, BoxLineNone, 0);  {2nd column}
          Println(#9 + 'OFFICIAL');

          ClearTabs;
          SetTab(1.1, pjLeft, 0.4, 0, BoxLineNone, 0);  {Left column}
          SetTab(1.6, pjLeft, 1.5, 0, BoxLineBottom, 0);  {Underline}
          SetTab(3.3, pjLeft, 1.1, 0, BoxLineNone, 0);  {2nd column}
          SetTab(4.6, pjLeft, 2.1, 0, BoxLineBottom, 0);  {Underline}
          SetTab(6.8, pjLeft, 1.5, 0, BoxLineNone, 0);  {Phone #}
          SetTab(8.5, pjLeft, 1.5, 0, BoxLineNone, 0);  {Underline}
          Println(#9 + 'NAME' +
                  #9 + ConstStr('_', 15) +
                  #9 + 'MAILING ADDR' +
                  #9 + ConstStr('_', 20) +
                  #9 + 'BUSINESS PHONE' +
                  #9 + '(____)____________');

            {FXX09081998-2: Remove line so that this section fits.}

          ClearTabs;
          SetTab(3.3, pjLeft, 1.2, 0, BoxLineNone, 0);  {2nd column}
          Println(#9 + 'OFFICIAL');

          ClearTabs;
          SetTab(1.1, pjLeft, 0.4, 0, BoxLineNone, 0);  {Left column}
          SetTab(1.6, pjLeft, 1.5, 0, BoxLineBottom, 0);  {Underline}
          SetTab(3.3, pjLeft, 1.1, 0, BoxLineNone, 0);  {2nd column}
          SetTab(4.6, pjLeft, 2.1, 0, BoxLineBottom, 0);  {Underline}
          SetTab(6.8, pjLeft, 1.5, 0, BoxLineNone, 0);  {Phone #}
          SetTab(8.5, pjLeft, 1.5, 0, BoxLineNone, 0);  {Underline}
          Println(#9 + 'TOWN OFFICE (IF ANY):' +
                  #9 + #9 + 'MAILING ADDR' +
                  #9 + ConstStr('_', 20) +
                  #9 + 'BUSINESS PHONE' +
                  #9 + '(____)____________');

        end;  {If not ReportCancelled}

end;  {PrintPart1Section4}

{===================================================================}
Procedure TAssessorsReportForm.PrintPart1Section5(    Sender : TObject;
                                                  var Quit : Boolean);

{Print the verification and signature lines.}

begin
  with Sender as TBaseReport do
    begin
      Println('');

      ClearTabs;
      SetPen(clBlack, psSolid, 1, pmCopy); { Set pen to 1 dot width }
      SetTab(0.5, pjLeft, 0.5, 0, BoxLineNone, 0);
      SetTab(1.1, pjLeft, 9, 0, BoxLineNone, 0);

      Println(#9 + 'V.' +
              #9 + 'I HEREBY CERTIFY THAT THE INFORMATION CONTAINED IN THIS REPORT CONSTITUTES A TRUE STATEMENT '+
                   'OF FACT AND IS DERIVED');
      Println(#9 + #9 +
              'FROM THE ASSESSMENT ROLL FINALIZED ON ______________________________.  FURTHERMORE, THE ACCOMPANYING ' +
              'COMPUTERIZED');
      Println(#9 + #9 +
              'DATA FILE SUPPORTS THE DATA PROVIDED IN THIS REPORT AND IS A COPY OF THE FILE USED TO PRODUCE SAID '+
              'ASSESSMENT ROLL.');
      Println('');


      ClearTabs;
      SetTab(1.1, pjCenter, 5, 0, BoxLineTop, 0);
      SetTab(7, pjCenter, 1.5, 0, BoxLineTop, 0);
      Println(#9 + ConstStr('_', 50) +
              #9 + ConstStr('_', 15));
      Println(#9 + 'SIGNATURE OF ASSESSOR OR CHAIR OF BOARD OF ASSESSORS' +
              #9 + 'DATE');
      NewPage;

    end;  {with Sender as TBaseReport do}

end;  {PrintPart1Section5}

{===================================================================}
Procedure TAssessorsReportForm.PrintARTotalsSection1(    Sender : TObject;
                                                         ReportTime : TDateTime;
                                                     var PageNum : Integer;
                                                     var Quit : Boolean);

{Print the AR totals section 1, i.e. the property class breakdown.}
{The property class categories are:
 A : 100's
 B : 200's  (Roll section 1, 6, non-condo)
 C : 200's  (Roll section 1, 6; condo)
 D : 200's  (Roll section 3, 5, 7, 8)
 E : 300's
 F : 400's
 G : 500's
 H : 600's
 I : 700's
 J : 800's
 K : 900's
 L : anything else}
 {We will put one line per category.}

const
  NumPropClassCategories = 12;

type
  PropClassShortDescArrayType = Array[1..NumPropClassCategories] of String;
  PropClassLongDescArrayType = Array[1..NumPropClassCategories] of String;

const
  PropClassShortDesc : PropClassShortDescArrayType =
      ('100', '200' ,'200', '200', '300', '400', '500', '600',
       '700', '800', '900', 'OTHER');

  PropClassLongDesc : PropClassLongDescArrayType =
      ('AGRICULTURAL',
       'RESIDENTIAL/NON-CONDO (RS 1,6)',
       'RESIDENTIAL/CONDO (RS 1, 6)',
       'RESIDENTIAL (RS 3, 5, 7, 8)',
       'VACANT LAND',
       'COMMERCIAL',
       'RECREATIONAL',
       'COMMUNITY SERVICES',
       'INDUSTRIAL',
       'PUBLIC SERVICE',
       'PARK & FOREST LAND',
       'PROPERTY CLASS < 100 OR ALPHA');

var
  I : Integer;
  Category : Char;
  PriorVal, CurrentVal,
  TotalPriorAssessedVal, TotalCurrentAssessedVal : Comp;
  PriorNumParcels, CurrentNumParcels,
  TotalPriorNumParcels, TotalCurrentNumParcels : LongInt;
  _Found : Boolean;

begin
  TotalPriorAssessedVal := 0;
  TotalCurrentAssessedVal := 0;
  TotalPriorNumParcels := 0;
  TotalCurrentNumParcels := 0;
  ProgressDialog.UserLabelCaption := 'Assessed Values By Property Class';

  with Sender as TBaseReport do
    begin
      PageNum := PageNum + 1;
      PrintReportHeader(Sender, ReportTime, PageNum,
                        'PART 1 - ASSESSOR''S REPORT TOTALS',
                        'FOR THE ' + CurrentAssessmentYear + ' ASSESSMENT ROLL',
                        ConvertSwisCodeToMunicipalitySwisCode(SwisCodeTable.FieldByName('SwisCode').Text));

      ClearTabs;
      SetPen(clBlack, psSolid, 1, pmCopy); { Set pen to 1 dot width }
      SetTab(0.5, pjLeft, 0.5, 0, BoxLineNone, 0);
      SetTab(1.1, pjLeft, 6, 0, BoxLineNone, 0);

      Println(#9 + 'I.' +
              #9 + 'SUMMARY OF ASSESSED VALUES ON PRIOR AND CURRENT ROLL BY PROPERTY CLASS');
      Println('');

      ClearTabs;
      SetTab(0.2, pjCenter, 0.8, 0, BoxLineNone, 0); {Prop class category}
      SetTab(4.2, pjCenter, 2.1, 0, BoxLineNone, 0);     {Prior header}
      SetTab(6.5, pjCenter, 2.1, 0, BoxLineNone, 0);   {Current header}
      SetTab(8.5, pjCenter, 2.1, 0, BoxLineNone, 0);  {Difference header}

        {Header}

      Println(#9 + 'PROPERTY' +
              #9 + '>>> PRIOR ROLL <<<' +
              #9 + '>>> CURRENT ROLL <<<' +
              #9 + '>>> DIFFERENCE <<<');

      ClearTabs;
      SetTab(0.2, pjCenter, 0.8, 0, BoxLineNone, 0); {Prop class category}
      SetTab(1.1, pjLeft, 2.5, 0, BoxLineNone, 0);     {Description}
      SetTab(4.2, pjRight, 1.2, 0, BoxLineNone, 0);     {Prior asssessed val}
      SetTab(5.5, pjRight, 0.7, 0, BoxLineNone, 0);  {# parcels prior}
      SetTab(6.4, pjRight, 1.2, 0, BoxLineNone, 0);     {Current Assessed val}
      SetTab(7.7, pjRight, 0.7, 0, BoxLineNone, 0);  {Current # parcels}
      SetTab(8.6, pjRight, 1.2, 0, BoxLineNone, 0);     {Diffference Assessed val}
      SetTab(9.9, pjRight, 0.7, 0, BoxLineNone, 0);  {Difference # parcels}

      Println(#9 + 'CLASS' +
              #9 + 'DESCRIPTION' +
              #9 + 'ASSESSED VAL' +
              #9 + 'PARCELS' +
              #9 + 'ASSESSED VAL' +
              #9 + 'PARCELS' +
              #9 + 'ASSESSED VAL' +
              #9 + 'PARCELS');
      Println('');

      ClearTabs;
      SetTab(0.2, pjCenter, 0.8, 0, BoxLineNone, 0); {Prop class category}
      SetTab(1.1, pjLeft, 2.5, 0, BoxLineNone, 0);     {Description}
      SetTab(4.2, pjRight, 1.2, 0, BoxLineNone, 0);     {Prior asssessed val}
      SetTab(5.5, pjRight, 0.7, 0, BoxLineNone, 0);  {# parcels prior}
      SetTab(6.4, pjRight, 1.2, 0, BoxLineNone, 0);     {Current Assessed val}
      SetTab(7.7, pjRight, 0.7, 0, BoxLineNone, 0);  {Current # parcels}
      SetTab(8.6, pjRight, 1.2, 0, BoxLineNone, 0);     {Diffference Assessed val}
      SetTab(9.9, pjRight, 0.7, 0, BoxLineNone, 0);  {Difference # parcels}

        {Now print the details}

      I := 1;

      while ((I <= NumPropClassCategories) and
             (not (Quit or ReportCancelled))) do
        begin
          Category := Chr(Ord('A') + I - 1);

          _Found := FindKeyOld(SortAVByPropClass_RS_Table,
                              ['RecType', 'Category'],
                              ['P', Category]);

          with SortAVByPropClass_RS_Table do
            begin
              ProgressDialog.Update(Self, 'Property Class: ' + PropClassShortDesc[I]);
              PriorVal := 0;
              PriorNumParcels := 0;
              CurrentVal := 0;
              CurrentNumParcels := 0;

              If _Found
                then
                  begin
                    PriorVal := TCurrencyField(FieldByName('PriorValue')).Value;
                    PriorNumParcels := FieldByName('PriorNumParcels').AsInteger;
                    CurrentVal := TCurrencyField(FieldByName('CurrentValue')).Value;
                    CurrentNumParcels := FieldByName('CurrentNumParcels').AsInteger;

                  end;  {If Found}

              Println(#9 + PropClassShortDesc[I] +
                      #9 + PropClassLongDesc[I] +
                      #9 + FormatFloat(CurrencyDisplayNoDollarSign, PriorVal) +
                      #9 + IntToStr(PriorNumParcels) +
                      #9 + FormatFloat(CurrencyDisplayNoDollarSign, CurrentVal) +
                      #9 + IntToStr(CurrentNumParcels) +
                      #9 + FormatFloat(CurrencyDisplayNoDollarSign, (CurrentVal - PriorVal)) +
                      #9 + IntToStr(CurrentNumParcels - PriorNumParcels));

              TotalPriorAssessedVal := TotalPriorAssessedVal + PriorVal;
              TotalPriorNumParcels := TotalPriorNumParcels + PriorNumParcels;
              TotalCurrentAssessedVal := TotalCurrentAssessedVal + CurrentVal;
              TotalCurrentNumParcels := TotalCurrentNumParcels + CurrentNumParcels;

            end;  {with SortAVByPropClass_RS_Table do}

          I := I + 1;

        end;  {while ((I <= NumPropClassCategories) and ...}

        {Now print the totals.}

      If not (Quit or ReportCancelled)
        then
          begin
            Println('');
            Println(#9 + #9 + 'TOTAL' +
                    #9 + FormatFloat(CurrencyDisplayNoDollarSign, TotalPriorAssessedVal) +
                    #9 + IntToStr(TotalPriorNumParcels) +
                    #9 + FormatFloat(CurrencyDisplayNoDollarSign, TotalCurrentAssessedVal) +
                    #9 + IntToStr(TotalCurrentNumParcels) +
                    #9 + FormatFloat(CurrencyDisplayNoDollarSign, (TotalCurrentAssessedVal - TotalPriorAssessedVal)) +
                    #9 + IntToStr(TotalCurrentNumParcels - TotalPriorNumParcels));

          end;  {If not (Quit or ReportCancelled)}

    end;  {with Sender as TBaseReport do}

end;  {PrintARTotalsSection1}

{===================================================================}
Procedure TAssessorsReportForm.PrintARTotalsSections2And3(    Sender : TObject;
                                                          var Quit : Boolean);

{Print the AR totals section 2, i.e. the roll section breakdown.}
{We will put one line per roll section (except 9).}
{Also print AR totals section 3 - just a 1 line total.}

const
  NumRollSectionCategories = 6;

type
  RollSectionShortDescArrayType = Array[1..NumRollSectionCategories] of Char;
  RollSectionLongDescArrayType = Array[1..NumRollSectionCategories] of String;

const
  RollSectionShortDesc : RollSectionShortDescArrayType =
      ('1', '3' ,'5', '6', '7', '8');

  RollSectionLongDesc : RollSectionLongDescArrayType =
      ('TAXABLE',
       'STATE OWNED LAND',
       'SPECIAL FRANCHISE',
       'UTILITIES / NON-CEILING RR',
       'CEILING RAILROADS',
       'WHOLLY EXEMPT');

var
  I : Integer;
  Category : Char;
  PriorVal, CurrentVal,
  TotalPriorAssessedVal, TotalCurrentAssessedVal : Comp;
  PriorNumParcels, CurrentNumParcels,
  TotalPriorNumParcels, TotalCurrentNumParcels,
  TotalCurrentParcelsInRS1Or6 : LongInt;
  _Found : Boolean;

begin
  ProgressDialog.UserLabelCaption := 'Assessed Value By Roll Section';
  TotalPriorAssessedVal := 0;
  TotalCurrentAssessedVal := 0;
  TotalPriorNumParcels := 0;
  TotalCurrentNumParcels := 0;
  TotalCurrentParcelsInRS1Or6 := 0;

  with Sender as TBaseReport do
    begin
      Println('');
      Println('');

      ClearTabs;
      SetPen(clBlack, psSolid, 1, pmCopy); { Set pen to 1 dot width }
      SetTab(0.5, pjLeft, 0.5, 0, BoxLineNone, 0);
      SetTab(1.1, pjLeft, 6, 0, BoxLineNone, 0);

      Println(#9 + 'II.' +
              #9 + 'SUMMARY OF ASSESSED VALUES ON PRIOR AND CURRENT ROLL BY ROLL SECTION');
      Println('');

      ClearTabs;
      SetTab(0.2, pjCenter, 0.8, 0, BoxLineNone, 0); {Prop class category}
      SetTab(4.2, pjCenter, 2.1, 0, BoxLineNone, 0);     {Prior header}
      SetTab(6.5, pjCenter, 2.1, 0, BoxLineNone, 0);   {Current header}
      SetTab(8.5, pjCenter, 2.1, 0, BoxLineNone, 0);  {Difference header}

        {Header}

      Println(#9 + 'ROLL' +
              #9 + '>>> PRIOR ROLL <<<' +
              #9 + '>>> CURRENT ROLL <<<' +
              #9 + '>>> DIFFERENCE <<<');

      ClearTabs;
      SetTab(0.2, pjCenter, 0.8, 0, BoxLineNone, 0); {Prop class category}
      SetTab(1.1, pjLeft, 2.5, 0, BoxLineNone, 0);     {Description}
      SetTab(4.2, pjRight, 1.2, 0, BoxLineNone, 0);     {Prior asssessed val}
      SetTab(5.5, pjRight, 0.7, 0, BoxLineNone, 0);  {# parcels prior}
      SetTab(6.4, pjRight, 1.2, 0, BoxLineNone, 0);     {Current Assessed val}
      SetTab(7.7, pjRight, 0.7, 0, BoxLineNone, 0);  {Current # parcels}
      SetTab(8.6, pjRight, 1.2, 0, BoxLineNone, 0);     {Diffference Assessed val}
      SetTab(9.9, pjRight, 0.7, 0, BoxLineNone, 0);  {Difference # parcels}

        {Header}

      Println(#9 + 'SECTION' +
              #9 + 'DESCRIPTION' +
              #9 + 'ASSESSED VAL' +
              #9 + 'PARCELS' +
              #9 + 'ASSESSED VAL' +
              #9 + 'PARCELS' +
              #9 + 'ASSESSED VAL' +
              #9 + 'PARCELS');
      Println('');

      ClearTabs;
      SetTab(0.2, pjCenter, 0.8, 0, BoxLineNone, 0); {Prop class category}
      SetTab(1.1, pjLeft, 2.5, 0, BoxLineNone, 0);     {Description}
      SetTab(4.2, pjRight, 1.2, 0, BoxLineNone, 0);     {Prior asssessed val}
      SetTab(5.5, pjRight, 0.7, 0, BoxLineNone, 0);  {# parcels prior}
      SetTab(6.4, pjRight, 1.2, 0, BoxLineNone, 0);     {Current Assessed val}
      SetTab(7.7, pjRight, 0.7, 0, BoxLineNone, 0);  {Current # parcels}
      SetTab(8.6, pjRight, 1.2, 0, BoxLineNone, 0);     {Diffference Assessed val}
      SetTab(9.9, pjRight, 0.7, 0, BoxLineNone, 0);  {Difference # parcels}

        {Now print the details}

      I := 1;

      while ((I <= NumRollSectionCategories) and
             (not (Quit or ReportCancelled))) do
        begin
          Category := RollSectionShortDesc[I];
          ProgressDialog.Update(Self, 'Roll Section: ' + RollSectionShortDesc[I]);

          _Found := FindKeyOld(SortAVByPropClass_RS_Table,
                              ['RecType', 'Category'],
                              ['R', Category]);

          with SortAVByPropClass_RS_Table do
            begin
              PriorVal := 0;
              PriorNumParcels := 0;
              CurrentVal := 0;
              CurrentNumParcels := 0;

              If _Found
                then
                  begin
                    PriorVal := TCurrencyField(FieldByName('PriorValue')).Value;
                    PriorNumParcels := FieldByName('PriorNumParcels').AsInteger;
                    CurrentVal := TCurrencyField(FieldByName('CurrentValue')).Value;
                    CurrentNumParcels := FieldByName('CurrentNumParcels').AsInteger;

                  end;  {If Found}

              Println(#9 + RollSectionShortDesc[I] +
                      #9 + RollSectionLongDesc[I] +
                      #9 + FormatFloat(CurrencyDisplayNoDollarSign, PriorVal) +
                      #9 + IntToStr(PriorNumParcels) +
                      #9 + FormatFloat(CurrencyDisplayNoDollarSign, CurrentVal) +
                      #9 + IntToStr(CurrentNumParcels) +
                      #9 + FormatFloat(CurrencyDisplayNoDollarSign, (CurrentVal - PriorVal)) +
                      #9 + IntToStr(CurrentNumParcels - PriorNumParcels));

              TotalPriorAssessedVal := TotalPriorAssessedVal + PriorVal;
              TotalPriorNumParcels := TotalPriorNumParcels + PriorNumParcels;
              TotalCurrentAssessedVal := TotalCurrentAssessedVal + CurrentVal;
              TotalCurrentNumParcels := TotalCurrentNumParcels + CurrentNumParcels;

              If (Category in ['1', '6'])
                then TotalCurrentParcelsInRS1Or6 := TotalCurrentParcelsInRS1Or6 +
                                                    CurrentNumParcels;

            end;  {with SortAVByPropClass_RS_Table do}

          I := I + 1;

        end;  {while ((I <= NumRollSectionCategories) and ...}

        {Now print the totals.}

      If not (Quit or ReportCancelled)
        then
          begin
            Println('');
            Println(#9 + #9 + 'TOTAL' +
                    #9 + FormatFloat(CurrencyDisplayNoDollarSign, TotalPriorAssessedVal) +
                    #9 + IntToStr(TotalPriorNumParcels) +
                    #9 + FormatFloat(CurrencyDisplayNoDollarSign, TotalCurrentAssessedVal) +
                    #9 + IntToStr(TotalCurrentNumParcels) +
                    #9 + FormatFloat(CurrencyDisplayNoDollarSign, (TotalCurrentAssessedVal - TotalPriorAssessedVal)) +
                    #9 + IntToStr(TotalCurrentNumParcels - TotalPriorNumParcels));

            Println('');
            Println('');

              {Section 3 (1 line only)}

            ClearTabs;
            SetTab(0.5, pjLeft, 0.5, 0, BoxLineNone, 0);
            SetTab(1.1, pjLeft, 8, 0, BoxLineNone, 0);

            Println(#9 + 'III.' +
                    #9 + 'NUMBER OF PARCELS IN ROLL SECTIONS 1 AND 6 ON THE CURRENT ASSESSMENT ROLL:  ' +
                    IntToStr(TotalCurrentParcelsInRS1Or6));

            NewPage;

          end;  {If not (Quit or ReportCancelled)}

    end;  {with Sender as TBaseReport do}

end;  {PrintARTotalsSections2And3}

{===================================================================}
Procedure TAssessorsReportForm.PrintARSection4Or5Subheader(Sender : TObject;
                                                           MunicipalityCode : String;
                                                           MunicipalityName : String);

{Print the informational section 4 and 5 sub header with
 school or swis code and school or swis name.}

begin
  with Sender as TBaseReport do
    begin
      ClearTabs;
      SetTab(0.3, pjLeft, 0.6, 0, BoxLineNone, 0);  {Code}
      SetTab(1.0, pjLeft, 1.9, 0, BoxLineNone, 0);  {Name}

      Println('');
      Println(#9 + MunicipalityCode +
              #9 + MunicipalityName);

    end;  {with Sender as TBaseReport do}

end;  {PrintARSection4Or5Subheader}

{===================================================================}
Procedure TAssessorsReportForm.PrintARSection4Header(Sender : TObject);

{Print the header for AR section 4 - totals by school code.}

begin
  with Sender as TBaseReport do
    begin
      ClearTabs;
      SetPen(clBlack, psSolid, 1, pmCopy); { Set pen to 1 dot width }
      SetTab(0.5, pjLeft, 0.5, 0, BoxLineNone, 0);
      SetTab(1.1, pjLeft, 9.5, 0, BoxLineNone, 0);

      Println(#9 + 'IV.' +
              #9 + 'SUMMARY OF TOTAL ASSESSED VALUES FOR LOCALLY ASSESSED PROPERTIES ON PRIOR AND CURRENT ROLL BY' +
                   ' SCHOOL DISTRICT');
      Println('');

      ClearTabs;
      SetTab(0.3, pjLeft, 0.6, 0, BoxLineNone, 0);  {School code}
      SetTab(1.0, pjLeft, 1.9, 0, BoxLineNone, 0);  {School name}
      SetTab(3.5, pjRight, 1.9, 0, BoxLineNone, 0);  {Prior amounts}
      SetTab(5.5, pjRight, 1.9, 0, BoxLineNone, 0);  {Current amounts}
      SetTab(7.5, pjRight, 1.9, 0, BoxLineNone, 0);  {Difference}

      Println(#9 + 'SCHOOL' +
              #9 + 'SCHOOL' +
              #9 + '>> PRIOR ROLL <<' +
              #9 + '>> CURRENT ROLL <<' +
              #9 + '>>> NET CHANGE <<<');
      Println(#9 + 'CODE' +
              #9 + 'NAME');

    end;  {with Sender as TBaseReport do}

end;  {PrintARSection4Header}

{===================================================================}
Procedure TAssessorsReportForm.PrintARSection4Or5Entry(
                                   Sender : TObject;
                                   SwisCodeTable : TTable;
                                   RS1PriorHomesteadVal,
                                   RS1PriorNonhomesteadVal,
                                   RS1CurrentHomesteadVal,
                                   RS1CurrentNonhomesteadVal,
                                   RS6PriorHomesteadVal,
                                   RS6PriorNonhomesteadVal,
                                   RS6CurrentHomesteadVal,
                                   RS6CurrentNonhomesteadVal : Comp);

{Print the information for one swis or school code.}

begin
  with Sender as TBaseReport do
    begin
      ClearTabs;
      SetTab(1.5, pjLeft, 1.4, 0, BoxLineNone, 0);  {Roll section}
      SetTab(3.5, pjRight, 1.9, 0, BoxLineNone, 0);  {Prior amounts}
      SetTab(5.5, pjRight, 1.9, 0, BoxLineNone, 0);  {Current amounts}
      SetTab(7.5, pjRight, 1.9, 0, BoxLineNone, 0);  {Difference}

        {Print roll section 1.}

      Println(#9 + 'ROLL SECTION 1' +
              #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                               (RS1PriorHomesteadVal + RS1PriorNonhomesteadVal)) +
              #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                               (RS1CurrentHomesteadVal + RS1CurrentNonhomesteadVal)) +
              #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                               ((RS1CurrentHomesteadVal + RS1CurrentNonhomesteadVal) -
                                (RS1PriorHomesteadVal + RS1PriorNonhomesteadVal))));

      If SwisCodeTable.FieldByName('Classified').AsBoolean
        then
          begin
            Println(#9 + '  HOMESTEAD' +
                    #9 + FormatFloat(CurrencyDisplayNoDollarSign, RS1PriorHomesteadVal) +
                    #9 + FormatFloat(CurrencyDisplayNoDollarSign, RS1CurrentHomesteadVal) +
                    #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                                     (RS1CurrentHomesteadVal - RS1PriorHomesteadVal)));

            Println(#9 + '  NON-HOMESTEAD' +
                    #9 + FormatFloat(CurrencyDisplayNoDollarSign, RS1PriorNonhomesteadVal) +
                    #9 + FormatFloat(CurrencyDisplayNoDollarSign, RS1CurrentNonhomesteadVal) +
                    #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                                     (RS1CurrentNonhomesteadVal - RS1PriorNonhomesteadVal)));

          end;  {If SwisCodeTable.FieldByName('Classified').AsBoolean}

        {Roll section 6}

      Println(#9 + 'ROLL SECTION 6' +
              #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                               (RS6PriorHomesteadVal + RS6PriorNonhomesteadVal)) +
              #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                               (RS6CurrentHomesteadVal + RS6CurrentNonhomesteadVal)) +
              #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                               ((RS6CurrentHomesteadVal + RS6CurrentNonhomesteadVal) -
                                (RS6PriorHomesteadVal + RS6PriorNonhomesteadVal))));

      If SwisCodeTable.FieldByName('Classified').AsBoolean
        then
          begin
            Println(#9 + '  HOMESTEAD' +
                    #9 + FormatFloat(CurrencyDisplayNoDollarSign, RS6PriorHomesteadVal) +
                    #9 + FormatFloat(CurrencyDisplayNoDollarSign, RS6CurrentHomesteadVal) +
                    #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                                     (RS6CurrentHomesteadVal - RS6PriorHomesteadVal)));

            Println(#9 + '  NON-HOMESTEAD' +
                    #9 + FormatFloat(CurrencyDisplayNoDollarSign, RS6PriorNonhomesteadVal) +
                    #9 + FormatFloat(CurrencyDisplayNoDollarSign, RS6CurrentNonhomesteadVal) +
                    #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                                     (RS6CurrentNonhomesteadVal - RS6PriorNonhomesteadVal)));

          end;  {If SwisCodeTable.FieldByName('Classified').AsBoolean}

         {Totals for this municipality}

      Println(#9 + 'TOTAL ASSESSED VALUE' +
              #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                               (RS1PriorHomesteadVal + RS1PriorNonhomesteadVal +
                                RS6PriorHomesteadVal + RS6PriorNonhomesteadVal)) +
              #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                               (RS1CurrentHomesteadVal + RS1CurrentNonhomesteadVal +
                                RS6CurrentHomesteadVal + RS6CurrentNonhomesteadVal)) +
              #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                               ((RS1CurrentHomesteadVal + RS1CurrentNonhomesteadVal +
                                 RS6CurrentHomesteadVal + RS6CurrentNonhomesteadVal) -
                                (RS1PriorHomesteadVal + RS1PriorNonhomesteadVal +
                                 RS6PriorHomesteadVal + RS6PriorNonhomesteadVal))));

      If SwisCodeTable.FieldByName('Classified').AsBoolean
        then
          begin
            Println(#9 + '  HOMESTEAD' +
                    #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                                     (RS1PriorHomesteadVal + RS6PriorHomesteadVal)) +
                    #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                                     (RS1CurrentHomesteadVal + RS6CurrentHomesteadVal)) +
                    #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                                     ((RS1CurrentHomesteadVal + RS6CurrentHomesteadVal) -
                                      (RS1PriorHomesteadVal + RS6PriorHomesteadVal))));

            Println(#9 + '  NON-HOMESTEAD' +
                    #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                                     (RS1PriorNonhomesteadVal + RS6PriorNonhomesteadVal)) +
                    #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                                     (RS1CurrentNonhomesteadVal + RS6CurrentNonhomesteadVal)) +
                    #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                                     ((RS1CurrentNonhomesteadVal + RS6CurrentNonhomesteadVal) -
                                      (RS1PriorNonhomesteadVal + RS6PriorNonhomesteadVal))));

          end;  {If SwisCodeTable.FieldByName('Classified').AsBoolean}

    end;  {with Sender as TBaseReport do}

end;  {PrintSection4Or5Entry}

{===================================================================}
Procedure TAssessorsReportForm.PrintARTotalsSection4(    Sender : TObject;
                                                         ReportTime : TDateTime;
                                                     var PageNum : Integer;
                                                     var Quit : Boolean);

{Print the AR totals section 4, i.e. the homestead\nonhomestead
 totals breakdown for schools.}

var
  RS1PriorHomesteadVal,
  RS1PriorNonhomesteadVal,
  RS1CurrentHomesteadVal,
  RS1CurrentNonhomesteadVal,
  RS6PriorHomesteadVal,
  RS6PriorNonhomesteadVal,
  RS6CurrentHomesteadVal,
  RS6CurrentNonhomesteadVal,
  TotalRS1PriorHomesteadVal,
  TotalRS1PriorNonhomesteadVal,
  TotalRS1CurrentHomesteadVal,
  TotalRS1CurrentNonhomesteadVal,
  TotalRS6PriorHomesteadVal,
  TotalRS6PriorNonhomesteadVal,
  TotalRS6CurrentHomesteadVal,
  TotalRS6CurrentNonhomesteadVal : Comp;
  Found, Done, FirstTimeThrough : Boolean;
  SchoolName : String;
  PreviousSchoolCode : String;

begin
  ProgressDialog.UserLabelCaption := 'Assessed Value By School District';
  PreviousSchoolCode := '';
  TotalRS1PriorHomesteadVal := 0;
  TotalRS1PriorNonhomesteadVal := 0;
  TotalRS1CurrentHomesteadVal := 0;
  TotalRS1CurrentNonhomesteadVal := 0;
  TotalRS6PriorHomesteadVal := 0;
  TotalRS6PriorNonhomesteadVal := 0;
  TotalRS6CurrentHomesteadVal := 0;
  TotalRS6CurrentNonhomesteadVal := 0;

  RS1PriorHomesteadVal := 0;
  RS1PriorNonhomesteadVal := 0;
  RS1CurrentHomesteadVal := 0;
  RS1CurrentNonhomesteadVal := 0;

  RS6PriorHomesteadVal := 0;
  RS6PriorNonhomesteadVal := 0;
  RS6CurrentHomesteadVal := 0;
  RS6CurrentNonhomesteadVal := 0;

  with Sender as TBaseReport do
    begin
      PageNum := PageNum + 1;
      PrintReportHeader(Sender, ReportTime, PageNum,
                        'PART 1 - ASSESSOR''S REPORT TOTALS',
                        'FOR THE ' + CurrentAssessmentYear + ' ASSESSMENT ROLL',
                        ConvertSwisCodeToMunicipalitySwisCode(SwisCodeTable.FieldByName('SwisCode').Text));

      Done := False;
      FirstTimeThrough := True;

      SetRangeOld(SortTotalAssessedValTable,
                  ['RecType', 'MunicipalityCode', 'RollSection', 'Block'],
                  ['C', '      ', '1', '    '],
                  ['C', '999999', '9', 'ZZZZ']);
      SortTotalAssessedValTable.First;

      PrintARSection4Header(Sender);
      PreviousSchoolCode := SortTotalAssessedValTable.FieldByName('MunicipalityCode').Text;

        {Loop through all the school sort records printing out the information
         for each.}

      repeat
        If FirstTimeThrough
          then FirstTimeThrough := False
          else
            try
              SortTotalAssessedValTable.Next;
            except
              Quit := True;
              SystemSupport(001, SortTotalAssessedValTable, 'Error getting total assessed val school sort record.',
                            UnitName, GlblErrorDlgBox);
            end;

        with SortTotalAssessedValTable do
          If (EOF or
              (Deblank(FieldByName('RecType').Text) = ''))
            then Done := True;

          {If this is a good record, print out the information.}

        If not Quit
          then
            begin
              ProgressDialog.Update(Self,
                                    'School: ' +
                                    SortTotalAssessedValTable.FieldByName('MunicipalityCode').Text);

                {If we changed school codes, then print a new
                 sub header.}

              If (Done or
                  (Take(6, PreviousSchoolCode) <>
                   Take(6, SortTotalAssessedValTable.FieldByName('MunicipalityCode').Text)))
                then
                  begin
                      {FXX09081998-5: Make sure there is enough room to print on
                                      this page.}
                      {FXX10211998-9: Need to print rpt hdr.}

                    If (LinesLeft < 10)
                      then
                        begin
                          NewPage;
                          PageNum := PageNum + 1;
                          PrintReportHeader(Sender, ReportTime, PageNum,
                                            'PART 1 - ASSESSOR''S REPORT TOTALS',
                                            'FOR THE ' + CurrentAssessmentYear + ' ASSESSMENT ROLL',
                                            ConvertSwisCodeToMunicipalitySwisCode(SwisCodeTable.FieldByName('SwisCode').Text));

                          PrintARSection4Header(Sender);
                        end;

                      {Print out the header for the last school code.}

                    Found := FindKeyOld(SchoolTable, ['SchoolCode'],
                                        [PreviousSchoolCode]);

                    If Found
                      then SchoolName := SchoolTable.FieldByName('SchoolName').Text
                      else SchoolName := 'NOT IN LIBRARY';

                    with SortTotalAssessedValTable do
                      PrintARSection4or5Subheader(Sender, PreviousSchoolCode,
                                                  SchoolName);

                    PreviousSchoolCode := SortTotalAssessedValTable.FieldByName('MunicipalityCode').Text;

                      {Print out the previous school code.}

                    PrintARSection4or5Entry(Sender, SwisCodeTable,
                                            RS1PriorHomesteadVal,
                                            RS1PriorNonhomesteadVal,
                                            RS1CurrentHomesteadVal,
                                            RS1CurrentNonhomesteadVal,
                                            RS6PriorHomesteadVal,
                                            RS6PriorNonhomesteadVal,
                                            RS6CurrentHomesteadVal,
                                            RS6CurrentNonhomesteadVal);

                      {Update the totals.}

                    TotalRS1PriorHomesteadVal := TotalRS1PriorHomesteadVal + RS1PriorHomesteadVal;
                    TotalRS1PriorNonhomesteadVal := TotalRS1PriorNonhomesteadVal + RS1PriorNonhomesteadVal;
                    TotalRS1CurrentHomesteadVal := TotalRS1CurrentHomesteadVal + RS1CurrentHomesteadVal;
                    TotalRS1CurrentNonhomesteadVal := TotalRS1CurrentNonhomesteadVal + RS1CurrentNonhomesteadVal;
                    TotalRS6PriorHomesteadVal := TotalRS6PriorHomesteadVal + RS6PriorHomesteadVal;
                    TotalRS6PriorNonhomesteadVal := TotalRS6PriorNonhomesteadVal + RS6PriorNonhomesteadVal;
                    TotalRS6CurrentHomesteadVal := TotalRS6CurrentHomesteadVal + RS6CurrentHomesteadVal;
                    TotalRS6CurrentNonhomesteadVal := TotalRS6CurrentNonhomesteadVal + RS6CurrentNonhomesteadVal;

                      {Reset the totals for the next parcel.}

                    RS1PriorHomesteadVal := 0;
                    RS1PriorNonhomesteadVal := 0;
                    RS1CurrentHomesteadVal := 0;
                    RS1CurrentNonhomesteadVal := 0;

                    RS6PriorHomesteadVal := 0;
                    RS6PriorNonhomesteadVal := 0;
                    RS6CurrentHomesteadVal := 0;
                    RS6CurrentNonhomesteadVal := 0;

                  end;  {If (Take(6, LastSchoolCode) <> ...}

                {Get the assessed values for this roll section.}

              If not Done
                then
                  with SortTotalAssessedValTable do
                    begin
                      If (FieldByName('RollSection').Text = '1')
                        then
                          begin
                            RS1PriorHomesteadVal := RS1PriorHomesteadVal +
                                                    TCurrencyField(FieldByName('HomestdPriorVal')).Value;
                            RS1PriorNonhomesteadVal := RS1PriorNonhomesteadVal +
                                                       TCurrencyField(FieldByName('NonhomestdPriorVal')).Value;
                            RS1CurrentHomesteadVal := RS1CurrentHomesteadVal +
                                                      TCurrencyField(FieldByName('HomestdCurrentVal')).Value;
                            RS1CurrentNonhomesteadVal := RS1CurrentNonhomesteadVal +
                                                         TCurrencyField(FieldByName('NonhomestdCurrentVal')).Value;

                          end;  {If (FieldByName('RollSection') = '1')}

                      If (FieldByName('RollSection').Text = '6')
                        then
                          begin
                            RS6PriorHomesteadVal := RS6PriorHomesteadVal +
                                                    TCurrencyField(FieldByName('HomestdPriorVal')).Value;
                            RS6PriorNonhomesteadVal := RS6PriorNonhomesteadVal +
                                                       TCurrencyField(FieldByName('NonhomestdPriorVal')).Value;
                            RS6CurrentHomesteadVal := RS6CurrentHomesteadVal +
                                                      TCurrencyField(FieldByName('HomestdCurrentVal')).Value;
                            RS6CurrentNonhomesteadVal := RS6CurrentNonhomesteadVal +
                                                         TCurrencyField(FieldByName('NonhomestdCurrentVal')).Value;

                          end;  {If (FieldByName('RollSection') = '6')}

                    end;  {with SortTotalAssessedValTable do}

            end;  {If not Done}

      until (Quit or Done or ReportCancelled);

        {Print the over all totals.}

      If not (Quit or ReportCancelled)
        then
          begin
            If (LinesLeft < 10)
              then
                begin
                  NewPage;
                  PageNum := PageNum + 1;
                  PrintReportHeader(Sender, ReportTime, PageNum,
                                    'PART 1 - ASSESSOR''S REPORT TOTALS',
                                    'FOR THE ' + CurrentAssessmentYear + ' ASSESSMENT ROLL',
                                    ConvertSwisCodeToMunicipalitySwisCode(SwisCodeTable.FieldByName('SwisCode').Text));

                  PrintARSection4Header(Sender);
                end;

            PrintARSection4or5Subheader(Sender, 'TOTAL', UpcaseStr(GetMunicipalityName));

            PrintARSection4or5Entry(Sender, SwisCodeTable,
                                    TotalRS1PriorHomesteadVal,
                                    TotalRS1PriorNonhomesteadVal,
                                    TotalRS1CurrentHomesteadVal,
                                    TotalRS1CurrentNonhomesteadVal,
                                    TotalRS6PriorHomesteadVal,
                                    TotalRS6PriorNonhomesteadVal,
                                    TotalRS6CurrentHomesteadVal,
                                    TotalRS6CurrentNonhomesteadVal);

            NewPage;

          end;  {If not (Quit or ReportCancelled)}

    end;  {with Sender as TBaseReport do}

end;  {PrintARTotalsSection4}

{===================================================================}
Procedure TAssessorsReportForm.PrintARSection5Header(Sender : TObject);

{Print the header for AR section 5 - totals by swis code.}

begin
  with Sender as TBaseReport do
    begin
      ClearTabs;
      SetPen(clBlack, psSolid, 1, pmCopy); { Set pen to 1 dot width }
      SetTab(0.5, pjLeft, 0.5, 0, BoxLineNone, 0);
      SetTab(1.1, pjLeft, 9.5, 0, BoxLineNone, 0);

      Println(#9 + 'V.' +
              #9 + 'SUMMARY OF TOTAL ASSESSED VALUES FOR LOCALLY ASSESSED PROPERTIES ON PRIOR AND CURRENT ROLL BY');
      Println(#9 + #9 + 'VILLAGE AND TOWN OUTSIDE');
      Println('');

      ClearTabs;
      SetTab(0.3, pjLeft, 0.7, 0, BoxLineNone, 0);  {School code}
      SetTab(1.1, pjLeft, 1.9, 0, BoxLineNone, 0);  {School name}
      SetTab(3.6, pjRight, 1.9, 0, BoxLineNone, 0);  {Prior amounts}
      SetTab(5.6, pjRight, 1.9, 0, BoxLineNone, 0);  {Current amounts}
      SetTab(7.6, pjRight, 1.9, 0, BoxLineNone, 0);  {Difference}

      Println(#9 + 'VILLAGE' +
              #9 + 'VILLAGE' +
              #9 + '>> PRIOR ROLL <<' +
              #9 + '>> CURRENT ROLL <<' +
              #9 + '>>> NET CHANGE <<<');
      Println(#9 + 'CODE' +
              #9 + 'NAME');

    end;  {with Sender as TBaseReport do}

end;  {PrintARSection5Header}

{===================================================================}
Procedure TAssessorsReportForm.PrintARTotalsSection5(    Sender : TObject;
                                                         ReportTime : TDateTime;
                                                     var PageNum : Integer;
                                                     var Quit : Boolean);

{Print the AR totals section 5, i.e. the homestead\nonhomestead
 totals breakdown for Swis.}

var
  RS1PriorHomesteadVal,
  RS1PriorNonhomesteadVal,
  RS1CurrentHomesteadVal,
  RS1CurrentNonhomesteadVal,
  RS6PriorHomesteadVal,
  RS6PriorNonhomesteadVal,
  RS6CurrentHomesteadVal,
  RS6CurrentNonhomesteadVal,
  TotalRS1PriorHomesteadVal,
  TotalRS1PriorNonhomesteadVal,
  TotalRS1CurrentHomesteadVal,
  TotalRS1CurrentNonhomesteadVal,
  TotalRS6PriorHomesteadVal,
  TotalRS6PriorNonhomesteadVal,
  TotalRS6CurrentHomesteadVal,
  TotalRS6CurrentNonhomesteadVal : Comp;
  Found, Done, FirstTimeThrough : Boolean;
  SwisName : String;
  PreviousSwisCode : String;

begin
  ProgressDialog.UserLabelCaption := 'Summary By Village And TO';
  PreviousSwisCode := '';
  TotalRS1PriorHomesteadVal := 0;
  TotalRS1PriorNonhomesteadVal := 0;
  TotalRS1CurrentHomesteadVal := 0;
  TotalRS1CurrentNonhomesteadVal := 0;
  TotalRS6PriorHomesteadVal := 0;
  TotalRS6PriorNonhomesteadVal := 0;
  TotalRS6CurrentHomesteadVal := 0;
  TotalRS6CurrentNonhomesteadVal := 0;

  RS1PriorHomesteadVal := 0;
  RS1PriorNonhomesteadVal := 0;
  RS1CurrentHomesteadVal := 0;
  RS1CurrentNonhomesteadVal := 0;

  RS6PriorHomesteadVal := 0;
  RS6PriorNonhomesteadVal := 0;
  RS6CurrentHomesteadVal := 0;
  RS6CurrentNonhomesteadVal := 0;

  with Sender as TBaseReport do
    begin
      PageNum := PageNum + 1;
      PrintReportHeader(Sender, ReportTime, PageNum,
                        'PART 1 - ASSESSOR''S REPORT TOTALS',
                        'FOR THE ' + CurrentAssessmentYear + ' ASSESSMENT ROLL',
                        ConvertSwisCodeToMunicipalitySwisCode(SwisCodeTable.FieldByName('SwisCode').Text));

      Done := False;
      FirstTimeThrough := True;

      SetRangeOld(SortTotalAssessedValTable,
                  ['RecType', 'MunicipalityCode', 'RollSection', 'Block'],
                  ['S', '      ', '1', '    '],
                  ['S', '999999', '9', 'ZZZZ']);
      SortTotalAssessedValTable.First;

      PrintARSection5Header(Sender);
      PreviousSwisCode := SortTotalAssessedValTable.FieldByName('MunicipalityCode').Text;

        {Loop through all the Swis sort records printing out the information
         for each.}

      repeat
        If FirstTimeThrough
          then FirstTimeThrough := False
          else
            try
              SortTotalAssessedValTable.Next;
            except
              Quit := True;
              SystemSupport(001, SortTotalAssessedValTable, 'Error getting total assessed val Swis sort record.',
                            UnitName, GlblErrorDlgBox);
            end;

        with SortTotalAssessedValTable do
          If (EOF or
              (Deblank(FieldByName('RecType').Text) = ''))
            then Done := True;

          {If this is a good record, print out the information.
           This is only villages, so skip the '00' swis code.}

        If ((not Quit) and
            (Copy(SortTotalAssessedValTable.FieldByName('MunicipalityCode').Text, 5, 2) <> '00'))
          then
            begin
              ProgressDialog.Update(Self,
                                    'Swis: ' +
                                    SortTotalAssessedValTable.FieldByName('MunicipalityCode').Text);

                {If we changed Swis codes, then print a new
                 sub header.}

              If (Done or
                  (Take(6, PreviousSwisCode) <>
                   Take(6, SortTotalAssessedValTable.FieldByName('MunicipalityCode').Text)))
                then
                  begin
                      {FXX09081998-5: Make sure there is enough room to print on
                                      this page.}
                      {FXX10211998-9: Need to print rpt hdr.}

                    If (LinesLeft < 10)
                      then
                        begin
                          NewPage;
                          PageNum := PageNum + 1;
                          PrintReportHeader(Sender, ReportTime, PageNum,
                                            'PART 1 - ASSESSOR''S REPORT TOTALS',
                                            'FOR THE ' + CurrentAssessmentYear + ' ASSESSMENT ROLL',
                                            ConvertSwisCodeToMunicipalitySwisCode(SwisCodeTable.FieldByName('SwisCode').Text));
                          PrintARSection5Header(Sender);
                        end;

                      {Print out the header for the last Swis code.}

                    Found := FindKeyOld(SwisCodeTable, ['SwisCode'],
                                        [PreviousSwisCode]);

                    If Found
                      then SwisName := SwisCodeTable.FieldByName('MunicipalityName').Text
                      else SwisName := 'NOT IN LIBRARY';

                    with SortTotalAssessedValTable do
                      PrintARSection4or5Subheader(Sender, PreviousSwisCode,
                                                  SwisName);

                    PreviousSwisCode := SortTotalAssessedValTable.FieldByName('MunicipalityCode').Text;

                      {Print out the previous Swis code.}

                    PrintARSection4or5Entry(Sender, SwisCodeTable,
                                            RS1PriorHomesteadVal,
                                            RS1PriorNonhomesteadVal,
                                            RS1CurrentHomesteadVal,
                                            RS1CurrentNonhomesteadVal,
                                            RS6PriorHomesteadVal,
                                            RS6PriorNonhomesteadVal,
                                            RS6CurrentHomesteadVal,
                                            RS6CurrentNonhomesteadVal);

                      {Update the totals.}

                    TotalRS1PriorHomesteadVal := TotalRS1PriorHomesteadVal + RS1PriorHomesteadVal;
                    TotalRS1PriorNonhomesteadVal := TotalRS1PriorNonhomesteadVal + RS1PriorNonhomesteadVal;
                    TotalRS1CurrentHomesteadVal := TotalRS1CurrentHomesteadVal + RS1CurrentHomesteadVal;
                    TotalRS1CurrentNonhomesteadVal := TotalRS1CurrentNonhomesteadVal + RS1CurrentNonhomesteadVal;
                    TotalRS6PriorHomesteadVal := TotalRS6PriorHomesteadVal + RS6PriorHomesteadVal;
                    TotalRS6PriorNonhomesteadVal := TotalRS6PriorNonhomesteadVal + RS6PriorNonhomesteadVal;
                    TotalRS6CurrentHomesteadVal := TotalRS6CurrentHomesteadVal + RS6CurrentHomesteadVal;
                    TotalRS6CurrentNonhomesteadVal := TotalRS6CurrentNonhomesteadVal + RS6CurrentNonhomesteadVal;

                      {Reset the totals for the next parcel.}

                    RS1PriorHomesteadVal := 0;
                    RS1PriorNonhomesteadVal := 0;
                    RS1CurrentHomesteadVal := 0;
                    RS1CurrentNonhomesteadVal := 0;

                    RS6PriorHomesteadVal := 0;
                    RS6PriorNonhomesteadVal := 0;
                    RS6CurrentHomesteadVal := 0;
                    RS6CurrentNonhomesteadVal := 0;

                  end;  {If (Take(6, LastSwisCode) <> ...}

                {Get the assessed values for this roll section.}

              If not Done
                then
                  with SortTotalAssessedValTable do
                    begin
                      If (FieldByName('RollSection').Text = '1')
                        then
                          begin
                            RS1PriorHomesteadVal := RS1PriorHomesteadVal +
                                                    TCurrencyField(FieldByName('HomestdPriorVal')).Value;
                            RS1PriorNonhomesteadVal := RS1PriorNonhomesteadVal +
                                                       TCurrencyField(FieldByName('NonhomestdPriorVal')).Value;
                            RS1CurrentHomesteadVal := RS1CurrentHomesteadVal +
                                                      TCurrencyField(FieldByName('HomestdCurrentVal')).Value;
                            RS1CurrentNonhomesteadVal := RS1CurrentNonhomesteadVal +
                                                         TCurrencyField(FieldByName('NonhomestdCurrentVal')).Value;

                          end;  {If (FieldByName('RollSection') = '1')}

                      If (FieldByName('RollSection').Text = '6')
                        then
                          begin
                            RS6PriorHomesteadVal := RS6PriorHomesteadVal +
                                                    TCurrencyField(FieldByName('HomestdPriorVal')).Value;
                            RS6PriorNonhomesteadVal := RS6PriorNonhomesteadVal +
                                                       TCurrencyField(FieldByName('NonhomestdPriorVal')).Value;
                            RS6CurrentHomesteadVal := RS6CurrentHomesteadVal +
                                                      TCurrencyField(FieldByName('HomestdCurrentVal')).Value;
                            RS6CurrentNonhomesteadVal := RS6CurrentNonhomesteadVal +
                                                         TCurrencyField(FieldByName('NonhomestdCurrentVal')).Value;

                          end;  {If (FieldByName('RollSection') = '6')}

                    end;  {with SortTotalAssessedValTable do}

            end;  {If not Done}

      until (Quit or Done or ReportCancelled);

        {Print the over all totals.}

      If not (Quit or ReportCancelled)
        then
          begin
            PrintARSection4or5Subheader(Sender, 'TOTAL', UpcaseStr(GetMunicipalityName));

            PrintARSection4or5Entry(Sender, SwisCodeTable,
                                    TotalRS1PriorHomesteadVal,
                                    TotalRS1PriorNonhomesteadVal,
                                    TotalRS1CurrentHomesteadVal,
                                    TotalRS1CurrentNonhomesteadVal,
                                    TotalRS6PriorHomesteadVal,
                                    TotalRS6PriorNonhomesteadVal,
                                    TotalRS6CurrentHomesteadVal,
                                    TotalRS6CurrentNonhomesteadVal);

          end;  {If not (Quit or ReportCancelled)}

    end;  {with Sender as TBaseReport do}

end;  {PrintARTotalsSection5}

{===================================================================}
Procedure  PrintSection6Subheader(Sender : TObject);

begin
  with Sender as TBaseReport do
    begin
      ClearTabs;
      SetTab(0.3, pjLeft, 1.0, 0, BoxLineNone, 0);  {Portion}
      SetTab(1.4, pjLeft, 0.6, 0, BoxLineNone, 0);  {Code}
      SetTab(2.1, pjLeft, 2.0, 0, BoxLineNone, 0);  {Description}
      SetTab(5.2, pjRight, 1.5, 0, BoxLineNone, 0);  {Increase}
      SetTab(6.8, pjRight, 1.5, 0, BoxLineNone, 0);  {Decrease}
      SetTab(8.4, pjRight, 1.5, 0, BoxLineNone, 0);  {Net change}
      SetTab(10.0, pjRight, 1.6, 0, BoxLineNone, 0);  {Assessed}

      Println(#9 + #9 + #9 +
              #9 + 'PHY QTY INC' +
              #9 + 'PHY QTY DEC' +
              #9 + #9 + 'CURRENT ASSESSED');
      Println(#9 + #9 + #9 +
              #9 + 'EQUAL INC' +
              #9 + 'EQUAL DEC' +
              #9 + #9 + 'PRIOR ASSESSED');
      Println(#9 + 'PORTION' +
              #9 + 'CODE' +
              #9 + 'DESCRIPTION' +
              #9 + 'TOTAL INC' +
              #9 + 'TOTAL DEC' +
              #9 + 'NET CHANGE' +
              #9 + 'ASSESSED DIFF');

    end;  {with Sender as TBaseReport do}

end;  {PrintSection6Subheader}

{===================================================================}
Procedure TAssessorsReportForm.PrintSection6Totals(Sender : TObject;
                                                   PortionType,
                                                   MunicipalityCode,
                                                   MunicipalityName : String;
                                                   HstdPhysicalQtyIncrease,
                                                   HstdEqualizationIncrease,
                                                   HstdPhysicalQtyDecrease,
                                                   HstdEqualizationDecrease,
                                                   HstdPriorAssessed,
                                                   HstdCurrentAssessed,
                                                   NonhstdPhysicalQtyIncrease,
                                                   NonhstdEqualizationIncrease,
                                                   NonhstdPhysicalQtyDecrease,
                                                   NonhstdEqualizationDecrease,
                                                   NonhstdPriorAssessed,
                                                   NonhstdCurrentAssessed : Comp);

{Print one entry for the totals by portion.}

const
  DividingLine = '_______________';

var
  TotalIncrease, TotalDecrease : Comp;

begin
  with Sender as TBaseReport do
    begin
      Println(#9 + PortionType);
      Println(#9 + #9 + MunicipalityCode +
              #9 + MunicipalityName);

      Println(#9 + #9 + #9 + '  HOMESTEAD TOTALS' +
              #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                               HstdPhysicalQtyIncrease) +
              #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                               HstdPhysicalQtyDecrease) +
              #9 + #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                                    HstdCurrentAssessed));
      Println(#9 + #9 + #9 +
              #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                               HstdEqualizationIncrease) +
              #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                               HstdEqualizationDecrease) +
              #9 + #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                                    HstdPriorAssessed));
      Println(#9 + #9 + #9 +
              #9 + DividingLine +
              #9 + DividingLine);

      TotalIncrease := HstdEqualizationIncrease + HstdPhysicalQtyIncrease;
      TotalDecrease := HstdEqualizationDecrease + HstdPhysicalQtyDecrease;

      Println(#9 + #9 + #9 +
              #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                               TotalIncrease) +
              #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                               TotalDecrease) +
              #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                               (TotalIncrease - TotalDecrease)) +
              #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                               (HstdCurrentAssessed - HstdPriorAssessed)));
      Println('');

      Println(#9 + #9 + #9 + '  NON-HOMESTEAD TOTALS' +
              #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                               NonhstdPhysicalQtyIncrease) +
              #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                               NonhstdPhysicalQtyDecrease) +
              #9 + #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                                    NonhstdCurrentAssessed));
      Println(#9 + #9 + #9 +
              #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                               NonhstdEqualizationIncrease) +
              #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                               NonhstdEqualizationDecrease) +
              #9 + #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                                    NonhstdPriorAssessed));
      Println(#9 + #9 + #9 +
              #9 + DividingLine +
              #9 + DividingLine);

      TotalIncrease := NonhstdEqualizationIncrease + NonhstdPhysicalQtyIncrease;
      TotalDecrease := NonhstdEqualizationDecrease + NonhstdPhysicalQtyDecrease;

      Println(#9 + #9 + #9 +
              #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                               TotalIncrease) +
              #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                               TotalDecrease) +
              #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                               (TotalIncrease - TotalDecrease)) +
              #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                               (NonhstdCurrentAssessed - NonhstdPriorAssessed)));
      Println('');

    end;  {with Sender as TBaseReport do}

end;  {PrintSection6Totals}

{===================================================================}
Procedure TAssessorsReportForm.PrintARTotalsSection6(    Sender : TObject;
                                                         ReportTime : TDateTime;
                                                     var PageNum : Integer;
                                                     var Quit : Boolean);

{Print the AR totals section 6, i.e. the homestead\nonhomestead
 totals breakdown by portion.}

var
  HstdPhysicalQtyIncrease, HstdEqualizationIncrease,
  HstdPhysicalQtyDecrease, HstdEqualizationDecrease,
  HstdPriorAssessed, HstdCurrentAssessed,
  NonhstdPhysicalQtyIncrease, NonhstdEqualizationIncrease,
  NonhstdPhysicalQtyDecrease, NonhstdEqualizationDecrease,
  NonhstdPriorAssessed, NonhstdCurrentAssessed : Comp;

  Done, FirstTimeThrough : Boolean;
  Detail225ChangeFile : TextFile;

begin
  AssignFile(Detail225ChangeFile, '225DTLS.TXT');
  Rewrite(Detail225ChangeFile);

    {FXX03152001-1: Put headers out for the 225 details.}

  Writeln(Detail225ChangeFile, '"Parcel ID",',
                               '"Prior HC",',
                               '"Current HC",',
                               '"Split Merge #",',
                               '"Prior AV",',
                               '"Current AV",',
                               '"Hstd Phys Inc",',
                               '"Hstd Phys Dec",',
                               '"Hstd Eq Inc",',
                               '"Hstd Eq Dec",',
                               '"Nonhstd Phys Inc",',
                               '"Nonhstd Phys Dec",',
                               '"Nonhstd Eq Inc",',
                               '"Nonhstd Eq Dec"');

    {FXX1021998-6: Missing a page break.}

  with Sender as TBaseReport do
    begin
      NewPage;
      PageNum := PageNum + 1;
      PrintReportHeader(Sender, ReportTime, PageNum,
                        'PART 1 - ASSESSOR''S REPORT TOTALS',
                        'FOR THE ' + CurrentAssessmentYear + ' ASSESSMENT ROLL',
                        ConvertSwisCodeToMunicipalitySwisCode(SwisCodeTable.FieldByName('SwisCode').Text));

      ClearTabs;
      SetTab(0.3, pjLeft, 0.2, 0, BoxLineNone, 0);  {Number}
      SetTab(0.6, pjLeft, 10.0, 0, BoxLineNone, 0);  {Text}

      Println('');
      Println(#9 + 'VI' +
              #9 + 'SUMMARY OF INCREASES AND DECREASES IN TOTAL ASSESSED VALUE' +
                   ' FROM PRIOR ROLL TO CURRENT ROLL BY PORTION.');
      Println(#9 + #9 + 'THIS REPORT INCLUDES ROLL SECTION 1 AND 6.  THE VALUES' +
                        ' GENERATED ARE USED TO CALCULATE CLASS EQUALIZATION RATES.');
      Println('');


      PrintSection6Subheader(Sender);

        {First do the over all municipality totals.}
        {FXX10211998-8: Do not hardcode CountyTownCode, i.e first 4 chars of swis.}

      GetSection6Totals('S', CountyTownCode,
                        HstdPhysicalQtyIncrease, HstdEqualizationIncrease,
                        HstdPhysicalQtyDecrease, HstdEqualizationDecrease,
                        HstdPriorAssessed, HstdCurrentAssessed,
                        NonhstdPhysicalQtyIncrease, NonhstdEqualizationIncrease,
                        NonhstdPhysicalQtyDecrease, NonhstdEqualizationDecrease,
                        NonhstdPriorAssessed, NonhstdCurrentAssessed,
                        SortAssessedValChangesTable, SortTotalAssessedValTable,
                        True, Detail225ChangeFile, Quit);

      PrintSection6Totals(Sender,
                          UpcaseStr(GetMunicipalityTypeName(GlblMunicipalityType)) + ':',
                          CountyTownCode, GlblMunicipalityName,
                          HstdPhysicalQtyIncrease, HstdEqualizationIncrease,
                          HstdPhysicalQtyDecrease, HstdEqualizationDecrease,
                          HstdPriorAssessed, HstdCurrentAssessed,
                          NonhstdPhysicalQtyIncrease, NonhstdEqualizationIncrease,
                          NonhstdPhysicalQtyDecrease, NonhstdEqualizationDecrease,
                          NonhstdPriorAssessed, NonhstdCurrentAssessed);

      Println('');

        {Now do assessing villages.}

      FirstTimeThrough := True;
      Done := False;

      SwisCodeTable.First;

      repeat
        If FirstTimeThrough
          then FirstTimeThrough := False
          else SwisCodeTable.Next;

        If SwisCodeTable.EOF
          then Done := True;

        with SwisCodeTable do
          If ((not Done) and
              FieldByName('AssessingVillage').AsBoolean)
            then
              begin
                If (LinesLeft < 15)
                  then
                    begin
                      NewPage;
                      PageNum := PageNum + 1;
                      PrintReportHeader(Sender, ReportTime, PageNum,
                                        'PART 1 - ASSESSOR''S REPORT TOTALS',
                                        'FOR THE ' + CurrentAssessmentYear + ' ASSESSMENT ROLL',
                                        ConvertSwisCodeToMunicipalitySwisCode(SwisCodeTable.FieldByName('SwisCode').Text));

                      PrintSection6Subheader(Sender);

                    end;  {If (LineCnt < 12)}

                GetSection6Totals('S', FieldByName('SwisCode').Text,
                                  HstdPhysicalQtyIncrease, HstdEqualizationIncrease,
                                  HstdPhysicalQtyDecrease, HstdEqualizationDecrease,
                                  HstdPriorAssessed, HstdCurrentAssessed,
                                  NonhstdPhysicalQtyIncrease, NonhstdEqualizationIncrease,
                                  NonhstdPhysicalQtyDecrease, NonhstdEqualizationDecrease,
                                  NonhstdPriorAssessed, NonhstdCurrentAssessed,
                                  SortAssessedValChangesTable,
                                  SortTotalAssessedValTable,
                                  False, Detail225ChangeFile, Quit);

                PrintSection6Totals(Sender, 'ASSESSING VILLAGE:',
                                    FieldByName('SwisCode').Text,
                                    FieldByName('MunicipalityName').Text,
                                    HstdPhysicalQtyIncrease, HstdEqualizationIncrease,
                                    HstdPhysicalQtyDecrease, HstdEqualizationDecrease,
                                    HstdPriorAssessed, HstdCurrentAssessed,
                                    NonhstdPhysicalQtyIncrease, NonhstdEqualizationIncrease,
                                    NonhstdPhysicalQtyDecrease, NonhstdEqualizationDecrease,
                                    NonhstdPriorAssessed, NonhstdCurrentAssessed);

                Println('');

              end;  {If ((not Done) and ...}

      until Done;

        {Next do non-assessing villages.}

      FirstTimeThrough := True;
      Done := False;

      SwisCodeTable.First;

      repeat
        If FirstTimeThrough
          then FirstTimeThrough := False
          else SwisCodeTable.Next;

        If SwisCodeTable.EOF
          then Done := True;

        with SwisCodeTable do
          If ((not Done) and
              (not FieldByName('AssessingVillage').AsBoolean) and
              (Copy(FieldByName('SwisCode').Text, 5, 2) <> '00'))
            then
              begin
                If (LinesLeft < 15)
                  then
                    begin
                      NewPage;
                      PageNum := PageNum + 1;
                      PrintReportHeader(Sender, ReportTime, PageNum,
                                        'PART 1 - ASSESSOR''S REPORT TOTALS',
                                        'FOR THE ' + CurrentAssessmentYear + ' ASSESSMENT ROLL',
                                        ConvertSwisCodeToMunicipalitySwisCode(SwisCodeTable.FieldByName('SwisCode').Text));

                      PrintSection6Subheader(Sender);

                    end;  {If (LineCnt < 12)}

                GetSection6Totals('S', FieldByName('SwisCode').Text,
                                  HstdPhysicalQtyIncrease, HstdEqualizationIncrease,
                                  HstdPhysicalQtyDecrease, HstdEqualizationDecrease,
                                  HstdPriorAssessed, HstdCurrentAssessed,
                                  NonhstdPhysicalQtyIncrease, NonhstdEqualizationIncrease,
                                  NonhstdPhysicalQtyDecrease, NonhstdEqualizationDecrease,
                                  NonhstdPriorAssessed, NonhstdCurrentAssessed,
                                  SortAssessedValChangesTable,
                                  SortTotalAssessedValTable,
                                  False, Detail225ChangeFile, Quit);

                PrintSection6Totals(Sender, 'NON-ASSESSING VILLAGE:',
                                    FieldByName('SwisCode').Text,
                                    FieldByName('MunicipalityName').Text,
                                    HstdPhysicalQtyIncrease, HstdEqualizationIncrease,
                                    HstdPhysicalQtyDecrease, HstdEqualizationDecrease,
                                    HstdPriorAssessed, HstdCurrentAssessed,
                                    NonhstdPhysicalQtyIncrease, NonhstdEqualizationIncrease,
                                    NonhstdPhysicalQtyDecrease, NonhstdEqualizationDecrease,
                                    NonhstdPriorAssessed, NonhstdCurrentAssessed);

                Println('');

              end;  {If ((not Done) and ...}

      until (Quit or Done);

        {Finally do schools.}

      FirstTimeThrough := True;
      Done := False;

      SchoolTable.First;

      repeat
        If FirstTimeThrough
          then FirstTimeThrough := False
          else SchoolTable.Next;

        If SchoolTable.EOF
          then Done := True;

        with SchoolTable do
          If not Done
            then
              begin
                If (LinesLeft < 15)
                  then
                    begin
                      NewPage;
                      PageNum := PageNum + 1;
                      PrintReportHeader(Sender, ReportTime, PageNum,
                                        'PART 1 - ASSESSOR''S REPORT TOTALS',
                                        'FOR THE ' + CurrentAssessmentYear + ' ASSESSMENT ROLL',
                                        ConvertSwisCodeToMunicipalitySwisCode(SwisCodeTable.FieldByName('SwisCode').Text));

                      PrintSection6Subheader(Sender);

                    end;  {If (LineCnt < 12)}

                GetSection6Totals('C', FieldByName('SchoolCode').Text,
                                  HstdPhysicalQtyIncrease, HstdEqualizationIncrease,
                                  HstdPhysicalQtyDecrease, HstdEqualizationDecrease,
                                  HstdPriorAssessed, HstdCurrentAssessed,
                                  NonhstdPhysicalQtyIncrease, NonhstdEqualizationIncrease,
                                  NonhstdPhysicalQtyDecrease, NonhstdEqualizationDecrease,
                                  NonhstdPriorAssessed, NonhstdCurrentAssessed,
                                  SortAssessedValChangesTable,
                                  SortTotalAssessedValTable,
                                  False, Detail225ChangeFile, Quit);

                PrintSection6Totals(Sender, 'SCHOOL:',
                                    FieldByName('SchoolCode').Text,
                                    FieldByName('SchoolName').Text,
                                    HstdPhysicalQtyIncrease, HstdEqualizationIncrease,
                                    HstdPhysicalQtyDecrease, HstdEqualizationDecrease,
                                    HstdPriorAssessed, HstdCurrentAssessed,
                                    NonhstdPhysicalQtyIncrease, NonhstdEqualizationIncrease,
                                    NonhstdPhysicalQtyDecrease, NonhstdEqualizationDecrease,
                                    NonhstdPriorAssessed, NonhstdCurrentAssessed);

                Println('');

              end;  {If ((not Done) and ...}

      until (Quit or Done);

    end;  {with Sender as TBaseReport do}

    {FXX12182001-1: Not closing the 225 details file.}

  CloseFile(Detail225ChangeFile);

end;  {PrintARTotalsSection6}

{===================================================================}
Procedure TAssessorsReportForm.PrintSection7Subheader(Sender : TObject;
                                                      SwisCode : String);

var
  Found : Boolean;
  SwisName : String;

begin
  with Sender as TBaseReport do
    begin
      Found := FindKeyOld(SwisCodeTable, ['SwisCode'], [SwisCode]);

      If Found
        then SwisName := SwisCodeTable.FieldByName('MunicipalityName').Text
        else SwisName := 'NOT IN LIBRARY';

      ClearTabs;
      SetTab(0.3, pjLeft, 0.7, 0, BoxLineNone, 0);  {Block}
      SetTab(1.1, pjRight, 1.6, 0, BoxLineNone, 0);  {Current}
      SetTab(2.8, pjRight, 1.5, 0, BoxLineNone, 0);  {Prior}
      SetTab(4.4, pjRight, 1.0, 0, BoxLineNone, 0);  {Net change}

      Println(#9 + 'SWIS ' + SwisCode + ': ' + SwisName);
      Println('');

      Println(#9 + 'BLOCK' +
              #9 + 'PRIOR ASSESSED' +
              #9 + 'CURRENT ASSESSED' +
              #9 + 'NET CHANGE');

      Println('');

    end;  {with Sender as TBaseReport do}

end;  {PrintSection7Subheader}

{==========================================================================}
Procedure PrintSection7Totals(Sender : TObject;
                              SwisCode : String;
                              PriorValue,
                              CurrentValue : Comp;
                              OverallTotalsRecord : Boolean);

begin
  with Sender as TBaseReport do
    begin
      Println('');

      If OverallTotalsRecord
        then Print(#9 + 'MUNIC TOT')
        else Print(#9 + 'TOTAL ' + SwisCode + ':');

        {FXX03241999-4: Had net change amount reversed.}

      Println(#9 + FormatFloat(CurrencyDisplayNoDollarSign,
                               PriorValue) +
              #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                               CurrentValue) +
              #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                               (CurrentValue - PriorValue)));

    end;  {with Sender as TBaseReport do}

end;  {PrintSection7Totals}

{==========================================================================}
Procedure TAssessorsReportForm.PrintARTotalsSection7(    Sender : TObject;
                                                         ReportTime : TDateTime;
                                                     var PageNum : Integer;
                                                     var Quit : Boolean);

{Print the new AR totals section 7, i.e. totals by block.}

var
  PriorValue, CurrentValue,
  SwisPriorVal, SwisCurrentVal,
  TotalPriorVal, TotalCurrentVal : Comp;
  Done, FirstTimeThrough : Boolean;
  PreviousSwisCode : String;

begin
  SwisPriorVal := 0;
  SwisCurrentVal := 0;
  TotalPriorVal := 0;
  TotalCurrentVal := 0;

    {FXX09111998-1: Switch keys so roll section is not in way.}

  SortTotalAssessedValTable.IndexName := 'BYRECTYPE_MUNICCODE_BLOCK';

  with Sender as TBaseReport do
    begin
      NewPage;
      PageNum := PageNum + 1;
      PrintReportHeader(Sender, ReportTime, PageNum,
                        'PART 1 - ASSESSOR''S REPORT TOTALS',
                        'FOR THE ' + CurrentAssessmentYear + ' ASSESSMENT ROLL',
                        ConvertSwisCodeToMunicipalitySwisCode(SwisCodeTable.FieldByName('SwisCode').Text));

      ClearTabs;
      SetTab(0.3, pjLeft, 10.0, 0, BoxLineNone, 0);  {Text}

      Println(#9 + 'VII  TOTAL PRIOR AND CURRENT ASSESSED VALUE BY BLOCK.');
      Println('');

      Done := False;
      FirstTimeThrough := True;

      SortTotalAssessedValTable.CancelRange;
      SetRangeOld(SortTotalAssessedValTable,
                  ['RecType', 'MunicipalityCode', 'Block'],
                  ['S', '      ', '    '],
                  ['S', '999999', 'ZZZZ']);
      SortTotalAssessedValTable.First;

      PreviousSwisCode := SortTotalAssessedValTable.FieldByName('MunicipalityCode').Text;
      PrintSection7Subheader(Sender, PreviousSwisCode);

        {Loop through all the Swis sort records printing out the information
         for each.}

      repeat
        If FirstTimeThrough
          then FirstTimeThrough := False
          else SortTotalAssessedValTable.Next;

        with SortTotalAssessedValTable do
          If (EOF or
              (Deblank(FieldByName('RecType').Text) = ''))
            then Done := True;

          {If this is a good record, print out the information.}

        If not Quit
          then
            begin
              ProgressDialog.Update(Self,
                                    'Swis: ' +
                                    SortTotalAssessedValTable.FieldByName('MunicipalityCode').Text);

                {If we changed Swis codes, then print a new
                 sub header.}

              If (Done or
                  (Take(6, PreviousSwisCode) <>
                   Take(6, SortTotalAssessedValTable.FieldByName('MunicipalityCode').Text)))
                then
                  begin
                      {Print out the header for the last Swis code.}

                    PrintSection7Totals(Sender, PreviousSwisCode, SwisPriorVal,
                                        SwisCurrentVal, False);

                    PreviousSwisCode := SortTotalAssessedValTable.FieldByName('MunicipalityCode').Text;

                      {Update the totals.}

                    TotalPriorVal := TotalPriorVal + SwisPriorVal;
                    TotalCurrentVal := TotalCurrentVal + SwisCurrentVal;

                      {Reset the totals for the next parcel.}

                    SwisPriorVal := 0;
                    SwisCurrentVal := 0;

                      {Go to a new page.}

                    If not Done
                      then
                        begin
                          NewPage;
                          PageNum := PageNum + 1;
                          PrintReportHeader(Sender, ReportTime, PageNum,
                                            'PART 1 - ASSESSOR''S REPORT TOTALS',
                                            'FOR THE ' + CurrentAssessmentYear + ' ASSESSMENT ROLL',
                                            ConvertSwisCodeToMunicipalitySwisCode(SwisCodeTable.FieldByName('SwisCode').Text));

                          PrintSection7Subheader(Sender, PreviousSwisCode);

                        end;  {If not Done}

                  end;  {If (Take(6, LastSwisCode) <> ...}

                {Print this entry.}

              If not Done
                then
                  with SortTotalAssessedValTable do
                    begin
                      If (LinesLeft <= 6)
                        then
                          begin
                            NewPage;
                            PageNum := PageNum + 1;
                            PrintReportHeader(Sender, ReportTime, PageNum,
                                              'PART 1 - ASSESSOR''S REPORT TOTALS',
                                              'FOR THE ' + CurrentAssessmentYear + ' ASSESSMENT ROLL',
                                              ConvertSwisCodeToMunicipalitySwisCode(SwisCodeTable.FieldByName('SwisCode').Text));

                            PrintSection7Subheader(Sender, PreviousSwisCode);

                          end;  {If (LinesLeft <= 6)}

                      PriorValue := FieldByName('HomestdPriorVal').AsFloat +
                                    FieldByName('NonhomestdPriorVal').AsFloat;
                      CurrentValue := FieldByName('HomestdCurrentVal').AsFloat +
                                      FieldByName('NonhomestdCurrentVal').AsFloat;

                        {FXX03241999-4: Had net change amount reversed.}

                      Println(#9 + DezeroOnLeft(FieldByName('Block').Text) +
                              #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                                               PriorValue) +
                              #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                                               CurrentValue) +
                              #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                                               (CurrentValue - PriorValue)));

                      SwisPriorVal := SwisPriorVal + PriorValue;
                      SwisCurrentVal := SwisCurrentVal + CurrentValue;

                    end;  {with SortTotalAssessedValTable do}

            end;  {If not Done}

      until (Quit or Done or ReportCancelled);

        {Print the over all totals.}

      If not (Quit or ReportCancelled)
        then PrintSection7Totals(Sender, '', TotalPriorVal,
                                 TotalCurrentVal, True);

    end;  {with Sender as TBaseReport do}

end;  {PrintARTotalsSection7}

{===================================================================}
Procedure PrintARPart2DetailHeader(Sender : TObject);

{Print the header for the detail page.}

begin
  with Sender as TBaseReport do
    begin

      ClearTabs;
      SetTab(0.2, pjLeft, 0.2, 0, BoxLineNone, 0);  {Deleted flag}
      SetTab(0.5, pjLeft, 2.0, 0, BoxLineNone, 0);  {Parcel ID}
      SetTab(2.6, pjLeft, 0.7, 0, BoxLineNone, 0);  {Name}
      SetTab(3.4, pjRight, 0.8, 0, BoxLineNone, 0);  {S\M Number}
      SetTab(4.3, pjRight, 0.6, 0, BoxLineNone, 0);  {School code}
      SetTab(5.0, pjRight, 0.4, 0, BoxLineNone, 0);  {Property class}
      SetTab(5.5, pjLeft, 0.3, 0, BoxLineNone, 0);  {Roll section}
      SetTab(5.9, pjLeft, 0.1, 0, BoxLineNone, 0);  {TY Homestead code}
      SetTab(6.1, pjLeft, 0.1, 0, BoxLineNone, 0);  {NY Homestead code}
      SetTab(6.3, pjCenter, 1.1, 0, BoxLineNone, 0);  {Assessed prior}
      SetTab(7.5, pjCenter, 1.1, 0, BoxLineNone, 0);  {Assessed current}
      SetTab(8.7, pjCenter, 1.0, 0, BoxLineNone, 0);  {Physical qty inc}
      SetTab(9.8, pjCenter, 1.0, 0, BoxLineNone, 0);  {Equalization inc}
      SetTab(10.9, pjCenter, 1.0, 0, BoxLineNone, 0);  {Physical qty dec}
      SetTab(12.0, pjCenter, 1.0, 0, BoxLineNone, 0);  {Equalization dec}
      SetTab(13.1, pjCenter, 0.3, 0, BoxLineNone, 0);  {Message}

      Println(#9 + #9 + #9 + #9 +
              #9 + 'SCHOOL' +
              #9 + 'PRP' +
              #9 + 'RS');
      Println(#9 + #9 + #9 +
              #9 + 'SP\MRG' +
              #9 + 'PYR' +
              #9 + 'PYR' +
              #9 + 'PY' +
              #9 + 'HST' + #9 +
              #9 + 'ASSESSED' +
              #9 + 'ASSESSED' +
              #9 + 'PHYS\QTY' +
              #9 + 'EQUAL' +
              #9 + 'PHYS\QTY' +
              #9 + 'EQUAL');
      Println(#9 + #9 + 'PARCEL' +
              #9 + 'NAME' +
              #9 + 'NUMBER' +
              #9 + 'CYR' +
              #9 + 'CYR' +
              #9 + 'CY' +
              #9 + 'P' +
              #9 + 'C' +
              #9 + 'PRIOR' +
              #9 + 'CURRENT' +
              #9 + 'INC' +
              #9 + 'INC' +
              #9 + 'DEC' +
              #9 + 'DEC' +
              #9 + 'MSG');
      Println('');

      ClearTabs;
      SetTab(0.2, pjLeft, 0.2, 0, BoxLineNone, 0);  {Deleted flag}
      SetTab(0.5, pjLeft, 2.0, 0, BoxLineNone, 0);  {Parcel ID}
      SetTab(2.6, pjLeft, 0.7, 0, BoxLineNone, 0);  {Name}
      SetTab(3.4, pjRight, 0.8, 0, BoxLineNone, 0);  {S\M Number}
      SetTab(4.3, pjRight, 0.6, 0, BoxLineNone, 0);  {School code}
      SetTab(5.0, pjRight, 0.4, 0, BoxLineNone, 0);  {Property class}
      SetTab(5.5, pjLeft, 0.3, 0, BoxLineNone, 0);  {Roll section}
      SetTab(5.9, pjLeft, 0.1, 0, BoxLineNone, 0);  {TY Homestead code}
      SetTab(6.1, pjLeft, 0.1, 0, BoxLineNone, 0);  {NY Homestead code}
      SetTab(6.3, pjRight, 1.1, 0, BoxLineNone, 0);  {Assessed prior}
      SetTab(7.5, pjRight, 1.1, 0, BoxLineNone, 0);  {Assessed current}
      SetTab(8.7, pjRight, 1.0, 0, BoxLineNone, 0);  {Physical qty inc}
      SetTab(9.8, pjRight, 1.0, 0, BoxLineNone, 0);  {Equalization inc}
      SetTab(10.9, pjRight, 1.0, 0, BoxLineNone, 0);  {Physical qty dec}
      SetTab(12.0, pjRight, 1.0, 0, BoxLineNone, 0);  {Equalization dec}
      SetTab(13.1, pjCenter, 0.3, 0, BoxLineNone, 0);  {Message}

    end;  {with Sender as TBaseReport do}

end;  {PrintARPart2DetailHeader}

{===================================================================}
Procedure TAssessorsReportForm.PrintSwisTotals(    Sender : TObject;
                                                   SwisCode : String;
                                                   PriorAssessedVal,
                                                   CurrAssessedVal,
                                                   EqualizationIncrease,
                                                   EqualizationDecrease,
                                                   PhysicalQtyIncrease,
                                                   PhysicalQtyDecrease : Comp;
                                                   OverallTotal : Boolean;
                                                   ReportTime : TDateTime;
                                                   PartName,
                                                   Subheader : String;
                                               var PageNum : Integer);

{Print the detail assessment changes for one swis.}

begin
  with Sender as TBaseReport do
    begin
        {Do we need to go to a new page first?}

      If (LinesLeft < 16)
        then
          begin
            NewPage;
            PageNum := PageNum + 1;
            PrintReportHeader(Sender, ReportTime, PageNum,
                              PartName, Subheader, SwisCode);
            PrintARPart2DetailHeader(Sender);

          end;  {If (LinesLeft < 10)}

      ClearTabs;
      SetTab(4.0, pjLeft, 2.0, 0, BoxLineNone, 0);  {Desc}

      Println('');
      Println(#9 + 'TOTAL ASSESSED VALUE');
      Println(#9 + 'FOR CHANGED PARCELS');

      If OverallTotal
        then
          begin
            Println(#9 + 'WITHIN MUNICIPALITY');
            Println('');
            Println(#9 + '** TOTALS REPORTED ON PART 1 **');
            Println('');
          end
        else Println(#9 + 'FOR SWIS ' + SwisCode);

      ClearTabs;
      SetTab(4.0, pjRight, 2.0, 0, BoxLineNone, 0);  {Desc}
      SetTab(6.1, pjRight, 1.2, 0, BoxLineNone, 0);  {AV}
      SetTab(7.4, pjRight, 1.2, 0, BoxLineNone, 0);  {Inc}
      SetTab(8.7, pjRight, 1.2, 0, BoxLineNone, 0);  {Dec}

      Println(#9 + 'ASSESSED PRIOR' +
              #9 + FormatFloat(CurrencyDisplayNoDollarSign, PriorAssessedVal));
      Println(#9 + 'ASSESSED CURRENT' +
              #9 + FormatFloat(CurrencyDisplayNoDollarSign, CurrAssessedVal));

      Println('');
      Println(#9 + 'PHYSICAL/QUANTITY INCREASE' + #9 +
              #9 + FormatFloat(CurrencyDisplayNoDollarSign, PhysicalQtyIncrease));
      Println(#9 + 'INCREASE FOR EQUALIZATION' + #9 +
              #9 + FormatFloat(CurrencyDisplayNoDollarSign, EqualizationIncrease));
      Println(#9 + 'PHYSICAL/QUANTITY DECREASE' + #9 + #9 +
              #9 + FormatFloat(CurrencyDisplayNoDollarSign, PhysicalQtyDecrease));
      Println(#9 + 'DECREASE FOR EQUALIZATION' + #9 + #9 +
              #9 + FormatFloat(CurrencyDisplayNoDollarSign, EqualizationDecrease));

    end;  {with Sender as TBaseReport do}

end;  {PrintSwisTotals}

{===================================================================}
Procedure PrintARPart2DetailFooter(Sender : TObject);

begin
  with Sender as TBaseReport do
    begin
      ClearTabs;
      SetTab(0.3, pjLeft, 1.0, 0, BoxLineNone, 0);  {Desc}
      SetTab(1.4, pjLeft, 3.0, 0, BoxLineNone, 0);  {AV}

      SetFont('Times New Roman', 8);
      Println('');
      Println(#9 + 'LEFT SIDE' + #9 + '(*)  DELETED PARCEL');
      Println(#9 + 'RIGHT SIDE' + #9 + '(B) PARCEL OUT OF BALANCE');
      Println(#9 + #9 + '(C) COMPUTED CHANGE');

    end;  {with Sender as TBaseReport do}

end;  {PrintARPart2DetailFooter}

{===================================================================}
Procedure TAssessorsReportForm.PrintARPart2DetailChanges(    Sender : TObject;
                                                             Part1TotalEqualizationIncrease,
                                                             Part1TotalPhysicalQtyIncrease,
                                                             Part1TotalEqualizationDecrease,
                                                             Part1TotalPhysicalQtyDecrease : Comp;
                                                             ReportTime : TDateTime;
                                                         var PageNum : Integer;
                                                         var Quit : Boolean);

{Print part 2 - the AR detail changes.}

var
   {Temporary values}

  CurrAssessedVal, PriorAssessedVal,
  EqualizationIncrease,
  EqualizationDecrease,
  PhysicalQtyIncrease,
  PhysicalQtyDecrease,

    {Totals}

  SwisCurrAssessedVal, SwisPriorAssessedVal,
  SwisEqualizationIncrease,
  SwisEqualizationDecrease,
  SwisPhysicalQtyIncrease,
  SwisPhysicalQtyDecrease : Comp;
  TotalCurrAssessedVal, TotalPriorAssessedVal,
  TotalEqualizationIncrease,
  TotalEqualizationDecrease,
  TotalPhysicalQtyIncrease,
  TotalPhysicalQtyDecrease : Comp;

  TempStr1, TempStr2 : String;
  PreviousSwisCode : String;
  Done, FirstTimeThrough,
  SchoolCodesAreDifferent,
  PropertyClassesAreDifferent,
  RollSectionsAreDifferent,
  HomesteadCodesAreDifferent : Boolean;
  NumSwisCodesPrinted : Integer;

begin
  NumSwisCodesPrinted := 0;
  SwisPriorAssessedVal := 0;
  SwisCurrAssessedVal := 0;
  SwisEqualizationIncrease := 0;
  SwisEqualizationDecrease := 0;
  SwisPhysicalQtyIncrease := 0;
  SwisPhysicalQtyDecrease := 0;

  TotalCurrAssessedVal := 0;
  TotalPriorAssessedVal := 0;
  TotalEqualizationIncrease := 0;
  TotalEqualizationDecrease := 0;
  TotalPhysicalQtyIncrease := 0;
  TotalPhysicalQtyDecrease := 0;

  with Sender as TBaseReport do
    begin
      SortAssessedValChangesTable.First;
      PreviousSwisCode := SortAssessedValChangesTable.FieldByName('SwisCode').Text;

      NewPage;
      PageNum := PageNum + 1;
      PrintReportHeader(Sender, ReportTime, PageNum,
                        'PART 2',
                        'ASSESSOR''S REPORT - DETAIL CHANGES',
                        PreviousSwisCode);
      PrintARPart2DetailHeader(Sender);

      Done := False;
      FirstTimeThrough := True;

        {Loop through all the Swis sort records printing out the information
         for each.}

      repeat
        If FirstTimeThrough
          then FirstTimeThrough := False
          else SortAssessedValChangesTable.Next;

        If SortAssessedValChangesTable.EOF
          then Done := True;

          {If we switched swis codes or the report is
           done, then print out the totals.}

        If (Done or
            (Take(6, SortAssessedValChangesTable.FieldByName('SwisCode').Text) <>
             Take(6, PreviousSwisCode)))
          then
            begin
              If ((not Done) or
                  (Done and
                   (NumSwisCodesPrinted > 0)))
                then PrintSwisTotals(Sender, PreviousSwisCode,
                                     SwisPriorAssessedVal,
                                     SwisCurrAssessedVal,
                                     SwisEqualizationIncrease,
                                     SwisEqualizationDecrease,
                                     SwisPhysicalQtyIncrease,
                                     SwisPhysicalQtyDecrease,
                                     False, ReportTime,
                                     'PART 2',
                                     'ASSESSOR''S REPORT - DETAIL CHANGES',
                                     PageNum);

              NumSwisCodesPrinted := NumSwisCodesPrinted + 1;

              TotalCurrAssessedVal := TotalCurrAssessedVal + SwisCurrAssessedVal;
              TotalPriorAssessedVal := TotalPriorAssessedVal + SwisPriorAssessedVal;
              TotalEqualizationIncrease := TotalEqualizationIncrease + SwisEqualizationIncrease;
              TotalEqualizationDecrease := TotalEqualizationDecrease + SwisEqualizationDecrease;
              TotalPhysicalQtyIncrease := TotalPhysicalQtyIncrease + SwisPhysicalQtyIncrease;
              TotalPhysicalQtyDecrease := TotalPhysicalQtyDecrease + SwisPhysicalQtyDecrease;

              SwisCurrAssessedVal := 0;
              SwisPriorAssessedVal := 0;
              SwisEqualizationIncrease := 0;
              SwisEqualizationDecrease := 0;
              SwisPhysicalQtyIncrease := 0;
              SwisPhysicalQtyDecrease := 0;

            end;  {If (Done or ...}

          {If we switched swis codes or there is not enough room left on
           this page, go to a new page.}
          {FXX09081998-4: Print less lines per page so bottom does not get chopped off.}

        If ((Take(6, SortAssessedValChangesTable.FieldByName('SwisCode').Text) <>
             Take(6, PreviousSwisCode)) or
            (LinesLeft < 8))
          then
            begin
              NewPage;
              PageNum := PageNum + 1;
              PreviousSwisCode := SortAssessedValChangesTable.FieldByName('SwisCode').Text;
              PrintReportHeader(Sender, ReportTime, PageNum,
                                'PART 2',
                                'ASSESSOR''S REPORT - DETAIL CHANGES',
                                PreviousSwisCode);
              PrintARPart2DetailHeader(Sender);

            end;  {If  ((Take(6, SortAssessedValChangesTable ...}

          {If this is a good record, print out the information.}

        If not Quit
          then
            with SortAssessedValChangesTable do
              begin
                If not Done
                  then
                    begin
                      SchoolCodesAreDifferent := False;
                      PropertyClassesAreDifferent := False;
                      RollSectionsAreDifferent := False;
                      HomesteadCodesAreDifferent := False;

                      CurrAssessedVal := TCurrencyField(FieldByName('CurrAssessedVal')).Value;
                      PriorAssessedVal := TCurrencyField(FieldByName('PriorAssessedVal')).Value;

                      EqualizationIncrease := FieldByName('HstdEqualInc').AsFloat +
                                              FieldByName('NonhstdEqualInc').AsFloat;
                      EqualizationDecrease := FieldByName('HstdEqualDec').AsFloat +
                                              FieldByName('NonhstdEqualDec').AsFloat;
                      PhysicalQtyIncrease := FieldByName('HstdPhysQtyInc').AsFloat +
                                             FieldByName('NonhstdPhysQtyInc').AsFloat;
                      PhysicalQtyDecrease := FieldByName('HstdPhysQtyDec').AsFloat +
                                             FieldByName('NonhstdPhysQtyDec').AsFloat;

                        {FXX04032001-1: Don't show parcels 0 before and after.}

                      If ((Roundoff(CurrAssessedVal, 0) > 0) or
                          (Roundoff(PriorAssessedVal, 0) > 0) or
                          (Roundoff(EqualizationIncrease, 0) > 0) or
                          (Roundoff(EqualizationDecrease, 0) > 0) or
                          (Roundoff(PhysicalQtyIncrease, 0) > 0) or
                          (Roundoff(PhysicalQtyDecrease, 0) > 0))
                        then
                          begin
                              {Print this record.}
                              {FXX04261999-3: Need seperate flag for inactive since
                                             it can be inactive and computed.}

                            If FieldByName('Inactive').AsBoolean
                              then Print(#9 + '*')
                              else Print(#9);

                            Print(#9 + ConvertSwisSBLToDashDotNoSwis(FieldByName('SwisCode').Text +
                                                                     FieldByName('SBLKey').Text) +
                                  #9 + Take(7, FieldByName('Name').Text) +
                                  #9 + DezeroOnLeft(FieldByName('SplitMergeNo').Text));

                            If (Take(6, FieldByName('CurrSchoolCode').Text) <>
                                Take(6, FieldByName('PriorSchoolCode').Text))
                              then SchoolCodesAreDifferent := True;

                            If (Take(6, FieldByName('CurrHomesteadCode').Text) <>
                                Take(6, FieldByName('PriorHomesteadCode').Text))
                              then HomesteadCodesAreDifferent := True;

                            If (Take(6, FieldByName('CurrPropertyClass').Text) <>
                                Take(6, FieldByName('PriorPropertyClass').Text))
                              then PropertyClassesAreDifferent := True;

                            If (Take(6, FieldByName('CurrRollSect_Subsect').Text) <>
                                Take(6, FieldByName('PriorRollSect_Subsec').Text))
                              then RollSectionsAreDifferent := True;

                            Print(#9 + FieldByName('PriorSchoolCode').Text +
                                  #9 + FieldByName('PriorPropertyClass').Text +
                                       FieldByName('PriorOwnershipCode').Text +
                                  #9 + FieldByName('PriorRollSect_Subsec').Text +
                                  #9 + FieldByName('PriorHomesteadCode').Text +
                                  #9 + FieldByName('CurrHomesteadCode').Text);

                              {If the roll section was 8, display a message saying
                               so. Otherwise, display the assessed val.}
                              {FXX091998-7: Roll section 7 is the same as roll section 8.}
                              {FXX04261999-1: Print rs 5 as R\S 5 EX.}

                            case Take(1, FieldByName('PriorRollSect_Subsec').Text)[1] of
                              '8' : TempStr1 := 'RS 8 EXMPT';
                              '7' : TempStr1 := 'RS 7 EXMPT';
                              '5' : TempStr1 := 'RS 5 EXMPT';
                              else TempStr1 := FormatFloat(CurrencyDisplayNoDollarSign,
                                                           PriorAssessedVal);
                            end;

                              {Print the Prior assessed val and the physical qty
                               change.}
                              {If the roll section was 8, display a message saying
                               so. Otherwise, display the assessed val.}

                            case Take(1, FieldByName('CurrRollSect_Subsect').Text)[1] of
                              '8' : TempStr2 := 'RS 8 EXMPT';
                              '7' : TempStr2 := 'RS 7 EXMPT';
                              '5' : TempStr2 := 'RS 5 EXMPT';
                              else TempStr2 := FormatFloat(CurrencyDisplayNoDollarSign,
                                                           CurrAssessedVal);
                            end;

                            Println(#9 + TempStr1 +
                                    #9 + TempStr2 +
                                    #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                                                       PhysicalQtyIncrease) +
                                    #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                                                     EqualizationIncrease) +
                                    #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                                                     PhysicalQtyDecrease) +
                                    #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                                                     EqualizationDecrease) +
                                    #9 + FieldByName('MismatchMessage').Text);

                              {CHG06192001-1: Create a parcel list of out of
                                              balance parcels.}

                            If (CreateParcelList and
                                (FieldByName('MismatchMessage').Text = 'B'))
                              then ParcelListDialog.AddOneParcel(FieldByName('SwisCode').Text +
                                                                 FieldByName('SBLKey').Text);

                              {Only print a 2nd line if there is a different
                               school code, property class, or roll section.}

                            If (SchoolCodesAreDifferent or
                                PropertyClassesAreDifferent or
                                RollSectionsAreDifferent)
                              then Println(#9 + #9 + #9 + #9 +
                                           #9 + FieldByName('CurrSchoolCode').Text +
                                           #9 + FieldByName('CurrPropertyClass').Text +
                                                FieldByName('CurrOwnershipCode').Text +
                                           #9 + FieldByName('CurrRollSect_Subsect').Text);

                              {FXX11041999-1: Create a seperate table of the exact av + and - for the 210.}

                            try
                              SortAVChangesTable.Insert;
                              SortAVChangesTable.FieldByName('SwisSBLKey').Text :=
                                                                SortAssessedValChangesTable.FieldByName('SwisCode').Text +
                                                                SortAssessedValChangesTable.FieldByName('SBLKey').Text;
                              SortAVChangesTable.FieldByName('HstdEqualInc').AsFloat :=
                                    SortAssessedValChangesTable.FieldByName('HstdEqualInc').AsFloat;
                              SortAVChangesTable.FieldByName('HstdEqualDec').AsFloat :=
                                    SortAssessedValChangesTable.FieldByName('HstdEqualDec').AsFloat;
                              SortAVChangesTable.FieldByName('HstdPhysQtyInc').AsFloat :=
                                    SortAssessedValChangesTable.FieldByName('HstdPhysQtyInc').AsFloat;
                              SortAVChangesTable.FieldByName('HstdPhysQtyDec').AsFloat :=
                                    SortAssessedValChangesTable.FieldByName('HstdPhysQtyDec').AsFloat;
                              SortAVChangesTable.FieldByName('NonhstdEqualInc').AsFloat :=
                                    SortAssessedValChangesTable.FieldByName('NonhstdEqualInc').AsFloat;
                              SortAVChangesTable.FieldByName('NonhstdEqualDec').AsFloat :=
                                    SortAssessedValChangesTable.FieldByName('NonhstdEqualDec').AsFloat;
                              SortAVChangesTable.FieldByName('NonhstdPhysQtyInc').AsFloat :=
                                    SortAssessedValChangesTable.FieldByName('NonhstdPhysQtyInc').AsFloat;
                              SortAVChangesTable.FieldByName('NonhstdPhysQtyDec').AsFloat :=
                                    SortAssessedValChangesTable.FieldByName('NonhstdPhysQtyDec').AsFloat;
                              SortAVChangesTable.Post;
                            except
                              SystemSupport(050, SortAVChangesTable, 'Error posting to AV changes for 210 file.',
                                            'RPASRUTL', GlblErrorDlgBox);
                            end;

                              {Update the totals, but don't include roll section
                               8 parcels. Also, only update the totals for parcels
                               that changed assessment.}
                              {FXX04261999-2: Must include all parcels in assessed and
                                              current totals - even those that
                                              just change school, rs, prop class or
                                              homestead.}

                            If ((Roundoff(EqualizationIncrease, 0) > 0) or
                                (Roundoff(EqualizationDecrease, 0) > 0) or
                                (Roundoff(PhysicalQtyIncrease, 0) > 0) or
                                (Roundoff(PhysicalQtyDecrease, 0) > 0) or
                                SchoolCodesAreDifferent or
                                PropertyClassesAreDifferent or
                                RollSectionsAreDifferent or
                                HomesteadCodesAreDifferent)
                              then
                                begin
                                  If not (Take(1, FieldByName('CurrRollSect_Subsect').Text)[1] in ['5', '7', '8'])
                                    then SwisCurrAssessedVal := SwisCurrAssessedVal + CurrAssessedVal;

                                  If not (Take(1, FieldByName('PriorRollSect_Subsec').Text)[1] in ['5', '7', '8'])
                                    then SwisPriorAssessedVal := SwisPriorAssessedVal + PriorAssessedVal;

                                  SwisEqualizationIncrease := SwisEqualizationIncrease + EqualizationIncrease;
                                  SwisEqualizationDecrease := SwisEqualizationDecrease + EqualizationDecrease;
                                  SwisPhysicalQtyIncrease := SwisPhysicalQtyIncrease + PhysicalQtyIncrease;
                                  SwisPhysicalQtyDecrease := SwisPhysicalQtyDecrease + PhysicalQtyDecrease;

                                end;  {If ((Roundoff(EqualizationIncrease, 0) > 0) or ...}

                          end;  {If ((Roundoff(CurrAssessedVal, 0) > 0) or ...}

                        {Do we need to go to a new page?}

                      If (LinesLeft < 10)
                        then
                          begin
                            PrintARPart2DetailFooter(Sender);
                            NewPage;
                            PageNum := PageNum + 1;
                            PrintReportHeader(Sender, ReportTime, PageNum,
                                              'PART 2',
                                              'ASSESSOR''S REPORT - DETAIL CHANGES',
                                              PreviousSwisCode);
                            PrintARPart2DetailHeader(Sender);

                          end;  {If (LinesLeft < 5)}

                    end;  {If not Done}

              end;  {with SortAssessedValChangesTable do}

          {FXX08131998-4: Not updating the previous swis code.}

        PreviousSwisCode := SortAssessedValChangesTable.FieldByName('SwisCode').Text;

      until (Quit or Done);

      PrintSwisTotals(Sender, '',
                      TotalPriorAssessedVal,
                      TotalCurrAssessedVal,
                      Part1TotalEqualizationIncrease,
                      Part1TotalEqualizationDecrease,
                      Part1TotalPhysicalQtyIncrease,
                      Part1TotalPhysicalQtyDecrease,
                      True, ReportTime,
                      'PART 2',
                      'ASSESSOR''S REPORT - DETAIL CHANGES',
                      PageNum);

      PrintARPart2DetailFooter(Sender);

    end;  {with Sender as TBaseReport do}

end;  {PrintARPart2DetailChanges}

{===================================================================}
Procedure PrintExemptionSummaryHeader(Sender : TObject);

{Print the header for the exemption summary page.}

begin
  with Sender as TBaseReport do
    begin
      ClearTabs;
      SetTab(0.2, pjLeft, 0.8, 0, BoxLineNone, 0);  {EX Code}
      SetTab(3.8, pjCenter, 5.1, 0, BoxLineNone, 0);  {Amounts}

      Println(#9 + 'EXEMPT' +
              #9 + '---------------  EXEMPTION AMOUNTS  -------------------');

      ClearTabs;
      SetTab(0.2, pjLeft, 0.8, 0, BoxLineNone, 0);  {EX Code}
      SetTab(1.1, pjLeft, 1.5, 0, BoxLineNone, 0);  {Description}
      SetTab(2.7, pjRight, 0.7, 0, BoxLineNone, 0);  {Parcel Count}
      SetTab(3.5, pjRight, 1.2, 0, BoxLineNone, 0);  {County amount}
      SetTab(4.8, pjRight, 1.2, 0, BoxLineNone, 0);  {Town Amount}
      SetTab(6.1, pjRight, 1.2, 0, BoxLineNone, 0);  {School amount}
      SetTab(7.4, pjRight, 1.2, 0, BoxLineNone, 0);  {Village amount}

      Print(#9 + 'CODE' +
            #9 + 'DESCRIPTION' +
            #9 + 'COUNT');

        {FXX03242005-1(2.8.3.14)[2087]: Only show applicable roll totals in this section.}

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
        then Println(#9 + 'VILLAGE')
        else Println('');

      Println('');

    end;  {with Sender as TBaseReport do}

end;  {PrintARPart2DetailHeader}

{===================================================================}
Procedure TAssessorsReportForm.PrintExemptionSummary(    Sender : TObject;
                                                         ReportTime : TDateTime;
                                                     var PageNum : Integer;
                                                     var Quit : Boolean);

{Print the exemption summary listing - on line per ex code.}

var
  CountyAmount, TownAmount,
  SchoolAmount, VillageAmount,
  TotalCountyAmount, TotalTownAmount,
  TotalSchoolAmount, TotalVillageAmount : Comp;
  TotalParcelCount : LongInt;
  Done, FirstTimeThrough : Boolean;

begin
  TotalCountyAmount := 0;
  TotalTownAmount := 0;
  TotalSchoolAmount := 0;
  TotalVillageAmount := 0;
  TotalParcelCount := 0;

  with Sender as TBaseReport do
    begin
      SortExemptionTable.First;
      NewPage;
      PageNum := PageNum + 1;

        {FXX09081998-6: Wrong swis code for exemption report}

      PrintReportHeader(Sender, ReportTime, PageNum,
                        'ASSESSOR''S ANNUAL REPORT',
                        'MUNICIPAL EXEMPTION CODE LISTING',
                        ConvertSwisCodeToMunicipalitySwisCode(SwisCodeTable.FieldByName('SwisCode').Text));
      PrintExemptionSummaryHeader(Sender);

      Done := False;
      FirstTimeThrough := True;

        {Loop through all the Swis sort records printing out the information
         for each.}

      repeat
        If FirstTimeThrough
          then FirstTimeThrough := False
          else SortExemptionTable.Next;

        If SortExemptionTable.EOF
          then Done := True;

          {FXX02242002-1: Changed LinesLeft to 8 so that it didn't cut off.}

        If not (Done or Quit)
          then
            begin
              If (LinesLeft < 8)
                then
                  begin
                    NewPage;
                    PageNum := PageNum + 1;
                    PrintReportHeader(Sender, ReportTime, PageNum,
                                      'ASSESSOR''S ANNUAL REPORT',
                                      'MUNICIPAL EXEMPTION CODE LISTING',
                                      ConvertSwisCodeToMunicipalitySwisCode(SwisCodeTable.FieldByName('SwisCode').Text));
                    PrintExemptionSummaryHeader(Sender);

                  end;  {If (LinesLeft < 5)}

              with SortExemptionTable do
                begin
                  Print(#9 + FieldByName('ExemptionCode').Text +
                        #9 + FieldByName('Description').Text +
                        #9 + FieldByName('ParcelCount').Text);

                  CountyAmount := FieldByName('CountyAmount').AsFloat;
                  TownAmount := FieldByName('TownAmount').AsFloat;
                  SchoolAmount := FieldByName('SchoolAmount').AsFloat;
                  VillageAmount := FieldByName('VillageAmount').AsFloat;

                    {FXX03242005-1(2.8.3.14)[2087]: Only show applicable roll totals in this section.}

                  If ((rtdCounty in GlblRollTotalsToShow) and
                      (Roundoff(CountyAmount, 0) > 0))
                    then Print(#9 + FormatFloat(CurrencyDisplayNoDollarSign,
                                                CountyAmount))
                    else Print(#9);

                  If ((rtdMunicipal in GlblRollTotalsToShow) and
                      (Roundoff(TownAmount, 0) > 0))
                    then Print(#9 + FormatFloat(CurrencyDisplayNoDollarSign,
                                                TownAmount))
                    else Print(#9);

                  If ((rtdSchool in GlblRollTotalsToShow) and
                      (Roundoff(SchoolAmount, 0) > 0))
                    then Print(#9 + FormatFloat(CurrencyDisplayNoDollarSign,
                                                SchoolAmount))
                    else Print(#9);

                  If ((rtdVillageReceivingPartialRoll in GlblRollTotalsToShow) and
                      (Roundoff(VillageAmount, 0) > 0))
                    then Println(#9 + FormatFloat(CurrencyDisplayNoDollarSign,
                                                  VillageAmount))
                    else Println(#9);

                  TotalCountyAmount := TotalCountyAmount + CountyAmount;
                  TotalTownAmount := TotalTownAmount + TownAmount;
                  TotalSchoolAmount := TotalSchoolAmount + SchoolAmount;
                  TotalVillageAmount := TotalVillageAmount + VillageAmount;
                  TotalParcelCount := TotalParcelCount + FieldByName('ParcelCount').AsInteger;

                  Println('');

                end;  {with SortExemptionTable do}

            end;  {If not (Done or Quit)}

      until (Done or Quit);

        {Print the totals.}

      Print(#9 + #9 + 'GRAND TOTALS' +
            #9 + IntToStr(TotalParcelCount));

        {FXX04232009-17(2.20.1.1)[D1491]: Totals should honor roll totals to display.}

      If (rtdCounty in GlblRollTotalsToShow)
        then Print(#9 + FormatFloat(CurrencyDisplayNoDollarSign,
                                    TotalCountyAmount))
        else Print(#9);

      If (rtdMunicipal in GlblRollTotalsToShow)
        then Print(#9 + FormatFloat(CurrencyDisplayNoDollarSign,
                                    TotalTownAmount))
        else Print(#9);

      If (rtdSchool in GlblRollTotalsToShow)
        then Print(#9 + FormatFloat(CurrencyDisplayNoDollarSign,
                                    TotalSchoolAmount))
        else Print(#9);

      If (rtdVillageReceivingPartialRoll in GlblRollTotalsToShow)
        then Println(#9 + FormatFloat(CurrencyDisplayNoDollarSign,
                                      TotalVillageAmount))
        else Println(#9);

    end;  {with Sender as TBaseReport do}

end;  {PrintExemptionSummary}

{===================================================================}
Procedure  PrintTransmittalLetterSubheader(Sender : TObject);

begin
  with Sender as TBaseReport do
    begin
      ClearTabs;
      SetTab(5.0, pjCenter, 5.3, 0, BoxLineNone, 0);  {Taxable vals}
      Println(#9 + '-----------------  TAXABLE ASSESSED VALUES  -----------------');

      ClearTabs;
      SetTab(0.3, pjLeft, 1.0, 0, BoxLineNone, 0);  {Portion}
      SetTab(1.4, pjLeft, 0.6, 0, BoxLineNone, 0);  {Code}
      SetTab(2.1, pjLeft, 2.0, 0, BoxLineNone, 0);  {Description}
      SetTab(5.0, pjRight, 1.7, 0, BoxLineNone, 0);  {Hstd amt}
      SetTab(6.8, pjRight, 1.7, 0, BoxLineNone, 0);  {Nonhstd amt}
      SetTab(8.6, pjRight, 1.7, 0, BoxLineNone, 0);  {Total}

      Println(#9 + 'PORTION' +
              #9 + 'CODE' +
              #9 + 'DESCRIPTION' +
              #9 + 'HOMESTEAD' +
              #9 + 'NON-HOMESTEAD' +
              #9 + 'TOTAL');

      Println('');

    end;  {with Sender as TBaseReport do}

end;  {PrintTransmittalLetterSubheader}

{===================================================================}
Procedure TAssessorsReportForm.GetTransmittalLetterTotals(    _RecType : Char;  {(S)wis, S(c)hool}
                                                              _MunicipalityCode : String;
                                                          var HstdTaxableVal,
                                                              NonhstdTaxableVal : Comp;
                                                          var Quit : Boolean);

{Get the taxable values for this rec type and municipality code.}

var
  MunicCodeLength : Integer;
  Done, FirstTimeThrough : Boolean;

begin
  FirstTimeThrough := True;
  Done := False;
  MunicCodeLength := Length(Trim(_MunicipalityCode));

  HstdTaxableVal := 0;
  NonhstdTaxableVal := 0;

  SortTotalAssessedValTable.CancelRange;
  SortTotalAssessedValTable.First;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else SortTotalAssessedValTable.Next;

    If SortTotalAssessedValTable.EOF
      then Done := True;

    If not (Done or Quit)
      then
        with SortTotalAssessedValTable do
          begin
              {Only match on the number of chars in the passed in munic code
               since it may be only 4 for the town total.}

            If ((Take(MunicCodeLength, FieldByName('MunicipalityCode').Text) =
                 Take(MunicCodeLength, _MunicipalityCode)) and
                (FieldByName('RecType').Text[1] = _RecType))
               then
                 begin
                   HstdTaxableVal := HstdTaxableVal +
                                     FieldByName('HomestdCurrentVal').AsFloat -
                                     FieldByName('HstdExAmount').AsFloat;

                   NonhstdTaxableVal := NonhstdTaxableVal +
                                        FieldByName('NonhomestdCurrentVal').AsFloat -
                                        FieldByName('NonhstdExAmount').AsFloat;

                 end;  {If (Take(MunicCodeLength, FieldByName('MunicipalityCode').Text) = ...}

          end;  {with SortTotalAssessedValTable do}

  until (Done or Quit);

end;  {GetTransmittalLetterTotals}

{===================================================================}
Procedure PrintTransmittalLetterTotals(Sender : TObject;
                                       PortionType,
                                       MunicipalityCode,
                                       MunicipalityName : String;
                                       HstdTaxableVal,
                                       NonhstdTaxableVal : Comp);

{Print one entry for the transmittal letter totals.}

begin
  with Sender as TBaseReport do
    begin
      Println(#9 + PortionType);
      Println(#9 + #9 + MunicipalityCode +
              #9 + MunicipalityName +
              #9 + FormatFloat(CurrencyDisplayNoDollarSign, HstdTaxableVal) +
              #9 + FormatFloat(CurrencyDisplayNoDollarSign, NonhstdTaxableVal) +
              #9 + FormatFloat(CurrencyDisplayNoDollarSign, (HstdTaxableVal +
                                                             NonhstdTaxableVal)));

      Println('');

    end;  {with Sender as TBaseReport do}

end;  {PrintTransmittalLetterTotals}

{===================================================================}
Procedure TAssessorsReportForm.PrintTransmittalLetter(    Sender : TObject;
                                                          ReportTime : TDateTime;
                                                      var PageNum : Integer;
                                                      var Quit : Boolean);

{Print the transmittal letter - taxable values by portion.}

var
  Done, FirstTimeThrough : Boolean;
  HstdTaxableVal, NonhstdTaxableVal : Comp;

begin
  with Sender as TBaseReport do
    begin
      NewPage;
      PageNum := PageNum + 1;
      PrintReportHeader(Sender, ReportTime, PageNum,
                        'PART 3',
                        'TRANSMITTAL LETTER',
                        ConvertSwisCodeToMunicipalitySwisCode(SwisCodeTable.FieldByName('SwisCode').Text));

      ClearTabs;
      SetTab(0.6, pjLeft, 10.0, 0, BoxLineNone, 0);  {Text}

      Println('');
      Println(#9 + 'SUMMARY OF TAXABLE ASSESSED VALUES ON CURRENT ROLL BY PORTION FOR APPROVED ASSESSING UNITS');
      Println(#9 + 'WHICH HAVE ADOPTED THE HOMESTEAD BASE PROPORTION PROVISIONS OF SECTION 1903, RPTL.');

      Println('');

      PrintTransmittalLetterSubheader(Sender);

        {First do the over all municipality totals.}
        {FXX10211998-8: Do not hardcode CountyTownCode, i.e first 4 chars of swis.}


      GetTransmittalLetterTotals('S', CountyTownCode,
                                 HstdTaxableVal, NonhstdTaxableVal, Quit);

      PrintTransmittalLetterTotals(Sender,
                                   UpcaseStr(GetMunicipalityTypeName(GlblMunicipalityType)) + ':',
                                   CountyTownCode, GlblMunicipalityName,
                                   HstdTaxableVal, NonhstdTaxableVal);

      Println('');

        {Now do assessing villages.}

      FirstTimeThrough := True;
      Done := False;

      SwisCodeTable.First;

      repeat
        If FirstTimeThrough
          then FirstTimeThrough := False
          else SwisCodeTable.Next;

        If SwisCodeTable.EOF
          then Done := True;

        with SwisCodeTable do
          If ((not Done) and
              FieldByName('AssessingVillage').AsBoolean)
            then
              begin
                If (LinesLeft < 12)
                  then
                    begin
                      NewPage;
                      PageNum := PageNum + 1;
                      PrintReportHeader(Sender, ReportTime, PageNum,
                                        'PART 3',
                                        'TRANSMITTAL LETTER',
                                        ConvertSwisCodeToMunicipalitySwisCode(SwisCodeTable.FieldByName('SwisCode').Text));

                      PrintTransmittalLetterSubheader(Sender);

                    end;  {If (LineCnt < 12)}

                GetTransmittalLetterTotals('S', FieldByName('SwisCode').Text,
                                           HstdTaxableVal, NonhstdTaxableVal, Quit);

                PrintTransmittalLetterTotals(Sender, 'ASSESSING VILLAGE:',
                                             FieldByName('SwisCode').Text,
                                             FieldByName('MunicipalityName').Text,
                                             HstdTaxableVal, NonhstdTaxableVal);

                Println('');

              end;  {If ((not Done) and ...}

      until Done;

        {Next do non-assessing villages.}

      FirstTimeThrough := True;
      Done := False;

      SwisCodeTable.First;

      repeat
        If FirstTimeThrough
          then FirstTimeThrough := False
          else SwisCodeTable.Next;

        If SwisCodeTable.EOF
          then Done := True;

        with SwisCodeTable do
          If ((not Done) and
              (not FieldByName('AssessingVillage').AsBoolean) and
              (Copy(FieldByName('SwisCode').Text, 5, 2) <> '00'))
            then
              begin
                If (LinesLeft < 12)
                  then
                    begin
                      NewPage;
                      PageNum := PageNum + 1;
                      PrintReportHeader(Sender, ReportTime, PageNum,
                                        'PART 3',
                                        'TRANSMITTAL LETTER',
                                        ConvertSwisCodeToMunicipalitySwisCode(SwisCodeTable.FieldByName('SwisCode').Text));

                      PrintTransmittalLetterSubheader(Sender);

                    end;  {If (LineCnt < 12)}

                GetTransmittalLetterTotals('S', FieldByName('SwisCode').Text,
                                           HstdTaxableVal, NonhstdTaxableVal, Quit);

                PrintTransmittalLetterTotals(Sender, 'NON-ASSESSING VILLAGE:',
                                             FieldByName('SwisCode').Text,
                                             FieldByName('MunicipalityName').Text,
                                             HstdTaxableVal, NonhstdTaxableVal);
                Println('');

              end;  {If ((not Done) and ...}

      until (Quit or Done);

        {Finally do schools.}

      FirstTimeThrough := True;
      Done := False;

      SchoolTable.First;

      repeat
        If FirstTimeThrough
          then FirstTimeThrough := False
          else SchoolTable.Next;

        If SchoolTable.EOF
          then Done := True;

        with SchoolTable do
          If not Done
            then
              begin
                If (LinesLeft < 12)
                  then
                    begin
                      NewPage;
                      PageNum := PageNum + 1;
                      PrintReportHeader(Sender, ReportTime, PageNum,
                                        'PART 3',
                                        'TRANSMITTAL LETTER',
                                        ConvertSwisCodeToMunicipalitySwisCode(SwisCodeTable.FieldByName('SwisCode').Text));

                      PrintTransmittalLetterSubheader(Sender);

                    end;  {If (LineCnt < 12)}

                GetTransmittalLetterTotals('C', FieldByName('SchoolCode').Text,
                                           HstdTaxableVal, NonhstdTaxableVal, Quit);

                PrintTransmittalLetterTotals(Sender, 'SCHOOL:',
                                             FieldByName('SchoolCode').Text,
                                             FieldByName('SchoolName').Text,
                                             HstdTaxableVal, NonhstdTaxableVal);
                Println('');

              end;  {If ((not Done) and ...}

      until (Quit or Done);

    end;  {with Sender as TBaseReport do}

end;  {PrintTransmittalLetter}

{===================================================================}
Procedure TAssessorsReportForm.TextReportPrint(Sender: TObject);

{To print the report, we will print each of the segments seperately.
 We will not use the normal paging event driven methods.
 We will control all paging.}

var
  Done, FirstTimeThrough,
  Quit, MunicipalityHasVillages : Boolean;
  ReportTime : TDateTime;
  PageNum : Integer;
  AssessmentChangeFactor : Double;
  TotalEqualizationIncrease,
  TotalPhysicalQtyIncrease,
  TotalEqualizationDecrease,
  TotalPhysicalQtyDecrease,
  PriorAssessedValue : Comp;

begin
  Quit := False;
  Done := False;
  FirstTimeThrough := True;
  MunicipalityHasVillages := False;
  PageNum := 1;
  ReportTime := Now;

    {See if this municipality has any villages - anything other than swis 00.}

  SwisCodeTable.First;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else SwisCodeTable.Next;

    If SwisCodeTable.EOF
      then Done := True;

    If ((not Done) and
        (Copy(SwisCodeTable.FieldByName('SwisCode').Text, 5, 2) <> '00'))
      then MunicipalityHasVillages := True;

  until Done;

    {Start the printing.}

  PrintPart1Section1(Sender, ReportTime, TotalEqualizationIncrease,
                     TotalPhysicalQtyIncrease, TotalEqualizationDecrease,
                     TotalPhysicalQtyDecrease, PriorAssessedValue,
                     PageNum, Quit);

  try
    AssessmentChangeFactor := 1 + (TotalEqualizationIncrease - TotalEqualizationDecrease) /
                                  (PriorAssessedValue - TotalPhysicalQtyDecrease);
  except
    AssessmentChangeFactor := 1;
  end;

  If not (Quit or ReportCancelled)
    then PrintPart1Section2(Sender, ReportTime, AssessmentChangeFactor,
                            MunicipalityHasVillages, PageNum, Quit);

  If not (Quit or ReportCancelled)
    then PrintPart1Section3(Sender, ReportTime, PageNum, Quit);

  If not (Quit or ReportCancelled)
    then PrintPart1Section4(Sender, ReportTime, PageNum, Quit);

  If not (Quit or ReportCancelled)
    then PrintPart1Section5(Sender, Quit);

  If not (Quit or ReportCancelled)
    then PrintARTotalsSection1(Sender, ReportTime, PageNum, Quit);

  If not (Quit or ReportCancelled)
    then PrintARTotalsSections2And3(Sender, Quit);

  If not (Quit or ReportCancelled)
    then PrintARTotalsSection4(Sender, ReportTime, PageNum, Quit);

    {Only print section 5 if there are villages.}

  If ((not (Quit or ReportCancelled)) and
      MunicipalityHasVillages)
    then PrintARTotalsSection5(Sender, ReportTime, PageNum, Quit);

    {Only print section 6 if the municipality uses two tax rates.}

  If ((not (Quit or ReportCancelled)) and
      GlblMunicipalityUsesTwoTaxRates)
    then PrintARTotalsSection6(Sender, ReportTime, PageNum, Quit);

  If ((not (Quit or ReportCancelled)) and
      PrintTotalsByBlockCheckBox.Checked)
    then PrintARTotalsSection7(Sender, ReportTime, PageNum, Quit);

  If not (Quit or ReportCancelled)
    then PrintARPart2DetailChanges(Sender, TotalEqualizationIncrease,
                                   TotalPhysicalQtyIncrease,
                                   TotalEqualizationDecrease,
                                   TotalPhysicalQtyDecrease,
                                   ReportTime, PageNum, Quit);

  If ((not (Quit or ReportCancelled)) and
      PrintMunicipalCodeListingCheckBox.Checked)
    then PrintExemptionSummary(Sender, ReportTime, PageNum, Quit);

  If ((not (Quit or ReportCancelled)) and
      GlblMunicipalityIsClassified and
      PrintTransmittalLetterCheckBox.Checked)
    then PrintTransmittalLetter(Sender, ReportTime, PageNum, Quit);

  ProgressDialog.StartPrinting(PrintDialog.PrintToFile);
  Application.ProcessMessages;

end;  {ReportPrint}


{===================================================================}
Procedure TAssessorsReportForm.ReportPrint(Sender: TObject);

var
  ReportTextFile : TextFile;

begin
  AssignFile(ReportTextFile, TextFiler.FileName);
  Reset(ReportTextFile);

        {CHG12211998-1: Add ability to select print range.}

  PrintTextReport(Sender, ReportTextFile, PrintDialog.FromPage,
                  PrintDialog.ToPage);

  CloseFile(ReportTextFile);

end;  {ReportPrint}

{===================================================================}
Procedure TAssessorsReportForm.FormClose(    Sender: TObject;
                                  var Action: TCloseAction);

begin
  CloseTablesForForm(Self);

    {Free up the child window and set the ClosingAForm Boolean to
     true so that we know to delete the tab.}

  Action := caFree;
  GlblClosingAForm := True;
  GlblClosingFormCaption := Caption;

end;  {FormClose}

end.