�
 TBILLCALCFORM 0�&  TPF0TBillCalcFormBillCalcFormLeft� Top� Width�Height�BorderIcons CaptionCalculate BillsColor	clBtnFaceFont.CharsetDEFAULT_CHARSET
Font.ColorclBlackFont.Height�	Font.NameArial
Font.Style 	FormStyle
fsMDIChild
KeyPreview	OldCreateOrder	Position	poDefaultVisible	
OnActivateFormActivateOnClose	FormClosePixelsPerInch`
TextHeight TPanelPanel1Left Top WidthrHeight)AlignalTopTabOrder  TLabel
TitleLabelLeftTop
WidthvHeightCaptionCalculate BillsFont.CharsetDEFAULT_CHARSET
Font.ColorclRedFont.Height�	Font.NameArial
Font.Style 
ParentFont   TPanelPanel2Left Top)WidthrHeightiAlignalClient
BevelInner	bvLoweredBorderWidthTabOrder 
TScrollBox
ScrollBox1LeftTopWidthfHeight]AlignalClientBorderStylebsNoneTabOrder  TLabelLabel5Left� Top� WidthHeightCaptionSwisVisible  TPageControlPageControl1Left Top)WidthfHeight
ActivePageOptionsTabSheetAlignalClientTabOrder  	TTabSheetOptionsTabSheetCaptionOptions 	TCheckBox$BillNumbersAreAccountNumbersCheckBoxLeftTopWidth� Height	AlignmenttaLeftJustifyCaptionBill #'s are Account #'sFont.CharsetDEFAULT_CHARSET
Font.ColorclBlackFont.Height�	Font.NameArial
Font.StylefsBold 
ParentFontTabOrder   	TCheckBoxNYLegalAddressCheckBoxLeftTop)Width� Height	AlignmenttaLeftJustifyCaptionLegal Address from Next YearFont.CharsetDEFAULT_CHARSET
Font.ColorclBlackFont.Height�	Font.NameArial
Font.StylefsBold 
ParentFontTabOrder  	TCheckBoxIncludeStateLandsCheckBoxLeftTopCWidth� Height	AlignmenttaLeftJustifyCaptionInclude State LandsFont.CharsetDEFAULT_CHARSET
Font.ColorclBlackFont.Height�	Font.NameArial
Font.StylefsBold 
ParentFontTabOrder  	TCheckBoxIncludeWhollyExemptCheckBoxLeftTop]Width� Height	AlignmenttaLeftJustifyCaption Assign Bill #'s to all Wholly ExFont.CharsetDEFAULT_CHARSET
Font.ColorclBlackFont.Height�	Font.NameArial
Font.StylefsBold 
ParentFontTabOrder  	TCheckBox$cb_OnlyCreateBillsForPositiveAmountsLeftTopvWidth� Height	AlignmenttaLeftJustifyCaptionOnly Bill Positive AmountsFont.CharsetDEFAULT_CHARSET
Font.ColorclBlackFont.Height�	Font.NameArial
Font.StylefsBold 
ParentFontTabOrder  	TCheckBoxcbxBillZeroSDRatesLeftTop� Width� Height	AlignmenttaLeftJustifyCaptionBill Zero Special Dist RatesFont.CharsetDEFAULT_CHARSET
Font.ColorclBlackFont.Height�	Font.NameArial
Font.StylefsBold 
ParentFontTabOrder  	TCheckBox(cbxWarnAboutBillsWithoutSpecialDistrictsLeftTop� Width� Height	AlignmenttaLeftJustifyCaption Warn for Bills without DistrictsFont.CharsetDEFAULT_CHARSET
Font.ColorclBlackFont.Height�	Font.NameArial
Font.StylefsBold 
ParentFontTabOrder   	TTabSheet#PreviouslyImportedBankCodesTabSheetCaptionPreviously Imported Bank Codes
ImageIndex 	TwwDBGridBankCodeAuditGridLeftTopWidthHeight� Selected.StringsTSOName	20	TSO NameDateImported	10	Date~ImportedTimeImported	10	Time~ImportedBankReplaced	7	Bank~Replaced!NumImported	10	Num Codes~ImportedImportSuccessful	5	Successful IniAttributes.Delimiter;;
TitleColor	clBtnFace	FixedCols ShowHorzScrollBar	
DataSourceBankCodeAuditDataSourceFont.CharsetDEFAULT_CHARSET
Font.ColorclBlackFont.Height�	Font.NameArial
Font.StylefsBold OptionsdgTitlesdgIndicatordgColumnResize
dgColLines
dgRowLinesdgTabsdgRowSelectdgConfirmDeletedgCancelOnExit
dgWordWrap 
ParentFontReadOnly	TabOrder TitleAlignmenttaCenterTitleFont.CharsetDEFAULT_CHARSETTitleFont.ColorclBlueTitleFont.Height�TitleFont.NameArialTitleFont.StylefsBold 
TitleLinesTitleButtonsIndicatorColoricBlack    TPanelPanel3Left Top WidthfHeight)AlignalTopTabOrder TLabelLabel18LeftTopWidthgHeightCaptionAssessment Year  TLabelLabel1Left� TopWidthXHeightCaptionCollection Type  TLabellabel16LeftkTopWidthDHeightCaptionCollection #  TEditEditTaxRollYearLeftuTopWidth7HeightTabStopColor	clBtnFaceFont.CharsetDEFAULT_CHARSET
Font.ColorclBlueFont.Height�	Font.NameArial
Font.StylefsBold 
ParentFontReadOnly	TabOrder   TwwDBLookupComboLookupCollectionTypeLeft TopWidth2HeightCharCaseecUpperCaseDropDownAlignmenttaLeftJustifySelected.StringsMainCode	3	MainCodeDescription	30	Description 	DataField LookupTableBillCollTypeLookupTableLookupFieldMainCodeOptions
loColLines
loRowLines StylecsDropDownListTabOrderAutoDropDown	
ShowButton	SeqSearchOptions
ssoEnabledssoCaseSensitive AllowClearKey  TEditEditCollectionNumberLeft�TopWidth(HeightTabOrder   TPanelPanel4Left Top4WidthfHeight)AlignalBottomTabOrder TBitBtnStartButtonLeft�TopWidthYHeight!Caption&StartTabOrder OnClickStartButtonClick
Glyph.Data
�  �  BM�      v   (   $            h                       �  �   �� �   � � ��  ��� ���   �  �   �� �   � � ��  ��� 333333333333333333  333333333333�33333  334C3333333733333  33B$3333333s7�3333  34""C333337333333  3B""$33333s337�333  4"*""C3337�7�3333  2"��"C3337�s3333  :*3:"$3337�37�7�33  3�33�"C333s33333  3333:"$3333337�7�3  33333�"C33333333  33333:"$3333337�7�  333333�"C3333333  333333:"C3333337�  3333333�#3333333s  3333333:3333333373  333333333333333333  	NumGlyphs  TBitBtnCloseButtonLeft
TopWidthYHeight!TabOrderOnClickCloseButtonClickKindbkClose     TwwDataSourceBillCtlDataSourceLeft'Topt  TwwTableBillCollTypeLookupTableDatabaseName	PASsystem	IndexName
BYMAINCODE	TableNameZBillCollectionType	TableTypettDBaseSyncSQLByRange	NarrowSearchValidateWithMask	Left� Topk TStringFieldBillCollTypeLookupTableMainCodeDisplayWidth	FieldNameMainCodeSize  TStringField"BillCollTypeLookupTableDescriptionDisplayWidth	FieldNameDescriptionSize   TwwTableSwisCodeTableDatabaseName	PASsystem	IndexName
BYSWISCODE	TableNameTSwisTbl	TableTypettDBaseSyncSQLByRange	NarrowSearchValidateWithMask	LeftTop�   TwwTableSchoolCodeTableDatabaseName	PASsystem	IndexNameBYSCHOOLCODE	TableName
TSchoolTbl	TableTypettDBaseSyncSQLByRange	NarrowSearchValidateWithMask	Left]Top�   TwwTableExCodeTableDatabaseName	PASsystem	IndexNameBYEXCODE	TableName
TExCodeTbl	TableTypettDBaseSyncSQLByRange	NarrowSearchValidateWithMask	LeftTopO  TwwTableTYParcelTableDatabaseName	PASsystem	IndexNameBYTAXROLLYR_SWISSBLKEY	TableName
TParcelRec	TableTypettDBaseSyncSQLByRange	NarrowSearchValidateWithMask	LeftTop�   TwwTableAssessmentTableDatabaseName	PASsystem	IndexNameBYTAXROLLYR_SWISSBLKEY	TableNameTPAssessRec	TableTypettDBaseSyncSQLByRange	NarrowSearchValidateWithMask	Left�Top�   TwwTableParcelExemptionTableDatabaseName	PASsystem	IndexNameBYYEAR_SWISSBLKEY_EXCODE	TableNameTPExemptionRec	TableTypettDBaseSyncSQLByRange	NarrowSearchValidateWithMask	Left�Top1  TwwTableParcelSDTableDatabaseName	PASsystem	IndexNameBYTAXROLLYR_SWISSBLKEY_SD	TableNameTPSpclDistRec	TableTypettDBaseSyncSQLByRange	NarrowSearchValidateWithMask	Left�Top�   TwwTableCollectionControlTableDatabaseName	PASsystem	IndexNameBYYEAR_COLLTYPE_NUM	TableNameBCollControlFile	TableTypettDBaseSyncSQLByRange	NarrowSearchValidateWithMask	Left� Top�   TwwTableSDCodeTableDatabaseName	PASsystem	IndexNameBYSDISTCODE	TableName
TSDCodeTbl	TableTypettDBaseSyncSQLByRange	NarrowSearchValidateWithMask	Left Top+  TTable
ClassTableDatabaseName	PASsystem	IndexNameBYTAXROLLYR_SWISSBLKEY	TableName
TPClassRec	TableTypettDBaseLeft�Top�   TTableBLExemptionTaxTableDatabaseName	PASsystem	IndexNameBYSWISSBLKEY_EXCODE_HC	TableNameBCollBLExemptTax	TableTypettDBaseLeft� TopJ  TTableBLSpecialDistrictTaxTableDatabaseName	PASsystem	IndexNameBYSWISSBL_SD_HC_EXT	TableNameBCollBLSdistTax	TableTypettDBaseLeft� TopP  TTableBLGeneralTaxTableDatabaseName	PASsystem	IndexNameBYSWISSBLKEY_HC_PRINTORDER	TableNameBCollBLGeneralTax	TableTypettDBaseLeft� Top�   TTableBLHeaderTaxTableDatabaseName	PASsystem	IndexNameBYSCHOOL_SWIS_RS_BANK_ADDR	TableNamebcollblhdrtax	TableTypettDBaseLeft� Top  TTableBLSpecialFeeTaxTableDatabaseName	PASsystem	IndexNameBYSWISSBLKEY_PRINTORDER	TableNameBCollBLSPFeeTax	TableTypettDBaseLeft� Top*  TwwTableNYParcelTableDatabaseName	PASsystem	IndexNameBYTAXROLLYR_SWISSBLKEY	TableTypettDBaseSyncSQLByRange	NarrowSearchValidateWithMask	Left�Top�   TwwTableGeneralTotalTableDatabaseName	PASsystem	IndexNameBYSWISCODE_RS_HC_PRINTORDER	TableNameBCollBLGnTot	TableTypettDBaseSyncSQLByRange	NarrowSearchValidateWithMask	Left,Top6  TTableSchoolTotalTableDatabaseName	PASsystem	IndexNameBYSCHOOL_SWIS_RS_HC	TableNameBCollBLScTot	TableTypettDBaseLeftFTop`  TTableEXTotalTableDatabaseName	PASsystem	IndexNameBYSWIS_RS_HC_EXCODE	TableNameBCollBLExTot	TableTypettDBaseLeftFTop�   TTableSDTotalTableDatabaseName	PASsystem	IndexNameBYSCHOOL_SWIS_RS_HC_SD_EXT_CM	TableNamebcollblsdtot	TableTypettDBaseLeftGTop�   TTableSpecialFeeTotalTableDatabaseName	PASsystem	IndexNameBYSWISCODE_RS_PRINTORDER	TableNamebcollblsftot	TableTypettDBaseLeftETop�   TTableAssessmentYearCtlTableDatabaseName	PASsystem	TableNameTAssmtYrCtlFile	TableTypettDBaseLeft� Top  TwwDataSourceBankCodeAuditDataSourceDataSetBankCodeAuditTableLeftrTop)  TwwTableBankCodeAuditTableDatabaseName	PASsystem	IndexNameBYDATE_TIME	TableTypettDBaseControlType.Strings$ImportSuccessful;CheckBox;True;False SyncSQLByRangeNarrowSearchValidateWithMask	LeftDTopP   