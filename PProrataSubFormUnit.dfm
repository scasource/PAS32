object ProrataSubform: TProrataSubform
  Left = 265
  Top = 102
  Width = 640
  Height = 480
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 13
  object ProrataDetailPageControl: TPageControl
    Left = 0
    Top = 0
    Width = 632
    Height = 446
    ActivePage = GeneralInformationTabSheet
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
    object GeneralInformationTabSheet: TTabSheet
      Caption = 'General'
      ImageIndex = 1
      object Panel2: TPanel
        Left = 0
        Top = 0
        Width = 624
        Height = 196
        Align = alTop
        TabOrder = 0
        object OwnerGroupBox: TGroupBox
          Left = 4
          Top = -2
          Width = 317
          Height = 191
          Caption = ' Owner: '
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
          object Label12: TLabel
            Left = 20
            Top = 18
            Width = 48
            Height = 16
            Caption = 'Name 1'
            FocusControl = EditName
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -13
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label13: TLabel
            Left = 20
            Top = 44
            Width = 48
            Height = 16
            Caption = 'Name 2'
            FocusControl = EditName2
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -13
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label14: TLabel
            Left = 20
            Top = 68
            Width = 41
            Height = 16
            Caption = 'Addr 1'
            FocusControl = EditAddress
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -13
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label15: TLabel
            Left = 20
            Top = 93
            Width = 41
            Height = 16
            Caption = 'Addr 2'
            FocusControl = EditAddress2
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -13
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label16: TLabel
            Left = 20
            Top = 117
            Width = 38
            Height = 16
            Caption = 'Street'
            FocusControl = EditStreet
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -13
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object SwisLabel: TLabel
            Left = 20
            Top = 142
            Width = 24
            Height = 16
            Caption = 'City'
            FocusControl = EditCity
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -13
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label17: TLabel
            Left = 20
            Top = 167
            Width = 33
            Height = 16
            Caption = 'State'
            FocusControl = EditState
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -13
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label18: TLabel
            Left = 123
            Top = 167
            Width = 19
            Height = 16
            Caption = 'Zip'
            FocusControl = EditZip
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -13
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label28: TLabel
            Left = 203
            Top = 167
            Width = 4
            Height = 16
            Caption = '-'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -13
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object EditName: TDBEdit
            Left = 73
            Top = 15
            Width = 213
            Height = 23
            CharCase = ecUpperCase
            DataField = 'Name1'
            DataSource = ProrataHeaderDataSource
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clRed
            Font.Height = -12
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 0
          end
          object EditName2: TDBEdit
            Left = 73
            Top = 40
            Width = 213
            Height = 23
            DataField = 'Name2'
            DataSource = ProrataHeaderDataSource
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlue
            Font.Height = -12
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 1
          end
          object EditAddress: TDBEdit
            Left = 73
            Top = 65
            Width = 213
            Height = 23
            DataField = 'Address1'
            DataSource = ProrataHeaderDataSource
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlue
            Font.Height = -12
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 2
          end
          object EditAddress2: TDBEdit
            Left = 73
            Top = 90
            Width = 213
            Height = 23
            DataField = 'Address2'
            DataSource = ProrataHeaderDataSource
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlue
            Font.Height = -12
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 3
          end
          object EditStreet: TDBEdit
            Left = 73
            Top = 114
            Width = 213
            Height = 23
            DataField = 'Street'
            DataSource = ProrataHeaderDataSource
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlue
            Font.Height = -12
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 4
          end
          object EditCity: TDBEdit
            Left = 73
            Top = 139
            Width = 213
            Height = 23
            DataField = 'City'
            DataSource = ProrataHeaderDataSource
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlue
            Font.Height = -12
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 5
          end
          object EditState: TDBEdit
            Left = 73
            Top = 164
            Width = 33
            Height = 23
            CharCase = ecUpperCase
            DataField = 'State'
            DataSource = ProrataHeaderDataSource
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlue
            Font.Height = -12
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 6
          end
          object EditZip: TDBEdit
            Left = 148
            Top = 164
            Width = 50
            Height = 23
            DataField = 'Zip'
            DataSource = ProrataHeaderDataSource
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlue
            Font.Height = -12
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 7
          end
          object EditZipPlus4: TDBEdit
            Left = 214
            Top = 164
            Width = 40
            Height = 23
            DataField = 'ZipPlus4'
            DataSource = ProrataHeaderDataSource
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlue
            Font.Height = -12
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 8
          end
        end
        object ProrataInformationGroupBox: TGroupBox
          Left = 328
          Top = -2
          Width = 293
          Height = 191
          Caption = ' Prorata Information: '
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 1
          object Label2: TLabel
            Left = 12
            Top = 33
            Width = 65
            Height = 34
            AutoSize = False
            Caption = 'Effective Date:'
            FocusControl = EditSalesDate
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -13
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            WordWrap = True
          end
          object Label3: TLabel
            Left = 12
            Top = 116
            Width = 79
            Height = 34
            AutoSize = False
            Caption = 'Calculation Date:'
            FocusControl = EditCalculationDate
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -13
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            WordWrap = True
          end
          object Label4: TLabel
            Left = 12
            Top = 75
            Width = 58
            Height = 34
            AutoSize = False
            Caption = 'Removal Date:'
            FocusControl = EditRemovalDate
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -13
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            WordWrap = True
          end
          object EditSalesDate: TDBEdit
            Left = 101
            Top = 39
            Width = 80
            Height = 23
            DataField = 'SaleDate'
            DataSource = ProrataHeaderDataSource
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlue
            Font.Height = -12
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 0
          end
          object EditCalculationDate: TDBEdit
            Left = 101
            Top = 122
            Width = 80
            Height = 23
            DataField = 'CalculationDate'
            DataSource = ProrataHeaderDataSource
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlue
            Font.Height = -12
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 1
          end
          object EditRemovalDate: TDBEdit
            Left = 101
            Top = 81
            Width = 80
            Height = 23
            DataField = 'RemovalDate'
            DataSource = ProrataHeaderDataSource
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlue
            Font.Height = -12
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 2
          end
        end
      end
      object Panel5: TPanel
        Left = 0
        Top = 196
        Width = 624
        Height = 219
        Align = alClient
        TabOrder = 1
        object Panel6: TPanel
          Left = 1
          Top = 168
          Width = 622
          Height = 50
          Align = alBottom
          TabOrder = 0
          object NewExemptionButton: TBitBtn
            Left = 3
            Top = 9
            Width = 114
            Height = 33
            Caption = '&New Exemption'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TabOrder = 0
            OnClick = NewExemptionButtonClick
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
            Spacing = 2
          end
          object DeleteExemptionButton: TBitBtn
            Left = 178
            Top = 9
            Width = 132
            Height = 33
            Caption = '&Remove Exemption'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TabOrder = 1
            OnClick = DeleteExemptionButtonClick
            Glyph.Data = {
              16020000424D160200000000000076000000280000001A0000001A0000000100
              040000000000A001000000000000000000001000000000000000000000000000
              BF0000BF000000BFBF00BF000000BF00BF00BFBF0000C0C0C000808080000000
              FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
              7777777777777709400077777777777777777799977777000000777777777777
              77777999977777FFFF0079997788888888889999777777FFFF00799997888888
              88899998777777FFFF00779999444444444999887777770000007779999FBFBF
              BF999488777777000000777799999BFBF99994887777770000007777799999BF
              9999B488777777000000777774F99999999BF488777777000000777774BF9999
              99BFB488777777FFFF00777774FBF9999BFBF488777777FFFFC0777774BF9999
              99BFB488777777FFFF00777774F99999999BF488777777FFFF007777749999BF
              9999B488777777FFFF00777774999BFBF9999488777777FFFF0077777999BFBF
              B499999777777700FFFF77779999FBFBF4F9999977777700F9007779999FBFBF
              B4B479999777771E8000779999FBFBFBF4477799997777000000799994444444
              4477777999777700800079997777777777777777997777008000799777777777
              7777777777777700800077777777777777777777777777008000777777777777
              7777777777777700800077777777777777777777777777008000}
            Spacing = 2
          end
        end
        object Panel7: TPanel
          Left = 1
          Top = 1
          Width = 622
          Height = 19
          Align = alTop
          TabOrder = 1
          object Label1: TLabel
            Left = 3
            Top = 2
            Width = 78
            Height = 16
            Caption = 'Exemptions:'
          end
        end
        object ProrataExemptionGrid: TwwDBGrid
          Left = 1
          Top = 20
          Width = 622
          Height = 148
          Selected.Strings = (
            'ExemptionCode'#9'5'#9'Exemption~Code'
            'TaxRollYr'#9'10'#9'Tax Year'
            'HomesteadCode'#9'1'#9'Hstd~Code'
            'CountyAmount'#9'12'#9'County~Amount'
            'TownAmount'#9'12'#9'Town~Amount'
            'SchoolAmount'#9'12'#9'School~Amount')
          IniAttributes.Delimiter = ';;'
          TitleColor = clBtnFace
          FixedCols = 0
          ShowHorzScrollBar = True
          Align = alClient
          DataSource = ProrataExemptionsDataSource
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgWordWrap]
          ParentFont = False
          TabOrder = 2
          TitleAlignment = taCenter
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clBlue
          TitleFont.Height = -13
          TitleFont.Name = 'Arial'
          TitleFont.Style = [fsBold]
          TitleLines = 2
          TitleButtons = False
          OnDblClick = ProrataExemptionGridDblClick
          IndicatorColor = icBlack
        end
      end
    end
    object DetailsTabSheet: TTabSheet
      Caption = 'Details'
      ImageIndex = 1
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 624
        Height = 415
        Align = alClient
        TabOrder = 0
        object Panel3: TPanel
          Left = 1
          Top = 364
          Width = 622
          Height = 50
          Align = alBottom
          TabOrder = 0
          object NewDetailButton: TBitBtn
            Left = 3
            Top = 9
            Width = 114
            Height = 33
            Caption = '&New Detail'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TabOrder = 0
            OnClick = NewDetailButtonClick
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
            Spacing = 2
          end
          object DeleteDetailButton: TBitBtn
            Left = 178
            Top = 9
            Width = 132
            Height = 33
            Caption = '&Remove Detail'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TabOrder = 1
            OnClick = DeleteDetailButtonClick
            Glyph.Data = {
              16020000424D160200000000000076000000280000001A0000001A0000000100
              040000000000A001000000000000000000001000000000000000000000000000
              BF0000BF000000BFBF00BF000000BF00BF00BFBF0000C0C0C000808080000000
              FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
              7777777777777709400077777777777777777799977777000000777777777777
              77777999977777FFFF0079997788888888889999777777FFFF00799997888888
              88899998777777FFFF00779999444444444999887777770000007779999FBFBF
              BF999488777777000000777799999BFBF99994887777770000007777799999BF
              9999B488777777000000777774F99999999BF488777777000000777774BF9999
              99BFB488777777FFFF00777774FBF9999BFBF488777777FFFFC0777774BF9999
              99BFB488777777FFFF00777774F99999999BF488777777FFFF007777749999BF
              9999B488777777FFFF00777774999BFBF9999488777777FFFF0077777999BFBF
              B499999777777700FFFF77779999FBFBF4F9999977777700F9007779999FBFBF
              B4B479999777771E8000779999FBFBFBF4477799997777000000799994444444
              4477777999777700800079997777777777777777997777008000799777777777
              7777777777777700800077777777777777777777777777008000777777777777
              7777777777777700800077777777777777777777777777008000}
            Spacing = 2
          end
        end
        object Panel4: TPanel
          Left = 1
          Top = 1
          Width = 622
          Height = 363
          Align = alClient
          TabOrder = 1
          object ProrataDetailsGrid: TwwDBGrid
            Left = 1
            Top = 1
            Width = 620
            Height = 361
            Selected.Strings = (
              'GeneralTaxType'#9'10'#9'Tax Type'
              'TaxRollYr'#9'4'#9'Tax~Year'
              'LevyDescription'#9'25'#9'Levy Description'#9'F'
              'HomesteadCode'#9'1'#9'Hstd~Code'
              'Days'#9'4'#9'Days'
              'TaxRate'#9'10'#9'Tax Rate'
              'ExemptionAmount'#9'10'#9'Exemption~Amount'
              'TaxAmount'#9'10'#9'Tax~Amount')
            IniAttributes.Delimiter = ';;'
            TitleColor = clBtnFace
            FixedCols = 0
            ShowHorzScrollBar = True
            Align = alClient
            DataSource = ProrataDetailsDataSource
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgWordWrap]
            ParentFont = False
            TabOrder = 0
            TitleAlignment = taCenter
            TitleFont.Charset = DEFAULT_CHARSET
            TitleFont.Color = clBlue
            TitleFont.Height = -13
            TitleFont.Name = 'Arial'
            TitleFont.Style = [fsBold]
            TitleLines = 2
            TitleButtons = False
            OnDblClick = ProrataDetailsGridDblClick
            IndicatorColor = icBlack
          end
        end
      end
    end
  end
  object ProrataHeaderTable: TwwTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYSWISSBLKEY_YEAR'
    TableName = 'ProrataHeader'
    TableType = ttDBase
    SyncSQLByRange = False
    NarrowSearch = False
    ValidateWithMask = True
    Left = 61
    Top = 283
  end
  object ProrataDetailsTable: TwwTable
    DatabaseName = 'PASsystem'
    IndexName = 'SBL_PYR_CATEGORY_TAXTYPE_TYR'
    TableName = 'ProrataDetails'
    TableType = ttDBase
    SyncSQLByRange = False
    NarrowSearch = False
    ValidateWithMask = True
    Left = 187
    Top = 294
  end
  object ProrataExemptionsTable: TwwTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYSBL_PYR_CAT_YEAR_EX'
    TableName = 'ProrataExemptions'
    TableType = ttDBase
    SyncSQLByRange = False
    NarrowSearch = False
    ValidateWithMask = True
    Left = 337
    Top = 296
  end
  object ProrataHeaderDataSource: TwwDataSource
    DataSet = ProrataHeaderTable
    Left = 61
    Top = 338
  end
  object ProrataDetailsDataSource: TwwDataSource
    DataSet = ProrataDetailsTable
    Left = 197
    Top = 342
  end
  object ProrataExemptionsDataSource: TwwDataSource
    DataSet = ProrataExemptionsTable
    Left = 333
    Top = 345
  end
  object tb_ProrataDetailsLookup: TwwTable
    DatabaseName = 'PASsystem'
    IndexName = 'SBL_PYR_CATEGORY_TAXTYPE_TYR'
    TableName = 'ProrataDetails'
    TableType = ttDBase
    SyncSQLByRange = False
    NarrowSearch = False
    ValidateWithMask = True
    Left = 196
    Top = 237
  end
  object tb_ProrataExemptionsLookup: TwwTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYSBL_PYR_CAT_YEAR_EX'
    TableName = 'ProrataExemptions'
    TableType = ttDBase
    SyncSQLByRange = False
    NarrowSearch = False
    ValidateWithMask = True
    Left = 344
    Top = 236
  end
end
