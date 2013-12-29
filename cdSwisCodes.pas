unit cdSwisCodes;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  StdCtrls, ExtCtrls, Forms, Dialogs, DB, Grids, DBGrids,
  DBTables, Mask, DBCtrls, Wwtable, Wwdatsrc, Wwdbcomb, Wwdbigrd, Wwdbgrid,
  Btrvdlg, Types, wwdblook, Buttons, ComCtrls, RPFiler, RPDefine, RPBase,
  RPCanvas, RPrinter;

type
  TfmSwisCodes = class(TForm)
    tbSwisCodes: TwwTable;
    Panel1: TPanel;
    TitleLabel: TLabel;
    Panel2: TPanel;
    Panel5: TPanel;
    lvSwisCodes: TListView;
    Panel4: TPanel;
    btnNewCode: TBitBtn;
    btnDeleteCode: TBitBtn;
    tnClose: TBitBtn;
    btnPrintCodes: TBitBtn;
    ReportPrinter: TReportPrinter;
    ReportFiler: TReportFiler;
    dlgPrint: TPrintDialog;
    YearLabel: TLabel;

    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure tnCloseClick(Sender: TObject);
    procedure lvSwisCodesClick(Sender: TObject);
    procedure btnNewCodeClick(Sender: TObject);
    procedure btnDeleteCodeClick(Sender: TObject);
    procedure lvSwisCodesKeyPress(Sender: TObject;
      var Key: Char);
    procedure ReportPrintHeader(Sender: TObject);
    procedure ReportPrint(Sender: TObject);
    procedure btnPrintCodesClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);

  protected
  public
    { public declarations }
    UnitName : String;  {For use with error dialog box.}

      {These will be set in the ParcelTabForm.}

    EditMode : Char;  {A = Add; M = Modify; V = View}

    FormAccessRights : Integer;
    Procedure InitializeForm;
    Procedure FillInMainListView;
    Procedure ShowSubform(sSwisCode : String;
                          sAssessmentYear : String;
                          sEditMode : String);

  end;    {end form object definition}

implementation

uses GlblVars, PASTypes, WinUtils, PASUTILS, UTILEXSD,  Utilitys,
     GlblCnst, DataAccessUnit, cdSwisCodesEntry, Preview, Prog, RTCalcul;


{$R *.DFM}

{====================================================================}
Procedure TfmSwisCodes.FormActivate(Sender: TObject);

begin
  SetFormStateMaximized(Self);
end;

{====================================================================}
Procedure TfmSwisCodes.FillInMainListView;

begin
  FillInListView(lvSwisCodes, tbSwisCodes,
                 ['SwisCode', 'MunicipalityName',
                  'EqualizationRate', 'UniformPercentValue',
                  'ResAssmntRatio', 'VeteransLimitSet',
                  'ColdWarVetMunicLimitSet', 'Classified'],
                 ['', '',
                  DecimalDisplay, DecimalDisplay,
                  DecimalDisplay, '',
                  '', ''],
                 False, False);

end;  {FillInMainListView}

{====================================================================}
Procedure TfmSwisCodes.InitializeForm;

