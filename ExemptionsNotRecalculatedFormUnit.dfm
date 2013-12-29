object ExemptionsNotRecalculatedForm: TExemptionsNotRecalculatedForm
  Left = 350
  Top = 143
  Width = 302
  Height = 446
  BorderIcons = [biSystemMenu]
  Caption = 'Exemptions not Recalulated'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 7
    Top = 8
    Width = 277
    Height = 45
    AutoSize = False
    Caption = 
      'The following exemptions were not recalculated because they appl' +
      'y to mixed use, mobile home or cooperative properties:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    WordWrap = True
  end
  object PrintButton: TBitBtn
    Left = 102
    Top = 368
    Width = 89
    Height = 33
    Caption = '&Print'
    TabOrder = 0
    OnClick = PrintButtonClick
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
  end
  object ExemptionsListView: TListView
    Left = 9
    Top = 60
    Width = 275
    Height = 290
    Columns = <
      item
        Caption = 'Parcel ID'
        Width = 175
      end
      item
        Caption = 'Code'
        Width = 70
      end>
    GridLines = True
    TabOrder = 1
    ViewStyle = vsReport
  end
  object ReportFiler: TReportFiler
    StatusFormat = 'Printing page %p'
    UnitsFactor = 1
    Title = 'PAS Parcel List'
    Orientation = poPortrait
    ScaleX = 100
    ScaleY = 100
    StreamMode = smFile
    OnPrint = ReportPrint
    OnPrintHeader = ReportPrintHeader
    Left = 125
    Top = 312
  end
  object ReportPrinter: TReportPrinter
    StatusFormat = 'Printing page %p'
    UnitsFactor = 1
    Title = 'PAS Parcel List'
    Orientation = poPortrait
    ScaleX = 100
    ScaleY = 100
    OnPrint = ReportPrint
    OnPrintHeader = ReportPrintHeader
    Left = 162
    Top = 313
  end
  object PrintDialog: TPrintDialog
    Copies = 1
    Options = [poPrintToFile, poPageNums]
    Left = 217
    Top = 306
  end
end
