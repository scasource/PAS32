object MappingOptionsSetupAddLayerDialog: TMappingOptionsSetupAddLayerDialog
  Left = 386
  Top = 115
  Width = 596
  Height = 475
  Caption = 'Map layer characteristics'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object LayerInformationGroupBox: TGroupBox
    Left = 6
    Top = 13
    Width = 574
    Height = 113
    Caption = ' Layer Information: '
    TabOrder = 0
    object Label1: TLabel
      Left = 24
      Top = 28
      Width = 31
      Height = 13
      Caption = 'Name:'
    end
    object Label2: TLabel
      Left = 24
      Top = 58
      Width = 44
      Height = 13
      Caption = 'Location:'
    end
    object Label3: TLabel
      Left = 24
      Top = 87
      Width = 27
      Height = 13
      Caption = 'Type:'
    end
    object FindLayerButton: TBitBtn
      Left = 535
      Top = 52
      Width = 27
      Height = 25
      TabOrder = 0
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
    end
    object LocationEdit: TwwDBEdit
      Left = 83
      Top = 54
      Width = 455
      Height = 21
      TabOrder = 1
      UnboundDataType = wwDefault
      WantReturns = False
      WordWrap = False
    end
    object LayerNameEdit: TwwDBEdit
      Left = 83
      Top = 24
      Width = 121
      Height = 21
      TabOrder = 2
      UnboundDataType = wwDefault
      WantReturns = False
      WordWrap = False
    end
    object LayerTypeEdit: TwwDBEdit
      Left = 83
      Top = 83
      Width = 121
      Height = 21
      TabOrder = 3
      UnboundDataType = wwDefault
      WantReturns = False
      WordWrap = False
    end
  end
  object ClassificationOptionsRadioGroup: TRadioGroup
    Left = 7
    Top = 128
    Width = 164
    Height = 150
    Caption = ' Classification Options: '
    ItemIndex = 0
    Items.Strings = (
      ' Single Symbol'
      ' Unique Values'
      ' Class Breaks'
      ' Standard Labels'
      ' No Overlapping Labels')
    TabOrder = 1
    OnClick = ClassificationOptionsRadioGroupClick
  end
  object Panel1: TPanel
    Left = 179
    Top = 132
    Width = 401
    Height = 261
    BevelInner = bvSpace
    BorderStyle = bsSingle
    TabOrder = 2
    object ClassificationNotebook: TNotebook
      Left = 2
      Top = 2
      Width = 393
      Height = 253
      Align = alClient
      PageIndex = 1
      TabOrder = 0
      object TPage
        Left = 0
        Top = 0
        Caption = 'SingleSymbolPage'
        object Label8: TLabel
          Left = 38
          Top = 72
          Width = 41
          Height = 13
          Caption = 'Fill Style:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label9: TLabel
          Left = 38
          Top = 103
          Width = 27
          Height = 13
          Caption = 'Color:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object FillStyleComboBox: TComboBox
          Left = 95
          Top = 67
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
          Left = 171
          Top = 98
          Width = 20
          Height = 22
          Caption = '...'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
        end
        object EditSingleSymbolColor: TEdit
          Left = 95
          Top = 99
          Width = 76
          Height = 21
          ReadOnly = True
          TabOrder = 2
        end
        object Panel2: TPanel
          Left = 0
          Top = 0
          Width = 393
          Height = 53
          Align = alTop
          TabOrder = 3
          object Label4: TLabel
            Left = 8
            Top = 4
            Width = 352
            Height = 30
            AutoSize = False
            Caption = 
              'The Single Symbol classification displays all features in a laye' +
              'r in the same manner.'
            WordWrap = True
          end
        end
      end
      object TPage
        Left = 0
        Top = 0
        Caption = 'UniqueValuesPage'
        object Label6: TLabel
          Left = 13
          Top = 88
          Width = 25
          Height = 13
          Caption = 'Field:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label7: TLabel
          Left = 179
          Top = 62
          Width = 72
          Height = 13
          Caption = 'Unique Values:'
        end
        object Panel3: TPanel
          Left = 0
          Top = 0
          Width = 393
          Height = 53
          Align = alTop
          TabOrder = 0
          object Label5: TLabel
            Left = 8
            Top = 4
            Width = 352
            Height = 42
            AutoSize = False
            Caption = 
              'The Unique Values classification displays each value with a diff' +
              'erent color.  Select the value field and unique color values wil' +
              'l be generated for each.  Double click on a color to change it.'
            WordWrap = True
          end
        end
        object MapFieldComboBox: TComboBox
          Left = 51
          Top = 84
          Width = 117
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBackground
          Font.Height = -12
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ItemHeight = 13
          ParentFont = False
          TabOrder = 1
        end
        object UniqueValuesListView: TListView
          Left = 179
          Top = 84
          Width = 204
          Height = 163
          Columns = <
            item
              Caption = 'Unique Value'
              Width = 125
            end
            item
              Alignment = taCenter
              Caption = 'Color'
              Width = 75
            end>
          RowSelect = True
          TabOrder = 2
          ViewStyle = vsReport
        end
        object DisplayOutlineCheckBox: TCheckBox
          Left = 13
          Top = 118
          Width = 97
          Height = 17
          Alignment = taLeftJustify
          Caption = 'Display Outline'
          TabOrder = 3
        end
        object DisplayTextCheckBox: TCheckBox
          Left = 13
          Top = 147
          Width = 97
          Height = 17
          Alignment = taLeftJustify
          Caption = 'Display Text'
          TabOrder = 4
        end
      end
      object TPage
        Left = 0
        Top = 0
        Caption = 'ClassBreaksPage'
      end
      object TPage
        Left = 0
        Top = 0
        Caption = 'StandardLabelsPage'
      end
      object TPage
        Left = 0
        Top = 0
        Caption = 'NoOverlappingLabelsPage'
      end
    end
  end
  object MapLayersAvailableTable: TwwTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYLAYERNAME'
    TableName = 'MapLayersAvailable'
    TableType = ttDBase
    SyncSQLByRange = False
    NarrowSearch = False
    ValidateWithMask = True
    Left = 302
    Top = 12
  end
end
