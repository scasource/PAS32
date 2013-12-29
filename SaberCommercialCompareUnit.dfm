object Form1: TForm1
  Left = 300
  Top = 106
  Width = 445
  Height = 393
  Caption = 'Compare Current Commercial Data to Saber Commercial Data'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label9: TLabel
    Left = 158
    Top = 13
    Width = 121
    Height = 16
    Caption = 'Select Swis Codes:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object StartButton: TBitBtn
    Left = 106
    Top = 304
    Width = 81
    Height = 31
    Caption = 'Start'
    Default = True
    TabOrder = 0
    OnClick = StartButtonClick
    Glyph.Data = {
      DE010000424DDE01000000000000760000002800000024000000120000000100
      0400000000006801000000000000000000001000000000000000000000000000
      80000080000000808000800000008000800080800000C0C0C000808080000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
      3333333333333333333333330000333333333333333333333333F33333333333
      00003333344333333333333333388F3333333333000033334224333333333333
      338338F3333333330000333422224333333333333833338F3333333300003342
      222224333333333383333338F3333333000034222A22224333333338F338F333
      8F33333300003222A3A2224333333338F3838F338F33333300003A2A333A2224
      33333338F83338F338F33333000033A33333A222433333338333338F338F3333
      0000333333333A222433333333333338F338F33300003333333333A222433333
      333333338F338F33000033333333333A222433333333333338F338F300003333
      33333333A222433333333333338F338F00003333333333333A22433333333333
      3338F38F000033333333333333A223333333333333338F830000333333333333
      333A333333333333333338330000333333333333333333333333333333333333
      0000}
    NumGlyphs = 2
  end
  object CancelButton: TBitBtn
    Left = 231
    Top = 304
    Width = 81
    Height = 31
    Cancel = True
    Caption = 'Cancel'
    TabOrder = 1
    OnClick = CancelButtonClick
    Glyph.Data = {
      DE010000424DDE01000000000000760000002800000024000000120000000100
      0400000000006801000000000000000000001000000000000000000000000000
      80000080000000808000800000008000800080800000C0C0C000808080000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
      333333333333333333333333000033338833333333333333333F333333333333
      0000333911833333983333333388F333333F3333000033391118333911833333
      38F38F333F88F33300003339111183911118333338F338F3F8338F3300003333
      911118111118333338F3338F833338F3000033333911111111833333338F3338
      3333F8330000333333911111183333333338F333333F83330000333333311111
      8333333333338F3333383333000033333339111183333333333338F333833333
      00003333339111118333333333333833338F3333000033333911181118333333
      33338333338F333300003333911183911183333333383338F338F33300003333
      9118333911183333338F33838F338F33000033333913333391113333338FF833
      38F338F300003333333333333919333333388333338FFF830000333333333333
      3333333333333333333888330000333333333333333333333333333333333333
      0000}
    NumGlyphs = 2
  end
  object SwisCodeListBox: TListBox
    Left = 115
    Top = 37
    Width = 207
    Height = 251
    IntegralHeight = True
    ItemHeight = 13
    MultiSelect = True
    TabOrder = 2
  end
  object ProgressBar: TProgressBar
    Left = 0
    Top = 343
    Width = 437
    Height = 16
    Align = alBottom
    Min = 0
    Max = 100
    TabOrder = 3
  end
  object ParcelTable: TTable
    DatabaseName = 'PASRamapo'
    IndexName = 'BYTAXROLLYR_SWISSBLKEY'
    TableName = 'Tparcelrec'
    TableType = ttDBase
    Left = 48
    Top = 232
  end
  object CommercialBuildingTable: TTable
    DatabaseName = 'PropertyAssessmentSystem'
    IndexName = 'BYTAXROLLYR_SWISSBLKEY'
    TableName = 'TPResidentialBldg'
    TableType = ttDBase
    Left = 139
    Top = 223
  end
  object CommercialRentTable: TTable
    DatabaseName = 'PropertyAssessmentSystem'
    IndexName = 'BYTAXROLLYR_SWISSBLKEY'
    TableName = 'TPCommercialRent'
    TableType = ttDBase
    Left = 238
    Top = 240
  end
  object SaberParcelTable: TTable
    DatabaseName = 'SaberData'
    IndexName = 'BYTAXROLLYR_SWISSBLKEY'
    TableName = 'Tparcelrec'
    TableType = ttDBase
    Left = 349
    Top = 31
  end
  object SaberCommercialBuildingTable: TTable
    DatabaseName = 'SaberData'
    IndexName = 'BYTAXROLLYR_SWISSBLKEY'
    TableName = 'TPCommercialBldg'
    TableType = ttDBase
    Left = 341
    Top = 110
  end
  object SaberCommercialRentTable: TTable
    DatabaseName = 'SaberData'
    IndexName = 'BYTAXROLLYR_SWISSBLKEY'
    TableName = 'TPCommercialRent'
    TableType = ttDBase
    Left = 357
    Top = 178
  end
  object SwisCodeTable: TTable
    DatabaseName = 'PASRamapo'
    IndexName = 'BYSWISCODE'
    TableName = 'TSwisTbl'
    TableType = ttDBase
    Left = 27
    Top = 44
  end
  object InitializationTimer: TTimer
    Enabled = False
    OnTimer = InitializationTimerTimer
    Left = 67
    Top = 133
  end
  object SystemTable: TTable
    DatabaseName = 'PASRamapo'
    TableName = 'SystemRecord'
    TableType = ttDBase
    Left = 365
    Top = 234
  end
  object AssessmentYearControlTable: TTable
    DatabaseName = 'PASRamapo'
    TableName = 'TAssmtYrCtlFile'
    TableType = ttDBase
    Left = 204
    Top = 165
  end
  object CommercialInventoryTable: TTable
    DatabaseName = 'PropertyAssessmentSystem'
    IndexName = 'BYTAXROLLYR_SWISSBLKEY'
    TableName = 'TPCommercialImprove'
    TableType = ttDBase
    Left = 163
    Top = 109
  end
  object SaberCommercialInventoryTable: TTable
    DatabaseName = 'SaberData'
    IndexName = 'BYTAXROLLYR_SWISSBLKEY'
    TableName = 'TPCommercialImprove'
    TableType = ttDBase
    Left = 144
    Top = 44
  end
end
