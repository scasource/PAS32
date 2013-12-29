object MapRangeEditItemDialog: TMapRangeEditItemDialog
  Left = 220
  Top = 236
  Width = 265
  Height = 222
  Caption = 'Edit Range Item'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object LowValueLabel: TLabel
    Left = 11
    Top = 29
    Width = 53
    Height = 13
    Caption = 'Low Value:'
  end
  object HighValueLabel: TLabel
    Left = 11
    Top = 63
    Width = 55
    Height = 13
    Caption = 'High Value:'
  end
  object Label4: TLabel
    Left = 11
    Top = 98
    Width = 27
    Height = 13
    Caption = 'Color:'
  end
  object ColorShape: TShape
    Left = 92
    Top = 89
    Width = 65
    Height = 25
  end
  object OKButton: TBitBtn
    Left = 35
    Top = 149
    Width = 78
    Height = 31
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 0
    OnClick = OKButtonClick
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
    Left = 144
    Top = 149
    Width = 78
    Height = 31
    TabOrder = 1
    Kind = bkCancel
  end
  object LowValueEdit: TEdit
    Left = 92
    Top = 25
    Width = 121
    Height = 24
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 2
  end
  object HighValueEdit: TEdit
    Left = 92
    Top = 59
    Width = 121
    Height = 24
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 3
  end
  object ColorButton: TButton
    Left = 157
    Top = 89
    Width = 25
    Height = 25
    Caption = '...'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 4
    OnClick = ColorButtonClick
  end
  object ColorDialog: TColorDialog
    Ctl3D = True
    Options = [cdFullOpen]
    Left = 205
    Top = 79
  end
end
