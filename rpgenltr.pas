unit Rpgenltr;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, DBCtrls, DBTables, DB, Buttons, Grids,
  Wwdbigrd, Wwdbgrid, ExtCtrls, Wwtable, Wwdatsrc, Menus,pastypes,
  GlblCnst,Types, RPFiler, RPBase, RPCanvas, RPrinter, (*Progress, *)RPDefine,
  DBGrids, DBLookup, TabNotBk, RPTXFilr, Mask, RPMemo, RPDBUtil, ComCtrls,
  ExtDlgs, wwriched, wwrichedspell, Word97, OleServer, OleCtnrs;

type
  TGenericLetterPrintForm = class(TForm)
    Panel2: TPanel;
    ScrollBox1: TScrollBox;
    LetterPrinter: TReportPrinter;
    LetterFiler: TReportFiler;
    PrintDialog: TPrintDialog;
    LetterTextTable: TTable;
    ExemptionCodeTable: TTable;
    AssessorOfficeTable: TTable;
    ParcelTable: TTable;
    ParcelExemptionTable: TTable;
    LetterTextDataSource: TDataSource;
    Notebook: TTabbedNotebook;
    Label5: TLabel;
    Label6: TLabel;
    SchoolCodeListBox: TListBox;
    SwisCodeListBox: TListBox;
    Label9: TLabel;
    PropertyClassListBox: TListBox;
    Label13: TLabel;
    Label14: TLabel;
    AllBanksCheckBox: TCheckBox;
    BanksStringGrid: TStringGrid;
    PrintOrderRadioGroup: TRadioGroup;
    Label1: TLabel;
    ExemptionListBox: TListBox;
    SpecialDistrictListBox: TListBox;
    Label3: TLabel;
    ReportTypeRadioGroup: TRadioGroup;
    SDCodeTable: TTable;
    SwisCodeTable: TTable;
    SchoolCodeTable: TTable;
    PropertyClassTable: TTable;
    AssessmentYearRadioGroup: TRadioGroup;
    OptionsGroupBox: TGroupBox;
    LetterHeadCheckBox: TCheckBox;
    PrintBySwisCodeCheckBox: TCheckBox;
    ParcelTypeRadioGroup: TRadioGroup;
    PrintDuplicatesCheckBox: TCheckBox;
    LetterTextTableMainCode: TStringField;
    LetterTextTableLetterText: TMemoField;
    PrintSuborderRadioGroup: TRadioGroup;
    Label21: TLabel;
    RollSectionListBox: TListBox;
    ParcelSDTable: TTable;
    SortTable: TTable;
    ReportPrinter: TReportPrinter;
    ReportFiler: TReportFiler;
    AssessmentTable: TTable;
    ReportTextFiler: TTextFiler;
    Label7: TLabel;
    DatePrintedEdit: TMaskEdit;
    PrintLetterBodyBoldCheckBox: TCheckBox;
    Label8: TLabel;
    ExemptionInclusionRadioGroup: TRadioGroup;
    Label10: TLabel;
    Label11: TLabel;
    SDInclusionRadioGroup: TRadioGroup;
    Label12: TLabel;
    CreateParcelListCheckBox: TCheckBox;
    LoadFromParcelListCheckBox: TCheckBox;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    SignatureGroupBox: TGroupBox;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    SignatureFileSpeedButton: TSpeedButton;
    SignatureXPosEdit: TEdit;
    SignatureYPosEdit: TEdit;
    SignatureFileNameEdit: TEdit;
    WidthLabel: TLabel;
    SignatureWidthEdit: TEdit;
    Label20: TLabel;
    SignatureHeightEdit: TEdit;
    SignatureOpenDialog: TOpenPictureDialog;
    ZipCodesStringGrid: TStringGrid;
    Label24: TLabel;
    Label25: TLabel;
    LetterTextPageControl: TPageControl;
    RegularLetterTabSheet: TTabSheet;
    Label2: TLabel;
    Label4: TLabel;
    Label15: TLabel;
    Label22: TLabel;
    Label16: TLabel;
    Label23: TLabel;
    LetterTextDBGrid: TDBGrid;
    DBNavigator1: TDBNavigator;
    LetterCodeDBEdit: TDBEdit;
    MirrorLetterCodeEdit: TEdit;
    LetterTextDBMemo: TwwDBRichEditMSWord;
    WordTabSheet: TTabSheet;
    Label26: TLabel;
    LetterFileNameLabel: TDBText;
    Label27: TLabel;
    Label28: TLabel;
    WordMergeletterGrid: TwwDBGrid;
    LetterOleContainer: TOleContainer;
    MergeFieldsUsedListBox: TListBox;
    NewLetterButton: TBitBtn;
    RemoveLetterButton: TBitBtn;
    AddFieldButton: TButton;
    RemoveFieldButton: TButton;
    UseWordLettersCheckBox: TCheckBox;
    WordApplication: TWordApplication;
    WordDocument: TWordDocument;
    MergeLetterTable: TwwTable;
    MergeLetterDataSource: TwwDataSource;
    OLEItemNameTimer: TTimer;
    MergeLetterDefinitionsTable: TwwTable;
    MergeFieldsAvailableTable: TTable;
    Panel1: TPanel;
    LoadButton: TBitBtn;
    SaveReportOptionsButton: TBitBtn;
    PrintButton: TBitBtn;
    CloseButton: TBitBtn;
    cbxActiveParcelsOnly: TCheckBox;
    cbExtractToExcel: TCheckBox;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CloseButtonClick(Sender: TObject);
    procedure PrintButtonClick(Sender: TObject);
    procedure LetterPrinterPrint(Sender: TObject);
    procedure ReportTextFilerPrint(Sender: TObject);
    procedure ReportTextFilerPrintHeader(Sender: TObject);
    procedure ReportPrint(Sender: TObject);
    procedure ReportTextFilerBeforePrint(Sender: TObject);
    procedure AllBanksCheckBoxClick(Sender: TObject);
    procedure BanksStringGridSetEditText(Sender: TObject; ACol,
      ARow: Longint; const Value: String);
    procedure SaveButtonClick(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject);
    procedure LoadButtonClick(Sender: TObject);
    procedure SaveReportOptionsButtonClick(Sender: TObject);
    procedure LetterTextTableBeforePost(DataSet: TDataset);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure SignatureFileSpeedButtonClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure LetterTextDBMemoKeyPress(Sender: TObject; var Key: Char);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure LetterTextDBMemoClick(Sender: TObject);
    procedure InsertCodeButtonClick(Sender: TObject);
    procedure MergeLetterTableAfterScroll(DataSet: TDataSet);
    procedure OLEItemNameTimerTimer(Sender: TObject);
    procedure LetterOleContainerMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
  private
    { Private declarations }
  public

    { Public declarations }
    UnitName : String;
    NumLettersPrinted : LongInt;

    bActiveParcelsOnly, LettersCancelled : Boolean; {cancels print job}

      {Report selections}

    PrintAllExemptions,
    PrintAllSpecialDistricts,
    PrintAllBankCodes,
    PrintAllSwisCodes,
    PrintAllSchoolCodes,
    PrintAllRollSections,
    PrintAllPropertyClasses,
    PrintBySwisCode,
    PrintLetterHead,
    PrintDuplicates : Boolean;

    SelectedExemptionCodes,
    SelectedSpecialDistricts,
    SelectedSchoolCodes,
    SelectedBankCodes,
    SelectedSwisCodes,
    SelectedRollSections,
    SelectedPropertyClasses,
    SelectedZipCodes : TStringList;

    AssessmentYear : String;
    ProcessingType : Integer;
    ReportType,
    PrintOrder,
    PrintSuborder,
    ParcelType : Integer;

    LetterTextCode : String;
    LastSwisCode : String;
    LastSchoolCode : String;
    LastRollSection : String;
    LastExemptionCode : String;
    LastSDCode : String;
    LastBankCode : String;
    LastPropertyClass : String;

    RollSectionList,
    SchoolCodeList,
    SwisCodeList,
    ExemptionCodeList,
    SDCodeList,
    PropertyClassList : TList;
    EnhancedSTARType,
    IncludeExemptions,
    IncludeSpecialDistricts : Integer;

    PrintedDate : TDateTime;

    LoadFromParcelList,
    CreateParcelList : Boolean;
    SBLPrintedList : TStringList;
    SignatureFile : String;
    SignatureXPos, SignatureYPos,
    SignatureHeight, SignatureWidth : Double;
    SignatureImage : TBitmap;
    OrigSortFileName : String;
    IVPEnrollmentStatusType : Integer;

    MergeFieldsToPrint : TStringList;
    UseWordLetterTemplate, bExtractToExcel : Boolean;
    InitializingForm : Boolean;
    LetterExtractFileName : String;
    flExtract, LetterExtractFile : TextFile;

    Procedure InitializeForm;  {Open the tables and setup.}

    Procedure FillListBoxes(AssessmentYear : String);

    Function ValidSelections : Boolean;

    Function RecordInRange(ParcelTable : TTable;
                           ExemptionList,
                           SDList : TStringList) : Boolean;

    Procedure InsertOneSortRecord(SortTable,
                                  ParcelTable : TTable;
                                  SwisSBLKey : String;
                                  EXCode : String;
                                  SDCode : String;
                                  PrintBySwisCode : Boolean);

    Procedure SortFiles;
    {Fill a sort file with any parcels in range.}

    Procedure PrintSelectionPage(Sender : TObject);

    Procedure InsertInformationIntoMemo(DBMemoBuf : TDBMemoBuf;
                                        SwisSBLKey : String);

    Procedure PrintOneWordLetter(var LetterExtractFile : TextFile;
                                     SwisSBLKey : String);

    Procedure PrintWordLetters;

    Procedure PrintOneLetter(    Sender : TObject;
                                 SwisSBLKey : String;
                             var FirstLetterPrinted : Boolean;
                             var LettersPrinted : LongInt);
    {Print one letter.}

  end;

{$R *.DFM}

implementation

uses GlblVars, WinUtils, Utilitys,PASUTILS, UTILEXSD, Preview,
     Prog, Enstarty, PRCLLIST, RptDialg, LetterInsertCodesUnit, UtilOLE, DataAccessUnit;

const
    {Report type constants}
  rtLetters = 0;
  rtReport = 1;
  rtBoth = 2;

    {Print orders}
  poParcelID = 0;
  poRollSection = 1;
  poSchoolCode = 2;
  poExemptionCode = 3;
  poSpecialDistrict = 4;
  poBankCode = 5;
  poPropertyClass = 6;
  poName = 7;
  poAddress = 8;

    {Property suborder}
  psParcelID = 0;
  psAddress = 1;
  psName = 2;
  psZipCode = 3;

    {Parcel types}
  ptAllParcels = 0;
  ptComInvParcels = 1;
  ptResInvParcels = 2;

  TrialRun = False;

    {Selection types for ex\sd codes.}

  stHasCode = 0;
  stDoesNotHaveCode = 1;
  stOnlyHasCode = 2;

type
  TotalsRecord = record
    LandVal,
    AssessedVal : Comp;
    Acres : Extended;
    Count : LongInt;
  end;

{========================================================}
Procedure TGenericLetterPrintForm.FormActivate(Sender: TObject);

begin
  SetFormStateMaximized(Self);
end;

{========================================================}
Procedure TGenericLetterPrintForm.FillListBoxes(AssessmentYear : String);

{Fill in all the list boxes on the various notebook pages.}

var
  ProcessingType : Integer;

