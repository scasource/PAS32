object LabelOptionsDialog: TLabelOptionsDialog
  Left = 124
  Top = 292
  Width = 496
  Height = 438
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
    Left = 259
    Top = 365
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
    Left = 386
    Top = 365
    Width = 86
    Height = 33
    TabOrder = 1
    Kind = bkCancel
  end
  object LabelTypeRadioGroup: TRadioGroup
    Left = 9
    Top = 4
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
    Top = 128
    Width = 226
    Height = 118
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
      ' Address Information'
      ' Account Number && Old ID')
    ParentFont = False
    TabOrder = 3
  end
  object OptionsGroupBox: TGroupBox
    Left = 243
    Top = 4
    Width = 231
    Height = 355
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
      Top = 215
      Width = 208
      Height = 134
      TabOrder = 4
      object FontSizeLabel: TLabel
        Left = 7
        Top = 42
        Width = 160
        Height = 30
        AutoSize = False
        Caption = 'Font size for Parcel ID labels (10=normal, 18=large)'
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        WordWrap = True
      end
      object FontSizeAdditionalLinesLabel: TLabel
        Left = 7
        Top = 82
        Width = 170
        Height = 41
        AutoSize = False
        Caption = 
          'Font size for Parcel ID labels: Additional lines          (10=no' +
          'rmal, 18=large)'
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        WordWrap = True
      end
      object PrintParcelIDOnlyCheckBox: TCheckBox
        Left = 7
        Top = 19
        Width = 186
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Print Parcel ID Only'
        TabOrder = 0
        OnClick = PrintParcelIDOnlyCheckBoxClick
      end
      object FontSizeEdit: TEdit
        Left = 169
        Top = 45
        Width = 26
        Height = 24
        Enabled = False
        TabOrder = 1
        Text = '16'
      end
      object FontSizeAdditionalLinesEdit: TEdit
        Left = 169
        Top = 99
        Width = 26
        Height = 24
        Enabled = False
        TabOrder = 2
        Text = '14'
      end
    end
    object ResidentLabelsCheckBox: TCheckBox
      Left = 11
      Top = 116
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
      Top = 136
      Width = 178
      Height = 17
      Hint = 
        'If you check this box, the labels will go to the owner at the le' +
        'gal address in the village or city they live in.'
      Alignment = taLeftJustify
      Caption = 'Legal Address Labels'
      TabOrder = 6
    end
    object ExtractToExcelCheckBox: TCheckBox
      Left = 11
      Top = 177
      Width = 178
      Height = 17
      Hint = 
        'If you check this box, the labels will also be extracted to Exce' +
        'l.'
      Alignment = taLeftJustify
      Caption = 'Extract to Excel'
      TabOrder = 7
    end
    object CommaDelimitedExtractCheckBox: TCheckBox
      Left = 11
      Top = 198
      Width = 178
      Height = 17
      Alignment = taLeftJustify
      Caption = 'Comma Delimited Extract'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 8
    end
    object EliminateDuplicatesCheckBox: TCheckBox
      Left = 11
      Top = 157
      Width = 178
      Height = 17
      Hint = 
        'If you check this box, labels will not be printed for duplicate ' +
        'mailing addresses (including owner names).'
      Alignment = taLeftJustify
      Caption = 'Eliminate Duplicates'
      TabOrder = 9
    end
  end
  object SaveDialog: TSaveDialog
    DefaultExt = 'csv'
    Left = 142
    Top = 304
  end
end
