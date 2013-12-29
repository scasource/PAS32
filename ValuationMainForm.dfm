object ValuationForm: TValuationForm
  Left = 179
  Top = 14
  AutoScroll = False
  Caption = 'Parcel Valuation'
  ClientHeight = 573
  ClientWidth = 792
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  ShowHint = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label32: TLabel
    Left = 23
    Top = 71
    Width = 47
    Height = 13
    Caption = 'Bldg Style'
  end
  object Label33: TLabel
    Left = 23
    Top = 44
    Width = 46
    Height = 13
    Caption = 'Neighbhd'
  end
  object Label34: TLabel
    Left = 111
    Top = 72
    Width = 65
    Height = 16
    Caption = 'Bldg Style'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label35: TLabel
    Left = 111
    Top = 44
    Width = 61
    Height = 16
    Caption = 'Neighbhd'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 792
    Height = 35
    Align = alTop
    TabOrder = 0
    object TitleLabel: TLabel
      Left = 302
      Top = 5
      Width = 188
      Height = 19
      Caption = 'Comparable Value Sheet'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -16
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object TemplateParcelLabel: TLabel
      Left = 598
      Top = 6
      Width = 109
      Height = 16
      Caption = 'Template Parcel:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object GroupBox1: TGroupBox
      Left = 4
      Top = -2
      Width = 122
      Height = 32
      TabOrder = 0
      object ExitValuationSpeedButton: TSpeedButton
        Left = 97
        Top = 6
        Width = 23
        Height = 25
        Hint = 'Exit.'
        Flat = True
        Glyph.Data = {
          76010000424D7601000000000000760000002800000020000000100000000100
          04000000000000010000120B0000120B00001000000000000000000000000000
          800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00330000000000
          03333377777777777F333301BBBBBBBB033333773F3333337F3333011BBBBBBB
          0333337F73F333337F33330111BBBBBB0333337F373F33337F333301110BBBBB
          0333337F337F33337F333301110BBBBB0333337F337F33337F333301110BBBBB
          0333337F337F33337F333301110BBBBB0333337F337F33337F333301110BBBBB
          0333337F337F33337F333301110BBBBB0333337F337FF3337F33330111B0BBBB
          0333337F337733337F333301110BBBBB0333337F337F33337F333301110BBBBB
          0333337F3F7F33337F333301E10BBBBB0333337F7F7F33337F333301EE0BBBBB
          0333337F777FFFFF7F3333000000000003333377777777777333}
        NumGlyphs = 2
        OnClick = ExitValuationSpeedButtonClick
      end
      object LocateSpeedButton: TSpeedButton
        Left = 1
        Top = 6
        Width = 23
        Height = 25
        Hint = 'Locate another parcel.'
        Flat = True
        Glyph.Data = {
          36050000424D3605000000000000360400002800000010000000100000000100
          08000000000000010000C40E0000C40E00000001000000000000000000004000
          000080000000FF000000002000004020000080200000FF200000004000004040
          000080400000FF400000006000004060000080600000FF600000008000004080
          000080800000FF80000000A0000040A0000080A00000FFA0000000C0000040C0
          000080C00000FFC0000000FF000040FF000080FF0000FFFF0000000020004000
          200080002000FF002000002020004020200080202000FF202000004020004040
          200080402000FF402000006020004060200080602000FF602000008020004080
          200080802000FF80200000A0200040A0200080A02000FFA0200000C0200040C0
          200080C02000FFC0200000FF200040FF200080FF2000FFFF2000000040004000
          400080004000FF004000002040004020400080204000FF204000004040004040
          400080404000FF404000006040004060400080604000FF604000008040004080
          400080804000FF80400000A0400040A0400080A04000FFA0400000C0400040C0
          400080C04000FFC0400000FF400040FF400080FF4000FFFF4000000060004000
          600080006000FF006000002060004020600080206000FF206000004060004040
          600080406000FF406000006060004060600080606000FF606000008060004080
          600080806000FF80600000A0600040A0600080A06000FFA0600000C0600040C0
          600080C06000FFC0600000FF600040FF600080FF6000FFFF6000000080004000
          800080008000FF008000002080004020800080208000FF208000004080004040
          800080408000FF408000006080004060800080608000FF608000008080004080
          800080808000FF80800000A0800040A0800080A08000FFA0800000C0800040C0
          800080C08000FFC0800000FF800040FF800080FF8000FFFF80000000A0004000
          A0008000A000FF00A0000020A0004020A0008020A000FF20A0000040A0004040
          A0008040A000FF40A0000060A0004060A0008060A000FF60A0000080A0004080
          A0008080A000FF80A00000A0A00040A0A00080A0A000FFA0A00000C0A00040C0
          A00080C0A000FFC0A00000FFA00040FFA00080FFA000FFFFA0000000C0004000
          C0008000C000FF00C0000020C0004020C0008020C000FF20C0000040C0004040
          C0008040C000FF40C0000060C0004060C0008060C000FF60C0000080C0004080
          C0008080C000FF80C00000A0C00040A0C00080A0C000FFA0C00000C0C00040C0
          C00080C0C000FFC0C00000FFC00040FFC00080FFC000FFFFC0000000FF004000
          FF008000FF00FF00FF000020FF004020FF008020FF00FF20FF000040FF004040
          FF008040FF00FF40FF000060FF004060FF008060FF00FF60FF000080FF004080
          FF008080FF00FF80FF0000A0FF0040A0FF0080A0FF00FFA0FF0000C0FF0040C0
          FF0080C0FF00FFC0FF0000FFFF0040FFFF0080FFFF00FFFFFF00FFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFF0000000000FFFFFFFFFF0000000000FF00FF000000
          FFFFFFFFFF00FF000000FF00FF000000FFFFFFFFFF00FF000000FF0000000000
          0000FF00000000000000FF0000FF000000000000FF0000000000FF0000FF0000
          00920000FF0000000000FF0000FF000000920000FF0000000000FFFF00000000
          000000000000000000FFFFFFFF00FF000000FF00FF000000FFFFFFFFFF000000
          0000FF0000000000FFFFFFFFFFFF000000FFFFFF000000FFFFFFFFFFFFFF00FF
          00FFFFFF00FF00FFFFFFFFFFFFFF000000FFFFFF000000FFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
        OnClick = ViewAnotherParcelButtonClick
      end
      object PrintParcelSpeedButton: TSpeedButton
        Left = 24
        Top = 6
        Width = 23
        Height = 25
        Hint = 'Print the comparable parcels for this parcel.'
        Flat = True
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
        OnClick = PrintButtonClick
      end
      object ExcelSpeedButton: TSpeedButton
        Left = 73
        Top = 6
        Width = 23
        Height = 25
        Hint = 
          'Click this button to extract the parcel IDs, names and addresses' +
          ' of the selected parcels to Excel.'
        Flat = True
        Glyph.Data = {
          F6000000424DF600000000000000760000002800000010000000100000000100
          0400000000008000000000000000000000001000000000000000000000000000
          8000008000000080800080000000800080008080000080808000C0C0C0000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00222222222222
          2222222222222222222222FFFFFFFFFFFF2222F22FFF22222F2222F222F222F2
          2F2222FF22222F22FF2220000000F22FFF22220EEEE022FFFF2222F0EEE022FF
          FF22220EEEE02F2FFF2220EEE0E0F2F2FF220EE00F00FF2F2F2220E0FFF0FFF2
          2F22220FFFFFFFFFFF2222222222222222222222222222222222}
      end
      object SaveSpeedButton: TSpeedButton
        Left = 47
        Top = 6
        Width = 25
        Height = 25
        Hint = 'Save a picture of the map to disk.'
        Flat = True
        Glyph.Data = {
          16020000424D160200000000000076000000280000001A0000001A0000000100
          040000000000A001000000000000000000001000000000000000000000000000
          BF0000BF000000BFBF00BF000000BF00BF00BFBF0000C0C0C000808080000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
          777777777777772D800077777777777777777777777777000000777777777777
          7777777777777700000077777777777777777777777777000000777770000000
          000000007777770000007777700BBBBBBBBBBBB07777770000007777700BBBBB
          BBBBBBB077777700000077777080BBBBBBBBBBBB077777000000777770B0BBBB
          BBBBBBBB07777700000077777080BBBBBBBBBBBB077777000000777770B80BBB
          BBBBBBBBB07777003C007777708B0BBBBBBBBBBBB07777004100777770B80000
          000000000077770045007777708B800000008B0777777700470077777000B80E
          EEE00007777777007200777777770000EEE07777777777005E0077777777770E
          EEE077777777770060007777777770EEE0E07777777777006200777777770EEE
          0700777777777700850077777770EEE077707777777777008700777777770E07
          77777777777777003C007777777770777777777777777700E100777777777777
          7777777777777700440077777777777777777777777777003E00777777777777
          7777777777777700400077777777777777777777777777004500}
      end
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 35
    Width = 792
    Height = 538
    Align = alClient
    BevelInner = bvLowered
    BorderWidth = 4
    TabOrder = 1
    object ScrollBox1: TScrollBox
      Left = 6
      Top = 6
      Width = 780
      Height = 526
      HorzScrollBar.Range = 610
      VertScrollBar.Range = 358
      Align = alClient
      AutoScroll = False
      BorderStyle = bsNone
      TabOrder = 0
      object TLabel
        Left = 278
        Top = 172
        Width = 3
        Height = 13
      end
      object ComparablesTypeRadioGroup: TRadioGroup
        Left = 196
        Top = 119
        Width = 212
        Height = 105
        Caption = ' Choose the comparables type: '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        Items.Strings = (
          'Assessment Comparables'
          'Sales Comparables')
        ParentFont = False
        TabOrder = 0
        Visible = False
      end
      object ValuationPageControl: TPageControl
        Left = 0
        Top = 0
        Width = 780
        Height = 526
        ActivePage = GroupTabSheet
        Align = alClient
        TabOrder = 1
        object TemplateTabSheet: TTabSheet
          Caption = 'Template'
          object Label23: TLabel
            Left = 272
            Top = 423
            Width = 44
            Height = 16
            Caption = '# Baths'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
          end
          object Panel7: TPanel
            Left = 0
            Top = 0
            Width = 772
            Height = 78
            Align = alTop
            TabOrder = 0
            object TotalAvDBText: TDBText
              Left = 357
              Top = 31
              Width = 110
              Height = 17
              DataField = 'TotalAssessedVal'
              DataSource = AssessmentDataSource
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clGreen
              Font.Height = -13
              Font.Name = 'Arial'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object LandAvDBText: TDBText
              Left = 357
              Top = 5
              Width = 110
              Height = 17
              DataField = 'LandAssessedVal'
              DataSource = AssessmentDataSource
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clGreen
              Font.Height = -13
              Font.Name = 'Arial'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object Label2: TLabel
              Left = 534
              Top = 56
              Width = 41
              Height = 16
              Caption = 'Depth:'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clNavy
              Font.Height = -13
              Font.Name = 'Arial'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object Label3: TLabel
              Left = 534
              Top = 31
              Width = 61
              Height = 16
              Caption = 'Frontage:'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clNavy
              Font.Height = -13
              Font.Name = 'Arial'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object Label4: TLabel
              Left = 534
              Top = 5
              Width = 57
              Height = 16
              Caption = 'Acreage:'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clNavy
              Font.Height = -13
              Font.Name = 'Arial'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object Label5: TLabel
              Left = 271
              Top = 31
              Width = 77
              Height = 16
              Caption = 'Total Value:'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clNavy
              Font.Height = -13
              Font.Name = 'Arial'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object Label6: TLabel
              Left = 271
              Top = 5
              Width = 77
              Height = 16
              Caption = 'Land Value:'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clNavy
              Font.Height = -13
              Font.Name = 'Arial'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object Label7: TLabel
              Left = 9
              Top = 56
              Width = 95
              Height = 16
              Caption = 'Res/Com Sites:'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clNavy
              Font.Height = -13
              Font.Name = 'Arial'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object ResSiteCntLabel: TLabel
              Left = 118
              Top = 56
              Width = 7
              Height = 16
              Caption = '0'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clGreen
              Font.Height = -13
              Font.Name = 'Arial'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object CommercialSiteCntLabel: TLabel
              Left = 141
              Top = 56
              Width = 7
              Height = 16
              Caption = '0'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clGreen
              Font.Height = -13
              Font.Name = 'Arial'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object Label10: TLabel
              Left = 131
              Top = 56
              Width = 4
              Height = 16
              Caption = '/'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clNavy
              Font.Height = -13
              Font.Name = 'Arial'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object DepthDisplayLabel: TLabel
              Left = 609
              Top = 56
              Width = 7
              Height = 16
              Caption = '0'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clGreen
              Font.Height = -13
              Font.Name = 'Arial'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object FrontageDisplayLabel: TLabel
              Left = 609
              Top = 31
              Width = 7
              Height = 16
              Caption = '0'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clGreen
              Font.Height = -13
              Font.Name = 'Arial'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object AcreDisplayLabel: TLabel
              Left = 609
              Top = 5
              Width = 7
              Height = 16
              Caption = '0'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clGreen
              Font.Height = -13
              Font.Name = 'Arial'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object TemplateLAddrLabel: TLabel
              Left = 9
              Top = 31
              Width = 134
              Height = 16
              Caption = 'TemplateLAddrLabel'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clNavy
              Font.Height = -13
              Font.Name = 'Arial'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object TemplateNameLabel: TLabel
              Left = 9
              Top = 5
              Width = 133
              Height = 16
              Caption = 'TemplateNameLabel'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clNavy
              Font.Height = -13
              Font.Name = 'Arial'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object SalePriceLabel: TLabel
              Left = 271
              Top = 56
              Width = 70
              Height = 16
              Caption = 'Sale Price:'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clNavy
              Font.Height = -13
              Font.Name = 'Arial'
              Font.Style = [fsBold]
              ParentFont = False
            end
          end
          object Panel6: TPanel
            Left = 0
            Top = 78
            Width = 772
            Height = 420
            Align = alClient
            TabOrder = 1
            object GroupBox4: TGroupBox
              Left = 7
              Top = 11
              Width = 294
              Height = 327
              Caption = ' Site Characteristics: '
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
              Font.Name = 'MS Sans Serif'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 0
              object Label15: TLabel
                Left = 8
                Top = 242
                Width = 32
                Height = 13
                Caption = 'Water:'
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -12
                Font.Name = 'MS Sans Serif'
                Font.Style = []
                ParentFont = False
              end
              object Label16: TLabel
                Left = 8
                Top = 198
                Width = 33
                Height = 13
                Caption = 'Sewer:'
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -12
                Font.Name = 'MS Sans Serif'
                Font.Style = []
                ParentFont = False
              end
              object Label17: TLabel
                Left = 8
                Top = 154
                Width = 36
                Height = 13
                Caption = 'Zoning:'
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -12
                Font.Name = 'MS Sans Serif'
                Font.Style = []
                ParentFont = False
              end
              object Label18: TLabel
                Left = 8
                Top = 286
                Width = 48
                Height = 13
                Caption = 'Year Built:'
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -12
                Font.Name = 'MS Sans Serif'
                Font.Style = []
                ParentFont = False
              end
              object Label19: TLabel
                Left = 8
                Top = 110
                Width = 66
                Height = 13
                Caption = 'Building Style:'
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -12
                Font.Name = 'MS Sans Serif'
                Font.Style = []
                ParentFont = False
              end
              object Label20: TLabel
                Left = 8
                Top = 66
                Width = 70
                Height = 13
                Caption = 'Neighborhood:'
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -12
                Font.Name = 'MS Sans Serif'
                Font.Style = []
                ParentFont = False
              end
              object Label21: TLabel
                Left = 8
                Top = 22
                Width = 53
                Height = 13
                Caption = 'Prop Class:'
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -12
                Font.Name = 'MS Sans Serif'
                Font.Style = []
                ParentFont = False
              end
              object PropertyClassText: TDBText
                Left = 142
                Top = 18
                Width = 143
                Height = 25
                DataField = 'Description'
                DataSource = PropertyClassDataSource
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clTeal
                Font.Height = -12
                Font.Name = 'Arial'
                Font.Style = [fsBold]
                ParentFont = False
                WordWrap = True
              end
              object NeighborhoodText: TDBText
                Left = 142
                Top = 62
                Width = 143
                Height = 25
                DataField = 'Description'
                DataSource = NeighborhoodDataSource
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clTeal
                Font.Height = -12
                Font.Name = 'Arial'
                Font.Style = [fsBold]
                ParentFont = False
                WordWrap = True
              end
              object BuildingStyleText: TDBText
                Left = 142
                Top = 106
                Width = 143
                Height = 25
                DataField = 'Description'
                DataSource = BuildingStyleDataSource
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clTeal
                Font.Height = -12
                Font.Name = 'Arial'
                Font.Style = [fsBold]
                ParentFont = False
                WordWrap = True
              end
              object ZoningText: TDBText
                Left = 142
                Top = 150
                Width = 143
                Height = 25
                DataField = 'Description'
                DataSource = ZoningDataSource
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clTeal
                Font.Height = -12
                Font.Name = 'Arial'
                Font.Style = [fsBold]
                ParentFont = False
                WordWrap = True
              end
              object SewerText: TDBText
                Left = 142
                Top = 194
                Width = 143
                Height = 25
                DataField = 'Description'
                DataSource = SewerDataSource
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clTeal
                Font.Height = -12
                Font.Name = 'Arial'
                Font.Style = [fsBold]
                ParentFont = False
                WordWrap = True
              end
              object WaterText: TDBText
                Left = 142
                Top = 238
                Width = 143
                Height = 25
                DataField = 'Description'
                DataSource = WaterDataSource
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clTeal
                Font.Height = -12
                Font.Name = 'Arial'
                Font.Style = [fsBold]
                ParentFont = False
                WordWrap = True
              end
              object WaterLookup: TwwDBLookupCombo
                Tag = 60
                Left = 84
                Top = 238
                Width = 51
                Height = 24
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clBlue
                Font.Height = -13
                Font.Name = 'Arial'
                Font.Style = [fsBold]
                DropDownAlignment = taLeftJustify
                Selected.Strings = (
                  'MainCode'#9'2'#9'MainCode'
                  'Description'#9'30'#9'Description')
                LookupTable = WaterTable
                LookupField = 'MainCode'
                Options = [loColLines, loRowLines]
                Style = csDropDownList
                ParentFont = False
                TabOrder = 0
                AutoDropDown = True
                ShowButton = True
                AllowClearKey = False
              end
              object SewerLookup: TwwDBLookupCombo
                Tag = 50
                Left = 84
                Top = 195
                Width = 51
                Height = 24
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clBlue
                Font.Height = -13
                Font.Name = 'Arial'
                Font.Style = [fsBold]
                DropDownAlignment = taLeftJustify
                Selected.Strings = (
                  'MainCode'#9'2'#9'MainCode'
                  'Description'#9'30'#9'Description')
                LookupTable = SewerTable
                LookupField = 'MainCode'
                Options = [loColLines, loRowLines]
                Style = csDropDownList
                ParentFont = False
                TabOrder = 1
                AutoDropDown = True
                ShowButton = True
                AllowClearKey = False
              end
              object ZoningLookup: TwwDBLookupCombo
                Tag = 40
                Left = 84
                Top = 151
                Width = 51
                Height = 24
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clBlue
                Font.Height = -13
                Font.Name = 'Arial'
                Font.Style = [fsBold]
                DropDownAlignment = taLeftJustify
                Selected.Strings = (
                  'MainCode'#9'5'#9'MainCode'
                  'Description'#9'30'#9'Description')
                LookupTable = ZoningTable
                LookupField = 'MainCode'
                Options = [loColLines, loRowLines]
                Style = csDropDownList
                ParentFont = False
                TabOrder = 2
                AutoDropDown = True
                ShowButton = True
                AllowClearKey = False
              end
              object BuildingStyleLookup: TwwDBLookupCombo
                Tag = 30
                Left = 84
                Top = 107
                Width = 51
                Height = 24
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clBlue
                Font.Height = -13
                Font.Name = 'Arial'
                Font.Style = [fsBold]
                DropDownAlignment = taLeftJustify
                Selected.Strings = (
                  'MainCode'#9'2'#9'MainCode'
                  'Description'#9'30'#9'Description')
                LookupTable = BuildingStyleTable
                LookupField = 'MainCode'
                Options = [loColLines, loRowLines]
                Style = csDropDownList
                ParentFont = False
                TabOrder = 3
                AutoDropDown = True
                ShowButton = True
                AllowClearKey = False
              end
              object NeighborhoodLookup: TwwDBLookupCombo
                Tag = 20
                Left = 84
                Top = 64
                Width = 51
                Height = 24
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clBlue
                Font.Height = -13
                Font.Name = 'Arial'
                Font.Style = [fsBold]
                DropDownAlignment = taLeftJustify
                Selected.Strings = (
                  'MainCode'#9'5'#9'MainCode'
                  'Description'#9'30'#9'Description')
                LookupTable = NeighborhoodTable
                LookupField = 'MainCode'
                Options = [loColLines, loRowLines]
                Style = csDropDownList
                ParentFont = False
                TabOrder = 4
                AutoDropDown = True
                ShowButton = True
                AllowClearKey = False
              end
              object PropertyClassLookup: TwwDBLookupCombo
                Tag = 10
                Left = 85
                Top = 20
                Width = 51
                Height = 24
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clBlue
                Font.Height = -13
                Font.Name = 'Arial'
                Font.Style = [fsBold]
                DropDownAlignment = taLeftJustify
                Selected.Strings = (
                  'MainCode'#9'3'#9'MainCode'
                  'Description'#9'30'#9'Description')
                LookupTable = PropertyClassTable
                LookupField = 'MainCode'
                Options = [loColLines, loRowLines]
                Style = csDropDownList
                ParentFont = False
                TabOrder = 5
                AutoDropDown = True
                ShowButton = True
                AllowClearKey = False
              end
              object YearBuiltEdit: TEdit
                Left = 82
                Top = 282
                Width = 63
                Height = 24
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clBlue
                Font.Height = -13
                Font.Name = 'Arial'
                Font.Style = [fsBold]
                ParentFont = False
                TabOrder = 6
              end
            end
            object GroupBox3: TGroupBox
              Left = 310
              Top = 11
              Width = 456
              Height = 199
              Caption = ' Residence Characteristics: '
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 1
              object Label12: TLabel
                Left = 16
                Top = 154
                Width = 25
                Height = 13
                Caption = 'Area:'
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -12
                Font.Name = 'MS Sans Serif'
                Font.Style = []
                ParentFont = False
              end
              object Label13: TLabel
                Left = 16
                Top = 71
                Width = 32
                Height = 13
                Caption = 'Grade:'
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -12
                Font.Name = 'MS Sans Serif'
                Font.Style = []
                ParentFont = False
              end
              object Label14: TLabel
                Left = 16
                Top = 30
                Width = 47
                Height = 13
                Caption = 'Condition:'
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -12
                Font.Name = 'MS Sans Serif'
                Font.Style = []
                ParentFont = False
              end
              object Label24: TLabel
                Left = 246
                Top = 113
                Width = 60
                Height = 13
                Caption = '# Bedrooms:'
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -12
                Font.Name = 'MS Sans Serif'
                Font.Style = []
                ParentFont = False
              end
              object Label25: TLabel
                Left = 246
                Top = 71
                Width = 45
                Height = 13
                Caption = '# Stories:'
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -12
                Font.Name = 'MS Sans Serif'
                Font.Style = []
                ParentFont = False
              end
              object Label26: TLabel
                Left = 246
                Top = 30
                Width = 68
                Height = 13
                Caption = '1st Floor Area:'
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -12
                Font.Name = 'MS Sans Serif'
                Font.Style = []
                ParentFont = False
              end
              object Label27: TLabel
                Left = 16
                Top = 113
                Width = 50
                Height = 13
                Caption = 'Basement:'
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -12
                Font.Name = 'MS Sans Serif'
                Font.Style = []
                ParentFont = False
              end
              object ConditionText: TDBText
                Left = 125
                Top = 24
                Width = 100
                Height = 25
                DataField = 'Description'
                DataSource = ConditionDataSource
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clTeal
                Font.Height = -12
                Font.Name = 'Arial'
                Font.Style = [fsBold]
                ParentFont = False
                WordWrap = True
              end
              object GradeText: TDBText
                Left = 125
                Top = 65
                Width = 100
                Height = 25
                DataField = 'Description'
                DataSource = GradeDataSource
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clTeal
                Font.Height = -12
                Font.Name = 'Arial'
                Font.Style = [fsBold]
                ParentFont = False
                WordWrap = True
              end
              object BasementTypeText: TDBText
                Left = 125
                Top = 107
                Width = 100
                Height = 25
                DataField = 'Description'
                DataSource = BasementDataSource
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clTeal
                Font.Height = -12
                Font.Name = 'Arial'
                Font.Style = [fsBold]
                ParentFont = False
                WordWrap = True
              end
              object Label28: TLabel
                Left = 246
                Top = 154
                Width = 40
                Height = 13
                Caption = '# Baths:'
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -12
                Font.Name = 'MS Sans Serif'
                Font.Style = []
                ParentFont = False
              end
              object BasementTypeLookup: TwwDBLookupCombo
                Tag = 90
                Left = 73
                Top = 107
                Width = 51
                Height = 24
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clBlue
                Font.Height = -13
                Font.Name = 'Arial'
                Font.Style = [fsBold]
                DropDownAlignment = taLeftJustify
                Selected.Strings = (
                  'MainCode'#9'2'#9'MainCode'
                  'Description'#9'30'#9'Description')
                LookupTable = BasementTable
                LookupField = 'MainCode'
                Options = [loColLines, loRowLines]
                Style = csDropDownList
                ParentFont = False
                TabOrder = 0
                AutoDropDown = True
                ShowButton = True
                AllowClearKey = False
              end
              object GradeLookup: TwwDBLookupCombo
                Tag = 80
                Left = 73
                Top = 65
                Width = 51
                Height = 24
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clBlue
                Font.Height = -13
                Font.Name = 'Arial'
                Font.Style = [fsBold]
                DropDownAlignment = taLeftJustify
                Selected.Strings = (
                  'MainCode'#9'2'#9'MainCode'
                  'Description'#9'30'#9'Description')
                LookupTable = GradeTable
                LookupField = 'MainCode'
                Options = [loColLines, loRowLines]
                Style = csDropDownList
                ParentFont = False
                TabOrder = 1
                AutoDropDown = True
                ShowButton = True
                AllowClearKey = False
              end
              object ConditionLookup: TwwDBLookupCombo
                Tag = 70
                Left = 73
                Top = 24
                Width = 51
                Height = 24
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clBlue
                Font.Height = -13
                Font.Name = 'Arial'
                Font.Style = [fsBold]
                DropDownAlignment = taLeftJustify
                Selected.Strings = (
                  'MainCode'#9'2'#9'MainCode'
                  'Description'#9'30'#9'Description')
                LookupTable = ConditionTable
                LookupField = 'MainCode'
                Options = [loColLines, loRowLines]
                Style = csDropDownList
                ParentFont = False
                TabOrder = 2
                AutoDropDown = True
                ShowButton = True
                AllowClearKey = False
              end
              object NumberOfBedroomsEdit: TEdit
                Left = 320
                Top = 107
                Width = 63
                Height = 24
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clBlue
                Font.Height = -13
                Font.Name = 'Arial'
                Font.Style = [fsBold]
                ParentFont = False
                TabOrder = 3
              end
              object SquareFootAreaEdit: TEdit
                Left = 73
                Top = 148
                Width = 63
                Height = 24
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clBlue
                Font.Height = -13
                Font.Name = 'Arial'
                Font.Style = [fsBold]
                ParentFont = False
                TabOrder = 4
              end
              object FirstFloorAreaEdit: TEdit
                Left = 320
                Top = 24
                Width = 63
                Height = 24
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clBlue
                Font.Height = -13
                Font.Name = 'Arial'
                Font.Style = [fsBold]
                ParentFont = False
                TabOrder = 5
              end
              object NumberOfStoriesEdit: TEdit
                Left = 320
                Top = 65
                Width = 63
                Height = 24
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clBlue
                Font.Height = -13
                Font.Name = 'Arial'
                Font.Style = [fsBold]
                ParentFont = False
                TabOrder = 6
              end
              object NumberOfBathsEdit: TEdit
                Left = 320
                Top = 148
                Width = 63
                Height = 24
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clBlue
                Font.Height = -13
                Font.Name = 'Arial'
                Font.Style = [fsBold]
                ParentFont = False
                TabOrder = 7
              end
            end
            object GroupBox2: TGroupBox
              Left = 311
              Top = 209
              Width = 456
              Height = 207
              Caption = ' Pictures: '
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -13
              Font.Name = 'MS Sans Serif'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 2
              object Panel8: TPanel
                Left = 2
                Top = 18
                Width = 177
                Height = 187
                Align = alLeft
                TabOrder = 0
                object PictureGrid: TwwDBGrid
                  Left = 1
                  Top = 1
                  Width = 175
                  Height = 185
                  Selected.Strings = (
                    'Notes'#9'17'#9'Description')
                  IniAttributes.Delimiter = ';;'
                  TitleColor = clBtnFace
                  FixedCols = 0
                  ShowHorzScrollBar = True
                  Align = alClient
                  DataSource = SubjectPictureDataSource
                  Font.Charset = DEFAULT_CHARSET
                  Font.Color = clWindowText
                  Font.Height = -13
                  Font.Name = 'MS Sans Serif'
                  Font.Style = [fsBold]
                  Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit, dgWordWrap]
                  ParentFont = False
                  ReadOnly = True
                  TabOrder = 0
                  TitleAlignment = taCenter
                  TitleFont.Charset = DEFAULT_CHARSET
                  TitleFont.Color = clBlue
                  TitleFont.Height = -13
                  TitleFont.Name = 'MS Sans Serif'
                  TitleFont.Style = [fsBold]
                  TitleLines = 1
                  TitleButtons = False
                  IndicatorColor = icBlack
                end
              end
            end
            object ApplyNewCharacteristicsButton: TBitBtn
              Left = 72
              Top = 362
              Width = 170
              Height = 41
              Caption = ' Apply Characteristics'
              TabOrder = 3
              Glyph.Data = {
                16020000424D160200000000000076000000280000001A0000001A0000000100
                040000000000A001000000000000000000001000000000000000000000000000
                BF0000BF000000BFBF00BF000000BF00BF00BFBF0000C0C0C000808080000000
                FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
                7777777777777700000077777777777777777777777777000000777777788777
                77777777777777000000777777008877777777777777770000007777770B0887
                7777777777777700000077777770B0887777777777777700000077777770BB08
                87777777777777000000777777770BB088777777777777000000777777770BBB
                08877777777777000000777777000BBBB08877777777770000007777770BBBBB
                BB08777777777700000077777770BBB00007777777777700000077777770BBBB
                08877777777777000000777777770BBBB0887777777777000000777777770BBB
                BB0887777777770000007777770000BBBBB088777777770000007777770BBBBB
                BBBB087777777700000077777770BBBBB000077777777700000077777770BBBB
                BB088777777777000000777777770BBBBBB08877777777000000777777770BBB
                BBBB08877777770000007777777770BBBBBBB0887777770000007777777770BB
                BBBBBB0877777700000077777777700000000007777777000000777777777777
                7777777777777700000077777777777777777777777777000000}
            end
          end
        end
        object GroupTabSheet: TTabSheet
          Caption = 'Groups'
          ImageIndex = 1
          object Panel9: TPanel
            Left = 0
            Top = 98
            Width = 772
            Height = 400
            Align = alClient
            Caption = 'Panel9'
            TabOrder = 0
            object Panel11: TPanel
              Left = 1
              Top = 358
              Width = 770
              Height = 41
              Align = alBottom
              TabOrder = 0
              object AddCharacteristicGroupButton: TBitBtn
                Left = 9
                Top = 5
                Width = 127
                Height = 30
                Caption = 'Add Group'
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -11
                Font.Name = 'MS Sans Serif'
                Font.Style = [fsBold]
                ParentFont = False
                TabOrder = 0
                Glyph.Data = {
                  16020000424D160200000000000076000000280000001A0000001A0000000100
                  040000000000A001000000000000000000001000000000000000000000000000
                  BF0000BF000000BFBF00BF000000BF00BF00BFBF0000C0C0C000808080000000
                  FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
                  777777777777770A000477777777777777777777777777000000777777777777
                  7777777777777700000077777788888888888888777777000000777777888888
                  8888888877777700000077777444444444444488777777000000777774BFBFBF
                  BFBFB488777777000000777774FBFBFBFBFBF488777777000000777774BFBFBF
                  BFBFB488777777070707777774FBFBFBFBFBF488777777000000777774BFBFBF
                  BFBFB488777777070707777774FBFBFBFBFBF488777777000000777774BFBFBF
                  BFBFB488777777070707777774FBFBFBFBFBF488777777000000777774BFBFBF
                  BFBFB488777777070707777774FBFBFBFBFBF488777777000000777774BFBFBF
                  B444447777777707070777F77FFBFBFBF4FB4777777777000000777F7FBFBFBF
                  B4B477777777770404047777FFFBFBFBF447777777777700000077FFFFFFF444
                  44777777777777FFFBFF7777FFF7777777777777777777000000777F7F7F7777
                  77777777777777FBFFFB77777F77F77777777777777777000000777777777777
                  77777777777777FFFBFF77777777777777777777777777000000}
              end
              object DeleteCharacteristicGroupButton: TBitBtn
                Left = 636
                Top = 5
                Width = 127
                Height = 30
                Caption = 'Delete Group'
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -11
                Font.Name = 'MS Sans Serif'
                Font.Style = [fsBold]
                ParentFont = False
                TabOrder = 1
                Glyph.Data = {
                  42010000424D4201000000000000760000002800000011000000110000000100
                  040000000000CC00000000000000000000001000000010000000000000000000
                  BF0000BF000000BFBF00BF000000BF00BF00BFBF0000C0C0C000808080000000
                  FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
                  777770000000777777777777777770000000777777777777770F700000007777
                  0F777777777770000000777000F7777770F770000000777000F777770F777000
                  00007777000F77700F777000000077777000F700F7777000000077777700000F
                  7777700000007777777000F777777000000077777700000F7777700000007777
                  7000F70F7777700000007770000F77700F7770000000770000F7777700F77000
                  00007700F7777777700F70000000777777777777777770000000777777777777
                  777770000000}
              end
            end
            object GroupBox5: TGroupBox
              Left = 1
              Top = 1
              Width = 770
              Height = 357
              Align = alClient
              Caption = ' Comparison Groups: '
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
              Font.Name = 'Arial'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 1
              object CharacteristicGroupsSelectedGrid: TwwDBGrid
                Left = 2
                Top = 17
                Width = 766
                Height = 338
                Selected.Strings = (
                  'SwisCode'#9'6'#9'Swis~Code'
                  'Neighborhood'#9'8'#9'Neighborhood'#9'F'
                  'PropertyClass'#9'3'#9'Class'
                  'BuildingStyleCode'#9'8'#9'Building~Style'
                  'ParcelCount'#9'6'#9'Parcel~Count'
                  'MinSalesPrice'#9'9'#9'Minimum~Sales Price'
                  'MaxSalesPrice'#9'9'#9'Maximum~Sales Price'
                  'MedianSalesPrice'#9'9'#9'Median~Sales Price'
                  'AverageSalesPrice'#9'9'#9'Average~Sales Price'
                  'MinimumPSF'#9'5'#9'Min~PSF'
                  'MaximumPSF'#9'5'#9'Max~PSF'
                  'MedianPSF'#9'5'#9'Median~PSF'
                  'AveragePSF'#9'5'#9'Average~PSF')
                IniAttributes.Delimiter = ';;'
                TitleColor = clBtnFace
                FixedCols = 0
                ShowHorzScrollBar = True
                Align = alClient
                DataSource = CharacteristicGroupsSelectedDataSource
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -12
                Font.Name = 'Arial'
                Font.Style = [fsBold]
                Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit, dgWordWrap]
                ParentFont = False
                ReadOnly = True
                TabOrder = 0
                TitleAlignment = taCenter
                TitleFont.Charset = DEFAULT_CHARSET
                TitleFont.Color = clBlue
                TitleFont.Height = -12
                TitleFont.Name = 'Arial'
                TitleFont.Style = [fsBold]
                TitleLines = 2
                TitleButtons = False
                IndicatorColor = icBlack
              end
            end
          end
          object Panel10: TPanel
            Left = 0
            Top = 0
            Width = 772
            Height = 98
            Align = alTop
            TabOrder = 1
            object Label29: TLabel
              Left = 11
              Top = 56
              Width = 50
              Height = 13
              Caption = 'Bldg Style:'
            end
            object Label30: TLabel
              Left = 11
              Top = 37
              Width = 70
              Height = 13
              Caption = 'Neighborhood:'
            end
            object Label31: TLabel
              Left = 11
              Top = 18
              Width = 53
              Height = 13
              Caption = 'Prop Class:'
            end
            object Pg2BldgStyleLabel: TLabel
              Left = 88
              Top = 56
              Width = 65
              Height = 16
              Caption = 'Bldg Style'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clNavy
              Font.Height = -13
              Font.Name = 'Arial'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object Pg2NeighborHoodLabel: TLabel
              Left = 88
              Top = 37
              Width = 61
              Height = 16
              Caption = 'Neighbhd'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clNavy
              Font.Height = -13
              Font.Name = 'Arial'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object Pg2PropClassLabel: TLabel
              Left = 88
              Top = 18
              Width = 53
              Height = 16
              Caption = 'Prop Cls'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clNavy
              Font.Height = -13
              Font.Name = 'Arial'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object Pg1MinLblLbl: TLabel
              Left = 304
              Top = 37
              Width = 72
              Height = 13
              Caption = 'Minimum Assmt'
            end
            object Label40: TLabel
              Left = 304
              Top = 18
              Width = 61
              Height = 13
              Caption = 'Parcel Count'
            end
            object Pg1MaxDataLbl: TLabel
              Left = 396
              Top = 56
              Width = 121
              Height = 16
              Caption = 'Pg1MaxAssDataLbl'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clNavy
              Font.Height = -13
              Font.Name = 'Arial'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object Pg1MinDataLbl: TLabel
              Left = 396
              Top = 37
              Width = 117
              Height = 16
              Caption = 'Pg1MinAssDataLbl'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clNavy
              Font.Height = -13
              Font.Name = 'Arial'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object Pg1ParcelCntLabel: TLabel
              Left = 396
              Top = 18
              Width = 36
              Height = 16
              Caption = 'Label'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clNavy
              Font.Height = -13
              Font.Name = 'Arial'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object Pg1MaxLblLbl: TLabel
              Left = 304
              Top = 56
              Width = 75
              Height = 13
              Caption = 'Maximum Assmt'
            end
          end
        end
        object MinMaxTabSheet: TTabSheet
          Caption = 'Min-Max'
          ImageIndex = 2
          object Label45: TLabel
            Left = 13
            Top = 22
            Width = 48
            Height = 14
            Caption = 'Bldg Style'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
          end
          object Label46: TLabel
            Left = 12
            Top = 73
            Width = 45
            Height = 14
            Caption = 'Neighbhd'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
          end
          object Label47: TLabel
            Left = 13
            Top = 5
            Width = 40
            Height = 14
            Caption = 'Prop Cls'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
          end
          object Pg3BldgStyleLabel: TLabel
            Left = 77
            Top = 22
            Width = 54
            Height = 14
            Caption = 'Bldg Style'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clNavy
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Pg3NeighborhoodLabel: TLabel
            Left = 77
            Top = 73
            Width = 52
            Height = 14
            Caption = 'Neighbhd'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clNavy
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Pg3PropClassLabel: TLabel
            Left = 77
            Top = 5
            Width = 47
            Height = 14
            Caption = 'Prop Cls'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clNavy
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label51: TLabel
            Left = 13
            Top = 56
            Width = 54
            Height = 14
            Caption = 'Total Value'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
          end
          object Label52: TLabel
            Left = 13
            Top = 39
            Width = 55
            Height = 14
            Caption = 'Land Value'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
          end
          object Pg3TavLabel: TLabel
            Left = 77
            Top = 56
            Width = 37
            Height = 14
            Caption = 'Tot AV'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clNavy
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Pg3LavLabel: TLabel
            Left = 77
            Top = 39
            Width = 46
            Height = 14
            Caption = 'Land AV'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clNavy
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label55: TLabel
            Left = 293
            Top = 2
            Width = 262
            Height = 14
            Caption = '===== Template Property Group Summary ====='
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clMaroon
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Pg2MinLblLbl: TLabel
            Left = 377
            Top = 18
            Width = 74
            Height = 14
            Caption = 'Minimum Assmt'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
          end
          object Pg3Lbl1: TLabel
            Left = 293
            Top = 19
            Width = 61
            Height = 14
            Caption = 'Parcel Count'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
          end
          object Pg2MaxAssLabel: TLabel
            Left = 500
            Top = 36
            Width = 104
            Height = 14
            Caption = 'Pg2MaxAssDataLbl'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clNavy
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object P2MinAssLabel: TLabel
            Left = 378
            Top = 35
            Width = 102
            Height = 14
            Caption = 'Pg2MinAssDataLbl'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clNavy
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Pg2ParcelCntLabel: TLabel
            Left = 308
            Top = 36
            Width = 30
            Height = 14
            Caption = 'Label'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clNavy
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Pg2MaxLblLbl: TLabel
            Left = 495
            Top = 20
            Width = 78
            Height = 14
            Caption = 'Maximum Assmt'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
          end
          object Label42: TLabel
            Left = 5
            Top = 177
            Width = 33
            Height = 16
            Caption = 'Cond'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -13
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label43: TLabel
            Left = 5
            Top = 344
            Width = 35
            Height = 16
            Caption = 'Acres'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -13
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label48: TLabel
            Left = 5
            Top = 311
            Width = 55
            Height = 16
            Caption = '1st St SF'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -13
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label49: TLabel
            Left = 5
            Top = 277
            Width = 54
            Height = 16
            Caption = 'Sq Ft LA'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -13
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label50: TLabel
            Left = 5
            Top = 244
            Width = 46
            Height = 16
            Caption = 'Yr Built'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -13
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label53: TLabel
            Left = 344
            Top = 312
            Width = 51
            Height = 16
            Caption = 'N Coord'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -13
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            Visible = False
          end
          object Label54: TLabel
            Left = 344
            Top = 280
            Width = 50
            Height = 16
            Caption = 'E Coord'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -13
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            Visible = False
          end
          object Label56: TLabel
            Left = 5
            Top = 210
            Width = 39
            Height = 16
            Caption = 'Grade'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -13
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label57: TLabel
            Left = 344
            Top = 153
            Width = 46
            Height = 16
            Caption = '# Baths'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -13
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label58: TLabel
            Left = 344
            Top = 185
            Width = 51
            Height = 16
            Caption = '# Bdrms'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -13
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label59: TLabel
            Left = 344
            Top = 217
            Width = 44
            Height = 16
            Caption = 'Stories'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -13
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label60: TLabel
            Left = 344
            Top = 248
            Width = 55
            Height = 16
            Caption = '# Fireplc'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -13
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label61: TLabel
            Left = 571
            Top = 117
            Width = 60
            Height = 16
            Caption = 'Template'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clPurple
            Font.Height = -13
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label62: TLabel
            Left = 489
            Top = 117
            Width = 63
            Height = 16
            Caption = 'Maximum'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clMaroon
            Font.Height = -13
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label63: TLabel
            Left = 412
            Top = 117
            Width = 59
            Height = 16
            Caption = 'Minimum'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clMaroon
            Font.Height = -13
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label64: TLabel
            Left = 231
            Top = 117
            Width = 60
            Height = 16
            Caption = 'Template'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clPurple
            Font.Height = -13
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label65: TLabel
            Left = 147
            Top = 117
            Width = 63
            Height = 16
            Caption = 'Maximum'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clMaroon
            Font.Height = -13
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label66: TLabel
            Left = 68
            Top = 117
            Width = 59
            Height = 16
            Caption = 'Minimum'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clMaroon
            Font.Height = -13
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label22: TLabel
            Left = 5
            Top = 143
            Width = 52
            Height = 16
            Caption = 'Sale Dts'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -13
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object GradeMin: TEdit
            Left = 65
            Top = 213
            Width = 70
            Height = 24
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clMaroon
            Font.Height = -13
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 0
            Text = 'GradeMin'
          end
          object AcresMin: TEdit
            Left = 65
            Top = 340
            Width = 70
            Height = 24
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clMaroon
            Font.Height = -13
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 1
            Text = 'AcresMin'
          end
          object FFSqFtMin: TEdit
            Left = 65
            Top = 308
            Width = 70
            Height = 24
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clMaroon
            Font.Height = -13
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 2
            Text = 'FFSqFtMin'
          end
          object SqFtMin: TEdit
            Left = 65
            Top = 276
            Width = 70
            Height = 24
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clMaroon
            Font.Height = -13
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 3
            Text = 'SqFtMin'
          end
          object YearBuiltMin: TEdit
            Left = 65
            Top = 244
            Width = 70
            Height = 24
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clMaroon
            Font.Height = -13
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 4
            Text = 'YearBuiltMin'
          end
          object CondMin: TEdit
            Left = 65
            Top = 181
            Width = 70
            Height = 24
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clMaroon
            Font.Height = -13
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 5
            Text = 'CondMin'
          end
          object GradeMax: TEdit
            Left = 145
            Top = 213
            Width = 70
            Height = 24
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clMaroon
            Font.Height = -13
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 6
            Text = 'GradeMax'
          end
          object AcresMax: TEdit
            Left = 145
            Top = 340
            Width = 70
            Height = 24
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clMaroon
            Font.Height = -13
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 7
            Text = 'AcresMax'
          end
          object FFSqFtMax: TEdit
            Left = 145
            Top = 308
            Width = 70
            Height = 24
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clMaroon
            Font.Height = -13
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 8
            Text = 'FFSqFtMax'
          end
          object SqFtMax: TEdit
            Left = 145
            Top = 276
            Width = 70
            Height = 24
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clMaroon
            Font.Height = -13
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 9
            Text = 'SqFtMax'
          end
          object YearBuiltMax: TEdit
            Left = 145
            Top = 244
            Width = 70
            Height = 24
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clMaroon
            Font.Height = -13
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 10
            Text = 'YearBuiltMax'
          end
          object CondMax: TEdit
            Left = 145
            Top = 181
            Width = 70
            Height = 24
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clMaroon
            Font.Height = -13
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 11
            Text = 'CondMax'
          end
          object GradeTmpl: TEdit
            Left = 224
            Top = 213
            Width = 70
            Height = 24
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlue
            Font.Height = -13
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 12
            Text = 'GradeTmpl'
          end
          object AcresTmpl: TEdit
            Left = 224
            Top = 340
            Width = 70
            Height = 24
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlue
            Font.Height = -13
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 13
            Text = 'AcresTmpl'
          end
          object FFSqFtTmpl: TEdit
            Left = 224
            Top = 308
            Width = 70
            Height = 24
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlue
            Font.Height = -13
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 14
            Text = 'FFSqFtTmpl'
          end
          object YearBuiltTmpl: TEdit
            Left = 224
            Top = 245
            Width = 70
            Height = 24
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlue
            Font.Height = -13
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 15
            Text = 'YearBuiltTmpl'
          end
          object CondTmpl: TEdit
            Left = 224
            Top = 181
            Width = 70
            Height = 24
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlue
            Font.Height = -13
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 16
            Text = 'CondTmpl'
          end
          object BedRoomsMin: TEdit
            Left = 408
            Top = 181
            Width = 70
            Height = 24
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clMaroon
            Font.Height = -13
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 17
            Text = 'BedRoomsMin'
          end
          object CrdNorthMin: TEdit
            Left = 408
            Top = 308
            Width = 70
            Height = 24
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clMaroon
            Font.Height = -13
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 18
            Text = 'CrdNorthMin'
            Visible = False
          end
          object CrdEastMin: TEdit
            Left = 408
            Top = 276
            Width = 70
            Height = 24
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clMaroon
            Font.Height = -13
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 19
            Text = 'CrdEastMin'
            Visible = False
          end
          object FirePlacesMin: TEdit
            Left = 408
            Top = 244
            Width = 70
            Height = 24
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clMaroon
            Font.Height = -13
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 20
            Text = 'FirePlacesMin'
          end
          object StoriesMin: TEdit
            Left = 408
            Top = 213
            Width = 70
            Height = 24
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clMaroon
            Font.Height = -13
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 21
            Text = 'StoriesMin'
          end
          object BathsMin: TEdit
            Left = 408
            Top = 149
            Width = 70
            Height = 24
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clMaroon
            Font.Height = -13
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 22
            Text = 'BathsMin'
          end
          object BedRoomsMax: TEdit
            Left = 485
            Top = 181
            Width = 70
            Height = 24
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clMaroon
            Font.Height = -13
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 23
            Text = 'BedRoomsMax'
          end
          object CrdNorthMax: TEdit
            Left = 485
            Top = 308
            Width = 70
            Height = 24
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clMaroon
            Font.Height = -13
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 24
            Text = 'CrdNorthMax'
            Visible = False
          end
          object CrdEastMax: TEdit
            Left = 485
            Top = 276
            Width = 70
            Height = 24
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clMaroon
            Font.Height = -13
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 25
            Text = 'CrdEastMax'
            Visible = False
          end
          object FirePlacesMax: TEdit
            Left = 485
            Top = 244
            Width = 70
            Height = 24
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clMaroon
            Font.Height = -13
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 26
            Text = 'FirePlacesMax'
          end
          object StoriesMax: TEdit
            Left = 485
            Top = 213
            Width = 70
            Height = 24
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clMaroon
            Font.Height = -13
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 27
            Text = 'StoriesMax'
          end
          object BathsMax: TEdit
            Left = 485
            Top = 149
            Width = 70
            Height = 24
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clMaroon
            Font.Height = -13
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 28
            Text = 'BathsMax'
          end
          object BedRoomsTmpl: TEdit
            Left = 562
            Top = 181
            Width = 70
            Height = 24
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlue
            Font.Height = -13
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 29
            Text = 'BedRoomsTmpl'
          end
          object CrdNorthTmpl: TEdit
            Left = 562
            Top = 308
            Width = 70
            Height = 24
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlue
            Font.Height = -13
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 30
            Text = 'CrdNorthTmpl'
            Visible = False
          end
          object CrdEastTmpl: TEdit
            Left = 562
            Top = 276
            Width = 70
            Height = 24
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlue
            Font.Height = -13
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 31
            Text = 'CrdEastTmpl'
            Visible = False
          end
          object FirePlacesTmpl: TEdit
            Left = 562
            Top = 244
            Width = 70
            Height = 24
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlue
            Font.Height = -13
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 32
            Text = 'FirePlacesTmpl'
          end
          object StoriesTmpl: TEdit
            Left = 562
            Top = 213
            Width = 70
            Height = 24
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlue
            Font.Height = -13
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 33
            Text = 'StoriesTmpl'
          end
          object BathsTmpl: TEdit
            Left = 562
            Top = 149
            Width = 70
            Height = 24
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlue
            Font.Height = -13
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 34
            Text = 'BathsTmpl'
          end
          object SqFtTmpl: TEdit
            Left = 224
            Top = 276
            Width = 70
            Height = 24
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlue
            Font.Height = -13
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 35
            Text = 'SqFtTmpl'
          end
          object SaleDateMin: TEdit
            Left = 65
            Top = 149
            Width = 70
            Height = 24
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clMaroon
            Font.Height = -13
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 36
            Text = 'SaleDateMin'
          end
          object SaleDateMax: TEdit
            Left = 145
            Top = 149
            Width = 70
            Height = 24
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clMaroon
            Font.Height = -13
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 37
            Text = 'SaleDateMax'
          end
          object ApplyMinMaxButton: TBitBtn
            Left = 601
            Top = 447
            Width = 152
            Height = 39
            Caption = 'Apply New Ranges'
            TabOrder = 38
            OnClick = ApplyMinMaxButtonClick
            Glyph.Data = {
              16020000424D160200000000000076000000280000001A0000001A0000000100
              040000000000A001000000000000000000001000000000000000000000000000
              BF0000BF000000BFBF00BF000000BF00BF00BFBF0000C0C0C000808080000000
              FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
              7777777777777700000077777777777777777777777777000000777777788777
              77777777777777000000777777008877777777777777770000007777770B0887
              7777777777777700000077777770B0887777777777777700000077777770BB08
              87777777777777000000777777770BB088777777777777000000777777770BBB
              08877777777777000000777777000BBBB08877777777770000007777770BBBBB
              BB08777777777700000077777770BBB00007777777777700000077777770BBBB
              08877777777777000000777777770BBBB0887777777777000000777777770BBB
              BB0887777777770000007777770000BBBBB088777777770000007777770BBBBB
              BBBB087777777700000077777770BBBBB000077777777700000077777770BBBB
              BB088777777777000000777777770BBBBBB08877777777000000777777770BBB
              BBBB08877777770000007777777770BBBBBBB0887777770000007777777770BB
              BBBBBB0877777700000077777777700000000007777777000000777777777777
              7777777777777700000077777777777777777777777777000000}
          end
          object RestoreMinMaxButton: TBitBtn
            Left = 437
            Top = 447
            Width = 152
            Height = 39
            Caption = 'Restore Original Ranges'
            TabOrder = 39
            OnClick = RestoreMinMaxButtonClick
            Glyph.Data = {
              76010000424D7601000000000000760000002800000020000000100000000100
              04000000000000010000130B0000130B00001000000000000000000000000000
              800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
              FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
              3333333333FFFFF3333333333999993333333333F77777FFF333333999999999
              3333333777333777FF33339993707399933333773337F3777FF3399933000339
              9933377333777F3377F3399333707333993337733337333337FF993333333333
              399377F33333F333377F993333303333399377F33337FF333373993333707333
              333377F333777F333333993333101333333377F333777F3FFFFF993333000399
              999377FF33777F77777F3993330003399993373FF3777F37777F399933000333
              99933773FF777F3F777F339993707399999333773F373F77777F333999999999
              3393333777333777337333333999993333333333377777333333}
            NumGlyphs = 2
          end
        end
        object AdjustmentsTabSheet: TTabSheet
          Caption = 'Adjustments'
          ImageIndex = 4
          object Panel3: TPanel
            Left = 0
            Top = 0
            Width = 772
            Height = 33
            Align = alTop
            BevelInner = bvLowered
            TabOrder = 0
            object Label1: TLabel
              Left = 13
              Top = 12
              Width = 74
              Height = 13
              Caption = 'Adjustment Set:'
            end
            object AdjustmentHeaderDescriptionText: TDBText
              Left = 284
              Top = 10
              Width = 218
              Height = 17
              DataField = 'Description'
              DataSource = ValuationAdjustmentHeaderDataSource
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlue
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object AdjustmentHeaderLookupCombo: TwwDBLookupCombo
              Left = 96
              Top = 8
              Width = 172
              Height = 21
              DropDownAlignment = taLeftJustify
              LookupTable = ValuationAdjustmentHeaderTable
              LookupField = 'AdjustmentCode'
              TabOrder = 0
              AutoDropDown = False
              ShowButton = True
              AllowClearKey = False
            end
          end
          object Panel4: TPanel
            Left = 0
            Top = 33
            Width = 772
            Height = 129
            Align = alTop
            BevelInner = bvLowered
            TabOrder = 1
          end
          object Panel5: TPanel
            Left = 0
            Top = 162
            Width = 772
            Height = 336
            Align = alClient
            BevelInner = bvLowered
            TabOrder = 2
            object ValuationAdjustmentDetailGrid: TwwDBGrid
              Left = 2
              Top = 2
              Width = 768
              Height = 332
              Selected.Strings = (
                'SalesPriceLow'#9'10'#9'Sales Price~Low'
                'SalesPriceHigh'#9'10'#9'Sales Price~High'
                'LotSize'#9'8'#9'Lot Size'
                'SFLA'#9'8'#9'Adjust~PSF'
                'YearBuilt'#9'8'#9'Year~Built'
                'Waterfront'#9'8'#9'Water-~front'
                'BasementArea'#9'8'#9'Basement~Area'
                'Fireplaces'#9'8'#9'Per~Fireplace'
                'Garages'#9'8'#9'Per~Garage'#9'F')
              IniAttributes.Delimiter = ';;'
              TitleColor = clBtnFace
              FixedCols = 0
              ShowHorzScrollBar = True
              Align = alClient
              DataSource = ValuationAdjustmentDetailDataSource
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
              TabOrder = 0
              TitleAlignment = taCenter
              TitleFont.Charset = DEFAULT_CHARSET
              TitleFont.Color = clBlue
              TitleFont.Height = -11
              TitleFont.Name = 'MS Sans Serif'
              TitleFont.Style = [fsBold]
              TitleLines = 2
              TitleButtons = False
              IndicatorColor = icBlack
            end
          end
        end
        object GroupMembersTabSheet: TTabSheet
          Caption = 'Group Members'
          ImageIndex = 3
          object GroupMembersGrid: TwwDBGrid
            Left = 0
            Top = 0
            Width = 772
            Height = 457
            Selected.Strings = (
              'IncludeParcel'#9'10'#9'Include'
              'SBLKey'#9'20'#9'Parcel ID'
              'PropertyClass'#9'5'#9'Class'
              'Neighborhood'#9'5'#9'Nbhd'
              'BuildingStyleCode'#9'9'#9'Style'
              'ActualYearBuilt'#9'4'#9'Year~Built'
              'ZoningCode'#9'6'#9'Zoning'
              'ConditionCode'#9'4'#9'Cond'
              'OverallGradeCode'#9'5'#9'Grade'
              'SqFootLivingArea'#9'6'#9'SFLA'
              'NumberOfBathrooms'#9'4'#9'Baths'
              'NumberOfBedrooms'#9'4'#9'Bedrooms'
              'TimeAdjSalesPrice'#9'8'#9'Sale~Price'
              'SaleDate'#9'8'#9'Sale~Date'
              'WaterSupplyCode'#9'5'#9'Water'
              'Acreage'#9'8'#9'Lot~Size'
              'SewerTypeCode'#9'5'#9'Sewer'
              'NumberOfStories'#9'3'#9'Stories'
              'FinishedBasementArea'#9'6'#9'Bsmt~Area'
              'CentralAir'#9'6'#9'Central~Air')
            IniAttributes.Delimiter = ';;'
            TitleColor = clBtnFace
            FixedCols = 0
            ShowHorzScrollBar = True
            Align = alClient
            DataSource = GroupMembersDataSource
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            TabOrder = 0
            TitleAlignment = taCenter
            TitleFont.Charset = DEFAULT_CHARSET
            TitleFont.Color = clBlue
            TitleFont.Height = -11
            TitleFont.Name = 'MS Sans Serif'
            TitleFont.Style = [fsBold]
            TitleLines = 2
            TitleButtons = False
            IndicatorColor = icBlack
          end
          object Panel13: TPanel
            Left = 0
            Top = 457
            Width = 772
            Height = 41
            Align = alBottom
            TabOrder = 1
          end
        end
        object ResultsTabSheet: TTabSheet
          Caption = 'Results'
          ImageIndex = 5
          object ResultsGrid: TcxDBVerticalGrid
            Left = 0
            Top = 0
            Width = 772
            Height = 457
            Align = alClient
            LayoutStyle = lsMultiRecordView
            TabOrder = 0
            DataController.DataSource = ResultsDetailsDataSource
            object ResultsGridSwisCode: TcxDBEditorRow
              Properties.DataBinding.FieldName = 'SwisCode'
            end
            object ResultsGridSBLKey: TcxDBEditorRow
              Properties.DataBinding.FieldName = 'SBLKey'
            end
            object ResultsGridIncludeParcel: TcxDBEditorRow
              Properties.DataBinding.FieldName = 'IncludeParcel'
            end
            object ResultsGridOrder: TcxDBEditorRow
              Properties.DataBinding.FieldName = 'Order'
            end
            object ResultsGridLegalAddress: TcxDBEditorRow
              Properties.DataBinding.FieldName = 'LegalAddress'
            end
            object ResultsGridProximity: TcxDBEditorRow
              Properties.DataBinding.FieldName = 'Proximity'
            end
            object ResultsGridOwner: TcxDBEditorRow
              Properties.DataBinding.FieldName = 'Owner'
            end
            object ResultsGridSchoolCode: TcxDBEditorRow
              Properties.DataBinding.FieldName = 'SchoolCode'
            end
            object ResultsGridPropertyClass: TcxDBEditorRow
              Properties.DataBinding.FieldName = 'PropertyClass'
            end
            object ResultsGridNeighborhood: TcxDBEditorRow
              Properties.DataBinding.FieldName = 'Neighborhood'
            end
            object ResultsGridBuildingStyleCode: TcxDBEditorRow
              Properties.DataBinding.FieldName = 'BuildingStyleCode'
            end
            object ResultsGridSaleDate: TcxDBEditorRow
              Properties.DataBinding.FieldName = 'SaleDate'
            end
            object ResultsGridDeedBook: TcxDBEditorRow
              Properties.DataBinding.FieldName = 'DeedBook'
            end
            object ResultsGridDeedPage: TcxDBEditorRow
              Properties.DataBinding.FieldName = 'DeedPage'
            end
            object ResultsGridUnadjustedSalesPrice: TcxDBEditorRow
              Properties.DataBinding.FieldName = 'UnadjustedSalesPrice'
            end
            object ResultsGridTimeAdjSalesPrice: TcxDBEditorRow
              Properties.DataBinding.FieldName = 'TimeAdjSalesPrice'
            end
            object ResultsGridTimeAdjSalesPSF: TcxDBEditorRow
              Properties.DataBinding.FieldName = 'TimeAdjSalesPSF'
            end
            object ResultsGridLotSize: TcxDBEditorRow
              Properties.DataBinding.FieldName = 'LotSize'
            end
            object ResultsGridLotSizeAdjustment: TcxDBEditorRow
              Properties.DataBinding.FieldName = 'LotSizeAdjustment'
            end
            object ResultsGridYearBuilt: TcxDBEditorRow
              Properties.DataBinding.FieldName = 'YearBuilt'
            end
            object ResultsGridYearBuiltAdjustment: TcxDBEditorRow
              Properties.DataBinding.FieldName = 'YearBuiltAdjustment'
            end
            object ResultsGridSFLA: TcxDBEditorRow
              Properties.DataBinding.FieldName = 'SFLA'
            end
            object ResultsGridSFLAAdjustment: TcxDBEditorRow
              Properties.DataBinding.FieldName = 'SFLAAdjustment'
            end
            object ResultsGridBedrooms: TcxDBEditorRow
              Properties.DataBinding.FieldName = 'Bedrooms'
            end
            object ResultsGridBedroomsAdjustment: TcxDBEditorRow
              Properties.DataBinding.FieldName = 'BedroomsAdjustment'
            end
            object ResultsGridBathrooms: TcxDBEditorRow
              Properties.DataBinding.FieldName = 'Bathrooms'
            end
            object ResultsGridBathroomsAdjustment: TcxDBEditorRow
              Properties.DataBinding.FieldName = 'BathroomsAdjustment'
            end
            object ResultsGridHalfBathrooms: TcxDBEditorRow
              Properties.DataBinding.FieldName = 'HalfBathrooms'
            end
            object ResultsGridHalfBathroomsAdjustment: TcxDBEditorRow
              Properties.DataBinding.FieldName = 'HalfBathroomsAdjustment'
            end
            object ResultsGridBasementCode: TcxDBEditorRow
              Properties.DataBinding.FieldName = 'BasementCode'
            end
            object ResultsGridBasementArea: TcxDBEditorRow
              Properties.DataBinding.FieldName = 'BasementArea'
            end
            object ResultsGridBasementAreaAdjustment: TcxDBEditorRow
              Properties.DataBinding.FieldName = 'BasementAreaAdjustment'
            end
            object ResultsGridFireplaces: TcxDBEditorRow
              Properties.DataBinding.FieldName = 'Fireplaces'
            end
            object ResultsGridFireplacesAdjustment: TcxDBEditorRow
              Properties.DataBinding.FieldName = 'FireplacesAdjustment'
            end
            object ResultsGridGarages: TcxDBEditorRow
              Properties.DataBinding.FieldName = 'Garages'
            end
            object ResultsGridGaragesAdjustment: TcxDBEditorRow
              Properties.DataBinding.FieldName = 'GaragesAdjustment'
            end
            object ResultsGridCentralAir: TcxDBEditorRow
              Properties.DataBinding.FieldName = 'CentralAir'
            end
            object ResultsGridCentralAirAdjustment: TcxDBEditorRow
              Properties.DataBinding.FieldName = 'CentralAirAdjustment'
            end
            object ResultsGridCondition: TcxDBEditorRow
              Properties.DataBinding.FieldName = 'Condition'
            end
            object ResultsGridConditionAdjustment: TcxDBEditorRow
              Properties.DataBinding.FieldName = 'ConditionAdjustment'
            end
            object ResultsGridGrade: TcxDBEditorRow
              Properties.DataBinding.FieldName = 'Grade'
            end
            object ResultsGridGradeAdjustment: TcxDBEditorRow
              Properties.DataBinding.FieldName = 'GradeAdjustment'
            end
            object ResultsGridWaterSupply: TcxDBEditorRow
              Properties.DataBinding.FieldName = 'WaterSupply'
            end
            object ResultsGridWaterSupplyAdjustment: TcxDBEditorRow
              Properties.DataBinding.FieldName = 'WaterSupplyAdjustment'
            end
            object ResultsGridOther: TcxDBEditorRow
              Properties.DataBinding.FieldName = 'Other'
            end
            object ResultsGridOtherAdjustment: TcxDBEditorRow
              Properties.DataBinding.FieldName = 'OtherAdjustment'
            end
            object ResultsGridImprovementAdjustment: TcxDBEditorRow
              Properties.DataBinding.FieldName = 'ImprovementAdjustment'
            end
            object ResultsGridSewerType: TcxDBEditorRow
              Properties.DataBinding.FieldName = 'SewerType'
            end
            object ResultsGridSewerTypeAdjustment: TcxDBEditorRow
              Properties.DataBinding.FieldName = 'SewerTypeAdjustment'
            end
            object ResultsGridStories: TcxDBEditorRow
              Properties.DataBinding.FieldName = 'Stories'
            end
            object ResultsGridStoriesAdjustment: TcxDBEditorRow
              Properties.DataBinding.FieldName = 'StoriesAdjustment'
            end
            object ResultsGridWaterfront: TcxDBEditorRow
              Properties.DataBinding.FieldName = 'Waterfront'
            end
            object ResultsGridWaterfrontAdjustment: TcxDBEditorRow
              Properties.DataBinding.FieldName = 'WaterfrontAdjustment'
            end
            object ResultsGridAdjustedSalesPrice: TcxDBEditorRow
              Properties.DataBinding.FieldName = 'AdjustedSalesPrice'
            end
            object ResultsGridAdjustedPSF: TcxDBEditorRow
              Properties.DataBinding.FieldName = 'AdjustedPSF'
            end
            object ResultsGridPicture: TcxDBEditorRow
              Properties.DataBinding.FieldName = 'Picture'
            end
          end
          object Panel12: TPanel
            Left = 0
            Top = 457
            Width = 772
            Height = 41
            Align = alBottom
            TabOrder = 1
          end
        end
      end
    end
  end
  object ValuationWeightingTable: TwwTable
    DatabaseName = 'PASValuation'
    TableName = 'vweightingfile'
    TableType = ttDBase
    ControlType.Strings = (
      'RangeOK;CheckBox;True;False')
    SyncSQLByRange = True
    NarrowSearch = False
    ValidateWithMask = True
    Left = 193
    Top = 490
  end
  object LocateTimer: TTimer
    Enabled = False
    Interval = 1
    OnTimer = LocateTimerTimer
    Left = 536
    Top = 245
  end
  object ParcelTable: TTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYTAXROLLYR_SWISSBLKEY'
    TableName = 'TParcelRec'
    TableType = ttDBase
    Left = 262
    Top = 310
  end
  object ParcelDataSource: TDataSource
    DataSet = ParcelTable
    Left = 381
    Top = 372
  end
  object AssessmentTable: TTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYTAXROLLYR_SWISSBLKEY'
    TableName = 'TPAssessRec'
    TableType = ttDBase
    Left = 553
    Top = 19
  end
  object ResSiteDataSource: TDataSource
    DataSet = ResidentialSiteTable
    Left = 268
    Top = 279
  end
  object ResidentialSiteTable: TTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYTAXROLLYR_SWISSBLKEY_SITE'
    TableName = 'TPResidentialSite'
    TableType = ttDBase
    Left = 223
    Top = 322
  end
  object AssessmentDataSource: TDataSource
    DataSet = AssessmentTable
    Left = 548
    Top = 6
  end
  object CommercialSiteTable: TTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYTAXROLLYR_SWISSBLKEY_SITE'
    TableName = 'TPCommercialSite'
    TableType = ttDBase
    Left = 582
    Top = 4
  end
  object CommercialSiteDataSource: TDataSource
    DataSet = CommercialSiteTable
    Left = 498
    Top = 13
  end
  object ComparableSalesSearchTable: TTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYSWIS_NBHD_PC_BLDGSTYLE'
    TableName = 'compsalesdatafile'
    TableType = ttDBase
    Left = 118
    Top = 470
  end
  object MainTable: TwwTable
    DatabaseName = 'PASsystem'
    TableName = 'CompAssmtDataFile'
    TableType = ttDBase
    SyncSQLByRange = True
    NarrowSearch = False
    ValidateWithMask = True
    Left = 543
    Top = 446
  end
  object ParcelSearchTable: TTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYTAXROLLYR_SWISSBLKEY'
    TableName = 'TParcelRec'
    TableType = ttDBase
    Left = 237
    Top = 352
  end
  object CompSalesMinMaxTable: TTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYSWIS_NBHD_PC_STYLE'
    TableName = 'CompSalesMinMaxFile'
    TableType = ttDBase
    Left = 49
    Top = 436
  end
  object SwisCodeTable: TTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYSWISCODE'
    TableName = 'tswistbl'
    TableType = ttDBase
    Left = 343
    Top = 515
  end
  object ReportFiler: TReportFiler
    StatusFormat = 'Printing page %p'
    UnitsFactor = 1
    Title = 'ReportPrinter Report'
    Orientation = poPortrait
    ScaleX = 100
    ScaleY = 100
    OnPrint = ReportPrint
    OnPrintHeader = ReportPrintHeader
    Left = 584
    Top = 326
  end
  object ReportPrinter: TReportPrinter
    StatusFormat = 'Printing page %p'
    UnitsFactor = 1
    Title = 'ReportPrinter Report'
    Orientation = poPortrait
    ScaleX = 100
    ScaleY = 100
    OnPrint = ReportPrint
    OnPrintHeader = ReportPrintHeader
    Left = 495
    Top = 280
  end
  object PrintDialog: TPrintDialog
    Options = [poPrintToFile]
    PrintToFile = True
    Left = 518
    Top = 326
  end
  object PropertyClassTable: TwwTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYMAINCODE'
    TableName = 'ZPropClsTbl'
    TableType = ttDBase
    SyncSQLByRange = True
    NarrowSearch = False
    ValidateWithMask = True
    Left = 236
    Top = 110
  end
  object NeighborhoodTable: TwwTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYMAINCODE'
    TableName = 'ZInvNghbrhdCodeTbl'
    TableType = ttDBase
    SyncSQLByRange = True
    NarrowSearch = False
    ValidateWithMask = True
    Left = 248
    Top = 233
  end
  object BuildingStyleTable: TwwTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYMAINCODE'
    TableName = 'ZInvBuildStyleTbl'
    TableType = ttDBase
    SyncSQLByRange = True
    NarrowSearch = False
    ValidateWithMask = True
    Left = 683
    Top = 398
  end
  object ZoningTable: TwwTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYMAINCODE'
    TableName = 'ZInvZoningCodeTbl'
    TableType = ttDBase
    SyncSQLByRange = True
    NarrowSearch = False
    ValidateWithMask = True
    Left = 209
    Top = 468
  end
  object WaterTable: TwwTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYMAINCODE'
    TableName = 'ZInvWaterTbl'
    TableType = ttDBase
    SyncSQLByRange = True
    NarrowSearch = False
    ValidateWithMask = True
    Left = 643
    Top = 72
  end
  object ConditionTable: TwwTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYMAINCODE'
    TableName = 'ZInvConditionTbl'
    TableType = ttDBase
    SyncSQLByRange = True
    NarrowSearch = False
    ValidateWithMask = True
    Left = 125
    Top = 105
  end
  object GradeTable: TwwTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYMAINCODE'
    TableName = 'ZInvGradeTbl'
    TableType = ttDBase
    SyncSQLByRange = True
    NarrowSearch = False
    ValidateWithMask = True
    Left = 550
    Top = 336
  end
  object BasementTable: TwwTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYMAINCODE'
    TableName = 'ZInvResBasementTbl'
    TableType = ttDBase
    SyncSQLByRange = True
    NarrowSearch = False
    ValidateWithMask = True
    Left = 536
    Top = 248
  end
  object PropertyClassDataSource: TwwDataSource
    DataSet = PropertyClassTable
    Left = 429
    Top = 122
  end
  object NeighborhoodDataSource: TwwDataSource
    DataSet = NeighborhoodTable
    Left = 275
    Top = 175
  end
  object BuildingStyleDataSource: TwwDataSource
    DataSet = BuildingStyleTable
    Left = 283
    Top = 207
  end
  object ZoningDataSource: TwwDataSource
    DataSet = ZoningTable
    Left = 320
    Top = 373
  end
  object SewerDataSource: TwwDataSource
    DataSet = SewerTable
    Left = 230
    Top = 274
  end
  object WaterDataSource: TwwDataSource
    DataSet = WaterTable
    Left = 256
    Top = 257
  end
  object ConditionDataSource: TwwDataSource
    DataSet = ConditionTable
    Left = 81
    Top = 113
  end
  object GradeDataSource: TwwDataSource
    DataSet = GradeTable
    Left = 387
    Top = 323
  end
  object BasementDataSource: TwwDataSource
    DataSet = BasementTable
    Left = 538
    Top = 184
  end
  object CodeTable: TwwTable
    DatabaseName = 'PASsystem'
    TableType = ttDBase
    SyncSQLByRange = True
    NarrowSearch = False
    ValidateWithMask = True
    Left = 285
    Top = 283
  end
  object ComparablesSalesDataTable: TwwTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYSWISCODE_SBLKEY_SITE'
    ReadOnly = True
    TableName = 'compsalesdatafile'
    TableType = ttDBase
    SyncSQLByRange = True
    NarrowSearch = False
    ValidateWithMask = True
    Left = 486
    Top = 476
  end
  object CompDataDataSource: TwwDataSource
    DataSet = ComparablesSalesDataTable
    Left = 569
    Top = 500
  end
  object SewerTable: TwwTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYMAINCODE'
    TableName = 'ZInvSewerTbl'
    TableType = ttDBase
    SyncSQLByRange = True
    NarrowSearch = False
    ValidateWithMask = True
    Left = 526
    Top = 492
  end
  object SysRecTable: TTable
    DatabaseName = 'PASsystem'
    TableName = 'SystemRecord'
    TableType = ttDBase
    Left = 156
    Top = 202
  end
  object AssessmentYearControlTable: TTable
    DatabaseName = 'PASsystem'
    TableName = 'NAssmtYrCtlFile'
    TableType = ttDBase
    Left = 394
    Top = 442
  end
  object ValuationAdjustmentHeaderDataSource: TwwDataSource
    Left = 635
    Top = 136
  end
  object ValuationAdjustmentDetailTable: TwwTable
    DatabaseName = 'PASValuation'
    IndexName = 'BYADJCODE_LOWPRICE'
    TableName = 'vadjustmentdetails'
    TableType = ttDBase
    SyncSQLByRange = False
    NarrowSearch = False
    ValidateWithMask = True
    Left = 653
    Top = 166
  end
  object ValuationAdjustmentDetailDataSource: TwwDataSource
    DataSet = ValuationAdjustmentDetailTable
    Left = 692
    Top = 439
  end
  object SubjectPictureTable: TwwTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYSWISSBLKEY'
    TableName = 'ppicturerec'
    TableType = ttDBase
    SyncSQLByRange = False
    NarrowSearch = False
    ValidateWithMask = True
    Left = 456
    Top = 393
  end
  object SubjectPictureDataSource: TwwDataSource
    DataSet = SubjectPictureTable
    Left = 353
    Top = 430
  end
  object GroupMembersTable: TwwTable
    DatabaseName = 'PASValuation'
    IndexName = 'BYSWISCODE_SBLKEY_SITE'
    TableType = ttDBase
    ControlType.Strings = (
      'IncludeParcel;CheckBox;True;False'
      'CentralAir;CheckBox;True;False')
    SyncSQLByRange = False
    NarrowSearch = False
    ValidateWithMask = True
    Left = 113
    Top = 171
  end
  object GroupMembersDataSource: TwwDataSource
    DataSet = GroupMembersTable
    Left = 49
    Top = 236
  end
  object CharacteristicGroupsSelectedTable: TwwTable
    DatabaseName = 'PASValuation'
    IndexName = 'BYSWIS_NBHD_CLASS_STYLE'
    TableName = 'vchargroupsselected'
    TableType = ttDBase
    SyncSQLByRange = False
    NarrowSearch = False
    ValidateWithMask = True
    Left = 432
    Top = 244
  end
  object CharacteristicGroupsSelectedDataSource: TwwDataSource
    DataSet = CharacteristicGroupsSelectedTable
    Left = 432
    Top = 200
  end
  object GroupMembersLookupTable: TwwTable
    DatabaseName = 'PASValuation'
    IndexName = 'BYSWISCODE_SBLKEY_SITE'
    TableType = ttDBase
    ControlType.Strings = (
      'IncludeParcel;CheckBox;True;False'
      'CentralAir;CheckBox;True;False')
    SyncSQLByRange = False
    NarrowSearch = False
    ValidateWithMask = True
    Left = 54
    Top = 184
  end
  object ComparableAssessmentSearchTable: TTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYSWISCODE_SBLKEY_SITE'
    TableName = 'CompAssmtDataFile'
    TableType = ttDBase
    Left = 564
    Top = 394
  end
  object ResultsHeaderTable: TTable
    DatabaseName = 'PASValuation'
    IndexName = 'BYSHEETID'
    TableName = 'vresultsheadertable'
    TableType = ttDBase
    Left = 673
    Top = 373
  end
  object ValuationAdjustmentHeaderTable: TwwTable
    DatabaseName = 'PASValuation'
    IndexName = 'BYADJCODE'
    TableName = 'vadjustmentheader'
    TableType = ttDBase
    SyncSQLByRange = False
    NarrowSearch = False
    ValidateWithMask = True
    Left = 568
    Top = 144
  end
  object ResultsDetailsTable: TwwTable
    DatabaseName = 'PASValuation'
    IndexName = 'BYORDER'
    TableName = 'vresultsdetailstable'
    TableType = ttDBase
    SyncSQLByRange = False
    NarrowSearch = False
    ValidateWithMask = True
    Left = 704
    Top = 232
  end
  object ResultsDetailsDataSource: TwwDataSource
    DataSet = ResultsDetailsTable
    Left = 674
    Top = 316
  end
  object ResultsDetailsLookupTable: TwwTable
    DatabaseName = 'PASValuation'
    IndexName = 'BYSWISCODE_SBLKEY'
    TableType = ttDBase
    SyncSQLByRange = False
    NarrowSearch = False
    ValidateWithMask = True
    Left = 692
    Top = 262
  end
  object ValuationAdjustmentFieldsAvailableTable: TTable
    DatabaseName = 'PASValuation'
    IndexName = 'BYADJUSTMENTCODE'
    TableName = 'vadjustmentfieldsavail'
    TableType = ttDBase
    Left = 525
    Top = 107
  end
end
