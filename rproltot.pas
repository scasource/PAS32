unit Rproltot;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, DBCtrls, DBTables, DB, Buttons, Grids,
  Wwdbigrd, Wwdbgrid, ExtCtrls, Wwtable, Wwdatsrc, Menus, RPFiler,
  RPCanvas, RPrinter, Progress, RPDefine, RPBase, RPTXFilr, Types;

type
  TRollTotalReport = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    ScrollBox1: TScrollBox;
    CloseButton: TBitBtn;
    TitleLabel: TLabel;
    TotalsBySchoolTable: TTable;
    TotalsByExemptionTable: TTable;
    TotalsBySpecialDistrictTable: TTable;
    TotalsByRollSectionTable: TTable;
    AssessmentYearRadioGroup: TRadioGroup;
    Label11: TLabel;
    PrintButton: TBitBtn;
    TextFiler: TTextFiler;
    PrintDialog: TPrintDialog;
    ReportPrinter: TReportPrinter;
    ReportFiler: TReportFiler;
    Label9: TLabel;
    SwisCodeListBox: TListBox;
    TotalsRadioGroup: TRadioGroup;
    SectionsToShowGroupBox: TGroupBox;
    TotalsBySchoolCheckBox: TCheckBox;
    TotalsByEXCodeCheckBox: TCheckBox;
    TotalsBySDCodeCheckBox: TCheckBox;
    TotalsByRollSectionCheckBox: TCheckBox;
    SwisCodeTable: TTable;
    PrintingPanel: TPanel;
    LoadButton: TBitBtn;
    SaveButton: TBitBtn;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    TotalsByVillageRelevyCheckBox: TCheckBox;
    TotalsByRS9CheckBox: TCheckBox;
    HistoryEdit: TEdit;
    TotalsByVillageRelevyTable: TTable;
    AllButton: TBitBtn;
    NoneButton: TBitBtn;
    TotalsByProrataTable: TTable;
    CalculateButton: TBitBtn;
    OptionsGroupBox: TGroupBox;
    ExtractToExcelCheckBox: TCheckBox;
    ShowClassCheckBox: TCheckBox;
    PrintEqualizationRateCheckBox: TCheckBox;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure PrintButtonClick(Sender: TObject);
    procedure PrintReport(Sender: TObject);
    procedure TextFilerPrint(Sender: TObject);
    procedure LoadButtonClick(Sender: TObject);
    procedure SaveButtonClick(Sender: TObject);
    procedure AssessmentYearRadioGroupClick(Sender: TObject);
    procedure AllButtonClick(Sender: TObject);
    procedure NoneButtonClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure CalculateButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    UnitName : String;
    ReportCancelled, PrintVillageRelevyTotals,
    TotalsOnly, PrintClassAmounts, PrintProrataTotals,
    PrintSchoolTotals, PrintExemptionTotals,
    PrintSpecialDistrictTotals, PrintRollSectionTotals : Boolean;
    SelectedSwisCodes : TStringList;
    ProcessingType : Integer;
    TaxRollYear : String;
    SDExtCategoryList,
    RollSectionDescList,
    EXCodeDescList,
    SDCodeDescList,
    SDExtCodeDescList,
    SwisCodeDescList,
    SchoolCodeDescList : TList;

    Procedure InitializeForm;  {Open the tables and setup.}

    Procedure PrintTotals(Sender : TObject;
                          SwisCode : String;
                          SectionType : Char);

  end;

implementation

uses GlblVars, WinUtils, Utilitys, GlblCnst,
     PASUtils, PASTypes, UTILRTOT, UTRTOTPT,
     UTILBILL, Preview, RptDialg, Prog, RTCalcul;

var
  NumLinesPerPage,
  NumColsPerPage : Integer;
  CL1, CL2, CL3, CL4, CL5, CL6, CL7,
  EX5, EX6, EX7,
  TL1, TL2, TL3, TL4, TL5, TL6,
  TL7, TL8, TL9, TL10, TL11 : Double;
  FirstPageOfReport : Boolean;
  PageNo, LineNo : Integer;
  ExtractToExcel : Boolean;
  ExtractFile : TextFile;
  PrintEqualizationRate,
  _AllSwisCodesInSameMunicipality : Boolean;
  EqualizationRate,
  ResidentialAssessmentRatio, UniformPercentOfValue : Double;

const
       {constants for printing lines on roll}

  MRG = 0;

     {Column widths}
     {FXX06251998-15: Add 1 space to column 1, remove one from column 3 for ag dist law warning.}

  CL1W = 2.6; {SBL}
  CL2W = 2.6; {column 2..prprloc,schldis,prclsize}
  CL3W = 1.6; {column 3..assessment, land , total}
  CL4W = 2.3; {column 4, ex codes,taxdescri}
  CL5W = 1.7; {column 5, taxable val}
  CL6W = 0.4; {column 6, SD Ext Codes}
  CL7W = 1.3; {column 7, tax amts}

  EX4W = 2.0; {column 4, ex codes, desc}
  EX5W = 1.0; {column 5, county ex amt}
  EX6W = 1.0; {column 6, town ex amt}
  EX7W = 1.0; {column 7, school amt}

   {constants for printing  TOTALS lines on roll}

  TL1W = 0.7; {column 1..name}
  TL2W = 1.8; {column 2..desc}
  TL3W = 0.8; {column 3 parcel count}
  TL4W = 1.3; {column 4, }
  TL5W = 1.3; {column 5, }
  TL6W = 1.3; {column 6,}
  TL7W = 1.3; {column 7,}
  TL8W = 1.3; {column 8,}
  TL9W = 1.4; {totals column}
  TL10W = 1.4; {totals column}
  TL11W = 1.3;

  ayThisYear = 0;
  ayNextYear = 1;
  ayHistory = 2;

{$R *.DFM}

{========================================================}
Procedure TRollTotalReport.FormActivate(Sender: TObject);

begin
  SetFormStateMaximized(Self);
end;

{========================================================}
Procedure TRollTotalReport.InitializeForm;

var
  Quit, Done, FirstTimeThrough : Boolean;
  I : Integer;

