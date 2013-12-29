unit PSmallClaimsSubFormUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, ComCtrls, wwdblook, wwriched, wwrichedspell,
  Grids, Wwdbigrd, Wwdbgrid, DBCtrls, Mask, Db, Wwdatsrc, DBTables, Wwtable,
  wwdbedit, Wwdotdot, Wwdbcomb, RPCanvas, RPrinter, RPDefine, RPBase,
  RPFiler, (*WordPerfect_TLB,*) ExtDlgs, Excel97, Word97, OleServer, OleCtnrs,
  TMultiP, ShellAPI;

type
  TSmallClaimsSubform = class(TForm)
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
    SmallClaimInfoTabSheet: TTabSheet;
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
    TimeOfSmallClaimInformationGroupBox: TGroupBox;
    SmallClaimNotesRichEdit: TwwDBRichEditMSWord;
    Label22: TLabel;
    SmallClaimsTable: TwwTable;
    SmallClaimsDataSource: TwwDataSource;
    TimeOfSmallClaimPageControl: TPageControl;
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
    SmallClaimGroupBox: TGroupBox;
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
    SmallClaimsExemptionTable: TwwTable;
    SmallClaimsExemptionsDataSource: TwwDataSource;
    SmallClaimsSalesTable: TwwTable;
    SmallClaimsSalesDataSource: TwwDataSource;
    SalesGrid: TwwDBGrid;
    SmallClaimsSpecialDistrictTable: TwwTable;
    SmallClaimsSpecialDistrictDataSource: TwwDataSource;
    SpecialDistrictDBGrid: TwwDBGrid;
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
    SmallClaimsSummaryGroupBox: TGroupBox;
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
    SmallClaimsExemptionsAskedTable: TTable;
    PropertyClassCodeTable: TTable;
    SmallClaimsExemptionsAskedDataSource: TwwDataSource;
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
    LawyerCodeTable: TTable;
    PrintButton: TBitBtn;
    ReportPrinter: TReportPrinter;
    ExemptionCodeTable: TwwTable;
    Label32: TLabel;
    EditGrievanceResults: TDBEdit;
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
    DocumentTabSheet: TTabSheet;
    MainPanel: TPanel;
    DocumentGrid: TwwDBGrid;
    FullScreenButton: TBitBtn;
    Notebook: TNotebook;
    ImagePanel: TPanel;
    ImageScrollBox: TScrollBox;
    Image: TPMultiImage;
    Panel3: TPanel;
    ScrollBox1: TScrollBox;
    OleContainer: TOleContainer;
    DeleteDocumentButton: TBitBtn;
    NewDocumentButton: TBitBtn;
    OleWordDocumentTimer: TTimer;
    WordDocument: TWordDocument;
    WordApplication: TWordApplication;
    ExcelApplication: TExcelApplication;
    OLEItemNameTimer: TTimer;
    OpenScannedImageDialog: TOpenPictureDialog;
    DocumentDialog: TOpenDialog;
    DocumentTypeTable: TwwTable;
    DocumentLookupTable: TTable;
    DocumentTable: TTable;
    DocumentDataSource: TDataSource;
    tbParcels: TTable;
    Label75: TLabel;
    Label101: TLabel;
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
    procedure SmallClaimsTableBeforeEdit(DataSet: TDataSet);
    procedure SmallClaimsTableBeforePost(DataSet: TDataSet);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure SmallClaimsTableAfterPost(DataSet: TDataSet);
    procedure LawyerLookupComboCloseUp(Sender: TObject; LookupTable,
      FillTable: TDataSet; modified: Boolean);
    procedure LawyerLookupComboDropDown(Sender: TObject);
    procedure PrintButtonClick(Sender: TObject);
    procedure ResultTypeLookupComboCloseUp(Sender: TObject; LookupTable,
      FillTable: TDataSet; modified: Boolean);
    procedure NewDocumentButtonClick(Sender: TObject);
    procedure DeleteDocumentButtonClick(Sender: TObject);
    procedure FullScreenButtonClick(Sender: TObject);
    procedure DocumentTableNewRecord(DataSet: TDataSet);
    procedure DocumentTableAfterInsert(DataSet: TDataSet);
    procedure DocumentTableAfterScroll(DataSet: TDataSet);
    procedure OleWordDocumentTimerTimer(Sender: TObject);
    procedure OLEItemNameTimerTimer(Sender: TObject);
    procedure WordApplicationQuit(Sender: TObject);
    procedure WordDocumentClose(Sender: TObject);
    procedure ExcelApplicationWorkbookBeforeClose(Sender: TObject; var Wb,
      Cancel: OleVariant);
    procedure SmallClaimsTableAfterEdit(DataSet: TDataSet);
  private
    { Private declarations }
  public
    { Public declarations }
    UnitName,
    SmallClaimsYear,
    SwisSBLKey : String;
    IndexNumber : LongInt;
    EditMode : Char;  {A = Add; M = Modify; V = View}
    SmallClaimsProcessingType : Integer;
    InitializingForm : Boolean;
    OldLawyerCode : String;
    OrigPetitionerTotalValue,
    OrigGrantedTotalValue : LongInt;

    DocumentActive : Boolean;
    DocumentTypeSelected : Integer;
    lcID : Integer;  {Reference ID number for created Excel worksheet.}
    CurrentDocumentName, OrigDisposition : String;
    FieldTraceInformationList : TList;

    Procedure FillInSummaryInfo;
    Procedure InitializeForm;
    Procedure SaveAllChanges;
    Procedure CancelAllChanges;
    Procedure SetScrollBars;

  end;

var
  SmallClaimsSubform: TSmallClaimsSubform;

implementation

{$R *.DFM}

uses GlblVars, WinUtils, PASUtils, PASTypes, Utilitys, GlblCnst,
     GrievanceUtilitys, DataAccessUnit, UtilOLE,
     GrievanceComplaintSubreasonDialogUnit, Preview, DocumentTypeDialog,
     Fullscrn, UtilBill, UtilExSD;

