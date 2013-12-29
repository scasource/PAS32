object MapCriteriaSearchDialog: TMapCriteriaSearchDialog
  Left = 123
  Top = 64
  Width = 293
  Height = 259
  Caption = 'Map Criteria Search Options'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 24
    Top = 122
    Width = 217
    Height = 26
    AutoSize = False
    Caption = 
      'Do you want to limit the size of the map to the parcels that mat' +
      'ch the search criteria?'
    WordWrap = True
  end
  object ProceedButton: TBitBtn
    Left = 49
    Top = 183
    Width = 75
    Height = 25
    Caption = 'Proceed'
    Default = True
    TabOrder = 0
    OnClick = ProceedButtonClick
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
    Left = 162
    Top = 183
    Width = 75
    Height = 25
    TabOrder = 1
    Kind = bkCancel
  end
  object MapSizeRadioGroup: TRadioGroup
    Left = 24
    Top = 13
    Width = 241
    Height = 87
    Caption = ' Map Size: '
    ItemIndex = 0
    Items.Strings = (
      'Search in the current map extent.'
      'Search in the whole map.')
    TabOrder = 2
  end
  object LimitExtentCheckBox: TCheckBox
    Left = 251
    Top = 127
    Width = 15
    Height = 17
    Alignment = taLeftJustify
    Checked = True
    State = cbChecked
    TabOrder = 3
  end
end
