object MappingForm: TMappingForm
  Left = 315
  Top = 127
  Width = 800
  Height = 600
  Caption = 'Mapping'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poDefault
  ShowHint = True
  Visible = True
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnKeyPress = FormKeyPress
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter: TSplitter
    Left = 174
    Top = 0
    Width = 3
    Height = 564
    Cursor = crHSplit
    ResizeStyle = rsLine
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 174
    Height = 564
    Align = alLeft
    TabOrder = 0
    object PageControl1: TPageControl
      Left = 1
      Top = 1
      Width = 172
      Height = 562
      ActivePage = TabSheet1
      Align = alClient
      MultiLine = True
      TabOrder = 0
      object TabSheet1: TTabSheet
        Caption = 'Options'
        object ChooseAssessmentYearRadioGroup: TRadioGroup
          Left = 11
          Top = 174
          Width = 142
          Height = 82
          Caption = ' Assessment Year: '
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ItemIndex = 0
          Items.Strings = (
            'Next Year'
            'This Year'
            'History')
          ParentFont = False
          TabOrder = 0
          OnClick = ChooseAssessmentYearRadioGroupClick
        end
        object EditHistoryYear: TEdit
          Left = 96
          Top = 208
          Width = 39
          Height = 23
          Ctl3D = True
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentCtl3D = False
          ParentFont = False
          TabOrder = 1
          Visible = False
        end
        object MapLabelRadioGroup: TRadioGroup
          Left = 11
          Top = -2
          Width = 142
          Height = 175
          Caption = ' Map Label: '
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ItemIndex = 0
          Items.Strings = (
            ' Parcel ID'
            ' Owner Name'
            ' Legal Address'
            ' Account Number'
            ' Sale Price \ Date'
            ' Assessed Value'
            ' AV \ SP Ratio'
            ' Property Class'
            ' None')
          ParentFont = False
          TabOrder = 2
          OnClick = MapLabelRadioGroupClick
        end
        object GroupBox1: TGroupBox
          Left = 11
          Top = 258
          Width = 142
          Height = 93
          Caption = ' Selected Parcels: '
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 3
          object Label8: TLabel
            Left = 8
            Top = 18
            Width = 49
            Height = 15
            Caption = 'Fill Style:'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -12
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object FillColorShape: TShape
            Left = 53
            Top = 62
            Width = 33
            Height = 22
            Brush.Color = clBlue
          end
          object Label9: TLabel
            Left = 8
            Top = 66
            Width = 33
            Height = 15
            Caption = 'Color:'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -12
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object FillStyleComboBox: TComboBox
            Left = 8
            Top = 35
            Width = 123
            Height = 22
            Style = csDropDownList
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ItemHeight = 14
            ParentFont = False
            TabOrder = 0
            OnChange = FillStyleComboBoxChange
            Items.Strings = (
              'Solid Fill'
              'Transparent Fill'
              'Horizontal Fill'
              'Vertical Fill'
              'Upward Diagonal Fill'
              'Downward Diagonal Fill'
              'Cross Fill'
              'Diagonal Cross Fill')
          end
          object FillColorButton: TButton
            Left = 87
            Top = 61
            Width = 21
            Height = 23
            Caption = '...'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlue
            Font.Height = -13
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TabOrder = 1
            OnClick = FillColorButtonClick
          end
        end
      end
      object TabSheet2: TTabSheet
        Caption = 'SD\EX'
        ImageIndex = 1
        object Panel6: TPanel
          Left = 0
          Top = 0
          Width = 164
          Height = 157
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 0
          object ExemptionListBox: TListBox
            Left = 0
            Top = 25
            Width = 164
            Height = 132
            Align = alClient
            ItemHeight = 13
            MultiSelect = True
            TabOrder = 0
          end
          object Panel9: TPanel
            Left = 0
            Top = 0
            Width = 164
            Height = 25
            Align = alTop
            BevelOuter = bvNone
            TabOrder = 1
            object Label19: TLabel
              Left = 2
              Top = 5
              Width = 115
              Height = 16
              Caption = 'Exemption Codes:'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -13
              Font.Name = 'Arial'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object AllExemptionCodesButton: TButton
              Left = 123
              Top = 3
              Width = 35
              Height = 19
              Hint = 'Click this button to select all exemption codes.'
              Caption = 'All'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 0
              OnClick = AllCodesButtonClick
            end
          end
        end
        object Panel7: TPanel
          Left = 0
          Top = 157
          Width = 164
          Height = 341
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 1
          object SpecialDistrictListBox: TListBox
            Left = 0
            Top = 25
            Width = 164
            Height = 316
            Align = alClient
            ItemHeight = 13
            MultiSelect = True
            TabOrder = 0
          end
          object Panel8: TPanel
            Left = 0
            Top = 0
            Width = 164
            Height = 25
            Align = alTop
            BevelOuter = bvNone
            TabOrder = 1
            object Label1: TLabel
              Left = 2
              Top = 5
              Width = 65
              Height = 16
              Caption = 'SD Codes:'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -13
              Font.Name = 'Arial'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object AllSpecialDistrictsButton: TButton
              Left = 124
              Top = 3
              Width = 35
              Height = 19
              Hint = 'Click this button to select all special districts.'
              Caption = 'All'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 0
              OnClick = AllCodesButtonClick
            end
          end
        end
      end
      object PropTabSheet3: TTabSheet
        Caption = 'Prop Cls\RS '
        ImageIndex = 2
        object Panel3: TPanel
          Left = 0
          Top = 146
          Width = 164
          Height = 352
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 0
          object Panel4: TPanel
            Left = 0
            Top = 0
            Width = 164
            Height = 25
            Align = alTop
            BevelOuter = bvNone
            TabOrder = 0
            object Label5: TLabel
              Left = 3
              Top = 5
              Width = 109
              Height = 16
              Caption = 'Property Classes:'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -13
              Font.Name = 'Arial'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object AllPropertyClassesButton: TButton
              Left = 123
              Top = 3
              Width = 35
              Height = 19
              Hint = 'Click this button to select all property classes.'
              Caption = 'All'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 0
              OnClick = AllCodesButtonClick
            end
          end
          object PropertyClassListBox: TListBox
            Left = 0
            Top = 25
            Width = 164
            Height = 316
            Align = alClient
            IntegralHeight = True
            ItemHeight = 13
            MultiSelect = True
            TabOrder = 1
          end
        end
        object Panel5: TPanel
          Left = 0
          Top = 0
          Width = 164
          Height = 146
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 1
          object Label21: TLabel
            Left = 2
            Top = 4
            Width = 87
            Height = 16
            Caption = 'Roll Sections:'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -13
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object RollSectionListBox: TListBox
            Left = 2
            Top = 24
            Width = 161
            Height = 118
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlue
            Font.Height = -13
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ItemHeight = 16
            Items.Strings = (
              '1 - Taxable'
              '3 - Taxable State Lands'
              '5 - Special Franchise'
              '6 - Utility/Non-ceiling RR'
              '7 - Ceiling RR'
              '8 - Wholly Exempt'
              '9 - Omitted\Pro-Rata')
            MultiSelect = True
            ParentFont = False
            TabOrder = 0
          end
          object AllRollSectionsButton: TButton
            Left = 124
            Top = 3
            Width = 35
            Height = 19
            Hint = 'Click this button to select all roll sections.'
            Caption = 'All'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 1
            OnClick = AllCodesButtonClick
          end
        end
      end
      object TabSheet3: TTabSheet
        Caption = 'Swis\School'
        ImageIndex = 3
        object Panel10: TPanel
          Left = 0
          Top = 0
          Width = 164
          Height = 165
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 0
          object SwisCodeListBox: TListBox
            Left = 0
            Top = 25
            Width = 164
            Height = 140
            Align = alClient
            ItemHeight = 13
            MultiSelect = True
            TabOrder = 0
          end
          object Panel11: TPanel
            Left = 0
            Top = 0
            Width = 164
            Height = 25
            Align = alTop
            BevelOuter = bvNone
            TabOrder = 1
            object Label3: TLabel
              Left = 1
              Top = 5
              Width = 77
              Height = 16
              Caption = 'Swis Codes:'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -13
              Font.Name = 'Arial'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object AllSwisCodesButton: TButton
              Left = 125
              Top = 3
              Width = 35
              Height = 19
              Hint = 'Click this button to select all swis codes.'
              Caption = 'All'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 0
              OnClick = AllCodesButtonClick
            end
          end
        end
        object Panel12: TPanel
          Left = 0
          Top = 165
          Width = 164
          Height = 333
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 1
          object SchoolCodeListBox: TListBox
            Left = 0
            Top = 25
            Width = 164
            Height = 308
            Align = alClient
            ItemHeight = 13
            MultiSelect = True
            TabOrder = 0
          end
          object Panel13: TPanel
            Left = 0
            Top = 0
            Width = 164
            Height = 25
            Align = alTop
            BevelOuter = bvNone
            TabOrder = 1
            object Label4: TLabel
              Left = 1
              Top = 5
              Width = 91
              Height = 16
              Caption = 'School Codes:'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -13
              Font.Name = 'Arial'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object AllSchoolCodesButton: TButton
              Left = 124
              Top = 3
              Width = 35
              Height = 19
              Hint = 'Click this button to select all school codes.'
              Caption = 'All'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 0
              OnClick = AllCodesButtonClick
            end
          end
        end
      end
      object TabSheet4: TTabSheet
        Caption = 'Layers'
        ImageIndex = 4
        object LayersCheckListPanel: TPanel
          Left = 0
          Top = 0
          Width = 164
          Height = 498
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 0
          object LayersCheckListBox: TCheckListBox
            Left = 0
            Top = 0
            Width = 164
            Height = 498
            OnClickCheck = LayersCheckListBoxClickCheck
            Align = alClient
            Flat = False
            ItemHeight = 13
            Sorted = True
            TabOrder = 0
            OnMouseMove = LayersCheckListBoxMouseMove
          end
        end
      end
      object TabSheet5: TTabSheet
        Caption = 'Ranges'
        ImageIndex = 5
        object Panel15: TPanel
          Left = 0
          Top = 113
          Width = 164
          Height = 345
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 0
          object ValueRangeStringGrid: TStringGrid
            Left = 0
            Top = 0
            Width = 164
            Height = 347
            Align = alClient
            ColCount = 2
            FixedCols = 0
            RowCount = 100
            ScrollBars = ssVertical
            TabOrder = 0
            OnDblClick = ValueRangeStringGridDblClick
            OnDrawCell = ValueRangeStringGridDrawCell
            ColWidths = (
              108
              32)
          end
        end
        object Panel16: TPanel
          Left = 0
          Top = 0
          Width = 164
          Height = 113
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 1
          object Label2: TLabel
            Left = 2
            Top = 3
            Width = 113
            Height = 13
            Caption = 'Value to Set Range On:'
          end
          object Label10: TLabel
            Left = 2
            Top = 44
            Width = 37
            Height = 13
            Caption = 'Region:'
          end
          object RangeValuesComboBox: TComboBox
            Left = 2
            Top = 21
            Width = 160
            Height = 21
            ItemHeight = 13
            TabOrder = 0
            OnChange = RangeValuesComboBoxChange
            Items.Strings = (
              'Land Value'
              'Assessed Value'
              'Assessment Change Percent'
              'Sales Price'
              'Zoning Codes'
              'Neighborhood Codes'
              'Swis Codes'
              'School Codes'
              'Assessed Value \ Sales Price Ratio'
              'Property Class')
          end
          object RangeRegionEdit: TEdit
            Left = 2
            Top = 61
            Width = 137
            Height = 21
            TabOrder = 1
            Text = 'Current extent.'
          end
          object ChooseRangeRegionButton: TButton
            Left = 140
            Top = 61
            Width = 20
            Height = 21
            Caption = '...'
            TabOrder = 2
          end
          object DisplayRangeLabelsCheckBox: TCheckBox
            Left = 2
            Top = 89
            Width = 124
            Height = 17
            Alignment = taLeftJustify
            Caption = 'Display Range Labels:'
            TabOrder = 3
          end
        end
        object Panel17: TPanel
          Left = 0
          Top = 458
          Width = 164
          Height = 40
          Align = alBottom
          BevelOuter = bvNone
          TabOrder = 2
          object ClearButton: TBitBtn
            Left = 85
            Top = 8
            Width = 75
            Height = 25
            Caption = 'Clear'
            TabOrder = 0
            OnClick = ClearButtonClick
            Glyph.Data = {
              76010000424D7601000000000000760000002800000020000000100000000100
              04000000000000010000120B0000120B00001000000000000000000000000000
              800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
              FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00555555555555
              55555FFFFFFF5F55FFF5777777757559995777777775755777F7555555555550
              305555555555FF57F7F555555550055BB0555555555775F777F55555550FB000
              005555555575577777F5555550FB0BF0F05555555755755757F555550FBFBF0F
              B05555557F55557557F555550BFBF0FB005555557F55575577F555500FBFBFB0
              B05555577F555557F7F5550E0BFBFB00B055557575F55577F7F550EEE0BFB0B0
              B05557FF575F5757F7F5000EEE0BFBF0B055777FF575FFF7F7F50000EEE00000
              B0557777FF577777F7F500000E055550805577777F7555575755500000555555
              05555777775555557F5555000555555505555577755555557555}
            NumGlyphs = 2
          end
          object ReapplyValuesButton: TBitBtn
            Left = 4
            Top = 8
            Width = 75
            Height = 25
            Hint = 
              'Click this button if you have change the values in a range or th' +
              'e color of a range break.'
            Caption = 'Reapply'
            TabOrder = 1
            OnClick = ReapplyValuesButtonClick
            Glyph.Data = {
              36030000424D3603000000000000360000002800000010000000100000000100
              1800000000000003000000000000000000000000000000000000808000808000
              8080008080008080008080008080008080008080008080008080008080008080
              0080800080800080800080800080800080800080800080800040400020200060
              6060000000606060202000404000808000808000808000808000808000606000
              404000202000606060909090C0C0C0C0C0C00000009090B06060A09090906060
              60202000404000808000808000404000C0C0C0C0C0C0C0C0C0C0C0C0CF9090C0
              C0C00000006060A0303090C0C0C0C0C0C0C0C0C0606060808000808000404000
              9090B0303090C0C0C0DF6060DF6060C0C0C00000006060A06060A0DF6060DF60
              60C0C0C0606060808000808000404000C0C0C0303090CF9090CF9090C0C0C0C0
              C0C0000000C0C0C0C0C0C0C0C0C0DF6060EF3030606060808000808000404000
              9090B06060A0C0C0C0C0C0C0C0C0C0C0C0C00000009090B0303090C0C0C0C0C0
              C0C0C0C06060608080008080004040009090B06060A0C0C0C0C0C0C0CF9090C0
              C0C00000006060A06060A0CF9090C0C0C0C0C0C0606060808000808000404000
              6060A06060A0C0C0C0EF3030DF6060C0C0C06060609090B06060A0CF9090EF30
              30EF30306060608080008080004040009090B0303090CF9090C0C0C0C0C0C0C0
              C0C0606060C0C0C09090B0C0C0C0C0C0C0C0C0C0606060808000808000404000
              C0C0C09090B0C0C0C0C0C0C0EF3030C0C0C00000009090B03030909090B0C0C0
              C0C0C0C0606060808000808000404000C0C0C06060A0DF6060EF3030CF9090C0
              C0C00000006060A06060A0C0C0C0EF3030C0C0C0606060808000808000404000
              C0C0C06060A0CF9090C0C0C0C0C0C0606060000000606060C0C0C0C0C0C0CF90
              90EF3030606060808000808000404000C0C0C090909060606020200040400060
              6000808000606000404000303030606060C0C0C0606060808000808000606000
              4040004040008080008080008080008080008080008080008080008080008080
              00404000404000808000BFBF7FBFBF7FBFBF7FBFBF7FBFBF7FBFBF7FBFBF7FBF
              BF7FBFBF7FBFBF7FBFBF7FBFBF7FBFBF7FBFBF7FBFBF7FBFBF7F}
          end
        end
      end
      object TabSheet6: TTabSheet
        Caption = 'Legend'
        ImageIndex = 6
        TabVisible = False
        object Panel20: TPanel
          Left = 0
          Top = 0
          Width = 164
          Height = 17
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 0
        end
      end
    end
  end
  object Panel2: TPanel
    Left = 177
    Top = 0
    Width = 607
    Height = 564
    Align = alClient
    TabOrder = 1
    object StatusBar: TStatusBar
      Left = 1
      Top = 544
      Width = 605
      Height = 19
      Panels = <
        item
          Text = 'Current Parcel:'
          Width = 350
        end
        item
          Width = 100
        end>
      SimplePanel = False
      SizeGrip = False
    end
    object Map: TMap
      Left = 1
      Top = 67
      Width = 605
      Height = 477
      ParentColor = False
      Align = alClient
      TabOrder = 1
      OnMouseUp = MapMouseUp
      OnMouseMove = MapMouseMove
      OnMouseDown = MapMouseDown
      OnAfterLayerDraw = MapAfterLayerDraw
      ControlData = {
        00000200873E00004D310000E1000000FFFFFF00010001000001102700000100
        00000000000000000000000000000100FFFFFF0000020000000000}
    end
    object ProgressBar: TProgressBar
      Left = 353
      Top = 425
      Width = 100
      Height = 16
      Min = 0
      Max = 100
      Smooth = True
      TabOrder = 2
    end
    object ToolBar: TToolBar
      Left = 1
      Top = 1
      Width = 605
      Height = 33
      ButtonHeight = 25
      Caption = 'ToolBar'
      TabOrder = 3
      object MapRangeSpeedButton: TSpeedButton
        Left = 0
        Top = 2
        Width = 23
        Height = 25
        Hint = 
          'When this button is down, you can zoom in on a region by clickin' +
          'g and dragging a zoom rectangle.'
        GroupIndex = 1
        Down = True
        Flat = True
        Glyph.Data = {
          F6000000424DF600000000000000760000002800000010000000100000000100
          04000000000080000000C40E0000C40E00001000000000000000000000000000
          80000080000000808000800000008000800080800000C0C0C000808080000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00666666666666
          6666666666000066666666660000000066666660000000000666660000000000
          006666000BBBB0000066600000BB00000006600000BB00000006600000BB0000
          0006600000BBB00B0006660000BBBBBB0066660000BB0BB00066666000000000
          0666666600000000666666666600006666666666666666666666}
        OnClick = MapRangeSpeedButtonClick
      end
      object IdentifySpeedButton: TSpeedButton
        Left = 23
        Top = 2
        Width = 25
        Height = 25
        Hint = 
          'When this button is down, clicking the mouse button will display' +
          ' parcel information.'
        GroupIndex = 1
        Flat = True
        Glyph.Data = {
          76010000424D7601000000000000760000002800000020000000100000000100
          0400000000000001000000000000000000001000000010000000000000000000
          80000080000000808000800000008000800080800000C0C0C000808080000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00555555555555
          5555555555555555555555555500005555555555550000555555555500000000
          5555555500000000555555500000000005555550000000000555550000BBBB00
          0055550000BBBB0000555500000BB00000555500000BB00000555000000BB000
          00055000000BB00000055000000BB00000055000000BB00000055000000BB000
          00055000000BB0000005500000BBB0000005500000BBB0000005550000000000
          005555000000000000555500000BB00000555500000BB00000555550000BB000
          05555550000BB000055555550000000055555555000000005555555555000055
          5555555555000055555555555555555555555555555555555555}
        NumGlyphs = 2
        OnClick = IdentifySpeedButtonClick
      end
      object SelectModeSpeedButton: TSpeedButton
        Left = 48
        Top = 2
        Width = 23
        Height = 25
        Hint = 
          'When this button is down, you can highlight parcels on the map b' +
          'y clicking on them.'
        GroupIndex = 1
        Flat = True
        Glyph.Data = {
          F6000000424DF600000000000000760000002800000010000000100000000100
          04000000000080000000C40E0000C40E00001000000000000000000000000000
          80000080000000808000800000008000800080800000C0C0C000808080000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00666666666666
          66666666600000666666666600000000666666600B000000066666000BBBB000
          006666000BBBBB00006660000B00BB0000066000000BBB000006600000BBB000
          000660000BB00000000666000BB00B00006666000BBBBB000066666000BBBB00
          0666666600000B00666666666600006666666666666666666666}
        OnClick = SelectModeSpeedButtonClick
      end
      object ModifySpeedButton: TSpeedButton
        Left = 71
        Top = 2
        Width = 25
        Height = 25
        Hint = 'Modify the ESRI parcel record.'
        GroupIndex = 1
        Flat = True
        Glyph.Data = {
          76010000424D7601000000000000760000002800000020000000100000000100
          04000000000000010000120B0000120B00001000000000000000000000000000
          800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333000000
          000033333377777777773333330FFFFFFFF03FF3FF7FF33F3FF700300000FF0F
          00F077F777773F737737E00BFBFB0FFFFFF07773333F7F3333F7E0BFBF000FFF
          F0F077F3337773F3F737E0FBFBFBF0F00FF077F3333FF7F77F37E0BFBF00000B
          0FF077F3337777737337E0FBFBFBFBF0FFF077F33FFFFFF73337E0BF0000000F
          FFF077FF777777733FF7000BFB00B0FF00F07773FF77373377373330000B0FFF
          FFF03337777373333FF7333330B0FFFF00003333373733FF777733330B0FF00F
          0FF03333737F37737F373330B00FFFFF0F033337F77F33337F733309030FFFFF
          00333377737FFFFF773333303300000003333337337777777333}
        NumGlyphs = 2
        OnClick = ModifySpeedButtonClick
      end
      object SBZoomIn: TSpeedButton
        Left = 96
        Top = 2
        Width = 25
        Height = 25
        Hint = 'Zoom In.'
        Flat = True
        Glyph.Data = {
          76010000424D7601000000000000760000002800000020000000100000000100
          04000000000000010000130B0000130B00001000000000000000000000000000
          800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
          33033333333333333F7F3333333333333000333333333333F777333333333333
          000333333333333F777333333333333000333333333333F77733333333333300
          033333333FFF3F777333333700073B703333333F7773F77733333307777700B3
          33333377333777733333307F8F8F7033333337F333F337F3333377F8F9F8F773
          3333373337F3373F3333078F898F870333337F33F7FFF37F333307F99999F703
          33337F377777337F3333078F898F8703333373F337F33373333377F8F9F8F773
          333337F3373337F33333307F8F8F70333333373FF333F7333333330777770333
          333333773FF77333333333370007333333333333777333333333}
        NumGlyphs = 2
        OnClick = SBZoomInClick
      end
      object SBZoomOut: TSpeedButton
        Left = 121
        Top = 2
        Width = 25
        Height = 25
        Hint = 'Zoom Out.'
        Flat = True
        Glyph.Data = {
          76010000424D7601000000000000760000002800000020000000100000000100
          04000000000000010000130B0000130B00001000000000000000000000000000
          800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
          33033333333333333F7F3333333333333000333333333333F777333333333333
          000333333333333F777333333333333000333333333333F77733333333333300
          033333333FFF3F777333333700073B703333333F7773F77733333307777700B3
          333333773337777333333078F8F87033333337F3333337F33333778F8F8F8773
          333337333333373F333307F8F8F8F70333337F33FFFFF37F3333078999998703
          33337F377777337F333307F8F8F8F703333373F3333333733333778F8F8F8773
          333337F3333337F333333078F8F870333333373FF333F7333333330777770333
          333333773FF77333333333370007333333333333777333333333}
        NumGlyphs = 2
        OnClick = SBZoomOutClick
      end
      object FullSizeButton: TSpeedButton
        Left = 146
        Top = 2
        Width = 25
        Height = 25
        Hint = 'Zoom out to see the whole map.'
        AllowAllUp = True
        Flat = True
        Glyph.Data = {
          76010000424D7601000000000000760000002800000020000000100000000100
          0400000000000001000000000000000000001000000010000000000000000000
          80000080000000808000800000008000800080800000C0C0C000808080000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00555555555555
          55555555555555555555555555511111555555555511111555555555511FFF44
          1155555511FFF441155555551FFFF44447155551FFFF4444755555511FF15444
          44515511FF154444455555515714444444415515714444444455551157144444
          4FFE511571444444FF555516EE444444144E512EE44444404455551EEEEE44E4
          446E51EEEEE44E44465555166E4EEEEEE6E45122E4EEEEEE6E5555166EE4EEE4
          E6E45122EE4EEE4E6E55555176E44444444155122E44444444555551EEEE4E44
          4441551EEEE4E444445555551EE5EE4444155551EE5EE4444155555551114E44
          115555551114E441155555555551111155555555551111155555}
        Margin = 0
        NumGlyphs = 2
        OnClick = FullSizeButtonClick
      end
      object LocateSpeedButton: TSpeedButton
        Left = 171
        Top = 2
        Width = 23
        Height = 25
        Hint = 'Locate a parcel.'
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
        OnClick = LocateSpeedButtonClick
      end
      object ApplySpeedButton: TSpeedButton
        Left = 194
        Top = 2
        Width = 25
        Height = 25
        Hint = 'Apply search criteria.'
        Flat = True
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
        OnClick = ApplySpeedButtonClick
      end
      object LegalAddressSpeedButton: TSpeedButton
        Left = 219
        Top = 2
        Width = 23
        Height = 25
        Hint = 'Select parcels by street.'
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
          FFFFFFFFFFFFFFFFFFFF03FF03FFFF03FFFF03FF03FF0303FFFF0303FFFF03FF
          03FF030303FF03FF03FF03FF03FF03FF03FF03FF03FF03FF03FF0303FFFFFF03
          FFFFFF03FFFF0303FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000FCFC0000FCFC
          0000FCFC0000FCFC000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          00000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
        OnClick = LegalAddressSpeedButtonClick
      end
      object ProxmitySpeedButton: TSpeedButton
        Left = 242
        Top = 2
        Width = 23
        Height = 25
        Hint = 'Find the parcels within a certain distance of a subject parcel.'
        Flat = True
        Glyph.Data = {
          F6000000424DF600000000000000760000002800000010000000100000000100
          04000000000080000000C40E0000C40E00001000000000000000000000000000
          80000080000000808000800000008000800080800000C0C0C000808080000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
          7777777777000077777777770077770077777770777777770777770777777777
          707777077777777770777077777C77777707707777CCC77777077077777C9777
          7707707777779977770777077777799770777707777777997077777077777779
          0777777700777700777777777700007777777777777777777777}
        OnClick = ProxmitySpeedButtonClick
      end
      object ClearAllSelectedSpeedButton: TSpeedButton
        Left = 265
        Top = 2
        Width = 23
        Height = 25
        Hint = 'Clear all selected parcels.'
        Flat = True
        Glyph.Data = {
          76010000424D7601000000000000760000002800000020000000100000000100
          04000000000000010000120B0000120B00001000000000000000000000000000
          800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00555555555555
          55555FFFFFFF5F55FFF5777777757559995777777775755777F7555555555550
          305555555555FF57F7F555555550055BB0555555555775F777F55555550FB000
          005555555575577777F5555550FB0BF0F05555555755755757F555550FBFBF0F
          B05555557F55557557F555550BFBF0FB005555557F55575577F555500FBFBFB0
          B05555577F555557F7F5550E0BFBFB00B055557575F55577F7F550EEE0BFB0B0
          B05557FF575F5757F7F5000EEE0BFBF0B055777FF575FFF7F7F50000EEE00000
          B0557777FF577777F7F500000E055550805577777F7555575755500000555555
          05555777775555557F5555000555555505555577755555557555}
        NumGlyphs = 2
        OnClick = ClearAllSelectedSpeedButtonClick
      end
      object ShowParcelListSpeedButton: TSpeedButton
        Left = 288
        Top = 2
        Width = 23
        Height = 25
        Hint = 'Show the parcel list.'
        Flat = True
        Glyph.Data = {
          36030000424D3603000000000000360000002800000010000000100000000100
          18000000000000030000C40E0000C40E00000000000000000000FFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          4040004040004040004040004040004040004040004040004040004040004040
          00FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF404000FFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFF404000404000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          404000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF4040004040
          00FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF40400040400040400040400040400040
          4000404000404000404000404000404000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          404000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF4040004040
          00FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF404000404000FFFFFF404000404000FF
          FFFF404000FFFFFFFFFFFF404000404000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          404000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF4040004040
          00FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF40400040400040400040400040400040
          4000404000404000404000404000404000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          404000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF4040004040
          00FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF404000FFFFFF404000404000FFFFFF40
          4000FFFFFF404000FFFFFF404000404000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          404000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF4040004040
          00FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF40400040400040400040400040400040
          4000404000404000404000404000404000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          4040004040004040004040004040004040004040004040004040004040004040
          00FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
        OnClick = ShowParcelListSpeedButtonClick
      end
      object LoadFromParcelListSpeedButton: TSpeedButton
        Left = 311
        Top = 2
        Width = 23
        Height = 25
        Hint = 'Display the contents of a parcel list on the map.'
        Flat = True
        Glyph.Data = {
          76010000424D7601000000000000760000002800000020000000100000000100
          04000000000000010000130B0000130B00001000000000000000000000000000
          800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
          333333333333333333FF33333333333330003333333333333777333333333333
          300033FFFFFF3333377739999993333333333777777F3333333F399999933333
          3300377777733333337733333333333333003333333333333377333333333333
          3333333333333333333F333333333333330033333F33333333773333C3333333
          330033337F3333333377333CC3333333333333F77FFFFFFF3FF33CCCCCCCCCC3
          993337777777777F77F33CCCCCCCCCC399333777777777737733333CC3333333
          333333377F33333333FF3333C333333330003333733333333777333333333333
          3000333333333333377733333333333333333333333333333333}
        NumGlyphs = 2
        OnClick = LoadFromParcelListButtonClick
      end
      object CreateParcelListSpeedButton: TSpeedButton
        Left = 334
        Top = 2
        Width = 23
        Height = 25
        Hint = 'Put all selected parcels on the map into a parcel list.'
        Flat = True
        Glyph.Data = {
          76010000424D7601000000000000760000002800000020000000100000000100
          04000000000000010000130B0000130B00001000000000000000000000000000
          800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
          33333333FF33333333FF333993333333300033377F3333333777333993333333
          300033F77FFF3333377739999993333333333777777F3333333F399999933333
          33003777777333333377333993333333330033377F3333333377333993333333
          3333333773333333333F333333333333330033333333F33333773333333C3333
          330033333337FF3333773333333CC333333333FFFFF77FFF3FF33CCCCCCCCCC3
          993337777777777F77F33CCCCCCCCCC3993337777777777377333333333CC333
          333333333337733333FF3333333C333330003333333733333777333333333333
          3000333333333333377733333333333333333333333333333333}
        NumGlyphs = 2
        OnClick = CreateParcelListButtonClick
      end
      object UnknownSpeedButton: TSpeedButton
        Left = 357
        Top = 2
        Width = 24
        Height = 25
        Hint = 'Highlight all unknown parcels in the current extent.'
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
          FF0080C0FF00FFC0FF0000FFFF0040FFFF0080FFFF00FFFFFF00FFFF00000000
          000000FFFFFFFFFFFFFFFFFF00FEFEFEFEFEFE000000000000FFFFFF00FEFEFE
          E0E0FEFEFEFEFEFE00FFFFFF00FEFEFEFEFEFEFEFEFEFEFE00FFFFFF00FEFEFE
          E0E0FEFEFEFEFEFE00FFFFFF00FEFEFEE0E0FEFEFEFEFEFE00FFFFFF00FEFEFE
          E0E0E0FEFEFEFE00FFFFFF00FEFEFEFEFEFEE0E0FEFEFE00FFFFFF00FEFEE0E0
          FEFEE0E0FEFEFE00FFFFFF00FEFEE0E0FEFEE0E0FEFEFE00FFFFFF00FEFEFEE0
          E0E0E0E0FEFEFE00FFFFFF00FEFEFEFEE0E0E0FEFEFEFE00FFFFFF00000000FE
          FEFEFEFEFEFE00FFFFFFFFFFFFFFFF00000000FEFEFE00FFFFFFFFFFFFFFFFFF
          FFFFFF00000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
        OnClick = UnknownSpeedButtonClick
      end
      object RefreshSpeedButton: TSpeedButton
        Left = 381
        Top = 2
        Width = 23
        Height = 25
        Hint = 'Redraw the map.'
        Flat = True
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
        OnClick = RefreshButtonClick
      end
      object MappingSetupSpeedButton: TSpeedButton
        Left = 404
        Top = 2
        Width = 25
        Height = 25
        Hint = 'Click this to change the map setup.'
        Flat = True
        Glyph.Data = {
          76010000424D7601000000000000760000002800000020000000100000000100
          04000000000000010000120B0000120B00001000000000000000000000000000
          800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00555550FF0559
          1950555FF75F7557F7F757000FF055591903557775F75557F77570FFFF055559
          1933575FF57F5557F7FF0F00FF05555919337F775F7F5557F7F700550F055559
          193577557F7F55F7577F07550F0555999995755575755F7FFF7F5570F0755011
          11155557F755F777777555000755033305555577755F75F77F55555555503335
          0555555FF5F75F757F5555005503335505555577FF75F7557F55505050333555
          05555757F75F75557F5505000333555505557F777FF755557F55000000355557
          07557777777F55557F5555000005555707555577777FF5557F55553000075557
          0755557F7777FFF5755555335000005555555577577777555555}
        NumGlyphs = 2
        OnClick = MappingSetupButtonClick
      end
      object PrintMapSpeedButton: TSpeedButton
        Left = 429
        Top = 2
        Width = 25
        Height = 25
        Hint = 'Print the map.'
        Flat = True
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
        OnClick = PrintMapSpeedButtonClick
      end
    end
    object ScalePanel: TPanel
      Left = 1
      Top = 34
      Width = 605
      Height = 33
      Align = alTop
      TabOrder = 4
      object ToolBar2: TToolBar
        Left = 1
        Top = 1
        Width = 341
        Height = 31
        Align = alClient
        ButtonHeight = 25
        Caption = 'ToolBar2'
        TabOrder = 0
        object PanLeftButton: TSpeedButton
          Left = 0
          Top = 2
          Width = 25
          Height = 25
          Hint = 'Pan left'
          Flat = True
          Glyph.Data = {
            76010000424D7601000000000000760000002800000020000000100000000100
            04000000000000010000120B0000120B00001000000000000000000000000000
            800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
            3333333333333333333333333333333333333333333333333333333333333333
            3333333333333FF3333333333333003333333333333F77F33333333333009033
            333333333F7737F333333333009990333333333F773337FFFFFF330099999000
            00003F773333377777770099999999999990773FF33333FFFFF7330099999000
            000033773FF33777777733330099903333333333773FF7F33333333333009033
            33333333337737F3333333333333003333333333333377333333333333333333
            3333333333333333333333333333333333333333333333333333333333333333
            3333333333333333333333333333333333333333333333333333}
          NumGlyphs = 2
          OnClick = PanButtonClick
        end
        object PanRightButton: TSpeedButton
          Left = 25
          Top = 2
          Width = 25
          Height = 25
          Hint = 'Pan right'
          Flat = True
          Glyph.Data = {
            76010000424D7601000000000000760000002800000020000000100000000100
            04000000000000010000120B0000120B00001000000000000000000000000000
            800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
            3333333333333333333333333333333333333333333333333333333333333333
            3333333333333333333333333333333333333333333FF3333333333333003333
            3333333333773FF3333333333309003333333333337F773FF333333333099900
            33333FFFFF7F33773FF30000000999990033777777733333773F099999999999
            99007FFFFFFF33333F7700000009999900337777777F333F7733333333099900
            33333333337F3F77333333333309003333333333337F77333333333333003333
            3333333333773333333333333333333333333333333333333333333333333333
            3333333333333333333333333333333333333333333333333333}
          NumGlyphs = 2
          OnClick = PanButtonClick
        end
        object PanUpButton: TSpeedButton
          Left = 50
          Top = 2
          Width = 25
          Height = 25
          Hint = 'Pan up'
          Flat = True
          Glyph.Data = {
            76010000424D7601000000000000760000002800000020000000100000000100
            04000000000000010000120B0000120B00001000000000000000000000000000
            800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333000333
            3333333333777F33333333333309033333333333337F7F333333333333090333
            33333333337F7F33333333333309033333333333337F7F333333333333090333
            33333333337F7F33333333333309033333333333FF7F7FFFF333333000090000
            3333333777737777F333333099999990333333373F3333373333333309999903
            333333337F33337F33333333099999033333333373F333733333333330999033
            3333333337F337F3333333333099903333333333373F37333333333333090333
            33333333337F7F33333333333309033333333333337373333333333333303333
            333333333337F333333333333330333333333333333733333333}
          NumGlyphs = 2
          OnClick = PanButtonClick
        end
        object PanDownButton: TSpeedButton
          Left = 75
          Top = 2
          Width = 25
          Height = 25
          Hint = 'Pan down'
          Flat = True
          Glyph.Data = {
            76010000424D7601000000000000760000002800000020000000100000000100
            04000000000000010000120B0000120B00001000000000000000000000000000
            800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333303333
            333333333337F33333333333333033333333333333373F333333333333090333
            33333333337F7F33333333333309033333333333337373F33333333330999033
            3333333337F337F33333333330999033333333333733373F3333333309999903
            333333337F33337F33333333099999033333333373333373F333333099999990
            33333337FFFF3FF7F33333300009000033333337777F77773333333333090333
            33333333337F7F33333333333309033333333333337F7F333333333333090333
            33333333337F7F33333333333309033333333333337F7F333333333333090333
            33333333337F7F33333333333300033333333333337773333333}
          NumGlyphs = 2
          OnClick = PanButtonClick
        end
        object ExcelSpeedButton: TSpeedButton
          Left = 100
          Top = 2
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
          OnClick = ExcelSpeedButtonClick
        end
        object CopyToClipboardSpeedButton: TSpeedButton
          Left = 123
          Top = 2
          Width = 23
          Height = 25
          Hint = 'Click this button to copy the current map view to the clipboard.'
          Flat = True
          Glyph.Data = {
            36030000424D3603000000000000360000002800000010000000100000000100
            1800000000000003000000000000000000000000000000000000FFFFFFDFDFDF
            A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0
            A0A0A0A0B0B0B0EFEFEFFFFFFF20204000004000004000004000004000004000
            0040000040000040000040000040000040000040202040B0B0B0FFFFFF000040
            0000600000400000400000400000400000400000400000400000400000400000
            40000060000040A0A0A0FFFFFF000040000040FFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000040000040A0A0A0FFFFFF000040
            000040DFDFDFBFBFBFDFDFDFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFDFDFDFDFDF
            DF000040000040A0A0A0FFFFFF000040000040DFDFDFBFBFBFBFBFBFBFBFBFDF
            DFDFBFBFBFDFDFDFBFBFBFBFBFBFDFDFDF000040000040A0A0A0FFFFFF000040
            000040DFDFDFBFBFBFBFBFBFBFBFBFDFDFDFBFBFBFBFBFBFBFBFBFDFDFDFDFDF
            DF000040000040A0A0A0FFFFFF000040000040DFDFDFBFBFBFBFBFBFDFDFDFBF
            BFBFBFBFBFBFBFBFDFDFDFBFBFBFDFDFDF000040000040A0A0A0FFFFFF000040
            000040DFDFDFDFDFDFBFBFBFBFBFBFDFDFDFBFBFBFBFBFBFDFDFDFBFBFBFDFDF
            DF000040000040A0A0A0FFFFFF000040000040DFDFDFBFBFBFBFBFBFDFDFDFBF
            BFBFBFBFBFDFDFDFBFBFBFBFBFBFDFDFDF000040000040A0A0A0FFFFFF000040
            000040DFDFDFDFDFDFBFBFBFBFBFBFDFDFDFBFBFBFBFBFBFDFDFDFBFBFBFDFDF
            DF000040000040A0A0A0FFFFFF000040000040DFDFDFBFBFBFBFBFBFDFDFDFBF
            BFBFBFBFBFDFDFDFBFBFBFBFBFBFDFDFDF000040000040A0A0A0FFFFFF000040
            000040FFFFFFFFFFFF6F6F6F606060606060606060606060606060BFBFBFFFFF
            FF000040000040A0A0A0FFFFFF00004000006000004000004030303060606060
            6060C0C0C0303030606060000020000040000060000040A0A0A0FFFFFF3F3F5F
            000040000040000040303030303030C0C0C06060606060606060600000200000
            400000403F3F5FDFDFDFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF6F
            6F6F606060BFBFBFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
          OnClick = CopyToClipboardSpeedButtonClick
        end
        object SaveSpeedButton: TSpeedButton
          Left = 146
          Top = 2
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
          OnClick = SaveSpeedButtonClick
        end
        object ExtractGISParcelShapeFileSpeedButton: TSpeedButton
          Left = 171
          Top = 2
          Width = 25
          Height = 25
          Hint = 
            'Extract fields from the base shape file and the PAS parcel table' +
            '.'
          Flat = True
          Glyph.Data = {
            F6000000424DF600000000000000760000002800000010000000100000000100
            04000000000080000000CE0E0000C40E00001000000000000000000000000000
            80000080000000808000800000008000800080800000C0C0C000808080000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00666666660000
            00006666668880EEEEE0666688CCCC0EEEE06668CCCCC0EEEEE06687CC720EEE
            EEE06686C7C0EEEEE0E06876C720EEEE0400687CC2220EE0224068C7CCC2C00C
            24C26877C2CCC2CC4C286877CC2CCC2C4C2866877C2222222286668CCCC2C222
            22866668CC6CC222286666668882C22886666666668888866666}
          OnClick = ExtractGISParcelShapeFileSpeedButtonClick
        end
        object SetPASFieldSpeedButton: TSpeedButton
          Left = 196
          Top = 2
          Width = 25
          Height = 25
          Hint = 'Set PAS data field based on map data.'
          Flat = True
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
          OnClick = SetPASFieldSpeedButtonClick
        end
        object ShowPicturesSpeedButton: TSpeedButton
          Left = 221
          Top = 2
          Width = 23
          Height = 25
          Hint = 'Show parcels with pictures.'
          Flat = True
          Glyph.Data = {
            36030000424D3603000000000000360000002800000010000000100000000100
            1800000000000003000000000000000000000000000000000000B0B0B0A0A0A0
            404040B0B0B0C0C0C0C0C0C0B0B0B0404040707070C0C0C0C0C0C0C0C0C07070
            70707070A0A0A0C0C0C0C0C0C0C0C0C0303030303030C0C0C0C0C0C0C0C0C000
            0000606060C0C0C0C0C0C0909090000000909090C0C0C0C0C0C0C0C0C0C0C0C0
            C0C0C0303030303030C0C0C0C0C0C0000000606060C0C0C09090900000009090
            90C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0303030303030C0C0C000
            0000606060909090000000909090C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
            C0C0C0C0C0C0C0C0C0303030303030000000303030000000909090C0C0C0C0C0
            C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C030303000
            0000000000909090C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0B0B0B0000000
            0000000000000000000000000000000000000000000000000000000000000000
            00000000505050C0C0C0A0A0A000000000000000000000000000000000000040
            4040404040202020000000000000000000000000404040C0C0C0A0A0A0000000
            0000000000000000000000006060605050506060606060602020200000000000
            00000000404040C0C0C0A0A0A0000000606060606060000000000000404040CF
            CFCFDFDFDF606060404040000000000000000000404040C0C0C0A0A0A0000000
            3030303030300000000000006060605050506060606060602020200000000000
            00000000404040C0C0C0A0A0A000000000000000000000000000000000000040
            4040404040202020000000000000000000000000404040C0C0C0A0A0A0303030
            6060606060606060606060609090906060606060609090906060606060606060
            60606060404040C0C0C090909000000000000030303000000030303030303000
            0000000000303030000000303030000000000000909090C0C0C0B0B0B0A0A0A0
            A0A0A0B0B0B0A0A0A0C0C0C0303030606060606060303030909090C0C0C0C0C0
            C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C060
            6060606060909090C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0}
          OnClick = ShowPicturesSpeedButtonClick
        end
      end
      object Panel14: TPanel
        Left = 342
        Top = 1
        Width = 262
        Height = 31
        Align = alRight
        BevelInner = bvLowered
        BevelOuter = bvNone
        TabOrder = 1
        object Label6: TLabel
          Left = 7
          Top = 8
          Width = 42
          Height = 13
          Caption = 'Scale  1:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object XCoordinateLabel: TLabel
          Left = 166
          Top = 1
          Width = 13
          Height = 13
          Caption = 'X: '
        end
        object YCoordinateLabel: TLabel
          Left = 166
          Top = 16
          Width = 10
          Height = 13
          Caption = 'Y:'
        end
        object UnlockScaleButton: TBitBtn
          Left = 135
          Top = 4
          Width = 24
          Height = 23
          Hint = 'Lock the current scale'
          TabOrder = 1
          Visible = False
          OnClick = UnlockScaleButtonClick
          Glyph.Data = {
            76010000424D7601000000000000760000002800000020000000100000000100
            04000000000000010000120B0000120B00001000000000000000000000000000
            800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333000003
            333333333F777773FF333333008888800333333377333F3773F3333077870787
            7033333733337F33373F3308888707888803337F33337F33337F330777880887
            7703337F33337FF3337F3308888000888803337F333777F3337F330777700077
            7703337F33377733337FB3088888888888033373FFFFFFFFFF733B3000000000
            0033333777777777773333BBBB3333080333333333F3337F7F33BBBB707BB308
            03333333373F337F7F3333BB08033308033333337F7F337F7F333B3B08033308
            033333337F73FF737F33B33B778000877333333373F777337333333B30888880
            33333333373FFFF73333333B3300000333333333337777733333}
          NumGlyphs = 2
        end
        object LockScaleButton: TBitBtn
          Left = 135
          Top = 4
          Width = 24
          Height = 23
          Hint = 'Lock the current scale'
          TabOrder = 0
          OnClick = LockScaleButtonClick
          Glyph.Data = {
            76010000424D7601000000000000760000002800000020000000100000000100
            04000000000000010000120B0000120B00001000000000000000000000000000
            800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333000003
            333333333F777773FF333333008888800333333377333F3773F3333077870787
            7033333733337F33373F3308888707888803337F33337F33337F330777880887
            7703337F33337FF3337F3308888000888803337F333777F3337F330777700077
            7703337F33377733337F33088888888888033373FFFFFFFFFF73333000000000
            00333337777777777733333308033308033333337F7F337F7F33333308033308
            033333337F7F337F7F33333308033308033333337F73FF737F33333377800087
            7333333373F77733733333333088888033333333373FFFF73333333333000003
            3333333333777773333333333333333333333333333333333333}
          NumGlyphs = 2
        end
        object ScaleComboBox: TwwDBComboBox
          Left = 53
          Top = 4
          Width = 83
          Height = 21
          ShowButton = True
          Style = csDropDown
          MapList = False
          AllowClearKey = False
          Color = clWhite
          DropDownCount = 8
          ItemHeight = 0
          Items.Strings = (
            '50'
            '100'
            '200'
            '400'
            '600'
            '800'
            '1000')
          Sorted = False
          TabOrder = 2
          UnboundDataType = wwDefault
          OnCloseUp = ScaleComboBoxCloseUp
          OnExit = ScaleComboBoxExit
        end
      end
    end
  end
  object ModifyParcelPanel: TPanel
    Left = 133
    Top = 83
    Width = 525
    Height = 400
    TabOrder = 2
    Visible = False
    object ParcelStringGrid: TStringGrid
      Left = 26
      Top = 28
      Width = 473
      Height = 329
      ColCount = 2
      RowCount = 14
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goDrawFocusSelected, goColSizing, goEditing, goTabs, goAlwaysShowEditor]
      ParentFont = False
      TabOrder = 0
      ColWidths = (
        131
        315)
      RowHeights = (
        24
        24
        24
        24
        24
        24
        24
        24
        24
        24
        24
        24
        24
        24)
    end
    object SaveButton: TBitBtn
      Left = 197
      Top = 361
      Width = 89
      Height = 33
      Caption = '&Save'
      TabOrder = 1
      OnClick = SaveButtonClick
      Glyph.Data = {
        DE010000424DDE01000000000000760000002800000024000000120000000100
        0400000000006801000000000000000000001000000000000000000000000000
        8000008000000080800080000000800080008080000080808000C0C0C0000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        3333333333333333333333330000333333333333333333333333F33333333333
        00003333344333333333333333377F3333333333000033334224333333333333
        337337F3333333330000333422224333333333333733337F3333333300003342
        222224333333333373333337F3333333000034222A22224333333337F337F333
        7F33333300003222A3A2224333333337F3737F337F33333300003A2A333A2224
        33333337F73337F337F33333000033A33333A222433333337333337F337F3333
        0000333333333A222433333333333337F337F33300003333333333A222433333
        333333337F337F33000033333333333A222433333333333337F337F300003333
        33333333A222433333333333337F337F00003333333333333A22433333333333
        3337F37F000033333333333333A223333333333333337F730000333333333333
        333A333333333333333337330000333333333333333333333333333333333333
        0000}
      NumGlyphs = 2
    end
    object CancelButton: TBitBtn
      Left = 303
      Top = 361
      Width = 89
      Height = 33
      Cancel = True
      Caption = '&Cancel'
      TabOrder = 2
      OnClick = CancelButtonClick
      Glyph.Data = {
        DE010000424DDE01000000000000760000002800000024000000120000000100
        0400000000006801000000000000000000001000000000000000000000000000
        8000008000000080800080000000800080008080000080808000C0C0C0000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        333333333333333333333333000033337733333333333333333F333333333333
        0000333911733333973333333377F333333F3333000033391117333911733333
        37F37F333F77F33300003339111173911117333337F337F3F7337F3300003333
        911117111117333337F3337F733337F3000033333911111111733333337F3337
        3333F7330000333333911111173333333337F333333F73330000333333311111
        7333333333337F3333373333000033333339111173333333333337F333733333
        00003333339111117333333333333733337F3333000033333911171117333333
        33337333337F333300003333911173911173333333373337F337F33300003333
        9117333911173333337F33737F337F33000033333913333391113333337FF733
        37F337F300003333333333333919333333377333337FFF730000333333333333
        3333333333333333333777330000333333333333333333333333333333333333
        0000}
      NumGlyphs = 2
    end
    object CloseButton: TBitBtn
      Left = 408
      Top = 361
      Width = 89
      Height = 33
      Caption = '&Close'
      TabOrder = 3
      OnClick = CloseButtonClick
      Glyph.Data = {
        CE070000424DCE07000000000000360000002800000024000000120000000100
        1800000000009807000000000000000000000000000000000000008080808080
        808080808080808080808080808080808080808080808080C0C0C0C0C0C0FFFF
        FFC0C0C0FFFFFFC0C0C0808080C0C0C0FFFFFF80808080808080808080808080
        8080808080808080808080808080808080008080008080008080008080008080
        008080FFFFFF8000008000008000008000008000000000000000008080808080
        80808080FFFFFFFFFFFFFFFFFF80000080000080000080000080000080808080
        8080808080808080808080808080808080808080808080808080FFFFFF008080
        008080008080FFFFFFFFFFFF808080FFFFFF0080800080800080800080808000
        00FF00FF800080000000000000C0C0C0FFFFFFFFFFFFFFFFFF80000000808000
        8080008080008080808080808080808080808080808080808080808080808080
        808080808080008080008080008080808080808080808080808080FFFFFF0080
        80008080008080008080800000800080FF00FF800080000000FFFFFFFFFFFFFF
        FFFFFFFFFF800000008080008080008080008080008080008080008080008080
        808080FFFFFF808080808080808080FFFFFF008080008080008080808080FFFF
        FF008080008080FFFFFF008080008080008080008080800000FF00FF800080FF
        00FF000000FFFFFFFFFFFFFFFFFFFFFFFF800000008080008080008080008080
        008080008080008080008080808080808080C0C0C0808080808080FFFFFF0080
        80008080008080808080FFFFFF008080008080FFFFFF00808000808000808000
        8080800000800080FF00FF800080000000FFFFFFFFFF00FFFFFFFFFF00800000
        008080008080008080008080008080008080008080008080808080FFFFFF8080
        80C0C0C0808080FFFFFF008080008080008080808080FFFFFF008080008080FF
        FFFF008080008080008080008080800000FF00FF800080FF00FF000000FFFFFF
        FFFFFFFFFFFFFFFFFF8000000080800080800080800080800080800080800080
        80008080808080808080C0C0C0808080808080FFFFFF00808000808000808080
        8080FFFFFF008080008080FFFFFF008080008080008080008080800000800080
        FF00FF800080000000FFFFFFFFFF00FFFFFFFFFF008000000080800080800080
        80008080008080008080008080008080808080FFFFFF808080C0C0C0808080FF
        FFFF008080008080008080808080FFFFFF008080008080FFFFFF008080008080
        008080008080800000FF00FF800080FF00FF000000FFFFFFFFFFFFFFFFFFFFFF
        FF80000000808000808000808000808000808000808000808000808080808080
        8080C0C0C0808080808080FFFFFF008080008080008080808080FFFFFF008080
        008080FFFFFF008080008080008080008080800000800080FF00FF8000800000
        00FFFFFFFFFF00FFFFFFFFFF0080000000808000808000808000808000808000
        8080008080008080808080FFFFFF808080C0C0C0808080FFFFFF008080008080
        008080808080FFFFFF008080008080FFFFFF0080800080800080800080808000
        00FF00FF800080FF00FF000000FFFF00FFFFFFFFFF00FFFFFF80000000808000
        8080008080008080008080008080008080008080808080808080C0C0C0808080
        808080FFFFFF008080008080008080808080FFFFFF008080008080FFFFFF0080
        80008080008080008080800000800080FF00FF800080000000FFFFFFFFFF00FF
        FFFFFFFF00800000008080008080008080008080008080008080008080008080
        808080FFFFFF808080C0C0C0808080FFFFFF008080008080008080808080FFFF
        FF008080008080FFFFFF008080008080008080008080800000FF00FF800080FF
        00FF000000FFFF00FFFFFFFFFF00FFFFFF800000008080008080008080008080
        008080008080008080008080808080808080C0C0C0808080808080FFFFFF0080
        80008080008080808080FFFFFF008080008080FFFFFF00808000808000808000
        8080800000800000800000800000800000800000800000800000800000800000
        008080008080008080008080008080008080008080008080808080FFFFFF8080
        80FFFFFF808080FFFFFFFFFFFFFFFFFFFFFFFF808080FFFFFF008080008080FF
        FFFF008080008080008080008080008080008080008080008080008080008080
        0080800080800080800080800080800080800080800080800080800080800080
        8000808080808080808080808080808080808080808080808080808080808080
        8080008080008080008080FFFFFF008080008080008080008080008080008080
        0000000000000000000000000000000000000080800080800080800080800080
        80008080008080008080008080008080008080008080008080FFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFF008080008080008080008080FFFFFF008080008080
        00808000808000808000808000000000FF0000FF0000FF0000FF000000000080
        8000808000808000808000808000808000808000808000808000808000808000
        8080808080808080808080808080808080808080FFFFFF008080008080008080
        008080FFFFFF0080800080800080800080800080800080800000000000000000
        0000000000000000000000808000808000808000808000808000808000808000
        8080008080008080008080008080808080FFFFFFFFFFFFFFFFFFFFFFFF808080
        FFFFFF008080008080008080008080FFFFFF}
      NumGlyphs = 2
    end
    object Panel21: TPanel
      Left = 1
      Top = 1
      Width = 523
      Height = 20
      Align = alTop
      Alignment = taLeftJustify
      BevelOuter = bvNone
      Caption = ' Modify properties for parcel in shapefile.'
      Color = clActiveCaption
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindow
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 4
      object CloseModifyParcelPanelTopButton: TButton
        Left = 503
        Top = 1
        Width = 17
        Height = 15
        Caption = 'x'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindow
        Font.Height = -13
        Font.Name = 'System'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        OnClick = CloseButtonClick
      end
    end
  end
  object MapTimer: TTimer
    Enabled = False
    Interval = 1
    OnTimer = MapTimerTimer
    Left = 300
    Top = 101
  end
  object OpenDialog: TOpenDialog
    DefaultExt = 'shp'
    Filter = 'Shape Files|*.shp|All Files|*.*'
    InitialDir = '\pas32\maps\hastings'
    Left = 207
    Top = 99
  end
  object ExemptionCodeTable: TTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYEXCODE'
    TableName = 'TExCodeTbl'
    TableType = ttDBase
    Left = 407
    Top = 92
  end
  object SDCodeTable: TTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYSDISTCODE'
    TableName = 'TSDCodeTbl'
    TableType = ttDBase
    Left = 360
    Top = 68
  end
  object SchoolCodeTable: TTable
    DatabaseName = 'PASsystem'
    TableName = 'TSchoolTbl'
    TableType = ttDBase
    Left = 489
    Top = 67
  end
  object SwisCodeTable: TTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYSWISCODE'
    TableName = 'TSwisTbl'
    TableType = ttDBase
    Left = 434
    Top = 89
  end
  object PropertyClassTable: TTable
    DatabaseName = 'PASsystem'
    TableName = 'ZPropClsTbl'
    TableType = ttDBase
    Left = 305
    Top = 151
  end
  object ParcelLookupTable: TTable
    DatabaseName = 'PASsystem'
    TableName = 'Nparcelrec'
    TableType = ttDBase
    Left = 403
    Top = 291
  end
  object SysRecTable: TTable
    DatabaseName = 'PASsystem'
    TableName = 'SystemRecord'
    TableType = ttDBase
    Left = 375
    Top = 157
  end
  object AssessmentYearControlTable: TTable
    DatabaseName = 'PASsystem'
    TableName = 'NAssmtYrCtlFile'
    TableType = ttDBase
    Left = 205
    Top = 69
  end
  object ParcelEXTable: TTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYYEAR_SWISSBLKEY_EXCODE'
    TableName = 'TPExemptionRec'
    TableType = ttDBase
    Left = 259
    Top = 72
  end
  object ParcelSDTable: TTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYTAXROLLYR_SWISSBLKEY_SD'
    TableName = 'TPSpclDistRec'
    TableType = ttDBase
    Left = 209
    Top = 240
  end
  object MappingHeaderTable: TTable
    DatabaseName = 'PASsystem'
    TableName = 'MappingOptionsHeader'
    TableType = ttDBase
    Left = 554
    Top = 81
  end
  object MappingDetailTable: TwwTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYSETUP_LAYERNAME'
    TableName = 'mappingoptionsdetails'
    TableType = ttDBase
    ControlType.Strings = (
      'MainLayer;CheckBox;True;False')
    SyncSQLByRange = True
    NarrowSearch = False
    ValidateWithMask = True
    Left = 574
    Top = 118
  end
  object OpenTablesInDataModuleTimer: TTimer
    Enabled = False
    Interval = 1
    OnTimer = OpenTablesInDataModuleTimerTimer
    Left = 449
    Top = 345
  end
  object MapLayersAvailableTable: TTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYLAYERNAME'
    TableName = 'maplayersavailable'
    TableType = ttDBase
    Left = 471
    Top = 241
  end
  object ParcelTable: TTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYTAXROLLYR_SWISSBLKEY'
    TableName = 'tparcelrec'
    TableType = ttDBase
    Left = 226
    Top = 262
  end
  object ColorDialog: TColorDialog
    Ctl3D = True
    Left = 230
    Top = 168
  end
  object PrintDialog: TPrintDialog
    Options = [poPrintToFile]
    Left = 366
    Top = 265
  end
  object FlashShapeTimer: TTimer
    Enabled = False
    Interval = 1
    OnTimer = FlashShapeTimerTimer
    Left = 376
    Top = 226
  end
  object RefreshLayerBoxTimer: TTimer
    Enabled = False
    Interval = 1
    OnTimer = RefreshLayerBoxTimerTimer
    Left = 520
    Top = 189
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
    Left = 164
    Top = 442
  end
  object ParcelLookupTable2: TTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYTAXROLLYR_SWISSBLKEY'
    TableName = 'Nparcelrec'
    TableType = ttDBase
    Left = 457
    Top = 271
  end
  object AssessmentTable: TTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYTAXROLLYR_SWISSBLKEY'
    TableName = 'TPAssessRec'
    TableType = ttDBase
    Left = 316
    Top = 227
  end
  object MapInfoFormSynchronizeTimer: TTimer
    Enabled = False
    OnTimer = MapInfoFormSynchronizeTimerTimer
    Left = 558
    Top = 245
  end
  object ZoningCodeTable: TTable
    DatabaseName = 'PASsystem'
    TableName = 'zinvzoningcodetbl'
    TableType = ttDBase
    Left = 506
    Top = 158
  end
  object NeighborhoodCodeTable: TTable
    DatabaseName = 'PASsystem'
    TableName = 'zinvnghbrhdcodetbl'
    TableType = ttDBase
    Left = 333
    Top = 360
  end
  object LimitExtentTimer: TTimer
    Enabled = False
    OnTimer = LimitExtentTimerTimer
    Left = 231
    Top = 289
  end
  object ResidentialSiteTable: TTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYTAXROLLYR_SWISSBLKEY'
    TableName = 'TPResidentialSite'
    TableType = ttDBase
    Left = 418
    Top = 136
  end
  object SalesTable: TTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYSWISSBLKEY_SALENUMBER'
    TableName = 'psalesrec'
    TableType = ttDBase
    Left = 531
    Top = 318
  end
  object SaveDialog: TSaveDialog
    Options = [ofHideReadOnly, ofPathMustExist, ofEnableSizing]
    Left = 581
    Top = 161
  end
  object ParcelListReportPrinter: TReportPrinter
    StatusFormat = 'Printing page %p'
    UnitsFactor = 1
    Title = 'ReportPrinter Report'
    Orientation = poPortrait
    ScaleX = 100
    ScaleY = 100
    OnPrint = ParcelListReportPrint
    OnPrintHeader = ParcelListReportPrintHeader
    Left = 618
    Top = 383
  end
  object UnknownParcelReportPrinter: TReportPrinter
    StatusFormat = 'Printing page %p'
    UnitsFactor = 1
    Title = 'ReportPrinter Report'
    Orientation = poPortrait
    ScaleX = 100
    ScaleY = 100
    OnPrint = UnknownParcelReportPrint
    OnPrintHeader = UnknownParcelReportPrintHeader
    Left = 659
    Top = 124
  end
  object SelectedLayerDeleteTimer: TTimer
    Enabled = False
    OnTimer = SelectedLayerDeleteTimerTimer
    Left = 348
    Top = 129
  end
  object MapCondoTable: TTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYSWISCODE_SBL'
    TableType = ttDBase
    Left = 111
    Top = 153
  end
  object MapParcelIDFormatTable: TTable
    DatabaseName = 'PASsystem'
    TableType = ttDBase
    Left = 83
    Top = 214
  end
  object AdjustExtentForLockedScaleTimer: TTimer
    Enabled = False
    OnTimer = AdjustExtentForLockedScaleTimerTimer
    Left = 402
    Top = 195
  end
  object Table1: TTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYSWISSBLKEY'
    TableName = 'ppicturerec'
    TableType = ttDBase
    Left = 187
    Top = 499
  end
  object CommercialSiteTable: TTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYTAXROLLYR_SWISSBLKEY'
    TableName = 'TPCommercialSite'
    TableType = ttDBase
    Left = 690
    Top = 261
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
    Left = 209
    Top = 444
  end
  object ParcelListReportFiler: TReportFiler
    StatusFormat = 'Printing page %p'
    UnitsFactor = 1
    Title = 'ReportPrinter Report'
    Orientation = poPortrait
    ScaleX = 100
    ScaleY = 100
    OnPrint = ParcelListReportPrint
    OnPrintHeader = ParcelListReportPrintHeader
    Left = 698
    Top = 377
  end
  object UnknownParcelReportFiler: TReportFiler
    StatusFormat = 'Printing page %p'
    UnitsFactor = 1
    Title = 'ReportPrinter Report'
    Orientation = poPortrait
    ScaleX = 100
    ScaleY = 100
    OnPrint = UnknownParcelReportPrint
    OnPrintHeader = UnknownParcelReportPrintHeader
    Left = 677
    Top = 177
  end
end
