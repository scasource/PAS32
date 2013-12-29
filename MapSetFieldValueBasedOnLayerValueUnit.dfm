object SetFieldValueFromMapLayerDialog: TSetFieldValueFromMapLayerDialog
  Left = 201
  Top = 212
  Width = 462
  Height = 444
  Caption = 'Set Data Field Value from Map Layer'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 16
  object ProgressBar: TProgressBar
    Left = 0
    Top = 390
    Width = 454
    Height = 20
    Align = alBottom
    Min = 0
    Max = 100
    Smooth = True
    TabOrder = 0
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 454
    Height = 350
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 1
    object TabSheet1: TTabSheet
      Caption = 'Options'
      object SourceGroupBox: TGroupBox
        Left = 21
        Top = 11
        Width = 389
        Height = 90
        Caption = ' Source: '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        object Label1: TLabel
          Left = 62
          Top = 20
          Width = 67
          Height = 16
          Caption = 'Map Layer'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label2: TLabel
          Left = 247
          Top = 20
          Width = 32
          Height = 16
          Caption = 'Field'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object MapFieldComboBox: TComboBox
          Left = 191
          Top = 46
          Width = 145
          Height = 24
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBackground
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ItemHeight = 16
          ParentFont = False
          TabOrder = 0
        end
        object MapLayersLookupCombo: TwwDBLookupCombo
          Left = 23
          Top = 46
          Width = 145
          Height = 24
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBackground
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          DropDownAlignment = taLeftJustify
          LookupTable = MapLayersAvailableTable
          LookupField = 'LayerName'
          ParentFont = False
          TabOrder = 1
          AutoDropDown = False
          ShowButton = True
          AllowClearKey = False
          OnCloseUp = MapLayersLookupComboCloseUp
        end
      end
      object DestinationGroupBox: TGroupBox
        Left = 17
        Top = 107
        Width = 389
        Height = 90
        Caption = ' Destination: '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 1
        object Label5: TLabel
          Left = 73
          Top = 20
          Width = 45
          Height = 16
          Caption = 'Screen'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label6: TLabel
          Left = 247
          Top = 20
          Width = 32
          Height = 16
          Caption = 'Field'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object ScreenComboBox: TComboBox
          Left = 23
          Top = 44
          Width = 145
          Height = 24
          Style = csDropDownList
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBackground
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ItemHeight = 16
          ParentFont = False
          TabOrder = 0
          OnChange = ScreenComboBoxChange
        end
        object FieldComboBox: TComboBox
          Left = 191
          Top = 44
          Width = 145
          Height = 24
          Style = csDropDownList
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBackground
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ItemHeight = 16
          ParentFont = False
          TabOrder = 1
        end
      end
      object GroupBox1: TGroupBox
        Left = 16
        Top = 179
        Width = 389
        Height = 121
        Caption = ' Options: '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 2
        object TrialRunCheckBox: TCheckBox
          Left = 217
          Top = 20
          Width = 163
          Height = 17
          Alignment = taLeftJustify
          Caption = 'Trial run:'
          TabOrder = 0
        end
        object AssessmentYearRadioGroup: TRadioGroup
          Left = 27
          Top = 19
          Width = 155
          Height = 72
          Caption = ' Assessment Year: '
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clGreen
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ItemIndex = 0
          Items.Strings = (
            ' This Year'
            ' Next Year')
          ParentFont = False
          TabOrder = 1
        end
        object AddInventoryIfNeededCheckBox: TCheckBox
          Left = 217
          Top = 45
          Width = 163
          Height = 17
          Alignment = taLeftJustify
          Caption = 'Add inv if needed:'
          TabOrder = 2
        end
        object cb_CommercialParcelsOnly: TCheckBox
          Left = 217
          Top = 69
          Width = 163
          Height = 17
          Alignment = taLeftJustify
          Caption = 'Comm Parcels Only'
          TabOrder = 3
        end
        object cb_ResidentialParcelsOnly: TCheckBox
          Left = 217
          Top = 94
          Width = 163
          Height = 17
          Alignment = taLeftJustify
          Caption = 'Res Parcels Only'
          TabOrder = 4
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Exclusions'
      ImageIndex = 1
      object GroupBox2: TGroupBox
        Left = 12
        Top = 20
        Width = 422
        Height = 281
        Caption = ' Exclusions: '
        TabOrder = 0
        object Label3: TLabel
          Left = 21
          Top = 38
          Width = 119
          Height = 16
          Caption = 'Field to Exclude On:'
        end
        object Label4: TLabel
          Left = 21
          Top = 80
          Width = 68
          Height = 16
          Caption = 'Exclusions:'
        end
        object ed_FieldToExcludeOn: TEdit
          Left = 155
          Top = 34
          Width = 151
          Height = 24
          TabOrder = 0
        end
        object sg_Exclusions: TStringGrid
          Left = 21
          Top = 102
          Width = 382
          Height = 155
          ColCount = 3
          DefaultColWidth = 125
          FixedCols = 0
          RowCount = 6
          FixedRows = 0
          Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goEditing, goTabs, goAlwaysShowEditor]
          TabOrder = 1
        end
      end
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 350
    Width = 454
    Height = 40
    Align = alBottom
    TabOrder = 2
    object StartButton: TBitBtn
      Left = 200
      Top = 3
      Width = 86
      Height = 33
      Caption = 'Start'
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
      Left = 350
      Top = 3
      Width = 86
      Height = 33
      Cancel = True
      Caption = 'Cancel'
      Enabled = False
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
  end
  object ScreenLabelTable: TTable
    DatabaseName = 'PASsystem'
    TableName = 'ScreenAndLabelNames'
    TableType = ttDBase
    Left = 329
    Top = 9
  end
  object TempTable: TTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYTAXROLLYR_SWISSBLKEY'
    TableType = ttDBase
    Left = 174
    Top = 2
  end
  object ReportPrinter: TReportPrinter
    StatusFormat = 'Printing page %p'
    UnitsFactor = 1
    Title = 'ReportPrinter Report'
    Orientation = poDefault
    ScaleX = 100
    ScaleY = 100
    OnPrint = ReportPrint
    OnPrintHeader = ReportPrintHeader
    Left = 266
    Top = 102
  end
  object ReportFiler: TReportFiler
    StatusFormat = 'Printing page %p'
    UnitsFactor = 1
    Title = 'ReportPrinter Report'
    Orientation = poDefault
    ScaleX = 100
    ScaleY = 100
    OnPrint = ReportPrint
    OnPrintHeader = ReportPrintHeader
    Left = 195
    Top = 99
  end
  object PrintDialog: TPrintDialog
    Options = [poPrintToFile]
    Left = 215
    Top = 14
  end
  object UserFieldDefinitionTable: TTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYTAXROLLYR_DISPLAYORDER'
    TableName = 'TPUserFieldsDefs'
    TableType = ttDBase
    Left = 172
    Top = 153
  end
  object MapLayersAvailableTable: TwwTable
    DatabaseName = 'PropertyAssessmentSystem'
    IndexName = 'BYLAYERNAME'
    TableName = 'MapLayersAvailable'
    TableType = ttDBase
    SyncSQLByRange = False
    NarrowSearch = False
    ValidateWithMask = True
    Left = 266
    Top = 164
  end
  object AssessmentYearControlTable: TTable
    DatabaseName = 'PASsystem'
    TableName = 'NAssmtYrCtlFile'
    TableType = ttDBase
    Left = 361
    Top = 53
  end
  object MapParcelIDFormatTable: TTable
    DatabaseName = 'PASsystem'
    TableType = ttDBase
    Left = 107
    Top = 147
  end
  object ParcelLookupTable: TTable
    DatabaseName = 'PASsystem'
    TableName = 'Nparcelrec'
    TableType = ttDBase
    Left = 341
    Top = 122
  end
  object CommercialSiteTable: TTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYTAXROLLYR_SWISSBLKEY_SITE'
    TableType = ttDBase
    Left = 87
    Top = 290
  end
  object ResidentialSiteTable: TTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYTAXROLLYR_SWISSBLKEY_SITE'
    TableType = ttDBase
    Left = 278
    Top = 256
  end
  object ResidentialBldgTable: TTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYTAXROLLYR_SWISSBLKEY_SITE'
    TableType = ttDBase
    Left = 140
    Top = 201
  end
  object CommercialBldgTable: TTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYYEAR_SBL_SITE_BLDGNUM_SECT'
    TableType = ttDBase
    Left = 155
    Top = 249
  end
end
