unit rCertiorariCalender;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, DBCtrls,  DB, Buttons, Grids,
  Wwdbigrd, Wwdbgrid, ExtCtrls, Wwdatsrc, Menus,
  DBTables, Wwtable, Btrvdlg, RPFiler, RPBase, RPCanvas, RPrinter, Mask,
  Gauges, RPMemo, RPDBUtil, RPDefine, (*Progress,*) Types, RPTXFilr, PASTypes,
  Progress, TabNotBk, ComCtrls;

type
  TCertiorariCalendarReportForm = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    ScrollBox: TScrollBox;
    CloseButton: TBitBtn;
    TitleLabel: TLabel;
    ReportPrinter: TReportPrinter;
    ReportFiler: TReportFiler;
    PrintDialog: TPrintDialog;
    CertiorariTable: TwwTable;
    PrintButton: TBitBtn;
    LoadButton: TBitBtn;
    SaveButton: TBitBtn;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    CertiorariCalendarTable: TTable;
    GroupBox1: TGroupBox;
    CreateParcelListCheckBox: TCheckBox;
    PrintNotesCheckBox: TCheckBox;
    DateGroupBox: TGroupBox;
    Label7: TLabel;
    Label8: TLabel;
    AllDatesCheckBox: TCheckBox;
    ToEndofDatesCheckBox: TCheckBox;
    EndDateEdit: TMaskEdit;
    StartDateEdit: TMaskEdit;
    TrialTypeRadioGroup: TRadioGroup;
    PrintOrderRadioGroupBox: TRadioGroup;
    SchoolCodeTable: TTable;
    SortCertiorariTable: TTable;
    UseAlternateIDCheckBox: TCheckBox;
    GridFormatCheckBox: TCheckBox;
    ExtractToExcelCheckBox: TCheckBox;
    CertiorariNotesTable: TTable;
    SortCertiorariCalendarHdrTable: TTable;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure PrintButtonClick(Sender: TObject);
    procedure CloseButtonClick(Sender: TObject);
    procedure ReportPrint(Sender: TObject);
    procedure LoadButtonClick(Sender: TObject);
    procedure SaveButtonClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure ReportPrintHeader(Sender: TObject);
    procedure AllDatesCheckBoxClick(Sender: TObject);
    procedure ToEndofDatesCheckBoxClick(Sender: TObject);
    procedure GridFormatCheckBoxClick(Sender: TObject);
  private
    { Private declarations }
  public
    ReportCancelled : Boolean;

    { Public declarations }
    UnitName, OrigSortFileName, OrigHeaderSortFileName : String;
    UseAlternateID : Boolean;

    IncludeResults, PrintNotes,
    CreateParcelList, ExtractToExcel,
    PrintAllDates, PrintToEndOfDates : Boolean;
    ExtractFile : TextFile;

    StartDate, EndDate : TDateTime;

    PrintOrder, LinesLeftAtBottom,
    TrialType, ReportFormat : Integer;

    Procedure InitializeForm;  {Open the ScreenLabelTables and setup.}

    Procedure FillSortTable(var Quit : Boolean);

    Function RecordInRange(    CertiorariCalendarTable : TTable;
                           var TrialDate : String) : Boolean;

    Procedure PrintNormalFormatReport(Sender : TObject);

    Procedure PrintCertiorariInfo(Sender : TObject;
                                  SwisSBLKey : String;
                                  CertiorariYear : String;
                                  CertiorariNumber : LongInt;
                                  FirstParcel : Boolean;
                                  SBLChanged : Boolean);

    Procedure PrintGridFormatReport(Sender : TObject);

  end;

implementation
Uses Utilitys,  {General utilitys}
     PASUTILS, {PAS specific utilitys}
     GlblCnst,  {Global constants}
     GlblVars,  {Global variables}
     WinUtils,  {General Windows utilitys}
     Prog,
     RptDialg,
     GrievanceUtilitys,
     PRCLLIST,
     Preview;

const
  ttLatestTrial = 0;
  ttAnyTrial = 1;

  poCertiorariNumber = 0;
  poParcelID = 1;
  poTrialDate = 2;

  rfNormal = 0;
  rfGrid = 1;
  rfCalendar = 2;

{$R *.DFM}

{========================================================}
Procedure TCertiorariCalendarReportForm.FormActivate(Sender: TObject);

begin
  SetFormStateMaximized(Self);
end;

{========================================================}
Procedure TCertiorariCalendarReportForm.InitializeForm;

begin
  UnitName := 'RCertiorariCalendar';  {mmm}

  OrigSortFileName := 'SortCertCalendarTable';
  OrigHeaderSortFileName := 'SortCertCalendarHdrTable';
  OpenTablesForForm(Self, GlblProcessingType);

    {CHG02012004-1(2.07l1): Allow for the alternate ID to default to on or off.}

  UseAlternateIDCheckBox.Checked := GlblCertiorariReportsUseAlternateID;

end;  {InitializeForm}

{===================================================================}
Procedure TCertiorariCalendarReportForm.GridFormatCheckBoxClick(Sender: TObject);

begin
  PrintOrderRadioGroupBox.Visible := not GridFormatCheckBox.Checked;

  If GridFormatCheckBox.Checked
    then PrintOrderRadioGroupBox.ItemIndex := poParcelID;

end;  {GridFormatCheckBoxClick}

{===================================================================}
Procedure TCertiorariCalendarReportForm.AllDatesCheckBoxClick(Sender: TObject);

begin
 If AllDatesCheckBox.Checked
    then
      begin
        ToEndofDatesCheckBox.Checked := False;
        ToEndofDatesCheckBox.Enabled := False;
        StartDateEdit.Text := '';
        StartDateEdit.Enabled := False;
        StartDateEdit.Color := clBtnFace;
        EndDateEdit.Text := '';
        EndDateEdit.Enabled := False;
        EndDateEdit.Color := clBtnFace;
      end
    else EnableSelectionsInGroupBoxOrPanel(DateGroupBox);

end;  {AllDatesCheckBoxClick}

{===================================================================}
Procedure TCertiorariCalendarReportForm.ToEndofDatesCheckBoxClick(Sender: TObject);

begin
 If ToEndofDatesCheckBox.Checked
    then
      begin
        EndDateEdit.Text := '';
        EndDateEdit.Enabled := False;
        EndDateEdit.Color := clBtnFace;
      end
    else
      begin
        EndDateEdit.Text := '  /  /    ';
        EndDateEdit.Enabled := True;
        EndDateEdit.Color := clWindow;

      end;  {else of If ToEndofDatesCheck.Checked}

end;  {ToEndofDatesCheckBoxClick}

{===================================================================}
Procedure TCertiorariCalendarReportForm.FormKeyPress(    Sender: TObject;
                                     var Key: Char);

