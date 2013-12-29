unit Rpcompex;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, DBCtrls, DBTables, DB, Buttons, Grids,
  Wwdbigrd, Wwdbgrid, ExtCtrls, Wwtable, Wwdatsrc, Menus, wwdblook,
  TabNotBk, Types, RPFiler, RPDefine, RPBase, RPCanvas, RPrinter, Progress,
  RPTXFilr, ComCtrls;

type
  TCompareExemptionsForm = class(TForm)
    Panel2: TPanel;
    ScrollBox1: TScrollBox;
    PrintDialog: TPrintDialog;
    NotebookChangeTimer: TTimer;
    OpenDialog: TOpenDialog;
    PriorEXTable: TTable;
    SDCodeTable: TTable;
    Label11: TLabel;
    Label12: TLabel;
    CurrentEXTable: TTable;
    EXCodeTable: TTable;
    CurrentAssessmentTable: TTable;
    PriorAssessmentTable: TTable;
    SortTable: TTable;
    PriorParcelTable: TTable;
    CurrentParcelTable: TTable;
    AssessmentYearControlTable: TTable;
    SwisCodeTable: TTable;
    SchoolCodeTable: TTable;
    Panel3: TPanel;
    PrintButton: TBitBtn;
    CloseButton: TBitBtn;
    Panel4: TPanel;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Label10: TLabel;
    Label21: TLabel;
    SwisCodeListBox: TListBox;
    SchoolCodeListBox: TListBox;
    ReportPrinter: TReportPrinter;
    ReportFiler: TReportFiler;
    tbsExemptions: TTabSheet;
    Panel6: TPanel;
    Label3: TLabel;
    Panel7: TPanel;
    ExemptionListBox: TListBox;
    rg_FirstAssessmentYear: TRadioGroup;
    MiscellaneousOptionsGroupBox: TGroupBox;
    CreateParcelListCheckBox: TCheckBox;
    ExtractToExcelCheckBox: TCheckBox;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    cb_FirstYear: TComboBox;
    cb_SecondYear: TComboBox;
    ed_FirstHistoryYear: TEdit;
    rg_SecondAssessmentYear: TRadioGroup;
    Panel1: TPanel;
    TitleLabel: TLabel;
    ed_SecondHistoryYear: TEdit;
    Label4: TLabel;
    cbxOnlyAdditionsAndDeletions: TCheckBox;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure PrintButtonClick(Sender: TObject);
    procedure ReportPrintHeader(Sender: TObject);
    procedure ReportPrint(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure ExemptionListBoxMouseMove(Sender: TObject;
      Shift: TShiftState; X, Y: Integer);
    procedure rg_AssessmentYearClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    UnitName : String;

    PriorAssessmentYear, CurrentAssessmentYear : String;
    ProcessingType : Integer;
    SelectedExemptions : TStringList;
    ReportCancelled : Boolean;

    PriorTotalTownAmount, PriorTotalCountyAmount, PriorTotalSchoolAmount,
    CurrentTotalTownAmount, CurrentTotalCountyAmount, CurrentTotalSchoolAmount : Comp;
    PriorNumParcels,
    CurrentNumParcels : LongInt;

    CreateParcelList : Boolean;
    OrigSortFileName,
    FirstYearDataSource, SecondYearDataSource : String;
    SelectedSchoolCodes, SelectedSwisCodes : TStringList;
    ExtractFile : TextFile;
    ExtractToExcel, bOnlyReportAdditionsAndDeletions : Boolean;

    Procedure InitializeForm;  {Open the tables and setup.}

    Procedure FillSortFile_OneExemption(EXCode : String);

    Procedure FillSortFile;

    Procedure FillListBoxes(AssessmentYear : String);

  end;

implementation

uses GlblVars, WinUtils, Utilitys, UTILEXSD, GlblCnst, PASUtils,
     PRCLLIST,  {Parcel list}
     Prog, RptDialg,
     Preview, PASTypes, DataAccessUnit;

const
    {Assessment Years}
    {Assessment Years}
  ayNextYear = 0;
  ayThisYear = 1;
  ayHistory = 2;

{$R *.DFM}

{========================================================}
Procedure TCompareExemptionsForm.FormActivate(Sender: TObject);

begin
  SetFormStateMaximized(Self);
end;

{========================================================}
Procedure TCompareExemptionsForm.FillListBoxes(AssessmentYear : String);

{Fill in all the list boxes on the various notebook pages.}

var
  ProcessingType : Integer;
  Quit : Boolean;

begin
  ProcessingType := GetProcessingTypeForTaxRollYear(AssessmentYear);
  OrigSortFileName := SortTable.TableName;

  OpenTableForProcessingType(EXCodeTable, ExemptionCodesTableName,
                             ProcessingType, Quit);

  OpenTableForProcessingType(SchoolCodeTable, SchoolCodeTableName,
                             ProcessingType, Quit);

  OpenTableForProcessingType(SwisCodeTable, SwisCodeTableName,
                             ProcessingType, Quit);

  FillOneListBox(ExemptionListBox, EXCodeTable, 'EXCode',
                 'Description', 10, False, False, ProcessingType, AssessmentYear);

    {CHG10262001-1: Add swis and school selection.}

  FillOneListBox(SwisCodeListBox, SwisCodeTable, 'SwisCode',
                 'MunicipalityName', 25, True, True, ProcessingType, AssessmentYear);

  FillOneListBox(SchoolCodeListBox, SchoolCodeTable, 'SchoolCode',
                 'SchoolName', 25, True, True, ProcessingType, AssessmentYear);

end;  {FillListBoxes}

{========================================================}
Procedure TCompareExemptionsForm.InitializeForm;

var
  DatabaseList : TStringList;
  I : Integer;

begin
  UnitName := 'RPCOMPEX';  {mmm}
  FillListBoxes(GlblThisYear);
  AssessmentYearControlTable.Open;

  SelectedSwisCodes := TStringList.Create;
  SelectedSchoolCodes := TStringList.Create;

  DatabaseList := TStringList.Create;
  Session.GetDatabaseNames(DatabaseList);

  For I := 0 to (DatabaseList.Count - 1) do
    If ((Pos('PROPERTYASSESSMENTSYSTEM', ANSIUpperCase(DatabaseList[I])) > 0) or
        (Pos('PAS', ANSIUpperCase(DatabaseList[I])) = 1))
      then
        begin
          cb_FirstYear.Items.Add(DatabaseList[I]);
          cb_SecondYear.Items.Add(DatabaseList[I]);
        end;

  DatabaseList.Free;

end;  {InitializeForm}

{===================================================================}
Procedure TCompareExemptionsForm.FormKeyPress(    Sender: TObject;
                                     var Key: Char);

begin
  If (Key = #13)
    then
      begin
        Key := #0;
        Perform(WM_NEXTDLGCTL, 0, 0);
      end;

end;  {FormKeyPress}

{======================================================================}
Procedure TCompareExemptionsForm.rg_AssessmentYearClick(Sender: TObject);

var
  ed_HistoryYear : TEdit;
  rg_AssessmentYear : TRadioGroup;

begin
  If _Compare(TWinControl(Sender).Name, 'rg_FirstAssessmentYear', coEqual)
    then
      begin
        ed_HistoryYear := ed_FirstHistoryYear;
        rg_AssessmentYear := rg_FirstAssessmentYear;
      end
    else
      begin
        ed_HistoryYear := ed_SecondHistoryYear;
        rg_AssessmentYear := rg_SecondAssessmentYear;
      end;

  ed_HistoryYear.Visible := False;

  case rg_AssessmentYear.ItemIndex of
    ayNextYear : FillListBoxes(GlblNextYear);
    ayThisYear : FillListBoxes(GlblThisYear);
    ayHistory :
      begin
        ed_HistoryYear.Visible := True;
        ed_HistoryYear.SetFocus;
      end;

  end;  {case rg_AssessmentYear.ItemIndex of}

end;  {rg_AssessmentYearClick}

{===================================================================}
Procedure TCompareExemptionsForm.ExemptionListBoxMouseMove(Sender: TObject;
                                                           Shift: TShiftState;
                                                           X, Y: Integer);

{CHG11062001-1: Allow popup hint with code description.}

begin
  DisplayHintForListBox(ExemptionListBox, EXCodeTable, 'EXCode',
                        'Description', X, Y);

end;  {ExemptionListBoxMouseMove}

{===================================================================}
Procedure TCompareExemptionsForm.FillSortFile_OneExemption(EXCode : String);

var
  PriorActive, CurrentActive, FoundPrior,
  PriorParcelExists, CurrentParcelExists,
  AddRecord, FoundCurrent, Done, FirstTimeThrough : Boolean;
  PriorTownAmount, PriorCountyAmount, PriorSchoolAmount,
  CurrentTownAmount, CurrentCountyAmount, CurrentSchoolAmount : Comp;
  SwisCode, SchoolCode, SwisSBLKey, sPreviousSwisSBLKey : String;

begin
  sPreviousSwisSBLKey := '';
  Done := False;
  FirstTimeThrough := True;
  ProgressDialog.UserLabelCaption := 'Filling Sort File - Pass 1';

  PriorTotalCountyAmount := 0;
  PriorTotalTownAmount := 0;
  PriorTotalSchoolAmount := 0;
  CurrentTotalCountyAmount := 0;
  CurrentTotalTownAmount := 0;
  CurrentTotalSchoolAmount := 0;
  PriorNumParcels := 0;
  CurrentNumParcels := 0;

    {FXX06202008-1(2.13.1.16): Add an index by exemption code + SBL so that it properly
                               picks up dulicates.}

  CurrentEXTable.IndexName := 'BYYEAR_SWISSBLKEY_EXCODE';
  PriorEXTable.IndexName := 'BYEXCODE_SBL';
  PriorEXTable.CancelRange;
  CurrentEXTable.CancelRange;

  _SetRange(PriorEXTable, [EXCode, ''], [EXCode, '999'], '', []);
  PriorEXTable.First;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else PriorEXTable.Next;

    If PriorEXTable.EOF
      then Done := True;

      {FXX04112000-1: Problem with multiple history years - only show one previous.}
      {CHG10262001-1: Add swis and school selection.}

    SwisSBLKey := PriorEXTable.FieldByName('SwisSBLKey').Text;
    PriorParcelExists := _Locate(PriorParcelTable, [PriorAssessmentYear, SwisSBLKey], '', [loParseSwisSBLKey]);

    SwisCode := Copy(SwisSBLKey, 1, 6);
    SchoolCode := PriorParcelTable.FieldByName('SchoolCode').Text;

    If ((not Done) and
        PriorParcelExists and
        (PriorEXTable.FieldByName('TaxRollYr').Text = PriorAssessmentYear) and
        (SelectedSwisCodes.IndexOf(SwisCode) > -1) and
        (SelectedSchoolCodes.IndexOf(SchoolCode) > -1))
      then
        begin
          ProgressDialog.Update(Self, ConvertSwisSBLToDashDot(SwisSBLKey));
          Application.ProcessMessages;
          CurrentActive := False;

          CurrentCountyAmount := 0;
          CurrentTownAmount := 0;
          CurrentSchoolAmount := 0;
          _Locate(PriorAssessmentTable, [PriorAssessmentYear, SwisSBLKey], '', []);

          PriorActive := not (PriorParcelTable.FieldByName('ActiveFlag').Text = 'D');

          with PriorEXTable do
            begin
              PriorCountyAmount := FieldByName('CountyAmount').AsFloat;
              PriorTownAmount := FieldByName('TownAmount').AsFloat;
              PriorSchoolAmount := FieldByName('SchoolAmount').AsFloat;

            end;  {with PriorEXTable do}

          CurrentEXTable.CancelRange;
          CurrentEXTable.First;
          FoundCurrent := _Locate(CurrentEXTable, [CurrentAssessmentYear, SwisSBLKey, EXCode], '', []);

            {FXX06192008-1(2.13.1.15): Set range on the exemption table in case there are duplicates.}

          If _Compare(SwisSBLKey, sPreviousSwisSBLKey, coEqual)
            then
              begin
                _SetRange(CurrentEXTable, [CurrentAssessmentYear, SwisSBLKey, EXCode], [], '', [loSameEndingRange]);
                FoundCurrent := _Compare(CurrentEXTable.RecordCount, 1, coGreaterThan);
                CurrentEXTable.Last;
              end;

          If FoundCurrent
            then
              begin
                _Locate(CurrentParcelTable, [CurrentAssessmentYear, SwisSBLKey], '', [loParseSwisSBLKey]);
                _Locate(CurrentAssessmentTable, [CurrentAssessmentYear, SwisSBLKey], '', []);

                CurrentActive := not (CurrentParcelTable.FieldByName('ActiveFlag').Text = 'D');

                with CurrentEXTable do
                  begin
                    CurrentCountyAmount := FieldByName('CountyAmount').AsFloat;
                    CurrentTownAmount := FieldByName('TownAmount').AsFloat;
                    CurrentSchoolAmount := FieldByName('SchoolAmount').AsFloat;

                  end;  {with CurrentEXTable do}

              end;  {If FoundCurrent}

          If not PriorActive
            then
              begin
                PriorCountyAmount := 0;
                PriorTownAmount := 0;
                PriorSchoolAmount := 0;

              end;  {If not PriorActive}

            {Now compare the prior and current for differences.}

          AddRecord := False;

          If ((Roundoff(PriorCountyAmount, 0) <> Roundoff(CurrentCountyAmount, 0)) or
              (Roundoff(PriorTownAmount, 0) <> Roundoff(CurrentTownAmount, 0)) or
              (Roundoff(PriorSchoolAmount, 0) <> Roundoff(CurrentSchoolAmount, 0)) or
              (not FoundCurrent))
            then AddRecord := True;

            {CHG06172008-1(2.13.1.14)[827]: Add option to only show adds & deletes.}

          If (bOnlyReportAdditionsAndDeletions and
              FoundCurrent)
            then AddRecord := False;

          If AddRecord
            then
              with SortTable do
                try
                  Insert;
                  FieldByName('EXCode').Text := EXCode;
                  FieldByName('SwisSBLKey').Text := SwisSBLKey;

                  FieldByName('PriorTownAmount').AsFloat := PriorTownAmount;
                  FieldByName('PriorCountyAmount').AsFloat := PriorCountyAmount;
                  FieldByName('PriorSchoolAmount').AsFloat := PriorSchoolAmount;

                  FieldByName('CurrentTownAmount').AsFloat := CurrentTownAmount;
                  FieldByName('CurrentCountyAmount').AsFloat := CurrentCountyAmount;
                  FieldByName('CurrentSchoolAmount').AsFloat := CurrentSchoolAmount;

                  FieldByName('ParcelExistsPrior').AsBoolean := True;
                  FieldByName('ParcelExistsCurrent').AsBoolean := FoundCurrent;

                  Post;
                except
                  SystemSupport(001, SortTable, 'Error posting record ' + SwisSBLKey + ' in sort table.',
                                UnitName, GlblErrorDlgBox);
                end;

            {Update totals}

          If PriorActive
            then
              begin
                PriorNumParcels := PriorNumParcels + 1;
                PriorTotalCountyAmount := PriorTotalCountyAmount + PriorCountyAmount;
                PriorTotalTownAmount := PriorTotalTownAmount + PriorTownAmount;
                PriorTotalSchoolAmount := PriorTotalSchoolAmount + PriorSchoolAmount;

              end;  {If PriorActive}

            {FXX06182008-2(2.13.1.15): The parcel count was doubling if there were multiple exemptions
                                       on one parcel.}

          If CurrentActive
              (*_Compare(SwisSBLKey, sPreviousSwisSBLKey, coNotEqual)) *)
            then
              begin
                CurrentNumParcels := CurrentNumParcels + 1;
                CurrentTotalCountyAmount := CurrentTotalCountyAmount + CurrentCountyAmount;
                CurrentTotalTownAmount := CurrentTotalTownAmount + CurrentTownAmount;
                CurrentTotalSchoolAmount := CurrentTotalSchoolAmount + CurrentSchoolAmount;

              end;  {If CurrentActive}

        end;  {If not Done}

    ReportCancelled := ProgressDialog.Cancelled;
    sPreviousSwisSBLKey := SwisSBLKey;

  until (Done or ReportCancelled);

    {Now search for parcels in current but not prior.}

  Done := False;
  sPreviousSwisSBLKey := '';
  FirstTimeThrough := True;
  ProgressDialog.UserLabelCaption := 'Filling Sort File - Pass 2';

  CurrentEXTable.IndexName := 'BYEXCODE_SBL';
  PriorEXTable.IndexName := 'BYYEAR_SWISSBLKEY_EXCODE';

  _SetRange(CurrentEXTable, [EXCode, ''], [EXCode, '999'], '', []);
  CurrentEXTable.First;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else CurrentEXTable.Next;

    If CurrentEXTable.EOF
      then Done := True;

      {CHG10262001-1: Add swis and school selection.}

    SwisSBLKey := CurrentEXTable.FieldByName('SwisSBLKey').Text;
    CurrentParcelExists := _Locate(CurrentParcelTable, [CurrentAssessmentYear, SwisSBLKey], '', [loParseSwisSBLKey]);

    SchoolCode := CurrentParcelTable.FieldByName('SchoolCode').Text;
    SwisCode := Copy(SwisSBLKey, 1, 6);

    If ((not Done) and
        CurrentParcelExists and
        (SelectedSwisCodes.IndexOf(SwisCode) > -1) and
        (SelectedSchoolCodes.IndexOf(SchoolCode) > -1))
      then
        begin
          ProgressDialog.Update(Self, ConvertSwisSBLToDashDot(SwisSBLKey));
          Application.ProcessMessages;

          PriorCountyAmount := 0;
          PriorTownAmount := 0;
          PriorSchoolAmount := 0;

            {Make sure the current parcel is active.}

          _Locate(CurrentAssessmentTable, [CurrentAssessmentYear, SwisSBLKey], '', []);
          CurrentActive := not (CurrentParcelTable.FieldByName('ActiveFlag').Text = 'D');

          PriorEXTable.CancelRange;
          FoundPrior := _Locate(PriorEXTable, [PriorAssessmentYear, SwisSBLKey, EXCode], '', []);

            {FXX06192008-1(2.13.1.15): Set range on the exemption table in case there are duplicates.}

          If _Compare(SwisSBLKey, sPreviousSwisSBLKey, coEqual)
            then
              begin
                _SetRange(PriorEXTable, [PriorAssessmentYear, SwisSBLKey, EXCode], [], '', [loSameEndingRange]);
                FoundPrior := _Compare(PriorEXTable.RecordCount, 1, coGreaterThan);
                PriorEXTable.Last;
              end;

          If (CurrentActive and
              (not FoundPrior))
            then
              begin
                with CurrentEXTable do
                  begin
                    CurrentCountyAmount := FieldByName('CountyAmount').AsFloat;
                    CurrentTownAmount := FieldByName('TownAmount').AsFloat;
                    CurrentSchoolAmount := FieldByName('SchoolAmount').AsFloat;

                  end;  {with CurrentEXTable do}

                with SortTable do
                  try
                    Insert;
                    FieldByName('EXCode').Text := EXCode;
                    FieldByName('SwisSBLKey').Text := SwisSBLKey;

                    FieldByName('PriorTownAmount').AsFloat := PriorTownAmount;
                    FieldByName('PriorCountyAmount').AsFloat := PriorCountyAmount;
                    FieldByName('PriorSchoolAmount').AsFloat := PriorSchoolAmount;

                    FieldByName('CurrentTownAmount').AsFloat := CurrentTownAmount;
                    FieldByName('CurrentCountyAmount').AsFloat := CurrentCountyAmount;
                    FieldByName('CurrentSchoolAmount').AsFloat := CurrentSchoolAmount;

                    FieldByName('ParcelExistsPrior').AsBoolean := False;
                    FieldByName('ParcelExistsCurrent').AsBoolean := True;

                    Post;
                  except
                    SystemSupport(001, SortTable, 'Error posting record ' + SwisSBLKey + ' in sort table.',
                                  UnitName, GlblErrorDlgBox);
                  end;

                CurrentNumParcels := CurrentNumParcels + 1;
                CurrentTotalCountyAmount := CurrentTotalCountyAmount + CurrentCountyAmount;
                CurrentTotalTownAmount := CurrentTotalTownAmount + CurrentTownAmount;
                CurrentTotalSchoolAmount := CurrentTotalSchoolAmount + CurrentSchoolAmount;

              end;  {If (CurrentActive and ...}

        end;  {If not Done}

    ReportCancelled := ProgressDialog.Cancelled;
    sPreviousSwisSBLKey := SwisSBLKey;

  until (Done or ReportCancelled);

end;  {FillSortFile_OneExemption}

{===================================================================}
Procedure TCompareExemptionsForm.FillSortFile;

var
  I : Integer;

begin
  I := 0;

  while ((I <= (SelectedExemptions.Count - 1)) and
         (not ReportCancelled)) do
    begin
      FillSortFile_OneExemption(SelectedExemptions[I]);
      I := I + 1;
    end;

end;  {FillSortFile}

{==============================================================}
Procedure TCompareExemptionsForm.PrintButtonClick(Sender: TObject);

var
  I, CurrentProcessingType, PriorProcessingType : Integer;
  NewFileName, SortFileName, SpreadsheetFileName : String;
  Quit : Boolean;

begin
  bOnlyReportAdditionsAndDeletions := cbxOnlyAdditionsAndDeletions.Checked;
  FirstYearDataSource := cb_FirstYear.Text;
  SecondYearDataSource := cb_SecondYear.Text;
  CurrentProcessingType := NextYear;
  PriorProcessingType := ThisYear;

  case rg_FirstAssessmentYear.ItemIndex of
    ayNextYear : PriorProcessingType := NextYear;
    ayThisYear : PriorProcessingType := ThisYear;
    ayHistory : PriorProcessingType := History;

  end;  {case rg_FirstAssessmentYear.ItemIndex of}

  case rg_SecondAssessmentYear.ItemIndex of
    ayNextYear : CurrentProcessingType := NextYear;
    ayThisYear : CurrentProcessingType := ThisYear;
    ayHistory : CurrentProcessingType := History;

  end;  {case rg_SecondAssessmentYear.ItemIndex of}

    {CHG10121998-1: Add user options for default destination and show vet max msg.}

  SetPrintToScreenDefault(PrintDialog);

  If PrintDialog.Execute
    then
      begin
        ExtractToExcel := ExtractToExcelCheckBox.Checked;

        AssignPrinterSettings(PrintDialog, ReportPrinter, ReportFiler, [ptBoth], False, Quit);

           {Range information}

        SelectedExemptions := TStringList.Create;

        For I := 0 to (ExemptionListBox.Items.Count - 1) do
          If ExemptionListBox.Selected[I]
            then SelectedExemptions.Add(Take(5, ExemptionListBox.Items[I]));

        SelectedSchoolCodes.Clear;

        For I := 0 to (SchoolCodeListBox.Items.Count - 1) do
          If SchoolCodeListBox.Selected[I]
            then SelectedSchoolCodes.Add(Take(6, SchoolCodeListBox.Items[I]));

        SelectedSwisCodes.Clear;

        For I := 0 to (SwisCodeListBox.Items.Count - 1) do
          If SwisCodeListBox.Selected[I]
            then SelectedSwisCodes.Add(Take(6, SwisCodeListBox.Items[I]));

        ReportCancelled := False;
        CreateParcelList := CreateParcelListCheckBox.Checked;

        If CreateParcelList
          then ParcelListDialog.ClearParcelGrid(True);

          {Now print the report and do the EX broadcast.}

        GlblPreviewPrint := False;

        CopyAndOpenSortFile(SortTable, 'CompareEX',
                            OrigSortFileName, SortFileName,
                            True, True, Quit);

        If _Compare(FirstYearDataSource, coBlank)
          then FirstYearDataSource := 'PASsystem';
        If _Compare(SecondYearDataSource, coBlank)
          then SecondYearDataSource := 'PASsystem';

        _OpenTable(PriorAssessmentTable, AssessmentTableName, FirstYearDataSource,
                   '', PriorProcessingType, []);
        _OpenTable(PriorParcelTable, ParcelTableName, FirstYearDataSource,
                   '', PriorProcessingType, []);
        _OpenTable(PriorEXTable, ExemptionsTableName, FirstYearDataSource,
                   '', PriorProcessingType, []);

        _OpenTable(CurrentAssessmentTable, AssessmentTableName, SecondYearDataSource,
                   '', CurrentProcessingType, []);
        _OpenTable(CurrentParcelTable, ParcelTableName, SecondYearDataSource,
                   '', CurrentProcessingType, []);
        _OpenTable(CurrentEXTable, ExemptionsTableName, SecondYearDataSource,
                   '', CurrentProcessingType, []);
        _OpenTable(EXCodeTable, ExemptionCodesTableName, SecondYearDataSource,
                   '', CurrentProcessingType, []);

        case rg_FirstAssessmentYear.ItemIndex of
          ayNextYear,
          ayThisYear : PriorAssessmentYear := PriorParcelTable.FieldByName('TaxRollYr').AsString;
          ayHistory : PriorAssessmentYear := ed_FirstHistoryYear.Text;

        end;  {case rg_FirstAssessmentYear.ItemIndex of}

        case rg_SecondAssessmentYear.ItemIndex of
          ayNextYear,
          ayThisYear : CurrentAssessmentYear := CurrentParcelTable.FieldByName('TaxRollYr').AsString;
          ayHistory : CurrentAssessmentYear := ed_SecondHistoryYear.Text;

        end;  {case rg_SecondAssessmentYear.ItemIndex of}

        ProgressDialog.Start(GetRecordCount(PriorEXTable) +
                             GetRecordCount(CurrentEXTable),
                             True, True);

        FillSortFile;

        If ExtractToExcel
          then
            begin
              SpreadsheetFileName := GetPrintFileName('EX', True);
              AssignFile(ExtractFile, SpreadsheetFileName);
              Rewrite(ExtractFile);

              WritelnCommaDelimitedLine(ExtractFile,
                                        ['Parcel ID',
                                         'EX Code',
                                         'Year',
                                         'Prior County',
                                         'Current County',
                                         'County Difference',
                                         'Prior ' + GlblMunicipalityTypeName,
                                         'Current ' + GlblMunicipalityTypeName,
                                         GlblMunicipalityTypeName + ' Difference',
                                         'Prior School',
                                         'Current School',
                                         'School Difference']);

            end;  {If ExtractToExcel}

          {If they want to see it on the screen, start the preview.}

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
              end;

                {Delete the report printer file.}

              try
                Chdir(GlblReportDir);
                OldDeleteFile(NewFileName);
              except
              end;

            end
          else ReportPrinter.Execute;

        ProgressDialog.Finish;

        If ExtractToExcel
          then
            begin
              CloseFile(ExtractFile);
              SendTextFileToExcelSpreadsheet(SpreadsheetFileName, True,
                                             False, '');

            end;  {If PrintToExcel}

        SelectedExemptions.Free;

          {Make sure to close and delete the sort file.}

        SortTable.Close;

          {Now delete the file.}
        try
          ChDir(GlblDataDir);
(*          OldDeleteFile(SortFileName); *)
        finally
          {We don't care if it does not get deleted, so we won't put up an
           error message.}

          ChDir(GlblProgramDir);
        end;

        If CreateParcelList
          then ParcelListDialog.Show;
        ResetPrinter(ReportPrinter);

      end;  {If PrintDialog.Execute}

end;  {StartButtonClick}

{==============================================================}
Procedure TCompareExemptionsForm.ReportPrintHeader(Sender: TObject);

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
      PrintCenter('Exemption Comparison Report', (PageWidth / 2));
      Println('');

      SetFont('Times New Roman', 12);
      ClearTabs;
      SetTab(0.3, pjCenter, 2.0, 5, BoxLineAll, 25);   {Parcel ID}
      SetTab(2.3, pjCenter, 0.5, 5, BoxLineAll, 25);   {EX Code}
      SetTab(2.8, pjCenter, 0.5, 5, BoxLineAll, 25);   {Year}
      SetTab(3.3, pjCenter, 1.4, 5, BoxLineAll, 25);   {County}
      SetTab(4.7, pjCenter, 1.4, 5, BoxLineAll, 25);   {Town}
      SetTab(6.1, pjCenter, 1.4, 5, BoxLineAll, 25);   {School}

      Println('');
      Bold := True;
      Println(#9 + 'Parcel ID' +
              #9 + 'EX' +
              #9 + 'Year' +
              #9 + 'County' +
              #9 + 'Town' +
              #9 + 'School');
      Bold := False;

     end;  {with Sender as TBaseReport do}

end;  {ReportPrintHeader}

{==============================================================}
Procedure SetHeadersForFirstParcelLine(Sender : TObject);

begin
  with Sender as TBaseReport do
    begin
      ClearTabs;
      SetTab(0.3, pjLeft, 2.0, 5, BoxLineAll, 0);   {Parcel ID}
      SetTab(2.3, pjLeft, 0.5, 5, BoxLineAll, 0);   {EX Code}
      SetTab(2.8, pjLeft, 0.5, 5, BoxLineAll, 0);   {Year}
      SetTab(3.3, pjRight, 1.4, 5, BoxLineAll, 0);   {County}
      SetTab(4.7, pjRight, 1.4, 5, BoxLineAll, 0);   {Town}
      SetTab(6.1, pjRight, 1.4, 5, BoxLineAll, 0);   {School}

    end;  {with Sender as TBaseReport do}

end;  {SetHeadersForFirstParcelLine}

{==============================================================}
Procedure SetHeadersForOtherParcelLines(Sender : TObject);

begin
  with Sender as TBaseReport do
    begin
      ClearTabs;
      SetTab(2.8, pjLeft, 0.5, 5, BoxLineAll, 0);   {Year}
      SetTab(3.3, pjRight, 1.4, 5, BoxLineAll, 0);   {County}
      SetTab(4.7, pjRight, 1.4, 5, BoxLineAll, 0);   {Town}
      SetTab(6.1, pjRight, 1.4, 5, BoxLineAll, 0);   {School}

    end;  {with Sender as TBaseReport do}

end;  {SetHeadersForOtherParcelLines}

{==============================================================}
Procedure TCompareExemptionsForm.ReportPrint(Sender: TObject);

var
  _Found, Done, FirstTimeThrough : Boolean;
  SwisSBLKey : String;
  TempStr : String;

begin
  FirstTimeThrough := True;
  Done := False;
  ProgressDialog.Reset;
  ProgressDialog.TotalNumRecords := GetRecordCount(SortTable);
  ProgressDialog.UserLabelCaption := 'Printing Differences';

  SortTable.First;

  with Sender as TBaseReport do
    repeat
      If FirstTimeThrough
        then FirstTimeThrough := False
        else SortTable.Next;

      If SortTable.EOF
        then Done := True;

      If not Done
        then
          begin
            SwisSBLKey := SortTable.FieldByName('SwisSBLKey').Text;

            If CreateParcelList
              then ParcelListDialog.AddOneParcel(SwisSBLKey);

            ProgressDialog.Update(Self, ConvertSwisSBLToDashDot(SwisSBLKey));
            Application.ProcessMessages;

            If (LinesLeft < 8)
              then NewPage;

            with SortTable do
              begin
                SetHeadersForFirstParcelLine(Sender);
                Bold := True;
                Print(#9 + Take(20, ConvertSwisSBLToDashDot(SwisSBLKey)));
                Bold := False;

                Print(#9 + FieldByName('EXCode').Text +
                      #9 + PriorAssessmentYear);

                If FieldByName('ParcelExistsPrior').AsBoolean
                  then Println(#9 + FormatFloat(NoDecimalDisplay_BlankZero, FieldByName('PriorCountyAmount').AsFloat) +
                               #9 + FormatFloat(NoDecimalDisplay_BlankZero, FieldByName('PriorTownAmount').AsFloat) +
                               #9 + FormatFloat(NoDecimalDisplay_BlankZero, FieldByName('PriorSchoolAmount').AsFloat))
                  else Println(#9 + 'Does not exist');

                SetHeadersForOtherParcelLines(Sender);

                  {If this is a remap munic, print old parcel ID under the new.}

                If GlblUseOldParcelIDsForSales
                  then
                    begin
                      If FieldByName('ParcelExistsCurrent').AsBoolean
                        then
                          begin
                            _Found := _Locate(CurrentParcelTable, [CurrentAssessmentYear, SwisSBLKey], '', [loParseSwisSBLKey]);

                            If (_Found and
                                (Length(CurrentParcelTable.FieldByName('RemapOldSBL').Text) = 26))
                              then TempStr := ConvertSwisSBLToOldDashDotNoSwis(
                                                               CurrentParcelTable.FieldByName('RemapOldSBL').Text,
                                                               AssessmentYearControlTable)
                              else TempStr := '';

                          end
                        else TempStr := '';

                    end
                  else TempStr := '';

(*                Print(#9 + TempStr +
                      #9 +
                      #9 + CurrentAssessmentYear); *)

                Print(#9 + CurrentAssessmentYear);

                If FieldByName('ParcelExistsCurrent').AsBoolean
                  then Println(#9 + FormatFloat(NoDecimalDisplay_BlankZero, FieldByName('CurrentCountyAmount').AsFloat) +
                               #9 + FormatFloat(NoDecimalDisplay_BlankZero, FieldByName('CurrentTownAmount').AsFloat) +
                               #9 + FormatFloat(NoDecimalDisplay_BlankZero, FieldByName('CurrentSchoolAmount').AsFloat))
                  else Println(#9 + 'Does not exist');

                  {CHG03102005-1(2.8.3.11): Add a totals line.}

                Bold := True;
                Println(#9 + 'Diff' +
                        #9 + FormatFloat(NoDecimalDisplay_BlankZero,
                                         (FieldByName('PriorCountyAmount').AsFloat -
                                          FieldByName('CurrentCountyAmount').AsFloat)) +
                        #9 + FormatFloat(NoDecimalDisplay_BlankZero,
                                         (FieldByName('PriorTownAmount').AsFloat -
                                          FieldByName('CurrentTownAmount').AsFloat)) +
                        #9 + FormatFloat(NoDecimalDisplay_BlankZero,
                                         (FieldByName('PriorSchoolAmount').AsFloat -
                                          FieldByName('CurrentSchoolAmount').AsFloat)));

                If ExtractToExcel
                  then WritelnCommaDelimitedLine(ExtractFile,
                                                 [ConvertSwisSBLToDashDot(SwisSBLKey),
                                                  FieldByName('EXCode').Text,
                                                  PriorAssessmentYear + '/' + CurrentAssessmentYear,
                                                  FieldByName('PriorCountyAmount').AsInteger,
                                                  FieldByName('CurrentCountyAmount').AsInteger,
                                                  (FieldByName('CurrentCountyAmount').AsInteger -
                                                   FieldByName('PriorCountyAmount').AsInteger),
                                                  FieldByName('PriorTownAmount').AsInteger,
                                                  FieldByName('CurrentTownAmount').AsInteger,
                                                  (FieldByName('CurrentTownAmount').AsInteger -
                                                   FieldByName('PriorTownAmount').AsInteger),
                                                  FieldByName('PriorSchoolAmount').AsInteger,
                                                  FieldByName('CurrentSchoolAmount').AsInteger,
                                                  (FieldByName('CurrentSchoolAmount').AsInteger -
                                                   FieldByName('PriorSchoolAmount').AsInteger)]);

              end;  {with SortTable do}

            Println('');

          end;  {If not Done}

    until Done;

    {Totals}

  with Sender as TBaseReport do
    begin
      SetHeadersForFirstParcelLine(Sender);
      Bold := True;
      Print(#9 + 'Total (' + IntToStr(PriorNumParcels) + ')');
      Bold := False;

      Println(#9 + SortTable.FieldByName('EXCode').Text +
              #9 + PriorAssessmentYear +
              #9 + FormatFloat(NoDecimalDisplay_BlankZero, PriorTotalCountyAmount) +
              #9 + FormatFloat(NoDecimalDisplay_BlankZero, PriorTotalTownAmount) +
              #9 + FormatFloat(NoDecimalDisplay_BlankZero, PriorTotalSchoolAmount));

      Bold := True;
      Print(#9 + 'Total (' + IntToStr(CurrentNumParcels) + ')');
      Bold := False;

      Println(#9 +
              #9 + CurrentAssessmentYear +
              #9 + FormatFloat(NoDecimalDisplay_BlankZero, CurrentTotalCountyAmount) +
              #9 + FormatFloat(NoDecimalDisplay_BlankZero, CurrentTotalTownAmount) +
              #9 + FormatFloat(NoDecimalDisplay_BlankZero, CurrentTotalSchoolAmount));

      SetHeadersForOtherParcelLines(Sender);
      Bold := True;
      Println(#9 + 'Diff' +
              #9 + FormatFloat(NoDecimalDisplay_BlankZero,
                               (PriorTotalCountyAmount - CurrentTotalCountyAmount)) +
              #9 + FormatFloat(NoDecimalDisplay_BlankZero,
                               (PriorTotalTownAmount - CurrentTotalTownAmount)) +
              #9 + FormatFloat(NoDecimalDisplay_BlankZero,
                               (PriorTotalSchoolAmount - CurrentTotalSchoolAmount)));

    end;  {with Sender as TBaseReport do}

end;  {ReportPrint}

{===================================================================}
Procedure TCompareExemptionsForm.FormClose(    Sender: TObject;
                                  var Action: TCloseAction);

begin
  SelectedSchoolCodes.Free;
  SelectedSwisCodes.Free;

  CloseTablesForForm(Self);

    {Free up the child window and set the ClosingAForm Boolean to
     true so that we know to delete the tab.}

  Action := caFree;
  GlblClosingAForm := True;
  GlblClosingFormCaption := Caption;

end;  {FormClose}

end.