unit Mainform;

{To add a new item to the main menu:

  1. If this is a generic table maintenance, go to the
     "TableMaintClick" handler and create a constant for this maint.
     with a unique numerical identifier. In the Object Inspector,
     put this number into the Tag property of the corresponding
     menu item. Then set the event handler for the OnClick to
     "TableMaintClick" (select from the drop down). Then go back
     into the code and copy one of the case blocks (marked
     by mmm) and adjust the variables to the new maint.

  2. Otherwise, go to the "NormalMenuItemClick" handler and
     create a constant for this form with a unique numerical
     identifier. In the Object Inspector,
     put this number into the Tag property of the corresponding
     menu item. Then set the event handler for the OnClick to
     "NormalMenuItemClick" (select from the drop down). Then go
     back into the code and copy one of the case blocks (marked
     by mmm) and adjust the variables (AllowMoreThanOneInstance and
     TabName). Then go to the next mmm and create a new case entry
     for the creation of this form.
  }

interface

uses WinTypes, WinProcs, SysUtils, Classes, Graphics, Forms, Controls, Menus,
  StdCtrls, Dialogs, Buttons, Messages, ExtCtrls, Tabs, Mask, DBGrids, WWdbGrid,
  DBCtrls,GlblVars, DBTables, DB, WwTable, Wwdatsrc, Btrvdlg, Logindlg,
   Printers, RPDefine, RPBase, RPCanvas, RPrinter, DLL96V1, FileCtrl, Registry,
  Progress, ShellAPI, PSJob, PJBitmap, PJControl, PJForm, PSWindow,
  PSToolbar, PSPreview{, rsFileVersion};

type
  TMainPASForm = class(TForm)
    MainMenu: TMainMenu;
    Tables: TMenuItem;
    MenuLine1: TMenuItem;
    MenuExitItem: TMenuItem;
    TabSet: TTabSet;
    SwisCode: TMenuItem;
    SchoolCodeTable: TMenuItem;
    SDistTable: TMenuItem;
    ParcelsSubMenu: TMenuItem;
    System1: TMenuItem;
    SystemRecord: TMenuItem;
    ExemptionCodeTable: TMenuItem;
    PropertyClass: TMenuItem;
    SpclDistExtCodes: TMenuItem;
    mnitmParcelAdd: TMenuItem;
    mnitmModifyParcel: TMenuItem;
    mnitmInactivateParcel: TMenuItem;
    ViewaParcel: TMenuItem;
    NotesTransactionCodes1: TMenuItem;
    HomesteadCodes1: TMenuItem;
    SewerCodes1: TMenuItem;
    WaterCodes1: TMenuItem;
    UtilityCodes1: TMenuItem;
    SiteDesirabilityCodes1: TMenuItem;
    NeighborhoodTypeCodes1: TMenuItem;
    NeighborhoodRatingCodes1: TMenuItem;
    NeighborhoodCodes1: TMenuItem;
    RollSectionCodes1: TMenuItem;
    RoadTypeCodes1: TMenuItem;
    BasicTables1: TMenuItem;
    N1: TMenuItem;
    MiscTables1: TMenuItem;
    InventoryTables2: TMenuItem;
    SpecialDistrictTables1: TMenuItem;
    ExemptionCodeTables1: TMenuItem;
    CalculationMethodMaint1: TMenuItem;
    TotalsVerifTypeMaint1: TMenuItem;
    SpecialDistCalculationCodes1: TMenuItem;
    SpecialDistExtensionFlagCodes1: TMenuItem;
    Help1: TMenuItem;
    OptionsSubMenu: TMenuItem;
    SelectTaxRollYear1: TMenuItem;
    UserProfile1: TMenuItem;
    SecurityLevels1: TMenuItem;
    MenuSecurityTable: TTable;
    Timer: TTimer;
    UserProfileTable: TTable;
    TrafficCodes1: TMenuItem;
    ElevationCodes1: TMenuItem;
    StructureCodes1: TMenuItem;
    SiteTables1: TMenuItem;
    BuildingTable1: TMenuItem;
    ExteriorWallCodes1: TMenuItem;
    ImprovementTables1: TMenuItem;
    GradeCodes1: TMenuItem;
    BuildingStyleCodes1: TMenuItem;
    QualityCodes1: TMenuItem;
    HeatTypeCodes1: TMenuItem;
    FuelTypeCodes1: TMenuItem;
    ConditionCodes1: TMenuItem;
    BasementTypeCodes1: TMenuItem;
    GradeCodes2: TMenuItem;
    PhysicalChangeCodes1: TMenuItem;
    LandTables1: TMenuItem;
    LandTypeCodes1: TMenuItem;
    SoilRatingCodes1: TMenuItem;
    WaterfrontTypeCodes1: TMenuItem;
    InfluenceCodes1: TMenuItem;
    ForestStandTables1: TMenuItem;
    RegionCodes1: TMenuItem;
    ForestTypeCodes1: TMenuItem;
    LoggingEaseCodes1: TMenuItem;
    AccessibilityCodes1: TMenuItem;
    NominalValueCodes1: TMenuItem;
    SiteClassCodes1: TMenuItem;
    CutClassCodes1: TMenuItem;
    VolumePerAcreClassCodes1: TMenuItem;
    ZoningCodes1: TMenuItem;
    PorchTypeCodes1: TMenuItem;
    EntryCodes1: TMenuItem;
    SalesTables2: TMenuItem;
    Verify1: TMenuItem;
    Validity1: TMenuItem;
    Type1: TMenuItem;
    Status1: TMenuItem;
    Ownership1: TMenuItem;
    EA52171: TMenuItem;
    DeedType1: TMenuItem;
    Condition1: TMenuItem;
    ArmsLength1: TMenuItem;
    UsedAsCodes1: TMenuItem;
    BasementTypeCodesCommercial1: TMenuItem;
    BoekhModelNo1: TMenuItem;
    RentableAreas1: TMenuItem;
    UnitCodes1: TMenuItem;
    TypeCodes1: TMenuItem;
    IncomeExpenseTables1: TMenuItem;
    ExpenseCode1: TMenuItem;
    DataUseCodes1: TMenuItem;
    ApprecitionDepreciationCodes1: TMenuItem;
    InvestmentSetCodes1: TMenuItem;
    ValuationDistrictCodes1: TMenuItem;
    ConstructionQualityCodes1: TMenuItem;
    AssmentYearControlTable1: TMenuItem;
    N2: TMenuItem;
    mnitmKeyChange: TMenuItem;
    Reports1: TMenuItem;
    NotesReport1: TMenuItem;
    NotesTypeCodes1: TMenuItem;
    RollTotals2: TMenuItem;
    Login: TMenuItem;
    mnitmReactivateParcel: TMenuItem;
    ResidentialTypeCodes: TMenuItem;
    AuditTrailReport1: TMenuItem;
    SalesReport: TMenuItem;
    mniTaxBilling: TMenuItem;
    BillCollectionType: TMenuItem;
    EasementCodes1: TMenuItem;
    LandCommitmentCodes1: TMenuItem;
    CurrentYearValueTypeCodes1: TMenuItem;
    OwnershipCodes1: TMenuItem;
    RevisedCurrentYearValueTypeCodes1: TMenuItem;
    BillCollRateTaxType1: TMenuItem;
    CreateTaxCollectionCycle1: TMenuItem;
    SetTaxRates1: TMenuItem;
    CalculateTaxBills1: TMenuItem;
    AssessorsReport1: TMenuItem;
    ImportExport1: TMenuItem;
    N995FileExtract1: TMenuItem;
    BankCodeImport1: TMenuItem;
    MunicipalityTypeCodes1: TMenuItem;
    mnitm_PrintTaxRoll: TMenuItem;
    N147155FileExtract1: TMenuItem;
    DefineUserData1: TMenuItem;
    SearchData1: TMenuItem;
    ExemptionsRecalculation1: TMenuItem;
    ExemptionReport1: TMenuItem;
    AssessmentVarianceReport1: TMenuItem;
    AssessmentSummaryReport1: TMenuItem;
    AssessmentRolls: TMenuItem;
    YearEndRollover1: TMenuItem;
    LetterText1: TMenuItem;
    ExemptionLetters1: TMenuItem;
    Assessormaint: TMenuItem;
    NotesTable: TwwTable;
    AsssessmentChangeLetters1: TMenuItem;
    N4: TMenuItem;
    ChangeThisYearandNextYearTogether: TMenuItem;
    DisplayComparatives1: TMenuItem;
    Comparables1: TMenuItem;
    SiteDesirabilityCodesCommercial1: TMenuItem;
    PrinterSetup1: TMenuItem;
    PrinterSetupDialog: TPrinterSetupDialog;
    SalesAnalysisReport1: TMenuItem;
    SpecialDistrictBroadcast: TMenuItem;
    SpecialDistrictReport1: TMenuItem;
    BuildingPermitReport: TMenuItem;
    SysRecTable: TTable;
    VeteransLimitsCodes1: TMenuItem;
    PrintMtPleasantTownTaxBills: TMenuItem;
    GenericLetters1: TMenuItem;
    AssessmentByPropertyClassReport1: TMenuItem;
    AssessorsVerificationReport1: TMenuItem;
    Labels1: TMenuItem;
    PropertyCards1: TMenuItem;
    InstalledPrinterTable: TTable;
    InstalledPrinterTablePrinterName: TStringField;
    InstalledPrinterTableLaser: TBooleanField;
    InstalledPrinterTableReserved: TStringField;
    MtVernonTaxExtractFile1: TMenuItem;
    RollTotalsPrint1: TMenuItem;
    ReportManager1: TMenuItem;
    ShowParcelList1: TMenuItem;
    AssessorsTrialBalanceReport1: TMenuItem;
    ExemptionBroadcast1: TMenuItem;
    SplitMergeReport1: TMenuItem;
    AssessorsOfficeTable: TTable;
    WarningsDisplayedTable: TTable;
    BroadcastChanges1: TMenuItem;
    SpecialDistrictComparisonReport1: TMenuItem;
    Letters2: TMenuItem;
    GeneralizedExport1: TMenuItem;
    ExemptionComparisonReport1: TMenuItem;
    OptionalItemsTable: TTable;
    PrintMtPleasantSchoolTaxBills: TMenuItem;
    PrintHastingsVillageTaxBills1: TMenuItem;
    AuditReports1: TMenuItem;
    NameAddressAuditTrailReport1: TMenuItem;
    ExemptionStatusReport1: TMenuItem;
    PrintWesleyHillsTaxBills1: TMenuItem;
    LoginDlg: TLoginDlg;
    OpenTablesInDataModuleTimer: TTimer;
    SalesExtractLog1: TMenuItem;
    DocumentTypesAvailable1: TMenuItem;
    UserInfoPanel: TPanel;
    LogoImage: TImage;
    TitleLabel: TLabel;
    VersionLabel: TLabel;
    MunicipalityLabel: TLabel;
    GroupBox1: TGroupBox;
    UserIDLabel: TLabel;
    CurrentTaxYearLabel: TLabel;
    DateLabel: TLabel;
    LoadPicturesDocuments1: TMenuItem;
    ClearArrearsFlags1: TMenuItem;
    SeniorIncomeLevels1: TMenuItem;
    PrintRyeCityBills1: TMenuItem;
    PrintRyeCountyBills1: TMenuItem;
    SalesAndRemovedExemptionsReport1: TMenuItem;
    SquareFootLivingAreaRecalculation1: TMenuItem;
    PrintRyeSchoolBills1: TMenuItem;
    PrintSomersSchoolBills1: TMenuItem;
    UpdateIndividualComputersSettings1: TMenuItem;
    LaserBillFileExtract1: TMenuItem;
    TopTaxpayerReport1: TMenuItem;
    Maps1: TMenuItem;
    BackupPropertyAssessmentData1: TMenuItem;
    SaveDialog: TSaveDialog;
    OpenDialog: TOpenDialog;
    BDEAdministrator: TMenuItem;
    N3rdPartyNotificationReport1: TMenuItem;
    LoadArrearsFlagsfromDelinquentTaxSystem1: TMenuItem;
    MapTypeCodes1: TMenuItem;
    TaskList1: TMenuItem;
    TaskListTable: TTable;
    mi_UpdateNamesandAddressesinTaxSystems: TMenuItem;
    GrievanceTables: TMenuItem;
    BOARMembersMaintenance: TMenuItem;
    BOARDispositionCodes1: TMenuItem;
    PetitionerComplaintCategoryCodes1: TMenuItem;
    BOARDenialReasonCodes1: TMenuItem;
    LawyerCodes1: TMenuItem;
    GrievanceReports: TMenuItem;
    GrievanceSummaryReport1: TMenuItem;
    ResultsByBoarMemberReport: TMenuItem;
    GrievanceLetters1: TMenuItem;
    PetitionerComplaintReasonCodes1: TMenuItem;
    ParcelToolbarTimer: TTimer;
    GrievanceAuditReport: TMenuItem;
    GrievanceBulkUpdate1: TMenuItem;
    N3: TMenuItem;
    CertiorariTables: TMenuItem;
    AppraiserTable1: TMenuItem;
    JudgeTable1: TMenuItem;
    LawyerCodes2: TMenuItem;
    PetitionerComplaintCategoryCodes2: TMenuItem;
    PetitionerComplaintReasonCodes2: TMenuItem;
    SalesReports1: TMenuItem;
    N7: TMenuItem;
    CertiorariReports: TMenuItem;
    CertiorariSummaryReport1: TMenuItem;
    CertiorariCalender1: TMenuItem;
    SmallClaimsReports: TMenuItem;
    SmallClaimsSummaryReport1: TMenuItem;
    SmallClaimsCalendar1: TMenuItem;
    MoveValuesfromCooperativeRolltoMainRoll: TMenuItem;
    OverallGrievanceSmallClaimsCertiorariReport: TMenuItem;
    TaskUserTable: TTable;
    CertiorariHistoryReport: TMenuItem;
    WorkstationSettingsUtilities1: TMenuItem;