begin
  UnitName := 'RPROLTOT';  {mmm}

    {Default assessment year.}

  If (GlblProcessingType = NextYear)
    then AssessmentYearRadioGroup.ItemIndex := 1
    else AssessmentYearRadioGroup.ItemIndex := 0;

  OpenTableForProcessingType(SwisCodeTable, SwisCodeTableName,
                             GlblProcessingType, Quit);

  PrintEqualizationRateCheckBox.Visible := AllSwisCodesInSameMunicipality(SwisCodeTable);

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
      then
        with SwisCodeTable do
          SwisCodeListBox.Items.Add(FieldByName('SwisCode').Text + '  (' +
                                    Trim(FieldByName('MunicipalityName').Text) + ')');

  until Done;

    {Default to all swis codes.}

  For I := 0 to (SwisCodeListBox.Items.Count - 1) do
    SwisCodeListBox.Selected[I] := True;

  SelectedSwisCodes := TStringList.Create;

  case GlblProcessingType of
    ThisYear : AssessmentYearRadioGroup.ItemIndex := ayThisYear;
    NextYear : AssessmentYearRadioGroup.ItemIndex := ayNextYear;
    History : AssessmentYearRadioGroup.ItemIndex := ayHistory;

  end;  {case GlblProcessingType of}

    {Compute the column positions.}

  CL1 := Mrg;
  CL2 := CL1 + CL1W + 0.1;
  CL3 := CL2 + CL2W + 0.1;
  CL4 := CL3 + CL3W + 0.1;
  CL5 := CL4 + CL4W + 0.1;
  CL6 := CL5 + CL5W + 0.1;
  CL7 := CL6 + CL6W + 0.1;
  EX5 := CL4 + EX4W + 0.1;
  EX6 := EX5 + EX5W + 0.1;
  EX7 := EX6 + EX6W + 0.1;
  TL1 := Mrg;
  TL2 := TL1 + TL1W + 0.1;
  TL3 := TL2 + TL2W + 0.1;
  TL4 := TL3 + TL3W + 0.2;
  TL5 := TL4 + TL4W + 0.1;
  TL6 := TL5 + TL5W + 0.1;
  TL7 := TL6 + TL6W + 0.1;
  TL8 := TL7 + TL7W + 0.1;
  TL9 := TL8 + TL8W + 0.1;
  TL10 := TL9 + TL9W + 0.1;
  TL11 := TL10 + TL10W + 0.1;

    {FXX05012002-1: Make sure that we don't show the calculate roll totals button if
                    they can't recalculate totals.}

  CalculateButton.Visible := GlblCanCalculateRollTotals;

    {CHG01192004-1(2.08): Let each municipality decide what roll totals to display.}

  If not (rtdSchool in GlblRollTotalsToShow)
    then TotalsBySchoolCheckBox.Checked := False;
  
end;  {InitializeForm}

{====================================================================}
Procedure TRollTotalReport.AssessmentYearRadioGroupClick(Sender: TObject);

{FXX1004199-6: Allow history roll totals print.}

begin
  case AssessmentYearRadioGroup.ItemIndex of
    0, 1 : begin
             HistoryEdit.Text := '';
             HistoryEdit.Visible := False;
           end;

    2 : HistoryEdit.Visible := True;

  end;  {case AssessmentYearRadioGroup.ItemIndex of}

end;  {AssessmentYearRadioGroupClick}

{====================================================================}
Procedure TRollTotalReport.AllButtonClick(Sender: TObject);

{Select all the sections.}

var
  I : Integer;
  TempStr : String;

begin
  For I := 0 to (ComponentCount - 1) do
    If (Components[I] is TCheckBox)
      then
        with Components[I] as TCheckBox do
          begin
            TempStr := Caption;

              {Check the check boxes that start with the word 'Total'.}

            If (Pos('Total', TempStr) > 0)
              then Checked := True;

          end;  {with Components[I] as TCheckBox do}

end;  {AllButtonClick}

{====================================================================}
Procedure TRollTotalReport.NoneButtonClick(Sender: TObject);

{Unselect all the sections.}

var
  I : Integer;
  TempStr : String;

begin
  For I := 0 to (ComponentCount - 1) do
    If (Components[I] is TCheckBox)
      then
        with Components[I] as TCheckBox do
          begin
            TempStr := Caption;

              {Uncheck the check boxes that start with the word 'Total'.}

            If (Pos('Total', TempStr) > 0)
              then Checked := False;

          end;  {with Components[I] as TCheckBox do}

end;  {NoneButtonClick}

{====================================================================}
Procedure TRollTotalReport.SaveButtonClick(Sender: TObject);

{FXX04091999-8: Add ability to save and load search report options.}

begin
  SaveReportOptions(Self, OpenDialog, SaveDialog, 'rolltot.tot', 'Roll Total Print');

end;  {SaveButtonClick}

{====================================================================}
Procedure TRollTotalReport.LoadButtonClick(Sender: TObject);

{FXX04091999-8: Add ability to save and load search report options.}

begin
  LoadReportOptions(Self, OpenDialog, 'rolltot.tot', 'Roll Total Print');

end;  {LoadButtonClick}

{===================================================================}
Procedure TRollTotalReport.CalculateButtonClick(Sender: TObject);

{CHG03282002-8: Let them calculate from the display and print screens.}

var
  TempStr, AssessmentYear : String;
  ProcessingType : Integer;

begin
  ProcessingType := GlblProcessingType;
  If (AssessmentYearRadioGroup.ItemIndex = ayHistory)
    then MessageDlg('Sorry, you can not recalculate roll totals for history.',
                    mtError, [mbOK], 0)
    else
      begin
        case AssessmentYearRadioGroup.ItemIndex of
          ayThisYear : begin
                         TempStr := 'This Year';
                         ProcessingType := ThisYear;
                         AssessmentYear := GlblThisYear;
                       end;

          ayNextYear : begin
                         TempStr := 'Next Year';
                         ProcessingType := NextYear;
                         AssessmentYear := GlblNextYear;
                       end;

        end;  {case AssessmentYearRadioGroup.ItemIndex of}

        CreateRollTotals(ProcessingType, AssessmentYear,
                         ProgressDialog, Self, False, True);

      end;  {else of If (AssessmentYearRadioGroup.ItemIndex = ayHistory)}

end;  {CalculateButtonClick}

{===================================================================}
Procedure TRollTotalReport.PrintButtonClick(Sender: TObject);

var
  Quit : Boolean;
  TextFileName, NewFileName, SpreadsheetFileName : String;
  I : Integer;

begin
  Quit := False;
  ReportCancelled := False;
  FirstPageOfReport := True;

    {CHG04092004-1(2.08): Display the equalization rate, RAR and uniform percent of value,
                          but only if all swis codes are part of the same town.}

  PrintEqualizationRate := PrintEqualizationRateCheckBox.Checked;
  _AllSwisCodesInSameMunicipality := AllSwisCodesInSameMunicipality(SwisCodeTable);

    {FXX09301998-1: Disable print button after clicking to avoid clicking twice.}

  PrintButton.Enabled := False;
  Application.ProcessMessages;

    {CHG10121998-1: Add user options for default destination and show vet max msg.}

  SetPrintToScreenDefault(PrintDialog);

    {CHG06092010-2(2.26.1)[I7371]: Force totals calculate before print.}

  If glblAutoCalcRollTotalsBeforePrint
  then CalculateButtonClick(nil);

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

        TotalsOnly := (TotalsRadioGroup.ItemIndex = 1);

        SelectedSwisCodes.Clear;

        For I := 0 to (SwisCodeListBox.Items.Count - 1) do
          If SwisCodeListBox.Selected[I]
            then SelectedSwisCodes.Add(Take(6, SwisCodeListBox.Items[I]));

          {FXX97262005-1(2.9.1.2): If the totals only is clicked, but they select a swis code,
                                   don't print totals only.}

        If (TotalsOnly and
            _Compare(SelectedSwisCodes.Count, SwisCodeListBox.Items.Count, coLessThan))
          then TotalsOnly := False;

        PrintClassAmounts := ShowClassCheckBox.Checked;
        PrintSchoolTotals := TotalsBySchoolCheckBox.Checked;
        PrintExemptionTotals := TotalsByEXCodeCheckBox.Checked;
        PrintSpecialDistrictTotals := TotalsBySDCodeCheckBox.Checked;
        PrintRollSectionTotals := TotalsByRollSectionCheckBox.Checked;
        PrintVillageRelevyTotals := TotalsByVillageRelevyCheckBox.Checked;
        PrintProrataTotals := TotalsByRS9CheckBox.Checked;

          {CHG02012004-5(2.08): Option to print to Excel.}

        ExtractToExcel := ExtractToExcelCheckBox.Checked;

        If ExtractToExcel
          then
            begin
              SpreadsheetFileName := GetPrintFileName(Self.Caption, True);
              AssignFile(ExtractFile, SpreadsheetFileName);
              Rewrite(ExtractFile);

            end;  {If PrintToExcel}

          {CHG10131998-1: Set the printer settings based on what printer they selected
                          only - they no longer need to worry about paper or landscape
                          mode.}

        AssignPrinterSettings(PrintDialog, ReportPrinter, ReportFiler, [ptBoth], True, Quit);

          {CHG12062003-2(2.07k1): Option to print on letter size paper.}

        If (ReportPrinter.Orientation = poLandscape)
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

                    ReportPrinter.ScaleX := 85;
                    ReportPrinter.ScaleY := 80;
                    ReportPrinter.SectionLeft := 1.5;
                    ReportFiler.ScaleX := 85;
                    ReportFiler.ScaleY := 80;
                    ReportFiler.SectionLeft := 1.5;
                    LinesAtBottom := GlblLinesLeftOnRollDotMatrix;
                  end
                else LinesAtBottom := GlblLinesLeftOnRollLaserJet;

            end
          else LinesAtBottom := GlblLinesLeftOnRollDotMatrix;

        If not Quit
          then
            begin
               case AssessmentYearRadioGroup.ItemIndex of
                 0 : begin
                       ProcessingType := ThisYear;
                       TaxRollYear := GlblThisYear;
                     end;

                 1 : begin
                       ProcessingType := NextYear;
                       TaxRollYear := GlblNextYear;
                     end;

                 2 : begin
                       ProcessingType := History;
                       TaxRollYear := HistoryEdit.Text;
                     end;

               end;  {case AssessmentYearRadioGroup.ItemIndex of}

                {FXX07212004-1(2.08): Make sure to reopen the swis code for the correct processing type.}

              OpenTableForProcessingType(SwisCodeTable, SwisCodeTableName, ProcessingType, Quit);

              If (ProcessingType = History)
                then SetFilterForHistoryYear(SwisCodeTable, TaxRollYear);

              with SwisCodeTable do
                begin
                  EqualizationRate := FieldByName('EqualizationRate').AsFloat;
                  ResidentialAssessmentRatio := FieldByName('ResAssmntRatio').AsFloat;
                  UniformPercentOfValue := FieldByName('UniformPercentValue').AsFloat;
                end;

                {FXX05101999-1: Need to open each of the tables explicitly
                                each time rather than using  OpenTablesForForm
                                since this does not work when switching NY to TY
                                (since FastOpen depends on the first letter of the
                                 table name being 'T').}

              OpenTableForProcessingType(TotalsBySchoolTable, RTBySchoolCodeTableName,
                                         ProcessingType, Quit);
              OpenTableForProcessingType(TotalsByExemptionTable, RTByExCodeTableName,
                                         ProcessingType, Quit);
              OpenTableForProcessingType(TotalsBySpecialDistrictTable, RTBySDCodeTableName,
                                         ProcessingType, Quit);
              OpenTableForProcessingType(TotalsByRollSectionTable, RTBySwisCodeTableName,
                                         ProcessingType, Quit);
              OpenTableForProcessingType(TotalsByVillageRelevyTable, RTByVillageRelevyTableName,
                                         ProcessingType, Quit);
              OpenTableForProcessingType(TotalsByProrataTable, RTByRS9TableName,
                                         ProcessingType, Quit);
              OpenTableForProcessingType(SwisCodeTable, SwisCodeTableName,
                                         ProcessingType, Quit);

                {Now print the report.}

              If not (Quit or ReportCancelled)
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
                    GlblPreviewPrint := False;

                      {FXX01211998-1: Need to set the LastPage property so that
                                      long rolls aren't a problem.}

                    TextFiler.LastPage := 30000;

                    TextFiler.Execute;

                    If PrintDialog.PrintToFile
                      then
                        begin
                          NewFileName := GetPrintFileName(Self.Caption, True);
                          ReportFiler.FileName := NewFileName;
                          GlblPreviewPrint := True;

                          try
                            PreviewForm := TPreviewForm.Create(self);
                            PreviewForm.FilePrinter.FileName := NewFileName;
                            PreviewForm.FilePreview.FileName := NewFileName;

                            ReportFiler.Execute;
                            PreviewForm.ShowModal;
                          finally
                            PreviewForm.Free;

                              {Now delete the file.}
                            try
                              Chdir(GlblReportDir);
                              OldDeleteFile(NewFileName);
                            finally
                              {We don't care if it does not get deleted, so we won't put up an
                               error message.}

                              ChDir(GlblProgramDir);
                            end;

                          end;  {try PreviewForm := ...}

                        end  {If PrintDialog.PrintToFile}
                      else ReportPrinter.Execute;

                      {CHG01182000-3: Allow them to choose a different name or copy right away.}

                    with ReportDialog do
                      begin
                        FileName := 'RPROLTOT.RPT';
                        OrigFileName := TextFiler.FileName;
                        ShowModal;
                      end;

                  end;  {If not Quit}

              ResetPrinter(ReportPrinter);

              If ExtractToExcel
                then
                  begin
                    CloseFile(ExtractFile);
                    SendTextFileToExcelSpreadsheet(SpreadsheetFileName, True,
                                                   False, '');

                  end;  {If PrintToExcel}

            end;  {If not Quit}

      end;  {If PrintDialog.Execute}

  PrintButton.Enabled := True;

end;  {PrintButtonClick}

{==================================================================}
Procedure PrintHeader(    Sender : TObject;  {Report printer or filer object}
                          SectionType : Char; {(S)wis, S(c)hool, (G)rand}
                          SwisCode : String;
                          TaxRollYear : String;
                          SwisCodeDescList : TList;
                          PageNo : Integer;
                      var LineNo : Integer);

{Print the header for this type of roll.}

var
  TempStr : String;

begin
  GlblCurrentTabNo := 1;
  GlblCurrentLinePos := 1;

  with Sender as TBaseReport do
    begin
      NumLinesPerPage := Trunc(6 * PageHeight);
      NumColsPerPage := 130;
      ClearTabs;
        {1st header line}

        {FXX02182004-3(2.07l1): Condensed the date and page columns so they fit better on letter size.}
        
      SetTab(Mrg, pjLeft, 2.0, 0, BOXLINENONE, 0);   {cOUNTY}
      SetTab(4.5, pjCenter, 5.0, 0, BOXLINENONE, 0);   {HDR}
      SetTab(10.0, pjLeft, 0.6, 0, BOXLINENONE, 0);   {VALUATION Date prose}
      SetTab(10.7, pjRight, 0.9, 0, BOXLINENONE, 0);   {VALUATION Date}
      Println('');
      Println('');

      TempStr := TaxRollYear + ' R O L L   T O T A L S';

      Println(#9 + 'STATE OF NEW YORK' +
                  #9 + TempStr +
                  #9 + 'PAGE: ' +
                  #9 + IntToStr(PageNo));

      Print(#9 + 'COUNTY: ' + GlblCountyName);

      case SectionType of
        'S' : Print(#9 + 'S W I S    T O T A L S');
        'C' : Print(#9 + 'S C H O O L    T O T A L S');
        'M' : Print(#9 + 'M U N I C I P A L I T Y    T O T A L S');

      end;  {case StrToInt(RollSection) of}

      Println(#9 + 'DATE: ' + #9 + DateToStr(Date));

       {2ND HDR LINE}
       {CHG03082007-1(MDT): Put time on roll totals.}

      Println(#9 + UpcaseStr(GetMunicipalityName) + #9 +
              #9 + 'TIME: ' + TimeToStr(Now));

       {3RD HDR LINE}

      If (Length(Trim(SwisCode)) = 6)
        then Println(#9 + 'SWIS: ' + SwisCode + '  ('+
                          Trim(GetDescriptionFromList(SwisCode, SwisCodeDescList)) + ')')
        else Println(#9 + 'SWIS: ' + SwisCode);

        {CHG04092004-1(2.08): Display the equalization rate, RAR and uniform percent of value,
                              but only if all swis codes are part of the same town.}

      If (PrintEqualizationRate and
          _AllSwisCodesInSameMunicipality)
        then
          Println(#9 + 'Eq Rate: ' +
                       FormatFloat(PercentageDisplay_2Decimals, EqualizationRate) +
                  #9 + 'RAR: ' +
                       FormatFloat(PercentageDisplay_2Decimals, ResidentialAssessmentRatio) +
                  #9 + 'Uniform %: ' +
                       FormatFloat(PercentageDisplay_2Decimals, UniformPercentOfValue));

    end;  {with Sender as TBaseReport do}

  LineNo := LineNo + 5;

end;  {PrintHeader}

{FXX03191999-2: The PageNo was not being var'ed in.}
{==================================================================}
Procedure StartNewPage(    Sender : TObject;  {Report printer or filer object}
                           SectionType : Char; {(S)wis, S(c)hool, (G)rand}
                           SwisCode : String;
                           TaxRollYear : String;
                           SwisCodeDescList : TList;
                       var PageNo : Integer;
                       var LineNo : Integer);

{Start a new page by formfeeding, reseting the counters and printing the
 header.}

begin
  TBaseReport(Sender).NewPage;

  LineNo := 1;
  PageNo := PageNo + 1;
  PrintHeader(Sender, SectionType, SwisCode,
              TaxRollYear, SwisCodeDescList,
              PageNo, LineNo);

end;  {StartNewPage}

{=======================================================================}
Procedure PrintTotalsPageSubheader(    Sender : TObject;  {Report printer or filer object}
                                       SectionType : Char;  {(R)oll section, (S)wis, S(c)hool, (G)rand}
                                   var LineNo : Integer);

{This is a header that appears once at the top of each totals page.}

begin
  with Sender as TBaseReport do
    begin
      ClearTabs;
      SetTab(Mrg, pjLeft, 13.0, 0, BOXLINENONE, 0);   {Header}

      case SectionType of
        'R' : Println(#9 + Center('R O L L    S E C T I O N    T O T A L S', NumColsPerPage));
        'S' : Println(#9 + Center('S W I S    T O T A L S', NumColsPerPage));
        'C' : Println(#9 + Center('S C H O O L    T O T A L S', NumColsPerPage));
        'G' : Println(#9 + Center('M U N I C I P A L I T Y    T O T A L S', NumColsPerPage));
        '9' : Println(#9 + Center('R O L L    S E C T I O N   9   T O T A L S', NumColsPerPage));
        'V' : Println(#9 + Center('V I L L A G E    R E L E V Y    T O T A L S', NumColsPerPage));

      end;  {case SectionType of}

    end;  {with Sender as TBaseReport do}

  LineNo := LineNo + 1;

end;  {PrintTotalsPageSubheader}

{=======================================================================}
Procedure PrintSectionHeader(    Sender : TObject;  {Report printer or filer object}
                                 TotalsType : Char;  {(G)eneral, S(c)hool, S(D), E(X), Spcl (F)ee}
                             var LineNo : Integer);

{Print the totals section subheader.}

begin
  with Sender as TBaseReport do
    begin
      ClearTabs;
      SetTab(Mrg, pjLeft, 13.0, 0, BOXLINENONE, 0);   {Header}
      Println('');

      case TotalsType of
        'D' : Println(#9 + Center('***  S P E C I A L    D I S T R I C T   S U M M A R Y ***', NumColsPerPage));
        'X' : Println(#9 + Center('***  E X E M P T I O N   S U M M A R Y ***', NumColsPerPage));
        'C' : Println(#9 + Center('***  S C H O O L   S U M M A R Y ***', NumColsPerPage));
        'R' : Println(#9 + Center('***  R O L L   S E C T I O N   S U M M A R Y ***', NumColsPerPage));
        'V' : Println(#9 + Center('***  V I L L A G E   R E L E V Y   S U M M A R Y ***', NumColsPerPage));
        'P' : Println(#9 + Center('***  P R O R A T E D \ O M I T T E D   S U M M A R Y ***', NumColsPerPage));
        'G' : Println(#9 + Center('***  G R A N D   T O T A L S ***', NumColsPerPage));

      end;  {case TotalsType of}

    end;  {with Sender as TBaseReport do}

  LineNo := LineNo + 4;

end;  {PrintSectionHeader}

{=======================================================================}
Procedure PrintSectionSubheader(    Sender : TObject;  {Report printer or filer object}
                                    SectionType : Char;  {(S)wis, S(c)hool, (G)rand, (H)std, (N)onhstd}
                                var LineNo : Integer);

{Print the totals section subheader.}

begin
    {FXX06291998-5: Only need subheaders if the municipality is classified.}

  If GlblMunicipalityIsClassified
    then
      with Sender as TBaseReport do
        begin
          ClearTabs;
          SetTab(Mrg, pjLeft, 13.0, 0, BOXLINENONE, 0);   {Header}
          Println('');

          case SectionType of
            'S' : Println(#9 + Center('***  S W I S  ***', NumColsPerPage));
            'C' : Println(#9 + Center('***  S C H O O L  ***', NumColsPerPage));
            'G' : Println(#9 + Center('***  M U N I C I P A L I T Y  ***', NumColsPerPage));
            'H' : Println(#9 + Center('***  H O M E S T E A D  ***', NumColsPerPage));
            'N' : Println(#9 + Center('***  N O N - H O M E S T E A D  ***', NumColsPerPage));

          end;  {case SectionType of}

        end;  {with Sender as TBaseReport do}

  LineNo := LineNo + 1;

end;  {PrintSectionSubheader}

{=======================================================================}
{=================   SCHOOL TOTALS  ====================================}
{=======================================================================}
Function FoundSchoolRecord(    SchoolTotalsList : TList;
                               _SchoolCode : String;
                               _HomesteadCode : String;
                           var I : Integer) : Boolean;

{Search through the totals list for this school code,
 and homestead code.}

var
  J : Integer;

begin
  Result := False;

  For J := 0 to (SchoolTotalsList.Count - 1) do
    with RTSchoolCodeTotalsPtr(SchoolTotalsList[J])^ do
      If ((Take(6, SchoolCode) = Take(6, _SchoolCode)) and
          (Take(1, HomesteadCode) = Take(1, _HomesteadCode)))
        then
          begin
            Result := True;
            I := J;
          end;

end;  {FoundSchoolRecord}

{====================================================================================}
Procedure CombineSchoolTotals(SchoolTotalsList,  {List with totals broken down into hstd, nonhstd.}
                              OverallTotalsList : TList);  {No hstd\nonhstd breakdown.}

{The totals entries in the SchoolTotalsList are broken down into homestead and
 nonhomestead, so we want to combine them for the overall totals. To do
 this, we will take the entries from the SchoolTotalsList and put them into the
 overall totals list, disregarding the homestead code.}
{CHG07291999-1: Add STAR values and taxable vals to on-line totals.}

var
  I, J : Integer;
  SchoolTotalsPtr : RTSchoolCodeTotalsPtr;

begin
  For I := 0 to (SchoolTotalsList.Count - 1) do
    with RTSchoolCodeTotalsPtr(SchoolTotalsList[I])^ do
      If FoundSchoolRecord(OverallTotalsList, SchoolCode,
                            ' ', J)  {Don't use hstd code as a key.}
        then
          begin
              {Note that we do not add the split count again since we
               would be double counting it then.}

            RTSchoolCodeTotalsPtr(OverallTotalsList[J])^.ParcelCount :=
                     RTSchoolCodeTotalsPtr(OverallTotalsList[J])^.ParcelCount + ParcelCount;
            RTSchoolCodeTotalsPtr(OverallTotalsList[J])^.LandValue :=
                     RTSchoolCodeTotalsPtr(OverallTotalsList[J])^.LandValue + LandValue;
            RTSchoolCodeTotalsPtr(OverallTotalsList[J])^.AssessedValue :=
                     RTSchoolCodeTotalsPtr(OverallTotalsList[J])^.AssessedValue + AssessedValue;
            RTSchoolCodeTotalsPtr(OverallTotalsList[J])^.SchoolTaxable :=
                     RTSchoolCodeTotalsPtr(OverallTotalsList[J])^.SchoolTaxable + SchoolTaxable;
            RTSchoolCodeTotalsPtr(OverallTotalsList[J])^.RelevyCount :=
                     RTSchoolCodeTotalsPtr(OverallTotalsList[J])^.RelevyCount + RelevyCount;
            RTSchoolCodeTotalsPtr(OverallTotalsList[J])^.SchoolRelevyAmt :=
                     RTSchoolCodeTotalsPtr(OverallTotalsList[J])^.SchoolRelevyAmt + SchoolRelevyAmt;
            RTSchoolCodeTotalsPtr(OverallTotalsList[J])^.BasicSTARAmount :=
                     RTSchoolCodeTotalsPtr(OverallTotalsList[J])^.BasicSTARAmount + BasicSTARAmount;
            RTSchoolCodeTotalsPtr(OverallTotalsList[J])^.EnhancedSTARAmount :=
                     RTSchoolCodeTotalsPtr(OverallTotalsList[J])^.EnhancedSTARAmount + EnhancedSTARAmount;
            RTSchoolCodeTotalsPtr(OverallTotalsList[J])^.BasicSTARCount :=
                     RTSchoolCodeTotalsPtr(OverallTotalsList[J])^.BasicSTARCount + BasicSTARCount;
            RTSchoolCodeTotalsPtr(OverallTotalsList[J])^.EnhancedSTARCount :=
                     RTSchoolCodeTotalsPtr(OverallTotalsList[J])^.EnhancedSTARCount + EnhancedSTARCount;

          end
        else
          begin
            New(SchoolTotalsPtr);   {get new pptr for tlist array}

            SchoolTotalsPtr^.SwisCode := SwisCode;
            SchoolTotalsPtr^.SchoolCode := SchoolCode;
            SchoolTotalsPtr^.HomesteadCode := ' ';  {Blank out hstd code.}
            SchoolTotalsPtr^.AssessedValue := AssessedValue;
            SchoolTotalsPtr^.LandValue := LandValue;
            SchoolTotalsPtr^.SchoolTaxable := SchoolTaxable;
            SchoolTotalsPtr^.ParcelCount := ParcelCount;
            SchoolTotalsPtr^.PartCount := PartCount;
            SchoolTotalsPtr^.RelevyCount := RelevyCount;
            SchoolTotalsPtr^.SchoolRelevyAmt := SchoolRelevyAmt;
            SchoolTotalsPtr^.BasicSTARAmount := BasicSTARAmount;
            SchoolTotalsPtr^.EnhancedSTARAmount := EnhancedSTARAmount;
            SchoolTotalsPtr^.BasicSTARCount := BasicSTARCount;
            SchoolTotalsPtr^.EnhancedSTARCount := EnhancedSTARCount;

            OverallTotalsList.Add(SchoolTotalsPtr);

          end;  {else of If FoundSchoolRecord(OverallTotalsList, SchoolCode, ExtCode, CMFlag,}

end;  {CombineSchoolTotals}

{=======================================================================}
Procedure UpdateSchoolTaxTotals(    SourceSchoolTotalsRec : RTSchoolTotals;
                                var TempSchoolTotalRec : RTSchoolTotals);

{Update the running totals in the TempSchoolTotalRec from the source
 rec.}
{CHG07291999-1: Add STAR values and taxable vals to on-line totals.}

begin
  with TempSchoolTotalRec do
    begin
      ParcelCount := ParcelCount + SourceSchoolTotalsRec.ParcelCount;
      PartCount := PartCount + SourceSchoolTotalsRec.PartCount;
      LandValue := LandValue + SourceSchoolTotalsRec.LandValue;
      AssessedValue := AssessedValue + SourceSchoolTotalsRec.AssessedValue;
      SchoolTaxable := SchoolTaxable + SourceSchoolTotalsRec.SchoolTaxable;
      RelevyCount := RelevyCount + SourceSchoolTotalsRec.RelevyCount;
      SchoolRelevyAmt := SchoolRelevyAmt + SourceSchoolTotalsRec.SchoolRelevyAmt;
      BasicSTARAmount := BasicSTARAmount + SourceSchoolTotalsRec.BasicSTARAmount;
      EnhancedSTARAmount := EnhancedSTARAmount + SourceSchoolTotalsRec.EnhancedSTARAmount;
      BasicSTARCount := BasicSTARCount + SourceSchoolTotalsRec.BasicSTARCount;
      EnhancedSTARCount := EnhancedSTARCount + SourceSchoolTotalsRec.EnhancedSTARCount;

    end;  {with TempSchoolTotalRec do}

end;  {UpdateSchoolTaxTotals}

{=======================================================================}
Procedure PrintSchoolSubheader(    Sender : TObject;  {Report printer or filer object}
                                   SubheaderType : Char;  {(H)std, (N)onhstd, (S)wis, S(c)hool, (R)S, (G)rand}
                                   PrintClassAmounts : Boolean;
                               var LineNo : Integer);

{Print the individual School totals section header and set the tabs for the
 School amounts columns.}
{CHG07291999-1: Add STAR values and taxable vals to on-line totals.}

begin
  with Sender as TBaseReport do
    begin
        {Roll section totals do not breakdown by hSchoolt\nonhstd so
         the following two lines are not needed.}

      If PrintClassAmounts
        then PrintSectionSubheader(Sender, SubheaderType, LineNo);

        {FXX02101999-4: Add land value to swis and school totals.}

      ClearTabs;
      SetTab(TL1, pjLeft, TL1W, 0, BOXLINENONE, 0);   {Code}
      SetTab(TL2, pjLeft, TL2W, 0, BOXLINENONE, 0);   {Desc}
      SetTab(TL3, pjCenter, TL3W, 0, BOXLINENONE, 0);   {PRCL CNT}
      SetTab(TL4, pjCenter, TL4W, 0, BOXLINENONE, 0);   {Land Val}
      SetTab(TL5, pjCenter, TL5W, 0, BOXLINENONE, 0);   {Assessed Val\#basic}
      SetTab(TL6, pjCenter, TL6W, 0, BOXLINENONE, 0);   {Taxable Val\basic amt}
      SetTab(TL7, pjCenter, TL7W, 0, BOXLINENONE, 0);   {Relevy Count\ # enh}
      SetTab(TL8, pjCenter, TL8W, 0, BOXLINENONE, 0);   {Relevy Amt\enh amount}
      SetTab(TL9, pjCenter, TL9W, 0, BOXLINENONE, 0);   {Taxable after star}

       {Don't show tax rate or tax total unless this is a school billing.}

      Println('');
      Println(#9 + 'SCHL' +
              #9 +
              #9 + 'TOTAL' +
              #9 + 'LAND' +
              #9 + 'ASSESSED' +
              #9 + 'TAXABLE' +
              #9 + 'RELEVY' +
              #9 + 'RELEVY' +
              #9 + 'TAXABLE VAL');

      Println(#9 + 'CODE' +
              #9 + 'DESCRIPTION' +
              #9 + 'PARCELS' +
              #9 + 'VALUE' +
              #9 + 'VALUE' +
              #9 + 'VALUE' +
              #9 + 'COUNT' +
              #9 + 'AMOUNT' +
              #9 + 'AFTER STAR');

         {If this is a homestead or nonhomestead section,
          print that this is the total number of parcels and parts.}

       If (SubheaderType in ['H', 'N'])
         then Println(#9 + #9 + #9 + '& PARTS');

       Println('');
       Println(#9 + #9 + #9 + #9 +
               #9 + 'NUM BASIC' +
               #9 + 'BASIC AMOUNT' +
               #9 + 'NUM ENH' +
               #9 + 'ENH AMOUNT');

       {FXX12291997-2: Print a blank line between the header and the start
                       of the information.}

      Println('');
      LineNo := LineNo + 1;

    end;  {with Sender as TBaseReport do}

  LineNo := LineNo + 6;

end;  {PrintSchoolSubheader}

{=======================================================================}
Procedure PrintOneSchoolTotal(    Sender : TObject;  {Report printer or filer object}
                                  SubheaderType : Char;  {(H)std, (N)onhstd, (S)wis, S(c)hool, (R)S, (G)rand}
                                  SchoolCodeDescList : TList;
                                  SchoolTotalsRec : RTSchoolTotals;
                                  IsTotalRecord : Boolean;  {Is this a 'TOTAL' line?}
                              var LineNo : Integer);

{Print one school total.}
{CHG07291999-1: Add STAR values and taxable vals to on-line totals.}

begin
   {FXX02101999-4: Add land value to swis and school totals.}

  with Sender as TBaseReport do
    begin
        {Reset the tabs}

      ClearTabs;
      SetTab(TL1, pjLeft, TL1W, 0, BOXLINENONE, 0);   {Code}
      SetTab(TL2, pjLeft, TL2W, 0, BOXLINENONE, 0);   {Desc}
      SetTab(TL3, pjRight, TL3W, 0, BOXLINENONE, 0);   {PRCL CNT}
      SetTab(TL4, pjRight, TL4W, 0, BOXLINENONE, 0);   {Land Val}
      SetTab(TL5, pjRight, TL5W, 0, BOXLINENONE, 0);   {Assessed Val \ # basic}
      SetTab(TL6, pjRight, TL6W, 0, BOXLINENONE, 0);   {Taxable Val \ basic amt}
      SetTab(TL7, pjRight, TL7W, 0, BOXLINENONE, 0);   {Relevy Count \ # enh}
      SetTab(TL8, pjRight, TL8W, 0, BOXLINENONE, 0);   {Relevy Amt \ enh amt}
      SetTab(TL9, pjRight, TL9W, 0, BOXLINENONE, 0);   {Taxable after STAR}

      with SchoolTotalsRec do
        begin
          If IsTotalRecord
            then Print(#9 + #9 + 'TOTAL')
            else Print(#9 + SchoolCode +
                       #9 + Take(18, (GetDescriptionFromList(SchoolCode, SchoolCodeDescList))));

            {FXX01071998-7: Subtract the number of splits out of the total.}
            {FXX04272004-1(2.07l3): Need to make sure not to cut the part count in half for the
                                    school totals.}

          If (SubheaderType in ['H', 'N'])
            then Print(#9 + IntToStr(ParcelCount + PartCount))
            else Print(#9 + IntToStr(ParcelCount + (PartCount DIV 2)));

            {FXX02101999-4: Add land value to swis and school totals.}

          Print(#9 + FormatFloat(NoDecimalDisplay_BlankZero, LandValue));
          Print(#9 + FormatFloat(NoDecimalDisplay_BlankZero, AssessedValue));
          Print(#9 + FormatFloat(NoDecimalDisplay_BlankZero, SchoolTaxable));
          Print(#9 + FormatFloat(NoDecimalDisplay_BlankZero, RelevyCount));

            {FXX12151999-6: Need to print decimals for school relevy amt.}

          Print(#9 + FormatFloat(DecimalDisplay, SchoolRelevyAmt));
          Print(#9 + FormatFloat(NoDecimalDisplay_BlankZero,
                                 (SchoolTaxable - (BasicSTARAmount + EnhancedSTARAmount))));

          Println('');

          Println(#9 + #9 + #9 + #9 +
                  #9 + IntToStr(BasicSTARCount) +
                  #9 + FormatFloat(NoDecimalDisplay_BlankZero, BasicSTARAmount) +
                  #9 + IntToStr(EnhancedSTARCount) +
                  #9 + FormatFloat(NoDecimalDisplay_BlankZero, EnhancedSTARAmount));
          Println('');

            {CHG02012004-5(2.08): Option to print to Excel.}

          If ExtractToExcel
            then
              begin
                If IsTotalRecord
                  then Write(ExtractFile, 'TOTAL,')
                  else Write(ExtractFile, SchoolCode,
                                          FormatExtractField(GetDescriptionFromList(SchoolCode, SchoolCodeDescList)));

                If (SubheaderType in ['H', 'N'])
                  then Write(ExtractFile, FormatExtractField(IntToStr(ParcelCount)))
                  else Write(ExtractFile, FormatExtractField(IntToStr(ParcelCount + (PartCount DIV 2))));

                Writeln(ExtractFile, FormatExtractField(FormatFloat(NoDecimalDisplay_BlankZero, LandValue)),
                                     FormatExtractField(FormatFloat(NoDecimalDisplay_BlankZero, AssessedValue)),
                                     FormatExtractField(FormatFloat(NoDecimalDisplay_BlankZero, SchoolTaxable)),
                                     FormatExtractField(IntToStr(BasicSTARCount)),
                                     FormatExtractField(FormatFloat(NoDecimalDisplay_BlankZero, BasicSTARAmount)),
                                     FormatExtractField(IntToStr(EnhancedSTARCount)),
                                     FormatExtractField(FormatFloat(NoDecimalDisplay_BlankZero, EnhancedSTARAmount)),
                                     FormatExtractField(FormatFloat(NoDecimalDisplay_BlankZero,
                                                                   (SchoolTaxable - (BasicSTARAmount + EnhancedSTARAmount)))),
                                     FormatExtractField(FormatFloat(NoDecimalDisplay_BlankZero, RelevyCount)),
                                     FormatExtractField(FormatFloat(DecimalDisplay, SchoolRelevyAmt)));

              end; {If ExtractToExcel}

        end;  {with SchoolTotalsRec do}

      LineNo := LineNo + 3;

    end;  {with Sender as TBaseReport do}

end;  {PrintOneSchoolTotal}

{=======================================================================}
Procedure PrintSchoolTotalsSection(    Sender : TObject;  {Report printer or filer object}
                                       SchoolTotalsList : TList;
                                       TaxRollYear : String;
                                       SwisCode : String;
                                       SchoolCodeDescList,
                                       SwisCodeDescList : TList;
                                       PrintClassAmounts : Boolean;
                                       SectionType : Char;
                                   var PageNo,
                                       LineNo : Integer);

{Print the School totals in the TLists.}
{CHG07291999-1: Add STAR values and taxable vals to on-line totals.}

var
  I, NumHomestead, NumNonhomestead : Integer;
  HeaderPrinted, SubheaderPrinted : Boolean;
  OverallSchoolTotalsList : TList;
  TempSchoolTotalRec : RTSchoolTotals;  {For an overall total for this section.}
  TempSubheaderType : Char;

begin
  HeaderPrinted := False;
  NumHomestead := 0;
  NumNonhomestead := 0;

  If FirstPageOfReport
    then
      begin
        PrintHeader(Sender, SectionType, SwisCode,
                    TaxRollYear, SwisCodeDescList,
                    PageNo, LineNo);
        FirstPageOfReport := False;
      end
    else StartNewPage(Sender, SectionType, SwisCode,
                      TaxRollYear, SwisCodeDescList,
                      PageNo, LineNo);

    {CHG02012004-5(2.08): Option to print to Excel.}

  If ExtractToExcel
    then
      begin
        Writeln(ExtractFile);
        Writeln(ExtractFile, 'School Totals');
        If PrintClassAmounts
          then Writeln(ExtractFile, ',Homestead Totals');
        Writeln(ExtractFile, 'School,',
                             'Description,',
                             'Parcel Count,',
                             'Land Value,',
                             'Assessed Value,',
                             'Taxable Value,',
                             'Basic STAR Count,',
                             'Basic STAR Amount,',
                             'Enh STAR Count,',
                             'Enh STAR Amount,',
                             'Taxable After STAR,',
                             'Relevy Count,',
                             'Relevy Amount');

      end;  {If ExtractToExcel}

  For I := 0 to (SchoolTotalsList.Count - 1) do
    with RTSchoolCodeTotalsPtr(SchoolTotalsList[I])^ do
      If (HomesteadCode = 'N')
        then NumNonhomestead := NumNonhomestead + 1
        else NumHomestead := NumHomestead + 1;

  with Sender as TBaseReport do
    begin
        {First homestead part, but only if this is not a roll section summary.
         Note that we print the header and subheader only if there is an
         entry.}

      If PrintClassAmounts
        then
          begin
            SubheaderPrinted := False;

              {Initialize the temporary record for the totals for this
               subsection.}

            with TempSchoolTotalRec do
              begin
                ParcelCount := 0;
                PartCount := 0;
                LandValue := 0;
                AssessedValue := 0;
                SchoolTaxable := 0;
                RelevyCount := 0;
                SchoolRelevyAmt := 0;
                BasicSTARAmount := 0;
                EnhancedSTARAmount := 0;
                BasicSTARCount := 0;
                EnhancedSTARCount := 0;

              end;  {with TempSchoolTotalRec do}

            If (NumHomestead = 0)
              then
                begin
                  Println('');
                  PrintSectionHeader(Sender, 'C', LineNo);
                  PrintSchoolSubheader(Sender, 'H', PrintClassAmounts, LineNo);
                  ClearTabs;
                  SetTab(4.5, pjCenter, 5.0, 0, BOXLINENONE, 0);   {HDR}
                  Println(#9 + 'NO TOTALS AT THIS LEVEL');
                  Println('');
                end
              else
                begin
                  For I := 0 to (SchoolTotalsList.Count - 1) do
                    If (RTSchoolCodeTotalsPtr(SchoolTotalsList[I])^.HomesteadCode[1] in ['H', ' '])
                      then
                        begin
                          If not HeaderPrinted
                            then
                              begin
                                PrintSectionHeader(Sender, 'C', LineNo);
                                HeaderPrinted := True;
                              end;

                          If not SubHeaderPrinted
                            then
                              begin
                                PrintSchoolSubheader(Sender, 'H', PrintClassAmounts, LineNo);
                                SubheaderPrinted := True;
                              end;

                          PrintOneSchoolTotal(Sender, 'H', SchoolCodeDescList,
                                              RTSchoolCodeTotalsPtr(SchoolTotalsList[I])^,
                                              False, LineNo);

                            {Do we need to go to a new page?}
                            {FXX04231998-9: Instead of print the roll section hdr for
                                            the totals sections, print the section type.}

                          If ((NumLinesPerPage - LineNo) < LinesAtBottom)
                            then
                              begin
                                StartNewPage(Sender, SectionType, SwisCode,
                                             TaxRollYear, SwisCodeDescList,
                                             PageNo, LineNo);

                                PrintTotalsPageSubheader(Sender, SectionType, LineNo);

                                HeaderPrinted := False;
                                SubheaderPrinted := False;

                              end;  {If (LinesLeft < 4)}

                          UpdateSchoolTaxTotals(RTSchoolCodeTotalsPtr(SchoolTotalsList[I])^,
                                                TempSchoolTotalRec);

                        end;  {If (RTSchoolCodeTotalsPtr(SchoolTotalsList[I])^.HomesteadCode in ['H', ' '])}

                    {Make sure that if we had to switch pages between
                     the details and the total line that we print the headers
                     again.}

                  If not HeaderPrinted
                    then
                      begin
                        PrintSectionHeader(Sender, 'C', LineNo);
                        HeaderPrinted := True;
                      end;

                  If not SubHeaderPrinted
                    then PrintSchoolSubheader(Sender, 'H', PrintClassAmounts, LineNo);

                    {Print the totals for this subsection.}

                  Println('');
                  PrintOneSchoolTotal(Sender, 'H',
                                      SchoolCodeDescList,
                                      TempSchoolTotalRec,
                                      True, LineNo);

                end;  {else of If (NumHomestead = 0)}

          end;  {If (SectionType <> 'R')}

        {Now the non-homestead part, if these are not roll section totals.}

      If PrintClassAmounts
        then
          begin
            SubheaderPrinted := False;

              {Initialize the temporary record for the totals for this
               subsection.}

            with TempSchoolTotalRec do
              begin
                ParcelCount := 0;
                PartCount := 0;
                LandValue := 0;
                AssessedValue := 0;
                SchoolTaxable := 0;
                RelevyCount := 0;
                SchoolRelevyAmt := 0;
                BasicSTARAmount := 0;
                EnhancedSTARAmount := 0;
                BasicSTARCount := 0;
                EnhancedSTARCount := 0;

              end;  {with TempSchoolTotalRec do}

            If (NumNonhomestead = 0)
              then
                begin
                  Println('');
                  PrintSectionHeader(Sender, 'C', LineNo);
                  PrintSchoolSubheader(Sender, 'N', PrintClassAmounts, LineNo);
                  ClearTabs;
                  SetTab(4.5, pjCenter, 5.0, 0, BOXLINENONE, 0);   {HDR}
                  Println(#9 + 'NO TOTALS AT THIS LEVEL');
                  Println('');
                end
              else
                begin
                  If ExtractToExcel
                    then Writeln(ExtractFile, ',Non-Homestead Totals');

                  For I := 0 to (SchoolTotalsList.Count - 1) do
                    If (RTSchoolCodeTotalsPtr(SchoolTotalsList[I])^.HomesteadCode[1] = 'N')
                      then
                        begin
                          If not HeaderPrinted
                            then
                              begin
                                PrintSectionHeader(Sender, 'C', LineNo);
                                HeaderPrinted := True;
                              end;

                          If not SubHeaderPrinted
                            then
                              begin
                                PrintSchoolSubheader(Sender, 'N', PrintClassAmounts, LineNo);
                                SubheaderPrinted := True;
                              end;

                          PrintOneSchoolTotal(Sender, 'N',
                                              SchoolCodeDescList,
                                              RTSchoolCodeTotalsPtr(SchoolTotalsList[I])^,
                                              False, LineNo);

                            {Do we need to go to a new page?}

                          If ((NumLinesPerPage - LineNo) < LinesAtBottom)
                            then
                              begin
                                StartNewPage(Sender, SectionType, SwisCode,
                                             TaxRollYear, SwisCodeDescList,
                                             PageNo, LineNo);

                                PrintTotalsPageSubheader(Sender, SectionType, LineNo);

                                HeaderPrinted := False;
                                SubheaderPrinted := False;

                              end;  {If (LinesLeft < 4)}

                          UpdateSchoolTaxTotals(RTSchoolCodeTotalsPtr(SchoolTotalsList[I])^,
                                                 TempSchoolTotalRec);

                        end;  {If (RTSchoolCodeTotalsPtr(SchoolTotalsList[I])^.HomesteadCode in ['N'])}

                    {Make sure that if we had to switch pages between
                     the details and the total line that we print the headers
                     again.}

                  If not HeaderPrinted
                    then
                      begin
                        PrintSectionHeader(Sender, 'C', LineNo);
                        HeaderPrinted := True;
                      end;

                  If not SubHeaderPrinted
                    then PrintSchoolSubheader(Sender, 'N', PrintClassAmounts, LineNo);

                    {Print the totals for this subsection.}

                  Println('');
                  PrintOneSchoolTotal(Sender, 'N',
                                      SchoolCodeDescList,
                                      TempSchoolTotalRec, True, LineNo);

                end;  {else of If (NumNonhomestead = 0)}

              end;  {If (SectionType <> 'R')}

        {Finally, do the overall totals.}

      SubheaderPrinted := False;

      OverallSchoolTotalsList := TList.Create;
      CombineSchoolTotals(SchoolTotalsList, OverallSchoolTotalsList);

      If (PrintClassAmounts and
          ExtractToExcel)
        then Writeln(ExtractFile, ',Overall Totals');


        {Initialize the temporary record for the totals for this
         subsection.}

      with TempSchoolTotalRec do
        begin
          ParcelCount := 0;
          PartCount := 0;
          LandValue := 0;
          AssessedValue := 0;
          SchoolTaxable := 0;
          RelevyCount := 0;
          SchoolRelevyAmt := 0;
          BasicSTARAmount := 0;
          EnhancedSTARAmount := 0;
          BasicSTARCount := 0;
          EnhancedSTARCount := 0;

        end;  {with TempSchoolTotalRec do}

        {FXX04272004-1(2.07l3): Need to make sure not to cut the part count in half for the
                                school totals.}

      If PrintClassAmounts
        then TempSubheaderType := 'H'
        else TempSubheaderType := ' ';

      If (OverallSchoolTotalsList.Count = 0)
        then
          begin
            Println('');
            PrintSectionHeader(Sender, 'C', LineNo);
            PrintSchoolSubheader(Sender, SectionType, PrintClassAmounts, LineNo);
            ClearTabs;
            SetTab(4.5, pjCenter, 5.0, 0, BOXLINENONE, 0);   {HDR}
            Println(#9 + 'NO TOTALS AT THIS LEVEL');
            Println('');
          end
        else
          begin
            For I := 0 to (OverallSchoolTotalsList.Count - 1) do
              begin
                  {Do we need to go to a new page?}

                with Sender as TBaseReport do
                If (LinesLeft < LinesAtBottom)
                  then
                    begin
                      StartNewPage(Sender, SectionType, SwisCode,
                                   TaxRollYear, SwisCodeDescList,
                                   PageNo, LineNo);

                      PrintTotalsPageSubheader(Sender, SectionType, LineNo);

                      HeaderPrinted := False;
                      SubheaderPrinted := False;

                    end;  {If (LinesLeft < 4)}

                If not HeaderPrinted
                  then
                    begin
                      PrintSectionHeader(Sender, 'C', LineNo);
                      HeaderPrinted := True;
                    end;

                If not SubHeaderPrinted
                  then
                    begin
                      PrintSchoolSubHeader(Sender, SectionType, PrintClassAmounts, LineNo);
                      SubheaderPrinted := True;
                    end;

                PrintOneSchoolTotal(Sender, TempSubheaderType,
                                    SchoolCodeDescList,
                                    RTSchoolCodeTotalsPtr(OverallSchoolTotalsList[I])^,
                                    False, LineNo);

                UpdateSchoolTaxTotals(RTSchoolCodeTotalsPtr(OverallSchoolTotalsList[I])^,
                                      TempSchoolTotalRec);

              end;  {For I := 0 to OverallSchoolTotalsList do}

              {Make sure that if we had to switch pages between
               the details and the total line that we print the headers
               again.}

                  {Do we need to go to a new page?}

                with Sender as TBaseReport do
                If (LinesLeft < LinesAtBottom)
                  then
                    begin
                      StartNewPage(Sender, SectionType, SwisCode,
                                   TaxRollYear, SwisCodeDescList,
                                   PageNo, LineNo);

                      PrintTotalsPageSubheader(Sender, SectionType, LineNo);

                      HeaderPrinted := False;
                      SubheaderPrinted := False;

                    end;  {If (LinesLeft < 4)}

            If not HeaderPrinted
              then PrintSectionHeader(Sender, 'C', LineNo);

            If not SubHeaderPrinted
              then PrintSchoolSubheader(Sender, SectionType, PrintClassAmounts, LineNo);

              {Print the totals for this subsection.}

            Println('');
            PrintOneSchoolTotal(Sender, TempSubheaderType,
                                SchoolCodeDescList,
                                TempSchoolTotalRec, True, LineNo);

         end;  {else of SchoolTotRecord}

      FreeTList(OverallSchoolTotalsList, SizeOf(RTSchoolTotals));

    end;  {with Sender as TBaseReport do}

end;  {PrintSchoolTotals}

{=======================================================================}
{=================   EXEMPTION TOTALS  =================================}
{=======================================================================}
Function FoundEXRecord(    EXTotalsList : TList;
                           _EXCode : String;
                           _HomesteadCode : String;
                       var I : Integer) : Boolean;

{Search through the totals list for this EX code,
 and homestead code.}

var
  J : Integer;

begin
  Result := False;

  For J := 0 to (EXTotalsList.Count - 1) do
    with RTEXCodeTotalsPtr(EXTotalsList[J])^ do
      If ((Take(5, EXCode) = Take(5, _EXCode)) and
          (Take(1, HomesteadCode) = Take(1, _HomesteadCode)))
        then
          begin
            Result := True;
            I := J;
          end;

end;  {FoundEXRecord}

{=======================================================================}
Procedure CombineEXTotals(EXTotalsList,  {List with totals broken down into hstd, nonhstd.}
                          OverallTotalsList : TList);  {No hstd\nonhstd breakdown.}

{The totals entries in the EXTotalsList are broken down into homestead and
 nonhomestead, so we want to combine them for the overall totals. To do
 this, we will take the entries from the EXTotalsList and put them into the
 overall totals list, disregarding the homestead code.}

var
  I, J : Integer;
  EXTotalsPtr : RTEXCodeTotalsPtr;

begin
    {FXX07142004-4(2.08): Don't forget to load the Part totals.}

  For I := 0 to (EXTotalsList.Count - 1) do
    with RTEXCodeTotalsPtr(EXTotalsList[I])^ do
      If FoundEXRecord(OverallTotalsList, EXCode,
                       ' ', J)  {Don't use hstd code as a key.}
        then
          begin
            RTEXCodeTotalsPtr(OverallTotalsList[J])^.ParcelCount :=
                     RTEXCodeTotalsPtr(OverallTotalsList[J])^.ParcelCount + ParcelCount;
            RTEXCodeTotalsPtr(OverallTotalsList[J])^.PartCount :=
                     RTEXCodeTotalsPtr(OverallTotalsList[J])^.PartCount + PartCount;
            RTEXCodeTotalsPtr(OverallTotalsList[J])^.CountyExAmount :=
                     RTEXCodeTotalsPtr(OverallTotalsList[J])^.CountyExAmount + CountyExAmount;
            RTEXCodeTotalsPtr(OverallTotalsList[J])^.TownExAmount :=
                     RTEXCodeTotalsPtr(OverallTotalsList[J])^.TownExAmount + TownExAmount;
            RTEXCodeTotalsPtr(OverallTotalsList[J])^.VillageExAmount :=
                     RTEXCodeTotalsPtr(OverallTotalsList[J])^.VillageExAmount + VillageExAmount;
            RTEXCodeTotalsPtr(OverallTotalsList[J])^.SchoolExAmount :=
                     RTEXCodeTotalsPtr(OverallTotalsList[J])^.SchoolExAmount + SchoolExAmount;

          end
        else
          begin
            New(EXTotalsPtr);   {get new pptr for tlist array}

            EXTotalsPtr^.SwisCode := SwisCode;
            EXTotalsPtr^.ParcelCount := ParcelCount;
            EXTotalsPtr^.PartCount := PartCount;
            EXTotalsPtr^.HomesteadCode := ' ';  {Blank out hstd code.}
            EXTotalsPtr^.EXCode := EXCode;
            EXTotalsPtr^.CountyExAmount := CountyEXAmount;
            EXTotalsPtr^.TownExAmount := TownEXAmount;
            EXTotalsPtr^.VillageExAmount := VillageEXAmount;
            EXTotalsPtr^.SchoolExAmount := SchoolEXAmount;

            OverallTotalsList.Add(EXTotalsPtr);

          end;  {else of If FoundEXRecord(OverallTotalsList, EXCode, ExtCode, CMFlag,}

end;  {CombineEXTotals}

{=======================================================================}
Procedure UpdateEXTaxTotals(    SourceEXTotalsRec : RTEXCodeTotals;
                            var TempEXTotalRec : RTEXCodeTotals);

{Update the running totals in the TempEXTotalRec from the source
 rec.}

begin
  with TempEXTotalRec do
    begin
      ParcelCount := ParcelCount + SourceEXTotalsRec.ParcelCount;

        {FXX07142004-4(2.08): Don't forget to load the Part totals.}

      PartCount := PartCount + SourceEXTotalsRec.PartCount;
      CountyExAmount := CountyExAmount + SourceEXTotalsRec.CountyExAmount;
      TownExAmount := TownExAmount + SourceEXTotalsRec.TownExAmount;
      SchoolExAmount := SchoolExAmount + SourceEXTotalsRec.SchoolExAmount;
      VillageExAmount := VillageExAmount + SourceEXTotalsRec.VillageExAmount;

    end;  {with TempEXTotalRec do}

end;  {UpdateEXTaxTotals}

{=======================================================================}
Procedure PrintEXSubheader(    Sender : TObject;  {Report printer or filer object}
                               SubheaderType : Char;  {(H)std, (N)onhstd, (S)wis, S(c)hool, (R)S, (G)rand}
                               IsAssessingVillage : Boolean;  {Should we have a village column?}
                           var LineNo : Integer);

{Print the individual EX totals section header and set the tabs for the
 EX amounts columns.}

begin
  with Sender as TBaseReport do
    begin
        {Roll section totals do not breakdown by hEXt\nonhstd so
         the following two lines are not needed.}

      If (SubheaderType <> 'R')
        then PrintSectionSubheader(Sender, SubheaderType, LineNo);

      ClearTabs;
      SetTab(TL1, pjLeft, TL1W, 0, BOXLINENONE, 0);   {CODE}
      SetTab(TL2, pjLeft, TL2W, 0, BOXLINENONE, 0);   {Desc}
      SetTab(TL3, pjCenter, TL3W, 0, BOXLINENONE, 0);   {PRCL CNT}
      SetTab(TL4, pjCenter, TL4W, 0, BOXLINENONE, 0);   {County Amount}
      SetTab(TL5, pjCenter, TL5W, 0, BOXLINENONE, 0);   {City Amount}
      SetTab(TL6, pjCenter, TL6W, 0, BOXLINENONE, 0);   {School Amount}
      SetTab(TL7, pjCenter, TL7W, 0, BOXLINENONE, 0);   {Village Amount}

      Println('');
      Println(#9 +
              #9 +
              #9 + 'TOTAL');

         {FXX12291997-7: Only print the relevant exemption amounts.}
         {CHG01192004-1(2.08): Let each municipality decide what roll totals to display.}

       Print(#9 + 'CODE' +
             #9 + 'DESCRIPTION' +
             #9 + 'PARCELS');

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

       LineNo := LineNo + 3;

         {If this is a homestead or nonhomestead section,
          print that this is the total number of parcels and parts.}

       If (SubheaderType in ['H', 'N'])
         then
           begin
             Println(#9 + #9 + #9 + '& PARTS');
             LineNo := LineNo + 1;
           end;

       {FXX12291997-2: Print a blank line between the header and the start
                       of the information.}

      Println('');
      LineNo := LineNo + 1;

    end;  {with Sender as TBaseReport do}

end;  {PrintEXSubheader}

{=======================================================================}
Procedure PrintOneEXTotal(    Sender : TObject;  {Report printer or filer object}
                              SubheaderType : Char;  {(H)std, (N)onhstd, (S)wis, S(c)hool, (R)S, (G)rand}
                              EXCodeDescList : TList;
                              EXTotalsRec : RTEXCodeTotals;
                              IsTotalRecord : Boolean;  {Is this a 'TOTAL' line?}
                              IsAssessingVillage : Boolean;
                          var LineNo : Integer);

{Print one special district total.}

begin
  with Sender as TBaseReport do
    begin
        {Reset the tabs}

      ClearTabs;
      SetTab(TL1, pjLeft, TL1W, 0, BOXLINENONE, 0);   {CODE}
      SetTab(TL2, pjLeft, TL2W, 0, BOXLINENONE, 0);   {Desc}
      SetTab(TL3, pjRight, TL3W, 0, BOXLINENONE, 0);   {PRCL CNT}
      SetTab(TL4, pjRight, TL4W, 0, BOXLINENONE, 0);   {1st Amount}
      SetTab(TL5, pjRight, TL5W, 0, BOXLINENONE, 0);   {2nd Amount}
      SetTab(TL6, pjRight, TL6W, 0, BOXLINENONE, 0);   {3rd Amount}
      SetTab(TL7, pjRight, TL7W, 0, BOXLINENONE, 0);   {4th Amount}

      with EXTotalsRec do
        begin
          If IsTotalRecord
            then Print(#9 + #9 + 'TOTAL')
            else Print(#9 + EXCode +
                       #9 + Take(15, GetDescriptionFromList(EXCode, EXCodeDescList)));

            {FXX07142004-3(2.08): Include the PartCount.}

          Print(#9 + IntToStr(ParcelCount + PartCount));

             {CHG01192004-1(2.08): Let each municipality decide what roll totals to display.}

          If (rtdCounty in GlblRollTotalsToShow)
            then Print(#9 + FormatFloat(NoDecimalDisplay_BlankZero, CountyExAmount))
            else Print(#9);

          If (rtdMunicipal in GlblRollTotalsToShow)
            then Print(#9 + FormatFloat(NoDecimalDisplay_BlankZero, TownExAmount))
            else Print(#9);

          If (rtdSchool in GlblRollTotalsToShow)
            then Print(#9 + FormatFloat(NoDecimalDisplay_BlankZero, SchoolExAmount))
            else Print(#9);

          If (rtdVillageReceivingPartialRoll in GlblRollTotalsToShow)
            then Print(#9 + FormatFloat(NoDecimalDisplay_BlankZero, VillageExAmount));

          Println('');

          If ExtractToExcel
            then
              begin
                If IsTotalRecord
                  then Write(ExtractFile, 'TOTAL,')
                  else Write(ExtractFile, EXCode +
                                          FormatExtractField(GetDescriptionFromList(EXCode, EXCodeDescList)));

                Write(ExtractFile, FormatExtractField(IntToStr(ParcelCount + PartCount)));

                If (rtdCounty in GlblRollTotalsToShow)
                  then Write(ExtractFile, FormatExtractField(FormatFloat(NoDecimalDisplay_BlankZero, CountyExAmount)));

                If (rtdMunicipal in GlblRollTotalsToShow)
                  then Write(ExtractFile, FormatExtractField(FormatFloat(NoDecimalDisplay_BlankZero, TownExAmount)));

                If (rtdSchool in GlblRollTotalsToShow)
                  then Write(ExtractFile, FormatExtractField(FormatFloat(NoDecimalDisplay_BlankZero, SchoolExAmount)));

                If (rtdVillageReceivingPartialRoll in GlblRollTotalsToShow)
                  then Write(ExtractFile, FormatExtractField(FormatFloat(NoDecimalDisplay_BlankZero, VillageExAmount)));

                Writeln(ExtractFile);

              end;  {If ExtractToExcel}

        end;  {with EXTotalsRec do}

    end;  {with Sender as TBaseReport do}

  LineNo := LineNo + 1;

end;  {PrintOneEXTotal}

{=================================================================}
Procedure SortExemptionList(EXTotalsList : TList);

{FXX04231998-11: Sort the exemption totals list into the proper order.}

var
  OldKey, NewKey : String;
  I, J : Integer;
  TempPtr : RTEXCodeTotalsPtr;

begin
  For I := 0 to (EXTotalsList.Count - 1) do
    begin
      OldKey := RTEXCodeTotalsPtr(EXTotalsList[I])^.EXCode;

      For J := (I + 1) to (EXTotalsList.Count - 1) do
        begin
          NewKey := RTEXCodeTotalsPtr(EXTotalsList[J])^.EXCode;

          If (NewKey < OldKey)
            then
              begin
                TempPtr := EXTotalsList[I];
                EXTotalsList[I] := EXTotalsList[J];
                EXTotalsList[J] := TempPtr;
                OldKey := NewKey;

              end;  {If (NewKey < OldKey)}

        end;  {For J := (I + 1) to (EXTotalsList.Count - 1) do}

    end;  {For I := 0 to (EXTotalsList.Count - 1) do}

end;  {SortExemptionList}

{=======================================================================}
Procedure PrintExemptionTotalsSection(    Sender : TObject;  {Report printer or filer object}
                                          EXTotalsList : TList;
                                          TaxRollYear : String;
                                          SwisCode : String;
                                          EXCodeDescList,
                                          SwisCodeDescList : TList;
                                          PrintClassAmounts : Boolean;
                                          SectionType : Char;
                                          IsAssessingVillage : Boolean;
                                      var PageNo,
                                          LineNo : Integer);

{Print the exemption totals in the TLists.}
{CHG03182003-1(2.06q1): Print village totals if this swis is an assessing village.}

var
  I, NumHomestead, NumNonhomestead : Integer;
  HeaderPrinted, SubheaderPrinted : Boolean;
  OverallEXTotalsList : TList;
  TempEXTotalRec : RTEXCodeTotals;

begin
  HeaderPrinted := False;
  NumHomestead := 0;
  NumNonhomestead := 0;

  For I := 0 to (EXTotalsList.Count - 1) do
    with RTEXCodeTotalsPtr(EXTotalsList[I])^ do
      If (HomesteadCode = 'N')
        then NumNonhomestead := NumNonhomestead + 1
        else NumHomestead := NumHomestead + 1;

    {FXX04231998-11: Sort the exemption totals list into the proper order.}

  SortExemptionList(EXTotalsList);

  If FirstPageOfReport
    then
      begin
        PrintHeader(Sender, SectionType, SwisCode,
                    TaxRollYear, SwisCodeDescList,
                    PageNo, LineNo);
        FirstPageOfReport := False;
      end
    else StartNewPage(Sender, SectionType, SwisCode,
                      TaxRollYear, SwisCodeDescList,
                      PageNo, LineNo);

    {CHG02012004-5(2.08): Option to print to Excel.}

  If ExtractToExcel
    then
      begin
        Writeln(ExtractFile);
        Writeln(ExtractFile, 'Exemption Totals');
        If PrintClassAmounts
          then Writeln(ExtractFile, ',Homestead Totals');
        Write(ExtractFile, 'EX Code,',
                           'Description,',
                           'Parcel Count');

        If (rtdCounty in GlblRollTotalsToShow)
          then Write(ExtractFile, ',COUNTY');

        If (rtdMunicipal in GlblRollTotalsToShow)
          then Write(ExtractFile, ',' + UpcaseStr(GetMunicipalityTypeName(GlblMunicipalityType)));

        If (rtdSchool in GlblRollTotalsToShow)
          then Write(ExtractFile, ',SCHOOL');

        If (rtdVillageReceivingPartialRoll in GlblRollTotalsToShow)
          then Write(ExtractFile, ',VILLAGE');

        Writeln(ExtractFile);

      end;  {If ExtractToExcel}

  with Sender as TBaseReport do
    begin
        {First homestead part, but only if this is not a roll section summary.
         Note that we print the header and subheader only if there is an
         entry.}

      If PrintClassAmounts
        then
          begin
            SubheaderPrinted := False;

              {Initialize the temporary record for the totals for this
               subsection.}

            with TempEXTotalRec do
              begin
                ParcelCount := 0;
                PartCount := 0;
                CountyExAmount := 0;
                TownExAmount := 0;
                SchoolExAmount := 0;
                VillageExAmount := 0;

              end;  {with TempEXTotalRec do}

            If (NumHomestead = 0)
              then
                begin
                  Println('');
                  PrintSectionHeader(Sender, 'X', LineNo);
                  PrintEXSubheader(Sender, 'H', IsAssessingVillage, LineNo);
                  ClearTabs;
                  SetTab(4.5, pjCenter, 5.0, 0, BOXLINENONE, 0);   {HDR}
                  Println(#9 + 'NO EXEMPTIONS AT THIS LEVEL');
                  Println('');
                end
              else
                begin
                  For I := 0 to (EXTotalsList.Count - 1) do
                    If (RTEXCodeTotalsPtr(EXTotalsList[I])^.HomesteadCode[1] in ['H', ' '])
                      then
                        begin
                          If not HeaderPrinted
                            then
                              begin
                                PrintSectionHeader(Sender, 'X', LineNo);
                                HeaderPrinted := True;
                              end;

                          If not SubHeaderPrinted
                            then
                              begin
                                PrintEXSubheader(Sender, 'H', IsAssessingVillage, LineNo);
                                SubheaderPrinted := True;
                              end;

                          PrintOneEXTotal(Sender, 'H', EXCodeDescList,
                                          RTEXCodeTotalsPtr(EXTotalsList[I])^,
                                          False, IsAssessingVillage, LineNo);

                            {Do we need to go to a new page?}
                            {FXX04231998-9: Instead of print the roll section hdr for
                                            the totals sections, print the section type.}

                          If ((NumLinesPerPage - LineNo) < LinesAtBottom)
                            then
                              begin
                                StartNewPage(Sender, SectionType, SwisCode,
                                             TaxRollYear, SwisCodeDescList,
                                             PageNo, LineNo);

                                PrintTotalsPageSubheader(Sender, SectionType, LineNo);

                                HeaderPrinted := False;
                                SubheaderPrinted := False;

                              end;  {If (LinesLeft < 4)}

                          UpdateEXTaxTotals(RTEXCodeTotalsPtr(EXTotalsList[I])^,
                                            TempEXTotalRec);

                        end;  {If (RTEXCodeTotalsPtr(EXTotalsList[I])^.HomesteadCode in ['H', ' '])}

                    {Make sure that if we had to switch pages between
                     the details and the total line that we print the headers
                     again.}

                  If not HeaderPrinted
                    then
                      begin
                        PrintSectionHeader(Sender, 'X', LineNo);
                        HeaderPrinted := True;
                      end;

                  If not SubHeaderPrinted
                    then PrintEXSubheader(Sender, 'H', IsAssessingVillage, LineNo);

                    {Print the totals for this subsection.}

                  Println('');
                  PrintOneEXTotal(Sender, 'H', EXCodeDescList,
                                  TempEXTotalRec, True, IsAssessingVillage, LineNo);

                end;  {else of If (NumHomestead = 0)}

          end;  {If (SectionType <> 'R')}

        {Now the non-homestead part, if these are not roll section totals.}

      If PrintClassAmounts
        then
          begin
            SubheaderPrinted := False;

              {Initialize the temporary record for the totals for this
               subsection.}

            with TempEXTotalRec do
              begin
                ParcelCount := 0;
                PartCount := 0;
                CountyExAmount := 0;
                TownExAmount := 0;
                SchoolExAmount := 0;
                VillageExAmount := 0;

              end;  {with TempEXTotalRec do}

            If (NumNonhomestead = 0)
              then
                begin
                  Println('');
                  PrintSectionHeader(Sender, 'X', LineNo);
                  PrintEXSubheader(Sender, 'N', IsAssessingVillage, LineNo);
                  ClearTabs;
                  SetTab(4.5, pjCenter, 5.0, 0, BOXLINENONE, 0);   {HDR}
                  Println(#9 + 'NO EXEMPTIONS AT THIS LEVEL');
                  Println('');
                end
              else
                begin
                  If ExtractToExcel
                    then Writeln(ExtractFile, ',Non-Homestead Totals');
                  For I := 0 to (EXTotalsList.Count - 1) do
                    If (RTEXCodeTotalsPtr(EXTotalsList[I])^.HomesteadCode[1] = 'N')
                      then
                        begin
                          If not HeaderPrinted
                            then
                              begin
                                PrintSectionHeader(Sender, 'X', LineNo);
                                HeaderPrinted := True;
                              end;

                          If not SubHeaderPrinted
                            then
                              begin
                                PrintEXSubheader(Sender, 'N', IsAssessingVillage, LineNo);
                                SubheaderPrinted := True;
                              end;

                          PrintOneEXTotal(Sender, 'N', EXCodeDescList,
                                          RTEXCodeTotalsPtr(EXTotalsList[I])^,
                                          False, IsAssessingVillage, LineNo);

                            {Do we need to go to a new page?}

                          If ((NumLinesPerPage - LineNo) < LinesAtBottom)
                            then
                              begin
                                StartNewPage(Sender, SectionType, SwisCode,
                                             TaxRollYear, SwisCodeDescList,
                                             PageNo, LineNo);

                                PrintTotalsPageSubheader(Sender, SectionType, LineNo);

                                HeaderPrinted := False;
                                SubheaderPrinted := False;

                              end;  {If (LinesLeft < 4)}

                          UpdateEXTaxTotals(RTEXCodeTotalsPtr(EXTotalsList[I])^,
                                            TempEXTotalRec);

                        end;  {If (RTEXCodeTotalsPtr(EXTotalsList[I])^.HomesteadCode in ['N'])}

                    {Make sure that if we had to switch pages between
                     the details and the total line that we print the headers
                     again.}

                  If not HeaderPrinted
                    then
                      begin
                        PrintSectionHeader(Sender, 'X', LineNo);
                        HeaderPrinted := True;
                      end;

                  If not SubHeaderPrinted
                    then PrintEXSubheader(Sender, 'N', IsAssessingVillage, LineNo);

                    {Print the totals for this subsection.}

                  Println('');
                  PrintOneEXTotal(Sender, 'N', EXCodeDescList,
                                  TempEXTotalRec, True, IsAssessingVillage, LineNo);

                end;  {else of If (NumNonhomestead = 0)}

              end;  {If (SectionType <> 'R')}

        {Finally, do the overall totals.}

      SubheaderPrinted := False;

      OverallEXTotalsList := TList.Create;
      CombineEXTotals(EXTotalsList, OverallEXTotalsList);

        {FXX04231998-11: Sort the exemption totals list into the proper order.}

      SortExemptionList(OverallEXTotalsList);

       {Initialize the temporary record for the totals for this
        subsection.}

      If (PrintClassAmounts and
          ExtractToExcel)
        then Writeln(ExtractFile, ',Overall Totals');

      with TempEXTotalRec do
        begin
          ParcelCount := 0;
          PartCount := 0;
          CountyExAmount := 0;
          TownExAmount := 0;
          SchoolExAmount := 0;
          VillageExAmount := 0;

        end;  {with TempEXTotalRec do}

      If (OverallEXTotalsList.Count = 0)
        then
          begin
            Println('');
            PrintSectionHeader(Sender, 'X', LineNo);
            PrintEXSubheader(Sender, SectionType, IsAssessingVillage, LineNo);
            ClearTabs;
            SetTab(4.5, pjCenter, 5.0, 0, BOXLINENONE, 0);   {HDR}
            Println(#9 + 'NO EXEMPTIONS AT THIS LEVEL');
            Println('');
          end
        else
          begin
            For I := 0 to (OverallEXTotalsList.Count - 1) do
              begin
                  {Do we need to go to a new page?}

                with Sender as TBaseReport do
                If (LinesLeft < LinesAtBottom)
                  then
                    begin
                      StartNewPage(Sender, SectionType, SwisCode,
                                   TaxRollYear, SwisCodeDescList,
                                   PageNo, LineNo);

                      PrintTotalsPageSubheader(Sender, SectionType, LineNo);

                      HeaderPrinted := False;
                      SubheaderPrinted := False;

                    end;  {If (LinesLeft < 4)}

                If not HeaderPrinted
                  then
                    begin
                      PrintSectionHeader(Sender, 'X', LineNo);
                      HeaderPrinted := True;
                    end;

                If not SubHeaderPrinted
                  then
                    begin
                      PrintEXSubHeader(Sender, SectionType, IsAssessingVillage, LineNo);
                      SubheaderPrinted := True;
                    end;

                PrintOneEXTotal(Sender, ' ', EXCodeDescList,
                                RTEXCodeTotalsPtr(OverallEXTotalsList[I])^,
                                False, IsAssessingVillage, LineNo);

                UpdateEXTaxTotals(RTEXCodeTotalsPtr(OverallEXTotalsList[I])^,
                                  TempEXTotalRec);

              end;  {For I := 0 to OverallEXTotalsList do}

              {Make sure that if we had to switch pages between
               the details and the total line that we print the headers
               again.}

                  {Do we need to go to a new page?}

                with Sender as TBaseReport do
                If (LinesLeft < LinesAtBottom)
                  then
                    begin
                      StartNewPage(Sender, SectionType, SwisCode,
                                   TaxRollYear, SwisCodeDescList,
                                   PageNo, LineNo);

                      PrintTotalsPageSubheader(Sender, SectionType, LineNo);

                      HeaderPrinted := False;
                      SubheaderPrinted := False;

                    end;  {If (LinesLeft < 4)}

            If not HeaderPrinted
              then PrintSectionHeader(Sender, 'X', LineNo);

            If not SubHeaderPrinted
              then PrintEXSubheader(Sender, SectionType, IsAssessingVillage, LineNo);

              {Print the totals for this subsection.}

            Println('');
            PrintOneEXTotal(Sender, SectionType, EXCodeDescList,
                            TempEXTotalRec, True, IsAssessingVillage, LineNo);

          end;  {else of If (OverallEXTotalsList.Count = 0)}

      FreeTList(OverallEXTotalsList, SizeOf(RTEXCodeTotals));

    end;  {with Sender as TBaseReport do}

end;  {PrintExemptionTotalsSection}

{=======================================================================}
{=================   SPECIAL DISTRICT TOTALS  ==========================}
{=======================================================================}
Function FoundSDRecord(    SDTotalsList : TList;
                           _SDCode : String;
                           _ExtCode : String;
                           _CMFlag : String;
                           _HomesteadCode : String;
                           CombineRollSections : Boolean;
                       var I : Integer) : Boolean;

{Search through the totals list for this SD code, ext code,
 and homestead code.}

var
  J : Integer;

begin
  Result := False;

      {FXX04231998-12: Need to use roll section in key for totals recs, too.}
      {FXX04291998-6: Don't need to use roll section as criteria when showing
                      totals in SD sections.}
      {CHG09122004-1(2.8.0.11): Add homestead split to SD Calcs}

  For J := 0 to (SDTotalsList.Count - 1) do
    with RTSDCodeTotalsPtr(SDTotalsList[J])^ do
      If ((Take(5, SDCode) = Take(5, _SDCode)) and
          (Take(2, ExtensionCode) = Take(2, _ExtCode)) and
          (Take(1, CCOMFlg) = Take(1, _CMFlag)) and
          ((not SplitDistrict) or
           (Take(1, HomesteadCode) = Take(1, _HomesteadCode))))
        then
          begin
            Result := True;
            I := J;
          end;

end;  {FoundSDRecord}

{=======================================================================}
Procedure CombineSDTotals(SDTotalsList,  {List with totals broken down into hstd, nonhstd.}
                          OverallTotalsList : TList);  {No hstd\nonhstd breakdown.}

{The totals entries in the SDTotalsList are broken down into homestead and
 nonhomestead, so we want to combine them for the overall totals. To do
 this, we will take the entries from the SDTotalsList and put them into the
 overall totals list, disregarding the homestead code.}

var
  I, J : Integer;
  TempPtr, SDTotalsPtr : RTSDCodeTotalsPtr;
  MainKey, NewKey : String;

begin
   {FXX04231998-12: Need to use roll section in key for totals recs, too.}

  For I := 0 to (SDTotalsList.Count - 1) do
    with RTSDCodeTotalsPtr(SDTotalsList[I])^ do
      If FoundSDRecord(OverallTotalsList, SDCode, ExtensionCode, CCOMFlg,
                       HomesteadCode, True, J)  {Don't use hstd code as a key.}
        then
          begin
            RTSDCodeTotalsPtr(OverallTotalsList[J])^.ParcelCount :=
                     RTSDCodeTotalsPtr(OverallTotalsList[J])^.ParcelCount + ParcelCount;
            RTSDCodeTotalsPtr(OverallTotalsList[J])^.TaxableValue :=
                     RTSDCodeTotalsPtr(OverallTotalsList[J])^.TaxableValue + TaxableValue;
            RTSDCodeTotalsPtr(OverallTotalsList[J])^.AssessedValue :=
                     RTSDCodeTotalsPtr(OverallTotalsList[J])^.AssessedValue + AssessedValue;

          end
        else
          begin
            New(SDTotalsPtr);   {get new pptr for tlist array}

            SDTotalsPtr^.SwisCode := SwisCode;
            SDTotalsPtr^.SDCode := SDCode;
            SDTotalsPtr^.ExtensionCode := ExtensionCode;
            SDTotalsPtr^.CCOMFlg := CCOMFlg;
            SDTotalsPtr^.ParcelCount := ParcelCount;
            SDTotalsPtr^.TaxableValue := TaxableValue;
            SDTotalsPtr^.AssessedValue := AssessedValue;

              {CHG09122004-1(2.8.0.11): Add homestead split to SD Calcs}

            SDTotalsPtr^.HomesteadCode := HomesteadCode;
            SDTotalsPtr^.SplitDistrict := SplitDistrict;

            OverallTotalsList.Add(SDTotalsPtr);

          end;  {else of If FoundSDRecord(OverallTotalsList, SDCode, ExtCode, CMFlag,}

    {FXX01021998-12: Sort the overall SD totals by SD code\ Extension.}

  For I := 0 to (OverallTotalsList.Count - 1) do
    begin
      with RTSDCodeTotalsPtr(OverallTotalsList[I])^ do
        MainKey := Take(5, SDCode) + Take(2, ExtensionCode);

      For J := (I + 1) to (OverallTotalsList.Count - 1) do
        begin
          with RTSDCodeTotalsPtr(OverallTotalsList[J])^ do
            NewKey := Take(5, SDCode) + Take(2, ExtensionCode);

          If (NewKey < MainKey)
            then
              begin
                TempPtr := OverallTotalsList[I];
                OverallTotalsList[I] := OverallTotalsList[J];
                OverallTotalsList[J] := TempPtr;
                MainKey := NewKey;

              end;  {If (NewKey < MainKey)}

        end;  {For J := (I + 1) to (OverallTotalsList.Count - 1) do}

    end;  {For I := 0 to (OverallTotalsList.Count - 1) do}

end;  {CombineSDTotals}

{=======================================================================}
Procedure UpdateSDTaxTotals(    SourceSDTotalsRec : RTSDCodeTotals;
                            var TempSDTotalRec : RTSDCodeTotals);

{Update the running totals in the TempSDTotalRec from the source
 rec.}

begin
  with TempSDTotalRec do
    begin
      ParcelCount := ParcelCount + SourceSDTotalsRec.ParcelCount;
      TaxableValue := TaxableValue + SourceSDTotalsRec.TaxableValue;

    end;  {with TempSDTotalRec do}

end;  {UpdateSDTaxTotals}

{=======================================================================}
Procedure PrintSDSubheader(    Sender : TObject;  {Report printer or filer object}
                               SubheaderType : Char;  {(H)std, (N)onhstd, (S)wis, S(c)hool, (R)S, (G)rand}
                           var LineNo : Integer);

{Print the individual SD totals section header and set the tabs for the
 SD amounts columns.}

begin
  with Sender as TBaseReport do
    begin
        {Roll section totals do not breakdown by hsdt\nonhstd so
         the following two lines are not needed.}

      If (SubheaderType <> 'R')
        then PrintSectionSubheader(Sender, SubheaderType, LineNo);

      ClearTabs;
      SetTab(TL1, pjLeft, TL1W, 0, BOXLINENONE, 0);   {CODE}
      SetTab(TL2, pjLeft, TL2W, 0, BOXLINENONE, 0);   {DIST NAME}
      SetTab(TL3, pjLeft, TL3W, 0, BOXLINENONE, 0);   {PRCL CNT}
      SetTab(TL4, pjLeft, TL4W, 0, BOXLINENONE, 0);   {EXT TYPE}
      SetTab(TL5, pjCenter, TL5W, 0, BOXLINENONE, 0);   {Assessed val}
      SetTab(TL6, pjCenter, TL6W, 0, BOXLINENONE, 0);   {Taxable val}

        {FXX01191998-7: Don't print tax rate or amt header for assessment
                        rolls.}

      Println('');
      Println(#9 + #9 +
              #9 + 'TOTAL' +
              #9 + 'EXTENSION' +
              #9 + 'ASSESSED' +
              #9 + 'TAXABLE');

       Println(#9 + 'CODE' +
               #9 + 'DISTRICT NAME' +
               #9 + 'PARCELS' +
               #9 + 'TYPE' +
               #9 + 'VALUE' +
               #9 + 'VALUE');

       LineNo := LineNo + 3;

      Println('');
      LineNo := LineNo + 1;

    end;  {with Sender as TBaseReport do}

end;  {PrintSDSubheader}

{=======================================================================}
Procedure PrintOneSDTotal(    Sender : TObject;  {Report printer or filer object}
                              SDCodeDescList,
                              SDExtCodeDescList : TList;
                              LastSDCode : String;  {What was the last SD code printed?}
                              SDTotalsRec : RTSDCodeTotals;
                          var LineNo : Integer);

{Print one special district total.}

begin
  with Sender as TBaseReport do
    begin
        {Reset the tabs}

      ClearTabs;
      SetTab(TL1, pjLeft, TL1W, 0, BOXLINENONE, 0);   {CODE}
      SetTab(TL2, pjLeft, TL2W, 0, BOXLINENONE, 0);   {DIST NAME}
      SetTab(TL3, pjRight, TL3W, 0, BOXLINENONE, 0);   {PRCL CNT}
      SetTab(TL4, pjLeft, TL4W, 0, BOXLINENONE, 0);   {EXT TYPE}
      SetTab(TL5, pjRight, TL5W, 0, BOXLINENONE, 0);   {Assessed VALUE}
      SetTab(TL6, pjRight, TL6W, 0, BOXLINENONE, 0);   {TAXABLE VALUE}

      with SDTotalsRec do
        begin
          If (SDCode = LastSDCode)
            then Print(#9 + #9 + #9)
            else Print(#9 + SDCode +
                       #9 + ANSIUpperCase(Take(18, GetDescriptionFromList(SDCode, SDCodeDescList))) +
                       #9 + FormatFloat(IntegerDisplay, ParcelCount));

          Print(#9 + Take(5, ANSIUpperCase(GetDescriptionFromList(ExtensionCode, SDExtCodeDescList))) +
                     ' ' + CCOMFlg);

            {CHG09122004-1(2.8.0.11): Add homestead split to SD Calcs}

          If (HomesteadCode <> '')
            then Print(' (' + HomesteadCode + ')');

          If (ExtensionCode = 'TO')
            then Println(#9 + FormatFloat(NoDecimalDisplay_BlankZero, AssessedValue) +
                         #9 + FormatFloat(NoDecimalDisplay_BlankZero, TaxableValue))
            else Println(#9 + FormatFloat(DecimalDisplay_BlankZero, AssessedValue) +
                         #9 + FormatFloat(DecimalDisplay_BlankZero, TaxableValue));

            {CHG02012004-5(2.08): Option to print to Excel.}

          If ExtractToExcel
            then
              begin
                Write(ExtractFile, SDCode +
                                   FormatExtractField(GetDescriptionFromList(SDCode, SDCodeDescList)),
                                   FormatExtractField(IntToStr(ParcelCount)),
                                   FormatExtractField(GetDescriptionFromList(ExtensionCode, SDExtCodeDescList) +
                                                      ' ' + CCOMFlg));

                If (ExtensionCode = 'TO')
                  then
                    begin
                      Write(ExtractFile, FormatExtractField(FormatFloat(NoDecimalDisplay_BlankZero, AssessedValue)));
                      Writeln(ExtractFile, FormatExtractField(FormatFloat(NoDecimalDisplay_BlankZero, TaxableValue)));
                    end
                  else
                    begin
                      Write(ExtractFile, FormatExtractField(FormatFloat(_3DecimalEditDisplay, AssessedValue)));
                      Writeln(ExtractFile, FormatExtractField(FormatFloat(_3DecimalEditDisplay, TaxableValue)));
                    end;

              end;  {If ExtractToExcel}

        end;  {with SDTotalsRec do}

    end;  {with Sender as TBaseReport do}

  LineNo := LineNo + 1;

end;  {PrintOneSDTotal}

{=======================================================================}
Procedure PrintSpecialDistrictTotalsSection(    Sender : TObject;  {Report printer or filer object}
                                                SDTotalsList : TList;
                                                TaxRollYear : String;
                                                SwisCode : String;
                                                SDCodeDescList,
                                                SDExtCodeDescList,
                                                SwisCodeDescList : TList;
                                                SectionType : Char;
                                            var PageNo,
                                                LineNo : Integer);

{Print the exemption totals in the TLists.}

var
  I : Integer;
  HeaderPrinted, SubheaderPrinted : Boolean;
  OverallSDTotalsList : TList;
  TempSDTotalRec : RTSDCodeTotals;
  SDCode, LastSDCode : String;

begin
  HeaderPrinted := False;

  If FirstPageOfReport
    then
      begin
        PrintHeader(Sender, SectionType, SwisCode,
                    TaxRollYear, SwisCodeDescList,
                    PageNo, LineNo);
        FirstPageOfReport := False;
      end
    else StartNewPage(Sender, SectionType, SwisCode,
                      TaxRollYear, SwisCodeDescList,
                      PageNo, LineNo);

    {CHG02012004-5(2.08): Option to print to Excel.}
    {CHG05102009-1(2.20.1.1)[F925]: Add the assessed value to the roll totals print.}

  If ExtractToExcel
    then
      begin
        Writeln(ExtractFile);
        Writeln(ExtractFile, 'Special District Totals');
        WritelnCommaDelimitedLine(ExtractFile,
                                  ['SD Code',
                                   'Description',
                                   'Parcel Count',
                                   'Extension',
                                   'Assessed Value',
                                   'Taxable Value']);

      end;  {If ExtractToExcel}

  with Sender as TBaseReport do
    begin
        {Finally, do the overall totals.}

      SubheaderPrinted := False;

       {Initialize the temporary record for the totals for this
        subsection.}

      with TempSDTotalRec do
        begin
          ParcelCount := 0;
          TaxableValue := 0;
          AssessedValue := 0;

        end;  {with TempSDTotalRec do}

      OverallSDTotalsList := TList.Create;
      CombineSDTotals(SDTotalsList, OverallSDTotalsList);
      LastSDCode := '';

      If (OverallSDTotalsList.Count = 0)
        then
          begin
            Println('');
            PrintSectionHeader(Sender, 'D', LineNo);
            PrintSDSubheader(Sender, SectionType, LineNo);
            ClearTabs;
            SetTab(4.5, pjCenter, 5.0, 0, BOXLINENONE, 0);   {HDR}
            Println(#9 + 'NO SPECIAL DISTRICT TOTALS AT THIS LEVEL');
            Println('');
          end
        else
          begin
            SDCode := RTSDCodeTotalsPtr(OverallSDTotalsList[0])^.SDCode;

            For I := 0 to (OverallSDTotalsList.Count - 1) do
              begin
                  {Do we need to go to a new page?}

                with Sender as TBaseReport do
                If (LinesLeft < LinesAtBottom)
                  then
                    begin
                      StartNewPage(Sender, SectionType, SwisCode,
                                   TaxRollYear, SwisCodeDescList,
                                   PageNo, LineNo);

                      PrintTotalsPageSubheader(Sender, SectionType, LineNo);

                      HeaderPrinted := False;
                      SubheaderPrinted := False;

                    end;  {If (LinesLeft < 4)}

                SDCode := RTSDCodeTotalsPtr(OverallSDTotalsList[I])^.SDCode;

                If not HeaderPrinted
                  then
                    begin
                      PrintSectionHeader(Sender, 'D', LineNo);
                      HeaderPrinted := True;
                    end;

                If not SubHeaderPrinted
                  then
                    begin
                      PrintSDSubHeader(Sender, SectionType, LineNo);
                      SubheaderPrinted := True;
                    end;

                PrintOneSDTotal(Sender, SDCodeDescList, SDExtCodeDescList,
                                LastSDCode, RTSDCodeTotalsPtr(OverallSDTotalsList[I])^,
                                LineNo);

                  {FXX01021998-7: Need to update the LastSDCode after
                                  printing one line, not before.}

                LastSDCode := SDCode;

                UpdateSDTaxTotals(RTSDCodeTotalsPtr(OverallSDTotalsList[I])^,
                                  TempSDTotalRec);

              end;  {For I := 0 to OverallEXTotalsList do}

          end;  {else of If (OverallSDTotalsList.Count = 0)}

      FreeTList(OverallSDTotalsList, SizeOf(RTSDCodeTotals));

    end;  {with Sender as TBaseReport do}

end;  {PrintSpecialDistrictTotalsSection}

{=======================================================================}
{=================   SPECIAL DISTRICT TOTALS  ==========================}
{=======================================================================}
Function FoundRS9Record(    RS9TotalsList : TList;
                            _SDCode : String;
                            CombineRollSections : Boolean;
                        var I : Integer) : Boolean;

{Search through the totals list for this RS9 code, ext code,
 and homestead code.}

var
  J : Integer;

begin
  Result := False;

      {FXX04231998-12: Need to use roll section in key for totals recs, too.}
      {FXX04291998-6: Don't need to use roll section as criteria when showing
                      totals in RS9 sections.}

  For J := 0 to (RS9TotalsList.Count - 1) do
    with RTRS9TotalsPtr(RS9TotalsList[J])^ do
      If (Take(5, SDCode) = Take(5, _SDCode))
        then
          begin
            Result := True;
            I := J;
          end;

end;  {FoundRS9Record}

{=======================================================================}
Procedure CombineRS9Totals(RS9TotalsList,  {List with totals broken down into hstd, nonhstd.}
                           OverallTotalsList : TList);  {No hstd\nonhstd breakdown.}

{The totals entries in the RS9TotalsList are broken down into homestead and
 nonhomestead, so we want to combine them for the overall totals. To do
 this, we will take the entries from the RS9TotalsList and put them into the
 overall totals list, disregarding the homestead code.}

var
  I, J : Integer;
  TempPtr, RS9TotalsPtr : RTRS9TotalsPtr;
  MainKey, NewKey : String;

begin
   {FXX04231998-12: Need to use roll section in key for totals recs, too.}

  For I := 0 to (RS9TotalsList.Count - 1) do
    with RTRS9TotalsPtr(RS9TotalsList[I])^ do
      If FoundRS9Record(OverallTotalsList, SDCode, True, J)  {Don't use hstd code as a key.}
        then
          begin
            RTRS9TotalsPtr(OverallTotalsList[J])^.ParcelCount :=
                     RTRS9TotalsPtr(OverallTotalsList[J])^.ParcelCount + ParcelCount;
            RTRS9TotalsPtr(OverallTotalsList[J])^.Amount :=
                     RTRS9TotalsPtr(OverallTotalsList[J])^.Amount + Amount;

          end
        else
          begin
            New(RS9TotalsPtr);   {get new pptr for tlist array}

            RS9TotalsPtr^.SwisCode := SwisCode;
            RS9TotalsPtr^.SDCode := SDCode;
            RS9TotalsPtr^.ParcelCount := ParcelCount;
            RS9TotalsPtr^.Amount := Amount;

            OverallTotalsList.Add(RS9TotalsPtr);

          end;  {else of If FoundRS9Record(OverallTotalsList, RS9, ExtCode, CMFlag,}

    {FXX01021998-12: Sort the overall RS9 totals by RS9 code\ Extension.}

  For I := 0 to (OverallTotalsList.Count - 1) do
    begin
      with RTRS9TotalsPtr(OverallTotalsList[I])^ do
        MainKey := Take(5, SDCode);

      For J := (I + 1) to (OverallTotalsList.Count - 1) do
        begin
          with RTRS9TotalsPtr(OverallTotalsList[J])^ do
            NewKey := Take(5, SDCode);

          If (NewKey < MainKey)
            then
              begin
                TempPtr := OverallTotalsList[I];
                OverallTotalsList[I] := OverallTotalsList[J];
                OverallTotalsList[J] := TempPtr;
                MainKey := NewKey;

              end;  {If (NewKey < MainKey)}

        end;  {For J := (I + 1) to (OverallTotalsList.Count - 1) do}

    end;  {For I := 0 to (OverallTotalsList.Count - 1) do}

end;  {CombineRS9Totals}

{=======================================================================}
Procedure UpdateRS9TaxTotals(    SourceRS9TotalsRec : RTRS9Totals;
                            var TempRS9TotalRec : RTRS9Totals);

{Update the running totals in the TempRS9TotalRec from the source
 rec.}

begin
  with TempRS9TotalRec do
    begin
      ParcelCount := ParcelCount + SourceRS9TotalsRec.ParcelCount;
      Amount := Amount + SourceRS9TotalsRec.Amount;

    end;  {with TempRS9TotalRec do}

end;  {UpdateRS9TaxTotals}

{=======================================================================}
Procedure PrintRS9Subheader(    Sender : TObject;  {Report printer or filer object}
                                SubheaderType : Char;  {(H)std, (N)onhstd, (S)wis, S(c)hool, (R)S, (G)rand}
                            var LineNo : Integer);

{Print the individual RS9 totals section header and set the tabs for the
 RS9 amounts columns.}

begin
  with Sender as TBaseReport do
    begin
        {Roll section totals do not breakdown by hRS9t\nonhstd so
         the following two lines are not needed.}

      If (SubheaderType <> 'R')
        then PrintSectionSubheader(Sender, SubheaderType, LineNo);

      ClearTabs;
      SetTab(TL1, pjLeft, TL1W, 0, BOXLINENONE, 0);   {CODE}
      SetTab(TL2, pjLeft, TL2W, 0, BOXLINENONE, 0);   {DIST NAME}
      SetTab(TL3, pjLeft, TL3W, 0, BOXLINENONE, 0);   {PRCL CNT}
      SetTab(TL4, pjCenter, TL4W, 0, BOXLINENONE, 0);   {Amount}

      Println('');
      Println(#9 + #9 +
              #9 + 'TOTAL' +
              #9 + 'TAXABLE');

       Println(#9 + 'CODE' +
               #9 + 'DISTRICT NAME' +
               #9 + 'PARCELS' +
               #9 + 'VALUE');

       LineNo := LineNo + 3;

      Println('');
      LineNo := LineNo + 1;

    end;  {with Sender as TBaseReport do}

end;  {PrintRS9Subheader}

{=======================================================================}
Procedure PrintOneRS9Total(    Sender : TObject;  {Report printer or filer object}
                               SDCodeDescList : TList;
                               LastSDCode : String;  {What was the last RS9 code printed?}
                               RS9TotalsRec : RTRS9Totals;
                           var LineNo : Integer);

{Print one special district total.}

begin
  with Sender as TBaseReport do
    begin
        {Reset the tabs}

      ClearTabs;
      SetTab(TL1, pjLeft, TL1W, 0, BOXLINENONE, 0);   {CODE}
      SetTab(TL2, pjLeft, TL2W, 0, BOXLINENONE, 0);   {DIST NAME}
      SetTab(TL3, pjRight, TL3W, 0, BOXLINENONE, 0);   {PRCL CNT}
      SetTab(TL4, pjRight, TL4W, 0, BOXLINENONE, 0);   {TAXABLE VALUE}

      with RS9TotalsRec do
        begin
          If (SDCode = LastSDCode)
            then Print(#9 + #9 + #9)
            else Print(#9 + SDCode +
                       #9 + UpcaseStr(Take(15, GetDescriptionFromList(SDCode, SDCodeDescList))) +
                       #9 + IntToStr(ParcelCount));

          Println(#9 + FormatFloat(DecimalDisplay_BlankZero, Amount));

        end;  {with RS9TotalsRec do}

    end;  {with Sender as TBaseReport do}

  LineNo := LineNo + 1;

end;  {PrintOneRS9Total}

{=======================================================================}
Procedure PrintRS9TotalsSection(    Sender : TObject;  {Report printer or filer object}
                                    RS9TotalsList : TList;
                                    TaxRollYear : String;
                                    SwisCode : String;
                                    SDCodeDescList,
                                    SwisCodeDescList : TList;
                                    SectionType : Char;
                                var PageNo,
                                    LineNo : Integer);

{Print the exemption totals in the TLists.}

var
  I : Integer;
  HeaderPrinted, SubheaderPrinted : Boolean;
  OverallRS9TotalsList : TList;
  TempRS9TotalRec : RTRS9Totals;
  SDCode, LastSDCode : String;

begin
  HeaderPrinted := False;

  If FirstPageOfReport
    then
      begin
        PrintHeader(Sender, SectionType, SwisCode,
                    TaxRollYear, SwisCodeDescList,
                    PageNo, LineNo);
        FirstPageOfReport := False;
      end
    else StartNewPage(Sender, SectionType, SwisCode,
                      TaxRollYear, SwisCodeDescList,
                      PageNo, LineNo);

  with Sender as TBaseReport do
    begin
        {Finally, do the overall totals.}

      SubheaderPrinted := False;

       {Initialize the temporary record for the totals for this
        subsection.}

      with TempRS9TotalRec do
        begin
          ParcelCount := 0;
          Amount := 0;

        end;  {with TempRS9TotalRec do}

      OverallRS9TotalsList := TList.Create;
      CombineRS9Totals(RS9TotalsList, OverallRS9TotalsList);
      LastSDCode := '';

      If (OverallRS9TotalsList.Count = 0)
        then
          begin
            Println('');
            PrintSectionHeader(Sender, 'D', LineNo);
            PrintRS9Subheader(Sender, SectionType, LineNo);
            ClearTabs;
            SetTab(4.5, pjCenter, 5.0, 0, BOXLINENONE, 0);   {HDR}
            Println(#9 + 'NO ROLL SECTION 9 TOTALS AT THIS LEVEL');
            Println('');
          end
        else
          begin
            SDCode := RTRS9TotalsPtr(OverallRS9TotalsList[0])^.SDCode;

            For I := 0 to (OverallRS9TotalsList.Count - 1) do
              begin
                  {Do we need to go to a new page?}

                with Sender as TBaseReport do
                If (LinesLeft < LinesAtBottom)
                  then
                    begin
                      StartNewPage(Sender, SectionType, SwisCode,
                                   TaxRollYear, SwisCodeDescList,
                                   PageNo, LineNo);

                      PrintTotalsPageSubheader(Sender, SectionType, LineNo);

                      HeaderPrinted := False;
                      SubheaderPrinted := False;

                    end;  {If (LinesLeft < 4)}

                SDCode := RTRS9TotalsPtr(OverallRS9TotalsList[I])^.SDCode;

                If not HeaderPrinted
                  then
                    begin
                      PrintSectionHeader(Sender, 'D', LineNo);
                      HeaderPrinted := True;
                    end;

                If not SubHeaderPrinted
                  then
                    begin
                      PrintRS9SubHeader(Sender, SectionType, LineNo);
                      SubheaderPrinted := True;
                    end;

                PrintOneRS9Total(Sender, SDCodeDescList,
                                 LastSDCode, RTRS9TotalsPtr(OverallRS9TotalsList[I])^,
                                 LineNo);

                  {FXX01021998-7: Need to update the LastRS9 after
                                  printing one line, not before.}

                LastSDCode := SDCode;

                UpdateRS9TaxTotals(RTRS9TotalsPtr(OverallRS9TotalsList[I])^,
                                  TempRS9TotalRec);

              end;  {For I := 0 to OverallEXTotalsList do}

          end;  {else of If (OverallRS9TotalsList.Count = 0)}

      FreeTList(OverallRS9TotalsList, SizeOf(RTRS9Totals));

    end;  {with Sender as TBaseReport do}

end;  {PrintRS9TotalsSection}

{=======================================================================}
{=================   ROLL SECTION TOTALS  ==============================}
{=======================================================================}
Function FoundRollSectionTotalRecord(    RollSectionTotalsList : TList;
                                        _RollSection,
                                        _HomesteadCode : String;
                                        CombineRollSections : Boolean;
                                    var I : Integer) : Boolean;

{Search through the totals list for this print order, roll section,
 and homestead code.}

var
  J : Integer;

begin
  Result := False;

    {FXX01091998-7: Don't compare homestead codes if it is blank.}

  For J := 0 to (RollSectionTotalsList.Count - 1) do
    with  RTSwisCodeTotalsPtr(RollSectionTotalsList[J])^ do
      If ((CombineRollSections or
           ((not CombineRollSections) and
            (Take(1, RollSection) = Take(1, _RollSection)))) and
          ((Deblank(_HomesteadCode) = '') or
           (Take(1, HomesteadCode) = Take(1, _HomesteadCode))))
        then
          begin
            Result := True;
            I := J;
          end;

end;  {FoundRollSectionTotalRecord}

{=======================================================================}
Procedure CombineRollSectionTotals(RollSectionTotalsList,  {List with totals broken down into hstd, nonhstd.}
                                   OverallTotalsList : TList;  {No hstd\nonhstd breakdown.}
                                   CombineRollSections : Boolean);  {Should we combine the
                                                                     tax for one tax type
                                                                     down into one line?}

{The totals entries in the RollSectionTotalsList are broken down into homestead and
 nonhomestead, so we want to combine them for the overall totals. To do
 this, we will take the entries from the RollSectionTotalsList and put them into the
 overall totals list, disregarding the homestead code.}

var
  I, J : Integer;
  RollSectionTotalsPtr :  RTSwisCodeTotalsPtr;

begin
  For I := 0 to (RollSectionTotalsList.Count - 1) do
    with RTSwisCodeTotalsPtr(RollSectionTotalsList[I])^ do
      If FoundRollSectionTotalRecord(OverallTotalsList, RollSection,
                                     ' ', CombineRollSections, J)  {Don't use hstd code as a key.}
        then
          begin
              {Note that we do not add the split count again since we
               would be double counting it then.}

             RTSwisCodeTotalsPtr(OverallTotalsList[J])^.ParcelCount :=
                      RTSwisCodeTotalsPtr(OverallTotalsList[J])^.ParcelCount + ParcelCount;

               {FXX02101999-4: Add land value to swis and school totals.}

             RTSwisCodeTotalsPtr(OverallTotalsList[J])^.LandValue :=
                      RTSwisCodeTotalsPtr(OverallTotalsList[J])^.LandValue + LandValue;

             RTSwisCodeTotalsPtr(OverallTotalsList[J])^.AssessedValue :=
                      RTSwisCodeTotalsPtr(OverallTotalsList[J])^.AssessedValue + AssessedValue;
             RTSwisCodeTotalsPtr(OverallTotalsList[J])^.CountyTaxable :=
                      RTSwisCodeTotalsPtr(OverallTotalsList[J])^.CountyTaxable + CountyTaxable;
             RTSwisCodeTotalsPtr(OverallTotalsList[J])^.TownTaxable :=
                      RTSwisCodeTotalsPtr(OverallTotalsList[J])^.TownTaxable + TownTaxable;
             RTSwisCodeTotalsPtr(OverallTotalsList[J])^.VillageTaxable :=
                      RTSwisCodeTotalsPtr(OverallTotalsList[J])^.TownTaxable + VillageTaxable;

          end
        else
          begin
            New(RollSectionTotalsPtr);   {get new pptr for tlist array}

            RollSectionTotalsPtr^.SwisCode := SwisCode;

              {If this is a total across roll sections, don't save the
               roll section code.}

            If CombineRollSections
              then RollSectionTotalsPtr^.RollSection := ''
              else RollSectionTotalsPtr^.RollSection := RollSection;

            RollSectionTotalsPtr^.HomesteadCode := ' ';  {Blank out hstd code.}

              {FXX02101999-4: Add land value to swis and school totals.}

            RollSectionTotalsPtr^.LandValue := LandValue;
            RollSectionTotalsPtr^.AssessedValue := AssessedValue;
            RollSectionTotalsPtr^.ParcelCount := ParcelCount;
            RollSectionTotalsPtr^.PartCount := PartCount;
            RollSectionTotalsPtr^.CountyTaxable := CountyTaxable;
            RollSectionTotalsPtr^.TownTaxable := TownTaxable;
            RollSectionTotalsPtr^.VillageTaxable := VillageTaxable;

            OverallTotalsList.Add(RollSectionTotalsPtr);

          end;  {else of If FoundRollSectionRecord(OverallTotalsList, GeneralCode, ExtCode, CMFlag,}

end;  {CombineRollSectionTotals}

{=======================================================================}
Procedure UpdateRollSectionTotals(    SourceRollSectionTotalsRec : RTSwisCodeTotals;
                                  var TempRollSectionTotalRec : RTSwisCodeTotals);

{Update the running totals in the TempGeneralTotalRec from the source
 rec.}

begin
  with TempRollSectionTotalRec do
    begin
      ParcelCount := ParcelCount + SourceRollSectionTotalsRec.ParcelCount;
      PartCount := PartCount + SourceRollSectionTotalsRec.PartCount;
      LandValue := LandValue + SourceRollSectionTotalsRec.LandValue;
      AssessedValue := AssessedValue + SourceRollSectionTotalsRec.AssessedValue;
      CountyTaxable := CountyTaxable + SourceRollSectionTotalsRec.CountyTaxable;
      TownTaxable := TownTaxable + SourceRollSectionTotalsRec.TownTaxable;
      VillageTaxable := VillageTaxable + SourceRollSectionTotalsRec.VillageTaxable; 

    end;  {with TempRollSectionTotalRec do}

end;  {UpdateRollSectionTotals}

{=======================================================================}
Procedure PrintRollSectionSubheader(    Sender : TObject;  {Report printer or filer object}
                                        SubheaderType : Char;  {(H)std, (N)onhstd, (S)wis, S(c)hool, (R)S, (G)rand}
                                        IsAssessingVillage : Boolean;
                                    var LineNo : Integer);

{Print the individual General totals section header and set the tabs for the
 General amounts columns.}

begin
  with Sender as TBaseReport do
    begin
        {Roll section totals do not breakdown by hstd\nonhstd.}

      If (SubheaderType <> 'R')
        then PrintSectionSubheader(Sender, SubheaderType, LineNo);

        {FXX02101999-4: Add land value to swis and school totals.}

      ClearTabs;
      SetTab(TL1, pjLeft, TL1W, 0, BOXLINENONE, 0);   {Roll Section}
      SetTab(TL2, pjLeft, TL2W, 0, BOXLINENONE, 0);   {Desc}
      SetTab(TL3, pjCenter, TL3W, 0, BOXLINENONE, 0);   {PRCL CNT}
      SetTab(TL4, pjCenter, TL4W, 0, BOXLINENONE, 0);   {Land AV}
      SetTab(TL5, pjCenter, TL5W, 0, BOXLINENONE, 0);   {Total AV}
      SetTab(TL6, pjCenter, TL6W, 0, BOXLINENONE, 0);   {County taxable}
      SetTab(TL7, pjCenter, TL7W, 0, BOXLINENONE, 0);   {Town Taxable}
      SetTab(TL8, pjCenter, TL8W, 0, BOXLINENONE, 0);   {Village Taxable}

      Println('');
      Print(#9 +'ROLL' +
            #9 +
            #9 + 'TOTAL' +
            #9 + 'LAND' +
            #9 + 'ASSESSED');

        {CHG01192004-1(2.08): Let each municipality decide what roll totals to display.}

      If (rtdCounty in GlblRollTotalsToShow)
        then Print(#9 + 'COUNTY')
        else Print(#9);

      If (rtdMunicipal in GlblRollTotalsToShow)
        then Print(#9 + UpcaseStr(GetMunicipalityTypeName(GlblMunicipalityType)))
        else Print(#9);

      If (rtdVillageReceivingPartialRoll in GlblRollTotalsToShow)
        then Println(#9 + 'VILLAGE')
        else Println('');

      Print(#9 + 'SEC' +
            #9 + 'DESCRIPTION' +
            #9 + 'PARCELS' +
            #9 + 'TOTAL' +
            #9 + 'TOTAL');

      If (rtdCounty in GlblRollTotalsToShow)
        then Print(#9 + 'TAXABLE')
        else Print(#9);

      If (rtdMunicipal in GlblRollTotalsToShow)
        then Print(#9 + 'TAXABLE')
        else Print(#9);

      If (rtdVillageReceivingPartialRoll in GlblRollTotalsToShow)
        then Println(#9 + 'TAXABLE')
        else Println('');

      LineNo := LineNo + 1;

         {If this is a homestead or nonhomestead section,
          print that this is the total number of parcels and parts.}

       If (SubheaderType in ['H', 'N'])
         then
           begin
             Println(#9 + #9 + #9 + '& PARTS');
             LineNo := LineNo + 1;
           end;

       {FXX12291997-2: Print a blank line between the header and the start
                       of the information.}

      Println('');
      LineNo := LineNo + 1;

    end;  {with Sender as TBaseReport do}

end;  {PrintRollSectionSubheader}

{=======================================================================}
Function GetRollSectionDescriptionForRollPrint(RollSection : String) : String;

{FXX01081998-3: Hardcode the roll section descriptions so they look nice.}

begin
  case RollSection[1] of
    '1' : Result := 'TAXABLE';
    '3' : Result := 'STATE LAND';
    '5' : Result := 'SPCL FRANCHISE';
    '6' : Result := 'UTILITY & R.R.';
    '7' : Result := 'CEILING RAILROAD';
    '8' : Result := 'WHOLLY EXEMPT';
    '9' : Result := 'OMITTED \ PRO-RATA';

  end;  {case RollSection[1] of}

end;  {GetRollSectionDescriptionForRollPrint}

{=======================================================================}
Procedure PrintOneRollSectionTotal(    Sender : TObject;  {Report printer or filer object}
                                       SubheaderType : Char;  {(H)std, (N)onhstd, (S)wis, S(c)hool, (R)S, (G)rand}
                                       RollSectionDescList : TList;
                                       RollSectionTotalsRec : RTSwisCodeTotals;
                                       IsAssessingVillage : Boolean;
                                   var LineNo : Integer);

{Print one general tax total.}

begin
    {FXX02101999-4: Add land value to swis and school totals.}
    {FXX03182003-1(2.06q1): The tabs were setup wrong.}

  with Sender as TBaseReport do
    begin
        {Reset the tabs}

      ClearTabs;
      SetTab(TL1, pjLeft, TL1W, 0, BOXLINENONE, 0);   {Roll Section}
      SetTab(TL2, pjLeft, TL2W, 0, BOXLINENONE, 0);   {Desc}
      SetTab(TL3, pjRight, TL3W, 0, BOXLINENONE, 0);   {PRCL CNT}
      SetTab(TL4, pjRight, TL4W, 0, BOXLINENONE, 0);   {Land AV}
      SetTab(TL5, pjRight, TL5W, 0, BOXLINENONE, 0);   {Total AV}
      SetTab(TL6, pjRight, TL6W, 0, BOXLINENONE, 0);   {County taxable}
      SetTab(TL7, pjRight, TL7W, 0, BOXLINENONE, 0);   {Town taxable}
      SetTab(TL8, pjRight, TL8W, 0, BOXLINENONE, 0);   {Village taxable}

      with RollSectionTotalsRec do
        begin
          If (Deblank(RollSection) = '')
            then Print(#9 + 'TOTAL' + #9)
            else
              begin
                Print(#9 + RollSection);
                Print(#9 + Take(15, GetRollSectionDescriptionForRollPrint(RollSection)));
              end;

            {FXX01071998-7: Subtract the number of splits out of the total.}
            {FXX04162001-2: Need to add the (PartCount DIV 2), not subtract!}

          If (SubheaderType in ['H', 'N'])
            then Print(#9 + IntToStr(ParcelCount + PartCount))
            else Print(#9 + IntToStr(ParcelCount + (PartCount DIV 2)));

          Print(#9 + FormatFloat(NoDecimalDisplay_BlankZero, LandValue));

          Print(#9 + FormatFloat(NoDecimalDisplay_BlankZero, AssessedValue));

            {CHG01192004-1(2.08): Let each municipality decide what roll totals to display.}

          If (rtdCounty in GlblRollTotalsToShow)
            then Print(#9 + FormatFloat(CurrencyDisplayNoDollarSign, CountyTaxable))
            else Print(#9);

          If (rtdMunicipal in GlblRollTotalsToShow)
            then Print(#9 + FormatFloat(CurrencyDisplayNoDollarSign, TownTaxable))
            else Print(#9);

          If (rtdVillageReceivingPartialRoll in GlblRollTotalsToShow)
            then Println(#9 + FormatFloat(CurrencyDisplayNoDollarSign, VillageTaxable))
            else Println('');

            {CHG02012004-5(2.08): Option to print to Excel.}

          If ExtractToExcel
            then
              begin
                If (Deblank(RollSection) = '')
                  then Write(ExtractFile, 'TOTAL,')
                  else Write(ExtractFile, RollSection,
                                          FormatExtractField(GetRollSectionDescriptionForRollPrint(RollSection)));

                If (SubheaderType in ['H', 'N'])
                  then Write(ExtractFile, FormatExtractField(IntToStr(ParcelCount + PartCount)))
                  else Write(ExtractFile, FormatExtractField(IntToStr(ParcelCount + (PartCount DIV 2))));

                Write(ExtractFile, FormatExtractField(FormatFloat(NoDecimalDisplay_BlankZero, LandValue)),
                                   FormatExtractField(FormatFloat(NoDecimalDisplay_BlankZero, AssessedValue)));

                If (rtdCounty in GlblRollTotalsToShow)
                  then Write(ExtractFile, FormatExtractField(FormatFloat(CurrencyDisplayNoDollarSign, CountyTaxable)));

                If (rtdMunicipal in GlblRollTotalsToShow)
                  then Write(ExtractFile, FormatExtractField(FormatFloat(CurrencyDisplayNoDollarSign, TownTaxable)));

                If (rtdVillageReceivingPartialRoll in GlblRollTotalsToShow)
                  then Write(ExtractFile, FormatExtractField(FormatFloat(CurrencyDisplayNoDollarSign, VillageTaxable)));

                Writeln(ExtractFile);

              end;  {If ExtractToExcel}

        end;  {with RollSectionTotalsRec do}

    end;  {with Sender as TBaseReport do}

  LineNo := LineNo + 1;

end;  {PrintOneRollSectionTotal}

{=================================================================}
Procedure SortRollSectionList(RollSectionTotalsList : TList);

{FXX04231998-11: Sort the RollSectionemption totals list into the proper order.}

var
  OldKey, NewKey : String;
  I, J : Integer;
  TempPtr : RTSwisCodeTotalsPtr;

begin
  For I := 0 to (RollSectionTotalsList.Count - 1) do
    begin
      OldKey := RTSwisCodeTotalsPtr(RollSectionTotalsList[I])^.RollSection;

      For J := (I + 1) to (RollSectionTotalsList.Count - 1) do
        begin
          NewKey := RTSwisCodeTotalsPtr(RollSectionTotalsList[J])^.RollSection;

          If (NewKey < OldKey)
            then
              begin
                TempPtr := RollSectionTotalsList[I];
                RollSectionTotalsList[I] := RollSectionTotalsList[J];
                RollSectionTotalsList[J] := TempPtr;
                OldKey := NewKey;

              end;  {If (NewKey < OldKey)}

        end;  {For J := (I + 1) to (RollSectionTotalsList.Count - 1) do}

    end;  {For I := 0 to (RollSectionTotalsList.Count - 1) do}

end;  {SortRollSectionList}

{=======================================================================}
Procedure PrintRollSectionTotalsSection(    Sender : TObject;  {Report printer or filer object}
                                            RollSectionTotalsList : TList;
                                            TaxRollYear : String;
                                            SwisCode : String;
                                            RollSectionDescList,
                                            SwisCodeDescList : TList;
                                            PrintClassAmounts : Boolean;
                                            SectionType : Char;
                                            IsAssessingVillage : Boolean;
                                        var PageNo,
                                            LineNo : Integer);

{Print the roll section totals in the TLists.}

var
  I, NumHomestead, NumNonhomestead : Integer;
  HeaderPrinted, SubheaderPrinted : Boolean;
  OverallRollSectionTotalsList : TList;
  TempRollSectionTotalRec : RTSwisCodeTotals;
  TempSubheaderType : Char;

begin
  HeaderPrinted := False;
  NumHomestead := 0;
  NumNonhomestead := 0;

  For I := 0 to (RollSectionTotalsList.Count - 1) do
    with RTSwisCodeTotalsPtr(RollSectionTotalsList[I])^ do
      If (HomesteadCode = 'N')
        then NumNonhomestead := NumNonhomestead + 1
        else NumHomestead := NumHomestead + 1;

    {FXX04231998-11: Sort the RollSection totals list into the proper order.}

  SortRollSectionList(RollSectionTotalsList);

  If FirstPageOfReport
    then
      begin
        PrintHeader(Sender, SectionType, SwisCode,
                    TaxRollYear, SwisCodeDescList,
                    PageNo, LineNo);
        FirstPageOfReport := False;
      end
    else StartNewPage(Sender, SectionType, SwisCode,
                      TaxRollYear, SwisCodeDescList,
                      PageNo, LineNo);

    {CHG02012004-5(2.08): Option to print to Excel.}

  If ExtractToExcel
    then
      begin
        Writeln(ExtractFile, 'Roll Section Totals');
        If PrintClassAmounts
          then Writeln(ExtractFile, ',Homestead Totals');

        Write(ExtractFile, 'RS,',
                           'Description,',
                           'Parcel Count,',
                           'Land Value,',
                           'Assessed Value');

        If (rtdCounty in GlblRollTotalsToShow)
          then Write(ExtractFile, ',County Taxable');

        If (rtdMunicipal in GlblRollTotalsToShow)
          then Write(ExtractFile, ',' + GetMunicipalityTypeName(GlblMunicipalityType) + ' Taxable');

        If (rtdVillageReceivingPartialRoll in GlblRollTotalsToShow)
          then Write(ExtractFile, ',Village Taxable');

        Writeln(ExtractFile);

      end;  {If ExtractToExcel}

  with Sender as TBaseReport do
    begin
        {First homestead part, but only if this is not a roll section summary.
         Note that we print the header and subheader only if there is an
         entry.}

      If PrintClassAmounts
        then
          begin
            SubheaderPrinted := False;

              {Initialize the temporary record for the totals for this
               subsection.}

            with TempRollSectionTotalRec do
              begin
                ParcelCount := 0;
                PartCount := 0;
                LandValue := 0;
                AssessedValue := 0;
                CountyTaxable := 0;
                TownTaxable := 0;
                VillageTaxable := 0;
                RollSection := '';

              end;  {with TempRollSectionTotalRec do}

            If (NumHomestead = 0)
              then
                begin
                  Println('');
                  PrintSectionHeader(Sender, 'R', LineNo);
                  PrintRollSectionSubheader(Sender, 'H', IsAssessingVillage, LineNo);
                  ClearTabs;
                  SetTab(4.5, pjCenter, 5.0, 0, BOXLINENONE, 0);   {HDR}
                  Println(#9 + 'NO TOTALS AT THIS LEVEL');
                  Println('');
                end
              else
                begin
                  If ExtractToExcel
                    then Writeln(ExtractFile, ',Homestead Totals');
                  For I := 0 to (RollSectionTotalsList.Count - 1) do
                    If (RTSwisCodeTotalsPtr(RollSectionTotalsList[I])^.HomesteadCode[1] in ['H', ' '])
                      then
                        begin
                          If not HeaderPrinted
                            then
                              begin
                                PrintSectionHeader(Sender, 'R', LineNo);
                                HeaderPrinted := True;
                              end;

                          If not SubHeaderPrinted
                            then
                              begin
                                PrintRollSectionSubheader(Sender, 'H', IsAssessingVillage, LineNo);
                                SubheaderPrinted := True;
                              end;

                          PrintOneRollSectionTotal(Sender, 'H', RollSectionDescList,
                                                   RTSwisCodeTotalsPtr(RollSectionTotalsList[I])^,
                                                   IsAssessingVillage,
                                                   LineNo);

                            {Do we need to go to a new page?}
                            {FXX04231998-9: Instead of print the roll section hdr for
                                            the totals sections, print the section type.}

                          If ((NumLinesPerPage - LineNo) < LinesAtBottom)
                            then
                              begin
                                StartNewPage(Sender, SectionType, SwisCode,
                                             TaxRollYear, SwisCodeDescList,
                                             PageNo, LineNo);

                                PrintTotalsPageSubheader(Sender, SectionType, LineNo);

                                HeaderPrinted := False;
                                SubheaderPrinted := False;

                              end;  {If (LinesLeft < 4)}

                          UpdateRollSectionTotals(RTSwisCodeTotalsPtr(RollSectionTotalsList[I])^,
                                                  TempRollSectionTotalRec);

                        end;  {If (RTSwisCodeTotalsPtr(RollSectionTotalsList[I])^.HomesteadCode in ['H', ' '])}

                    {Make sure that if we had to switch pages between
                     the details and the total line that we print the headers
                     again.}

                  If not HeaderPrinted
                    then
                      begin
                        PrintSectionHeader(Sender, 'R', LineNo);
                        HeaderPrinted := True;
                      end;

                  If not SubHeaderPrinted
                    then PrintRollSectionSubheader(Sender, 'H', IsAssessingVillage, LineNo);

                    {Print the totals for this subsection.}

                  Println('');
                  PrintOneRollSectionTotal(Sender, 'H', RollSectionDescList,
                                           TempRollSectionTotalRec,
                                           IsAssessingVillage, LineNo);

                end;  {else of If (NumHomestead = 0)}

          end;  {If (SectionType <> 'R')}

        {Now the non-homestead part, if these are not roll section totals.}

      If PrintClassAmounts
        then
          begin
            SubheaderPrinted := False;

              {Initialize the temporary record for the totals for this
               subsection.}

            with TempRollSectionTotalRec do
              begin
                ParcelCount := 0;
                PartCount := 0;
                LandValue := 0;
                AssessedValue := 0;
                CountyTaxable := 0;
                TownTaxable := 0;
                VillageTaxable := 0;
                RollSection := '';

              end;  {with TempRollSectionTotalRec do}

            If (NumNonhomestead = 0)
              then
                begin
                  Println('');
                  PrintSectionHeader(Sender, 'R', LineNo);
                  PrintRollSectionSubheader(Sender, 'N', IsAssessingVillage, LineNo);
                  ClearTabs;
                  SetTab(4.5, pjCenter, 5.0, 0, BOXLINENONE, 0);   {HDR}
                  Println(#9 + 'NO TOTALS AT THIS LEVEL');
                  Println('');
                end
              else
                begin
                  For I := 0 to (RollSectionTotalsList.Count - 1) do
                    If (RTSwisCodeTotalsPtr(RollSectionTotalsList[I])^.HomesteadCode[1] = 'N')
                      then
                        begin
                          If not HeaderPrinted
                            then
                              begin
                                PrintSectionHeader(Sender, 'R', LineNo);
                                HeaderPrinted := True;
                              end;

                          If not SubHeaderPrinted
                            then
                              begin
                                PrintRollSectionSubheader(Sender, 'N', IsAssessingVillage, LineNo);
                                SubheaderPrinted := True;
                              end;

                          PrintOneRollSectionTotal(Sender, 'N', RollSectionDescList,
                                                   RTSwisCodeTotalsPtr(RollSectionTotalsList[I])^,
                                                   IsAssessingVillage, LineNo);

                            {Do we need to go to a new page?}

                          If ((NumLinesPerPage - LineNo) < LinesAtBottom)
                            then
                              begin
                                StartNewPage(Sender, SectionType, SwisCode,
                                             TaxRollYear, SwisCodeDescList,
                                             PageNo, LineNo);

                                PrintTotalsPageSubheader(Sender, SectionType, LineNo);

                                HeaderPrinted := False;
                                SubheaderPrinted := False;

                              end;  {If (LinesLeft < 4)}

                          UpdateRollSectionTotals(RTSwisCodeTotalsPtr(RollSectionTotalsList[I])^,
                                                  TempRollSectionTotalRec);

                        end;  {If (RTSwisCodeTotalsPtr(RollSectionTotalsList[I])^.HomesteadCode in ['N'])}

                    {Make sure that if we had to switch pages between
                     the details and the total line that we print the headers
                     again.}

                  If not HeaderPrinted
                    then
                      begin
                        PrintSectionHeader(Sender, 'R', LineNo);
                        HeaderPrinted := True;
                      end;

                  If not SubHeaderPrinted
                    then PrintRollSectionSubheader(Sender, 'N', IsAssessingVillage, LineNo);

                    {Print the totals for this subsection.}

                  Println('');
                  PrintOneRollSectionTotal(Sender, 'N', RollSectionDescList,
                                           TempRollSectionTotalRec, IsAssessingVillage, LineNo);

                end;  {else of If (NumNonhomestead = 0)}

              end;  {If (SectionType <> 'R')}

        {Finally, do the overall totals.}

      SubheaderPrinted := False;

      OverallRollSectionTotalsList := TList.Create;
      CombineRollSectionTotals(RollSectionTotalsList, OverallRollSectionTotalsList, False);

        {FXX04231998-11: Sort the RollSection totals list into the proper order.}

      SortRollSectionList(OverallRollSectionTotalsList);

       {Initialize the temporary record for the totals for this
        subsection.}

      with TempRollSectionTotalRec do
        begin
          ParcelCount := 0;
          PartCount := 0;
          LandValue := 0;
          AssessedValue := 0;
          CountyTaxable := 0;
          TownTaxable := 0;
          VillageTaxable := 0;
          RollSection := '';

        end;  {with TempRollSectionTotalRec do}

      If PrintClassAmounts
        then
          begin
            TempSubheaderType := 'H';
            If ExtractToExcel
              then Writeln(ExtractFile, ',Overall Totals');
          end
        else TempSubheaderType := ' ';

      If (OverallRollSectionTotalsList.Count = 0)
        then
          begin
            Println('');
            PrintSectionHeader(Sender, 'R', LineNo);
            PrintRollSectionSubheader(Sender, SectionType, IsAssessingVillage, LineNo);
            ClearTabs;
            SetTab(4.5, pjCenter, 5.0, 0, BOXLINENONE, 0);   {HDR}
            Println(#9 + 'NO TOTALS AT THIS LEVEL');
            Println('');
          end
        else
          begin
            For I := 0 to (OverallRollSectionTotalsList.Count - 1) do
              begin
                  {Do we need to go to a new page?}

                with Sender as TBaseReport do
                If (LinesLeft < LinesAtBottom)
                  then
                    begin
                      StartNewPage(Sender, SectionType, SwisCode,
                                   TaxRollYear, SwisCodeDescList,
                                   PageNo, LineNo);

                      PrintTotalsPageSubheader(Sender, SectionType, LineNo);

                      HeaderPrinted := False;
                      SubheaderPrinted := False;

                    end;  {If (LinesLeft < 4)}

                If not HeaderPrinted
                  then
                    begin
                      PrintSectionHeader(Sender, 'R', LineNo);
                      HeaderPrinted := True;
                    end;

                If not SubHeaderPrinted
                  then
                    begin
                      PrintRollSectionSubheader(Sender, SectionType, IsAssessingVillage, LineNo);
                      SubheaderPrinted := True;
                    end;

                PrintOneRollSectionTotal(Sender, TempSubheaderType, RollSectionDescList,
                                         RTSwisCodeTotalsPtr(OverallRollSectionTotalsList[I])^,
                                         IsAssessingVillage, LineNo);

                UpdateRollSectionTotals(RTSwisCodeTotalsPtr(OverallRollSectionTotalsList[I])^,
                                        TempRollSectionTotalRec);

              end;  {For I := 0 to OverallRollSectionTotalsList do}

              {Make sure that if we had to switch pages between
               the details and the total line that we print the headers
               again.}

                  {Do we need to go to a new page?}

                with Sender as TBaseReport do
                If (LinesLeft < LinesAtBottom)
                  then
                    begin
                      StartNewPage(Sender, SectionType, SwisCode,
                                   TaxRollYear, SwisCodeDescList,
                                   PageNo, LineNo);

                      PrintTotalsPageSubheader(Sender, SectionType, LineNo);

                      HeaderPrinted := False;
                      SubheaderPrinted := False;

                    end;  {If (LinesLeft < 4)}

            If not HeaderPrinted
              then PrintSectionHeader(Sender, 'R', LineNo);

            If not SubHeaderPrinted
              then PrintRollSectionSubheader(Sender, SectionType, IsAssessingVillage, LineNo);

              {Print the totals for this subsection.}

            Println('');
            PrintOneRollSectionTotal(Sender, TempSubheaderType, RollSectionDescList,
                                     TempRollSectionTotalRec, IsAssessingVillage, LineNo);

          end;  {else of If (OverallRollSectionTotalsList.Count = 0)}

      FreeTList(OverallRollSectionTotalsList, SizeOf(RTSwisCodeTotals));

    end;  {with Sender as TBaseReport do}

end;  {PrintRollSectionTotalsSection}

{=======================================================================}
{=================   Village relevy TOTALS  ==============================}
{=======================================================================}
Function FoundVillageRelevyTotalRecord(    VillageRelevyTotalsList : TList;
                                           _HomesteadCode : String;
                                           CombineVillageRelevys : Boolean;
                                       var I : Integer) : Boolean;

{Search through the totals list for this print order, roll section,
 and homestead code.}

var
  J : Integer;

begin
  Result := False;

    {FXX01091998-7: Don't compare homestead codes if it is blank.}

  For J := 0 to (VillageRelevyTotalsList.Count - 1) do
    with  RTVillageRelevyTotalsPtr(VillageRelevyTotalsList[J])^ do
      If (CombineVillageRelevys or
          ((Deblank(_HomesteadCode) = '') or
           (Take(1, HomesteadCode) = Take(1, _HomesteadCode))))
        then
          begin
            Result := True;
            I := J;
          end;

end;  {FoundVillageRelevyTotalRecord}

{=======================================================================}
Procedure CombineVillageRelevyTotals(VillageRelevyTotalsList,  {List with totals broken down into hstd, nonhstd.}
                                     OverallTotalsList : TList;  {No hstd\nonhstd breakdown.}
                                     CombineVillageRelevys : Boolean);  {Should we combine the
                                                                         tax for one tax type
                                                                         down into one line?}

{The totals entries in the VillageRelevyTotalsList are broken down into homestead and
 nonhomestead, so we want to combine them for the overall totals. To do
 this, we will take the entries from the VillageRelevyTotalsList and put them into the
 overall totals list, disregarding the homestead code.}

var
  I, J : Integer;
  VillageRelevyTotalsPtr :  RTVillageRelevyTotalsPtr;

begin
  For I := 0 to (VillageRelevyTotalsList.Count - 1) do
    with RTVillageRelevyTotalsPtr(VillageRelevyTotalsList[I])^ do
      If FoundVillageRelevyTotalRecord(OverallTotalsList, HomesteadCode,
                                       CombineVillageRelevys, J)  {Don't use hstd code as a key.}
        then
          begin
              {Note that we do not add the split count again since we
               would be double counting it then.}

             RTVillageRelevyTotalsPtr(OverallTotalsList[J])^.RelevyCount :=
                      RTVillageRelevyTotalsPtr(OverallTotalsList[J])^.RelevyCount + RelevyCount;

             RTVillageRelevyTotalsPtr(OverallTotalsList[J])^.RelevyAmount :=
                      RTVillageRelevyTotalsPtr(OverallTotalsList[J])^.RelevyAmount + RelevyAmount;

          end
        else
          begin
            New(VillageRelevyTotalsPtr);   {get new pptr for tlist array}

            VillageRelevyTotalsPtr^.SwisCode := SwisCode;

            VillageRelevyTotalsPtr^.HomesteadCode := HomesteadCode;

              {FXX02101999-4: Add land value to swis and school totals.}

            VillageRelevyTotalsPtr^.RelevyAmount := RelevyAmount;
            VillageRelevyTotalsPtr^.RelevyCount := RelevyCount;

            OverallTotalsList.Add(VillageRelevyTotalsPtr);

          end;  {else of If FoundVillageRelevyRecord(OverallTotalsList, GeneralCode, ExtCode, CMFlag,}

end;  {CombineVillageRelevyTotals}

{=======================================================================}
Procedure UpdateVillageRelevyTotals(    SourceVillageRelevyTotalsRec : RTVillageRelevyTotals;
                                    var TempVillageRelevyTotalRec : RTVillageRelevyTotals);

{Update the running totals in the TempGeneralTotalRec from the source
 rec.}

begin
  with TempVillageRelevyTotalRec do
    begin
      RelevyCount := RelevyCount + SourceVillageRelevyTotalsRec.RelevyCount;
      RelevyAmount := RelevyAmount + SourceVillageRelevyTotalsRec.RelevyAmount;

    end;  {with TempVillageRelevyTotalRec do}

end;  {UpdateVillageRelevyTotals}

{=======================================================================}
Procedure PrintVillageRelevySubheader(    Sender : TObject;  {Report printer or filer object}
                                          SubheaderType : Char;  {(H)std, (N)onhstd, (S)wis, S(c)hool, (R)S, (G)rand}
                                      var LineNo : Integer);

{Print the individual General totals section header and set the tabs for the
 General amounts columns.}

begin
  with Sender as TBaseReport do
    begin
        {Roll section totals do not breakdown by hstd\nonhstd.}

      If (SubheaderType <> 'R')
        then PrintSectionSubheader(Sender, SubheaderType, LineNo);

        {FXX02101999-4: Add land value to swis and school totals.}

      ClearTabs;
      SetTab(TL1, pjLeft, TL1W, 0, BOXLINENONE, 0);   {Blank}
      SetTab(TL2, pjLeft, TL2W, 0, BOXLINENONE, 0);   {Desc}
      SetTab(TL3, pjCenter, TL3W, 0, BOXLINENONE, 0);   {PRCL CNT}
      SetTab(TL4, pjCenter, (TL4W + 1), 0, BOXLINENONE, 0);   {Relevy Amount}

      Println('');
      Println(#9 + #9 +
              #9 + 'TOTAL' +
              #9 + 'RELEVY');
      Println(#9 +
              #9 + 'DESCRIPTION' +
              #9 + 'PARCELS' +
              #9 + 'AMOUNT');

        LineNo := LineNo + 1;

       {FXX12291997-2: Print a blank line between the header and the start
                       of the information.}

      Println('');
      LineNo := LineNo + 1;

    end;  {with Sender as TBaseReport do}

end;  {PrintVillageRelevySubheader}

{=======================================================================}
Procedure PrintOneVillageRelevyTotal(    Sender : TObject;  {Report printer or filer object}
                                         SubheaderType : Char;  {(H)std, (N)onhstd, (S)wis, S(c)hool, (R)S, (G)rand}
                                         VillageRelevyTotalsRec : RTVillageRelevyTotals;
                                         TotalsRecord : Boolean;
                                     var LineNo : Integer);

{Print one general tax total.}

begin
    {FXX02101999-4: Add land value to swis and school totals.}

  with Sender as TBaseReport do
    begin
        {Reset the tabs}

      ClearTabs;
      SetTab(TL1, pjLeft, TL1W, 0, BOXLINENONE, 0);   {Blank}
      SetTab(TL2, pjLeft, TL2W, 0, BOXLINENONE, 0);   {Desc}
      SetTab(TL3, pjRight, TL3W, 0, BOXLINENONE, 0);   {PRCL CNT}
      SetTab(TL4, pjRight, (TL4W + 1), 0, BOXLINENONE, 0);   {Relevy amount}

      with VillageRelevyTotalsRec do
        begin
          If TotalsRecord
            then Print(#9 + #9 + 'TOTAL')
            else Print(#9 + #9 + 'VILLAGE RELEVY');

          Print(#9 + IntToStr(RelevyCount));

          Println(#9 + FormatFloat(DecimalDisplay_BlankZero, RelevyAmount));

            {CHG02012004-5(2.08): Option to print to Excel.}

          If ExtractToExcel
            then
              begin
                If TotalsRecord
                  then Write(ExtractFile, 'TOTAL')
                  else Write(ExtractFile, 'VILLAGE RELEVY');

                Writeln(ExtractFile, FormatExtractField(IntToStr(RelevyCount)),
                                     FormatExtractField(FormatFloat(DecimalDisplay_BlankZero, RelevyAmount)));

              end;  {If ExtractToExcel}

        end;  {with VillageRelevyTotalsRec do}

    end;  {with Sender as TBaseReport do}

  LineNo := LineNo + 1;

end;  {PrintOneVillageRelevyTotal}

{=======================================================================}
Procedure PrintVillageRelevyTotalsSection(    Sender : TObject;  {Report printer or filer object}
                                              VillageRelevyTotalsList : TList;
                                              TaxRollYear : String;
                                              SwisCode : String;
                                              SwisCodeDescList : TList;
                                              PrintClassAmounts : Boolean;
                                              SectionType : Char;
                                          var PageNo,
                                              LineNo : Integer);

{Print the roll section totals in the TLists.}

var
  I, NumHomestead, NumNonhomestead : Integer;
  HeaderPrinted, SubheaderPrinted : Boolean;
  OverallVillageRelevyTotalsList : TList;
  TempVillageRelevyTotalRec : RTVillageRelevyTotals;

begin
  HeaderPrinted := False;
  NumHomestead := 0;
  NumNonhomestead := 0;

  For I := 0 to (VillageRelevyTotalsList.Count - 1) do
    with RTVillageRelevyTotalsPtr(VillageRelevyTotalsList[I])^ do
      If (HomesteadCode = 'N')
        then NumNonhomestead := NumNonhomestead + 1
        else NumHomestead := NumHomestead + 1;

  If FirstPageOfReport
    then
      begin
        PrintHeader(Sender, SectionType, SwisCode,
                    TaxRollYear, SwisCodeDescList,
                    PageNo, LineNo);
        FirstPageOfReport := False;
      end
    else StartNewPage(Sender, SectionType, SwisCode,
                      TaxRollYear, SwisCodeDescList,
                      PageNo, LineNo);

    {CHG02012004-5(2.08): Option to print to Excel.}

  If ExtractToExcel
    then
      begin
        Writeln(ExtractFile);
        Writeln(ExtractFile, 'Village Relevy Totals');
        Writeln(ExtractFile, 'Description,',
                             'Parcel Count,',
                             'Relevy Amount');

      end;  {If ExtractToExcel}

  with Sender as TBaseReport do
    begin
        {First homestead part, but only if this is not a roll section summary.
         Note that we print the header and subheader only if there is an
         entry.}

      If PrintClassAmounts
        then
          begin
            SubheaderPrinted := False;

              {Initialize the temporary record for the totals for this
               subsection.}

            with TempVillageRelevyTotalRec do
              begin
                RelevyCount := 0;
                RelevyAmount := 0;

              end;  {with TempVillageRelevyTotalRec do}

            If (NumHomestead = 0)
              then
                begin
                  Println('');
                  PrintSectionHeader(Sender, 'V', LineNo);
                  PrintVillageRelevySubheader(Sender, 'H', LineNo);
                  ClearTabs;
                  SetTab(4.5, pjCenter, 5.0, 0, BOXLINENONE, 0);   {HDR}
                  Println(#9 + 'NO TOTALS AT THIS LEVEL');
                  Println('');
                end
              else
                begin
                  For I := 0 to (VillageRelevyTotalsList.Count - 1) do
                    If (RTVillageRelevyTotalsPtr(VillageRelevyTotalsList[I])^.HomesteadCode[1] in ['H', ' '])
                      then
                        begin
                          If not HeaderPrinted
                            then
                              begin
                                PrintSectionHeader(Sender, 'V', LineNo);
                                HeaderPrinted := True;
                              end;

                          If not SubHeaderPrinted
                            then
                              begin
                                PrintVillageRelevySubheader(Sender, 'H', LineNo);
                                SubheaderPrinted := True;
                              end;

                          PrintOneVillageRelevyTotal(Sender, 'H',
                                                     RTVillageRelevyTotalsPtr(VillageRelevyTotalsList[I])^,
                                                     False, LineNo);

                            {Do we need to go to a new page?}
                            {FXX04231998-9: Instead of print the roll section hdr for
                                            the totals sections, print the section type.}

                          If ((NumLinesPerPage - LineNo) < LinesAtBottom)
                            then
                              begin
                                StartNewPage(Sender, SectionType, SwisCode,
                                             TaxRollYear, SwisCodeDescList,
                                             PageNo, LineNo);

                                PrintTotalsPageSubheader(Sender, SectionType, LineNo);

                                HeaderPrinted := False;
                                SubheaderPrinted := False;

                              end;  {If (LinesLeft < 4)}

                          UpdateVillageRelevyTotals(RTVillageRelevyTotalsPtr(VillageRelevyTotalsList[I])^,
                                                  TempVillageRelevyTotalRec);

                        end;  {If (RTVillageRelevyTotalsPtr(VillageRelevyTotalsList[I])^.HomesteadCode in ['H', ' '])}

                    {Make sure that if we had to switch pages between
                     the details and the total line that we print the headers
                     again.}

                  If not HeaderPrinted
                    then
                      begin
                        PrintSectionHeader(Sender, 'V', LineNo);
                        HeaderPrinted := True;
                      end;

                  If not SubHeaderPrinted
                    then PrintVillageRelevySubheader(Sender, 'H', LineNo);

                    {Print the totals for this subsection.}

                  Println('');
                  PrintOneVillageRelevyTotal(Sender, 'H',
                                            TempVillageRelevyTotalRec,
                                            False, LineNo);

                end;  {else of If (NumHomestead = 0)}

          end;  {If (SectionType <> 'R')}

        {Now the non-homestead part, if these are not roll section totals.}

      If PrintClassAmounts
        then
          begin
            SubheaderPrinted := False;

              {Initialize the temporary record for the totals for this
               subsection.}

            with TempVillageRelevyTotalRec do
              begin
                RelevyCount := 0;
                RelevyAmount := 0;

              end;  {with TempVillageRelevyTotalRec do}

            If (NumNonhomestead = 0)
              then
                begin
                  Println('');
                  PrintSectionHeader(Sender, 'V', LineNo);
                  PrintVillageRelevySubheader(Sender, 'N', LineNo);
                  ClearTabs;
                  SetTab(4.5, pjCenter, 5.0, 0, BOXLINENONE, 0);   {HDR}
                  Println(#9 + 'NO TOTALS AT THIS LEVEL');
                  Println('');
                end
              else
                begin
                  For I := 0 to (VillageRelevyTotalsList.Count - 1) do
                    If (RTVillageRelevyTotalsPtr(VillageRelevyTotalsList[I])^.HomesteadCode[1] = 'N')
                      then
                        begin
                          If not HeaderPrinted
                            then
                              begin
                                PrintSectionHeader(Sender, 'V', LineNo);
                                HeaderPrinted := True;
                              end;

                          If not SubHeaderPrinted
                            then
                              begin
                                PrintVillageRelevySubheader(Sender, 'N', LineNo);
                                SubheaderPrinted := True;
                              end;

                          PrintOneVillageRelevyTotal(Sender, 'N',
                                                    RTVillageRelevyTotalsPtr(VillageRelevyTotalsList[I])^,
                                                    False, LineNo);

                            {Do we need to go to a new page?}

                          If ((NumLinesPerPage - LineNo) < LinesAtBottom)
                            then
                              begin
                                StartNewPage(Sender, SectionType, SwisCode,
                                             TaxRollYear, SwisCodeDescList,
                                             PageNo, LineNo);

                                PrintTotalsPageSubheader(Sender, SectionType, LineNo);

                                HeaderPrinted := False;
                                SubheaderPrinted := False;

                              end;  {If (LinesLeft < 4)}

                          UpdateVillageRelevyTotals(RTVillageRelevyTotalsPtr(VillageRelevyTotalsList[I])^,
                                                  TempVillageRelevyTotalRec);

                        end;  {If (RTVillageRelevyTotalsPtr(VillageRelevyTotalsList[I])^.HomesteadCode in ['N'])}

                    {Make sure that if we had to switch pages between
                     the details and the total line that we print the headers
                     again.}

                  If not HeaderPrinted
                    then
                      begin
                        PrintSectionHeader(Sender, 'V', LineNo);
                        HeaderPrinted := True;
                      end;

                  If not SubHeaderPrinted
                    then PrintVillageRelevySubheader(Sender, 'N', LineNo);

                    {Print the totals for this subsection.}

                  Println('');
                  PrintOneVillageRelevyTotal(Sender, 'N',
                                             TempVillageRelevyTotalRec,
                                             False, LineNo);

                end;  {else of If (NumNonhomestead = 0)}

              end;  {If (SectionType <> 'R')}

        {Finally, do the overall totals.}

      SubheaderPrinted := False;

      OverallVillageRelevyTotalsList := TList.Create;
      CombineVillageRelevyTotals(VillageRelevyTotalsList, OverallVillageRelevyTotalsList, False);

       {Initialize the temporary record for the totals for this
        subsection.}

      with TempVillageRelevyTotalRec do
        begin
          RelevyCount := 0;
          RelevyAmount := 0;

        end;  {with TempVillageRelevyTotalRec do}

      If (OverallVillageRelevyTotalsList.Count = 0)
        then
          begin
            Println('');
            PrintSectionHeader(Sender, 'V', LineNo);
            PrintVillageRelevySubheader(Sender, SectionType, LineNo);
            ClearTabs;
            SetTab(4.5, pjCenter, 5.0, 0, BOXLINENONE, 0);   {HDR}
            Println(#9 + 'NO TOTALS AT THIS LEVEL');
            Println('');
          end
        else
          begin
            For I := 0 to (OverallVillageRelevyTotalsList.Count - 1) do
              begin
                  {Do we need to go to a new page?}

                with Sender as TBaseReport do
                If (LinesLeft < LinesAtBottom)
                  then
                    begin
                      StartNewPage(Sender, SectionType, SwisCode,
                                   TaxRollYear, SwisCodeDescList,
                                   PageNo, LineNo);

                      PrintTotalsPageSubheader(Sender, SectionType, LineNo);

                      HeaderPrinted := False;
                      SubheaderPrinted := False;

                    end;  {If (LinesLeft < 4)}

                If not HeaderPrinted
                  then
                    begin
                      PrintSectionHeader(Sender, 'V', LineNo);
                      HeaderPrinted := True;
                    end;

                If not SubHeaderPrinted
                  then
                    begin
                      PrintVillageRelevySubheader(Sender, SectionType, LineNo);
                      SubheaderPrinted := True;
                    end;

                PrintOneVillageRelevyTotal(Sender, ' ',
                                           RTVillageRelevyTotalsPtr(OverallVillageRelevyTotalsList[I])^,
                                           False, LineNo);

                UpdateVillageRelevyTotals(RTVillageRelevyTotalsPtr(OverallVillageRelevyTotalsList[I])^,
                                        TempVillageRelevyTotalRec);

              end;  {For I := 0 to OverallVillageRelevyTotalsList do}

              {Make sure that if we had to switch pages between
               the details and the total line that we print the headers
               again.}

                  {Do we need to go to a new page?}

                with Sender as TBaseReport do
                If (LinesLeft < LinesAtBottom)
                  then
                    begin
                      StartNewPage(Sender, SectionType, SwisCode,
                                   TaxRollYear, SwisCodeDescList,
                                   PageNo, LineNo);

                      PrintTotalsPageSubheader(Sender, SectionType, LineNo);

                      HeaderPrinted := False;
                      SubheaderPrinted := False;

                    end;  {If (LinesLeft < 4)}

            If not HeaderPrinted
              then PrintSectionHeader(Sender, 'V', LineNo);

            If not SubHeaderPrinted
              then PrintVillageRelevySubheader(Sender, SectionType, LineNo);

              {Print the totals for this subsection.}

            Println('');
            PrintOneVillageRelevyTotal(Sender, SectionType,
                                       TempVillageRelevyTotalRec, True, LineNo);

          end;  {else of If (OverallVillageRelevyTotalsList.Count = 0)}

      FreeTList(OverallVillageRelevyTotalsList, SizeOf(RTVillageRelevyTotals));

    end;  {with Sender as TBaseReport do}

end;  {PrintVillageRelevyTotalsSection}

{=======================================================================}
{=================   Prorata TOTALS  ==============================}
{=======================================================================}
Function FoundProrataTotalRecord(    ProrataTotalsList : TList;
                                     _SwisCode : String;
                                     _SDCode : String;
                                 var I : Integer) : Boolean;

{Search through the totals list for this print order, roll section,
 and homestead code.}

var
  J : Integer;

begin
  Result := False;

  For J := 0 to (ProrataTotalsList.Count - 1) do
    with RTRS9TotalsPtr(ProrataTotalsList[J])^ do
      If ((Take(5, SDCode) = Take(5, _SDCode)) and
          (Take(6, SwisCode) = Take(6, _SwisCode)))
        then
          begin
            Result := True;
            I := J;
          end;

end;  {FoundProrataTotalRecord}

{=======================================================================}
Procedure CombineProrataTotals(ProrataTotalsList,  {List with totals broken down into hstd, nonhstd.}
                               OverallTotalsList : TList;  {No hstd\nonhstd breakdown.}
                               CombineProratas : Boolean);  {Should we combine the
                                                             tax for one tax type
                                                             down into one line?}

{The totals entries in the ProrataTotalsList are broken down into homestead and
 nonhomestead, so we want to combine them for the overall totals. To do
 this, we will take the entries from the ProrataTotalsList and put them into the
 overall totals list, disregarding the homestead code.}

var
  I, J : Integer;
  ProrataTotalsPtr :  RtRS9TotalsPtr;

begin
  For I := 0 to (ProrataTotalsList.Count - 1) do
    with RTRS9TotalsPtr(ProrataTotalsList[I])^ do
      If FoundProrataTotalRecord(OverallTotalsList, SwisCode, SDCode, J)
        then
          begin
            RTRS9TotalsPtr(OverallTotalsList[J])^.Amount :=
                      RTRS9TotalsPtr(OverallTotalsList[J])^.Amount + Amount;
            RTRS9TotalsPtr(OverallTotalsList[J])^.ParcelCount :=
                      RTRS9TotalsPtr(OverallTotalsList[J])^.ParcelCount + ParcelCount;

          end
        else
          begin
            New(ProrataTotalsPtr);   {get new pptr for tlist array}

            ProrataTotalsPtr^.SwisCode := SwisCode;
            ProrataTotalsPtr^.SDCode := SDCode;

            ProrataTotalsPtr^.Amount := Amount;
            ProrataTotalsPtr^.ParcelCount := ParcelCount;

            OverallTotalsList.Add(ProrataTotalsPtr);

          end;  {else of If FoundProrataRecord(OverallTotalsList, GeneralCode, ExtCode, CMFlag,}

end;  {CombineProrataTotals}

{=======================================================================}
Procedure UpdateProrataTotals(    SourceProrataTotalsRec : RtRS9Totals;
                              var TempProrataTotalRec : RtRS9Totals);

{Update the running totals in the TempGeneralTotalRec from the source
 rec.}

begin
  with TempProrataTotalRec do
    begin
      ParcelCount := ParcelCount + SourceProrataTotalsRec.ParcelCount;
      Amount := Amount + SourceProrataTotalsRec.Amount;

    end;  {with TempProrataTotalRec do}

end;  {UpdateProrataTotals}

{=======================================================================}
Procedure PrintProrataSubheader(    Sender : TObject;  {Report printer or filer object}
                                    SubheaderType : Char;  {(H)std, (N)onhstd, (S)wis, S(c)hool, (R)S, (G)rand}
                                var LineNo : Integer);

{Print the individual General totals section header and set the tabs for the
 General amounts columns.}

begin
  with Sender as TBaseReport do
    begin
        {Roll section totals do not breakdown by hstd\nonhstd.}

      If (SubheaderType <> 'R')
        then PrintSectionSubheader(Sender, SubheaderType, LineNo);

        {FXX02101999-4: Add land value to swis and school totals.}

      ClearTabs;
      SetTab(TL1, pjLeft, TL1W, 0, BOXLINENONE, 0);   {SD Code}
      SetTab(TL2, pjLeft, TL2W, 0, BOXLINENONE, 0);   {Desc}
      SetTab(TL3, pjCenter, TL3W, 0, BOXLINENONE, 0);   {PRCL CNT}
      SetTab(TL4, pjCenter, (TL4W + 1), 0, BOXLINENONE, 0);   {Relevy Amount}

      Println('');
      Println(#9 +
              #9 + 'SD' +
              #9 + 'TOTAL' +
              #9 + '');
      Println(#9 + 'CODE' +
              #9 + 'DESCRIPTION' +
              #9 + 'PARCELS' +
              #9 + 'AMOUNT');

        LineNo := LineNo + 1;

       {FXX12291997-2: Print a blank line between the header and the start
                       of the information.}

      Println('');
      LineNo := LineNo + 1;

    end;  {with Sender as TBaseReport do}

end;  {PrintProrataSubheader}

{=======================================================================}
Procedure PrintOneProrataTotal(    Sender : TObject;  {Report printer or filer object}
                                   SubheaderType : Char;  {(H)std, (N)onhstd, (S)wis, S(c)hool, (R)S, (G)rand}
                                   ProrataTotalsRec : RtRS9Totals;
                                   SDCodeDescList : TList;
                                   TotalsRecord : Boolean;
                               var LineNo : Integer);

{Print one general tax total.}

begin
    {FXX02101999-4: Add land value to swis and school totals.}

  with Sender as TBaseReport do
    begin
        {Reset the tabs}

      ClearTabs;
      SetTab(TL1, pjLeft, TL1W, 0, BOXLINENONE, 0);   {SDCode}
      SetTab(TL2, pjLeft, TL2W, 0, BOXLINENONE, 0);   {Desc}
      SetTab(TL3, pjRight, TL3W, 0, BOXLINENONE, 0);   {PRCL CNT}
      SetTab(TL4, pjRight, (TL4W + 1), 0, BOXLINENONE, 0);   {Relevy amount}

      with ProrataTotalsRec do
        begin
          If TotalsRecord
            then Print(#9 + 'TOTAL' +
                       #9)
            else Print(#9 + SDCode +
                       #9 + UpcaseStr(Take(15, GetDescriptionFromList(SDCode, SDCodeDescList))));

          Print(#9 + IntToStr(ParcelCount));

          Println(#9 + FormatFloat(DecimalDisplay_BlankZero, Amount));

        end;  {with ProrataTotalsRec do}

    end;  {with Sender as TBaseReport do}

  LineNo := LineNo + 1;

end;  {PrintOneProrataTotal}

{=======================================================================}
Procedure PrintProrataTotalsSection(    Sender : TObject;  {Report printer or filer object}
                                        ProrataTotalsList : TList;
                                        TaxRollYear : String;
                                        SwisCode : String;
                                        SwisCodeDescList,
                                        SDCodeDescList : TList;
                                        SectionType : Char;
                                    var PageNo,
                                        LineNo : Integer);

{Print the roll section totals in the TLists.}

var
  I : Integer;
  HeaderPrinted, SubheaderPrinted : Boolean;
  OverallProrataTotalsList : TList;
  TempProrataTotalRec : RtRS9Totals;

begin
  HeaderPrinted := False;

  If FirstPageOfReport
    then
      begin
        PrintHeader(Sender, SectionType, SwisCode,
                    TaxRollYear, SwisCodeDescList,
                    PageNo, LineNo);
        FirstPageOfReport := False;
      end
    else StartNewPage(Sender, SectionType, SwisCode,
                      TaxRollYear, SwisCodeDescList,
                      PageNo, LineNo);

  with Sender as TBaseReport do
    begin
      SubheaderPrinted := False;

      OverallProrataTotalsList := TList.Create;
      CombineProrataTotals(ProrataTotalsList, OverallProrataTotalsList, False);

       {Initialize the temporary record for the totals for this
        subsection.}

      with TempProrataTotalRec do
        begin
          ParcelCount := 0;
          Amount := 0;

        end;  {with TempProrataTotalRec do}

      If (OverallProrataTotalsList.Count = 0)
        then
          begin
            Println('');
            PrintSectionHeader(Sender, 'P', LineNo);
            PrintProrataSubheader(Sender, SectionType, LineNo);
            ClearTabs;
            SetTab(4.5, pjCenter, 5.0, 0, BOXLINENONE, 0);   {HDR}
            Println(#9 + 'NO TOTALS AT THIS LEVEL');
            Println('');
          end
        else
          begin
            For I := 0 to (OverallProrataTotalsList.Count - 1) do
              begin
                  {Do we need to go to a new page?}

                with Sender as TBaseReport do
                If (LinesLeft < LinesAtBottom)
                  then
                    begin
                      StartNewPage(Sender, SectionType, SwisCode,
                                   TaxRollYear, SwisCodeDescList,
                                   PageNo, LineNo);

                      PrintTotalsPageSubheader(Sender, SectionType, LineNo);

                      HeaderPrinted := False;
                      SubheaderPrinted := False;

                    end;  {If (LinesLeft < 4)}

                If not HeaderPrinted
                  then
                    begin
                      PrintSectionHeader(Sender, 'P', LineNo);
                      HeaderPrinted := True;
                    end;

                If not SubHeaderPrinted
                  then
                    begin
                      PrintProrataSubheader(Sender, SectionType, LineNo);
                      SubheaderPrinted := True;
                    end;

                PrintOneProrataTotal(Sender, ' ',
                                     RTRS9TotalsPtr(OverallProrataTotalsList[I])^,
                                     SDCodeDescList, False, LineNo);

                UpdateProrataTotals(RTRS9TotalsPtr(OverallProrataTotalsList[I])^,
                                                   TempProrataTotalRec);

              end;  {For I := 0 to OverallProrataTotalsList do}

              {Make sure that if we had to switch pages between
               the details and the total line that we print the headers
               again.}

                  {Do we need to go to a new page?}

                with Sender as TBaseReport do
                If (LinesLeft < LinesAtBottom)
                  then
                    begin
                      StartNewPage(Sender, SectionType, SwisCode,
                                   TaxRollYear, SwisCodeDescList,
                                   PageNo, LineNo);

                      PrintTotalsPageSubheader(Sender, SectionType, LineNo);

                      HeaderPrinted := False;
                      SubheaderPrinted := False;

                    end;  {If (LinesLeft < 4)}

            If not HeaderPrinted
              then PrintSectionHeader(Sender, 'P', LineNo);

            If not SubHeaderPrinted
              then PrintProrataSubheader(Sender, SectionType, LineNo);

              {Print the totals for this subsection.}

            Println('');
            PrintOneProrataTotal(Sender, SectionType,
                                 TempProrataTotalRec,
                                 SDCodeDescList, True, LineNo);

          end;  {else of If (OverallProrataTotalsList.Count = 0)}

      FreeTList(OverallProrataTotalsList, SizeOf(RtRS9Totals));

    end;  {with Sender as TBaseReport do}

end;  {PrintProrataTotalsSection}

{===================================================================}
Procedure TRollTotalReport.PrintTotals(Sender : TObject;
                                       SwisCode : String;
                                       SectionType : Char);

var
  TotalsByVillageRelevyList,
  TotalsByProrataList,
  TotalsBySchoolList, TotalsByExemptionList,
  TotalsBySpecialDistrictList, TotalsByRollSectionList : TList;
  SwisCodes : TStringList;
  I : Integer;
  _Found, IsAssessingVillage : Boolean;

begin
  LineNo := 1;
  SwisCodes := TStringList.Create;
  IsAssessingVillage := False;

    {FXX10041999-7: Make sure to pass the year in for history load.}

  If TotalsOnly
    then
      begin
        For I := 0 to (SelectedSwisCodes.Count - 1) do
          SwisCodes.Add(SelectedSwisCodes[I]);
      end
    else
      begin
        SwisCodes.Add(SwisCode);

        _Found := FindKeyOld(SwisCodeTable, ['SwisCode'], [SwisCode]);

        If _Found
          then IsAssessingVillage := SwisCodeTable.FieldByName('AssessingVillage').AsBoolean;

      end;  {If TotalsOnly}

    {CHG01192004-2(2.08): Print the roll totals page first.}

  If PrintRollSectionTotals
    then
      begin
        TotalsByRollSectionList := TList.Create;
        LoadTotalsByRollSectionList(TotalsByRollSectionList, TotalsByRollSectionTable, SwisCodes,
                                    TotalsOnly, PrintClassAmounts, TaxRollYear);
        PrintRollSectionTotalsSection(Sender, TotalsByRollSectionList, TaxRollYear,
                                      SwisCode, RollSectionDescList,
                                      SwisCodeDescList, PrintClassAmounts,
                                      SectionType, IsAssessingVillage, PageNo, LineNo);
        FreeTList(TotalsByRollSectionList, SizeOf(RTSwisCodeTotals));

      end;  {If PrintRollSectionTotals}

  If PrintSchoolTotals
    then
      begin
        TotalsBySchoolList := TList.Create;
        LoadTotalsBySchoolList(TotalsBySchoolList, TotalsBySchoolTable, SwisCodes,
                               TotalsOnly, PrintClassAmounts, TaxRollYear);
        PrintSchoolTotalsSection(Sender, TotalsBySchoolList, TaxRollYear,
                                 SwisCode, SchoolCodeDescList,
                                 SwisCodeDescList, PrintClassAmounts,
                                 SectionType, PageNo, LineNo);
        FreeTList(TotalsBySchoolList, SizeOf(RTSchoolTotals));

      end;  {If PrintSchoolTotals}

  If PrintExemptionTotals
    then
      begin
        TotalsByExemptionList := TList.Create;
        LoadTotalsByExemptionList(TotalsByExemptionList, TotalsByExemptionTable, SwisCodes,
                                  TotalsOnly, PrintClassAmounts, TaxRollYear);
        PrintExemptionTotalsSection(Sender, TotalsByExemptionList, TaxRollYear,
                                    SwisCode, EXCodeDescList,
                                    SwisCodeDescList, PrintClassAmounts,
                                    SectionType, IsAssessingVillage, PageNo, LineNo);
        FreeTList(TotalsByExemptionList, SizeOf(RTEXCodeTotals));

      end;  {If PrintExemptionTotals}

  If PrintSpecialDistrictTotals
    then
      begin
        TotalsBySpecialDistrictList := TList.Create;
        LoadTotalsBySpecialDistrictList(TotalsBySpecialDistrictList, TotalsBySpecialDistrictTable, SwisCodes,
                                        TotalsOnly, PrintClassAmounts, False, TaxRollYear);
        PrintSpecialDistrictTotalsSection(Sender, TotalsBySpecialDistrictList, TaxRollYear,
                                          SwisCode, SDCodeDescList, SDExtCodeDescList,
                                          SwisCodeDescList, SectionType, PageNo, LineNo);
        FreeTList(TotalsBySpecialDistrictList, SizeOf(RtSDCodeTotals));

      end;  {If PrintSpecialDistrictTotals}

		{FXX12121999-1: Need to actually print village relevies.}

  If (PrintVillageRelevyTotals and
      (ProcessingType <> NextYear))
    then
      begin
        TotalsByVillageRelevyList := TList.Create;
        LoadTotalsByVillageRelevyList(TotalsByVillageRelevyList, TotalsByVillageRelevyTable, SwisCodes,
                                      TotalsOnly, PrintClassAmounts, TaxRollYear);

        If (TotalsByVillageRelevyList.Count > 0)
          then PrintVillageRelevyTotalsSection(Sender, TotalsByVillageRelevyList,
	                                  		       TaxRollYear, SwisCode,
                                               SwisCodeDescList, PrintClassAmounts,
                                               SectionType, PageNo, LineNo);
        FreeTList(TotalsByVillageRelevyList, SizeOf(RTVillageRelevyTotals));

      end;  {If PrintVillageRelevyTotals}

  If (PrintProrataTotals and
      (ProcessingType <> NextYear))
    then
      begin
        TotalsByProrataList := TList.Create;
        LoadTotalsByProrataList(TotalsByProrataList, TotalsByProrataTable, SwisCodes,
                                TotalsOnly, TaxRollYear);

        If (TotalsByProrataList.Count > 0)
          then PrintProrataTotalsSection(Sender, TotalsByProrataList,
             	                		       TaxRollYear, SwisCode,
                                         SwisCodeDescList, SDCodeDescList,
                                         SectionType, PageNo, LineNo);
        FreeTList(TotalsByProrataList, SizeOf(RtRS9Totals));

      end;  {If PrintProrataTotals}

  SwisCodes.Free;

end;  {PrintTotals}

{===================================================================}
Procedure TRollTotalReport.TextFilerPrint(Sender: TObject);

var
  I : Integer;
  Quit : Boolean;

begin
  PrintingPanel.Visible := True;
  Application.ProcessMessages;

    {FXX07391999-1: Was printing page 2 at top of each page because page
                    kept getting set back to 1.}

  PageNo := 1;
  LineNo := 1;

  EXCodeDescList := TList.Create;
  SDCodeDescList := TList.Create;
  SwisCodeDescList := TList.Create;
  SchoolCodeDescList := TList.Create;
  SDExtCodeDescList := TList.Create;
  RollSectionDescList := TList.Create;
  SDExtCategoryList := TList.Create;

  LoadSDExtCategoryList(SDExtCategoryList, Quit);

  LoadCodeList(RollSectionDescList, 'ZRollSectionTbl',
               'MainCode', 'Description', Quit);

  LoadCodeList(SDExtCodeDescList, 'ZSDExtCodeTbl',
               'MainCode', 'Description', Quit);

    {FXX08182008-1(2.15.1.6)[D1366]: Open the tables based on the processing type in order to avoid
                                     unknown descriptions.}

  LoadCodeList(EXCodeDescList,
               DetermineTableNameForProcessingType('TExCodeTbl', ProcessingType),
               'ExCode', 'Description', Quit);

  LoadCodeList(SDCodeDescList,
               DetermineTableNameForProcessingType('TSDCodeTbl', ProcessingType),
               'SDistCode', 'Description', Quit);

  LoadCodeList(SwisCodeDescList,
               DetermineTableNameForProcessingType('TSwisTbl', ProcessingType),
               'SwisCode', 'MunicipalityName', Quit);

  LoadCodeList(SchoolCodeDescList,
               DetermineTableNameForProcessingType('TSchoolTbl', ProcessingType),
               'SchoolCode', 'SchoolName', Quit);

    {FXX06262005-1(2.8.5.2)[2156]: Fix the error where a person selects swis codes,
                                   has totals only, and gets blank paper.}

  If _Compare(SelectedSwisCodes.Count, SwisCodeListBox.Items.Count, coLessThan)
    then TotalsOnly := False;

  If not TotalsOnly
    then
      For I := 0 to (SelectedSwisCodes.Count - 1) do
        begin
          (*If (I > 0)
            then StartNewPage(Sender, 'S',
                              SelectedSwisCodes[I],
                              TaxRollYear, SwisCodeDescList,
                              PageNo, LineNo); *)
          PrintTotals(Sender, SelectedSwisCodes[I], 'S');

        end;  {If not TotalsOnly}

    {Now print the grand totals (only if they are printing > 1 swis.}
    {FXX02101999-5: If there is only one swis code and they select totals
                    only, print it.}

  If (((SelectedSwisCodes.Count > 1) and
       (SwisCodeTable.RecordCount > 1)) or
      ((SwisCodeTable.RecordCount = 1) and
       TotalsOnly))
    then
      begin
          {FXX02191999-4: Don't need to print a new page if this is totals only - already
                          taken care of.}
          {FXX01232000-1: No longer need to start new page if print by swis - taken
                          care of in individual section prints.}

(*        If not TotalsOnly
          then StartNewPage(Sender, 'M',
                            Take(4, SwisCodeTable.FieldByName('SWISSwisCode').Text),
                            TaxRollYear, SwisCodeDescList,
                            PageNo, LineNo);*)

          {FXX12172001-2: Only do a take 2 on the swis code for villages
                          that go across 2 towns.}

        TotalsOnly := True;
        PrintTotals(Sender, Take(2, SwisCodeTable.FieldByName('SwisCode').Text),
                    'M');

      end;  {If (SelectedSwisCodes.Count > 1)}

  FreeTList(RollSectionDescList, SizeOf(CodeRecord));
  FreeTList(EXCodeDescList, SizeOf(CodeRecord));
  FreeTList(SDCodeDescList, SizeOf(CodeRecord));
  FreeTList(SwisCodeDescList, SizeOf(CodeRecord));
  FreeTList(SchoolCodeDescList, SizeOf(CodeRecord));
  FreeTList(SDExtCodeDescList, SizeOf(CodeRecord));
  FreeTList(SDExtCategoryList, SizeOf(SDExtCategoryRecord));

  PrintingPanel.Visible := False;

end;  {TextFilerPrint}

{===================================================================}
Procedure TRollTotalReport.PrintReport(Sender: TObject);

var
  TempTextFile : TextFile;

begin
  AssignFile(TempTextFile, TextFiler.FileName);
  Reset(TempTextFile);

        {CHG12211998-1: Add ability to select print range.}

  PrintTextReport(Sender, TempTextFile, PrintDialog.FromPage,
                  PrintDialog.ToPage);

  CloseFile(TempTextFile);

end;  {PrintReport}

{===================================================================}
Procedure TRollTotalReport.FormClose(    Sender: TObject;
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