begin
    {FXX11241999-1: If this is history, set a range so that only codes from that
                    year are displayed.}

  ProcessingType := GetProcessingTypeForTaxRollYear(AssessmentYear);

  FillOneListBox(ExemptionListBox, ExemptionCodeTable, 'EXCode',
                 'Description', 10, True, False, ProcessingType, AssessmentYear);

  FillOneListBox(SpecialDistrictListBox, SDCodeTable, 'SDistCode',
                 'Description', 10, True, False, ProcessingType, AssessmentYear);

  FillOneListBox(SwisCodeListBox, SwisCodeTable, 'SwisCode',
                 'MunicipalityName', 15, True, True, ProcessingType, AssessmentYear);

  FillOneListBox(SchoolCodeListBox, SchoolCodeTable, 'SchoolCode',
                 'SchoolName', 15, True, True, ProcessingType, AssessmentYear);

  FillOneListBox(PropertyClassListBox, PropertyClassTable, 'MainCode',
                 'Description', 17, True, True, ProcessingType, AssessmentYear);

    {Select all items}

  SelectItemsInListBox(RollSectionListBox);
  SelectItemsInListBox(ExemptionListBox);
  SelectItemsInListBox(SpecialDistrictListBox);
  SelectItemsInListBox(SwisCodeListBox);
  SelectItemsInListBox(SchoolCodeListBox);
  SelectItemsInListBox(PropertyClassListBox);

end;  {FillListBoxes}

{========================================================}
Procedure TGenericLetterPrintForm.InitializeForm;

var
  I : Integer;

