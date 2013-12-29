object fmCopyTaxRatesToCoopRoll: TfmCopyTaxRatesToCoopRoll
  Left = 620
  Top = 337
  Width = 299
  Height = 270
  Caption = 'Copy Tax Rates from Main Roll'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 16
  object Label1: TLabel
    Left = 9
    Top = 10
    Width = 264
    Height = 47
    AutoSize = False
    Caption = 
      'Enter the assessment year and collection type that you want to c' +
      'opy from the main roll to the cooperative roll.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    Visible = False
    WordWrap = True
  end
  object btnCopy: TBitBtn
    Left = 104
    Top = 194
    Width = 75
    Height = 29
    Caption = 'Copy'
    TabOrder = 0
    OnClick = btnCopyClick
    Glyph.Data = {
      76010000424D7601000000000000760000002800000020000000100000000100
      04000000000000010000130B0000130B00001000000000000000000000000000
      800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF003333330B7FFF
      FFB0333333777F3333773333330B7FFFFFB0333333777F3333773333330B7FFF
      FFB0333333777F3333773333330B7FFFFFB03FFFFF777FFFFF77000000000077
      007077777777777777770FFFFFFFF00077B07F33333337FFFF770FFFFFFFF000
      7BB07F3FF3FFF77FF7770F00F000F00090077F77377737777F770FFFFFFFF039
      99337F3FFFF3F7F777FF0F0000F0F09999937F7777373777777F0FFFFFFFF999
      99997F3FF3FFF77777770F00F000003999337F773777773777F30FFFF0FF0339
      99337F3FF7F3733777F30F08F0F0337999337F7737F73F7777330FFFF0039999
      93337FFFF7737777733300000033333333337777773333333333}
    NumGlyphs = 2
  end
  object GroupBox1: TGroupBox
    Left = 38
    Top = 66
    Width = 206
    Height = 115
    Caption = ' Collection: '
    TabOrder = 1
    Visible = False
    object Label18: TLabel
      Left = 20
      Top = 33
      Width = 108
      Height = 16
      Caption = 'Assessment Year:'
    end
    object Label17: TLabel
      Left = 20
      Top = 71
      Width = 93
      Height = 16
      Caption = 'Collection Type:'
    end
    object cbCollectionType: TwwDBLookupCombo
      Left = 133
      Top = 67
      Width = 51
      Height = 24
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      CharCase = ecUpperCase
      DropDownAlignment = taLeftJustify
      Selected.Strings = (
        'MainCode'#9'3'#9'Code'#9'F'
        'Description'#9'30'#9'Description')
      LookupTable = tbBillCycleTypes
      LookupField = 'MainCode'
      Options = [loColLines, loRowLines, loTitles]
      Style = csDropDownList
      ParentFont = False
      TabOrder = 1
      AutoDropDown = True
      ShowButton = True
      SeqSearchOptions = [ssoEnabled, ssoCaseSensitive]
      AllowClearKey = False
    end
    object edAssessmentYear: TEdit
      Left = 133
      Top = 29
      Width = 51
      Height = 24
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
    end
  end
  object tbBillCycleTypes: TwwTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYMAINCODE'
    TableName = 'ZBillCollectionType'
    TableType = ttDBase
    SyncSQLByRange = True
    NarrowSearch = False
    ValidateWithMask = True
    Left = 211
    Top = 169
  end
  object dsBillCycleTypes: TDataSource
    DataSet = tbBillCycleTypes
    Left = 57
    Top = 157
  end
end
