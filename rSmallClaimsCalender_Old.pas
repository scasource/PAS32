unit rSmallClaimsCalender_Old;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, DBCtrls,  DB, Buttons, Grids,
  Wwdbigrd, Wwdbgrid, ExtCtrls, Wwdatsrc, Menus,
  DBTables, Wwtable, Btrvdlg, RPFiler, RPBase, RPCanvas, RPrinter, Mask,
  Gauges, RPMemo, RPDBUtil, RPDefine, (*Progress,*) Types, RPTXFilr, PASTypes,
  Progress, TabNotBk, ComCtrls;

type
  TSmallClaimsCalendarReportForm = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    ScrollBox: TScrollBox;
    CloseButton: TBitBtn;
    TitleLabel: TLabel;
    ReportPrinter: TReportPrinter;
    ReportFiler: TReportFiler;
    PrintDialog: TPrintDialog;
    SmallClaimsTable: TwwTable;
    PrintButton: TBitBtn;
    LoadButton: TBitBtn;
    SaveButton: TBitBtn;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    SmallClaimsCalendarTable: TTable;
    GroupBox1: TGroupBox;
    CreateParcelListCheckBox: TCheckBox;
    IncludeResultsCheckBox: TCheckBox;
    DateGroupBox: TGroupBox;
    Label7: TLabel;
    Label8: TLabel;
    AllDatesCheckBox: TCheckBox;
    ToEndofDatesCheckBox: TCheckBox;
    EndDateEdit: TMaskEdit;
    StartDateEdit: TMaskEdit;
    CalendarFormatCheckBox: TCheckBox;
    TrialTypeRadioGroup: TRadioGroup;
    PrintOrderRadioGroupBox: TRadioGroup;
    SchoolCodeTable: TTable;
    SortSmallClaimsTable: TTable;
    UseAlternateIDCheckBox: TCheckBox;
    ExtractToExcelCheckBox: TCheckBox;
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
  private
    { Private declarations }
  public
    ReportCancelled, ExtractToExcel : Boolean;

    { Public declarations }
    UnitName, OrigSortFileName : String;
    UseAlternateID : Boolean;

    IncludeResults,
    CreateParcelList, CalendarFormat,
    PrintAllDates, PrintToEndOfDates : Boolean;

    StartDate, EndDate : TDateTime;

    PrintOrder, LinesLeftAtBottom : Integer;
    TrialType : Integer;

    Procedure InitializeForm;  {Open the ScreenLabelTables and setup.}

    Procedure FillSortTable(var Quit : Boolean);

    Function RecordInRange(    SmallClaimsCalendarTable : TTable;
                           var TrialDate : String) : Boolean;


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

  poIndexNumber = 0;
  poParcelID = 1;
  poTrialDate = 2;

{$R *.DFM}

{========================================================}
Procedure TSmallClaimsCalendarReportForm.FormActivate(Sender: TObject);

begin
  SetFormStateMaximized(Self);
end;

{========================================================}
Procedure TSmallClaimsCalendarReportForm.InitializeForm;

begin
  UnitName := 'RSmallClaimsCalendar';  {mmm}

  OrigSortFileName := 'sortsmlclcalendartable';
  OpenTablesForForm(Self, GlblProcessingType);

end;  {InitializeForm}

