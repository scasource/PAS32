object SalesEntryDialogForm: TSalesEntryDialogForm
  Left = 501
  Top = 137
  Width = 600
  Height = 480
  ActiveControl = TransactionCode
  Caption = 'SalesEntryDialogForm'
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
  object MainToolBar: TToolBar
    Left = 0
    Top = 0
    Width = 592
    Height = 31
    ButtonHeight = 25
    TabOrder = 0
    object SaveAndExitButton: TSpeedButton
      Left = 0
      Top = 2
      Width = 99
      Height = 25
      Caption = 'Save and E&xit'
      Enabled = False
      Flat = True
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000120B0000120B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00330000000000
        03333377777777777F333301111111110333337F333333337F33330111111111
        0333337F333333337F333301111111110333337F333333337F33330111111111
        0333337F333333337F333301111111110333337F333333337F33330111111111
        0333337F3333333F7F333301111111B10333337F333333737F33330111111111
        0333337F333333337F333301111111110333337F33FFFFF37F3333011EEEEE11
        0333337F377777F37F3333011EEEEE110333337F37FFF7F37F3333011EEEEE11
        0333337F377777337F333301111111110333337F333333337F33330111111111
        0333337FFFFFFFFF7F3333000000000003333377777777777333}
      NumGlyphs = 2
      OnClick = SaveAndExitButtonClick
    end
    object SaveButton: TSpeedButton
      Left = 99
      Top = 2
      Width = 23
      Height = 25
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
      Left = 122
      Top = 2
      Width = 23
      Height = 25
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
  object EntryInformationGroupBox: TGroupBox
    Left = 0
    Top = 31
    Width = 592
    Height = 52
    Align = alTop
    Caption = ' Entry Information: '
    TabOrder = 1
    object Label1: TLabel
      Left = 26
      Top = 24
      Width = 29
      Height = 13
      Caption = 'Date: '
    end
    object Label2: TLabel
      Left = 218
      Top = 24
      Width = 26
      Height = 13
      Caption = 'Time:'
    end
    object Label3: TLabel
      Left = 402
      Top = 24
      Width = 39
      Height = 13
      Caption = 'User ID:'
    end
    object DateEntered: TEdit
      Left = 60
      Top = 19
      Width = 86
      Height = 21
      TabStop = False
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      TabOrder = 0
    end
    object TimeEntered: TEdit
      Left = 259
      Top = 20
      Width = 86
      Height = 21
      TabStop = False
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      TabOrder = 1
    end
    object EnteredByUserID: TEdit
      Left = 457
      Top = 20
      Width = 121
      Height = 21
      TabStop = False
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      TabOrder = 2
    end
  end
  object SaleInformationGroupBox: TGroupBox
    Left = 0
    Top = 189
    Width = 592
    Height = 257
    Align = alBottom
    Caption = ' Sale Information: '
    TabOrder = 2
    object Label4: TLabel
      Left = 15
      Top = 29
      Width = 70
      Height = 27
      AutoSize = False
      Caption = 'Transaction Code:'
      WordWrap = True
    end
    object Label5: TLabel
      Left = 218
      Top = 36
      Width = 27
      Height = 13
      Caption = 'Type:'
    end
    object Label6: TLabel
      Left = 402
      Top = 36
      Width = 49
      Height = 13
      Caption = 'Due Date:'
    end
    object Label7: TLabel
      Left = 18
      Top = 69
      Width = 72
      Height = 31
      AutoSize = False
      Caption = 'Person Responsible:'
      WordWrap = True
    end
    object Label8: TLabel
      Left = 218
      Top = 78
      Width = 29
      Height = 13
      Caption = 'Open:'
      FocusControl = NoteOpen
    end
    object TransactionCode: TwwDBLookupCombo
      Tag = 10
      Left = 90
      Top = 32
      Width = 96
      Height = 21
      CharCase = ecUpperCase
      DropDownAlignment = taLeftJustify
      LookupField = 'MainCode'
      Options = [loColLines, loRowLines]
      Style = csDropDownList
      TabOrder = 0
      AutoDropDown = True
      ShowButton = True
      SeqSearchOptions = [ssoEnabled, ssoCaseSensitive]
      AllowClearKey = True
      OnChange = EditChange
    end
    object NoteTypeCode: TwwDBLookupCombo
      Tag = 20
      Left = 259
      Top = 32
      Width = 47
      Height = 21
      CharCase = ecUpperCase
      DropDownAlignment = taLeftJustify
      LookupField = 'MainCode'
      Options = [loColLines, loRowLines]
      Style = csDropDownList
      TabOrder = 1
      AutoDropDown = True
      ShowButton = True
      SeqSearchOptions = [ssoEnabled, ssoCaseSensitive]
      AllowClearKey = True
      OnChange = EditChange
    end
    object UserResponsible: TwwDBLookupCombo
      Left = 90
      Top = 74
      Width = 96
      Height = 21
      CharCase = ecUpperCase
      DropDownAlignment = taLeftJustify
      LookupField = 'UserID'
      Options = [loColLines, loRowLines]
      Style = csDropDownList
      TabOrder = 3
      AutoDropDown = True
      ShowButton = True
      SeqSearchOptions = [ssoEnabled, ssoCaseSensitive]
      AllowClearKey = True
      OnChange = EditChange
    end
    object DueDate1: TMaskEdit
      Left = 473
      Top = 81
      Width = 72
      Height = 21
      EditMask = '!99/99/0000;1;_'
      MaxLength = 10
      TabOrder = 5
      Text = '  /  /    '
      Visible = False
      OnChange = EditChange
      OnExit = DueDateExit
    end
    object NoteOpen: TCheckBox
      Left = 259
      Top = 76
      Width = 16
      Height = 17
      TabOrder = 4
      OnClick = EditChange
    end
    object DueDate2: TDateTimePicker
      Left = 359
      Top = 78
      Width = 90
      Height = 21
      CalAlignment = dtaLeft
      Date = 38618.034729456
      Time = 38618.034729456
      DateFormat = dfShort
      DateMode = dmComboBox
      Kind = dtkDate
      ParseInput = False
      TabOrder = 6
      Visible = False
    end
    object DueDate: TEdit
      Left = 457
      Top = 32
      Width = 89
      Height = 21
      TabOrder = 2
      OnChange = EditChange
      OnExit = DueDateExit
    end
  end
  object TimeOfSaleInformationGroupBox: TGroupBox
    Left = 0
    Top = 83
    Width = 592
    Height = 105
    Align = alTop
    Caption = ' Time of Sale Information: '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
    object TotalAssessedValLabel: TLabel
      Left = 162
      Top = 20
      Width = 57
      Height = 14
      Caption = 'Total Value:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object LandAssessedValLabel: TLabel
      Left = 4
      Top = 20
      Width = 58
      Height = 14
      Caption = 'Land Value:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object PropertyClassLabel: TLabel
      Left = 164
      Top = 39
      Width = 48
      Height = 25
      AutoSize = False
      Caption = 'Property Class:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      WordWrap = True
    end
    object RollSectLabel: TLabel
      Left = 4
      Top = 47
      Width = 59
      Height = 14
      Caption = 'Roll Section:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object HomeSteadLabel: TLabel
      Left = 178
      Top = 78
      Width = 50
      Height = 14
      Caption = 'Hstd Code'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object SchoolDistLabel: TLabel
      Left = 342
      Top = 18
      Width = 36
      Height = 14
      Caption = 'School:'
      FocusControl = SchoolDistDBEdit
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label9: TLabel
      Left = 380
      Top = 41
      Width = 57
      Height = 14
      Caption = 'Ownership:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label10: TLabel
      Left = 366
      Top = 71
      Width = 48
      Height = 14
      Caption = 'N/E Coord'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label14: TLabel
      Left = 505
      Top = 67
      Width = 5
      Height = 13
      Caption = '/'
    end
    object DimensionsLabel: TLabel
      Left = 3
      Top = 75
      Width = 57
      Height = 13
      Caption = 'Dimensions:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      Visible = False
    end
    object RollSectionDBEdit: TDBEdit
      Left = 63
      Top = 43
      Width = 20
      Height = 22
      TabStop = False
      Color = clBtnFace
      DataField = 'RollSection'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      ReadOnly = True
      TabOrder = 0
    end
    object SchoolDistDBEdit: TDBEdit
      Left = 392
      Top = 8
      Width = 60
      Height = 22
      TabStop = False
      Color = clBtnFace
      DataField = 'SchoolDistcode'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      ReadOnly = True
      TabOrder = 1
    end
    object OwnershipDBEdit: TDBEdit
      Left = 458
      Top = 32
      Width = 20
      Height = 22
      Color = clBtnFace
      DataField = 'OwnerShipCode'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      ReadOnly = True
      TabOrder = 2
    end
    object EastCordDBEdit: TDBEdit
      Left = 520
      Top = 65
      Width = 50
      Height = 22
      TabStop = False
      Color = clBtnFace
      DataField = 'EastCoord'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      ReadOnly = True
      TabOrder = 3
    end
    object NorhtCoordDBEdit: TDBEdit
      Left = 446
      Top = 66
      Width = 50
      Height = 22
      TabStop = False
      Color = clBtnFace
      DataField = 'NorthCoord'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      ReadOnly = True
      TabOrder = 4
    end
    object LandAVDBEdit: TDBEdit
      Left = 63
      Top = 16
      Width = 76
      Height = 22
      TabStop = False
      Color = clBtnFace
      DataField = 'LandAssessedVal'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      ReadOnly = True
      TabOrder = 5
    end
    object TotalAVDBEdit: TDBEdit
      Left = 233
      Top = 15
      Width = 80
      Height = 22
      TabStop = False
      Color = clBtnFace
      DataField = 'TotAssessedVal'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      ReadOnly = True
      TabOrder = 6
    end
    object PropClassDBEdit: TDBEdit
      Left = 232
      Top = 42
      Width = 40
      Height = 22
      TabStop = False
      Color = clBtnFace
      DataField = 'PropClass'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      ReadOnly = True
      TabOrder = 7
    end
    object HomeSteadDBEdit: TDBEdit
      Left = 240
      Top = 71
      Width = 20
      Height = 22
      TabStop = False
      Color = clBtnFace
      DataField = 'HomeSteadcode'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      ReadOnly = True
      TabOrder = 8
    end
    object EditDimensions: TEdit
      Left = 66
      Top = 71
      Width = 86
      Height = 23
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      ReadOnly = True
      TabOrder = 9
      Visible = False
    end
  end
  object MainQuery: TQuery
    DatabaseName = 'PASsystem'
    Left = 374
    Top = 213
  end
  object ButtonsStateTimer: TTimer
    Enabled = False
    Interval = 10
    OnTimer = ButtonsStateTimerTimer
    Left = 322
    Top = 193
  end
end
