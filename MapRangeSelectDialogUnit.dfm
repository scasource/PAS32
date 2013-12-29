object MapRangeSelectDialog: TMapRangeSelectDialog
  Left = 234
  Top = 105
  ActiveControl = StartValueEdit
  BorderStyle = bsDialog
  Caption = 'Select Map Ranges'
  ClientHeight = 453
  ClientWidth = 331
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Arial'
  Font.Style = [fsBold]
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 16
  object OKButton: TBitBtn
    Left = 130
    Top = 416
    Width = 86
    Height = 33
    Caption = 'OK'
    TabOrder = 0
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
    Left = 239
    Top = 416
    Width = 86
    Height = 33
    TabOrder = 1
    OnClick = CancelButtonClick
    Kind = bkCancel
  end
  object Panel1: TPanel
    Left = 4
    Top = 4
    Width = 322
    Height = 410
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 2
    object StartValueLabel: TLabel
      Left = 10
      Top = 123
      Width = 75
      Height = 16
      Caption = 'Start Value:'
    end
    object EndValueLabel: TLabel
      Left = 10
      Top = 157
      Width = 69
      Height = 16
      Caption = 'End Value:'
    end
    object StartColorShape: TShape
      Left = 91
      Top = 221
      Width = 65
      Height = 25
    end
    object IncrementsLabel: TLabel
      Left = 10
      Top = 191
      Width = 45
      Height = 16
      Caption = 'Levels:'
    end
    object Label4: TLabel
      Left = 10
      Top = 225
      Width = 72
      Height = 16
      Caption = 'Start Color:'
    end
    object EndColorShape: TShape
      Left = 91
      Top = 256
      Width = 65
      Height = 25
    end
    object Label5: TLabel
      Left = 10
      Top = 260
      Width = 66
      Height = 16
      Caption = 'End Color:'
    end
    object ValueRangeHeaderLabel: TLabel
      Left = 15
      Top = 3
      Width = 282
      Height = 50
      AutoSize = False
      Caption = 
        'Please enter the starting and ending value of the range and the ' +
        'increment for each range break.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      WordWrap = True
    end
    object ValueRangeHeaderLabel2: TLabel
      Left = 15
      Top = 66
      Width = 282
      Height = 50
      AutoSize = False
      Caption = 
        'Also please enter the starting and ending colors - the colors in' +
        ' between will be automatically calculated.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      WordWrap = True
    end
    object StartYearLabel: TLabel
      Left = 10
      Top = 294
      Width = 67
      Height = 16
      Caption = 'Start Year:'
      Visible = False
    end
    object EndYearLabel: TLabel
      Left = 173
      Top = 294
      Width = 61
      Height = 16
      Caption = 'End Year:'
      Visible = False
    end
    object CodeRangeHeaderLabel: TLabel
      Left = 15
      Top = 13
      Width = 282
      Height = 84
      AutoSize = False
      Caption = 
        'Since the colors displayed are based on a list of codes rather t' +
        'han a value range, only a color range must be entered.  After yo' +
        'u click OK below, you will get to choose which codes you want to' +
        ' display.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      Visible = False
      WordWrap = True
    end
    object Label1: TLabel
      Left = 138
      Top = 192
      Width = 145
      Height = 14
      Caption = '(How many color breaks?)'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGreen
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object StartValueEdit: TEdit
      Left = 91
      Top = 119
      Width = 121
      Height = 24
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
    end
    object EndValueEdit: TEdit
      Left = 91
      Top = 153
      Width = 121
      Height = 24
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
    end
    object LevelsEdit: TEdit
      Left = 91
      Top = 187
      Width = 34
      Height = 24
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 2
    end
    object StartColorButton: TButton
      Left = 156
      Top = 221
      Width = 25
      Height = 25
      Caption = '...'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 3
      OnClick = SetColorButtonClick
    end
    object EndColorButton: TButton
      Left = 156
      Top = 256
      Width = 25
      Height = 25
      Caption = '...'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 4
      OnClick = SetColorButtonClick
    end
    object StartYearEdit: TMaskEdit
      Left = 91
      Top = 290
      Width = 75
      Height = 24
      TabOrder = 5
      Visible = False
    end
    object EndYearEdit: TMaskEdit
      Left = 238
      Top = 290
      Width = 75
      Height = 24
      TabOrder = 6
      Visible = False
    end
    object MapSizeRadioGroup: TRadioGroup
      Left = 10
      Top = 317
      Width = 304
      Height = 64
      Caption = ' Map Size: '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ItemIndex = 0
      Items.Strings = (
        'Search in the current map extent.'
        'Search in the whole map.')
      ParentFont = False
      TabOrder = 7
    end
    object DisplayLabelsCheckBox: TCheckBox
      Left = 10
      Top = 386
      Width = 185
      Height = 17
      Alignment = taLeftJustify
      Caption = 'Display Labels on Parcels'
      TabOrder = 8
    end
  end
  object ColorDialog: TColorDialog
    Ctl3D = True
    Options = [cdFullOpen]
    Left = 199
    Top = 235
  end
end
