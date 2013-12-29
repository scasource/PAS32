unit RGrievanceSummaryReport;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, DBCtrls,  DB, Buttons, Grids,
  Wwdbigrd, Wwdbgrid, ExtCtrls, Wwdatsrc, Menus,
  DBTables, Wwtable, Btrvdlg, RPFiler, RPBase, RPCanvas, RPrinter, Mask,
  Gauges, RPMemo, RPDBUtil, RPDefine, (*Progress,*) Types, RPTXFilr, PASTypes,
  Progress, TabNotBk, ComCtrls, wwriched, CheckLst;

type
  TGrievanceSummaryReportForm = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    ScrollBox: TScrollBox;
    TitleLabel: TLabel;
    ReportPrinter: TReportPrinter;
    ReportFiler: TReportFiler;
    PrintDialog: TPrintDialog;
    GrievanceTable: TwwTable;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    ParcelTable: TTable;
    GrievanceResultsTable: TTable;
    GrievanceExemptionsAskedTable: TwwTable;
    GrievanceDispositionCodeTable: TTable;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    GrievanceTypeRadioGroup: TRadioGroup;
    PrintOrderRadioGroupBox: TRadioGroup;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    CreateParcelListCheckBox: TCheckBox;
    IncludeResultsCheckBox: TCheckBox;
    GrievanceYearEdit: TEdit;
    AppearanceNumberCheckBox: TCheckBox;
    DenialCodeListBox: TListBox;
    Label2: TLabel;
    DenialReasonCodesTable: TTable;
    TabSheet3: TTabSheet;
    Label3: TLabel;
    RepresentativeCodeListBox: TListBox;
    RepresentativeCodesTable: TTable;
    DenialReasonCodesDataSource: TwwDataSource;
    DenialReasonCodesTableMainCode: TStringField;
    DenialReasonCodesTableReason: TMemoField;
    RichTextMemo: TDBRichEdit;
    Label4: TLabel;
    PrintLawyerNameCheckBox: TCheckBox;
    PrintGrievanceNotesCheckBox: TCheckBox;
    AssessmentTable: TTable;
    PrintToExcelCheckBox: TCheckBox;
    GrievanceDataSource: TwwDataSource;
    GridLineFormatCheckBox: TCheckBox;
    SortGrievanceTable: TTable;
    Label5: TLabel;
    MoreOptionsTabSheet: TTabSheet;
    ComplaintReasonListBox: TListBox;
    Label6: TLabel;
    GrievanceChangeRequestedTypeRadioGroup: TRadioGroup;
    ComplaintReasonTable: TTable;
    MinutesHeaderMemo: TMemo;
    MinutesHeaderLabel: TLabel;
    PrintExtendedFormatCheckBox: TCheckBox;
    PlainTextMemo: TMemo;
    GrievanceResultsDataSource: TDataSource;
    Panel3: TPanel;
    NotesEdit: TEdit;
    LoadButton: TBitBtn;
    SaveButton: TBitBtn;
    PrintButton: TBitBtn;
    CloseButton: TBitBtn;
    tbsGrievanceResultTypes: TTabSheet;
    Label7: TLabel;
    GrievanceResultsTypeCheckListBox: TCheckListBox;
    tbCertiorari: TTable;
    tbAssessmentYearControl: TTable;
    tbParcels: TTable;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure PrintButtonClick(Sender: TObject);
    procedure CloseButtonClick(Sender: TObject);
    procedure ReportPrint(Sender: TObject);
    procedure LoadButtonClick(Sender: TObject);
    procedure SaveButtonClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure ReportPrintHeader(Sender: TObject);
    procedure PrintExtendedFormatCheckBoxClick(Sender: TObject);
  private
    { Private declarations }
  public
    ReportCancelled : Boolean;

    { Public declarations }
    UnitName : String;

    IncludeResults,
    CreateParcelList,
    PrintAppearanceNumberColumn,
    PrintLawyerName : Boolean;
    SelectedDenialCodes,
    SelectedGrievanceResultsTypeList,
    SelectedRepresentativeCodes,
    SelectedComplaintReasons : TStringList;

    GrievanceYear, sParcelLocateYear : String;
    PrintOrder, GrievanceProcessingType,
    GrievanceStatusType, ChangeRequestedType : Integer;
    PrintGrievanceNotes, PrintToExcel, GridLineFormat,
    PrintExtendedFormat, OrigGlblDisplaySwisOnPrintKey : Boolean;
    ExtractFile : TextFile;

    OrigSortFileName, SpreadsheetFileName : String;

    Procedure InitializeForm;  {Open the ScreenLabelTables and setup.}

    Function MeetsCriteria(    SwisSBLKey : String;
                               GrievanceYear : String;
                           var StatusThisGrievance : Integer) : Boolean;

    Procedure FillSortFile_ExemptionsAsked;
    Procedure FillSortFile(var Quit : Boolean);
    Procedure PrintOneGrievance(Sender : TObject);

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
     DataAccessUnit,
     Preview;

{$R *.DFM}

const
  poGrievanceNumber = 0;
  poParcelID = 1;
  poOwnerName = 2;
  poLegalAddress = 3;
  poRepresentative = 4;
  poPropertyClass = 5;
  poRepresentative_SBL = 6;

  gstOpen = 0;
  gstClosed = 1;
  gstApproved = 2;
  gstDenied = 3;
  gstDismissed = 4;
  gstWithdrawn = 5;
  gstAll = 6;

  crtAssessmentReduction = 0;
  crtExemptionChange_Addition = 1;
  crtEither = 2;

{==============================================================}
Procedure FillOneListBox_WithDescription(ListBox : TListBox;
                                         Table : TTable;
                                         CodeField : String;
                                         DescriptionRichEdit : TDBRichEdit;
                                         DescriptionLen : Integer;
                                         SelectAll,
                                         IncludeDescription : Boolean;
                                         ProcessingType : Integer;
                                         AssessmentYear : String);

var
  FirstTimeThrough, Done : Boolean;
  TempStr : String;

begin
  FirstTimeThrough := True;
  Done := False;

  ListBox.Items.Clear;

  Table.First;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else Table.Next;

    If Table.EOF
      then Done := True;

    If not Done
      then
        begin
          TempStr := Table.FieldByName(CodeField).Text;

          If IncludeDescription
            then TempStr := TempStr + ' - ' +
                            Take(DescriptionLen, DescriptionRichEdit.Text);

          ListBox.Items.Add(TempStr);

        end;  {If not Done}

  until Done;

  If SelectAll
    then SelectItemsInListBox(ListBox);

  ListBox.TopIndex := 1;

end;  {FillOneListBox_WithDescription}

{========================================================}
Procedure TGrievanceSummaryReportForm.FormActivate(Sender: TObject);

begin
  SetFormStateMaximized(Self);
end;

{========================================================}
Procedure TGrievanceSummaryReportForm.InitializeForm;

begin
  UnitName := 'RGrievanceSummaryReport';  {mmm}

  If GlblIsWestchesterCounty
    then
      begin
        GrievanceYear := GlblNextYear;
        GrievanceProcessingType := NextYear;
      end
    else
      begin
        GrievanceYear := GlblThisYear;
        GrievanceProcessingType := ThisYear;
      end;

  sParcelLocateYear := GrievanceYear;

  OrigSortFileName := 'sortgrievancesummarytable';

  OpenTablesForForm(Self, GrievanceProcessingType);

    {CHG06102009-5(2.20.1.1)[F980]: Add a grievance results type option.}

  SelectedGrievanceResultsTypeList := TStringList.Create;

  FillOneListBox(GrievanceResultsTypeCheckListBox,
                 GrievanceDispositionCodeTable,
                 'Code', 'Description', 0,
                 True, False, GlblProcessingType,
                 GrievanceYearEdit.Text);

  GrievanceYearEdit.Text := GrievanceYear;

  FillOneListBox_WithDescription(DenialCodeListBox, DenialReasonCodesTable,
                                 'MainCode',
                                 RichTextMemo,
                                 35, True, True,
                                 GrievanceProcessingType, GrievanceYear);

  FillOneListBox(RepresentativeCodeListBox, RepresentativeCodesTable,
                 'Code', 'Name1', 20, True, True,
                 GrievanceProcessingType, GrievanceYear);

  FillOneListBox(ComplaintReasonListBox, ComplaintReasonTable,
                 'MainCode', '', 20, True, False,
                 GrievanceProcessingType, GrievanceYear);

  try
    MinutesHeaderMemo.Lines.LoadFromFile(GlblProgramDir + 'MinutesHeader.txt');
  except
  end;

end;  {InitializeForm}

