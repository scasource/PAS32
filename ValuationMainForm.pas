unit ValuationMainForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  RPCanvas, RPrinter, RPDefine, RPBase, RPFiler, Db, ExtCtrls, DBTables,
  Wwtable, Wwdatsrc, Mask, DBCtrls, Grids, StdCtrls, wwdblook, ComCtrls,
  Tabnotbk, Buttons, Types, Btrvdlg, DLL96V1, Wwdbigrd, Wwdbgrid, TMultiP,
  ValuationTypes, cxVGrid, cxDBVGrid, cxControls, cxInplaceContainer;

type
  TValuationForm = class(TForm)
    Label32: TLabel;
    Label33: TLabel;
    Label34: TLabel;
    Label35: TLabel;
    Panel1: TPanel;
    TitleLabel: TLabel;
    TemplateParcelLabel: TLabel;
    Panel2: TPanel;
    ScrollBox1: TScrollBox;
    ComparablesTypeRadioGroup: TRadioGroup;
    ValuationWeightingTable: TwwTable;
    LocateTimer: TTimer;
    ParcelTable: TTable;
    ParcelDataSource: TDataSource;
    AssessmentTable: TTable;
    ResSiteDataSource: TDataSource;
    ResidentialSiteTable: TTable;
    AssessmentDataSource: TDataSource;
    CommercialSiteTable: TTable;
    CommercialSiteDataSource: TDataSource;
    ComparableSalesSearchTable: TTable;
    MainTable: TwwTable;
    ParcelSearchTable: TTable;
    CompSalesMinMaxTable: TTable;
    SwisCodeTable: TTable;
    ReportFiler: TReportFiler;
    ReportPrinter: TReportPrinter;
    PrintDialog: TPrintDialog;
    PropertyClassTable: TwwTable;
    NeighborhoodTable: TwwTable;
    BuildingStyleTable: TwwTable;
    ZoningTable: TwwTable;
    WaterTable: TwwTable;
    ConditionTable: TwwTable;
    GradeTable: TwwTable;
    BasementTable: TwwTable;
    PropertyClassDataSource: TwwDataSource;
    NeighborhoodDataSource: TwwDataSource;
    BuildingStyleDataSource: TwwDataSource;
    ZoningDataSource: TwwDataSource;
    SewerDataSource: TwwDataSource;
    WaterDataSource: TwwDataSource;
    ConditionDataSource: TwwDataSource;
    GradeDataSource: TwwDataSource;
    BasementDataSource: TwwDataSource;
    CodeTable: TwwTable;
    ComparablesSalesDataTable: TwwTable;
    CompDataDataSource: TwwDataSource;
    SewerTable: TwwTable;
    SysRecTable: TTable;
    AssessmentYearControlTable: TTable;
    GroupBox1: TGroupBox;
    ExitValuationSpeedButton: TSpeedButton;
    LocateSpeedButton: TSpeedButton;
    PrintParcelSpeedButton: TSpeedButton;
    ValuationPageControl: TPageControl;
    TemplateTabSheet: TTabSheet;
    GroupTabSheet: TTabSheet;
    MinMaxTabSheet: TTabSheet;
    GroupMembersTabSheet: TTabSheet;
    AdjustmentsTabSheet: TTabSheet;
    ResultsTabSheet: TTabSheet;
    Label23: TLabel;
    Label45: TLabel;
    Label46: TLabel;
    Label47: TLabel;
    Pg3BldgStyleLabel: TLabel;
    Pg3NeighborhoodLabel: TLabel;
    Pg3PropClassLabel: TLabel;
    Label51: TLabel;
    Label52: TLabel;
    Pg3TavLabel: TLabel;
    Pg3LavLabel: TLabel;
    Label55: TLabel;
    Pg2MinLblLbl: TLabel;
    Pg3Lbl1: TLabel;
    Pg2MaxAssLabel: TLabel;
    P2MinAssLabel: TLabel;
    Pg2ParcelCntLabel: TLabel;
    Pg2MaxLblLbl: TLabel;
    Label42: TLabel;
    Label43: TLabel;
    Label48: TLabel;
    Label49: TLabel;
    Label50: TLabel;
    Label53: TLabel;
    Label54: TLabel;
    Label56: TLabel;
    Label57: TLabel;
    Label58: TLabel;
    Label59: TLabel;
    Label60: TLabel;
    Label61: TLabel;
    Label62: TLabel;
    Label63: TLabel;
    Label64: TLabel;
    Label65: TLabel;
    Label66: TLabel;
    Label22: TLabel;
    GradeMin: TEdit;
    AcresMin: TEdit;
    FFSqFtMin: TEdit;
    SqFtMin: TEdit;
    YearBuiltMin: TEdit;
    CondMin: TEdit;
    GradeMax: TEdit;
    AcresMax: TEdit;
    FFSqFtMax: TEdit;
    SqFtMax: TEdit;
    YearBuiltMax: TEdit;
    CondMax: TEdit;
    GradeTmpl: TEdit;
    AcresTmpl: TEdit;
    FFSqFtTmpl: TEdit;
    YearBuiltTmpl: TEdit;
    CondTmpl: TEdit;
    BedRoomsMin: TEdit;
    CrdNorthMin: TEdit;
    CrdEastMin: TEdit;
    FirePlacesMin: TEdit;
    StoriesMin: TEdit;
    BathsMin: TEdit;
    BedRoomsMax: TEdit;
    CrdNorthMax: TEdit;
    CrdEastMax: TEdit;
    FirePlacesMax: TEdit;
    StoriesMax: TEdit;
    BathsMax: TEdit;
    BedRoomsTmpl: TEdit;
    CrdNorthTmpl: TEdit;
    CrdEastTmpl: TEdit;
    FirePlacesTmpl: TEdit;
    StoriesTmpl: TEdit;
    BathsTmpl: TEdit;
    SqFtTmpl: TEdit;
    SaleDateMin: TEdit;
    SaleDateMax: TEdit;
    ValuationAdjustmentHeaderDataSource: TwwDataSource;
    Panel3: TPanel;
    Label1: TLabel;
    AdjustmentHeaderLookupCombo: TwwDBLookupCombo;
    AdjustmentHeaderDescriptionText: TDBText;
    Panel4: TPanel;
    Panel5: TPanel;
    ValuationAdjustmentDetailTable: TwwTable;
    ValuationAdjustmentDetailDataSource: TwwDataSource;
    ValuationAdjustmentDetailGrid: TwwDBGrid;
    ExcelSpeedButton: TSpeedButton;
    SaveSpeedButton: TSpeedButton;
    SubjectPictureTable: TwwTable;
    SubjectPictureDataSource: TwwDataSource;
    Panel7: TPanel;
    TotalAvDBText: TDBText;
    LandAvDBText: TDBText;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    ResSiteCntLabel: TLabel;
    CommercialSiteCntLabel: TLabel;
    Label10: TLabel;
    DepthDisplayLabel: TLabel;
    FrontageDisplayLabel: TLabel;
    AcreDisplayLabel: TLabel;
    TemplateLAddrLabel: TLabel;
    TemplateNameLabel: TLabel;
    SalePriceLabel: TLabel;
    Panel6: TPanel;
    GroupBox4: TGroupBox;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    PropertyClassText: TDBText;
    NeighborhoodText: TDBText;
    BuildingStyleText: TDBText;
    ZoningText: TDBText;
    SewerText: TDBText;
    WaterText: TDBText;
    WaterLookup: TwwDBLookupCombo;
    SewerLookup: TwwDBLookupCombo;
    ZoningLookup: TwwDBLookupCombo;
    BuildingStyleLookup: TwwDBLookupCombo;
    NeighborhoodLookup: TwwDBLookupCombo;
    PropertyClassLookup: TwwDBLookupCombo;
    YearBuiltEdit: TEdit;
    GroupBox3: TGroupBox;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    ConditionText: TDBText;
    GradeText: TDBText;
    BasementTypeText: TDBText;
    Label28: TLabel;
    BasementTypeLookup: TwwDBLookupCombo;
    GradeLookup: TwwDBLookupCombo;
    ConditionLookup: TwwDBLookupCombo;
    NumberOfBedroomsEdit: TEdit;
    SquareFootAreaEdit: TEdit;
    FirstFloorAreaEdit: TEdit;
    NumberOfStoriesEdit: TEdit;
    NumberOfBathsEdit: TEdit;
    GroupBox2: TGroupBox;
    Panel8: TPanel;
    PictureGrid: TwwDBGrid;
    GroupMembersGrid: TwwDBGrid;
    ApplyNewCharacteristicsButton: TBitBtn;
    GroupMembersTable: TwwTable;
    GroupMembersDataSource: TwwDataSource;
    Panel9: TPanel;
    Panel10: TPanel;
    Label29: TLabel;
    Label30: TLabel;
    Label31: TLabel;
    Pg2BldgStyleLabel: TLabel;
    Pg2NeighborHoodLabel: TLabel;
    Pg2PropClassLabel: TLabel;
    Pg1MinLblLbl: TLabel;
    Label40: TLabel;
    Pg1MaxDataLbl: TLabel;
    Pg1MinDataLbl: TLabel;
    Pg1ParcelCntLabel: TLabel;
    Pg1MaxLblLbl: TLabel;
    Panel11: TPanel;
    GroupBox5: TGroupBox;
    CharacteristicGroupsSelectedTable: TwwTable;
    CharacteristicGroupsSelectedDataSource: TwwDataSource;
    CharacteristicGroupsSelectedGrid: TwwDBGrid;
    AddCharacteristicGroupButton: TBitBtn;
    DeleteCharacteristicGroupButton: TBitBtn;
    ApplyMinMaxButton: TBitBtn;
    RestoreMinMaxButton: TBitBtn;
    GroupMembersLookupTable: TwwTable;
    ComparableAssessmentSearchTable: TTable;
    ResultsHeaderTable: TTable;
    ValuationAdjustmentHeaderTable: TwwTable;
    ResultsDetailsTable: TwwTable;
    ResultsGrid: TcxDBVerticalGrid;
    Panel12: TPanel;
    ResultsDetailsDataSource: TwwDataSource;
    Panel13: TPanel;
    ResultsDetailsLookupTable: TwwTable;
    ValuationAdjustmentFieldsAvailableTable: TTable;
    ResultsGridSwisCode: TcxDBEditorRow;
    ResultsGridSBLKey: TcxDBEditorRow;
    ResultsGridIncludeParcel: TcxDBEditorRow;
    ResultsGridOrder: TcxDBEditorRow;
    ResultsGridLegalAddress: TcxDBEditorRow;
    ResultsGridProximity: TcxDBEditorRow;
    ResultsGridOwner: TcxDBEditorRow;
    ResultsGridSchoolCode: TcxDBEditorRow;
    ResultsGridPropertyClass: TcxDBEditorRow;
    ResultsGridNeighborhood: TcxDBEditorRow;
    ResultsGridBuildingStyleCode: TcxDBEditorRow;
    ResultsGridSaleDate: TcxDBEditorRow;
    ResultsGridDeedBook: TcxDBEditorRow;
    ResultsGridDeedPage: TcxDBEditorRow;
    ResultsGridUnadjustedSalesPrice: TcxDBEditorRow;
    ResultsGridTimeAdjSalesPrice: TcxDBEditorRow;
    ResultsGridTimeAdjSalesPSF: TcxDBEditorRow;
    ResultsGridLotSize: TcxDBEditorRow;
    ResultsGridLotSizeAdjustment: TcxDBEditorRow;
    ResultsGridYearBuilt: TcxDBEditorRow;
    ResultsGridYearBuiltAdjustment: TcxDBEditorRow;
    ResultsGridSFLA: TcxDBEditorRow;
    ResultsGridSFLAAdjustment: TcxDBEditorRow;
    ResultsGridBedrooms: TcxDBEditorRow;
    ResultsGridBedroomsAdjustment: TcxDBEditorRow;
    ResultsGridBathrooms: TcxDBEditorRow;
    ResultsGridBathroomsAdjustment: TcxDBEditorRow;
    ResultsGridHalfBathrooms: TcxDBEditorRow;
    ResultsGridHalfBathroomsAdjustment: TcxDBEditorRow;
    ResultsGridBasementCode: TcxDBEditorRow;
    ResultsGridBasementArea: TcxDBEditorRow;
    ResultsGridBasementAreaAdjustment: TcxDBEditorRow;
    ResultsGridFireplaces: TcxDBEditorRow;
    ResultsGridFireplacesAdjustment: TcxDBEditorRow;
    ResultsGridGarages: TcxDBEditorRow;
    ResultsGridGaragesAdjustment: TcxDBEditorRow;
    ResultsGridCentralAir: TcxDBEditorRow;
    ResultsGridCentralAirAdjustment: TcxDBEditorRow;
    ResultsGridCondition: TcxDBEditorRow;
    ResultsGridConditionAdjustment: TcxDBEditorRow;
    ResultsGridGrade: TcxDBEditorRow;
    ResultsGridGradeAdjustment: TcxDBEditorRow;
    ResultsGridWaterSupply: TcxDBEditorRow;
    ResultsGridWaterSupplyAdjustment: TcxDBEditorRow;
    ResultsGridOther: TcxDBEditorRow;
    ResultsGridOtherAdjustment: TcxDBEditorRow;
    ResultsGridImprovementAdjustment: TcxDBEditorRow;
    ResultsGridSewerType: TcxDBEditorRow;
    ResultsGridSewerTypeAdjustment: TcxDBEditorRow;
    ResultsGridStories: TcxDBEditorRow;
    ResultsGridStoriesAdjustment: TcxDBEditorRow;
    ResultsGridWaterfront: TcxDBEditorRow;
    ResultsGridWaterfrontAdjustment: TcxDBEditorRow;
    ResultsGridAdjustedSalesPrice: TcxDBEditorRow;
    ResultsGridAdjustedPSF: TcxDBEditorRow;
    ResultsGridPicture: TcxDBEditorRow;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure LocateTimerTimer(Sender: TObject);
    procedure CondMinExit(Sender: TObject);
    procedure ApplyMinMaxButtonClick(Sender: TObject);
    procedure ReportPrintHeader(Sender: TObject);
    procedure ReportPrint(Sender: TObject);
    procedure PrintButtonClick(Sender: TObject);
    procedure ViewAnotherParcelButtonClick(Sender: TObject);
    procedure RestoreMinMaxButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ExitValuationSpeedButtonClick(Sender: TObject);
    procedure ShowMapButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    PrintPoints,
    AutoloadingParcel,
    OverridingMinMaxSettings,
    TemplateRecordFound : Boolean;
    TemplateSwisSBLKey : String;
    UnitName : String;

    TemplateCompSalesBookmark,
    TemplateGroupMemberBookmark,
    TemplateResultsDetailsBookmark : TBookmark;

    ProcessingType : Integer;
    GroupTotalsRec : GroupTotalsRecord;
    AdjustmentTemplate : TAdjustmentTemplateObject;

    AssessmentYear : String;
    FirstParcelDisplayed, MinMaxScreenInitialized : Boolean;
    MaximumEntriesInResults : Integer;

    Function GetSalesGroup(_SwisCode : String;
                           _NeighborhoodCode : String;
                           _PropertyClassCode : String;
                           _BuildingStyleCode : String) : Boolean;

    Function ParcelMeetsMinMaxCriteria(GroupMemberLookupTable : TTable) : Boolean;

    Procedure FillGroupMembersTable(_SwisCode : String;
                                    _NeighborhoodCode : String;
                                    _PropertyClassCode : String;
                                    _BuildingStyleCode : String;
                                    ComparableSalesDataTable : TTable;
                                    TemplateRecordFound : Boolean);

    Function ComputePoints(GroupMemberTable : TTable;
                           GroupMemberLookupTable : TTable;
                           WeightingPtr : WeightingPointer) : Double;

    Procedure LoadMembersForGroup(_SwisCode : String;
                                  _NeighborhoodCode : String;
                                  _PropertyClassCode : String;
                                  _BuildingStyleCode : String;
                                  TemplateSwisSBLKey : String;
                                  SalesPricePSF_List : TStringList;
                                  SalesPriceList : TStringList);

    Procedure AddOneGroupMemberToTable(ComparableDataSearchTable : TTable;
                                       GroupMembersTable : TTable;
                                       TemplateRecordFound,
                                       IsTemplate : Boolean);

    Procedure SetMinMaxScreenVariables(    CompMinMaxTable : TTable;
                                       var MinMaxScreenInitialized : Boolean);

    Procedure UpdateScreenMinMaxes(var GroupTotalsRec : GroupTotalsRecord);

    Procedure DisplayTemplateCharacteristics(SwisSBLKey : String;
                                             AssessmentYear : String;
                                             TemplateRecordFound : Boolean);

    Procedure InitializeTotalsRec(var GroupTotalsRec : GroupTotalsRecord);

    Procedure UpdateGroupTotals(    CompSalesMinMaxTable : TTable;
                                var GroupTotalsRec : GroupTotalsRecord);

    Procedure DisplayGroupTotals(GroupTotalsRec : GroupTotalsRecord);

    Function GetNextSheetID : LongInt;

    Procedure CreateTablesForSheet(SheetID : LongInt);

    Procedure AddOneResultRecord(ResultsDetailsTable : TTable;
                                 GroupMembersTable : TTable;
                                 GroupMembersLookupTable : TTable;
                                 Order : Integer;
                                 IsTemplate : Boolean);

    Procedure FillResultsTable(GroupMembersTable : TTable;
                               ResultsDetailsTable : TTable);

    Procedure LoadAndDisplayParcel(_SwisCode : String;
                                   _NeighborhoodCode : String;
                                   _PropertyClassCode : String;
                                   _BuildingStyleCode : String;
                                   SwisSBLKey : String);

    Procedure AddItemToCharacteristicGroupsSelected(CharacteristicGroupsSelectedTable : TTable;
                                                    CompSalesMinMaxTable : TTable);

  end;

