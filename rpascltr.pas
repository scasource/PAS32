unit Rpascltr;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, DBCtrls, DBTables, DB, Buttons, Grids,
  Wwdbigrd, Wwdbgrid, ExtCtrls, Wwtable, Wwdatsrc, Menus, pastypes,
  GlblCnst,Types, RPFiler, RPBase, RPCanvas, RPrinter, (*Progress, *)RPDefine,
  DBGrids, DBLookup, Mask, TabNotBk, RPMemo, RPDBUtil, RPTXFilr, ComCtrls,
  ExtDlgs, wwriched, wwrichedspell, Word97, OleServer, OleCtnrs;

Type
  TAsmtChangeLetterPrintForm = class(TForm)
    Panel2: TPanel;
    ScrollBox1: TScrollBox;
    ReportPrinter: TReportPrinter;
    ReportFiler: TReportFiler;
    PrintDialog: TPrintDialog;
    CurrentParcelTable: TTable;
    LetterTextDataSource: TDataSource;
    LetterTextTable: TTable;
    PriorAssessmentTable: TTable;
    CurrentAssessmentTable: TTable;
    AssessorOfficeTable: TTable;
    CurrentSwisCodeTable: TTable;
    PriorParcelTable: TTable;
    CurrentParcelClassTable: TTable;
    PriorSwisCodeTable: TTable;
    Notebook: TTabbedNotebook;
    AssmtChangeTypeRadioGroup: TRadioGroup;
    PrintOrderRadioGroup: TRadioGroup;
    Label21: TLabel;
    RollSectionListBox: TListBox;
    GroupBox1: TGroupBox;
    ResPercentCheckBox: TCheckBox;
    LetterHeadCheckBox: TCheckBox;
    Label5: TLabel;
    NumBlankLettersEdit: TEdit;
    Label7: TLabel;
    DatePrintedEdit: TMaskEdit;
    PrintLetterBodyBoldCheckBox: TCheckBox;
    LetterTextTableMainCode: TStringField;
    LetterTextTableLetterText: TMemoField;
    PriorParcelClassTable: TTable;
    SortTable: TTable;
    SummaryReportFiler: TReportFiler;
    SummaryReportPrinter: TReportPrinter;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    PrintInactiveParcelsCheckBox: TCheckBox;
    ReportTypeRadioGroup: TRadioGroup;
    AssessmentLetterTextTable: TTable;
    SignatureGroupBox: TGroupBox;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    SignatureFileSpeedButton: TSpeedButton;
    WidthLabel: TLabel;
    Label13: TLabel;
    SignatureXPosEdit: TEdit;
    SignatureYPosEdit: TEdit;
    SignatureFileNameEdit: TEdit;
    SignatureWidthEdit: TEdit;
    SignatureHeightEdit: TEdit;
    Label3: TLabel;
    SwisCodeListBox: TListBox;
    PartialAssessmentGroupBox: TGroupBox;
    PartialAssessmentEditLine1: TEdit;
    PartialAssessmentEditLine2: TEdit;
    SignatureOpenDialog: TOpenPictureDialog;
    EditStartingParcelID: TEdit;
    Label1: TLabel;
    PrintBlanksOnlyCheckBox: TCheckBox;
    PrintAccountNumberCheckBox: TCheckBox;
    LoadFromParcelListCheckBox: TCheckBox;
    AssessmentLetterTextTableTaxRollYr: TStringField;
    AssessmentLetterTextTableSwisSBLKey: TStringField;
    AssessmentLetterTextTableNote: TMemoField;
    Label4: TLabel;
    PropertyDescriptionLinesEdit: TEdit;
    LetterTextPageControl: TPageControl;
    RegularLetterTabSheet: TTabSheet;
    Label2: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label22: TLabel;
    Label16: TLabel;
    Label23: TLabel;
    LetterTextDBGrid: TDBGrid;
    DBNavigator1: TDBNavigator;
    LetterCodeDBEdit: TDBEdit;
    MirrorLetterCodeEdit: TEdit;
    LetterTextDBMemo: TwwDBRichEditMSWord;
    WordTabSheet: TTabSheet;
    MergeFieldsAvailableTable: TTable;
    MergeLetterTable: TwwTable;
    MergeLetterDataSource: TwwDataSource;
    WordDocument: TWordDocument;
    WordApplication: TWordApplication;
    MergeLetterDefinitionsTable: TwwTable;
    OLEItemNameTimer: TTimer;
    Panel3: TPanel;
    CloseButton: TBitBtn;
    PrintButton: TBitBtn;
    LoadButton: TBitBtn;
    SaveOptionsButton: TBitBtn;
    Panel4: TPanel;
    Panel5: TPanel;
    MergeFieldsUsedListBox: TListBox;
    Panel6: TPanel;
    Label15: TLabel;
    Panel7: TPanel;
    LetterFileNameLabel: TDBText;
    Panel8: TPanel;
    LetterOleContainer: TOleContainer;
    Panel9: TPanel;
    Label6: TLabel;
    Panel10: TPanel;
    RemoveLetterButton: TBitBtn;
    NewLetterButton: TBitBtn;
    UseWordLettersCheckBox: TCheckBox;
    Panel11: TPanel;
    WordMergeletterGrid: TwwDBGrid;
    CompareToHoldValuesCheckBox: TCheckBox;
    tbAssessmentChangeReasons: TTable;
    cbPrintIfHasChangeReason: TCheckBox;
    PriorExemptionTable: TTable;
    CurrentExemptionTable: TTable;

    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure CloseButtonClick(Sender: TObject);
    procedure ReportFilerPrintHeader(Sender: TObject);
    procedure PrintButtonClick(Sender: TObject);
    procedure ReportPrinterPrint(Sender: TObject);
    procedure SummaryReportPrint(Sender: TObject);
    procedure LoadButtonClick(Sender: TObject);
    procedure SaveOptionsButtonClick(Sender: TObject);
    procedure SaveButtonClick(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject);
    procedure LetterTextTableBeforePost(DataSet: TDataset);
    procedure SignatureFileSpeedButtonClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure LetterTextDBMemoKeyPress(Sender: TObject; var Key: Char);
    procedure LetterTextDBMemoClick(Sender: TObject);
    procedure LetterOleContainerMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure OLEItemNameTimerTimer(Sender: TObject);
    procedure MergeLetterTableAfterScroll(DataSet: TDataSet);
    procedure SummaryReportPrintHeader(Sender: TObject);
  private
    { Private declarations }

  public
    { Public declarations }
    UnitName : String;
    LettersCancelled : Boolean;
    SelectedSwisCodes,
    SelectedRollSections : TStringList;
    LetterTextCode,
    StartingParcelID,
    PropertyDescriptionLinesToPrint,
    PartialAssessmentLine1,
    PartialAssessmentLine2 : String;
    PrintLetterHead,
    PrintBodyBold,
    PrintResidentialPercentChanges, bPrintIfHasChangeReason : Boolean;
    AssessmentLetterType, PrintOrder, NumBlankLetters : Integer;
    LettersPrinted : LongInt;
    PrintedDate : TDateTime;

    CurrentYear, PriorYear : String;
    CurrentProcessingType, PriorProcessingTYpe : Integer;
    StartingParcelSBLRec : SBLRecord;

    NumPrintedThisSwisCode,
    NumPrintedGrandTotal : LongInt;
    InactiveParcelTotal,
    ChangeThisSwisCode,
    ChangeGrandTotal : Comp;
    PrintInactiveParcels : Boolean;
    SignatureFile : String;
    SignatureXPos, SignatureYPos,
    SignatureHeight, SignatureWidth : Double;
    SignatureImage : TImage;
    OrigSortFileName : String;
    PrintBlanksOnly, LoadFromParcelList, PrintAccountNumber : Boolean;

    MergeFieldsToPrint : TStringList;
    UseWordLetterTemplate : Boolean;
    InitializingForm, CompareToHoldValues : Boolean;
    ReportType : Integer;

    Procedure InitializeForm;  {Open the tables and setup.}

    Function ValidSelections : Boolean;

    Procedure FillSortFiles(var Quit : Boolean);

    Function ParcelGetsAVChangeLetter(var PriorHstdAssessedValue,
                                          CurrentHstdAssessedValue,
                                          PriorNonhstdAssessedValue,
                                          CurrentNonhstdAssessedValue : Comp;
                                      var PriorResidentialPercent,
                                          CurrentResidentialPercent : Real;
                                      var PriorRollSection,
                                          CurrentRollSection,
                                          PriorHomesteadCode,
                                          CurrentHomesteadCode : String;
                                      var PartialAssessment : Boolean) : Boolean;
    {A parcel gets a letter if:
       1. The residential percent changes.
       2. The homestead code changes.
       3. The assessed value changes.
       4. The parcel goes from wholly exempt to taxable.}

    Function ParcelGetsExStatusChangeLetter(SwisSBLKey : String) : Boolean;

    Function VillageIsNonAssessingUnit(SwisCode : String) : Boolean;

    Procedure PrintOneLetter(Sender : TObject;
                             SwisSBLKey : String;
                             SchoolCode : String;
                             NAddrArray : NameAddrArray;
                             PriorHstdAssessedValue,
                             CurrentHstdAssessedValue,
                             PriorNonhstdAssessedValue,
                             CurrentNonhstdAssessedValue : Comp;
                             PriorResidentialPercent,
                             CurrentResidentialPercent : Real;
                             PriorRollSection,
                             CurrentRollSection,
                             PriorHomesteadCode,
                             CurrentHomesteadCode : String;
                             PartialAssessment,
                             BlankLetter : Boolean);

    Procedure PrintOneWordLetter(var LetterExtractFile : Text;
                                     SwisSBLKey : String;
                                     NAddrArray : NameAddrArray;
                                     PriorHstdAssessedValue,
                                     CurrentHstdAssessedValue,
                                     PriorNonhstdAssessedValue,
                                     CurrentNonhstdAssessedValue : LongInt;
                                     PriorResidentialPercent,
                                     CurrentResidentialPercent : Real;
                                     PriorRollSection,
                                     CurrentRollSection,
                                     PriorHomesteadCode,
                                     CurrentHomesteadCode : String;
                                     PartialAssessment,
                                     BlankLetter : Boolean);

    Procedure PrintWordLetters;

    Procedure PrintOptionsPage(Sender : TObject);

    Procedure InsertSortRecord(SwisSBLKey : String;
                               PriorHstdAssessedValue,
                               CurrentHstdAssessedValue,
                               PriorNonhstdAssessedValue,
                               CurrentNonhstdAssessedValue : Comp;
                               PriorResidentialPercent,
                               CurrentResidentialPercent : Real;
                               PriorRollSection,
                               CurrentRollSection,
                               PriorHomesteadCode,
                               CurrentHomesteadCode : String;
                               PartialAssessment : Boolean);

  end;

{$R *.DFM}

implementation

uses GlblVars, WinUtils, Utilitys,PASUTILS, UTILEXSD, Preview, Prog,
     RptDialg, Prcllist, UtilOLE, UtilEstimatedTaxComputation, DataAccessUnit;

{FXX11052001-5: Increase and decrease options were switched.}

const
  alDecreasesOnly = 1;
  alIncreasesOnly = 0;
  alAllChanges = 2;

  poParcelID = 0;
  poRollSection = 1;
  poZipCode = 2;
  poAlphabetic = 3;
  poAddress_LegalAddressNum = 4;
  poLegalAddressNum_Address = 5;

  rtReport = 0;
  rtAVChangeLetters = 1;
  rtStatusChangeLetters = 2;
  rtBoth = 3;

  TrialRun = False;

{========================================================}
Procedure TAsmtChangeLetterPrintForm.FormActivate(Sender: TObject);

begin
  SetFormStateMaximized(Self);
end;

{========================================================}
Procedure TAsmtChangeLetterPrintForm.InitializeForm;

var
  Quit, Done, FirstTimeThrough : Boolean;
  I, TempInt : Integer;

