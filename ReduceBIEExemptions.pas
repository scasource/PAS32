unit ReduceBIEExemptions;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, DBCtrls, DBTables, DB, Buttons, Grids,
  Wwdbigrd, Wwdbgrid, ExtCtrls, Wwtable, Wwdatsrc, Menus, RPCanvas,
  RPrinter, RPDefine, RPBase, RPFiler, locatdir;

type
  TReduceBIEExemptionsForm = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    ScrollBox1: TScrollBox;
    CloseButton: TBitBtn;
    TitleLabel: TLabel;
    StartButton: TBitBtn;
    ReportFiler: TReportFiler;
    PrintDialog: TPrintDialog;
    ReportPrinter: TReportPrinter;
    ExemptionTable: TTable;
    AssessmentYearRadioGroup: TRadioGroup;
    TrialRunCheckBox: TCheckBox;
    cbxUseCalculatedAmounts: TCheckBox;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure StartButtonClick(Sender: TObject);
    procedure ReportPrintHeader(Sender: TObject);
    procedure ReportPrint(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    UnitName : String;
    ProcessingType : Integer;
    TrialRun, ReportCancelled, bUseCalculatedAmounts : Boolean;
    Procedure InitializeForm;  {Open the tables and setup.}

  end;

implementation

uses GlblVars, WinUtils, Utilitys, GlblCnst, PASUtils, Prog, Preview,
     Types, PASTypes, UtilEXSD;

{$R *.DFM}

{========================================================}
Procedure TReduceBIEExemptionsForm.FormActivate(Sender: TObject);

begin
  SetFormStateMaximized(Self);
end;

{========================================================}
Procedure TReduceBIEExemptionsForm.InitializeForm;

begin
  UnitName := 'ReduceBIEExemptions';
end;  {InitializeForm}

{===================================================================}
Procedure TReduceBIEExemptionsForm.ReportPrintHeader(Sender: TObject);

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
      PrintCenter('Reduce BIE Exemptions', (PageWidth / 2));
      SetFont('Times New Roman', 9);
      CRLF;
      Println('');

      Print('  Assessment Year: ');

      case ProcessingType of
        ThisYear : Println(' This Year');
        NextYear : Println(' Next Year');
      end;

      If TrialRun
        then Println('Trial run.');

      Println('');
      Bold := True;
      ClearTabs;
      SetTab(0.3, pjCenter, 1.2, 5, BOXLINEALL, 25);   {Parcel ID}
      SetTab(1.5, pjCenter, 0.8, 5, BOXLINEALL, 25);   {Original amount}
      SetTab(2.3, pjCenter, 0.8, 5, BOXLINEALL, 25);   {Previous amount}
      SetTab(3.1, pjCenter, 0.8, 5, BOXLINEALL, 25);   {New amount}
      SetTab(3.9, pjCenter, 0.6, 5, BOXLINEALL, 25);   {Difference}
      SetTab(4.5, pjCenter, 0.6, 5, BOXLINEALL, 25);   {Initial Date}
      SetTab(5.1, pjCenter, 0.6, 5, BOXLINEALL, 25);   {Termination date}
      SetTab(5.7, pjCenter, 2.0, 5, BOXLINEALL, 25);   {Notes}

      Println(#9 + 'Parcel ID' +
              #9 + 'Original Amt' +
              #9 + 'Current Amt' +
              #9 + 'New Amount' +
              #9 + 'Difference' +
              #9 + 'Init Date' +
              #9 + 'End Date' +
              #9 + 'Notes');

      Bold := False;
      ClearTabs;
      SetTab(0.3, pjLeft, 1.2, 5, BOXLINEALL, 0);   {Parcel ID}
      SetTab(1.5, pjRight, 0.8, 5, BOXLINEALL, 0);   {Original amount}
      SetTab(2.3, pjRight, 0.8, 5, BOXLINEALL, 0);   {Previous amount}
      SetTab(3.1, pjRight, 0.8, 5, BOXLINEALL, 0);   {New amount}
      SetTab(3.9, pjRight, 0.6, 5, BOXLINEALL, 0);   {Difference}
      SetTab(4.5, pjLeft, 0.6, 5, BOXLINEALL, 0);   {Initial Date}
      SetTab(5.1, pjLeft, 0.6, 5, BOXLINEALL, 0);   {Termination date}
      SetTab(5.7, pjLeft, 2.0, 5, BOXLINEALL, 0);   {Notes}

    end;  {with Sender as TBaseReport do}

end;  {ReportPrintHeader}

{===================================================================}
Procedure TReduceBIEExemptionsForm.ReportPrint(Sender: TObject);

var
  Done, FirstTimeThrough, Quit : Boolean;
  NumberReduced : Integer;
  OriginalBIEAmount, NewBIEAmount,
  OriginalExemptionAmount,
  TotalOriginalExemptionAmount, TotalNewBIEAmount,
  iCalculatedNewBIEAmount, iYearsDifference : LongInt;
  ExemptionAppliesArray : ExemptionAppliesArrayType;
  ExemptionCode, sMessage : String;
  wInitialYear, wCurrentYear, wMonth, wDay : Word;

begin
  NumberReduced := 0;
  FirstTimeThrough := True;
  Quit := False;
  TotalOriginalExemptionAmount := 0;
  TotalNewBIEAmount := 0;

  ExemptionTable.First;

  with Sender as TBaseReport, ExemptionTable do
    begin
      repeat
        If FirstTimeThrough
          then FirstTimeThrough := False
          else Next;

        Done := EOF;
        ProgressDialog.Update(Self, ConvertSwisSBLToDashDot(FieldByName('SwisSBLKey').Text));
        ProgressDialog.UserLabelCaption := 'Number BIE Exemptions Reduced = ' + IntToStr(NumberReduced);
        Application.ProcessMessages;
        ExemptionCode := FieldByName('ExemptionCode').Text;

        If ((not Done) and
            IsBIEExemptionCode(ExemptionCode))
          then
            begin
              If _Compare(LinesLeft, 5, coLessThan)
                then NewPage;

              OriginalBIEAmount := 0;
              NewBIEAmount := 0;
              OriginalExemptionAmount := 0;
              Inc(NumberReduced);

              try
                Edit;

                OriginalBIEAmount := FieldByName('OriginalBIEAmount').AsInteger;
                NewBIEAmount := FieldByName('Amount').AsInteger -
                                Round(OriginalBIEAmount / 10);
                OriginalExemptionAmount := FieldByName('Amount').AsInteger;
                sMessage := 'Reduced.';

                If bUseCalculatedAmounts
                  then
                    begin
                      DecodeDate(FieldByName('InitialDate').AsDateTime, wInitialYear, wMonth, wDay);
                      DecodeDate(StrToDate('1/1/' + FieldByName('TaxRollYr').AsString), wCurrentYear, wMonth, wDay);
                      iYearsDifference := wCurrentYear - wInitialYear;
                      If _Compare(iYearsDifference, 0, coLessThan)
                        then iYearsDifference := 0;
                        
                      iCalculatedNewBIEAmount := FieldByName('OriginalBIEAmount').AsInteger -
                                                 (iYearsDifference * Round(OriginalBIEAmount / 10));

                      If _Compare(iCalculatedNewBIEAmount, NewBIEAmount, coNotEqual)
                        then sMessage := 'Reduced, normal reduction = ' + FormatFloat(IntegerDisplay, NewBIEAmount);

                      NewBIEAmount := iCalculatedNewBIEAmount;

                    end;  {If bUseCalculatedAmounts}

                FieldByName('Amount').AsInteger := NewBIEAmount;

                ExemptionAppliesArray := ExApplies(ExemptionCode, FieldByName('ApplyToVillage').AsBoolean);

                If ExemptionAppliesArray[exMunicipal]
                  then FieldByName('TownAmount').AsInteger := NewBIEAmount;

                If ExemptionAppliesArray[exCounty]
                  then FieldByName('CountyAmount').AsInteger := NewBIEAmount;

                If ExemptionAppliesArray[exSchool]
                  then FieldByName('SchoolAmount').AsInteger := NewBIEAmount;

                If ExemptionAppliesArray[exVillage]
                  then FieldByName('VillageAmount').AsInteger := NewBIEAmount;

                If TrialRun
                  then Cancel
                  else Post;
              except
                Quit := True;
                SystemSupport(80, ExemptionTable, 'Error updating BIE amount.',
                              UnitName, GlblErrorDlgBox);
              end;

              Inc(TotalOriginalExemptionAmount, OriginalExemptionAmount);
              Inc(TotalNewBIEAmount, NewBIEAmount);

                {If the new BIE amount is 0, then delete it.}

              If (_Compare(NewBIEAmount, 0, coLessThanOrEqual) or
                  (_Compare(FieldByName('TerminationDate').AsString, coNotBlank) and
                   _Compare(FieldByName('TerminationDate').AsDateTime, Date, coLessThan)))
                then
                  begin
                    try
                      Println(#9 + ConvertSwisSBLToDashDot(FieldByName('SwisSBLKey').Text) +
                              #9 + FormatFloat(CurrencyDisplayNoDollarSign, OriginalBIEAmount) +
                              #9 + FormatFloat(CurrencyDisplayNoDollarSign, OriginalExemptionAmount) +
                              #9 + FormatFloat(CurrencyDisplayNoDollarSign, NewBIEAmount) +
                              #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                                               (NewBIEAmount - OriginalExemptionAmount)) +
                              #9 + FieldByName('InitialDate').AsString +
                              #9 + FieldByName('TerminationDate').AsString +
                              #9 + 'Deleted.');

                      If not TrialRun
                        then
                          begin
                            Delete;
                            Prior;
                          end;

                    except
                      Quit := True;
                      SystemSupport(80, ExemptionTable, 'Error deleting exemption.',
                                    UnitName, GlblErrorDlgBox);
                    end;

                  end
                else Println(#9 + ConvertSwisSBLToDashDot(FieldByName('SwisSBLKey').Text) +
                             #9 + FormatFloat(CurrencyDisplayNoDollarSign, OriginalBIEAmount) +
                             #9 + FormatFloat(CurrencyDisplayNoDollarSign, OriginalExemptionAmount) +
                             #9 + FormatFloat(CurrencyDisplayNoDollarSign, NewBIEAmount) +
                             #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                                              (NewBIEAmount - OriginalExemptionAmount)) +
                             #9 + FieldByName('InitialDate').AsString +
                             #9 + FieldByName('TerminationDate').AsString +
                             #9 + sMessage);

            end;  {If ((not Done) and ...}

        ReportCancelled := ProgressDialog.Cancelled;

      until (Done or ReportCancelled or Quit);

      Println(#9 + #9 + #9 + #9 + #9 + #9 + #9);
      Bold := True;
      ClearTabs;
      SetTab(0.3, pjLeft, 1.5, 5, BOXLINEALL, 25);   {Parcel ID}
      SetTab(1.8, pjRight, 0.8, 5, BOXLINEALL, 25);   {Original amount}
      SetTab(2.6, pjRight, 0.8, 5, BOXLINEALL, 25);   {Previous Amount}
      SetTab(3.4, pjRight, 0.8, 5, BOXLINEALL, 25);   {New amount}
      SetTab(4.2, pjRight, 0.8, 5, BOXLINEALL, 25);   {Difference}
      SetTab(5.0, pjLeft, 0.8, 5, BOXLINEALL, 25);   {Termination date}
      SetTab(5.8, pjLeft, 2.0, 5, BOXLINEALL, 25);   {Notes}

      Println(#9 + 'Total' + #9 +
              #9 + FormatFloat(CurrencyDisplayNoDollarSign, TotalOriginalExemptionAmount) +
              #9 + FormatFloat(CurrencyDisplayNoDollarSign, TotalNewBIEAmount) +
              #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                               (TotalNewBIEAmount - TotalOriginalExemptionAmount)) +
              #9 + #9);

      ClearTabs;
      Println('');
      Println(#9 + 'Number reduced = ' + IntToStr(NumberReduced));

    end;  {with Sender as TBaseReport do}

end;  {ReportPrint}

{===================================================================}
Procedure TReduceBIEExemptionsForm.StartButtonClick(Sender: TObject);

var
  Quit : Boolean;
  NewFileName : String;
  TempFile : File;

begin
  Quit := False;
  ReportCancelled := False;
  TrialRun := TrialRunCheckBox.Checked;
  ProcessingType := NextYear;
  bUseCalculatedAmounts := cbxUseCalculatedAmounts.Checked;

  case AssessmentYearRadioGroup.ItemIndex of
    0 : ProcessingType := ThisYear;
    1 : ProcessingType := NextYear;
  end;

  StartButton.Enabled := False;
  Application.ProcessMessages;
  Quit := False;

  SetPrintToScreenDefault(PrintDialog);

  If PrintDialog.Execute
    then
      begin
        OpenTableForProcessingType(ExemptionTable, ExemptionsTableName, ProcessingType, Quit);
        AssignPrinterSettings(PrintDialog, ReportPrinter, ReportFiler,
                              [ptLaser], False, Quit);

        ProgressDialog.Start(GetRecordCount(ExemptionTable), True, True);

          {Now print the report.}

        If not (Quit or ReportCancelled)
          then
            begin
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

  StartButton.Enabled := True;

end; {StartButtonClick}

{===================================================================}
Procedure TReduceBIEExemptionsForm.FormClose(    Sender: TObject;
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