object ExtractMainLayerInformationDialog: TExtractMainLayerInformationDialog
  Left = 234
  Top = 105
  BorderStyle = bsDialog
  Caption = 'Select fields to extract.'
  ClientHeight = 453
  ClientWidth = 331
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Arial'
  Font.Style = [fsBold]
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 16
  object OKButton: TBitBtn
    Left = 130
    Top = 416
    Width = 86
    Height = 33
    Caption = 'OK'
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
    Left = 239
    Top = 416
    Width = 86
    Height = 33
    TabOrder = 1
    OnClick = CancelButtonClick
    Kind = bkCancel
  end
  object Panel1: TPanel
    Left = 4
    Top = 4
    Width = 322
    Height = 410
    BevelInner = bvRaised
    BevelOuter = bvLowered
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 2
    object Label1: TLabel
      Left = 7
      Top = 7
      Width = 165
      Height = 15
      Caption = 'Choose PAS fields to extract:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label2: TLabel
      Left = 7
      Top = 171
      Width = 160
      Height = 15
      Caption = 'Choose GIS fields to extract:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object MapSizeRadioGroup: TRadioGroup
      Left = 10
      Top = 336
      Width = 304
      Height = 64
      Caption = ' Map Size: '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ItemIndex = 0
      Items.Strings = (
        'Search in the current map extent.'
        'Search in the whole map.')
      ParentFont = False
      TabOrder = 0
    end
    object PASFieldsToExtractListBox: TListBox
      Left = 7
      Top = 25
      Width = 310
      Height = 140
      Columns = 2
      ItemHeight = 16
      MultiSelect = True
      TabOrder = 1
    end
    object GISFieldsToExtractListBox: TListBox
      Left = 7
      Top = 189
      Width = 310
      Height = 140
      Columns = 2
      ItemHeight = 16
      MultiSelect = True
      TabOrder = 2
    end
  end
  object ScreenLabelTable: TTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYSCREENNAME_LABELNAME'
    TableName = 'ScreenAndLabelNames'
    TableType = ttDBase
    Left = 147
    Top = 237
  end
end
