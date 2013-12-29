object SalesOwnerProgressionForm: TSalesOwnerProgressionForm
  Left = 373
  Top = 79
  Width = 648
  Height = 661
  Caption = 'Owner Progression'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 16
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 632
    Height = 312
    Align = alClient
    TabOrder = 0
    object ProgressionOfOwnersLabel: TLabel
      Left = 4
      Top = 7
      Width = 166
      Height = 16
      Caption = 'Progression of owners for '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Panel2: TPanel
      Left = 1
      Top = 30
      Width = 630
      Height = 281
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 0
      object OwnerProgressionListView: TListView
        Left = 0
        Top = 0
        Width = 630
        Height = 281
        Align = alClient
        Columns = <
          item
            Caption = 'Date'
            Width = 70
          end
          item
            Caption = 'Time'
            Width = 90
          end
          item
            Caption = 'Old Owner'
            Width = 175
          end
          item
            Caption = 'New Owner'
            Width = 175
          end
          item
            Caption = 'Changed By'
            Width = 90
          end>
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        ViewStyle = vsReport
      end
    end
  end
  object pnlHistoryOfOwners: TPanel
    Left = 0
    Top = 312
    Width = 632
    Height = 311
    Align = alBottom
    TabOrder = 1
    object lbHistoryOfOwnersHeader: TLabel
      Left = 4
      Top = 7
      Width = 134
      Height = 16
      Caption = 'History of owners for '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Panel4: TPanel
      Left = 1
      Top = 29
      Width = 630
      Height = 281
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 0
      object lstHistoryOfOwners: TListView
        Left = 0
        Top = 0
        Width = 630
        Height = 240
        Align = alClient
        Columns = <
          item
            Caption = 'Liber'
            Width = 65
          end
          item
            Caption = 'Page'
            Width = 65
          end
          item
            Caption = 'Deed Date'
            Width = 75
          end
          item
            Caption = 'Seq #'
          end
          item
            Caption = 'Comment'
            Width = 350
          end>
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        ViewStyle = vsReport
      end
      object Panel3: TPanel
        Left = 0
        Top = 240
        Width = 630
        Height = 41
        Align = alBottom
        TabOrder = 1
        object btnAddHistoryOfOwnersEntry: TBitBtn
          Left = 15
          Top = 6
          Width = 146
          Height = 29
          Caption = 'Add History Info'
          TabOrder = 0
          OnClick = btnAddHistoryOfOwnersEntryClick
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
      end
    end
  end
  object SalesTable: TTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYSWISSBLKEY_SALENUMBER'
    TableName = 'psalesrec'
    TableType = ttDBase
    Left = 136
    Top = 240
  end
  object AuditNameAddressTable: TTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYSWISSBLKEY_DATE_TIME'
    TableName = 'AuditNameAddress'
    TableType = ttDBase
    Left = 442
    Top = 250
  end
  object tbHistoryOfOwners: TTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYSBL_DEEDDATE_SEQNUM'
    TableType = ttDBase
    Left = 293
    Top = 536
  end
  object MemoDialogBox: TMemoDialogBox
    Left = 309
    Top = 238
  end
end
