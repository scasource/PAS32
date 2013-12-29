object AddNewLimitSetDialog: TAddNewLimitSetDialog
  Left = 277
  Top = 42
  Width = 385
  Height = 386
  Caption = 'Add new senior limit set'
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
    Left = 99
    Top = 15
    Width = 158
    Height = 19
    Caption = 'Enter a new limit set:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -16
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Panel1: TPanel
    Left = 7
    Top = 54
    Width = 363
    Height = 287
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 0
    object PreviousButton: TBitBtn
      Left = 198
      Top = 242
      Width = 82
      Height = 32
      Caption = 'Previous'
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnClick = PreviousButtonClick
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000120B0000120B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        3333333333333333333333333333333333333333333333333333333333333333
        3333333333333FF3333333333333003333333333333F77F33333333333009033
        333333333F7737F333333333009990333333333F773337FFFFFF330099999000
        00003F773333377777770099999999999990773FF33333FFFFF7330099999000
        000033773FF33777777733330099903333333333773FF7F33333333333009033
        33333333337737F3333333333333003333333333333377333333333333333333
        3333333333333333333333333333333333333333333333333333333333333333
        3333333333333333333333333333333333333333333333333333}
      NumGlyphs = 2
    end
    object NextButton: TBitBtn
      Left = 280
      Top = 242
      Width = 75
      Height = 32
      Caption = 'Next '
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ModalResult = 2
      ParentFont = False
      TabOrder = 1
      OnClick = NextButtonClick
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000120B0000120B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        3333333333333333333333333333333333333333333333333333333333333333
        3333333333333333333333333333333333333333333FF3333333333333003333
        3333333333773FF3333333333309003333333333337F773FF333333333099900
        33333FFFFF7F33773FF30000000999990033777777733333773F099999999999
        99007FFFFFFF33333F7700000009999900337777777F333F7733333333099900
        33333333337F3F77333333333309003333333333337F77333333333333003333
        3333333333773333333333333333333333333333333333333333333333333333
        3333333333333333333333333333333333333333333333333333}
      Layout = blGlyphRight
      NumGlyphs = 2
    end
    object Notebook: TNotebook
      Left = 4
      Top = 9
      Width = 356
      Height = 217
      TabOrder = 2
      object TPage
        Left = 0
        Top = 0
        Caption = 'LimitType'
        object ApplyToMunicipalityRadioGroup: TRadioGroup
          Left = 14
          Top = 11
          Width = 329
          Height = 164
          Caption = ' Enter Municipality(ies) that this set applies to: '
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Items.Strings = (
            ' County, Town\City, and School'
            ' County and Town\City'
            ' County and School'
            ' School and Town\City'
            ' County'
            ' Town\City'
            ' School')
          ParentFont = False
          TabOrder = 0
          OnClick = ApplyToMunicipalityRadioGroupClick
        end
      end
      object TPage
        Left = 0
        Top = 0
        Caption = 'SwisCode'
        object Label2: TLabel
          Left = 17
          Top = 9
          Width = 307
          Height = 16
          Caption = 'Choose the swis code(s) that this limit applies to:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object SwisCodeListBox: TListBox
          Left = 17
          Top = 31
          Width = 324
          Height = 172
          ItemHeight = 16
          TabOrder = 0
        end
      end
      object TPage
        Left = 0
        Top = 0
        Caption = 'SchoolCode'
        object Label3: TLabel
          Left = 17
          Top = 9
          Width = 321
          Height = 16
          Caption = 'Choose the school code(s) that this limit applies to:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object SchoolCodeListBox: TListBox
          Left = 17
          Top = 31
          Width = 324
          Height = 172
          ItemHeight = 16
          TabOrder = 0
        end
      end
    end
  end
  object SwisCodeTable: TwwTable
    DatabaseName = 'PASsystem'
    TableName = 'tswistbl'
    TableType = ttDBase
    SyncSQLByRange = False
    NarrowSearch = False
    ValidateWithMask = True
    Left = 290
    Top = 3
  end
  object Table1: TTable
    Left = 292
    Top = 357
  end
  object SchoolCodeTable: TTable
    DatabaseName = 'PASsystem'
    TableName = 'TSchoolTbl'
    TableType = ttDBase
    Left = 44
    Top = 9
  end
end