(*    UpdateBDESettings1: TMenuItem; *)
    RestrictParcelsViewedbySearcherMenuItem: TMenuItem;
    PrintVillageofLawrenceBills1: TMenuItem;
    CertiorariNotesReportMenuItem: TMenuItem;
    LoadPicturesfromLoadingDock1: TMenuItem;
    SendNameAddressUpdatetoVillages: TMenuItem;
    ImportNamesandAddressesfromTown: TMenuItem;
    CertiorariNotesTable: TwwTable;
    GeneralProcessingHelpMenuItem: TMenuItem;
    ReportsHelpMenuItem: TMenuItem;
    N5: TMenuItem;
    About1: TMenuItem;
    N8: TMenuItem;
    EmailPASSupport1: TMenuItem;
    N9: TMenuItem;
    mnuitmImportSeniorEnhancedSTARIVPStatus: TMenuItem;
    PASWebsite1: TMenuItem;
    ExemptionReportsMenuItem: TMenuItem;
    RemovedExemptionsReport1: TMenuItem;
    ExemptionComparisonReport2: TMenuItem;
    SpecialDistrictReports: TMenuItem;
    SpecialDistrictComparisonReport2: TMenuItem;
    GeneralizedComparisonMenuItem: TMenuItem;
    CreateSketchesforSearcherMenuItem: TMenuItem;
    FindUsersNotLoggedOutofSystem1: TMenuItem;
    GetyourIPAddress1: TMenuItem;
    HelpDocumentTable: TTable;
    ReleaseNotesTable: TTable;
    ReleaseNotesLineMenuItem: TMenuItem;
    ReleaseNotesMenuItem: TMenuItem;
    PrintVillageofBrookvilleBills1: TMenuItem;
    CompareParcelIDsbetweenSCASystems1: TMenuItem;
    PictureAndPropertyCardReport1: TMenuItem;
    YorktownNameAddressExtractUpdate1: TMenuItem;
    SystemShutdownTimer: TTimer;
    Preview: TPreview;
    PreviewToolbar: TPreviewToolbar;
    PreviewMain: TPreviewWindow;
    FormPrintJob: TFormPrintJob;
    ProrataMenuItem: TMenuItem;
    ProrataCalculation1: TMenuItem;
    ProrataList1: TMenuItem;
    ProrataLetters1: TMenuItem;
    ProrataValueTransfer1: TMenuItem;
    CreateRyeBillingExtract1: TMenuItem;
    PrintScarsdaleVillageCountyBills1: TMenuItem;
    PrintRyeCityCountyBills1: TMenuItem;
    PrintMalverneBills1: TMenuItem;
    ReduceBIEExemptionsMenuItem: TMenuItem;
    PrintEastchesterSchoolBills1: TMenuItem;
    mni_ProrataWorksheets: TMenuItem;
    PrintScarsdaleSchoolBills1: TMenuItem;
    mnitm_PrintCooperativeTaxRoll: TMenuItem;
    LoadNassauCountyValues1: TMenuItem;
    PrintSuffernSolidWasteBills1: TMenuItem;
    PrintEastchesterTownBills1: TMenuItem;
    PrintSuffernSolidWasteBills2ndHalf1: TMenuItem;
    ExemptionLetters2: TMenuItem;
    ExemptionPurge1: TMenuItem;
    mnitm_NYSORPSCoopExtract: TMenuItem;
    ValueComparisonReport1: TMenuItem;
    ColdWarVeteranLimits1: TMenuItem;
    PrintLakeSuccessBills1: TMenuItem;
    mnitm_Coops: TMenuItem;
    CoopBuildingMaintenance1: TMenuItem;
    mnuDispositionCodes: TMenuItem;
    mnuMiddleClassSTARExtract: TMenuItem;
    N10: TMenuItem;
    PrintEastHamptonBills1: TMenuItem;
    N11: TMenuItem;
    CopyTaxRatesfromMainRoll1: TMenuItem;
    CalculateTaxBills2: TMenuItem;
    mnuExemptionImpactReport: TMenuItem;
    PrintSouthamptonBills1: TMenuItem;
    PrintTarrytownBills1: TMenuItem;
    mnuitmBillSeparator: TMenuItem;
    TransferSTARSavingsfromCoopRolltoMainRoll1: TMenuItem;
    PrintParcelSummarywithSketch1: TMenuItem;
    PrintMasticBeachBills1: TMenuItem;
    SmallClaimsNotesTable: TwwTable;
    procedure FormCreate(Sender: TObject);
    procedure TabSetChange(Sender: TObject; NewTab: Integer;
      var AllowChange: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure TableMaintClick(Sender: TObject);
    procedure NormalMenuItemClick(Sender: TObject);
    procedure ParcelClick(Sender: TObject);
    procedure MenuExitItemClick(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure SelectTaxRollYear1Click(Sender: TObject);
    procedure LoginClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure ChangeThisYearandNextYearTogetherClick(Sender: TObject);
    procedure PrinterSetup1Click(Sender: TObject);
    procedure ShowParcelList1Click(Sender: TObject);
    procedure OpenTablesInDataModuleTimerTimer(Sender: TObject);
    procedure DisplayComparatives1Click(Sender: TObject);
    procedure Maps1Click(Sender: TObject);
    procedure BackupPropertyAssessmentData1Click(Sender: TObject);
    procedure BDEAdministratorClick(Sender: TObject);
    procedure ParcelToolbarTimerTimer(Sender: TObject);
(*    procedure UpdateBDESettings1Click(Sender: TObject); *)
    procedure EmailPASSupport1Click(Sender: TObject);
    procedure PASWebsite1Click(Sender: TObject);
    procedure FindUsersNotLoggedOutofSystem1Click(Sender: TObject);
    procedure GetyourIPAddress1Click(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure PreviewToolbarUserButtonClick(Sender: TObject);
    procedure FormPrintJobDraw(Sender: TObject; TheCanvas: TCanvas;
      PageIndex: Integer; TheRect: TRect; Area: TDrawArea;
      Target: TDrawTarget);
    procedure CopyTaxRatesfromMainRoll1Click(Sender: TObject);
  private
    { Private declarations }
    Procedure DetermineAvailableMenuOptions; {Based on the security level,
                                              what menu options are available to this user?}
    Function DetermineFormAccessRights(MenuID : Integer) : Integer;  {Based on the security level,
                                                                do they have read only or read write access?}
    {FXX08261999-2: If click X in upper right, exit all the way, not
                    back to locate menu.}
    Procedure WMQueryEndSession(var Message : TWMQueryEndSession);
                                message WM_QUERYENDSESSION;

  public
    { Public declarations }
    UnitName : String;
    DataModuleComponentIndex : Integer;
    Initializing, OpenFiles, CalculateRollTotals : Boolean;

    Procedure SynchronizeTabsWithForms(Sender : TObject);
{If the proper Tab is not selected for the active form, then we want to select it.}
{This procedure is called whenever the active form is changed.
 This occurs at 5 different times:

   1. When the main MDI form is initially created, it is called (since it goes from
      no active form showing to having the main MDI form showing). In this case,
      since MDIChildCount is 0, we do nothing.

   2. Whenever a new form is created, since the new form shows itself immediatly.
      In this case there is also no action taken since the Form name (caption) for
      this new form is not in the list yet. This is what we want since each form
      takes care of selecting the proper Tab itself.

   3. Whenever switching forms while using the Tabs. In this case, the ActiveMDIChild
      is already the proper form for the Tab that they just clicked on, and hence
      no action is taken.  Look in the event for OnTabChange to follow why this is.

   4. Whenever the person switches between forms using some other method (i.e. Next
      from the Child system menu, a Window list, or by clicking on a visible portion of
      another screen. In this case, we look through the list of form name to find the
      ActiveMDIChild caption, and then we synchronize the Tabs.

   5. When a person closes a form. In this case, we will look for each caption name in
      the list of MDIChildren. When we find one that no longer exists, we will delete
      this Tab and the entry in the caption name list. We will know that a form has been
      deleted because a flag will have been set in the child form when it closed.}


    Procedure PASExceptionHandler(Sender : TObject;
                                  E : Exception);
    {This is the exception handler that will be assigned to the overall application.
     So, rather than a regular message dlg. being shown, we will display our own
     message and can customize it based on what type of exception it is.
     This exception handler is assigned to be the default application exception
     handler in the create of this form.}

    Procedure PASMessageHandler(var Msg: TMsg;
                                var Handled: Boolean);
    {Intercept the print screen key and print.}

    Procedure ApplicationActivate(Sender : TObject);
    {FXX10211997-4: Make it so that progress panel does not prevent
                    people from going to other apps.}

    Procedure ApplicationDeactivate(Sender : TObject);

    Procedure ApplicationMinimize(Sender : TObject);
    Procedure LimitSearcherOptions;

    Procedure HelpDocumentMenuItemClick(Sender : TObject);
    Procedure AddHelpDocumentsMenuItems;

    Procedure ReleaseNotesMenuItemClick(Sender : TObject);
    Procedure AddReleaseNotesMenuItems;
  end;

var
  MainPASForm: TMainPASForm;

implementation

uses Types,Utilitys,WinUtils,PASTypes,PASUTILS, UTILEXSD,  UtilPrcl,
     RPAVSmry,  {Assessed value summary report}
     TableMnt,  {Generic table maint. form}
     StrctMnt,  {Structure code maint.}
     UseAsMnt,  {Used as codes maint.}
(*     Swscdmnt,  {Swis code maint.} *)
     SchcdMnt,  {School code maint.}
     SDCodMnt,  {Special district code maint.}
     Sysrcmnt,  {System rec. maint.}
     SDEcdMnt,  {Special district extension code maint.}
     ExCodMnt,  {Exemption code maintenance}
     LtrtxMnt,  {free-form letter text maintenance}
     AsOfcMnt,  {assessor's office file maint}
     ParclTab,  {Parcel maintenance - add/modify/view}
     ParclDel,  {Parcel delete}
     ParclRea,  {Parcel reactivate}
     KeyChng,   {Parcel split\merge\key change\replicate}
     UserProf,  {User profile}
     RTCalcul,    {Roll total calculation- on line}
     RPAsesor,  {Assessor's report}
     RAuditRl,  {Audit Trail Report}
     RSlsRept,  {Sales Report}
     RPExList,  {Exemption list}
     RNoteRpt,  {Notes report}
     RpExmLtr,  {Exemption Letter Print}
     RpAscLtr,  {assessment chg letter print}
     RSearch,   {Search report}
     AsmtRoll,  {Assessment rolls}
     RPAVVari,  {Assessed value variance report}
     RPAVPRCL,  {AV by property class}
     RTDisply,  {Display roll totals on screen}
     BCollCtl,  {Create Tax Bill Cycle Control Record}
     BCollRte,  {Create Tax Bill Cycle Rates Records}
     Bcollclc,  {Bill calculation job}
     BCollRol,  {Print tax roll job}
     BillPrnt,  {Print Wesley bills}
     Impbkcod,  {import bank codes}
     RPS155Ex,  {RPS 147\155 file extract}
     RPS995Ex,  {RPS 995 file extract}
     Security,  {Menu security maintenance}
     AssYrMnt,  {Assessment year control file}
     ChosTxYr,  {Choose tax year}
     PUserdef,  {Define field names for user data fields}
     ExRecalc,  {Recalc all exemptions}
     YrendRol,  {Year end rollover}
     NotesRem,  {Notes reminder}
     CmpCreat,  {create comparables file}
     RPSLANAL,  {Sales analysis report}
     SDBRDCST,  {Special district broadcast}
     RPSDLIST,  {Special district report}
     RBLDPRPT,  {Building permit view\report}
     VETLMTCD,  {Veterans limits codes}
     RPGENLTR,  {Generic letters}
     RPASRVER,  {Assessor's verification report}
     RPLABELS,  {Labels}
     RPPRCPRT,  {Property cards}
     PRNTRMNT,  {Printer maintenance}
     MTVRTXEX,  {Mt Vernon tax extract}
     RPROLTOT,  {Roll total print}
     RPMANAGE,  {Report manager}
     PRCLLIST,  {Parcel list}
     RPASRTRL,  {Assessor's trial balance.}
     EXBRDCST,  {Exemption broadcast}
     RPSPLMRG,  {Split\Merge report}
     BROADCST,  {Broadcast form}
     RPCOMPSD,  {Compare special districts report.}
     RPCOMPEX,  {Compare exemptions report}
     GNRLEXTR,  {generalized extract}
     RPEXSTAT,  {Exemption status report}
     RAUDNMAD,  {Name\address audit report}
     STAREXTR,  {STAR extract}
     Frprtext,  {Freeport tax extract}
     Prog,
     DataModule,
     SalesExtractLogMaintenance,
     DocumentTypesAvailable,
     AutoLoadPicturesAndDocuments,
     ClearArrearsFlag,
     SeniorIncomeLimitsMaintenance,
     rpSales_And_RemovedExemptions,
     RecalculateSquareFootLivingArea,
(*     UpdateIndividualComputerSettingsForm, *)
     RPS160Extract,
     RPTopTaxPayers,
     MappingSetupOptions,
     ParcelAuditPrintForm,
     R3rdPartyNotificationReport,
     LoadArrearsFromTaxSystems,
     LoadArrearsFromTaxSystems_SQL,
     TaskList,
     TaskListReminder,
     UpdateNamesAndAddressesInSCASystems,
     GLawyerCodeUnit,
     GBoardDispositionCodesUnit,
     GBoardMemberCodesUnit,
     GPetitionerSubreasonCodesUnit,
     GBOARDenialReasonCodesUnit,
     RGrievanceAuditTrail,
     RGrievanceSummaryReport,
     RGBOARResultsReport,
     GrievanceBulkUpdate,
     RGrievanceLetters,
     RCertiorariSummaryReport,
     RSmallClaimsSummaryReport,
     rCertiorariCalender,
     GlblCnst, ParcelToolbar,
     MoveCooperativeRollValuesToMainRoll,
     RGrievance_SmallClaims_Certiorari_SummaryReport,
     RCertiorariHistoryReport,
     RestrictParcelsForSearcher,
     RGrievance_SmallClaims_Certiorari_NotesReport,
     rSmallClaimsCalender,
     AutoLoadPicturesAndDocumentsFromLoadingDock,
     UpdateVillageNamesAndAddresses_Export,
     UpdateVillageNamesAndAddresses_Import,
     ImportIVPStatusFromDTF,
     RPRemovedExemptions,
     RGeneralizedComparison,
     CreateApexSearcherFiles,
     TrackLoginsUnit,
     RCompareBuildingAndPASParcelIDs,
(*     RPictureReport,*)
     YorktownNameAddressExtract,
     Prorata_Calculation,
     RProrataLetters,
     RProrataInformation,
     Prorata_Move_Amounts_To_Parcels,
     RyeBillExtract,
     BroadcastAssessmentChange,
     ReduceBIEExemptions,
     ROverallBalance,
     RProrataWorksheets,
     Coop_TaxRoll,
     NassauCountyDiskLoadUnit,
     DataAccessUnit,
     Exemption_Remove,  {Remove non-renewed exemptions}
     Coop_ORPS_Extract,  {NYS ORPS coop extract}
     RValueComparison,   {Value comparison report}
     cdColdWarVeteranLimits,  {Cold war vet limits}
     cdSwisCodes,  {The new improved SWIS code maint.}
     mntCooperativeBuildings,
     extMiddleClassSTARRebate,  {Middle class STAR rebate extract}
     GSmallClaim_Cert_DispositionCodesUnit,
     Coop_TaxRateCopy,  {Copy tax rates from main roll to coop roll.}
     RExemptionImpactReport,
     RPictureAndPropertyCardReport,
     MoveCooperativeSTARValuesToMainRoll,
     RPrintParcelSummaryWithSketch,
     pAgriculture;
     (*Coop_AssessmentRoll;*)

{$R *.DFM}

const
  DisplayComparativesMenuTag = 5445;
  AuditReportMenuTag = 5440;
  CalculateRollTotalsMenuTag = 11010;

var
  FormCaptions : TStringList;
  ChildFormHeight,
  ChildFormWidth : Integer;

{============================================================================}
Procedure TMainPASForm.WMQueryEndSession(var Message : TWMQueryEndSession);

begin
  GlblApplicationIsClosing := True;
end;

{====================================================================}
Procedure TMainPASForm.PASExceptionHandler(Sender : TObject;
                                           E : Exception);

{This is the exception handler that will be assigned to the overall application.
 So, rather than a regular message dlg. being shown, we will display our own
 message and can customize it based on what type of exception it is.
 This exception handler is assigned to be the default application exception
 handler in the create of this form.}

const
  EDatasetNotInEditMode = 'Dataset not in edit or insert mode';
var
  TempStr : String;

begin
  TempStr := E.Message;

  If (E.Message = EDatasetNotInEditMode)
    then TempStr := 'Please click insert or edit on the navigator bar' + #13 +
                    'before making any changes to this information.';

    {FXX06291999-7: Filter out error code 84 and 85.}
    {FXX07201999-1: Actually, just filter out the 85 - filtering the 84 crashes the system.}

  If (Pos('85', TempStr) <> 0)
    then
      begin
        LogException(E.Message, E.ClassName, '', ExceptAddr);
        (*Abort;*)
      end
    else
      begin
        MessageDlg(TempStr, mtError, [mbOK], 0);

        LogException(E.Message, E.ClassName, '', ExceptAddr);

      end;

    {FXX03031998-7: If there is an exception while the cursor is an hourglass,
                    let's be sure to set it back.}

  Screen.ActiveForm.Cursor := crDefault;

end;  {PASExceptionHandler}

{====================================================================}
Procedure TMainPASForm.PreviewToolbarUserButtonClick(Sender: TObject);

begin
  PreviewMain.Show;
end;

{====================================================================}
Procedure TMainPASForm.FormPrintJobDraw(Sender: TObject;
                                        TheCanvas: TCanvas;
                                        PageIndex: Integer;
                                        TheRect: TRect;
                                        Area: TDrawArea;
                                        Target: TDrawTarget);

var
  Text : String;

begin
  with TheCanvas, TheRect do
    If (Area = daFooter)
      then
        begin
          Rectangle(Left, Top, Right, Bottom);

          Font.Size := 10;
          Font.Style := [fsBold];
          Text := 'Printed on ' + DateToStr(Date);
          TextOut((Left + (Right - Left - TextWidth(Text)) div 2),
                  (Bottom - 2 * TextHeight(Text)), Text);

        end;  {If (Area = daPage)}

end;  {FormPrintJobDraw}

{====================================================================}
Procedure TMainPASForm.PASMessageHandler(var Msg: TMsg;
                                         var Handled: Boolean);

{Intercept the print screen key and print.}
{CHG02271998-1: Allow print screen from all screens.}

{Note that the parcel screen printing must be done in ParcelTab itself
 because of the way the forms are shown - ParcelTabForm is always the
 active form. To do this, we will give a special tag to the ParcelTabForm
 exclusively so we can tell that that is the active form and don't process
 it in MainForm.  We cannot tell by the caption since the caption changes
 to reflect the mode and parcel ID.}

var
  I : Integer;
  TempFieldName, DataSourceName, TableName : String;
  Table : TTable;
  Form : TForm;

begin
    {FXX02091999-2: After a page up or down, the screen.activeform.tag equals
                    the tag of the child form displayed on the parcel tab notebook,
                    but the below instruction was supposed to filter out parcel
                    prints, and it was not.  So, we are also filtering out any screen
                    tag corresponding to a parcel page.}

  If ((Msg.Message = WM_KeyDown) and
      (Msg.wParam = VK_F3) and
      (Screen.ActiveForm.Tag <> ParcelTabFormTag) and
      ((Screen.ActiveForm.Tag < SummaryFormNumber) or
       (Screen.ActiveForm.Tag > PermitsFormNumber)))
    then
      begin
        LockWindowUpdate(Handle);

          {CHG01122004-2(2.8.2.3): Try another print screen component.}
          {CHG04182005-1(2.8.4.2): Each user can choose from any 3 print screen method.}

(*        case GlblPrintScreenMethod of
          psNormal : PrintScreen(Application, Screen.ActiveForm,
                                 0, 0, Screen.ActiveForm.Width,
                                 Screen.ActiveForm.Height);
          psExcellentPrinter : TFormPrint_PrintScreen(Application, Screen.ActiveForm);
          psPrintSuite :
            begin
              FormPrintJob.UpdateBitmap;
              PreviewToolbar.ButtonClick(btnPrint);
            end;

        end;  {case GlblPrintScreenMethod of} *)

        (*ShowMessage(Screen.ActiveForm.Caption); *)

        If GlblUsePrintSuitePrintScreen
          then
            begin
              FormPrintJob.UpdateBitmap;
              PreviewToolbar.ButtonClick(btnPrint);

            end
          else PrintScreen(Application, Screen.ActiveForm,
                           (*Screen.ActiveForm.Top,
                           Screen.ActiveForm.Left,*)
                           0,0,
                           Screen.ActiveForm.Width,
                           Screen.ActiveForm.Height);
        Handled := True;
        LockWindowUpdate(0);
      end;

    {FXX12101999-5: Alow them to blank out dates.}

  If ((Msg.Message = WM_KeyDown) and
      (Msg.WParam = VK_Delete))
    then
      begin
        If (Screen.ActiveControl is TMaskEdit)
          then
            with Screen.ActiveControl as TMaskEdit do
              begin
                Text := '  /  /    ';
                SelLength := 0;
                Msg.wParam := VK_Escape;
                Handled := True;

              end;  {with Screen.ActiveControl as TMaskEdit do}

        If ((Screen.ActiveControl is TDBEdit) or
            (Screen.ActiveControl is TDBGrid) or
            (Screen.ActiveControl is TwwDBGrid))
          then
            begin
              TableName := '';

              If (Screen.ActiveControl is TDBEdit)
                then
                  with Screen.ActiveControl as TDBEdit do
                    begin
                      TempFieldName := DataField;
                      DataSourceName := DataSource.Name;
                    end;

              If (Screen.ActiveControl is TDBGrid)
                then
                  with Screen.ActiveControl as TDBGrid do
                    begin
                      TempFieldName := SelectedField.FieldName;
                      DataSourceName := DataSource.Name;
                    end;

              If (Screen.ActiveControl is TwwDBGrid)
                then
                  with Screen.ActiveControl as TwwDBGrid do
                    begin
                      TempFieldName := SelectedField.FieldName;
                      DataSourceName := DataSource.Name;
                    end;

                  {Search for the data source so that we can find the table name.}

              If (Screen.ActiveForm.Tag = ParcelTabFormTag)
                then Form := GlblParcelTabChild
                else Form := Screen.ActiveForm;

              with Form do
                For I := 0 to (ComponentCount - 1) do
                  If (((Components[I] is TDataSource) or
                       (Components[I] is TwwDataSource)) and
                      (Components[I].Name = DataSourceName))
                    then TableName := TDataSource(Components[I]).DataSet.Name;

                {Now find the table and field.}

              Table := nil;
              with Form do
                For I := 0 to (ComponentCount - 1) do
                  If (Components[I].Name = TableName)
                    then Table := TTable(Components[I]);

              If ((Table <> nil) and
                  (Table.FieldByName(TempFieldName).EditMask = '!99/99/0000;1;_'))
                then
                  begin
                    If ((not Table.ReadOnly) and
                        (Table.State = dsBrowse))
                      then Table.Edit;

                    Table.FieldByName(TempFieldName).Text := '';
                    Handled := True;

                  end;  {If (Table.FieldByName(FieldName).EditMask = '!99/99/0000;1;_')}

            end;  {If ((Screen.ActiveControl is TDBEdit) or ...}

      end;  {If ((Msg.Message = WM_KeyDown) and ...}

    {CHG03232004-7(2.08): Link up help - do it by looking at the tag of the form - this
                          will be the main document for that page.}

  If ((Msg.Message = WM_KeyDown) and
      (Msg.wParam = VK_F1))
    then
      If (Screen.ActiveForm.Tag = 0)
        then MessageDlg('Sorry, there is currently no help available for this topic.',
                        mtError, [mbOk], 0)
        else OpenHelpDocument(HelpDocumentTable, Screen.ActiveForm.Tag);

end;  {PASMessageHandler}

{====================================================================}
Function FindNumOccurrences(TabName : String) : Integer;

{Look through the list of Tabs for this Tab name. Note that the Tabs
 may have multiple occurrences of the same name, but it will have the
 instance number at the end, i.e. "Property Maintenance 2".}

var
  I, NumOccurrences : Integer;

begin
  NumOccurrences := 0;

  with MainPASForm do
    For I := 0 to (TabSet.Tabs.Count - 1) do
         {find the occurenc of Tabname string in Tabs string list}
         {excluding any qualifier such as 1,2,3 or owner name, etc }
      If (Pos(TabName, TabSet.Tabs[I]) <> 0)
        then NumOccurrences := NumOccurrences + 1;

  Result := NumOccurrences;

end;  {FindNumOccurrences}

{====================================================================}
Procedure ShowOccurrence(TabName : String);

{Show the form corresponding to this Tab name. To do this, we will search
 through the list of Tabs for the index of this Tab name. Then we will look in
 the form caption list to get the caption of the form. Then we will loop through the
 MDI children list to find the child with this caption. Once we find it, we will
 show it.}

var
  I, Index : Integer;
  Found : Boolean;
  TempStr : String;

begin
  Index := -1;

  with MainPASForm do
    begin
       {First get the index of the Tab with this name.}

      For I := 0 to (TabSet.Tabs.Count - 1) do
        If (TabName = TabSet.Tabs[I])
          then Index := I;

       {Now search for the child form with the caption corresponding to this
        Tab.}

      I := 0;
      Found := False;
                {MDICHIldcount = prop of MDI form}
            {FXX10071998-1: Must select which form to go to - if let Delphi do it,
                            sometimes get out of synch.}

      while ((I < MDIChildCount) and
             (not Found) and
             (MDIChildren[I] <> nil)) do
        begin
                                       {SCA memory list}
          If (Pos(FormCaptions[Index], MDIChildren[I].Caption) <> 0)
            then
              begin
                TempStr := ActiveMDIChild.Caption;

                  {FXX04072009(2.17.1.17)[1262]: Refresh the GlblParcelMaintenance each time.}

                If (MDIChildren[I] is TParcelTabForm)
                  then GlblParcelMaintenance := MDIChildren[I]
                  else GlblParcelMaintenance := nil;

                  {Only show the form if it is not already the active form.}

                If ((Deblank(ActiveMDIChild.Caption) = '') or
                    (ActiveMDIChild.Caption <> MDIChildren[I].Caption))
                  then
                    begin
                        {Make sure that we hide the user info panel.}

                      If UserInfoPanel.Visible
                        then UserInfoPanel.Visible := False;

                      LockWindowUpdate(Handle);

                        {CHG05131999-2: Let people look up parcels from the parcel list.}
                        {Keep track of a parcel maint if it is active.}

                      MDIChildren[I].Show;
                      LockWindowUpdate(0);

                    end;  {If (ActiveMDIChild.Caption <> MDIChildren[I].Caption)}

                Found := True;

              end;  {If (MDIChildren[I].Caption = FormCaptions[Index])}

          I := I + 1;

        end;  {while ((I < MDIChildCount) and ...}

    end;  {with MainPASForm do}

end;  {ShowOccurrence}

{====================================================================}
Procedure AddTab(TabName, FormCaption : String);

{Add a new Tab at the end of the list. Also, we want to keep a list
 corresponding the Tab names to the caption names of the form that
 the Tab switches to. This way, we don't have to rely on the order of
 the MDI children.}

begin
  with MainPASForm do
    begin
      TabSet.Tabs.Add(TabName);
      FormCaptions.Add(FormCaption);
    end;

end;  {AddTab}

{====================================================================}
Procedure SelectTab(TabName : String);

{Based on the Tabname, highlight this Tab in the Tab set.}

var
  I : Integer;

begin
  with MainPASForm do
    For I := 0 to (TabSet.Tabs.Count - 1) do
      If (TabName = TabSet.Tabs[I])
           {setting the Tabset.TabIndex automatically hilites the Tab}
        then TabSet.TabIndex := I;

end;  {SelectTab}

{================================================================================}
{================================================================================}
{==================  These are the events for the main MDI form. ================}
{================================================================================}
Procedure TMainPASForm.SynchronizeTabsWithForms(Sender : TObject);

{If the proper Tab is not selected for the active form, then we want to select it.}
{This procedure is called whenever the active form is changed.
 This occurs at 5 different times:

   1. When the main MDI form is initially created, it is called (since it goes from
      no active form showing to having the main MDI form showing). In this case,
      since MDIChildCount is 0, we do nothing.

   2. Whenever a new form is created, since the new form shows itself immediatly.
      In this case there is also no action taken since the Form name (caption) for
      this new form is not in the list yet. This is what we want since each form
      takes care of selecting the proper Tab itself.

   3. Whenever switching forms while using the Tabs. In this case, the ActiveMDIChild
      is already the proper form for the Tab that they just clicked on, and hence
      no action is taken.  Look in the event for OnTabChange to follow why this is.

   4. Whenever the person switches between forms using some other method (i.e. Next
      from the Child system menu, a Window list, or by clicking on a visible portion of
      another screen. In this case, we look through the list of form name to find the
      ActiveMDIChild caption, and then we synchronize the Tabs.

   5. When a person closes a form. In this case, we will look for each caption name in
      the list of MDIChildren. When we find one that no longer exists, we will delete
      this Tab and the entry in the caption name list. We will know that a form has been
      deleted because a flag will have been set in the child form when it closed.}

var
  I, Index : Integer;
  Found : Boolean;
  TempStr : String;

begin

    {In order get around a problem in Delphi, I have created two global vars and
     put them in the Types unit - GlblClosingAForm and GlblClosingFormCaption which must
     be set in the FormClose for EVERY child window. The problem is that when a
     form is closed, then form is not freed up until after the OnActiveScreenChange
     occurs, so the number of MDIChildren still reflects the number of children before
     the deletion, so there is no way to tell that this event was issued because a form
     is closing.  Thus, the need for the global vars.  The exception to the update
     problem is when the last form is closed, the number of MDIChildren is updated
     before entering the OnActiveScreenChange event.}

   {skip Tab synch when running the search dialg. box, it is not a Tab form}

   {Note that we will also skip the synchronize page processing if we are presently
    changing tax years since the ChooseTaxYearForm takes care of clearing the tabs
    and FormCaptions itself when the MDI children are closed.}
   {FXX10231998-2: In order to fix the problem that Peggy has been having, we will make a universal
                   dialogboxshowing var and not worry about the individual kind.}

  If not GlblDialogBoxShowing
    then
      begin
        If GlblClosingAForm
          then
            begin  {Delete a Tab case.}
                {We know that a form is closing, and it must be the
                 form that the tab along the bottom is pointing to,
                 so we can just delete this tab and the corresponding
                 form caption.}

              Index := Tabset.TabIndex;

              If (Index <> -1)
                then
                  begin
                    FormCaptions.Delete(Index);
                    TabSet.Tabs.Delete(Index);
                  end;

                {If we are now down to no open children, then show the user info. panel.}
                {FXX10071998-1: Must select which form to go to - if let Delphi do it,
                                sometimes get out of synch.}

              If (TabSet.Tabs.Count = 0)
                then UserInfoPanel.Visible := True
                else
                  begin
                    GlblClosingAForm := False;
                    ShowOccurrence(TabSet.Tabs[TabSet.TabIndex]);
                  end;  {else of If (TabSet.Tabs.Count = 0)}

              GlblClosingAForm := False;

            end
          else  {Update the Tabs case.}
            If ((MDIChildCount > 0) and  {Case 1}
                (FormCaptions.Count > 0) and  {Case 2}
                (ActiveMDIChild.Caption <> FormCaptions[TabSet.TabIndex]))  {Case 3}
              then
                begin
                  TempStr := ActiveMDIChild.Caption;
                  Index := -1;
                  Found := False;

                     {First, look in the list of form captions for the caption of the
                      active form.}

                  For I := 0 to (FormCaptions.Count - 1) do
                    If (FormCaptions[I] = ActiveMDIChild.Caption)
                      then
                        begin
                          Index := I;
                          Found := True;
                        end;

                    {Only select the Tab if it was found - this is case 2}

                  If Found
                    then SelectTab(TabSet.Tabs[Index]);

                end;  {If (ActiveMDIChild.Caption <> FormCaptions[TabSet.TabIndex])}

          {FXX03042002-1: Fix the disappearing toolbar trick.}
          {FXX07312003-1(2.07h): Make sure not to try to bring toolbar to front if it is closed.}

        If ((MainPASForm.ActiveMDIChild is TParcelTabForm) and
             GlblParcelToolbarIsCreated and
            GlblUserWantsParcelToolbar and
            (not ParcelToolbarForm.Visible))
          then
            try
              ParcelToolbarForm.Visible := True;
            except
            end;

        If ( GlblParcelToolbarIsCreated and
            (not (MainPASForm.ActiveMDIChild is TParcelTabForm)) and
            (ParcelToolbarForm <> nil) and
            ParcelToolbarForm.Visible)
          then
            try
              ParcelToolbarForm.Visible := False;
            except
            end;

      end;  {If not GlblDialogBoxShowing}

end;  {SynchronizeTabsWithForms}

{================================================================================}
Procedure TMainPASForm.ApplicationActivate(Sender : TObject);

{CHG10211997-4: Make it so that progress panel does not prevent
                people from going to other apps.}

var
  I : Integer;

begin
  GlblApplicationIsMinimized := False;
  GlblApplicationIsActive := True;

    {FXX08231999-4: Throw this exception away - otherwise occasionally
                    get list index out of bounds.}

  For I := 0 to (Screen.FormCount - 1) do
    try
      If ((Screen.Forms[I].Caption = 'Progress') and
          ProgressDialog.Active)
        then Screen.Forms[I].Show;
    except
    end;

  If (GlblUserWantsParcelToolbar and
      (not Initializing) and
      (MainPASForm.ActiveMDIChild is TParcelTabForm))
    then
      begin
        ParcelToolbarForm.Visible := True;
        ParcelToolbarForm.BringToFront;
      end;

end;  {ApplicationActivate}

{================================================================================}
Procedure TMainPASForm.ApplicationDeactivate(Sender : TObject);

begin
  GlblApplicationIsActive := False;
end;

{================================================================================}
Procedure TMainPASForm.ApplicationMinimize(Sender : TObject);

begin
    {FXX12032004-1(2.8.1.1): If the application is minimized, make sure the parcel
                             toolbar is minimized.}

  If GlblUserWantsParcelToolbar
    then ParcelToolbarForm.Visible := False;

  GlblApplicationIsMinimized := True;

end;  {ApplicationMinimize}

{================================================================================}
Procedure TMainPASForm.OpenTablesInDataModuleTimerTimer(Sender: TObject);

{Open the tables in the data module on a timer so that they do not
 slow down the open.}

begin

  with PASDataModule do
    begin
      If ((Components[DataModuleComponentIndex] is TwwTable) and
          (Deblank(TwwTable(Components[DataModuleComponentIndex]).TableName) <> ''))
        then
        begin
          (*try *)
            LogTime('c:\trace.txt', 'Data module open - before ' + TwwTable(Components[DataModuleComponentIndex]).TableName);
            TwwTable(Components[DataModuleComponentIndex]).Open;
            LogTime('c:\trace.txt', 'Data module open - after ' + TwwTable(Components[DataModuleComponentIndex]).TableName);
        end;
          (*except
            SystemSupport(032, TwwTable(Components[DataModuleComponentIndex]),
                          'Error opening table ' +
                          TwwTable(Components[DataModuleComponentIndex]).Name +
                          ' in data module.', UnitName, GlblErrorDlgBox);
          end; *)

      DataModuleComponentIndex := DataModuleComponentIndex + 1;

      If (DataModuleComponentIndex > (ComponentCount - 1))
        then
        begin
          OpenTablesInDataModuleTimer.Enabled := False;
          LogTime('c:\trace.txt', 'Data module done');
        end;

    end;  {with PASDataModule do}

end;  {OpenTablesInDataModuleTimerTimer}

{================================================================================}
Procedure TMainPASForm.HelpDocumentMenuItemClick(Sender : TObject);

{CHG03232004-7(2.08): Link up help.}

begin
  OpenHelpDocument(HelpDocumentTable, TMenuItem(Sender).Tag);
end;  {HelpDocumentMenuItemClick}

{================================================================================}
Procedure TMainPASForm.AddHelpDocumentsMenuItems;

var
  Done, FirstTimeThrough : Boolean;
  NewMenuItem : TMenuItem;
  HelpGroup : String;

begin
  Done := False;
  FirstTimeThrough := True;

  HelpDocumentTable.First;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else HelpDocumentTable.Next;

    If HelpDocumentTable.EOF
      then Done := True;

    If not Done
      then
        begin
          NewMenuItem := TMenuItem.Create(Self);

          with HelpDocumentTable, NewMenuItem do
            begin
              Caption := Trim(FieldByName('Caption').Text);
              Tag := FieldByName('HelpIndex').AsInteger;
              OnClick := HelpDocumentMenuItemClick;

            end;  {with NewMenuItem, HelpDocumentTable do}

          HelpGroup := ANSIUpperCase(Trim(HelpDocumentTable.FieldByName('Category').Text));

          If (HelpGroup = hgReports)
            then ReportsHelpMenuItem.Add(NewMenuItem);

          If (HelpGroup = hgGeneralProcessing)
            then GeneralProcessingHelpMenuItem.Add(NewMenuItem);

        end;  {If not Done}

  until Done;

  HelpDocumentTable.IndexName := 'ByHelpIndex';

end;  {AddHelpDocumentsMenuItems}

{================================================================================}
Procedure TMainPASForm.ReleaseNotesMenuItemClick(Sender : TObject);

var
  ReleaseNotesDirectory : String;

begin
  ReleaseNotesDirectory := GlblDrive + ':' + GlblProgramDir + 'ReleaseNotes\';

  If FindKeyOld(ReleaseNotesTable, ['AutoIncrementID'], [IntToStr(TMenuItem(Sender).Tag)])
    then
      begin
        try
          ShellExecute(0, 'open',
                       PChar(ReleaseNotesDirectory + ReleaseNotesTable.FieldByName('DocumentName').Text),
                       nil, nil, SW_NORMAL);
        except
          MessageDlg('Unable to connect to Release Notes.',
                     mtError, [mbOk], 0);
        end;

      end
    else MessageDlg('Unable to locate those release notes.', mtError, [mbOK], 0);

end;  {ReleaseNotesMenuItemClick}

{================================================================================}
Procedure TMainPASForm.AddReleaseNotesMenuItems;

{CHG04032004-1(2.08): Add links to release notes under the help menu.}

var
  Done, FirstTimeThrough : Boolean;
  NewSubreleaseMenuItem, NewReleaseMenuItem : TMenuItem;
  MainVersionList : TStringList;

begin
  NewReleaseMenuItem := nil;
  MainVersionList := TStringList.Create;
  Done := False;
  FirstTimeThrough := True;

  ReleaseNotesTable.First;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else ReleaseNotesTable.Next;

    If ReleaseNotesTable.EOF
      then Done := True;

    If not Done
      then
        begin
            {Put all subreleases under the main release number.}

          with ReleaseNotesTable do
            If (MainVersionList.IndexOf(FieldByName('MainVersionNumber').Text) = -1)
              then
                begin
                  MainVersionList.Add(FieldByName('MainVersionNumber').Text);
                  NewReleaseMenuItem := TMenuItem.Create(Self);
                  NewReleaseMenuItem.Caption := FieldByName('MainVersionNumber').Text;
                  ReleaseNotesMenuItem.Add(NewReleaseMenuItem);

                end;  {with ReleaseNotesTable do}

          NewSubreleaseMenuItem := TMenuItem.Create(Self);

            {FXX07202004-1(2.08): Need a unique key since the Order is only the order within a version.}

          with ReleaseNotesTable, NewSubreleaseMenuItem do
            begin
              Caption := FieldByName('Caption').Text + ' (' +
                         FieldByName('ReleaseDate').Text + ')';
              Tag := FieldByName('AutoIncrementID').AsInteger;
              OnClick := ReleaseNotesMenuItemClick;

            end;  {with NewSubreleaseMenuItem, ReleaseNotesTable do}

          If (NewReleaseMenuItem <> nil)
            then NewReleaseMenuItem.Add(NewSubreleaseMenuItem);

        end;  {If not Done}

  until Done;

  ReleaseNotesTable.IndexName := 'ByAutoIncrementID';

end;  {AddReleaseNotesMenuItems}

{================================================================================}
Procedure TMainPASForm.FormCreate(Sender: TObject);

var
  Quit : Boolean;
  AssessmentYearControlTable : TTable;
  I, ItemCount : Integer;
  MenuList : TList;

begin
  GlblCurrentCommaDelimitedField := 0;
  GlblApplicationIsMinimized := False;
  Initializing := True;
  OpenFiles := True;

  For I := 1 to ParamCount do
    If (Pos('PREVENTOPEN', ParamStr(I)) > 0)
      then OpenFiles := False;

(*  MessageDlg('Form Create.', mtInformation, [mbOK], 0); *)
    {FXX03262001-1: Make sure the icon is loaded.}

  GlblApplicationIsClosing := False;
  GlblApplicationIsTerminatingToDoBackup := False;
  InitGlblLastLocateInfoRec(GlblLastLocateInfoRec);

    {FXX10231998-2: In order to fix the problem that Peggy has been having, we will make a universal
                    dialogboxshowing var and not worry about the individual kind.}

  GlblDialogBoxShowing := False;

    {Replace the default exception handler with our own.}

  Application.OnException := PASExceptionHandler;

  Application.OnMessage := PASMessageHandler;

  UnitName := 'MAINFORM.PAS';
  GlblChildWindowCreateFailed := False;
  GlblApplicationIsClosing := False;
  GlblChangingTaxYear := False;
  GlblTaxYearFlg := ' ';

    {FXX05181999-2: Trace the add of the system exemption, but only if the
                    calling job requires it - i.e. running exemptions recalc,
                    since other jobs automatically insert a trace rec for the
                    system exemption.}

  GlblInsertSystemExemptionTrace := False;

    {Initialize the global error dialog box.}

  GlblErrorDlgBox := TSCAErrorDialogBox.Create(Self);
  GlblErrorDlgBox.ShowSCAPhoneNumbers := True;

  GlblLastSwisSBLKey := '';
  GlblLastLocateKey := 1;

(*  try *)
    SysrecTable.Open;
(*  except *)
      {If they can not even open the system record, there are very
       serious problems. They probably are not connected to the
       network or they don't have rights because they are not logged
       in with the correct ID. So, we will tell them and terminate
       the application.}

(*    MessageDlg('Cannot access the database.' +
               'Please check the network drive mapping and database alias.',
               mtError, [mbOK], 0);
    LogException('', '', 'BTrieve error: ' + IntToStr(GetBtrieveError(SysRecTable)), nil);
    Application.Terminate;
  end; *)

    {Set up the date and time formats.}

  LongTimeFormat := 'h:mm AMPM';
  ShortDateFormat := 'm/d/yyyy';
  (*DateSeparator := '\';*)

  FormCaptions := TStringList.Create;

    {Set up the dimensions for child forms.}

  ChildFormWidth := ClientWidth;
  ChildFormHeight := ClientHeight - TabSet.Height;

    {In case they switch forms using a method other than the Tabs or the
     menus, we want to make sure that we keep the Tabs in sync. This could happen
     if they do Ctrl+F6 on a form (Next on the System menu).}

     {this assigns the SynchronizeTabs... as event hndlr of Screen}
  Screen.OnActiveFormChange := SynchronizeTabsWithForms;

    {CHG10211997-4: Make it so that progress panel does not prevent
                    people from going to other apps.}

  Application.OnActivate := ApplicationActivate;
  Application.OnDeactivate := ApplicationDeactivate;
  Application.OnMinimize := ApplicationMinimize;

  try
    SysrecTable.First;
  except
    SystemSupport(001, SysRecTable, 'Error getting system record.',
                  UnitName, GlblErrorDlgBox);
    Application.Terminate;
  end;

    {FXX02091999-2: Move the setting of global system vars to
                    one proc.}

  SetGlobalSystemVariables(SysRecTable);

  GlblMunicipalityTypeName := GetMunicipalityTypeName(GlblMunicipalityType);

    {CHG07192002-1: Accomodate a seperate coop roll.}
    {FXX01282004-2(2.08): Change to the program directory and drive before loading the icon.}

  try
    ChDir(GlblDrive + ':' + GlblProgramDir);
    Application.Icon.LoadFromFile(GlblIconFileName);
  except
  end;                                              

  try
    MainPASForm.Caption := GlblCaption;
  except
    MainPASForm.Caption := 'PAS';
  end;

    {FXX07292002-1: Make it so that they can start up coop roll and
                    regular PAS.  To do this, if the caption is
                    different than 'PAS', set the Application.Title
                    to be that caption.  Otherwise, just leave it
                    as 'Property Assessment System'.  Note that
                    the only time the caption will be different than
                    'PAS' is if this is a coop roll.}

  If (MainPASForm.Caption <> 'PAS')
    then Application.Title := MainPASForm.Caption;

    {Even if this municipality uses maps, if it is not installed on this
     computer, don't show maps.}

  If not MapObjectsInstalled
    then GlblUsesMaps := False;

  If not GlblUsesMaps
    then Maps1.Enabled := False;

  mnitm_Coops.Visible := GlblIsCoopRoll;

    {If this is the coop roll, don't show the tax billing submenu at all.}
    
  If mnitm_Coops.Visible
    then mniTaxBilling.Visible := False;

    {CHG04102003-5(2.07): Restrict parcels for the searcher.}

  If GlblUseRestrictSearcherParcelsFeature
    then RestrictParcelsViewedbySearcherMenuItem.Visible := True;

    {CHG11212003-1(2.07k): Menu options for import \ export of village names and addresses.}

  If GlblUsesVillage_Import_Export
    then
      begin
        SendNameAddressUpdatetoVillages.Visible := True;
        ImportNamesandAddressesfromTown.Visible := True;
      end;  {If GlblUsesVillage_Import_Export}

    {CHG03132004-4(2.08): Create jpegs of sketch files.}

  If GlblUsesSketches
    then CreateSketchesforSearcherMenuItem.Visible := True;

    {CHG03232004-6(2.08): Showing the generalized comparison report is a system option.}

  If not GlblUseGeneralizedComparisonReport
    then GeneralizedComparisonMenuItem.Visible := False;

    {CHG10122000-1: In order to fix the print screen, I had to use Multi Image
                    and there are 2 DLLs - CRDE2000.DLL and ISP2000.DLL which
                    we will put in the application directory.  The following
                    variable allows us to put the DLLs where we want.}

  DLLPathName := ExpandPASPath(GlblProgramDir);
(*  MessageDlg('DLL Path = ' + DLLPathName, mtInformation, [mbOK], 0);*)

    {CHG09071999-3: Allow selection of what warning messages are displayed.}

  WarningsDisplayedTable.Open;
  SetGlobalWarningOptions(WarningsDisplayedTable);
  WarningsDisplayedTable.Close;

    {CHG09071999-1: Allow add\parcel inactivate\reactivate to be moved below
                    line.}

  If SysRecTable.FieldByName('MoveInactReact').AsBoolean
    then
      begin
        MenuList := TList.Create;

        with ParcelsSubMenu do
          begin
            For I := 0 to (Count - 1) do
              MenuList.Add(Items[I]);

            ItemCount := Count - 1;

            For I := ItemCount downto 0 do
              Remove(Items[I]);

            Add(TMenuItem(MenuList[2]));
            Add(TMenuItem(MenuList[4]));
            Add(TMenuItem(MenuList[5]));
            Add(TMenuItem(MenuList[0]));
            Add(TMenuItem(MenuList[1]));
            Add(TMenuItem(MenuList[3]));
            Add(TMenuItem(MenuList[6]));
            Add(TMenuItem(MenuList[7]));
            Add(TMenuItem(MenuList[8]));

          end;  {with ParcelsSubMenu do}

        MenuList.Free;

      end;  {If SysRecTable.FieldByName('MoveInactReact').AsBoolean}

  VersionLabel.Caption := 'Version ' + {GetFileVersion;} GlblVersion;

    {CHG06062003-1(2.07c): Add the date and time of the EXE to the version.}

  try
(*    FileHandle := FileOpen(GlblProgramDir + 'PAS32.EXE', 0);
    FileDate := DateToStr(FileDateToDateTime(FileGetDate(FileHandle)));
    FileTime := TimeToStr(FileDateToDateTime(FileGetDate(FileHandle)));
    FileClose(FileHandle);*)

    VersionLabel.Caption := VersionLabel.Caption(* + '  ' + FileDate + '-' + FileTime*);
  except
  end;

(*  VersionLabel.Left := TitleLabel.Left + (TitleLabel.Width - VersionLabel.Width) DIV 2;*)

    {CHG01302002-2: Change building permit link to allow link to all systems.}

  If (GlblBuildingSystemLinkType = bldNone)
    then BuildingPermitReport.Visible := False;

  with MunicipalityLabel do
    begin
      Caption := GetMunicipalityName;

      Left := (UserInfoPanel.Width - Width) DIV 2;

      Visible := True;

    end;  {with MunicipalityLabel do}

  MunicipalityLabel.Visible := True;

    {Now set the error file directory based on the system
     record.}

  GlblErrorDlgBox.ErrorFileDirectory := GlblDrive + ':' + GlblErrorFileDir;

  try
    GlblTraceTable := TTable.Create(Self);

    OpenTableForProcessingType(GlblTraceTable, 'AuditTable',
                               GlblProcessingType, Quit);
  except
    NonBtrvSystemSupport(002, 999, 'Error creating trace table.', UnitName, GlblErrorDlgBox);
    Application.Terminate;
  end;

    {CHG02122000-3: Insert a name\addr audit change record.}

  try
    GlblNameAddressTraceTable := TTable.Create(Self);

    OpenTableForProcessingType(GlblNameAddressTraceTable, 'AuditNameAddress',
                               GlblProcessingType, Quit);
    GlblNameAddressTraceTable.IndexName := 'BySwisSBLKey_Date_Time';
  except
    NonBtrvSystemSupport(003, 999, 'Error creating name \ address trace table.', UnitName, GlblErrorDlgBox);
    Application.Terminate;
  end;

    {FXX11101997-2: Only store traces for fields listed in the
                    screen label file, since these are all we care about.}

  try
    GlblScreenLabelTable := TTable.Create(Self);

    OpenTableForProcessingType(GlblScreenLabelTable, 'ScreenAndLabelNames',
                               GlblProcessingType, Quit);
    GlblScreenLabelTable.IndexName := 'BYSCREENNAME_LABELNAME';
  except
    NonBtrvSystemSupport(003, 999, 'Error creating Screen Lable table.', UnitName, GlblErrorDlgBox);
    Application.Terminate;
  end;
  (*MessageDlg('Screen Label table created.', mtInformation, [mbOK], 0);*)

    {CHG09251998-1: Default change together.}

  If GlblModifyBothYearsCheckedInTY
    then ChangeThisYearandNextYearTogether.Checked := True;

  SysRecTable.Close;  {Close right away so hopefully don't get in use errors when all go in at once.}

    {FXX02121998-1: Open the assessment year control table for ThisYear and
                    NextYear and put the STAR variables into global variables
                    so that we don't have to open the assessment table
                    each time to calculate STAR.  This was causing a
                    computer hang sometimes possibly due to going too deep
                    in the call stack.}

  AssessmentYearControlTable := TTable.Create(nil);
  OpenTableForProcessingType(AssessmentYearControlTable, AssessmentYearControlTableName,
                             ThisYear, Quit);

(*  with AssessmentYearControlTable do
    begin
      GlblThisYearBasicSalesDifferential := FieldByName('ResSalePriceDiffFact').AsFloat;;
      GlblThisYearBasicLimit := FieldByName('BasicSTARAmount').AsFloat;
      GlblThisYearEnhancedSalesDifferential := FieldByName('EnhSalePriceDiffFact').AsFloat;
      GlblThisYearEnhancedLimit := FieldByName('EnhancedSTARAmount').AsFloat;

    end;  {with AssessmentYearControlTable do}

  OpenTableForProcessingType(AssessmentYearControlTable, AssessmentYearControlTableName,
                             NextYear, Quit);

  with AssessmentYearControlTable do
    begin
      GlblNextYearBasicSalesDifferential := FieldByName('ResSalePriceDiffFact').AsFloat;;
      GlblNextYearBasicLimit := FieldByName('BasicSTARAmount').AsFloat;
      GlblNextYearEnhancedSalesDifferential := FieldByName('EnhSalePriceDiffFact').AsFloat;
      GlblNextYearEnhancedLimit := FieldByName('EnhancedSTARAmount').AsFloat;

    end;  {with AssessmentYearControlTable do} *)

    {FXX01142000-2: Don't ask if want to change assessment if prior to final roll.}

  try
    GlblFinalRollDate := AssessmentYearControlTable.FieldByName('FinalRollDate').AsDateTime;
  except
  end;

  AssessmentYearControlTable.Close;

    {FXX08142002-1: No free was being done on the assessment year control table.}

  AssessmentYearControlTable.Free;

    {CHG12282001-1: Allow for autolaunch of roll totals calculation.}

  CalculateRollTotals := False;

  For I := 1 to ParamCount do
    If (Pos('CALCULATE', ParamStr(I)) > 0)
      then CalculateRollTotals := True;

    {CHG04032004-2(2.08): Make the help menu driven by a table.}

  with HelpDocumentTable do
    try
      TableName := HelpDocumentTableName;
      Open;
      AddHelpDocumentsMenuItems;
    except
      GeneralProcessingHelpMenuItem.Visible := False;
      ReportsHelpMenuItem.Visible := False;
    end;

    {CHG04032004-1(2.08): Add links to release notes under the help menu.}

  with ReleaseNotesTable do
    try
      TableName := ReleaseNotesTableName;
      Open;
      AddReleaseNotesMenuItems;
    except
      ReleaseNotesLineMenuItem.Visible := False;
      ReleaseNotesMenuItem.Visible := False;
    end;

    {CHG11302004-1(2.8.1.1): Allow for forced system shut down.}

(*  If GlblAllowSystemShutdown
    then
      begin
        SystemShutdownTable.TableName := SystemShutdownTableName;
        SystemShutdownTable.Open;
        SystemShutdownTimer.Enabled := True;

      end;  {If GlblAllowSystemShutdown} *)

    {CHG06092010-1(2.26.1)[I7395]: Suppress the IVP option.}
    
  If glblSuppressIVP
  then mnuitmImportSeniorEnhancedSTARIVPStatus.Visible := False;

  Initializing := False;
  Timer.Enabled := True;

end;  {FormCreate}

{==================================================================}
Procedure TMainPASForm.FormActivate(Sender: TObject);

begin
  If (ChooseTaxYearForm.Showing and
      (not ChooseTaxYearForm.Active))
    then ChooseTaxYearForm.BringToFront;

  If (LoginDlg.Showing and
      (not LoginDlg.Active))
    then LoginDlg.BringToFront;

end;  {FormActivate}

{================================================================================}
Procedure TMainPASForm.DetermineAvailableMenuOptions;

{Based on the security level, what menu options are available
 to this user?}

var
  I : Integer;

begin
  mnitmParcelAdd.Enabled := True;
  mnitmInactivateParcel.Enabled := True;
  mnitmModifyParcel.Enabled := True;
  mnitmReactivateParcel.Enabled := True;
  mnitmKeyChange.Enabled := True;

  For I := 0 to (ComponentCount - 1) do
    If (Components[I] is TMenuItem)
      then
        with Components[I] as TMenuItem do
          If (Tag > 0)
            then
              begin
                try
                  FindKeyOld(MenuSecurityTable, ['MenuID'], [IntToStr(Tag)]);
                except
                  SystemSupport(004, MenuSecurityTable, 'Error getting menu security record.',
                                UnitName, GlblErrorDlgBox);
                end;

                  {FXX01202000-4: Relogging in with higher access did not work
                                  because items disabled stayed disabled.}

                Enabled := True;

                  {Now, if the person does not have a high enough security
                   level to have read\write access to this item (i.e.
                   their security level is less than what is required for
                   this item), let's see if it should be disabled entirely.
                   When can tell by looking at the DisableIfUnderAccess
                   field in the MenuSecurityTable. If it is not disabled, they
                   will have read only access to this item.}

                If ((MenuSecurityTable.FieldByName('SecurityLevel').AsInteger > GlblSecurityLevel) and
                    MenuSecurityTable.FieldByName('DisableIfUnderAccess').AsBoolean)
                  then Enabled := False;

                  {CHG01142000-1: All optional menu items will be in the main form,
                                  but we will check a table to see if they actually
                                  get installed.}

                If (FindKeyOld(OptionalItemsTable, ['MenuTag'], [IntToStr(Tag)]) and
                    (not OptionalItemsTable.FieldByName('Active').AsBoolean))
                  then Visible := False;

              end;  {If (Tag > 0)}

    {FXX02101999-6: Take off the Mt. Vernon extract for other municipalities.}

  If ((RTrim(GlblMunicipalityName) <> 'MT. VERNON') and
      (RTrim(GlblMunicipalityName) <> 'MT VERNON'))
    then MtVernonTaxExtractFile1.Visible := False;

  Maps1.Visible := GlblUsesMaps;

    {See if we should allow the user to print an audit trail or see comps from
     the toolbar or by function key.}

  FindKeyOld(MenuSecurityTable, ['MenuID'], [IntToStr(DisplayComparativesMenuTag)]);
  GlblUserCanSeeComparables := (GlblSecurityLevel >= MenuSecurityTable.FieldByName('SecurityLevel').AsInteger);

  FindKeyOld(MenuSecurityTable, ['MenuID'], [IntToStr(AuditReportMenuTag)]);
  GlblUserCanRunAudits := (GlblSecurityLevel >= MenuSecurityTable.FieldByName('SecurityLevel').AsInteger);

    {FXX05012002-1: Make sure that we don't show the calculate roll totals button if
                    they can't recalculate totals.}

  FindKeyOld(MenuSecurityTable, ['MenuID'], [IntToStr(CalculateRollTotalsMenuTag)]);
  GlblCanCalculateRollTotals := (GlblSecurityLevel >= MenuSecurityTable.FieldByName('SecurityLevel').AsInteger);

  If (_Compare(GlblThisYearAccess, raReadOnly, coEqual) and
      _Compare(GlblProcessingType, ThisYear, coEqual))
    then
      begin
        mnitmParcelAdd.Enabled := False;
        mnitmInactivateParcel.Enabled := False;
        mnitmModifyParcel.Enabled := False;
        mnitmReactivateParcel.Enabled := False;
        mnitmKeyChange.Enabled := False;

      end;  {If (_Compare(GlblThisYearAccess, raReadOnly, coEqual) and ...}

  If not GlblUserCanViewPermits
    then BuildingPermitReport.Visible := False;

    {CHG05062010(2.24.2.1)[F1053]: Limit the bill print menu options to only the applicable ones.}

  If (_Compare(glblBillPrintMenuItem1, 0, coGreaterThan) or
      _Compare(glblBillPrintMenuItem2, 0, coGreaterThan))
  then mnuitmBillSeparator.Visible := True;
    
  For I := 0 to (ComponentCount - 1) do
    If ((Components[I] is TMenuItem) and
        _Compare(TMenuItem(Components[I]).Tag, 6040, coGreaterThanOrEqual) and
        _Compare(TMenuItem(Components[I]).Tag, 6999, coLessThanOrEqual))
    then TMenuItem(Components[I]).Visible := (_Compare(TMenuItem(Components[I]).Tag, glblBillPrintMenuItem1, coEqual) or
                                              _Compare(TMenuItem(Components[I]).Tag, glblBillPrintMenuItem2, coEqual));

end;  {DetermineAvailableMenuOptions}

{=======================================================================}
Function NumNotesOverdue(NotesTable : TTable) : Integer;

var
  Done, FirstTimeThrough : Boolean;

begin
  (*NotesTable.IndexDefs.Update;

  If _Compare(NotesTable.IndexDefs.Count, 0, coEqual)
    then _SetFilter(NotesTable, 'UserResponsible = ' + FormatFilterString(GlblUserName))
    else *)


  NotesTable.IndexName := 'BYUSER_DUEDATE_SBL_NOTENUM';
  _SetRange(NotesTable, [GlblUserName, '1/1/1990', '', ''], [GlblUserName, '1/1/2500', '', ''], '', []);

  NotesTable.First;

  Done := False;
  FirstTimeThrough := True;
  Result := 0;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else NotesTable.Next;

    If NotesTable.EOF
      then Done := True;

    with NotesTable do
      If ((Trim(FieldByName('NoteTypeCode').Text) = 'T') and
          FieldByName('NoteOpen').AsBoolean and
          (FieldByName('DueDate').AsDateTime <= Date))
        then Result := Result + 1;

  until Done;

end;  {NumNotesOverdue}

{======================================================================}
Function NumTaskListItemsOverdue(TaskListTable : TTable) : Integer;

{CHG01302002-3: Task list reminders.}

var
  Done, FirstTimeThrough : Boolean;

begin
  TaskListTable.Open;
  TaskListTable.First;

  Done := False;
  FirstTimeThrough := True;
  Result := 0;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else TaskListTable.Next;

    If TaskListTable.EOF
      then Done := True;

    with TaskListTable do
      If ((not Done) and
          (not FieldByName('Done').AsBoolean) and
          (FieldByName('ReminderDate').AsDateTime <= Date))
        then Result := Result + 1;

  until Done;

  TaskListTable.Close;

end;  {NumTaskListItemsOverdue}

{=======================================================================}
Function UserGetsTaskReminder(TaskUserTable : TTable;
                              UserName : String) : Boolean;

{FXX04062003-1(2.06r): Need to make sure only the correct users get the task
                       list reminder.}

begin
  Result := FindKeyOld(TaskUserTable, ['UserName'], [UserName]);
end;  {UserGetsTaskReminder}

{=======================================================================}
Procedure TMainPASForm.LimitSearcherOptions;

{CHG11071997-2: Limit menu options for searcher.}
{FXX01211999-1: Allow them to change assessment years.}

var
  I : Integer;

begin
  If GlblUserIsSearcher
    then
      For I := 0 to (ComponentCount - 1) do
        If (Components[I] is TMenuItem)
          then
            with Components[I] as TMenuItem do
              If (Name <> 'SelectTaxRollYear1')
                then Enabled := False;

  ParcelsSubMenu.Enabled := True;
  ViewaParcel.Enabled := True;
  OptionsSubMenu.Enabled := True;
  SelectTaxRollYear1.Enabled := True;

end;  {LimitSearcherOptions}

{=======================================================================}
Procedure TMainPASForm.TimerTimer(Sender: TObject);

var
  Cancelled, Found : Boolean;
  I : Integer;

begin
  Timer.Enabled := False;

    {CHG12282001-1: Allow for autolaunch of roll totals calculation.}

  If CalculateRollTotals
    then
      begin
        CreateRollTotals(ThisYear, GlblThisYear,
                         ProgressDialog, Self, False, False);
        CreateRollTotals(NextYear, GlblNextYear,
                         ProgressDialog, Self, False, False);
        Application.Terminate;
      end
    else
      begin
        Cancelled := False;

        try
          UserProfileTable.Open;
        except
          SystemSupport(005, UserProfileTable, 'Error opening user profile table.',
                        UnitName, GlblErrorDlgBox);
          Application.Terminate;
        end;

          {Now bring up the login dialog box. If they do not login successfully,
           terminate the application.}

        DataModuleComponentIndex := 0;

        If OpenFiles
          then OpenTablesInDataModuleTimer.Enabled := True;

        If LoginDlg.Execute
          then
            begin
              SetGlobalUserDefaults(UserProfileTable);
              TrackUserLogin(GlblUserName, lgIn);

                {CHG01112006-2(2.9.4.9): Add the feature to broadcast AV changes
                                         by % change, but only for supervisor.}

(*              If UserIsSupervisor(GlblUserName)
                then BroadcastAssessmentChangesMenuItem.Enabled := True; *)
            end
          else
            begin
              Application.Terminate;
              Cancelled := True;
            end;  {else of If LoginDlg.Execute}

        If not Cancelled
          then
            begin
                {Now show the tax year selection form and set appropriately.}
                {CHG11101997-1: Allow user to set dual processing.}

              ChooseTaxYearForm.CurrentTaxYearLabel := CurrentTaxYearLabel;
              ChooseTaxYearForm.MainFormTabSet := TabSet;
              ChooseTaxYearForm.FormCaptions := FormCaptions;
              ChooseTaxYearForm.ChangeThisYearandNextYearTogether := ChangeThisYearandNextYearTogether;
              ChooseTaxYearForm.ShowModal;

              Cancelled := (ChooseTaxYearForm.CloseResult = idCancel);

                {If they hit the cancel button, then we will close the
                 application.}

              If Cancelled
                then Application.Terminate;

                {FXX03191999-5: Setup the parcel grid at this point.}

              ParcelListDialog.ClearParcelGrid(True);

              GlblDisplaySystemExemptionConfirmation := True;

            end;  {If not Cancelled}

        If not Cancelled
          then
            begin
              If not GlblUsesProrata
                then ProrataMenuItem.Visible := False;

                {FXX01032003-1: These need to be after the user options are set by login.}

              If ((not GlblUsesGrievances) or
                  GlblUserIsSearcher)
                then
                  begin
                    GrievanceTables.Visible := False;
                    GrievanceReports.Visible := False;
                    GrievanceBulkUpdate1.Visible := False;
                    CertiorariTables.Visible := False;
                    CertiorariReports.Visible := False;
                    SmallClaimsReports.Visible := False;
                    OverallGrievanceSmallClaimsCertiorariReport.Visible := False;

                  end;  {If ((not GlblUsesGrievances) or ...}

                {CHG12202002-1: Additional security for certs.}

              If not GlblCanSeeCertiorari
                then
                  begin
                    CertiorariTables.Visible := False;
                    CertiorariReports.Visible := False;
                    OverallGrievanceSmallClaimsCertiorariReport.Visible := False;
                  end;

              UserIDLabel.Caption := 'ID = ' + GlblUserName;
              UserIDLabel.Left := (UserInfoPanel.Width - UserIDLabel.Width) DIV 2;
              UserIDLabel.Visible := True;
              CurrentTaxYearLabel.Caption := GetTaxYrLbl;
              CurrentTaxYearLabel.Visible := True;
              DateLabel.Caption := DateToStr(Date);
              DateLabel.Visible := True;

                {Now open the menu security table and determine what menu options
                 are available to this user.}

              try
                MenuSecurityTable.Open;
                OptionalItemsTable.Open;
              except
                SystemSupport(006, MenuSecurityTable, 'Error opening menu security table.',
                              UnitName, GlblErrorDlgBox);
                Application.Terminate;
              end;

              DetermineAvailableMenuOptions;

                {CHG11071997-2: Limit menu options for searcher.}

              LimitSearcherOptions;

              If GlblStartPASMaximized
                then WindowState := wsMaximized;

                {CHG11172003-2(2.07k): Add tickler feature for cert notes.}

              If GlblCanSeeCertNotes
                then
                  try
                    CertiorariNotesTable.TableName := 'gcnotesrec';
                    CertiorariNotesTable.Open;
                  except
                  end
                else CertiorariNotesReportMenuItem.Visible := False;

                {CHG10131997-3: Add the notes reminder feature.}

              try
                SmallClaimsNotesTable.TableName := 'gscnotesrec';
                SmallClaimsNotesTable.Open;
              except
              end;

                {CHG11132013(MPT): Add Small Claims Notes to reminder dialogue.}

                {Now open the menu security table and determine what menu options
                 are available to this user.}

              try
                NotesTable.Open;
              except
                SystemSupport(007, NotesTable, 'Error opening notes table.',
                              UnitName, GlblErrorDlgBox);
                Application.Terminate;
              end;

                {Now see which notes are due today or earlier.}

              If ((NumNotesOverdue(NotesTable) > 0) or
                  (GlblCanSeeCertNotes and
                   (NumNotesOverdue(CertiorariNotesTable) > 0)) or
                   (NumNotesOverdue(SmallClaimsNotesTable) > 0))
                then
                  try
                    NotesReminderDialog := TNotesReminderDialog.Create(nil);
                    NotesReminderDialog.ShowModal;
                  finally
                    NotesReminderDialog.Free;
                  end;

                {CHG04132007-1(2.11.1.24): Name\addr only users should get access to the
                                           Name \ address utility.}

              If GlblNameAddressUpdateOnly
                then mi_UpdateNamesandAddressesinTaxSystems.Visible := True;

                {CHG01302002-3: Task list reminders.}
                {FXX04062003-1(2.06r): Need to make sure only the correct users get the task
                                       list reminder.}

              try
                TaskUserTable.Open;

                If ((NumTaskListItemsOverdue(TaskListTable) > 0) and
                    UserGetsTaskReminder(TaskUserTable, GlblUserName))
                  then
                    try
                      TaskListReminderDialog := TTaskListReminderDialog.Create(nil);
                      TaskListReminderDialog.ShowModal;
                    finally
                      TaskListReminderDialog.Free;
                    end;

                TaskUserTable.Close;
              except
              end;

            end;  {If not Cancelled}

          {CHG10131998-1: Check for new printers.}

        If not Cancelled
          then
            begin
              InstalledPrinterTable.Open;

              For I := 0 to (Printer.Printers.Count - 1) do
                begin
                  Found := FindKeyOld(InstalledPrinterTable,
                                      ['PrinterName'],
                                      [Trim(Printer.Printers[I])]);

                  If not Found
                    then
                      begin
(*                        Laser := (MessageDlg('PAS detected a new printer or printer driver.' + #13 + #13 +
                                             'New Printer: ' + Printer.Printers[I] + #13 + #13 +
                                             'Is this printer a laser printer?', mtConfirmation,
                                             [mbYes, mbNo], 0) = mrYes); *)

                        with InstalledPrinterTable do
                          try
                            Insert;
                            FieldByName('PrinterName').Text := Printer.Printers[I];
                            FieldByName('Laser').AsBoolean := True;
                            Post;
                          except
                              {FXX03012002-1: Don't show an error if this post fails - it
                                              is probably a searcher with read only access.}
                            Cancel;
(*                            SystemSupport(008, InstalledPrinterTable, 'Error adding rec to installed printer table.',
                                          UnitName, GlblErrorDlgBox);*)
                          end;

                      end;  {If not Found}

                end;  {For I := 0 to (Printer.Printers.Count - 1) do}

              InstalledPrinterTable.Close;

            end;  {If not Cancelled}

          {FXX05021999-1: Place on page where to start address for windowed
                          envelope.}

        If not Cancelled
          then
            begin
              AssessorsOfficeTable.Open;
              SetGlobalAssessorsOfficeVariables(AssessorsOfficeTable);

            end;  {If not Cancelled}

          {CHG04282005-1(2.8.4.3)[2114]: Create autoload for sketches.}

        If ((not Cancelled) and
            GlblUsesSketches)
          then
            try
              PASDataModule.SketchTable.TableName := SketchTableName;
              PASDataModule.SketchTable.Open;
            except
            end;

          {CHG05131999-2: Let people look up parcels from the parcel list.}

        GlblLocateParcelFromList := False;

      end;  {If not CalculateRollTotals}

  ParcelToolbarTimer.Enabled := True;

end;  {TimerTimer}

{=======================================================================}
Procedure TMainPASForm.ParcelToolbarTimerTimer(Sender: TObject);

{FXX05092002-1: The toolbar was disappearing again!}

begin
    {FXX07312003-1(2.07h): Make sure not to try to bring toolbar to front if it is closed.}

  If (GlblUserWantsParcelToolbar and
      GlblParcelToolbarIsCreated)
    then
      begin
        If ((MainPASForm.ActiveMDIChild is TParcelTabForm) and
            (not GlblApplicationIsMinimized))
          then
            begin
              If not ParcelToolbarForm.Visible
                then
                  begin
                    ParcelToolbarForm.Visible := True;
                    ParcelToolbarForm.BringToFront;
                  end;

              ParcelToolbarForm.Visible := True;

            end;  {If (MainPASForm.ActiveMDIChild is TParcelTabForm)}

        If (MainPASForm.Active and
            (not (MainPASForm.ActiveMDIChild is TParcelTabForm)) and
            ParcelToolbarForm.Visible)
          then ParcelToolbarForm.Visible := False;

      end;  {If GlblUserWantsParcelToolbar}

end;  {ParcelToolbarTimerTimer}

{=======================================================================}
Function TMainPASForm.DetermineFormAccessRights(MenuID : Integer) : Integer;

{Based on the security level, do they have read only or read
 write access? Note that if they were able to click on this menu item,
 then they msut have some access since if they had no access, the
 menu item would have been turned off.}

begin
  try
    FindKeyOld(MenuSecurityTable, ['MenuID'], [IntToStr(MenuID)]);
  except
    SystemSupport(009, MenuSecurityTable, 'Error getting menu security record.',
                  UnitName, GlblErrorDlgBox);
  end;

  If (MenuSecurityTable.FieldByName('SecurityLevel').AsInteger > GlblSecurityLevel)
    then Result := raReadOnly
    else Result := raReadWrite;

end;  {DetermineFormAccessRights}

{=======================================================================}
Procedure TMainPASForm.TabSetChange(    Sender: TObject;
                                        NewTab: Integer;
                                    var AllowChange: Boolean);

{Show the form corresponding to the Tab that they just selected.}

begin
  ShowOccurrence(TabSet.Tabs[NewTab]);
end;  {TabSetChange}

{=======================================================================}
Procedure TMainPASForm.MenuExitItemClick(Sender: TObject);

{FXX11141997-1: FormCaptions was being freed too early and was being
                referenced by SynchronizeTabs, causing GPF.}

begin
  (*FormCaptions.Free;*)
  Close;

end;  {MenuExitItemClick}

{==========================================================}
Procedure TMainPASForm.FormCloseQuery(    Sender: TObject;
                                      var CanClose: Boolean);

begin
  If (GlblConfirmOnExit and
      (not GlblApplicationIsTerminatingToDoBackup))
    then CanClose := (MessageDlg('Are you sure you want to exit the Property Assessment System?',
                                 mtConfirmation, [mbYes, mbNo], 0) = idYes)
    else CanClose := True;

end;  {FormCloseQuery}

{==========================================================}
Procedure TMainPASForm.FormClose(    Sender: TObject;
                                 var Action: TCloseAction);

begin
  MenuSecurityTable.Close;

  GlblTraceTable.Close;
  GlblTraceTable.Free;

  GlblNameAddressTraceTable.Close;
  GlblNameAddressTraceTable.Free;

    {FXX11101997-2: Only store traces for fields listed in the
                    screen label file, since these are all we care about.}

  GlblScreenLabelTable.Close;
  GlblScreenLabelTable.Free;

    {Set a global variable saying that the whole application is closing.}
  GlblApplicationIsClosing := True;
  GlblErrorDlgBox.Free;

    {FXX07152002-2: The FormCaptions were not being freed.}

  FormCaptions.Free;

  HelpDocumentTable.Close;

    {CHG03222004-1(2.08): Track user logins.}

  TrackUserLogin(GlblUserName, lgOut);

end;  {FormClose}

{================================================================================}
{================================================================================}
{============  ALL MENU ON CLICK EVENTS FOLLOW  =================================}
{================================================================================}

{===================================================================}
Procedure TMainPASForm.TableMaintClick(Sender: TObject);

{This is the shared event handler used by all generic maint. clicks since
 they all use the same form - TABLEMNT (TableMaintForm).}

{The tags are done in menu order, from left to right, down each
 menu.
 Basic Tables = 1000 - 1090
 EX tables = 1100 - 1190
 Inventory tables :
   Building codes = 1200-1390
   Improvement codes = 1500-1590
   Income\Expense = 1600-1690
   Forest Stand codes = 1700 - 1890
   Land codes = 2000 - 2190
   Rentable Areas = 2200 - 2290
   Site = 2300 - 2590
   Other = 2600 - 2690

 Misc tables = 3000-3090
 Sales tables = 3200-3290
 SD tables = 3400 - 3490}

const
   {Basic}
  HomesteadMaint = 1010;
  PropertyClassMaint = 1020;
  RollSectionMaint = 1030;

    {Exemption}
  ExExtCalcMethodMaint = 1100;
  ExResidentialTypeMaint = 1105;
  ExTotalVerifTypeMaint = 1110;

    {Inventory - Building}
  ComBasementTypeMaint = 1200;
  ResBasementTypeMaint = 1205;
  BoeckhModelMaint = 1207;
  BuildingStyleMaint = 1210;
  ConstructionQualityMaint = 1215;
  ExteriorWallMaint = 1220;
  FuelTypeMaint = 1230;
  HeatTypeMaint = 1240;
  PorchTypeMaint = 1250;
  QualityMaint = 1260;

    {Inventory - Forest}
  AccessibilityMaint = 1700;
  CutClassMaint = 1710;
  ForestTypeMaint = 1720;
  LoggingEaseMaint = 1730;
  NominalValueMaint = 1740;
  RegionMaint = 1750;
  SiteClassMaint = 1760;
  VolumePerAcreClassMaint = 1770;

    {Inventory - Improvement}
  MeasurementMaint = 1500;

    {Inventory - Income\Expense}
  AppreciationDepreciationMaint = 1610;
  DateUseMaint = 1620;
  ExpenseMaint = 1630;
  InvestmentSetMaint = 1640;

    {Inventory - Land}
  InfluenceMaint = 2010;
  LandTypeMaint = 2020;
  SoilRatingMaint = 2030;
  WaterfrontTypeMaint = 2040;

    {Inventory - Rentable}
  RentableTypeMaint = 2210;

    {Inventory - Site}
  ElevationMaint = 2310;
  EntryMaint = 2315;
  NeighborhoodMaint = 2320;  {User defined}
  NeighborhoodRatingMaint = 2330;
  NeighborhoodTypeMaint = 2340;
  PhysicalChangeMaint = 2350;
  RoadMaint = 2370;
  SewerMaint = 2380;
  ResSiteDesirabilityMaint = 2390;
  ComSiteDesirabilityMaint = 2395;
  TrafficMaint = 2400;
  UtilityMaint = 2410;
  WaterMaint = 2420;
  ZoningMaint = 2430;  {State\user defined}

    {Inventory - general}
  ConditionMaint = 2600;
  GradeMaint = 2610;
  UnitMaint = 2620;
  ValuationDistMaint = 2640;  {User defined}

    {Misc}
  BillCollGenRateTaxTypeMaint = 3000;
  BillCollectionTypeMaint = 3005;
  EasementMaint = 3010;
  LandCommitmentMaint = 3020;
  MapTypeMaint = 3022;
  MunicipalityTypeMaint = 3025;
  NotesXActMaint = 3030;
  NotesTypeMaint = 3040;
  OrigAssValueMaint = 3050;
  OwnershipMaint = 3060;
  RevisedAssValueMaint = 3070;

      {Sales}
  SlsArmsLengthMaint = 3200;
  SlsConditionMaint  = 3205;
  SlsDeedTypeMaint   = 3210;
  SlsEA5217Maint     = 3215;
  SlsOwnerShipMaint  = 3220;
  SlsStatusMaint     = 3225;
  SlsTypeMaint       = 3230;
  SlsValidityMaint   = 3235;
  SlsVerifyMaint     = 3240;

    {Special district}
  SDCalcMaint = 3400;
  SDExtFlagsMaint = 3420;

  PetitionerComplaintCategoryMaint = 3540;

  AppraiserMaint = 3560;
  JudgeMaint = 3570;

var
  _TableName,
  _MainCodeName,
  _CaptionName : String;
  _SRAZ : Boolean;

  Child: TForm;
  Aborted, AllowMoreThanOneInstance : Boolean;
  TabName : String;
  NumOccurrences : Integer;

begin
  Aborted := False;
  _SRAZ := False;

  case TComponent(Sender).Tag of
    HomesteadMaint:
      begin
         _TableName := 'ZHomesteadCodeTbl';
         _MainCodeName := 'Homestead';
         _SRAZ := False;
         _CaptionName := 'Homestead Codes';
         TabName := 'Hmstd Cd';  {instance name for this form }
       end;

    PropertyClassMaint:
      begin
         _TableName := 'ZPropClsTbl';
         _MainCodeName := 'Property Class';
         _SRAZ := False;
         _CaptionName := 'Property Class Codes';
         TabName := 'Prp Class';  {instance name for this form }
       end;

    RollSectionMaint:
      begin
          _TableName := 'ZRollSectionTbl';
          _MainCodeName := 'Roll Section';
          _SRAZ := False;
          _CaptionName := 'Roll Section Codes';
          TabName := 'Roll Sect';  {instance name for this form }
        end;

      {Exemption}
    ExExtCalcMethodMaint:
      begin
         _TableName := 'ZExcdCalcMethodTbl';
         _MainCodeName := 'EX Calc Method';
         _SRAZ := False;
         _CaptionName := 'EX Calculation Method Codes';
         TabName := 'EX Calc Mthd Cds';  {instance name for this form }
       end;

    ExResidentialTypeMaint:
      begin
         _TableName := 'ZExResidentialTbl';
         _MainCodeName := 'EX Residential Type';
         _SRAZ := False;
         _CaptionName := 'EX Residential Type Codes';
         TabName := 'EX Res Cds';  {instance name for this form }
       end;

    ExTotalVerifTypeMaint:
      begin
         _TableName := 'ZExcdTotVerifyTbl';
         _MainCodeName := 'EX Total Verification';
         _SRAZ := False;
         _CaptionName := 'EX Total Verification Codes';
         TabName := 'EX Tot Ver Cds';  {instance name for this form }
       end;

      {Inventory - building}
    ComBasementTypeMaint:
      begin
         _TableName := 'ZInvComBasementTbl';
         _MainCodeName := 'Basement Type';
         _SRAZ := False;
         _CaptionName := 'Commercial Basement Type Codes';
         TabName := 'Com Bsmnt Cds';  {instance name for this form }
       end;

    ResBasementTypeMaint:
      begin
         _TableName := 'ZInvResBasementTbl';
         _MainCodeName := 'Basement Type';
         _SRAZ := False;
         _CaptionName := 'Residential Basement Type Codes';
         TabName := 'Res Bsmnt Cds';  {instance name for this form }
       end;

    BoeckhModelMaint:
      begin
         _TableName := 'ZInvBoeckhModelTbl';
         _MainCodeName := 'Boeckh Model Number';
         _SRAZ := True;
         _CaptionName := 'Boeckh Model Number Codes';
         TabName := 'Boeckh Cds';  {instance name for this form }
       end;

    BuildingStyleMaint:
      begin
         _TableName := 'ZInvBuildStyleTbl';
         _MainCodeName := 'Building Style';
         _SRAZ := True;
         _CaptionName := 'Building Style Codes';
         TabName := 'Bldg Cds';  {instance name for this form }
       end;

    ConstructionQualityMaint:
      begin
         _TableName := 'ZInvConstQualTbl';
         _MainCodeName := 'Construction Quality';
         _SRAZ := False;
         _CaptionName := 'Construction Quality Codes';
         TabName := 'Cnst Qual Cds';  {instance name for this form }
       end;

    ExteriorWallMaint:
      begin
         _TableName := 'ZInvExteriorWallTbl';
         _MainCodeName := 'Exterior Wall Material';
         _SRAZ := True;
         _CaptionName := 'Exterior Wall Material Codes';
         TabName := 'Ext Wall Cds';  {instance name for this form }
       end;

    FuelTypeMaint:
      begin
         _TableName := 'ZInvFuelTbl';
         _MainCodeName := 'Fuel Type';
         _SRAZ := False;
         _CaptionName := 'Fuel Type Codes';
         TabName := 'Fuel Cds';  {instance name for this form }
       end;

    HeatTypeMaint:
      begin
         _TableName := 'ZInvHeatTbl';
         _MainCodeName := 'Heat Type';
         _SRAZ := False;
         _CaptionName := 'Heat Type Codes';
         TabName := 'Heat Cds';  {instance name for this form }
       end;

    PorchTypeMaint:
      begin
         _TableName := 'ZInvPorchTypeTbl';
         _MainCodeName := 'Porch Type';
         _SRAZ := False;
         _CaptionName := 'Porch Type Codes';
         TabName := 'Porch Cds';  {instance name for this form }
       end;

      {FXX10091998-7: The caption name for this maint was contained in the
                      caption for const qual codes and caused problems.}

    QualityMaint:
      begin
         _TableName := 'ZInvQualityTbl';
         _MainCodeName := 'Quality';
         _SRAZ := False;
         _CaptionName := 'Bldg Qual Codes';
         TabName := 'Quality Cds';  {instance name for this form }
       end;

      {Inventory - Forest}
    AccessibilityMaint:
      begin
         _TableName := 'ZInvAccessibilityTbl';
         _MainCodeName := 'Accessibility';
         _SRAZ := False;
         _CaptionName := 'Accessibility Codes';
         TabName := 'Access Cds';  {instance name for this form }
       end;

    CutClassMaint:
      begin
         _TableName := 'ZInvCutClassTbl';
         _MainCodeName := 'Cut Class';
         _SRAZ := False;
         _CaptionName := 'Cut Class Codes';
         TabName := 'Cut Class Cds';  {instance name for this form }
       end;

    ForestTypeMaint:
      begin
         _TableName := 'ZInvForestTypeTbl';
         _MainCodeName := 'Forest Type';
         _SRAZ := True;
         _CaptionName := 'Forest Type Codes';
         TabName := 'Forest Cds';  {instance name for this form }
       end;

    LoggingEaseMaint:
      begin
         _TableName := 'ZInvLoggingEaseTbl';
         _MainCodeName := 'Logging Ease';
         _SRAZ := False;
         _CaptionName := 'Logging Ease Codes';
         TabName := 'Log Ease Cds';  {instance name for this form }
       end;

    NominalValueMaint:
      begin
         _TableName := 'ZInvNominalValueTbl';
         _MainCodeName := 'Nominal Value';
         _SRAZ := False;
         _CaptionName := 'Nominal Value Codes';
         TabName := 'Nom Val Cds';  {instance name for this form }
       end;

    RegionMaint:
      begin
         _TableName := 'ZInvForestRegionTbl';
         _MainCodeName := 'Forest Region';
         _SRAZ := False;
         _CaptionName := 'Forest Region Codes';
         TabName := 'Region Cds';  {instance name for this form }
       end;

    SiteClassMaint:
      begin
         _TableName := 'ZInvSiteClassTbl';
         _MainCodeName := 'Site Class';
         _SRAZ := True;
         _CaptionName := 'Site Class Codes';
         TabName := 'Site Class Cds';  {instance name for this form }
       end;

    VolumePerAcreClassMaint:
      begin
         _TableName := 'ZInvVolAcreClassTbl';
         _MainCodeName := 'Volume\Acre Class';
         _SRAZ := False;
         _CaptionName := 'Volume\Acre Class Codes';
         TabName := 'Vol\Acre Cds';  {instance name for this form }
       end;

      {Inventory - improvements}
    MeasurementMaint:
      begin
         _TableName := 'ZInvMeasurementTbl';
         _MainCodeName := 'Measurement';
         _SRAZ := False;
         _CaptionName := 'Measurement Codes';
         TabName := 'Meas Cds';  {instance name for this form }
       end;

      {Inventory - Income\Expense}
    AppreciationDepreciationMaint:
      begin
         _TableName := 'ZInvAppDepTbl';
         _MainCodeName := 'Appreciation\Depreciation';
         _SRAZ := False;
         _CaptionName := 'Appreciation\Depreciation Codes';
         TabName := 'App\Dep Cds';  {instance name for this form }
       end;

    DateUseMaint:
      begin
         _TableName := 'ZInvDataUseTbl';
         _MainCodeName := 'Data Use';
         _SRAZ := False;
         _CaptionName := 'Data Use Codes';
         TabName := 'Data Use Cds';  {instance name for this form }
       end;

    ExpenseMaint:
      begin
         _TableName := 'ZInvExpenseTbl';
         _MainCodeName := 'Expense';
         _SRAZ := False;
         _CaptionName := 'Expense Codes';
         TabName := 'Expense Cds';  {instance name for this form }
       end;

    InvestmentSetMaint:
      begin
         _TableName := 'ZInvInvestmentSetTbl';
         _MainCodeName := 'Investment Set';
         _SRAZ := False;
         _CaptionName := 'Investment Set Codes';
         TabName := 'Inv Set Cds';  {instance name for this form }
       end;


    {Inventory - Land}
    InfluenceMaint:
      begin
         _TableName := 'ZInvInfluenceTbl';
         _MainCodeName := 'Influence';
         _SRAZ := False;
         _CaptionName := 'Influence Codes';
         TabName := 'Influence Cds';  {instance name for this form }
       end;

    LandTypeMaint:
      begin
         _TableName := 'ZInvLandTypeTbl';
         _MainCodeName := 'Land Type';
         _SRAZ := True;
         _CaptionName := 'Land Type Codes';
         TabName := 'Land Cds';  {instance name for this form }
       end;

    SoilRatingMaint:
      begin
         _TableName := 'ZInvSoilRatingTbl';
         _MainCodeName := 'Soil Rating';
         _SRAZ := False;
         _CaptionName := 'Soil Rating Codes';
         TabName := 'Soil Cds';  {instance name for this form }
       end;

    WaterfrontTypeMaint:
      begin
         _TableName := 'ZInvWtrfrntTypeTbl';
         _MainCodeName := 'Waterfront Type';
         _SRAZ := False;
         _CaptionName := 'Waterfront Type Codes';
         TabName := 'Waterfront Cds';  {instance name for this form }
       end;

      {Inventory - Rentable}
    RentableTypeMaint:
      begin
         _TableName := 'ZInvRentTypeTbl';
         _MainCodeName := 'Rent Type';
         _SRAZ := False;
         _CaptionName := 'Rent Type Codes';
         TabName := 'Rent Type Cds';  {instance name for this form }
       end;

      {Inventory - site}
    ElevationMaint:
      begin
         _TableName := 'ZInvElevationCodeTbl';
         _MainCodeName := 'Elevation';
         _SRAZ := False;
         _CaptionName := 'Elevation Codes';
         TabName := 'Elev Cds';  {instance name for this form }
       end;

    EntryMaint:
      begin
         _TableName := 'ZInvEntryCodeTbl';
         _MainCodeName := 'Entry';
         _SRAZ := False;
         _CaptionName := 'Entry Codes';
         TabName := 'Entry Cds';  {instance name for this form }
       end;

    NeighborhoodMaint:
      begin
         _TableName := 'ZInvNghbrhdCodeTbl';
         _MainCodeName := 'Neighborhood';
         _SRAZ := False;
         _CaptionName := 'Neighborhood Codes';
         TabName := 'Nghbrhd Cds';  {instance name for this form }
       end;

    NeighborhoodRatingMaint:
      begin
         _TableName := 'ZInvNghbrhdRatingTbl';
         _MainCodeName := 'Neighborhood Rating';
         _SRAZ := False;
         _CaptionName := 'Neighborhood Rating Codes';
         TabName := 'Nghbrhd Rtg Cds';  {instance name for this form }
       end;

    NeighborhoodTypeMaint:
      begin
         _TableName := 'ZInvNghbrhdTypeTbl';
         _MainCodeName := 'Neighborhood Type';
         _SRAZ := False;
         _CaptionName := 'Neighborhood Type Codes';
         TabName := 'Nghbrhd Type Cds';  {instance name for this form }
       end;

    PhysicalChangeMaint:
      begin
         _TableName := 'ZInvPhysicalChgTbl';
         _MainCodeName := 'Physical Change';
         _SRAZ := False;
         _CaptionName := 'Physical Change Codes';
         TabName := 'Physical Change Cds';  {instance name for this form }
       end;

    RoadMaint:
      begin
         _TableName := 'ZInvRoadTypeTbl';
         _MainCodeName := 'Road Type';
         _SRAZ := False;
         _CaptionName := 'Road Type Codes';
         TabName := 'Rd Typ Cds';  {instance name for this form }
       end;

    SewerMaint:
      begin
         _TableName := 'ZInvSewerTbl';
         _MainCodeName := 'Sewer';
         _SRAZ := False;
         _CaptionName := 'Sewer Codes';
         TabName := 'Sewer Cds';  {instance name for this form }
       end;

      {FXX01211998-3: The site desirability codes are different for
                      commercial and residential.}

    ResSiteDesirabilityMaint:
      begin
         _TableName := 'ZInvResSiteDesireTbl';
         _MainCodeName := 'Site Desirability';
         _SRAZ := False;
         _CaptionName := 'Residential Site Desirability Codes';
         TabName := 'Res Site Cds';  {instance name for this form }
       end;

    ComSiteDesirabilityMaint:
      begin
         _TableName := 'ZInvComSiteDesireTbl';
         _MainCodeName := 'Site Desirability';
         _SRAZ := False;
         _CaptionName := 'Commercial Site Desirability Codes';
         TabName := 'Com Site Cds';  {instance name for this form }
       end;

    TrafficMaint:
      begin
         _TableName := 'ZInvTrafficCodeTbl';
         _MainCodeName := 'Traffic';
         _SRAZ := False;
         _CaptionName := 'Traffic Codes';
         TabName := 'Traffic Cds';  {instance name for this form }
       end;

    UtilityMaint:
      begin
         _TableName := 'ZInvUtilityTbl';
         _MainCodeName := 'Utility';
         _SRAZ := False;
         _CaptionName := 'Utility Codes';
         TabName := 'Utlty Cds';  {instance name for this form }
       end;

    WaterMaint:
      begin
         _TableName := 'ZInvWaterTbl';
         _MainCodeName := 'Water';
         _SRAZ := False;
         _CaptionName := 'Water Codes';
         TabName := 'Water Cds';  {instance name for this form }
       end;

    ZoningMaint:
      begin
         _TableName := 'ZInvZoningCodeTbl';
         _MainCodeName := 'Zoning';
         _SRAZ := False;
         _CaptionName := 'Zoning Codes';
         TabName := 'Zoning Cds';  {instance name for this form }
       end;

      {Inventory - general}
    ConditionMaint:
      begin
         _TableName := 'ZInvConditionTbl';
         _MainCodeName := 'Condition';
         _SRAZ := False;
         _CaptionName := 'Condition Codes';
         TabName := 'Condition Cds';  {instance name for this form }
       end;

    GradeMaint:
      begin
         _TableName := 'ZInvGradeTbl';
         _MainCodeName := 'Grade';
         _SRAZ := False;
         _CaptionName := 'Grade Codes';
         TabName := 'Grade Cds';  {instance name for this form }
       end;

    UnitMaint:
      begin
         _TableName := 'ZInvUnitTbl';
         _MainCodeName := 'Unit';
         _SRAZ := True;
         _CaptionName := 'Unit Codes';
         TabName := 'Unit Cds';  {instance name for this form }
       end;

    ValuationDistMaint:
      begin
         _TableName := 'ZInvValuationDistTbl';
         _MainCodeName := 'Valuation District';
         _SRAZ := False;
         _CaptionName := 'Valuation District Codes';
         TabName := 'Val Dist Cds';  {instance name for this form }
       end;

      {Misc}
    BillCollGenRateTaxTypeMaint:
      begin
         _TableName := 'ZBillCollGenRateTaxType';
         _MainCodeName := 'General Tax Rate Type';
         _SRAZ := False;
         _CaptionName := 'General Tax Rate Type';
         TabName := 'Gen Tax Rate Cds';  {instance name for this form }
       end;

    BillCollectionTypeMaint:
      begin
         _TableName := 'ZBillCollectionType';
         _MainCodeName := 'Bill Collection Type';
         _SRAZ := False;
         _CaptionName := 'Bill Collection Type Codes';
         TabName := 'Bill Coll Cds';  {instance name for this form }
       end;

    EasementMaint:
      begin
         _TableName := 'ZEasementTbl';
         _MainCodeName := 'Easement';
         _SRAZ := False;
         _CaptionName := 'Easement Codes';
         TabName := 'Esmnt Cds';  {instance name for this form }
       end;

    LandCommitmentMaint:
      begin
         _TableName := 'ZLandCommitmentTbl';
         _MainCodeName := 'Land Commitment';
         _SRAZ := False;
         _CaptionName := 'Land Commitment Codes';
         TabName := 'Land Com Cds';  {instance name for this form }
       end;

    MapTypeMaint:
      begin
         _TableName := 'ZMapTypesTable';
         _MainCodeName := 'Map Type';
         _SRAZ := False;
         _CaptionName := 'Map Type Codes';
         TabName := 'Map Types';  {instance name for this form }
       end;

    MunicipalityTypeMaint:
      begin
         _TableName := 'ZMunicipalityTypeTbl';
         _MainCodeName := 'Municipality Type';
         _SRAZ := False;
         _CaptionName := 'Municipality Type Codes';
         TabName := 'Munic Cds';  {instance name for this form }
       end;


    NotesXActMaint:
      begin
         _TableName := 'ZNotesXactCodeTbl';
         _MainCodeName := 'Notes Transaction';
         _SRAZ := False;
         _CaptionName := 'Notes Transaction Codes';
         TabName := 'Notes XAct Cds';  {instance name for this form }
       end;

    NotesTypeMaint:
      begin
         _TableName := 'ZNotesTypeTbl';
         _MainCodeName := 'Notes Type';
         _SRAZ := False;
         _CaptionName := 'Notes Type Codes';
         TabName := 'Notes Types';  {instance name for this form }
       end;

    OrigAssValueMaint:
      begin
         _TableName := 'ZOrigAssValTbl';
         _MainCodeName := 'Original Assessed Value Type';
         _SRAZ := False;
         _CaptionName := 'Original Assessed Value Type Codes';
         TabName := 'Orig Val Cds';  {instance name for this form }
       end;

    OwnershipMaint:
      begin
         _TableName := 'ZOwnershipTbl';
         _MainCodeName := 'Ownership';
         _SRAZ := False;
         _CaptionName := 'Ownership Codes';
         TabName := 'Ownership Cds';  {instance name for this form }
       end;

    RevisedAssValueMaint:
      begin
         _TableName := 'ZRevisedAssValTbl';
         _MainCodeName := 'Revised Assessment Value Type';
         _SRAZ := False;
         _CaptionName := 'Revised Assessment Value Type Codes';
         TabName := 'Revised Val Cds';  {instance name for this form }
       end;

      {Sales}
    SlsArmsLengthMaint:
      begin
         _TableName := 'ZSlsArmsLengthTbl';
         _MainCodeName := 'Arms Length';
         _SRAZ := False;
         _CaptionName := 'Arms Length Codes';
         TabName := 'Arms Len. Cds';  {instance name for this form }
       end;

    SlsConditionMaint:
      begin
         _TableName := 'ZSlsConditionTbl';
         _MainCodeName := 'Sales Condition';
         _SRAZ := False;
         _CaptionName := 'Sales Condition Codes';
         TabName := 'Conditon Cds';  {instance name for this form }
       end;

    SlsDeedTypeMaint:
      begin
         _TableName := 'ZSlsDeedTypeTbl';
         _MainCodeName := 'Deed Type';
         _SRAZ := False;
         _CaptionName := 'Deed Type Codes';
         TabName := 'Deed Ty. Cds';  {instance name for this form }
       end;

    SlsEA5217Maint:
      begin
         _TableName := 'ZSlsEA5217Tbl';
         _MainCodeName := 'EA-5217';
         _SRAZ := False;
         _CaptionName := 'EA-5217 Codes';
         TabName := 'EA5217 Cds';  {instance name for this form }
       end;

    SlsOwnerShipMaint:
      begin
         _TableName := 'ZSlsOwnershipTbl';
         _MainCodeName := 'Ownership';
         _SRAZ := False;
         _CaptionName := 'Ownership Codes';
         TabName := 'Ownership Cds';  {instance name for this form }
       end;

    SlsStatusMaint:
      begin
         _TableName := 'ZSlsStatusTbl';
         _MainCodeName := 'Status';
         _SRAZ := False;
         _CaptionName := 'Status Codes';
         TabName := 'Status Cds';  {instance name for this form }
       end;

    SlsTypeMaint:
      begin
         _TableName := 'ZSlsSalesTypeTbl';
         _MainCodeName := 'Sales Type';
         _SRAZ := False;
         _CaptionName := 'Sales Type Codes';
         TabName := 'Sls Type Cds';  {instance name for this form }
       end;

    SlsValidityMaint:
      begin
         _TableName := 'ZSlsValidityTbl';
         _MainCodeName := 'Validity';
         _SRAZ := False;
         _CaptionName := 'Validity Codes';
         TabName := 'Validity Cds';  {instance name for this form }
       end;


    SlsVerifyMaint:
      begin
         _TableName := 'ZSlsVerifyTbl';
         _MainCodeName := 'Verify';
         _SRAZ := False;
         _CaptionName := 'Verify Codes';
         TabName := 'Verify Cds';  {instance name for this form }
       end;

      {Special district}
    SDCalcMaint:
      begin
         _TableName := 'ZSDCalcCodeTbl';
         _MainCodeName := 'SD Calc';
         _SRAZ := False;
         _CaptionName := 'SD Calc Codes';
         TabName := 'SD Calc Cds';  {instance name for this form }
       end;

    SDExtFlagsMaint:
      begin
         _TableName := 'ZSDExtCodeFlagTbl';
         _MainCodeName := 'SD Ext Flags';
         _SRAZ := False;
         _CaptionName := 'SD Extension Flag Codes';
         TabName := 'Sd Ext Flag Cds';  {instance name for this form }
       end;

    PetitionerComplaintCategoryMaint:
      begin
         _TableName := 'ZGReasonCategoryCodes';
         _MainCodeName := 'Complaint Categories';
         _SRAZ := False;
         _CaptionName := 'Petitioner Complaint Category Codes';
         TabName := 'Cpmlt Cat';  {instance name for this form }
       end;

    AppraiserMaint:
      begin
         _TableName := 'zgcappraisertable';
         _MainCodeName := 'Appraisers';
         _SRAZ := False;
         _CaptionName := 'Appraiser Codes';
         TabName := 'Appraisers';  {instance name for this form }
       end;

    JudgeMaint:
      begin
         _TableName := 'zgcjudgetable';
         _MainCodeName := 'Judges';
         _SRAZ := False;
         _CaptionName := 'Judge Codes';
         TabName := 'Judges';  {instance name for this form }
       end;

  end;  {case TComponent(Sender).Tag of}

  AllowMoreThanOneInstance := False;
  NumOccurrences := FindNumOccurrences(TabName);

    {Now if there are no forms of this type already visible, or there is and
     we allow multiple instances of this form, then create a new form. Otherwise,
     find the existing form and show it.}

  If ((NumOccurrences = 0) or
      ((NumOccurrences > 0) and
        AllowMoreThanOneInstance))
    then
      begin
        Child := nil;
        try
          LockWindowUpdate(Handle);
          Child := TTableMaintForm.Create(Application);
        except
          NonBtrvSystemSupport(010, 0, 'Error creating form.',
                               UnitName, GlblErrorDlgBox);
          Aborted := True;
        end;

        If ((not Aborted) and
            (Child <> nil))
          then
            begin
              with Child as TTableMaintForm do
                begin
                  TableName := _TableName;
                  MainCodeName := _MainCodeName;
                  CaptionName := _CaptionName;
                  SRAZ := _SRAZ;
                  FormAccessRights := DetermineFormAccessRights(TComponent(Sender).Tag);
                  InitializeForm;

                end;  {with Child as TTableMaintForm do}

              Child.WindowState := wsMaximized; {make child fit in parent window}
              NumOccurrences := NumOccurrences + 1;

                {Now, if there is more than one occurrence of this form, then
                 we want to label the Tab and caption of the form with the number
                 of this occurrence.}
              If AllowMoreThanOneInstance
                then
                  begin
                    Child.Caption := Child.Caption + ' ' + IntToStr(NumOccurrences);
                    TabName := TabName + ' ' + IntToStr(NumOccurrences);
                  end;

                {Now add this Tab to the Tab set, and select it.}

              AddTab(TabName, Child.Caption);
              SelectTab(TabName);

                {If the user info panel is visible, then we want to hide it so
                 that it does not show on top.}

              If UserInfoPanel.Visible
                then UserInfoPanel.Visible := False;

              Child.Show;        {this shows my form}
              LockWindowUpdate(0);  {Now draw the child.}

            end;  {If not Aborted}

      end
    else
      begin
        ShowOccurrence(TabName);
        SelectTab(TabName);
      end;

end;  {TableMaintClick}

{================================================================================}
Procedure TMainPASForm.NormalMenuItemClick(Sender: TObject);

{The tags are done in menu order, from left to right, down each
 menu.}

const
   {NOTE NOTE NOTE The following constants must be in numerical order }
   {mathcing the order they appear in the menu designer, for the security}
   {job to list menu selections in order as they actually appear in menu}
  AssYearControlMaint = 5;
  SwisCodeMaint = 10;
  SchoolCodeMaint = 20;
  SDCodeMaint = 30;
  EXCodeMaint = 40;
  StructureMaint = 1510;
  LetterTextMaint = 1520;
  AssessorOfficeMaint = 1530;
  UsedAsMaint = 2630;
  ColdWarVeteranLimits = 3007;
  SeniorIncomeLimits = 3075;
  VeteransLimitsCodes = 3080;
  SDExtensionCodeMaint = 3410;
  BoardDenialReasonMaint = 3500;
  BoardDispositionMaint = 3510;
  BoardMemberMaint = 3520;
  LawyerCodeMaint = 3530;
  ComplaintReasonCodeMaint = 3550;
  SmallClaim_Cert_DispositionMaint = 3560;
  DeleteAParcel = 4020;
  ReactivateAParcel = 4040;
  SplitMerge = 4060;

    {Reports}
    {FXX10191997-2: The report tags overlapped with the parcel page tags
                    which caused a problem for the security.}

  AssessmentByPropClassReport = 5400;
  ChangeAssessmentLetter = 5405;
  AssessmentRolls = 5407;
  AssessmentSummaryReport = 5410;
  AssessmentVarianceReport = 5420;
  AssessorsReport = 5430;
  AssessorsTrialBalanceReport = 5432;
  AssessorsVerificationReport = 5435;
  AuditTrailReport = 5440;
  NameAddressAuditTrailReport = 5441;
  BuildingPermitReport = 5442;
  CompDisplay = 5445;
  ExemptionReport = 5450;
  ExemptionComparisonReport = 5455;
  ExemptionStatusReport = 5447;
  ExemptionImpactReport = 5457;
  ExemptionLetter = 5460;
  GenericLetters = 5465;
  Labels = 5467;
  NotesReport = 5470;
  ParcelInfoReport = 5475;
  PictureReport = 5477;
  DisplayRollTotals = 5480;
  RollTotalsPrint = 5485;
  SalesReport = 5490;
  SalesAndRemovedExemptionsReport = 5492;
  SalesAnalysisReport = 5495;
  SearchReport = 5500;
  SpecialDistrictReport = 5600;
  SplitMergeReport = 5610;
  ValueComparisonReport = 5620;
  ThirdPartyNotificationReport = 5625;
  TopTaxPayerReport = 5650;
  GrievanceAuditReport = 5660;
  GrievanceLetters = 5665;
  GrievanceNotesReport = 5667;
  GrievanceSummaryReport = 5670;
  GrievanceResultsByBOARReport = 5680;
  SmallClaimsNotesReport = 5685;
  SmallClaimsSummaryReport = 5690;
  SmallClaimsCalendarReport = 5695;
  CertiorariSummaryReport = 5700;
  CertiorariCalendarReport = 5710;
  CertiorariHistoryReport = 5720;
  CertiorariNotesReport = 5730;
  OverallGrievance_SmallClaims_Certiorari_Report = 5750;
  RemovedExemptionsReport = 5760;
  GeneralizedComparisonReport = 5770;

    {Bill Processing}
  BillCollectionControlCreate = 6000;
  LoadArrearsFlags = 6005;
  BillCollectionRates         = 6010;
  BillCalculation             = 6020;
  BillPrintRoll               = 6030;
  CoopTaxRoll                 = 6035;
  MtPleasantSchoolPrintBills  = 6040;
  MtPleasantTownPrintBills    = 6050;
  HastingsPrintBills          = 6060;
  WesleyPrintBills = 6070;
  SomersTownPrintBills = 6080;
  RyeCityPrintBills = 6090;
  RyeCountyPrintBills = 6100;
  RyeSchoolPrintBills = 6110;
  SomersSchoolPrintBills = 6120;
  LawrenceVillagePrintBills = 6130;
  BrookvilleVillagePrintBills = 6140;
  RyeBillExtract = 6150;
  ScarsdaleVillage_CountyPrintBills = 6160;
  RyeCity_CountyPrintBills = 6170;
  MalvernePrintBills = 6180;
  EastchesterSchoolPrintBills = 6190;
  ScarsdaleSchoolPrintBills = 6200;
  SuffernSewerPrintBills = 6210;
  EastchesterTownPrintBills = 6220;
  SuffernSewerSecondHalfPrintBills = 6230;
  LakeSuccessPrintBills = 6240;
  EastHamptonPrintBills = 6250;
  SouthamptonPrintBills = 6260;
  TarrytownPrintBills = 6270;
  MasticBeachPrintBills = 6280;

    {IMPORT/Export}
  ImportBankcodes = 7000;
  _147155FileExtract = 7010;
  _995FileExtract = 7020;
  GeneralizedFileExtract = 7030;
  LaserBillFileExtract = 7032;
  LoadPictures_Documents = 7035;
  LoadPicturesFromLoadingDock = 7037;
  STARExtract = 7040;
  FreeportTaxExtract = 7050;
  ImportIVPStatusFromDTF = 7055;
  UpdateVillageNameAddressExport = 7060;
  UpdateVillageNameAddressImport = 7070;
  YorktownNameAddressExport = 7080;
  LoadNassauCountyValues = 7090;
  NYSORPSCoopExtract = 7100;
  MiddleClassSTARExtract = 7110;

    {Prorata}

  ProrataCalculation = 9010;
  ProrataList = 9020;
  ProrataWorksheets = 9025;
  ProrataLetters = 9030;
  ProrataMoveValues = 9040;

    {Options}
  SelectTaxRollYear = 10010;
  UserProfile = 10020;


    {System}

  AddEnhancedSTARExemptions = 11005;
  BroadcastChanges = 11007;
  CalculateRollTotals = 11010;
  CompareParcelIDsBetweenSCASystems = 11011;
  ClearArrearsFlags = 11012;
  CompFileCreate = 11013;
  CreateSketchesForSearcher = 11014;
  DefineUserDataFieldNames = 11015;
  DocumentTypesAvailable = 11060;
  ExemptionBroadcast = 11016;
  ExemptionsRecalc = 11017;
  GrievanceBulkUpdate = 11018;
  SysRecMaint = 11020;
  MtVernonTaxExtract = 11021;
  PrinterMaint = 11025;
  RestrictSearcherParcels = 11026;
  PurgeDeniedExemptions = 11027;
  ReduceBIEExemptions = 11031;
  ReportManager = 11028;
  SalesExtractLog = 11029;
  SecurityLevels = 11030;
  SFLARecalculation = 11035;
  _TaskList = 11038;
  SDBroadcast = 11040;
  TransferCoopValues = 11041;
(*  UpdateIndividualSettings = 11042; *)
  TransferCoopSTARValues = 11042;
  UpdateNamesAndAddresses = 11047;
  SDComparisonReport = 11045;
  YearEndRollover = 11050;
  CoopBuildingMaintenance = 11055;
  ExemptionPurge = 11080;
  BroadcastAVChanges = 11070;
  ParcelSummaryWithSketch = 11111;

    {Test only programs - will be removed later.
     They start with 20000 and will only show for SCABOAT.}

  DataConversion = 20010;
  GenerateScreenLabels = 20020;
  TotalExemptions = 20030;
  ExemptionsCheck = 20040;
  RollScan = 20050;
  AVCheck = 20060;
  SeniorCheck = 20070;
  CopyINIFile = 20080;
  FindNYInactive = 20090;
  RecreateSalesExtract = 20100;

var
  Child: TForm;
  Aborted, AllowMoreThanOneInstance : Boolean;
  TabName, Caption : String;
  I, Tag, NumOccurrences : Integer;

begin
  Child := nil;
  Tag := TComponent(Sender).Tag;
  Aborted := False;
  AllowMoreThanOneInstance := False;

  case Tag of
    AssYearControlMaint : TabName := 'Asmt Yr Ctl';
    SwisCodeMaint : TabName := 'SWIS Codes';
    SchoolCodeMaint : TabName := 'School Codes';
    SDCodeMaint : TabName := 'SD Codes';
    EXCodeMaint : TabName := 'EX Codes';
    StructureMaint : TabName := 'Structure Codes';
    UsedAsMaint : TabName := 'Used As Codes';
    ColdWarVeteranLimits : TabName := 'Cold War Bet Limits';
    SeniorIncomeLimits : TabName := 'Senior Limits';
    VeteransLimitsCodes : TabName := 'Vet Limits';
    LetterTExtMaint : TabName := 'Letter Text Maint';
    AssessorOfficeMaint : TabName := 'Assessor Office Maint';
    SysRecMaint : TabName := 'Sys Rec Maint';
    PrinterMaint : TabName := 'Printer Maint';
    PurgeDeniedExemptions : TabName := 'EX Purge';
    ReduceBIEExemptions : TabName := 'Reduce BIE';
    SDExtensionCodeMaint : TabName := 'SD Ext Cds';
    BoardDenialReasonMaint : TabName := 'Denial Cds';
    BoardDispositionMaint : TabName := 'BAR Disp';
    BoardMemberMaint : TabName := 'BAR Members';
    LawyerCodeMaint : TabName := 'Lawyers';
    ComplaintReasonCodeMaint : TabName := 'Cmp Reason';
    SmallClaim_Cert_DispositionMaint : TabName := 'Disp Codes';
    DeleteAParcel : TabName := 'Inact Prcl';
    ReactivateAParcel : TabName := 'React Parcel';
    SplitMerge : TabName := 'Split\Merge';
    AssessmentRolls : TabName := 'Rolls';
    AssessmentSummaryReport : TabName := 'AV Smry Rpt';
    AssessmentVarianceReport : TabName := 'AV Var Rpt';
    AssessmentByPropClassReport : TabName := 'AV By Prp Cls';
    AssessorsReport : TabName := 'Assessor''s Rpt';
    AssessorsTrialBalanceReport : TabName := 'Assessor''s Trial Bal';
    AssessorsVerificationReport : TabName := 'Assessor''s Ver Rpt';
    BuildingPermitReport : TabName := 'Prmt Rpt';
    ExemptionReport : TabName := 'Exempt Rpt';
    ExemptionComparisonReport : TabName := 'EX Comp Rpt';
    ExemptionImpactReport : TabName := 'EX Impact Rpt';
    ExemptionStatusReport : TabName := 'EX Stat Rpt';
    SpecialDistrictReport : TabName := 'SD Rpt';
    SplitMergeReport : TabName := 'Split Merge Rpt';
    ValueComparisonReport : TabName := 'Value Compare Rpt';
    ThirdPartyNotificationReport : TabName := '3rd Party';
    TopTaxPayerReport : TabName := 'Top Taxpayers';
    GrievanceAuditReport : TabName := 'Grv Audit';
    GrievanceLetters : TabName := 'Grv Letters';
    GrievanceNotesReport : TabName := 'Grv Notes';
    GrievanceSummaryReport : TabName := 'Grv Summary';
    GrievanceResultsByBOARReport : TabName := 'Grv Rslts by BAR';
    SmallClaimsNotesReport : TabName := 'Sm Clm Notes';
    SmallClaimsSummaryReport : TabName := 'Small Claims Summary';
    SmallClaimsCalendarReport : TabName := 'Small Claims Calendar';
    CertiorariSummaryReport : TabName := 'Cert Summary';
    CertiorariCalendarReport : TabName := 'Cert Cal';
    CertiorariHistoryReport : TabName := 'Cert Hist';
    CertiorariNotesReport : TabName := 'Cert Notes';
    OverallGrievance_SmallClaims_Certiorari_Report : TabName := 'Overall Summary';
    RemovedExemptionsReport : TabName := 'Removed EX Rpt';
    GeneralizedComparisonReport : TabName := 'Gen Compare';
    ChangeAssessmentLetter : TabName := 'Asmt Chg Ltrs';
    RollTotalsPrint : TabName := 'Roll Tot Rpt';
    AuditTrailReport : TabName := 'Audit Rpt';
    NameAddressAuditTrailReport : TabName := 'Name\Addr Rpt';
    SalesReport : TabName := 'Sales Rpt';
    SalesAndRemovedExemptionsReport : TabName := 'Sales\Removed Ex Rpt';
    SalesAnalysisReport : TabName := 'Sales Anal Rpt';
    NotesReport : TabName := 'Notes Rpt';
    ParcelInfoReport : TabName := 'Prcl Info Rpt';
    PictureReport : TabName := 'Pic \ Card Rpt';
    SearchReport : TabName := 'Search Rpt';
    ExemptionLetter : TabName := 'Exempt Ltrs';
    GenericLetters : TabName := 'Letters';
    Labels : TabName := 'Labels';
    DisplayRollTotals : TabName := 'Roll Totals';
    BillCollectionControlCreate : TabName := 'Create Bill Cycle';
    LoadArrearsFlags : TabName := 'Load Arrears';
    BillCollectionRates : TabName := 'Set Bill Rates';
    BillCalculation : TabName := 'Bill Calculation';
    BillPrintRoll : TabName := 'Print Tax Roll';
    CoopTaxRoll : TabName := 'Coop Tax Roll';

    MtPleasantSchoolPrintBills,
    MtPleasantTownPrintBills,
    HastingsPrintBills,
    WesleyPrintBills,
    SomersTownPrintBills,
    RyeCityPrintBills,
    RyeCountyPrintBills,
    RyeSchoolPrintBills,
    SomersSchoolPrintBills,
    LawrenceVillagePrintBills,
    BrookvilleVillagePrintBills,
    ScarsdaleVillage_CountyPrintBills,
    RyeCity_CountyPrintBills,
    MalvernePrintBills,
    EastchesterSchoolPrintBills,
    ScarsdaleSchoolPrintBills,
    SuffernSewerPrintBills : TabName := 'Print Tax Bills';

    RyeBillExtract : TabName := 'Rye Bill Print Extract';

    _147155FileExtract : TabName := 'Billing File Extract';
    _995FileExtract : TabName := 'Full File Extract';
    GeneralizedFileExtract : TabName := 'General Extract';
    LaserBillFileExtract : TabName := 'Laser Bill Extract';
    LoadPictures_Documents : TabName := 'Load Pics\Docs';
    LoadPicturesFromLoadingDock : TabName := 'Load Pics';
    ImportBankCodes : TabName := 'Import Bank Codes';
    DataConversion : TabName := 'Data Conv';
    UserProfile : TabName := 'User Profile';  {instance name for this form }
    DefineUserDataFieldNames : TabName := 'User Data Def';  {instance name for this form }
    DocumentTypesAvailable : TabName := 'Doc Types';  {instance name for this form }
    RestrictSearcherParcels : TabName := 'Restrict Parcels';
    ReportManager : TabName := 'Rpt Manager';  {instance name for this form }
    SalesExtractLog : TabName := 'Sales Extract Log';  {instance name for this form }
    SFLARecalculation : TabName := 'SFLA Recalc';  {instance name for this form }
    _TaskList : TabName := 'Task List';  {instance name for this form }
    SecurityLevels : TabName := 'Security';  {instance name for this form }
    MtVernonTaxExtract : TabName := 'Tax Extract';  {instance name for this form }
    CalculateRollTotals : TabName := 'Roll Tot Calc';  {instance name for this form }
    CompareParcelIDsBetweenSCASystems : TabName := 'Compare IDs';
    ClearArrearsFlags : TabName := 'Clear Arrears';  {instance name for this form }
    TotalExemptions : TabName := 'Tot Ex';  {instance name for this form }
    SDBroadcast : TabName := 'SD Broadcast';  {instance name for this form }
    TransferCoopValues : TabName := 'XFer Coop Vals';
    TransferCoopSTARValues : TabName := 'XFer Coop STAR Vals';
    SDComparisonReport : TabName := 'SD Comp Rpt';  {instance name for this form }
    ExemptionBroadcast : TabName := 'EX Broadcast';  {instance name for this form }
    BroadcastChanges : TabName := 'Broadcast Changes';  {instance name for this form }
    BroadcastAVChanges : TabName := 'Broadcast AV Changes';
    ParcelSummaryWithSketch : TabName := 'Prcl Smry w/Sketch';
(*    UpdateIndividualSettings : TabName := 'Update Settings';  *)
    UpdateNamesAndAddresses : TabName := 'Update Names \ Addresses';  {instance name for this form }
    YearEndRollOver : TabName := 'YearEnd Rollover';  {instance name for this form }
    CoopBuildingMaintenance : TabName := 'Coop Bldg Maint';
    GenerateScreenLabels : TabName := 'Scrn Label File';  {instance name for this form }
    ExemptionsRecalc : TabName := 'Recalc Ex';  {instance name for this form }
    GrievanceBulkUpdate : TabName := 'Grv Bulk Update';  {instance name for this form }
    CompFileCreate : TabName := 'Comp File Create';  {instance name for this form }
    CreateSketchesForSearcher : TabName := 'Srchr Sketches';
    STARExtract : TabName := 'Renewal Extract';  {instance name for this form }
    FreeportTaxExtract : TabName := 'Tax Extract';  {instance name for this form }
    ImportIVPStatusFromDTF : TabName := 'Import IVP Status';
    UpdateVillageNameAddressExport : TabName := 'Send Name\Addr Update';
    UpdateVillageNameAddressImport : TabName := 'Name\Addr Update';
    YorktownNameAddressExport : TabName := 'Name\Addr Extract';
    LoadNassauCountyValues : TabName := 'Nassau Load';
    NYSORPSCoopExtract : TabName := 'ORPS Coop Extract';
    MiddleClassSTARExtract : TabName := 'STAR Extract';
    ProrataCalculation : TabName := 'Prorata Calc';
    ProrataList : TabName := 'Prorata Report';
    ProrataWorksheets : TabName := 'Prorata Worksheets';
    ProrataLetters : TabName := 'Prorata Letters';
    ProrataMoveValues : TabName := 'Prorata Move Values';
    ExemptionPurge : TabName := 'EX Purge';

  end;  {case Tag of}

  NumOccurrences := FindNumOccurrences(TabName);

    {Now if there are no forms of this type already visible, or there is and
     we allow multiple instances of this form, then create a new form. Otherwise,
     find the existing form and show it.}

  If ((NumOccurrences = 0) or
      ((NumOccurrences > 0) and
        AllowMoreThanOneInstance))
    then
      begin
        try
          Child := nil;
          Cursor := crHourglass;
          Application.ProcessMessages;
          LockWindowUpdate(Handle);

            {Create the form based on what kind we want. Also,
             each form has a public property called FormAccessRights
             which will be either raReadOnly or raReadWrite.
             (Note that it will not be raNoAccess since the menu
              item is disabled if there is no access). Then we
              will call the procedure InitializeForm. We are using
              this procedure rather than OnShow so that we can
              control the order of execution.}

          case Tag of
            AssYearControlMaint:
              begin
                Child := TAssYearControlForm.Create(Application);
                TAssYearControlForm(Child).FormAccessRights := DetermineFormAccessRights(Tag);
                TAssYearControlForm(Child).InitializeForm;
              end;  {EXCodeMaint}

(*            SwisCodeMaint:
              begin
                Child := TSwisCodeMaintForm.Create(Application);
                TSwisCodeMaintForm(Child).FormAccessRights := DetermineFormAccessRights(Tag);
                TSwisCodeMaintForm(Child).InitializeForm;
              end;  {SwisCodeMaint} *)

            SwisCodeMaint:
              begin
                Child := TfmSwisCodes.Create(Application);
                TfmSwisCodes(Child).FormAccessRights := DetermineFormAccessRights(Tag);
                TfmSwisCodes(Child).InitializeForm;
              end;  {SwisCodeMaint}

             DefineUserDataFieldNames:
               begin
                Child := TDefineUserFieldsForm .Create(Application);
                TDefineUserFieldsForm (Child).FormAccessRights := DetermineFormAccessRights(Tag);
                TDefineUserFieldsForm (Child).InitializeForm;
              end;  {RollTotals}

            DocumentTypesAvailable:
              begin
                Child := TDocumentTypesAvailableForm.Create(Application);
                TDocumentTypesAvailableForm(Child).FormAccessRights := DetermineFormAccessRights(Tag);
                TDocumentTypesAvailableForm(Child).InitializeForm;
              end;  {Doc Types}

            SchoolCodeMaint:
              begin
                Child := TSchoolCodeMaintForm.Create(Application);
                TSchoolCodeMaintForm(Child).FormAccessRights := DetermineFormAccessRights(Tag);
                TSchoolCodeMaintForm(Child).InitializeForm;
              end;  {SchoolCodeMaint}

            SDCodeMaint:
              begin
                Child := TSDCodeForm.Create(Application);
                TSDCodeForm(Child).FormAccessRights := DetermineFormAccessRights(Tag);
                TSDCodeForm(Child).InitializeForm;
              end;  {SDCodeMaint}

            EXCodeMaint:
              begin
                Child := TEXCodeForm.Create(Application);
                TEXCodeForm(Child).FormAccessRights := DetermineFormAccessRights(Tag);
                TEXCodeForm(Child).InitializeForm;
              end;  {EXCodeMaint}

            StructureMaint:
              begin
                Child := TStructureMaintForm.Create(Application);
                TStructureMaintForm(Child).FormAccessRights := DetermineFormAccessRights(Tag);
                TStructureMaintForm(Child).InitializeForm;
              end;  {StructureMaint}

            UsedAsMaint:
              begin
                Child := TUsedAsMaintForm.Create(Application);
                TUsedAsMaintForm(Child).FormAccessRights := DetermineFormAccessRights(Tag);
                TUsedAsMaintForm(Child).InitializeForm;
              end;  {UsedAsMaint}

            SeniorIncomeLimits :
              begin
                Child := TSeniorIncomeLimitsMaintenance.Create(Application);
                TSeniorIncomeLimitsMaintenance(Child).FormAccessRights := DetermineFormAccessRights(Tag);
                TSeniorIncomeLimitsMaintenance(Child).InitializeForm;
              end;

            ColdWarVeteranLimits :
              begin
                Child := TfmColdWarVeteranLimits.Create(Application);
                TfmColdWarVeteranLimits(Child).FormAccessRights := DetermineFormAccessRights(Tag);
                TfmColdWarVeteranLimits(Child).InitializeForm;
              end;

             {CHG05191998-1: Add veterans limits codes maint.}

            VeteransLimitsCodes :
              begin
                Child := TVeteransLimitsCodesForm.Create(Application);
                TVeteransLimitsCodesForm(Child).FormAccessRights := DetermineFormAccessRights(Tag);
                TVeteransLimitsCodesForm(Child).InitializeForm;
              end;

            LetterTextMaint:
              begin
                Child := TLetterTextMaintForm.Create(Application);
                TLetterTextMaintForm(Child).FormAccessRights := DetermineFormAccessRights(Tag);
                TLetterTextMaintForm(Child).InitializeForm;
              end;  {UsedAsMaint}

            AssessorOfficeMaint:
              begin
                Child := TAssessorOfficeMaintForm.Create(Application);
                TAssessorOfficeMaintForm(Child).FormAccessRights := DetermineFormAccessRights(Tag);
                TAssessorOfficeMaintForm(Child).InitializeForm;
              end;  {UsedAsMaint}

            SysRecMaint:
              begin
                Child := TSysRecForm.Create(Application);
                TSysRecForm(Child).FormAccessRights := DetermineFormAccessRights(Tag);
                TSysRecForm(Child).InitializeForm;
              end;  {SysRecMaint}

            PrinterMaint:
              begin
                Child := TInstalledPrinterForm.Create(Application);
                TInstalledPrinterForm(Child).InitializeForm;
              end;  {PrinterMaint}

(*            PurgeDeniedExemptions:
              begin
                Child := TPurgeDeniedExemptionsForm.Create(Application);
                TPurgeDeniedExemptionsForm(Child).InitializeForm;
              end;  {PrinterMaint}*)

            ReduceBIEExemptions :
              begin
                Child := TReduceBIEExemptionsForm.Create(Application);
                TReduceBIEExemptionsForm(Child).InitializeForm;
              end;

            AssessmentRolls:
              begin
                Child := TAssessmentRollForm.Create(Application);
                TAssessmentRollForm(Child).InitializeForm;
              end;

            AssessmentSummaryReport:
              begin
                Child := TAssessmentSummaryReportForm.Create(Application);
                TAssessmentSummaryReportForm(Child).InitializeForm;
              end;

            AssessmentVarianceReport:
              begin
                Child := TAssessmentVarianceReportForm.Create(Application);
                TAssessmentVarianceReportForm(Child).InitializeForm;
              end;

            RollTotalsPrint:
              begin
                Child := TRollTotalReport.Create(Application);
                TRollTotalReport(Child).InitializeForm;
              end;

            AssessmentByPropClassReport:
              begin
                Child := TAssessmentByPropertyClassReportForm.Create(Application);
                TAssessmentByPropertyClassReportForm(Child).InitializeForm;
              end;

            AssessorsReport:
              begin
                Child := TAssessorsReportForm.Create(Application);
                TAssessorsReportForm(Child).InitializeForm;
              end;  {Assessors report}

            AssessorsTrialBalanceReport:
              begin
                Child := TAssessorsTrialBalanceReportForm.Create(Application);
                TAssessorsTrialBalanceReportForm(Child).InitializeForm;
              end;  {AssessorsTrialBalance report}

            AssessorsVerificationReport:
              begin
                Child := TAssessorsVerificationReportForm.Create(Application);
                TAssessorsVerificationReportForm(Child).InitializeForm;
              end;  {Assessors report}

              {CHG05011998-2: Add building permit report}

            BuildingPermitReport:
              begin
                Child := TBldgPermitReportForm.Create(Application);
                TBldgPermitReportForm(Child).InitializeForm;
              end;  {Building permit report}

            ExemptionReport:
              begin
                Child := TExemptionReportForm.Create(Application);
                TExemptionReportForm(Child).InitializeForm;
              end;  {Exemption report}

            ExemptionComparisonReport:
              begin
                Child := TCompareExemptionsForm.Create(Application);
                TCompareExemptionsForm(Child).InitializeForm;
              end;  {Exemptions comparison report}

            ExemptionImpactReport:
              begin
                Child := TfmExemptionImpactReport.Create(Application);
                TfmExemptionImpactReport(Child).InitializeForm;
              end;

            ExemptionStatusReport:
              begin
                Child := TExemptionStatusReportForm.Create(Application);
                TExemptionStatusReportForm(Child).InitializeForm;
              end;  {Exemptions status report}

              {CHG04221998-1: Add special district report.}

            SpecialDistrictReport:
              begin
                Child := TSpecialDistrictReportForm.Create(Application);
                TSpecialDistrictReportForm(Child).InitializeForm;
              end;  {Exemption report}

              {FXX04081999-6: Trace split\merges.}

            SplitMergeReport:
              begin
                Child := TSplitMergeReportForm.Create(Application);
                TSplitMergeReportForm(Child).InitializeForm;
              end;  {Exemption report}

            ValueComparisonReport:
              begin
                Child := Tfm_ValueComparisonReport.Create(Application);
                Tfm_ValueComparisonReport(Child).InitializeForm;
              end;

            ThirdPartyNotificationReport:
               begin
                Child := TThirdPartyNotificationReport.Create(Application);
                TThirdPartyNotificationReport(Child).InitializeForm;
              end;  {Third Party Notification}

            TopTaxpayerReport:
              begin
                Child := TTopTaxpayerReportForm.Create(Application);
                TTopTaxpayerReportForm(Child).InitializeForm;
              end;  {Top taxpayer report}

            GrievanceAuditReport :
              begin
                Child := TGrievanceAuditTrailForm.Create(Application);
                TGrievanceAuditTrailForm(Child).InitializeForm;
              end;  {GrievanceAuditReport}

            GrievanceLetters :
              begin
                Child := TGreivanceLettersForm.Create(Application);
                TGreivanceLettersForm(Child).InitializeForm;
              end;  {GrievanceLettersReports}

            GrievanceSummaryReport :
              begin
                Child := TGrievanceSummaryReportForm.Create(Application);
                TGrievanceSummaryReportForm(Child).InitializeForm;
              end;  {Grievance summary report}

            GrievanceResultsByBOARReport :
              begin
                Child := TGrievanceResultsByBoardMemberReport.Create(Application);
                TGrievanceResultsByBoardMemberReport(Child).InitializeForm;
              end;  {GrievanceResultsByBOARReport}

            SmallClaimsSummaryReport :
              begin
                Child := TSmallClaimsSummaryReportForm.Create(Application);
                TSmallClaimsSummaryReportForm(Child).InitializeForm;
              end;  {Small Claims summary report}

            SmallClaimsCalendarReport :
              begin
                Child := TSmallClaimsCalendarReportForm.Create(Application);
                TSmallClaimsCalendarReportForm(Child).InitializeForm;
              end;

            CertiorariSummaryReport :
              begin
                Child := TCertiorariSummaryReportForm.Create(Application);
                TCertiorariSummaryReportForm(Child).InitializeForm;
              end;  {Certiorari summary report}

            CertiorariCalendarReport :
              begin
                Child := TCertiorariCalendarReportForm.Create(Application);
                TCertiorariCalendarReportForm(Child).InitializeForm;
              end;  {Certiorari Calendar report}

            CertiorariHistoryReport :
              begin
                Child := TCertiorariHistoryReportForm.Create(Application);
                TCertiorariHistoryReportForm(Child).InitializeForm;
              end;  {Certiorari History Report}

            GrievanceNotesReport,
            SmallClaimsNotesReport,
            CertiorariNotesReport :
              begin
                Child := TGrievance_SmallClaims_Certiorari_NotesReportForm.Create(Application);

                case Tag of
                  GrievanceNotesReport : TGrievance_SmallClaims_Certiorari_NotesReportForm(Child).GrievanceType := 'G';
                  SmallClaimsNotesReport : TGrievance_SmallClaims_Certiorari_NotesReportForm(Child).GrievanceType := 'S';
                  CertiorariNotesReport : TGrievance_SmallClaims_Certiorari_NotesReportForm(Child).GrievanceType := 'C';
                end;

                TGrievance_SmallClaims_Certiorari_NotesReportForm(Child).InitializeForm;

              end;  {GrievanceNotesReport...}

            RemovedExemptionsReport :
              begin
                Child := TRemovedExemptionReportForm.Create(Application);
                TRemovedExemptionReportForm(Child).InitializeForm;
              end;

            GeneralizedComparisonReport :
              begin
                Child := TGeneralizedComparisonReportForm.Create(Application);
                TGeneralizedComparisonReportForm(Child).InitializeForm;
              end;

            OverallGrievance_SmallClaims_Certiorari_Report :
              begin
                Child := TGrievance_SmallClaims_Certiorari_SummaryReportForm.Create(Application);
                TGrievance_SmallClaims_Certiorari_SummaryReportForm(Child).InitializeForm;
              end;  {Certiorari Calendar report}

            ChangeAssessmentLetter:
             begin
               Child := TAsmtChangeLetterPrintForm.Create(Application);
               TAsmtChangeLetterPrintForm(Child).InitializeForm;
             end;  {SearchReport}

            AuditTrailReport:
              begin
                Child := TRptAuditTrailForm.Create(Application);
                TRptAuditTrailForm(Child).FormAccessRights := DetermineFormAccessRights(Tag);
                TRptAuditTrailForm(Child).InitializeForm;
              end;  {Display roll totals}

            NameAddressAuditTrailReport:
              begin
                Child := TRptNameAddressAuditTrailForm.Create(Application);
                TRptNameAddressAuditTrailForm(Child).InitializeForm;
              end;  {Name \ addr audit report}

            SalesReport:
              begin
                Child := TRptSalesReportingForm.Create(Application);
                TRptSalesReportingForm(Child).FormAccessRights := DetermineFormAccessRights(Tag);
                TRptSalesReportingForm(Child).InitializeForm;
              end;  {Display roll totals}

            SalesAndRemovedExemptionsReport:
              begin
                Child := TReportSalesAndRemovedExemptionsForm.Create(Application);
                TReportSalesAndRemovedExemptionsForm(Child).InitializeForm;
              end;

              {CHG02041998-1: Add sales analysis report.}

            SalesAnalysisReport:
              begin
                Child := TSalesAnalysisForm.Create(Application);
                TSalesAnalysisForm(Child).InitializeForm;
              end;  {Sales analysis}

            NotesReport:
              begin
                Child := TNotesReportForm.Create(Application);
                TNotesReportForm(Child).FormAccessRights := DetermineFormAccessRights(Tag);
                TNotesReportForm(Child).InitializeForm;
              end;  {NotesDueForActionReport}

            ParcelInfoReport:
              begin
                Child := TParcelInformationPrintForm.Create(Application);
                TParcelInformationPrintForm(Child).InitializeForm;
              end;  {ParcelInfoReport}

            PictureReport:
              begin
                Child := TfmPictureAndPropertyCardReport.Create(Application);
                TfmPictureAndPropertyCardReport(Child).InitializeForm;
              end;  {PictureReport}

            SearchReport:
              begin
                Child := TSearchReportForm.Create(Application);
                TSearchReportForm(Child).InitializeForm;
              end;  {SearchReport}

            ExemptionLetter:
              begin
                Child := TExemptionLetterPrintForm.Create(Application);
                TExemptionLetterPrintForm(Child).InitializeForm;
              end;  {SearchReport}

            GenericLetters:
              begin
                Child := TGenericLetterPrintForm.Create(Application);
                TGenericLetterPrintForm(Child).InitializeForm;
              end;  {Generic letters}

            Labels:
              begin
                Child := TLabelsForm.Create(Application);
                TLabelsForm(Child).InitializeForm;
              end;  {Labels}

            DisplayRollTotals:
              begin
                Child := TRollTotalDisplayForm.Create(Application);
                TRollTotalDisplayForm(Child).FormAccessRights := DetermineFormAccessRights(Tag);
                TRollTotalDisplayForm(Child).InitializeForm;
              end;  {Display roll totals}

            BillCollectionControlCreate:
              begin
                Child := TBillFileControlForm.Create(Application);
                TBillFileControlForm(Child).FormAccessRights := DetermineFormAccessRights(Tag);
                TBillFileControlForm(Child).InitializeForm;
              end;  {Display roll totals}

            LoadArrearsFlags:
            If glblUsesSQLTax
            then
              begin
                Child := TLoadArrearsFlagsFromSQLTaxesForm.Create(Application);
                TLoadArrearsFlagsFromSQLTaxesForm(Child).InitializeForm;
              end  {Load Arrears flags}
            else
              begin
                Child := TLoadArrearsFlagsFromTaxesForm.Create(Application);
                TLoadArrearsFlagsFromTaxesForm(Child).InitializeForm;
              end;  {Load Arrears flags}

            BillCollectionRates:
              begin
                Child := TBillRatesForm.Create(Application);
                TBillRatesForm(Child).FormAccessRights := DetermineFormAccessRights(Tag);
                TBillRatesForm(Child).InitializeForm;
              end;  {Display roll totals}

            BillCalculation:
              begin
                Child := TBillCalcForm.Create(Application);
                TBillCalcForm(Child).InitializeForm;
              end;  {Display roll totals}

            BillPrintRoll:
              begin
                Child := TBillPrintRollForm.Create(Application);
                TBillPrintRollForm(Child).InitializeForm;
              end;  {Display roll totals}

            CoopTaxRoll:
              begin
                Child := Tfm_CooperativeRollPrint.Create(Application);
                Tfm_CooperativeRollPrint(Child).InitializeForm;
              end;

            MtPleasantTownPrintBills,
            MtPleasantSchoolPrintBills,
            HastingsPrintBills,
            WesleyPrintBills,
            SomersTownPrintBills,
            RyeCityPrintBills,
            RyeCountyPrintBills,
            RyeSchoolPrintBills,
            SomersSchoolPrintBills,
            LawrenceVillagePrintBills,
            BrookvilleVillagePrintBills,
            ScarsdaleVillage_CountyPrintBills,
            RyeCity_CountyPrintBills,
            MalvernePrintBills,
            EastchesterSchoolPrintBills,
            ScarsdaleSchoolPrintBills,
            SuffernSewerPrintBills,
            EastchesterTownPrintBills,
            SuffernSewerSecondHalfPrintBills,
            LakeSuccessPrintBills,
            EastHamptonPrintBills,
            SouthamptonPrintBills,
            TarrytownPrintBills,
            MasticBeachPrintBills :
              begin
                Child := TPrintBillsForm.Create(Application);
                TabName := 'Print Bills';

                  {FXX03032004-3(2.07l2): Move the assignment of the bill type to before the InitializeForm.}

                case Tag of
                  MtPleasantTownPrintBills : TPrintBillsForm(Child).BillType := btMtPleasantTown;
                  MtPleasantSchoolPrintBills : TPrintBillsForm(Child).BillType := btMtPleasantSchool;
                  HastingsPrintBills : TPrintBillsForm(Child).BillType := btHastings;
                  WesleyPrintBills : TPrintBillsForm(Child).BillType := btWesleyHills;
                  SomersTownPrintBills : TPrintBillsForm(Child).BillType := btSomersTown;
                  RyeCityPrintBills : TPrintBillsForm(Child).BillType := btRyeCity;
                  RyeCountyPrintBills : TPrintBillsForm(Child).BillType := btRyeCounty;
                  RyeSchoolPrintBills : TPrintBillsForm(Child).BillType := btRyeSchool;
                  SomersSchoolPrintBills : TPrintBillsForm(Child).BillType := btSomersSchool;
                  LawrenceVillagePrintBills : TPrintBillsForm(Child).BillType := btLawrenceVillage;
                  BrookvilleVillagePrintBills : TPrintBillsForm(Child).BillType := btBrookvilleVillage;
                  ScarsdaleVillage_CountyPrintBills : TPrintBillsForm(Child).BillType := btScarsdaleVillage_County;
                  RyeCity_CountyPrintBills : TPrintBillsForm(Child).BillType := btRyeCity_County;
                  MalvernePrintBills : TPrintBillsForm(Child).BillType := btMalverne;
                  EastchesterSchoolPrintBills : TPrintBillsForm(Child).BillType := btEastchesterSchool;
                  ScarsdaleSchoolPrintBills : TPrintBillsForm(Child).BillType := btScarsdaleSchool;
                  SuffernSewerPrintBills : TPrintBillsForm(Child).BillType := btSuffernSewer;
                  EastchesterTownPrintBills : TPrintBillsForm(Child).BillType := btEastchesterTown;
                  SuffernSewerSecondHalfPrintBills : TPrintBillsForm(Child).BillType := btSuffernSewer2ndHalf;
                  LakeSuccessPrintBills : TPrintBillsForm(Child).BillType := btLakeSuccess;
                  EastHamptonPrintBills : TPrintBillsForm(Child).BillType := btEastHampton;
                  SouthamptonPrintBills : TPrintBillsForm(Child).BillType := btSouthampton;
                  TarrytownPrintBills : TPrintBillsForm(Child).BillType := btTarrytown;
                  MasticBeachPrintBills : TPrintBillsForm(Child).BillType := btMasticBeach;

                end;  {case Tag of}

                TPrintBillsForm(Child).InitializeForm;

              end;  {Print bills}

            RyeBillExtract :
              begin
                Child := TRyeBillExtractForm.Create(Application);
                TRyeBillExtractForm(Child).InitializeForm;
              end;

            SDExtensionCodeMaint:
              begin
                Child := TSpecialDistrictExtensionCodesForm.Create(Application);
                TSpecialDistrictExtensionCodesForm(Child).FormAccessRights := DetermineFormAccessRights(Tag);
                TSpecialDistrictExtensionCodesForm(Child).InitializeForm;
              end;  {SDExtensionCodeMaint}

            BoardDenialReasonMaint:
              begin
                Child := TBOARDenialReasonCodeForm.Create(Application);
                TBOARDenialReasonCodeForm(Child).FormAccessRights := DetermineFormAccessRights(Tag);
                TBOARDenialReasonCodeForm(Child).InitializeForm;
              end;  {BOARDenialReasonMaint}

            BoardDispositionMaint:
              begin
                Child := TBOARDispositionCodeForm.Create(Application);
                TBOARDispositionCodeForm(Child).FormAccessRights := DetermineFormAccessRights(Tag);
                TBOARDispositionCodeForm(Child).InitializeForm;
              end;  {BOARDispositionMaint}

            SmallClaim_Cert_DispositionMaint:
              begin
                Child := TfmSmallClaims_CertiorariDispositionCodes.Create(Application);
                TfmSmallClaims_CertiorariDispositionCodes(Child).FormAccessRights := DetermineFormAccessRights(Tag);
                TfmSmallClaims_CertiorariDispositionCodes(Child).InitializeForm;
              end;  {BOARDispositionMaint}

            BoardMemberMaint:
              begin
                Child := TBOARMemberCodeForm.Create(Application);
                TBOARMemberCodeForm(Child).FormAccessRights := DetermineFormAccessRights(Tag);
                TBOARMemberCodeForm(Child).InitializeForm;
              end;  {BOARMemberMaint}

            LawyerCodeMaint:
              begin
                Child := TLawyerCodeForm.Create(Application);
                TLawyerCodeForm(Child).FormAccessRights := DetermineFormAccessRights(Tag);
                TLawyerCodeForm(Child).InitializeForm;
              end;  {LawyerCodeMaint}

            ComplaintReasonCodeMaint:
              begin
                Child := TPetitionerComplaintSubreasonCodeForm.Create(Application);
                TPetitionerComplaintSubreasonCodeForm(Child).FormAccessRights := DetermineFormAccessRights(Tag);
                TPetitionerComplaintSubreasonCodeForm(Child).InitializeForm;
              end;  {ComplaintReasonCodeMaint}

            DeleteAParcel:
              begin
                Child := TParcelDeleteForm.Create(Application);
                TParcelDeleteForm(Child).FormAccessRights := DetermineFormAccessRights(Tag);
                TParcelDeleteForm(Child).InitializeForm;
              end;  {DeleteAParcel}

            ReactivateAParcel:
              begin
                Child := TParcelReactivateForm.Create(Application);
                TParcelReactivateForm(Child).FormAccessRights := DetermineFormAccessRights(Tag);
                TParcelReactivateForm(Child).InitializeForm;
              end;  {ReactivateAParcel}

            SplitMerge:
              begin
                Child := TKeyChangeForm.Create(Application);
                TKeyChangeForm(Child).FormAccessRights := DetermineFormAccessRights(Tag);
                TKeyChangeForm(Child).InitializeForm;
              end;  {SysRecMaint}

            _147155FileExtract:
              begin
                Child := TRPS155FileExtractForm.Create(Application);
                TRPS155FileExtractForm(Child).InitializeForm;
              end;  {_147155FileExtract}

             _995FileExtract:
              If (FormCaptions.Count > 0)
                then
                  begin
                    MessageDlg('Please close all other tabs in the Property Assessment System' + #13 +
                               'before running the 995 file extract.', mtError, [mbOK], 0);

                      {Release the lock on the window update and abort.}

                    LockWindowUpdate(0);
                    Aborted := True;

                  end
                else
                  begin
                    Child := TRPS995FileExtractForm.Create(Application);
                    TRPS995FileExtractForm(Child).InitializeForm;
                  end;

            GeneralizedFileExtract:
              begin
                Child := TGeneralizedExtractForm.Create(Application);
                TGeneralizedExtractForm(Child).InitializeForm;
              end;  {GeneralizedFileExtract}

            LaserBillFileExtract:
              begin
                Child := TCreateRPS160ExtractForm.Create(Application);
                TCreateRPS160ExtractForm(Child).InitializeForm;
              end;  {LaserBillFileExtract}

            LoadPictures_Documents:
              begin
                Child := TAutoLoadPicturesAndDocumentsForm.Create(Application);
                TAutoLoadPicturesAndDocumentsForm(Child).InitializeForm;
              end;  {LoadPictures_Documents}

            LoadPicturesFromLoadingDock :
              begin
                Child := TImportPicturesFromLoadingDockForm.Create(Application);
                TImportPicturesFromLoadingDockForm(Child).InitializeForm;
              end;

             ImportBankCodes:
              begin
                Child := TImportBankCodeForm.Create(Application);
                TImportBankCodeForm(Child).InitializeForm;
              end;  {ReactivateAParcel}

            UserProfile:
              begin
                Child := TUserProfileForm.Create(Application);
                TUserProfileForm(Child).FormAccessRights := DetermineFormAccessRights(Tag);
                TUserProfileForm(Child).InitializeForm;
              end;  {UserProfile}

            CalculateRollTotals:
              begin
                Child := TRollTotalCalculateForm.Create(Application);
                TRollTotalCalculateForm(Child).FormAccessRights := DetermineFormAccessRights(Tag);
                TRollTotalCalculateForm(Child).InitializeForm;
              end;  {RollTotals}

            CompareParcelIDsBetweenSCASystems :
              begin
                Child := TParcelIDComparisonReportForm.Create(Application);
                TParcelIDComparisonReportForm(Child).InitializeForm;
              end;  {Compare IDs}

            ClearArrearsFlags:
              begin
                Child := TClearArrearsFlagForm.Create(Application);
                TClearArrearsFlagForm(Child).InitializeForm;
              end;  {Clear Arrears Flag}

             {CHG03171998-2: Remove update PAS system from menu and add SD broadcast.}

            SDBroadcast:
              begin
                Child := TSDBroadcastForm.Create(Application);
                TSDBroadcastForm(Child).InitializeForm;
              end;  {SD Broadcast}

            TransferCoopValues:
              begin
                Child := TCooperativeValuesTransferForm.Create(Application);
                TCooperativeValuesTransferForm(Child).InitializeForm;
              end;  {Transfer cooperative values}

            TransferCoopSTARValues:
              begin
                Child := TCooperativeSTARSavingsValuesTransferForm.Create(Application);
                TCooperativeSTARSavingsValuesTransferForm(Child).InitializeForm;
              end;  {Transfer cooperative values}

            SDComparisonReport:
              begin
                Child := TCompareSpecialDistrictsForm.Create(Application);
                TCompareSpecialDistrictsForm(Child).InitializeForm;
              end;

            BroadcastChanges:
              begin
                Child := TBroadcastForm.Create(Application);
                TBroadcastForm(Child).InitializeForm;
              end;  {SD Broadcast}


            ParcelSummaryWithSketch :
              begin
                Child := TParcelInformationWithSketchPrintForm.Create(Application);
                TParcelInformationWithSketchPrintForm(Child).InitializeForm;
              end;

            BroadcastAVChanges :
              begin
                Child := TBroadcastAssessmentChangeForm.Create(Application);
                TBroadcastAssessmentChangeForm(Child).InitializeForm;
              end;

            ExemptionBroadcast:
              begin
                Child := TExemptionBroadcastForm.Create(Application);
                TExemptionBroadcastForm(Child).InitializeForm;
              end;  {EX Broadcast}

(*            UpdateIndividualSettings:
              begin
                Child := TUpdateIndividualSettingsForm.Create(Application);
                TUpdateIndividualSettingsForm(Child).InitializeForm;
              end;  {Update Settings} *)

            UpdateNamesAndAddresses:
              begin
                Child := TUpdateNamesAndAddressesInSCASystemsForm.Create(Application);
                TUpdateNamesAndAddressesInSCASystemsForm(Child).InitializeForm;
              end;  {Update Names and Addresses}

            CoopBuildingMaintenance:
              begin
                Child := TfmCooperativeBuildings.Create(Application);
                TfmCooperativeBuildings(Child).InitializeForm;
              end;

            YearEndRollOver:
              begin
                Child := TYearEndRollOverForm.Create(Application);
                TYearEndRollOverForm(Child).FormAccessRights := DetermineFormAccessRights(Tag);
                TYearEndRollOverForm(Child).InitializeForm;
              end;  {RollTotals}

            MtVernonTaxExtract:
              begin
                Child := TMtVernonTaxExtractForm.Create(Application);
                TMtVernonTaxExtractForm(Child).InitializeForm;
              end;  {Tax Extract}

(*            RecreateSalesExtract:
              begin
                Child := TRecreateSalesExtractForm.Create(Application);
                TRecreateSalesExtractForm(Child).InitializeForm;
              end;  {Recreate Sales Extract} *)

             STARExtract:
               begin
                 Child := TSTARRenewalExtractForm.Create(Application);
                 TSTARRenewalExtractForm(Child).InitializeForm;
               end;  {STARExtract}

             FreeportTaxExtract:
               begin
                 Child := TFreeportTaxExtractForm.Create(Application);
                 TFreeportTaxExtractForm(Child).InitializeForm;
               end;

            ImportIVPStatusFromDTF :
              begin
                Child := TImportIVPStatusFileForm.Create(Application);
                TImportIVPStatusFileForm(Child).InitializeForm;
              end;

            UpdateVillageNameAddressExport :
              begin
                Child := TUpdateVillagesNameAndAddress_ExportForm.Create(Application);
                TUpdateVillagesNameAndAddress_ExportForm(Child).InitializeForm;
              end;

            UpdateVillageNameAddressImport :
              begin
                Child := TUpdateVillagesNameAndAddress_ImportForm.Create(Application);
                TUpdateVillagesNameAndAddress_ImportForm(Child).InitializeForm;
              end;

            YorktownNameAddressExport :
              begin
                Child := TYorktownNameAddressExtractForm.Create(Application);
                TYorktownNameAddressExtractForm(Child).InitializeForm;
              end;

            LoadNassauCountyValues : Child := Tfm_NassauCountyDiskLoad.Create(Application);

              {CHG06282007-1(2.11.1.42)[I754]: Add an extract for the DTF extract.}

            NYSORPSCoopExtract :
              begin
                Child := Tfm_NYSORPSCooperativeExtract.Create(Application);
                Tfm_NYSORPSCooperativeExtract(Child).InitializeForm;
              end;

            MiddleClassSTARExtract :
              begin
                Child := TfmMiddleClassSTARRebateExtract.Create(Application);
                TfmMiddleClassSTARRebateExtract(Child).InitializeForm;
              end;

            ProrataCalculation :
              begin
                Child := TCalculateProrataInformationForm.Create(Application);
                TCalculateProrataInformationForm(Child).InitializeForm;
              end;

            ProrataList :
              begin
                Child := TProrataReportForm.Create(Application);
                TProrataReportForm(Child).InitializeForm;
              end;

            ProrataWorksheets :
              begin
                Child := Tfm_ProrataWorksheets.Create(Application);
                Tfm_ProrataWorksheets(Child).InitializeForm;
              end;

            ProrataLetters :
              begin
                Child := TProrataLettersForm.Create(Application);
                TProrataLettersForm(Child).InitializeForm;
              end;

            ProrataMoveValues :
              begin
                Child := TTransferProrataAmountsForm.Create(Application);
                TTransferProrataAmountsForm(Child).InitializeForm;
              end;

            ReportManager:
              begin
                Child := TReportManagerForm.Create(Application);
                TReportManagerForm(Child).InitializeForm;
              end;  {Report Manager}

            SalesExtractLog :
              begin
                Child := TSalesExtractLogForm.Create(Application);
                TSalesExtractLogForm(Child).InitializeForm;
              end;  {Sales extract log}

            SFLARecalculation :
              begin
                Child := TRecalculateSquareFootLivingAreaForm.Create(Application);
                TRecalculateSquareFootLivingAreaForm (Child).InitializeForm;
              end;  {SFLA Recalc}

            _TaskList:
              begin
                Child := TTaskListForm.Create(Application);
                TTaskListForm(Child).FormAccessRights := DetermineFormAccessRights(Tag);
                TTaskListForm(Child).InitializeForm;
              end;  {_TaskList}

            SecurityLevels:
              begin
                Child := TMenuSecurityForm.Create(Application);
                TMenuSecurityForm(Child).FormAccessRights := DetermineFormAccessRights(Tag);
                TMenuSecurityForm(Child).InitializeForm;

                  {Now, we need a copy of the menu id's and menu captions
                   for al TMenuItems.}

                TMenuSecurityForm(Child).MainMenuIDs := TStringList.Create;
                TMenuSecurityForm(Child).MainMenuDescriptions := TStringList.Create;

                  {We will loop through all the components on the
                   main form looking for TMenuItems. When we find
                   one, we will put the tag in the MainMenuIDs
                   string list and the captions (minus the '&')
                   in the MainMenuDescriptions string list. The
                   MainMenuIDs and MainMenuDescriptions string
                   lists are public properties of the
                   TMenuSecurityForm class. See the form for details
                   on how they are used.}

                For I := 0 to (ComponentCount - 1) do
                  If (Components[I] is TMenuItem)
                    then
                      with Components[I] as TMenuItem do
                        begin
                          TMenuSecurityForm(Child).MainMenuIDs.Add(IntToStr(Tag));
                          TMenuSecurityForm(Child).MainMenuDescriptions.Add(StripChar(Caption, '&', ' ', False));
                        end;

              end;  {SecurityLevels:}

(*            GenerateScreenLabels :
              begin
                Child := TGenerateScreenLabelFileForm.Create(Application);
                TGenerateScreenLabelFileForm(Child).FormAccessRights :=
                   DetermineFormAccessRights(Tag);
                TGenerateScreenLabelFileForm(Child).InitializeForm;

              end;  {RollTotals}*)

            ExemptionsRecalc :
              begin
                Child := TExemptionRecalculationForm.Create(Application);
                TExemptionRecalculationForm(Child).InitializeForm;
              end;  {EX Recalc}

           GrievanceBulkUpdate:
              begin
                Child := TGrievanceResultsBulkUpdateForm.Create(Application);
                TGrievanceResultsBulkUpdateForm(Child).InitializeForm;
              end;  {GrievanceBulkUpdate}

           CompFileCreate:
              begin
                Child :=  TCreateComparablesFileForm.Create(Application);
                TCreateComparablesFileForm(Child).FormAccessRights := DetermineFormAccessRights(Tag);
                TCreateComparablesFileForm(Child).InitializeForm;
              end;  {Comp File Create}

            CreateSketchesForSearcher :
              begin
                Child := TCreateSketchFilesForSearcherForm.Create(Application);
                TCreateSketchFilesForSearcherForm(Child).InitializeForm;
              end;

            RestrictSearcherParcels:
              begin
                Child := TTRestrictParcelsForSearcherViewForm.Create(Application);
                TTRestrictParcelsForSearcherViewForm(Child).FormAccessRights := DetermineFormAccessRights(Tag);
                TTRestrictParcelsForSearcherViewForm(Child).InitializeForm;
              end;  {Restrict parcels}

            ExemptionPurge:
              begin
                Child := TfmRemoveNonRenewedExemptions.Create(Application);
                TfmRemoveNonRenewedExemptions(Child).InitializeForm;
              end;

(*            CompDisplay:
              begin
                Child :=  TComparativesDisplayForm.Create(Application);
                TComparativesDisplayForm(Child).FormAccessRights := DetermineFormAccessRights(Tag);
                TComparativesDisplayForm(Child).InitializeForm;
              end;  {Comp Display} *)

          end;  {case Tag of}

        except
          NonBtrvSystemSupport(011, 0, 'Error creating form.',
                               UnitName, GlblErrorDlgBox);
          (*Child.Free;*)
          Aborted := True;
        end;

        If not Aborted
          then
            begin
              If (Child <> nil)
                then Child.WindowState := wsMaximized; {make child fit in parent window}
              NumOccurrences := NumOccurrences + 1;

                {Now, if there is more than one occurrence of this form, then
                 we want to label the Tab and caption of the form with the number
                 of this occurrence.}

              If AllowMoreThanOneInstance
                then
                  begin
                    Child.Caption := Child.Caption + ' ' + IntToStr(NumOccurrences);
                    TabName := TabName + ' ' + IntToStr(NumOccurrences);
                  end;

                {Now add this Tab to the Tab set, and select it.}

              AddTab(TabName, Child.Caption);
              SelectTab(TabName);
                {If the user info panel is visible, then we want to hide it so
                 that it does not show on top.}

              If UserInfoPanel.Visible
                then UserInfoPanel.Visible := False;

                {CHG05131999-2: Let people look up parcels from the parcel list.}
                {Keep track of a parcel maint if it is active.}

              GlblParcelMaintenance := nil;

              Child.Show;        {this shows my form}
              LockWindowUpdate(0);  {Now draw the child.}
              Cursor := crDefault;

            end;  {If not Aborted}

      end
    else
      begin
        ShowOccurrence(TabName);
        SelectTab(TabName);
      end;

end;  {NormalMenuItemClick}

{==============================================================================}
Procedure TMainPASForm.ParcelClick(Sender: TObject);

{These items all have an offset of 4000.
 The popup menu items (in PARCLTAB.PAS) have an offset of 5000 - 5400.}

const
  AddAParcel = 4010;
  ModifyAParcel = 4030;
  ViewAParcel = 4050;

var
  Child: TParcelTabForm;
  AllowMoreThanOneInstance : Boolean;
  TabName : String;
  NumOccurrences : Integer;
  EditMode : Char;  {Add/Modify/View}

begin
  Child := nil;
  AllowMoreThanOneInstance := False;
  EditMode := 'V';

    {Let's figure out the mode for the Parcel Maintenance
     (i.e. Add/Modify/View). We will do this by looking at the
     caption of the Sender. We will use this information to
     set the Mode property of the ParcelTabForm.

     We will also use this information to set the TabName to
     reflect the mode that we are in.}

  If (Pos('Add', TMenuItem(Sender).Caption) <> 0)
    then EditMode := 'A';

  If (Pos('Modify', TMenuItem(Sender).Caption) <> 0)
    then EditMode := 'M';

  If (Pos('View', TMenuItem(Sender).Caption) <> 0)
    then
      begin
        EditMode := 'V';

          {FXX02021999-3: Do not allow more than one view for searchers.}

        If not GlblUserIsSearcher
          then AllowMoreThanOneInstance := True;
      end;

  case EditMode of
    'A' : TabName := 'Add';
    'M' : TabName := 'Modify';
    'V' : TabName := 'View';

  end;  {case EditMode of}

  NumOccurrences := FindNumOccurrences(TabName);

    {Only allow 9 parcel views.}

  If (AllowMoreThanOneInstance and
      (NumOccurrences = 9))
    then
      begin
        MessageDlg('You can only view at most 9 parcels at once.' + #13 +
                   'Please close some parcels before trying to view another one.',
                   mtError, [mbOK], 0);
      end
    else
      begin
          {Now if there are no forms of this type already visible, or there is and
           we allow multiple instances of this form, then create a new form. Otherwise,
           find the existing form and show it.}

        If ((NumOccurrences = 0) or
            ((NumOccurrences > 0) and
             AllowMoreThanOneInstance))
          then
            begin
              try
                LockWindowUpdate(Handle);  {Prevent drawing of child to avoid flicker.}
                Child := TParcelTabForm.Create(Application);
                TParcelTabForm(Child).FormAccessRights := DetermineFormAccessRights(TComponent(Sender).Tag);
              except
                (*Abort;*)
              end;

              If GlblChildWindowCreateFailed
                then Child.Free
                else
                  begin
                    Child.WindowState := wsMaximized; {make child fit in parent window}

                    NumOccurrences := NumOccurrences + 1;

                      {Now, if there is more than one occurrence of this form, then
                       we want to label the Tab and caption of the form with the number
                       of this occurrence.}

                    If AllowMoreThanOneInstance
                      then
                        begin
                            {Note that the caption here is set a bit differently
                             then the other forms. Whereas the on the other
                             forms, we tack an instance number on the end of
                             the caption name as it was designed, here we are
                             setting the caption to be the same as the tab name.
                             The reason for this is that the ParcelTabForm is used
                             by three different types of parcel maint: (A/M/V).
                             So, we want the caption to reflect the mode. Also, since
                             in the parcel maintenance we are changing the caption to
                             include the SBL of the present parcel, we need a part of the
                             caption to stay constant so that if they switch between instances
                             of the parcel maintenance, we can locate that caption the FormCaptions
                             list even though the caption of the ParcelTabForm for that instance of
                             the parcel maintenance is not what it originally was.}

                          Child.Caption := TabName + ' ' +
                                           IntToStr(NumOccurrences) + ':';
                          TabName := TabName + '-' + IntToStr(NumOccurrences);

                        end;  {If AllowMoreThanOneInstance}

                    Child.Caption := TabName + ':';

                      {Now add this Tab to the Tab set, and select it.}

                    AddTab(TabName, Child.Caption);
                    SelectTab(TabName);

                      {Set the Mode (A/M/V) property in the ParcelTabForm.}

                    TParcelTabForm(Child)._EditMode := EditMode;

                      {If the user info panel is visible, then we want to hide it so
                       that it does not show on top.}

                    If UserInfoPanel.Visible
                      then UserInfoPanel.Visible := False;

                      {CHG05131999-2: Let people look up parcels from the parcel list.}
                      {Keep track of a parcel maint if it is active.}

                    GlblParcelMaintenance := Child;

                    Child.Show;        {this shows my form}

                  end;  {else of If GlblChildWindowCreateFailed}

              LockWindowUpdate(0);  {Now draw the child.}
            end
          else
            begin
              ShowOccurrence(TabName);
              SelectTab(TabName);
            end;

      end;  {else of If (AllowMoreThanOneInstance and ...}

  If GlblChildWindowCreateFailed
    then GlblChildWindowCreateFailed := False;

end;  {ParcelClick}

{===============================================================}
Procedure TMainPASForm.DisplayComparatives1Click(Sender: TObject);

var
  TempComparablesCommandLine : String;
  ComparablesPChar : PChar;
  TempLen : Integer;

begin
    {FXX04232003-2(2.07): Make sure to include full path to outside executables since
                          we may be starting local.}

  TempComparablesCommandLine := GlblDrive + ':' + GlblProgramDir + 'PASComparables.EXE FROMPAS';

  TempLen := Length(TempComparablesCommandLine);
  ComparablesPChar := StrAlloc(TempLen + 1);
  StrPCopy(ComparablesPChar, TempComparablesCommandLine);

  WinExec(ComparablesPChar, SW_SHOW);
  StrDispose(ComparablesPChar);

end;  {DisplayComparatives1Click}

{===============================================================}
Procedure TMainPASForm.Maps1Click(Sender: TObject);

var
  TempMapsCommandLine : String;
  MapsPChar : PChar;
  TempLen : Integer;

begin
    {FXX04232003-2(2.07): Make sure to include full path to outside executables since
                          we may be starting local.}

  TempMapsCommandLine := GlblDrive + ':' + GlblProgramDir + 'PASMappingForm.EXE FROMPAS';

  TempLen := Length(TempMapsCommandLine);
  MapsPChar := StrAlloc(TempLen + 1);
  StrPCopy(MapsPChar, TempMapsCommandLine);

  WinExec(MapsPChar, SW_SHOW);
  StrDispose(MapsPChar);

end;  {Maps1Click}

{===============================================================}
Procedure TMainPASForm.ChangeThisYearandNextYearTogetherClick(Sender: TObject);

{CHG11101997-1: Allow user to set dual processing.}

var
  TempStr : String;
  Index : Integer;
  Continue : Boolean;

begin
  Continue := True;

    {CHG09122001-1: Warning if change TY and NY together.}

  If (ChangeThisYearandNextYearTogether.Checked and
      (MessageDlg('Are you sure you want to stop the automatic' + #13 +
                  'transfer of changes from This Year to Next Year?', mtWarning, [mbYes, mbNo], 0) = idNo))
    then Continue := False
    else AddToTraceFile('', 'MAINFORM', 'CHANGE TY\NY TOGETHER',
                        'TRUE', 'FALSE', Now, OptionalItemsTable);  {Note the table doesn't matter}

  If Continue
    then
      begin
        GlblModifyBothYears := not GlblModifyBothYears;
        ChangeThisYearandNextYearTogether.Checked := not ChangeThisYearandNextYearTogether.Checked;

          {FXX12301999-2: Display if in dual modify.}
          {FXX01202000-3: If did when parcel maint not up, caused a problem.}

        If ((GlblParcelMaintenance <> nil) and
            GlblParcelMaintenance.Active)
          then
            begin
              TempStr := TParcelTabForm(GlblParcelMaintenance).Caption;

              If (not GlblModifyBothYears)
                then
                  begin
                    Index := Pos('Change', TempStr);

                    If (Index > 0)
                      then Delete(TempStr, (Index - 1), 40);

                  end;  {If (not GlblModifyBothYears)}

              If GlblModifyBothYears
                then
                  begin
                    Index := Pos('Change', TempStr);

                    If (Index = 0)
                      then TempStr := TempStr + ' (Change This Year and Next Year)';

                  end;  {If (not GlblModifyBothYears)}

              TParcelTabForm(GlblParcelMaintenance).Caption := TempStr;

            end;  {If ParcelViewOrModifyActive}

      end;  {If Continue}

end;  {ChangeThisYearandNextYearTogetherClick}

{==========================================================================}
Procedure TMainPASForm.LoginClick(Sender: TObject);

var
  I, ReturnCode : Integer;
  CanClose, Proceed, Cancelled : Boolean;

begin
  Proceed := True;
  Cancelled := False;

    {If there is only one MDI child then it is this form, and we don't need to
     ask them about closing all the open menu items.}

  If (Application.MainForm.MDIChildCount > 0)
    then
      begin
        ReturnCode := MessageDlg('Warning! If you login again, ' + #13 +
                                 'all open menu items will be closed.' + #13 +
                                 'Do you want to proceed?', mtWarning,
                                 [mbYes, mbNo], 0);

        Proceed := (ReturnCode = idYes);

      end;  {If (Application.MainForm.MDIChildCount > 1)}

  If Proceed
    then
      If LoginDlg.Execute
        then
          begin
              {CHG03222004-1(2.08): Track user logins.}

            TrackUserLogin(GlblUserName, lgOut);

            SetGlobalUserDefaults(UserProfileTable);  {FXX11211997-5: Use common procedure to make sure all defaults set.}

            TrackUserLogin(GlblUserName, lgIn);

          end
        else Cancelled := True
    else Cancelled := True;

    {If they logged in OK, then let's close all open menu items.}

  If not Cancelled
    then
      begin
        CanClose := True;

          {Close all the other jobs.}

        I := 0;

          {First let's go through each child form and make sure that it
           is ok to close it by calling the CloseQuery method.
           If CloseQuery comes back True for all forms, then we will
           close the forms. However, if CloseQuery comes back False for
           any form, we will not close any forms, and no tax year change
           will be done.}

        while (CanClose and
               (I <= (MDIChildCount - 1))) do
          begin
            CanClose := MDIChildren[I].CloseQuery;
            I := I + 1;

          end;  {while (CanClose and ...}

          {All form's CloseQuery returned True, so now close all the
           child forms. Note that this is not a child form.}

        If CanClose
          then
            For I := 0 to (MDIChildCount - 1) do
              MDIChildren[I].Close;

      end;  {If not Cancelled}

    {Now, if they logged in successfully, we will change the user ID on the
     screen and reset the menu options.}

  If not Cancelled
    then
      begin
        UserIDLabel.Caption := 'ID = ' + GlblUserName;
        UserIDLabel.Left := (UserInfoPanel.Width - UserIDLabel.Width) DIV 2;
        UserIDLabel.Visible := True;

        DetermineAvailableMenuOptions;

          {FXX11181997-1: Need to determine if searcher when change user
                          name to prevent security loophole.}

        GlblUserIsSearcher := UserProfileTable.FieldByName('Searcher').AsBoolean;

          {CHG11071997-2: Limit menu options for searcher.}

        LimitSearcherOptions;

           {CHG10131997-3: Add the notes reminder feature.}
           {Now see which notes are due today or earlier.}

        If (NumNotesOverdue(NotesTable) > 0)
          then
            try
              NotesReminderDialog := TNotesReminderDialog.Create(nil);
              NotesReminderDialog.ShowModal;
            finally
              NotesReminderDialog.Free;
            end;

          {CHG01302002-3: Task list reminders.}

(*        If (NumTaskListItemsOverdue(TaskListTable) > 0)
          then
            try
              TaskListReminderDialog := TTaskListReminderDialog.Create(nil);
              TaskListReminderDialog.ShowModal;
            finally
              TaskListReminderDialog.Free;
            end;*)

        ParcelToolbarForm.InitialPositionSet := False;

      end;  {If not Cancelled}

end;  {LoginClick}

{==================================================================}
Procedure TMainPASForm.SelectTaxRollYear1Click(Sender: TObject);

{CHG11101997-1: Allow user to set dual processing.}

begin
  ChooseTaxYearForm.CurrentTaxYearLabel := CurrentTaxYearLabel;
  ChooseTaxYearForm.MainFormTabSet := TabSet;
  ChooseTaxYearForm.FormCaptions := FormCaptions;
  ChooseTaxYearForm.ChangeThisYearandNextYearTogether := ChangeThisYearandNextYearTogether;
  ChooseTaxYearForm.ShowModal;
  DetermineAvailableMenuOptions;

end;  {SelectTaxRollYear1Click}

{====================================================================}
Procedure TMainPASForm.PrinterSetup1Click(Sender: TObject);

{CHG01211998-1: Allow users to change printer setup off of main menu.
                This will help in printing from parcel screens.}

begin
  PrinterSetupDialog.Execute
end;

{================================================================}
Procedure TMainPASForm.ShowParcelList1Click(Sender: TObject);

begin
  ParcelListDialog.Show;
end;

{================================================================}
Procedure TMainPASForm.BackupPropertyAssessmentData1Click(Sender: TObject);

{CHG11142001-3: Allow for backup of PAS data at any time.}

var
  ZipFileName, TempZipUtilityCommandLine, BackupDirectory : String;
  ZipUtilityPChar : PChar;
  TempLen : Integer;
  Year, Month, Day : Word;

begin
  If (MessageDlg('Are you sure you want to make a backup of the Property Assessment System?',
                 mtConfirmation, [mbYes, mbNo], 0) = idYes)
    then
      begin
        MessageDlg('Please make sure that all users are out of the system before proceeding.',
                   mtWarning, [mbOK], 0);

        BackupDirectory := GlblProgramDir + 'Backups\';

        If not DirectoryExists(BackupDirectory)
          then MkDir(BackupDirectory);

        DecodeDate(Date, Year, Month, Day);

        ZipFileName := 'Property_Assessment_System_Data_' +
                       IntToStr(Year) + '_' + IntToStr(Month) + '_' + IntToStr(Day) + '.zip';

        MessageDlg('PAS will now shut down and a backup utility will appear.' + #13 +
                   'When the backup is complete PAS will automatically restart.',
                   mtInformation, [mbOK], 0);

          {FXX04232003-2(2.07): Make sure to include full path to outside executables since
                                we may be starting local.}

        TempZipUtilityCommandLine := GlblDrive + ':' + GlblProgramDir +
                                     'BackupPAS.EXE FILE=' + ZipFileName +
                                     ' BASE=' + GlblDataDir +
                                     ' DIRECTORY=' + BackupDirectory +
                                     ' ONEXIT=' + GlblProgramDir + 'PAS32.EXE';

        TempLen := Length(TempZipUtilityCommandLine);
        ZipUtilityPChar := StrAlloc(TempLen + 1);
        StrPCopy(ZipUtilityPChar, TempZipUtilityCommandLine);

        GlblApplicationIsTerminatingToDoBackup := True;
        WinExec(ZipUtilityPChar, SW_SHOW);
        StrDispose(ZipUtilityPChar);

        Close;
        Application.MainForm.Close;
        Application.Terminate;

      end;  {If (MessageDlg('Are you sure ...}

end;  {BackupPropertyAssessmentData1Click}

{======================================================}
Procedure TMainPASForm.BDEAdministratorClick(Sender: TObject);

{CHG11232001-1: Allow for launch of the BDE administrator from PAS.}

var
  Registry1 : TRegistry;
  BDEDirectory, TempUtilityCommandLine : String;
  UtilityPChar : PChar;
  TempLen : Integer;

begin
  Registry1 := TRegistry.Create;
  Registry1.RootKey := HKEY_LOCAL_MACHINE;

  If ((MessageDlg('This will open the BDE Administrator to allow modification of the PAS system settings.' + #13 +
                  'This should only be used if you have experience with the BDE or under guidance from SCA.' + #13 +
                  'Do you want to continue?',
                  mtWarning, [mbYes, mbNo], 0) = idYes) and
       Registry1.OpenKey('SOFTWARE\Borland\Borland Shared\', False))
    then
      begin
        GlblApplicationIsTerminatingToDoBackup := True;
        MessageDlg('The Property Assessment System will now shut down and the BDE Administrator will start up.',
                   mtInformation, [mbOK], 0);

        BDEDirectory := Registry1.ReadString('SharedFilesDir');

        If (BDEDirectory[Length(BDEDirectory)] <> '\')
          then BDEDirectory := BDEDirectory + '\';

        TempUtilityCommandLine := BDEDirectory + 'BDE\BDEADMIN.EXE';

        TempLen := Length(TempUtilityCommandLine);
        UtilityPChar := StrAlloc(TempLen + 1);
        StrPCopy(UtilityPChar, TempUtilityCommandLine);

        WinExec(UtilityPChar, SW_SHOW);
        StrDispose(UtilityPChar);
        Close;
        Application.MainForm.Close;
        Application.Terminate;

      end;  {If ((MessageDlg('This ..}

  Registry1.Free;

end;  {BDEAdministratorClick}

(*{======================================================}
Procedure TMainPASForm.UpdateBDESettings1Click(Sender: TObject);

{CHG04102003-4(2.06r): Run alter dbase with parameters to alter the BDE settings for this computer.}

var
  TempUtilityCommandLine : String;
  UtilityPChar : PChar;
  TempLen : Integer;

begin
  GlblApplicationIsTerminatingToDoBackup := True;
    {FXX04232003-2(2.07): Make sure to include full path to outside executables since
                          we may be starting local.}

  TempUtilityCommandLine := GlblDrive + ':' + GlblProgramDir + 'Utilitys\UpdateBDESettings.EXE' +
                            ' BASEDIR=' + GlblProgramDir;

  TempLen := Length(TempUtilityCommandLine);
  UtilityPChar := StrAlloc(TempLen + 1);
  StrPCopy(UtilityPChar, TempUtilityCommandLine);

  WinExec(UtilityPChar, SW_SHOW);
  StrDispose(UtilityPChar);
  Close;
  Application.MainForm.Close;
  Application.Terminate;

end;  {UpdateBDESettings1Click} *)

{================================================================}
Procedure TMainPASForm.EmailPASSupport1Click(Sender: TObject);

{CHG12172003-1(2.07k2): Add email to me.}

begin
  try
    ShellExecute(0, 'open',
                 PChar('mailto: miket@propertyassessmentsystem.com'),
                 nil, nil, SW_NORMAL);
  except
    MessageDlg('Unable to connect to email program.',
               mtError, [mbOk], 0);
  end;

end;  {EmailPASSupport1Click}

{================================================================}
Procedure TMainPASForm.PASWebsite1Click(Sender: TObject);

{CHG01212004-3(2.07l): Link to the wesite.}

begin
  try
    ShellExecute(0, 'open',
                 PChar('http://www.sca-corp.com/pas'),
                 nil, nil, SW_NORMAL);
  except
    MessageDlg('Unable to connect to website.',
               mtError, [mbOk], 0);
  end;

end;  {PASWebsite1Click}

{=========================================================================}
Procedure TMainPASForm.FindUsersNotLoggedOutofSystem1Click(Sender: TObject);

{CHG03222004-1(2.08): Track user logins.}

var
  TempFindUserUtilityCommandLine : String;
  FindUserUtilityPChar : PChar;
  TempLen : Integer;

begin
  TempFindUserUtilityCommandLine := GlblDrive + ':' + GlblProgramDir +
                                    'FindUsersNotLoggedOut.exe';

  TempLen := Length(TempFindUserUtilityCommandLine);
  FindUserUtilityPChar := StrAlloc(TempLen + 1);
  StrPCopy(FindUserUtilityPChar, TempFindUserUtilityCommandLine);

  GlblApplicationIsTerminatingToDoBackup := True;
  WinExec(FindUserUtilityPChar, SW_SHOW);
  StrDispose(FindUserUtilityPChar);

  Close;
  Application.MainForm.Close;
  Application.Terminate;

end;  {FindUsersNotLoggedOutofSystem1Click}

{=========================================================================}
Procedure TMainPASForm.GetyourIPAddress1Click(Sender: TObject);

{CHG02004-3(2.07l): Link to the wesite.}

begin
  try
    ShellExecute(0, 'open',
                 PChar('http://www.whatismyip.com'),
                 nil, nil, SW_NORMAL);
  except
    MessageDlg('Unable to connect to website.',
               mtError, [mbOk], 0);
  end;

end;  {GetyourIPAddress1Click}

{=========================================================================}
Procedure TMainPASForm.FormResize(Sender: TObject);

{CHG09132004-1(2.8.0.11): Adjust info panel to center of screen if it is resized.}

begin
  UserInfoPanel.Left := (Width - UserInfoPanel.Width) DIV 2;
  UserInfoPanel.Top := (Height - UserInfoPanel.Height - (2 * TabSet.Height)) DIV 2;

end;  {FormResize}

{=========================================================================}
Procedure TMainPASForm.CopyTaxRatesfromMainRoll1Click(Sender: TObject);

var
  fmCopyTaxRatesToCoopRoll: TfmCopyTaxRatesToCoopRoll;

begin
  fmCopyTaxRatesToCoopRoll := TfmCopyTaxRatesToCoopRoll.Create(nil);

  try
    fmCopyTaxRatesToCoopRoll.ShowModal;
  finally
    fmCopyTaxRatesToCoopRoll.Free;
  end;

end;  {CopyTaxRatesfromMainRoll1Click}

end.
