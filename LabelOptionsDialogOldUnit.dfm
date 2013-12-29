object LabelOptionsDialogOld: TLabelOptionsDialogOld
  Left = 2
  Top = 107
  Width = 485
  Height = 398
  Caption = 'Label Options'
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
  object OKButton: TBitBtn
    Left = 243
    Top = 328
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
    Left = 370
    Top = 328
    Width = 86
    Height = 33
    TabOrder = 1
    Kind = bkCancel
  end
  object LabelTypeRadioGroup: TRadioGroup
    Left = 9
    Top = 17
    Width = 226
    Height = 116
    Caption = ' Label Type: '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clTeal
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ItemIndex = 2
    Items.Strings = (
      ' 4" x 1 15/16" (Dot Matrix)'
      ' 4" x 1" (Laser - Avery 5161)'
      ' 2.5" x 1" (Laser - Avery 5160)'
      ' 3.5" x .5" (Laser - Avery 5215)'
      ' Envelope (#10)')
    ParentFont = False
    TabOrder = 2
  end
  object FirstLineRadioGroup: TRadioGroup
    Left = 9
    Top = 141
    Width = 226
    Height = 102
    Caption = ' First Line Shows: '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ItemIndex = 2
    Items.Strings = (
      ' Parcel ID Only'
      ' Parcel ID && Prop Class'
      ' Address Information')
    ParentFont = False
    TabOrder = 3
  end
  object OptionsGroupBox: TGroupBox
    Left = 243
    Top = 17
    Width = 213
    Height = 295
    Caption = ' Miscellaneous Options: '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 4
    object Label10: TLabel
      Left = 11
      Top = 69
      Width = 111
      Height = 16
      Hint = 
        'This is the amount of margin that will be left at the top of the' +
        ' page before printing the first label.  Only adjust if the label' +
        's are not lining up on a lser jet.'
      Caption = 'Laser Top Margin'
    end
    object LaserTopMarginEdit: TEdit
      Left = 150
      Top = 66
      Width = 39
      Height = 24
      Hint = 
        'This is the amount of margin that will be left at the top of the' +
        ' page before printing the first label.  Only adjust if the label' +
        's are not lining up on a lser jet.'
      TabOrder = 2
      Text = '0.66'
    end
    object PrintLabelsBoldCheckBox: TCheckBox
      Left = 11
      Top = 20
      Width = 178
      Height = 17
      Hint = 
        'Check this box if you want the labels to print in bold font.  On' +
        'ly works on laser or bubble jets.'
      Alignment = taLeftJustify
      Caption = 'Print Labels Bold'
      Checked = True
      State = cbChecked
      TabOrder = 0
    end
    object OldAndNewLabelCheckBox: TCheckBox
      Left = 11
      Top = 95
      Width = 178
      Height = 17
      Hint = 
        'This will print a label with the new parcel ID on the first line' +
        ' and the old parcel ID on the second.'
      Alignment = taLeftJustify
      Caption = 'New\Old Parcel IDs'
      TabOrder = 3
      Visible = False
    end
    object PrintSwisCodeOnParcelIDCheckBox: TCheckBox
      Left = 11
      Top = 44
      Width = 178
      Height = 17
      Hint = 
        'If you want the parcel ID on the first line to include the short' +
        ' swis code, check this box.'
      Alignment = taLeftJustify
      Caption = 'Print Swis On Parcel IDs'
      Checked = True
      State = cbChecked
      TabOrder = 1
    end
    object GroupBox1: TGroupBox
      Left = 11
      Top = 164
      Width = 180
      Height = 120
      TabOrder = 4
      object FontSizeLabel: TLabel
        Left = 7
        Top = 42
        Width = 116
        Height = 68
        AutoSize = False
        Caption = 'Font size for Parcel ID labels (10=normal, 18=large)'
        Enabled = False
        WordWrap = True
      end
      object PrintParcelIDOnlyCheckBox: TCheckBox
        Left = 7
        Top = 19
        Width = 151
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Print Parcel ID Only'
        TabOrder = 0
        OnClick = PrintParcelIDOnlyCheckBoxClick
      end
      object FontSizeEdit: TEdit
        Left = 132
        Top = 64
        Width = 26
        Height = 24
        Enabled = False
        TabOrder = 1
        Text = '16'
      end
    end
    object ResidentLabelsCheckBox: TCheckBox
      Left = 11
      Top = 119
      Width = 178
      Height = 17
      Hint = 
        'If you check this box, the word '#39'Resident'#39' will appear instead o' +
        'f the name.'
      Alignment = taLeftJustify
      Caption = 'Resident Labels'
      TabOrder = 5
    end
    object LegalAddressLabelsCheckBox: TCheckBox
      Left = 11
      Top = 144
      Width = 178
      Height = 17
      Hint = 
        'If you check this box, the labels will go to the owner at the le' +
        'gal address in the village or city they live in.'
      Alignment = taLeftJustify
      Caption = 'Legal Address Labels'
      TabOrder = 6
    end
  end
end
