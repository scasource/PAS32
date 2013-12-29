object GrievanceSubform: TGrievanceSubform
  Left = 553
  Top = 46
  BorderStyle = bsDialog
  ClientHeight = 454
  ClientWidth = 632
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Arial'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 16
  object PageControl: TPageControl
    Left = 0
    Top = 0
    Width = 632
    Height = 415
    ActivePage = ResultsTabSheet
    Align = alClient
    TabOrder = 0
    OnChange = PageControlChange
    object ParcelTabSheet: TTabSheet
      Caption = 'Parcel Information'
      object Label22: TLabel
        Left = 334
        Top = 6
        Width = 39
        Height = 16
        Caption = 'Notes:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label53: TLabel
        Left = 336
        Top = 167
        Width = 88
        Height = 16
        Caption = 'Appearance #'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label42: TLabel
        Left = 472
        Top = 158
        Width = 131
        Height = 34
        Hint = 
          'Click here to prevent the parcel from being updated once the res' +
          'ults are recorded.  Use this if the grievance spans several parc' +
          'els and the new value recorded applies to all parcels.'
        AutoSize = False
        Caption = 'Prevent Results from Updating Parcel'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        WordWrap = True
      end
      object FrozenLabel: TLabel
        Left = 562
        Top = 2
        Width = 51
        Height = 16
        Hint = 
          'The assessment on this parcel has been frozen due to a grievance' +
          ', small claims or certiorari decision.'
        Caption = 'FROZEN'
        Color = clRed
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clYellow
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
        Visible = False
      end
      object OwnerGroupBox: TGroupBox
        Left = 9
        Top = -1
        Width = 317
        Height = 191
        Caption = ' Owner: '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        object Label12: TLabel
          Left = 20
          Top = 18
          Width = 48
          Height = 16
          Caption = 'Name 1'
          FocusControl = EditName
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label13: TLabel
          Left = 20
          Top = 43
          Width = 48
          Height = 16
          Caption = 'Name 2'
          FocusControl = EditName2
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label14: TLabel
          Left = 20
          Top = 68
          Width = 41
          Height = 16
          Caption = 'Addr 1'
          FocusControl = EditAddress
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label15: TLabel
          Left = 20
          Top = 93
          Width = 41
          Height = 16
          Caption = 'Addr 2'
          FocusControl = EditAddress2
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label16: TLabel
          Left = 20
          Top = 117
          Width = 38
          Height = 16
          Caption = 'Street'
          FocusControl = EditStreet
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object SwisLabel: TLabel
          Left = 20
          Top = 142
          Width = 24
          Height = 16
          Caption = 'City'
          FocusControl = EditCity
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label17: TLabel
          Left = 20
          Top = 167
          Width = 33
          Height = 16
          Caption = 'State'
          FocusControl = EditState
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label18: TLabel
          Left = 123
          Top = 167
          Width = 19
          Height = 16
          Caption = 'Zip'
          FocusControl = EditZip
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label28: TLabel
          Left = 203
          Top = 167
          Width = 4
          Height = 16
          Caption = '-'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object EditName: TDBEdit
          Left = 73
          Top = 15
          Width = 213
          Height = 23
          CharCase = ecUpperCase
          DataField = 'CurrentName1'
          DataSource = GrievanceDataSource
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clRed
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
        end
        object EditName2: TDBEdit
          Left = 73
          Top = 40
          Width = 213
          Height = 23
          DataField = 'CurrentName2'
          DataSource = GrievanceDataSource
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 1
        end
        object EditAddress: TDBEdit
          Left = 73
          Top = 65
          Width = 213
          Height = 23
          DataField = 'CurrentAddress1'
          DataSource = GrievanceDataSource
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 2
        end
        object EditAddress2: TDBEdit
          Left = 73
          Top = 90
          Width = 213
          Height = 23
          DataField = 'CurrentAddress2'
          DataSource = GrievanceDataSource
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 3
        end
        object EditStreet: TDBEdit
          Left = 73
          Top = 114
          Width = 213
          Height = 23
          DataField = 'CurrentStreet'
          DataSource = GrievanceDataSource
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 4
        end
        object EditCity: TDBEdit
          Left = 73
          Top = 139
          Width = 213
          Height = 23
          DataField = 'CurrentCity'
          DataSource = GrievanceDataSource
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 5
        end
        object EditState: TDBEdit
          Left = 73
          Top = 164
          Width = 33
          Height = 23
          CharCase = ecUpperCase
          DataField = 'CurrentState'
          DataSource = GrievanceDataSource
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 6
        end
        object EditZip: TDBEdit
          Left = 148
          Top = 164
          Width = 50
          Height = 23
          DataField = 'CurrentZip'
          DataSource = GrievanceDataSource
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 7
        end
        object EditZipPlus4: TDBEdit
          Left = 214
          Top = 164
          Width = 40
          Height = 23
          DataField = 'CurrentZipPlus4'
          DataSource = GrievanceDataSource
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 8
        end
      end
      object TimeOfGrievanceInformationGroupBox: TGroupBox
        Left = 9
        Top = 191
        Width = 607
        Height = 184
        Caption = ' Time of Grievance Information: '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 5
        object Label25: TLabel
          Left = 153
          Top = 24
          Width = 81
          Height = 16
          Caption = 'Legal Addr #'
          FocusControl = EditLegalAddrNo
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label26: TLabel
          Left = 332
          Top = 23
          Width = 78
          Height = 16
          Caption = 'Legal Street'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label19: TLabel
          Left = 27
          Top = 24
          Width = 77
          Height = 16
          Caption = 'Roll Section'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label20: TLabel
          Left = 153
          Top = 78
          Width = 91
          Height = 16
          Caption = 'Property Class'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label21: TLabel
          Left = 153
          Top = 51
          Width = 85
          Height = 16
          Caption = 'Residential %'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label23: TLabel
          Left = 27
          Top = 78
          Width = 68
          Height = 16
          Caption = 'Ownership'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label24: TLabel
          Left = 27
          Top = 51
          Width = 64
          Height = 16
          Caption = 'Hstd Code'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label27: TLabel
          Left = 332
          Top = 51
          Width = 74
          Height = 16
          Caption = 'Full Mkt Val'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object PriorValueLabel: TLabel
          Left = 19
          Top = 126
          Width = 67
          Height = 15
          Caption = 'Prior (2000)'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clMaroon
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object CurrentValueLabel: TLabel
          Left = 19
          Top = 154
          Width = 82
          Height = 15
          Caption = 'Current (2000)'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clMaroon
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label31: TLabel
          Left = 144
          Top = 104
          Width = 28
          Height = 15
          Caption = 'Land'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clMaroon
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label30: TLabel
          Left = 242
          Top = 104
          Width = 27
          Height = 15
          Caption = 'Total'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clMaroon
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object PropertyClassCodeText: TDBText
          Left = 301
          Top = 78
          Width = 293
          Height = 17
          DataField = 'Description'
          DataSource = PropertyClassDataSource
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clGreen
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object EditLegalAddrNo: TDBEdit
          Left = 250
          Top = 21
          Width = 73
          Height = 23
          CharCase = ecUpperCase
          Color = clBtnFace
          DataField = 'LegalAddrNo'
          DataSource = GrievanceDataSource
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clPurple
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          ReadOnly = True
          TabOrder = 0
        end
        object EditLegalAddr: TDBEdit
          Left = 419
          Top = 20
          Width = 153
          Height = 23
          CharCase = ecUpperCase
          Color = clBtnFace
          DataField = 'LegalAddr'
          DataSource = GrievanceDataSource
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clPurple
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          ReadOnly = True
          TabOrder = 1
        end
        object EditHomesteadCode: TDBEdit
          Left = 114
          Top = 48
          Width = 24
          Height = 23
          Color = clBtnFace
          DataField = 'HomesteadCode'
          DataSource = GrievanceDataSource
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          ReadOnly = True
          TabOrder = 2
        end
        object EditCurrentTotalValue: TDBEdit
          Left = 212
          Top = 150
          Width = 89
          Height = 23
          DataField = 'CurrentTotalValue'
          DataSource = GrievanceDataSource
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 3
        end
        object EditPriorTotalValue: TDBEdit
          Left = 212
          Top = 122
          Width = 89
          Height = 23
          Color = clBtnFace
          DataField = 'PriorTotalValue'
          DataSource = GrievanceDataSource
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          ReadOnly = True
          TabOrder = 4
        end
        object EditCurrentLandValue: TDBEdit
          Left = 114
          Top = 150
          Width = 89
          Height = 23
          DataField = 'CurrentLandValue'
          DataSource = GrievanceDataSource
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 5
        end
        object EditPriorLandValue: TDBEdit
          Left = 114
          Top = 122
          Width = 89
          Height = 23
          Color = clBtnFace
          DataField = 'PriorLandValue'
          DataSource = GrievanceDataSource
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          ReadOnly = True
          TabOrder = 6
        end
        object EditFullMarketValue: TDBEdit
          Left = 419
          Top = 48
          Width = 89
          Height = 23
          DataField = 'CurrentFullMarketVal'
          DataSource = GrievanceDataSource
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 7
        end
        object EditPropertyClassCode: TDBEdit
          Left = 250
          Top = 75
          Width = 42
          Height = 23
          Color = clBtnFace
          DataField = 'PropertyClassCode'
          DataSource = GrievanceDataSource
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          ReadOnly = True
          TabOrder = 8
        end
        object EditOwnership: TDBEdit
          Left = 114
          Top = 75
          Width = 24
          Height = 23
          Color = clBtnFace
          DataField = 'OwnershipCode'
          DataSource = GrievanceDataSource
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          ReadOnly = True
          TabOrder = 9
        end
        object EditResidentialPercent: TDBEdit
          Left = 250
          Top = 48
          Width = 44
          Height = 23
          Color = clBtnFace
          DataField = 'ResidentialPercent'
          DataSource = GrievanceDataSource
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          ReadOnly = True
          TabOrder = 10
        end
        object EditRollSection: TDBEdit
          Left = 114
          Top = 21
          Width = 24
          Height = 23
          Color = clBtnFace
          DataField = 'RollSection'
          DataSource = GrievanceDataSource
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          ReadOnly = True
          TabOrder = 11
        end
        object GrievanceExemptionGrid: TwwDBGrid
          Left = 328
          Top = 108
          Width = 258
          Height = 69
          Selected.Strings = (
            'ExemptionCode'#9'7'#9'EX Code'
            'Amount'#9'15'#9'Amount'
            'Percent'#9'7'#9'Percent')
          IniAttributes.Delimiter = ';;'
          TitleColor = clBtnFace
          FixedCols = 0
          ShowHorzScrollBar = True
          DataSource = GrievanceExemptionDataSource
          ReadOnly = True
          TabOrder = 12
          TitleAlignment = taCenter
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clBlue
          TitleFont.Height = -13
          TitleFont.Name = 'Arial'
          TitleFont.Style = [fsBold]
          TitleLines = 1
          TitleButtons = False
          IndicatorColor = icBlack
        end
      end
      object GrievanceNotesRichEdit: TwwDBRichEditMSWord
        Left = 335
        Top = 25
        Width = 280
        Height = 108
        Hint = 'Double click to edit the note.'
        AutoURLDetect = False
        DataField = 'Notes'
        DataSource = GrievanceDataSource
        PrintJobName = 'Delphi 5'
        TabOrder = 1
        OnDblClick = GrievanceNotesRichEditDblClick
        EditorOptions = [reoShowLoad, reoShowSaveExit, reoShowPrint, reoShowPageSetup, reoShowFormatBar, reoShowToolBar, reoShowStatusBar, reoShowHints, reoShowRuler, reoShowInsertObject, reoCloseOnEscape, reoFlatButtons, reoShowSpellCheck, reoShowMainMenuIcons]
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
          820000007B5C727466315C616E73695C616E7369637067313235325C64656666
          305C6465666C616E67313033337B5C666F6E7474626C7B5C66305C666E696C20
          417269616C3B7D7D0D0A5C766965776B696E64345C7563315C706172645C6630
          5C66733230204772696576616E63654E6F74657352696368456469745C706172
          0D0A7D0D0A00}
      end
      object AppearanceNumberEdit: TDBEdit
        Left = 432
        Top = 163
        Width = 33
        Height = 24
        DataField = 'AppearanceNumber'
        DataSource = GrievanceDataSource
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 3
      end
      object PreventUpdateCheckBox: TDBCheckBox
        Left = 608
        Top = 167
        Width = 16
        Height = 17
        Hint = 
          'Click here to prevent the parcel from being updated once the res' +
          'ults are recorded.  Use this if the grievance spans several parc' +
          'els and the new value recorded applies to all parcels.'
        Alignment = taLeftJustify
        DataField = 'PreventUpdate'
        DataSource = GrievanceDataSource
        TabOrder = 4
        ValueChecked = 'True'
        ValueUnchecked = 'False'
      end
      object NoHearingCheckBox: TDBCheckBox
        Left = 336
        Top = 141
        Width = 109
        Height = 17
        Hint = 
          'Click this check box if the petitioner did not receive a hearing' +
          '.'
        Alignment = taLeftJustify
        Caption = 'No Hearing'
        DataField = 'NoHearing'
        DataSource = GrievanceDataSource
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 2
        ValueChecked = 'True'
        ValueUnchecked = 'False'
      end
    end
    object PetitionerTabSheet: TTabSheet
      Caption = 'Petitioner'
      ImageIndex = 1
      object PetitionerAskingGroupBox: TGroupBox
        Left = 0
        Top = 207
        Width = 624
        Height = 177
        Align = alClient
        Caption = ' Complaint Information: '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        object Label34: TLabel
          Left = 7
          Top = 97
          Width = 76
          Height = 33
          AutoSize = False
          Caption = 'Asking Total Value'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          WordWrap = True
        end
        object Label36: TLabel
          Left = 7
          Top = 56
          Width = 77
          Height = 31
          AutoSize = False
          Caption = 'Asking Land Value'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          WordWrap = True
        end
        object Label35: TLabel
          Left = 213
          Top = 97
          Width = 77
          Height = 33
          AutoSize = False
          Caption = 'Full Mkt Val Claimed'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          WordWrap = True
        end
        object Label37: TLabel
          Left = 212
          Top = 47
          Width = 77
          Height = 48
          AutoSize = False
          Caption = 'Assessed Percent Claimed'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          WordWrap = True
        end
        object Label40: TLabel
          Left = 7
          Top = 26
          Width = 57
          Height = 16
          Caption = 'Category'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label41: TLabel
          Left = 212
          Top = 25
          Width = 47
          Height = 16
          Caption = 'Reason'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label54: TLabel
          Left = 574
          Top = 21
          Width = 6
          Height = 22
          Caption = '('
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clGreen
          Font.Height = -19
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label55: TLabel
          Left = 606
          Top = 31
          Width = 6
          Height = 22
          Caption = ')'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clGreen
          Font.Height = -19
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object SubreasonCodeText: TDBText
          Left = 581
          Top = 24
          Width = 23
          Height = 17
          DataField = 'PetitSubreasonCode'
          DataSource = GrievanceDataSource
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clGreen
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label38: TLabel
          Left = 397
          Top = 48
          Width = 149
          Height = 16
          Caption = 'Exemptions Requested:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object EditAskingLandValue: TDBEdit
          Left = 87
          Top = 60
          Width = 97
          Height = 23
          DataField = 'PetitLandValue'
          DataSource = GrievanceDataSource
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 3
        end
        object EditAskingTotalValue: TDBEdit
          Left = 89
          Top = 102
          Width = 97
          Height = 23
          DataField = 'PetitTotalValue'
          DataSource = GrievanceDataSource
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 4
        end
        object EditPetitionerAssessedPercent: TDBEdit
          Left = 292
          Top = 60
          Width = 97
          Height = 23
          DataField = 'PetitAssessedPct'
          DataSource = GrievanceDataSource
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 5
        end
        object EditPetitionerFullMarketValue: TDBEdit
          Left = 292
          Top = 102
          Width = 97
          Height = 23
          DataField = 'PetitFullMarketVal'
          DataSource = GrievanceDataSource
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 6
        end
        object ComplaintReasonLookupCombo: TwwDBLookupCombo
          Left = 87
          Top = 22
          Width = 112
          Height = 24
          DropDownAlignment = taLeftJustify
          Selected.Strings = (
            'MainCode'#9'10'#9'Code'#9'F'
            'Description'#9'30'#9'Description'#9'F')
          DataField = 'PetitReason'
          DataSource = GrievanceDataSource
          LookupTable = GrievanceComplaintReasonTable
          LookupField = 'MainCode'
          Options = [loColLines, loRowLines]
          Style = csDropDownList
          TabOrder = 0
          AutoDropDown = True
          ShowButton = True
          AllowClearKey = False
          OnCloseUp = ComplaintReasonLookupComboCloseUp
        end
        object ComplaintSubreasonRichEdit: TwwDBRichEditMSWord
          Left = 292
          Top = 21
          Width = 256
          Height = 24
          AutoURLDetect = False
          DataField = 'PetitSubreason'
          DataSource = GrievanceDataSource
          PrintJobName = 'Delphi 5'
          TabOrder = 1
          OnDblClick = ComplaintSubreasonButtonClick
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
            AA0000007B5C727466315C616E73695C616E7369637067313235325C64656666
            305C6465666C616E67313033337B5C666F6E7474626C7B5C66305C666E696C20
            417269616C3B7D7D0D0A7B5C636F6C6F7274626C203B5C726564305C67726565
            6E305C626C75653235353B7D0D0A5C766965776B696E64345C7563315C706172
            645C6366315C625C66305C667332302044656E69616C526561736F6E52696368
            456469745C7061720D0A7D0D0A00}
        end
        object ComplaintSubreasonButton: TButton
          Left = 548
          Top = 22
          Width = 23
          Height = 25
          Caption = '...'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
          OnClick = ComplaintSubreasonButtonClick
        end
        object AskingExemptionsGrid: TwwDBGrid
          Left = 397
          Top = 68
          Width = 215
          Height = 72
          Selected.Strings = (
            'ExemptionCode'#9'9'#9'Code'
            'Amount'#9'11'#9'Amount'
            'Percent'#9'4'#9'%')
          IniAttributes.Delimiter = ';;'
          TitleColor = clBtnFace
          FixedCols = 0
          ShowHorzScrollBar = True
          DataSource = GreivanceExemptionsAskedDataSource
          TabOrder = 7
          TitleAlignment = taCenter
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clBlue
          TitleFont.Height = -13
          TitleFont.Name = 'Arial'
          TitleFont.Style = [fsBold]
          TitleLines = 1
          TitleButtons = False
          IndicatorColor = icBlack
        end
        object ExemptionCodeAskedLookupCombo: TwwDBLookupCombo
          Left = 428
          Top = 101
          Width = 121
          Height = 24
          DropDownAlignment = taLeftJustify
          Selected.Strings = (
            'ExCode'#9'5'#9'Code'#9'F'
            'Description'#9'20'#9'Description'#9'F')
          DataField = 'ExemptionCode'
          DataSource = GreivanceExemptionsAskedDataSource
          LookupTable = ExemptionCodeTable
          LookupField = 'ExCode'
          Options = [loColLines, loRowLines, loTitles]
          Style = csDropDownList
          TabOrder = 8
          AutoDropDown = True
          ShowButton = True
          AllowClearKey = False
        end
        object DeleteExemptionAskedButton: TBitBtn
          Left = 521
          Top = 145
          Width = 91
          Height = 25
          Caption = 'Delete EX'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 9
          OnClick = DeleteExemptionAskedButtonClick
          Glyph.Data = {
            76010000424D7601000000000000760000002800000020000000100000000100
            04000000000000010000130B0000130B00001000000000000000000000000000
            800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
            333333333333333333FF33333333333330003333333333333777333333333333
            300033FFFFFF3333377739999993333333333777777F3333333F399999933333
            3300377777733333337733333333333333003333333333333377333333333333
            3333333333333333333F333333333333330033333F33333333773333C3333333
            330033337F3333333377333CC3333333333333F77FFFFFFF3FF33CCCCCCCCCC3
            993337777777777F77F33CCCCCCCCCC399333777777777737733333CC3333333
            333333377F33333333FF3333C333333330003333733333333777333333333333
            3000333333333333377733333333333333333333333333333333}
          NumGlyphs = 2
        end
        object AddExemptionClaimedButton: TBitBtn
          Left = 397
          Top = 145
          Width = 91
          Height = 25
          Caption = 'Add EX'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 10
          OnClick = AddExemptionClaimedButtonClick
          Glyph.Data = {
            76010000424D7601000000000000760000002800000020000000100000000100
            04000000000000010000130B0000130B00001000000000000000000000000000
            800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
            33333333FF33333333FF333993333333300033377F3333333777333993333333
            300033F77FFF3333377739999993333333333777777F3333333F399999933333
            33003777777333333377333993333333330033377F3333333377333993333333
            3333333773333333333F333333333333330033333333F33333773333333C3333
            330033333337FF3333773333333CC333333333FFFFF77FFF3FF33CCCCCCCCCC3
            993337777777777F77F33CCCCCCCCCC3993337777777777377333333333CC333
            333333333337733333FF3333333C333330003333333733333777333333333333
            3000333333333333377733333333333333333333333333333333}
          NumGlyphs = 2
        end
      end
      object Petitioner_Attorney_NameAddress_PageControl: TPageControl
        Left = 0
        Top = 0
        Width = 624
        Height = 207
        ActivePage = PetitionerNameAddressTabSheet
        Align = alTop
        TabOrder = 1
        object PetitionerNameAddressTabSheet: TTabSheet
          Caption = 'Petitioner Name \ Addr'
          object Label1: TLabel
            Left = 31
            Top = 3
            Width = 48
            Height = 16
            Caption = 'Name 1'
            FocusControl = EditPetitionerName1
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -13
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label2: TLabel
            Left = 31
            Top = 29
            Width = 48
            Height = 16
            Caption = 'Name 2'
            FocusControl = EditPetitionerName2
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -13
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label4: TLabel
            Left = 31
            Top = 54
            Width = 41
            Height = 16
            Caption = 'Addr 1'
            FocusControl = EditPetitionerAddress1
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -13
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label5: TLabel
            Left = 31
            Top = 80
            Width = 41
            Height = 16
            Caption = 'Addr 2'
            FocusControl = EditPetitionerAddress2
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -13
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label6: TLabel
            Left = 31
            Top = 105
            Width = 38
            Height = 16
            Caption = 'Street'
            FocusControl = EditPetitionerStreet
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -13
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label7: TLabel
            Left = 31
            Top = 131
            Width = 24
            Height = 16
            Caption = 'City'
            FocusControl = EditPetitionerCity
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -13
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label8: TLabel
            Left = 31
            Top = 156
            Width = 33
            Height = 16
            Caption = 'State'
            FocusControl = EditPetitionerState
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -13
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label9: TLabel
            Left = 132
            Top = 156
            Width = 19
            Height = 16
            Caption = 'Zip'
            FocusControl = EditPetitionerZip
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -13
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label10: TLabel
            Left = 212
            Top = 156
            Width = 4
            Height = 16
            Caption = '-'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -13
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object LawyerLabel: TLabel
            Left = 327
            Top = 28
            Width = 51
            Height = 16
            Caption = 'Lawyer:'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -13
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label11: TLabel
            Left = 327
            Top = 3
            Width = 41
            Height = 16
            Caption = 'Phone'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -13
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object EditPetitionerName1: TDBEdit
            Left = 84
            Top = 0
            Width = 213
            Height = 23
            CharCase = ecUpperCase
            DataField = 'PetitName1'
            DataSource = GrievanceDataSource
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clRed
            Font.Height = -12
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 0
          end
          object EditPetitionerName2: TDBEdit
            Left = 84
            Top = 26
            Width = 213
            Height = 23
            DataField = 'PetitName2'
            DataSource = GrievanceDataSource
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlue
            Font.Height = -12
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 1
          end
          object EditPetitionerAddress1: TDBEdit
            Left = 84
            Top = 51
            Width = 213
            Height = 23
            DataField = 'PetitAddress1'
            DataSource = GrievanceDataSource
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlue
            Font.Height = -12
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 2
          end
          object EditPetitionerAddress2: TDBEdit
            Left = 84
            Top = 77
            Width = 213
            Height = 23
            DataField = 'PetitAddress2'
            DataSource = GrievanceDataSource
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlue
            Font.Height = -12
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 3
          end
          object EditPetitionerStreet: TDBEdit
            Left = 84
            Top = 102
            Width = 213
            Height = 23
            DataField = 'PetitStreet'
            DataSource = GrievanceDataSource
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlue
            Font.Height = -12
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 4
          end
          object EditPetitionerCity: TDBEdit
            Left = 84
            Top = 128
            Width = 213
            Height = 23
            DataField = 'PetitCity'
            DataSource = GrievanceDataSource
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlue
            Font.Height = -12
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 5
          end
          object EditPetitionerState: TDBEdit
            Left = 84
            Top = 153
            Width = 33
            Height = 23
            CharCase = ecUpperCase
            DataField = 'PetitState'
            DataSource = GrievanceDataSource
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlue
            Font.Height = -12
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 6
          end
          object EditPetitionerZip: TDBEdit
            Left = 157
            Top = 153
            Width = 50
            Height = 23
            DataField = 'PetitZip'
            DataSource = GrievanceDataSource
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlue
            Font.Height = -12
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 7
          end
          object EditPetitionerZipPlus4: TDBEdit
            Left = 223
            Top = 153
            Width = 40
            Height = 23
            DataField = 'PetitZipPlus4'
            DataSource = GrievanceDataSource
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlue
            Font.Height = -12
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 8
          end
          object LawyerLookupCombo: TwwDBLookupCombo
            Left = 394
            Top = 24
            Width = 121
            Height = 24
            DropDownAlignment = taLeftJustify
            Selected.Strings = (
              'Code'#9'10'#9'Code'#9'F'
              'Name1'#9'25'#9'Name'#9'F')
            DataField = 'LawyerCode'
            DataSource = GrievanceDataSource
            LookupTable = LawyerCodeTable
            LookupField = 'Code'
            Options = [loColLines, loRowLines, loTitles]
            Style = csDropDownList
            TabOrder = 10
            AutoDropDown = True
            ShowButton = True
            AllowClearKey = False
            OnDropDown = LawyerLookupComboDropDown
            OnCloseUp = LawyerLookupComboCloseUp
          end
          object EditPetitionerPhone: TDBEdit
            Left = 394
            Top = 0
            Width = 154
            Height = 23
            DataField = 'PetitPhoneNumber'
            DataSource = GrievanceDataSource
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlue
            Font.Height = -12
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 9
          end
        end
        object RepresentativeNameAddressTabSheet: TTabSheet
          Caption = 'Representative Name \ Addr'
          ImageIndex = 1
          object Label43: TLabel
            Left = 31
            Top = 3
            Width = 48
            Height = 16
            Caption = 'Name 1'
            FocusControl = EditAttorneyName1
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -13
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label44: TLabel
            Left = 31
            Top = 29
            Width = 48
            Height = 16
            Caption = 'Name 2'
            FocusControl = EditAttorneyName2
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -13
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label45: TLabel
            Left = 31
            Top = 54
            Width = 41
            Height = 16
            Caption = 'Addr 1'
            FocusControl = EditAttorneyAddress1
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -13
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label46: TLabel
            Left = 31
            Top = 80
            Width = 41
            Height = 16
            Caption = 'Addr 2'
            FocusControl = EditAttorneyAddress2
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -13
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label56: TLabel
            Left = 31
            Top = 105
            Width = 38
            Height = 16
            Caption = 'Street'
            FocusControl = EditAttorneyStreet
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -13
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label57: TLabel
            Left = 31
            Top = 131
            Width = 24
            Height = 16
            Caption = 'City'
            FocusControl = EditAttorneyCity
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -13
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label58: TLabel
            Left = 31
            Top = 156
            Width = 33
            Height = 16
            Caption = 'State'
            FocusControl = EditAttorneyState
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -13
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label59: TLabel
            Left = 132
            Top = 156
            Width = 19
            Height = 16
            Caption = 'Zip'
            FocusControl = EditAttorneyZip
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -13
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label60: TLabel
            Left = 212
            Top = 156
            Width = 4
            Height = 16
            Caption = '-'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -13
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label61: TLabel
            Left = 327
            Top = 28
            Width = 51
            Height = 16
            Caption = 'Lawyer:'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -13
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label62: TLabel
            Left = 327
            Top = 3
            Width = 41
            Height = 16
            Caption = 'Phone'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -13
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object EditAttorneyName1: TDBEdit
            Left = 84
            Top = 0
            Width = 213
            Height = 23
            CharCase = ecUpperCase
            DataField = 'AttyName1'
            DataSource = GrievanceDataSource
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clRed
            Font.Height = -12
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 0
          end
          object EditAttorneyName2: TDBEdit
            Left = 84
            Top = 26
            Width = 213
            Height = 23
            DataField = 'AttyName2'
            DataSource = GrievanceDataSource
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlue
            Font.Height = -12
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 1
          end
          object EditAttorneyAddress1: TDBEdit
            Left = 84
            Top = 51
            Width = 213
            Height = 23
            DataField = 'AttyAddress1'
            DataSource = GrievanceDataSource
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlue
            Font.Height = -12
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 2
          end
          object EditAttorneyAddress2: TDBEdit
            Left = 84
            Top = 77
            Width = 213
            Height = 23
            DataField = 'AttyAddress2'
            DataSource = GrievanceDataSource
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlue
            Font.Height = -12
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 3
          end
          object EditAttorneyStreet: TDBEdit
            Left = 84
            Top = 102
            Width = 213
            Height = 23
            DataField = 'AttyStreet'
            DataSource = GrievanceDataSource
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlue
            Font.Height = -12
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 4
          end
          object EditAttorneyCity: TDBEdit
            Left = 84
            Top = 128
            Width = 213
            Height = 23
            DataField = 'AttyCity'
            DataSource = GrievanceDataSource
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlue
            Font.Height = -12
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 5
          end
          object EditAttorneyState: TDBEdit
            Left = 84
            Top = 152
            Width = 33
            Height = 23
            CharCase = ecUpperCase
            DataField = 'AttyState'
            DataSource = GrievanceDataSource
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlue
            Font.Height = -12
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 6
          end
          object EditAttorneyZip: TDBEdit
            Left = 157
            Top = 152
            Width = 50
            Height = 23
            DataField = 'AttyZip'
            DataSource = GrievanceDataSource
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlue
            Font.Height = -12
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 7
          end
          object EditAttorneyZipPlus4: TDBEdit
            Left = 223
            Top = 152
            Width = 40
            Height = 23
            DataField = 'AttyZipPlus4'
            DataSource = GrievanceDataSource
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlue
            Font.Height = -12
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 8
          end
          object LawyerCodeLookupCombo2: TwwDBLookupCombo
            Left = 394
            Top = 24
            Width = 121
            Height = 24
            DropDownAlignment = taLeftJustify
            Selected.Strings = (
              'Code'#9'10'#9'Code'#9'F'
              'Name1'#9'25'#9'Name'#9'F')
            DataField = 'LawyerCode'
            DataSource = GrievanceDataSource
            LookupTable = LawyerCodeTable
            LookupField = 'Code'
            Options = [loColLines, loRowLines, loTitles]
            Style = csDropDownList
            TabOrder = 10
            AutoDropDown = True
            ShowButton = True
            AllowClearKey = False
            OnDropDown = LawyerLookupComboDropDown
            OnCloseUp = LawyerLookupComboCloseUp
          end
          object EditAttorneyPhone: TDBEdit
            Left = 394
            Top = 0
            Width = 154
            Height = 23
            DataField = 'AttyPhoneNumber'
            DataSource = GrievanceDataSource
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlue
            Font.Height = -12
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 9
          end
        end
      end
    end
    object ResultsTabSheet: TTabSheet
      Caption = 'Results'
      ImageIndex = 2
      object Label33: TLabel
        Left = 11
        Top = 359
        Width = 39
        Height = 16
        Caption = 'Notes:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label52: TLabel
        Left = 351
        Top = 359
        Width = 155
        Height = 16
        Caption = 'Values Transferred Date:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object GroupBox2: TGroupBox
        Left = 13
        Top = 97
        Width = 594
        Height = 255
        Caption = ' Decision on: '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        object Label32: TLabel
          Left = 11
          Top = 22
          Width = 73
          Height = 16
          Caption = 'Disposition:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label47: TLabel
          Left = 221
          Top = 46
          Width = 51
          Height = 30
          AutoSize = False
          Caption = 'Land Value'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          WordWrap = True
        end
        object Label48: TLabel
          Left = 421
          Top = 46
          Width = 42
          Height = 38
          AutoSize = False
          Caption = 'Total Value'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          WordWrap = True
        end
        object Label49: TLabel
          Left = 11
          Top = 77
          Width = 77
          Height = 31
          AutoSize = False
          Caption = 'Exemption Granted'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          WordWrap = True
        end
        object Label50: TLabel
          Left = 221
          Top = 77
          Width = 77
          Height = 31
          AutoSize = False
          Caption = 'Exemption Amount'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          WordWrap = True
        end
        object Label51: TLabel
          Left = 11
          Top = 52
          Width = 47
          Height = 18
          AutoSize = False
          Caption = 'Date'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          WordWrap = True
        end
        object DenialReasonLabel: TLabel
          Left = 221
          Top = 15
          Width = 62
          Height = 31
          AutoSize = False
          Caption = 'Denial Reason:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          Visible = False
          WordWrap = True
        end
        object Label29: TLabel
          Left = 379
          Top = 197
          Width = 205
          Height = 51
          AutoSize = False
          Caption = 
            'When you enter the disposition, the board members will be automa' +
            'tically added.'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clGreen
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          WordWrap = True
        end
        object Label39: TLabel
          Left = 421
          Top = 77
          Width = 50
          Height = 31
          AutoSize = False
          Caption = 'Exempt Pct'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          WordWrap = True
        end
        object DispositionLookupCombo: TwwDBLookupCombo
          Left = 91
          Top = 18
          Width = 126
          Height = 24
          DropDownAlignment = taLeftJustify
          Selected.Strings = (
            'Code'#9'10'#9'Code'#9'F'
            'Description'#9'20'#9'Description'#9'F'
            'Approved'#9'5'#9'Approved'#9'F')
          DataField = 'Disposition'
          DataSource = GrievanceResultsDataSource
          LookupTable = GrievanceDispositionCodeTable
          LookupField = 'Code'
          Options = [loColLines, loRowLines]
          Style = csDropDownList
          DropDownWidth = 200
          TabOrder = 0
          AutoDropDown = False
          ShowButton = True
          AllowClearKey = False
          OnCloseUp = DispositionLookupComboCloseUp
        end
        object BoarMemberResultsDBGrid: TwwDBGrid
          Left = 19
          Top = 111
          Width = 346
          Height = 140
          Selected.Strings = (
            'BoardMember'#9'15'#9'Member'#9'F'
            'Concur'#9'6'#9'Concur'#9'F'
            'Against'#9'6'#9'Against'#9'F'
            'Abstain'#9'6'#9'Abstain'#9'F'
            'Absent'#9'6'#9'Absent'#9'F')
          IniAttributes.Delimiter = ';;'
          TitleColor = clBtnFace
          FixedCols = 0
          ShowHorzScrollBar = True
          EditControlOptions = [ecoCheckboxSingleClick, ecoSearchOwnerForm]
          DataSource = GrievanceBoardDataSource
          TabOrder = 9
          TitleAlignment = taCenter
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clBlue
          TitleFont.Height = -13
          TitleFont.Name = 'Arial'
          TitleFont.Style = [fsBold]
          TitleLines = 1
          TitleButtons = False
          IndicatorColor = icBlack
        end
        object BOARMemberLookupCombo: TwwDBLookupCombo
          Left = 39
          Top = 162
          Width = 121
          Height = 24
          DropDownAlignment = taLeftJustify
          DataField = 'BoardMember'
          DataSource = GrievanceBoardDataSource
          LookupTable = BOARMembersTable
          LookupField = 'Code'
          TabOrder = 14
          AutoDropDown = False
          ShowButton = True
          AllowClearKey = False
        end
        object AllConcurButton: TButton
          Left = 380
          Top = 116
          Width = 96
          Height = 34
          Caption = 'All Concur'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 10
          OnClick = AllConcurButtonClick
        end
        object AllAgainstButton: TButton
          Left = 380
          Top = 158
          Width = 96
          Height = 34
          Caption = 'All Against'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 11
          OnClick = AllAgainstButtonClick
        end
        object EditLandValue: TDBEdit
          Left = 295
          Top = 50
          Width = 112
          Height = 23
          DataField = 'LandValue'
          DataSource = GrievanceResultsDataSource
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 4
        end
        object EditTotalValue: TDBEdit
          Left = 473
          Top = 50
          Width = 112
          Height = 23
          DataField = 'TotalValue'
          DataSource = GrievanceResultsDataSource
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 5
        end
        object EditExemptionAmount: TDBEdit
          Left = 295
          Top = 81
          Width = 112
          Height = 23
          DataField = 'EXAmount'
          DataSource = GrievanceResultsDataSource
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 7
        end
        object EditDate: TDBEdit
          Left = 90
          Top = 50
          Width = 84
          Height = 23
          DataField = 'DecisionDate'
          DataSource = GrievanceResultsDataSource
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 3
          OnKeyDown = EditDateKeyDown
        end
        object EditExemptionGranted: TwwDBLookupCombo
          Left = 90
          Top = 80
          Width = 84
          Height = 24
          DropDownAlignment = taLeftJustify
          Selected.Strings = (
            'ExCode'#9'5'#9'Code'#9'F'
            'Description'#9'20'#9'Description'#9'F')
          DataField = 'EXGranted'
          DataSource = GrievanceResultsDataSource
          LookupTable = ExemptionCodeTable
          LookupField = 'ExCode'
          Options = [loColLines, loRowLines]
          TabOrder = 6
          AutoDropDown = True
          ShowButton = True
          AllowClearKey = False
          OnCloseUp = EditExemptionGrantedCloseUp
        end
        object DenialReasonRichEdit: TwwDBRichEditMSWord
          Left = 295
          Top = 18
          Width = 266
          Height = 24
          AutoURLDetect = False
          DataField = 'DenialReason'
          DataSource = GrievanceResultsDataSource
          PrintJobName = 'Delphi 5'
          TabOrder = 1
          Visible = False
          OnDblClick = DenialReasonNotesButtonClick
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
            AA0000007B5C727466315C616E73695C616E7369637067313235325C64656666
            305C6465666C616E67313033337B5C666F6E7474626C7B5C66305C666E696C20
            417269616C3B7D7D0D0A7B5C636F6C6F7274626C203B5C726564305C67726565
            6E305C626C75653235353B7D0D0A5C766965776B696E64345C7563315C706172
            645C6366315C625C66305C667332302044656E69616C526561736F6E52696368
            456469745C7061720D0A7D0D0A00}
        end
        object DenialReasonNotesButton: TButton
          Left = 561
          Top = 18
          Width = 23
          Height = 25
          Caption = '...'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
          Visible = False
          OnClick = DenialReasonNotesButtonClick
        end
        object AddBoardMemberButton: TBitBtn
          Left = 486
          Top = 116
          Width = 101
          Height = 34
          Caption = 'Add Member'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 12
          OnClick = AddBoardMemberButtonClick
          NumGlyphs = 2
        end
        object RemoveBoardMemberButton: TBitBtn
          Left = 486
          Top = 158
          Width = 101
          Height = 34
          Caption = 'Remove Member'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 13
          OnClick = RemoveBoardMemberButtonClick
        end
        object EditExemptionPercent: TDBEdit
          Left = 473
          Top = 81
          Width = 112
          Height = 23
          DataField = 'EXPercent'
          DataSource = GrievanceResultsDataSource
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 8
        end
      end
      object ResultsNotesRichEdit: TwwDBRichEditMSWord
        Left = 59
        Top = 355
        Width = 257
        Height = 25
        AutoURLDetect = False
        DataField = 'Notes'
        DataSource = GrievanceResultsDataSource
        PrintJobName = 'Delphi 5'
        TabOrder = 1
        OnDblClick = ResultsNotesButtonClick
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
          800000007B5C727466315C616E73695C616E7369637067313235325C64656666
          305C6465666C616E67313033337B5C666F6E7474626C7B5C66305C666E696C20
          417269616C3B7D7D0D0A5C766965776B696E64345C7563315C706172645C6630
          5C6673323020526573756C74734E6F74657352696368456469745C7061720D0A
          7D0D0A00}
      end
      object ResultsNotesButton: TButton
        Left = 317
        Top = 355
        Width = 23
        Height = 25
        Caption = '...'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
        OnClick = ResultsNotesButtonClick
      end
      object EditValuesTransferredDate: TDBEdit
        Left = 514
        Top = 355
        Width = 94
        Height = 24
        TabStop = False
        Color = clBtnFace
        DataField = 'ValuesTransferredDate'
        DataSource = GrievanceResultsDataSource
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        ReadOnly = True
        TabOrder = 3
      end
      object ResultsGrid: TwwDBGrid
        Left = 13
        Top = 2
        Width = 594
        Height = 95
        Selected.Strings = (
          'ComplaintReason'#9'19'#9'Complaint Reason'
          'Disposition'#9'10'#9'Disposition'
          'DecisionDate'#9'12'#9'Decision Date'
          'LandValue'#9'9'#9'Land Val'
          'TotalValue'#9'11'#9'Total Val'
          'EXGranted'#9'7'#9'Ex Code'
          'EXPercent'#9'5'#9'Ex Pct')
        IniAttributes.Delimiter = ';;'
        TitleColor = clBtnFace
        FixedCols = 0
        ShowHorzScrollBar = True
        DataSource = GrievanceResultsDataSource
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        Options = [dgAlwaysShowEditor, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit, dgWordWrap]
        ParentFont = False
        ReadOnly = True
        TabOrder = 4
        TitleAlignment = taLeftJustify
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clBlue
        TitleFont.Height = -13
        TitleFont.Name = 'Arial'
        TitleFont.Style = [fsBold]
        TitleLines = 1
        TitleButtons = False
        IndicatorColor = icBlack
      end
    end
    object DocumentsTabSheet: TTabSheet
      Caption = 'Documents'
      ImageIndex = 3
      object MainPanel: TPanel
        Left = 0
        Top = 3
        Width = 624
        Height = 381
        Align = alBottom
        BevelInner = bvLowered
        TabOrder = 0
        object DocumentGrid: TwwDBGrid
          Left = 8
          Top = 7
          Width = 606
          Height = 131
          Selected.Strings = (
            'DocumentNumber'#9'6'#9'Order'#9'F'
            'DocumentTypeDescription'#9'10'#9'Doc Type'#9'F'
            'Date'#9'10'#9'Date'#9'F'
            'DocumentLocation'#9'36'#9'Document Location'#9'F'
            'Notes'#9'29'#9'Notes'#9'F')
          MemoAttributes = [mSizeable, mWordWrap, mGridShow]
          IniAttributes.Delimiter = ';;'
          TitleColor = clBtnFace
          FixedCols = 0
          ShowHorzScrollBar = True
          EditControlOptions = [ecoCheckboxSingleClick, ecoSearchOwnerForm]
          DataSource = DocumentDataSource
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          KeyOptions = [dgEnterToTab, dgAllowDelete, dgAllowInsert]
          ParentFont = False
          TabOrder = 0
          TitleAlignment = taCenter
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clBlue
          TitleFont.Height = -11
          TitleFont.Name = 'Arial'
          TitleFont.Style = [fsBold]
          TitleLines = 1
          TitleButtons = False
          OnDblClick = FullScreenButtonClick
          IndicatorColor = icBlack
        end
        object FullScreenButton: TBitBtn
          Left = 317
          Top = 342
          Width = 90
          Height = 30
          Caption = '&Full Screen'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          OnClick = FullScreenButtonClick
          Glyph.Data = {
            76010000424D7601000000000000760000002800000020000000100000000100
            04000000000000010000130B0000130B00001000000000000000000000000000
            800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
            33033333333333333F7F3333333333333000333333333333F777333333333333
            000333333333333F777333333333333000333333333333F77733333333333300
            033333333FFF3F777333333700073B703333333F7773F77733333307777700B3
            33333377333777733333307F8F8F7033333337F333F337F3333377F8F9F8F773
            3333373337F3373F3333078F898F870333337F33F7FFF37F333307F99999F703
            33337F377777337F3333078F898F8703333373F337F33373333377F8F9F8F773
            333337F3373337F33333307F8F8F70333333373FF333F7333333330777770333
            333333773FF77333333333370007333333333333777333333333}
          NumGlyphs = 2
        end
        object BitBtn1: TBitBtn
          Left = 524
          Top = 342
          Width = 90
          Height = 30
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
          OnClick = CloseButtonClick
          Kind = bkClose
        end
        object BitBtn2: TBitBtn
          Left = 420
          Top = 342
          Width = 90
          Height = 30
          Caption = '&Print'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 3
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
        object Notebook: TNotebook
          Left = 3
          Top = 138
          Width = 614
          Height = 198
          TabOrder = 4
          object TPage
            Left = 0
            Top = 0
            Caption = 'Image Page'
            object ImagePanel: TPanel
              Left = 4
              Top = 3
              Width = 608
              Height = 197
              BevelInner = bvLowered
              BevelOuter = bvLowered
              BorderWidth = 2
              TabOrder = 0
              object ImageScrollBox: TScrollBox
                Left = 4
                Top = 4
                Width = 600
                Height = 189
                Align = alClient
                TabOrder = 0
                object Image: TPMultiImage
                  Left = 0
                  Top = 0
                  Width = 596
                  Height = 185
                  GrabHandCursor = 5
                  Align = alClient
                  Scrolling = True
                  ShowScrollbars = True
                  B_W_CopyFlags = [C_DEL]
                  Color = clBtnFace
                  Picture.Data = {07544269746D617000000000}
                  ImageReadRes = lAutoMatic
                  BlitMode = sLight
                  ImageWriteRes = sAutoMatic
                  TifSaveCompress = sNONE
                  TiffPage = 0
                  TiffAppend = False
                  JPegSaveQuality = 25
                  JPegSaveSmooth = 5
                  RubberBandBtn = mbLeft
                  ScrollbarWidth = 12
                  ParentColor = True
                  Stretch = True
                  TextLeft = 0
                  TextTop = 0
                  TextRotate = 0
                  TabOrder = 0
                  ZoomBy = 10
                end
              end
            end
          end
          object TPage
            Left = 0
            Top = 0
            Caption = 'OLE Application Page'
            object Panel3: TPanel
              Left = 4
              Top = 2
              Width = 608
              Height = 184
              BevelInner = bvLowered
              BevelOuter = bvLowered
              BorderWidth = 2
              TabOrder = 0
              object ScrollBox1: TScrollBox
                Left = 4
                Top = 4
                Width = 600
                Height = 176
                VertScrollBar.Range = 800
                Align = alClient
                AutoScroll = False
                TabOrder = 0
                object OleContainer: TOleContainer
                  Left = 0
                  Top = 0
                  Width = 580
                  Height = 800
                  AllowInPlace = False
                  AllowActiveDoc = False
                  AutoActivate = aaManual
                  Align = alClient
                  TabOrder = 0
                end
              end
            end
          end
          object TPage
            Left = 0
            Top = 0
            Caption = 'Apex Sketch Page'
          end
          object TPage
            Left = 0
            Top = 0
            Caption = 'PDF page'
            object Label3: TLabel
              Left = 220
              Top = 89
              Width = 178
              Height = 22
              Caption = 'No image available.'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlue
              Font.Height = -19
              Font.Name = 'Arial'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object Label63: TLabel
              Left = 195
              Top = 118
              Width = 229
              Height = 16
              Caption = 'Click Full Screen to view document.'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlue
              Font.Height = -13
              Font.Name = 'Arial'
              Font.Style = [fsBold]
              ParentFont = False
            end
          end
        end
        object DeleteDocumentButton: TBitBtn
          Left = 106
          Top = 342
          Width = 99
          Height = 30
          Caption = '&Remove Doc'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 5
          OnClick = DeleteDocumentButtonClick
          Glyph.Data = {
            16020000424D160200000000000076000000280000001A0000001A0000000100
            040000000000A001000000000000000000001000000000000000000000000000
            BF0000BF000000BFBF00BF000000BF00BF00BFBF0000C0C0C000808080000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
            7777777777777709400077777777777777777799977777000000777777777777
            77777999977777FFFF0079997788888888889999777777FFFF00799997888888
            88899998777777FFFF00779999444444444999887777770000007779999FBFBF
            BF999488777777000000777799999BFBF99994887777770000007777799999BF
            9999B488777777000000777774F99999999BF488777777000000777774BF9999
            99BFB488777777FFFF00777774FBF9999BFBF488777777FFFFC0777774BF9999
            99BFB488777777FFFF00777774F99999999BF488777777FFFF007777749999BF
            9999B488777777FFFF00777774999BFBF9999488777777FFFF0077777999BFBF
            B499999777777700FFFF77779999FBFBF4F9999977777700F9007779999FBFBF
            B4B479999777771E8000779999FBFBFBF4477799997777000000799994444444
            4477777999777700800079997777777777777777997777008000799777777777
            7777777777777700800077777777777777777777777777008000777777777777
            7777777777777700800077777777777777777777777777008000}
        end
        object NewDocumentButton: TBitBtn
          Left = 6
          Top = 342
          Width = 90
          Height = 30
          Caption = 'New Doc'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 6
          OnClick = NewDocumentButtonClick
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
        object btnDocumentSave: TBitBtn
          Left = 213
          Top = 342
          Width = 90
          Height = 30
          Caption = '&Save Doc'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 7
          OnClick = btnDocumentSaveClick
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
        end
      end
    end
    object LettersSentTabSheet: TTabSheet
      Caption = 'Letters Sent'
      ImageIndex = 4
      object GrievanceLettersSentGrid: TwwDBGrid
        Left = 65
        Top = 36
        Width = 494
        Height = 307
        Selected.Strings = (
          'LetterName'#9'27'#9'Letter Name'
          'DateSent'#9'10'#9'Date Sent'
          'TimeSent'#9'11'#9'Time Sent'
          'SentByUser'#9'15'#9'User')
        IniAttributes.Delimiter = ';;'
        TitleColor = clBtnFace
        FixedCols = 0
        ShowHorzScrollBar = True
        DataSource = GrievanceLettersSentDataSource
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgConfirmDelete, dgCancelOnExit, dgWordWrap]
        ParentFont = False
        ReadOnly = True
        TabOrder = 0
        TitleAlignment = taCenter
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clBlue
        TitleFont.Height = -13
        TitleFont.Name = 'Arial'
        TitleFont.Style = [fsBold]
        TitleLines = 1
        TitleButtons = False
        IndicatorColor = icBlack
      end
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 415
    Width = 632
    Height = 39
    Align = alBottom
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 1
    object CloseButton: TBitBtn
      Left = 529
      Top = 4
      Width = 89
      Height = 30
      Caption = '&Close'
      TabOrder = 0
      OnClick = CloseButtonClick
      Glyph.Data = {
        DE010000424DDE01000000000000760000002800000024000000120000000100
        0400000000006801000000000000000000001000000000000000000000000000
        8000008000000080800080000000800080008080000080808000C0C0C0000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00377777777788
        F8F878F7777777777333333F00004444400777FFF444447777777777F333FF7F
        000033334D5008FFF4333377777777773337777F0000333345D50FFFF4333333
        337F777F3337F33F000033334D5D0FFFF43333333377877F3337F33F00003333
        45D50FEFE4333333337F787F3337F33F000033334D5D0FFFF43333333377877F
        3337F33F0000333345D50FEFE4333333337F787F3337F33F000033334D5D0FFF
        F43333333377877F3337F33F0000333345D50FEFE4333333337F787F3337F33F
        000033334D5D0EFEF43333333377877F3337F33F0000333345D50FEFE4333333
        337F787F3337F33F000033334D5D0EFEF43333333377877F3337F33F00003333
        4444444444333333337F7F7FFFF7F33F00003333333333333333333333777777
        7777333F00003333330000003333333333333FFFFFF3333F00003333330AAAA0
        333333333333777777F3333F00003333330000003333333333337FFFF7F3333F
        0000}
      NumGlyphs = 2
    end
    object SaveButton: TBitBtn
      Left = 318
      Top = 4
      Width = 89
      Height = 30
      Caption = '&Save'
      TabOrder = 1
      OnClick = SaveButtonClick
      Glyph.Data = {
        DE010000424DDE01000000000000760000002800000024000000120000000100
        0400000000006801000000000000000000001000000000000000000000000000
        8000008000000080800080000000800080008080000080808000C0C0C0000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        3333333333333333333333330000333333333333333333333333F33333333333
        00003333344333333333333333377F3333333333000033334224333333333333
        337337F3333333330000333422224333333333333733337F3333333300003342
        222224333333333373333337F3333333000034222A22224333333337F337F333
        7F33333300003222A3A2224333333337F3737F337F33333300003A2A333A2224
        33333337F73337F337F33333000033A33333A222433333337333337F337F3333
        0000333333333A222433333333333337F337F33300003333333333A222433333
        333333337F337F33000033333333333A222433333333333337F337F300003333
        33333333A222433333333333337F337F00003333333333333A22433333333333
        3337F37F000033333333333333A223333333333333337F730000333333333333
        333A333333333333333337330000333333333333333333333333333333333333
        0000}
      NumGlyphs = 2
    end
    object CancelButton: TBitBtn
      Left = 423
      Top = 4
      Width = 89
      Height = 30
      Cancel = True
      Caption = '&Cancel'
      TabOrder = 2
      OnClick = CancelButtonClick
      Glyph.Data = {
        DE010000424DDE01000000000000760000002800000024000000120000000100
        0400000000006801000000000000000000001000000000000000000000000000
        8000008000000080800080000000800080008080000080808000C0C0C0000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        333333333333333333333333000033337733333333333333333F333333333333
        0000333911733333973333333377F333333F3333000033391117333911733333
        37F37F333F77F33300003339111173911117333337F337F3F7337F3300003333
        911117111117333337F3337F733337F3000033333911111111733333337F3337
        3333F7330000333333911111173333333337F333333F73330000333333311111
        7333333333337F3333373333000033333339111173333333333337F333733333
        00003333339111117333333333333733337F3333000033333911171117333333
        33337333337F333300003333911173911173333333373337F337F33300003333
        9117333911173333337F33737F337F33000033333913333391113333337FF733
        37F337F300003333333333333919333333377333337FFF730000333333333333
        3333333333333333333777330000333333333333333333333333333333333333
        0000}
      NumGlyphs = 2
    end
    object PrintButton: TBitBtn
      Left = 212
      Top = 4
      Width = 89
      Height = 30
      Caption = '&Print'
      TabOrder = 3
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
  end
  object GrievanceTable: TTable
    BeforeEdit = GrievanceTableBeforeEdit
    AfterEdit = GrievanceTableAfterEdit
    BeforePost = GrievanceTableBeforePost
    AfterPost = GrievanceTableAfterPost
    DatabaseName = 'PASsystem'
    IndexName = 'BYTAXROLLYR_SWISSBLKEY_GRVNUM'
    TableName = 'grievancetable'
    TableType = ttDBase
    Left = 523
    Top = 129
  end
  object GrievanceDataSource: TDataSource
    DataSet = GrievanceTable
    Left = 533
    Top = 91
  end
  object LawyerCodeTable: TwwTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYCODE'
    TableName = 'ZGLawyerCodes'
    TableType = ttDBase
    SyncSQLByRange = False
    NarrowSearch = False
    ValidateWithMask = True
    Left = 333
    Top = 82
  end
  object BOARMembersTable: TTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYCODE'
    TableName = 'zgboardmembers'
    TableType = ttDBase
    Left = 402
    Top = 408
  end
  object GrievanceBoardTable: TwwTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYYEAR_SBL_GRVNUM_RSLT_MEM'
    TableName = 'GreivanceBOARDetails'
    TableType = ttDBase
    ControlType.Strings = (
      'Concur;CheckBox;True;False'
      'Against;CheckBox;True;False'
      'Abstain;CheckBox;True;False'
      'Absent;CheckBox;True;False'
      'BoardMember;CustomEdit;BOARMemberLookupCombo')
    SyncSQLByRange = False
    NarrowSearch = False
    ValidateWithMask = True
    Left = 278
    Top = 411
    object GrievanceBoardTableBoardMember: TStringField
      DisplayLabel = 'Member'
      DisplayWidth = 15
      FieldName = 'BoardMember'
      Size = 10
    end
    object GrievanceBoardTableConcur: TBooleanField
      DisplayWidth = 6
      FieldName = 'Concur'
      OnChange = GrievanceBoardTableVoteChange
    end
    object GrievanceBoardTableAgainst: TBooleanField
      DisplayWidth = 6
      FieldName = 'Against'
      OnChange = GrievanceBoardTableVoteChange
    end
    object GrievanceBoardTableAbstain: TBooleanField
      DisplayWidth = 6
      FieldName = 'Abstain'
      OnChange = GrievanceBoardTableVoteChange
    end
    object GrievanceBoardTableAbsent: TBooleanField
      DisplayWidth = 6
      FieldName = 'Absent'
      OnChange = GrievanceBoardTableVoteChange
    end
    object GrievanceBoardTableTaxRollYr: TStringField
      DisplayWidth = 4
      FieldName = 'TaxRollYr'
      Visible = False
      Size = 4
    end
    object GrievanceBoardTableSwisSBLKey: TStringField
      DisplayWidth = 26
      FieldName = 'SwisSBLKey'
      Visible = False
      Size = 26
    end
    object GrievanceBoardTableGrievanceNumber: TIntegerField
      DisplayWidth = 10
      FieldName = 'GrievanceNumber'
      Visible = False
    end
    object GrievanceBoardTableResultNumber: TIntegerField
      FieldName = 'ResultNumber'
      Visible = False
    end
  end
  object GrievanceBoardDataSource: TwwDataSource
    DataSet = GrievanceBoardTable
    Left = 305
    Top = 413
  end
  object GrievanceResultsTable: TwwTable
    AfterEdit = GrievanceResultsTableAfterEdit
    BeforePost = GrievanceResultsTableBeforePost
    AfterPost = GrievanceResultsTableAfterPost
    AfterScroll = GrievanceResultsTableAfterScroll
    DatabaseName = 'PASsystem'
    IndexName = 'BYYEAR_SBL_GRVNUM_RSLT'
    TableName = 'grievanceresultstable'
    TableType = ttDBase
    SyncSQLByRange = False
    NarrowSearch = False
    ValidateWithMask = True
    Left = 135
    Top = 395
  end
  object GrievanceResultsDataSource: TwwDataSource
    DataSet = GrievanceResultsTable
    Left = 27
    Top = 403
  end
  object PropertyClassCodeTable: TTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYMAINCODE'
    TableName = 'zpropclstbl'
    TableType = ttDBase
    Left = 65524
    Top = 232
  end
  object PropertyClassDataSource: TDataSource
    DataSet = PropertyClassCodeTable
    Left = 282
    Top = 65527
  end
  object GrievanceExemptionTable: TwwTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYYEAR_SWISSBLKEY_EXCODE'
    TableName = 'gpexemptionrec'
    TableType = ttDBase
    SyncSQLByRange = False
    NarrowSearch = False
    ValidateWithMask = True
    Left = 498
    Top = 408
  end
  object GrievanceExemptionDataSource: TwwDataSource
    DataSet = GrievanceExemptionTable
    Left = 542
    Top = 403
  end
  object ExemptionCodeTable: TwwTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYEXCODE'
    TableName = 'TExCodeTbl'
    TableType = ttDBase
    SyncSQLByRange = False
    NarrowSearch = False
    ValidateWithMask = True
    Left = 139
    Top = 123
  end
  object GrievanceComplaintReasonTable: TwwTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYMAINCODE'
    TableName = 'ZGReasonCategoryCodes'
    TableType = ttDBase
    SyncSQLByRange = False
    NarrowSearch = False
    ValidateWithMask = True
    Left = 210
    Top = 390
  end
  object GrievanceComplaintSubreasonTable: TwwTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYCODE'
    TableName = 'zgsubreasoncodes'
    TableType = ttDBase
    SyncSQLByRange = False
    NarrowSearch = False
    ValidateWithMask = True
    Left = 354
    Top = 404
  end
  object GrievanceDenialReasonCodeTable: TwwTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYMAINCODE'
    TableName = 'ZGDenialReasonCodes'
    TableType = ttDBase
    SyncSQLByRange = False
    NarrowSearch = False
    ValidateWithMask = True
    Left = 80
    Top = 405
  end
  object GrievanceDispositionCodeTable: TwwTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYCODE'
    TableName = 'ZGBOARDispositionCode'
    TableType = ttDBase
    ControlType.Strings = (
      'Approved;CheckBox;True;False')
    SyncSQLByRange = False
    NarrowSearch = False
    ValidateWithMask = True
    Left = 228
    Top = 19
  end
  object GrievanceResultsLookupTable: TTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYYEAR_SBL_GRVNUM_RSLT'
    TableName = 'grievanceresultstable'
    TableType = ttDBase
    Left = 513
    Top = 214
  end
  object SetFocusOnPageTimer: TTimer
    Enabled = False
    Interval = 100
    OnTimer = SetFocusOnPageTimerTimer
    Left = 270
    Top = 166
  end
  object GreivanceExemptionsAskedDataSource: TwwDataSource
    DataSet = GrievanceExemptionsAskedTable
    Left = 532
    Top = 312
  end
  object GrievanceExemptionsAskedTable: TwwTable
    OnNewRecord = GrievanceExemptionsAskedTableNewRecord
    DatabaseName = 'PASsystem'
    IndexName = 'BYYEAR_SBL_GRVNUM_EX'
    TableName = 'GExemptionsAsked'
    TableType = ttDBase
    ControlType.Strings = (
      'ExemptionCode;CustomEdit;ExemptionCodeAskedLookupCombo')
    SyncSQLByRange = False
    NarrowSearch = False
    ValidateWithMask = True
    Left = 271
    Top = 323
  end
  object GrievanceLettersSentTable: TwwTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYYEAR_SBL_GRVNUM_RSLT_LTR'
    TableName = 'gletterssent'
    TableType = ttDBase
    SyncSQLByRange = False
    NarrowSearch = False
    ValidateWithMask = True
    Left = 464
    Top = 65528
  end
  object GrievanceLettersSentDataSource: TwwDataSource
    DataSet = GrievanceLettersSentTable
    Left = 426
    Top = 3
  end
  object GrievanceLookupTable: TTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYTAXROLLYR_GREVNUM'
    TableName = 'grievancetable'
    TableType = ttDBase
    Left = 209
    Top = 175
  end
  object GrievanceBoardLookupTable: TTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYYEAR_SBL_GRVNUM_RSLT_MEM'
    TableName = 'GreivanceBOARDetails'
    TableType = ttDBase
    Left = 78
    Top = 313
  end
  object AssessmentTable: TTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYTAXROLLYR_SWISSBLKEY'
    TableName = 'TPAssessRec'
    TableType = ttDBase
    Left = 361
    Top = 270
  end
  object DocumentTable: TTable
    AfterInsert = DocumentTableAfterInsert
    AfterScroll = DocumentTableAfterScroll
    OnNewRecord = DocumentTableNewRecord
    DatabaseName = 'PASsystem'
    IndexName = 'BYYEAR_GNUM_SWISSBL_DNUM'
    TableName = 'gdocumentrec'
    TableType = ttDBase
    Left = 319
    Top = 283
  end
  object DocumentLookupTable: TTable
    AutoCalcFields = False
    DatabaseName = 'PASsystem'
    IndexName = 'BYYEAR_GNUM_SWISSBL_DNUM'
    TableName = 'gdocumentrec'
    TableType = ttDBase
    Left = 369
    Top = 182
  end
  object DocumentDataSource: TDataSource
    DataSet = DocumentTable
    Left = 136
    Top = 205
  end
  object WordApplication: TWordApplication
    AutoConnect = False
    ConnectKind = ckRunningOrNew
    AutoQuit = False
    OnQuit = WordApplicationQuit
    Left = 465
    Top = 177
  end
  object ExcelApplication: TExcelApplication
    AutoConnect = False
    ConnectKind = ckRunningOrNew
    AutoQuit = False
    OnWorkbookBeforeClose = ExcelApplicationWorkbookBeforeClose
    Left = 476
    Top = 228
  end
  object DocumentTypeTable: TwwTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYAPPLICATIONTAG'
    TableName = 'oleapplicationsavailable'
    TableType = ttDBase
    SyncSQLByRange = False
    NarrowSearch = False
    ValidateWithMask = True
    Left = 460
    Top = 275
  end
  object DocumentDialog: TOpenDialog
    DefaultExt = 'doc'
    Filter = 'MS Word documents|*.doc|All Files|*.*'
    Left = 425
    Top = 312
  end
  object OpenScannedImageDialog: TOpenPictureDialog
    Filter = 
      'All Files (*.*)|*.*|JPEG Image File (*.jpg)|*.jpg|JPEG Image Fil' +
      'e (*.jpeg)|*.jpeg|Bitmaps (*.bmp)|*.bmp|Icons (*.ico)|*.ico|Enha' +
      'nced Metafiles (*.emf)|*.emf|Metafiles (*.wmf)|*.wmf|GIF Image F' +
      'iles (*.gif)|*.gif|All (*.jpg;*.jpeg;*.bmp;*.ico;*.emf;*.wmf,*.g' +
      'if)|*.jpg;*.jpeg;*.bmp;*.ico;*.emf;*.wmf,*.gif'
    Left = 568
    Top = 320
  end
  object OleWordDocumentTimer: TTimer
    Enabled = False
    OnTimer = OleWordDocumentTimerTimer
    Left = 568
    Top = 283
  end
  object WordDocument: TWordDocument
    AutoConnect = False
    ConnectKind = ckRunningOrNew
    OnClose = WordDocumentClose
    Left = 565
    Top = 232
  end
  object OLEItemNameTimer: TTimer
    Enabled = False
    OnTimer = OLEItemNameTimerTimer
    Left = 548
    Top = 176
  end
  object OpenPDFDialog: TOpenDialog
    DefaultExt = 'pdf'
    Filter = 'PDF Files|*.pdf|All Files|*.*'
    Left = 444
    Top = 167
  end
end
