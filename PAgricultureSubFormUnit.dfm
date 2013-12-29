object AgricultureSubform: TAgricultureSubform
  Left = 750
  Top = 271
  Width = 640
  Height = 572
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 13
  object AgriculturePageControl: TPageControl
    Left = 0
    Top = 94
    Width = 624
    Height = 440
    ActivePage = SoilsTabSheet
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
    object SoilsTabSheet: TTabSheet
      Caption = 'Soils'
      ImageIndex = 1
      object Panel5: TPanel
        Left = 0
        Top = 0
        Width = 616
        Height = 409
        Align = alClient
        TabOrder = 0
        object Panel6: TPanel
          Left = 1
          Top = 360
          Width = 614
          Height = 48
          Align = alBottom
          TabOrder = 0
          object btnNewSoil: TBitBtn
            Left = 3
            Top = 11
            Width = 114
            Height = 33
            Caption = '&New Soil'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TabOrder = 0
            OnClick = btnNewSoilClick
            Glyph.Data = {
              16020000424D160200000000000076000000280000001A0000001A0000000100
              040000000000A001000000000000000000001000000000000000000000000000
              BF0000BF000000BFBF00BF000000BF00BF00BFBF0000C0C0C000808080000000
              FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
              777777777777770A000477777777777777777777777777000000777777777777
              7777777777777700000077777788888888888888777777000000777777888888
              8888888877777700000077777444444444444488777777000000777774BFBFBF
              BFBFB488777777000000777774FBFBFBFBFBF488777777000000777774BFBFBF
              BFBFB488777777070707777774FBFBFBFBFBF488777777000000777774BFBFBF
              BFBFB488777777070707777774FBFBFBFBFBF488777777000000777774BFBFBF
              BFBFB488777777070707777774FBFBFBFBFBF488777777000000777774BFBFBF
              BFBFB488777777070707777774FBFBFBFBFBF488777777000000777774BFBFBF
              B444447777777707070777F77FFBFBFBF4FB4777777777000000777F7FBFBFBF
              B4B477777777770404047777FFFBFBFBF447777777777700000077FFFFFFF444
              44777777777777FFFBFF7777FFF7777777777777777777000000777F7F7F7777
              77777777777777FBFFFB77777F77F77777777777777777000000777777777777
              77777777777777FFFBFF77777777777777777777777777000000}
            Spacing = 2
          end
          object btnDeleteSoil: TBitBtn
            Left = 137
            Top = 11
            Width = 132
            Height = 33
            Caption = '&Remove Soil'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TabOrder = 1
            OnClick = btnDeleteSoilClick
            Glyph.Data = {
              16020000424D160200000000000076000000280000001A0000001A0000000100
              040000000000A001000000000000000000001000000000000000000000000000
              BF0000BF000000BFBF00BF000000BF00BF00BFBF0000C0C0C000808080000000
              FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
              7777777777777709400077777777777777777799977777000000777777777777
              77777999977777FFFF0079997788888888889999777777FFFF00799997888888
              88899998777777FFFF00779999444444444999887777770000007779999FBFBF
              BF999488777777000000777799999BFBF99994887777770000007777799999BF
              9999B488777777000000777774F99999999BF488777777000000777774BF9999
              99BFB488777777FFFF00777774FBF9999BFBF488777777FFFFC0777774BF9999
              99BFB488777777FFFF00777774F99999999BF488777777FFFF007777749999BF
              9999B488777777FFFF00777774999BFBF9999488777777FFFF0077777999BFBF
              B499999777777700FFFF77779999FBFBF4F9999977777700F9007779999FBFBF
              B4B479999777771E8000779999FBFBFBF4477799997777000000799994444444
              4477777999777700800079997777777777777777997777008000799777777777
              7777777777777700800077777777777777777777777777008000777777777777
              7777777777777700800077777777777777777777777777008000}
            Spacing = 2
          end
        end
        object gdAgricultureSoils: TwwDBGrid
          Left = 1
          Top = 1
          Width = 614
          Height = 359
          Selected.Strings = (
            'SoilGroupCode'#9'10'#9'Soil Code'#9'F'
            'AgAcreage'#9'10'#9'Acreage'#9'F'
            'AssessmentPerAcre'#9'10'#9'Assessment / Acre'#9'F'
            'Assessment'#9'10'#9'Assessment'#9'F')
          IniAttributes.Delimiter = ';;'
          TitleColor = clBtnFace
          FixedCols = 0
          ShowHorzScrollBar = True
          Align = alClient
          DataSource = dsAgricultureSoils
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgWordWrap]
          ParentFont = False
          TabOrder = 1
          TitleAlignment = taCenter
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clBlue
          TitleFont.Height = -13
          TitleFont.Name = 'Arial'
          TitleFont.Style = [fsBold]
          TitleLines = 2
          TitleButtons = False
          IndicatorColor = icBlack
        end
        object lcbxSoilRating: TwwDBLookupCombo
          Left = 407
          Top = 57
          Width = 121
          Height = 24
          DropDownAlignment = taLeftJustify
          DataField = 'MainCode'
          DataSource = dsSoilRatings
          TabOrder = 2
          AutoDropDown = False
          ShowButton = True
          AllowClearKey = False
        end
      end
    end
    object DetailsTabSheet: TTabSheet
      Caption = 'Calculation'
      ImageIndex = 1
      object Label4: TLabel
        Left = 162
        Top = 3
        Width = 31
        Height = 15
        Caption = 'Acres'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object Label5: TLabel
        Left = 8
        Top = 34
        Width = 110
        Height = 15
        Caption = 'Parcel Assessment:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object Label6: TLabel
        Left = 8
        Top = 62
        Width = 68
        Height = 15
        Caption = 'Homestead:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object Label7: TLabel
        Left = 8
        Top = 90
        Width = 95
        Height = 15
        Caption = 'Farrm Structures:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object Label8: TLabel
        Left = 8
        Top = 118
        Width = 92
        Height = 15
        Caption = 'Other Structures:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object Label9: TLabel
        Left = 8
        Top = 146
        Width = 84
        Height = 15
        Caption = 'Ineligible Land:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object Label10: TLabel
        Left = 8
        Top = 230
        Width = 62
        Height = 15
        Caption = 'Total Acres:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object Label11: TLabel
        Left = 8
        Top = 202
        Width = 82
        Height = 15
        Caption = 'Total Ineligible:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object Label12: TLabel
        Left = 8
        Top = 174
        Width = 119
        Height = 15
        Caption = 'Ineligible Woodlands:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object Label13: TLabel
        Left = 271
        Top = 3
        Width = 28
        Height = 15
        Caption = 'Land'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object Label14: TLabel
        Left = 353
        Top = 3
        Width = 79
        Height = 15
        Caption = 'Improvements'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object Label15: TLabel
        Left = 540
        Top = 3
        Width = 26
        Height = 15
        Caption = 'Total'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object Label16: TLabel
        Left = 357
        Top = 267
        Width = 144
        Height = 16
        Caption = 'Assessed Value Eligible:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object Label17: TLabel
        Left = 357
        Top = 294
        Width = 150
        Height = 16
        Caption = 'Assessed Support Struct:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object Label18: TLabel
        Left = 357
        Top = 320
        Width = 137
        Height = 16
        Caption = 'Total Agriculture Assmt:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object Label19: TLabel
        Left = 357
        Top = 347
        Width = 145
        Height = 16
        Caption = 'Total Agriculture Exempt:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object edLandValue: TEdit
        Left = 243
        Top = 28
        Width = 86
        Height = 24
        TabStop = False
        Color = clBtnFace
        TabOrder = 8
      end
      object edImprovementValue: TEdit
        Left = 349
        Top = 29
        Width = 86
        Height = 24
        TabStop = False
        Color = clBtnFace
        TabOrder = 9
      end
      object edTotalValue: TEdit
        Left = 510
        Top = 29
        Width = 86
        Height = 24
        TabStop = False
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 10
      end
      object edTotalHomesteadValue: TEdit
        Left = 510
        Top = 57
        Width = 86
        Height = 24
        TabStop = False
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 11
      end
      object edTotalFarmStructureValue: TEdit
        Left = 510
        Top = 85
        Width = 86
        Height = 24
        TabStop = False
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 12
      end
      object edTotalOtherStructureValue: TEdit
        Left = 510
        Top = 112
        Width = 86
        Height = 24
        TabStop = False
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 13
      end
      object edIneligibleWoodlandsAcreage: TEdit
        Left = 134
        Top = 168
        Width = 86
        Height = 24
        TabStop = False
        Color = clBtnFace
        TabOrder = 14
      end
      object edIneligibleWoodlandsLandValue: TEdit
        Left = 242
        Top = 169
        Width = 86
        Height = 24
        TabStop = False
        Color = clBtnFace
        TabOrder = 15
      end
      object edTotalIneligibleLandValue2: TEdit
        Left = 510
        Top = 141
        Width = 86
        Height = 24
        TabStop = False
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 16
      end
      object edTotalIneligibleAcreage: TEdit
        Left = 134
        Top = 197
        Width = 86
        Height = 24
        TabStop = False
        Color = clBtnFace
        TabOrder = 17
      end
      object edTotalIneligibleLandValue: TEdit
        Left = 242
        Top = 197
        Width = 86
        Height = 24
        TabStop = False
        Color = clBtnFace
        TabOrder = 18
      end
      object edTotalIneligibleImprovements: TEdit
        Left = 349
        Top = 197
        Width = 86
        Height = 24
        TabStop = False
        Color = clBtnFace
        TabOrder = 19
      end
      object edTotalIneligibleValue: TEdit
        Left = 510
        Top = 197
        Width = 86
        Height = 24
        TabStop = False
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 20
      end
      object edTotalAcres: TEdit
        Left = 134
        Top = 225
        Width = 86
        Height = 24
        TabStop = False
        Color = clBtnFace
        TabOrder = 21
      end
      object edAssessedValueEligible: TEdit
        Left = 510
        Top = 263
        Width = 86
        Height = 24
        TabStop = False
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 22
      end
      object edTotalAgricultureAssessment: TEdit
        Left = 510
        Top = 316
        Width = 86
        Height = 24
        TabStop = False
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 23
      end
      object edTotalAgricultureExemption: TEdit
        Left = 510
        Top = 343
        Width = 86
        Height = 24
        TabStop = False
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 24
      end
      object edTotalIneligibleWoodlands: TEdit
        Left = 510
        Top = 169
        Width = 86
        Height = 24
        TabStop = False
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 25
      end
      object edResidentialAcreage: TDBEdit
        Left = 134
        Top = 57
        Width = 86
        Height = 24
        DataField = 'ResidentialAcreage'
        DataSource = dsAgriculture
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        OnExit = AgValueEditExit
      end
      object edResidentialLand: TDBEdit
        Left = 243
        Top = 57
        Width = 86
        Height = 24
        DataField = 'Residentialland'
        DataSource = dsAgriculture
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 1
        OnExit = AgValueEditExit
      end
      object edResidentialBuilding: TDBEdit
        Left = 349
        Top = 57
        Width = 86
        Height = 24
        DataField = 'ResidentialBuilding'
        DataSource = dsAgriculture
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 2
        OnExit = AgValueEditExit
      end
      object edFarmStructureValue: TDBEdit
        Left = 349
        Top = 85
        Width = 86
        Height = 24
        DataField = 'FarmStructureValue'
        DataSource = dsAgriculture
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 3
        OnExit = AgValueEditExit
      end
      object edOtherStructureValue: TDBEdit
        Left = 349
        Top = 113
        Width = 86
        Height = 24
        DataField = 'OtherStructureValue'
        DataSource = dsAgriculture
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 4
        OnExit = AgValueEditExit
      end
      object edIneligibleAcreage: TDBEdit
        Left = 134
        Top = 141
        Width = 86
        Height = 24
        DataField = 'IneligibleAcreage'
        DataSource = dsAgriculture
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 5
        OnExit = AgValueEditExit
      end
      object edIneligibleLand: TDBEdit
        Left = 242
        Top = 141
        Width = 86
        Height = 24
        DataField = 'IneligibleLand'
        DataSource = dsAgriculture
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 6
        OnExit = AgValueEditExit
      end
      object edAssessedSupportStructure: TDBEdit
        Left = 510
        Top = 290
        Width = 86
        Height = 24
        DataField = 'SupportStructureAssessment'
        DataSource = dsAgriculture
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 7
        OnExit = AgValueEditExit
      end
      object btnUpdateExemption: TBitBtn
        Left = 495
        Top = 378
        Width = 116
        Height = 27
        Caption = 'Update Exmpt'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 26
        Kind = bkOK
      end
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 624
    Height = 94
    Align = alTop
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    object Label3: TLabel
      Left = 177
      Top = 8
      Width = 271
      Height = 19
      Caption = 'Agricultural Assessment Worksheet'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label1: TLabel
      Left = 372
      Top = 41
      Width = 83
      Height = 16
      Caption = 'Eligible Acres:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label2: TLabel
      Left = 372
      Top = 71
      Width = 127
      Height = 16
      Caption = 'Certified Assessment:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label20: TLabel
      Left = 6
      Top = 44
      Width = 66
      Height = 16
      Caption = 'Exemption:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object edEligibleAcres: TEdit
      Left = 512
      Top = 37
      Width = 104
      Height = 24
      Color = clMenu
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
    end
    object edCertifiedAssessment: TEdit
      Left = 512
      Top = 67
      Width = 104
      Height = 24
      Color = clMenu
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
    end
    object edExemption: TEdit
      Left = 82
      Top = 40
      Width = 104
      Height = 24
      Color = clMenu
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 2
    end
  end
  object tbAgriculture: TwwTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYTAXROLLYR_SWISSBLKEY'
    TableName = 'tpagriculture'
    TableType = ttDBase
    SyncSQLByRange = False
    NarrowSearch = False
    ValidateWithMask = True
    Left = 57
    Top = 105
  end
  object dsAgricultureSoils: TwwDataSource
    DataSet = tbAgricultureSoils
    Left = 219
    Top = 44
  end
  object tbAgricultureSoils: TwwTable
    OnCalcFields = tbAgricultureSoilsCalcFields
    DatabaseName = 'PASsystem'
    TableName = 'tpagriculturesoildtl'
    TableType = ttDBase
    ControlType.Strings = (
      'SoilGroupCode;CustomEdit;lcbxSoilRating')
    SyncSQLByRange = False
    NarrowSearch = False
    ValidateWithMask = True
    Left = 164
    Top = 40
    object tbAgricultureSoilsSoilGroupCode: TStringField
      DisplayLabel = 'Soil Code'
      DisplayWidth = 10
      FieldName = 'SoilGroupCode'
      Size = 10
    end
    object tbAgricultureSoilsAgAcreage: TFloatField
      DisplayLabel = 'Acreage'
      DisplayWidth = 10
      FieldName = 'AgAcreage'
    end
    object tbAgricultureSoilsAssessmentPerAcre: TIntegerField
      DisplayLabel = 'Assessment / Acre'
      DisplayWidth = 10
      FieldKind = fkCalculated
      FieldName = 'AssessmentPerAcre'
      Calculated = True
    end
    object tbAgricultureSoilsAssessment: TIntegerField
      DisplayWidth = 10
      FieldKind = fkCalculated
      FieldName = 'Assessment'
      Calculated = True
    end
  end
  object tbSoilRatings: TwwTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYMAINCODE'
    TableName = 'ZInvSoilRatingTbl'
    TableType = ttDBase
    SyncSQLByRange = False
    NarrowSearch = False
    ValidateWithMask = True
    Left = 277
    Top = 44
  end
  object dsSoilRatings: TwwDataSource
    DataSet = tbSoilRatings
    Left = 168
    Top = 85
  end
  object dsAgriculture: TDataSource
    DataSet = tbAgriculture
    Left = 84
    Top = 125
  end
  object tbParcel: TTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYTAXROLLYR_SWISSBLKEY'
    TableName = 'TParcelRec'
    TableType = ttDBase
    Left = 69
    Top = 388
  end
  object tbAssess: TTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYTAXROLLYR_SWISSBLKEY'
    TableName = 'TPAssessRec'
    TableType = ttDBase
    Left = 113
    Top = 385
  end
  object tbSwis: TTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYSWISCODE'
    TableName = 'TSwisTbl'
    TableType = ttDBase
    Left = 180
    Top = 387
  end
  object tbExemption: TwwTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYSWISSBLKEY_EXCODE'
    TableName = 'TPExemptionRec'
    TableType = ttDBase
    SyncSQLByRange = False
    NarrowSearch = False
    ValidateWithMask = True
    Left = 333
    Top = 40
  end
end
