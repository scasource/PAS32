object TransferPASForm: TTransferPASForm
  Left = 243
  Top = 125
  Width = 438
  Height = 396
  Caption = 'Transfer PAS'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 15
    Top = 12
    Width = 392
    Height = 46
    AutoSize = False
    Caption = 
      'This program will allow you to transfer all the items selected b' +
      'elow to another computer.  Please choose the items below that yo' +
      'u wish to transfer and click OK.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -12
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    WordWrap = True
  end
  object Label2: TLabel
    Left = 15
    Top = 61
    Width = 392
    Height = 20
    AutoSize = False
    Caption = 
      'Please make sure that all users are out of PAS before proceeding' +
      '.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clPurple
    Font.Height = -12
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    WordWrap = True
  end
  object StartButton: TBitBtn
    Left = 170
    Top = 331
    Width = 81
    Height = 31
    Caption = 'Start'
    Default = True
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
  object Notebook: TNotebook
    Left = 10
    Top = 94
    Width = 410
    Height = 227
    TabOrder = 1
    object TPage
      Left = 0
      Top = 0
      Caption = 'Main Page'
      object GroupBox1: TGroupBox
        Left = 58
        Top = 9
        Width = 294
        Height = 117
        Caption = ' Items to Transfer: '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        object DataCheckBox: TCheckBox
          Left = 22
          Top = 29
          Width = 97
          Height = 17
          Alignment = taLeftJustify
          Caption = 'Data'
          Checked = True
          State = cbChecked
          TabOrder = 0
        end
        object PicturesCheckBox: TCheckBox
          Left = 157
          Top = 29
          Width = 97
          Height = 17
          Alignment = taLeftJustify
          Caption = 'Pictures'
          TabOrder = 1
        end
        object DocumentsCheckBox: TCheckBox
          Left = 157
          Top = 55
          Width = 97
          Height = 17
          Alignment = taLeftJustify
          Caption = 'Documents'
          TabOrder = 2
        end
        object ProgramsCheckBox: TCheckBox
          Left = 22
          Top = 55
          Width = 97
          Height = 17
          Alignment = taLeftJustify
          Caption = 'Programs'
          Checked = True
          State = cbChecked
          TabOrder = 3
        end
        object GrievancesCheckBox: TCheckBox
          Left = 157
          Top = 81
          Width = 97
          Height = 17
          Alignment = taLeftJustify
          Caption = 'Grievances'
          TabOrder = 4
          Visible = False
        end
        object MapsCheckBox: TCheckBox
          Left = 22
          Top = 81
          Width = 97
          Height = 17
          Alignment = taLeftJustify
          Caption = 'Maps'
          TabOrder = 5
          Visible = False
        end
      end
      object OptionsGroupBox: TGroupBox
        Left = 58
        Top = 131
        Width = 294
        Height = 91
        Caption = ' Options: '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 1
        object Label3: TLabel
          Left = 13
          Top = 61
          Width = 103
          Height = 13
          Caption = 'Destination Drive:'
        end
        object SearcherCanViewNYCheckBox: TCheckBox
          Left = 11
          Top = 29
          Width = 149
          Height = 17
          Alignment = taLeftJustify
          Caption = 'Searcher Can View NY'
          Checked = True
          State = cbChecked
          TabOrder = 0
        end
        object EditDestinationDrive: TEdit
          Left = 130
          Top = 57
          Width = 30
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -12
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 1
          Text = 'C'
        end
      end
    end
    object TPage
      Left = 0
      Top = 0
      Caption = 'Progress'
      object ProgressGroupBox: TGroupBox
        Left = 13
        Top = 22
        Width = 384
        Height = 136
        Caption = ' Progress: '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        object Label4: TLabel
          Left = 19
          Top = 74
          Width = 70
          Height = 13
          Caption = 'Current File:'
        end
        object Label5: TLabel
          Left = 19
          Top = 105
          Width = 45
          Height = 13
          Caption = 'Overall:'
        end
        object CurrentlyProcessingFileLabel: TLabel
          Left = 22
          Top = 42
          Width = 164
          Height = 13
          Caption = 'CurrentlyProcessingFileLabel'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBackground
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object CurrentFileProgressMeter: TAbMeter
          Left = 94
          Top = 72
          Width = 186
          Height = 16
          Orientation = moHorizontal
          UnusedColor = clBtnFace
          UsedColor = clNavy
        end
        object OverallProgressMeter: TAbMeter
          Left = 94
          Top = 103
          Width = 186
          Height = 16
          Orientation = moHorizontal
          UnusedColor = clBtnFace
          UsedColor = clNavy
        end
        object CurrentSectionLabel: TLabel
          Left = 22
          Top = 20
          Width = 116
          Height = 13
          Caption = 'CurrentSectionLabel'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clGreen
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
        end
      end
    end
  end
  object CancelButton: TBitBtn
    Left = 262
    Top = 331
    Width = 81
    Height = 31
    Caption = 'Cancel'
    Enabled = False
    TabOrder = 2
    OnClick = CancelButtonClick
    Glyph.Data = {
      DE010000424DDE01000000000000760000002800000024000000120000000100
      0400000000006801000000000000000000001000000000000000000000000000
      80000080000000808000800000008000800080800000C0C0C000808080000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
      333333333333333333333333000033338833333333333333333F333333333333
      0000333911833333983333333388F333333F3333000033391118333911833333
      38F38F333F88F33300003339111183911118333338F338F3F8338F3300003333
      911118111118333338F3338F833338F3000033333911111111833333338F3338
      3333F8330000333333911111183333333338F333333F83330000333333311111
      8333333333338F3333383333000033333339111183333333333338F333833333
      00003333339111118333333333333833338F3333000033333911181118333333
      33338333338F333300003333911183911183333333383338F338F33300003333
      9118333911183333338F33838F338F33000033333913333391113333338FF833
      38F338F300003333333333333919333333388333338FFF830000333333333333
      3333333333333333333888330000333333333333333333333333333333333333
      0000}
    NumGlyphs = 2
  end
  object SystemTable: TTable
    DatabaseName = 'PropertyAssessmentSystem'
    TableName = 'SystemRecord'
    TableType = ttDBase
    Left = 372
    Top = 92
  end
  object ParcelTable: TTable
    DatabaseName = 'PropertyAssessmentSystem'
    Exclusive = True
    TableName = 'Tparcelrec'
    TableType = ttDBase
    Left = 350
    Top = 163
  end
  object AbZipper: TAbZipper
    ArchiveProgressMeter = OverallProgressMeter
    ItemProgressMeter = CurrentFileProgressMeter
    AutoSave = False
    DOSMode = False
    OnArchiveItemProgress = AbZipperArchiveItemProgress
    StoreOptions = [soStripDrive, soStripPath, soRemoveDots]
    Left = 14
    Top = 91
  end
end
