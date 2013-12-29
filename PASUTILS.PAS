UNIT PASUtils;

{$N+}

INTERFACE
USES Types, Glblvars, SysUtils, WinTypes, WinProcs, BtrvDlg,
     Messages, Dialogs, Forms, wwTable, Classes, DB, DBTables, EXTCtrls, ADODB, 
     Controls,DBCtrls,StdCtrls, PASTypes, WinUtils, GlblCnst, Utilitys,
     wwDBLook, Graphics, RPBase, RPDefine,  wwdbGrid, Progress, Tabs, Buttons,
     RPRTPROG,  {Report reprint progress form}
     RptDIalg,
     DataModule,
     PrcLocat,  {Form to look up a parcel}
     PictureOrDocumentLoadDialog,
     LabelOptionsDialogUnit,
     LabelOptionsDialogOldUnit,
     GrievanceUtilitys, ShellAPI, Registry;

Function GetTaxRlYr: String;

Function GetTaxRollYearForProcessingType(ProcessingType : Integer) : String;
{This function returns the tax roll year for the given processing type, i.e.
 ThisYear, NextYear, History.}

Function GetProcessingTypeForTaxRollYear(TaxRollYr : String) : Integer;
{This function returns the processing type, i.e.
 ThisYear, NextYear, History given a tax roll year.}

Function GetMunicipalityType(MunicipalityType : Integer) : Integer;
{Given a municipality type, figure out which exemption or roll total
 type to use.}

Function GetMunicipalityTypeName(MunicipalityType : Integer) : String;
{Given a municipality type, figure out which municipality type this is -
 i.e. County, City, Town }

Function GetShortMunicipalityTypeName(MunicipalityType : Integer) : String;

Function ConvertYearBeingProcessedToText : String; overload;

Function ConvertYearBeingProcessedToText(TaxYearFlag : Char) : String; overload;

Function GetSwisFromSwisSBLKey (SwisSBLKey : String) : String;
{retrieves swiss code from SwisSBL key assuming swis code is in 1st 6 bytes}

Function ExtractYSSKey(InputTable : TTable) : String;
{this function provides a 30 char string of taxyr,Swis & SBL assembled from }
{the individual fields in any TTable component whose tx yr,Swis&sbl fields}
{are named as shown below}
{YSS = tax Year,Swiss,Sbl}

Function ExtractSSKey(InputTable : TTable) : String;
{this function provides a 26 char string of Swis SBL assembled from }
{the individual fields in any TTable component whose Swis/sbl fields}
{are named as shown below ...SS = Swis,Sbl}

Function ExtractSBL(InputTable : TTable) : String;
{this function provides a 20 char string of  SBL assembled from }
{the individual fields in any TTable component whose Swis/sbl fields}
{are named as shown below ...}

Function ExtractSwisSBLFromSwisSBLKey(SBLKey : String) : SBLRecord;
{Given an SBL in the SwisSBL (all together), return the individual parts in the
 SBLRecord.}

Function ExtractSBLFromSBLKey(SBLKey : String) : SBLRecord;
{Given an SBL  (w. NO swis), return the individual parts in the
 SBLRecord.}

Function GetSwisSBLFromSBLRecord(SBLRec : SBLRecord) : String;

Function SchoolCodesMatch_FullOrPartial(SchoolCode1,
                                        SchoolCode2 : String) : Boolean;
{Match the school codes on the least number of chars in either, i.e. if one
 has 2 and the other 4, only match on 4.}

Function SwisCodesMatch_FullOrPartial(SwisCode1,
                                      SwisCode2 : String) : Boolean;
{Match the Swis codes on the least number of chars in either, i.e. if one
 has 2 and the other 4, only match on 4.}

Procedure CreateFieldValuesAndLabels(Form : TForm;
                                     MainTable : TTable;
                                     FieldTraceInformationList : TList);
{Initialize the values and labels list for a table so that we can trace it.
 See below for more information.}

Procedure AddToTraceFile(SwisSBLKey,
                         FScreenName,  {Form caption}
                         FLabelName,
                         FOldValue,
                         FNewValue : String;
                         PresentTime : TDateTime;
                         MainTable : TTable);

Function RecordChanges(Form : TForm;
                       ScreenName : String;  {Pass in the screen name since may not be form name.}
                       MainTable : TTable;
                       SwisSBLKey : String;
                       FieldTraceInformationList : TList) : Integer;
{After posting the record, see if there are any changes and write
 a trace record for each of them. See below for more information.}

Function NumRecordChanges(Form : TForm;
                          MainTable : TTable;
                          FieldTraceInformationList : TList) : Integer;
{See how many changes there were to the record.}

(*
Function RecordChanges(Form : TForm;
                       ScreenName : String;  {Pass in the screen name since may not be form name.}
                       MainTable : TTable;
                       SwisSBL : String;
                       FieldValuesList,
                       FieldLabelsList : TStringList) : Integer;
{After posting the record, see if there are any changes and write
 a trace record for each of them. See below for more information.}

Function NumRecordChanges(Form : TForm;
                          MainTable : TTable;
                          FieldValuesList,
                          FieldLabelsList : TStringList) : Integer;
{See how many changes there were to the record.} *)

Function DetermineTableNameForTaxYear(TableName : String) : String;

{Return the table name after adjusting the table name for the present processing
 type ('N', 'T', 'H'). Note that we return the new table
 name only - do not actually change the name of the table!}

Procedure SetTableNameForTaxYear(Table : TTable);
{Change the first letter of the table name based on the global tax year (i.e. 'N', 'T', 'H').}

Function ExpandPASPath(Directory : String) : String;
{Given a PAS directory, append a drive letter.}

Procedure SetTableNameForProcessingType(Table : TTable;
                                        ProcessingType : Integer);  {History, This Year,
                                                                     Next Year, SalesInv}
{Based on the processing type (History, ThisYear, NextYear, or SalesInventory), change
 the first letter of the table name to 'H', 'T', 'N', or 'S', respectively.}

Function DetermineTableNameForProcessingType(TableName : String;
                                             ProcessingType : Integer) : String;  {History, This Year,
                                                                                   Next Year, SalesInv}
{Based on the processing type (History, ThisYear, NextYear, or SalesInventory), change
 the first letter of the table name to 'H', 'T', 'N', or 'S', respectively.}

Function MakeLegalAddress(LegalAddressNumber : String;
                          LegalAddressName : String) : String;

Function GetLegalAddressFromTable(Table : TTable) : String;
{Concatenate the legal addr. no. and legal address into a string.}

Function GetLegalAddressFromADOQuery(AQuery : TADOQuery) : String;
{Concatenate the legal addr. no. and legal address into a string.}

Function LegalAddressesDifferent(LegalAddressName1 : String;
                                 LegalAddressNumber1 : String;
                                 LegalAddressName2 : String;
                                 LegalAddressNumber2 : String) : Boolean;

Function GetTaxYrLbl : String;
{Create the text for the tax year label.}

Procedure SetTaxYearLabelForProcessingType(TaxLabel : TLabel;
                                           ProcessingType : Integer);  {History, This Year,
                                                                        Next Year, SalesInv}
{Based on the processing type (History, ThisYear, NextYear, or SalesInventory), change
 the label's color and text.}

Function ExecuteParcelLocateDialog(var SBLKey : String;
                                       ShowCancelButton,
                                       ShowExitButton : Boolean;
                                       TitleString : String;
                                       _AllowMultiSelect : Boolean;
                                       _SwisSBLKeyList : TStringList) : Boolean;

{Shows the parcel locate form. If they hit OK, the result of
 this function is True and the SBLKey is filled in with the
 SBL that they chose. Otherwise, it returns False.}

Function FormatSegment(    SegmentName : String;
                       var Segment : String;
                           MaxLen : Integer;
                           SegmentFormat : TSBLSegmentFormatType;
                           ReportErrors : Boolean) : Boolean;
{Format one segment of an SBL based on the SegmentFormat flags.
 The return value is True if the segment is valid, False if it
 is not.}

Function ConvertSwisSBLToDashDot(SwisSBLKey : String) : String;
{Given a 26 char SwisSBL, convert it to dash dot format.}

Function ConvertSBLOnlyToDashDot(SBLKey : String) : String;
{Given a 20 char SBL, convert it to dash dot format.}

Function ConvertSwisSBLToDashDotNoSwis(SwisSBLKey : String) : String;
{Given a 26 char SwisSBL, convert it to dash dot format,
 but do not prefix with the swis code.}

Function ConvertDashDotSBLToSegmentSBL(    DashDotSBL : String;
                                       var ValidEntry : Boolean) : SBLRecord;
{Given an SBL entry in dash dot format, convert it to a segment style
 SBL in an SBLRecord format.}

Function ConvertSwisDashDotToSwisSBL(    SwisDashDotSBL : String;
                                         SwisCodeTable : TTable;
                                     var ValidEntry : Boolean) : String;
{Given a SwisDashDotSBL in the form ss\SBL where ss = swis short code and a swis code table,
 return the 26 char SwisSBL and if the entry was valid.}

Procedure ForceSBLRecordFormat(var SBLRec : SBLRecord);

Procedure MarkRecChanged(Table : TTable;
                         UnitName : String);
{Update this parcel, residential site, or commercial site record with the name and date changed.}

Procedure SetRangeForHistoryTaxYear(Table : TTable;
                                    TaxRollYrFieldName,
                                    FieldName : String);  {What is the name of the field to set the range on?}
{This proc. is used only for history processing - range based on
 the global history year that they have selected.}

Procedure SetIndexForCodeTable(Table : TTable;
                               FieldName : String);   {What is the name of the field to set the index on?}
{Set the index to either MainCode or Description for a lookup table.}

Procedure LoadCodeList(    CodeList : TList;
                           CodeTableName,
                           MainCodeFieldName,
                           DescriptionFieldName : String;
                       var Quit : Boolean);
{Load the codes and description for the given table into the given code list.}

Procedure LoadCodeListWithProcessingType(    CodeList : TList;
                                             CodeTableName,
                                             MainCodeFieldName,
                                             DescriptionFieldName : String;
                                             ProcessingType : Integer;
                                         var Quit : Boolean);

Function GetDescriptionFromList(Code : String;
                                List : TList) : String;
{Look through the list for the code if it is non blank. Return the description
 for this code. If we can not find the code, then we will return "UNKNOWN".}

Procedure SetGlobalSBLSegmentFormats(AssessmentYearCtlTable : TTable);

{This procedure determines if a user has read-write access to this
 program or read-only.}
Function ModifyAccessAllowed(FormAccessRights : Integer) : Boolean;

Function DetermineProcessingType(ProcessingTypeChar : Char) : Integer;
{Convert from the letter based processing year to the constants listed in GLBLCNST.}

Function NameAddressInfoChanged(OrigNameAddressRec,
                                NewNameAddressRec : NameAddressRecord) : Boolean;

Function ConvertProcessingTypeToChar(ProcessingType : Integer) : Char;
{Convert from the processing type constants listed in GLBLCNST to a char.}

Function ParcelIsActive(ParcelTable : TTable) : Boolean;
{Is this parcel active?}

Function MarkParcelInactive(ParcelTable : TTable;
                            TaxRollYr : String;
                            ParcelID : String) : Boolean;
{Set the active flag of a parcel to inactive. If successful, return True,
 otherwise, False.}

Function MarkParcelReactivated(ParcelTable : TTable;
                               TaxRollYr : String;
                               ParcelID : String) : Boolean;
{Set the active flag of a parcel to reactivated. If successful, return True,
 otherwise, False.}

Function DetermineDescriptionField(FieldName : String) : String;
{Given a field 'xxxCode', return 'xxxDesc'.}

Procedure RefreshDropdownsAndLabels(Form : TForm;
                                    MainTable : TTable;
                                    DescriptionIndexedLookups : DropdownTagIDSetType);
{For some reason the lookup boxes were not being filled in with the
 value in the underlying MainTable field when the form was initialized,
 so this fills in the fields so that the data is visible. Note that this
 does not cause the table to be marked modified. Also, we will fill
 in any labels for code based dropdowns. Note that the label names (not captions)
 must be EXACTLY the description field name in the table.}

          {CHG10091997-1: Should zeroes be blanks or '0'?}
Procedure SetDisplayFormatForCurrencyFields(Form : TForm;
                                            DisplayZeroesAsBlanks : Boolean);
{Set up the currency fields display formats to $xxx,xxx}

Procedure OpenTableForProcessingType(    Table : TTable;
                                         TableName : String;
                                         ProcessingType : Integer;
                                     var Quit : Boolean);
{Open the table with the given the table name and processing type.}

Function OpenTablesForForm(Form : TComponent;
                           ProcessingType : Integer) : Boolean;
{Given a form, open all tables on it using the fast open method. Any table
 which does not have a table name filled in, i.e. the CodeTable on many parcel pages,
 will not be opened. This function returns true if all the tables are opened
 successfully.
 If this form does not have a specific processing type (i.e. any
 non parcel page), just pass in GlblProcessingType which is a
 variable corresponding to the tax year flag.}

Procedure CloseTablesForForm(Form : TComponent);
{Close all the tables on the form.}

Procedure DeleteRecordsForParcel(    Table : TTable;
                                     TaxRollYear : String;
                                     SwisSBLKey : String;
                                 var Quit : Boolean);
{Delete all the records with this TaxRollYr\SwisSBL in this file.}

Function PropertyIsResidential(PropertyClass : String) : Boolean;
{Determine if a property is residential. For now, we are assuming
 that any 2xx class is residential, but this needs more investigation.}

Function ReturnCheckDigit(SwisSBLKey : String;
                          SequenceNumber : Integer) : String;
{DS: Return the RPS check digit given the SwisSBL.}

Function DetermineExemptionResidentialType(ExemptionCode : String) : String;

Function PropertyClassIsResidential(PropertyClassCode : String;
                                    OwnershipCode : String) : Boolean;


Function CalculateNumSites(SiteTable : TTable;
                           TaxRollYr : String;
                           SwisSBLKey : String;
                           SalesNo : Integer;
                           SalesInventory : Boolean) : Integer;
{This procedure figures out how many sites there are for a parcel -
 both commercial and residential.}

Procedure CalculateHstdAndNonhstdAmounts(    TaxRollYr : String;
                                             SwisSBLKey : String;
                                             AssessmentTable,
                                             ClassTable,
                                             ParcelTable : TTable;
                                         var HstdAssessedVal,
                                             NonhstdAssessedVal,
                                             HstdLandVal,
                                             NonhstdLandVal : Comp;
                                         var HstdAcres,
                                             NonhstdAcres : Real;
                                         var AssessmentRecordFound,
                                             ClassRecordFound : Boolean);
{Given the assessment table, class table, and parcel table, return the
 homestead and nonhomestead assessed values. If this is not a classified
 municipality, then the one assessed value will be returned in the
 HstdAssessedVal variable.
 Also, we will return the homestead and nonhomestead land and acreage values.}

Procedure LogException(ExceptionMessage,
                       ExceptionClassName,
                       AdditionalMsg : String;
                       ExceptionAddr : Pointer);
{Store this unhandled exception in the SCA error file log.}

Function GetPrintFileName(Caption : String;
                          ChangeToPrintDir : Boolean) : String;
{We want a unique file name, so we will use the first two letters of the
 form name plus the time down to the millisecond.}
{The form of the file name is xxHHMMSS.MM (Two letters\Hour\minute\second.millisecond)}

Procedure PrintSelectedSwisCodes(Sender : TObject;
                                 SelectedSwisCodes : TStringList;
                                 SwisCodeTable : TTable);
{For a report where they can select any number of swis codes, this prints out
 what swis codes they selected. If they selected all, we will just say all instead
 of printing all.}

Function GetMunicipalityName : String;
{Return the municipality name with the type.}

Procedure GetAuditParcelRec(    ParcelTable : TTable;
                                _AssessedVal : Comp;
                                EXAmounts : ExemptionTotalsArrayType;
                            var AuditParcelRec : AuditParcelRecord);
{Get the information that we need in order to write out a trace record
 if any important roll totals change.}

Procedure InsertParcelChangeRec(SwisSBLKey : String;
                                TaxRollYr : String;
                                AuditParcelChangeTable : TTable;
                                OrigAuditParcelRec,
                                NewAuditParcelRec : AuditParcelRecord;
                                RecordType : Char);
{CHG03161998-1: Track exemption, SD adds, av changes, parcel add/del.}
{CHG03301998-1: Trace SD, EX changes from everywhere. Also more parcel info.}
{Add an audit record to track parcel additions and deletions.}

Procedure SetOrientation(Sender : TObject;
                         _Orientation : Integer);  {0=Portrait, 1=Landscape}
{FXX04171998-1: In order to get the setting in the printer dialog to
                work, must take info out of print dialog and put into
                Report components.}

Procedure FillInNameAddrArray(    Name1,
                                  Name2,
                                  Address1,
                                  Address2,
                                  Street,
                                  City : String;
                                  State : String;
                                  Zip : String;
                                  ZipPlus4 : String;
                                  IncludeZipPlus4 : Boolean;
                                  bPrintOrCurrentOwner : Boolean;
                              var NAddrArray : NameAddrArray);

Procedure GetNameAddress(    Table : TTable;
                         var NAddrArray : NameAddrArray);
{Given a parcel in the parcel table, return the name and address in an array.}

Procedure GetNameAddress_OrCurrentOwner(    Table : TTable;
                                        var NAddrArray : NameAddrArray);


Procedure PrintLetterHeader(Sender : TObject;
                            AssessorOfficeTable : TTable;
                            ParcelNAddrArray : NameAddrArray;
                            PrintLetterHead : Boolean;
                            PrintedDate : TDateTime;
                            PrintNameAddress : Boolean);
{Print the letter head on a letter.}

Procedure PrintTextReport(    Sender : TObject;
                          var ReportTextFile : TextFile;
                              StartPage,
                              EndPage : Integer);

Function ParcelUsesRAR(PropertyClassCode,
                       OwnershipCode : String) : Boolean;

Function GetUniformPercentOrRAR(    SwisCodeTable : TTable;
                                    PropertyClassCode,
                                    OwnershipCode : String;
                                    UseUniformPercentOverride : Boolean;
                                var IsUniformPercent : Boolean) : Double;

Function ComputeFullValue(AssessedValue : Comp;
                          SwisCodeTable : TTable;
                          PropertyClassCode,
                          OwnershipCode : String;
                          UseUniformPercentOverride : Boolean) : Comp; overload;

Function ComputeFullValue(iAssessedValue : LongInt;
                          fUniformatPercent : Double) : LongInt; Overload;

Function ComputeTaxLevyPercentChange(CurrentTaxLevy,
                                     PriorTaxLevy : Comp) : Double;

Procedure PrintSelectedList(Sender : TObject;
                            SelectedList : TStringList;
                            Header : String);

Procedure SetGlobalUserDefaults(UserProfileTable : TTable);

Procedure SetGlobalSystemVariables(SysRecTable : TTable);

Procedure SetGlobalAssessorsOfficeVariables(AssessorsOfficeTable : TTable);

Procedure SetGlobalWarningOptions(WarningsDisplayedTable : TTable);

Function GetNameAddressBankCodeInfo(ParcelTable : TTable) : NameAddressBankCodeRecord;

Function NameAddressBankCodeDifferent(NameAddrBankCodeRec1,
                                      NameAddrBankCodeRec2 : NameAddressBankCodeRecord) : Boolean;

Function FindProcessingTypeOfLastFinalRoll(    TempDate : TDateTime;
                                           var TaxRollYr : String;
                                           var Found : Boolean) : Integer;
{Given a date, find the processing type (assessment year) of the previous final roll.}

Function HistoryExists : Boolean;

Function ConvertModeToStr(Mode : Integer) : String;
{FXX04081999-6: These were moved here for split\merge tracing.}

Procedure LoadScreenLabelList(ScreenLabelList : TList;
                              ScreenLabelTable,
                              UserFieldDefinitionTable : TTable;
                              LoadUserDefinedFields : Boolean;
                              LoadOnlyReportVisibleFields : Boolean;
                              UseReportDisplayNames : Boolean;
                              ScreensToShow : TScreenType);

Procedure ShowReportDialog(DefaultFileName,
                           OriginalFileName : String;
                           ReportFile : Boolean);


Procedure InitNameAddressRecord(var NameAddressRec : NameAddressRecord);

Function GetNameAddressInfo(ParcelTable : TTable) : NameAddressRecord;

Function InsertNameAddressTraceRecord(SwisSBLKey : String;
                                      OrigNameAddressRec,
                                      NewNameAddressRec : NameAddressRecord) : Boolean;

Procedure SetOldSegmentFormats;

Function ConvertSwisSBLToOldDashDotNoSwis(SwisSBLKey : String;
                                          AssessmentYearControlTable : TTable) : String;

Function ConvertSwisSBLToOldDashDot(SwisSBLKey : String;
                                    AssessmentYearControlTable : TTable) : String;

Function ConvertSBLOnlyToOldDashDot(SBLKey : String;
                                    AssessmentYearControlTable : TTable) : String;

Function ConvertOldDashDotSBLToSegmentSBL(    DashDotParcelID : String;
                                              AssessmentYearControlTable : TTable;
                                          var ValidEntry : Boolean) : SBLRecord;

Function ConvertOldSwisDashDotSBLToSwisSBL(    DashDotParcelID : String;
                                               AssessmentYearControlTable,
                                               SwisCodeTable : TTable;
                                           var ValidEntry : Boolean) : String;

Procedure SetOldParcelIDLabel(OldParcelIDLabel : TLabel;
                              ParcelTable,
                              AssessmentYearControlTable : TTable);

Function CheckIfParcelIsActive(AssessmentYear : String;
                               ProcessingType : Integer;
                               SwisSBLKey : String) : Integer;

Function FindTableInDataModuleForProcessingType(TableName : String;
                                                ProcessingType : Integer) : TwwTable;

Function ConvertRegularTableNameToDataModuleName(RegularTableName : String) : String;
{Given a table name with its regular constant, come up with the data module name.}

Procedure DetectNewPicturesOrDocuments(_SwisSBLKey : String;
                                       SearchDirectory : String;
                                       DocumentType : Integer;
                                       AutoAdd : Boolean;
                                       ItemsAdded : TStringList;
                                       AlreadyOnFileList : TStringList;
                                       UseLastPartOfFileNameForNotes,
                                       LoadAtTopOfPictureList : Boolean;
                                       ExactParcelIDMatchOnly : Boolean;
                                       sAccountNumber : String;
                                       sPrintKey : String);

Function GetLegalAddressInt(sLegalAddrNo : String) : Integer;

Procedure SetExtractFlags(SwisSBLKey : String);

Procedure GetLegalNameAddress(    ParcelTable,
                                  SwisCodeTable : TTable;
                              var LegalNameAddrArray : NameAddrArray;
                                  UseZipCodeFromSwis : Boolean);

Function MailingAndLegalAddressEqual(ParcelTable : TTable;
                                     SwisCodeTable : TTable) : Boolean;

Function CalculateSquareFootLivingArea(ResidentialBuildingTable : TTable) : Integer;

Function NameAddressesDifferent(NameAddrArray1,
                                NameAddrArray2 : NameAddrArray;
                                StripCommas : Boolean) : Boolean;

Procedure PrintLabelParcelID_Class(    SwisSBLKey : String;
                                   var NAddrArray : NameAddrArray;
                                       PrintClass : Boolean;
                                       PrintSwisCodeOnParcelIDs : Boolean;
                                       PropertyClass : String);

Procedure PrintLabelAccountNumber_OldID(var NAddrArray : NameAddrArray;
                                            AccountNumber : String;
                                            OldParcelID : String);
                                       
Procedure PrintLabelOldAndNewParcelID(    SwisSBLKey : String;
                                      var NAddrArray : NameAddrArray;
                                          ParcelTable : TTable;
                                          AssessmentYearControlTable : TTable;
                                          PrintSwisCodeOnParcelIDs : Boolean;
                                          ShortForm : Boolean);

Procedure PrintLabelAcctNum_Addr_OldID_ParcelID(    SwisSBLKey : String;
                                                var NAddrArray : NameAddrArray;
                                                    ParcelTable : TTable;
                                                    PrintSwisCodeOnParcelIDs : Boolean);

Procedure PrintOwner_ExemptionCode_LegalAddress_PrintKey(    SwisSBLKey : String;
                                                         var NAddrArray : NameAddrArray;
                                                             ParcelTable : TTable;
                                                             ExemptionCode : String;
                                                             PrintSwisCodeOnParcelIDs : Boolean);

Procedure PrintOwner_LegalAddress_PrintKey(    SwisSBLKey : String;
                                           var NAddrArray : NameAddrArray;
                                               ParcelTable : TTable;
                                               PrintSwisCodeOnParcelIDs : Boolean);

Procedure GetLabelListForParcelList(LabelList : TList;
                                    ParcelListForLabels : TStringList;
                                    ParcelTable : TTable;
                                    SwisCodeTable : TTable;
                                    AssessmentYearControlTable : TTable;
                                    AssessmentYear : String;
                                    LabelOptions : TLabelOptions);

Procedure PrintLabelHeader(Sender : TObject;
                           LabelOptions : TLabelOptions);

Procedure PrintLabels(Sender : TObject;
                      ParcelListForLabels : TStringList;
                      ParcelTable : TTable;
                      SwisCodeTable : TTable;
                      AssessmentYearControlTable : TTable;
                      AssessmentYear : String;
                      LabelOptions : TLabelOptions);

Procedure FreeLabelList(LabelList : TList;
                        LabelOptions : TLabelOptions);

Procedure PrintLabelHeaderOld(Sender : TObject;
                              LabelType : Integer;
                              LaserTopMargin : Double;
                              PrintLabelsBold : Boolean);

Function ExecuteLabelOptionsDialogOld(var lb_PrintLabelsBold : Boolean;
                                      var lb_PrintOldAndNewParcelIDs : Boolean;
                                      var lb_PrintSwisCodeOnParcelIDs : Boolean;
                                      var lb_PrintParcelIDOnly : Boolean;
                                      var lb_LabelType : Integer;
                                      var lb_NumLinesPerLabel : Integer;
                                      var lb_NumLabelsPerPage : Integer;
                                      var lb_NumColumnsPerPage : Integer;
                                      var lb_SingleParcelFontSize : Integer;
                                      var lb_ResidentLabels : Boolean;
                                      var lb_LegalAddressLabels : Boolean;
                                      var lb_PrintParcelIDOnlyOnFirstLine : Boolean;
                                      var lb_LaserTopMargin : Real;
                                      var lb_PrintParcelID_PropertyClass : Boolean) : Boolean;

Procedure PrintLabelsOld(Sender : TObject;
                         LabelList : TList;
                         LabelType : Integer;
                         PrintParcelIDOnly : Boolean;
                         PrintLabelsBold : Boolean;
                         NumLinesPerLabel : Integer;
                         NumLabelsPerPage : Integer;
                         NumColumnsPerPage : Integer;
                         SingleParcelFontSize : Integer;
                         FontSizeAdditionalLines : Integer; {Set to zero if regular 10pt should be used.}
                         LinesToBold : TStringList;
                         PrintLabelsUnderline : Boolean;
                         LinesToUnderline : TStringList;
                         PrintLabelsItalicized : Boolean;
                         LinesToItalicize : TStringList);

Procedure InsertAuditAVChangeRec(AuditAVChangeTable : TTable;
                                 SwisSBLKey : String;
                                 TaxRollYr : String;
                                 OrigLandAssessedVal,
                                 OrigTotalAssessedVal,
                                 OrigPhysicalQtyInc,
                                 OrigPhysicalQtyDec,
                                 OrigEqualizationInc,
                                 OrigEqualizationDec : Comp;
                                 OrigEXAmounts : ExemptionTotalsArrayType;
                                 NewLandAssessedVal,
                                 NewTotalAssessedVal,
                                 NewPhysicalQtyInc,
                                 NewPhysicalQtyDec,
                                 NewEqualizationInc,
                                 NewEqualizationDec : Comp;
                                 NewEXAmounts : ExemptionTotalsArrayType);

Procedure InitGlblLastLocateInfoRec(var GlblLastLocateInfoRec : GlblLastLocateInfoRecord);

Function GetFieldFromTable(_TableName : String;
                           LookupFieldName : String;
                           TargetFieldName : String;
                           IndexName : String;
                           LookupData : String;
                           UseDataModuleTable : Boolean;
                           ProcessingType : Integer) : String;

Function ExemptionIsCalculatedAlternativeVeteran(ExemptionCode : String) : Boolean;

Function ExecuteLabelOptionsDialog(var LabelOptions : TLabelOptions) : Boolean;

Procedure InitializeSBLRecord(var SBLRec : SBLRecord);

Function SBLRecordsDifferent(SBLRec1,
                             SBLRec2 : SBLRecord) : Boolean;

Function TableIsYearBasedTable(TableName : String) : Boolean;

Function ApexIsInstalledOnComputer : Boolean;

Function GetTableNameFromScreenName(ScreenLabelList : TList;
                                    _ScreenName,
                                    _LabelName : String) : String;

Function GetFieldNameForScreenLabel(ScreenLabelList : TList;
                                    _ScreenName,
                                    _LabelName : String) : String;

Function ConvertSwisSBLToNassauDashDot(SwisSBLKey : String) : String;

Function AllSwisCodesInSameMunicipality(SwisCodeTable : TTable) : Boolean;

Function ConvertFrom_GlenCoveTax_Building_To_PAS_SBL(SBL : String) : String;

Function ConvertFrom_PAS_To_GlenCoveTax_Building_SBL(SBL : String) : String;

Procedure OpenHelpDocument(HelpDocumentTable : TTable;
                           HelpIndex : LongInt);

Procedure SetFilterForHistoryYear(Table : TTable;
                                  AssessmentYear : String);

Function ConvertFileNameToApexWMFFileName(QualifiedFileName : String;
                                          ChangePath : Boolean;
                                          IncludePath : Boolean) : String;

Procedure MakeCloseButtonLocate(CloseButton : TBitBtn);

Function ParcelDimensionsToString(ParcelTable : TTable) : String;

Procedure ResizeTitleInformation(Form : TForm);

Procedure ResizeHeaderInformation(Form : TForm);

Procedure ResizeFooterInformation(Form : TForm);

Procedure LaunchRAVE(      ProjectName : String;
                     const ParameterNameList : Array of const;
                     const ParameterList : Array of const;
                           RAVELauncherType : TRAVELauncherType);

Procedure GetAuditInformation(Table : TTable;
                              AuditList : TList);

Procedure StoreAuditInformation(OriginalAuditList : TList;
                                NewAuditList : TList;
                                User : String;
                                EditMode : String;  {(E)dit, (I)nsert, (D)elete}
                                KeyFieldType : Integer);

Procedure StoreAuditNotesInformation(OriginalAuditList : TList;
                                     NewAuditList : TList;
                                     User : String;
                                     EditMode : String;  {(E)dit, (I)nsert, (D)elete}
                                     KeyFieldType : Integer);

Function CategoryMeetsCollectionTypeRequirements(CollectionType : String;
                                                 Category : String) : Boolean;

Function GetDescriptionForCode(CodeTable : TTable;
                               Code : String;
                               DescriptionFieldName : String) : String;

Function ParcelExistsInAnyYear(SwisSBLKey : String;
                               YearsOfExistence : TStringList) : Boolean;

Procedure DeleteParcelPermanently(    AssessmentYear : String;
                                      SwisSBLKey : String;
                                  var Quit : Boolean);

Procedure GetAllAssessmentYears(AssessmentYears : TStringList); overload;

Procedure GetAllAssessmentYears(AssessmentYears : TStringList;
                                DatabaseName : String); overload;

Function GetCooperativeBase(SBL : String;
                            AccountNumber : String;
                            BaseIsSBL : Boolean;
                            IncludeSublotInBaseSBL : Boolean) : String;

Function GetPropertyClass_OwnershipCode(PropertyClassCode : String;
                                        OwnershipCode : String) : String; overload;

Function GetPropertyClass_OwnershipCode(Table : TTable) : String; overload;

Function GetMalverneSwisSBLFromPrintKey(PrintKey : String;
                                        SwisCode : String) : String;

Function GetAssessmentDisplayFormat : String;

Function ParcelIsNonImprovedVacantLand(PropertyClass : String) : Boolean;

Function GetSketchLocation(SketchTable : TTable;
                           ApexInstalled : Boolean) : String;

Function GetMunicityCODateForPermit(qryCertificates : TADOQuery;
                                    sPermitID : String;
                                    sParcelID : String) : String;

Function GetPOBox(tbParcels : TTable) : String;

Function VillageIsAssessingUnit(sSWISCode : String) : Boolean;

Function GetCodeDescription(sCodeValue : String;
                            sTableName : String) : String;

Function CheckTaxSystemStatus(    sSchoolCode : String;
                                  sSwisCode : String;
                                  sSBL : String;
                                  iTaxSystemType : Integer;
                                  sCountyTaxDatabaseName : String;
                                  sTaxRatePointer : String;
                              var iTaxSystemAssessedValue : Integer;
                              var iTaxSystemExemptionValue : Integer;
                              var iTaxSystemTaxableValue : Integer) : Boolean;

Function CheckTaxSystemStatus_SQL(    sSchoolCode : String;
                                      sSwisCode : String;
                                      sSBL : String;
                                      iTaxSystemType : Integer;
                                      sCountyTaxDatabaseName : String;
                                      sTaxRatePointer : String;
                                  var iTaxSystemAssessedValue : Integer;
                                  var iTaxSystemExemptionValue : Integer;
                                  var iTaxSystemTaxableValue : Integer) : Boolean;

Procedure AutoUpdateNamesAndAddressesInOtherSystems(tbPASParcels : TTable;
                                                    sSwisSBL : String;
                                                    sAssessmentYear : String);

Function UserIsSupervisor(sUserName : String) : Boolean;

Function DetermineEditStatusForInventoryForm(EditMode : String;
                                             ProcessingType : Integer;
                                             GlblTaxYearFlag : String;
                                             glblAllowSalesInventoryEdit : Boolean) : Boolean;

                                                    
IMPLEMENTATION

uses UtilrTot, UtilEXSD, UtilPrcl, DataAccessUnit;

{===================================================================}
Function GetTaxRlYr : String;

{This function returns the tax roll year the user is working on}
{eg the ThisYear or NextYear value as string, YYYY}

begin
  case GlblTaxYearFlg of
   'T' : Result := GlblThisYear;
   'N' : Result := GlblNextYear;
   'H' : Result := GlblHistYear;

   else NonBtrvSystemSupport(900, 999, 'Global tax year flag not set.', 'PASUTILS.PAS',
                             GlblErrorDlgBox);

  end;  {case GlblTaxYearFlg of}

end;  {GetTaxRlYr}

{===================================================================}
Function GetTaxRollYearForProcessingType(ProcessingType : Integer) : String;

{This function returns the tax roll year for the given processing type, i.e.
 ThisYear, NextYear, History.}

begin
  case ProcessingType of
   ThisYear : Result := GlblThisYear;
   NextYear : Result := GlblNextYear;
   History : Result := GlblHistYear;
   SalesInventory : Result := GetTaxRlYr;  {If any processing year is needed in
                                           sales inventory, use present GlblTaxYearFlg.}

   else NonBtrvSystemSupport(901, 999, 'Global tax year flag not set.', 'PASUTILS.PAS',
                             GlblErrorDlgBox);

  end;  {case GlblTaxYearFlg of}

end;  {GetTaxRollYearForProcessingType}

{===================================================================}
Function GetProcessingTypeForTaxRollYear(TaxRollYr : String) : Integer;
{This function returns the processing type, i.e.
 ThisYear, NextYear, History given a tax roll year.}

begin
  If (TaxRollYr = GlblThisYear)
    then Result := ThisYear
    else
      If (TaxRollYr = GlblNextYear)
        then Result := NextYear
        else Result := History;

end;  {GetProcessingTypeForTaxRollYear}

{===================================================================}
Function ConvertYearBeingProcessedToText : String; Overload;

{This function looks at the global var. GlblTaxYearFlg and
 returns a text description (i.e. 'This Year').}

begin
  case GlblTaxYearFlg of
    'T' : Result := 'This Year';
    'N' : Result := 'Next Year';
    'H' : Result := 'History';

  end;  {case GlblTaxYearFlg of}

end;  {ConvertYearBeingProcessedToText}

{===================================================================}
Function ConvertYearBeingProcessedToText(TaxYearFlag : Char) : String; overload;

{This function looks at the global var. GlblTaxYearFlg and
 returns a text description (i.e. 'This Year').}

begin
  case TaxYearFlag of
    'T' : Result := 'This Year';
    'N' : Result := 'Next Year';
    'H' : Result := 'History';

  end;  {case TaxYearFlag of}

end;  {ConvertYearBeingProcessedToText}

{===================================================================}
Function GetSwisFromSwisSBLKey (SwisSBLKey : String) : String;
{retrieves swiss code from SwisSBL key assuming swis code is in 1st 6 bytes}

Var
   I : Integer;
   Temp : String;
Begin
Temp := Take(6,' ');
For I := 1 to 6 do
    Temp[I] := SwisSBLKey[I];  {skip over tax year to swis code}
GetSwisFromSwisSBLKey := Take(6,temp);

end;
{===================================================================}
Function ExtractYSSKey(InputTable : TTable) : String;
{this function provides a 30 char string of taxyr,Swis & SBL assembled from }
{the individual fields in any TTable component whose tx yr,Swis&sbl fields}
{are named as shown below}
{YSS = tax Year,Swiss,Sbl}
Var
  TempYrSwisSBL : String;
Begin
TempYrSwisSBL := Take(30,' ');

With InputTable do
begin
TempYrSwisSBL :=  Take(4,FieldByName('TaxRollYr').Text) +
               Take(6,FieldByName('SwisCode').Text) +
               Take(3,FieldByName('Section').Text) +
               Take(3,FieldByName('Subsection').Text) +
               Take(4,FieldByName('Block').Text) +
               Take(3,FieldByName('Lot').Text) +
               Take(3,FieldByName('Sublot').Text) +
               Take(4,FieldByName('Suffix').Text);
ExtractYSSKey := Take(30,TempYrSwisSBL);
end;
end;

{===================================================================}
Function ExtractSSKey(InputTable : TTable) : String;
{this function provides a 26 char string of Swis SBL assembled from }
{the individual fields in any TTable component whose Swis/sbl fields}
{are named as shown below ...SS = Swis,Sbl}

Var
  TempSwisSBL : String;
Begin
TempSwisSBL := Take(26,' ');

With InputTable do
begin
TempSwisSBL :=
               Take(6,FieldByName('SwisCode').Text) +
               Take(3,FieldByName('Section').Text) +
               Take(3,FieldByName('Subsection').Text) +
               Take(4,FieldByName('Block').Text) +
               Take(3,FieldByName('Lot').Text) +
               Take(3,FieldByName('Sublot').Text) +
               Take(4,FieldByName('Suffix').Text);
ExtractSSKey := Take(26,TempSwisSBL);
end;
end;

{===================================================================}
Function ExtractSBL(InputTable : TTable) : String;
{this function provides a 20 char string of  SBL assembled from }
{the individual fields in any TTable component whose Swis/sbl fields}
{are named as shown below ...}

Var
  TempSBL : String;
Begin
TempSBL := Take(20,' ');

With InputTable do
begin
TempSBL :=
               Take(3,FieldByName('Section').Text) +
               Take(3,FieldByName('Subsection').Text) +
               Take(4,FieldByName('Block').Text) +
               Take(3,FieldByName('Lot').Text) +
               Take(3,FieldByName('Sublot').Text) +
               Take(4,FieldByName('Suffix').Text);
ExtractSBL := Take(20,TempSBL);
end;
end;

{===================================================================}
Function ExtractSwisSBLFromSwisSBLKey(SBLKey : String) : SBLRecord;

{Given an SBL in the SwisSBL (all together), return the individual parts in the
 SBLRecord.}

var
  SBLRec : SBLRecord;

begin
  with SBLRec do
    begin
      SwisCode := Take(6, Copy(SBLKey, 1, 6));
      Section := Take(3, Copy(SBLKey, 7, 3));
      SubSection := Take(3, Copy(SBLKey, 10, 3));
      Block := Take(4, Copy(SBLKey, 13, 4));
      Lot := Take(3, Copy(SBLKey, 17, 3));
      SubLot := Take(3, Copy(SBLKey, 20, 3));
      Suffix := Take(4, Copy(SBLKey, 23, 4));

    end;  {with SBLRec do}

  ExtractSwisSBLFromSwisSBLKey := SBLRec;

end;  {ExtractSwisSBLFromSwisSBLKey}

{===================================================================}
Function ExtractSBLFromSBLKey(SBLKey : String) : SBLRecord;

{Given an SBL  (w. NO Swis, return the individual parts in the
 SBLRecord.}

var
  SBLRec : SBLRecord;

begin
  with SBLRec do
    begin
      SwisCode := Take(6, ' ');
      Section := Take(3, Copy(SBLKey, 1, 3));
      SubSection := Take(3, Copy(SBLKey, 4, 3));
      Block := Take(4, Copy(SBLKey, 7, 4));
      Lot := Take(3, Copy(SBLKey, 11, 3));
      SubLot := Take(3, Copy(SBLKey, 14, 3));
      Suffix := Take(4, Copy(SBLKey, 17, 4));

    end;  {with SBLRec do}

  ExtractSBLFromSBLKey := SBLRec;

end;  {ExtractSBLFromSBLKey}

{==================================================================}
Function GetSwisSBLFromSBLRecord(SBLRec : SBLRecord) : String;

begin
  with SBLRec do
    Result := SwisCode + Section + Subsection +
              Block + Lot + Sublot + Suffix;

end;  {GetSwisSBLFromSBLRecord}

(*
{===================================================================}
Function FieldIsTraceable(    Form : TForm;
                              MainTable : TTable;
                          var TempLabel,
                              TempFieldName : String;
                              Index : Integer) : Boolean;

{FXX11101997-6: Moved this procedure from UGENSCLB since it was better.
                Also, had to add FieldNamesList for compatibility to
                all procedures.}

var
  I, J, K : Integer;
  TempStr : String;
  EditBox : TDBEdit;
  ComboBox : TwwDBLookupCombo;
  CheckBox : TDBCheckBox;
  FieldInGrid, EditBoxReadOnly, CheckBoxLabelFound,
  CheckBoxFound, EditBoxFound, ComboBoxFound : Boolean;
  TempField : TField;

begin
    {FXX11141997-2: Not initializing Result of FieldIsTracable to False.}

  Result := False;

    {CHG10171997-1: Only do labels for fields that are visible and not read
                    only.}
    {Make sure this is a field of the main table.}

  with Form do
    If (Take(Length(MainTable.Name), TField(Components[Index]).Name) = MainTable.Name)
      then
        begin
          TempField := TField(Components[Index]);
          TempStr := TempField.FieldName;
        end
      else TempField := nil;

  with Form do
    If ((Take(Length(MainTable.Name), TField(Components[Index]).Name) = MainTable.Name) and
        TField(Components[Index]).Visible and
        (not (Components[Index] is TMemoField)) and
        (not TField(Components[Index]).ReadOnly))
      then
        begin
            {Now we want to find a label associated with this field.
             This assumes that the field is being edited in an edit box, and
             the FocusControl value of the associated label points to the
             corresponding edit box. If there is no edit box for this field, then
             we will assume that this is a grid that we are working with, and we
             will use the DisplayLabel property of the field.}

          with Components[Index] as TField do
            begin
              TempLabel := DisplayLabel;
              TempFieldName := FieldName;

            end;  {with Components[Index] as TField do}

          EditBoxFound := False;

            {Now look for an edit box which is linked to this field.
             When we find one, we will record the name of the edit box
             in a temp var.}

          For J := 0 to (ComponentCount - 1) do
            If (Components[J] is TDBEdit)
              then
                If (TDBEdit(Components[J]).DataField = TempFieldName)
                  then
                    begin
                      EditBoxFound := True;
                      EditBox := (Components[J] as TDBEdit);

                    end;  {If (TDBEdit(Components[J]).DataField = TempFieldName)}

            {Now, if we found an edit box corresponding to this field,
             then we will look through the labels to find the corresponding
             label.}

          If EditBoxFound
            then
              For J := 0 to (ComponentCount - 1) do
                If (Components[J] is TLabel)
                  then
                    with Components[J] as TLabel do
                      If (FocusControl = EditBox)
                        then TempLabel := Caption;

          ComboBoxFound := False;

            {Now look for an edit box which is linked to this field.
             When we find one, we will record the name of the edit box
             in a temp var.}

          For J := 0 to (ComponentCount - 1) do
            If (Components[J] is TwwDBLookupCombo)
              then
                If (TwwDBLookupCombo(Components[J]).DataField = TempFieldName)
                  then
                    begin
                      ComboBoxFound := True;
                      ComboBox := (Components[J] as TwwDBLookupCombo);

                    end;  {If (TDBEdit(Components[J]).DataField = TempFieldName)}

            {Now, if we found an edit box corresponding to this field,
             then we will look through the labels to find the corresponding
             label.}

          If ComboBoxFound
            then
              For J := 0 to (ComponentCount - 1) do
                If (Components[J] is TLabel)
                  then
                    with Components[J] as TLabel do
                      If (FocusControl = ComboBox)
                        then TempLabel := Caption;

            {See if it is in a grid. Note that the table has to be open
             for this to work.}

          FieldInGrid := False;

            {FXX10041999-8: Also check for check boxes.}

          CheckBoxFound := False;

          If not (EditBoxFound or ComboBoxFound)
            then
              For I := 0 to (ComponentCount - 1) do
                If ((Components[I] is TDBCheckBox) and
                    (TDBCheckBox(Components[I]).DataField = TempFieldName))
                  then
                    begin
                      CheckBoxFound := True;
                      CheckBox := Components[I] as TDBCheckBox;
                    end;

          CheckBoxLabelFound := False;

          If CheckBoxFound
            then
              For J := 0 to (ComponentCount - 1) do
                If (Components[J] is TLabel)
                  then
                    with Components[J] as TLabel do
                      If (FocusControl = CheckBox)
                        then
                          begin
                            CheckBoxLabelFound := True;
                            TempLabel := Caption;
                          end;

          If (CheckBoxFound and
              (not CheckBoxLabelFound))
            then TempLabel := CheckBox.Caption;

            {FXX03161998-2: If the field is in the grid, use the grid label
                            name, not the field name.}

          If not (EditBoxFound or ComboBoxFound or CheckBoxFound)
            then
              For J := 0 to (ComponentCount - 1) do
                If (Components[J] is TwwDBGrid)
                  then
                    with (Components[J] as TwwDBGrid) do
                      For K := 0 to (Selected.Count - 1) do
                        If (Pos(TempFieldName, Selected[K]) > 0)
                          then FieldInGrid := True;

            {Only store this field for tracing if it is in an editable
             edit box or in a grid.}

          If (EditBoxFound or
              ComboBoxFound or
              CheckBoxFound or
              FieldInGrid)
            then Result := True
            else Result := False;

            {FXX03021998-4: Strip any colons or tildes off of the label.}

          TempLabel := StripColon(TempLabel);
          TempLabel := StripChar(TempLabel, '~', ' ', True);

        end;  {If ((Components[Index] is TField) and ...}

end;  {FieldIsTraceable}

{===================================================================}
Procedure CreateFieldValuesAndLabels(Form : TForm;
                                     MainTable : TTable;
                                     FieldValuesList,
                                     FieldLabelsList,
                                     FieldNamesList : TStringList);

{Get all the field labels on the screen and the corresponding field names.}

var
  I : Integer;
  TempStr, TempLabel, TempFieldName : String;

begin
    {FXX04151998-6: Not clearing the values and labels list so problems on
                    reedit case.}

  FieldNamesList.Clear;
  FieldValuesList.Clear;
  FieldLabelsList.Clear;

  with Form do
    For I := 0 to (ComponentCount - 1) do
      If ((Components[I] is TField) and
          FieldIsTraceable(Form, MainTable, TempLabel, TempFieldName, I))
        then
          begin
            TempStr := StripColon(TempLabel);
            TempStr := StripChar(TempStr, '~', ' ', True);

            FieldLabelsList.Add(TempStr);
            FieldNamesList.Add(TempFieldName);

              {First add the value to the list.}

            with Components[I] as TField do
              FieldValuesList.Add(Text);

          end;  {If FieldIsTraceable(Form ...}

end;  {CreateFieldValuesList} *)

{===================================================================}
Function GetScreenLabelForDataField(Form : TForm;
                                    _Field : TField) : String;

var
  I, J, K : Integer;
  TempFieldName : String;
  EditBox : TDBEdit;
  ComboBox : TwwDBLookupCombo;
  CheckBox : TDBCheckBox;
  FieldInGrid, CheckBoxLabelFound,
  CheckBoxFound, EditBoxFound, ComboBoxFound : Boolean;

begin
  Result := '';
  TempFieldName := _Field.FieldName;
  CheckBox := nil;
  EditBox := nil;
  ComboBox := nil;

  with Form do
    begin
        {Now we want to find a label associated with this field.
         This assumes that the field is being edited in an edit box, and
         the FocusControl value of the associated label points to the
         corresponding edit box. If there is no edit box for this field, then
         we will assume that this is a grid that we are working with, and we
         will use the DisplayLabel property of the field.}

      Result := _Field.DisplayLabel;

      EditBoxFound := False;

        {Now look for an edit box which is linked to this field.
         When we find one, we will record the name of the edit box
         in a temp var.}

      For J := 0 to (ComponentCount - 1) do
        If (Components[J] is TDBEdit)
          then
            If (TDBEdit(Components[J]).DataField = TempFieldName)
              then
                begin
                  EditBoxFound := True;
                  EditBox := (Components[J] as TDBEdit);

                end;  {If (TDBEdit(Components[J]).DataField = TempFieldName)}

        {Now, if we found an edit box corresponding to this field,
         then we will look through the labels to find the corresponding
         label.}

      If EditBoxFound
        then
          For J := 0 to (ComponentCount - 1) do
            If (Components[J] is TLabel)
              then
                with Components[J] as TLabel do
                  If (FocusControl = EditBox)
                    then Result := Caption;

      ComboBoxFound := False;

        {Now look for an edit box which is linked to this field.
         When we find one, we will record the name of the edit box
         in a temp var.}

      For J := 0 to (ComponentCount - 1) do
        If (Components[J] is TwwDBLookupCombo)
          then
            If (TwwDBLookupCombo(Components[J]).DataField = TempFieldName)
              then
                begin
                  ComboBoxFound := True;
                  ComboBox := (Components[J] as TwwDBLookupCombo);

                end;  {If (TDBEdit(Components[J]).DataField = TempFieldName)}

        {Now, if we found an edit box corresponding to this field,
         then we will look through the labels to find the corresponding
         label.}

      If ComboBoxFound
        then
          For J := 0 to (ComponentCount - 1) do
            If (Components[J] is TLabel)
              then
                with Components[J] as TLabel do
                  If (FocusControl = ComboBox)
                    then Result := Caption;

        {See if it is in a grid. Note that the table has to be open
         for this to work.}

      FieldInGrid := False;

        {FXX10041999-8: Also check for check boxes.}

      CheckBoxFound := False;

      If not (EditBoxFound or ComboBoxFound)
        then
          For I := 0 to (ComponentCount - 1) do
            If ((Components[I] is TDBCheckBox) and
                (TDBCheckBox(Components[I]).DataField = TempFieldName))
              then
                begin
                  CheckBoxFound := True;
                  CheckBox := Components[I] as TDBCheckBox;
                end;

      CheckBoxLabelFound := False;

      If CheckBoxFound
        then
          For J := 0 to (ComponentCount - 1) do
            If (Components[J] is TLabel)
              then
                with Components[J] as TLabel do
                  If (FocusControl = CheckBox)
                    then
                      begin
                        CheckBoxLabelFound := True;
                        Result := Caption;
                      end;

      If (CheckBoxFound and
          (not CheckBoxLabelFound))
        then Result := CheckBox.Caption;

        {FXX03161998-2: If the field is in the grid, use the grid label
                        name, not the field name.}

      If not (EditBoxFound or ComboBoxFound or CheckBoxFound)
        then
          For J := 0 to (ComponentCount - 1) do
            If (Components[J] is TwwDBGrid)
              then
                with (Components[J] as TwwDBGrid) do
                  For K := 0 to (Selected.Count - 1) do
                    If (Pos(TempFieldName, Selected[K]) > 0)
                      then FieldInGrid := True;

        {Only store this field for tracing if it is in an editable
         edit box or in a grid.}

      If (EditBoxFound or
          ComboBoxFound or
          CheckBoxFound or
          FieldInGrid)
        then
          begin
            Result := StripColon(Result);
            Result := StripChar(Result, '~', ' ', True);
          end
        else Result := '';

    end;  {If ((Components[Index] is TField) and ...}

end;  {GetScreenLabelForDataField}

{===================================================================}
Function FieldIsTraceable(Field : TField) : Boolean;

begin
  Result := ((not Field.ReadOnly) and
             Field.Visible and
             (Field.DataType <> ftMemo));

end;  {FieldIsTraceable}

{===================================================================}
Procedure CreateFieldValuesAndLabels(Form : TForm;
                                     MainTable : TTable;
                                     FieldTraceInformationList : TList);

{Get all the field labels on the screen and the corresponding field names.}
{CHG12162004-1(2.8.1.3)[2025]: Rewrite this procedure so that it does not
                               depend on the presence of TFields.}

var
  I : Integer;
  TempLabel : String;
  FieldTraceInformationPtr : FieldTraceInformationPointer;

begin
  If (FieldTraceInformationList = nil)
    then FieldTraceInformationList := TList.Create;

  ClearTList(FieldTraceInformationList, SizeOf(FieldTraceInformationRecord));

  with MainTable do
    For I := 0 to (FieldCount - 1) do
      If FieldIsTraceable(Fields[I])
        then
          begin
            TempLabel := GetScreenLabelForDataField(Form, Fields[I]);

(*            If _Compare(TempLabel, coNotBlank)
              then
                begin *)
                  New(FieldTraceInformationPtr);

                  with FieldTraceInformationPtr^ do
                    begin
                      FieldName := Fields[I].FieldName;
                      FieldValue := Fields[I].Text;

                      If _Compare(TempLabel, coNotBlank)
                        then FieldLabel := TempLabel
                        else FieldLabel := FieldName;

                    end;  {with FieldTraceInformationPtr^ do}

                  FieldTraceInformationList.Add(FieldTraceInformationPtr);

(*                end;  {If (Trim(TempLabel) <> '')} *)

          end;  {If FieldIsTraceable(Form ...}

end;  {CreateFieldValuesList}

{===================================================================}
Procedure AddToTraceFile(SwisSBLKey,
                         FScreenName,  {Form caption}
                         FLabelName,
                         FOldValue,
                         FNewValue : String;
                         PresentTime : TDateTime;
                         MainTable : TTable);

{FXX11101997-2: Only store fields listed in the screen label file,
                since these are all we care about. Also, we no longer
                need to worry about storing field name and table name
                since these are in the screen label file.}

var
  TempStr : String;

begin
  try
    GlblTraceTable.Insert;
  except
    SystemSupport(902, GlblTraceTable, 'Error putting trace table in insert mode.',
                  'PASUTILS.PAS', GlblErrorDlgBox);
  end;

  with GlblTraceTable do
    begin
        {Note that some traceable tables such as sales do not have a tax roll
         year so first we have to verify that the TaxRollYr field exists
         before trying to say it.}

        {FXX11101997-5: Get the tax roll year from the record instead of
                        the global tax year since this could be the
                        result of dual mode processing.}
        {FXX12221998-2: Make sure fill in the current processing year if none
                        available.}

      If (MainTable.FindField('TaxRollYr') <> nil)
        then FieldByName('TaxRollYr').Text := MainTable.FieldByName('TaxRollYr').Text
        else FieldByName('TaxRollYr').Text := GetTaxRollYearForProcessingType(GlblProcessingType);

      FieldByName('SwisSBLKey').Text := SwisSBLKey;
      FieldByName('User').Text := GlblUserName;

      try
        FieldByName('UserEnteredBy').Text := GlblUserName;
      except
      end;

      FieldByName('LabelName').Text := FLabelName;
      FieldByName('ScreenName').Text := FScreenName;
      FieldByName('OldValue').Text := FOldValue;
      FieldByName('NewValue').Text := FNewValue;
      FieldByName('Date').AsDateTime := Date;

      try
        FieldByName('DateEntered').AsDateTime := Date;
      except
      end;

      FieldByName('Time').AsDateTime := PresentTime;

      try
        FieldByName('TimeEntered').AsDateTime := PresentTime;
      except
      end;

      TempStr := FormatDateTime(TimeFormat, FieldByName('Time').AsDateTime);

    end;  {with GlblTraceTable do}

  try
    GlblTraceTable.Post;
  except
    GlblTraceTable.Cancel;
    (*SystemSupport(903, GlblTraceTable, 'Error putting trace table in insert mode.',
                  'PASUTILS.PAS', GlblErrorDlgBox); *)
  end;

end;  {AddToTraceFile}

(*
{===================================================================}
Function RecordChanges(Form : TForm;
                       ScreenName : String;  {Pass in the screen name since may not be form name.}
                       MainTable : TTable;
                       SwisSBL : String;
                       FieldValuesList,
                       FieldLabelsList : TStringList) : Integer;

{This function records all changes to a given record in a trace table
 and returns the number of changes.}

var
  Index, I : Integer;
  StateChar : Char;
  Found, AddTrace : Boolean;
  TempValue, TempFieldName, LabelName : String;
  PresentTime : TDateTime;

begin
  Index := 0;
  Result := 0;

  case MainTable.State of
    dsInsert : StateChar := 'I';
    dsEdit   : StateChar := 'E';
  end;

    {FXX12221998-4: To make sure that all changes get marked with the same time,
                    set the time here and pass in.}

  PresentTime := Now;

  If (FieldValuesList.Count > 0)
    then
      with Form do
        For I := 1 to (ComponentCount - 1) do
          begin
              {Note that we only want to check the fields of the main table.}
            If ((Components[I] is TField) and
                FieldIsTraceable(Form, MainTable, LabelName,
                                 TempFieldName, I))
              then
                begin
                  AddTrace := False;

                    {FXX11101997-2: Only store fields listed in the
                                    screen label file, since these
                                    are all we care about.}

                  Found := FindKeyOld(GlblScreenLabelTable,
                                      ['ScreenName', 'LabelName'],
                                      [Take(30, ScreenName),
                                       Take(30, LabelName)]);

                  If Found
                    then
                      begin
                        AddTrace := True;

                          {FXX03021998-3: Don't make the index into the field
                                          labels list dependant on the order
                                          of the field components on the form
                                          by just starting Index at 0 and
                                          incrementing.}

                        Index := FieldLabelsList.IndexOf(Trim(LabelName));

                          {Has there been a change?}

                        If (FieldValuesList.Strings[Index] = TField(Components[I]).Text)
                          then AddTrace := False;

                        TempValue := FieldValuesList[Index];

                          {CHG11141997-1: Don't store LastChange or By
                                          fields since they can select
                                          range of change date or user
                                          seperately.}
                          {FXX01201998-12: Need to do takes on 'Last Change' and 'By'.}

                        If ((Take(30, LabelName) = Take(30, 'Last Change')) or
                            (Take(30, LabelName) = 'By'))
                          then AddTrace := False;

                           {CHG11141997-2: Compare fields by their data
                                           type to see if they really changed,
                                           i.e. 0.00 and 0 should be
                                           no change.}

                      end;  {If Found}

                  If AddTrace
                    then
                      begin
                        Result := Result + 1;

                        AddToTraceFile(SwisSBL, StateChar,
                                       ScreenName,
                                       Take(30, LabelName),
                                       TempValue,
                                       TField(Components[I]).Text,
                                       PresentTime,
                                       MainTable);

                      end;  {If AddTrace}

                end;  {If (Components[I] is TField)}

          end;  {For I := 1 to (FieldValuesList.Count - 1) do}

end;  {RecordChanges}

{===================================================================}
Function NumRecordChanges(Form : TForm;
                          MainTable : TTable;
                          FieldValuesList,
                          FieldLabelsList : TStringList) : Integer;

{This function records all changes to a given record in a trace table
 and returns the number of changes.}

var
  Index, I : Integer;
  TempLabel, TempFieldName : String;

begin
  Index := 0;
  Result := 0;

  If (FieldValuesList.Count > 0)
    then
      with Form do
        For I := 1 to (ComponentCount - 1) do
          begin
              {Note that we only want to check the fields of the main table.}
              {FXX11171997-2: Only check tracable fields in this proc, too.}

            If ((Components[I] is TField) and
                FieldIsTraceable(Form, MainTable, TempLabel, TempFieldName, I))
              then
                begin
                  If (FieldValuesList.Strings[Index] <> TField(Components[I]).Text)
                    then Result := Result + 1;

                  Index := Index + 1;

                end;  {If ((Components[I] is TField) and ...}

          end;  {For I := 1 to (FieldValuesList.Count - 1) do}

end;  {NumRecordChanges} *)

{===================================================================}
Function RecordChanges(Form : TForm;
                       ScreenName : String;  {Pass in the screen name since may not be form name.}
                       MainTable : TTable;
                       SwisSBLKey : String;
                       FieldTraceInformationList : TList) : Integer;

{This function records all changes to a given record in a trace table
 and returns the number of changes.}
{CHG12162004-1(2.8.1.3)[2025]: Rewrite this procedure so that it does not
                               depend on the presence of TFields.}

var
  I : Integer;
  PresentTime : TDateTime;
  ChangeFromBlankToZero : Boolean;

begin
  Result := 0;
  PresentTime := Now;

  For I := 0 to (FieldTraceInformationList.Count - 1) do
    with FieldTraceInformationPointer(FieldTraceInformationList[I])^ do
      try
        If (_Compare(FieldValue, MainTable.FieldByName(FieldName).Text, coNotEqual)) and
(*            (_Locate(GlblScreenLabelTable, [ScreenName, FieldLabel], '', []) and *)
            (not _Compare(FieldLabel, 'Last Change', coEqual)) and
            (not _Compare(FieldLabel, 'By', coEqual))
          then
            begin
              ChangeFromBlankToZero := False;

              If _Compare(FieldValue, coNotBlank)
                then ChangeFromBlankToZero := _Compare(MainTable.FieldByName(FieldName).Text, '0', coEqual);

              If not ChangeFromBlankToZero
                then
                  begin
                    Result := Result + 1;

                    AddToTraceFile(SwisSBLKey,
                                   ScreenName,
                                   FieldLabel,
                                   FieldValue,
                                   MainTable.FieldByName(FieldName).Text,
                                   PresentTime,
                                   MainTable);

                  end;  {If not ChangeFromBlankToZero}

            end;  {If (_Compare(FieldValue ...}
      except
      end;

end;  {RecordChanges}

{===================================================================}
Function NumRecordChanges(Form : TForm;
                          MainTable : TTable;
                          FieldTraceInformationList : TList) : Integer;

{This function records all changes to a given record in a trace table
 and returns the number of changes.}
{CHG12162004-1(2.8.1.3)[2025]: Rewrite this procedure so that it does not
                               depend on the presence of TFields.}

var
  I : Integer;

begin
  Result := 0;

  For I := 0 to (FieldTraceInformationList.Count - 1) do
    with FieldTraceInformationPointer(FieldTraceInformationList[I])^ do
      If _Compare(FieldValue, MainTable.FieldByName(FieldName).Text, coNotEqual)
        then Result := Result + 1;

end;  {NumRecordChanges}


{=============================================================}
Function GetMunicipalityType(MunicipalityType : Integer) : Integer;

{Given a municipality type, figure out which exemption or roll total
 type to use.}
{FXX02042004-4(2.07l): Treat municipality type NONE as town.}

begin
  If ((GlblMunicipalityType = MTCity) or
      (GlblMunicipalityType = MTNone))
    then Result := MTTown
    else Result := GlblMunicipalityType;

end;  {GetMunicipalityType}

{=============================================================}
Function GetMunicipalityTypeName(MunicipalityType : Integer) : String;

{Given a municipality type, figure out which exemption or roll total
 type to use.}

begin
  case GlblMunicipalityType of
    MTCity : Result := 'City';
    MTTown : Result := 'Town';
    MTSchool : Result := 'School';
    MTCounty : Result := 'County';
    MTVillage : Result := 'Village';

  end;  {case GlblMunicipalityType of}

end;  {GetMunicipalityTypeName}

{=============================================================}
Function GetShortMunicipalityTypeName(MunicipalityType : Integer) : String;

{Given a municipality type, figure out which exemption or roll total
 type to use.}

begin
  case GlblMunicipalityType of
    MTCity : Result := 'City';
    MTTown : Result := 'Town';
    MTSchool : Result := 'Schl';
    MTCounty : Result := 'Cnty';
    MTVillage : Result := 'Vill';

  end;  {case GlblMunicipalityType of}

end;  {GetShortMunicipalityTypeName}

{=============================================================}
Function DetermineTableNameForTaxYear(TableName : String) : String;

{Return the table name after adjusting the table name for the present processing
 type ('N', 'T', 'H'). Note that we return the new table
 name only - do not actually change the name of the table!}

begin
  Result := GlblTaxYearFlg +
            Copy(TableName, 2, (Length(TableName) - 1));  {Copy to end of string}

end;  {DetermineTableNameForTaxYear}

{=============================================================}
Procedure SetTableNameForTaxYear(Table : TTable);

{Change the first letter of the table name to 'T' for ThisYear,
 'N' for NextYear, and 'H' for History processing.}

begin
  Table.TableName := GlblTaxYearFlg +
                     Copy(Table.TableName, 2, (Length(Table.TableName) - 1));  {Copy to end of string}

end;  {SetTableNameForTaxYear}

{===============================================================}
Procedure SetTableNameForProcessingType(Table : TTable;
                                        ProcessingType : Integer);  {History, This Year,
                                                                     Next Year, SalesInv}
{Based on the processing type (History, ThisYear, NextYear, or SalesInventory), change
 the first letter of the table name to 'H', 'T', 'N', or 'S', respectively.}

var
  TempTableName : String;

begin
  with Table do
    begin
      TempTableName := TableName;

        {Note that the first letter is changed only if this is a year dependent file -
         i.e. one that starts with a 'T'.}
          {dfxx09141997}
      If (UpcaseSTr(TempTableName[1]) = 'T')
        then
          case ProcessingType of
            History : TempTableName[1] := 'H';
            NextYear : TempTableName[1] := 'N';
            ThisYear : TempTableName[1] := 'T';
            SalesInventory : TempTableName[1] := 'S';

          end;  {case ProcessingType of}

      TableName := TempTableName;

    end;  {with Table do}

end;  {SetTableNameForProcessingType}

{===============================================================}
Function DetermineTableNameForProcessingType(TableName : String;
                                             ProcessingType : Integer) : String;  {History, This Year,
                                                                                   Next Year, SalesInv}
{Based on the processing type (History, ThisYear, NextYear, or SalesInventory), change
 the first letter of the table name to 'H', 'T', 'N', or 'S', respectively.}

begin
  Result := TableName;

    {FXX12022001-2: If this is a non-year dependent table (i.e. it starts with a 'P'),
                    leave it alone.}

  If (TableName[1] <> 'P')
    then
      case ProcessingType of
        History : Result[1] := 'H';
        NextYear : Result[1] := 'N';
        ThisYear : Result[1] := 'T';
        SalesInventory : Result[1] := 'S';

      end;  {case ProcessingType of}

end;  {DetermineTableNameForProcessingType}

{===============================================================}
Function ExpandPASPath(Directory : String) : String;

{Given a PAS directory, append a drive letter.}

begin
    {FXX02212001-3: Don't put the drive letter on the front if it
                    is already there.}

  If (Pos(':\', Directory) = 2)
    then Result := Directory
    else
      If (Directory[1] = '\')
        then Result := GlblDrive + ':' + Directory
        else Result := GlblDrive + ':\' + Directory;

end;  {ExpandPASPath}

{===============================================================}
Function MakeLegalAddress(LegalAddressNumber : String;
                          LegalAddressName : String) : String;

var
  TempStr : String;

begin
  TempStr := Trim(LegalAddressNumber) + ' ' +
             Trim(LegalAddressName);

  Result := LTrim(TempStr);

end;  {MakeLegalAddress}

{===============================================================}
Function GetLegalAddressFromTable(Table : TTable) : String;

{Return a string that is the whole legal address (i.e. number + street),
 since the legal address is in two parts.}
{FXX07131998-3: Avoid return with space in front if no legal addr no.}

begin
  with Table do
    Result := MakeLegalAddress(FieldByName('LegalAddrNo').Text,
                               FieldByName('LegalAddr').Text);

end;  {GetLegalAddressFromTable}

{===============================================================}

Function GetLegalAddressFromADOQuery(AQuery : TADOQuery) : String;

{Return a string that is the whole legal address (i.e. number + street),
 since the legal address is in two parts.}
{FXX07131998-3: Avoid return with space in front if no legal addr no.}

begin
  with AQuery do
    Result := MakeLegalAddress(FieldByName('LegalAddrNo').Text,
                               FieldByName('LegalAddr').Text);

end;  {GetLegalAddressFromADOQuery}

{===============================================================}
Function LegalAddressesDifferent(LegalAddressName1 : String;
                                 LegalAddressNumber1 : String;
                                 LegalAddressName2 : String;
                                 LegalAddressNumber2 : String) : Boolean;

begin
   Result := ((Trim(ANSIUpperCase(LegalAddressName1)) <> Trim(ANSIUpperCase(LegalAddressName2))) or
              (Trim(ANSIUpperCase(LegalAddressNumber1)) <> Trim(ANSIUpperCase(LegalAddressNumber2))));

end;  {LegalAddressesDifferent}

{===============================================================}
Function GetTaxYrLbl : String;

{Create the text for the tax year label.}

begin
  Result := GetTaxRlYr +
            ' (' + ConvertYearBeingProcessedToText + ')';

end;  {GetTaxYrLbl}

{=========================================================================}
Procedure SetTaxYearLabelForProcessingType(TaxLabel : TLabel;
                                           ProcessingType : Integer);  {History, This Year,
                                                                        Next Year, SalesInv}
{Based on the processing type (History, ThisYear, NextYear, or SalesInventory), change
 the label's color and text.}
{FXX12011998-9: Change the background color too.}

 begin
     {FXX02091999-1: Show that they are in dual processing mode.}

(*   If GlblModifyBothYears
     then
       case ProcessingType of
         ThisYear,
         NextYear : begin
                      TaxLabel.Font.Color := DualProcessingFontColor;
                      TaxLabel.Color := ThisYearTabColor;
                      TaxLabel.Caption := GlblThisYear + '\' + GlblNextYear;
                    end;  {ThisYear}

         History : begin
                      TaxLabel.Font.Color := HistoryFontColor;
                      TaxLabel.Color := HistoryTabColor;
                      TaxLabel.Caption := GlblHistYear + ' (History)';
                    end;  {ThisYear}

         SalesInventory :
                    begin
                      TaxLabel.Font.Color := SalesInventoryFontColor;
                      TaxLabel.Color := SalesInventoryTabColor;
                      TaxLabel.Caption := GlblThisYear + ' (Sales)';
                    end;  {SalesInventory}

       end  {case ProcessingType of}
     else *)
       case ProcessingType of
         ThisYear : begin
                      TaxLabel.Font.Color := ThisYearFontColor;
                      TaxLabel.Color := ThisYearTabColor;
                      TaxLabel.Caption := GlblThisYear + ' (This Year)';
                    end;  {ThisYear}

         NextYear : begin
                      TaxLabel.Font.Color := NextYearFontColor;
                      TaxLabel.Color := NextYearTabColor;
                      TaxLabel.Caption := GlblNextYear + ' (Next Year)';
                    end;  {NextYear}

         History : begin
                      TaxLabel.Font.Color := HistoryFontColor;
                      TaxLabel.Color := HistoryTabColor;
                      TaxLabel.Caption := GlblHistYear + ' (History)';
                    end;  {ThisYear}

         SalesInventory :
                    begin
                      TaxLabel.Font.Color := SalesInventoryFontColor;
                      TaxLabel.Color := SalesInventoryTabColor;
                      TaxLabel.Caption := GlblThisYear + ' (Sales)';
                    end;  {SalesInventory}

       end;  {case ProcessingType of}

   TaxLabel.Font.Style := [fsBold];

 end;  {SetTaxYearLabelForProcessingType}

{=========================================================================}
Function ExecuteParcelLocateDialog(var SBLKey : String;
                                       ShowCancelButton,
                                       ShowExitButton : Boolean;
                                       TitleString : String;
                                       _AllowMultiSelect : Boolean;
                                       _SwisSBLKeyList : TStringList) : Boolean;

{Shows the parcel locate form. If they hit OK, the result of
 this function is True and the SBLKey is filled in with the
 SBL that they chose. Otherwise, it returns False.}

begin
  SBLKey := '';

  try
      {CHG11231997-1: Return to parcel locate for parcel modify and view,
                      so need to be able to control which buttons are visible.}

    LocateParcelForm.CancelButton.Visible := ShowCancelButton;
    LocateParcelForm.ExitButton.Visible := ShowExitButton;
    LocateParcelForm.AllowMultiSelect := _AllowMultiSelect;
    LocateParcelForm.SwisSBLKeyList := _SwisSBLKeyList;

      {FXX12011998-20: Display the present action in the locate dialog.}

(*    LocateParcelForm.TitleLabel.Caption := TitleString;*)

    Result := (LocateParcelForm.ShowModal = idOK);

    If Result
      then SBLKey := GlblLastLocateInfoRec.LastSwisSBLKey;
  finally
    CloseTablesForForm(LocateParcelForm);
    LocateParcelForm.ParcelTable.Close;
  end;

end;  {ExecuteParcelLocateDialog}

{============================================================}
Function FormatSegment(    SegmentName : String;
                       var Segment : String;
                           MaxLen : Integer;
                           SegmentFormat : TSBLSegmentFormatType;
                           ReportErrors : Boolean) : Boolean;
{Format one segment of an SBL based on the SegmentFormat flags.
 The return value is True if the segment is valid, False if it
 is not.}

var
  ShiftIt, ValidEntry : Boolean;

begin
  ValidEntry := True;

    {CHG03072003-1: Some municipalities only SRAZ in non-zero filled fields.}
    {CHG01052004-1(2.07l): Allow zero-filled numbers and non-zero-filled alphas for a segment.}

  If (fmShiftRightAddZeroes in SegmentFormat)
    then
      begin
        ShiftIt := (((fmAlphaNumeric in SegmentFormat) and
                     StringIsNumeric(Segment)) or
                    (not (fmAlphaNumeric in SegmentFormat)));

        If (ShiftIt and
            ((Deblank(Segment) <> '') or
             (not GlblDontZeroFillBlankSegments)))
          then Segment := ShiftRightAddZeroes(Take(MaxLen, Segment))
          else
            If StringIsNumeric(Segment)
              then Segment := '';

      end;  {If (fmShiftRightAddZeroes in SegmentFormat)}

    {FXX03172003-2(2.06q1): If the segment is longer than the MaxLen, don't trim it.}

  If (Length(Trim(Segment)) > MaxLen)
    then MaxLen := Length(Trim(Segment));

  If (fmLeftJustify in SegmentFormat)
    then Segment := Take(MaxLen, Trim(Segment));

  If (fmRightJustify in SegmentFormat)
    then Segment := ShiftRightAddBlanks(Take(MaxLen, Segment));

  If ((fmAlpha in SegmentFormat) and
      (not StringIsAlphabetic(Segment)))
    then
      begin
        If ReportErrors
          then MessageDlg('The ' + SegmentName + ' must be alphabetic only.' + #13 +
                         'Please re-enter.', mtError, [mbOK], 0);
        ValidEntry := False;

      end;  {If ((fmAlpha in SegmentFormat) and ...}

  If ((fmAlpha in SegmentFormat) and
      (not StringIsNumeric(Segment)))
    then
      begin
        If ReportErrors
          then MessageDlg('The ' + SegmentName + ' must be numeric only.' + #13 +
                          'Please re-enter.', mtError, [mbOK], 0);
        ValidEntry := False;

      end;  {If ((fmAlpha in SegmentFormat) and ...}

  Result := ValidEntry;

end;  {FormatSegment}

{============================================================}
Function ConvertSBLToDashDot(SBLRec : SBLRecord) : String;

{FXX03182003-2(2.06q1): Other part of not trimming segments that are longer than the forced digits.}

var
  I, TempLen : Integer;
  DashDotSBL, TempStr : String;
  AlphaNumFound : Boolean;

begin
  DashDotSBL := '';

  with SBLRec do
    begin
        {FXX11021999-12: Allow the # of forced digits in each segment to be specified.}

      If ((Section = '000') and
          (not (GlblSectionDigits in [1, 2])))
        then TempStr := ''
        else
          If (fmShiftRightAddZeroes in GlblSectionFormat)
            then
              begin
                If ((GlblSectionDigits in [1, 2]) and
                    (Length(Trim(DezeroOnLeft(Section))) <= 2))
                  then TempStr := Copy(Section, (4 - GlblSectionDigits), GlblSectionDigits)
                  else TempStr := Deblank(DezeroOnLeft(Section))
              end
            else TempStr := Deblank(Section);

      DashDotSBL := DashDotSBL + TempStr + Deblank(GlblSectionSeparator);

      If (Subsection = '000')
        then TempStr := ''
        else
          If (fmShiftRightAddZeroes in GlblSubsectionFormat)
            then
              begin
                If ((GlblSubsectionDigits in [1, 2]) and
                    (Length(Trim(DezeroOnLeft(Subsection))) <= 2))
                  then TempStr := Copy(Subsection, (4 - GlblSubsectionDigits), GlblSubsectionDigits)
                  else TempStr := Deblank(DezeroOnLeft(Subsection))
              end
            else TempStr := Deblank(Subsection);

      DashDotSBL := DashDotSBL + TempStr + Deblank(GlblSubsectionSeparator);

      If (Block = '0000')
        then TempStr := ''
        else
          If (fmShiftRightAddZeroes in GlblBlockFormat)
            then
              begin
                  {FXX04222003-1(2.07): Need to make sure that a block of '00B' which is
                                        forced to 3 digits does not show up as '0B'.}

                TempLen := Length(Trim(Block));

                If ((GlblBlockDigits in [1, 2, 3]) and
                    (Length(Trim(DezeroOnLeft(Block))) <= 3))
                  then TempStr := Copy(Block, ((TempLen + 1) - GlblBlockDigits), GlblBlockDigits)
                  else TempStr := Deblank(DezeroOnLeft(Block))
              end
            else TempStr := Deblank(Block);

      DashDotSBL := DashDotSBL + TempStr + Deblank(GlblBlockSeparator);

      If (Lot = '0000')
        then TempStr := ''
        else
          If (fmShiftRightAddZeroes in GlblLotFormat)
            then
              begin
                If ((GlblLotDigits in [1, 2]) and
                    (Length(Trim(DezeroOnLeft(Lot))) <= 2))
                  then TempStr := Copy(Lot, (4 - GlblLotDigits), GlblLotDigits)
                  else TempStr := Deblank(DezeroOnLeft(Lot))
              end
            else TempStr := Deblank(Lot);

      DashDotSBL := DashDotSBL + TempStr + Deblank(GlblLotSeparator);

      If (Sublot = '000')
        then TempStr := ''
        else
          If (fmShiftRightAddZeroes in GlblSublotFormat)
            then
              begin
                If ((GlblSublotDigits in [1, 2]) and
                    (Length(Trim(DezeroOnLeft(Sublot))) <= 2))
                  then TempStr := Copy(Sublot, (4 - GlblSublotDigits), GlblSublotDigits)
                  else TempStr := Deblank(DezeroOnLeft(Sublot))
              end
            else TempStr := Deblank(Sublot);

      DashDotSBL := DashDotSBL + TempStr + Deblank(GlblSublotSeparator);

      If (Suffix = '0000')
        then TempStr := ''
        else
          If (fmShiftRightAddZeroes in GlblSuffixFormat)
            then
              begin
                If ((GlblSuffixDigits in [1, 2, 3]) and
                    (Length(Trim(DezeroOnLeft(Suffix))) <= 3))
                  then TempStr := Copy(Suffix, (5 - GlblSuffixDigits), GlblSuffixDigits)
                  else TempStr := Deblank(DezeroOnLeft(Suffix))
              end
            else TempStr := Deblank(Suffix);

      DashDotSBL := DashDotSBL + TempStr;

      AlphaNumFound := False;
      I := Length(DashDotSBL);

      while ((I > 0) and
             (not AlphaNumFound)) do
        If ((DashDotSBL[I] in Letters) or
            (DashDotSBL[I] in Numbers))
          then AlphaNumFound := True
          else I := I - 1;

      If AlphaNumFound
        then Delete(DashDotSBL, (I + 1), 26)
        else DashDotSBL := '';

    end;  {with SBLRec do}

  Result := DashDotSBL;

end;  {ConvertSBLToDashDot}

{============================================================}
Function ConvertSwisSBLToDashDot(SwisSBLKey : String) : String;
{Given a 26 char SwisSBL, convert it to dash dot format.}
{FXX11101997-1: If a seperator is blank, don't need it.}

var
  SBLRec : SBLRecord;
  DashDotSBL, sCurrentIndex : String;
  SwisCodeTable, tbParcel : TTable;

begin
  Result := '';

    {CHG01022013 - Option to use the exact print key.}

  If glblUseExactPrintKey
  then
  begin
    tbParcel := FindTableInDataModuleForProcessingType(DataModuleParcelTableName, NextYear);
    sCurrentIndex := tbParcel.IndexName;
    tbParcel.IndexName := 'BYTAXROLLYR_SWISSBLKEY';

    If _Locate(tbParcel, [glblNextYear, SwisSBLKey], '', [loParseSwisSBLKey])
    then Result := tbParcel.FieldByName('PrintKey').AsString;

    tbParcel.IndexName := sCurrentIndex;

  end;  {If glblUseExactPrintKey}

  If _Compare(Result, coBlank)
  then
  begin
    SBLRec := ExtractSwisSBLFromSwisSBLKey(SwisSBLKey);

      {For now we will just take the last two digits of the
       swis code for a short swis since for the 3 original
       municipalities this is the case. Later, this will be fixed.}
      {CHG11022004-1(2.8.0.16)[1966]: Don't show '00/' if there is only 1 swis code.}

    SwisCodeTable := FindTableInDataModuleForProcessingType(DataModuleSwisCodeTableName,
                                                            NextYear);

      {CHG11082009-1(2.20.1.24): Allow option to supress leading swis.}

    If ((SwisCodeTable.Active and
         (SwisCodeTable.RecordCount = 1)) or
        (not GlblDisplaySwisOnPrintKey))
      then DashDotSBL := ''
      else DashDotSBL := Copy(SBLRec.SwisCode, 5, 2) + '/';

    Result := DashDotSBL + ConvertSBLToDashDot(SBLRec);

  end;  {If _Compare(Result, coBlank)}

end;  {ConvertSwisSBLToDashDot}

{============================================================}
Function ConvertSBLOnlyToDashDot(SBLKey : String) : String;
{Given a 20 char SBL, convert it to dash dot format.}

var
  SBLRec : SBLRecord;
  tbParcel : TTable;
  sCurrentIndex : String;

begin
  Result := '';

    {CHG01022013 - Option to use the exact print key.}

  If glblUseExactPrintKey
  then
  begin
    tbParcel := FindTableInDataModuleForProcessingType(DataModuleParcelTableName, ThisYear);
    sCurrentIndex := tbParcel.IndexName;
    tbParcel.IndexName := 'BYTAXROLLYR_SBLKEY';

    If _Locate(tbParcel, [glblThisYear, SBLKey], '', [loParseSBLOnly])
    then Result := tbParcel.FieldByName('PrintKey').AsString;

    tbParcel.IndexName := sCurrentIndex;

  end;  {If glblUseExactPrintKey}

  If _Compare(Result, coBlank)
  then
  begin
    SBLRec := ExtractSBLFromSBLKey(SBLKey);
    Result := ConvertSBLToDashDot(SBLRec);
  end;

end;  {ConvertSBLOnlyToDashDot}

{============================================================}
Function ConvertSwisSBLToDashDotNoSwis(SwisSBLKey : String) : String;
{Given a 26 char SwisSBL, convert it to dash dot format,
 but do not prefix with the swis code.}
{FXX11101997-1: If a seperator is blank, don't need it.}

var
  bCurrentDisplaySwisOnPrintKey : Boolean;

begin
  (*SBLRec := ExtractSwisSBLFromSwisSBLKey(SwisSBLKey);
  Result := ConvertSBLToDashDot(SBLRec); *)

  bCurrentDisplaySwisOnPrintKey := GlblDisplaySwisOnPrintKey;

  GlblDisplaySwisOnPrintKey := False;

  Result := ConvertSwisSBLToDashDot(SwisSBLKey);

  GlblDisplaySwisOnPrintKey := bCurrentDisplaySwisOnPrintKey;

end;  {ConvertSwisSBLToDashDot}

{============================================================}
Function ConvertDashDotSBLToSegmentSBL(    DashDotSBL : String;
                                       var ValidEntry : Boolean) : SBLRecord;

{Given an SBL entry in dash dot format, convert it to a segment style
 SBL in an SBLRecord format.}
{FXX11101997-1: If a seperator is blank, don't need it, so can't find
                the position, must do blank.}

var
  SBLRec : SBLRecord;
  MaxLen, SepPos : Integer;   {position of next separator}

begin
  ValidEntry := True;

  with SBLRec do
    begin
      SwisCode := '      ';
      Section := '   ';
      Subsection := '   ';
      Block := '    ';
      Lot := '   ';
      Sublot := '   ';
      Suffix := '    ';

        {The approach is the following - look for the next seperator,
         If found, then the segment is the characters up to one minus
         position of the separator. Then delete up to and including
         the separator from the string.}

        {Section}

      If (GlblSectionSeparator = ' ')
        then
        begin
          If (GlblSectionDigits < 3)
          then SepPos := GlblSectionDigits + 1
          else SepPos := 4  {Copy the first three if blank - must be all}
        end
        else SepPos := Pos(GlblSectionSeparator, DashDotSBL);

      If (SepPos > 1)
        then Section := Copy(DashDotSBL, 1, (SepPos - 1));

      If (GlblSectionSeparator = ' ')
        then Delete(DashDotSBL, 1, (SepPos - 1)) {Delete the part, but not the sep since there is none.}
        else Delete(DashDotSBL, 1, SepPos);

        {Subsection}

      If (GlblSubsectionSeparator = ' ')
        then SepPos := 4  {Copy the first three if blank - must be all}
        else SepPos := Pos(GlblSubsectionSeparator, DashDotSBL);

      If (SepPos > 1)
        then Subsection := Copy(DashDotSBL, 1, (SepPos - 1))
        else
          If (SepPos = 0)
            then
              begin
                SubSection := Copy(DashDotSBL, 1, 30);  {No separator, so segment is rest of SBL.}
                DashDotSBL := '';
              end;

      If (GlblSubsectionSeparator = ' ')
        then Delete(DashDotSBL, 1, (SepPos - 1)) {Delete the part, but not the sep since there is none.}
        else Delete(DashDotSBL, 1, SepPos);

        {Block}

      If (GlblBlockSeparator = ' ')
        then SepPos := 5  {Copy the first three if blank - must be all}
        else SepPos := Pos(GlblBlockSeparator, DashDotSBL);

      If (SepPos > 1)
        then Block := Copy(DashDotSBL, 1, (SepPos - 1))
        else
          If (SepPos = 0)
            then
              begin
                Block := Copy(DashDotSBL, 1, 30);  {No separator, so segment is rest of SBL.}
                DashDotSBL := '';
              end;

      If (GlblBlockSeparator = ' ')
        then Delete(DashDotSBL, 1, (SepPos - 1)) {Delete the part, but not the sep since there is none.}
        else Delete(DashDotSBL, 1, SepPos);

        {Lot}
        {FXX12011998-2: In the case of a blank lot separator and a suffix and
                        an alpha lot which is LJ, can have the case where taking
                        4 automatically for the lot separator will get some of the
                        suffix.}

      If (GlblLotSeparator = ' ')
        then
          begin
            SepPos := Pos(GlblSubLotSeparator, DashDotSBL);

            If ((SepPos = 0) or  {No suffix}
                (SepPos > 3))  {Have > 3 until suffix.}
              then SepPos := 4;  {Copy the first three if blank - must be all}

          end
        else SepPos := Pos(GlblLotSeparator, DashDotSBL);

      If (SepPos > 1)
        then Lot := Copy(DashDotSBL, 1, (SepPos - 1))
        else
          If (SepPos = 0)
            then
              begin
                Lot := Copy(DashDotSBL, 1, 30);  {No separator, so segment is rest of SBL.}
                DashDotSBL := '';
              end;

      If (GlblLotSeparator = ' ')
        then Delete(DashDotSBL, 1, (SepPos - 1)) {Delete the part, but not the sep since there is none.}
        else Delete(DashDotSBL, 1, SepPos);

        {Sublot}
      If (GlblSublotSeparator = ' ')
        then SepPos := 4  {Copy the first three if blank - must be all}
        else SepPos := Pos(GlblSublotSeparator, DashDotSBL);

      If (SepPos > 1)
        then Sublot := Copy(DashDotSBL, 1, (SepPos - 1))
        else
          If (SepPos = 0)
            then
              begin
                Sublot := Copy(DashDotSBL, 1, 30);  {No separator, so segment is rest of SBL.}
                DashDotSBL := '';
              end;

      If (GlblSublotSeparator = ' ')
        then Delete(DashDotSBL, 1, (SepPos - 1)) {Delete the part, but not the sep since there is none.}
        else Delete(DashDotSBL, 1, SepPos);

        {Suffix}
      Suffix := Copy(DashDotSBL, 1, 30);  {Copy to end}

        {Now format the individual segments based on the system record.}
        {CHG03072003-2: Should we format to the restricted display length?}

      If GlblFormatSegmentToLength
        then MaxLen := GlblSectionDigits
        else MaxLen := 3;
      ValidEntry := FormatSegment('section', Section, MaxLen,
                                  GlblSectionFormat, True);

      If GlblFormatSegmentToLength
        then MaxLen := GlblSubsectionDigits
        else MaxLen := 3;
      If ValidEntry
        then ValidEntry := FormatSegment('subsection', Subsection, MaxLen,
                                         GlblSubsectionFormat, True);

      If GlblFormatSegmentToLength
        then MaxLen := GlblBlockDigits
        else MaxLen := 4;
      If ValidEntry
        then ValidEntry := FormatSegment('block', Block, MaxLen,
                                         GlblBlockFormat, True);

      If GlblFormatSegmentToLength
        then MaxLen := GlblLotDigits
        else MaxLen := 3;
      If ValidEntry
        then ValidEntry := FormatSegment('lot', Lot, MaxLen,
                                         GlblLotFormat, True);

      If GlblFormatSegmentToLength
        then MaxLen := GlblSublotDigits
        else MaxLen := 3;
      If ValidEntry
        then ValidEntry := FormatSegment('sublot', Sublot, MaxLen,
                                         GlblSublotFormat, True);

      If GlblFormatSegmentToLength
        then MaxLen := GlblSuffixDigits
        else MaxLen := 4;
      If ValidEntry
        then ValidEntry := FormatSegment('suffix', Suffix, MaxLen,
                                         GlblSuffixFormat, True);

      Section := Take(3, Section);
      Subsection := Take(3, Subsection);
      Block := Take(4, Block);
      Lot := Take(3, Lot);
      Sublot := Take(3, Sublot);
      Suffix := Take(4, Suffix);

    end;  {with SBLRec do}

  Result := SBLRec;

end;  {ConvertDashDotSBLToSegmentSBL}

{================================================================================}
Function ConvertSwisDashDotToSwisSBL(    SwisDashDotSBL : String;
                                         SwisCodeTable : TTable;
                                     var ValidEntry : Boolean) : String;

{Given a SwisDashDotSBL in the form ss\SBL where ss = swis short code and a swis code table,
 return the 26 char SwisSBL and if the entry was valid.
 Note that we will also actually allow the 6 digit swis, too.}

var
  FoundRec : Boolean;
  TempSwisCode, SwisCode, TempIndexName : String;
  SlashPos : Integer;
  SBLRec : SBLRecord;

begin
  ValidEntry := True;
  Result := '';
  FoundRec := False;
  TempIndexName := SwisCodeTable.IndexName;

    {FXX12011998-16: If this is a city and there is only one swis
                     (00), then don't make them enter the swis
                     code. However, if it is there, take it.}
    {FXX03012006-1(2.9.5.6): Don't use GetRecordCount.}

  If (_Compare(SwisCodeTable.RecordCount, 1, coEqual) and  {Only 1 swis}
      _Compare(SwisDashDotSBL, '00/', coDoesNotStartWith))  {and they did not enter swis prefix.}
    then
      begin
        FoundRec := True;

          {FXX08261999-1: In a city, not entering 00/ did not work.}

        SlashPos := Pos('/', SwisDashDotSBL);
      end
    else
      begin
        SlashPos := Pos('/', SwisDashDotSBL);

        If (SlashPos = 3)
          then
            begin
                 {The person entered a short swis code.}

              TempSwisCode := Copy(SwisDashDotSBL, 1, 2);
              SwisCodeTable.IndexName := 'BYSWISShortCode';

                {First determine the 26 char SwisSBL.}

              try
                FoundRec := FindKeyOld(SwisCodeTable, ['SWISShortCode'],
                                      [TempSwisCode]);
              except
                ValidEntry := False;
                MessageDlg('Error trying to get swis code.', mtError, [mbOK], 0);
              end;

            end
          else
            If (SlashPos = 7)
              then
                begin
                     {The person entered a short swis code.}

                  TempSwisCode := Copy(SwisDashDotSBL, 1, 6);
                  SwisCodeTable.IndexName := 'BYSWISCODE';

                    {First determine the 26 char SwisSBL.}

                  try
                    FoundRec := FindKeyOld(SwisCodeTable, ['SwisCode'],
                                           [TempSwisCode]);
                  except
                    ValidEntry := False;
                    MessageDlg('Error trying to get swis code.', mtError, [mbOK], 0);
                  end;

                end;

      end;  {else of If ((SwisCodeTable.RecordCount = 1) and ...}

  If FoundRec
    then
      begin
        SwisCode := SwisCodeTable.FieldByName('SwisCode').Text;

        SBLRec := ConvertDashDotSBLToSegmentSBL(Copy(SwisDashDotSBL, (SlashPos + 1), 26), ValidEntry);
        SBLRec.SwisCode := SwisCode;

        with SBLRec do
          Result := SwisCode + Section + Subsection + Block + Lot + Sublot + Suffix;

      end  {If FoundRec}
    else
      begin
        ValidEntry := False;
        MessageDlg('Please enter a valid Swis code.', mtError, [mbOK], 0);
      end;

    {Reset the original index.}

  SwisCodeTable.IndexName := TempIndexName;

end;  {ConvertSwisDashDotToSwisSBL}

{==========================================================}
Procedure ForceSBLRecordFormat(var SBLRec : SBLRecord);

begin
  with SBLRec do
    begin
      FormatSegment('section', Section, 3,
                   GlblSectionFormat, True);

      FormatSegment('subsection', Subsection, 3,
                    GlblSubsectionFormat, True);

      FormatSegment('block', Block, 4,
                    GlblBlockFormat, True);

      FormatSegment('lot', Lot, 3, GlblLotFormat, True);

      FormatSegment('sublot', Sublot, 3, GlblSublotFormat, True);

      FormatSegment('suffix', Suffix, 4,
                    GlblSuffixFormat, True);

      Section := Take(3, Section);
      Subsection := Take(3, Subsection);
      Block := Take(4, Block);
      Lot := Take(3, Lot);
      Sublot := Take(3, Sublot);
      Suffix := Take(4, Suffix);

    end;  {with SBLRec do}

end;  {ForceSBLRecordFormat}

{===============================================================}
Function SchoolCodesMatch_FullOrPartial(SchoolCode1,
                                        SchoolCode2 : String) : Boolean;

{Match the school codes on the least number of chars in either, i.e. if one
 has 2 and the other 4, only match on 4.}
{CHG12221997-1: Make procedures to match on partial school or swis codes.}

 var
   TempLength, Length1, Length2 : Integer;

begin
  Length1 := Length(Trim(SchoolCode1));
  Length2 := Length(Trim(SchoolCode2));

  TempLength := MinInt(Length1, Length2);

  Result := (Take(TempLength, SchoolCode1) = Take(TempLength, SchoolCode2));

end;  {SchoolCodesMatch_FullOrPartial}

{===============================================================}
Function SwisCodesMatch_FullOrPartial(SwisCode1,
                                      SwisCode2 : String) : Boolean;

{Match the Swis codes on the least number of chars in either, i.e. if one
 has 2 and the other 4, only match on 4.}
{CHG12221997-1: Make procedures to match on partial school or swis codes.}

 var
   TempLength, Length1, Length2 : Integer;

begin
  Length1 := Length(Trim(SwisCode1));
  Length2 := Length(Trim(SwisCode2));

  TempLength := MinInt(Length1, Length2);

  Result := (Take(TempLength, SwisCode1) = Take(TempLength, SwisCode2));

end;  {SwisCodesMatch_FullOrPartial}

{===============================================================}
Procedure MarkRecChanged(Table : TTable;
                         UnitName : String);

{Update this parcel, residential site, or commercial site
 record with the name and date changed.}

begin
  Table.Edit;
  Table.FieldByName('LastChangeByName').Text := GlblUserName;
  Table.FieldByName('LastChangeDate').AsDateTime := Date;

  try
    Table.Post;
  except
    SystemSupport(904, Table, 'Error posting rec in ' + Table.TableName + '.',
                  UnitName, GlblErrorDlgBox);
  end;

end;  {MarkRecChanged}

{=============================================================}
Procedure SetRangeForHistoryTaxYear(Table : TTable;
                                    TaxRollYrFieldName,
                                    FieldName : String);  {What is the name of the field with the code?}

{This proc. is used only for history processing - range based on
 the global history year that they have selected. Note that they pass in
 the name of the field to set the range on - code or description. We then
 use this field name to set the index on Year\FieldName and set the range on
 this key. Note that the parameter FieldName must be the exact text field name
 as it appears in the Fields Editor (or DDF).}

begin
(*  Table.IndexFieldNames := TaxRollYrFieldName + ';' + FieldName;
  Size := Table.FieldByName(FieldName).DataSize - 1;  {DataSize adds one for null termination.}
  SetRangeOld(Table, ['TaxRollYr', 'SwisSBLKey'],
              [GlblHistYear, ConstStr(' ', Size)],
              [GlblHistYear, ConstStr('z', Size)]); *)

end;  {SetRangeForHistoryTaxYear}

{=================================================================}
Procedure SetIndexForCodeTable(Table : TTable;
                               FieldName : String);   {What is the name of the field to set the index on?}
{Set the index to either MainCode or Description for a lookup table.}

begin
  If (FieldName = 'Description')
    then Table.IndexName := 'BYDESCRIPTION'
    else Table.IndexName := 'BYMAINCODE';
end;  {SetIndexForCodeTable}

{=================================================================}
Procedure LoadCodeList(    CodeList : TList;
                           CodeTableName,
                           MainCodeFieldName,
                           DescriptionFieldName : String;
                       var Quit : Boolean);

{Load the codes and description for the given table into the given code list.}

var
  FirstTimeThrough, Done, SwisCodeTable : Boolean;
  P : PCodeRecord;
  CodeTable : TTable;

begin
  Done := False;
  FirstTimeThrough := True;

  CodeTable := TTable.Create(nil);
  CodeTable.DatabaseName := 'PASsystem';
  CodeTable.TableName := CodeTableName;
  CodeTable.TableType := ttDBase;

  SwisCodeTable := (CodeTableName = SwisCodeTableName);

  try
    CodeTable.Open;
  except
    SystemSupport(905, CodeTable, 'Error opening ' + CodeTableName + ' table.', 'PASUTILS',
                  GlblErrorDlgBox);
  end;

  try
    CodeTable.First;
  except
    SystemSupport(906, CodeTable, 'Error getting first in ' + CodeTableName + ' table.', 'PASUTILS',
                  GlblErrorDlgBox);
  end;

  repeat
    If FirstTimeThrough
      then
      else
        try
          CodeTable.Next;
        except
          SystemSupport(907, CodeTable, 'Error getting next in ' + CodeTableName + ' table.',
                        'PASUTILS', GlblErrorDlgBox);
        end;

    If CodeTable.EOF
      then Done := True;

    If not Done
      then
        begin
          New(P);

          P^.Code := Take(10, CodeTable.FieldByName(MainCodeFieldName).Text);
          P^.Description := Take(30, CodeTable.FieldByName(DescriptionFieldName).Text);
          P^.CodeTableName := CodeTableName;

            {FXX06251998-7: Need to store the uniform % of value for each swis code.}

          If SwisCodeTable
            then P^.UniformPercentOfValue := CodeTable.FieldByName('UniformPercentValue').AsFloat
            else P^.UniformPercentOfValue := 0;

          CodeList.Add(P);

          CodeTable.Next;

        end;  {If not Done}

  until Done;

  CodeTable.Close;
  CodeTable.Free;

end;  {LoadCodeList}

{=================================================================}
Procedure LoadCodeListWithProcessingType(    CodeList : TList;
                                             CodeTableName,
                                             MainCodeFieldName,
                                             DescriptionFieldName : String;
                                             ProcessingType : Integer;
                                         var Quit : Boolean);

{Load the codes and description for the given table into the given code list.}

var
  FirstTimeThrough, Done, SwisCodeTable : Boolean;
  P : PCodeRecord;
  CodeTable : TTable;

begin
  Done := False;
  FirstTimeThrough := True;

  CodeTable := TTable.Create(nil);
  OpenTableForProcessingType(CodeTable, CodeTableName, ProcessingType, Quit);

  SwisCodeTable := (CodeTableName = SwisCodeTableName);

  try
    CodeTable.Open;
  except
    SystemSupport(908, CodeTable, 'Error opening ' + CodeTableName + ' table.', 'PASUTILS',
                  GlblErrorDlgBox);
  end;

  If (SwisCodeTable and
      (ProcessingType = History))
    then SetFilterForHistoryYear(CodeTable, GlblHistYear);

  try
    CodeTable.First;
  except
    SystemSupport(909, CodeTable, 'Error getting first in ' + CodeTableName + ' table.', 'PASUTILS',
                  GlblErrorDlgBox);
  end;

  repeat
    If FirstTimeThrough
      then
      else
        try
          CodeTable.Next;
        except
          SystemSupport(910, CodeTable, 'Error getting next in ' + CodeTableName + ' table.',
                        'PASUTILS', GlblErrorDlgBox);
        end;

    If CodeTable.EOF
      then Done := True;

    If not Done
      then
        begin
          New(P);

          P^.Code := Take(10, CodeTable.FieldByName(MainCodeFieldName).Text);
          P^.Description := Take(30, CodeTable.FieldByName(DescriptionFieldName).Text);
          P^.CodeTableName := CodeTableName;

            {FXX06251998-7: Need to store the uniform % of value for each swis code.}

          If SwisCodeTable
            then P^.UniformPercentOfValue := CodeTable.FieldByName('UniformPercentValue').AsFloat
            else P^.UniformPercentOfValue := 0;

          CodeList.Add(P);

          CodeTable.Next;

        end;  {If not Done}

  until Done;

  CodeTable.Close;
  CodeTable.Free;

end;  {LoadCodeList}

{====================================================================================}
Function GetDescriptionFromList(Code : String;
                                List : TList) : String;

{Look through the list for the code if it is non blank. Return the description
 for this code. If we can not find the code, then we will return "UNKNOWN".}

var
  I : Integer;
  Found : Boolean;
  TempCode : String;
  TempStr : String;

begin
  I := 0;
  Found := False;
  Code := Take(10, Code);
  Result := '';

    {FXX05041998-6: The call stack was getting too deep, had to seperate some
                    procedure calls.}

  TempCode := DezeroOnLeft(Code);

  If (Deblank(TempCode) <> '')
    then
      while ((I <= (List.Count - 1)) and (not Found)) do
        begin
          TempStr := PCodeRecord(List[I])^.Code;

          If (Take(10, TempStr) = Take(10, Code))
            then
              begin
                Result := PCodeRecord(List[I])^.Description;
                Found := True;
              end;

          I := I + 1;

        end;  {while ((I <= List.Count - 1) and (not Found)) do}

  If ((not Found) and
      (Deblank(Code) <> '') and
      (Deblank(DezeroOnLeft(Code)) <> ''))
    then
      begin
        If (List.Count > 0)
          then TempStr := PCodeRecord(List[0])^.CodeTableName
          else TempStr := 'Unknown';

      end;

  Result := Take(30, Result);

end;  {GetDescriptionFromList}

{=================================================================}
Procedure SetGlobalSBLSegmentFormats(AssessmentYearCtlTable : TTable);

{FXX02101999-3 Split the SBL format into a by year item.}

begin
    {Now set the format of the SBL segments.}

  GlblSectionFormat    := [];
  GlblSubsectionFormat := [];
  GlblBlockFormat      := [];
  GlblLotFormat        := [];
  GlblSublotFormat     := [];
  GlblSuffixFormat     := [];

    {Section}

  with AssessmentYearCtlTable do
    begin
      If FieldByName('SectionLJust').AsBoolean
        then GlblSectionFormat := GlblSectionFormat + [fmLeftJustify];

      If FieldByName('SectionRJust').AsBoolean
        then GlblSectionFormat := GlblSectionFormat + [fmRightJustify];

      If FieldByName('SectionNumeric').AsBoolean
        then GlblSectionFormat := GlblSectionFormat + [fmNumeric];

      If FieldByName('SectionAlphaNum').AsBoolean
        then GlblSectionFormat := GlblSectionFormat + [fmAlphaNumeric];

      If FieldByName('SectionAlpha').AsBoolean
        then GlblSectionFormat := GlblSectionFormat + [fmAlpha];

      If FieldByName('SectionSRAZ').AsBoolean
        then GlblSectionFormat := GlblSectionFormat + [fmShiftRightAddZeroes];

        {Subsection}

      If FieldByName('SubsectionLJust').AsBoolean
        then GlblSubsectionFormat := GlblSubsectionFormat + [fmLeftJustify];

      If FieldByName('SubsectionRJust').AsBoolean
        then GlblSubsectionFormat := GlblSubsectionFormat + [fmRightJustify];

      If FieldByName('SubsectionNumeric').AsBoolean
        then GlblSubsectionFormat := GlblSubsectionFormat + [fmNumeric];

      If FieldByName('SubsectionAlphaNum').AsBoolean
        then GlblSubsectionFormat := GlblSubsectionFormat + [fmAlphaNumeric];

      If FieldByName('SubsectionAlpha').AsBoolean
        then GlblSubsectionFormat := GlblSubsectionFormat + [fmAlpha];

      If FieldByName('SubsectionSRAZ').AsBoolean
        then GlblSubsectionFormat := GlblSubsectionFormat + [fmShiftRightAddZeroes];

        {Block}

      If FieldByName('BlockLJust').AsBoolean
        then GlblBlockFormat := GlblBlockFormat + [fmLeftJustify];

      If FieldByName('BlockRJust').AsBoolean
        then GlblBlockFormat := GlblBlockFormat + [fmRightJustify];

      If FieldByName('BlockNumeric').AsBoolean
        then GlblBlockFormat := GlblBlockFormat + [fmNumeric];

      If FieldByName('BlockAlphaNum').AsBoolean
        then GlblBlockFormat := GlblBlockFormat + [fmAlphaNumeric];

      If FieldByName('BlockAlpha').AsBoolean
        then GlblBlockFormat := GlblBlockFormat + [fmAlpha];

      If FieldByName('BlockSRAZ').AsBoolean
        then GlblBlockFormat := GlblBlockFormat + [fmShiftRightAddZeroes];

        {Lot}

      If FieldByName('LotLJust').AsBoolean
        then GlblLotFormat := GlblLotFormat + [fmLeftJustify];

      If FieldByName('LotRJust').AsBoolean
        then GlblLotFormat := GlblLotFormat + [fmRightJustify];

      If FieldByName('LotNumeric').AsBoolean
        then GlblLotFormat := GlblLotFormat + [fmNumeric];

      If FieldByName('LotAlphaNum').AsBoolean
        then GlblLotFormat := GlblLotFormat + [fmAlphaNumeric];

      If FieldByName('LotAlpha').AsBoolean
        then GlblLotFormat := GlblLotFormat + [fmAlpha];

      If FieldByName('LotSRAZ').AsBoolean
        then GlblLotFormat := GlblLotFormat + [fmShiftRightAddZeroes];

        {Sublot}

      If FieldByName('SublotLJust').AsBoolean
        then GlblSublotFormat := GlblSublotFormat + [fmLeftJustify];

      If FieldByName('SublotRJust').AsBoolean
        then GlblSublotFormat := GlblSublotFormat + [fmRightJustify];

      If FieldByName('SublotNumeric').AsBoolean
        then GlblSublotFormat := GlblSublotFormat + [fmNumeric];

      If FieldByName('SublotAlphaNum').AsBoolean
        then GlblSublotFormat := GlblSublotFormat + [fmAlphaNumeric];

      If FieldByName('SublotAlpha').AsBoolean
        then GlblSublotFormat := GlblSublotFormat + [fmAlpha];

      If FieldByName('SublotSRAZ').AsBoolean
        then GlblSublotFormat := GlblSublotFormat + [fmShiftRightAddZeroes];

        {Suffix}

      If FieldByName('SuffixLJust').AsBoolean
        then GlblSuffixFormat := GlblSuffixFormat + [fmLeftJustify];

      If FieldByName('SuffixRJust').AsBoolean
        then GlblSuffixFormat := GlblSuffixFormat + [fmRightJustify];

      If FieldByName('SuffixNumeric').AsBoolean
        then GlblSuffixFormat := GlblSuffixFormat + [fmNumeric];

      If FieldByName('SuffixAlphaNum').AsBoolean
        then GlblSuffixFormat := GlblSuffixFormat + [fmAlphaNumeric];

      If FieldByName('SuffixAlpha').AsBoolean
        then GlblSuffixFormat := GlblSuffixFormat + [fmAlpha];

      If FieldByName('SuffixSRAZ').AsBoolean
        then GlblSuffixFormat := GlblSuffixFormat + [fmShiftRightAddZeroes];

        {Now assign the separators.}

      try
        GlblSectionSeparator    := FieldByName('SectionSeparator').AsString[1];
        GlblSubsectionSeparator := FieldByName('SubsectionSeparator').AsString[1];
        GlblBlockSeparator      := FieldByName('BlockSeparator').AsString[1];
        GlblLotSeparator        := FieldByName('LotSeparator').AsString[1];
        GlblSublotSeparator     := FieldByName('SublotSeparator').AsString[1];
      except
        GlblSectionSeparator    := '.';
        GlblSubsectionSeparator := '.';
        GlblBlockSeparator      := '.';
        GlblLotSeparator        := '.';
        GlblSublotSeparator     := '.';
      end;

        {FXX11021999-12: Allow the # of forced digits in each segment to be specified.}

      try
        GlblSectionDigits    := FieldByName('SectionDigits').AsInteger;
        GlblSubsectionDigits := FieldByName('SubsectionDigits').AsInteger;
        GlblBlockDigits      := FieldByName('BlockDigits').AsInteger;
        GlblLotDigits        := FieldByName('LotDigits').AsInteger;
        GlblSublotDigits     := FieldByName('SublotDigits').AsInteger;
        GlblSuffixDigits     := FieldByName('SuffixDigits').AsInteger;
      except
        GlblSectionDigits    := 3;
        GlblSubsectionDigits := 3;
        GlblBlockDigits      := 4;
        GlblLotDigits        := 3;
        GlblSublotDigits     := 3;
        GlblSuffixDigits     := 4;
      end;

    end;  {with AssessmentYearCtlTable do}

    {Make sure that if a segment is blank that it is a 'b'.}

  If (Deblank(GlblSectionSeparator) = 'b')
    then GlblSectionSeparator := ' ';

  If (Deblank(GlblSubsectionSeparator) = 'b')
    then GlblSubsectionSeparator := ' ';

  If (Deblank(GlblBlockSeparator) = 'b')
    then GlblBlockSeparator := ' ';

  If (Deblank(GlblLotSeparator) = 'b')
    then GlblLotSeparator := ' ';

  If (Deblank(GlblSublotSeparator) = 'b')
    then GlblSublotSeparator := ' ';

end;  {SetGlobalSBLSegmentFormats}

{============================================================}
Function ModifyAccessAllowed(FormAccessRights : Integer) : Boolean;

{Modify access is not allowed if
  1. They have read only access to this program.
  2. They are in history mode.
  3. They are in NextYear mode and have NextYear readonly access.
  4. They are in ThisYear mode and have ThisYear readonly access.
  5. They have name/addr access only.}

begin
  Result := True;

   {CHG12011998-1: Allow user ID's that only allow name and addr changes on pg 1.}
   {FXX11011999-3: Allow user ID of SCAHIST to modify history.}

  If ((FormAccessRights = raReadOnly) or
      ((GlblTaxYearFlg = 'H') and
       (Take(10, GlblUserName) = Take(10, 'SCAHIST'))) or
      ((GlblTaxYearFlg = 'N') and
       (GlblNextYearAccess = raReadOnly)) or
      ((GlblTaxYearFlg = 'T') and
       (GlblThisYearAccess = raReadOnly)) or
      GlblNameAddressUpdateOnly)
    then Result := False;

end;  {ModifyAccessAllowed}

{===============================================================================}
Function DetermineProcessingType(ProcessingTypeChar : Char) : Integer;

{Convert from the letter based processing year to the constants listed in GLBLCNST.}

begin
  Result := NoProcessingType;
  case ProcessingTypeChar of
    'H' : Result := History;
    'N' : Result := NextYear;
    'S' : Result := SalesInventory;
    'T' : Result := ThisYear;
    'X' : Result := NoProcessingType;

  end;  {case ProcessingTypeChar of}

end;  {DetermineProcessingType}

{===============================================================================}
Function ConvertProcessingTypeToChar(ProcessingType : Integer) : Char;

{Convert from the processing type constants listed in GLBLCNST to a char.}

begin
  Result := ' ';
  case ProcessingType of
    History : Result := 'H';
    NextYear : Result := 'N';
    SalesInventory : Result := 'S';
    ThisYear : Result := 'T';

  end;  {case ProcessingType of}

end;  {ConvertProcessingTypeToChar}

{=================================================================}
Function ParcelIsActive(ParcelTable : TTable) : Boolean;

{Is this parcel active?}

begin
  If (ParcelTable.FieldByName('ActiveFlag').Text = InactiveParcelFlag)
     then Result := False
     else Result := True;

end;  {ParcelIsActive}

{=================================================================}
Function MarkParcelInactive(ParcelTable : TTable;
                            TaxRollYr : String;
                            ParcelID : String) : Boolean;

{Set the active flag of a parcel to inactive. If successful, return True,
 otherwise, False. Also, set the changed dates for the parcel.}

var
  FoundRec : Boolean;
  SwisSBLRec : SBLRecord;

begin
  Result := True;

  try
    SwisSBLRec := ExtractSwisSBLFromSwisSBLKey(ParcelID);

    with SwisSBLRec do
      FoundRec := FindKeyOld(ParcelTable,
                             ['TaxRollYr', 'SwisCode', 'Section',
                              'Subsection', 'Block', 'Lot',
                              'Sublot', 'Suffix'],
                             [TaxRollYr, SwisCode, Section, Subsection,
                              Block, Lot, Sublot, Suffix]);

    If FoundRec
      then
        begin
          ParcelTable.Edit;

          ParcelTable.FieldByName('ActiveFlag').Text := InactiveParcelFlag;
          ParcelTable.FieldByName('LastChangeByName').Text := GlblUserName;
          ParcelTable.FieldByName('LastChangeDate').AsDateTime := Date;

          ParcelTable.Post;

        end  {If FoundRec}
      else
        begin
          Result := False;
          MessageDlg('Unable to find parcel record to mark it inactive.', mtError,
                     [mbOK], 0);
        end;

  except
    Result := False;
    MessageDlg('Error trying to mark parcel inactive.', mtError, [mbOK], 0);
  end;

end;  {MarkParcelInactive}

{=================================================================}
Function MarkParcelReactivated(ParcelTable : TTable;
                               TaxRollYr : String;
                               ParcelID : String) : Boolean;

{Set the active flag of a parcel to reactivated. If successful, return True,
 otherwise, False.}

var
  FoundRec : Boolean;
  SwisSBLRec : SBLRecord;

begin
  Result := True;

  try
    SwisSBLRec := ExtractSwisSBLFromSwisSBLKey(ParcelID);

    with SwisSBLRec do
      FoundRec := FindKeyOld(ParcelTable,
                             ['TaxRollYr', 'SwisCode', 'Section',
                              'Subsection', 'Block', 'Lot',
                              'Sublot', 'Suffix'],
                             [TaxRollYr, SwisCode, Section, Subsection,
                              Block, Lot, Sublot, Suffix]);

    If FoundRec
      then
        begin
          ParcelTable.Edit;

          ParcelTable.FieldByName('ActiveFlag').Text := ActiveParcelFlag;  {Don't use reactivated flag.}
          ParcelTable.FieldByName('LastChangeByName').Text := GlblUserName;
          ParcelTable.FieldByName('LastChangeDate').AsDateTime := Date;

          ParcelTable.Post;

        end  {If FoundRec}
      else
        begin
          Result := False;
          MessageDlg('Unable to find parcel record to mark it reactivated.', mtError,
                     [mbOK], 0);
        end;

  except
    Result := False;
    MessageDlg('Error trying to mark parcel reactivated.', mtError, [mbOK], 0);
  end;

end;  {MarkParcelReactivated}

{==================================================================}
Function DetermineDescriptionField(FieldName : String) : String;

{Given a field 'xxxCode', return 'xxxDesc'.}

var
  DescFieldName : String;

begin
  DescFieldName := FieldName;
  If (Pos('Code', DescFieldName) > 0)
    then Delete(DescFieldName, Pos('Code', DescFieldName), 50);  {Delete 'Code' from the field name.}
  DescFieldName := DescFieldName + 'Desc';  {Now add 'Desc' to get the code field name.}
  Result := DescFieldName;

end;  {DetermineDescriptionField}

{==============================================================================}
Procedure RefreshDropdownsAndLabels(Form : TForm;
                                    MainTable : TTable;
                                    DescriptionIndexedLookups : DropdownTagIDSetType);

{For some reason the lookup boxes were not being filled in with the
 value in the underlying MainTable field when the form was initialized,
 so this fills in the fields so that the data is visible. Note that this
 does not cause the table to be marked modified. Also, we will fill
 in any labels for code based dropdowns. Note that the label names (not captions)
 must be EXACTLY the description field name in the table.}

var
  I : Integer;
  TempStr : String;

begin
  with Form do
    For I := 1 to (ComponentCount - 1) do
      begin
        TempStr := Components[I].Name;

          {First do the dropdowns. Note that we do not want to do dropwdowns that
           point to tables other than CodeTable since the field names might not
           be compatible.}

        If ((Components[I] is TwwDBLookupCombo) and
            (TwwDBLookupCombo(Components[I]).LookupTable.Name = 'CodeTable'))
          then
            with Components[I] as TwwDBLookupCombo do
              begin
                  {FXX03061998-1: Only set the lookup field if blank,
                                  otherwise, caused a heap overflow under
                                  certain circumstances.}

                If (Deblank(LookupField) = '')
                  then
                    If (Tag in DescriptionIndexedLookups)
                      then LookupField := 'Description'
                      else LookupField := 'MainCode';

                TempStr := Name;
                TempStr := DataField;

                  {FXX10251997-1: By clearing the selected, the following
                                  problem was occurring: if someone went
                                  into a drop down a second time right
                                  away, the second column was missing.}

                (*Selected.Clear;*)

                Text := MainTable.FieldByName(DataField).Text;

                TempStr := Text;

              end;  {with Components[I] as TwwDBLookupCombo do}

          {Set the description labels.}

        If ((Components[I] is TLabel) and
            (Pos('Desc', TLabel(Components[I]).Name) > 0))
          then
            with Components[I] as TLabel do
              begin
                Visible := True;
                Caption := MainTable.FieldByName(Name).Text;
                Hint := MainTable.FieldByName(Name).Text;
                Repaint;

              end;  {with Components[I] as TLabel do}

      end;  {For I := 1 to (ComponentCount - 1) do}

end;  {RefreshDropdownsAndLabels}

{==============================================================================}
Procedure SetDisplayFormatForCurrencyFields(Form : TForm;
                                            DisplayZeroesAsBlanks : Boolean);

{Set up the currency fields display formats to $xxx,xxx}

var
  I : Integer;
  TempField : TCurrencyField;

begin
  with Form do
    For I := 1 to (ComponentCount - 1) do
      If (Components[I] is TCurrencyField)
        then
          begin
            TempField := TCurrencyField(Components[I]);

            with TempField do
              If ((DataType = ftCurrency) and
                   Currency)
                then
                   {CHG10091997-1: Should zeroes be blanks or '0'?}
                  If DisplayZeroesAsBlanks
                    then DisplayFormat := CurrencyNormalDisplay_BlankZero
                    else DisplayFormat := CurrencyNormalDisplay;

          end;  {If (Components[I] is TCurrencyField)}

end;  {SetDisplayFormatForCurrencyFields}

{==========================================================================}
Procedure OpenTableForProcessingType(    Table : TTable;
                                         TableName : String;
                                         ProcessingType : Integer;
                                     var Quit : Boolean);

{Open the table with the given the table name and processing type.}

begin
  try
    Table.Close;

      {Only set the database if we already know it is not coop.}
      {FXX01312007-1(2.11.1.15): Don't reassign to PASSystem if PropertyAssessmentSystem.}

    If ((ANSIUpperCase(Table.DatabaseName) <> 'PROPERTYASSESSMENTSYSTEMCOOPS') and
        (ANSIUpperCase(Table.DatabaseName) <> 'PROPERTYASSESSMENTSYSTEM') and
        (ANSIUpperCase(Table.DatabaseName) <> 'YORKTOWN TUNELL DATA') and
        (ANSIUpperCase(Table.DatabaseName) <> 'PASVALUATION') and
        (ANSIUpperCase(Table.DatabaseName) <> 'PASAAR2004'))
      then Table.DatabaseName := 'PASsystem';

    Table.TableType := ttDBase;
    Table.TableName := TableName;

    If ((ANSIUpperCase(Table.DatabaseName) <> 'YORKTOWN TUNELL DATA') and
        (ANSIUpperCase(Table.DatabaseName) <> 'PASVALUATION'))
      then SetTableNameForProcessingType(Table, ProcessingType);
    Table.Open;
  except
    Quit := True;
    SystemSupport(963, Table, 'Error opening table ' + Table.TableName + '.', 'PASUTILS.PAS',
                  GlblErrorDlgBox);
  end;

end;  {OpenTableForProcessingType}

{================================================================================}
Function OpenTablesForForm(Form : TComponent;
                           ProcessingType : Integer) : Boolean;

{Given a form, open all tables on it using the fast open method. Any table
 which does not have a table name filled in, i.e. the CodeTable on many parcel pages,
 will not be opened. This function returns true if all the tables are opened
 successfully.
 If this form does not have a specific processing type (i.e. any
 non parcel page), just pass in GlblProcessingType which is a
 variable corresponding to the tax year flag.}

var
  I, TempProcessingType : Integer;
  Quit : Boolean;
  TableName : String;

begin
  Quit := False;
  with Form do
    begin
      For I := 1 to (ComponentCount - 1) do
        If ((Components[I] is TTable) and
            (Deblank(TTable(Components[I]).TableName) <> ''))
          then
            begin
              LogTime('c:\trace.txt', 'OpenTablesForForm - before ' + TTable(Components[I]).TableName);
              TableName := TTable(Components[I]).TableName;
              TempProcessingType := ProcessingType;

                {If this a sales inventory page, and this is an inventory file, then
                 we will change the table name so that it is a sales inventory file
                 (i.e. starts with 'S'). However, if this is sales inventory, but the file
                 is not inventory (i.e. TParcelRec), then we want to open it with the GlblTaxYrFlg as
                 the ProcessingType because SalesInventory can only be viewed for the current Processing year.
                 However, if this is not sales, we will just adjust the first letter of any year
                 dependant files to match the processing type of this instance.}

              If ((ProcessingType = SalesInventory) and
                  (Take(5, TableName) <> 'TPRes') and
                  (Take(5, TableName) <> 'TPCom'))
                then TempProcessingType := DetermineProcessingType(GlblTaxYearFlg);

              OpenTableForProcessingType(TTable(Components[I]), TableName,
                                         TempProcessingType, Quit);

              LogTime('c:\trace.txt', 'OpenTablesForForm - after ' + TTable(Components[I]).TableName);

            end;  {If ((Components[I] is TTable) and ...}

    end;  {with Form do}

  Result := not Quit;

end;  {OpenTablesForForm}

{================================================================================}
Procedure CloseTablesForForm(Form : TComponent);

{Close all the tables on the form.}

var
  I : Integer;

begin
    {Close all tables here.}

  with Form do
    For I := 1 to (ComponentCount - 1) do
      If (Components[I] is TTable)
        then
          try
            with Components[I] as TTable do
              If Active
                then Close;

          except
          end;

end;  {CloseTablesForForm}

{================================================================================}
Procedure DeleteRecordsForParcel(    Table : TTable;
                                     TaxRollYear : String;
                                     SwisSBLKey : String;
                                 var Quit : Boolean);

{Delete all the parcels with this TaxRollYr\SwisSBL in this file.}

var
  Done : Boolean;

begin
  Table.CancelRange;
  Done := False;

  If TableIsYearBasedTable(Table.TableName)
    then
      begin
        If _Compare(Copy(Table.TableName, 2, 200), Copy(ParcelTableName, 2, 200), coEqual)
          then
            begin
              Table.IndexName := 'BYTAXROLLYR_SWISSBLKEY';
              _SetRange(Table, [TaxRollYear, SwisSBLKey], [], '', [loParseSwisSBLKey, loSameEndingRange]);

            end
          else
            begin
              Table.IndexName := 'BYTAXROLLYR_SWISSBLKEY';
              SetRangeOld(Table,
                          ['TaxRollYr', 'SwisSBLKey'],
                          [TaxRollYear, SwisSBLKey],
                          [TaxRollYear, SwisSBLKey]);

            end;  {else of If (IsSalesTable or IsNotesTable)}

      end
    else
      begin
        Table.IndexName := 'BYSWISSBLKEY';
        SetRangeOld(Table, ['SwisSBLKey'],[SwisSBLKey],[SwisSBLKey]);
      end;

  Table.First;

  repeat
      {If this is the EOF or we are on a different parcel ID then the source, then
       we are done.}

    If Table.EOF
      then Done := True;

      {If we got a record for this source parcel id ok, then we will copy it to all
       destination parcel id's.}

    If not (Done or Quit)
      then
        begin
          try
            Table.Delete;
          except
            Quit := True;
            SystemSupport(911, Table, 'Error deleting record in ' + Table.TableName + '.',
                          'PASUTILS.PAS', GlblErrorDlgBox);
          end;

        end;  {If not (Done or Quit)}

  until (Done or Quit);

end;  {DeleteRecordsForParcel}

{============================================================================}
Function PropertyIsResidential(PropertyClass : String) : Boolean;

{Determine if a property is residential. For now, we are assuming
 that any 2xx class is residential, but this needs more investigation.}
{FXX02031999-1: Also 411 is a residential.}

begin
  If ((PropertyClass[1] = '2') or
      (PropertyClass = '411') or
      (PropertyClass = '311') or
      (PropertyClass = '484'))
    then Result := True
    else Result := False;

end;  {PropertyIsResidential}

{============================================================================}
Function ReturnCheckDigit(SwisSBLKey : String;
                          SequenceNumber : Integer) : String;

{DS: Return the RPS check digit given the SwisSBL.}
{The sequence number is used for giving individual sales a unique check
 digit. For parcels, the sequence number is 0.}
{DS: The algorithm contained in this routine is taken from the NYS RPS
      system documentation }

var
  Res       : String;
  KeyStr    : String;
  I, K     : Integer;
  TotalWt,
  Quotient,
  Remainder : Integer;
  Element   : Char;
  ElementWt : Integer;
  WeightTable : Array[0..36] Of Char;
  LookUpTable : Array[0..25] Of Char;
  SmallEnuf : Boolean;

begin
  Res := ''; { Initialize result }
  WeightTable := '0123456789 ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  LookupTable := 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';

  {First, set the key string to the entire key...}
  KeyStr := Take(26, SwisSBLKey) +
            ShiftRightAddZeroes(Take(2, IntToStr(SequenceNumber))) + '1';

  { the trailing '00' is a sequence number, and the trailing '1'
    signifies that this came from an assessent record }

  TotalWt := 0;

  For I := 1 to 29 do
    begin
      Element := KeyStr[I];
      ElementWt :=  0;

      For K := 0 to 36 do
        If (WeightTable[K] = Element)
          then ElementWt := K;

      If ((ElementWt = 0) and
          (Element <> '0'))
        then ElementWt := 37;

      TotalWt := TotalWt + (ElementWt * I)

    end;  {For I := 1 to 29 do}

     {Per RPS instructions, if the total weight exceeds 676, subtract
      676 from the weight, IF NOT <= 676, SUBTRACT 676 AGAIN TILL SMALL ENUF }

  SmallEnuf := False;

  repeat
    If (TotalWt >= 676)
      then TotalWt := TotalWt - 676
      else SmallEnuf := True;

   until SmallEnuf;

    {Next, divide the total weight by 26 and capture the quotient and remainder}

  Quotient := TotalWt Div 26;
  Remainder := TotalWt Mod 26;

    {Now, look up each in the table}

  Res := '  ';
  Res[1] := LookupTable[Quotient];
  Res[2] := LookupTable[Remainder];
  ReturnCheckDigit := Res;  { Set final function result }

end;  {ReturnCheckDigit}

{======================================================================}
Function DetermineExemptionResidentialType(ExemptionCode : String) : String;

var
  ExemptionCodeInt : LongInt;
  ReturnCode : Integer;

begin
  Val(ExemptionCode, ExemptionCodeInt, ReturnCode);
  Result := ' ';

    {Check for residential}
    {FXX03031999-2: Exemption 4770x is res also.}
    {FXX04162001-1: Make sure STAR is residential.}

  If ((ExemptionCodeInt = 41834) or
      (ExemptionCodeInt = 41854) or
      ((ExemptionCodeInt DIV 10) = 4112) or
      ((ExemptionCodeInt DIV 10) = 4113) or
      ((ExemptionCodeInt DIV 10) = 4114) or
      ((ExemptionCodeInt DIV 10) = 4130) or
      ((ExemptionCodeInt DIV 10) = 4180) or
      ((ExemptionCodeInt DIV 100) = 419) or
      ((ExemptionCodeInt DIV 10) = 4770) or
      ((ExemptionCodeInt DIV 10) = 4166) or
      ((ExemptionCodeInt DIV 10) = 4168) or
      ((ExemptionCodeInt DIV 10) = 4951))
    then Result := 'R';

    {Check for both.}

  If (((ExemptionCodeInt DIV 10) = 4110) or
      ((ExemptionCodeInt DIV 10) = 4111) or
      (ExemptionCodeInt = 41200) or
      (ExemptionCodeInt = 49500) or
      (ExemptionCodeInt = 41400))
    then Result := 'B';

    {If it does not fall into the above categories, it is non-residential.}

  If (Deblank(Result) = '')
    then Result := 'N';

  Result := Take(2, Result);

end;  {DetermineExemptionResidentialType}

{=====================================================================}
Function CalculateNumSites(SiteTable : TTable;
                           TaxRollYr : String;
                           SwisSBLKey : String;
                           SalesNo : Integer;
                           SalesInventory : Boolean) : Integer;

{This procedure figures out how many sites there are for a parcel -
 both commercial and residential.}

var
  Done, FirstTimeThrough : Boolean;

begin
  FirstTimeThrough := True;
  Done := False;
  Result := 0;

  try
    If SalesInventory
      then SetRangeOld(SiteTable, ['SwisSBLKey', 'SalesNumber', 'Site'],
                       [SwisSBLKey, IntToStr(SalesNo), '0'],
                       [SwisSBLKey, IntToStr(SalesNo), '32000'])
      else SetRangeOld(SiteTable,
                       ['TaxRollYr', 'SwisSBLKey', 'Site'],
                       [TaxRollYr, SwisSBLKey, '0'],
                       [TaxRollYr, SwisSBLKey, '32000']);
  except
    SystemSupport(912, SiteTable, 'Error setting range on site table ' + SiteTable.TableName,
                  'PASUTILS.PAS', GlblErrorDlgBox);
  end;

  SiteTable.First;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else SiteTable.Next;

    If (SiteTable.EOF or
        (Take(26, SiteTable.FieldByName('SwisSBLKey').Text) <> Take(26, SwisSBLKey)))
      then Done := True;

    If not Done
      then Result := Result + 1;

  until Done;

end;  {CalculateNumSites}

{====================================================================}
Procedure CalculateHstdAndNonhstdAmounts(    TaxRollYr : String;
                                             SwisSBLKey : String;
                                             AssessmentTable,
                                             ClassTable,
                                             ParcelTable : TTable;
                                         var HstdAssessedVal,
                                             NonhstdAssessedVal,
                                             HstdLandVal,
                                             NonhstdLandVal : Comp;
                                         var HstdAcres,
                                             NonhstdAcres : Real;
                                         var AssessmentRecordFound,
                                             ClassRecordFound : Boolean);

{Given the assessment table, class table, and parcel table, return the
 homestead and nonhomestead assessed values. If this is not a classified
 municipality, then the one assessed value will be returned in the
 HstdAssessedVal variable.
 Also, we will return the homestead and nonhomestead land and acreage values.}

begin
  HstdAssessedVal := 0;
  NonhstdAssessedVal := 0;
  HstdLandVal := 0;
  NonhstdLandVal := 0;
  HstdAcres := 0;
  NonhstdAcres := 0;

  try
    AssessmentRecordFound := FindKeyOld(AssessmentTable,
                                        ['TaxRollYr', 'SwisSBLKey'],
                                        [TaxRollYr, SwisSBLKey]);
  except
    SystemSupport(913, AssessmentTable, 'Error getting assessment record.',
                  'PASUTILS.PAS', GlblErrorDlgBox);
  end;

    {FXX07172007-1(2.11.2.4): If the assessment record is not found, give an error message.}

  If not AssessmentRecordFound
    then SystemSupport(977, AssessmentTable, 'Assessment record not found for ' + SwisSBLKey + '.',
                       'PASUTILS.PAS', GlblErrorDlgBox);

  try
    ClassRecordFound := FindKeyOld(ClassTable,
                                   ['TaxRollYr', 'SwisSBLKey'],
                                   [TaxRollYr, SwisSBLKey]);
  except
    SystemSupport(914, ClassTable, 'Error getting Class record.',
                  'PASUTILS.PAS', GlblErrorDlgBox);
  end;

  If ClassRecordFound
    then
      begin
        HstdAssessedVal := TCurrencyField(ClassTable.FieldByName('HstdTotalVal')).Value;
        NonhstdAssessedVal := TCurrencyField(ClassTable.FieldByName('NonhstdTotalVal')).Value;
        HstdLandVal := TCurrencyField(ClassTable.FieldByName('HstdLandVal')).Value;
        NonhstdLandVal := TCurrencyField(ClassTable.FieldByName('NonhstdLandVal')).Value;
        HstdAcres := ClassTable.FieldByName('HstdAcres').AsFloat;
        NonhstdAcres := ClassTable.FieldByName('NonhstdAcres').AsFloat;

      end
    else
      begin
          {No class record, so we will put the assessed value in either the
           homestead or nonhomestead amounts depending on the homestead
           code of the parcel. If this parcel is not designated, the amounts
           will go in the homestead variables.}

        If (ParcelTable.FieldByName('HomesteadCode').Text = 'N')
          then
            begin
              NonhstdAssessedVal := TCurrencyField(AssessmentTable.FieldByName('TotalAssessedVal')).Value;
              NonhstdLandVal := TCurrencyField(AssessmentTable.FieldByName('LandAssessedVal')).Value;
              NonhstdAcres := ParcelTable.FieldByName('Acreage').AsFloat;
            end
          else
            begin
              HstdAssessedVal := TCurrencyField(AssessmentTable.FieldByName('TotalAssessedVal')).Value;
              HstdLandVal := TCurrencyField(AssessmentTable.FieldByName('LandAssessedVal')).Value;
              HstdAcres := ParcelTable.FieldByName('Acreage').AsFloat;

            end;  {else of If (ParcelTable.FieldByName('HomesteadCode').Text = 'N')}

      end;  {If ClassRecordFound}

end;  {CalculateHstdAndNonhstdAssessedVal}

{==========================================================================}
Procedure LogException(ExceptionMessage,
                       ExceptionClassName,
                       AdditionalMsg : String;
                       ExceptionAddr : Pointer);

{Store this unhandled exception in the SCA error file log.}

var
  ErrorFile : TextFile;
  FileName : String;

begin
  If (Deblank(GlblErrorFileDir) = '')
    then FileName := 'SCAERROR.TXT'
    else FileName := ExpandPASPath(GlblErrorFileDir) + 'SCAERROR.TXT';

  try
    AssignFile(ErrorFile, FileName);

    If FileExists(FileName)
      then Append(ErrorFile)
      else Rewrite(ErrorFile);

    Writeln(ErrorFile, 'Date: ', DateToStr(Date), '  Time: ', TimeToStr(Time));
    Writeln(ErrorFile, 'Exception: ', ExceptionMessage);
    Writeln(ErrorFile, 'Exception Class: ', ExceptionClassName);
    Writeln(ErrorFile, 'Additional Message: ', AdditionalMsg);

    Writeln(ErrorFile);
    Writeln(ErrorFile);

    CloseFile(ErrorFile);

  except
    {Throw away this exception.}
  end;

end;  {LogException}

{==========================================================================}
Function GetPrintFileName(Caption : String;
                          ChangeToPrintDir : Boolean) : String;

{We want a unique file name, so we will use the first two letters of the
 form name plus the time down to the millisecond.}
{The form of the file name is xxHHMMSS.MM (Two letters\Hour\minute\second.millisecond)}

var
  Hour, Minute,
  Second, Millisecond : Word;
  sTempCaption : String;

begin
  DecodeTime(Time, Hour, Minute, Second, Millisecond);

  sTempCaption := StripChars(Copy(Caption, 1, 8),
                             [':', '/', '\', ',', ' '],
                             ' ', False);

  Result := sTempCaption +
            ShiftRightAddZeroes(Take(2, IntToStr(Hour))) +
            ShiftRightAddZeroes(Take(2, IntToStr(Minute))) +
            ShiftRightAddZeroes(Take(2, IntToStr(Second))) + '.' +
            ShiftRightAddZeroes(Take(2, IntToStr(Millisecond)));

  Result := GlblDrive + ':' + GlblReportDir + Result;

  If ChangeToPrintDir
    then ChDir(GlblDrive + ':' + GlblReportDir);

end;  {GetPrintFileName}

{==========================================================================}
Procedure PrintSelectedSwisCodes(Sender : TObject;
                                 SelectedSwisCodes : TStringList;
                                 SwisCodeTable : TTable);

{For a report where they can select any number of swis codes, this prints out
 what swis codes they selected. If they selected all, we will just say all instead
 of printing all.}

var
  I : Integer;

begin
  with Sender as TBaseReport do
    If (SelectedSwisCodes.Count = GetRecordCount(SwisCodeTable))
      then Println('For All Swis Codes')
      else
        begin
          Underline := False;
          ClearTabs;
          SetTab(0.3, pjLeft, 1.5, 0, BoxLineBottom, 0);  {Desc}
          SetTab(1.7, pjLeft, 6.3, 0, BoxLineBottom, 0);  {Parcel ID}

          Print(#9 + 'For Swis Codes: ' + #9);

          I := 1;

          while (I <= SelectedSwisCodes.Count) do
            begin
                {Only 9 per line.}

              If ((I MOD 9) = 0)
                then
                  begin
                    Println('');
                    Print(#9 + #9);
                  end;

              Print(SelectedSwisCodes[I - 1] + ' ');

              I := I + 1;

            end;  {while (I <= SelectedSwisCodes.Count) do}

          Println('');

        end;  {else of If (SelectedSwisCodes.Count = SwisCodeTable.RecordCount)}

end;  {PrintSelectedSwisCodes}

{==========================================================================}
Function GetMunicipalityName : String;

{Return the municipality name with the type.}

begin
  case GlblMunicipalityType of
    MTTown : Result := 'Town of ' + UpperCaseFirstChars(RTrim(GlblMunicipalityName));
    MTSchool : Result := UpperCaseFirstChars(RTrim(GlblMunicipalityName)) + ' School District';
    MTCity : Result := 'City of ' + UpperCaseFirstChars(RTrim(GlblMunicipalityName));
    MTVillage : Result := 'Village of ' + UpperCaseFirstChars(RTrim(GlblMunicipalityName));
    MTCounty : Result := 'County of ' + UpperCaseFirstChars(RTrim(GlblMunicipalityName));
    MTNone : Result := UpperCaseFirstChars(RTrim(GlblMunicipalityName));
  end;  {case GlblMunicipalityType of}

end;  {GetMunicipalityName}

{==========================================================================}
Procedure GetAuditParcelRec(    ParcelTable : TTable;
                                _AssessedVal : Comp;
                                EXAmounts : ExemptionTotalsArrayType;
                            var AuditParcelRec : AuditParcelRecord);

{Get the information that we need in order to write out a trace record
 if any important roll totals change.}
 {CHG03301998-1: Trace SD, EX changes from everywhere. Also more parcel info.}

begin
  with AuditParcelRec do
    begin
      RollSection := ParcelTable.FieldByName('RollSection').Text;
      HomesteadCode := ParcelTable.FieldByName('HomesteadCode').Text;
      SchoolCode := ParcelTable.FieldByName('SchoolCode').Text;

      ResPercent := ParcelTable.FieldByName('ResidentialPercent').AsFloat;
      Frontage := ParcelTable.FieldByName('Frontage').AsFloat;
      Depth := ParcelTable.FieldByName('Depth').AsFloat;
      Acreage := ParcelTable.FieldByName('Acreage').AsFloat;

      AssessedVal := _AssessedVal;
      CountyTaxableVal := AssessedVal - EXAmounts[EXCounty];
      TownTaxableVal := AssessedVal - EXAmounts[EXTown];
      SchoolTaxableVal := AssessedVal - EXAmounts[EXSchool];

      SplitMergeNo := ParcelTable.FieldByName('SplitMergeNo').Text;

    end;  {with AuditParcelRec do}

end;  {GetAuditParcelRec}

{==========================================================================}
Procedure InsertParcelChangeRec(SwisSBLKey : String;
                                TaxRollYr : String;
                                AuditParcelChangeTable : TTable;
                                OrigAuditParcelRec,
                                NewAuditParcelRec : AuditParcelRecord;
                                RecordType : Char);

{CHG03161998-1: Track exemption, SD adds, av changes, parcel add/del.}
{CHG03301998-1: Trace SD, EX changes from everywhere. Also more parcel info.}
{Add an audit record to track parcel additions and deletions.}

begin
  with AuditParcelChangeTable do
    try
      Insert;

      FieldByName('SwisSBLKey').Text := SwisSBLKey;
      FieldByName('TaxRollYr').Text := TaxRollYr;
      FieldByName('Date').AsDateTime := Date;
      FieldByName('Time').AsDateTime := Now;
      FieldByName('User').Text := GlblUserName;
      FieldByName('RecordType').Text := RecordType;

      If (RecordType in ['A', 'C'])
        then
          with AuditParcelChangeTable, NewAuditParcelRec do
            begin
              FieldByName('NewSchoolCode').Text := SchoolCode;
              FieldByName('NewAssessedVal').AsFloat := AssessedVal;
              FieldByName('NewCountyTaxableVal').AsFloat := CountyTaxableVal;
              FieldByName('NewTownTaxableVal').AsFloat := TownTaxableVal;
              FieldByName('NewSchlTaxableVal').AsFloat := SchoolTaxableVal;
              FieldByName('NewRollSection').Text := RollSection;
              FieldByName('NewHstdCode').Text := HomesteadCode;
              FieldByName('NewFrontage').AsFloat := Frontage;
              FieldByName('NewDepth').AsFloat := Depth;
              FieldByName('NewAcreage').AsFloat := Acreage;
              FieldByName('NewResPercent').AsFloat := ResPercent;
              FieldByName('SplitMergeNo').Text := SplitMergeNo;

            end;  {with AuditParcelChangeTable, AuditParcelRec do}

      If (RecordType in ['D', 'C'])
        then
          with AuditParcelChangeTable, OrigAuditParcelRec do
            begin
              FieldByName('OldSchoolCode').Text := SchoolCode;
              FieldByName('OldAssessedVal').AsFloat := AssessedVal;
              FieldByName('OldCountyTaxableVal').AsFloat := CountyTaxableVal;
              FieldByName('OldTownTaxableVal').AsFloat := TownTaxableVal;
              FieldByName('OldSchlTaxableVal').AsFloat := SchoolTaxableVal;
              FieldByName('OldRollSection').Text := RollSection;
              FieldByName('OldHstdCode').Text := HomesteadCode;
              FieldByName('OldFrontage').AsFloat := Frontage;
              FieldByName('OldDepth').AsFloat := Depth;
              FieldByName('OldAcreage').AsFloat := Acreage;
              FieldByName('OldResPercent').AsFloat := ResPercent;
              FieldByName('SplitMergeNo').Text := SplitMergeNo;

            end;  {with AuditParcelChangeTable, AuditParcelRec do}


      try
        Post;
      except
        SystemSupport(915, AuditParcelChangeTable, 'Error inserting parcel change trace rec.',
                      'PASUTILS', GlblErrorDlgBox);
      end;

    except
    end;  {with AuditParcelChangeTable do}

end;  {InsertParcelChangeAuditRec}

{=========================================================}
Procedure SetOrientation(Sender : TObject;
                         _Orientation : Integer);  {0=Portrait, 1=Landscape}

{FXX04171998-1: In order to get the setting in the printer dialog to
                work, must take info out of print dialog and put into
                Report components.}


begin
  with Sender as TBaseReport do
    begin
      If (Orientation = poDefault)
        then
          If (_Orientation = 0)
            then Orientation := poPortrait
            else Orientation := poLandscape;

    end;

end;  {SetOrientation}

{=====================================================================}
Procedure FillInNameAddrArray(    Name1,
                                  Name2,
                                  Address1,
                                  Address2,
                                  Street,
                                  City : String;
                                  State : String;
                                  Zip : String;
                                  ZipPlus4 : String;
                                  IncludeZipPlus4 : Boolean;
                                  bPrintOrCurrentOwner : Boolean;
                              var NAddrArray : NameAddrArray);

{FXX05191998-5: Make the name address routine common for letters.}

var
  I : Integer;
  TempStr, FullZipCode : String;
  AddComma, IncludeZipOnCityStateLine : Boolean;

begin
  For I := 1 to 6 do
    NAddrArray[I] := Take(30, '');

  I := 1;

  If ((GlblUseMailingAddrFields and
       (Deblank(Address1) = '')) or
      (not GlblUseMailingAddrFields))
    then
      begin
        If (Deblank(Name1) <> '')
          then
            begin
              NAddrArray[I] := Name1;
              I := I + 1;
            end;

       If (Deblank(Name2) <> '')
         then
           begin
             NAddrArray[I] := Name2;
             I := I + 1;
           end;

      end;  {If ((GlblUseMailingAddrFields and ...}

   If bPrintOrCurrentOwner
   then
   begin
     NAddrArray[I] := 'OR CURRENT OWNER';
     I := I + 1;
   end;

   If (Deblank(Address1) <> '')
     then
       begin
         NAddrArray[I] := Address1;
         I := I + 1;
       end;

   If (Deblank(Address2) <> '')
     then
       begin
         NAddrArray[I] := Address2;
         I := I + 1;
       end;

   If (Deblank(Street) <> '')
     then
       begin
         NAddrArray[I] := Street;
         I := I + 1;
       end;

     {FXX05191998-4: Don't print the comma between city and state if city
                     is blank or the dash between zip and plus 4 if the
                     zip or plus 4 is blank.}

   If (Deblank(City) <> '')
     then
       begin
         TempStr := RTrim(City);

           {FXX08182003-1(2.07h): If there is a comma at the end of the city, don't add another one.}

         AddComma := not (City[Length(City)] = ',');

         If (Deblank(State) <> '')
           then
             begin
               If AddComma
                 then TempStr := TempStr + ',';

                TempStr := TempStr + ' ' + RTrim(State);

             end;  {If (Deblank(State) <> '')}

       end  {If (Deblank(City).Text <> ')}
     else TempStr := RTrim(State);

     {Blank space before zip.}

   If (Deblank(TempStr) <> '')
     then TempStr := TempStr + ' ';

   FullZipCode := '';
   IncludeZipOnCityStateLine := True;

   If (Deblank(Zip) <> '')
     then
       begin
         FullZipCode := RTrim(Zip);

         If (IncludeZipPlus4 and
             (Deblank(ZipPlus4) <> ''))
           then FullZipCode := FullZipCode + '-' + RTrim(ZipPlus4);

           {FXX03202005-1(2.8.3.12)[2082]: If the city, state, zip, zip + 4 line exceeds 30 characters,
                                           move the zip code to the next line (unless we are already on
                                           the 6th line in which case we will omit the zip+4.}

         If (Length(TempStr + FullZipCode) > 30)
           then
             If (I = 6)
               then FullZipCode := RTrim(Zip)
               else IncludeZipOnCityStateLine := False;

       end;  {If (Deblank(Zip) <> ')}

   If IncludeZipOnCityStateLine
     then TempStr := TempStr + FullZipCode;

     {FXX05201998-2: Need to add city and zip to name addr array.}

   If (Deblank(TempStr) <> '')
     then
       begin
         NAddrArray[I] := TempStr;
         I := I + 1;
       end;

  If (_Compare(FullZipCode, coNotBlank) and
      (not IncludeZipOnCityStateLine) and
      (I <= 6))
    then NAddrArray[I] := ConstStr(' ', 7) + FullZipCode;

end;  {FillInNameAddrArray}

{=================================================================================}
Procedure GetNameAddress(    Table : TTable;
                         var NAddrArray : NameAddrArray);

{Given a parcel in the parcel table, return the name and address in an array.}

begin
  with Table do
    FillInNameAddrArray(FieldByName('Name1').Text,
                        FieldByName('Name2').Text,
                        FieldByName('Address1').Text,
                        FieldByName('Address2').Text,
                        FieldByName('Street').Text,
                        FieldByName('City').Text,
                        FieldByName('State').Text,
                        FieldByName('Zip').Text,
                        FieldByName('ZipPlus4').Text,
                        True, False,
                        NAddrArray);

end;  {GetNameAddress}

{=================================================================================}
Procedure GetNameAddress_OrCurrentOwner(    Table : TTable;
                                        var NAddrArray : NameAddrArray);

{Given a parcel in the parcel table, return the name and address in an array.}

begin
  with Table do
    FillInNameAddrArray(FieldByName('Name1').Text,
                        FieldByName('Name2').Text,
                        FieldByName('Address1').Text,
                        FieldByName('Address2').Text,
                        FieldByName('Street').Text,
                        FieldByName('City').Text,
                        FieldByName('State').Text,
                        FieldByName('Zip').Text,
                        FieldByName('ZipPlus4').Text,
                        True, True,
                        NAddrArray);

end;  {GetNameAddress_OrCurrentOwner}

{======================================================================================}
Procedure PrintLetterHeader(Sender : TObject;
                            AssessorOfficeTable : TTable;
                            ParcelNAddrArray : NameAddrArray;
                            PrintLetterHead : Boolean;
                            PrintedDate : TDateTime;
                            PrintNameAddress : Boolean);

{Print the letter head on a letter.}

var
 I : Integer;
 NAddrArray : NameAddrArray;

begin
  with Sender as TBaseReport do
    begin
      SectionTop := 0.25;
      SectionLeft := 0.5;
      SectionRight := PageWidth - 0.5;
      SetFont('Times New Roman', 12);

      Underline := False;
      Bold := True;

        {FXX06181999-7: Reacess the assessor's office file in case they made
                        any changes while letter job was up.}

      AssessorOfficeTable.First;

      If PrintLetterHead
        then
          begin
              {PRINT LETTER HEAD FROM ASSESSOR OFFICE TABLE}
            For I := 1 to 6 do
              NAddrArray[I] := Take(30,' ');

            I := 1;

            with AssessorOfficeTable do
              begin
                If (Deblank(FieldByName('Address1').Text) <> '')
                  then
                    begin
                      NAddrArray[I] := FieldByName('Address1').Text;
                      I := I + 1;
                    end;

                If (Deblank(FieldByName('Address2').Text) <> '')
                  then
                    begin
                      NAddrArray[I] := FieldByName('Address2').Text;
                      I := I + 1;
                    end;

                If (Deblank(FieldByName('Address3').Text) <> '')
                  then
                    begin
                      NAddrArray[I] := FieldByName('Address3').Text;
                      I := I + 1;
                    end;

                NAddrArray[I] := RTrim(FieldByName('City').Text) +', ' +
                                 FieldByName('State').Text +' ' +
                                 FieldByName('Zip').Text;

                     {CHG12011997-1: Add the phone number to the header.}

                I := I + 1;

                NAddrArray[I] := FieldByName('Phone').Text;

                Home;
                PrintCenter(UpcaseStr(GetMunicipalityName), (PageWidth / 2));
                CRLF;

                For I := 1 to 5 do
                  begin
                    PrintCenter(NAddrArray[I], (PageWidth / 2));
                    CRLF;
                  end;

              end;  {with AssessorOfficeTable do}
            end
          else GotoXY(1.0, AssessorOfficeTable.FieldByName('LetterheadHeight').AsFloat);

      CRLF;
      CRLF;

        {CHG10141998-2: Allow the user to select the printed date.}

      PrintRight('Date: ' + DateToStr(PrintedDate), 6.5);

      CRLF;
      SetPen(clBlack, psSolid, 1, pmCopy); { Set pen to 1 dot width }
      SetFont('Times New Roman', 12);
      Bold := True;
      Println('');

        {Now print the address.}

      If PrintNameAddress
        then
          begin
            ClearTabs;
            SetTab(1.0, pjLeft, 3.5, 0, BOXLINENONE, 0);   {letter addr}

             {FXX05021999-1: Place on page where to start address for windowed
                             envelope.}

            GotoXY(1.0, GlblLetterAddressStart);

            For I := 1 to 6 do
              Println(#9 + ParcelNAddrArray[I]);

            CRLF;
            CRLF;

          end;  {If PrintNameAddress}

    end;  {with Sender as TBaseReport do}

end;  {PrintLetterHeader}

{======================================================================}
Procedure PrintTextReport(    Sender : TObject;
                          var ReportTextFile : TextFile;
                              StartPage,
                              EndPage : Integer);

{CHG12211998-1: Add ability to select print range.}

var
  TempStr : String;
  PageNum : LongInt;
  Done, PrintAllPages : Boolean;

begin
  Done := False;
  PageNum := 1;
  PrintAllPages := False;

    {FXX10041999-3: Show progress during reprint.}

  ReprintingReportForm.ScanningPageNumLabel.Caption := '';
  ReprintingReportForm.PrintingPageNumLabel.Caption := '';
  ReprintingReportForm.Show;
  Application.ProcessMessages;

  If (EndPage = 0)
    then PrintAllPages := True;

    {FXX10141998-1: Move set forn name and size for wide carriage reports to here since if it is
                    in AssignPrinterSettings in WINUTILS, the Canvas is not yet active.}

  with Sender as TBaseReport do
    begin
      If ((Orientation = poLandscape) or  {Wide carriage or}
          (Pos('Filer', Name) > 0))  {To screen}
        then
          begin
            FontName := 'Courier New';
            FontSize := 12;

              {FXX12071998-10: Set a section top and use a tab for the left side so
                               doesn't get cut off on left.}

            SectionTop := GlblReportReprintSectionTop;  {Was 0.8}
(*            MarginLeft := 0.3;  {0.1 for Print Laser Wide}*)
          end;

      OriginX := 0;
      OriginY := 0;
      ClearTabs;

        {FXX04161999-3: Set left margin farther over - some printers were chopping off
                        left side (Barbara's 850c).}
        {FXX11122003-1(2.07k): Allow the user to adjust the left margin on the report reprint.}

      SetTab(GlblReportReprintLeftMargin, pjLeft, 13.0, 0, BoxLineNone, 0);  {0.1 for Print Laser Wide}

    end;  {with Sender as TBaseReport do}

  repeat
    Readln(ReportTextFile, TempStr);

    with Sender as TBaseReport do
      If (TempStr[1] = #12)
        then
          begin
            (*ProgressDialog.UserLabelCaption := 'Printing page ' +
                                               IntToStr(PageNum) + '.';*)
            ReprintingReportForm.ScanningPageNumLabel.Caption := IntToStr(PageNum);

            Delete(TempStr, 1, 1);  {FXX06181998-1 prevent extra form feeds}
            If (TempStr = '')
              then TempStr := ' ';

            PageNum := PageNum + 1;


              {FXX09071999-7: Don't need to do page counting here - see
                              AssignPrinterSettings for direct setting.}
              {FXX02181999-1: Not issuing a form feed before the last page in the range.}
              {FXX02152000-1: Blank page at end.}

(*            If (PrintAllPages or
                ((PageNum > StartPage) and
                 (PageNum <= EndPage)))
              then
                begin *)

              If not EOF(ReportTextFile)
                then NewPage;

                    {FXX1221998-2: make sure the settings are repeated on each page.}

                  If ((Orientation = poLandscape) or  {Wide carriage or}
                      (Pos('Filer', Name) > 0))  {To screen}
                    then
                      begin
                        FontName := 'Courier New';
                        FontSize := 12;

                          {FXX12071998-10: Set a section top and use a tab for the left side so
                                           doesn't get cut off on left.}

                        SectionTop := GlblReportReprintSectionTop;  {Was 0.8}
                        (*MarginLeft := 0.3;  {0.1 for Print Laser Wide} *)
                      end;

                    {FXX11122003-1(2.07k): Allow the user to adjust the left margin on the report reprint.}

                  ClearTabs;
                  SetTab(GlblReportReprintLeftMargin, pjLeft, 13.0, 0, BoxLineNone, 0);  {0.1 for Print Laser Wide}

(*                end;  {If (PrintAllPages or ...} *)

          end;

    If (PrintAllPages or
        ((PageNum >= StartPage) and
         (PageNum <= EndPage)))
      then ReprintingReportForm.PrintingPageNumLabel.Caption := IntToStr(PageNum);

    Application.ProcessMessages;

    with Sender as TBaseReport do
      If (Orientation = poLandscape)
        then Println(#9 + TempStr)
        else TextPrintln(Sender, TempStr);

    If (EOF(ReportTextFile) or
        ((not PrintAllPages) and
         (PageNum > EndPage)))
      then Done := True;

  until Done;

  ReprintingReportForm.Close;

end;  {PrintTextReport}

{========================================================================}
Function PropertyClassIsResidential(PropertyClassCode : String;
                                    OwnershipCode : String) : Boolean;

{Note that this is different from ParcelIsResidential which determines
 residential status according to the Assessor's Report.}

begin
  Result := False;

  If ((PropertyClassCode[1] = '2') and
      (Deblank(OwnershipCode) = ''))
    then Result := True;

    {CHG08082002-1: Allow them to select in a system option whether
                    or not residential vacant land uses the RAR for
                    full market value.}

  If (GlblUseRARForResVacantLand and
      ((PropertyClassCode = '310') or
       (PropertyClassCode = '311') or
       (PropertyClassCode = '312') or
       (PropertyClassCode = '313') or
       (PropertyClassCode = '314') or
       (PropertyClassCode = '315') or
       (PropertyClassCode = '316') or
       (PropertyClassCode = '317') or
       (PropertyClassCode = '320') or
       (PropertyClassCode = '321') or
       (PropertyClassCode = '322') or
       (PropertyClassCode = '323')))
    then Result := True;

    {FXX03012006-2(2.9.5.6): 411C counts as residential, too.}
    {CHG04252007-1(2.11.1.26): According to Phil, John, and RPTL, use eq rate for condos.}

(*  If (_Compare(PropertyClassCode, '411', coEqual) and
      _Compare(OwnershipCode, ownCondominium, coEqual))
    then Result := True;  *)

end;  {PropertyClassIsResidential}

{=========================================================================}
Function ParcelUsesRAR(PropertyClassCode,
                       OwnershipCode : String) : Boolean;

begin
  Result := (GlblUseRAR and
             PropertyClassIsResidential(PropertyClassCode,
                                        OwnershipCode));
end;  {ParcelUsesRAR}

{=========================================================================}
Function GetUniformPercentOrRAR(    SwisCodeTable : TTable;
                                    PropertyClassCode,
                                    OwnershipCode : String;
                                    UseUniformPercentOverride : Boolean;
                                var IsUniformPercent : Boolean) : Double;

{If this municipality uses both RAR and uniform % and wants to show full market
 using the two percents, figure out which to use.}

var
  UniformPercentValue, RAR : Double;

begin
  UniformPercentValue := SwisCodeTable.FieldByName('UniformPercentValue').AsFloat;
  RAR := SwisCodeTable.FieldByName('ResAssmntRatio').AsFloat;
  IsUniformPercent := False;

  If (GlblUseRAR and
      PropertyClassIsResidential(PropertyClassCode,
                                 OwnershipCode) and
      (not UseUniformPercentOverride) and
      (Roundoff(RAR, 2) > 0))
    then Result := RAR
    else
      begin
        Result := UniformPercentValue;
        IsUniformPercent := True;
      end;

end;  {GetUniformPercentOrRAR}

{=========================================================================}
Function ComputeFullValue(AssessedValue : Comp;
                          SwisCodeTable : TTable;
                          PropertyClassCode,
                          OwnershipCode : String;
                          UseUniformPercentOverride : Boolean) : Comp; overload;

{UseUniformPercentOverride means that the uniform % should be used to compute
 the full market value even if they normally want to use the RAR for residential
 parcels.}

var
  TempDivisor : Double;
  IsUniformPercent : Boolean;

begin
  TempDivisor := GetUniformPercentOrRAR(SwisCodeTable,
                                        PropertyClassCode,
                                        OwnershipCode,
                                        UseUniformPercentOverride,
                                        IsUniformPercent);

  If _Compare(TempDivisor, 0, coEqual)
    then Result := 0
    else
      try
        Result := Trunc(AssessedValue / (TempDivisor / 100));
      except
        Result := 0;
      end;

end;  {ComputeFullValue}

{=========================================================================}
Function ComputeFullValue(iAssessedValue : LongInt;
                          fUniformatPercent : Double) : LongInt; Overload;

begin
  If _Compare(fUniformatPercent, 0, coEqual)
    then Result := 0
    else
      try
        Result := Trunc(iAssessedValue / (fUniformatPercent / 100));
      except
        Result := 0;
      end;

end;  {ComputeFullValue}

{===================================================================}
Function ComputeTaxLevyPercentChange(CurrentTaxLevy,
                                     PriorTaxLevy : Comp) : Double;

begin
  If (Roundoff(PriorTaxLevy, 0) = 0)
    then Result := 0
    else
      try
        Result := ((CurrentTaxLevy - PriorTaxLevy) / PriorTaxLevy) * 100;
      except
        Result := 0;
      end;

end;  {ComputeTaxLevyPercentChange}

{========================================================================}
Procedure PrintSelectedList(Sender : TObject;
                            SelectedList : TStringList;
                            Header : String);

var
  ItemLength, Index, J, NumPerLine : Integer;

begin
  with Sender as TBaseReport do
    begin
      ItemLength := Length(Trim(SelectedList[0]));
      NumPerLine := (75 - Length(Header) - 11) DIV (ItemLength + 1);

      Print(#9 + 'Selected ' + Header + ': ');

      Index := 0;
      For J := 0 to (SelectedList.Count - 1) do
        begin
          If ((Index + 1) > NumPerLine)
            then
              begin
                Println('');
                Print(#9 + Take(11 + Length(Header), ''));
                Index := 0;
              end;

          Print(SelectedList[J] + ' ');

          Index := Index + 1;

        end;  {For J := 0 to (SelectedList.Count - 1) do}

      Println('');

    end;  {with Sender as TBaseReport do}

end;  {PrintSelectedList}

{=====================================================================}
Procedure SetGlobalUserDefaults(UserProfileTable : TTable);

{FXX11211997-5: Make sure that all global user preferences get set at
                initial login and re-login by using a common routine.}

begin
  with UserProfileTable do
    begin
      GlblUserName := Take(10, FieldByName('UserID').Text);
      Application.ShowHint := FieldByName('ShowHints').AsBoolean;
      GlblAskSave := FieldByName('AskSaveOnParcelPage').AsBoolean;
      GlblInterleaveTabs := FieldByName('InterleaveParcelTabs').AsBoolean;
      GlblSecurityLevel := FieldByName('SecurityLevel').AsInteger;
      GlblThisYearAccess := FieldByName('ThisYearAccess').AsInteger;
      GlblNextYearAccess := FieldByName('NextYearAccess').AsInteger;
      GlblHistoryAccess  := FieldByName('HistoryAccess').AsBoolean;
      GlblNotesPurgeDefault := FieldByName('NotesPurgableDefault').AsBoolean;
      GlblDefaultSwisCode := FieldByName('DefaultSwisCode').Text;
      GlblConfirmOnExit := FieldByName('ConfirmOnExit').AsBoolean;
      GlblDefaultPreviewZoomPercent := 100;

        {CHG10131997-1: Make the starting parcel page a user option.}

      If (FieldByName('StartingParcelPage').AsInteger > 0)
        then GlblFirstParcelPageShown := FieldByName('StartingParcelPage').AsInteger
        else GlblFirstParcelPageShown := SummaryFormNumber;

      GlblUserIsSearcher := FieldByName('Searcher').AsBoolean;

        {CHG10121998-1: Add user options for default destination and show vet max msg.}

      GlblPrintToScreenDefault := FieldByName('PrintToScreenDefault').AsBoolean;
      GlblShowVetMaxMessage := FieldByName('ShowVetMaxMessage').AsBoolean;

        {CHG12011998-1: Allow user ID's that only allow name and addr changes on pg 1.}

      GlblNameAddressUpdateOnly := FieldByName('NameAddrUpdateOnly').AsBoolean;

        {CHG12081999-1: Option to prompt if legal paper is required.}

      GlblRemindForLegalPaper := FieldByName('RemindForWidePrint').AsBoolean;

      GlblSearchReportDefaultParcelType := FieldByName('DefaultSrchPrclType').AsInteger;

      GlblUserSeesReportDialog := FieldByName('ShowRptDialog').AsBoolean;

        {CHG09162001-1: New security option to not allow value changes.}

      GlblUserCanMakeValueChanges := FieldByName('CanDoValueChanges').AsBoolean;

        {CHG12072001-1: Parcel toolbar.}

      GlblUserWantsParcelToolbar := FieldByName('UseParcelToolbar').AsBoolean;

      GlblShowAVChangeBox := FieldByName('ShowAVChangeAmount').AsBoolean;

      GlblShowParcelYearFlipMenuItem := FieldByName('AllowParcelYearSwitch').AsBoolean;

      try
        GlblCertiorariOnly := FieldByName('CertiorariOnly').AsBoolean;
      except
        GlblCertiorariOnly := False;
      end;

        {CHG12202002-1: Additional security for certs.}

      try
        GlblCanSeeCertiorari := FieldByName('CanSeeCertiorari').AsBoolean;
      except
        GlblCanSeeCertiorari := False;
      end;

      try
        GlblCanSeeCertNotes := FieldByName('CanSeeCertNotes').AsBoolean;
      except
        GlblCanSeeCertNotes := False;
      end;

      try
        GlblCanSeeCertAppraisals := FieldByName('CanSeeCertAppraisals').AsBoolean;
      except
        GlblCanSeeCertAppraisals := False;
      end;

        {CHG01082003-1: Allow for a different default on the parcel view, too.}

      try
        GlblDefaultParcelViewPage := FieldByName('StartingViewPage').AsInteger;
      except
        GlblDefaultParcelViewPage := SummaryFormNumber;
      end;

      If (GlblDefaultParcelViewPage = 0)
        then GlblDefaultParcelViewPage := SummaryFormNumber;

        {CHG05142003-1(2.07a): Use of TForm Print screen is now a user option.}

      try
        GlblUseTFormPrint := FieldByName('UseTFormScreenPrint').AsBoolean;
      except
        GlblUseTFormPrint := False;
      end;

        {CHG03222004-2(2.08): Option to prevent user from changing exemptions.}

      try
        GlblUserCannotChangeExemptions := FieldByName('UserCannotChangeExemptions').AsBoolean;
      except
        GlblUserCannotChangeExemptions := False;
      end;

        {CHG03232004-5(2.08): Private notes feature.}

      try
        GlblUserCanEnterAndViewPrivateNotes := FieldByName('UsesPrivateNotes').AsBoolean;
      except
        GlblUserCanEnterAndViewPrivateNotes := False;
      end;

        {FXX04182004-1(2.08): Make it so that this is a user option.}

      try
        GlblSkipUnusedSalesFields := FieldByName('SkipUnusedSalesFields').AsBoolean;
      except
        GlblSkipUnusedSalesFields := False;
      end;

      try
        GlblNextSalesFieldAfterCondition := FieldByName('NextSalesFieldAfterCond').AsInteger;
      except
        GlblNextSalesFieldAfterCondition := nsfDefault;
      end;

      try
        GlblParcelLocateDefault := FieldByName('DefaultLocateMethod').AsInteger;
      except
        GlblParcelLocateDefault := pldParcelID;
      end;

      try
        GlblUser_Restricted_To_Name_Addr_Change_Can_Change_Owner := FieldByName('CanChangeOwnerOverride').AsBoolean;
      except
        GlblUser_Restricted_To_Name_Addr_Change_Can_Change_Owner := False;
      end;

      try
        GlblUser_BankCodeUpdateOnly := FieldByName('BankCodeChangesOnly').AsBoolean;
      except
        GlblUser_BankCodeUpdateOnly := False;
      end;

      try
        GlblPrintScreenMethod := FieldByName('PrintScreenMethod').AsInteger;
      except
        GlblPrintScreenMethod := psNormal;
      end;

      try
        GlblUserCantDeleteExemptions := FieldByName('UserCantDeleteExemptions').AsBoolean;
      except
        GlblUserCantDeleteExemptions := False;
      end;

      try
        GlblUserCanViewPermits := FieldByName('UserCanViewPermits').AsBoolean;
      except
        GlblUserCanViewPermits := False;
      end;

      try
        glblSuppressPrintSizePrompts := FieldByName('SuppressPrintSizePrompts').AsBoolean;
      except
        glblSuppressPrintSizePrompts := False;
      end;

      try
        glblAutoDuplex := FieldByName('AutoDuplex').AsBoolean;
      except
        glblAutoDuplex := False;
      end;

      try
        glblAutoVerticalDuplex := FieldByName('AutoVerticalDuplex').AsBoolean;
      except
        glblAutoVerticalDuplex := False;
      end;

      try
        glblShowSketchWithComments := FieldByName('ShowSketchWithComments').AsBoolean;
      except
        glblShowSketchWithComments := False;
      end;

    end;  {with UserProfileTable do}

end;  {SetGlobalUserDefaults}

{========================================================}
Procedure SetGlobalSystemVariables(SysRecTable : TTable);

{FXX02091999-2: Move the setting of global system vars to
                one proc.}

begin
  with SysRecTable do
    begin
      {set up memory globals for rest of PAS system from System Record}
      GlblDrive := FieldByName('DriveLetter').Text;

      GlblDataDir := FieldByName('SysDataDir').AsString;
      GlblDataDir := AddDirectorySlashes(GlblDataDir);

      GlblErrorFileDir := FieldByName('SysSCAErrorFileDir').AsString;
      GlblErrorFileDir := AddDirectorySlashes(GlblErrorFileDir);

      GlblProgramDir := FieldByName('SysProgramDir').AsString;
      GlblProgramDir := AddDirectorySlashes(GlblProgramDir);

      GlblRPSDataDir := '\PASYSTEM\RPSDATA\';  {Hard coded for now.}
      GlblExportDir := FieldByName('ExportDir').Text;
      GlblExportDir := AddDirectorySlashes(GlblExportDir);

      GlblReportDir := FieldByName('SysReportDir').AsString;
      GlblReportDir := AddDirectorySlashes(GlblReportDir);

      GlblListDir := FieldByName('ListDir').Text;

      GlblThisYear := FieldByName('SysThisYear').AsString;
      GlblNextYear := FieldByName('SysNextYear').AsString;

      GlblVersion := '2.29.1.17';
      GlblMunicipalityType := FieldByName('MunicipalityType').AsInteger;
      GlblCountyName := FieldByName('CountyName').Text;

        {FXX04161999-6: Don't go on county name for Westchester logic since
                        some towns in Westchester do not use it.}

      GlblIsWestchesterCounty := FieldByName('UseWestchesterLogic').AsBoolean;
      GlblMunicipalityName := FieldByName('SysMunicipalityName').Text;
      GlblMunicipalityUsesTwoTaxRates := FieldByName('UsesTwoTaxRates').AsBoolean;                                                                        
      GlblSalesControlNumberRequired := FieldByName('SalesCtlNumRequired').AsBoolean;

        {CHG05011998-2: Add bldg permits.}

(*      GlblShowPermitForms := FieldByName('ShowPermitForms').AsBoolean;*)

        {FXX02061998-5: Allow the automatic addition of enhanced STAR exemptions
                        when a senior exemption is added be a municipality
                        decision.}

      GlblAutomaticallyAddEnhancedSTARExemptions := FieldByName('AutoEnhSTARAdd').AsBoolean;

      GlblSalesApplyToThisYear := FieldByName('SalesOnThisYear').AsBoolean;

        {FXX04231998-8: Add global var to see if municipality is classified.}

      GlblMunicipalityIsClassified := FieldByName('Classified').AsBoolean;

        {FXX12291998-2: LB does not use override amounts for condos and we must calc
                        amount.}

      GlblAllowCondoExemptionOverride := FieldByName('CondoEXOverride').AsBoolean;

      GlblModifyBothYearsCheckedInTY := FieldByName('ChangeTogetherDef').AsBoolean;

      GlblWarnIfAddEnhancedSTARWithoutSenior := FieldByName('WarnForSTARnoSnr').AsBoolean;

        {FXX04161999-5: Allow people to modify other's notes if they want.}

      GlblModifyOthersNotes := FieldByName('ModifyOthersNotes').AsBoolean;

        {CHG06101999-1: Use mailing addr fields a la Mt. Vernon.}

      GlblUseMailingAddrFields := FieldByName('UseMailAddrFields').AsBoolean;

      GlblReportOptionsDir := FieldByName('ReportOptionsDir').Text;

        {FXX06141999-2: Allow users to see warnings on a parcel right away.}

      GlblShowParcelWarnings := FieldByName('ParcelWarnings').AsBoolean;

        {CHG06291999-1: Keep the searcher from seeing next year values.}

      SearcherCanSeeNYValues := FieldByName('SearcherCanViewNY').AsBoolean;

        {CHG07191999-1: Allow municipality to choose which deed type is default.}

      GlblDefaultDeedType := FieldByName('DefaultDeedType').Text;

        {FXX08031999-2: Option to not enforce measurement restrictions.}

      GlblEnforceMeasurementRestrictions := FieldByName('EnforceMeasRestric').AsBoolean;

        {CHG09021999-1: Save sales transmittals in a directory for history.}

      GlblSavedSalesDir := AddDirectorySlashes(FieldByName('SavedSalesDir').Text);

        {CHG01182000-1: Option to not have searcher see exemption denials.}
        {CHG01182000-2: Allow users to click off the owner change button.}
        {FXX01182000-1: Need a default picture directory.}

      GlblSearcherViewsDenials := FieldByName('EXDenialForSearcher').AsBoolean;
      GlblCanTurnOffOwnerChangeFlag := FieldByName('TurnOffOwnerChange').AsBoolean;
      GlblPictureDir := AddDirectorySlashes(FieldByName('PictureDir').Text);
      GlblDocumentDir := AddDirectorySlashes(FieldByName('DocumentDir').Text);

      GlblLocateByOldParcelID := FieldByName('LookupByOldSBL').AsBoolean;
      GlblUseOldParcelIDsForSales := FieldByName('UseOldIDsForSales').AsBoolean;
      GlblUseTransactions := FieldByName('UseLocking').AsBoolean;

      GlblAutoDetectNewPictures := FieldByName('AutoDetectNewPictures').AsBoolean;
      GlblAutoDetectNewDocuments := FieldByName('AutoDetectNewDocuments').AsBoolean;

      GlblAllowAuditAccessToAll := FieldByName('AllowAuditAccessToAll').AsBoolean;

      GlblPasswordProtectSchoolCode := FieldByName('ProtectSchoolCode').AsBoolean;
      GlblSchoolCodeChangePassword := FieldByName('SchoolCodePassword').Text;
      GlblAllowOnlyWhollyExemptsOnVacantLand := FieldByName('VacantLandWhollyEx').AsBoolean;

        {CHG04122001-1(MDT): Record removed exemptions.}

      GlblRecordRemovedExemptions := FieldByName('ShowRemovedExemptions').AsBoolean;

        {CHG04172001-1: Senior percent calculator.}

      GlblUseSeniorExemptionPercentCalculator := FieldByName('CalcSeniorPercents').AsBoolean;

      GlblSearcherOnlySeesSummaryAndPage1 := FieldByName('SrchrSeesSmry_Pg1').AsBoolean;

        {CHG07132001-1: Allow searching subdirectories and picture masks.}

      GlblPictureMask := FieldByName('PictureMask').Text;
      GlblSearchSubfoldersForPictures := FieldByName('SearchSubfoldersForPics').AsBoolean;

      GlblDocumentMask := FieldByName('DocumentMask').Text;
      GlblSearchSubfoldersForDocuments := FieldByName('SearchSubfoldersForDocs').AsBoolean;

(*     GlblMapDirectory := FieldByName('MapDirectory').Text; *)

      GlblRecalculateSFLA := FieldByName('RecalculateSFLA').AsBoolean;
      GlblBuildingSystemLinkType := FieldByName('BuildingSystemType').AsInteger;
      GlblBuildingSystemDatabaseName := FieldByName('BuildingSystemAlias').Text;
      GlblBuildingSystemTableName := FieldByName('BuildingSystemTable').Text;
      GlblBuildingSystemIndexName := FieldByName('BuildingSystemIndex').Text;

        {CHG03112002-1: Allow for suppression of inventory values.}

      GlblShowInventoryValues := FieldByName('ShowInventoryValues').AsBoolean;

      GlblUsesMaps := FieldByName('UsesMaps').AsBoolean;

      GlblUsesGrievances := FieldByName('UsesGrievances').AsBoolean;

      GlblLetterTemplateDir := GlblProgramDir + 'LetterTemplates\';

      GlblUseRAR := FieldByName('UseRARForFullMktVal').AsBoolean;
      GlblShowFullMarketValue := FieldByName('ShowFullMktVal').AsBoolean;
      GlblSearcherCanSeeFullMarketValue := FieldByName('SearcherSeesFullMktVal').AsBoolean;

        {CHG07192002-1: Accomodate a seperate coop roll.}

      try
        GlblIconFileName := FieldByName('IconFileName').Text;
      except
        GlblIconFileName := 'PAS32.ICO';
      end;

      If (Deblank(GlblIconFileName) = '')
        then GlblIconFileName := 'PAS32.ICO';

      try
        GlblCaption := FieldByName('Caption').Text;
      except
        GlblCaption := 'PAS';
      end;

      If (Deblank(GlblCaption) = '')
        then GlblCaption := 'PAS';

      try
        GlblIsCoopRoll := FieldByName('CoopRoll').AsBoolean;
      except
        GlblIsCoopRoll := False;
      end;

      try
        GlblUseRARForResVacantLand := FieldByName('UseRARForResVacantLand').AsBoolean;
      except
        GlblUseRARForResVacantLand := False;
      end;

      try
        GlblFormatSegmentToLength := FieldByName('FormatSegmentToLength').AsBoolean;
      except
        GlblFormatSegmentToLength := False;
      end;

      try
        GlblDontZeroFillBlankSegments := FieldByName('DontZeroFillBlankSegments').AsBoolean;
      except
        GlblDontZeroFillBlankSegments := False;
      end;

      try
        GlblUseRestrictSearcherParcelsFeature := FieldByName('RestrictSearcherParcels').AsBoolean;
      except
        GlblUseRestrictSearcherParcelsFeature := False;
      end;

      try
        GlblSuppressRollTotalsUpdate := FieldByName('SuppressRollTotalsUpdate').AsBoolean;
      except
        GlblSuppressRollTotalsUpdate := False;
      end;

      try
        GlblUseAccountNumberLookup := FieldByName('UseAccountNumberLocate').AsBoolean;
      except
        GlblUseAccountNumberLookup := False;
      end;

      try
        GlblAnyUserCanChangeOpenNoteStatus := FieldByName('AnyUserCanChangeOpenNoteStatus').AsBoolean;
      except
        GlblAnyUserCanChangeOpenNoteStatus := False;
      end;

      try
        GlblNoPartialExemptionsOnRollSection8 := FieldByName('NoPartialEXsOnRS8').AsBoolean;
      except
        GlblNoPartialExemptionsOnRollSection8 := False;
      end;

      try
        GlblSummaryAndPage1ValueInformationIsAlwaysPrior2Years := FieldByName('AlwaysShowPrior2Years').AsBoolean;
      except
        GlblSummaryAndPage1ValueInformationIsAlwaysPrior2Years := False;
      end;

      try
        GlblAllowBankCodeFreeze := FieldByName('AllowBankCodeFreeze').AsBoolean;
      except
        GlblAllowBankCodeFreeze := False;
      end;

      try
        GlblExtractAdditionalLotsIn155File := FieldByName('IncludeAddtlLotsIn155').AsBoolean;
      except
        GlblExtractAdditionalLotsIn155File := False;
      end;

      try
        GlblDefaultToNoSwisRequiredOnParcelIDLookup := FieldByName('DefaultNoSwisRequired').AsBoolean;
      except
        GlblDefaultToNoSwisRequiredOnParcelIDLookup := False;
      end;

      try
        GlblUsesSketches := FieldByName('UsesApex').AsBoolean;
      except
        GlblUsesSketches := False;
      end;

      try
        GlblDefaultApexDir := FieldByName('DefaultApexDir').Text;
      except
        GlblDefaultApexDir := '\pas32\sketch\';
      end;

      try
        GlblDefaultPictureLoadingDockDirectory := FieldByName('DefaultPicLoadingDockDir').Text;
      except
        GlblDefaultPictureLoadingDockDirectory := '\pas32\loadingdock';
      end;

      try
        GlblSearcherMapDefault := FieldByName('SearcherMapDefault').Text;
      except
        GlblSearcherMapDefault := MapSetupDefaultNone;
      end;

      try
        GlblUsesVillage_Import_Export := FieldByName('UsesVillNameAddrImport').AsBoolean;
      except
        GlblUsesVillage_Import_Export := False;
      end;

      try
        GlblVillageHoldingDockFolder := FieldByName('VillImportFolder').Text;
      except
        GlblVillageHoldingDockFolder := '';
      end;

       {CHG01192004-1(2.08): Let each municipality decide what roll totals to display.}

      GlblRollTotalsToShow := [];

      try
        If FieldByName('ShowCountyTaxable').AsBoolean
          then GlblRollTotalsToShow := GlblRollTotalsToShow + [rtdCounty];
      except
      end;

      try
        If FieldByName('ShowMunicipalTaxable').AsBoolean
          then GlblRollTotalsToShow := GlblRollTotalsToShow + [rtdMunicipal];
      except
      end;

      try
        If FieldByName('ShowSchoolTaxable').AsBoolean
          then GlblRollTotalsToShow := GlblRollTotalsToShow + [rtdSchool];
      except
      end;

      try
        If FieldByName('ShowVillOfTownTaxable').AsBoolean
          then GlblRollTotalsToShow := GlblRollTotalsToShow + [rtdVillageReceivingPartialRoll];
      except
      end;

      try
        GlblAV_BalancingFieldUpdates_AV := FieldByName('Eq_Phy_Chg_Updates_AV').AsBoolean;
      except
        GlblAV_BalancingFieldUpdates_AV := False;
      end;

        {CHG03012004-1(2.07l2): Allow for searchers to create selected layers locally.}

      try
        GlblSearcherCreatesSelectedMapLayerLocally := FieldByName('Maps_SrchrLocal').AsBoolean;
      except
        GlblSearcherCreatesSelectedMapLayerLocally := False;
      end;

        {CHG03182004-1(2.08): Allow for prevention of renewals on individual exemptions.
                              Used for volunteer firefighter.}

      try
        GlblCanPreventExemptionRenewal := FieldByName('AllowPreventExRenewal').AsBoolean;
      except
        GlblCanPreventExemptionRenewal := False;
      end;

      try
        GlblUseGeneralizedComparisonReport := FieldByName('UseGeneralComparisonRpt').AsBoolean;
      except
        GlblUseGeneralizedComparisonReport := False;
      end;

        {CHG03232004-5(2.08): Private notes feature.}

      try
        GlblUsePrivateNotes := FieldByName('UsePrivateNotes').AsBoolean;
      except
        GlblUsePrivateNotes := False;
      end;

        {CHG03232004-7(2.08): Link up help.}

      GlblHelpDirectory := GlblProgramDir + 'HELP\';

      try
        GlblGrievanceSeperateRepresentativeInfo := FieldByName('UseGrvAttorneyInfo').AsBoolean;
      except
      end;

      try
        GlblSubtractUnfinishedArea := FieldByName('SubtractUnfinishedArea').AsBoolean;
      except
        GlblSubtractUnfinishedArea := False;
      end;

      try
        GlblAllUsersCreatesSelectedMapLayerLocally := FieldByName('Maps_AllLocal').AsBoolean;
      except
        GlblAllUsersCreatesSelectedMapLayerLocally := False;
      end;

      try
        GlblIncludeFinishedBasementAreaInSFLA := FieldByName('FinBsmntInAllSFLA').AsBoolean;
      except
        GlblIncludeFinishedBasementAreaInSFLA := False;
      end;

      try
        GlblUseControlNumInsteadOfBook_Page := FieldByName('UseControlNumInsteadOfBook_Page').AsBoolean;
      except
        GlblUseControlNumInsteadOfBook_Page := False;
      end;

      try
        GlblHideSalesPersonalProperty := FieldByName('HideSalesPersonalProperty').AsBoolean;
      except
        GlblHideSalesPersonalProperty := False;
      end;

      try
        GlblHideSalesTransmitFields := FieldByName('HideSalesTransmitFields').AsBoolean;
      except
        GlblHideSalesTransmitFields := False;
      end;

      try
        GlblShowUniformPercentInsteadOfSTARAmountOnSummaryScreen := FieldByName('ShowUnifPctInsteadOfSTAR').AsBoolean;
      except
        GlblShowUniformPercentInsteadOfSTARAmountOnSummaryScreen := False;
      end;

      try
        GlblShowAssessmentNotesOnAVHistoryScreen := FieldByName('ShowAVNotesInAVHistScreen').AsBoolean;
      except
        GlblShowAssessmentNotesOnAVHistoryScreen := False;
      end;

      try
        GlblPreventSearcherExit := FieldByName('PreventSearcherExit').AsBoolean;
      except
        GlblPreventSearcherExit := False;
      end;

      try
        GlblAllowBlankDeedDate := FieldByName('AllowBlankDeedDate').AsBoolean;
      except
        GlblAllowBlankDeedDate := False;
      end;

      try
        GlblCustomParcelLocate := FieldByName('CustomParcelLocateGrid').AsBoolean;
      except
        GlblCustomParcelLocate := False;
      end;

      try
        GlblShowExtendedSDAmounts := FieldByName('ShowExtendedSDValue').AsBoolean;
      except
        GlblShowExtendedSDAmounts := False;
      end;

      try
        GlblCloseButtonIsLocate := FieldByName('CloseButtonIsLocate').AsBoolean;
      except
        GlblCloseButtonIsLocate := False;
      end;

      try
        GlblParcelMaint_DisplayAccountNumber := FieldByName('Prcl_DisplayAccountNumber').AsBoolean;
      except
        GlblParcelMaint_DisplayAccountNumber := False;
      end;

      try
        GlblParcelMaint_DisplayOldIDUnconverted := FieldByName('Prcl_DisplayOldParcelID').AsBoolean;
      except
        GlblParcelMaint_DisplayOldIDUnconverted := False;
      end;

      try
        GlblAllowSystemShutdown := FieldByName('AllowSystemShutdown').AsBoolean;
      except
        GlblAllowSystemShutdown := False;
      end;

      try
        GlblShowExemptionDescription := FieldByName('ShowExemptionDescription').AsBoolean;
      except
        GlblShowExemptionDescription := False;
      end;

      try
        GlblShowMortgageOnPage1 := FieldByName('ShowMortgageOnPg1').AsBoolean;
      except
        GlblShowMortgageOnPage1 := False;
      end;

      try
        GlblShowExemptionFilingInformation := FieldByName('ShowEXFilingInfo').AsBoolean;
      except
        GlblShowExemptionFilingInformation := False;
      end;

      try
        GlblUseEnhancedPrintDialog := FieldByName('UseEnhancedPrintDialog').AsBoolean;
      except
        GlblUseEnhancedPrintDialog := False;
      end;

      try
        GlblUse3DecimalsForDimensions := FieldByName('Use3DecimalsForDimensions').AsBoolean;
      except
        GlblUse3DecimalsForDimensions := False;
      end;

      try
        GlblPreventParcelLocateMinimize := FieldByName('PreventParcelLocateMinimize').AsBoolean;
      except
        GlblPreventParcelLocateMinimize := False;
      end;

      try
        GlblUsePrintSuitePrintScreen := FieldByName('UsePrintSuitePrintScreen').AsBoolean;
      except
        GlblUsePrintSuitePrintScreen := False;
      end;

      try
        GlblShowNassauValues := FieldByName('DisplayNassauValues').AsBoolean;
      except
        GlblShowNassauValues := False;
      end;

      try
        GlblShowSpecialDistrictDescriptions := FieldByName('ShowSDDescription').AsBoolean;
      except
        GlblShowSpecialDistrictDescriptions := False;
      end;

      try
        GlblAllowOldSBLEdit := FieldByName('AllowOldSBLEdit').AsBoolean;
      except
        GlblAllowOldSBLEdit := False;
      end;

      try
        GlblMergeValuesDuringMerge := FieldByName('MergeValuesDuringMerge').AsBoolean;
      except
        GlblMergeValuesDuringMerge := False;
      end;

      try
        GlblAllowSBLRenumber := FieldByName('AllowSBLRenumber').AsBoolean;
      except
        GlblAllowSBLRenumber := False;
      end;

      try
        GlblEnableExemptionCapOption := FieldByName('EnableExemptionCapOption').AsBoolean;
      except
        GlblEnableExemptionCapOption := False;
      end;

      try
        GlblUseGlenCoveFormatForCodeEnforcement := FieldByName('GlenCoveBuildingSBLFormat').AsBoolean;
      except
        GlblUseGlenCoveFormatForCodeEnforcement := False;
      end;

      try
        GlblEnablePermanentRetentionFeature := FieldByName('EnablePermanentRetention').AsBoolean;
      except
        GlblEnablePermanentRetentionFeature := False;
      end;

      try
        GlblUseNewBuildingPermitPage := FieldByName('UsesNewBuildingParcelForm').AsBoolean;
      except
        GlblUseNewBuildingPermitPage := False;
      end;

      try
        GlblPrintEstimatedTaxLetters := FieldByName('UsesEstimatedTaxLetters').AsBoolean;
      except
        GlblPrintEstimatedTaxLetters := False;
      end;

      try
        GlblUsesProrata := FieldByName('UsesProrataPackage').AsBoolean;
      except
        GlblUsesProrata := False;
      end;

      try
        GlblUseNewStyleForms := FieldByName('UseNewStyleForms').AsBoolean;
      except
        GlblUseNewStyleForms := False;
      end;

      try
        GlblTreatMixedUseParcelsAsResidential := FieldByName('MixedUseParcelsAreRes').AsBoolean;
      except
        GlblTreatMixedUseParcelsAsResidential := False;
      end;

      try
        GlblUsesPASPermits := FieldByName('UseBuildingPermits').AsBoolean;
      except
        GlblUsesPASPermits := False;
      end;

      try
        GlblDoNotPrintNextYearOnF5 := FieldByName('DontPrintNYOnF5').AsBoolean;
      except
        GlblDoNotPrintNextYearOnF5 := False;
      end;

      try
        GlblLeaveApexActive := FieldByName('LeaveApexActive').AsBoolean;
      except
        GlblLeaveApexActive := False;
      end;

      try
        GlblDefaultPropertyCardDirectory := FieldByName('PropertyCardDir').AsString;
      except
        GlblDefaultPropertyCardDirectory := '';
      end;

      try
        GlblSupressDollarSignsOnAssessments := FieldByName('NoDollarsOnAssessments').AsBoolean;
      except
        GlblSupressDollarSignsOnAssessments := False;
      end;

      try
        GlblAllowLetterPrint := FieldByName('AllowParcelLetterPrint').AsBoolean;
      except
        GlblAllowLetterPrint := False;
      end;

      try
        GlblPropertyCardsArePDF := FieldByName('LoadPDFPropCards').AsBoolean;
      except
        GlblPropertyCardsArePDF := False;
      end;

      try
        GlblCoopBaseSBLHasSubblock := FieldByName('CoopBaseSBLHasSubblock').AsBoolean;
      except
        GlblCoopBaseSBLHasSubblock := False;
      end;

      try
        GlblUsesApexMedina := FieldByName('UsesApexMedina').AsBoolean;
      except
        GlblUsesApexMedina := False;
      end;

      try
        GlblRAVEBillName := FieldByName('RAVEBillName').AsString;
      except
        GlblRAVEBillName := '';
      end;

      try
        glblUsesRAVEBills := FieldByName('UsesRAVEBills').AsBoolean;
      except
        glblUsesRAVEBills := False;
      end;

      try
        glblBillPrintMenuItem1 := FieldByName('BillPrintMenuItem1').AsInteger;
      except
        glblBillPrintMenuItem1 := 0;
      end;

      try
        glblBillPrintMenuItem2 := FieldByName('BillPrintMenuItem2').AsInteger;
      except
        glblBillPrintMenuItem2 := 0;
      end;

      try
        GlblUsesAutoShutdown := FieldByName('UsesAutoShutdown').AsBoolean;
      except
        GlblUsesAutoShutdown := False;
      end;

      GlblCanSeeSmallClaimsNotes := True;

      try
        GlblDetectPicturesByAccountNumber := FieldByName('DetectPicturesByAccountNumber').AsBoolean;
      except
        GlblDetectPicturesByAccountNumber := False;
      end;

      try
        GlblDisplayExemptionDescriptions := FieldByName('DisplayExemptionDescription').AsBoolean;
      except
        GlblDisplayExemptionDescriptions := False;
      end;

      try
        GlblDisplaySpecialDistrictDescriptions := FieldByName('DisplaySpecialDistDescription').AsBoolean;
      except
        GlblDisplaySpecialDistrictDescriptions := False;
      end;

      try
        GlblSuppressDocumentAutoload := FieldByName('SuppressDocumentAutoload').AsBoolean;
      except
        GlblSuppressDocumentAutoload := False;
      end;

      try
        GlblDisplaySplitSchoolSBLs := FieldByName('DisplaySplitSchoolSBLs').AsBoolean;
      except
        GlblDisplaySplitSchoolSBLs := False;
      end;

      try
        GlblDisplaySwisOnPrintKey := FieldByName('DisplaySwisOnPrintKey').AsBoolean;
      except
        GlblDisplaySwisOnPrintKey := False;
      end;

      try
        glblOwnerAddressUpdateFilePath := FieldByName('OwnerAddressUpdateFilePath').AsString;
      except
        glblOwnerAddressUpdateFilePath := 'OwnerAddressUpdateFilePath';
      end;

      try
        glblCountyCollectionType := FieldByName('CountyCollectionType').AsString;
      except
        glblCountyCollectionType := '';
      end;

      try
        glblCountyCollectionNumber := FieldByName('CountyCollectionNumber').AsString;
      except
        glblCountyCollectionNumber := '1';
      end;

      try
        glblCountyBaseTaxRatePointer := FieldByName('CountyBaseTaxRatePointer').AsString;
      except
        glblCountyBaseTaxRatePointer := '';
      end;

      try
        glblSCARFormTemplateFileName := FieldByName('SCARInfoFormFileName').AsString;
      except
        glblSCARFormTemplateFileName := '';
      end;

      try
        glblCountyTaxDatabaseName := FieldByName('CountyTaxDatabaseName').AsString;
      except
        glblCountyTaxDatabaseName := '';
      end;

      try
        glblPrintSmallClaimsRebateForms := FieldByName('UsesSCARInfoForms').AsBoolean;
      except
        glblPrintSmallClaimsRebateForms := False;
      end;

      try
        glblDisplayAccountNumberOnCard := FieldByName('DisplayAcctNumOnCard').AsBoolean;
      except
        glblDisplayAccountNumberOnCard := False;
      end;

      try
        glblShowHistoryOfOwners := FieldByName('ShowHistoryOfOwners').AsBoolean;
      except
        glblShowHistoryOfOwners := False;
      end;

      try
        glblShowNewOwnerOnSummaryTab := FieldByName('ShowNewOwnerOnSummaryTab').AsBoolean;
      except
        glblShowNewOwnerOnSummaryTab := False;
      end;

      try
        glblSuppressIVP := FieldByName('SuppressIVP').AsBoolean;
      except
        glblSuppressIVP := False;
      end;

      try
        glblShowImprovementValue := FieldByName('ShowImprovementValue').AsBoolean;
      except
        glblShowImprovementValue := False;
      end;

      try
        glblAutoUpdateNamesAddrs := FieldByName('AutoUpdateNamesAddrs').AsBoolean;
      except
        glblAutoUpdateNamesAddrs := False;
      end;

      try
        glblDatabaseToUpdateNameAddrs1 := FieldByName('DatabaseToUpdateNameAddrs1').AsString;
      except
        glblDatabaseToUpdateNameAddrs1 := '';
      end;

      try
        glblDatabaseToUpdateNameAddrs2 := FieldByName('DatabaseToUpdateNameAddrs2').AsString;
      except
        glblDatabaseToUpdateNameAddrs2 := '';
      end;

      try
        glblDatabaseToUpdateNameAddrs3 := FieldByName('DatabaseToUpdateNameAddrs3').AsString;
      except
        glblDatabaseToUpdateNameAddrs3 := '';
      end;

      try
        glblAlwaysShowMostCurrentSaleOnSalesPage := FieldByName('AlwaysShowMostCurrentSale').AsBoolean;
      except
        glblAlwaysShowMostCurrentSaleOnSalesPage := False;
      end;

      try
        glblAutoCalcRollTotalsBeforePrint := FieldByName('AutoCalcRollTotalsBeforePrint').AsBoolean;
      except
        glblAutoCalcRollTotalsBeforePrint := False;
      end;

      try
        glblUseNewOwnerProgressionForm := FieldByName('UseNewOwnerProgressionForm').AsBoolean;
      except
        glblUseNewOwnerProgressionForm := False;
      end;

      try
        glblDisplaySuppressFromGIS := FieldByName('DisplaySuppressFromGIS').AsBoolean;
      except
        glblDisplaySuppressFromGIS := False;
      end;

      try
        glblUseWindowsSaveDlgForReports := FieldByName('UseWindowsSaveDlgForReports').AsBoolean;
      except
        glblUseWindowsSaveDlgForReports := False;
      end;

      try
        glblTracePictureAccess := FieldByName('TracePictureAccess').AsBoolean;
      except
        glblTracePictureAccess := False;
      end;

      try
        glblUnfinRoomIsUnfinBsmt := FieldByName('UnfinRoomIsUnfinBsmt').AsBoolean;
      except
        glblUnfinRoomIsUnfinBsmt := False;
      end;

      try
        glblUsesSQLTax := FieldByName('UsesSQLTax').AsBoolean;
      except
        glblUsesSQLTax := False;
      end;

      try
        glblShowSTARSavingsOnExemptionPage := FieldByName('ShowSTARSavingsOnEXPage').AsBoolean;
      except
        glblShowSTARSavingsOnExemptionPage := False;
      end;

      try
        glblUsesPictometry := FieldByName('UsesPictometry').AsBoolean;
      except
        glblUsesPictometry := False;
      end;

      try
        glblPreventPASStartup := FieldByName('PreventPASStartup').AsBoolean;
      except
        glblPreventPASStartup := False;
      end;

      try
        glblSmallClaimsDefaultYear := FieldByName('SmallClaimsDefaultYear').AsString;
      except
        glblSmallClaimsDefaultYear := glblThisYear;
      end;

      try
        glblUsesPictometry_FullSBL := FieldByName('UsesPictometry_FullSBL').AsBoolean;
      except
        glblUsesPictometry_FullSBL := False;
      end;

      try
        glblFreezeAssessmentDueToGrievance := FieldByName('FreezeAVForGrievance').AsBoolean;
      except
        glblFreezeAssessmentDueToGrievance := False;
      end;

      try
        glblAllowSalesInventoryEdit := FieldByName('AllowSalesInventoryEdit').AsBoolean;
      except
        glblAllowSalesInventoryEdit :=  False;
      end;

      If GlblIsWestchesterCounty
      then
      begin
        GlblAssessmentYearIsSameAsTaxYearForCounty := False;
        GlblAssessmentYearIsSameAsTaxYearForMunicipal := False;
        GlblAssessmentYearIsSameAsTaxYearForSchool := False;
      end
      else
      begin
        GlblAssessmentYearIsSameAsTaxYearForCounty := True;
        GlblAssessmentYearIsSameAsTaxYearForMunicipal := True;
        GlblAssessmentYearIsSameAsTaxYearForSchool := True;
      end;

      try
        glblUsesPictometry_OldPrintKey := FieldByName('UsesPictometry_OldPrintKey').AsBoolean;
      except
        glblUsesPictometry_OldPrintKey := False;
      end;

      try
        glblRemapOldSBLHasSwis := FieldByName('RemapOldSBLHasSwis').AsBoolean;
      except
        glblRemapOldSBLHasSwis := False;
      end;

      try
        glblUseExactPrintKey := FieldByName('UseExactPrintKey').AsBoolean;
      except
        glblUseExactPrintKey := False;
      end;

      try
        glblLocateDisplaysPrintKey := FieldByName('DisplayPrintKey').AsBoolean;
      except
        glblLocateDisplaysPrintKey := False;
      end;

      try
        glblToolbarLaunchesGIS := FieldByName('ToolbarLaunchesGIS').AsBoolean;
      except
        glblToolbarLaunchesGIS := False;
      end;

      try
        glblInvDisplaysZoningCode := FieldByName('ZoningDropdownIsCode').AsBoolean;
      except
        glblInvDisplaysZoningCode := False;
      end;

      try
        glblDisplaySchoolShortCodeInSummary := FieldByName('SummarySchoolShortCode').AsBoolean;
      except
        glblDisplaySchoolShortCodeInSummary := True;
      end;

      try
        glblUsesTaxBillNameAddr := FieldByName('UsesTaxBillNameAddr').AsBoolean;
      except
        glblUsesTaxBillNameAddr := False;
      end;

      try
        glblShowExtendedNeighborhoodInfo := FieldByName('UsesExtraNbhdCodes').AsBoolean;
      except
        glblShowExtendedNeighborhoodInfo := False;
      end;

    end;  {with SysRecTable do}

end;  {SetGlobalSystemVariables}

{===========================================================================}
Procedure SetGlobalAssessorsOfficeVariables(AssessorsOfficeTable : TTable);

{FXX12291999-1: Allow them to specify the number of blank lines at
                the bottom of the roll.}

begin
  with AssessorsOfficeTable do
    begin
      try
        GlblLetterAddressStart := FieldByName('EnvWindowHeight').AsFloat;
      except
        GlblLetterAddressStart := 2.35;  {Default}
      end;

        {FXX11021999-13: Allow the letter left margin to be customized.}

      try
        GlblLetterLeftMargin := FieldByName('LeftLetterMargin').AsFloat;
      except
        GlblLetterLeftMargin := 1;  {Default}
      end;

        {FXX12291999-1: Allow them to specify the number of blank lines at
                        the bottom of the roll.}

      try
        GlblLinesLeftOnRollDotMatrix := FieldByName('LinesLeftDM').AsInteger;
      except
        GlblLinesLeftOnRollDotMatrix := 12;  {Default}
      end;

      try
        GlblLinesLeftOnRollLaserJet := FieldByName('LinesLeftLJ').AsInteger;
      except
        GlblLinesLeftOnRollLaserJet := 12;  {Default}
      end;

      try
        GlblReportReprintLeftMargin := FieldByName('ReprintLeftMargin').AsFloat;
      except
        GlblReportReprintLeftMargin := 0.5;
      end;

      If (Roundoff(GlblReportReprintLeftMargin, 2) = 0)
        then GlblReportReprintLeftMargin := 0.5;

      GlblReportReprintSectionTop := 0.8;

    end;  {with AssessorsOfficeTable do}

end;  {SetGlobalAssessorsOfficeVariables}

{===========================================================================}
Procedure SetGlobalWarningOptions(WarningsDisplayedTable : TTable);

{CHG09071999-3: Allow selection of what warning messages are displayed.}

begin
  GlblWarningOptions := [];

  with WarningsDisplayedTable do
    begin
      If FieldByName('Inactive').AsBoolean
        then GlblWarningOptions := GlblWarningOptions + [wtInactiveParcels];

      If FieldByName('OutOfBalance').AsBoolean
        then GlblWarningOptions := GlblWarningOptions + [wtOutOfBalance];

      If FieldByName('RS8NoExempt').AsBoolean
        then GlblWarningOptions := GlblWarningOptions + [wtRS8NoExemption];

      If FieldByName('WhollyNoRS8').AsBoolean
        then GlblWarningOptions := GlblWarningOptions + [wtWhollyExemptNotRS8];

      If FieldByName('ZeroAV').AsBoolean
        then GlblWarningOptions := GlblWarningOptions + [wtZeroAssessments];

      If FieldByName('Frozen').AsBoolean
        then GlblWarningOptions := GlblWarningOptions + [wtFrozenAssessments];

      If FieldByName('PropClass73x').AsBoolean
        then GlblWarningOptions := GlblWarningOptions + [wtGasAndOilWells];

      If FieldByName('ImpChange').AsBoolean
        then GlblWarningOptions := GlblWarningOptions + [wtImprovementChange];

      If FieldByName('SMNumberNoAVChange').AsBoolean
        then GlblWarningOptions := GlblWarningOptions + [wtSplitMerge];

      If FieldByName('ARNoAVChange').AsBoolean
        then GlblWarningOptions := GlblWarningOptions + [wtARFilledIn_NoAVChange];

      If FieldByName('PhysIncAndDec').AsBoolean
        then GlblWarningOptions := GlblWarningOptions + [wtPhysIncAndDec];

      If FieldByName('EqualIncAndDec').AsBoolean
        then GlblWarningOptions := GlblWarningOptions + [wtEqualIncAndDec];

      If FieldByName('VacantLandAV').AsBoolean
        then GlblWarningOptions := GlblWarningOptions + [wtVacantLand];

      If FieldByName('NonvacantLandAV').AsBoolean
        then GlblWarningOptions := GlblWarningOptions + [wtNonVacantLand];

      If FieldByName('DuplicateExempt').AsBoolean
        then GlblWarningOptions := GlblWarningOptions + [wtDuplicateExemptions];

      If FieldByName('BasicAndSenior').AsBoolean
        then GlblWarningOptions := GlblWarningOptions + [wtBasicAndEnhanced];

      If FieldByName('SeniorNoEnhanced').AsBoolean
        then GlblWarningOptions := GlblWarningOptions + [wtSeniorWithoutEnhanced];

      If FieldByName('ExemptOnVacant').AsBoolean
        then GlblWarningOptions := GlblWarningOptions + [wtExemptionOnVacant];

      If FieldByName('STAROnNonRes').AsBoolean
        then GlblWarningOptions := GlblWarningOptions + [wtSTARonNonResidential];

      If FieldByName('NoTerminationDate').AsBoolean
        then GlblWarningOptions := GlblWarningOptions + [wtNoTerminationDate];

      If FieldByName('CountyOrTownOnly').AsBoolean
        then GlblWarningOptions := GlblWarningOptions + [wtCountyOrTownExemptionOnly];

      If FieldByName('ClergyWarning').AsBoolean
        then GlblWarningOptions := GlblWarningOptions + [wtClergyExemptionTooHigh];

      If FieldByName('EXMoreThanAV').AsBoolean
        then GlblWarningOptions := GlblWarningOptions + [wtExemptionsGreaterThanAV];

      try
        If FieldByName('STAROnNYnotTY').AsBoolean
          then GlblWarningOptions := GlblWarningOptions + [wtSTARonNYnotTY];
      except
      end;

      try
        If FieldByName('RS8PartialExemption').AsBoolean
          then GlblWarningOptions := GlblWarningOptions + [wtPartialExemptionOnRS8];
      except
      end;

      try
        If FieldByName('GarbageDiscountReminder').AsBoolean
          then GlblWarningOptions := GlblWarningOptions + [wtGarbageDiscountReminder];
      except
      end;

      try
        If FieldByName('AVChangeOnOverrideSD').AsBoolean
          then GlblWarningOptions := GlblWarningOptions + [wtAVChangeWithOverrideSpecialDistricts];
      except
      end;

      try
        If FieldByName('AVChange_MultSalePrcl').AsBoolean
          then GlblWarningOptions := GlblWarningOptions + [wtAVChangeWithSaleForMultipleParcels];
      except
      end;

      try
        If FieldByName('ColdWarAndOtherVet').AsBoolean
          then GlblWarningOptions := GlblWarningOptions + [wtColdWarVetAndRegularVetOnParcel];
      except
      end;

    end;  {with WarningsDisplayedTable do}

end;  {SetGlobalWarningOptions}

{=============================================================}
Function OwnerNamesAndAddressEqual(NameAddressArray1 : NameAddrArray;
                                   NameAddressArray2 : NameAddrArray) : Boolean;

var
  I : Integer;

begin
  Result := True;

  For I := 1 to 6 do
    If _Compare(NameAddressArray1[I], NameAddressArray2[I], coNotEqual)
      then Result := False;

end;  {OwnerNamesAndAddressEqual}

{==================================================================================}
Function GetNameAddressBankCodeInfo(ParcelTable : TTable) : NameAddressBankCodeRecord;

{FXX02171999-7: Store the name address information to see if it changed.}

begin
  GetNameAddress(ParcelTable, Result.NAddrArray);
  Result.BankCode := ParcelTable.FieldByName('BankCode').Text;

end;  {GetNameAddressBankCodeInfo}

{==================================================================================}
Function NameAddressBankCodeDifferent(NameAddrBankCodeRec1,
                                      NameAddrBankCodeRec2 : NameAddressBankCodeRecord) : Boolean;

var
  I : Integer;

begin
  Result := False;

  For I := 1 to 6 do
    If (Take(30, NameAddrBankCodeRec1.NAddrArray[I]) <>
        Take(30, NameAddrBankCodeRec2.NAddrArray[I]))
      then Result := true;

  If (Take(6, NameAddrBankCodeRec1.BankCode) <> Take(6, NameAddrBankCodeRec2.BankCode))
    then Result := True;

end;  {NameAddressBankCodeDifferent}

{==================================================================================}
Function FindProcessingTypeOfLastFinalRoll(    TempDate : TDateTime;
                                           var TaxRollYr : String;
                                           var Found : Boolean) : Integer;

{Given a date, find the processing type (assessment year) of the previous final roll.}

var
  AssessmentYearControlTable : TTable;
  PriorTaxYear : String;
  Quit, FoundPrior, Done, FirstTimeThrough : Boolean;
  PriorFinalRollDate, ThisYearFinalRollDate : TDateTime;
  Year, Month, Day : Word;

begin
  Result := 0;
  Found := False;
  PriorFinalRollDate := 0;
  FoundPrior := False;
  ThisYearFinalRollDate := 0;

  AssessmentYearControlTable := TTable.Create(nil);
  AssessmentYearControlTable.IndexName := 'BYTAXROLLYR';

  OpenTableForProcessingType(AssessmentYearControlTable, AssessmentYearControlTableName,
                             NextYear, Quit);

  If (AssessmentYearControlTable.FieldByName('FinalRollDate').AsDateTime <= TempDate)
    then
      begin
        Result := NextYear;
        TaxRollYr := GlblNextYear;
        Found := True;
      end;

    {Not earlier than the next year final roll date, try this year.}

  If (Result = 0)
    then
      begin
        OpenTableForProcessingType(AssessmentYearControlTable, AssessmentYearControlTableName,
                                   ThisYear, Quit);

        If (AssessmentYearControlTable.FieldByName('FinalRollDate').AsDateTime <= TempDate)
          then
            begin
              Result := ThisYear;
              Found := True;
              TaxRollYr := GlblThisYear;
            end;

        ThisYearFinalRollDate := AssessmentYearControlTable.FieldByName('FinalRollDate').AsDateTime;

      end;  {If (Result = 0)}

    {Not earlier than the this year final roll date, try prior.}

  If (Result = 0)
    then
      begin
          {FXX12082004-1(2.8.1.2)[2018]: This FindKey did not work because the index was never set.}

        OpenTableForProcessingType(AssessmentYearControlTable, AssessmentYearControlTableName,
                                   History, Quit);

        Done := False;
        FirstTimeThrough := True;

        AssessmentYearControlTable.Last;

        PriorTaxYear := IntToStr(StrToInt(GlblThisYear) - 1);

        repeat
          If FirstTimeThrough
            then FirstTimeThrough := False
            else AssessmentYearControlTable.Prior;

          If AssessmentYearControlTable.BOF
            then Done := True;

          If not Done
            then FoundPrior := (AssessmentYearControlTable.FieldByName('FinalRollDate').AsDateTime <= TempDate);

        until (Done or FoundPrior);

        If FoundPrior
          then
            begin
              Found := True;
              Result := History;
              TaxRollYr := AssessmentYearControlTable.FieldByName('TaxRollYr').Text;
            end
          else
            begin
                {No history, so we will try going back one year and using the prior fields in
                 the ThisYear assessment table. Otherwise, it's to old a sale.}

              DecodeDate(ThisYearFinalRollDate, Year, Month, Day);
              PriorFinalRollDate := EncodeDate((Year - 1), Month, Day);

              If (PriorFinalRollDate <= TempDate)
                then
                  begin
                    Result := History;
                    TaxRollYr := IntToStr(StrToInt(GlblThisYear) - 1);
                    Found := True;

                  end;  {If (PriorFinalRollDate <= TempDate)}

            end;  {else of If FoundPrior}

      end;  {If (Result = 0)}

  If not Found
    then
      begin
          {If we have no info for this parcel, work our way back to figure out
           at least the assessment year.}

        TaxRollYr := IntToStr(StrToInt(GlblThisYear) - 1);

        repeat
          DecodeDate(PriorFinalRollDate, Year, Month, Day);
          PriorFinalRollDate := EncodeDate((Year - 1), Month, Day);

          TaxRollYr := IntToStr(StrToInt(TaxRollYr) - 1);

        until (PriorFinalRollDate <= TempDate);

      end;  {If not Found}

  AssessmentYearControlTable.Close;
  AssessmentYearControlTable.Free;

end;  {FindProcessingTypeOfLastFinalRoll}

{==========================================================================}
Function HistoryExists : Boolean;

var
  TempParcelTable : TTable;

begin
  TempParcelTable := FindTableInDataModuleForProcessingType(DataModuleParcelTableName,
                                                            History);
  Result := _Compare(GetRecordCount(TempParcelTable), 0, coGreaterThan);

end;  {HistoryExists}

{======================================================}
Function ConvertModeToStr(Mode : Integer) : String;

{FXX04081999-6: These were moved here for split\merge tracing.}

begin
  case Mode of
    Split : Result := 'split';
    Merge : Result := 'merge';
    SBLChange : Result := 'SBL change';
    CopyParcel : Result := 'copy';
    SwitchParcels : Result := 'parcel switch';
    RollSection9 : Result := 'roll section 9';

  end;  {case Mode of}

end;  {ConvertModeToStr}

{=====================================================================================}
Function MeetsScreensToShowCriteria(ScreensToShow : TScreenType;
                                    ScreenName : String) : Boolean;

{CHG03212004-1(2.08): Allow for limitations on what screens to put in the list
                      from the calling routine.}

begin
  Result := False;
  ScreenName := Trim(ANSIUpperCase(ScreenName));

  If (slAll in ScreensToShow)
    then Result := True
    else
      begin
        If ((slAssessment in ScreensToShow) and
            (ScreenName = ANSIUpperCase(AssessmentScreenName)))
          then Result := True;

        If ((slBaseInformation in ScreensToShow) and
            (ScreenName = ANSIUpperCase(BaseInformationScreenName)))
          then Result := True;

        If ((slClass in ScreensToShow) and
            (ScreenName = ANSIUpperCase(ClassScreenName)))
          then Result := True;

        If ((slExemption in ScreensToShow) and
            (ScreenName = ANSIUpperCase(ExemptionScreenName)))
          then Result := True;

        If ((slExemptionDenial in ScreensToShow) and
            (ScreenName = ANSIUpperCase(ExemptionDenialScreenName)))
          then Result := True;

        If ((slExemptionRemoval in ScreensToShow) and
            (ScreenName = ANSIUpperCase(ExemptionRemovalScreenName)))
          then Result := True;

        If ((slSpecialDistrict in ScreensToShow) and
            (ScreenName = ANSIUpperCase(SpecialDistrictScreenName)))
          then Result := True;

        If ((slResidentialSite in ScreensToShow) and
            (ScreenName = ANSIUpperCase(ResidentialSiteScreenName)))
          then Result := True;

        If ((slResidentialBuilding in ScreensToShow) and
            (ScreenName = ANSIUpperCase(ResidentialBuildingScreenName)))
          then Result := True;

        If ((slResidentialLand in ScreensToShow) and
            (ScreenName = ANSIUpperCase(ResidentialLandScreenName)))
          then Result := True;

        If ((slResidentialImprovement in ScreensToShow) and
            (ScreenName = ANSIUpperCase(ResidentialImprovementScreenName)))
          then Result := True;

        If ((slResidentialForest in ScreensToShow) and
            (ScreenName = ANSIUpperCase(ResidentialForestScreenName)))
          then Result := True;

        If ((slCommercialSite in ScreensToShow) and
            (ScreenName = ANSIUpperCase(CommercialSiteScreenName)))
          then Result := True;

        If ((slCommercialBuilding in ScreensToShow) and
            (ScreenName = ANSIUpperCase(CommercialBuildingScreenName)))
          then Result := True;

        If ((slCommercialLand in ScreensToShow) and
            (ScreenName = ANSIUpperCase(CommercialLandScreenName)))
          then Result := True;

        If ((slCommercialImprovement in ScreensToShow) and
            (ScreenName = ANSIUpperCase(CommercialImprovementScreenName)))
          then Result := True;

        If ((slCommercialRent in ScreensToShow) and
            (ScreenName = ANSIUpperCase(CommercialRentScreenName)))
          then Result := True;

        If ((slCommercialIncomeExpense in ScreensToShow) and
            (ScreenName = ANSIUpperCase(CommercialIncomeExpenseScreenName)))
          then Result := True;

        If ((slDocument in ScreensToShow) and
            (ScreenName = ANSIUpperCase(DocumentScreenName)))
          then Result := True;

        If ((slPicture in ScreensToShow) and
            (ScreenName = ANSIUpperCase(PictureScreenName)))
          then Result := True;

        If ((slNote in ScreensToShow) and
            (ScreenName = ANSIUpperCase(NoteScreenName)))
          then Result := True;

        If ((slSale in ScreensToShow) and
            (ScreenName = ANSIUpperCase(SaleScreenName)))
          then Result := True;

        If ((slGrievance in ScreensToShow) and
            (ScreenName = ANSIUpperCase(GrievanceScreenName)))
          then Result := True;

        If ((slGrievanceResult in ScreensToShow) and
            (ScreenName = ANSIUpperCase(GrievanceResultsScreenName)))
          then Result := True;

        If ((slSmallClaims in ScreensToShow) and
            (ScreenName = ANSIUpperCase(SmallClaimsScreenName)))
          then Result := True;

        If ((slSmallClaimsNote in ScreensToShow) and
            (ScreenName = ANSIUpperCase(SmallClaimsNotesScreenName)))
          then Result := True;

        If ((slSmallClaimsCalendar in ScreensToShow) and
            (ScreenName = ANSIUpperCase(SmallClaimsCalendarScreenName)))
          then Result := True;

        If ((slSmallClaimsAppraisal in ScreensToShow) and
            (ScreenName = ANSIUpperCase(SmallClaimsAppraisalsScreenName)))
          then Result := True;

        If ((slCertiorari in ScreensToShow) and
            (ScreenName = ANSIUpperCase(CertiorariScreenName)))
          then Result := True;

        If ((slCertiorariNote in ScreensToShow) and
            (ScreenName = ANSIUpperCase(CertiorariNotesScreenName)))
          then Result := True;

        If ((slCertiorariCalendar in ScreensToShow) and
            (ScreenName = ANSIUpperCase(CertiorariCalendarScreenName)))
          then Result := True;

        If ((slCertiorariAppraisal in ScreensToShow) and
            (ScreenName = ANSIUpperCase(CertiorariAppraisalsScreenName)))
          then Result := True;

      end;  {If (slAll in ScreensToShow)}

end;  {MeetsScreensToShowCriteria}

{=====================================================================================}
Procedure LoadScreenLabelList(ScreenLabelList : TList;
                              ScreenLabelTable,
                              UserFieldDefinitionTable : TTable;
                              LoadUserDefinedFields : Boolean;
                              LoadOnlyReportVisibleFields : Boolean;
                              UseReportDisplayNames : Boolean;
                              ScreensToShow : TScreenType);

{FXX11191999-7: Add user defined fields to search, audit, broadcast.}

var
  Done, FirstTimeThrough : Boolean;
  ScrLblPtr : ScreenLabelPtr;
  ScreenName, TempStr, TempFieldName : String;

begin
  Done := False;
  FirstTimeThrough := True;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else ScreenLabelTable.Next;

    If ScreenLabelTable.EOF
      then Done := True;

      {CHG02152004-1(2.07l): Add grievance, small claims and cert info. to search report.}

    ScreenName := ScreenLabelTable.FieldByName('ScreenName').Text;

      {CHG03212004-1(2.08): Allow for limitations on what screens to put in the list
                            from the calling routine.}

    If ((not Done) and
        MeetsScreensToShowCriteria(ScreensToShow, ScreenName) and
        ((not LoadOnlyReportVisibleFields) or
         ScreenLabelTable.FieldByName('VisibleOnReports').AsBoolean) and
        ((not IsGrievance_SmallClaims_CertiorariScreen(ScreenName)) or
         UserCanViewGrievance_SmallClaims_CertiorariInformation(ScreenName)))
      then
        begin
            {first put all screenname/labelname combinations in a Tlist}
            {in memory for later reference to fill in the label string list}

         New(ScrLblPtr);
         ScrLblPtr^.ScreenName := Take(30, ScreenLabelTable.FieldByName('ScreenName').Text);

         If UseReportDisplayNames
           then ScrLblPtr^.LabelName := Take(30, ScreenLabelTable.FieldByName('ReportDisplayName').Text)
           else ScrLblPtr^.LabelName := Take(30, ScreenLabelTable.FieldByName('LabelName').Text);

         ScrLblPtr^.FieldName := Take(30, ScreenLabelTable.FieldByName('FieldName').Text);
         ScrLblPtr^.TableName := Take(30, ScreenLabelTable.FieldByName('TableName').Text);
         ScreenLabelList.Add(ScrLblPtr);

      end;  {If not Done}

  until Done;

  If LoadUserDefinedFields
    then
      begin
        FirstTimeThrough := True;
        Done := False;
        UserFieldDefinitionTable.First;

        repeat
          If FirstTimeThrough
            then FirstTimeThrough := False
            else UserFieldDefinitionTable.Next;

          If UserFieldDefinitionTable.EOF
            then Done := True;

          If not Done
            then
              with UserFieldDefinitionTable do
                If FieldByName('Active').AsBoolean
                  then
                    begin
                      New(ScrLblPtr);
                      ScrLblPtr^.ScreenName := Take(30, 'User Fields');
                      ScrLblPtr^.LabelName := Take(30, FieldByName('UserSpecifiedDescr').Text);

                        {We have to construct the actual field name in the data file.}

                      TempStr := FieldByName('ComponentFieldName').Text;

                      If (Pos('Str', TempStr) > 0)
                        then TempFieldName := 'String' + TempStr[4] + 'Field';

                      If (Pos('Flt', TempStr) > 0)
                        then TempFieldName := 'Float' + TempStr[4] + 'Field';

                      If (Pos('Int', TempStr) > 0)
                        then TempFieldName := 'Integer' + TempStr[4] + 'Field';

                      If (Pos('CheckBox', TempStr) > 0)
                        then TempFieldName := 'Logical' + TempStr[11] + 'Field';

                      ScrLblPtr^.FieldName := Take(30, TempFieldName);
                      ScrLblPtr^.TableName := Take(30, UserDataTableName);
                      ScreenLabelList.Add(ScrLblPtr);

                    end;  {If FieldByName('Active').AsBoolean}

        until Done;

      end;  {If LoadUserDefinedFields}

end;  {LoadScreenLabelList}

{===================================================================}
Procedure ShowReportDialog(DefaultFileName,
                           OriginalFileName : String;
                           ReportFile : Boolean);

var
  dlgSave : TSaveDialog;
  sFileName, sFilePath : String;

begin
    {If the person is not allowed to see this dialog box, save as the
     default name and exit without displaying.}

  If glblUseWindowsSaveDlgForReports
  then
  begin
    dlgSave := TSaveDialog.Create(nil);
    dlgSave.FileName := DefaultFileName;
    dlgSave.InitialDir := GlblReportDir;

    If dlgSave.Execute
    then
    begin
      sFileName := ExtractFileName(dlgSave.FileName);
      sFilePath := ExtractFilePath(dlgSave.FileName);

      try
        Chdir(sFilePath);
        OldDeleteFile(sFileName);
      except
      end;

      CopyOneFile(OriginalFileName, sFilePath + sFileName);

    end;  {If dlgSave.Execute}

    dlgSave.Free;

  end
  else
  with ReportDialog do
    begin
      FileName := DefaultFileName;
      OrigFileName := OriginalFileName;

      If GlblUserSeesReportDialog
        then ShowModal
        else SaveFile(FileName, ExpandPASPath(GlblReportDir));

    end;  {with ReportDialog do}

end;  {ShowReportDialog}

{=======================================================================}
Procedure InitNameAddressRecord(var NameAddressRec : NameAddressRecord);

{CHG02122000-3: Insert a name\addr audit change record.}

begin
  with NameAddressRec do
    begin
      Name1 := '';
      Name2 := '';
      Address1 := '';
      Address2 := '';
      Street := '';
      City := '';
      State := '';
      Zip := '';
      ZipPlus4 := '';
    end;

end;  {InitNameAddressRecord}

{======================================================================}
Function NameAddressInfoChanged(OrigNameAddressRec,
                                NewNameAddressRec : NameAddressRecord) : Boolean;

begin
  Result := ((OrigNameAddressRec.Name1 <> NewNameAddressRec.Name1) or
             (OrigNameAddressRec.Name2 <> NewNameAddressRec.Name2) or
             (OrigNameAddressRec.Address1 <> NewNameAddressRec.Address1) or
             (OrigNameAddressRec.Address2 <> NewNameAddressRec.Address2) or
             (OrigNameAddressRec.Street <> NewNameAddressRec.Street) or
             (OrigNameAddressRec.City <> NewNameAddressRec.City) or
             (OrigNameAddressRec.State <> NewNameAddressRec.State) or
             (OrigNameAddressRec.Zip <> NewNameAddressRec.Zip) or
             (OrigNameAddressRec.ZipPlus4 <> NewNameAddressRec.ZipPlus4));

end;  {NameAddressInfoChanged}

{======================================================================}
Function GetNameAddressInfo(ParcelTable : TTable) : NameAddressRecord;

begin
  with ParcelTable do
    begin
      Result.Name1 := FieldByName('Name1').Text;
      Result.Name2 := FieldByName('Name2').Text;
      Result.Address1 := FieldByName('Address1').Text;
      Result.Address2 := FieldByName('Address2').Text;
      Result.Street := FieldByName('Street').Text;
      Result.City := FieldByName('City').Text;
      Result.State := FieldByName('State').Text;
      Result.Zip := FieldByName('Zip').Text;
      Result.ZipPlus4 := FieldByName('ZipPlus4').Text;
    end;

end;  {GetNameAddressInfo}

{======================================================================}
Function InsertNameAddressTraceRecord(SwisSBLKey : String;
                                      OrigNameAddressRec,
                                      NewNameAddressRec : NameAddressRecord) : Boolean;

{CHG02122000-3: Insert a name\addr audit change record.}

begin
  Result := False;

  If NameAddressInfoChanged(OrigNameAddressRec, NewNameAddressRec)
    then
      with GlblNameAddressTraceTable do
        try
          Result := True;
          Insert;
          FieldByName('SwisSBLKey').Text := SwisSBLKey;
          FieldByName('User').Text := Take(10, GlblUserName);
          FieldByName('Date').AsDateTime := Date;
          FieldByName('Time').AsDateTime := Now;
          FieldByName('OldName1').Text := OrigNameAddressRec.Name1;
          FieldByName('OldName2').Text := OrigNameAddressRec.Name2;
          FieldByName('OldAddress1').Text := OrigNameAddressRec.Address1;
          FieldByName('OldAddress2').Text := OrigNameAddressRec.Address2;
          FieldByName('OldStreet').Text := OrigNameAddressRec.Street;
          FieldByName('OldCity').Text := OrigNameAddressRec.City;
          FieldByName('OldState').Text := OrigNameAddressRec.State;
          FieldByName('OldZip').Text := OrigNameAddressRec.Zip;
          FieldByName('OldZipPlus4').Text := OrigNameAddressRec.ZipPlus4;
          FieldByName('NewName1').Text := NewNameAddressRec.Name1;
          FieldByName('NewName2').Text := NewNameAddressRec.Name2;
          FieldByName('NewAddress1').Text := NewNameAddressRec.Address1;
          FieldByName('NewAddress2').Text := NewNameAddressRec.Address2;
          FieldByName('NewStreet').Text := NewNameAddressRec.Street;
          FieldByName('NewCity').Text := NewNameAddressRec.City;
          FieldByName('NewState').Text := NewNameAddressRec.State;
          FieldByName('NewZip').Text := NewNameAddressRec.Zip;
          FieldByName('NewZipPlus4').Text := NewNameAddressRec.ZipPlus4;
          FieldByName('CheckedOff').AsBoolean := False;
          Post;
        except
          SystemSupport(916, GlblNameAddressTraceTable, 'Error posting to name \ address trace table.',
                        'PASUTILS', GlblErrorDlgBox);
        end;

end;  {InsertNameAddressTraceRecord}

{===============================================================}
Procedure SetOldSegmentFormats;

begin
  If _Compare(GlblMunicipalityName, 'Ramapo', coEqual)
    then
      begin
        GlblSectionFormat := [fmShiftRightAddZeroes, fmNumeric];
        GlblSubsectionFormat := [fmLeftJustify];
        GlblBlockFormat := [fmShiftRightAddZeroes, fmNumeric];
        GlblLotFormat := [fmAlphaNumeric];
        GlblSublotFormat := [fmAlphaNumeric];
        GlblSuffixFormat := [fmShiftRightAddZeroes, fmNumeric];

        GlblSectionSeparator    := '.';
        GlblSubsectionSeparator := '/';
        GlblBlockSeparator      := '/';
        GlblLotSeparator        := ' ';
        GlblSublotSeparator     := '/';

      end;  {If _Compare(GlblMunicipalityName, 'Ramapo', coEqual)}

  If _Compare(GlblMunicipalityName, 'Greenburgh', coEqual)
    then
      begin
        GlblSectionFormat := [fmLeftJustify, fmAlphaNumeric];
        GlblSubsectionFormat := [fmLeftJustify, fmAlphaNumeric];
        GlblBlockFormat := [fmLeftJustify, fmAlphaNumeric];
        GlblLotFormat := [fmLeftJustify, fmAlphaNumeric];
        GlblSublotFormat := [fmLeftJustify, fmAlphaNumeric];
        GlblSuffixFormat := [fmLeftJustify, fmAlphaNumeric];

        GlblSectionSeparator    := '/';
        GlblSubsectionSeparator := '/';
        GlblBlockSeparator      := '/';
        GlblLotSeparator        := '/';
        GlblSublotSeparator     := '/';

      end;  {If _Compare(GlblMunicipalityName, 'Ramapo', coEqual)}

  If _Compare(GlblMunicipalityName, 'North Castle', coEqual)
    then
      begin
        GlblSectionFormat := [fmShiftRightAddZeroes, fmNumeric];
        GlblSubsectionFormat := [fmLeftJustify, fmAlphaNumeric];
        GlblBlockFormat := [fmShiftRightAddZeroes, fmNumeric];
        GlblLotFormat := [fmLeftJustify, fmAlphaNumeric];
        GlblSublotFormat := [fmShiftRightAddZeroes, fmNumeric];
        GlblSuffixFormat := [fmLeftJustify, fmAlphaNumeric];

        GlblSectionSeparator    := '/';
        GlblSubsectionSeparator := '/';
        GlblBlockSeparator      := '.';
        GlblLotSeparator        := '-';
        GlblSublotSeparator     := '.';

        GlblSectionDigits    := 3;
        GlblSubsectionDigits := 2;
        GlblBlockDigits      := 4;
        GlblLotDigits        := 3;
        GlblSublotDigits     := 3;
        GlblSuffixDigits     := 4;

      end;  {If _Compare(GlblMunicipalityName, 'Ramapo', coEqual)}

end;  {SetOldSegmentFormats}

{===============================================================}
Function ConvertSwisSBLToOldDashDotNoSwis(SwisSBLKey : String;
                                          AssessmentYearControlTable : TTable) : String;

begin
    {Switch to old segment formats}
  SetOldSegmentFormats;

  Result := ConvertSwisSBLToDashDotNoSwis(SwisSBLKey);

    {Switch back}
  SetGlobalSBLSegmentFormats(AssessmentYearControlTable);

end;  {ConvertSwisSBLToOldDashDotNoSwis}

{===============================================================}
Function ConvertSwisSBLToOldDashDot(SwisSBLKey : String;
                                    AssessmentYearControlTable : TTable) : String;

begin
    {Switch to old segment formats}
  SetOldSegmentFormats;

  Result := ConvertSwisSBLToDashDot(SwisSBLKey);

    {Switch back}
  SetGlobalSBLSegmentFormats(AssessmentYearControlTable);

end;  {ConvertSwisSBLToOldDashDotNoSwis}

{===============================================================}
Function ConvertSBLOnlyToOldDashDot(SBLKey : String;
                                    AssessmentYearControlTable : TTable) : String;

begin
    {Switch to old segment formats}
  SetOldSegmentFormats;

  Result := ConvertSBLOnlyToDashDot(SBLKey);

    {Switch back}
  SetGlobalSBLSegmentFormats(AssessmentYearControlTable);

end;  {ConvertSBLOnlyToOldDashDot}

{===============================================================}
Function ConvertOldDashDotSBLToSegmentSBL(    DashDotParcelID : String;
                                              AssessmentYearControlTable : TTable;
                                          var ValidEntry : Boolean) : SBLRecord;

begin
    {Switch to old segment formats}
  SetOldSegmentFormats;

  Result := ConvertDashDotSBLToSegmentSBL(DashDotParcelID, ValidEntry);

    {Switch back}
  SetGlobalSBLSegmentFormats(AssessmentYearControlTable);

end;  {ConvertOldDashDotSBLToSegmentSBL}

{===============================================================}
Function ConvertOldSwisDashDotSBLToSwisSBL(    DashDotParcelID : String;
                                               AssessmentYearControlTable,
                                               SwisCodeTable : TTable;
                                           var ValidEntry : Boolean) : String;

begin
    {Switch to old segment formats}
  SetOldSegmentFormats;

  Result := ConvertSwisDashDotToSwisSBL(DashDotParcelID, SwisCodeTable, ValidEntry);

    {Switch back}
  SetGlobalSBLSegmentFormats(AssessmentYearControlTable);

end;  {ConvertOldSwisDashDotSBLToSwisSBL}

{===============================================================}
Procedure SetOldParcelIDLabel(OldParcelIDLabel : TLabel;
                              ParcelTable,
                              AssessmentYearControlTable : TTable);

var
  TempSwisSBLKey : String;

begin
  OldParcelIDLabel.Visible := True;
  TempSwisSBLKey := ParcelTable.FieldByName('RemapOldSBL').Text;
  If _Compare(TempSwisSBLKey, coBlank)
    then TempSwisSBLKey := ExtractSSKey(ParcelTable);

  If _Compare(Length(TempSwisSBLKey), 26, coEqual)
    then OldParcelIDLabel.Caption := 'Old ID: ' +
                                     ConvertSwisSBLToOldDashDotNoSwis(TempSwisSBLKey,
                                                                      AssessmentYearControlTable)
    else OldParcelIDLabel.Caption := 'Old ID: ' +
                                     ConvertSBLOnlyToOldDashDot(TempSwisSBLKey,
                                                                AssessmentYearControlTable);

end;  {SetOldParcelIDLabel}

{============================================================================}
Function CheckIfParcelIsActive(AssessmentYear : String;
                               ProcessingType : Integer;
                               SwisSBLKey : String) : Integer;

var
  SBLRec : SBLRecord;
  Found, Quit : Boolean;
  ParcelTable : TTable;

begin
  ParcelTable := TTable.Create(nil);
  OpenTableForProcessingType(ParcelTable, ParcelTableName, ProcessingType, Quit);
  ParcelTable.IndexName := ParcelTable_Year_Swis_SBLKey;
  SBLRec := ExtractSwisSBLFromSwisSBLKey(SwisSBLKey);

  with SBLRec do
    Found := FindKeyOld(ParcelTable,
                        ['TaxRollYr', 'SwisCode',
                         'Section', 'Subsection',
                         'Block', 'Lot', 'Sublot', 'Suffix'],
                        [AssessmentYear, SwisCode, Section,
                         Subsection, Block,
                         Lot, Sublot, Suffix]);

  If Found
    then
      begin
        If ParcelIsActive(ParcelTable)
          then Result := atActive
          else Result := atInactive;
      end
    else Result := atDoesNotExist;

  ParcelTable.Close;
  ParcelTable.Free;

end;  {CheckIfParcelIsActive}

{=============================================================}
Function FindTableInDataModuleForProcessingType(TableName : String;
                                                ProcessingType : Integer) : TwwTable;

{Given a table name and a processing type, find the corresponding table
 on the data module form.  For instance, there are 3 AssessmentTables on
 the data module: TYAssessmentTable, NYAssessmentTable and HistoryAssessmentTable -
 'AssessmentTable' and ThisYear should be passed in in order to use the
 TYAssessmentTable on the DataModule.}

var
  I : Integer;
  TempName : String;

begin
  Result := nil;

  case ProcessingType of
    ThisYear : TempName := 'TY' + TableName;
    NextYear : TempName := 'NY' + TableName;
    History : TempName := 'History' + TableName;
    SalesInventory : TempName := 'Sales' + TableName;
    NoProcessingType : TempName := TableName;
  end;

    {Go through the data module until we find the table we are looking for.}

  with PASDataModule do
    For I := 0 to (ComponentCount - 1) do
      If ((Components[I] is TwwTable) and
          _Compare(TwwTable(Components[I]).Name, TempName, coEqual))
        then Result := TwwTable(Components[I]);

end;  {FindTableInDataModuleForProcessingType}

{============================================================}
Function ConvertRegularTableNameToDataModuleName(RegularTableName : String) : String;

{Given a table name with its regular constant, come up with the data module name.}

begin
  If (RegularTableName = ParcelTableName)
    then Result := DataModuleParcelTableName;
  If (RegularTableName = AssessmentTableName)
    then Result := DataModuleAssessmentTableName;
  If (RegularTableName = ClassTableName)
    then Result := DataModuleClassTableName;
  If (RegularTableName = SpecialDistrictTableName)
    then Result := DataModuleSpecialDistrictTableName;
  If (RegularTableName = ExemptionsTableName)
    then Result := DataModuleExemptionTableName;
  If (RegularTableName = SalesTableName)
    then Result := DataModuleSalesTableName;
  If (RegularTableName = ResidentialSiteTableName)
    then Result := DataModuleResidentialSiteTableName;
  If (RegularTableName = ResidentialBldgTableName)
    then Result := DataModuleResidentialBuildingTableName;
  If (RegularTableName = ResidentialLandTableName)
    then Result := DataModuleResidentialLandTableName;
  If (RegularTableName = ResidentialForestTableName)
    then Result := DataModuleResidentialForestTableName;
  If (RegularTableName = ResidentialImprovementsTableName)
    then Result := DataModuleResidentialImprovementTableName;
  If (RegularTableName = CommercialSiteTableName)
    then Result := DataModuleCommercialSiteTableName;
  If (RegularTableName = CommercialBldgTableName)
    then Result := DataModuleCommercialBuildingTableName;
  If (RegularTableName = CommercialLandTableName)
    then Result := DataModuleCommercialLandTableName;
  If (RegularTableName = CommercialImprovementsTableName)
    then Result := DataModuleCommercialImprovementTableName;
  If (RegularTableName = CommercialRentTableName)
    then Result := DataModuleCommercialRentTableName;
  If (RegularTableName = CommercialIncomeExpenseTableName)
    then Result := DataModuleCommercialIncomeExpenseTableName;
  If (RegularTableName = AssessmentYearControlTableName)
    then Result := DataModuleAssessmentYearControlTableName;
  If (RegularTableName = ExemptionCodesTableName)
    then Result := DataModuleExemptionCodeTableName;
  If (RegularTableName = SchoolCodeTableName)
    then Result := DataModuleSchoolCodeTableName;
  If (RegularTableName = SdistCodeTableName)
    then Result := DataModuleSpecialDistrictCodeTableName;
  If (RegularTableName = SwisCodeTableName)
    then Result := DataModuleSwisCodeTableName;

end;  {ConvertRegularTableNameToDataModuleName}

{====================================================================}
Procedure GetItemFileList(ItemNameList : TList;
                          Directory : String;
                          DocumentType : Integer;
                          SwisSBLKey : String;
                          UseLastPartOfFileNameForNotes : Boolean;
                          IncludeSwisCode : Boolean;
                          StripLeadingZeroes : Boolean;
                          EastchesterGeneralCodeFormat : Boolean;
                          ExactParcelIDMatchOnly : Boolean;
                          sAccountNumber : String;
                          sPrintKey : String;
                          bDetectByAccountNumber : Boolean;
                          bDetectByFullSBL : Boolean;
                          bDetectByExactPrintKey : Boolean;
                          bMatchHarrisonCardFormat : Boolean;
                          bNassauFormat : Boolean);

{Get a list of files (pictures, docs, etc.) matching the parcel ID in
 the given directory.}

var
  TempFile : TSearchRec;
  ReturnCode, NextCharacterPosAfterSwisSBLKey, CaratPos, iPos : Integer;
  DocumentListPtr : DocumentListPointer;
  SwisCodeTable : TTable;
  InitialFileName,
  CurrentDirectory, EndingStr, TempSwisSBLKey,
  sSection, sSubsection, sBlock, sLot, sSublot : String;
  Continue, ProcessThisItem : Boolean;

begin
  If (Deblank(ConvertSwisSBLToDashDotNoSwis(SwisSBLKey)) <> '')
    then
      begin
        Continue := True;
        CurrentDirectory := ExpandPASPath(Directory);
        SwisCodeTable := FindTableInDataModuleForProcessingType(DataModuleSwisCodeTableName,
                                                                ThisYear);

        If bDetectByAccountNumber
          then TempSwisSBLKey := sAccountNumber
          else
            If EastchesterGeneralCodeFormat
              then
                begin
                  TempSwisSBLKey := DeZeroOnLeft(Copy(SwisSBLKey, 7, 3)) +
                                    Trim(Copy(SwisSBLKey, 10, 3)) +  '_' +
                                    DeZeroOnLeft(Copy(SwisSBLKey, 13, 4)) + '_' +
                                    DeZeroOnLeft(Copy(SwisSBLKey, 17, 3)) +
                                    Trim(Copy(SwisSBLKey, 20, 3)) +  '-' +
                                    Trim(Copy(SwisSBLKey, 23, 4));

                  If _Compare(TempSwisSBLKey[Length(TempSwisSBLKey)], '-', coEqual)
                    then Delete(TempSwisSBLKey, Length(TempSwisSBLKey), 1);

                end
              else
                If bDetectByFullSBL
                  then TempSwisSBLKey := SwisSBLKey
                  else
                    begin
                      TempSwisSBLKey := ConvertSwisSBLToDashDotNoSwis(SwisSBLKey);

                        {FXX07062003-1(2.07f): If this municipality uses separator chars that
                                               are not valid in Windows file names, replace all with
                                               dashes for characters.}

                      If ((Pos('/', TempSwisSBLKey) > 0) or
                          (Pos('\', TempSwisSBLKey) > 0))
                        then
                          begin
                            TempSwisSBLKey := StringReplace(TempSwisSBLKey, '/', '-', [rfReplaceAll]);
                            TempSwisSBLKey := StringReplace(TempSwisSBLKey, '\', '-', [rfReplaceAll]);
                          end;

                        {CHG06192001-1: Add the last two digits of the swis code onto
                                        the file name for towns with more than 1 swis.}
                        {FXX11152002-1: Use RecordCount instead of GetRecordCount so
                                        that we don't pick up deleted records.}
                        {CHG08042003-1(2.07h): Search for SBL without swis code if the picture
                                               can't be found with it.}

                      If ((SwisCodeTable.RecordCount > 1) and
                          IncludeSwisCode)
                        then TempSwisSBLKey := Copy(SwisSBLKey, 5, 2) + TempSwisSBLKey;

                      If StripLeadingZeroes
                        then
                          begin
                            TempSwisSBLKey := StringReplace(TempSwisSBLKey, '.0', '.', [rfReplaceAll]);
                            TempSwisSBLKey := DezeroOnLeft(StringReplace(TempSwisSBLKey, '-0', '-', [rfReplaceAll]));
                          end;

                    end;  {If bDetectByFullSBL}

        If bMatchHarrisonCardFormat
        then
        begin
          TempSwisSBLKey := DezeroOnLeft(sPrintkey);

          TempSwisSBLKey := StringReplace(TempSwisSBLKey, '.-', '_', [rfReplaceAll]);
          iPos := Pos('_', TempSwisSBLKey);

          If not _Compare(TempSwisSBLKey, '.', coContains)
          then TempSwisSBLKey := Copy(TempSwisSBLKey, 1, iPos) + ShiftRightAddZeroes(Copy(TempSwisSBLKey, (iPos + 1), 200), 3);
        end;

        If bNassauFormat
        then
        begin
          sSection := DezeroOnLeft(Copy(SwisSBLKey, 7, 3));
          sBlock := Copy(SwisSBLKey, 13, 4);
          sLot := Copy(SwisSBLKey, 17, 3);
          sSublot := Trim(Copy(SwisSBLKey, 20, 3));

          If StringIsAlphabetic(sBlock)
          then TempSwisSBLKey := Take(2, sSection) + ShiftRightAddBlanks(Take(3, Trim(sBlock)))
          else TempSwisSBLKey := sSection + Trim(sBlock);

          If _Compare(sSublot, coBlank)
          then TempSwisSBLKey := TempSwisSBLKey + '  0' + sLot
          else TempSwisSBLKey := TempSwisSBLKey + ShiftRightAddZeroes(DezeroOnLeft(sLot), 2) + ShiftRightAddZeroes(sSubLot, 4);

          TempSwisSBLKey := TempSwisSBLKey + '0';

        end;  {If bNassauFormat}

          {CHG07132001-1: Allow searching subdirectories and picture masks.}

        If (DocumentType = dtPicture)
          then
            begin
              If GlblSearchSubfoldersForPictures
                then
                  begin
                    ReturnCode := FindFirst(ExpandPASPath(Directory) + TempSwisSBLKey,
                                            faDirectory, TempFile);

                    If (ReturnCode = 0)
                      then
                        begin
                          CurrentDirectory := ExpandPASPath(Directory) + TempFile.Name + '\';
                          ChDir(CurrentDirectory);
                        end
                      else Continue := False;

                  end;  {If GlblSearchSubfoldersForPictures}

            end
          else
            begin
              If GlblSearchSubfoldersForDocuments
                then
                  begin
                    ReturnCode := FindFirst(ExpandPASPath(Directory) + TempSwisSBLKey,
                                            faDirectory, TempFile);

                    If (ReturnCode = 0)
                      then
                        begin
                          CurrentDirectory := ExpandPASPath(Directory) + TempFile.Name + '\';
                          ChDir(CurrentDirectory);
                        end
                      else Continue := False;

                  end;  {If GlblSearchSubfoldersForDocuments}

            end;  {else of If (DocumentType = dtPicture)}

        If Continue
          then
            begin
              If (DocumentType = dtPicture)
                then InitialFileName := CurrentDirectory + TempSwisSBLKey +
                                        GlblPictureMask + '*.*'
                else InitialFileName := CurrentDirectory + TempSwisSBLKey +
                                        GlblDocumentMask + '*.*';

              ReturnCode := FindFirst(InitialFileName, faAnyFile, TempFile);

                {FXX06272001-1: Prevent 90.13-1-22.A from being detected for 90.13-1-2, etc.}

              while (ReturnCode = 0) do
                begin
                  ProcessThisItem := True;

                    {Not a directory name.}

                  If ((TempFile.Name = '.') or
                      (TempFile.Name = '..'))
                    then ProcessThisItem := False;

                    {Now check to make sure that it is not a similar name,
                     i.e. 90.13-2-22.A when we are searching for 90.13-2-2.
                     However, we will allow 90.13-2-2A.}

                  If ProcessThisItem
                    then
                      begin
                        EndingStr := Copy(TempFile.Name, (Length(TempSwisSBLKey) + 1), 200);

                          {FXX02102005-1(2.8.3.6): Need to be able to differentiate between
                                                   01.01.6 with an extension of A and
                                                   01.01.6A. To do this, they will put a ^ at the
                                                   end of the parcel ID.}

                        If (_Compare(Length(TempSwisSBLKey), 26, coNotEqual) and
                            (((Deblank(EndingStr) <> '') and
                              (EndingStr[1] in Numbers)) or
                             (Pos('^', EndingStr) > 1)))
                          then ProcessThisItem := False;

                      end;  {If ProcessThisItem}

                    {CHG07092005-1(2.8.5.5): Much like the above option, but selected via a check box.}

                  If (ProcessThisItem and
                      ExactParcelIDMatchOnly)
                    then
                      begin
                        ProcessThisItem := False;

                          {Only if the next character is a period (i.e. the start of the extension)
                           should it be processed.}

                        NextCharacterPosAfterSwisSBLKey := (Length(TempSwisSBLKey) + 1);
                        try
                          If (_Compare(Pos('.jpg', TempFile.Name), NextCharacterPosAfterSwisSBLKey, coEqual) or
                              _Compare(Pos('.tif', TempFile.Name), NextCharacterPosAfterSwisSBLKey, coEqual) or
                              _Compare(Pos('(', TempFile.Name), NextCharacterPosAfterSwisSBLKey, coEqual) or
                              _Compare(Pos(' ', TempFile.Name), NextCharacterPosAfterSwisSBLKey, coEqual))
                            then ProcessThisItem := True;
                        except
                        end;

                      end;  {If (ProcessThisItem and ...}

                    {FXX01112006-1(2.9.4.9): Fix problem of 71.9-1-9.-64C.jpg being loaded on
                                             to both the base lot and the condo unit.}   

                  CaratPos := Pos('^', TempFile.Name);
                  If ((not ProcessThisItem) and
                      _Compare(CaratPos, 0, coGreaterThan) and
                      _Compare(Copy(TempFile.Name, 1, (CaratPos - 1)), TempSwisSBLKey, coEqual))
                    then ProcessThisItem := True;

                  If ProcessThisItem
                    then
                      begin
                        New(DocumentListPtr);

                        DocumentListPtr^.FileName := CurrentDirectory + TempFile.Name;
                        DocumentListPtr^.AlreadyOnFile := False;

                          {CHG01272003-2: Option to use the ending part of the picture name as a note.}

                        If UseLastPartOfFileNameForNotes
                          then
                            begin
                              EndingStr := RemoveExtension(EndingStr);
                              DocumentListPtr^.Notes := EndingStr;
                            end
                          else DocumentListPtr^.Notes := '';

                        ItemNameList.Add(DocumentListPtr);

                      end;  {If ((TempFile.Name <> '.') and ...}

                  ReturnCode := FindNext(TempFile);

                end;  {while (ReturnCode = 0) do}

            end;  {If Continue}

      end;  {If (Deblank(ConvertSwisSBLToDashDotNoSwis(SwisSBLKey)) <> '')}

(*  FindClose(TempFile);*)

end;  {GetItemFileList}

{====================================================================}
Procedure RenumberPicturesOrDocuments(TempTable : TTable;
                                      ItemNumberFieldName : String;
                                      Increment : Integer);

var
  Done, FirstTimeThrough : Boolean;

begin
  Done := False;
  FirstTimeThrough := True;

  TempTable.Last;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else TempTable.Prior;

    If TempTable.BOF
      then Done := True;

    If not Done
      then
        with TempTable do
          try
            Edit;
            FieldByName(ItemNumberFieldName).AsInteger := FieldByName(ItemNumberFieldName).AsInteger + Increment;
            Post;
          except
            MessageDlg('Error renumbering picture #' + FieldByName(ItemNumberFieldName).Text +
                       ' for parcel ' + FieldByName('SwisSBLKey').Text + '.',
                       mtError, [mbOK], 0);
          end;

  until Done;

end;  {RenumberPicturesOrDocuments}

{====================================================================}
Procedure DetectNewPicturesOrDocuments(_SwisSBLKey : String;
                                       SearchDirectory : String;
                                       DocumentType : Integer;
                                       AutoAdd : Boolean;
                                       ItemsAdded : TStringList;
                                       AlreadyOnFileList : TStringList;
                                       UseLastPartOfFileNameForNotes,
                                       LoadAtTopOfPictureList : Boolean;
                                       ExactParcelIDMatchOnly : Boolean;
                                       sAccountNumber : String;
                                       sPrintKey : String);


var
  TempTable : TTable;
  SelectedItemsList, ItemList : TList;
  SaveItems,Done, FirstTimeThrough : Boolean;
  I, NextItemNo, ItemsToAdd : Integer;
  LabelName, LocationFieldName, ItemNumberFieldName : String;
  SelectedPicsOrDocsPtr : SelectedPicsOrDocsPointer;

begin
  TempTable := nil;
  case DocumentType of
    dtPicture :
      begin
        TempTable := PASDataModule.PictureTable;
        LabelName := 'picture';
        LocationFieldName := 'PictureLocation';
        ItemNumberFieldName := 'PictureNumber';

      end;  {dtPicture}

    dtScannedImage,
    dtMSWord,
    dtExcel :
      begin
        TempTable := PASDataModule.DocumentTable;
        LocationFieldName := 'DocumentLocation';

          {FXX07102001-2: DocumentNumber field was missing.}

        ItemNumberFieldName := 'DocumentNumber';

        case DocumentType of
          dtScannedImage : LabelName := 'scanned image';
          dtMSWord : LabelName := 'MS Word document';
          dtExcel : LabelName := 'Excel document';

        end;  {case DocumentType of}

      end;  {dtScannedImage}

      {CHG04282005-1(2.8.4.3)[2114]: Create autoload for sketches.}

    dtApexSketch :
      begin
        TempTable := PASDataModule.SketchTable;
        LabelName := 'sketch';
        LocationFieldName := 'SketchLocation';
        ItemNumberFieldName := 'SketchNumber';
      end;  {dtApexSketch}

    dtPropertyCard :
      begin
        TempTable := PASDataModule.PropertyCardTable;
        LocationFieldName := 'DocumentLocation';

          {FXX07102001-2: DocumentNumber field was missing.}

        ItemNumberFieldName := 'DocumentNumber';
        LabelName := 'property card';

      end;  {dtPropertyCard}

    dtCertiorari :
      begin
        TempTable := PASDataModule.tb_CertiorariDocument;

          {The certiorari documents table is not automatically opened because
           some municipalities do not have the grievance package.}

        If not TempTable.Active
          then
            begin
              TempTable.TableName := CertiorariDocumentsTableName;
              TempTable.Open;
            end;

        LabelName := 'certiorari document';
        LocationFieldName := 'DocumentLocation';
        ItemNumberFieldName := 'DocumentNumber';

      end;  {dtCertiorari}

  end;  {case DocumentType of}

    {See what pictures \ documents are already on file.}

  TempTable.CancelRange;
  ItemList := TList.Create;
  AlreadyOnFileList.Clear;

  with TempTable do
    begin
      GetItemFileList(ItemList, SearchDirectory, DocumentType, _SwisSBLKey,
                      UseLastPartOfFileNameForNotes, True, False, False,
                      ExactParcelIDMatchOnly, '', '', False, False, False, False, False);

        {CHG08042003-1(2.07h): Search for SBL without swis code if the picture
                               can't be found with it.}

      If (ItemList.Count = 0)
        then GetItemFileList(ItemList, SearchDirectory, DocumentType, _SwisSBLKey,
                             UseLastPartOfFileNameForNotes, False, False, False,
                             ExactParcelIDMatchOnly, '', '', False, False, False, False, False);

        {CHG04282005-2(2.8.4.3): If still no items found, then try the swis sbl without leading
                                 zeroes on the segments.  This is for Scarsdale - i.e. instead of
                                 11.01.01, try 11.11.1.}

      If (ItemList.Count = 0)
        then GetItemFileList(ItemList, SearchDirectory, DocumentType, _SwisSBLKey,
                             UseLastPartOfFileNameForNotes, False, True, False,
                             ExactParcelIDMatchOnly, '', '', False, False, False, False, False);

        {CHG05202005-1(2.8.4.5): Add one more try to accomodate General Code's Eastchester format.}

      If (ItemList.Count = 0)
        then GetItemFileList(ItemList, SearchDirectory, DocumentType, _SwisSBLKey,
                             UseLastPartOfFileNameForNotes, False, False, True,
                             ExactParcelIDMatchOnly, '', '', False, False, False, False, False);

        {CHG02042009-1(2.17.1.1): Detect by raw SBL.}

      If (ItemList.Count = 0)
        then GetItemFileList(ItemList, SearchDirectory, DocumentType, _SwisSBLKey,
                             UseLastPartOfFileNameForNotes, False, False, False,
                             ExactParcelIDMatchOnly, '', '', False, True, False, False, False);

        {CHG12032008-1(2.16.1.7): Detect by account #.}

      If ((ItemList.Count = 0) and
          GlblDetectPicturesByAccountNumber)
        then GetItemFileList(ItemList, SearchDirectory, DocumentType, _SwisSBLKey,
                             UseLastPartOfFileNameForNotes, False, False, False,
                             ExactParcelIDMatchOnly, sAccountNumber, '', True, False, False, False, False);

        {Try it again without the last 2 chars. of the file name before the extension.}

      If (ItemList.Count = 0)
      then GetItemFileList(ItemList, SearchDirectory, DocumentType, _SwisSBLKey,
                             UseLastPartOfFileNameForNotes, False, False, False,
                             ExactParcelIDMatchOnly, '', sPrintKey, False, False, True, False, False);

        {Check Harrison cards.}

      If (ItemList.Count = 0)
      then GetItemFileList(ItemList, SearchDirectory, DocumentType, _SwisSBLKey,
                             UseLastPartOfFileNameForNotes, False, False, False,
                             ExactParcelIDMatchOnly, '', sPrintKey, False, False, True, True, False);

        {Check Nassau format.}

      If (ItemList.Count = 0)
      then GetItemFileList(ItemList, SearchDirectory, DocumentType, _SwisSBLKey,
                             UseLastPartOfFileNameForNotes, False, False, False,
                             ExactParcelIDMatchOnly, '', sPrintKey, False, False, False, false, True);



      SetRangeOld(TempTable, ['SwisSBLKey', ItemNumberFieldName],
                  [_SwisSBLKey, '0'], [_SwisSBLKey, '32000']);

      FirstTimeThrough := True;
      Done := False;

      TempTable.First;

      repeat
        If FirstTimeThrough
          then FirstTimeThrough := False
          else TempTable.Next;

        If TempTable.EOF
          then Done := True;

          {FXX04162003-1(2.07): Need to compare the file name returned by the directory search and
                                what is actually on file in all upper case.}

        If not Done
          then
            For I := 0 to (ItemList.Count - 1) do
              with DocumentListPointer(ItemList[I])^ do
                If (ANSIUpperCase(Trim(FileName)) = ANSIUpperCase(Trim(TempTable.FieldByName(LocationFieldName).Text)))
                  then
                    begin
                        {CHG01272003-1: Return what pictures were already on file.}

                      AlreadyOnFile := True;
                      AlreadyOnFileList.Add(FileName);
                    end;

      until Done;

    end;  {with TempTable do}

    {Now look for pictures that were not found.}

  SelectedItemsList := TList.Create;
  SaveItems := False;

  If AutoAdd
    then
      begin
        For I := 0 to (ItemList.Count - 1) do
          If not DocumentListPointer(ItemList[I])^.AlreadyOnFile
            then
              begin
                SaveItems := True;
                New(SelectedPicsOrDocsPtr);

                with SelectedPicsOrDocsPtr^ do
                  begin
(*                    FileName := StripPath(DocumentListPointer(ItemList[I])^.FileName);*)

                      {FXX08172002-2: The DirectoryName was not being filled in.}

                    DirectoryName := ReturnPath(DocumentListPointer(ItemList[I])^.FileName);
                    FileName := DocumentListPointer(ItemList[I])^.FileName;

                      {CHG01272003-2: Option to use the ending part of the picture name as a note.}

                    Notes := DocumentListPointer(ItemList[I])^.Notes;

                  end;  {with SelectedPicsOrDocsPtr^ do}

                SelectedItemsList.Add(SelectedPicsOrDocsPtr);

              end;  {If not DocumentListPointer(ItemList[I])^.AlreadyOnFile}

      end
    else
      begin
          {FXX11072002-1: Don't invoke the picture dialog unless we know there are
                          items to add.}

        ItemsToAdd := 0;
        For I := 0 to (ItemList.Count - 1) do
          with DocumentListPointer(ItemList[I])^ do
            If not AlreadyOnFile
              then ItemsToAdd := ItemsToAdd + 1;

        If (ItemsToAdd > 0)
          then
            try
              LoadPicturesOrDocumentsDialog := TLoadPicturesOrDocumentsDialog.Create(nil);

              with LoadPicturesOrDocumentsDialog do
                begin
                     {First see if there are any items to be added.}

                  For I := 0 to (ItemList.Count - 1) do
                    with DocumentListPointer(ItemList[I])^ do
                      If not AlreadyOnFile
                        then AddItem(DocumentListPointer(ItemList[I])^.FileName);

                  If (OriginalItemList.Count = 0)
                    then Close
                    else
                      begin
                        SwisSBLKey := _SwisSBLKey;
                        ItemType := DocumentType;
                        ItemTypeStr := LabelName;

                        InitializeForm;

                        If (ShowModal = idOK)
                          then
                            begin
                              GetSelectedItems(SelectedItemsList);

                              If (SelectedItemsList.Count > 0)
                                then SaveItems := True;

                            end;  {If (ShowModal = idOK)}

                      end;  {If (ItemList.Count > 0)}

                end;  {with LoadPicturesOrDocumentsDialog do}

            except
              LoadPicturesOrDocumentsDialog.Free;
            end;

      end;  {else of If AutoAdd}

  If SaveItems
    then
      For I := 0 to (SelectedItemsList.Count - 1) do
        with SelectedPicsOrDocsPointer(SelectedItemsList[I])^ do
          begin
            TempTable.Last;

              {FXX07272004-1(2.08.0.07272004): If loading at the top of the picture list,
                                               need to make sure the item number is 1.}

            If ((TempTable.FieldByName('SwisSBLKey').Text = '') or
                LoadAtTopOfPictureList)
              then NextItemNo := 1
              else NextItemNo := TempTable.FieldByName(ItemNumberFieldName).AsInteger + 1;

              {CHG06032004-1(2.07l5): Option to number pictures so they appear at the top of the list.}

            If LoadAtTopOfPictureList
              then RenumberPicturesOrDocuments(TempTable, ItemNumberFieldName, 1);

              {FXX08172002-3: The LocationFieldName should not include the directory
                              name since the FileName already has the directory name.}

            with TempTable do
              try
                Insert;
                FieldByName('SwisSBLKey').Text := _SwisSBLKey;
                FieldByName(ItemNumberFieldName).AsInteger := NextItemNo;
                FieldByName(LocationFieldName).Text := FileName;
                FieldByName('Date').AsDateTime := Date;

                  {FXX06032004-1(2.07l5): If there is just a '.', or there is 'jpg' or '.jpg',
                                          get rid of it.}

                If (Trim(Notes) = '.')
                  then Notes := '';

                Notes := StringReplace(Notes, 'jpg', '', [rfReplaceAll, rfIgnoreCase]);
                Notes := StringReplace(Notes, '.jpg', '', [rfReplaceAll, rfIgnoreCase]);
                FieldByName('Notes').Text := Notes;

                  {CHG11192002-1: Default visible to searcher to true for scanned images.}

                If (DocumentType = dtScannedImage)
                  then
                    try
                      FieldByName('VisibleToSearcher').AsBoolean := True;
                    except
                    end;

                Post;

                If AutoAdd
                  then ItemsAdded.Add(FileName);
              except
                Cancel;
                SystemSupport(917, TempTable, 'Error inserting item record.',
                              'PASUTILS', GlblErrorDlgBox);
              end;

          end;  {For I := 0 to (SelectedItemsList.Count - 1) do}

  FreeTList(ItemList, SizeOf(DocumentListRecord));
  FreeTList(SelectedItemsList, SizeOf(SelectedPicsOrDocsRecord));

end;  {DetectNewPicturesOrDocuments}

{===============================================================}
Function GetLegalAddressInt(sLegalAddrNo : String) : Integer;

{CHG03042001-1: Look up by LegalAddrInt instead of the text addr #.}

var
  sTempStr : String;
  I: Integer;
  bNonNumberFound : Boolean;

begin
  sTempStr := '';
  bNonNumberFound := False;

  For I := 1 to Length(sLegalAddrNo) do
    If (sLegalAddrNo[I] in ['0'..'9'])
      then
        begin
          If not bNonNumberFound
            then sTempStr := sTempStr + sLegalAddrNo[I];

        end
      else bNonNumberFound := True;

  If (Trim(sTempStr) = '')
    then Result := 0
    else
      try
        Result := StrToInt(sTempStr);
      except
        Result := 0;
      end;

end;  {GetLegalAddressInt}

{========================================================}
Procedure SetExtractFlags(SwisSBLKey : String);

{CHG03302000-1: Expand the capabilites of the extract.}

var
  NYParcelTable : TTable;
  Found, Quit : Boolean;
  SBLRec : SBLRecord;

begin
  NYParcelTable := TTable.Create(nil);
  OpenTableForProcessingType(NYParcelTable, ParcelTableName, NextYear, Quit);

  NYParcelTable.IndexName := 'BYTAXROLLYR_SWISSBLKEY';

  SBLRec := ExtractSwisSBLFromSwisSBLKey(SwisSBLKey);

  with SBLRec do
    Found := FindKeyOld(NYParcelTable,
                        ['TaxRollYr', 'SwisCode',
                         'Section', 'Subsection',
                         'Block', 'Lot', 'Sublot', 'Suffix'],
                        [GlblNextYear, SwisCode, Section,
                         SubSection, Block, Lot, Sublot, Suffix]);

    {FXX04172002-1: It should not be an error if the parcel exists in TY
                    but not NY.}

  If Found
    then
      with NYParcelTable do
        try
          Edit;
          FieldByName('ChangeExtracted').AsBoolean := False;
          FieldByName('DateChangedForExtract').AsDateTime := Date;
          Post;
        except
          SystemSupport(919, NYParcelTable, 'Error marking parcel updated.',
                        'PASUTILS', GlblErrorDlgBox);
        end;

  NYParcelTable.Close;
  NYParcelTable.Free;

end;  {SetExtractFlags}

{===============================================================}
Function StripMunicipalityType(MunicipalityName : String) : String;

{Given a municipality name such as 'CITY OF RYE', strip 'CITY OF '.}

begin
  Result := StringReplace(MunicipalityName, 'CITY OF ', '', [rfIgnoreCase]);
  Result := StringReplace(Result, 'TOWN OF ', '', [rfIgnoreCase]);
  Result := StringReplace(Result, 'VILLAGE OF ', '', [rfIgnoreCase]);

end;  {StripMunicipalityType}


{===============================================================}
Procedure GetLegalNameAddress(    ParcelTable,
                                  SwisCodeTable : TTable;
                              var LegalNameAddrArray : NameAddrArray;
                                  UseZipCodeFromSwis : Boolean);

{Make up the address using the legal address, village name and zip of the swis
 they are in.}

var
  ZipCode : String;

begin
  FindKeyOld(SwisCodeTable, ['SwisCode'],
             [ParcelTable.FieldByName('SwisCode').Text]);

  If UseZipCodeFromSwis
    then ZipCode := SwisCodeTable.FieldByName('ZipCode').Text
    else ZipCode := '';

  with ParcelTable do
    FillInNameAddrArray(FieldByName('Name1').Text,
                        FieldByName('Name2').Text,
                        '', '',
                        GetLegalAddressFromTable(ParcelTable),
                        Trim(StripMunicipalityType(SwisCodeTable.FieldByName('MunicipalityName').Text)),
                        'NY',
                        ZipCode, '',
                        False, False, LegalNameAddrArray);

end;  {GetLegalNameAddress}

{===============================================================}
Function MailingAndLegalAddressEqual(ParcelTable : TTable;
                                     SwisCodeTable : TTable) : Boolean;

{See if the mailing address and complete legal address (i.e. name 1&2,
 legal address, swis name and zip) match.  Note that we ignore the zipPlus4.}

var
  Index : Integer;
  MailingNameAddrArray,
  LegalNameAddrArray : NameAddrArray;
  TempAddress, LegalAddress : String;

begin
  with ParcelTable do
    FillInNameAddrArray(FieldByName('Name1').Text,
                        FieldByName('Name2').Text,
                        FieldByName('Address1').Text,
                        FieldByName('Address2').Text,
                        FieldByName('Street').Text,
                        FieldByName('City').Text,
                        FieldByName('State').Text,
{                        FieldByName('Zip').Text,
                        FieldByName('ZipPlus4').Text,}'','',  {For now, leave zip blank.}
                        False, False, MailingNameAddrArray);

  GetLegalNameAddress(ParcelTable, SwisCodeTable, LegalNameAddrArray, False);

  LegalAddress := Trim(GetLegalAddressFromTable(ParcelTable));

    {If the last character is a period as in AVE., remove it.}

  If (LegalAddress[Length(LegalAddress)] = '.')
    then Delete(LegalAddress, Length(LegalAddress), 1);
  LegalAddress := ExpandAddress(LegalAddress);

  Result := False;

    {CHG5202002-1: Smarten up the comparison algorithm.}
    {Compare each line of the mailing address to the legal address - we are assuming
     that if the mailing address contains the legal address exactly (allowing for
     differences such as RD vs. ROAD, etc., then it is owner occupied.}

  For Index := 1 to 6 do
    If (Deblank(MailingNameAddrArray[Index]) <> '')
      then
        If (Take(30, MailingNameAddrArray[Index]) = Take(30, LegalAddress))
          then Result := True
          else
            begin
              TempAddress := Trim(MailingNameAddrArray[Index]);

                {If the last character is a period as in AVE., remove it.}

              If (TempAddress[Length(TempAddress)] = '.')
                then Delete(TempAddress, Length(TempAddress), 1);

                {Now look for certain abbreviations in both strings and
                 expand them, i.e. 'ST', 'RD', 'DR', 'CIR', 'CT'}

              TempAddress := ExpandAddress(TempAddress);

              If (Take(50, LegalAddress) = Take(50, TempAddress))
                then Result := True;

            end;  {else ofIf ((Deblank(MailingNameAddrArray[Index]) <> '')}

end;  {MailingAndLegalAddressEqual}

{============================================================}
Function CalculateSquareFootLivingArea(ResidentialBuildingTable : TTable) : Integer;

begin
  with ResidentialBuildingTable do
    begin
      Result := FieldByName('FirstStoryArea').AsInteger +
                FieldByName('SecondStoryArea').AsInteger +
                FieldByName('ThirdStoryArea').AsInteger +
                FieldByName('HalfStoryArea').AsInteger +
                FieldByName('ThreeQuarterStoryAre').AsInteger +
                FieldByName('FinishedAreaOverGara').AsInteger +
                FieldByName('FinishedAtticArea').AsInteger;

        {Include the finished basement area for raised ranches and
         split levels.}
        {CHG08032004-1(2.08.0.08042004): Add option to include finished basement in SFLA.}

      try
        If (GlblIncludeFinishedBasementAreaInSFLA or
            (FieldByName('BuildingStyleCode').AsInteger = 2) or
            (FieldByName('BuildingStyleCode').AsInteger = 3))
          then Result := Result +
                         FieldByName('FinishedBasementArea').AsInteger;
      except
      end;

        {CHG07172004-1(2.08): Add system option to subtract out any unfinished areas.}

      try
        If GlblSubtractUnfinishedArea
          then Result := Result -
                         FieldByName('UnfinishedHalfStory').AsInteger -
                         FieldByName('Unfinished3_4Story').AsInteger -
                         FieldByName('UnfinishedRoom').AsInteger;
      except
      end;

    end;  {with ResidentialBuildingTable do}

end;  {CalculateSquareFootLivingArea}

{==================================================================================}
Function NameAddressesDifferent(NameAddrArray1,
                                NameAddrArray2 : NameAddrArray;
                                StripCommas : Boolean) : Boolean;

var
  I : Integer;
  NameAddr1, NameAddr2 : String;

begin
  Result := False;

  For I := 1 to 6 do
    begin
      NameAddr1 := NameAddrArray1[I];
      NameAddr2 := NameAddrArray2[I];

        {Remove the blanks.}

      NameAddr1 := StringReplace(NameAddr1, ' ', '', [rfReplaceAll]);
      NameAddr2 := StringReplace(NameAddr2, ' ', '', [rfReplaceAll]);

      If StripCommas
        then
          begin
            NameAddr1 := StringReplace(NameAddr1, ',', '', [rfReplaceAll]);
            NameAddr2 := StringReplace(NameAddr2, ',', '', [rfReplaceAll]);
          end;

      If (Trim(NameAddr1) <> Trim(NameAddr2))
        then Result := True;

    end;  {For I := 1 to 6 do}

end;  {NameAddressesDifferent}

{========================================================}
Procedure PrintLabelParcelID_Class(    SwisSBLKey : String;
                                   var NAddrArray : NameAddrArray;
                                       PrintClass : Boolean;
                                       PrintSwisCodeOnParcelIDs : Boolean;
                                       PropertyClass : String);

{CHG03261999-1: Let them print parcel ID and class on the first line.}

var
  I : Integer;
  TempStr : String;

begin
  For I := 6 downto 2 do
    NAddrArray[I] := NAddrArray[I-1];

   {CHG06092000-1: Print new/old labels.  Also option of whether or not to print
                        the swis code on the parcel id.}

  If PrintSwisCodeOnParcelIDs
    then TempStr := ConvertSwisSBLToDashDot(SwisSBLKey)
    else TempStr := ConvertSBLOnlyToDashDot(Copy(SwisSBLKey, 7, 20));

   {CHG07272001-1: Allow for the first line to be parcel ID only.}

  If PrintClass
    then NAddrArray[1] := TempStr + '  ' + PropertyClass
    else NAddrArray[1] := TempStr;

end;  {PrintLabelParcelID_Class}

{========================================================}
Procedure PrintLabelAccountNumber_OldID(var NAddrArray : NameAddrArray;
                                            AccountNumber : String;
                                            OldParcelID : String);

var
  I : Integer;

begin
  For I := 6 downto 2 do
    NAddrArray[I] := NAddrArray[I-1];

  NAddrArray[1] := Trim(AccountNumber) + '\' + OldParcelID;

end;  {PrintLabelParcelID_Class}

{========================================================}
Procedure PrintLabelOldAndNewParcelID(    SwisSBLKey : String;
                                      var NAddrArray : NameAddrArray;
                                          ParcelTable : TTable;
                                          AssessmentYearControlTable : TTable;
                                          PrintSwisCodeOnParcelIDs : Boolean;
                                          ShortForm : Boolean);

{Print the new parcel ID on the first line and the old on the second.}

var
  I, Index : Integer;
  TempStr : String;
  SBLRec : SBLRecord;

begin
  For I := 1 to 6 do
    NAddrArray[I] := '';

  If PrintSwisCodeOnParcelIDs
    then TempStr := ConvertSwisSBLToDashDot(SwisSBLKey)
    else TempStr := ConvertSBLOnlyToDashDot(Copy(SwisSBLKey, 7, 20));

  NAddrArray[1] := 'New: ' + TempStr;

  SBLRec := ExtractSwisSBLFromSwisSBLKey(SwisSBLKey);

  with SBLRec do
    FindKeyOld(ParcelTable,
               ['TaxRollYr', 'SwisCode', 'Section',
                'Subsection', 'Block', 'Lot', 'Sublot',
                'Suffix'],
               [ParcelTable.FieldByName('TaxRollYr').Text, SwisCode,
                Section, Subsection, Block, Lot, Sublot, Suffix]);

  TempStr := ConvertSwisSBLToOldDashDotNoSwis(ParcelTable.FieldByName('RemapOldSBL').Text,
                                              AssessmentYearControlTable);

  If PrintSwisCodeOnParcelIDs
    then TempStr := Copy(SwisSBLKey, 5, 2) + '/' + TempStr;

  NAddrArray[2] := 'Old: ' + TempStr;
  Index := 3;

    {CHG01022003-1(MDT): Add the owner name, legal addr and school code.}
    {CHG07232003-1(2.07g): Option to print old \ new labels that only have old and new ID, legal addr.}

  with ParcelTable do
    begin
      If not ShortForm
        then
          begin
            NAddrArray[Index] := FieldByName('Name1').Text;
            Index := Index + 1;
          end;

(*      If (Deblank(FieldByName('Name2').Text) <> '')
        then
          begin
            NAddrArray[Index] := FieldByName('Name2').Text;
            Index := Index + 1;
          end; *)

      NAddrArray[Index] := GetLegalAddressFromTable(ParcelTable);
      Index := Index + 1;

      If not ShortForm
        then NAddrArray[Index] := 'SCHOOL: ' + FieldByName('SchoolCode').Text;

    end;  {with ParcelTable do}

end;  {PrintLabelOldAndNewParcelID}

{============================================================================}
Procedure PrintLabelAcctNum_Addr_OldID_ParcelID(    SwisSBLKey : String;
                                                var NAddrArray : NameAddrArray;
                                                    ParcelTable : TTable;
                                                    PrintSwisCodeOnParcelIDs : Boolean);

{CHG12082004-3(2.8.1.2)[2016]: New label format.}

var
  I : Integer;
  TempStr : String;

begin
  For I := 1 to 6 do
    NAddrArray[I] := '';

  _Locate(ParcelTable, [ParcelTable.FieldByName('TaxRollYr').Text, SwisSBLKey],
          ParcelTable.IndexName, [loParseSwisSBLKey]);

  with ParcelTable do
    begin
      If PrintSwisCodeOnParcelIDs
        then TempStr := ConvertSwisSBLToDashDot(SwisSBLKey)
        else TempStr := ConvertSBLOnlyToDashDot(Copy(SwisSBLKey, 7, 20));

      NAddrArray[2] := Take(15, TempStr) + ' ' + FieldByName('AccountNo').Text;
      NAddrArray[4] := GetLegalAddressFromTable(ParcelTable);
      NAddrArray[6] := FieldByName('RemapOldSBL').Text;

    end;  {with ParcelTable do}

end;  {PrintLabelAcctNum_Addr_OldID_ParcelID}

{============================================================================}
Procedure PrintOwner_ExemptionCode_LegalAddress_PrintKey(    SwisSBLKey : String;
                                                         var NAddrArray : NameAddrArray;
                                                             ParcelTable : TTable;
                                                             ExemptionCode : String;
                                                             PrintSwisCodeOnParcelIDs : Boolean);

var
  I : Integer;
  TempStr : String;

begin
  For I := 1 to 6 do
    NAddrArray[I] := '';

  _Locate(ParcelTable, [ParcelTable.FieldByName('TaxRollYr').Text, SwisSBLKey],
          ParcelTable.IndexName, [loParseSwisSBLKey]);

  with ParcelTable do
    begin
      If PrintSwisCodeOnParcelIDs
        then TempStr := ConvertSwisSBLToDashDot(SwisSBLKey)
        else TempStr := ConvertSBLOnlyToDashDot(Copy(SwisSBLKey, 7, 20));

      NAddrArray[1] := FieldByName('Name1').AsString;
      NAddrArray[2] := GetLegalAddressFromTable(ParcelTable);
      NAddrArray[3] := ExemptionCode;
      NAddrArray[5] := TempStr;

    end;  {with ParcelTable do}

end;  {PrintOwner_ExemptionCode_LegalAddress_PrintKey}

{============================================================================}
Procedure PrintOwner_LegalAddress_PrintKey(    SwisSBLKey : String;
                                           var NAddrArray : NameAddrArray;
                                               ParcelTable : TTable;
                                               PrintSwisCodeOnParcelIDs : Boolean);

var
  I : Integer;
  TempStr : String;

begin
  For I := 1 to 6 do
    NAddrArray[I] := '';

  _Locate(ParcelTable, [ParcelTable.FieldByName('TaxRollYr').Text, SwisSBLKey],
          ParcelTable.IndexName, [loParseSwisSBLKey]);

  with ParcelTable do
    begin
      If PrintSwisCodeOnParcelIDs
        then TempStr := ConvertSwisSBLToDashDot(SwisSBLKey)
        else TempStr := ConvertSBLOnlyToDashDot(Copy(SwisSBLKey, 7, 20));

      NAddrArray[1] := FieldByName('Name1').AsString;
      NAddrArray[2] := GetLegalAddressFromTable(ParcelTable);
      NAddrArray[3] := TempStr;

    end;  {with ParcelTable do}

end;  {PrintOwner_LegalAddress_PrintKey}

{============================================================================}
Procedure GetLabelListForParcelList(LabelList : TList;
                                    ParcelListForLabels : TStringList;
                                    ParcelTable : TTable;
                                    SwisCodeTable : TTable;
                                    AssessmentYearControlTable : TTable;
                                    AssessmentYear : String;
                                    LabelOptions : TLabelOptions);

var
  Name2FilledIn, AddToList : Boolean;
  SwisSBLKey : String;
  PSwisSBLKey : PSwisSBLKeyType;
  I, Index, StartIndex : Integer;
  PNAddrArray : PNameAddrArray;

begin
  ParcelTable.IndexName := 'BYTAXROLLYR_SWISSBLKEY';

  with LabelOptions do
    For Index := 0 to (ParcelListForLabels.Count - 1) do
      begin
        SwisSBLKey := ParcelListForLabels[Index];

        If _Locate(ParcelTable, [AssessmentYear, SwisSBLKey], '', [loParseSwisSBLKey])
          then
            begin
              If (LabelType = lbLaser1Liner)
                then
                  begin
                    New(PSwisSBLKey);
                    If (lb_PrintSwisCodeOnParcelIDs in LabelFormatOptions)
                      then PSwisSBLKey^ := ConvertSwisSBLToDashDot(SwisSBLKey)
                      else PSwisSBLKey^ := ConvertSBLOnlyToDashDot(Copy(SwisSBLKey, 7, 20));

                    LabelList.Add(PSwisSBLKey);
                  end
                else
                  begin
                    New(PNAddrArray);
                    GetNameAddress(ParcelTable, PNAddrArray^);

                    If (lb_ResidentLabels in LabelFormatOptions)
                      then
                        begin
                          Name2FilledIn := (Deblank(ParcelTable.FieldByName('Name2').Text) <> '');

                          PNAddrArray^[1] := 'RESIDENT';

                            {If name 2 is filled in then move everything from
                             the 3rd line up one since 'RESIDENT' replaces the
                             name.  So, we are assuming the 2nd line is name
                             info and not address.}

                          If Name2FilledIn
                            then
                              begin
                                For I := 3 to 6 do
                                  PNAddrArray^[I-1] := PNAddrArray^[I];

                                PNAddrArray^[6] := '';

                              end;  {If Name2FilledIn}

                        end;  {If lb_ResidentLabels}

                    If (lb_LegalAddressLabels in LabelFormatOptions)
                      then
                        begin
                            {FXX05222004-1(2.07l4): If resident and legal address labels, do 'Resident'
                                                    on line 1, legal addr on line 2 and then city info on
                                                    line 3.}

                          If (lb_ResidentLabels in LabelFormatOptions)
                            then
                              begin
                                PNAddrArray^[1] := 'RESIDENT';
                                StartIndex := 2;
                              end
                            else
                              begin
                                Name2FilledIn := (Deblank(ParcelTable.FieldByName('Name2').Text) <> '');

                                If Name2FilledIn
                                  then StartIndex := 3
                                  else StartIndex := 2;

                              end;  {else of If lb_ResidentLabels}

                            {Clear out everything after the name.}

                          For I := StartIndex to 6 do
                            PNAddrArray^[I] := '';

                          PNAddrArray^[StartIndex] := GetLegalAddressFromTable(ParcelTable);

                            {CHG12192008-1: Legal city \ zip.}

                          If (ParcelTable.FindField('LegalCity') = nil)
                            then
                              begin
                                FindKeyOld(SwisCodeTable, ['SwisCode'], [ParcelTable.FieldByName('SwisCode').Text]);

                                with SwisCodeTable do
                                  PNAddrArray^[StartIndex + 1] := Trim(FieldByName('MunicipalityName').Text) +
                                                                  ', NY ' +
                                                                  FieldByName('ZipCode').Text;
                              end
                            else PNAddrArray^[StartIndex + 1] := Trim(ParcelTable.FieldByName('LegalCity').AsString) +
                                                                 ', NY ' +
                                                                 ParcelTable.FieldByName('LegalZip').AsString;

                        end;  {If LegalAddressLabels}

                      {CHG07192000-1: Allow them to print labels with just parcel IDs.}

                    If (lb_PrintParcelIDOnly in LabelFormatOptions)
                      then
                        begin
                          For I := 1 to 6 do
                            PNAddrArray^[I] := '';

                          If (lb_PrintSwisCodeOnParcelIDs in LabelFormatOptions)
                            then PNAddrArray^[3] := ConvertSwisSBLToDashDot(SwisSBLKey)
                            else PNAddrArray^[3] := ConvertSBLOnlyToDashDot(Copy(SwisSBLKey, 7, 20));

                        end
                      else
                        begin
                            {FXX10182004-1(2.8.0.14): The option to print the parcel ID and
                                                      property class on the same line was not
                                                      working.}

                          If (lb_PrintParcelID_PropertyClass in LabelFormatOptions)
                            then PrintLabelParcelID_Class(SwisSBLKey, PNAddrArray^, True,
                                                          (lb_PrintSwisCodeOnParcelIDs in LabelFormatOptions),
                                                          ParcelTable.FieldByName('PropertyClassCode').Text);

                          If (lb_PrintParcelIDOnlyOnFirstLine in LabelFormatOptions)
                            then PrintLabelParcelID_Class(SwisSBLKey, PNAddrArray^, False,
                                                          (lb_PrintSwisCodeOnParcelIDs in LabelFormatOptions),
                                                          ParcelTable.FieldByName('PropertyClassCode').Text);

                          If (lb_PrintOldAndNewParcelIDs in LabelFormatOptions)
                            then PrintLabelOldAndNewParcelID(SwisSBLKey, PNAddrArray^,
                                                             ParcelTable,
                                                             AssessmentYearControlTable,
                                                             (lb_PrintSwisCodeOnParcelIDs in LabelFormatOptions),
                                                             False);

                          with ParcelTable do
                            If (lb_PrintAccountNumber_OldID in LabelFormatOptions)
                              then PrintLabelAccountNumber_OldID(PNAddrArray^,
                                                                 FieldByName('AccountNo').Text,
                                                                 FieldByName('RemapOldSBL').Text);

                        end;  {else of If PrintParcelIDOnly}

                      {CHG06262005-1(2.8.5.2)[2152]: Option to eliminate duplicate owners from label print.}

                    AddToList := True;
                    If (lb_EliminateDuplicateOwners in LabelFormatOptions)
                      then
                        For I := 0 to (LabelList.Count - 1) do
                          If OwnerNamesAndAddressEqual(PNAddrArray^,
                                                       PNameAddrArray(LabelList[I])^)
                            then AddToList := False;

                    If AddToList
                      then LabelList.Add(PNAddrArray);

                  end;  {else of If (LabelType = lbLaser1Liner}

            end;  {If _Locate(ParcelTable, ...}

      end;  {For Index := 0 to (ParcelListForLabels.Count - 1) do}

end;  {GetLabelListForParcelList}

{================================================================================}
Procedure PrintLabelHeader(Sender : TObject;
                           LabelOptions : TLabelOptions);

begin
  with Sender as TBaseReport, LabelOptions do
    begin
      If (LabelType <> lbDotMatrix)
        then
          begin
            GotoXY(0.3, LaserTopMargin);

            with Sender as TBaseReport do
              If (LabelType = lbLaser1Liner)
                then SetFont('Times New Roman', 14)
                else SetFont('Times New Roman', 10);

            If (lb_PrintLabelsBold in LabelFormatOptions)
              then Bold := True;

          end;  {If (LabelType = lbLaser5161)}

    end;  {with Sender as TBaseReport do}

end;  {PrintLabelHeader}

{================================================================================}
Procedure PrintLabels(Sender : TObject;
                      ParcelListForLabels : TStringList;
                      ParcelTable : TTable;
                      SwisCodeTable : TTable;
                      AssessmentYearControlTable : TTable;
                      AssessmentYear : String;
                      LabelOptions : TLabelOptions);

{Code to actually print one label.}

var
  Index, I, J, NumLinesToPrint, NumLabelsPrinted : Integer;
  TempSwisSBLKey, TempStr, SBLKey, TempFileName : String;
  TempNAddrArray1, TempNAddrArray2, TempNAddrArray3 : NameAddrArray;
  FirstLinePrinted : Boolean;
  LabelList : TList;
  ExtractFile : TextFile;

begin
  LabelList := TList.Create;
  GetLabelListForParcelList(LabelList, ParcelListForLabels,
                            ParcelTable, SwisCodeTable,
                            AssessmentYearControlTable,
                            AssessmentYear,
                            LabelOptions);

  with LabelOptions do
    If (FontSizeAdditionalLines = 0)
      then FontSizeAdditionalLines := 10;
  Index := 0;
  NumLabelsPrinted := 0;

  with Sender as TBaseReport, LabelOptions do
    while (Index <= (LabelList.Count - 1)) do
      begin
        FirstLinePrinted := True;
        If (LabelType = lbLaser1Liner)
          then
            begin
              TempSwisSBLKey := Take(26, PSwisSBLKeyType(LabelList[Index])^);
              SBLKey := Copy(TempSwisSBLKey, 7, 20);
              Index := Index + 1;
            end
          else
            begin
              For J := 1 to 6 do
                begin
                  TempNAddrArray1[J] := '';
                  TempNAddrArray2[J] := '';
                  TempNAddrArray3[J] := '';
                end;

                {Dot matrix labels, envelopes take 1 at a time.}
              TempNAddrArray1 := PNameAddrArray(LabelList[Index])^;
              Index := Index + 1;

                {5160 and 5161 have at least 2 labels across.}

              If ((Index <= (LabelList.Count - 1)) and
                  (LabelType in [lbLaser5160, lbLaser5161]))
                then
                  begin
                    TempNAddrArray2 := PNameAddrArray(LabelList[Index])^;
                    Index := Index + 1;
                  end;

                {5160 has three across.}

              If ((Index <= (LabelList.Count - 1)) and
                  (LabelType = lbLaser5160))
                then
                  begin
                    TempNAddrArray3 := PNameAddrArray(LabelList[Index])^;
                    Index := Index + 1;
                  end;

            end;  {else of If (LabelType = lbLaser1Liner)}

        If (LabelType = lbDotMatrix)
          then
            begin
              ClearTabs;
              SetTab(0.1, pjLeft, 4, 0, BOXLINENone, 0);   {Line}

              If (Take(3, TempNAddrArray1[1]) = 'XXX')  {Alignment label?}
                then TempStr := SBLKey
                else TempStr := ConvertSBLOnlyToDashDot(SBLKey);

              For I := 1 to 6 do
                TextPrintln(Sender, #9 + '    ' + Take(30, TempNAddrArray1[I]));

              TextPrintln(Sender, '');
              TextPrintln(Sender, '');

              For I := 9 to NumLinesPerLabel do  {To the end of the label}
                TextPrintln(Sender, '');

              NumLabelsPrinted := NumLabelsPrinted + 1;  {1 across}

            end;  {If (LabelType = lbDotMatrix)}

        If (LabelType = lbLaser5161)
          then
            begin
              ClearTabs;
              SetTab(0.3, pjLeft, 4, 0, BOXLINENone, 0);   {Column 1}
              SetTab(4.5, pjLeft, 4, 0, BOXLINENone, 0);   {Column 2}

              NumLinesToPrint := 6;

                {CHG07232000-1: Allow them to adjust the font size on the
                                parcel ID only labels.}

              If (lb_PrintParcelIDOnly in LabelFormatOptions)
                then
                  begin
                    SetFont('Courier New', SingleParcelFontSize);

                    If (lb_PrintLabelsBold in LabelFormatOptions)
                      then Bold := True;

                  end;  {If PrintParcelIDOnly}

                {CHG11172003-1(2.07k): Add a label format to accomodate printing parcel id \ legal address labels.}

              For I := 1 to NumLinesToPrint do
                begin
                  Println(#9 + Take(30, TempNAddrArray1[I]) +
                          #9 + Take(30, TempNAddrArray2[I]));

                    {We want to use the big font for the parcel ID and the regular font for the rest.}
                    {CHG12062003-3(2.07k1): Allow for different font size for additional lines on parcel ID only labels.}

                  If ((lb_PrintParcelIDOnly in LabelFormatOptions) and
                      (Deblank(TempNAddrArray1[I]) <> '') and
                      FirstLinePrinted)
                    then
                      begin
                        SetFont('Courier New', FontSizeAdditionalLines);
                        FirstLinePrinted := False;

                        If (lb_PrintLabelsBold in LabelFormatOptions)
                          then Bold := True;

                      end;  {If (PrintParcelIDOnly and ...}

                end;  {For I := 1 to NumLinesToPrint do}

              For I := 7 to NumLinesPerLabel do
                Println('');

              NumLabelsPrinted := NumLabelsPrinted + 2;  {2 across}

            end;  {If (LabelType = lbLaser5161)}

        If (LabelType = lbLaser5160)
          then
            begin
              ClearTabs;
              SetTab(0.3, pjLeft, 2.7, 0, BOXLINENone, 0);   {Column 1}
              SetTab(3.1, pjLeft, 2.7, 0, BOXLINENone, 0);   {Column 2}
              SetTab(5.9, pjLeft, 2.5, 0, BOXLINENone, 0);   {Column 3}

                {CHG07232000-1: Allow them to adjust the font size on the
                                parcel ID only labels.}

              If (lb_PrintParcelIDOnly in LabelFormatOptions)
                then
                  begin
                    SetFont('Courier New', SingleParcelFontSize);

                    If (lb_PrintLabelsBold in LabelFormatOptions)
                      then Bold := True;

                  end;  {If PrintParcelIDOnly}

              NumLinesToPrint := 6;

                {CHG11172003-1(2.07k): Add a label format to accomodate printing parcel id \ legal address labels.}

              For I := 1 to NumLinesToPrint do
                begin
                  Println(#9 + Take(27, TempNAddrArray1[I]) +
                          #9 + Take(27, TempNAddrArray2[I]) +
                          #9 + Take(27, TempNAddrArray3[I]));

                    {We want to use the big font for the parcel ID and the regular font for the rest.}
                    {CHG12062003-3(2.07k1): Allow for different font size for additional lines on parcel ID only labels.}

                  If ((lb_PrintParcelIDOnly in LabelFormatOptions) and
                      (Deblank(TempNAddrArray1[I]) <> '') and
                      FirstLinePrinted)
                    then
                      begin
                        SetFont('Courier New', FontSizeAdditionalLines);
                        FirstLinePrinted := False;

                        If (lb_PrintLabelsBold in LabelFormatOptions)
                          then Bold := True;

                      end;  {If (PrintParcelIDOnly and ...}

                end;  {For I := 1 to NumLinesToPrint do}

              For I := 7 to NumLinesPerLabel do
                Println('');

              NumLabelsPrinted := NumLabelsPrinted + 3;  {3 across}

            end;  {If (LabelType = lbLaser5160)}

        If (LabelType = lbLaser1Liner)
          then
            begin
              ClearTabs;
              SetTab(2.3, pjLeft, 2, 0, BOXLINENone, 0);   {Column 1}
              Println('');
              Println('');
              Println(#9 + TempSwisSBLKey);
              NumLabelsPrinted := NumLabelsPrinted + 1;
              Println('');

            end;  {If (LabelType = lbLaser1Liner)}

          {CHG12021999-1: Allow print to envelopes.}

        If (LabelType = lbEnvelope)
          then
            begin
              GotoXY(0, 2.0);
              ClearTabs;
              SetTab(4.0, pjLeft, 3.0, 0, BOXLINENone, 0);   {Column 1}

              NumLinesToPrint := 6;
              For I := 1 to NumLinesToPrint do
                Println(#9 + Take(30, TempNAddrArray1[I]));

              NumLabelsPrinted := NumLabelsPrinted + 1;

            end;  {If (LabelType = lbEnvelope)}

        If ((LabelType <> lbDotMatrix) and  {For dot matrix, just print continuous}
            ((NumLabelsPrinted mod NumLabelsPerPage) = 0) and
            (NumLabelsPrinted > 0))
          then
            with Sender as TBaseReport do
              NewPage;

      end;  {For J := 0 to (LabelList.Count - 1) do}

    {CHG11122005-1(2.9.4.1): Actually do the comma delimited and Excel extract.}

  with LabelOptions do
    If (CommaDelimitedExtract or
        ExtractToExcel)
      then
        try
          If CommaDelimitedExtract
            then TempFileName := ExtractFileName
            else TempFileName := GetPrintFileName('Labels', True);

          AssignFile(ExtractFile, TempFileName);
          Rewrite(ExtractFile);

          For Index := 0 to (LabelList.Count - 1) do
            begin
              For J := 1 to 6 do
                WriteCommaDelimitedLine(ExtractFile, [Trim(PNameAddrArray(LabelList[Index])^[J])]);

              WritelnCommaDelimitedLine(ExtractFile, []);

            end;  {For Index := 0 to (LabelList.Count - 1) do}

          CloseFile(ExtractFile);

          If ExtractToExcel
            then SendTextFileToExcelSpreadsheet(TempFileName, True, False, '');

        except
        end;

  FreeLabelList(LabelList, LabelOptions);

end;  {PrintLabels}

{=====================================================================================}
Procedure FreeLabelList(LabelList : TList;
                        LabelOptions : TLabelOptions);

begin
  with LabelOptions do
    If (LabelType = lbLaser1Liner)
      then FreeTList(LabelList, 26)
      else FreeTList(LabelList, SizeOf(NameAddrArray));

end;  {FreeLabelList}

{========================================================}
Function ExecuteLabelOptionsDialogOld(var lb_PrintLabelsBold : Boolean;
                                      var lb_PrintOldAndNewParcelIDs : Boolean;
                                      var lb_PrintSwisCodeOnParcelIDs : Boolean;
                                      var lb_PrintParcelIDOnly : Boolean;
                                      var lb_LabelType : Integer;
                                      var lb_NumLinesPerLabel : Integer;
                                      var lb_NumLabelsPerPage : Integer;
                                      var lb_NumColumnsPerPage : Integer;
                                      var lb_SingleParcelFontSize : Integer;
                                      var lb_ResidentLabels : Boolean;
                                      var lb_LegalAddressLabels : Boolean;
                                      var lb_PrintParcelIDOnlyOnFirstLine : Boolean;
                                      var lb_LaserTopMargin : Real;
                                      var lb_PrintParcelID_PropertyClass : Boolean) : Boolean;

begin
    {Let them choose the options for the labels.}

  try
    LabelOptionsDialogOld := TLabelOptionsDialogOld.Create(Application);

    Result := (LabelOptionsDialogOld.ShowModal = idOK);

      {Set all the label vars.}

    If Result
      then
        with LabelOptionsDialogOld do
          begin
            lb_PrintLabelsBold := PrintLabelsBold;
            lb_PrintOldAndNewParcelIDs := PrintOldAndNewParcelIDs;
            lb_PrintSwisCodeOnParcelIDs := PrintSwisCodeOnParcelIDs;
            lb_PrintParcelIDOnly := PrintParcelIDOnly;

            lb_LabelType := LabelType;
            lb_NumLinesPerLabel := NumLinesPerLabel;
            lb_NumLabelsPerPage := NumLabelsPerPage;
            lb_NumColumnsPerPage := NumColumnsPerPage;
            lb_SingleParcelFontSize := SingleParcelFontSize;

            lb_ResidentLabels := ResidentLabels;
            lb_LegalAddressLabels := LegalAddressLabels;
            lb_PrintParcelIDOnlyOnFirstLine := PrintParcelIDOnlyOnFirstLine;
            lb_LaserTopMargin := LaserTopMargin;
            lb_PrintParcelID_PropertyClass := PrintParcelID_PropertyClass;

          end;  {with LabelOptionsDialog do}

  finally
    LabelOptionsDialogOld.Free;
  end;

end;  {ExecuteLabelOptionsDialog}

{================================================================================}
Procedure PrintLabelHeaderOld(Sender : TObject;
                              LabelType : Integer;
                              LaserTopMargin : Double;
                              PrintLabelsBold : Boolean);

{05242004: Just temporarily.  Want to switch to PrintLabelHeader in PASUtils.}

begin
  with Sender as TBaseReport do
    begin
      If (LabelType <> lbDotMatrix)
        then
          begin
            GotoXY(0.3, LaserTopMargin);

            with Sender as TBaseReport do
              If (LabelType = lbLaser1Liner)
                then SetFont('Times New Roman', 14)
                else SetFont('Times New Roman', 10);

            If PrintLabelsBold
              then Bold := True;

          end;  {If (LabelType = lbLaser5161)}

    end;  {with Sender as TBaseReport do}

end;  {PrintLabelHeaderOld}

{================================================================================}
Procedure PrintLabelsOld(Sender : TObject;
                         LabelList : TList;
                         LabelType : Integer;
                         PrintParcelIDOnly : Boolean;
                         PrintLabelsBold : Boolean;
                         NumLinesPerLabel : Integer;
                         NumLabelsPerPage : Integer;
                         NumColumnsPerPage : Integer;
                         SingleParcelFontSize : Integer;
                         FontSizeAdditionalLines : Integer; {Set to zero if regular 10pt should be used.}
                         LinesToBold : TStringList;
                         PrintLabelsUnderline : Boolean;
                         LinesToUnderline : TStringList;
                         PrintLabelsItalicized : Boolean;
                         LinesToItalicize : TStringList);

{Code to actually print one label.}
{05242004: Just temporarily.  Want to switch to PrintLabelHeader in PASUtils.}

var
  Index, I, J, NumLinesToPrint, NumLabelsPrinted : Integer;
  TempSwisSBLKey, TempStr, SBLKey : String;
  TempNAddrArray1, TempNAddrArray2, TempNAddrArray3 : NameAddrArray;
  FirstLinePrinted, BoldThisLine, UnderlineThisLine, ItalicizeThisLine : Boolean;

begin
  If (FontSizeAdditionalLines = 0)
    then FontSizeAdditionalLines := 10;
  Index := 0;
  NumLabelsPrinted := 0;

  with Sender as TBaseReport do
    while (Index <= (LabelList.Count - 1)) do
      begin
        FirstLinePrinted := True;
        If (LabelType = lbLaser1Liner)
          then
            begin
              TempSwisSBLKey := Take(26, PSwisSBLKeyType(LabelList[Index])^);
              SBLKey := Copy(TempSwisSBLKey, 7, 20);
              Index := Index + 1;
            end
          else
            begin
              For J := 1 to 6 do
                begin
                  TempNAddrArray1[J] := '';
                  TempNAddrArray2[J] := '';
                  TempNAddrArray3[J] := '';
                end;

                {Dot matrix labels, envelopes take 1 at a time.}
              TempNAddrArray1 := PNameAddrArray(LabelList[Index])^;
              Index := Index + 1;

                {5160 and 5161 have at least 2 labels across.}

              If ((Index <= (LabelList.Count - 1)) and
                  (LabelType in [lbLaser5160, lbLaser5161]))
                then
                  begin
                    TempNAddrArray2 := PNameAddrArray(LabelList[Index])^;
                    Index := Index + 1;
                  end;

                {5160 has three across.}

              If ((Index <= (LabelList.Count - 1)) and
                  (LabelType = lbLaser5160))
                then
                  begin
                    TempNAddrArray3 := PNameAddrArray(LabelList[Index])^;
                    Index := Index + 1;
                  end;

            end;  {else of If (LabelType = lbLaser1Liner)}

        If (LabelType = lbDotMatrix)
          then
            begin
              ClearTabs;
              SetTab(0.1, pjLeft, 4, 0, BOXLINENone, 0);   {Line}

              If (Take(3, TempNAddrArray1[1]) = 'XXX')  {Alignment label?}
                then TempStr := SBLKey
                else TempStr := ConvertSBLOnlyToDashDot(SBLKey);

              For I := 1 to 6 do
                TextPrintln(Sender, #9 + '    ' + Take(30, TempNAddrArray1[I]));

              TextPrintln(Sender, '');
              TextPrintln(Sender, '');

              For I := 9 to NumLinesPerLabel do  {To the end of the label}
                TextPrintln(Sender, '');

              NumLabelsPrinted := NumLabelsPrinted + 1;  {1 across}

            end;  {If (LabelType = lbDotMatrix)}

        If (LabelType = lbLaser5161)
          then
            begin
              ClearTabs;
              SetTab(0.3, pjLeft, 4, 0, BOXLINENone, 0);   {Column 1}
              SetTab(4.5, pjLeft, 4, 0, BOXLINENone, 0);   {Column 2}

              NumLinesToPrint := 6;

                {CHG07232000-1: Allow them to adjust the font size on the
                                parcel ID only labels.}

              If PrintParcelIDOnly
                then
                  begin
                    SetFont('Courier New', SingleParcelFontSize);

                    If PrintLabelsBold
                      then Bold := True;

                  end;  {If PrintParcelIDOnly}

                {CHG11172003-1(2.07k): Add a label format to accomodate printing parcel id \ legal address labels.}

              For I := 1 to NumLinesToPrint do
                begin
                  Println(#9 + Take(30, TempNAddrArray1[I]) +
                          #9 + Take(30, TempNAddrArray2[I]));

                    {We want to use the big font for the parcel ID and the regular font for the rest.}
                    {CHG12062003-3(2.07k1): Allow for different font size for additional lines on parcel ID only labels.}

                  If (PrintParcelIDOnly and
                      (Deblank(TempNAddrArray1[I]) <> '') and
                      FirstLinePrinted)
                    then
                      begin
                        SetFont('Courier New', FontSizeAdditionalLines);
                        FirstLinePrinted := False;

                        If PrintLabelsBold
                          then Bold := True;

                      end;  {If (PrintParcelIDOnly and ...}

                end;  {For I := 1 to NumLinesToPrint do}

              For I := 7 to NumLinesPerLabel do
                Println('');

              NumLabelsPrinted := NumLabelsPrinted + 2;  {2 across}

            end;  {If (LabelType = lbLaser5161)}

        If (LabelType = lbLaser5160)
          then
            begin
              ClearTabs;
              SetTab(0.3, pjLeft, 2.7, 0, BOXLINENone, 0);   {Column 1}
              SetTab(3.1, pjLeft, 2.7, 0, BOXLINENone, 0);   {Column 2}
              SetTab(5.9, pjLeft, 2.5, 0, BOXLINENone, 0);   {Column 3}

                {CHG07232000-1: Allow them to adjust the font size on the
                                parcel ID only labels.}
                {CHG12292004-1(2.8.1.7): Allow for font size to be altered even for non-parcel labels.}

              SetFont('Courier New', 10);

              NumLinesToPrint := 6;

                {CHG07232000-1: Allow them to adjust the font size on the
                                parcel ID only labels.}

              If PrintParcelIDOnly
                then
                  begin
                    SetFont('Courier New', SingleParcelFontSize);

                    If PrintLabelsBold
                      then Bold := True;

                  end;  {If PrintParcelIDOnly}

              If ((LinesToBold = nil) and
                  PrintLabelsBold)
                then Bold := True;

                {CHG11172003-1(2.07k): Add a label format to accomodate printing parcel id \ legal address labels.}
                {CHG12302004-2(2.8.1.7): Add option to underline labels.}
                {CHG12302004-3(2.8.1.7): Add option to italicize labels.}

              For I := 1 to NumLinesToPrint do
                begin
                    {CHG12272004-1(2.8.1.6): Option to bold individual lines of the label.}

                 If (LinesToBold = nil)
                   then BoldThisLine := PrintLabelsBold
                   else BoldThisLine := (LinesToBold.IndexOf(IntToStr(I)) > -1);

                  UnderlineThisLine := ((LinesToUnderline <> nil) and
                                        (LinesToUnderline.IndexOf(IntToStr(I)) > -1));

                  ItalicizeThisLine := ((LinesToItalicize <> nil) and
                                        (LinesToItalicize.IndexOf(IntToStr(I)) > -1));

                  If BoldThisLine
                    then Bold := True;

                  If UnderlineThisLine
                    then Underline := True;

                  If ItalicizeThisLine
                    then Italic := True;

                  Println(#9 + Take(27, TempNAddrArray1[I]) +
                          #9 + Take(27, TempNAddrArray2[I]) +
                          #9 + Take(27, TempNAddrArray3[I]));

                  Bold := False;
                  Underline := False;
                  Italic := False;

                    {We want to use the big font for the parcel ID and the regular font for the rest.}
                    {CHG12062003-3(2.07k1): Allow for different font size for additional lines on parcel ID only labels.}
                    {CHG12292004-1(2.8.1.7): Allow for font size to be altered even for non-parcel labels.}

                  If ((Deblank(TempNAddrArray1[I]) <> '') and
                      FirstLinePrinted)
                    then
                      begin
                        SetFont('Courier New', FontSizeAdditionalLines);
                        FirstLinePrinted := False;

                        If ((LinesToBold = nil) and
                            PrintLabelsBold)
                          then Bold := True;

                      end;  {If (PrintParcelIDOnly and ...}

                end;  {For I := 1 to NumLinesToPrint do}

              For I := 7 to NumLinesPerLabel do
                Println('');

              NumLabelsPrinted := NumLabelsPrinted + 3;  {3 across}

            end;  {If (LabelType = lbLaser5160)}

        If (LabelType = lbLaser1Liner)
          then
            begin
              ClearTabs;
              SetTab(2.3, pjLeft, 2, 0, BOXLINENone, 0);   {Column 1}
              Println('');
              Println('');
              Println(#9 + TempSwisSBLKey);
              NumLabelsPrinted := NumLabelsPrinted + 1;
              Println('');

            end;  {If (LabelType = lbLaser1Liner)}

          {CHG12021999-1: Allow print to envelopes.}

        If (LabelType = lbEnvelope)
          then
            begin
              GotoXY(0, 2.0);
              ClearTabs;
              SetTab(4.0, pjLeft, 3.0, 0, BOXLINENone, 0);   {Column 1}

              NumLinesToPrint := 6;
              For I := 1 to NumLinesToPrint do
                Println(#9 + Take(30, TempNAddrArray1[I]));

              NumLabelsPrinted := NumLabelsPrinted + 1;

            end;  {If (LabelType = lbEnvelope)}

        If ((LabelType <> lbDotMatrix) and  {For dot matrix, just print continuous}
            ((NumLabelsPrinted mod NumLabelsPerPage) = 0) and
            (NumLabelsPrinted > 0))
          then
            with Sender as TBaseReport do
              NewPage;

      end;  {For J := 0 to (LabelList.Count - 1) do}

end;  {PrintLabelsOld}

{=====================================================================================}
Procedure InsertAuditAVChangeRec(AuditAVChangeTable : TTable;
                                 SwisSBLKey : String;
                                 TaxRollYr : String;
                                 OrigLandAssessedVal,
                                 OrigTotalAssessedVal,
                                 OrigPhysicalQtyInc,
                                 OrigPhysicalQtyDec,
                                 OrigEqualizationInc,
                                 OrigEqualizationDec : Comp;
                                 OrigEXAmounts : ExemptionTotalsArrayType;
                                 NewLandAssessedVal,
                                 NewTotalAssessedVal,
                                 NewPhysicalQtyInc,
                                 NewPhysicalQtyDec,
                                 NewEqualizationInc,
                                 NewEqualizationDec : Comp;
                                 NewEXAmounts : ExemptionTotalsArrayType);

{Write out a trace record for this AV change.}
{FXX03301998-2: Commonize the AV trace post.}

begin
  with AuditAVChangeTable do
    begin
      Insert;

      FieldByName('SwisSBLKey').Text := SwisSBLKey;
      FieldByName('TaxRollYr').Text := TaxRollYr;
      FieldByName('Date').AsDateTime := Date;
      FieldByName('Time').AsDateTime := Now;
      FieldByName('User').Text := GlblUserName;

      FieldByName('OldLandValue').AsFloat := OrigLandAssessedVal;
      FieldByName('OldAssessedValue').AsFloat := OrigTotalAssessedVal;
      FieldByName('OldPhyQtyInc').AsFloat := OrigPhysicalQtyInc;
      FieldByName('OldPhyQtyDec').AsFloat := OrigPhysicalQtyDec;
      FieldByName('OldEqInc').AsFloat := OrigEqualizationInc;
      FieldByName('OldEqDec').AsFloat := OrigEqualizationDec;

        {FXX03301998-1: Show county, school, town tv's.}

      FieldByName('OldCountyTaxableVal').AsFloat := OrigTotalAssessedVal -
                                                    OrigEXAmounts[EXCounty];
      FieldByName('OldTownTaxableVal').AsFloat := OrigTotalAssessedVal -
                                                  OrigEXAmounts[EXTown];
      FieldByName('OldSchlTaxableVal').AsFloat := OrigTotalAssessedVal -
                                                    OrigEXAmounts[EXSchool];

      FieldByName('NewLandValue').AsFloat := NewLandAssessedVal;
      FieldByName('NewAssessedValue').AsFloat := NewTotalAssessedVal;
      FieldByName('NewPhyQtyInc').AsFloat := NewPhysicalQtyInc;
      FieldByName('NewPhyQtyDec').AsFloat := NewPhysicalQtyDec;
      FieldByName('NewEqInc').AsFloat := NewEqualizationInc;
      FieldByName('NewEqDec').AsFloat := NewEqualizationDec;
      FieldByName('NewCountyTaxableVal').AsFloat := NewTotalAssessedVal -
                                                    NewEXAmounts[EXCounty];
      FieldByName('NewTownTaxableVal').AsFloat := NewTotalAssessedVal -
                                                  NewEXAmounts[EXTown];
      FieldByName('NewSchlTaxableVal').AsFloat := NewTotalAssessedVal -
                                                    NewEXAmounts[EXSchool];

      try
        Post;
      except
        SystemSupport(971, AuditAVChangeTable, 'Error inserting AV change trace rec.',
                      'PASUTILS', GlblErrorDlgBox);
      end;

    end;  {with AuditAVChangeTable do}

end;  {InsertAuditAVChangeRec}

{======================================================================}
Procedure InitGlblLastLocateInfoRec(var GlblLastLocateInfoRec : GlblLastLocateInfoRecord);

begin
  with GlblLastLocateInfoRec do
    begin
      LastLocateKey := -1;
      LastLocatePage := ' ';
      LastSwisSBLKey := '';
      LastLegalAddrInt := 0;
      LastLegalAddr := '';
      LastOwnerName := '';
      LastPetitionerName := '';
      LastIndexNumber := 0;
      LastOldParcelID := '';
      LastSpecificGrievanceYear := '';

    end;  {with GlblLastLocateInfoRec do}

end;  {InitGlblLastLocateInfoRec}

{======================================================================}
Function GetFieldFromTable(_TableName : String;
                           LookupFieldName : String;
                           TargetFieldName : String;
                           IndexName : String;
                           LookupData : String;
                           UseDataModuleTable : Boolean;
                           ProcessingType : Integer) : String;

var
  Table : TTable;
  Quit, _Found : Boolean;
  TempIndexName : String;

begin
  If UseDataModuleTable
    then Table := FindTableInDataModuleForProcessingType(_TableName,
                                                         ProcessingType)
    else
      begin
        Table := TTable.Create(nil);
        Table.TableType := ttDBase;

        OpenTableForProcessingType(Table, _TableName, ProcessingType, Quit);

      end;  {If UseDataModuleTable}

  TempIndexName := Table.IndexName;
  Table.IndexName := IndexName;

  _Found := FindKeyOld(Table, [LookupFieldName], [LookupData]);

  If _Found
    then Result := Trim(Table.FieldByName(TargetFieldName).Text)
    else Result := '';

  Table.IndexName := TempIndexName;

  If not UseDataModuleTable
    then
      begin
        Table.Close;
        Table.Free;
      end;

end;  {GetFieldFromTable}

{========================================================}
Function ExemptionIsCalculatedAlternativeVeteran(ExemptionCode : String) : Boolean;

begin
  Result := ((Take(4, ExemptionCode) = '4112') or
             (Take(4, ExemptionCode) = '4113'));
end;

{========================================================}
Function ExecuteLabelOptionsDialog(var LabelOptions : TLabelOptions) : Boolean;

begin
  try
    LabelOptionsDialog := TLabelOptionsDialog.Create(Application);

    Result := (LabelOptionsDialog.ShowModal = idOK);

      {Set all the label vars.}

    If Result
      then
        with LabelOptionsDialog do
          begin
              {CHG05222004-2(2.08): Redesign label printing to make it more
                                    concise and easier to spread throughout this and
                                    other systems.}

            with LabelOptions do
              begin
                LabelType := _LabelType;
                NumLabelsPerPage := _NumLabelsPerPage;
                NumLinesPerLabel := _NumLinesPerLabel;
                NumColumnsPerPage := _NumColumnsPerPage;
                SingleParcelFontSize := _SingleParcelFontSize;
                LaserTopMargin := _LaserTopMargin;
                ExtractToExcel := _ExtractToExcel;
                CommaDelimitedExtract := _CommaDelimitedExtract;
                ExtractFileName := _ExtractFileName;

                LabelFormatOptions := [];

                If _PrintLabelsBold
                  then LabelFormatOptions := LabelFormatOptions + [lb_PrintLabelsBold];
                If _PrintOldAndNewParcelIDs
                  then LabelFormatOptions := LabelFormatOptions + [lb_PrintOldAndNewParcelIDs];
                If _PrintSwisCodeOnParcelIDs
                  then LabelFormatOptions := LabelFormatOptions + [lb_PrintSwisCodeOnParcelIDs];
                If _PrintParcelIDOnly
                  then LabelFormatOptions := LabelFormatOptions + [lb_PrintParcelIDOnly];
                If _ResidentLabels
                  then LabelFormatOptions := LabelFormatOptions + [lb_ResidentLabels];
                If _LegalAddressLabels
                  then LabelFormatOptions := LabelFormatOptions + [lb_LegalAddressLabels];
                If _PrintParcelIDOnlyOnFirstLine
                  then LabelFormatOptions := LabelFormatOptions + [lb_PrintParcelIDOnlyOnFirstLine];
                If _PrintParcelID_PropertyClass
                  then LabelFormatOptions := LabelFormatOptions + [lb_PrintParcelID_PropertyClass];

                  {CHG06262005-1(2.8.5.2)[2152]: Option to eliminate duplicate owners from label print.}

                If _EliminateDuplicateOwners
                  then LabelFormatOptions := LabelFormatOptions + [lb_EliminateDuplicateOwners];
                If _PrintAccountNumber_OldID
                  then LabelFormatOptions := LabelFormatOptions + [lb_PrintAccountNumber_OldID];

              end;  {with LabelOptions do}

          end;  {with LabelOptionsDialog do}

  finally
    LabelOptionsDialog.Free;
  end;

end;  {ExecuteLabelOptionsDialog}

{===============================================================================}
Procedure InitializeSBLRecord(var SBLRec : SBLRecord);

begin
  with SBLRec do
    begin
      SwisCode := '';
      Section := '';
      Subsection := '';
      Block := '';
      Lot := '';
      Sublot := '';
      Suffix := '';

    end;  {with SBLRec do}

end;  {InitializeSBLRecord}

{=======================================================================}
Function SBLRecordsDifferent(SBLRec1,
                             SBLRec2 : SBLRecord) : Boolean;

begin
  Result := ((Trim(SBLRec1.SwisCode) <> Trim(SBLRec2.SwisCode)) or
             (Trim(SBLRec1.Section) <> Trim(SBLRec2.Section)) or
             (Trim(SBLRec1.Subsection) <> Trim(SBLRec2.Subsection)) or
             (Trim(SBLRec1.Block) <> Trim(SBLRec2.Block)) or
             (Trim(SBLRec1.Lot) <> Trim(SBLRec2.Lot)) or
             (Trim(SBLRec1.Sublot) <> Trim(SBLRec2.Sublot)) or
             (Trim(SBLRec1.Suffix) <> Trim(SBLRec2.Suffix)));

end;  {SBLRecordsDifferent}

{================================================================}
Function TableIsYearBasedTable(TableName : String) : Boolean;

{Is the table a year based table? (i.e. has a ThisYear, NextYear and History copy).}

begin
  Result := not _Compare(TableName, [SalesTableName,
                                     NotesTableName,
                                     ExemptionsRemovedTableName,
                                     PictureTableName,
                                     DocumentTableName,
                                     ThirdPartyNotificationTableName,
                                     GrievanceTableName,
                                     GrievanceResultsTableName,
                                     CertiorariTableName,
                                     SmallClaimsTableName,
                                     CertiorariAppraisalsTableName,
                                     SmallClaimsAppraisalsTableName,
                                     CertiorariNotesTableName,
                                     SmallClaimsNotesTableName,
                                     CertiorariCalenderTableName,
                                     SmallClaimsCalenderTableName,
                                     PASPermitsTableName,
                                     AdditionalOwnersTableName,
                                     SketchTableName], coEqual);

end;  {TableIsYearBasedTable}

{================================================================}
Function ApexIsInstalledOnComputer : Boolean;

{CHG03052004-1(2.07l2): Allow the searcher to view and print sketches.}
{FXX08172004-1(2.08.0.08182004): Make the detection of Apex a registry thing.}

var
  Reg : TRegistry;

begin
  Reg := TRegistry.Create;
  Reg.RootKey := HKEY_LOCAL_MACHINE;

  try
    Result := (Reg.OpenKey('\SOFTWARE\Property Assessment System\Apex', False) and
               Reg.ValueExists('installed'));

  except
    Result := False;

  end; 

    {FXX01302009-1(2.16.1.20): If the user does not have rights to HKey_Local_Machine,
                               manually create an entry in the registry under HKey_Current_User
                               and check for it.}

  If not Result
    then
      begin
        Reg.RootKey := HKEY_CURRENT_USER;

        try
          Result := (Reg.OpenKey('\Software\Property Assessment System\Apex', False) and
                     Reg.ValueExists('installed'));
        except
          Result := False;

        end;

      end;  {If not Result}

  Reg.Free;

end;  {ApexIsInstalledOnComputer}

{====================================================================}
Function GetTableNameFromScreenName(ScreenLabelList : TList;
                                    _ScreenName,
                                    _LabelName : String) : String;

var
  I : Integer;

begin
     {FXX06101999-1: Get the table name for the specific field in case there is
                     data from several tables on one form.}

  For I := 0 to (ScreenLabelList.Count - 1) do
    with ScreenLabelPtr(ScreenLabelList[I])^ do
      If ((RTrim(ScreenName) = RTrim(_ScreenName)) and
          (RTrim(LabelName) = RTrim(_LabelName)))
        then Result := RTrim(TableName);

end;  {GetTableNameFromScreenName}

{====================================================================}
Function GetFieldNameForScreenLabel(ScreenLabelList : TList;
                                    _ScreenName,
                                    _LabelName : String) : String;

var
  I : Integer;

begin
  For I := 0 to (ScreenLabelList.Count - 1) do
    with ScreenLabelPtr(ScreenLabelList[I])^ do
      If ((RTrim(ScreenName) = RTrim(_ScreenName)) and
          (RTrim(LabelName) = RTrim(_LabelName)))
        then Result := RTrim(FieldName);

end;  {GetFieldNameForScreenLabel}

{======================================================================}
Function ConvertSwisSBLToNassauDashDot(SwisSBLKey : String) : String;

{CHG04042004-1(2.07l2): Allow for Nassau formatting and ordering on assessment roll.}

begin
  Result := '';
end;  {ConvertSwisSBLToNassauDashDot}

{======================================================================}
Function AllSwisCodesInSameMunicipality(SwisCodeTable : TTable) : Boolean;

var
  Done, FirstTimeThrough : Boolean;
  MunicipalCode : String;

begin
  Result := True;
  MunicipalCode := Copy(SwisCodeTable.FieldByName('SwisCode').Text, 1, 4);

  Done := False;
  FirstTimeThrough := True;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else SwisCodeTable.Next;

    If SwisCodeTable.EOF
      then Done := True;

    If ((not Done) and
        (MunicipalCode <> Copy(SwisCodeTable.FieldByName('SwisCode').Text, 1, 4)))
      then Result := False;

  until Done;

end;  {AllSwisCodesInSameMunicipality}

{================================================================}
Function ConvertFrom_PAS_To_GlenCoveTax_Building_SBL(SBL : String) : String;

{Convert from PAS to the building or tax system.}

var
  SBLRec : SBLRecord;

begin
  Result := '';
  InitializeSBLRecord(SBLRec);

  with SBLRec do
    begin
      Section := Trim(Copy(SBL, 1, 3));
      SubSection := Trim(Copy(SBL, 4, 3));
      Block := Trim(Copy(SBL, 7, 4));
      Lot := Trim(Copy(SBL, 11, 3));
      Sublot := Trim(Copy(SBL, 14, 3));
      Suffix := Trim(Copy(SBL, 17, 4));

      If (Deblank(Section) <> '')
        then
          try
            StrToInt(Section);
          except
            Section := ShiftRightAddZeroes(Section, 3);
          end;

      Subsection := ShiftRightAddZeroes(Subsection, 3);
      Block := ShiftRightAddZeroes(Block, 4);
      Lot := ShiftRightAddZeroes(Lot, 3);
      Suffix := ShiftRightAddZeroes(Suffix, 4);

      Result := Take(3, Section) +
                Take(3, Subsection) +
                Take(4, Block) +
                Take(3, Lot) +
                Take(3, Sublot) +
                Take(4, Suffix);

    end;  {with SBLRec do}

end;  {ConvertFrom_PAS_To_GlenCoveTax_Building_SBL}

{================================================================}
Function ConvertFrom_GlenCoveTax_Building_To_PAS_SBL(SBL : String) : String;

{Convert from the tax \ building SBL to the PAS SBL.}

var
  SBLRec : SBLRecord;
  TempInt : Integer;

begin
  Result := '';
  InitializeSBLRecord(SBLRec);

  with SBLRec do
    begin
      Section := Copy(SBL, 1, 3);
      SubSection := Copy(SBL, 4, 3);
      Block := Copy(SBL, 7, 4);
      Lot := Copy(SBL, 11, 3);
      Sublot := Copy(SBL, 14, 3);
      Suffix := Copy(SBL, 17, 4);

        {Subsection is SRAZ in 3 if numeric; dezeroed, SRAB in 3 if alpha.}

      try
        StrToInt(Subsection);
        Subsection := ShiftRightAddZeroes(Take(3, Subsection));
      except
        Subsection := ShiftRightAddBlanks(Take(3, DezeroOnLeft(Subsection)));
      end;

        {Block is SRAZ in 2, rj if non-zero and numeric; otherwise blank.}

      try
        TempInt := StrToInt(Block);

        If (TempInt = 0)
          then Block := ''
          else Block := ShiftRightAddBlanks(Take(4, ShiftRightAddZeroes(Take(2, DezeroOnLeft(Block)))));
      except
        Block := '';
      end;

        {Sublot is SRAB in 3.}

      Sublot := ShiftRightAddBlanks(Take(3, Trim(Sublot)));

        {Suffix is SRAZ in 4 if numeric; otherwise blank.}

      try
        TempInt := StrToInt(Suffix);

        If (TempInt = 0)
          then Suffix := ''
          else Suffix := ShiftRightAddZeroes(Take(4, Suffix));
      except
        Suffix := '';
      end;

      Result := Take(3, Section) +
                Take(3, Subsection) +
                Take(4, Block) +
                Take(3, Lot) +
                Take(3, Sublot) +
                Take(4, Suffix);

    end;  {with SBLRec do}

end;  {ConvertFrom_GlenCoveTax_Building_To_PAS_SBL}

{========================================================================}
Procedure OpenHelpDocument(HelpDocumentTable : TTable;
                           HelpIndex : LongInt);

{CHG03232004-7(2.08): Link up help.}

var
  HelpDirectory : String;

begin
  If HelpDocumentTable.Active
    then
      If FindKeyOld(HelpDocumentTable, ['HelpIndex'], [IntToStr(HelpIndex)])
        then
          begin
            HelpDirectory := GlblDrive + ':' + GlblHelpDirectory;
            try
              ShellExecute(0, 'open',
                           PChar(HelpDirectory + HelpDocumentTable.FieldByName('DocumentName').Text),
                           nil, nil, SW_NORMAL);
            except
              MessageDlg('Unable to connect to help document.',
                         mtError, [mbOk], 0);
            end;

          end
        else MessageDlg('Sorry, that help document could not be located.', mtError, [mbOK], 0);

end;  {OpenHelpDocument}

{=======================================================================}
Procedure SetFilterForHistoryYear(Table : TTable;
                                  AssessmentYear : String);

begin
  with Table do
    try
      Filtered := False;
      Filter := 'TaxRollYr = ' + AssessmentYear;
      Filtered := True;
    except
      MessageDlg('Error setting filter for history table ' + TableName + '.',
                 mtError, [mbOK], 0);
    end;

end;  {SetFilterForHistoryYear}

{==========================================================================}
Function ConvertFileNameToApexWMFFileName(QualifiedFileName : String;
                                          ChangePath : Boolean;
                                          IncludePath : Boolean) : String;

{Remove all dashes, dots, etc. and replace them with underscores.}

var
  ExtensionPos : Integer;
  TempFileName, TempPath : String;

begin
  TempPath := ReturnPath(QualifiedFileName);
  TempFileName := StripPath(QualifiedFileName);

  If ChangePath
    then
      try
        ChDir(TempPath);
      except
      end;

  Result := TempFileName;
  ExtensionPos := Pos('.AX2', ANSIUpperCase(TempFileName));

  If (ExtensionPos > 0)
    then Delete(Result, ExtensionPos, 4);

  Result := StringReplace(Result, '-', '_', [rfReplaceAll]);
  Result := StringReplace(Result, '.', '_', [rfReplaceAll]);
  Result := StringReplace(Result, '/', '_', [rfReplaceAll]);
  Result := StringReplace(Result, '\', '_', [rfReplaceAll]);
  Result := StringReplace(Result, ' ', '_', [rfReplaceAll]);

  Result := Result + '.wmf';

  If IncludePath
    then Result := TempPath + Result;

end;  {ConvertFileNameToApexFileName}

{=================================================================}
Procedure MakeCloseButtonLocate(CloseButton : TBitBtn);

{CHG11162004-7(2.8.0.21): Option to make the close button locate.}

begin
  with CloseButton do
    begin
      Caption := 'Locate';

      try
        ChDir(GlblProgramDir);
        NumGlyphs := 1;
        Glyph.LoadFromFile('Binoculars.bmp');
      except
      end;

    end;  {with CloseButton do}

end;  {MakeCloseButtonLocate}

{=================================================================}
Function ParcelDimensionsToString(ParcelTable : TTable) : String;

begin
  Result := '';

  with ParcelTable do
    If (FieldByName('Acreage').AsFloat > 0)
      then Result := FormatFloat(DecimalEditDisplay, FieldByName('Acreage').AsFloat) + ' ac'
      else
        If ((FieldByName('Frontage').AsFloat > 0) or
            (FieldByName('Depth').AsFloat > 0))
          then Result := FormatFloat(DecimalEditDisplay, FieldByName('Frontage').AsFloat) + ' x ' +
                         FormatFloat(DecimalEditDisplay, FieldByName('Depth').AsFloat);

end;  {ParcelDimensionsToString}

{==================================================================================}
Procedure ResizeTitleInformation(Form : TForm);

var
  TitlePanel : TControl;
  Continue : Boolean;

begin
  Continue := True;
  TitlePanel := nil;

  try
    TitlePanel := TControl(Form.FindComponent('TitlePanel'));
  except
    Continue := False;
  end;

  If Continue
    then
      begin
        try
          with TControl(Form.FindComponent('TitleLabel')) do
            Left := (TitlePanel.Width - Width) DIV 2;
          TControl(Form.FindComponent('LandLabel')).Left := TitlePanel.Width - 229;
          TControl(Form.FindComponent('LandAVLabel')).Left := TitlePanel.Width - 194;
          TControl(Form.FindComponent('TotalLabel')).Left := TitlePanel.Width - 117;
          TControl(Form.FindComponent('TotalAVLabel')).Left := TitlePanel.Width - 92;
          TControl(Form.FindComponent('PartialAssessmentLabel')).Left := TitlePanel.Width - 44;
        except
        end;

      end;  {If Continue}

end;  {ResizeHeaderInformation}

{==================================================================================}
Procedure ResizeHeaderInformation(Form : TForm);

var
  HeaderPanel : TControl;
  Continue : Boolean;

begin
  Continue := True;
  HeaderPanel := nil;

  try
    HeaderPanel := TControl(Form.FindComponent('HeaderPanel'));
  except
    Continue := False;
  end;

  If Continue
    then
      begin
        try
          TControl(Form.FindComponent('EditName')).Left := HeaderPanel.Width - 257;
          TControl(Form.FindComponent('EditLastChangeByName')).Left := HeaderPanel.Width - 149;
          TControl(Form.FindComponent('EditLastChangeDate')).Left := HeaderPanel.Width - 257;
          TControl(Form.FindComponent('OwnerNameLabel')).Left := HeaderPanel.Width - 341;
          TControl(Form.FindComponent('ChangeByLabel')).Left := HeaderPanel.Width - 176;
          TControl(Form.FindComponent('LastChangeByLabel')).Left := HeaderPanel.Width - 341;
        except
        end;

      end;  {If Continue}

end;  {ResizeHeaderInformation}

{==================================================================================}
Procedure ResizeFooterInformation(Form : TForm);

var
  FooterPanel : TControl;
  Continue : Boolean;

begin
  Continue := True;
  FooterPanel := nil;
  
  try
    FooterPanel := TControl(Form.FindComponent('FooterPanel'));
  except
    Continue := False;
  end;

  If Continue
    then
      begin
        try
          TControl(Form.FindComponent('CloseButton')).Left := FooterPanel.Width - 103;

          If (Form.FindComponent('Navigator') <> nil)
            then
              with TControl(Form.FindComponent('Navigator')) do
                Left := (FooterPanel.Width - Width) DIV 2;

        except
        end;

      end;  {If Continue}

end;  {ResizeFooterInformation}

{========================================================================}
Procedure LaunchRAVE(      ProjectName : String;
                     const ParameterNameList : Array of const;
                     const ParameterList : Array of const;
                           RAVELauncherType : TRAVELauncherType);

var
  TempLen, I : Integer;
  RAVELauncherPChar : PChar;
  RAVELauncherCommandLine, RAVEProgram : String;

begin
  case RAVELauncherType of
    rltBill : RAVEProgram := 'RAVEBILLLauncher.exe';
    rltLetter : RAVEProgram := 'RAVELetterLauncher.exe';
    rltReport : RAVEProgram := 'RAVEReportLauncher.exe';
  end;

  RAVELauncherCommandLine := GlblProgramDir + RAVEProgram +
                             ' PROJECT=' + ProjectName;

  For I := 0 to High(ParameterNameList) do
    RAVELauncherCommandLine := RAVELauncherCommandLine + ' ' +
                               VarRecToStr(ParameterNameList[I]) + '=' +
                               VarRecToStr(ParameterList[I]);

  TempLen := Length(RAVELauncherCommandLine);
  RAVELauncherPChar := StrAlloc(TempLen + 1);
  StrPCopy(RAVELauncherPChar, RAVELauncherCommandLine);

  WinExec(RAVELauncherPChar, SW_SHOW);
  StrDispose(RAVELauncherPChar);

end;  {LaunchRAVE}

{============================================================================}
Procedure GetAuditInformation(Table : TTable;
                              AuditList : TList);

var
  I : Integer;
  AuditPtr : AuditPointer;

begin
  try
    If (AuditList <> nil)
      then ClearTList(AuditList, SizeOf(AuditRecord));
  except
  end;

  If (AuditList = nil)
    then AuditList := TList.Create;

  with Table do
    For I := 0 to (FieldCount - 1) do
      try
        New(AuditPtr);

        with AuditPtr^ do
          begin
            _FieldName := ANSIUpperCase(Fields[I].FieldName);
            _TableName := ANSIUpperCase(TableName);
            _DataType := Fields[I].DataType;

            If (Fields[I] is TMemoField)
              then
                begin
                  _StringValue := '';
                  {$H+}
                  _MemoValue := FieldByName(Fields[I].FieldName).AsString;
                  {$H-}
                end
              else
                begin
                  _StringValue := FieldByName(Fields[I].FieldName).Text;
                  _MemoValue := '';
                end;  {else of If (Fields[I] is TMemoField)}

          end;  {with AuditPtr^ do}

        AuditList.Add(AuditPtr);
      except
      end;

end;  {GetAuditInformation}

{===============================================================}
Procedure SetAuditKeyFields(AuditTable : TTable;
                            AuditList : TList;
                            KeyFields : Array of const);

var
  I, J : Integer;
  KeyFieldName : String;

begin
  For I := 0 to High(KeyFields) do
    begin
      KeyFieldName := VarRecToStr(KeyFields[I]);

      For J := 0 to (AuditList.Count - 1) do
        If _Compare(KeyFieldName, AuditPointer(AuditList[J])^._FieldName, coEqual)
          then
            try
              AuditTable.FieldByName(KeyFieldName).AsString := AuditPointer(AuditList[J])^._StringValue;
            except
            end;

    end;  {For I := 0 to High(KeyFields) do}

end;  {SetAuditKeyFields}

{===========================================================================}
Procedure FillInAuditKeyFields(AuditTable : TTable;
                               AuditList : TList;
                               KeyFieldType : Integer);

begin
  case KeyFieldType of
    kfSwisSBLKey : SetAuditKeyFields(AuditTable, AuditList,
                                     ['SwisSBLKey']);

  end;  {case KeyFieldType of}

end;  {FillInAuditKeyFields}

{===============================================================}
Procedure StoreAuditInformation(OriginalAuditList : TList;
                                NewAuditList : TList;
                                User : String;
                                EditMode : String;  {(E)dit, (I)nsert, (D)elete}
                                KeyFieldType : Integer);

var
  I, J : Integer;
  AuditTable : TTable;
  _Date, _Time : TDateTime;
  Changed : Boolean;
  _OldStringValue, _NewStringValue : String;

begin
  AuditTable := TTable.Create(nil);

  with AuditTable do
    try
      DatabaseName := 'PASSystem';
      TableName := 'AuditTable';
      TableType := ttDBase;
      Open;
    except
      Abort;
    end;

  _Date := Date;
  _Time := Now;

  If _Compare(EditMode, [emInsert, emEdit], coEqual)
    then
      try
        For I := 0 to (OriginalAuditList.Count - 1) do
          For J := 0 to (NewAuditList.Count - 1) do
            If _Compare(AuditPointer(OriginalAuditList[I])^._FieldName,
                        AuditPointer(NewAuditList[J])^._FieldName, coEqual)
              then
                begin
                  Changed := False;
                  _OldStringValue := '';
                  _NewStringValue := '';

                  If _Compare(AuditPointer(OriginalAuditList[I])^._StringValue,
                              AuditPointer(NewAuditList[J])^._StringValue, coNotEqual)
                    then
                      begin
                        Changed := True;
                        _OldStringValue := AuditPointer(OriginalAuditList[I])^._StringValue;
                        _NewStringValue := AuditPointer(NewAuditList[J])^._StringValue;

                      end;  {If _Compare(AuditPointer(OriginalAuditList[I])^._StringValue, ...}

                  If Changed
                    then
                      with AuditTable, AuditPointer(NewAuditList[J])^ do
                        try
                          Insert;
                          FieldByName('User').Text := User;
                          FieldByName('Date').AsDateTime := _Date;
                          FieldByName('Time').AsDateTime := _Time;
(*                          FieldByName('EditMode').Text := EditMode;
                          FieldByName('TableName').Text := _TableName;
                          FieldByName('FieldName').Text := _FieldName; *)
                          FieldByName('OldValue').Text := _OldStringValue;
                          FieldByName('NewValue').Text := _NewStringValue;

                          FillInAuditKeyFields(AuditTable, NewAuditList, KeyFieldType);

                          Post;
                        except
                        end;

                end;  {If _Compare(AuditPointer(OriginalAuditList[I]^)._FieldName, ...}

      except
      end;

    {For a delete, store all non-blank fields and then store key information.}

  If _Compare(EditMode, emDelete, coEqual)
    then
      try
        For I := 0 to (OriginalAuditList.Count - 1) do
          If _Compare(AuditPointer(OriginalAuditList[I])^._StringValue, coNotBlank)
            then
              begin
                _NewStringValue := '';
                _OldStringValue := AuditPointer(OriginalAuditList[I])^._StringValue;

                with AuditTable, AuditPointer(OriginalAuditList[I])^ do
                  try
                    Insert;
                    FieldByName('User').Text := User;
                    FieldByName('Date').AsDateTime := _Date;
                    FieldByName('Time').AsDateTime := _Time;
(*                    FieldByName('EditMode').Text := EditMode;
                    FieldByName('TableName').Text := _TableName;
                    FieldByName('FieldName').Text := _FieldName;*)
                    FieldByName('OldValue').Text := _OldStringValue;
                    FieldByName('NewValue').Text := _NewStringValue;

                    FillInAuditKeyFields(AuditTable, OriginalAuditList, KeyFieldType);

                    Post;
                  except
                  end;

              end;  {If (((AuditPointer(OriginalAuditList[I])^._DataType = ftMemo) ...}

      except
      end;

  try
    If (OriginalAuditList <> nil)
      then ClearTList(OriginalAuditList, SizeOf(AuditRecord));
  except
  end;

  try
    If (NewAuditList <> nil)
      then ClearTList(NewAuditList, SizeOf(AuditRecord));
  except
  end;

  try
    AuditTable.Close;
    AuditTable.Free;
  except
  end;

end;  {StoreAuditInformation}

{===============================================================}
Procedure StoreAuditNotesInformation(OriginalAuditList : TList;
                                     NewAuditList : TList;
                                     User : String;
                                     EditMode : String;  {(E)dit, (I)nsert, (D)elete}
                                     KeyFieldType : Integer);

var
  I, J : Integer;
  AuditTable : TTable;
  _Date, _Time : TDateTime;
  Changed : Boolean;
  _OldStringValue, _NewStringValue : String;
  {$H+}
  _OldMemoValue, _NewMemoValue : String;
  {$H-}

begin
  AuditTable := TTable.Create(nil);

  with AuditTable do
    try
      DatabaseName := 'PASSystem';
      TableName := 'AuditNotesTable';
      TableType := ttDBase;
      Open;
    except
      Abort;
    end;

  _Date := Date;
  _Time := Now;

  If _Compare(EditMode, [emInsert, emEdit], coEqual)
    then
      try
        For I := 0 to (OriginalAuditList.Count - 1) do
          For J := 0 to (NewAuditList.Count - 1) do
            If _Compare(AuditPointer(OriginalAuditList[I])^._FieldName,
                        AuditPointer(NewAuditList[J])^._FieldName, coEqual)
              then
                begin
                  Changed := False;
                  _OldMemoValue := '';
                  _NewMemoValue := '';
                  _OldStringValue := '';
                  _NewStringValue := '';

                  If (AuditPointer(OriginalAuditList[I])^._DataType = ftMemo)
                    then
                      begin
                        {$H+}
                        If _Compare(AuditPointer(OriginalAuditList[I])^._MemoValue,
                                    AuditPointer(NewAuditList[J])^._MemoValue, coNotEqual)
                          then
                            begin
                              Changed := True;
                              _OldMemoValue := AuditPointer(OriginalAuditList[I])^._MemoValue;
                              _NewMemoValue := AuditPointer(NewAuditList[J])^._MemoValue;

                            end;  {If _Compare(AuditPointer(OriginalAuditList[I])^._MemoValue, ...}

                        {$H-}
                      end
                    else
                      begin
                        If _Compare(AuditPointer(OriginalAuditList[I])^._StringValue,
                                    AuditPointer(NewAuditList[J])^._StringValue, coNotEqual)
                          then
                            begin
                              Changed := True;
                              _OldStringValue := AuditPointer(OriginalAuditList[I])^._StringValue;
                              _NewStringValue := AuditPointer(NewAuditList[J])^._StringValue;

                            end;  {If _Compare(AuditPointer(OriginalAuditList[I])^._StringValue, ...}

                      end;  {else of If (AuditPointer(OriginalAuditList[I])^._DataType = ftMemo)}

                  If Changed
                    then
                      with AuditTable, AuditPointer(NewAuditList[J])^ do
                        try
                          Insert;
                          FieldByName('User').Text := User;
                          FieldByName('Date').AsDateTime := _Date;
                          FieldByName('Time').AsDateTime := _Time;
                          FieldByName('EditMode').Text := EditMode;
                          FieldByName('TableName').Text := _TableName;
                          FieldByName('FieldName').Text := _FieldName;
                          FieldByName('OldValue').Text := _OldStringValue;
                          FieldByName('NewValue').Text := _NewStringValue;

                          If (_DataType = ftMemo)
                            then
                              begin
                                {$H+}
                                FieldByName('OldMemo').AsString := _OldMemoValue;
                                FieldByName('NewMemo').AsString := _NewMemoValue;
                                {$H-}

                              end;  {If (_DataType = ftMemo)}

                          FillInAuditKeyFields(AuditTable, NewAuditList, KeyFieldType);

                          Post;
                        except
                        end;

                end;  {If _Compare(AuditPointer(OriginalAuditList[I]^)._FieldName, ...}

      except
      end;

    {For a delete, store all non-blank fields and then store key information.}

  If _Compare(EditMode, emDelete, coEqual)
    then
      try
        For I := 0 to (OriginalAuditList.Count - 1) do
          If (((AuditPointer(OriginalAuditList[I])^._DataType = ftMemo) and
               _Compare(AuditPointer(OriginalAuditList[I])^._MemoValue, coNotBlank)) or
              _Compare(AuditPointer(OriginalAuditList[I])^._StringValue, coNotBlank))
            then
              begin
                _OldMemoValue := '';
                _NewMemoValue := '';
                _OldStringValue := '';
                _NewStringValue := '';

                If (AuditPointer(OriginalAuditList[I])^._DataType = ftMemo)
                  then
                    begin
                        {$H+}
                      _OldMemoValue := AuditPointer(OriginalAuditList[I])^._MemoValue;
                        {$H-}
                    end
                  else _OldStringValue := AuditPointer(OriginalAuditList[I])^._StringValue;

                with AuditTable, AuditPointer(OriginalAuditList[I])^ do
                  try
                    Insert;
                    FieldByName('User').Text := User;
                    FieldByName('Date').AsDateTime := _Date;
                    FieldByName('Time').AsDateTime := _Time;
                    FieldByName('EditMode').Text := EditMode;
                    FieldByName('TableName').Text := _TableName;
                    FieldByName('FieldName').Text := _FieldName;
                    FieldByName('OldValue').Text := _OldStringValue;
                    FieldByName('NewValue').Text := _NewStringValue;

                    If (_DataType = ftMemo)
                      then
                        begin
                          {$H+}
                          FieldByName('OldMemo').AsString := _OldMemoValue;
                          FieldByName('NewMemo').AsString := _NewMemoValue;
                          {$H-}

                        end;  {If (_DataType = ftMemo)}

                    FillInAuditKeyFields(AuditTable, OriginalAuditList, KeyFieldType);

                    Post;
                  except
                  end;

              end;  {If (((AuditPointer(OriginalAuditList[I])^._DataType = ftMemo) ...}

      except
      end;

  try
    If (OriginalAuditList <> nil)
      then ClearTList(OriginalAuditList, SizeOf(AuditRecord));
  except
  end;

  try
    If (NewAuditList <> nil)
      then ClearTList(NewAuditList, SizeOf(AuditRecord));
  except
  end;

  try
    AuditTable.Close;
    AuditTable.Free;
  except
  end;

end;  {StoreAuditNotesInformation}

{======================================================================}
Function CategoryMeetsCollectionTypeRequirements(CollectionType : String;
                                                 Category : String) : Boolean;

begin
  Result := False;

  If (_Compare(CollectionType, CountyTaxType, coEqual) and
      _Compare(Category, mtfnCounty, coEqual))
    then Result := True;

  If (_Compare(CollectionType, [MunicipalTaxType, TownTaxType, VillageTaxType], coEqual) and
      _Compare(Category, [mtfnCity, mtfnTown, mtfnVillage], coEqual))
    then Result := True;

  If (_Compare(CollectionType, SchoolTaxType, coEqual) and
      _Compare(Category, mtfnSchool, coEqual))
    then Result := True;

  If _Compare(CollectionType, AllTaxTypes, coEqual)
    then Result := True;

end;  {CategoryMeetsCollectionTypeRequirements}

{==============================================================================}
Function GetDescriptionForCode(CodeTable : TTable;
                               Code : String;
                               DescriptionFieldName : String) : String;

begin
  Result := '';

  try
    If _Locate(CodeTable, [Code], '', [])
      then Result := CodeTable.FieldByName(DescriptionFieldName).Text;
  except
  end;

end;  {GetDescriptionForCode}

{=======================================================================}
Function CheckParcelForExistence(ParcelTable : TTable;
                                 ProcessingType : Integer;
                                 AssessmentYear : String;
                                 SwisSBLKey : String) : Boolean;

var
  Quit : Boolean;

begin
  OpenTableForProcessingType(ParcelTable, ParcelTableName, ProcessingType, Quit);

  Result := _Locate(ParcelTable, [AssessmentYear, SwisSBLKey], '', [loParseSwisSBLKey]);

end;  {CheckParcelForExistence}

{=======================================================================}
Function ParcelExistsInAnyYear(SwisSBLKey : String;
                               YearsOfExistence : TStringList) : Boolean;

var
  ParcelTable, AssessmentYearControlTable : TTable;
  Quit, Done, FirstTimeThrough : Boolean;

begin
  Result := False;
  ParcelTable := TTable.Create(nil);
  AssessmentYearControlTable := TTable.Create(nil);

  with ParcelTable do
    begin
      DatabaseName := 'PASSystem';
      TableType := ttDBase;
      IndexName := 'BYTAXROLLYR_SWISSBLKEY';

    end;  {with ParcelTable do}

  OpenTableForProcessingType(AssessmentYearControlTable, AssessmentYearControlTableName, History, Quit);

  If CheckParcelForExistence(ParcelTable, NextYear, GlblNextYear, SwisSBLKey)
    then
      begin
        YearsOfExistence.Add(GlblNextYear);
        Result := True;
      end;

  If CheckParcelForExistence(ParcelTable, ThisYear, GlblThisYear, SwisSBLKey)
    then
      begin
        Result := True;
        YearsOfExistence.Add(GlblThisYear);

      end;  {If CheckParcelForExistence(ParcelTable, ThisYear, GlblThisYear, SwisSBLKey)}

  AssessmentYearControlTable.First;
  FirstTimeThrough := True;

  with AssessmentYearControlTable do
    repeat
      If FirstTimeThrough
        then FirstTimeThrough := False
        else Next;

      Done := EOF;

      If ((not Done) and
          CheckParcelForExistence(ParcelTable, History, FieldByName('TaxRollYr').Text, SwisSBLKey))
        then
          begin
            Result := True;
            YearsOfExistence.Add(FieldByName('TaxRollYr').Text);

          end;  {If ((not Done) and ...}

    until Done;

  ParcelTable.Close;
  AssessmentYearControlTable.Close;

  ParcelTable.Free;
  AssessmentYearControlTable.Free;

end;  {ParcelExistsInAnyYear}

{=============================================================================}
Procedure DeleteRecordsForThisTable(    DestTable : TTable;
                                        TableName : String;
                                        AssessmentYear : String;
                                        ProcessingType : Integer;
                                        SwisSBLKey : String;
                                    var Quit : Boolean);

begin
  DestTable.IndexName := '';
  OpenTableForProcessingType(DestTable, TableName, ProcessingType, Quit);

  If not Quit
    then DeleteRecordsForParcel(DestTable, AssessmentYear, SwisSBLKey, Quit);

  DestTable.Close;

end;   {DeleteRecordsForThisTable}

{============================================================================}
Procedure DeleteParcelPermanently(    AssessmentYear : String;
                                      SwisSBLKey : String;
                                  var Quit : Boolean);

var
  ProcessingType : Integer;
  DestinationTable : TTable;

begin
  Quit := False;
  ProcessingType := GetProcessingTypeForTaxRollYear(AssessmentYear);
  DestinationTable := TTable.Create(nil);

  OpenTableForProcessingType(DestinationTable, ParcelTableName, ProcessingType, Quit);

  If not Quit
    then
      If _Locate(DestinationTable, [AssessmentYear, SwisSBLKey], 'BYTAXROLLYR_SWISSBLKEY', [loParseSwisSBLKey, loChangeIndex])
        then
          try
            DestinationTable.Delete;
          except
            Quit := True;
          end;

  If not Quit
    then DeleteRecordsForThisTable(DestinationTable, AssessmentTableName,
                                   AssessmentYear, ProcessingType, SwisSBLKey, Quit);

  If not Quit
    then DeleteRecordsForThisTable(DestinationTable, ClassTableName,
                                   AssessmentYear, ProcessingType, SwisSBLKey, Quit);

  If not Quit
    then DeleteRecordsForThisTable(DestinationTable, SpecialDistrictTableName,
                                   AssessmentYear, ProcessingType, SwisSBLKey, Quit);

  If not Quit
    then DeleteRecordsForThisTable(DestinationTable, ExemptionsTableName,
                                   AssessmentYear, ProcessingType, SwisSBLKey, Quit);

  If not Quit
    then DeleteRecordsForThisTable(DestinationTable, ExemptionsDenialTableName,
                                   AssessmentYear, ProcessingType, SwisSBLKey, Quit);

  If not Quit
    then DeleteRecordsForThisTable(DestinationTable, ResidentialSiteTableName,
                                   AssessmentYear, ProcessingType, SwisSBLKey, Quit);

  If not Quit
    then DeleteRecordsForThisTable(DestinationTable, ResidentialBldgTableName,
                                   AssessmentYear, ProcessingType, SwisSBLKey, Quit);

  If not Quit
    then DeleteRecordsForThisTable(DestinationTable, ResidentialForestTableName,
                                   AssessmentYear, ProcessingType, SwisSBLKey, Quit);

  If not Quit
    then DeleteRecordsForThisTable(DestinationTable, ResidentialLandTableName,
                                   AssessmentYear, ProcessingType, SwisSBLKey, Quit);

  If not Quit
    then DeleteRecordsForThisTable(DestinationTable, ResidentialImprovementsTableName,
                                   AssessmentYear, ProcessingType, SwisSBLKey, Quit);

  If not Quit
    then DeleteRecordsForThisTable(DestinationTable, CommercialSiteTableName,
                                   AssessmentYear, ProcessingType, SwisSBLKey, Quit);

  If not Quit
    then DeleteRecordsForThisTable(DestinationTable, CommercialBldgTableName,
                                   AssessmentYear, ProcessingType, SwisSBLKey, Quit);

  If not Quit
    then DeleteRecordsForThisTable(DestinationTable, CommercialLandTableName,
                                  AssessmentYear, ProcessingType, SwisSBLKey, Quit);

  If not Quit
    then DeleteRecordsForThisTable(DestinationTable, CommercialImprovementsTableName,
                                   AssessmentYear, ProcessingType, SwisSBLKey, Quit);

  If not Quit
    then DeleteRecordsForThisTable(DestinationTable, CommercialIncomeExpenseTableName,
                                   AssessmentYear, ProcessingType, SwisSBLKey, Quit);

  If not Quit
    then DeleteRecordsForThisTable(DestinationTable, CommercialRentTableName,
                                   AssessmentYear, ProcessingType, SwisSBLKey, Quit);

  If not Quit
    then DeleteRecordsForThisTable(DestinationTable, AssessmentNotesTableName,
                                   AssessmentYear, ProcessingType, SwisSBLKey, Quit);

  If not Quit
    then DeleteRecordsForThisTable(DestinationTable, AssessmentLetterTextTableName,
                                   AssessmentYear, ProcessingType, SwisSBLKey, Quit);

  If not Quit
    then DeleteRecordsForThisTable(DestinationTable, UserDataTableName,
                                   AssessmentYear, ProcessingType, SwisSBLKey, Quit);

  If not Quit
    then DeleteRecordsForThisTable(DestinationTable, NotesTableName,
                                   AssessmentYear, ProcessingType, SwisSBLKey, Quit);

  If not Quit
    then DeleteRecordsForThisTable(DestinationTable, SalesTableName,
                                   AssessmentYear, ProcessingType, SwisSBLKey, Quit);

  If not Quit
    then DeleteRecordsForThisTable(DestinationTable, AssessmentNotesTableName,
                                   AssessmentYear, ProcessingType, SwisSBLKey, Quit);

  If not Quit
    then DeleteRecordsForThisTable(DestinationTable, AssessmentLetterTextTableName,
                                   AssessmentYear, ProcessingType, SwisSBLKey, Quit);

  If not Quit
    then DeleteRecordsForThisTable(DestinationTable, ExemptionsRemovedTableName,
                                   AssessmentYear, ProcessingType, SwisSBLKey, Quit);

  If not Quit
    then DeleteRecordsForThisTable(DestinationTable, PictureTableName,
                                   AssessmentYear, ProcessingType, SwisSBLKey, Quit);

  If not Quit
    then DeleteRecordsForThisTable(DestinationTable, DocumentTableName,
                                   AssessmentYear, ProcessingType, SwisSBLKey, Quit);

  If not Quit
    then DeleteRecordsForThisTable(DestinationTable, ThirdPartyNotificationTableName,
                                   AssessmentYear, ProcessingType, SwisSBLKey, Quit);

  DestinationTable.Free;

end;  {DeleteParcelPermanently}

{=======================================================================}
Procedure GetAllAssessmentYears(AssessmentYears : TStringList); overload;

var
  AssessmentYearControlTable : TTable;
  Quit : Boolean;

begin
  AssessmentYearControlTable := TTable.Create(nil);

  OpenTableForProcessingType(AssessmentYearControlTable, AssessmentYearControlTableName, History, Quit);

  AssessmentYears.Add(GlblNextYear);
  AssessmentYears.Add(GlblThisYear);

  AssessmentYearControlTable.First;

  with AssessmentYearControlTable do
    while not EOF do
      begin
        AssessmentYears.Add(FieldByName('TaxRollYr').Text);
        Next;
      end;

  AssessmentYearControlTable.Close;
  AssessmentYearControlTable.Free;

end;  {GetAllAssessmentYears}

{=======================================================================}
Procedure GetAllAssessmentYears(AssessmentYears : TStringList;
                                DatabaseName : String); overload;

var
  tb_AssessmentYear : TTable;

begin
  AssessmentYears.Clear;
  tb_AssessmentYear := TTable.Create(nil);

  _OpenTable(tb_AssessmentYear, AssessmentYearControlTableName, DatabaseName, '', NextYear, []);
  AssessmentYears.Add(tb_AssessmentYear.FieldByName('TaxRollYr').AsString);

  _OpenTable(tb_AssessmentYear, AssessmentYearControlTableName, DatabaseName, '', ThisYear, []);
  AssessmentYears.Add(tb_AssessmentYear.FieldByName('TaxRollYr').AsString);

  _OpenTable(tb_AssessmentYear, AssessmentYearControlTableName, DatabaseName, 'BYTAXROLLYR', History, []);

  with tb_AssessmentYear do
    begin
      Last;

      while not BOF do
        begin
          AssessmentYears.Add(FieldByName('TaxRollYr').Text);
          Prior;
        end;

    end;  {with tb_AssessmentYear do}

  tb_AssessmentYear.Close;
  tb_AssessmentYear.Free;

end;  {GetAllAssessmentYears}

{====================================================================}
Function GetCooperativeBase(SBL : String;
                            AccountNumber : String;
                            BaseIsSBL : Boolean;
                            IncludeSublotInBaseSBL : Boolean) : String;

begin
  If BaseIsSBL
    then
      begin
        If IncludeSublotInBaseSBL
          then Result := Copy(SBL, 1, 16)
          else Result := Copy(SBL, 1, 13)
      end
    else Result := Copy(AccountNumber, 1, 6);

end;  {GetCooperativeBase}

{========================================================================}
Function GetPropertyClass_OwnershipCode(PropertyClassCode : String;
                                        OwnershipCode : String) : String; overload;

begin
  Result := PropertyClassCode + OwnershipCode;
end;  {GetPropertyClass_OwnershipCode}

{========================================================================}
Function GetPropertyClass_OwnershipCode(Table : TTable) : String; overload;

begin
  with Table do
    try
      Result := GetPropertyClass_OwnershipCode(FieldByName('PropertyClassCode').AsString,
                                               FieldByName('OwnershipCode').AsString);
    except
      Result := '';
    end;

end;  {GetPropertyClass_OwnershipCode}

{==============================================================================}
Function GetMalverneSwisSBLFromPrintKey(PrintKey : String;
                                        SwisCode : String) : String;

var
  SlashPos : Integer;

begin
  Result := '';

  SlashPos := Pos('/', PrintKey);
  Result := ShiftRightAddZeroes(Copy(PrintKey, 1, (SlashPos - 1)), 3);
  Delete(PrintKey, 1, SlashPos);

  SlashPos := Pos('/', PrintKey);
  Result := Result + Copy(PrintKey, 1, (SlashPos - 1)) +
                     ConstStr(' ', (11 - SlashPos));
  Delete(PrintKey, 1, SlashPos);

  Result := SwisCode + Result + PrintKey;

end;  {GetMalverneSwisSBLFromPrintKey}

{=============================================================================}
Function GetAssessmentDisplayFormat : String;

begin
  If GlblSupressDollarSignsOnAssessments
    then Result := CurrencyDisplayNoDollarSign
    else Result := CurrencyNormalDisplay;

end;  {GetAssessmentDisplayFormat}

{=============================================================================}
Function ParcelIsNonImprovedVacantLand(PropertyClass : String) : Boolean;

begin
  Result := (_Compare(PropertyClass, '3', coStartsWith) and
             _Compare(PropertyClass, '312', coNotEqual) and  {Vacant land w\small improvement}
             _Compare(PropertyClass, '316', coNotEqual));  {Waterfront vacant land w\small improvement}

end;  {ParcelIsNonImprovedVacantLand}

{=======================================================================}
Function GetSketchLocation(SketchTable : TTable;
                           ApexInstalled : Boolean) : String;

begin
  Result := SketchTable.FieldByName('SketchLocation').Text;

    {FXX08232004-3(2.08.0.08302004): Change to Windows metafile for better clarity.}

  If not ApexInstalled
    then Result := ConvertFileNameToApexWMFFileName(Result, False, True);

  If not FileExists(Result)
    then Result := ChangeLocationToLocalDrive(Result);

end;  {GetSketchLocation}

{===================================================================}
Function GetMunicityCODateForPermit(qryCertificates : TADOQuery;
                                    sPermitID : String;
                                    sParcelID : String) : String;

begin
  Result := '';

(*  _ADOQuery(qryCertificates,
            ['Select Top(1) c1.CertificateDate, c1.CertificateType, c1.Permit_ID from Certificates c1',
             'Inner Join Certificates c2 on',
             '(c1.Certificate_ID = c2.Certificate_ID)',
             'where (c1.Permit_ID = ' + FormatSQLString(sPermitID) + ') and',
             '      (c1.CertificateType = ' + FormatSQLString('CO') + ')',
             'order by Cast(c1.CertificateDate as DateTime) DESC']);

  If (qryCertificates.Active and
      _Compare(qryCertificates.RecordCount, 0, coGreaterThan))
    then Result := qryCertificates.FieldByName('CertificateDate').AsString;  *)

(*  _ADOQuery(qryCertificates,
            ['Select c1.CertificateDate, c1.CertificateType, c1.Permit_ID from Certificates c1',
             'Inner Join Certificates c2 on',
             '(c1.Certificate_ID = c2.Certificate_ID)',
             'where (c1.Permit_ID = ' + FormatSQLString(sPermitID) + ') and',
             '      (c1.CertificateType = ' + FormatSQLString('CO') + ')',
             'order by Cast(c1.CertificateDate as DateTime) DESC']); *)

(*  _ADOQuery(qryCertificates,
            ['Select c1.CertificateDate, c1.CertificateType,',
            '        c1.Permit_ID, c1.Certificate_ID, pcm.Parcel_ID from Certificates c1',
             'Inner Join Certificates c2 on',
             '  (c1.Certificate_ID = c2.Certificate_ID)',
             'Left Outer Join ParcelCertificateMap pcm on',
             '  (c1.Certificate_ID = ParcelCertificateMap.Certificate_ID)',
             'where (c1.Permit_ID = ' + FormatSQLString(sPermitID) + ') and',
             '      (c1.CertificateType = ' + FormatSQLString('CO') + ') and',
             '      (pcm.Parcel_ID = ' + FormatSQLString(sParcelID) + ')',
             'order by Cast(c1.CertificateDate as DateTime) DESC']); *)

  _ADOQuery(qryCertificates,
            ['Select c1.CertificateDate, c1.CertificateType,',
            '        c1.Permit_ID, c1.Certificate_ID, pcm.Parcel_ID from Certificates c1',
             'inner Join ParcelCertificateMap pcm on',
             '  ((c1.Certificate_ID = pcm.Certificate_ID) and',
             '   (pcm.Parcel_ID = ' + FormatSQLString(sParcelID) + '))',
             'where (c1.Permit_ID = ' + FormatSQLString(sPermitID) + ') and',
             '      (c1.CertificateType = ' + FormatSQLString('CO') + ')']);

  with qryCertificates do
    If (Active and
        _Compare(RecordCount, 0, coGreaterThan))
      then
        begin
          First;

          while (not EOF) do
            begin
              try
                If (_Compare(FieldByName('CertificateDate').AsString, coNotBlank) and
                    (_Compare(Result, coBlank) or
                     _Compare(FieldByName('CertificateDate').AsDateTime, StrToDate(Result), coGreaterThan)))
                      then Result := FieldByName('CertificateDate').AsString;

              except
              end;

              Next;

            end;  {while (not EOF) do}

        end;  {with qryCertificates do}

end;  {GetMunicityCODateForPermit}

{===========================================================================}
Function GetPOBoxFromAddressLine(sAddress : String) : String;

begin
  Result := '';
  If _Compare(sAddress, ['P.O.', 'P O', 'PO BOX', 'P.O'], coContains)
    then Result := sAddress;
    
end;  {GetPOBoxFromAddressLine}

{===========================================================================}
Function GetPOBox(tbParcels : TTable) : String;

begin
  Result := GetPOBoxFromAddressLine(tbParcels.FieldByName('Address1').AsString);

  If _Compare(Result, coBlank)
    then Result := GetPOBoxFromAddressLine(tbParcels.FieldByName('Address2').AsString);

end;  {GetPOBox}

{=============================================================================}
Function VillageIsAssessingUnit(sSWISCode : String) : Boolean;

begin
  Result := (_Locate(PASDataModule.TYSwisCodeTable, [sSWISCode], '', []) and
             PASDataModule.TYSwisCodeTable.FieldByName('AssessingVillage').AsBoolean)

end;  {VillageIsAssessingUnit}

{=============================================================================}
Function GetCodeDescription(sCodeValue : String;
                            sTableName : String) : String;

var
  tbCodeTable : TTable;

begin
  Result := '';

  If _Compare(sCodeValue, coNotBlank)
    then
      try
        tbCodeTable := TTable.Create(nil);
        _OpenTable(tbCodeTable, sTableName, '', 'BYMAINCODE', noProcessingType, []);

        If _Locate(tbCodeTable, [sCodeValue], '', [])
          then Result := tbCodeTable.FieldByName('Description').AsString;

        tbCodeTable.Free;
      except 
      end;  {If _Compare(sCodeValue, coNotBlank)}

end;  {GetCodeDescription}

{===========================================================================}
Function CheckTaxSystemStatus(    sSchoolCode : String;
                                  sSwisCode : String;
                                  sSBL : String;
                                  iTaxSystemType : Integer;
                                  sCountyTaxDatabaseName : String;
                                  sTaxRatePointer : String;
                              var iTaxSystemAssessedValue : Integer;
                              var iTaxSystemExemptionValue : Integer;
                              var iTaxSystemTaxableValue : Integer) : Boolean;

var
  tbPay, tbDue,
  tbParcels, tbBaseTaxes : TTable;
  sDatabaseName : String;
  fBaseDueAmount, fBasePaidAmount : Double;

begin
  iTaxSystemAssessedValue := 0;
  iTaxSystemExemptionValue := 0;
  iTaxSystemTaxableValue := 0;

  tbPay := TTable.Create(nil);
  tbDue := TTable.Create(nil);
  tbParcels := TTable.Create(nil);
  tbBaseTaxes := TTable.Create(nil);

  case iTaxSystemType of
    tsCounty :
      begin
        sDatabaseName := sCountyTaxDatabaseName;
        sSchoolCode := '999999';
      end;

  end;  {case iTaxSystemType of}

  _OpenTable(tbDue, 'DueFile', sDatabaseName, 'BYSCHOOLCODEKEY_SWISCODE_SBL', NoProcessingType, []);
  _OpenTable(tbPay, 'PayFile', sDatabaseName, 'BYAPPLYTONO', NoProcessingType, []);
  _OpenTable(tbParcels, 'parcelyearmasterfile', sDatabaseName, 'BYSCHOOLKEYCODE_SWISCODE_SBL', NoProcessingType, []);
  _OpenTable(tbBaseTaxes, 'basetaxdetailsfile', sDatabaseName, 'BYSCHOOLCODEKEY_SWISCODE_SBL', NoProcessingType, []);

  _SetRange(tbDue, [sSchoolCode, sSwisCode, sSBL], [], '', [loSameEndingRange]);
  tbDue.First;

  fBaseDueAmount := 0;
  fBasePaidAmount := 0;

  with tbDue do
    while (not EOF) do
    begin
      If FieldByName('Base').AsBoolean
        then
        begin
          fBaseDueAmount := fBaseDueAmount + FieldByName('Amount').AsFloat;
          _SetRange(tbPay, [FieldByName('DocumentNo').AsString], [], '', [loSameEndingRange]);
          fBasePaidAmount := fBasePaidAmount + SumTableColumn(tbPay, 'Amount');

        end;  {If FieldByName('Base').AsBoolean}

      Next;

    end;  {while (not EOF) do}

  Result := _Compare(fBaseDueAmount, fBasePaidAmount, coEqual);

  If _Locate(tbParcels, [sSchoolCode, sSwisCode, sSBL], '', [])
    then
    begin
      iTaxSystemAssessedValue := tbParcels.FieldByName('AssessedVal').AsInteger;

      _SetRange(tbBaseTaxes, [sSchoolCode, sSwisCode, sSBL, ''], [sSchoolCode, sSwisCode, sSBL, 'zzz'], '', []);
      tbBaseTaxes.First;

      with tbBaseTaxes do
      begin
        If _Compare(FieldByName('BaseTaxRatePtr').AsString, sTaxRatePointer, coEqual)
          then
          begin
            iTaxSystemTaxableValue := FieldByName('TaxableVal').AsInteger;
            iTaxSystemExemptionValue := iTaxSystemAssessedValue - iTaxSystemTaxableValue;
          end;

        Next;

      end;  {with tbBaseTaxes do}

    end;  {If _Locate(tbParcels, [sSchoolCode, sSwisCode, sSBL], '', [])}

  tbPay.Close;
  tbDue.Close;
  tbParcels.Close;
  tbBaseTaxes.Close;

  tbPay.Free;
  tbDue.Free;
  tbParcels.Free;
  tbBaseTaxes.Free;

end;  {CheckTaxSystemStatus}


{===========================================================================}
Function CheckTaxSystemStatus_SQL(    sSchoolCode : String;
                                      sSwisCode : String;
                                      sSBL : String;
                                      iTaxSystemType : Integer;
                                      sCountyTaxDatabaseName : String;
                                      sTaxRatePointer : String;
                                  var iTaxSystemAssessedValue : Integer;
                                  var iTaxSystemExemptionValue : Integer;
                                  var iTaxSystemTaxableValue : Integer) : Boolean;

var
  sDatabaseName : String;
  fBaseDueAmount, fBasePaidAmount : Double;
  qryTax : TADOQuery;
  adoConnection : TADOConnection;
  iCollectionID : Integer;

begin
  iTaxSystemAssessedValue := 0;
  iTaxSystemExemptionValue := 0;
  iTaxSystemTaxableValue := 0;

  try
    adoConnection := TADOConnection.Create(nil);
    adoConnection.ConnectionString := 'FILE NAME=' + GlblProgramDir + 'LocalTax.udl';
    adoConnection.LoginPrompt := False;
    adoConnection.Connected := True;
    qryTax := TADOQuery.Create(nil);
    qryTax.Connection := adoConnection;

    //ShowMessage('1');
    _ADOQuery(qryTax,
              ['Select * from CollectionsAvailableTable',
               'where (CollectionType in (' + FormatSQLString('CO') + '))',
               'order by TaxYear desc']);
    qryTax.First;
    If _Compare(qryTax.RecordCount, 0, coEqual)
    then iCollectionID := 0
    else iCollectionID := qryTax.FieldByName('Collection_ID').AsInteger;

    case iTaxSystemType of
      tsCounty :
        begin
          sDatabaseName := sCountyTaxDatabaseName;
          sSchoolCode := '999999';
        end;

    end;  {case iTaxSystemType of}

    //ShowMessage('2');
    _ADOQuery(qryTax,
              ['Select TaxableVal, AssessedVal, d.Amount as DueAmount, d.Base, py.Amount as PaidAmount from ParcelYearMasterFile p',
               'inner join DueFile d on',
               '(d.SBL = p.SBL) and (d.Collection_ID = ' + IntToStr(iCollectionID) + ')',
               'left outer join PayFile py on',
               '(py.ApplyToNo = d.DocumentNo) and (py.Collection_ID = ' + IntToStr(iCollectionID) + ')',
               'where (p.SBL = ' + FormatSQLString(sSBL) + ') and (p.SwisCode = ' + FormatSQLString(sSwisCode) + ') and (p.SchoolKeyCode = ' + FormatSQLString(sSchoolCode) + ') and (p.Collection_ID = ' + IntToStr(iCollectionID) + ')']);

    qryTax.First;

    fBaseDueAmount := 0;
    fBasePaidAmount := 0;

    with qryTax do
      while (not EOF) do
      begin
        If FieldByName('Base').AsBoolean
        then
        begin
          fBaseDueAmount := fBaseDueAmount + FieldByName('DueAmount').AsFloat;
          fBasePaidAmount := fBasePaidAmount + FieldByName('PaidAmount').AsFloat;

        end;  {If FieldByName('Base').AsBoolean}

        Next;

      end;  {while (not EOF) do}

    _ADOQuery(qryTax,
              ['Select AssessedVal from ParcelYearMasterFile p',
               'where (p.SBL = ' + FormatSQLString(sSBL) + ') and (p.SwisCode = ' + FormatSQLString(sSwisCode) + ') and (p.SchoolKeyCode = ' + FormatSQLString(sSchoolCode) + ') and (p.Collection_ID = ' + IntToStr(iCollectionID) + ')']);

    qryTax.First;
    iTaxSystemAssessedValue := qryTax.FieldByName('AssessedVal').AsInteger;

    _ADOQuery(qryTax,
              ['Select AssessedVal, e.Amount as ExemptionAmount from ParcelYearMasterFile p',
               'inner join ExemptionDetailsFile e on',
               '(e.SBL = p.SBL) and (e.Collection_ID = ' + IntToStr(iCollectionID) + ')',
               'where (p.SBL = ' + FormatSQLString(sSBL) + ') and (p.SwisCode = ' + FormatSQLString(sSwisCode) + ') and (p.SchoolKeyCode = ' + FormatSQLString(sSchoolCode) + ') and (p.Collection_ID = ' + IntToStr(iCollectionID) + ')']);

    qryTax.First;
    iTaxSystemExemptionValue := 0;

    with qryTax do
      while (not EOF) do
      begin
        iTaxSystemExemptionValue := iTaxSystemExemptionValue + FieldByName('ExemptionAmount').AsInteger;
        Next;

      end;  {while (not EOF) do}

    iTaxSystemTaxableValue := iTaxSystemAssessedValue - iTaxSystemExemptionValue;

    Result := _Compare(fBaseDueAmount, fBasePaidAmount, coEqual);
  finally
    adoConnection.Close;
    adoConnection.Free;
    qryTax.Free;
  end;

end;  {CheckTaxSystemStatus_SQL}

{========================================================================}
Procedure AutoUpdateNamesAndAddressesOneDatabase(tbTaxParcels : TTable;
                                                 tbPASParcels : TTable;
                                                 sDatabaseName : String;
                                                 sSwisSBL : String;
                                                 sAssessmentYear : String);

var
  sSwisCode, sSBL, sSchoolCode : String;
  flLogFile : TextFile;
  NAddrArray : NameAddrArray;

begin
  _Locate(tbPASParcels, [sAssessmentYear, sSwisSBL], '', [loParseSwisSBLKey]);
  sSwisCode := Copy(sSwisSBL, 1, 6);
  sSBL := Copy(sSwisSBL, 7, 20);
  sSchoolCode := tbPASParcels.FieldByName('SchoolCode').AsString;

  _OpenTable(tbTaxParcels, 'parcelyearmasterfile', sDatabaseName, 'BYSCHOOLKEYCODE_SWISCODE_SBL', NoProcessingType, []);

  If _Compare(tbTaxParcels.FieldByName('CollectionType').AsString, 'SC', coNotEqual)
  then sSchoolCode := '999999';

  If not FileExists(glblProgramDir + 'NameAddressUpdateLog.txt')
  then
  begin
    AssignFile(flLogFile, glblProgramDir + 'NameAddressUpdateLog.txt');
    Rewrite(flLogFile);
    CloseFile(flLogFile);
  end;
  
  If _Locate(tbTaxParcels, [sSchoolCode, sSwisCode, sSBL], '', [])
  then
  begin
    GetNameAddress(tbPASParcels, NAddrArray);

    with tbTaxParcels do
    begin
      AssignFile(flLogFile, glblProgramDir + 'NameAddressUpdateLog.txt');
      System.Append(flLogFile);
      WritelnCommaDelimitedLine(flLogFile,
                                [sSwisSBL, DateToStr(Date), TimeToStr(Now),
                                 FieldByName('Name1').AsString,
                                 FieldByName('Name2').AsString,
                                 FieldByName('Address1').AsString,
                                 FieldByName('Address2').AsString,
                                 FieldByName('Address3').AsString,
                                 FieldByName('Address4').AsString,
                                 NAddrArray[1],
                                 NAddrArray[2],
                                 NAddrArray[3],
                                 NAddrArray[4],
                                 NAddrArray[5],
                                 NAddrArray[6]]);

      CloseFile(flLogFile);

      try
        Edit;
        FieldByName('Name1').AsString := NAddrArray[1];
        FieldByName('Name2').AsString := NAddrArray[2];
        FieldByName('Address1').AsString := NAddrArray[3];
        FieldByName('Address2').AsString := NAddrArray[4];
        FieldByName('Address3').AsString := NAddrArray[5];
        FieldByName('Address4').AsString := NAddrArray[6];
        Post;
      except
      end;

    end;  {with tbTaxParcels do}

  end
  else
  begin
    AssignFile(flLogFile, glblProgramDir + 'NameAddressUpdateLog.txt');
    System.Append(flLogFile);
    WritelnCommaDelimitedLine(flLogFile,
                              [sSwisSBL, DateToStr(Date), TimeToStr(Now),
                               'Parcel not found in database ' + sDatabaseName + '.']);
    CloseFile(flLogFile);

  end;  {else of If _Locate(tbParcels, [sSchoolCode, sSwisCode, sSBL], '', [])}

end;  {AutoUpdateNamesAndAddressesOneDatabase}

{========================================================================}
Procedure AutoUpdateNamesAndAddressesInOtherSystems(tbPASParcels : TTable;
                                                    sSwisSBL : String;
                                                    sAssessmentYear : String);

var
  tbTaxParcels : TTable;

begin
  tbTaxParcels := TTable.Create(nil);

  If _Compare(glblDatabaseToUpdateNameAddrs1, coNotBlank)
  then AutoUpdateNamesAndAddressesOneDatabase(tbTaxParcels, tbPASParcels,
                                              glblDatabaseToUpdateNameAddrs1,
                                              sSwisSBL, sAssessmentYear);

  If _Compare(glblDatabaseToUpdateNameAddrs2, coNotBlank)
  then AutoUpdateNamesAndAddressesOneDatabase(tbTaxParcels, tbPASParcels,
                                              glblDatabaseToUpdateNameAddrs2,
                                              sSwisSBL, sAssessmentYear);

  If _Compare(glblDatabaseToUpdateNameAddrs3, coNotBlank)
  then AutoUpdateNamesAndAddressesOneDatabase(tbTaxParcels, tbPASParcels,
                                              glblDatabaseToUpdateNameAddrs3,
                                              sSwisSBL, sAssessmentYear);

  tbTaxParcels.Close;
  tbTaxParcels.Free;

end;  {AutoUpdateNamesAndAddressInOtherSystems}

{=================================================================}
Function UserIsSupervisor(sUserName : String) : Boolean;

var
  tbUsers : TTable;

begin
  tbUsers := TTable.Create(nil);
  _OpenTable(tbUsers, UserProfileTableName, '', 'BYUSERID', noProcessingType, []);

  If _Locate(tbUsers, [sUserName], '', [])
  then Result := (_Compare(sUserName, 'SUPERVISOR', coEqual) or
                  tbUsers.FieldByName('SupervisorEquivalent').AsBoolean)
  else Result := False;

end;  {UserIsSupervisor}

{=================================================================}
Function DetermineEditStatusForInventoryForm(EditMode : String;
                                             ProcessingType : Integer;
                                             GlblTaxYearFlag : String;
                                             glblAllowSalesInventoryEdit : Boolean) : Boolean;

var
  bCanEdit : Boolean;

begin
  bCanEdit := True;

  If _Compare(EditMode, 'V', coEqual)
  then bCanEdit := False;

  If _Compare(ProcessingType, SalesInventory, coEqual)
  then
  begin
    If not glblAllowSalesInventoryEdit
    then bCanEdit := False;
  end
  else
    If _Compare(ProcessingType, DetermineProcessingType(GlblTaxYearFlg), coNotEqual)
    then bCanEdit := False;

  Result := bCanEdit;

end;  {DetermineEditStatusForInventoryForm}


{INITIALIZATION CODE IS VACUOUS }

BEGIN
END.