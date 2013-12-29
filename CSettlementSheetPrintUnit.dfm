object CertiorariSettlementForm: TCertiorariSettlementForm
  Left = 53
  Top = 140
  Width = 591
  Height = 480
  ActiveControl = EditPetitioner
  Caption = 'Settlement Sheet Print'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Arial'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 16
  object Label1: TLabel
    Left = 20
    Top = 9
    Width = 125
    Height = 16
    Caption = 'Refund Calculation:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object TotalRefundLabel: TLabel
    Left = 473
    Top = 193
    Width = 77
    Height = 16
    Alignment = taRightJustify
    Caption = 'TotRefLabel'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 381
    Top = 193
    Width = 85
    Height = 16
    Caption = 'Total Refund:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label3: TLabel
    Left = 20
    Top = 232
    Width = 66
    Height = 16
    Caption = 'Petitioner:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label4: TLabel
    Left = 20
    Top = 299
    Width = 57
    Height = 16
    Caption = 'Lawyers:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label5: TLabel
    Left = 20
    Top = 332
    Width = 93
    Height = 16
    Caption = 'Property Type:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label6: TLabel
    Left = 20
    Top = 366
    Width = 95
    Height = 16
    Caption = 'Special Terms:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label7: TLabel
    Left = 20
    Top = 399
    Width = 33
    Height = 16
    Caption = 'Date:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label8: TLabel
    Left = 20
    Top = 265
    Width = 46
    Height = 16
    Caption = 'Owner:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object SettlementGrid: TwwDBGrid
    Left = 21
    Top = 28
    Width = 550
    Height = 163
    ControlType.Strings = (
      'Include;CheckBox;True;False')
    Selected.Strings = (
      'Include'#9'5'#9'Include'
      'TaxRollYr'#9'6'#9'Tax~Year'
      'CertiorariNumber'#9'10'#9'Certiorari~Number'
      'OriginalAssessment'#9'12'#9'Original~Assessment'
      'CorrectedAssessment'#9'12'#9'Corrected~Assessment'
      'AssessmentReduction'#9'11'#9'Assessment~Reduction'
      'TaxRefund'#9'11'#9'Tax~Refund')
    IniAttributes.Delimiter = ';;'
    TitleColor = clBtnFace
    FixedCols = 0
    ShowHorzScrollBar = True
    EditControlOptions = [ecoCheckboxSingleClick, ecoSearchOwnerForm]
    DataSource = SortSettlementSheetDataSource
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    KeyOptions = [dgEnterToTab]
    ParentFont = False
    TabOrder = 7
    TitleAlignment = taCenter
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clBlue
    TitleFont.Height = -13
    TitleFont.Name = 'Arial'
    TitleFont.Style = [fsBold]
    TitleLines = 2
    TitleButtons = False
    OnColExit = SettlementGridColExit
    IndicatorColor = icBlack
  end
  object EditPetitioner: TEdit
    Left = 123
    Top = 228
    Width = 323
    Height = 24
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
  end
  object EditLawyers: TEdit
    Left = 123
    Top = 295
    Width = 323
    Height = 24
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
  end
  object EditPropertyType: TEdit
    Left = 123
    Top = 328
    Width = 323
    Height = 24
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 2
  end
  object PrintButton: TBitBtn
    Left = 312
    Top = 406
    Width = 80
    Height = 31
    Caption = 'Print'
    TabOrder = 5
    OnClick = PrintButtonClick
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
  end
  object CancelButton: TBitBtn
    Left = 430
    Top = 406
    Width = 80
    Height = 31
    TabOrder = 6
    Kind = bkCancel
  end
  object EditSpecialTerms: TEdit
    Left = 123
    Top = 362
    Width = 323
    Height = 24
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 3
  end
  object EditDate: TMaskEdit
    Left = 123
    Top = 395
    Width = 88
    Height = 24
    EditMask = '!99/99/0000;1;_'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    MaxLength = 10
    ParentFont = False
    TabOrder = 4
    Text = '  /  /    '
  end
  object EditOwner: TEdit
    Left = 123
    Top = 260
    Width = 323
    Height = 24
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 8
  end
  object SortSettlementSheetTable: TTable
    AfterEdit = SortSettlementSheetTableAfterEdit
    BeforePost = SortSettlementSheetTableBeforePost
    AfterPost = SortSettlementSheetTableAfterPost
    DatabaseName = 'PASsystem'
    TableName = 'sortcertiorarisettlementtable'
    TableType = ttDBase
    Left = 240
    Top = 108
  end
  object SortSettlementSheetDataSource: TDataSource
    DataSet = SortSettlementSheetTable
    Left = 93
    Top = 109
  end
  object CertiorariTable: TTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYSWISSBLKEY_TAXROLLYR'
    TableName = 'GCertiorariTable'
    TableType = ttDBase
    Left = 51
    Top = 161
  end
  object LawyerTable: TTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYCODE'
    TableName = 'zglawyercodes'
    TableType = ttDBase
    Left = 248
    Top = 161
  end
  object PropertyClassTable: TTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYMAINCODE'
    TableName = 'zpropclstbl'
    TableType = ttDBase
    Left = 371
    Top = 129
  end
  object TaxRateTable: TTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYYEAR_COLLTYPE_NUM_ORDER'
    TableName = 'BCollGeneralRateFile'
    TableType = ttDBase
    Left = 145
    Top = 176
  end
  object ReportFiler: TReportFiler
    StatusFormat = 'Printing page %p'
    UnitsFactor = 1
    Title = 'ReportPrinter Report'
    Orientation = poPortrait
    ScaleX = 100
    ScaleY = 100
    OnPrint = ReportPrint
    Left = 299
    Top = 28
  end
  object ReportPrinter: TReportPrinter
    StatusFormat = 'Printing page %p'
    UnitsFactor = 1
    Title = 'ReportPrinter Report'
    Orientation = poPortrait
    ScaleX = 100
    ScaleY = 100
    OnPrint = ReportPrint
    Left = 216
    Top = 93
  end
  object PrintDialog: TPrintDialog
    Options = [poPrintToFile]
    Left = 459
    Top = 268
  end
  object SwisCodeTable: TTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYSWISCODE'
    TableName = 'tswistbl'
    TableType = ttDBase
    Left = 416
    Top = 43
  end
  object AssessorsOfficeTable: TTable
    DatabaseName = 'PASsystem'
    IndexName = 'MUNICIPALCODE'
    TableName = 'AssessorOfficeTable'
    TableType = ttDBase
    Left = 309
    Top = 56
  end
  object SchoolCodeTable: TTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYSCHOOLCODE'
    TableName = 'TSchoolTbl'
    TableType = ttDBase
    Left = 157
    Top = 52
  end
end
