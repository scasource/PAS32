unit MappingFormUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  OleCtrls, ExtCtrls, ComCtrls, MapUtilitys,
  Buttons, StdCtrls, ComObj, ActiveX, Db, DBTables, DLL96V1, Wwtable,
  MapSetupObjectType, ToolWin, CheckLst, Grids, RPFiler, RPDefine, RPBase,
  RPCanvas, RPrinter, PASTypes, (*MO21legend_TLB, *)Printers, MapObjects2_TLB,
  Mask, wwdbedit, Wwdotdot, Wwdbcomb, FileCtrl;

type
  TMappingForm = class(TForm)
    Panel1: TPanel;
    Splitter: TSplitter;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    PropTabSheet3: TTabSheet;
    MapTimer: TTimer;
    OpenDialog: TOpenDialog;
    ExemptionCodeTable: TTable;
    SDCodeTable: TTable;
    TabSheet3: TTabSheet;
    SchoolCodeTable: TTable;
    SwisCodeTable: TTable;
    ChooseAssessmentYearRadioGroup: TRadioGroup;
    EditHistoryYear: TEdit;
    PropertyClassTable: TTable;
    ParcelLookupTable: TTable;
    SysRecTable: TTable;
    AssessmentYearControlTable: TTable;
    ParcelEXTable: TTable;
    ParcelSDTable: TTable;
    MappingHeaderTable: TTable;
    MappingDetailTable: TwwTable;
    OpenTablesInDataModuleTimer: TTimer;
    Panel2: TPanel;
    StatusBar: TStatusBar;
    Map: TMap;
    ProgressBar: TProgressBar;
    TabSheet4: TTabSheet;
    ToolBar: TToolBar;
    IdentifySpeedButton: TSpeedButton;
    SBZoomIn: TSpeedButton;
    SBZoomOut: TSpeedButton;
    ApplySpeedButton: TSpeedButton;
    SelectModeSpeedButton: TSpeedButton;
    MapRangeSpeedButton: TSpeedButton;
    Panel3: TPanel;
    MapLabelRadioGroup: TRadioGroup;
    TabSheet5: TTabSheet;
    CreateParcelListSpeedButton: TSpeedButton;
    LoadFromParcelListSpeedButton: TSpeedButton;
    ShowParcelListSpeedButton: TSpeedButton;
    LocateSpeedButton: TSpeedButton;
    MapLayersAvailableTable: TTable;
    ParcelTable: TTable;
    ClearAllSelectedSpeedButton: TSpeedButton;
    GroupBox1: TGroupBox;
    Label8: TLabel;
    FillStyleComboBox: TComboBox;
    FillColorShape: TShape;
    Label9: TLabel;
    FillColorButton: TButton;
    ColorDialog: TColorDialog;
    Panel4: TPanel;
    Label5: TLabel;
    PropertyClassListBox: TListBox;
    Panel5: TPanel;
    Label21: TLabel;
    RollSectionListBox: TListBox;
    AllPropertyClassesButton: TButton;
    Panel6: TPanel;
    ExemptionListBox: TListBox;
    Panel7: TPanel;
    SpecialDistrictListBox: TListBox;
    Panel8: TPanel;
    Label1: TLabel;
    Panel9: TPanel;
    Label19: TLabel;
    AllExemptionCodesButton: TButton;
    AllSpecialDistrictsButton: TButton;
    Panel10: TPanel;
    SwisCodeListBox: TListBox;
    Panel11: TPanel;
    Label3: TLabel;
    Panel12: TPanel;
    SchoolCodeListBox: TListBox;
    Panel13: TPanel;
    Label4: TLabel;
    AllSwisCodesButton: TButton;
    AllSchoolCodesButton: TButton;
    AllRollSectionsButton: TButton;
    PrintDialog: TPrintDialog;
    FlashShapeTimer: TTimer;
    LayersCheckListPanel: TPanel;
    RefreshLayerBoxTimer: TTimer;
    ProxmitySpeedButton: TSpeedButton;
    ReportPrinter: TReportPrinter;
    ParcelLookupTable2: TTable;
    AssessmentTable: TTable;
    Panel15: TPanel;
    Panel16: TPanel;
    Label2: TLabel;
    Label10: TLabel;
    RangeValuesComboBox: TComboBox;
    RangeRegionEdit: TEdit;
    ChooseRangeRegionButton: TButton;
    Panel17: TPanel;
    ClearButton: TBitBtn;
    TabSheet6: TTabSheet;
    Panel20: TPanel;
    MapInfoFormSynchronizeTimer: TTimer;
    ZoningCodeTable: TTable;
    NeighborhoodCodeTable: TTable;
    LegalAddressSpeedButton: TSpeedButton;
    LimitExtentTimer: TTimer;
    ResidentialSiteTable: TTable;
    FullSizeButton: TSpeedButton;
    SalesTable: TTable;
    ModifySpeedButton: TSpeedButton;
    SaveDialog: TSaveDialog;
    UnknownSpeedButton: TSpeedButton;
    ReapplyValuesButton: TBitBtn;
    ModifyParcelPanel: TPanel;
    ParcelStringGrid: TStringGrid;
    SaveButton: TBitBtn;
    CancelButton: TBitBtn;
    CloseButton: TBitBtn;
    Panel21: TPanel;
    CloseModifyParcelPanelTopButton: TButton;
    ParcelListReportPrinter: TReportPrinter;
    UnknownParcelReportPrinter: TReportPrinter;
    SelectedLayerDeleteTimer: TTimer;
    DisplayRangeLabelsCheckBox: TCheckBox;
    ValueRangeStringGrid: TStringGrid;
    LayersCheckListBox: TCheckListBox;
    MapCondoTable: TTable;
    MappingSetupSpeedButton: TSpeedButton;
    MapParcelIDFormatTable: TTable;
    ScalePanel: TPanel;
    ToolBar2: TToolBar;
    PanLeftButton: TSpeedButton;
    PanRightButton: TSpeedButton;
    PanUpButton: TSpeedButton;
    PanDownButton: TSpeedButton;
    Panel14: TPanel;
    Label6: TLabel;
    LockScaleButton: TBitBtn;
    XCoordinateLabel: TLabel;
    YCoordinateLabel: TLabel;
    UnlockScaleButton: TBitBtn;
    ScaleComboBox: TwwDBComboBox;
    AdjustExtentForLockedScaleTimer: TTimer;
    ExcelSpeedButton: TSpeedButton;
    CopyToClipboardSpeedButton: TSpeedButton;
    ExtractGISParcelShapeFileSpeedButton: TSpeedButton;
    RefreshSpeedButton: TSpeedButton;
    PrintMapSpeedButton: TSpeedButton;
    SaveSpeedButton: TSpeedButton;
    SetPASFieldSpeedButton: TSpeedButton;
    ShowPicturesSpeedButton: TSpeedButton;
    Table1: TTable;
    CommercialSiteTable: TTable;
    ReportFiler: TReportFiler;
    ParcelListReportFiler: TReportFiler;
    UnknownParcelReportFiler: TReportFiler;
    procedure MapTimerTimer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure PanButtonClick(Sender: TObject);
    procedure SBZoomInClick(Sender: TObject);
    procedure SBZoomOutClick(Sender: TObject);
    procedure ApplySpeedButtonClick(Sender: TObject);
    procedure MapMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure MapAfterLayerDraw(Sender: TObject; index: Smallint;
      canceled: WordBool; hDC: Cardinal);
    procedure CreateParcelListButtonClick(Sender: TObject);
    procedure LoadFromParcelListButtonClick(Sender: TObject);
    procedure CloseMappingButtonClick(Sender: TObject);
    procedure FullSizeButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure PrintMapSpeedButtonClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure MappingSetupButtonClick(Sender: TObject);
    procedure OpenTablesInDataModuleTimerTimer(Sender: TObject);
    procedure IdentifySpeedButtonClick(Sender: TObject);
    procedure SelectModeSpeedButtonClick(Sender: TObject);
    procedure MapMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure MapLabelRadioGroupClick(Sender: TObject);
    procedure MapRangeSpeedButtonClick(Sender: TObject);
    procedure ShowParcelListSpeedButtonClick(Sender: TObject);
    procedure DistanceSpeedButtonClick(Sender: TObject);
    procedure MapMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure LocateSpeedButtonClick(Sender: TObject);
    procedure LayersCheckListBoxClickCheck(Sender: TObject);
    procedure LayersCheckListBoxMouseMove(Sender: TObject;
      Shift: TShiftState; X, Y: Integer);
    procedure ClearAllSelectedSpeedButtonClick(Sender: TObject);
    procedure ChooseAssessmentYearRadioGroupClick(Sender: TObject);
    procedure FillColorButtonClick(Sender: TObject);
    procedure FillStyleComboBoxChange(Sender: TObject);
    procedure AllCodesButtonClick(Sender: TObject);
    procedure FlashShapeTimerTimer(Sender: TObject);
    procedure RefreshLayerBoxTimerTimer(Sender: TObject);
    procedure RangeValuesComboBoxChange(Sender: TObject);
    procedure ProxmitySpeedButtonClick(Sender: TObject);
    procedure ReportPrint(Sender: TObject);
    procedure ValueRangeStringGridDrawCell(Sender: TObject; ACol,
      ARow: Integer; Rect: TRect; State: TGridDrawState);
    procedure RefreshButtonClick(Sender: TObject);
    procedure ReportPrintHeader(Sender: TObject);
    procedure MapInfoFormSynchronizeTimerTimer(Sender: TObject);
    procedure ClearButtonClick(Sender: TObject);
    procedure LegalAddressSpeedButtonClick(Sender: TObject);
    procedure LimitExtentTimerTimer(Sender: TObject);
    procedure AvailableLayersListBoxClick(Sender: TObject);
    procedure AvailableLayersListBoxMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ParcelListReportPrint(Sender: TObject);
    procedure ParcelListReportPrintHeader(Sender: TObject);
    procedure SaveSpeedButtonClick(Sender: TObject);
    procedure ModifySpeedButtonClick(Sender: TObject);
    procedure UnknownSpeedButtonClick(Sender: TObject);
    procedure ReapplyValuesButtonClick(Sender: TObject);
    procedure ValueRangeStringGridDblClick(Sender: TObject);
    procedure SaveButtonClick(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject);
    procedure CloseButtonClick(Sender: TObject);
    procedure UnknownParcelReportPrint(Sender: TObject);
    procedure UnknownParcelReportPrintHeader(Sender: TObject);
    procedure SelectedLayerDeleteTimerTimer(Sender: TObject);
    procedure LockScaleButtonClick(Sender: TObject);
    procedure UnlockScaleButtonClick(Sender: TObject);
