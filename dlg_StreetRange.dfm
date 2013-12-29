object StreetRangeDialog: TStreetRangeDialog
  Left = 394
  Top = 145
  Width = 305
  Height = 259
  ActiveControl = edt_StartingStreetNumber
  Caption = 'Street Range'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 13
  object MainToolBar: TToolBar
    Left = 0
    Top = 0
    Width = 297
    Height = 31
    ButtonHeight = 25
    TabOrder = 2
    object SaveAndExitButton: TSpeedButton
      Left = 0
      Top = 2
      Width = 99
      Height = 25
      Hint = 'Save and Exit'
      Caption = 'Save and E&xit'
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
    object CancelButton: TSpeedButton
      Left = 99
      Top = 2
      Width = 26
      Height = 25
      Hint = 'Cancel'
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
  object StartingRangeGroupBox: TGroupBox
    Left = 10
    Top = 44
    Width = 277
    Height = 78
    Caption = ' Starting Street: '
    TabOrder = 0
    object Label1: TLabel
      Left = 20
      Top = 25
      Width = 41
      Height = 13
      Caption = 'Street #:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label2: TLabel
      Left = 20
      Top = 50
      Width = 31
      Height = 13
      Caption = 'Street:'
    end
    object edt_StartingStreetNumber: TEdit
      Left = 68
      Top = 21
      Width = 56
      Height = 21
      CharCase = ecUpperCase
      TabOrder = 0
    end
    object edt_StartingStreet: TEdit
      Left = 68
      Top = 46
      Width = 204
      Height = 21
      CharCase = ecUpperCase
      TabOrder = 1
    end
  end
  object EndingStreetGroupBox: TGroupBox
    Left = 10
    Top = 130
    Width = 277
    Height = 78
    Caption = ' Ending Street: '
    TabOrder = 1
    object Label3: TLabel
      Left = 20
      Top = 25
      Width = 41
      Height = 13
      Caption = 'Street #:'
    end
    object Label4: TLabel
      Left = 20
      Top = 50
      Width = 31
      Height = 13
      Caption = 'Street:'
    end
    object edt_EndingStreetNumber: TEdit
      Left = 68
      Top = 21
      Width = 56
      Height = 21
      CharCase = ecUpperCase
      TabOrder = 0
    end
    object edt_EndingStreet: TEdit
      Left = 68
      Top = 46
      Width = 204
      Height = 21
      CharCase = ecUpperCase
      TabOrder = 1
    end
  end
end
