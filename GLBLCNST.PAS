unit Glblcnst;

interface

uses Graphics;

const
  GlblOutOfMemoryErrorMsg = 'Out Of Memory.' + #13 + 'Please close some windows and try again.';
  GlblOutOfResourcesErrorMsg = 'Out Of Resources.' + #13 + 'Please close some windows and try again.';

    {Access constants}

  raNoAccess = 0;
  raReadOnly = 1;
  raReadWrite = 2;

    {Processing type constants}
    {FXX04081999-6: Added BothYears constant for use in tracking Split\Merges.}

  NoProcessingType = -1;
  History = 1;
  NextYear = 2;
  ThisYear = 3;
  SalesInventory = 4;
  BothYears = 5;

    {Tax year label color constants}

  ThisYearLabelColor = clBlue;
  NextYearLabelColor = clRed;
  HistoryLabelColor = clGreen;
  SalesInventoryLabelColor = clMaroon;

  ThisYearTabColor = clBlue;
  NextYearTabColor = clWhite;
  HistoryTabColor = clAqua;
  SalesInventoryTabColor = clMaroon;

  ThisYearFontColor = clWhite;
  NextYearFontColor = clBlue;
  HistoryFontColor = clBlack;
  SalesInventoryFontColor = clWhite;

    {Active\Inactive status flags.}

  InactiveParcelFlag = 'D';
  ActiveParcelFlag = 'A';
  ReactivatedParcelFlag = 'R';

    {CHG10091997-1: Allow for blank zeroes in display.}
    {CHG10291997-1: Change CurrencyEditDisplay to blank if it is zero.}

  CurrencyEditDisplay = '0.;0.;''';
  CurrencyNormalDisplay = '"$",0.;"$-",0.';
  CurrencyNormalDisplay_BlankZero = '"$",0.;"$-",0.;''';
  CurrencyDisplayNoDollarSign = ',0.';
  DecimalDisplay = ',0.00;"-",0.00;';
  DecimalEditDisplay = '0.00;"-",0.00;';
  DecimalDisplay_BlankZero = ',0.00;"-",0.00;''';
  DecimalEditDisplay_BlankZero = '0.00;"-"0.00;''';
  NoDecimalDisplay_BlankZero = ',0.;,"-"0.;''';
  NoDecimalDisplay = '0.';
  CurrencyDecimalDisplay = '"$",0.00';
  CurrencyDecimalDisplay_BlankZero = '"$",0.00;"$-",0.00;''';
  ExtendedDecimalDisplay = ',0.000000';
  PercentageDisplay = '0."%"';
  PercentageDisplay_2Decimals = '0.00"%"';

    {FXX05041998-7: Incorrect format for blank zeroes for extended decimal
                    display.}

  ExtendedDecimalDisplay_BlankZero = ',0.000000;,0.000000;''';
  ExtendedDecimalDisplay_NA = ',0.000000;,0.000000;"N\A"';

