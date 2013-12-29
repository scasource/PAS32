unit Cmpdispl;

{To use this template:
  1. Save the form it under a new name.
  2. Rename the form in the Object Inspector.
  3. Rename the table in the Object Inspector. Then switch
     to the code and do a blanket replace of "Table" with the new name.
  4. Change UnitName to the new unit name.}

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, DBCtrls, DBTables, DB, Buttons, Grids,
  Wwdbigrd, Wwdbgrid, ExtCtrls, Wwtable, Wwdatsrc, Menus, BtrvDlg, Mask,
  DBLookup,types, wwdblook, (*Progress, *)RPCanvas, RPrinter, RPDefine, RPBase,
  RPFiler, TabNotBk, ComCtrls;

type
  CompDataRecord = record
    SwisCode : Str6;
    SBLKey : Str20;
    Site : Integer;
    PropertyClass : Str3;
    NeighborHood   : Str5;
    BuildingStyleCode : Str2;
    ActualYearBuilt : Str4;
    ZoningCode : Str5;
    SewerTypeCode : Str2;
    WaterSupplyCode : Str2;
    ConditionCode : Str2;
    OverallGradeCode : Str2;
    SqFootLivingArea : Longint;
    FirstStoryArea   : LongInt;
    NumberOfStories  : Double;
    NumberOfBedrooms : Integer;
    NumberOfBathrooms : Double;
    NumberOfFirePlaces : Integer;
    BasementCode : Str2;
    Acreage          : Double;    {acreage computed from acreage or ftg/depth}
    Frontage         : Double;
    Depth            : Double;
    AttachedGarCapacity : Integer;
    EastCoord           : LongInt;
    NorthCoord          : LongInt;
    Name : Str30;
    LegalAddr : Str30;
    LandAssessedVal     : Double;
    TotalAssessedVal    : Double;
    AsValPrSqFt         : Double;
    UnadjustedSalesPrice : Double;
    TimeAdjSalesPrice : Double;
    SaleDate             : Double;
    SalePricePerSqFt     : Double;
    TotalPoints         : Double;  {computed points based on  weights}
    FinishedBasementArea : LongInt;
    FinishedAtticArea    : LongInt;
    CentralAir           : Boolean;
    Imp1StructureCode    : Str3;
    Imp1YearBuilt        : Str4;
    Imp1ConditionCode    : Str2;
    Imp2StructureCode    : Str3;
    Imp2YearBuilt        : Str4;
    Imp2ConditionCode    : Str2;
    Imp3StructureCode    : Str3;
    Imp3YearBuilt        : Str4;
    Imp3ConditionCode    : Str2;
  end;

  CompDataPointer = ^CompDataRecord;
  ResultsPointer = ^CompDataRecord;

type
  TComparativesDisplayForm = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    ScrollBox1: TScrollBox;
    TitleLabel: TLabel;
    CompWeightingDataSource: TwwDataSource;
    CompWeightingTable: TwwTable;
    LocateTimer: TTimer;
    ParcelTable: TTable;
    ParcelDataSource: TDataSource;
    AssessmentTable: TTable;
    ResSiteDataSource: TDataSource;
    ResSiteTable: TTable;
    AssessmentDataSource: TDataSource;
    CommercialSiteTable: TTable;
    CommercialSiteDataSource: TDataSource;
    Label32: TLabel;
    Label33: TLabel;
    Label34: TLabel;
    Label35: TLabel;
    CompDataSearchTable: TTable;
    AssessmentSearchTable: TTable;
    CompAssmtMinMaxTable: TTable;
    MainTable: TwwTable;
    ParcelSearchTable: TTable;
    CompSalesMinMaxTable: TTable;
    SwCodeTable: TTable;
    ReportFiler: TReportFiler;
    ReportPrinter: TReportPrinter;
    PrintDialog: TPrintDialog;
    CompNotebook: TTabbedNotebook;
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
    Label8: TLabel;
    Label9: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    DepthDisplayLabel: TLabel;
    FrontageDisplayLabel: TLabel;
    AcreDisplayLabel: TLabel;
    TemplateLAddrLabel: TLabel;
    TemplateNameLabel: TLabel;
    BasementTypeLookup: TwwDBLookupCombo;
    GradeLookup: TwwDBLookupCombo;
    ConditionLookup: TwwDBLookupCombo;
    WaterLookup: TwwDBLookupCombo;
    SewerLookup: TwwDBLookupCombo;
    ZoningLookup: TwwDBLookupCombo;
    BuildingStyleLookup: TwwDBLookupCombo;
    NeighborhoodLookup: TwwDBLookupCombo;
    PropertyClassLookup: TwwDBLookupCombo;
    Label29: TLabel;
    Label30: TLabel;
    Label31: TLabel;
    Pg2BldgStyleLabel: TLabel;
    Pg2NeighborHoodLabel: TLabel;
    Pg2PropClassLabel: TLabel;
    Label36: TLabel;
    Label37: TLabel;
    Pg2TAVLabel: TLabel;
    Pg2LAVLabel: TLabel;
    Label38: TLabel;
    Pg1MinLblLbl: TLabel;
    Label40: TLabel;
    Pg1MaxDataLbl: TLabel;
    Pg1MinDataLbl: TLabel;
    Pg1ParcelCntLabel: TLabel;
    Pg1MaxLblLbl: TLabel;
    GroupStringGrid: TStringGrid;
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
    Label69: TLabel;
    Label70: TLabel;
    Label71: TLabel;
    Label72: TLabel;
    Label73: TLabel;
    Label74: TLabel;
    Label75: TLabel;
    Label76: TLabel;
    Label77: TLabel;
    Label78: TLabel;
    Label79: TLabel;
    Label80: TLabel;
    Label81: TLabel;
    Label82: TLabel;
    Label83: TLabel;
    Label84: TLabel;
    Label85: TLabel;
    Label86: TLabel;
    Label87: TLabel;
    BathsDBEdit: TDBEdit;
    BedRoomsDBEdit: TDBEdit;
    StoriesDBEdit: TDBEdit;
    YrBuiltDBEdit: TDBEdit;
    SqFtDBEdit: TDBEdit;
    CondDBEdit: TDBEdit;
    GradeDBEdit: TDBEdit;
    BldgStyDBEdit: TDBEdit;
    NeighDbEdit: TDBEdit;
    PropClsDBEdit: TDBEdit;
    SwisDBEdit: TDBEdit;
    GarageDBEdit: TDBEdit;
    FirePlDBEdit: TDBEdit;
    AcreageDBEdit: TDBEdit;
    SaveWeightingsButton: TButton;
    ApplyMinMaxButton: TButton;
    TemplateParcelLabel: TLabel;
    ComparablesTypeRadioGroup: TRadioGroup;
    GroupMemberStringGrid: TStringGrid;
    ResultsStringGrid: TStringGrid;
    PrintButton: TBitBtn;
    CloseButton: TBitBtn;
    ViewAnotherParcelButton: TBitBtn;
    SalePriceLabel: TLabel;
    CompAssDataSearchTable: TTable;
    CompASSDataSearchDataSource: TDataSource;
    ApplyNewCharactersticsButton: TBitBtn;
    DBText1: TDBText;
    DBText2: TDBText;
    DBText3: TDBText;
    DBText4: TDBText;
    DBText5: TDBText;
    DBText6: TDBText;
    DBText7: TDBText;
    DBText8: TDBText;
    DBText9: TDBText;
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
    CompDataTable: TwwTable;
    CompDataDataSource: TwwDataSource;
    SewerTable: TwwTable;
    RestoreMinMaxButton: TButton;
    NumberOfBedroomsEdit: TEdit;
    YearBuiltEdit: TEdit;
    SquareFootAreaEdit: TEdit;
    FirstFloorAreaEdit: TEdit;
    NumberOfStoriesEdit: TEdit;
    NumberOfBathsEdit: TEdit;
    Label1: TLabel;
    SaleDateMin: TEdit;
    SaleDateMax: TEdit;
    AssessmentTableTaxRollYr: TStringField;
    AssessmentTableSwisSBLKey: TStringField;
    AssessmentTableAssessmentDate: TDateField;
    AssessmentTableLandAssessedVal: TIntegerField;
    AssessmentTableTotalAssessedVal: TIntegerField;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure LocateTimerTimer(Sender: TObject);
    procedure CondMinExit(Sender: TObject);
    procedure SaveWeightingsButtonClick(Sender: TObject);
    procedure ApplyMinMaxButtonClick(Sender: TObject);
    procedure ComprablesTypeRadioGroupClick(Sender: TObject);
    procedure GroupStringGridEnter(Sender: TObject);
    procedure GroupStringGridSelectCell(Sender: TObject; Col, Row: Longint;
      var CanSelect: Boolean);
    procedure GroupStringGridKeyPress(Sender: TObject; var Key: Char);
    procedure ReportPrintHeader(Sender: TObject);
    procedure ReportPrint(Sender: TObject);
    procedure CompNotebookChange(Sender: TObject; NewTab: Integer;
      var AllowChange: Boolean);
    procedure PrintButtonClick(Sender: TObject);
    procedure ViewAnotherParcelButtonClick(Sender: TObject);
    procedure ResultsStringGridDrawCell(Sender: TObject; Col, Row: Longint;
      Rect: TRect; State: TGridDrawState);
    procedure ResultsStringGridDblClick(Sender: TObject);
    procedure GroupMemberStringGridDrawCell(Sender: TObject; Col,
      Row: Longint; Rect: TRect; State: TGridDrawState);
    procedure GroupMemberStringGridDblClick(Sender: TObject);
    procedure ApplyNewCharactersticsButtonClick(Sender: TObject);
    procedure MinimumOrMaximumChanged(Sender: TObject);
    procedure RestoreMinMaxButtonClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    PrintPoints,
    TemplateRecordFound : boolean;  {FXX11251998-1}
    SwisSBLKey : Str26;
    UnitName : String;
    NumErrors,
    NumParcels : LongInt;
    ErrorFile : TextFile;
    CompDataList : TList;  {contains all parcel records in group(s)}
    ResultsList : TList;  {contains copy of all of Compdata recs filtered by range settings}
                        {and ranked by points}

    FormAccessRights : Integer;  {Read only or read write, based on security level?}
                                {Values = raReadOnly, raReadWrite}
    GroupMembersSelected,
    GroupMembersShowing,
    ResultsSelected : TStringList;
    ParcelBookmarkAssigned : Boolean;
    ParcelBookmark : TBookmark;
    PASSettingMinMaxValues,
    MinMaxChanged : Boolean;
    MinimumAssessmentAmount,
    MaximumAssessmentAmount,
    MinimumSalePriceAmount,
    MaximumSalePriceAmount : Comp;

    Procedure InitializeForm;  {Open the tables and setup.}

    Procedure GetAssessmentGroupData(var  MinimumAssessment,
                                          MaximumAssessment,
                                          AssmentSqFoot    : Str15;
                                     var  GroupParcelCnt   : Longint;
                                          SrchSwis : Str6;
                                          SrchNeighborHood : Str5;
                                          SrchPropClass : Str3;
                                          SrchBldgStyle : Str2);

    Procedure GetSalesGroupData(var  MinimumSalePrice,
                                     MaximumSalePrice : Str15;
                                var  GroupParcelCnt   : Longint;
                                     SrchSwis : Str6;
                                     SrchNeighborHood : Str5;
                                     SrchPropClass : Str3;
                                     SrchBldgStyle : Str2;
                                Var  FoundGroup : boolean     );

    Function CompKeyMatch(SrchSwis : Str6;
                          SrchNeighborHood : Str5;
                          SrchPropClass : Str3;
                          SrchBldgStyle : Str2;
                          CompDataSearchTable : TTable) : Boolean;

    Function DetermineCodeTableName(Tag : Integer) : String;
    Function ParcelMeetsMinMaxCriteria(CompRec : CompdataREcord) : Boolean;
    Procedure FillGroupMembersList(SrchSwis : Str6;
                                   SrchNeighborHood : Str5;
                                   SrchPropClass : Str3;
                                   SrchBldgStyle : Str2;
                                   ParcelCount : Integer;
                                   CompDataTable : TTable;
                                   TemplateRecordFound : boolean);

    Procedure FillGroupMemberStringGrid(var GroupMemGridRows : Integer;
                                            StartCmpTLIdx,
                                            EndCmpTlIdx : Integer);

    Procedure ComputePoints(CompDataPtr : CompDataPointer;
                            CompDataTable : TTable);
    Procedure LoadMembersForGroup(SrchSwis : Str6;
                                  SrchNeighborHood : Str5;
                                  SrchPropClass : Str3;
                                  SrchBldgStyle : Str2;
                                  TemplateSBLKey : Str20;
                                  var Median : Double);

    Procedure AddOneGroupMemberToList(CompDataSearchTable : TTable;
                                      CompDataList : TList;
                                      TemplateRecordFound,
                                      IsTemplate : Boolean);

    Procedure SortResults(ResultsList : TList);
    Procedure SortResultsAndFillResultsStringGrid(ResultsList : Tlist);
    Procedure SetMinMaxScreenvariables(    CompMinMaxTable : TTable;
                                       var MinMaxScreenInitialized : Boolean);
    Procedure FillGroupMemberStringGridColDescrip;
    Function CompItemSelected(CompTLIdx : Integer): Boolean;
    Function ValidSwisCode(SwisCd : Str6) : Boolean;
    Function ValidGroupCode(ThisCode : String;
                            TableNameConstant : Integer) :Boolean;
    Procedure UpdateScreenMinMaxes(var MinimumAssessment,
                                       MaximumAssessment,
                                       MinimumSalePrice,
                                       MaximumSalePrice,
                                       AssmentSqFoot : Str15;
                                   var GroupParcelCnt : LongInt);

     Procedure FillGroupStringGrid(SwisCd : Str6;
                                             NeighborHood : Str5;
                                             PropClass : Str3;
                                             BldgStyle : Str2;
                                             GroupParcelCnt : Integer;
                                             ThisGrpMinVal : Str15;
                                             THisGrpMaxVal : Str15;
                                             ThisGrpAssmentSqFoot : Str15;
                                             GroupRow : Integer);

    Procedure LoadAndDisplayParcel(SwisSBLKey : Str26;
                                   SearchSwis : Str6;
                                   SearchNeighborHood : Str5;
                                   SearchPropClass : Str3;
                                   SearchBldgStyle : Str2);

  end;

implementation

uses Glblvars, WinUtils, Utilitys, PASUTILS, UTILEXSD,  PASTypes,
     GlblCnst, PrcLocat,Preview;

