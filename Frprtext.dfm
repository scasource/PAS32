�
 TFREEPORTTAXEXTRACTFORM 0p  TPF0TFreeportTaxExtractFormFreeportTaxExtractFormLeftlTop� Width�Height�BorderIcons CaptionFreeport Tax ExtractColor	clBtnFaceFont.CharsetDEFAULT_CHARSET
Font.ColorclBlackFont.Height�	Font.NameArial
Font.Style 	FormStyle
fsMDIChild
KeyPreview	OldCreateOrder	Position	poDefaultVisible	
OnActivateFormActivateOnClose	FormClosePixelsPerInch`
TextHeight TPanelPanel1Left Top WidthpHeight)AlignalTopTabOrder  TLabel
TitleLabelLeft� Top
Width� HeightCaptionFreeport Tax ExtractFont.CharsetDEFAULT_CHARSET
Font.ColorclRedFont.Height�	Font.NameArial
Font.Style 
ParentFont   TPanelPanel2Left Top)WidthpHeightiAlignalClient
BevelInner	bvLoweredBorderWidthTabOrder 
TScrollBox
ScrollBox1LeftTopWidthdHeight]AlignalClientBorderStylebsNoneTabOrder  TLabelLabel1Left1TopWidthHeight9AutoSizeCaption�This task either creates the tax extract file needed to build Freeport tax files or a file with name and address updates for the tax system.  After clicking Start, you will be asked where to put the file and what to name it.Font.CharsetDEFAULT_CHARSET
Font.ColorclNavyFont.Height�	Font.NameArial
Font.StylefsBold 
ParentFontWordWrap	  TBitBtnCloseButtonLeftTop8WidthYHeight!TabOrder KindbkClose  TBitBtnStartButtonLeft�Top8WidthYHeight!Caption&StartTabOrderOnClickStartButtonClick
Glyph.Data
�  �  BM�      v   (   $            h                       �  �   �� �   � � ��  ��� ���   �  �   �� �   � � ��  ��� 333333333333333333  333333333333�33333  334C3333333733333  33B$3333333s7�3333  34""C333337333333  3B""$33333s337�333  4"*""C3337�7�3333  2"��"C3337�s3333  :*3:"$3337�37�7�33  3�33�"C333s33333  3333:"$3333337�7�3  33333�"C33333333  33333:"$3333337�7�  333333�"C3333333  333333:"C3333337�  3333333�#3333333s  3333333:3333333373  333333333333333333  	NumGlyphs  TRadioGroupExtractTypeRadioGroupLeftTop=Width� HeightUCaption Extract Type: Font.CharsetDEFAULT_CHARSET
Font.ColorclBlueFont.Height�	Font.NameArial
Font.StylefsBold 	ItemIndex Items.Strings Tax Extract Monthly Update Assessment Update 
ParentFontTabOrderOnClickExtractTypeRadioGroupClick  	TGroupBoxOptionsGroupBoxLeftTop� Width\Height� Caption
 Options: Font.CharsetDEFAULT_CHARSET
Font.ColorclNavyFont.Height�	Font.NameArial
Font.StylefsBold 
ParentFontTabOrderVisible 	TCheckBoxExtractMarkedParcelsCheckBoxLeftTopvWidth� Height	AlignmenttaLeftJustifyCaption!Include Parcels Already ExtractedFont.CharsetDEFAULT_CHARSET
Font.ColorclNavyFont.Height�	Font.NameArial
Font.StylefsBold 
ParentFontTabOrder   	TGroupBoxDateGroupBoxLeftTopWidth3HeightPCaption Date Range: Font.CharsetDEFAULT_CHARSET
Font.ColorclNavyFont.Height�	Font.NameArial
Font.StylefsBold 
ParentFontTabOrder TLabelLabel7LeftTopWidth"HeightCaptionStart:Font.CharsetDEFAULT_CHARSET
Font.ColorclBlackFont.Height�	Font.NameArial
Font.StylefsBold 
ParentFont  TLabelLabel8LeftTop5WidthHeightCaptionEnd:Font.CharsetDEFAULT_CHARSET
Font.ColorclBlackFont.Height�	Font.NameArial
Font.StylefsBold 
ParentFont  	TCheckBoxAllDatesCheckBoxLeft� TopWidthaHeightCaption
 All DatesFont.CharsetDEFAULT_CHARSET
Font.ColorclBlackFont.Height�	Font.NameArial
Font.StylefsBold 
ParentFontTabOrder  	TCheckBoxToEndofDatesCheckBoxLeft� Top5Width|HeightCaption To End of DatesFont.CharsetDEFAULT_CHARSET
Font.ColorclBlackFont.Height�	Font.NameArial
Font.StylefsBold 
ParentFontTabOrder  	TMaskEditEndDateEditLeft8Top2WidthbHeightEditMask!99/99/0000;1;_	MaxLength
TabOrderText
  /  /      	TMaskEditStartDateEditLeft8TopWidthbHeightEditMask!99/99/0000;1;_	MaxLength
TabOrder Text
  /  /          TSaveDialog
SaveDialog
DefaultExttxtFilterText File|*.txtOptionsofOverwritePromptofExtensionDifferentofPathMustExistofNoReadOnlyReturn Left� Topq  TTableTYParcelTableDatabaseName	PASsystem	IndexNameBYTAXROLLYR_SWISSBLKEY	TableName
TParcelRec	TableTypettDBaseLeftTopv  TTableNYParcelTableDatabaseName	PASsystem	IndexNameBYTAXROLLYR_SWISSBLKEY	TableName
TParcelRec	TableTypettDBaseLeftZTopw  TTableAssessmentTableDatabaseName	PASsystem	IndexNameBYTAXROLLYR_SWISSBLKEY	TableNameTPAssessRec	TableTypettDBaseLeft�Topv  TTableEXCodeTableDatabaseName	PASsystem	IndexNameBYEXCODE	TableName
TExCodeTbl	TableTypettDBaseLeftMTop�   TTableParcelExemptionTableDatabaseName	PASsystem	IndexNameBYTAXROLLYR_SWISSBLKEY	TableNameTPExemptionRec	TableTypettDBaseLeft�Top�   TTabletbSmallClaimsDatabaseName	PASsystem	IndexNameBYTAXROLLYR_SWISSBLKEY	TableNameGSmallClaimsTable	TableTypettDBaseLeft�Tops   