�
 TROLLSCANUTILITYFORM 0�  TPF0TRollScanUtilityFormRollScanUtilityFormLeftzTop Width�Height�BorderIcons CaptionImport Bank CodesColor	clBtnFaceFont.CharsetDEFAULT_CHARSET
Font.ColorclBlackFont.Height�	Font.NameArial
Font.Style 	FormStyle
fsMDIChild
KeyPreview	OldCreateOrder	Position	poDefaultVisible	OnClose	FormClose
OnKeyPressFormKeyPressPixelsPerInch`
TextHeight TPanelPanel1Left Top WidthxHeight)AlignalTopTabOrder  TLabel
TitleLabelLeft� Top
Width� HeightCaptionImport Bank CodesFont.CharsetDEFAULT_CHARSET
Font.ColorclRedFont.Height�	Font.NameArial
Font.Style 
ParentFont   TPanelPanel2Left Top)WidthxHeighttAlignalClient
BevelInner	bvLoweredBorderWidthTabOrder 
TScrollBox
ScrollBox1LeftTopWidthlHeighthAlignalClientBorderStylebsNoneTabOrder  TLabelLabel1Left� TopWidthzHeightCaptionTSO Code To ClearFont.CharsetDEFAULT_CHARSET
Font.ColorclMaroonFont.Height�	Font.NameArial
Font.StylefsBold 
ParentFont  TLabelInstructionLabelLeft~Top� Width�HeightCaption�IMPORTANT:  Before starting this process, please~ insure no users are editing the  "This Year" parcel file.  Then enter a 3-character TSO code (eg "TRA") and click the "Do Import" button.Font.CharsetDEFAULT_CHARSET
Font.ColorclMaroonFont.Height�	Font.NameArial
Font.StylefsBold 
ParentFont  TLabel
tracelabelLeft>TopLWidth8HeightCaption
tracelabel  TBitBtnCloseButtonLeftTop8WidthYHeight!TabOrder OnClickCloseButtonClickKindbkClose  TEditTSOCodeEditLeft*TopWidth2HeightHint$Enter a 3-charactar TSO code, eg TRACharCaseecUpperCase	MaxLengthTabOrder  TButtonImportButtonLeftTop\WidthYHeight!Caption	Run Scan Font.CharsetDEFAULT_CHARSET
Font.ColorclMaroonFont.Height�	Font.NameArial
Font.StylefsBold 
ParentFontTabOrderOnClickImportButtonClick    TTableSysrecTableDatabaseName	PASsystem	TableNameSystemRecordLeftNTop TStringFieldSysrecTableSysNextYear	FieldNameSysNextYearSize(  TStringFieldSysrecTableSysThisYear	FieldNameSysThisYearSize(   TOpenDialogTSODiskOpenDialogFileName*.*
InitialDirA:\TitleSelect TSO File To ImportLeft.Top�   TReportPrinterReportPrinterStatusFormatPrinting page %pUnitsFactor       ��?TitleReportPrinter ReportOrientation
poPortraitScaleX       �@ScaleY       �@OnPrintReportPrinterPrintOnPrintHeaderReportFilerPrintHeaderLeft�Top  TReportFilerReportFilerStatusFormatPrinting page %pUnitsFactor       ��?TitleReportPrinter ReportOrientation
poPortraitScaleX       �@ScaleY       �@OnPrintReportPrinterPrintOnPrintHeaderReportFilerPrintHeaderLeft�Top  TPrintDialogPrintDialogOptionspoPrintToFile PrintToFile	Left�Top  TTableParcelTableDatabaseName	PASsystem	TableName
TParcelRecLeftTop TStringFieldParcelTableTaxRollYr	FieldName	TaxRollYrSize  TStringFieldParcelTableSwisCode	FieldNameSwisCodeSize  TStringFieldParcelTableSection	FieldNameSectionSize  TStringFieldParcelTableSubsection	FieldName
SubsectionSize  TStringFieldParcelTableBlock	FieldNameBlockSize  TStringFieldParcelTableLot	FieldNameLotSize  TStringFieldParcelTableSublot	FieldNameSublotSize  TStringFieldParcelTableSuffix	FieldNameSuffixSize  TStringFieldParcelTableActiveFlag	FieldName
ActiveFlagSize  TStringFieldParcelTableRelatedSBL	FieldName
RelatedSBLSize  TStringFieldParcelTableSBLRelationship	FieldNameSBLRelationshipSize  TStringFieldParcelTableRemapOldSBL	FieldNameRemapOldSBLSize  TStringFieldParcelTableCheckDigit	FieldName
CheckDigitSize  TStringFieldParcelTableSchoolCode	FieldName
SchoolCodeSize  TStringFieldParcelTableName1	FieldNameName1Size  TStringFieldParcelTableName2	FieldNameName2Size  TStringFieldParcelTableAddress1	FieldNameAddress1Size  TStringFieldParcelTableAddress2	FieldNameAddress2Size  TStringFieldParcelTableStreet	FieldNameStreetSize  TStringFieldParcelTableCity	FieldNameCitySize  TStringFieldParcelTableState	FieldNameStateSize  TStringFieldParcelTableZip	FieldNameZipSize
  TStringFieldParcelTableZipPlus4	FieldNameZipPlus4Size  TStringFieldParcelTablePropDescr1	FieldName
PropDescr1Size  TStringFieldParcelTablePropDescr2	FieldName
PropDescr2Size  TStringFieldParcelTablePropDescr3	FieldName
PropDescr3Size  TStringFieldParcelTablePropertyClassDesc	FieldNamePropertyClassDesc  TStringFieldParcelTablePropertyClassCode	FieldNamePropertyClassCodeSize  TStringFieldParcelTableHomesteadDesc	FieldNameHomesteadDesc  TStringFieldParcelTableHomesteadCode	FieldNameHomesteadCodeSize  TStringFieldParcelTableOwnershipCode	FieldNameOwnershipCodeSize  TStringFieldParcelTableOwnershipDesc	FieldNameOwnershipDesc  TStringFieldParcelTableLegalAddrNo	FieldNameLegalAddrNoSize
  TStringFieldParcelTableLegalAddr	FieldName	LegalAddrSize  
TDateFieldParcelTableLastChangeDate	FieldNameLastChangeDate  TStringFieldParcelTableLastChangeByName	FieldNameLastChangeByNameSize
  TStringFieldParcelTableRollSection	FieldNameRollSectionSize  TStringFieldParcelTableRollSubsection	FieldNameRollSubsectionSize  TStringFieldParcelTableBankCode	FieldNameBankCodeSize  TStringFieldParcelTableDeedBook	FieldNameDeedBookSize  TStringFieldParcelTableDeedPage	FieldNameDeedPageSize  TFloatFieldParcelTableFrontage	FieldNameFrontage  TFloatFieldParcelTableDepth	FieldNameDepth  TFloatFieldParcelTableAcreage	FieldNameAcreage  TIntegerFieldParcelTableGridCordNorth	FieldNameGridCordNorth  TIntegerFieldParcelTableGridCordEast	FieldNameGridCordEast  TStringFieldParcelTableAuditControl	FieldNameAuditControlSize  TStringFieldParcelTableAccountNo	FieldName	AccountNoSize  TStringFieldParcelTableLotGroup	FieldNameLotGroupSize  TStringFieldParcelTableAdditionalLots	FieldNameAdditionalLotsSize  TFloatFieldParcelTableResidentialPercent	FieldNameResidentialPercent  
TDateFieldParcelTableParcelCreatedDate	FieldNameParcelCreatedDate  TStringFieldParcelTableSplitMergeNo	FieldNameSplitMergeNoSize  TStringFieldParcelTableConsolidatedSchlDist	FieldNameConsolidatedSchlDistSize  TStringFieldParcelTableDescriptionPrintCode	FieldNameDescriptionPrintCodeSize  TStringFieldParcelTableEasementCode	FieldNameEasementCodeSize  TStringFieldParcelTableEasementDesc	FieldNameEasementDesc  TStringFieldParcelTableLandCommitmentCode	FieldNameLandCommitmentCodeSize  TStringFieldParcelTableLandCommitmentDesc	FieldNameLandCommitmentDesc  TStringFieldParcelTableCommitmentTermYear	FieldNameCommitmentTermYearSize  TFloatFieldParcelTableAllocationFactor	FieldNameAllocationFactor  TStringFieldParcelTableHoldPriorHomestead	FieldNameHoldPriorHomesteadSize  TSmallintFieldParcelTableAssociatedSaleNumber	FieldNameAssociatedSaleNumber  TBooleanFieldParcelTableIrregularShape	FieldNameIrregularShape  TCurrencyFieldParcelTableSchoolRelevy	FieldNameSchoolRelevy  TCurrencyFieldParcelTableTownRelevy	FieldName
TownRelevy  TStringFieldParcelTableMortgageNumber	FieldNameMortgageNumberSize	  TStringFieldParcelTableRS9LinkedSBL	FieldNameRS9LinkedSBLSize  TStringFieldParcelTableReserved	FieldNameReservedSize2   TTableAssessmentTableDatabaseName	PASsystem	TableNameTPAssessRecLeft~Top  TTableParcelSDTableDatabaseName	PASsystemIndexFieldNames	SdistCode	TableNameTPSpclDistRecLeft� Top  TTableSDCodeTableDatabaseName	PASsystem	TableName
TSDCodeTblLeft� Top  TTableParcelExemptionTableDatabaseName	PASsystem	TableNameTPExemptionRecLeft� Top  TTableExemptionCodeTableDatabaseName	PASsystemIndexFieldNamesExCode	TableName
TExCodeTblLeft.Top  TTableParcelSDLookupTableDatabaseName	PASsystem	TableNameTPSpclDistRecLeftVTop   