unit PCertiorariSubFormUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, ComCtrls, wwdblook, wwriched, wwrichedspell,
  Grids, Wwdbigrd, Wwdbgrid, DBCtrls, Mask, Db, Wwdatsrc, DBTables, Wwtable,
  wwdbedit, Wwdotdot, Wwdbcomb, RPCanvas, RPrinter, RPDefine, RPBase,
  RPFiler, RPMemo, RPDBUtil, RPTable, RPDBTabl, RPShell, OleCtnrs, TMultiP,
  MMOpen, Word97, Excel97, OleServer, ShellAPI, Printers;

type
  TCertiorariSubform = class(TForm)
    PageControl: TPageControl;
    SummaryTabSheet: TTabSheet;
    Panel1: TPanel;
    CloseButton: TBitBtn;
    SaveButton: TBitBtn;
    CancelButton: TBitBtn;
    BroadcastButton: TBitBtn;
    ParcelTabSheet: TTabSheet;
    PetitionerTabSheet: TTabSheet;
    CalenderTabSheet: TTabSheet;
    CertInfoTabSheet: TTabSheet;
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
    TimeOfCertiorariInformationGroupBox: TGroupBox;
    CertiorariNotesRichEdit: TwwDBRichEditMSWord;
    Label22: TLabel;
    CertiorariTable: TwwTable;
    CertiorariDataSource: TwwDataSource;
    TimeOfCertiorariPageControl: TPageControl;
    TabSheet2: TTabSheet;
    ExemptionsTabSheet: TTabSheet;
    SalesTabSheet: TTabSheet;
    TabSheet5: TTabSheet;
    Label25: TLabel;
    Label26: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    PropertyClassCodeText: TDBText;
    EditLegalAddrNo: TDBEdit;
    EditLegalAddr: TDBEdit;
    EditHomesteadCode: TDBEdit;
    EditCurrentFullMarketValue: TDBEdit;
    EditPropertyClassCode: TDBEdit;
    EditOwnership: TDBEdit;
    EditResidentialPercent: TDBEdit;
    EditRollSection: TDBEdit;
    PriorValueLabel: TLabel;
    CurrentValueLabel: TLabel;
    Label31: TLabel;
    Label30: TLabel;
    EditCurrentTotalValue: TDBEdit;
    EditPriorTotalValue: TDBEdit;
    EditCurrentLandValue: TDBEdit;
    EditPriorLandValue: TDBEdit;
    GrievanceExemptionGrid: TwwDBGrid;
    Label29: TLabel;
    EditEqualizationRate: TDBEdit;
    EditPriorFullMarketValue: TDBEdit;
    Label27: TLabel;
    CalenderTable: TwwTable;
    CalenderDataSource: TwwDataSource;
    ConferenceGroupBox: TGroupBox;
    CalenderGrid: TwwDBGrid;
    NewCalenderButton: TBitBtn;
    RemoveCalenderButton: TBitBtn;
    AppraisalTable: TwwTable;
    AppraisalDataSource: TwwDataSource;
    CertiorariGroupBox: TGroupBox;
    Label33: TLabel;
    Label34: TLabel;
    Label35: TLabel;
    EditNoticeOfPetition: TDBEdit;
    EditNoticeOfIssue: TDBEdit;
    EditNumberOfParcels: TDBEdit;
    Label36: TLabel;
    EditTownAudit: TDBEdit;
    PetitionerAskingGroupBox: TGroupBox;
    Label48: TLabel;
    Label49: TLabel;
    Label52: TLabel;
    Label53: TLabel;
    Label54: TLabel;
    Label55: TLabel;
    SubreasonCodeText: TDBText;
    Label56: TLabel;
    EditAskingLandValue: TDBEdit;
    EditAskingTotalValue: TDBEdit;
    ComplaintReasonLookupCombo: TwwDBLookupCombo;
    ComplaintSubreasonRichEdit: TwwDBRichEditMSWord;
    ComplaintSubreasonButton: TButton;
    AskingExemptionsGrid: TwwDBGrid;
    ExemptionCodeAskedLookupCombo: TwwDBLookupCombo;
    DeleteExemptionAskedButton: TBitBtn;
    AddExemptionClaimedButton: TBitBtn;
    CalenderItemComboBox: TwwDBComboBox;
    JudgeCodeLookupCombo: TwwDBLookupCombo;
    JudgeCodeTable: TwwTable;
    PrintDialog: TPrintDialog;
    AppraisalTabSheet: TTabSheet;
    AppraisalGroupBox: TGroupBox;
    AppraisalGrid: TwwDBGrid;
    NewAppraisalButton: TBitBtn;
    RemoveAppraisalButton: TBitBtn;
    ResultsGroupBox: TGroupBox;
    Label37: TLabel;
    Label38: TLabel;
    Label39: TLabel;
    Label41: TLabel;
    Label40: TLabel;
    Label42: TLabel;
    Label43: TLabel;
    Label44: TLabel;
    Label50: TLabel;
    ResultTypeLookupCombo: TwwDBLookupCombo;
    EditResultDate: TDBEdit;
    EditResolutionNumber: TDBEdit;
    EditGrantedLandAmount: TDBEdit;
    EditPostTrialMemoDate: TDBEdit;
    EditFinalOrderDate: TDBEdit;
    EditGrantedEXCode: TDBEdit;
    EditGrantedEXAmount: TDBEdit;
    EditGrantedEXPercent: TDBEdit;
    AppraiserLookupCombo: TwwDBLookupCombo;
    AppraiserCodeTable: TwwTable;
    CertiorariExemptionsTable: TwwTable;
    CertiorariExemptionsDataSource: TwwDataSource;
    CertiorariSalesTable: TwwTable;
    CertiorariSalesDataSource: TwwDataSource;
    SalesGrid: TwwDBGrid;
    CertiorariSpecialDistrictTable: TwwTable;
    CertiorariSpecialDistrictDataSource: TwwDataSource;
    CertiorariSpecialDistrictDBGrid: TwwDBGrid;
    GroupBox1: TGroupBox;
    LabelOldParcelID: TLabel;
    Label57: TLabel;
    Label58: TLabel;
    Label59: TLabel;
    Label60: TLabel;
    Label61: TLabel;
    Label62: TLabel;
    Label63: TLabel;
    Label64: TLabel;
    LabelSwisCode: TLabel;
    AttorneyTreeView: TTreeView;
    CertSummaryGroupBox: TGroupBox;
    EditOldParcelID: TEdit;
    EditOwner: TDBEdit;
    EditPetitioner: TDBEdit;
    EditYear: TDBEdit;
    EditIndexNumber: TDBEdit;
    EditPropertyClass: TDBEdit;
    EditSchool: TDBEdit;
    EditEqRate: TDBEdit;
    EditLocation: TEdit;
    EditSwisCode: TEdit;
    Label67: TLabel;
    Label68: TLabel;
    EditCurrentAssessment: TDBEdit;
    EditPetitionerAssessment: TDBEdit;
    EditPetitionerFullMarket: TDBEdit;
    EditCurrentFullMarket: TDBEdit;
    Label69: TLabel;
    Label70: TLabel;
    Label66: TLabel;
    EditFinalAssessment: TDBEdit;
    EditFinalFullMarket: TDBEdit;
    Label71: TLabel;
    Label72: TLabel;
    EditAssessmentDifference: TEdit;
    EditFullMarketDifference: TEdit;
    SetFocusOnPageTimer: TTimer;
    CertiorariExemptionsAskedTable: TTable;
    PropertyClassCodeTable: TTable;
    CertiorariExemptionsAskedDataSource: TwwDataSource;
    Label73: TLabel;
    EditGrantedTotalAssessment: TDBEdit;
    DispositionCodeTable: TwwTable;
    Label74: TLabel;
    ResultsNotesMemo: TwwDBRichEditMSWord;
    GrievanceComplaintReasonTable: TwwTable;
    GrievanceComplaintSubreasonTable: TwwTable;
    SwisCodeTable: TTable;
    Label51: TLabel;
    EditUniformPercentOfValue: TDBEdit;
    Label65: TLabel;
    EditRAR: TDBEdit;
    ArticleTypeRadioGroup: TDBRadioGroup;
    LawyerCodeTable: TTable;
    PrintButton: TBitBtn;
    ReportFiler: TReportFiler;
    ReportPrinter: TReportPrinter;
    ExemptionCodeTable: TwwTable;
    Label32: TLabel;
    EditGrievanceResults: TDBEdit;
    SettlementSheetButton: TBitBtn;
    Label75: TLabel;
    EditAlternateID: TDBEdit;
    PropertyClassDataSource: TDataSource;
    SchoolInterventionCheckBox: TDBCheckBox;
    CertiorariNotesTable: TTable;
    CertiorariNotesTablePrinter: TDBTablePrinter;
    CertiorariNotesTablePrinterDateEntered: TDBTableColumn;
    CertiorariNotesTablePrinterEnteredBy: TDBTableColumn;
    CertiorariNotesTablePrinterOpen: TDBTableColumn;
    CertiorariNotesTablePrinterNote: TDBTableColumn;
    CertiorariNotesTablePrinterBodyHeader: TTableSection;
    EditRARParcelInfoPage: TDBEdit;
    Label76: TLabel;
    PetitionerAndRepresentativeInfoNotebook: TNotebook;
    GroupBox2: TGroupBox;
    Label82: TLabel;
    Label88: TLabel;
    Label89: TLabel;
    Label90: TLabel;
    Label91: TLabel;
    Label92: TLabel;
    Label93: TLabel;
    Label94: TLabel;
    Label95: TLabel;
    EditOldStylePetitName1: TDBEdit;
    EditOldStylePetitName2: TDBEdit;
    EditOldStylePetitAddr1: TDBEdit;
    EditOldStylePetitAddr2: TDBEdit;
    EditOldStylePetitStreet: TDBEdit;
    EditOldStylePetitCity: TDBEdit;
    EditOldStylePetitState: TDBEdit;
    EditOldStylePetitZip: TDBEdit;
    EditOldStylePetitZipPlus4: TDBEdit;
    PetitionerGroupBox: TGroupBox;
    Label96: TLabel;
    Label97: TLabel;
    Label98: TLabel;
    Label99: TLabel;
    Label100: TLabel;
    EditOldStyleLawyerLookupCombo: TwwDBLookupCombo;
    EditOldStylePetitPhoneNumber: TDBEdit;
    EditOldStylePetitFaxNumber: TDBEdit;
    EditOldStylePetitEmail: TDBEdit;
    EditOldStylePetitAttorneyName: TDBEdit;
    ExtendedRepInfoPageControl: TPageControl;
    PetitionerNameAddressTabSheet: TTabSheet;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label11: TLabel;
    EditPetitionerState: TDBEdit;
    EditPetitionerZip: TDBEdit;
    EditPetitionerZipPlus4: TDBEdit;
    EditPetitionerName1: TDBEdit;
    EditPetitionerName2: TDBEdit;
    EditPetitionerAddress1: TDBEdit;
    EditPetitionerAddress2: TDBEdit;
    EditPetitionerStreet: TDBEdit;
    EditPetitionerCity: TDBEdit;
    EditPetitionerPhone: TDBEdit;
    RepresentativeNameAddressTabSheet: TTabSheet;
    Label3: TLabel;
    Label45: TLabel;
    Label46: TLabel;
    Label47: TLabel;
    Label77: TLabel;
    Label78: TLabel;
    Label79: TLabel;
    Label80: TLabel;
    Label81: TLabel;
    Label83: TLabel;
    Label84: TLabel;
    Label85: TLabel;
    Label86: TLabel;
    Label87: TLabel;
    EditAttorneyName1: TDBEdit;
    EditAttorneyName2: TDBEdit;
    EditAttorneyAddress1: TDBEdit;
    EditAttorneyAddress2: TDBEdit;
    EditAttorneyStreet: TDBEdit;
    EditAttorneyCity: TDBEdit;
    EditAttorneyState: TDBEdit;
    EditAttorneyZip: TDBEdit;
    EditAttorneyZipPlus4: TDBEdit;
    EditAttorneyPhone: TDBEdit;
    LawyerLookupCombo: TwwDBLookupCombo;
    EditAttorney: TDBEdit;
    EditFaxNumber: TDBEdit;
    EditEMailAddress: TDBEdit;
    tbs_CertiorariDocument: TTabSheet;
    MainPanel: TPanel;
    gd_Document: TwwDBGrid;
    btn_FullScreen: TBitBtn;
    btn_PrintDocument: TBitBtn;
    ntbk_Document: TNotebook;
    ImagePanel: TPanel;
    ImageScrollBox: TScrollBox;
    Image: TPMultiImage;
    Panel3: TPanel;
    ScrollBox1: TScrollBox;
    OleContainer: TOleContainer;
    btn_DeleteDocument: TBitBtn;
    btn_NewDocument: TBitBtn;
    btn_SaveDocument: TBitBtn;
    tb_CertiorariDocuments: TwwTable;
    ds_CertiorariDocuments: TwwDataSource;
    tb_CertiorariDocumentsTaxRollYr: TStringField;
    tb_CertiorariDocumentsSwisSBLKey: TStringField;
    tb_CertiorariDocumentsCertiorariNumber: TIntegerField;
    tb_CertiorariDocumentsDocumentNumber: TIntegerField;
    tb_CertiorariDocumentsDocumentLocation: TStringField;
    tb_CertiorariDocumentsDate: TDateField;
    tb_CertiorariDocumentsNotes: TStringField;
    tb_CertiorariDocumentsReserved: TStringField;
    tb_CertiorariDocumentsDocumentType: TIntegerField;
    Label101: TLabel;
    Label102: TLabel;
    tb_CertiorariDocumentsDocumentTypeDescription: TStringField;
    tb_DocumentType: TwwTable;
    tb_CertiorariDocumentsLookup: TwwTable;
    IntegerField1: TIntegerField;
    StringField1: TStringField;
    DateField1: TDateField;
    StringField2: TStringField;
    StringField3: TStringField;
    StringField4: TStringField;
    StringField5: TStringField;
    IntegerField2: TIntegerField;
    StringField6: TStringField;
    IntegerField3: TIntegerField;
    WordDocument: TWordDocument;
    OLEItemNameTimer: TTimer;
    ExcelApplication: TExcelApplication;
    WordApplication: TWordApplication;
    OleWordDocumentTimer: TTimer;
    DocumentDialog: TOpenDialog;
    OpenScannedImageDialog: TMMOpenDialog;
    OpenPDFDialog: TOpenDialog;
    procedure NewCalenderButtonClick(Sender: TObject);
    procedure RemoveCalenderButtonClick(Sender: TObject);
    procedure PrintCalenderButtonClick(Sender: TObject);
    procedure CalenderTableNewRecord(DataSet: TDataSet);
    procedure SaveButtonClick(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject);
    procedure NewAppraisalButtonClick(Sender: TObject);
    procedure RemoveAppraisalButtonClick(Sender: TObject);
    procedure AppraisalTableNewRecord(DataSet: TDataSet);
    procedure SetFocusOnPageTimerTimer(Sender: TObject);
    procedure AddExemptionClaimedButtonClick(Sender: TObject);
    procedure DeleteExemptionAskedButtonClick(Sender: TObject);
    procedure PageControlChange(Sender: TObject);
    procedure ComplaintReasonLookupComboCloseUp(Sender: TObject;
      LookupTable, FillTable: TDataSet; modified: Boolean);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CloseButtonClick(Sender: TObject);
    procedure CertiorariTableBeforeEdit(DataSet: TDataSet);
    procedure CertiorariTableBeforePost(DataSet: TDataSet);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure CertiorariTableAfterPost(DataSet: TDataSet);
    procedure LawyerLookupComboCloseUp(Sender: TObject; LookupTable,
      FillTable: TDataSet; modified: Boolean);
    procedure LawyerLookupComboDropDown(Sender: TObject);
    procedure PrintButtonClick(Sender: TObject);
    procedure ReportPrint(Sender: TObject);
    procedure ResultTypeLookupComboCloseUp(Sender: TObject; LookupTable,
      FillTable: TDataSet; modified: Boolean);
    procedure SettlementSheetButtonClick(Sender: TObject);
    procedure tb_CertiorariDocumentsAfterDelete(DataSet: TDataSet);
    procedure tb_CertiorariDocumentsAfterInsert(DataSet: TDataSet);
    procedure tb_CertiorariDocumentsNewRecord(DataSet: TDataSet);
    procedure tb_CertiorariDocumentsAfterScroll(DataSet: TDataSet);
    procedure tb_CertiorariDocumentsCalcFields(DataSet: TDataSet);
    procedure btn_NewDocumentClick(Sender: TObject);
    procedure btn_DeleteDocumentClick(Sender: TObject);
    procedure btn_FullScreenClick(Sender: TObject);
    procedure btn_PrintDocumentClick(Sender: TObject);
    procedure btn_SaveDocumentClick(Sender: TObject);
    procedure WordApplicationQuit(Sender: TObject);
    procedure WordDocumentClose(Sender: TObject);
    procedure ExcelApplicationWorkbookBeforeClose(Sender: TObject; var Wb,
      Cancel: OleVariant);
    procedure tb_CertiorariDocumentsBeforePost(DataSet: TDataSet);
    procedure tb_CertiorariDocumentsAfterPost(DataSet: TDataSet);
    procedure OleWordDocumentTimerTimer(Sender: TObject);
    procedure OLEItemNameTimerTimer(Sender: TObject);
    procedure CertiorariTableAfterEdit(DataSet: TDataSet);
  private
    { Private declarations }
  public
    { Public declarations }
    UnitName,
    CertiorariYear,
    SwisSBLKey : String;
    CertiorariNumber : LongInt;
    EditMode : Char;  {A = Add; M = Modify; V = View}
    CertiorariProcessingType : Integer;
    InitializingForm : Boolean;
    OldLawyerCode : String;
    OrigPetitionerTotalValue,
    OrigGrantedTotalValue : LongInt;
    PrintCertiorariNotes : Boolean;
    lcid, DocumentTypeSelected : Integer;
    DocumentActive : Boolean;
    CurrentDocumentName : String;
    FieldTraceInformationList : TList;

    Procedure FillInSummaryCertInfo;
    Procedure InitializeForm;
    Procedure SaveAllChanges;
    Procedure CancelAllChanges;
    Procedure SetScrollBars;

  end;

