ÿ
 TIMPORTIVPSTATUSFILEFORM 0ì  TPF0TImportIVPStatusFileFormImportIVPStatusFileFormLeftGTop WidthHeight¸BorderIcons Caption2Import IVP (Auto-Renewal) Status for Enhanced STARColor	clBtnFaceFont.CharsetDEFAULT_CHARSET
Font.ColorclBlackFont.Heightó	Font.NameArial
Font.Style 	FormStyle
fsMDIChild
KeyPreview	OldCreateOrder	Position	poDefaultVisible	
OnActivateFormActivateOnClose	FormClosePixelsPerInch`
TextHeight TPanelPanel1Left Top WidthpHeight)AlignalTopTabOrder  TLabel
TitleLabelLeftñ Top
Width HeightCaptionImport IVP StatusFont.CharsetDEFAULT_CHARSET
Font.ColorclRedFont.Heightí	Font.NameArial
Font.Style 
ParentFont   TPanelPanel2Left Top)WidthpHeightkAlignalClient
BevelInner	bvLoweredBorderWidthTabOrder 
TScrollBox
ScrollBox1LeftTopWidthdHeight_AlignalClientBorderStylebsNoneTabOrder  TLabelLabel3Left(Top
WidthHeight<AutoSizeCaptionãThis program will import the approved status for seniors enrolled in the IVP program.  You may print labels for seniors whose income status is denied or unknown, but the exemptions for that parcel will not be removed or denied.Font.CharsetDEFAULT_CHARSET
Font.ColorclBlueFont.Heightó	Font.NameArial
Font.StylefsBold 
ParentFontWordWrap	  TBitBtnCloseButtonLeftTop8WidthYHeight!TabOrder KindbkClose  TBitBtnStartButtonLeftTop9WidthYHeight!CaptionStartTabOrderOnClickStartButtonClick
Glyph.Data
Ò  Î  BMÎ      6   (   $                                                                                          ÿÿÿ                                    ÿÿÿ                                      ÿÿÿ                                        ÿÿÿ                                          ÿÿÿ                 ÿ                   ÿÿÿ  ÿÿÿ   ÿÿÿ              ÿ   ÿ                 ÿÿÿ  ÿÿÿ  ÿÿÿ        ÿ    ÿ     ÿ                ÿÿÿ   ÿÿÿ  ÿÿÿ        ÿ       ÿ                     ÿÿÿ  ÿÿÿ              ÿ                      ÿÿÿ  ÿÿÿ              ÿ                      ÿÿÿ  ÿÿÿ              ÿ                      ÿÿÿ  ÿÿÿ              ÿ                      ÿÿÿ  ÿÿÿ              ÿ                     ÿÿÿ ÿÿÿ               ÿ                    ÿÿÿ                 ÿ                                                        	NumGlyphs  	TGroupBoxMiscellaneousGroupBoxLeftó TopMWidthpHeightÌ Caption Miscellaneous Options: Font.CharsetDEFAULT_CHARSET
Font.ColorclGreenFont.Heightó	Font.NameArial
Font.StylefsBold 
ParentFontTabOrder TLabelLabel1LeftTopaWidth Height%AutoSizeCaptionPrint Labels for Unknown StatusWordWrap	  TLabelLabel2LeftTop Width Height!AutoSizeCaptionPrint Labels for Denied StatusWordWrap	  TLabelLabel4LeftTop¯ Width HeightAutoSizeCaption	Trial RunWordWrap	  TLabelLabel5LeftTopWidth Height%AutoSizeCaption Print Labels for Approved StatusWordWrap	  TLabelLabel6LeftTop:Width Height!AutoSizeCaption.Print Labels for Approved, Not Enrolled StatusFont.CharsetDEFAULT_CHARSET
Font.ColorclGreenFont.Heightô	Font.NameArial
Font.StylefsBold 
ParentFontWordWrap	  TLabelLabel7LeftÒ TopWidthxHeight%AutoSizeCaption"Update status even if not enrolledWordWrap	  TLabelLabel8LeftÒ Top:Width Height0AutoSizeCaption3Mark approved homeowners in file as enrolled in IVPWordWrap	  	TCheckBox#PrintLabelsForUnknownStatusCheckBoxLeft­ TopkWidthHeight	AlignmenttaLeftJustifyTabOrder   	TCheckBox"PrintLabelsForDeniedStatusCheckBoxLeft­ Top WidthHeight	AlignmenttaLeftJustifyTabOrder  	TCheckBoxTrialRunCheckBoxLeft­ Top± WidthHeight	AlignmenttaLeftJustifyTabOrder  	TCheckBox$PrintLabelsForApprovedStatusCheckBoxLeft­ TopWidthHeight	AlignmenttaLeftJustifyTabOrder  	TCheckBox0PrintLabelsForApproved_NotEnrolledStatusCheckBoxLeft­ TopBWidthHeight	AlignmenttaLeftJustifyTabOrder  	TCheckBox!UpdateStatusIfNotEnrolledCheckBoxLeftUTopWidthHeightHintIf an exemption is marked as approved from DTF, mark the exemption approved in PAS even if the homeowner is not marked as enrolled in the IVP program.	AlignmenttaLeftJustifyTabOrder  	TCheckBox'MarkApprovedHomeownersEnfrolledCheckBoxLeftUTopBWidthHeight	AlignmenttaLeftJustifyTabOrder  	TCheckBoxcbxExtractToExcelLeftÒ Top Width Height	AlignmenttaLeftJustifyCaptionExtract to ExcelTabOrder   TRadioGroupAssessmentYearRadioGroupLeft(TopMWidth¾ HeightgCaption Assessment Year: Font.CharsetDEFAULT_CHARSET
Font.ColorclPurpleFont.Heightó	Font.NameArial
Font.StylefsBold 	ItemIndexItems.Strings	This Year	Next Year 
ParentFontTabOrder    TTableParcelTableDatabaseName	PASsystem	IndexNameBYTAXROLLYR_SBLKEY	TableName
TParcelRec	TableTypettDBaseLeft0Top  TTableExemptionTableDatabaseName	PASsystem	IndexNameBYYEAR_SWISSBLKEY_EXCODE	TableNameTPExemptionRec	TableTypettDBaseLeft Top  TReportFilerReportFilerStatusFormatPrinting page %pUnitsFactor       ÿ?TitleReportPrinter ReportOrientation
poPortraitScaleX       È@ScaleY       È@OnPrintReportPrintOnPrintHeaderReportPrintHeaderLeftzTop*  TReportPrinterReportPrinterStatusFormatPrinting page %pUnitsFactor       ÿ?TitleReportPrinter ReportOrientation
poPortraitScaleX       È@ScaleY       È@OnPrintReportPrintOnPrintHeaderReportPrintHeaderLeftÍ Top:  TPrintDialogPrintDialogMaxPage }OptionspoPrintToFile
poPageNums LeftTop  TOpenDialog
OpenDialogOptionsofHideReadOnlyofPathMustExistofFileMustExistofEnableSizing Leftê Top  TReportPrinterReportLabelPrinterStatusFormatPrinting page %pUnitsFactor       ÿ?TitleLabels from Search ReportOrientation
poPortraitScaleX       È@ScaleY       È@OnPrintReportLabelPrintOnPrintHeaderReportLabelPrintHeaderLeftOTopg  TReportFilerReportLabelFilerStatusFormatPrinting page %pUnitsFactor       ÿ?TitleLabels from Search ReportOrientation
poPortraitScaleX       È@ScaleY       È@
StreamModesmFileOnPrintReportLabelPrintOnPrintHeaderReportLabelPrintHeaderLeftQTop    TwwTableSwisCodeTableDatabaseName	PASsystem	IndexName
BYSWISCODE	TableNameTSwisTbl	TableTypettDBaseSyncSQLByRange	NarrowSearchValidateWithMask	Left§ Top	  TTableAssessmentYearControlTableDatabaseName	PASSystem	TableNameTAssmtYrCtlFile	TableTypettDBaseLeftTopU  TTable
tbParcels2DatabaseName	PASsystem	IndexNameBYYEAR_LEGALADDRNO_LEGALADDR	TableName
TParcelRec	TableTypettDBaseLeftùTop   