{================================================================}
Procedure PrintSmallClaimsRebateForm(tbSmallClaims : TTable;
                                     tbParcels : TTable;
                                     sSwisSBLKey : String;
                                     sTaxYear : String;
                                     sCountyTaxDatabaseName : String;
                                     sCollectionType : String;
                                     sCollectionNumber : String;
                                     sMunicipality : String;
                                     sBaseTaxRatePointer : String;
                                     sSCARFormTemplateFileName : String;
                                     bReprint : Boolean);

var
  flLetterMerge : TextFile;
  sLot, sSublot, sZipCode, sLegalZipCode, sLegalCity,
  sPrintKey, sMergeFileName, sFileExtension, sNewFileName,
  sHeaderFileName, sGeneralFileName, sExemptionFileName,
  sSpecialDistrictFileName, sSpecialFeeFileName, sLegalAddress,
  sSolidWasteDistrictName, sSewerDistrictName, sWaterDistrictName, sPriorTaxYear : String;
  fCountyTaxRate, fSolidWasteDistrictRate, fSewerDistrictRate, fWaterDistrictRate : Double;
  bQuit : Boolean;
  tbSpecialDistrictCodes, tbHeaderTax,
  tbGeneralTax, tbBillExemptions,
  tbBillSpecialDistricts, tbSpecialFees,
  tbBillGeneralRates, tbBillSpecialDistrictRates,
  tbSmallClaimsExemptions : TTable;
  NAddrArray : NameAddrArray;
  iRevisedLandValue, iRevisedAssessedValue,
  iRevisedExemptionValue, iRevisedTaxableValue,
  iTaxSystemAssessedValue, iTaxSystemExemptionValue, iTaxSystemTaxableValue : LongInt;
  RevisedExemptionAmounts : ExemptionTotalsArrayType;
  iExtensionPos, iIndexNumber : Integer;

