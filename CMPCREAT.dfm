�
 TCREATECOMPARABLESFILEFORM 0�  TPF0TCreateComparablesFileFormCreateComparablesFileFormLeftOTop� Width�Height�BorderIcons CaptionCreate Comparables FileColor	clBtnFaceFont.CharsetDEFAULT_CHARSET
Font.ColorclBlackFont.Height�	Font.NameArial
Font.Style 	FormStyle
fsMDIChild
KeyPreview	OldCreateOrder	Position	poDefaultVisible	
OnActivateFormActivateOnClose	FormClosePixelsPerInch`
TextHeight TPanelPanel1Left Top WidthpHeight)AlignalTopTabOrder  TLabel
TitleLabelLeft� Top
Width� HeightCaptionCreate Comparables FileFont.CharsetDEFAULT_CHARSET
Font.ColorclRedFont.Height�	Font.NameArial
Font.Style 
ParentFont   TPanelPanel2Left Top)WidthpHeightlAlignalClient
BevelInner	bvLoweredBorderWidthTabOrder 
TScrollBox
ScrollBox1LeftTopWidthdHeight`HorzScrollBar.RangeXVertScrollBar.RangeYAlignalClient
AutoScrollBorderStylebsNoneTabOrder  TLabelInstructionLabelLeft!Top� Width�Height#AutoSizeCaptionoIMPORTANT:  This program recreates the data files necessary for  comparables reporting by assessment or sales. Font.CharsetDEFAULT_CHARSET
Font.ColorclMaroonFont.Height�	Font.NameArial
Font.StylefsBold 
ParentFontWordWrap	  TLabelTableDeleteStatusMsgLabelLeftTop� Width�Height Caption�Please wait while the old 'comp' data files are emptied. This may take several minutes if you have a large number of parcels......Font.CharsetDEFAULT_CHARSET
Font.ColorclPurpleFont.Height�	Font.NameArial
Font.StylefsBold 
ParentFontVisibleWordWrap	  TLabelLabel1LeftTopcWidthtHeightHAutoSizeCaption�Sales after the following date will use the current inventory if there was no time of sale inventory available: (Leave blank if the sales comparables should only contain sales with actual time of sale inventory).Font.CharsetDEFAULT_CHARSET
Font.ColorclBlueFont.Height�	Font.NameArial
Font.StylefsBold 
ParentFontWordWrap	  TBitBtnCloseButtonLeftTop8WidthYHeight!TabOrder OnClickCloseButtonClickKindbkClose  TBitBtnStartButtonLeft�Top8WidthYHeight!CaptionStartTabOrderOnClickStartButtonClickKindbkOK  TRadioGroupAssessmentYearRadioGroupLeft� Top
Width� HeightOCaption Choose Assessment Year: Font.CharsetDEFAULT_CHARSET
Font.ColorclBlueFont.Height�	Font.NameArial
Font.StylefsBold 	ItemIndexItems.Strings	This Year	Next Year 
ParentFontTabOrder  	TMaskEditSalesDateEditLeft�Top{WidthPHeightEditMask!99/99/0000;1;_Font.CharsetDEFAULT_CHARSET
Font.ColorclBlueFont.Height�	Font.NameArial
Font.StylefsBold 	MaxLength

ParentFontTabOrderText
  /  /      	TCheckBox(cbxFillInBlankInformationFromCurrentDataLeft� Top� Width2Height	AlignmenttaLeftJustifyCaption,Fill in blank information from current data.Checked	Font.CharsetDEFAULT_CHARSET
Font.ColorclBlueFont.Height�	Font.NameArial
Font.StylefsBold 
ParentFontState	cbCheckedTabOrder    TReportFilerReportFilerStatusFormatPrinting page %pUnitsFactor       ��?TitleReportPrinter ReportOrientation
poPortraitScaleX       �@ScaleY       �@Left�Top  TTableParcelTableDatabaseName	PASsystem	IndexNameBYTAXROLLYR_SWISSBLKEY	TableName
TParcelRec	TableTypettDBaseLeftTop  TTableAssessmentTableDatabaseName	PASsystem	IndexNameBYTAXROLLYR_SWISSBLKEY	TableNameTPAssessRec	TableTypettDBaseLeftDTop��    TTableResidentialSiteTableDatabaseName	PASsystem	IndexNameBYTAXROLLYR_SWISSBLKEY_SITE	TableNameTPResidentialSite	TableTypettDBaseLeft� Top  TTableResidentialBldgTableDatabaseName	PASsystem	IndexNameBYTAXROLLYR_SWISSBLKEY_SITE	TableNameTPResidentialBldg	TableTypettDBaseLeft�   TTable
SalesTableDatabaseName	PASsystem	IndexNameBYSWISSBLKEY_SALENUMBER	TableName	PSalesRec	TableTypettDBaseLeft�Top  TwwTableCompAssmtMinMaxTableDatabaseName	PASsystem	Exclusive		IndexNameBYSWIS_NBHD_PC_STYLE	TableNameCompAssmtMinMaxFile	TableTypettDBaseSyncSQLByRangeNarrowSearchValidateWithMask	LefteTop:  TwwTableCompSalesTableDatabaseName	PASsystem	Exclusive		IndexNameBYSWISCODE_SBLKEY_SITE	TableNameCompSalesDataFile	TableTypettDBaseSyncSQLByRangeNarrowSearchValidateWithMask	Left/Top  TTableSalesResidentialSiteTableDatabaseName	PASsystem	IndexNameBYSWISSBLKEY_SALESNUMBER_SITE	TableTypettDBaseLeft� Top��    TwwTableCompSalesMinMaxTableDatabaseName	PASsystem	Exclusive		IndexNameBYSWIS_NBHD_PC_STYLE	TableNameCompSalesMinMaxFile	TableTypettDBaseSyncSQLByRangeNarrowSearchValidateWithMask	Left� Top  TTableSalesResidentialBldgTableDatabaseName	PASsystem	IndexNameBYSWISSBLKEY_SALESNUMBER_SITE	TableTypettDBaseLeft� TopI  TTableResidentialImprovementTableDatabaseName	PASsystem	IndexNameBYTAXROLLYR_SBL_SITE_IMPNO	TableNameTPResidentialImprove	TableTypettDBaseLeft;Top  TTable SalesResidentialImprovementTableDatabaseName	PASsystem	IndexNameBYSBL_SALENO_SITE_IMPNO	TableTypettDBaseLeftwTop	  TwwTableCompAssmtTableDatabaseName	PASsystem	Exclusive		TableNameCompAssmtDataFile	TableTypettDBaseSyncSQLByRangeNarrowSearchValidateWithMask	LeftPTop��     