{FXX02241998-1: Change display format so that when enter field, it
                is blank if zero - add new constants to do this.}
   {FXX07021998-2: The 3 decimal display had an error with blank zero.}

  _3DecimalDisplay = ',0.000;,0.000;''';
  _3DecimalEditDisplay = '0.000;0.000;''';
  _4DecimalDisplay = ',0.0000;,0.0000;''';
  _4DecimalEditDisplay = '0.0000;0.0000;''';
  IntegerDisplay = ',0;,"-"0;''';
  IntegerEditDisplay_NoBlankZero = '0;"-"0';
  IntegerEditDisplay = '0;"-"0;''';

  DecimalDisplayHTE = '.00;"-".00;';
  IntegerDisplayHTE = '0;"-"0;';
  _3DecimalDisplayHTE = '.000;"-",.000;';
  _4DecimalDisplayHTE = '.0000;"-".0000;';


  _1DecimalDisplay = ',0.0;,0.0;''';

  PercentDisplay = '0."%"';
  PercentDisplay_BlankZero = '0."%";-0."%";''';

  DateMask = '!99/99/0000;1;_';
  TimeFormat = 'hh:mm ampm';
  TimeFormatMillisecond = 'hh:mm:ss:zz ampm';
  DateFormat = 'm/d/yyyy';
  _LongDateFormat = 'mm/dd/yyyy';
  LongDateAbbreviatedFormat = 'mmmm d, yyyy';
  DateFormatHTE = 'mmddyyyy';
  
   {Roll Total Taxable Value Types}

  RTCounty = 1;
  RTTown = 2;
  RTVillage = 3;
  RTSchool = 4;

     {exemption totals array indexs for ExemptionTotalsArrayType}
     {in PASTypes.pas}
  EXCounty = 1;
  EXTown = 2;
  EXMunicipal = 2;
  EXVillage = 3;
  EXSchool = 4;

    {Municipality types. Note that town and city are really the same
     for roll and exemption purposes, but sometimes we want a prompt
     to say "City" instead of "Town".}

  MTCounty = 1;
  MTTown = 2;
  MTVillage = 3;
  MTSchool = 4;
  MTCity = 5;
  MTNone = 6;

    {used by PSDCDMNT.PAS to ascertain type of SD Ext Code}
  SDistCategoryDIMN = 'DIMN';
  SdistCategoryUNIT = 'UNIT';
  SDistCategorySTUN = 'STUN';
  SDistCategoryADVL = 'ADVL';
  SDistCategoryFIXD = 'FIXD';
   {Advalorum}
  SDistEcIM = 'IM';
  SDistEcLD = 'LD';
  SDistEcTO = 'TO';
   {Units}
  SDistEcUN = 'UN';
  SDistEcSU = 'SU';
   {Dimensions}
  SDistEcAC = 'AC';
  SDistEcFR = 'FR';
  SDistEcSQ = 'SQ';
   {Fixed}
  SdistEcMT = 'MT';
  SDistEcFE = 'FE';
   {Stepped Unitary}
  SDistEcF1 = 'F1';
  SDistEcF2 = 'F2';
  SDistEcF3 = 'F3';
  SDistEcF4 = 'F4';
  SDistEcU1 = 'U1';
  SDistEcU2 = 'U2';
  SDistEcU3 = 'U3';
  SDistEcU4 = 'U4';
  SDistEcS1 = 'S1';
  SDistEcS2 = 'S2';
  SDistEcS3 = 'S3';
  SDistEcS4 = 'S4';

     {SD Ext Categories}
  SDExtCatA = 'A';   {ad valorum}
  SDExtCatU = 'U';  {unitary}
  SDExtCatD = 'D'; {dimensions}
  SDExtCatF = 'F'; {fixed}
  SDExtCatS = 'S'; {stepped unitary}

   {exemption calc codes}
  EXCMethF  = 'F';     {fixed}
  EXCMethI  = 'I';     {Improve val}
  EXCMethL  = 'L';     {land val}
  EXCMethO  = 'O';     {other}
  EXCMethP  = 'P';     {Fixed %}
  EXCMethT  = 'T';     {total val}
  EXCMethV  = 'V';     {variable amount}

   {parcel special dist calc codes}
  PrclSDCcS   = 'S';    {assessed val override}
  PrclSDCcE   = 'E';    {taxable val override}
  PrclSDCcT   = 'T';    {precalc tax}
  PrclSDCcR   = 'R';    {relevy tax}
  PrclSDCcU   = 'U';    {seconday unitarytax}

  SDAdValorumType  = 'A';
  SDSpclAssessmentType = 'S';
  SDVillageSpclAssessmentType = 'V';
  SDCapitalCostType = 'C';
  SDMaintenanceCostType = 'M';

    {Implicit table names}

  ParcelTableName = 'TParcelRec';
  AssessmentTableName = 'TPAssessRec';
  ClassTableName = 'TPClassRec';
  SpecialDistrictTableName = 'TPSpclDistRec';
  ExemptionsTableName = 'TPExemptionRec';
  ExemptionsDenialTableName = 'TPExemptionsDenied';
  ExemptionsRemovedTableName = 'PRemovedExemptionsTable';
  SalesTableName = 'PSalesRec';
  ResidentialSiteTableName = 'TPResidentialSite';
  ResidentialBldgTableName = 'TPResidentialBldg';
  ResidentialLandTableName = 'TPResidentialLand';
  ResidentialForestTableName = 'TPResidentialForest';
  ResidentialImprovementsTableName = 'TPResidentialImprove';
  CommercialSiteTableName = 'TPCommercialSite';
  CommercialBldgTableName = 'TPCommercialBldg';
  CommercialLandTableName = 'TPCommercialLand';
  CommercialImprovementsTableName = 'TPCommercialImprove';
  CommercialRentTableName = 'TPCommercialRent';
  CommercialIncomeExpenseTableName = 'TPCommercialIncExp';
  CoopBuildingsTableName = 'TCoopBuildings';

    {CHG05011998-2: Add building permit report}
    {FXX05041998-4: Incorrect permit table name.}
  PermitsTableName = 'BldgPermitTable';
  PASPermitsTableName = 'PBuildingPermits';
  NotesTableName = 'PNotesRec';
  PictureTableName = 'PPictureRec';
  SketchTableName = 'PSketchRec';
  DocumentTableName = 'PDocumentRec';
  PropertyCardTableName = 'PPropertyCard';
  ThirdPartyNotificationTableName = 'p3rdPartyNoticeTable';
  AdditionalOwnersTableName = 'padditionalowners';
  AgricultureTableName = 'TPAgriculture';

  GrievanceTableName = 'GrievanceTable';
  GrievanceResultsTableName = 'GrievanceResultsTable';
  GrievanceExemptionsAskedTableName = 'gexemptionsasked';
  GrievanceAuditTableName = 'gauditgrantedvalues';
  GrievanceDocumentTableName = 'gdocumentrec';
  GrievanceLettersTableName = 'gletterssent';
  GrievanceParcelExemptionTableName = 'gpexemptionrec';
  GrievanceParcelSpecialDistrictTableName = 'gpspcldistrec';
  GrievanceBOARDetailsTableName = 'GreivanceBOARDetails';
  GrievanceNotesTableName = 'gnotesrec';

  CertiorariTableName = 'GCertiorariTable';
  CertiorariAppraisalsTableName = 'gcappraisals';
  CertiorariCalenderTableName = 'gcertcalender';
  CertiorariDocumentsTableName = 'gcdocumentrec';
  CertiorariExemptionsAskedTableName = 'gcexemptionsasked';
  CertiorariLettersSentTableName = 'gcletterssent';
  CertiorariNotesTableName = 'gcnotesrec';
  CertiorariParcelExemptionsTableName = 'gcpexemptionrec';
  CertiorariParcelSalesTableName = 'gcpsalesrec';
  CertiorariParcelSpecialDistrictsTableName = 'gcpspcldistrec';

  SmallClaimsTableName = 'GSmallClaimsTable';
  SmallClaimsAppraisalsTableName = 'gscappraisals';
  SmallClaimsCalenderTableName = 'gsccalender';
  SmallClaimsDocumentsTableName = 'gscdocumentrec';
  SmallClaimsExemptionsAskedTableName = 'gscexemptionsasked';
  SmallClaimsLettersSentTableName = 'gscletterssent';
  SmallClaimsNotesTableName = 'gscnotesrec';
  SmallClaimsParcelExemptionsTableName = 'gscexemptionrec';
  SmallClaimsParcelSalesTableName = 'gscpsalesrec';
  SmallClaimsParcelSpecialDistrictsTableName = 'gscspcldistrec';

  AssessmentYearControlTableName = 'TAssmtYrCtlFile';
  ExemptionCodesTableName = 'TExCodeTbl';
  AssessmentNotesTableName = 'TPAssessmentNotes';
  AssessmentLetterTextTableName = 'TPAssessmentLtrText';
  RTByExCodeTableName = 'TRTotByExCode';
  RTBySchoolCodeTableName = 'TRTotBySchoolCode';
  RTBySDCodeTableName = 'TRTotBySDCode';
  RTByRS9TableName = 'TRTotByRollSec9';
  RTBySwisCodeTableName = 'TRTotBySwisCode';
  RTByVillageRelevyTableName = 'TRTotByVillageRelevy';
  SchoolCodeTableName = 'TSchoolTbl';
  SdistCodeTableName = 'TSDCodeTbl';
  SwisCodeTableName = 'TSwisTbl';
  UserDataTableName = 'TPUserFieldsData';
  UserDefinitionsTableName = 'TPUserFieldsDefs';
  SortAsrAVChangesTableName = 'SortAsrAVChanges';
  AlternateVeteranLimitsTableName = 'ZVeteransLimitCodes';
  ColdWarVeteranLimitsTableName = 'zcoldwarvetlimits';

  PrinterSettingsTableName = 'DefaultPrinterSettings';
  UserProfileTableName = 'UserProfileTable';

  MergeLetterCodesTableName = 'zlettercodes';
  MergeLetterFieldsTableName = 'ZMergeLetterDefs';
  MergeFieldsAvailableTableName = 'zmergefieldsavailable';

  ReleaseNotesTableName = 'ReleaseNotesTable';
  HelpDocumentTableName = 'helpdocumenttable';

  BillGeneralRateTableName = 'BCollGeneralRateFile';
  BillSpecialDistrictRateTableName = 'BCollSdistRateFile';
  BillControlHeaderTableName = 'BCollControlFile';
  BillControlDetailTableName = 'BCollControlDtlFile';
  BillSpecialFeeRateTableName = 'BCollSpclFeeFile';
  BillArrearsMessageTableName = 'BCollArrearsMsg';

  ProrataHeaderTableName = 'ProrataHeader';
  ProrataDetailsTableName = 'ProrataDetails';

  PropertyClassCodeTableName = 'ZPropClsTbl';
  AuditAVChangesTableName = 'auditavchangetbl';
  AuditEXChangesTableName = 'AuditEXChangeTbl';
  AuditTableName = 'AuditTable';
  AuditNameAddressTableName = 'AuditNameAddress';
  HistoryOfOwnersTableName = 'PHistoryOfOwners';
  TaxBillAddressTableName = 'TTaxBillAddress';

  RPSExtractRecordLength = 822;
  RPSImportRecordLength = 824;  {2 more for carriage return line feed}

  HstdCnst = 'H';
  NonhomesteadParcel = 'N';
  SplitParcel = 'S';

    {CHG10281997-1: Dual mode processing.}

  raInserted = 0;
  raEdited = 1;

   {CHG02271998-1: Allow print screen from all screens.}

  ParcelTabFormTag = 9999;

    {FXX05061998-3: Save the STAR amounts for school billings.}

  BasicSTARExemptionCode = '41854';
  EnhancedSTARExemptionCode = '41834';
  BIEExemptionCode = '47600';


   {***** NOTE **** NOTE *** "number" constants below MUST}
   {match the Tag number of the object BasePopUpMenu.Items[n]}
   {so that the popupmenu will select and activate the correct form}
   {based on user's button click}

   {MDT09301997 - If the form numbers are ever changed for the
                  summary, base pg 1 or 2, or the assessment form,
                  they must also be changed in the Items property of
                  the FirstPageInParcelNotebookComboBox
                  on the user profile form (USERPROF).}

   {CHG10121998-2: I had to move the screen form numbers to GlblCnst in order to
                   centralize the SetGlobalUserDefaults routine across several
                   units.}
   {CHG08021999-3: Add exemptions denial page.}


  SummaryTabName = 'Smry';
  SummaryFormNumber = 5005;
  BaseParcelPg1TabName = 'Pg 1';
  BaseParcelPg1FormNumber = 5010;

  BaseParcelPg2TabName = 'Pg 2';
  BaseParcelPg2FormNumber = 5020;

  AssessmentTabName = 'Assess';
  AssessmentFormNumber = 5030;
  ClassTabName = 'Class';
  ClassFormNumber = 5035;
  SpecialDistrictTabName = 'Sp Dist';
  SpecialDistrictFormNumber = 5040;
  ExemptionsTabName = 'Exmpt';
  ExemptionsFormNumber = 5050;
  ExemptionsDenialTabName = 'Denial';
  ExemptionsDenialFormNumber = 5053;
  ExemptionsRemovedTabName = 'Removed';
  ExemptionsRemovedFormNumber = 5055;
  SalesTabName = 'Sales';
  SalesFormNumber = 5060;
  ResidentialSiteTabName = 'Res Site';
  ResidentialSiteFormNumber = 5070;
  ResidentialBldgTabName = 'Res Bldg';
  ResidentialBldgFormNumber = 5080;
  ResidentialLandTabName = 'Res Land';
  ResidentialLandFormNumber = 5090;
  ResidentialForestTabName = 'Res Forest';
  ResidentialForestFormNumber = 5100;
  ResidentialImprovementsTabName = 'Res Imp';
  ResidentialImprovementsFormNumber = 5110;
  CommercialSiteTabName = 'Com Site';
  CommercialSiteFormNumber = 5120;
  CommercialBldgTabName = 'Com Bldg';
  CommercialBldgFormNumber = 5130;
  CommercialLandTabName = 'Com Land';
  CommercialLandFormNumber = 5140;
  CommercialImprovementsTabName = 'Com Imp';
  CommercialImprovementsFormNumber = 5150;
  CommercialRentTabName = 'Com Rent';
  CommercialRentFormNumber = 5160;
  CommercialIncomeExpenseTabName = 'Com Inc\Exp';
  CommercialIncomeExpenseFormNumber = 5170;
  NotesTabName = 'Notes';
  NotesFormNumber = 5180;
  PictureTabName = 'Pict';
  PictureFormNumber = 5190;
  DocumentTabName = 'Docs';
  DocumentFormNumber = 5195;
  PropertyCardTabName = 'Cards';
  PropertyCardFormNumber = 5197;
  SketchTabName = 'Sketch';
  SketchFormNumber = 5200;
  UserDataTabName = 'User Data';
  UserDataFormNumber = 5210;

    {CHG05011998-2: Add building permit report}

  PermitsTabName = 'Permits';
  PermitsFormNumber = 5220;
  ProrataTabName = 'Prorata';
  ProrataFormNumber = 5225;
  MapTabName = 'Map';
  MapFormNumber = 5230;

    {CHG01082002-1: 3rd party notification}

  ThirdPartyNotificationTabName = '3rd Party';
  ThirdPartyNotificationFormNumber = 5240;
  AdditionalOwnersTabName = 'Contacts';
  AdditionalOwnersFormNumber = 5245;
  GrievanceTabName = 'Grievance';
  GrievanceFormNumber = 5250;
  CertiorariTabName = 'Cert';
  CertiorariFormNumber = 5260;
  SmallClaimsTabName = 'Sml Clm';
  SmallClaimsFormNumber = 5255;
  PASPermitsTabName = 'Permit';
  PASPermitsFormNumber = 5270;
  SplitSchoolDistrictTabName = 'Split Schl';
  SplitSchoolDistrictFormNumber = 5280;
  AgricultureTabName = 'Agriculture';
  AgricultureFormNumber = 5290;
  TaxBillAddressTabName = 'Tax Bill Addr';
  TaxBillAddressFormNumber = 5295;

    {FXX04081999-6: These were moved here for split\merge tracing.}

  Split = 0;
  Merge = 1;
  SBLChange = 2;
  CopyParcel = 3;
  SwitchParcels = 4;
  RollSection9 = 5;

  InactiveLabelText = 'INACT';
  DoesNotExistLabelText = '';

  atActive = 0;
  atInactive = 1;
  atDoesNotExist = 2;

  ParcelTable_Year_Swis_SBLKey = 'BYTAXROLLYR_SWISSBLKEY';
  InventoryYear_SwisSBLKey = 'BYTAXROLLYR_SWISSBLKEY';
  InventorySwisSBL_SalesNumberKey = 'BYSWISSBLKEY_SALESNUMBER';
  OtherTableYear_SwisSBLKey = 'BYTAXROLLYR_SWISSBLKEY';
  SalesTableSwisSBL_SalesNumberKey = 'BYSWISSBLKEY_SALENUMBER';
  ExemptionTableYear_SwisSBL_EXKey = 'BYYEAR_SWISSBLKEY_EXCODE';
  SDTableYear_SwisSBL_SDKey = 'BYTAXROLLYR_SWISSBLKEY_SD';


    {The following are the default extensions for report options:

      Assessment by prop class = *.prp
      Assessment change letters = *.cgl
      Assessment rolls = *.rol
      Assessment summary = *.sum
      Assessment variance = *.var
      Assessor's report = *.asr
      Assessor's trial bal = *.bal
      Assessor's verification = *.ver
      Audit trial = *.aud
      Exemption report = *.exr
      Exemption letters = *.exl
      Exemption Status Report = *.sta
      Generic letters = *.gnl
      Generalized extract = *.ext
      Labels = *.lab
      Notes report = *.not
      Parcel information = *.prc
      Roll totals print = *.tot
      Sales = *.sal
      Sales analysis = *.anl
      SD = *.spd
      Search Report = *.src}

    {Constants for the data module tables.}

  DataModuleAssessmentTableName = 'AssessmentTable';
  DataModuleExemptionCodeTableName = 'ExemptionCodeTable';
  DataModuleExemptionTableName = 'ExemptionTable';
  DataModuleSpecialDistrictCodeTableName = 'SpecialDistrictCodeTable';
  DataModuleSpecialDistrictTableName = 'SpecialDistrictTable';
  DataModuleParcelTableName = 'ParcelTable';
  DataModuleClassTableName = 'ClassTable';
  DataModuleAssessmentYearControlTableName = 'AssessmentYearControlTable';
  DataModuleSwisCodeTableName = 'SwisCodeTable';
  DataModuleSalesTableName = 'SalesTable';
  DataModuleSchoolCodeTableName = 'SchoolCodeTable';
  DataModuleSketchTableName = SketchTableName;

  DataModuleResidentialSiteTableName = 'ResidentialSiteTable';
  DataModuleResidentialBuildingTableName = 'ResidentialBuildingTable';
  DataModuleResidentialLandTableName = 'ResidentialLandTable';
  DataModuleResidentialImprovementTableName = 'ResidentialImprovementTable';
  DataModuleResidentialForestTableName = 'ResidentialForestTable';
  DataModuleCommercialSiteTableName = 'CommercialSiteTable';
  DataModuleCommercialBuildingTableName = 'CommercialBuildingTable';
  DataModuleCommercialLandTableName = 'CommercialLandTable';
  DataModuleCommercialImprovementTableName = 'CommercialImprovementTable';
  DataModuleCommercialRentTableName = 'CommercialRentTable';
  DataModuleCommercialIncomeExpenseTableName = 'CommercialIncomeExpenseTable';

    {Document types}

  dtPicture = 5;
  dtScannedImage = 10;
  dtMSWord = 20;
  dtExcel = 30;
  dtWordPerfect = 40;
  dtQuattroPro = 50;
  dtAdobePdf = 60;
  dtApexSketch = 70;
  dtPropertyCard = 80;
  dtCertiorari = 90;

    {Senior limit set types}

  lsAll = 0;
  lsCountyTown = 1;
  lsCountySchool = 2;
  lsSchoolTown = 3;
  lsCounty = 4;
  lsTown = 5;
  lsSchool = 6;

    {Building system types}

  bldNone = 0;
  bldBTrieve = 1;
  bldSmallBuilding = 2;
  bldLargeBuilding = 3;
  bldMunicity = 4;

    {Layer types}

  ltArcInfo = 'ARC\INFO';
  ltCADText = 'CADTEXT';
  ltMRSID = 'MRSID';
  ltCADArea = 'CADAREA';
  ltCADPoint = 'CADPOINT';

    {Proximity types}

  ptCentroid = 0;
  ptPerimeter = 1;

    {Label types}

  lbDotMatrix = 0;
  lbLaser5161 = 1;
  lbLaser5160 = 2;
  lbLaser1Liner = 3;
  lbEnvelope = 4;

    {First line}

  flParcelIDOnly = 0;
  flPropertyClass = 1;
  flSDCode = 2;
  flExemptionCode = 3;
  flAddressInformation = 4;
  flAccountNumber_OldID = 5;

    {Range Types for mapping}

  rtLandValue = 0;
  rtAssessedValue = 1;
  rtAssessmentChange = 2;
  rtSalesPrice = 3;
  rtZoningCodes = 4;
  rtNeighborhoodCodes = 5;
  rtSwisCodes = 6;
  rtSchoolCodes = 7;
  rtAssessedValue_SalesPrice_Ratio = 8;
  rtPropertyClass = 9;

    {Grievance results type}

  gtApproved = 0;
  gtDenied = 1;
  gtDismissed = 2;
  gtWithdrawn = 3;
  gtAll = 4;

    {Grievance status types}

  gsOpen = 0;
  gsMixed = 1;
  gsClosed = 2;
  gsApproved = 3;
  gsDenied = 4;
  gsDismissed = 5;
  gsWithdrawn = 6;

    {New parcel locate constants.}

  lcGParcelID = 0;
  lcGLegalAddress = 1;
  lcGStreetName = 2;
  lcGOwnerName = 3;
  lcGIndexNumber = 4;
  lcGPetitionerName = 5;
  lcGOldParcelID = 6;
  lcgAlternateID = 7;

  lcPParcelLongFormat = 0;
  lcPParcelID = 1;
  lcPLegalAddress = 2;
  lcPStreetName = 3;
  lcPOwnerName = 4;
  lcPOldParcelID = 5;
  lcPOldSBLRaw = 6;
  lcPParcelID_No_Swis = 8;

    {Certiorari results type}

  csApproved = 0;
  csDenied = 1;
  csDiscontinued = 2;
  csWithdrawn = 3;
  csDismissed = 4;
  csOpen = 5;

  MapSetupDefaultNone = 'NONE';

    {CHG02152004-1(2.07l): Add grievance, small claims and cert info. to search report.}

  GrievanceScreenName = 'Grievance';
  GrievanceResultsScreenName = 'Grievance Results';
  GrievanceExemptionsAskedScreenName = 'Grievance EX';
  SmallClaimsScreenName = 'Small Claims';
  SmallClaimsAppraisalsScreenName = 'Sml Clm Appraisals';
  SmallClaimsCalendarScreenName = 'Sml Clm Calendar';
  SmallClaimsNotesScreenName = 'Sml Clm Notes';
  CertiorariScreenName = 'Certiorari';
  CertiorariAppraisalsScreenName = 'Cert Appraisals';
  CertiorariCalendarScreenName = 'Cert Calendar';
  CertiorariNotesScreenName = 'Cert Notes';
  PermitsScreenName = 'Permits';

    {CHG03212004-1(2.08): Allow for limitations on what screens to put in the list
                          from the calling routine.}

  AssessmentScreenName = 'Assessments';
  BaseInformationScreenName = 'Base Information';
  ClassScreenName = 'Class';
  CommercialBuildingScreenName = 'Commercial Building';
  CommercialImprovementScreenName = 'Commercial Improvements';
  CommercialIncomeExpenseScreenName = 'Commercial Income Expense';
  CommercialLandScreenName = 'Commercial Land';
  CommercialRentScreenName = 'Commercial Rent';
  CommercialSiteScreenName = 'Commercial Sites';
  DocumentScreenName = 'Documents';
  PropertyCardScreenName = 'Property Cards';
  ExemptionScreenName = 'Exemption';
  ExemptionDenialScreenName = 'Exemption Denials';
  ExemptionRemovalScreenName = 'Exemption Removals';
  NoteScreenName = 'Notes';
  PictureScreenName = 'Pictures';
  ResidentialBuildingScreenName = 'Residential Building';
  ResidentialForestScreenName = 'Residential Forest';
  ResidentialImprovementScreenName = 'Residential Improvements';
  ResidentialLandScreenName = 'Residential Land';
  ResidentialSiteScreenName = 'Residential Sites';
  SaleScreenName = 'Sales';
  SpecialDistrictScreenName = 'Special District';


  coEqual = 0;
  coGreaterThan = 1;
  coLessThan = 2;
  coGreaterThanOrEqual = 3;
  coLessThanOrEqual = 4;
  coNotEqual = 5;

    {CHG11251997-2: Allow for selection on blank or not blank.}

  coBlank = 6;
  coNotBlank = 7;
  coContains = 8;  {CHG10091998-2: Check for partial strings}
  coStartsWith = 9;
  coBetween = 10;
  coMatchesPartialOrFirstItemBlank = 11;
  coMatchesOrFirstItemBlank = 12;
  coDoesNotStartWith = 13;
  coEndsWith = 14;

    {Help groups}

  hgReports = 'REPORT';
  hgGeneralProcessing = 'GENPROC';

    {CHG09122004-4(2.8.0.11): User option as to what sales field to go to after the condition code.}

  nsfDefault = 0;
  nsfVerify = 1;
  nsfPersonalProperty = 2;
  nsfAssessorChangeFlag = 3;
  nsfOldOwner = 4;
  nsfDeedBook = 5;
  nsfDeedType = 6;
  nsfDeedDate = 7;

    {CHG11162004-3(2.8.0.21): Allow for parcel locate customization.}

  plcParcelID = 0;
  plcOwner = 1;
  plcLegalAddressNumber = 2;
  plcLegalAddressName = 3;
  plcSwisCode = 4;
  plcSBLSegments = 5;
  plcAccountNumber = 6;
  plcPropertyClass = 7;
  plcSchoolCode = 8;

    {Constants for parcel index locate default.}

  pldParcelID = 0;
  pldParcelIDLongFormat = 1;
  pldLegalAddress = 2;
  pldStreetName = 3;
  pldOwnerName = 4;
  pldOldParcelID = 5;
  pldAccountNumber = 6;

  emEdit = 'M';
  emInsert = 'A';
  emBrowse = 'V';
  emDelete = 'D';

    {Print screen methods.}

  psNormal = 0;
  psExcellentPrinter = 1;
  psPrintSuite = 2;

  CountyTaxType = 'CO';
  TownTaxType = 'TO';
  VillageTaxType = 'VI';
  MunicipalTaxType = 'MU';
  SchoolTaxType = 'SC';
  SchoolMunicipalTaxType = 'SCMU';
  SpecialDistrictTaxType = 'SD';
  AllTaxTypes = 'ALL';

  mtfnCity = 'City';
  mtfnTown = 'Town';
  mtfnSchool = 'School';
  mtfnCounty = 'County';
  mtfnVillage = 'Village';
  mtfnSchoolMunicipal = 'School\Municipal';

  ownCooperative = 'P';
  ownCondominium = 'C';
  ownAssociation = 'A';

  BlankMaskDate = '  /  /    ';
  BlankMaskDateUnderscore = '__/__/____';

    {Key fields for new audit.}

  kfSwisSBLKey = 0;

  MobileHomePropertyClass = '416';

  ctNone = 0;
  ctThisParcel = 1;
  ctAllParcels = 2;

    {Grievance results}

  grApproved = 0;
  grDenied = 1;
  grDismissed = 2;
  grWithdrawn = 3;

    {Ownership Codes}

  ocCooperative = 'P';
  ocCooperative_Waterfront = 'Q';

(*  sgSegment1Length = 2;
  sgSegment2Length = 3;
  sgSegment3Length = 3;
  sgSegment4Length = 2;
  sgSegment5Length = 4;
  sgSegment6Length = 3; *)

  sgSegment1Length = 3;
  sgSegment2Length = 3;
  sgSegment3Length = 4;
  sgSegment4Length = 3;
  sgSegment5Length = 3;
  sgSegment6Length = 4;

  cwvBasic = 0;
  cwvDisabled = 1;

  blBillingParcelBaseName = 'BillHeader';
  blBillingExemptionBaseName = 'BillExemptionDetails';

  emlORPSExtract = 'orpts_dmu@tax.ny.gov';
  emlORPSSTARExtract = 'internet.STAR@orps.state.ny.us';
  emlSCAMike = 'miket@sca-corp.com';
  emlSCASupport = 'support@sca-corp.com';

    {Special district types}

  sdtSolidWaste = 1;
  sdtSewer = 2;
  sdtWater = 3;

    {Tax system types}

  tsCounty = 1;

  SQLQuote = '''';

implementation

end.