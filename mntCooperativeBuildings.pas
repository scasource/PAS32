unit mntCooperativeBuildings;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  StdCtrls, ExtCtrls, Forms, Dialogs, DB, Grids, DBGrids,
  DBTables, Mask, DBCtrls, Wwtable, Wwdatsrc, Wwdbcomb, Wwdbigrd, Wwdbgrid,
  Btrvdlg, Types, wwdblook, Buttons, ComCtrls, RPFiler, RPDefine, RPBase,
  RPCanvas, RPrinter;

type
  TfmCooperativeBuildings = class(TForm)
    tbCooperativeBuildings: TwwTable;
    Panel1: TPanel;
    TitleLabel: TLabel;
    Panel2: TPanel;
    Panel5: TPanel;
    lvCooperativeBuildings: TListView;
    Panel4: TPanel;
    btnNew: TBitBtn;
    btnDelete: TBitBtn;
    tnClose: TBitBtn;
    btnPrint: TBitBtn;
    ReportPrinter: TReportPrinter;
    ReportFiler: TReportFiler;
    dlgPrint: TPrintDialog;
    btnUpdate: TBitBtn;
    YearLabel: TLabel;
    tbCooperativeBuildings2: TwwTable;

    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure tnCloseClick(Sender: TObject);
    procedure lvCooperativeBuildingsClick(Sender: TObject);
    procedure btnNewClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure lvCooperativeBuildingsKeyPress(Sender: TObject;
      var Key: Char);
    procedure ReportPrint(Sender: TObject);
    procedure btnPrintClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure btnUpdateClick(Sender: TObject);

  protected
  public
    UnitName, sCurrentAssessmentYear : String;  {For use with error dialog box.}
    EditMode : Char;  {A = Add; M = Modify; V = View}
    FormAccessRights, iReportType,
    iMode, iCurrentProcessingType : Integer;
    bExtractToExcel, bTrialRun : Boolean;
    flExtractFile : TextFile;

    Procedure InitializeForm;
    Procedure FillInMainListView;
    Procedure ShowSubform(iCoopID : LongInt;
                          sEditMode : String);
    Procedure RecalculateOneYear(sAssessmentYear : String;
                                 iProcessingType : Integer);
    Procedure UpdateCoopsOneYear(sAssessmentYear : String;
                                 iProcessingType : Integer);

  end;    {end form object definition}

implementation

uses GlblVars, PASTypes, WinUtils, PASUTILS, UTILEXSD,  Utilitys,
     GlblCnst, DataAccessUnit, mntCooperativeBuildingEntry, Preview, Prog,
     RtCalcul, Util_Coops;


{$R *.DFM}

const
  rtSummary = 0;
  rtDetailed = 1;

  mdNoChange = 0;
  mdUpdate = 1;

{====================================================================}
Procedure TfmCooperativeBuildings.FormActivate(Sender: TObject);

begin
  SetFormStateMaximized(Self);
end;

{====================================================================}
Procedure TfmCooperativeBuildings.FillInMainListView;

begin
  lvCooperativeBuildings.Items.Clear;

  with tbCooperativeBuildings2 do
    begin
      First;

      while (not EOF) do
        begin
          FillInListViewRow(lvCooperativeBuildings,
                            [FieldByName('CoopID').AsString,
                             ConvertSwisSBLToDashDot(FieldByName('CoopSwisSBL').AsString),
                             FieldByName('CoopName').AsString,
                             FormatFloat(IntegerDisplay, FieldByName('AssessedValue').AsInteger),
                             FormatFloat(DecimalDisplay, FieldByName('TotalShares').AsFloat)],
                            False);

          Next;

        end;  {while (not EOF) do}

    end;  {with tbCooperativeBuildings2 do}

end;  {FillInMainListView}

{====================================================================}
Procedure TfmCooperativeBuildings.InitializeForm;