begin
  If (Key = #13)
    then
      begin
        Key := #0;
        Perform(WM_NEXTDLGCTL, 0, 0);
      end;

end;  {FormKeyPress}

{====================================================================}
Procedure TCertiorariCalendarReportForm.SaveButtonClick(Sender: TObject);

{FXX04091999-8: Add ability to save and load search report options.}

begin
  SaveReportOptions(Self, OpenDialog, SaveDialog, 'Certiorari Summary.grs', 'Certiorari Summary Report');

end;  {SaveButtonClick}

{====================================================================}
Procedure TCertiorariCalendarReportForm.LoadButtonClick(Sender: TObject);

{FXX04091999-8: Add ability to save and load search report options.}

begin
  LoadReportOptions(Self, OpenDialog, 'Certiorari Summary.grs', 'Certiorari Summary Report');

end;  {LoadButtonClick}

{========================================================================}
{==================  PRINTING  ==========================================}
{====================================================================}
Function TCertiorariCalendarReportForm.RecordInRange(    CertiorariCalendarTable : TTable;
                                                     var TrialDate : String) : Boolean;

var
  Done, FirstTimeThrough,
  ThisTrialDateInRange, TrialDateInRange : Boolean;

begin
  Done := False;
  FirstTimeThrough := True;
  CertiorariCalendarTable.First;
  TrialDateInRange := False;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else CertiorariCalendarTable.Next;

    If CertiorariCalendarTable.EOF
      then Done := True;

    If not Done
      then
        begin
          If PrintAllDates
            then
              begin
                TrialDateInRange := True;
                TrialDate := CertiorariCalendarTable.FieldByName('Date').Text;
              end
            else
              begin
                ThisTrialDateInRange := False;

                with CertiorariCalendarTable do
                  try
                    If ((FieldByName('Date').AsDateTime >= StartDate) and
                        (PrintToEndOfDates or
                         (FieldByName('Date').AsDateTime <= EndDate)))
                      then ThisTrialDateInRange := True;
                  except
                  end;

                  {If they only want the latest trial date, reset the overall
                   truth of whether or not the trial is in range each trial record
                   since the last record will be the most recent.  Otherwise,
                   if any trial is in range, take it.}

                case TrialType of
                  ttLatestTrial : TrialDateInRange := ThisTrialDateInRange;

                  ttAnyTrial : If ((not TrialDateInRange) and
                                   ThisTrialDateInRange)
                                 then TrialDateInRange := True;

                end;  {case TrialType of}

                If TrialDateInRange
                  then TrialDate := CertiorariCalendarTable.FieldByName('Date').Text;

              end;  {else of If PrintAllDates}

        end;  {If not Done}

  until Done;

  Result := TrialDateInRange;

end;  {RecordInRange}

{======================================================================}
Procedure TCertiorariCalendarReportForm.FillSortTable(var Quit : Boolean);

var
  Done, FirstTimeThrough, SortEntryExists : Boolean;
  TrialDate, SwisSBLKey : String;

begin
  Done := False;
  FirstTimeThrough := True;
  CertiorariTable.First;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else CertiorariTable.Next;

    If CertiorariTable.EOF
      then Done := True;

    SwisSBLKey := CertiorariTable.FieldByName('SwisSBLKey').Text;
    ProgressDialog.Update(Self, ConvertSwisSBLToDashDot(SwisSBLKey));
    Application.ProcessMessages;

    If not Done
      then
        begin
          with CertiorariTable do
            SetRangeOld(CertiorariCalendarTable,
                        ['TaxRollYr', 'SwisSBLKey', 'CertiorariNumber', 'Date'],
                        [FieldByName('TaxRollYr').Text,
                         FieldByName('SwisSBLKey').Text,
                         FieldByName('CertiorariNumber').Text, '1/1/1950'],
                        [FieldByName('TaxRollYr').Text,
                         FieldByName('SwisSBLKey').Text,
                         FieldByName('CertiorariNumber').Text, '1/1/3000']);

          If RecordInRange(CertiorariCalendarTable, TrialDate)
            then
              case ReportFormat of
                rfNormal :
                  begin
                    with SortCertiorariTable do
                      try
                        Insert;

                        FieldByName('TaxRollYr').Text := CertiorariTable.FieldByName('TaxRollYr').Text;
                        FieldByName('SwisSBLKey').Text := SwisSBLKey;
                        FieldByName('AlternateID').Text := CertiorariTable.FieldByName('AlternateID').Text;
                        FieldByName('CertiorariNumber').Text := CertiorariTable.FieldByName('CertiorariNumber').Text;
                        FieldByName('PropertyClassCode').Text := CertiorariTable.FieldByName('PropertyClassCode').Text;
                        FieldByName('PetitName1').Text := CertiorariTable.FieldByName('PetitName1').Text;
                        FieldByName('PetitName2').Text := CertiorariTable.FieldByName('PetitName2').Text;
                        FieldByName('SchoolCode').Text := CertiorariTable.FieldByName('SchoolCode').Text;
                        FieldByName('CurrentTentativeValue').AsInteger := CertiorariTable.FieldByName('CurrentTentativeValue').AsInteger;
                        FieldByName('PetitGrievanceValue').AsInteger := CertiorariTable.FieldByName('PetitGrievanceValue').AsInteger;
                        FieldByName('CurrentTotalValue').AsInteger := CertiorariTable.FieldByName('CurrentTotalValue').AsInteger;
                        FieldByName('PetitTotalValue').AsInteger := CertiorariTable.FieldByName('PetitTotalValue').AsInteger;
                        FieldByName('LawyerCode').Text := CertiorariTable.FieldByName('LawyerCode').Text;
                        FieldByName('LegalAddr').Text := CertiorariTable.FieldByName('LegalAddr').Text;
                        FieldByName('LegalAddrNo').Text := CertiorariTable.FieldByName('LegalAddrNo').Text;

                        try
                          FieldByName('TrialDate').Text := TrialDate;
                        except
                        end;

                        Post;

                      except;
                        SystemSupport(001, SortCertiorariTable, 'Error inserting into sort file.',
                                      UnitName, GlblErrorDlgBox);
                      end;

                end;  {rfNormal}

                rfGrid :
                  begin
                    with CertiorariCalendarTable do
                      SortEntryExists := FindKeyOld(SortCertiorariCalendarHdrTable,
                                                    ['SwisSBLKey', 'TaxRollYr', 'CertiorariNumber'],
                                                    [SwisSBLKey, FieldByName('TaxRollYr').Text,
                                                     FieldByName('CertiorariNumber').Text]);

                    If not SortEntryExists
                      then
                        with SortCertiorariCalendarHdrTable do
                          try
                            Insert;
                            FieldByName('SwisSBLKey').Text := SwisSBLKey;
                            FieldByName('CertiorariNumber').Text := CertiorariTable.FieldByName('CertiorariNumber').Text;
                            FieldByName('TrialDate').Text := TrialDate;
                            FieldByName('TaxRollYr').Text := CertiorariCalendarTable.FieldByName('TaxRollYr').Text;

                            Post;
                          except
                            SystemSupport(001, SortCertiorariCalendarHdrTable, 'Error inserting into sort file for grid format.',
                                          UnitName, GlblErrorDlgBox);
                          end;

                  end;  {rfGrid}

              end;  {case ReportFormat of}

        end;  {If not Done}

    ReportCancelled := ProgressDialog.Cancelled;

  until (Done or ReportCancelled);

end;  {FillSortFile}

{========================================================}
Procedure TCertiorariCalendarReportForm.PrintButtonClick(Sender: TObject);

var
  SpreadsheetFileName, SortFileName, NewFileName : String;
  Quit : Boolean;

begin
  ReportCancelled := False;
  Quit := False;
  UseAlternateID := UseAlternateIDCheckBox.Checked;
  ExtractToExcel := ExtractToExcelCheckBox.Checked;
  ReportFormat := rfNormal;
  TrialType := TrialTypeRadioGroup.ItemIndex;

  If GridFormatCheckBox.Checked
    then ReportFormat := rfGrid;

  PrintNotes := PrintNotesCheckBox.Checked;

    {CHG10121998-1: Add user options for default destination and show vet max msg.}

  SetPrintToScreenDefault(PrintDialog);

  If PrintDialog.Execute
    then
      begin
        CreateParcelList := CreateParcelListCheckBox.Checked;
        If CreateParcelList
          then ParcelListDialog.ClearParcelGrid(True);

(*        IncludeResults := IncludeResultsCheckBox.Checked;*)

          {If they didn't select any dates, then select all.}

        If ((not AllDatesCheckBox.Checked) and
            (not ToEndOfDatesCheckBox.Checked) and
            (StartDateEdit.Text = '  /  /    ') and
            (EndDateEdit.Text = '  /  /    '))
          then AllDatesCheckBox.Checked := True;

        PrintAllDates := AllDatesCheckBox.Checked;
        PrintToEndOfDates := False;

        If not PrintAllDates
          then
            begin
              try
                StartDate := StrToDate(StartDateEdit.Text);
              except
              end;

              PrintToEndOfDates := ToEndOfDatesCheckBox.Checked;

              If not PrintToEndOfDates
                then
                  try
                    EndDate := StrToDate(EndDateEdit.Text);
                  except
                  end;

            end;  {If not PrintAllDates}

          {CHG10131998-1: Set the printer settings based on what printer they selected
                          only - they no longer need to worry about paper or landscape
                          mode.}

        AssignPrinterSettings(PrintDialog, ReportPrinter, ReportFiler, [ptLaser],
                              False, Quit);

        case ReportFormat of
          rfGrid : begin
                     ReportPrinter.Orientation := poLandscape;
                     ReportFiler.Orientation := poLandscape;
                   end;

        end;  {case ReportFormat of}

          {Automatically print reduced for non calendar format.}

(*        If not CalendarFormat
          then
            begin
              If IncludeResults
                then XScale := 77
                else XScale := 95;

              ReportPrinter.SetPaperSize(dmPaper_Letter, 0, 0);
              ReportFiler.SetPaperSize(dmPaper_Letter, 0, 0);
              ReportPrinter.Orientation := poLandscape;
              ReportFiler.Orientation := poLandscape;

              ReportPrinter.ScaleX := XScale;
              ReportPrinter.ScaleY := 70;
              ReportPrinter.SectionLeft := 1.5;
              ReportFiler.ScaleX := XScale;
              ReportFiler.ScaleY := 70;
              ReportFiler.SectionLeft := 1.5;

              LinesLeftAtBottom := GlblLinesLeftOnRollDotMatrix;

            end;  {If not CalendarFormat}*)

        If not Quit
          then
            begin
                {CHG01252005-1(2.8.3.1): Add extract to Excel to Cert calender.}

              If ExtractToExcel
                then
                  begin
                    SpreadsheetFileName := GetPrintFileName('SL', True);
                    AssignFile(ExtractFile, SpreadsheetFileName);
                    Rewrite(ExtractFile);

                  end;  {If ExtractToExcel}

              ProgressDialog.UserLabelCaption := 'Creating Sort File';

              ProgressDialog.Start(GetRecordCount(CertiorariTable), True, True);
              PrintOrder := PrintOrderRadioGroupBox.ItemIndex;

              case ReportFormat of
                rfNormal :
                  begin
                    SortCertiorariTable.Close;
                    SortCertiorariTable.TableName := OrigSortFileName;

                    SortFileName := GetSortFileName('CertCalendar');

                    SortCertiorariTable.IndexName := '';
                    CopySortFile(SortCertiorariTable, SortFileName);
                    SortCertiorariTable.Close;
                    SortCertiorariTable.TableName := SortFileName;
                    SortCertiorariTable.Exclusive := True;

                    try
                      SortCertiorariTable.Open;
                    except
                      Quit := True;
                      SystemSupport(060, SortCertiorariTable, 'Error opening sort table.',
                                    UnitName, GlblErrorDlgBox);
                    end;

                    with SortCertiorariTable do
                      case PrintOrder of
                        poParcelID : IndexName := 'BySwisSBLKey';
                        poCertiorariNumber : IndexName := 'ByCertiorariNumber';
                        poTrialDate : IndexName := 'ByTrialDate';
                      end;

                    {CHG01252005-1(2.8.3.1): Add extract to Excel to Cert calender.}

                  If ExtractToExcel
                    then WritelnCommaDelimitedLine(ExtractFile,
                                                   ['Year',
                                                    'Index #',
                                                    'Prop Class',
                                                    'School',
                                                    'Parcel ID',
                                                    'Petitioner',
                                                    'Representative',
                                                    'Location',
                                                    'Final AV',
                                                    'Asking Value',
                                                    'AV Difference',
                                                    'Trial Date']);

                end;  {rfNormal}

                rfGrid :
                  begin
                    SortCertiorariCalendarHdrTable.Close;
                    SortCertiorariCalendarHdrTable.TableName := OrigHeaderSortFileName;

                    SortFileName := GetSortFileName('CertCalendar');

                    SortCertiorariCalendarHdrTable.IndexName := '';
                    CopySortFile(SortCertiorariCalendarHdrTable, SortFileName);
                    SortCertiorariCalendarHdrTable.Close;
                    SortCertiorariCalendarHdrTable.TableName := SortFileName;
                    SortCertiorariCalendarHdrTable.Exclusive := True;

                    try
                      SortCertiorariCalendarHdrTable.Open;
                    except
                      Quit := True;
                      SystemSupport(060, SortCertiorariCalendarHdrTable, 'Error opening sort table.',
                                    UnitName, GlblErrorDlgBox);
                    end;

                    {CHG01252005-1(2.8.3.1): Add extract to Excel to Cert calender.}

                  If ExtractToExcel
                    then WritelnCommaDelimitedLine(ExtractFile,
                                                   ['Parcel ID',
                                                    'Year',
                                                    'Index #',
                                                    'Prop Class',
                                                    'School',
                                                    'Petitioner',
                                                    'Location',
                                                    'Representative',
                                                    'Final AV',
                                                    'Appraisal Exchange Date',
                                                    'Pretrial Memo Date',
                                                    'Pretrial Conf Date',
                                                    'Conference Date',
                                                    'Trial Date',
                                                    'Trial Date',
                                                    'Trial Date',
                                                    'Trial Date']);

                  end;  {rfGrid}

              end;  {case ReportFormat of}

              FillSortTable(Quit);

              If (ReportFormat = rfGrid)
                then SortCertiorariCalendarHdrTable.IndexName := 'BYTRIAL_SBL_YEAR';

              ProgressDialog.Reset;

                {Now print the report.}

              If not Quit
                then
                  begin
                    GlblPreviewPrint := False;

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

                              {FXX09071999-6: Tell people that printing is starting and
                                              done.}

                            ProgressDialog.StartPrinting(PrintDialog.PrintToFile);

                            PreviewForm.ShowModal;
                          finally
                            PreviewForm.Free;
                          end;

                          ShowReportDialog('Certiorari Calendar Report.RPT', NewFileName, True);

                        end
                      else ReportPrinter.Execute;

                  end;  {If not Quit}

              SortCertiorariTable.Close;

              try
                Chdir(GlblReportDir);
                OldDeleteFile(SortFileName)
              except
              end;

                {Clear the selections.}

              ProgressDialog.Finish;

                {FXX09071999-6: Tell people that printing is starting and
                                done.}

              DisplayPrintingFinishedMessage(PrintDialog.PrintToFile);


              If CreateParcelList
                then ParcelListDialog.Show;

                {CHG01252005-1(2.8.3.1): Extract the Certiorari summary report to Excel.}

              If ExtractToExcel
                then
                  begin
                    CloseFile(ExtractFile);
                    SendTextFileToExcelSpreadsheet(SpreadsheetFileName, True,
                                                   False, '');

                  end;  {If PrintToExcel}

            end;  {If not Quit}

        ResetPrinter(ReportPrinter);

      end;  {If PrintDialog.Execute}

end;  {PrintButtonClick}

{====================================================================}
Procedure PrintParcelSubHeader(Sender : TObject;
                               PrintParcelID : Boolean);

begin
  with Sender as TBaseReport do
    begin
      ClearTabs;

      If PrintParcelID
        then SetTab(0.3, pjCenter, 1.4, 5, BoxLineAll, 25);   {Parcel ID}

      SetTab(1.7, pjCenter, 0.3, 5, BoxLineAll, 25);   {Tax Year}
      SetTab(2.0, pjCenter, 0.5, 5, BoxLineAll, 25);   {Certiorari #}
      SetTab(2.5, pjCenter, 0.4, 5, BoxLineAll, 25);   {Prop Class}
      SetTab(2.9, pjCenter, 0.5, 5, BoxLineAll, 25);   {School}
      SetTab(3.4, pjCenter, 3.0, 5, BoxLineAll, 25);   {Petitioner}
      SetTab(6.4, pjCenter, 1.6, 5, BoxLineAll, 25);   {Location}
      SetTab(8.0, pjCenter, 1.2, 5, BoxLineAll, 25);   {Rep}
      SetTab(9.2, pjCenter, 1.0, 5, BoxLineAll, 25);   {Final AV}

      If PrintParcelID
        then Print(#9 + 'Parcel ID');

      Println(#9 + 'Year' +
              #9 + 'Index #' +
              #9 + 'Class' +
              #9 + 'School' +
              #9 + 'Petitioner' +
              #9 + 'Location' +
              #9 + 'Representative' +
              #9 + 'Final AV');

      ClearTabs;

      If PrintParcelID
        then SetTab(0.3, pjLeft, 1.4, 5, BoxLineAll, 0);   {Parcel ID}

      SetTab(1.7, pjCenter, 0.3, 5, BoxLineAll, 0);   {Tax Year}
      SetTab(2.0, pjRight, 0.5, 5, BoxLineAll, 0);   {Certiorari #}
      SetTab(2.5, pjCenter, 0.4, 5, BoxLineAll, 0);   {Prop Class}
      SetTab(2.9, pjLeft, 0.5, 5, BoxLineAll, 0);   {School}
      SetTab(3.4, pjLeft, 3.0, 5, BoxLineAll, 0);   {Petitioner}
      SetTab(6.4, pjLeft, 1.6, 5, BoxLineAll, 0);   {Location}
      SetTab(8.0, pjLeft, 1.2, 5, BoxLineAll, 0);   {Rep}
      SetTab(9.2, pjRight, 1.0, 5, BoxLineAll, 0);   {Final AV}

    end;  {with Sender as TBaseReport do}

end;  {PrintParcelSubHeader}

{====================================================================}
Procedure PrintCalendarDatesSubHeader(Sender : TObject);

begin
  with Sender as TBaseReport do
    begin
      ClearTabs;
      SetTab(2.5, pjCenter, 1.0, 5, BoxLineAll, 25);   {Appraisal Exchange Date}
      SetTab(3.5, pjCenter, 1.0, 5, BoxLineAll, 25);   {Pretrial Conference Date}
      SetTab(4.5, pjCenter, 1.0, 5, BoxLineAll, 25);   {Pretrial memo date}
      SetTab(5.5, pjCenter, 1.0, 5, BoxLineAll, 25);   {Conference Date}
      SetTab(6.5, pjCenter, 1.0, 5, BoxLineAll, 25);   {Trial 1}
      SetTab(7.5, pjCenter, 1.0, 5, BoxLineAll, 25);   {Trial 2}
      SetTab(8.5, pjCenter, 1.0, 5, BoxLineAll, 25);   {Trial 3}
      SetTab(9.5, pjCenter, 1.0, 5, BoxLineAll, 25);   {Trial 4}

      Println(#9 + 'Appr Xchng' +
              #9 + 'PT Memo' +
              #9 + 'PT Conf' +
              #9 + 'Conference' +
              #9 + 'Trial' +
              #9 + 'Trial' +
              #9 + 'Trial' +
              #9 + 'Trial');

      ClearTabs;
      SetTab(2.5, pjCenter, 1.0, 5, BoxLineAll, 0);   {Appraisal Exchange Date}
      SetTab(3.5, pjCenter, 1.0, 5, BoxLineAll, 0);   {Pretrial Conference Date}
      SetTab(4.5, pjCenter, 1.0, 5, BoxLineAll, 0);   {Pretrial memo date}
      SetTab(5.5, pjCenter, 1.0, 5, BoxLineAll, 0);   {Conference Date}
      SetTab(6.5, pjCenter, 1.0, 5, BoxLineAll, 0);   {Trial 1}
      SetTab(7.5, pjCenter, 1.0, 5, BoxLineAll, 0);   {Trial 2}
      SetTab(8.5, pjCenter, 1.0, 5, BoxLineAll, 0);   {Trial 3}
      SetTab(9.5, pjCenter, 1.0, 5, BoxLineAll, 0);   {Trial 4}

    end;  {with Sender as TBaseReport do}

end;  {PrintCalendarDatesSubHeader}

{====================================================================}
Procedure PrintNotesSubHeader(Sender : TObject;
                              PrintParcelID : Boolean);

begin
  with Sender as TBaseReport do
    begin
      ClearTabs;
      If PrintParcelID
        then SetTab(0.3, pjCenter, 2.2, 5, BoxLineAll, 25);   {Parcel ID}

      SetTab(2.5, pjCenter, 1.0, 5, BoxLineAll, 25);   {Note Date}
      SetTab(3.5, pjCenter, 7.2, 5, BoxLineAll, 25);   {Note}

      If PrintParcelID
        then Print(#9 + 'Parcel ID');

      Println(#9 + 'Note Date' +
              #9 + 'Note');

    end;  {with Sender as TBaseReport do}

end;  {PrintNotesSubHeader}

{====================================================================}
Procedure TCertiorariCalendarReportForm.ReportPrintHeader(Sender: TObject);

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
      PrintCenter('Certiorari Calendar', (PageWidth / 2));
      Println('');

      ClearTabs;
      SetTab(0.5, pjLeft, 1.7, 0, BOXLINENONE, 0);   {Index}
      SetFont('Times New Roman', 10);

      Bold := True;
      Print(#9 + 'For Dates: ');
      Bold := False;

      If AllDatesCheckBox.Checked
        then Println(' All')
        else
          begin
            Print(' ' + StartDateEdit.Text + ' to ');

            If ToEndOfDatesCheckBox.Checked
              then Println(' End')
              else Println(' ' + EndDateEdit.Text);

          end;  {else of If AllDatesCheckBox.Checked}

      SetFont('Times New Roman',8);
      ClearTabs;

      case ReportFormat of
        rfNormal :
          begin
            ClearTabs;
            SetTab(0.3, pjCenter, 0.3, 0, BoxLineNone, 0);   {Tax Year}
            SetTab(0.65, pjCenter, 0.3, 0, BoxLineNone, 0);   {Certiorari #}
            SetTab(1.0, pjCenter, 0.2, 0, BoxLineNone, 0);   {Prop Class}
            SetTab(1.25, pjCenter, 0.2, 0, BoxLineNone, 0);   {School}
            SetTab(1.5, pjCenter, 1.0, 0, BoxLineNone, 0);   {Parcel ID}
            SetTab(2.55, pjCenter, 1.6, 0, BoxLineNone, 0);   {Petitioner}
            SetTab(4.2, pjCenter, 0.6, 0, BoxLineNone, 0);   {Rep}

            SetTab(4.85, pjCenter, 1.05, 0, BoxLineNone, 0);   {Location}
            SetTab(6.0, pjCenter, 0.5, 0, BoxLineNone, 0);   {Final AV}
            SetTab(6.55, pjCenter, 0.5, 0, BoxLineNone, 0);   {Cert Claim}
            SetTab(7.1, pjCenter, 0.5, 0, BoxLineNone, 0);   {Cert Claim diff}
            SetTab(7.65, pjCenter, 0.55, 0, BoxLineNone, 0);   {Trial Date}

            Bold := True;

            Println(#9 + #9 +
                    #9 + 'PRP' +
                    #9 + 'SCH' +
                    #9 + #9 + #9 +
                    #9 + '' +
                    #9 + 'FINAL' +
                    #9 + 'CERT' +
                    #9 + 'CERT CL' +
                    #9 + 'TRIAL');

            ClearTabs;
            SetTab(0.3, pjCenter, 0.3, 0, BoxLineBottom, 0);   {Tax Year}
            SetTab(0.65, pjCenter, 0.3, 0, BoxLineBottom, 0);   {Certiorari #}
            SetTab(1.0, pjCenter, 0.2, 0, BoxLineBottom, 0);   {Prop Class}
            SetTab(1.25, pjCenter, 0.2, 0, BoxLineBottom, 0);   {School}
            SetTab(1.5, pjCenter, 1.0, 0, BoxLineBottom, 0);   {Parcel ID}
            SetTab(2.55, pjCenter, 1.6, 0, BoxLineBottom, 0);   {Petitioner}
            SetTab(4.2, pjCenter, 0.6, 0, BoxLineBottom, 0);   {Rep}

            SetTab(4.85, pjCenter, 1.05, 0, BoxLineBottom, 0);   {Location}
            SetTab(6.0, pjCenter, 0.5, 0, BoxLineBottom, 0);   {Final AV}
            SetTab(6.55, pjCenter, 0.5, 0, BoxLineBottom, 0);   {Cert Claim}
            SetTab(7.1, pjCenter, 0.5, 0, BoxLineBottom, 0);   {Cert Claim diff}
            SetTab(7.65, pjCenter, 0.55, 0, BoxLineBottom, 0);   {Trial Date}

            Println(#9 + 'YEAR' +
                    #9 + 'INDEX' +
                    #9 + 'CLS' +
                    #9 + 'CD' +
                    #9 + 'PARCEL ID' +
                    #9 + 'PETITIONER' +
                    #9 + 'REP' +
                    #9 + 'LOCATION' +
                    #9 + 'ASSMT' +
                    #9 + 'CLAIM' +
                    #9 + 'DIFF' +
                    #9 + 'DATE');

            ClearTabs;
            SetTab(0.3, pjLeft, 0.3, 0, BoxLineNone, 0);   {Tax Year}
            SetTab(0.65, pjLeft, 0.3, 0, BoxLineNone, 0);   {Certiorari #}
            SetTab(1.0, pjLeft, 0.2, 0, BoxLineNone, 0);   {Prop Class}
            SetTab(1.25, pjLeft, 0.2, 0, BoxLineNone, 0);   {School}
            SetTab(1.5, pjLeft, 1.0, 0, BoxLineNone, 0);   {Parcel ID}
            SetTab(2.55, pjLeft, 1.6, 0, BoxLineNone, 0);   {Petitioner}
            SetTab(4.2, pjLeft, 0.6, 0, BoxLineNone, 0);   {Rep}

            SetTab(4.85, pjLeft, 1.05, 0, BoxLineNone, 0);   {Location}
            SetTab(6.0, pjRight, 0.5, 0, BoxLineNone, 0);   {Final AV}
            SetTab(6.55, pjRight, 0.5, 0, BoxLineNone, 0);   {Cert Claim}
            SetTab(7.1, pjRight, 0.5, 0, BoxLineNone, 0);   {Cert Claim diff}
            SetTab(7.65, pjRight, 0.55, 0, BoxLineNone, 0);   {Trial Date}

          end;  {If not CalendarFormat}

      end;  {case ReportFormat of}

      Bold := False;

    end;  {with Sender as TBaseReport do}

end;  {TextFilerPrintHeader}

{====================================================================}
Procedure TCertiorariCalendarReportForm.PrintNormalFormatReport(Sender : TObject);

var
  Done, FirstTimeThrough : Boolean;
  SwisSBLKey, ParcelID, TempPetitioner,
  ShortSchoolCode, NameLine1, NameLine2 : String;

begin
  Done := False;
  FirstTimeThrough := True;

  ProgressDialog.Start(GetRecordCount(SortCertiorariTable), True, True);

  SortCertiorariTable.First;

  with Sender as TBaseReport do
    begin
      repeat
        If FirstTimeThrough
          then FirstTimeThrough := False
          else SortCertiorariTable.Next;

        If SortCertiorariTable.EOF
          then Done := True;

        SwisSBLKey := SortCertiorariTable.FieldByName('SwisSBLKey').Text;
        Application.ProcessMessages;
        ProgressDialog.Update(Self, ConvertSwisSBLToDashDot(SwisSBLKey));

        If not Done
          then
            with SortCertiorariTable do
              begin
                ShortSchoolCode := '';
                If FindKeyOld(SchoolCodeTable, ['SchoolCode'],
                              [FieldByName('SchoolCode').Text])
                  then ShortSchoolCode := SchoolCodeTable.FieldByName('SchoolShortCode').Text;
(*
                PetitionerName := Trim(FieldByName('PetitName1').Text);

                If (Length(PetitionerName) > 25)
                  then
                    begin
                      NameLine1 := '';
                      DoneSplit := False;

                      NameLine1 := GetNextWord(PetitionerName);

                      repeat
                        NextWord := GetNextWord(PetitionerName);

                        If ((Length(NameLine1) + Length(NextWord) + 1) > 25)
                          then
                            begin
                              DoneSplit := True;
                              NameLine2 := NextWord + ' ' + PetitionerName;
                            end;

                      until DoneSplit;

                    end
                  else
                    begin
                      NameLine1 := PetitionerName;
                      NameLine2 := '';
                    end; *)

                NameLine1 := FieldByName('PetitName1').Text;
                NameLine2 := FieldByName('PetitName2').Text;

                If UseAlternateID
                  then ParcelID := FieldByName('AlternateID').Text
                  else ParcelID := ConvertSBLOnlyToDashDot(Copy(SwisSBLKey, 7, 20));

                Println(#9 + FieldByName('TaxRollYr').Text +
                        #9 + FieldByName('CertiorariNumber').Text +
                        #9 + FieldByName('PropertyClassCode').Text +
                        #9 + ShortSchoolCode +
                        #9 + Take(20, ParcelID) +
                        #9 + Take(20, NameLine1) +
                        #9 + FieldByName('LawyerCode').Text +
                        #9 + Take(16, GetLegalAddressFromTable(SortCertiorariTable)) +
                        #9 + FormatFloat(NoDecimalDisplay,
                                         FieldByName('CurrentTotalValue').AsFloat) +
                        #9 + FormatFloat(NoDecimalDisplay,
                                         FieldByName('PetitTotalValue').AsFloat) +
                        #9 + FormatFloat(NoDecimalDisplay,
                                         (FieldByName('CurrentTotalValue').AsFloat -
                                          FieldByName('PetitTotalValue').AsFloat)) +
                        #9 + FieldByName('TrialDate').Text);

                If (Deblank(NameLine2) <> '')
                  then Println(#9 + #9 + #9 + #9 + #9 +
                               #9 + NameLine2);

(*                TotalTentativeValue := TotalTentativeValue +
                                       FieldByName('CurrentTentativeValue').AsInteger;
                TotalGrievanceClaim := TotalGrievanceClaim +
                                       FieldByName('PetitGrievanceValue').AsInteger;
                TotalFinalAssessment := TotalFinalAssessment +
                                        FieldByName('CurrentTotalValue').AsInteger;
                TotalCertClaim := TotalCertClaim +
                                  FieldByName('PetitTotalValue').AsInteger; *)

                  {CHG01252005-1(2.8.3.1): Add extract to Excel to Cert calender.}

                If ExtractToExcel
                  then
                    begin
                      TempPetitioner := NameLine1;

                      If _Compare(NameLine2, coNotBlank)
                        then TempPetitioner := TempPetitioner + ' & ' + NameLine2;

                      WritelnCommaDelimitedLine(ExtractFile,
                                                 [FieldByName('TaxRollYr').Text,
                                                  FieldByName('CertiorariNumber').Text,
                                                  FieldByName('PropertyClassCode').Text,
                                                  ShortSchoolCode,
                                                  ParcelID,
                                                  TempPetitioner,
                                                  FieldByName('LawyerCode').Text,
                                                  GetLegalAddressFromTable(SortCertiorariTable),
                                                  FieldByName('CurrentTotalValue').AsFloat,
                                                  FieldByName('PetitTotalValue').AsFloat,
                                                  (FieldByName('CurrentTotalValue').AsFloat -
                                                   FieldByName('PetitTotalValue').AsFloat),
                                                  FieldByName('TrialDate').Text]);

                    end;  {If ExtractToExcel}

                If (CreateParcelList and
                    (not ParcelListDialog.ParcelExistsInList(SwisSBLKey)))
                  then ParcelListDialog.AddOneParcel(SwisSBLKey);

                  {If there is only one line left to print, then we
                   want to go to the next page.}

                If (LinesLeft <= LinesLeftAtBottom)
                  then NewPage;

              end;  {with SortCertiorariTable do}

        ReportCancelled := ProgressDialog.Cancelled;

      until (Done or ReportCancelled);

    end;  {with Sender as TBaseReport do}

end;  {PrintNormalFormatReport}

{====================================================================}
Procedure PrintParcelInformation(    Sender : TObject;
                                     SortCertiorariTable : TTable;
                                     SchoolCodeTable : TTable;
                                     UseAlternateID : Boolean;
                                     PrintParcelID : Boolean;
                                     ExtractToExcel : Boolean;
                                 var ExtractFile : TextFile);

var
  ParcelID, ShortSchoolCode,
  Petitioner, SwisSBLKey : String;

begin
  with Sender as TBaseReport, SortCertiorariTable do
    begin
      SwisSBLKey := FieldByName('SwisSBLKey').Text;
      ShortSchoolCode := '';
      If FindKeyOld(SchoolCodeTable, ['SchoolCode'],
                    [FieldByName('SchoolCode').Text])
        then ShortSchoolCode := SchoolCodeTable.FieldByName('SchoolShortCode').Text;

      Petitioner := FieldByName('PetitName1').Text;

      If _Compare(FieldByName('PetitName2').Text, '', coNotBlank)
        then Petitioner := Trim(Petitioner) + ' \ ' +
                           FieldByName('PetitName2').Text;

      If UseAlternateID
        then ParcelID := FieldByName('AlternateID').Text;

      If _Compare(ParcelID, coBlank)
        then ParcelID := ConvertSBLOnlyToDashDot(Copy(SwisSBLKey, 7, 20));

      If PrintParcelID
        then Print(#9 + ParcelID);

      Println(#9 + FieldByName('TaxRollYr').Text +
              #9 + FieldByName('CertiorariNumber').Text +
              #9 + FieldByName('PropertyClassCode').Text +
              #9 + ShortSchoolCode +
              #9 + Petitioner +
              #9 + Take(16, GetLegalAddressFromTable(SortCertiorariTable)) +
              #9 + FieldByName('LawyerCode').Text +
              #9 + FormatFloat(NoDecimalDisplay,
                               FieldByName('CurrentTotalValue').AsFloat));

        {CHG01252005-1(2.8.3.1): Add extract to Excel to Cert calender.}

      If ExtractToExcel
        then WriteCommaDelimitedLine(ExtractFile,
                                     [ParcelID,
                                      FieldByName('TaxRollYr').Text,
                                      FieldByName('CertiorariNumber').Text,
                                      FieldByName('PropertyClassCode').Text,
                                      ShortSchoolCode,
                                      Petitioner,
                                      GetLegalAddressFromTable(SortCertiorariTable),
                                      FieldByName('LawyerCode').Text,
                                      FieldByName('CurrentTotalValue').AsFloat]);

    end;  {with Sender, SortCertiorariTable do}

end;  {PrintParcelInformation}

{====================================================================}
Procedure PrintCertiorariNotes(Sender : TObject;
                               CertiorariNotesTable : TTable;
                               CertiorariTable : TTable;
                               UseAlternateID : Boolean;
                               SwisSBLKey : String);

var
  Done, FirstTimeThrough : Boolean;
  MemoBuf : TDBMemoBuf;
  ParcelID : String;

begin
  MemoBuf := nil;
  
  with Sender as TBaseReport, CertiorariNotesTable do
    begin
      SetRangeOld(CertiorariNotesTable, ['SwisSBLKey', 'NoteNumber'],
                  [SwisSBLKey, '0'], [SwisSBLKey, '9999']);

      If (RecordCount > 0)
        then
          begin
            Done := False;
            FirstTimeThrough := True;
            First;
            PrintNotesSubHeader(Sender, False);

            repeat
              If FirstTimeThrough
                then FirstTimeThrough := False
                else Next;

              If EOF
                then Done := True;

              If not Done
                then
                  begin

                    try
                      MemoBuf := TDBMemoBuf.Create;
                      MemoBuf.PrintStart := 3.55;
                      MemoBuf.PrintEnd := 10.65;
                      MemoBuf.RTFField := TMemoField(FieldByName('Note'));

                        {Set up the headers for a new page.}

                      If (MemoLines(MemoBuf) > (LinesLeft - 3))
                        then
                          begin
                            NewPage;
                            PrintNotesSubHeader(Sender, True);

                            ClearTabs;
                            SetTab(0.3, pjCenter, 2.2, 5, BoxLineAll, 0);   {Parcel ID}

                            ParcelID := '';
                            If UseAlternateID
                              then ParcelID := CertiorariTable.FieldByName('AlternateID').Text;

                            If _Compare(ParcelID, coBlank)
                              then ParcelID := ConvertSBLOnlyToDashDot(Copy(SwisSBLKey, 7, 20));

                            Print(#9 + ParcelID + '(cont.)');

                          end;  {If (MemoLines(MemoBuf) > LinesLeft)}

                      ClearTabs;
                      SetTab(2.5, pjLeft, 1.0, 5, BoxLineAll, 0);   {Note Date}

                      Print(#9 + FieldByName('DateEntered').Text);

                      ClearTabs;
                      SetTab(3.5, pjLeft, 7.2, 0, BoxLineLeftRight, 0);   {Note}

                      PrintMemo(MemoBuf, 0, True);
                    finally
                      MemoBuf.Free;
                    end;

                    ClearTabs;
                    SetTab(3.55, pjLeft, 7.1, 0, BoxLineTop, 0);   {Note}
                    Print(#9);

                  end;  {If not Done}

            until Done;

          end;  {If (RecordCount > 0)}

    end;  {with Sender as TBaseReport do}

end;  {PrintCertiorariNotes}

{====================================================================}
Procedure GetDatesForCertiorari(    SortCertiorariCalendarTable : TTable;
                                var AppraisalExchangeDate : String;
                                var PretrialMemoDate : String;
                                var PretrialConferenceDate : String;
                                var ConferenceDate : String;
                                    TrialDateList : TStringList;
                                    StartDate : TDateTime;
                                    EndDate : TDateTime;
                                    PrintAllDates : Boolean;
                                    PrintToEndOfDates : Boolean);

begin
  with SortCertiorariCalendarTable do
    If _Compare(FieldByName('MeetingType').Text, coNotBlank)
      then
        case FieldByName('MeetingType').Text[1] of
          'A' : AppraisalExchangeDate := FieldByName('Date').Text;
          'M' : PretrialMemoDate := FieldByName('Date').Text;
          'P' : PretrialConferenceDate := FieldByName('Date').Text;
          'C' : If _Compare(ConferenceDate, coNotBlank)
                  then
                    begin
                        {If there is already a conference date filled in,
                         only replace it if this date is actually in date range.}

                      If MeetsDateCriteria(FieldByName('Date').AsDateTime,
                                           StartDate, EndDate,
                                           PrintAllDates, PrintToEndOfDates)
                        then ConferenceDate := FieldByName('Date').Text;

                    end
                  else ConferenceDate := FieldByName('Date').Text;

          'T' : TrialDateList.Add(FieldByName('Date').Text);

        end;  {case FieldByName('MeetingType').Text[1] of}

end;  {GetDatesForCertiorari}

{====================================================================}
Procedure PrintDatesForCertiorari(    Sender : TObject;
                                      CertiorariCalendarTable : TTable;
                                      SwisSBLKey : String;
                                      CertiorariYear : String;
                                      CertiorariNumber : LongInt;
                                      StartDate : TDateTime;
                                      EndDate : TDateTime;
                                      PrintAllDates : Boolean;
                                      PrintToEndOfDates : Boolean;
                                      ExtractToExcel : Boolean;
                                  var ExtractFile : TextFile);

var
  Done, FirstTimeThrough : Boolean;
  I, NumTrialsPrinted : Integer;
  AppraisalExchangeDate, PretrialMemoDate,
  PretrialConferenceDate, ConferenceDate : String;
  TrialDateList : TStringList;

begin
  AppraisalExchangeDate := '';
  PretrialMemoDate := '';
  PretrialConferenceDate := '';
  ConferenceDate := '';
  TrialDateList := TStringList.Create;
  Done := False;
  FirstTimeThrough := True;

    {First go through the calendar entries for this certiorari and get the needed dates.}

  SetRangeOld(CertiorariCalendarTable,
              ['SwisSBLKey', 'TaxRollYr', 'CertiorariNumber', 'Date'],
              [SwisSBLKey, CertiorariYear, IntToStr(CertiorariNumber), '1/1/1990'],
              [SwisSBLKey, CertiorariYear, IntToStr(CertiorariNumber), '1/1/3000']);

  CertiorariCalendarTable.First;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else CertiorariCalendarTable.Next;

    If CertiorariCalendarTable.EOF
      then Done := True;

    If not Done
      then GetDatesForCertiorari(CertiorariCalendarTable,
                                 AppraisalExchangeDate,
                                 PretrialMemoDate,
                                 PretrialConferenceDate,
                                 ConferenceDate,
                                 TrialDateList,
                                 StartDate, EndDate,
                                 PrintAllDates, PrintToEndOfDates);

  until Done;

    {Now print the dates.}

  If (_Compare(AppraisalExchangeDate, coNotBlank) or
      _Compare(PretrialMemoDate, coNotBlank) or
      _Compare(PretrialConferenceDate, coNotBlank) or
      _Compare(ConferenceDate, coNotBlank) or
      (TrialDateList.Count > 0))
    then
      begin
        PrintCalendarDatesSubHeader(Sender);

        SortDateStringList(TrialDateList);

        with Sender as TBaseReport do
          begin
            Print(#9 + AppraisalExchangeDate +
                  #9 + PretrialMemoDate +
                  #9 + PretrialConferenceDate +
                  #9 + ConferenceDate);

            If ExtractToExcel
              then WriteCommaDelimitedLine(ExtractFile,
                                           [AppraisalExchangeDate,
                                            PretrialMemoDate,
                                            PretrialConferenceDate,
                                            ConferenceDate]);

            NumTrialsPrinted := 0;

            For I := (TrialDateList.Count - 1) downto 0 do
              If (NumTrialsPrinted <= 4)
                then
                  begin
                    NumTrialsPrinted := NumTrialsPrinted + 1;
                    Print(#9 + TrialDateList[I]);

                    If ExtractToExcel
                      then WriteCommaDelimitedLine(ExtractFile,
                                                   [TrialDateList[I]]);

                  end;  {For I := (TrialDateList.Count - 1) downto 0 do}

            For I := NumTrialsPrinted to 4 do
              begin
                Print(#9);

                If ExtractToExcel
                  then WriteCommaDelimitedLine(ExtractFile, ['']);

              end;  {For I := NumTrialsPrinted to 4 do}

            Println('');
            If ExtractToExcel
              then WritelnCommaDelimitedLine(ExtractFile, ['']);

          end;  {with Sender as TBaseReport do}

      end  {If (_Compare(AppraisalExchangeDate, coNotBlank) or ...}
    else
      If ExtractToExcel
        then WritelnCommaDelimitedLine(ExtractFile, ['']);

end;  {PrintDatesForCertiorari}

{====================================================================}
Procedure TCertiorariCalendarReportForm.PrintCertiorariInfo(Sender : TObject;
                                                            SwisSBLKey : String;
                                                            CertiorariYear : String;
                                                            CertiorariNumber : LongInt;
                                                            FirstParcel : Boolean;
                                                            SBLChanged : Boolean);

var
  PrintParcelID : Boolean;

begin
  PrintParcelID := (SBLChanged or FirstParcel);
  FindKeyOld(CertiorariTable, ['TaxRollYr', 'SwisSBLKey', 'CertiorariNumber'],
             [CertiorariYear, SwisSBLKey, IntToStr(CertiorariNumber)]);

  with Sender as TBaseReport do
    If (LinesLeft < 8)
      then
        begin
          NewPage;
          PrintParcelID := True;
        end;

  PrintParcelSubHeader(Sender, PrintParcelID);
  PrintParcelInformation(Sender, CertiorariTable,
                         SchoolCodeTable, UseAlternateID, PrintParcelID,
                         ExtractToExcel, ExtractFile);

  PrintDatesForCertiorari(Sender, CertiorariCalendarTable,
                          SwisSBLKey, CertiorariYear, CertiorariNumber,
                          StartDate, EndDate, PrintAllDates, PrintToEndOfDates,
                          ExtractToExcel, ExtractFile);

end;  {PrintCertiorariEntriesForParcel}

{====================================================================}
Procedure TCertiorariCalendarReportForm.PrintGridFormatReport(Sender : TObject);

var
  Done, FirstTimeThrough, SBLChanged, FirstParcel : Boolean;
  LastSwisSBLKey, SwisSBLKey, CertiorariYear : String;
  CertiorariNumber : LongInt;
  NotesPrintedForParcelList : TStringList;

begin
  Done := False;
  FirstTimeThrough := True;
  LastSwisSBLKey := '';
  FirstParcel := True;
  NotesPrintedForParcelList := TStringList.Create;

  CertiorariTable.IndexName := 'BYTAXROLLYR_SWISSBLKEY_CERTNUM';
  ProgressDialog.Start(GetRecordCount(SortCertiorariCalendarHdrTable), True, True);

  SortCertiorariCalendarHdrTable.First;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else SortCertiorariCalendarHdrTable.Next;

    If SortCertiorariCalendarHdrTable.EOF
      then Done := True;

    with SortCertiorariCalendarHdrTable do
      begin
        SwisSBLKey := FieldByName('SwisSBLKey').Text;
        CertiorariYear := FieldByName('TaxRollYr').Text;
        CertiorariNumber := FieldByName('CertiorariNumber').AsInteger;

      end;  {with SortCertiorariCalendarHdrTable do}

    Application.ProcessMessages;
    ProgressDialog.Update(Self, ConvertSwisSBLToDashDot(SwisSBLKey));

    SBLChanged := (_Compare(LastSwisSBLKey, coNotBlank) and
                   (LastSwisSBLKey <> SwisSBLKey));

    If (SBLChanged and
        PrintNotes and
        (NotesPrintedForParcelList.IndexOf(LastSwisSBLKey) = -1))
      then
        begin
          PrintCertiorariNotes(Sender, CertiorariNotesTable, CertiorariTable,
                               UseAlternateID, LastSwisSBLKey);
          NotesPrintedForParcelList.Add(LastSwisSBLKey);

        end;  {If (SBLChanged and ...}

    If not Done
      then
        begin
          with Sender as TBaseReport do
            Println('');

          PrintCertiorariInfo(Sender, SwisSBLKey, CertiorariYear, CertiorariNumber,
                              FirstParcel, SBLChanged);

        end;  {If not Done}

    If (CreateParcelList and
         (not ParcelListDialog.ParcelExistsInList(SwisSBLKey)))
       then ParcelListDialog.AddOneParcel(SwisSBLKey);

    ReportCancelled := ProgressDialog.Cancelled;
    LastSwisSBLKey := SwisSBLKey;
    FirstParcel := False;

  until (Done or ReportCancelled);

  NotesPrintedForParcelList.Free;
  CertiorariTable.IndexName := 'BYTAXROLLYR_SWISSBLKEY_CERTNUM';

end;  {PrintGridFormatReport}

{====================================================================}
Procedure TCertiorariCalendarReportForm.ReportPrint(Sender: TObject);

begin
  case ReportFormat of
    rfNormal : PrintNormalFormatReport(Sender);
    rfGrid : PrintGridFormatReport(Sender);
  end;

end;  {ReportPrinterPrint}

{===============================================================}
Procedure TCertiorariCalendarReportForm.CloseButtonClick(Sender: TObject);

begin
  Close;
end;

{===================================================================}
Procedure TCertiorariCalendarReportForm.FormClose(    Sender: TObject;
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