const
    {notebook page constants}
  TemplatePg = 0;
  GroupPg = 1;
  MinMaxPg = 2;
  ResultsPg = 5;
  WeightsPg = 4;
  GroupMembersPg = 3;

   {group array String grid data constants}
    {column constants}
  SBLGm = 0;
  SelectGm = 1;   {Y/N field}
  NameGm = 2;
  NeighborhoodGm = 3;
  PropertyClassGm = 4;
  BuildingStyleGm = 5;
  TASPGm = 6;   {for sales comp}
  AssessedValGm = 6;  {for assmt comp}
  PerSqFtGm = 7;
  ConditionGm = 8;
  GradeGm = 9;
  YearBuiltGm = 10;
  AcresGm = 11;
  SFLAGm = 12;
  NoBathsGm = 13;
  NobedsGm = 14;
  NoStoriesGm = 15;
  ECordGm = 16;
  NCordGm = 17;
  FinBaseGm = 18;
  FinAtticGM = 19;
  CentralAirGm = 20;
  I1StructCdGm = 21;
  I1YearBuiltGm = 22;
  I1CondCodeGm  = 23;
  I2StructCdGm = 24;
  I2YearBuiltGm = 25;
  I2CondCodeGm  = 26;
  I3StructCdGm = 27;
  I3YearBuiltGm = 28;
  I3CondCodeGm  = 29;
  SaleDateGm    = 30;  {sales}
  SalePriceUnadjGm = 31;
  SalePriceAdjGm   = 32;


   {Results Row  constants}
  SBLRs= 0;
  SelectedRs = 1;
  NameRs = 2;
  AddrRs = 3;
  PropertyClassRs = 4;
  NeighborhoodRs = 5;
  BuildingStyleRs = 6;
  AcresRs = 7;
  YearBuiltRs = 8;
  ConditionGradeRs = 9;
  SFLARs = 10;
  LAVRs = 11;
  SaleDateRs = 11;  {sales}
  TAVRs = 12;
  SalePriceUnadjRs = 12;  {Sales}
  AssmtSqFtRs = 13;
  SalePricePerSqFtRs = 13;  {Sales}
  WeightRs = 14;
  FirePlaceStoriesRs = 15;
  BedroomBathRs = 16;
  GarageRs = 17;
  FirstFloorAreaRs = 18;
  FinBaseRs = 19;
  FinAtticRs = 20;
  ZoningSewerRs = 21;
  WaterBasementRs = 22;
  CoordsRs = 23;
  CentralAirRs = 24;
  I1StructCdRs = 25;
  I1YearBuiltRs = 26;
  I1CondCodeRs  = 27;
  I2StructCdRs = 28;
  I2YearBuiltRs = 29;
  I2CondCodeRs  = 30;
  I3StructCdRs = 31;
  I3YearBuiltRs = 32;
  I3CondCodeRs  = 33;
  SalePriceAdjRs   = 34;


     {col width constants}
  SBLWGm = 94;
  NameWGm = 84;
  AssessedValWGM = 84;
  PerSqFtWGM = 84;


  {summary group String grid column values}
   SGStartCol = 0;
   SGSwisCol = 1;
   SGNeighborHoodCol = 2;
   SGPropertyClassCol = 3;
   SGBuildingStyleCol = 4;
   SGError            = 99;

   HighlightColor = clLime;


    {This is a unique number for each lookup box stored in that
     lookup's tag field. This is because we have only one code table and
     as they enter each lookup, we change the name of the code table to be
     the table for this lookup. To use this, set the tag field of each
     lookup combo box to a unique number and list it below.}

    {To use the hints, create unique numerical tags for each lookup combo box
     and list them below (LLL1).
     Also, put the constants of the lookups that will be description based
     in the DescriptionIndexedLookups array (LLL2).
     Then go to the DetermineCodeTableName procedure
     (LLL3) and change the table name assignments. Then set the OnEnter event
     for all LookupCombo boxes to CodeLookupEnter and the OnCloseUp for all
     LookupCombo boxes to SetCodeOnLookupCloseUp.}

  PropertyClass = 10;  {LLL1}
  NeighborhoodCode = 20;
  BuildingStyle = 30;
  Zoning = 40;
  Sewer = 50;
  Water = 60;
  Condition = 70;
  Grade = 80;
  BasementType = 90;
  SwisCode  = 100;


var
  TaxRollYr : Str4;
  MinMaxScreenInitialized,
  DoingAssmtComps : Boolean;   {if true, doing assmt comp, else doing sales comp}
  GroupMemGridRows : Integer;  {rows in group members Str grid}
  LastGroupGridCol : Integer;   {column in summary grp grid last entered}
     {used for setting screen variables}
  MinimumAssessment,
  MaximumAssessment,
  MinimumSalePrice,
  MaximumSalePrice,
  AssmentSqFoot    : Str15;
  GroupParcelCnt   : Longint;
  GrpItemError : Boolean; {if true, had error entereing grp key item in grp summ scr}

{$R *.DFM}

{========================================================}
Procedure TComparativesDisplayForm.FormActivate(Sender: TObject);

begin
  SetFormStateMaximized(Self);
end;

{========================================================}
Procedure TComparativesDisplayForm.InitializeForm;

var
  SwisCd : Str6;
  SBLKey : Str20;
  Found : Boolean;
  SwSblRec : SBLREcord;

begin
  ParcelBookmarkAssigned := False;
  ViewAnotherParcelButton.Enabled := False;
  PrintButton.Enabled := False;
  UnitName := 'CMPDISPL.PAS';  {mmm}
  CompNoteBook.PageINdex := 6;  {show select page for assmt or sls data}
  TaxRollyr := GlblNextYear;   {always go to next year for comparatives}
  NumErrors := 0;
  NumParcels := 0;
  GroupMemGridRows := 0;
  MinMaxScreenInitialized := False;

    {FXX12151998-2: Since the tax roll year being used to look up parcels is NY,
                    must open tables as NY, too - not as GlblProcessingType.}

  OpenTablesForForm(Self, NextYear);
  GrpItemError := False;

    {set column widths of larger groupMember columns}
  with GroupMemberStringGrid do
    begin
      ColWidths[SBLGm] :=  SBLWGm;
      ColWidths[NameGm] :=  NameWGm;
      ColWidths[AssessedValGm] :=  AssessedValWGm;
      ColWidths[PerSqFtgm] :=  PerSqFtWgm;
    end;

  CompDataList := TList.Create;
  ResultsList := TList.Create;

  AssessmentTableLandAssessedVal.DisplayFormat := CurrencyNormalDisplay;
  AssessmentTableTotalAssessedVal.DisplayFormat := CurrencyNormalDisplay;

  ResultsSelected := TStringList.Create;
  GroupMembersSelected := TStringList.Create;
  GroupMembersShowing := TStringList.Create;

  with GroupStringGrid do
    begin
      ColWidths[SGSwisCol] := 50;
      ColWidths[SGNeighborHoodCol] := 40;
      ColWidths[6] := 70;
      ColWidths[7] := 70;
      ColWidths[8] := 85;

    end;  {with GroupStringGrid do}

end;  {InitializeForm}

{====================================================================}
Function TComparativesDisplayForm.DetermineCodeTableName(Tag : Integer) : String;

{Based on the tag of the lookup combo box, what table should we open in the
 code table? Note that the constants below are declared right after the
 IMPLEMENTATION directive.}

begin
  case Tag of  {LLL3}
    PropertyClass : Result := 'ZPropClsTbl';
    NeighborhoodCode : Result := 'ZInvNghbrhdCodeTbl';
    BuildingStyle : Result := 'ZInvBuildStyleTbl';
    Zoning : Result := 'ZInvZoningCodeTbl';
    Sewer : Result := 'ZInvSewerTbl';
    Water : Result := 'ZInvWaterTbl';
    Condition : Result := 'ZInvConditionTbl';
    Grade : Result := 'ZInvGradeTbl';
    BasementType : Result := 'ZInvResBasementTbl';
    SwisCode : Result := 'NSwisTbl';

  end;  {case Tag of}

end;  {DetermineCodeTableName}

{===================================================================================}
Procedure TComparativesDisplayForm.GroupStringGridKeyPress(    Sender: TObject;
                                                           var Key: Char);