{===================================================================}
Procedure TGrievanceSummaryReportForm.FormKeyPress(    Sender: TObject;
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
Procedure TGrievanceSummaryReportForm.SaveButtonClick(Sender: TObject);

{FXX04091999-8: Add ability to save and load search report options.}

begin
  SaveReportOptions(Self, OpenDialog, SaveDialog, 'Grievance Summary.grs', 'Grievance Summary Report');

end;  {SaveButtonClick}

{====================================================================}
Procedure TGrievanceSummaryReportForm.LoadButtonClick(Sender: TObject);

{FXX04091999-8: Add ability to save and load search report options.}

begin
  LoadReportOptions(Self, OpenDialog, 'Grievance Summary.grs', 'Grievance Summary Report');

end;  {LoadButtonClick}

{====================================================================}
Procedure TGrievanceSummaryReportForm.PrintExtendedFormatCheckBoxClick(Sender: TObject);

var
  Visible : Boolean;

begin
  Visible := PrintExtendedFormatCheckBox.Checked;

  MinutesHeaderMemo.Visible := Visible;
  MinutesHeaderLabel.Visible := Visible;

end;  {PrintExtendedFormatCheckBoxClick}

{====================================================================}
Procedure TGrievanceSummaryReportForm.FillSortFile_ExemptionsAsked;

var
  Done, FirstTimeThrough : Boolean;
  ExemptionsExtracted : Integer;
  TempFieldName : String;

begin
  Done := False;
  FirstTimeThrough := True;
  ExemptionsExtracted := 0;
  GrievanceExemptionsAskedTable.First;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else GrievanceExemptionsAskedTable.Next;

    if GrievanceExemptionsAskedTable.EOF
      then Done := True;

    If not Done
      then
        with GrievanceExemptionsAskedTable do
          try
            ExemptionsExtracted := ExemptionsExtracted + 1;

            TempFieldName := 'PetitEXCode' + IntToStr(ExemptionsExtracted);
            SortGrievanceTable.FieldByName(TempFieldName).Text := FieldByName('ExemptionCode').Text;

            TempFieldName := 'PetitEXAmount' + IntToStr(ExemptionsExtracted);
            SortGrievanceTable.FieldByName(TempFieldName).AsInteger := FieldByName('Amount').AsInteger;

            TempFieldName := 'PetitEXPercent' + IntToStr(ExemptionsExtracted);
            SortGrievanceTable.FieldByName(TempFieldName).AsFloat := FieldByName('Percent').AsFloat;

          except
          end;  {with GrievanceExemptionsAskedTable do}

  until (Done or (ExemptionsExtracted = 3));

end;  {FillSortFile_ExemptionsAsked}

{====================================================================}
Procedure TGrievanceSummaryReportForm.FillSortFile(var Quit : Boolean);

var
  _Found, FrozenStatus,
  Done, FirstTimeThrough, Cancelled : Boolean;
  NumFound, GrievanceNumber : LongInt;
  Representative, Decision, SwisSBLKey, TempStr : String;
  StatusThisGrievance : Integer;

begin
  NumFound := 0;
  Done := False;
  FirstTimeThrough := True;
  GrievanceTable.First;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else GrievanceTable.Next;

    If GrievanceTable.EOF
      then Done := True;

    SwisSBLKey := GrievanceTable.FieldByName('SwisSBLKey').Text;
    ProgressDialog.Update(Self, ConvertSwisSBLToDashDot(SwisSBLKey));
    ProgressDialog.UserLabelCaption := 'Num Found = ' + IntToStr(NumFound);
    Application.ProcessMessages;

    GrievanceNumber := GrievanceTable.FieldByName('GrievanceNumber').AsInteger;
    SetRangeOld(GrievanceResultsTable,
                ['TaxRollYr', 'SwisSBLKey', 'GrievanceNumber', 'ResultNumber'],
                [GrievanceYear, SwisSBLKey, IntToStr(GrievanceNumber), '0'],
                [GrievanceYear, SwisSBLKey, IntToStr(GrievanceNumber), '9999']);

      {CHG06062004-1(2.07l5): Allow for extract \ search on petitioner reason,
                              exemptions asked.}

    SetRangeOld(GrievanceExemptionsAskedTable,
                ['TaxRollYr', 'SwisSBLKey', 'GrievanceNumber', 'ExemptionCode'],
                [GrievanceYear, SwisSBLKey, IntToStr(GrievanceNumber), ''],
                [GrievanceYear, SwisSBLKey, IntToStr(GrievanceNumber), 'zzzzz']);

    If ((not Done) and
        MeetsCriteria(SwisSBLKey, GrievanceYear, StatusThisGrievance))
      then
        begin
          GrievanceResultsTable.First;
          NumFound := NumFound + 1;
          _Found := FindKeyOld(AssessmentTable, ['TaxRollYr', 'SwisSBLKey'],
                               [GrievanceYear, SwisSBLKey]);

          FrozenStatus := (_Found and
                          (Deblank(AssessmentTable.FieldByName('DateFrozen').Text) <> ''));

          TempStr := ExtractPlainTextFromRichText(GrievanceTable.FieldByName('Notes').AsString, False);

          with SortGrievanceTable do
            try
              Insert;

              Representative := GrievanceTable.FieldByName('LawyerCode').Text;

              If (GridLineFormat and
                  (Deblank(Representative) = ''))
                then Representative := 'PRO SE';

              FieldByName('GrievanceNumber').AsInteger := GrievanceTable.FieldByName('GrievanceNumber').AsInteger;
              FieldByName('TaxRollYr').Text := GrievanceTable.FieldByName('TaxRollYr').Text;
              FieldByName('SwisSBLKey').Text := GrievanceTable.FieldByName('SwisSBLKey').Text;
              FieldByName('PropertyClassCode').Text := GrievanceTable.FieldByName('PropertyClassCode').Text;
              FieldByName('CurrentName1').Text := GrievanceTable.FieldByName('CurrentName1').Text;
              FieldByName('LegalAddr').Text := GrievanceTable.FieldByName('LegalAddr').Text;
              FieldByName('LegalAddrNo').Text := GrievanceTable.FieldByName('LegalAddrNo').Text;
              FieldByName('LegalAddrInt').AsInteger := GrievanceTable.FieldByName('LegalAddrInt').AsInteger;
              FieldByName('LawyerCode').Text := Representative;
              FieldByName('Notes').Text := TempStr;
              FieldByName('CurrentLandValue').AsInteger := GrievanceTable.FieldByName('CurrentLandValue').AsInteger;
              FieldByName('CurrentTotalValue').AsInteger := GrievanceTable.FieldByName('CurrentTotalValue').AsInteger;
              FieldByName('PetitTotalValue').AsInteger := GrievanceTable.FieldByName('PetitTotalValue').AsInteger;
              FieldByName('NoHearing').AsBoolean := GrievanceTable.FieldByName('NoHearing').AsBoolean;
              FieldByName('Frozen').AsBoolean := FrozenStatus;

              If GrievanceResultsTable.EOF
                then FieldByName('Decision').Text := ''
                else FieldByName('Decision').Text := GrievanceResultsTable.FieldByName('Disposition').Text;

              Decision := FieldByName('Decision').Text;

              If (GrievanceResultsTable.EOF or
                  (Deblank(Decision) = '') or
                  (StatusThisGrievance <> gsApproved))
                then
                  begin
                    FieldByName('ReducedToAmount').AsInteger := 0;
                    FieldByName('ReductionAmount').AsInteger := 0;
                  end
                else
                  begin
                    FieldByName('ReducedToAmount').AsInteger := GrievanceResultsTable.FieldByName('TotalValue').AsInteger;

                    If _Compare(FieldByName('ReducedToAmount').AsInteger, 0, coGreaterThan)
                      then FieldByName('ReductionAmount').AsInteger := FieldByName('CurrentTotalValue').AsInteger -
                                                                       FieldByName('ReducedToAmount').AsInteger
                      else FieldByName('ReductionAmount').AsInteger := 0;

                  end;  {else of If GrievanceResultsTable.EOF}

              try
                FieldByName('PetitReason').Text := GrievanceTable.FieldByName('PetitReason').Text;
              except
              end;

              FillSortFile_ExemptionsAsked;

              try
                FieldByName('CurrentName1').Text := GrievanceTable.FieldByName('CurrentName1').Text;
                FieldByName('CurrentName2').Text := GrievanceTable.FieldByName('CurrentName2').Text;
                FieldByName('CurrentAddress1').Text := GrievanceTable.FieldByName('CurrentAddress1').Text;
                FieldByName('CurrentAddress2').Text := GrievanceTable.FieldByName('CurrentAddress2').Text;
                FieldByName('CurrentStreet').Text := GrievanceTable.FieldByName('CurrentStreet').Text;
                FieldByName('CurrentCity').Text := GrievanceTable.FieldByName('CurrentCity').Text;
                FieldByName('CurrentState').Text := GrievanceTable.FieldByName('CurrentState').Text;
                FieldByName('CurrentZip').Text := GrievanceTable.FieldByName('CurrentZip').Text;
                FieldByName('CurrentZipPlus4').Text := GrievanceTable.FieldByName('CurrentZipPlus4').Text;
                FieldByName('AttyName1').Text := GrievanceTable.FieldByName('AttyName1').Text;
                FieldByName('AttyName2').Text := GrievanceTable.FieldByName('AttyName2').Text;
                FieldByName('AttyAddress1').Text := GrievanceTable.FieldByName('AttyAddress1').Text;
                FieldByName('AttyAddress2').Text := GrievanceTable.FieldByName('AttyAddress2').Text;
                FieldByName('AttyStreet').Text := GrievanceTable.FieldByName('AttyStreet').Text;
                FieldByName('AttyCity').Text := GrievanceTable.FieldByName('AttyCity').Text;
                FieldByName('AttyState').Text := GrievanceTable.FieldByName('AttyState').Text;
                FieldByName('AttyZip').Text := GrievanceTable.FieldByName('AttyZip').Text;
                FieldByName('AttyZipPlus4').Text := GrievanceTable.FieldByName('AttyZipPlus4').Text;

                If _Locate(ParcelTable, [ParcelTable.FieldByName('TaxRollYr').Text, SwisSBLKey], '', [loParseSwisSBLKey])
                  then FieldByName('AccountNumber').Text := ParcelTable.FieldByName('AccountNo').Text;

                {$H+}
                TMemoField(FieldByName('ComplaintReason')).AsString := ConvertRichTextFieldToString(RichTextMemo,
                                                                                                    PlainTextMemo,
                                                                                                    GrievanceDataSource,
                                                                                                    'PetitSubreason');

                TMemoField(FieldByName('DenialReason')).AsString := ConvertRichTextFieldToString(RichTextMemo,
                                                                                                 PlainTextMemo,
                                                                                                 GrievanceResultsDataSource,
                                                                                                 'DenialReason');

                TMemoField(FieldByName('ApprovalReason')).AsString := ConvertRichTextFieldToString(RichTextMemo,
                                                                                                   PlainTextMemo,
                                                                                                   GrievanceResultsDataSource,
                                                                                                   'Notes');
                {$H-}

              except
              end;

              try
                FieldByName('GrievanceStatus').AsInteger := StatusThisGrievance;
              except
              end;

              try
                FieldByName('DenialReasonCode').AsString := GrievanceResultsTable.FieldByName('DenialReasonCode').AsString;
              except
              end;

              Post;

            except
              Cancel;
              Quit := True;
              SystemSupport(001, SortGrievanceTable, 'Error inserting into sort file.',
                            UnitName, GlblErrorDlgBox);
            end;

        end;  {If not Done}

    Cancelled := ProgressDialog.Cancelled;

  until (Done or Quit or Cancelled);

end;  {FillSortFile}

{========================================================================}
{==================  PRINTING  ==========================================}
{======================================================================}
Procedure TGrievanceSummaryReportForm.PrintButtonClick(Sender: TObject);

var
  SortFileName, NewFileName, TempStr : String;
  Quit, WideCarriage : Boolean;
  I, TempPos : Integer;

begin
  ReportCancelled := False;
  Quit := False;
  PrintExtendedFormat := PrintExtendedFormatCheckBox.Checked;

  SelectedGrievanceResultsTypeList.Clear;

  with GrievanceResultsTypeCheckListBox do
    For I := 0 to (Items.Count - 1) do
      If Checked[I]
        then SelectedGrievanceResultsTypeList.Add(Items[I]);

  SelectedDenialCodes := TStringList.Create;
  SelectedRepresentativeCodes := TStringList.Create;
  SelectedComplaintReasons := TStringList.Create;

  PrintToExcel := PrintToExcelCheckBox.Checked;
  PrintGrievanceNotes := PrintGrievanceNotesCheckBox.Checked;
  GridLineFormat := GridLineFormatCheckBox.Checked;

    {FXX05072003-1(2.07): Not honoring grievance year.}

  GrievanceYear := GrievanceYearEdit.Text;

  ChangeRequestedType := GrievanceChangeRequestedTypeRadioGroup.ItemIndex;

    {CHG10121998-1: Add user options for default destination and show vet max msg.}

  SetPrintToScreenDefault(PrintDialog);

  If PrintDialog.Execute
    then
      begin
        SortGrievanceTable.Close;
        SortGrievanceTable.TableName := OrigSortFileName;

        SortFileName := GetSortFileName('GrievanceSummary');

        SortGrievanceTable.IndexName := '';
        CopySortFile(SortGrievanceTable, SortFileName);
        SortGrievanceTable.Close;
        SortGrievanceTable.TableName := SortFileName;
        SortGrievanceTable.Exclusive := True;

        try
          SortGrievanceTable.Open;
        except
          Quit := True;
          SystemSupport(060, SortGrievanceTable, 'Error opening sort table.',
                        UnitName, GlblErrorDlgBox);
        end;

        PrintOrder := PrintOrderRadioGroupBox.ItemIndex;

        with SortGrievanceTable do
          case PrintOrder of
            poGrievanceNumber : IndexName := 'BYYEAR_GRVNUM_SBL';
            poParcelID : IndexName := 'BYYEAR_SBL_GRVNUM';
            poOwnerName : IndexName := 'BYYEAR_NAME';
            poLegalAddress : IndexName := 'BYYEAR_LEGALADDR';
            poRepresentative : IndexName := 'BYLAWYERCODE';
            poPropertyClass : IndexName := 'BYPROPERTYCLASSCODE';
            poRepresentative_SBL :
              begin
                IndexName := 'BYLAWYERCODE_SBL';
                OrigGlblDisplaySwisOnPrintKey := GlblDisplaySwisOnPrintKey;
                GlblDisplaySwisOnPrintKey := True;
              end;

          end;  {case PrintOrder of}

        CreateParcelList := CreateParcelListCheckBox.Checked;
        If CreateParcelList
          then ParcelListDialog.ClearParcelGrid(True);

        IncludeResults := IncludeResultsCheckBox.Checked;

        PrintAppearanceNumberColumn := AppearanceNumberCheckBox.Checked;

          {CHG08202002-3: Allow for choice of lawyer name print.}

        PrintLawyerName := PrintLawyerNameCheckBox.Checked;

        GrievanceStatusType := GrievanceTypeRadioGroup.ItemIndex;

        For I := 0 to (DenialCodeListBox.Items.Count - 1) do
          If DenialCodeListBox.Selected[I]
            then
              begin
                TempStr := DenialCodeListBox.Items[I];
                TempPos := Pos('-', TempStr);

                SelectedDenialCodes.Add(Take((TempPos - 2), TempStr));

              end;  {If DenialCodeListBox.Selected[I])}

        For I := 0 to (RepresentativeCodeListBox.Items.Count - 1) do
          If RepresentativeCodeListBox.Selected[I]
            then
              begin
                TempStr := RepresentativeCodeListBox.Items[I];
                TempPos := Pos('-', TempStr);

                SelectedRepresentativeCodes.Add(Take((TempPos - 2), TempStr));

              end;  {If RepresentativeCodeListBox.Selected[I])}

        For I := 0 to (ComplaintReasonListBox.Items.Count - 1) do
          If ComplaintReasonListBox.Selected[I]
            then SelectedComplaintReasons.Add(ComplaintReasonListBox.Items[I]);

        WideCarriage := (IncludeResults or GridLineFormat);

        If PrintToExcel
          then
            begin
              SpreadsheetFileName := GetPrintFileName(Self.Caption, True);
              AssignFile(ExtractFile, SpreadsheetFileName);
              Rewrite(ExtractFile);

              Write(ExtractFile, 'Grv #,',
                                 'Parcel ID,',
                                 'Swis SBL,',
                                 'Account #,',
                                 'Property Address,',
                                 'Owner,',
                                 'Class,',
                                 'Represented,',
                                 'Reason,',
                                 'Asking Amount,',
                                 'EX Code 1,',
                                 'EX Amt 1,',
                                 'EX Pct 1,',
                                 'EX Code 2,',
                                 'EX Amt 2,',
                                 'EX Pct 2,',
                                 'EX Code 3,',
                                 'EX Amt 3,',
                                 'EX Pct 3,',
                                 'Decision,',
                                 'Denial Reason Code,',
                                 'Denial Reason,',
                                 'Land,',
                                 'Tentative Total,',
                                 'BAR Change To,',
                                 'BAR Red Amount,',
                                 'Frozen,',
                                 'Open Cert?,',
                                 'Account #,',
                                 'Old Print Key,',
                                 'Additional Lots');

              If PrintGrievanceNotes
                then Writeln(ExtractFile, ',Notes')
                else Writeln(ExtractFile);

            end;  {If PrintToExcel}

          {CHG10131998-1: Set the printer settings based on what printer they selected
                          only - they no longer need to worry about paper or landscape
                          mode.}

        AssignPrinterSettings(PrintDialog, ReportPrinter, ReportFiler, [ptLaser],
                              WideCarriage, Quit);

        If (GridLineFormat or
            PrintExtendedFormat)
          then
            begin
              ReportFiler.Orientation := poLandscape;
              ReportPrinter.Orientation := poLandscape;
            end;

        If PrintExtendedFormat
          then
            begin
              ReportFiler.SetPaperSize(dmPaper_Letter, 0, 0);
              ReportPrinter.SetPaperSize(dmPaper_Letter, 0, 0);
            end;

        If not Quit
          then
            begin
              ProgressDialog.UserLabelCaption := '';

              ProgressDialog.Start(GetRecordCount(GrievanceTable), True, True);

                {Now print the report.}

              FillSortFile(Quit);

              If not Quit
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

                          ShowReportDialog('Grievance Summary Report.RPT', NewFileName, True);

                        end
                      else ReportPrinter.Execute;

                  end;  {If not Quit}

                {Clear the selections.}

              ProgressDialog.Finish;

                {FXX09071999-6: Tell people that printing is starting and
                                done.}

              DisplayPrintingFinishedMessage(PrintDialog.PrintToFile);


              If CreateParcelList
                then ParcelListDialog.Show;

              If PrintToExcel
                then
                  begin
                    CloseFile(ExtractFile);
                    SendTextFileToExcelSpreadsheet(SpreadsheetFileName, True,
                                                   False, '');

                  end;  {If PrintToExcel}

              SortGrievanceTable.Close;

              try
                Chdir(GlblReportDir);
                OldDeleteFile(SortFileName)
              except
              end;

            end;  {If not Quit}

        ResetPrinter(ReportPrinter);

      end;  {If PrintDialog.Execute}

  SelectedDenialCodes.Free;
  SelectedRepresentativeCodes.Free;
  SelectedComplaintReasons.Free;

  GlblDisplaySwisOnPrintKey := OrigGlblDisplaySwisOnPrintKey;

