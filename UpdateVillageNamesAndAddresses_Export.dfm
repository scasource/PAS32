�
 TUPDATEVILLAGESNAMEANDADDRESS_EXPORTFORM 0�  TPF0(TUpdateVillagesNameAndAddress_ExportForm'UpdateVillagesNameAndAddress_ExportFormLeft� TopYWidth�Height�BorderIcons Caption-Export Names and Addresses for Village UpdateColor	clBtnFaceFont.CharsetDEFAULT_CHARSET
Font.ColorclBlackFont.Height�	Font.NameArial
Font.Style 	FormStyle
fsMDIChild
KeyPreview	OldCreateOrder	Position	poDefaultVisible	
OnActivateFormActivateOnClose	FormClosePixelsPerInch`
TextHeight TPanelPanel1Left Top WidthxHeight)AlignalTopTabOrder  TLabel
TitleLabelLeftoTop
Width�HeightCaption-Export Names and Addresses for Village UpdateFont.CharsetDEFAULT_CHARSET
Font.ColorclRedFont.Height�	Font.NameArial
Font.Style 
ParentFont   TPanelPanel2Left Top)WidthxHeighttAlignalClient
BevelInner	bvLoweredBorderWidthTabOrder 
TScrollBox
ScrollBox1LeftTopWidthlHeighthAlignalClientBorderStylebsNoneTabOrder  TLabelLabel1Left1TopWidthHeightCAutoSizeCaption�This task creates and extract file of all the names and addresses for the selected village(s) and sends it to a website for the village to download.  In addition, an email message will be sent to the village to notify them that an update is available.Font.CharsetDEFAULT_CHARSET
Font.ColorclNavyFont.Height�	Font.NameArial
Font.StylefsBold 
ParentFontWordWrap	  TLabelLabel6LeftRTopPWidthyHeightCaptionSelect Swis Codes:Font.CharsetDEFAULT_CHARSET
Font.ColorclBlackFont.Height�	Font.NameArial
Font.StylefsBold 
ParentFont  TLabelLabel2LeftTopgWidthwHeight6AutoSizeCaption-EMail address of person at village to notify:Font.CharsetDEFAULT_CHARSET
Font.ColorclBlackFont.Height�	Font.NameArial
Font.StylefsBold 
ParentFontWordWrap	  TBitBtnCloseButtonLeftTop)WidthYHeight!TabOrder KindbkClose  TBitBtnStartButtonLeft�Top)WidthYHeight!Caption&StartTabOrderOnClickStartButtonClick
Glyph.Data
�  �  BM�      v   (   $            h                       �  �   �� �   � � ��  ��� ���   �  �   �� �   � � ��  ��� 333333333333333333  333333333333�33333  334C3333333733333  33B$3333333s7�3333  34""C333337333333  3B""$33333s337�333  4"*""C3337�7�3333  2"��"C3337�s3333  :*3:"$3337�37�7�33  3�33�"C333s33333  3333:"$3333337�7�3  33333�"C33333333  33333:"$3333337�7�  333333�"C3333333  333333:"C3333337�  3333333�#3333333s  3333333:3333333373  333333333333333333  	NumGlyphs  TListBoxSwisCodeListBoxLeft%TopgWidth� Height� ColumnsFont.CharsetDEFAULT_CHARSET
Font.ColorclBlackFont.Height�	Font.NameArial
Font.Style 
ItemHeightMultiSelect	
ParentFontTabOrder  TwwDBLookupCombo NotificationEMailAddressComboBoxLeftTop� Width,HeightDropDownAlignmenttaLeftJustifySelected.StringsPerson	20	Person	FEmailAddress	25	EmailAddress	F LookupTableEmailAddressesTableLookupFieldPersonOptions
loColLines
loRowLinesloTitles TabOrderAutoDropDown
ShowButton	AllowClearKey	OnCloseUp'NotificationEMailAddressComboBoxCloseUp  TBitBtnEditEmailAddressTableButtonLeft2Top� WidthHeightTabOrderOnClick EditEmailAddressTableButtonClick
Glyph.Data
z  v  BMv      v   (                                    �  �   �� �   � � ��   ���   �  �   �� �   � � ��  ��� U0UP   UW�WwwwU0U���UW�uUUWU0P���UW����uU0    UUWwwww�U     UUwU_w�U x   pU_wU_wW� x�  wpUwUUwUW��� wwpUUUwUUW��wwpU�uUUW�	��wwpUw�UUUW����wwpUwuUu�UWU	���wwUwUUW_�uU���� UUUUUwwUU���UUUu�U_wUUUP��UUUUW_�wUUUUU UUUUUUwwUUUUU	NumGlyphs  
TStatusBar	StatusBarLeft TopUWidthlHeightPanelsTextDisconnectedWidthd Text xxxxx of xxxxx bytes transferredWidth2  SimplePanel    TTableParcelTableDatabaseName	PASsystem	IndexNameBYTAXROLLYR_SWISSBLKEY	TableName
TParcelRec	TableTypettDBaseLeftzTop�   TwwTableSwisCodeTableDatabaseName	PASsystem	TableNameTSwisTbl	TableTypettDBaseSyncSQLByRange	NarrowSearchValidateWithMask	LeftjTop  TNMFTPNMFTPHost%propertyassessmentsystem.netfirms.comPortReportLevel UserIDpropertyassessmentsystemPasswordmorlin26Vendork		ParseList	ProxyPort PassiveFirewallTypeFTUserFWAuthenticateLeft7Top  TwwTableEmailAddressesTableDatabaseName	PASsystem	IndexNameBYPERSON	TableNameemailaddresstable	TableTypettDBaseSyncSQLByRangeNarrowSearchValidateWithMask	Left�Top�    