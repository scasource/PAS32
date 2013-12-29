object GrievanceCondoCopyDialog: TGrievanceCondoCopyDialog
  Left = 474
  Top = 95
  Width = 332
  Height = 480
  Caption = 'Please enter destination parcels'
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
  object InformationLabel: TLabel
    Left = 10
    Top = 11
    Width = 305
    Height = 60
    AutoSize = False
    Caption = 
      'Please enter the additional parcels that should have a grievance' +
      ' created ...'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    WordWrap = True
  end
  object OKButton: TBitBtn
    Left = 68
    Top = 412
    Width = 86
    Height = 29
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
    Left = 172
    Top = 413
    Width = 86
    Height = 29
    TabOrder = 1
    Kind = bkCancel
  end
  object ParcelGroupBox: TGroupBox
    Left = 10
    Top = 67
    Width = 305
    Height = 274
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 2
    object ParcelGrid: TStringGrid
      Left = 44
      Top = 18
      Width = 218
      Height = 214
      Hint = 
        'Please enter a parcel ID in the form ss/SBL where ss = short swi' +
        's code.'
      ColCount = 1
      DefaultColWidth = 200
      DefaultRowHeight = 20
      FixedCols = 0
      RowCount = 100
      FixedRows = 0
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goEditing, goTabs, goAlwaysShowEditor]
      ParentFont = False
      ScrollBars = ssVertical
      TabOrder = 0
    end
    object ClearButton: TBitBtn
      Left = 29
      Top = 235
      Width = 73
      Height = 30
      Caption = '&Clear'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
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
      IsControl = True
    end
    object AddButton: TBitBtn
      Left = 116
      Top = 235
      Width = 73
      Height = 30
      Caption = '&Add'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      OnClick = AddButtonClick
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
      IsControl = True
    end
    object DeleteButton: TBitBtn
      Left = 203
      Top = 235
      Width = 73
      Height = 30
      Caption = '&Delete'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
      OnClick = DeleteButtonClick
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000120B0000120B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333000000000
        3333333777777777F3333330F777777033333337F3F3F3F7F3333330F0808070
        33333337F7F7F7F7F3333330F080707033333337F7F7F7F7F3333330F0808070
        33333337F7F7F7F7F3333330F080707033333337F7F7F7F7F3333330F0808070
        333333F7F7F7F7F7F3F33030F080707030333737F7F7F7F7F7333300F0808070
        03333377F7F7F7F773333330F080707033333337F7F7F7F7F333333070707070
        33333337F7F7F7F7FF3333000000000003333377777777777F33330F88877777
        0333337FFFFFFFFF7F3333000000000003333377777777777333333330777033
        3333333337FFF7F3333333333000003333333333377777333333}
      NumGlyphs = 2
      IsControl = True
    end
  end
  object GroupBox1: TGroupBox
    Left = 10
    Top = 350
    Width = 305
    Height = 50
    Caption = ' Asking Value Percent (Optional): '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 3
    object Label1: TLabel
      Left = 21
      Top = 23
      Width = 209
      Height = 16
      Caption = 'Asking Value as % of Current AV: '
    end
    object EditAskingPercent: TEdit
      Left = 239
      Top = 19
      Width = 43
      Height = 24
      TabOrder = 0
    end
  end
  object GrievanceTable: TTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYSWISSBLKEY_TAXROLLYR_GREVNUM'
    TableName = 'grievancetable'
    TableType = ttDBase
    Left = 178
    Top = 191
  end
  object CurrentExemptionsTable: TTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYTAXROLLYR_SWISSBLKEY'
    TableType = ttDBase
    Left = 265
    Top = 178
  end
  object GrievanceExemptionsTable: TTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYYEAR_SWISSBLKEY_EXCODE'
    TableName = 'gpexemptionrec'
    TableType = ttDBase
    Left = 53
    Top = 199
  end
  object CurrentAssessmentTable: TTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYTAXROLLYR_SWISSBLKEY'
    TableType = ttDBase
    Left = 36
    Top = 247
  end
  object GrievanceExemptionsAskedTable: TwwTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYYEAR_SBL_GRVNUM_EX'
    TableName = 'GExemptionsAsked'
    TableType = ttDBase
    ControlType.Strings = (
      'ExemptionCode;CustomEdit;ExemptionCodeAskedLookupCombo')
    SyncSQLByRange = False
    NarrowSearch = False
    ValidateWithMask = True
    Left = 85
    Top = 155
  end
  object GrievanceSpecialDistrictsTable: TTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYYEAR_SBL_GRVNUM_SD'
    TableName = 'gpspcldistrec'
    TableType = ttDBase
    Left = 108
    Top = 270
  end
  object CurrentSpecialDistrictsTable: TTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYTAXROLLYR_SWISSBLKEY'
    TableType = ttDBase
    Left = 60
    Top = 115
  end
  object ParcelTable: TTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYTAXROLLYR_SWISSBLKEY'
    TableName = 'TParcelRec'
    TableType = ttDBase
    Left = 231
    Top = 150
  end
  object SwisCodeTable: TTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYSWISCODE'
    TableType = ttDBase
    Left = 118
    Top = 205
  end
  object PriorAssessmentTable: TTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYTAXROLLYR_SWISSBLKEY'
    TableType = ttDBase
    Left = 171
    Top = 105
  end
  object LawyerCodeTable: TTable
    DatabaseName = 'PASsystem'
    IndexFieldNames = 'Code'
    TableName = 'ZGLawyerCodes'
    TableType = ttDBase
    Left = 250
    Top = 228
  end
  object GrievanceLookupTable: TTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYSWISSBLKEY_TAXROLLYR_GREVNUM'
    TableName = 'GrievanceTable'
    TableType = ttDBase
    Left = 41
    Top = 91
  end
  object GrievanceExemptionsAskedLookupTable: TTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYYEAR_SBL_GRVNUM_EX'
    TableName = 'GExemptionsAsked'
    TableType = ttDBase
    Left = 159
    Top = 243
  end
end