end;  {PrintButtonClick}

{====================================================================}
Function TGrievanceSummaryReportForm.MeetsCriteria(    SwisSBLKey : String;
                                                       GrievanceYear : String;
                                                   var StatusThisGrievance : Integer) : Boolean;

var
  StatusStr : String;

begin
  Result := False;

    {FXX05072003-1(2.07): Not honoring grievance year.}

  If ((Deblank(GrievanceYear) = '') or
      (GrievanceTable.FieldByName('TaxRollYr').Text = GrievanceYear))
    then Result := True;

  If Result
    then
      begin
        StatusThisGrievance := GetGrievanceStatus(GrievanceTable, GrievanceExemptionsAskedTable,
                                                  GrievanceResultsTable, GrievanceDispositionCodeTable,
                                                  GrievanceYear, SwisSBLKey,
                                                  True, StatusStr);

          {FXX08102008-1(2.15.1.3): If the user did not select specific denial codes, don't
                                    use it as a criteria.}

        If (GrievanceStatusType = gstAll)
          then Result := True
          else
            case GrievanceStatusType of
              gstOpen : Result := (StatusThisGrievance in [gsOpen,
                                                           gsMixed]);
              gstClosed : Result := (StatusThisGrievance in [gsClosed,
                                                             gsApproved,
                                                             gsDenied,
                                                             gsDismissed]);
              gstApproved : Result := (StatusThisGrievance = gsApproved);

              gstDenied :
                Result := ((StatusThisGrievance = gsDenied) and
                           ((DenialCodeListBox.Items.Count = 0) or
                            _Compare(DenialCodeListBox.Items.Count, SelectedDenialCodes.Count, coEqual) or
                            (SelectedDenialCodes.IndexOf(Trim(GrievanceResultsTable.FieldByName('DenialReasonCode').Text)) > -1)));

                {FXX8262004-1(2.8.0.9)[1889]: Missing a filter for the denied status.}

              gstDismissed :
                Result := ((StatusThisGrievance = gsDismissed) and
                           ((DenialCodeListBox.Items.Count = 0) or
                            _Compare(DenialCodeListBox.Items.Count, SelectedDenialCodes.Count, coEqual) or
                            (SelectedDenialCodes.IndexOf(Trim(GrievanceResultsTable.FieldByName('DenialReasonCode').Text)) > -1)));

              gstWithdrawn :
                Result := ((StatusThisGrievance = gsWithdrawn) and
                           ((DenialCodeListBox.Items.Count = 0) or
                            _Compare(DenialCodeListBox.Items.Count, SelectedDenialCodes.Count, coEqual) or
                            (SelectedDenialCodes.IndexOf(Trim(GrievanceResultsTable.FieldByName('DenialReasonCode').Text)) > -1)));

            end;  {case StatusThisGrievance of}

      end;  {If Result}

    {Check the representative.}

  If Result
    then Result := ((SelectedRepresentativeCodes.Count =
                     RepresentativeCodeListBox.Items.Count) or  {All items selected}
                    (SelectedRepresentativeCodes.IndexOf(GrievanceTable.FieldByName('LawyerCode').Text) > -1));

    {CHG06062004-1(2.07l5): Allow for extract \ search on petitioner reason,
                            exemptions asked.}

  If Result
    then Result := ((SelectedComplaintReasons.Count =
                     ComplaintReasonListBox.Items.Count) or  {All items selected}
                    (SelectedComplaintReasons.IndexOf(GrievanceTable.FieldByName('PetitReason').Text) > -1));

  If Result
    then
      with GrievanceTable do
        case ChangeRequestedType of
          crtAssessmentReduction : Result := ((FieldByName('PetitTotalValue').AsInteger > 0) and
                                              (GrievanceExemptionsAskedTable.RecordCount = 0));
          crtExemptionChange_Addition : Result := ((FieldByName('PetitTotalValue').AsInteger = 0) and
                                                   (GrievanceExemptionsAskedTable.RecordCount > 0));
        end;  {case ChangeRequestedType of}

    {FXX06182009-1(2.20.1.3)[D1547]: Open status was not working.}

  If (Result and
      _Compare(GrievanceStatusType, gstOpen, coNotEqual) and
      _Compare(GrievanceStatusType, gstAll, coNotEqual) and
      ((_Compare(SelectedGrievanceResultsTypeList.IndexOf(GrievanceResultsTable.FieldByName('Disposition').AsString), -1, coEqual)) or
        _Compare(GrievanceResultsTable.FieldByName('Disposition').AsString, coBlank)))
    then Result := False;

