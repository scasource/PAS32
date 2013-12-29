unit Exemption_Remove;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, DBCtrls, DBTables, DB, Buttons, Grids,
  Wwdbigrd, Wwdbgrid, ExtCtrls, Wwtable, Wwdatsrc, Menus, RPCanvas,
  RPrinter, RPDefine, RPBase, RPFiler, locatdir, ComCtrls;

type
  TfmRemoveNonRenewedExemptions = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    lb_Title: TLabel;
    ReportFiler: TReportFiler;
    dlg_Print: TPrintDialog;
    ReportPrinter: TReportPrinter;
    tbExemptions: TTable;
    tbExemptionCodes: TTable;
    Panel3: TPanel;
    btn_Start: TBitBtn;
    btn_Close: TBitBtn;
    pgctl_Main: TPageControl;
    tbs_Options: TTabSheet;
    cbx_TrialRun: TCheckBox;
    rg_AssessmentYear: TRadioGroup;
    tbs_ExemptionCodes: TTabSheet;
    Panel4: TPanel;
    Label1: TLabel;
    lbx_ExemptionCodes: TListBox;
    tbExemptionsLookup: TTable;
    tbRemovedExemptions: TTable;
    tbAuditEXChange: TTable;
    tbAudit: TTable;
    tbAssessment: TTable;
    tbClass: TTable;
    tbSwisCodes: TTable;
    tbParcel: TTable;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btn_StartClick(Sender: TObject);
    procedure ReportPrintHeader(Sender: TObject);
    procedure ReportPrint(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    AssessmentYear, UnitName : String;
    ProcessingType : Integer;
    TrialRun, ReportCancelled : Boolean;
    SelectedExemptionCodes : TStringList;

    Procedure InitializeForm;  {Open the tables and setup.}
    Procedure FillListBoxes(ProcessingType : Integer;
                            AssessmentYear : String);

  end;

implementation

uses GlblVars, WinUtils, Utilitys, GlblCnst, PASUtils, Prog, Preview,
     Types, PASTypes, UtilEXSD, DataAccessUnit;

{$R *.DFM}

{========================================================}
Procedure TfmRemoveNonRenewedExemptions.FormActivate(Sender: TObject);

begin
  SetFormStateMaximized(Self);
end;

{========================================================}
Procedure TfmRemoveNonRenewedExemptions.FillListBoxes(ProcessingType : Integer;
                                                       AssessmentYear : String);

var
  Quit : Boolean;

begin
  OpenTableForProcessingType(tbExemptionCodes, ExemptionCodesTableName,
                             ProcessingType, Quit);

  FillOneListBox(lbx_ExemptionCodes, tbExemptionCodes,
                 'EXCode', 'Description', 10,
                 True, True, ProcessingType, AssessmentYear);

end;  {FillListBoxes}

{========================================================}
Procedure TfmRemoveNonRenewedExemptions.InitializeForm;

begin
  UnitName := 'Exemption_Remove';
    {Default assessment year.}

  case GlblProcessingType of
    NextYear : begin
                 rg_AssessmentYear.ItemIndex := 1;
                 ProcessingType := NextYear;
                 AssessmentYear := GlblNextYear;
               end;  {NextYear}

    ThisYear : begin
                 rg_AssessmentYear.ItemIndex := 0;
                 ProcessingType := ThisYear;
                 AssessmentYear := GlblThisYear;
               end;  {This Year}

  end;  {case GlblProcessingType of}

  FillListBoxes(ProcessingType, AssessmentYear);

end;  {InitializeForm}

{===================================================================}
Procedure TfmRemoveNonRenewedExemptions.ReportPrintHeader(Sender: TObject);

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
      PrintCenter('Remove Non-Renewed Exemptions', (PageWidth / 2));
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
      SetTab(0.3, pjCenter, 1.3, 0, BOXLINENone, 0);   {Parcel ID}
      SetTab(1.7, pjCenter, 0.6, 0, BOXLINENone, 0);   {EX Code}
      SetTab(2.4, pjCenter, 0.8, 0, BOXLINENone, 0);   {Initial date}
      SetTab(3.3, pjCenter, 1.0, 0, BOXLINENone, 0);   {County amount}
      SetTab(4.4, pjCenter, 1.0, 0, BOXLINENone, 0);   {Municipal amount}
      SetTab(5.5, pjCenter, 1.0, 0, BOXLINENone, 0);   {School amount}

      Print(#9 + #9 +
            #9 + 'Initial');

      If (rtdCounty in GlblRollTotalsToShow)
        then Print(#9 + 'County')
        else Print(#9);

      If (rtdMunicipal in GlblRollTotalsToShow)
        then Print(#9 + GetMunicipalityTypeName(GlblMunicipalityType))
        else Print(#9);

      If (rtdSchool in GlblRollTotalsToShow)
        then Println(#9 + 'School')
        else Println(#9);

      ClearTabs;
      SetTab(0.3, pjCenter, 1.3, 0, BOXLINEBottom, 0);   {Parcel ID}
      SetTab(1.7, pjCenter, 0.6, 0, BOXLINEBottom, 0);   {EX Code}
      SetTab(2.4, pjCenter, 0.8, 0, BOXLINEBottom, 0);   {Initial date}
      SetTab(3.3, pjCenter, 1.0, 0, BOXLINEBottom, 0);   {County amount}
      SetTab(4.4, pjCenter, 1.0, 0, BOXLINEBottom, 0);   {Municipal amount}
      SetTab(5.5, pjCenter, 1.0, 0, BOXLINEBottom, 0);   {School amount}

      Print(#9 + 'Parcel ID' +
            #9 + 'EX Code' +
            #9 + 'Date');

      If (rtdCounty in GlblRollTotalsToShow)
        then Print(#9 + 'Amount')
        else Print(#9);

      If (rtdMunicipal in GlblRollTotalsToShow)
        then Print(#9 + 'Amount')
        else Print(#9);

      If (rtdSchool in GlblRollTotalsToShow)
        then Println(#9 + 'Amount')
        else Println(#9);

      ClearTabs;
      SetTab(0.3, pjLeft, 1.3, 0, BOXLINENone, 0);   {Parcel ID}
      SetTab(1.7, pjLeft, 0.6, 0, BOXLINENone, 0);   {EX Code}
      SetTab(2.4, pjLeft, 0.8, 0, BOXLINENone, 0);   {Initial date}
      SetTab(3.3, pjRight, 1.0, 0, BOXLINENone, 0);   {County amount}
      SetTab(4.4, pjRight, 1.0, 0, BOXLINENone, 0);   {Municipal amount}
      SetTab(5.5, pjRight, 1.0, 0, BOXLINENone, 0);   {School amount}

      Bold := False;
      
    end;  {with Sender as TBaseReport do}

end;  {ReportPrintHeader}

{===================================================================}
Procedure TfmRemoveNonRenewedExemptions.ReportPrint(Sender: TObject);

var
  ExemptionCode, SwisSBLKey : String;
  NumberRemoved : LongInt;

begin
  NumberRemoved := 0;

  tbExemptions.First;

  with Sender as TBaseReport, tbExemptions do
    begin
      while (not (EOF or ReportCancelled)) do
        begin
          ExemptionCode := FieldByName('ExemptionCode').AsString;
          SwisSBLKey := FieldByName('SwisSBLKey').AsString;
          ProgressDialog.Update(Self, ConvertSwisSBLToDashDot(SwisSBLKey));
          ProgressDialog.UserLabelCaption := 'Number Removed = ' + IntToStr(NumberRemoved);
          Application.ProcessMessages;

          If ((SelectedExemptionCodes.IndexOf(ExemptionCode) <> -1) and
              (not FieldByName('ExemptionApproved').AsBoolean) and
              (not FieldByName('PreventRenewal').AsBoolean))
            then
              begin
                If _Compare(LinesLeft, 5, coLessThan)
                  then NewPage;

                Inc(NumberRemoved);

                Print(#9 + ConvertSwisSBLToDashDot(FieldByName('SwisSBLKey').Text) +
                      #9 + ExemptionCode +
                      #9 + FieldByName('InitialDate').AsString);

                If (rtdCounty in GlblRollTotalsToShow)
                  then Print(#9 + FormatFloat(CurrencyDisplayNoDollarSign, FieldByName('CountyAmount').AsInteger))
                  else Print(#9);

                If (rtdMunicipal in GlblRollTotalsToShow)
                  then Print(#9 + FormatFloat(CurrencyDisplayNoDollarSign, FieldByName('TownAmount').AsInteger))
                  else Print(#9);

                If (rtdSchool in GlblRollTotalsToShow)
                  then Println(#9 + FormatFloat(CurrencyDisplayNoDollarSign, FieldByName('SchoolAmount').AsInteger))
                  else Println(#9);

                If not TrialRun
                  then
                    try
                      _Locate(tbParcel, [AssessmentYear, SwisSBLKey], '', [loParseSwisSBLKey]);

                      DeleteAnExemption(tbExemptions, tbExemptionsLookup,
                                        tbRemovedExemptions, tbAuditEXChange,
                                        tbAudit, tbAssessment,
                                        tbClass, tbSwisCodes,
                                        tbParcel, tbExemptionCodes,
                                        AssessmentYear, SwisSBLKey, nil);

                      Prior;
                    except
                      SystemSupport(80, tbExemptions, 'Error deleting exemption.',
                                    UnitName, GlblErrorDlgBox);
                    end;

              end;  {If ((not Done) and ...}

          ReportCancelled := ProgressDialog.Cancelled;
          Next;

        end;  {while not EOF do}

      ClearTabs;
      Println('');
      Println(#9 + 'Number removed = ' + IntToStr(NumberRemoved));

    end;  {with Sender as TBaseReport, tbExemptions do}

end;  {ReportPrint}

{===================================================================}
Procedure TfmRemoveNonRenewedExemptions.btn_StartClick(Sender: TObject);

var
  Quit : Boolean;
  NewFileName : String;
  TempFile : File;

begin
  Quit := False;
  ReportCancelled := False;
  TrialRun := cbx_TrialRun.Checked;
  ProcessingType := NextYear;
  SelectedExemptionCodes := TStringList.Create;
  FillSelectedItemList(lbx_ExemptionCodes, SelectedExemptionCodes, 5);

  case rg_AssessmentYear.ItemIndex of
    0 : ProcessingType := ThisYear;
    1 : ProcessingType := NextYear;
  end;

  OpenTablesForForm(Self, ProcessingType);

  btn_Start.Enabled := False;
  Application.ProcessMessages;
  Quit := False;

  SetPrintToScreenDefault(dlg_Print);

  If dlg_Print.Execute
    then
      begin
(*        OpenTablesForForm( *)
        AssignPrinterSettings(dlg_Print, ReportPrinter, ReportFiler,
                              [ptLaser], False, Quit);

        ProgressDialog.Start(GetRecordCount(tbExemptions), True, True);

          {Now print the report.}

        If not (Quit or ReportCancelled)
          then
            begin
              If dlg_Print.PrintToFile
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

                      ProgressDialog.StartPrinting(dlg_Print.PrintToFile);

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

        DisplayPrintingFinishedMessage(dlg_Print.PrintToFile);

      end;  {If PrintDialog.Execute}

  SelectedExemptionCodes.Free;
  btn_Start.Enabled := True;

end; {StartButtonClick}

{===================================================================}
Procedure TfmRemoveNonRenewedExemptions.FormClose(    Sender: TObject;
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