begin
  UnitName := 'cdSwisCodes';

    {FXX04232009-2(2.20.1.1)[D489]: Don't allow edit of Swis codes in history.}

  If (_Compare(GlblTaxYearFlg, 'H', coEqual) or
      (not ModifyAccessAllowed(FormAccessRights)) or
      _Compare(EditMode, 'V', coEqual))
    then
      begin
        tbSwisCodes.ReadOnly := True;
        btnNewCode.Enabled := False;
        btnDeleteCode.Enabled := False;
        EditMode := 'V';

      end;  {If ((not ModifyAccessAllowed(FormAccessRights)) or ...}

  OpenTablesForForm(Self, GlblProcessingType);

    {FXX04232009-1(2.20.1.1)[D490]: Swis code history grid shows all Swis codes.}

  If _Compare(GlblTaxYearFlg, 'H', coEqual)
    then
      with tbSwisCodes do
        begin
          Filtered := False;
          Filter := 'TaxRollYr = ' + FormatFilterString(GlblHistYear);
          Filtered := True;
        end;

  TitleLabel.Left := (Panel1.Width - TitleLabel.Width) DIV 2;

  YearLabel.Caption := GetTaxYrLbl;

  FillInMainListView;

end;  {InitializeForm}

{==============================================================}
Procedure TfmSwisCodes.ShowSubform(sSwisCode : String;
                                   sAssessmentYear : String;
                                   sEditMode : String);

var
  fmSwisCodesEntry: TfmSwisCodesEntry;
  bQuit : Boolean;

begin
  fmSwisCodesEntry := nil;

  try
    fmSwisCodesEntry := TfmSwisCodesEntry.Create(nil);

    fmSwisCodesEntry.InitializeForm(sSwisCode, sAssessmentYear, sEditMode);

    If (fmSwisCodesEntry.ShowModal = idOK)
      then
        begin
          FillInMainListView;

            {FXX06012008-3(2.13.1.5)[]: The progress dialog does not update when created from the subform.}

          If fmSwisCodesEntry.bRecalculate
            then
              begin
                AddToTraceFile('', 'Swis Code',
                               'Recalculate?', 'EX Recalculate', 'Accepted', Time,
                               tbSwisCodes);

                ProgressDialog.Start(1, False, False);
                RecalculateAllExemptions(Self, ProgressDialog,
                                         GlblProcessingType, GetTaxRlYr, True, bQuit);
                CreateRollTotals(GlblProcessingType, GetTaxRlYr, ProgressDialog, Self,
                                 False, True);
              end;

        end;  {If (fmSwisCodesEntry.ShowModal = idOK)}

  finally
    fmSwisCodesEntry.Free;
  end;

end;  {ShowSubform}

{==============================================================}
Procedure TfmSwisCodes.lvSwisCodesClick(Sender: TObject);

var
  sEditMode, sSwisCode : String;

begin
  sSwisCode := GetColumnValueForItem(lvSwisCodes, 0, -1);

  If _Compare(sSwisCode, coNotBlank)
    then
      begin
        If tbSwisCodes.ReadOnly
          then sEditMode := emBrowse
          else sEditMode := emEdit;

        ShowSubform(sSwisCode, GetTaxRlYr, sEditMode);

      end;  {If _Compare(NotificationNumber, 0, coGreaterThan)}

end;  {lvSwisCodesClick}

{==============================================================}
Procedure TfmSwisCodes.lvSwisCodesKeyPress(    Sender: TObject;
                                           var Key: Char);

begin
  If (Key = #13)
    then
      begin
        Key := #0;
        lvSwisCodesClick(Sender);
      end;

end;  {lvSwisCodesKeyPress}

{==============================================================}
Procedure TfmSwisCodes.btnNewCodeClick(Sender: TObject);

begin
  ShowSubform('', GetTaxRlYr, emInsert);

end;  {NewButtonClick}

{==============================================================}
Procedure TfmSwisCodes.btnDeleteCodeClick(Sender: TObject);

var
  sSwisCode : String;

begin
  sSwisCode := GetColumnValueForItem(lvSwisCodes, 0, -1);

  If (_Compare(sSwisCode, coNotBlank) and
      _Locate(tbSwisCodes, [sSwisCode], '', []) and
      (MessageDlg('Do you want to delete swis code ' + sSwisCode + '?',
                  mtConfirmation, [mbYes, mbNo], 0) = idYes))
    then
      begin
        tbSwisCodes.Delete;
        FillInMainListView;

      end;  {If (_Compare(sSwisCode, coNotBlank) and...}

end;  {DeleteButtonClick}

{=================================================================}
Procedure TfmSwisCodes.btnPrintCodesClick(Sender: TObject);

var
  NewFileName : String;
  TempFile : File;

begin
  If dlgPrint.Execute
    then
      begin
        If dlgPrint.PrintToFile
          then
            begin
              NewFileName := GetPrintFileName(Self.Caption, True);
              ReportFiler.FileName := NewFileName;

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
                  AssignFile(TempFile, NewFileName);
                  OldDeleteFile(NewFileName);
                finally
                  {We don't care if it does not get deleted, so we won't put up an
                   error message.}

                  ChDir(GlblProgramDir);
                end;

              end;  {If PrintRangeDlg.PreviewPrint}

            end  {They did not select preview, so we will go
                  right to the printer.}
          else ReportPrinter.Execute;

      end;  {If dlgPrint.Execute}

end;  {btnPrintCodesClick}

{===============================================================================}
Procedure TfmSwisCodes.tnCloseClick(Sender: TObject);

begin
  Close;
end;

{====================================================================}
Procedure TfmSwisCodes.FormClose(    Sender: TObject;
                                                var Action: TCloseAction);

begin
  CloseTablesForForm(Self);
  Action := caFree;
  GlblClosingAForm := True;
  GlblClosingFormCaption := Caption;

end;  {FormClose}

{============================================================}
Procedure TfmSwisCodes.ReportPrintHeader(Sender: TObject);

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
      PrintCenter('Swis Codes', (PageWidth / 2));
      SetFont('Times New Roman', 10);
      CRLF;

      SectionTop := 1.0;

    end;  {with Sender as TBaseReport do}

end;  {ReportPrintHeader}

{=============================================================================}
Procedure PrintOneEntry(Sender : TObject;
                        tbSwisCodes : TTable);

{Print the information for one swis code entry.}

begin
  with Sender as TBaseReport, tbSwisCodes do
    begin
      ClearTabs;
      SetPen(clBlack, psSolid, 1, pmCopy); { Set pen to 1 dot width }
      SetTab(0.3, pjLeft, 2.0, 0, BOXLINENONE, 0);    {1st col}
      SetTab(2.5, pjLeft, 2.0, 0, BOXLINENONE, 0);    {2nd col}

      Println(#9 + ConstStr('-', 180));

      Bold := True;
      Print(#9 + 'Swis Code: ' + FieldByName('SwisCode').AsString);
      Bold := False;
      Println(#9 + 'Short Code: ' +
                   FieldByName('SwisShortCode').AsString);
      Println(#9 + 'Municipality: ' +
                   Trim(FieldByName('MunicipalityName').AsString) +
              #9 + 'Type: ' +
                   Trim(FieldByName('MunicipalTypeDesc').AsString));
      Println(#9 + 'Split Village: ' +
                   Take(4, FieldByName('SplitVillageCode').AsString) +
              #9 + 'Assessing Village: ' +
                   BoolToChar(FieldByName('AssessingVillage').AsBoolean));
      Println(#9 + 'Equalization Rate: ' +
                   FormatFloat(DecimalDisplay, FieldByName('EqualizationRate').AsFloat) +
              #9 + 'Res. Assess. Rate: ' +
                   FormatFloat(DecimalDisplay, FieldByName('ResAssmntRatio').AsFloat));
      Println(#9 + 'Classified: ' +
                   BoolToChar(FieldByName('Classified').AsBoolean));
      Println(#9 + 'Uniform % of Value: ' +
                   FormatFloat(DecimalDisplay, FieldByName('UniformPercentValue').AsFloat));

      Println('');

      ClearTabs;

      SetTab(0.5, pjLeft, 2.0, 0, BOXLINENONE, 0);    {Description}
      SetTab(2.6, pjLeft, 1.0, 0, BOXLINENONE, 0);    {City}
      SetTab(7.0, pjLeft, 1.0, 0, BOXLINENONE, 0);    {Percent}

        {Now print the vet limits.}

      Bold := True;
      Underline := True;
      Println(#9 + #9 + 'Town\City' + #9 + 'Percent');
      Bold := False;
      Underline := False;

      Println(#9 + 'Eligible Funds Max:' +
              #9 + FormatFloat(CurrencyNormalDisplay, FieldByName('EligibleFundsTownMax').AsInteger));
      Println(#9 + 'Veteran Max:' +
              #9 + FormatFloat(CurrencyNormalDisplay, FieldByName('VeteranTownMax').AsInteger) +
              #9 + FieldByName('VeteranCalcPercent').AsString);
      Println(#9 + 'Combat Veteran Max:' +
              #9 + FormatFloat(CurrencyNormalDisplay, FieldByName('CombatVetTownMax').AsInteger) +
              #9 + FieldByName('CombatVetCalcPercent').AsString);
      Println(#9 + 'Disabled Veteran Max:' +
              #9 + FormatFloat(CurrencyNormalDisplay, FieldByName('DisabledVetTownMax').AsInteger));

    end;  {with Sender as TBaseReport do}

end;   {PrintOneEntry}

{============================================================}
Procedure TfmSwisCodes.ReportPrint(Sender: TObject);

var
  iNumPrinted : Integer;

begin
  iNumPrinted := 0;

  with tbSwisCodes do
    begin
      First;

      while (not EOF) do
        begin
          If (_Compare(iNumPrinted, 0, coGreaterThan) and
              _Compare((iNumPrinted MOD 3), 0, coEqual))
            then
              with Sender as TBaseReport do
                NewPage;

          PrintOneEntry(Sender, tbSwisCodes);
          Inc(iNumPrinted);
          Next;

        end;  {If not (Done or Quit)}

    end;  {while (not EOF) do}

end;  {ReportPrint}

end.
