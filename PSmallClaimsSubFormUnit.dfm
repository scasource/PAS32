object SmallClaimsSubform: TSmallClaimsSubform
  Left = 728
  Top = 240
  Width = 647
  Height = 488
  HorzScrollBar.Range = 630
  VertScrollBar.Range = 420
  AutoScroll = False
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
    Width = 631
    Height = 411
    ActivePage = SummaryTabSheet
    Align = alClient
    TabOrder = 0
    OnChange = PageControlChange
    object SummaryTabSheet: TTabSheet
      Caption = 'Summary'
      object Label72: TLabel
        Left = 3
        Top = 178
        Width = 57
        Height = 16
        Caption = 'Attorney:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object GroupBox1: TGroupBox
        Left = 1
        Top = 1
        Width = 618
        Height = 165
        Caption = ' Parcel: '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        object LabelOldParcelID: TLabel
          Left = 7
          Top = 139
          Width = 88
          Height = 16
          Caption = 'Old Parcel ID:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          Visible = False
        end
        object Label57: TLabel
          Left = 321
          Top = 25
          Width = 51
          Height = 16
          Caption = 'Index #:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label58: TLabel
          Left = 321
          Top = 54
          Width = 32
          Height = 16
          Caption = 'Year:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label59: TLabel
          Left = 7
          Top = 54
          Width = 46
          Height = 16
          Caption = 'Owner:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label60: TLabel
          Left = 7
          Top = 82
          Width = 66
          Height = 16
          Caption = 'Petitioner:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label61: TLabel
          Left = 321
          Top = 82
          Width = 57
          Height = 16
          Caption = 'Prop Cls:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label62: TLabel
          Left = 321
          Top = 111
          Width = 48
          Height = 16
          Caption = 'School:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label63: TLabel
          Left = 463
          Top = 25
          Width = 53
          Height = 16
          Caption = 'Eq Rate:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label64: TLabel
          Left = 7
          Top = 25
          Width = 59
          Height = 16
          Caption = 'Location:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object LabelSwisCode: TLabel
          Left = 7
          Top = 111
          Width = 34
          Height = 16
          Caption = 'Swis:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          Visible = False
        end
        object Label51: TLabel
          Left = 463
          Top = 54
          Width = 68
          Height = 16
          Caption = 'Uniform %:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label65: TLabel
          Left = 463
          Top = 82
          Width = 31
          Height = 16
          Caption = 'RAR:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object EditOldParcelID: TEdit
          Left = 104
          Top = 135
          Width = 197
          Height = 24
          TabStop = False
          Color = clBtnFace
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          ReadOnly = True
          TabOrder = 0
          Visible = False
        end
        object EditOwner: TDBEdit
          Left = 104
          Top = 50
          Width = 197
          Height = 24
          TabStop = False
          Color = clBtnFace
          DataField = 'CurrentName1'
          DataSource = SmallClaimsDataSource
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          ReadOnly = True
          TabOrder = 1
        end
        object EditPetitioner: TDBEdit
          Left = 104
          Top = 78
          Width = 197
          Height = 24
          TabStop = False
          Color = clBtnFace
          DataField = 'PetitName1'
          DataSource = SmallClaimsDataSource
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          ReadOnly = True
          TabOrder = 2
        end
        object EditYear: TDBEdit
          Left = 386
          Top = 50
          Width = 64
          Height = 24
          TabStop = False
          Color = clBtnFace
          DataField = 'TaxRollYr'
          DataSource = SmallClaimsDataSource
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          ReadOnly = True
          TabOrder = 3
        end
        object EditIndexNumber: TDBEdit
          Left = 386
          Top = 21
          Width = 64
          Height = 24
          TabStop = False
          Color = clBtnFace
          DataField = 'IndexNumber'
          DataSource = SmallClaimsDataSource
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          ReadOnly = True
          TabOrder = 4
        end
        object EditPropertyClass: TDBEdit
          Left = 386
          Top = 78
          Width = 64
          Height = 24
          TabStop = False
          Color = clBtnFace
          DataField = 'PropertyClassCode'
          DataSource = SmallClaimsDataSource
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          ReadOnly = True
          TabOrder = 5
        end
        object EditSchool: TDBEdit
          Left = 386
          Top = 107
          Width = 64
          Height = 24
          TabStop = False
          Color = clBtnFace
          DataField = 'SchoolCode'
          DataSource = SmallClaimsDataSource
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          ReadOnly = True
          TabOrder = 6
        end
        object EditEqRate: TDBEdit
          Left = 534
          Top = 21
          Width = 64
          Height = 24
          TabStop = False
          Color = clBtnFace
          DataField = 'CurrentEqRate'
          DataSource = SmallClaimsDataSource
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          ReadOnly = True
          TabOrder = 7
        end
        object EditLocation: TEdit
          Left = 104
          Top = 21
          Width = 197
          Height = 24
          TabStop = False
          Color = clBtnFace
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          ReadOnly = True
          TabOrder = 8
        end
        object EditSwisCode: TEdit
          Left = 104
          Top = 107
          Width = 197
          Height = 24
          TabStop = False
          Color = clBtnFace
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          ReadOnly = True
          TabOrder = 9
          Visible = False
        end
        object EditUniformPercentOfValue: TDBEdit
          Left = 534
          Top = 50
          Width = 64
          Height = 24
          TabStop = False
          Color = clBtnFace
          DataField = 'CurrentUniformPercent'
          DataSource = SmallClaimsDataSource
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          ReadOnly = True
          TabOrder = 10
        end
        object EditRAR: TDBEdit
          Left = 534
          Top = 78
          Width = 64
          Height = 24
          TabStop = False
          Color = clBtnFace
          DataField = 'CurrentRAR'
          DataSource = SmallClaimsDataSource
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          ReadOnly = True
          TabOrder = 11
        end
      end
      object AttorneyTreeView: TTreeView
        Left = 3
        Top = 199
        Width = 259
        Height = 176
        Indent = 19
        TabOrder = 1
      end
      object SmallClaimsSummaryGroupBox: TGroupBox
        Left = 277
        Top = 191
        Width = 341
        Height = 174
        Caption = ' Small Claim: '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 2
        object Label67: TLabel
          Left = 125
          Top = 15
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
        object Label68: TLabel
          Left = 223
          Top = 15
          Width = 63
          Height = 15
          Caption = 'Full Mkt Val'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clMaroon
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label69: TLabel
          Left = 16
          Top = 41
          Width = 67
          Height = 15
          Caption = 'Orig Assmt:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clMaroon
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label70: TLabel
          Left = 16
          Top = 72
          Width = 59
          Height = 15
          Caption = 'Asking AV:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clMaroon
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label66: TLabel
          Left = 16
          Top = 102
          Width = 62
          Height = 15
          Caption = 'Difference:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clMaroon
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label71: TLabel
          Left = 16
          Top = 133
          Width = 69
          Height = 15
          Caption = 'Final Assmt:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clMaroon
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object EditCurrentAssessment: TDBEdit
          Left = 106
          Top = 37
          Width = 89
          Height = 23
          TabStop = False
          Color = clBtnFace
          DataField = 'CurrentTotalValue'
          DataSource = SmallClaimsDataSource
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          ReadOnly = True
          TabOrder = 0
        end
        object EditPetitionerAssessment: TDBEdit
          Left = 106
          Top = 68
          Width = 89
          Height = 23
          TabStop = False
          Color = clBtnFace
          DataField = 'PetitTotalValue'
          DataSource = SmallClaimsDataSource
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          ReadOnly = True
          TabOrder = 1
        end
        object EditPetitionerFullMarket: TDBEdit
          Left = 213
          Top = 68
          Width = 89
          Height = 23
          TabStop = False
          Color = clBtnFace
          DataField = 'PetitFullMarketVal'
          DataSource = SmallClaimsDataSource
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          ReadOnly = True
          TabOrder = 2
        end
        object EditCurrentFullMarket: TDBEdit
          Left = 213
          Top = 37
          Width = 89
          Height = 23
          TabStop = False
          Color = clBtnFace
          DataField = 'CurrentFullMarketVal'
          DataSource = SmallClaimsDataSource
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          ReadOnly = True
          TabOrder = 3
        end
        object EditFinalAssessment: TDBEdit
          Left = 106
          Top = 129
          Width = 89
          Height = 23
          TabStop = False
          Color = clBtnFace
          DataField = 'GrantedTotalValue'
          DataSource = SmallClaimsDataSource
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          ReadOnly = True
          TabOrder = 4
        end
        object EditFinalFullMarket: TDBEdit
          Left = 213
          Top = 129
          Width = 89
          Height = 23
          TabStop = False
          Color = clBtnFace
          DataField = 'GrantedFullMarketVal'
          DataSource = SmallClaimsDataSource
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          ReadOnly = True
          TabOrder = 5
        end
        object EditAssessmentDifference: TEdit
          Left = 106
          Top = 98
          Width = 89
          Height = 24
          TabStop = False
          Color = clBtnFace
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clRed
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          ReadOnly = True
          TabOrder = 6
        end
        object EditFullMarketDifference: TEdit
          Left = 213
          Top = 98
          Width = 89
          Height = 24
          TabStop = False
          Color = clBtnFace
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clRed
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          ReadOnly = True
          TabOrder = 7
        end
      end
    end
    object ParcelTabSheet: TTabSheet
      Caption = 'Parcel Info'
      ImageIndex = 1
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
      object Label32: TLabel
        Left = 331
        Top = 161
        Width = 63
        Height = 34
        AutoSize = False
        Caption = 'Grievance Results:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        WordWrap = True
      end
      object OwnerGroupBox: TGroupBox
        Left = 9
        Top = 1
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
          DataSource = SmallClaimsDataSource
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
          DataSource = SmallClaimsDataSource
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
          DataSource = SmallClaimsDataSource
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
          DataSource = SmallClaimsDataSource
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
          DataSource = SmallClaimsDataSource
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
          DataSource = SmallClaimsDataSource
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
          DataSource = SmallClaimsDataSource
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
          DataSource = SmallClaimsDataSource
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
          DataSource = SmallClaimsDataSource
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 8
        end
      end
      object TimeOfSmallClaimInformationGroupBox: TGroupBox
        Left = 3
        Top = 191
        Width = 620
        Height = 192
        Caption = ' Time of Small Claim Information: '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 1
        object TimeOfSmallClaimPageControl: TPageControl
          Left = 2
          Top = 17
          Width = 613
          Height = 171
          ActivePage = TabSheet2
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          object TabSheet2: TTabSheet
            Caption = 'Basic Info'
            object Label25: TLabel
              Left = 128
              Top = 7
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
              Left = 307
              Top = 6
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
              Left = 2
              Top = 7
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
              Left = 128
              Top = 32
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
              Left = 128
              Top = 61
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
              Left = 2
              Top = 61
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
              Left = 2
              Top = 34
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
            object PropertyClassCodeText: TDBText
              Left = 275
              Top = 32
              Width = 293
              Height = 17
              DataField = 'Description'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clGreen
              Font.Height = -12
              Font.Name = 'Arial'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object PriorValueLabel: TLabel
              Left = 209
              Top = 88
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
              Left = 208
              Top = 115
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
              Left = 334
              Top = 68
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
              Left = 436
              Top = 68
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
            object Label29: TLabel
              Left = 2
              Top = 80
              Width = 85
              Height = 33
              AutoSize = False
              Caption = 'Equalization Rate'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -13
              Font.Name = 'Arial'
              Font.Style = [fsBold]
              ParentFont = False
              WordWrap = True
            end
            object Label27: TLabel
              Left = 515
              Top = 68
              Width = 63
              Height = 15
              Caption = 'Full Mkt Val'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clMaroon
              Font.Height = -12
              Font.Name = 'Arial'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object Label76: TLabel
              Left = 2
              Top = 117
              Width = 31
              Height = 16
              Caption = 'RAR:'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -13
              Font.Name = 'Arial'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object EditLegalAddrNo: TDBEdit
              Left = 225
              Top = 4
              Width = 73
              Height = 23
              CharCase = ecUpperCase
              Color = clBtnFace
              DataField = 'LegalAddrNo'
              DataSource = SmallClaimsDataSource
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
              Left = 394
              Top = 3
              Width = 153
              Height = 23
              CharCase = ecUpperCase
              Color = clBtnFace
              DataField = 'LegalAddr'
              DataSource = SmallClaimsDataSource
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
              Left = 89
              Top = 31
              Width = 24
              Height = 23
              Color = clBtnFace
              DataField = 'HomesteadCode'
              DataSource = SmallClaimsDataSource
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlue
              Font.Height = -12
              Font.Name = 'Arial'
              Font.Style = [fsBold]
              ParentFont = False
              ReadOnly = True
              TabOrder = 2
            end
            object EditCurrentFullMarketValue: TDBEdit
              Left = 503
              Top = 110
              Width = 89
              Height = 23
              DataField = 'CurrentFullMarketVal'
              DataSource = SmallClaimsDataSource
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlue
              Font.Height = -12
              Font.Name = 'Arial'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 3
            end
            object EditPropertyClassCode: TDBEdit
              Left = 225
              Top = 29
              Width = 42
              Height = 23
              Color = clBtnFace
              DataField = 'PropertyClassCode'
              DataSource = SmallClaimsDataSource
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlue
              Font.Height = -12
              Font.Name = 'Arial'
              Font.Style = [fsBold]
              ParentFont = False
              ReadOnly = True
              TabOrder = 4
            end
            object EditOwnership: TDBEdit
              Left = 89
              Top = 58
              Width = 24
              Height = 23
              Color = clBtnFace
              DataField = 'OwnershipCode'
              DataSource = SmallClaimsDataSource
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlue
              Font.Height = -12
              Font.Name = 'Arial'
              Font.Style = [fsBold]
              ParentFont = False
              ReadOnly = True
              TabOrder = 5
            end
            object EditResidentialPercent: TDBEdit
              Left = 225
              Top = 58
              Width = 44
              Height = 23
              Color = clBtnFace
              DataField = 'ResidentialPercent'
              DataSource = SmallClaimsDataSource
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlue
              Font.Height = -12
              Font.Name = 'Arial'
              Font.Style = [fsBold]
              ParentFont = False
              ReadOnly = True
              TabOrder = 6
            end
            object EditRollSection: TDBEdit
              Left = 89
              Top = 4
              Width = 24
              Height = 23
              Color = clBtnFace
              DataField = 'RollSection'
              DataSource = SmallClaimsDataSource
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlue
              Font.Height = -12
              Font.Name = 'Arial'
              Font.Style = [fsBold]
              ParentFont = False
              ReadOnly = True
              TabOrder = 7
            end
            object EditCurrentTotalValue: TDBEdit
              Left = 406
              Top = 111
              Width = 89
              Height = 23
              DataField = 'CurrentTotalValue'
              DataSource = SmallClaimsDataSource
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlue
              Font.Height = -12
              Font.Name = 'Arial'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 8
            end
            object EditPriorTotalValue: TDBEdit
              Left = 406
              Top = 84
              Width = 89
              Height = 23
              Color = clBtnFace
              DataField = 'PriorTotalValue'
              DataSource = SmallClaimsDataSource
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlue
              Font.Height = -12
              Font.Name = 'Arial'
              Font.Style = [fsBold]
              ParentFont = False
              ReadOnly = True
              TabOrder = 9
            end
            object EditCurrentLandValue: TDBEdit
              Left = 304
              Top = 111
              Width = 89
              Height = 23
              DataField = 'CurrentLandValue'
              DataSource = SmallClaimsDataSource
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlue
              Font.Height = -12
              Font.Name = 'Arial'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 10
            end
            object EditPriorLandValue: TDBEdit
              Left = 304
              Top = 84
              Width = 89
              Height = 23
              Color = clBtnFace
              DataField = 'PriorLandValue'
              DataSource = SmallClaimsDataSource
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlue
              Font.Height = -12
              Font.Name = 'Arial'
              Font.Style = [fsBold]
              ParentFont = False
              ReadOnly = True
              TabOrder = 11
            end
            object EditEqualizationRate: TDBEdit
              Left = 89
              Top = 85
              Width = 46
              Height = 23
              Color = clBtnFace
              DataField = 'CurrentEqRate'
              DataSource = SmallClaimsDataSource
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlue
              Font.Height = -12
              Font.Name = 'Arial'
              Font.Style = [fsBold]
              ParentFont = False
              ReadOnly = True
              TabOrder = 12
            end
            object EditPriorFullMarketValue: TDBEdit
              Left = 503
              Top = 84
              Width = 89
              Height = 23
              Color = clBtnFace
              DataSource = SmallClaimsDataSource
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlue
              Font.Height = -12
              Font.Name = 'Arial'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 13
            end
            object EditRARParcelInfoPage: TDBEdit
              Left = 89
              Top = 113
              Width = 46
              Height = 23
              TabStop = False
              Color = clBtnFace
              DataField = 'CurrentRAR'
              DataSource = SmallClaimsDataSource
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlue
              Font.Height = -12
              Font.Name = 'Arial'
              Font.Style = [fsBold]
              ParentFont = False
              ReadOnly = True
              TabOrder = 14
            end
          end
          object ExemptionsTabSheet: TTabSheet
            Caption = 'Exemptions'
            ImageIndex = 1
            object GrievanceExemptionGrid: TwwDBGrid
              Left = 64
              Top = 5
              Width = 476
              Height = 125
              Selected.Strings = (
                'ExemptionCode'#9'7'#9'EX Code'
                'Amount'#9'15'#9'Amount'
                'Percent'#9'7'#9'Percent'
                'InitialDate'#9'10'#9'Initial~Date'
                'TerminationDate'#9'10'#9'Ending~Date'
                'HomesteadCode'#9'1'#9'HC'
                'OwnerPercent'#9'5'#9'Owner~%')
              IniAttributes.Delimiter = ';;'
              TitleColor = clBtnFace
              FixedCols = 0
              ShowHorzScrollBar = True
              DataSource = SmallClaimsExemptionsDataSource
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -13
              Font.Name = 'Arial'
              Font.Style = [fsBold]
              ParentFont = False
              ReadOnly = True
              TabOrder = 0
              TitleAlignment = taCenter
              TitleFont.Charset = DEFAULT_CHARSET
              TitleFont.Color = clBlue
              TitleFont.Height = -13
              TitleFont.Name = 'Arial'
              TitleFont.Style = [fsBold]
              TitleLines = 2
              TitleButtons = False
              IndicatorColor = icBlack
            end
          end
          object SalesTabSheet: TTabSheet
            Caption = 'Sales'
            ImageIndex = 2
            object SalesGrid: TwwDBGrid
              Left = 6
              Top = 4
              Width = 593
              Height = 128
              Selected.Strings = (
                'SaleNumber'#9'4'#9'Sale~#'
                'SaleDate'#9'10'#9'Sale~Date'
                'SalePrice'#9'8'#9'Sale~Price'
                'OldOwnerName'#9'15'#9'Old Owner'
                'NewOwnerName'#9'15'#9'New Owner'
                'DeedBook'#9'5'#9'Deed~Book'
                'DeedPage'#9'5'#9'Deed~Page'
                'ArmsLength'#9'3'#9'Arms~Length'
                'ValidSale'#9'5'#9'Valid~Sale')
              IniAttributes.Delimiter = ';;'
              TitleColor = clBtnFace
              FixedCols = 0
              ShowHorzScrollBar = True
              DataSource = SmallClaimsSalesDataSource
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -13
              Font.Name = 'Arial'
              Font.Style = [fsBold]
              ParentFont = False
              ReadOnly = True
              TabOrder = 0
              TitleAlignment = taCenter
              TitleFont.Charset = DEFAULT_CHARSET
              TitleFont.Color = clBlue
              TitleFont.Height = -13
              TitleFont.Name = 'Arial'
              TitleFont.Style = [fsBold]
              TitleLines = 2
              TitleButtons = False
              IndicatorColor = icBlack
            end
          end
          object TabSheet5: TTabSheet
            Caption = 'Special Districts'
            ImageIndex = 3
            object SpecialDistrictDBGrid: TwwDBGrid
              Left = 86
              Top = 5
              Width = 433
              Height = 123
              Selected.Strings = (
                'SDistCode'#9'7'#9'SD~Code'
                'PrimaryUnits'#9'6'#9'Primary~Units'
                'SecondaryUnits'#9'7'#9'2nd~Units'
                'SDPercentage'#9'4'#9'SD~%'
                'CalcCode'#9'1'#9'Calc~Code'
                'CalcAmount'#9'11'#9'Calc~Amount'
                'DateAdded'#9'11'#9'Date~Added')
              IniAttributes.Delimiter = ';;'
              TitleColor = clBtnFace
              FixedCols = 0
              ShowHorzScrollBar = True
              DataSource = SmallClaimsSpecialDistrictDataSource
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -13
              Font.Name = 'Arial'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 0
              TitleAlignment = taCenter
              TitleFont.Charset = DEFAULT_CHARSET
              TitleFont.Color = clBlue
              TitleFont.Height = -13
              TitleFont.Name = 'Arial'
              TitleFont.Style = [fsBold]
              TitleLines = 2
              TitleButtons = False
              IndicatorColor = icBlack
            end
          end
        end
      end
      object SmallClaimNotesRichEdit: TwwDBRichEditMSWord
        Left = 335
        Top = 25
        Width = 280
        Height = 131
        Hint = 'Double click to edit the note.'
        AutoURLDetect = False
        DataField = 'Notes'
        DataSource = SmallClaimsDataSource
        PrintJobName = 'Delphi 5'
        TabOrder = 2
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
          830000007B5C727466315C616E73695C616E7369637067313235325C64656666
          305C6465666C616E67313033337B5C666F6E7474626C7B5C66305C666E696C20
          417269616C3B7D7D0D0A5C766965776B696E64345C7563315C706172645C6630
          5C6673323020536D616C6C436C61696D4E6F74657352696368456469745C7061
          720D0A7D0D0A00}
      end
      object EditGrievanceResults: TDBEdit
        Left = 393
        Top = 166
        Width = 221
        Height = 23
        Color = clBtnFace
        DataField = 'GrievanceDecision'
        DataSource = SmallClaimsDataSource
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        ReadOnly = True
        TabOrder = 3
      end
    end
    object PetitionerTabSheet: TTabSheet
      Caption = 'Rep \ Reason'
      ImageIndex = 2
      object PetitionerAskingGroupBox: TGroupBox
        Left = 3
        Top = 220
        Width = 618
        Height = 148
        Caption = ' Complaint Information: '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        object Label48: TLabel
          Left = 7
          Top = 93
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
        object Label49: TLabel
          Left = 7
          Top = 52
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
        object Label52: TLabel
          Left = 7
          Top = 22
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
        object Label53: TLabel
          Left = 212
          Top = 21
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
          Top = 17
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
          Top = 17
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
          Top = 20
          Width = 23
          Height = 17
          DataField = 'PetitSubreasonCode'
          DataSource = SmallClaimsDataSource
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clGreen
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label56: TLabel
          Left = 212
          Top = 46
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
          Top = 56
          Width = 97
          Height = 23
          DataField = 'PetitLandValue'
          DataSource = SmallClaimsDataSource
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
          Top = 98
          Width = 97
          Height = 23
          DataField = 'PetitTotalValue'
          DataSource = SmallClaimsDataSource
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 4
        end
        object ComplaintReasonLookupCombo: TwwDBLookupCombo
          Left = 87
          Top = 18
          Width = 112
          Height = 24
          DropDownAlignment = taLeftJustify
          Selected.Strings = (
            'MainCode'#9'10'#9'Code'#9'F'
            'Description'#9'30'#9'Description'#9'F')
          DataField = 'PetitReason'
          DataSource = SmallClaimsDataSource
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
          Top = 17
          Width = 256
          Height = 24
          AutoURLDetect = False
          DataField = 'PetitSubreason'
          DataSource = SmallClaimsDataSource
          PrintJobName = 'Delphi 5'
          TabOrder = 1
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
            B00000007B5C727466315C616E73695C616E7369637067313235325C64656666
            305C6465666C616E67313033337B5C666F6E7474626C7B5C66305C666E696C20
            417269616C3B7D7D0D0A7B5C636F6C6F7274626C203B5C726564305C67726565
            6E305C626C75653235353B7D0D0A5C766965776B696E64345C7563315C706172
            645C6366315C625C66305C6673323020436F6D706C61696E7453756272656173
            6F6E52696368456469745C7061720D0A7D0D0A00}
        end
        object ComplaintSubreasonButton: TButton
          Left = 548
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
        end
        object AskingExemptionsGrid: TwwDBGrid
          Left = 212
          Top = 66
          Width = 231
          Height = 72
          ControlType.Strings = (
            'ExemptionCode;CustomEdit;ExemptionCodeAskedLookupCombo')
          Selected.Strings = (
            'ExemptionCode'#9'9'#9'Code'#9'F'
            'Amount'#9'13'#9'Amount'#9'F'
            'Percent'#9'4'#9'%'#9'F')
          IniAttributes.Delimiter = ';;'
          TitleColor = clBtnFace
          FixedCols = 0
          ShowHorzScrollBar = True
          DataSource = SmallClaimsExemptionsAskedDataSource
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
          Left = 241
          Top = 99
          Width = 121
          Height = 24
          DropDownAlignment = taLeftJustify
          Selected.Strings = (
            'ExCode'#9'5'#9'Code'#9'F'
            'Description'#9'20'#9'Description'#9'F')
          DataField = 'ExemptionCode'
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
          Left = 459
          Top = 108
          Width = 91
          Height = 25
          Caption = 'Delete EX'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 6
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
          Left = 459
          Top = 68
          Width = 91
          Height = 25
          Caption = 'Add EX'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 5
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
      object PetitionerAndRepresentativeInfoNotebook: TNotebook
        Left = 2
        Top = 0
        Width = 619
        Height = 220
        TabOrder = 1
        object TPage
          Left = 0
          Top = 0
          Caption = 'OldStylePage'
          object GroupBox2: TGroupBox
            Left = 3
            Top = 1
            Width = 297
            Height = 212
            Caption = ' Petitioner: '
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 0
            object Label82: TLabel
              Left = 14
              Top = 24
              Width = 48
              Height = 16
              Caption = 'Name 1'
              FocusControl = EditOldStylePetitName1
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -13
              Font.Name = 'Arial'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object Label88: TLabel
              Left = 14
              Top = 51
              Width = 48
              Height = 16
              Caption = 'Name 2'
              FocusControl = EditOldStylePetitName2
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -13
              Font.Name = 'Arial'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object Label89: TLabel
              Left = 14
              Top = 77
              Width = 41
              Height = 16
              Caption = 'Addr 1'
              FocusControl = EditOldStylePetitAddr1
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -13
              Font.Name = 'Arial'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object Label90: TLabel
              Left = 14
              Top = 104
              Width = 41
              Height = 16
              Caption = 'Addr 2'
              FocusControl = EditOldStylePetitAddr2
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -13
              Font.Name = 'Arial'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object Label91: TLabel
              Left = 14
              Top = 130
              Width = 38
              Height = 16
              Caption = 'Street'
              FocusControl = EditOldStylePetitStreet
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -13
              Font.Name = 'Arial'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object Label92: TLabel
              Left = 14
              Top = 156
              Width = 24
              Height = 16
              Caption = 'City'
              FocusControl = EditOldStylePetitCity
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -13
              Font.Name = 'Arial'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object Label93: TLabel
              Left = 14
              Top = 183
              Width = 33
              Height = 16
              Caption = 'State'
              FocusControl = EditOldStylePetitState
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -13
              Font.Name = 'Arial'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object Label94: TLabel
              Left = 123
              Top = 183
              Width = 19
              Height = 16
              Caption = 'Zip'
              FocusControl = EditOldStylePetitZip
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -13
              Font.Name = 'Arial'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object Label95: TLabel
              Left = 203
              Top = 183
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
            object EditOldStylePetitName1: TDBEdit
              Left = 75
              Top = 21
              Width = 213
              Height = 23
              CharCase = ecUpperCase
              DataField = 'PetitName1'
              DataSource = SmallClaimsDataSource
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clRed
              Font.Height = -12
              Font.Name = 'Arial'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 0
            end
            object EditOldStylePetitName2: TDBEdit
              Left = 75
              Top = 48
              Width = 213
              Height = 23
              DataField = 'PetitName2'
              DataSource = SmallClaimsDataSource
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlue
              Font.Height = -12
              Font.Name = 'Arial'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 1
            end
            object EditOldStylePetitAddr1: TDBEdit
              Left = 75
              Top = 74
              Width = 213
              Height = 23
              DataField = 'PetitAddress1'
              DataSource = SmallClaimsDataSource
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlue
              Font.Height = -12
              Font.Name = 'Arial'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 2
            end
            object EditOldStylePetitAddr2: TDBEdit
              Left = 75
              Top = 101
              Width = 213
              Height = 23
              DataField = 'PetitAddress2'
              DataSource = SmallClaimsDataSource
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlue
              Font.Height = -12
              Font.Name = 'Arial'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 3
            end
            object EditOldStylePetitStreet: TDBEdit
              Left = 75
              Top = 127
              Width = 213
              Height = 23
              DataField = 'PetitStreet'
              DataSource = SmallClaimsDataSource
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlue
              Font.Height = -12
              Font.Name = 'Arial'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 4
            end
            object EditOldStylePetitCity: TDBEdit
              Left = 75
              Top = 153
              Width = 213
              Height = 23
              DataField = 'PetitCity'
              DataSource = SmallClaimsDataSource
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlue
              Font.Height = -12
              Font.Name = 'Arial'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 5
            end
            object EditOldStylePetitState: TDBEdit
              Left = 75
              Top = 180
              Width = 33
              Height = 23
              CharCase = ecUpperCase
              DataField = 'PetitState'
              DataSource = SmallClaimsDataSource
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlue
              Font.Height = -12
              Font.Name = 'Arial'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 6
            end
            object EditOldStylePetitZip: TDBEdit
              Left = 148
              Top = 180
              Width = 50
              Height = 23
              DataField = 'PetitZip'
              DataSource = SmallClaimsDataSource
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlue
              Font.Height = -12
              Font.Name = 'Arial'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 7
            end
            object EditOldStylePetitZipPlus4: TDBEdit
              Left = 214
              Top = 180
              Width = 40
              Height = 23
              DataField = 'PetitZipPlus4'
              DataSource = SmallClaimsDataSource
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlue
              Font.Height = -12
              Font.Name = 'Arial'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 8
            end
          end
          object PetitionerGroupBox: TGroupBox
            Left = 301
            Top = 1
            Width = 318
            Height = 212
            Caption = ' Representative: '
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlue
            Font.Height = -13
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 1
            object Label96: TLabel
              Left = 15
              Top = 24
              Width = 29
              Height = 16
              Caption = 'Firm'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -13
              Font.Name = 'Arial'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object Label97: TLabel
              Left = 16
              Top = 77
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
            object Label98: TLabel
              Left = 16
              Top = 104
              Width = 24
              Height = 16
              Caption = 'Fax'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -13
              Font.Name = 'Arial'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object Label99: TLabel
              Left = 16
              Top = 130
              Width = 39
              Height = 16
              Caption = 'E-Mail'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -13
              Font.Name = 'Arial'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object Label100: TLabel
              Left = 15
              Top = 51
              Width = 53
              Height = 16
              Caption = 'Attorney'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -13
              Font.Name = 'Arial'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object EditOldStyleLawyerLookupCombo: TwwDBLookupCombo
              Left = 76
              Top = 20
              Width = 154
              Height = 24
              DropDownAlignment = taLeftJustify
              Selected.Strings = (
                'Code'#9'10'#9'Code'#9'F'
                'Name1'#9'25'#9'Name'#9'F')
              DataField = 'LawyerCode'
              DataSource = SmallClaimsDataSource
              LookupTable = LawyerCodeTable
              LookupField = 'Code'
              Options = [loColLines, loRowLines, loTitles]
              Style = csDropDownList
              TabOrder = 0
              AutoDropDown = True
              ShowButton = True
              AllowClearKey = False
              OnDropDown = LawyerLookupComboDropDown
              OnCloseUp = LawyerLookupComboCloseUp
            end
            object EditOldStylePetitPhoneNumber: TDBEdit
              Left = 77
              Top = 74
              Width = 154
              Height = 23
              DataField = 'PetitPhoneNumber'
              DataSource = SmallClaimsDataSource
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlue
              Font.Height = -12
              Font.Name = 'Arial'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 2
            end
            object EditOldStylePetitFaxNumber: TDBEdit
              Left = 77
              Top = 101
              Width = 154
              Height = 23
              DataField = 'PetitFaxNumber'
              DataSource = SmallClaimsDataSource
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlue
              Font.Height = -12
              Font.Name = 'Arial'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 3
            end
            object EditOldStylePetitEmail: TDBEdit
              Left = 77
              Top = 127
              Width = 235
              Height = 23
              DataField = 'PetitEmail'
              DataSource = SmallClaimsDataSource
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlue
              Font.Height = -12
              Font.Name = 'Arial'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 4
            end
            object EditOldStylePetitAttorneyName: TDBEdit
              Left = 76
              Top = 48
              Width = 154
              Height = 23
              DataField = 'PetitAttorneyName'
              DataSource = SmallClaimsDataSource
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlue
              Font.Height = -12
              Font.Name = 'Arial'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 1
            end
          end
        end
        object TPage
          Left = 0
          Top = 0
          Caption = 'ExtendedRepInfoPage'
          object ExtendedRepInfoPageControl: TPageControl
            Left = 0
            Top = 0
            Width = 619
            Height = 220
            ActivePage = PetitionerNameAddressTabSheet
            Align = alClient
            TabOrder = 0
            object PetitionerNameAddressTabSheet: TTabSheet
              Caption = 'Petitioner Name \ Addr'
              object Label8: TLabel
                Left = 332
                Top = 16
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
                Left = 445
                Top = 16
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
                Left = 525
                Top = 16
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
              object Label1: TLabel
                Left = 14
                Top = 16
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
                Left = 14
                Top = 44
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
                Left = 14
                Top = 71
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
                Left = 14
                Top = 99
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
                Left = 14
                Top = 126
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
                Left = 14
                Top = 154
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
              object Label11: TLabel
                Left = 332
                Top = 44
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
              object EditPetitionerState: TDBEdit
                Left = 397
                Top = 13
                Width = 33
                Height = 23
                CharCase = ecUpperCase
                DataField = 'PetitState'
                DataSource = SmallClaimsDataSource
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clBlue
                Font.Height = -12
                Font.Name = 'Arial'
                Font.Style = [fsBold]
                ParentFont = False
                TabOrder = 6
              end
              object EditPetitionerZip: TDBEdit
                Left = 470
                Top = 13
                Width = 50
                Height = 23
                DataField = 'PetitZip'
                DataSource = SmallClaimsDataSource
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clBlue
                Font.Height = -12
                Font.Name = 'Arial'
                Font.Style = [fsBold]
                ParentFont = False
                TabOrder = 7
              end
              object EditPetitionerZipPlus4: TDBEdit
                Left = 536
                Top = 13
                Width = 40
                Height = 23
                DataField = 'PetitZipPlus4'
                DataSource = SmallClaimsDataSource
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clBlue
                Font.Height = -12
                Font.Name = 'Arial'
                Font.Style = [fsBold]
                ParentFont = False
                TabOrder = 8
              end
              object EditPetitionerName1: TDBEdit
                Left = 75
                Top = 13
                Width = 213
                Height = 23
                CharCase = ecUpperCase
                DataField = 'PetitName1'
                DataSource = SmallClaimsDataSource
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clRed
                Font.Height = -12
                Font.Name = 'Arial'
                Font.Style = [fsBold]
                ParentFont = False
                TabOrder = 0
              end
              object EditPetitionerName2: TDBEdit
                Left = 75
                Top = 41
                Width = 213
                Height = 23
                DataField = 'PetitName2'
                DataSource = SmallClaimsDataSource
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clBlue
                Font.Height = -12
                Font.Name = 'Arial'
                Font.Style = [fsBold]
                ParentFont = False
                TabOrder = 1
              end
              object EditPetitionerAddress1: TDBEdit
                Left = 75
                Top = 68
                Width = 213
                Height = 23
                DataField = 'PetitAddress1'
                DataSource = SmallClaimsDataSource
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clBlue
                Font.Height = -12
                Font.Name = 'Arial'
                Font.Style = [fsBold]
                ParentFont = False
                TabOrder = 2
              end
              object EditPetitionerAddress2: TDBEdit
                Left = 75
                Top = 96
                Width = 213
                Height = 23
                DataField = 'PetitAddress2'
                DataSource = SmallClaimsDataSource
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clBlue
                Font.Height = -12
                Font.Name = 'Arial'
                Font.Style = [fsBold]
                ParentFont = False
                TabOrder = 3
              end
              object EditPetitionerStreet: TDBEdit
                Left = 75
                Top = 123
                Width = 213
                Height = 23
                DataField = 'PetitStreet'
                DataSource = SmallClaimsDataSource
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clBlue
                Font.Height = -12
                Font.Name = 'Arial'
                Font.Style = [fsBold]
                ParentFont = False
                TabOrder = 4
              end
              object EditPetitionerCity: TDBEdit
                Left = 75
                Top = 151
                Width = 213
                Height = 23
                DataField = 'PetitCity'
                DataSource = SmallClaimsDataSource
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clBlue
                Font.Height = -12
                Font.Name = 'Arial'
                Font.Style = [fsBold]
                ParentFont = False
                TabOrder = 5
              end
              object EditPetitionerPhone: TDBEdit
                Left = 397
                Top = 41
                Width = 154
                Height = 23
                DataField = 'PetitPhoneNumber'
                DataSource = SmallClaimsDataSource
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
              object Label3: TLabel
                Left = 14
                Top = 71
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
              object Label45: TLabel
                Left = 14
                Top = 99
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
              object Label46: TLabel
                Left = 14
                Top = 126
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
              object Label47: TLabel
                Left = 14
                Top = 154
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
              object Label77: TLabel
                Left = 305
                Top = 17
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
              object Label78: TLabel
                Left = 305
                Top = 44
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
              object Label79: TLabel
                Left = 305
                Top = 72
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
              object Label80: TLabel
                Left = 415
                Top = 72
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
              object Label81: TLabel
                Left = 495
                Top = 72
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
              object Label83: TLabel
                Left = 305
                Top = 99
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
              object Label84: TLabel
                Left = 14
                Top = 16
                Width = 29
                Height = 16
                Caption = 'Firm'
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clBlack
                Font.Height = -13
                Font.Name = 'Arial'
                Font.Style = [fsBold]
                ParentFont = False
              end
              object Label85: TLabel
                Left = 14
                Top = 44
                Width = 53
                Height = 16
                Caption = 'Attorney'
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clBlack
                Font.Height = -13
                Font.Name = 'Arial'
                Font.Style = [fsBold]
                ParentFont = False
              end
              object Label86: TLabel
                Left = 305
                Top = 127
                Width = 24
                Height = 16
                Caption = 'Fax'
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clBlack
                Font.Height = -13
                Font.Name = 'Arial'
                Font.Style = [fsBold]
                ParentFont = False
              end
              object Label87: TLabel
                Left = 305
                Top = 154
                Width = 39
                Height = 16
                Caption = 'E-Mail'
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clBlack
                Font.Height = -13
                Font.Name = 'Arial'
                Font.Style = [fsBold]
                ParentFont = False
              end
              object EditAttorneyName1: TDBEdit
                Left = 75
                Top = 68
                Width = 213
                Height = 23
                CharCase = ecUpperCase
                DataField = 'AttyName1'
                DataSource = SmallClaimsDataSource
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clRed
                Font.Height = -12
                Font.Name = 'Arial'
                Font.Style = [fsBold]
                ParentFont = False
                TabOrder = 1
              end
              object EditAttorneyName2: TDBEdit
                Left = 75
                Top = 95
                Width = 213
                Height = 23
                DataField = 'AttyName2'
                DataSource = SmallClaimsDataSource
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clBlue
                Font.Height = -12
                Font.Name = 'Arial'
                Font.Style = [fsBold]
                ParentFont = False
                TabOrder = 2
              end
              object EditAttorneyAddress1: TDBEdit
                Left = 75
                Top = 123
                Width = 213
                Height = 23
                DataField = 'AttyAddress1'
                DataSource = SmallClaimsDataSource
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clBlue
                Font.Height = -12
                Font.Name = 'Arial'
                Font.Style = [fsBold]
                ParentFont = False
                TabOrder = 3
              end
              object EditAttorneyAddress2: TDBEdit
                Left = 75
                Top = 151
                Width = 213
                Height = 23
                DataField = 'AttyAddress2'
                DataSource = SmallClaimsDataSource
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clBlue
                Font.Height = -12
                Font.Name = 'Arial'
                Font.Style = [fsBold]
                ParentFont = False
                TabOrder = 4
              end
              object EditAttorneyStreet: TDBEdit
                Left = 372
                Top = 14
                Width = 213
                Height = 23
                DataField = 'AttyStreet'
                DataSource = SmallClaimsDataSource
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clBlue
                Font.Height = -12
                Font.Name = 'Arial'
                Font.Style = [fsBold]
                ParentFont = False
                TabOrder = 5
              end
              object EditAttorneyCity: TDBEdit
                Left = 372
                Top = 41
                Width = 213
                Height = 23
                DataField = 'AttyCity'
                DataSource = SmallClaimsDataSource
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clBlue
                Font.Height = -12
                Font.Name = 'Arial'
                Font.Style = [fsBold]
                ParentFont = False
                TabOrder = 6
              end
              object EditAttorneyState: TDBEdit
                Left = 372
                Top = 69
                Width = 33
                Height = 23
                CharCase = ecUpperCase
                DataField = 'AttyState'
                DataSource = SmallClaimsDataSource
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clBlue
                Font.Height = -12
                Font.Name = 'Arial'
                Font.Style = [fsBold]
                ParentFont = False
                TabOrder = 7
              end
              object EditAttorneyZip: TDBEdit
                Left = 440
                Top = 69
                Width = 50
                Height = 23
                DataField = 'AttyZip'
                DataSource = SmallClaimsDataSource
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clBlue
                Font.Height = -12
                Font.Name = 'Arial'
                Font.Style = [fsBold]
                ParentFont = False
                TabOrder = 8
              end
              object EditAttorneyZipPlus4: TDBEdit
                Left = 506
                Top = 69
                Width = 40
                Height = 23
                DataField = 'AttyZipPlus4'
                DataSource = SmallClaimsDataSource
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clBlue
                Font.Height = -12
                Font.Name = 'Arial'
                Font.Style = [fsBold]
                ParentFont = False
                TabOrder = 9
              end
              object EditAttorneyPhone: TDBEdit
                Left = 372
                Top = 96
                Width = 154
                Height = 23
                DataField = 'AttyPhoneNumber'
                DataSource = SmallClaimsDataSource
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clBlue
                Font.Height = -12
                Font.Name = 'Arial'
                Font.Style = [fsBold]
                ParentFont = False
                TabOrder = 10
              end
              object LawyerLookupCombo: TwwDBLookupCombo
                Left = 75
                Top = 13
                Width = 154
                Height = 24
                DropDownAlignment = taLeftJustify
                Selected.Strings = (
                  'Code'#9'10'#9'Code'#9'F'
                  'Name1'#9'25'#9'Name'#9'F')
                DataField = 'LawyerCode'
                DataSource = SmallClaimsDataSource
                LookupTable = LawyerCodeTable
                LookupField = 'Code'
                Options = [loColLines, loRowLines, loTitles]
                Style = csDropDownList
                TabOrder = 0
                AutoDropDown = True
                ShowButton = True
                AllowClearKey = False
                OnDropDown = LawyerLookupComboDropDown
                OnCloseUp = LawyerLookupComboCloseUp
              end
              object EditAttorney: TDBEdit
                Left = 75
                Top = 40
                Width = 154
                Height = 23
                DataField = 'PetitAttorneyName'
                DataSource = SmallClaimsDataSource
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clBlue
                Font.Height = -12
                Font.Name = 'Arial'
                Font.Style = [fsBold]
                ParentFont = False
                TabOrder = 11
              end
              object EditFaxNumber: TDBEdit
                Left = 372
                Top = 124
                Width = 154
                Height = 23
                DataField = 'PetitFaxNumber'
                DataSource = SmallClaimsDataSource
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clBlue
                Font.Height = -12
                Font.Name = 'Arial'
                Font.Style = [fsBold]
                ParentFont = False
                TabOrder = 12
              end
              object EditEMailAddress: TDBEdit
                Left = 372
                Top = 151
                Width = 235
                Height = 23
                DataField = 'PetitEmail'
                DataSource = SmallClaimsDataSource
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clBlue
                Font.Height = -12
                Font.Name = 'Arial'
                Font.Style = [fsBold]
                ParentFont = False
                TabOrder = 13
              end
            end
          end
        end
      end
    end
    object SmallClaimInfoTabSheet: TTabSheet
      Caption = 'Small Claim Info'
      ImageIndex = 4
      object SmallClaimGroupBox: TGroupBox
        Left = 4
        Top = 1
        Width = 616
        Height = 116
        Caption = ' Small Claim Information: '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        object Label33: TLabel
          Left = 183
          Top = 16
          Width = 63
          Height = 36
          AutoSize = False
          Caption = 'Notice of Petition'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          WordWrap = True
        end
        object Label34: TLabel
          Left = 183
          Top = 50
          Width = 63
          Height = 36
          AutoSize = False
          Caption = 'Notice of Issue'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          WordWrap = True
        end
        object Label35: TLabel
          Left = 8
          Top = 16
          Width = 63
          Height = 36
          AutoSize = False
          Caption = 'Number of Parcels'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          WordWrap = True
        end
        object Label36: TLabel
          Left = 370
          Top = 26
          Width = 71
          Height = 16
          Caption = 'Town Audit'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object EditNoticeOfPetition: TDBEdit
          Left = 262
          Top = 22
          Width = 87
          Height = 24
          DataField = 'NoticeOfPetition'
          DataSource = SmallClaimsDataSource
          TabOrder = 1
        end
        object EditNoticeOfIssue: TDBEdit
          Left = 262
          Top = 56
          Width = 87
          Height = 24
          DataField = 'NoteOfIssue'
          DataSource = SmallClaimsDataSource
          TabOrder = 2
        end
        object EditNumberOfParcels: TDBEdit
          Left = 87
          Top = 22
          Width = 31
          Height = 24
          DataField = 'NumberOfParcels'
          DataSource = SmallClaimsDataSource
          TabOrder = 0
        end
        object EditTownAudit: TDBEdit
          Left = 449
          Top = 22
          Width = 87
          Height = 24
          DataField = 'NoteOfIssue'
          DataSource = SmallClaimsDataSource
          TabOrder = 3
        end
      end
      object ResultsGroupBox: TGroupBox
        Left = 10
        Top = 116
        Width = 602
        Height = 262
        Caption = ' Results: '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGreen
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 1
        object Label37: TLabel
          Left = 13
          Top = 25
          Width = 39
          Height = 16
          Caption = 'Result'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label38: TLabel
          Left = 13
          Top = 59
          Width = 29
          Height = 16
          Caption = 'Date'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label39: TLabel
          Left = 12
          Top = 86
          Width = 85
          Height = 30
          AutoSize = False
          Caption = 'Resolution Number'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          WordWrap = True
        end
        object Label41: TLabel
          Left = 207
          Top = 16
          Width = 74
          Height = 34
          AutoSize = False
          Caption = 'Granted Land Val'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          WordWrap = True
        end
        object Label40: TLabel
          Left = 422
          Top = 18
          Width = 80
          Height = 31
          AutoSize = False
          Caption = 'Post Trial Memo Filed'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          WordWrap = True
        end
        object Label42: TLabel
          Left = 422
          Top = 59
          Width = 72
          Height = 16
          Caption = 'Final Order'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label43: TLabel
          Left = 207
          Top = 84
          Width = 74
          Height = 34
          AutoSize = False
          Caption = 'Granted EX Code'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          WordWrap = True
        end
        object Label44: TLabel
          Left = 207
          Top = 118
          Width = 74
          Height = 34
          AutoSize = False
          Caption = 'Granted EX Amt \ Pct'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          WordWrap = True
        end
        object Label50: TLabel
          Left = 372
          Top = 124
          Width = 5
          Height = 22
          Caption = '\'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -19
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label73: TLabel
          Left = 207
          Top = 50
          Width = 74
          Height = 34
          AutoSize = False
          Caption = 'Granted Total Val'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          WordWrap = True
        end
        object Label74: TLabel
          Left = 12
          Top = 136
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
        object ResultTypeLookupCombo: TwwDBLookupCombo
          Left = 64
          Top = 21
          Width = 128
          Height = 24
          DropDownAlignment = taLeftJustify
          DataField = 'Disposition'
          DataSource = SmallClaimsDataSource
          LookupTable = DispositionCodeTable
          LookupField = 'Code'
          Options = [loColLines, loRowLines]
          Style = csDropDownList
          TabOrder = 0
          AutoDropDown = True
          ShowButton = True
          AllowClearKey = False
          OnCloseUp = ResultTypeLookupComboCloseUp
        end
        object EditResultDate: TDBEdit
          Left = 83
          Top = 55
          Width = 109
          Height = 24
          DataField = 'DispositionDate'
          DataSource = SmallClaimsDataSource
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 1
        end
        object EditResolutionNumber: TDBEdit
          Left = 83
          Top = 89
          Width = 109
          Height = 24
          DataField = 'ResolutionNumber'
          DataSource = SmallClaimsDataSource
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 2
        end
        object EditGrantedLandAmount: TDBEdit
          Left = 288
          Top = 21
          Width = 115
          Height = 24
          DataField = 'GrantedLandValue'
          DataSource = SmallClaimsDataSource
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 4
        end
        object EditPostTrialMemoDate: TDBEdit
          Left = 503
          Top = 21
          Width = 85
          Height = 24
          DataField = 'PostTrialMemo'
          DataSource = SmallClaimsDataSource
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 9
        end
        object EditFinalOrderDate: TDBEdit
          Left = 503
          Top = 55
          Width = 85
          Height = 24
          DataField = 'FinalOrderDate'
          DataSource = SmallClaimsDataSource
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 10
        end
        object EditGrantedEXCode: TDBEdit
          Left = 288
          Top = 89
          Width = 59
          Height = 24
          DataField = 'GrantedEXCode'
          DataSource = SmallClaimsDataSource
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 6
        end
        object EditGrantedEXAmount: TDBEdit
          Left = 288
          Top = 124
          Width = 78
          Height = 24
          DataField = 'GrantedEXAmount'
          DataSource = SmallClaimsDataSource
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 7
        end
        object EditGrantedEXPercent: TDBEdit
          Left = 383
          Top = 123
          Width = 31
          Height = 24
          DataField = 'GrantedEXPercent'
          DataSource = SmallClaimsDataSource
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 8
        end
        object EditGrantedTotalAssessment: TDBEdit
          Left = 288
          Top = 55
          Width = 115
          Height = 24
          DataField = 'GrantedTotalValue'
          DataSource = SmallClaimsDataSource
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 5
        end
        object ResultsNotesMemo: TwwDBRichEditMSWord
          Left = 12
          Top = 158
          Width = 576
          Height = 96
          AutoURLDetect = False
          DataField = 'ResultsReason'
          DataSource = SmallClaimsDataSource
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          PrintJobName = 'Delphi 5'
          TabOrder = 3
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
            A60000007B5C727466315C616E73695C616E7369637067313235325C64656666
            305C6465666C616E67313033337B5C666F6E7474626C7B5C66305C666E696C20
            417269616C3B7D7D0D0A7B5C636F6C6F7274626C203B5C726564305C67726565
            6E305C626C75653235353B7D0D0A5C766965776B696E64345C7563315C706172
            645C6366315C625C66305C6673323020526573756C74734E6F7465734D656D6F
            5C7061720D0A7D0D0A00}
        end
      end
    end
    object AppraisalTabSheet: TTabSheet
      Caption = 'Appraisals'
      ImageIndex = 6
      object AppraisalGroupBox: TGroupBox
        Left = 2
        Top = 1
        Width = 620
        Height = 366
        Caption = ' Appraisals: '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        object AppraisalGrid: TwwDBGrid
          Left = 7
          Top = 20
          Width = 606
          Height = 293
          Selected.Strings = (
            'DateAuthorized'#9'10'#9'Date~Ordered'#9'F'
            'AppraisalType'#9'10'#9'Appraisal~Type'#9'F'
            'Appraiser'#9'10'#9'Appraiser'#9'F'
            'Appraisal'#9'10'#9'Appraised~Value'#9'F'
            'DateReceived'#9'10'#9'Date~Received'#9'F'
            'DatePaid'#9'10'#9'Date~Paid'#9'F'
            'AmountPaid'#9'8'#9'Amount~Paid'#9'F'
            'Notes'#9'8'#9'Notes'#9'F')
          MemoAttributes = [mSizeable, mWordWrap, mGridShow]
          IniAttributes.Delimiter = ';;'
          TitleColor = clBtnFace
          FixedCols = 0
          ShowHorzScrollBar = True
          EditControlOptions = [ecoSearchOwnerForm, ecoDisableDateTimePicker]
          DataSource = AppraisalDataSource
          Options = [dgEditing, dgAlwaysShowEditor, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit, dgWordWrap]
          TabOrder = 0
          TitleAlignment = taCenter
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clBlue
          TitleFont.Height = -13
          TitleFont.Name = 'Arial'
          TitleFont.Style = [fsBold]
          TitleLines = 2
          TitleButtons = False
          IndicatorColor = icBlack
        end
        object NewAppraisalButton: TBitBtn
          Left = 8
          Top = 325
          Width = 149
          Height = 30
          Caption = 'New Appraisal'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          OnClick = NewAppraisalButtonClick
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
        object RemoveAppraisalButton: TBitBtn
          Left = 229
          Top = 325
          Width = 149
          Height = 30
          Caption = 'Remove Appraisal'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
          OnClick = RemoveAppraisalButtonClick
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
        end
        object AppraiserLookupCombo: TwwDBLookupCombo
          Left = 128
          Top = 89
          Width = 121
          Height = 24
          DropDownAlignment = taLeftJustify
          DataField = 'Appraiser'
          DataSource = AppraisalDataSource
          LookupTable = AppraiserCodeTable
          LookupField = 'MainCode'
          Options = [loColLines, loRowLines]
          TabOrder = 3
          AutoDropDown = True
          ShowButton = True
          AllowClearKey = False
        end
      end
    end
    object CalenderTabSheet: TTabSheet
      Caption = 'Calender'
      ImageIndex = 3
      object ConferenceGroupBox: TGroupBox
        Left = 2
        Top = 1
        Width = 620
        Height = 358
        Caption = ' Calender: '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        object CalenderGrid: TwwDBGrid
          Left = 8
          Top = 18
          Width = 603
          Height = 291
          Selected.Strings = (
            'MeetingType'#9'4'#9'Type'#9'F'
            'Date'#9'10'#9'Date'#9'F'
            'JudgeCode'#9'10'#9'Judge'#9'F'
            'Location'#9'15'#9'Location'#9'F'
            'MunicipalProposal'#9'10'#9'Municipal~Proposal'#9'F'
            'PetitionerProposal'#9'10'#9'Petitioner~Proposal'#9'F'
            'Notes'#9'17'#9'Notes'#9'F')
          MemoAttributes = [mSizeable, mWordWrap, mGridShow]
          IniAttributes.Delimiter = ';;'
          TitleColor = clBtnFace
          FixedCols = 0
          ShowHorzScrollBar = True
          EditControlOptions = [ecoSearchOwnerForm, ecoDisableDateTimePicker]
          DataSource = CalenderDataSource
          Options = [dgEditing, dgAlwaysShowEditor, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit, dgWordWrap]
          TabOrder = 0
          TitleAlignment = taCenter
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clBlue
          TitleFont.Height = -13
          TitleFont.Name = 'Arial'
          TitleFont.Style = [fsBold]
          TitleLines = 2
          TitleButtons = False
          IndicatorColor = icBlack
        end
        object NewCalenderButton: TBitBtn
          Left = 10
          Top = 319
          Width = 149
          Height = 30
          Caption = 'New Calender Item'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          OnClick = NewCalenderButtonClick
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
        object RemoveCalenderButton: TBitBtn
          Left = 231
          Top = 319
          Width = 159
          Height = 30
          Caption = 'Remove Calender Item'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
          OnClick = RemoveCalenderButtonClick
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
        end
        object CalenderItemComboBox: TwwDBComboBox
          Left = 27
          Top = 85
          Width = 121
          Height = 24
          ShowButton = True
          Style = csDropDownList
          MapList = False
          AllowClearKey = False
          AutoDropDown = True
          ShowMatchText = True
          DataField = 'MeetingType'
          DataSource = CalenderDataSource
          DropDownCount = 8
          DropDownWidth = 100
          ItemHeight = 0
          Items.Strings = (
            'Conference'#9'C'
            'Pretrial'#9'P'
            'Trial'#9'T')
          Sorted = False
          TabOrder = 3
          UnboundDataType = wwDefault
        end
        object JudgeCodeLookupCombo: TwwDBLookupCombo
          Left = 252
          Top = 96
          Width = 121
          Height = 24
          DropDownAlignment = taLeftJustify
          Selected.Strings = (
            'MainCode'#9'10'#9'MainCode'#9'F'
            'Description'#9'30'#9'Description'#9'F')
          DataField = 'JudgeCode'
          DataSource = CalenderDataSource
          LookupTable = JudgeCodeTable
          LookupField = 'MainCode'
          Options = [loColLines, loRowLines]
          TabOrder = 4
          AutoDropDown = False
          ShowButton = True
          AllowClearKey = False
        end
      end
    end
    object DocumentTabSheet: TTabSheet
      Caption = 'Documents'
      ImageIndex = 6
      object MainPanel: TPanel
        Left = 0
        Top = -1
        Width = 623
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
          IndicatorColor = icBlack
        end
        object FullScreenButton: TBitBtn
          Left = 221
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
        object Notebook: TNotebook
          Left = 3
          Top = 138
          Width = 614
          Height = 198
          TabOrder = 2
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
            Caption = 'PDF'
            object Label75: TLabel
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
            object Label101: TLabel
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
          TabOrder = 3
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
          TabOrder = 4
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
      end
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 411
    Width = 631
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
    object BroadcastButton: TBitBtn
      Left = 212
      Top = 4
      Width = 89
      Height = 30
      Hint = 'Copy this same certiorari to other parcels.'
      Caption = '&Copy'
      TabOrder = 3
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000120B0000120B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF003FF0000000F0
        000033F77777773777773FFF0CCC0FF09990333F73F37337F33733FFF0C0FFF0
        99903333F7373337F337333FFF0FFFF0999033333F73FFF7FFF73333FFF000F0
        0000333333F77737777733333F07B70FFFFF3333337F337F33333333330BBB0F
        FFFF3333337F337F333333333307B70FFFFF33333373FF733F333333333000FF
        0FFF3333333777337FF3333333333FF000FF33FFFFF3333777FF300000333300
        000F377777F33377777F30EEE0333000000037F337F33777777730EEE0333330
        00FF37F337F3333777F330EEE033333000FF37FFF7F3333777F3300000333330
        00FF3777773333F77733333333333000033F3333333337777333}
      NumGlyphs = 2
    end
    object PrintButton: TBitBtn
      Left = 107
      Top = 4
      Width = 89
      Height = 30
      Caption = '&Print'
      TabOrder = 4
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
  end
  object SmallClaimsTable: TwwTable
    BeforeEdit = SmallClaimsTableBeforeEdit
    AfterEdit = SmallClaimsTableAfterEdit
    BeforePost = SmallClaimsTableBeforePost
    AfterPost = SmallClaimsTableAfterPost
    DatabaseName = 'PASsystem'
    IndexName = 'BYTAXROLLYR_SWISSBLKEY_INDEXNUM'
    TableName = 'gsmallclaimstable'
    TableType = ttDBase
    SyncSQLByRange = False
    NarrowSearch = False
    ValidateWithMask = True
    Left = 18
    Top = 396
  end
  object SmallClaimsDataSource: TwwDataSource
    DataSet = SmallClaimsTable
    Left = 48
    Top = 400
  end
  object CalenderTable: TwwTable
    OnNewRecord = CalenderTableNewRecord
    DatabaseName = 'PASsystem'
    IndexName = 'BYYEAR_SWISSBL_INDEXNUM_DATE'
    TableName = 'gsccalender'
    TableType = ttDBase
    ControlType.Strings = (
      'MeetingType;CustomEdit;CalenderItemComboBox'
      'JudgeCode;CustomEdit;JudgeCodeLookupCombo')
    SyncSQLByRange = False
    NarrowSearch = False
    ValidateWithMask = True
    Left = 151
    Top = 277
  end
  object CalenderDataSource: TwwDataSource
    DataSet = CalenderTable
    Left = 155
    Top = 411
  end
  object AppraisalTable: TwwTable
    OnNewRecord = AppraisalTableNewRecord
    DatabaseName = 'PASsystem'
    IndexName = 'BYYEAR_SWISSBL_INDEXNUM_DATE'
    TableName = 'gscappraisals'
    TableType = ttDBase
    ControlType.Strings = (
      'Appraiser;CustomEdit;AppraiserLookupCombo')
    SyncSQLByRange = False
    NarrowSearch = False
    ValidateWithMask = True
    Left = 391
    Top = 404
  end
  object AppraisalDataSource: TwwDataSource
    DataSet = AppraisalTable
    Left = 435
    Top = 413
  end
  object JudgeCodeTable: TwwTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYMAINCODE'
    TableName = 'zgcjudgetable'
    TableType = ttDBase
    SyncSQLByRange = False
    NarrowSearch = False
    ValidateWithMask = True
    Left = 301
    Top = 400
  end
  object PrintDialog: TPrintDialog
    Options = [poPrintToFile]
    Left = 473
    Top = 94
  end
  object AppraiserCodeTable: TwwTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYMAINCODE'
    TableName = 'zgcappraisertable'
    TableType = ttDBase
    SyncSQLByRange = False
    NarrowSearch = False
    ValidateWithMask = True
    Left = 518
    Top = 407
  end
  object SmallClaimsExemptionTable: TwwTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYYEAR_SWISSBL_INDEXNUM_EXCODE'
    ReadOnly = True
    TableName = 'gscexemptionrec'
    TableType = ttDBase
    SyncSQLByRange = False
    NarrowSearch = False
    ValidateWithMask = True
    Left = 211
    Top = 390
  end
  object SmallClaimsExemptionsDataSource: TwwDataSource
    DataSet = SmallClaimsExemptionTable
    Left = 256
    Top = 394
  end
  object SmallClaimsSalesTable: TwwTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYSWISSBL_INDEXNUM_SALENUM'
    ReadOnly = True
    TableName = 'gscpsalesrec'
    TableType = ttDBase
    ControlType.Strings = (
      'ArmsLength;CheckBox;True;False'
      'ValidSale;CheckBox;True;False')
    SyncSQLByRange = False
    NarrowSearch = False
    ValidateWithMask = True
    Left = 195
    Top = 118
  end
  object SmallClaimsSalesDataSource: TwwDataSource
    DataSet = SmallClaimsSalesTable
    Left = 226
    Top = 154
  end
  object SmallClaimsSpecialDistrictTable: TwwTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYYEAR_SWISSBL_INDEXNUM_SD'
    ReadOnly = True
    TableName = 'gscspcldistrec'
    TableType = ttDBase
    SyncSQLByRange = False
    NarrowSearch = False
    ValidateWithMask = True
    Left = 409
    Top = 104
  end
  object SmallClaimsSpecialDistrictDataSource: TwwDataSource
    DataSet = SmallClaimsSpecialDistrictTable
    Left = 484
    Top = 58
  end
  object SetFocusOnPageTimer: TTimer
    Enabled = False
    Interval = 100
    OnTimer = SetFocusOnPageTimerTimer
    Left = 293
    Top = 50
  end
  object SmallClaimsExemptionsAskedTable: TTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYYEAR_SBL_INDEXNUM_EX'
    TableName = 'gscexemptionsasked'
    TableType = ttDBase
    Left = 483
    Top = 369
  end
  object PropertyClassCodeTable: TTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYMAINCODE'
    TableName = 'zpropclstbl'
    TableType = ttDBase
    Left = 420
    Top = 362
  end
  object SmallClaimsExemptionsAskedDataSource: TwwDataSource
    DataSet = SmallClaimsExemptionsAskedTable
    Left = 523
    Top = 377
  end
  object DispositionCodeTable: TwwTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYCODE'
    TableName = 'zgcdispositioncode'
    TableType = ttDBase
    SyncSQLByRange = False
    NarrowSearch = False
    ValidateWithMask = True
    Left = 544
    Top = 10
  end
  object GrievanceComplaintReasonTable: TwwTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYMAINCODE'
    TableName = 'ZGReasonCategoryCodes'
    TableType = ttDBase
    SyncSQLByRange = False
    NarrowSearch = False
    ValidateWithMask = True
    Left = 346
    Top = 89
  end
  object GrievanceComplaintSubreasonTable: TwwTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYCODE'
    TableName = 'zgsubreasoncodes'
    TableType = ttDBase
    SyncSQLByRange = False
    NarrowSearch = False
    ValidateWithMask = True
    Left = 520
    Top = 65535
  end
  object SwisCodeTable: TTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYSWISCODE'
    TableName = 'tswistbl'
    TableType = ttDBase
    Left = 578
    Top = 370
  end
  object LawyerCodeTable: TTable
    DatabaseName = 'PASsystem'
    IndexFieldNames = 'Code'
    TableName = 'ZGLawyerCodes'
    TableType = ttDBase
    Left = 23
    Top = 89
  end
  object ReportPrinter: TReportPrinter
    StatusFormat = 'Printing page %p'
    UnitsFactor = 1
    Title = 'Parcel Information Print'
    Orientation = poPortrait
    ScaleX = 100
    ScaleY = 100
    Left = 12
    Top = 47
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
    Top = 118
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
  object OLEItemNameTimer: TTimer
    Enabled = False
    OnTimer = OLEItemNameTimerTimer
    Left = 548
    Top = 176
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
  object DocumentDialog: TOpenDialog
    DefaultExt = 'doc'
    Filter = 'MS Word documents|*.doc|All Files|*.*'
    Left = 425
    Top = 312
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
  object DocumentLookupTable: TTable
    AutoCalcFields = False
    DatabaseName = 'PASsystem'
    IndexName = 'BYYEAR_SWISSBL_INDEXNUM_DOCNUM'
    TableName = 'gscdocumentrec'
    TableType = ttDBase
    Left = 369
    Top = 183
  end
  object DocumentTable: TTable
    AfterInsert = DocumentTableAfterInsert
    AfterScroll = DocumentTableAfterScroll
    OnNewRecord = DocumentTableNewRecord
    DatabaseName = 'PASsystem'
    IndexName = 'BYYEAR_SWISSBL_INDEXNUM_DOCNUM'
    TableName = 'gscdocumentrec'
    TableType = ttDBase
    Left = 317
    Top = 284
  end
  object DocumentDataSource: TDataSource
    DataSet = DocumentTable
    Left = 136
    Top = 206
  end
  object tbParcels: TTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYTAXROLLYR_SWISSBLKEY'
    TableName = 'TParcelRec'
    TableType = ttDBase
    Left = 309
    Top = 160
  end
  object OpenPDFDialog: TOpenDialog
    DefaultExt = 'pdf'
    Filter = 'PDF Files|*.pdf|All Files|*.*'
    Left = 444
    Top = 167
  end
end
