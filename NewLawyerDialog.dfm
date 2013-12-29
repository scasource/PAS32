object NewLawyerForm: TNewLawyerForm
  Left = 202
  Top = 176
  Width = 386
  Height = 464
  ActiveControl = MainCodeEdit
  Caption = 'Add a representative code'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Arial'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnCloseQuery = FormCloseQuery
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 16
  object UndoButton: TBitBtn
    Left = 207
    Top = 390
    Width = 89
    Height = 33
    Hint = 'Press this button to discard all present changes.'
    Caption = '&Undo'
    TabOrder = 0
    OnClick = UndoButtonClick
    Glyph.Data = {
      76010000424D7601000000000000760000002800000020000000100000000100
      04000000000000010000120B0000120B00001000000000000000000000000000
      800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00555555555555
      55555FFFFFFF5F55FFF5777777757559995777777775755777F7555555555550
      305555555555FF57F7F555555550055BB0555555555775F777F55555550FB000
      005555555575577777F5555550FB0BF0F05555555755755757F555550FBFBF0F
      B05555557F55557557F555550BFBF0FB005555557F55575577F555500FBFBFB0
      B05555577F555557F7F5550E0BFBFB00B055557575F55577F7F550EEE0BFB0B0
      B05557FF575F5757F7F5000EEE0BFBF0B055777FF575FFF7F7F50000EEE00000
      B0557777FF577777F7F500000E055550805577777F7555575755500000555555
      05555777775555557F5555000555555505555577755555557555}
    NumGlyphs = 2
  end
  object GroupBox1: TGroupBox
    Left = 22
    Top = 11
    Width = 334
    Height = 370
    Caption = ' Enter new representative information: '
    TabOrder = 1
    object MainCodeLabel: TLabel
      Left = 17
      Top = 35
      Width = 34
      Height = 16
      Caption = 'Code:'
      FocusControl = MainCodeEdit
    end
    object Label11: TLabel
      Left = 17
      Top = 63
      Width = 45
      Height = 16
      Caption = 'Name 1'
      FocusControl = EditName
    end
    object Label12: TLabel
      Left = 17
      Top = 90
      Width = 45
      Height = 16
      Caption = 'Name 2'
      FocusControl = EditName2
    end
    object Label13: TLabel
      Left = 17
      Top = 117
      Width = 38
      Height = 16
      Caption = 'Addr 1'
      FocusControl = EditAddress
    end
    object Label14: TLabel
      Left = 17
      Top = 144
      Width = 38
      Height = 16
      Caption = 'Addr 2'
      FocusControl = EditAddress2
    end
    object Label15: TLabel
      Left = 17
      Top = 170
      Width = 35
      Height = 16
      Caption = 'Street'
      FocusControl = EditStreet
    end
    object SwisLabel: TLabel
      Left = 17
      Top = 197
      Width = 23
      Height = 16
      Caption = 'City'
      FocusControl = EditCity
    end
    object Label17: TLabel
      Left = 17
      Top = 224
      Width = 31
      Height = 16
      Caption = 'State'
      FocusControl = EditState
    end
    object Label3: TLabel
      Left = 123
      Top = 224
      Width = 17
      Height = 16
      Caption = 'Zip'
      FocusControl = EditZip
    end
    object Label28: TLabel
      Left = 202
      Top = 224
      Width = 4
      Height = 16
      Caption = '-'
    end
    object Label1: TLabel
      Left = 17
      Top = 253
      Width = 48
      Height = 16
      Caption = 'Phone #'
      FocusControl = EditPhoneNumber
    end
    object Label2: TLabel
      Left = 17
      Top = 280
      Width = 33
      Height = 16
      Caption = 'Fax #'
      FocusControl = EditFaxNumber
    end
    object Label4: TLabel
      Left = 17
      Top = 307
      Width = 62
      Height = 16
      Caption = 'Atty Name'
      FocusControl = EditAttorneyName
    end
    object Label5: TLabel
      Left = 17
      Top = 334
      Width = 33
      Height = 16
      Caption = 'EMail'
      FocusControl = EditEmail
    end
    object MainCodeEdit: TDBEdit
      Left = 83
      Top = 31
      Width = 104
      Height = 24
      CharCase = ecUpperCase
      DataField = 'Code'
      DataSource = LawyerDataSource
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
    end
    object EditName: TDBEdit
      Left = 83
      Top = 59
      Width = 213
      Height = 23
      CharCase = ecUpperCase
      DataField = 'Name1'
      DataSource = LawyerDataSource
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
    end
    object EditName2: TDBEdit
      Left = 83
      Top = 86
      Width = 213
      Height = 24
      CharCase = ecUpperCase
      DataField = 'Name2'
      DataSource = LawyerDataSource
      TabOrder = 2
    end
    object EditAddress: TDBEdit
      Left = 83
      Top = 113
      Width = 213
      Height = 24
      CharCase = ecUpperCase
      DataField = 'Address1'
      DataSource = LawyerDataSource
      TabOrder = 3
    end
    object EditAddress2: TDBEdit
      Left = 83
      Top = 140
      Width = 213
      Height = 24
      CharCase = ecUpperCase
      DataField = 'Address2'
      DataSource = LawyerDataSource
      TabOrder = 4
    end
    object EditStreet: TDBEdit
      Left = 83
      Top = 166
      Width = 213
      Height = 24
      CharCase = ecUpperCase
      DataField = 'Street'
      DataSource = LawyerDataSource
      TabOrder = 5
    end
    object EditCity: TDBEdit
      Left = 83
      Top = 193
      Width = 213
      Height = 24
      CharCase = ecUpperCase
      DataField = 'City'
      DataSource = LawyerDataSource
      TabOrder = 6
    end
    object EditState: TDBEdit
      Left = 83
      Top = 220
      Width = 33
      Height = 24
      CharCase = ecUpperCase
      DataField = 'State'
      DataSource = LawyerDataSource
      TabOrder = 7
    end
    object EditZip: TDBEdit
      Left = 147
      Top = 220
      Width = 50
      Height = 24
      CharCase = ecUpperCase
      DataField = 'Zip'
      DataSource = LawyerDataSource
      TabOrder = 8
    end
    object EditZipPlus4: TDBEdit
      Left = 211
      Top = 220
      Width = 40
      Height = 24
      CharCase = ecUpperCase
      DataField = 'ZipPlus4'
      DataSource = LawyerDataSource
      TabOrder = 9
    end
    object EditPhoneNumber: TDBEdit
      Left = 83
      Top = 249
      Width = 213
      Height = 24
      CharCase = ecUpperCase
      DataField = 'PhoneNumber'
      DataSource = LawyerDataSource
      TabOrder = 10
    end
    object EditFaxNumber: TDBEdit
      Left = 83
      Top = 276
      Width = 213
      Height = 24
      CharCase = ecUpperCase
      DataField = 'FaxNumber'
      DataSource = LawyerDataSource
      TabOrder = 11
    end
    object EditAttorneyName: TDBEdit
      Left = 83
      Top = 303
      Width = 213
      Height = 24
      CharCase = ecUpperCase
      DataField = 'AttorneyName'
      DataSource = LawyerDataSource
      TabOrder = 12
    end
    object EditEmail: TDBEdit
      Left = 83
      Top = 330
      Width = 213
      Height = 24
      CharCase = ecUpperCase
      DataField = 'Email'
      DataSource = LawyerDataSource
      TabOrder = 13
    end
  end
  object SaveButton: TBitBtn
    Left = 82
    Top = 390
    Width = 89
    Height = 33
    Hint = 'Press this button to save any current changes.'
    Caption = '&Save'
    TabOrder = 2
    OnClick = SaveButtonClick
    Glyph.Data = {
      76010000424D7601000000000000760000002800000020000000100000000100
      04000000000000010000130B0000130B00001000000000000000000000000000
      800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333330070
      7700333333337777777733333333008088003333333377F73377333333330088
      88003333333377FFFF7733333333000000003FFFFFFF77777777000000000000
      000077777777777777770FFFFFFF0FFFFFF07F3333337F3333370FFFFFFF0FFF
      FFF07F3FF3FF7FFFFFF70F00F0080CCC9CC07F773773777777770FFFFFFFF039
      99337F3FFFF3F7F777F30F0000F0F09999937F7777373777777F0FFFFFFFF999
      99997F3FF3FFF77777770F00F000003999337F773777773777F30FFFF0FF0339
      99337F3FF7F3733777F30F08F0F0337999337F7737F73F7777330FFFF0039999
      93337FFFF7737777733300000033333333337777773333333333}
    NumGlyphs = 2
  end
  object LawyerDataSource: TwwDataSource
    DataSet = LawyerTable
    Left = 319
    Top = 161
  end
  object LawyerTable: TwwTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYCODE'
    TableName = 'ZGLawyerCodes'
    TableType = ttDBase
    SyncSQLByRange = True
    NarrowSearch = False
    ValidateWithMask = True
    Left = 315
    Top = 79
  end
  object LawyerCodeLookupTable: TwwTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYCODE'
    TableName = 'ZGLawyerCodes'
    TableType = ttDBase
    SyncSQLByRange = True
    NarrowSearch = False
    ValidateWithMask = True
    Left = 19
    Top = 377
  end
end
