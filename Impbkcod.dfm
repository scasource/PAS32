�
 TIMPORTBANKCODEFORM 0�  TPF0TImportBankCodeFormImportBankCodeFormLeft� TopWWidth�Height�BorderIcons CaptionImport Bank CodesColor	clBtnFaceFont.CharsetDEFAULT_CHARSET
Font.ColorclBlackFont.Height�	Font.NameArial
Font.Style 	FormStyle
fsMDIChild
KeyPreview	OldCreateOrder	Position	poDefaultVisible	
OnActivateFormActivateOnClose	FormClose
OnKeyPressFormKeyPressPixelsPerInch`
TextHeight TPanelPanel1Left Top WidthpHeight)AlignalTopTabOrder  TLabel
TitleLabelLeft� Top
Width� HeightCaptionImport Bank CodesFont.CharsetDEFAULT_CHARSET
Font.ColorclRedFont.Height�	Font.NameArial
Font.Style 
ParentFont   TPanelPanel2Left Top)WidthpHeightiAlignalClient
BevelInner	bvLoweredBorderWidthTabOrder 
TScrollBox
ScrollBox1LeftTopWidthdHeight]HorzScrollBar.RangeNVertScrollBar.RangeJAlignalClient
AutoScrollBorderStylebsNoneTabOrder  TPageControlPageControl1Left Top WidthdHeight]
ActivePage	TabSheet1AlignalClientTabOrder  	TTabSheet	TabSheet1CaptionImport TLabelLabel1LeftITopWidth}HeightCaptionTSO Code To Clear:Font.CharsetDEFAULT_CHARSET
Font.ColorclBlueFont.Height�	Font.NameArial
Font.StylefsBold 
ParentFont  TLabelLabel2LeftyTop/Width;HeightCaption.Enter Bank Codes Here You Wish NOT To Overlay:Font.CharsetDEFAULT_CHARSET
Font.ColorclBlueFont.Height�	Font.NameArial
Font.StylefsBold 
ParentFont  TLabelLabel4Left6TopWidthLHeightCaption
TSO Name: Font.CharsetDEFAULT_CHARSET
Font.ColorclBlueFont.Height�	Font.NameArial
Font.StylefsBold 
ParentFont  TBitBtnCloseButtonLeftTopWidthYHeight!TabOrder OnClickCloseButtonClickKindbkClose  TEditTSOCodeEditLeft� TopWidthXHeightHint$Enter a 6-character TSO code, eg TRACharCaseecUpperCase	MaxLengthTabOrder  TStringGridFrozenBankCodesStringGridLeft� TopIWidthIHeight� 	FixedCols 	FixedRows OptionsgoFixedVertLinegoFixedHorzLine
goVertLine
goHorzLinegoRangeSelect	goEditinggoTabsgoAlwaysShowEditor 
ScrollBarsssNoneTabOrder  TBitBtnImportButtonLeft�TopWidthYHeight!CaptionImportDefault	TabOrderOnClickImportButtonClick
Glyph.Data
z  v  BMv      v   (                                    �  �   �� �   � � ��   ���   �  �   �� �   � � ��  ��� 33333333333?����333     333wwwww333����3333337333����333?���333 � �33�w7w7303����37�??��39 ��37sw7739�����?�w?���	�� �  wwww7ww	������wwww�7�s	�����3wwwws7�3	�����3wwww��s3	��   33wwwwww3339�3333337w33333393333337s333333033333337333333	NumGlyphs  	TCheckBoxPrintBankCodesReceivedCheckBoxLeftTop� Width� HeightHint�If you check this option, a list of every parcel that received a bank code will be printed along with the code it received.  Warning - this may be a long report.	AlignmenttaLeftJustifyCaptionPrint Bank Codes ReceivedFont.CharsetDEFAULT_CHARSET
Font.ColorclBlackFont.Height�	Font.NameArial
Font.StylefsBold 
ParentFontTabOrder  	TCheckBoxChangeThisYearBankCodesCheckBoxLeftTop� Width� HeightHintmClick this box if you want the This Year bank codes to be the same as the Next Year bank codes for this bank.	AlignmenttaLeftJustifyCaptionChange This Year Bank CodesFont.CharsetDEFAULT_CHARSET
Font.ColorclBlackFont.Height�	Font.NameArial
Font.StylefsBold 
ParentFontTabOrder  	TComboBoxTSONameComboBoxLeft�TopWidth� Height
ItemHeightTabOrderItems.StringsBank of AmericaFidelity National (FNIS)
Core LogicLerettaWells FargoZC SterlingOther   	TCheckBoxcbxTabDelimitedLeftTopWidth� Height	AlignmenttaLeftJustifyCaptionTab DelimitedFont.CharsetDEFAULT_CHARSET
Font.ColorclBlackFont.Height�	Font.NameArial
Font.StylefsBold 
ParentFontTabOrder   	TTabSheet	TabSheet2CaptionHistory
ImageIndex TLabelLabel3Left#TopWidth� HeightCaptionPreviously imported bank codes:Font.CharsetDEFAULT_CHARSET
Font.ColorclBlueFont.Height�	Font.NameArial
Font.StylefsBold 
ParentFont  	TwwDBGridBankCodeAuditGridLeft#Top%WidthHeightSelected.StringsTSOName	20	TSO Name	FDateImported	10	Date~Imported	FTimeImported	10	Time~Imported	FBankReplaced	7	Bank~Replaced	F#NumImported	10	Num Codes~Imported	FImportSuccessful	5	Successful	F IniAttributes.Delimiter;;
TitleColor	clBtnFace	FixedCols ShowHorzScrollBar	
DataSourceBankCodeAuditDataSourceFont.CharsetDEFAULT_CHARSET
Font.ColorclBlackFont.Height�	Font.NameArial
Font.StylefsBold OptionsdgTitlesdgIndicatordgColumnResize
dgColLines
dgRowLinesdgTabsdgRowSelectdgConfirmDeletedgCancelOnExit
dgWordWrap 
ParentFontReadOnly	TabOrder TitleAlignmenttaCenterTitleFont.CharsetDEFAULT_CHARSETTitleFont.ColorclBlueTitleFont.Height�TitleFont.NameArialTitleFont.StylefsBold 
TitleLinesTitleButtonsIndicatorColoricBlack      TOpenDialogTSODiskOpenDialogFileName*.*FilterAll Files|*.*
InitialDirA:\TitleSelect TSO File To ImportLeftTop  TReportPrinterReportPrinterStatusFormatPrinting page %pUnitsFactor       ��?TitleReportPrinter ReportOrientation
poPortraitScaleX       �@ScaleY       �@OnPrintReportPrinterPrintOnPrintHeaderReportFilerPrintHeaderLeft�Top  TReportFilerReportFilerStatusFormatPrinting page %pUnitsFactor       ��?TitleReportPrinter ReportOrientation
poPortraitScaleX       �@ScaleY       �@OnPrintReportPrinterPrintOnPrintHeaderReportFilerPrintHeaderLeft�Top  TPrintDialogPrintDialogOptionspoPrintToFile PrintToFile	Left�Top  TTableParcelTableDatabaseName	PASsystem	IndexNameBYTAXROLLYR_SWISSBLKEY	TableName
TParcelRec	TableTypettDBaseLeftTop  TTableTYParcelTableDatabaseName	PASsystem	IndexNameBYTAXROLLYR_SWISSBLKEY	TableTypettDBaseLeftVTop
  TwwTableBankCodeAuditTableActive	DatabaseNamePropertyAssessmentSystem	IndexNameBYDATE_TIME	TableNameAuditBankCodeDisks	TableTypettDBaseControlType.Strings$ImportSuccessful;CheckBox;True;False SyncSQLByRangeNarrowSearchValidateWithMask	LeftTop-  TwwDataSourceBankCodeAuditDataSourceDataSetBankCodeAuditTableLeftrTop)   