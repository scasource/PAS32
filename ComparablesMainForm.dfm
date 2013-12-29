object ComparativesDisplayForm: TComparativesDisplayForm
  Left = 272
  Top = 138
  Width = 649
  Height = 447
  Caption = 'Comparable Parcels'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  ShowHint = True
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label32: TLabel
    Left = 23
    Top = 71
    Width = 47
    Height = 13
    Caption = 'Bldg Style'
  end
  object Label33: TLabel
    Left = 23
    Top = 44
    Width = 46
    Height = 13
    Caption = 'Neighbhd'
  end
  object Label34: TLabel
    Left = 111
    Top = 72
    Width = 65
    Height = 16
    Caption = 'Bldg Style'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label35: TLabel
    Left = 111
    Top = 44
    Width = 61
    Height = 16
    Caption = 'Neighbhd'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 633
    Height = 35
    Align = alTop
    TabOrder = 0
    object TitleLabel: TLabel
      Left = 209
      Top = 6
      Width = 181
      Height = 22
      Caption = 'Display Comparables'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -19
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object TemplateParcelLabel: TLabel
      Left = 403
      Top = 9
      Width = 109
      Height = 16
      Caption = 'Template Parcel:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object GroupBox1: TGroupBox
      Left = 105
      Top = -2
      Width = 73
      Height = 32
      TabOrder = 0
      object ExitParcelMaintenanceSpeedButton: TSpeedButton
        Left = 48
        Top = 7
        Width = 23
        Height = 22
        Hint = 'Exit comparables.'
        Flat = True
        Glyph.Data = {
          76010000424D7601000000000000760000002800000020000000100000000100
          04000000000000010000120B0000120B00001000000000000000000000000000
          800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00330000000000
          03333377777777777F333301BBBBBBBB033333773F3333337F3333011BBBBBBB
          0333337F73F333337F33330111BBBBBB0333337F373F33337F333301110BBBBB
          0333337F337F33337F333301110BBBBB0333337F337F33337F333301110BBBBB
          0333337F337F33337F333301110BBBBB0333337F337F33337F333301110BBBBB
          0333337F337F33337F333301110BBBBB0333337F337FF3337F33330111B0BBBB
          0333337F337733337F333301110BBBBB0333337F337F33337F333301110BBBBB
          0333337F3F7F33337F333301E10BBBBB0333337F7F7F33337F333301EE0BBBBB
          0333337F777FFFFF7F3333000000000003333377777777777333}
        NumGlyphs = 2
        OnClick = ExitParcelMaintenanceSpeedButtonClick
      end
      object LocateSpeedButton: TSpeedButton
        Left = 1
        Top = 7
        Width = 23
        Height = 22
        Hint = 'Locate another parcel.'
        Flat = True
        Glyph.Data = {
          76010000424D7601000000000000760000002800000020000000100000000100
          04000000000000010000130B0000130B00001000000000000000000000000000
          800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
          33033333333333333F7F3333333333333000333333333333F777333333333333
          000333333333333F777333333333333000333333333333F77733333333333300
          033333333FFF3F777333333700073B703333333F7773F77733333307777700B3
          33333377333777733333307F8F8F7033333337F333F337F3333377F8F9F8F773
          3333373337F3373F3333078F898F870333337F33F7FFF37F333307F99999F703
          33337F377777337F3333078F898F8703333373F337F33373333377F8F9F8F773
          333337F3373337F33333307F8F8F70333333373FF333F7333333330777770333
          333333773FF77333333333370007333333333333777333333333}
        NumGlyphs = 2
        OnClick = ViewAnotherParcelButtonClick
      end
      object PrintParcelSpeedButton: TSpeedButton
        Left = 25
        Top = 7
        Width = 23
        Height = 22
        Hint = 'Print the comparable parcels for this parcel.'
        Flat = True
        Glyph.Data = {
          76010000424D7601000000000000760000002800000020000000100000000100
          04000000000000010000130B0000130B00001000000000000000000000000000
          800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00300000000000
          00033FFFFFFFFFFFFFFF0888888888888880777777777777777F088888888888
          8880777777777777777F0000000000000000FFFFFFFFFFFFFFFF0F8F8F8F8F8F
          8F80777777777777777F08F8F8F8F8F8F9F0777777777777777F0F8F8F8F8F8F
          8F807777777777777F7F0000000000000000777777777777777F3330FFFFFFFF
          03333337F3FFFF3F7F333330F0000F0F03333337F77773737F333330FFFFFFFF
          03333337F3FF3FFF7F333330F00F000003333337F773777773333330FFFF0FF0
          33333337F3FF7F3733333330F08F0F0333333337F7737F7333333330FFFF0033
          33333337FFFF7733333333300000033333333337777773333333}
        NumGlyphs = 2
        OnClick = PrintButtonClick
      end
    end
    object GroupBox2: TGroupBox
      Left = 4
      Top = -2
      Width = 101
      Height = 32
      TabOrder = 1
      object SalesAssessmentSpeedButton: TSpeedButton
        Left = 62
        Top = 8
        Width = 37
        Height = 22
        GroupIndex = 1
        Down = True
        Caption = 'Sales'
        Flat = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        OnClick = SalesAssessmentSpeedButtonClick
      end
      object AssessmentCompsSpeedButton: TSpeedButton
        Left = 1
        Top = 6
        Width = 61
        Height = 22
        Hint = 'Click this for assessment comparables for the current parcel.'
        GroupIndex = 1
        Caption = 'Assessed'
        Flat = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        OnClick = AssessmentCompsSpeedButtonClick
      end
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 35
    Width = 633
    Height = 376
    Align = alClient
    BevelInner = bvLowered
    BorderWidth = 4
    TabOrder = 1
    object Label1: TLabel
      Left = 26
      Top = 20
      Width = 426
      Height = 40
      AutoSize = False
      Caption = 
        'Click on the locate button above to view comparable parcels.  (T' +
        'he magnifying glass with the plus sign).'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      WordWrap = True
    end
    object CompNotebook: TTabbedNotebook
      Left = 6
      Top = 6
      Width = 621
      Height = 364
      Align = alClient
      TabsPerRow = 6
      TabFont.Charset = DEFAULT_CHARSET
      TabFont.Color = clBtnText
      TabFont.Height = -11
      TabFont.Name = 'MS Sans Serif'
      TabFont.Style = []
      TabOrder = 0
      OnChange = CompNotebookChange
      object TTabPage
        Left = 4
        Top = 24
        Caption = 'Template'
        object TotalAvDBText: TDBText
          Left = 319
          Top = 18
          Width = 110
          Height = 17
          DataField = 'TotalAssessedVal'
          DataSource = AssessmentDataSource
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object LandAvDBText: TDBText
          Left = 320
          Top = 1
          Width = 110
          Height = 17
          DataField = 'LandAssessedVal'
          DataSource = AssessmentDataSource
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label2: TLabel
          Left = 468
          Top = 35
          Width = 39
          Height = 14
          Caption = 'Depth -'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label3: TLabel
          Left = 468
          Top = 19
          Width = 56
          Height = 14
          Caption = 'Frontage -'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label4: TLabel
          Left = 468
          Top = 2
          Width = 53
          Height = 14
          Caption = 'Acreage -'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label5: TLabel
          Left = 241
          Top = 19
          Width = 53
          Height = 14
          Caption = 'Total AV -'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label6: TLabel
          Left = 241
          Top = 2
          Width = 53
          Height = 14
          Caption = 'Land AV -'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label7: TLabel
          Left = 9
          Top = 36
          Width = 88
          Height = 14
          Caption = 'Res/Com Sites -'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object ResSiteCntLabel: TLabel
          Left = 102
          Top = 36
          Width = 6
          Height = 14
          Caption = '0'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object CommercialSiteCntLabel: TLabel
          Left = 130
          Top = 36
          Width = 6
          Height = 14
          Caption = '0'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label10: TLabel
          Left = 120
          Top = 36
          Width = 3
          Height = 14
          Caption = '/'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label8: TLabel
          Left = 2
          Top = 50
          Width = 601
          Height = 14
          Caption = 
            '= = = = = = = = = = = = = = = = = = = = = = = = = = Residential ' +
            'Site 1 = = = = = = = = = = = = = = = = = = = = = = = = = = = = =' +
            ' = '
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clPurple
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label9: TLabel
          Left = 380
          Top = 61
          Width = 163
          Height = 16
          Caption = 'Residence Characteristics'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label11: TLabel
          Left = 62
          Top = 61
          Width = 122
          Height = 16
          Caption = 'Site Characteristics'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label12: TLabel
          Left = 321
          Top = 167
          Width = 50
          Height = 13
          Caption = 'Sq Ft Area'
        end
        object Label13: TLabel
          Left = 321
          Top = 114
          Width = 29
          Height = 13
          Caption = 'Grade'
        end
        object Label14: TLabel
          Left = 321
          Top = 88
          Width = 42
          Height = 13
          Caption = 'Conditon'
        end
        object Label15: TLabel
          Left = 8
          Top = 242
          Width = 29
          Height = 13
          Caption = 'Water'
        end
        object Label16: TLabel
          Left = 8
          Top = 211
          Width = 30
          Height = 13
          Caption = 'Sewer'
        end
        object Label17: TLabel
          Left = 8
          Top = 180
          Width = 33
          Height = 13
          Caption = 'Zoning'
        end
        object Label18: TLabel
          Left = 8
          Top = 273
          Width = 45
          Height = 13
          Caption = 'Year Built'
        end
        object Label19: TLabel
          Left = 8
          Top = 149
          Width = 47
          Height = 13
          Caption = 'Bldg Style'
        end
        object Label20: TLabel
          Left = 8
          Top = 118
          Width = 46
          Height = 13
          Caption = 'Neighbhd'
        end
        object Label21: TLabel
          Left = 8
          Top = 87
          Width = 39
          Height = 13
          Caption = 'Prop Cls'
        end
        object Label23: TLabel
          Left = 321
          Top = 272
          Width = 37
          Height = 13
          Caption = '# Baths'
        end
        object Label24: TLabel
          Left = 321
          Top = 246
          Width = 57
          Height = 13
          Caption = '# Bedrooms'
        end
        object Label25: TLabel
          Left = 321
          Top = 219
          Width = 42
          Height = 13
          Caption = '# Stories'
        end
        object Label26: TLabel
          Left = 321
          Top = 193
          Width = 53
          Height = 13
          Caption = '1st Flr Area'
        end
        object Label27: TLabel
          Left = 321
          Top = 141
          Width = 50
          Height = 13
          Caption = 'Bsmt Type'
        end
        object DepthDisplayLabel: TLabel
          Left = 543
          Top = 35
          Width = 6
          Height = 14
          Caption = '0'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object FrontageDisplayLabel: TLabel
          Left = 543
          Top = 19
          Width = 6
          Height = 14
          Caption = '0'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object AcreDisplayLabel: TLabel
          Left = 543
          Top = 2
          Width = 6
          Height = 14
          Caption = '0'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object TemplateLAddrLabel: TLabel
          Left = 8
          Top = 19
          Width = 116
          Height = 14
          Caption = 'TemplateLAddrLabel'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object TemplateNameLabel: TLabel
          Left = 8
          Top = 2
          Width = 113
          Height = 14
          Caption = 'TemplateNameLabel'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object SalePriceLabel: TLabel
          Left = 241
          Top = 36
          Width = 61
          Height = 14
          Caption = 'Sale Price -'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object PropertyClassText: TDBText
          Left = 129
          Top = 83
          Width = 163
          Height = 25
          DataField = 'Description'
          DataSource = PropertyClassDataSource
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          WordWrap = True
        end
        object NeighborhoodText: TDBText
          Left = 129
          Top = 114
          Width = 163
          Height = 25
          DataField = 'Description'
          DataSource = NeighborhoodDataSource
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          WordWrap = True
        end
        object BuildingStyleText: TDBText
          Left = 129
          Top = 145
          Width = 163
          Height = 25
          DataField = 'Description'
          DataSource = BuildingStyleDataSource
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          WordWrap = True
        end
        object ZoningText: TDBText
          Left = 129
          Top = 176
          Width = 163
          Height = 25
          DataField = 'Description'
          DataSource = ZoningDataSource
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          WordWrap = True
        end
        object SewerText: TDBText
          Left = 129
          Top = 206
          Width = 163
          Height = 25
          DataField = 'Description'
          DataSource = SewerDataSource
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          WordWrap = True
        end
        object WaterText: TDBText
          Left = 129
          Top = 237
          Width = 163
          Height = 25
          DataField = 'Description'
          DataSource = WaterDataSource
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          WordWrap = True
        end
        object ConditionText: TDBText
          Left = 457
          Top = 84
          Width = 143
          Height = 25
          DataField = 'Description'
          DataSource = ConditionDataSource
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          WordWrap = True
        end
        object GradeText: TDBText
          Left = 457
          Top = 110
          Width = 143
          Height = 25
          DataField = 'Description'
          DataSource = GradeDataSource
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          WordWrap = True
        end
        object BasementTypeText: TDBText
          Left = 457
          Top = 136
          Width = 143
          Height = 25
          DataField = 'Description'
          DataSource = BasementDataSource
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          WordWrap = True
        end
        object BasementTypeLookup: TwwDBLookupCombo
          Tag = 90
          Left = 399
          Top = 138
          Width = 51
          Height = 24
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          DropDownAlignment = taLeftJustify
          Selected.Strings = (
            'MainCode'#9'2'#9'MainCode'
            'Description'#9'30'#9'Description')
          LookupTable = BasementTable
          LookupField = 'MainCode'
          Options = [loColLines, loRowLines]
          Style = csDropDownList
          ParentFont = False
          TabOrder = 8
          AutoDropDown = True
          ShowButton = True
          AllowClearKey = False
        end
        object GradeLookup: TwwDBLookupCombo
          Tag = 80
          Left = 399
          Top = 111
          Width = 51
          Height = 24
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          DropDownAlignment = taLeftJustify
          Selected.Strings = (
            'MainCode'#9'2'#9'MainCode'
            'Description'#9'30'#9'Description')
          LookupTable = GradeTable
          LookupField = 'MainCode'
          Options = [loColLines, loRowLines]
          Style = csDropDownList
          ParentFont = False
          TabOrder = 7
          AutoDropDown = True
          ShowButton = True
          AllowClearKey = False
        end
        object ConditionLookup: TwwDBLookupCombo
          Tag = 70
          Left = 399
          Top = 85
          Width = 51
          Height = 24
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          DropDownAlignment = taLeftJustify
          Selected.Strings = (
            'MainCode'#9'2'#9'MainCode'
            'Description'#9'30'#9'Description')
          LookupTable = ConditionTable
          LookupField = 'MainCode'
          Options = [loColLines, loRowLines]
          Style = csDropDownList
          ParentFont = False
          TabOrder = 6
          AutoDropDown = True
          ShowButton = True
          AllowClearKey = False
        end
        object WaterLookup: TwwDBLookupCombo
          Tag = 60
          Left = 71
          Top = 238
          Width = 51
          Height = 24
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          DropDownAlignment = taLeftJustify
          Selected.Strings = (
            'MainCode'#9'2'#9'MainCode'
            'Description'#9'30'#9'Description')
          LookupTable = WaterTable
          LookupField = 'MainCode'
          Options = [loColLines, loRowLines]
          Style = csDropDownList
          ParentFont = False
          TabOrder = 5
          AutoDropDown = True
          ShowButton = True
          AllowClearKey = False
        end
        object SewerLookup: TwwDBLookupCombo
          Tag = 50
          Left = 71
          Top = 207
          Width = 51
          Height = 24
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          DropDownAlignment = taLeftJustify
          Selected.Strings = (
            'MainCode'#9'2'#9'MainCode'
            'Description'#9'30'#9'Description')
          LookupTable = SewerTable
          LookupField = 'MainCode'
          Options = [loColLines, loRowLines]
          Style = csDropDownList
          ParentFont = False
          TabOrder = 4
          AutoDropDown = True
          ShowButton = True
          AllowClearKey = False
        end
        object ZoningLookup: TwwDBLookupCombo
          Tag = 40
          Left = 71
          Top = 177
          Width = 51
          Height = 24
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          DropDownAlignment = taLeftJustify
          Selected.Strings = (
            'MainCode'#9'5'#9'MainCode'
            'Description'#9'30'#9'Description')
          LookupTable = ZoningTable
          LookupField = 'MainCode'
          Options = [loColLines, loRowLines]
          Style = csDropDownList
          ParentFont = False
          TabOrder = 3
          AutoDropDown = True
          ShowButton = True
          AllowClearKey = False
        end
        object BuildingStyleLookup: TwwDBLookupCombo
          Tag = 30
          Left = 71
          Top = 146
          Width = 51
          Height = 24
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          DropDownAlignment = taLeftJustify
          Selected.Strings = (
            'MainCode'#9'2'#9'MainCode'
            'Description'#9'30'#9'Description')
          LookupTable = BuildingStyleTable
          LookupField = 'MainCode'
          Options = [loColLines, loRowLines]
          Style = csDropDownList
          ParentFont = False
          TabOrder = 2
          AutoDropDown = True
          ShowButton = True
          AllowClearKey = False
        end
        object NeighborhoodLookup: TwwDBLookupCombo
          Tag = 20
          Left = 71
          Top = 115
          Width = 51
          Height = 24
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          DropDownAlignment = taLeftJustify
          Selected.Strings = (
            'MainCode'#9'5'#9'MainCode'
            'Description'#9'30'#9'Description')
          LookupTable = NeighborhoodTable
          LookupField = 'MainCode'
          Options = [loColLines, loRowLines]
          Style = csDropDownList
          ParentFont = False
          TabOrder = 1
          AutoDropDown = True
          ShowButton = True
          AllowClearKey = False
        end
        object PropertyClassLookup: TwwDBLookupCombo
          Tag = 10
          Left = 72
          Top = 85
          Width = 51
          Height = 24
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          DropDownAlignment = taLeftJustify
          Selected.Strings = (
            'MainCode'#9'3'#9'MainCode'
            'Description'#9'30'#9'Description')
          LookupTable = PropertyClassTable
          LookupField = 'MainCode'
          Options = [loColLines, loRowLines]
          Style = csDropDownList
          ParentFont = False
          TabOrder = 0
          AutoDropDown = True
          ShowButton = True
          AllowClearKey = False
        end
        object ApplyNewCharactersticsButton: TBitBtn
          Left = 477
          Top = 299
          Width = 127
          Height = 33
          Caption = 'Apply Characteristics'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 9
          OnClick = ApplyNewCharactersticsButtonClick
        end
        object NumberOfBedroomsEdit: TEdit
          Left = 399
          Top = 243
          Width = 63
          Height = 24
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 10
        end
        object YearBuiltEdit: TEdit
          Left = 71
          Top = 270
          Width = 63
          Height = 24
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 11
        end
        object SquareFootAreaEdit: TEdit
          Left = 399
          Top = 164
          Width = 63
          Height = 24
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 12
        end
        object FirstFloorAreaEdit: TEdit
          Left = 399
          Top = 190
          Width = 63
          Height = 24
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 13
        end
        object NumberOfStoriesEdit: TEdit
          Left = 399
          Top = 216
          Width = 63
          Height = 24
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 14
        end
        object NumberOfBathsEdit: TEdit
          Left = 399
          Top = 269
          Width = 63
          Height = 24
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 15
        end
      end
      object TTabPage
        Left = 4
        Top = 24
        Caption = 'Groups'
        object Label29: TLabel
          Left = 11
          Top = 41
          Width = 47
          Height = 13
          Caption = 'Bldg Style'
        end
        object Label30: TLabel
          Left = 11
          Top = 22
          Width = 46
          Height = 13
          Caption = 'Neighbhd'
        end
        object Label31: TLabel
          Left = 11
          Top = 3
          Width = 39
          Height = 13
          Caption = 'Prop Cls'
        end
        object Pg2BldgStyleLabel: TLabel
          Left = 99
          Top = 41
          Width = 65
          Height = 16
          Caption = 'Bldg Style'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Pg2NeighborHoodLabel: TLabel
          Left = 99
          Top = 22
          Width = 61
          Height = 16
          Caption = 'Neighbhd'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Pg2PropClassLabel: TLabel
          Left = 99
          Top = 3
          Width = 53
          Height = 16
          Caption = 'Prop Cls'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label36: TLabel
          Left = 11
          Top = 79
          Width = 54
          Height = 13
          Caption = 'Total Value'
        end
        object Label37: TLabel
          Left = 11
          Top = 60
          Width = 54
          Height = 13
          Caption = 'Land Value'
        end
        object Pg2TAVLabel: TLabel
          Left = 99
          Top = 79
          Width = 65
          Height = 16
          Caption = 'Bldg Style'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Pg2LAVLabel: TLabel
          Left = 99
          Top = 60
          Width = 61
          Height = 16
          Caption = 'Neighbhd'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label38: TLabel
          Left = 147
          Top = 98
          Width = 314
          Height = 16
          Caption = '===== Template Property Group Summary ====='
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clMaroon
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Pg1MinLblLbl: TLabel
          Left = 304
          Top = 22
          Width = 72
          Height = 13
          Caption = 'Minimum Assmt'
        end
        object Label40: TLabel
          Left = 304
          Top = 3
          Width = 61
          Height = 13
          Caption = 'Result Count'
        end
        object Pg1MaxDataLbl: TLabel
          Left = 448
          Top = 41
          Width = 121
          Height = 16
          Caption = 'Pg1MaxAssDataLbl'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Pg1MinDataLbl: TLabel
          Left = 448
          Top = 22
          Width = 117
          Height = 16
          Caption = 'Pg1MinAssDataLbl'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Pg1ParcelCntLabel: TLabel
          Left = 448
          Top = 3
          Width = 36
          Height = 16
          Caption = 'Label'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Pg1MaxLblLbl: TLabel
          Left = 304
          Top = 41
          Width = 75
          Height = 13
          Caption = 'Maximum Assmt'
        end
        object GroupStringGrid: TStringGrid
          Left = 4
          Top = 140
          Width = 603
          Height = 154
          ColCount = 9
          RowCount = 6
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing, goTabs]
          ParentFont = False
          ScrollBars = ssVertical
          TabOrder = 0
          OnSelectCell = GroupStringGridSelectCell
        end
      end
      object TTabPage
        Left = 4
        Top = 24
        Caption = 'Min-Max'
        object Label45: TLabel
          Left = 13
          Top = 22
          Width = 48
          Height = 14
          Caption = 'Bldg Style'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label46: TLabel
          Left = 155
          Top = 5
          Width = 45
          Height = 14
          Caption = 'Neighbhd'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label47: TLabel
          Left = 13
          Top = 5
          Width = 40
          Height = 14
          Caption = 'Prop Cls'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Pg3BldgStyleLabel: TLabel
          Left = 77
          Top = 22
          Width = 54
          Height = 14
          Caption = 'Bldg Style'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Pg3NeighborhoodLabel: TLabel
          Left = 220
          Top = 5
          Width = 52
          Height = 14
          Caption = 'Neighbhd'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Pg3PropClassLabel: TLabel
          Left = 77
          Top = 5
          Width = 47
          Height = 14
          Caption = 'Prop Cls'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label51: TLabel
          Left = 13
          Top = 57
          Width = 54
          Height = 14
          Caption = 'Total Value'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label52: TLabel
          Left = 13
          Top = 40
          Width = 55
          Height = 14
          Caption = 'Land Value'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Pg3TavLabel: TLabel
          Left = 77
          Top = 57
          Width = 37
          Height = 14
          Caption = 'Tot AV'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Pg3LavLabel: TLabel
          Left = 77
          Top = 40
          Width = 46
          Height = 14
          Caption = 'Land AV'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label55: TLabel
          Left = 293
          Top = 2
          Width = 262
          Height = 14
          Caption = '===== Template Property Group Summary ====='
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clMaroon
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Pg2MinLblLbl: TLabel
          Left = 377
          Top = 18
          Width = 74
          Height = 14
          Caption = 'Minimum Assmt'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Pg3Lbl1: TLabel
          Left = 292
          Top = 19
          Width = 61
          Height = 14
          Caption = 'Result Count'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Pg2MaxAssLabel: TLabel
          Left = 500
          Top = 36
          Width = 104
          Height = 14
          Caption = 'Pg2MaxAssDataLbl'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object P2MinAssLabel: TLabel
          Left = 378
          Top = 35
          Width = 102
          Height = 14
          Caption = 'Pg2MinAssDataLbl'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Pg2ParcelCntLabel: TLabel
          Left = 308
          Top = 36
          Width = 30
          Height = 14
          Caption = 'Label'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Pg2MaxLblLbl: TLabel
          Left = 495
          Top = 20
          Width = 78
          Height = 14
          Caption = 'Maximum Assmt'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label42: TLabel
          Left = 5
          Top = 135
          Width = 33
          Height = 16
          Caption = 'Cond'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label43: TLabel
          Left = 5
          Top = 270
          Width = 35
          Height = 16
          Caption = 'Acres'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label48: TLabel
          Left = 5
          Top = 242
          Width = 55
          Height = 16
          Caption = '1st St SF'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label49: TLabel
          Left = 5
          Top = 215
          Width = 54
          Height = 16
          Caption = 'Sq Ft LA'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label50: TLabel
          Left = 5
          Top = 188
          Width = 46
          Height = 16
          Caption = 'Yr Built'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label53: TLabel
          Left = 311
          Top = 270
          Width = 51
          Height = 16
          Caption = 'N Coord'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label54: TLabel
          Left = 311
          Top = 243
          Width = 50
          Height = 16
          Caption = 'E Coord'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label56: TLabel
          Left = 5
          Top = 161
          Width = 39
          Height = 16
          Caption = 'Grade'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label57: TLabel
          Left = 311
          Top = 135
          Width = 46
          Height = 16
          Caption = '# Baths'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label58: TLabel
          Left = 311
          Top = 162
          Width = 51
          Height = 16
          Caption = '# Bdrms'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label59: TLabel
          Left = 311
          Top = 189
          Width = 44
          Height = 16
          Caption = 'Stories'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label60: TLabel
          Left = 311
          Top = 216
          Width = 55
          Height = 16
          Caption = '# Fireplc'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label61: TLabel
          Left = 538
          Top = 108
          Width = 60
          Height = 16
          Caption = 'Template'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clPurple
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label62: TLabel
          Left = 456
          Top = 108
          Width = 63
          Height = 16
          Caption = 'Maximum'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clMaroon
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label63: TLabel
          Left = 379
          Top = 108
          Width = 59
          Height = 16
          Caption = 'Minimum'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clMaroon
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label64: TLabel
          Left = 231
          Top = 82
          Width = 60
          Height = 16
          Caption = 'Template'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clPurple
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label65: TLabel
          Left = 147
          Top = 82
          Width = 63
          Height = 16
          Caption = 'Maximum'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clMaroon
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label66: TLabel
          Left = 68
          Top = 82
          Width = 59
          Height = 16
          Caption = 'Minimum'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clMaroon
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label22: TLabel
          Left = 5
          Top = 108
          Width = 52
          Height = 16
          Caption = 'Sale Dts'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object GradeMin: TEdit
          Left = 65
          Top = 158
          Width = 70
          Height = 24
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clMaroon
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 3
          Text = 'GradeMin'
        end
        object AcresMin: TEdit
          Left = 65
          Top = 266
          Width = 70
          Height = 24
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clMaroon
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 15
          Text = 'AcresMin'
        end
        object FFSqFtMin: TEdit
          Left = 65
          Top = 239
          Width = 70
          Height = 24
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clMaroon
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 12
          Text = 'FFSqFtMin'
        end
        object SqFtMin: TEdit
          Left = 65
          Top = 212
          Width = 70
          Height = 24
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clMaroon
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 9
          Text = 'SqFtMin'
        end
        object YearBuiltMin: TEdit
          Left = 65
          Top = 185
          Width = 70
          Height = 24
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clMaroon
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 6
          Text = 'YearBuiltMin'
        end
        object CondMin: TEdit
          Left = 65
          Top = 131
          Width = 70
          Height = 24
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clMaroon
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
          Text = 'CondMin'
        end
        object GradeMax: TEdit
          Left = 145
          Top = 158
          Width = 70
          Height = 24
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clMaroon
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 4
          Text = 'GradeMax'
        end
        object AcresMax: TEdit
          Left = 145
          Top = 266
          Width = 70
          Height = 24
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clMaroon
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 16
          Text = 'AcresMax'
        end
        object FFSqFtMax: TEdit
          Left = 145
          Top = 239
          Width = 70
          Height = 24
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clMaroon
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 13
          Text = 'FFSqFtMax'
        end
        object SqFtMax: TEdit
          Left = 145
          Top = 212
          Width = 70
          Height = 24
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clMaroon
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 10
          Text = 'SqFtMax'
        end
        object YearBuiltMax: TEdit
          Left = 145
          Top = 185
          Width = 70
          Height = 24
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clMaroon
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 7
          Text = 'YearBuiltMax'
        end
        object CondMax: TEdit
          Left = 145
          Top = 131
          Width = 70
          Height = 24
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clMaroon
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 1
          Text = 'CondMax'
        end
        object GradeTmpl: TEdit
          Left = 224
          Top = 158
          Width = 70
          Height = 24
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 5
          Text = 'GradeTmpl'
        end
        object AcresTmpl: TEdit
          Left = 224
          Top = 266
          Width = 70
          Height = 24
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 17
          Text = 'AcresTmpl'
        end
        object FFSqFtTmpl: TEdit
          Left = 224
          Top = 239
          Width = 70
          Height = 24
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 14
          Text = 'FFSqFtTmpl'
        end
        object YearBuiltTmpl: TEdit
          Left = 224
          Top = 185
          Width = 70
          Height = 24
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 8
          Text = 'YearBuiltTmpl'
        end
        object CondTmpl: TEdit
          Left = 224
          Top = 131
          Width = 70
          Height = 24
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 2
          Text = 'CondTmpl'
        end
        object BedRoomsMin: TEdit
          Left = 375
          Top = 158
          Width = 70
          Height = 24
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clMaroon
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 21
          Text = 'BedRoomsMin'
        end
        object CrdNorthMin: TEdit
          Left = 375
          Top = 266
          Width = 70
          Height = 24
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clMaroon
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 33
          Text = 'CrdNorthMin'
        end
        object CrdEastMin: TEdit
          Left = 375
          Top = 239
          Width = 70
          Height = 24
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clMaroon
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 30
          Text = 'CrdEastMin'
        end
        object FirePlacesMin: TEdit
          Left = 375
          Top = 212
          Width = 70
          Height = 24
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clMaroon
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 27
          Text = 'FirePlacesMin'
        end
        object StoriesMin: TEdit
          Left = 375
          Top = 185
          Width = 70
          Height = 24
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clMaroon
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 24
          Text = 'StoriesMin'
        end
        object BathsMin: TEdit
          Left = 375
          Top = 131
          Width = 70
          Height = 24
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clMaroon
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 18
          Text = 'BathsMin'
        end
        object BedRoomsMax: TEdit
          Left = 452
          Top = 158
          Width = 70
          Height = 24
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clMaroon
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 22
          Text = 'BedRoomsMax'
        end
        object CrdNorthMax: TEdit
          Left = 452
          Top = 266
          Width = 70
          Height = 24
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clMaroon
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 34
          Text = 'CrdNorthMax'
        end
        object CrdEastMax: TEdit
          Left = 452
          Top = 239
          Width = 70
          Height = 24
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clMaroon
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 31
          Text = 'CrdEastMax'
        end
        object FirePlacesMax: TEdit
          Left = 452
          Top = 212
          Width = 70
          Height = 24
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clMaroon
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 28
          Text = 'FirePlacesMax'
        end
        object StoriesMax: TEdit
          Left = 452
          Top = 185
          Width = 70
          Height = 24
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clMaroon
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 25
          Text = 'StoriesMax'
        end
        object BathsMax: TEdit
          Left = 452
          Top = 131
          Width = 70
          Height = 24
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clMaroon
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 19
          Text = 'BathsMax'
        end
        object BedRoomsTmpl: TEdit
          Left = 529
          Top = 158
          Width = 70
          Height = 24
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 23
          Text = 'BedRoomsTmpl'
        end
        object CrdNorthTmpl: TEdit
          Left = 529
          Top = 266
          Width = 70
          Height = 24
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 35
          Text = 'CrdNorthTmpl'
        end
        object CrdEastTmpl: TEdit
          Left = 529
          Top = 239
          Width = 70
          Height = 24
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 32
          Text = 'CrdEastTmpl'
        end
        object FirePlacesTmpl: TEdit
          Left = 529
          Top = 212
          Width = 70
          Height = 24
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 29
          Text = 'FirePlacesTmpl'
        end
        object StoriesTmpl: TEdit
          Left = 529
          Top = 185
          Width = 70
          Height = 24
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 26
          Text = 'StoriesTmpl'
        end
        object BathsTmpl: TEdit
          Left = 529
          Top = 131
          Width = 70
          Height = 24
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 20
          Text = 'BathsTmpl'
        end
        object SqFtTmpl: TEdit
          Left = 224
          Top = 212
          Width = 70
          Height = 24
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 11
          Text = 'SqFtTmpl'
        end
        object ApplyMinMaxButton: TButton
          Left = 478
          Top = 60
          Width = 115
          Height = 32
          Caption = 'Apply Min/Max'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 36
          OnClick = ApplyMinMaxButtonClick
        end
        object RestoreMinMaxButton: TButton
          Left = 347
          Top = 61
          Width = 115
          Height = 32
          Caption = 'Restore Min/Max'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 37
          OnClick = RestoreMinMaxButtonClick
        end
        object SaleDateMin: TEdit
          Left = 65
          Top = 104
          Width = 70
          Height = 24
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clMaroon
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 38
          Text = 'SaleDateMin'
        end
        object SaleDateMax: TEdit
          Left = 145
          Top = 104
          Width = 70
          Height = 24
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clMaroon
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 39
          Text = 'SaleDateMax'
        end
      end
      object TTabPage
        Left = 4
        Top = 24
        Caption = 'Group Members'
        object GroupMemberStringGrid: TStringGrid
          Left = 0
          Top = 0
          Width = 613
          Height = 336
          Align = alClient
          ColCount = 33
          DefaultColWidth = 54
          DefaultRowHeight = 20
          DefaultDrawing = False
          RowCount = 15
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
          OnDrawCell = GroupMemberStringGridDrawCell
          ColWidths = (
            54
            54
            54
            54
            54
            54
            54
            54
            54
            54
            54
            54
            54
            54
            54
            54
            54
            54
            54
            54
            54
            54
            54
            54
            54
            54
            54
            54
            54
            54
            54
            54
            54)
          RowHeights = (
            20
            20
            14
            20
            20
            20
            20
            20
            20
            20
            20
            20
            20
            20
            20)
        end
      end
      object TTabPage
        Left = 4
        Top = 24
        Caption = 'Weights'
        object Label69: TLabel
          Left = 5
          Top = 6
          Width = 592
          Height = 42
          Caption = 
            'The fields on this screen can be altered to weight the various c' +
            'haracteristics of each parcel in a parcel grouping. Fewer points' +
            ' are assigned to a comparative parcel in the grouping if it more' +
            ' closely matches the characteristics of the template parcel. '
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          WordWrap = True
        end
        object Label70: TLabel
          Left = 5
          Top = 48
          Width = 607
          Height = 42
          Caption = 
            #39'Matching'#39'  or '#39'Yes/No'#39' items cause a weighting value to be assi' +
            'gned to a parcel if the characterisitic does NOT match the templ' +
            'ate parcel.  Scaling values are assigned by multiplying the abso' +
            'lute value of the difference between the template and '
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          WordWrap = True
        end
        object Label71: TLabel
          Left = 153
          Top = 76
          Width = 240
          Height = 14
          Caption = 'the comparative parcel by the scaling value.'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          WordWrap = True
        end
        object Label72: TLabel
          Left = 320
          Top = 232
          Width = 35
          Height = 16
          Caption = 'Acres'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label73: TLabel
          Left = 320
          Top = 209
          Width = 46
          Height = 16
          Caption = '# Baths'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label74: TLabel
          Left = 320
          Top = 186
          Width = 75
          Height = 16
          Caption = '# Bedrooms'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label75: TLabel
          Left = 320
          Top = 164
          Width = 55
          Height = 16
          Caption = '# Stories'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label76: TLabel
          Left = 320
          Top = 141
          Width = 46
          Height = 16
          Caption = 'Yr Built'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label77: TLabel
          Left = 16
          Top = 278
          Width = 68
          Height = 16
          Caption = 'Att Garage'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label78: TLabel
          Left = 16
          Top = 255
          Width = 65
          Height = 16
          Caption = 'Fire Place'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label79: TLabel
          Left = 16
          Top = 232
          Width = 61
          Height = 16
          Caption = 'Condition'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label80: TLabel
          Left = 16
          Top = 209
          Width = 39
          Height = 16
          Caption = 'Grade'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label81: TLabel
          Left = 16
          Top = 187
          Width = 65
          Height = 16
          Caption = 'Bldg Style'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label82: TLabel
          Left = 16
          Top = 164
          Width = 61
          Height = 16
          Caption = 'Neighbhd'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label83: TLabel
          Left = 16
          Top = 141
          Width = 53
          Height = 16
          Caption = 'Prop Cls'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label84: TLabel
          Left = 16
          Top = 118
          Width = 67
          Height = 16
          Caption = 'Swis Code'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label85: TLabel
          Left = 320
          Top = 118
          Width = 102
          Height = 16
          Caption = 'Living Ar (Sq Ft)'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label86: TLabel
          Left = 434
          Top = 90
          Width = 91
          Height = 16
          Caption = 'Scaled Values'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clRed
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label87: TLabel
          Left = 84
          Top = 90
          Width = 160
          Height = 16
          Caption = 'Matching (Yes/No) Values'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clRed
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object BathsDBEdit: TDBEdit
          Left = 429
          Top = 208
          Width = 121
          Height = 22
          DataField = 'NoBaths'
          DataSource = CompWeightingDataSource
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 12
        end
        object BedRoomsDBEdit: TDBEdit
          Left = 429
          Top = 185
          Width = 121
          Height = 22
          DataField = 'NoBedrooms'
          DataSource = CompWeightingDataSource
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 11
        end
        object StoriesDBEdit: TDBEdit
          Left = 429
          Top = 162
          Width = 121
          Height = 22
          DataField = 'NoStories'
          DataSource = CompWeightingDataSource
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 10
        end
        object YrBuiltDBEdit: TDBEdit
          Left = 429
          Top = 139
          Width = 121
          Height = 22
          DataField = 'YearBuilt'
          DataSource = CompWeightingDataSource
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 9
        end
        object SqFtDBEdit: TDBEdit
          Left = 429
          Top = 116
          Width = 121
          Height = 22
          DataField = 'SqFtLivingArea'
          DataSource = CompWeightingDataSource
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 8
        end
        object CondDBEdit: TDBEdit
          Left = 103
          Top = 231
          Width = 121
          Height = 22
          DataField = 'Condition'
          DataSource = CompWeightingDataSource
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 5
        end
        object GradeDBEdit: TDBEdit
          Left = 103
          Top = 208
          Width = 121
          Height = 22
          DataField = 'Grade'
          DataSource = CompWeightingDataSource
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 4
        end
        object BldgStyDBEdit: TDBEdit
          Left = 103
          Top = 184
          Width = 121
          Height = 22
          DataField = 'BuildingStyle'
          DataSource = CompWeightingDataSource
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 3
        end
        object NeighDbEdit: TDBEdit
          Left = 103
          Top = 161
          Width = 121
          Height = 22
          DataField = 'Neighborhood'
          DataSource = CompWeightingDataSource
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 2
        end
        object PropClsDBEdit: TDBEdit
          Left = 103
          Top = 138
          Width = 121
          Height = 22
          DataField = 'PropertyClass'
          DataSource = CompWeightingDataSource
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 1
        end
        object SwisDBEdit: TDBEdit
          Left = 103
          Top = 115
          Width = 121
          Height = 22
          DataField = 'SwisCode'
          DataSource = CompWeightingDataSource
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
        end
        object GarageDBEdit: TDBEdit
          Left = 103
          Top = 277
          Width = 121
          Height = 22
          DataField = 'AttachedGarage'
          DataSource = CompWeightingDataSource
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 7
        end
        object FirePlDBEdit: TDBEdit
          Left = 103
          Top = 254
          Width = 121
          Height = 22
          DataField = 'FirePlace'
          DataSource = CompWeightingDataSource
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 6
        end
        object AcreageDBEdit: TDBEdit
          Left = 429
          Top = 231
          Width = 121
          Height = 22
          DataField = 'Acres'
          DataSource = CompWeightingDataSource
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 13
        end
        object SaveWeightingsButton: TButton
          Left = 486
          Top = 299
          Width = 120
          Height = 32
          Caption = 'Save Weightings'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 14
          OnClick = SaveWeightingsButtonClick
        end
      end
      object TTabPage
        Left = 4
        Top = 24
        Caption = 'Results'
        object ResultsStringGrid: TStringGrid
          Left = 0
          Top = 0
          Width = 613
          Height = 336
          Align = alClient
          ColCount = 6
          DefaultColWidth = 93
          DefaultRowHeight = 16
          DefaultDrawing = False
          RowCount = 18
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
          OnDrawCell = ResultsStringGridDrawCell
          RowHeights = (
            16
            16
            16
            16
            16
            16
            16
            16
            16
            16
            16
            16
            16
            16
            16
            16
            16
            16)
        end
      end
    end
    object ComparablesTypeRadioGroup: TRadioGroup
      Left = 210
      Top = 118
      Width = 212
      Height = 105
      Caption = ' Choose the comprables type: '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      Items.Strings = (
        'Assessment Comparables'
        'Sales Comparables')
      ParentFont = False
      TabOrder = 1
      Visible = False
      OnClick = ComprablesTypeRadioGroupClick
    end
  end
  object CompWeightingDataSource: TwwDataSource
    DataSet = CompWeightingTable
    Left = 110
    Top = 365
  end
  object CompWeightingTable: TwwTable
    DatabaseName = 'PASsystem'
    TableName = 'CompWeightingFile'
    TableType = ttDBase
    ControlType.Strings = (
      'RangeOK;CheckBox;True;False')
    SyncSQLByRange = True
    NarrowSearch = False
    ValidateWithMask = True
    Left = 110
    Top = 376
  end
  object LocateTimer: TTimer
    Enabled = False
    Interval = 1
    OnTimer = LocateTimerTimer
    Left = 535
    Top = 244
  end
  object ParcelTable: TTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYTAXROLLYR_SWISSBLKEY'
    TableName = 'TParcelRec'
    TableType = ttDBase
    Left = 329
    Top = 295
  end
  object ParcelDataSource: TDataSource
    DataSet = ParcelTable
    Left = 390
    Top = 383
  end
  object AssessmentTable: TTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYTAXROLLYR_SWISSBLKEY'
    TableName = 'TPAssessRec'
    TableType = ttDBase
    Left = 553
    Top = 19
    object AssessmentTableTaxRollYr: TStringField
      FieldName = 'TaxRollYr'
      Size = 4
    end
    object AssessmentTableSwisSBLKey: TStringField
      FieldName = 'SwisSBLKey'
      Size = 26
    end
    object AssessmentTableAssessmentDate: TDateField
      FieldName = 'AssessmentDate'
    end
    object AssessmentTableLandAssessedVal: TIntegerField
      FieldName = 'LandAssessedVal'
    end
    object AssessmentTableTotalAssessedVal: TIntegerField
      FieldName = 'TotalAssessedVal'
    end
  end
  object ResSiteDataSource: TDataSource
    DataSet = ResSiteTable
    Left = 303
    Top = 283
  end
  object ResSiteTable: TTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYTAXROLLYR_SWISSBLKEY_SITE'
    TableName = 'TPResidentialSite'
    TableType = ttDBase
    Left = 314
    Top = 257
  end
  object AssessmentDataSource: TDataSource
    DataSet = AssessmentTable
    Left = 548
    Top = 6
  end
  object CommercialSiteTable: TTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYTAXROLLYR_SWISSBLKEY_SITE'
    TableName = 'TPCommercialSite'
    TableType = ttDBase
    Left = 582
    Top = 4
  end
  object CommercialSiteDataSource: TDataSource
    DataSet = CommercialSiteTable
    Left = 498
    Top = 13
  end
  object CompDataSearchTable: TTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYSWIS_NBHD_PC_BLDGSTYLE'
    TableName = 'CompAssmtDataFile'
    TableType = ttDBase
    Left = 42
    Top = 378
  end
  object AssessmentSearchTable: TTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYTAXROLLYR_SWISSBLKEY'
    TableName = 'TPAssessRec'
    TableType = ttDBase
    Left = 277
    Top = 384
  end
  object CompAssmtMinMaxTable: TTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYSWIS_NBHD_PC_STYLE'
    TableName = 'CompAssmtMinMaxFile'
    TableType = ttDBase
    Left = 386
    Top = 308
  end
  object MainTable: TwwTable
    DatabaseName = 'PASsystem'
    TableName = 'CompAssmtDataFile'
    TableType = ttDBase
    SyncSQLByRange = True
    NarrowSearch = False
    ValidateWithMask = True
    Left = 211
    Top = 376
  end
  object ParcelSearchTable: TTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYTAXROLLYR_SWISSBLKEY'
    TableName = 'TParcelRec'
    TableType = ttDBase
    Left = 249
    Top = 377
  end
  object CompSalesMinMaxTable: TTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYSWIS_NBHD_PC_STYLE'
    TableName = 'CompSalesMinMaxFile'
    TableType = ttDBase
    Left = 14
    Top = 372
  end
  object SwCodeTable: TTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYSWISCODE'
    TableName = 'tswistbl'
    TableType = ttDBase
    Left = 176
    Top = 375
  end
  object ReportFiler: TReportFiler
    StatusFormat = 'Printing page %p'
    UnitsFactor = 1
    Title = 'ReportPrinter Report'
    Orientation = poPortrait
    ScaleX = 100
    ScaleY = 100
    OnPrint = ReportPrint
    OnPrintHeader = ReportPrintHeader
    Left = 541
    Top = 269
  end
  object ReportPrinter: TReportPrinter
    StatusFormat = 'Printing page %p'
    UnitsFactor = 1
    Title = 'ReportPrinter Report'
    Orientation = poPortrait
    ScaleX = 100
    ScaleY = 100
    OnPrint = ReportPrint
    OnPrintHeader = ReportPrintHeader
    Left = 495
    Top = 280
  end
  object PrintDialog: TPrintDialog
    Options = [poPrintToFile]
    PrintToFile = True
    Left = 499
    Top = 251
  end
  object CompAssDataSearchTable: TTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYSWISCODE_SBLKEY_SITE'
    TableName = 'CompAssmtDataFile'
    TableType = ttDBase
    Left = 393
    Top = 332
  end
  object CompASSDataSearchDataSource: TDataSource
    DataSet = CompAssDataSearchTable
    Left = 374
    Top = 375
  end
  object PropertyClassTable: TwwTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYMAINCODE'
    TableName = 'ZPropClsTbl'
    TableType = ttDBase
    SyncSQLByRange = True
    NarrowSearch = False
    ValidateWithMask = True
    Left = 205
    Top = 146
  end
  object NeighborhoodTable: TwwTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYMAINCODE'
    TableName = 'ZInvNghbrhdCodeTbl'
    TableType = ttDBase
    SyncSQLByRange = True
    NarrowSearch = False
    ValidateWithMask = True
    Left = 209
    Top = 182
  end
  object BuildingStyleTable: TwwTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYMAINCODE'
    TableName = 'ZInvBuildStyleTbl'
    TableType = ttDBase
    SyncSQLByRange = True
    NarrowSearch = False
    ValidateWithMask = True
    Left = 201
    Top = 213
  end
  object ZoningTable: TwwTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYMAINCODE'
    TableName = 'ZInvZoningCodeTbl'
    TableType = ttDBase
    SyncSQLByRange = True
    NarrowSearch = False
    ValidateWithMask = True
    Left = 202
    Top = 239
  end
  object WaterTable: TwwTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYMAINCODE'
    TableName = 'ZInvWaterTbl'
    TableType = ttDBase
    SyncSQLByRange = True
    NarrowSearch = False
    ValidateWithMask = True
    Left = 202
    Top = 309
  end
  object ConditionTable: TwwTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYMAINCODE'
    TableName = 'ZInvConditionTbl'
    TableType = ttDBase
    SyncSQLByRange = True
    NarrowSearch = False
    ValidateWithMask = True
    Left = 527
    Top = 148
  end
  object GradeTable: TwwTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYMAINCODE'
    TableName = 'ZInvGradeTbl'
    TableType = ttDBase
    SyncSQLByRange = True
    NarrowSearch = False
    ValidateWithMask = True
    Left = 521
    Top = 176
  end
  object BasementTable: TwwTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYMAINCODE'
    TableName = 'ZInvResBasementTbl'
    TableType = ttDBase
    SyncSQLByRange = True
    NarrowSearch = False
    ValidateWithMask = True
    Left = 519
    Top = 211
  end
  object PropertyClassDataSource: TwwDataSource
    DataSet = PropertyClassTable
    Left = 239
    Top = 149
  end
  object NeighborhoodDataSource: TwwDataSource
    DataSet = NeighborhoodTable
    Left = 240
    Top = 184
  end
  object BuildingStyleDataSource: TwwDataSource
    DataSet = BuildingStyleTable
    Left = 230
    Top = 214
  end
  object ZoningDataSource: TwwDataSource
    DataSet = ZoningTable
    Left = 232
    Top = 244
  end
  object SewerDataSource: TwwDataSource
    DataSet = SewerTable
    Left = 230
    Top = 274
  end
  object WaterDataSource: TwwDataSource
    DataSet = WaterTable
    Left = 227
    Top = 310
  end
  object ConditionDataSource: TwwDataSource
    DataSet = ConditionTable
    Left = 556
    Top = 148
  end
  object GradeDataSource: TwwDataSource
    DataSet = GradeTable
    Left = 552
    Top = 179
  end
  object BasementDataSource: TwwDataSource
    DataSet = BasementTable
    Left = 547
    Top = 210
  end
  object CodeTable: TwwTable
    DatabaseName = 'PASsystem'
    TableType = ttDBase
    SyncSQLByRange = True
    NarrowSearch = False
    ValidateWithMask = True
    Left = 285
    Top = 283
  end
  object CompDataTable: TwwTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYSWISCODE_SBLKEY_SITE'
    ReadOnly = True
    TableName = 'CompAssmtDataFile'
    TableType = ttDBase
    SyncSQLByRange = True
    NarrowSearch = False
    ValidateWithMask = True
    Left = 146
    Top = 385
  end
  object CompDataDataSource: TwwDataSource
    DataSet = CompDataTable
    Left = 146
    Top = 362
  end
  object SewerTable: TwwTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYMAINCODE'
    TableName = 'ZInvSewerTbl'
    TableType = ttDBase
    SyncSQLByRange = True
    NarrowSearch = False
    ValidateWithMask = True
    Left = 206
    Top = 273
  end
  object SysRecTable: TTable
    DatabaseName = 'PASsystem'
    TableName = 'SystemRecord'
    TableType = ttDBase
    Left = 53
    Top = 164
  end
  object AssessmentYearControlTable: TTable
    DatabaseName = 'PASsystem'
    TableName = 'NAssmtYrCtlFile'
    TableType = ttDBase
    Left = 170
    Top = 198
  end
end
