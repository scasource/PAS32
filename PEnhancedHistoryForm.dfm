object EnhancedHistoryForm: TEnhancedHistoryForm
  Left = 54
  Top = 89
  Width = 641
  Height = 460
  Caption = 'Parcel History'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object ParcelCreateLabel: TLabel
    Left = 3
    Top = 377
    Width = 119
    Height = 16
    Caption = 'ParcelCreateLabel'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'System'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object SplitMergeInfoLabel1: TLabel
    Left = 191
    Top = 377
    Width = 138
    Height = 16
    Caption = 'SplitMergeInfoLabel1'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -13
    Font.Name = 'System'
    Font.Style = [fsBold]
    ParentFont = False
    Visible = False
  end
  object SchoolCodeLabel: TLabel
    Left = 3
    Top = 403
    Width = 113
    Height = 16
    Caption = 'SchoolCodeLabel'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clGreen
    Font.Height = -13
    Font.Name = 'System'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object SplitMergeInfoLabel2: TLabel
    Left = 191
    Top = 403
    Width = 138
    Height = 16
    Caption = 'SplitMergeInfoLabel2'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -13
    Font.Name = 'System'
    Font.Style = [fsBold]
    ParentFont = False
    Visible = False
  end
  object CloseButton: TBitBtn
    Left = 540
    Top = 384
    Width = 89
    Height = 33
    Caption = '&Close'
    TabOrder = 0
    OnClick = CloseButtonClick
    Glyph.Data = {
      DE010000424DDE01000000000000760000002800000024000000120000000100
      0400000000006801000000000000000000001000000000000000000000000000
      8000008000000080800080000000800080008080000080808000C0C0C0000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00377777777788
      F8F878F7777777777333333F00004444400777FFF444447777777777F333FF7F
      000033334D5008FFF4333377777777773337777F0000333345D50FFFF4333333
      337F777F3337F33F000033334D5D0FFFF43333333377877F3337F33F00003333
      45D50FEFE4333333337F787F3337F33F000033334D5D0FFFF43333333377877F
      3337F33F0000333345D50FEFE4333333337F787F3337F33F000033334D5D0FFF
      F43333333377877F3337F33F0000333345D50FEFE4333333337F787F3337F33F
      000033334D5D0EFEF43333333377877F3337F33F0000333345D50FEFE4333333
      337F787F3337F33F000033334D5D0EFEF43333333377877F3337F33F00003333
      4444444444333333337F7F7FFFF7F33F00003333333333333333333333777777
      7777333F00003333330000003333333333333FFFFFF3333F00003333330AAAA0
      333333333333777777F3333F00003333330000003333333333337FFFF7F3333F
      0000}
    NumGlyphs = 2
  end
  object PageControl1: TPageControl
    Left = 1
    Top = 5
    Width = 630
    Height = 369
    ActivePage = TabSheet1
    TabOrder = 1
    object TabSheet1: TTabSheet
      Caption = 'Summary'
      object HistoryStringGrid: TStringGrid
        Left = 11
        Top = 16
        Width = 599
        Height = 304
        ColCount = 12
        DefaultDrawing = False
        FixedCols = 0
        RowCount = 12
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'System'
        Font.Style = [fsBold]
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine]
        ParentFont = False
        ScrollBars = ssVertical
        TabOrder = 0
        OnDrawCell = HistoryStringGridDrawCell
        ColWidths = (
          37
          84
          21
          74
          51
          19
          45
          59
          63
          43
          64
          22)
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Detailed'
      ImageIndex = 1
      object HistoryTreeView: TTreeView
        Left = 0
        Top = 0
        Width = 622
        Height = 341
        Align = alClient
        BorderWidth = 1
        Indent = 19
        TabOrder = 0
      end
    end
  end
end