begin
  InitializingForm := True;
  Quit := False;
  LettersCancelled := False;
  UnitName := 'RPASCLTR';  {mmm}
  MergeFieldsToPrint := TStringList.Create;

    {FXX10021997 - MDT - If this is not next year, don't open aCurrent files.}
    {FXX04301999-1: Add westchester logic.}

  If GlblIsWestchesterCounty
    then
      begin
        CurrentYear := GlblNextYear;
        CurrentProcessingType := NextYear;
        PriorYear := GlblThisYear;
        PriorProcessingType := ThisYear;
      end
    else
      begin
        CurrentYear := GlblThisYear;
        CurrentProcessingType := ThisYear;

        If HistoryExists
          then
            begin
              TempInt := StrToInt(GlblThisYear);
              GlblHistYear := IntToStr(TempInt - 1);
              PriorProcessingType := History;
              PriorYear := GlblHistYear;

            end
          else
            begin
              PriorYear := GlblThisYear;
              PriorProcessingType := ThisYear;
            end;

      end;  {else of If GlblIsWestchesterCounty}

  OpenTablesForForm(Self, CurrentProcessingType);

   {open this year file separately as Prior operation, other tables are Current}
   {do this for Prior  parcel rec, assessment rec, and class rec}

  OpenTableForProcessingType(PriorParcelTable, ParcelTableName,
                             PriorProcessingType, Quit);
  OpenTableForProcessingType(PriorExemptionTable, ExemptionsTableName,
                             PriorProcessingType, Quit);
  OpenTableForProcessingType(PriorAssessmentTable, AssessmentTableName,
                             PriorProcessingType, Quit);
  OpenTableForProcessingType(PriorParcelClassTable, ClassTableName,
                             PriorProcessingType, Quit);
  OpenTableForProcessingType(PriorSwisCodeTable, SwisCodeTableName,
                             PriorProcessingType, Quit);

    {Fill in the swis code list.}

  Done := False;
  FirstTimeThrough := True;
  CurrentSwisCodeTable.First;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else
        try
          CurrentSwisCodeTable.Next;
        except
          SystemSupport(005, CurrentSwisCodeTable, 'Error locating record ',
                        UnitName, GlblErrorDlgBox);
          Abort;
          Done := True;
        end;

    If CurrentSwisCodeTable.EOF
      then Done := True;

    If not Done
      then
        with CurrentSwisCodeTable do
          SwisCodeListBox.Items.Add(FieldByName('SwisCode').Text + ' - ' +
                                    Take(15, FieldByName('MunicipalityName').Text));

  until Done;

    {Default to all swis codes.}

  For I := 0 to (SwisCodeListBox.Items.Count - 1) do
    SwisCodeListBox.Selected[I] := True;

    {Default to all roll sections.}

  For I := 0 to (RollSectionListBox.Items.Count - 1) do
    RollSectionListBox.Selected[I] := True;

    {Default date to today.}

  DatePrintedEdit.Text := DateToStr(Date);
  OrigSortFileName := SortTable.TableName;

    {FXX02032004-1(2.07l): Make sure that not having the Word merge table does not cause a problem.}

  try
    MergeLetterTable.TableName := MergeLetterCodesTableName;
    MergeFieldsAvailableTable.TableName := MergeFieldsAvailableTableName;
    MergeLetterDefinitionsTable.TableName := MergeLetterFieldsTableName;

    MergeLetterTable.Open;
    MergeFieldsAvailableTable.Open;
    MergeLetterDefinitionsTable.Open;

    If (MergeLetterTable.RecordCount > 0)
      then OLEItemNameTimer.Enabled := True;

    MergeLetterTable.IndexName := 'BYLetterName';

    InitializingForm := False;

    MergeLetterTableAfterScroll(nil);
  except
    MergeLetterTable.TableName := '';
    MergeFieldsAvailableTable.TableName := '';
    MergeLetterDefinitionsTable.TableName := '';
    WordTabSheet.TabVisible := False;
  end;

end;  {InitializeForm}

{===================================================================}
Procedure TAsmtChangeLetterPrintForm.FormKeyPress(    Sender: TObject;
                                                  var Key: Char);

{FXX02292000-2: Don't make Enter move to next control in letter edit.}

begin
  If ((Key = #13) and
      (Screen.ActiveControl.Name <> 'LetterTextDBMemo'))
    then
      begin
        Key := #0;
        Perform(WM_NEXTDLGCTL, 0, 0);
      end;

end;  {FormKeyPress}

{================================================================}
Procedure TAsmtChangeLetterPrintForm.FormKeyDown(    Sender: TObject;
                                                 var Key: Word;
                                                     Shift: TShiftState);
{If they press F2 anywhere on the letter tab, bring up the edit memo.}

begin
  If ((Key = VK_F2) and
      (Notebook.PageIndex = 1) and
      (LetterTextTable.RecordCount > 0))
    then LetterTextDBMemo.Execute;

end;  {FormKeyDown}

{================================================================}
Procedure TAsmtChangeLetterPrintForm.LetterTextDBMemoKeyPress(    Sender: TObject;
                                                              var Key: Char);

{If they press any key in the memo box, bring up the edit memo.}

begin
  If (LetterTextTable.RecordCount > 0)
    then
      begin
        Key := #0;
        LetterTextDBMemo.Execute;
      end;

end;  {LetterTextDBMemoKeyPress}

{================================================================}
Procedure TAsmtChangeLetterPrintForm.LetterTextDBMemoClick(Sender: TObject);

{If they click or double click in the memo, bring up the edit memo.}

begin
  If (LetterTextTable.RecordCount > 0)
    then
      begin
        LetterTextDBMemo.Execute;

          {FXX04232009-4(2.20.1.1)[D210]: Automatically save the letter changes.}

        If (LetterTextTable.State = dsEdit)
          then LetterTextTable.Post;

      end;  {If (LetterTextTable.RecordCount > 0)}

end;  {LetterTextDBMemoClick}

{================================================================}
Procedure TAsmtChangeLetterPrintForm.SignatureFileSpeedButtonClick(Sender: TObject);

begin
  If SignatureOpenDialog.Execute
    then SignatureFileNameEdit.Text := SignatureOpenDialog.FileName;
end;

{====================================================================}
Procedure TAsmtChangeLetterPrintForm.SaveOptionsButtonClick(Sender: TObject);

{FXX04091999-8: Add ability to save and load search report options.}
{FXX03302000-3: Make sure they don't think this is the button to save
                the letter options.}

begin
    {FXX05012000-4: The save\load options does not work for data aware components,
                    so we will trick it by having a mirror edit the contains the
                    letter text code and can be used to relocate to the correct
                    letter.}

  MirrorLetterCodeEdit.Text := LetterTextTable.FieldByName('MainCode').Text;

  If (MessageDlg('Please note that this saves the report options for use again,' + #13 +
                 'but does not save changes to the letter.' + #13 +
                 'If you want to save changes to the letter,' + #13 +
                 'please click the check on the Letter page.' + #13 +
                 'Do you want to proceed with saving the report options?',
                 mtConfirmation, [mbYes, mbNo], 0) = idYes)
    then SaveReportOptions(Self, OpenDialog, SaveDialog, 'avchgltr.cgl', 'Assessment Change Letter Report');

end;  {SaveButtonClick}

{====================================================================}
Procedure TAsmtChangeLetterPrintForm.LoadButtonClick(Sender: TObject);

{FXX04091999-8: Add ability to save and load search report options.}

begin
  LoadReportOptions(Self, OpenDialog, 'avchgltr.cgl', 'Assessment Change Letter Report');

    {FXX05012000-4: The save\load options does not work for data aware components,
                    so we will trick it by having a mirror edit the contains the
                    letter text code and can be used to relocate to the correct
                    letter.}

  FindKeyOld(LetterTextTable, ['MainCode'], [MirrorLetterCodeEdit.Text]);

end;  {LoadButtonClick}

{==========================================================================}
Function TAsmtChangeLetterPrintForm.ValidSelections : Boolean;

{See what options they selected.}

var
  I : Integer;
  ValidEntry : Boolean;

begin
  Result := True;

  with SwisCodeListBox do
    For I := 0 to (Items.Count - 1) do
      If Selected[I]
        then SelectedSwisCodes.Add(Take(6, Items[I]));

  with RollSectionListBox do
    For I := 0 to (Items.Count - 1) do
      If Selected[I]
        then SelectedRollSections.Add(Take(1, Items[I]));

  LetterTextCode := LetterTextTable.FieldByName('MainCode').Text;

  StartingParcelID := EditStartingParcelID.Text;

  PrintLetterHead := LetterHeadCheckBox.Checked;
  PrintResidentialPercentChanges := ResPercentCheckBox.Checked;
  AssessmentLetterType := AssmtChangeTypeRadioGroup.ItemIndex;
  PrintOrder := PrintOrderRadioGroup.ItemIndex;

  try
    NumBlankLetters := StrToInt(NumBlankLettersEdit.Text);
  except
    NumBlankLetters := 0;
  end;

  try
    PrintedDate := StrToDate(DatePrintedEdit.Text);
  except
    Result := False;
    MessageDlg('Please enter a valid printed date.', mtInformation, [mbOK], 0);
  end;

  If (Result and
      (Deblank(StartingParcelID) <> ''))
    then
      begin
        StartingParcelSBLRec := ExtractSwisSBLFromSwisSBLKey(ConvertSwisDashDotToSwisSBL(EditStartingParcelID.Text,
                                                             CurrentSwisCodeTable,
                                                             ValidEntry));

        If not ValidEntry
          then Result := False;

      end;  {If Result}

end;  {ValidSelections}

{==========================================================================}
Procedure TAsmtChangeLetterPrintForm.SaveButtonClick(Sender: TObject);

begin
  If (LetterTextTable.State in [dsEdit, dsInsert])
    then LetterTextTable.Post;

end;  {SaveButtonClick}

{==========================================================================}
Procedure TAsmtChangeLetterPrintForm.CancelButtonClick(Sender: TObject);

begin
  If (LetterTextTable.State in [dsEdit, dsInsert])
    then LetterTextTable.Cancel;

end;  {CancelButtonClick}

{==========================================================================}
Procedure TAsmtChangeLetterPrintForm.LetterTextTableBeforePost(DataSet: TDataset);

{FXX09071999-3: Allow full access to letters from all places.}

begin
  If (Deblank(LetterTextTable.FieldByName('MainCode').Text) = '')
    then
      begin
        MessageDlg('Please enter a name for this new letter on the letter text page.',
                   mtError, [mbOK], 0);
        Abort;
      end;

end;  {LetterTextTableBeforePost}

{========================================================================}
Procedure TAsmtChangeLetterPrintForm.MergeLetterTableAfterScroll(DataSet: TDataSet);

var
  TemplateName : OLEVariant;

begin
  If not InitializingForm
    then
      begin
        TemplateName := MergeLetterTable.FieldByName('FileName').Text;

          {FXX07252002-2: Make sure to have a try..except around the container create.}

        If (_Compare(MergeLetterTable.FieldByName('LetterName').AsString, coNotBlank) and
            FileExists(MergeLetterTable.FieldByName('LetterName').AsString))
          then
            begin
              try
                LetterOLEContainer.CreateObjectFromFile(TemplateName, False);
              except
                LetterOLEContainer.DestroyObject;
                LetterOLEContainer.SizeMode := smClip;
                LetterOLEContainer.CreateObjectFromFile(TemplateName, False);

              end;

            end;  {If (_Compare(MergeLetterTable...}

        SetRangeOld(MergeLetterDefinitionsTable, ['LetterName'],
                    [MergeLetterTable.FieldByName('LetterName').Text],
                    [MergeLetterTable.FieldByName('LetterName').Text]);

        FillOneListBox(MergeFieldsUsedListBox,
                       MergeLetterDefinitionsTable,
                       'MergeFieldName',
                       '', 0, False, False,
                       NoProcessingType, '');

      end;  {If not InitializingForm}

end;  {MergeLetterTableAfterScroll}

{======================================================================}
Procedure TAsmtChangeLetterPrintForm.OLEItemNameTimerTimer(Sender: TObject);

begin
  If GlblApplicationIsActive
    then
      begin
        OLEItemNameTimer.Enabled := False;
        MergeLetterTableAfterScroll(MergeLetterTable);
      end
    else
      If (MergeLetterTable.State in [dsEdit, dsInsert])
        then
          try
            MergeLetterTable.FieldByName('FileName').Text := WordDocument.FullName;
          except
          end;

end;  {OLEItemNameTimerTimer}

{======================================================================}
Procedure TAsmtChangeLetterPrintForm.LetterOleContainerMouseDown(Sender: TObject;
                                                                 Button: TMouseButton;
                                                                 Shift: TShiftState;
                                                                 X, Y: Integer);

{Bring up the document for editing.}

var
  FileName : OLEVariant;

begin
  FileName := MergeLetterTable.FieldByName('FileName').Text;

  try
    LetterOLEContainer.DestroyObject;
  except
  end;

  OpenWordDocument(WordApplication, WordDocument, FileName);

end;  {LetterOleContainerMouseDown}

{============================================================================}
Function TAsmtChangeLetterPrintForm.ParcelGetsAVChangeLetter(var PriorHstdAssessedValue,
                                                                 CurrentHstdAssessedValue,
                                                                 PriorNonhstdAssessedValue,
                                                                 CurrentNonhstdAssessedValue : Comp;
                                                             var PriorResidentialPercent,
                                                                 CurrentResidentialPercent : Real;
                                                             var PriorRollSection,
                                                                 CurrentRollSection,
                                                                 PriorHomesteadCode,
                                                                 CurrentHomesteadCode : String;
                                                             var PartialAssessment : Boolean) : Boolean;

{A parcel gets a letter if:
   1. The residential percent changes.
   2. The homestead code changes.
   3. The assessed value changes.
   4. The parcel goes from wholly exempt to taxable.}

var
  FoundPrior,
  PriorAssessmentRecordFound, PriorClassRecordFound,
  CurrentAssessmentRecordFound, CurrentClassRecordFound : Boolean;
  SwisSBLKey : String;
  I : Integer;
  SBLRec : SBLRecord;
  HstdAcres, NonhstdAcres : Real;
  PriorHstdLandVal, PriorNonhstdLandVal,
  CurrentHstdLandVal, CurrentNonhstdLandVal,
  HstdAVChange, NonhstdAVChange : Comp;
  PriorActiveFlag, CurrentActiveFlag, sCurrentAssessmentChangeReason : String;

begin
  SwisSBLKey := ExtractSSKey(CurrentParcelTable);
  Result := False;
  PriorAssessmentRecordFound := False;
  PartialAssessment := False;

  PriorHstdAssessedValue := 0;
  PriorNonhstdAssessedValue := 0;
  PriorResidentialPercent := 0;
  PriorRollSection := ' ';
  PriorHomesteadCode := ' ';

    {First see the parcel is in the roll sections they selected.}

  CurrentRollSection := CurrentParcelTable.FieldByName('RollSection').Text;
  CurrentHomesteadCode := CurrentParcelTable.FieldByName('HomesteadCode').Text;
  CurrentResidentialPercent := CurrentParcelTable.FieldByName('ResidentialPercent').AsFloat;

    {FXX06011999-1: If the current and prior parcel is inactive, no change flag.}

  CurrentActiveFlag := CurrentParcelTable.FieldByName('ActiveFlag').Text;

  For I := 0 to (SelectedRollSections.Count - 1) do
    If (CurrentRollSection = SelectedRollSections[I])
      then Result := True;

    {FXX06012000-1: Not looking at selected swis codes.}

  If Result
    then
      begin
        Result := False;

        For I := 0 to (SelectedSwisCodes.Count - 1) do
          If (Take(6, SwisSBLKey) = SelectedSwisCodes[I])
            then Result := True;

      end;  {If Result}

  If Result
    then
      begin
        Result := False;

        SBLRec := ExtractSwisSBLFromSwisSBLKey(SwisSBLKey);

          {FXX05031999-4: Was the prior found?}

        with SBLRec do
          FoundPrior := FindKeyOld(PriorParcelTable,
                                   ['TaxRollYr', 'SwisCode', 'Section',
                                    'Subsection', 'Block', 'Lot', 'Sublot',
                                    'Suffix'],
                                   [PriorYear, SwisCode, Section,
                                    Subsection, Block, Lot,
                                    Sublot, Suffix]);

        If (HistoryExists or
            GlblIsWestchesterCounty)
          then
            begin
              If FoundPrior
                then
                  begin
                    CalculateHstdAndNonhstdAmounts(PriorYear, SwisSBLKey,
                                                   PriorAssessmentTable, PriorParcelClassTable,
                                                   PriorParcelTable,
                                                   PriorHstdAssessedValue,
                                                   PriorNonhstdAssessedValue,
                                                   PriorHstdLandVal,
                                                   PriorNonhstdLandVal,
                                                   HstdAcres, NonhstdAcres,
                                                   PriorAssessmentRecordFound,
                                                   PriorClassRecordFound);

                      {CHG05312005-1(2.8.4.7): Option to compare against the hold values in case there were any court changes.}

                    If (CompareToHoldValues and
                        _Compare(PriorParcelTable.FieldByName('HomesteadCode').Text, 'S', coNotEqual))
                      then
                        begin
                          PriorHstdAssessedValue := 0;
                          PriorNonhstdAssessedValue := 0;
                          PriorHstdLandVal := 0;
                          PriorNonhstdLandVal := 0;

                          with PriorAssessmentTable do
                            If _Compare(PriorParcelTable.FieldByName('HomesteadCode').Text, 'H', coMatchesOrFirstItemBlank)
                              then PriorHstdAssessedValue := FieldByName('HoldPriorValue').AsInteger
                              else PriorNonhstdAssessedValue := FieldByName('HoldPriorValue').AsInteger;

                        end;  {If CompareToHoldValues}

                    PriorRollSection := PriorParcelTable.FieldByName('RollSection').Text;
                    PriorHomesteadCode := PriorParcelTable.FieldByName('HomesteadCode').Text;
                    PriorResidentialPercent := PriorParcelTable.FieldByName('ResidentialPercent').AsFloat;

                    PriorActiveFlag := PriorParcelTable.FieldByName('ActiveFlag').Text;

                  end;  {If FoundPrior}

              PriorAssessmentRecordFound := True;

            end
          else
            begin
                {No history so look up the info in the prior fields of the TY
                 data.}

              PriorRollSection := PriorParcelTable.FieldByName('PriorRollSection').Text;
              PriorHomesteadCode := PriorParcelTable.FieldByName('PriorHomesteadCode').Text;
              PriorResidentialPercent := PriorParcelTable.FieldByName('PriorResPercent').AsFloat;

                {Prior status code is not saved, so assume same.}

              PriorActiveFlag := CurrentActiveFlag;

              FindKeyOld(PriorAssessmentTable,
                         ['TaxRollYr', 'SwisSBLKey'],
                         [PriorYear, SwisSBLKey]);
              FindKeyOld(PriorParcelClassTable,
                         ['TaxRollYr', 'SwisSBLKey'],
                         [PriorYear, SwisSBLKey]);

              case PriorHomesteadCode[1] of
                'S' : begin
                        PriorNonhstdAssessedValue := PriorParcelClassTable.FieldByName('NonhstdPriorTotalVal').AsFloat;
                        PriorHstdAssessedValue := PriorParcelClassTable.FieldByName('HstdPriorTotalVal').AsFloat
                      end;  {Split}

                'N' : PriorNonhstdAssessedValue := PriorAssessmentTable.FieldByName('PriorTotalValue').AsFloat;

                  {Hstd or unclassified.}

                else  PriorHstdAssessedValue := PriorAssessmentTable.FieldByName('PriorTotalValue').AsFloat;

              end;  {case HomesteadCode[1] of}

              PriorAssessmentRecordFound := True;

            end;  {else of If (HistoryExists or ...}

        CalculateHstdAndNonhstdAmounts(CurrentYear, SwisSBLKey,
                                       CurrentAssessmentTable, CurrentParcelClassTable,
                                       CurrentParcelTable,
                                       CurrentHstdAssessedValue,
                                       CurrentNonhstdAssessedValue,
                                       CurrentHstdLandVal,
                                       CurrentNonhstdLandVal,
                                       HstdAcres, NonhstdAcres,
                                       CurrentAssessmentRecordFound,
                                       CurrentClassRecordFound);

        If (CurrentParcelTable.FieldByName('ActiveFlag').Text = InactiveParcelFlag)
          then
            begin
              CurrentHstdAssessedValue := 0;
              CurrentNonhstdAssessedValue := 0;
              CurrentHomesteadCode := ' ';
              CurrentRollSection := ' ';
              CurrentResidentialPercent := 0;

            end  {If (CurrentParcelTable.FieldByName('ActiveFlag').Text}
          else PartialAssessment := CurrentAssessmentTable.FieldByName('PartialAssessment').AsBoolean;

          {FXX06011999-1: If the prior is inactive, set the av to 0.}

        If (PriorActiveFlag = InactiveParcelFlag)
          then
            begin
              PriorHstdAssessedValue := 0;
              PriorNonhstdAssessedValue := 0;
              PriorHomesteadCode := ' ';
              PriorRollSection := ' ';
              PriorResidentialPercent := 0;

            end;  {If (CurrentParcelTable.FieldByName('ActiveFlag').Text}

(*        If ((PriorActiveFlag <> InactiveParcelFlag) and
            (CurrentActiveFlag <> InactiveParcelFlag))
          then *)
            If PriorAssessmentRecordFound
              then
                begin

                    {Check to see if residential percent changed.}

                  If (PrintResidentialPercentChanges and
                      (CurrentResidentialPercent <> PriorResidentialPercent))
                    then Result := True;

                    {Check for av change.}

                  HstdAVChange := CurrentHstdAssessedValue - PriorHstdAssessedValue;
                  NonhstdAVChange := CurrentNonhstdAssessedValue - PriorNonhstdAssessedValue;

                  case AssessmentLetterType of
                    alAllChanges :
                      begin
                        Result := (_Compare(HstdAVChange, 0, coNotEqual) or
                                   _Compare(NonhstdAVChange, 0, coNotEqual));

                          {Check for hstd code change.}

                        If (PriorHomesteadCode <> CurrentHomesteadCode)
                          then Result := True;

                          {Check for taxable status change.}
                          {FXX04301999-2: Also, do for parcel that go from rs 1 to 8.}

                        If (((PriorRollSection = '8') and
                             (CurrentRollSection = '1')) or
                            ((PriorRollSection = '1') and
                             (CurrentRollSection = '8')))
                          then Result := True;

                      end;  {alAllChanges}

                    alDecreasesOnly : Result := (_Compare(HstdAVChange, 0, coLessThan) or
                                                 _Compare(NonhstdAVChange, 0, coLessThan));

                    alIncreasesOnly : Result := (_Compare(HstdAVChange, 0, coGreaterThan) or
                                                 _Compare(NonhstdAVChange, 0, coGreaterThan));

                  end;  {case AssessmentLetterType of}

                end
              else Result := True;  {New parcel - it gets letter.}

      end;  {If Result}

    {CHG06181999-1: Allow users to exclude currently inactive parcels.}

  If (Result and
      (CurrentActiveFlag = InactiveParcelFlag) and
      (not PrintInactiveParcels))
    then Result := False;

    {CHG02102011(2.26.1.38)[I]: Add option to print if there is only a change reason.}

  sCurrentAssessmentChangeReason := CurrentAssessmentTable.FieldByName('OrigCurrYrValCode').AsString;

  If ((not Result) and
      (bPrintIfHasChangeReason and
       _Compare(sCurrentAssessmentChangeReason, coNotBlank)))
  then Result := True;

end;  {ParcelGetsChangeLetter}

{==============================================================================}
Procedure TAsmtChangeLetterPrintForm.InsertSortRecord(SwisSBLKey : String;
                                                      PriorHstdAssessedValue,
                                                      CurrentHstdAssessedValue,
                                                      PriorNonhstdAssessedValue,
                                                      CurrentNonhstdAssessedValue : Comp;
                                                      PriorResidentialPercent,
                                                      CurrentResidentialPercent : Real;
                                                      PriorRollSection,
                                                      CurrentRollSection,
                                                      PriorHomesteadCode,
                                                      CurrentHomesteadCode : String;
                                                      PartialAssessment : Boolean);

{FXX04301999-5: Need to have a report to accompany change letters.}

begin
  with SortTable do
    try
      Insert;
      FieldByName('SwisSBLKey').Text := SwisSBLKey;
      FieldByName('PriorHstdValue').AsFloat := PriorHstdAssessedValue;
      FieldByName('PriorNonhstdValue').AsFloat := PriorNonhstdAssessedValue;
      FieldByName('CurrentHstdValue').AsFloat := CurrentHstdAssessedValue;
      FieldByName('CurrentNonhstdValue').AsFloat := CurrentNonhstdAssessedValue;
      FieldByName('PriorRollSection').Text := PriorRollSection;
      FieldByName('CurrentRollSection').Text := CurrentRollSection;
      FieldByName('PriorResPercent').AsFloat := PriorResidentialPercent;
      FieldByName('CurrentResPercent').AsFloat := CurrentResidentialPercent;
      FieldByName('PriorHomesteadCode').Text := PriorHomesteadCode;
      FieldByName('CurrentHomesteadCode').Text := CurrentHomesteadCode;
      FieldByName('PartialAssessment').AsBoolean := PartialAssessment;

        {CHG04262004-1(2.08): Add owner and legal address to change of assessment report.}

      FieldByName('Owner').Text := CurrentParcelTable.FieldByName('Name1').Text;
      FieldByName('LegalAddress').Text := GetLegalAddressFromTable(CurrentParcelTable);

      Post;
    except
      SystemSupport(020, SortTable, 'Error posting sort record.',
                    UnitName, GlblErrorDlgBox);
    end;

end;  {InsertSortRecord}

{==========================================================================}
Function TAsmtChangeLetterPrintForm.ParcelGetsExStatusChangeLetter(SwisSBLKey : String) : Boolean;

var
  sExemptionCode : String;

begin
  Result := False;

  _SetRange(PriorExemptionTable, [PriorYear, SwisSBLKey, ''], [PriorYear, SwisSBLKey, '99999'], '', []);

  with PriorExemptionTable do
  try
    First;

    while not EOF do
    begin
      sExemptionCode := PriorExemptionTable.FieldByName('ExemptionCode').AsString;

      If not _Locate(CurrentExemptionTable, [CurrentYear, SwisSBLKey, sExemptionCode], '', [])
      then Result := True;

      Next;

    end;  {while not EOF do}

  except
  end;

end;  {ParcelGetsExStatusChangeLetter}

{==========================================================================}
Procedure TAsmtChangeLetterPrintForm.FillSortFiles(var Quit : Boolean);

var
  Cancelled, FirstTimeThrough,
  Done, GetsLetter, PartialAssessment : Boolean;
  PriorHstdAssessedValue, CurrentHstdAssessedValue,
  PriorNonhstdAssessedValue, CurrentNonhstdAssessedValue : Comp;
  PriorResidentialPercent, CurrentResidentialPercent : Real;
  PriorRollSection, CurrentRollSection,
  PriorHomesteadCode, CurrentHomesteadCode : String;
  SwisSBLKey : String;
  NumChangesFound, Index : LongInt;

begin
  Quit := False;
  SwisSBLKey := '';
  NumChangesFound := 0;
  Index := 1;

  PriorResidentialPercent := 0;
  CurrentResidentialPercent := 0;

    {Set the index.}
    {FXX06062002-1: The address should use legal addr int.}


  with CurrentParcelTable do
    case PrintOrder of
      poParcelID : IndexName := ParcelTable_Year_Swis_SBLKey;
      poRollSection : IndexName := 'BYYEAR_RS_SWISSBLKEY';
(*      poZipCode = 2; *)
      poAlphabetic : IndexName := 'BYYEAR_NAME';
      poAddress_LegalAddressNum : IndexName := 'BYYEAR_LEGALADDR_LEGALADDRINT';
      poLegalAddressNum_Address : IndexName := 'BYYEAR_LEGALADDRINT_LEGALADDR';

    end;  {case PrintOrder of}

    {FXX06011999-2: The starting parcel ID did not work.}

  If LoadFromParcelList
    then
      begin
        ParcelListDialog.GetParcel(CurrentParcelTable, Index);
        ProgressDialog.Start(ParcelListDialog.NumItems, True, True);
      end
    else
      begin
        If (Deblank(StartingParcelID) = '')
          then CurrentParcelTable.First
          else
            with StartingParcelSBLRec do
              FindNearestOld(CurrentParcelTable,
                             ['TaxRollYr', 'SwisCode', 'Section',
                              'Subsection', 'Block', 'Lot',
                              'Sublot', 'Suffix'],
                             [CurrentParcelTable.FieldByName('TaxRollYr').Text,
                              SwisCode, Section, Subsection,
                              Block, Lot, Sublot, Suffix]);

        ProgressDialog.Start(GetRecordCount(CurrentParcelTable), True, True);

      end;  {else of If LoadFromParcelList}


  FirstTimeThrough := True;
  Done := False;

    {Set up the tabs for the info.}
  ProgressDialog.UserLabelCaption := 'Filling Sort File';

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else
        If LoadFromParcelList
          then
            begin
              Index := Index + 1;
              ParcelListDialog.GetParcel(CurrentParcelTable, Index);
            end
          else CurrentParcelTable.Next;

    If (CurrentParcelTable.EOF or
        (LoadFromParcelList and
         (Index > ParcelListDialog.NumItems)))
      then Done := True;

    If not Done
      then
        begin
          SwisSBLKey := ExtractSSKey(CurrentParcelTable);

             {FXX10021997 - MDT. Show dash dot format SBL.}
             {FXX11251997-2: Show name if in alpha order.}

          If LoadFromParcelList
            then ProgressDialog.Update(Self, ParcelListDialog.GetParcelID(Index))
            else
              If (PrintOrderRadioGroup.ItemIndex = 0)
                then ProgressDialog.Update(Self, ConvertSwisSBLToDashDot(SwisSBLKey))
                else ProgressDialog.Update(Self, CurrentParcelTable.FieldByName('Name1').Text);

          ProgressDialog.UserLabelCaption := 'Filling Sort File - Num Changes Found = ' + IntToStr(NumChangesFound);


          If _Compare(ReportType, rtAVChangeLetters, coEqual)
          then GetsLetter := ParcelGetsAVChangeLetter(PriorHstdAssessedValue,
                                                       CurrentHstdAssessedValue,
                                                       PriorNonhstdAssessedValue,
                                                       CurrentNonhstdAssessedValue,
                                                       PriorResidentialPercent,
                                                       CurrentResidentialPercent,
                                                       PriorRollSection,
                                                       CurrentRollSection,
                                                       PriorHomesteadCode,
                                                       CurrentHomesteadCode,
                                                       PartialAssessment)
          else GetsLetter := ParcelGetsExStatusChangeLetter(SwisSBLKey);

          If (GetsLetter and
              (not Quit))
            then
              begin
                InsertSortRecord(SwisSBLKey, PriorHstdAssessedValue,
                                 CurrentHstdAssessedValue,
                                 PriorNonhstdAssessedValue,
                                 CurrentNonhstdAssessedValue,
                                 PriorResidentialPercent,
                                 CurrentResidentialPercent,
                                 PriorRollSection,
                                 CurrentRollSection,
                                 PriorHomesteadCode,
                                 CurrentHomesteadCode,
                                 PartialAssessment);
                NumChangesFound := NumChangesFound + 1;

              end;

      end;  {If not Done}

    Cancelled := ProgressDialog.Cancelled;

  until (Done or Cancelled or Quit);

end;  {ReportPrinterPrint}

{==========================================================================}
Procedure TAsmtChangeLetterPrintForm.PrintButtonClick(Sender: TObject);

var
  SortFileName, NewFileName : String;
  Quit, Continue, ShowPrintDialog : Boolean;

begin
  UseWordLetterTemplate := UseWordLettersCheckBox.Checked;
  MergeFieldsToPrint.Assign(MergeFieldsUsedListBox.Items);
  ReportType := ReportTypeRadioGroup.ItemIndex;

  SelectedSwisCodes := TStringList.Create;
  SelectedRollSections := TStringList.Create;
  bPrintIfHasChangeReason := cbPrintIfHasChangeReason.Checked;

    {CHG05312005-1(2.8.4.7): Option to compare against the hold values in case there were any court changes.}

  CompareToHoldValues := CompareToHoldValuesCheckBox.Checked;

  Application.ProcessMessages;

  Quit := False;

    {CHG10121998-1: Add user options for default destination and show vet max msg.}

  SetPrintToScreenDefault(PrintDialog);

    {FXX03302000-2: Make sure that the letter text is saved prior to printing.}

  Continue := True;

  If (LetterTextTable.State in [dsEdit, dsInsert])
    then LetterTextTable.Post;

  ShowPrintDialog := True;

  If (UseWordLetterTemplate and
      _Compare(ReportType, [rtAVChangeLetters, rtStatusChangeLetters], coEqual))
    then ShowPrintDialog := False;

  If (Continue and
      ValidSelections and
      ((ShowPrintDialog and
        PrintDialog.Execute) or
       (not ShowPrintDialog)))
    then
      begin
          {FXX09301998-1: Disable print button after clicking to avoid clicking twice.}

        PrintButton.Enabled := False;
        LettersCancelled := False;
        LettersPrinted := 0;
        PrintBodyBold := PrintLetterBodyBoldCheckBox.Checked;
        PrintInactiveParcels := PrintInactiveParcelsCheckBox.Checked;

          {CHG12262000-1: Let them choose which lines of the property description
                          to print.}

        PropertyDescriptionLinesToPrint := PropertyDescriptionLinesEdit.Text;

          {CHG02292000-1: Signature files}

        SignatureFile := SignatureFileNameEdit.Text;

        try
          SignatureXPos := StrToFloat(SignatureXPosEdit.Text);
        except
          SignatureXPos := 0;
        end;

        try
          SignatureYPos := StrToFloat(SignatureYPosEdit.Text);
        except
          SignatureYPos := 0;
        end;

          {FXX05012000-1: Need height and width for sig files.}

        try
          SignatureHeight := StrToFloat(SignatureHeightEdit.Text);
        except
          SignatureHeight := 0.5;
        end;

        try
          SignatureWidth := StrToFloat(SignatureWidthEdit.Text);
        except
          SignatureWidth := 2.25;
        end;

          {CHG05292000-1: Partial assessment text.}

        PartialAssessmentLine1 := PartialAssessmentEditLine1.Text;
        PartialAssessmentLine2 := PartialAssessmentEditLine2.Text;

        If (Deblank(SignatureFile) <> '')
          then
            begin
              SignatureImage := TImage.Create(nil);
              SignatureImage.Picture.LoadFromFile(SignatureFile);
            end;

          {CHG05062001-1: Add ability to print blanks only, load from the parcel list,
                          and suppress the account number.}

        PrintBlanksOnly := PrintBlanksOnlyCheckBox.Checked;
        LoadFromParcelList := LoadFromParcelListCheckBox.Checked;
        PrintAccountNumber := PrintAccountNumberCheckBox.Checked;

          {CHG10131998-1: Set the printer settings based on what printer they selected
                          only - they no longer need to worry about paper or landscape
                          mode.}

        AssignPrinterSettings(PrintDialog, ReportPrinter, ReportFiler, [ptLaser], False, Quit);
        AssignPrinterSettings(PrintDialog, SummaryReportPrinter, SummaryReportFiler, [ptLaser], False, Quit);

          {FXX04301999-5: Need to have a report to accompany change letters.}

        CopyAndOpenSortFile(SortTable, 'AssessmentChangeLetters',
                            OrigSortFileName, SortFileName,
                            True, True, Quit);

          {FXX12161999-1: Sort the files first and run the letters off the sort file
                          so that we can print the report first.}

        If not PrintBlanksOnly
          then FillSortFiles(Quit);

        OpenTableForProcessingType(AssessmentLetterTextTable, AssessmentLetterTextTableName,
                                   CurrentProcessingType, Quit);

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

           {Do the report.}

        If ((not Quit) and
            (ReportType in [rtReport, rtBoth]))
          then
            begin
              AssignPrinterSettings(PrintDialog, ReportPrinter, ReportFiler, [ptBoth], True, Quit);

              If (ReportPrinter.Orientation = poLandscape)
                then
                  If (MessageDlg('Do you want to print on letter size paper?',
                                 mtConfirmation, [mbYes, mbNo], 0) = idYes)
                    then
                      begin
                        ReportPrinter.SetPaperSize(dmPaper_Letter, 0, 0);
                        ReportFiler.SetPaperSize(dmPaper_Letter, 0, 0);
                        ReportPrinter.Orientation := poLandscape;
                        ReportFiler.Orientation := poLandscape;

                        If (ReportPrinter.SupportDuplex and
                            (MessageDlg('Do you want to print on both sides of the paper?',
                                        mtConfirmation, [mbYes, mbNo], 0) = idYes))
                          then
                            If (MessageDlg('Do you want to vertically duplex this report?',
                                            mtConfirmation, [mbYes, mbNo], 0) = idYes)
                              then ReportPrinter.Duplex := dupVertical
                              else ReportPrinter.Duplex := dupHorizontal;

                        ReportPrinter.ScaleX := 92;
                        ReportPrinter.ScaleY := 90;
                        ReportPrinter.SectionLeft := 1.5;
                        ReportFiler.ScaleX := 92;
                        ReportFiler.ScaleY := 90;
                        ReportFiler.SectionLeft := 1.5;

                      end;  {If (MessageDlg('Do you want to...}

              ProgressDialog.StartPrinting(PrintDialog.PrintToFile);

                {If they want to see it on the screen, start the preview.}

              If PrintDialog.PrintToFile
                then
                  begin
                    GlblPreviewPrint := True;
                    NewFileName := GetPrintFileName(Self.Caption, True);
                    SummaryReportFiler.FileName := NewFileName;

                    try
                      PreviewForm := TPreviewForm.Create(self);
                      PreviewForm.FilePrinter.FileName := NewFileName;
                      PreviewForm.FilePreview.FileName := NewFileName;

                      PreviewForm.FilePreview.ZoomFactor := 130;

                      SummaryReportFiler.Execute;
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

                    ShowReportDialog('AVCHGLTR.RPT', NewFileName, True);
                  end
                else SummaryReportPrinter.Execute;

            end;  {If ((not Quit) and ...}

          {Now do the letters.}

        If (ReportType in [rtAVChangeLetters, rtStatusChangeLetters, rtBoth])
          then
            begin
                {FXX06022008-1(2.13.1.7)[1275]: The letters print out in landscape if the report
                                                is printed first.}
                                                 
              AssignPrinterSettings(PrintDialog, ReportPrinter, ReportFiler, [ptBoth], False, Quit);

              LettersCancelled := False;
              If (ReportType = rtBoth)
                then MessageDlg('Please press OK to start printing the letters.',
                                mtInformation, [mbOK], 0);

              If UseWordLetterTemplate
                then PrintWordLetters
                else
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
                            PreviewForm.ShowModal;
                          finally
                            PreviewForm.Free;

                              {CHG01182000-3: Allow them to choose a different name or copy right away.}
                              {However, we can only do it if they print to screen first since
                               report printer does not generate a file.}

                            ShowReportDialog('AVCHGLTR.LTR', ReportFiler.FileName, True);

                          end;  {If PrintRangeDlg.PreviewPrint}

                        end  {They did not select preview, so we will go
                              right to the printer.}
                      else ReportPrinter.Execute;

                    ResetPrinter(ReportPrinter);

                  end;  {else of If UseWordLetterTemplate}

            end;  {If ((not Quit) and ...}

        ProgressDialog.Finish;

          {Make sure to close and delete the sort file.}

        SortTable.Close;

          {Now delete the file.}
        try
          ChDir(GlblDataDir);
          OldDeleteFile(SortFileName);
        finally
          {We don't care if it does not get deleted, so we won't put up an
           error message.}

          ChDir(GlblProgramDir);
        end;

          {FXX06181999-5: Put up a dialog box with amounts.}

        MessageDlg('There were ' + IntToStr(NumPrintedGrandTotal) + ' letters printed with' + #13 +
                   ' a total change of ' + FormatFloat(CurrencyNormalDisplay, ChangeGrandTotal) + '.',
                   mtInformation, [mbOK], 0);

          {CHG02292000-1: Signature files}

        If (Deblank(SignatureFile) <> '')
          then SignatureImage.Free;

      end;  {If PrintDialog.Execute}

  SelectedSwisCodes.Free;
  SelectedRollSections.Free;
  PrintButton.Enabled := True;

end;   {PrintButtonClick}

{=================================================================}
Procedure TAsmtChangeLetterPrintForm.ReportFilerPrintHeader(Sender: TObject);

var
  NAddrArray : NameAddrArray;

begin
    {FXX11021998-2: Remove fudge factor and copy letter changes from other
                    letters.}

  GetNameAddress(CurrentParcelTable, NAddrArray);

  PrintLetterHeader(Sender, AssessorOfficeTable, NAddrArray,
                    PrintLetterHead, PrintedDate, False);

end;  {ReportFilerPrintHeader}

{============================================================================}
Function TAsmtChangeLetterPrintForm.VillageIsNonAssessingUnit(SwisCode : String) : Boolean;

var
  Found : Boolean;

begin
  Result := False;
  Found := FindKeyOld(CurrentSwisCodeTable, ['SwisCode'], [SwisCode]);

  If Found
    then
      Result := not CurrentSwisCodeTable.FieldByName('AssessingVillage').AsBoolean;

end;  {VillageIsNonAssessingUnit}

{=======================================================================}
Procedure TAsmtChangeLetterPrintForm.PrintOptionsPage(Sender : TObject);

begin
  with Sender as TBaseReport do
    begin
      Newpage;
      ClearTabs;
      SetTab(1.0, pjLeft, 3.5, 0, BOXLINENONE, 0);   {labels}

      If LettersCancelled
        then
          begin
            CRLF;
            CRLF;
            CRLF;
            SetFont('Times New Roman', 16);
            Bold := True;
            Println(#9 + '*** PRINT JOB CANCELLED BY USER ***');
          end;  {If LettersCancelled}

      SetFont('Times New Roman', 12);
      Underline := False;
      Bold := True;

      Println('');
      Println(#9 + 'Total Letters Printed: ' + IntToStr(LettersPrinted));
      Println('');
      Println('');
      Println(#9 + 'Print Options Selected:');
      Println('');

      Print(#9 + '     Letter Priorpe: ');

      case AssessmentLetterType of
        alAllChanges : Println('Increases and Decreases.');
        alDecreasesOnly : Println('Decreases Only.');
        alIncreasesOnly : Println('Increases Only.');
      end;  {case AssessmentLetterType of}

      Println('');
      Println(#9 + '     Letter Text Code: ' +
                   LetterTextTable.FieldByName('MainCode').Text);
      Println('');

      Print(#9 + '     Print Order: ');
      case PrintOrder of
        poParcelID : Println('Parcel ID');
        poRollSection : Println('Roll Section \ Parcel ID');
        poZipCode : Println('Zip Code \ Parcel ID');
        poAlphabetic : Println('Alphabetic');
        poAddress_LegalAddressNum : Println('Legal Address \ Legal Addr Num');
        poLegalAddressNum_Address : Println('Legal Addr Num \ Legal Address');
      end;  {case PrintOrder of}

      Println('');

      If PrintLetterHead
        then Println(#9 +  '    PAS Printing Letter Head')
        else Println(#9 +  '    Using Letter Head');

    end;  {with Sender as TBaseReport do}

end;  {PrintOptionsPage}

{=======================================================================}
Function GetHomesteadDescription(HomesteadCode : String) : String;

begin
  case HomesteadCode[1] of
    'S' : Result := 'Combination Homestead\Non-homestead Parcel';
    'H' : Result := 'Homestead Parcel';
    'N' : Result := 'Non-homestead Parcel';
    else Result := 'Undesignated Parcel';

  end;  {case HomesteadCode of}

end;  {GetHomesteadDescription}

{=======================================================================}
Procedure PrintChange(Sender : TObject;
                      PriorHstdAssessedVal,
                      CurrentHstdAssessedVal,
                      PriorNonhstdAssessedVal,
                      CurrentNonhstdAssessedVal : Comp;
                      PriorResidentialPercent,
                      CurrentResidentialPercent : Real;
                      PriorRollSection,
                      CurrentRollSection,
                      PriorHomesteadCode,
                      CurrentHomesteadCode : String;
                      SwisCode : String;
                      PrintResidentialPercentChanges,
                      BlankLetter : Boolean);

{Print the actual change message and the amounts involved.}

var
  TempStr : String;

begin
  with Sender as TBaseReport do
    begin
        {Print aCurrent messages first.}

      ClearTabs;
      SetTab(1.0, pjLeft, 3.5, 0, BOXLINENONE, 0);   {labels}

        {Did the parcel change from wholly exempt to taxable.}

      If ((PriorRollSection = '8') and
          (CurrentRollSection = '1'))
        then
          begin
            Println(#9 + 'This property was changed from wholly exempt to taxable.');
            Println('');
          end;  {If ((PriorRollSection = '8') and ...}

        {Did the parcel change from taxable to wholly exempt?}
        {FXX04301999-2: Print switches from rs 1 to 8.}

      If ((PriorRollSection = '1') and
          (CurrentRollSection = '8'))
        then
          begin
            Println(#9 + 'This property was changed from taxable to wholly exempt.');
            Println('');
          end;  {If ((PriorRollSection = '8') and ...}

        {Did the residential percent change?}

      If (PrintResidentialPercentChanges and
          (Roundoff(PriorResidentialPercent , 0) <>
           Roundoff(CurrentResidentialPercent, 0)))
        then
          begin
            Println(#9 + 'Current year residential percent used for exemptions is ' +
                     FormatFloat(CurrencyDisplayNoDollarSign,
                                 CurrentResidentialPercent) + '%.');
            Println('');
          end;

        {FXX04301999-3: Need to print letters for homestead code changes.}

      If not BlankLetter
        then
          If ((PriorHomesteadCode = CurrentHomesteadCode) or
              (Deblank(PriorHomesteadCode) = '') and  {Parcel did not exist previously.}
               (Roundoff((PriorHstdAssessedVal + PriorNonHstdAssessedVal), 0) = 0))
            then
              begin
                  {If there is no change, print out the current homestead code
                   of this parcel, but not if not a classified munic.}

                If GlblMunicipalityIsClassified
                  then
                    begin
                      Println(#9 + 'This parcel is a(n): ' +
                              GetHomesteadDescription(CurrentHomesteadCode));
                      Println('');
                    end;

              end
            else
              begin
                Println(#9 + 'This property has been changed from a(n):');
                Print(#9 + '  ');
                Print(GetHomesteadDescription(PriorHomesteadCode) + ' to a(n) ' +
                      GetHomesteadDescription(CurrentHomesteadCode));
                Println('');
                Println('');

              end;  {If (PriorHomesteadCode <> CurrentHomesteadCode)}

        {Now print the assessed value of Prior and Current.}
        {FXX11021998-2: Also show AV amounts.}
        {CHG11042006-1(2.9.4.7): Don't display $ signs.}

      If (((PriorHstdAssessedVal <> CurrentHstdAssessedVal) or
          (PriorNonhstdAssessedVal <> CurrentNonhstdAssessedVal)) or
          (PrintResidentialPercentChanges and
           (Roundoff(PriorResidentialPercent , 0) <>
            Roundoff(CurrentResidentialPercent, 0))) or
          BlankLetter)
        then
          If ((PriorHomesteadCode = SplitParcel) or
              (CurrentHomesteadCode = SplitParcel))
            then
              begin
                   {FXX04301999-3: Need to have special layout for classified.}

                ClearTabs;
                SetTab(0.3, pjLeft, 3.0, 0, BOXLINENONE, 0);   {labels}
                SetTab(3.4, pjLeft, 1.4, 0, BOXLINENONE, 0);   {hstd}
                SetTab(4.9, pjLeft, 1.4, 0, BOXLINENONE, 0);   {nonhstd}
                SetTab(6.4, pjLeft, 1.4, 0, BOXLINENONE, 0);   {total col}

                Println(#9 + #9 + 'HOMESTEAD' + #9 +
                        'NONHOMESTEAD' + #9 + 'TOTAL');
                Println(#9 + #9 + 'PORTION' + #9 +
                        'PORTION' );

                ClearTabs;
                SetTab(0.3, pjLeft, 3.0, 0, BOXLINENONE, 0);   {labels}
                SetTab(3.4, pjRight, 1.4, 0, BOXLINENONE, 0);   {hstd}
                SetTab(4.9, pjRight, 1.4, 0, BOXLINENONE, 0);   {nonhstd}
                SetTab(6.4, pjRight, 1.4, 0, BOXLINENONE, 0);   {total col}

                Println('');
                Println(#9 + 'PRIOR ASSESSED VALUE: ' +
                        #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                                         PriorHstdAssessedVal) +
                        #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                                         PriorNonhstdAssessedVal) +
                        #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                                         (PriorHstdAssessedVal +
                                          PriorNonhstdAssessedVal)));

                Println('');
                Println(#9 + 'CURRENT YEAR TENTATIVE ASSESSMENT: ' +
                        #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                                         CurrentHstdAssessedVal) +
                        #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                                         CurrentNonhstdAssessedVal) +
                        #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                                         (CurrentHstdAssessedVal +
                                          CurrentNonhstdAssessedVal)));

                Println('');
                Println(#9 + 'NET CHANGE:' + #9 + #9 +
                        #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                                         ((CurrentHstdAssessedVal + CurrentNonhstdAssessedVal) -
                                          (PriorHstdAssessedVal + PriorNonhstdAssessedVal))));

              end
            else
              begin
                  {Non-split parcel changed assessment.}

                ClearTabs;
                SetTab(1.0, pjLeft, 3.5, 0, BOXLINENONE, 0);   {labels}
                SetTab(4.6, pjRight, 1.5, 0, BOXLINENONE, 0);   {hstd}

                If BlankLetter
                  then TempStr := ''
                  else TempStr := FormatFloat(CurrencyDisplayNoDollarSign,
                                              (PriorHstdAssessedVal + PriorNonhstdAssessedVal));
                Println(#9 + 'PRIOR ASSESSED VALUE: ' + #9 +
                        TempStr);

                CRLF;
                If BlankLetter
                  then TempStr := ''
                  else TempStr := FormatFloat(CurrencyDisplayNoDollarSign,
                                             (CurrentHstdAssessedVal + CurrentNonhstdAssessedVal));
                Println(#9 + 'CURRENT YEAR TENTATIVE ASSESSMENT: ' + #9 +
                        TempStr);
                CRLF;

                If BlankLetter
                  then TempStr := ''
                  else TempStr := FormatFloat(CurrencyDisplayNoDollarSign,
                                              ((CurrentHstdAssessedVal + CurrentNonhstdAssessedVal) -
                                               (PriorHstdAssessedVal + PriorNonhstdAssessedVal)));
                Println(#9 + 'NET CHANGE:' + #9 +
                        TempStr);

              end;  {else of If ((PriorHomesteadCode = SplitParcel) or ...}

(*      If VillageIsNonAssessingUnit(SwisCode)
        then
          begin
            Println(#9 + 'This tentative assessment will also apply for ' + TaxRollYear +
                         ' village tax purposes.');
            Println('');
          end; *)

      Println('');

    end;  {with Sender as TBaseReport do}

end;  {PrintChange}

{==============================================================================}
Procedure TAsmtChangeLetterPrintForm.PrintOneLetter(Sender : TObject;
                                                    SwisSBLKey : String;
                                                    SchoolCode : String;
                                                    NAddrArray : NameAddrArray;
                                                    PriorHstdAssessedValue,
                                                    CurrentHstdAssessedValue,
                                                    PriorNonhstdAssessedValue,
                                                    CurrentNonhstdAssessedValue : Comp;
                                                    PriorResidentialPercent,
                                                    CurrentResidentialPercent : Real;
                                                    PriorRollSection,
                                                    CurrentRollSection,
                                                    PriorHomesteadCode,
                                                    CurrentHomesteadCode : String;
                                                    PartialAssessment,
                                                    BlankLetter : Boolean);

var
  PropDescList : TStringList;
  I, OrigPos, NewPos : Integer;
  TempStr : String;
  DBMemoBuf : TDBMemoBuf;
  FoundInsertCommand : Boolean;

begin
  DBMemoBuf := TDBMemoBuf.Create;
  If BlankLetter
    then
      For I := 1 to 6 do
       NAddrArray[I] := '';

  with Sender as TBaseReport do
    begin
        {FXX11021998-2: Remove fudge factor for AV letters.}

      ClearTabs;
      Bold := False;
      SetTab(1.0, pjLeft, 3.5, 0, BOXLINENONE, 0);   {letter addr}
      SetTab(4.6, pjLeft, 3.0, 0, BOXLINENONE, 0);   {letter addr}

        {Print the name and address.}

      GotoXY(1.0, GlblLetterAddressStart);

      Println(#9 + NAddrArray[1] +
              #9 + 'Parcel ID');

      If BlankLetter
        then TempStr := ''
        else TempStr := Copy(SwisSBLKey, 1, 6) + '  ' +
                        ConvertSBLOnlyToDashDot(Copy(SwisSBLKey, 7, 20));
      Println(#9 + NAddrArray[2] +
              #9 + '  ' + TempStr);

       {CHG05062001-1: Add ability to print blanks only, load from the parcel list,
                        and suppress the account number.}

      If (BlankLetter or
          (not PrintAccountNumber))
        then TempStr := ''
        else TempStr := 'Acct #: ' +
                        CurrentParcelTable.FieldByName('AccountNo').Text;
      Println(#9 + NAddrArray[3] +
              #9 + TempStr);

         {On the next lines do parcel location and prop descr.}

      Println(#9 + NAddrArray[4] +
              #9 + 'Location\Description');

      If BlankLetter
        then TempStr := ''
        else TempStr := GetLegalAddressFromTable(CurrentParcelTable);
      Println(#9 + NAddrArray[5] +
              #9 + '  ' + TempStr);

        {Get the property descriptions, leaving out Current
         spaces.}

      PropDescList := TStringList.Create;

      If not BlankLetter
        then
          with CurrentParcelTable do
            begin
                {CHG12262000-1: Let them choose which lines of the property description
                                to print.}

              If ((Pos('1', PropertyDescriptionLinesToPrint) > 0) and
                  (Deblank(FieldByName('PropDescr1').Text) <> ''))
                then PropDescList.Add(FieldByName('PropDescr1').Text);

              If ((Pos('2', PropertyDescriptionLinesToPrint) > 0) and
                  (Deblank(FieldByName('PropDescr2').Text) <> ''))
                then PropDescList.Add(FieldByName('PropDescr2').Text);

              If ((Pos('3', PropertyDescriptionLinesToPrint) > 0) and
                  (Deblank(FieldByName('PropDescr3').Text) <> ''))
                then PropDescList.Add(FieldByName('PropDescr3').Text);

            end;  {with CurrentParcelTable do}

        {Fill in the rest with blanks.}

      For I := (PropDescList.Count + 1) to 3 do
        PropDescList.Add('');

      Println(#9 + NAddrArray[6] +
              #9 + '  ' + PropDescList[0]);
      Println(#9 + #9 + '  ' + PropDescList[1]);
      Println(#9 + #9 + '  ' + PropDescList[2]);

      PropDescList.Free;

      Bold := PrintBodyBold;

      CRLF;

      ClearTabs;
      SetTab(1.0, pjLeft, 3.5, 0, BOXLINENONE, 0);   {letter addr}

        {CHG04172006-1(2.9.6.3): Have different text for taxable status change.}

      If ((_Compare(PriorRollSection, '8', coEqual) and
           _Compare(CurrentRollSection, '1', coEqual)) or
          (_Compare(PriorRollSection, '1', coEqual) and
           _Compare(CurrentRollSection, '8', coEqual)))
        then
          begin
            Println(#9 + 'You are hereby notified in accordance with the requirements of Section 510-A of the');
            Println(#9 + 'Real Property Tax Law that the taxable status of the real property identified');
            Println(#9 + 'above, under your ownership, has been changed as shown below:');
            Println('');
          end
        else
          begin
            Println(#9 + 'You are hereby notified in accordance with the requirements of Section 510 of the');
            Println(#9 + 'Real Property Tax Law that the assessed valuation of the real property identified');
            Println(#9 + 'above, under your ownership, has been adjusted as shown:');
            Println('');
          end;

        {Now print the change message(s).}

      PrintChange(Sender, PriorHstdAssessedValue,
                  CurrentHstdAssessedValue,
                  PriorNonhstdAssessedValue,
                  CurrentNonhstdAssessedValue,
                  PriorResidentialPercent,
                  CurrentResidentialPercent,
                  PriorRollSection,
                  CurrentRollSection,
                  PriorHomesteadCode,
                  CurrentHomesteadCode,
                  Copy(SwisSBLKey, 1, 6),
                  PrintResidentialPercentChanges,
                  BlankLetter);

        {CHG05292000-1: Partial assessment text.}

      If PartialAssessment
        then
          begin
            If (Deblank(PartialAssessmentLine1) <> '')
              then Println(#9 + PartialAssessmentLine1);

            If (Deblank(PartialAssessmentLine2) <> '')
              then Println(#9 + PartialAssessmentLine2);

              {If printed either, then print a blank line.}

            If ((Deblank(PartialAssessmentLine1) <> '') or
                (Deblank(PartialAssessmentLine2) <> ''))
              then Println('');

          end;  {If PartialAssessment}

      ClearTabs;

        {FXX11021998-3: Avoid problem with no carriage returns in letter text.}
        {FXX11021999-13: Allow the letter left margin to be customized.}

      DBMemoBuf.RTFField := LetterTextTableLetterText;
      DBMemoBuf.PrintStart := GlblLetterLeftMargin;
      DBMemoBuf.PrintEnd := 8.2;

        {FXX2292000-1: Insert letter text.  It should be in the form %IThe reason is%I.
                       We will delete the %I's and then insert the text afterwards.}

      FoundInsertCommand := DBMemoBuf.SearchFirst('%I', False);

      If FoundInsertCommand
        then
          If FindKeyOld(AssessmentLetterTextTable,
                        ['TaxRollYr', 'SwisSBLKey'],
                        [CurrentYear, SwisSBLKey])
            then
              begin
(*                TempString := DBMemoBuf.Text;
                MessageDlg(TempString, mtInformation, [mbOK], 0); *)
                DBMemoBuf.Delete(DBMemoBuf.Pos, 2);
                DBMemoBuf.SearchNext;

(*                {$H+}
                TempString := DBMemoBuf.Text;
                MessageDlg(TempString, mtInformation, [mbOK], 0);
                {$H-} *)

                DBMemoBuf.Delete(DBMemoBuf.Pos, 2);
                DBMemoBuf.Insert(DBMemoBuf.Pos, #13 + (*'\b ' + *)AssessmentLetterTextTableNote.Value(* + '\b0'*));
(*                TempString := DBMemoBuf.Text;
                MessageDlg(TempString, mtInformation, [mbOK], 0); *)
                DBMemoBuf.Pos := 0;

              end  {If (AssessmentLetterTextTable.FindKey([CurrentYear, SwisSBLKey]) and ...}
            else
              begin
                DBMemoBuf.Delete(DBMemoBuf.Pos, 2);
                OrigPos := DBMemoBuf.Pos;
                DBMemoBuf.SearchNext;
                NewPos := DBMemoBuf.Pos;
                DBMemoBuf.Delete(OrigPos, (NewPos - OrigPos + 3));  {Also delete 2nd %I%}
                DBMemoBuf.Pos := 0;

              end;  {If AssessmentLetterTextTable.FindKey([CurrentYear, SwisSBLKey])}

      PrintMemo(DBMemoBuf, 0, False);

        {CHG02292000-1: Signature files}
        {FXX05012000-1: Need height and width for sig files.}
        {FXX06042001-2: Wrong variable for width and height}

      If (Deblank(SignatureFile) <> '')
        then PrintBitmapRect(SignatureXPos, SignatureYPos,
                             SignatureXPos + SignatureWidth,
                             SignatureYPos + SignatureHeight,
                             SignatureImage.Picture.Bitmap);

    end;  {with Sender as TBaseReport do}

  DBMemoBuf.Free;

end;  {PrintOneLetter}

{======================================================================}
Procedure AddMergeFieldsToExtractFile(var LetterExtractFile : TextFile;
                                          MergeFieldsToPrint : TStringList;
                                          ParcelTable,
                                          AssessmentLetterTextTable,
                                          MergeFieldsAvailableTable,
                                          AssessmentTable,
                                          tbAssessmentChangeReasons : TTable;
                                          NAddrArray : NameAddrArray;
                                          AssessmentYear : String;
                                          SwisSBLKey : String;
                                          CurrentHstdAssessedValue,
                                          CurrentNonhstdAssessedValue,
                                          PriorHstdAssessedValue,
                                          PriorNonhstdAssessedValue : LongInt;
                                          ParcelDescriptionChange,
                                          PartialAssessmentLine1,
                                          PartialAssessmentLine2 : String;
                                          LetterDate : TDateTime;
                                          BlankLetter : Boolean;
                                          bPartialAssessment : Boolean);

var
  I : Integer;
  MergeFieldName, FieldValue, sChangeReasonCode : String;
  TaxInformationList : TList;

begin
  _Locate(AssessmentTable, [AssessmentYear, SwisSBLKey], '', []);
  
  For I := 0 to (MergeFieldsToPrint.Count - 1) do
    begin
      FieldValue := '';
      FindKeyOld(MergeFieldsAvailableTable, ['MergeFieldName'],
                 [MergeFieldsToPrint[I]]);

      with MergeFieldsAvailableTable do
        begin
          MergeFieldName := FieldByName('MergeFieldName').Text;

          If _Compare(FieldByName('TableName').Text, 'Special', coEqual)
            then
              begin
                If _Compare(MergeFieldName, 'ThisYear', coEqual)
                  then FieldValue := GlblThisYear;

                If _Compare(MergeFieldName, 'NextYear', coEqual)
                  then FieldValue := GlblNextYear;

                If _Compare(MergeFieldName, 'ParcelID', coEqual)
                  then FieldValue := ConvertSwisSBLToDashDot(SwisSBLKey);

                If _Compare(MergeFieldName, 'ParcelID_No_Swis', coEqual)
                  then FieldValue := ConvertSBLOnlyToDashDot(Copy(SwisSBLKey, 7, 20));

                If _Compare(MergeFieldName, 'LegalAddress', coEqual)
                  then FieldValue := GetLegalAddressFromTable(ParcelTable);

                If _Compare(MergeFieldName, 'ParcelChangeDescription', coEqual)
                  then FieldValue := ParcelDescriptionChange;

                If (_Compare(MergeFieldName, 'PartialFlag', coEqual) and
                    bPartialAssessment)
                  then FieldValue := ' (Partial)';

                If _Compare(MergeFieldName, 'PartialAVLine1', coEqual)
                  then FieldValue := PartialAssessmentLine1;

                If _Compare(MergeFieldName, 'PartialAVLine2', coEqual)
                  then FieldValue := PartialAssessmentLine2;

                If _Compare(MergeFieldName, 'Name1', coEqual)
                  then FieldValue := NAddrArray[1];

                If _Compare(MergeFieldName, 'Name2', coEqual)
                  then FieldValue := NAddrArray[2];

                If _Compare(MergeFieldName, 'Address1', coEqual)
                  then FieldValue := NAddrArray[3];

                If _Compare(MergeFieldName, 'Address2', coEqual)
                  then FieldValue := NAddrArray[4];

                If _Compare(MergeFieldName, 'Address3', coEqual)
                  then FieldValue := NAddrArray[5];

                If _Compare(MergeFieldName, 'Address4', coEqual)
                  then FieldValue := NAddrArray[6];

                If _Compare(MergeFieldName, 'LetterDate', coEqual)
                  then FieldValue := DateToStr(LetterDate);

                If _Compare(MergeFieldName, 'PriorValue', coEqual)
                  then FieldValue := FormatFloat(CurrencyNormalDisplay,
                                                 (PriorHstdAssessedValue +
                                                  PriorNonhstdAssessedValue));

                If _Compare(MergeFieldName, 'CurrentValue', coEqual)
                  then FieldValue := FormatFloat(CurrencyNormalDisplay,
                                                 (CurrentHstdAssessedValue +
                                                  CurrentNonhstdAssessedValue));

                If _Compare(MergeFieldName, 'AssessmentChange', coEqual)
                  then FieldValue := FormatFloat(CurrencyNormalDisplay,
                                                 ((CurrentHstdAssessedValue +
                                                   CurrentNonhstdAssessedValue) -
                                                  (PriorHstdAssessedValue +
                                                   PriorNonhstdAssessedValue)));

                  {CHG05182005-1(2.8.4.5): Add the change reason and projected tax.}

                If _Compare(MergeFieldName, 'ChangeReason', coEqual)
                  then
                    If _Locate(AssessmentLetterTextTable, [AssessmentYear, SwisSBLKey], '', [])
                      then FieldValue := AssessmentLetterTextTable.FieldByName('Note').AsString
                      else FieldValue := '';

                If _Compare(MergeFieldName, 'ChangeReason_CodeTable', coEqual)
                then
                begin
                    sChangeReasonCode := AssessmentTable.FieldByName('OrigCurrYrValCode').AsString;

                    If _Locate(tbAssessmentChangeReasons, [sChangeReasonCode], '', [])
                    then FieldValue := tbAssessmentChangeReasons.FieldByName('Description').AsString
                    else FieldValue := '';

                end;  {If _Compare(MergeFieldName, 'ChangeReason_CodeTable', coEqual)}

                If _Compare(MergeFieldName, 'ProjectedTax', coEqual)
                  then
                    begin
                      TaxInformationList := TList.Create;

                        {CHG05182007-1(2.11.1.31): Round the project tax information.}

                      FieldValue := FormatFloat(CurrencyNormalDisplay,
                                                GetProjectedTaxInformation(CurrentHstdAssessedValue,
                                                                           CurrentNonhstdAssessedValue,
                                                                           SwisSBLKey,
                                                                           ParcelTable.FieldByName('SchoolCode').Text,
                                                                           TaxInformationList,
                                                                           [ltMunicipal, ltSchool, ltNoUnitary],
                                                                           trPerThousand,
                                                                           False));

                      FreeTList(TaxInformationList, SizeOf(TaxInformationRecord));

                    end;  {If _Compare(MergeFieldName, 'ProjectedTax', coEqual)}

                If _Compare(MergeFieldName, 'PropClass_Desc', coEqual)
                  then FieldValue := ParcelTable.FieldByName('PropertyClassCode').AsString + '-' +
                                     ParcelTable.FieldByName('PropertyClassDesc').AsString;

                If _Compare(MergeFieldName, 'Acreage', coEqual)
                  then FieldValue := FormatFloat(DecimalEditDisplay, ParcelTable.FieldByName('Acreage').AsFloat);

                If _Compare(MergeFieldName, 'Dimensions', coEqual)
                  then FieldValue := ParcelDimensionsToString(ParcelTable);

              end;  {If (FieldByName('TableName').Text = 'Special')}

          If _Compare(FieldByName('TableName').Text, 'ParcelTable', coEqual)
            then
              try
                FieldValue := ParcelTable.FieldByName(FieldByName('FieldName').Text).Text;
              except
                FieldValue := '';
              end;

        end;  {with MergeFieldsAvailableTable do}

      If (I > 0)
        then Write(LetterExtractFile, ',');

      If BlankLetter
        then FieldValue := '';

      Write(LetterExtractFile, '"', FieldValue, '"');

    end;  {For I := 0 to (MergeFieldsToAdd.Count - 1) do}

  Writeln(LetterExtractFile);

end;  {AddMergeFieldsToExtractFile}

{==============================================================================}
Procedure TAsmtChangeLetterPrintForm.PrintOneWordLetter(var LetterExtractFile : Text;
                                                            SwisSBLKey : String;
                                                            NAddrArray : NameAddrArray;
                                                            PriorHstdAssessedValue,
                                                            CurrentHstdAssessedValue,
                                                            PriorNonhstdAssessedValue,
                                                            CurrentNonhstdAssessedValue : LongInt;
                                                            PriorResidentialPercent,
                                                            CurrentResidentialPercent : Real;
                                                            PriorRollSection,
                                                            CurrentRollSection,
                                                            PriorHomesteadCode,
                                                            CurrentHomesteadCode : String;
                                                            PartialAssessment,
                                                            BlankLetter : Boolean);

var
  ParcelDescriptionChange,
  TempPartialAssessmentLine1,
  TempPartialAssessmentLine2 : String;

begin
  ParcelDescriptionChange := '';

  If ((PriorRollSection = '8') and
      (CurrentRollSection = '1'))
    then ParcelDescriptionChange := 'This property was changed from wholly exempt to taxable.';

  If ((PriorRollSection = '1') and
      (CurrentRollSection = '8'))
    then ParcelDescriptionChange := 'This property was changed from taxable to wholly exempt.';

    {Did the residential percent change?}

  If (PrintResidentialPercentChanges and
      (Roundoff(PriorResidentialPercent , 0) <>
       Roundoff(CurrentResidentialPercent, 0)))
    then ParcelDescriptionChange := 'Current year residential percent used for exemptions is ' +
                                    FormatFloat(CurrencyDisplayNoDollarSign,
                                                CurrentResidentialPercent) + '%.';

  If ((PriorHomesteadCode = CurrentHomesteadCode) or
      (Deblank(PriorHomesteadCode) = '') and  {Parcel did not exist previously.}
       (Roundoff((PriorHstdAssessedValue + PriorNonHstdAssessedValue), 0) = 0))
    then
      begin
          {If there is no change, print out the current homestead code
           of this parcel, but not if not a classified munic.}

        If GlblMunicipalityIsClassified
          then ParcelDescriptionChange := 'This parcel is a(n): ' +
                                          GetHomesteadDescription(CurrentHomesteadCode);

      end
    else ParcelDescriptionChange := 'This property has been changed from a ' +
                                    GetHomesteadDescription(PriorHomesteadCode) + ' to a ' +
                                    GetHomesteadDescription(CurrentHomesteadCode);

  If PartialAssessment
    then
      begin
        TempPartialAssessmentLine1 := PartialAssessmentLine1;
        TempPartialAssessmentLine2 := PartialAssessmentLine2;
      end
    else
      begin
        TempPartialAssessmentLine1 := '';
        TempPartialAssessmentLine2 := '';
      end;

  AddMergeFieldsToExtractFile(LetterExtractFile,
                              MergeFieldsToPrint, CurrentParcelTable,
                              AssessmentLetterTextTable,
                              MergeFieldsAvailableTable,
                              CurrentAssessmentTable,
                              tbAssessmentChangeReasons,
                              NAddrArray, CurrentYear, SwisSBLKey,
                              CurrentHstdAssessedValue,
                              CurrentNonhstdAssessedValue,
                              PriorHstdAssessedValue,
                              PriorNonhstdAssessedValue,
                              ParcelDescriptionChange,
                              TempPartialAssessmentLine1,
                              TempPartialAssessmentLine2,
                              PrintedDate, BlankLetter,
                              PartialAssessment);

end;  {PrintOneWordLetter}

{============================================================================}
Procedure TAsmtChangeLetterPrintForm.PrintWordLetters;

{CHG05202003-1(2.07b): Word Template for change letters.}

var
  LetterExtractFile : TextFile;
  FileExtension, NewFileName,
  SwisSBLKey, LetterExtractFileName,
  PriorRollSection, CurrentRollSection,
  PriorHomesteadCode, CurrentHomesteadCode : String;
  Done, FirstTimeThrough : Boolean;
  PriorHstdAssessedValue, CurrentHstdAssessedValue,
  PriorNonhstdAssessedValue, CurrentNonhstdAssessedValue : LongInt;
  PriorResidentialPercent, CurrentResidentialPercent : Real;
  NAddrArray : NameAddrArray;
  ExtensionPos, I : Integer;
  SBLRec : SBLRecord;

begin
  SwisSBLKey := '';
  NumPrintedGrandTotal := 0;
  ChangeGrandTotal := 0;
  Done := False;

  LetterExtractFileName := GetPrintFileName(Caption, True);

  try
    AssignFile(LetterExtractFile, LetterExtractFileName);
    Rewrite(LetterExtractFile);
  except
    SystemSupport(001, CurrentParcelTable, 'Error creating linked text file.',
                  UnitName, GlblErrorDlgBox);
  end;

    {Create the header record.}

  For I := 0 to (MergeFieldsToPrint.Count - 1) do
    begin
      If (I > 0)
        then Write(LetterExtractFile, ',');

      Write(LetterExtractFile, '"', MergeFieldsToPrint[I], '"');

    end;  {For I := 0 to (MergeFieldsToPrint.Count - 1) do}

  Writeln(LetterExtractFile);

  PriorResidentialPercent := 0;
  CurrentResidentialPercent := 0;

  FirstTimeThrough := True;
  SortTable.First;
  CurrentParcelTable.IndexName := ParcelTable_Year_Swis_SBLKey;

  PriorHstdAssessedValue := 0;
  CurrentHstdAssessedValue := 0;
  PriorNonhstdAssessedValue := 0;
  CurrentNonhstdAssessedValue := 0;

    {Print the blank letters.}

  For I := 1 to NumBlankLetters do
    PrintOneWordLetter(LetterExtractFile, SwisSBLKey, NAddrArray,
                       PriorHstdAssessedValue,
                       CurrentHstdAssessedValue,
                       PriorNonhstdAssessedValue,
                       CurrentNonhstdAssessedValue,
                       PriorResidentialPercent,
                       CurrentResidentialPercent,
                       PriorRollSection,
                       CurrentRollSection,
                       PriorHomesteadCode,
                       CurrentHomesteadCode,
                       False, False);

    ProgressDialog.Start(GetRecordCount(SortTable), True, True);

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
            SBLRec := ExtractSwisSBLFromSwisSBLKey(SwisSBLKey);

            with SBLRec do
              FindKeyOld(CurrentParcelTable,
                         ['TaxRollYr', 'SwisCode', 'Section',
                          'Subsection', 'Block', 'Lot', 'Sublot',
                          'Suffix'],
                         [CurrentYear, SwisCode, Section, Subsection, Block,
                          Lot, Sublot, Suffix]);

            If (PrintOrderRadioGroup.ItemIndex = 0)
              then ProgressDialog.Update(Self, ConvertSwisSBLToDashDot(SwisSBLKey))
              else ProgressDialog.Update(Self, CurrentParcelTable.FieldByName('Name1').Text);

            LettersPrinted := LettersPrinted + 1;
            GetNameAddress(CurrentParcelTable, NAddrArray);

            ProgressDialog.UserLabelCaption := 'Letters Printed = ' + IntToStr(LettersPrinted);
            Application.ProcessMessages;

            with SortTable do
              begin
                PriorRollSection := FieldByName('PriorRollSection').Text;
                PriorHomesteadCode := FieldByName('PriorHomesteadCode').Text;
                PriorResidentialPercent := FieldByName('PriorResPercent').AsFloat;
                PriorHstdAssessedValue := FieldByName('PriorHstdValue').AsInteger;
                PriorNonhstdAssessedValue := FieldByName('PriorNonhstdValue').AsInteger;

                CurrentRollSection := FieldByName('CurrentRollSection').Text;
                CurrentHomesteadCode := FieldByName('CurrentHomesteadCode').Text;
                CurrentResidentialPercent := FieldByName('CurrentResPercent').AsFloat;
                CurrentHstdAssessedValue := FieldByName('CurrentHstdValue').AsInteger;
                CurrentNonhstdAssessedValue := FieldByName('CurrentNonhstdValue').AsInteger;

              end;  {with SortTable do}

            NumPrintedGrandTotal := NumPrintedGrandTotal + 1;
            ChangeGrandTotal := ChangeGrandTotal +
                                (CurrentHstdAssessedValue +
                                 CurrentNonhstdAssessedValue) -
                                (PriorHstdAssessedValue +
                                 PriorNonhstdAssessedValue);

            PrintOneWordLetter(LetterExtractFile,
                               SwisSBLKey, NAddrArray,
                               PriorHstdAssessedValue,
                               CurrentHstdAssessedValue,
                               PriorNonhstdAssessedValue,
                               CurrentNonhstdAssessedValue,
                               PriorResidentialPercent,
                               CurrentResidentialPercent,
                               PriorRollSection,
                               CurrentRollSection,
                               PriorHomesteadCode,
                               CurrentHomesteadCode,
                               SortTable.FieldByName('PartialAssessment').AsBoolean,
                               False);

          end;  {If not Done}

      LettersCancelled := ProgressDialog.Cancelled;

  until (Done or LettersCancelled);

    {Now load the text file into Excel and then do the mail merge.}

  CloseFile(LetterExtractFile);

  try
    LetterOLEContainer.DestroyObject;
  except
  end;

  If not LettersCancelled
    then
      begin
        SendTextFileToExcelSpreadsheet(LetterExtractFileName, False,
                                       True, ChangeFileExt(LetterExtractFileName, '.XLS'));

          {FXX08192002-1: First copy the merge document to a template to avoid
                          MS Word associating the template with a particular Excel file.}

        FileExtension := ExtractFileExt(MergeLetterTable.FieldByName('FileName').Text);
        NewFileName := MergeLetterTable.FieldByName('FileName').Text;
        ExtensionPos := Pos(FileExtension, NewFileName);
        Delete(NewFileName, ExtensionPos, 200);
        NewFileName := NewFileName + '_Template' + FileExtension;

        CopyOneFile(MergeLetterTable.FieldByName('FileName').Text, NewFileName);

        PerformWordMailMerge(NewFileName,
                             ChangeFileExt(LetterExtractFileName, '.XLS'));

      end;  {If not ReportCancelled}

end;  {PrintWordLetters}

{============================================================================}
Procedure TAsmtChangeLetterPrintForm.ReportPrinterPrint(Sender: TObject);

var
  FirstTimeThrough, Done,
  FirstLetterPrinted : Boolean;
  I : Integer;
  PriorHstdAssessedValue, CurrentHstdAssessedValue,
  PriorNonhstdAssessedValue, CurrentNonhstdAssessedValue : Comp;
  PriorResidentialPercent, CurrentResidentialPercent : Real;
  PriorRollSection, CurrentRollSection,
  PriorHomesteadCode, CurrentHomesteadCode : String;
  SwisSBLKey : String;
  NAddrArray : NameAddrArray;
  SBLRec : SBLRecord;

begin
  FirstLetterPrinted := True;
  LettersPrinted := 0;
  SwisSBLKey := '';
  NumPrintedGrandTotal := 0;
  ChangeGrandTotal := 0;

  PriorResidentialPercent := 0;
  CurrentResidentialPercent := 0;

  FirstTimeThrough := True;
  SortTable.First;
  CurrentParcelTable.IndexName := ParcelTable_Year_Swis_SBLKey;

  PriorHstdAssessedValue := 0;
  CurrentHstdAssessedValue := 0;
  PriorNonhstdAssessedValue := 0;
  CurrentNonhstdAssessedValue := 0;

    {Print the blank letters.}

  For I := 1 to NumBlankLetters do
    begin
      PrintOneLetter(Sender, SwisSBLKey, '', NAddrArray,
                     PriorHstdAssessedValue, CurrentHstdAssessedValue,
                     PriorNonhstdAssessedValue, CurrentNonhstdAssessedValue,
                     PriorResidentialPercent, CurrentResidentialPercent,
                     PriorRollSection, CurrentRollSection,
                     PriorHomesteadCode, CurrentHomesteadCode, False, True);

        {skip newpage on 1st ltr, ReportPrinter has already printed hdr}

      with Sender as TBaseReport do
        If not FirstLetterPrinted
          then FirstLetterPrinted := True
          else NewPage;

    end;  {For I := 1 to NumBlankLetters do}

   {CHG05062001-1: Add ability to print blanks only, load from the parcel list,
                    and suppress the account number.}

  If not PrintBlanksOnly
    then
      with Sender as TBaseReport do
        begin
          Bold := True;
          Done := False;

            {Set up the tabs for the info.}
          ProgressDialog.Start(GetRecordCount(SortTable), True, True);

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
                  SBLRec := ExtractSwisSBLFromSwisSBLKey(SwisSBLKey);

                  with SBLRec do
                    FindKeyOld(CurrentParcelTable,
                               ['TaxRollYr', 'SwisCode', 'Section',
                                'Subsection', 'Block', 'Lot', 'Sublot',
                                'Suffix'],
                               [CurrentYear, SwisCode, Section, Subsection, Block,
                                Lot, Sublot, Suffix]);

                     {FXX10021997 - MDT. Show dash dot format SBL.}
                     {FXX11251997-2: Show name if in alpha order.}

                  If (PrintOrderRadioGroup.ItemIndex = 0)
                    then ProgressDialog.Update(Self, ConvertSwisSBLToDashDot(SwisSBLKey))
                    else ProgressDialog.Update(Self, CurrentParcelTable.FieldByName('Name1').Text);

                  LettersPrinted := LettersPrinted + 1;
                  GetNameAddress(CurrentParcelTable, NAddrArray);

                  ProgressDialog.UserLabelCaption := 'Letters Printed = ' + IntToStr(LettersPrinted);
                  Application.ProcessMessages;

                    {skip newpage on 1st ltr, ReportPrinter has already printed hdr}
                    {FXX06181999-8: This logic was messed up - caused blank 1st letter.}

                  If FirstLetterPrinted
                    then FirstLetterPrinted := False
                    else NewPage;

                  with SortTable do
                    begin
                      PriorRollSection := FieldByName('PriorRollSection').Text;
                      PriorHomesteadCode := FieldByName('PriorHomesteadCode').Text;
                      PriorResidentialPercent := FieldByName('PriorResPercent').AsFloat;
                      PriorHstdAssessedValue := FieldByName('PriorHstdValue').AsFloat;
                      PriorNonhstdAssessedValue := FieldByName('PriorNonhstdValue').AsFloat;

                      CurrentRollSection := FieldByName('CurrentRollSection').Text;
                      CurrentHomesteadCode := FieldByName('CurrentHomesteadCode').Text;
                      CurrentResidentialPercent := FieldByName('CurrentResPercent').AsFloat;
                      CurrentHstdAssessedValue := FieldByName('CurrentHstdValue').AsFloat;
                      CurrentNonhstdAssessedValue := FieldByName('CurrentNonhstdValue').AsFloat;

                    end;  {with SortTable do}

                  NumPrintedGrandTotal := NumPrintedGrandTotal + 1;
                  ChangeGrandTotal := ChangeGrandTotal +
                                      (CurrentHstdAssessedValue +
                                       CurrentNonhstdAssessedValue) -
                                      (PriorHstdAssessedValue -
                                       PriorNonhstdAssessedValue);

                  PrintOneLetter(Sender, SwisSBLKey,
                                 CurrentParcelTable.FieldByName('SchoolCode').Text,
                                 NAddrArray,
                                 PriorHstdAssessedValue,
                                 CurrentHstdAssessedValue,
                                 PriorNonhstdAssessedValue,
                                 CurrentNonhstdAssessedValue,
                                 PriorResidentialPercent,
                                 CurrentResidentialPercent,
                                 PriorRollSection,
                                 CurrentRollSection,
                                 PriorHomesteadCode,
                                 CurrentHomesteadCode,
                                 SortTable.FieldByName('PartialAssessment').AsBoolean,
                                 False);

                end;  {If not Done}

            LettersCancelled := ProgressDialog.Cancelled;

      until (Done or LettersCancelled);

      PrintOptionsPage(Sender);

    end;  {with Sender as TBaseReport do}

end;  {ReportPrinterPrint}

{========================================================================}
Procedure TAsmtChangeLetterPrintForm.SummaryReportPrintHeader(Sender: TObject);

begin
  with Sender as TBaseReport do
    begin
      ClearTabs;
      SetTab(0.3, pjLeft, 8.0, 0, BoxLineNone, 0);
      SetTab(4.5, pjCenter, 3.0, 0, BoxLineNone, 0);
      SetTab(10.0, pjRight, 0.7, 0, BoxLineNone, 0);

        {Print the date and page number.}
      SectionTop := 0.25;
      SectionLeft := 0.5;
      SectionRight := PageWidth - 0.5;

      SetFont('Times New Roman',8);
      Println(#9 + 'Date: ' + DateToStr(Date) +
                   '  Time: ' + TimeToStr(Now) +
              #9 +
              #9 + 'Page: ' + IntToStr(CurrentPage));

      SetFont('Times New Roman', 10);
      Bold := True;
      Println(#9 +
              #9 + 'Assessment Change Letter Report');
      Println('');

      ClearTabs;
      SetTab(0.3, pjCenter, 1.4, 5, BoxLineAll, 0);   {parcel id}
      SetTab(1.7, pjCenter, 1.6, 5, BoxLineAll, 0);   {Owner}
      SetTab(3.3, pjCenter, 1.6, 5, BoxLineAll, 0);   {Legal address}
      SetTab(4.9, pjCenter, 0.4, 5, BoxLineAll, 0);   {Prior rs}
      SetTab(5.3, pjCenter, 0.4, 5, BoxLineAll, 0);   {Current rs}
      SetTab(5.7, pjCenter, 0.4, 5, BoxLineAll, 0);   {Prior hc}
      SetTab(6.1, pjCenter, 0.4, 5, BoxLineAll, 0);   {Current hc}
      SetTab(6.5, pjCenter, 0.5, 5, BoxLineAll, 0);   {Prior res %}
      SetTab(7.0, pjCenter, 0.5, 5, BoxLineAll, 0);   {Current res %}
      SetTab(7.5, pjCenter, 1.0, 5, BoxLineAll, 0);   {Prior val}
      SetTab(8.5, pjCenter, 1.0, 5, BoxLineAll, 0);   {Current val}
      SetTab(9.5, pjCenter, 1.0, 5, BoxLineAll, 0);   {Change}

      Println(#9 + #9 + #9 +
              #9 + 'Prior' +
              #9 + 'Curr' +
              #9 + 'Prior' +
              #9 + 'Curr' +
              #9 + 'Prior' +
              #9 + 'Curr' +
              #9 + #9 + #9);

      Println(#9 + 'Parcel ID' +
              #9 + 'Owner' +
              #9 + 'Legal Addr' +
              #9 + 'RS' +
              #9 + 'RS' +
              #9 + 'HC' +
              #9 + 'HC' +
              #9 + 'Res %' +
              #9 + 'Res %' +
              #9 + 'Prior Value' +
              #9 + 'Current Value' +
              #9 + 'Net Change');

      Bold := False;

      ClearTabs;
      SetTab(0.3, pjLeft, 1.4, 5, BoxLineAll, 0);   {parcel id}
      SetTab(1.7, pjLeft, 1.6, 5, BoxLineAll, 0);   {Owner}
      SetTab(3.3, pjLeft, 1.6, 5, BoxLineAll, 0);   {Legal address}
      SetTab(4.9, pjCenter, 0.4, 5, BoxLineAll, 0);   {Prior rs}
      SetTab(5.3, pjCenter, 0.4, 5, BoxLineAll, 0);   {Current rs}
      SetTab(5.7, pjCenter, 0.4, 5, BoxLineAll, 0);   {Prior hc}
      SetTab(6.1, pjCenter, 0.4, 5, BoxLineAll, 0);   {Current hc}
      SetTab(6.5, pjRight, 0.5, 5, BoxLineAll, 0);   {Prior res %}
      SetTab(7.0, pjRight, 0.5, 5, BoxLineAll, 0);   {Current res %}
      SetTab(7.5, pjRight, 1.0, 5, BoxLineAll, 0);   {Prior val}
      SetTab(8.5, pjRight, 1.0, 5, BoxLineAll, 0);   {Current val}
      SetTab(9.5, pjRight, 1.0, 5, BoxLineAll, 0);   {Change}

    end;  {with Sender as TBaseReport do}

end;  {SummaryReportPrinterPrintHeader}

{========================================================================}
Procedure TAsmtChangeLetterPrintForm.SummaryReportPrint(Sender: TObject);

var
  Done, FirstTimeThrough : Boolean;
  TempParcelID, LastSwisCode : String;

begin
  Done := False;
  FirstTimeThrough := True;
  SortTable.First;
  ProgressDialog.Reset;
  ProgressDialog.TotalNumRecords := GetRecordCount(SortTable);
  ProgressDialog.UserLabelCaption := 'Printing summary report.';

  NumPrintedThisSwisCode := 0;
  ChangeThisSwisCode := 0;
  NumPrintedGrandTotal := 0;
  ChangeGrandTotal := 0;

  LastSwisCode := Take(6, SortTable.FieldByName('SwisSBLKey').Text);

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else SortTable.Next;

    If SortTable.EOF
      then Done := True;

    If ((Take(6, LastSwisCode) <> Take(6, SortTable.FieldByName('SwisSBLKey').Text)) or
        Done)
      then
        with Sender as TBaseReport do
          begin
            Println('');
            Println('Totals for swis ' + LastSwisCode + '->     Printed = ' +
                    IntToStr(NumPrintedThisSwisCode) + '   Change = ' +
                    FormatFloat(CurrencyNormalDisplay, ChangeThisSwisCode));

            NumPrintedGrandTotal := NumPrintedGrandTotal + NumPrintedThisSwisCode;
            ChangeGrandTotal := ChangeGrandTotal + ChangeThisSwisCode;
            NumPrintedThisSwisCode := 0;
            ChangeThisSwisCode := 0;

            LastSwisCode := Take(6, SortTable.FieldByName('SwisSBLKey').Text);

            If not Done
              then NewPage;

          end;  {If ((Take(6, LastSwisCode) <> Take(6, SortTable.FieldByName('SwisSBLKey').Text) or ...}

    If not Done
      then
        with Sender as TBaseReport, SortTable do
          begin
            ProgressDialog.Update(Self, ConvertSwisSBLToDashDot(FieldByName('SwisSBLKey').Text));

            If (LinesLeft < 5)
              then NewPage;

              {CHG04262004-1(2.08): Add owner and legal address to change of assessment report.}

            If (CurrentSwisCodeTable.RecordCount = 1)
              then TempParcelID := ConvertSBLOnlyToDashDot(Copy(FieldByName('SwisSBLKey').Text, 7, 20))
              else TempParcelID := ConvertSwisSBLToDashDot(FieldByName('SwisSBLKey').Text);

            Println(#9 + TempParcelID +
                    #9 + Take(16, FieldByName('Owner').Text) +
                    #9 + Take(16, FieldByName('LegalAddress').Text) +
                    #9 + FieldByName('PriorRollSection').Text +
                    #9 + FieldByName('CurrentRollSection').Text +
                    #9 + FieldByName('PriorHomesteadCode').Text +
                    #9 + FieldByName('CurrentHomesteadCode').Text +
                    #9 + FormatFloat(NoDecimalDisplay_BlankZero,
                                     FieldByName('PriorResPercent').AsFloat) +
                    #9 + FormatFloat(NoDecimalDisplay_BlankZero,
                                     FieldByName('CurrentResPercent').AsFloat) +
                    #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                                     (FieldByName('PriorHstdValue').AsFloat +
                                      FieldByName('PriorNonhstdValue').AsFloat)) +
                    #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                                     (FieldByName('CurrentHstdValue').AsFloat +
                                      FieldByName('CurrentNonhstdValue').AsFloat)) +
                    #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                                     ((FieldByName('CurrentHstdValue').AsFloat +
                                       FieldByName('CurrentNonhstdValue').AsFloat) -
                                      (FieldByName('PriorHstdValue').AsFloat +
                                       FieldByName('PriorNonhstdValue').AsFloat))));

            NumPrintedThisSwisCode := NumPrintedThisSwisCode + 1;
            ChangeThisSwisCode := ChangeThisSwisCode +
                                  ((FieldByName('CurrentHstdValue').AsFloat +
                                    FieldByName('CurrentNonhstdValue').AsFloat) -
                                   (FieldByName('PriorHstdValue').AsFloat +
                                    FieldByName('PriorNonhstdValue').AsFloat));

          end;  {with Sender as TBaseReport, SortTable do}

  until Done;

  with Sender as TBaseReport do
    begin
      Println('');
      Println('Grand totals ->   Printed = ' +
              IntToStr(NumPrintedGrandTotal) + '   Change = ' +
              FormatFloat(CurrencyNormalDisplay, ChangeGrandTotal));
    end;

end;  {SummaryReportPrint}

{===================================================================}
Procedure TAsmtChangeLetterPrintForm.CloseButtonClick(Sender: TObject);

begin
  Close;
end;

{===================================================================}
Procedure TAsmtChangeLetterPrintForm.FormClose(    Sender: TObject;
                                               var Action: TCloseAction);

begin
  MergeFieldsToPrint.Free;

  CloseTablesForForm(Self);

    {Free up the child window and set the ClosingAForm Boolean to
     true so that we know to delete the tab.}

  Action := caFree;
  GlblClosingAForm := True;
  GlblClosingFormCaption := Caption;

end;  {FormClose}

end.
