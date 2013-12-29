object NameAddressDialogForm: TNameAddressDialogForm
  Left = 510
  Top = 220
  Width = 402
  Height = 354
  ActiveControl = EditName1
  Caption = 'Name \ address'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnCloseQuery = FormCloseQuery
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 13
  object NameAddressGroupBox: TGroupBox
    Left = 20
    Top = 38
    Width = 354
    Height = 261
    Caption = ' Name \ Address #1: '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object Label11: TLabel
      Left = 43
      Top = 26
      Width = 45
      Height = 16
      Caption = 'Name 1'
      FocusControl = EditName1
    end
    object Label12: TLabel
      Left = 43
      Top = 55
      Width = 45
      Height = 16
      Caption = 'Name 2'
      FocusControl = EditName2
    end
    object Label13: TLabel
      Left = 43
      Top = 83
      Width = 38
      Height = 16
      Caption = 'Addr 1'
      FocusControl = EditAddress
    end
    object Label14: TLabel
      Left = 43
      Top = 112
      Width = 38
      Height = 16
      Caption = 'Addr 2'
      FocusControl = EditAddress2
    end
    object Label15: TLabel
      Left = 43
      Top = 141
      Width = 35
      Height = 16
      Caption = 'Street'
      FocusControl = EditStreet
    end
    object SwisLabel: TLabel
      Left = 43
      Top = 170
      Width = 23
      Height = 16
      Caption = 'City'
      FocusControl = EditCity
    end
    object Label17: TLabel
      Left = 43
      Top = 198
      Width = 31
      Height = 16
      Caption = 'State'
      FocusControl = EditState
    end
    object Label3: TLabel
      Left = 150
      Top = 198
      Width = 17
      Height = 16
      Caption = 'Zip'
      FocusControl = EditZip
    end
    object Label28: TLabel
      Left = 229
      Top = 198
      Width = 4
      Height = 16
      Caption = '-'
    end
    object lbl_PhoneNumber: TLabel
      Left = 43
      Top = 227
      Width = 48
      Height = 16
      Caption = 'Phone #'
      FocusControl = edt_PhoneNumber
      Visible = False
    end
    object EditName1: TDBEdit
      Left = 96
      Top = 22
      Width = 213
      Height = 23
      CharCase = ecUpperCase
      DataField = 'Name1'
      DataSource = NameAddressDataSource
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
    end
    object EditName2: TDBEdit
      Left = 96
      Top = 51
      Width = 213
      Height = 24
      CharCase = ecUpperCase
      DataField = 'Name2'
      DataSource = NameAddressDataSource
      TabOrder = 1
    end
    object EditAddress: TDBEdit
      Left = 96
      Top = 79
      Width = 213
      Height = 24
      CharCase = ecUpperCase
      DataField = 'Address1'
      DataSource = NameAddressDataSource
      TabOrder = 2
    end
    object EditAddress2: TDBEdit
      Left = 96
      Top = 108
      Width = 213
      Height = 24
      CharCase = ecUpperCase
      DataField = 'Address2'
      DataSource = NameAddressDataSource
      TabOrder = 3
    end
    object EditStreet: TDBEdit
      Left = 96
      Top = 137
      Width = 213
      Height = 24
      CharCase = ecUpperCase
      DataField = 'Street'
      DataSource = NameAddressDataSource
      TabOrder = 4
    end
    object EditCity: TDBEdit
      Left = 96
      Top = 166
      Width = 213
      Height = 24
      CharCase = ecUpperCase
      DataField = 'City'
      DataSource = NameAddressDataSource
      TabOrder = 5
    end
    object EditState: TDBEdit
      Left = 96
      Top = 194
      Width = 33
      Height = 24
      CharCase = ecUpperCase
      DataField = 'State'
      DataSource = NameAddressDataSource
      TabOrder = 6
    end
    object EditZip: TDBEdit
      Left = 174
      Top = 194
      Width = 50
      Height = 24
      CharCase = ecUpperCase
      DataField = 'Zip'
      DataSource = NameAddressDataSource
      TabOrder = 7
    end
    object EditZipPlus4: TDBEdit
      Left = 238
      Top = 194
      Width = 40
      Height = 24
      CharCase = ecUpperCase
      DataField = 'ZipPlus4'
      DataSource = NameAddressDataSource
      TabOrder = 8
      OnExit = EditZipPlus4Exit
    end
    object edt_PhoneNumber: TDBEdit
      Left = 96
      Top = 223
      Width = 213
      Height = 24
      CharCase = ecUpperCase
      DataField = 'City'
      DataSource = NameAddressDataSource
      TabOrder = 9
      Visible = False
      OnExit = edt_PhoneNumberExit
    end
  end
  object MainToolBar: TToolBar
    Left = 0
    Top = 0
    Width = 394
    Height = 29
    TabOrder = 1
    object SaveButton: TSpeedButton
      Left = 0
      Top = 2
      Width = 23
      Height = 22
      Hint = 'Save'
      Enabled = False
      Flat = True
      Glyph.Data = {
        16020000424D160200000000000076000000280000001A0000001A0000000100
        040000000000A001000000000000000000001000000000000000000000000000
        BF0000BF000000BFBF00BF000000BF00BF00BFBF0000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
        777777777777772D800077777777777777777777777777000000777777777777
        7777777777777700000077777777777777777777777777000000777770000000
        000000007777770000007777700BBBBBBBBBBBB07777770000007777700BBBBB
        BBBBBBB077777700000077777080BBBBBBBBBBBB077777000000777770B0BBBB
        BBBBBBBB07777700000077777080BBBBBBBBBBBB077777000000777770B80BBB
        BBBBBBBBB07777003C007777708B0BBBBBBBBBBBB07777004100777770B80000
        000000000077770045007777708B800000008B0777777700470077777000B80E
        EEE00007777777007200777777770000EEE07777777777005E0077777777770E
        EEE077777777770060007777777770EEE0E07777777777006200777777770EEE
        0700777777777700850077777770EEE077707777777777008700777777770E07
        77777777777777003C007777777770777777777777777700E100777777777777
        7777777777777700440077777777777777777777777777003E00777777777777
        7777777777777700400077777777777777777777777777004500}
      OnClick = SaveButtonClick
    end
    object CancelButton: TSpeedButton
      Left = 23
      Top = 2
      Width = 23
      Height = 22
      Hint = 'Cancel'
      Enabled = False
      Flat = True
      Glyph.Data = {
        42010000424D4201000000000000760000002800000011000000110000000100
        040000000000CC00000000000000000000001000000010000000000000000000
        BF0000BF000000BFBF00BF000000BF00BF00BFBF0000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
        777770000000777777777777777770000000777777777777770F700000007777
        0F777777777770000000777000F7777770F770000000777000F777770F777000
        00007777000F77700F777000000077777000F700F7777000000077777700000F
        7777700000007777777000F777777000000077777700000F7777700000007777
        7000F70F7777700000007770000F77700F7770000000770000F7777700F77000
        00007700F7777777700F70000000777777777777777770000000777777777777
        777770000000}
      OnClick = CancelButtonClick
    end
  end
  object NameAddressTable: TwwTable
    DatabaseName = 'PASsystem'
    TableType = ttDBase
    SyncSQLByRange = True
    NarrowSearch = False
    ValidateWithMask = True
    Left = 237
    Top = 9
  end
  object NameAddressDataSource: TDataSource
    DataSet = NameAddressTable
    Left = 245
    Top = 92
  end
  object ButtonsStateTimer: TTimer
    Enabled = False
    Interval = 10
    OnTimer = ButtonsStateTimerTimer
    Left = 322
    Top = 193
  end
end
