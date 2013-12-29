object GrievanceDenialReasonDialog: TGrievanceDenialReasonDialog
  Left = 281
  Top = 202
  Width = 586
  Height = 372
  ActiveControl = GrievanceCodeIncrementalSearch
  Caption = 'Choose the reason for the denial.'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 16
  object Label1: TLabel
    Left = 10
    Top = 10
    Width = 539
    Height = 52
    AutoSize = False
    Caption = 
      'Please choose the reason for the grievance denial.  If the reaso' +
      'n is not listed below, choose "OTHER".  Regardless of what denia' +
      'l reason you choose, you will be able to edit it later.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    WordWrap = True
  end
  object Label2: TLabel
    Left = 10
    Top = 76
    Width = 197
    Height = 16
    Caption = 'Enter the denial code here ==>'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label3: TLabel
    Left = 10
    Top = 98
    Width = 195
    Height = 16
    Caption = 'or choose from the grid below:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clGreen
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object OKButton: TBitBtn
    Left = 194
    Top = 303
    Width = 86
    Height = 33
    Caption = 'OK'
    ModalResult = 1
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
    Left = 299
    Top = 303
    Width = 86
    Height = 33
    TabOrder = 1
    Kind = bkCancel
  end
  object GrievanceDenialReasonGrid: TwwDBGrid
    Left = 10
    Top = 122
    Width = 556
    Height = 166
    ControlType.Strings = (
      'Reason;RichEdit;ReasonRichEdit')
    Selected.Strings = (
      'MainCode'#9'10'#9'Code'#9'F'
      'Reason'#9'63'#9'Reason'#9'F')
    MemoAttributes = [mSizeable, mWordWrap, mGridShow, mViewOnly, mDisableDialog]
    IniAttributes.Delimiter = ';;'
    TitleColor = clBtnFace
    FixedCols = 0
    ShowHorzScrollBar = True
    DataSource = GrievanceDenialDataSource
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgWordWrap]
    ParentFont = False
    ReadOnly = True
    TabOrder = 2
    TitleAlignment = taCenter
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clBlue
    TitleFont.Height = -13
    TitleFont.Name = 'Arial'
    TitleFont.Style = [fsBold]
    TitleLines = 1
    TitleButtons = False
    OnDblClick = OKButtonClick
    IndicatorColor = icBlack
  end
  object GrievanceCodeIncrementalSearch: TwwIncrementalSearch
    Left = 212
    Top = 72
    Width = 121
    Height = 24
    DataSource = GrievanceDenialDataSource
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 3
  end
  object ReasonRichEdit: TwwDBRichEditMSWord
    Left = 57
    Top = 183
    Width = 185
    Height = 89
    AutoURLDetect = False
    DataField = 'Reason'
    DataSource = GrievanceDenialDataSource
    PrintJobName = 'Delphi 5'
    TabOrder = 4
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
      7A0000007B5C727466315C616E73695C616E7369637067313235325C64656666
      305C6465666C616E67313033337B5C666F6E7474626C7B5C66305C666E696C20
      417269616C3B7D7D0D0A5C766965776B696E64345C7563315C706172645C6630
      5C6673323020526561736F6E52696368456469745C7061720D0A7D0D0A00}
  end
  object GrievanceDenialReasonCodeTable: TTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYMAINCODE'
    ReadOnly = True
    TableName = 'ZGDenialReasonCodes'
    TableType = ttDBase
    Left = 164
    Top = 177
  end
  object GrievanceDenialDataSource: TDataSource
    DataSet = GrievanceDenialReasonCodeTable
    Left = 451
    Top = 222
  end
end
