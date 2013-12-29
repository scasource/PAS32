object ModifyShapefileRecordForm: TModifyShapefileRecordForm
  Left = 160
  Top = -6
  Width = 525
  Height = 473
  Caption = 'Modify properties for parcel record in shapefile.'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object SaveButton: TBitBtn
    Left = 174
    Top = 402
    Width = 89
    Height = 33
    Caption = '&Save'
    TabOrder = 0
    OnClick = SaveButtonClick
    Glyph.Data = {
      DE010000424DDE01000000000000760000002800000024000000120000000100
      0400000000006801000000000000000000001000000000000000000000000000
      8000008000000080800080000000800080008080000080808000C0C0C0000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
      3333333333333333333333330000333333333333333333333333F33333333333
      00003333344333333333333333377F3333333333000033334224333333333333
      337337F3333333330000333422224333333333333733337F3333333300003342
      222224333333333373333337F3333333000034222A22224333333337F337F333
      7F33333300003222A3A2224333333337F3737F337F33333300003A2A333A2224
      33333337F73337F337F33333000033A33333A222433333337333337F337F3333
      0000333333333A222433333333333337F337F33300003333333333A222433333
      333333337F337F33000033333333333A222433333333333337F337F300003333
      33333333A222433333333333337F337F00003333333333333A22433333333333
      3337F37F000033333333333333A223333333333333337F730000333333333333
      333A333333333333333337330000333333333333333333333333333333333333
      0000}
    NumGlyphs = 2
  end
  object CancelButton: TBitBtn
    Left = 279
    Top = 402
    Width = 89
    Height = 33
    Cancel = True
    Caption = '&Cancel'
    TabOrder = 1
    OnClick = CancelButtonClick
    Glyph.Data = {
      DE010000424DDE01000000000000760000002800000024000000120000000100
      0400000000006801000000000000000000001000000000000000000000000000
      8000008000000080800080000000800080008080000080808000C0C0C0000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
      333333333333333333333333000033337733333333333333333F333333333333
      0000333911733333973333333377F333333F3333000033391117333911733333
      37F37F333F77F33300003339111173911117333337F337F3F7337F3300003333
      911117111117333337F3337F733337F3000033333911111111733333337F3337
      3333F7330000333333911111173333333337F333333F73330000333333311111
      7333333333337F3333373333000033333339111173333333333337F333733333
      00003333339111117333333333333733337F3333000033333911171117333333
      33337333337F333300003333911173911173333333373337F337F33300003333
      9117333911173333337F33737F337F33000033333913333391113333337FF733
      37F337F300003333333333333919333333377333337FFF730000333333333333
      3333333333333333333777330000333333333333333333333333333333333333
      0000}
    NumGlyphs = 2
  end
  object CloseButton: TBitBtn
    Left = 384
    Top = 402
    Width = 89
    Height = 33
    Caption = '&Close'
    TabOrder = 2
    OnClick = CloseButtonClick
    Glyph.Data = {
      CE070000424DCE07000000000000360000002800000024000000120000000100
      1800000000009807000000000000000000000000000000000000008080808080
      808080808080808080808080808080808080808080808080C0C0C0C0C0C0FFFF
      FFC0C0C0FFFFFFC0C0C0808080C0C0C0FFFFFF80808080808080808080808080
      8080808080808080808080808080808080008080008080008080008080008080
      008080FFFFFF8000008000008000008000008000000000000000008080808080
      80808080FFFFFFFFFFFFFFFFFF80000080000080000080000080000080808080
      8080808080808080808080808080808080808080808080808080FFFFFF008080
      008080008080FFFFFFFFFFFF808080FFFFFF0080800080800080800080808000
      00FF00FF800080000000000000C0C0C0FFFFFFFFFFFFFFFFFF80000000808000
      8080008080008080808080808080808080808080808080808080808080808080
      808080808080008080008080008080808080808080808080808080FFFFFF0080
      80008080008080008080800000800080FF00FF800080000000FFFFFFFFFFFFFF
      FFFFFFFFFF800000008080008080008080008080008080008080008080008080
      808080FFFFFF808080808080808080FFFFFF008080008080008080808080FFFF
      FF008080008080FFFFFF008080008080008080008080800000FF00FF800080FF
      00FF000000FFFFFFFFFFFFFFFFFFFFFFFF800000008080008080008080008080
      008080008080008080008080808080808080C0C0C0808080808080FFFFFF0080
      80008080008080808080FFFFFF008080008080FFFFFF00808000808000808000
      8080800000800080FF00FF800080000000FFFFFFFFFF00FFFFFFFFFF00800000
      008080008080008080008080008080008080008080008080808080FFFFFF8080
      80C0C0C0808080FFFFFF008080008080008080808080FFFFFF008080008080FF
      FFFF008080008080008080008080800000FF00FF800080FF00FF000000FFFFFF
      FFFFFFFFFFFFFFFFFF8000000080800080800080800080800080800080800080
      80008080808080808080C0C0C0808080808080FFFFFF00808000808000808080
      8080FFFFFF008080008080FFFFFF008080008080008080008080800000800080
      FF00FF800080000000FFFFFFFFFF00FFFFFFFFFF008000000080800080800080
      80008080008080008080008080008080808080FFFFFF808080C0C0C0808080FF
      FFFF008080008080008080808080FFFFFF008080008080FFFFFF008080008080
      008080008080800000FF00FF800080FF00FF000000FFFFFFFFFFFFFFFFFFFFFF
      FF80000000808000808000808000808000808000808000808000808080808080
      8080C0C0C0808080808080FFFFFF008080008080008080808080FFFFFF008080
      008080FFFFFF008080008080008080008080800000800080FF00FF8000800000
      00FFFFFFFFFF00FFFFFFFFFF0080000000808000808000808000808000808000
      8080008080008080808080FFFFFF808080C0C0C0808080FFFFFF008080008080
      008080808080FFFFFF008080008080FFFFFF0080800080800080800080808000
      00FF00FF800080FF00FF000000FFFF00FFFFFFFFFF00FFFFFF80000000808000
      8080008080008080008080008080008080008080808080808080C0C0C0808080
      808080FFFFFF008080008080008080808080FFFFFF008080008080FFFFFF0080
      80008080008080008080800000800080FF00FF800080000000FFFFFFFFFF00FF
      FFFFFFFF00800000008080008080008080008080008080008080008080008080
      808080FFFFFF808080C0C0C0808080FFFFFF008080008080008080808080FFFF
      FF008080008080FFFFFF008080008080008080008080800000FF00FF800080FF
      00FF000000FFFF00FFFFFFFFFF00FFFFFF800000008080008080008080008080
      008080008080008080008080808080808080C0C0C0808080808080FFFFFF0080
      80008080008080808080FFFFFF008080008080FFFFFF00808000808000808000
      8080800000800000800000800000800000800000800000800000800000800000
      008080008080008080008080008080008080008080008080808080FFFFFF8080
      80FFFFFF808080FFFFFFFFFFFFFFFFFFFFFFFF808080FFFFFF008080008080FF
      FFFF008080008080008080008080008080008080008080008080008080008080
      0080800080800080800080800080800080800080800080800080800080800080
      8000808080808080808080808080808080808080808080808080808080808080
      8080008080008080008080FFFFFF008080008080008080008080008080008080
      0000000000000000000000000000000000000080800080800080800080800080
      80008080008080008080008080008080008080008080008080FFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFF008080008080008080008080FFFFFF008080008080
      00808000808000808000808000000000FF0000FF0000FF0000FF000000000080
      8000808000808000808000808000808000808000808000808000808000808000
      8080808080808080808080808080808080808080FFFFFF008080008080008080
      008080FFFFFF0080800080800080800080800080800080800000000000000000
      0000000000000000000000808000808000808000808000808000808000808000
      8080008080008080008080008080808080FFFFFFFFFFFFFFFFFFFFFFFF808080
      FFFFFF008080008080008080008080FFFFFF}
    NumGlyphs = 2
  end
  object ParcelStringGrid: TStringGrid
    Left = 26
    Top = 28
    Width = 473
    Height = 354
    ColCount = 2
    RowCount = 14
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goDrawFocusSelected, goColSizing, goEditing, goTabs, goAlwaysShowEditor]
    ParentFont = False
    TabOrder = 3
    ColWidths = (
      131
      315)
  end
end
