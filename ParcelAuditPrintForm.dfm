object ParcelAuditPrintDialog: TParcelAuditPrintDialog
  Left = 122
  Top = 63
  ActiveControl = StartDateEdit
  BorderStyle = bsDialog
  Caption = 'Print Audit Trail for Parcel'
  ClientHeight = 243
  ClientWidth = 359
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object HeaderLabel: TLabel
    Left = 13
    Top = 9
    Width = 103
    Height = 13
    Caption = 'Print audit trail for'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object UserIDGroupBox: TGroupBox
    Left = 13
    Top = 115
    Width = 333
    Height = 80
    Caption = ' User ID Range: '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
    object Label9: TLabel
      Left = 12
      Top = 24
      Width = 34
      Height = 16
      Caption = 'Start:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label10: TLabel
      Left = 12
      Top = 53
      Width = 28
      Height = 16
      Caption = 'End:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object StartUserEdit: TEdit
      Left = 56
      Top = 20
      Width = 98
      Height = 24
      CharCase = ecUpperCase
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
    end
    object AllUsersCheckBox: TCheckBox
      Left = 168
      Top = 23
      Width = 97
      Height = 17
      Caption = ' All Users'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
      OnClick = AllUsersCheckBoxClick
    end
    object ToEndOfUsersCheckBox: TCheckBox
      Left = 168
      Top = 53
      Width = 124
      Height = 17
      Caption = ' To End of Users'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 3
    end
    object EndUserEdit: TEdit
      Left = 56
      Top = 49
      Width = 98
      Height = 24
      CharCase = ecUpperCase
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 2
    end
  end
  object DateGroupBox: TGroupBox
    Left = 13
    Top = 31
    Width = 333
    Height = 80
    Caption = ' Date Range: '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
    object Label7: TLabel
      Left = 12
      Top = 24
      Width = 34
      Height = 16
      Caption = 'Start:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label8: TLabel
      Left = 12
      Top = 53
      Width = 28
      Height = 16
      Caption = 'End:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object AllDatesCheckBox: TCheckBox
      Left = 168
      Top = 23
      Width = 97
      Height = 17
      Caption = ' All Dates'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
      OnClick = AllDatesCheckBoxClick
    end
    object ToEndofDatesCheckBox: TCheckBox
      Left = 168
      Top = 53
      Width = 124
      Height = 17
      Caption = ' To End of Dates'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 3
    end
    object EndDateEdit: TMaskEdit
      Left = 56
      Top = 50
      Width = 98
      Height = 24
      EditMask = '!99/99/0000;1;_'
      MaxLength = 10
      TabOrder = 2
      Text = '  /  /    '
    end
    object StartDateEdit: TMaskEdit
      Left = 56
      Top = 20
      Width = 98
      Height = 24
      EditMask = '!99/99/0000;1;_'
      MaxLength = 10
      TabOrder = 0
      Text = '  /  /    '
    end
  end
  object PrintButton: TBitBtn
    Left = 149
    Top = 205
    Width = 89
    Height = 33
    Caption = '&Print'
    TabOrder = 2
    OnClick = PrintButtonClick
    Glyph.Data = {
      76010000424D7601000000000000760000002800000020000000100000000100
      04000000000000010000120B0000120B00001000000000000000000000000000
      800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00300000000000
      0003377777777777777308888888888888807F33333333333337088888888888
      88807FFFFFFFFFFFFFF7000000000000000077777777777777770F8F8F8F8F8F
      8F807F333333333333F708F8F8F8F8F8F9F07F333333333337370F8F8F8F8F8F
      8F807FFFFFFFFFFFFFF7000000000000000077777777777777773330FFFFFFFF
      03333337F3FFFF3F7F333330F0000F0F03333337F77773737F333330FFFFFFFF
      03333337F3FF3FFF7F333330F00F000003333337F773777773333330FFFF0FF0
      33333337F3F37F3733333330F08F0F0333333337F7337F7333333330FFFF0033
      33333337FFFF7733333333300000033333333337777773333333}
    NumGlyphs = 2
  end
  object CancelButton: TBitBtn
    Left = 250
    Top = 205
    Width = 96
    Height = 33
    TabOrder = 3
    Kind = bkCancel
    Margin = 2
    Spacing = -1
    IsControl = True
  end
  object PrintDialog: TPrintDialog
    MaxPage = 32000
    Options = [poPrintToFile, poPageNums]
    Left = 180
    Top = 4
  end
  object TextFiler: TTextFiler
    CPI = 10
    LPI = 6
    StatusFormat = 'Printing page %p'
    UnitsFactor = 1
    OnPrint = TextFilerPrint
    OnPrintHeader = TextFilerPrintHeader
    Left = 145
    Top = 5
  end
  object ReportFiler: TReportFiler
    StatusFormat = 'Printing page %p'
    UnitsFactor = 1
    Title = 'Audit Trail Report'
    Orientation = poDefault
    ScaleX = 100
    ScaleY = 100
    StreamMode = smFile
    OnPrint = ReportPrint
    Left = 222
    Top = 3
  end
  object ReportPrinter: TReportPrinter
    StatusFormat = 'Printing page %p'
    UnitsFactor = 1
    Title = 'Audit Trail Report'
    Orientation = poDefault
    ScaleX = 100
    ScaleY = 100
    OnPrint = ReportPrint
    Left = 271
    Top = 7
  end
  object AuditTrailTable: TwwTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYSBL_DATE_TIME'
    TableName = 'AuditTable'
    TableType = ttDBase
    SyncSQLByRange = True
    NarrowSearch = False
    ValidateWithMask = True
    Left = 88
    Top = 6
  end
  object AuditQuery: TQuery
    DatabaseName = 'PASsystem'
    Left = 44
    Top = 189
  end
end