begin
  {* Before printing determine pay status and that there is a reduction.  Ask them to print?
     Also, print button to enable reprint.}

    {Check tax system status and get tax system AV.}

  If (((not glblUsesSQLTax) and
       CheckTaxSystemStatus('999999', Copy(sSwisSBLKey, 1, 6), Copy(sSwisSBLKey, 7, 20),
                            tsCounty, sCountyTaxDatabaseName, sBaseTaxRatePointer,
                            iTaxSystemAssessedValue, iTaxSystemExemptionValue, iTaxSystemTaxableValue)) or
      (glblUsesSQLTax and
       _Compare(sCountyTaxDatabaseName, coBlank) or
       CheckTaxSystemStatus_SQL('999999', Copy(sSwisSBLKey, 1, 6), Copy(sSwisSBLKey, 7, 20),
                                tsCounty, sCountyTaxDatabaseName, sBaseTaxRatePointer,
                                iTaxSystemAssessedValue, iTaxSystemExemptionValue, iTaxSystemTaxableValue)))
  then
    begin
      iIndexNumber := tbSmallClaims.FieldByName('IndexNumber').AsInteger;

        {Create and open tables.}

      tbSpecialDistrictCodes := TTable.Create(nil);
      tbHeaderTax := TTable.Create(nil);
      tbGeneralTax := TTable.Create(nil);
      tbBillExemptions := TTable.Create(nil);
      tbBillSpecialDistricts := TTable.Create(nil);
      tbSpecialFees := TTable.Create(nil);
      tbBillGeneralRates := TTable.Create(nil);
      tbBillSpecialDistrictRates := TTable.Create(nil);
      tbSmallClaimsExemptions := TTable.Create(nil);

      _OpenTable(tbSpecialDistrictCodes, SdistCodeTableName, '', 'BYSDISTCODE', ThisYear, []);
      _OpenTable(tbHeaderTax, 'BCollBLHdrTax', '', 'BYSCHOOLCODEKEY_SWISCODE_SBL', NoProcessingType, []);
      _OpenTable(tbGeneralTax, 'BCollBLGeneralTax', '', 'BYSWISSBLKEY_HC_PRINTORDER', NoProcessingType, []);
      _OpenTable(tbBillExemptions, 'BCollBLExemptTax', '', 'BYSWISSBLKEY_EXCODE_HC', NoProcessingType, []);
      _OpenTable(tbBillSpecialDistricts, 'bcollblsdisttax', '', 'BYSWISSBL_SD_HC_EXT', NoProcessingType, []);
      _OpenTable(tbSpecialFees, 'BCollBLSPFeeTax', '', 'BYSWISSBLKEY_PRINTORDER', NoProcessingType, []);
      _OpenTable(tbBillGeneralRates, 'BCollGeneralRateFile', '', 'BYYEAR_COLLTYPE_NUM_ORDER', NoProcessingType, []);
      _OpenTable(tbBillSpecialDistrictRates, 'BCollSdistRateFile', '', 'BYYEAR_TYPE_NUM_SD_EX_CM', NoProcessingType, []);
      _OpenTable(tbSmallClaimsExemptions, 'gscexemptionrec', '', 'BYYEAR_SWISSBL_INDEXNUM_EXCODE', NoProcessingType, []);

      with tbSmallClaims do
        FillInNameAddrArray(FieldByName('CurrentName1').Text,
                            FieldByName('CurrentName2').Text,
                            FieldByName('CurrentAddress1').Text,
                            FieldByName('CurrentAddress2').Text,
                            FieldByName('CurrentStreet').Text,
                            FieldByName('CurrentCity').Text,
                            FieldByName('CurrentState').Text,
                            FieldByName('CurrentZip').Text,
                            FieldByName('CurrentZipPlus4').Text,
                            True, False, nAddrArray);

      sLegalZipCode := '';
      sLegalCity := '';

      If _Locate(tbParcels, [glblThisYear, sSwisSBLKey], '', [loParseSwisSBLKey])
      then
      begin
        sLegalZipCode := tbParcels.FieldByName('LegalZip').AsString;
        sLegalCity := tbParcels.FieldByName('LegalCity').AsString;
      end;

      sZipCode := tbSmallClaims.FieldByName('PetitZip').AsString;

      sPrintKey := ConvertSBLOnlyToDashDot(Copy(sSwisSBLKey, 7, 20));
      sLegalAddress := GetLegalAddressFromTable(tbSmallClaims);
      //sPriorTaxYear := IntToStr(StrToInt(sTaxYear) - 1);
      sPriorTaxYear := glblThisYear;

      GetBillingFileNames(sPriorTaxYear, sCollectionType, sCollectionNumber,
                          sHeaderFileName, sGeneralFileName, sExemptionFileName,
                          sSpecialDistrictFileName, sSpecialFeeFileName);

      OpenBillingFiles(sHeaderFileName, sGeneralFileName, sExemptionFileName,
                       sSpecialDistrictFileName, sSpecialFeeFileName,
                       tbHeaderTax, tbGeneralTax, tbBillExemptions,
                       tbBillSpecialDistricts, tbSpecialFees, bQuit);

      If _Compare(sCountyTaxDatabaseName, coBlank)
      then
        begin
          _Locate(tbHeaderTax, ['999999', Copy(sSwisSBLKey, 1, 6), Copy(sSwisSBLKey, 7, 20)], '', []);

          iTaxSystemAssessedValue := tbHeaderTax.FieldByName('HstdTotalVal').AsInteger +
                                     tbHeaderTax.FieldByName('NonHstdTotalVal').AsInteger;
          _SetRange(tbBillExemptions, [sSwisSBLKey, '', ''], [sSwisSBLKey, '99999', ''], '', []);
          iTaxSystemExemptionValue := Trunc(SumTableColumn(tbBillExemptions, 'CountyAmount'));
          iTaxSystemTaxableValue := iTaxSystemAssessedValue - iTaxSystemExemptionValue;
        end;  {If _Compare(sCountyTaxDatabaseName, coBlank)}

        (* Determine new exemption and taxable value *)

      iRevisedAssessedValue := tbSmallClaims.FieldByName('GrantedTotalValue').AsInteger;
      iRevisedLandValue := tbSmallClaims.FieldByName('GrantedLandValue').AsInteger;
      If _Compare(iRevisedLandValue, 0, coEqual)
        then iRevisedLandValue := tbSmallClaims.FieldByName('CurrentLandValue').AsInteger;

      _SetRange(tbSmallClaimsExemptions, [sTaxYear, sSwisSBLKey, iIndexNumber, ''],
                [sTaxYear, sSwisSBLKey, iIndexNumber, '99999'], '', []);
      RevisedExemptionAmounts := ProjectExemptions(tbSmallClaimsExemptions, sTaxYear, sSwisSBLKey,
                                                   iRevisedLandValue, iRevisedAssessedValue, NoProcessingType);
      iRevisedExemptionValue := Trunc(RevisedExemptionAmounts[ExCounty]);

      iRevisedTaxableValue := iRevisedAssessedValue - iRevisedExemptionValue;

        (* Get district rates and names from corresponding billing district. *)

      fCountyTaxRate := GetBaseTaxRate(tbBillGeneralRates,
                                       sTaxYear, sCollectionType,
                                       sCollectionNumber, CountyTaxType);

      GetDistrictNameAndRate(tbBillSpecialDistricts, tbBillSpecialDistrictRates,
                             tbSpecialDistrictCodes, sSwisSBLKey,
                             sTaxYear, sCollectionType, sCollectionNumber,
                             sdtSolidWaste, sSolidWasteDistrictName, fSolidWasteDistrictRate);

      GetDistrictNameAndRate(tbBillSpecialDistricts, tbBillSpecialDistrictRates,
                             tbSpecialDistrictCodes, sSwisSBLKey,
                             sTaxYear, sCollectionType, sCollectionNumber,
                             sdtSewer, sSewerDistrictName, fSewerDistrictRate);

      GetDistrictNameAndRate(tbBillSpecialDistricts, tbBillSpecialDistrictRates,
                             tbSpecialDistrictCodes, sSwisSBLKey,
                             sTaxYear, sCollectionType, sCollectionNumber,
                             sdtWater, sWaterDistrictName, fWaterDistrictRate);

        {Create and fill the merge file.}

      sMergeFileName := GetPrintFileName('SCARForm', True);
      AssignFile(flLetterMerge, sMergeFileName);
      Rewrite(flLetterMerge);

      WritelnCommaDelimitedLine(flLetterMerge,
                                ['IndexNumber',
                                 'Municipality',
                                 'Name1',
                                 'Name2',
                                 'Address1',
                                 'Address2',
                                 'Address3',
                                 'Address4',
                                 'ZipCode',
                                 'LegalZipCode',
                                 'LegalCity',
                                 'LegalAddress',
                                 'PrintKey',
                                 'Section',
                                 'Block',
                                 'Lot',
                                 'PriorAssessedValue',
                                 'PriorExemption',
                                 'PriorTaxableValue',
                                 'RevisedAssessedValue',
                                 'RevisedExemption',
                                 'RevisedTaxableValue',
                                 'TaxYear',
                                 'CountyTaxRate',
                                 'SolidWasteRate',
                                 'SewerDistrictRate',
                                 'WaterDistrictRate',
                                 'SewerDistrictName',
                                 'WaterDistrictName']);

      sLot := DezeroOnLeft(Copy(sSwisSBLKey, 13, 4));
      sSubLot := Copy(sSwisSBLKey, 17, 3);
      If _Compare(sSublot, coNotBlank)
      then sLot := sLot + '.' + DezeroOnLeft(sSubLot);

      WritelnCommaDelimitedLine(flLetterMerge,
                                [iIndexNumber,
                                 GetMunicipalityName,
                                 NAddrArray[1],
                                 NAddrArray[2],
                                 NAddrArray[3],
                                 NAddrArray[4],
                                 NAddrArray[5],
                                 NAddrArray[6],
                                 sZipCode,
                                 sLegalZipCode,
                                 sLegalCity,
                                 sLegalAddress,
                                 sPrintKey,
                                 Copy(sSwisSBLKey, 7, 3),
                                 Copy(sSwisSBLKey, 10, 3),
                                 sLot,
                                 FormatFloat(CurrencyNormalDisplay_BlankZero, iTaxSystemAssessedValue),
                                 FormatFloat(CurrencyNormalDisplay_BlankZero, iTaxSystemExemptionValue),
                                 FormatFloat(CurrencyNormalDisplay_BlankZero, iTaxSystemTaxableValue),
                                 FormatFloat(CurrencyNormalDisplay_BlankZero, iRevisedAssessedValue),
                                 FormatFloat(CurrencyNormalDisplay_BlankZero, iRevisedExemptionValue),
                                 FormatFloat(CurrencyNormalDisplay_BlankZero, iRevisedTaxableValue),
                                 IncrementNumericString(sTaxYear, 1),
                                 FormatFloat(ExtendedDecimalDisplay_NA, fCountyTaxRate),
                                 FormatFloat(ExtendedDecimalDisplay_NA, fSolidWasteDistrictRate),
                                 FormatFloat(ExtendedDecimalDisplay_NA, fSewerDistrictRate),
                                 FormatFloat(ExtendedDecimalDisplay_NA, fWaterDistrictRate),
                                 sSewerDistrictName,
                                 sWaterDistrictName]);

      CloseFile(flLetterMerge);

        {Close and free tables.}

      tbSpecialDistrictCodes.Close;
      tbHeaderTax.Close;
      tbGeneralTax.Close;
      tbBillExemptions.Close;
      tbBillSpecialDistricts.Close;
      tbSpecialFees.Close;
      tbBillGeneralRates.Close;
      tbBillSpecialDistrictRates.Close;

      tbSpecialDistrictCodes.Free;
      tbHeaderTax.Free;
      tbGeneralTax.Free;
      tbBillExemptions.Free;
      tbBillSpecialDistricts.Free;
      tbSpecialFees.Free;
      tbBillGeneralRates.Free;
      tbBillSpecialDistrictRates.Free;

        {Do the merge.}

      SendTextFileToExcelSpreadsheet(sMergeFileName, False,
                                     True, ChangeFileExt(sMergeFileName, '.XLS'));

      sFileExtension := ExtractFileExt(sSCARFormTemplateFileName);
      sNewFileName := sSCARFormTemplateFileName;
      iExtensionPos := Pos(sFileExtension, sNewFileName);
      Delete(sNewFileName, iExtensionPos, 200);
      sNewFileName := sNewFileName + '_Template' + sFileExtension;

      CopyOneFile(sSCARFormTemplateFileName, sNewFileName);

      PerformWordMailMerge(sNewFileName, ChangeFileExt(sMergeFileName, '.XLS'));

    end  {If CheckTaxSystemStatus...}
  else MessageDlg('The ' + IncrementNumericString(sTaxYear, 1) + ' county taxes are not paid for this parcel.' + #13 +
                  'No refund letter will be printed.',
                  mtInformation, [mbOK], 0);  