{===================================================================}
Procedure TSmallClaimsCalendarReportForm.AllDatesCheckBoxClick(Sender: TObject);

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
Procedure TSmallClaimsCalendarReportForm.ToEndofDatesCheckBoxClick(Sender: TObject);

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
Procedure TSmallClaimsCalendarReportForm.FormKeyPress(    Sender: TObject;
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
Procedure TSmallClaimsCalendarReportForm.SaveButtonClick(Sender: TObject);

{FXX04091999-8: Add ability to save and load search report options.}

begin
  SaveReportOptions(Self, OpenDialog, SaveDialog, 'Small Claims Calendar.scg', 'Small Claims Calendar Report');

end;  {SaveButtonClick}

{====================================================================}
Procedure TSmallClaimsCalendarReportForm.LoadButtonClick(Sender: TObject);

{FXX04091999-8: Add ability to save and load search report options.}

begin
  LoadReportOptions(Self, OpenDialog, 'Small Claims Calendar.scg', 'Small Claims Calendar Report');

end;  {LoadButtonClick}

{========================================================================}
{==================  PRINTING  ==========================================}
{====================================================================}
Function TSmallClaimsCalendarReportForm.RecordInRange(    SmallClaimsCalendarTable : TTable;
                                                      var TrialDate : String) : Boolean;

var
  Done, FirstTimeThrough,
  ThisTrialDateInRange, TrialDateInRange : Boolean;

begin
  Done := False;
  FirstTimeThrough := True;
  SmallClaimsCalendarTable.First;
  TrialDateInRange := False;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else SmallClaimsCalendarTable.Next;

    If SmallClaimsCalendarTable.EOF
      then Done := True;

    If not Done
      then
        begin
          If PrintAllDates
            then
              begin
                TrialDateInRange := True;
                TrialDate := SmallClaimsCalendarTable.FieldByName('Date').Text;
              end
            else
              begin
                ThisTrialDateInRange := False;

                with SmallClaimsCalendarTable do
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
                  then TrialDate := SmallClaimsCalendarTable.FieldByName('Date').Text;

              end;  {else of If PrintAllDates}

        end;  {If not Done}

  until Done;

  Result := TrialDateInRange;

end;  {RecordInRange}

{======================================================================}
Procedure TSmallClaimsCalendarReportForm.FillSortTable(var Quit : Boolean);

var
  Done, FirstTimeThrough : Boolean;
  TrialDate : String;

begin
  Done := False;
  FirstTimeThrough := True;
  SmallClaimsTable.First;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else SmallClaimsTable.Next;

    If SmallClaimsTable.EOF
      then Done := True;

    ProgressDialog.Update(Self, ConvertSwisSBLToDashDot(SmallClaimsTable.FieldByName('SwisSBLKey').Text));
    Application.ProcessMessages;

    If not Done
      then
        begin
          with SmallClaimsTable do
            SetRangeOld(SmallClaimsCalendarTable,
                        ['TaxRollYr', 'SwisSBLKey', 'IndexNumber', 'Date'],
                        [FieldByName('TaxRollYr').Text,
                         FieldByName('SwisSBLKey').Text,
                         FieldByName('IndexNumber').Text, '1/1/1950'],
                        [FieldByName('TaxRollYr').Text,
                         FieldByName('SwisSBLKey').Text,
                         FieldByName('IndexNumber').Text, '1/1/3000']);

          If RecordInRange(SmallClaimsCalendarTable, TrialDate)
            then
              with SortSmallClaimsTable do
                try
                  Insert;

                  FieldByName('TaxRollYr').Text := SmallClaimsTable.FieldByName('TaxRollYr').Text;
                  FieldByName('SwisSBLKey').Text := SmallClaimsTable.FieldByName('SwisSBLKey').Text;
                 (* FieldByName('AlternateID').Text := SmallClaimsTable.FieldByName('AlternateID').Text;*)
                  FieldByName('IndexNumber').Text := SmallClaimsTable.FieldByName('IndexNumber').Text;
                  FieldByName('PropertyClassCode').Text := SmallClaimsTable.FieldByName('PropertyClassCode').Text;
                  FieldByName('PetitName1').Text := SmallClaimsTable.FieldByName('PetitName1').Text;
                  FieldByName('PetitName2').Text := SmallClaimsTable.FieldByName('PetitName2').Text;
                  FieldByName('SchoolCode').Text := SmallClaimsTable.FieldByName('SchoolCode').Text;
                  FieldByName('CurrentTentativeValue').AsInteger := SmallClaimsTable.FieldByName('CurrentTentativeValue').AsInteger;
(*                  FieldByName('PetitGrievanceValue').AsInteger := SmallClaimsTable.FieldByName('PetitGrievanceValue').AsInteger;*)
                  FieldByName('CurrentTotalValue').AsInteger := SmallClaimsTable.FieldByName('CurrentTotalValue').AsInteger;
                  FieldByName('PetitTotalValue').AsInteger := SmallClaimsTable.FieldByName('PetitTotalValue').AsInteger;
                  FieldByName('LawyerCode').Text := SmallClaimsTable.FieldByName('LawyerCode').Text;
                  FieldByName('LegalAddr').Text := SmallClaimsTable.FieldByName('LegalAddr').Text;
                  FieldByName('LegalAddrNo').Text := SmallClaimsTable.FieldByName('LegalAddrNo').Text;

                  try
                    FieldByName('TrialDate').Text := TrialDate;
                  except
                  end;

                  Post;

                except;
                  SystemSupport(001, SortSmallClaimsTable, 'Error inserting into sort file.',
                                UnitName, GlblErrorDlgBox);
                end;

        end;  {If not Done}

  until Done;

end;  {FillSortFile}

{========================================================}
Procedure TSmallClaimsCalendarReportForm.PrintButtonClick(Sender: TObject);

var
  SortFileName, NewFileName : String;
  Quit : Boolean;

begin
  ReportCancelled := False;
  Quit := False;
  ExtractToExcel := ExtractToExcelCheckBox.Checked;

(*  UseAlternateID := UseAlternateIDCheckBox.Checked;*)

    {CHG10121998-1: Add user options for default destination and show vet max msg.}

  SetPrintToScreenDefault(PrintDialog);

  If PrintDialog.Execute
    then
      begin
        CreateParcelList := CreateParcelListCheckBox.Checked;
        If CreateParcelList
          then ParcelListDialog.ClearParcelGrid(True);

        If ExtractToExcel
          then
            begin
              SpreadsheetFileName := GetPrintFileName('SL', True);
              AssignFile(ExtractFile, SpreadsheetFileName);
              Rewrite(ExtractFile);

            end;  {If ExtractToExcel}

        IncludeResults := IncludeResultsCheckBox.Checked;
        CalendarFormat := CalendarFormatCheckBox.Checked;

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
              ProgressDialog.UserLabelCaption := 'Creating Sort File';

              ProgressDialog.Start(GetRecordCount(SmallClaimsTable), True, True);

              SortSmallClaimsTable.Close;
              SortSmallClaimsTable.TableName := OrigSortFileName;

              SortFileName := GetSortFileName('SortSmallClaims');

              SortSmallClaimsTable.IndexName := '';
              CopySortFile(SortSmallClaimsTable, SortFileName);
              SortSmallClaimsTable.Close;
              SortSmallClaimsTable.TableName := SortFileName;
              SortSmallClaimsTable.Exclusive := True;

              try
                SortSmallClaimsTable.Open;
              except
                Quit := True;
                SystemSupport(060, SortSmallClaimsTable, 'Error opening sort table.',
                              UnitName, GlblErrorDlgBox);
              end;

              FillSortTable(Quit);

              PrintOrder := PrintOrderRadioGroupBox.ItemIndex;

              with SortSmallClaimsTable do
                case PrintOrder of
                  poParcelID : IndexName := 'BySwisSBLKey';
                  poIndexNumber : IndexName := 'ByIndexNumber';
                  poTrialDate : IndexName := 'ByTrialDate';
                end;

              ProgressDialog.Reset;

                {Now print the report.}

              If not (Quit or ReportCancelled)
                then
                  begin
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

                      {FXX07221998-1: So that more than one person can run the report
                                      at once, use a time based name first and then
                                      rename.}

                      {If they want to see it on the screen, start the preview.}

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

                          ShowReportDialog('Small Claims Calendar Report.RPT', NewFileName, True);

                        end
                      else ReportPrinter.Execute;

                  end;  {If not Quit}

              SortSmallClaimsTable.Close;

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

            end;  {If not Quit}

        ResetPrinter(ReportPrinter);

      end;  {If PrintDialog.Execute}

end;  {PrintButtonClick}

{====================================================================}
Procedure TSmallClaimsCalendarReportForm.ReportPrintHeader(Sender: TObject);

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

      Println('');
      Println('');

      SetFont('Times New Roman',14);
      Bold := True;
      Home;
      Println('');
      PrintCenter('Small Claims Calendar', (PageWidth / 2));
      Println('');
      Println('');

      SetFont('Times New Roman',8);
      ClearTabs;

      If not CalendarFormat
        then
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
                    #9 + 'SM CL' +
                    #9 + 'CLAIM' +
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

      Bold := False;

    end;  {with Sender as TBaseReport do}

end;  {TextFilerPrintHeader}

{====================================================================}
Procedure TSmallClaimsCalendarReportForm.ReportPrint(Sender: TObject);

var
  Done, FirstTimeThrough : Boolean;
  SwisSBLKey : String;
  ParcelID, ShortSchoolCode,
  NameLine1, NameLine2 : String;
(*  TotalTentativeValue, TotalGrievanceClaim,
  TotalFinalAssessment, TotalCertClaim : LongInt; *)

begin
  Done := False;
  FirstTimeThrough := True;

(*  TotalTentativeValue := 0;
  TotalGrievanceClaim := 0;
  TotalFinalAssessment := 0;
  TotalCertClaim := 0; *)

  ProgressDialog.Start(GetRecordCount(SortSmallClaimsTable), True, True);

  SortSmallClaimsTable.First;

  with Sender as TBaseReport do
    begin
      repeat
        If FirstTimeThrough
          then FirstTimeThrough := False
          else SortSmallClaimsTable.Next;

        If SortSmallClaimsTable.EOF
          then Done := True;

        SwisSBLKey := SortSmallClaimsTable.FieldByName('SwisSBLKey').Text;
        Application.ProcessMessages;
        ProgressDialog.Update(Self, ConvertSwisSBLToDashDot(SwisSBLKey));

        If not Done
          then
            begin
              with SortSmallClaimsTable do
                If CalendarFormat
                  then
                    begin
                    end
                  else
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

                      (*If UseAlternateID
                        then ParcelID := FieldByName('AlternateID').Text
                        else*) ParcelID := ConvertSBLOnlyToDashDot(Copy(SwisSBLKey, 7, 20));

                      Println(#9 + FieldByName('TaxRollYr').Text +
                              #9 + FieldByName('IndexNumber').Text +
                              #9 + FieldByName('PropertyClassCode').Text +
                              #9 + ShortSchoolCode +
                              #9 + Take(20, ParcelID) +
                              #9 + Take(20, NameLine1) +
                              #9 + FieldByName('LawyerCode').Text +
(*                              #9 + FormatFloat(NoDecimalDisplay,
                                               FieldByName('CurrentTentativeValue').AsFloat) +
                              #9 + FormatFloat(NoDecimalDisplay,
                                               FieldByName('PetitGrievanceValue').AsFloat) +
                              #9 + FormatFloat(NoDecimalDisplay,
                                               (FieldByName('CurrentTentativeValue').AsFloat -
                                                FieldByName('PetitGrievanceValue').AsFloat)) +*)
                              #9 + Take(16, GetLegalAddressFromTable(SortSmallClaimsTable)) +
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

