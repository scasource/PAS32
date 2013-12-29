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
    Height = 356
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
      FocusControl = MainCodeEdit
    end
    object MunNameLabel: TLabel
      Left = 27
      Top = 55
      Width = 41
      Height = 16
      Caption = 'Name:'
      FocusControl = MunicipalName
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
      Width = 35
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
    object MainCodeEdit: TDBEdit
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
    end
    object MunicipalName: TDBEdit
      Left = 112
      Top = 51
      Width = 225
      Height = 24
      DataField = 'MunicipalityName'
      DataSource = dsMain
      TabOrder = 2
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
    end
    object MunicipalityLookupCombo: TwwDBLookupCombo
      Left = 112
      Top = 80
      Width = 124
      Height = 24
      DropDownAlignment = taLeftJustify
      DataField = 'MunicipalTypeDesc'
      DataSource = dsMain
      LookupField = 'Description'
      Options = [loColLines, loRowLines]
      TabOrder = 3
      AutoDropDown = False
      ShowButton = True
      SeqSearchOptions = [ssoEnabled, ssoCaseSensitive]
      AllowClearKey = False
    end
    object EditSplitVillageCode: TDBEdit
      Left = 112
      Top = 110
      Width = 68
      Height = 24
      DataField = 'SplitVillageCode'
      DataSource = dsMain
      TabOrder = 5
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
    end
    object ZipCodeEdit: TDBEdit
      Left = 299
      Top = 170
      Width = 54
      Height = 24
      DataField = 'ZipCode'
      DataSource = dsMain
      TabOrder = 10
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
        Width = 97
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
        Width = 78
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
        Width = 91
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
        DropDownAlignment = taLeftJustify
        Selected.Strings = (
          'Code'#9'1'#9'Code'
          'BasicVetLimit'#9'10'#9'Basic'
          'CombatVetLimit'#9'10'#9'Combat'
          'DisabledVetLimit'#9'10'#9'DisabledVetLimit')
        DataField = 'VeteransLimitSet'
        DataSource = dsMain
        LookupTable = tbVeteranLimits
        LookupField = 'Code'
        Options = [loColLines, loRowLines, loTitles]
        Style = csDropDownList
        DropDownWidth = 300
        TabOrder = 3
        AutoDropDown = False
        ShowButton = True
        SeqSearchOptions = [ssoEnabled, ssoCaseSensitive]
        AllowClearKey = False
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
        Width = 97
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
        DropDownAlignment = taLeftJustify
        Selected.Strings = (
          'Code'#9'1'#9'Code'
          'BasicVetLimit'#9'10'#9'Basic'
          'CombatVetLimit'#9'10'#9'Combat'
          'DisabledVetLimit'#9'10'#9'DisabledVetLimit')
        DataField = 'ColdWarVetMunicLimitSet'
        DataSource = dsMain
        LookupField = 'Code'
        Options = [loColLines, loRowLines, loTitles]
        Style = csDropDownList
        DropDownWidth = 300
        TabOrder = 3
        AutoDropDown = False
        ShowButton = True
        SeqSearchOptions = [ssoEnabled, ssoCaseSensitive]
        AllowClearKey = False
      end
    end
  end
  object MainToolBar: TToolBar
    Left = 0
    Top = 0
    Width = 471
    Height = 29
    TabOrder = 1
    object SaveButton: TSpeedButton
      Left = 0
      Top = 2
      Width = 23
      Height = 22
      Hint = 'Save'
      Enabled = False
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
      OnClick = SaveButtonClick
    end
    object CancelButton: TSpeedButton
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
      OnClick = CancelButtonClick
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
    Left = 283
    Top = 5
  end
  object tbMain: TwwTable
    Active = True
    DatabaseName = 'PASsystem'
    TableName = 'TSwisTbl'
    TableType = ttDBase
    SyncSQLByRange = True
    NarrowSearch = False
    ValidateWithMask = True
    Left = 231
    Top = 4
  end
  object tbVeteranLimits: TwwTable
    DatabaseName = 'PASsystem'
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
    object tbVeteranLimitsEligibleFundsLimit: TIntegerField
      FieldName = 'EligibleFundsLimit'
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
    object tbVeteranLimitsReserved: TStringField
      FieldName = 'Reserved'
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
    Left = 271
    Top = 245
  end
  object dsColdWarVeteranLimits: TwwDataSource
    DataSet = tbColdWarVeteranLimits
    Left = 348
    Top = 243
  end
end
