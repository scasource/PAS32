object MapParcelInfoForm: TMapParcelInfoForm
  Left = 19
  Top = 244
  Width = 246
  Height = 378
  HorzScrollBar.Visible = False
  BorderIcons = [biSystemMenu]
  BorderWidth = 1
  Color = clInfoBk
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object InformationPageControl: TPageControl
    Left = 0
    Top = 0
    Width = 228
    Height = 163
    ActivePage = DemographicsTabSheet
    Align = alTop
    TabOrder = 0
    object DemographicsTabSheet: TTabSheet
      BorderWidth = 2
      Caption = 'Demog'
      object NameAddrLabel1: TLabel
        Left = 1
        Top = -1
        Width = 82
        Height = 13
        Caption = 'NameAddrLabel1'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object NameAddrLabel2: TLabel
        Left = 1
        Top = 12
        Width = 82
        Height = 13
        Caption = 'NameAddrLabel2'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object NameAddrLabel3: TLabel
        Left = 1
        Top = 26
        Width = 82
        Height = 13
        Caption = 'NameAddrLabel3'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object NameAddrLabel4: TLabel
        Left = 1
        Top = 39
        Width = 82
        Height = 13
        Caption = 'NameAddrLabel4'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object NameAddrLabel5: TLabel
        Left = 1
        Top = 52
        Width = 82
        Height = 13
        Caption = 'NameAddrLabel5'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object NameAddrLabel6: TLabel
        Left = 1
        Top = 65
        Width = 82
        Height = 13
        Caption = 'NameAddrLabel6'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object DimensionsLabel: TLabel
        Left = 1
        Top = 90
        Width = 80
        Height = 13
        Caption = 'DimensionsLabel'
      end
      object AssessmentLabel: TLabel
        Left = 1
        Top = 116
        Width = 82
        Height = 13
        Caption = 'AssessmentLabel'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clRed
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object PropertyClass_SchoolLabel: TLabel
        Left = 1
        Top = 103
        Width = 129
        Height = 13
        Caption = 'PropertyClass_SchoolLabel'
      end
      object LegalAddressLabel: TLabel
        Left = 1
        Top = 77
        Width = 90
        Height = 13
        Caption = 'LegalAddressLabel'
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Sales'
      ImageIndex = 1
      object SalesTreeView: TTreeView
        Left = 0
        Top = 0
        Width = 220
        Height = 135
        Align = alClient
        Indent = 19
        TabOrder = 0
      end
    end
    object ExemptionTabSheet: TTabSheet
      Caption = 'EX'
      ImageIndex = 3
      object ExemptionsListView: TListView
        Left = 0
        Top = 0
        Width = 228
        Height = 135
        Align = alClient
        Columns = <
          item
            Caption = 'Code'
            Width = 39
          end
          item
            Alignment = taRightJustify
            Caption = '%'
            Width = 20
          end
          item
            Alignment = taRightJustify
            Caption = 'County'
            Width = 54
          end
          item
            Alignment = taRightJustify
            Caption = 'Munic'
            Width = 54
          end
          item
            Alignment = taRightJustify
            Caption = 'School'
            Width = 54
          end>
        GridLines = True
        TabOrder = 0
        ViewStyle = vsReport
      end
    end
    object SDTabSheet: TTabSheet
      Caption = 'SD'
      ImageIndex = 4
      object SpecialDistrictListView: TListView
        Left = 0
        Top = 0
        Width = 228
        Height = 135
        Align = alClient
        Columns = <
          item
            Caption = 'Code'
            Width = 45
          end
          item
            Alignment = taRightJustify
            Caption = 'Units'
            Width = 40
          end
          item
            Alignment = taRightJustify
            Caption = '2nd '
            Width = 40
          end
          item
            Alignment = taRightJustify
            Caption = '%'
            Width = 20
          end
          item
            Alignment = taRightJustify
            Caption = 'Override'
            Width = 55
          end>
        GridLines = True
        TabOrder = 0
        ViewStyle = vsReport
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'Inventory'
      ImageIndex = 2
      object InventoryPageControl: TPageControl
        Left = 0
        Top = 33
        Width = 220
        Height = 99
        ActivePage = BuildingTabSheet
        Align = alTop
        TabOrder = 0
        object BuildingTabSheet: TTabSheet
          Caption = 'Bldg'
          object BuildingStyleLabel: TLabel
            Left = 5
            Top = 2
            Width = 44
            Height = 13
            Caption = 'BldgStyle'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlue
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
          end
          object BuildingConditionLabel: TLabel
            Left = 5
            Top = 16
            Width = 46
            Height = 13
            Caption = 'BldgCond'
          end
          object BuildingGradeLabel: TLabel
            Left = 5
            Top = 30
            Width = 50
            Height = 13
            Caption = 'BldgGrade'
          end
          object BuildingYearLabel: TLabel
            Left = 5
            Top = 43
            Width = 43
            Height = 13
            Caption = 'BldgYear'
          end
          object Building1stFloorLabel: TLabel
            Left = 5
            Top = 57
            Width = 35
            Height = 13
            Caption = 'Bldg1st'
          end
          object BuildingRoomsLabel: TLabel
            Left = 103
            Top = 2
            Width = 54
            Height = 13
            Caption = 'BldgRooms'
          end
          object BuildingBedroomsLabel: TLabel
            Left = 103
            Top = 16
            Width = 40
            Height = 13
            Caption = 'BldgBed'
          end
          object BuildingFireplacesLabel: TLabel
            Left = 103
            Top = 43
            Width = 38
            Height = 13
            Caption = 'BldgFire'
          end
          object BuildingAreaLabel: TLabel
            Left = 103
            Top = 56
            Width = 43
            Height = 13
            Caption = 'BldgArea'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clGreen
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
          end
          object BuildingBathroomsLabel: TLabel
            Left = 103
            Top = 29
            Width = 48
            Height = 13
            Caption = 'BldgBaths'
          end
        end
        object ImprovementTabSheet: TTabSheet
          Caption = 'Improve'
          ImageIndex = 1
          object ImprovementsListView: TListView
            Left = 0
            Top = 0
            Width = 220
            Height = 71
            Align = alClient
            Columns = <
              item
                Caption = 'Type'
                Width = 90
              end
              item
                Caption = 'Qty'
                Width = 30
              end
              item
                Caption = 'Dim'
                Width = 40
              end
              item
                Caption = 'Year'
                Width = 40
              end>
            GridLines = True
            TabOrder = 0
            ViewStyle = vsReport
          end
        end
        object LandTabSheet: TTabSheet
          Caption = 'Land'
          ImageIndex = 2
          object LandListView: TListView
            Left = 0
            Top = 0
            Width = 220
            Height = 71
            Align = alClient
            Columns = <
              item
                Caption = 'Type'
              end
              item
                Caption = 'Size'
              end
              item
                Caption = 'Value'
              end
              item
                Caption = 'Unit $'
              end>
            GridLines = True
            TabOrder = 0
            ViewStyle = vsReport
          end
        end
      end
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 220
        Height = 33
        Align = alTop
        Color = clInfoBk
        TabOrder = 1
        object NbhdLabel: TLabel
          Left = 5
          Top = 2
          Width = 52
          Height = 13
          Caption = 'NbhdLabel'
        end
        object UtilityLabel: TLabel
          Left = 5
          Top = 19
          Width = 51
          Height = 13
          Caption = 'UtilityLabel'
        end
        object SewerWaterLabel: TLabel
          Left = 90
          Top = 2
          Width = 85
          Height = 13
          Caption = 'SewerWaterLabel'
        end
        object ZoningLabel: TLabel
          Left = 90
          Top = 19
          Width = 59
          Height = 13
          Caption = 'ZoningLabel'
        end
      end
    end
  end
  object ImageTabSet: TTabSet
    Left = 0
    Top = 319
    Width = 228
    Height = 21
    Align = alBottom
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    SelectedColor = clSilver
    UnselectedColor = clWhite
    OnChange = ImageTabSetChange
  end
  object ParcelPicture: TPMultiImage
    Left = 0
    Top = 163
    Width = 228
    Height = 156
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
    OnClick = ParcelPictureClick
    RubberBandBtn = mbLeft
    ScrollbarWidth = 12
    ParentColor = True
    Stretch = True
    TextLeft = 0
    TextTop = 0
    TextRotate = 0
    TabOrder = 2
    ZoomBy = 10
  end
  object PictureTable: TTable
    DatabaseName = 'PASsystem'
    IndexName = 'BYSWISSBLKEY_PICTURENUMBER'
    TableName = 'ppicturerec'
    TableType = ttDBase
    Left = 50
    Top = 172
  end
  object Query: TQuery
    DatabaseName = 'PASsystem'
    Left = 199
    Top = 183
  end
end
