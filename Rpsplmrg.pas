unit Rpsplmrg;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, DBCtrls, DBTables, DB, Buttons, Grids,
  Wwdbigrd, Wwdbgrid, ExtCtrls, Wwtable, Wwdatsrc, Menus, Mask, (*Progress,*)
  RPFiler, RPDefine, RPBase, RPCanvas, RPrinter;

type
  TSplitMergeReportForm = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    ScrollBox1: TScrollBox;
    CloseButton: TBitBtn;
    TitleLabel: TLabel;
    SplitMergeHdrTable: TTable;
    DateGroupBox: TGroupBox;
    Label7: TLabel;
    Label8: TLabel;
    AllDatesCheckBox: TCheckBox;
    ToEndofDatesCheckBox: TCheckBox;
    EndDateEdit: TMaskEdit;
    StartDateEdit: TMaskEdit;
    PrintOrderRadioGroup: TRadioGroup;
    SplitMergeNumberGroupBox: TGroupBox;
    Label11: TLabel;
    Label12: TLabel;
    StartSplitMergeNumberEdit: TEdit;
    EndSplitMergeNumberEdit: TEdit;
    AllSplitMergeNumbersCheckBox: TCheckBox;
    ToEndOfSplitMergeNumbersCheckBox: TCheckBox;
    PrintButton: TBitBtn;
    ReportPrinter: TReportPrinter;
    ReportFiler: TReportFiler;
    PrintDialog: TPrintDialog;
    TYParcelTable: TTable;
    NYParcelTable: TTable;
    SplitMergeDtlTable: TTable;
    SplitMergeHdrDataSource: TDataSource;
    AssessmentTable: TTable;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure PrintButtonClick(Sender: TObject);
    procedure ReportPrintHeader(Sender: TObject);
    procedure ReportPrint(Sender: TObject);
    procedure AllDatesCheckBoxClick(Sender: TObject);
    procedure ToEndofDatesCheckBoxClick(Sender: TObject);
    procedure AllSplitMergeNumbersCheckBoxClick(Sender: TObject);
    procedure ToEndOfSplitMergeNumbersCheckBoxClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    UnitName : String;

    PrintAllDates,
    PrintAllSplitMergeNumbers,
    PrintToEndOfDates,
    PrintToEndOfSplitMergeNumbers : Boolean;

    StartDate,
    EndDate : TDateTime;
    StartSplitMergeNumber,
    EndSplitMergeNumber : String;

    ReportCancelled : Boolean;
    PrintOrder : Integer;

    Procedure InitializeForm;  {Open the tables and setup.}
    Function ValidSelections : Boolean;
    Function RecordInRange : Boolean;
    Procedure PrintDetails(Sender : TObject;
                           SectionType : String;
                           ProcessingYears : Integer);

  end;

implementation

uses GlblVars, WinUtils, Utilitys, GlblCnst, PASUTILS, UTILEXSD,
     Prog, PASTypes, Preview, Types;

{$R *.DFM}

{========================================================}
Procedure TSplitMergeReportForm.FormActivate(Sender: TObject);

begin
  SetFormStateMaximized(Self);
end;

{========================================================}
Procedure TSplitMergeReportForm.InitializeForm;

var
  Quit : Boolean;

begin
  UnitName := 'RPSPLMRG';  {mmm}

  OpenTablesForForm(Self, GlblProcessingType);

  OpenTableForProcessingType(TYParcelTable, ParcelTableName, ThisYear, Quit);
  OpenTableForProcessingType(NYParcelTable, ParcelTableName, NextYear, Quit);
  OpenTableForProcessingType(AssessmentTable, AssessmentTableName, NextYear, Quit);

end;  {InitializeForm}

{======================================================================}
Function TSplitMergeReportForm.ValidSelections : Boolean;

