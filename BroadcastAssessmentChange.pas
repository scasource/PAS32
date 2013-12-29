unit BroadcastAssessmentChange;

interface

uses
SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, DBCtrls, DBTables, DB, Buttons, Grids,
  Wwdbigrd, Wwdbgrid, ExtCtrls, Wwtable, Wwdatsrc, Menus, Mask, Types,
  ComCtrls, RPCanvas, RPrinter, RPDefine, RPBase, RPFiler;

type
  TBroadcastAssessmentChangeForm = class(TForm)
    Panel2: TPanel;
    AssessmentTable: TTable;
    ReportFiler: TReportFiler;
    ReportPrinter: TReportPrinter;
    PrintDialog: TPrintDialog;
    ParcelTable: TTable;
    Panel1: TPanel;
    PageControl1: TPageControl;
    tbsOptions: TTabSheet;
    AssessmentYearRadioGroup: TRadioGroup;
    OptionsGroupBox: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    TrialRunCheckBox: TCheckBox;
    EditChangePercent: TEdit;
    ChangeIsEqualizationCheckBox: TCheckBox;
    ExtractToExcelCheckBox: TCheckBox;
    StartButton: TBitBtn;
    CloseButton: TBitBtn;
    Label3: TLabel;
    tbsPropertyClass: TTabSheet;
    Panel8: TPanel;
    Label22: TLabel;
    lbxPropertyClasses: TListBox;
    tbPropertyClasses: TTable;
    tbNeighborhoods: TTable;
    tbResidentialSites: TTable;
    tbCommercialSites: TTable;
    lbxNeighborhoods: TListBox;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure StartButtonClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure ReportPrintHeader(Sender: TObject);
    procedure ReportPrint(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    UnitName : String;
    ReportCancelled, TrialRun,
    ExtractToExcel, ChangeIsEqualization : Boolean;
    AssessmentYearsChosen : Integer;
    ChangePercent : Double;
    slSelectedPropertyClasses, slSelectedNeighborhoods : TStringList;

    Procedure InitializeForm;  {Open the tables and setup.}

    Function ParcelMeetsCriteria(sAssessmentYear : String;
                                 sSwisSBLKey : String;
                                 sPropertyClassCode : String;
                                 sNeighborhoodCode : String) : Boolean;

    Procedure UpdateAssessment(AssessmentTable : TTable;
                               NewAssessment : LongInt;
                               Difference : LongInt);

    Procedure BroadcastAssessmentChange_OneYear(Sender : TObject;
                                                ProcessingType : Integer);

  end;

implementation

uses GlblVars, WinUtils, Utilitys, GlblCnst, PASUtils, UtilEXSD,
     PASTypes, Prog, Preview, RTCalcul, DataAccessUnit;

{$R *.DFM}

const
    {Assessment Years}
  ayThisYear = 0;
  ayNextYear = 1;
  ayBothYears = 2;

{========================================================}
procedure TBroadcastAssessmentChangeForm.FormActivate(Sender: TObject);

begin
  SetFormStateMaximized(Self);
end;

{========================================================}
Procedure TBroadcastAssessmentChangeForm.InitializeForm;

begin
  UnitName := 'BroadcastAssessmentChange';
  FillOneListBox(lbxPropertyClasses, tbPropertyClasses, 'MainCode',
                 'Description', 15, True, True, GlblProcessingType,
                 GlblThisYear);

  slSelectedPropertyClasses := TStringList.Create;
  slSelectedNeighborhoods := TStringList.Create;

end;  {InitializeForm}

{==============================================================}
Procedure TBroadcastAssessmentChangeForm.StartButtonClick(Sender: TObject);

var
  NewFileName : String;

begin
  TrialRun := TrialRunCheckBox.Checked;
  AssessmentYearsChosen := AssessmentYearRadioGroup.ItemIndex;
  ChangeIsEqualization := ChangeIsEqualizationCheckBox.Checked;
  ExtractToExcel := ExtractToExcelCheckBox.Checked;

  try
    ChangePercent := StrToFloat(EditChangePercent.Text) / 100;
  except
    ChangePercent := 1;  {Do nothing}
  end;

  FillSelectedItemList(lbxPropertyClasses, slSelectedPropertyClasses, 3);
  FillSelectedItemList(lbxNeighborhoods, slSelectedNeighborhoods, 5);

  ReportCancelled := False;
  GlblPreviewPrint := False;

  If PrintDialog.Execute
    then
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
            end

          end
        else ReportPrinter.Execute;

end;  {StartButtonClick}

{===================================================================}
Function TBroadcastAssessmentChangeForm.ParcelMeetsCriteria(sAssessmentYear : String;
                                                            sSwisSBLKey : String;
                                                            sPropertyClassCode : String;
                                                            sNeighborhoodCode : String) : Boolean;

begin
  Result := True;

  If (_Compare(slSelectedPropertyClasses.Count, lbxPropertyClasses.Items.Count, coNotEqual) and
      _Compare(slSelectedPropertyClasses.IndexOf(sPropertyClassCode), -1, coEqual))
    then Result := False;

  If (Result and
      _Compare(slSelectedNeighborhoods.Count, lbxNeighborhoods.Items.Count, coNotEqual) and
      _Compare(slSelectedNeighborhoods.IndexOf(sNeighborhoodCode), -1, coEqual))
    then Result := False;

end;  {ParcelMeetsCriteria}

{===================================================================}
Procedure PrintSubheader(Sender : TObject;
                         ProcessingType : Integer);

begin
  with Sender as TBaseReport do
    begin
      Println('');

      ClearTabs;
      SetTab(0.3, pjCenter, 1.2, 0, BOXLINEBottom, 0);  {Parcel ID}
      SetTab(1.6, pjCenter, 1.5, 0, BOXLINEBottom, 0);  {Legal address}
      SetTab(3.2, pjCenter, 1.5, 0, BOXLINEBottom, 0);  {Owner}
      SetTab(4.8, pjCenter, 1.1, 0, BOXLINEBottom, 0);  {Old AV}
      SetTab(6.0, pjCenter, 1.1, 0, BOXLINEBottom, 0);  {New AV}
      SetTab(7.2, pjCenter, 1.1, 0, BOXLINEBottom, 0);  {Difference}

      Bold := True;
      Println(#9 + 'Parcel ID' +
              #9 + 'Legal Address' +
              #9 + 'Owner' +
              #9 + 'Old AV' +
              #9 + 'New AV' +
              #9 + 'Difference');
      Bold := False;

      ClearTabs;
      SetTab(0.3, pjLeft, 1.2, 0, BOXLINENone, 0);  {Parcel ID}
      SetTab(1.6, pjLeft, 1.5, 0, BOXLINENone, 0);  {Legal address}
      SetTab(3.2, pjLeft, 1.5, 0, BOXLINENone, 0);  {Owner}
      SetTab(4.8, pjRight, 1.1, 0, BOXLINENone, 0);  {Old AV}
      SetTab(6.0, pjRight, 1.1, 0, BOXLINENone, 0);  {New AV}
      SetTab(7.2, pjRight, 1.1, 0, BOXLINENone, 0);  {Difference}

    end;  {with Sender as TBaseReport do}

end;  {PrintSubheader}

{===================================================================}
Procedure TBroadcastAssessmentChangeForm.UpdateAssessment(AssessmentTable : TTable;
                                                          NewAssessment : LongInt;
                                                          Difference : LongInt);

var
  ARChangeFieldName : String;

begin
  with AssessmentTable do
    try
      Edit;
      FieldByName('TotalAssessedVal').AsInteger := NewAssessment;

      If _Compare(Difference, 0, coGreaterThan)
        then
          begin
            If ChangeIsEqualization
              then ARChangeFieldName := 'IncreaseForEqual'
              else ARChangeFieldName := 'PhysicalQtyIncrease';

          end
        else
          begin
            If ChangeIsEqualization
              then ARChangeFieldName := 'DecreaseForEqual'
              else ARChangeFieldName := 'PhysicalQtyDecrease';

          end;

      FieldByName(ARChangeFieldName).AsInteger := Difference;
      FieldByName('AssessmentDate').AsDateTime := Date;
      Post;
    except
      SystemSupport(001, AssessmentTable,
                    'Error posting assessment change for ' + ConvertSwisSBLToDashDot(FieldByName('SwisSBLKey').Text),
                    UnitName, GlblErrorDlgBox);
    end;

end;  {UpdateAssessment}

{===================================================================}
Procedure TBroadcastAssessmentChangeForm.BroadcastAssessmentChange_OneYear(Sender : TObject;
                                                                           ProcessingType : Integer);

var
  OldAssessment, NewAssessment, Difference : LongInt;
  TotalOldAssessment, TotalNewAssessment,
  TotalParcels, TotalDifference : Int64;
  Quit, Done, FirstTimeThrough : Boolean;
  sAssessmentYear, sPropertyClassCode,
  sSwisSBLKey, sNeighborhoodCode : String;

begin
  TotalOldAssessment := 0;
  TotalNewAssessment := 0;
  TotalDifference := 0;
  TotalParcels := 0;

  FirstTimeThrough := True;
  sAssessmentYear := GetTaxRollYearForProcessingType(ProcessingType);
  OpenTableForProcessingType(ParcelTable, ParcelTableName, ProcessingType, Quit);
  OpenTableForProcessingType(AssessmentTable, AssessmentTableName, ProcessingType, Quit);

  ProgressDialog.Start(GetRecordCount(ParcelTable), True, True);

  with ParcelTable do
    begin
      First;

      repeat
        If FirstTimeThrough
          then FirstTimeThrough := False
          else Next;

        Done := EOF;
        sSwisSBLKey := ExtractSSKey(ParcelTable);
        ProgressDialog.Update(Self, ConvertSwisSBLToDashDot(sSwisSBLKey));
        Application.ProcessMessages;
        sPropertyClassCode := ParcelTable.FieldByName('PropertyClassCode').AsString;

        sNeighborhoodCode := '';

        If _Locate(tbResidentialSites, [sAssessmentYear, sSwisSBLKey], '', [])
          then sNeighborhoodCode := tbResidentialSites.FieldByName('NeighborhoodCode').AsString;

        If _Locate(tbCommercialSites, [sAssessmentYear, sSwisSBLKey], '', [])
          then sNeighborhoodCode := tbCommercialSites.FieldByName('NeighborhoodCode').AsString;

        If not Done
          then
            with Sender as TBaseReport do
              begin
                If (LinesLeft < 5)
                  then
                    begin
                      NewPage;
                      PrintSubheader(Sender, NextYear);

                    end;

                If (ParcelMeetsCriteria(sAssessmentYear, sSwisSBLKey,
                                        sPropertyClassCode, sNeighborhoodCode) and
                    _Locate(AssessmentTable, [sAssessmentYear, ExtractSSKey(ParcelTable)], '', []))
                  then
                    begin
                      Inc(TotalParcels);

                      OldAssessment := AssessmentTable.FieldByName('TotalAssessedVal').AsInteger;
                      NewAssessment := Round(OldAssessment * (1 + ChangePercent));
                      Difference := NewAssessment - OldAssessment;

                      Inc(TotalOldAssessment, OldAssessment);
                      Inc(TotalNewAssessment, NewAssessment);
                      Inc(TotalDifference, Difference);

                      Println(#9 + ConvertSwisSBLToDashDot(ExtractSSKey(ParcelTable)) +
                              #9 + Copy(GetLegalAddressFromTable(ParcelTable), 1, 15) +
                              #9 + Copy(FieldByName('Name1').Text, 1, 15) +
                              #9 + FormatFloat(CurrencyDisplayNoDollarSign, OldAssessment)  +
                              #9 + FormatFloat(CurrencyDisplayNoDollarSign, NewAssessment) +
                              #9 + FormatFloat(CurrencyDisplayNoDollarSign, Difference));

                      If not TrialRun
                        then UpdateAssessment(AssessmentTable, NewAssessment, Difference);

                    end;  {If _Locate(AssessmentTable, [AssessmentYear, ExtractSSKey], '', [])}

              end;  {with Sender as TBaseReport do}

        ReportCancelled := ProgressDialog.Cancelled;

      until (Done or ReportCancelled);

      with Sender as TBaseReport do
        begin
          Bold := True;
          Println('');
          Println(#9 + #9 + #9 +
                  #9 + FormatFloat(CurrencyDisplayNoDollarSign, TotalOldAssessment)  +
                  #9 + FormatFloat(CurrencyDisplayNoDollarSign, TotalNewAssessment) +
                  #9 + FormatFloat(CurrencyDisplayNoDollarSign, TotalDifference));
          Bold := False;

        end;  {with Sender as TBaseReport do}

    end;  {BroadcastAssessmentChange_OneYear}

  If not (TrialRun or ReportCancelled)
    then
      begin
        ProgressDialog.UserLabelCaption := 'Recalculating Exemptions.';
        RecalculateAllExemptions(Self, ProgressDialog,
                                 ProcessingType, sAssessmentYear, False, Quit);

        ProgressDialog.Reset;

        CreateRollTotals(ProcessingType, sAssessmentYear,
                         ProgressDialog, Self, False, False);

      end;  {If not (TrialRun or ReportCancelled)}

  CloseTablesForForm(Self);
  ProgressDialog.Finish;

end;  {BroadcastAssessmentChange_OneYear}

{===================================================================}
Procedure TBroadcastAssessmentChangeForm.ReportPrintHeader(Sender: TObject);

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
      SetFont('Times New Roman',10);
      Bold := True;
      Home;
      PrintCenter('Assessment Change Broadcast', (PageWidth / 2));
      Bold := False;
      CRLF;
      CRLF;

      ClearTabs;
      SetTab(0.3, pjLeft, 7.5, 0, BOXLINENONE, 0);   {hdr}

      SetFont('Times New Roman',10);
      Println(#9 + 'Change Percent: ' + FormatFloat(DecimalDisplay, (ChangePercent * 100)));

      Print(#9 + 'Assessment Year: ');

      case AssessmentYearsChosen of
        ayThisYear : Println(GlblThisYear);
        ayNextYear : Println(GlblNextYear);
        ayBothYears : Println(GlblThisYear + '\' + GlblNextYear);
      end;

      If TrialRun
        then
          begin
            Bold := True;
            Println(#9 + 'Trial Run - no updates done.');
            Bold := False;

          end;  {If TrialRun}

    end;  {with Sender as TBaseReport do}

end;  {ReportPrintHeader}

{===================================================================}
Procedure TBroadcastAssessmentChangeForm.ReportPrint(Sender: TObject);

begin
  If _Compare(AssessmentYearsChosen, [ayThisYear, ayBothYears], coEqual)
    then
      begin
        with Sender as TBaseReport do
          PrintSubheader(Sender, ThisYear);

        BroadcastAssessmentChange_OneYear(Sender, ThisYear);

      end;  {If _Compare(AssessmentYearsChosen, [ayThisYear ...}

  If ((not ReportCancelled) and
      _Compare(AssessmentYearsChosen, [ayNextYear, ayBothYears], coEqual))
    then
      begin
        with Sender as TBaseReport do
          begin
            NewPage;
            PrintSubheader(Sender, NextYear);

          end;  {with Sender as TBaseReport do}

        BroadcastAssessmentChange_OneYear(Sender, NextYear);

      end;  {If _Compare(AssessmentYearsChosen, ...}

end;  {ReportPrint}

{===================================================================}
Procedure TBroadcastAssessmentChangeForm.FormClose(    Sender: TObject;
                                                   var Action: TCloseAction);

begin
  slSelectedPropertyClasses.Free;
  slSelectedNeighborhoods.Free;
  CloseTablesForForm(Self);

    {Free up the child window and set the ClosingAForm Boolean to
     true so that we know to delete the tab.}

  Action := caFree;
  GlblClosingAForm := True;
  GlblClosingFormCaption := Caption;

end;  {FormClose}

end.