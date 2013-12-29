unit Glblvars;

interface

uses Types, Forms, BtrvDlg, PASTypes, DBTables;

var
  GlblApplicationIsClosing : Boolean;  {Set when all of PAS is closing.}
  GlblClosingAForm : Boolean;{set by childform.onclose, ref by MainPasForm.OnActScreenchg}

    {the following items are loaded from the system record when user starts PAS}
  GlblDataDir,               {path to data for PAS, eg \PASYSTEM\DATA}
  GlblErrorFileDir,          {SCA error log path for SystemSupport, eg \PASYSTEM\ERRORLOG}
  GlblProgramDir,            {path to programs for PAS, eg \PASYSTEM}
  GlblRPSDataDir,            {path to the raw RPS data}
  GlblExportDir,            {path to where the 995 and 155 files we produce end up}
  GlblReportDir : String;     {path for reports \PASYSTEM\REPORTS}
  GlblDrive : String;          {What drive are the PAS directories located on?}

  GlblHistYear,
  GlblThisYear,
  GlblNextYear : String;  {contain current year values for ThisYear and NextYear}
                        {assessment files, loaded from system record}


   {variables set during PAS execution after startup}
  GlblClosingFormCaption : String;{used by tabs ctl of MDI interface to know when to}
                           {delete a tab, ref in OnActiveScreenChange event of}
                           {MainPASForm, set in OnClose of each Child Form}
                           {...when ClosingAForm is set on exiting a form, tells}
                           {MainPasForm.OnActScreen which form is closing so }
                           {it can tell which tab to delete}

  GlblTaxYearFlg : Char;   {set at startup or while user is in session}
                           {contains.. 'T' = Thisyear, 'N' = NextYear}

  GlblProcessingType : Integer;  {ThisYear, NextYear, History}

  GlblVersion : String;  {What version of PAS is this?}

  GlblMunicipalityName,
  GlblCountyName : String;

  GlblUnitName : String;     {used as part of SCA Error Dialog component processing}

  GlblUserName : String; {PAS Userid of current user}
  GlblSecurityLevel : Integer;  {Security level of user from user profile.
                                 10 = highest, 1 = lowest.}

    {The mode access levels are controlled in the user profile.}

  GlblNextYearAccess,
  GlblThisYearAccess : Integer;  {raNoAccess, raReadOnly, raReadWrite}
  GlblHistoryAccess : Boolean;

      {.. user prof for menus}
      {name?}

  {Parcltab.pas synchronization variables}
  GlblParcelPageCloseCancelled : Boolean;  {Used in the Parcel Add\Modify\Inquire
                                            to say if a person cancelled the
                                            exit on a page of the parcel notebook.
                                            ...See Parcltab.PAS and the child forms
                                            it spawns for detailed usage}

  GlblSearchDialogueInProgress : Boolean;  {use to skip some OnActiveScreen change
                                            events so SearchDialogue box, when displayed
                                            on screen, is not treated as a 'tab-associated'
                                            form, tested by MainForm.pas}

  GlblChildWindowCreateFailed : Boolean;  {Did the create of a child window
                                           fail because of memory problems?}

  GlblErrorDlgBox : TSCAErrorDialogBox;   {We will only have one error
                                           dialog box created in the main
                                           form and freed upon the close of
                                           the main form. This is for convienence
                                           and consistency.}

  GlblTraceTable : TTable;  {We will have a global trace table which is opened once and maintained
                             throughout the session. This will reduce the overhead of opening the
                             trace table on each form.}

  GlblCurrentTabNo,
  GlblCurrentLinePos : Integer;  {For printing directly to the printer.}

  GlblPreviewPrint : Boolean;  {Do they want to print to screen for this report?
                                This is only used for printing directly to
                                the printer.}

    {The following variables are stored in the system record
     and contain the formatting information for each part of the
     SBL key. They are set variables with the possible values of
     (fmLeftJustify, fmRightJustify, fmNumeric,
      fmAlphaNumeric, fmAlpha, fmShiftRightAddZeroes).}

  GlblSectionFormat    : TSBLSegmentFormatType;
  GlblSubsectionFormat : TSBLSegmentFormatType;
  GlblBlockFormat      : TSBLSegmentFormatType;
  GlblLotFormat        : TSBLSegmentFormatType;
  GlblSublotFormat     : TSBLSegmentFormatType;
  GlblSuffixFormat     : TSBLSegmentFormatType;

    {FXX11021999-12: Allow the # of forced digits in each segment to be specified.}

  GlblSectionDigits    : Integer;
  GlblSubsectionDigits : Integer;
  GlblBlockDigits      : Integer;
  GlblLotDigits        : Integer;
  GlblSublotDigits     : Integer;
  GlblSuffixDigits     : Integer;

    {The following are the separators for the dash dot format
     SBL. The seperator is between the named segment and the next
     one, i.e. the GlblSectionSeparator is between the section
     and subsection.}

  GlblSectionSeparator    : Char;
  GlblSubsectionSeparator : Char;
  GlblBlockSeparator      : Char;
  GlblLotSeparator        : Char;
  GlblSublotSeparator     : Char;

  GlblChangingTaxYear : Boolean;  {This is a flag to say that we are presently changing
                                   the tax year and closing all MDI children.}

  GlblMunicipalityType : Integer;  {MTCounty, MTTown, MTCity, MTVillage, MTSchool}
                                   {This is used for places where we are just going to
                                    show one exemption or taxable value type - that of
                                    the municipal entity.}

  GlblMunicipalityUsesTwoTaxRates : Boolean;  {Even though a municipality has
                                               hstd\non-hstd, they may only
                                               use one rate (i.e. Ramapo),
                                               so can't just rely on classified
                                               indicator.}

    {CHG10141997-2: Removed requirement for control number.
                    Is an option on municipality basis.}

  GlblSalesControlNumberRequired : Boolean;

      {These variables are used for the parcel locate so that it stays
       in the same key as last time and goes to the old parcel.}

  GlblLastSwisSBLKey : String;
  GlblLastLocateKey : Integer;

    {User preferences.}

  GlblShowHints : Boolean;                  {Based on the user profile,
                                             should we show hints on all forms?}

  GlblAskSave : Boolean;                    {In the parcel pages, should we ask AMC
                                             before they post?}

  GlblInterleaveTabs : Boolean;           {In the parcel pages, should the tabs for different
                                           processing types be all together or interleaved?}

  GlblNotesPurgeDefault : Boolean;  {When they enter a note, should
                                     we default the purge flag to
                                     true or false - this is an option
                                     is the user profile.}

  GlblDefaultSwisCode : String;  {The default swis code for the parcel locate.}

  GlblConfirmOnExit : Boolean;  {Confirm exit of whole PAS system?}

  GlblDefaultPreviewZoomPercent : Integer;  {What is the default zoom % for the preview form?}

  GlblFirstParcelPageShown : Integer;  {Either the form number of the summary page or the
                                        or the base page 1 - whatever the user prefers.}

    {CHG10281997-1: More work on dual mode modifying.}

  GlblModifyBothYears : Boolean;

    {CHG11071997-2: Limit menu options for searcher.}

  GlblUserIsSearcher : Boolean;

    {CHG11181997-1: For the searcher, need a way to exit parcel view.}

  GlblUserPressedParcelExit : Boolean;

    {FXX11101997-2: Only store traces for fields listed in the
                    screen label file, since these are all we care about.}

  GlblScreenLabelTable : TTable;

  GlblMunicipalityCode : String;  {The first four digits of each swis in the munic.}

    {FXX02061998-5: Allow the automatic addition of enhanced STAR exemptions
                    when a senior exemption is added be a municipality
                    decision.}

  GlblAutomaticallyAddEnhancedSTARExemptions : Boolean;

    {FXX02121998-1: Open the assessment year control table for ThisYear and
                    NextYear and put the STAR variables into global variables
                    so that we don't have to open the assessment table
                    each time to calculate STAR.  This was causing a
                    computer hang sometimes possibly due to going too deep
                    in the call stack.}

  GlblThisYearBasicSalesDifferential : Double;
  GlblThisYearBasicLimit : Comp;
  GlblThisYearEnhancedSalesDifferential : Double;
  GlblThisYearEnhancedLimit : Comp;
  GlblNextYearBasicSalesDifferential : Double;
  GlblNextYearBasicLimit : Comp;
  GlblNextYearEnhancedSalesDifferential : Double;
  GlblNextYearEnhancedLimit : Comp;

    {FXX04071998-6: Must keep track of whether or not
                    dual processing mode is on for TY.}

  GlblModifyBothYearsCheckedInTY : Boolean;

    {FXX04231998-8: Add global var to see if municipality is classified.}

  GlblMunicipalityIsClassified : Boolean;

    {CHG05011998-2: Add building permit report}

(*  GlblShowPermitForms : Boolean;*)

    {FXX06241998-1: The veterans maximums need to be at the county and swis level.}

  GlblCountyVeteransMax,
  GlblCountyCombatVeteransMax,
  GlblCountyDisabledVeteransMax : Comp;

  GlblIsWestchesterCounty : Boolean;
  GlblWarnIfAddEnhancedSTARWithoutSenior : Boolean;

    {CHG10121998-1: Add user options for default destination and show vet max msg.}

  GlblPrintToScreenDefault,
  GlblShowVetMaxMessage : Boolean;

   {FXX10231998-2: In order to fix the problem that Peggy has been having, we will make a universal
                   dialogboxshowing var and not worry about the individual kind.}

  GlblDialogBoxShowing : Boolean;

    {CHG12011998-1: Allow user ID's that only allow name and addr changes on pg 1.}

  GlblNameAddressUpdateOnly : Boolean;

    {FXX12291998-2: LB does not use override amounts for condos and we must calc
                    amount.}

  GlblAllowCondoExemptionOverride : Boolean;

    {CHG01251999-1 Add floating list capability.}

  GlblListDir : String;

  GlblSalesApplyToThisYear : Boolean;

    {FXX04091999-8: Allow for saving and loading of report options.}

  GlblReportOptionsDir : String;

    {FXX04161999-5: Allow people to modify other's notes if they want.}

  GlblModifyOthersNotes : Boolean;

  GlblDisplaySystemExemptionConfirmation : Boolean;

    {FXX05181999-2: Trace the add of the system exemption, but only if the
                    calling job requires it - i.e. running exemptions recalc,
                    since other jobs automatically insert a trace rec for the
                    system exemption.}


  GlblInsertSystemExemptionTrace : Boolean;

    {FXX05021999-1: Place on page where to start address for windowed
                    envelope.}

  GlblLetterAddressStart : Real;

    {CHG05131999-2: Let people look up parcels from the parcel list.}

  GlblParcelMaintenance : TForm;
  GlblLocateParcelFromList : Boolean;
  GlblParcelListSBLKey : String;

    {CHG06101999-1: Use mailing addr fields a la Mt. Vernon.}

  GlblUseMailingAddrFields : Boolean;

    {FXX06141999-2: Allow users to see warnings on a parcel right away.}

  GlblShowParcelWarnings : Boolean;

    {CHG06291999-1: Keep the searcher from seeing next year values.}

  SearcherCanSeeNYValues : Boolean;

    {CHG07191999-1: Allow municipality to choose which deed type is default.}

  GlblDefaultDeedType : String;

    {FXX08031999-2: Option to not enforce measurement restrictions.}

  GlblEnforceMeasurementRestrictions : Boolean;

    {CHG09021999-1: Save sales transmittals in a directory for history.}

  GlblSavedSalesDir : String;

    {CHG09071999-3: Allow selection of what warning messages are displayed.}

  GlblWarningOptions : WarningTypesSet;

    {FXX11021999-13: Allow the letter left margin to be customized.}

  GlblLetterLeftMargin : Real;

    {CHG12081999-1: Option to prompt if legal paper is required.}

  GlblRemindForLegalPaper : Boolean;

    {FXX12101999-5: Alow them to blank out dates.}

  GlblParcelTabChild : TForm;

  GlblSearchReportDefaultParcelType : Integer;

    {FXX12291999-1: Allow them to specify the number of blank lines at
                    the bottom of the roll.}

  GlblLinesLeftOnRollDotMatrix : Integer;
  GlblLinesLeftOnRollLaserJet : Integer;

   {FXX01142000-2: Don't ask if want to change assessment if prior to final roll.}

  GlblFinalRollDate : TDateTime;

    {CHG01182000-1: Option to not have searcher see exemption denials.}
    {CHG01182000-2: Allow users to click off the owner change button.}
    {FXX01182000-1: Need a default picture directory.}

  GlblSearcherViewsDenials : Boolean;
  GlblCanTurnOffOwnerChangeFlag : Boolean;
  GlblPictureDir : String;

  GlblUserSeesReportDialog : Boolean;

   {CHG02122000-3: Insert a name\addr audit change record.}
  GlblNameAddressTraceTable : TTable;

    {CHG03202000-1: For Ramapo remapping.}
  GlblLocateByOldParcelID : Boolean;

    {CHG04032000-1: Print full market value on rolls.}
  GlblPrintFullMarketValue : Boolean;

  GlblUseOldParcelIDsForSales : Boolean;

    {FXX06012000-1: Try using transactions around roll totals and audits to
                    reduce 84s and 85s.}

  GlblUseTransactions : Boolean;

    {CHG01082001-1: Auto detect new pictures / documents.}

  GlblAutoDetectNewPictures : Boolean;
  GlblAutoDetectNewDocuments : Boolean;

    {CHG02282001-1: Allow everybody to everyone elses changes.}

  GlblAllowAuditAccessToAll : Boolean;
  GlblDocumentDir : String;

    {CHG03212001-1: Password protect school code changes.}
    {CHG03212001-2: Only allow wholly exempt exemptions on vacant lands.}

  GlblPasswordProtectSchoolCode : Boolean;
  GlblSchoolCodeChangePassword : String;
  GlblAllowOnlyWhollyExemptsOnVacantLand : Boolean;

    {CHG04122001-1(MDT): Record removed exemptions.}

  GlblRecordRemovedExemptions : Boolean;

    {CHG04172001-1: Senior percent calculator.}

  GlblUseSeniorExemptionPercentCalculator : Boolean;

      {CHG05102001-1: Only let the searcher view summary and pg1}

  GlblSearcherOnlySeesSummaryAndPage1 : Boolean;

    {CHG06302001-1: Set enhanced options such as collate, duplex, bins.}

  GlblAlwaysPrintOnLetterPaper : Boolean;

    {CHG07132001-1: Allow searching subdirectories and picture masks.}

  GlblPictureMask : String;
  GlblSearchSubfoldersForPictures : Boolean;

  GlblDocumentMask : String;
  GlblSearchSubfoldersForDocuments : Boolean;

  GlblApplicationIsTerminatingToDoBackup : Boolean;

    {CHG09162001-1: New security option to not allow value changes.}

  GlblUserCanMakeValueChanges : Boolean;

    {CHG09272001-1: Parcel toolbar.}

  GlblUserWantsParcelToolbar : Boolean;

  GlblMapDirectory : String;

  GlblApplicationIsActive : Boolean;

  GlblUserCanSeeComparables : Boolean;
  GlblUserCanRunAudits : Boolean;

  GlblRecalculateSFLA : Boolean;
  GlblBuildingSystemLinkType : Integer;
  GlblBuildingSystemDatabaseName,
  GlblBuildingSystemTableName,
  GlblBuildingSystemIndexName : String;

  GlblShowAVChangeBox : Boolean;
  GlblShowInventoryValues : Boolean;

  GlblShowParcelYearFlipMenuItem : Boolean;

  GlblUsesMaps : Boolean;
  GlblUsesGrievances : Boolean;

  GlblCanCalculateRollTotals : Boolean;

  GlblMapInfoFormClosed : Boolean;
  GlblMapInfoFormClosingSwisSBLKey : String;

  GlblLastGrievanceNumber : Integer;
  GlblLetterTemplateDir : String;

  GlblUseRAR : Boolean;
  GlblShowFullMarketValue : Boolean;
  GlblSearcherCanSeeFullMarketValue : Boolean;

    {CHG07192002-1: Accomodate a seperate coop roll.}

  GlblIconFileName : String;
  GlblCaption : String;
  GlblIsCoopRoll : Boolean;

  GlblLastCertiorariNumber : Integer;
  GlblUseRARForResVacantLand : Boolean;

  GlblCertiorariOnly : Boolean;

  GlblLastLocateInfoRec : GlblLastLocateInfoRecord;

    {CHG12202002-1: Additional security for certs.}

  GlblCanSeeCertiorari : Boolean;
  GlblCanSeeCertNotes : Boolean;
  GlblCanSeeCertAppraisals : Boolean;

  GlblCanSeeSmallClaimsNotes : Boolean;

  GlblDefaultParcelViewPage : Integer;

  GlblFormatSegmentToLength : Boolean;
  GlblDontZeroFillBlankSegments : Boolean;

  GlblUseTFormPrint : Boolean;
  GlblUseRestrictSearcherParcelsFeature : Boolean;
  GlblSuppressRollTotalsUpdate : Boolean;
  GlblUseAccountNumberLookup : Boolean;
  GlblAnyUserCanChangeOpenNoteStatus : Boolean;
  GlblNoPartialExemptionsOnRollSection8 : Boolean;
  GlblSummaryAndPage1ValueInformationIsAlwaysPrior2Years : Boolean;
  GlblAllowBankCodeFreeze : Boolean;
  GlblExtractAdditionalLotsIn155File : Boolean;
  GlblDefaultToNoSwisRequiredOnParcelIDLookup : Boolean;

  GlblParcelToolbarIsCreated : Boolean;

  GlblUsesSketches : Boolean;
  GlblDefaultApexDir : String;
  GlblDefaultPictureLoadingDockDirectory : String;

  GlblSearcherMapDefault : String;
  GlblMapAV_SP_Ratio_Decimals : Integer;
  GlblReportReprintLeftMargin : Double;
  GlblReportReprintSectionTop : Double;
  GlblUsesVillage_Import_Export : Boolean;
  GlblVillageHoldingDockFolder : String;
  GlblRollTotalsToShow : TRollTotalsToShowType;

  GlblAV_BalancingFieldUpdates_AV : Boolean;
  GlblCertiorariReportsUseAlternateID : Boolean;
  GlblSearcherCreatesSelectedMapLayerLocally : Boolean;
  GlblCanPreventExemptionRenewal : Boolean;

    {CHG03222004-2(2.08): Option to prevent user from changing exemptions.}

  GlblUserCannotChangeExemptions : Boolean;
  GlblUseGeneralizedComparisonReport : Boolean;

    {CHG03232004-5(2.08): Private notes feature.}

  GlblUsePrivateNotes : Boolean;
  GlblUserCanEnterAndViewPrivateNotes : Boolean;

    {CHG03232004-7(2.08): Link up help.}

  GlblHelpDirectory : String;

  GlblSkipUnusedSalesFields : Boolean;
  GlblUseGlenCoveFormatForCodeEnforcement : Boolean;
  GlblBillDLLName : String;
  GlblBillRAVEName : String;
  GlblGrievanceSeperateRepresentativeInfo : Boolean;
  GlblAllUsersCreatesSelectedMapLayerLocally : Boolean;
  GlblIncludeFinishedBasementAreaInSFLA : Boolean;
  GlblSubtractUnfinishedArea : Boolean;

  GlblUseControlNumInsteadOfBook_Page : Boolean;
  GlblHideSalesPersonalProperty : Boolean;
  GlblHideSalesTransmitFields : Boolean;
  GlblNextSalesFieldAfterCondition : Integer;
  GlblShowUniformPercentInsteadOfSTARAmountOnSummaryScreen : Boolean;
  GlblShowAssessmentNotesOnAVHistoryScreen : Boolean;
  GlblPreventSearcherExit : Boolean;
  GlblAllowBlankDeedDate : Boolean;
  GlblCustomParcelLocate : Boolean;
  GlblShowExtendedSDAmounts : Boolean;
  GlblParcelLocateDefault : Integer;
  GlblCloseButtonIsLocate : Boolean;
  GlblParcelMaint_DisplayAccountNumber : Boolean;
  GlblParcelMaint_DisplayOldIDUnconverted : Boolean;
  GlblUser_Restricted_To_Name_Addr_Change_Can_Change_Owner : Boolean;
  GlblAllowSystemShutdown : Boolean;
  GlblShowExemptionDescription : Boolean;
  GlblShowMortgageOnPage1 : Boolean;
  GlblShowExemptionFilingInformation : Boolean;
  GlblUseEnhancedPrintDialog : Boolean;
  GlblApplicationIsMinimized : Boolean;
  GlblUse3DecimalsForDimensions : Boolean;
  GlblUser_BankCodeUpdateOnly : Boolean;
  GlblPreventParcelLocateMinimize : Boolean;
  GlblUsePrintSuitePrintScreen : Boolean;
  GlblShowNassauValues : Boolean;
  GlblShowSpecialDistrictDescriptions : Boolean;
  GlblAllowOldSBLEdit : Boolean;
  GlblMergeValuesDuringMerge : Boolean;
  GlblAllowSBLRenumber : Boolean;
  GlblPrintAccountNumbersOnReports : Boolean;
  GlblMunicipalityTypeName : String;
  GlblEnableExemptionCapOption : Boolean;
  GlblUsesProrata : Boolean;
  GlblEnablePermanentRetentionFeature : Boolean;
  GlblUseNewBuildingPermitPage : Boolean;
  GlblPrintScreenMethod : Integer;
  GlblPrintEstimatedTaxLetters : Boolean;

  GlblAssessmentYearIsSameAsTaxYearForCounty : Boolean;
  GlblAssessmentYearIsSameAsTaxYearForMunicipal : Boolean;
  GlblAssessmentYearIsSameAsTaxYearForSchool : Boolean;
  GlblUseNewStyleForms : Boolean;
  GlblTreatMixedUseParcelsAsResidential : Boolean;
  GlblUsesPASPermits : Boolean;
  GlblDoNotPrintNextYearOnF5 : Boolean;
  GlblLeaveApexActive : Boolean;
  GlblDefaultPropertyCardDirectory : String;

  GlblSupressDollarSignsOnAssessments : Boolean;
  GlblAllowLetterPrint : Boolean;
  GlblCurrentSwisSBLKey : String;
  GlblPropertyCardsArePDF : Boolean;
  GlblCoopBaseSBLHasSubblock : Boolean;

  GlblStartPASMaximized : Boolean;
  GlblUserCantDeleteExemptions : Boolean;
  GlblUsesApexMedina : Boolean;
  GlblRAVEBillName : String;
  GlblUsesAutoShutdown : Boolean;
  GlblDetectPicturesByAccountNumber : Boolean;
  GlblDisplayExemptionDescriptions : Boolean;
  GlblDisplaySpecialDistrictDescriptions : Boolean;
  GlblUserCanViewPermits : Boolean;
  GlblSuppressDocumentAutoload : Boolean;
  GlblDisplaySplitSchoolSBLs : Boolean;
  GlblDisplaySwisOnPrintKey : Boolean;

  glblOwnerAddressUpdateFilePath : String;
  glblCountyTaxDatabaseName : String;
  glblCountyCollectionType : String;
  glblCountyCollectionNumber : String;
  glblCountyBaseTaxRatePointer : String;
  glblSCARFormTemplateFileName : String;
  glblPrintSmallClaimsRebateForms : Boolean;
  glblDisplayAccountNumberOnCard : Boolean;
  glblUsesRAVEBills : Boolean;
  glblBillPrintMenuItem1 : Integer;
  glblBillPrintMenuItem2 : Integer;
  glblShowHistoryOfOwners : Boolean;
  glblShowNewOwnerOnSummaryTab : Boolean;
  glblShowImprovementValue : Boolean;

  glblAutoUpdateNamesAddrs : Boolean;
  glblDatabaseToUpdateNameAddrs1 : String;
  glblDatabaseToUpdateNameAddrs2 : String;
  glblDatabaseToUpdateNameAddrs3 : String;

  glblAutoCalcRollTotalsBeforePrint : Boolean;
  glblSuppressPrintSizePrompts : Boolean;
  glblAutoDuplex : Boolean;
  glblAutoVerticalDuplex : Boolean;
  glblSuppressIVP : Boolean;
  glblAlwaysShowMostCurrentSaleOnSalesPage : Boolean;
  glblUseNewOwnerProgressionForm : Boolean;
  glblDisplaySuppressFromGIS : Boolean;
  glblUseWindowsSaveDlgForReports : Boolean;
  glblTracePictureAccess : Boolean;
  glblUnfinRoomIsUnfinBsmt : Boolean;

  glblUsesSQLTax : Boolean;
  glblShowSTARSavingsOnExemptionPage : Boolean;
  glblUsesPictometry : Boolean;
  glblPreventPASStartup : Boolean;

  glblSmallClaimsDefaultYear : String;
  glblUsesPictometry_FullSBL : Boolean;
  glblShowSketchWithComments : Boolean;
  glblFreezeAssessmentDueToGrievance : Boolean;
  glblAllowSalesInventoryEdit : Boolean;

  glblUsesPictometry_OldPrintKey : Boolean;
  glblRemapOldSBLHasSwis : Boolean;
  glblUseExactPrintKey : Boolean;
  glblLocateDisplaysPrintKey : Boolean;
  glblToolbarLaunchesGIS : Boolean;

  glblInvDisplaysZoningCode : Boolean;
  glblDisplaySchoolShortCodeInSummary : Boolean;

  glblUsesTaxBillNameAddr : Boolean;
  glblShowExtendedNeighborhoodInfo : Boolean;

implementation

end.