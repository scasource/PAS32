object GrievanceAddDialog: TGrievanceAddDialog
  Left = 213
  Top = 163
  Width = 354
  Height = 439
  ActiveControl = EditGrievanceNumber
  Caption = 'Enter the new grievance.'
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
    Top = 365
    Width = 86
    Height = 33
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
    Left = 184
    Top = 365
    Width = 86
    Height = 33
    TabOrder = 1
    Kind = bkCancel
  end
  object RepresentativeGroupBox: TGroupBox
    Left = 15
    Top = 240
    Width = 317
    Height = 118
    TabOrder = 2
    object Label2: TLabel
      Left = 13
      Top = 86
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
      Height = 52
      AutoSize = False
      Caption = 
        'Please choose the code of the person(s) representing the parcel ' +
        'owner or leave blank if they are representing themselves.'
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
      Top = 82
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
      AutoDropDown = False
      ShowButton = True
      AllowClearKey = False
      OnNotInList = LawyerCodeLookupComboNotInList
    end
    object NewLawyerButton: TBitBtn
      Left = 283
      Top = 79
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
  object GrievanceNumberGroupBox: TGroupBox
    Left = 15
    Top = 116
    Width = 317
    Height = 125
    TabOrder = 3
    object Label3: TLabel
      Left = 13
      Top = 96
      Width = 123
      Height = 16
      Caption = 'Grievance Number:'
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
      Height = 67
      AutoSize = False
      Caption = 
        'The following is the grievance number that will be assigned to t' +
        'his grievance.  You may change it to a different number if one g' +
        'rievance was filed for several parcels.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      WordWrap = True
    end
    object EditGrievanceNumber: TEdit
      Left = 146
      Top = 93
      Width = 64
      Height = 24
      TabOrder = 0
    end
  end
  object GrievanceYearGroupBox: TGroupBox
    Left = 15
    Top = 2
    Width = 317
    Height = 116
    TabOrder = 4
    object Label5: TLabel
      Left = 13
      Top = 86
      Width = 102
      Height = 16
      Caption = 'Grievance Year:'
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
        'Please enter the assessment year that this grievance applies to.' +
        '  Only change this year if you are entering grievance informatio' +
        'n for prior years.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      WordWrap = True
    end
    object EditGrievanceYear: TEdit
      Left = 146
      Top = 83
      Width = 64
      Height = 24
      TabOrder = 0
    end
  end
  object LawyerCodeTable: TTable
    DatabaseName = 'PASsystem'
    IndexFieldNames = 'Code'
    TableName = 'ZGLawyerCodes'
    TableType = ttDBase
    Left = 282
    Top = 249
  end
  object GrievanceTable: TTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYTAXROLLYR_GREVNUM'
    TableName = 'grievancetable'
    TableType = ttDBase
    Left = 282
    Top = 166
  end
end
