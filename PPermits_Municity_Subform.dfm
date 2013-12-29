object PermitsMunicityEditDialogForm: TPermitsMunicityEditDialogForm
  Left = 370
  Top = 121
  Width = 601
  Height = 561
  Caption = 'PermitsMunicityEditDialogForm'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnCloseQuery = FormCloseQuery
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 13
  object MainToolBar: TToolBar
    Left = 0
    Top = 0
    Width = 585
    Height = 31
    ButtonHeight = 25
    TabOrder = 0
    object SaveAndExitButton: TSpeedButton
      Left = 0
      Top = 2
      Width = 99
      Height = 25
      Caption = 'Save and E&xit'
      Enabled = False
      Flat = True
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000120B0000120B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00330000000000
        03333377777777777F333301111111110333337F333333337F33330111111111
        0333337F333333337F333301111111110333337F333333337F33330111111111
        0333337F333333337F333301111111110333337F333333337F33330111111111
        0333337F3333333F7F333301111111B10333337F333333737F33330111111111
        0333337F333333337F333301111111110333337F33FFFFF37F3333011EEEEE11
        0333337F377777F37F3333011EEEEE110333337F37FFF7F37F3333011EEEEE11
        0333337F377777337F333301111111110333337F333333337F33330111111111
        0333337FFFFFFFFF7F3333000000000003333377777777777333}
      NumGlyphs = 2
      OnClick = SaveAndExitButtonClick
    end
    object SaveButton: TSpeedButton
      Left = 99
      Top = 2
      Width = 23
      Height = 25
      Hint = 'Save'
      Enabled = False
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
      OnClick = SaveButtonClick
    end
    object btnPrintFieldSheet: TSpeedButton
      Left = 122
      Top = 2
      Width = 23
      Height = 25
      Hint = 'Print Field Sheet.'
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
      OnClick = btnPrintFieldSheetClick
    end
    object CancelButton: TSpeedButton
      Left = 145
      Top = 2
      Width = 23
      Height = 25
      Hint = 'Cancel'
      Enabled = False
      Flat = True
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
      OnClick = CancelButtonClick
    end
  end
  object EntryInformationGroupBox: TGroupBox
    Left = 0
    Top = 31
    Width = 585
    Height = 52
    Align = alTop
    Caption = 'Application Information: '
    TabOrder = 1
    object Label1: TLabel
      Left = 8
      Top = 27
      Width = 68
      Height = 13
      Alignment = taCenter
      Caption = 'Application #: '
    end
    object Label2: TLabel
      Left = 273
      Top = 27
      Width = 26
      Height = 13
      Caption = 'Date:'
    end
    object ApplicaNo: TEdit
      Left = 80
      Top = 23
      Width = 113
      Height = 21
      TabStop = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      ReadOnly = True
      TabOrder = 0
      Text = 'ApplicaNo'
    end
    object ApplicaDate1: TEdit
      Left = 304
      Top = 23
      Width = 113
      Height = 21
      TabStop = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      ReadOnly = True
      TabOrder = 1
      Text = 'ApplicaDate1'
    end
  end
  object PermitInformationGroupBox: TGroupBox
    Left = 0
    Top = 83
    Width = 585
    Height = 262
    Align = alTop
    Caption = 'Permit Information: '
    TabOrder = 2
    object Label6: TLabel
      Left = 8
      Top = 27
      Width = 42
      Height = 13
      Caption = 'Permit #:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label15: TLabel
      Left = 145
      Top = 27
      Width = 26
      Height = 13
      Caption = 'Date:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label13: TLabel
      Left = 273
      Top = 27
      Width = 43
      Height = 13
      AutoSize = False
      Caption = 'Status:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      WordWrap = True
    end
    object Label14: TLabel
      Left = 8
      Top = 59
      Width = 27
      Height = 13
      Caption = 'Type:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label10: TLabel
      Left = 145
      Top = 59
      Width = 75
      Height = 13
      AutoSize = False
      Caption = 'Improve Type:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      WordWrap = True
    end
    object Label9: TLabel
      Left = 313
      Top = 59
      Width = 75
      Height = 13
      AutoSize = False
      Caption = 'Proposed Use:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      WordWrap = True
    end
    object Label12: TLabel
      Left = 8
      Top = 84
      Width = 93
      Height = 27
      AutoSize = False
      Caption = 'Construction Start / End Date:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      WordWrap = True
    end
    object Label11: TLabel
      Left = 182
      Top = 91
      Width = 7
      Height = 13
      Alignment = taCenter
      Caption = '/'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label16: TLabel
      Left = 281
      Top = 91
      Width = 49
      Height = 13
      Caption = 'C/O Date:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label20: TLabel
      Left = 438
      Top = 91
      Width = 48
      Height = 13
      Caption = 'C/C Date:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label3: TLabel
      Left = 8
      Top = 200
      Width = 131
      Height = 13
      Caption = 'Assessor'#39's Information:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label4: TLabel
      Left = 8
      Top = 220
      Width = 53
      Height = 13
      Caption = 'Visit Dates:'
    end
    object Label5: TLabel
      Left = 281
      Top = 220
      Width = 77
      Height = 13
      Caption = 'Next Inspection:'
    end
    object Label8: TLabel
      Left = 8
      Top = 248
      Width = 52
      Height = 13
      Caption = 'Comments:'
    end
    object Label7: TLabel
      Left = 446
      Top = 218
      Width = 35
      Height = 13
      Caption = 'Closed:'
    end
    object Label17: TLabel
      Left = 446
      Top = 128
      Width = 54
      Height = 13
      Caption = 'Const Cost:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label18: TLabel
      Left = 8
      Top = 128
      Width = 85
      Height = 13
      Caption = 'Work Description:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Bevel1: TBevel
      Left = 8
      Top = 192
      Width = 569
      Height = 9
      Shape = bsTopLine
    end
    object AssessorTempDate1: TEdit
      Left = 72
      Top = 216
      Width = 75
      Height = 21
      TabOrder = 0
      Text = 'AssessorTempDate1'
      OnChange = EditChange
      OnExit = ChangeDate
    end
    object AssessorTempDate2: TEdit
      Left = 160
      Top = 216
      Width = 75
      Height = 21
      TabOrder = 1
      Text = 'AssessorTempDate2'
      OnChange = EditChange
      OnExit = ChangeDate
    end
    object AssessorOfficeClosed: TCheckBox
      Left = 486
      Top = 216
      Width = 25
      Height = 17
      TabOrder = 3
      OnClick = EditChange
    end
    object AssessorNextInspDate: TEdit
      Left = 360
      Top = 216
      Width = 75
      Height = 21
      TabOrder = 2
      Text = 'AssessorNextInspDate'
      OnChange = EditChange
      OnExit = ChangeDate
    end
    object Description: TMemo
      Left = 104
      Top = 128
      Width = 337
      Height = 57
      TabStop = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      Lines.Strings = (
        'Description')
      ParentFont = False
      ReadOnly = True
      TabOrder = 4
    end
    object PermitNo: TEdit
      Left = 48
      Top = 23
      Width = 89
      Height = 21
      TabStop = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      ReadOnly = True
      TabOrder = 5
      Text = 'PermitNo'
    end
    object PermitDate: TEdit
      Left = 176
      Top = 23
      Width = 89
      Height = 21
      TabStop = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      ReadOnly = True
      TabOrder = 6
      Text = 'PermitDate'
    end
    object PermStatus: TEdit
      Left = 312
      Top = 23
      Width = 115
      Height = 21
      TabStop = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      ReadOnly = True
      TabOrder = 7
      Text = 'PermStatus'
    end
    object PermitType: TEdit
      Left = 40
      Top = 55
      Width = 97
      Height = 21
      TabStop = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      ReadOnly = True
      TabOrder = 8
      Text = 'PermitType'
    end
    object ImproveType: TEdit
      Left = 216
      Top = 55
      Width = 89
      Height = 21
      TabStop = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      ReadOnly = True
      TabOrder = 9
      Text = 'ImproveType'
    end
    object ProposedUse: TEdit
      Left = 384
      Top = 55
      Width = 201
      Height = 21
      TabStop = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      ReadOnly = True
      TabOrder = 10
      Text = 'ProposedUse'
    end
    object StartedDate: TEdit
      Left = 104
      Top = 87
      Width = 75
      Height = 21
      TabStop = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      ReadOnly = True
      TabOrder = 11
      Text = 'StartedDate'
    end
    object CompletedDate: TEdit
      Left = 192
      Top = 87
      Width = 75
      Height = 21
      TabStop = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      ReadOnly = True
      TabOrder = 12
      Text = 'CompletedDate'
    end
    object CertificateDate: TEdit
      Left = 336
      Top = 87
      Width = 75
      Height = 21
      TabStop = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      ReadOnly = True
      TabOrder = 13
      Text = 'CertificateDate'
    end
    object CertComplianceDate: TEdit
      Left = 488
      Top = 87
      Width = 75
      Height = 21
      TabStop = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      ReadOnly = True
      TabOrder = 14
      Text = 'CertComplianceDate'
    end
    object ConstCost: TEdit
      Left = 504
      Top = 128
      Width = 70
      Height = 21
      TabStop = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGreen
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      ReadOnly = True
      TabOrder = 15
      Text = 'ConstCost'
    end
  end
  object AssessorComments: TMemo
    Left = 0
    Top = 345
    Width = 585
    Height = 178
    Align = alClient
    Lines.Strings = (
      '')
    TabOrder = 3
    OnChange = EditChange
  end
  object ButtonsStateTimer: TTimer
    Enabled = False
    Interval = 10
    OnTimer = ButtonsStateTimerTimer
    Left = 442
    Top = 353
  end
  object ADO_MainQuery2: TADOQuery
    ConnectionString = 'FILE NAME=N:\pas32\pasMunicity.udl'
    Parameters = <>
    SQL.Strings = (
      'SELECT'
      ' ApplicaNo, ApplicaDate1, Permit_ID, PermitNo, PermitDate,'
      ' PermStatus, PermitType, ImproveType, ProposedUse,'
      
        ' StartedDate, CompletedDate, CertOccupancyDate, CertComplianceDa' +
        'te,'
      #9'Permits.Description, TotalCost,'
      ' AssessorTempDate1, AssessorTempDate2, AssessorNextInspDate,'
      ' AssessorOfficeClosed, AssessorComments'
      'FROM Permits'
      '')
    Left = 526
    Top = 364
  end
  object qryCertificates: TADOQuery
    ConnectionString = 'FILE NAME=N:\pas32\pasMunicity.udl'
    Parameters = <>
    SQL.Strings = (
      'SELECT'
      ' ApplicaNo, ApplicaDate1, Permit_ID, PermitNo, PermitDate,'
      ' PermStatus, PermitType, ImproveType, ProposedUse,'
      
        ' StartedDate, CompletedDate, CertOccupancyDate, CertComplianceDa' +
        'te,'
      #9'Permits.Description, TotalCost,'
      ' AssessorTempDate1, AssessorTempDate2, AssessorNextInspDate,'
      ' AssessorOfficeClosed, AssessorComments'
      'FROM Permits'
      '')
    Left = 345
    Top = 370
  end
  object PrintDialog: TPrintDialog
    Options = [poPrintToFile]
    Left = 81
    Top = 127
  end
  object ReportFiler: TReportFiler
    StatusFormat = 'Printing page %p'
    UnitsFactor = 1
    Title = 'ReportPrinter Report'
    Orientation = poPortrait
    ScaleX = 100
    ScaleY = 100
    StreamMode = smFile
    OnPrint = ReportPrint
    Left = 26
    Top = 296
  end
  object ReportPrinter: TReportPrinter
    StatusFormat = 'Printing page %p'
    UnitsFactor = 1
    Title = 'ReportPrinter Report'
    Orientation = poPortrait
    ScaleX = 100
    ScaleY = 100
    OnPrint = ReportPrint
    Left = 95
    Top = 293
  end
  object ParcelTable: TTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYTAXROLLYR_SWISSBLKEY'
    TableName = 'TParcelRec'
    TableType = ttDBase
    Left = 269
    Top = 201
  end
end
