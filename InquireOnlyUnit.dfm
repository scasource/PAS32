object MainForm: TMainForm
  Left = 64
  Top = 82
  Width = 640
  Height = 480
  Caption = 'Property Assessment System'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsMDIForm
  Menu = MainMenu1
  OldCreateOrder = False
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object UserInfoPanel: TPanel
    Left = 58
    Top = 81
    Width = 523
    Height = 250
    BevelInner = bvRaised
    BorderStyle = bsSingle
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -19
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object LogoImage: TImage
      Left = 9
      Top = 14
      Width = 38
      Height = 38
      Picture.Data = {
        07544269746D6170260A0000424D260A00000000000036040000280000002600
        0000260000000100080000000000F00500000000000000000000000100000000
        0000000000000000BF0000BF000000BFBF00BF000000BF00BF00BFBF0000C0C0
        C000C0DCC000F0CAA60000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000F0FBFF00A4A0
        A000808080000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFF
        FF00FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFF0001FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0100FFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0100FFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        0001FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF07F8F8000001000100F8F8F8070707
        FFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFFFFFFFFFFF80000000000000000
        000100F9F8F8F8F8F8F80707FFFFFFFF0001FFFFFFFFFFFFFFFFFFFFFF070100
        010001000000000000000000F900F8F8F8F8F8F80707FFFFF800FFFFFFFFFFFF
        FFFFFFFFF800000000000000010000010000000000F900F9F8F8F8F8F807FFFF
        FFFFFFFFFFFFFFFFFFFFFFF8010001000100010001010001000100000000F900
        F9F8070707FFFFFFFFFFFFFFFFFFFFFFFFFFF801000100010001000100000100
        010001000100000100F8FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF8000100010001
        00010001000101000100010001000000010007FFFFFFFFFFFFFFFFFFFFFFFFFF
        FF0101000100010001000100010000010001000100010000000100FFFFFFFFFF
        FFFFFFFFFFFFFFFFF80001000100010001000100010100010001000001000100
        000001F8FFFFFFFF0000FFFFFFFFFFFF01010001000100010001000100000100
        010001000100010001000001FFFFFFFF0707FFFFFFFFFF070001000101010101
        010101010101010100000101000100010001010007FFFFFF0000FFFFFFFFFFF8
        01000101FBFBFBFB01010101F8FBFBFBFBF80001FB01000100FB000100FFFFFF
        0000FFFFFFFFFFF8000100FBF80101FBFB0101F8FBFB0101FBFB0100FB000100
        01FB0001F8FFFFFF0000FFFFFFFFFF000100010101010101FBF801F8FB010101
        01010101FBFBFBFBFBFB010001FFFFFF0000FFFFFFFFFF0100010101FBFBFBFB
        FB0101FBFB01010101010101FBF8010001FB010000FFFFFF0000FFFFFFFFFF00
        010101FBFBFBFBFB01F901FBFB01010101010101FB00010100FB000101FFFFFF
        0000FFFFFFFFFF010101F8FBF901F901F901F9F8FB01010101010101FBFB0001
        FBFB000101FFFFFF0000FFFFFFFFFF00010101FBFB0101FBFBF901F9FBFB0101
        FBFB0101F8FBFBFBFB010100F8FFFFFF0000FFFFFFFFFFF80101F901FBFBFBFB
        F901F901F9FBFBFBFBF801010101FBFB0100000101FFFFFF0000FFFFFFFFFF07
        01F901F901F901F901F901F901F901F901F90101010100010001000007FFFFFF
        0000FFFFFFFFFFFFF901F901F901F901F901F901F901F901F901010101010100
        01000100FFFFFFFF0000FFFFFFFFFFFFF8F901F901F9F9F9F9F9F9F901F901F9
        01F901010101010100010000FFFFFFFF0000FFFFFFFFFFFF0701F901F9F9F9F9
        F807F8F9F901F901F901F9010101010001000107FFFFFFFF0000FFFFFFFFFFFF
        FF0701F9F9F9F9F807FF07F8F9F901F901F9010101010101000107FFFFFFFFFF
        0F00FFFFFFFFFFFFFFFFF801F9F9F907FFFFFF07F9F9F901F901F90101010100
        01F8FFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFFF801F9F9F807FF07F8F9F901F9
        01F9010101010101F8FFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFFFFF8F9F9F9
        F807F8F9F901F901F9010101010101F8FFFFFFFFFFFFFFFF0000FFFFFFFFFFFF
        FFFFFFFFFF07F9F9F9F9F9F9F9F901F901F90101010107FFFFFFFFFFFFFFFFFF
        0000FFFFFFFFFFFFFFFFFFFFFFFFFFF8F9F9F9F9F901F90101010101F807FFFF
        FFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF07F8F901F90101
        F8F807FFFFFFFFFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000}
    end
    object TitleLabel: TLabel
      Left = 54
      Top = 7
      Width = 367
      Height = 36
      Caption = 'Property Assessment System'
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlue
      Font.Height = -32
      Font.Name = 'Times New Roman'
      Font.Style = [fsBold, fsItalic]
      ParentFont = False
    end
    object VersionLabel: TLabel
      Left = 54
      Top = 52
      Width = 5
      Height = 16
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object MunicipalityLabel: TLabel
      Left = 174
      Top = 92
      Width = 173
      Height = 24
      Caption = 'MunicipalityLabel'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGreen
      Font.Height = -21
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      Visible = False
    end
    object GroupBox1: TGroupBox
      Left = 10
      Top = 117
      Width = 501
      Height = 115
      TabOrder = 0
      object UserIDLabel: TLabel
        Left = 19
        Top = 87
        Width = 94
        Height = 19
        Caption = 'UserIDLabel'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clPurple
        Font.Height = -16
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        Visible = False
      end
      object CurrentTaxYearLabel: TLabel
        Left = 17
        Top = 33
        Width = 213
        Height = 24
        Caption = 'CurrentTaxYearLabel'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clRed
        Font.Height = -21
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        Visible = False
      end
      object DateLabel: TLabel
        Left = 383
        Top = 34
        Width = 93
        Height = 22
        Caption = 'DateLabel'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -19
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        Visible = False
      end
    end
  end
  object TabSet: TTabSet
    Left = 0
    Top = 413
    Width = 632
    Height = 21
    Align = alBottom
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    SelectedColor = clAqua
    UnselectedColor = clWhite
  end
  object AssessorsOfficeTable: TTable
    DatabaseName = 'PASsystem'
    TableName = 'AssessorOfficeTable'
    TableType = ttDBase
    Left = 14
    Top = 176
  end
  object SysRecTable: TTable
    DatabaseName = 'PASsystem'
    TableName = 'SystemRecord'
    TableType = ttDBase
    Left = 45
    Top = 35
  end
  object InstalledPrinterTable: TTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYPRINTERNAME'
    TableName = 'InstalledPrinterTbl'
    TableType = ttDBase
    Left = 23
    Top = 355
    object InstalledPrinterTablePrinterName: TStringField
      FieldName = 'PrinterName'
      Size = 60
    end
    object InstalledPrinterTableLaser: TBooleanField
      FieldName = 'Laser'
    end
    object InstalledPrinterTableReserved: TStringField
      FieldName = 'Reserved'
      Size = 50
    end
  end
  object PrinterSetupDialog: TPrinterSetupDialog
    Left = 306
    Top = 360
  end
  object OpenTablesInDataModuleTimer: TTimer
    Enabled = False
    Interval = 10
    OnTimer = OpenTablesInDataModuleTimerTimer
    Left = 448
    Top = 353
  end
  object LoginDlg: TLoginDlg
    RetryCount = 3
    DataSet = UserProfileTable
    Left = 550
    Top = 338
  end
  object UserProfileTable: TTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYUSERID'
    TableName = 'UserProfileTable'
    TableType = ttDBase
    Left = 510
    Top = 17
  end
  object Timer: TTimer
    Enabled = False
    Interval = 1
    OnTimer = TimerTimer
    Left = 261
    Top = 12
  end
  object MainMenu1: TMainMenu
    Left = 323
    Top = 16
    object Inquire: TMenuItem
      Caption = '&Inquire'
      OnClick = InquireClick
    end
    object SystemMenuItem: TMenuItem
      Caption = '&System'
      Enabled = False
      object MaintainSystemRecord1: TMenuItem
        Tag = 11020
        Caption = '&Maintain System Record'
        OnClick = NormalMenuItemClick
      end
      object UserProfile1: TMenuItem
        Tag = 10020
        Caption = '&User Profile'
        OnClick = NormalMenuItemClick
      end
    end
    object Exit: TMenuItem
      Caption = 'E&xit'
      OnClick = ExitClick
    end
    object ChangeThisYearandNextYearTogether: TMenuItem
      Caption = 'Change This Year and Next Year Together'
      Enabled = False
      Visible = False
    end
  end
end
