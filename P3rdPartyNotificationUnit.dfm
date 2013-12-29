object ThirdPartyNotificationSubForm: TThirdPartyNotificationSubForm
  Left = 394
  Top = 177
  Width = 402
  Height = 326
  Caption = '3rd Party Notifications'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object ThirdPartyNotificationGroupBox: TGroupBox
    Left = 16
    Top = 43
    Width = 354
    Height = 225
    Caption = ' 3rd Party Notification #1: '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
    object Label11: TLabel
      Left = 43
      Top = 26
      Width = 48
      Height = 16
      Caption = 'Name 1'
      FocusControl = EditName1
    end
    object Label12: TLabel
      Left = 43
      Top = 55
      Width = 48
      Height = 16
      Caption = 'Name 2'
      FocusControl = EditName2
    end
    object Label13: TLabel
      Left = 43
      Top = 83
      Width = 41
      Height = 16
      Caption = 'Addr 1'
      FocusControl = EditAddress
    end
    object Label14: TLabel
      Left = 43
      Top = 112
      Width = 41
      Height = 16
      Caption = 'Addr 2'
      FocusControl = EditAddress2
    end
    object Label15: TLabel
      Left = 43
      Top = 140
      Width = 38
      Height = 16
      Caption = 'Street'
      FocusControl = EditStreet
    end
    object SwisLabel: TLabel
      Left = 43
      Top = 169
      Width = 24
      Height = 16
      Caption = 'City'
      FocusControl = EditCity
    end
    object Label17: TLabel
      Left = 43
      Top = 197
      Width = 33
      Height = 16
      Caption = 'State'
      FocusControl = EditState
    end
    object Label3: TLabel
      Left = 150
      Top = 197
      Width = 19
      Height = 16
      Caption = 'Zip'
      FocusControl = EditZip
    end
    object Label28: TLabel
      Left = 229
      Top = 197
      Width = 4
      Height = 16
      Caption = '-'
    end
    object EditName1: TDBEdit
      Left = 96
      Top = 22
      Width = 213
      Height = 23
      CharCase = ecUpperCase
      DataField = 'Name1'
      DataSource = MainDataSource
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
    end
    object EditName2: TDBEdit
      Left = 96
      Top = 51
      Width = 213
      Height = 24
      DataField = 'Name2'
      DataSource = MainDataSource
      TabOrder = 1
    end
    object EditAddress: TDBEdit
      Left = 96
      Top = 79
      Width = 213
      Height = 24
      DataField = 'Address1'
      DataSource = MainDataSource
      TabOrder = 2
    end
    object EditAddress2: TDBEdit
      Left = 96
      Top = 108
      Width = 213
      Height = 24
      DataField = 'Address2'
      DataSource = MainDataSource
      TabOrder = 3
    end
    object EditStreet: TDBEdit
      Left = 96
      Top = 136
      Width = 213
      Height = 24
      DataField = 'Street'
      DataSource = MainDataSource
      TabOrder = 4
    end
    object EditCity: TDBEdit
      Left = 96
      Top = 165
      Width = 213
      Height = 24
      DataField = 'City'
      DataSource = MainDataSource
      TabOrder = 5
    end
    object EditState: TDBEdit
      Left = 96
      Top = 193
      Width = 33
      Height = 24
      CharCase = ecUpperCase
      DataField = 'State'
      DataSource = MainDataSource
      TabOrder = 6
    end
    object EditZip: TDBEdit
      Left = 174
      Top = 193
      Width = 50
      Height = 24
      DataField = 'Zip'
      DataSource = MainDataSource
      TabOrder = 7
    end
    object EditZipPlus4: TDBEdit
      Left = 238
      Top = 193
      Width = 40
      Height = 24
      DataField = 'ZipPlus4'
      DataSource = MainDataSource
      TabOrder = 8
    end
  end
  object MainToolBar: TToolBar
    Left = 0
    Top = 0
    Width = 394
    Height = 29
    TabOrder = 1
    object SaveSpeedButton: TSpeedButton
      Left = 0
      Top = 2
      Width = 23
      Height = 22
      Hint = 'Save'
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
    end
    object CancelSpeedButton: TSpeedButton
      Left = 23
      Top = 2
      Width = 23
      Height = 22
      Hint = 'Cancel'
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
    end
  end
  object MainTable: TwwTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYSWISSBLKEY_NOTICENUMBER'
    TableName = 'p3rdPartyNoticeTable'
    TableType = ttDBase
    SyncSQLByRange = True
    NarrowSearch = False
    ValidateWithMask = True
    Left = 346
    Top = 31
  end
  object MainDataSource: TDataSource
    DataSet = MainTable
    Left = 347
    Top = 87
  end
end