end;  {PrintSmallClaimsRebateForm}

{================================================================}
Procedure TSmallClaimsSubform.FillInSummaryInfo;

var
  AVDifference, FullMktDifference : LongInt;
  NAddrArray : NameAddrArray;
  I : Integer;

begin
  with SmallClaimsTable do
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

    end;  {with SmallClaimsTable do}

end;  {FillInSummaryInfo}

{================================================================}
Procedure TSmallClaimsSubform.InitializeForm;

var
  _Found : Boolean;
  SwisCodeTable, AssessmentYearControlTable : TTable;

begin
    {FXX01262004-1(2.07l1): Make sure that the subwindows have the same state as the main form.}
(*  WindowState := Forms.Application.MainForm.WindowState; *)

  InitializingForm := True;
  UnitName := 'PSmallClaimsSubform';
  FieldTraceInformationList := TList.Create;
  OrigDisposition := '';

  If (EditMode = 'V')
    then
      begin
        SmallClaimsTable.ReadOnly := True;
        SmallClaimsExemptionsAskedTable.ReadOnly := True;
        AppraisalTable.ReadOnly := True;
        CalenderTable.ReadOnly := True;
        SaveButton.Enabled := False;
        CancelButton.Enabled := False;

      end;  {If (EditMode = 'V')}

  OpenTablesForForm(Self, SmallClaimsProcessingType);

  _Found := FindKeyOld(SmallClaimsTable, ['TaxRollYr', 'SwisSBLKey', 'IndexNumber'],
                       [SmallClaimsYear, SwisSBLKey, IntToStr(IndexNumber)]);

  If not _Found
    then SystemSupport(001, SmallClaimsTable,
                       'Error finding small claim ' + SmallClaimsYear + '\' +
                       SwisSBLKey + '\' +
                       IntToStr(IndexNumber),
                       UnitName, GlblErrorDlgBox);

  Caption := SmallClaimsYear + ' Index #' +
             SmallClaimsTable.FieldByName('IndexNumber').Text +
             ' for parcel ' + ConvertSwisSBLToDashDot(SwisSBLKey);

    {Set range on the small claims results table, the BOAR members, the
     small claims exemption table, and find the property class code.}

  SetRangeOld(SmallClaimsExemptionsAskedTable,
              ['SwisSBLKey', 'TaxRollYr', 'IndexNumber', 'ExemptionCode'],
              [SwisSBLKey, SmallClaimsYear, IntToStr(IndexNumber), '     '],
              [SwisSBLKey, SmallClaimsYear, IntToStr(IndexNumber), '99999']);

  SetRangeOld(SmallClaimsExemptionTable,
              ['SwisSBLKey', 'TaxRollYr', 'IndexNumber', 'ExemptionCode'],
              [SwisSBLKey, SmallClaimsYear, IntToStr(IndexNumber), '     '],
              [SwisSBLKey, SmallClaimsYear, IntToStr(IndexNumber), '99999']);

  SetRangeOld(SmallClaimsSalesTable,
              ['SwisSBLKey', 'IndexNumber', 'SaleNumber'],
              [SwisSBLKey, IntToStr(IndexNumber), '0'],
              [SwisSBLKey, IntToStr(IndexNumber), '99999']);

  SetRangeOld(SmallClaimsSpecialDistrictTable,
              ['SwisSBLKey', 'TaxRollYr', 'IndexNumber', 'SDistCode'],
              [SwisSBLKey, SmallClaimsYear, IntToStr(IndexNumber), '     '],
              [SwisSBLKey, SmallClaimsYear, IntToStr(IndexNumber), 'ZZZZZ']);

  SetRangeOld(AppraisalTable,
              ['SwisSBLKey', 'TaxRollYr', 'IndexNumber', 'DateAuthorized'],
              [SwisSBLKey, SmallClaimsYear, IntToStr(IndexNumber), '1/1/1950'],
              [SwisSBLKey, SmallClaimsYear, IntToStr(IndexNumber), '1/1/3000']);

  SetRangeOld(CalenderTable,
              ['SwisSBLKey', 'TaxRollYr', 'IndexNumber', 'Date'],
              [SwisSBLKey, SmallClaimsYear, IntToStr(IndexNumber), '1/1/1950'],
              [SwisSBLKey, SmallClaimsYear, IntToStr(IndexNumber), '1/1/3000']);

  _SetRange(DocumentTable, [SmallClaimsYear, SwisSBLKey, IndexNumber, 0],
            [SmallClaimsYear, SwisSBLKey, IndexNumber, 32000], '', []);
            
  FindKeyOld(PropertyClassCodeTable, ['MainCode'],
             [SmallClaimsTable.FieldByName('PropertyClassCode').Text]);

    {Now set display formats on numeric fields.}

  TFloatField(SmallClaimsTable.FieldByName('PriorLandValue')).DisplayFormat := CurrencyDisplayNoDollarSign;
  TFloatField(SmallClaimsTable.FieldByName('CurrentLandValue')).DisplayFormat := CurrencyDisplayNoDollarSign;
  TFloatField(SmallClaimsTable.FieldByName('PriorTotalValue')).DisplayFormat := CurrencyDisplayNoDollarSign;
  TFloatField(SmallClaimsTable.FieldByName('CurrentTotalValue')).DisplayFormat := CurrencyDisplayNoDollarSign;
  TFloatField(SmallClaimsTable.FieldByName('PriorFullMarketVal')).DisplayFormat := CurrencyDisplayNoDollarSign;
  TFloatField(SmallClaimsTable.FieldByName('CurrentFullMarketVal')).DisplayFormat := CurrencyDisplayNoDollarSign;
  TFloatField(SmallClaimsTable.FieldByName('ResidentialPercent')).DisplayFormat := NoDecimalDisplay_BlankZero;
  TFloatField(SmallClaimsTable.FieldByName('CurrentEqRate')).DisplayFormat := DecimalEditDisplay;
  TFloatField(SmallClaimsTable.FieldByName('CurrentUniformPercent')).DisplayFormat := DecimalEditDisplay;
  TFloatField(SmallClaimsTable.FieldByName('CurrentRAR')).DisplayFormat := DecimalEditDisplay_BlankZero;
  TDateField(SmallClaimsTable.FieldByName('DispositionDate')).EditMask := DateMask;
  TDateField(SmallClaimsTable.FieldByName('PostTrialMemo')).EditMask := DateMask;
  TDateField(SmallClaimsTable.FieldByName('NoticeOfPetition')).EditMask := DateMask;
  TDateField(SmallClaimsTable.FieldByName('NoteOfIssue')).EditMask := DateMask;
  TDateField(SmallClaimsTable.FieldByName('FinalOrderDate')).EditMask := DateMask;
  TFloatField(SmallClaimsTable.FieldByName('PetitLandValue')).DisplayFormat := CurrencyDisplayNoDollarSign;
  TFloatField(SmallClaimsTable.FieldByName('PetitTotalValue')).DisplayFormat := CurrencyDisplayNoDollarSign;
  TFloatField(SmallClaimsTable.FieldByName('PetitFullMarketVal')).DisplayFormat := CurrencyDisplayNoDollarSign;
  TFloatField(SmallClaimsTable.FieldByName('GrantedLandValue')).DisplayFormat := CurrencyDisplayNoDollarSign;
  TFloatField(SmallClaimsTable.FieldByName('GrantedTotalValue')).DisplayFormat := CurrencyDisplayNoDollarSign;
  TFloatField(SmallClaimsTable.FieldByName('GrantedFullMarketVal')).DisplayFormat := CurrencyDisplayNoDollarSign;
  TFloatField(SmallClaimsTable.FieldByName('GrantedEXAmount')).DisplayFormat := CurrencyDisplayNoDollarSign;
  TFloatField(SmallClaimsTable.FieldByName('GrantedEXPercent')).DisplayFormat := NoDecimalDisplay;

  TFloatField(SmallClaimsExemptionTable.FieldByName('Amount')).DisplayFormat := CurrencyDisplayNoDollarSign;
  TFloatField(SmallClaimsExemptionTable.FieldByName('Percent')).DisplayFormat := NoDecimalDisplay;
  TFloatField(SmallClaimsExemptionTable.FieldByName('OwnerPercent')).DisplayFormat := NoDecimalDisplay;

  TFloatField(SmallClaimsSpecialDistrictTable.FieldByName('PrimaryUnits')).DisplayFormat := DecimalEditDisplay_BlankZero;
  TFloatField(SmallClaimsSpecialDistrictTable.FieldByName('SecondaryUnits')).DisplayFormat := DecimalEditDisplay_BlankZero;
  TFloatField(SmallClaimsSpecialDistrictTable.FieldByName('SDPercentage')).DisplayFormat := DecimalEditDisplay_BlankZero;
  TFloatField(SmallClaimsSpecialDistrictTable.FieldByName('CalcAmount')).DisplayFormat := NoDecimalDisplay_BlankZero;

  TFloatField(SmallClaimsExemptionsAskedTable.FieldByName('Amount')).DisplayFormat := CurrencyDisplayNoDollarSign;
  TFloatField(SmallClaimsExemptionsAskedTable.FieldByName('Percent')).DisplayFormat := NoDecimalDisplay;

  TDateTimeField(AppraisalTable.FieldByName('DateAuthorized')).EditMask := DateMask;
  TDateTimeField(AppraisalTable.FieldByName('DateReceived')).EditMask := DateMask;
  TDateTimeField(AppraisalTable.FieldByName('DatePaid')).EditMask := DateMask;
  AppraisalTable.FieldByName('DateAuthorized').Required := True;
  TFloatField(AppraisalTable.FieldByName('AmountPaid')).DisplayFormat := DecimalEditDisplay;

  TDateTimeField(CalenderTable.FieldByName('Date')).EditMask := DateMask;
  TFloatField(CalenderTable.FieldByName('MunicipalProposal')).DisplayFormat := CurrencyDisplayNoDollarSign;
  TFloatField(CalenderTable.FieldByName('PetitionerProposal')).DisplayFormat := CurrencyDisplayNoDollarSign;
  CalenderTable.FieldByName('Date').Required := True;

