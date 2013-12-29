unit Pastypes;

interface

uses Types, GlblCnst, Classes, Graphics, DB;

const
  MaximumSpecialDistrictExtensions = 10;

type            {used by trace table}
  SBLRecord = record
    SwisCode : String;
    Section : String;
    SubSection : String;
    Block : String;
    Lot : String;
    Sublot : String;
    Suffix : String;
  end;  {SBLRecord = record}

  ECRec = Record
    Ecde : String;
    ECFlg : String;
  end;

  EcdCMArray = Array[1..10] of ECREc;
  ECdeArray = array[1..10] of String;

  TSBLFormatTypes = (fmLeftJustify, fmRightJustify, fmNumeric,
                     fmAlphaNumeric, fmAlpha, fmShiftRightAddZeroes);
  TSBLSegmentFormatType = set of TSBLFormatTypes;

  DropdownTagIDSetType = set of 0..250;

  ExemptionAppliesArrayType = Array[1..4] of Boolean;  {County, Town, Village, School}

     {also see extotals constants in glblcnsts, which are used}
     {to index into this array}

  ExemptionTotalsArrayType = Array[1..4] of Comp;  {County, Town, Village, School}

  RPSExtractRec = Array[1..RPSExtractRecordLength] of Char;
  PRPSExtractRec = ^RPSExtractRec;

  RPSImportRec = Array[1..RPSImportRecordLength] of Char;

  PCodeRecord = ^CodeRecord;

  CodeRecord = record
    Code : String;
    Description : String;
    UniformPercentOfValue : Real;
    CodeTableName : String;
  end;

    {This record "bundles" and SD code with all it's extension codes,
     CC_OM flags, and the corresponding values.
     I used arrays here rather then string lists since these were
     causing me GPF problems.}

    {CHG09122004-1(2.8.0.11): Add homestead split to SD Calcs}

  ParcelSDValuesRecord = record
    SDCode : String;
    SplitDistrict : Boolean;
    SDExtensionCodes : Array[1..10] of String;
    SDCC_OMFlags : Array[1..10] of String;
    AssessedValues : Array[1..10] of String;
    SDValues : Array[1..10] of String;
    HomesteadCodes : Array[1..10] of String;
  end;

  PParcelSDValuesRecord = ^ParcelSDValuesRecord;

    {CHG06241998-2: Load the prior and current levy amounts.}

    {Rate record definitions and pointers.}

  GeneralRateRecord = record
    PrintOrder : Integer;
    GeneralTaxType : String;
    SwisCode : String;
    SchoolCode : String;
    Description : String;
    HomesteadRate,
    NonhomesteadRate : Extended;
    PriorTaxLevy,
    CurrentTaxLevy : Comp;
      {FXX07011998-1: Add state aid field.}
    EstimatedStateAid : Comp;
      {FXX11101998-1: Add apply STAR field.}
    ApplySTAR : Boolean;
    BasicSTARCap : Double;
    EnhancedSTARCap : Double;
    NonHstdBasicSTARCap : Double;
    NonHstdEnhancedSTARCap : Double;
    BillPrintOrder : Integer;
  end;  {GeneralRateRecord = record}

  GeneralRatePointer = ^GeneralRateRecord;


  SDRateRecord = record
    SdistCode : String;
    ExtCode   : String;
    CMFlag    : String;
    Description : String;
    HomesteadCode : String;
    HomesteadRate,
    NonHomesteadRate : Extended;
    PriorTaxLevy,
    CurrentTaxLevy : Comp;
    BillPrintOrder : Integer;
  end;  {SDRateRecord = record}

  SDRatePointer = ^SDRateRecord;


  SpecialFeeRecord = record
    PrintOrder : Integer;
    FixedAmount : Double;
    Percentage  : Double;
    Description : String;
    AmtInFirstpayment : Boolean;
    AmtDistribAllPayment: Boolean;
    PriorTaxLevy,
    CurrentTaxLevy : Comp;
  end;  {SpecialFeeRecord = record}

  SpecialFeePointer = ^SpecialFeeRecord;


  ControlDetailRecord = record
    SwisCode : String;
    SchoolCode : String;
    StartingBillNo : Longint;
    CurrentBillNo  : LongInt;
  end;  {ControlDetailRecord = record}

  ControlDetailRecordPointer = ^ControlDetailRecord;

   {SD extension category list}

  SDExtCategoryRecord = record
    ExtCode : String;
    ExtCategory : String;
  end;  {SDExtCategoryRecord = record}

  SDExtCategoryPointer = ^SDExtCategoryRecord;

    {Code description list - so we don't have to keep looking up
     the descriptions in a file - we will make the code 10 to allow for
     the max.}

  CodeDescRecord = record
    Code : String;
    Description : String;
  end;  {CodeDescRecord = record}

  CodeDescPointer = ^CodeDescRecord;

    {MEMORY LIST OF TAX RECORDS}

  GeneralTaxRecord = record
    Description : String;
    HomesteadCode : String;
    PrintOrder  : Integer;
      {FXX12171998-8: Don't print taxable val for relevies.}
    GeneralTaxType : String;
    TaxableVal  : Comp;
    TaxRate     : Extended;
    TaxAmount   : Extended;
      {FXX06301998-20: Add STAR savings field.}
    StarSavings : Extended;
    BasicSTARSavings,
    EnhancedSTARSavings : Double;
  end;  {GeneralTaxRecord = record}

  GeneralTaxPtr = ^GeneralTaxRecord;


  SDistTaxRecord = record
    SdistCode : String;
    ExtCode   : String;
    CMFlag    : String;
    HomesteadCode : String;
    Description : String;
    SdValue   : Double;
    TaxRate   : Extended;
    SDAmount  : Extended;
    CombinedDistrictRecord : Boolean;

  end;  {SDistTaxRecord = record}

  SDistTaxPtr = ^SDistTaxRecord;


  SPFeeTaxRecord = record
    PrintOrder : Integer;
    Description : String;
    SPAmount    : Double;
  end;  {SPFeeTaxRecord = record}

  SPFeeTaxPtr = ^SPFeeTaxRecord;

    {FXX01131998-1: Add land commitment warnings.}

  ExemptTaxRecord = record
    ExCode : String;
    HomesteadCode : String;
    Description : String;
    InitialYear : String;
    CountyAmount,
    TownAmount,
    SchoolAmount,
    VillageAmount : Comp;
    FullValue : LongInt;

  end;  {ExemptTaxRecord = record}

  ExemptTaxPtr = ^ExemptTaxRecord;

    {roll totals tlist records}
  GeneralTotRecord = record
    SwisCode : String;
    SchoolCode : String;
    RollSection : String;
    HomesteadCode : String;
    PrintOrder : Integer;
    PartCt,
    ParcelCt : Longint;
    LandAv,
    TotalAV,
    ExemptAmt,
    TaxableVal,
     {FXX05061998-3: Save the STAR amounts for school billings.}
    STARAmount,
    TaxableValAfterSTAR : Comp;
    TotalTax : Extended;
      {FXX05141998-6: Save total STARSavings amount.}
    STARSavings : Extended;
    BasicSTARSavings,
    EnhancedSTARSavings : Double;
  end;  {GeneralTotRecord = record}

  GeneralTotPtr = ^GeneralTotRecord;

    {Assessment roll totals tlist records}
  GeneralAssessmentTotRecord = record
    SwisCode : String;
    SchoolCode : String;
    RollSection : String;
    HomesteadCode : String;
    PartCt,
    ParcelCt : Longint;
    LandAv,
    TotalAV,
    ExemptAmt,
    CountyTaxableVal,
    TownTaxableVal,
    SchoolTaxableVal,
    VillageTaxableVal,
     {FXX05061998-3: Save the STAR amounts for school billings.}
    STARAmount,
    TaxableValAfterSTAR : Comp;
  end;  {GeneralAssessmentTotRecord = record}

  GeneralAssessmentTotPtr = ^GeneralAssessmentTotRecord;


  SDistTotRecord = Record
    SwisCode : String;
    SchoolCode : String;
    RollSection : String;
    HomesteadCode : String;
    CMFlag : String;
    SDCode : String;
    ExtCode : String;
    ParcelCt : Longint;
    PartCount : LongInt;
    Value,
    ADValue,
    TaxableVal : Extended;
    ExemptAmt : Comp;
    TotalTax : Extended;
  end;  {SDistTotRecord = Record}

  SDistTotPtr = ^SDistTotRecord;


  ExemptTotRecord = record
    SwisCode : String;
    SchoolCode : String;
    RollSection : String;
    HomesteadCode : String;
    EXCode : String;
    PartCt,
    ParcelCt : Longint;
    CountyExAmt,
    TownExAmt,
    VillageEXAmt,
    SchoolExAmt : Comp;
    
  end;  {ExemptTotRecord = record}

  ExemptTotPtr = ^ExemptTotRecord;


  SchoolTotRecord = record
    SwisCode : String;
    RollSection : String;
    HomesteadCode : String;
    SchoolCode : String;
    PartCt,
    ParcelCt : Longint;
    LandAV,
    TotalAV,
    ExemptAmt,
    TaxableVal : Comp;
     {FXX05061998-3: Save the STAR amounts for school billings.}
    STARAmount,
    TaxableValAfterSTAR : Comp;
    TotalTax : Extended;
    BasicSTARSavings,
    EnhancedSTARSavings : Double;
  end;  {SchoolTotRecord = record}

  SchoolTotPtr = ^SchoolTotRecord;


  SPFeeTotRecord = record
    SwisCode : String;
    SchoolCode : String;
    RollSection : String;
    PrintOrder : Integer;
    ParcelCt : Longint;
    TotalTax : Extended;
    AmtInFirstPayment : Boolean;
  end;  {SPFeeTotRecord = record}

  SPFeeTotPtr = ^SPFeeTotRecord;

    {used by rpexmltr.pas }
  NameAddrArray = Array[1..6] of ShortString;
  PNameAddrArray = ^NameAddrArray;

    {CHG03241998-1: Trace exemption changes as whole picture.}

  AuditEXRecord = record
    ExemptionCode : String;
    CountyAmount,
    TownAmount,
    SchoolAmount,
    VillageAmount,
    Percent,
    OwnerPercent : Comp;
    InitialDate,
    TerminationDate : TDateTime;
  end;  {AuditEXRecord = record}

  PAuditEXRecord = ^AuditEXRecord;

    {CHG03231998-1: Also record SD and ex changes.}
    {CHG03301998-1: Trace SD, EX changes from everywhere.}

  AuditSDRecord = record
    PrimaryUnits : Real;
    SecondaryUnits : Real;
    CalcAmount : Comp;
    SDPercentage : Real;
    CalcCode : Char;
  end;  {SDRecord = record}

    {CHG03301998-1: Trace SD, EX changes from everywhere. Also more parcel info.}

  AuditParcelRecord = record
    SchoolCode : String;
    RollSection : String;
    HomesteadCode : String;
    AssessedVal,
    CountyTaxableVal,
    TownTaxableVal,
    SchoolTaxableVal : Comp;
    ResPercent,
    Frontage,
    Depth,
    Acreage : Real;
    SplitMergeNo : String;
  end; {AuditParcelRecord = record}


  TExemptionTypes = (extBIE, extBasicSTAR, extEnhancedSTAR,
                     extSenior, extAlternateVeteran,
                     extVolunteerFirefighterOrAmbulance, extOther);

  ExemptionCodeRecord = record
    ExemptionCode : String;
    ExemptionType : TExemptionTypes;
    CalculationMethod : String;
    ResidentialType : String;
    AppliesToSection490 : Boolean;
    AppliesToAdValorumDistrict : Boolean;
    AppliesToSpecialAssessmentDistrict : Boolean;
    IsVolunteerFirefighterOrAmbulanceExemption : Boolean;

  end;  {ExemptionCodeRecord = record}

  PExemptionCodeRecord = ^ExemptionCodeRecord;


  SpecialDistrictCodeRecord = record
    SpecialDistrictCode : String;
    Description : String;
    HomesteadCode : String;
    DistrictType : String;
    Section490 : Boolean;
    Chapter562 : Boolean;
    RollSection9 : Boolean;
    FireDistrict : Boolean;
    Prorata_Omitted_District : Boolean;
    DefaultUnits : Double;
    DefaultSecondaryUnits : Double;
    VolunteerFirefighterOrAmbulanceExemptionApplies : Boolean;
    LateralDistrict : Boolean;
    OperatingDistrict : Boolean;
    TreatmentDistrict : Boolean;
    Step1 : Double;
    Step2 : Double;
    Step3 : Double;
    ExtensionCodes : Array[1..MaximumSpecialDistrictExtensions] of String;
    CapitalCostOrMaintenanceCodes : Array[1..MaximumSpecialDistrictExtensions] of String;

  end;  {SpecialDistrictCodeRecord = record}

  ParcelExemptionRecord = record
    EXCode : String;
    HomesteadCode : String;
    CountyAmount,
    TownAmount,
    SchoolAmount,
    VillageAmount : Comp;
  end;  {ParcelExemptionRecord = record}

  PParcelExemptionRecord = ^ParcelExemptionRecord;

type
  PrintToTypes = (ptLaser, ptDotMatrix, ptBoth);
  PrintToTypeSet = set of PrintToTypes;

    {CHG12031998-1: Move definitions of roll total lists here so that
                    the load procs can be shared by Roll total display
                    and print.}

     {BY SWIS}

  RTSwisCodeTotals = record
    TaxRollYr : String;
    SwisCode  : String;
    RollSection : String;
    HomesteadCode : String;
    ParcelCount   : Longint;
    PartCount     : LongInt;
      {FXX02101999-4: Add land value to swis and school totals.}
    LandValue : Double;
    AssessedValue : Double;
    CountyTaxable : Double;
    TownTaxable   : Double;
    VillageTaxable: Double;

  end;  {RTSwisCodeTotals = record}

  RTSwisCodeTotalsPtr = ^RTSwisCodeTotals;

     {BY SCHOOL}

  RTSchoolTotals = record
    TaxRollYr : String;
    SwisCode : String;
    SchoolCode : String;
    HomesteadCode : String;
    ParcelCount   : Longint;
    PartCount     : LongInt;
      {FXX02101999-4: Add land value to swis and school totals.}
    LandValue : Double;
    AssessedValue : Double;
    SchoolTaxable : Double;
    RelevyCount   : LongInt;
    SchoolRelevyAmt : Double;
      {CHG07291999-1: Add STAR values and taxable vals to on-line totals.}
    BasicSTARAmount : Double;
    EnhancedSTARAmount : Double;
    BasicSTARCount : LongInt;
    EnhancedSTARCount : LongInt;

  end;  {RTSchlTotals = record}

  RTSchoolCodeTotalsPtr = ^RTSchoolTotals;

   {*************EX code totals records     *******}

  RTEXCodeTotals = record
    TaxRollYr : String;
    SwisCode : String;
    ExCode  : String;
    HomesteadCode : String;
    ParcelCount   : Longint;
    PartCount     : LongInt;
    CountyExAmount : Double;
    TownExAmount   : Double;
    VillageExAmount : Double;
    SchoolExAmount  : Double;

  end;  {RtEXCodeTotals = record}

  RTEXCodeTotalsPtr = ^RTEXCodeTotals;

   {*************SD code totals records     *******}

  RtSDCodeTotals = Record
    TaxRollYr : String;
    SwisCode : String;
    SDCode  : String;
    HomesteadCode : String;  {CHG09122004-1(2.8.0.11): Add homestead split to SD Calcs}
    SplitDistrict : Boolean;
    ExtensionCode : String;
    ParcelCount : Longint;
    CCOMFlg : String;
    TaxableValue   : Double;
    AssessedValue : Double;
  end;

  RTSDCodeTotalsPtr = ^RtSDCodeTotals;

    {CHG12091998-1:  Village relevy totals.}

   {************ Village relevy totals **************}

  RTVillageRelevyTotals = record
    TaxRollYr : String;
    SwisCode  : String;
    HomesteadCode : String;
    RelevyCount : LongInt;
    RelevyAmount : Extended;

  end;  {RTVillageRelevyCodeTotals = record}

  RTVillageRelevyTotalsPtr = ^RTVillageRelevyTotals;

  RtRS9Totals = Record
    TaxRollYr : String;
    SwisCode : String;
    SDCode  : String;
    ParcelCount : Longint;
    Amount : Double;
  end;

  RTRS9TotalsPtr = ^RtRS9Totals;

type
  NameAddressBankCodeRecord = record
    NAddrArray : NameAddrArray;
    BankCode : String;
  end;


const
  WarningMessageCount = 30;

type
  WarningTypes = (wtInactiveParcels, wtOutOfBalance,
                  wtRS8NoExemption, wtWhollyExemptNotRS8,
                  wtZeroAssessments, wtFrozenAssessments,
                  wtGasAndOilWells, wtImprovementChange,
                  wtSplitMerge, wtARFilledIn_NoAVChange,
                  wtPhysIncAndDec, wtEqualIncAndDec,
                  wtVacantLand, wtNonVacantLand,
                  wtDuplicateExemptions, wtBasicAndEnhanced,
                  wtSeniorWithoutEnhanced,
                  wtInventoryWarnings, wtExemptionOnVacant,
                  wtSTARonNonResidential, wtNoTerminationDate,
                  wtCountyOrTownExemptionOnly,
                  wtClergyExemptionTooHigh,
                  wtExemptionsGreaterThanAV,
                  wtLandRecordSizeNotEqualToOverallSize,
                  wtSTARonNYnotTY,
                  wtPartialExemptionOnRS8,
                  wtGarbageDiscountReminder,
                  wtAVChangeWithOverrideSpecialDistricts,
                  wtAVChangeWithSaleForMultipleParcels,
                  wtColdWarVetAndRegularVetOnParcel,
                  wtAll);
  WarningTypesSet = set of WarningTypes;

  {memory list of screens and labels}
  ScreenLabelRecord = Record
    ScreenName : String;
    LabelName  : String;
    TableName : String;
    FieldName : String;
    ReportDisplayName : String;
    VisibleOnReport : Boolean;
    NumberOfColumns : Integer;
  end;

  ScreenLabelPtr = ^ScreenLabelRecord;

  PSwisSBLKeyType = ^String;

    {CHG02122000-3: Insert a name\addr audit change record.}

  NameAddressRecord = record
    Name1 : String;
    Name2 : String;
    Address1 : String;
    Address2 : String;
    Street : String;
    City : String;
    State : String;
    Zip : String;
    ZipPlus4 : String;
  end;

   {CHG03232004-1(2.08): Fix up taxable value type selection \ printing on rolls.}

  MunicipalitySetTypes = (mtpCounty, mtpSchool, mtpTown, mtpPartialVillage);
  MunicipalityTypes = set of MunicipalitySetTypes;

  DocumentListRecord = record
    FileName : String;
    AlreadyOnFile : Boolean;
    Notes : String;
  end;

  DocumentListPointer = ^DocumentListRecord;

  SelectedPicsOrDocsRecord = record
    FileName : String;
    DirectoryName : String;
    Notes : String;
  end;

  SelectedPicsOrDocsPointer = ^SelectedPicsOrDocsRecord;

  DestinationParcelInformationRecord = record
    SwisSBLKey : String;
    GridLine : String;
    TableName : String;
    FieldName : String;
    FieldValue : String;
  end;

  DestinationParcelInformationPointer = ^DestinationParcelInformationRecord;

    {For mapping}

  MapRangeRecord = record
    StartValue : Double;
    EndValue : Double;
    NumberOfIncrements : Integer;
    StartColor : TColor;
    EndColor : TColor;
    StartYear : String;
    EndYear : String;
    StartDate : TDateTime;
    EndDate : TDateTime;
    UseFullMapExtent : Boolean;
    DisplayLabels : Boolean;
  end;

  MapRangeItemRecord = record
    LowValue : String;
    HighValue : String;
    Color : TColor;
  end;

  MapRangeItemPointer = ^MapRangeItemRecord;

  GlblLastLocateInfoRecord = record
    LastLocateKey : Integer;
    LastLocatePage : Char;
    LastSwisSBLKey : String;
    LastLegalAddrInt : Integer;
    LastLegalAddr : String;
    LastOwnerName : String;
    LastPetitionerName : String;
    LastIndexNumber : Integer;
    LastOldParcelID : String;
    LastSpecificGrievanceYear : String;

  end;  {GlblLastLocateInfoRecord = record}

  TRollTotalsToShowTypes = (rtdCounty, rtdMunicipal, rtdSchool, rtdVillageReceivingPartialRoll);
  TRollTotalsToShowType = set of TRollTotalsToShowTypes;

  TScreenTypes = (slAssessment, slBaseInformation, slClass, slExemption,
                  slExemptionDenial, slExemptionRemoval, slSpecialDistrict,
                  slResidentialSite, slResidentialBuilding, slResidentialLand,
                  slResidentialImprovement, slResidentialForest,
                  slCommercialSite, slCommercialBuilding, slCommercialLand,
                  slCommercialImprovement, slCommercialRent, slCommercialIncomeExpense,
                  slDocument, slPicture, slNote, slSale,
                  slGrievance, slGrievanceResult,
                  slSmallClaims, slSmallClaimsNote,
                  slSmallClaimsCalendar, slSmallClaimsAppraisal,
                  slCertiorari, slCertiorariNote,
                  slCertiorariCalendar, slCertiorariAppraisal, slAll);
  TScreenType = set of TScreenTypes;

  TLabelFormatOptionsTypes = (lb_PrintLabelsBold,
                              lb_PrintOldAndNewParcelIDs,
                              lb_PrintSwisCodeOnParcelIDs,
                              lb_PrintParcelIDOnly,
                              lb_ResidentLabels,
                              lb_LegalAddressLabels,
                              lb_PrintParcelIDOnlyOnFirstLine,
                              lb_PrintParcelID_PropertyClass,
                              lb_EliminateDuplicateOwners,
                              lb_PrintAccountNumber_OldID);
  TLabelFormatOptionsType = set of TLabelFormatOptionsTypes;

  TLabelOptions = record
    LabelType : Integer;
    NumLabelsPerPage : Integer;
    NumLinesPerLabel : Integer;
    NumColumnsPerPage : Integer;
    SingleParcelFontSize : Integer;
    FontSizeAdditionalLines : Integer;
    LaserTopMargin : Real;
    ExtractToExcel : Boolean;
    CommaDelimitedExtract : Boolean;
    ExtractFileName : String;
    LabelFormatOptions : TLabelFormatOptionsType;
  end;

  FieldTraceInformationRecord = record
    FieldName : String;
    FieldValue : String;
    FieldLabel : String;
  end;

  FieldTraceInformationPointer = ^FieldTraceInformationRecord;

  TCollectionTypes = (ctSchool, ctMunicipal, ctCounty, ctVillage);
  TCollectionSetType = set of TCollectionTypes;

  TTaxRateType = (trPerThousand, trPerUnit, trPerSecondaryUnit, trAny);

  TaxInformationRecord = record
    LevyCode : String;
    LevyDescription : String;
    HomesteadCode : String;
    ExtensionCode : String;
    TaxableValue : Double;
    TaxRate : Double;
    TaxRateType : TTaxRateType;
    TaxRateDescription : String;
    TaxAmount : Double;
  end;

  TaxInformationPointer = ^TaxInformationRecord;

  TLevyTypes = (ltCounty, ltTown, ltVillage, ltMunicipal, ltSchool, ltNoUnitary, ltPolice, ltAll,
                ltAdValorumSpecialDistrict, ltUnitarySpecialDistrict, ltSpecialDistrict,
                ltFlatFeeDistrict);
  TLevyTypeSet = set of TLevyTypes;

{=============  Prorata types ============}

  ProrataRemovedExemptionRecord = record
    ExemptionCode : String;
    AssessmentYear : String;
    HomesteadCode : String;
    CountyAmount : LongInt;
    MunicipalAmount : LongInt;
    SchoolAmount : LongInt;
    EffectiveDate : TDateTime;
    RemovalDate : TDateTime;
    CountyCalculated : Boolean;
    MunicipalCalculated : Boolean;
    SchoolCalculated : Boolean;
  end;

  ProrataRemovedExemptionPointer = ^ProrataRemovedExemptionRecord;


  ProrataDetailRecord = record
    ProrataYear : String;
    AssessmentYear : String;
    GeneralTaxType : String;
    HomesteadCode : String;
    ExemptionCode : String;
    LevyDescription : String;
    EffectiveDate : TDateTime;
    RemovalDate : TDateTime;
    CalculationDays : LongInt;
    TaxRate : Double;
    ExemptionAmount : LongInt;
    TaxAmount : Double;
  end;

  ProrataDetailPointer = ^ProrataDetailRecord;

  LeviesToProrateRecord = record
    PrintOrder : Integer;
    GeneralTaxType : String;  {Base rate or SD code}
    LevyDescription : String;
    SwisCode : String;
    SchoolCode : String;
    SpecialDistrictCode : String;
    Description : String;
    LevyType : TLevyTypes;
    ProrateThisLevy : Boolean;
  end;

  LeviesToProratePointer = ^LeviesToProrateRecord;


  BillingRateRecord = record
    AssessmentYear : String;
    AssessmentYearBilledFrom : String;
    CollectionType : String;
    CollectionNumber : Integer;
    PrintOrder : Integer;
    GeneralTaxType : String;  {Base rate or SD code}
    SpecialDistrictCode : String;
    HomesteadCode : String;
    ExtensionCode : String;
    LevyDescription : String;
    SwisCode : String;
    SchoolCode : String;
    Description : String;
    LevyType : TLevyTypes;
    HomesteadRate : Double;
    NonhomesteadRate : Double;
  end;

  BillingRatePointer = ^BillingRateRecord;


  RemovedExemptionSortRecord = record
    ExemptionCode : String;
    HomesteadCode : String;
    EffectiveDate : TDateTime;
    RemovalDate : TDateTime;
  end;

  RemovedExemptionSortPointer = ^RemovedExemptionSortRecord;


  ProrataTotalsRecord = record
    LevyDescription : String;
    AssessedValue : LongInt;
    TaxAmount : Double;
    TaxRate : Double;
    Count : Integer;
  end;

  ProrataTotalsPointer = ^ProrataTotalsRecord;

{=============  End of Prorata types ============}


  TRAVELauncherType = (rltBill, rltLetter, rltReport);

  OrthoMapLayerIndexRecord = record
    OrthoFileName : String;
    MaxX : Extended;
    MaxY : Extended;
    MinX : Extended;
    MinY : Extended;
  end;

  OrthoMapLayerIndexPointer = ^OrthoMapLayerIndexRecord;

  AuditRecord = record
    _FieldName : String;
    _TableName : String;
    _DataType : TFieldType;
    _StringValue : String;
    {$H+}
    _MemoValue : String;
    {$H-}
  end;

  AuditPointer = ^AuditRecord;

  GrievanceTotalsRecord = record
    TotalCount : LongInt;
    _Open : LongInt;
    _Closed : LongInt;
    _Approved : LongInt;
    _Denied : LongInt;
    _Dismissed : LongInt;
    _Withdrawn : LongInt;
  end;

  RoadRangeRecord = record
    StartingStreetNumber : String;
    StartingStreet : String;
    EndingStreetNumber : String;
    EndingStreet : String;
  end;

  RoadRangePointer = ^RoadRangeRecord;

  rCoopAVChange = record
    CoopID : Integer;
    CoopName : String;
    SwisSBLKey : String;
    Shares : Double;
    SharePercent : Double;
    CurrentAssessedValue : LongInt;
    NewAssessedValue : LongInt;
  end;

  ptrCoopAVChange = ^rCoopAVChange;

implementation

end.