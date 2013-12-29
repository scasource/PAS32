object GrievanceLawyerCodeDialog: TGrievanceLawyerCodeDialog
  Left = 4
  Top = 130
  Width = 297
  Height = 242
  ActiveControl = LawyerCodeLookupCombo
  Caption = 'Choose a lawyer code.'
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
    Left = 1
    Top = 11
    Width = 280
    Height = 52
    AutoSize = False
    Caption = 
      'Please choose the code of the lawyer representing the parcel own' +
      'er or leave blank if they are representing themselves.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    WordWrap = True
  end
  object Label2: TLabel
    Left = 4
    Top = 85
    Width = 51
    Height = 16
    Caption = 'Lawyer:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object OKButton: TBitBtn
    Left = 59
    Top = 146
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
    Left = 164
    Top = 146
    Width = 86
    Height = 33
    TabOrder = 1
    Kind = bkCancel
  end
  object LawyerCodeLookupCombo: TwwDBLookupCombo
    Left = 75
    Top = 81
    Width = 175
    Height = 24
    DropDownAlignment = taLeftJustify
    Selected.Strings = (
      'Code'#9'10'#9'Code'#9'F'
      'Name1'#9'15'#9'Name'#9'F')
    LookupTable = LawyerCodeTable
    LookupField = 'Code'
    Options = [loColLines, loRowLines, loTitles]
    Style = csDropDownList
    TabOrder = 2
    AutoDropDown = False
    ShowButton = True
    AllowClearKey = False
    OnNotInList = LawyerCodeLookupComboNotInList
  end
  object LawyerCodeTable: TTable
    DatabaseName = 'PASsystem'
    IndexFieldNames = 'Code'
    TableName = 'ZGLawyerCodes'
    TableType = ttDBase
    Left = 19
    Top = 116
  end
end
