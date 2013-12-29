object EstimatedTaxLetterForm: TEstimatedTaxLetterForm
  Left = 301
  Top = 167
  Width = 266
  Height = 199
  ActiveControl = EditNewAssessmentAmount
  Caption = 'Estimated tax letter'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 16
  object Label1: TLabel
    Left = 11
    Top = 36
    Width = 151
    Height = 16
    Caption = 'New assessment amount:'
  end
  object EditNewAssessmentAmount: TEdit
    Left = 168
    Top = 32
    Width = 81
    Height = 24
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
  end
  object PrintButton: TBitBtn
    Left = 87
    Top = 124
    Width = 85
    Height = 31
    Caption = 'Print'
    Default = True
    TabOrder = 1
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
  object RAVEEstimatedTaxLetterHeaderTable: TTable
    DatabaseName = 'PASsystem'
    TableName = 'Rave_EstTaxLetterHdr'
    TableType = ttDBase
    Left = 139
    Top = 84
  end
  object RAVEEstimatedTaxLetterDetailsTable: TTable
    DatabaseName = 'PASsystem'
    TableName = 'Rave_EstTaxLetterDtls'
    TableType = ttDBase
    Left = 79
    Top = 52
  end
  object ParcelTable: TTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYTAXROLLYR_SWISSBLKEY'
    TableType = ttDBase
    Left = 40
    Top = 5
  end
  object SwisCodeTable: TTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYSWISCODE'
    TableName = 'TSwisTbl'
    TableType = ttDBase
    Left = 195
    Top = 61
  end
  object AssessmentYearControlTable: TTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYTAXROLLYR'
    TableName = 'TAssmtYrCtlFile'
    TableType = ttDBase
    Left = 32
    Top = 101
  end
end
