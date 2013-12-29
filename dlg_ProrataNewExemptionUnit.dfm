object dlg_ProrataNewExemption: Tdlg_ProrataNewExemption
  Left = 560
  Top = 208
  Width = 344
  Height = 381
  ActiveControl = ed_RollYear
  Caption = 'Enter the new prorated exemption.'
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
    Width = 303
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
      Caption = 
        'Enter the assessment year that this prorated exemption applies t' +
        'o.  '
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
    Left = 17
    Top = 91
    Width = 303
    Height = 204
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
      Width = 72
      Height = 16
      Caption = 'Exemption:'
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
      Width = 101
      Height = 16
      Caption = 'County Amount:'
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
      Width = 119
      Height = 16
      Caption = 'Municipal Amount:'
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
      Width = 101
      Height = 16
      Caption = 'School Amount:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object cb_ExemptionCode: TwwDBLookupCombo
      Left = 139
      Top = 30
      Width = 78
      Height = 24
      DropDownAlignment = taLeftJustify
      Selected.Strings = (
        'ExCode'#9'5'#9'ExCode'#9'F'
        'Description'#9'20'#9'Description'#9'F')
      LookupTable = tb_ExemptionCodes
      LookupField = 'ExCode'
      Style = csDropDownList
      TabOrder = 0
      AutoDropDown = False
      ShowButton = True
      AllowClearKey = False
    end
    object cb_HomesteadCode: TComboBox
      Left = 139
      Top = 63
      Width = 42
      Height = 24
      Style = csDropDownList
      ItemHeight = 16
      TabOrder = 1
      Items.Strings = (
        ''
        'H'
        'N')
    end
    object ed_CountyAmount: TEdit
      Left = 139
      Top = 96
      Width = 85
      Height = 24
      TabOrder = 2
    end
    object ed_MunicipalAmount: TEdit
      Left = 139
      Top = 128
      Width = 85
      Height = 24
      TabOrder = 3
    end
    object ed_SchoolAmount: TEdit
      Left = 139
      Top = 161
      Width = 85
      Height = 24
      TabOrder = 4
    end
  end
  object OKButton: TBitBtn
    Left = 73
    Top = 300
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
    Left = 178
    Top = 300
    Width = 86
    Height = 33
    TabOrder = 3
    Kind = bkCancel
  end
  object tb_ExemptionCodes: TwwTable
    Active = True
    DatabaseName = 'PASsystem'
    IndexName = 'BYEXCODE'
    TableName = 'TExCodeTbl'
    TableType = ttDBase
    SyncSQLByRange = False
    NarrowSearch = False
    ValidateWithMask = True
    Left = 205
    Top = 72
  end
end