(*    procedure ScaleComboBoxChange(Sender: TObject);
    procedure EditScaleExit(Sender: TObject);*)
    procedure ScaleComboBoxCloseUp(Sender: TwwDBComboBox; Select: Boolean);
    procedure ScaleComboBoxExit(Sender: TObject);
    procedure AdjustExtentForLockedScaleTimerTimer(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure ExcelSpeedButtonClick(Sender: TObject);
    procedure CopyToClipboardSpeedButtonClick(Sender: TObject);
    procedure ExtractGISParcelShapeFileSpeedButtonClick(Sender: TObject);
    procedure SetPASFieldSpeedButtonClick(Sender: TObject);
    procedure ShowPicturesSpeedButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    MainLayer : IMoMapLayer;
    SelectedLayer : IMoMapLayer;
    dc : IMoDataConnection;
    LimitExtentToCriteriaResults,
    InitializingForm, ReloadingLayerBox,
    LoadingComps, CreateParcelList,
    LoadFromParcelList, ApplyingChanges,
    CriteriaInEffect, TrackingLayerDrawn, FillingRanges : Boolean;

    SelectedSwisCodes, SelectedSchoolCodes,
    SelectedPropertyClasses, SelectedRollSections,
    SelectedSDCodes, SelectedEXCodes : TStringList;
    MapInfoFormList : TStringList;

    LabelDisplayType, ProcessingType, iUnknownReportSection : Integer;
    CurrentSwisSBLKey, LastFoundSwisSBLKey,
    CompsFileName, AssessmentYear, ProximitySubjectSwisSBLKey : String;
    LayerList : TStringList;
    CurrentTrackingLayerExtent, FullSizeRect : IMoRectangle;

    MapSetupObject : TMapSetupObject;
    DataModuleComponentIndex : Integer;
    CurrentMouseMode : CurrentMouseModeSetType;
    CurrentlySelectedList : TStringList;
    StartingDistanceMeasurePoint, EndingDistanceMeasurePoint : IMOPoint;
    DistanceLine : IMOLine;

    CurrentLayerItem, CurrentLayerListItem : Integer;
    SelectedFillColor : TColor;
    SelectedFillStyle : Integer;
    CurrentParcelShape : IMoPolygon;

    RangeType : Integer;
    MapRangeRec : MapRangeRecord;
    MapRangeList : TList;
    DialogShowing : Boolean;

      {Label variables}

    lb_PrintLabelsBold,
    lb_PrintOldAndNewParcelIDs,
    lb_PrintSwisCodeOnParcelIDs,
    lb_PrintParcelIDOnly : Boolean;

    lb_LabelType,
    lb_NumLinesPerLabel,
    lb_NumLabelsPerPage,
    lb_NumColumnsPerPage,
    lb_SingleParcelFontSize : Integer;

    lb_ResidentLabels, lb_LegalAddressLabels,
    lb_PrintParcelIDOnlyOnFirstLine : Boolean;
    lb_LaserTopMargin : Real;
    lb_PrintParcelID_PropertyClass : Boolean;

    CurrentAssessmentTable, PriorAssessmentTable : TTable;
    CurrentAssessmentYear, PriorAssessmentYear : String;

    LegalAddressLookup : Boolean;
    LegalAddress : String;
    LegalAddressNumberStart, LegalAddressNumberEnd : String;
    AllLegalAddressNumbers, ToEndOfLegalAddressNumbers : Boolean;
    SelectedParcelsAreLegalAddress : Boolean;
    LimitExtentRect : IMoRectangle;
    SelectedParcelsAreComps : Boolean;
    MainLayerName,
    MainLayerFileName, MainLayerLocation,
    SelectedLayerFileName, SelectedLayerLocation : String;
    SelectedLayerDc : IMoDataConnection;
    ModifyRecordSet : IMORecordSet;
    ModifyParcelPanelVisible : Boolean;
    CurrentPoint : IMOPoint;
    ImageLayer : IMoImageLayer;
    UnknownParcelList : TList;
    SelectedLayerIsRangeLayer : Boolean;
    CondominiumUnitList : TStringList;
    OnlyBaseCondominiumParcelIdIsEncoded : Boolean;
    ActionCancelled : Boolean;
    CurrentScale, LockedScale : Extended;
    ScaleIsLocked : Boolean;
    SelectedLayerToDelete : String;
    LabelOptions : TLabelOptions;
    UseGenericUnknownPrintFormat : Boolean;
    UnknownFieldValues, UnknownFieldNames : TStringList;

(*    LayersCheckListBox: TCheckListBox;*)


    Procedure MapExceptionHandler(Sender : TObject;
                                  E : Exception);
    {This is the exception handler that will be assigned to the overall application.
     So, rather than a regular message dlg. being shown, we will display our own
     message and can customize it based on what type of exception it is.
     This exception handler is assigned to be the default application exception
     handler in the create of this form.}

    Function ParcelMeetsCriteria(ParcelLookupTable : TTable) : Boolean;
    Procedure FillInValueRangesGrid(MapRangeList : TList);
    Procedure ColorMapByRange(RangeType : Integer;
                              MapRangeRec : MapRangeRecord);

    Procedure AddSelectedParcelLayer;
    Procedure RefreshSelectedLayer;
    Procedure ClearSelectedInformation;
    Procedure AddItemToSelectedLayer(P : IMoPolygon;
                                     ParcelID : String;
                                     AlternateLabel : String;
                                     AlternateLabelColor : TColor;
                                     FillStyle : Integer;
                                     FillColor : TColor;
                                     UseAltLabel : Boolean);
    Procedure RemoveItemFromSelectedLayer(P : IMoPolygon;
                                          ParcelID : String);
    Procedure ShowModifyRecordPanel;
    Procedure CloseParcelModifyPanel;
    Procedure DeleteSelectedLayerGeoDataset;

    Procedure AdjustCurrentExtentToScale(CurrentScale : Extended);

  end;

type
  UnknownParcelRecord = record
    MismatchType : Integer;
    Field1 : String;
    Field2 : String;
    Field3 : String;
    Field4 : String;
    Field5 : String;
    sPrintKey : String;
    sOwner : String;
    sLegalAddress : String;
    sAccountNumber : String;
  end;

  UnknownParcelPointer = ^UnknownParcelRecord;

var
  MappingForm : TMappingForm;

implementation

{$R *.DFM}

uses WinUtils, PASUtils, GlblVars, Glblcnst, MapParcelInfoDialog,
     PrclList, Utilitys, MappingSetupOptions, DataModule,
     Prclocat, MapProximitySelectUnit, Preview, DataAccessUnit,
     MapRangeSelectDialogUnit, Math,
     MapLegalAddressSelectDialogUnit,
     MapPrintTypeDialogUnit,
     MapPrintDialogUnit,
(*     MapModifyParcelUnit,*)
     MapCriteriaSearchDialogUnit,
     MapRangeEditItemDialogUnit,
     MapExtractMainLayerInformationDialogUnit,
     MapSetFieldValueBasedOnLayerValueUnit;

const
  ptThisYear = 1;
  ptNextYear = 0;
  ptHistory = 2;

  lbParcelID  = 0;
  lbOwnerName = 1;
  lbLegalAddress = 2;
  lbAccountNo = 3;
  lbSalePrice = 4;
  lbAssessedValue = 5;
  lbAssessedValue_SalesPrice_Ratio = 6;
  lbPropertyClass = 7;
  lbNone = 8;

  mmtOnMapNotPAS = 0;
  mmtInPASNotMap = 1;

{====================================================================}
Procedure TMappingForm.MapExceptionHandler(Sender : TObject;
                                           E : Exception);

{This is the exception handler that will be assigned to the overall application.
 So, rather than a regular message dlg. being shown, we will display our own
 message and can customize it based on what type of exception it is.
 This exception handler is assigned to be the default application exception
 handler in the create of this form.}

const
  EDatasetNotInEditMode = 'Dataset not in edit or insert mode';
var
  TempStr : String;

begin
  TempStr := E.Message;

  If (E.Message = EDatasetNotInEditMode)
    then TempStr := 'Please click insert or edit on the navigator bar' + #13 +
                    'before making any changes to this information.';

  Screen.ActiveForm.Cursor := crDefault;

end;  {MapExceptionHandler}

{==========================================================================}
Procedure TMappingForm.FormCreate(Sender: TObject);

begin
  SelectedLayerIsRangeLayer := False;
  ModifyParcelPanelVisible := False;
  ModifyParcelPanel.Left := 75;
  ModifyParcelPanel.Top := 3;
  PageControl1.ActivePageIndex := 0;
  CurrentAssessmentTable := TTable.Create(nil);
  PriorAssessmentTable := TTable.Create(nil);
  InitGlblLastLocateInfoRec(GlblLastLocateInfoRec);

  UnknownFieldValues := TStringList.Create;
  UnknownFieldNames := TStringList.Create;

  Application.OnException := MapExceptionHandler;

  GlblMapInfoFormClosed := False;
  GlblMapInfoFormClosingSwisSBLKey := '';

  DialogShowing := False;
  RangeType := 0;
  FillingRanges := False;
  LastFoundSwisSBLKey := '';
  InitializingForm := True;
  LabelDisplayType := lbParcelID;
  CurrentMouseMode := [msZoomRectangle];
  CriteriaInEffect := False;
  TrackingLayerDrawn := False;
  ReloadingLayerBox := False;
  LegalAddressLookup := False;
  CurrentlySelectedList := TStringList.Create;
  DistanceLine := IMoLine(CreateOleObject('MapObjects2.Line'));
  CurrentParcelShape := IMoPolygon(CreateOleObject('MapObjects2.Polygon'));
  LimitExtentRect := IMoRectangle(CreateOleObject('MapObjects2.Rectangle'));
  CurrentLayerItem := -1;
  CurrentLayerListItem := -1;
  SelectedParcelsAreLegalAddress := False;
  SelectedParcelsAreComps := False;

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

  try
    Application.Icon.LoadFromFile('PASMapping.ICO');
  except
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

  SysRecTable.Close;  {Close right away so hopefully don't get in use errors when all go in at once.}

  GlblProcessingType := NextYear;
  GlblTaxYearFlg := 'N';
  AssessmentYear := GlblNextYear;
  ProcessingType := NextYear;

  OpenTablesForForm(Self, GlblProcessingType);

  SetGlobalSBLSegmentFormats(AssessmentYearControlTable);

    {CHG10062003-1: Allow for a different parcel ID format in order to accomodate
                    different IDs coming from the map source file.}

  try
    MapParcelIDFormatTable.TableName := 'mapparcelidtable';
    MapParcelIDFormatTable.Open;
  except
    MapParcelIDFormatTable.TableName := '';
  end;

(*  SetFormStateMaximized(Self); *)
  ApplyingChanges := False;
  LoadFromParcelList := False;
  CreateParcelList := False;

  LayerList := TStringList.Create;

  SelectedSwisCodes := TStringList.Create;
  SelectedSchoolCodes := TStringList.Create;
  SelectedPropertyClasses := TStringList.Create;
  SelectedRollSections := TStringList.Create;
  SelectedSDCodes := TStringList.Create;
  SelectedEXCodes := TStringList.Create;

  FillOneListBox(PropertyClassListBox, PropertyClassTable,
                 'MainCode', 'Description',
                 10, True, True, GlblProcessingType, AssessmentYear);
  PropertyClassListBox.TopIndex := 1;

  SelectItemsInListBox(RollSectionListBox);

  ChooseAssessmentYearRadioGroupClick(Sender);

  MapInfoFormList := TStringList.Create;

  WindowState := wsMaximized;
    {Set the default map setup options.}

  MapSetupObject := TMapSetupObject.Create;

  SetMapOptions('', True,
                MappingHeaderTable, MappingDetailTable,
                MapLayersAvailableTable, MapParcelIDFormatTable, MapSetupObject);

  MapLabelRadioGroup.ItemIndex := MapSetupObject.LabelType;
  FillStyleComboBox.ItemIndex := MapSetupObject.FillType;
  FillColorShape.Brush.Color := MapSetupObject.FillColor;
  FillColorShape.Refresh;

  SelectedFillColor := FillColorShape.Brush.Color;
  SelectedFillStyle := FillStyleComboBox.ItemIndex;

    {We need to create the layers check list box by hand because the items won't delete!!!}

(*  LayersCheckListBox := TCheckListBox.Create(LayersCheckListPanel);
  LayersCheckListBox.Align := alClient;
  LayersCheckListBox.Sorted := True;
  LayersCheckListBox.OnClickCheck := LayersCheckListBoxClickCheck;
  LayersCheckListBox.OnMouseMove := LayersCheckListBoxMouseMove; *)

  LoadLayersIntoLayerBox(LayersCheckListBox,
                         MappingHeaderTable.FieldByName('MappingSetupName').Text,
                         MapLayersAvailableTable,
                         MappingDetailTable);

(*  LoadLayersIntoLayerListBox(AvailableLayersListBox, MapLayersAvailableTable,
                             MappingDetailTable, True);*)

  ParcelLookupTable.IndexName := MapSetupObject.PASIndex;

    {Open the tables in the data module.}

  DataModuleComponentIndex := 0;
  OpenTablesInDataModuleTimer.Enabled := True;

  Application.ShowHint := True;
  InitializingForm := False;

  GlblLastLocateKey := 1;
  GlblLastSwisSBLKey := '';

  LockWindowUpdate(Handle);
  MappingOptionsForm := TMappingOptionsForm.Create(nil);

  try
    MappingOptionsForm.CloseOnStart := True;
    MappingOptionsForm.ShowModal;
  finally
    MappingOptionsForm.Free;
  end;
  LockWindowUpdate(0);

  SelectedLayerDc := IMoDataConnection(CreateOleObject('MapObjects2.DataConnection'));

    {CHG09132003-1: Add feature to search for condominium units
                    if only the base parcel id is coded on the map.}

  CondominiumUnitList := TStringList.Create;
  OnlyBaseCondominiumParcelIdIsEncoded := True;
  try
    MapCondoTable.TableName := 'MapCondoTable';
    MapCondoTable.Open;
  except
    OnlyBaseCondominiumParcelIdIsEncoded := False;
  end;

  MapRangeList := TList.Create;
  MapTimer.Enabled := True;
  MapInfoFormSynchronizeTimer.Enabled := True;

end;  {FormCreate}

{==========================================================================}
Procedure TMappingForm.FormKeyPress(Sender: TObject; var Key: Char);

{CHG07172002-2: Add key shortcuts for pan and zoom.}

begin
  case Key of
    '+' : SBZoomInClick(Sender);
    '-' : SBZoomOutClick(Sender);

    #13 : begin
            Perform(WM_NextDlgCtl, 0, 0);
            Key := #0;
          end;  {If (Key = #13)}

  end;  {case Key of}

end;  {FormKeyPress}

{==========================================================================}
Procedure TMappingForm.FormKeyDown(    Sender: TObject;
                                   var Key: Word;
                                       Shift: TShiftState);

var
  PanIt : Boolean;

begin
  PanIt := False;

  case Key of
    VK_LEFT :
      begin
        TWinControl(Sender).Name := 'Left';
        PanIt := True;
      end;

    VK_UP :
      begin
        TWinControl(Sender).Name := 'Up';
        PanIt := True;
      end;

    VK_DOWN :
      begin
        TWinControl(Sender).Name := 'Down';
        PanIt := True;
      end;

    VK_RIGHT :
      begin
        TWinControl(Sender).Name := 'Right';
        PanIt := True;
      end;

      {CHG11102003-1(M1.4): Allow for cancelling of actions.}

    VK_ESCAPE : ActionCancelled := True;

  end;  {case Key of}

  If PanIt
    then PanButtonClick(Sender);

end;  {FormKeyDown}

{==========================================================================}
Procedure TMappingForm.ChooseAssessmentYearRadioGroupClick(Sender: TObject);

var
  Quit : Boolean;

begin
  Quit := False;

  case ChooseAssessmentYearRadioGroup.ItemIndex of
    0 : begin
          AssessmentYear := GlblNextYear;
          ProcessingType := NextYear;

          EditHistoryYear.Text := '';
          EditHistoryYear.Visible := False;

        end;  {Next Year}

    1 : begin
          AssessmentYear := GlblThisYear;
          ProcessingType := ThisYear;
          EditHistoryYear.Text := '';
          EditHistoryYear.Visible := False;

        end;  {This Year}

    2 : begin
          ProcessingType := History;

          EditHistoryYear.SetFocus;
          EditHistoryYear.Visible := True;

          If (Deblank(EditHistoryYear.Text) = '')
            then
              begin
                EditHistoryYear.Text := GlblHistYear;
                AssessmentYear := GlblHistYear;
              end;

        end;  {History}

  end;  {case ChooseAssessmentYearRadioGroup.ItemIndex of}

  OpenTableForProcessingType(ExemptionCodeTable, ExemptionCodesTableName,
                             ProcessingType, Quit);
  OpenTableForProcessingType(SDCodeTable, SdistCodeTableName,
                             ProcessingType, Quit);
  OpenTableForProcessingType(SwisCodeTable, SwisCodeTableName,
                             ProcessingType, Quit);
  OpenTableForProcessingType(SchoolCodeTable, SchoolCodeTableName,
                             ProcessingType, Quit);
  OpenTableForProcessingType(AssessmentYearControlTable, AssessmentYearControlTableName,
                             ProcessingType, Quit);
  OpenTableForProcessingType(ParcelEXTable, ExemptionsTableName,
                             ProcessingType, Quit);
  OpenTableForProcessingType(ParcelSDTable, SpecialDistrictTableName,
                             ProcessingType, Quit);
  OpenTableForProcessingType(ParcelTable, ParcelTableName,
                             ProcessingType, Quit);
  OpenTableForProcessingType(ParcelLookupTable, ParcelTableName,
                             ProcessingType, Quit);

    {FXX03052003-1: The ProcessingType was hardcoded to NextYear.}

  OpenTableForProcessingType(ParcelLookupTable2, ParcelTableName,
                             ProcessingType, Quit);

  FillOneListBox(ExemptionListBox, ExemptionCodeTable, 'EXCode',
                 'Description', 10, True, True, ProcessingType, AssessmentYear);
  FillOneListBox(SpecialDistrictListBox, SDCodeTable, 'SDistCode',
                 'Description', 10, True, True, ProcessingType, AssessmentYear);
  FillOneListBox(SwisCodeListBox, SwisCodeTable, 'SwisCode',
                 'MunicipalityName', 10, True, True, ProcessingType, AssessmentYear);
  FillOneListBox(SchoolCodeListBox, SchoolCodeTable, 'SchoolCode',
                 'SchoolName', 10, True, True, ProcessingType, AssessmentYear);

  ExemptionListBox.TopIndex := 1;
  SpecialDistrictListBox.TopIndex := 1;
  SwisCodeListBox.TopIndex := 1;
  SchoolCodeListBox.TopIndex := 1;

end;  {ChooseAssessmentYearRadioGroupClick}

{==========================================================================}
Procedure TMappingForm.FillColorButtonClick(Sender: TObject);

begin
  If ColorDialog.Execute
    then
      begin
        FillColorShape.Brush.Color := ColorDialog.Color;
        SelectedFillColor := ColorDialog.Color;

        If (CurrentlySelectedList.Count > 0)
          then
            begin
              SelectedLayer.Symbol.Color := SelectedFillColor;
              Map.RefreshRect(Map.Extent);

            end;

      end;  {If ColorDialog.Execute}

end;  {FillColorButtonClick}

{==========================================================================}
Procedure TMappingForm.MapLabelRadioGroupClick(Sender: TObject);

var
  CurrentZoomPercent : Double;

begin
  LabelDisplayType := MapLabelRadioGroup.ItemIndex;

  with Map do
    try
      CurrentZoomPercent := Extent.Height / FullExtent.Height;
    except
      CurrentZoomPercent := 100;
    end;

  If (CurrentZoomPercent < MapSetupObject.DefaultZoomPercentToDrawDetails)
    then
      begin
        TrackingLayerDrawn := False;  {Force redraw of selected items.}
        Map.RefreshRect(Map.Extent);
      end;

end;  {MapLabelRadioGroupClick}

{==========================================================================}
Procedure TMappingForm.FillStyleComboBoxChange(Sender: TObject);

begin
  SelectedFillStyle := FillStyleComboBox.ItemIndex;

  If (CurrentlySelectedList.Count > 0)
    then
      begin
        SelectedLayer.Symbol.Style := SelectedFillStyle;
        Map.RefreshRect(Map.Extent);
      end;

end;  {FillStyleComboBoxChange}

{==========================================================================}
Procedure TMappingForm.AllCodesButtonClick(Sender: TObject);

var
  ListBox : TListBox;

begin
  ListBox := nil;

  with Sender as TButton do
    begin
      If (Name = 'AllRollSectionsButton')
        then ListBox := RollSectionListBox;

      If (Name = 'AllPropertyClassesButton')
        then ListBox := PropertyClassListBox;

      If (Name = 'AllSwisCodesButton')
        then ListBox := SwisCodeListBox;

      If (Name = 'AllSchoolCodesButton')
        then ListBox := SchoolCodeListBox;

      If (Name = 'AllExemptionCodesButton')
        then ListBox := ExemptionListBox;

      If (Name = 'AllSpecialDistrictsButton')
        then ListBox := SpecialDistrictListBox;

    end;  {with Sender as Button do}

  If (ListBox <> nil)
    then
      begin
        SelectItemsInListBox(ListBox);
        ListBox.TopIndex := 1;
      end;

end;  {AllCodesButtonClick}

{==========================================================================}
Procedure TMappingForm.OpenTablesInDataModuleTimerTimer(Sender: TObject);

{Open the tables in the data module on a timer so that they do not
 slow down the open.}

begin
  with PASDataModule do
    begin
      If ((Components[DataModuleComponentIndex] is TwwTable) and
          (Deblank(TwwTable(Components[DataModuleComponentIndex]).TableName) <> ''))
        then
          try
            TwwTable(Components[DataModuleComponentIndex]).Open;
          except
            MessageDlg('Error opening table ' +
                       TwwTable(Components[DataModuleComponentIndex]).Name +
                       ' in data module.', mtError, [mbOK], 0);
          end;

      DataModuleComponentIndex := DataModuleComponentIndex + 1;

      If (DataModuleComponentIndex > (ComponentCount - 1))
        then OpenTablesInDataModuleTimer.Enabled := False;

    end;  {with PASDataModule do}

end;  {OpenTablesInDataModuleTimerTimer}

{==========================================================================}
Procedure TMappingForm.AddSelectedParcelLayer;

{CHG11262002-1: Create a layer for the selected parcels rather than using
                the tracking layer.}

var
  Td : IMoTableDesc;
  Gd : IMoGeoDataset;
  LayerName, LayerDatabaseName : String;
  I : Integer;

begin
  //create new geodataset
  Td := IMoTableDesc(CreateOleObject('MapObjects2.TableDesc'));

    {First set up the extra fields we need in this shapefile.}

  with Td do
    begin
      FieldCount := 6;

      FieldName[0] := 'ParcelID';
      FieldType[0] := moString;
      FieldLength[0]:= 26;

      FieldName[1] := 'AltLabel';  {AlternateLabel}
      FieldType[1] := moString;
      FieldLength[1]:= 20;

      FieldName[2] := 'UseAltLbl';  {UseAlternateLabel for this parcel}
      FieldType[2] := moBoolean;

      FieldName[3] := 'Fill';
      FieldType[3] := moLong;
      FieldPrecision[3]:= 8;

      FieldName[4] := 'Color';
      FieldType[4] := moLong;
      FieldPrecision[4]:= 8;

      FieldName[5] := 'AltLblClr';
      FieldType[5] := moLong;
      FieldPrecision[5]:= 8;

    end;  {with Td do}

    {Create this in the same place as the main layer.}

  For I := 0 to (MapSetupObject.GetLayerCount - 1) do
    If MapSetupObject.IsMainLayer(MapSetupObject.GetLayerName(I))
      then
        begin
          LayerName := MapSetupObject.GetLayerName(I);
          LayerDatabaseName := MapSetupObject.GetLayerDatabaseName(LayerName);

            {CHG08032004-2(2.08.0.08042004): Allow for all users to create selected layers locally.}

          If GlblAllUsersCreatesSelectedMapLayerLocally
            then
              begin
                LayerDatabaseName[1] := 'C';

                If not DirectoryExists(LayerDatabaseName)
                  then ForceDirectories(LayerDatabaseName);

              end;  {If GlblSearcherCreatesSelectedMapLayerLocally}

          SelectedLayerLocation := LayerDatabaseName;
          SelectedLayerDc.database := GetLayerTypePrefix(MapSetupObject.GetLayerType(LayerName)) +
                                      LayerDatabaseName;

        end;  {If MapSetupObject.IsMainLayer}

  //try to connect
  If not SelectedLayerDc.Connect
    then
      begin
        MessageDlg('Error connecting to path for selected parcel layer.', mtError, [mbOK], 0);
        Exit;
      end;

  SelectedLayerFileName := GetTemporaryFileName('SelectedParcels');

  //create the three files *.shp, *.shx, *.dbf

  Gd := SelectedLayerDc.AddGeoDataset(SelectedLayerFileName, moPolygon, Td, False, False); //no Z no measures
  //the layer

  SelectedLayer := IMoMapLayer(CreateOleObject('MapObjects2.MapLayer'));

  with SelectedLayer do
    begin
      GeoDataset       := Gd;
      Visible          := True;
      Symbol.SymbolType:= moFillSymbol;
      Symbol.Style     := SelectedFillStyle;
      Symbol.Color     := SelectedFillColor;
      Tag := SelectedLayerFileName;

    end;  {with SelectedLayer do}

  //add to the window
  Map.Layers.Add(SelectedLayer);

end;  {AddSelectedParcelLayer}

{========================================================}
Procedure TMappingForm.SelectedLayerDeleteTimerTimer(Sender: TObject);

var
  Return : Integer;
  Done, FirstTimeThrough : Boolean;
  SearchRec : TSearchRec;

begin
  SelectedLayerDeleteTimer.Enabled := False;

  Done := False;
  Return := 0;
  FirstTimeThrough := True;
  FindFirst(SelectedLayerToDelete + '.*', faAnyFile, SearchRec);

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else Return := FindNext(SearchRec);

    If (Return <> 0)
      then Done := True;

    If ((not Done) and
        (SearchRec.Name <> '.') and
        (SearchRec.Name <> '..'))
      then
        try
          DeleteFile(SelectedLayerLocation + SearchRec.Name);
        except
        end;

  until Done;

end;  {SelectedLayerDeleteTimerTimer}

{==========================================================================}
Procedure TMappingForm.DeleteSelectedLayerGeoDataset;

var
  I : Integer;
  MapLayer : IMoMapLayer;

begin
    {To clear it, delete the old and add the new.}

  For I := (Map.Layers.Count - 1) downto 0 do
    begin
      MapLayer := IMoMapLayer(Map.Layers.Item(I));

      If (ANSIUpperCase(MapLayer.Tag) = ANSIUpperCase(SelectedLayerFileName))
        then Map.Layers.Remove(I);

    end;  {For I := 0 to (Map.Layers.Count - 1) do}

  If SelectedLayerDc.Connected
    then SelectedLayerDc.Disconnect;

  SelectedLayerToDelete := SelectedLayerLocation + SelectedLayerFileName;
  SelectedLayerDeleteTimer.Enabled := True;
(*  Application.ProcessMessages;*)

end;  {DeleteSelectedLayerGeoDataset}

{==========================================================================}
Procedure TMappingForm.ClearSelectedInformation;

{Clear the selected list and layer.}

begin
  SelectedLayerIsRangeLayer := False;
  CurrentlySelectedList.Clear;

  SelectedLayerDc.Disconnect;
  DeleteSelectedLayerGeoDataset;

  AddSelectedParcelLayer;

end;  {ClearSelectedLayer}

{==========================================================================}
Procedure TMappingForm.RefreshSelectedLayer;

var
  I, Index : Integer;
  MapLayer : IMoMapLayer;

begin
  Index := 0;
  For I := (Map.Layers.Count - 1) downto 0 do
    begin
      MapLayer := IMoMapLayer(Map.Layers.Item(I));

      If (ANSIUpperCase(MapLayer.Tag) = ANSIUpperCase(SelectedLayerFileName))
        then Index := I;

    end;  {For I := 0 to (Map.Layers.Count - 1) do}

  Map.RefreshLayer(Index);

end;  {RefreshSelectedLayer}

{==========================================================================}
Procedure TMappingForm.AddItemToSelectedLayer(P : IMoPolygon;
                                              ParcelID : String;
                                              AlternateLabel : String;
                                              AlternateLabelColor : TColor;
                                              FillStyle : Integer;
                                              FillColor : TColor;
                                              UseAltLabel : Boolean);

begin
  with SelectedLayer.Records do
    try
      AddNew;
      Fields.Item('Shape').Value := P;
      Fields.Item('Fill').Value := FillStyle;
      Fields.Item('Color').Value := FillColor;
      Fields.Item('ParcelID').Value := ParcelID;
      Fields.Item('AltLabel').Value := AlternateLabel;
      Fields.Item('AltLblClr').Value := AlternateLabelColor;
      Fields.Item('UseAltLbl').Value := UseAltLabel;
      Update;
      StopEditing;
    except
      MessageDlg('Could not add ' + ParcelID + ' to selected layer.', mtError, [mbOK], 0);
    end;

end;  {AddItemToSelectedLayer}

{==========================================================================}
Procedure TMappingForm.RemoveItemFromSelectedLayer(P : IMoPolygon;
                                                   ParcelID : String);

var
  Recs : IMoRecordset;

begin
  Recs := SelectedLayer.SearchShape(Map.Extent, moAreaIntersect,
                                    'ParcelID = ''' + ParcelID + '''');
  Recs.MoveFirst;

  If not Recs.EOF
    then
      try
        Recs.Delete;
      except
      end;

end;  {RemoveItemFromSelectedLayer}

{==========================================================================}
Procedure TMappingForm.MapTimerTimer(Sender: TObject);

var
  I : Integer;
  HasImageLayer, Done, Continue : Boolean;
  CompsFileName, TempStr : String;
  EqualsPos : Integer;
  CompsFile : TextFile;

begin
  MapTimer.Enabled := False;

  DisplayAutoLoadLayers(MapSetupObject, Map,
                        MainLayer, ImageLayer, MainLayerName,
                        MainLayerFileName, MainLayerLocation, True, HasImageLayer);

  FullSizeRect := IMoRectangle(CreateOleObject('MapObjects2.Rectangle'));
  FullSizeRect := Map.FullExtent;

    {CHG11262002-1: Create a layer for the selected parcels rather than using
                    the tracking layer.}

  AddSelectedParcelLayer;

  CompsFileName := '';
  LoadingComps := False;

  For I := 1 to ParamCount do
    begin
      TempStr := ParamStr(I);
      Continue := True;

      If (Pos('COMPS', ANSIUppercase(TempStr)) > 0)
        then
          begin
            EqualsPos := Pos('=', TempStr);
            CompsFileName := Trim(Copy(TempStr, (EqualsPos + 1), 200));

              {Load them into the selected list.}

            try
              AssignFile(CompsFile, CompsFileName);
              Reset(CompsFile);
            except
              Continue := False;
            end;

            If Continue
              then
                begin
                  Done := False;

                  repeat
                    Readln(CompsFile, TempStr);

                    If EOF(CompsFile)
                      then Done := True;

                    CurrentlySelectedList.Add(TempStr);

                  until Done;

                end;  {If Continue}

            CloseFile(CompsFile);

            LoadingComps := True;
            SelectedParcelsAreComps := True;

          end;  {If (Pos('COMPS', ANSIUppercase(TempStr)) > 0)}

    end;  {For I := 1 to ParamCount do}

  If LoadingComps
    then
      begin
        TrackingLayerDrawn := False;
        Map.TrackingLayer.Refresh(True, Map.Extent);
      end;

end;  {MapTimerTimer}

{========================================================}
Procedure TMappingForm.AvailableLayersListBoxMouseDown(Sender: TObject;
                                                       Button: TMouseButton;
                                                       Shift: TShiftState;
                                                       X, Y: Integer);

begin
(*  Point.X := X;
  Point.Y := Y;
  CurrentLayerListItem := AvailableLayersListBox.ItemAtPos(Point, True);*)

end;  {AvailableLayersListBoxMouseDown}

{========================================================}
Procedure TMappingForm.AvailableLayersListBoxClick(Sender: TObject);

begin
(*  AddOneLayer(AvailableLayersListBox.Items[CurrentLayerListItem],
              MainLayer, MapSetupObject, Map);*)

end;  {AvailableLayersListBoxClick}

(*
{========================================================}
Procedure TMappingForm.LegendMouseDown(    Sender: TObject;
                                       var Index,
                                           Button,
                                           Shift: Smallint;
                                       var X, Y: Single);

var
  LayerName : String;
  MapLayer : IMoMapLayer;
  LoadIt : WordBool;
  I : Integer;

begin
    {Remove this layer.}
  LayerName := Legend.GetEntryName(Index);

  For I := (Map.Layers.Count - 1) downto 0 do
    begin
      MapLayer := IMoMapLayer(Map.Layers.Item(I));

      If (ANSIUpperCase(MapLayer.Tag) = LayerName)
        then Map.Layers.Remove(I);

    end;  {For I := 0 to (Map.Layers.Count - 1) do}

  LoadIt := True;
  Legend.LoadLegend(LoadIt);

end;  {LegendMouseDown} *)

{========================================================}
Procedure TMappingForm.LayersCheckListBoxMouseMove(Sender: TObject;
                                                   Shift: TShiftState;
                                                   X, Y: Integer);

var
  Point : TPoint;

begin
  Point.X := X;
  Point.Y := Y;
  CurrentLayerItem := LayersCheckListBox.ItemAtPos(Point, True);

end;  {LayersCheckListBoxMouseMove}

{========================================================}
Procedure TMappingForm.LayersCheckListBoxClickCheck(Sender: TObject);

var
  I : Integer;
  MapLayer : IMoMapLayer;

begin
  If ((not ReloadingLayerBox) and
      (CurrentLayerItem <> -1))
    then
      begin
          {Don't let them turn off the main layer.}

        If (Pos('(Main)', LayersCheckListBox.Items[CurrentLayerItem]) > 0)
          then
            begin
              MessageDlg('Sorry, that is the main layer and can not be removed.',
                         mtError, [mbOK], 0);
              LayersCheckListBox.Checked[CurrentLayerItem] := True;
            end
          else
            begin
                 {Turn the layer on or off.}

              TrackingLayerDrawn := False;  {Force redraw of selected items.}

              If LayersCheckListBox.Checked[CurrentLayerItem]
                then
                  begin
                      {If this is an image layer, just set the visible to true.}

                    If (ANSIUpperCase(LayersCheckListBox.Items[CurrentLayerItem]) = 'IMAGE')
                      then
                        begin
                          ImageLayer.Visible := True;
                          MainLayer.Symbol.Style := moTransparentFill;
                          Map.Refresh;
                        end
                      else AddOneLayer(LayersCheckListBox.Items[CurrentLayerItem],
                                       MainLayer, MapSetupObject, Map)

                  end
                else
                  begin
                      {Remove the layer.}

                    If (ANSIUpperCase(LayersCheckListBox.Items[CurrentLayerItem]) = 'IMAGE')
                      then
                        begin
                          ImageLayer.Visible := False;
                          MainLayer.Symbol.Style := moSolidFill;
                          Map.Refresh;
                        end
                      else
                        For I := (Map.Layers.Count - 1) downto 0 do
                          begin
                            MapLayer := IMoMapLayer(Map.Layers.Item(I));

                            If (ANSIUpperCase(MapLayer.Tag) =
                                ANSIUpperCase(LayersCheckListBox.Items[CurrentLayerItem]))
                              then Map.Layers.Remove(I);

                          end;  {For I := 0 to (Map.Layers.Count - 1) do}

                  end;  {eles of If LayersCheckListBox.Selected[CurrentLayerItem]}

            end;  {If (Pos('(Main)', ...}

      end;  {If (CurrentLayerItem <> -1)}

end;  {LayersCheckListBoxClickCheck}

{========================================================}
Procedure TMappingForm.IdentifySpeedButtonClick(Sender: TObject);

begin
  CurrentMouseMode := [msIdentifyParcel];
end;

{========================================================}
Procedure TMappingForm.SelectModeSpeedButtonClick(Sender: TObject);

begin
  CriteriaInEffect := False;
  CurrentMouseMode := [msSelectParcel];
end;

{========================================================}
Procedure TMappingForm.ModifySpeedButtonClick(Sender: TObject);

{Display a form where they can edit the DBF for the main layer.}

begin
  CurrentMouseMode := [msModifyParcel];
end;  {ModifySpeedButtonClick}

{========================================================}
Procedure TMappingForm.MapRangeSpeedButtonClick(Sender: TObject);

begin
  CurrentMouseMode := [msZoomRectangle];
end;

{========================================================}
Procedure TMappingForm.DistanceSpeedButtonClick(Sender: TObject);

begin
  CurrentMouseMode := [msDistanceMeasure];
  StartingDistanceMeasurePoint := nil;
  ProgressBar.Visible := False;

end;  {DistanceSpeedButtonClick}

{========================================================}
Function TMappingForm.ParcelMeetsCriteria(ParcelLookupTable : TTable) : Boolean;

var
  SwisSBLKey : String;
  ExemptionFound, SDCodeFound,
  Done, FirstTimeThrough : Boolean;

begin
  SwisSBLKey := ExtractSSKey(ParcelLookupTable);

  with ParcelLookupTable do
    Result := ((SelectedPropertyClasses.IndexOf(FieldByName('PropertyClassCode').Text) > -1) and
               (SelectedSwisCodes.IndexOf(FieldByName('SwisCode').Text) > -1) and
               (SelectedSchoolCodes.IndexOf(FieldByName('SchoolCode').Text) > -1) and
               (SelectedRollSections.IndexOf(FieldByName('RollSection').Text) > -1));

  If (Result and
      (SelectedEXCodes.Count < ExemptionListBox.Items.Count))  {Not all selected}
    then
      begin
        Done := False;
        FirstTimeThrough := True;
        ExemptionFound := False;

        SetRangeOld(ParcelEXTable, ['TaxRollYr', 'SwisSBLKey', 'ExemptionCode'],
                    [AssessmentYear, SwisSBLKey, '     '],
                    [AssessmentYear, SwisSBlKey, 'zzzzz']);

        repeat
          If FirstTimeThrough
            then FirstTimeThrough := False
            else ParcelEXTable.Next;

          If ParcelEXTable.EOF
            then Done := True;

          If ((not Done) and
              (SelectedEXCodes.IndexOf(ParcelEXTable.FieldByName('ExemptionCode').Text) > -1))
            then ExemptionFound := True;

        until (Done or (not Result));

        Result := ExemptionFound;

      end;  {If Result}

  If (Result and
      (SelectedSDCodes.Count < SpecialDistrictListBox.Items.Count))  {Not all selected}
    then
      begin
        Done := False;
        FirstTimeThrough := True;
        SDCodeFound := False;

        SetRangeOld(ParcelSDTable, ['TaxRollYr', 'SwisSBLKey', 'SDistCode'],
                    [AssessmentYear, SwisSBLKey, '     '],
                    [AssessmentYear, SwisSBlKey, 'zzzzz']);

        repeat
          If FirstTimeThrough
            then FirstTimeThrough := False
            else ParcelSDTable.Next;

          If ParcelSDTable.EOF
            then Done := True;

          If ((not Done) and
              (SelectedSDCodes.IndexOf(ParcelSDTable.FieldByName('SDistCode').Text) > -1))
            then SDCodeFound := True;

        until (Done or (not Result));

        Result := SDCodeFound;

      end;  {If Result}

end;  {ParcelMeetsCriteria}

{========================================================}
Procedure TMappingForm.MapAfterLayerDraw(Sender: TObject;
                                         index: Smallint;
                                         canceled: WordBool;
                                         hDC: Cardinal);

var
  recs, SelectedRecs : IMoRecordset;
  fld  : IMoField;
  p : IMoPolygon;
  CompsAreaRect, CurrentRect : IMoRectangle;
  tsym   : IMoTextSymbol;
  sym   : IMoSymbol;
  ft    : TFont;
  oleFt : variant;
  CurrentZoomPercent : Double;
  TextBaseLine : IMoLine;
  CompsFile : TextFile;
  SwisSBLKey, TempStr, TempSearchStr : String;
  IsCondoBuilding, _Found, Done,
  Continue, FirstComp, SaleFound : Boolean;
  FieldName : OLEVariant;
  I, SelectedLayerIndex, MainLayerIndex : Integer;
  MapLayer : IMoMapLayer;
  ScaleX, ScaleY, BaseLineLength : Extended;
  AssessedValue, SalesPrice : LongInt;

begin
  SelectedLayerIndex := 0;
  MainLayerIndex := 0;
  For I := (Map.Layers.Count - 1) downto 0 do
    begin
      MapLayer := IMoMapLayer(Map.Layers.Item(I));

      If (ANSIUpperCase(MapLayer.Tag) = ANSIUpperCase(MainLayerName))
        then MainLayerIndex := I;

      If (ANSIUpperCase(MapLayer.Tag) = ANSIUpperCase(SelectedLayerFileName))
        then SelectedLayerIndex := I;

    end;  {For I := 0 to (Map.Layers.Count - 1) do}

  If not DialogShowing
    then
      begin
        CurrentRect := IMoRectangle(CreateOleObject('MapObjects2.Rectangle'));
        CurrentRect := Map.Extent;

        If LoadingComps
          then
            begin
              Continue := True;

              try
                AssignFile(CompsFile, CompsFileName);
                Reset(CompsFile);
              except
                Continue := False;
              end;

              If Continue
                then
                  begin
                    Done := False;

                      {First load the comps into a stringlist.}

                    ParcelLookupTable.IndexName := 'BYSWISSBLKEY';
                    CompsAreaRect := IMoRectangle(CreateOleObject('MapObjects2.Rectangle'));

                    repeat
                      Readln(CompsFile, TempStr);

                      If EOF(CompsFile)
                        then Done := True;

                      If FindKeyOld(ParcelLookupTable, ['SwisSBLKey'],
                                    [TempStr])
                        then
                          begin
                            TempSearchStr := 'Acct_Num = ''' +
                                             Take(11, ParcelLookupTable.FieldByName('AccountNo').Text) +
                                             '''';

                            recs := MainLayer.SearchExpression(TempSearchStr);
                            FirstComp := True;

                            while not Recs.EOF do
                              begin
                                fld := recs.Fields.item('Shape');
                                p := IMoPolygon(CreateOleObject('MapObjects2.Polygon'));
                                p :=IMoPolygon(IDispatch(fld.value));

                                If FirstComp
                                  then
                                    begin
                                      FirstComp := False;
                                      CompsAreaRect := p.Extent;
                                    end
                                  else
                                    begin
                                      If (P.Extent.Left < CompsAreaRect.Left)
                                        then CompsAreaRect.Left := P.Extent.Left;

                                      If (P.Extent.Right > CompsAreaRect.Right)
                                        then CompsAreaRect.Right := P.Extent.Right;

                                      If (P.Extent.Top < CompsAreaRect.Top)
                                        then CompsAreaRect.Top := P.Extent.Top;

                                      If (P.Extent.Bottom > CompsAreaRect.Bottom)
                                        then CompsAreaRect.Bottom := P.Extent.Bottom;

                                    end;  {If FirstComp}

                                sym :=IMoSymbol(CreateOleObject('MapObjects2.Symbol'));
                                sym.Style := moDiagonalCrossFill;
                                sym.color :=clBlue;

                                Map.DrawShape(p, sym);

                                  {Display the map info dialog.}

      (*                          LockWindowUpdate(Handle);
                                MapInfoForm := TMapParcelInfoForm.Create(Application);

                                with MapInfoForm do
                                  begin
                                    Left := Mouse.CursorPos.X;
                                    Top := Mouse.CursorPos.Y;
                                    FillInParcelInformation(ParcelLookupTable);

                                    If (CompNumber > 0)
                                      then MapInfoForm.Caption := 'Comparable ' + IntToStr(CompNumber)
                                      else MapInfoForm.Caption := 'Subject';

                                    CompNumber := CompNumber + 1;
                                    Show;

                                  end;  {with MapParcelInfoForm do}

                                MapInfoFormList.Add(MapInfoForm);

                                LockWindowUpdate(0); *)

                                Application.ProcessMessages;

                                recs.MoveNext;

                              end;  {while not Recs.EOF do}

                          end;  {If FindKeyOld(ParcelLookupTable, ['SwisSBLKey'],}

                    until Done;

      (*              Map.Extent := CompsAreaRect; *)

                    ParcelLookupTable.IndexName := 'BYACCOUNTNO';
                    LoadingComps := False;
                    CloseFile(CompsFile);

                  end;  {If Continue}

            end;  {If LoadingComps}

          {Display labels}
          {FXX01022003-1: Only redisplay the labels after the redraw of the main layer.}

        If ((not (ApplyingChanges or LoadFromParcelList or LoadingComps)) and
            (Index = MainLayerIndex) and
            (LabelDisplayType <> lbNone))
          then
            begin
              with Map do
                CurrentZoomPercent := Extent.Height / FullExtent.Height;

              If (CurrentZoomPercent < MapSetupObject.DefaultZoomPercentToDrawDetails)
                then
                  begin
                    ft := TFont.Create;
                    ft.Name := 'Times New Roman';
                    ft.size := 8;
                    oleFt := FontToOleFont(ft);

                    recs := MainLayer.SearchShape(CurrentRect, moCentroidInPolygon, '');
                    recs.MoveFirst;
                    ActionCancelled := False;

                    while not (Recs.EOF or ActionCancelled) do
                      begin
                        fld := recs.Fields.item('Shape');
                        p := IMoPolygon(CreateOleObject('MapObjects2.Polygon'));
                        p :=IMoPolygon(IDispatch(fld.value));

                          {If this parcel is in the selected layer and the selected
                           layer has an alternate ID, display it.}

                        SelectedRecs := SelectedLayer.SearchShape(p, moIdentical, '');

                        If (SelectedRecs.EOF or
                            (SelectedRecs.Fields.Item('UseAltLbl').Value = False))
                          then
                            begin
                              TextBaseLine := IMoLine(CreateOleObject('MapObjects2.Line'));

                              BaseLineLength := DetermineLabelBaseline(P, TextBaseLine);

                              tsym :=IMoTextSymbol(CreateOleObject('MapObjects2.TextSymbol'));

                              tsym.color := MapSetupObject.LabelColor;
                              tsym.HorizontalAlignment := moAlignCenter;
                              tsym.VerticalAlignment := moAlignCenter;
                              tsym.Font := IFontDisp(IDispatch(oleFt));

                              FieldName := MapSetupObject.MapFileKeyField;

                                {FXX07072008-1[D1300]: Inactive parcels don't count for lookups.}

                              _Found := (FindParcelForMapRecord(ParcelLookupTable,
                                                                MapParcelIDFormatTable, AssessmentYearControlTable,
                                                                MapSetupObject,
                                                                Recs.Fields.Item(FieldName).Value,
                                                                AssessmentYear) and
                                         ParcelIsActive(ParcelLookupTable));

                              IsCondoBuilding := False;

                              If _Found
                                then SwisSBLKey := ExtractSSKey(ParcelLookupTable)
                                else
                                  If (OnlyBaseCondominiumParcelIdIsEncoded and
                                      FindCondominiumForMapRecord(MapCondoTable,
                                                                  MapSetupObject,
                                                                  Recs.Fields.Item(MapSetupObject.MapFileKeyField).Value))
                                    then
                                      begin
                                        _Found := True;
                                        IsCondoBuilding := True;

                                        with MapCondoTable do
                                          SwisSBLKey := FieldByName('SwisCode').Text + FieldByName('SBL').Text;

                                      end;  {If (OnlyBaseCondominiumParcelIdIsEncoded and ...}

                              If _Found
                                then
                                  begin
                                    If CreateParcelList
                                      then ParcelListDialog.AddOneParcel(SwisSBLKey);

                                      {CHG07172002-3: Allow for sales price and assessed value display.}
                                      {FXX11202002-1: Don't show the swis code in the label.}

                                    If IsCondoBuilding
                                      then
                                        case LabelDisplayType of
                                          lbParcelID : TempStr := 'Condo: ' + ConvertSBLOnlyToDashDot(Copy(SwisSBLKey, 7, 20));
                                          lbOwnerName : TempStr := MapCondoTable.FieldByName('CondoName').Text;
                                          else TempStr := '';
                                        end
                                      else
                                        case LabelDisplayType of
                                          lbParcelID : TempStr := ConvertSBLOnlyToDashDot(Copy(SwisSBLKey, 7, 20));
                                          lbOwnerName : TempStr := ParcelLookupTable.FieldByName('Name1').Text;
                                          lbLegalAddress : TempStr := GetLegalAddressFromTable(ParcelLookupTable);
                                          lbAccountNo : TempStr := ParcelLookupTable.FieldByName('AccountNo').Text;

                                          lbSalePrice :
                                            begin
                                              TempStr := '';

                                              SetRangeOld(SalesTable, ['SwisSBLKey', 'SaleNumber'],
                                                          [SwisSBLKey, '0'],
                                                          [SwisSBLKey, '9999']);

                                              SalesTable.First;

                                              If not SalesTable.EOF
                                                then
                                                  begin
                                                    SalesTable.Last;
                                                    TempStr := FormatFloat(CurrencyNormalDisplay,
                                                                           SalesTable.FieldByName('SalePrice').AsFloat) + ' ' +
                                                               SalesTable.FieldByName('SaleDate').Text;

                                                  end;  {If not SalesTable.EOF}

                                            end;  {lbSalePrice}

                                          lbAssessedValue :
                                            begin
                                              TempStr := '';

                                              _Found := FindKeyOld(AssessmentTable,
                                                                   ['TaxRollYr', 'SwisSBLKey'],
                                                                   [AssessmentYear, SwisSBLKey]);

                                              If _Found
                                                then TempStr := FormatFloat(CurrencyNormalDisplay,
                                                                            AssessmentTable.FieldByName('TotalAssessedVal').AsFloat);

                                            end;  {lbAssessedVal}

                                          lbAssessedValue_SalesPrice_Ratio :
                                            begin
                                              TempStr := '';
                                              SaleFound := False;
                                              SalesPrice := 0;
                                              AssessedValue := 0;

                                              SetRangeOld(SalesTable, ['SwisSBLKey', 'SaleNumber'],
                                                          [SwisSBLKey, '0'],
                                                          [SwisSBLKey, '9999']);

                                              SalesTable.First;

                                              If not SalesTable.EOF
                                                then
                                                  begin
                                                    SalesTable.Last;
                                                    SaleFound := True;
                                                    SalesPrice := SalesTable.FieldByName('SalePrice').AsInteger;
                                                    AssessedValue := SalesTable.FieldByName('TotAssessedVal').AsInteger;

                                                  end;  {If not SalesTable.EOF}

                                                {CHG11112003-3(M1.4): Allow the user to choose how many decimals to display for AV\SP ratio.}

                                              If SaleFound
                                                then
                                                  try
                                                    If (SalesPrice > 0)
                                                      then TempStr := FormatFloat(GetAV_SP_DecimalDisplayFormat(MapSetupObject),
                                                                                  Roundoff((AssessedValue / SalesPrice), 2));
                                                  except
                                                    TempStr := '';
                                                  end;

                                            end;  {lbAssessedValue_SalesPrice_Ratio}

                                            {CHG11102003-2(M1.4): Allow property class labeling.}

                                          lbPropertyClass : TempStr := ParcelLookupTable.FieldByName('PropertyClassCode').Text;

                                        end;  {case LabelDisplayType of}

                                    If (TempStr <> '')
                                      then
                                        begin
                                          tsym.Height := GetSymbolHeight(BaseLineLength, TempStr);

                                          try
                                            Map.DrawText(TempStr, TextBaseLine, tsym);
                                          except
                                          end;

                                        end;  {If (TempStr <> '')}

                                  end;  {If _Found}

                            end;  {If (SelectedRecs.EOF or ...}

                        recs.MoveNext;

                      end;  {while not Recs.EOF do}

                  end;  {If (CurrentZoomPercent < 0.01)}

              CreateParcelList := False;

              CurrentScale := GetScale(Self, CurrentRect, Map, ScaleX, ScaleY);
              ScaleComboBox.Text := FormatFloat(_3DecimalDisplay, CurrentScale);

            end;  {else of If ApplyingChanges}

          {If this is the selected layer, draw the information.}

        If ((not (ApplyingChanges or LoadFromParcelList or LoadingComps)) and
            (Index = SelectedLayerIndex))
          then
            begin
              ft := TFont.Create;
              ft.Name := 'Times New Roman';
              ft.size := 8;
              ft.Style := [fsBold];
              oleFt := FontToOleFont(ft);

              recs := SelectedLayer.SearchShape(CurrentRect, moAreaIntersect, '');
              recs.MoveFirst;
              ActionCancelled := False;

              while not (Recs.EOF or ActionCancelled) do
                begin
                  If Recs.Fields.Item('UseAltLbl').Value
                    then
                      begin
                        fld := recs.Fields.item('Shape');
                        p := IMoPolygon(CreateOleObject('MapObjects2.Polygon'));
                        p :=IMoPolygon(IDispatch(fld.value));

                        TextBaseLine := IMoLine(CreateOleObject('MapObjects2.Line'));

                        BaseLineLength := DetermineLabelBaseline(P, TextBaseLine);

                        tsym :=IMoTextSymbol(CreateOleObject('MapObjects2.TextSymbol'));

                        tsym.color := Recs.Fields.Item('AltLblClr').Value;
                        tsym.HorizontalAlignment := moAlignCenter;
                        tsym.VerticalAlignment := moAlignCenter;
                        tsym.Height := GetSymbolHeight(BaseLineLength, TempStr);
                        tsym.Font := IFontDisp(IDispatch(oleFt));
                        TempStr := Recs.Fields.Item('AltLabel').Value;

                        sym :=IMoSymbol(CreateOleObject('MapObjects2.Symbol'));
                        sym.Style := Recs.Fields.Item('Fill').Value;
                        sym.color := Recs.Fields.Item('Color').Value;

                        If (SelectedLayerIsRangeLayer and
                            (not MapRangeRec.DisplayLabels))
                          then TempStr := '';

                        If ((TempStr <> '') or
                            SelectedLayerIsRangeLayer)
                          then
                            begin
                              Map.DrawShape(p, sym);

                              try
                                Map.DrawText(TempStr, TextBaseLine, tsym);
                              except
                              end;

                            end;  {If SelectedRecs.EOF}

                          end;  {If (TempStr <> '')}

                  recs.MoveNext;

                end;  {while not Recs.EOF do}

            end;  {else of If ApplyingChanges}

      end;  {If not DialogShowing}

end;  {MapAfterLayerDraw}

{========================================================}
Procedure TMappingForm.LimitExtentTimerTimer(Sender: TObject);

begin
  LimitExtentTimer.Enabled := False;
  Map.Extent := LimitExtentRect;
  Map.Refresh;

end;  {LimitExtentTimerTimer}

{========================================================}
Procedure TMappingForm.PanButtonClick(Sender: TObject);

var
  PanRect : IMoRectangle;

begin
  PanRect := IMoRectangle(CreateOleObject('MapObjects2.Rectangle'));
  PanRect := Map.Extent;

  with PanRect do
    begin
      If (Pos('Up', TWinControl(Sender).Name) > 0)
        then
          begin
            Bottom := Bottom + 100;
            Top := Top + 100;
          end;

      If (Pos('Right', TWinControl(Sender).Name) > 0)
        then
          begin
            Left := Left + 100;
            Right := Right + 100;
          end;

      If (Pos('Down', TWinControl(Sender).Name) > 0)
        then
          begin
            Top := Top - 100;
            Bottom := Bottom - 100;
          end;

      If (Pos('Left', TWinControl(Sender).Name) > 0)
        then
          begin
            Left := Left - 100;
            Right := Right - 100;
          end;

    end;  {with PanRect, TWinControl(Sender) do}

     {Force recalculation of selected items based on current criteria due to view change.}

  If CriteriaInEffect
    then ApplyingChanges := True;

  TrackingLayerDrawn := False;  {Force redraw of selected items.}
  Map.Extent := PanRect;
  Map.Enabled := False;
  Map.Enabled := True;

end;  {PanButtonClick}

{========================================================}
Procedure TMappingForm.FlashShapeTimerTimer(Sender: TObject);

begin
  FlashShapeTimer.Enabled := False;
  Map.FlashShape(CurrentParcelShape, 3);
end;

{========================================================}
Procedure TMappingForm.LocateSpeedButtonClick(Sender: TObject);

var
  SwisSBLKey : String;
  recs : IMoRecordset;
  tdesc: IMoTableDesc;
  flds : IMoFields;
  shapebounds : IMoRectangle;
  fld  : IMoField;
  TempStr, TempSwisSBLKey : String;
  FieldName : OLEVariant;
  p : IMoPolygon;

begin
  LocateParcelForm.WindowState := wsNormal;
  If ExecuteParcelLocateDialog(SwisSBLKey, True, False, 'Locate a Parcel', False, nil)
    then
      begin
        CriteriaInEffect := False;

        TempStr := MapSetupObject.MapFileKeyField + ' = ''' +
                   ConvertPASKeyFieldToMapKeyField(ParcelTable, MapParcelIDFormatTable,
                                                   AssessmentYearControlTable, SwisSBLKey,
                                                   AssessmentYear, MapSetupObject, False) +
                   '''';

        recs := MainLayer.SearchExpression(TempStr);

          {FXX05032005-2(M1.5): If the swis SBL was not found, and they have condos,
                                this may be a condo unit, so strip off the sublot and
                                suffix and check the map condo table.
                                If it exists in the table, then look up via the base lot.}

        If (Recs.EOF and
            OnlyBaseCondominiumParcelIdIsEncoded)
          then
            begin
              TempSwisSBLKey := Copy(SwisSBLKey, 1, 19) + '0000000';

              If FindCondominium(MapCondoTable, TempSwisSBLKey)
                then
                  begin
                    TempStr := MapSetupObject.MapFileKeyField + ' = ''' +
                               ConvertPASKeyFieldToMapKeyField(ParcelTable, MapParcelIDFormatTable,
                                                               AssessmentYearControlTable, TempSwisSBLKey,
                                                               AssessmentYear, MapSetupObject, True) +
                               '''';

                    recs := MainLayer.SearchExpression(TempStr);

                  end;  {If FindCondominium(MapCondoTable, TempSwisSBLKey)}

            end;  {If (Recs.EOF and ...}

        If recs.eof
          then MessageDlg('Sorry, that parcel could not be found on the map.' + #13 +
                          'The map parcel boundaries may need to be updated.',
                          mtError, [mbOK], 0)
          else
            begin
                //clear out the existing info

              tdesc := IMoTableDesc(CreateOleObject('MapObjects2.TableDesc'));
              tdesc := recs.TableDesc;
              flds := recs.Fields;

              recs.MoveFirst;

              fld := recs.Fields.item('Shape');

              CurrentParcelShape := IMoPolygon(IDispatch(fld.value));

              shapeBounds := CurrentParcelShape.Extent;
              Map.Extent := ShapeBounds;

              FieldName := MapSetupObject.MapFileKeyField;

              CurrentlySelectedList.Clear;
              SelectedParcelsAreLegalAddress := False;
              SelectedParcelsAreComps := False;
              CurrentlySelectedList.Add(SwisSBLKey);

              ClearSelectedInformation;

              p := IMoPolygon(CreateOleObject('MapObjects2.Polygon'));
              p :=IMoPolygon(IDispatch(fld.value));

              CurrentlySelectedList.Add(SwisSBLKey);
              AddItemToSelectedLayer(p, SwisSBLKey, 'SUBJECT', moRed,
                                     SelectedFillStyle, SelectedFillColor, True);

                {Zoom out 2x to see more area.}

                {Do we need to resize based on an action to match current scale?}
                {CHG11112003-4(M1.4): Add scale manipulation to map.}

              If ScaleIsLocked
                then AdjustExtentForLockedScaleTimer.Enabled := True
                else
                  begin
                    SBZoomOutClick(Sender);
                    SBZoomOutClick(Sender);
                  end;  {else of If ScaleIsLocked}

              FlashShapeTimer.Enabled := True;

              LastFoundSwisSBLKey := SwisSBLKey;

            end;  {If not recs.eof}

      end;  {If ExecuteParcelLocateDialog(SwisSBLKey, True, False, 'Locate')}

end;  {LocateSpeedButtonClick}

{========================================================}
Procedure TMappingForm.SBZoomInClick(Sender: TObject);

var
  ZoomInRect : IMoRectangle;

begin
  ZoomInRect := IMoRectangle(CreateOleObject('MapObjects2.Rectangle'));
  ZoomInRect := Map.Extent;
  ZoomInRect.ScaleRectangle(variant(0.5));

     {Force recalculation of selected items based on current criteria due to view change.}

  If CriteriaInEffect
    then ApplyingChanges := True;

  TrackingLayerDrawn := False;  {Force redraw of selected items.}
  Map.Extent := ZoomInrect;
  Map.Refresh;

  If ScaleIsLocked
    then UnlockScaleButtonClick(Sender);

end;  {SBZoomInClick}

{========================================================}
Procedure TMappingForm.SBZoomOutClick(Sender: TObject);

var
  ZoomOutRect : IMoRectangle;

begin
  ZoomOutRect := IMoRectangle(CreateOleObject('MapObjects2.Rectangle'));
  ZoomOutRect := Map.Extent;
  ZoomOutRect.ScaleRectangle(variant(1.5));
  Map.Extent := ZoomOutRect;

     {Force recalculation of selected items based on current criteria due to view change.}

  If CriteriaInEffect
    then ApplyingChanges := True;

  TrackingLayerDrawn := False;  {Force redraw of selected items.}
  Map.RefreshRect(Map.Extent);
  Map.Enabled := False;
  Map.Enabled := True;

end;  {SBZoomOutClick}

{========================================================}
Procedure TMappingForm.ApplySpeedButtonClick(Sender: TObject);

{Clear the map and adjust to the SDs\Ex\RS\Property classes they selected.}

var
  FirstTimeThrough, Quit, LimitExtent, Continue : Boolean;
  recs : IMoRecordset;
  fld  : IMoField;
  p : IMoPolygon;
  CurrentRect : IMoRectangle;
  FieldName : OLEVariant;
  Polygon : IMoPolygon;
  RecCount, FoundCount : Integer;

begin
  Continue := True;

    {So that it does not get executed a second time while still drawing the
     first, don't do it unless we know it is now currently drawing.}
    {CHG11252002-1: Ask them if they want to search on the whole map and if
                    they want to limit the extent.}

  try
    MapCriteriaSearchDialog := TMapCriteriaSearchDialog.Create(nil);

    If not ApplyingChanges
      then
        If (MapCriteriaSearchDialog.ShowModal = mrOK)
          then
            begin
              LimitExtentToCriteriaResults := MapCriteriaSearchDialog.LimitExtent;

              If MapCriteriaSearchDialog.ExpandToFullSize
                then
                  begin
                    CurrentlySelectedList.Clear;
                    FullSizeButtonClick(Sender);
                  end;  {If MapCriteriaSearchDialog.ExpandToFullSize}

              ApplyingChanges := True;
              LoadFromParcelList := False;
              CreateParcelList := False;
              CriteriaInEffect := True;

              SelectedSwisCodes.Clear;
              SelectedSchoolCodes.Clear;
              SelectedPropertyClasses.Clear;
              SelectedRollSections.Clear;
              SelectedSDCodes.Clear;
              SelectedEXCodes.Clear;

              FillSelectedItemList(ExemptionListBox, SelectedEXCodes, 5);
              FillSelectedItemList(SpecialDistrictListBox, SelectedSDCodes, 5);
              FillSelectedItemList(SwisCodeListBox, SelectedSwisCodes, 6);
              FillSelectedItemList(SchoolCodeListBox, SelectedSchoolCodes, 6);
              FillSelectedItemList(PropertyClassListBox, SelectedPropertyClasses, 3);
              FillSelectedItemList(RollSectionListBox, SelectedRollSections, 1);

              case ChooseAssessmentYearRadioGroup.ItemIndex of
                ptThisYear :
                  begin
                    ProcessingType := ThisYear;
                    AssessmentYear := GlblThisYear;
                  end;

                ptNextYear :
                  begin
                    ProcessingType := NextYear;
                    AssessmentYear := GlblNextYear;
                  end;

                ptHistory :
                  begin
                    ProcessingType := History;
                    AssessmentYear := EditHistoryYear.Text;;
                  end;

              end;  {case ChooseAssessmentYearRadioGroup.ItemIndex of}

              OpenTableForProcessingType(ParcelEXTable, ExemptionsTableName,
                                         ProcessingType, Quit);
              OpenTableForProcessingType(ParcelSDTable, SpecialDistrictTableName,
                                         ProcessingType, Quit);

    (*          Map.TrackingLayer.Refresh(True, MainLayer.Extent);*)

            end  {If not ApplyingChanges}
          else Continue := False;

  finally
    MapCriteriaSearchDialog.Free;
  end;

    {Now select the parcels that apply.}

  If Continue
    then
      begin
        FirstTimeThrough := True;
        CurrentRect := IMoRectangle(CreateOleObject('MapObjects2.Rectangle'));
        CurrentRect := Map.Extent;
        recs := MainLayer.SearchShape(CurrentRect, moAreaIntersect, '');
        recs.MoveFirst;
        Application.ProcessMessages;
        RecCount := 0;
        FoundCount := 0;
        ProgressBar.Visible := True;
        ProgressBar.Max := Recs.Count;
        Polygon := IMoPolygon(CreateOleObject('MapObjects2.Polygon'));

          {CHG11252002-1: Allow them to chose whether to limit the
                          extent of the results.}

        LimitExtent := LimitExtentToCriteriaResults;

        ClearSelectedInformation;
        SelectedParcelsAreLegalAddress := False;
        SelectedParcelsAreComps := False;

        FieldName := MapSetupObject.MapFileKeyField;

        ActionCancelled := False;

        while not (Recs.EOF or ActionCancelled) do
          begin
            If (FindParcelForMapRecord(ParcelLookupTable,
                                       MapParcelIDFormatTable, AssessmentYearControlTable,
                                       MapSetupObject,
                                       Recs.Fields.Item(FieldName).Value,
                                       AssessmentYear) and
                ParcelMeetsCriteria(ParcelLookupTable))
              then
                begin
                  FoundCount := FoundCount + 1;
                  fld := recs.Fields.item('Shape');
                  p := IMoPolygon(CreateOleObject('MapObjects2.Polygon'));
                  p := IMoPolygon(IDispatch(fld.value));

      (*            TempInt := p.ShapeType;

                  case TempInt of
                    21 : MessageDlg('21', mtInformation, [mbOK], 0);
                    22 : MessageDlg('22', mtInformation, [mbOK], 0);
                    23 : MessageDlg('23', mtInformation, [mbOK], 0);
                    24 : MessageDlg('24', mtInformation, [mbOK], 0);
                    25 : MessageDlg('25', mtInformation, [mbOK], 0);
                    26 : MessageDlg('26', mtInformation, [mbOK], 0);
                  end;*)

                  CurrentlySelectedList.Add(ExtractSSKey(ParcelLookupTable));
                  AddItemToSelectedLayer(p, ExtractSSKey(ParcelLookupTable), '', moBlue,
                                         SelectedFillStyle, SelectedFillColor, False);

                  If CreateParcelList
                    then ParcelListDialog.AddOneParcel(ExtractSSKey(ParcelLookupTable));

                  If LimitExtent
                    then
                      begin
                        Polygon := IMoPolygon(IDispatch(Recs.Fields.item('Shape').value));

                        If FirstTimeThrough
                          then
                            begin
                              FirstTimeThrough := False;
                              LimitExtentRect := Polygon.Extent;
                            end
                          else
                            begin
                              If (Polygon.Extent.Left < LimitExtentRect.Left)
                                then LimitExtentRect.Left := Polygon.Extent.Left;

                              If (Polygon.Extent.Right > LimitExtentRect.Right)
                                then LimitExtentRect.Right := Polygon.Extent.Right;

                              If (Polygon.Extent.Top > LimitExtentRect.Top)
                                then LimitExtentRect.Top := Polygon.Extent.Top;

                              If (Polygon.Extent.Bottom < LimitExtentRect.Bottom)
                                then LimitExtentRect.Bottom := Polygon.Extent.Bottom;

                            end;  {If FirstTimeThrough}

                      end;  {If LimitExtent}

                end;  {If (FindKeyOld(ParcelLookupTable, ['AccountNo'], ...}

            RecCount := RecCount + 1;
            ProgressBar.Position := RecCount;
            Application.ProcessMessages;

            recs.MoveNext;

          end;  {while not Recs.EOF do}

        ProgressBar.Visible := False;
        StatusBar.Panels[1].Text := IntToStr(FoundCount) + ' selected.';
        CreateParcelList := False;
        ApplyingChanges := False;

        If LimitExtent
          then
            begin
              Map.Extent := LimitExtentRect;

                {Do we need to resize based on an action to match current scale?}
                {CHG11112003-4(M1.4): Add scale manipulation to map.}

              If ScaleIsLocked
                then AdjustExtentForLockedScaleTimer.Enabled := True;

            end
          else (*Map.TrackingLayer.Refresh(True, MainLayer.Extent);*)Map.Refresh;

      end;  {If Continue}

end;  {ApplySpeedButtonClick}

{========================================================}
Procedure TMappingForm.ClearAllSelectedSpeedButtonClick(Sender: TObject);

begin
  ClearSelectedInformation;
  CriteriaInEffect := False;
  SelectedParcelsAreLegalAddress := False;
  SelectedParcelsAreComps := False;
  StatusBar.Panels[1].Text := '';
  Map.Refresh;

end;  {ClearAllSelectedSpeedButtonClick}

{========================================================}
Procedure TMappingForm.FullSizeButtonClick(Sender: TObject);

begin
  If ((CurrentlySelectedList.Count > 0) and
      (MessageDlg('Do you want to clear the currently selected parcels?',
                  mtConfirmation, [mbYes, mbNo], 0) = idYes))
    then
      begin
        ClearSelectedInformation;
        SelectedParcelsAreLegalAddress := False;
        SelectedParcelsAreComps := False;
        CriteriaInEffect := False;
        StatusBar.Panels[1].Text := '';
      end;

  TrackingLayerDrawn := False;  {Force redraw of selected items.}
  Map.Extent := FullSizeRect;
  Map.Refresh;

end;  {FullSizeButtonClick}

{========================================================}
Procedure TMappingForm.MapInfoFormSynchronizeTimerTimer(Sender: TObject);

{The map info form closed - update the list of open ones.}

var
  Index : Integer;

begin
  If GlblMapInfoFormClosed
    then
      begin
        GlblMapInfoFormClosed := False;

        Index := MapInfoFormList.IndexOf(GlblMapInfoFormClosingSwisSBLKey);

        If (Index > -1)
          then
            try
              MapInfoFormList.Delete(Index);
            except
            end;

      end;  {If GlblMapInfoFormClosed}

end;  {MapInfoFormSynchronizeTimerTimer}

{========================================================}
Procedure TMappingForm.CloseParcelModifyPanel;

begin
  ModifyParcelPanel.Visible := False;
  ModifyParcelPanelVisible := False;
end;  {CloseParcelModifyPanel}

{========================================================}
Procedure TMappingForm.SaveButtonClick(Sender: TObject);

var
  I : Integer;
  fld : IMoField;

begin
  with ModifyRecordSet, ParcelStringGrid do
    If Updatable
      then
        try
          Edit;

          For I := 1 to (RowCount - 1) do
            begin
              fld := Fields.Item(Cells[0, I]);

              case fld.Type_ of
                moLong : try
                           fld.Value := StrToInt(Cells[1, I]);
                         except
                         end;

                moDouble : try
                           fld.Value := StrToFloat(Cells[1, I]);
                         except
                         end;

                moDate : try
                           fld.Value := StrToDate(Cells[1, I]);
                         except
                         end;

                moString : fld.Value := Cells[1, I];

                moBoolean : If ((ANSIUpperCase(Cells[1, I]) = 'TRUE') or
                                (ANSIUpperCase(Cells[1, I]) = 'Y'))
                              then fld.Value := True
                              else fld.Value := False;

              end;  {case Field.FieldType of}

            end;  {For I := 1 to (RowCount - 1) do}

          ModifyRecordSet.Update;
          StopEditing;

          CloseParcelModifyPanel;

        except
          MessageDlg('Error saving shapefile record.', mtError, [mbOK], 0);
        end
      else MessageDlg('Sorry, the changes can not be saved because the shapefile is not updatable.',
                      mtError, [mbOK], 0);

end;  {SaveButtonClick}

{========================================================}
Procedure TMappingForm.CancelButtonClick(Sender: TObject);

begin
  If (MessageDlg('Are you sure you want to cancel all changes?', mtConfirmation, [mbYes, mbNo], 0) = idYes)
    then CloseParcelModifyPanel;

end;  {CancelButtonClick}

{========================================================}
Procedure TMappingForm.CloseButtonClick(Sender: TObject);

var
  ReturnValue : Integer;

begin
  ReturnValue := MessageDlg('Do you want to save your changes?', mtConfirmation,
                            [mbYes, mbNo, mbCancel], 0);

  case ReturnValue of
    idYes : SaveButtonClick(Sender);
    idNo : CloseParcelModifyPanel;
  end;

end;  {CloseButtonClick}

{========================================================}
Procedure TMappingForm.ShowModifyRecordPanel;

var
  tdesc: IMoTableDesc;
  flds : IMoFields;
  fld  : IMoField;
  I : Integer;

begin
  ModifyParcelPanelVisible := True;

  with ModifyParcelPanel do
    begin
      Visible := True;
      Caption := 'Modify properties for parcel ' +
                 ConvertSwisSBLToDashDot(LastFoundSwisSBLKey) +
                 ' in shapefile.';

      Left := (MappingForm.Width - Width) DIV 2;
      Top := (MappingForm.Height - Height) DIV 2;

    end;  {with ModifyParcelPanel do}

  tdesc := IMoTableDesc(CreateOleObject('MapObjects2.TableDesc'));
  tdesc := ModifyRecordSet.TableDesc;
  flds := ModifyRecordSet.Fields;

  with ParcelStringGrid do
    begin
      Cells[0, 0] := 'Field';
      Cells[1, 0] := 'Value';
    end;

  For I := 0 to (tdesc.FieldCount - 1) do
    begin
      If (I > (ParcelStringGrid.RowCount - 1))
        then ParcelStringGrid.RowCount := ParcelStringGrid.RowCount + 1;

      fld := flds.Item(tdesc.FieldName[i]);
      ParcelStringGrid.Cells[0, (I + 1)] := fld.name ;
      ParcelStringGrid.Cells[1, (I + 1)] := fld.valueasstring;

    end;  {For I := 0 to (tdesc.FieldCount - 1) do}

end;  {ShowModifyRecordPanel}

{========================================================}
Procedure TMappingForm.MapMouseDown(Sender: TObject;
                                    Button: TMouseButton;
                                    Shift: TShiftState;
                                    X, Y: Integer);

var
  P : IMoPoint;
  recs : IMoRecordset;
  MapInfoForm : TMapParcelInfoForm;
  TempRect : IMoRectangle;
  _Found : Boolean;
  FieldName : OLEVariant;
  TempIndex : Integer;
  poly : IMoPolygon;
  fld : IMoField;
  SwisSBLKey : String;
  I : Integer;

begin
  FieldName := MapSetupObject.MapFileKeyField;

  If (msIdentifyParcel in CurrentMouseMode)
    then
      begin
        LockWindowUpdate(Handle);

          {First see what parcel they clicked on.}

        _Found := False;
        p := IMoPoint(CreateOleObject('MapObjects2.Point'));
        p := Map.ToMapPoint(x,y);

        recs := MainLayer.SearchShape(p,12,'');

        If not Recs.EOF
          then
            begin
              Recs.MoveFirst;

              _Found := FindParcelForMapRecord(ParcelLookupTable,
                                               MapParcelIDFormatTable, AssessmentYearControlTable,
                                               MapSetupObject,
                                               Recs.Fields.Item(FieldName).Value,
                                               AssessmentYear);

              If _Found
                then SwisSBLKey := ExtractSSKey(ParcelLookupTable)
                else MessageDlg('Sorry, that parcel can not be identified.',
                                mtError, [mbOK], 0);

            end;  {If not Recs.EOF}

          {Now make sure that they don't already have this parcel up.}

        If _Found
          then
            For I := 0 to (MapInfoFormList.Count - 1) do
              If (MapInfoFormList[I] = SwisSBLKey)
                then _Found := False;

          {Now actually show the dialog.}

        If _Found
          then
            begin
              LastFoundSwisSBLKey := SwisSBLKey;
              MapInfoForm := TMapParcelInfoForm.Create(Application);

              with MapInfoForm do
                begin
                  Left := Mouse.CursorPos.X;
                  Top := Mouse.CursorPos.Y;

                    {If the info dialog is going to appear too far off the right,
                     then make sure at least half is showing.}

                  If ((Left + MapInfoForm.Width DIV 2) > Map.Width)
                    then Left := Map.Width - (MapInfoForm.Width DIV 2);

                  FillInParcelInformation(ParcelLookupTable, ProcessingType);
                  Show;

                  MapInfoFormList.Add(SwisSBLKey);

                end;  {with MapParcelInfoForm do}

            end;  {If _Found}

        LockWindowUpdate(0);

      end;  {If (msIdentifyParcel in CurrentMouseMode)}

    {Add the parcel to the selected list.}

  If (msSelectParcel in CurrentMouseMode)
    then
      begin
        p := IMoPoint(CreateOleObject('MapObjects2.Point'));
        p := Map.ToMapPoint(x,y);

        recs := MainLayer.SearchShape(p,12,'');

        If not Recs.EOF
          then
            begin
              Recs.MoveFirst;

              _Found := FindParcelForMapRecord(ParcelLookupTable,
                                               MapParcelIDFormatTable, AssessmentYearControlTable,
                                               MapSetupObject,
                                               Recs.Fields.Item(FieldName).Value,
                                               AssessmentYear);

              If _Found
                then
                  begin
                    LastFoundSwisSBLKey := ExtractSSKey(ParcelLookupTable);
                    TempIndex := CurrentlySelectedList.IndexOf(ExtractSSKey(ParcelLookupTable));

                      {Get the extent of this polygon so that we don't have to
                       refresh the whole tracking layer each time.}

                    fld := recs.Fields.item('Shape');
                    poly := IMoPolygon(CreateOleObject('MapObjects2.Polygon'));
                    poly := IMoPolygon(IDispatch(fld.value));
                    TempRect := poly.Extent;

                    If (TempIndex = -1)
                      then
                        begin
                          CurrentlySelectedList.Add(ExtractSSKey(ParcelLookupTable));  {Select}
                          AddItemToSelectedLayer(poly, ExtractSSKey(ParcelLookupTable), '', moBlue,
                                                 SelectedFillStyle, SelectedFillColor, False);
                        end
                      else
                        begin
                          CurrentlySelectedList.Delete(TempIndex);  {Unselect}
                          RemoveItemFromSelectedLayer(poly, ExtractSSKey(ParcelLookupTable));
                        end;  {If (TempIndex = -1)}

                    Map.RefreshRect(TempRect);

                  end
                else MessageDlg('Sorry, that parcel can not be identified.',
                                mtError, [mbOK], 0);

            end;  {If not Recs.EOF}

      end;  {If (msSelectParcel in CurrentMouseMode)}

  If (msZoomRectangle in CurrentMouseMode)
    then
      begin
       TempRect := IMoRectangle(CreateOleObject('MapObjects2.Rectangle'));
       TempRect := Map.TrackRectangle;

       If not VarIsEmpty(TempRect)
         then Map.Extent := TempRect;

        If ScaleIsLocked
          then UnlockScaleButtonClick(Sender);

      end;  {If (msZoomRectangle in CurrentMouseMode)}

  If (msDistanceMeasure in CurrentMouseMode)
    then
      begin
        DistanceLine := Map.TrackLine;

(*        If (StartingDistanceMeasurePoint = nil)
          then
            begin
              p := IMoPoint(CreateOleObject('MapObjects2.Point'));
              p := Map.ToMapPoint(x,y);
              StartingDistanceMeasurePoint := p;

            end;  {If (StartingDistanceMeasurePoint = nil)} *)

      end;  {If (msDistanceMeasure in CurrentMouseMode)}

  If ((MapSetupObject <> nil) and
      (msZoomRectangle in CurrentMouseMode))
    then
      begin
        FieldName := MapSetupObject.MapFileKeyField;

        p := IMoPoint(CreateOleObject('MapObjects2.Point'));
        p := Map.ToMapPoint(x,y);

        recs := MainLayer.SearchShape(p,12,'');

        If not Recs.EOF
          then
            begin
              Recs.MoveFirst;

              _Found := FindParcelForMapRecord(ParcelLookupTable,
                                               MapParcelIDFormatTable, AssessmentYearControlTable,
                                               MapSetupObject,
                                               Recs.Fields.Item(FieldName).Value,
                                               AssessmentYear);

              If _Found
                then LastFoundSwisSBLKey := ExtractSSKey(ParcelLookupTable);;

            end;  {If not Recs.EOF}

      end;  {If (MapSetupObject <> nil)}

  If (msModifyParcel in CurrentMouseMode)
    then
      begin
        p := IMoPoint(CreateOleObject('MapObjects2.Point'));
        p := Map.ToMapPoint(x,y);
        CurrentPoint := p;

        ModifyRecordSet := MainLayer.SearchShape(p,12,'');

        ModifyRecordSet.MoveFirst;

        _Found := FindParcelForMapRecord(ParcelLookupTable,
                                         MapParcelIDFormatTable, AssessmentYearControlTable,
                                         MapSetupObject,
                                         ModifyRecordSet.Fields.Item(FieldName).Value,
                                         AssessmentYear);

        If _Found
          then LastFoundSwisSBLKey := ExtractSSKey(ParcelLookupTable);

        ShowModifyRecordPanel;

      end;  {If (msModifyParcel in CurrentMouseMode)}

end;  {MapMouseDown}

{========================================================}
Procedure TMappingForm.MapMouseMove(Sender: TObject;
                                    Shift: TShiftState;
                                    X, Y: Integer);

{Display current parcel information in the status bar.}

var
  P : IMoPoint;
  recs : IMoRecordset;
  _Found : Boolean;
  FieldName : OLEVariant;
  TempStr, SwisSBLKey : String;
  Distance : Double;

begin
  TempStr := 'Unknown Parcel.';

  If ((MapSetupObject <> nil) and
      (MainLayer <> nil) and
      (not InitializingForm))
    then
      begin
        FieldName := MapSetupObject.MapFileKeyField;

        p := IMoPoint(CreateOleObject('MapObjects2.Point'));
        p := Map.ToMapPoint(x,y);

        recs := MainLayer.SearchShape(p,12,'');
(*        recs := MainLayer.SearchShape(p,1,'');*)

        If not Recs.EOF
          then
            begin
              Recs.MoveFirst;

              _Found := FindParcelForMapRecord(ParcelLookupTable,
                                               MapParcelIDFormatTable, AssessmentYearControlTable,
                                               MapSetupObject,
                                               Recs.Fields.Item(FieldName).Value,
                                               AssessmentYear);

              If _Found
                then TempStr := ConvertSwisSBLToDashDot(ExtractSSKey(ParcelLookupTable)) + '  ' +
                                ParcelLookupTable.FieldByName('Name1').Text + '  ' +
                                GetLegalAddressFromTable(ParcelLookupTable)
                else
                  If (OnlyBaseCondominiumParcelIdIsEncoded and
                      FindCondominiumForMapRecord(MapCondoTable,
                                                  MapSetupObject,
                                                  Recs.Fields.Item(MapSetupObject.MapFileKeyField).Value))
                    then
                      with MapCondoTable do
                        begin
                          SwisSBLKey := FieldByName('SwisCode').Text + FieldByName('SBL').Text;

                          TempStr := 'Condo:  ' + ConvertSwisSBLToDashDot(SwisSBLKey) + '  ' +
                                     FieldByName('CondoName').Text;

                        end
                    else TempStr := 'Unknown Parcel - (ESRI ' +
                                    Trim(MapSetupObject.MapFileKeyField) + '=' +
                                    Recs.Fields.Item(FieldName).Value + ')';

            end;  {If not Recs.EOF}

        StatusBar.Panels[0].Text := TempStr;

      end;  {If (MapSetupObject <> nil)}

  If (msDistanceMeasure in CurrentMouseMode)
(*      (StartingDistanceMeasurePoint <> nil))*)
    then
      begin
(*        p := IMoPoint(CreateOleObject('MapObjects2.Point'));
        p := Map.ToMapPoint(x,y);
        EndingDistanceMeasurePoint := p;

        Points := IMOPoints(CreateOleObject('MapObjects2.Points'));
        Points.Add(StartingDistanceMeasurePoint);
        Points.Add(EndingDistanceMeasurePoint);

        For I := (DistanceLine.Parts.Count - 1) downto 0 do
          DistanceLine.Parts.Remove(I);

        DistanceLine.Parts.Add(Points); *)

        Distance := DistanceLine.Length;

        StatusBar.Panels[1].Text := 'Distance: ' +
                                    FormatFloat(DecimalDisplay_BlankZero, Distance);

      end;  {If (msDistanceMeasure in CurrentMouseMode)}

    {CHG11092003-1: Add X and Y coordinates.}

  p := IMoPoint(CreateOleObject('MapObjects2.Point'));
  p := Map.ToMapPoint(x,y);

  XCoordinateLabel.Caption := 'X: ' + FormatFloat(ExtendedDecimalDisplay, p.x);
  YCoordinateLabel.Caption := 'Y: ' + FormatFloat(ExtendedDecimalDisplay, p.y);

end;  {MapMouseMove}

{=======================================================================}
Procedure TMappingForm.MapMouseUp(Sender: TObject;
                                  Button: TMouseButton;
                                  Shift: TShiftState;
                                  X, Y: Integer);

begin
  If (msDistanceMeasure in CurrentMouseMode)
    then StartingDistanceMeasurePoint := nil;

end;  {MapMouseUp}

{=======================================================================}
Procedure TMappingForm.ShowParcelListSpeedButtonClick(Sender: TObject);

begin
  ParcelListDialog.Show;
end;  {ShowParcelListSpeedButtonClick}

{========================================================}
Procedure TMappingForm.LoadFromParcelListButtonClick(Sender: TObject);

var
  I, RecCount : Integer;
  FirstTimeThrough : Boolean;
  recs : IMoRecordset;
  CurrentRect : IMoRectangle;
  FieldName : OLEVariant;
  Polygon : IMoPolygon;
  TempStr, SwisSBLKey : String;

begin
  ShowParcelListSpeedButtonClick(Sender);
  ClearSelectedInformation;
  FullSizeButtonClick(Sender);

    {Now go through the items on the list and add them to the selected layer.}

  CurrentRect := IMoRectangle(CreateOleObject('MapObjects2.Rectangle'));
  CurrentRect := Map.Extent;
  recs := MainLayer.SearchShape(CurrentRect, moAreaIntersect, '');
  recs.MoveFirst;
  Application.ProcessMessages;
  RecCount := 0;
  ProgressBar.Visible := True;
  ProgressBar.Max := Recs.Count;
  FirstTimeThrough := True;

  FieldName := MapSetupObject.MapFileKeyField;

  For I := 1 to ParcelListDialog.NumItems do
    begin
      ParcelListDialog.GetParcel(ParcelLookupTable2, I);
      SwisSBLKey := ExtractSSKey(ParcelLookupTable2);

      TempStr := MapSetupObject.MapFileKeyField + ' = ''' +
                 ConvertPASKeyFieldToMapKeyField(ParcelLookupTable2, MapParcelIDFormatTable,
                                                 AssessmentYearControlTable, SwisSBLKey,
                                                 AssessmentYear, MapSetupObject, False) +
                 '''';

      recs := MainLayer.SearchExpression(TempStr);

      If not recs.eof
        then
          begin
            Polygon := IMoPolygon(IDispatch(Recs.Fields.item('Shape').value));

            CurrentlySelectedList.Add(ExtractSSKey(ParcelLookupTable2));
            AddItemToSelectedLayer(Polygon, ExtractSSKey(ParcelLookupTable2),
                                   '', moRed,
                                   SelectedFillStyle, SelectedFillColor, False);

            If FirstTimeThrough
              then
                begin
                  FirstTimeThrough := False;
                  LimitExtentRect := Polygon.Extent;
                end
              else
                begin
                  If (Polygon.Extent.Left < LimitExtentRect.Left)
                    then LimitExtentRect.Left := Polygon.Extent.Left;

                  If (Polygon.Extent.Right > LimitExtentRect.Right)
                    then LimitExtentRect.Right := Polygon.Extent.Right;

                  If (Polygon.Extent.Top > LimitExtentRect.Top)
                    then LimitExtentRect.Top := Polygon.Extent.Top;

                  If (Polygon.Extent.Bottom < LimitExtentRect.Bottom)
                    then LimitExtentRect.Bottom := Polygon.Extent.Bottom;

                end;  {If FirstTimeThrough}

          end;  {If (FindKeyOld(ParcelLookupTable, ['AccountNo'], ...}

      RecCount := RecCount + 1;
      ProgressBar.Position := RecCount;
      Application.ProcessMessages;

    end;  {For I := 1 to ParcelListDialog.NumItems do}

  ProgressBar.Visible := False;
  StatusBar.Panels[1].Text := IntToStr(RecCount) + ' parcels.';

  If (CurrentlySelectedList.Count > 0)
    then LimitExtentTimer.Enabled := True;

end;  {LoadFromParcelListButtonClick}

{========================================================}
Procedure TMappingForm.CreateParcelListButtonClick(Sender: TObject);

var
  I : Integer;

begin
  ParcelListDialog.ClearParcelGrid(True);
  CreateParcelList := True;
  LoadFromParcelList := False;

  For I := 0 to (CurrentlySelectedList.Count - 1) do
    ParcelListDialog.AddOneParcel(CurrentlySelectedList[I]);

  ParcelListDialog.Show;

end;  {CreateParcelListClick}

{========================================================}
Procedure TMappingForm.PrintMapSpeedButtonClick(Sender: TObject);

var
  NewFileName : String;
  TempFile : TextFile;
  Quit, OtherItemPrinted : Boolean;

begin
  OtherItemPrinted := False;

    {FXX11202002-1: Fix up the printing.}
    {First export a copy of this map so that it can be printed.
     If we do not we will lose it because of redrawing issues.}
    {Also have option to print a parcel list.}

  NewFileName := GetPrintFileName('MAP', True);
  Map.ExportMap2(moExportBMP, NewFileName, 2, True);

  try
    MapPrintTypeDialog := TMapPrintTypeDialog.Create(Application);

    If (MapPrintTypeDialog.ShowModal = mrOK)
      then
        begin
          If (mptMap in MapPrintTypeDialog.PrintType)
            then
              begin
                OtherItemPrinted := True;
                ExecuteMapPrintDialog(NewFileName);
              end;

          If ((mptLabels in MapPrintTypeDialog.PrintType) and
              ExecuteLabelOptionsDialog(LabelOptions) and
              PrintDialog.Execute)
            then
              begin
                OtherItemPrinted := True;
                If PrintDialog.PrintToFile
                  then
                    begin
                      NewFileName := GetPrintFileName(Self.Caption, True);
                      GlblPreviewPrint := True;
                      GlblDefaultPreviewZoomPercent := 70;
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

              end;  {If ((mptLabels in MapPrintTypeDialog.PrintType) and ...}

          If ((mptParcelList in MapPrintTypeDialog.PrintType) and
              ((OtherItemPrinted and
                (MessageDlg('Please select where you want to print the parcel list.',
                            mtConfirmation, [mbOK, mbCancel], 0) = idOK)) or
               (not OtherItemPrinted)) and
              PrintDialog.Execute)
            then
              begin
                AssignPrinterSettings(PrintDialog, ParcelListReportPrinter, ParcelListReportFiler, [ptLaser],
                                      False, Quit);

                If not Quit
                  then
                    begin
                      GlblPreviewPrint := False;

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

                        {FXX07221998-1: So that more than one person can run the report
                                        at once, use a time based name first and then
                                        rename.}

                        {If they want to see it on the screen, start the preview.}

                      If PrintDialog.PrintToFile
                        then
                          begin
                            GlblPreviewPrint := True;
                            NewFileName := GetPrintFileName(Self.Caption, True);
                            ParcelListReportFiler.FileName := NewFileName;

                            try
                              PreviewForm := TPreviewForm.Create(self);
                              PreviewForm.FilePrinter.FileName := NewFileName;
                              PreviewForm.FilePreview.FileName := NewFileName;

                              PreviewForm.FilePreview.ZoomFactor := 130;

                              ParcelListReportFiler.Execute;

                              PreviewForm.ShowModal;
                            finally
                              PreviewForm.Free;
                            end;

                          end
                        else ParcelListReportPrinter.Execute;

                    end;  {If not Quit}

              end;  {If ((mptParcelList in MapPrintTypeDialog.PrintType) and ...}

        end;  {If (MapPrintTypeDialog.ShowModal = mrOK)}

  finally
    MapPrintTypeDialog.Free;
  end;

  TrackingLayerDrawn := False;  {Force redraw of selected items.}
  Map.Enabled := False;
  Map.Enabled := True;

end;  {PrintMapSpeedButtonClick}

{========================================================}
Procedure TMappingForm.FormResize(Sender: TObject);

{Make sure the loading panel appears in the right place.}

var
  TempWidth : Real;
  TempWidthInt : Integer;

begin
(*  LoadingPanel.Left := Map.Left + 1;*)

  TempWidth := 0.75 * StatusBar.Width;
  TempWidthInt := Round(TempWidth);

  StatusBar.Panels[0].Width := TempWidthInt;
  StatusBar.Panels[1].Width := StatusBar.Width - StatusBar.Panels[0].Width - 3;
  ProgressBar.Left := StatusBar.Panels[0].Width + 3;
  ProgressBar.Width := StatusBar.Panels[1].Width;
  ProgressBar.Top := StatusBar.Top + 2;

end;  {FormResize}

{========================================================}
Procedure TMappingForm.RefreshLayerBoxTimerTimer(Sender: TObject);

{For some reason the check box states set in LoadLayersIntoLayerBox
 are lost in the procedure pass and cannot be set until an interrupt
 has occurred, so it is being done on a timer - this seems to be
 a Delphi problem, but it is just easier to do a workaround.}

var
  I : Integer;

begin
  RefreshLayerBoxTimer.Enabled := False;

  For I := 1 to (LayersCheckListBox.Items.Count - 1) do
    LayersCheckListBox.Checked[I] := FindKeyOld(MappingDetailTable, ['LayerName'],
                                                [LayersCheckListBox.Items[I]]);

  ReloadingLayerBox := False;
  MapTimer.Enabled := True;

end;  {RefreshLayerBoxTimerTimer}

{========================================================}
Procedure TMappingForm.MappingSetupButtonClick(Sender: TObject);

var
  I : Integer;

begin
  DialogShowing := True;

  try
    MappingOptionsForm := TMappingOptionsForm.Create(nil);

    with MappingOptionsForm do
      begin
        FormAccessRights := raReadWrite;
        CloseOnStart := False;
        InitializeForm;
        OriginalSetupName := MapSetupObject.SetupName;
        ShowModal;

        If ((OriginalSetupName <> ReturnSetupName) or
            (MessageDlg('Do you want to reload the map with the current settings?',
                        mtConfirmation, [mbYes, mbNo], 0) = idYes))
          then
            begin
              MapSetupObject.Clear;
              StatusBar.Panels[1].Text := '';
              CriteriaInEffect := False;
              CurrentlySelectedList.Clear;
              SelectedParcelsAreLegalAddress := False;
              SelectedParcelsAreComps := False;

              SetMapOptions(ReturnSetupName, False,
                            MappingHeaderTable, MappingDetailTable,
                            MapLayersAvailableTable, MapParcelIDTable, MapSetupObject);

              MapLabelRadioGroup.ItemIndex := MapSetupObject.LabelType;
              FillStyleComboBox.ItemIndex := MapSetupObject.FillType;
              FillColorShape.Brush.Color := MapSetupObject.FillColor;
              FillColorShape.Refresh;

              SelectedFillColor := FillColorShape.Brush.Color;
              SelectedFillStyle := FillStyleComboBox.ItemIndex;

              For I := (Map.Layers.Count - 1) downto 0 do
                Map.Layers.Remove(I);

              ReloadingLayerBox := True;

              MapLayersAvailableTable.Refresh;

(*              LayersCheckListBox.Free;
              LayersCheckListBox := TCheckListBox.Create(LayersCheckListPanel);
              LayersCheckListBox.Align := alClient;
              LayersCheckListBox.Sorted := True;
              LayersCheckListBox.OnClickCheck := LayersCheckListBoxClickCheck;
              LayersCheckListBox.OnMouseMove := LayersCheckListBoxMouseMove;*)

              LoadLayersIntoLayerBox(LayersCheckListBox,
                                     ReturnSetupName,
                                     MapLayersAvailableTable,
                                     MappingDetailTable);

              ReloadingLayerBox := False;

(*              LoadLayersIntoLayerListBox(AvailableLayersListBox,
                                         MapLayersAvailableTable,
                                         MappingDetailTable, True); *)

                {For some reason the check box states set in LoadLayersIntoLayerBox
                 are lost in the procedure pass and cannot be set until an interrupt
                 has occurred, so it is being done on a timer - this seems to be
                 a Delphi problem, but it is just easier to do a workaround.}

              LayersCheckListBox.Refresh;
              RefreshLayerBoxTimer.Enabled := True;

            end;  {If ((CurrentSetupName <> ReturnSetupName) or ...}

      end;  {with MappingOptionsForm do}

  finally
    MappingOptionsForm.Free;
  end;

  Map.Enabled := True;
  DialogShowing := False;

end;  {MappingSetupButtonClick}

{========================================================}
Procedure TMappingForm.LegalAddressSpeedButtonClick(Sender: TObject);

var
  FirstTimeThrough : Boolean;
  recs : IMoRecordset;
  fld  : IMoField;
  p : IMoPolygon;
  CurrentRect : IMoRectangle;
  FieldName : OLEVariant;
  Polygon : IMoPolygon;
  RecCount, FoundCount : Integer;

begin
  DialogShowing := True;

  try
    MapLegalAddressSelectDialog := TMapLegalAddressSelectDialog.Create(nil);

    If (MapLegalAddressSelectDialog.ShowModal = mrOK)
      then
        begin
          ClearSelectedInformation;
          FullSizeButtonClick(Sender);
          LegalAddressLookup := True;

          LegalAddress := MapLegalAddressSelectDialog.LegalAddress;
          LegalAddressNumberStart := MapLegalAddressSelectDialog.LegalAddressNumberStart;
          LegalAddressNumberEnd := MapLegalAddressSelectDialog.LegalAddressNumberEnd;
          AllLegalAddressNumbers := MapLegalAddressSelectDialog.AllLegalAddressNumbers;
          ToEndOfLegalAddressNumbers := MapLegalAddressSelectDialog.ToEndOfLegalAddressNumbers;

          DialogShowing := False;
          SelectedParcelsAreLegalAddress := True;
          SelectedParcelsAreComps := False;
          Map.TrackingLayer.Refresh(True, Map.Extent);

        end;  {If (MapLegalAddressSelectDialog.ShowModal = mrOK)}

  finally
    MapLegalAddressSelectDialog.Free;
  end;

    {CHG11272002-1: Move the legal address search here because the selected info
                    is now a layer..}

  CurrentRect := IMoRectangle(CreateOleObject('MapObjects2.Rectangle'));
  CurrentRect := Map.Extent;
  recs := MainLayer.SearchShape(CurrentRect, moAreaIntersect, '');
  recs.MoveFirst;
  Application.ProcessMessages;
  RecCount := 0;
  FoundCount := 0;
  ProgressBar.Visible := True;
  ProgressBar.Max := Recs.Count;

  Polygon := IMoPolygon(CreateOleObject('MapObjects2.Polygon'));
  FieldName := MapSetupObject.MapFileKeyField;
  FirstTimeThrough := True;

  ActionCancelled := False;

  while not (Recs.EOF or ActionCancelled) do
    begin
      If (FindParcelForMapRecord(ParcelLookupTable,
                                 MapParcelIDFormatTable, AssessmentYearControlTable,
                                 MapSetupObject,
                                 Recs.Fields.Item(FieldName).Value,
                                 AssessmentYear) and
          ParcelMeetsLegalAddressCriteria(ParcelLookupTable,
                                          LegalAddress,
                                          LegalAddressNumberStart,
                                          LegalAddressNumberEnd,
                                          AllLegalAddressNumbers,
                                          ToEndOfLegalAddressNumbers))
        then
          begin
            FoundCount := FoundCount + 1;
            fld := recs.Fields.item('Shape');
            p := IMoPolygon(CreateOleObject('MapObjects2.Polygon'));
            p :=IMoPolygon(IDispatch(fld.value));

            CurrentlySelectedList.Add(ExtractSSKey(ParcelLookupTable));
            AddItemToSelectedLayer(p, ExtractSSKey(ParcelLookupTable),
                                   ParcelLookupTable.FieldByName('LegalAddrNo').Text, moRed,
                                   SelectedFillStyle, SelectedFillColor, True);

            If CreateParcelList
              then ParcelListDialog.AddOneParcel(ExtractSSKey(ParcelLookupTable));

              {Figure out the extent of the road.}

            Polygon := IMoPolygon(IDispatch(Recs.Fields.item('Shape').value));

            If FirstTimeThrough
              then
                begin
                  FirstTimeThrough := False;
                  LimitExtentRect := Polygon.Extent;
                end
              else
                begin
                  If (Polygon.Extent.Left < LimitExtentRect.Left)
                    then LimitExtentRect.Left := Polygon.Extent.Left;

                  If (Polygon.Extent.Right > LimitExtentRect.Right)
                    then LimitExtentRect.Right := Polygon.Extent.Right;

                  If (Polygon.Extent.Top > LimitExtentRect.Top)
                    then LimitExtentRect.Top := Polygon.Extent.Top;

                  If (Polygon.Extent.Bottom < LimitExtentRect.Bottom)
                    then LimitExtentRect.Bottom := Polygon.Extent.Bottom;

                end;  {If FirstTimeThrough}

          end;  {If (FindKeyOld(ParcelLookupTable, ['AccountNo'], ...}

      RecCount := RecCount + 1;
      ProgressBar.Position := RecCount;
      Application.ProcessMessages;

      recs.MoveNext;

    end;  {while not Recs.EOF do}

  ProgressBar.Visible := False;
  StatusBar.Panels[1].Text := IntToStr(FoundCount) + ' selected.';
  CreateParcelList := False;
  LegalAddressLookup := False;

  If (CurrentlySelectedList.Count > 0)
    then
      begin
        Map.Extent := LimitExtentRect;

          {Do we need to resize based on an action to match current scale?}
          {CHG11112003-4(M1.4): Add scale manipulation to map.}

        If ScaleIsLocked
          then AdjustExtentForLockedScaleTimer.Enabled := True;

      end;  {If (CurrentlySelectedList.Count > 0)}

end;  {LegalAddressSpeedButtonClick}

{========================================================}
Procedure TMappingForm.ReportPrintHeader(Sender: TObject);

begin
  PrintLabelHeader(Sender, LabelOptions);
end;  {ReportPrintHeader}

{========================================================}
Procedure TMappingForm.ReportPrint(Sender: TObject);

var
  TempCurrentlySelectedList, CondominiumUnitList : TStringList;
  I, J : LongInt;

begin
  TempCurrentlySelectedList := TStringList.Create;
  CondominiumUnitList := TStringList.Create;

    {FXX05032005-1(M1.5): The printing of condo labels was not working.  The
                          correct way to do is to have the base lot SBL on the
                          selected list.  Prior to printing the labels, take that
                          SBL out of the list and substitute condo units.
                          After printing, restore the original selected list.}

  If OnlyBaseCondominiumParcelIdIsEncoded
    then
      For I := 0 to (CurrentlySelectedList.Count - 1) do
        begin
          If FindCondominium(MapCondoTable, CurrentlySelectedList[I])
            then
              begin
                AddCondoUnitsToListForBaseCondoID(ParcelLookupTable2,
                                                  CurrentlySelectedList[I],
                                                  AssessmentYear,
                                                  CondominiumUnitList);

                For J := 0 to (CondominiumUnitList.Count - 1) do
                  TempCurrentlySelectedList.Add(CondominiumUnitList[J]);

              end
            else TempCurrentlySelectedList.Add(CurrentlySelectedList[I]);

        end  {For I := 0 to (CurrentlySelectedList.Count - 1) do}
    else TempCurrentlySelectedList.Assign(CurrentlySelectedList);  {No condos}

  PrintLabels(Sender, TempCurrentlySelectedList, ParcelLookupTable2,
              SwisCodeTable, AssessmentYearControlTable,
              AssessmentYear, LabelOptions);

  TempCurrentlySelectedList.Free;
  CondominiumUnitList.Free;

end;  {ReportPrint}

{========================================================}
Procedure TMappingForm.ParcelListReportPrintHeader(Sender: TObject);

begin
  with Sender as TBaseReport do
    begin
      SectionTop := 0.25;
      SectionLeft := 0.5;
      SectionRight := PageWidth - 0.5;
      SetFont('Times New Roman',8);
      PrintHeader('Page: ' + IntToStr(CurrentPage), pjRight);
      PrintHeader('Date: ' + DateToStr(Date) + '  Time: ' + TimeToStr(Now), pjLeft);

      SectionTop := 0.5;

      ClearTabs;
      SetTab(0.3, pjLeft, 8.0, 0, BoxLineNone, 0);

      Println('');
      Println('');

      SetFont('Times New Roman',12);
      Bold := True;
      Home;
      Println('');
      PrintCenter('Selected Parcels', (PageWidth / 2));
      Println('');
      Println('');

      SetFont('Times New Roman',10);
      ClearTabs;

      ClearTabs;
      SetTab(0.3, pjCenter, 1.4, 0, BoxLineBottom, 0);   {Parcel ID}
      SetTab(1.8, pjCenter, 2.5, 0, BoxLineBottom, 0);   {Owner}
      SetTab(4.4, pjCenter, 2.5, 0, BoxLineBottom, 0);   {Legal address}
      SetTab(7.0, pjCenter, 0.3, 0, BoxLineBottom, 0);   {Property class}

      Bold := True;
      Println(#9 + 'Parcel ID' +
              #9 + 'Owner' +
              #9 + 'Legal Address' +
              #9 + 'Cls');
      Bold := False;

      ClearTabs;
      SetTab(0.3, pjLeft, 1.4, 0, BoxLineNone, 0);   {Parcel ID}
      SetTab(1.8, pjLeft, 2.5, 0, BoxLineNone, 0);   {Owner}
      SetTab(4.4, pjLeft, 2.5, 0, BoxLineNone, 0);   {Legal address}
      SetTab(7.0, pjLeft, 0.3, 0, BoxLineNone, 0);   {Property class}

    end;  {with Sender as TBaseReport do}

end;  {ParcelListReportPrintHeader}

{========================================================}
Procedure TMappingForm.ParcelListReportPrint(Sender: TObject);

var
  I : Integer;
  SBLRec : SBLRecord;
  SwisSBLKey : String;

begin
  with Sender as TBaseReport do
    For I := 0 to (CurrentlySelectedList.Count - 1) do
      begin
        SwisSBLKey := CurrentlySelectedList[I];
        SBLRec := ExtractSwisSBLFromSwisSBLKey(SwisSBLKey);

        with SBLRec do
          FindKeyOld(ParcelLookupTable2,
                     ['TaxRollYr', 'SwisCode', 'Section',
                      'Subsection', 'Block', 'Lot', 'Sublot',
                      'Suffix'],
                     [AssessmentYear, SwisCode, Section, Subsection,
                      Block, Lot, Sublot, Suffix]);

        If (LinesLeft < 6)
          then NewPage;

        Println(#9 + ConvertSwisSBLToDashDot(SwisSBLKey) +
                #9 + ParcelLookupTable2.FieldByName('Name1').Text +
                #9 + GetLegalAddressFromTable(ParcelLookupTable2) +
                #9 + ParcelLookupTable2.FieldByName('PropertyClassCode').Text);


      end;  {For I := 0 to (CurrentlySelectedList.Count - 1) do}

end;  {ParcelListReportPrint}

{========================================================}
Procedure TMappingForm.ProxmitySpeedButtonClick(Sender: TObject);

var
  recs : IMoRecordset;
  Distance : Double;
  CurrentParcelShape, Polygon : IMoPolygon;
  FirstTimeThrough : Boolean;
  NewExtentRect : IMoRectangle;
  TempStr, NewFileName, TempSwisSBLKey : String;
  NumSelected : LongInt;
  TempFile : TextFile;
  ProximitySwisSBLKeyList : TStringList;
  ParcelFound, CondoFound : Boolean;

begin
  DialogShowing := True;
  ProximitySwisSBLKeyList := TStringList.Create;
  NumSelected := 0;
  FirstTimeThrough := True;

  try
    MapProximitySelectDialog := TMapProximitySelectDialog.Create(nil);

    MapProximitySelectDialog.SwisSBLKey := LastFoundSwisSBLKey;

    If (MapProximitySelectDialog.ShowModal = mrOK)
      then
        begin
          CondominiumUnitList.Clear;
          ProximitySubjectSwisSBLKey := MapProximitySelectDialog.SwisSBLKey;
          LastFoundSwisSBLKey := ProximitySubjectSwisSBLKey;
          Distance := MapProximitySelectDialog.ProximityRadius;
          StatusBar.Panels[1].Text := '';

            {CHG03132003-1: Allow for proximity from multiple parcels.}

          If MapProximitySelectDialog.UseAlreadySelectedParcels
            then
              begin
                recs := SelectedLayer.Records;
                recs.MoveFirst;

                If not Recs.EOF
                  then
                    begin
                      CurrentParcelShape := IMoPolygon(IDispatch(recs.Fields.item('Shape').value));
                      ProximitySwisSBLKeyList.Add(recs.Fields.item('ParcelID').value);
                      Recs.MoveNext;

                      while not Recs.EOF do
                        begin
                          CurrentParcelShape := IMoPolygon(CurrentParcelShape.Union(IMoPolygon(IDispatch(recs.Fields.item('Shape').value)), FullSizeRect));
                          ProximitySwisSBLKeyList.Add(recs.Fields.item('ParcelID').value);
                          Recs.MoveNext;
                        end;

                    end;  {If not Recs.EOF}

              end
            else
              begin
                ClearSelectedInformation;
                NumSelected := 0;
                ProximitySwisSBLKeyList.Add(ProximitySubjectSwisSBLKey);

                  {Locate the parcel.}

                TempStr := MapSetupObject.MapFileKeyField + ' = ''' +
                           ConvertPASKeyFieldToMapKeyField(ParcelTable, MapParcelIDFormatTable,
                                                           AssessmentYearControlTable,
                                                           ProximitySubjectSwisSBLKey,
                                                           AssessmentYear, MapSetupObject, False) +
                           '''';

                recs := MainLayer.SearchExpression(TempStr);

                If not recs.eof
                  then
                    begin
                      recs.MoveFirst;
                      CurrentParcelShape := IMoPolygon(IDispatch(recs.Fields.item('Shape').value));

                        {In case this is a multipart parcel (i.e. discontiguous shapes),
                         make sure to do a union of the parts.}

                      while not Recs.EOF do
                        begin
                          CurrentParcelShape := IMoPolygon(CurrentParcelShape.Union(IMoPolygon(IDispatch(recs.Fields.item('Shape').value)), FullSizeRect));
                          Recs.MoveNext;
                        end;

                    end;  {If not recs.eof}

              end;  {else of If MapProximitySelectDialog.UseAlreadySelectedParcels}

          If (CurrentParcelShape = nil)
            then
              begin
                ActionCancelled := True;
                MessageDlg('No proximate parcels were found.' + #13 +
                           'Please change the search parameters.',
                           mtWarning, [mbOK], 0);

              end
            else
              begin
                case MapProximitySelectDialog.ProximityType of
                  ptPerimeter : recs := MainLayer.SearchByDistance(CurrentParcelShape, Distance, '');
                  ptCentroid : recs := MainLayer.SearchByDistance(CurrentParcelShape.Centroid, Distance, '');
                end;

                recs.MoveFirst;
                FirstTimeThrough := True;

                  {CHG09132003-1: Add feature to search for condominium units
                                  if only the base parcel id is coded on the map.}

                ActionCancelled := False;

              end;  {If (CurrentParcelShape = nil)}

          while not (Recs.EOF or ActionCancelled) do
            begin
              ParcelFound := False;
              CondoFound := False;

              If FindParcelForMapRecord(ParcelLookupTable,
                                        MapParcelIDFormatTable, AssessmentYearControlTable,
                                        MapSetupObject,
                                        Recs.Fields.Item(MapSetupObject.MapFileKeyField).Value,
                                        AssessmentYear)
                then
                  begin
                    ParcelFound := True;
                    TempSwisSBLKey := ExtractSSKey(ParcelLookupTable);


                  end;  {If FindParcelForMapRecord ...}

                {If this parcel was not found, check to see if it is a condo.}

              If ((not ParcelFound) and
                  OnlyBaseCondominiumParcelIdIsEncoded and
                  FindCondominiumForMapRecord(MapCondoTable,
                                              MapSetupObject,
                                              Recs.Fields.Item(MapSetupObject.MapFileKeyField).Value))
                then
                  begin
                    CondoFound := True;
                    TempSwisSBLKey := MapCondoTable.FieldByName('SwisCode').Text +
                                      MapCondoTable.FieldByName('SBL').Text;

                      {We know this is a condo, so add all the units to the list.}

                    AddCondoUnitsToListForBaseCondoID(ParcelLookupTable2,
                                                      TempSwisSBLKey,
                                                      AssessmentYear,
                                                      CondominiumUnitList);

                  end;  {If ((not ParcelFound) and ...}

              If (ParcelFound or CondoFound)
                then
                  begin
                    If (CurrentlySelectedList.IndexOf(TempSwisSBLKey) = -1)
                      then
                        begin
                          CurrentlySelectedList.Add(TempSwisSBLKey);
                          NumSelected := NumSelected + 1;
                        end;

                      {Expand the extent to include all parcels.}

                    Polygon := IMoPolygon(CreateOleObject('MapObjects2.Polygon'));
                    Polygon := IMoPolygon(IDispatch(Recs.Fields.item('Shape').value));

                    If (ProximitySwisSBLKeyList.IndexOf(TempSwisSBLKey) > -1)
                      then AddItemToSelectedLayer(Polygon, TempSwisSBLKey, 'SUBJECT', moBlack,
                                                  moCrossFill, moRed, True)
                      else AddItemToSelectedLayer(Polygon, TempSwisSBLKey, '', moBlue,
                                                  SelectedFillStyle, SelectedFillColor, False);

                    If FirstTimeThrough
                      then
                        begin
                          FirstTimeThrough := False;
                          NewExtentRect := Polygon.Extent;
                        end
                      else
                        begin
                          If (Polygon.Extent.Left < NewExtentRect.Left)
                            then NewExtentRect.Left := Polygon.Extent.Left;

                          If (Polygon.Extent.Right > NewExtentRect.Right)
                            then NewExtentRect.Right := Polygon.Extent.Right;

                          If (Polygon.Extent.Top > NewExtentRect.Top)
                            then NewExtentRect.Top := Polygon.Extent.Top;

                          If (Polygon.Extent.Bottom < NewExtentRect.Bottom)
                            then NewExtentRect.Bottom := Polygon.Extent.Bottom;

                        end;  {If FirstTimeThrough}

                  end;  {If FindParcelForMapRecord ...}

              recs.MoveNext;

            end;  {while not Recs.EOF do}

            {Print out labels if they want them.}

          If (MapProximitySelectDialog.PrintLabels and
              ExecuteLabelOptionsDialog(LabelOptions) and
              PrintDialog.Execute)
            then
              begin
                If PrintDialog.PrintToFile
                  then
                    begin
                      NewFileName := GetPrintFileName(Self.Caption, True);
                      GlblPreviewPrint := True;
                      GlblDefaultPreviewZoomPercent := 70;
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

              end;  {If (MapProximitySelectDialog.PrintLabels and ..}

          StatusBar.Panels[1].Text := IntToStr(NumSelected) + ' parcels within ' +
                                      FormatFloat(DecimalEditDisplay, Distance) +
                                      ' feet.';

          DialogShowing := False;
          Map.Extent := NewExtentRect;
          Map.Refresh;

        end;  {If (MapProximitySelectDialog.ShowModal = mrOK)}

  finally
    MapProximitySelectDialog.Free;
  end;

end;  {ProxmitySpeedButtonClick}

{========================================================}
Procedure TMappingForm.ValueRangeStringGridDrawCell(Sender: TObject;
                                                    ACol, ARow: Integer;
                                                    Rect: TRect;
                                                    State: TGridDrawState);

var
  BackgroundColor : TColor;

begin
  with ValueRangeStringGrid do
    begin
      Canvas.Font.Size := 8;
      Canvas.Font.Name := 'Arial';
      Canvas.Font.Style := [fsBold];

      If (ARow = 0)
        then
          begin
            BackgroundColor := clBtnFace;
            Canvas.Font.Color := clBlack;
            CenterText(CellRect(ACol, ARow), Canvas, Cells[ACol, ARow], True,
                       True, BackgroundColor);
          end
        else
          case ACol of
            0 : begin
                  BackgroundColor := clWhite;
                  Canvas.Font.Color := clBlue;
                  CenterText(CellRect(ACol, ARow), Canvas, Cells[ACol, ARow], True,
                             True, BackgroundColor);
                end;  {Interval column}

            1 : begin
                  If (Deblank(Cells[ACol, ARow]) = '')
                    then BackgroundColor := clWhite
                    else BackgroundColor := StrToInt(Cells[ACol, ARow]);

                  CenterText(CellRect(ACol, ARow), Canvas, '', True,
                             True, BackgroundColor);

                end;  {Color column}

          end;  {case ACol of}

    end;  {with ValueRangeStringGrid do}

end;  {ValueRangeStringGridDrawCell}

{========================================================}
Procedure TMappingForm.ClearButtonClick(Sender: TObject);

begin
  SelectedLayerIsRangeLayer := False;
  ClearStringGrid(ValueRangeStringGrid);
  ValueRangeStringGrid.Cells[0, 0] := 'Interval';
  ValueRangeStringGrid.Cells[1, 0] := 'Color';
  ClearTList(MapRangeList, SizeOf(MapRangeItemRecord));
  ClearAllSelectedSpeedButtonClick(Sender);

end;  {ClearButtonClick}

{========================================================}
Procedure FillInOneValuesGridRow(ValueRangeStringGrid : TStringGrid;
                                 RowNumber : Integer;
                                 LowValue : String;
                                 HighValue : String;
                                 _Color : TColor);

begin
  with ValueRangeStringGrid do
    begin
      If (Deblank(HighValue) = '')
        then Cells[0, RowNumber] := LowValue
        else Cells[0, RowNumber] := LowValue + ' to ' + HighValue;

      Cells[1, RowNumber] := IntToStr(_Color);

    end;  {with ValueRangeStringGrid do}

end;  {FillInOneValuesGridRow}

{========================================================}
Procedure TMappingForm.FillInValueRangesGrid(MapRangeList : TList);

var
  I : Integer;

begin
  ClearStringGrid(ValueRangeStringGrid);
  ValueRangeStringGrid.Cells[0, 0] := 'Interval';
  ValueRangeStringGrid.Cells[1, 0] := 'Color';

  For I := 0 to (MapRangeList.Count - 1) do
    with ValueRangeStringGrid, MapRangeItemPointer(MapRangeList[I])^ do
      begin
        If ((I + 1) > RowCount)
          then RowCount := RowCount + 1;

        FillInOneValuesGridRow(ValueRangeStringGrid, (I + 1),
                               LowValue, HighValue,
                               MapRangeItemPointer(MapRangeList[I])^.Color);

      end;  {with ValueRangeStringGrid, MapRangeItemPointer(MapRangeList[I])^ do}

end;  {FillInValueRangesGrid}

{========================================================}
Procedure TMappingForm.ValueRangeStringGridDblClick(Sender: TObject);

begin
  MapRangeEditItemDialog := TMapRangeEditItemDialog.Create(nil);

  with MapRangeEditItemDialog do
    try
      MapRangeItemRec := MapRangeItemPointer(MapRangeList[ValueRangeStringGrid.Row - 1])^;

      If (ShowModal = idOK)
        then
          with MapRangeItemPointer(MapRangeList[ValueRangeStringGrid.Row - 1])^ do
            begin
              LowValue := MapRangeItemRec.LowValue;
              HighValue := MapRangeItemRec.HighValue;
              Color := MapRangeItemRec.Color;

              with MapRangeItemRec do
                FillInOneValuesGridRow(ValueRangeStringGrid, ValueRangeStringGrid.Row,
                                       LowValue, HighValue, Color);

            end;  {with MapRangeItemPointer...}

    finally
      Free;
    end;

end;  {ValueRangeStringGridDblClick}

{========================================================}
Procedure TMappingForm.ColorMapByRange(RangeType : Integer;
                                       MapRangeRec : MapRangeRecord);

var
  Quit, SaleFound, FirstTimeThrough : Boolean;
  CurrentProcessingType, PriorProcessingType : Integer;
  recs : IMoRecordset;
  fld  : IMoField;
  p, Polygon : IMoPolygon;
  CurrentRect : IMoRectangle;
  ft    : TFont;
  oleFt : variant;
  FieldName : OLEVariant;
  FillColor : TColor;
  AV_SalesPriceRatioStr,
  SalePrice, SaleDate,
  TempFieldName, SwisSBLKey, DisplayValue : String;
  AV_SalesPriceRatio, CurrentValue,
  PriorValue, PercentChange : Double;
  ValueInRange, _Found, CurrentFound, PriorFound : Boolean;

begin
  FillColor := 0;
  FirstTimeThrough := True;

  If (RangeType = rtAssessmentChange)
    then
      begin
        CurrentAssessmentYear := MapRangeRec.StartYear;
        PriorAssessmentYear := MapRangeRec.EndYear;

        CurrentProcessingType := GetProcessingTypeForTaxRollYear(CurrentAssessmentYear);
        PriorProcessingType := GetProcessingTypeForTaxRollYear(PriorAssessmentYear);
        OpenTableForProcessingType(CurrentAssessmentTable,
                                   AssessmentTableName,
                                   CurrentProcessingType, Quit);
        OpenTableForProcessingType(PriorAssessmentTable,
                                   AssessmentTableName,
                                   PriorProcessingType, Quit);

        CurrentAssessmentTable.IndexName := 'BYTAXROLLYR_SWISSBLKEY';
        PriorAssessmentTable.IndexName := 'BYTAXROLLYR_SWISSBLKEY';

      end;  {If (RangeType = rtAssessmentChange)}

  ClearSelectedInformation;

  If MapRangeRec.UseFullMapExtent
    then FullSizeButtonClick(nil);

  CurrentRect := IMoRectangle(CreateOleObject('MapObjects2.Rectangle'));
  CurrentRect := Map.Extent;
  recs := MainLayer.SearchShape(CurrentRect, moAreaIntersect, '');
  recs.MoveFirst;
  Application.ProcessMessages;
  ProgressBar.Visible := True;
  ProgressBar.Position := 0;
  ProgressBar.Max := Recs.Count;

    {Turn off fill since we are doing it manually.}


  FieldName := MapSetupObject.MapFileKeyField;

  ft := TFont.Create;
  ft.Name := 'Times New Roman';
  ft.size := 10;
  oleFt := FontToOleFont(ft);

  ActionCancelled := False;

  while not (Recs.EOF or ActionCancelled) do
    begin
      If FindParcelForMapRecord(ParcelLookupTable,
                                MapParcelIDFormatTable, AssessmentYearControlTable,
                                MapSetupObject,
                                Recs.Fields.Item(FieldName).Value,
                                AssessmentYear)
        then
          begin
            SwisSBLKey := ExtractSSKey(ParcelLookupTable);
            _Found := False;

            case RangeType of
              rtAssessedValue :
                begin
                  _Found := FindKeyOld(AssessmentTable, ['TaxRollYr', 'SwisSBLKey'],
                                       [AssessmentYear, SwisSBLKey]);

                  If _Found
                    then
                      begin
                        FillColor := FindRangeColorForValue(MapRangeList,
                                                            FormatFloat(NoDecimalDisplay,
                                                                        AssessmentTable.FieldByName('TotalAssessedVal').AsFloat),
                                                            True,
                                                            MapSetupObject.GetLayerColor('MAIN'),
                                                            ValueInRange);

                        DisplayValue := FormatFloat(NoDecimalDisplay,
                                                    AssessmentTable.FieldByName('TotalAssessedVal').AsFloat);

                      end;  {If _Found}

                end;  {rtAssessedValue}

              rtAssessmentChange :
                begin
                  _Found := True;
                  CurrentFound := FindKeyOld(CurrentAssessmentTable,
                                             ['TaxRollYr', 'SwisSBLKey'],
                                             [CurrentAssessmentYear, SwisSBLKey]);

                  PriorFound := FindKeyOld(PriorAssessmentTable,
                                           ['TaxRollYr', 'SwisSBLKey'],
                                           [PriorAssessmentYear, SwisSBLKey]);

                  If CurrentFound
                    then CurrentValue := CurrentAssessmentTable.FieldByName('TotalAssessedVal').AsFloat
                    else CurrentValue := 0;

                  If PriorFound
                    then PriorValue := PriorAssessmentTable.FieldByName('TotalAssessedVal').AsFloat
                    else PriorValue := 0;

                  try
                    PercentChange := (CurrentValue - PriorValue) / PriorValue * 100;
                    PercentChange := Roundoff(PercentChange, 2);
                  except
                    PercentChange := 0;
                  end;

                  FillColor := FindRangeColorForValue(MapRangeList,
                                                      FormatFloat(DecimalDisplay,
                                                                  PercentChange),
                                                      True,
                                                      MapSetupObject.GetLayerColor('MAIN'),
                                                      ValueInRange);

                  If (Roundoff(PercentChange, 0) = 0)
                    then DisplayValue := ''
                    else DisplayValue := FormatFloat(DecimalDisplay,
                                              PercentChange);

                end;  {rtAssessmentChange}

              rtSalesPrice :
                begin
                  SaleFound := False;
                  _Found := False;
                  SetRangeOld(SalesTable, ['SwisSBLKey', 'SaleNumber'],
                              [SwisSBLKey, '0'],
                              [SwisSBLKey, '9999']);

                  SalesTable.First;

                  If not SalesTable.EOF
                    then
                      begin
                        SalesTable.Last;

                        with SalesTable do
                          begin
                            SaleFound := True;
                            _Found := True;

                            SalePrice := FieldByName('SalePrice').Text;
                            SaleDate := FieldByName('SaleDate').Text;

                          end;  {with SalesTable do}

                      end;  {If not SalesTable.EOF}

                  If SaleFound
                    then
                      begin
                        _Found := True;
                        FillColor := FindRangeColorForValue(MapRangeList, SalePrice,
                                                            True,
                                                            MapSetupObject.GetLayerColor('MAIN'),
                                                            ValueInRange);

                        DisplayValue := SalePrice;

                      end;  {If SaleFound}

                end;  {rtSalesPrice}

              rtAssessedValue_SalesPrice_Ratio :
                begin
                  AV_SalesPriceRatioStr := '';
                  SetRangeOld(SalesTable, ['SwisSBLKey', 'SaleNumber'],
                              [SwisSBLKey, '0'],
                              [SwisSBLKey, '9999']);

                  SalesTable.First;

                  If not SalesTable.EOF
                    then
                      SalesTable.Last;

                      with SalesTable do
                        begin
                          SaleFound := True;
                          _Found := True;

                          try
                            AV_SalesPriceRatio := FieldByName('TotAssessedVal').AsInteger /
                                                  FieldByName('SalePrice').AsInteger;
                          except
                            AV_SalesPriceRatio := 0;
                            _Found := False;
                            SaleFound := False;
                          end;

                            {CHG11112003-3(M1.4): Allow the user to choose how many decimals to display for AV\SP ratio.}

                          If _Found
                            then AV_SalesPriceRatioStr := FormatFloat(GetAV_SP_DecimalDisplayFormat(MapSetupObject),
                                                                      AV_SalesPriceRatio)
                            else AV_SalesPriceRatioStr := '';

                        end;  {with SalesTable do}

                  If SaleFound
                    then
                      begin
                        FillColor := FindRangeColorForValue(MapRangeList, AV_SalesPriceRatioStr,
                                                            True,
                                                            MapSetupObject.GetLayerColor('MAIN'),
                                                            ValueInRange);

                        If ValueInRange
                          then DisplayValue := AV_SalesPriceRatioStr
                          else _Found := False;

                      end;  {If SaleFound}

                end;  {rtAssessedValue}

              rtZoningCodes,
              rtNeighborhoodCodes :
                begin
                  _Found := FindKeyOld(ResidentialSiteTable,
                                       ['TaxRollYr', 'SwisSBLKey'],
                                       [AssessmentYear, SwisSBLKey]);

                  If _Found
                    then
                      begin
                        case RangeType of
                          rtZoningCodes : TempFieldName := 'ZoningCode';
                          rtNeighborhoodCodes : TempFieldName := 'NeighborhoodCode';
                        end;

                        FillColor := FindRangeColorForValue(MapRangeList,
                                                            ResidentialSiteTable.FieldByName(TempFieldName).Text,
                                                            False,
                                                            MapSetupObject.GetLayerColor('MAIN'),
                                                            ValueInRange);

                        DisplayValue := ResidentialSiteTable.FieldByName(TempFieldName).Text

                      end;  {If _Found}

                    {CHG05012006: Check the commercial value, too.}

                  If not _Found
                    then
                      begin
                        _Found := FindKeyOld(CommercialSiteTable,
                                             ['TaxRollYr', 'SwisSBLKey'],
                                             [AssessmentYear, SwisSBLKey]);

                        If _Found
                          then
                            begin
                              case RangeType of
                                rtZoningCodes : TempFieldName := 'ZoningCode';
                                rtNeighborhoodCodes : TempFieldName := 'NeighborhoodCode';
                              end;

                              FillColor := FindRangeColorForValue(MapRangeList,
                                                                  CommercialSiteTable.FieldByName(TempFieldName).Text,
                                                                  False,
                                                                  MapSetupObject.GetLayerColor('MAIN'),
                                                                  ValueInRange);

                              DisplayValue := CommercialSiteTable.FieldByName(TempFieldName).Text

                            end;  {If _Found}

                      end;  {If not _Found}

                end;  {rtZoningCodes}

              rtPropertyClass :
                begin
                  _Found := True;
                  DisplayValue := ParcelLookupTable.FieldByName('PropertyClassCode').Text;

                  FillColor := FindRangeColorForValue(MapRangeList,
                                                      DisplayValue,
                                                      False,
                                                      MapSetupObject.GetLayerColor('MAIN'),
                                                      ValueInRange);

                end;  {rtPropertyClass}

            end;  {case RangeType of}

            If _Found
              then
                begin
                  fld := recs.Fields.item('Shape');
                  p := IMoPolygon(CreateOleObject('MapObjects2.Polygon'));
                  p := IMoPolygon(IDispatch(fld.value));

                  CurrentlySelectedList.Add(ExtractSSKey(ParcelLookupTable));
                  AddItemToSelectedLayer(p, ExtractSSKey(ParcelLookupTable),
                                         DisplayValue, moRed,
                                         moSolidFill, FillColor, True);

                    {Figure out the extent of the road.}

                  Polygon := IMoPolygon(IDispatch(Recs.Fields.item('Shape').value));

                  If FirstTimeThrough
                    then
                      begin
                        FirstTimeThrough := False;
                        LimitExtentRect := Polygon.Extent;
                      end
                    else
                      begin
                        If (Polygon.Extent.Left < LimitExtentRect.Left)
                          then LimitExtentRect.Left := Polygon.Extent.Left;

                        If (Polygon.Extent.Right > LimitExtentRect.Right)
                          then LimitExtentRect.Right := Polygon.Extent.Right;

                        If (Polygon.Extent.Top > LimitExtentRect.Top)
                          then LimitExtentRect.Top := Polygon.Extent.Top;

                        If (Polygon.Extent.Bottom < LimitExtentRect.Bottom)
                          then LimitExtentRect.Bottom := Polygon.Extent.Bottom;

                      end;  {If FirstTimeThrough}

                end;  {If _Found}

            ProgressBar.Position := ProgressBar.Position + 1;

          end;  {If (FindKeyOld(ParcelLookupTable, ['AccountNo'], ...}

      Application.ProcessMessages;

      recs.MoveNext;

    end;  {while not Recs.EOF do}

  ProgressBar.Position := 0;

  Map.Refresh;

end;  {ColorMapByRange}

{========================================================}
Procedure TMappingForm.ReapplyValuesButtonClick(Sender: TObject);

begin
  MapRangeRec.DisplayLabels := DisplayRangeLabelsCheckBox.Checked;
  ColorMapByRange(RangeType, MapRangeRec);
  SelectedLayerIsRangeLayer := True;

end;  {ReapplyValuesButtonClick}

{========================================================}
Procedure TMappingForm.RangeValuesComboBoxChange(Sender: TObject);

var
  IntegerValuesOnly : Boolean;
  SelectedCodesList : TStringList;

begin
  SelectedCodesList := TStringList.Create;

  try
    RangeType := RangeValuesComboBox.ItemIndex;
    MapRangeSelectDialog := TMapRangeSelectDialog.Create(nil);
    MapRangeSelectDialog.RangeType := RangeType;

    MapRangeSelectDialog.InitializeForm(MapRangeRec, False, SelectedCodesList);

    MapRangeSelectDialog.Caption := 'Select Map Ranges for ' +
                                    RangeValuesComboBox.Items[RangeValuesComboBox.ItemIndex];

    If (MapRangeSelectDialog.ShowModal = idOK)
      then
        begin
          MapRangeRec := MapRangeSelectDialog.MapRangeRec;
          DisplayRangeLabelsCheckBox.Checked := MapRangeRec.DisplayLabels;

          IntegerValuesOnly := True;

          case RangeType of
            rtAssessedValue_SalesPrice_Ratio : IntegerValuesOnly := False;
          end;  {case RangeType of}

          FillInMapRangeList(MapRangeList, MapRangeRec, RangeType, IntegerValuesOnly,
                             SelectedCodesList);

          ColorMapByRange(RangeType, MapRangeRec);

          SelectedLayerIsRangeLayer := True;

          FillInValueRangesGrid(MapRangeList);

          Map.Refresh;

            {Do we need to resize based on an action to match current scale?}
            {CHG11112003-4(M1.4): Add scale manipulation to map.}

          If ScaleIsLocked
            then AdjustExtentForLockedScaleTimer.Enabled := True;

        end;  {If FillingRanges}

  finally
    MapRangeSelectDialog.Free;
  end;

  SelectedCodesList.Free;

end;  {RangeValuesComboBoxChange}

{========================================================}
Procedure TMappingForm.SaveSpeedButtonClick(Sender: TObject);

begin
  SaveDialog.FileName := 'Map.bmp';

  If SaveDialog.Execute
    then Map.ExportMap(moExportBMP, SaveDialog.FileName, 1);

end;  {SaveSpeedButtonClick}

{========================================================}
Procedure TMappingForm.ExcelSpeedButtonClick(Sender: TObject);

{CHG12102003-1(M1.41): Extract the parcel IDs, names and addresses
                       of the selected parcels to Excel.}

var
  I, J : Integer;
  SwisSBLKey, SpreadsheetFileName : String;
  SBLRec : SBLRecord;
  NameAddressArray : NameAddrArray;
  ExtractFile : TextFile;

begin
  If (CurrentlySelectedList.Count = 0)
    then MessageDlg('There are no parcels currently selected.' + #13 +
                    'No information will be extracted to Excel.',
                    mtError, [mbOK], 0)
    else
      begin
        SpreadsheetFileName := GetPrintFileName('NM', True);
        AssignFile(ExtractFile, SpreadsheetFileName);
        Rewrite(ExtractFile);

        For I := 0 to (CurrentlySelectedList.Count - 1) do
          begin
            SwisSBLKey := CurrentlySelectedList[I];
            SBLRec := ExtractSwisSBLFromSwisSBLKey(SwisSBLKey);

            with SBLRec do
              FindKeyOld(ParcelLookupTable2,
                         ['TaxRollYr', 'SwisCode', 'Section',
                          'Subsection', 'Block', 'Lot', 'Sublot',
                          'Suffix'],
                         [AssessmentYear, SwisCode, Section,
                          Subsection, Block, Lot,
                          Sublot, Suffix]);

            GetNameAddress(ParcelLookupTable2, NameAddressArray);

            Write(ExtractFile, ConvertSBLOnlyToDashDot(Copy(SwisSBLKey, 7, 20)));

            For J := 1 to 6 do
              Write(ExtractFile, FormatExtractField(NameAddressArray[J]));

            Writeln(ExtractFile);

          end;  {For I := 0 to (CurrentlySelectedList.Count - 1) do}

        CloseFile(ExtractFile);
        SendTextFileToExcelSpreadsheet(SpreadsheetFileName, True,
                                       False, '');

      end;  {else of If (CurrentlySelectedList.Count = 0)}

end;  {ExcelSpeedButtonClick}

{========================================================}
Procedure TMappingForm.CopyToClipboardSpeedButtonClick(Sender: TObject);

{CHG12102003-2(M1.41): Copy the current view to the clipboard.}

begin
  try
    Map.CopyMap(10);
  except
  end;

end;  {CopyToClipboardSpeedButtonClick}

{========================================================}
Procedure TMappingForm.UnknownParcelReportPrintHeader(Sender: TObject);

var
  I : Integer;

begin
  with Sender as TBaseReport do
    begin
      SectionTop := 0.25;
      SectionLeft := 0.5;
      SectionRight := PageWidth - 0.5;
      SetFont('Times New Roman',8);
      PrintHeader('Page: ' + IntToStr(CurrentPage), pjRight);
      PrintHeader('Date: ' + DateToStr(Date) + '  Time: ' + TimeToStr(Now), pjLeft);

      SectionTop := 0.5;

      ClearTabs;
      SetTab(0.3, pjLeft, 8.0, 0, BoxLineNone, 0);

      Println('');
      Println('');

      SetFont('Times New Roman',12);
      Bold := True;
      Home;
      Println('');
      PrintCenter('Unknown Parcels', (PageWidth / 2));
      Println('');
      Println('');

      SetFont('Times New Roman',10);
      ClearTabs;

      If _Compare(iUnknownReportSection, mmtOnMapNotPAS, coEqual)
        then
          begin
            ClearTabs;
            SetTab(0.3, pjCenter, 1.5, 0, BoxLineBottom, 0);   {Field 1}
            SetTab(1.9, pjCenter, 1.5, 0, BoxLineBottom, 0);   {Field 2}
            SetTab(3.5, pjCenter, 1.5, 0, BoxLineBottom, 0);   {Field 3}
            SetTab(5.1, pjCenter, 1.5, 0, BoxLineBottom, 0);   {Field 4}
            SetTab(6.7, pjCenter, 1.5, 0, BoxLineBottom, 0);   {Field 5}

            Bold := True;
            Underline := True;
            Println(#9 + 'Parcels on map, not in PAS:');
            Underline := False;
            Println('');

            If UseGenericUnknownPrintFormat
              then
                begin
                  For I := 0 to (UnknownFieldNames.Count - 1) do
                    Print(#9 + UnknownFieldNames[I]);

                  Println('');
                end
              else Println(#9 + 'Acct_Num' +
                            #9 + 'PID' +
                            #9 + 'Parcel_ID' +
                            #9 + 'Area' +
                            #9 + 'Perimeter');
            Bold := False;

            ClearTabs;
            SetTab(0.3, pjRight, 1.5, 0, BoxLineNone, 0);   {Field 1}
            SetTab(1.9, pjRight, 1.5, 0, BoxLineNone, 0);   {Field 2}
            SetTab(3.5, pjRight, 1.5, 0, BoxLineNone, 0);   {Field 3}
            SetTab(5.1, pjRight, 1.5, 0, BoxLineNone, 0);   {Field 4}
            SetTab(6.7, pjRight, 1.5, 0, BoxLineNone, 0);   {Field 5}

          end;  {If _Compare(iUnknownReportSection, mmtOnMapNotPAS, coEqual)}

      If _Compare(iUnknownReportSection, mmtInPASNotMap, coEqual)
        then
          begin
            ClearTabs;
            SetTab(0.3, pjCenter, 1.5, 0, BoxLineBottom, 0);   {Print key}
            SetTab(1.9, pjCenter, 2.0, 0, BoxLineBottom, 0);   {Owner}
            SetTab(4.0, pjCenter, 2.0, 0, BoxLineBottom, 0);   {Legal address}
            SetTab(6.1, pjCenter, 2.0, 0, BoxLineBottom, 0);   {Account #}

            Bold := True;
            Underline := True;
            Println(#9 + 'Parcels in PAS, not on map:');
            Underline := False;
            Println('');
            Println(#9 + 'Parcel ID' +
                    #9 + 'Owner' +
                    #9 + 'Legal Address' +
                    #9 + 'Account #');

            Bold := False;

            ClearTabs;
            SetTab(0.3, pjLeft, 1.5, 0, BoxLineNone, 0);   {Print key}
            SetTab(1.9, pjLeft, 2.0, 0, BoxLineNone, 0);   {Owner}
            SetTab(4.0, pjLeft, 2.0, 0, BoxLineNone, 0);   {Legal address}
            SetTab(6.1, pjLeft, 2.0, 0, BoxLineNone, 0);   {Account #}

          end;  {If _Compare(iUnknownReportSection, mmtOnMapNotPAS, coEqual)}

    end;  {with Sender as TBaseReport do}

end;  {UnknownParcelReportPrintHeader}

{========================================================}
Procedure TMappingForm.UnknownParcelReportPrint(Sender: TObject);

var
  I, iCount : LongInt;
  sSpreadsheetName : String;
  sSpreadsheetFile : TextFile;

begin
  iCount := 0;
  sSpreadsheetName := GlblReportDir + 'Mismatches.txt';
  AssignFile(sSpreadsheetFile, sSpreadsheetName);
  Rewrite(sSpreadsheetFile);

  WritelnCommaDelimitedLine(sSpreadsheetFile,
                            ['PID',
                             'Acct_Num',
                             'ObjectID']);

  with Sender as TBaseReport do
    begin
        {Parcels on map, not PAS.}
      WritelnCommaDelimitedLine(sSpreadsheetFile,
                                ['Parcels on map, not in PAS.']);

      For I := 0 to (UnknownParcelList.Count - 1) do
        with UnknownParcelPointer(UnknownParcelList[I])^ do
          If _Compare(MismatchType, iUnknownReportSection, coEqual)
            then
              begin
                If (LinesLeft < 6)
                  then NewPage;

                WritelnCommaDelimitedLine(sSpreadsheetFile,
                                          [Field1,
                                           Field2,
                                           Field3,
                                           Field4,
                                           Field5]);

                Println(#9 + Field1 +
                        #9 + Field2 +
                        #9 + Field3 +
                        #9 + Field4 +
                        #9 + Field5);

                inc(iCount);

              end;  {If _Compare(MismatchType, iUnknownReportSection, coEqual)}

      Println('');
      Println(#9 + 'Mismatches = ' + IntToStr(iCount));

      iUnknownReportSection := mmtInPASNotMap;
      NewPage;
      iCount := 0;

      WritelnCommaDelimitedLine(sSpreadsheetFile, []);
      WritelnCommaDelimitedLine(sSpreadsheetFile,
                                ['Parcels in PAS, not on map.']);
      WritelnCommaDelimitedLine(sSpreadsheetFile,
                                ['Print Key',
                                 'Owner',
                                 'Legal Address',
                                 'Account #']);

      For I := 0 to (UnknownParcelList.Count - 1) do
        with UnknownParcelPointer(UnknownParcelList[I])^ do
          If _Compare(MismatchType, iUnknownReportSection, coEqual)
            then
              begin
                If (LinesLeft < 6)
                  then NewPage;

                WritelnCommaDelimitedLine(sSpreadsheetFile,
                                          [sPrintKey,
                                           sOwner,
                                           sLegalAddress,
                                           sAccountNumber]);

                Println(#9 + sPrintKey +
                        #9 + sOwner +
                        #9 + sLegalAddress +
                        #9 + sAccountNumber);

                inc(iCount);

              end;  {If _Compare(MismatchType, iUnknownReportSection, coEqual)}

      Println('');
      Println(#9 + 'Mismatches = ' + IntToStr(iCount));

    end;  {with Sender as TBaseReport do}

  CloseFile(sSpreadsheetFile);
  SendTextFileToExcelSpreadsheet(sSpreadsheetName, True,
                                 False, '');

end;  {UnknownParcelReportPrint}

{========================================================}
Procedure TMappingForm.UnknownSpeedButtonClick(Sender: TObject);

{Clear all currently selected parcels and highlight the unknown parcels in the current extent.}

var
  recs : IMoRecordset;
  fld  : IMoField;
  p : IMoPolygon;
  CurrentRect : IMoRectangle;
  FieldName : OLEVariant;
  Polygon : IMoPolygon;
  FoundCount, RecCount, I : Integer;
  PrintUnknowns : Boolean;
  UnknownParcelPtr : UnknownParcelPointer;
  NewFileName, TempStr, SwisSBLKey : String;
  TempFile : TextFile;
(*  TableDescription : IMoTableDesc;*)

begin
  iUnknownReportSection := mmtOnMapNotPAS;

  UnknownParcelList := TList.Create;
  UnknownFieldValues.Clear;
  UnknownFieldNames.Clear;
  UseGenericUnknownPrintFormat := True;

  PrintUnknowns := (MessageDlg('Do you want to print all unknown parcels?', mtConfirmation,
                               [mbYes, mbNo], 0) = idYes);

  ClearAllSelectedSpeedButtonClick(Sender);

    {CHG11272002-1: Move the legal address search here because the selected info
                    is now a layer..}

  CurrentRect := IMoRectangle(CreateOleObject('MapObjects2.Rectangle'));
  CurrentRect := Map.Extent;
  recs := MainLayer.SearchShape(CurrentRect, moAreaIntersect, '');
  recs.MoveFirst;
  Application.ProcessMessages;
  FoundCount := 0;
  RecCount := 0;
  ProgressBar.Visible := True;
  ProgressBar.Max := GetRecordCount(ParcelLookupTable) * 2;

  Polygon := IMoPolygon(CreateOleObject('MapObjects2.Polygon'));
  FieldName := MapSetupObject.MapFileKeyField;

  ActionCancelled := False;

  (*try
    TempStr := recs.Fields.item('Acct_Num').Value;
  except
    UseGenericUnknownPrintFormat := True;
    I := 0;

    TableDescription := IMoTableDesc(CreateOleObject('MapObjects2.TableDesc'));
    TableDescription := Recs.TableDesc;

    while _Compare(I, Min(4, TableDescription.FieldCount), coLessThanOrEqual) do
      begin
        UnknownFieldNames.Add(TableDescription.FieldName[I]);
        Inc(I);

      end;  {while _Compare(I, Min(4, TableDescription ...}

  end;  {try} *)

  UnknownFieldNames.Add('PID');
  UnknownFieldNames.Add('Acct_Num');
  UnknownFieldNames.Add('ObjectID');

  while not (Recs.EOF or ActionCancelled) do
    begin
      If not FindParcelForMapRecord(ParcelLookupTable,
                                    MapParcelIDFormatTable, AssessmentYearControlTable,
                                    MapSetupObject,
                                    Recs.Fields.Item(FieldName).Value,
                                    AssessmentYear)
        then
          begin
            FoundCount := FoundCount + 1;
            fld := recs.Fields.item('Shape');
            p := IMoPolygon(CreateOleObject('MapObjects2.Polygon'));
            p := IMoPolygon(IDispatch(fld.value));

            CurrentlySelectedList.Add(Recs.Fields.Item(FieldName).Value);
            AddItemToSelectedLayer(p, '', '', moBlue,
                                   SelectedFillStyle, SelectedFillColor, False);

            If PrintUnknowns
              then
                begin
                  New(UnknownParcelPtr);
                  UnknownParcelPtr^.MismatchType := mmtOnMapNotPAS;

                  with UnknownParcelPtr^ do
                    If UseGenericUnknownPrintFormat
                      then
                        begin
                          Field1 := '';
                          Field2 := '';
                          Field3 := '';
                          Field4 := '';
                          Field5 := '';

                          For I := 0 to (UnknownFieldNames.Count - 1) do
                            begin
                              TempStr := Recs.Fields.Item(UnknownFieldNames[I]).Value;

                              case I of
                                0 : Field1 := TempStr;
                                1 : Field2 := TempStr;
                                2 : Field3 := TempStr;
                                3 : Field4 := TempStr;
                                4 : Field5 := TempStr;

                              end;  {case I of}

                            end;  {while _Compare(I, Min(4, TableDescription ...}

                        end
                      else
                        begin
                          Field1 := recs.Fields.item('Acct_Num').Value;
                          Field2 := recs.Fields.item('PID').Value;
                          Field3 := recs.Fields.item('Parcel_ID').Value;
                          Field4 := recs.Fields.item('Area').Value;
                          Field5 := recs.Fields.item('Perimeter').Value;

                        end;  {else of If UseGenericUnknownPrintFormat}

                  UnknownParcelList.Add(UnknownParcelPtr);

                end;  {If PrintUnknowns}

          end;  {If (FindKeyOld(ParcelLookupTable, ['AccountNo'], ...}

      RecCount := RecCount + 1;
      ProgressBar.Position := RecCount;
      Application.ProcessMessages;

      recs.MoveNext;

    end;  {while not Recs.EOF do}

    {Now search the other way around.}

  with ParcelLookupTable do
    begin
      First;

      while (not EOF) do
        begin
          SwisSBLKey := ExtractSSKey(ParcelLookupTable);

          If _Compare(FieldByName('OwnershipCode').AsString, 'C', coNotEqual)
            then
              begin
                TempStr := MapSetupObject.MapFileKeyField + ' = ''' +
                           ConvertPASKeyFieldToMapKeyField(ParcelTable, MapParcelIDFormatTable,
                                                           AssessmentYearControlTable, SwisSBLKey,
                                                           AssessmentYear, MapSetupObject, False) +
                           '''';

                recs := MainLayer.SearchExpression(TempStr);

                If recs.EOF
                  then
                    begin
                      New(UnknownParcelPtr);

                      with UnknownParcelPtr^ do
                        begin
                          MismatchType := mmtInPASNotMap;

                          Field1 := '';
                          Field2 := '';
                          Field3 := '';
                          Field4 := '';
                          Field5 := '';

                          sPrintKey := ConvertSBLOnlyToDashDot(Copy(SwisSBLKey, 7, 20));
                          sOwner := FieldByName('Name1').AsString;
                          sLegalAddress := GetLegalAddressFromTable(ParcelLookupTable);
                          sAccountNumber := FieldByName('AccountNo').AsString;
                          UnknownParcelList.Add(UnknownParcelPtr);

                        end;  {with UnknownParcelPtr^ do}

                    end;  {If recs.EOF}

              end;  {If _Compare(FieldByName('OwnershipCode').AsString, 'C', coNotEqual)}

          Next;
          RecCount := RecCount + 1;
          ProgressBar.Position := RecCount;
          Application.ProcessMessages;
          StatusBar.Panels[1].Text := 'Trying to match ' + ConvertSBLOnlyToDashDot(Copy(SwisSBLKey, 7, 20)) + '.';

        end;  {while (not EOF) do}

    end;  {with ParcelLookupTable do}

  ProgressBar.Visible := False;
  StatusBar.Panels[1].Text := IntToStr(FoundCount) + ' not found.';
  RefreshSelectedLayer;

  If (PrintUnknowns and
      PrintDialog.Execute)
    then
      begin
        If PrintDialog.PrintToFile
          then
            begin
              NewFileName := GetPrintFileName(Self.Caption, True);
              GlblPreviewPrint := True;
              GlblDefaultPreviewZoomPercent := 70;
              UnknownParcelReportFiler.FileName := NewFileName;

              try
                PreviewForm := TPreviewForm.Create(self);
                PreviewForm.FilePrinter.FileName := NewFileName;
                PreviewForm.FilePreview.FileName := NewFileName;
                UnknownParcelReportFiler.Execute;
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

            end
          else UnknownParcelReportPrinter.Execute;

      end;  {If (PrintUnknowns and ...}

  FreeTList(UnknownParcelList, SizeOf(UnknownParcelRecord));

end;  {UnknownSpeedButtonClick}

{========================================================}
Procedure TMappingForm.RefreshButtonClick(Sender: TObject);

var
  I : Integer;

begin
  DialogShowing := False;
  ApplyingChanges := False;
  For I := (Map.Layers.Count - 1) downto 0 do
    Map.RefreshLayer(I);

end;  {RefreshButtonClick}

{========================================================}
Procedure TMappingForm.AdjustCurrentExtentToScale(CurrentScale : Extended);

{Adjust the current extent to the current scale.
 Note that this means that the Y extent will be adjusted differently from the X extent
 because the map component is not square.}

var
  CenterPoint, LowerLeft, UpperRight : IMoPoint;
  MapSizeX, (*MapSizeY, *) {In inches}
  ScaleX, ScaleY,
  ScalePercentDifference, OriginalX_YRatio,
  NewDistanceX, NewDistanceY : Extended;
  CurrentRect : IMoRectangle;
  NumberOfTries : Integer;
  ScaleCorrect : Boolean;

begin
  CurrentRect := IMoRectangle(CreateOleObject('MapObjects2.Rectangle'));
  CurrentRect := Map.Extent;

    {First determine the center point of the current extent so that we can rescale around it.}

  CenterPoint := CurrentRect.Center;

  (*MessageDlg('X: ' + FormatFloat(_3DecimalDisplay, CenterPoint.X) +
             ' Y: ' + FormatFloat(_3DecimalDisplay, CenterPoint.Y),
             mtInformation, [mbOK], 0);*)

    {Now get the lower left and upper right points of the current extent.}

  LowerLeft := IMoPoint(CreateOleObject('MapObjects2.Point'));
  LowerLeft.X := CurrentRect.Extent.Left;
  LowerLeft.Y := CurrentRect.Extent.Bottom;

(*  MessageDlg('LL -> X: ' + FormatFloat(_3DecimalDisplay, LowerLeft.X) +
             ' Y: ' + FormatFloat(_3DecimalDisplay, LowerLeft.Y),
             mtInformation, [mbOK], 0); *)

  UpperRight := IMoPoint(CreateOleObject('MapObjects2.Point'));
  UpperRight.X := CurrentRect.Extent.Right;
  UpperRight.Y := CurrentRect.Extent.Top;

  with CurrentRect.Extent do
    try
      OriginalX_YRatio := Abs((Left - Right) / (Top - Bottom));
    except
      OriginalX_YRatio := 0;
    end;

(*  MessageDlg('UR -> X: ' + FormatFloat(_3DecimalDisplay, UpperRight.X) +
             ' Y: ' + FormatFloat(_3DecimalDisplay, UpperRight.Y),
             mtInformation, [mbOK], 0);*)

    {How many inches wide and high is the map control?}

  MapSizeX := Map.Width / Self.PixelsPerInch;
  (*MapSizeY := Map.Height / Self.PixelsPerInch; *)

    {So the new distance for the current scale is the scale * the map size.}
    {Note that we don't set the y scale the same way - we have to compute to
     keep the same X_Y ratio.  This is because MapObjects overrides the new extent to
     keep the same aspect ratio, so technically the y is not exactly the same scale.
     This can only be achieved if the control is square, but we aren't, so we have to
     live with the error (maybe about 0.5%).}

  NewDistanceX := CurrentScale * MapSizeX;
(*  NewDistanceY := CurrentScale * MapSizeY;*)
  NewDistanceY := (NewDistanceX / OriginalX_YRatio);

  ScaleCorrect := False;
  NumberOfTries := 0;

    {Because of rounding problems, we have to use a feedback method to come up with the
     exact scale.}

  repeat
      {So change the extent to be the center point +/- half the distance in that direction.}

    LimitExtentRect.Left := CenterPoint.X - (NewDistanceX / 2);
    LimitExtentRect.Right := CenterPoint.X + (NewDistanceX / 2);
    LimitExtentRect.Top := CenterPoint.Y + (NewDistanceY / 2);
    LimitExtentRect.Bottom := CenterPoint.Y - (NewDistanceY / 2);

    GetScale(Self, LimitExtentRect, Map, ScaleX, ScaleY);
    NumberOfTries := NumberOfTries + 1;

    If (Roundoff(ScaleX, 3) = Roundoff(CurrentScale, 3))
      then ScaleCorrect := True
      else
        begin
          ScalePercentDifference := (CurrentScale - ScaleX) / CurrentScale;

          NewDistanceX := NewDistanceX + (ScalePercentDifference * ScaleX);
          NewDistanceY := NewDistanceY + (ScalePercentDifference * ScaleY);

        end;  {else of If (Roundoff(ScaleX, 3) = (Roundoff(CurrentScale, 3))}

  until (ScaleCorrect or (NumberOfTries > 20));

  LimitExtentTimer.Enabled := True;

(*  Map.Extent.Left := LimitExtentRect.Left;
  Map.Extent.Right := LimitExtentRect.Right;
  Map.Refresh;*)

end;  {AdjustCurrentExtentToScale}

{========================================================}
Procedure TMappingForm.LockScaleButtonClick(Sender: TObject);

{CHG11112003-4(M1.4): Add scale manipulation to map.}

var
  NewScale : Extended;

begin
  ScaleIsLocked := True;
  LockScaleButton.Visible := False;
  UnlockScaleButton.Visible := True;

  ScaleComboBox.Color := clBtnFace;
  ScaleComboBox.Font.Color := clBlue;

  try
    NewScale := StrToFloat(ScaleComboBox.Text);
  except
    NewScale := 0;
  end;

  LockedScale := NewScale;

  If ((Roundoff(NewScale, 3) <> 0) and
      (Roundoff(NewScale, 3) <> Roundoff(CurrentScale, 3)))
    then ScaleComboBoxCloseUp(nil, False);

end;  {LockScaleButtonClick}

{========================================================}
Procedure TMappingForm.UnlockScaleButtonClick(Sender: TObject);

{CHG11112003-4(M1.4): Add scale manipulation to map.}

begin
  ScaleIsLocked := False;
  LockScaleButton.Visible := True;
  UnlockScaleButton.Visible := False;
  ScaleComboBox.Color := clWindow;
  ScaleComboBox.Font.Color := clBlack;

end;  {UnlockScaleButtonClick}

(*
{========================================================}
Procedure TMappingForm.ScaleComboBoxChange(Sender: TObject);

{CHG11112003-4(M1.4): Add scale manipulation to map.}

var
  TempStr : String;

begin
  TempStr := ScaleComboBox.Text;
  Delete(TempStr, 1, 2);  {Remove the '1:'}

  try
    CurrentScale := StrToFloat(TempStr);
  except
    CurrentScale := StrToFloat(EditScale.Text);
  end;

  AdjustCurrentExtentToScale(CurrentScale);

end;  {ScaleComboBoxChange}*)

{========================================================}
Procedure TMappingForm.ScaleComboBoxCloseUp(Sender: TwwDBComboBox;
                                            Select: Boolean);

var
  CurrentRect : IMoRectangle;
  ScaleX, ScaleY : Extended;

begin
  CurrentRect := IMoRectangle(CreateOleObject('MapObjects2.Rectangle'));
  CurrentRect := Map.Extent;

  try
    CurrentScale := StrToFloat(ScaleComboBox.Text);
  except
    CurrentScale := GetScale(Self, CurrentRect, Map, ScaleX, ScaleY);
  end;

  AdjustCurrentExtentToScale(CurrentScale);

end;  {ScaleComboBoxCloseUp}

{========================================================}
Procedure TMappingForm.ScaleComboBoxExit(Sender: TObject);

var
  NewScale : Extended;

begin
  try
    NewScale := StrToFloat(ScaleComboBox.Text);
  except
    NewScale := 0;
  end;

  If ((Roundoff(NewScale, 3) <> 0) and
      (Roundoff(NewScale, 3) <> Roundoff(CurrentScale, 3)))
    then ScaleComboBoxCloseUp(nil, False);

end;  {ScaleComboBoxExit}

{========================================================}
Procedure TMappingForm.AdjustExtentForLockedScaleTimerTimer(Sender: TObject);

begin
  AdjustExtentForLockedScaleTimer.Enabled := False;
  AdjustCurrentExtentToScale(LockedScale);
end;

(*
{========================================================}
Procedure TMappingForm.EditScaleExit(Sender: TObject);

var
  CurrentRect : IMoRectangle;
  ScaleX, ScaleY : Extended;

begin
  CurrentRect := IMoRectangle(CreateOleObject('MapObjects2.Rectangle'));
  CurrentRect := Map.Extent;

  try
    CurrentScale := StrToFloat(EditScale.Text);
  except
    CurrentScale := GetScale(Self, CurrentRect, Map, ScaleX, ScaleY);
  end;

  AdjustCurrentExtentToScale(CurrentScale);

end;  {EditScaleExit}*)

{========================================================}
Procedure TMappingForm.ExtractGISParcelShapeFileSpeedButtonClick(Sender: TObject);

{CHG03242004-1(M1.05): Extract selected fields from the parcel dbf along with selected base information.}

var
  tdesc: IMoTableDesc;
  flds : IMoFields;
  I, J, RecCount : LongInt;
  ActionCancelled, Continue, FirstField : Boolean;
  CurrentRect : IMORectangle;
  KeyFieldName, SpreadsheetFileName : String;
  _FieldName, _FieldValue : Variant;
  ExtractMainLayerInformationDialog : TExtractMainLayerInformationDialog;
  MainLayerFieldsToExtractList, ParcelTableFieldsToExtractList : TStringList;
  ExtractFile : TextFile;
  recs : IMoRecordset;

begin
  Continue := False;
  MainLayerFieldsToExtractList := TStringList.Create;
  ParcelTableFieldsToExtractList := TStringList.Create;

  ExtractMainLayerInformationDialog := TExtractMainLayerInformationDialog.Create(nil);

  ExtractMainLayerInformationDialog.InitializeForm(MainLayerFieldsToExtractList, ParcelTableFieldsToExtractList,
                                                   MainLayer.Records);

  try
    If (ExtractMainLayerInformationDialog.ShowModal = mrOK)
      then
        begin
          Continue := True;

          If ExtractMainLayerInformationDialog.UseFullMapExtent
            then FullSizeButtonClick(Sender);

        end;  {If (ExtractMainLayerInformationDialog.ShowModal = mrOK)}

  finally
    ExtractMainLayerInformationDialog.Free;
  end;

    {Now go through all the parcels in the current extent.}

  If Continue
    then
      begin
        CurrentRect := IMoRectangle(CreateOleObject('MapObjects2.Rectangle'));
        CurrentRect := Map.Extent;
        recs := MainLayer.SearchShape(CurrentRect, moAreaIntersect, '');
        recs.MoveFirst;
        Application.ProcessMessages;
        RecCount := 0;
        ProgressBar.Visible := True;
        ProgressBar.Max := Recs.Count;
        SpreadsheetFileName := GetPrintFileName('NM', True);
        AssignFile(ExtractFile, SpreadsheetFileName);
        Rewrite(ExtractFile);

        KeyFieldName := MapSetupObject.MapFileKeyField;

        ActionCancelled := False;

          {First put out a line of headers.}

        For I := 0 to (MainLayerFieldsToExtractList.Count - 1) do
          If (I = 0)
            then Write(ExtractFile, 'GIS')
            else Write(ExtractFile, FormatExtractField('GIS'));

        For I := 0 to (ParcelTableFieldsToExtractList.Count - 1) do
          Write(ExtractFile, FormatExtractField('PAS'));

        Writeln(ExtractFile);

        For I := 0 to (MainLayerFieldsToExtractList.Count - 1) do
          If (I = 0)
            then Write(ExtractFile, MainLayerFieldsToExtractList[0])
            else Write(ExtractFile, FormatExtractField(MainLayerFieldsToExtractList[I]));

        For I := 0 to (ParcelTableFieldsToExtractList.Count - 1) do
          Write(ExtractFile, FormatExtractField(ParcelTableFieldsToExtractList[I]));

        Writeln(ExtractFile);


        while not (Recs.EOF or ActionCancelled) do
          begin
            If FindParcelForMapRecord(ParcelLookupTable,
                                      MapParcelIDFormatTable, AssessmentYearControlTable,
                                      MapSetupObject,
                                      Recs.Fields.Item(KeyFieldName).Value,
                                      AssessmentYear)
              then
                begin
                     {For each field in the main layer that they selected to extract, do it.}

                  tdesc := IMoTableDesc(CreateOleObject('MapObjects2.TableDesc'));
                  tdesc := Recs.TableDesc;
                  flds := Recs.Fields;
                  FirstField := True;

                    {In order to preserve the order selected in the main layer list,
                     for each field in the main layer selected list, go through the fields in
                     the shape .dbf table until we find that field.}

                  For J := 0 to (MainLayerFieldsToExtractList.Count - 1) do
                    For I := 0 to (tdesc.FieldCount - 1) do
                      begin
                        _FieldName := flds.Item(tdesc.FieldName[I]).Name;

                        If (ANSIUpperCase(_FieldName) = ANSIUpperCase(MainLayerFieldsToExtractList[J]))
                          then
                            begin
                              _FieldValue := flds.Item(tdesc.FieldName[I]).valueasstring;

                              If FirstField
                                then
                                  begin
                                    FirstField := False;
                                    Write(ExtractFile, _FieldValue);
                                  end
                                else Write(ExtractFile, FormatExtractField(_FieldValue));

                            end;  {If (ANSIUpperCase(_FieldName)...}

                    end;  {For I := 0 to (tdesc.FieldCount - 1) do}

                    {Now write out the parcel table fields.}

                  For I := 0 to (ParcelTableFieldsToExtractList.Count - 1) do
                    Write(ExtractFile, FormatExtractField(ParcelLookupTable.FieldByName(ParcelTableFieldsToExtractList[I]).Text));

                  Writeln(ExtractFile);

                end;  {If (FindKeyOld(ParcelLookupTable, ['AccountNo'], ...}

            RecCount := RecCount + 1;
            ProgressBar.Position := RecCount;
            Application.ProcessMessages;

            recs.MoveNext;

          end;  {while not Recs.EOF do}

        ProgressBar.Visible := False;
        StatusBar.Panels[1].Text := IntToStr(RecCount) + ' extracted';

        CloseFile(ExtractFile);
        SendTextFileToExcelSpreadsheet(SpreadsheetFileName, True,
                                       False, '');

      end;  {If Continue}

  MainLayerFieldsToExtractList.Free;
  ParcelTableFieldsToExtractList.Free;

end;  {ExtractGISParcelShapeFileSpeedButtonClick}

{========================================================}
Procedure TMappingForm.SetPASFieldSpeedButtonClick(Sender: TObject);

begin
  try
    SetFieldValueFromMapLayerDialog := TSetFieldValueFromMapLayerDialog.Create(nil);

    SetFieldValueFromMapLayerDialog.ParcelLayer := MainLayer;
    SetFieldValueFromMapLayerDialog.MapSetupObject := MapSetupObject;
    SetFieldValueFromMapLayerDialog.Map := Map;
    SetFieldValueFromMapLayerDialog.InitializeForm;
    SetFieldValueFromMapLayerDialog.ShowModal;
  finally
    SetFieldValueFromMapLayerDialog.Free;
  end;

end;  {SetPASFieldSpeedButtonClick}

{================================================================}
Procedure TMappingForm.ShowPicturesSpeedButtonClick(Sender: TObject);

var
  FirstTimeThrough, LimitExtent : Boolean;
  recs : IMoRecordset;
  fld  : IMoField;
  p : IMoPolygon;
  CurrentRect : IMoRectangle;
  FieldName : OLEVariant;
  Polygon : IMoPolygon;
  RecCount, FoundCount : Integer;
  PictureTable : TTable;

begin
  PictureTable := TTable.Create(nil);
  with PictureTable do
    try
      TableType := ttDBase;
      DatabaseName := 'PASsystem';
      IndexName := 'BYSWISSBLKEY';
      TableName := PictureTableName;
      Open;
    except
    end;

  ApplyingChanges := True;
  LoadFromParcelList := False;
  CreateParcelList := False;
  CriteriaInEffect := True;
  LimitExtent := False;

    {Now select the parcels that apply.}

  FirstTimeThrough := True;
  CurrentRect := IMoRectangle(CreateOleObject('MapObjects2.Rectangle'));
  CurrentRect := Map.Extent;
  recs := MainLayer.SearchShape(CurrentRect, moAreaIntersect, '');
  recs.MoveFirst;
  Application.ProcessMessages;
  RecCount := 0;
  FoundCount := 0;
  ProgressBar.Visible := True;
  ProgressBar.Max := Recs.Count;
  Polygon := IMoPolygon(CreateOleObject('MapObjects2.Polygon'));

  ClearSelectedInformation;
  FieldName := MapSetupObject.MapFileKeyField;

  ActionCancelled := False;

  while not (Recs.EOF or ActionCancelled) do
    begin
      If (FindParcelForMapRecord(ParcelLookupTable,
                                 MapParcelIDFormatTable, AssessmentYearControlTable,
                                 MapSetupObject,
                                 Recs.Fields.Item(FieldName).Value,
                                 AssessmentYear) and
          _Locate(PictureTable, [ExtractSSKey(ParcelLookupTable)], '', []))
        then
          begin
            FoundCount := FoundCount + 1;
            fld := recs.Fields.item('Shape');
            p := IMoPolygon(CreateOleObject('MapObjects2.Polygon'));
            p := IMoPolygon(IDispatch(fld.value));

            CurrentlySelectedList.Add(ExtractSSKey(ParcelLookupTable));
            AddItemToSelectedLayer(p, ExtractSSKey(ParcelLookupTable), '', moBlue,
                                   SelectedFillStyle, SelectedFillColor, False);

            If CreateParcelList
              then ParcelListDialog.AddOneParcel(ExtractSSKey(ParcelLookupTable));

            If LimitExtent
              then
                begin
                  Polygon := IMoPolygon(IDispatch(Recs.Fields.item('Shape').value));

                  If FirstTimeThrough
                    then
                      begin
                        FirstTimeThrough := False;
                        LimitExtentRect := Polygon.Extent;
                      end
                    else
                      begin
                        If (Polygon.Extent.Left < LimitExtentRect.Left)
                          then LimitExtentRect.Left := Polygon.Extent.Left;

                        If (Polygon.Extent.Right > LimitExtentRect.Right)
                          then LimitExtentRect.Right := Polygon.Extent.Right;

                        If (Polygon.Extent.Top > LimitExtentRect.Top)
                          then LimitExtentRect.Top := Polygon.Extent.Top;

                        If (Polygon.Extent.Bottom < LimitExtentRect.Bottom)
                          then LimitExtentRect.Bottom := Polygon.Extent.Bottom;

                      end;  {If FirstTimeThrough}

                end;  {If LimitExtent}

          end;  {If (FindKeyOld(ParcelLookupTable, ['AccountNo'], ...}

      RecCount := RecCount + 1;
      ProgressBar.Position := RecCount;
      Application.ProcessMessages;

      recs.MoveNext;

    end;  {while not Recs.EOF do}

  ProgressBar.Visible := False;
  StatusBar.Panels[1].Text := IntToStr(FoundCount) + ' selected.';
  CreateParcelList := False;
  ApplyingChanges := False;

  If LimitExtent
    then
      begin
        Map.Extent := LimitExtentRect;

          {Do we need to resize based on an action to match current scale?}
          {CHG11112003-4(M1.4): Add scale manipulation to map.}

        If ScaleIsLocked
          then AdjustExtentForLockedScaleTimer.Enabled := True;

      end
    else Map.Refresh;

  PictureTable.Close;
  PictureTable.Free;

end;  {ShowPicturesSpeedButtonClick}

{========================================================}
Procedure TMappingForm.CloseMappingButtonClick(Sender: TObject);

begin
  Close;
end;

{========================================================}
Procedure TMappingForm.FormCloseQuery(    Sender: TObject;
                                      var CanClose: Boolean);

begin
  SelectedLayerDc.Disconnect;
  Map.Layers.Clear;
  SelectedLayerDc._Release;
  DeleteSelectedLayerGeoDataset;

end;  {FormCloseQuery}

{========================================================}
Procedure TMappingForm.FormClose(    Sender: TObject;
                                 var Action: TCloseAction);

var
  I : Integer;
  TempSelectedLayerCommandLine : String;
  SelectedLayerPChar : PChar;
  TempLen : Integer;

begin
  UnknownFieldValues.Free;
  UnknownFieldNames.Free;

  SelectedSwisCodes.Free;
  SelectedSchoolCodes.Free;
  SelectedPropertyClasses.Free;
  SelectedRollSections.Free;
  SelectedSDCodes.Free;
  SelectedEXCodes.Free;

  try
    CurrentAssessmentTable.Close;
    PriorAssessmentTable.Close;
    CurrentAssessmentTable.Free;
    PriorAssessmentTable.Free;
  except
  end;

  For I := 0 to (MapInfoFormList.Count - 1) do
    try
      TForm(MapInfoFormList[I]).Free;
    except
    end;

  MapSetupObject.Free;
  CurrentlySelectedList.Free;
  CondominiumUnitList.Free;
(*  LayersCheckListBox.Free;*)

  FreeTList(MapRangeList, SizeOf(MapRangeItemRecord));

  CloseTablesForForm(Self);

    {The DBF and SHP files are not released until a new GeoDataset are
     created or the application is closed.  So, we have to launch a
     separate application to delete the remaining files.}

  TempSelectedLayerCommandLine := GlblDrive + ':' + GlblProgramDir +
                                  'DeleteFileOnClose.EXE' +
                                  ' FILEDIRECTORY=' + '"' + SelectedLayerLocation + '"' +
                                  ' FILENAME=' + StripPath(SelectedLayerToDelete) +
                                  ' LABEL=' + StripPath(SelectedLayerToDelete);

  TempLen := Length(TempSelectedLayerCommandLine);
  SelectedLayerPChar := StrAlloc(TempLen + 1);
  StrPCopy(SelectedLayerPChar, TempSelectedLayerCommandLine);

  GlblApplicationIsTerminatingToDoBackup := True;
  WinExec(SelectedLayerPChar, SW_MINIMIZE);
  StrDispose(SelectedLayerPChar);

    {Free up the child window and set the ClosingAForm Boolean to
     true so that we know to delete the tab.}

  Action := caFree;
  GlblClosingAForm := True;
  GlblClosingFormCaption := Caption;

end;  {FormClose}

end.
