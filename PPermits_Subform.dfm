object PermitsEntryDialogForm: TPermitsEntryDialogForm
  Left = 417
  Top = 176
  Width = 600
  Height = 413
  Caption = 'Permit #'
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
  object NoteInformationGroupBox: TGroupBox
    Left = 0
    Top = 31
    Width = 592
    Height = 125
    Align = alTop
    Caption = ' Permit Information: '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    object Label4: TLabel
      Left = 15
      Top = 43
      Width = 56
      Height = 13
      AutoSize = False
      Caption = 'Permit #:'
      WordWrap = True
    end
    object Label6: TLabel
      Left = 221
      Top = 42
      Width = 73
      Height = 16
      Caption = 'Permit Date:'
    end
    object Label1: TLabel
      Left = 430
      Top = 42
      Width = 35
      Height = 16
      Caption = 'Cost: '
    end
    object PermitNumber: TEdit
      Left = 74
      Top = 38
      Width = 106
      Height = 24
      TabOrder = 0
      OnChange = EditChange
    end
    object Entered: TCheckBox
      Left = 15
      Top = 79
      Width = 72
      Height = 17
      Alignment = taLeftJustify
      Caption = 'Entered:'
      TabOrder = 3
      OnClick = EditChange
    end
    object Inspected: TCheckBox
      Left = 221
      Top = 79
      Width = 94
      Height = 17
      Alignment = taLeftJustify
      Caption = 'Inspected:'
      TabOrder = 4
      OnClick = EditChange
    end
    object PermitDate: TMaskEdit
      Left = 305
      Top = 38
      Width = 96
      Height = 24
      EditMask = '!99/99/0000;1;_'
      MaxLength = 10
      TabOrder = 1
      Text = '  /  /    '
      OnChange = EditChange
    end
    object Cost: TEdit
      Left = 468
      Top = 38
      Width = 88
      Height = 24
      TabOrder = 2
      OnChange = EditChange
    end
    object COIssued: TCheckBox
      Left = 429
      Top = 79
      Width = 94
      Height = 17
      Alignment = taLeftJustify
      Caption = 'C\O Issued:'
      TabOrder = 5
      OnClick = EditChange
    end
  end
  object WorkDescription: TMemo
    Left = 0
    Top = 156
    Width = 592
    Height = 223
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Lines.Strings = (
      '')
    ParentFont = False
    TabOrder = 2
    OnChange = EditChange
  end
  object MainQuery: TQuery
    DatabaseName = 'PASsystem'
    Left = 125
    Top = 186
  end
  object ButtonsStateTimer: TTimer
    Enabled = False
    Interval = 10
    OnTimer = ButtonsStateTimerTimer
    Left = 322
    Top = 193
  end
end