var
  CertiorariSubform: TCertiorariSubform;

implementation

{$R *.DFM}

uses GlblVars, WinUtils, PASUtils, PASTypes, Utilitys, GlblCnst,
     GrievanceUtilitys, CSettlementSheetPrintUnit,
     DataAccessUnit, UtilOLE, FullScrn,
     GrievanceComplaintSubreasonDialogUnit, Preview, DocumentTypeDialog;

{================================================================}
Procedure TCertiorariSubform.FillInSummaryCertInfo;

var
  AVDifference, FullMktDifference : LongInt;
  NAddrArray : NameAddrArray;
  I : Integer;

begin
  with CertiorariTable do
    begin
      If (FieldByName('PetitTotalValue').AsInteger > 0)
        then
          begin
            AVDifference := FieldByName('CurrentTotalValue').AsInteger -
                            FieldByName('PetitTotalValue').AsInteger;

            FullMktDifference := FieldByName('CurrentFullMarketVal').AsInteger -
                                 FieldByName('PetitFullMarketVal').AsInteger;

            EditAssessmentDifference.Text := FormatFloat(IntegerDisplay,
                                                         AVDifference);
            EditFullMarketDifference.Text := FormatFloat(IntegerDisplay,
                                                         FullMktDifference);

          end;  {If (FieldByName('PetitTotalValue').AsInteger > 0)}

        {Attorney Info.}

      with AttorneyTreeView do
        begin
          Items.Clear;
          FillInNameAddrArray(FieldByName('PetitName1').Text,
                              FieldByName('PetitName2').Text,
                              FieldByName('PetitAddress1').Text,
                              FieldByName('PetitAddress2').Text,
                              FieldByName('PetitStreet').Text,
                              FieldByName('PetitCity').Text,
                              FieldByName('PetitState').Text,
                              FieldByName('PetitZip').Text,
                              FieldByName('PetitZipPlus4').Text,
                              True, False, NAddrArray);

          Items.AddChild(nil, 'Firm: ' + FieldByName('LawyerCode').Text);
          Items.AddChild(nil, 'Atty: ' + FieldByName('PetitAttorneyName').Text);

          For I := 1 to 6 do
            If (Deblank(NAddrArray[I]) <> '')
              then Items.AddChild(nil, NAddrArray[I]);

          If (Deblank(FieldByName('PetitPhoneNumber').Text) <> '')
            then Items.AddChild(nil, 'Phone: ' + FieldByName('PetitPhoneNumber').Text);

          If (Deblank(FieldByName('PetitFaxNumber').Text) <> '')
            then Items.AddChild(nil, 'Fax: ' + FieldByName('PetitFaxNumber').Text);

        end;  {with AttorneyTreeView do}

    end;  {with CertiorariTable do}

end;  {FillInSummaryCertInfo}

{================================================================}
Procedure TCertiorariSubform.InitializeForm;

var
  _Found : Boolean;
  SwisCodeTable, AssessmentYearControlTable : TTable;

begin
  DocumentActive := False;
    {FXX01262004-1(2.07l1): Make sure that the subwindows have the same state as the main form.}
