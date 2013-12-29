object Form1: TForm1
  Left = 288
  Top = 103
  Width = 333
  Height = 202
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object RecCountLabel: TLabel
    Left = 27
    Top = 110
    Width = 74
    Height = 13
    Caption = 'RecCountLabel'
  end
  object StartButton: TBitBtn
    Left = 123
    Top = 134
    Width = 75
    Height = 25
    Caption = 'Start'
    TabOrder = 0
    OnClick = StartButtonClick
    Kind = bkOK
  end
  object AssessmentRadioGroup: TRadioGroup
    Left = 24
    Top = 17
    Width = 144
    Height = 81
    Caption = ' Assessment Year: '
    ItemIndex = 0
    Items.Strings = (
      ' This Year'
      ' Next Year')
    TabOrder = 1
  end
  object ParcelTable: TTable
    DatabaseName = 'PropertyAssessmentSystem'
    IndexName = 'BYACCOUNTNO'
    TableName = 'Tparcelrec'
    TableType = ttDBase
    Left = 255
    Top = 81
  end
  object BillToNameAddressTable: TTable
    DatabaseName = 'Temp'
    TableName = 'qmf_bill_to_addresses_Small'
    TableType = ttDBase
    Left = 223
    Top = 19
  end
end