begin
  UnitName := 'RPGENLTR';  {mmm}
  InitializingForm := True;
  SortTable.TableName := 'SortLettersLabels';

  MergeFieldsToPrint := TStringList.Create;
  OpenTablesForForm(Self, GlblProcessingType);

  AssessmentYear := GetTaxRlYr;

  FillListBoxes(AssessmentYear);

    {Select all roll sections}

  with RollSectionListBox do
    For I := 0 to (Items.Count - 1) do
      Selected[I] := True;

    {Default date to today.}

  DatePrintedEdit.Text := DateToStr(Date);
  OrigSortFileName := SortTable.TableName;

   {CHG12012004-1(2.8.1.1): Add capability to do Word merge letters in generic letters.}

  try
    MergeLetterTable.TableName := MergeLetterCodesTableName;
    MergeFieldsAvailableTable.TableName := MergeFieldsAvailableTableName;
    MergeLetterDefinitionsTable.TableName := MergeLetterFieldsTableName;

    MergeLetterTable.Open;
    MergeFieldsAvailableTable.Open;
    MergeLetterDefinitionsTable.Open;

    If (MergeLetterTable.RecordCount > 0)
      then OLEItemNameTimer.Enabled := True;

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
Procedure TGenericLetterPrintForm.FormKeyPress(    Sender: TObject;
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

{=======================================================================}
Procedure TGenericLetterPrintForm.FormKeyDown(    Sender: TObject;
                                              var Key: Word;
                                                  Shift: TShiftState);

{If they press F2 anywhere on the letter tab, bring up the edit memo.}

begin
  If ((Key = VK_F2) and
      (Notebook.PageIndex = 1) and
      (LetterTextTable.RecordCount > 0))
    then LetterTextDBMemo.Execute;

end;  {FormKeyDown}

{=======================================================================}
Procedure TGenericLetterPrintForm.LetterTextDBMemoKeyPress(    Sender: TObject;
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

{===================================================================}
Procedure TGenericLetterPrintForm.LetterTextDBMemoClick(Sender: TObject);

{If they click or double click in the memo, bring up the edit memo.}

begin
  If (LetterTextTable.RecordCount > 0)
    then
      begin
        LetterTextDBMemo.Execute;
          {FXX04232009-4(2.20.1.1)[D210]: Automatically save the letter changes.}

        If (LetterTextTable.State = dsEdit)
          then LetterTextTable.Post;

      end;

end;  {LetterTextDBMemoClick}

{===============================================================}
Procedure TGenericLetterPrintForm.MergeLetterTableAfterScroll(DataSet: TDataSet);

var
  TemplateName : OLEVariant;

begin
  If not InitializingForm
    then
      begin
        TemplateName := MergeLetterTable.FieldByName('FileName').Text;

          {FXX07252002-2: Make sure to have a try..except around the container create.}

        If (_Compare(MergeLetterTable.FieldByName('LetterName').AsString, coNotBlank) and
            FileExists(TemplateName))
          then
            try
              LetterOLEContainer.CreateObjectFromFile(TemplateName, False);
            except
              LetterOLEContainer.DestroyObject;
              LetterOLEContainer.SizeMode := smClip;
              LetterOLEContainer.CreateObjectFromFile(TemplateName, False);

            end;

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

{====================================================================}
Procedure TGenericLetterPrintForm.OLEItemNameTimerTimer(Sender: TObject);

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

{=========================================================================}
Procedure TGenericLetterPrintForm.LetterOleContainerMouseDown(Sender: TObject;
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

{===================================================================}
Procedure TGenericLetterPrintForm.SaveButtonClick(Sender: TObject);

{CHG10131998-2: Add the ability to edit the letter text right on screen.}

begin
  LetterTextTable.Post;
end;

{===================================================================}
Procedure TGenericLetterPrintForm.CancelButtonClick(Sender: TObject);

begin
  LetterTextTable.Cancel;
end;

{===================================================================}
Procedure TGenericLetterPrintForm.AllBanksCheckBoxClick(Sender: TObject);

{Get rid of any bank codes already entered.}

var
  I, J : Integer;

begin
  If AllBanksCheckBox.Checked
    then
      with BanksStringGrid do
        For I := 0 to (ColCount - 1) do
          For J := 0 to (RowCount - 1) do
            Cells[I, J] := '';

end;  {AllBanksCheckBoxClick}

{===================================================================}
Procedure TGenericLetterPrintForm.BanksStringGridSetEditText(Sender: TObject;
                                                             ACol, ARow: Longint;
                                                             const Value: String);
begin
  AllBanksCheckBox.Checked := False;
end;

{===================================================================}
Function TGenericLetterPrintForm.ValidSelections : Boolean;

var
  I, J, NumBanks : Integer;

begin
  Result := True;

  If (AssessmentYearRadioGroup.ItemIndex = -1)
    then
      begin
        MessageDlg('Please select an assessment year before printing.',
                   mtError, [mbOK], 0);
        Result := False;
      end;

  If (Result and
      (ReportTypeRadioGroup.ItemIndex = -1))
    then
      begin
        MessageDlg('Please select a report type before printing.',
                   mtError, [mbOK], 0);
        Result := False;
      end;

  If (Result and
      (PrintOrderRadioGroup.ItemIndex = -1))
    then
      begin
        MessageDlg('Please select a print order before printing.',
                   mtError, [mbOK], 0);
        Result := False;
      end;

    {FXX09071999-1: Add print by name and addr.}

  If (Result and
      (PrintSuborderRadioGroup.ItemIndex = -1) and
      (not (PrintOrderRadioGroup.ItemIndex in [poParcelID, poName, poAddress])))
    then
      begin
        MessageDlg('Please select a print sub order before printing.',
                   mtError, [mbOK], 0);
        Result := False;
      end;

  If (Result and
      (ExemptionListBox.SelCount = 0))
    then
      begin
        MessageDlg('Please select one or more exemption codes before printing.',
                   mtError, [mbOK], 0);
        Result := False;
      end;

    {CHG07281999-1: Allow users to select parcels that exclusively have a given ex or sd.}

  If (Result and
      (ExemptionListBox.SelCount > 1) and
      (ExemptionInclusionRadioGroup.ItemIndex = stOnlyHasCode))
    then
      begin
        MessageDlg('Please select only one exemption code to search exclusively for.',
                   mtError, [mbOK], 0);
        Result := False;
      end;

    {FXX06181999-4: Allow printing for munic with no special districts.}

  If (Result and
      (SpecialDistrictListBox.SelCount = 0) and
      _Compare(SpecialDistrictListBox.Items.Count, 0, coGreaterThan))
    then
      begin
        MessageDlg('Please select one or more special district codes before printing.',
                   mtError, [mbOK], 0);
        Result := False;
      end;

    {CHG07281999-1: Allow users to select parcels that exclusively have a given ex or sd.}

  If (Result and
      (SpecialDistrictListBox.SelCount > 1) and
      (SDInclusionRadioGroup.ItemIndex = stOnlyHasCode))
    then
      begin
        MessageDlg('Please select only one special district code to search exclusively for.',
                   mtError, [mbOK], 0);
        Result := False;
      end;

  If (Result and
      (SwisCodeListBox.SelCount = 0))
    then
      begin
        MessageDlg('Please select one or more swis codes before printing.',
                   mtError, [mbOK], 0);
        Result := False;
      end;

  If (Result and
      (SchoolCodeListBox.SelCount = 0))
    then
      begin
        MessageDlg('Please select one or more school codes before printing.',
                   mtError, [mbOK], 0);
        Result := False;
      end;

  If (Result and
      (PropertyClassListBox.SelCount = 0))
    then
      begin
        MessageDlg('Please select one or more property class codes before printing.',
                   mtError, [mbOK], 0);
        Result := False;
      end;

  If (Result and
      (RollSectionListBox.SelCount = 0))
    then
      begin
        MessageDlg('Please select one or more roll sections before printing.',
                   mtError, [mbOK], 0);
        Result := False;
      end;

  NumBanks := 0;
  with BanksStringGrid do
    For I := 0 to (ColCount - 1) do
      For J := 0 to (RowCount - 1) do
        If (Deblank(Cells[I, J]) <> '')
          then NumBanks := NumBanks + 1;

   If (Result and
       (not (AllBanksCheckBox.Checked or
            (NumBanks > 0))))
     then
       begin
         MessageDlg('Please either select all banks or enter one or more bank codes.',
                    mtError, [mbOK], 0);
         Result := False;
       end;

    {CHG10141998-3: Allow the user to select what date to print.}

  If Result
    then
      try
        PrintedDate := StrToDate(DatePrintedEdit.Text);
      except
        Result := False;
        MessageDlg('Please enter a valid printed date.', mtInformation, [mbOK], 0);
      end;

  If (Result and
      LoadFromParcelListCheckBox.Checked and
      CreateParcelListCheckBox.Checked)
    then
      begin
        MessageDlg('Sorry, you can not choose to both load from the parcel list and' + #13 +
                   'create a new parcel list.', mtError, [mbOK], 0);
        Result := False;
      end;

end;  {ValidSelections}

{===================================================================}
Function TGenericLetterPrintForm.RecordInRange(ParcelTable : TTable;
                                               ExemptionList,
                                               SDList : TStringList) : Boolean;

var
  ParcelHasSenior, ZipCodeFound,
  SwisCodeFound, BankCodeFound, SchoolCodeFound,
  PropertyClassFound, RollSectionFound,
  ExemptionFound, SpecialDistrictFound,
  FirstTimeThrough, CorrectParcelType, Done,
  MeetsExemptionCriteria, MeetsSpecialDistrictCriteria : Boolean;
  SwisSBLKey : String;
  AssessmentYear : String;
  I, ZipCodeLength : Integer;
  CommercialSiteTable, ResidentialSiteTable : TTable;

begin
  ExemptionList.Clear;
  SDList.Clear;

  with ParcelTable do
    begin
      SwisCodeFound := False;
      If PrintAllSwisCodes
        then SwisCodeFound := True
        else
          For I := 0 to (SelectedSwisCodes.Count - 1) do
            If (FieldByName('SwisCode').Text = SelectedSwisCodes[I])
              then SwisCodeFound := True;

      SchoolCodeFound := False;
      If PrintAllSchoolCodes
        then SchoolCodeFound := True
        else
          For I := 0 to (SelectedSchoolCodes.Count - 1) do
            If (FieldByName('SchoolCode').Text = SelectedSchoolCodes[I])
              then SchoolCodeFound := True;

      BankCodeFound := False;
      If PrintAllBankCodes
        then BankCodeFound := True
        else
          For I := 0 to (SelectedBankCodes.Count - 1) do
            If (FieldByName('BankCode').Text = SelectedBankCodes[I])
              then BankCodeFound := True;

        {CHG02252004-3(2.08): Allow them to select zip codes.}

      ZipCodeFound := False;
      If (SelectedZipCodes.Count = 0)
        then ZipCodeFound := True
        else
          For I := 0 to (SelectedZipCodes.Count - 1) do
            begin
              ZipCodeLength := Length(Trim(SelectedZipCodes[I]));

              If (Take(ZipCodeLength, FieldByName('Zip').Text) =
                  Take(ZipCodeLength, SelectedZipCodes[I]))
                then ZipCodeFound := True;

            end;  {For I := 0 to (SelectedZipCodes.Count - 1) do}

      RollSectionFound := False;
      If PrintAllRollSections
        then RollSectionFound := True
        else
          For I := 0 to (SelectedRollSections.Count - 1) do
            If (FieldByName('RollSection').Text = SelectedRollSections[I])
              then RollSectionFound := True;

      PropertyClassFound := False;
      If PrintAllPropertyClasses
        then PropertyClassFound := True
        else
          For I := 0 to (SelectedPropertyClasses.Count - 1) do
            If (FieldByName('PropertyClassCode').Text = SelectedPropertyClasses[I])
              then PropertyClassFound := True;

    end;  {with ParcelTable do}

  SwisSBLKey := ExtractSSKey(ParcelTable);
  AssessmentYear := ParcelTable.FieldByName('TaxRollYr').Text;

    {FXX07281999-1: If looking for a does not have of an exemption or SD, then always get the
                    list.}
    {CHG07281999-1: Allow user to look exclusively for an exemption or SD.}

  If ((IncludeExemptions = stHasCode) and
      PrintAllExemptions)
    then ExemptionFound := True
    else
      begin
        ExemptionFound := False;

        FirstTimeThrough := True;
        Done := False;
        ParcelExemptionTable.CancelRange;
        SetRangeOld(ParcelExemptionTable,
                    ['TaxRollYr', 'SwisSBLKey', 'ExemptionCode'],
                    [AssessmentYear, SwisSBLKey, '     '],
                    [AssessmentYear, SwisSBLKey, 'ZZZZZ']);

        repeat
          If FirstTimeThrough
            then FirstTimeThrough := False
            else ParcelExemptionTable.Next;

          If ParcelExemptionTable.EOF
            then Done := True;

          If not Done
            then ExemptionList.Add(ParcelExemptionTable.FieldByName('ExemptionCode').Text);

        until Done;

          {CHG11011999-2: If they just selected 41834 to print, ask if
                          they want seniors too.}

        ParcelHasSenior := False;

        For I := 0 to (ExemptionList.Count - 1) do
          If (Take(4, ExemptionList[I]) = '4180')
            then ParcelHasSenior := True;

          {FXX12281999-1: Use the enhanced STAR dialog.}

        If ((SelectedExemptionCodes.Count = 1) and
            (SelectedExemptionCodes[0] = EnhancedSTARExemptionCode))
          then
            begin
              case EnhancedSTARType of
                enSeniorSTAROnly :
                      ExemptionFound := ((ExemptionList.IndexOf(EnhancedSTARExemptionCode) > -1) and
                                         (not ParcelHasSenior));
                enWithSeniorandSTARExemption :
                      ExemptionFound := ((ExemptionList.IndexOf(EnhancedSTARExemptionCode) > -1) and
                                         ParcelHasSenior);
                enAnySeniorSTAR :
                      ExemptionFound := (ExemptionList.IndexOf(EnhancedSTARExemptionCode) > -1);

              end;  {case EnhancedSTARType of}

                {CHG01212004-1(2.08): Add ability to select IVP enrollment status as a choice.}

              If ExemptionFound
                then
                  begin
                    _Locate(ParcelExemptionTable,
                            [AssessmentYear, SwisSBLKey, EnhancedSTARExemptionCode],
                            ParcelExemptionTable.IndexName, []);

                    case IVPEnrollmentStatusType of
                      ivpEnrolledOnly : ExemptionFound := ParcelExemptionTable.FieldByName('AutoRenew').AsBoolean;
                      ivpNotEnrolledOnly : ExemptionFound := (not ParcelExemptionTable.FieldByName('AutoRenew').AsBoolean);
                    end;  {case IVPEnrollmentStatusType of}

                  end;  {If ExemptionFound}

            end
          else
            For I := 0 to (ExemptionList.Count - 1) do
              If (SelectedExemptionCodes.IndexOf(ExemptionList[I]) <> -1)
                then ExemptionFound := True;

          {FXX12131999-3: Did not work to say print parcels with no Exemptions or SDs.}

        If (PrintAllExemptions and
            ((IncludeExemptions = stHasCode) or  {Wants all regardless of Exemptions.}
             ((IncludeExemptions = stDoesNotHaveCode) and  {Wants parcels without an Exemption.}
              (ExemptionList.Count > 0))))
          then ExemptionFound := True;

      end;  {else of IfPrintAllExemptions}

  MeetsExemptionCriteria := ((IncludeExemptions = stHasCode) and  {They want any parcel with selected ex code.}
                             ExemptionFound) or
                            ((IncludeExemptions = stDoesNotHaveCode) and {Want parcels without selected ex code.}
                             (not ExemptionFound)) or
                            ((IncludeExemptions = stOnlyHasCode) and  {Only the 1 selected.}
                             (ExemptionList.Count = 1) and
                             ExemptionFound);

  If ((IncludeSpecialDistricts = stHasCode) and
      PrintAllSpecialDistricts)
    then SpecialDistrictFound := True
    else
      begin
        SpecialDistrictFound := False;

        FirstTimeThrough := True;
        Done := False;
        ParcelSDTable.CancelRange;
        SetRangeOld(ParcelSDTable,
                    ['TaxRollYr', 'SwisSBLKey', 'SDistCode'],
                    [AssessmentYear, SwisSBLKey, '     '],
                    [AssessmentYear, SwisSBLKey, 'ZZZZZ']);

        repeat
          If FirstTimeThrough
            then FirstTimeThrough := False
            else ParcelSDTable.Next;

          If ParcelSDTable.EOF
            then Done := True;

          If not Done
            then SDList.Add(ParcelSDTable.FieldByName('SDistCode').Text);

        until Done;

        For I := 0 to (SDList.Count - 1) do
          If (SelectedSpecialDistricts.IndexOf(SDList[I]) > - 1)
            then SpecialDistrictFound := True;

          {FXX12131999-3: Did not work to say print parcels with no Exemptions or SDs.}

        If (PrintAllSpecialDistricts and
            ((IncludeSpecialDistricts = stHasCode) or  {Wants all regardless of SpecialDistricts.}
             ((IncludeSpecialDistricts = stDoesNotHaveCode) and  {Wants parcels without an SpecialDistrict.}
              (SDList.Count > 0))))
          then SpecialDistrictFound := True;

      end;  {else of IfPrintAllSpecialDistricts}

    {FXX07172008-1(2.14.1.3)[D1309]: If the municipality does not special districts, then don't consider them.}

  MeetsSpecialDistrictCriteria := _Compare(SelectedSpecialDistricts.Count, 0, coEqual) or
                                  ((IncludeSpecialDistricts = stHasCode) and  {They want any parcel with selected SD code.}
                                   SpecialDistrictFound) or
                                  ((IncludeSpecialDistricts = stDoesNotHaveCode) and {Want parcels without selected SD code.}
                                   (not SpecialDistrictFound)) or
                                  ((IncludeSpecialDistricts = stOnlyHasCode) and  {Only the 1 selected.}
                                   (SDList.Count = 1) and
                                   SpecialDistrictFound);

    {FXX07161998-1: Add filter for parcel type.}

  CorrectParcelType := False;

  If (ParcelType = ptAllParcels)
    then CorrectParcelType := True;

    {FXX05112001-2: Hook up the commercial and residential inventory
                    option.}

  If (ParcelType = ptComInvParcels)
    then
      begin
        CommercialSiteTable := FindTableInDataModuleForProcessingType(DataModuleCommercialSiteTableName,
                                                                      ProcessingType);

        CorrectParcelType := _Locate(CommercialSiteTable, [AssessmentYear, SwisSBLKey], '', []);

      end;  {If (ParcelType = ptComInvParcels)}

  If (ParcelType = ptResInvParcels)
    then
      begin
        ResidentialSiteTable := FindTableInDataModuleForProcessingType(DataModuleResidentialSiteTableName,
                                                                       ProcessingType);

        ResidentialSiteTable.CancelRange;
        FindNearestOld(ResidentialSiteTable, ['TaxRollYr', 'SwisSBLKey'],
                       [AssessmentYear, SwisSBLKey]);

        CorrectParcelType := (Take(26, ResidentialSiteTable.FieldByName('SwisSBLKey').Text) =
                              Take(26, SwisSBLKey));

      end;  {If (ParcelType = ptResInvParcels)}

    {FXX05161999-1: Don't make being loaded from parcel list an automatic
                    qualification for RecordInRange - it has to go through
                    the tests also - this makes it more flexible.
                    If they want exactly that list, then leave all
                    options selected.}

  Result := (SwisCodeFound and
             BankCodeFound and
             ZipCodeFound and
             SchoolCodeFound and
             PropertyClassFound and
             RollSectionFound and
             MeetsExemptionCriteria and
             MeetsSpecialDistrictCriteria and
             CorrectParcelType{ or
             LoadFromParcelList});

end;  {RecordInRange}

{===================================================================}
Procedure TGenericLetterPrintForm.InsertOneSortRecord(SortTable,
                                                      ParcelTable : TTable;
                                                      SwisSBLKey : String;
                                                      EXCode : String;
                                                      SDCode : String;
                                                      PrintBySwisCode : Boolean);

begin
  with SortTable do
    try
      Insert;

      FieldByName('SwisCode').Text := Copy(SwisSBLKey, 1, 6);

        {Only fill in the swis code key if they are printing by swis code.
         Otherwise, it will be blank and will not affect the keys.}

      If PrintBySwisCode
        then FieldByName('SwisCodeKey').Text := FieldByName('SwisCode').Text;

      FieldByName('SBLKey').Text := Copy(SwisSBLKey, 7, 20);
      FieldByName('SchoolCode').Text := ParcelTable.FieldByName('SchoolCode').Text;
      FieldByName('Name1').Text := ParcelTable.FieldByName('Name1').Text;
      FieldByName('LegalAddrNo').Text := ParcelTable.FieldByName('LegalAddrNo').Text;
      FieldByName('LegalAddr').Text := ParcelTable.FieldByName('LegalAddr').Text;
      FieldByName('ZipCode').Text := ParcelTable.FieldByName('Zip').Text;
      FieldByName('ZipPlus4').Text := ParcelTable.FieldByName('ZipPlus4').Text;
      FieldByName('RollSection').Text := ParcelTable.FieldByName('RollSection').Text;
      FieldByName('PropertyClass').Text := ParcelTable.FieldByName('PropertyClassCode').Text;
      FieldByName('BankCode').Text := ParcelTable.FieldByName('BankCode').Text;
      FieldByName('SDCode').Text := SDCode;
      FieldByName('EXCode').Text := EXCode;

      Post;
    except
      SystemSupport(023, SortTable, 'Error inserting sort record.', UnitName, GlblErrorDlgBox);
    end;

end;  {InsertOneSortRecord}

{===================================================================}
Procedure TGenericLetterPrintForm.SortFiles;

{Fill a sort file with any parcels in range.}

var
  Found, FirstTimeThrough, Done : Boolean;
  ExemptionList, SDList : TStringList;
  SwisSBLKey : String;
  Index, I : Integer;
  NumFound : LongInt;

begin
  Index := 1;
  NumFound := 0;
  FirstTimeThrough := True;
  Done := False;
  ExemptionList := TStringList.Create;
  SDList := TStringList.Create;
  ProgressDialog.UserLabelCaption := 'Sorting files.';

    {CHG03101999-1: Send info to a list or load from a list.}

  If CreateParcelList
    then ParcelListDialog.ClearParcelGrid(True);

  If LoadFromParcelList
    then
      begin
        ParcelListDialog.GetParcel(ParcelTable, Index);
        ProgressDialog.Start(ParcelListDialog.NumItems, True, True);
      end
    else
      begin
        ParcelTable.First;
        ProgressDialog.Start(GetRecordCount(ParcelTable), True, True);
      end;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else
        If LoadFromParcelList
          then
            begin
              Index := Index + 1;
              ParcelListDialog.GetParcel(ParcelTable, Index);
            end
          else ParcelTable.Next;

    If (ParcelTable.EOF or
        (LoadFromParcelList and
         (Index > ParcelListDialog.NumItems)) or
        (TrialRun and
         (NumFound = 4)))
      then Done := True;

    If LoadFromParcelList
      then ProgressDialog.Update(Self, ParcelListDialog.GetParcelID(Index))
      else ProgressDialog.Update(Self, ConvertSwisSBLToDashDot(ExtractSSKey(ParcelTable)));

    Application.ProcessMessages;

      {FXX04232009-5(2.20.1.1)[D761]: Don't print out letters for inactive parcels.}

    If ((not Done) and
        RecordInRange(ParcelTable, ExemptionList, SDList) and
        ((not bActiveParcelsOnly) or
         ParcelIsActive(ParcelTable)))
      then
        begin
          NumFound := NumFound + 1;
          SwisSBLKey := ExtractSSKey(ParcelTable);

          ProgressDialog.UserLabelCaption := 'Number Found = ' + IntToStr(NumFound);

             {CHG03101999-1: Send info to a list.}

           If CreateParcelList
             then ParcelListDialog.AddOneParcel(SwisSBLKey);

           {If they want duplicates and they are printing in sd or ex order, then put in one
            for each selected exemption or sd.  Otherwise, just insert the first matching one.}

          If (PrintDuplicates and
              (PrintOrder in [poExemptionCode, poSpecialDistrict]))
            then
              begin
                If (PrintOrder = poExemptionCode)
                  then
                    For I := 0 to (ExemptionList.Count - 1) do
                      If (SelectedExemptionCodes.IndexOf(ExemptionList[I]) > -1)
                        then InsertOneSortRecord(SortTable, ParcelTable, SwisSBLKey, ExemptionList[I],
                                                 '', PrintBySwisCode);

                If (PrintOrder = poSpecialDistrict)
                  then
                    For I := 0 to (SDList.Count - 1) do
                      If (SelectedSpecialDistricts.IndexOf(SDList[I]) > -1)
                        then InsertOneSortRecord(SortTable, ParcelTable, SwisSBLKey, '', SDList[I], PrintBySwisCode);

              end
            else
              begin
                  {Only insert for one exemption or special district even if more
                   than one matches.}

                If (PrintOrder = poExemptionCode)
                  then
                    begin
                      Found := False;

                      For I := 0 to (ExemptionList.Count - 1) do
                        If ((SelectedExemptionCodes.IndexOf(ExemptionList[I]) > -1) and
                            (not Found))
                          then
                            begin
                              Found := True;
                              InsertOneSortRecord(SortTable, ParcelTable, SwisSBLKey, ExemptionList[I],
                                                   '', PrintBySwisCode);
                            end;  {If ((SelectedExemptionCodes.IndexOf(ExemptionList[I]) > -1) and...}

                    end;  {If (PrintOrder = poExemptionCode)}

                If (PrintOrder = poSpecialDistrict)
                  then
                    begin
                      Found := False;

                      For I := 0 to (SDList.Count - 1) do
                        If ((SelectedSpecialDistricts.IndexOf(SDList[I]) > -1) and
                            (not Found))
                          then
                            begin
                              Found := True;
                              InsertOneSortRecord(SortTable, ParcelTable, SwisSBLKey, '',
                                                  SDList[I], PrintBySwisCode);
                            end;  {If ((SelectedSpecialDistricts.IndexOf(SDList[I]) > -1) and...}

                    end;  {If (PrintOrder = poSpecialDistrictCode)}

                If not (PrintOrder in [poExemptionCode, poSpecialDistrict])
                  then InsertOneSortRecord(SortTable, ParcelTable, SwisSBLKey,
                                           '', '', PrintBySwisCode);

              end;  {If (PrintDuplicates and...}

        end;  {If ((not Done) and ...}

  until (Done or ProgressDialog.Cancelled);

  ExemptionList.Free;
  SDList.Free;

end;  {SortFiles}

{====================================================================}
Procedure TGenericLetterPrintForm.SaveReportOptionsButtonClick(Sender: TObject);

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
    then SaveReportOptions(Self, OpenDialog, SaveDialog, 'genltrs.gnl', 'Generic Letters');

end;  {SaveButtonClick}

{====================================================================}
Procedure TGenericLetterPrintForm.LoadButtonClick(Sender: TObject);

{FXX04091999-8: Add ability to save and load search report options.}

begin
  LoadReportOptions(Self, OpenDialog, 'genltrs.gnl', 'Generic Letters');

    {FXX05012000-4: The save\load options does not work for data aware components,
                    so we will trick it by having a mirror edit the contains the
                    letter text code and can be used to relocate to the correct
                    letter.}

  FindKeyOld(LetterTextTable, ['MainCode'], [MirrorLetterCodeEdit.Text]);

end;  {LoadButtonClick}

{===================================================================}
Procedure TGenericLetterPrintForm.LetterTextTableBeforePost(DataSet: TDataset);

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

{===============================================================}
Procedure TGenericLetterPrintForm.SignatureFileSpeedButtonClick(Sender: TObject);

{CHG04242000-1: Add signature file capabilites to ex, generic letters.}

begin
  If SignatureOpenDialog.Execute
    then SignatureFileNameEdit.Text := SignatureOpenDialog.FileName;

end;  {SignatureFileSpeedButtonClick}

{======================================================================}
Procedure AddMergeFieldsToExtractFile(var LetterExtractFile : TextFile;
                                          MergeFieldsToPrint : TStringList;
                                          ParcelTable,
                                          MergeFieldsAvailableTable : TTable;
                                          NAddrArray : NameAddrArray;
                                          AssessmentYear : String;
                                          SwisSBLKey : String;
                                          LetterDate : TDateTime);

var
  I : Integer;
  MergeFieldName, FieldValue : String;

begin
  For I := 0 to (MergeFieldsToPrint.Count - 1) do
    begin
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

      Write(LetterExtractFile, '"', FieldValue, '"');

    end;  {For I := 0 to (MergeFieldsToAdd.Count - 1) do}

  Writeln(LetterExtractFile);

end;  {AddMergeFieldsToExtractFile}

{===================================================================}
Procedure TGenericLetterPrintForm.PrintOneWordLetter(var LetterExtractFile : TextFile;
                                                         SwisSBLKey : String);

var
  NAddrArray : NameAddrArray;

begin
    {FXX07242007-2(2.11.2.8)[D939]: The locate of the parcel was not correct because it
                                    was missing loParseSwisSBLKey.}

  _Locate(ParcelTable, [AssessmentYear, SwisSBLKey], 'BYTAXROLLYR_SWISSBLKEY', [loParseSwisSBLKey]);
  GetNameAddress(ParcelTable, NAddrArray);

  AddMergeFieldsToExtractFile(LetterExtractFile, MergeFieldsToPrint,
                              ParcelTable, MergeFieldsAvailableTable,
                              NAddrArray, AssessmentYear,
                              SwisSBLKey, PrintedDate);

end;  {PrintOneWordLetter}

{===================================================================}
Procedure TGenericLetterPrintForm.PrintWordLetters;

var
  FileExtension, NewFileName,
  SwisSBLKey : String;
  LettersPrinted, ExtensionPos : LongInt;

begin
  LettersPrinted := 0;

  ProgressDialog.Start(GetRecordCount(SortTable), True, True);
  SortTable.First;

    {FXX07242007-1(2.11.2.8)[]: The loop for printing the Word letters was
                                not starting with the first record.} 

  with SortTable do
    while not (EOF or LettersCancelled) do
      begin
        SwisSBLKey := FieldByName('SwisCode').AsString + FieldByName('SBLKey').AsString;
        ProgressDialog.Update(Self, ConvertSwisSBLToDashDot(SwisSBLKey));
        LettersPrinted := LettersPrinted + 1;
        ProgressDialog.UserLabelCaption := 'Letters Printed = ' + IntToStr(LettersPrinted);
        Application.ProcessMessages;

        PrintOneWordLetter(LetterExtractFile, SwisSBLKey);

        LettersCancelled := ProgressDialog.Cancelled;
        Next;

      end;  {while not (EOF or LettersCancelled) do}

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

{===================================================================}
Procedure TGenericLetterPrintForm.PrintButtonClick(Sender: TObject);

var
  TextFileName, SortFileName,
  TempIndex, NewFileName, sSpreadsheetFileName : String;
  ReturnCode, I, J : Integer;
  ShowPrintDialog, Continue, Quit, Cancelled : Boolean;

begin
  Quit := False;
  UseWordLetterTemplate := UseWordLettersCheckBox.Checked;
  MergeFieldsToPrint.Assign(MergeFieldsUsedListBox.Items);
  bActiveParcelsOnly := cbxActiveParcelsOnly.Checked;
  bExtractToExcel := cbExtractToExcel.Checked;

  Application.ProcessMessages;

    {CHG10121998-1: Add user options for default destination and show vet max msg.}

  SetPrintToScreenDefault(PrintDialog);

    {FXX03302000-2: Make sure that the letter text is saved prior to printing.}

  Continue := True;

  If (LetterTextTable.State in [dsEdit, dsInsert])
    then
      begin
        ReturnCode := MessageDlg('Do you want to save the changes to the letter text before printing?' + #13 +
                                 'Selecting No means discard all changes and print.' + #13 +
                                 'Selecting Cancel means stop now and don''t print.', mtConfirmation,
                                 [mbYes, mbNo, mbCancel], 0);
        case ReturnCode of
          idYes : LetterTextTable.Post;
          idNo : LetterTextTable.Cancel;
          idCancel : Continue := False;
        end;

      end;  {If (LetterTextTable.State in [dsEdit, dsInsert])}

  If (Continue and
      ValidSelections)
    then
      begin
        SelectedExemptionCodes := TStringList.Create;
        SelectedSpecialDistricts := TStringList.Create;
        SelectedBankCodes := TStringList.Create;
        SelectedZipCodes := TStringList.Create;
        SelectedSwisCodes := TStringList.Create;
        SelectedRollSections := TStringList.Create;
        SelectedPropertyClasses := TStringList.Create;
        SelectedSchoolCodes := TStringList.Create;

        PrintAllExemptions := False;
        PrintAllSpecialDistricts := False;
        PrintAllBankCodes := False;
        PrintAllSwisCodes := False;
        PrintAllSchoolCodes := False;
        PrintAllRollSections := False;
        PrintAllPropertyClasses := False;
        PrintedDate := StrToDate(DatePrintedEdit.Text);

        LoadFromParcelList := LoadFromParcelListCheckBox.Checked;
        CreateParcelList := CreateParcelListCheckBox.Checked;

        with ExemptionListBox do
          If (SelCount = Items.Count)
            then PrintAllExemptions := True
            else
              For I := 0 to (Items.Count - 1) do
                If Selected[I]
                  then SelectedExemptionCodes.Add(Take(5, Items[I]));

        with SpecialDistrictListBox do
          If (SelCount = Items.Count)
            then PrintAllSpecialDistricts := True
            else
              For I := 0 to (Items.Count - 1) do
                If Selected[I]
                  then SelectedSpecialDistricts.Add(Take(5, Items[I]));

        with SwisCodeListBox do
          If (SelCount = Items.Count)
            then PrintAllSwisCodes := True
            else
              For I := 0 to (Items.Count - 1) do
                If Selected[I]
                  then SelectedSwisCodes.Add(Take(6, Items[I]));

        with SchoolCodeListBox do
          If (SelCount = Items.Count)
            then PrintAllSchoolCodes := True
            else
              For I := 0 to (Items.Count - 1) do
                If Selected[I]
                  then SelectedSchoolCodes.Add(Take(6, Items[I]));

        with RollSectionListBox do
          If (SelCount = Items.Count)
            then PrintAllRollSections := True
            else
              For I := 0 to (Items.Count - 1) do
                If Selected[I]
                  then SelectedRollSections.Add(Take(1, Items[I]));

        with PropertyClassListBox do
          If (SelCount = Items.Count)
            then PrintAllPropertyClasses := True
            else
              For I := 0 to (Items.Count - 1) do
                If Selected[I]
                  then SelectedPropertyClasses.Add(Take(3, Items[I]));

        If AllBanksCheckBox.Checked
          then PrintAllBankCodes := True
          else
            with BanksStringGrid do
              For I := 0 to (ColCount - 1) do
                For J := 0 to (RowCount - 1) do
                  If (Deblank(Cells[I, J]) <> '')
                    then SelectedBankCodes.Add(Trim(Cells[I, J]));

          {CHG02252004-3(2.08): Allow them to select zip codes.}

        with ZipCodesStringGrid do
          For I := 0 to (ColCount - 1) do
            For J := 0 to (RowCount - 1) do
              If (Deblank(Cells[I, J]) <> '')
                then SelectedZipCodes.Add(Trim(Cells[I, J]));

        PrintBySwisCode := PrintBySwisCodeCheckBox.Checked;
        PrintLetterHead := LetterHeadCheckBox.Checked;
        PrintDuplicates := PrintDuplicatesCheckBox.Checked;

        If (AssessmentYearRadioGroup.ItemIndex = 0)
          then AssessmentYear := GlblThisYear
          else AssessmentYear := GlblNextYear;

        ReportType := ReportTypeRadioGroup.ItemIndex;
        PrintOrder := PrintOrderRadioGroup.ItemIndex;
        PrintSuborder := PrintSuborderRadioGroup.ItemIndex;
        ParcelType := ParcelTypeRadioGroup.ItemIndex;

          {CHG04242000-1: Add signature file capabilites to ex, generic letters.}

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

        If (Deblank(SignatureFile) <> '')
          then
            begin
              SignatureImage := TBitmap.Create;
              SignatureImage.LoadFromFile(SignatureFile);
            end;

        LetterTextCode := LetterTextTableMainCode.Text;

        LettersCancelled := False;

          {CHG02021999-1: Allow user to either include or exclude selected
                          exemptions or special districts.}
          {CHG07281999-1: Allow user to look exclusively for an exemption or SD.}

        IncludeExemptions := ExemptionInclusionRadioGroup.ItemIndex;
        IncludeSpecialDistricts := SDInclusionRadioGroup.ItemIndex;

          {FXX12281999-1: Use the enhanced STAR dialog.}

        If ((SelectedExemptionCodes.Count = 1) and
            (SelectedExemptionCodes[0] = '41834'))
          then
            begin
              EnhancedSTARTypeDialog.ShowModal;
              EnhancedSTARType := EnhancedSTARTypeDialog.EnhancedSTARType;
            end;

        ShowPrintDialog := True;

        If (UseWordLetterTemplate and
            (ReportType = rtLetters))
          then
            begin
              LetterExtractFileName := GetPrintFileName('GenericLetter', True);

              try
                AssignFile(LetterExtractFile, LetterExtractFileName);
                Rewrite(LetterExtractFile);
              except
              end;

                {Create the header record.}

              For I := 0 to (MergeFieldsToPrint.Count - 1) do
                begin
                  If (I > 0)
                    then Write(LetterExtractFile, ',');

                  Write(LetterExtractFile, '"', MergeFieldsToPrint[I], '"');

                end;  {For I := 0 to (MergeFieldsToPrint.Count - 1) do}

              Writeln(LetterExtractFile);

              ShowPrintDialog := False;

            end;  {If (UseWordLetterTemplate and ...}

        If ((ShowPrintDialog and
             PrintDialog.Execute) or
            (not ShowPrintDialog))
          then
            begin
                {FXX09301998-1: Disable print button after clicking to avoid clicking twice.}

              PrintButton.Enabled := False;
              RollSectionList := TList.Create;
              SchoolCodeList := TList.Create;
              SwisCodeList := TList.Create;
              PropertyClassList := TList.Create;
              ExemptionCodeList := TList.Create;
              SDCodeList := TList.Create;

              LoadCodeList(RollSectionList, 'ZRollSectionTbl',
                           'MainCode', 'Description', Quit);
              LoadCodeList(SchoolCodeList, SchoolCodeTableName,
                           'SchoolCode', 'SchoolName', Quit);
              LoadCodeList(SwisCodeList, SwisCodeTableName,
                           'SwisCode', 'MunicipalityName', Quit);
              LoadCodeList(PropertyClassList, 'ZPropClsTbl',
                           'MainCode', 'Description', Quit);
              LoadCodeList(ExemptionCodeList, ExemptionCodesTableName,
                           'EXCode', 'Description', Quit);
              LoadCodeList(SDCodeList, SdistCodeTableName,
                           'SDistCode', 'Description', Quit);

                {Set the index for the sort table.}

              TempIndex := 'SwisCodeKey+';

              case PrintOrder of
                poParcelID : TempIndex := TempIndex + 'SBLKey';
                poRollSection : TempIndex := TempIndex + 'RollSection';
                poSchoolCode : TempIndex := TempIndex + 'SchoolCode';
                poExemptionCode : TempIndex := TempIndex + 'EXCode';
                poSpecialDistrict : TempIndex := TempIndex + 'SDCode';
                poBankCode : TempIndex := TempIndex + 'BankCode';
                poPropertyClass : TempIndex := TempIndex + 'PropertyClass';

                  {FXX09071999-2: Add indexes by just and just address.}

                poName : TempIndex := TempIndex + 'Name1';
                poAddress : TempIndex := TempIndex + 'LegalAddr+LegalAddrNo';

              end;  {case PrintOrder of}

              If not (PrintOrder in [poParcelID, poName, poAddress])
                then
                  case PrintSuborder of
                    psParcelID : TempIndex := TempIndex + '+SBLKey';
                    psAddress : TempIndex := TempIndex + '+LegalAddr+LegalAddrNo';
                    psName : TempIndex := TempIndex + '+Name1';
                    psZipCode : TempIndex := TempIndex + '+ZipCode+ZipPlus4';

                  end;  {case PrintSuborder of}

                {Make sure that the tables are open for the correct assessment year and
                 copy and open the sort file.}

              SortTable.IndexName := '';
              CopyAndOpenSortFile(SortTable, 'GenericLetters',
                                  OrigSortFileName, SortFileName,
                                  True, True, Quit);

              SortTable.AddIndex('LettersSearchIndex',
                                 TempIndex, [ixExpression]);
              SortTable.IndexName := 'LettersSearchIndex';

              If not Quit
                then
                  begin
                    ProcessingType := GetProcessingTypeForTaxRollYear(AssessmentYear);

                    OpenTableForProcessingType(ParcelTable, ParcelTableName, ProcessingType, Quit);
                    OpenTableForProcessingType(AssessmentTable, AssessmentTableName, ProcessingType, Quit);
                    OpenTableForProcessingType(ParcelExemptionTable, ExemptionsTableName, ProcessingType, Quit);
                    OpenTableForProcessingType(ParcelSDTable, SpecialDistrictTableName, ProcessingType, Quit);

                  end;  {If not Quit}

              If not Quit
                then SortFiles;

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

                {FXX07131998-2: Each section has its own report printer components.}

              If not (Quit or LettersCancelled)
                then
                  begin
                    If (ReportType = rtBoth)
                      then MessageDlg('Since you wish to print both letters and reports, the letters' + #13 +
                                      'will completely print first.  Then you will have an opportunity' + #13 +
                                      'choose the settings for the report section (print to screen or a' + #13 +
                                      'particular printer).' + #13 + #13 +
                                      'Click OK to start printing the letters.', mtInformation, [mbOK], 0);

                    ProgressDialog.Reset;
                    ProgressDialog.TotalNumRecords := GetRecordCount(SortTable);

                      {CHG06092010-5(2.26.1): Add extract to Excel.}

                    If bExtractToExcel
                    then
                    begin
                      sSpreadsheetFileName := GetPrintFileName(Self.Caption, True);
                      AssignFile(flExtract, sSpreadsheetFileName);
                      Rewrite(flExtract);
                      WritelnCommaDelimitedLine(flExtract,
                                                ['Parcel ID',
                                                 'Owner',
                                                 'Legal Address',
                                                 'School',
                                                 'RS',
                                                 'Land Value',
                                                 'Assessed Value',
                                                 'Res %',
                                                 'Prop Cls',
                                                 'Homestead',
                                                 'Bank',
                                                 'Acreage',
                                                 'Ownership']);

                    end;

                      {Print the letters.}

                    If (ReportType in [rtLetters, rtBoth])
                      then
                        If UseWordLetterTemplate
                          then PrintWordLetters
                          else
                            begin
                                {CHG10131998-1: Set the printer settings based on what printer they selected
                                                only - they no longer need to worry about paper or landscape
                                                mode.}

                              AssignPrinterSettings(PrintDialog, LetterPrinter, LetterFiler, [ptLaser], False, Quit);

                              If PrintDialog.PrintToFile
                                then
                                  begin
                                    NewFileName := GetPrintFileName(Self.Caption, True);
                                    LetterFiler.FileName := NewFileName;

                                    try
                                      PreviewForm := TPreviewForm.Create(self);
                                      PreviewForm.FilePrinter.FileName := NewFileName;
                                      PreviewForm.FilePreview.FileName := NewFileName;

                                      LetterFiler.Execute;

                                      PreviewForm.ShowModal;
                                    finally
                                      PreviewForm.Free;

                                        {CHG01182000-3: Allow them to choose a different name or copy right away.}
                                        {However, we can only do it if they print to screen first since
                                         report printer does not generate a file.}

                                      ShowReportDialog('GENERIC.LTR', ReportFiler.FileName, True);

                                    end;  {If PrintRangeDlg.PreviewPrint}

                                  end  {They did not select preview, so we will go
                                        right to the printer.}
                                else LetterPrinter.Execute;

                            end;  {else of If UseWordLetterTemplate}

                    If (ReportType in [rtReport, rtBoth])
                      then
                        begin
                          Cancelled := False;

                          ProgressDialog.Reset;
                          ProgressDialog.TotalNumRecords := GetRecordCount(SortTable);

                            {If they printed letters, put up the dialog box again since they
                             will need to go to a different printer or choose different paper.}

                          If (ReportType = rtBoth)
                            then
                              begin
                                MessageDlg('The report will now be printed.' + #13 +
                                           'After clicking OK, the print option box will appear and' + #13 +
                                           'let you select different paper or a different printer.',
                                           mtInformation, [mbOK], 0);

                                Cancelled := not PrintDialog.Execute;

                              end;  {If (ReportType = rtBoth)}

                            {Print the report.}

                          If not Cancelled
                            then
                              begin
                                  {CHG10131998-1: Set the printer settings based on what printer they selected
                                                  only - they no longer need to worry about paper or landscape
                                                  mode.}

                                AssignPrinterSettings(PrintDialog, ReportPrinter, ReportFiler, [ptBoth], True, Quit);

                                ReportTextFiler.SetFont('Courier New', 10);
                                TextFileName := GetPrintFileName(Self.Caption, True);
                                ReportTextFiler.FileName := TextFileName;
                                ReportTextFiler.LastPage := 30000;

                                ReportTextFiler.Execute;

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
                                          {Now delete the file.}
                                        try
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

                                  {Now rename the text file to a recognizable
                                   name, but to do so, erase the original first.
                                   This is so that several people can run this job
                                   at once.}

                                ShowReportDialog('LETTERS.RPT', ReportTextFiler.FileName, True);

                              end;  {else of If not Cancelled}

                        end;  {If (ReportType in [rtReport, rtBoth])}

                  end;  {If not LettersCancelled}

            If bExtractToExcel
              then
                begin
                  CloseFile(flExtract);
                  SendTextFileToExcelSpreadsheet(sSpreadsheetFileName, True,
                                                 False, '');

                end;  {If bExtractToExcel}

              SortTable.Close;

              try
                Chdir(GlblDataDir);
                OldDeleteFile(SortFileName);
              except
              end;

              FreeTList(RollSectionList, SizeOf(CodeRecord));
              FreeTList(SchoolCodeList, SizeOf(CodeRecord));
              FreeTList(SwisCodeList, SizeOf(CodeRecord));
              FreeTList(PropertyClassList, SizeOf(CodeRecord));
              FreeTList(ExemptionCodeList, SizeOf(CodeRecord));
              FreeTList(SDCodeList, SizeOf(CodeRecord));

              ProgressDialog.Finish;

              If CreateParcelList
                then ParcelListDialog.Show;

                {FXX10111999-3: Tell people that printing is starting and
                                done.}

              DisplayPrintingFinishedMessage(PrintDialog.PrintToFile);

              ResetPrinter(ReportPrinter);

            end;  {If PrintDialog.Execute}

        SelectedExemptionCodes.Free;
        SelectedSpecialDistricts.Free;
        SelectedBankCodes.Free;
        SelectedSwisCodes.Free;
        SelectedRollSections.Free;
        SelectedPropertyClasses.Free;
        SelectedSchoolCodes.Free;
        SelectedZipCodes.Free;

        If (Deblank(SignatureFile) <> '')
          then SignatureImage.Free;

      end;  {If ValidSelections}

  PrintButton.Enabled := True;

end;  {PrintButtonClick}

{========================================================================}
Procedure TGenericLetterPrintForm.PrintSelectionPage(Sender : TObject);

{FXX08041998-1: Add selection page.}

var
  TempStr : String;

begin
  with Sender as TBaseReport do
    begin
      NewPage;
      ClearTabs;
      SetTab(0.4, pjLeft, 7.0, 0, BoxLineNone, 0);  {Header}

      Println('');
      Println(#9 + '  SELECTIONS CHOOSEN:  ');
      Println('');
      Println(#9 + 'Letters Printed = ' + IntToStr(NumLettersPrinted));
      Println('');

      If LettersCancelled
        then
          begin
            Println(#9 + '>>> The letter printing was cancelled. <<<');
            Println('');
          end;

      Println(#9 + 'Assessment Year: ' + AssessmentYear);

      case ReportType of
        rtLetters : TempStr := 'Letters Only.';
        rtReport : TempStr := 'Report Only';
        rtBoth : TempStr := 'Letters and Report';
      end;
      Println(#9 + 'Report Type: ' + TempStr);

      case PrintOrder of
        poParcelID : TempStr := 'Parcel ID';
        poRollSection : TempStr := 'Roll Section';
        poSchoolCode : TempStr := 'School Code';
        poExemptionCode : TempStr := 'Exemption Code';
        poSpecialDistrict : TempStr := 'Special District';
        poBankCode : TempStr := 'Bank Code';
        poPropertyClass : TempStr := 'Property Class';
          {FXX09071999-1: Add print by name and addr.}

        poName : TempStr := 'Name';
        poAddress : TempStr := 'Legal Address';

      end;  {case PrintOrder of}

      case PrintSuborder of
        psParcelID : TempStr := TempStr + ' \ Parcel ID';
        psAddress : TempStr := TempStr + ' \ Address';
        psName : TempStr := TempStr + ' \ Name';
        psZipCode : TempStr := TempStr + ' \ Zip Code';
      end;
      Println(#9 + 'Print Order: ' + TempStr);

      case ParcelType of
        ptAllParcels : TempStr := 'All Parcels.';
        ptComInvParcels : TempStr := 'Parcels with Commercial Inventory';
        ptResInvParcels : TempStr := 'Parcels with Residential Inventory';
      end;
      Println(#9 + 'Parcel Type : ' + TempStr);

      If PrintBySwisCode
        then Println(#9 + 'Print by swis code');

      If PrintLetterHead
        then Println(#9 + 'Property Assessment System prints letterhead from assessor''s office table.');

      If PrintDuplicates
        then Println(#9 + 'Print Duplicates.');

      If PrintAllExemptions
        then Println(#9 + 'Print all exemptions.')
        else PrintSelectedList(Sender, SelectedExemptionCodes, 'exemptions');

          {CHG02021999-1: Allow user to either include or exclude selected
                          exemptions or special districts.}

      case IncludeExemptions of
        stHasCode : Println(#9 + '    Parcels that have the listed exemptions will be printed.');
        stDoesNotHaveCode : Println(#9 + '    Parcels that do not have any of the listed exemptions will be printed.');
        stOnlyHasCode : Println(#9 + '    Parcels that have only the selected exemption will be printed.');
      end;

      If PrintAllSpecialDistricts
        then Println(#9 + 'Print all special districts.')
        else PrintSelectedList(Sender, SelectedSpecialDistricts, 'special districts');

      case IncludeSpecialDistricts of
        stHasCode : Println(#9 + '    Parcels that have the listed special districts will be printed.');
        stDoesNotHaveCode : Println(#9 + '    Parcels that do not have any of the listed special ' +
                                         'districts will be printed.');
        stOnlyHasCode : Println(#9 + '    Parcels that only have the selected special district will be printed.');
      end;

      If PrintAllBankCodes
        then Println(#9 + 'Print all bank codes.')
        else PrintSelectedList(Sender, SelectedBankCodes, 'bank codes');

        {CHG02252004-3(2.08): Allow them to select zip codes.}

      If (SelectedZipCodes.Count = 0)
        then Println(#9 + 'Print all zip codes.')
        else PrintSelectedList(Sender, SelectedZipCodes, 'zip codes');

      If PrintAllSchoolCodes
        then Println(#9 + 'Print all school codes.')
        else PrintSelectedList(Sender, SelectedSchoolCodes, 'school codes');

      If PrintAllSwisCodes
        then Println(#9 + 'Print all swis codes.')
        else PrintSelectedList(Sender, SelectedSwisCodes, 'swis codes');

      If PrintAllRollSections
        then Println(#9 + 'Print all roll sections.')
        else PrintSelectedList(Sender, SelectedRollSections, 'roll sections');

      If PrintAllPropertyClasses
        then Println(#9 + 'Print all property classes.')
        else PrintSelectedList(Sender, SelectedPropertyClasses, 'property classes');

      If ((SelectedExemptionCodes.Count = 1) and
          (SelectedExemptionCodes[0] = '41834'))
        then
          case EnhancedSTARType of
            enSeniorSTAROnly : Println(#9 + 'Print parcels with senior STAR but no senior exemption.');
            enWithSeniorandSTARExemption : Println(#9 + 'Print parcels with both senior STAR and senior exemptions.');
          end;

    end;  {with Sender as TBaseReport do}

end;  {PrintSelectionPage}

{================================================================================}
Procedure InitTotalsRec(var TotalsRec : TotalsRecord);

begin
  with TotalsRec do
    begin
      LandVal := 0;
      AssessedVal := 0;
      Acres := 0;
      Count := 0;
    end;  {with TotalsRec do}

end;  {InitTotalsRec}

{================================================================================}
Procedure UpdateTotals(var TotalsRec : TotalsRecord;
                           ParcelTable,
                           AssessmentTable : TTable);

begin
  with TotalsRec do
    begin
      LandVal := LandVal + AssessmentTable.FieldByName('LandAssessedVal').AsFloat;
      AssessedVal := AssessedVal + AssessmentTable.FieldByName('TotalAssessedVal').AsFloat;
      Acres := Acres + ParcelTable.FieldByName('Acreage').AsFloat;
      Count := Count + 1;
    end;  {with TotalsRec do}

end;  {UpdateTotals}

{================================================================================}
Procedure PrintTotals(Sender : TObject;
                      TotalsRec : TotalsRecord;
                      Header : String);

begin
  with Sender as TBaseReport, TotalsRec do
    begin
      ClearTabs;
      SetTab(0.2, pjLeft, 4.5, 0, BoxLineNone, 0);  {Header}
      SetTab(4.9, pjLeft, 7.0, 0, BoxLineNone, 0);  {Count}
      SetTab(7.9, pjRight, 1.0, 0, BoxLineNone, 0);  {Land value}
      SetTab(9.0, pjRight, 1.2, 0, BoxLineNone, 0);  {Assessed value}
      SetTab(12.2, pjRight, 0.8, 0, BoxLineNone, 0);  {Acres}

      Println(#9 + 'TOTALS FOR ' + Trim(Header) + ':' +
              #9 + 'COUNT: ' + IntToStr(Count) +
              #9 + FormatFloat(CurrencyDisplayNoDollarSign, LandVal) +
              #9 + FormatFloat(CurrencyDisplayNoDollarSign, AssessedVal) +
              #9 + FormatFloat(DecimalDisplay_BlankZero, Acres));

    end;  {with Sender as TBaseReport, TotalsRec do}

end;  {PrintTotals}

{================================================================================}
Procedure TGenericLetterPrintForm.ReportTextFilerBeforePrint(Sender: TObject);

begin
  SortTable.First;
  LastSwisCode := SortTable.FieldByName('SwisCode').Text;
end;

{================================================================================}
Procedure TGenericLetterPrintForm.ReportTextFilerPrintHeader(Sender: TObject);

var
  TempSwisCode, ReportTypeString : String;

begin
    {Print the date and page number.}

  with Sender as TBaseReport do
    begin
      ClearTabs;
      SetTab(0.2, pjLeft, 13.0, 0, BoxLineNone, 0);

      Println(Take(43, UpcaseStr(GetMunicipalityName)) +
              Center('LETTER PRINT REPORT', 43) +
              RightJustify('Page: ' + IntToStr(CurrentPage), 43));

      case PrintOrder of
        poParcelID : ReportTypeString := 'PARCEL ID';
        poRollSection : ReportTypeString := 'ROLL SECTION';
        poSchoolCode :  ReportTypeString := 'SCHOOL DISTRICT';
        poExemptionCode :  ReportTypeString := 'EXEMPTION CODE';
        poSpecialDistrict :  ReportTypeString := 'SPECIAL DISTRICT';
        poBankCode :  ReportTypeString := 'BANK CODE';
        poPropertyClass : ReportTypeString := 'PROPERTY CLASS';
        poName : ReportTypeString := 'NAME';
        poAddress : ReportTypeString := 'ADDRESS';

      end;  {case PrintOrder of}

      If (PrintOrder in [poRollSection, poPropertyClass])
        then
          case PrintSuborder of
            psParcelID : ReportTypeString := ReportTypeString + '\PARCEL ID';
            psAddress : ReportTypeString := ReportTypeString + '\ADDRESS';
            psName : ReportTypeString := ReportTypeString + '\NAME';
            psZipCode : ReportTypeString := ReportTypeString + '\ZIP CODE';

          end;  {case PrintSuborder of}

      ReportTypeString := ReportTypeString + ' ORDER';

      If PrintBySwisCode
        then TempSwisCode := LastSwisCode
        else TempSwisCode := Take(4, LastSwisCode);

      Println(Take(43, 'SWIS - ' + TempSwisCode) +
              Center(ReportTypeString, 43) +
              RightJustify('Date: ' + DateToStr(Date) +
                           '  Time: ' + TimeToStr(Now), 43));

      Println('');

    end;  {with Sender as TBaseReport do}

    {Set the tabs for the header.}

  with Sender as TBaseReport do
    begin
      ClearTabs;
      SetTab(0.2, pjCenter, 2.5, 0, BoxLineNone, 0);  {Parcel ID}
      SetTab(2.8, pjCenter, 2.0, 0, BoxLineNone, 0);  {Name}
      SetTab(4.9, pjCenter, 2.0, 0, BoxLineNone, 0);  {Address}
      SetTab(7.0, pjCenter, 0.6, 0, BoxLineNone, 0);  {School}
      SetTab(7.7, pjCenter, 0.1, 0, BoxLineNone, 0);  {RS}
      SetTab(7.9, pjCenter, 1.0, 0, BoxLineNone, 0);  {Land value}
      SetTab(9.0, pjCenter, 1.2, 0, BoxLineNone, 0);  {Assessed value}
      SetTab(10.3, pjCenter, 0.3, 0, BoxLineNone, 0);  {Res %}
      SetTab(10.7, pjCenter, 0.3, 0, BoxLineNone, 0);  {Prop class}
      SetTab(11.2, pjCenter, 0.1, 0, BoxLineNone, 0);  {HC}
      SetTab(11.4, pjCenter, 0.7, 0, BoxLineNone, 0);  {Bank}
      SetTab(12.2, pjCenter, 0.8, 0, BoxLineNone, 0);  {Acres}
      SetTab(13.1, pjCenter, 0.1, 0, BoxLineNone, 0);  {Ownership code}

      Println(#9 + #9 + #9 +
              #9 + 'SCHOOL' +
              #9 + 'R' +
              #9 + 'LAND' +
              #9 + 'ASSESSED' +
              #9 + 'RES' +
              #9 + 'PRP' +
              #9 + 'H' +
              #9 + 'BANK' +
              #9 +
              #9 + 'O');

      Println(#9 + 'PARCEL ID' +
              #9 + 'OWNER NAME' +
              #9 + 'ADDRESS' +
              #9 + 'CODE' +
              #9 + 'S' +
              #9 + 'VALUE' +
              #9 + 'VALUE' +
              #9 + ' %' +
              #9 + 'CLS' +
              #9 + 'C' +
              #9 + 'CODE' +
              #9 + 'ACRES' +
              #9 + 'C');

      Println('');

      ClearTabs;
      SetTab(0.2, pjLeft, 2.5, 0, BoxLineNone, 0);  {Parcel ID}
      SetTab(2.8, pjLeft, 2.0, 0, BoxLineNone, 0);  {Name}
      SetTab(4.9, pjLeft, 2.0, 0, BoxLineNone, 0);  {Address}
      SetTab(7.0, pjLeft, 0.6, 0, BoxLineNone, 0);  {School}
      SetTab(7.7, pjLeft, 0.1, 0, BoxLineNone, 0);  {RS}
      SetTab(7.9, pjRight, 1.0, 0, BoxLineNone, 0);  {Land value}
      SetTab(9.0, pjRight, 1.2, 0, BoxLineNone, 0);  {Assessed value}
      SetTab(10.3, pjRight, 0.3, 0, BoxLineNone, 0);  {Res %}
      SetTab(10.8, pjLeft, 0.3, 0, BoxLineNone, 0);  {Prop class}
      SetTab(11.2, pjLeft, 0.1, 0, BoxLineNone, 0);  {HC}
      SetTab(11.4, pjLeft, 0.7, 0, BoxLineNone, 0);  {Bank}
      SetTab(12.2, pjRight, 0.8, 0, BoxLineNone, 0);  {Acres}
      SetTab(13.1, pjLeft, 0.1, 0, BoxLineNone, 0);  {Ownership code}

    end;  {with Sender as TBaseReport do}

end;  {ReportPrinterPrintHeader}

{================================================================================}
Procedure TGenericLetterPrintForm.ReportTextFilerPrint(Sender: TObject);

var
  GroupChanged,
  FirstTimeThrough, Done, SwisCodesDifferent : Boolean;
  ParcelsPrinted : LongInt;
  SwisSBLKey : String;
  SBLRec : SBLRecord;
  Header : String;
  GroupTotalsRec, SwisTotalsRec, OverallTotalsRec : TotalsRecord;

begin
  FirstTimeThrough := True;
  Done := False;
  ParcelsPrinted := 0;

  SortTable.First;
  ProgressDialog.UserLabelCaption := 'Printing report.';
  LastSchoolCode := SortTable.FieldByName('SchoolCode').Text;
  LastRollSection := SortTable.FieldByName('RollSection').Text;
  LastExemptionCode := SortTable.FieldByName('EXCode').Text;
  LastSDCode := SortTable.FieldByName('SDCode').Text;
  LastBankCode := SortTable.FieldByName('BankCode').Text;
  LastPropertyClass := SortTable.FieldByName('PropertyClass').Text;

  InitTotalsRec(GroupTotalsRec);
  InitTotalsRec(SwisTotalsRec);
  InitTotalsRec(OverallTotalsRec);

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else SortTable.Next;

    If SortTable.EOF
      then Done := True;

    Application.ProcessMessages;
    ProgressDialog.Update(Self, 'Parcels Printed = ' + IntToStr(ParcelsPrinted));

    SwisSBLKey := SortTable.FieldByName('SwisCode').Text +
                  SortTable.FieldByName('SBLKey').Text;
    ParcelsPrinted := ParcelsPrinted + 1;

    with Sender as TBaseReport do
      begin
        SwisCodesDifferent := (LastSwisCode <> SortTable.FieldByName('SwisCode').Text);
        GroupChanged := False;

        with SortTable do
          case PrintOrder of
            poRollSection : If ((LastRollSection <> FieldByName('RollSection').Text) or
                                Done)
                              then
                                begin
                                  Header := 'RS ' + LastRollSection +  ' (' +
                                            Trim(GetDescriptionFromList(LastRollSection, RollSectionList)) + ')';
                                  GroupChanged := True;
                                end;

            poSchoolCode :  If ((LastSchoolCode <> FieldByName('SchoolCode').Text) or
                                Done)
                              then
                                begin
                                  Header := 'SCHOOL ' + LastSchoolCode + ' (' +
                                            Trim(GetDescriptionFromList(LastSchoolCode, SchoolCodeList)) + ')';

                                  GroupChanged := True;
                                end;

            poExemptionCode :  If ((LastExemptionCode <> FieldByName('EXCode').Text) or
                                   Done)
                                 then
                                   begin
                                     Header := 'EXEMPTION ' + LastExemptionCode + ' (' +
                                               Trim(GetDescriptionFromList(LastExemptionCode, ExemptionCodeList)) + ')';
                                     GroupChanged := True;
                                   end;

            poSpecialDistrict :  If ((LastSDCode <> FieldByName('SDCode').Text) or
                                     Done)
                                   then
                                     begin
                                       Header := 'SD CODE ' + LastSDCode + ' (' +
                                                 Trim(GetDescriptionFromList(LastSDCode, SDCodeList)) + ')';
                                       GroupChanged := True;
                                     end;

            poBankCode :  If ((LastBankCode <> FieldByName('BankCode').Text) or
                              Done)
                            then
                              begin
                                Header := 'BANK ' + LastBankCode;
                                GroupChanged := True;
                              end;

            poPropertyClass :  If ((LastPropertyClass <> FieldByName('PropertyClass').Text) or
                                   Done)
                                 then
                                   begin
                                     Header := 'PROP CLS ' + LastPropertyClass + ' (' +
                                               Trim(GetDescriptionFromList(LastPropertyClass, PropertyClassList)) + ')';
                                     GroupChanged := True;
                                   end;

          end;  {case PrintSuborder of}

           {Print group totals, but never for by parcel id.}

        If ((PrintOrder <> poParcelID) and
            GroupChanged)
          then
            begin
              Println('');
              PrintTotals(Sender, GroupTotalsRec, Header);
              InitTotalsRec(GroupTotalsRec);

                {Go to a new page if not going to print swis totals.}

              If (not ((SwisCodesDifferent and
                        PrintBySwisCode) or
                       Done))
                then NewPage;

            end;  {If (GroupChanged or Done)}

          {Print swis totals.}

        If (PrintBySwisCode and
            (SwisCodesDifferent or
             Done))
          then
            begin
              Println('');
              PrintTotals(Sender, SwisTotalsRec,
                          'SWIS ' + LastSwisCode + ' (' +
                          Trim(GetDescriptionFromList(LastSwisCode, SwisCodeList)) + ')');
              InitTotalsRec(SwisTotalsRec);

              If not Done
                then NewPage;

            end;  {If ((SwisCodeDifferent and ...}

        If (LinesLeft < 8)
          then NewPage;

          {Update the break codes.}

        LastSwisCode := SortTable.FieldByName('SwisCode').Text;
        LastSchoolCode := SortTable.FieldByName('SchoolCode').Text;
        LastRollSection := SortTable.FieldByName('RollSection').Text;
        LastExemptionCode := SortTable.FieldByName('EXCode').Text;
        LastSDCode := SortTable.FieldByName('SDCode').Text;
        LastBankCode := SortTable.FieldByName('BankCode').Text;
        LastPropertyClass := SortTable.FieldByName('PropertyClass').Text;

        SBLRec := ExtractSwisSBLFromSwisSBLKey(SwisSBLKey);

        with SBLRec do
          FindKeyOld(ParcelTable,
                     ['TaxRollYr', 'SwisCode', 'Section',
                      'Subsection', 'Block', 'Lot', 'Sublot',
                      'Suffix'],
                     [AssessmentYear, SwisCode, Section, Subsection, Block, Lot,
                      Sublot, Suffix]);

        FindKeyOld(AssessmentTable, ['TaxRollYr', 'SwisSBLKey'],
                   [AssessmentYear, SwisSBLKey]);

        If not Done
          then
            begin
              with ParcelTable do
                Println(#9 + ConvertSwisSBLToDashDot(SwisSBLKey) +
                        #9 + Take(19, FieldByName('Name1').Text) +
                        #9 + Take(19, GetLegalAddressFromTable(SortTable)) +
                        #9 + FieldByName('SchoolCode').Text +
                        #9 + FieldByName('RollSection').Text +
                        #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                                         AssessmentTable.FieldByName('LandAssessedVal').AsFloat) +
                        #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                                         AssessmentTable.FieldByName('TotalAssessedVal').AsFloat) +
                        #9 + FormatFloat(CurrencyEditDisplay,
                                         FieldByName('ResidentialPercent').AsFloat) +
                        #9 + FieldByName('PropertyClassCode').Text +
                        #9 + FieldByName('HomesteadCode').Text +
                        #9 + FieldByName('BankCode').Text +
                        #9 + FormatFloat(DecimalDisplay_BlankZero,
                                         FieldByName('Acreage').AsFloat) +
                        #9 + FieldByName('OwnershipCode').Text);

              If bExtractToExcel
              then
                with ParcelTable do
                WritelnCommaDelimitedLine(flExtract,
                                          [ConvertSwisSBLToDashDot(SwisSBLKey),
                                           FieldByName('Name1').AsString,
                                           GetLegalAddressFromTable(SortTable),
                                           FieldByName('SchoolCode').AsString,
                                           FieldByName('RollSection').AsString,
                                           AssessmentTable.FieldByName('LandAssessedVal').AsFloat,
                                           AssessmentTable.FieldByName('TotalAssessedVal').AsFloat,
                                           FieldByName('ResidentialPercent').AsFloat,
                                           FieldByName('PropertyClassCode').AsString,
                                           FieldByName('HomesteadCode').AsString,
                                           FieldByName('BankCode').AsString,
                                           FormatFloat(DecimalDisplay_BlankZero,
                                                       FieldByName('Acreage').AsFloat),
                                           FieldByName('OwnershipCode').AsString]);

              UpdateTotals(GroupTotalsRec, ParcelTable, AssessmentTable);
              UpdateTotals(SwisTotalsRec, ParcelTable, AssessmentTable);
              UpdateTotals(OverallTotalsRec, ParcelTable, AssessmentTable);

            end;  {If not Done}

      end;  {with Sender as TBaseReport do}

    LettersCancelled := ProgressDialog.Cancelled;

  until (Done or LettersCancelled);

    {Print final totals.}

  with Sender as TBaseReport do
    begin
      Println('');
      PrintTotals(Sender, OverallTotalsRec, Take(4, SortTable.FieldByname('SwisCode').Text));
    end;

    {FXX08041998-1: Add selection page.}

  PrintSelectionPage(Sender);

end;  {ReportPrinterPrint}

{==================================================================}
Procedure InsertOneItem(DBMemoBuf : TDBMemoBuf;
                        InsertName : String;
                        Table : TTable;
                        FieldName : String);

{CHG11142003-1(2.07k): Allow for inserts.}

var
  FoundInsertCommand : Boolean;
  TempValue : String;

begin
  FoundInsertCommand := DBMemoBuf.SearchFirst(InsertName, False);

  If FoundInsertCommand
    then
      repeat
        DBMemoBuf.Delete(DBMemoBuf.Pos, Length(InsertName));

        If (Table = nil)
          then TempValue := FieldName
          else TempValue := Table.FieldByName(FieldName).Text;

        DBMemoBuf.Insert(DBMemoBuf.Pos, TempValue);

        FoundInsertCommand := DBMemoBuf.SearchNext;

      until (not FoundInsertCommand);

  DBMemoBuf.Pos := 0;

end;  {InsertOneItem}

{==================================================================}
Procedure TGenericLetterPrintForm.InsertInformationIntoMemo(DBMemoBuf : TDBMemoBuf;
                                                            SwisSBLKey : String);

{CHG11142003-1(2.07k): Allow for inserts.}

var
  LandAssessedValue, TotalAssessedValue,
  CountyTaxableValue, MunicipalTaxableValue, SchoolTaxableValue,
  VillageTaxableValue, BasicSTARAmount, EnhancedSTARAmount : LongInt;

begin
  InsertOneItem(DBMemoBuf, ParcelIDInsert, nil, ConvertSwisSBLToDashDot(SwisSBLKey));

  InsertOneItem(DBMemoBuf, LegalAddressInsert, nil, GetLegalAddressFromTable(ParcelTable));

  InsertOneItem(DBMemoBuf, OwnerInsert, ParcelTable, 'Name1');
  InsertOneItem(DBMemoBuf, PropertyClassInsert, ParcelTable, 'PropertyClassCode');
  InsertOneItem(DBMemoBuf, AccountNumberInsert, ParcelTable, 'AccountNo');

    {CHG11222004-2(2.8.1.1): Add inserts for assessed, taxable, exemption values.}

  DetermineAssessedAndTaxableValues(AssessmentYear, SwisSBLKey,
                                    ParcelTable.FieldByName('HomesteadCode').Text,
                                    ParcelExemptionTable, ExemptionCodeTable,
                                    AssessmentTable, LandAssessedValue, TotalAssessedValue,
                                    CountyTaxableValue, MunicipalTaxableValue, SchoolTaxableValue,
                                    VillageTaxableValue, BasicSTARAmount, EnhancedSTARAmount);

  InsertOneItem(DBMemoBuf, AssessedValueInsert, nil, FormatFloat(IntegerDisplay, TotalAssessedValue));
  InsertOneItem(DBMemoBuf, LandValueInsert, nil, FormatFloat(IntegerDisplay, LandAssessedValue));
  InsertOneItem(DBMemoBuf, CountyTaxableValueInsert, nil, FormatFloat(IntegerDisplay, CountyTaxableValue));
  InsertOneItem(DBMemoBuf, MunicipalTaxableValueInsert, nil, FormatFloat(IntegerDisplay, MunicipalTaxableValue));
  InsertOneItem(DBMemoBuf, SchoolTaxableValueInsert, nil, FormatFloat(IntegerDisplay, SchoolTaxableValue));
  InsertOneItem(DBMemoBuf, CountyExemptionTotalInsert, nil,
                FormatFloat(IntegerDisplay, (TotalAssessedValue - CountyTaxableValue)));
  InsertOneItem(DBMemoBuf, MunicipalExemptionTotalInsert, nil,
                FormatFloat(IntegerDisplay, (TotalAssessedValue - MunicipalTaxableValue)));
  InsertOneItem(DBMemoBuf, SchoolExemptionTotalInsert, nil,
                FormatFloat(IntegerDisplay, (TotalAssessedValue - SchoolTaxableValue)));

end;  {InsertInformationIntoMemo}

{==================================================================}
Procedure TGenericLetterPrintForm.ReportPrint(Sender: TObject);

var
  TempTextFile : TextFile;

begin
  AssignFile(TempTextFile, ReportTextFiler.FileName);
  Reset(TempTextFile);

        {CHG12211998-1: Add ability to select print range.}

  PrintTextReport(Sender, TempTextFile, PrintDialog.FromPage,
                  PrintDialog.ToPage);

  CloseFile(TempTextFile);

end;  {ReportPrint}

{================================================================================}
Procedure TGenericLetterPrintForm.PrintOneLetter(    Sender : TObject;
                                                     SwisSBLKey : String;
                                                 var FirstLetterPrinted : Boolean;
                                                 var LettersPrinted : LongInt);

{Print one letter.}

var
  NAddrArray : NameAddrArray;
  SBLRec : SBLRecord;
  DBMemoBuf : TDBMemoBuf;

begin
  DBMemoBuf := TDBMemoBuf.Create;

  SBLRec := ExtractSwisSBLFromSwisSBLKey(SwisSBLKey);

  with SBLRec do
    FindKeyOld(ParcelTable,
               ['TaxRollYr', 'SwisCode', 'Section',
                'Subsection', 'Block', 'Lot', 'Sublot',
                'Suffix'],
               [AssessmentYear, SwisCode, Section, Subsection, Block, Lot,
                Sublot, Suffix]);

  GetNameAddress(ParcelTable, NAddrArray);

  LettersPrinted := LettersPrinted + 1;

  ProgressDialog.UserLabelCaption := 'Letters Printed = ' + IntToStr(LettersPrinted);

    {skip newpage on 1st ltr, ReportPrinter has already printed hdr}

  with Sender as TBaseReport do
    begin
      If FirstLetterPrinted
        then FirstLetterPrinted := False
        else NewPage;

         {Print the header.}

      PrintLetterHeader(Sender, AssessorOfficeTable, NAddrArray,
                        PrintLetterHead, PrintedDate, True);

      ClearTabs;
      SetTab(1.0, pjLeft, 8.0,0, BOXLINENONE, 0);   {letter text}

        {FXX11021998-3: Avoid problem with no carriage returns in letter text.}
        {FXX11021999-13: Allow the letter left margin to be customized.}

      DBMemoBuf.RTFField := LetterTextTableLetterText;
      DBMemoBuf.PrintStart := GlblLetterLeftMargin;
      DBMemoBuf.PrintEnd := 8.2;

        {CHG11142003-1(2.07k): Allow for inserts.}

      InsertInformationIntoMemo(DBMemoBuf, SwisSBLKey);

      PrintMemo(DBMemoBuf, 0, False);

        {CHG02292000-1: Signature files}
        {FXX05012000-1: Need height and width for sig files.}
        {FXX06042001-2: Wrong variable for width and height}

      If (Deblank(SignatureFile) <> '')
        then PrintBitmapRect(SignatureXPos, SignatureYPos,
                             SignatureXPos + SignatureWidth,
                             SignatureYPos + SignatureHeight,
                             SignatureImage);

    end;  {with Sender as TBaseOject do}

  DBMemoBuf.Free;

end;  {PrintOneLetter}

{========================================================}
Procedure TGenericLetterPrintForm.LetterPrinterPrint(Sender: TObject);

var
  FirstTimeThrough, Done,
  FirstLetterPrinted : Boolean;
  SwisSBLKey : String;

begin
  FirstTimeThrough := True;
  Done := False;
  FirstLetterPrinted := True;
  NumLettersPrinted := 0;

  SortTable.First;
  ProgressDialog.UserLabelCaption := 'Printing letters.';

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else SortTable.Next;

    If SortTable.EOF
      then Done := True;

    If not Done
      then
        begin
          SwisSBLKey := SortTable.FieldByName('SwisCode').Text +
                        SortTable.FieldByName('SBLKey').Text;
          PrintOneLetter(Sender, SwisSBLKey, FirstLetterPrinted, NumLettersPrinted);

          If bExtractToExcel
          then
          begin
            _Locate(AssessmentTable, [AssessmentYear, SwisSBLKey], '', []);

            with ParcelTable do
            WritelnCommaDelimitedLine(flExtract,
                                      [ConvertSwisSBLToDashDot(SwisSBLKey),
                                       FieldByName('Name1').AsString,
                                       GetLegalAddressFromTable(SortTable),
                                       FieldByName('SchoolCode').AsString,
                                       FieldByName('RollSection').AsString,
                                       AssessmentTable.FieldByName('LandAssessedVal').AsFloat,
                                       AssessmentTable.FieldByName('TotalAssessedVal').AsFloat,
                                       FieldByName('ResidentialPercent').AsFloat,
                                       FieldByName('PropertyClassCode').AsString,
                                       FieldByName('HomesteadCode').AsString,
                                       FieldByName('BankCode').AsString,
                                       FormatFloat(DecimalDisplay_BlankZero,
                                                   FieldByName('Acreage').AsFloat),
                                       FieldByName('OwnershipCode').AsString]);

          end;  {If bExtractToExcel}
          
        end;  {If not Done}

    Application.ProcessMessages;
    ProgressDialog.Update(Self, 'Num Letters Printed = ' + IntToStr(NumLettersPrinted));
    LettersCancelled := ProgressDialog.Cancelled;

  until (Done or LettersCancelled);

    {FXX08041998-1: Add selection page.}

  If (ReportType = rtLetters)
    then PrintSelectionPage(Sender);

end;  {LetterPrinterPrint}

{===================================================================}
Procedure TGenericLetterPrintForm.InsertCodeButtonClick(Sender: TObject);

begin
  try
    LetterInsertCodesForm := TLetterInsertCodesForm.Create(nil);
    LetterInsertCodesForm.ShowModal;
  finally
    LetterInsertCodesForm.Free;
  end;

end;  {InsertCodeButtonClick}

{===================================================================}
Procedure TGenericLetterPrintForm.CloseButtonClick(Sender: TObject);

begin
  Close;
end;

{===================================================================}
Procedure TGenericLetterPrintForm.FormClose(    Sender: TObject;
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