(*  WindowState := Application.MainForm.WindowState; *)

  InitializingForm := True;
  UnitName := 'PCertiorariSubform';
  FieldTraceInformationList := TList.Create;

  If (EditMode = 'V')
    then
      begin
        CertiorariTable.ReadOnly := True;
        CertiorariExemptionsAskedTable.ReadOnly := True;
        AppraisalTable.ReadOnly := True;
        CalenderTable.ReadOnly := True;
        SaveButton.Enabled := False;
        CancelButton.Enabled := False;

      end;  {If (EditMode = 'V')}

  If not GlblCanSeeCertAppraisals
    then AppraisalTabSheet.Visible := False;

  OpenTablesForForm(Self, CertiorariProcessingType);

  _Found := FindKeyOld(CertiorariTable, ['TaxRollYr', 'SwisSBLKey', 'CertiorariNumber'],
                       [CertiorariYear, SwisSBLKey, IntToStr(CertiorariNumber)]);

  If not _Found
    then SystemSupport(001, CertiorariTable,
                       'Error finding Certiorari ' + CertiorariYear + '\' +
                       SwisSBLKey + '\' +
                       IntToStr(CertiorariNumber),
                       UnitName, GlblErrorDlgBox);

  Caption := CertiorariYear + ' Index #' +
             CertiorariTable.FieldByName('CertiorariNumber').Text +
             ' for parcel ' + ConvertSwisSBLToDashDot(SwisSBLKey);

    {Set range on the Certiorari results table, the BOAR members, the
     Certiorari exemption table, and find the property class code.}

  SetRangeOld(CertiorariExemptionsAskedTable,
              ['SwisSBLKey', 'TaxRollYr', 'CertiorariNumber', 'ExemptionCode'],
              [SwisSBLKey, CertiorariYear, IntToStr(CertiorariNumber), '     '],
              [SwisSBLKey, CertiorariYear, IntToStr(CertiorariNumber), '99999']);

  SetRangeOld(CertiorariExemptionsTable,
              ['SwisSBLKey', 'TaxRollYr', 'CertiorariNumber', 'ExemptionCode'],
              [SwisSBLKey, CertiorariYear, IntToStr(CertiorariNumber), '     '],
              [SwisSBLKey, CertiorariYear, IntToStr(CertiorariNumber), '99999']);

  SetRangeOld(CertiorariNotesTable,
              ['SwisSBLKey'], [SwisSBLKey], [SwisSBLKey]);

  SetRangeOld(CertiorariSalesTable,
              ['SwisSBLKey', 'CertiorariNumber', 'SaleNumber'],
              [SwisSBLKey, IntToStr(CertiorariNumber), '0'],
              [SwisSBLKey, IntToStr(CertiorariNumber), '99999']);

  SetRangeOld(CertiorariSpecialDistrictTable,
              ['SwisSBLKey', 'TaxRollYr', 'CertiorariNumber', 'SDistCode'],
              [SwisSBLKey, CertiorariYear, IntToStr(CertiorariNumber), '     '],
              [SwisSBLKey, CertiorariYear, IntToStr(CertiorariNumber), 'ZZZZZ']);

  SetRangeOld(AppraisalTable,
              ['SwisSBLKey', 'TaxRollYr', 'CertiorariNumber', 'DateAuthorized'],
              [SwisSBLKey, CertiorariYear, IntToStr(CertiorariNumber), '1/1/1950'],
              [SwisSBLKey, CertiorariYear, IntToStr(CertiorariNumber), '1/1/3000']);

  SetRangeOld(CalenderTable,
              ['SwisSBLKey', 'TaxRollYr', 'CertiorariNumber', 'Date'],
              [SwisSBLKey, CertiorariYear, IntToStr(CertiorariNumber), '1/1/1950'],
              [SwisSBLKey, CertiorariYear, IntToStr(CertiorariNumber), '1/1/3000']);

  _SetRange(tb_CertiorariDocuments,
            [CertiorariYear, SwisSBLKey, IntToStr(CertiorariNumber), '0'],
            [CertiorariYear, SwisSBLKey, IntToStr(CertiorariNumber), '99999'], '', []);

  FindKeyOld(PropertyClassCodeTable, ['MainCode'],
             [CertiorariTable.FieldByName('PropertyClassCode').Text]);

    {Now set display formats on numeric fields.}

  TFloatField(CertiorariTable.FieldByName('PriorLandValue')).DisplayFormat := CurrencyDisplayNoDollarSign;
  TFloatField(CertiorariTable.FieldByName('CurrentLandValue')).DisplayFormat := CurrencyDisplayNoDollarSign;
  TFloatField(CertiorariTable.FieldByName('PriorTotalValue')).DisplayFormat := CurrencyDisplayNoDollarSign;
  TFloatField(CertiorariTable.FieldByName('CurrentTotalValue')).DisplayFormat := CurrencyDisplayNoDollarSign;
  TFloatField(CertiorariTable.FieldByName('PriorFullMarketVal')).DisplayFormat := CurrencyDisplayNoDollarSign;
  TFloatField(CertiorariTable.FieldByName('CurrentFullMarketVal')).DisplayFormat := CurrencyDisplayNoDollarSign;
  TFloatField(CertiorariTable.FieldByName('ResidentialPercent')).DisplayFormat := NoDecimalDisplay_BlankZero;
  TFloatField(CertiorariTable.FieldByName('CurrentEqRate')).DisplayFormat := DecimalEditDisplay;
  TFloatField(CertiorariTable.FieldByName('CurrentUniformPercent')).DisplayFormat := DecimalEditDisplay;
  TFloatField(CertiorariTable.FieldByName('CurrentRAR')).DisplayFormat := DecimalEditDisplay_BlankZero;
  TDateField(CertiorariTable.FieldByName('DispositionDate')).EditMask := DateMask;
  TDateField(CertiorariTable.FieldByName('PostTrialMemo')).EditMask := DateMask;
  TDateField(CertiorariTable.FieldByName('NoticeOfPetition')).EditMask := DateMask;
  TDateField(CertiorariTable.FieldByName('NoteOfIssue')).EditMask := DateMask;
  TDateField(CertiorariTable.FieldByName('FinalOrderDate')).EditMask := DateMask;
  TFloatField(CertiorariTable.FieldByName('PetitLandValue')).DisplayFormat := CurrencyDisplayNoDollarSign;
  TFloatField(CertiorariTable.FieldByName('PetitTotalValue')).DisplayFormat := CurrencyDisplayNoDollarSign;
  TFloatField(CertiorariTable.FieldByName('PetitFullMarketVal')).DisplayFormat := CurrencyDisplayNoDollarSign;
  TFloatField(CertiorariTable.FieldByName('GrantedLandValue')).DisplayFormat := CurrencyDisplayNoDollarSign;
  TFloatField(CertiorariTable.FieldByName('GrantedTotalValue')).DisplayFormat := CurrencyDisplayNoDollarSign;
  TFloatField(CertiorariTable.FieldByName('GrantedFullMarketVal')).DisplayFormat := CurrencyDisplayNoDollarSign;
  TFloatField(CertiorariTable.FieldByName('GrantedEXAmount')).DisplayFormat := CurrencyDisplayNoDollarSign;
  TFloatField(CertiorariTable.FieldByName('GrantedEXPercent')).DisplayFormat := NoDecimalDisplay;

  TFloatField(CertiorariExemptionsTable.FieldByName('Amount')).DisplayFormat := CurrencyDisplayNoDollarSign;
  TFloatField(CertiorariExemptionsTable.FieldByName('Percent')).DisplayFormat := NoDecimalDisplay;
  TFloatField(CertiorariExemptionsTable.FieldByName('OwnerPercent')).DisplayFormat := NoDecimalDisplay;

  TFloatField(CertiorariSpecialDistrictTable.FieldByName('PrimaryUnits')).DisplayFormat := DecimalEditDisplay_BlankZero;
  TFloatField(CertiorariSpecialDistrictTable.FieldByName('SecondaryUnits')).DisplayFormat := DecimalEditDisplay_BlankZero;
  TFloatField(CertiorariSpecialDistrictTable.FieldByName('SDPercentage')).DisplayFormat := DecimalEditDisplay_BlankZero;
  TFloatField(CertiorariSpecialDistrictTable.FieldByName('CalcAmount')).DisplayFormat := NoDecimalDisplay_BlankZero;

  TFloatField(CertiorariExemptionsAskedTable.FieldByName('Amount')).DisplayFormat := CurrencyDisplayNoDollarSign;
  TFloatField(CertiorariExemptionsAskedTable.FieldByName('Percent')).DisplayFormat := NoDecimalDisplay;

  TDateTimeField(AppraisalTable.FieldByName('DateAuthorized')).EditMask := DateMask;
  TDateTimeField(AppraisalTable.FieldByName('DateReceived')).EditMask := DateMask;
  TDateTimeField(AppraisalTable.FieldByName('DatePaid')).EditMask := DateMask;
  AppraisalTable.FieldByName('DateAuthorized').Required := True;
  TFloatField(AppraisalTable.FieldByName('AmountPaid')).DisplayFormat := DecimalEditDisplay;

  TDateTimeField(CalenderTable.FieldByName('Date')).EditMask := DateMask;
  TFloatField(CalenderTable.FieldByName('MunicipalProposal')).DisplayFormat := CurrencyDisplayNoDollarSign;
  TFloatField(CalenderTable.FieldByName('PetitionerProposal')).DisplayFormat := CurrencyDisplayNoDollarSign;
  CalenderTable.FieldByName('Date').Required := True;

(*  case CertiorariProcessingType of
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

  end;  {case CertiorariProcessingType of} *)

    {FXX08272003-2(2.07i): Fix up the current and prior value display labels.}

  CertiorariYear := CertiorariTable.FieldByName('TaxRollYr').Text;
  PriorValueLabel.Caption := 'Prior (' + (IntToStr(StrToInt(CertiorariYear) - 1)) + ')';
  CurrentValueLabel.Caption := 'Current (' + CertiorariYear + ')';

  with CertiorariTable do
    begin
      SwisCodeTable := FindTableInDataModuleForProcessingType(DataModuleSwisCodeTableName,
                                                              CertiorariProcessingType);

      AssessmentYearControlTable := FindTableInDataModuleForProcessingType(DataModuleAssessmentYearControlTableName,
                                                                           CertiorariProcessingType);

      FindKeyOld(SwisCodeTable, ['SwisCode'],
                 [Copy(SwisSBLKey, 1, 6)]);

      EditLocation.Text := GetLegalAddressFromTable(CertiorariTable);

      If GlblLocateByOldParcelID
        then
          begin
            EditOldParcelID.Visible := True;
            LabelOldParcelID.Visible := True;

            EditOldParcelID.Text := ConvertSwisSBLToOldDashDotNoSwis(FieldByName('OldParcelID').Text,
                                                                     AssessmentYearControlTable);

          end;  {If GlblLocateByOldParcelID}

      If (SwisCodeTable.RecordCount > 1)
        then
          begin
            EditSwisCode.Visible := True;
            LabelSwisCode.Visible := True;
            EditSwisCode.Text := Copy(SwisCodeTable.FieldByName('SwisCode').Text, 5, 2) + ' - ' +
                                 SwisCodeTable.FieldByName('MunicipalityName').Text;

          end;  {If (SwisCodeTable.RecordCount > 1)}

      FillInSummaryCertInfo;

    end;  {with CertiorariTable do}

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
        MakeEditNotReadOnly(EditEqualizationRate);
        MakeEditNotReadOnly(EditRARParcelInfoPage);

      end;  {If (GlblUserName = 'SUPERVISOR')}

    {CHG07262004-1(2.08): Option to have attorney information seperate.}

  If GlblGrievanceSeperateRepresentativeInfo
    then PetitionerAndRepresentativeInfoNotebook.PageIndex := 1
    else PetitionerAndRepresentativeInfoNotebook.PageIndex := 0;

  InitializingForm := False;
  PageControl.ActivePage := SummaryTabSheet;
  SetFocusOnPageTimer.Enabled := True;

