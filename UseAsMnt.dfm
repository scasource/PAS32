�
 TUSEDASMAINTFORM 0�  TPF0TUsedAsMaintFormUsedAsMaintFormLeft� Top]WidthxHeight�HorzScrollBar.VisibleBorderIcons CaptionUsed As Codes MaintenanceColor	clBtnFaceFont.CharsetDEFAULT_CHARSET
Font.ColorclBlackFont.Height�	Font.NameArial
Font.Style 	FormStyle
fsMDIChild
KeyPreview	OldCreateOrder	PositionpoScreenCenterShowHint	Visible	
OnActivateFormActivateOnClose	FormCloseOnCloseQueryFormCloseQuery
OnKeyPressFormKeyPressPixelsPerInch`
TextHeight 
TScrollBox
ScrollBox1Left Top)WidthpHeightRHorzScrollBar.VisibleVertScrollBar.VisibleAlignalClientBorderStylebsNoneTabOrder  TLabelMainCodeLabelLeft� TopLWidth"HeightCaptionCode:FocusControlMainCodeEdit  TLabelDescriptionLabelLeft� Top� WidthEHeightCaptionDescription:FocusControlDescriptionEdit  TLabelInsertLabel1LeftNTopIWidthpHeightCaption<= Please enter aFont.CharsetDEFAULT_CHARSET
Font.ColorclPurpleFont.Height�	Font.NameArial
Font.StylefsBold 
ParentFontVisible  TLabelIncrementalSearchLabelLeftTopWidthTHeightCaptionSelect a code:  TLabelInsertLabel2LeftbTop]WidthBHeightCaption	new code.Font.CharsetDEFAULT_CHARSET
Font.ColorclPurpleFont.Height�	Font.NameArial
Font.StylefsBold 
ParentFontVisible  TLabelLabel1Left� Top� Width=HeightCaption
Unit Code:  TDBNavigatorDBNavigatorLeft� TopWidth� Height
DataSourceMainDataSourceVisibleButtonsnbFirstnbPriornbNextnbLast TabOrder   TwwIncrementalSearchIncrementalSearchLeftTop+WidthrHeightHint*Type in the code to view, edit, or delete.
DataSourceMainDataSourceCharCaseecUpperCaseTabOrderOnEnterIncrementalSearchEnterOnExitIncrementalSearchExit  TBitBtnInsertButtonLeftTop(WidthYHeight!Hint$Press this button to add a new code.Caption&AddTabOrderOnClickInsertButtonClick	NumGlyphsSpacing  TBitBtnDeleteButtonLeftTopUWidthYHeight!Hint-Press this button to delete the present code.Caption&DeleteTabOrderOnClickDeleteButtonClick
Glyph.Data
z  v  BMv      v   (                                    �  �   �� �   � � ��   ���   �  �   �� �   � � ��  ��� UUUUUUUU_���_U��wwwuuY�WwwwuuWw�UUUUUP0UUUUU�W��UUUP[�UUUUWu�w�UUU�  UUUUuWww�UUP���UUUWUuWW�UU���UUUUUuW�UU��� UUUUWUw�UP����UUWUUW��U�� �UUuu�Uw��P�࿰��UW�W_WW�� ���Uw�u����  ��  �Uww�Www��  UP�UwwuUWWUP  UUUUWwwUUUUU UUUUUwuUUUuU	NumGlyphs  TBitBtnPrintButtonLeftTop� WidthYHeight!Hint%Press this button to print the codes.Caption&PrintTabOrderOnClickPrintButtonClick
Glyph.Data
z  v  BMv      v   (                                    �  �   �� �   � � ��   ���   �  �   �� �   � � ��  ��� 0      ?��������������wwwwwww�������wwwwwww        ���������������wwwwwww�������wwwwwww�������wwwwww        wwwwwww30����337���?330� 337�wss330����337��?�330�  337�swws330���3337��73330��3337�ss3330�� 33337��w33330  33337wws333	NumGlyphsSpacing  TBitBtn
SaveButtonLeftTop� WidthYHeight!Hint.Press this button to save any current changes.Caption&SaveTabOrderOnClickSaveButtonClick  TBitBtn
ExitButtonLeftTopWidthYHeight!Hint*Press this button to exit the maintenance.TabOrder
OnClickExitButtonClickKindbkClose  TDBEditMainCodeEditLeft� TopHWidthhHeightCharCaseecUpperCase	DataFieldMainCode
DataSourceMainDataSourceFont.CharsetDEFAULT_CHARSET
Font.ColorclBlueFont.Height�	Font.NameArial
Font.StylefsBold 
ParentFontTabOrderOnExitMainCodeEditExit  TDBEditDescriptionEditLeft� Top|WidthHeight	DataFieldDescription
DataSourceMainDataSourceTabOrder  TBitBtnRefreshButtonLeftTop� WidthYHeight!Hint1Press this button to discard all present changes.Caption&UndoTabOrder	OnClickRefreshButtonClick  TPanel	StatusBarLeft Top=WidthpHeightAlignalBottom	AlignmenttaLeftJustify
BevelOuter	bvLoweredBorderStylebsSingleFont.CharsetDEFAULT_CHARSET
Font.ColorclBlueFont.Height�	Font.NameCourier New
Font.Style 
ParentFontTabOrder  TDBGrid
LookupGridLeftTop[WidthrHeight� Hint)Choose the code to view, edit, or delete.TabStop
DataSourceMainDataSourceOptionsdgIndicator TabOrderTitleFont.CharsetDEFAULT_CHARSETTitleFont.ColorclBlackTitleFont.Height�TitleFont.NameArialTitleFont.Style OnEnterLookupGridEnterOnExitLookupGridExit  TwwDBLookupComboUnitCodeLookupComboLeft� Top� Width� HeightDropDownAlignmenttaLeftJustifySelected.StringsDescription	20	DescriptionMainCode	2	MainCode 	DataFieldUnitRestrictionDesc
DataSourceMainDataSourceLookupTableUnitCodeLookupTableLookupFieldDescriptionOptions
loColLines
loRowLines StylecsDropDownListTabOrderAutoDropDown
ShowButton	SeqSearchOptions
ssoEnabledssoCaseSensitive AllowClearKeyOnEnterUnitCodeLookupComboEnterOnExitUnitCodeLookupComboExit   TPanelPanel1Left Top WidthpHeight)AlignalTop
BevelInner	bvLoweredTabOrder TLabel
TitleLabelLeft� TopWidth� HeightCaptionUsed As Codes MaintenanceFont.CharsetDEFAULT_CHARSET
Font.ColorclRedFont.Height�	Font.NameArial
Font.StylefsBold 
ParentFont   TwwDataSourceMainDataSourceDataSet	MainTableLeft� Top6  TwwTable	MainTable
BeforePostMainTableBeforePost	AfterPostMainTableAfterPostDatabaseName	PASsystem	IndexName
BYMAINCODE	TableNameZInvUsedAsTbl	TableTypettDBaseSyncSQLByRange	NarrowSearchValidateWithMask	LefttTop4 TStringFieldMainTableTaxRollYr	FieldName	TaxRollYrSize  TStringFieldMainTableMainCode	FieldNameMainCodeSize  TStringFieldMainTableDescription	FieldNameDescriptionSize  TStringFieldMainTableUnitRestrictionCode	FieldNameUnitRestrictionCodeVisibleSize  TStringFieldMainTableUnitRestrictionDesc	FieldNameUnitRestrictionDescVisible   TPrintRangeDlgPrintRangeDlgAskPrintPreview	UppercaseChars	
CodeLengthCodeNameSampleDisplayHints	Left�Top�   TwwTableLookupTableDatabaseName	PASsystem	IndexName
BYMAINCODEReadOnly		TableNameZInvUsedAsTbl	TableTypettDBaseSyncSQLByRange	NarrowSearchValidateWithMask	Left�Top�   TReportPrinterReportPrinterStatusFormatPrinting page %pUnitsFactor       ��?TitleReportPrinter ReportOrientation
poPortraitScaleX       �@ScaleY       �@OnPrintPageReportPrinterPrintPageOnBeforePrintReportPrinterBeforePrintOnAfterPrintReportPrinterAfterPrintOnPrintHeaderReportPrinterPrintHeaderLeft�Top  TReportFilerReportFilerStatusFormatPrinting page %pUnitsFactor       ��?TitleReportPrinter ReportOrientation
poPortraitScaleX       �@ScaleY       �@OnPrintPageReportPrinterPrintPageOnBeforePrintReportPrinterBeforePrintOnAfterPrintReportPrinterAfterPrintOnPrintHeaderReportPrinterPrintHeaderLeft�Top	  TwwTableUnitCodeLookupTableDatabaseName	PASsystem	IndexNameBYDESCRIPTION	TableNameZInvUnitTbl	TableTypettDBaseSyncSQLByRange	NarrowSearchValidateWithMask	Left�Top�    