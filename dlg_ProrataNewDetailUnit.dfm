object dlg_ProrataNewDetail: Tdlg_ProrataNewDetail
  Left = 560
  Top = 169
  Width = 364
  Height = 408
  Caption = 'Enter the new prorata detail.'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Arial'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnClose = FormClose
  OnKeyPress = FormKeyPress
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 16
  object gb_ProrataYear: TGroupBox
    Left = 16
    Top = 5
    Width = 324
    Height = 79
    TabOrder = 0
    object Label5: TLabel
      Left = 13
      Top = 53
      Width = 62
      Height = 16
      Caption = 'Roll Year:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label6: TLabel
      Left = 13
      Top = 12
      Width = 280
      Height = 34
      AutoSize = False
      Caption = 'Enter the assessment year that this prorata detail applies to.  '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      WordWrap = True
    end
    object ed_RollYear: TEdit
      Left = 88
      Top = 49
      Width = 64
      Height = 24
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      OnExit = ed_RollYearExit
    end
  end
  object gb_OtherInformation: TGroupBox
    Left = 16
    Top = 91
    Width = 324
    Height = 233
    Caption = ' Other Information:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
    object Label1: TLabel
      Left = 13
      Top = 34
      Width = 34
      Height = 16
      Caption = 'Levy:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label2: TLabel
      Left = 13
      Top = 67
      Width = 112
      Height = 16
      Caption = 'Homestead Code:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label3: TLabel
      Left = 13
      Top = 100
      Width = 34
      Height = 16
      Caption = 'Days:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label4: TLabel
      Left = 13
      Top = 132
      Width = 61
      Height = 16
      Caption = 'Tax Rate:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label7: TLabel
      Left = 13
      Top = 165
      Width = 125
      Height = 16
      Caption = 'Exemption Amount:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label8: TLabel
      Left = 13
      Top = 198
      Width = 81
      Height = 16
      Caption = 'Tax Amount:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label9: TLabel
      Left = 179
      Top = 99
      Width = 36
      Height = 16
      Caption = 'out of'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label10: TLabel
      Left = 255
      Top = 99
      Width = 29
      Height = 16
      Caption = 'days'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object cb_HomesteadCode: TComboBox
      Left = 144
      Top = 62
      Width = 42
      Height = 24
      Style = csDropDownList
      ItemHeight = 16
      TabOrder = 0
      Items.Strings = (
        ''
        'H'
        'N')
    end
    object ed_Days: TEdit
      Left = 144
      Top = 95
      Width = 31
      Height = 24
      TabOrder = 1
    end
    object ed_TaxRate: TEdit
      Left = 144
      Top = 128
      Width = 85
      Height = 24
      TabOrder = 3
    end
    object ed_ExemptionAmount: TEdit
      Left = 144
      Top = 161
      Width = 85
      Height = 24
      TabOrder = 4
      OnExit = ed_ExemptionAmountExit
    end
    object cb_Levy: TComboBox
      Left = 144
      Top = 29
      Width = 173
      Height = 23
      Style = csDropDownList
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ItemHeight = 15
      ParentFont = False
      TabOrder = 5
    end
    object ed_TaxAmount: TEdit
      Left = 144
      Top = 194
      Width = 85
      Height = 24
      TabOrder = 6
    end
    object ed_CalculationDays: TEdit
      Left = 220
      Top = 95
      Width = 31
      Height = 24
      TabOrder = 2
      Text = '365'
    end
  end
  object OKButton: TBitBtn
    Left = 82
    Top = 335
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
    Left = 187
    Top = 335
    Width = 86
    Height = 33
    TabOrder = 3
    Kind = bkCancel
  end
  object tb_LeviesToProrate: TTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYCOLLECTIONTYPE_PRINTORDER'
    TableName = 'LeviesToProrate'
    TableType = ttDBase
    Left = 166
    Top = 80
  end
end
