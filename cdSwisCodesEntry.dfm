object fmSwisCodesEntry: TfmSwisCodesEntry
  Left = 538
  Top = 150
  Width = 487
  Height = 421
  Caption = 'Swis Code'
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
  object gbxSwisCode: TGroupBox
    Left = 0
    Top = 29
    Width = 471
    Height = 354
    Align = alClient
    Caption = ' Swis Code: '
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
      Width = 71
      Height = 16
      Caption = 'Swis Code:'
      FocusControl = edMainCode
    end
    object MunNameLabel: TLabel
      Left = 27
      Top = 55
      Width = 41
      Height = 16
      Caption = 'Name:'
      FocusControl = edMunicipalName
    end
    object EqualLabel: TLabel
      Left = 27
      Top = 143
      Width = 57
      Height = 16
      Caption = 'Eq. Rate:'
    end
    object ResAssmntLabel: TLabel
      Left = 221
      Top = 132
      Width = 73
      Height = 38
      AutoSize = False
      Caption = 'Res Assmnt Ratio'
      WordWrap = True
    end
    object Label1: TLabel
      Left = 212
      Top = 25
      Width = 71
      Height = 16
      Caption = 'Short Code'
    end
    object Label3: TLabel
      Left = 27
      Top = 84
      Width = 34
      Height = 16
      Caption = 'Type:'
    end
    object Label7: TLabel
      Left = 274
      Top = 114
      Width = 61
      Height = 16
      Caption = 'Classified'
    end
    object Label9: TLabel
      Left = 27
      Top = 114
      Width = 82
      Height = 16
      Caption = 'Split Village:'
    end
    object Label10: TLabel
      Left = 274
      Top = 84
      Width = 110
      Height = 16
      Caption = 'Assessing Village'
    end
    object Label11: TLabel
      Left = 27
      Top = 163
      Width = 73
      Height = 35
      AutoSize = False
      Caption = 'Uniform % of Value:'
      WordWrap = True
    end
    object Label4: TLabel
      Left = 221
      Top = 174
      Width = 56
      Height = 16
      Caption = 'Zip Code'
    end
    object edMainCode: TDBEdit
      Left = 112
      Top = 21
      Width = 69
      Height = 24
      CharCase = ecUpperCase
      DataField = 'SwisCode'
      DataSource = dsMain
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      OnChange = EditChange
    end
    object edMunicipalName: TDBEdit
      Left = 112
      Top = 51
      Width = 225
      Height = 24
      DataField = 'MunicipalityName'
      DataSource = dsMain
      TabOrder = 2
      OnChange = EditChange
    end
    object EditEqualizationRate: TDBEdit
      Left = 112
      Top = 139
      Width = 85
      Height = 24
      DataField = 'EqualizationRate'
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
    object EditResidentialAssessmentRatio: TDBEdit
      Left = 299
      Top = 139
      Width = 85
      Height = 24
      DataField = 'ResAssmntRatio'
      DataSource = dsMain
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGreen
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 8
      OnChange = EditChange
    end
    object EditShortSwisCode: TDBEdit
      Left = 292
      Top = 21
      Width = 45
      Height = 24
      CharCase = ecUpperCase
      DataField = 'SWISShortCode'
      DataSource = dsMain
      TabOrder = 1
      OnChange = EditChange
    end
    object ClassifiedCheckBox: TDBCheckBox
      Left = 390
      Top = 114
      Width = 14
      Height = 17
      Caption = 'ClassifiedCheckBox'
      DataField = 'Classified'
      DataSource = dsMain
      TabOrder = 6
      ValueChecked = 'True'
      ValueUnchecked = 'False'
      OnClick = EditChange
    end
    object MunicipalityLookupCombo: TwwDBLookupCombo
      Left = 112
      Top = 80
      Width = 124
      Height = 24
      DropDownAlignment = taLeftJustify
      DataField = 'MunicipalTypeDesc'
      DataSource = dsMain
      LookupTable = tbMunicipalTypes
      LookupField = 'Description'
      Options = [loColLines, loRowLines]
      TabOrder = 3
      AutoDropDown = False
      ShowButton = True
      SeqSearchOptions = [ssoEnabled, ssoCaseSensitive]
      AllowClearKey = False
      OnChange = EditChange
    end
    object EditSplitVillageCode: TDBEdit
      Left = 112
      Top = 110
      Width = 68
      Height = 24
      DataField = 'SplitVillageCode'
      DataSource = dsMain
      TabOrder = 5
      OnChange = EditChange
    end
    object AssessingVillageCheckBox: TDBCheckBox
      Left = 390
      Top = 84
      Width = 14
      Height = 17
      Caption = 'AssessingVillageCheckBox'
      DataField = 'AssessingVillage'
      DataSource = dsMain
      TabOrder = 4
      ValueChecked = 'True'
      ValueUnchecked = 'False'
      OnClick = EditChange
    end
    object UniformPercentOfValueEdit: TDBEdit
      Left = 112
      Top = 170
      Width = 85
      Height = 24
      DataField = 'UniformPercentValue'
      DataSource = dsMain
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGreen
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 9
      OnChange = EditChange
    end
    object ZipCodeEdit: TDBEdit
      Left = 299
      Top = 170
      Width = 54
      Height = 24
      DataField = 'ZipCode'
      DataSource = dsMain
      TabOrder = 10
      OnChange = EditChange
    end
    object gbxMunicipalVeteranLimits: TGroupBox
      Left = 16
      Top = 199
      Width = 207
      Height = 147
      Caption = ' Municipal Veteran Limits: '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clPurple
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 11
      object DisabledVetLabel: TLabel
        Left = 20
        Top = 119
        Width = 96
        Height = 15
        Caption = 'Disabled (4114x):'
        FocusControl = edMunicipalDisabledVetLimit
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object VetMaxLabel: TLabel
        Left = 20
        Top = 61
        Width = 77
        Height = 15
        Caption = 'Basic (4112x):'
        FocusControl = edMunicipalBasicVetLimit
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object CombatVetlbl: TLabel
        Left = 20
        Top = 90
        Width = 90
        Height = 15
        Caption = 'Combat (4113x):'
        FocusControl = edMunicipalCombatVetLimit
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object Label21: TLabel
        Left = 20
        Top = 29
        Width = 56
        Height = 16
        Caption = 'Limit Set:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object edMunicipalDisabledVetLimit: TDBEdit
        Left = 130
        Top = 116
        Width = 66
        Height = 22
        Hint = ' '
        TabStop = False
        Color = clBtnFace
        DataField = 'DisabledVetTownMax'
        DataSource = dsMain
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        ReadOnly = True
        TabOrder = 0
      end
      object edMunicipalBasicVetLimit: TDBEdit
        Left = 130
        Top = 58
        Width = 66
        Height = 22
        Hint = ' '
        TabStop = False
        Color = clBtnFace
        DataField = 'VeteranTownMax'
        DataSource = dsMain
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        ReadOnly = True
        TabOrder = 1
      end
      object edMunicipalCombatVetLimit: TDBEdit
        Left = 130
        Top = 87
        Width = 66
        Height = 22
        TabStop = False
        Color = clBtnFace
        DataField = 'CombatVetTownMax'
        DataSource = dsMain
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        ReadOnly = True
        TabOrder = 2
      end
      object cbxVeteranLimitSet: TwwDBLookupCombo
        Left = 130
        Top = 25
        Width = 47
        Height = 24
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        DropDownAlignment = taLeftJustify
        Selected.Strings = (
          'Code'#9'1'#9'Code'
          'BasicVetLimit'#9'10'#9'Basic'
          'CombatVetLimit'#9'10'#9'Combat'
          'DisabledVetLimit'#9'10'#9'Disabled'#9'F')
        DataField = 'VeteransLimitSet'
        DataSource = dsMain
        LookupTable = tbVeteranLimits
        LookupField = 'Code'
        Options = [loColLines, loRowLines, loTitles]
        Style = csDropDownList
        DropDownWidth = 300
        ParentFont = False
        TabOrder = 3
        AutoDropDown = False
        ShowButton = True
        SeqSearchOptions = [ssoEnabled, ssoCaseSensitive]
        AllowClearKey = False
        OnChange = EditChange
        OnCloseUp = cbxVeteranLimitSetCloseUp
      end
    end
    object gbxMunicipalColdWarVeteranLimits: TGroupBox
      Left = 246
      Top = 199
      Width = 207
      Height = 147
      Caption = ' Munic. Cold War Vet Limits: '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clPurple
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 12
      object Label5: TLabel
        Left = 20
        Top = 119
        Width = 96
        Height = 15
        Caption = 'Disabled (4117x):'
        FocusControl = edDisabledColdWarVeteranLimit
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object Label6: TLabel
        Left = 20
        Top = 61
        Width = 34
        Height = 15
        Caption = 'Basic:'
        FocusControl = edBasicColdWarVeteranLimit
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object Label2: TLabel
        Left = 20
        Top = 90
        Width = 48
        Height = 15
        Caption = 'Basic %:'
        FocusControl = edColdWarBasicCountyPercent
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object Label13: TLabel
        Left = 20
        Top = 29
        Width = 56
        Height = 16
        Caption = 'Limit Set:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object edDisabledColdWarVeteranLimit: TDBEdit
        Left = 130
        Top = 116
        Width = 66
        Height = 22
        Hint = ' '
        TabStop = False
        Color = clBtnFace
        DataField = 'DisabledVetLimit'
        DataSource = dsColdWarVeteranLimits
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        ReadOnly = True
        TabOrder = 0
      end
      object edBasicColdWarVeteranLimit: TDBEdit
        Left = 130
        Top = 58
        Width = 66
        Height = 22
        Hint = ' '
        TabStop = False
        Color = clBtnFace
        DataField = 'BasicLimit'
        DataSource = dsColdWarVeteranLimits
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        ReadOnly = True
        TabOrder = 1
      end
      object edColdWarBasicCountyPercent: TDBEdit
        Left = 130
        Top = 87
        Width = 66
        Height = 22
        TabStop = False
        Color = clBtnFace
        DataField = 'BasicPercent'
        DataSource = dsColdWarVeteranLimits
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        ReadOnly = True
        TabOrder = 2
      end
      object cbxMunicipalColdWarVeteranLimitCode: TwwDBLookupCombo
        Left = 129
        Top = 25
        Width = 47
        Height = 24
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        DropDownAlignment = taLeftJustify
        Selected.Strings = (
          'Code'#9'1'#9'Code'
          'BasicPercent'#9'5'#9'Basic %'#9'F'
          'BasicLimit'#9'8'#9'Basic Limit'#9'F'
          'DisabledVetLimit'#9'8'#9'Disabled'#9'F')
        DataField = 'ColdWarVetMunicLimitSet'
        DataSource = dsMain
        LookupTable = tbColdWarVeteranLimits
        LookupField = 'Code'
        Options = [loColLines, loRowLines, loTitles]
        Style = csDropDownList
        DropDownWidth = 300
        ParentFont = False
        TabOrder = 3
        AutoDropDown = False
        ShowButton = True
        SeqSearchOptions = [ssoEnabled, ssoCaseSensitive]
        AllowClearKey = False
        OnChange = EditChange
      end
    end
  end
  object MainToolBar: TToolBar
    Left = 0
    Top = 0
    Width = 471
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
  end
  object tmrButtonsState: TTimer
    Enabled = False
    Interval = 10
    OnTimer = tmrButtonsStateTimer
    Left = 147
    Top = 1
  end
  object dsMain: TwwDataSource
    DataSet = tbMain
    Left = 386
    Top = 78
  end
  object tbMain: TwwTable
    AfterEdit = tbMainAfterEdit
    AfterPost = tbMainAfterPost
    DatabaseName = 'PASsystem'
    IndexName = 'BYSWISCODE'
    TableName = 'TSwisTbl'
    TableType = ttDBase
    SyncSQLByRange = True
    NarrowSearch = False
    ValidateWithMask = True
    Left = 349
    Top = 51
  end
  object tbVeteranLimits: TwwTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYVETLIMITCODE'
    TableName = 'ZVeteransLimitCodes'
    TableType = ttDBase
    SyncSQLByRange = True
    NarrowSearch = False
    ValidateWithMask = True
    Left = 199
    Top = 267
    object tbVeteranLimitsCode: TStringField
      DisplayWidth = 1
      FieldName = 'Code'
      Size = 1
    end
    object tbVeteranLimitsBasicVetLimit: TIntegerField
      DisplayLabel = 'Basic'
      DisplayWidth = 10
      FieldName = 'BasicVetLimit'
    end
    object tbVeteranLimitsCombatVetLimit: TIntegerField
      DisplayLabel = 'Combat'
      DisplayWidth = 10
      FieldName = 'CombatVetLimit'
    end
    object tbVeteranLimitsDisabledVetLimit: TIntegerField
      DisplayLabel = 'Disabled'
      DisplayWidth = 10
      FieldName = 'DisabledVetLimit'
    end
    object tbVeteranLimitsEligibleFundsLimit: TIntegerField
      FieldName = 'EligibleFundsLimit'
      Visible = False
    end
    object tbVeteranLimitsReserved: TStringField
      FieldName = 'Reserved'
      Visible = False
    end
  end
  object tbColdWarVeteranLimits: TwwTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYVETLIMITCODE'
    TableName = 'zcoldwarvetlimits'
    TableType = ttDBase
    SyncSQLByRange = False
    NarrowSearch = False
    ValidateWithMask = True
    Left = 273
    Top = 245
  end
  object dsColdWarVeteranLimits: TwwDataSource
    DataSet = tbColdWarVeteranLimits
    Left = 348
    Top = 243
  end
  object tbMunicipalTypes: TwwTable
    DatabaseName = 'PASsystem'
    TableName = 'ZMunicipalityTypeTbl'
    SyncSQLByRange = True
    NarrowSearch = False
    ValidateWithMask = True
    Left = 237
    Top = 105
  end
  object tbSwisCodeLookup: TTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYSWISCODE'
    TableName = 'TSwisTbl'
    TableType = ttDBase
    Left = 403
    Top = 18
  end
end
