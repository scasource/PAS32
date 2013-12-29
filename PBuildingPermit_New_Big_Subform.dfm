object BigBuildingPermitSubform: TBigBuildingPermitSubform
  Left = 351
  Top = 318
  Width = 620
  Height = 460
  ActiveControl = EditVisitDate1
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  OnKeyDown = FormKeyDown
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 604
    Height = 384
    Align = alClient
    Color = clWhite
    TabOrder = 0
    object BuildingDepartmentInformationGroupBox: TGroupBox
      Left = 1
      Top = 1
      Width = 602
      Height = 207
      Align = alTop
      Caption = ' Building Department Information: '
      Color = clBtnFace
      ParentColor = False
      TabOrder = 0
      object Label3: TLabel
        Left = 6
        Top = 31
        Width = 43
        Height = 15
        Caption = 'Applic #'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object Label6: TLabel
        Left = 310
        Top = 31
        Width = 46
        Height = 15
        Caption = 'Permit #'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object Label8: TLabel
        Left = 540
        Top = 149
        Width = 56
        Height = 15
        Caption = 'Total Cost'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object Label9: TLabel
        Left = 465
        Top = 61
        Width = 58
        Height = 27
        AutoSize = False
        Caption = 'Proposed Use'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        WordWrap = True
      end
      object Label10: TLabel
        Left = 310
        Top = 59
        Width = 52
        Height = 31
        AutoSize = False
        Caption = 'Improve Type'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        WordWrap = True
      end
      object Label12: TLabel
        Left = 6
        Top = 98
        Width = 93
        Height = 27
        AutoSize = False
        Caption = 'Construction Start / End Date'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        WordWrap = True
      end
      object Label13: TLabel
        Left = 6
        Top = 59
        Width = 54
        Height = 31
        AutoSize = False
        Caption = 'Permit Status'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        WordWrap = True
      end
      object Label14: TLabel
        Left = 154
        Top = 66
        Width = 65
        Height = 15
        Caption = 'Permit Type'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object Label15: TLabel
        Left = 462
        Top = 31
        Width = 65
        Height = 15
        Caption = 'Permit Date'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object Label11: TLabel
        Left = 184
        Top = 106
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
      object Label16: TLabel
        Left = 310
        Top = 107
        Width = 50
        Height = 15
        Caption = 'C/O Date'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object Label19: TLabel
        Left = 6
        Top = 139
        Width = 72
        Height = 45
        AutoSize = False
        Caption = 'Work Description'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        WordWrap = True
      end
      object Label20: TLabel
        Left = 462
        Top = 107
        Width = 50
        Height = 15
        Caption = 'C/C Date'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object Label22: TLabel
        Left = 154
        Top = 31
        Width = 62
        Height = 15
        Caption = 'Applic Date'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object ApplicationNoDBEdit: TDBEdit
        Left = 66
        Top = 27
        Width = 75
        Height = 24
        TabStop = False
        Color = clBtnFace
        DataField = 'ApplicaNo'
        DataSource = BigBuildingDataSource
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        ReadOnly = True
        TabOrder = 0
      end
      object PermitNoDBEdit: TDBEdit
        Left = 378
        Top = 27
        Width = 75
        Height = 24
        TabStop = False
        Color = clBtnFace
        DataField = 'PermitNo'
        DataSource = BigBuildingDataSource
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        ReadOnly = True
        TabOrder = 1
      end
      object PermitTypeEdit: TDBEdit
        Left = 226
        Top = 62
        Width = 75
        Height = 24
        TabStop = False
        Color = clBtnFace
        DataField = 'PermitType'
        DataSource = BigBuildingDataSource
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        ReadOnly = True
        TabOrder = 2
      end
      object PermitDateEdit: TDBEdit
        Left = 531
        Top = 27
        Width = 75
        Height = 24
        TabStop = False
        Color = clBtnFace
        DataField = 'PermitDate'
        DataSource = BigBuildingDataSource
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        ReadOnly = True
        TabOrder = 3
      end
      object ProposedUseDBEdit: TDBEdit
        Left = 531
        Top = 62
        Width = 75
        Height = 24
        TabStop = False
        Color = clBtnFace
        DataField = 'ProposedUse'
        DataSource = BigBuildingDataSource
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        ReadOnly = True
        TabOrder = 4
      end
      object ImproveTypeDBEdit: TDBEdit
        Left = 378
        Top = 62
        Width = 75
        Height = 24
        TabStop = False
        Color = clBtnFace
        DataField = 'ImproveType'
        DataSource = BigBuildingDataSource
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        ReadOnly = True
        TabOrder = 5
      end
      object ConstructionEndDateDBEdit: TDBEdit
        Left = 200
        Top = 103
        Width = 75
        Height = 24
        TabStop = False
        Color = clBtnFace
        DataField = 'CompletedDate'
        DataSource = BigBuildingDataSource
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        ReadOnly = True
        TabOrder = 6
      end
      object TotalCostEdit: TDBEdit
        Left = 531
        Top = 171
        Width = 75
        Height = 24
        TabStop = False
        Color = clBtnFace
        DataField = 'TotalCost'
        DataSource = BigBuildingDataSource
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGreen
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        ReadOnly = True
        TabOrder = 7
      end
      object ContstrStartDBEdit: TDBEdit
        Left = 102
        Top = 103
        Width = 75
        Height = 24
        TabStop = False
        Color = clBtnFace
        DataField = 'StartedDate'
        DataSource = BigBuildingDataSource
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        ReadOnly = True
        TabOrder = 8
      end
      object StatusDBEdit: TDBEdit
        Left = 66
        Top = 62
        Width = 75
        Height = 24
        TabStop = False
        Color = clBtnFace
        DataField = 'PermStatus'
        DataSource = BigBuildingDataSource
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        ReadOnly = True
        TabOrder = 9
      end
      object CCDateDBEdit: TDBEdit
        Left = 531
        Top = 103
        Width = 75
        Height = 24
        TabStop = False
        Color = clBtnFace
        DataField = 'CertComplianceDate'
        DataSource = BigBuildingDataSource
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        ReadOnly = True
        TabOrder = 10
      end
      object CODateDBEdit: TDBEdit
        Left = 378
        Top = 103
        Width = 75
        Height = 24
        TabStop = False
        Color = clBtnFace
        DataField = 'CertOccupancyDate'
        DataSource = BigBuildingDataSource
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        ReadOnly = True
        TabOrder = 11
      end
      object ApplicationDateEdit: TDBEdit
        Left = 226
        Top = 27
        Width = 75
        Height = 24
        TabStop = False
        Color = clBtnFace
        DataField = 'ApplicaDate1'
        DataSource = BigBuildingDataSource
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        ReadOnly = True
        TabOrder = 12
      end
      object DescriptionMemo: TwwDBRichEdit
        Left = 80
        Top = 139
        Width = 443
        Height = 56
        TabStop = False
        AutoURLDetect = False
        Color = clBtnFace
        DataField = 'Description'
        DataSource = BigBuildingDataSource
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        PrintJobName = 'Delphi 5'
        ReadOnly = True
        TabOrder = 13
        EditorCaption = 'Edit Rich Text'
        EditorPosition.Left = 0
        EditorPosition.Top = 0
        EditorPosition.Width = 0
        EditorPosition.Height = 0
        MeasurementUnits = muInches
        PrintMargins.Top = 1
        PrintMargins.Bottom = 1
        PrintMargins.Left = 1
        PrintMargins.Right = 1
        RichEditVersion = 2
        Data = {
          A50000007B5C727466315C616E73695C616E7369637067313235325C64656666
          305C6465666C616E67313033337B5C666F6E7474626C7B5C66305C666E696C20
          417269616C3B7D7D0D0A7B5C636F6C6F7274626C203B5C726564305C67726565
          6E305C626C75653132383B7D0D0A5C766965776B696E64345C7563315C706172
          645C6366315C625C66305C66733230204465736372697074696F6E4D656D6F5C
          7061720D0A7D0D0A00}
      end
    end
    object AssessorsInformationGroupBox: TGroupBox
      Left = 1
      Top = 208
      Width = 602
      Height = 175
      Align = alClient
      Caption = ' Assessor'#39's Information: '
      Color = clBtnFace
      ParentColor = False
      TabOrder = 1
      object Label17: TLabel
        Left = 9
        Top = 25
        Width = 62
        Height = 15
        Caption = 'Visit Dates:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object Label21: TLabel
        Left = 297
        Top = 25
        Width = 83
        Height = 15
        Caption = 'Next Insp. Date'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object Label18: TLabel
        Left = 9
        Top = 54
        Width = 36
        Height = 15
        Caption = 'Notes:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object EditVisitDate2: TDBEdit
        Left = 169
        Top = 20
        Width = 75
        Height = 24
        DataField = 'AssessorTempDate2'
        DataSource = BigBuildingDataSource
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 1
      end
      object EditNextInspectionDate: TDBEdit
        Left = 399
        Top = 20
        Width = 75
        Height = 24
        DataField = 'AssessorNextInspDate'
        DataSource = BigBuildingDataSource
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 2
      end
      object EditVisitDate1: TDBEdit
        Left = 82
        Top = 20
        Width = 75
        Height = 24
        DataField = 'AssessorTempDate1'
        DataSource = BigBuildingDataSource
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
      end
      object ClosedAssessmentCheckBox: TDBCheckBox
        Left = 521
        Top = 24
        Width = 78
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Closed'
        DataField = 'AssessorOfficeClosed'
        DataSource = BigBuildingDataSource
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 3
        ValueChecked = 'True'
        ValueUnchecked = 'False'
      end
      object AssessorsNoteMemo: TwwDBRichEditMSWord
        Left = 59
        Top = 54
        Width = 540
        Height = 113
        AutoURLDetect = False
        DataField = 'AssessorComments'
        DataSource = BigBuildingDataSource
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        PrintJobName = 'Delphi 5'
        TabOrder = 4
        OnExit = AssessorsNoteMemoExit
        EditorCaption = 'Edit Rich Text'
        EditorPosition.Left = 0
        EditorPosition.Top = 0
        EditorPosition.Width = 0
        EditorPosition.Height = 0
        MeasurementUnits = muInches
        PrintMargins.Top = 1
        PrintMargins.Bottom = 1
        PrintMargins.Left = 1
        PrintMargins.Right = 1
        RichEditVersion = 2
        Data = {
          A70000007B5C727466315C616E73695C616E7369637067313235325C64656666
          305C6465666C616E67313033337B5C666F6E7474626C7B5C66305C666E696C20
          417269616C3B7D7D0D0A7B5C636F6C6F7274626C203B5C726564305C67726565
          6E305C626C75653235353B7D0D0A5C766965776B696E64345C7563315C706172
          645C6366315C625C66305C66733138204173736573736F72734E6F74654D656D
          6F5C7061720D0A7D0D0A00}
      end
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 384
    Width = 604
    Height = 40
    Align = alBottom
    TabOrder = 1
    object SaveButton: TBitBtn
      Left = 520
      Top = 5
      Width = 89
      Height = 33
      Caption = '&Save'
      TabOrder = 0
      OnClick = SaveButtonClick
      Glyph.Data = {
        BE060000424DBE06000000000000360400002800000024000000120000000100
        0800000000008802000000000000000000000001000000000000000000000000
        BF0000BF000000BFBF00BF000000BF00BF00BFBF0000C0C0C000C0DCC000F0CA
        A600000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        000000000000000000000000000000000000F0FBFF00A4A0A000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00030303030303
        0303030303030303030303030303030303030303030303030303030303030303
        03030303030303030303030303030303030303030303FF030303030303030303
        03030303030303040403030303030303030303030303030303F8F8FF03030303
        03030303030303030303040202040303030303030303030303030303F80303F8
        FF030303030303030303030303040202020204030303030303030303030303F8
        03030303F8FF0303030303030303030304020202020202040303030303030303
        0303F8030303030303F8FF030303030303030304020202FA0202020204030303
        0303030303F8FF0303F8FF030303F8FF03030303030303020202FA03FA020202
        040303030303030303F8FF03F803F8FF0303F8FF03030303030303FA02FA0303
        03FA0202020403030303030303F8FFF8030303F8FF0303F8FF03030303030303
        FA0303030303FA0202020403030303030303F80303030303F8FF0303F8FF0303
        0303030303030303030303FA0202020403030303030303030303030303F8FF03
        03F8FF03030303030303030303030303FA020202040303030303030303030303
        0303F8FF0303F8FF03030303030303030303030303FA02020204030303030303
        03030303030303F8FF0303F8FF03030303030303030303030303FA0202020403
        030303030303030303030303F8FF0303F8FF03030303030303030303030303FA
        0202040303030303030303030303030303F8FF03F8FF03030303030303030303
        03030303FA0202030303030303030303030303030303F8FFF803030303030303
        030303030303030303FA0303030303030303030303030303030303F803030303
        0303030303030303030303030303030303030303030303030303030303030303
        0303}
      NumGlyphs = 2
    end
  end
  object BigBuildingPermitTable: TTable
    DatabaseName = 'CodeEnforcement'
    IndexName = 'BYPTAPPLICANO'
    TableName = 'PermitRecord'
    TableType = ttDBase
    Left = 240
    Top = 160
  end
  object BigBuildingDataSource: TwwDataSource
    DataSet = BigBuildingPermitTable
    Left = 354
    Top = 150
  end
end