(*  case SmallClaimsProcessingType of
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

  end;  {case SmallClaimsProcessingType of} *)

    {FXX08272003-2(2.07i): Fix up the current and prior value display labels.}

  (*SmallClaimsYear := SmallClaimsTable.FieldByName('TaxRollYr').Text; *)

  PriorValueLabel.Caption := 'Prior (' + (IntToStr(StrToInt(SmallClaimsYear) - 1)) + ')';
  CurrentValueLabel.Caption := 'Current (' + SmallClaimsYear + ')';

  with SmallClaimsTable do
    begin
      SwisCodeTable := FindTableInDataModuleForProcessingType(DataModuleSwisCodeTableName,
                                                              SmallClaimsProcessingType);

      AssessmentYearControlTable := FindTableInDataModuleForProcessingType(DataModuleAssessmentYearControlTableName,
                                                                           SmallClaimsProcessingType);

      FindKeyOld(SwisCodeTable, ['SwisCode'],
                 [Copy(SwisSBLKey, 1, 6)]);

      EditLocation.Text := GetLegalAddressFromTable(SmallClaimsTable);

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

      FillInSummaryInfo;

    end;  {with SmallClaimsTable do}

    {CHG03232004-2(2.08): The Supervisor can change time of grievance info.}

  If (GlblUserName = 'SUPERVISOR')
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

  PrintButton.Visible := glblPrintSmallClaimsRebateForms;

  InitializingForm := False;
  PageControl.ActivePage := SummaryTabSheet;
  SetFocusOnPageTimer.Enabled := True;

