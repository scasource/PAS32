unit PMap;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  StdCtrls, ExtCtrls, Forms, Dialogs, DB, Grids, DBGrids,
  DBTables, Mask, DBCtrls, Wwtable, Wwdatsrc, Wwdbcomb, Wwdbigrd, Wwdbgrid,
  Btrvdlg, Types, wwdblook, Buttons, MMOpen, TMultiP, Printers, OleCtrls,
  MapObjects2_TLB, ComObj, ActiveX, RPFiler, RPDefine, RPBase, RPCanvas,
  RPrinter, MapSetupObjectType, ComCtrls, CheckLst, FileCtrl, PASTypes, MapUtilitys;

type
  TMapForm = class(TForm)
    Panel1: TPanel;
    TitleLabel: TLabel;
    Panel2: TPanel;
    ScrollBox: TScrollBox;
    ParcelDataSource: TDataSource;
    ParcelTable: TTable;
    EditName: TDBEdit;
    EditSBL: TMaskEdit;
    YearLabel: TLabel;
    EditLocation: TEdit;
    Label4: TLabel;
    ImagePanel: TPanel;
    Label53: TLabel;
    Label55: TLabel;
    TotalAVLabel: TLabel;
    LandAVLabel: TLabel;
    InactiveLabel: TLabel;
    MapTimer: TTimer;
    Panel3: TPanel;
    ParcelLookupTable: TTable;
    ReportPrinter: TReportPrinter;
    ReportFiler: TReportFiler;
    PrintDialog: TPrintDialog;
    ParcelLookupTable2: TTable;
    PartialAssessmentLabel: TLabel;
    MappingHeaderTable: TTable;
    MappingDetailTable: TwwTable;
    MapLayersAvailableTable: TTable;
    StatusBar: TStatusBar;
    Map: TMap;
    SwisCodeTable: TTable;
    AssessmentYearControlTable: TTable;
    FlashShapeTimer: TTimer;
    SaveDialog: TSaveDialog;
    MapParcelIDFormatTable: TTable;
    ToolPanel : TPanel;
    LocationLabel : TLabel;
    HeaderPanel : TPanel;
    OwnerLabel : TLabel;
    PageControl1: TPageControl;
    OptionsTabSheet: TTabSheet;
    SBZoomOut: TSpeedButton;
    PrintMapButton: TSpeedButton;
    SBZoomIn: TSpeedButton;
    PanLeftButton: TSpeedButton;
    PanRightButton: TSpeedButton;
    PanUpButton: TSpeedButton;
    PanDownButton: TSpeedButton;
    ProxmitySpeedButton: TSpeedButton;
    SaveSpeedButton: TSpeedButton;
    MapLabelRadioGroup: TRadioGroup;
    ShowImageLayerCheckBox: TCheckBox;
    LayersTabSheet: TTabSheet;
    LayersCheckListBox: TCheckListBox;
    Panel4: TPanel;
    CloseButton: TBitBtn;
    MapInfoFormSynchronizeTimer: TTimer;
    SelectedLayerDeleteTimer: TTimer;
    CopyToClipboardSpeedButton: TSpeedButton;
    ParcelListReportFiler: TReportFiler;
    ParcelListReportPrinter: TReportPrinter;
    ModeRadioGroup: TRadioGroup;
    MapCondoTable: TTable;

    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CloseButtonClick(Sender: TObject);
    procedure MapAfterLayerDraw(Sender: TObject; index: Smallint;
      canceled: WordBool; hDC: Cardinal);
    procedure MapMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ReportPrint(Sender: TObject);
    procedure MapTimerTimer(Sender: TObject);
    procedure SBZoomOutClick(Sender: TObject);
    procedure SBZoomInClick(Sender: TObject);
    procedure PanButtonClick(Sender: TObject);
    procedure MapMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure MapLabelRadioGroupClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure PrintMapButtonClick(Sender: TObject);
    procedure ProxmitySpeedButtonClick(Sender: TObject);
    procedure ReportPrintHeader(Sender: TObject);
    procedure FlashShapeTimerTimer(Sender: TObject);
    procedure SaveSpeedButtonClick(Sender: TObject);
    procedure ShowImageLayerCheckBoxClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure LayersCheckListBoxMouseMove(Sender: TObject;
      Shift: TShiftState; X, Y: Integer);
    procedure LayersCheckListBoxClickCheck(Sender: TObject);
    procedure MapInfoFormSynchronizeTimerTimer(Sender: TObject);
    procedure SelectedLayerDeleteTimerTimer(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure CopyToClipboardSpeedButtonClick(Sender: TObject);
    procedure ParcelListReportPrintHeader(Sender: TObject);
    procedure ParcelListReportPrint(Sender: TObject);
    procedure ModeRadioGroupClick(Sender: TObject);

  protected
    procedure CreateParams(var Params: TCreateParams); override;
  public
    { public declarations }
    UnitName : String;  {For use with error dialog box.}
    MapInfoFormList : TStringList;

      {These will be set in the ParcelTabForm.}

    AssessmentYear, SwisSBLKey : String;
    SelectDistance : Boolean;
    CurrentlySelectedList : TStringList;

    FormIsInitializing : Boolean;  {Is the form being initialized right now?}
    ClosingForm : Boolean;  {Are we closing a form right now?}

    dc : IMoDataConnection;
    MainLayer : IMoMapLayer;
    MapSetupObject : TMapSetupObject;
    MainParcelPolygon : IMoPolygon;
    LabelDisplayType : Integer;
    LabelsShowing, CurrentlyPrinting : Boolean;
    ProximitySubjectSwisSBLKey : String;

      {Label variables}

    LabelOptions : TLabelOptions;
    ShowImageLayer : Boolean;
    MainLayerFileName, MainLayerLocation,
    SelectedLayerFileName, SelectedLayerLocation : String;
    SelectedLayerDc : IMoDataConnection;
    SelectedLayer : IMoMapLayer;
    FullSizeRect : IMoRectangle;
    DefaultFillColor : TColor;
    DefaultFillStyle : Integer;
    HasImageLayer, InitialMapDisplay : Boolean;
    MainLayerName : String;
    CurrentLayerItem : Integer;
    ImageLayer : IMoImageLayer;
    LoadingLayers : Boolean;
    SelectedLayerToDelete : String;
    CurrentMouseMode : CurrentMouseModeSetType;
    ProcessingType : Integer;
    CondominiumUnitList : TStringList;
    OnlyBaseCondominiumParcelIdIsEncoded : Boolean;

    Procedure InitializeForm;  {Open the tables and setup.}
    Procedure PrintOutCurrentlySelectedList;
    Procedure AddSelectedParcelLayer;
    Procedure DeleteSelectedLayerGeoDataset;
    Procedure RefreshSelectedLayer;
    Procedure ClearSelectedInformation(AddNewLayer : Boolean);
    Procedure AddItemToSelectedLayer(P : IMoPolygon;
                                     ParcelID : String;
                                     AlternateLabel : String;
                                     AlternateLabelColor : TColor;
                                     FillStyle : Integer;
                                     FillColor : TColor;
                                     UseAltLabel : Boolean);
    Procedure RemoveItemFromSelectedLayer(P : IMoPolygon;
                                          ParcelID : String);

  end;    {end form object definition}

implementation

uses GlblVars, WinUtils, PASUTILS, UTILEXSD,  Utilitys,
     GlblCnst, MapParcelInfoDialog, Preview, DataAccessUnit,
     MapProximitySelectUnit,
     MapPrintDialogUnit,
     MapPrintTypeDialogUnit,
     MapLabelOptionsDialogUnit;

{$R *.DFM}

const
  lbParcelID  = 0;
  lbOwnerName = 1;
  lbLegalAddress = 2;
  lbAccountNumber = 3;
  lbNone = 4;

{=====================================================================}
Procedure TMapForm.CreateParams(var Params: TCreateParams);

begin
 inherited CreateParams(Params);

  with Params do
    begin
      WndParent := Application.Mainform.Handle;
      Style := (Style or WS_Child) and not WS_Popup;
    end;

end;  {CreateParams}

{=====================================================================}
Procedure TMapForm.FormResize(Sender: TObject);

begin
  If not FormIsInitializing
    then
      begin
        LocationLabel.Left := HeaderPanel.Width - 218;
        EditLocation.Left := HeaderPanel.Width - 166;

        EditName.Left := (HeaderPanel.Width - EditName.Width) DIV 2;
        OwnerLabel.Left := EditName.Left - 35;

      end;  {If not FormIsInitializing}

end;  {FormResize}

{====================================================================}
Procedure TMapForm.InitializeForm;

{This procedure opens the tables for this form and synchronizes
 them to this parcel. Also, we set the title and year
 labels.

 Note that this code is in this seperate procedure rather
 than any of the OnShow events so that we could have
 complete control over when this procedure is run.
 The problem with any of the OnShow events is that when
 the form is created, they are called, but it is not possible to
 have the SwisSBLKey, etc. set.
 This way, we can call InitializeForm after we know that
 the SwisSBLKey, etc. has been set.}

var
  Found : Boolean;

begin
  HasImageLayer := False;
  LabelsShowing := False;
  UnitName := 'PMAP';  {mmm1}
  ClosingForm := False;
  FormIsInitializing := True;
  MapInfoFormList := TStringList.Create;
  LabelDisplayType := lbParcelID;
  CurrentlyPrinting := False;
  ProcessingType := GetProcessingTypeForTaxRollYear(AssessmentYear);

  If (Deblank(SwisSBLKey) <> '')
    then
      begin
        OpenTablesForForm(Self, NextYear);
        AssessmentYear := GlblNextYear;

          {First let's find this parcel in the parcel table.}

        Found := _Locate(ParcelTable, [AssessmentYear, SwisSBLKey], '', [loParseSwisSBLKey]);

        If not Found
          then SystemSupport(005, ParcelTable, 'Error finding key in parcel table.', UnitName, GlblErrorDlgBox);

        TitleLabel.Left := (Panel1.Width - TitleLabel.Width) DIV 2;

          {Set the location label.}

        EditLocation.Text := GetLegalAddressFromTable(ParcelTable);
        EditSBL.Text := ConvertSwisSBLToDashDot(SwisSBLKey);
        SetTaxYearLabelForProcessingType(YearLabel, GlblProcessingType);

          {FXX12101997-1: Make sure that all pages have the inactive label.}

        If (ParcelTable.FieldByName('ActiveFlag').Text = InactiveParcelFlag)
          then InactiveLabel.Visible := True;

      end;  {If (Deblank(SwisSBLKey) <> '')}

  DefaultFillStyle := moUpwardDiagonalFill;
  DefaultFillColor := moGreen;

    {CHG10062003-1: Allow for a different parcel ID format in order to accomodate
                    different IDs coming from the map source file.}

  try
    MapParcelIDFormatTable.TableName := 'mapparcelidtable';
    MapParcelIDFormatTable.Open;
  except
    MapParcelIDFormatTable.TableName := '';
  end;

  SelectedLayerDc := IMoDataConnection(CreateOleObject('MapObjects2.DataConnection'));

  LoadingLayers := True;
  LoadLayersIntoLayerBox(LayersCheckListBox,
                         GlblSearcherMapDefault,
                         MapLayersAvailableTable,
                         MappingDetailTable);
  LoadingLayers := False;

  CurrentMouseMode := [msIdentifyParcel];
  InitialMapDisplay := True;
  ShowImageLayer := False;
  FormIsInitializing := False;
  MapTimer.Enabled := True;
  SelectDistance := False;
  CurrentlySelectedList := TStringList.Create;

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

    {CHG11162004-7(2.8.0.21): Option to make the close button locate.}

  If GlblCloseButtonIsLocate
    then MakeCloseButtonLocate(CloseButton);

end;  {InitializeForm}

{=============================================================}
Procedure TMapForm.FormActivate(Sender: TObject);

{Solve a refresh problem.}

begin
  If not FormIsInitializing
    then
      begin
        Map.Visible := False;
        Map.Visible := True;
      end;

end;  {FormActivate}

{==========================================================================}
Procedure TMapForm.AddSelectedParcelLayer;

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

            {CHG03012004-1(2.07l2): Allow for searchers to create selected layers locally.}
            {CHG08032004-2(2.08.0.08042004): Allow for all users to create selected layers locally.}

          If (GlblAllUsersCreatesSelectedMapLayerLocally or
              (GlblSearcherCreatesSelectedMapLayerLocally and
               GlblUserIsSearcher))
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
      Symbol.Style     := DefaultFillStyle;
      Symbol.Color     := DefaultFillColor;
      Tag := SelectedLayerFileName;

    end;  {with SelectedLayer do}

  //add to the window
  Map.Layers.Add(SelectedLayer);

end;  {AddSelectedParcelLayer}

{==========================================================================}
Procedure TMapForm.SelectedLayerDeleteTimerTimer(Sender: TObject);

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
          SysUtils.DeleteFile(SelectedLayerLocation + SearchRec.Name);
        except
        end;

  until Done;

end;  {SelectedLayerDeleteTimerTimer}

{==========================================================================}
Procedure TMapForm.DeleteSelectedLayerGeoDataset;

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

end;  {DeleteSelectedLayerGeoDataset}

{==========================================================================}
Procedure TMapForm.ClearSelectedInformation(AddNewLayer : Boolean);

{Clear the selected list and layer.}

begin
  CurrentlySelectedList.Clear;

  SelectedLayerDc.Disconnect;
  DeleteSelectedLayerGeoDataset;

  FullSizeRect := IMoRectangle(CreateOleObject('MapObjects2.Rectangle'));
  FullSizeRect := Map.FullExtent;

  If AddNewLayer
    then AddSelectedParcelLayer;

end;  {ClearSelectedLayer}

{==========================================================================}
Procedure TMapForm.RefreshSelectedLayer;

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
Procedure TMapForm.AddItemToSelectedLayer(P : IMoPolygon;
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
Procedure TMapForm.RemoveItemFromSelectedLayer(P : IMoPolygon;
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

{=============================================================}
Procedure TMapForm.MapTimerTimer(Sender: TObject);

var
  recs : IMoRecordset;
  tdesc: IMoTableDesc;
  fld : IMoField;
  flds : IMoFields;
  shapebounds : IMoRectangle;
  TempStr, LayerName, TempSwisSBLKey : String;
  I : Integer;
  FullSizeRect : IMoRectangle;

begin
  MapTimer.Enabled := False;

  If InitialMapDisplay
    then
      begin
        MapSetupObject := TMapSetupObject.Create;
        MainParcelPolygon := IMoPolygon(CreateOleObject('MapObjects2.Polygon'));

        SetMapOptions(GlblSearcherMapDefault, False,
                      MappingHeaderTable, MappingDetailTable,
                      MapLayersAvailableTable, MapParcelIDFormatTable, MapSetupObject);

        ParcelLookupTable.IndexName := MapSetupObject.PASIndex;

          {CHG03222003-1(2.06q1): Support for image layers.}
          {If there is an image layer in this set up, set it to not automatically show
           and then show a check box allowing them to turn it on.}

        For I := 0 to (MapSetupObject.GetLayerCount - 1) do
          begin
            LayerName := MapSetupObject.GetLayerName(I);

            If (MapSetupObject.GetLayerType(LayerName) = ltMRSID)
              then
                begin
                  ShowImageLayerCheckBox.Visible := True;
                  HasImageLayer := True;

                  If MapSetupObject.MapLayerIsVisible(MapSetupObject.GetLayerName(I))
                    then MapSetupObject.SetLayerVisible(LayerName, False);

                end;  {If (MapSetupObject.GetLayerType(LayerName) = ltMRSID)}

          end;  {For I := 0 to (MapSetupObject.GetLayerCount - 1) do}

      end;  {If InitialMapDisplay}

  DisplayAutoLoadLayers(MapSetupObject, Map,
                        MainLayer, ImageLayer, MainLayerName,
                        MainLayerFileName, MainLayerLocation, ShowImageLayer, HasImageLayer);

  AddSelectedParcelLayer;

    {Now zoom to the parcel in question.}

  TempStr := MapSetupObject.MapFileKeyField + ' = ''' +
             ConvertPASKeyFieldToMapKeyField(ParcelTable, MapParcelIDFormatTable,
                                             AssessmentYearControlTable, SwisSBLKey,
                                             AssessmentYear, MapSetupObject, False) +
             '''';

  recs := MainLayer.SearchExpression(TempStr);

  If recs.eof
    then
      begin
          {FXX05032005-2(M1.5): If the swis SBL was not found, and they have condos,
                                this may be a condo unit, so strip off the sublot and
                                suffix and check the map condo table.
                                If it exists in the table, then look up via the base lot.}

        If OnlyBaseCondominiumParcelIdIsEncoded
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

            end;  {If OnlyBaseCondominiumParcelIdIsEncoded}

      end;  {If recs.eof}

  If not Recs.EOF
    then
      begin
          //clear out the existing info

        tdesc := IMoTableDesc(CreateOleObject('MapObjects2.TableDesc'));
        tdesc := recs.TableDesc;
        flds := recs.Fields;

        recs.MoveFirst;

        fld := recs.Fields.item('Shape');

        MainParcelPolygon := IMoPolygon(IDispatch(fld.value));
        CurrentlySelectedList.Clear;
        CurrentlySelectedList.Add(SwisSBLKey);
        AddItemToSelectedLayer(MainParcelPolygon, ExtractSSKey(ParcelLookupTable), '', moBlue,
                               moCrossFill, moRed, False);

        shapeBounds := MainParcelPolygon.Extent;
        Map.Extent := ShapeBounds;
        SBZoomOutClick(Sender);
        SBZoomOutClick(Sender);

        FlashShapeTimer.Enabled := True;

      end;  {If not recs.eof}

    {CHG01162005-3(2.8.3.1)[1999]: Add option to select parcels to the map tab.}

  ModeRadioGroup.Visible := not ShowImageLayerCheckBox.Visible;

  FullSizeRect := IMoRectangle(CreateOleObject('MapObjects2.Rectangle'));
  FullSizeRect := Map.Extent;
  Map.Visible := False;
  Map.Visible := True;
  InitialMapDisplay := False;
  MapInfoFormSynchronizeTimer.Enabled := True;

end;  {MapTimerTimer}

{========================================================}
Procedure TMapForm.ShowImageLayerCheckBoxClick(Sender: TObject);

{Do not automatically display the image layer.  If they turn the image layer on,
 then remove all other layers and display the image layer first.  Otherwise, remove them
 all and redisplay.}

var
  I : Integer;
  LayerName : String;
  
begin
  For I := (Map.Layers.Count - 1) downto 0 do
    Map.Layers.Remove(I);

  MainLayer := nil;
  MainLayerFileName := '';
  MainLayerLocation := '';

  ShowImageLayer := ShowImageLayerCheckBox.Checked;

    {Set the orthographic layer to visible or not depending on the click.}

  For I := 0 to (MapSetupObject.GetLayerCount - 1) do
    begin
      LayerName := MapSetupObject.GetLayerName(I);

      If (MapSetupObject.GetLayerType(LayerName) = ltMRSID)
        then MapSetupObject.SetLayerVisible(LayerName, ShowImageLayer);

    end;  {For I := 0 to (MapSetupObject.GetLayerCount - 1) do}

  MapTimerTimer(Sender);

end;  {ShowImageLayerCheckBoxClick}

{========================================================}
Procedure TMapForm.FlashShapeTimerTimer(Sender: TObject);

begin
  FlashShapeTimer.Enabled := False;
  Map.FlashShape(MainParcelPolygon, 3);
end;

{===================================================================}
Procedure TMapForm.SBZoomOutClick(Sender: TObject);

var
  ZoomOutRect : IMoRectangle;

begin
  ZoomOutRect := IMoRectangle(CreateOleObject('MapObjects2.Rectangle'));
  ZoomOutRect := Map.Extent;
  ZoomOutRect.ScaleRectangle(variant(1.5));
  Map.Extent := ZoomOutRect;
  Map.RefreshRect(ZoomOutRect);
  Map.Visible := False;
  Map.Visible := True;

end;  {SBZoomOutClick}

{===================================================================}
Procedure TMapForm.SBZoomInClick(Sender: TObject);

var
  ZoomInRect : IMoRectangle;

begin
  ZoomInRect := IMoRectangle(CreateOleObject('MapObjects2.Rectangle'));
  ZoomInRect := Map.Extent;
  ZoomInRect.ScaleRectangle(variant(0.5));
  Map.Extent := ZoomInrect;
  Map.Visible := False;
  Map.Visible := True;

end;  {SBZoomInClick}

{=============================================================}
Procedure TMapForm.PanButtonClick(Sender: TObject);

var
  PanRect : IMoRectangle;

begin
  PanRect := IMoRectangle(CreateOleObject('MapObjects2.Rectangle'));
  PanRect := Map.Extent;

  with PanRect do
    begin
      If (Pos('Up', TSpeedButton(Sender).Name) > 0)
        then
          begin
            Bottom := Bottom + 100;
            Top := Top + 100;
          end;

      If (Pos('Right', TSpeedButton(Sender).Name) > 0)
        then
          begin
            Left := Left + 100;
            Right := Right + 100;
          end;

      If (Pos('Down', TSpeedButton(Sender).Name) > 0)
        then
          begin
            Top := Top - 100;
            Bottom := Bottom - 100;
          end;

      If (Pos('Left', TSpeedButton(Sender).Name) > 0)
        then
          begin
            Left := Left - 100;
            Right := Right - 100;
          end;

    end;  {with PanRect, TSpeedButton(Sender) do}

  Map.Extent := PanRect;
  Map.Refresh;
  Map.Visible := False;
  Map.Visible := True;

end;  {PanButtonClick}

{=============================================================}
Procedure TMapForm.CopyToClipboardSpeedButtonClick(Sender: TObject);

{CHG09092004-1(2.8.0.11): Copy the current view to the clipboard.}

begin
  try
    Map.CopyMap(10);
  except
  end;

end;  {CopyToClipboardSpeedButtonClick}

{=============================================================}
Procedure TMapForm.ReportPrintHeader(Sender: TObject);

begin
  PrintLabelHeader(Sender, LabelOptions);

end;  {ReportPrintHeader}

{=============================================================}
Procedure TMapForm.ReportPrint(Sender: TObject);

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

{===================================================================}
Procedure TMapForm.PrintOutCurrentlySelectedList;

var
  NewFileName : String;
  TempFile : TextFile;

begin
  If PrintDialog.Execute
    then
      If PrintDialog.PrintToFile
        then
          begin
            NewFileName := GetPrintFileName(Self.Caption, True);
            GlblPreviewPrint := True;
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

end;  {PrintOutCurrentlySelectedList}

{===============================================}
Procedure TMapForm.MapAfterLayerDraw(Sender: TObject;
                                     index: Smallint;
                                     canceled: WordBool;
                                     hDC: Cardinal);
var
  recs : IMoRecordset;
  fld  : IMoField;
  p : IMoPolygon;
  CurrentRect : IMoRectangle;
  tsym   : IMoTextSymbol;
  ft    : TFont;
  oleFt : variant;
  CurrentZoomPercent : Double;
  TextBaseLine : IMoLine;
  Point : IMoPoint;
  Points : IMoPoints;
  IsCondoBuilding, _Found : Boolean;
  TempStr, SwisSBLKey, sValue : String;
  I, MainLayerIndex, SelectedLayerIndex : Integer;
  MapLayer : IMoMapLayer;
  sym   : IMoSymbol;
  BaseLineLength : Extended;

begin
  MainLayerIndex := 0;
  SelectedLayerIndex := 0;

  For I := (Map.Layers.Count - 1) downto 0 do
    begin
      MapLayer := IMoMapLayer(Map.Layers.Item(I));

      If (ANSIUpperCase(MapLayer.Tag) = ANSIUpperCase(MainLayerName))
        then MainLayerIndex := I;

      If (ANSIUpperCase(MapLayer.Tag) = ANSIUpperCase(SelectedLayerFileName))
        then SelectedLayerIndex := I;

    end;  {For I := 0 to (Map.Layers.Count - 1) do}

  with Map do
    CurrentZoomPercent := Extent.Height / FullExtent.Height;
  LabelsShowing := False;

  If ((not CurrentlyPrinting) and
      (Index = MainLayerIndex) and
      (CurrentZoomPercent < MapSetupObject.DefaultZoomPercentToDrawDetails) and
      (LabelDisplayType <> lbNone))
    then
      begin
        LabelsShowing := True;
        CurrentRect := IMoRectangle(CreateOleObject('MapObjects2.Rectangle'));
        CurrentRect := Map.Extent;

        ft := TFont.Create;
        ft.Name := 'Times New Roman';
        ft.size := 8;
        oleFt := FontToOleFont(ft);

        recs := MainLayer.SearchShape(CurrentRect, moAreaIntersect, '');
        recs.MoveFirst;

        while not Recs.EOF do
          begin
            fld := recs.Fields.item('Shape');
            p := IMoPolygon(CreateOleObject('MapObjects2.Polygon'));
            p :=IMoPolygon(IDispatch(fld.value));
            Point := IMoPoint(CreateOleObject('MapObjects2.Point'));
            Points := IMoPoints(CreateOleObject('MapObjects2.Points'));

            TextBaseLine := IMoLine(CreateOleObject('MapObjects2.Line'));

            BaseLineLength := DetermineLabelBaseline(P, TextBaseLine);

            tsym :=IMoTextSymbol(CreateOleObject('MapObjects2.TextSymbol'));

            tsym.color := MapSetupObject.LabelColor;
            tsym.HorizontalAlignment := moAlignLeft;
            tsym.VerticalAlignment := moAlignCenter;
            tsym.Font := IFontDisp(IDispatch(oleFt));
            tsym.Height := GetSymbolHeight(BaseLineLength, TempStr);

              {FXX07072008-1(2.13.1.23)[D1300]: Inactive parcels don't count for lookups.}

            try
              sValue := Recs.Fields.Item(MapSetupObject.MapFileKeyField).Value;
            except
              sValue := '';
            end;

            _Found := (FindParcelForMapRecord(ParcelLookupTable,
                                             MapParcelIDFormatTable, AssessmentYearControlTable,
                                             MapSetupObject,
                                             sValue,
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

            If IsCondoBuilding
              then
                case LabelDisplayType of
                  lbParcelID : TempStr := 'Condo: ' + ConvertSBLOnlyToDashDot(Copy(SwisSBLKey, 7, 20));
                  lbOwnerName : TempStr := MapCondoTable.FieldByName('CondoName').Text;
                  else TempStr := '';
                end
              else
                case LabelDisplayType of
                  lbParcelID : TempStr := ConvertSwisSBLToDashDot(ExtractSSKey(ParcelLookupTable));
                  lbOwnerName : TempStr := ParcelLookupTable.FieldByName('Name1').Text;
                  lbLegalAddress : TempStr := GetLegalAddressFromTable(ParcelLookupTable);
                  lbAccountNumber : TempStr := ParcelLookupTable.FieldByName('AccountNo').Text;

                end;  {case LabelDisplayType of}

            If _Found
              then
                try
                  Map.DrawText(TempStr, TextBaseLine, tsym);
                except
                end;

            recs.MoveNext;

          end;  {while not Recs.EOF do}

      end;  {If (CurrentZoomPercent < 0.01)}

    {If this is the selected layer, draw the information.}

  If ((not GlblDialogBoxShowing) and
      (Index = SelectedLayerIndex))
    then
      begin
        CurrentRect := IMoRectangle(CreateOleObject('MapObjects2.Rectangle'));
        CurrentRect := Map.Extent;

        ft := TFont.Create;
        ft.Name := 'Times New Roman';
        ft.size := 8;
        ft.Style := [fsBold];
        oleFt := FontToOleFont(ft);

        try
          recs := SelectedLayer.SearchShape(CurrentRect, moAreaIntersect, '');
          recs.MoveFirst;

          while not Recs.EOF do
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
                    tsym.Font := IFontDisp(IDispatch(oleFt));
                    TempStr := Recs.Fields.Item('AltLabel').Value;
                    tsym.Height := GetSymbolHeight(BaseLineLength, TempStr);

                    sym :=IMoSymbol(CreateOleObject('MapObjects2.Symbol'));
                    sym.Style := Recs.Fields.Item('Fill').Value;
                    sym.color := Recs.Fields.Item('Color').Value;

                    Map.DrawShape(p, sym);

                    try
                      Map.DrawText(TempStr, TextBaseLine, tsym);
                    except
                    end;

                  end;  {If SelectedRecs.EOF}

              recs.MoveNext;

            end;  {while not Recs.EOF do}

          except
          end;

      end;  {If ((not GlblDialogBoxShowing) and ...}

end;  {MapAfterLayerDraw}

{===============================================}
Procedure TMapForm.ModeRadioGroupClick(Sender: TObject);

begin
  case ModeRadioGroup.ItemIndex of
    0 : CurrentMouseMode := [msIdentifyParcel];
    1 : CurrentMouseMode := [msSelectParcel];
  end;

end;

{===============================================}
Procedure TMapForm.MapMouseDown(Sender: TObject;
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
                                                 DefaultFillStyle, DefaultFillColor, False);
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

end;  {MapMouseDown}

{===============================================}
Procedure TMapForm.MapMouseMove(Sender: TObject;
                                Shift: TShiftState;
                                X, Y: Integer);

var
  P : IMoPoint;
  recs : IMoRecordset;
  _Found : Boolean;
  FieldName : OLEVariant;
  TempStr, SwisSBLKey : String;

begin
  If ((MapSetupObject <> nil) and
      (MainLayer <> nil) and
      (not FormIsInitializing))
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
                then TempStr := 'Current Parcel: ' +
                                ConvertSwisSBLToDashDot(ExtractSSKey(ParcelLookupTable)) + '  ' +
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

              StatusBar.Panels[0].Text := TempStr;

            end;  {If not Recs.EOF}

      end;  {If (MapSetupObject <> nil)}

end;  {MapMouseMove}

{===============================================}
Procedure TMapForm.MapInfoFormSynchronizeTimerTimer(Sender: TObject);

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

{===============================================}
Procedure TMapForm.MapLabelRadioGroupClick(Sender: TObject);

begin
  LabelDisplayType := MapLabelRadioGroup.ItemIndex;
  Map.RefreshRect(Map.Extent);

end;  {MapLabelRadioGroupClick}

{===============================================}
Procedure TMapForm.LayersCheckListBoxMouseMove(Sender: TObject;
                                               Shift: TShiftState;
                                               X, Y: Integer);

var
  Point : TPoint;

begin
  Point.X := X;
  Point.Y := Y;
  CurrentLayerItem := LayersCheckListBox.ItemAtPos(Point, True);

end;  {LayersCheckListBoxMouseMove}

{===============================================}
Procedure TMapForm.LayersCheckListBoxClickCheck(Sender: TObject);

var
  I : Integer;
  MapLayer : IMoMapLayer;

begin
  If not LoadingLayers
    then
      If (CurrentLayerItem <> -1)
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

{===============================================}
Procedure TMapForm.ParcelListReportPrintHeader(Sender: TObject);

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

{===============================================}
Procedure TMapForm.ParcelListReportPrint(Sender: TObject);

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

(*  with Sender as TBaseReport do
    For I := 0 to (CurrentlySelectedList.Count - 1) do
      begin
        SwisSBLKey := CurrentlySelectedList[I];
        SBLRec := ExtractSwisSBLFromSwisSBLKey(SwisSBLKey);

        with SBLRec do
          FindKeyOld(ParcelLookupTable2,
                     ['AssessmentYear', 'SwisCode', 'Section',
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


      end;  {For I := 0 to (CurrentlySelectedList.Count - 1) do} *)

end;  {ParcelListReportPrint}

{===============================================}
Procedure TMapForm.PrintMapButtonClick(Sender: TObject);

{CHG01162005-2(2.8.3.1)[2031]: Make the print from the map tab the same as on the big map.}

var
  NewFileName, TempDirectory : String;
  TempFile : TextFile;
  Quit, OtherItemPrinted : Boolean;

begin
(*  NewFileName := GetPrintFileName('MAP', True);
  Map.ExportMap2(moExportBMP, NewFileName, 2, True);
  ExecuteMapPrintDialog(NewFileName); *)

  OtherItemPrinted := False;

    {FXX11202002-1: Fix up the printing.}
    {First export a copy of this map so that it can be printed.
     If we do not we will lose it because of redrawing issues.}
    {Also have option to print a parcel list.}
    {CHG07172005-1(2.8.5.6): Create the map bitmap for printing locally if this is a searcher.}

  NewFileName := GetPrintFileName('MAP', True);

  If (GlblAllUsersCreatesSelectedMapLayerLocally or
      (GlblSearcherCreatesSelectedMapLayerLocally and
       GlblUserIsSearcher))
    then
      begin
        NewFileName[1] := 'C';
        TempDirectory := ReturnPath(NewFileName);

        If not DirectoryExists(TempDirectory)
          then ForceDirectories(TempDirectory);

      end;  {If GlblSearcherCreatesSelectedMapLayerLocally}

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

  Map.Enabled := False;
  Map.Enabled := True;

end;  {PrintMapButtonClick}

{===============================================}
Procedure TMapForm.ProxmitySpeedButtonClick(Sender: TObject);

var
  recs : IMoRecordset;
  Distance : Double;
  CurrentParcelShape, Polygon : IMoPolygon;
  FirstTimeThrough, CondoFound, ParcelFound : Boolean;
  NewExtentRect : IMoRectangle;
  TempStr, NewFileName, TempSwisSBLKey : String;
  NumSelected : LongInt;
  TempFile : TextFile;
  ProximitySwisSBLKeyList : TStringList;

begin
  GlblDialogBoxShowing := True;
  ProximitySwisSBLKeyList := TStringList.Create;
  NumSelected := 0;

  try
    MapProximitySelectDialog := TMapProximitySelectDialog.Create(nil);

    MapProximitySelectDialog.SwisSBLKey := SwisSBLKey;
    MapProximitySelectDialog.LocateButton.Visible := False;
    MapProximitySelectDialog.UseAlreadySelectedParcelsCheckBox.Visible := False;

    If (MapProximitySelectDialog.ShowModal = mrOK)
      then
        begin
          CondominiumUnitList.Clear;
          ProximitySubjectSwisSBLKey := MapProximitySelectDialog.SwisSBLKey;
          Distance := MapProximitySelectDialog.ProximityRadius;

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
                ClearSelectedInformation(True);
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

          try
            case MapProximitySelectDialog.ProximityType of
              ptPerimeter : recs := MainLayer.SearchByDistance(CurrentParcelShape, Distance, '');
              ptCentroid : recs := MainLayer.SearchByDistance(CurrentParcelShape.Centroid, Distance, '');
            end;
          except
          end;

          recs.MoveFirst;
          FirstTimeThrough := True;

          while not Recs.EOF do
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
                                                  DefaultFillStyle, DefaultFillColor, False);

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

          StatusBar.Panels[0].Text := IntToStr(NumSelected) + ' parcels within ' +
                                      FormatFloat(DecimalEditDisplay, Distance) +
                                      ' feet.';

          GlblDialogBoxShowing := False;
          Map.Extent := NewExtentRect;
          Map.Refresh;

        end;  {If (MapProximitySelectDialog.ShowModal = mrOK)}

  finally
    MapProximitySelectDialog.Free;
  end;

end;  {ProxmitySpeedButtonClick}

{===============================================}
Procedure TMapForm.SaveSpeedButtonClick(Sender: TObject);

var
  ParcelID : String;

begin
  ParcelID := ConvertSBLOnlyToDashDot(Copy(SwisSBLKey, 7, 20));
  ParcelID := StringReplace(ParcelID, '/', '-', [rfReplaceAll]);

  SaveDialog.FileName := 'Parcel Map for ' + ParcelID + ' .bmp';

  If SaveDialog.Execute
    then Map.ExportMap(moExportBMP, SaveDialog.FileName, 2);

end;  {SaveSpeedButtonClick}

{===============================================}
Procedure TMapForm.CloseButtonClick(Sender: TObject);

{Note that the close button is a close for the whole
 parcel maintenance.}

{To close the whole parcel maintenance, we will once again use
 the base popup menu. We will simulate a click on the
 "Exit Parcel Maintenance" of the BasePopupMenu which will
 then call the Close of ParcelTabForm. See the locate button
 click above for more information on how this works.}

var
  I : Integer;

begin
    {Search for the name of the menu item that has "Exit"
     in it, and click it.}

  For I := 0 to (PopupMenu.Items.Count - 1) do
    If (Pos('Exit', PopupMenu.Items[I].Name) <> 0)
      then PopupMenu.Items[I].Click;

end;  {CloseButtonClick}

{====================================================================}
Procedure TMapForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);

begin
  SelectedLayerDc.Disconnect;
  Map.Layers.Clear;
  SelectedLayerDc._Release;
  DeleteSelectedLayerGeoDataset;

end;  {FormCloseQuery}

{====================================================================}
Procedure TMapForm.FormClose(    Sender: TObject;
                             var Action: TCloseAction);

var
  I : Integer;
  TempSelectedLayerCommandLine : String;
  SelectedLayerPChar : PChar;
  TempLen : Integer;

begin
  ClearSelectedInformation(False);

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

    {Reset parcel IDs.}

  If MapParcelIDFormatTable.Active
    then SetGlobalSBLSegmentFormats(AssessmentYearControlTable);

  CurrentlySelectedList.Free;
  CondominiumUnitList.Free;

  For I := 0 to (MapInfoFormList.Count - 1) do
    try
      TForm(MapInfoFormList[I]).Free;
    except
    end;

  MapSetupObject.Free;

    {Close all tables here.}

  CloseTablesForForm(Self);

  Action := caFree;

end;  {FormClose}


end.