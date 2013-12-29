object fm_NassauCountyDiskLoad: Tfm_NassauCountyDiskLoad
  Left = 423
  Top = 113
  Width = 640
  Height = 440
  HorzScrollBar.Visible = False
  VertScrollBar.Visible = False
  BorderIcons = []
  Caption = 'Load Nassau County Data'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = False
  Position = poScreenCenter
  Visible = True
  OnActivate = FormActivate
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 43
    Top = 50
    Width = 105
    Height = 13
    Caption = 'Parcels not found:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object NotFoundListBox: TListBox
    Left = 43
    Top = 69
    Width = 205
    Height = 264
    IntegralHeight = True
    ItemHeight = 13
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 632
    Height = 41
    Align = alTop
    TabOrder = 1
    object TitleLabel: TLabel
      Left = 206
      Top = 9
      Width = 219
      Height = 22
      Caption = 'Load Nassau County Data'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -19
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 357
    Width = 632
    Height = 49
    Align = alBottom
    TabOrder = 2
    object StartButton: TBitBtn
      Left = 425
      Top = 6
      Width = 86
      Height = 38
      Caption = 'Start'
      ModalResult = 1
      TabOrder = 0
      OnClick = StartButtonClick
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
    object CloseButton: TBitBtn
      Left = 522
      Top = 9
      Width = 89
      Height = 33
      TabOrder = 1
      OnClick = CloseButtonClick
      Kind = bkClose
    end
  end
  object TrialRunCheckBox: TCheckBox
    Left = 284
    Top = 216
    Width = 75
    Height = 17
    Alignment = taLeftJustify
    Caption = 'Trial Run'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 3
  end
  object GroupBox1: TGroupBox
    Left = 284
    Top = 69
    Width = 241
    Height = 139
    Caption = ' Progress: '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBackground
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 4
    object RecordCountLabel: TLabel
      Left = 26
      Top = 27
      Width = 106
      Height = 13
      Caption = 'RecordCountLabel'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBackground
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object NotFoundCountLabel: TLabel
      Left = 26
      Top = 55
      Width = 120
      Height = 13
      Caption = 'NotFoundCountLabel'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBackground
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object TotalLandLabel: TLabel
      Left = 26
      Top = 83
      Width = 89
      Height = 13
      Caption = 'TotalLandLabel'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBackground
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object TotalAssessedLabel: TLabel
      Left = 26
      Top = 111
      Width = 114
      Height = 13
      Caption = 'TotalAssessedLabel'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBackground
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
  end
  object ParcelTable: TTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYTAXROLLYR_SBLKEY'
    TableName = 'tparcelrec'
    TableType = ttDBase
    Left = 143
    Top = 157
  end
  object OpenDialog: TOpenDialog
    InitialDir = '\pas32\imports'
    Left = 238
    Top = 185
  end
  object AssessmentTable: TTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYTAXROLLYR_SWISSBLKEY'
    TableName = 'TPAssessRec'
    TableType = ttDBase
    Left = 68
    Top = 89
  end
end