end;  {MeetsGrievanceStatusCriteria}

{====================================================================}
Procedure TGrievanceSummaryReportForm.ReportPrintHeader(Sender: TObject);

begin
    {CHG09292003-1(2.07j): Add the property class code to the report.}

  with Sender as TBaseReport do
    begin
      SectionTop := 0.25;
      SectionLeft := 0.5;
      ClearTabs;
      SetTab(0.3, pjLeft, 8.0, 0, BoxLineNone, 0);

      Println('');
      Println('');

        {Print the date and page number.}

      SetFont('Times New Roman',8);
      PrintHeader('Page: ' + IntToStr(CurrentPage) + '         ', pjRight);
      PrintHeader('    Date: ' + DateToStr(Date) + '  Time: ' + TimeToStr(Now), pjLeft);

      SetFont('Times New Roman',14);
      Bold := True;
      Home;
      Println('');
      Println('');
      Println('');
      If PrintExtendedFormat
        then PrintLeft('Minutes of the Board of Assessment Review', 0.5)
        else PrintCenter('Grievance Listing for ' + GrievanceYear, (PageWidth / 2));

      Println('');
      Println('');

      If GridLineFormat
        then SetFont('Times New Roman',8)
        else SetFont('Times New Roman',10);
      ClearTabs;

        {CHG08202002-2: Change report to show current and asking value.}
        {CHG10042005-1(2.9.3.3): Extended "minutes" format for Yorktown.}

      If not PrintExtendedFormat
        then
          If GridLineFormat
            then
              begin
                Bold := True;
                ClearTabs;
                SetTab(0.2, pjCenter, 0.3, 5, BoxLineAll, 0);   {Grievance #}
                SetTab(0.5, pjCenter, 1.1, 5, BoxLineAll, 0);   {Parcel ID}
                SetTab(1.6, pjCenter, 1.8, 5, BoxLineAll, 0);   {Legal address}
                SetTab(3.4, pjCenter, 1.8, 5, BoxLineAll, 0);   {Owner name}
                SetTab(5.2, pjCenter, 0.4, 5, BoxLineAll, 0);   {Property Class}
                SetTab(5.6, pjCenter, 1.0, 5, BoxLineAll, 0);   {Lawyer}
                SetTab(6.6, pjCenter, 0.9, 5, BoxLineAll, 0);   {Decision code}
                SetTab(7.5, pjCenter, 0.4, 5, BoxLineAll, 0);   {Denial code}
                SetTab(7.9, pjCenter, 0.7, 5, BoxLineAll, 0);   {Current Land}
                SetTab(8.6, pjCenter, 0.9, 5, BoxLineAll, 0);   {Current Total}
                SetTab(9.5, pjCenter, 0.9, 5, BoxLineAll, 0);   {Asking value}
                SetTab(10.4, pjCenter, 0.9, 5, BoxLineAll, 0);   {Granted total value}
                SetTab(11.3, pjCenter, 0.9, 5, BoxLineAll, 0);   {Reduction Amount}
                SetTab(12.2, pjCenter, 0.3, 5, BoxLineAll, 0);   {Frozen}
                SetTab(12.5, pjCenter, 1.4, 5, BoxLineAll, 0);   {Notes}

                Println(#9 + #9 + #9 + #9 +
                        #9 + #9 + #9 +
                        #9 + 'Den' +
                        #9 + 'Tentative' +
                        #9 + 'Tentative' +
                        #9 + 'Asking' +
                        #9 + 'BAR' +
                        #9 + 'BAR' +
                        #9 + 'PAR' +
                        #9 + 'Certs');

                Println(#9 + '#' +
                        #9 + 'Parcel ID' +
                        #9 + 'Legal Address' +
                        #9 + 'Owner' +
                        #9 + 'CLS' +
                        #9 + 'Represented' +
                        #9 + 'Decision' +
                        #9 + 'Code' +
                        #9 + 'Land' +
                        #9 + 'Total' +
                        #9 + 'Amount' +
                        #9 + 'Reduced To' +
                        #9 + 'Red Amount' +
                        #9 + 'FRO' +
                        #9 + 'Pending');

                Bold := False;

                Println(#9 + #9 + #9 + #9 +
                        #9 + #9 + #9 + #9 +
                        #9 + #9 + #9 + #9 +
                        #9 + #9 + #9 + '');

                Println(#9 + #9 + #9 + #9 +
                        #9 + #9 + #9 + #9 +
                        #9 + #9 + #9 + #9 +
                        #9 + #9 + #9 + '');

                ClearTabs;
                SetTab(0.2, pjRight, 0.3, 5, BoxLineAll, 0);   {Grievance #}
                SetTab(0.5, pjLeft, 1.1, 5, BoxLineAll, 0);   {Parcel ID}
                SetTab(1.6, pjLeft, 1.8, 5, BoxLineAll, 0);   {Legal address}
                SetTab(3.4, pjLeft, 1.8, 5, BoxLineAll, 0);   {Owner name}
                SetTab(5.2, pjLeft, 0.4, 5, BoxLineAll, 0);   {Property Class}
                SetTab(5.6, pjLeft, 1.0, 5, BoxLineAll, 0);   {Lawyer}
                SetTab(6.6, pjLeft, 0.9, 5, BoxLineAll, 0);   {Decision code}
                SetTab(7.5, pjLeft, 0.4, 5, BoxLineAll, 0);   {Denial code}
                SetTab(7.9, pjRight, 0.7, 5, BoxLineAll, 0);   {Current Land}
                SetTab(8.6, pjRight, 0.9, 5, BoxLineAll, 0);   {Current Total}
                SetTab(9.5, pjRight, 0.9, 5, BoxLineAll, 0);   {Asking value}
                SetTab(10.4, pjRight, 0.9, 5, BoxLineAll, 0);   {Granted total value}
                SetTab(11.3, pjRight, 0.9, 5, BoxLineAll, 0);   {Reduction Amount}
                SetTab(12.2, pjCenter, 0.3, 5, BoxLineAll, 0);   {Frozen}
                SetTab(12.5, pjLeft, 1.4, 5, BoxLineAll, 0);   {Notes}

              end
            else
              begin
                If IncludeResults
                  then
                    begin
                      SetTab(0.3, pjCenter, 0.4, 0, BoxLineNone, 0);   {Grievance #}
                      SetTab(0.8, pjCenter, 1.3, 0, BoxLineNone, 0);   {Lawyer}
                      SetTab(2.2, pjCenter, 1.3, 0, BoxLineNone, 0);   {Owner name}
                      SetTab(3.6, pjCenter, 1.3, 0, BoxLineNone, 0);   {Parcel ID}
                      SetTab(5.0, pjCenter, 0.9, 0, BoxLineNone, 0);   {Legal address}
                      SetTab(6.0, pjCenter, 0.3, 0, BoxLineNone, 0);   {Property Class}

                      SetTab(6.4, pjCenter, 0.9, 0, BoxLineNone, 0);   {Current value}
                      SetTab(7.4, pjCenter, 0.9, 0, BoxLineNone, 0);   {Asking value}
                      SetTab(8.4, pjCenter, 1.0, 0, BoxLineNone, 0);   {Decision code}
                      SetTab(9.5, pjCenter, 0.6, 0, BoxLineNone, 0);   {Denial code}
                      SetTab(10.2, pjCenter, 0.9, 0, BoxLineNone, 0);   {Granted total value}
                      SetTab(11.2, pjCenter, 0.7, 0, BoxLineNone, 0);   {Reduction amount}
                      SetTab(12.0, pjCenter, 1.3, 0, BoxLineNone, 0);   {Granted exemption info}
                      SetTab(13.4, pjCenter, 0.5, 0, BoxLineNone, 0);   {Transferred to main parcel}

                    end
                  else
                    begin
                      SetTab(0.3, pjCenter, 0.5, 0, BoxLineNone, 0);   {Grievance #}
                      SetTab(0.9, pjCenter, 1.0, 0, BoxLineNone, 0);   {Lawyer}
                      SetTab(2.0, pjCenter, 2.3, 0, BoxLineNone, 0);   {Owner name}
                      SetTab(4.4, pjCenter, 1.4, 0, BoxLineNone, 0);   {Parcel ID}
                      SetTab(5.9, pjCenter, 1.5, 0, BoxLineNone, 0);   {Legal address}
                      SetTab(7.5, pjCenter, 0.3, 0, BoxLineNone, 0);   {Property Class}
                      SetTab(7.9, pjCenter, 0.3, 0, BoxLineNone, 0);   {Appearance #}

                    end;  {else of If IncludeResults}

                Bold := True;
                Print(#9 + 'Grv');

                If PrintAppearanceNumberColumn
                  then Print(#9 + #9 + #9 + #9 +
                             #9 + 'Apr');

                If IncludeResults
                  then Println(#9 + #9 + #9 + #9 + #9 +
                               #9 + 'Current' +
                               #9 + 'Asking' +
                               #9 + 'Decision' +
                               #9 + 'Denial' +
                               #9 + 'Granted' +
                               #9 +
                               #9 + 'Granted')
                  else Println('');

                ClearTabs;
                Bold := True;

                If IncludeResults
                  then
                    begin
                      SetTab(0.3, pjCenter, 0.4, 0, BoxLineBottom, 0);   {Grievance #}
                      SetTab(0.8, pjCenter, 1.3, 0, BoxLineBottom, 0);   {Lawyer}
                      SetTab(2.2, pjCenter, 1.3, 0, BoxLineBottom, 0);   {Owner name}
                      SetTab(3.6, pjCenter, 1.3, 0, BoxLineBottom, 0);   {Parcel ID}
                      SetTab(5.0, pjCenter, 0.9, 0, BoxLineBottom, 0);   {Legal address}
                      SetTab(6.0, pjCenter, 0.3, 0, BoxLineBottom, 0);   {Property Class}

                      SetTab(6.4, pjCenter, 0.9, 0, BoxLineBottom, 0);   {Current value}
                      SetTab(7.4, pjCenter, 0.9, 0, BoxLineBottom, 0);   {Asking value}
                      SetTab(8.4, pjCenter, 1.0, 0, BoxLineBottom, 0);   {Decision code}
                      SetTab(9.5, pjCenter, 0.6, 0, BoxLineBottom, 0);   {Denial code}
                      SetTab(10.2, pjCenter, 0.9, 0, BoxLineBottom, 0);   {Granted total value}
                      SetTab(11.2, pjCenter, 0.7, 0, BoxLineBottom, 0);   {Reduction amount}
                      SetTab(12.0, pjCenter, 1.3, 0, BoxLineBottom, 0);   {Granted exemption info}
                      SetTab(13.4, pjCenter, 0.5, 0, BoxLineBottom, 0);   {Transferred to main parcel}

                    end
                  else
                    begin
                      SetTab(0.3, pjCenter, 0.5, 0, BoxLineBottom, 0);   {Grievance #}
                      SetTab(0.9, pjCenter, 1.0, 0, BoxLineBottom, 0);   {Lawyer}
                      SetTab(2.0, pjCenter, 2.3, 0, BoxLineBottom, 0);   {Owner name}
                      SetTab(4.4, pjCenter, 1.4, 0, BoxLineBottom, 0);   {Parcel ID}
                      SetTab(5.9, pjCenter, 1.5, 0, BoxLineBottom, 0);   {Legal address}
                      SetTab(7.5, pjCenter, 0.3, 0, BoxLineBottom, 0);   {Property Class}
                      SetTab(7.9, pjCenter, 0.3, 0, BoxLineBottom, 0);   {Appearance #}

                    end;  {else of If IncludeResults}

                Print(#9 + 'Num' +
                      #9 + 'Representative' +
                      #9 + 'Name' +
                      #9 + 'Parcel ID' +
                      #9 + 'Legal Address' +
                      #9 + 'Cls');

                If PrintAppearanceNumberColumn
                  then Print(#9 + 'Num');

                If IncludeResults
                  then Println(#9 + 'Value' +
                               #9 + 'Value' +
                               #9 + 'Code' +
                               #9 + 'Code' +
                               #9 + 'Total Val' +
                               #9 + 'Reduction' +
                               #9 + 'Exemption Info' +
                               #9 + 'Updated')
                  else Println('');

                ClearTabs;

                If IncludeResults
                  then
                    begin
                      SetTab(0.3, pjLeft, 0.4, 0, BoxLineNone, 0);   {Grievance #}
                      SetTab(0.8, pjLeft, 1.3, 0, BoxLineNone, 0);   {Lawyer}
                      SetTab(2.2, pjLeft, 1.3, 0, BoxLineNone, 0);   {Owner name}
                      SetTab(3.6, pjLeft, 1.3, 0, BoxLineNone, 0);   {Parcel ID}
                      SetTab(5.0, pjLeft, 0.9, 0, BoxLineNone, 0);   {Legal address}
                      SetTab(6.0, pjLeft, 0.3, 0, BoxLineNone, 0);   {Legal address}

                      SetTab(6.4, pjRight, 0.9, 0, BoxLineNone, 0);   {Current value}
                      SetTab(7.4, pjRight, 0.9, 0, BoxLineNone, 0);   {Asking value}
                      SetTab(8.4, pjLeft, 1.0, 0, BoxLineNone, 0);   {Decision code}
                      SetTab(9.5, pjLeft, 0.6, 0, BoxLineNone, 0);   {Denial code}
                      SetTab(10.2, pjRight, 0.9, 0, BoxLineNone, 0);   {Granted total value}
                      SetTab(11.2, pjRight, 0.7, 0, BoxLineNone, 0);   {Reduction amount}
                      SetTab(12.0, pjLeft, 1.3, 0, BoxLineNone, 0);   {Granted exemption info}
                      SetTab(13.4, pjCenter, 0.5, 0, BoxLineNone, 0);   {Transferred to main parcel}

                    end
                  else
                    begin
                      SetTab(0.3, pjLeft, 0.5, 0, BoxLineNone, 0);   {Grievance #}
                      SetTab(0.9, pjLeft, 1.0, 0, BoxLineNone, 0);   {Lawyer}
                      SetTab(2.0, pjLeft, 2.3, 0, BoxLineNone, 0);   {Owner name}
                      SetTab(4.4, pjLeft, 1.4, 0, BoxLineNone, 0);   {Parcel ID}
                      SetTab(5.9, pjLeft, 1.5, 0, BoxLineNone, 0);   {Legal address}
                      SetTab(7.5, pjLeft, 0.3, 0, BoxLineNone, 0);   {Property Class}
                      SetTab(7.9, pjLeft, 0.3, 0, BoxLineNone, 0);   {Appearance #}

                    end;  {else of If IncludeResults}

                Println('');

              end;  {else of If GridLineFormat}

      Bold := False;

    end;  {with Sender as TBaseReport do}

end;  {TextFilerPrintHeader}

{====================================================================}
Function GetLawyerInfoToDisplay(LawyerCode : String;
                                PrintLawyerName : Boolean;
                                IncludeResults : Boolean;
                                RepresentativeCodesTable : TTable) : String;

begin
  If PrintLawyerName
    then
      begin
        FindKeyOld(RepresentativeCodesTable, ['Code'],
                   [LawyerCode]);

        Result := RepresentativeCodesTable.FieldByName('Name1').Text;

        If IncludeResults
          then Result := Take(18, Result)
          else Result := Take(12, Result);
      end
    else Result := LawyerCode;

end;  {GetLawyerInfoToDisplay}

{====================================================================}
Procedure TGrievanceSummaryReportForm.PrintOneGrievance(Sender : TObject);

var
  SwisSBLKey, GrievanceYear, TempGrantedValue, TempReductionAmount : String;
  GrievanceNumber, I : Integer;
  OwnerNameAddress, RepresentativeNameAddress : NameAddrArray;
  PrintRepresentative : Boolean;
  DBMemoBuf : TDBMemoBuf;

begin
  with Sender as TBaseReport, SortGrievanceTable do
    begin
      If (LinesLeft < 13)
        then NewPage;

      ClearTabs;
      SetTab(0.3, pjCenter, 0.8, 5, BoxLineAll, 25);   {Grievance #}
      SetTab(1.1, pjCenter, 2.0, 5, BoxLineAll, 25);   {Legal addr}
      SetTab(3.1, pjCenter, 1.3, 5, BoxLineAll, 25);   {Parcel ID}
      SetTab(4.4, pjCenter, 0.9, 5, BoxLineAll, 25);   {Account #}
      SetTab(5.3, pjCenter, 1.0, 5, BoxLineAll, 25);   {Av}
      SetTab(6.3, pjCenter, 1.0, 5, BoxLineAll, 25);   {Requested}
      SetTab(7.3, pjCenter, 1.0, 5, BoxLineAll, 25);   {BAR}
      SetTab(8.3, pjCenter, 1.0, 5, BoxLineAll, 25);   {Reduction}

      Bold := True;
      Println(#9 + 'Grievance #' +
              #9 + 'Property Location' +
              #9 + 'Parcel ID' +
              #9 + 'Account #' +
              #9 + 'Assessed Value' +
              #9 + 'AV Requested' +
              #9 + 'B.A.R. Value' +
              #9 + 'Reduction');
      Bold := False;

      ClearTabs;
      SetTab(0.3, pjLeft, 0.8, 5, BoxLineAll, 0);   {Grievance #}
      SetTab(1.1, pjLeft, 2.0, 5, BoxLineAll, 0);   {Legal addr}
      SetTab(3.1, pjLeft, 1.3, 5, BoxLineAll, 0);   {Parcel ID}
      SetTab(4.4, pjLeft, 0.9, 5, BoxLineAll, 0);   {Account #}
      SetTab(5.3, pjRight, 1.0, 5, BoxLineAll, 0);   {Av}
      SetTab(6.3, pjRight, 1.0, 5, BoxLineAll, 0);   {Requested}
      SetTab(7.3, pjRight, 1.0, 5, BoxLineAll, 0);   {BAR}
      SetTab(8.3, pjRight, 1.0, 5, BoxLineAll, 0);   {Reduction}

      GrievanceNumber := FieldByName('GrievanceNumber').AsInteger;
      GrievanceYear := FieldByName('TaxRollYr').Text;
      SwisSBLKey := FieldByName('SwisSBLKey').Text;

      SetRangeOld(GrievanceResultsTable,
                  ['TaxRollYr', 'SwisSBLKey', 'GrievanceNumber', 'ResultNumber'],
                  [GrievanceYear, SwisSBLKey, IntToStr(GrievanceNumber), '0'],
                  [GrievanceYear, SwisSBLKey, IntToStr(GrievanceNumber), '9999']);

      GrievanceResultsTable.First;

      If _Compare(FieldByName('ReductionAmount').AsFloat, 0, coGreaterThan)
        then
          begin
            TempGrantedValue := FormatFloat(NoDecimalDisplay_BlankZero,
                                            GrievanceResultsTable.FieldByName('TotalValue').AsFloat);
            TempReductionAmount := FormatFloat(NoDecimalDisplay_BlankZero,
                                               FieldByName('ReductionAmount').AsFloat);
          end
        else
          begin
            TempGrantedValue := 'No Change';
            TempReductionAmount := 'No Change';
          end;

      Println(#9 + FieldByName('GrievanceNumber').Text +
              #9 + GetLegalAddressFromTable(SortGrievanceTable) +
              #9 + ConvertSwisSBLToDashDot(SwisSBLKey) +
              #9 + FieldByName('AccountNumber').Text +
              #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                               FieldByName('CurrentTotalValue').AsFloat) +
              #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                               FieldByName('PetitTotalValue').AsFloat) +
              #9 + TempGrantedValue +
              #9 + TempReductionAmount);

      FillInNameAddrArray(FieldByName('CurrentName1').Text,
                          FieldByName('CurrentName2').Text,
                          FieldByName('CurrentAddress1').Text,
                          FieldByName('CurrentAddress2').Text,
                          FieldByName('CurrentStreet').Text,
                          FieldByName('CurrentCity').Text,
                          FieldByName('CurrentState').Text,
                          FieldByName('CurrentZip').Text,
                          FieldByName('CurrentZipPlus4').Text,
                          True, False, OwnerNameAddress);

      FillInNameAddrArray(FieldByName('AttyName1').Text,
                          FieldByName('AttyName2').Text,
                          FieldByName('AttyAddress1').Text,
                          FieldByName('AttyAddress2').Text,
                          FieldByName('AttyStreet').Text,
                          FieldByName('AttyCity').Text,
                          FieldByName('AttyState').Text,
                          FieldByName('AttyZip').Text,
                          FieldByName('AttyZipPlus4').Text,
                          True, False, RepresentativeNameAddress);

      PrintRepresentative := _Compare(FieldByName('LawyerCode').Text, coNotBlank);

      If PrintRepresentative
        then
          begin
            ClearTabs;
            SetTab(5.0, pjLeft, 0.6, 0, BoxLineNone, 0);   {Rep label}
            SetTab(5.7, pjLeft, 3.0, 0, BoxLineNone, 0);   {Rep}

            Bold := True;
            Print(#9 + 'Agent:');
            Bold := False;
            Println(#9 + FieldByName('LawyerCode').Text);

          end;  {If PrintRepresentative}

      ClearTabs;
      SetTab(0.5, pjLeft, 0.6, 0, BoxLineNone, 0);   {Owner label}
      SetTab(1.2, pjLeft, 3.0, 0, BoxLineNone, 0);   {Owner}
      SetTab(5.0, pjLeft, 0.6, 0, BoxLineNone, 0);   {Rep label}
      SetTab(5.7, pjLeft, 3.0, 0, BoxLineNone, 0);   {Rep}

      Bold := True;
      Print(#9 + 'Owner:');
      Bold := False;
      Print(#9 + OwnerNameAddress[1]);

      If PrintRepresentative
        then
          begin
            Bold := True;
            Print(#9 + 'Addr:');
            Bold := False;
            Println(#9 + RepresentativeNameAddress[1]);

          end  {If PrintRepresentative}
        else Println('');

      For I := 2 to 6 do
        If (_Compare(OwnerNameAddress[I], coNotBlank) or
            _Compare(RepresentativeNameAddress[I], coNotBlank))
          then Println(#9 +
                       #9 + OwnerNameAddress[I] +
                       #9 +
                       #9 + RepresentativeNameAddress[I]);

      ClearTabs;
      SetTab(0.5, pjLeft, 4.5, 0, BoxLineNone, 0);   {Grounds for complaint}

      Println('');
      Bold := True;
      Println(#9 + 'Grounds for complaint:');
      Bold := False;

      DBMemoBuf := TDBMemoBuf.Create;
      DBMemoBuf.RTFField := TMemoField(FieldByName('ComplaintReason'));

      DBMemoBuf.PrintStart := 0.5;
      DBMemoBuf.PrintEnd := 10.5;

      PrintMemo(DBMemoBuf, 0, False);
      DBMemoBuf.Free;

      Bold := True;
      Println(#9 + 'Determination by board:');
      Bold := False;

      DBMemoBuf := TDBMemoBuf.Create;

      If TMemoField(FieldByName('DenialReason')).IsNull
        then DBMemoBuf.RTFField := TMemoField(FieldByName('ApprovalReason'))
        else DBMemoBuf.RTFField := TMemoField(FieldByName('DenialReason'));

      DBMemoBuf.PrintStart := 0.5;
      DBMemoBuf.PrintEnd := 10.5;

      PrintMemo(DBMemoBuf, 0, False);
      DBMemoBuf.Free;

      Println('');

    end;  {with Sender as TBaseReport, SortGrievanceTable do}

end;  {PrintOneGrievance}

{====================================================================}
Procedure TGrievanceSummaryReportForm.ReportPrint(Sender: TObject);

var
  Done, FirstTimeThrough,
  DoneResults, FirstTimeThroughResults, Quit : Boolean;
  SwisSBLKey,
  FrozenStatusStr,
  Representative, sDecision,
  Updated, EXAmountToDisplay, sOpenCertiorari : String;
  NumPrinted, GrievanceNumber : Integer;
  iTotalReduction : LongInt;
  TotalsRec : GrievanceTotalsRecord;

begin
  iTotalReduction := 0;
  Done := False;
  FirstTimeThrough := True;
  Quit := False;
  SortGrievanceTable.First;
  ProgressDialog.UserLabelCaption := 'Printing sort file.';
  ProgressDialog.Start(SortGrievanceTable.RecordCount, True, True);
  InitGrievanceTotalsRecord(TotalsRec);

  with Sender as TBaseReport do
    begin
        {First print the individual changes.}

      repeat
        If FirstTimeThrough
          then FirstTimeThrough := False
          else SortGrievanceTable.Next;

        If SortGrievanceTable.EOF
          then Done := True;

        Application.ProcessMessages;
        ProgressDialog.Update(Self, ConvertSwisSBLToDashDot(SortGrievanceTable.FieldByName('SwisSBLKey').Text));
        SwisSBLKey := SortGrievanceTable.FieldByName('SwisSBLKey').Text;

        If not Done
          then
            with SortGrievanceTable do
              begin
                iTotalReduction := iTotalReduction +
                                   FieldByName('ReductionAmount').AsInteger;

                try
                  UpdateGrievanceTotalsRecord(TotalsRec, FieldByName('GrievanceStatus').AsInteger);
                except
                end;

                If PrintExtendedFormat
                  then PrintOneGrievance(Sender)
                  else
                    If GridLineFormat
                      then
                        begin
                          Representative := FieldByName('LawyerCode').Text;

                          If (Deblank(Representative) = '')
                            then Representative := 'PRO SE';

                          FrozenStatusStr := '';
                          If FieldByName('Frozen').AsBoolean
                            then FrozenStatusStr := 'X';

                          Println(#9 + FieldByName('GrievanceNumber').Text +
                                  #9 + ConvertSBLOnlyToDashDot(Copy(FieldByName('SwisSBLKey').Text, 7, 20)) +
                                  #9 + Take(18, Trim(GetLegalAddressFromTable(SortGrievanceTable))) +
                                  #9 + Take(18, FieldByName('CurrentName1').Text) +
                                  #9 + FieldByName('PropertyClassCode').Text +
                                  #9 + Representative +
                                  #9 + FieldByName('Decision').AsString +
                                  #9 + FieldByName('DenialReasonCode').AsString +
                                  #9 + FormatFloat(NoDecimalDisplay_BlankZero,
                                                   FieldByName('CurrentLandValue').AsFloat) +
                                  #9 + FormatFloat(NoDecimalDisplay_BlankZero,
                                                   FieldByName('CurrentTotalValue').AsFloat) +
                                  #9 + FormatFloat(NoDecimalDisplay_BlankZero,
                                                   FieldByName('PetitTotalValue').AsFloat) +
                                  #9 + FormatFloat(NoDecimalDisplay_BlankZero,
                                                   FieldByName('ReducedToAmount').AsFloat) +
                                  #9 + FormatFloat(NoDecimalDisplay_BlankZero,
                                                   FieldByName('ReductionAmount').AsFloat) +
                                  #9 + FrozenStatusStr +
                                  #9 + FieldByName('Notes').Text);

                        end
                      else
                        begin
                          Print(#9 + GetGrievanceNumberToDisplay(SortGrievanceTable) +
                                #9 + GetLawyerInfoToDisplay(FieldByName('LawyerCode').Text,
                                                            PrintLawyerName,
                                                            IncludeResults,
                                                            RepresentativeCodesTable));

                          If IncludeResults
                            then
                              begin
                                GrievanceNumber := FieldByName('GrievanceNumber').AsInteger;
                                SetRangeOld(GrievanceResultsTable,
                                            ['TaxRollYr', 'SwisSBLKey', 'GrievanceNumber', 'ResultNumber'],
                                            [GrievanceYear, SwisSBLKey, IntToStr(GrievanceNumber), '0'],
                                            [GrievanceYear, SwisSBLKey, IntToStr(GrievanceNumber), '9999']);

                                GrievanceResultsTable.First;
                                DoneResults := False;
                                FirstTimeThroughResults := True;
                                Updated := '';
                                NumPrinted := 0;

                                repeat
                                  If FirstTimeThroughResults
                                    then FirstTimeThroughResults := False
                                    else GrievanceResultsTable.Next;

                                  If GrievanceResultsTable.EOF
                                    then DoneResults := True;

                                  If not DoneResults
                                    then
                                      begin
                                        NumPrinted := NumPrinted + 1;

                                        If GrievanceResultsTable.FieldByName('ValuesTransferred').AsBoolean
                                          then Updated := 'X'
                                          else Updated := '';

                                        If (Roundoff(GrievanceResultsTable.FieldByName('EXAmount').AsFloat, 0) > 0)
                                          then EXAmountToDisplay := FormatFloat(NoDecimalDisplay_BlankZero,
                                                                                GrievanceResultsTable.FieldByName('EXAmount').AsFloat)
                                          else
                                            If (Roundoff(GrievanceResultsTable.FieldByName('EXPercent').AsFloat, 0) = 0)
                                              then EXAmountToDisplay := ''
                                              else EXAmountToDisplay := FormatFloat(NoDecimalDisplay_BlankZero,
                                                                                    GrievanceResultsTable.FieldByName('EXPercent').AsFloat) + '%';

                                        If (Deblank(EXAmountToDisplay) <> '')
                                          then EXAmountToDisplay := GrievanceResultsTable.FieldByName('EXGranted').Text + '-' +
                                                                    EXAmountToDisplay;

                                          {FXX06112003-1(2.07c): The name was coming from the Grievance table
                                                                 instead of the SortGrievanceTable.}

                                        If (NumPrinted = 1)
                                          then Print(#9 + Take(14, FieldByName('CurrentName1').Text) +
                                                     #9 + Take(18, ConvertSwisSBLToDashDot(SwisSBLKey)) +
                                                     #9 + Take(12, GetLegalAddressFromTable(SortGrievanceTable)) +
                                                     #9 + FieldByName('PropertyClassCode').Text)
                                          else Print(#9 + #9 + #9 + #9 + #9 + #9);

                                          {CHG10042005-1(2.9.3.2): Add the reduction amount to the report.}

                                        Println(#9 + FormatFloat(CurrencyDisplayNoDollarSign,
                                                                 FieldByName('CurrentTotalValue').AsFloat) +
                                                #9 + FormatFloat(NoDecimalDisplay_BlankZero,
                                                                 FieldByName('PetitTotalValue').AsFloat) +
                                                #9 + Take(10, GrievanceResultsTable.FieldByName('Disposition').Text) +
                                                #9 + Take(10, GrievanceResultsTable.FieldByName('DenialReasonCode').Text) +
                                                #9 + FormatFloat(NoDecimalDisplay_BlankZero,
                                                                 GrievanceResultsTable.FieldByName('TotalValue').AsFloat) +
                                                #9 + FormatFloat(NoDecimalDisplay_BlankZero,
                                                                 FieldByName('ReductionAmount').AsFloat) +
                                                #9 + EXAmountToDisplay +
                                                #9 + Updated);

                                      end;  {If not DoneResults}

                                until DoneResults;

                                  {Results records not yet created for this record.}

                                If (NumPrinted = 0)
                                  then Println(#9 + Take(14, FieldByName('CurrentName1').Text) +
                                               #9 + Take(18, ConvertSwisSBLToDashDot(SwisSBLKey)) +
                                               #9 + Take(12, GetLegalAddressFromTable(SortGrievanceTable)) +
                                               #9 + FieldByName('PropertyClassCode').Text +
                                               #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                                                                FieldByName('CurrentTotalValue').AsFloat) +
                                               #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                                                                FieldByName('PetitTotalValue').AsFloat) +
                                               #9 + 'No Results' +
                                               #9 + 'Recorded');

                              end
                            else Println(#9 + Take(25, FieldByName('CurrentName1').Text) +
                                         #9 + Take(18, ConvertSwisSBLToDashDot(SwisSBLKey)) +
                                         #9 + Take(16, GetLegalAddressFromTable(SortGrievanceTable)) +
                                         #9 + FieldByName('PropertyClassCode').Text);

                        end;  {If GridLineFormat}

                If PrintToExcel
                  then
                    begin
                      Representative := FieldByName('LawyerCode').Text;

                      If (Deblank(Representative) = '')
                        then Representative := 'Pro Se';

                      FrozenStatusStr := '';
                      If FieldByName('Frozen').AsBoolean
                        then FrozenStatusStr := 'Y';

                      If ParcelHasOpenCertiorari(tbCertiorari, FieldByName('SwisSBLKey').AsString)
                        then sOpenCertiorari := 'Y'
                        else sOpenCertiorari := '';

                      _Locate(tbParcels, [sParcelLocateYear, SwisSBLKey], '', [loParseSwisSBLKey]);

                      Writeln(ExtractFile, FieldByName('GrievanceNumber').Text,
                                           FormatExtractField(ConvertSwisSBLToDashDot(FieldByName('SwisSBLKey').Text)),
                                           FormatExtractField(FieldByName('SwisSBLKey').Text),
                                           FormatExtractField(FieldByName('AccountNumber').AsString),
                                           FormatExtractField(GetLegalAddressFromTable(SortGrievanceTable)),
                                           FormatExtractField(FieldByName('CurrentName1').Text),
                                           FormatExtractField(FieldByName('PropertyClassCode').Text),
                                           FormatExtractField(Representative),
                                           FormatExtractField(FieldByName('PetitReason').Text),
                                           FormatExtractField(FieldByName('PetitTotalValue').Text),
                                           FormatExtractField(FieldByName('PetitEXCode1').Text),
                                           FormatExtractField(FieldByName('PetitEXAmount1').Text),
                                           FormatExtractField(FieldByName('PetitEXPercent1').Text),
                                           FormatExtractField(FieldByName('PetitEXCode2').Text),
                                           FormatExtractField(FieldByName('PetitEXAmount2').Text),
                                           FormatExtractField(FieldByName('PetitEXPercent2').Text),
                                           FormatExtractField(FieldByName('PetitEXCode3').Text),
                                           FormatExtractField(FieldByName('PetitEXAmount3').Text),
                                           FormatExtractField(FieldByName('PetitEXPercent3').Text),
                                           FormatExtractField(FieldByName('Decision').Text),
                                           FormatExtractField(FieldByName('DenialReasonCode').AsString),
                                           FormatExtractField(ExtractPlainTextFromRichText(TMemoField(FieldByName('DenialReason')).AsString, True)),
                                           FormatExtractField(FieldByName('CurrentLandValue').Text),
                                           FormatExtractField(FieldByName('CurrentTotalValue').Text),
                                           FormatExtractField(FormatFloat(IntegerEditDisplay, FieldByName('ReducedToAmount').AsFloat)),
                                           FormatExtractField(FormatFloat(IntegerEditDisplay, FieldByName('ReductionAmount').AsFloat)),
                                           FormatExtractField(FrozenStatusStr),
                                           FormatExtractField(sOpenCertiorari),
                                           FormatExtractField(tbParcels.FieldByName('AccountNo').AsString),
                                           FormatExtractField(ConvertSBLOnlyToOldDashDot(tbParcels.FieldByName('RemapOldSBL').AsString,
                                                                                         tbAssessmentYearControl)),
                                           FormatExtractField(tbParcels.FieldByName('AdditionalLots').AsString),
                                           FormatExtractField(FieldByName('Notes').Text));

                    end;  {If PrintToExcel}

                  If (CreateParcelList and
                      (not ParcelListDialog.ParcelExistsInList(SwisSBLKey)))
                    then ParcelListDialog.AddOneParcel(SwisSBLKey);

                    {If there is only one line left to print, then we
                     want to go to the next page.}

                  If (LinesLeft < 5)
                    then NewPage;

                end;  {with SortGrievanceTable do}

        ReportCancelled := ProgressDialog.Cancelled;

      until (Done or Quit or ReportCancelled);

        {FXX06092009-3(2.20.1.1)[D1532]: Print the total reduction at the bottom of the grid.}

      If GridLineFormat
        then
          begin
            Bold := True;
            Println(#9 + #9 + 'Total Reduction' +
                    #9 + #9 + #9 + #9 +
                    #9 + #9 + #9 + #9 + #9 + #9 +
                    #9 + FormatFloat(IntegerDisplay, iTotalReduction) +
                    #9 + #9);
          end;

      ClearTabs;
      SetTab(0.3, pjLeft, 3.0, 0, BoxLineNone, 0);   {Owner}

      Println('');
      Bold := True;
      Println(#9 + 'Grievances Printed = ' + IntToStr(SortGrievanceTable.RecordCount));
      Println(#9 + 'Total Reduction = ' + FormatFloat(IntegerDisplay, iTotalReduction));
      Bold := False;
      PrintGrievanceTotals(Sender, TotalsRec);

    end;  {with Sender as TBaseReport do}

end;  {ReportPrinterPrint}

{===============================================================}
Procedure TGrievanceSummaryReportForm.CloseButtonClick(Sender: TObject);

begin
  Close;
end;

{===================================================================}
Procedure TGrievanceSummaryReportForm.FormClose(    Sender: TObject;
                                  var Action: TCloseAction);

begin
  CloseTablesForForm(Self);
  SelectedGrievanceResultsTypeList.Free;

    {Free up the child window and set the ClosingAForm Boolean to
     true so that we know to delete the tab.}

  Action := caFree;

  GlblClosingAForm := True;
  GlblClosingFormCaption := Caption;

end;  {FormClose}

end.