object ViewDataForm: TViewDataForm
  Left = 10
  Top = 132
  Width = 640
  Height = 480
  Caption = 'View Report Data'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object wwDBNavigator1: TwwDBNavigator
    Left = 141
    Top = 368
    Width = 350
    Height = 25
    DataSource = DataSource
    RepeatInterval.InitialDelay = 500
    RepeatInterval.Interval = 100
    object wwDBNavigator1First: TwwNavButton
      Left = 0
      Top = 0
      Width = 25
      Height = 25
      Hint = 'Move to first record'
      ImageIndex = -1
      NumGlyphs = 2
      Spacing = 4
      Transparent = False
      Caption = 'wwDBNavigator1First'
      Enabled = False
      DisabledTextColors.ShadeColor = clGray
      DisabledTextColors.HighlightColor = clBtnHighlight
      Index = 0
      Style = nbsFirst
    end
    object wwDBNavigator1PriorPage: TwwNavButton
      Left = 25
      Top = 0
      Width = 25
      Height = 25
      Hint = 'Move backward 10 records'
      ImageIndex = -1
      NumGlyphs = 2
      Spacing = 4
      Transparent = False
      Caption = 'wwDBNavigator1PriorPage'
      Enabled = False
      DisabledTextColors.ShadeColor = clGray
      DisabledTextColors.HighlightColor = clBtnHighlight
      Index = 1
      Style = nbsPriorPage
    end
    object wwDBNavigator1Prior: TwwNavButton
      Left = 50
      Top = 0
      Width = 25
      Height = 25
      Hint = 'Move to prior record'
      ImageIndex = -1
      NumGlyphs = 2
      Spacing = 4
      Transparent = False
      Caption = 'wwDBNavigator1Prior'
      Enabled = False
      DisabledTextColors.ShadeColor = clGray
      DisabledTextColors.HighlightColor = clBtnHighlight
      Index = 2
      Style = nbsPrior
    end
    object wwDBNavigator1Next: TwwNavButton
      Left = 75
      Top = 0
      Width = 25
      Height = 25
      Hint = 'Move to next record'
      ImageIndex = -1
      NumGlyphs = 2
      Spacing = 4
      Transparent = False
      Caption = 'wwDBNavigator1Next'
      Enabled = False
      DisabledTextColors.ShadeColor = clGray
      DisabledTextColors.HighlightColor = clBtnHighlight
      Index = 3
      Style = nbsNext
    end
    object wwDBNavigator1NextPage: TwwNavButton
      Left = 100
      Top = 0
      Width = 25
      Height = 25
      Hint = 'Move forward 10 records'
      ImageIndex = -1
      NumGlyphs = 2
      Spacing = 4
      Transparent = False
      Caption = 'wwDBNavigator1NextPage'
      Enabled = False
      DisabledTextColors.ShadeColor = clGray
      DisabledTextColors.HighlightColor = clBtnHighlight
      Index = 4
      Style = nbsNextPage
    end
    object wwDBNavigator1Last: TwwNavButton
      Left = 125
      Top = 0
      Width = 25
      Height = 25
      Hint = 'Move to last record'
      ImageIndex = -1
      NumGlyphs = 2
      Spacing = 4
      Transparent = False
      Caption = 'wwDBNavigator1Last'
      Enabled = False
      DisabledTextColors.ShadeColor = clGray
      DisabledTextColors.HighlightColor = clBtnHighlight
      Index = 5
      Style = nbsLast
    end
    object wwDBNavigator1Insert: TwwNavButton
      Left = 150
      Top = 0
      Width = 25
      Height = 25
      Hint = 'Insert new record'
      ImageIndex = -1
      NumGlyphs = 2
      Spacing = 4
      Transparent = False
      Caption = 'wwDBNavigator1Insert'
      Enabled = False
      DisabledTextColors.ShadeColor = clGray
      DisabledTextColors.HighlightColor = clBtnHighlight
      Index = 6
      Style = nbsInsert
    end
    object wwDBNavigator1Delete: TwwNavButton
      Left = 175
      Top = 0
      Width = 25
      Height = 25
      Hint = 'Delete current record'
      ImageIndex = -1
      NumGlyphs = 2
      Spacing = 4
      Transparent = False
      Caption = 'wwDBNavigator1Delete'
      Enabled = False
      DisabledTextColors.ShadeColor = clGray
      DisabledTextColors.HighlightColor = clBtnHighlight
      Index = 7
      Style = nbsDelete
    end
    object wwDBNavigator1Edit: TwwNavButton
      Left = 200
      Top = 0
      Width = 25
      Height = 25
      Hint = 'Edit current record'
      ImageIndex = -1
      NumGlyphs = 2
      Spacing = 4
      Transparent = False
      Caption = 'wwDBNavigator1Edit'
      Enabled = False
      DisabledTextColors.ShadeColor = clGray
      DisabledTextColors.HighlightColor = clBtnHighlight
      Index = 8
      Style = nbsEdit
    end
    object wwDBNavigator1Post: TwwNavButton
      Left = 225
      Top = 0
      Width = 25
      Height = 25
      Hint = 'Post changes of current record'
      ImageIndex = -1
      NumGlyphs = 2
      Spacing = 4
      Transparent = False
      Caption = 'wwDBNavigator1Post'
      Enabled = False
      DisabledTextColors.ShadeColor = clGray
      DisabledTextColors.HighlightColor = clBtnHighlight
      Index = 9
      Style = nbsPost
    end
    object wwDBNavigator1Cancel: TwwNavButton
      Left = 250
      Top = 0
      Width = 25
      Height = 25
      Hint = 'Cancel changes made to current record'
      ImageIndex = -1
      NumGlyphs = 2
      Spacing = 4
      Transparent = False
      Caption = 'wwDBNavigator1Cancel'
      Enabled = False
      DisabledTextColors.ShadeColor = clGray
      DisabledTextColors.HighlightColor = clBtnHighlight
      Index = 10
      Style = nbsCancel
    end
    object wwDBNavigator1Refresh: TwwNavButton
      Left = 275
      Top = 0
      Width = 25
      Height = 25
      Hint = 'Refresh the contents of the dataset'
      ImageIndex = -1
      NumGlyphs = 2
      Spacing = 4
      Transparent = False
      Caption = 'wwDBNavigator1Refresh'
      Enabled = False
      DisabledTextColors.ShadeColor = clGray
      DisabledTextColors.HighlightColor = clBtnHighlight
      Index = 11
      Style = nbsRefresh
    end
    object wwDBNavigator1SaveBookmark: TwwNavButton
      Left = 300
      Top = 0
      Width = 25
      Height = 25
      Hint = 'Bookmark current record'
      ImageIndex = -1
      NumGlyphs = 2
      Spacing = 4
      Transparent = False
      Caption = 'wwDBNavigator1SaveBookmark'
      Enabled = False
      DisabledTextColors.ShadeColor = clGray
      DisabledTextColors.HighlightColor = clBtnHighlight
      Index = 12
      Style = nbsSaveBookmark
    end
    object wwDBNavigator1RestoreBookmark: TwwNavButton
      Left = 325
      Top = 0
      Width = 25
      Height = 25
      Hint = 'Go back to saved bookmark'
      ImageIndex = -1
      NumGlyphs = 2
      Spacing = 4
      Transparent = False
      Caption = 'wwDBNavigator1RestoreBookmark'
      Enabled = False
      DisabledTextColors.ShadeColor = clGray
      DisabledTextColors.HighlightColor = clBtnHighlight
      Index = 13
      Style = nbsRestoreBookmark
    end
  end
  object Grid: TwwDBGrid
    Left = 22
    Top = 19
    Width = 587
    Height = 340
    IniAttributes.Delimiter = ';;'
    TitleColor = clBtnFace
    FixedCols = 0
    ShowHorzScrollBar = True
    EditControlOptions = [ecoCheckboxSingleClick, ecoSearchOwnerForm]
    DataSource = DataSource
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    KeyOptions = [dgEnterToTab, dgAllowDelete, dgAllowInsert]
    MultiSelectOptions = [msoShiftSelect]
    Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit, dgWordWrap, dgPerfectRowFit, dgMultiSelect]
    ParentFont = False
    TabOrder = 1
    TitleAlignment = taLeftJustify
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clBlue
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = [fsBold]
    TitleLines = 1
    TitleButtons = False
    IndicatorColor = icBlack
  end
  object CloseButton: TBitBtn
    Left = 528
    Top = 409
    Width = 89
    Height = 33
    Caption = '&Close'
    TabOrder = 2
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
  object SaveButton: TBitBtn
    Left = 199
    Top = 409
    Width = 89
    Height = 33
    Caption = '&Save'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
    Glyph.Data = {
      76010000424D7601000000000000760000002800000020000000100000000100
      04000000000000010000130B0000130B00001000000000000000000000000000
      800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333330070
      7700333333337777777733333333008088003333333377F73377333333330088
      88003333333377FFFF7733333333000000003FFFFFFF77777777000000000000
      000077777777777777770FFFFFFF0FFFFFF07F3333337F3333370FFFFFFF0FFF
      FFF07F3FF3FF7FFFFFF70F00F0080CCC9CC07F773773777777770FFFFFFFF039
      99337F3FFFF3F7F777F30F0000F0F09999937F7777373777777F0FFFFFFFF999
      99997F3FF3FFF77777770F00F000003999337F773777773777F30FFFF0FF0339
      99337F3FF7F3733777F30F08F0F0337999337F7737F73F7777330FFFF0039999
      93337FFFF7737777733300000033333333337777773333333333}
    NumGlyphs = 2
  end
  object PrintButton: TBitBtn
    Left = 309
    Top = 409
    Width = 89
    Height = 33
    Caption = '&Print'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ModalResult = 1
    ParentFont = False
    TabOrder = 4
    Glyph.Data = {
      76010000424D7601000000000000760000002800000020000000100000000100
      04000000000000010000120B0000120B00001000000000000000000000000000
      800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00300000000000
      0003377777777777777308888888888888807F33333333333337088888888888
      88807FFFFFFFFFFFFFF7000000000000000077777777777777770F8F8F8F8F8F
      8F807F333333333333F708F8F8F8F8F8F9F07F333333333337370F8F8F8F8F8F
      8F807FFFFFFFFFFFFFF7000000000000000077777777777777773330FFFFFFFF
      03333337F3FFFF3F7F333330F0000F0F03333337F77773737F333330FFFFFFFF
      03333337F3FF3FFF7F333330F00F000003333337F773777773333330FFFF0FF0
      33333337F3F37F3733333330F08F0F0333333337F7337F7333333330FFFF0033
      33333337FFFF7733333333300000033333333337777773333333}
    NumGlyphs = 2
    IsControl = True
  end
  object ExportButton: TBitBtn
    Left = 418
    Top = 409
    Width = 89
    Height = 33
    Caption = '&Export'
    TabOrder = 5
    Glyph.Data = {
      76010000424D7601000000000000760000002800000020000000100000000100
      04000000000000010000130B0000130B00001000000000000000000000000000
      800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333303
      333333333333337FF3333333333333903333333333333377FF33333333333399
      03333FFFFFFFFF777FF3000000999999903377777777777777FF0FFFF0999999
      99037F3337777777777F0FFFF099999999907F3FF777777777770F00F0999999
      99037F773777777777730FFFF099999990337F3FF777777777330F00FFFFF099
      03337F773333377773330FFFFFFFF09033337F3FF3FFF77733330F00F0000003
      33337F773777777333330FFFF0FF033333337F3FF7F3733333330F08F0F03333
      33337F7737F7333333330FFFF003333333337FFFF77333333333000000333333
      3333777777333333333333333333333333333333333333333333}
    NumGlyphs = 2
  end
  object Table: TwwTable
    SyncSQLByRange = False
    NarrowSearch = False
    ValidateWithMask = True
    Left = 24
    Top = 405
  end
  object DataSource: TwwDataSource
    DataSet = Table
    Left = 101
    Top = 406
  end
end
