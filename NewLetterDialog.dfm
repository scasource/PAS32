object NewLetterDialogForm: TNewLetterDialogForm
  Left = 782
  Top = 97
  Width = 317
  Height = 342
  ActiveControl = LetterNameEdit
  Caption = 'Create a New  Letter'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 16
  object Label1: TLabel
    Left = 10
    Top = 28
    Width = 82
    Height = 16
    Caption = 'Letter Name:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 12
    Top = 158
    Width = 249
    Height = 16
    Caption = 'Automatically Include Merge Fields for:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object LetterNameEdit: TEdit
    Left = 102
    Top = 24
    Width = 200
    Height = 24
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
  end
  object AutomaticMergeCheckListBox: TCheckListBox
    Left = 82
    Top = 184
    Width = 145
    Height = 71
    Flat = False
    ItemHeight = 16
    Items.Strings = (
      'Letter Date'
      'Mailing Address'
      'Parcel ID'
      'Legal Address')
    TabOrder = 1
  end
  object OKButton: TBitBtn
    Left = 59
    Top = 274
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
    Left = 165
    Top = 274
    Width = 86
    Height = 33
    TabOrder = 3
    Kind = bkCancel
  end
  object WordProcessorToUseRadioGroup: TRadioGroup
    Left = 10
    Top = 63
    Width = 185
    Height = 78
    Caption = ' Word Processor to Use: '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ItemIndex = 0
    Items.Strings = (
      ' Word'
      ' Word Perfect')
    ParentFont = False
    TabOrder = 4
  end
  object MergeLetterDefinitionsTable: TTable
    DatabaseName = 'PASsystem'
    TableName = 'zmergeletterdefs'
    TableType = ttDBase
    Left = 232
    Top = 99
  end
  object GrievanceLetterCodeTable: TTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYLETTERNAME'
    TableName = 'zglettercodes'
    TableType = ttDBase
    Left = 15
    Top = 117
  end
end
