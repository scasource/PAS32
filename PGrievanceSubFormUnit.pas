unit PGrievanceSubFormUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, ComCtrls, StdCtrls, Buttons, Mask, DBCtrls, wwdblook, Db,
  DBTables, Wwtable, Grids, Wwdbigrd, Wwdbgrid, wwriched, wwrichedspell,
  Wwdatsrc, Tabs, OleCtnrs, TMultiP, Word97, ExtDlgs, Excel97, OleServer, ShellAPI;

type
  TGrievanceSubform = class(TForm)
    PageControl: TPageControl;
    ParcelTabSheet: TTabSheet;
    Panel1: TPanel;
    PetitionerTabSheet: TTabSheet;
    ResultsTabSheet: TTabSheet;
    DocumentsTabSheet: TTabSheet;
    CloseButton: TBitBtn;
    SaveButton: TBitBtn;
    CancelButton: TBitBtn;
    PrintButton: TBitBtn;
    GrievanceTable: TTable;
    GrievanceDataSource: TDataSource;
    LawyerCodeTable: TwwTable;
    OwnerGroupBox: TGroupBox;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    SwisLabel: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label28: TLabel;
    EditName: TDBEdit;
    EditName2: TDBEdit;
    EditAddress: TDBEdit;
    EditAddress2: TDBEdit;
    EditStreet: TDBEdit;
    EditCity: TDBEdit;
    EditState: TDBEdit;
    EditZip: TDBEdit;
    EditZipPlus4: TDBEdit;
    TimeOfGrievanceInformationGroupBox: TGroupBox;
    Label25: TLabel;
    EditLegalAddrNo: TDBEdit;
    Label26: TLabel;
    EditLegalAddr: TDBEdit;
    Label19: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label27: TLabel;
    PriorValueLabel: TLabel;
    CurrentValueLabel: TLabel;
    Label31: TLabel;
    BOARMembersTable: TTable;
    GroupBox2: TGroupBox;
    DispositionLookupCombo: TwwDBLookupCombo;
    Label32: TLabel;
    BoarMemberResultsDBGrid: TwwDBGrid;
    GrievanceBoardTable: TwwTable;
    GrievanceBoardDataSource: TwwDataSource;
    BOARMemberLookupCombo: TwwDBLookupCombo;
    GrievanceResultsTable: TwwTable;
    GrievanceResultsDataSource: TwwDataSource;
    AllConcurButton: TButton;
    AllAgainstButton: TButton;
    EditHomesteadCode: TDBEdit;
    EditCurrentTotalValue: TDBEdit;
    EditPriorTotalValue: TDBEdit;
    EditCurrentLandValue: TDBEdit;
    EditPriorLandValue: TDBEdit;
    EditFullMarketValue: TDBEdit;
    EditPropertyClassCode: TDBEdit;
    EditOwnership: TDBEdit;
    EditResidentialPercent: TDBEdit;
    EditRollSection: TDBEdit;
    Label30: TLabel;
    PropertyClassCodeText: TDBText;
    PropertyClassCodeTable: TTable;
    PropertyClassDataSource: TDataSource;
    GrievanceExemptionTable: TwwTable;
    GrievanceExemptionDataSource: TwwDataSource;
    GrievanceExemptionGrid: TwwDBGrid;
    ExemptionCodeTable: TwwTable;
    PetitionerAskingGroupBox: TGroupBox;
    Label22: TLabel;
    GrievanceNotesRichEdit: TwwDBRichEditMSWord;
    Label34: TLabel;
    Label36: TLabel;
    EditAskingLandValue: TDBEdit;
    EditAskingTotalValue: TDBEdit;
    EditPetitionerAssessedPercent: TDBEdit;
    EditPetitionerFullMarketValue: TDBEdit;
    Label35: TLabel;
    Label37: TLabel;
    Label40: TLabel;
    Label41: TLabel;
    ComplaintReasonLookupCombo: TwwDBLookupCombo;
    GrievanceComplaintReasonTable: TwwTable;
    GrievanceComplaintSubreasonTable: TwwTable;
    Label47: TLabel;
    EditLandValue: TDBEdit;
    Label48: TLabel;
    EditTotalValue: TDBEdit;
    Label49: TLabel;
    Label50: TLabel;
    EditExemptionAmount: TDBEdit;
    Label51: TLabel;
    EditDate: TDBEdit;
    EditExemptionGranted: TwwDBLookupCombo;
    DenialReasonLabel: TLabel;
    GrievanceDenialReasonCodeTable: TwwTable;
    DenialReasonRichEdit: TwwDBRichEditMSWord;
    DenialReasonNotesButton: TButton;
    GrievanceDispositionCodeTable: TwwTable;
    GrievanceResultsLookupTable: TTable;
    Label33: TLabel;
    ResultsNotesRichEdit: TwwDBRichEditMSWord;
    ResultsNotesButton: TButton;
    Label29: TLabel;
    Label52: TLabel;
    AddBoardMemberButton: TBitBtn;
    RemoveBoardMemberButton: TBitBtn;
    GrievanceBoardTableTaxRollYr: TStringField;
    GrievanceBoardTableSwisSBLKey: TStringField;
    GrievanceBoardTableGrievanceNumber: TIntegerField;
    GrievanceBoardTableBoardMember: TStringField;
    GrievanceBoardTableConcur: TBooleanField;
    GrievanceBoardTableAgainst: TBooleanField;
    GrievanceBoardTableAbstain: TBooleanField;
    GrievanceBoardTableAbsent: TBooleanField;
    EditValuesTransferredDate: TDBEdit;
    SetFocusOnPageTimer: TTimer;
    Label53: TLabel;
    AppearanceNumberEdit: TDBEdit;
    ComplaintSubreasonRichEdit: TwwDBRichEditMSWord;
    ComplaintSubreasonButton: TButton;
    Label54: TLabel;
    Label55: TLabel;
    SubreasonCodeText: TDBText;
    AskingExemptionsGrid: TwwDBGrid;
    Label38: TLabel;
    GreivanceExemptionsAskedDataSource: TwwDataSource;
    GrievanceExemptionsAskedTable: TwwTable;
    ExemptionCodeAskedLookupCombo: TwwDBLookupCombo;
    ResultsGrid: TwwDBGrid;
    Label39: TLabel;
    EditExemptionPercent: TDBEdit;
    GrievanceBoardTableResultNumber: TIntegerField;
    DeleteExemptionAskedButton: TBitBtn;
    AddExemptionClaimedButton: TBitBtn;
    PreventUpdateCheckBox: TDBCheckBox;
    Label42: TLabel;
    LettersSentTabSheet: TTabSheet;
    GrievanceLettersSentGrid: TwwDBGrid;
    GrievanceLettersSentTable: TwwTable;
    GrievanceLettersSentDataSource: TwwDataSource;
    GrievanceLookupTable: TTable;
    GrievanceBoardLookupTable: TTable;
    MainPanel: TPanel;
    DocumentGrid: TwwDBGrid;
    FullScreenButton: TBitBtn;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Notebook: TNotebook;
    ImagePanel: TPanel;
    ImageScrollBox: TScrollBox;
    Image: TPMultiImage;
    Panel3: TPanel;
    ScrollBox1: TScrollBox;
    OleContainer: TOleContainer;
    DeleteDocumentButton: TBitBtn;
    NewDocumentButton: TBitBtn;
    btnDocumentSave: TBitBtn;
    NoHearingCheckBox: TDBCheckBox;
    FrozenLabel: TLabel;
    AssessmentTable: TTable;
    Petitioner_Attorney_NameAddress_PageControl: TPageControl;
    PetitionerNameAddressTabSheet: TTabSheet;
    Label1: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    LawyerLabel: TLabel;
    Label11: TLabel;
    EditPetitionerName1: TDBEdit;
    EditPetitionerName2: TDBEdit;
    EditPetitionerAddress1: TDBEdit;
    EditPetitionerAddress2: TDBEdit;
    EditPetitionerStreet: TDBEdit;
    EditPetitionerCity: TDBEdit;
    EditPetitionerState: TDBEdit;
    EditPetitionerZip: TDBEdit;
    EditPetitionerZipPlus4: TDBEdit;
    LawyerLookupCombo: TwwDBLookupCombo;
    EditPetitionerPhone: TDBEdit;
    RepresentativeNameAddressTabSheet: TTabSheet;
    Label43: TLabel;
    Label44: TLabel;
    Label45: TLabel;
    Label46: TLabel;
    Label56: TLabel;
    Label57: TLabel;
    Label58: TLabel;
    Label59: TLabel;
    Label60: TLabel;
    Label61: TLabel;
    Label62: TLabel;
    EditAttorneyName1: TDBEdit;
    EditAttorneyName2: TDBEdit;
    EditAttorneyAddress1: TDBEdit;
    EditAttorneyAddress2: TDBEdit;
    EditAttorneyStreet: TDBEdit;
    EditAttorneyCity: TDBEdit;
    EditAttorneyState: TDBEdit;
    EditAttorneyZip: TDBEdit;
    EditAttorneyZipPlus4: TDBEdit;
    LawyerCodeLookupCombo2: TwwDBLookupCombo;
    EditAttorneyPhone: TDBEdit;
    DocumentTable: TTable;
    DocumentLookupTable: TTable;
    DocumentDataSource: TDataSource;
    WordApplication: TWordApplication;
    ExcelApplication: TExcelApplication;
    DocumentTypeTable: TwwTable;
    DocumentDialog: TOpenDialog;
    OpenScannedImageDialog: TOpenPictureDialog;
    OleWordDocumentTimer: TTimer;
    WordDocument: TWordDocument;
    OLEItemNameTimer: TTimer;
    OpenPDFDialog: TOpenDialog;
    Label3: TLabel;
    Label63: TLabel;
    procedure CloseButtonClick(Sender: TObject);
    procedure DispositionLookupComboCloseUp(Sender: TObject; LookupTable,
      FillTable: TDataSet; modified: Boolean);
    procedure SaveButtonClick(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject);
    procedure GrievanceResultsTableBeforePost(DataSet: TDataSet);
    procedure GrievanceResultsTableAfterPost(DataSet: TDataSet);
    procedure DenialReasonNotesButtonClick(Sender: TObject);
    procedure ResultsNotesButtonClick(Sender: TObject);
    procedure AllConcurButtonClick(Sender: TObject);
    procedure AllAgainstButtonClick(Sender: TObject);
    procedure LawyerLookupComboDropDown(Sender: TObject);
    procedure LawyerLookupComboCloseUp(Sender: TObject; LookupTable,
      FillTable: TDataSet; modified: Boolean);
    procedure AddBoardMemberButtonClick(Sender: TObject);
    procedure RemoveBoardMemberButtonClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure GrievanceBoardTableVoteChange(Sender: TField);
    procedure GrievanceNotesRichEditDblClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure ComplaintReasonLookupComboCloseUp(Sender: TObject;
      LookupTable, FillTable: TDataSet; modified: Boolean);
    procedure EditExemptionGrantedCloseUp(Sender: TObject; LookupTable,
      FillTable: TDataSet; modified: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure PageControlChange(Sender: TObject);
    procedure SetFocusOnPageTimerTimer(Sender: TObject);
    procedure ComplaintSubreasonButtonClick(Sender: TObject);
    procedure EditDateKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure GrievanceExemptionsAskedTableNewRecord(DataSet: TDataSet);
    procedure AddExemptionClaimedButtonClick(Sender: TObject);
    procedure DeleteExemptionAskedButtonClick(Sender: TObject);
    procedure GrievanceResultsTableAfterScroll(DataSet: TDataSet);
    procedure GrievanceTableBeforeEdit(DataSet: TDataSet);
    procedure GrievanceTableBeforePost(DataSet: TDataSet);
    procedure GrievanceResultsTableAfterEdit(DataSet: TDataSet);
    procedure GrievanceTableAfterEdit(DataSet: TDataSet);
    procedure GrievanceTableAfterPost(DataSet: TDataSet);
    procedure DocumentTableNewRecord(DataSet: TDataSet);
    procedure DocumentTableAfterInsert(DataSet: TDataSet);
    procedure DocumentTableAfterScroll(DataSet: TDataSet);
    procedure OleWordDocumentTimerTimer(Sender: TObject);
    procedure OLEItemNameTimerTimer(Sender: TObject);
    procedure WordApplicationQuit(Sender: TObject);
    procedure WordDocumentClose(Sender: TObject);
    procedure NewDocumentButtonClick(Sender: TObject);
    procedure ExcelApplicationWorkbookBeforeClose(Sender: TObject; var Wb,
      Cancel: OleVariant);
    procedure DeleteDocumentButtonClick(Sender: TObject);
    procedure FullScreenButtonClick(Sender: TObject);
    procedure btnDocumentSaveClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    GrievanceYear : String;
    GrievanceProcessingType : Integer;
    SwisSBLKey : String;
    GrievanceNumber : Integer;
    EditMode : Char;  {A = Add; M = Modify; V = View}
    UnitName : String;

    OriginalGrantedLandValue,
    OriginalGrantedTotalValue,
    OriginalGrantedExemptionAmount,
    NewGrantedLandValue,
    NewGrantedTotalValue,
    NewGrantedExemptionAmount : LongInt;

    OriginalGrantedExemptionCode,
    NewGrantedExemptionCode : String;

    OriginalGrantedExemptionPercent,
    NewGrantedExemptionPercent : Double;

    OldLawyerCode : String;

    InitializingForm,
    AddingBoardMembers,
    SynchronizingBoardVote,
    SettingBoardVote, PostCancelled : Boolean;
    OriginalTotalAssessedValue : LongInt;

    ParcelTabSet : TTabSet;  {The tabs along the bottom. We need them for
                              so that we can refresh the tabs when
                              the first exemption denial or removal is added.}
    TabTypeList : TStringList; {The corresponding tab processing types. "  "   "  "}

    AddingResult : Boolean;
    FieldTraceInformationList : TList;

    DocumentActive : Boolean;
    DocumentTypeSelected : Integer;
    lcID : Integer;  {Reference ID number for created Excel worksheet.}
    CurrentDocumentName : String;

    Procedure SetScrollBars;
    Procedure InitializeForm;
    Procedure SetDenialReasonState(Disposition : String);
    Procedure SaveAllChanges;
    Procedure CancelAllChanges;
    Procedure AddBoardMembers(DefaultAllToConcur : Boolean);
    Procedure AddOneGrievanceResultsRecord(var ResultNumber : Integer;
                                               ComplaintDescription : String);

  end;

var
  GrievanceSubform: TGrievanceSubform;

implementation

{$R *.DFM}

uses
  PASTypes, GlblVars, PASUtils, WinUtils, Utilitys, GlblCnst,
  UtilRTot, utilEXSD, GrievanceDenialReasonDialogUnit, UtilPrcl,
  GrievanceComplaintSubreasonDialogUnit, Prog, FullScrn,
  GrievanceUtilitys, DocumentTypeDialog, UtilOLE, DataAccessUnit;

{==================================================================}
Procedure TGrievanceSubform.InitializeForm;

var
  _Found : Boolean;
  CurrentAssessmentYear : String;

begin
    {FXX01262004-1(2.07l1): Make sure that the subwindows have the same state as the main form.}
(*  WindowState := Application.MainForm.WindowState; *)

  InitializingForm := True;
  AddingBoardMembers := False;
  SynchronizingBoardVote := False;
  SettingBoardVote := False;
  AddingResult := False;
  FieldTraceInformationList := TList.Create;

  UnitName := 'PGrievanceSubform';
  ParcelTabSheet.PageIndex := 0;

  If (EditMode = 'V')
    then
      begin
        GrievanceTable.ReadOnly := True;
        GrievanceResultsTable.ReadOnly := True;
        GrievanceBoardTable.ReadOnly := True;
        SaveButton.Enabled := False;
        CancelButton.Enabled := False;

          {FXX10022003-1(2.07j): Make sure that the board member result buttons are disabled.}

        AllConcurButton.Enabled := False;
        AllAgainstButton.Enabled := False;
        AddBoardMemberButton.Enabled := False;
        RemoveBoardMemberButton.Enabled := False;

      end;  {If (EditMode = 'V')}

  OpenTablesForForm(Self, GrievanceProcessingType);

  _Found := FindKeyOld(GrievanceTable, ['TaxRollYr', 'SwisSBLKey', 'GrievanceNumber'],
                       [GrievanceYear, SwisSBLKey, IntToStr(GrievanceNumber)]);

  If not _Found
    then SystemSupport(001, GrievanceTable,
                       'Error finding grievance ' + GrievanceYear + '\' +
                       SwisSBLKey + '\' +
                       IntToStr(GrievanceNumber),
                       UnitName, GlblErrorDlgBox);

  Caption := GrievanceYear + ' Grievance #' +
             GetGrievanceNumberToDisplay(GrievanceTable) +
             ' for parcel ' + ConvertSwisSBLToDashDot(SwisSBLKey);

    {Set range on the grievance results table, the BOAR members, the
     grievance exemption table, and find the property class code.}

  SetRangeOld(GrievanceResultsTable,
              ['TaxRollYr', 'SwisSBLKey', 'GrievanceNumber', 'ResultNumber'],
              [GrievanceYear, SwisSBLKey, IntToStr(GrievanceNumber), '0'],
              [GrievanceYear, SwisSBLKey, IntToStr(GrievanceNumber), '9999']);

  SetRangeOld(GrievanceBoardTable,
              ['SwisSBLKey', 'TaxRollYr', 'GrievanceNumber', 'ResultNumber', 'BoardMember'],
              [SwisSBLKey, GrievanceYear, IntToStr(GrievanceNumber),
               GrievanceResultsTable.FieldByName('ResultNumber').Text, ''],
              [SwisSBLKey, GrievanceYear, IntToStr(GrievanceNumber),
               GrievanceResultsTable.FieldByName('ResultNumber').Text, 'ZZZZZZZZZZ']);

  SetRangeOld(GrievanceExemptionsAskedTable,
              ['SwisSBLKey', 'TaxRollYr', 'GrievanceNumber', 'ExemptionCode'],
              [SwisSBLKey, GrievanceYear, IntToStr(GrievanceNumber), '     '],
              [SwisSBLKey, GrievanceYear, IntToStr(GrievanceNumber), '99999']);

  SetRangeOld(GrievanceExemptionTable,
              ['SwisSBLKey', 'TaxRollYr', 'GrievanceNumber', 'ExemptionCode'],
              [SwisSBLKey, GrievanceYear, IntToStr(GrievanceNumber), '     '],
              [SwisSBLKey, GrievanceYear, IntToStr(GrievanceNumber), '99999']);

  FindKeyOld(PropertyClassCodeTable, ['MainCode'],
             [GrievanceTable.FieldByName('PropertyClassCode').Text]);

  SetRangeOld(GrievanceLettersSentTable,
              ['TaxRollYr', 'SwisSBLKey', 'GrievanceNumber', 'ResultNumber', 'LetterName'],
              [GrievanceYear, SwisSBLKey, IntToStr(GrievanceNumber), '0', ''],
              [GrievanceYear, SwisSBLKey, IntToStr(GrievanceNumber), '9999', '']);

  _SetRange(DocumentTable, [GrievanceYear, IntToStr(GrievanceNumber), SwisSBLKey, 0],
            [GrievanceYear, IntToStr(GrievanceNumber), SwisSBLKey, 32000], '', []);

    {Now set display formats on numeric fields.}

  TFloatField(GrievanceTable.FieldByName('PriorLandValue')).DisplayFormat := CurrencyDisplayNoDollarSign;
  TFloatField(GrievanceTable.FieldByName('CurrentLandValue')).DisplayFormat := CurrencyDisplayNoDollarSign;
  TFloatField(GrievanceTable.FieldByName('PetitLandValue')).DisplayFormat := CurrencyDisplayNoDollarSign;
  TFloatField(GrievanceTable.FieldByName('PetitTotalValue')).DisplayFormat := CurrencyDisplayNoDollarSign;
  TFloatField(GrievanceTable.FieldByName('PetitFullMarketVal')).DisplayFormat := CurrencyDisplayNoDollarSign;
  TFloatField(GrievanceTable.FieldByName('CurrentLandValue')).DisplayFormat := CurrencyDisplayNoDollarSign;
  TFloatField(GrievanceTable.FieldByName('PriorTotalValue')).DisplayFormat := CurrencyDisplayNoDollarSign;
  TFloatField(GrievanceTable.FieldByName('CurrentTotalValue')).DisplayFormat := CurrencyDisplayNoDollarSign;
  TFloatField(GrievanceTable.FieldByName('CurrentFullMarketVal')).DisplayFormat := CurrencyDisplayNoDollarSign;
  TFloatField(GrievanceTable.FieldByName('ResidentialPercent')).DisplayFormat := CurrencyDisplayNoDollarSign;

  TFloatField(GrievanceResultsTable.FieldByName('LandValue')).DisplayFormat := CurrencyDisplayNoDollarSign;
  TFloatField(GrievanceResultsTable.FieldByName('TotalValue')).DisplayFormat := CurrencyDisplayNoDollarSign;
  TFloatField(GrievanceResultsTable.FieldByName('EXAmount')).DisplayFormat := NoDecimalDisplay_BlankZero;
  TFloatField(GrievanceResultsTable.FieldByName('EXPercent')).DisplayFormat := NoDecimalDisplay_BlankZero;
  TDateField(GrievanceResultsTable.FieldByName('DecisionDate')).EditMask := DateMask;

  TFloatField(GrievanceExemptionTable.FieldByName('Amount')).DisplayFormat := CurrencyDisplayNoDollarSign;
  TFloatField(GrievanceExemptionTable.FieldByName('Percent')).DisplayFormat := NoDecimalDisplay;

  TFloatField(GrievanceExemptionsAskedTable.FieldByName('Amount')).DisplayFormat := CurrencyDisplayNoDollarSign;
  TFloatField(GrievanceExemptionsAskedTable.FieldByName('Percent')).DisplayFormat := NoDecimalDisplay;

  TTimeField(GrievanceLettersSentTable.FieldByName('TimeSent')).DisplayFormat := TimeFormat;

    {FXX09282003-1(2.07j): Fix up grievance history entry.}

  CurrentAssessmentYear := GrievanceTable.FieldByName('TaxRollYr').Text;
  PriorValueLabel.Caption := 'Prior (' + IntToStr(StrToInt(CurrentAssessmentYear) - 1) + ')';
  CurrentValueLabel.Caption := 'Current (' + CurrentAssessmentYear + ')';

(*  case GrievanceProcessingType of
    ThisYear :
      begin
        PriorValueLabel.Caption := 'Prior (' + IntToStr(StrToInt(GlblThisYear) - 1) + ')';
        CurrentValueLabel.Caption := 'Current (' + GlblThisYear + ')';
      end;  {ThisYear}

    NextYear :
      begin
        PriorValueLabel.Caption := 'Prior (' + GlblThisYear + ')';
        CurrentValueLabel.Caption := 'Current (' + GlblNextYear + ')';
      end;  {ThisYear}

  end;  {case GrievanceProcessingType of}*)

    {CHG01162003-1: Display the frozen status of the parcel.}

  _Found := FindKeyOld(AssessmentTable, ['TaxRollYr', 'SwisSBLKey'],
                       [GrievanceYear, SwisSBLKey]);

  If (_Found and
      (Deblank(AssessmentTable.FieldByName('DateFrozen').Text) <> ''))
    then FrozenLabel.Visible := False;

  TFloatField(GrievanceResultsTable.FieldByName('EXPercent')).MinValue := 0;
  TFloatField(GrievanceResultsTable.FieldByName('EXPercent')).MaxValue := 100;

    {CHG03232004-2(2.08): The Supervisor can change time of grievance info.}

    {CHG06092010-3(2.26.1)[I7208]: Allow for supervisor equivalents.}

  If UserIsSupervisor(GlblUserName)
    then
      begin
        MakeEditNotReadOnly(EditRollSection);
        MakeEditNotReadOnly(EditHomesteadCode);
        MakeEditNotReadOnly(EditOwnership);
        MakeEditNotReadOnly(EditLegalAddr);
        MakeEditNotReadOnly(EditLegalAddrNo);
        MakeEditNotReadOnly(EditResidentialPercent);
        MakeEditNotReadOnly(EditPropertyClassCode);
        
      end;  {If (GlblUserName = 'SUPERVISOR')}

    {CHG05252004-1(2.08): Option to have attorney information seperate.}

  If GlblGrievanceSeperateRepresentativeInfo
    then
      begin
        LawyerLabel.Visible := False;
        LawyerLookupCombo.Visible := False;
        RepresentativeNameAddressTabSheet.Caption := 'Representative Name \ Addr';

        If (Deblank(GrievanceTable.FieldByName('LawyerCode').Text) <> '')
          then RepresentativeNameAddressTabSheet.Caption := RepresentativeNameAddressTabSheet.Caption +
                                                            ' (' +
                                                            Trim(GrievanceTable.FieldByName('LawyerCode').Text) +
                                                            ')';
      end
    else Petitioner_Attorney_NameAddress_PageControl.Pages[1].TabVisible := False;

  InitializingForm := False;
  PageControl.ActivePage := ParcelTabSheet;
  SetFocusOnPageTimer.Enabled := True;

end;  {InitializeForm}

{================================================================}
Procedure TGrievanceSubform.FormKeyPress(    Sender: TObject;
                                         var Key: Char);

begin
  If (Key = #13)
    then
      begin
        Perform(WM_NextDlgCtl, 0, 0);
        Key := #0;
      end;  {If (Key = #13)}

end;  {FormKeyPress}

{================================================================}
Procedure TGrievanceSubform.GrievanceTableBeforeEdit(DataSet: TDataSet);

begin
  OriginalTotalAssessedValue := GrievanceTable.FieldByName('CurrentTotalValue').AsInteger;
end;

{==================================================================}
Procedure TGrievanceSubform.GrievanceTableAfterEdit(DataSet: TDataSet);

begin
    {FXX05142009-1(2.20.1.1)[D1537]: Audit grievance, small claims, certiorari.}

  CreateFieldValuesAndLabels(Self, GrievanceTable, FieldTraceInformationList);

end;

{==================================================================}
Procedure TGrievanceSubform.GrievanceTableAfterPost(DataSet: TDataSet);

begin
  RecordChanges(Self, 'Grievance', GrievanceTable, SwisSBLKey,
                FieldTraceInformationList);
end;

{================================================================}
Procedure TGrievanceSubform.SetDenialReasonState(Disposition : String);

var
  IsApprovedCode : Boolean;

begin
  FindKeyOld(GrievanceDispositionCodeTable, ['Code'],
             [Disposition]);

  IsApprovedCode := (GrievanceDispositionCodeTable.FieldByName('ResultType').AsInteger = gtApproved);

  DenialReasonRichEdit.Visible := (not IsApprovedCode);
  DenialReasonNotesButton.Visible := (not IsApprovedCode);
  DenialReasonLabel.Visible := (not IsApprovedCode);

  DenialReasonRichEdit.TabStop := (not IsApprovedCode);
  DenialReasonNotesButton.TabStop := (not IsApprovedCode);

end;  {SetDenialReasonState}

{================================================================}
Procedure TGrievanceSubform.AddOneGrievanceResultsRecord(var ResultNumber : Integer;
                                                             ComplaintDescription : String);

begin
  AddingResult := True;

  with GrievanceResultsTable do
    try
      Insert;
      FieldByName('SwisSBLKey').Text := SwisSBLKey;
      FieldByName('TaxRollYr').Text := GrievanceYear;
      FieldByName('GrievanceNumber').AsInteger := GrievanceNumber;
      FieldByName('ResultNumber').AsInteger := ResultNumber;
      FieldByName('ComplaintReason').Text := ComplaintDescription;

      ResultNumber := ResultNumber + 1;
      Post;
    except
      SystemSupport(040, GrievanceResultsTable,
                    'Error adding result number ' + IntToStr(ResultNumber) +
                    ' to results table.',
                    UnitName, GlblErrorDlgBox)
    end;

  AddingResult := False;

end;  {AddOneGrievanceResultsRecord}

{================================================================}
Procedure TGrievanceSubform.PageControlChange(Sender: TObject);

var
  ResultNumber : Integer;
  ResultsRecordAdded,
  Done, FirstTimeThrough : Boolean;

begin
  ResultsRecordAdded := False;

    {Create results records if none exist yet.}

  GrievanceResultsTable.First;

  If ((PageControl.ActivePage = ResultsTabSheet) and
      GrievanceResultsTable.EOF)
    then
      begin
        ResultNumber := 1;

        If (Roundoff(GrievanceTable.FieldByName('PetitTotalValue').AsFloat, 0) > 0)
          then
            begin
              ResultsRecordAdded := True;
              AddOneGrievanceResultsRecord(ResultNumber,
                                           'Asking AV ' +
                                           FormatFloat(CurrencyDisplayNoDollarSign,
                                                       GrievanceTable.FieldByName('PetitTotalValue').AsFloat));

            end;  {If (Roundoff(GrievanceTable.FieldByName('PetitTotalValue').AsFloat, 0) > 0)}

        SetRangeOld(GrievanceExemptionsAskedTable,
                    ['SwisSBLKey', 'TaxRollYr', 'GrievanceNumber', 'ExemptionCode'],
                    [SwisSBLKey, GrievanceYear, IntToStr(GrievanceNumber), '     '],
                    [SwisSBLKey, GrievanceYear, IntToStr(GrievanceNumber), '99999']);

        GrievanceExemptionsAskedTable.First;

        Done := False;
        FirstTimeThrough := True;

        repeat
          If FirstTimeThrough
            then FirstTimeThrough := False
            else GrievanceExemptionsAskedTable.Next;

          If GrievanceExemptionsAskedTable.EOF
            then Done := True;

          If not Done
            then
              begin
                ResultsRecordAdded := True;
                AddOneGrievanceResultsRecord(ResultNumber,
                                             'Asking EX ' +
                                             GrievanceExemptionsAskedTable.FieldByName('ExemptionCode').Text);
              end;  {If not Done}

        until Done;

          {FXX06172002-1: If the petitioner failed to put an asking AV or
                          exemption, we still need to add the grievance result
                          record.}

        If not ResultsRecordAdded
          then AddOneGrievanceResultsRecord(ResultNumber,
                                            'No AV Asked');

        GrievanceResultsTable.First;

      end;  {If ((PageControl.ActivePageIndex = ResultsTabSheet) and ...}

  SetFocusOnPageTimer.Enabled := True;

end;  {PageControlChange}

{================================================================}
Procedure TGrievanceSubform.SetFocusOnPageTimerTimer(Sender: TObject);

begin
  SetFocusOnPageTimer.Enabled := False;

  case PageControl.ActivePage.PageIndex of
    0 : EditName.SetFocus;
    1 : EditPetitionerName1.SetFocus;
    2 : DispositionLookupCombo.SetFocus;
    3 : DocumentTableAfterScroll(nil);

  end;  {case PageControl.ActivePage.PageIndex of}

end;  {SetFocusOnPageTimerTimer}

{================================================================}
Procedure TGrievanceSubform.EditDateKeyDown(    Sender: TObject;
                                            var Key: Word;
                                                Shift: TShiftState);

{Blank out the date if they press delete.}

begin
  If (Key = VK_Delete)
    then
      begin
        If (GrievanceResultsTable.State = dsBrowse)
          then GrievanceResultsTable.Edit;

        GrievanceResultsTable.FieldByName('DecisionDate').AsDateTime := 0;

      end;  {If (Key = VK_Del)}

end;  {EditDateKeyDown}

{================================================================}
Procedure TGrievanceSubform.GrievanceNotesRichEditDblClick(Sender: TObject);

begin
  GrievanceNotesRichEdit.Execute;
end;

{================================================================}
Procedure TGrievanceSubform.LawyerLookupComboDropDown(Sender: TObject);

begin
  OldLawyerCode := GrievanceTable.FieldByName('LawyerCode').Text;
end;

{================================================================}
Procedure TGrievanceSubform.LawyerLookupComboCloseUp(Sender: TObject;
                                                     LookupTable,
                                                     FillTable: TDataSet;
                                                     modified: Boolean);

{If they change lawyer codes, then change the petitioner information.}

begin
  If (OldLawyerCode <> LawyerCodeTable.FieldByName('Code').Text)
    then
      begin
        If not (GrievanceTable.State in [dsEdit, dsInsert])
          then GrievanceTable.Edit;

          {CHG05252004-1(2.08): Option to have attorney information seperate.}

        If GlblGrievanceSeperateRepresentativeInfo
          then SetAttorneyNameAndAddress(GrievanceTable, LawyerCodeTable,
                                         LawyerCodeTable.FieldByName('Code').Text)
          else SetPetitionerNameAndAddress(GrievanceTable, LawyerCodeTable,
                                           LawyerCodeTable.FieldByName('Code').Text);

      end;  {If (OldLawyerCode <> LawyerCodeTable.FieldByName('Code').Text)}

end;  {LawyerLookupComboCloseUp}

{================================================================}
Procedure TGrievanceSubform.ComplaintReasonLookupComboCloseUp(Sender: TObject;
                                                              LookupTable,
                                                              FillTable: TDataSet;
                                                              modified: Boolean);

var
  TempComplaintSubreasonCode : String;

begin
  try
    GrievanceComplaintSubreasonDialog := TGrievanceComplaintSubreasonDialog.Create(nil);

    with GrievanceComplaintSubreasonDialog do
      begin
        Category := GrievanceComplaintReasonTable.FieldByName('MainCode').Text;

        If (ShowModal = idOK)
          then
            begin
              TempComplaintSubreasonCode := GrievanceComplaintSubreasonCode;

              FindKeyOld(GrievanceComplaintSubreasonTable, ['Code'],
                         [TempComplaintSubreasonCode]);

              TMemoField(GrievanceTable.FieldByName('PetitSubreason')).Assign(TMemoField(GrievanceComplaintSubreasonTable.FieldByName('Description')));
              GrievanceTable.FieldByName('PetitSubreasonCode').Text := TempComplaintSubreasonCode;

            end;  {If (ShowModal = idOK)}

      end;  {with GrievanceComplaintSubreasonDialog do}

  finally
    GrievanceComplaintSubreasonDialog.Free;
  end;

  EditAskingLandValue.SetFocus;

end;  {ComplaintReasonLookupComboCloseUp}

{================================================================}
Procedure TGrievanceSubform.ComplaintSubreasonButtonClick(Sender: TObject);

begin
  ComplaintSubreasonRichEdit.Execute;
  EditAskingLandValue.SetFocus;
end;

{================================================================}
Procedure TGrievanceSubform.GrievanceExemptionsAskedTableNewRecord(DataSet: TDataSet);

begin
  with GrievanceExemptionsAskedTable do
    begin
      FieldByName('TaxRollYr').Text := GrievanceYear;
      FieldByName('GrievanceNumber').AsInteger := GrievanceNumber;
      FieldByName('SwisSBLKey').Text := SwisSBLKey;

    end;  {with GrievanceExemptionsAskedTable do}

end;  {GrievanceExemptionsAskedTableNewRecord}

{================================================================}
Procedure TGrievanceSubform.AddExemptionClaimedButtonClick(Sender: TObject);

begin
  GrievanceExemptionsAskedTable.Append;
  AskingExemptionsGrid.SetFocus;
  AskingExemptionsGrid.SetActiveField('ExemptionCode');
end;

{================================================================}
Procedure TGrievanceSubform.DeleteExemptionAskedButtonClick(Sender: TObject);

begin
  GrievanceExemptionsAskedTable.Delete;
end;

{================================================================}
Procedure TGrievanceSubform.GrievanceTableBeforePost(DataSet: TDataSet);

{If they have overriden the assessed value this grievance may apply to more than
 1 parcel and the values should not be updated.}

begin
  If ((OriginalTotalAssessedValue <> GrievanceTable.FieldByName('CurrentTotalValue').AsInteger) and
      (not GrievanceTable.FieldByName('PreventUpdate').AsBoolean))
    then GrievanceTable.FieldByName('PreventUpdate').AsBoolean :=
         (MessageDlg('The total assessed value of the parcel has been overriden,' + #13 +
                     'which may mean that this grievance applies to more than 1 parcel.' + #13 +
                     'If this is true, you may want to prevent recorded results from updating the parcel.' + #13 +
                     'Do you want to prevent the results from updating the parcel?',
                     mtConfirmation, [mbYes, mbNo], 0) = idYes);

    {If they did not fill in a value or exemption, warn them but let
     them proceed.}

  If ((GrievanceTable.FieldByName('PetitTotalValue').AsInteger = 0) and
      (NumRecordsInRange(GrievanceExemptionsAskedTable,
                         ['SwisSBLKey', 'TaxRollYr', 'GrievanceNumber', 'ExemptionCode'],
                         [SwisSBLKey, GrievanceYear, IntToStr(GrievanceNumber), '     '],
                         [SwisSBLKey, GrievanceYear, IntToStr(GrievanceNumber), '99999']) = 0) and
      (MessageDlg('There is no petitioner asking value or requested exemptions filled in.' + #13 +
                  'Is this correct?', mtWarning, [mbYes, mbNo], 0) = idNo))
    then
      begin
        Abort;
        PostCancelled := True;
      end;

end;  {GrievanceTableBeforePost}

{================================================================}
Procedure TGrievanceSubform.SaveAllChanges;

begin
  PostCancelled := False;

  If GrievanceTable.Modified
    then
      try
        GrievanceTable.Post;
      except
        If not PostCancelled
          then SystemSupport(002, GrievanceTable, 'Error posting to grievance table.',
                             UnitName, GlblErrorDlgBox);
      end;

  If GrievanceResultsTable.Modified
    then
      try
        GrievanceResultsTable.Post;
      except
        SystemSupport(003, GrievanceResultsTable, 'Error posting to grievance results table.',
                      UnitName, GlblErrorDlgBox);
      end;

  If GrievanceBoardTable.Modified
    then
      try
        GrievanceBoardTable.Post;
      except
        SystemSupport(004, GrievanceBoardTable, 'Error posting to grievance board table.',
                      UnitName, GlblErrorDlgBox);
      end;

  If GrievanceExemptionsAskedTable.Modified
    then
      try
        GrievanceExemptionsAskedTable.Post;
      except
        SystemSupport(070, GrievanceExemptionsAskedTable, 'Error posting to grievance exemptions asked table.',
                      UnitName, GlblErrorDlgBox);
      end;

  If (DocumentTable.State in [dsEdit, dsInsert])
    then
      try
        DocumentTable.Post;
      except
        SystemSupport(006, DocumentTable, 'Error posting document link.',
                      UnitName, GlblErrorDlgBox);
      end;


end;  {SaveAllChanges}

{================================================================}
Procedure TGrievanceSubform.SaveButtonClick(Sender: TObject);

begin
  If ((GrievanceTable.Modified or
       GrievanceResultsTable.Modified or
       GrievanceExemptionsAskedTable.Modified or
       GrievanceBoardTable.Modified or
       DocumentTable.Modified) and
      ((not GlblAskSave) or
       (MessageDlg('Do you want to save your grievance changes?', mtConfirmation,
                   [mbYes, mbNo], 0) = idYes)))
    then SaveAllChanges;

end;  {SaveButtonClick}

{================================================================}
Procedure TGrievanceSubform.CancelAllChanges;

begin
  If GrievanceTable.Modified
    then GrievanceTable.Cancel;

  If GrievanceResultsTable.Modified
    then GrievanceResultsTable.Cancel;

  If GrievanceBoardTable.Modified
    then GrievanceBoardTable.Cancel;

  If GrievanceExemptionsAskedTable.Modified
    then GrievanceExemptionsAskedTable.Cancel;

  If DocumentTable.Modified
    then DocumentTable.Cancel;

end;  {CancelAllChanges}

{================================================================}
Procedure TGrievanceSubform.CancelButtonClick(Sender: TObject);

begin
  If (MessageDlg('Do you want to cancel your changes?', mtConfirmation,
                 [mbYes, mbNo], 0) = idYes)
    then CancelAllChanges;

end;  {CancelButtonClick}

{================================================================}
Procedure TGrievanceSubform.AddBoardMembers(DefaultAllToConcur : Boolean);

{If there are no board memboers for this result yet, then add them.}

var
  FirstTimeThrough, Done : Boolean;

begin
  AddingBoardMembers := True;
  GrievanceBoardTable.First;

  If GrievanceBoardTable.EOF
    then
      begin
        Done := False;
        FirstTimeThrough := True;

        BOARMembersTable.First;

        repeat
          If FirstTimeThrough
            then FirstTimeThrough := False
            else BOARMembersTable.Next;

          If BOARMembersTable.EOF
            then Done := True;

          If ((not Done) and
              BOARMembersTable.FieldByName('Active').AsBoolean)
            then
              with GrievanceBoardTable do
                try
                  Append;
                  FieldByName('TaxRollYr').Text := GrievanceYear;
                  FieldByName('GrievanceNumber').AsInteger := GrievanceNumber;
                  FieldByName('ResultNumber').AsInteger := GrievanceResultsTable.FieldByName('ResultNumber').AsInteger;
                  FieldByName('SwisSBLKey').Text := SwisSBLKey;

                  FieldByName('BoardMember').Text := BOARMembersTable.FieldByName('Code').Text;

                  FieldByName('Against').AsBoolean := False;
                  FieldByName('Absent').AsBoolean := False;
                  FieldByName('Abstain').AsBoolean := False;
                  FieldByName('Concur').AsBoolean := DefaultAllToConcur;

                  Post;
                except
                  SystemSupport(005, GrievanceBoardTable,
                                'Error adding board member ' +
                                BOARMembersTable.FieldByName('Code').Text + '.',
                                UnitName, GlblErrorDlgBox);
                end;

        until Done;

      end;  {If GrievanceBoardTable.EOF}

  AddingBoardMembers := False;

end;  {AddBoardMembers}

{================================================================}
Procedure TGrievanceSubform.GrievanceBoardTableVoteChange(Sender: TField);

var
  I : Integer;

begin
  If not (InitializingForm or
          AddingBoardMembers or
          SynchronizingBoardVote or
          SettingBoardVote)
    then
      begin
        SynchronizingBoardVote := True;

        with GrievanceBoardTable do
          try
            If not (State in [dsEdit, dsInsert])
              then Edit;

            For I := 0 to (FieldCount - 1) do
              If ((Fields[I] is TBooleanField) and
                  (Fields[I].FieldName <> Sender.FieldName))
                then FieldByName(Fields[I].FieldName).AsBoolean := False;

            Post;
          except
            SystemSupport(006, GrievanceBoardTable,
                          'Error updating member vote.',
                          UnitName, GlblErrorDlgBox);
          end;

        SynchronizingBoardVote := False;

      end;  {If not (AddingBoardMembers or ...}

end;  {GrievanceBoardTableVoteChange}

{================================================================}
Procedure TGrievanceSubform.DispositionLookupComboCloseUp(Sender: TObject;
                                                          LookupTable,
                                                          FillTable: TDataSet;
                                                          modified: Boolean);

var
  TempDenialCode, ComplaintReason, ExemptionCode : String;
  IntDefault : Integer;
  StrDefault, ComplaintDescription : String;
  Done, FirstTimeThrough : Boolean;

begin
  IntDefault := 0;
  StrDefault := '';

    {FXX09292003-3(2.07j): Redo the complaint reason if it has not yet been filled in.}

  If (Modified and
      (GrievanceResultsTable.FieldByName('ComplaintReason').Text = 'No AV Asked'))
    then
      begin
        ComplaintDescription := '';

        If (Roundoff(GrievanceTable.FieldByName('PetitTotalValue').AsFloat, 0) > 0)
          then ComplaintDescription := 'Asking AV ' +
                                       FormatFloat(CurrencyDisplayNoDollarSign,
                                                   GrievanceTable.FieldByName('PetitTotalValue').AsFloat);

        If (ComplaintDescription = '')
          then
            begin
              SetRangeOld(GrievanceExemptionsAskedTable,
                          ['SwisSBLKey', 'TaxRollYr', 'GrievanceNumber', 'ExemptionCode'],
                          [SwisSBLKey, GrievanceYear, IntToStr(GrievanceNumber), '     '],
                          [SwisSBLKey, GrievanceYear, IntToStr(GrievanceNumber), '99999']);

              GrievanceExemptionsAskedTable.First;

              Done := False;
              FirstTimeThrough := True;

              repeat
                If FirstTimeThrough
                  then FirstTimeThrough := False
                  else GrievanceExemptionsAskedTable.Next;

                If GrievanceExemptionsAskedTable.EOF
                  then Done := True;

                If not Done
                  then ComplaintDescription := 'Asking EX ' +
                                               GrievanceExemptionsAskedTable.FieldByName('ExemptionCode').Text;

              until Done;

            end;  {If (ComplaintDescription = '')}

          {FXX06172002-1: If the petitioner failed to put an asking AV or
                          exemption, we still need to add the grievance result
                          record.}

        If (ComplaintDescription = '')
          then ComplaintDescription := 'No AV Asked';

        If (GrievanceResultsTable.State = dsBrowse)
          then GrievanceResultsTable.Edit;

        GrievanceResultsTable.FieldByName('ComplaintReason').Text := ComplaintDescription;

      end;  {If (Modified and ...}

  If Modified
    then SetDenialReasonState(GrievanceDispositionCodeTable.FieldByName('Code').Text);

  If Modified
  then
    case GrievanceDispositionCodeTable.FieldByName('ResultType').AsInteger of
      gtApproved :
      begin
          {FXX09282003-4(2.07j): Don't allow them to enter any approval information if it is not approved.}

        MakeEditNotReadOnly(EditLandValue);
        MakeEditNotReadOnly(EditTotalValue);
        MakeEditNotReadOnly(EditExemptionAmount);
        MakeEditNotReadOnly(EditExemptionPercent);
        MakeEditNotReadOnly(EditExemptionGranted);

        ComplaintReason := GrievanceResultsTable.FieldByName('ComplaintReason').Text;

          {FXX09282003-5(2.07j): Don't allow AV info for EX results and vice-cersa.}

        If (Pos('EX', ComplaintReason) > 0)
          then
            begin
              MakeEditReadOnly(EditLandValue, GrievanceResultsTable, False, IntDefault);
              MakeEditReadOnly(EditTotalValue, GrievanceResultsTable, False, IntDefault);
              ExemptionCode := Copy(ComplaintReason,
                                    (Length(ComplaintReason) - 4),
                                    5);

              If FindKeyOld(GrievanceExemptionsAskedTable,
                            ['SwisSBLKey', 'TaxRollYr', 'GrievanceNumber', 'ExemptionCode'],
                            [SwisSBLKey, GrievanceYear, IntToStr(GrievanceNumber), ExemptionCode])
                then
                  with GrievanceResultsTable do
                    begin
                      If (State = dsBrowse)
                        then Edit;

                      FieldByName('EXGranted').Text := ExemptionCode;
                      FieldByName('ExAmount').AsFloat := GrievanceExemptionsAskedTable.FieldByName('Amount').AsFloat;
                      FieldByName('ExPercent').AsFloat := GrievanceExemptionsAskedTable.FieldByName('Percent').AsFloat;

                    end;  {with GrievanceResultsTable do}

            end  {If (Pos('EX', ComplaintReason) > -1)}
          else
            begin
              MakeEditReadOnly(EditExemptionAmount, GrievanceResultsTable, False, IntDefault);
              MakeEditReadOnly(EditExemptionPercent, GrievanceResultsTable, False, IntDefault);
              MakeEditReadOnly(EditExemptionGranted, GrievanceResultsTable, True, StrDefault);

            end;  {else of If (Pos('EX', ComplaintReason) > -1)}

      end;

      gtDenied:
      begin
          {CHG02052003-1: Don't ask for a reason if there are no codes in the dialog.}

        If (GrievanceDenialReasonCodeTable.RecordCount > 0)
          then
            try
              GrievanceDenialReasonDialog := TGrievanceDenialReasonDialog.Create(nil);

                  with GrievanceDenialReasonDialog do
                    If (ShowModal = idOK)
                      then
                        begin
                          TempDenialCode := GrievanceDenialCode;

                          FindKeyOld(GrievanceDenialReasonCodeTable, ['MainCode'],
                                     [TempDenialCode]);

                          TMemoField(GrievanceResultsTable.FieldByName('DenialReason')).Assign(TMemoField(GrievanceDenialReasonCodeTable.FieldByName('Reason')));
                          GrievanceResultsTable.FieldByName('DenialReasonCode').Text := TempDenialCode;

                        end;  {with GrievanceDenialReasonDialog do}

            finally
              GrievanceDenialReasonDialog.Free;
            end;

          {FXX09282003-4(2.07j): Don't allow them to enter any approval information if it is not approved.}

        MakeEditReadOnly(EditLandValue, GrievanceResultsTable, False, IntDefault);
        MakeEditReadOnly(EditTotalValue, GrievanceResultsTable, False, IntDefault);
        MakeEditReadOnly(EditExemptionAmount, GrievanceResultsTable, False, IntDefault);
        MakeEditReadOnly(EditExemptionPercent, GrievanceResultsTable, False, IntDefault);
        MakeEditReadOnly(EditExemptionGranted, GrievanceResultsTable, True, StrDefault);

      end;  {gtDenied}

    end;  {case GrievanceDispositionCodeTable.FieldByName('ResultType').AsInteger of}

    {Only add the board members if they are not there already.}

  GrievanceBoardTable.First;

  If GrievanceBoardTable.EOF
    then AddBoardMembers((GrievanceDispositionCodeTable.FieldByName('ResultType').AsInteger = gtApproved));

  EditDate.SetFocus;

end;  {DispositionLookupComboCloseUp}

{==================================================================}
Procedure TGrievanceSubform.EditExemptionGrantedCloseUp(Sender: TObject;
                                                            LookupTable,
                                                            FillTable: TDataSet;
                                                            modified: Boolean);

var
  AmountFieldRequired, AmountFieldReadOnly,
  PercentFieldRequired, PercentFieldReadOnly,
  OwnerPercentFieldRequired, OwnerPercentFieldReadOnly,
  TerminationDateRequired : Boolean;
  IntDefault : Integer;
  StrDefault : String;

begin
  IntDefault := 0;
  StrDefault := '';
  
    {FXX09292003-1(2.07j): Make sure grievance entry follows the same rules for exemption entry.}

  DetermineExemptionReadOnlyAndRequiredFields(ExemptionCodeTable,
                                              GrievanceTable,
                                              GrievanceResultsTable.FieldByName('EXGranted').Text,
                                              AmountFieldRequired,
                                              AmountFieldReadOnly,
                                              PercentFieldRequired,
                                              PercentFieldReadOnly,
                                              OwnerPercentFieldRequired,
                                              OwnerPercentFieldReadOnly,
                                              TerminationDateRequired);

  If AmountFieldReadOnly
    then MakeEditReadOnly(EditExemptionAmount, GrievanceResultsTable, False, IntDefault);

  If PercentFieldReadOnly
    then MakeEditReadOnly(EditExemptionPercent, GrievanceResultsTable, False, IntDefault);

end;  {EditExemptionGrantedCloseUp}

{==================================================================}
Procedure TGrievanceSubform.DenialReasonNotesButtonClick(Sender: TObject);

begin
  DenialReasonRichEdit.Execute;
  EditDate.SetFocus;
end;  {DenialReasonNotesButtonClick}

{==================================================================}
Procedure TGrievanceSubform.ResultsNotesButtonClick(Sender: TObject);

begin
  ResultsNotesRichEdit.Execute;
end;

{==================================================================}
Procedure SetVoteForAllBoardMembers(GrievanceBoardTable : TTable;
                                    FieldNameToSet : String);

var
  Done, FirstTimeThrough : Boolean;
  I : Integer;

begin
  GrievanceBoardTable.DisableControls;

  Done := False;
  FirstTimeThrough := True;

  GrievanceBoardTable.First;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else GrievanceBoardTable.Next;

    If GrievanceBoardTable.EOF
      then Done := True;

    If not Done
      then
        with GrievanceBoardTable do
          For I := 0 to (FieldCount - 1) do
            If (Fields[I] is TBooleanField)
              then
                try
                  Edit;
                  Fields[I].AsBoolean := (ANSIUpperCase(Fields[I].FieldName) =
                                          ANSIUpperCase(FieldNameToSet));
                  Post;
                except
                  SystemSupport(007, GrievanceBoardTable,
                                'Error posting to grievance board table.',
                                'PGrievanceSubFormUnit', GlblErrorDlgBox);
                end;

  until Done;

  GrievanceBoardTable.EnableControls;

end;  {SetVoteForAllBoardMembers}

{==================================================================}
Procedure TGrievanceSubform.AllConcurButtonClick(Sender: TObject);

begin
  SettingBoardVote := True;
  SetVoteForAllBoardMembers(GrievanceBoardTable, 'Concur');
  SettingBoardVote := False;
end;

{==================================================================}
Procedure TGrievanceSubform.AllAgainstButtonClick(Sender: TObject);

begin
  SettingBoardVote := True;
  SetVoteForAllBoardMembers(GrievanceBoardTable, 'Against');
  SettingBoardVote := False;
end;

{================================================================}
Procedure TGrievanceSubform.AddBoardMemberButtonClick(Sender: TObject);

begin
  AddingBoardMembers := True;

    {FXX03152008-1(2.11.7.15): Make sure to put in the essential identifying info.}

  with GrievanceBoardTable do
    try
      Append;
      FieldByName('TaxRollYr').Text := GrievanceYear;
      FieldByName('GrievanceNumber').AsInteger := GrievanceNumber;
      FieldByName('ResultNumber').AsInteger := GrievanceResultsTable.FieldByName('ResultNumber').AsInteger;
      FieldByName('SwisSBLKey').Text := SwisSBLKey;
    except
      SystemSupport(008, GrievanceBoardTable,
                    'Error adding board member.',
                    UnitName, GlblErrorDlgBox);
    end;

  AddingBoardMembers := False;

end;  {AddBoardMemberButtonClick}

{================================================================}
Procedure TGrievanceSubform.RemoveBoardMemberButtonClick(Sender: TObject);

begin
  If (MessageDlg('Are you sure you want to remove board member ' +
                 GrievanceBoardTable.FieldByName('BoardMember').Text + '?',
                 mtConfirmation, [mbYes, mbNo], 0) = idYes)
    then
      try
        GrievanceBoardTable.Delete;
      except
        SystemSupport(009, GrievanceBoardTable,
                      'Error removing board member' +
                      GrievanceBoardTable.FieldByName('BoardMember').Text + '.',
                      UnitName, GlblErrorDlgBox);
      end;

end;  {RemoveBoardMemberButtonClick}

{================================================================}
Procedure TGrievanceSubform.GrievanceResultsTableAfterEdit(DataSet: TDataSet);

begin
    {FXX05142009-1(2.20.1.1)[D1537]: Audit grievance, small claims, certiorari.}

  CreateFieldValuesAndLabels(Self, GrievanceResultsTable, FieldTraceInformationList);

  DetermineGrantedValues(GrievanceResultsTable, OriginalGrantedLandValue,
                         OriginalGrantedTotalValue,
                         OriginalGrantedExemptionAmount,
                         OriginalGrantedExemptionPercent,
                         OriginalGrantedExemptionCode);

end;  {GrievanceResultsTableAfterEdit}

{================================================================}
Procedure TGrievanceSubform.GrievanceResultsTableAfterScroll(DataSet: TDataSet);

{Make sure the board members stay synchronized with the results.}

begin
  If not InitializingForm
    then
      begin
        If GrievanceBOARDTable.Active
          then SetRangeOld(GrievanceBoardTable,
                           ['SwisSBLKey', 'TaxRollYr', 'GrievanceNumber', 'ResultNumber', 'BoardMember'],
                           [SwisSBLKey, GrievanceYear, IntToStr(GrievanceNumber),
                            GrievanceResultsTable.FieldByName('ResultNumber').Text, ''],
                           [SwisSBLKey, GrievanceYear, IntToStr(GrievanceNumber),
                            GrievanceResultsTable.FieldByName('ResultNumber').Text, 'ZZZZZZZZZZ']);

        SetDenialReasonState(GrievanceResultsTable.FieldByName('Disposition').Text);

      end;  {If not InitializingForm}

end;  {GrievanceResultsTableAfterScroll}

{================================================================}
Procedure TGrievanceSubform.GrievanceResultsTableBeforePost(DataSet: TDataSet);

begin
  If not InitializingForm
    then
      with GrievanceResultsTable do
        begin
            {If there has been a change, be sure to set the Value Transferred
             flags to false.}

          DetermineGrantedValues(GrievanceResultsTable, NewGrantedLandValue,
                                 NewGrantedTotalValue,
                                 NewGrantedExemptionAmount,
                                 NewGrantedExemptionPercent,
                                 NewGrantedExemptionCode);

          If ((NewGrantedLandValue <> OriginalGrantedLandValue) or
              (NewGrantedTotalValue <> OriginalGrantedTotalValue) or
              (Deblank(OriginalGrantedExemptionCode) = '') and
               ((NewGrantedExemptionAmount <> OriginalGrantedExemptionAmount) or
               (NewGrantedExemptionPercent <> OriginalGrantedExemptionPercent) or
               (NewGrantedExemptionCode <> OriginalGrantedExemptionCode)))
            then
              begin
                FieldByName('ValuesTransferred').AsBoolean := False;
                FieldByName('ValuesTransferredDate').Text := '';
              end;

            {FXX09302003-1(2.07j): Additional error checking on the results entry.}

          If ((NewGrantedTotalValue > 0) and
              (NewGrantedTotalValue < GrievanceTable.FieldByName('PetitTotalValue').AsInteger) and
              (MessageDlg('Warning!  The granted value ( ' +
                          FormatFloat(CurrencyDisplayNoDollarSign,
                                      NewGrantedTotalValue) +
                          ') is less than what the petitioner requested (' +
                          FormatFloat(CurrencyDisplayNoDollarSign,
                                      GrievanceTable.FieldByName('PetitTotalValue').AsInteger) +
                          ').' + #13 +
                          'Is this correct?', mtConfirmation, [mbYes, mbNo], 0) = idNo))
            then
              begin
                EditTotalValue.SetFocus;
                PostCancelled := True;
                Abort;
              end;

          If ((GrievanceYear = DetermineGrievanceYear) and
              (NewGrantedTotalValue > 0) and
              (NewGrantedTotalValue >= AssessmentTable.FieldByName('TotalAssessedVal').AsInteger) and
              (MessageDlg('Warning!  The granted value ( ' +
                          FormatFloat(CurrencyDisplayNoDollarSign,
                                      NewGrantedTotalValue) +
                          ') is greater than or equal to than the current assessed value (' +
                          FormatFloat(CurrencyDisplayNoDollarSign,
                                      AssessmentTable.FieldByName('TotalAssessedVal').AsInteger) +
                          ').' + #13 +
                          'Is this correct?', mtConfirmation, [mbYes, mbNo], 0) = idNo))
            then
              begin
                EditTotalValue.SetFocus;
                PostCancelled := True;
                Abort;
              end;

          If ((Deblank(OriginalGrantedExemptionCode) <> '') and
              (OriginalGrantedExemptionCode <> NewGrantedExemptionCode) and
              (MessageDlg('Warning!  The granted exemption code (' + NewGrantedExemptionCode +
                          ') is different than the original exemption code (' +
                          OriginalGrantedExemptionCode + ').' + #13 +
                          'Is this correct?', mtConfirmation, [mbYes, mbNo], 0) = idNo))
            then
              begin
                EditExemptionGranted.SetFocus;
                PostCancelled := True;
                Abort;
              end;

        end;  {with GrievanceResultsTable do}

end;  {GrievanceResultsTableBeforePost}

{==================================================================}
Procedure TGrievanceSubform.GrievanceResultsTableAfterPost(DataSet: TDataSet);

{If they have filled in amounts, then offer to update the parcel.}

var
  Done, FirstTimeThrough, ChangeOccured,
  NowWhollyExempt, RecordVotes, Updated : Boolean;
  NumberOfDuplicates : Integer;
  TempSwisSBLKey, ErrorMessage : String;
  LandValueChange, TotalValueChange,
  CountyTaxableChange, TownTaxableChange,
  SchoolTaxableChange, VillageTaxableChange : Comp;

begin
  RecordChanges(Self, 'Grievance', GrievanceResultsTable, SwisSBLKey,
                FieldTraceInformationList);

  DetermineGrantedValues(GrievanceResultsTable, NewGrantedLandValue,
                         NewGrantedTotalValue,
                         NewGrantedExemptionAmount,
                         NewGrantedExemptionPercent,
                         NewGrantedExemptionCode);

  ChangeOccured := ((NewGrantedLandValue <> OriginalGrantedLandValue) or
                    (NewGrantedTotalValue <> OriginalGrantedTotalValue) or
                   (((Deblank(OriginalGrantedExemptionCode) = '') or
                    (not GrievanceResultsTable.FieldByName('ValuesTransferred').AsBoolean)) and
                   ((NewGrantedExemptionCode <> OriginalGrantedExemptionCode) or
                    (NewGrantedExemptionAmount <> OriginalGrantedExemptionAmount) or
                    (NewGrantedExemptionPercent <> OriginalGrantedExemptionPercent))));

    {Only offer to move the values if this is a grievance on the current grievance year
     (i.e. not history).}
    {FXX09282003-1(2.07j): Fix up grievance history entry.}

  If not InitializingForm
    then
      begin
        If ChangeOccured
          then
            If (GrievanceYear = DetermineGrievanceYear)
              then
                begin
                  If ChangeOccured
                    then
                      If GrievanceTable.FieldByName('PreventUpdate').AsBoolean
                        then MessageDlg('The parcel was not updated with the results because it has been flagged' + #13 +
                                        'to prevent updates of the main parcel.',
                                        mtInformation, [mbOK], 0)
                        else
                          If (MessageDlg('Do you wanted the new values moved to the main parcel now?' + #13 +
                                         'If you say no, the values can be automatically transferred' + #13 +
                                         'later in a bulk value move program.', mtConfirmation,
                                         [mbYes, mbNo], 0) = idYes)
                            then
                              begin
                                MoveGrantedValuesToMainParcel(OriginalGrantedLandValue,
                                                              OriginalGrantedTotalValue,
                                                              OriginalGrantedExemptionAmount,
                                                              OriginalGrantedExemptionPercent,
                                                              OriginalGrantedExemptionCode,
                                                              NewGrantedLandValue,
                                                              NewGrantedTotalValue,
                                                              NewGrantedExemptionAmount,
                                                              NewGrantedExemptionPercent,
                                                              NewGrantedExemptionCode,
                                                              GrievanceProcessingType,
                                                              SwisSBLKey,
                                                              GrievanceYear,
                                                              ParcelTabSet,
                                                              TabTypeList,
                                                              GrievanceResultsTable.FieldByName('GrievanceNumber').AsInteger,
                                                              GrievanceResultsTable.FieldByName('ResultNumber').AsInteger,
                                                              GrievanceResultsTable.FieldByName('Disposition').Text,
                                                              GrievanceResultsTable.FieldByName('DecisionDate').Text,
                                                              False, True,
                                                              False, glblFreezeAssessmentDueToGrievance,
                                                              NowWhollyExempt,
                                                              Updated, ErrorMessage,
                                                              LandValueChange, TotalValueChange,
                                                              CountyTaxableChange, TownTaxableChange,
                                                              SchoolTaxableChange, VillageTaxableChange);

                                  {Note that we will only automatically move this parcel to rs 8
                                   if it was switched to rs 8 above, i.e. if it is now wholly
                                   exempt, but the user chose not to move it to rs 8, we won't below.}

                                If (GlblModifyBothYears and
                                    (GrievanceProcessingType = ThisYear))
                                  then MoveGrantedValuesToMainParcel(OriginalGrantedLandValue,
                                                                     OriginalGrantedTotalValue,
                                                                     OriginalGrantedExemptionAmount,
                                                                     OriginalGrantedExemptionPercent,
                                                                     OriginalGrantedExemptionCode,
                                                                     NewGrantedLandValue,
                                                                     NewGrantedTotalValue,
                                                                     NewGrantedExemptionAmount,
                                                                     NewGrantedExemptionPercent,
                                                                     NewGrantedExemptionCode,
                                                                     NextYear,
                                                                     SwisSBLKey,
                                                                     GlblNextYear,
                                                                     ParcelTabSet,
                                                                     TabTypeList,
                                                                     GrievanceResultsTable.FieldByName('GrievanceNumber').AsInteger,
                                                                     GrievanceResultsTable.FieldByName('ResultNumber').AsInteger,
                                                                     GrievanceResultsTable.FieldByName('Disposition').Text,
                                                                     GrievanceResultsTable.FieldByName('DecisionDate').Text,
                                                                     False, False,
                                                                     NowWhollyExempt,
                                                                     glblFreezeAssessmentDueToGrievance, NowWhollyExempt,
                                                                     Updated, ErrorMessage,
                                                                     LandValueChange, TotalValueChange,
                                                                     CountyTaxableChange, TownTaxableChange,
                                                                     SchoolTaxableChange, VillageTaxableChange);

                                  {Now mark that the information was transferred to the main parcel.}

                                GrievanceResultsLookupTable.GotoCurrent(GrievanceResultsTable);

                                  {FXX09282003-2(2.07j): Make sure not to mark the values as transferred if there was an error.}

                                If Updated
                                  then
                                    with GrievanceResultsLookupTable do
                                      try
                                        Edit;
                                        FieldByName('ValuesTransferred').AsBoolean := True;
                                        FieldByName('ValuesTransferredDate').AsDateTime := Date;
                                        Post;
                                      except
                                        SystemSupport(013, GrievanceResultsLookupTable,
                                                      'Error marking values transferred in results table.',
                                                      UnitName, GlblErrorDlgBox);
                                      end
                                  else MessageDlg('The values and\or exemptions on the parcel were not updated.' + #13 +
                                                  'Please make the changes manually.', mtWarning, [mbOK], 0);

                              end;  {If ((NewGrantedLandValue <> OriginalGrantedLandValue) or...}

                    {If they changed the EX granted values in the results and
                     the value has already been transferred, they will have to adjust
                     the parcel by hand.}

                  If (((NewGrantedExemptionCode <> OriginalGrantedExemptionCode) or
                       (NewGrantedExemptionAmount <> OriginalGrantedExemptionAmount) or
                       (NewGrantedExemptionPercent <> OriginalGrantedExemptionPercent)) and
                      (Deblank(OriginalGrantedExemptionCode) <> '') and
                      GrievanceResultsTable.FieldByName('ValuesTransferred').AsBoolean)
                    then MessageDlg('The results for exemption code ' +
                                    OriginalGrantedExemptionCode +
                                    ' were changed.' + #13 +
                                    'This change can not be automatically done by PAS.' + #13 +
                                    'Please make this change manually.',
                                    mtWarning, [mbOK], 0);

                end  {If (GrievanceYear = DetermineGrievanceYear)}
              else MessageDlg('The assessed value and \ or exemptions were not updated because this is a grievance from a prior year.',
                              mtWarning, [mbOK], 0);

          {If they denied this grievance and this grievance is on more
           than one parcel, offer to move this result to all grievances
           with this complaint.}
          {Also note that NumRecordsInRange does a set range.}

        FindKeyOld(GrievanceDispositionCodeTable, ['Code'],
                   [GrievanceResultsTable.FieldByName('Disposition').Text]);

        If ((not AddingResult) and
            (GrievanceDispositionCodeTable.FieldByName('ResultType').AsInteger <> gtApproved))
          then
            begin
              NumberOfDuplicates := NumRecordsInRange(GrievanceLookupTable,
                                                      ['TaxRollYr', 'GrievanceNumber'],
                                                      [GrievanceYear, IntToStr(GrievanceNumber)],
                                                      [GrievanceYear, IntToStr(GrievanceNumber)]) - 1;

              If ((NumberOfDuplicates > 0) and
                  (MessageDlg('This grievance number is also on ' + IntToStr(NumberOfDuplicates) +
                              ' other parcels.' + #13 +
                              'Do you want this denial result to apply to all the other parcels with this grievance number?',
                              mtConfirmation, [mbYes, mbNo], 0) = idYes))
                then
                  begin
                    BOARMembersTable.DisableControls;
                    RecordVotes := (MessageDlg('Should all other parcels with this grievance number have the same' + #13 +
                                               'Board vote as the vote recorded on this parcel?',
                                               mtConfirmation, [mbYes, mbNo], 0) = idYes);

                    ProgressDialog.Start((NumberOfDuplicates + 1), False, False);
                    FirstTimeThrough := True;
                    Done := False;

                    GrievanceLookupTable.First;

                    repeat
                      If FirstTimeThrough
                        then FirstTimeThrough := False
                        else GrievanceLookupTable.Next;

                      If GrievanceLookupTable.EOF
                        then Done := True;

                      TempSwisSBLKey := GrievanceLookupTable.FieldByName('SwisSBLKey').Text;
                      ProgressDialog.Update(Self, ConvertSwisSBLToDashDot(TempSwisSBLKey));
                      Application.ProcessMessages;

                      If ((not Done) and
                          (SwisSBLKey <> TempSwisSBLKey))
                        then
                          begin
                              {First delete any existing results for this grievance.}

                            SetRangeOld(GrievanceResultsLookupTable,
                                        ['TaxRollYr', 'SwisSBLKey', 'GrievanceNumber', 'ResultNumber'],
                                        [GrievanceYear, TempSwisSBLKey, IntToStr(GrievanceNumber), '0'],
                                        [GrievanceYear, TempSwisSBLKey, IntToStr(GrievanceNumber), '9999']);

                            DeleteTableRange(GrievanceResultsLookupTable);

                              {Now copy the results to this parcel.}

                            CopyTable_OneRecord(GrievanceResultsTable, GrievanceResultsLookupTable,
                                                ['SwisSBLKey'], [TempSwisSBLKey]);

                              {Now copy the votes to this parcel if they want it.}

                            If RecordVotes
                              then
                                begin
                                  SetRangeOld(GrievanceBoardLookupTable,
                                              ['SwisSBLKey', 'TaxRollYr', 'GrievanceNumber', 'ResultNumber', 'BoardMember'],
                                              [TempSwisSBLKey, GrievanceYear, IntToStr(GrievanceNumber),
                                               GrievanceResultsTable.FieldByName('ResultNumber').Text, ''],
                                              [TempSwisSBLKey, GrievanceYear, IntToStr(GrievanceNumber),
                                               GrievanceResultsTable.FieldByName('ResultNumber').Text, 'ZZZZZZZZZZ']);

                                  DeleteTableRange(GrievanceBoardLookupTable);

                                  CopyTableRange(GrievanceBoardTable, GrievanceBoardLookupTable,
                                                 'SwisSBLKey',
                                                 ['SwisSBLKey'], [TempSwisSBLKey]);

                                end;  {If RecordVotes}

                          end;  {If not Done}

                    until Done;

                    ProgressDialog.Finish;

                    MessageDlg('The results from this grievance have been copied to ' +
                               IntToStr(NumberOfDuplicates) + ' other parcels.',
                               mtInformation, [mbOK], 0);
                    BOARMembersTable.EnableControls;

                  end;  {If ((NumberOfDuplicates > 0) and ...}

            end;  {If ((not AddingResult) and ...}
            
      end;  {If not InitializingForm}

end;  {GrievanceResultsTableAfterPost}

{=====================================================================}
Procedure TGrievanceSubform.SetScrollBars;

{Set the scroll bars for this imags height.}

var
  TempHeight, ZoomPercent : Integer;

begin
  If ((Deblank(Image.ImageName) = '') or
      (Image.ImageName = 'file not found'))
    then ImageScrollBox.VertScrollBar.Range := 0
    else
      begin
        Image.GetInfoAndType(Image.ImageName);
        ZoomPercent := Trunc((Image.Width / Image.BWidth) * 100);

        TempHeight := Trunc(Image.BHeight * (ZoomPercent / 100));
        ImageScrollBox.VertScrollBar.Range := TempHeight;
        ImageScrollBox.Height := TempHeight;
        Image.Height := TempHeight;

      end;  {If ((Deblank(Image.ImageName) = '') or ...}

end;  {SetScrollBars}

{======================================================}
Procedure TGrievanceSubform.DocumentTableNewRecord(DataSet: TDataSet);

var
  NextDocumentNumber : Integer;

begin
  If not InitializingForm
    then
      try
        DocumentTypeDialogForm := TDocumentTypeDialogForm.Create(nil);

        DocumentTypeDialogForm.ShowModal;

        If (DocumentTypeDialogForm.ModalResult = idOK)
          then
            begin
              _SetRange(DocumentLookupTable, [GrievanceYear, GrievanceNumber, SwisSBLKey, 0],
                        [GrievanceYear, GrievanceNumber, SwisSBLKey, 32000], '', []);

              DocumentLookupTable.First;

              If DocumentLookupTable.EOF
                then NextDocumentNumber := 1
                else
                  begin
                    DocumentLookupTable.Last;

                    NextDocumentNumber := DocumentLookupTable.FieldByName('DocumentNumber').AsInteger + 1;

                  end;  {If DocumentLookupTable.EOF}

              with DocumentTable do
                begin
                  FieldByName('DocumentNumber').AsInteger := NextDocumentNumber;
                  FieldByName('Date').AsDateTime := Date;
                  FieldByName('TaxRollYr').Text := GrievanceYear;
                  FieldByName('GrievanceNumber').Text := IntToStr(GrievanceNumber);
                  FieldByName('SwisSBLKey').Text := SwisSBLKey;

                end;  {with DocumentTable do}

              DocumentTypeSelected := DocumentTypeDialogForm.DocumentTypeSelected;

            end;  {If (DocumentTypeDialogForm.ModalResult = idOK)}

      finally
        DocumentTypeDialogForm.Free;
      end;

end;  {DocumentTableNewRecord}

{======================================================}
Procedure TGrievanceSubform.DocumentTableAfterInsert(DataSet: TDataSet);

var
  _Selection : Selection;
  TempParcelTable, NYParcelTable, TYParcelTable : TTable;
  InsertNameAndAddress : Boolean;
  NAddrArray : NameAddrArray;
  I : Integer;
  TempMemo : TMemo;

begin
  NYParcelTable := nil;
  If not InitializingForm
    then
      NYParcelTable := FindTableInDataModuleForProcessingType(DataModuleParcelTableName,
                                                              NextYear);
      TYParcelTable := FindTableInDataModuleForProcessingType(DataModuleParcelTableName,
                                                              ThisYear);

      case DocumentTypeSelected of
        dtOpenScannedImage :
          begin
            If OpenScannedImageDialog.Execute
              then
                begin
                  DocumentTable.FieldByName('DocumentLocation').Text := OpenScannedImageDialog.FileName;
                  DocumentTable.FieldByName('DocumentType').AsInteger := dtScannedImage;
                  DocumentTableAfterScroll(Dataset);
                end
              else DocumentTable.Cancel;

          end;  {dtOpenScannedImage}

        dtOpenWordDocument :
          begin
            DocumentDialog.Filter := 'MS Word documents|*.doc|All Files|*.*';

            If DocumentDialog.Execute
              then
                begin
                  DocumentTable.FieldByName('DocumentLocation').Text := DocumentDialog.FileName;
                  DocumentTable.FieldByName('DocumentType').AsInteger := dtMSWord;
                  DocumentTableAfterScroll(Dataset);
                end
              else DocumentTable.Cancel;

          end;  {dtOpenWordDocument}

        dtCreateWordDocument :
          try
            DocumentTable.FieldByName('DocumentType').AsInteger := dtMSWord;

            InsertNameAndAddress := (MessageDlg('Do you want to insert the current name and address of this parcel?',
                                     mtConfirmation, [mbYes, mbNo], 0) = idYes);

            CreateWordDocument(WordApplication, WordDocument);

            with WordApplication do
              begin
                  {CHG04022002-1: Give them the option of inserting the name and address.}

                If InsertNameAndAddress
                  then
                    begin
                      _Selection := WordApplication.Selection;

                        {If it does not exist in NY, use the main parcel table.}

                      If _Locate(NYParcelTable, [GlblNextYear, SwisSBLKey], '', [loParseSwisSBLKey])
                        then TempParcelTable := NYParcelTable
                        else
                          begin
                            TempParcelTable := TYParcelTable;
                            _Locate(TYParcelTable, [GlblThisYear, SwisSBLKey], '', [loParseSwisSBLKey])
                          end;

                      GetNameAddress(TempParcelTable, NAddrArray);

                      For I := 1 to 6 do
                        If (Deblank(NAddrArray[I]) <> '')
                          then
                            begin
                              _Selection.TypeText(NAddrArray[I]);
                              _Selection.TypeParagraph;
                            end;

                    end;  {InsertNameAndAddress}

                DocumentActive := True;
                CurrentDocumentName := '';
                GlblApplicationIsActive := False;
                OLEItemNameTimer.Enabled := True;

              end;  {with WordApplication do}

          except
            MessageDlg('Sorry, there was an problem linking with Word.' + #13 +
                       'Please try again.', mtError, [mbOK], 0);
            DocumentTable.Cancel;
          end;  {dtCreateWordDocument}

        dtOpenExcelSpreadsheet :
          begin
            DocumentDialog.Filter := 'Excel spreadsheets|*.xls|All Files|*.*';

            If DocumentDialog.Execute
              then
                begin
                  DocumentTable.FieldByName('DocumentLocation').Text := DocumentDialog.FileName;
                  DocumentTable.FieldByName('DocumentType').AsInteger := dtExcel;
                  DocumentTableAfterScroll(Dataset);
                end
              else DocumentTable.Cancel;

          end;  {dtOpenExcelSpreadsheet}

        dtCreateExcelSpreadsheet :
          try
            DocumentTable.FieldByName('DocumentType').AsInteger := dtExcel;

            CreateExcelDocument(ExcelApplication, lcID);
            DocumentActive := True;
            CurrentDocumentName := '';
            GlblApplicationIsActive := False;
            OLEItemNameTimer.Enabled := True;

          except
            MessageDlg('Sorry, there was an problem linking with Excel.' + #13 +
                       'Please try again.', mtError, [mbOK], 0);
            DocumentTable.Cancel;
          end;  {dtCreateExcelSpreadsheet}

        dtOpenWordPerfectDocument :
          begin
            DocumentDialog.Filter := 'Word Perfect documents|*.wpd|All Files|*.*';

            If DocumentDialog.Execute
              then
                begin
                  DocumentTable.FieldByName('DocumentLocation').Text := DocumentDialog.FileName;
                  DocumentTable.FieldByName('DocumentType').AsInteger := dtWordPerfect;
                  DocumentTableAfterScroll(Dataset);
                end
              else DocumentTable.Cancel;

          end;  {dtOpenWordPerfectDocument}

        dtCreateWordPerfectDocument :
          begin
              {CHG04022002-1: Give them the option of inserting the name and address.}

            InsertNameAndAddress := (MessageDlg('Do you want to insert the current name and address of this parcel?',
                                     mtConfirmation, [mbYes, mbNo], 0) = idYes);

(*            PerfectScript.Connect;*)

            If InsertNameAndAddress
              then
                begin
                    {If it does not exist in NY, use the main parcel table.}

                  If _Locate(NYParcelTable, [GlblNextYear, SwisSBLKey], '', [loParseSwisSBLKey])
                    then TempParcelTable := NYParcelTable
                    else
                      begin
                        TempParcelTable := TYParcelTable;
                        _Locate(TYParcelTable, [GlblThisYear, SwisSBLKey], '', [loParseSwisSBLKey])
                      end;

                  GetNameAddress(TempParcelTable, NAddrArray);

                    {For WordPerfect, we have to copy to the clipboard and
                     then paste.  To do this, we will fill in the name
                     and address into a memo, copy it to the clipboard
                     and then paste.}

                  TempMemo := TMemo.Create(Self);
                  TempMemo.ParentWindow := Self.Handle;
                  TempMemo.Lines.Clear;

                  For I := 1 to 6 do
                    If (Deblank(NAddrArray[I]) <> '')
                      then TempMemo.Lines.Add(NAddrArray[I]);

                  TempMemo.SelectAll;
                  TempMemo.CopyToClipboard;

(*                  PerfectScript.Paste;*)

                  TempMemo.Free;

                end;  {InsertNameAndAddress}

(*            PerfectScript.AppMaximize;

            PerfectScript.Disconnect;
            OLEItemNameTimer.Enabled := True;*)

          end;  {dtCreateWordPerfectDocument}

        dtOpenPDFDocument :
          If OpenPDFDialog.Execute
            then
              begin
                DocumentTable.FieldByName('DocumentLocation').AsString := OpenPDFDialog.FileName;
                DocumentTable.FieldByName('DocumentType').AsInteger := dtAdobePDF;
                DocumentTableAfterScroll(nil);
              end
            else DocumentTable.Cancel;

(*        dtOpenQuattroProSpreadsheet :
          begin
            DocumentDialog.Filter := 'Quattro Pro notebooks|*.qpw|All Files|*.*';

            If DocumentDialog.Execute
              then
                begin
                  DocumentTableDocumentLocation.Text := DocumentDialog.FileName;
                  DocumentTable.FieldByName('DocumentType').AsInteger := dtQuattroPro;
                  MainDataSourceDataChange(Dataset, nil);
                end
              else DocumentTable.Cancel;

          end;  {dtOpenQuattroProSpreadsheet}

        dtCreateQuattroProSpreadsheet :
          begin
            try
              QuattroPro := GetActiveOleObject('QuattroPro.PerfectScript');
            except
              QuattroPro := CreateOleObject('QuattroPro.PerfectScript');
            end;

            QuattroPro.WindowQPW_Maximize;
            QuattroPro.Quit;

            QuattroPro := unassigned;

          end;  {dtCreateQuattroProSpreadsheet} *)

      end;  {case DocumentTypeSelected of}

end;  {DocumentTableAfterInsert}

{======================================================}
Procedure TGrievanceSubform.DocumentTableAfterScroll(DataSet: TDataSet);

var
  FileName : String;

begin
  If not InitializingForm
    then
      begin
        Cursor := crHourglass;

          {FXX07272001-2: If the data is downloaded from a network to a portable,
                          try to find the pictures on the local drive.}

        If (Deblank(DocumentTable.FieldByName('DocumentLocation').Text) <> '')
          then
            case DocumentTable.FieldByName('DocumentType').AsInteger of
              0,
              dtScannedImage :
                begin
                  Notebook.PageIndex := 0;

                  try
                    If FileExists(DocumentTable.FieldByName('DocumentLocation').Text)
                      then Image.ImageName := DocumentTable.FieldByName('DocumentLocation').Text
                      else Image.ImageName := ChangeLocationToLocalDrive(DocumentTable.FieldByName('DocumentLocation').Text);
                  except
                    MessageDlg('Unable to connect to scanned image ' +
                               DocumentTable.FieldByname('DocumentLocation').Text + '.',
                               mtError, [mbOK], 0);
                  end;

                  SetScrollBars;

                end;  {dtScannedImage}

              dtMSWord,
              dtExcel,
              dtWordPerfect,
              dtQuattroPro :
                begin
                  Notebook.PageIndex := 1;

                  If FileExists(DocumentTable.FieldByName('DocumentLocation').Text)
                    then FileName := DocumentTable.FieldByName('DocumentLocation').Text
                    else FileName := ChangeLocationToLocalDrive(DocumentTable.FieldByName('DocumentLocation').Text);

                    {FXX03152004-2(2.08): Make it so that Word documents show in the OLE container.}

(*                  with OleContainer do
                    If (DocumentTable.FieldByName('DocumentType').AsInteger = dtMSWord)
                      then
                        begin
                          AllowActiveDoc := True;
                          AutoActivate := aaGetFocus;
                        end
                      else
                        begin
                          AllowActiveDoc := False;
                          AutoActivate := aaManual;
                        end;  {else of If (DocumentTable.FieldByName('DocumentType').AsInteger = dtMSWord)} *)

                  OleContainer.CreateObjectFromFile(DocumentTable.FieldByName('DocumentLocation').Text, False);

                  If (DocumentTable.FieldByName('DocumentType').AsInteger = dtMSWord)
                    then OleWordDocumentTimer.Enabled := True;

                end;  {dtMSWord}

              dtAdobePdf : Notebook.PageIndex := 3;

            end;  {case DocumentTable.FieldByName('DocumentType').AsInteger of}

        Cursor := crDefault;

      end;  {If ((not InitializingForm) and}

end;  {DocumentTableAfterScroll}

{======================================================}
Procedure TGrievanceSubform.OleWordDocumentTimerTimer(Sender: TObject);

{FXX03152004-2(2.08): Make it so that Word documents show in the OLE container.}

begin
  OleWordDocumentTimer.Enabled := False;
  OleContainer.SetFocus;
(*  OleContainer.DoVerb(ovShow); *)

end;  {OleWordDocumentTimerTimer}

{======================================================}
Procedure TGrievanceSubform.OLEItemNameTimerTimer(Sender: TObject);

{Keep checking for the document name until they return to the application.}

begin
  If GlblApplicationIsActive
    then
      begin
        OLEItemNameTimer.Enabled := False;
        DocumentTableAfterScroll(DocumentTable);
      end
    else
      begin
        If (DocumentTable.State in [dsEdit, dsInsert])
          then
            try
              case DocumentTable.FieldByName('DocumentType').AsInteger of
                dtMSWord : DocumentTable.FieldByName('DocumentLocation').Text := WordDocument.FullName;
                dtExcel : DocumentTable.FieldByName('DocumentLocation').Text := ExcelApplication.ActiveWorkbook.FullName[lcID];

                dtWordPerfect :
                  begin
(*                    PerfectScript.Connect;
                    DocumentTable.FieldByName('DocumentLocation').Text := PerfectScript.envPath +
                                                                      PerfectScript.envName;
                    PerfectScript.Disconnect;*)

                      {We do not have an event to catch the close of the document, so
                       turn off the timer when the location has a value.}

                    If (Deblank(DocumentTable.FieldByName('DocumentLocation').Text) <> '')
                      then GlblApplicationIsActive := False;

                  end;  {dtWordPerfect}

              end;  {case DocumentTable.FieldByName('DocumentType').AsInteger of}
            except
            end;

      end;  {If GlblApplicationIsActive}

end;  {OLEItemNameTimerTimer}

{======================================================}
Procedure TGrievanceSubform.WordApplicationQuit(Sender: TObject);

begin
  DocumentActive := False;
end;

{======================================================}
Procedure TGrievanceSubform.WordDocumentClose(Sender: TObject);

begin
  If not WordDocument.Saved
    then WordDocument.Save;

  If (DocumentTable.State in [dsEdit, dsInsert])
    then DocumentTable.FieldByName('DocumentLocation').Text := WordDocument.FullName;

  DocumentActive := False;

end;  {WordDocumentClose}

{======================================================}
Procedure TGrievanceSubform.NewDocumentButtonClick(Sender: TObject);

begin
  DocumentTable.Insert;
end;

{===============================================================}
Procedure TGrievanceSubform.ExcelApplicationWorkbookBeforeClose(    Sender: TObject;
                                                                  var Wb, Cancel: OleVariant);

begin
  If not ExcelApplication.ActiveWorkbook.Saved[lcID]
    then ExcelApplication.ActiveWorkbook.Save(lcID);

  If (DocumentTable.State in [dsEdit, dsInsert])
    then DocumentTable.FieldByName('DocumentLocation').Text := ExcelApplication.ActiveWorkbook.FullName[lcID];

  DocumentActive := False;

end;  {ExcelApplicationWorkbookBeforeClose}

{======================================================}
Procedure TGrievanceSubform.DeleteDocumentButtonClick(Sender: TObject);

begin
  If (MessageDlg('Are you sure you want to delete the link to this document?', mtConfirmation,
                 [mbYes, mbNo], 0) = idYes)
    then
      try
        If (MessageDlg('Do you want to delete the actual document also?', mtConfirmation, [mbYes, mbNo], 0) = idYes)
          then
            try
              DeleteFile(PChar(DocumentTable.FieldByName('DocumentLocation').Text));
            except
              MessageDlg('There was an error deleting the document.' + #13 +
                         'Please remove it manually.', mtError, [mbOK], 0);
            end
          else MessageDlg('Please note that only the link was deleted, not the actual document.', mtWarning, [mbOK], 0);

        DocumentTable.Delete;

      except
        SystemSupport(005, DocumentTable, 'Error deleting document link.',
                      UnitName, GlblErrorDlgBox);
      end;

end;  {DeleteDocumentButtonClick}

{======================================================}
Procedure TGrievanceSubform.FullScreenButtonClick(Sender: TObject);

var
  FullScreenForm : TFullScreenViewForm;
  FileName : OLEVariant;

begin
  OleContainer.DestroyObject;
  FileName := DocumentTable.FieldByName('DocumentLocation').Text;
  FullScreenForm := nil;

  case DocumentTable.FieldByName('DocumentType').AsInteger of
    0,
    dtScannedImage :
      try
        FullScreenForm := TFullScreenViewForm.Create(self);
        FullScreenForm.Image.ImageName := DocumentTable.FieldByName('DocumentLocation').Text;
        FullScreenForm.Image.ImageLibPalette := False;
        FullScreenForm.ShowModal;
      finally
        FullScreenForm.Free;
      end;

    dtMSWord : OpenWordDocument(WordApplication, WordDocument, FileName);

    dtExcel : OpenExcelDocument(ExcelApplication, lcID, FileName);

    dtAdobePdf : ShellExecute(0, 'open',
                              PChar(DocumentTable.FieldByName('DocumentLocation').AsString),
                              nil, nil, SW_NORMAL);

  end;  {case MainTable.FieldByName('DocumentType').AsInteger of}

end;  {FullScreenButtonClick}

{==================================================================}
Procedure TGrievanceSubform.btnDocumentSaveClick(Sender: TObject);

begin
  If (DocumentTable.State in [dsEdit, dsInsert])
    then
      try
        DocumentTable.Post;
      except
        SystemSupport(006, DocumentTable, 'Error posting document link.',
                      UnitName, GlblErrorDlgBox);
      end;

end;

{==================================================================}
Procedure TGrievanceSubform.FormCloseQuery(    Sender: TObject;
                                           var CanClose: Boolean);

var
  Decision : Integer;

begin
  CanClose := True;
  Decision := idNo;

  If (GrievanceTable.Modified or
      GrievanceResultsTable.Modified or
      GrievanceBoardTable.Modified or
      DocumentTable.Modified)
    then
      begin
        If GlblAskSave
          then Decision := MessageDlg('Do you want to save your grievance changes?', mtConfirmation,
                                      [mbYes, mbNo, mbCancel], 0);

        If ((not GlblAskSave) or
            (Decision = idOK))
          then SaveAllChanges;

        If GlblAskSave
          then
            begin
              If (Decision = idNo)
                then CancelAllChanges;

              If (Decision = idCancel)
                then CanClose := False;

            end;  {If GlblAskSave}

      end;  {If (GrievanceTable.Modified or}

end;  {FormCloseQuery}

{==================================================================}
Procedure TGrievanceSubform.CloseButtonClick(Sender: TObject);

begin
  Close;
end;

{==================================================================}
Procedure TGrievanceSubform.FormClose(    Sender: TObject;
                                      var Action: TCloseAction);
begin
  FreeTList(FieldTraceInformationList, SizeOf(FieldTraceInformationRecord));
  CloseTablesForForm(Self);
end;


end.
