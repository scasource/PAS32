object SpecialDistrictCodeMaintenanceSubform: TSpecialDistrictCodeMaintenanceSubform
  Left = 319
  Top = 146
  Width = 543
  Height = 609
  Caption = 'Special District '
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Arial'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 16
  object MainGroupBox: TGroupBox
    Left = 0
    Top = 29
    Width = 527
    Height = 544
    Align = alClient
    Caption = ' Information for district: '
    TabOrder = 0
    object Label1: TLabel
      Left = 10
      Top = 25
      Width = 41
      Height = 16
      Caption = 'Code: '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label2: TLabel
      Left = 10
      Top = 52
      Width = 75
      Height = 16
      Caption = 'Description:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object EditSpecialDistrictCode: TwwDBEdit
      Left = 90
      Top = 21
      Width = 89
      Height = 24
      CharCase = ecUpperCase
      DataField = 'SDistCode'
      DataSource = SpecialDistrictDataSource
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBackground
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      UnboundDataType = wwDefault
      WantReturns = False
      WordWrap = False
      OnChange = EditChange
    end
    object DescriptionEdit: TwwDBEdit
      Left = 90
      Top = 49
      Width = 428
      Height = 24
      CharCase = ecUpperCase
      DataField = 'Description'
      DataSource = SpecialDistrictDataSource
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
      UnboundDataType = wwDefault
      WantReturns = False
      WordWrap = False
    end
    object OptionsGroupBox: TGroupBox
      Left = 12
      Top = 71
      Width = 253
      Height = 184
      Caption = ' Options: '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 2
      object Label3: TLabel
        Left = 18
        Top = 24
        Width = 74
        Height = 15
        Caption = 'District Type:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label18: TLabel
        Left = 18
        Top = 156
        Width = 87
        Height = 15
        Caption = 'Bill Print Group:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object HomesteadCheckBox: TDBCheckBox
        Left = 15
        Top = 92
        Width = 119
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Split District'
        DataField = 'SDHomestead'
        DataSource = SpecialDistrictDataSource
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 3
        ValueChecked = 'True'
        ValueUnchecked = 'False'
        OnClick = EditChange
      end
      object Section490DBCheckBox: TDBCheckBox
        Left = 15
        Top = 49
        Width = 119
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Section 490 Dist'
        DataField = 'Section490'
        DataSource = SpecialDistrictDataSource
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 1
        ValueChecked = 'True'
        ValueUnchecked = 'False'
        OnClick = EditChange
      end
      object AppliesToSchoolDBCheckBox: TDBCheckBox
        Left = 15
        Top = 113
        Width = 119
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Applies to School'
        DataField = 'AppliesToSchool'
        DataSource = SpecialDistrictDataSource
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 5
        ValueChecked = 'True'
        ValueUnchecked = 'False'
        OnClick = EditChange
      end
      object Chapter562CheckBox: TDBCheckBox
        Left = 15
        Top = 70
        Width = 119
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Chapter 562 Dist'
        DataField = 'Chapter562'
        DataSource = SpecialDistrictDataSource
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 2
        ValueChecked = 'True'
        ValueUnchecked = 'False'
        OnClick = EditChange
      end
      object VolunteerAmbulance_Fire_Exemption_AppliesCheckBox: TDBCheckBox
        Left = 15
        Top = 134
        Width = 204
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Vol Fire \ Amb Exemption Applies'
        DataField = 'VolFireAmbApplies'
        DataSource = SpecialDistrictDataSource
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 4
        ValueChecked = 'True'
        ValueUnchecked = 'False'
        OnClick = EditChange
      end
      object DistrictTypeComboBox: TwwDBComboBox
        Left = 120
        Top = 19
        Width = 38
        Height = 24
        ShowButton = True
        Style = csDropDown
        MapList = False
        AllowClearKey = False
        Color = clWhite
        DataField = 'DistrictType'
        DataSource = SpecialDistrictDataSource
        DropDownCount = 8
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ItemHeight = 0
        Items.Strings = (
          'A'#9'Ad Valorum'
          'S'#9'Special Assessment')
        ParentFont = False
        Sorted = False
        TabOrder = 0
        UnboundDataType = wwDefault
      end
      object cbxBillPrintGroup: TwwDBLookupCombo
        Left = 127
        Top = 153
        Width = 93
        Height = 24
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        DropDownAlignment = taLeftJustify
        Selected.Strings = (
          'Code'#9'7'#9'Code'#9'F'
          'Description'#9'12'#9'Description'#9'F')
        DataField = 'BillPrintGroup'
        DataSource = SpecialDistrictDataSource
        LookupTable = tbBillPrintGroup
        LookupField = 'Code'
        Options = [loColLines, loRowLines]
        Style = csDropDownList
        ParentFont = False
        TabOrder = 6
        AutoDropDown = False
        ShowButton = True
        AllowClearKey = False
      end
    end
    object ExtensionGroupBox: TGroupBox
      Left = 12
      Top = 256
      Width = 508
      Height = 182
      Caption = ' Extensions: '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 3
      object Label4: TLabel
        Left = 25
        Top = 46
        Width = 11
        Height = 16
        Caption = '1.'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label5: TLabel
        Left = 25
        Top = 74
        Width = 11
        Height = 16
        Caption = '2.'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label6: TLabel
        Left = 25
        Top = 102
        Width = 11
        Height = 16
        Caption = '3.'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label7: TLabel
        Left = 25
        Top = 129
        Width = 11
        Height = 16
        Caption = '4.'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label8: TLabel
        Left = 25
        Top = 157
        Width = 11
        Height = 16
        Caption = '5.'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label9: TLabel
        Left = 64
        Top = 23
        Width = 27
        Height = 15
        Caption = 'Type'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGreen
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label10: TLabel
        Left = 130
        Top = 23
        Width = 79
        Height = 15
        Caption = 'Capital \ Maint'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGreen
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label16: TLabel
        Left = 302
        Top = 23
        Width = 65
        Height = 15
        Caption = 'Description'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGreen
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label17: TLabel
        Left = 464
        Top = 23
        Width = 33
        Height = 15
        Caption = 'Order'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGreen
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object ExtensionCode1Lookup: TwwDBLookupCombo
        Left = 50
        Top = 43
        Width = 55
        Height = 23
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        DropDownAlignment = taLeftJustify
        Selected.Strings = (
          'MainCode'#9'2'#9'Code'#9'F'
          'Description'#9'15'#9'Description'#9'F')
        DataField = 'ECd1'
        DataSource = SpecialDistrictDataSource
        LookupTable = ExtensionCodeLookupTable
        LookupField = 'MainCode'
        Options = [loColLines, loRowLines]
        ParentFont = False
        TabOrder = 0
        AutoDropDown = False
        ShowButton = True
        AllowClearKey = False
      end
      object ExtensionCode2Lookup: TwwDBLookupCombo
        Left = 50
        Top = 71
        Width = 55
        Height = 23
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        DropDownAlignment = taLeftJustify
        Selected.Strings = (
          'MainCode'#9'2'#9'Code'#9'F'
          'Description'#9'15'#9'Description'#9'F')
        DataField = 'ECd2'
        DataSource = SpecialDistrictDataSource
        LookupTable = ExtensionCodeLookupTable
        LookupField = 'MainCode'
        Options = [loColLines, loRowLines]
        ParentFont = False
        TabOrder = 4
        AutoDropDown = False
        ShowButton = True
        AllowClearKey = False
      end
      object ExtensionFlag2Lookup: TwwDBComboBox
        Left = 145
        Top = 71
        Width = 49
        Height = 23
        ShowButton = True
        Style = csDropDown
        MapList = False
        AllowClearKey = False
        DataField = 'ECFlg2'
        DataSource = SpecialDistrictDataSource
        DropDownCount = 8
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ItemHeight = 0
        Items.Strings = (
          'C'#9'Capital Cost'
          'M'#9'Maintenance')
        ParentFont = False
        Sorted = False
        TabOrder = 5
        UnboundDataType = wwDefault
      end
      object ExtensionCode3Lookup: TwwDBLookupCombo
        Left = 50
        Top = 99
        Width = 55
        Height = 23
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        DropDownAlignment = taLeftJustify
        Selected.Strings = (
          'MainCode'#9'2'#9'Code'#9'F'
          'Description'#9'15'#9'Description'#9'F')
        DataField = 'ECd3'
        DataSource = SpecialDistrictDataSource
        LookupTable = ExtensionCodeLookupTable
        LookupField = 'MainCode'
        Options = [loColLines, loRowLines]
        ParentFont = False
        TabOrder = 8
        AutoDropDown = False
        ShowButton = True
        AllowClearKey = False
      end
      object ExtensionFlag3Lookup: TwwDBComboBox
        Left = 145
        Top = 99
        Width = 49
        Height = 23
        ShowButton = True
        Style = csDropDown
        MapList = False
        AllowClearKey = False
        DataField = 'ECFlg3'
        DataSource = SpecialDistrictDataSource
        DropDownCount = 8
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ItemHeight = 0
        Items.Strings = (
          'C'#9'Capital Cost'
          'M'#9'Maintenance')
        ParentFont = False
        Sorted = False
        TabOrder = 9
        UnboundDataType = wwDefault
      end
      object ExtensionCode4Lookup: TwwDBLookupCombo
        Left = 50
        Top = 126
        Width = 55
        Height = 23
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        DropDownAlignment = taLeftJustify
        Selected.Strings = (
          'MainCode'#9'2'#9'Code'#9'F'
          'Description'#9'15'#9'Description'#9'F')
        DataField = 'ECd4'
        DataSource = SpecialDistrictDataSource
        LookupTable = ExtensionCodeLookupTable
        LookupField = 'MainCode'
        Options = [loColLines, loRowLines]
        ParentFont = False
        TabOrder = 12
        AutoDropDown = False
        ShowButton = True
        AllowClearKey = False
      end
      object ExtensionFlag4Lookup: TwwDBComboBox
        Left = 145
        Top = 126
        Width = 49
        Height = 23
        ShowButton = True
        Style = csDropDown
        MapList = False
        AllowClearKey = False
        DataField = 'ECFlg4'
        DataSource = SpecialDistrictDataSource
        DropDownCount = 8
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ItemHeight = 0
        Items.Strings = (
          'C'#9'Capital Cost'
          'M'#9'Maintenance')
        ParentFont = False
        Sorted = False
        TabOrder = 13
        UnboundDataType = wwDefault
      end
      object ExtensionCode5Lookup: TwwDBLookupCombo
        Left = 50
        Top = 154
        Width = 55
        Height = 23
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        DropDownAlignment = taLeftJustify
        Selected.Strings = (
          'MainCode'#9'2'#9'Code'#9'F'
          'Description'#9'15'#9'Description'#9'F')
        DataField = 'ECd5'
        DataSource = SpecialDistrictDataSource
        LookupTable = ExtensionCodeLookupTable
        LookupField = 'MainCode'
        Options = [loColLines, loRowLines]
        ParentFont = False
        TabOrder = 16
        AutoDropDown = False
        ShowButton = True
        AllowClearKey = False
      end
      object ExtensionFlag5Lookup: TwwDBComboBox
        Left = 145
        Top = 154
        Width = 49
        Height = 23
        ShowButton = True
        Style = csDropDown
        MapList = False
        AllowClearKey = False
        DataField = 'ECFlg5'
        DataSource = SpecialDistrictDataSource
        DropDownCount = 8
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ItemHeight = 0
        Items.Strings = (
          'C'#9'Capital Cost'
          'M'#9'Maintenance')
        ParentFont = False
        Sorted = False
        TabOrder = 17
        UnboundDataType = wwDefault
      end
      object ExtensionFlag1Lookup: TwwDBComboBox
        Left = 145
        Top = 43
        Width = 49
        Height = 23
        ShowButton = True
        Style = csDropDown
        MapList = False
        AllowClearKey = False
        DataField = 'ECFlg1'
        DataSource = SpecialDistrictDataSource
        DropDownCount = 8
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ItemHeight = 0
        Items.Strings = (
          'C'#9'Capital Cost'
          'M'#9'Maintenance')
        ParentFont = False
        Sorted = False
        TabOrder = 1
        UnboundDataType = wwDefault
      end
      object edExtensionDescription1: TDBEdit
        Left = 214
        Top = 42
        Width = 240
        Height = 24
        DataField = 'ExtensionDescription1'
        DataSource = SpecialDistrictDataSource
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 2
      end
      object edExtensionGroupOrder1: TDBEdit
        Left = 463
        Top = 42
        Width = 34
        Height = 24
        DataField = 'ExtensionGroupOrder1'
        DataSource = SpecialDistrictDataSource
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 3
      end
      object edExtensionDescription2: TDBEdit
        Left = 214
        Top = 70
        Width = 240
        Height = 24
        DataField = 'ExtensionDescription2'
        DataSource = SpecialDistrictDataSource
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 6
      end
      object edExtensionGroupOrder2: TDBEdit
        Left = 463
        Top = 70
        Width = 34
        Height = 24
        DataField = 'ExtensionGroupOrder2'
        DataSource = SpecialDistrictDataSource
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 7
      end
      object edExtensionDescription3: TDBEdit
        Left = 214
        Top = 98
        Width = 240
        Height = 24
        DataField = 'ExtensionDescription3'
        DataSource = SpecialDistrictDataSource
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 10
      end
      object edExtensionGroupOrder3: TDBEdit
        Left = 463
        Top = 97
        Width = 34
        Height = 24
        DataField = 'ExtensionGroupOrder3'
        DataSource = SpecialDistrictDataSource
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 11
      end
      object edExtensionDescription4: TDBEdit
        Left = 214
        Top = 125
        Width = 240
        Height = 24
        DataField = 'ExtensionDescription4'
        DataSource = SpecialDistrictDataSource
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 14
      end
      object edExtensionGroupOrder4: TDBEdit
        Left = 462
        Top = 125
        Width = 34
        Height = 24
        DataField = 'ExtensionGroupOrder4'
        DataSource = SpecialDistrictDataSource
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 15
      end
      object edExtensionDescription5: TDBEdit
        Left = 214
        Top = 153
        Width = 240
        Height = 24
        DataField = 'ExtensionDescription5'
        DataSource = SpecialDistrictDataSource
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 18
      end
      object edExtensionGroupOrder5: TDBEdit
        Left = 463
        Top = 152
        Width = 34
        Height = 24
        DataField = 'ExtensionGroupOrder5'
        DataSource = SpecialDistrictDataSource
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 19
      end
    end
    object DefaultsGroupBox: TGroupBox
      Left = 12
      Top = 450
      Width = 241
      Height = 76
      Caption = ' Defaults: '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 4
      object Label11: TLabel
        Left = 30
        Top = 19
        Width = 35
        Height = 16
        Caption = 'Units:'
      end
      object Label12: TLabel
        Left = 30
        Top = 48
        Width = 62
        Height = 16
        Caption = '2nd Units:'
      end
      object DefaultUnitsEdit: TwwDBEdit
        Left = 104
        Top = 15
        Width = 52
        Height = 24
        DataField = 'DefaultUnits'
        DataSource = SpecialDistrictDataSource
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        UnboundDataType = wwDefault
        WantReturns = False
        WordWrap = False
      end
      object DefaultSecondUnitsEdit: TwwDBEdit
        Left = 104
        Top = 44
        Width = 52
        Height = 24
        DataField = 'Default2ndUnits'
        DataSource = SpecialDistrictDataSource
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 1
        UnboundDataType = wwDefault
        WantReturns = False
        WordWrap = False
      end
    end
    object StepAmountsGroupBox: TGroupBox
      Left = 311
      Top = 443
      Width = 208
      Height = 95
      Caption = ' Step Amounts: '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 5
      object Label13: TLabel
        Left = 25
        Top = 21
        Width = 11
        Height = 16
        Caption = '1.'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label14: TLabel
        Left = 25
        Top = 47
        Width = 11
        Height = 16
        Caption = '2.'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label15: TLabel
        Left = 25
        Top = 72
        Width = 11
        Height = 16
        Caption = '3.'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object StepAmount1Edit: TwwDBEdit
        Left = 60
        Top = 18
        Width = 61
        Height = 23
        DataField = 'Step1'
        DataSource = SpecialDistrictDataSource
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        UnboundDataType = wwDefault
        WantReturns = False
        WordWrap = False
      end
      object StepAmount2Edit: TwwDBEdit
        Left = 60
        Top = 44
        Width = 61
        Height = 23
        DataField = 'Step2'
        DataSource = SpecialDistrictDataSource
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 1
        UnboundDataType = wwDefault
        WantReturns = False
        WordWrap = False
      end
      object StepAmount3Edit: TwwDBEdit
        Left = 60
        Top = 69
        Width = 61
        Height = 23
        DataField = 'Step3'
        DataSource = SpecialDistrictDataSource
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 2
        UnboundDataType = wwDefault
        WantReturns = False
        WordWrap = False
      end
    end
    object GroupBox1: TGroupBox
      Left = 275
      Top = 71
      Width = 235
      Height = 184
      Caption = ' District Category: '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 6
      object RollSection9CheckBox: TDBCheckBox
        Left = 33
        Top = 37
        Width = 119
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Roll Section 9'
        DataField = 'SDRs9'
        DataSource = SpecialDistrictDataSource
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        ValueChecked = 'True'
        ValueUnchecked = 'False'
        OnClick = EditChange
      end
      object Prorata_Omitted_CheckBox: TDBCheckBox
        Left = 33
        Top = 55
        Width = 119
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Prorata \ Omitted'
        DataField = 'ProRataOmit'
        DataSource = SpecialDistrictDataSource
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 1
        ValueChecked = 'True'
        ValueUnchecked = 'False'
        OnClick = EditChange
      end
      object LateralDistrictCheckBox: TDBCheckBox
        Left = 61
        Top = 143
        Width = 119
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Lateral Dist'
        DataField = 'LateralDistrict'
        DataSource = SpecialDistrictDataSource
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 2
        ValueChecked = 'True'
        ValueUnchecked = 'False'
        OnClick = EditChange
      end
      object OperatingDistrictCheckBox: TDBCheckBox
        Left = 61
        Top = 161
        Width = 119
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Operating Dist'
        DataField = 'OperatingDistrict'
        DataSource = SpecialDistrictDataSource
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 3
        ValueChecked = 'True'
        ValueUnchecked = 'False'
        OnClick = EditChange
      end
      object TreatmentDistrictCheckBox: TDBCheckBox
        Left = 61
        Top = 126
        Width = 119
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Treatment Dist'
        DataField = 'TreatmentDistrict'
        DataSource = SpecialDistrictDataSource
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 4
        ValueChecked = 'True'
        ValueUnchecked = 'False'
        OnClick = EditChange
      end
      object FireDistrictCheckBox: TDBCheckBox
        Left = 33
        Top = 19
        Width = 119
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Fire District'
        DataField = 'FireDistrict'
        DataSource = SpecialDistrictDataSource
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 5
        ValueChecked = 'True'
        ValueUnchecked = 'False'
        OnClick = EditChange
      end
      object cbxSewerDistrict: TDBCheckBox
        Left = 33
        Top = 108
        Width = 119
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Sewer'
        DataField = 'Sewer'
        DataSource = SpecialDistrictDataSource
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 6
        ValueChecked = 'True'
        ValueUnchecked = 'False'
        OnClick = EditChange
      end
      object cbxSolidWasteDistrict: TDBCheckBox
        Left = 33
        Top = 90
        Width = 119
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Solid Waste'
        DataField = 'SolidWaste'
        DataSource = SpecialDistrictDataSource
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 7
        ValueChecked = 'True'
        ValueUnchecked = 'False'
        OnClick = EditChange
      end
      object cbxWaterDistrict: TDBCheckBox
        Left = 33
        Top = 72
        Width = 119
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Water'
        DataField = 'Water'
        DataSource = SpecialDistrictDataSource
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 8
        ValueChecked = 'True'
        ValueUnchecked = 'False'
        OnClick = EditChange
      end
    end
  end
  object MainToolBar: TToolBar
    Left = 0
    Top = 0
    Width = 527
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
    end
  end
  object SpecialDistrictCodeTable: TwwTable
    OnNewRecord = SpecialDistrictCodeTableNewRecord
    DatabaseName = 'PASsystem'
    IndexName = 'BYSDISTCODE'
    TableName = 'TSDCodeTbl'
    TableType = ttDBase
    SyncSQLByRange = False
    NarrowSearch = False
    ValidateWithMask = True
    Left = 413
    Top = 4
  end
  object SpecialDistrictDataSource: TwwDataSource
    DataSet = SpecialDistrictCodeTable
    Left = 528
    Top = 13
  end
  object ExtensionCodeLookupTable: TwwTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYMAINCODE'
    TableName = 'ZSDExtCodeTbl'
    TableType = ttDBase
    SyncSQLByRange = True
    NarrowSearch = False
    ValidateWithMask = True
    Left = 266
    Top = 6
    object ExtensionCodeLookupTableMainCode: TStringField
      DisplayLabel = 'Code'
      DisplayWidth = 2
      FieldName = 'MainCode'
      Size = 2
    end
    object ExtensionCodeLookupTableDescription: TStringField
      DisplayWidth = 15
      FieldName = 'Description'
      Size = 30
    end
    object ExtensionCodeLookupTableTaxRollYr: TStringField
      DisplayWidth = 4
      FieldName = 'TaxRollYr'
      Visible = False
      Size = 4
    end
    object ExtensionCodeLookupTableCategory: TStringField
      DisplayWidth = 4
      FieldName = 'Category'
      Visible = False
      Size = 4
    end
  end
  object OppositeYearSDCodeTable: TTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYSDISTCODE'
    TableType = ttDBase
    Left = 344
    Top = 40
  end
  object tbBillPrintGroup: TTable
    DatabaseName = 'PASsystem'
    IndexFieldNames = 'Code'
    TableName = 'zbillprintgroup'
    TableType = ttDBase
    Left = 181
    Top = 430
  end
end
