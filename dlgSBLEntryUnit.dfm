object dlgEnterSBL: TdlgEnterSBL
  Left = 300
  Top = 122
  Width = 465
  Height = 155
  Caption = 'Enter SBL'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 29
    Top = 26
    Width = 50
    Height = 13
    Caption = 'Swis Code'
  end
  object Label2: TLabel
    Left = 158
    Top = 26
    Width = 53
    Height = 13
    Caption = 'Subsection'
  end
  object Label3: TLabel
    Left = 108
    Top = 26
    Width = 36
    Height = 13
    Caption = 'Section'
  end
  object Label4: TLabel
    Left = 229
    Top = 26
    Width = 27
    Height = 13
    Caption = 'Block'
  end
  object Label5: TLabel
    Left = 343
    Top = 26
    Width = 30
    Height = 13
    Caption = 'Sublot'
  end
  object Label6: TLabel
    Left = 293
    Top = 26
    Width = 15
    Height = 13
    Caption = 'Lot'
  end
  object Label7: TLabel
    Left = 403
    Top = 26
    Width = 26
    Height = 13
    Caption = 'Suffix'
  end
  object edSection: TEdit
    Left = 107
    Top = 46
    Width = 38
    Height = 21
    MaxLength = 3
    TabOrder = 1
  end
  object edSubsection: TEdit
    Left = 165
    Top = 47
    Width = 38
    Height = 21
    MaxLength = 3
    TabOrder = 2
  end
  object edBlock: TEdit
    Left = 223
    Top = 47
    Width = 38
    Height = 21
    MaxLength = 4
    TabOrder = 3
  end
  object edLot: TEdit
    Left = 281
    Top = 47
    Width = 38
    Height = 21
    MaxLength = 3
    TabOrder = 4
  end
  object edSublot: TEdit
    Left = 339
    Top = 47
    Width = 38
    Height = 21
    MaxLength = 3
    TabOrder = 5
  end
  object edSuffix: TEdit
    Left = 397
    Top = 45
    Width = 38
    Height = 21
    MaxLength = 4
    TabOrder = 6
  end
  object btnOK: TBitBtn
    Left = 134
    Top = 81
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    TabOrder = 7
    OnClick = btnOKClick
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
  object btnCancel: TBitBtn
    Left = 239
    Top = 82
    Width = 75
    Height = 25
    Caption = 'Cancel'
    TabOrder = 8
    OnClick = btnCancelClick
    Glyph.Data = {
      DE010000424DDE01000000000000760000002800000024000000120000000100
      0400000000006801000000000000000000001000000000000000000000000000
      80000080000000808000800000008000800080800000C0C0C000808080000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
      333333333333333333333333000033338833333333333333333F333333333333
      0000333911833333983333333388F333333F3333000033391118333911833333
      38F38F333F88F33300003339111183911118333338F338F3F8338F3300003333
      911118111118333338F3338F833338F3000033333911111111833333338F3338
      3333F8330000333333911111183333333338F333333F83330000333333311111
      8333333333338F3333383333000033333339111183333333333338F333833333
      00003333339111118333333333333833338F3333000033333911181118333333
      33338333338F333300003333911183911183333333383338F338F33300003333
      9118333911183333338F33838F338F33000033333913333391113333338FF833
      38F338F300003333333333333919333333388333338FFF830000333333333333
      3333333333333333333888330000333333333333333333333333333333333333
      0000}
    NumGlyphs = 2
  end
  object cbxSwisCode: TwwDBLookupCombo
    Left = 11
    Top = 46
    Width = 86
    Height = 21
    DropDownAlignment = taLeftJustify
    LookupTable = tbSwisCodes
    LookupField = 'SwisCode'
    Style = csDropDownList
    TabOrder = 0
    AutoDropDown = False
    ShowButton = True
    AllowClearKey = False
  end
  object tbSwisCodes: TTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYSWISCODE'
    TableName = 'TSwisTbl'
    TableType = ttDBase
    Left = 9
    Top = 76
  end
  object dsSwisCodes: TDataSource
    DataSet = tbSwisCodes
    Left = 65
    Top = 71
  end
end
