object SalesOwnerProgressionForm_New: TSalesOwnerProgressionForm_New
  Left = 346
  Top = 141
  Width = 809
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
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 793
    Height = 623
    ActivePage = tbsHistoryOfOwners
    Align = alClient
    TabOrder = 0
    object tbsHistoryOfOwners: TTabSheet
      Caption = 'History of Owners'
      ImageIndex = 1
      object Panel3: TPanel
        Left = 0
        Top = 551
        Width = 785
        Height = 41
        Align = alBottom
        TabOrder = 0
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
        object DBNavigator1: TDBNavigator
          Left = 261
          Top = 10
          Width = 264
          Height = 25
          DataSource = dsHistoryOfOwners
          VisibleButtons = [nbFirst, nbPrior, nbNext, nbLast, nbPost, nbCancel]
          Flat = True
          TabOrder = 1
        end
      end
      object Panel2: TPanel
        Left = 0
        Top = 0
        Width = 785
        Height = 30
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 1
        object Label1: TLabel
          Left = 5
          Top = 7
          Width = 57
          Height = 16
          Caption = 'Parcel ID:'
        end
        object Label2: TLabel
          Left = 241
          Top = 7
          Width = 68
          Height = 16
          Caption = 'Deed Book:'
        end
        object Label3: TLabel
          Left = 616
          Top = 7
          Width = 58
          Height = 16
          Caption = 'Rec Date:'
        end
        object Label4: TLabel
          Left = 419
          Top = 7
          Width = 68
          Height = 16
          Caption = 'Deed Page:'
        end
        object edDeedBook: TDBEdit
          Left = 314
          Top = 3
          Width = 95
          Height = 24
          TabStop = False
          DataField = 'DeedBook'
          DataSource = dsHistoryOfOwners
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          ReadOnly = True
          TabOrder = 0
        end
        object edDeedPage: TDBEdit
          Left = 492
          Top = 3
          Width = 95
          Height = 24
          TabStop = False
          DataField = 'DeedPage'
          DataSource = dsHistoryOfOwners
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          ReadOnly = True
          TabOrder = 1
        end
        object edDeedDate: TDBEdit
          Left = 682
          Top = 3
          Width = 95
          Height = 24
          TabStop = False
          DataField = 'DeedDate'
          DataSource = dsHistoryOfOwners
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          ReadOnly = True
          TabOrder = 2
        end
        object edParcelID: TDBEdit
          Left = 66
          Top = 3
          Width = 164
          Height = 24
          TabStop = False
          DataField = 'PrintKey'
          DataSource = dsHistoryOfOwners
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          ReadOnly = True
          TabOrder = 3
        end
      end
      object memHistory: TDBMemo
        Left = 0
        Top = 30
        Width = 785
        Height = 521
        Align = alClient
        DataField = 'Note'
        DataSource = dsHistoryOfOwners
        TabOrder = 2
      end
    end
    object tbsProgressionOfOwners: TTabSheet
      Caption = 'Progression of Owners'
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 785
        Height = 594
        Align = alClient
        TabOrder = 0
        object Panel5: TPanel
          Left = 1
          Top = 1
          Width = 783
          Height = 30
          Align = alTop
          BevelOuter = bvNone
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
        end
        object OwnerProgressionListView: TListView
          Left = 1
          Top = 31
          Width = 783
          Height = 562
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
              Width = 250
            end
            item
              Caption = 'New Owner'
              Width = 250
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
          TabOrder = 1
          ViewStyle = vsReport
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
    OnCalcFields = tbHistoryOfOwnersCalcFields
    DatabaseName = 'PASsystem'
    IndexName = 'BYSBL_DEEDDATE_SEQNUM'
    TableType = ttDBase
    Left = 509
    Top = 102
    object tbHistoryOfOwnersSwisSBLKey: TStringField
      FieldName = 'SwisSBLKey'
      Size = 26
    end
    object tbHistoryOfOwnersSequenceNumber: TIntegerField
      FieldName = 'SequenceNumber'
    end
    object tbHistoryOfOwnersDeedBook: TStringField
      FieldName = 'DeedBook'
      Size = 7
    end
    object tbHistoryOfOwnersDeedPage: TStringField
      FieldName = 'DeedPage'
      Size = 7
    end
    object tbHistoryOfOwnersDeedDate: TDateField
      FieldName = 'DeedDate'
    end
    object tbHistoryOfOwnersComment: TStringField
      FieldName = 'Comment'
      Size = 80
    end
    object tbHistoryOfOwnersNote: TMemoField
      FieldName = 'Note'
      BlobType = ftMemo
      Size = 1
    end
    object tbHistoryOfOwnersPrintKey: TStringField
      FieldKind = fkCalculated
      FieldName = 'PrintKey'
      Size = 30
      Calculated = True
    end
  end
  object dsHistoryOfOwners: TDataSource
    DataSet = tbHistoryOfOwners
    Left = 509
    Top = 156
  end
end
