object SmallClaimsAddDialog: TSmallClaimsAddDialog
  Left = 231
  Top = 152
  Width = 358
  Height = 400
  ActiveControl = EditIndexNumber
  Caption = 'Please enter the new small claims.'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 16
  object OKButton: TBitBtn
    Left = 79
    Top = 311
    Width = 86
    Height = 33
    Caption = 'OK'
    TabOrder = 3
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
    Left = 184
    Top = 311
    Width = 86
    Height = 33
    TabOrder = 4
    Kind = bkCancel
  end
  object GroupBox1: TGroupBox
    Left = 17
    Top = 210
    Width = 317
    Height = 92
    TabOrder = 2
    object Label2: TLabel
      Left = 13
      Top = 56
      Width = 99
      Height = 16
      Caption = 'Representative:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label1: TLabel
      Left = 10
      Top = 12
      Width = 280
      Height = 37
      AutoSize = False
      Caption = 
        'Please choose the code of the representative for this small clai' +
        'ms case.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      WordWrap = True
    end
    object LawyerCodeLookupCombo: TwwDBLookupCombo
      Left = 121
      Top = 52
      Width = 162
      Height = 24
      DropDownAlignment = taLeftJustify
      Selected.Strings = (
        'Code'#9'10'#9'Code'#9'F'
        'Name1'#9'15'#9'Name'#9'F')
      LookupTable = LawyerCodeTable
      LookupField = 'Code'
      Options = [loColLines, loRowLines, loTitles]
      Style = csDropDownList
      TabOrder = 0
      AutoDropDown = True
      ShowButton = True
      AllowClearKey = False
      OnNotInList = LawyerCodeLookupComboNotInList
    end
    object NewLawyerButton: TBitBtn
      Left = 283
      Top = 49
      Width = 29
      Height = 30
      Hint = 'Create a new representative code.'
      TabOrder = 1
      OnClick = NewLawyerButtonClick
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
  object GroupBox2: TGroupBox
    Left = 17
    Top = 116
    Width = 317
    Height = 92
    TabOrder = 1
    object Label3: TLabel
      Left = 13
      Top = 55
      Width = 94
      Height = 16
      Caption = 'Index Number:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label4: TLabel
      Left = 10
      Top = 12
      Width = 280
      Height = 39
      AutoSize = False
      Caption = 'Please enter the index number assigned by the court.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      WordWrap = True
    end
    object EditIndexNumber: TEdit
      Left = 146
      Top = 52
      Width = 64
      Height = 24
      TabOrder = 0
    end
  end
  object ProgressBar: TProgressBar
    Left = 0
    Top = 348
    Width = 342
    Height = 16
    Align = alBottom
    Min = 0
    Max = 100
    TabOrder = 5
    Visible = False
  end
  object GrievanceYearGroupBox: TGroupBox
    Left = 17
    Top = 2
    Width = 317
    Height = 116
    TabOrder = 0
    object Label5: TLabel
      Left = 14
      Top = 86
      Width = 121
      Height = 16
      Caption = 'Small Claims Year:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label6: TLabel
      Left = 10
      Top = 12
      Width = 280
      Height = 67
      AutoSize = False
      Caption = 
        'Please enter the assessment year that this small claims applies ' +
        'to.  Only change this year if you are entering small claims info' +
        'rmation for prior years.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      WordWrap = True
    end
    object EditSmallClaimsYear: TEdit
      Left = 146
      Top = 83
      Width = 64
      Height = 24
      TabOrder = 0
      OnExit = EditSmallClaimsYearExit
    end
  end
  object LawyerCodeTable: TTable
    DatabaseName = 'PASsystem'
    IndexFieldNames = 'Code'
    TableName = 'ZGLawyerCodes'
    TableType = ttDBase
    Left = 269
    Top = 184
  end
  object SmallClaimsTable: TTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYYEAR_INDEXNUM'
    TableName = 'gsmallclaimstable'
    TableType = ttDBase
    Left = 221
    Top = 228
  end
  object CheckForGrievanceTimer: TTimer
    Enabled = False
    Interval = 1
    OnTimer = CheckForGrievanceTimerTimer
    Left = 73
    Top = 159
  end
  object GrievanceTable: TTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYSWISSBLKEY_TAXROLLYR_GREVNUM'
    TableName = 'GrievanceTable'
    TableType = ttDBase
    Left = 283
    Top = 294
  end
  object SwisCodeTable: TTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYSWISCODE'
    TableType = ttDBase
    Left = 270
    Top = 165
  end
  object HistorySwisCodeTable: TTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYTAXROLLYR_SWISCODE'
    TableName = 'Hswistbl'
    TableType = ttDBase
    Left = 282
    Top = 206
  end
  object PriorAssessmentTable: TTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYTAXROLLYR_SWISSBLKEY'
    TableType = ttDBase
    Left = 28
    Top = 288
  end
  object CurrentAssessmentTable: TTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYTAXROLLYR_SWISSBLKEY'
    TableType = ttDBase
    Left = 175
    Top = 221
  end
  object PriorSwisCodeTable: TTable
    DatabaseName = 'PASsystem'
    TableType = ttDBase
    Left = 43
    Top = 131
  end
  object ParcelTable: TTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYTAXROLLYR_SWISSBLKEY'
    TableName = 'TParcelRec'
    TableType = ttDBase
    Left = 46
    Top = 232
  end
  object SmallClaimsExemptionsAskedTable: TTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYYEAR_SBL_INDEXNUM_EX'
    TableName = 'gscexemptionsasked'
    TableType = ttDBase
    Left = 53
    Top = 168
  end
  object SmallClaimsExemptionsTable: TTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYTAXROLLYR_SWISSBLKEY'
    TableName = 'gscexemptionrec'
    TableType = ttDBase
    Left = 125
    Top = 168
  end
  object CurrentSalesTable: TTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYSWISSBLKEY_SALENUMBER'
    TableName = 'psalesrec'
    TableType = ttDBase
    Left = 199
    Top = 155
  end
  object CurrentExemptionsTable: TTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYTAXROLLYR_SWISSBLKEY'
    TableType = ttDBase
    Left = 159
    Top = 112
  end
  object SmallClaimsSpecialDistrictsTable: TTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYTAXROLLYR_SWISSBLKEY'
    TableName = 'gscspcldistrec'
    TableType = ttDBase
    Left = 241
    Top = 121
  end
  object CurrentSpecialDistrictsTable: TTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYTAXROLLYR_SWISSBLKEY'
    TableType = ttDBase
    Left = 120
    Top = 141
  end
  object SmallClaimsSalesTable: TTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYSWISSBL_INDEXNUM_SALENUM'
    TableName = 'gscpsalesrec'
    TableType = ttDBase
    Left = 215
    Top = 140
  end
  object GrievanceExemptionsAskedTable: TTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYYEAR_SBL_GRVNUM_EX'
    TableName = 'GExemptionsAsked'
    TableType = ttDBase
    Left = 53
    Top = 194
  end
  object GrievanceDispositionCodeTable: TTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYCODE'
    TableName = 'ZGBOARDispositionCode'
    TableType = ttDBase
    Left = 89
    Top = 15
  end
  object GrievanceResultsTable: TTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYYEAR_SBL_GRVNUM_RSLT'
    TableName = 'grievanceresultstable'
    TableType = ttDBase
    Left = 308
    Top = 61
  end
end
