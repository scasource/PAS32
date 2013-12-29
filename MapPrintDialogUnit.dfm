object MapPrintDialog: TMapPrintDialog
  Left = 110
  Top = 145
  Width = 696
  Height = 480
  Caption = 'Print the Map'
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
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 688
    Height = 41
    Align = alTop
    BorderWidth = 1
    BorderStyle = bsSingle
    TabOrder = 0
    object Label1: TLabel
      Left = 8
      Top = 12
      Width = 33
      Height = 13
      Caption = 'Printer:'
    end
    object Label2: TLabel
      Left = 278
      Top = 12
      Width = 54
      Height = 13
      Caption = 'Orientation:'
    end
    object Label3: TLabel
      Left = 449
      Top = 12
      Width = 31
      Height = 13
      Caption = 'Paper:'
    end
    object OrientationComboBox: TComboBox
      Left = 338
      Top = 8
      Width = 99
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 0
      Items.Strings = (
        'Portrait'
        'Landscape')
    end
    object PrintButton: TBitBtn
      Left = 607
      Top = 2
      Width = 75
      Height = 34
      Caption = 'Print'
      TabOrder = 1
      OnClick = PrintButtonClick
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000130B0000130B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00300000000000
        00033FFFFFFFFFFFFFFF0888888888888880777777777777777F088888888888
        8880777777777777777F0000000000000000FFFFFFFFFFFFFFFF0F8F8F8F8F8F
        8F80777777777777777F08F8F8F8F8F8F9F0777777777777777F0F8F8F8F8F8F
        8F807777777777777F7F0000000000000000777777777777777F3330FFFFFFFF
        03333337F3FFFF3F7F333330F0000F0F03333337F77773737F333330FFFFFFFF
        03333337F3FF3FFF7F333330F00F000003333337F773777773333330FFFF0FF0
        33333337F3FF7F3733333330F08F0F0333333337F7737F7333333330FFFF0033
        33333337FFFF7733333333300000033333333337777773333333}
      NumGlyphs = 2
    end
    object PrinterComboBox: TwwDBComboBox
      Left = 47
      Top = 8
      Width = 222
      Height = 21
      ShowButton = True
      Style = csDropDown
      MapList = False
      AllowClearKey = False
      DropDownCount = 8
      DropDownWidth = 250
      ItemHeight = 0
      Sorted = False
      TabOrder = 2
      UnboundDataType = wwDefault
      OnChange = PrinterComboBoxChange
    end
    object PaperSizeComboBox: TwwDBComboBox
      Left = 487
      Top = 8
      Width = 115
      Height = 21
      ShowButton = True
      Style = csDropDown
      MapList = False
      AllowClearKey = False
      DropDownCount = 8
      DropDownWidth = 200
      ItemHeight = 0
      Sorted = False
      TabOrder = 3
      UnboundDataType = wwDefault
    end
  end
  object Image: TPMultiImage
    Left = 0
    Top = 41
    Width = 688
    Height = 405
    GrabHandCursor = 5
    Align = alClient
    Scrolling = True
    ShowScrollbars = True
    B_W_CopyFlags = [C_DEL]
    Color = clBtnFace
    Picture.Data = {07544269746D617000000000}
    ImageReadRes = lAutoMatic
    BlitMode = sLight
    ImageWriteRes = sAutoMatic
    TifSaveCompress = sNONE
    TiffPage = 0
    TiffAppend = False
    JPegSaveQuality = 25
    JPegSaveSmooth = 5
    RubberBandBtn = mbLeft
    ScrollbarWidth = 12
    ParentColor = True
    Stretch = True
    TextLeft = 0
    TextTop = 0
    TextRotate = 0
    TabOrder = 1
    ZoomBy = 10
  end
  object ReportPrinter: TReportPrinter
    StatusFormat = 'Printing page %p'
    UnitsFactor = 1
    Title = 'ReportPrinter Report'
    Orientation = poPortrait
    ScaleX = 100
    ScaleY = 100
    Left = 205
    Top = 93
  end
end