end;  {InitializeForm}

{================================================================}
Procedure TSmallClaimsSubform.PageControlChange(Sender: TObject);

begin
  SetFocusOnPageTimer.Enabled := True;
end;

{================================================================}
Procedure TSmallClaimsSubform.SetFocusOnPageTimerTimer(Sender: TObject);

begin
  SetFocusOnPageTimer.Enabled := False;

  case PageControl.ActivePage.PageIndex of
    1 : EditName.SetFocus;
    2 : If GlblGrievanceSeperateRepresentativeInfo
          then EditPetitionerName1.SetFocus
          else EditOldStylePetitName1.SetFocus;
    3 : EditNumberOfParcels.SetFocus;
    4 : AppraisalGrid.SetFocus;
    5 : CalenderGrid.SetFocus;
    6 : DocumentTableAfterScroll(nil);

  end;  {case PageControl.ActivePage.PageIndex of}

end;  {SetFocusOnPageTimerTimer}

{==========================================================}
Procedure TSmallClaimsSubform.FormKeyPress(Sender: TObject; var Key: Char);

begin
  If (Key = #13)
    then
      begin
        Perform(WM_NextDlgCtl, 0, 0);
        Key := #0;
      end;  {If (Key = #13)}

end;  {FormKeyPress}

{==========================================================}
Procedure TSmallClaimsSubform.SmallClaimsTableBeforeEdit(DataSet: TDataSet);

begin
  with SmallClaimsTable do
    begin
      OrigPetitionerTotalValue := FieldByName('PetitTotalValue').AsInteger;
      OrigGrantedTotalValue := FieldByName('GrantedTotalValue').AsInteger;
      OrigDisposition := FieldByName('Disposition').AsString;
    end;

end;  {SmallClaimsTableBeforeEdit}

{===================================================================}
Procedure TSmallClaimsSubform.SmallClaimsTableAfterEdit(DataSet: TDataSet);

begin
    {FXX05142009-1(2.20.1.1)[D1537]: Audit grievance, small claims, certiorari.}

  CreateFieldValuesAndLabels(Self, SmallClaimsTable, FieldTraceInformationList);

end;

{===================================================================}
Procedure TSmallClaimsSubform.LawyerLookupComboDropDown(Sender: TObject);

begin
  OldLawyerCode := SmallClaimsTable.FieldByName('LawyerCode').Text;
end;

{===================================================================}
Procedure TSmallClaimsSubform.LawyerLookupComboCloseUp(Sender: TObject;
                                                      LookupTable,
                                                      FillTable: TDataSet;
                                                      modified: Boolean);

{If they change lawyer codes, then change the petitioner information.}

begin
  If (OldLawyerCode <> LawyerCodeTable.FieldByName('Code').Text)
    then
      begin
        If not (SmallClaimsTable.State in [dsEdit, dsInsert])
          then SmallClaimsTable.Edit;

          {CHG07262004-1(2.08): Option to have attorney information separate.}

        If GlblGrievanceSeperateRepresentativeInfo
          then SetAttorneyNameAndAddress(SmallClaimsTable, LawyerCodeTable,
                                         LawyerCodeTable.FieldByName('Code').Text)
          else SetPetitionerNameAndAddress(SmallClaimsTable, LawyerCodeTable,
                                           LawyerCodeTable.FieldByName('Code').Text);

      end;  {If (OldLawyerCode <> LawyerCodeTable.FieldByName('Code').Text)}

end;  {LawyerLookupComboCloseUp}

{===================================================================}
Procedure TSmallClaimsSubform.ComplaintReasonLookupComboCloseUp(Sender: TObject;
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
        Caption := 'Please chose the small claim reason.';

        If (ShowModal = idOK)
          then
            begin
              TempComplaintSubreasonCode := GrievanceComplaintSubreasonCode;

              FindKeyOld(GrievanceComplaintSubreasonTable, ['Code'],
                         [TempComplaintSubreasonCode]);

              If (SmallClaimsTable.State = dsBrowse)
                then SmallClaimsTable.Edit;

              TMemoField(SmallClaimsTable.FieldByName('PetitSubreason')).Assign(TMemoField(GrievanceComplaintSubreasonTable.FieldByName('Description')));
              SmallClaimsTable.FieldByName('PetitSubreasonCode').Text := TempComplaintSubreasonCode;

            end;  {If (ShowModal = idOK)}

      end;  {with GrievanceComplaintSubreasonDialog do}

  finally
    GrievanceComplaintSubreasonDialog.Free;
  end;

  EditAskingLandValue.SetFocus;

end;  {ComplaintReasonLookupComboCloseUp}

{================================================================}
Procedure TSmallClaimsSubform.SmallClaimsTableBeforePost(DataSet: TDataSet);

begin
  with SmallClaimsTable do
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

    end;  {with SmallClaimsTable do}

end;  {SmallClaimsTableBeforePost}

{================================================================}
Procedure TSmallClaimsSubform.AddExemptionClaimedButtonClick(Sender: TObject);

begin
  SmallClaimsExemptionsAskedTable.Append;
  AskingExemptionsGrid.SetFocus;
  AskingExemptionsGrid.SetActiveField('ExemptionCode');

end;  {AddExemptionClaimedButtonClick}

{================================================================}
Procedure TSmallClaimsSubform.DeleteExemptionAskedButtonClick(Sender: TObject);

begin
  SmallClaimsExemptionsAskedTable.Delete;
end;

{================================================================}
Procedure TSmallClaimsSubform.AppraisalTableNewRecord(DataSet: TDataSet);

begin
  with AppraisalTable do
    begin
      FieldByName('SwisSBLKey').Text := SwisSBLKey;
      FieldByName('TaxRollYr').Text := SmallClaimsYear;
      FieldByName('IndexNumber').AsInteger := IndexNumber;

    end;  {with AppraisalTable do}

  AppraisalGrid.SetActiveField('DateAuthorized');

end;  {AppraisalTableNewRecord}

{================================================================}
Procedure TSmallClaimsSubform.NewAppraisalButtonClick(Sender: TObject);

begin
  try
    AppraisalTable.Append;
  except
    SystemSupport(001, AppraisalTable, 'Error appending to Appraisal table.',
                  UnitName, GlblErrorDlgBox);
  end;

end;  {NewAppraisalButtonClick}

{================================================================}
Procedure TSmallClaimsSubform.RemoveAppraisalButtonClick(Sender: TObject);

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
Procedure TSmallClaimsSubform.CalenderTableNewRecord(DataSet: TDataSet);

begin
  with CalenderTable do
    begin
      FieldByName('SwisSBLKey').Text := SwisSBLKey;
      FieldByName('TaxRollYr').Text := SmallClaimsYear;
      FieldByName('IndexNumber').AsInteger := IndexNumber;

    end;  {with CalenderTable do}

  CalenderGrid.SetActiveField('MeetingType');

end;  {CalenderTableNewRecord}

{=============================================================}
Procedure TSmallClaimsSubform.NewCalenderButtonClick(Sender: TObject);

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
Procedure TSmallClaimsSubform.RemoveCalenderButtonClick(Sender: TObject);

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
Procedure TSmallClaimsSubform.PrintCalenderButtonClick(Sender: TObject);

begin
  If PrintDialog.Execute
    then
      begin
      end;  {If PrintDialog.Execute}

end;  {PrintCalenderButtonClick}

{================================================================}
Procedure TSmallClaimsSubform.ResultTypeLookupComboCloseUp(Sender: TObject;
                                                           LookupTable,
                                                           FillTable: TDataSet;
                                                           modified: Boolean);

begin
  SmallClaimsTable.FieldByName('DispositionDate').AsDateTime := Date;
  EditResultDate.SetFocus;
end;  {ResultTypeLookupComboCloseUp}

{================================================================}
Procedure TSmallClaimsSubform.SmallClaimsTableAfterPost(DataSet: TDataSet);

begin
  RecordChanges(Self, 'Small Claims', SmallClaimsTable, SwisSBLKey,
                FieldTraceInformationList);
  FillInSummaryInfo;
end;

{================================================================}
Procedure TSmallClaimsSubform.SaveAllChanges;

var
  PostCancelled : Boolean;

begin
  PostCancelled := False;

  If SmallClaimsTable.Modified
    then
      try
        SmallClaimsTable.Post;
      except
        If not PostCancelled
          then SystemSupport(002, SmallClaimsTable, 'Error posting to small claims table.',
                             UnitName, GlblErrorDlgBox);
      end;

  If SmallClaimsExemptionsAskedTable.Modified
    then
      try
        SmallClaimsExemptionsAskedTable.Post;
      except
        SystemSupport(070, SmallClaimsExemptionsAskedTable, 'Error posting to small claims exemptions asked table.',
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

  If (DocumentTable.State in [dsEdit, dsInsert])
    then
      try
        DocumentTable.Post;
      except
        SystemSupport(006, DocumentTable, 'Error posting document link.',
                      UnitName, GlblErrorDlgBox);
      end;

  If (glblPrintSmallClaimsRebateForms and
      (_Compare(OrigDisposition, coBlank) and
       _Compare(SmallClaimsTable.FieldByName('Disposition').AsString, coNotBlank)))
    then PrintButtonClick(nil);

end;  {SaveAllChanges}

{=============================================================}
Procedure TSmallClaimsSubform.SaveButtonClick(Sender: TObject);

begin
    {FXX07192007-1(2.11.2.6)[D449]: It should not ask if you want to save
                                    certiorari changes in small claims.}

  If ((SmallClaimsTable.Modified or
       SmallClaimsExemptionsAskedTable.Modified or
       AppraisalTable.Modified or
       CalenderTable.Modified or
       DocumentTable.Modified) and
      ((not GlblAskSave) or
       (MessageDlg('Do you want to save your small claims changes?', mtConfirmation,
                   [mbYes, mbNo], 0) = idYes)))
    then SaveAllChanges;

end;  {SaveButtonClick}

{================================================================}
Procedure TSmallClaimsSubform.CancelAllChanges;

begin
  If SmallClaimsTable.Modified
    then SmallClaimsTable.Cancel;

  If AppraisalTable.Modified
    then AppraisalTable.Cancel;

  If CalenderTable.Modified
    then CalenderTable.Cancel;

  If DocumentTable.Modified
    then DocumentTable.Cancel;

  If SmallClaimsExemptionsAskedTable.Modified
    then SmallClaimsExemptionsAskedTable.Cancel;

end;  {CancelAllChanges}

{================================================================}
Procedure TSmallClaimsSubform.CancelButtonClick(Sender: TObject);

begin
  If (MessageDlg('Do you want to cancel your changes?', mtConfirmation,
                 [mbYes, mbNo], 0) = idYes)
    then CancelAllChanges;

end;  {CancelButtonClick}

{======================================================}
Procedure TSmallClaimsSubform.PrintButtonClick(Sender: TObject);

begin
  PrintSmallClaimsRebateForm(SmallClaimsTable,
                             tbParcels,
                             SwisSBLKey,
                             //SmallClaimsYear,
                             glblThisYear,
                             glblCountyTaxDatabaseName,
                             glblCountyCollectionType,
                             glblCountyCollectionNumber,
                             glblMunicipalityName,
                             glblCountyBaseTaxRatePointer,
                             glblSCARFormTemplateFileName,
                             False);

end;  {PrintButtonClick}

{=====================================================================}
Procedure TSmallClaimsSubform.SetScrollBars;

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
Procedure TSmallClaimsSubform.DocumentTableNewRecord(DataSet: TDataSet);

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
              _SetRange(DocumentLookupTable, [SmallClaimsYear, SwisSBLKey, IndexNumber, 0],
                        [SmallClaimsYear, SwisSBLKey, IndexNumber, 32000], '', []);

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
                  FieldByName('TaxRollYr').Text := SmallClaimsYear;
                  FieldByName('IndexNumber').Text := IntToStr(IndexNumber);
                  FieldByName('SwisSBLKey').Text := SwisSBLKey;

                end;  {with DocumentTable do}

              DocumentTypeSelected := DocumentTypeDialogForm.DocumentTypeSelected;

            end;  {If (DocumentTypeDialogForm.ModalResult = idOK)}

      finally
        DocumentTypeDialogForm.Free;
      end;

end;  {DocumentTableNewRecord}

{======================================================}
Procedure TSmallClaimsSubform.DocumentTableAfterInsert(DataSet: TDataSet);

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
Procedure TSmallClaimsSubform.DocumentTableAfterScroll(DataSet: TDataSet);

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
Procedure TSmallClaimsSubform.OleWordDocumentTimerTimer(Sender: TObject);

{FXX03152004-2(2.08): Make it so that Word documents show in the OLE container.}

begin
  OleWordDocumentTimer.Enabled := False;
  OleContainer.SetFocus;
(*  OleContainer.DoVerb(ovShow); *)

end;  {OleWordDocumentTimerTimer}

{======================================================}
Procedure TSmallClaimsSubform.OLEItemNameTimerTimer(Sender: TObject);

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
Procedure TSmallClaimsSubform.WordApplicationQuit(Sender: TObject);

begin
  DocumentActive := False;
end;

{======================================================}
Procedure TSmallClaimsSubform.WordDocumentClose(Sender: TObject);

begin
  If not WordDocument.Saved
    then WordDocument.Save;

  If (DocumentTable.State in [dsEdit, dsInsert])
    then DocumentTable.FieldByName('DocumentLocation').Text := WordDocument.FullName;

  DocumentActive := False;

end;  {WordDocumentClose}

{======================================================}
Procedure TSmallClaimsSubform.NewDocumentButtonClick(Sender: TObject);

begin
  DocumentTable.Insert;
end;

{===============================================================}
Procedure TSmallClaimsSubform.ExcelApplicationWorkbookBeforeClose(    Sender: TObject;
                                                                  var Wb, Cancel: OleVariant);

begin
  If not ExcelApplication.ActiveWorkbook.Saved[lcID]
    then ExcelApplication.ActiveWorkbook.Save(lcID);

  If (DocumentTable.State in [dsEdit, dsInsert])
    then DocumentTable.FieldByName('DocumentLocation').Text := ExcelApplication.ActiveWorkbook.FullName[lcID];

  DocumentActive := False;

end;  {ExcelApplicationWorkbookBeforeClose}

{======================================================}
Procedure TSmallClaimsSubform.DeleteDocumentButtonClick(Sender: TObject);

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
Procedure TSmallClaimsSubform.FullScreenButtonClick(Sender: TObject);

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

{======================================================}
Procedure TSmallClaimsSubform.FormCloseQuery(    Sender: TObject;
                                            var CanClose: Boolean);

var
  Decision : Integer;

begin
  CanClose := True;

  If (SmallClaimsTable.Modified or
      SmallClaimsExemptionsAskedTable.Modified or
      CalenderTable.Modified or
      AppraisalTable.Modified or
      DocumentTable.Modified)
    then
      begin
        If GlblAskSave
          then Decision := MessageDlg('Do you want to save your certiorari changes?', mtConfirmation,
                                      [mbYes, mbNo, mbCancel], 0)
          else Decision := idOK;

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

      end;  {If (SmallClaimsTable.Modified or}

end;  {FormCloseQuery}

{======================================================}
Procedure TSmallClaimsSubform.CloseButtonClick(Sender: TObject);

begin
  Close;
end;

{======================================================}
Procedure TSmallClaimsSubform.FormClose(    Sender: TObject;
                                       var Action: TCloseAction);

begin
  FreeTList(FieldTraceInformationList, SizeOf(FieldTraceInformationRecord));
  CloseTablesForForm(Self);
end;

end.