begin
  If (Key in [#13])
    then
      If ((GroupStringGrid.Col >= 1) and
          (GroupStringGrid.Col <= 4))
        then
          begin
            GroupStringGrid.Col := GroupStringGrid.Col + 1;
            GroupStringGrid.SetFocus;
          end;

end;  {GroupStringGridKeyPress}

{==================================================================================}
Procedure TComparativesDisplayForm.ComprablesTypeRadioGroupClick(Sender: TObject);

var
  Quit : Boolean;

begin
  DoingAssmtComps := (ComparablesTypeRadioGroup.ItemIndex = 0);

  CompDataSearchTable.Close;  {in case open from prior iteration}
  CompDataTable.Close;

  If DoingAssmtComps
    then
      begin
        CompDataSearchTable.TableName := 'CompAssmtDataFile';
        CompDataTable.TableName := 'CompAssmtDataFile';
        ResultsStringGrid.RowCount := I3CondCodeRs;

      end
    else
      begin
        CompDataSearchTable.TableName := 'CompSalesDataFile';
        CompDataTable.TableName := 'CompSalesDataFile';
        ResultsStringGrid.RowCount := SalePriceAdjRs;
          {FXX11251998-1 need to access assessment comp file for parcel }
          {characteristics when doing sales and template parcel has no sales}

        OpenTableForProcessingType(CompASSDataSearchTable, CompASSDataSearchTable.TableName, NextYear, Quit);
      end;

  OpenTableForProcessingType(CompDataSearchTable, CompDataSearchTable.TableName, NextYear, Quit);
  OpenTableForProcessingType(CompDataTable, CompDataTable.TableName, NextYear, Quit);

  LocateTimer.Enabled := True;

end;  {ComparitiveTypeRadioGroupClick}

{=================================================================}
Procedure TComparativesDisplayForm.ViewAnotherParcelButtonClick(Sender: TObject);

begin

  ComparablesTypeRadioGroup.ItemIndex := -1;
  CompNotebook.Visible := False;
  PrintButton.Enabled := False;
  ViewAnotherParcelButton.Enabled := False;
  ClearStringGrid(GroupStringGrid);

end;  {ViewAnotherParcelButtonClick}

{=================================================================================}
Procedure TComparativesDisplayForm.GroupStringGridEnter(Sender: TObject);

begin
  LastGroupGridCol := 0;
end;

{===========================================================================}
Function TComparativesDisplayForm.CompKeyMatch(SrchSwis : Str6;
                                               SrchNeighborHood : Str5;
                                               SrchPropClass : Str3;
                                               SrchBldgStyle : Str2;
                                               CompDataSearchTable : TTable) : Boolean;

begin
  If ((Take(6, SrchSwis) = Take(6, CompDataSearchTable.FieldByName('SwisCode').Text)) and
      (Take(5, SrchNeighborHood) = Take(5, CompDataSearchTable.FieldByName('NeighborHood').Text)) and
      (Take(3, SrchPropClass) = Take(3, CompDataSearchTable.FieldByName('PropertyClass').Text)) and
      (Take(2, SrchBldgStyle) = Take(2, CompDataSearchTable.FieldByName('BuildingStyleCode').Text)))
    then Result := True
    else Result := False;

end;  {CompKeyMatch}

{===========================================================================}
Procedure TComparativesDisplayForm.MinimumOrMaximumChanged(Sender: TObject);

{FXX01051999-3: Keep track of whether or not they change the minimum or maximum -
                if they have and add a new group, we will not reset the
                amounts.}

begin
    {Don't do it until after the initial values have been set and
     don't do if we are refreshing the values under program control - just
     if the user does it.}

  If (MinMaxScreenInitialized and
      (not PASSettingMinMaxValues))
    then MinMaxChanged := True;

end;  {MinimumOrMaximumChanged}

{===========================================================================}
Function TComparativesDisplayForm.ParcelMeetsMinMaxCriteria(CompRec : CompDataRecord) : Boolean;

var
  MeetsCriteria : Boolean;
  TempAcres : Double;

begin
  Result := True;

  with CompRec do
    begin
         {Calc acres first}

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

        {FXX06071999-2: Default to sales within 2 years only.}

      try
        If ((Roundoff(SaleDate, 0) <> 0) and
            (not DoingAssmtComps) and
            ((SaleDate < StrToDate(SaleDateMin.Text)) or
             (SaleDate > StrToDate(SaleDateMax.Text))) and
            ((Take(6, SwisCode) + Take(20, SBLKey)) <>
             Take(26, SwisSBLKey)))  {Not the template.}
          then Result := False;
      except
      end;

    end;  {with CompRec do}

end;  {ParcelMeetsMinMaxCriteria}

{===========================================================================}
Procedure TComparativesDisplayForm.ComputePoints(CompDataPtr :CompDataPointer;
                                                 CompDataTable : TTable);

{compute points for this record}

var
  TempPoints, TempAcres : Double;
  TempInt : Integer;

begin
  TempPoints := 0;

  with CompDataTable do
    begin
          {Absolute points}
          {FXX06091999-1: Need try excepts around all StrToInts.}

      try
        If (Take(6, FieldByName('SwisCode').Text) <> Take(6,CompDataPtr^.SwisCode))
          then TempPoints := TempPoints + StrToInt(SwisDbedit.Text);
      except
      end;

      try
        If (Take(3, PropertyClassLookup.Text) <> Take(3,CompDataPtr^.PropertyClass))
          then TempPoints := TempPoints + StrToInt(PropClsDbedit.Text);
      except
      end;

         {FXX12221998-5: Doing a take 3 on neighborhood - need to do a take 5.}

      try
        If (Take(5, NeighborHoodLookup.Text) <> Take(5,CompDataPtr^.NeighborHood))
           then TempPoints := TempPoints + StrToInt(NeighDbedit.Text);
      except
      end;

      try
        If (Take(2, BuildingStyleLookup.Text) <> Take(2,CompDataPtr^.BuildingStyleCode))
          then TempPoints := TempPoints + StrToInt(BldgStyDbedit.Text);
      except
      end;

      try
        If (Take(2, GradeLookup.Text) <> Take(2,CompDataPtr^.OverallGradeCode))
          then TempPoints := TempPoints + StrToInt(GradeDbedit.Text);
      except
      end;

      try
        If (Take(2, ConditionLookup.Text) <> Take(2,CompDataPtr^.ConditionCode))
          then TempPoints := TempPoints + StrToInt(CondDbedit.Text);
      except
      end;

      try
        TempInt := FieldByName('NumFireplaces').AsInteger;
        If (FieldByName('NumFireplaces').AsInteger <> CompDataPtr^.NumberOfFirePlaces)
          then TempPoints := TempPoints + StrToInt(FirePlDbedit.Text);
      except
      end;

      try
        If (FieldByName('AttachedGarCapacity').AsInteger <> CompDataPtr^.AttachedGarCapacity)
          then TempPoints := TempPoints + StrToInt(GarageDbedit.Text);
      except
      end;

      try
        TempPoints := TempPoints + (Abs(StrToInt(SquareFootAreaEdit.Text) -
                                        CompDataPtr^.SqFootLivingArea) *
                                       (StrToInt(SqFtDbEdit.Text)));
      except
      end;

      try
        TempPoints := TempPoints + (Abs(StrToInt(YearBuiltEdit.Text) -
                                        StrToInt(CompDataPtr^.ActualYearBuilt)) *
                                       (StrToInt(YrBuiltDbEdit.Text)));
      except
      end;

      try
        TempPoints := TempPoints + (Abs(StrToFloat(NumberOfStoriesEdit.Text) -
                                        CompDataPtr^.NumberOfStories) *
                                       (StrToInt(StoriesDbEdit.Text)));
      except
      end;

      try
        TempPoints := TempPoints + (Abs(StrToInt(NumberOfBedroomsEdit.Text) -
                                        CompDataPtr^.NumberOfBedrooms) *
                                       (StrToInt(BedroomsDbEdit.Text)));
      except
      end;

      try
        TempPoints := TempPoints + (Abs(StrToFloat(NumberOfBathsEdit.Text) -
                                        CompDataPtr^.NumberOfBathrooms) *
                                       (StrToInt(BathsDbEdit.Text)));
      except
      end;

      try
        TempAcres := GetAcres(FieldByName('Acreage').AsFloat,
                              FieldByName('Frontage').AsFloat,
                              FieldByName('Depth').AsFloat);
        TempPoints := TempPoints + (Abs(TempAcres - CompDataPtr^.Acreage) *
                                       (StrToInt(AcreageDbEdit.Text)));
      except
      end;

      TempPoints := RoundOff(TempPoints,0);
      CompDataPtr^.TotalPoints := TempPoints;

    end;  {with CompDataTable do}

end;  {ComputePoints}

{===========================================================================}
Procedure TComparativesDisplayForm.AddOneGroupMemberToList(CompDataSearchTable : TTable;
                                                           CompDataList : TList;
                                                           TemplateRecordFound,
                                                           IsTemplate : Boolean);

var
  TempAcres : Double;
  CompDataPtr : CompDataPointer;

begin
  New(CompDataPtr);

  with CompDataSearchTable do
    begin
      TempAcres := GetAcres(FieldByName('Acreage').AsFloat,
                            FieldByName('Frontage').AsFloat,
                            FieldByName('Depth').AsFloat);

      CompDataPtr^.SwisCode        :=   FieldByName('SwisCode').Text;
      CompDataPtr^.SBLKey          :=   FieldByName('SBLKey').Text;
      CompDataPtr^.Site            :=   FieldByName('Site').AsInteger;

        {For template record, we must take the values from the front screen
         instead of from the record since they may have changed the values.}

      If IsTemplate
        then CompDataPtr^.PropertyClass := PropertyClassLookup.Text
        else CompDataPtr^.PropertyClass := FieldByName('PropertyClass').Text;

      If IsTemplate
        then CompDataPtr^.NeighborHood := NeighborhoodLookup.Text
        else CompDataPtr^.NeighborHood := FieldByName('NeighborHood').Text;

      If IsTemplate
        then CompDataPtr^.BuildingStyleCode := BuildingStyleLookup.Text
        else CompDataPtr^.BuildingStyleCode := FieldByName('BuildingStyleCode').Text;

      If IsTemplate
        then CompDataPtr^.ActualYearBuilt := YearBuiltEdit.Text
        else CompDataPtr^.ActualYearBuilt := FieldByName('ActualYearBuilt').Text;

      If IsTemplate
        then CompDataPtr^.ZoningCode := ZoningLookup.Text
        else CompDataPtr^.ZoningCode := FieldByName('ZoningCode').Text;

      If IsTemplate
        then CompDataPtr^.SewerTypeCode := SewerLookup.Text
        else CompDataPtr^.SewerTypeCode := FieldByName('SewerTypeCode').Text;

      If IsTemplate
        then CompDataPtr^.WaterSupplyCode := WaterLookup.Text
        else CompDataPtr^.WaterSupplyCode := FieldByName('WaterSupplyCode').Text;

      If IsTemplate
        then CompDataPtr^.ConditionCode := ConditionLookup.Text
        else CompDataPtr^.ConditionCode := FieldByName('ConditionCode').Text;

      If IsTemplate
        then CompDataPtr^.OverallGradeCode := GradeLookup.Text
        else CompDataPtr^.OverallGradeCode := FieldByName('OverallGradeCode').Text;

      If IsTemplate
        then
          try
            CompDataPtr^.SqFootLivingArea := StrToInt(SquareFootAreaEdit.Text)
          except
            CompDataPtr^.SqFootLivingArea := 0;
          end
        else CompDataPtr^.SqFootLivingArea := FieldByName('SqFootLivingArea').AsInteger;

      If IsTemplate
        then
          try
            CompDataPtr^.FirstStoryArea := StrToInt(FirstFloorAreaEdit.Text)
          except
            CompDataPtr^.FirstStoryArea := 0;
          end
        else CompDataPtr^.FirstStoryArea := FieldByName('FirstStoryArea').AsInteger;

      If IsTemplate
        then
          try
            CompDataPtr^.NumberOfStories := StrToFloat(NumberOfStoriesEdit.Text)
          except
            CompDataPtr^.NumberOfStories := 0;
          end
        else CompDataPtr^.NumberOfStories := FieldByName('NumberOfStories').AsFloat;

      If IsTemplate
        then
          try
            CompDataPtr^.NumberOfBedrooms := StrToInt(NumberofBedroomsEdit.Text);
          except
            CompDataPtr^.NumberOfBedrooms := 0;
          end
        else CompDataPtr^.NumberOfBedrooms := FieldByName('NumberOfBedrooms').AsInteger;

      If IsTemplate
        then
          try
            CompDataPtr^.NumberOfBathrooms := StrToFloat(NumberOfBathsEdit.Text);
          except
            CompDataPtr^.NumberOfBathrooms := 0;
          end
        else CompDataPtr^.NumberOfBathrooms := FieldByName('NumberOfBathrooms').AsFloat;

      If IsTemplate
        then CompDataPtr^.BasementCode := BasementTypeLookup.Text
        else CompDataPtr^.BasementCode := FieldByName('BasementCode').Text;

      CompDataPtr^.NumberOfFirePlaces:= FieldByName('NumFireplaces').AsInteger;
      CompDataPtr^.Acreage          :=  TempAcres;
      CompDataPtr^.Frontage         :=  FieldByName('Frontage').AsFloat;
      CompDataPtr^.Depth            :=  FieldByName('Depth').AsFloat;
      CompDataPtr^.AttachedGarCapacity:=FieldByName('AttachedGarCapacity').AsInteger;
      CompDataPtr^.EastCoord         := FieldByName('EastCoord').AsInteger;
      CompDataPtr^.NorthCoord        := FieldByName('NorthCoord').AsInteger;
      CompDataPtr^.Name              := ParcelTable.FieldByName('Name1').Text;
      CompDataPtr^.LegalAddr        := GetLegalAddressFromTable(ParcelTable);

      If DoingAssmtComps
        then
          begin
            CompDataPtr^.LandAssessedVal  :=
                  AssessmentSearchTable.FieldByName('LandAssessedVal').AsFloat;
            CompDataPtr^.TotalAssessedVal  :=
                  AssessmentSearchTable.FieldByName('TotalAssessedVal').AsFloat;

            try
              CompDataPtr^.AsValPrSqFt := AssessmentSearchTable.FieldByName('TotalAssessedVal').AsFloat/
                            FieldByName('SqFootLivingArea').AsFloat;   {www}
            except
              CompDataPtr^.AsValPrSqFt := 0;
            end;
          end
        else
          begin
            If (TemplateRecordFound or
                (not IsTemplate))
              then
                begin
                  CompDataPtr^.UnAdjustedSalesPrice := FieldByName('UnadjustedSalesPrice').AsFloat;
                  CompDataPtr^.TimeAdjSalesPrice := FieldByName('TimeAdjSalesPrice').AsFloat;
                  CompDataPtr^.SaleDate := FieldByName('SaleDate').AsFloat;
                  try
                    with CompDataPtr^ do
                      SalePricePerSqFt := UnAdjustedSalesPrice / FieldByName('SqFootLivingArea').AsFloat;
                  except
                    CompDataPtr^.SalePricePerSqFt := 0;
                  end;

                end
              else
                begin
                  CompDataPtr^.UnadjustedSalesPrice := 0;
                  CompDataPtr^.TimeAdjSalesPrice := 0;
                  CompDataPtr^.SaleDate := 0;
                  CompDataPtr^.SalePricePerSqFt := 0;
                end;

          end;  {else of If DoingAssmtComps}

      CompDataPtr^.FinishedBasementArea :=  FieldByName('FinishedBasementArea').AsInteger;
      CompDataPtr^.FinishedAtticArea :=  FieldByName('FinishedAtticArea').AsInteger;
      CompDataPtr^.CentralAir :=  FieldByName('CentralAir').AsBoolean;
      CompDataPtr^.Imp1StructureCode :=  FieldByName('Imp1StructureCode').Text;
      CompDataPtr^.Imp1YearBuilt :=  FieldByName('Imp1YearBuilt').Text;
      CompDataPtr^.Imp1ConditionCode :=  FieldByName('Imp1ConditionCode').Text;
      CompDataPtr^.Imp2StructureCode :=  FieldByName('Imp2StructureCode').Text;
      CompDataPtr^.Imp2YearBuilt :=  FieldByName('Imp2YearBuilt').Text;
      CompDataPtr^.Imp2ConditionCode :=  FieldByName('Imp2ConditionCode').Text;
      CompDataPtr^.Imp3StructureCode :=  FieldByName('Imp3StructureCode').Text;
      CompDataPtr^.Imp3YearBuilt :=  FieldByName('Imp3YearBuilt').Text;
      CompDataPtr^.Imp3ConditionCode :=  FieldByName('Imp3ConditionCode').Text;

       {compute points for this record}

     If TemplateRecordFound
       then ComputePoints(CompDataPtr, CompDataTable)
       else ComputePoints(CompDataPtr, CompAssDataSearchTable); {FXX11251998-1}

     CompDataList.Add(CompDataPtr);

   end;  {with CompDataSearchTable do}

end;  {AddOneGroupMemberToList}

{===========================================================================}
Procedure TComparativesDisplayForm.LoadMembersForGroup(    SrchSwis : Str6;
                                                           SrchNeighborHood : Str5;
                                                           SrchPropClass : Str3;
                                                           SrchBldgStyle : Str2;
                                                           TemplateSBLKey : Str20;
                                                       var Median : Double);

var
  Found, Done, Matches, FirstTimeThrough : Boolean;
  SBLRec : SBLRecord;
  SwisSBLKey : Str26;
  TempNum, Mean, COD : Double;
  Index : Integer;
  AV_SF_List : TStringList;

begin
  Done := False;
  AV_SF_List := TStringList.Create;
  FindNearestOld(CompDataSearchTable,
                 ['SwisCode', 'Neighborhood',
                  'PropertyClass', 'BuildingStyleCode'],
                 [SrchSwis, SrchNeighborHood, SrchPropClass,
                  Take(5, SrchBldgStyle)]);

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else CompDataSearchTable.Next;

    Matches := CompKeyMatch(SrchSwis, SrchNeighborHood, SrchPropClass, SrchBldgStyle, CompDataSearchTable);

    If (CompDataSearchTable.EOF or
        (not Matches))
      then Done := True;

    If ((not Done) and
        Matches and
        (Take(20, TemplateSBLKey) <> Take(20, CompDataSearchTable.FieldByName('SBLKey').Text)))
      then
        begin
          with CompDataSearchTable do
            SwisSBLKey := FieldByName('SwisCode').Text + FieldByName('SBLKey').Text;

          If DoingAssmtComps
            then Found := FindKeyOld(AssessmentSearchTable,
                                     ['TaxRollYr', 'SwisSBLKey'],
                                     [TaxRollYr, SwisSBLKey])
            else Found := True; {for sales leg no need to find assmt rec}

          If Found
            then
              begin
                SBLRec := ExtractSwisSBLFromSwisSBLKey(SwisSBLKey);

                with SBLRec do
                  Found := FindKeyOld(ParcelTable,
                                      ['TaxRollYr', 'SwisCode', 'Section',
                                       'Subsection', 'Block', 'Lot', 'Sublot',
                                       'Suffix'],
                                      [TaxRollYr, SwisCode,
                                       Section, Subsection, Block,
                                       Lot, Sublot, Suffix]);

                AddOneGroupMemberToList(CompDataSearchTable, CompDataList, TemplateRecordFound, False);

              end;  {If Found}

        end;  {If ((not Done) and...}

    If ((not Done) and
        Matches)
      then
        begin
          try
            If (Take(20, TemplateSBLKey) = Take(20, CompDataSearchTable.FieldByName('SBLKey').Text))
              then Index := 0
              else Index := CompDataList.Count - 1;

            If DoingAssmtComps
              then TempNum := CompDataPointer(CompDataList[Index])^.AsValPrSqFt
              else TempNum := CompDataPointer(CompDataList[Index])^.SalePricePerSqFt;

          except
            TempNum := 0;
          end;

          try
            AV_SF_List.Add(FloatToStr(TempNum));
          except
            AV_SF_List.Add('0');
          end;

        end;  {If ((not Done) and ...}

  until Done;

  SortListAndGetStats(AV_SF_List, Median, Mean, COD);

  AV_SF_List.Free;

end;  {LoadMembersForGroup}

{===========================================================================}
Procedure TComparativesDisplayForm.FillGroupMembersList(SrchSwis : Str6;
                                                        SrchNeighborHood : Str5;
                                                        SrchPropClass : Str3;
                                                        SrchBldgStyle : Str2;
                                                        ParcelCount : Integer;
                                                        CompDataTable : TTable;
                                                        TemplateRecordFound : boolean);

 {compdata table is either compassmtdata table or compsalesdatatable}
{load the tlist with all parcels currently in group..ignore ranges}

var
  I, GridRows : Integer;
  SBLRec : SBLRecord;
  Found : Boolean;
  Median : Double;
  TempTable : TTable;
  TempStr, TempIndexName : String;

begin
      {FXX01041999-3: Synch the search table with the main table - was out of
                      synch when changed characteristics.}

  CompDataTable.GotoBookmark(ParcelBookmark);
  TempStr := CompDataTable.FieldByName('SBLKey').Text;

  SBLRec := ExtractSwisSBLFromSwisSBLKey(SwisSBLKey);

  with SBLRec do
    Found := FindKeyOld(ParcelTable,
                        ['TaxRollYr', 'SwisCode', 'Section',
                         'Subsection', 'Block', 'Lot', 'Sublot',
                         'Suffix'],
                        [TaxRollYr, SwisCode, Section,
                         Subsection, Block,
                         Lot, Sublot, Suffix]);

  FindKeyOld(AssessmentSearchTable,
             ['TaxRollYr', 'SwisSBLKey'],
             [TaxRollYr, SwisSBLKey]);

      {FXX06082000-1: Goto current was not working because it was on the wrong index.}

  TempIndexName := CompDataSearchTable.IndexName;
  CompDataSearchTable.IndexName := 'BYSWISCODE_SBLKEY_SITE';

  CompDataSearchTable.GotoCurrent(CompDataTable);
  CompDataSearchTable.IndexName := TempIndexName;
  TempStr := CompDataSearchTable.FieldByName('SBLKey').Text;

  If TemplateRecordFound
    then TempTable := CompDataSearchTable
    else TempTable := CompAssDataSearchTable;  {If there is no template for sales,
                                                use assessment record.}

     {FXX11251998-1 ..if no sales comp data record for template, we must make up }
     {one from all data we have execpt sales data and put it in grid}
     {FXX01041999-5: Actually, always add the template parcel seperately and
                     exclude in LoadMemberToList to avoid problems with duplicate
                     template entries after changing characteristics.}

  AddOneGroupMemberToList(TempTable, CompDataList, TemplateRecordFound, True);

    {Now go through each parcel in the groups listed in the group members grid and add meembers.}

  with GroupStringGrid do
    For I := 1 to (RowCount - 1) do
      If (Deblank(Cells[1, I]) <> '')
        then
          begin
            LoadMembersForGroup(Cells[1, I], Cells[2, I], Cells[3, I], Cells[4, I],
                                Copy(SwisSBLKey, 7, 20), Median);

            Cells[8, I] := FormatFloat(DecimalDisplay, Median);

          end;  {If (Deblank(Cells[1, I]) <> '')}

    {Originally select all group members.}

  with GroupMembersSelected do
    begin
      Clear;

      For I := 0 to (CompDataList.Count - 1) do
        Add('Y');

    end;  {with GroupMembersSelected do}

    {Originally display all group members.}

  with GroupMembersShowing do
    begin
      Clear;

      For I := 0 to (CompDataList.Count - 1) do
        Add('Y');

    end;  {with GroupMembersShowing do}

end;  {FillGroupMembersList}

{===========================================================================}
Procedure TComparativesDisplayForm.SortResults(ResultsList : Tlist);

var
  TempResultsPtr : CompDataPointer;
  I, J : Integer;

begin
  {bubble sort: if next item in list < current item, move next to cur, cur to next}
  {..note that lower pooints is better (closer match to template) so lower pointed}
  {parcels move up to nearer the front of the results tlist}

  For I := 0 to (ResultsList.Count - 1) do
    For J := (I + 1) to (ResultsList.Count - 1) do
      If (ResultsPointer(ResultsList[I])^.TotalPoints > ResultsPointer(ResultsList[J])^.TotalPoints)
        then
          begin
            TempResultsPtr :=  ResultsList[I];
            ResultsList[I] := ResultsList[J];
            ResultsList[J] := TempResultsPtr;
          end;

end;  {SortResults}

{===========================================================================}
Procedure TComparativesDisplayForm.SortResultsAndFillResultsStringGrid(ResultsList : Tlist);

var
  EndIndex, I, J, K, GridCol, PrclCnt : Integer;
  SwisSBLKey : Str26;
  TempStr : Str30;
  MinAmt, MaxAmt : Double;

begin
  PrclCnt := 0;

  ResultsSelected.Clear;

    {First unselect all results.}

  For I := 0 to (ResultsList.Count - 1) do
    ResultsSelected.Add('N');

    {Select the 1st 7 (includes template.}

  If (ResultsList.Count < 9)
    then EndIndex := ResultsList.Count
    else EndIndex := 9;

  For I := 0 to (EndIndex - 1) do
    ResultsSelected[I] := 'Y';

  try
    If DoingAssmtComps
      then
        begin
          MinAmt := ResultsPointer(ResultsList[0])^.TotalAssessedVal;
          MaxAmt := ResultsPointer(ResultsList[0])^.TotalAssessedVal;
        end
      else
        begin
          MinAmt := ResultsPointer(ResultsList[0])^.UnAdjustedSalesPrice;
          MaxAmt := ResultsPointer(ResultsList[0])^.UnAdjustedSalesPrice;
       end;
  except
    MinAmt := 0;
    MaxAmt := 0;
  end;

    {Determine minimum and maximum assessmnets (sales prices).}
    {FXX010141999-4: Only include those group members actually showing in the
                     members grid.}

  For I := 0 to (ResultsList.Count - 1) do
    begin
      If DoingAssmtComps
        then
          begin
            If (ResultsPointer(ResultsList[I])^.TotalAssessedVal < MinAmt)
              then MinAmt := ResultsPointer(ResultsList[I])^.TotalAssessedVal;
            If (ResultsPointer(ResultsList[I])^.TotalAssessedVal > MaxAmt)
              then MaxAmt := ResultsPointer(ResultsList[I])^.TotalAssessedVal;
          end
        else
          begin
            If (ResultsPointer(ResultsList[I])^.UnAdjustedSalesPrice < MinAmt)
              then MinAmt := ResultsPointer(ResultsList[I])^.UnAdjustedSalesPrice;
            If (ResultsPointer(ResultsList[I])^.UnAdjustedSalesPrice > MaxAmt)
              then MaxAmt := ResultsPointer(ResultsList[I])^.UnAdjustedSalesPrice;
          end;

      PrclCnt := PrclCnt + 1;

    end;  {For I := 0 to (ResultsList.Count - 1) do}

  If DoingAssmtComps
    then
      begin
        Pg1MinLblLbl.Caption := 'Minimum Assmt';
        Pg1MaxLblLbl.Caption := 'Maximum Assmt';
        Pg2MinLblLbl.Caption := 'Minimum Assmt';
        Pg2MaxLblLbl.Caption := 'Maximum Assmt';
      end
    else
      begin
        Pg1MinLblLbl.Caption := 'Minimum SlsPrc';
        Pg1MaxLblLbl.Caption := 'Maximum SlsPrc';
        Pg2MinLblLbl.Caption := 'Minimum SlsPrc';
        Pg2MaxLblLbl.Caption := 'Maximum SlsPrc';
      end;

    {FXX06071999-3: Trying to catch a convert error.}

  try
    Pg1ParcelCntLabel.Caption := IntToStr(PrclCnt);
  except
    Pg1ParcelCntLabel.Caption := '';
  end;

  try
    Pg2ParcelCntLabel.Caption := IntToStr(PrclCnt);
  except
    Pg2ParcelCntLabel.Caption := '';
  end;

  Pg1MinDataLbl.Caption := FormatFloat(CurrencyNormalDisplay, MinAmt);
  Pg1MaxDataLbl.Caption := FormatFloat(CurrencyNormalDisplay, MaxAmt);
  P2MinAssLabel.Caption := FormatFloat(CurrencyNormalDisplay, MinAmt);
  Pg2MaxAssLabel.Caption := FormatFloat(CurrencyNormalDisplay, MaxAmt);

  Pg1MinDataLbl.Repaint;
  Pg1MaxDataLbl.Repaint;
  Pg2MinLblLbl.Repaint;
  Pg2MaxLblLbl.Repaint;
  Pg2ParcelCntLabel.Repaint;
  Pg2ParcelCntLabel.Repaint;
  P2MinAssLabel.Repaint;
  Pg2MaxAssLabel.Repaint;

  SortResults(ResultsList);  {sort in ascending point order}

  If DoingAssmtComps
    then ResultsStringGrid.RowCount := I3CondCodeRs
    else ResultsStringGrid.RowCount := SalePriceAdjRs;

  ClearStringGrid(ResultsStringGrid);

  GridCol := 0;
  {put hdr descrip in grid}

  with ResultsStringGrid do
    begin
      Cells[GridCol,SBLrs] := 'Parcel ID';
      Cells[GridCol, SelectedRs] := 'Print';
      Cells[GridCol,NameRs] := 'Name';
      Cells[GridCol,AddrRs] := 'Addr';

      Cells[GridCol,PropertyClassRs] := 'Prop Class';
      Cells[GridCol,NeighborhoodRs] := 'Neighborhood';
      Cells[GridCol,AcresRs] := 'Acres';
      Cells[GridCol,BuildingStyleRs] := 'Bldg Style';
      Cells[GridCol,YearBuiltRs] := 'Year Built';
      Cells[GridCol,ConditionGradeRs] := 'Cond/Grade';
      Cells[GridCol,FirePlaceStoriesRs] := '# Frplc/Stories';
      Cells[GridCol,BedroomBathRs] := '# Beds/Baths';
      Cells[GridCol,SFLARs] := 'SFLA';
      Cells[GridCol,GarageRs] := 'Att Garage';

      If DoingAssmtComps
        then
          begin
            Cells[GridCol,LAVRs] := 'Land AV';
            Cells[GridCol,TAVRs] := 'Total AV';
            Cells[GridCol,AssmtSqFtRs] := 'Assmt/SqFt';
          end
        else
          begin
            Cells[GridCol, SaleDateRs] := 'Sale Date';
            Cells[GridCol, SalePriceUnadjRs] := 'Sale Price';
            Cells[GridCol, SalePricePerSqFtRs] := 'Price/SqFt';
          end;

      Cells[GridCol,WeightRs] := 'Weight';

      Cells[GridCol, FirstFloorAreaRs] := '1st Floor Area';
      Cells[GridCol, FinBaseRs] := 'Fin Basement';
      Cells[GridCol, FinAtticRs] := 'Fin Attic';
      Cells[GridCol, ZoningSewerRs] := 'Zoning\Sewer';
      Cells[GridCol, WaterBasementRs] := 'Water\Bsmt';
      Cells[GridCol, CoordsRs] := 'E\N Coord';

      Cells[GridCol,CentralAirRs] := 'Central Air';
      Cells[GridCol,I1StructCdRs] := 'Imp1 - Structure';
      Cells[GridCol,I1YearBuiltRs]:= 'Imp1 - Yr Built';
      Cells[GridCol,I1CondCodeRs] := 'Imp1 - Condition';
      Cells[GridCol,I2StructCdRs] := 'Imp2 - Structure';
      Cells[GridCol,I2YearBuiltRs]:= 'Imp2 - Yr Built';
      Cells[GridCol,I2CondCodeRs] := 'Imp2 - Condition';
      Cells[GridCol,I3StructCdRs] := 'Imp3 - Structure';
      Cells[GridCol,I3YearBuiltRs]:= 'Imp3 - Yr Built';
      Cells[GridCol,I3CondCodeRs] := 'Imp3 - Condition';

      If not DoingAssmtComps
        then Cells[GridCol,SalePriceAdjRs] := 'Time Adj Sls Price';

      For I := 1 to ResultsList.Count do
        with ResultsPointer(ResultsList[I-1])^ do
          begin
            GridCol := GridCol + 1;
            ColCount := GRidCol + 1;  {expand width of grid to handle all parcels}
            SwisSBLKey := SwisCode + SBLKey;
            Cells[GridCol,SBLRs] := ConvertSBLOnlyToDashDot(Copy(SwisSBLKey, 7, 20));
            Cells[GridCol,NameRs] := Name;
            Cells[GridCol,AddrRs] := LegalAddr;
            Cells[GridCol,PropertyClassRs] := PropertyClass;
            Cells[GridCol,NeighborhoodRs] := Neighborhood;
            Cells[GridCol,AcresRs] := FormatFloat(DecimalDisplay, Acreage);
            Cells[GridCol,BuildingStyleRs] := BuildingStyleCode;
            Cells[GridCol,YearBuiltRs] := ActualYearBuilt;
            Cells[GridCol,ConditionGradeRs] := Rtrim(ConditionCode) + ' / ' + Deblank(OverAllGradeCode);

            try
              Cells[GridCol,FireplaceStoriesRs] := IntToStr(NumberOfFireplaces) + ' / ' +
                                                   FormatFloat(DecimalDisplay, NumberOfStories);
            except
              Cells[GridCol,FireplaceStoriesRs] := '';
            end;

            try
              Cells[GridCol,BedRoomBathRs] := IntToStr(NumberOfBedrooms) + ' / ' +
                                              FormatFloat(DecimalDisplay, NumberOfBathrooms);
            except
              Cells[GridCol,BedRoomBathRs] := '';
            end;

            Cells[GridCol,SFLARs] := FormatFloat(IntegerDisplay, SqFootLivingArea);

            try
              Cells[GridCol,GarageRs] := IntToStr(AttachedGarCapacity);
            except
              Cells[GridCol,GarageRs] := '';
            end;

            If DoingAssmtComps
              then
                begin
                  Cells[GridCol,LAVRs] := FormatFloat(CurrencyNormalDisplay, LandAssessedVal);
                  Cells[GridCol,TAVRs] := FormatFloat(CurrencyNormalDisplay, TotalAssessedVal);
                  Cells[GridCol,AssmtSqFtRs] := FormatFloat(_3DecimalDisplay, AsValPrSqFt);
                end
              else
                begin
                  TempStr := DateToStr(SaleDate);

                  If (TempStr = '0/0/0000')
                    then TempStr := '';

                  Cells[GridCol, SaleDateRs] := TempStr;
                  Cells[GridCol, SalePriceUnadjRs] := FormatFloat(CurrencyNormalDisplay, UnadjustedSalesPrice);
                  Cells[GridCol, SalePricePerSqFtRs] := FormatFloat(_3DecimalDisplay, SalePricePerSqFt);

                end;  {else of If DoingAssmtComps}

            Cells[GridCol,WeightRs] := FormatFloat(NoDecimalDisplay, TotalPoints);
            Cells[GridCol, FirstFloorAreaRs] := FormatFloat(IntegerDisplay, FirstStoryArea);

            try
              Cells[GridCol,FinBaseRs] := IntToStr(FinishedBasementArea);
            except
              Cells[GridCol,FinBaseRs] := '';
            end;

            try
              Cells[GridCol,FinAtticRs] := IntToStr(FinishedAtticArea);
            except
              Cells[GridCol,FinAtticRs] := '';
            end;

            Cells[GridCol, ZoningSewerRs] := ZoningCode + '\' + SewerTypeCode;
            Cells[GridCol, WaterBasementRs] := WaterSupplyCode + '\' + BasementCode;

            try
              Cells[GridCol, CoordsRs] := IntToStr(EastCoord) + '\' + IntToStr(NorthCoord);
            except
              Cells[GridCol, CoordsRs] := '';
            end;

            If CentralAir
               then Cells[GridCol,CentralAirRs] := 'YES'
               else Cells[GridCol,CentralAirRs] := 'NO';
            Cells[GridCol,I1StructCdRs] := Imp1StructureCode;
            Cells[GridCol,I1YearBuiltRs]:= Imp1YearBuilt;
            Cells[GridCol,I1CondCodeRs] := Imp1ConditionCode;
            Cells[GridCol,I2StructCdRs] := Imp2StructureCode;
            Cells[GridCol,I2YearBuiltRs]:= Imp2YearBuilt;
            Cells[GridCol,I2CondCodeRs] := Imp2ConditionCode;
            Cells[GridCol,I3StructCdRs] := Imp3StructureCode;
            Cells[GridCol,I3YearBuiltRs]:= Imp3YearBuilt;
            Cells[GridCol,I3CondCodeRs] := Imp3ConditionCode;

            If not DoingAssmtComps
              then Cells[GridCol,SalePriceAdjRs] := FormatFloat(CurrencyNormalDisplay, TimeadjSalesPrice);

          end;  {with ResultsPointer(ResultsList[I-1])^ do}

      Repaint;

    end;  {with ResultsStringGrid do}

end;  {SortResultsAndFillResultsStringGrid}

{===========================================================================}
 Procedure TComparativesDisplayForm.FillGroupMemberStringGridColDescrip;

 var
   GridRows : Integer;

 begin
  GridRows := 0;

   {put hdr descrip in grid}

  with GroupMemberStringGrid do
    begin
      Cells[SBLGm,GridRows] := 'Parcel ID';
      Cells[SelectGm,GridRows] := 'Use(Y/N)';
      Cells[NameGm,GridRows] := 'Name';
      Cells[NeighborhoodGm,GridRows] := 'Nbhd';
      Cells[PropertyClassGm,GridRows] := 'Prp Cls';
      Cells[BuildingStyleGm,GridRows] := 'Bld Style';
      If DoingAssmtComps
         then Cells[AssessedValGm,GridRows] := 'Assessed Val'
         else Cells[TASPGm,GridRows] := 'Sale Price';
      Cells[ConditionGm,GridRows] := 'Cond';
      Cells[GradeGm,GridRows] := 'Grade';
      Cells[YearBuiltGm,GridRows] := 'Year Blt';
      Cells[AcresGm,GridRows] := 'Acres';
      Cells[SFLAGm,GridRows] := 'SFLA';
      Cells[NoBathsGm,GridRows] := '# Baths';
      Cells[NoBedsGm,GridRows] := '# Beds';
      Cells[NoStoriesGm,GridRows] := '# Stories';
      Cells[ECordGm,GridRows] := 'E Crd';
      Cells[NCordGm,GridRows] := 'N Crd';

      If DoingAssmtComps
        then Cells[PerSqFtGm,GridRows] := 'AV/SqFt'
        else Cells[PerSqFtGm,GridRows] := 'Prc/SqFt';

      Cells[FinBaseGm,GridRows] := 'Fin Bsmt';
      Cells[FinAtticGm,GridRows] := 'Fin Attic';
      Cells[CentralAirGm,GridRows] := 'Cent Air';
      Cells[I1StructCdGm,GridRows] := 'I1 Strct';
      Cells[I1YearBuiltGm,GridRows] := 'I1 Year';
      Cells[I1CondCodeGm,GridRows] := 'I1 Cond';
      Cells[I2StructCdGm,GridRows] := 'I2 Strct';
      Cells[I2YearBuiltGm,GridRows] := 'I2 Year';
      Cells[I2CondCodeGm,GridRows] := 'I2 Cond';
      Cells[I3StructCdGm,GridRows] := 'I3 Strct';
      Cells[I3YearBuiltGm,GridRows] := 'I3 Year';
      Cells[I3CondCodeGm,GridRows] := 'I3 Cond';
      Cells[SaleDateGm,GridRows] := 'Sls Date';
      Cells[SalePriceUnadjGm,GridRows] := 'Unadj Prc';
      Cells[SalepriceAdjGm,GridRows] := 'Adj Prc';

    end;  {with GroupMemberStringGrid do}

 end;  {FillGroupMemberStringGridColDescrip}

{===========================================================================}
Procedure TComparativesDisplayForm.FillGroupMemberStringGrid(var GroupMemGridRows : Integer;
                                                                 StartCmpTLIdx,
                                                                 EndCmpTlIdx : Integer);

var
  Found : Boolean;
  SBLRec : SBLRecord;
  SwisSBLKey : Str26;
  NumShowing, ParcelCnt, I, J, K, GridIdx : Integer;
  MinAv, MaxAv, TempAcres : double;
  ResultsPtr : CompDataPointer;

begin
  ParcelCnt := 0;
  MinAv := 0;
  MaxAv := 0;
  ClearStringGrid(GroupMemberStringGrid);
  GroupMemGridRows := 0;
  GroupMemberStringGrid.RowCount := 1;

  FillGroupMemberStringGridColDescrip;

    {Must set min and max starting points to same TAV for 1st parcel in list,}
    {as we loop thru list, the min/max valuse will diverge}

  try
    MinAv := CompDataPointer(CompDataList[0])^.TotalAssessedVal;
    MaxAv := CompDataPointer(CompDataList[0])^.TotalAssessedVal;
  except
    MinAV := 0;
    MaxAV := 0;
  end;

    {fill in String grid with specified range of items in Tlist}

  For I := 0 to (CompDataList.Count - 1) do
    with GroupMemberStringGrid, CompDataPointer(CompDataList[I])^ do
      begin
        SwisSBLKey := SwisCode + SBLKey;

        If (ParcelMeetsMinMaxCriteria(CompDataPointer(CompDataList[I])^) or
            (I = 0)) {The 0th element is ALWAYS the template and must be included.}
          then
            begin
              GroupMembersShowing[I] := 'Y';
              GroupMemGridRows := GroupMemGridRows + 1;
              RowCount := RowCount + 1;
              ParcelCnt := ParcelCnt + 1;

              If DoingAssmtComps
                then
                  begin
                    If (MinAV > TotalAssessedVal)
                      then MinAV := TotalAssessedVal;
                    If (MaxAV < TotalAssessedVal)
                      then MaxAV := TotalAssessedVal;
                  end;

              TempAcres := GetAcres(Acreage,Frontage,Depth);

                 {Fill in this row of grid with parcel data}

              Cells[SBLGm,GroupMemGridRows] := ConvertSBLOnlyToDashDot(Copy(SwisSBLKey, 7, 20));

              Cells[NameGm,GroupMemGridRows] := Name;
              Cells[NeighborhoodGm,GroupMemGridRows] := NeighborHood;
              Cells[PropertyClassGm,GroupMemGridRows] := PropertyClass;
              Cells[BuildingStyleGm,GroupMemGridRows] := BuildingStyleCode;

              If DoingAssmtComps
                then Cells[AssessedValGm,GroupMemGridRows] := FormatFloat(CurrencyNormalDisplay, TotalAssessedVal)
                else Cells[TASPGm,GroupMemGridRows] := FormatFloat(CurrencyNormalDisplay, UnadjustedSalesPrice);

              Cells[ConditionGm,GroupMemGridRows] := Conditioncode;
              Cells[GradeGm,GroupMemGridRows] := OverallGradeCode;
              Cells[YearBuiltGm,GroupMemGridRows] := ActualYearBuilt;
              Cells[AcresGm,GroupMemGridRows] := FormatFloat(DecimalDisplay, Acreage);

              try
                Cells[SFLAGm,GroupMemGridRows] := IntToStr(SqFootLivingArea);
              except
                Cells[SFLAGm,GroupMemGridRows] := '';
              end;

              Cells[NoBathsGm,GroupMemGridRows] := FormatFloat(DecimalDisplay, NumberofBathrooms);

              try
                Cells[NoBedsGm,GroupMemGridRows] := IntToStr(NumberOfBedrooms);
              except
                Cells[NoBedsGm,GroupMemGridRows] := '';
              end;

              Cells[NoStoriesGm,GroupMemGridRows] := FormatFloat(DecimalDisplay, NumberofStories);

              try
                Cells[ECordGm,GroupMemGridRows] := IntToStr(EastCoord);
              except
                Cells[ECordGm,GroupMemGridRows] := '';
              end;

              try
                Cells[NCordGm,GroupMemGridRows] := IntToStr(NorthCoord);
              except
                Cells[NCordGm,GroupMemGridRows] := '';
              end;

              If DoingAssmtComps
                then Cells[PerSqFtGM,GroupMemGridRows] := FormatFloat(_3DecimalDisplay, AsValPrSqFt)
                else Cells[PerSqFtGM,GroupMemGridRows] := FormatFloat(_3DecimalDisplay, SalePricePerSqFt);

              try
                Cells[FinBAseGm,GroupMemGridRows] := IntToStr(FinishedBasementArea);
              except
                Cells[FinBAseGm,GroupMemGridRows] := '';
              end;

              try
                Cells[FinAtticGm,GroupMemGridRows] := IntToStr(FinishedAtticArea);
              except
                Cells[FinAtticGm,GroupMemGridRows] := '';
              end;

              If CentralAir
                then Cells[CentralAirGm,GroupMemGridRows] := 'YES'
                else Cells[CentralAirGm,GroupMemGridRows] := 'NO';

              Cells[I1StructCdGm,GroupMemGridRows] := Imp1StructureCode ;
              Cells[I1YearBuiltGm,GroupMemGridRows] := Imp1YearBuilt ;
              Cells[I1CondCodeGM,GroupMemGridRows] := Imp1ConditionCode;   {www}
              Cells[I2StructCdGm,GroupMemGridRows] := Imp2StructureCode ;
              Cells[I2YearBuiltGm,GroupMemGridRows] := Imp2YearBuilt ;
              Cells[I2CondCodeGM,GroupMemGridRows] := Imp2ConditionCode;   {www}
              Cells[I3StructCdGm,GroupMemGridRows] := Imp3StructureCode ;
              Cells[I3YearBuiltGm,GroupMemGridRows] := Imp3YearBuilt ;
              Cells[I3CondCodeGM,GroupMemGridRows] := Imp3ConditionCode;   {www}

              If not DoingAssmtComps
                then
                  begin
                    Cells[SaleDateGm,GroupMemGridRows] := DateToStr(SaleDate);
                    Cells[SalePriceUnadjGm,GroupMemGridRows] := FormatFloat(CurrencyNormalDisplay, UnadjustedSalesPrice);
                    Cells[SalepriceAdjGm,GroupMemGridRows] := FormatFloat(CurrencyNormalDisplay, TimeadjSalesPrice);
                  end;

            end  {If ParcelMeetsMinMaxCriteria(CompDataPointer(CompDataList[I - 1])^)}
          else GroupMembersShowing[I] := 'N';

      end;  {with GroupMemberStringGrid, CompDataPointer(CompDataList[I-1])^ do}

     {empty results tlist, will then fill it with same records as contained in }
     {group memeber String grid, but eventually sorted in ascending point order}
     {...clear tlist including releasing memory for every results record each  }
     {time this routine is entered...thus the CompDataListist remains full but the}
     {ResultsList is emptied and refilled each time this routine is entered}

  ClearTList(ResultsList, SizeOf(CompDataRecord));

   {loop thru compdata String grid for SBL match with CompDataList,
    and see if selected flag set (set = blank or 'y')  }

  For I := 0 to (CompDataList.Count-1) do
    If (CompItemSelected(I) and
        (GroupMembersShowing[I] = 'Y'))
      then
        begin
          New(ResultsPtr);
          ResultsPtr^ := CompDataPointer(CompDataList[I])^;
          ResultsList.Add(ResultsPtr);
        end;

    {sort the results tlist in ascending point order and store in results String grid}

  SortResultsAndFillResultsStringGrid(ResultsList);

  NumShowing := 0;

  For I := 0 to (GroupMembersShowing.Count - 1) do
    If (GroupMembersShowing[I] = 'Y')
      then NumShowing := NumShowing + 1;

    {FXX06071999-4: Need to increase row and column count by 1 to include fixed row\col.}

  GroupMemberStringGrid.RowCount := NumShowing + 1;
  ResultsStringGrid.ColCount := ResultsList.Count + 1;

end;  {FillGroupMemberStringGrid}

{===========================================================================}
Procedure TComparativesDisplayForm.GetAssessmentGroupData(var MinimumAssessment,
                                                              MaximumAssessment,
                                                              AssmentSqFoot : Str15;
                                                          var GroupParcelCnt : Longint;
                                                              SrchSwis : Str6;
                                                              SrchNeighborHood : Str5;
                                                              SrchPropClass : Str3;
                                                              SrchBldgStyle : Str2);

var
  Found, Done : Boolean;

begin
  GroupParcelCnt := 0;
  Done := False;

  Found := FindKeyOld(CompAssmtMinMaxTable,
                      ['SwisCode', 'Neighborhood',
                       'PropertyClass', 'BuildingStyleCode'],
                      [SrchSwis,
                       SrchNeighborHood,
                       SrchPropClass,
                       SrchBldgStyle]);

  If Found
    then
      with CompAssmtMinMaxTable do
        begin
          MinimumAssessmentAmount := FieldByName('TavMin').AsFloat;
          MaximumAssessmentAmount := FieldByName('TavMax').AsFloat;

          MinimumAssessment := FormatFloat(CurrencyNormalDisplay, MinimumAssessmentAmount);
          MaximumAssessment := FormatFloat(CurrencyNormalDisplay, MaximumAssessmentAmount);
          GroupParcelCnt := FieldByName('GroupParcelCount').AsInteger;
          AssmentSqFoot := '  ';
        end
    else
      begin
        SystemSupport(006, CompAssmtMinMaxTable, 'Find Error locating group record.',
                      UnitName, GlblErrorDlgBox);
        (*Abort;*)
      end;

end;  {GetAssessmentGroupData}

{===========================================================================}
Procedure TComparativesDisplayForm.GetSalesGroupData(var MinimumSalePrice,
                                                         MaximumSalePrice : Str15;
                                                     var GroupParcelCnt   : Longint;
                                                         SrchSwis : Str6;
                                                         SrchNeighborHood : Str5;
                                                         SrchPropClass : Str3;
                                                         SrchBldgStyle : Str2;
                                                     Var FoundGroup : Boolean);


var
  Found : boolean;

begin
  GroupParcelCnt := 0;

  FoundGroup := FindKeyOld(CompSalesMinMaxTable,
                           ['SwisCode', 'Neighborhood',
                            'PropertyClass', 'BuildingStyleCode'],
                           [SrchSwis, SrchNeighborHood,
                            SrchPropClass, SrchBldgStyle]);

  If FoundGroup
    then
      with CompSalesMinMaxTable do
        begin
          MinimumSalePrice := FormatFloat(CurrencyNormalDisplay, FieldByName('SalesPriceMin').AsFloat);
          MaximumSalePrice := FormatFloat(CurrencyNormalDisplay, FieldByName('SalesPriceMax').AsFloat);
          GroupParcelCnt := FieldByName('GroupParcelCount').AsInteger;
        end
    else
      begin
      (*** FXX12211998-1 not an error if no group data, tell user and let them edit
        SystemSupport(006, CompSalesMinMaxTable,'Find error locating group record.',
                      UnitName, GlblErrorDlgBox);
        (*Abort;*)
      end;

end;  {GetSalesGroupData}

{===========================================================================}
Procedure TComparativesDisplayForm.SetMinMaxScreenVariables(    CompMinMaxTable : TTable;
                                                            var MinMaxScreenInitialized : Boolean);

var
  OldDate : TDateTime;
  Year, Month, Day : Word;

begin
  PASSettingMinMaxValues := True;

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

            {FXX06071999-2: Default to sales within 2 years only.}

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

  PASSettingMinMaxValues := False;
  MinMaxScreenInitialized := True;

end;  {SetMinMaxScreenVariables}

{===========================================================================}
Function TComparativesDisplayForm.CompItemSelected(CompTLIdx : Integer): Boolean;

{Look through the group members grid to see if this comp item was marked
 as selected or not.}

var
  I : Integer;
  SwisSBLKey : Str26;
  PrtKeySBL : Str20;

begin
  Result := True;

(*  with CompDataPointer(CompDataList[CompTlIdx])^ do
    begin
      SwisSBLKey := SwisCode + SBLKey;
      PrtKeySBL := Take(20, ConvertSwisSBLToDashDot(SwisSBLKey));

      For I := 0 to (GroupMemberStringGrid.RowCount - 1) do
        If ((Take(20, PrtKeySBL) = Take(20, GroupMemberStringGrid.Cells[SBLGm, I])) and
            (Take(1, Deblank(UpCaseStr(GroupMemberStringGrid.Cells[SelectGm, I]))) = 'N'))
          then Result := False;

    end;  {SetMinMaxScreenVariables} *)

  Result := (GroupMembersSelected[CompTlIdx] = 'Y');

end;  {SetMinMaxScreenVariables}

{===========================================================================}
Procedure TComparativesDisplayForm.LoadAndDisplayParcel(SwisSBLKey : Str26;
                                                        SearchSwis : Str6;
                                                        SearchNeighborHood : Str5;
                                                        SearchPropClass : Str3;
                                                        SearchBldgStyle : Str2);

var
  SBLRec : SBLRecord;
  FoundGroup, Found : Boolean;
  GridRows, I, ResSiteCnt, CommSiteCnt : Integer;
  TempStr : String;
  TempAcres : Double;

begin
  CompNoteBook.Visible := True;
  ViewAnotherParcelButton.Enabled := True;
  PrintButton.Enabled := True;
  CompNoteBook.Repaint;
  SBLRec := ExtractSwisSBLFromSwisSBLKey(SwisSBLKey);

  MinimumAssessmentAmount := 999999999;
  MaximumAssessmentAmount := 0;
  MinimumSalePriceAmount := 999999999;
  MaximumSalePriceAmount := 0;

    {FXX12221998-7: make sure to clear all lists and grids.}

  ResultsSelected.Clear;
  GroupMembersSelected.Clear;
  GroupMembersShowing.Clear;
  ClearTList(CompDataList,Sizeof(CompDataRecord));  {free memory for comp data tlist}
  ClearTList(ResultsList,Sizeof(CompDataRecord));  {free memory for results tlist}
  ClearStringGrid(GroupMemberStringGrid);
  ClearStringGrid(ResultsStringGrid);

  with SBLRec do
    Found := FindKeyOld(ParcelTable,
                        ['TaxRollYr', 'SwisCode', 'Section',
                         'Subsection', 'Block', 'Lot', 'Sublot',
                         'Suffix'],
                        [TaxRollYr, SwisCode, Section,
                         Subsection, Block,
                         Lot, Sublot, Suffix]);

  FindKeyOld(AssessmentTable,
             ['TaxRollYr', 'SwisSBLKey'],
             [TaxRollYr, SwisSBLKey]);

  ResSiteCnt := CalculateNumSites(ResSiteTable,
                                  TaxRollYr,
                                  SwisSBLKey,
                                  0, False);
  ResSiteCntLabel.Caption := IntToStr(ResSiteCnt);
  ResSiteCntLabel.Repaint;

  CommSiteCnt := CalculateNumSites(CommercialSiteTable,
                                   TaxRollYr,
                                   SwisSBLKey,
                                   0, False);
  CommercialSiteCntLabel.Caption := IntToStr(CommSiteCnt);
  CommercialSiteCntLabel.Repaint;

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

  If DoingAssmtComps
    then SalePriceLabel.Visible := False
    else
      begin
        SalePriceLabel.Visible := True;

        If TemplateRecordFound
          then
            with CompDataTable do
              SalePriceLabel.Caption := 'Sale Price - ' +
                               FormatFloat(CurrencyNormalDisplay, FieldByName('UnadjustedSalesPrice').AsFloat) +
                               '   (' +
                               FieldByName('SaleDate').Text + ')'
          else  SalePriceLabel.Caption := 'Sale Price - No sale for parcel.' ;

      end;  {else of If DoingAssmtComps}

        {set up page 2 (groups) display items}
  Pg2PropClassLabel.Caption := SearchPropClass;
  Pg2NeighborHoodLabel.Caption := SearchNeighborhood;
  Pg2BldgStyleLabel.Caption := SearchBldgStyle;

  Pg2LavLabel.Caption := FormatFloat(CurrencyNormalDisplay,
                                     AssessmentTable.FieldByName('LandAssessedVal').AsFloat);
  Pg2TavLabel.Caption := FormatFloat(CurrencyNormalDisplay,
                                     AssessmentTable.FieldByName('TotalAssessedVal').AsFloat);
  Pg3LavLabel.Caption := FormatFloat(CurrencyNormalDisplay,
                                     AssessmentTable.FieldByName('LandAssessedVal').AsFloat);
  Pg3TavLabel.Caption := FormatFloat(CurrencyNormalDisplay,
                                     AssessmentTable.FieldByName('TotalAssessedVal').AsFloat);

  with GroupStringGrid do
    begin
      Cells[1,0] := 'Swis';
      Cells[2,0] := 'Nbhd';
      Cells[3,0] := 'Prp Class';
      Cells[4,0] := 'Bld Style';
      Cells[5,0] := '# Parcels';

      If DoingAssmtComps
        then
          begin
            Cells[6,0] := 'Min Asmt';
            Cells[7,0] := 'Max Asmt';
            Cells[8,0] := 'Med AV/SqF';
          end
        else
          begin
            Cells[6,0] := 'Min Price';
            Cells[7,0] := 'Max Price';
            Cells[8,0] := 'Med Pr/SqF';  {DODDOD ..change to correct title}
         end;

      Cells[0,1] := 'Template';
      Cells[0,2] := '1.';
      Cells[0,3] := '2.';
      Cells[0,4] := '3.';
      Cells[0,5] := '4.';
      Cells[0,6] := '5.';

        {setup page 3 (range) page data}
      Pg3PropClassLabel.Caption := SearchPropClass;
      Pg3NeighborHoodLabel.Caption := SearchNeighborhood;
      Pg3BldgStyleLabel.Caption := SearchBldgStyle;

      If DoingAssmtComps
        then
          begin
            GetAssessmentGroupData(MinimumAssessment,
                                   MaximumAssessment,
                                   AssmentSqFoot,
                                   GroupParcelCnt,
                                   CompDataTable.FieldByName('SwisCode').Text,
                                   CompDataTable.FieldByName('NeighborHood').Text,
                                   CompDataTable.FieldByName('PropertyClass').Text,
                                   CompDataTable.FieldByName('BuildingStyleCode').Text);
            Pg1MinLblLbl.Caption := 'Minimum Assmt';
            Pg1MaxLblLbl.Caption := 'Maximum Assmt';
            Pg1MinLblLbl.Repaint;
            Pg1MaxLblLbl.Repaint;
            Pg1MinDataLbl.Caption := MinimumAssessment;
            Pg1MaxDataLbl.Caption := MaximumAssessment;

          end
        else
          begin

            {FXX11251998-1 get needed comp data for template parcel}
            GetSalesGroupData(MinimumSalePrice,
                              MaximumSalePrice,
                              GroupParcelCnt,
                              SearchSwis,
                              SearchNeighborHood,
                              SearchPropClass,
                              SearchBldgStyle,
                              FoundGroup);
            Pg1MinLblLbl.Caption := 'Minimum Sls Prc';
            Pg1MaxLblLbl.Caption := 'Maximum Sls Prc';
            Pg1MinLblLbl.Repaint;
            Pg1MaxLblLbl.Repaint;

            If FoundGroup
              then
                begin
                  Pg1MinDataLbl.Caption := MinimumSalePrice;
                  Pg1MaxDataLbl.Caption := MaximumSalePrice;
                end
              else
                begin
                  Cells[1,1] := Copy(SwisSBLKey,1,6);              {FXX11251998-1}
                  Cells[2,1] := SearchNeighborHood;  {        " }
                  Cells[3,1] := SearchPropClass;      {        " }
                  Cells[4,1] := SearchBldgStyle;            {        " }
                  MessageDlg('There are no parcels with the same charateristics as the parcel' + #13 +
                             'you selected that also have sales.' +  #13 +
                             'Parcel ID = ' + ConvertSwisSBLToDashDot(SwisSBLKey) + '.' + #13 +
                             'Please change the parcel characteristics or try a different parcel.',
                             mtError, [mbOK], 0);

                end;

          end;  {else of If DoingAssmtComps}

      Pg1MinDataLbl.Repaint;
      Pg1MaxDataLbl.Repaint;

      try
        Pg1ParcelCntLabel.Caption := IntToStr(GroupParcelCnt);
      except
        Pg1ParcelCntLabel.Caption := '';
      end;

      Pg1ParcelCntLabel.Repaint;

      Cells[1,1] := Copy(SwisSBLKey,1,6);              {FXX11251998-1}
      Cells[2,1] := SearchNeighborHood;  {        " }
      Cells[3,1] := SearchPropClass;      {        " }
      Cells[4,1] := SearchBldgStyle;            {        " }

      try
        Cells[5,1] := IntToStr(GroupParcelCnt);
      except
        Cells[5,1] := '';
      end;

      If DoingAssmtComps
        then
          begin
            Cells[6,1] := MinimumAssessment;
            Cells[7,1] := MaximumAssessment;
            Cells[8,1] := AssmentSqFoot;
          end
        else
          begin
            Cells[6,1] := MinimumSalePrice;
            Cells[7,1] := MaximumSalePrice;
            Cells[8,1] := '0';  {Must calculate}
          end;

    end;  {with GroupStringGrid do}

  CompNoteBook.PageIndex := TemplatePg;

  If (GroupParcelCnt > 0)
    then
      begin
        UpdateScreenMinMaxes(MinimumAssessment, MaximumAssessment,
                             MinimumSalePrice, MaximumSalePrice,
                             AssmentSqFoot, GroupParcelCnt);

            {Fill out Str grid with details of group members from comp
             data file.}

        with CompDataTable do
          FillGroupMembersList(SearchSwis,
                                SearchNeighborHood,
                                SearchPropClass,
                                SearchBldgStyle,
                                GroupParcelCnt,
                                CompDataTable,
                                TemplateRecordFound);

          {Put labels at top of grp String grid}

        FillGroupMemberStringGridColDescrip;

          {Fill String grid with entire comp data tlist}
        GridRows := 0;  { where we are now, row 0 is filled out,}
             {start out new groupStrGrid with one row}

          {This code fills in group String grid and results tl}

        FillGroupMemberStringGrid(GridRows,1,CompDataList.Count);

          {Get weights file}

        CompWeightingTable.First;

        CompNotebook.Refresh;

        CompNoteBook.SetFocus;

          {Make sure after all the above operations, we are still pointing to the same
           parcel.}

        CompDataTable.GotoBookmark(ParcelBookmark);

        with CompDataTable do
          SwisSBLKey := FieldByName('SwisCode').Text + FieldByName('SBLKey').Text;

      end;  {If (GroupParcelCnt > 0)}

end;  {LoadAndDisplayParcel}

{===========================================================================}
Procedure TComparativesDisplayForm.LocateTimerTimer(Sender: TObject);

var
  SwisCd : Str6;
  SBLKey : Str20;
  Done, _Found : Boolean;
  GridRows, I : Integer;
  SearchSwis : Str6;
  SearchNeighborHood : Str5;
  SearchPropClass    : Str3;
  SearchBldgStyle    : Str2;
  FoundGroup         : Boolean;
  TempTable : TTable;

begin
  LocateTimer.Enabled := False;
  SwisSBLKey := Take(26,' ');

    {CHG11241997-1: Show the cancel button, not the exit button.}
    {FXX12011998-20: Display the present action in the locate dialog.}

  ExecuteParcelLocateDialog(SwisSBLKey, True, False, 'Choose Parcel For Comprables');

  SwisCd := Copy(SwisSBLKey,1,6);
  SBLKey := Copy(SwisSBLKey,7,20);

  If (Deblank(SwisSBLKey) <> '')
    then
      begin
        MinMaxChanged := False;
        FindNearestOld(CompDataTable,
                       ['SwisCode', 'SBLKey', 'Site'],
                       [SwisCd, SBLKey, '0']);

        with CompDataTable do
          _Found := ((Take(6, SwisCd) = Take(6, FieldByName('SwisCode').Text)) and
                    (Take(20, SBLKey) = Take(20, FieldByName('SBLKey').Text)));

        TempTable := CompDataTable;

        If _Found
          then
            begin
              TemplateRecordFound := True;
              ParcelBookmark := CompDataTable.GetBookmark;
              ParcelBookmarkAssigned := True;
            end
          else TemplateRecordFound := False;  {FXX11251998-1}

        {FXX11251998-1  if sales rec not found and doing sales comps, we must get}
        {assmt comp record  so we can have correct parcel characteristics}
        {to search sales comp file down below}

        If _Found
          then
            begin   {FXX11251998-1}
              SearchSwis := Take(6,CompDataTable.FieldByName('SwisCode').Text);
              SearchNeighborHood := Take(5,CompDataTable.FieldByName('NeighborHood').Text);
              SearchPropClass := Take(3,CompDataTable.FieldByName('PropertyClass').Text);
              SearchBldgStyle := Take(2,CompDataTable.FieldByName('BuildingStyleCode').Text);
            end
          else
            begin
              If not DoingAssmtComps
                then
                  begin
                      {FXX12062001-1: Need to do a FindNearest instead of a FindKey
                                      in order to use assessment comp in case of no sale.}

                    FindNearestOld(CompAssDataSearchTable,
                                   ['SwisCode', 'SBLKey', 'Site'],
                                   [SwisCd, SBLKey, '0']);

                    with CompAssDataSearchTable do
                      _Found := ((Take(6, SwisCd) = Take(6, FieldByName('SwisCode').Text)) and
                                (Take(20, SBLKey) = Take(20, FieldByName('SBLKey').Text)));


                    If _Found
                      then
                        begin
                          SearchSwis := Take(6,CompAssDataSearchTable.FieldByName('SwisCode').Text);
                          SearchNeighborHood := Take(5,CompAssDataSearchTable.FieldByName('NeighborHood').Text);
                          SearchPropClAss := Take(3,CompAssDataSearchTable.FieldByName('PropertyClAss').Text);
                          SearchBldgStyle := Take(2,CompAssDataSearchTable.FieldByName('BuildingStyleCode').Text);

                          TempTable := CompAssDataSearchTable;  {Get template info from the assessment side.}

                        end;  {If Found}

                  end;  {If not DoingAssmtComps}

            end;  {else of If Found}

          {FXX12301998-1: Had to open a table for each drop down on front screen -
                          must synch up initially.}
          {FXX01051999-5: Had to unhook the edits and lookups from the CompDataSource
                          since changing charateristics when they were hooked up
                          caused actual changes in the comp data record.}

        with TempTable do
          begin
            FindKeyOld(PropertyClassTable, ['MainCode'],
                       [FieldByName('PropertyClass').Text]);
            FindKeyOld(NeighborhoodTable, ['MainCode'],
                       [Take(5, FieldByName('Neighborhood').Text)]);
            FindKeyOld(BuildingStyleTable, ['MainCode'],
                       [FieldByName('BuildingStyleCode').Text]);
            FindKeyOld(ZoningTable, ['MainCode'],
                       [Take(5, FieldByName('ZoningCode').Text)]);
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

          end;  {with CompDataTable do}

        If (_Found or
            (not DoingAssmtComps))  {OK to compare if no sale.}
          then LoadAndDisplayParcel(SwisSBLKey, SearchSwis, SearchNeighborHood,
                                    SearchPropClass, SearchBldgStyle)
          else
            begin
              MessageDlg('No comparatives for parcel ' +
                         ConvertSwisSBLToDashDot(SwisSBLKey) + '.' + #13 +
                         'Please try a different parcel.',
                         mtError, [mbOK], 0);
              LocateTimer.Enabled := True;

            end;  {else of If Found}

      end;  {If (Deblank(SwisSBLKey) <> '')}

end;  {CompItemSelected}

{================================================================}
Procedure TComparativesDisplayForm.CompNotebookChange(    Sender: TObject;
                                                          NewTab: Integer;
                                                      var AllowChange: Boolean);

var
  GridRows : Integer;
  TempAcres : Double;

begin
  If (NewTab = MinMaxPg)
    then
      with CompDataTable do
        begin
            {set up template and min/max info}

          CondTmpl.ReadOnly := False;
          GradeTmpl.ReadOnly := False;
          YearBuiltTmpl.ReadOnly := False;
          SqFtTmpl.ReadOnly := False;
          FFSqFTTmpl.ReadOnly := False;
          AcresTmpl.ReadOnly := False;
          BathsTmpl.ReadOnly := False;
          BedroomsTmpl.ReadOnly := False;
          StoriesTmpl.ReadOnly := False;
          FireplacesTmpl.ReadOnly := False;
          CrdEastTmpl.ReadOnly := False;
          CrdNorthTmpl.ReadOnly := False;

          CondTmpl.Text := FieldByName('ConditionCode').Text;
          GradeTmpl.Text := FieldByName('OverallGradeCode').Text;
          YearBuiltTmpl.Text := FieldByName('ActualYearBuilt').Text;
          SqFtTmpl.Text := FieldByName('SqFootLivingArea').Text;
          FFSqFTTmpl.Text := FieldByName('FirstStoryArea').Text;

            {FXX01051999-1: Fill in template acres by computing.}

          TempAcres := GetAcres(FieldByName('Acreage').AsFloat,
                                FieldByName('Frontage').AsFloat,
                                FieldByName('Depth').AsFloat);
          AcresTmpl.Text := FormatFloat(DecimalDisplay, TempAcres);

          BathsTmpl.Text := FieldByName('NumberOfBathrooms').Text;
          BedroomsTmpl.Text := FieldByName('NumberOfBedrooms').Text;
          StoriesTmpl.Text := FieldByName('NumberOfStories').Text;
          FireplacesTmpl.Text := FieldByName('NumFireplaces').Text;
          CrdEastTmpl.Text := FieldByName('EastCoord').Text;
          CrdNorthTmpl.Text := FieldByName('NorthCoord').Text;

          CondTmpl.ReadOnly := True;
          GradeTmpl.ReadOnly := True;
          YearBuiltTmpl.ReadOnly := True;
          SqFtTmpl.ReadOnly := True;
          FFSqFTTmpl.ReadOnly := True;
          AcresTmpl.ReadOnly := True;
          BathsTmpl.ReadOnly := True;
          BedroomsTmpl.ReadOnly := True;
          StoriesTmpl.ReadOnly := True;
          FireplacesTmpl.ReadOnly := True;
          CrdEastTmpl.ReadOnly := True;
          CrdNorthTmpl.ReadOnly := True;

        end;  {If (NewTab = MinMaxPg)}

    {When going to the weighting page, put them in insert or edit mode.}

  If (NewTab = WeightsPg)
    then
      with CompWeightingTable do
        If (State = dsBrowse)
          then
            If (RecordCount = 0)
              then Insert
              else Edit;

    {When leaving the weighting page, if there was a mod, see if they want to
     save it.}

  If (CompNotebook.PageIndex = WeightsPg)
    then
      with CompWeightingTable do
        If ((State in [dsEdit, dsInsert]) and
            Modified and
            (MessageDlg('Do you want to save the weighting changes?', mtConfirmation,
                        [mbYes, mbNo], 0) = idYes))
          then
            try
              Post;
            except
              SystemSupport(080, CompWeightingTable, 'Error saving comp weightins rec.',
                            UnitName, GlblErrorDlgBox);
            end;

    {Always refill the results grid based on whatever changes they have done.}

    {FXX12151998-3: The row count being passed in was wrong.}

  If ((NewTab = ResultsPg) and  {FXx1126198-1  fix list idx out of bnds error}
      (CompDataList.Count > 0))
    then
      begin
        GridRows := ResultsStringGrid.RowCount;
        FillGroupMemberStringGrid(GridRows, 1, CompDataList.Count);
      end;

end;  {CompNotebookChange}

{=========================================================================================}
Procedure TComparativesDisplayForm.CondMinExit(Sender: TObject);

var
  TempRl : Real;
  Code : Integer;

begin
  with Sender as TEdit do
    begin
      Val(Text,TempRl,Code);

      If (Code <> 0)
        then
          begin
            MessageDlg('Value Must Be Numeric ',
                       mtError, [mbOK], 0);
            Text := '0';
            SetFocus;
            (*Abort;*)

          end;  {If (Code <> 0)}

    end;  {with Sender as TEdit do}

end;  {CondMinExit}

{=====================================================================}
Procedure TComparativesDisplayForm.GroupMemberStringGridDrawCell(Sender: TObject;
                                                                 Col, Row: Longint;
                                                                 Rect: TRect;
                                                                 State: TGridDrawState);

var
  BackgroundColor : TColor;
  Selected : Boolean;
  ACol, ARow : LongInt;
  TempStr : String;

begin
  ACol := Col;
  ARow := Row;

  with GroupMemberStringGrid do
    begin
      Canvas.Font.Size := 8;
      Canvas.Font.Name := 'Arial';
      Canvas.Font.Style := [fsBold];
    end;

  with GroupMemberStringGrid do
    If (ARow > 0)
      then
        case ACol of
          NameGm,
          PropertyClassGm,
          NeighborhoodGm,
          BuildingStyleGm : Canvas.Font.Color := clFuchsia;
          AssessedValGm,
          PerSqFtGm : Canvas.Font.Color := clPurple;
          else Canvas.Font.Color := clBlue;

        end;  {case ARow of}

  If ((ACol = 0) or
      (ARow = 0))
    then GroupMemberStringGrid.Canvas.Font.Color := clNavy;

  If ((ACol = SelectGm) and
      (ARow > 0))
    then
      begin
        If ((GroupMembersSelected.Count > 0) and
            (GroupMembersSelected[ARow - 1] = 'Y'))
          then
            begin
              TempStr := 'Yes';
              BackgroundColor := clAqua;
              Selected := True;
            end
          else
            begin
              TempStr := 'No';
              BackgroundColor := clWhite;
              Selected := False;
            end;

        with GroupMemberStringGrid do
          CenterText(CellRect(ACol, ARow), Canvas, TempStr, True,
                     Selected, BackgroundColor);

      end
    else
      begin
        If ((ACol = 0) or
            (ARow = 0))
          then
            begin
              BackgroundColor := clBtnFace;
              Selected := True;
            end
          else
            begin
              BackgroundColor := clWhite;
              Selected := False;
            end;

        TempStr := GroupMemberStringGrid.Cells[ACol, ARow];

        with GroupMemberStringGrid do
          If ((ACol in [NameGm, PropertyClassGm, NeighborhoodGm,
                        BuildingStyleGm]) or
              (ARow = 0) or
              (ACol = 0))
            then LeftJustifyText(CellRect(ACol, ARow), Canvas, TempStr, True,
                                 Selected, BackgroundColor, 2)
            else RightJustifyText(CellRect(ACol, ARow), Canvas, TempStr, True,
                                  Selected, BackgroundColor, 2);

      end;  {else of If ((ARow = SelectedRs) and ...}

end;  {GroupMemberStringGridDrawCell}

{=====================================================================}
Procedure TComparativesDisplayForm.GroupMemberStringGridDblClick(Sender: TObject);

{Allow them to select which parcels to include in the group.}

begin
  with GroupMemberStringGrid do
    begin
      If (GroupMembersSelected[Row - 1] = 'Y')
        then GroupMembersSelected[Row - 1] := 'N'
        else GroupMembersSelected[Row - 1] := 'Y';

      GroupMemberStringGridDrawCell(Sender, Col, Row, CellRect(Col, Row), []);

    end;  {with ResultsStringGrid do}

end;  {GroupMemberStringGridDblClick}

{=====================================================================}
Procedure TComparativesDisplayForm.ResultsStringGridDrawCell(Sender: TObject;
                                                             Col, Row: Longint;
                                                             Rect: TRect;
                                                             State: TGridDrawState);

var
  BackgroundColor : TColor;
  Selected : Boolean;
  ACol, ARow : LongInt;
  TempStr : String;

begin
  ACol := Col;
  ARow := Row;

  with ResultsStringGrid do
    begin
      Canvas.Font.Size := 8;
      Canvas.Font.Name := 'Arial';
      Canvas.Font.Style := [fsBold];
    end;

  with ResultsStringGrid do
    If (ACol > 0)
      then
        case ARow of
          NameRs, AddrRs,
          PropertyClassRs,
          NeighborhoodRs,
          BuildingStyleRs : Canvas.Font.Color := clFuchsia;
          LAVRs,
          TAVRs,
          AssmtSqFtRs : Canvas.Font.Color := clPurple;
          WeightRs : Canvas.Font.Color := clRed;
          else Canvas.Font.Color := clBlue;

        end;  {case ARow of}

  If ((ACol = 0) or
      (ARow = 0))
    then ResultsStringGrid.Canvas.Font.Color := clNavy;

  If ((ARow = SelectedRs) and
      (ACol > 0))
    then
      begin
        If ((ResultsSelected.Count > 0) and
            (ResultsSelected[ACol - 1] = 'Y'))
          then
            begin
              TempStr := 'Yes';
              BackgroundColor := clAqua;
              Selected := True;
            end
          else
            begin
              TempStr := 'No';
              BackgroundColor := clWhite;
              Selected := False;
            end;

        with ResultsStringGrid do
          CenterText(CellRect(ACol, ARow), Canvas, TempStr, True,
                     Selected, BackgroundColor);

      end
    else
      begin
        If ((ACol = 0) or
            (ARow = 0))
          then
            begin
              BackgroundColor := clBtnFace;
              Selected := True;
            end
          else
            begin
              BackgroundColor := clWhite;
              Selected := False;
            end;

        TempStr := ResultsStringGrid.Cells[ACol, ARow];

        with ResultsStringGrid do
          If ((ARow in [NameRs, AddrRs, PropertyClassRs, NeighborhoodRs,
                        BuildingStyleRs]) or
              (ACol = 0))
            then LeftJustifyText(CellRect(ACol, ARow), Canvas, TempStr, True,
                                 Selected, BackgroundColor, 2)
            else RightJustifyText(CellRect(ACol, ARow), Canvas, TempStr, True,
                                  Selected, BackgroundColor, 2);

      end;  {else of If ((ARow = SelectedRs) and ...}

end;  {ResultsStringGridDrawCell}

{=====================================================================}
Procedure TComparativesDisplayForm.ResultsStringGridDblClick(Sender: TObject);

{Allow them to select which parcels to print.}

begin
  with ResultsStringGrid do
    begin
      If (ResultsSelected[Col - 1] = 'Y')
        then ResultsSelected[Col - 1] := 'N'
        else ResultsSelected[Col - 1] := 'Y';

      ResultsStringGridDrawCell(Sender, Col, Row, CellRect(Col, Row), []);

    end;  {with ResultsStringGrid do}

end;  {ResultsStringGridDblClick}

{=====================================================================}
Function TComparativesDisplayForm.ValidSwisCode(SwisCd : Str6) : Boolean;

var
  Quit : Boolean;

begin
  OpenTableForProcessingType(SWCodeTable, SwisCodeTableName, NextYear, Quit);
  SwCodeTable.IndexName := 'BYSWISCODE';
  Result := FindKeyOld(SWCodeTable, ['SwisCode'], [SwisCd]);

end;  {ValidSwisCode}

{=====================================================================}
Function TComparativesDisplayForm.ValidGroupCode(ThisCode : String;
                                                 TableNameConstant : Integer) :Boolean;
var
  LookupFieldName : String;  {Which key is this lookup by desc. or main code?}

begin
  CodeTable.Close;
  CodeTable.TableName := DetermineCodeTableName(TableNameConstant);
  LookupFieldName := 'MainCode';
  SetIndexForCodeTable(CodeTable, LookupFieldName);
  CodeTable.Open;
  Result := FindKeyOld(CodeTable, ['MainCode'], [ThisCode]);

end;  {ValidGroupCode}

{=====================================================================================}
Procedure TComparativesDisplayForm.SaveWeightingsButtonClick(Sender: TObject);

begin
  If (CompWeightingTable.State in [dsEdit, dsInsert])
    then
      try
        CompWeightingTable.Post;
      except
        SystemSupport(017, CompWeightingTable, 'Error posting weightings.', UnitName, GlblErrorDlgBox);
        (*Abort;*)
      end;

end;  {SaveWeightingsButtonClick}

{================================================================================================}
Procedure TComparativesDisplayForm.ApplyMinMaxButtonClick(Sender: TObject);

var
  GridRows : Integer;

begin
  GridRows := 0;

    {FXX01041998-3: Need to clear the string grid first.}

  ClearStringGrid(GroupMemberStringGrid);
  FillGroupMemberStringGrid(GridRows, 1, CompDataList.Count);

end;  {ApplyMinMaxButtonClick}

{======================================================================}
Procedure TComparativesDisplayForm.RestoreMinMaxButtonClick(Sender: TObject);

{Set the min\maxes to the full values of the groups.}

begin
  UpdateScreenMinMaxes(MinimumAssessment, MaximumAssessment,
                       MinimumSalePrice, MaximumSalePrice,
                       AssmentSqFoot, GroupParcelCnt);

    {Now reset all the members.}

  ApplyMinMaxButtonClick(Sender);

end;  {RestoreMinMaxButtonClick}

{======================================================================}
Procedure TComparativesDisplayForm.UpdateScreenMinMaxes(var MinimumAssessment,
                                                            MaximumAssessment,
                                                            MinimumSalePrice,
                                                            MaximumSalePrice,
                                                            AssmentSqFoot    : Str15;
                                                        var GroupParcelCnt : Longint);

{Set the min\max amounts taking all groups into account.}

var
  Found : Boolean;
  SrchSwis : Str6;
  SrchNeighborHood : Str5;
  SrchPropClass : Str3;
  SrchBldgStyle : Str2;
  I, ThisGroupParcelCount : Integer;
  ThisGroupMinVal, ThisGroupMaxVal : Comp;
  ThisGroupAssessmentSqFoot : Double;

begin
  MinimumAssessmentAmount := 999999999;
  MaximumAssessmentAmount := 0;
  MinimumSalePriceAmount := 999999999;
  MaximumSalePriceAmount := 0;
  GroupParcelCnt := 0;
  MinMaxScreenInitialized := False;  {Redo each time.}
  ThisGroupAssessmentSqFoot := 0;

    {Reset the min\maxes for all groups.}

  with GroupStringGrid do
    For I := 1 to (RowCount - 1) do
      If (Deblank(Cells[SGSwisCol, I]) <> '')
        then
          begin
            SrchSwis := Cells[SGSwisCol, I];
            SrchNeighborHood := Cells[SGNeighborHoodCol, I];
            SrchPropClass := Cells[SGPropertyClassCol, I];
            SrchBldgStyle := Cells[SGBuildingStyleCol, I];

            If DoingAssmtComps
              then
                begin
                  Found := FindKeyOld(CompAssmtMinMaxTable,
                                      ['SwisCode', 'Neighborhood',
                                       'PropertyClass', 'BuildingStyleCode'],
                                      [SrchSwis, SrchNeighborHood,
                                       SrchPropClass, SrchBldgStyle]);

                  If Found
                    then
                      with CompAssmtMinMaxTable do
                        begin
                          ThisGroupMinVal := FieldByName('TavMin').AsFloat;
                          If (ThisGroupMinVal < MinimumAssessmentAmount)
                            then
                              begin
                                MinimumAssessmentAmount := ThisGroupMinVal;
                                MinimumAssessment := FormatFloat(CurrencyNormalDisplay, MinimumAssessmentAmount);
                              end;

                          ThisGroupMaxVal := FieldByName('TavMax').AsFloat;
                          If (ThisGroupMaxVal > MaximumAssessmentAmount)
                            then
                              begin
                                MaximumAssessmentAmount := ThisGroupMaxVal;
                                MaximumAssessment := FormatFloat(CurrencyNormalDisplay, MaximumAssessmentAmount);
                              end;

                          ThisGroupParcelCount := FieldByName('GroupParcelCount').AsInteger;
                          GroupParcelCnt := GroupParcelCnt + ThisGroupParcelCount;
                          AssmentSqFoot := '  ';
                          SetMinMaxScreenVariables(CompAssmtMinMaxTable, MinMaxScreenInitialized);
                        end;

                end  {end doing assmt comps}
              else
                begin
                  Found := FindKeyOld(CompSalesMinMaxTable,
                                      ['SwisCode', 'Neighborhood',
                                       'PropertyClass', 'BuildingStyleCode'],
                                      [SrchSwis, SrchNeighborHood,
                                       SrchPropClass, SrchBldgStyle]);

                  If Found
                    then
                      with CompSalesMinMaxTable do
                        begin
                          ThisGroupMinVal := FieldByName('SalesPriceMin').AsFloat;
                          If (ThisGroupMinVal < MinimumSalePriceAmount)
                            then
                              begin
                                MinimumSalePriceAmount := ThisGroupMinVal;
                                MinimumSalePrice := FormatFloat(CurrencyNormalDisplay, MinimumSalePriceAmount);
                              end;

                          ThisGroupMaxVal := FieldByName('SalesPriceMax').AsFloat;
                          If (ThisGroupMaxVal > MaximumSalePriceAmount)
                            then
                              begin
                                MaximumSalePriceAmount := ThisGroupMaxVal;
                                MaximumSalePrice := FormatFloat(CurrencyNormalDisplay, MaximumSalePriceAmount);
                              end;

                          ThisGroupParcelCount := FieldByName('GroupParcelCount').AsInteger;
                          GroupParcelCnt := GroupParcelCnt + ThisGroupParcelCount;
                          SetMinMaxScreenvariables(CompSalesMinMaxTable, MinMaxScreenInitialized);
                        end;

                end;  {else of If DoingAssmtComps}

            MinMaxScreenInitialized := True;

            FillGroupStringGrid(SrchSwis, SrchNeighborHood, SrchPropClass,
                                SrchBldgStyle, ThisGroupParcelCount,
                                FormatFloat(CurrencyNormalDisplay, ThisGroupMinVal),
                                FormatFloat(CurrencyNormalDisplay, ThisGroupMaxVal),
                                '', I);

          end;  {If (Deblank(Cells[SGSwisCol, I]) <> '')}

end;  {UpdateScreenMinMaxes}

{======================================================================}
 Procedure TComparativesDisplayForm.FillGroupStringGrid(SwisCd : Str6;
                                             NeighborHood : Str5;
                                             PropClass : Str3;
                                             BldgStyle : Str2;
                                             GroupParcelCnt : Integer;
                                             ThisGrpMinVal : Str15;
                                             ThisGrpMaxVal : Str15;
                                             ThisGrpAssmentSqFoot : Str15;
                                             GroupRow : Integer);

begin
  with GroupStringGrid do
     begin
     Cells[1,GroupRow] := SwisCd;              {FXX11251998-1}
     Cells[2,GroupRow] := NeighborHood;  {        " }
     Cells[3,GroupRow] := PropClass;      {        " }
     Cells[4,GroupRow] := BldgStyle;            {        " }

     try
       Cells[5,GroupRow] := IntToStr(GroupParcelCnt);
     except
       Cells[5,GroupRow] := '';
     end;

     If DoingAssmtComps
          then
          begin
          Cells[6,GroupRow] := ThisGrpMinVal;
          Cells[7,GroupRow] := ThisGrpMaxVal;
          Cells[8,GroupRow] := ThisGrpAssmentSqFoot;
          end
          else
          begin
          Cells[6,GroupRow] := ThisGrpMinVal;
          Cells[7,GroupRow] := ThisGrpMaxVal;
          Cells[8,GroupRow] := '0';  {Must calculate}
          end;
    end;
end;
{======================================================================}
Procedure TComparativesDisplayForm.GroupStringGridSelectCell(    Sender: TObject;
                                                                 Col, Row: Longint;
                                                             var CanSelect: Boolean);

var
  LastGroupElement : Integer;
  NewGroupMinimumAssessment,
  NewGroupMaximumAssessment,
  NewGroupMinimumSalePrice,
  NewGroupMaximumSalePrice,
  NewGroupAssmentSqFoot    : Str15;
  NewGroupGroupParcelCnt : Longint;
  I : Integer;
  Found, FoundGroup : Boolean;
  SrchSwis : Str6;
  SrchNeighborHood : Str5;
  SrchPropClass : Str3;
  SrchBldgStyle : Str2;

begin
  case LastGroupGridCol of
    SGStartCol: LastGroupGridCol := Col;  {no cell processed yet so set this cel col
                                           as last cell processed}

    SGSwisCol:  {last cell was SWIS}
      If not ValidSwisCode(Take(6, GroupStringGrid.Cells[LastGroupGridCol, Row]) )
        then
          begin
            GrpItemError := True;
            MessageDlg('Please enter a valid swis code.', mtError, [mbOK], 0);
            GroupStringGrid.Col := SgSwisCol;
            GroupStringGrid.Setfocus;
            LastGroupGridCol := 99;
          end
        else LastGroupGridCol := Col;

     SGNeighborHoodCol: {last cell was neighborhood}
       If not ValidGroupCode(GroupStringGrid.Cells[LastGroupGridCol, Row],
                              NeighborHoodCode)
         then
           begin
             MessageDlg('Please enter a valid neigborhood code.', mtError, [mbOK], 0);
             GroupStringGrid.Col := LastGroupGridCol;
           end
         else LastGroupGridCol := Col;

     SGPropertyClassCol: {last cell was prop class}
         If not ValidGroupCode(GroupStringGrid.Cells[LastGroupGridCol, Row],
                               PropertyClass)
           then
             begin
               MessageDlg('Please enter a valid property class.', mtError, [mbOK], 0);
               GroupStringGrid.Col := LastGroupGridCol;
             end
           else LastGroupGridCol := Col;

      SGBuildingStyleCol:
        begin                    {last cell was bldg style}

          If not ValidGroupCode(GroupStringGrid.Cells[LastGroupGridCol, Row],
                                BuildingStyle)
            then
              begin
                MessageDlg('Please enter a valid building style.', mtError, [mbOK], 0);
                GroupStringGrid.Col := LastGroupGridCol;
              end
            else
              begin
                  {fill out Str grid with details of group members from comp data file}
                LastGroupGridCol := 0; {reset last cell indicator so user can go to next line}

                LastGroupElement := CompDataList.Count-1;

                    {widen min/max ranges if necessary from new group}
                    {so new grp items wont be filtered out below when}
                    {grp String grid is filled}

                with GroupStringGrid do
                  begin
                    SrchSwis := Cells[SGSwisCol,Row];
                    SrchNeighborHood := Cells[SGNeighborhoodCol,Row];
                    SrchPropClass := Cells[SGPropertyClassCol,Row];
                    SrchBldgStyle := Cells[SGBuildingStyleCol,Row];

                  end;

                Found := FindKeyOld(CompAssmtMinMaxTable,
                                    ['SwisCode', 'Neighborhood',
                                     'PropertyClass', 'BuildingStyleCode'],
                                    [SrchSwis, SrchNeighborHood,
                                     SrchPropClass, SrchBldgStyle]);

                If Found
                  then
                    begin
                         {FXX01051999-3: Keep track of whether or not they change the minimum or maximum -
                                         if they have and add a new group, we will not reset the
                                         amounts.}

                      If MinMaxChanged
                        then MessageDlg('Warning! The groups have changed, but the minimums and maximums' + #13 +
                                        'have been left at the values that you set.  If you want to' + #13 +
                                        'expand the minimums and maximums to the new values, please' + #13 +
                                        'click ''Restore Min\Max'' on the ''Min\Max'' page.', mtWarning, [mbOK], 0)
                        else
                          with GroupStringGrid do
                            UpdateScreenMinMaxes(MinimumAssessment,
                                                 MaximumAssessment,
                                                 MinimumSalePrice,
                                                 MaximumSalePrice,
                                                 AssmentSqFoot,
                                                 GroupParcelCnt);

                      If DoingAssmtComps
                        then
                          with GroupStringGrid do
                            begin
                              GetAssessmentGroupData(NewGroupMinimumAssessment,
                                                     NewGroupMaximumAssessment,
                                                     NewGroupAssmentSqFoot,
                                                     NewGroupGroupParcelCnt,
                                                     SrchSwis,
                                                     SrchNeighborHood,
                                                     SrchPropClass,
                                                     SrchBldgStyle);

                               {FILL  'GROUPS' STRING LIST}

                              FillGroupStringGrid(SrchSwis,
                                                  SrchNeighborHood,
                                                  SrchPropClass,
                                                  SrchBldgStyle,
                                                  NewGroupGroupParcelCnt,
                                                  NewGroupMinimumAssessment,
                                                  NewGroupMaximumAssessment,
                                                  NewGroupAssmentSqFoot,
                                                  Row);

                            end
                          else
                            with GroupStringGrid do
                              begin

                                  {FXX11251998-1 get needed comp data for template parcel}

                                GetSalesGroupData(NewGroupMinimumSalePrice,
                                                  NewGroupMaximumSalePrice,
                                                  NewGroupGroupParcelCnt,
                                                  SrchSwis,
                                                  SrchNeighborHood,
                                                  SrchPropClass,
                                                  SrchBldgStyle,
                                                  FoundGroup);  {doddod}

                                  {FILL  'GROUPS' STRING LIST}

                                FillGroupStringGrid(SrchSwis,
                                                    SrchNeighborHood,
                                                    SrchPropClass,
                                                    SrchBldgStyle,
                                                    NewGroupGroupParcelCnt,
                                                    NewGroupMinimumSalePrice,
                                                    NewGroupMaximumSalePrice,
                                                    '    ',
                                                    Row);

                              end;  {with GroupStringGrid do}

                    end;  {If Found}

                   {flag all new members as print = Yes}

                with GroupMembersSelected do
                  For I := CompDataList.Count to (CompDataList.Count + NewGroupGroupParcelCnt - 1) do
                    Add('Y');

                  {Also, display all new members.}

                with GroupMembersShowing do
                  For I := CompDataList.Count to (CompDataList.Count + NewGroupGroupParcelCnt - 1) do
                    Add('Y');

                  {Clear the group members and reload them all.}

                ClearTList(CompDataList,Sizeof(CompDataList));

                FillGroupMembersList(SrchSwis,
                                     SrchNeighborHood,
                                     SrchPropClass,
                                     SrchBldgStyle,
                                     GroupParcelCnt,
                                     CompDataTable,
                                     TemplateRecordFound);

                  {add to String grid from where last item left off}
                  {this code fills in group String grid and results tl}

                  {FILL 'GROUP MEMBERS' TAB STRING LIST}

                FillGroupMemberStringGrid(LastGroupElement,
                                          (LastGroupElement + 1), {skip last elemt alreadythere}
                                          CompDataList.Count);

              end;  {If not ValidGroupCode(GroupStringGrid.Cells[LastGroupGridCol, Row] ...}

        end;  { SGBuildingStyleCol:}

     SGError:  LastGroupGridCol := col;  {error case}

   end;  {case LastGroupGridCol of}

end;  {GroupStringGridSelectCell}

{===================================================================================}
Procedure TComparativesDisplayForm.ApplyNewCharactersticsButtonClick(Sender: TObject);

{FXX12221998-6: Let them change the characteristics and reload everything.}

var
  SearchSwis : Str6;
  SearchNeighborHood : Str5;
  SearchPropClass : Str3;
  SearchBldgStyle : Str2;

begin
    {Be sure to get the info from the actual edits since it no longer matches
     the actual data.}

  SearchSwis := Take(6, SwisSBLKey);
  SearchNeighborHood := Take(5, NeighborhoodLookup.Text);
  SearchPropClass := Take(3, PropertyClassLookup.Text);
  SearchBldgStyle := Take(2, BuildingStyleLookup.Text);

    {FXX01041999-2: Also, change the group that this belongs to.
                    Further, set TemplateParcelFound to false since it is
                    not in this group.}

  with GroupStringGrid do
    begin
      Cells[1,1] := SearchSwis;
      Cells[2,1] := SearchNeighborHood;
      Cells[3,1] := SearchPropClass;
      Cells[4,1] := SearchBldgStyle;

    end;   {with GroupStringGrid do}

    {FXX06012000-1: This is a template record, so it should be true.}

  TemplateRecordFound := True;

  LoadAndDisplayParcel(SwisSBLKey,
                       SearchSwis, SearchNeighborHood,
                       SearchPropClass, SearchBldgStyle)

end;  {ApplyNewCharactersticsButtonClick}

{===================================================================================}
Procedure TComparativesDisplayForm.PrintButtonClick(Sender: TObject);

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
Procedure TComparativesDisplayForm.ReportPrintHeader(Sender: TObject);

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
      If DoingAssmtComps
        then PrintCenter('Parcel Assessment Comparatives Report', (PageWidth / 2))
        else PrintCenter('Parcel Sales Comparatives Report', (PageWidth / 2));
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
Procedure TComparativesDisplayForm.ReportPrint(Sender: TObject);

var
  I, J, EndIdx, NumPages, StartIndex : Integer;
  ResultsToPrintList : TStringList;

begin
    {First create a list of indices into the ResultsList which says which
     results to actually print.}

  ResultsToPrintList := TStringList.Create;
  For I := 0 to (ResultsSelected.Count - 1) do
    If (ResultsSelected[I] = 'Y')
      then ResultsToPrintList.Add(IntToStr(I));

  with Sender as TBaseReport do
    begin
      NumPages := (ResultsToPrintList.Count DIV 9) + 1;

      For J := 1 to NumPages do
        begin
          StartIndex := ((J - 1) * 9);

          If ((StartIndex + 9) > ResultsToPrintList.Count)
            then EndIdx := ResultsToPrintList.Count - 1  {Just to the end}
            else EndIdx := StartIndex + 8;  {make sure if short list, we dont blow up}

          Print(#9 + 'Swis');
          For I := StartIndex to EndIdx do
            Print(#9 + ResultsPointer(ResultsList[StrToInt(ResultsToPrintList[I])])^.SwisCode);
          Println('');

          Print(#9 + 'Parcel ID');
          For I := StartIndex to EndIdx do
            Print(#9 + ConvertSBLOnlyToDashDot(ResultsPointer(ResultsList[StrToInt(ResultsToPrintList[I])])^.SBLKey));
          Println('');

          Print(#9 + 'Owner Name');
          For I := StartIndex to EndIdx do
            Print(#9 + Take(15, ResultsPointer(ResultsList[StrToInt(ResultsToPrintList[I])])^.Name));
          Println('');

          Print(#9 + 'Legal Addr');
          For I := StartIndex to EndIdx do
            Print(#9 + Take(15, ResultsPointer(ResultsList[StrToInt(ResultsToPrintList[I])])^.LegalAddr));
          Println('');

          Print(#9 + 'Prop Class');
          For I := StartIndex to EndIdx do
            Print(#9 + ResultsPointer(ResultsList[StrToInt(ResultsToPrintList[I])])^.PropertyClass);
          Println('');

          Print(#9 + 'Neighborhood');
          For I := StartIndex to EndIdx do
            Print(#9 + ResultsPointer(ResultsList[StrToInt(ResultsToPrintList[I])])^.Neighborhood);
          Println('');

          Print(#9 + 'Year Built');
          For I := StartIndex to EndIdx do
            Print(#9 + ResultsPointer(ResultsList[StrToInt(ResultsToPrintList[I])])^.ActualYearBuilt);
          Println('');

          Print(#9 + 'Bldg Style');
          For I := StartIndex to EndIdx do
            Print(#9 + ResultsPointer(ResultsList[StrToInt(ResultsToPrintList[I])])^.BuildingStyleCode);
          Println('');

          Print(#9 + 'Condition');
          For I := StartIndex to EndIdx do
            Print(#9 + ResultsPointer(ResultsList[StrToInt(ResultsToPrintList[I])])^.ConditionCode);
          Println('');

          Print(#9 + 'Grade');
          For I := StartIndex to EndIdx do
            Print(#9 + ResultsPointer(ResultsList[StrToInt(ResultsToPrintList[I])])^.OverallGradeCode);
          Println('');

          Print(#9 + 'Acreage / FF x Dep');
          For I := StartIndex to EndIdx do
            If (RoundOff(ResultsPointer(ResultsList[StrToInt(ResultsToPrintList[I])])^.Acreage,2) > StartIndex)
              then Print(#9 + FormatFloat(DecimalDisplay,
                                          ResultsPointer(ResultsList[StrToInt(ResultsToPrintList[I])])^.Acreage))
              else Print(#9 + FormatFloat(DecimalDisplay,
                                          ResultsPointer(ResultsList[StrToInt(ResultsToPrintList[I])])^.Frontage) + ' x ' +
                         FormatFloat(DecimalDisplay, ResultsPointer(ResultsList[StrToInt(ResultsToPrintList[I])])^.Depth));
          PrintLn('');

          Print(#9 + 'Stories');
          For I := StartIndex to EndIdx do
            Print(#9 + FormatFloat(DecimalDisplay,
                                   ResultsPointer(ResultsList[StrToInt(ResultsToPrintList[I])])^.NumberOfStories));
          Println('');

          Print(#9 + 'Bedrooms');
          For I := StartIndex to EndIdx do
            Print(#9 + IntToStr(ResultsPointer(ResultsList[StrToInt(ResultsToPrintList[I])])^.NumberOfBedrooms));
          Println('');

          Print(#9 + 'Bathrooms');
          For I := StartIndex to EndIdx do
            Print(#9 + FormatFloat(DecimalDisplay,
                                   ResultsPointer(ResultsList[StrToInt(ResultsToPrintList[I])])^.NumberOfBathrooms));
          Println('');

          Print(#9 + 'First Story Area');
          For I := StartIndex to EndIdx do
            Print(#9 + IntToStr(ResultsPointer(ResultsList[StrToInt(ResultsToPrintList[I])])^.FirstStoryArea));
          Println('');

          Print(#9 + 'Sq Ft Liv. Area');
          For I := StartIndex to EndIdx do
            Print(#9 + IntToStr(ResultsPointer(ResultsList[StrToInt(ResultsToPrintList[I])])^.SqFootLivingArea));
          Println('');

          Print(#9 + 'Attach Gar Size');
          For I := StartIndex to EndIdx do
            Print(#9 + IntToStr(ResultsPointer(ResultsList[StrToInt(ResultsToPrintList[I])])^.AttachedGarCapacity));
          Println('');

          Print(#9 + 'Fireplaces');
          For I := StartIndex to EndIdx do
            Print(#9 + IntToStr(ResultsPointer(ResultsList[StrToInt(ResultsToPrintList[I])])^.NumberOfFirePlaces));
          Println('');

          Print(#9 + 'Zoning\Sewer');
          For I := StartIndex to EndIdx do
            with ResultsPointer(ResultsList[StrToInt(ResultsToPrintList[I])])^ do
              Print(#9 + ZoningCode + '\' + SewerTypeCode);
          Println('');

          Print(#9 + 'Water\Bsmt');
          For I := StartIndex to EndIdx do
            with ResultsPointer(ResultsList[StrToInt(ResultsToPrintList[I])])^ do
              Print(#9 + WaterSupplyCode + '\' + BasementCode);
          Println('');

          Print(#9 + 'E\N Coord');
          For I := StartIndex to EndIdx do
            with ResultsPointer(ResultsList[StrToInt(ResultsToPrintList[I])])^ do
              Print(#9 + IntToStr(EastCoord) + '\' + IntToStr(NorthCoord));
          Println('');

          Print(#9 + 'Imp #1 Struct');
          For I := StartIndex to EndIdx do
            Print(#9 + ResultsPointer(ResultsList[StrToInt(ResultsToPrintList[I])])^.Imp1StructureCode);
          Println('');

          Print(#9 + 'Imp #1 Yr Blt\Cond');
          For I := StartIndex to EndIdx do
            If (Deblank(ResultsPointer(ResultsList[StrToInt(ResultsToPrintList[I])])^.Imp1StructureCode) <> '')
              then Print(#9 + ResultsPointer(ResultsList[StrToInt(ResultsToPrintList[I])])^.Imp1YearBuilt + '\' +
                         ResultsPointer(ResultsList[StrToInt(ResultsToPrintList[I])])^.Imp1ConditionCode)
              else Print(#9);
          Println('');

          Print(#9 + 'Imp #2 Struct');
          For I := StartIndex to EndIdx do
            Print(#9 + ResultsPointer(ResultsList[StrToInt(ResultsToPrintList[I])])^.Imp2StructureCode);
          Println('');

          Print(#9 + 'Imp #2 Yr Blt\Cond');
          For I := StartIndex to EndIdx do
            If (Deblank(ResultsPointer(ResultsList[StrToInt(ResultsToPrintList[I])])^.Imp2StructureCode) <> '')
              then Print(#9 + ResultsPointer(ResultsList[StrToInt(ResultsToPrintList[I])])^.Imp2YearBuilt + '\' +
                         ResultsPointer(ResultsList[StrToInt(ResultsToPrintList[I])])^.Imp2ConditionCode)
              else Print(#9);
          Println('');

          Print(#9 + 'Imp #3 Struct');
          For I := StartIndex to EndIdx do
            Print(#9 + ResultsPointer(ResultsList[StrToInt(ResultsToPrintList[I])])^.Imp3StructureCode);
          Println('');

          Print(#9 + 'Imp #3 Yr Blt\Cond');
          For I := StartIndex to EndIdx do
            If (Deblank(ResultsPointer(ResultsList[StrToInt(ResultsToPrintList[I])])^.Imp3StructureCode) <> '')
              then Print(#9 + ResultsPointer(ResultsList[StrToInt(ResultsToPrintList[I])])^.Imp3YearBuilt + '\' +
                         ResultsPointer(ResultsList[StrToInt(ResultsToPrintList[I])])^.Imp3ConditionCode)
              else Print(#9);
          Println('');

          If DoingAssmtComps
            then
              begin
                Print(#9 + 'Land Assess Val');
                For I := StartIndex to EndIdx do
                  Print(#9 + FormatFloat(CurrencyNormalDisplay,
                                         ResultsPointer(ResultsList[StrToInt(ResultsToPrintList[I])])^.LandAssessedVal));
                Println('');

                Print(#9 + 'Tot Assessed Val');
                For I := StartIndex to EndIdx do
                  Print(#9 + FormatFloat(CurrencyNormalDisplay,
                              ResultsPointer(ResultsList[StrToInt(ResultsToPrintList[I])])^.TotalAssessedVal));
                Println('');

                Print(#9 + 'AV/Square Foot');
                For I := StartIndex to EndIdx do
                  Print(#9 + FormatFloat(_3DecimalDisplay,
                                         ResultsPointer(ResultsList[StrToInt(ResultsToPrintList[I])])^.AsValPrSqFt));
                Println('');

             end
           else
             begin
               Print(#9 + 'Sale Price');
               For I := StartIndex to EndIdx do
                 Print(#9 + FormatFloat(CurrencyNormalDisplay,
                                     ResultsPointer(ResultsList[StrToInt(ResultsToPrintList[I])])^.UnadjustedSalesPrice));
               Println('');

               Print(#9 + 'Sale Date');
               For I := StartIndex to EndIdx do
                 Print(#9 + DateToStr(ResultsPointer(ResultsList[StrToInt(ResultsToPrintList[I])])^.SaleDate));
               Println('');

                Print(#9 + 'Sale Price/Square Foot');
                For I := StartIndex to EndIdx do
                  Print(#9 + FormatFloat(_3DecimalDisplay,
                                         ResultsPointer(ResultsList[StrToInt(ResultsToPrintList[I])])^.SalePricePerSqFt));
                Println('');

             end;  {else of If DoingAssmtComps}

            {CHG10041999-1: Ask if they want to print the points.}

          If PrintPoints
            then
              begin
                Bold := True;
                Print(#9 + 'Points');
                For I := StartIndex to EndIdx do
                  Print(#9 + FormatFloat(NoDecimalDisplay,
                                         ResultsPointer(ResultsList[StrToInt(ResultsToPrintList[I])])^.TotalPoints));

              end;  {If PrintPoints}

          Println('');
          Bold := False;

          If (J < NumPages)
            then NewPage;

        end;  {For J := 1 to NumPages do}

    end;  {with Sender as TBaseReport do}

end;  {ReportPrint}

{===================================================================}
Procedure TComparativesDisplayForm.FormClose(    Sender: TObject;
                                             var Action: TCloseAction);

begin
  ResultsSelected.Free;
  GroupMembersSelected.Free;
  GroupMembersShowing.Free;

  If ParcelBookmarkAssigned
    then CompDataTable.FreeBookmark(ParcelBookmark);

  CloseTablesForForm(Self);
  FreeTList(CompDataList,Sizeof(CompDataRecord));  {free memory for comp data tlist}
  FreeTList(ResultsList,Sizeof(CompDataRecord));  {free memory for results tlist}

    {Free up the child window and set the ClosingAForm Boolean to
     true so that we know to delete the tab.}

  Action := caFree;
  GlblClosingAForm := True;
  GlblClosingFormCaption := Caption;

end;  {FormClose}



end.