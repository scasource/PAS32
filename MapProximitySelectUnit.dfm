object MapProximitySelectDialog: TMapProximitySelectDialog
  Left = 191
  Top = 122
  Width = 371
  Height = 276
  ActiveControl = ProximityRadiusEdit
  Caption = 'Highlight the proximity from a parcel.'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 16
  object Label2: TLabel
    Left = 11
    Top = 116
    Width = 98
    Height = 16
    Caption = 'Parcels within: '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label1: TLabel
    Left = 167
    Top = 116
    Width = 24
    Height = 16
    Caption = 'feet'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object ProximityTypeRadioGroup: TRadioGroup
    Left = 8
    Top = 7
    Width = 267
    Height = 97
    Caption = ' Proximity Type: '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ItemIndex = 1
    Items.Strings = (
      ' From center point of parcel(s) '
      ' From perimiter of parcel(s)')
    ParentFont = False
    TabOrder = 0
  end
  object LocateButton: TBitBtn
    Left = 8
    Top = 202
    Width = 120
    Height = 33
    Hint = 
      'If you want to choose a different parcel as the center point, cl' +
      'ick here.'
    Caption = 'Locate a parcel'
    TabOrder = 1
    OnClick = LocateButtonClick
    Glyph.Data = {
      76010000424D7601000000000000760000002800000020000000100000000100
      04000000000000010000130B0000130B00001000000000000000000000000000
      800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
      33033333333333333F7F3333333333333000333333333333F777333333333333
      000333333333333F777333333333333000333333333333F77733333333333300
      033333333FFF3F777333333700073B703333333F7773F77733333307777700B3
      33333377333777733333307F8F8F7033333337F333F337F3333377F8F9F8F773
      3333373337F3373F3333078F898F870333337F33F7FFF37F333307F99999F703
      33337F377777337F3333078F898F8703333373F337F33373333377F8F9F8F773
      333337F3373337F33333307F8F8F70333333373FF333F7333333330777770333
      333333773FF77333333333370007333333333333777333333333}
    NumGlyphs = 2
  end
  object OKButton: TBitBtn
    Left = 154
    Top = 202
    Width = 86
    Height = 33
    Caption = 'OK'
    TabOrder = 2
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
    Left = 261
    Top = 202
    Width = 86
    Height = 33
    TabOrder = 3
    OnClick = CancelButtonClick
    Kind = bkCancel
  end
  object PrintLabelsCheckBox: TCheckBox
    Left = 11
    Top = 145
    Width = 119
    Height = 17
    Alignment = taLeftJustify
    Caption = 'Print labels'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 4
  end
  object ProximityRadiusEdit: TEdit
    Left = 116
    Top = 111
    Width = 46
    Height = 24
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 5
  end
  object UseAlreadySelectedParcelsCheckBox: TCheckBox
    Left = 11
    Top = 173
    Width = 273
    Height = 17
    Alignment = taLeftJustify
    Caption = 'Search from already selected parcel(s).'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 6
  end
end