end;  {InitializeForm}

{================================================================}
Procedure TCertiorariSubform.PageControlChange(Sender: TObject);

begin
  SetFocusOnPageTimer.Enabled := True;
end;  {PageControlChange}

{================================================================}
Procedure TCertiorariSubform.SetFocusOnPageTimerTimer(Sender: TObject);

begin
  SetFocusOnPageTimer.Enabled := False;

  case PageControl.ActivePage.PageIndex of
    1 : EditName.SetFocus;
    2 : If GlblGrievanceSeperateRepresentativeInfo
          then EditPetitionerName1.SetFocus
          else EditOldStylePetitName1.SetFocus;
    3 : ArticleTypeRadioGroup.SetFocus;
    4 : AppraisalGrid.SetFocus;
    5 : CalenderGrid.SetFocus;

  end;  {case PageControl.ActivePage.PageIndex of}

end;  {SetFocusOnPageTimerTimer}

{==========================================================}
Procedure TCertiorariSubform.FormKeyPress(Sender: TObject; var Key: Char);

begin
  If (Key = #13)
    then
      begin
        Perform(WM_NextDlgCtl, 0, 0);
        Key := #0;
      end;  {If (Key = #13)}

end;  {FormKeyPress}

{==========================================================}
Procedure TCertiorariSubform.CertiorariTableBeforeEdit(DataSet: TDataSet);

begin
  with CertiorariTable do
    begin
      OrigPetitionerTotalValue := FieldByName('PetitTotalValue').AsInteger;
      OrigGrantedTotalValue := FieldByName('GrantedTotalValue').AsInteger;
    end;

end;  {CertiorariTableBeforeEdit}

{===================================================================}
Procedure TCertiorariSubform.CertiorariTableAfterEdit(DataSet: TDataSet);

begin
    {FXX05142009-1(2.20.1.1)[D1537]: Audit grievance, small claims, certiorari.}

  CreateFieldValuesAndLabels(Self, CertiorariTable, FieldTraceInformationList);

end;  {CertiorariTableAfterEdit}

{===================================================================}
Procedure TCertiorariSubform.LawyerLookupComboDropDown(Sender: TObject);

begin
  OldLawyerCode := CertiorariTable.FieldByName('LawyerCode').Text;
end;

{===================================================================}
Procedure TCertiorariSubform.LawyerLookupComboCloseUp(Sender: TObject;
                                                      LookupTable,
                                                      FillTable: TDataSet;
                                                      modified: Boolean);

{If they change lawyer codes, then change the petitioner information.}

begin
  If (OldLawyerCode <> LawyerCodeTable.FieldByName('Code').Text)
    then
      begin
        If not (CertiorariTable.State in [dsEdit, dsInsert])
          then CertiorariTable.Edit;

          {CHG07262004-1(2.08): Option to have attorney information separate.}

        If GlblGrievanceSeperateRepresentativeInfo
          then SetAttorneyNameAndAddress(CertiorariTable, LawyerCodeTable,
                                         LawyerCodeTable.FieldByName('Code').Text)
          else SetPetitionerNameAndAddress(CertiorariTable, LawyerCodeTable,
                                           LawyerCodeTable.FieldByName('Code').Text);

      end;  {If (OldLawyerCode <> LawyerCodeTable.FieldByName('Code').Text)}

end;  {LawyerLookupComboCloseUp}

{===================================================================}
Procedure TCertiorariSubform.ComplaintReasonLookupComboCloseUp(Sender: TObject;
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
        Caption := 'Please chose the certiorari reason.';

        If (ShowModal = idOK)
          then
            begin
              TempComplaintSubreasonCode := GrievanceComplaintSubreasonCode;

              FindKeyOld(GrievanceComplaintSubreasonTable, ['Code'],
                         [TempComplaintSubreasonCode]);

              If (CertiorariTable.State = dsBrowse)
                then CertiorariTable.Edit;

              TMemoField(CertiorariTable.FieldByName('PetitSubreason')).Assign(TMemoField(GrievanceComplaintSubreasonTable.FieldByName('Description')));
              CertiorariTable.FieldByName('PetitSubreasonCode').Text := TempComplaintSubreasonCode;

            end;  {If (ShowModal = idOK)}

      end;  {with GrievanceComplaintSubreasonDialog do}

  finally
    GrievanceComplaintSubreasonDialog.Free;
  end;

  EditAskingLandValue.SetFocus;

end;  {ComplaintReasonLookupComboCloseUp}

{================================================================}
Procedure TCertiorariSubform.CertiorariTableBeforePost(DataSet: TDataSet);

begin
  with CertiorariTable do
    begin
      If ((OrigPetitionerTotalValue = 0) and
          (FieldByName('PetitTotalValue').AsInteger > 0))
        then FieldByname('PetitFullMarketVal').AsInteger := Round(ComputeFullValue(FieldByName('PetitTotalValue').AsInteger,
                                                                                   SwisCodeTable,
                                                                                   FieldByName('PropertyClassCode').Text,
                                                                                   FieldByName('OwnershipCode').Text,
                                                                                   GlblUseRAR));

      If ((OrigGrantedTotalValue = 0) and
          (FieldByName('GrantedTotalValue').AsInteger > 0))
        then FieldByName('GrantedFullMarketVal').AsInteger := Round(ComputeFullValue(FieldByName('GrantedTotalValue').AsInteger,
                                                                                     SwisCodeTable,
                                                                                     FieldByName('PropertyClassCode').Text,
                                                                                     FieldByName('OwnershipCode').Text,
                                                                                     GlblUseRAR));

    end;  {with CertiorariTable do}

end;  {CertiorariTableBeforePost}

{================================================================}
Procedure TCertiorariSubform.AddExemptionClaimedButtonClick(Sender: TObject);

begin
  CertiorariExemptionsAskedTable.Append;
  AskingExemptionsGrid.SetFocus;
  AskingExemptionsGrid.SetActiveField('ExemptionCode');

end;  {AddExemptionClaimedButtonClick}

{================================================================}
Procedure TCertiorariSubform.DeleteExemptionAskedButtonClick(Sender: TObject);

begin
  CertiorariExemptionsAskedTable.Delete;
end;

{================================================================}
Procedure TCertiorariSubform.AppraisalTableNewRecord(DataSet: TDataSet);

begin
  with AppraisalTable do
    begin
      FieldByName('SwisSBLKey').Text := SwisSBLKey;
      FieldByName('TaxRollYr').Text := CertiorariYear;
      FieldByName('CertiorariNumber').AsInteger := CertiorariNumber;

    end;  {with AppraisalTable do}

  AppraisalGrid.SetActiveField('DateAuthorized');

end;  {AppraisalTableNewRecord}

{================================================================}
Procedure TCertiorariSubform.NewAppraisalButtonClick(Sender: TObject);

begin
  try
    AppraisalTable.Append;
  except
    SystemSupport(001, AppraisalTable, 'Error appending to Appraisal table.',
                  UnitName, GlblErrorDlgBox);
  end;

end;  {NewAppraisalButtonClick}

{================================================================}
Procedure TCertiorariSubform.RemoveAppraisalButtonClick(Sender: TObject);

begin
  If (MessageDlg('Are you sure you want to delete the appraisal item for ' +
                 AppraisalTable.FieldByName('DateAuthorized').Text + '?',
                 mtConfirmation, [mbYes, mbNo], 0) = idYes)
    then
      try
        AppraisalTable.Delete;
      except
        SystemSupport(002, AppraisalTable, 'Error deleting from Appraisal table.',
                      UnitName, GlblErrorDlgBox);
      end;

end;  {RemoveAppraisalButtonClick}

{=============================================================}
Procedure TCertiorariSubform.CalenderTableNewRecord(DataSet: TDataSet);

begin
  with CalenderTable do
    begin
      FieldByName('SwisSBLKey').Text := SwisSBLKey;
      FieldByName('TaxRollYr').Text := CertiorariYear;
      FieldByName('CertiorariNumber').AsInteger := CertiorariNumber;

    end;  {with CalenderTable do}

  CalenderGrid.SetActiveField('MeetingType');

end;  {CalenderTableNewRecord}

{=============================================================}
Procedure TCertiorariSubform.NewCalenderButtonClick(Sender: TObject);

begin
  try
    CalenderTable.Append;
    CalenderGrid.SetActiveField('MeetingType');
  except
    SystemSupport(001, CalenderTable, 'Error appending to calender table.',
                  UnitName, GlblErrorDlgBox);
  end;

end;  {NewCalenderButtonClick}

{=============================================================}
Procedure TCertiorariSubform.RemoveCalenderButtonClick(Sender: TObject);

begin
  If (MessageDlg('Are you sure you want to delete the calender item for ' +
                 CalenderTable.FieldByName('Date').Text + '?',
                 mtConfirmation, [mbYes, mbNo], 0) = idYes)
    then
      try
        CalenderTable.Delete;
      except
        SystemSupport(002, CalenderTable, 'Error deleting from calender table.',
                      UnitName, GlblErrorDlgBox);
      end;

end;  {RemoveCalenderButtonClick}

{=============================================================}
Procedure TCertiorariSubform.PrintCalenderButtonClick(Sender: TObject);

begin
  If PrintDialog.Execute
    then
      begin
      end;  {If PrintDialog.Execute}

end;  {PrintCalenderButtonClick}

{================================================================}
Procedure TCertiorariSubform.ResultTypeLookupComboCloseUp(Sender: TObject;
                                                          LookupTable,
                                                          FillTable: TDataSet;
                                                          modified: Boolean);

begin
  CertiorariTable.FieldByName('DispositionDate').AsDateTime := Date;
  EditResultDate.SetFocus;
end;  {ResultTypeLookupComboCloseUp}

{================================================================}
Procedure TCertiorariSubform.CertiorariTableAfterPost(DataSet: TDataSet);

begin
  RecordChanges(Self, 'Certiorari', CertiorariTable, SwisSBLKey,
                FieldTraceInformationList);
  FillInSummaryCertInfo;
end;

{================================================================}
Procedure TCertiorariSubform.SaveAllChanges;

var
  PostCancelled : Boolean;

begin
  PostCancelled := False;

  If CertiorariTable.Modified
    then
      try
        CertiorariTable.Post;
      except
        If not PostCancelled
          then SystemSupport(002, CertiorariTable, 'Error posting to Certiorari table.',
                             UnitName, GlblErrorDlgBox);
      end;

  If CertiorariExemptionsAskedTable.Modified
    then
      try
        CertiorariExemptionsAskedTable.Post;
      except
        SystemSupport(070, CertiorariExemptionsAskedTable, 'Error posting to Certiorari exemptions asked table.',
                      UnitName, GlblErrorDlgBox);
      end;

  If AppraisalTable.Modified
    then
      try
        AppraisalTable.Post;
      except
        If not PostCancelled
          then SystemSupport(002, AppraisalTable, 'Error posting to appraisal table.',
                             UnitName, GlblErrorDlgBox);
      end;

  If CalenderTable.Modified
    then
      try
        CalenderTable.Post;
      except
        If not PostCancelled
          then SystemSupport(002, CalenderTable, 'Error posting to Calender table.',
                             UnitName, GlblErrorDlgBox);
      end;

end;  {SaveAllChanges}

{=============================================================}
Procedure TCertiorariSubform.SaveButtonClick(Sender: TObject);

begin
  If ((CertiorariTable.Modified or
       CertiorariExemptionsAskedTable.Modified or
       AppraisalTable.Modified or
       CalenderTable.Modified) and
      ((not GlblAskSave) or
       (MessageDlg('Do you want to save your certiorari changes?', mtConfirmation,
                   [mbYes, mbNo], 0) = idYes)))
    then SaveAllChanges;

end;  {SaveButtonClick}

{================================================================}
Procedure TCertiorariSubform.CancelAllChanges;

begin
  If CertiorariTable.Modified
    then CertiorariTable.Cancel;

  If AppraisalTable.Modified
    then AppraisalTable.Cancel;

  If CalenderTable.Modified
    then CalenderTable.Cancel;

  If CertiorariExemptionsAskedTable.Modified
    then CertiorariExemptionsAskedTable.Cancel;

end;  {CancelAllChanges}

{================================================================}
Procedure TCertiorariSubform.CancelButtonClick(Sender: TObject);

begin
  If (MessageDlg('Do you want to cancel your changes?', mtConfirmation,
                 [mbYes, mbNo], 0) = idYes)
    then CancelAllChanges;

end;  {CancelButtonClick}

{======================================================}
Procedure PrintItem(Sender : TObject;
                    HeaderItem : String;
                    DescriptionItem : String;
                    LineFeed : Boolean);

begin
  with Sender as TBaseReport do
    begin
      Bold := True;
      Print(#9 + HeaderItem);
      Bold := False;
      Print(#9 + DescriptionItem);

      If LineFeed
        then Println('');

    end;  {with Sender as TBaseObject do}

end;  {PrintItem}

{======================================================}
Procedure TCertiorariSubform.ReportPrint(Sender: TObject);

var
  AssessmentYearControlTable : TTable;
  TempStr, SwisCode : String;
  NAddrArray : NameAddrArray;
  I, LinesPrinted : Integer;
  Done, FirstTimeThrough : Boolean;
  DBMemoBuf: TDBMemoBuf;

begin
  with Sender as TBaseReport, CertiorariTable do
    begin
      SetFont('Times New Roman',12);
      Println('');
      Println('');
      ClearTabs;
      Bold := True;
      SetTab(0.5, pjCenter, 8.0, 0, BOXLINENone, 0);   {SBL}
      Println(#9 + 'CERTIORARI INFORMATION SHEET');
      Bold := False;
      SetFont('Times New Roman',10);
      Println('');

      ClearTabs;
      SetTab(0.3, pjLeft, 0.7, 0, BOXLINENone, 0);   {SBL}
      SetTab(1.1, pjLeft, 2.0, 0, BOXLINENone, 0);   {Name}
      SetTab(4.0, pjLeft, 0.5, 0, BOXLINENone, 0);   {Name}
      SetTab(4.6, pjLeft, 2.0, 0, BOXLINENone, 0);   {Name}

      PrintItem(Sender, 'Parcel ID:', ConvertSwisSBLToDashDotNoSwis(FieldByName('SwisSBLKey').Text), False);
      PrintItem(Sender, 'Name:', FieldByName('CurrentName1').Text, True);

      If GlblLocateByOldParcelID
        then
          begin
            AssessmentYearControlTable := FindTableInDataModuleForProcessingType(DataModuleAssessmentYearControlTableName,
                                                                                 GlblProcessingType);
            PrintItem(Sender, 'Old ID: ',
                      ConvertSwisSBLToOldDashDotNoSwis(FieldByName('OldParcelID').Text,
                                                       AssessmentYearControlTable),
                      False);
          end
        else Print(#9 + #9);

      TempStr := GetFieldFromTable('zpropclstbl', 'MainCode', 'Description',
                                   'ByMainCode', FieldByName('PropertyClassCode').Text,
                                   False, GlblProcessingType);
      PrintItem(Sender, 'Class: ',
                FieldByName('PropertyClassCode').Text +
                ' (' + TempStr + ')', True);

      ClearTabs;
      SetTab(0.3, pjLeft, 0.7, 0, BOXLINENone, 0);   {Index #}
      SetTab(1.1, pjLeft, 0.6, 0, BOXLINENone, 0);   {Index #}
      SetTab(2.0, pjLeft, 0.6, 0, BOXLINENone, 0);   {Year}
      SetTab(2.7, pjLeft, 1.0, 0, BOXLINENone, 0);   {Year}
      SetTab(4.0, pjLeft, 0.5, 0, BOXLINENone, 0);   {Name}
      SetTab(4.6, pjLeft, 2.0, 0, BOXLINENone, 0);   {Name}

      PrintItem(Sender, 'Index #:', FieldByName('CertiorariNumber').Text, False);
      PrintItem(Sender, 'Year:', FieldByName('TaxRollYr').Text, False);
      TempStr := GetFieldFromTable(DataModuleSchoolCodeTableName,
                                   'SchoolCode', 'SchoolName',
                                   'BySchoolCode', FieldByName('SchoolCode').Text,
                                   True, GlblProcessingType);
      PrintItem(Sender, 'School: ',
                FieldByName('SchoolCode').Text +
                ' (' + TempStr + ')', True);

      PrintItem(Sender, '# Parcls:', FieldByName('NumberOfParcels').Text, False);
      PrintItem(Sender, 'Atty Cd:', FieldByName('LawyerCode').Text, False);
      PrintItem(Sender, 'Eq Rate:',
                FormatFloat(DecimalEditDisplay,
                            FieldByName('CurrentEqRate').AsFloat), True);

      If (Deblank(FieldByName('AlternateID').Text) <> '')
        then PrintItem(Sender, 'Alternate ID:', FieldByName('AlternateID').Text, True);

      Println('');
      ClearTabs;
      SetTab(0.3, pjCenter, 2.2, 0, BOXLINENone, 0);   {Cert Info Box}
      SetTab(2.7, pjCenter, 5.0, 0, BOXLINENone, 0);   {Grievance Info Box}
      Bold := True;
      Println(#9 + 'Certiorari Info:' +
              #9 + 'Grievance Information:');
      Bold := False;

      ClearTabs;
      SetTab(0.3, pjLeft, 1.0, 2, BOXLINEAll, 0);   {Cert Info Box - Header}
      SetTab(1.3, pjRight, 1.2, 2, BOXLINEAll, 10);   {Cert Info Box - Data}
      SetTab(2.7, pjLeft, 0.7, 0, BoxLineNone, 0);   {Grievance Info Box - Header}
      SetTab(3.5, pjLeft, 4.0, 0, BoxLineNone, 0);   {Grievance Info Box - Data}

      Print(#9 + 'Orig Assmt:' +
            #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                             FieldByName('CurrentTotalValue').AsFloat));
      PrintItem(Sender, 'Name:', FieldByName('CurrentName1').Text, True);

      Print(#9 + 'Cert Claim:' +
            #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                             FieldByName('PetitTotalValue').AsFloat));
      PrintItem(Sender, 'Location:',
                GetLegalAddressFromTable(CertiorariTable), True);

      SwisCode := Copy(FieldByName('SwisSBLKey').Text, 1, 6);
      TempStr := GetFieldFromTable(DataModuleSwisCodeTableName,
                                   'SwisCode', 'MunicipalityName',
                                   'BySwisCode', SwisCode,
                                   True, GlblProcessingType);

      Print(#9 + 'Difference:' +
            #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                             (FieldByName('CurrentTotalValue').AsFloat -
                              FieldByName('PetitTotalValue').AsFloat)));
      PrintItem(Sender, 'Swis:',
                SwisCode + ' (' + TempStr + ')', True);

      ClearTabs;
      SetTab(0.3, pjLeft, 1.0, 2, BOXLINEAll, 0);   {Cert Info Box - Header}
      SetTab(1.3, pjRight, 1.2, 2, BOXLINEAll, 25);   {Cert Info Box - Data}
      SetTab(2.8, pjCenter, 1.2, 2, BoxLineNoBottom, 0);   {Grievance Info Box}
      SetTab(4.0, pjCenter, 1.2, 2, BoxLineNoBottom, 0);   {Grievance Info Box}
      SetTab(5.2, pjCenter, 1.2, 2, BoxLineNoBottom, 0);   {Grievance Info Box}
      SetTab(6.4, pjCenter, 1.2, 2, BoxLineNoBottom, 0);   {Grievance Info Box}

      Println(#9 + 'Final Asmt:' +
              #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                               FieldByName('GrantedTotalValue').AsFloat) +
              #9 + 'Prior Year' +
              #9 + 'Current Year' +
              #9 + 'Grievance' +
              #9 + 'Current Year');

      ClearTabs;
      SetTab(2.8, pjCenter, 1.2, 2, BoxLineNoTop, 0);   {Grievance Info Box}
      SetTab(4.0, pjCenter, 1.2, 2, BoxLineNoTop, 0);   {Grievance Info Box}
      SetTab(5.2, pjCenter, 1.2, 2, BoxLineNoTop, 0);   {Grievance Info Box}
      SetTab(6.4, pjCenter, 1.2, 2, BoxLineNoTop, 0);   {Grievance Info Box}

      Println(#9 + 'Final' +
              #9 + 'Tent' +
              #9 + 'Claim' +
              #9 + 'Final');

      ClearTabs;
      SetTab(2.8, pjRight, 1.2, 2, BoxLineNoTop, 15);   {Grievance Info Box}
      SetTab(4.0, pjRight, 1.2, 2, BoxLineNoTop, 15);   {Grievance Info Box}
      SetTab(5.2, pjRight, 1.2, 2, BoxLineNoTop, 15);   {Grievance Info Box}
      SetTab(6.4, pjRight, 1.2, 2, BoxLineNoTop, 15);   {Grievance Info Box}

      Println(#9 + FormatFloat(CurrencyDisplayNoDollarSign,
                               FieldByName('PriorTotalValue').AsFloat) +
              #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                               FieldByName('CurrentTentativeValue').AsFloat) +
              #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                               FieldByName('PetitGrievanceValue').AsFloat) +
              #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                               FieldByName('CurrentTotalValue').AsFloat));

      Rectangle(2.65, 1.82, 7.65, 2.92);
      Println('');
      Println('');

      Bold := True;
      ClearTabs;
      SetTab(0.3, pjCenter, 7.3, 0, BOXLINENone, 0);   {SBL}
      Println(#9 + 'Attorney Information');

      ClearTabs;
      SetTab(0.3, pjLeft, 0.7, 0, BOXLINENone, 0);   {SBL}
      SetTab(1.1, pjLeft, 2.0, 0, BOXLINENone, 0);   {Name}
      SetTab(4.0, pjLeft, 0.5, 0, BOXLINENone, 0);   {Name}
      SetTab(4.6, pjLeft, 2.0, 0, BOXLINENone, 0);   {Name}
      LinesPrinted := 3;

      FillInNameAddrArray(FieldByName('PetitName1').Text,
                          FieldByName('PetitName2').Text,
                          FieldByName('PetitAddress1').Text,
                          FieldByName('PetitAddress2').Text,
                          FieldByName('PetitStreet').Text,
                          FieldByName('PetitCity').Text,
                          FieldByName('PetitState').Text,
                          FieldByName('PetitZip').Text,
                          FieldByName('PetitZipPlus4').Text,
                          True, False, NAddrArray);

      PrintItem(Sender, 'Name/Addr:', NAddrArray[1], False);
      PrintItem(Sender, 'Attorney:', FieldByName('PetitAttorneyName').Text, True);

      PrintItem(Sender, '', NAddrArray[2], False);
      PrintItem(Sender, 'Phone:', FieldByName('PetitPhoneNumber').Text, True);

      PrintItem(Sender, '', NAddrArray[3], False);
      PrintItem(Sender, 'Fax:', FieldByName('PetitFaxNumber').Text, True);

      For I := 4 to 6 do
        If (Deblank(NAddrArray[I]) <> '')
          then
            begin
              PrintItem(Sender, '', NAddrArray[I], True);
              LinesPrinted := LinesPrinted + 1;
            end;  {If (Deblank(NAddrArray[I]) <> '')}

      Rectangle(0.25, 3.16, 7.65, (3.16 + (LinesPrinted * 0.16) + 0.30));

      ClearTabs;
      SetTab(0.3, pjLeft, 1.2, 0, BOXLINENone, 0);
      SetTab(1.6, pjLeft, 1.0, 0, BOXLINENone, 0);
      SetTab(5.4, pjCenter, 2.1, 0, BOXLINENone, 0);

      Println('');
      PrintItem(Sender, 'Notice of Petition:', FieldByName('NoticeOfPetition').Text, False);
      Bold := True;
      Println(#9 + 'Full Market Value Info');
      Bold := False;

      ClearTabs;
      SetTab(0.3, pjLeft, 1.2, 0, BOXLINENone, 0);
      SetTab(1.6, pjLeft, 1.0, 0, BOXLINENone, 0);
      SetTab(5.4, pjLeft, 1.2, 2, BOXLINEAll, 0);
      SetTab(6.6, pjRight, 0.9, 2, BOXLINEAll, 10);

      PrintItem(Sender, 'Note of Issue:', FieldByName('NoteOfIssue').Text, False);
      Println(#9 + 'Munic Full Value:' +
              #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                               FieldByName('CurrentFullMarketVal').AsFloat));

      PrintItem(Sender, 'Municipal Audit:', ''{FieldByName('MunicipalAudit').Text}, False);
      Println(#9 + 'Petn Full Value:' +
              #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                               FieldByName('PetitFullMarketVal').AsFloat));

      ClearTabs;
      SetTab(0.3, pjLeft, 1.2, 0, BOXLINENone, 0);
      SetTab(1.6, pjLeft, 1.0, 0, BOXLINENone, 0);
      SetTab(5.4, pjLeft, 1.2, 2, BOXLINEAll, 0);
      SetTab(6.6, pjRight, 0.9, 2, BOXLINEAll, 25);

      TempStr := '';
      CertiorariSalesTable.First;

      If not CertiorariSalesTable.EOF
        then
          with CertiorariSalesTable do
            TempStr := FormatFloat(CurrencyDisplayNoDollarSign,
                                   FieldByName('SalePrice').AsFloat) +
                       ' (' + FieldByName('SaleDate').Text + ')';

      PrintItem(Sender, 'Most Recent Sale:', TempStr, False);
      Println(#9 + 'Final Full Value:' +
              #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                               FieldByName('GrantedFullMarketVal').AsFloat));

      ClearTabs;
      SetTab(0.3, pjCenter, 7.3, 0, BOXLINENone, 0);
      Bold := True;
      Println('');
      Println(#9 + 'Appraisal Information');
      Bold := False;

      ClearTabs;
      SetTab(0.3, pjCenter, 1.0, 2, BOXLINEAll, 10);  {Appraisal type}
      SetTab(1.3, pjCenter, 1.0, 2, BOXLINEAll, 10);  {Appraiser}
      SetTab(2.3, pjCenter, 1.0, 2, BOXLINEAll, 10);  {Date}
      SetTab(3.3, pjCenter, 1.0, 2, BOXLINEAll, 10);  {Appraisal}
      SetTab(4.3, pjCenter, 3.3, 2, BOXLINEAll, 10);  {Notes}

      Println(#9 + 'Type' +
              #9 + 'Appraiser' +
              #9 + 'Date' +
              #9 + 'Appraisal' +
              #9 + 'Notes');

      ClearTabs;
      SetTab(0.3, pjLeft, 1.0, 2, BOXLINEAll, 0);  {Appraisal type}
      SetTab(1.3, pjLeft, 1.0, 2, BOXLINEAll, 0);  {Appraiser}
      SetTab(2.3, pjLeft, 1.0, 2, BOXLINEAll, 0);  {Date}
      SetTab(3.3, pjRight, 1.0, 2, BOXLINEAll, 0);  {Appraisal}
      SetTab(4.3, pjLeft, 3.3, 2, BOXLINEAll, 0);  {Notes}

      AppraisalTable.First;

      If AppraisalTable.EOF
        then Println(#9 + 'None.' +
                     #9 + '' +
                     #9 + '' +
                     #9 + '' +
                     #9 + '')
        else
          begin
            Done := False;
            FirstTimeThrough := True;

            repeat
              If FirstTimeThrough
                then FirstTimeThrough := False
                else AppraisalTable.Next;

              If AppraisalTable.EOF
                then Done := True;

                {FXX01152003-2: Make sure that '(MEMO)' does not appear in the notes field.}

              If not Done
                then
                  begin
                    with AppraisalTable do
                      Print(#9 + FieldByName('AppraisalType').Text +
                            #9 + FieldByName('Appraiser').Text +
                            #9 + FieldByName('DateAuthorized').Text +
                            #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                                             FieldByName('Appraisal').AsFloat));

                    DBMemoBuf := TDBMemoBuf.Create;
                    DBMemoBuf.Field := TMemoField(AppraisalTable.FieldByName('Notes'));

                    DBMemoBuf.PrintStart := 4.3;
                    DBMemoBuf.PrintEnd := 7.6;

                    PrintMemo(DBMemoBuf, 0, False);
                    DBMemoBuf.Free;

                  end;  {If not Done}

            until Done;

          end;  {If AppraisalTable.EOF}

      ClearTabs;
      SetTab(0.3, pjCenter, 7.3, 0, BOXLINENone, 0);
      Bold := True;
      Println('');
      Println(#9 + 'Trial \ Conference Information');
      Bold := False;

      ClearTabs;
      SetTab(0.3, pjCenter, 0.4, 2, BOXLINEAll, 10);  {Calender type}
      SetTab(0.7, pjCenter, 1.0, 2, BOXLINEAll, 10);  {Location}
      SetTab(1.7, pjCenter, 1.0, 2, BOXLINEAll, 10);  {Date}
      SetTab(2.7, pjCenter, 1.0, 2, BOXLINEAll, 10);  {Judge}
      SetTab(3.7, pjCenter, 3.9, 2, BOXLINEAll, 10);  {Notes}

      Println(#9 + 'Type' +
              #9 + 'Location' +
              #9 + 'Date' +
              #9 + 'Judge' +
              #9 + 'Notes');

      ClearTabs;
      SetTab(0.3, pjLeft, 0.4, 2, BOXLINEAll, 0);  {Calender type}
      SetTab(0.7, pjLeft, 1.0, 2, BOXLINEAll, 0);  {Location}
      SetTab(1.7, pjLeft, 1.0, 2, BOXLINEAll, 0);  {Date}
      SetTab(2.7, pjRight, 1.0, 2, BOXLINEAll, 0);  {Judge}
      SetTab(3.7, pjLeft, 3.9, 2, BOXLINEAll, 0);  {Notes}

      CalenderTable.First;

      If CalenderTable.EOF
        then Println(#9 + 'None.' +
                     #9 + '' +
                     #9 + '' +
                     #9 + '' +
                     #9 + '')
        else
          begin
            Done := False;
            FirstTimeThrough := True;

            repeat
              If FirstTimeThrough
                then FirstTimeThrough := False
                else CalenderTable.Next;

              If CalenderTable.EOF
                then Done := True;

              If not Done
                then
                  begin
                      {FXX01152003-2: Make sure that '(MEMO)' does not appear in the notes field.}

                    with CalenderTable do
                      Print(#9 + FieldByName('MeetingType').Text +
                            #9 + FieldByName('Location').Text +
                            #9 + FieldByName('Date').Text +
                            #9 + FieldByName('JudgeCode').Text);

                    DBMemoBuf := TDBMemoBuf.Create;
                    DBMemoBuf.Field := TMemoField(CalenderTable.FieldByName('Notes'));

                    DBMemoBuf.PrintStart := 4.3;
                    DBMemoBuf.PrintEnd := 7.6;

                    PrintMemo(DBMemoBuf, 0, False);
                    DBMemoBuf.Free;

                  end;  {If not Done}

            until Done;

          end;  {If CalenderTable.EOF}

      Println('');
      ClearTabs;
      SetTab(0.3, pjLeft, 1.2, 0, BOXLINENone, 0);
      SetTab(2.0, pjLeft, 1.5, 0, BOXLINENone, 0);
      SetTab(4.0, pjLeft, 0.7, 2, BOXLINENone, 0);
      SetTab(4.8, pjLeft, 1.0, 2, BOXLINENone, 0);

      TempStr := '';
      If (FieldByName('Disposition').Text = 'DISC')
        then TempStr := FieldByName('DispositionDate').Text;
      PrintItem(Sender, 'Discontinued:', TempStr, True);

      If (FieldByName('Disposition').Text = 'DISC')
        then TempStr := ''
        else TempStr := FieldByName('DispositionDate').Text;

      PrintItem(Sender, 'Munic Settlement Approval:', TempStr, False);
      PrintItem(Sender, 'Resol Num:', FieldByName('ResolutionNumber').Text, True);

      If (TMemoField(FieldByName('PostTrialMemo')).IsNull)
        then TempStr := ''
        else TempStr := 'YES';

      PrintItem(Sender, 'Post-Trial Memo:', TempStr, False);
      PrintItem(Sender, 'Final Order:', FieldByName('FinalOrderDate').Text, True);

        {CHG11042003-2(2.07k): Add the ability to print the certiorari notes.}

      If PrintCertiorariNotes
        then
          begin
            Println('');
            CertiorariNotesTablePrinter.Execute(TBaseReport(Sender));

          end;  {If PrintCertiorariNotes}

    end;  {with Sender as TBaseReport do}

end;  {ReportPrint}

{======================================================}
Procedure TCertiorariSubform.PrintButtonClick(Sender: TObject);

{CHG08212002-2: Add a summary print.}

var
  NewFileName : String;
  Quit : Boolean;

begin
  SetPrintToScreenDefault(PrintDialog);

  If PrintDialog.Execute
    then
      begin
        AssignPrinterSettings(PrintDialog, ReportPrinter, ReportFiler, [ptLaser],
                              False, Quit);

          {CHG11042003-2(2.07k): Add the ability to print the certiorari notes.}

        PrintCertiorariNotes := False;
        If (GlblCanSeeCertNotes and
            (CertiorariNotesTable.RecordCount > 0))
          then PrintCertiorariNotes := (MessageDlg('Do you want to print the certiorari notes for this parcel?',
                                                   mtConfirmation, [mbYes, mbNo], 0) = idYes);

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

                  end
                else ReportPrinter.Execute;

            end;  {If not Quit}

        ResetPrinter(ReportPrinter);

      end;  {If PrintDialog.Execute}

end;  {PrintButtonClick}

{======================================================}
Procedure TCertiorariSubform.SettlementSheetButtonClick(Sender: TObject);

begin
  ExecuteSettlementSheetPrint(SwisSBLKey);
end;

{Document processing}

{=====================================================================}
Procedure TCertiorariSubform.SetScrollBars;

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
Procedure TCertiorariSubform.tb_CertiorariDocumentsAfterInsert(DataSet: TDataSet);

var
  _Selection : Selection;
  TempParcelTable, NYParcelTable : TTable;
  InsertNameAndAddress : Boolean;
  NAddrArray : NameAddrArray;
  I : Integer;

begin
  If not InitializingForm
    then
      begin
        NYParcelTable := FindTableInDataModuleForProcessingType(DataModuleParcelTableName,
                                                                NextYear);

        case DocumentTypeSelected of
          dtOpenScannedImage :
            begin
              If OpenScannedImageDialog.Execute
                then
                  begin
                    tb_CertiorariDocuments.FieldByName('DocumentLocation').AsString := OpenScannedImageDialog.FileName;
                    tb_CertiorariDocuments.FieldByName('DocumentType').AsInteger := dtScannedImage;
                    tb_CertiorariDocumentsAfterScroll(nil);
                  end
                else tb_CertiorariDocuments.Cancel;

            end;  {dtOpenScannedImage}

          dtOpenWordDocument :
            begin
              DocumentDialog.Filter := 'MS Word documents|*.doc|All Files|*.*';

              If DocumentDialog.Execute
                then
                  begin
                    tb_CertiorariDocuments.FieldByName('DocumentLocation').AsString := DocumentDialog.FileName;
                    tb_CertiorariDocuments.FieldByName('DocumentType').AsInteger := dtMSWord;
                    tb_CertiorariDocumentsAfterScroll(nil);
                  end
                else tb_CertiorariDocuments.Cancel;

            end;  {dtOpenWordDocument}

          dtCreateWordDocument :
            try
              tb_CertiorariDocuments.FieldByName('DocumentType').AsInteger := dtMSWord;

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
                          then
                            begin
                              TempParcelTable := NYParcelTable;

                              GetNameAddress(TempParcelTable, NAddrArray);

                              For I := 1 to 6 do
                                If (Deblank(NAddrArray[I]) <> '')
                                  then
                                    begin
                                      _Selection.TypeText(NAddrArray[I]);
                                      _Selection.TypeParagraph;
                                    end;

                            end;  {If _Locate(NYParcelTable, [GetTaxRlYr, SwisSBLKey], '', [loParseSwisSBLKey])}

                      end;  {InsertNameAndAddress}

                  DocumentActive := True;
                  CurrentDocumentName := '';
                  GlblApplicationIsActive := False;
                  OLEItemNameTimer.Enabled := True;

                end;  {with WordApplication do}

            except
              MessageDlg('Sorry, there was an problem linking with Word.' + #13 +
                         'Please try again.', mtError, [mbOK], 0);
              tb_CertiorariDocuments.Cancel;
            end;  {dtCreateWordDocument}

          dtOpenExcelSpreadsheet :
            begin
              DocumentDialog.Filter := 'Excel spreadsheets|*.xls|All Files|*.*';

              If DocumentDialog.Execute
                then
                  begin
                    tb_CertiorariDocuments.FieldByName('DocumentLocation').AsString := DocumentDialog.FileName;
                    tb_CertiorariDocuments.FieldByName('DocumentType').AsInteger := dtExcel;
                    tb_CertiorariDocumentsAfterScroll(nil);
                  end
                else tb_CertiorariDocuments.Cancel;

            end;  {dtOpenExcelSpreadsheet}

          dtCreateExcelSpreadsheet :
            try
              tb_CertiorariDocuments.FieldByName('DocumentType').AsInteger := dtExcel;

              CreateExcelDocument(ExcelApplication, lcID);
              DocumentActive := True;
              CurrentDocumentName := '';
              GlblApplicationIsActive := False;
              OLEItemNameTimer.Enabled := True;

            except
              MessageDlg('Sorry, there was an problem linking with Excel.' + #13 +
                         'Please try again.', mtError, [mbOK], 0);
              tb_CertiorariDocuments.Cancel;
            end;  {dtCreateExcelSpreadsheet}

          dtOpenPDFDocument :
            If OpenPDFDialog.Execute
              then
                begin
                  tb_CertiorariDocuments.FieldByName('DocumentLocation').AsString := OpenPDFDialog.FileName;
                  tb_CertiorariDocuments.FieldByName('DocumentType').AsInteger := dtAdobePDF;
                    tb_CertiorariDocumentsAfterScroll(nil);
                end
              else tb_CertiorariDocuments.Cancel;

        end;  {case DocumentTypeSelected of}

      end;  {If not FormIsInitializing}

end;  {tb_CertiorariDocumentsAfterInsert}

{======================================================}
Procedure TCertiorariSubform.tb_CertiorariDocumentsNewRecord(DataSet: TDataSet);

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
              _SetRange(tb_CertiorariDocumentsLookup,
                        [CertiorariYear, SwisSBLKey, IntToStr(CertiorariNumber), '0'],
                        [CertiorariYear, SwisSBLKey, IntToStr(CertiorariNumber), '99999'], '', []);

              tb_CertiorariDocumentsLookup.First;

              If tb_CertiorariDocumentsLookup.EOF
                then NextDocumentNumber := 1
                else
                  begin
                    tb_CertiorariDocumentsLookup.Last;

                    NextDocumentNumber := tb_CertiorariDocumentsLookup.FieldByName('DocumentNumber').AsInteger + 1;

                  end;  {If tb_CertiorariDocumentsLookup.EOF}

              tb_CertiorariDocuments.FieldByName('DocumentNumber').AsInteger := NextDocumentNumber;
              tb_CertiorariDocuments.FieldByName('Date').AsDateTime := Date;
              tb_CertiorariDocuments.FieldByName('SwisSBLKey').AsString := SwisSBLKey;
              tb_CertiorariDocuments.FieldByName('TaxRollYr').AsString := CertiorariYear;
              tb_CertiorariDocuments.FieldByName('CertiorariNumber').AsInteger := CertiorariNumber;

              DocumentTypeSelected := DocumentTypeDialogForm.DocumentTypeSelected;

            end;  {If (DocumentTypeDialogForm.ModalResult = idOK)}

      finally
        DocumentTypeDialogForm.Free;
      end;

end;  {tb_CertiorariDocumentsNewRecord}

{======================================================}
Procedure TCertiorariSubform.tb_CertiorariDocumentsBeforePost(DataSet: TDataSet);

var
  ReturnCode : Integer;

begin
  If ((not InitializingForm) and
      (tb_CertiorariDocuments.State = dsInsert))
    then
      begin
          {If they are linked to an OLE server, make sure the file name
           is filled in.}

        with tb_CertiorariDocuments do
          case FieldByName('DocumentType').AsInteger of
            dtMSWord :
              If DocumentActive
                then WordDocumentClose(DataSet);

          end;  {case FieldByName('DocumentType').AsInteger of}

         {FXX05151998-3: Don't ask save on close form if don't want to see save.}

        If GlblAskSave
          then
            begin
                 {FXX11061997-2: Remove the "save before exiting" prompt because it
                                 is confusing. Use only "Do you want to save.}

              ReturnCode := MessageDlg('Do you wish to save your document changes?', mtConfirmation,
                                       [mbYes, mbNo, mbCancel], 0);

              case ReturnCode of
                idNo : If (tb_CertiorariDocuments.State = dsInsert)
                         then tb_CertiorariDocuments.Cancel
                         else RefreshNoPost(tb_CertiorariDocuments);

                idCancel : Abort;

              end;  {case ReturnCode of}

            end;  {If GlblAskSave}

      end;  {If ((not FormIsInitializing) and ...}

end;  {tb_CertiorariDocumentsBeforePost}

{======================================================}
Procedure TCertiorariSubform.tb_CertiorariDocumentsAfterPost(DataSet: TDataSet);

begin
  with tb_CertiorariDocuments do
    case FieldByName('DocumentType').AsInteger of
      dtMSWord :
        If DocumentActive
          then WordDocument.Close;

    end;  {case FieldByName('DocumentType').AsInteger of}

  DocumentActive := False;

  tb_CertiorariDocumentsAfterScroll(nil);

end;  {tb_CertiorariDocumentsAfterPost}

{======================================================}
Procedure TCertiorariSubform.tb_CertiorariDocumentsAfterDelete(DataSet: TDataSet);

begin
  with tb_CertiorariDocuments do
    begin
      DisableControls;
      CancelRange;

      _SetRange(tb_CertiorariDocuments,
                [CertiorariYear, SwisSBLKey, IntToStr(CertiorariNumber), '0'],
                [CertiorariYear, SwisSBLKey, IntToStr(CertiorariNumber), '99999'], '', []);

      tb_CertiorariDocuments.EnableControls;

   end;  {with tb_CertiorariDocuments do}

end;  {tb_CertiorariDocumentsAfterDelete}

{======================================================}
Procedure TCertiorariSubform.tb_CertiorariDocumentsAfterScroll(DataSet: TDataSet);

var
  FileName : String;

begin
  If not InitializingForm
    then
      begin
        Cursor := crHourglass;

        If _Compare(tb_CertiorariDocuments.FieldByName('DocumentLocation').AsString, coNotBlank)
          then
            case tb_CertiorariDocuments.FieldByName('DocumentType').AsInteger of
              0,
              dtScannedImage :
                begin
                  ntbk_Document.PageIndex := 0;

                  try
                    If FileExists(tb_CertiorariDocumentsDocumentLocation.Text)
                      then Image.ImageName := tb_CertiorariDocumentsDocumentLocation.Text
                      else Image.ImageName := ChangeLocationToLocalDrive(tb_CertiorariDocumentsDocumentLocation.Text);
                  except
                    MessageDlg('Unable to connect to scanned image ' +
                               tb_CertiorariDocumentsDocumentLocation.Text + '.',
                               mtError, [mbOK], 0);
                  end;

                  SetScrollBars;

                end;  {dtScannedImage}

              dtMSWord,
              dtExcel :
                begin
                  ntbk_Document.PageIndex := 1;

                  If FileExists(tb_CertiorariDocumentsDocumentLocation.Text)
                    then FileName := tb_CertiorariDocumentsDocumentLocation.Text
                    else FileName := ChangeLocationToLocalDrive(tb_CertiorariDocumentsDocumentLocation.Text);

                  OleContainer.CreateObjectFromFile(tb_CertiorariDocumentsDocumentLocation.Text, False);

                  If (tb_CertiorariDocuments.FieldByName('DocumentType').AsInteger = dtMSWord)
                    then OleWordDocumentTimer.Enabled := True;

                end;  {dtMSWord}

              dtAdobePdf : ntbk_Document.PageIndex := 2;

            end;  {case tb_CertiorariDocuments.FieldByName('DocumentType').AsInteger of}

        Cursor := crDefault;

      end;  {If ((not FormIsInitializing) and}

end;  {tb_CertiorariDocumentsAfterScroll}

{======================================================}
Procedure TCertiorariSubform.tb_CertiorariDocumentsCalcFields(DataSet: TDataSet);

begin
    {Display the document type.}

  If not InitializingForm
    then
      begin
        _Locate(tb_DocumentType, [tb_CertiorariDocuments.FieldByName('DocumentType').AsString], '', []);
        tb_CertiorariDocuments.FieldByName('DocumentTypeDescription').Text := tb_DocumentType.FieldByName('ApplicationName').AsString;

      end;  {If not InitializingForm}

end;  {tb_CertiorariDocumentsCalcFields}

{======================================================}
Procedure TCertiorariSubform.btn_NewDocumentClick(Sender: TObject);

begin
  tb_CertiorariDocuments.Append;
end;

{======================================================}
Procedure TCertiorariSubform.btn_SaveDocumentClick(Sender: TObject);

begin
  with tb_CertiorariDocuments do
    If (State in [dsEdit, dsInsert])
      then
        try
          Post;
        except
          SystemSupport(006, tb_CertiorariDocuments, 'Error posting document link.',
                        UnitName, GlblErrorDlgBox);
        end;

end;  {btn_SaveDocumentClick}

{======================================================}
Procedure TCertiorariSubform.btn_DeleteDocumentClick(Sender: TObject);

begin
    {CHG05042004-1(2.07l4): Option to delete the physical document.}

  If (MessageDlg('Are you sure you want to delete the link to this document?', mtConfirmation,
                 [mbYes, mbNo], 0) = idYes)
    then
      try
        If (MessageDlg('Do you want to delete the actual document also?', mtConfirmation, [mbYes, mbNo], 0) = idYes)
          then
            try
              DeleteFile(PChar(tb_CertiorariDocuments.FieldByName('DocumentLocation').AsString));
            except
              MessageDlg('There was an error deleting the document.' + #13 +
                         'Please remove it manually.', mtError, [mbOK], 0);
            end
          else MessageDlg('Please note that only the link was deleted, not the actual document.', mtWarning, [mbOK], 0);

        tb_CertiorariDocuments.Delete;

      except
        SystemSupport(005, tb_CertiorariDocuments, 'Error deleting document link.',
                      UnitName, GlblErrorDlgBox);
      end;

end;  {btn_DeleteDocumentClick}

{======================================================}
Procedure TCertiorariSubform.btn_FullScreenClick(Sender: TObject);

var
  FullScreenForm : TFullScreenViewForm;
  FileName : OLEVariant;

begin
  OleContainer.DestroyObject;
  FileName := tb_CertiorariDocuments.FieldByName('DocumentLocation').Text;
  FullScreenForm := nil;

  case tb_CertiorariDocuments.FieldByName('DocumentType').AsInteger of
    0,
    dtScannedImage :
      try
        FullScreenForm := TFullScreenViewForm.Create(self);
        FullScreenForm.Image.ImageName := tb_CertiorariDocuments.FieldByName('DocumentLocation').Text;
        FullScreenForm.Image.ImageLibPalette := False;
        FullScreenForm.ShowModal;
      finally
        FullScreenForm.Free;
      end;

    dtMSWord : OpenWordDocument(WordApplication, WordDocument, FileName);

    dtExcel : OpenExcelDocument(ExcelApplication, lcID, FileName);

    dtAdobePdf : ShellExecute(0, 'open',
                              PChar(tb_CertiorariDocuments.FieldByName('DocumentLocation').Text),
                              nil, nil, SW_NORMAL);

  end;  {case MainTable.FieldByName('DocumentType').AsInteger of}

end;  {btn_FullScreenClick}

{======================================================}
Procedure TCertiorariSubform.btn_PrintDocumentClick(Sender: TObject);

var
  FileName : OLEVariant;

begin
  FileName := tb_CertiorariDocuments.FieldByName('DocumentLocation').AsString;

    {FXX02181999-2: The image is printing very small.}

  case tb_CertiorariDocuments.FieldByName('DocumentType').AsInteger of
    0,
    dtScannedImage :
      If PrintDialog.Execute
        then
          begin
            Printer.Refresh;
            PrintImage(Image, Handle, 0, 0, Printer.PageWidth, Printer.PageHeight,
                       0, 999, True);

          end;  {If PrintDialog.Execute}

    dtMSWord : PrintWordDocument(WordApplication, WordDocument, FileName);

    dtExcel : PrintExcelDocument(ExcelApplication, lcID, FileName);

  end;  {case MainTable.FieldByName('DocumentType').AsInteger of}

end;  {btn_PrintDocumentClick}

{======================================================}
Procedure TCertiorariSubform.OleWordDocumentTimerTimer(Sender: TObject);

begin
  OleWordDocumentTimer.Enabled := False;
  OleContainer.SetFocus;
  OleContainer.DoVerb(ovShow);
end;

{======================================================}
Procedure TCertiorariSubform.OLEItemNameTimerTimer(Sender: TObject);

{Keep checking for the document name until they return to the application.}

begin
  If GlblApplicationIsActive
    then
      begin
        OLEItemNameTimer.Enabled := False;
        tb_CertiorariDocumentsAfterScroll(nil);
      end
    else
      begin
        If (tb_CertiorariDocuments.State in [dsEdit, dsInsert])
          then
            try
              case tb_CertiorariDocuments.FieldByName('DocumentType').AsInteger of
                dtMSWord : tb_CertiorariDocuments.FieldByName('DocumentLocation').Text := WordDocument.FullName;
                dtExcel : tb_CertiorariDocuments.FieldByName('DocumentLocation').Text := ExcelApplication.ActiveWorkbook.FullName[lcID];

              end;  {case tb_CertiorariDocuments.FieldByName('DocumentType').AsInteger of}
            except
            end;

      end;  {If GlblApplicationIsActive}

end;  {OLEItemNameTimerTimer}

{======================================================}
Procedure TCertiorariSubform.WordApplicationQuit(Sender: TObject);

begin
  DocumentActive := False;
end;

{======================================================}
Procedure TCertiorariSubform.WordDocumentClose(Sender: TObject);

begin
  If not WordDocument.Saved
    then WordDocument.Save;

  with tb_CertiorariDocuments do
    If (State in [dsEdit, dsInsert])
      then FieldByName('DocumentLocation').Text := WordDocument.FullName;

  DocumentActive := False;

end;  {WordDocumentClose}

{======================================================}
Procedure TCertiorariSubform.ExcelApplicationWorkbookBeforeClose(    Sender: TObject;
                                                                 var Wb, Cancel: OleVariant);

begin
  If not ExcelApplication.ActiveWorkbook.Saved[lcID]
    then ExcelApplication.ActiveWorkbook.Save(lcID);

  with tb_CertiorariDocuments do
    If (State in [dsEdit, dsInsert])
      then FieldByName('DocumentLocation').Text := ExcelApplication.ActiveWorkbook.FullName[lcID];

  DocumentActive := False;

end;  {ExcelApplicationWorkbookBeforeClose}

{======================================================}
Procedure TCertiorariSubform.FormCloseQuery(    Sender: TObject;
                                            var CanClose: Boolean);

var
  Decision : Integer;

begin
  CanClose := True;

  If (CertiorariTable.Modified or
      CertiorariExemptionsAskedTable.Modified or
      CalenderTable.Modified or
      AppraisalTable.Modified)
    then
      begin
        Decision := idOK;
        If GlblAskSave
          then Decision := MessageDlg('Do you want to save your certiorari changes?', mtConfirmation,
                                      [mbYes, mbNo, mbCancel], 0);

        If (Decision = idOK)
          then SaveAllChanges;

        If GlblAskSave
          then
            begin
              If (Decision = idNo)
                then CancelAllChanges;

              If (Decision = idCancel)
                then CanClose := False;

            end;  {If GlblAskSave}

      end;  {If (CertiorariTable.Modified or}

end;  {FormCloseQuery}

{======================================================}
Procedure TCertiorariSubform.CloseButtonClick(Sender: TObject);

begin
  Close;
end;

{======================================================}
Procedure TCertiorariSubform.FormClose(    Sender: TObject;
                                       var Action: TCloseAction);

begin
  FreeTList(FieldTraceInformationList, SizeOf(FieldTraceInformationRecord));
  CloseTablesForForm(Self);
end;  {FormClose}

end.