var
  ValuationForm : TValuationForm;

implementation

uses Glblvars, WinUtils, Utilitys, PASUTILS, UTILEXSD,  PASTypes,
     GlblCnst, PrcLocat,Preview;

{$R *.DFM}

const
  GroupMemberTableName = 'vgroupmemberstable';
  CharacteristicGroupsSelectedTableName = 'vchargroupsselected';
  ValuationAdjustmentDetailTableName = 'vadjustmentdetails';
  ResultsDetailTableName = 'vresultsdetailstable';

{========================================================}
Procedure TValuationForm.FormShow(Sender: TObject);

begin
  LocateTimerTimer(Sender);
end;

{========================================================}
Procedure TValuationForm.FormCreate(Sender: TObject);

var
  TempStr : String;
  I, EqualsPos : Integer;
  Quit : Boolean;

begin
  MaximumEntriesInResults := 10;
  GlblErrorDlgBox := TSCAErrorDialogBox.Create(Self);
  GlblErrorDlgBox.ShowSCAPhoneNumbers := True;

  GlblLastSwisSBLKey := '';
  GlblLastLocateKey := 1;

  try
    SysrecTable.Open;
  except
      {If they can not even open the system record, there are very
       serious problems. They probably are not connected to the
       network or they don't have rights because they are not logged
       in with the correct ID. So, we will tell them and terminate
       the application.}

    MessageDlg('Can not access network.' + #13 +
               'Please check that you are connected ' + #13 +
               'to the network with the proper user ID.' + #13 +
               'Please correct the problem and try again.',
               mtError, [mbOK], 0);
    LogException('', '', 'BTrieve error: ' + IntToStr(GetBtrieveError(SysRecTable)), nil);
    Application.Terminate;
  end;

    {Set up the date and time formats.}

  LongTimeFormat := 'h:mm AMPM';
  ShortDateFormat := 'm/d/yyyy';
  SysrecTable.First;

    {FXX02091999-2: Move the setting of global system vars to
                    one proc.}

  SetGlobalSystemVariables(SysRecTable);

    {CHG10122000-1: In order to fix the print screen, I had to use Multi Image
                    and there are 2 DLLs - CRDE2000.DLL and ISP2000.DLL which
                    we will put in the application directory.  The following
                    variable allows us to put the DLLs where we want.}

  DLLPathName := ExpandPASPath(GlblProgramDir);

    {Now set the error file directory based on the system
     record.}

  GlblErrorDlgBox.ErrorFileDirectory := GlblDrive + ':' + GlblErrorFileDir;

  SysRecTable.Close;  {Close right away so hopefully don't get in use errors when all go in at once.}

     {FXX02042004-1(2.07l): If there is no next year file, then open up
                            everything in ThisYear.}

  OpenTableForProcessingType(ParcelTable, ParcelTableName, NextYear, Quit);

  If (ParcelTable.RecordCount = 0)
    then
      begin
        ProcessingType := ThisYear;
        AssessmentYear := GlblThisYear;
        GlblTaxYearFlg := 'T';
        GlblProcessingType := ThisYear;

        ParcelTable.Close;
        ParcelTable.TableName := ParcelTableName;
      end
    else
      begin
        ProcessingType := NextYear;
        AssessmentYear := GlblNextYear;
        GlblTaxYearFlg := 'N';
        GlblProcessingType := NextYear;
      end;

  FirstParcelDisplayed := True;

  UnitName := 'ValuationMainForm';
  ValuationPageControl.ActivePageIndex := 0;
  MinMaxScreenInitialized := False;

  OpenTablesForForm(Self, ProcessingType);

  TFloatField(AssessmentTable.FieldByName('LandAssessedVal')).DisplayFormat := CurrencyNormalDisplay;
  TFloatField(AssessmentTable.FieldByName('TotalAssessedVal')).DisplayFormat := CurrencyNormalDisplay;

  try
    Application.Icon.LoadFromFile('PASComparables.ico');
  except
  end;

  SetGlobalSBLSegmentFormats(AssessmentYearControlTable);

  InitGlblLastLocateInfoRec(GlblLastLocateInfoRec);

    {Accept the following parameters for comps to autolaunch -
     TYPE and PARCELID.}

  For I := 1 to ParamCount do
    begin
      TempStr := ParamStr(I);

      If (Pos('PARCELID', ANSIUppercase(TempStr)) > 0)
        then
          begin
            EqualsPos := Pos('=', TempStr);
            TemplateSwisSBLKey := Trim(Copy(TempStr, (EqualsPos + 1), 200));

              {FXX02032004-2(2.07l): Put the SwisSBL in double quotes for municipalilites
                                     with blanks in the SBL such as Glen Cove.}

            TemplateSwisSBLKey := StringReplace(TemplateSwisSBLKey, '"', '', [rfReplaceAll]);

            AutoloadingParcel := True;

          end;  {If (Pos('PARCELID', ANSIUppercase(TempStr)) > 0)}

    end;  {For I := 1 to ParamCount do}

  AdjustmentTemplate := TAdjustmentTemplateObject.Create;

  AdjustmentTemplate.SetAdjustmentCode(AdjustmentTemplate.GetDefaultAdjustmentCode(ValuationAdjustmentHeaderTable));
  AdjustmentTemplate.LoadAdjustmentInformation(ValuationAdjustmentFieldsAvailableTable,
                                               ValuationAdjustmentDetailTable);

  LocateTimer.Enabled := True;

end;  {FormCreate}

{=================================================================}
Procedure TValuationForm.ViewAnotherParcelButtonClick(Sender: TObject);

begin
  LocateTimer.Enabled := True;
end;  {ViewAnotherParcelButtonClick}

{===========================================================================}
Function TValuationForm.ParcelMeetsMinMaxCriteria(GroupMemberLookupTable : TTable) : Boolean;

(*var
  TempAcres : Double; *)

begin
  Result := True;

(*  with ComparablesRec do
    begin
      TempAcres := GetAcres(Acreage, Frontage, Depth);

      try
        If ((StrToInt(ConditionCode) < StrToInt(CondMin.Text)) or
            (StrToInt(ConditionCode) > StrToInt(CondMax.Text)))
          then Result := False;
      except
      end;

      try
        If ((Deblank(OverallGradeCode) < Deblank(GradeMin.Text)) or
            (DeBlank(OverallGradeCode) > DeBlank(GradeMax.Text)))
          then Result := False;
      except
      end;

      try
        If ((StrToInt(ActualYearBuilt) < StrToInt(YearBuiltMin.Text)) or
            (StrToInt(ActualYearBuilt) > StrToInt(YearBuiltMax.Text)))
          then Result := False;
      except
      end;

      try
        If ((SqFootLivingArea < StrToInt(SqFtMin.Text)) or
            (SqFootLivingArea  > StrToInt(SqFtMax.Text)))
          then Result := False;
      except
      end;

      try
        If ((FirstStoryArea  < StrToInt(FFSqFtMin.Text)) or
            (FirstStoryArea  > StrToInt(FFSqFtMax.Text)))
          then Result := False;
      except
      end;

      try
        If ((RoundOff(TempAcres, 2) < RoundOff(StrToFloat(AcresMin.Text), 2)) or
            (RoundOff(TempAcres, 2) > RoundOff(StrToFloat(AcresMax.Text), 2)))
          then Result := False;
      except
      end;

      try
        If ((NumberOfBathrooms < StrToFloat(BathsMin.Text)) or
            (NumberOfBathRooms > StrToFloat(BathsMax.Text)))
          then Result := False;
      except
      end;

      try
        If ((NumberOfBedrooms < StrToInt(BedRoomsMin.Text)) or
            (NumberOfBedrooms  > StrToInt(BedRoomsMax.Text)))
          then Result := False;
      except
      end;

      try
        If ((NumberOfStories < StrToFloat(StoriesMin.Text)) or
            (NumberOfStories > StrToFloat(StoriesMax.Text)))
          then Result := False;
      except
      end;

      try
        If ((NumberOfFirePlaces  < StrToInt(FirePlacesMin.Text)) or
            (NumberOfFireplaces  > StrToInt(FirePlacesMax.Text)))
          then Result := False;
      except
      end;

      try
        If ((EastCoord  < StrToInt(CrdEastMin.Text)) or
            (EastCoord  > StrToInt(CrdEastMax.Text)))
          then Result := False;
      except
      end;

      try
        If ((NorthCoord  < StrToInt(CrdNorthMin.Text)) or
            (NorthCoord  > StrToInt(CrdNorthMax.Text)))
        then Result := False;
      except
      end;

      try
        If ((Roundoff(SaleDate, 0) <> 0) and
            ((SaleDate < StrToDate(SaleDateMin.Text)) or
             (SaleDate > StrToDate(SaleDateMax.Text))) and
            ((Take(6, SwisCode) + Take(20, SBLKey)) <>
             Take(26, SwisSBLKey)))  {Not the template.}
          then Result := False;
      except
      end;

    end;  {with CompRec do} *)

end;  {ParcelMeetsMinMaxCriteria}

{===========================================================================}
Function TValuationForm.ComputePoints(GroupMemberTable : TTable;
                                      GroupMemberLookupTable : TTable;
                                      WeightingPtr : WeightingPointer) : Double;

var
  TempAcres1, TempAcres2 : Double;

begin
  Result := 0;
  GroupMemberLookupTable.GotoBookmark(TemplateGroupMemberBookmark);

  If not TableFieldsSame(GroupMemberTable, GroupMemberLookupTable, 'SwisCode')
    then Result := Result + WeightingPtr^.SwisCodePoints;

  If not TableFieldsSame(GroupMemberTable, GroupMemberLookupTable, 'PropertyClass')
    then Result := Result + WeightingPtr^.PropertyClassPoints;

  If not TableFieldsSame(GroupMemberTable, GroupMemberLookupTable, 'Neighborhood')
    then Result := Result + WeightingPtr^.NeighborhoodPoints;

  If not TableFieldsSame(GroupMemberTable, GroupMemberLookupTable, 'BuildingStyleCode')
    then Result := Result + WeightingPtr^.BuildingStylePoints;

  If not TableFieldsSame(GroupMemberTable, GroupMemberLookupTable, 'OverallGradeCode')
    then Result := Result + WeightingPtr^.GradePoints;

  If not TableFieldsSame(GroupMemberTable, GroupMemberLookupTable, 'ConditionCode')
    then Result := Result + WeightingPtr^.ConditionPoints;

  If not TableFieldsSame(GroupMemberTable, GroupMemberLookupTable, 'NumFireplaces')
    then Result := Result + WeightingPtr^.FireplacePoints;

  If not TableFieldsSame(GroupMemberTable, GroupMemberLookupTable, 'AttachedGarCapacity')
    then Result := Result + WeightingPtr^.GarageCapacityPoints;

  Result := Result +
            (TableIntegerFieldsDifference(GroupMemberTable,
                                          GroupMemberLookupTable,
                                          'SqFootLivingArea', True) *
             WeightingPtr^.SquareFootPoints);

  Result := Result +
            (TableIntegerFieldsDifference(GroupMemberTable,
                                          GroupMemberLookupTable,
                                          'ActualYearBuilt', True) *
             WeightingPtr^.YearPoints);

  Result := Result +
            (TableFloatFieldsDifference(GroupMemberTable,
                                        GroupMemberLookupTable,
                                        'NumberOfStories', True) *
             WeightingPtr^.StoriesPoints);

  Result := Result +
            (TableIntegerFieldsDifference(GroupMemberTable,
                                          GroupMemberLookupTable,
                                          'NumberOfBedrooms', True) *
             WeightingPtr^.BedroomPoints);

  Result := Result +
            (TableIntegerFieldsDifference(GroupMemberTable,
                                          GroupMemberLookupTable,
                                          'NumberOfBathrooms', True) *
             WeightingPtr^.BathroomPoints);

  try
    with GroupMemberLookupTable do
      TempAcres1 := GetAcres(FieldByName('Acreage').AsFloat,
                             FieldByName('Frontage').AsFloat,
                             FieldByName('Depth').AsFloat);

    with GroupMemberTable do
      TempAcres2 := GetAcres(FieldByName('Acreage').AsFloat,
                             FieldByName('Frontage').AsFloat,
                             FieldByName('Depth').AsFloat);

    Result := Result +
              (Abs(TempAcres1 - TempAcres2) *
                   WeightingPtr^.AcreagePoints);
  except
  end;

end;  {ComputePoints}

{===========================================================================}
Procedure TValuationForm.AddOneGroupMemberToTable(ComparableDataSearchTable : TTable;
                                                  GroupMembersTable : TTable;
                                                  TemplateRecordFound,
                                                  IsTemplate : Boolean);

var
  TempFloat : Double;
  TempInt, TimeAdjustedSalesPrice : LongInt;
  TempStr, TempSwisSBLKey : String;
  SBLRec : SBLRecord;

begin
  with ComparableDataSearchTable do
    try
      GroupMembersTable.Insert;
      GroupMembersTable.FieldByName('SwisCode').Text := FieldByName('SwisCode').Text;
      GroupMembersTable.FieldByName('SBLKey').Text := FieldByName('SBLKey').Text;
      GroupMembersTable.FieldByName('Site').AsInteger := FieldByName('Site').AsInteger;
      GroupMembersTable.FieldByName('IncludeParcel').AsBoolean := True;

      TempSwisSBLKey := FieldByName('SwisCode').Text + FieldByName('SBLKey').Text;

      SBLRec := ExtractSwisSBLFromSwisSBLKey(TempSwisSBLKey);

      with SBLRec do
        FindKeyOld(ParcelTable,
                   ['TaxRollYr', 'SwisCode', 'Section',
                    'Subsection', 'Block', 'Lot', 'Sublot','Suffix'],
                   [AssessmentYear, SwisCode, Section,
                    Subsection, Block, Lot, Sublot, Suffix]);

        {For template record, we must take the values from the front screen
         instead of from the record since they may have changed the values.}

      If IsTemplate
        then TempStr := PropertyClassLookup.Text
        else TempStr := FieldByName('PropertyClass').Text;
      GroupMembersTable.FieldByName('PropertyClass').Text := TempStr;

      If IsTemplate
        then TempStr := NeighborhoodLookup.Text
        else TempStr := FieldByName('Neighborhood').Text;
      GroupMembersTable.FieldByName('Neighborhood').Text := TempStr;

      If IsTemplate
        then TempStr := BuildingStyleLookup.Text
        else TempStr := FieldByName('BuildingStyleCode').Text;
      GroupMembersTable.FieldByName('BuildingStyleCode').Text := TempStr;

      If IsTemplate
        then TempStr := YearBuiltEdit.Text
        else TempStr := FieldByName('ActualYearBuilt').Text;
      GroupMembersTable.FieldByName('ActualYearBuilt').Text := TempStr;

      If IsTemplate
        then TempStr := ZoningLookup.Text
        else TempStr := FieldByName('ZoningCode').Text;
      GroupMembersTable.FieldByName('ZoningCode').Text := TempStr;

      If IsTemplate
        then TempStr := SewerLookup.Text
        else TempStr := FieldByName('SewerTypeCode').Text;
      GroupMembersTable.FieldByName('SewerTypeCode').Text := TempStr;

      If IsTemplate
        then TempStr := WaterLookup.Text
        else TempStr := FieldByName('WaterSupplyCode').Text;
      GroupMembersTable.FieldByName('WaterSupplyCode').Text := TempStr;

      If IsTemplate
        then TempStr := ConditionLookup.Text
        else TempStr := FieldByName('ConditionCode').Text;
      GroupMembersTable.FieldByName('ConditionCode').Text := TempStr;

      If IsTemplate
        then TempStr := GradeLookup.Text
        else TempStr := FieldByName('OverallGradeCode').Text;
      GroupMembersTable.FieldByName('OverallGradeCode').Text := TempStr;

      If IsTemplate
        then
          try
            TempInt := StrToInt(SquareFootAreaEdit.Text)
          except
            TempInt := 0;
          end
        else TempInt := FieldByName('SqFootLivingArea').AsInteger;
      GroupMembersTable.FieldByName('SqFootLivingArea').AsInteger := TempInt;

      If IsTemplate
        then
          try
            TempInt := StrToInt(FirstFloorAreaEdit.Text)
          except
            TempInt := 0;
          end
        else TempInt := FieldByName('FirstStoryArea').AsInteger;
      GroupMembersTable.FieldByName('FirstStoryArea').AsInteger := TempInt;

      If IsTemplate
        then
          try
            TempFloat := StrToFloat(NumberOfStoriesEdit.Text)
          except
            TempFloat := 0;
          end
        else TempFloat := FieldByName('NumberOfStories').AsFloat;
      GroupMembersTable.FieldByName('NumberOfStories').AsFloat := TempFloat;

      If IsTemplate
        then
          try
            TempInt := StrToInt(NumberofBedroomsEdit.Text);
          except
            TempInt := 0;
          end
        else TempInt := FieldByName('NumberOfBedrooms').AsInteger;
      GroupMembersTable.FieldByName('NumberOfBedrooms').AsInteger := TempInt;

      If IsTemplate
        then
          try
            TempFloat := StrToFloat(NumberOfBathsEdit.Text);
          except
            TempFloat := 0;
          end
        else TempFloat := FieldByName('NumberOfBathrooms').AsFloat;
      GroupMembersTable.FieldByName('NumberOfBathrooms').AsFloat := TempFloat;

      If IsTemplate
        then TempStr := BasementTypeLookup.Text
        else TempStr := FieldByName('BasementCode').Text;
      GroupMembersTable.FieldByName('BasementCode').Text := TempStr;

      GroupMembersTable.FieldByName('NumFireplaces').AsInteger := FieldByName('NumFireplaces').AsInteger;
      GroupMembersTable.FieldByName('Acreage').AsFloat := FieldByName('Acreage').AsFloat;
      GroupMembersTable.FieldByName('Frontage').AsFloat := FieldByName('Frontage').AsFloat;
      GroupMembersTable.FieldByName('Depth').AsFloat := FieldByName('Depth').AsFloat;
      GroupMembersTable.FieldByName('AttachedGarCapacity').AsInteger := FieldByName('AttachedGarCapacity').AsInteger;
      GroupMembersTable.FieldByName('EastCoord').AsInteger := FieldByName('EastCoord').AsInteger;
      GroupMembersTable.FieldByName('NorthCoord').AsInteger := FieldByName('NorthCoord').AsInteger;
      GroupMembersTable.FieldByName('Owner').Text := ParcelTable.FieldByName('Name1').Text;
      GroupMembersTable.FieldByName('LegalAddress').Text := GetLegalAddressFromTable(ParcelTable);

      If (TemplateRecordFound or
          (not IsTemplate))
        then
          begin
            GroupMembersTable.FieldByName('UnadjustedSalesPrice').AsInteger := FieldByName('UnadjustedSalesPrice').AsInteger;
            GroupMembersTable.FieldByName('SaleDate').AsDateTime := FieldByName('SaleDate').AsDateTime;
            TimeAdjustedSalesPrice := AdjustmentTemplate.GetTimeAdjustedSalesPrice(FieldByName('UnadjustedSalesPrice').AsInteger,
                                                                                   FieldByName('SaleDate').AsDateTime);
            GroupMembersTable.FieldByName('TimeAdjSalesPrice').AsInteger := TimeAdjustedSalesPrice;

            try
              GroupMembersTable.FieldByName('SalePricePSF').AsFloat := TimeAdjustedSalesPrice /
                                                                          FieldByName('SqFootLivingArea').AsFloat;
            except
              GroupMembersTable.FieldByName('SalePricePSF').AsFloat := 0;
            end;

          end;  {If (TemplateRecordFound or}

      GroupMembersTable.FieldByName('FinishedBasementArea').AsInteger := FieldByName('FinishedBasementArea').AsInteger;
      GroupMembersTable.FieldByName('FinishedAtticArea').AsInteger := FieldByName('FinishedAtticArea').AsInteger;
      GroupMembersTable.FieldByName('CentralAir').AsBoolean := FieldByName('CentralAir').AsBoolean;
      GroupMembersTable.FieldByName('Imp1StructureCode').Text := FieldByName('Imp1StructureCode').Text;
      GroupMembersTable.FieldByName('Imp1YearBuilt').Text := FieldByName('Imp1YearBuilt').Text;
      GroupMembersTable.FieldByName('Imp1ConditionCode').Text := FieldByName('Imp1ConditionCode').Text;
      GroupMembersTable.FieldByName('Imp2StructureCode').Text := FieldByName('Imp2StructureCode').Text;
      GroupMembersTable.FieldByName('Imp2YearBuilt').Text := FieldByName('Imp2YearBuilt').Text;
      GroupMembersTable.FieldByName('Imp2ConditionCode').Text := FieldByName('Imp2ConditionCode').Text;
      GroupMembersTable.FieldByName('Imp3StructureCode').Text := FieldByName('Imp3StructureCode').Text;
      GroupMembersTable.FieldByName('Imp3YearBuilt').Text := FieldByName('Imp3YearBuilt').Text;
      GroupMembersTable.FieldByName('Imp3ConditionCode').Text := FieldByName('Imp3ConditionCode').Text;

      If not IsTemplate
        then GroupMembersTable.FieldByName('Points').AsFloat := ComputePoints(GroupMembersTable,
                                                                                     GroupMembersLookupTable,
                                                                                     AdjustmentTemplate.GetCurrentWeights);

      GroupMembersTable.Post;
    except
      SystemSupport(50, GroupMembersTable, 'Error adding record to group members table.',
                    UnitName, GlblErrorDlgBox);
    end;

  If IsTemplate
    then TemplateGroupMemberBookmark := GroupMembersTable.GetBookmark;

end;  {AddOneGroupMemberToList}

{===========================================================================}
Procedure TValuationForm.LoadMembersForGroup(_SwisCode : String;
                                             _NeighborhoodCode : String;
                                             _PropertyClassCode : String;
                                             _BuildingStyleCode : String;
                                             TemplateSwisSBLKey : String;
                                             SalesPricePSF_List : TStringList;
                                             SalesPriceList : TStringList);

var
  Done, FirstTimeThrough : Boolean;
  TempNum : Double;

begin
  Done := False;
  FirstTimeThrough := True;
  SalesPricePSF_List.Clear;
  SalesPriceList.Clear;

  SetRangeOld(ComparableSalesSearchTable,
              ['SwisCode', 'Neighborhood',
               'PropertyClass', 'BuildingStyleCode'],
              [_SwisCode, _NeighborhoodCode,
               _PropertyClassCode, _BuildingStyleCode],
              [_SwisCode, _NeighborhoodCode,
               _PropertyClassCode, _BuildingStyleCode]);

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else ComparableSalesSearchTable.Next;

    If ComparableSalesSearchTable.EOF
      then Done := True;

    If ((not Done) and
        (Copy(TemplateSwisSBLKey, 7, 20) <> Take(20, ComparableSalesSearchTable.FieldByName('SBLKey').Text)))
      then AddOneGroupMemberToTable(ComparableSalesSearchTable, GroupMembersTable, TemplateRecordFound, False);

    If not Done
      then
        begin
          try
            with GroupMembersTable do
              TempNum := FieldByName('TimeAdjSalesPrice').AsInteger /
                         FieldByName('SqFootLivingArea').AsInteger;
          except
            TempNum := 0;
          end;

          try
            SalesPricePSF_List.Add(FloatToStr(TempNum));
          except
            SalesPricePSF_List.Add('0');
          end;

          try
            SalesPriceList.Add(GroupMembersTable.FieldByName('TimeAdjSalesPrice').Text);
          except
            SalesPriceList.Add('0');
          end;

        end;  {If ((not Done) and ...}

  until Done;

end;  {LoadMembersForGroup}

{===========================================================================}
Procedure TValuationForm.FillGroupMembersTable(_SwisCode : String;
                                               _NeighborhoodCode : String;
                                               _PropertyClassCode : String;
                                               _BuildingStyleCode : String;
                                               ComparableSalesDataTable : TTable;
                                               TemplateRecordFound : Boolean);

var
  Median, Mean, COD : Double;
  TempTable : TTable;
  TempIndexName : String;
  Done, FirstTimeThrough : Boolean;
  SalesPricePSF_List, SalesPriceList : TStringList;

begin
  SalesPricePSF_List := TStringList.Create;
  SalesPriceList := TStringList.Create;

  TempIndexName := ComparableSalesSearchTable.IndexName;
  ComparableSalesSearchTable.IndexName := 'BYSWISCODE_SBLKEY_SITE';
  ComparableSalesSearchTable.GotoCurrent(ComparableSalesDataTable);
  ComparableSalesSearchTable.IndexName := TempIndexName;

    {If there is no template for sales, use assessment record.}

  If TemplateRecordFound
    then TempTable := ComparableSalesSearchTable
    else TempTable := ComparableAssessmentSearchTable;

  AddOneGroupMemberToTable(TempTable, GroupMembersTable, TemplateRecordFound, True);

    {Now go through each parcel in the groups.}

  Done := False;
  FirstTimeThrough := True;
  CharacteristicGroupsSelectedTable.DisableControls;
  CharacteristicGroupsSelectedTable.First;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else CharacteristicGroupsSelectedTable.Next;

    If CharacteristicGroupsSelectedTable.EOF
      then Done := True;

    If not Done
      then
        with CharacteristicGroupsSelectedTable do
          begin
            LoadMembersForGroup(FieldByName('SwisCode').Text,
                                FieldByName('Neighborhood').Text,
                                FieldByName('PropertyClass').Text,
                                FieldByName('BuildingStyleCode').Text,
                                TemplateSwisSBLKey,
                                SalesPricePSF_List, SalesPriceList);

            try
              Edit;
              SortListAndGetStats(SalesPriceList, Median, Mean, COD);
              FieldByName('MinimumSalePrice').AsInteger := StrToInt(SalesPriceList[0]);
              FieldByName('MaximumSalePrice').AsInteger := StrToInt(SalesPriceList[SalesPriceList.Count - 1]);
              FieldByName('MedianSalePrice').AsInteger := Trunc(Median);
              FieldByName('AverageSalePrice').AsInteger := Trunc(Mean);

              SortListAndGetStats(SalesPricePSF_List, Median, Mean, COD);
              FieldByName('MinimumPSF').AsInteger := StrToInt(SalesPricePSF_List[0]);
              FieldByName('MaximumPSF').AsInteger := StrToInt(SalesPricePSF_List[SalesPricePSF_List.Count - 1]);
              FieldByName('MedianPSF').AsInteger := Trunc(Median);
              FieldByName('AveragePSF').AsInteger := Trunc(Mean);
              Post;
            except
            end;

          end;  {with CharacteristicGroupsSelectedTable do}

  until Done;

  CharacteristicGroupsSelectedTable.First;
  CharacteristicGroupsSelectedTable.EnableControls;

end;  {FillGroupMembersTable}

{===========================================================================}
Function TValuationForm.GetSalesGroup(_SwisCode : String;
                                      _NeighborhoodCode : String;
                                      _PropertyClassCode : String;
                                      _BuildingStyleCode : String) : Boolean;

begin
  Result := FindKeyOld(CompSalesMinMaxTable,
                       ['SwisCode', 'Neighborhood',
                        'PropertyClass', 'BuildingStyleCode'],
                       [_SwisCode, _NeighborhoodCode,
                        _PropertyClassCode, _BuildingStyleCode]);

end;  {GetSalesGroup}

{===========================================================================}
Procedure TValuationForm.SetMinMaxScreenVariables(    CompMinMaxTable : TTable;
                                                  var MinMaxScreenInitialized : Boolean);

var
  OldDate : TDateTime;
  Year, Month, Day : Word;

begin
  with CompMinMaxTable do
    If not MinMaxScreenInitialized
      then
        begin
          MinMaxScreenInitialized := True;
          CondMin.Text := FieldByName('ConditionCodeMin').Text;
          GradeMin.Text := FieldByName('OverallGradeCodeMin').Text;
          YearBuiltMin.Text := FieldByName('ActualYearBuiltMin').Text;
          SqFtMin.Text := FieldByName('SqFootLivingAreaMin').Text;
          FFSqFTMin.Text := FieldByName('FirstStoryAreaMin').Text;

          AcresMin.Text := FormatFloat(DecimalDisplay, FieldByName('AcreageMin').AsFloat);
          BathsMin.Text := FormatFloat(DecimalDisplay, FieldByName('NumberOfBathroomsMin').AsFloat);
          BedroomsMin.Text := FieldByName('NumberOfBedroomsMin').Text;
          StoriesMin.Text := FormatFloat(DecimalDisplay, FieldByName('NumberOfStoriesMin').AsFloat);
          FireplacesMin.Text := FieldByName('NumberOfFirePlcsMin').Text;
          CrdEastMin.Text := FieldByName('EastCoordMin').Text;
          CrdNorthMin.Text := FieldByName('NorthCoordMin').Text;

          CondMax.Text := FieldByName('ConditionCodeMax').Text;
          GradeMax.Text := FieldByName('OverallGradeCodeMax').Text;
          YearBuiltMax.Text := FieldByName('ActualYearBuiltMax').Text;
          SqFtMax.Text := FieldByName('SqFootLivingAreaMax').Text;
          FFSqFTMax.Text := FieldByName('FirstStoryAreaMax').Text;

          AcresMax.Text := FormatFloat(DecimalDisplay, FieldByName('AcreageMax').AsFloat);
          BathsMax.Text := FormatFloat(DecimalDisplay, FieldByName('NumberOfBathroomsMax').AsFloat);
          BedroomsMax.Text := FieldByName('NumberOfBedroomsMax').Text;
          StoriesMax.Text := FormatFloat(DecimalDisplay, FieldByName('NumberOfStoriesMax').AsFloat);
          FireplacesMax.Text := FieldByName('NumberOfFirePlcsMax').Text;
          CrdEastMax.Text := FieldByName('EastCoordMax').Text;
          CrdNorthMax.Text := FieldByName('NorthCoordMax').Text;

          SaleDateMax.Text := DateToStr(Date);

          DecodeDate(Date, Year, Month, Day);
          Year := Year - 2;
          OldDate := EncodeDate(Year, Month, Day);
          SaleDateMin.Text := DateToStr(OldDate);

        end
      else
        begin
            {see if new min max items are outside range of existing ones, and}
            {if so, change to expand the min/max range to cover range of all records}

          If (Take(2, FieldByName('ConditionCodeMin').Text) < Take(2, CondMin.Text))
            then CondMin.Text := FieldByName('ConditionCodeMin').Text;

          If (Take(2, FieldByName('OverallGradeCodeMin').Text) < Take(2,GradeMin.Text))
            then GradeMin.Text := FieldByName('OverallGradeCodeMin').Text;

          If (Take(4,FieldByName('ActualYearBuiltMin').Text) < Take(4,YearBuiltMin.Text))
            then YearBuiltMin.Text := FieldByName('ActualYearBuiltMin').Text;

          try
            If (FieldByName('SqFootLivingAreaMin').AsInteger < StrToInt(SqFtMin.Text))
              then SqFtMin.Text := FieldByName('SqFootLivingAreaMin').Text;
          except
          end;

          try
            If (FieldByName('FirstStoryAreaMin').AsInteger < StrToInt(FFSqFTMin.Text))
              then FFSqFTMin.Text := FieldByName('FirstStoryAreaMin').Text;
          except
          end;

          try
            If (FieldByName('AcreageMin').AsFloat < StrToFloat(AcresMin.Text))
              then AcresMin.Text := FormatFloat(DecimalDisplay, FieldByName('AcreageMin').AsFloat);
          except
          end;

          try
            If (FieldByName('NumberOfBathroomsMin').AsFloat < StrToFloat(BathsMin.Text))
              then BathsMin.Text := FieldByName('NumberOfBathroomsMin').Text;
          except
          end;

          try
            If (FieldByName('NumberOfBedroomsMin').AsInteger < StrToInt(BedroomsMin.Text))
              then BedroomsMin.Text := FieldByName('NumberOfBedroomsMin').Text;
          except
          end;

          try
            If (FieldByName('NumberOfStoriesMin').AsFloat < StrToFloat(StoriesMin.Text))
              then StoriesMin.Text := FieldByName('NumberOfStoriesMin').Text;
          except
          end;

          try
            If (FieldByName('NumberOfFirePlcsMin').AsInteger < StrToInt(FireplacesMin.Text))
              then FireplacesMin.Text := FieldByName('NumberOfFirePlcsMin').Text;
          except
          end;

          try
            If (FieldByName('EastCoordMin').AsInteger < StrtoInt(CrdEastMin.Text))
              then CrdEastMin.Text := FieldByName('EastCoordMin').Text;
          except
          end;

          try
            If (FieldByName('NorthCoordMin').AsInteger < StrToInt(CrdNorthMin.Text))
              then CrdNorthMin.Text := FieldByName('NorthCoordMin').Text;
          except
          end;

          If (Take(2, FieldByName('ConditionCodeMax').Text) > Take(2, CondMax.Text))
            then CondMax.Text := FieldByName('ConditionCodeMax').Text;

          If (Take(2, FieldByName('OverallGradeCodeMax').Text) > Take(2, GradeMax.Text))
            then GradeMax.Text := FieldByName('OverallGradeCodeMax').Text;

          If (Take(4, FieldByName('ActualYearBuiltMax').Text) > Take(4, YearBuiltMax.Text))
            then YearBuiltMax.Text := FieldByName('ActualYearBuiltMax').Text;

          try
            If (FieldByName('SqFootLivingAreaMax').AsInteger > StrToInt(SqFtMax.Text))
             then SqFtMax.Text := FieldByName('SqFootLivingAreaMax').Text;
          except
          end;

          try
            If (FieldByName('FirstStoryAreaMax').AsInteger > StrToInt(FFSqFTMax.Text))
              then FFSqFTMax.Text := FieldByName('FirstStoryAreaMax').Text;
          except
          end;

          try
            If (FieldByName('AcreageMax').AsFloat > StrtoFloat(AcresMax.Text))
              then AcresMax.Text := FormatFloat(DecimalDisplay, FieldByName('AcreageMax').AsFloat);
          except
          end;

          try
            If (FieldByName('NumberOfBathroomsMax').AsFloat > StrToFloat(BathsMax.Text))
              then BathsMax.Text := FieldByName('NumberOfBathroomsMax').Text;
          except
          end;

          try
            If (FieldByName('NumberOfBedroomsMax').AsInteger > StrToInt(BedroomsMax.Text))
              then BedroomsMax.Text := FieldByName('NumberOfBedroomsMax').Text;
          except
          end;

          try
            If (FieldByName('NumberOfStoriesMax').AsFloat > StrToFloat(StoriesMax.Text))
              then StoriesMax.Text := FieldByName('NumberOfStoriesMax').Text;
          except
          end;

          try
            If (FieldByName('NumberOfFirePlcsMax').AsInteger > StrToInt(FireplacesMax.Text))
              then FireplacesMax.Text := FieldByName('NumberOfFirePlcsMax').Text;
          except
          end;

          try
            If (FieldByName('EastCoordMax').AsInteger > StrToInt(CrdEastMax.Text))
              then CrdEastMax.Text := FieldByName('EastCoordMax').Text;
          except
          end;

          try
            If (FieldByName('NorthCoordMax').AsInteger > StrToInt(CrdNorthMax.Text))
              then CrdNorthMax.Text := FieldByName('NorthCoordMax').Text;
          except
          end;

        end;  {else of If not MinMaxScreenInitialized}

  MinMaxScreenInitialized := True;

end;  {SetMinMaxScreenVariables}

{===========================================================================}
Procedure TValuationForm.DisplayTemplateCharacteristics(SwisSBLKey : String;
                                                        AssessmentYear : String;
                                                        TemplateRecordFound : Boolean);

var
  ResidentialSiteCount, CommercialSiteCount : Integer;
  TempAcres : Double;

begin
  with ComparablesSalesDataTable do
    begin
      FindKeyOld(PropertyClassTable, ['MainCode'],
                 [FieldByName('PropertyClass').Text]);
      FindKeyOld(NeighborhoodTable, ['MainCode'],
                 [FieldByName('Neighborhood').Text]);
      FindKeyOld(BuildingStyleTable, ['MainCode'],
                 [FieldByName('BuildingStyleCode').Text]);
      FindKeyOld(ZoningTable, ['MainCode'],
                 [FieldByName('ZoningCode').Text]);
      FindKeyOld(SewerTable, ['MainCode'],
                 [FieldByName('SewerTypeCode').Text]);
      FindKeyOld(WaterTable, ['MainCode'],
                 [FieldByName('WaterSupplyCode').Text]);
      FindKeyOld(ConditionTable, ['MainCode'],
                 [FieldByName('ConditionCode').Text]);
      FindKeyOld(GradeTable, ['MainCode'],
                 [FieldByName('OverallGradeCode').Text]);
      FindKeyOld(BasementTable, ['MainCode'],
                 [FieldByName('BasementCode').Text]);

      BasementTypeLookup.Value := FieldByName('BasementCode').Text;
      GradeLookup.Value := FieldByName('OverallGradeCode').Text;
      ConditionLookup.Value := FieldByName('ConditionCode').Text;
      WaterLookup.Value := FieldByName('WaterSupplyCode').Text;
      SewerLookup.Value := FieldByName('SewerTypeCode').Text;
      ZoningLookup.Value := FieldByName('ZoningCode').Text;
      BuildingStyleLookup.Value := FieldByName('BuildingStyleCode').Text;
      NeighborhoodLookup.Value := FieldByName('Neighborhood').Text;
      PropertyClassLookup.Value := FieldByName('PropertyClass').Text;

      YearBuiltEdit.Text := FieldByName('ActualYearBuilt').Text;
      SquareFootAreaEdit.Text := FieldByName('SqFootLivingArea').Text;
      FirstFloorAreaEdit.Text := FieldByName('FirstStoryArea').Text;
      NumberOfStoriesEdit.Text := FieldByName('NumberOfStories').Text;
      NumberofBedroomsEdit.Text := FieldByName('NumberOfBedrooms').Text;
      NumberOfBathsEdit.Text := FieldByName('NumberOfBathrooms').Text;

      PropertyClassText.Visible := (Deblank(PropertyClassLookup.Text) <> '');
      NeighborhoodText.Visible := (Deblank(NeighborhoodLookup.Text) <> '');
      BuildingStyleText.Visible := (Deblank(BuildingStyleLookup.Text) <> '');
      ZoningText.Visible := (Deblank(ZoningLookup.Text) <> '');
      SewerText.Visible := (Deblank(SewerLookup.Text) <> '');
      WaterText.Visible := (Deblank(WaterLookup.Text) <> '');
      ConditionText.Visible := (Deblank(ConditionLookup.Text) <> '');
      GradeText.Visible := (Deblank(GradeLookup.Text) <> '');
      BasementTypeText.Visible := (Deblank(BasementTypeLookup.Text) <> '');

      Pg2PropClassLabel.Caption := FieldByName('PropertyClass').Text;
      Pg2NeighborhoodLabel.Caption := FieldByName('Neighborhood').Text;
      Pg2BldgStyleLabel.Caption := FieldByName('BuildingStyleCode').Text;

    end;  {with ComparablesSalesDataTable do}

  SetRangeOld(SubjectPictureTable, ['SwisSBLKey'], [SwisSBLKey], [SwisSBLKey]);

  ResidentialSiteCount := CalculateNumSites(ResidentialSiteTable, AssessmentYear,
                                            SwisSBLKey, 0, False);
  ResSiteCntLabel.Caption := IntToStr(ResidentialSiteCount);

  try
    ResSiteCntLabel.Repaint;
  except
  end;

  CommercialSiteCount := CalculateNumSites(CommercialSiteTable, AssessmentYear,
                                           SwisSBLKey, 0, False);
  CommercialSiteCntLabel.Caption := IntToStr(CommercialSiteCount);

  try
    CommercialSiteCntLabel.Repaint;
  except
  end;

    {Set up name addresslabel}

  with ParcelTable do
    begin
      TemplateNameLabel.Caption := FieldByName('Name1').Text;
      TemplateLAddrLabel.Caption := GetLegalAddressFromTable(ParcelTable);

      TemplateParcelLabel.Caption := 'Template Parcel: ' +
                                     ConvertSwisSBLToDashDot(SwisSBLKey);

      TempAcres := GetAcres(FieldByName('Acreage').AsFloat,
                            FieldByName('Frontage').AsFloat,
                            FieldByName('Depth').AsFloat);

      AcreDisplayLabel.Caption := FormatFloat(DecimalDisplay, TempAcres);
      FrontageDisplayLabel.Caption := FormatFloat(DecimalDisplay,
                                                  FieldByName('Frontage').AsFloat);
      DepthDisplayLabel.Caption := FormatFloat(DecimalDisplay,
                                               FieldByName('Depth').AsFloat);

    end;  {with ParcelTable do}

  If TemplateRecordFound
    then
      with ComparablesSalesDataTable do
        SalePriceLabel.Caption := 'Sale Price - ' +
                         FormatFloat(CurrencyNormalDisplay, FieldByName('UnadjustedSalesPrice').AsFloat) +
                         '   (' +
                         FieldByName('SaleDate').Text + ')'
    else SalePriceLabel.Caption := 'Sale Price - No sale for parcel.' ;

  Pg3LavLabel.Caption := FormatFloat(CurrencyNormalDisplay,
                                     AssessmentTable.FieldByName('LandAssessedVal').AsFloat);
  Pg3TavLabel.Caption := FormatFloat(CurrencyNormalDisplay,
                                     AssessmentTable.FieldByName('TotalAssessedVal').AsFloat);

end;  {DisplayTemplateCharacteristics}

{===========================================================================}
Procedure TValuationForm.InitializeTotalsRec(var GroupTotalsRec : GroupTotalsRecord);

begin
  with GroupTotalsRec do
    begin
      MinimumSalePrice := 0;
      MaximumSalePrice := 0;
      MedianSalePrice := 0;
      AverageSalePrice := 0;
      MinimumPSF := 0;
      MaximumPSF := 0;
      MedianPSF := 0;
      AveragePSF := 0;
      ParcelCount := 0;

    end;  {with GroupTotalsRec do}

end;  {InitializeTotalsRec}

{===========================================================================}
Procedure TValuationForm.UpdateGroupTotals(    CompSalesMinMaxTable : TTable;
                                           var GroupTotalsRec : GroupTotalsRecord);

begin
end;  {UpdateGroupTotals}

{===========================================================================}
Procedure TValuationForm.DisplayGroupTotals(GroupTotalsRec : GroupTotalsRecord);

begin
  with GroupTotalsRec do
    begin
      Pg1MinLblLbl.Caption := 'Minimum Sls Prc';
      Pg1MaxLblLbl.Caption := 'Maximum Sls Prc';

      Pg1MinDataLbl.Caption := FormatFloat(CurrencyNormalDisplay, MinimumSalePrice);
      Pg1MaxDataLbl.Caption := FormatFloat(CurrencyNormalDisplay, MaximumSalePrice);

      Pg1ParcelCntLabel.Caption := IntToStr(ParcelCount);

    end;  {with GroupTotalsRec do}

end;  {DisplayGroupTotals}

{===========================================================================}
Procedure TValuationForm.AddItemToCharacteristicGroupsSelected(CharacteristicGroupsSelectedTable : TTable;
                                                               CompSalesMinMaxTable : TTable);

begin
  with CharacteristicGroupsSelectedTable do
    try
      Insert;
      FieldByName('SwisCode').Text := CompSalesMinMaxTable.FieldByName('SwisCode').Text;
      FieldByName('Neighborhood').Text := CompSalesMinMaxTable.FieldByName('Neighborhood').Text;
      FieldByName('PropertyClass').Text := CompSalesMinMaxTable.FieldByName('PropertyClass').Text;
      FieldByName('BuildingStyleCode').Text := CompSalesMinMaxTable.FieldByName('BuildingStyleCode').Text;
      FieldByName('ParcelCount').AsInteger := CompSalesMinMaxTable.FieldByName('GroupParcelCount').AsInteger;
      FieldByName('MinSalesPrice').AsInteger := CompSalesMinMaxTable.FieldByName('SalesPriceMin').AsInteger;
      FieldByName('MaxSalesPrice').AsInteger := CompSalesMinMaxTable.FieldByName('SalesPriceMax').AsInteger;
      Post;
    except
      SystemSupport(52, CharacteristicGroupsSelectedTable,
                    'Error adding record to characteristic groups selected table.',
                    UnitName, GlblErrorDlgBox);
    end;

end;  {AddItemToCharacteristicGroupsSelected}

{===========================================================================}
Function TValuationForm.GetNextSheetID : LongInt;

begin
  Result := 0;

  with ResultsHeaderTable do
    try
      Last;
      Result := FieldByName('SheetID').AsInteger + 1;

        {Now reserve the sheet by creating the header.}

      Insert;
      FieldByName('SheetID').AsInteger := Result;
      FieldByName('SubjectSwisCode').Text := Copy(TemplateSwisSBLKey, 1, 6);
      FieldByName('SubjectSBL').Text := Copy(TemplateSwisSBLKey, 7, 20);
      FieldByName('DatePrepared').AsDateTime := Date;
      FieldByName('PreparedBy').Text := GlblUserName;
      FieldByName('CurrentLandValue').AsInteger := AssessmentTable.FieldByName('LandAssessedVal').AsInteger;
      FieldByName('CurrentTotalValue').AsInteger := AssessmentTable.FieldByName('TotalAssessedVal').AsInteger;
      Post;
    except
      SystemSupport(51, ResultsHeaderTable, 'Error adding record to results header table.',
                    UnitName, GlblErrorDlgBox);
    end;

end;  {GetNextSheetID}

{===========================================================================}
Procedure TValuationForm.CreateTablesForSheet(SheetID : LongInt);

var
  Prefix, SortFileName: String;
  Quit : Boolean;

begin
  Prefix := 'Sheet' + '_' + ShiftRightAddZeroes(Take(6, IntToStr(SheetID))) + '_';

  CopyAndOpenSortFile(GroupMembersTable, Prefix + GroupMemberTableName,
                      GroupMemberTableName, SortFileName,
                      False, False, Quit);

  GroupMembersLookupTable.TableName := GroupMembersTable.TableName;

  try
    GroupMembersLookupTable.Open;
  except
  end;

  CopyAndOpenSortFile(ResultsDetailsTable,
                      Prefix + ResultsDetailTableName,
                      ResultsDetailTableName, SortFileName,
                      False, False, Quit);

  ResultsDetailsLookupTable.TableName := ResultsDetailsTable.TableName;

  try
    ResultsDetailsLookupTable.Open;
  except
  end;

  CopyAndOpenSortFile(CharacteristicGroupsSelectedTable,
                      Prefix + CharacteristicGroupsSelectedTableName,
                      CharacteristicGroupsSelectedTableName, SortFileName,
                      False, False, Quit);

end;  {CreateTablesForSheet}

{===========================================================================}
Procedure TValuationForm.AddOneResultRecord(ResultsDetailsTable : TTable;
                                            GroupMembersTable : TTable;
                                            GroupMembersLookupTable : TTable;
                                            Order : Integer;
                                            IsTemplate : Boolean);

var
  _ResultExists : Boolean;
  TotalAdjustments : LongInt;
  LotSize : Double;

begin
  GroupMembersLookupTable.GotoBookmark(TemplateGroupMemberBookmark);
  ResultsDetailsTable.IndexName := 'BYSWISCODE_SBLKEY';

  with GroupMembersTable do
    _ResultExists := FindKeyOld(ResultsDetailsTable, ['SwisCode', 'SBLKey'],
                                [FieldByName('SwisCode').Text,
                                 FieldByName('SBLKey').Text]);

  If not _ResultExists
    then
      with ResultsDetailsTable do
        try
          Insert;

          FieldByName('SwisCode').Text := GroupMembersTable.FieldByName('SwisCode').Text;
          FieldByName('SBLKey').Text := GroupMembersTable.FieldByName('SBLKey').Text;
          FieldByName('IncludeParcel').AsBoolean := True;
          FieldByName('Order').AsInteger := Order;
          FieldByName('LegalAddress').Text := GroupMembersTable.FieldByName('LegalAddress').Text;
          FieldByName('Owner').Text := GroupMembersTable.FieldByName('Owner').Text;
          FieldByName('PropertyClass').Text := GroupMembersTable.FieldByName('PropertyClass').Text;
          FieldByName('Neighborhood').Text := GroupMembersTable.FieldByName('Neighborhood').Text;
          FieldByName('BuildingStyleCode').Text := GroupMembersTable.FieldByName('BuildingStyleCode').Text;
          FieldByName('SaleDate').AsDateTime := GroupMembersTable.FieldByName('SaleDate').AsDateTime;
          FieldByName('UnadjustedSalesPrice').AsInteger := GroupMembersTable.FieldByName('UnadjustedSalesPrice').AsInteger;
          FieldByName('TimeAdjSalesPrice').AsInteger := GroupMembersTable.FieldByName('TimeAdjSalesPrice').AsInteger;

          with GroupMembersTable do
            LotSize := GetAcres(FieldByName('Acreage').AsFloat,
                                FieldByName('Frontage').AsFloat,
                                FieldByName('Depth').AsFloat);
          FieldByName('LotSize').AsFloat := Roundoff(LotSize, 2);

          FieldByName('YearBuilt').Text := GroupMembersTable.FieldByName('ActualYearBuilt').Text;
          FieldByName('SFLA').AsInteger := GroupMembersTable.FieldByName('SqFootLivingArea').AsInteger;
          FieldByName('Bedrooms').AsInteger := GroupMembersTable.FieldByName('NumberOfBedrooms').AsInteger;
          FieldByName('Bathrooms').AsFloat := GroupMembersTable.FieldByName('NumberOfBathrooms').AsFloat;
          FieldByName('BasementArea').AsInteger := GroupMembersTable.FieldByName('FinishedBasementArea').AsInteger;
          FieldByName('BasementCode').Text := GroupMembersTable.FieldByName('BasementCode').Text;
          FieldByName('Fireplaces').AsInteger := GroupMembersTable.FieldByName('NumFireplaces').AsInteger;
          FieldByName('Garages').AsInteger := GroupMembersTable.FieldByName('AttachedGarCapacity').AsInteger;
          FieldByName('CentralAir').AsBoolean := GroupMembersTable.FieldByName('CentralAir').AsBoolean;
          FieldByName('Condition').Text := GroupMembersTable.FieldByName('ConditionCode').Text;
          FieldByName('Grade').Text := GroupMembersTable.FieldByName('OverallGradeCode').Text;
          FieldByName('WaterSupply').Text := GroupMembersTable.FieldByName('WaterSupplyCode').Text;
          FieldByName('SewerType').Text := GroupMembersTable.FieldByName('SewerTypeCode').Text;
          FieldByName('Stories').AsFloat := GroupMembersTable.FieldByName('NumberOfStories').AsFloat;

          FieldByName('TimeAdjSalesPSF').AsFloat := FieldByName('TimeAdjSalesPrice').AsInteger /
                                                    FieldByName('SFLA').AsInteger;

          If IsTemplate
            then
              begin
                FieldByName('AdjustedSalesPrice').AsInteger := FieldByName('TimeAdjSalesPrice').AsInteger;
                FieldByName('AdjustedPSF').AsFloat := FieldByName('TimeAdjSalesPSF').AsFloat;
              end
            else
              begin
                ResultsDetailsLookupTable.GotoBookmark(TemplateResultsDetailsBookmark);
                TotalAdjustments := AdjustmentTemplate.ComputeAdjustments(ResultsDetailsTable,
                                                                          ResultsDetailsLookupTable);


                FieldByName('AdjustedSalesPrice').AsInteger := FieldByName('TimeAdjSalesPrice').AsInteger +
                                                               TotalAdjustments;
                FieldByName('AdjustedPSF').AsFloat := FieldByName('AdjustedSalesPrice').AsInteger /
                                                      FieldByName('SFLA').AsInteger;

              end;

          Post;
        except
          SystemSupport(53, ResultsDetailsTable, 'Error adding record to results detail table.',
                        UnitName, GlblErrorDlgBox);
        end;

  If IsTemplate
    then TemplateResultsDetailsBookmark := ResultsDetailsTable.GetBookmark;

end;  {AddOneResultRecord}

{===========================================================================}
Procedure TValuationForm.FillResultsTable(GroupMembersTable : TTable;
                                          ResultsDetailsTable : TTable);

var
  Done, FirstTimeThrough : Boolean;
  ResultsAdded : Integer;
  TempSwisSBLKey : String;

begin
  Done := False;
  FirstTimeThrough := True;
  ResultsAdded := 1;

    {First do the template parcel.}

  AddOneResultRecord(ResultsDetailsTable, GroupMembersLookupTable,
                     GroupMembersLookupTable, ResultsAdded, True);

  GroupMembersTable.IndexName := 'ByPoints';

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else GroupMembersTable.Next;

    If (GroupMembersTable.EOF or
        (ResultsAdded > MaximumEntriesInResults))
      then Done := True;

    with GroupMembersTable do
      TempSwisSBLKey := FieldByName('SwisCode').Text + FieldByName('SBLKey').Text;

    If ((not Done) and
        (Take(26, TempSwisSBLKey) <> Take(26, TemplateSwisSBLKey)))
      then
        begin
          ResultsAdded := ResultsAdded + 1;
          AddOneResultRecord(ResultsDetailsTable, GroupMembersTable,
                             GroupMembersLookupTable, ResultsAdded, False);
        end;

  until Done;

  GroupMembersTable.IndexName := 'BYSWISCODE_SBLKEY_SITE';
  ResultsDetailsTable.IndexName := 'BYORDER';

end;  {FillResultsTable}

{===========================================================================}
Procedure TValuationForm.LoadAndDisplayParcel(_SwisCode : String;
                                              _NeighborhoodCode : String;
                                              _PropertyClassCode : String;
                                              _BuildingStyleCode : String;
                                              SwisSBLKey : String);

var
  SBLRec : SBLRecord;
  FoundGroup : Boolean;
  SheetID : LongInt;

begin
  SBLRec := ExtractSwisSBLFromSwisSBLKey(SwisSBLKey);

    {Clear group member and results table.}

  with SBLRec do
    FindKeyOld(ParcelTable,
               ['TaxRollYr', 'SwisCode', 'Section',
                'Subsection', 'Block', 'Lot', 'Sublot','Suffix'],
               [AssessmentYear, SwisCode, Section,
                Subsection, Block, Lot, Sublot, Suffix]);

  FindKeyOld(AssessmentTable,
             ['TaxRollYr', 'SwisSBLKey'],
             [AssessmentYear, SwisSBLKey]);

  SheetID := GetNextSheetID;
  CreateTablesForSheet(SheetID);

  DisplayTemplateCharacteristics(SwisSBLKey, AssessmentYear, TemplateRecordFound);

  FoundGroup := GetSalesGroup(_SwisCode, _NeighborhoodCode,
                              _PropertyClassCode, _BuildingStyleCode);

  If FoundGroup
    then
      begin
        TemplateCompSalesBookmark := ComparablesSalesDataTable.GetBookmark;
        AddItemToCharacteristicGroupsSelected(CharacteristicGroupsSelectedTable,
                                              CompSalesMinMaxTable);

        If not OverridingMinMaxSettings
          then UpdateScreenMinMaxes(GroupTotalsRec);

        FillGroupMembersTable(_SwisCode, _NeighborhoodCode,
                              _PropertyClassCode, _BuildingStyleCode,
                              ComparablesSalesDataTable,
                              TemplateRecordFound);

        FillResultsTable(GroupMembersTable, ResultsDetailsTable);

        ComparablesSalesDataTable.GotoBookmark(TemplateCompSalesBookmark);

      end
    else MessageDlg('There are no parcels with the same charateristics as the parcel' + #13 +
                     'you selected that also have sales.' +  #13 +
                     'Parcel ID = ' + ConvertSwisSBLToDashDot(SwisSBLKey) + '.' + #13 +
                     'Please change the parcel characteristics or try a different parcel.',
                     mtError, [mbOK], 0);

end;  {LoadAndDisplayParcel}

{===========================================================================}
Procedure TValuationForm.LocateTimerTimer(Sender: TObject);

var
  SwisCode, SBL,
  SearchSwisCode, SearchNeighborhood,
  SearchPropertyClass, SearchBuildingStyle : String;
  _Found, SelectedParcel : Boolean;

begin
  SelectedParcel := True;
  LocateTimer.Enabled := False;

  If not AutoloadingParcel
    then
      begin
        TemplateSwisSBLKey := Take(26,' ');

        SelectedParcel := ExecuteParcelLocateDialog(TemplateSwisSBLKey, True, False, 'Choose Parcel For Comparables',
                                                    False, nil);

        If (FirstParcelDisplayed and
            (not SelectedParcel))
          then Application.Terminate;

        If FirstParcelDisplayed
          then FirstParcelDisplayed := False;

      end;  {If not AutoloadingParcel}

  SwisCode := Copy(TemplateSwisSBLKey, 1, 6);
  SBL := Copy(TemplateSwisSBLKey, 7, 20);

  If ((Deblank(TemplateSwisSBLKey) <> '') and
      SelectedParcel)
    then
      begin
        FindNearestOld(ComparablesSalesDataTable,
                       ['SwisCode', 'SBLKey', 'Site'],
                       [SwisCode, SBL, '0']);

        with ComparablesSalesDataTable do
          begin
            _Found := ((Take(6, SwisCode) = Take(6, FieldByName('SwisCode').Text)) and
                       (Take(20, SBL) = Take(20, FieldByName('SBLKey').Text)));

            TemplateRecordFound := _Found;

            If _Found
              then
                begin
                  SearchSwisCode := FieldByName('SwisCode').Text;
                  SearchNeighborhood := FieldByName('Neighborhood').Text;
                  SearchPropertyClass := FieldByName('PropertyClass').Text;
                  SearchBuildingStyle := FieldByName('BuildingStyleCode').Text;

                end  {If _Found}
              else
                begin
                    {What to do if no comp info found?}
                end;

          end;  {with ComparablesSalesDataTable do}

        If _Found
          then LoadAndDisplayParcel(SearchSwisCode, SearchNeighborHood,
                                    SearchPropertyClass, SearchBuildingStyle,
                                    TemplateSwisSBLKey)
          else
            begin
              MessageDlg('No comparatives for parcel ' +
                         ConvertSwisSBLToDashDot(TemplateSwisSBLKey) + '.' + #13 +
                         'Please try a different parcel.',
                         mtError, [mbOK], 0);
              LocateTimer.Enabled := True;

            end;  {else of If Found}

        AutoloadingParcel := False;

      end;  {If (Deblank(SwisSBLKey) <> '')}

end;  {LocateTimerTimer}

{=========================================================================================}
Procedure TValuationForm.CondMinExit(Sender: TObject);

begin
  with Sender as TEdit do
    begin
      try
        StrToFloat(Text);
      except
        MessageDlg('Please enter a numeric value.', mtError, [mbOK], 0);
        Text := '0';
        SetFocus;
      end;

    end;  {with Sender as TEdit do}

end;  {CondMinExit}

{================================================================================================}
Procedure TValuationForm.ApplyMinMaxButtonClick(Sender: TObject);

(*var
  SearchSwis : Str6;
  SearchNeighborHood : Str5;
  SearchPropClass    : Str3;
  SearchBldgStyle    : Str2;
  SwisCd : Str6;
  SBLKey : Str20;
  _Found : Boolean; *)

begin
(*  ClearStringGrid(GroupMemberStringGrid);

    {FXX03292002-5: Reapplying min/max did not work.}

    {Reaccess the parcel and then reload the group members.}

  SwisCd := Copy(SwisSBLKey,1,6);
  SBLKey := Copy(SwisSBLKey,7,20);

  FindNearestOld(ComparablesSalesDataTable,
                 ['SwisCode', 'SBLKey', 'Site'],
                 [SwisCd, SBLKey, '0']);

  with ComparablesSalesDataTable do
    _Found := ((Take(6, SwisCd) = Take(6, FieldByName('SwisCode').Text)) and
              (Take(20, SBLKey) = Take(20, FieldByName('SBLKey').Text)));

  SearchSwis := Take(6,ComparablesSalesDataTable.FieldByName('SwisCode').Text);
  SearchNeighborHood := Take(5,ComparablesSalesDataTable.FieldByName('NeighborHood').Text);
  SearchPropClass := Take(3,ComparablesSalesDataTable.FieldByName('PropertyClass').Text);
  SearchBldgStyle := Take(2,ComparablesSalesDataTable.FieldByName('BuildingStyleCode').Text);

  OverridingMinMaxSettings := True;
  LoadAndDisplayParcel(SwisSBLKey, SearchSwis, SearchNeighborHood,
                       SearchPropClass, SearchBldgStyle);
  OverridingMinMaxSettings := False; *)

end;  {ApplyMinMaxButtonClick}

{======================================================================}
Procedure TValuationForm.RestoreMinMaxButtonClick(Sender: TObject);

{Set the min\maxes to the full values of the groups.}

begin
  UpdateScreenMinMaxes(GroupTotalsRec);

    {Now reset all the members.}

  ApplyMinMaxButtonClick(Sender);

end;  {RestoreMinMaxButtonClick}

{======================================================================}
Procedure TValuationForm.UpdateScreenMinMaxes(var GroupTotalsRec : GroupTotalsRecord);

{Set the min\max amounts taking all groups into account.}

var
  Done, FirstTimeThrough, _Found : Boolean;

begin
  Done := False;
  FirstTimeThrough := True;
  CharacteristicGroupsSelectedTable.DisableControls;
  CharacteristicGroupsSelectedTable.First;
  InitializeTotalsRec(GroupTotalsRec);

    {Loop through all the selected groups and set the min \ maxes.}

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else CharacteristicGroupsSelectedTable.Next;

    If CharacteristicGroupsSelectedTable.EOF
      then Done := True;

    If not Done
      then
        with CharacteristicGroupsSelectedTable do
          begin
            _Found := FindKeyOld(CompSalesMinMaxTable,
                                 ['SwisCode', 'Neighborhood',
                                  'PropertyClass', 'BuildingStyleCode'],
                                 [FieldByName('SwisCode').Text,
                                  FieldByName('Neighborhood').Text,
                                  FieldByName('PropertyClass').Text,
                                  FieldByName('BuildingStyleCode').Text]);

            If _Found
              then
                begin
                  UpdateGroupTotals(CompSalesMinMaxTable, GroupTotalsRec);

                  SetMinMaxScreenVariables(CompSalesMinMaxTable, MinMaxScreenInitialized);

                end;  {If _Found}

          end;  {with CharacteristicGroupsSelectedTable do}

  until Done;

  CharacteristicGroupsSelectedTable.EnableControls;
  CharacteristicGroupsSelectedTable.First;
  DisplayGroupTotals(GroupTotalsRec);

end;  {UpdateScreenMinMaxes}

{===================================================================================}
Procedure TValuationForm.ShowMapButtonClick(Sender: TObject);

var
  CompsFileName : String;
  CompsFile : TextFile;
  TempMapsCommandLine : String;
  MapsPChar : PChar;
  TempLen : Integer;

begin
  CompsFileName := 'C:\temp\Comps2.txt';
  AssignFile(CompsFile, CompsFileName);
  Rewrite(CompsFile);

(*  For I := 0 to 2 do
    with ResultsPointer(ResultsList[I])^ do
      Writeln(CompsFile, SwisCode + SBLKey); *)

  CloseFile(CompsFile);

  TempMapsCommandLine := 'PASMappingForm.EXE COMPS=' + CompsFileName;

  TempLen := Length(TempMapsCommandLine);
  MapsPChar := StrAlloc(TempLen + 1);
  StrPCopy(MapsPChar, TempMapsCommandLine);

  WinExec(MapsPChar, SW_SHOW);
  StrDispose(MapsPChar);

end;  {ShowMapButtonClick}

{===================================================================================}
Procedure TValuationForm.PrintButtonClick(Sender: TObject);

var
  NewFileName : String;
  TempFile : File;
  Quit : Boolean;
  Result : Integer;

begin
    {CHG10121998-1: Add user options for default destination and show vet max msg.}

  SetPrintToScreenDefault(PrintDialog);

    {CHG10041999-1: Ask if they want to print the points.}

  Result := MessageDlg('Do you want to print the points?', mtConfirmation,
                       [mbYes, mbNo, mbCancel], 0);

  If ((Result <> idCancel) and
      PrintDialog.Execute)
    then
      begin
        PrintPoints := (Result = idYes);

          {CHG10131998-1: Set the printer settings based on what printer they selected
                          only - they no longer need to worry about paper or landscape
                          mode.}

        AssignPrinterSettings(PrintDialog, ReportPrinter, ReportFiler, [ptLaser], True, Quit);

          {If they want to preview the print (i.e. have it
           go to the screen), then we need to come up with
           a unique file name to tell the ReportFiler
           component where to put the output.
           Once we have done that, we will execute the
           report filer which will print the report to
           that file. Then we will create and show the
           preview print form and give it the name of the
           file. When we are done, we will delete the file
           and make sure that we go back to the original
           directory.}

        If PrintDialog.PrintToFile
          then
            begin
              NewFileName := GetPrintFileName(Self.Caption, True);
              ReportFiler.FileName := NewFileName;

              try
                PreviewForm := TPreviewForm.Create(self);
                PreviewForm.FilePrinter.FileName := NewFileName;
                PreviewForm.FilePreview.FileName := NewFileName;

                ReportFiler.Execute;
                PreviewForm.ShowModal;
              finally
                PreviewForm.Free;
                  {Now delete the file.}
                try
                  AssignFile(TempFile, NewFileName);
                  OldDeleteFile(NewFileName);
                finally
                  {We don't care if it does not get deleted, so we won't put up an
                   error message.}

                  ChDir(GlblProgramDir);
                end;

              end;  {If PrintRangeDlg.PreviewPrint}

            end  {They did not select preview, so we will go
                  right to the printer.}
          else ReportPrinter.Execute;

      end;  {If PrintDialog.Execute}

end;  {PrintButtonClick}

{==========================================================================================}
Procedure TValuationForm.ReportPrintHeader(Sender: TObject);

begin
  with Sender as TBaseReport do
    begin
        {Print the date and page number.}

      SectionTop := 0.25;
      SectionLeft := 0.5;
      SectionRight := PageWidth - 0.5;
      SetFont('Times New Roman',8);
      PrintHeader('Page: ' + IntToStr(CurrentPage), pjRight);
      PrintHeader('Date: ' + DateToStr(Date) + '  Time: ' + TimeToStr(Now), pjLeft);

      SectionTop := 0.5;
      SetFont('Times New Roman', 10);
      Home;
      PrintCenter('Parcel Sales Comparatives Report', (PageWidth / 2));
      CRLF;
      Bold := False;
      SectionTop := 1.0;

        {Print column headers.}

      CRLF;
      Home;
      SetPen(clBlack, psSolid, 1, pmCopy); { Set pen to 1 dot width }
      SetFont('Times New Roman', 10);
      Bold := True;
      ClearTabs;

      SetTab(0.2, pjCenter, 0.5 ,0, BOXLINENONE, 0);   {Topic}
      SetTab(0.8, pjCenter, 1.3, 0, BOXLINEBOTTOM, 0);   {Template}
      SetTab(2.2, pjCenter, 1.3, 0, BOXLINEBOTTOM, 0);   {Comp1}
      SetTab(3.6, pjCenter, 1.3, 0, BOXLINEBOTTOM, 0);   {Comp2}
      SetTab(5.0, pjCenter, 1.3, 0, BOXLINEBOTTOM, 0);   {Comp3}
      SetTab(6.4, pjCenter, 1.3, 0, BOXLINEBOTTOM, 0);   {Comp4}
      SetTab(7.8, pjCenter, 1.3, 0, BOXLINEBOTTOM, 0);   {Comp5}
      SetTab(9.2, pjCenter, 1.3, 0, BOXLINEBOTTOM, 0);   {Comp6}
      SetTab(10.6, pjCenter, 1.3, 0, BOXLINEBOTTOM, 0);   {Comp7}
      SetTab(12.0, pjCenter, 1.3, 0, BOXLINEBOTTOM, 0);   {Comp8}

      If (CurrentPage = 1)
        then Println(#9 +
                     #9 + 'Template' +
                     #9 + 'Comparative 1' +
                     #9 + 'Comparative 2' +
                     #9 + 'Comparative 3' +
                     #9 + 'Comparative 4' +
                     #9 + 'Comparative 5' +
                     #9 + 'Comparative 6' +
                     #9 + 'Comparative 7' +
                     #9 + 'Comparative 8')
        else Println(#9 +
                     #9 + 'Comparative ' + IntToStr(((CurrentPage - 1) * 9)) +
                     #9 + 'Comparative ' + IntToStr(((CurrentPage - 1) * 9 + 1)) +
                     #9 + 'Comparative ' + IntToStr(((CurrentPage - 1) * 9 + 2)) +
                     #9 + 'Comparative ' + IntToStr(((CurrentPage - 1) * 9 + 3)) +
                     #9 + 'Comparative ' + IntToStr(((CurrentPage - 1) * 9 + 4)) +
                     #9 + 'Comparative ' + IntToStr(((CurrentPage - 1) * 9 + 5)) +
                     #9 + 'Comparative ' + IntToStr(((CurrentPage - 1) * 9 + 6)) +
                     #9 + 'Comparative ' + IntToStr(((CurrentPage - 1) * 9 + 7)) +
                     #9 + 'Comparative ' + IntToStr(((CurrentPage - 1) * 9 + 8)));

      ClearTabs;
      SetTab(0.2, pjLeft, 0.5 ,0, BOXLINENONE, 0);   {Topic}
      SetTab(0.8, pjCenter, 1.3, 0, BOXLINENone, 0);   {Template}
      SetTab(2.2, pjCenter, 1.3, 0, BOXLINENone, 0);   {Comp1}
      SetTab(3.6, pjCenter, 1.3, 0, BOXLINENone, 0);   {Comp2}
      SetTab(5.0, pjCenter, 1.3, 0, BOXLINENone, 0);   {Comp3}
      SetTab(6.4, pjCenter, 1.3, 0, BOXLINENone, 0);   {Comp4}
      SetTab(7.8, pjCenter, 1.3, 0, BOXLINENone, 0);   {Comp5}
      SetTab(9.2, pjCenter, 1.3, 0, BOXLINENone, 0);   {Comp6}
      SetTab(10.6, pjCenter, 1.3, 0, BOXLINENone, 0);   {Comp7}
      SetTab(12.0, pjCenter, 1.3, 0, BOXLINENone, 0);   {Comp8}

      SetFont('Times New Roman', 8);
      Bold := False;

    end;  {with Sender as TBaseReport do}

end;  {ReportPrintHeader}

{=============================================================================================}
Procedure TValuationForm.ReportPrint(Sender: TObject);

begin
end;  {ReportPrint}

{=====================================================================}
Procedure TValuationForm.ExitValuationSpeedButtonClick(Sender: TObject);

begin
  Close;
end;

{===================================================================}
Procedure TValuationForm.FormClose(    Sender: TObject;
                                             var Action: TCloseAction);

begin
  try
    ComparablesSalesDataTable.FreeBookmark(TemplateCompSalesBookmark);
  except
  end;

  try
    GroupMembersTable.FreeBookmark(TemplateGroupMemberBookmark);
  except
  end;

  CloseTablesForForm(Self);
  AdjustmentTemplate.Free;

    {Free up the child window and set the ClosingAForm Boolean to
     true so that we know to delete the tab.}

  Action := caFree;
  GlblClosingAForm := True;
  GlblClosingFormCaption := Caption;

end;  {FormClose}

end.