{FXX02172000-2: If they don't check all, default it.}

begin
  Result := True;

    {Make sure that they selected a print order.}

  If (PrintOrderRadioGroup.ItemIndex = -1)
    then
      begin
        Result := False;
        MessageDlg('Please select the print order that you want.',
                   mtError, [mbOK], 0);
      end;

    {Now make sure that they selected a date range.}

  If Result
    then
      begin
        Result := False;

        If AllDatesCheckBox.Checked
          then Result := True
          else
            If (StartDateEdit.Text = '  /  /    ')
              then
                begin
                  If (EndDateEdit.Text = '  /  /    ')
                    then
                      begin
                        Result := True;
                        AllDatesCheckBox.Checked := True;
                      end;

                end
              else
                begin  {Start date filled in}
                  If (EndDateEdit.Text = '  /  /    ')
                    then
                      begin
                        If ToEndofDatesCheckBox.Checked
                          then Result := True;
                      end
                    else Result := True;

                end;  {else of If (StartDateEdit.Text = '  /  /    ')}

        If not Result
          then MessageDlg('Please enter a date range.',
                          mtError, [mbOK], 0);

      end;  {If Result}

    {Now make sure that they selected a split merge # range.}

  If Result
    then
      begin
        Result := False;

        If AllSplitMergeNumbersCheckBox.Checked
          then Result := True
          else
            If (Deblank(StartSplitMergeNumberEdit.Text) = '')
              then
                begin
                  If (Deblank(EndSplitMergeNumberEdit.Text) = '')
                    then
                      begin
                        Result := True;
                        AllSplitMergeNumbersCheckBox.Checked := True;
                      end;

                end
              else
                begin  {Start merge # filled in.}
                  If (Deblank(EndSplitMergeNumberEdit.Text) = '')
                    then
                      begin
                        If ToEndOfSplitMergeNumbersCheckBox.Checked
                          then Result := True;
                      end
                    else Result := True;

                end;  {else of If (Deblank(StartSplitMergeNumberEdit.Text) = '')}

        If not Result
          then MessageDlg('Please enter a split merge number range.',
                          mtError, [mbOK], 0);

      end;  {If Result}

end;  {ValidSelections}

{===============================================================}
Procedure TSplitMergeReportForm.AllDatesCheckBoxClick(Sender: TObject);

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

{===============================================================}
Procedure TSplitMergeReportForm.ToEndofDatesCheckBoxClick(Sender: TObject);

begin
  If ToEndOfDatesCheckBox.Checked
    then
      begin
        EndDateEdit.Text := '';
        EndDateEdit.Enabled := False;
        EndDateEdit.Color := clBtnFace;
      end
    else
      begin
        EndDateEdit.Enabled := True;
        EndDateEdit.Color := clWindow;

      end;  {If ToEndOfDatesCheckBox.Checked}

end;  {ToEndofDatesCheckBoxClick}

{===============================================================}
Procedure TSplitMergeReportForm.AllSplitMergeNumbersCheckBoxClick(Sender: TObject);

begin
  If AllSplitMergeNumbersCheckBox.Checked
    then
      begin
        ToEndofSplitMergeNumbersCheckBox.Checked := False;
        ToEndofSplitMergeNumbersCheckBox.Enabled := False;
        StartSplitMergeNumberEdit.Text := '';
        StartSplitMergeNumberEdit.Enabled := False;
        StartSplitMergeNumberEdit.Color := clBtnFace;
        EndSplitMergeNumberEdit.Text := '';
        EndSplitMergeNumberEdit.Enabled := False;
        EndSplitMergeNumberEdit.Color := clBtnFace;

      end
    else EnableSelectionsInGroupBoxOrPanel(SplitMergeNumberGroupBox);

end;  {AllSplitMergeNumbersCheckBoxClick}

{===============================================================}
Procedure TSplitMergeReportForm.ToEndOfSplitMergeNumbersCheckBoxClick(Sender: TObject);

begin
  If ToEndOfSplitMergeNumbersCheckBox.Checked
    then
      begin
        EndSplitMergeNumberEdit.Text := '';
        EndSplitMergeNumberEdit.Enabled := False;
        EndSplitMergeNumberEdit.Color := clBtnFace;
      end
    else
      begin
        EndSplitMergeNumberEdit.Enabled := True;
        EndSplitMergeNumberEdit.Color := clWindow;

      end;  {If ToEndOfSplitMergeNumbersCheckBox.Checked}

end;  {ToEndOfSplitMergeNumbersCheckBoxClick}

{======================================================================}
Procedure TSplitMergeReportForm.PrintButtonClick(Sender: TObject);

var
  Quit : Boolean;
  NewFileName : String;
  TempFile : File;

begin
  Quit := False;
  ReportCancelled := False;

    {FXX09301998-1: Disable print button after clicking to avoid clicking twice.}

  PrintButton.Enabled := False;
  Application.ProcessMessages;
  Quit := False;

    {CHG10121998-1: Add user options for default destination and show vet max msg.}

  SetPrintToScreenDefault(PrintDialog);

  If (ValidSelections and
      PrintDialog.Execute)
    then
      begin
          {CHG10131998-1: Set the printer settings based on what printer they selected
                          only - they no longer need to worry about paper or landscape
                          mode.}

        AssignPrinterSettings(PrintDialog, ReportPrinter, ReportFiler, [ptLaser], False, Quit);

        PrintOrder := PrintOrderRadioGroup.ItemIndex;

          {Figure out the date range that they want to see.}

        PrintAllDates := AllDatesCheckBox.Checked;
        PrintToEndOfDates := ToEndofDatesCheckBox.Checked;

        try
          If (StartDateEdit.Text <> '  /  /    ')
            then StartDate := StrToDate(StartDateEdit.Text);
        except
          StartDate := 0;
        end;

        try
          If (EndDateEdit.Text <> '  /  /    ')
            then EndDate := StrToDate(EndDateEdit.Text);
        except
          EndDate := 0;
        end;

          {Figure out the split merge # range that they want to see.}

        PrintAllSplitMergeNumbers := AllSplitMergeNumbersCheckBox.Checked;
        PrintToEndOfSplitMergeNumbers := ToEndofSplitMergeNumbersCheckBox.Checked;
        StartSplitMergeNumber := StartSplitMergeNumberEdit.Text;
        EndSplitMergeNumber := EndSplitMergeNumberEdit.Text;

        case PrintOrder of
          0 : SplitMergeHdrTable.IndexName := 'BYSPLITMERGENO_DATE_TIME';
          1 : SplitMergeHdrTable.IndexName := 'BYDATE_TIME';
        end;

        ProgressDialog.Start(GetRecordCount(SplitMergeHdrTable), True, True);

          {Now print the report.}

        If not (Quit or ReportCancelled)
          then
            begin

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

              If PrintDialog.PrintToFile
                then
                  begin
                    NewFileName := GetPrintFileName(Self.Caption, True);
                    ReportFiler.FileName := NewFileName;

                    try
                      PreviewForm := TPreviewForm.Create(self);
                      PreviewForm.FilePrinter.FileName := NewFileName;
                      PreviewForm.FilePreview.FileName := NewFileName;

                      ReportFiler.Execute;

                        {FXX10111999-3: Make sure they know its done.}

                      ProgressDialog.StartPrinting(PrintDialog.PrintToFile);

                      PreviewForm.ShowModal;
                    finally
                      PreviewForm.Free;

                        {Now delete the file.}
                      try
                        AssignFile(TempFile, NewFileName);
                        OldDeleteFile(NewFileName);
                      finally
                        {We don't care if it does not get deleted, so we won't put up an
                         error message.}

                        ChDir(GlblProgramDir);
                      end;

                    end;  {try PreviewForm := ...}

                  end  {If PrintDialog.PrintToFile}
                else ReportPrinter.Execute;

              ResetPrinter(ReportPrinter);

            end;  {If not Quit}

        ProgressDialog.Finish;

          {FXX10111999-3: Tell people that printing is starting and
                          done.}

        DisplayPrintingFinishedMessage(PrintDialog.PrintToFile);

      end;  {If PrintDialog.Execute}

  PrintButton.Enabled := True;

end;  {PrintButtonClick}

{===================================================================}
Function TSplitMergeReportForm.RecordInRange : Boolean;

begin
  Result := False;

     {Check the date.}

  with SplitMergeHdrTable do
    If PrintAllDates
      then Result := True
      else
        If ((FieldByName('Date').AsDateTime >= StartDate) and
            (PrintToEndOfDates or
             (FieldByName('Date').AsDateTime <= EndDate)))
          then Result := True;

     {Check the split\merge number.}

  If Result
    then
      with SplitMergeHdrTable do
        begin
          Result := False;

          If PrintAllSplitMergeNumbers
            then Result := True
            else
              If ((FieldByName('SplitMergeNo').AsInteger >= StrToInt(StartSplitMergeNumber)) and
                  (PrintToEndOfSplitMergeNumbers or
                   (FieldByName('SplitMergeNo').AsInteger <= StrToInt(EndSplitMergeNumber))))
                then Result := True;

        end;  {If Result}

end;  {RecordInRange}

{===================================================================}
Procedure TSplitMergeReportForm.ReportPrintHeader(Sender: TObject);

var
  TempStr : String;

begin
  with Sender as TBaseReport do
    begin
        {Print the date and page number.}

      SectionTop := 0.25;
      SectionLeft := 0.5;
      SectionRight := PageWidth - 0.5;
      SetFont('Times New Roman',8);
      PrintHeader('Page: ' + IntToStr(CurrentPage), pjRight);
      PrintHeader('Date: ' + DateToStr(Date) + '  Time: ' + TimeToStr(Now), pjLeft);

      SectionTop := 0.5;
      SetFont('Arial',12);
      Bold := True;
      Home;
      PrintCenter('Split\Merge Report', (PageWidth / 2));
      SetFont('Times New Roman', 9);
      CRLF;

      ClearTabs;
      SetTab(0.5, pjLeft, 6.5, 0, BOXLINENONE, 0);   {Index}

      TempStr := 'For Dates: ';
      If PrintAllDates
        then Println(TempStr + 'All')
        else
          begin
            TempStr := TempStr + DateTimetoMMDDYYYY(StartDate) + ' to ';

            If PrintToEndOfDates
              then Println(TempStr + 'Last Date.')
              else Println(TempStr + DateTimetoMMDDYYYY(EndDate) + '.');

          end;  {If PrintAllDates}

      TempStr := 'For Split Merge Numbers:';
      If PrintAllSplitMergeNumbers
        then Println(TempStr + ' All')
        else
          begin
            TempStr := TempStr + StartSplitMergeNumber + ' to ';

            If PrintToEndOfSplitMergeNumbers
              then Println(TempStr + 'Last Split Merge Number.')
              else Println(TempStr + EndSplitMergeNumber + '.');

          end;  {If PrintAllSalesPrices}

    end;  {with Sender as TBaseReport do}

end;  {ReportPrintHeader}

{==========================================================}
Procedure PrintHeaderTabs(Sender : TObject;
                          SectionType : String);

{FXX10162008-1(2.16.1.1)[1387]: Add paging for details.}

begin
  with Sender as TBaseReport do
    begin
      ClearTabs;
      SetTab(0.5, pjLeft, 1.2, 0, BOXLINENONE, 0);   {Hdr}
      Println('');

      Underline := True;
      Bold := True;

      If (SectionType = 'D')
        then Println(#9 + 'Destination Parcels:')
        else Println(#9 + 'Source Parcels:');

      Underline := False;
      Bold := False;
      
      If (SectionType = 'D')
        then
          begin
            ClearTabs;
            SetTab(0.7, pjLeft, 1.4, 0, BOXLINENone, 0);   {Parcel ID}
            SetTab(2.2, pjLeft, 1.3, 0, BOXLINENone, 0);   {Name}
            SetTab(3.6, pjLeft, 1.3, 0, BOXLINENone, 0);   {Location}
            SetTab(5.0, pjCenter, 1.2, 0, BOXLINENone, 0);   {Existed Previously?}

            Println(#9 + #9 + #9 +
                    #9 + 'Existed Prior');

              {CHG07282001-1: Show most current AV.}

            ClearTabs;
            SetTab(0.7, pjCenter, 1.4, 0, BOXLINEBottom, 0);   {Parcel ID}
            SetTab(2.2, pjCenter, 1.3, 0, BOXLINEBottom, 0);   {Name}
            SetTab(3.6, pjCenter, 1.3, 0, BOXLINEBottom, 0);   {Location}
            SetTab(5.0, pjCenter, 1.2, 0, BOXLINEBottom, 0);   {Existed Previously?}
            SetTab(6.3, pjCenter, 1.1, 0, BOXLINEBottom, 0);   {AV}

            Println(#9 + 'Parcel ID' +
                    #9 + 'Name' +
                    #9 + 'Location' +
                    #9 + 'To Split\Merge' +
                    #9 + 'Current AV');

            ClearTabs;
            SetTab(0.7, pjLeft, 1.4, 0, BOXLINENONE, 0);   {Parcel ID}
            SetTab(2.2, pjLeft, 1.3, 0, BOXLINENONE, 0);   {Name}
            SetTab(3.6, pjLeft, 1.3, 0, BOXLINENONE, 0);   {Location}
            SetTab(5.0, pjCenter, 1.2, 0, BOXLINENONE, 0);   {Existed Previously?}
            SetTab(6.3, pjRight, 1.1, 0, BOXLINENone, 0);   {AV}

          end;  {If (SectionType = 'D')}

      If (SectionType = 'S')
        then
          begin
            ClearTabs;
            SetTab(0.7, pjCenter, 1.4, 0, BOXLINEBottom, 0);   {Parcel ID}
            SetTab(2.2, pjCenter, 1.3, 0, BOXLINEBottom, 0);   {Name}
            SetTab(3.6, pjCenter, 1.3, 0, BOXLINEBottom, 0);   {Location}
            SetTab(5.0, pjCenter, 1.2, 0, BOXLINEBottom, 0);   {Original AV}

            Println(#9 + 'Parcel ID' +
                    #9 + 'Name' +
                    #9 + 'Location' +
                    #9 + 'Original AV');

            ClearTabs;
            SetTab(0.7, pjLeft, 1.4, 0, BOXLINENone, 0);   {Parcel ID}
            SetTab(2.2, pjLeft, 1.3, 0, BOXLINENone, 0);   {Name}
            SetTab(3.6, pjLeft, 1.3, 0, BOXLINENone, 0);   {Location}
            SetTab(5.0, pjCenter, 1.2, 0, BOXLINENone, 0);   {Original AV}

          end;  {If (SectionType = 'S')}

    end;  {with Sender as TBaseReport do}

end;  {PrintHeaderTabs}

{===================================================================}
Procedure TSplitMergeReportForm.PrintDetails(Sender : TObject;
                                             SectionType : String;
                                             ProcessingYears : Integer);

var
  _Found, FirstTimeThrough, Done : Boolean;

begin
  FirstTimeThrough := True;
  Done := False;
  SplitMergeDtlTable.CancelRange;

    {FXX06181999-9: The section type is not part of the key, so can't set range on it.}

  SetRangeOld(SplitMergeDtlTable,
              ['SplitMergeNo', 'Date', 'Time', 'OrderInGrid'],
              [SplitMergeHdrTable.FieldByName('SplitMergeNo').Text,
               SplitMergeHdrTable.FieldByname('Date').Text,
               SplitMergeHdrTable.FieldByName('Time').Text, '0'],
              [SplitMergeHdrTable.FieldByName('SplitMergeNo').Text,
               SplitMergeHdrTable.FieldByname('Date').Text,
               SplitMergeHdrTable.FieldByName('Time').Text, '32000']);

  SplitMergeDtlTable.First;

  with Sender as TBaseReport do
    begin
      PrintHeaderTabs(Sender, SectionType);

      repeat
        If FirstTimeThrough
          then FirstTimeThrough := False
          else SplitMergeDtlTable.Next;

        If SplitMergeDtlTable.EOF
          then Done := True;

        If not Done
          then
            begin
              If (LinesLeft < 5)
                then
                  begin
                    NewPage;
                    PrintHeaderTabs(Sender, SectionType);
                  end;

                {FXX01272000-1: Need to store owner and legal addr as of split.}

(*              If (ProcessingYears in [NextYear, BothYears])
                then
                  begin
                    AssessmentYear := GlblNextYear;
                    TempTable := NYParcelTable;
                  end
                else
                  begin
                    AssessmentYear := GlblThisYear;
                    TempTable := TYParcelTable;
                  end;

              SwisSBLKey := SplitMergeDtlTable.FieldByName('SwisSBLKey').Text;
              SBLRec := ExtractSwisSBLFromSwisSBLKey(SwisSBLKey);

              with SBLRec do
                TempTable.FindKey([AssessmentYear, SwisCode, Section, Subsection,
                                   Block, Lot, Sublot, Suffix]); *)

              If (SplitMergeDtlTable.FieldByName('SourceOrDest').Text = SectionType)
                then
                  begin
                    Print(#9 + ConvertSwisSBLToDashDot(SplitMergeDtlTable.FieldByName('SwisSBLKey').Text) +
                          #9 + Take(15, SplitMergeDtlTable.FieldByName('Name').Text) +
                          #9 + Take(15, SplitMergeDtlTable.FieldByName('LegalAddress').Text));

                      {CHG07282001-1: Show most current AV.}

                    If (SectionType = 'D')
                      then
                        begin
                          Print(#9 + SplitMergeDtlTable.FieldByName('SBLExists').Text);

                          _Found := FindKeyOld(AssessmentTable, ['TaxRollYr', 'SwisSBLKey'],
                                               [GlblNextYear, SplitMergeDtlTable.FieldByName('SwisSBLKey').Text]);

                          If _Found
                            then Println(#9 + FormatFloat(CurrencyDisplayNoDollarSign,
                                                          AssessmentTable.FieldByName('TotalAssessedVal').AsFloat))
                            else Println(#9 + 'N/A');

                        end
                      else
                        try
                          Println(#9 + FormatFloat(CurrencyDisplayNoDollarSign,
                                                   SplitMergeDtlTable.FieldByName('OriginalAV').AsFloat));

                        except
                          Println('');
                        end;

                  end;  {If (SplitMergeDtlTable.FieldByName ...}

            end;  {If not Done}

      until Done;

    end;  {with Sender as TBaseReport do}

end;  {PrintDetails}

{===================================================================}
Procedure TSplitMergeReportForm.ReportPrint(Sender: TObject);

var
  FirstTimeThrough, Done : Boolean;
  TempStr1, TempStr2 : String;

begin
  FirstTimeThrough := True;
  Done := False;

  SplitMergeHdrTable.First;

  repeat
      {FXX05032000-9: Was getting an EOF when there were no details for a header.}

    If FirstTimeThrough
      then FirstTimeThrough := False
      else
        try
          SplitMergeHdrTable.Next;
        except
        end;

    If SplitMergeHdrTable.EOF
      then Done := True;

    Application.ProcessMessages;
    ProgressDialog.Update(Self, SplitMergeHdrTable.FieldByName('SplitMergeNo').Text);

    If ((not Done) and
        RecordInRange)
      then
        with Sender as TBaseReport do
          begin
            Println('');

              {First print the header information.}

            with SplitMergeHdrTable do
              begin
                ClearTabs;
                SetTab(0.3, pjLeft, 1.2, 0, BOXLINEBottom, 0);   {S\M #}
                SetTab(1.5, pjLeft, 1.0, 0, BOXLINEBottom, 0);   {Date}
                SetTab(2.5, pjLeft, 1.0, 0, BOXLINEBottom, 0);   {Time}

                Bold := True;
                Print(#9 + 'Split\Merge: ' + FieldByName('SplitMergeNo').Text);
                Bold := False;

                Println(#9 + 'Date: ' + FieldByName('Date').Text +
                        #9 + 'Time: ' + FormatDateTime(TimeFormat, FieldByName('Time').AsDateTime));

                ClearTabs;
                SetTab(0.5, pjLeft, 1.2, 0, BOXLINENONE, 0);   {S\M #}
                SetTab(2.1, pjLeft, 1.8, 0, BOXLINENONE, 0);   {Date}
                SetTab(4.0, pjLeft, 1.8, 0, BOXLINENONE, 0);   {Time}

                TempStr1 := UpperCaseFirstChars(ConvertModeToStr(FieldByName('Mode').AsInteger));

                case FieldByName('ProcessingYears').AsInteger of
                  ThisYear : TempStr2 := 'This Year';
                  NextYear : TempStr2 := 'Next Year';
                  BothYears : TempStr2 := 'Both Years';
                end;

                Println(#9 + 'Mode: ' + TempStr1 +
                        #9 + 'Inventory Copied: ' + FieldByName('CopyInventory').Text +
                        #9 + 'Assessment Year(s): ' + TempStr2);

                Println(#9 + 'Printed: ' + FieldByName('Printed').Text +
                        #9 + 'Sorce Parcel(s) Inactivated: ' + FieldByName('SourceParcelInactive').Text);

              end;  {with SplitMergeHdrTable do}

              {Now print the details.}
              {FXX05032000-9: Was getting an EOF when there were no details for a header.}

            PrintDetails(Sender, 'S', SplitMergeHdrTable.FieldByName('ProcessingYears').AsInteger);
            PrintDetails(Sender, 'D', SplitMergeHdrTable.FieldByName('ProcessingYears').AsInteger);

            NewPage;

          end;  {with Sender as TBaseReport do}

  until (Done or ProgressDialog.Cancelled);

end;  {ReportPrint}

{===================================================================}
Procedure TSplitMergeReportForm.FormClose(    Sender: TObject;
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