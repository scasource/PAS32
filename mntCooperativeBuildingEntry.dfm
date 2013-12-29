object fmCooperativeBuildingsEntry: TfmCooperativeBuildingsEntry
  Left = 542
  Top = 153
  Width = 455
  Height = 350
  Caption = 'Base'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 13
  object gbxSwisCode: TGroupBox
    Left = 0
    Top = 29
    Width = 439
    Height = 285
    Align = alClient
    Caption = ' Coop Building: '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
    object MainCodeLabel: TLabel
      Left = 27
      Top = 25
      Width = 30
      Height = 16
      Caption = 'SBL:'
    end
    object MunNameLabel: TLabel
      Left = 27
      Top = 90
      Width = 74
      Height = 16
      Caption = 'Bldg Name:'
      FocusControl = edBuildingName
    end
    object EqualLabel: TLabel
      Left = 27
      Top = 220
      Width = 77
      Height = 16
      Caption = 'Assessment:'
    end
    object Label1: TLabel
      Left = 27
      Top = 252
      Width = 84
      Height = 16
      Caption = 'Total Shares:'
    end
    object Label2: TLabel
      Left = 27
      Top = 57
      Width = 62
      Height = 16
      Caption = 'Print Key:'
    end
    object Label3: TLabel
      Left = 27
      Top = 122
      Width = 46
      Height = 16
      Caption = 'Owner:'
      FocusControl = edOwner
    end
    object Label4: TLabel
      Left = 27
      Top = 155
      Width = 65
      Height = 16
      Caption = 'Mail Addr:'
      FocusControl = edMailAddr1
    end
    object Label5: TLabel
      Left = 27
      Top = 187
      Width = 65
      Height = 16
      Caption = 'Mail Addr:'
      FocusControl = edMailAddr2
    end
    object edBuildingName: TDBEdit
      Left = 118
      Top = 86
      Width = 297
      Height = 24
      CharCase = ecUpperCase
      DataField = 'CoopName'
      DataSource = dsMain
      TabOrder = 2
      OnChange = EditChange
    end
    object edAssessment: TDBEdit
      Left = 118
      Top = 216
      Width = 85
      Height = 24
      DataField = 'AssessedValue'
      DataSource = dsMain
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGreen
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 6
      OnChange = EditChange
    end
    object edTotalShares: TDBEdit
      Left = 118
      Top = 248
      Width = 85
      Height = 24
      DataField = 'TotalShares'
      DataSource = dsMain
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGreen
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 7
      OnChange = EditChange
    end
    object edSwisSBLKey: TEdit
      Left = 118
      Top = 21
      Width = 158
      Height = 24
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      OnChange = EditChange
    end
    object edOwner: TDBEdit
      Left = 118
      Top = 118
      Width = 297
      Height = 24
      CharCase = ecUpperCase
      DataField = 'Owner'
      DataSource = dsMain
      TabOrder = 3
      OnChange = EditChange
    end
    object edMailAddr1: TDBEdit
      Left = 118
      Top = 151
      Width = 297
      Height = 24
      CharCase = ecUpperCase
      DataField = 'MailingAddr1'
      DataSource = dsMain
      TabOrder = 4
      OnChange = EditChange
    end
    object edMailAddr2: TDBEdit
      Left = 118
      Top = 183
      Width = 297
      Height = 24
      CharCase = ecUpperCase
      DataField = 'MailingAddr2'
      DataSource = dsMain
      TabOrder = 5
      OnChange = EditChange
    end
    object edPrintKey: TDBEdit
      Left = 118
      Top = 55
      Width = 158
      Height = 24
      CharCase = ecUpperCase
      DataField = 'PrintKey'
      DataSource = dsMain
      TabOrder = 1
      OnChange = EditChange
    end
  end
  object MainToolBar: TToolBar
    Left = 0
    Top = 0
    Width = 439
    Height = 29
    TabOrder = 1
    object btnSave: TSpeedButton
      Left = 0
      Top = 2
      Width = 23
      Height = 22
      Hint = 'Save'
      Flat = True
      Glyph.Data = {
        EE030000424DEE03000000000000360000002800000012000000110000000100
        180000000000B8030000C40E0000C40E00000000000000000000D8E9ECD8E9EC
        D8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9
        ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9EC0000D8E9ECD8E9ECD8E9ECA7A7A77373
        737373735959595959594B4B4B4B4B4B3D3D3D303030303030303030A7A7A7D8
        E9ECD8E9ECD8E9EC0000D8E9ECD8E9ECA7A7A7633600CDCDCDE6E6E6C1C1C1C1
        C1C1CDCDCDF0F0F0EDEDEDE6E6E6A7A7A7333333303030A7A7A7D8E9ECD8E9EC
        0000D8E9EC633600633600633600DADADAE6E6E6E6E6E6E6E6E6E6E6E6E6E6E6
        E6E6E6E6E6E6DADADACB8C44633600303030303030D8E9EC0000D8E9EC633600
        CB8C44633600D9A77DD9A77DD9A77DD9A77DD9A77DCB8C44CB8C44CB8C44CB8C
        44CB8C446336007F5B00303030D8E9EC0000D8E9EC633600D9A77D633600D9A7
        7DD9A77DD9A77DD9A77DD9A77DD9A77DCB8C44CB8C44CB8C44CB8C44633600CB
        8C44303030D8E9EC0000D8E9EC633600D9A77D633600D9A77DD9A77DD9A77DD9
        A77DD9A77DD9A77DD9A77DCB8C44CB8C44CB8C44633600CB8C443D3D3DD8E9EC
        0000D8E9EC633600D9A77D633600AA3F2A633600633600633600633600633600
        633600633600633600CB8C44633600CB8C444B4B4BD8E9EC0000D8E9EC633600
        D9A77D6336009A9A9AAAFFFF99F8FF99F8FF99F8FF99F8FF99F8FF99F8FF99F8
        FF633600633600CB8C444B4B4BD8E9EC0000D8E9EC633600D9A77D633600AAFF
        FFCDCDCDA7A7A7A7A7A7A7A7A7A7A7A7A7A7A7A7A7A7C1C1C199F8FF633600CB
        8C444B4B4BD8E9EC0000D8E9EC633600D9A77D7F5B00AAFFFFAAFFFFAAFFFFAA
        FFFFAAFFFFAAFFFFAAFFFFAAFFFFAAFFFF99F8FF7F5B00CB8C444B4B4BD8E9EC
        0000D8E9EC633600D9A77D7F5B00AAFFFFCDCDCDA7A7A7A7A7A7A7A7A7A7A7A7
        A7A7A7A7A7A7C1C1C199F8FF7F5B00CB8C444B4B4BD8E9EC0000D8E9EC633600
        D9A77D989898AAFFFFAAFFFFAAFFFFAAFFFFAAFFFFAAFFFFAAFFFFAAFFFFAAFF
        FF99F8FF989898CB8C44595959D8E9EC0000D8E9EC633600D9A77DA6A6A6D8E9
        ECCDCDCDCB8C44CB8C44A7A7A7A7A7A7A7A7A7A7A7A7C1C1C199F8FFA6A6A6D9
        A77D666666D8E9EC0000D8E9ECA7A7A76336007F5B00D8E9ECD8E9ECAAFFFFAA
        FFFFAAFFFFAAFFFFAAFFFFAAFFFFAAFFFFAAFFFF7F5B00633600A7A7A7D8E9EC
        0000D8E9ECD8E9ECD8E9ECA7A7A7633600633600633600633600633600633600
        6336006336006336006336009A9A9AD8E9ECD8E9ECD8E9EC0000D8E9ECD8E9EC
        D8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9
        ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9EC0000}
      OnClick = btnSaveClick
    end
    object btnCancel: TSpeedButton
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
      OnClick = btnCancelClick
    end
    object btnCalculate: TSpeedButton
      Left = 46
      Top = 2
      Width = 23
      Height = 22
      Flat = True
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000120B0000120B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00337000000000
        73333337777777773F333308888888880333337F3F3F3FFF7F33330808089998
        0333337F737377737F333308888888880333337F3F3F3F3F7F33330808080808
        0333337F737373737F333308888888880333337F3F3F3F3F7F33330808080808
        0333337F737373737F333308888888880333337F3F3F3F3F7F33330808080808
        0333337F737373737F333308888888880333337F3FFFFFFF7F33330800000008
        0333337F7777777F7F333308000E0E080333337F7FFFFF7F7F33330800000008
        0333337F777777737F333308888888880333337F333333337F33330888888888
        03333373FFFFFFFF733333700000000073333337777777773333}
      NumGlyphs = 2
      OnClick = btnCalculateClick
    end
    object btnApportion: TSpeedButton
      Left = 69
      Top = 2
      Width = 23
      Height = 22
      Hint = 'Apportion Coops'
      Flat = True
      Glyph.Data = {
        66010000424D6601000000000000760000002800000014000000140000000100
        040000000000F000000000000000000000001000000010000000000000000000
        8000008000000080800080000000800080008080000080808000C0C0C0000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888888888888
        8888888800008888888888888888888800008888888888888888888800008888
        88888888777777780000888888888880000000780000888888888840FBFBF078
        0000888888888480000000880000888888884888888888880000887777748888
        77777778000080000007777000000078000080FFFF044440FBFBF07800008000
        0008788000000088000088888884878888888888000088888888487877777778
        0000888888888480000000780000888888888840FBFBF0780000888888888880
        0000008800008888888888888888888800008888888888888888888800008888
        88888888888888880000}
      OnClick = btnApportionClick
    end
  end
  object tmrButtonsState: TTimer
    Enabled = False
    Interval = 10
    Left = 147
    Top = 1
  end
  object dsMain: TwwDataSource
    DataSet = tbMain
    Left = 283
    Top = 5
  end
  object tbMain: TwwTable
    AfterEdit = tbMainAfterEdit
    BeforePost = tbMainBeforePost
    AfterPost = tbMainAfterPost
    DatabaseName = 'PASsystem'
    IndexName = 'BYCOOPID'
    TableName = 'TCoopBuildings'
    TableType = ttDBase
    SyncSQLByRange = True
    NarrowSearch = False
    ValidateWithMask = True
    Left = 233
    Top = 4
  end
  object dlgPrint: TPrintDialog
    MaxPage = 32000
    Options = [poPrintToFile, poPageNums]
    Left = 228
    Top = 95
  end
  object ReportFiler: TReportFiler
    StatusFormat = 'Printing page %p'
    UnitsFactor = 1
    Title = 'AV Summary Report (PAS)'
    Orientation = poDefault
    ScaleX = 100
    ScaleY = 100
    StreamMode = smFile
    OnPrint = ReportPrint
    Left = 224
    Top = 138
  end
  object ReportPrinter: TReportPrinter
    StatusFormat = 'Printing page %p'
    UnitsFactor = 1
    Title = 'AV Summary Report (PAS)'
    Orientation = poDefault
    ScaleX = 100
    ScaleY = 100
    OnPrint = ReportPrint
    Left = 256
    Top = 72
  end
  object tbSwisCodes: TTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYSWISCODE'
    TableName = 'TSwisTbl'
    TableType = ttDBase
    Left = 284
    Top = 127
  end
end