(*                      TotalTentativeValue := TotalTentativeValue +
                                             FieldByName('CurrentTentativeValue').AsInteger;
                      TotalGrievanceClaim := TotalGrievanceClaim +
                                             FieldByName('PetitGrievanceValue').AsInteger;
                      TotalFinalAssessment := TotalFinalAssessment +
                                              FieldByName('CurrentTotalValue').AsInteger;
                      TotalCertClaim := TotalCertClaim +
                                        FieldByName('PetitTotalValue').AsInteger; *)

                    end;  {If not If CalendarFormat}

              If (CreateParcelList and
                  (not ParcelListDialog.ParcelExistsInList(SwisSBLKey)))
                then ParcelListDialog.AddOneParcel(SwisSBLKey);

                {If there is only one line left to print, then we
                 want to go to the next page.}

              If (LinesLeft <= LinesLeftAtBottom)
                then NewPage;

            end;  {If not Done}

        ReportCancelled := ProgressDialog.Cancelled;

      until (Done or ReportCancelled);

    end;  {with Sender as TBaseReport do}

end;  {ReportPrinterPrint}

{===============================================================}
Procedure TSmallClaimsCalendarReportForm.CloseButtonClick(Sender: TObject);

begin
  Close;
end;

{===================================================================}
Procedure TSmallClaimsCalendarReportForm.FormClose(    Sender: TObject;
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