begin
  UnitName := 'mntCooperativeBuildings';
  iReportType := rtSummary;
  sCurrentAssessmentYear := GetTaxRlYr;
  iCurrentProcessingType := GlblProcessingType;

  If ((not ModifyAccessAllowed(FormAccessRights)) or
      _Compare(EditMode, 'V', coEqual))
    then
      begin
        tbCooperativeBuildings.ReadOnly := True;
        tbCooperativeBuildings2.ReadOnly := True;
        btnNew.Enabled := False;
        btnDelete.Enabled := False;

      end;  {If ((not ModifyAccessAllowed(FormAccessRights)) or ...}

  OpenTablesForForm(Self, GlblProcessingType);

  TitleLabel.Left := (Panel1.Width - TitleLabel.Width) DIV 2;
  YearLabel.Caption := GetTaxYrLbl;

  FillInMainListView;

end;  {InitializeForm}

{==============================================================}
Procedure TfmCooperativeBuildings.RecalculateOneYear(sAssessmentYear : String;
                                                     iProcessingType : Integer);

var
  bQuit : Boolean;

begin
  ProgressDialog.Start(1, False, False);
  RecalculateAllExemptions(Self, ProgressDialog,
                           iProcessingType, sAssessmentYear, True, bQuit);
  CreateRollTotals(iProcessingType, sAssessmentYear, ProgressDialog, Self,
                   False, True);

end;  {RecalculateOneYear}

{==============================================================}
Procedure TfmCooperativeBuildings.ShowSubform(iCoopID : LongInt;
                                              sEditMode : String);

var
  fmCooperativeBuildingsEntry: TfmCooperativeBuildingsEntry;
                                     
begin
  fmCooperativeBuildingsEntry := nil;

  try
    fmCooperativeBuildingsEntry := TfmCooperativeBuildingsEntry.Create(nil);

    fmCooperativeBuildingsEntry.InitializeForm(iCoopID, sEditMode);

    If (fmCooperativeBuildingsEntry.ShowModal = idOK)
      then
        begin
          FillInMainListView;

            {CHG05232010-1(2.24.2.7)[I7501]: Allow them to delay recalculating the exemptions and roll totals in case they have
                                             a lot of changes.}

          If not fmCooperativeBuildingsEntry.bTrialRun
            then
              If _Compare(MessageDlg('Do you want to recalculate the exemptions and roll totals?', mtConfirmation, [mbYes, mbNo], 0), idYes, coEqual)
              then
              begin
                If fmCooperativeBuildingsEntry.bRecalculateThisYear
                  then RecalculateOneYear(GlblThisYear, ThisYear);

                If fmCooperativeBuildingsEntry.bRecalculateNextYear
                  then RecalculateOneYear(GlblNextYear, NextYear);

              end  {If not fmCooperativeBuildingsEntry.bTrialRun}
              else MessageDlg('You must recalculate the exemptions in order to adjust for the new coop unit values.', mtWarning, [mbOK], 0);

        end;  {If (fmCooperativeBuildingsEntry.ShowModal = idOK)}

  finally
    fmCooperativeBuildingsEntry.Free;
  end;

end;  {ShowSubform}

{==============================================================}
Procedure TfmCooperativeBuildings.lvCooperativeBuildingsClick(Sender: TObject);

var
  sEditMode : String;
  iCoopID : LongInt;

begin
  try
    iCoopID := StrToInt(GetColumnValueForItem(lvCooperativeBuildings, 0, -1));
  except
    iCoopID := -1;
  end;

  If _Compare(iCoopID, -1, coGreaterThan)
    then
      begin
        If tbCooperativeBuildings.ReadOnly
          then sEditMode := emBrowse
          else sEditMode := emEdit;

        ShowSubform(iCoopID, sEditMode);

      end;  {If _Compare(iCoopID, -1, coGreaterThan)}

end;  {lvCooperativeBuildingsClick}

{==============================================================}
Procedure TfmCooperativeBuildings.lvCooperativeBuildingsKeyPress(    Sender: TObject;
                                                                 var Key: Char);

begin
  If (Key = #13)
    then
      begin
        Key := #0;
        lvCooperativeBuildingsClick(Sender);
      end;

end;  {lvSwisCodesKeyPress}

{==============================================================}
Procedure TfmCooperativeBuildings.btnNewClick(Sender: TObject);

begin
  ShowSubform(-1, emInsert);

end;  {NewButtonClick}

{==============================================================}
Procedure TfmCooperativeBuildings.btnDeleteClick(Sender: TObject);

var
  iCoopID : LongInt;

begin
  try
    iCoopID := StrToInt(GetColumnValueForItem(lvCooperativeBuildings, 0, -1));
  except
    iCoopID := -1;
  end;

  If (_Compare(iCoopID, -1, coGreaterThan) and
      _Locate(tbCooperativeBuildings, [iCoopID], '', []) and
      (MessageDlg('Do you want to delete cooperative building ' +
                  tbCooperativeBuildings.FieldByName('CoopName').AsString + '?',
                  mtConfirmation, [mbYes, mbNo], 0) = idYes))
    then
      begin
        tbCooperativeBuildings.Delete;
        FillInMainListView;

      end;  {If (_Compare(sSwisCode, coNotBlank) and...}

end;  {DeleteButtonClick}

{=================================================================}
Procedure TfmCooperativeBuildings.UpdateCoopsOneYear(sAssessmentYear : String;
                                                     iProcessingType : Integer);

begin
  btnPrintClick(nil);
  RecalculateOneYear(sAssessmentYear, iProcessingType);

end;  {UpdateCoopsOneYear}

{=================================================================}
Procedure TfmCooperativeBuildings.btnUpdateClick(Sender: TObject);

begin
  sCurrentAssessmentYear := GetTaxRlYr;
  iCurrentProcessingType := GlblProcessingType;

  If (MessageDlg('Are you sure want to apportion the ' + sCurrentAssessmentYear + ' coop values?',
                 mtConfirmation, [mbYes, mbNo], 0) = idYes)
    then
      begin
        iReportType := rtDetailed;
        iMode := mdUpdate;
        UpdateCoopsOneYear(sCurrentAssessmentYear, iCurrentProcessingType);

        If (_Compare(iCurrentProcessingType, ThisYear, coEqual) and
            GlblModifyBothYears)
          then
            begin
              sCurrentAssessmentYear := GlblNextYear;
              iCurrentProcessingType := NextYear;
              MessageDlg('The ' + sCurrentAssessmentYear + ' values will now be apportioned.',
                         mtInformation, [mbOK], 0);
              UpdateCoopsOneYear(sCurrentAssessmentYear, iCurrentProcessingType);

            end;  {If (_Compare(GlblProcessingType, ThisYear, coEqual)...}

      end;  {If (MessageDlg(...}

end;  {btnUpdateClick}

{=================================================================}
Procedure TfmCooperativeBuildings.btnPrintClick(Sender: TObject);

var
  sNewFileName, sSpreadsheetFileName : String;
  flTempFile : File;

begin
  If _Compare(iMode, mdNoChange, coEqual)
    then
      If _Compare(MessageDlg('Do you want to print the unit details?', mtConfirmation, [mbYes, mbNo], 0), mrYes, coEqual)
        then iReportType := rtDetailed
        else iReportType := rtSummary;

  If dlgPrint.Execute
    then
      begin
        bExtractToExcel := PromptForExcelExtract;

        If bExtractToExcel
          then
            begin
              sSpreadsheetFileName := GetPrintFileName('CoopApportionment' + '_' +
                                                        sCurrentAssessmentYear + '_', True);
              AssignFile(flExtractFile, sSpreadsheetFileName);
              Rewrite(flExtractFile);

              case iReportType of
                rtSummary : WritelnCommaDelimitedLine(flExtractFile,
                                                       ['Parcel ID',
                                                        'Coop Name',
                                                        'Total AV',
                                                        'Total Shares']);

                rtDetailed : WritelnCommaDelimitedLine(flExtractFile,
                                                       ['Parcel ID',
                                                        'Shares',
                                                        'Share %',
                                                        'Current AV',
                                                        'New AV',
                                                        'Difference']);

              end;  {case iReportType of}

            end;  {If bExtractToExcel}

        bTrialRun := _Compare(iMode, mdNoChange, coEqual);

        If dlgPrint.PrintToFile
          then
            begin
              sNewFileName := GetPrintFileName(Self.Caption, True);
              ReportFiler.FileName := sNewFileName;

              try
                PreviewForm := TPreviewForm.Create(self);
                PreviewForm.FilePrinter.FileName := sNewFileName;
                PreviewForm.FilePreview.FileName := sNewFileName;

                ReportFiler.Execute;
                PreviewForm.ShowModal;
              finally
                PreviewForm.Free;

                  {Now delete the file.}
                try
                  AssignFile(flTempFile, sNewFileName);
                  OldDeleteFile(sNewFileName);
                finally
                  {We don't care if it does not get deleted, so we won't put up an
                   error message.}

                  ChDir(GlblProgramDir);
                end;

              end;  {If PrintRangeDlg.PreviewPrint}

            end  {They did not select preview, so we will go
                  right to the printer.}
          else ReportPrinter.Execute;

        If bExtractToExcel
          then
            begin
              CloseFile(flExtractFile);
              SendTextFileToExcelSpreadsheet(sSpreadsheetFileName, True,
                                             False, '');

            end;  {If PrintToExcel}

      end;  {If dlgPrint.Execute}

end;  {btnPrintCodesClick}

{============================================================}
Procedure PrintSummaryReportHeader(Sender: TObject;
                                   sAssessmentYear : String);

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
      SetFont('Arial',16);
      Home;
      CRLF;
      Bold := True;
      PrintCenter('Cooperative Buildings', (PageWidth / 2));
      SetFont('Times New Roman', 10);
      CRLF;
      CRLF;
      ClearTabs;
      SetTab(0.4, pjLeft, 2.0, 0, BOXLINENone, 0);
      Println(#9 + 'Assessment Year: ' + sAssessmentYear);

      SectionTop := 1.0;

      ClearTabs;
      SetTab(0.4, pjCenter, 2.0, 5, BOXLINENOBOTTOM, 25);   {SBL}
      SetTab(2.4, pjCenter, 2.5, 5, BOXLINENOBOTTOM, 25);   {Name}
      SetTab(4.9, pjCenter, 1.0, 5, BOXLINENOBOTTOM, 25);   {Assessed Value}
      SetTab(5.9, pjCenter, 1.0, 5, BOXLINENOBOTTOM, 25);   {Total shares}

      Println(#9 + 'Coop SBL' +
              #9 + 'Building Name' +
              #9 + 'Assessed Value' +
              #9 + 'Total Shares');

      ClearTabs;
      SetTab(0.4, pjLeft, 2.0, 5, BOXLINEAll, 0);   {SBL}
      SetTab(2.4, pjLeft, 2.5, 5, BOXLINEAll, 0);   {Name}
      SetTab(4.9, pjRight, 1.0, 5, BOXLINEAll, 0);   {Assessed Value}
      SetTab(5.9, pjRight, 1.0, 5, BOXLINEAll, 0);   {Total shares}

    end;  {with Sender as TBaseReport do}

end;  {PrintSummaryReportHeader}

{============================================================}
Procedure TfmCooperativeBuildings.ReportPrint(Sender: TObject);

var
  lstCoopAVChanges : TList;

begin
  with tbCooperativeBuildings2, Sender as TBaseReport do
    begin
      First;

      case iReportType of
        rtSummary :
          begin
            PrintSummaryReportHeader(Sender, GetTaxRlYr);

            while (not EOF) do
              begin
                If _Compare(LinesLeft, 5, coLessThan)
                  then
                    with Sender as TBaseReport do
                      begin
                        NewPage;
                        PrintSummaryReportHeader(Sender, GetTaxRlYr);
                      end;

                Println(#9 + ConvertSBLOnlyToDashDot(Copy(FieldByName('CoopSwisSBL').AsString, 7, 20)) +
                        #9 + FieldByName('CoopName').AsString +
                        #9 + FormatFloat(IntegerDisplay, FieldByName('AssessedValue').AsInteger) +
                        #9 + FormatFloat(DecimalDisplay, FieldByName('TotalShares').AsFloat));

                WritelnCommaDelimitedLine(flExtractFile,
                                          [ConvertSBLOnlyToDashDot(Copy(FieldByName('CoopSwisSBL').AsString, 7, 20)),
                                           FieldByName('CoopName').AsString,
                                           FormatFloat(IntegerDisplay, FieldByName('AssessedValue').AsInteger),
                                           FormatFloat(DecimalDisplay, FieldByName('TotalShares').AsFloat)]);

                Next;

              end;  {while (not EOF) do}

          end;  {rtSummary}

        rtDetailed :
          begin
            lstCoopAVChanges := TList.Create;

            while (not EOF) do
              begin
                ApportionCoopBuilding(FieldByName('CoopID').AsInteger,
                                      bTrialRun, True,
                                      iCurrentProcessingType,
                                      sCurrentAssessmentYear,
                                      lstCoopAVChanges,
                                      True, 0, 0, False);

                PrintApportionmentOneBuilding(Sender, lstCoopAVChanges,
                                              sCurrentAssessmentYear, bExtractToExcel,
                                              flExtractFile);

                Next;

                If not EOF
                  then NewPage;

              end;  {while (not EOF) do}

            FreeTList(lstCoopAVChanges, SizeOf(rCoopAVChange));

          end;  {rtDetailed}

      end;  {case iReportType of}

    end;  {with tbCooperativeBuildings, Sender as TBaseReport do}

end;  {ReportPrint}

{===============================================================================}
Procedure TfmCooperativeBuildings.tnCloseClick(Sender: TObject);

begin
  Close;
end;

{====================================================================}
Procedure TfmCooperativeBuildings.FormClose(    Sender: TObject;
                                                var Action: TCloseAction);

begin
  CloseTablesForForm(Self);
  Action := caFree;
  GlblClosingAForm := True;
  GlblClosingFormCaption := Caption;

end;  {FormClose}


end.
