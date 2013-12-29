unit MapUtilitys;

interface

uses Types, PASTypes, PASUtils, Utilitys, WinUtils,
     Windows, Messages, SysUtils, Classes, Controls, Forms, Dialogs,
     DB, DBTables, MapSetupObjectType, Checklst, StdCtrls, ExtCtrls,
     MapObjects2_TLB, ComObj, ActiveX, GlblCnst, Graphics, GlblVars,
     DataAccessUnit;

Function GetParcelIDFromMapFile(MapParcelID : String;
                                MapSetupObject : TMapSetupObject) : SBLRecord;

Function FindParcelForMapRecord(ParcelLookupTable : TTable;
                                MapParcelIDFormatTable : TTable;
                                AssessmentYearControlTable : TTable;
                                MapSetupObject : TMapSetupObject;
                                FieldValue : String;
                                AssessmentYear : String) : Boolean;

Procedure SetMapOptions(MappingSetupName : String;
                        DefaultSetup : Boolean;
                        MappingHeaderTable,
                        MappingDetailTable,
                        MapLayersAvailableTable,
                        MapParcelIDFormatTable : TTable;
                        MapSetupObject : TMapSetupObject);

Function ConvertPASKeyFieldToMapKeyField(ParcelTable : TTable;
                                         MapParcelIDFormatTable : TTable;
                                         AssessmentYearControlTable : TTable;
                                         SwisSBLKey : String;
                                         AssessmentYear : String;
                                         MapSetupObject : TMapSetupObject;
                                         ConvertIfNotLocated : Boolean) : String;

Procedure LoadLayersIntoLayerBox(LayersCheckListBox : TCheckListBox;
                                 MappingSetupName : String;
                                 MapLayersAvailableTable,
                                 MappingDetailTable : TTable);

Procedure LoadLayersIntoLayerListBox(LayersListBox : TListBox;
                                     MapLayersAvailableTable,
                                     MappingDetailTable : TTable;
                                     InactiveOnly : Boolean);

Function AddOneLayer(    LayerName : String;
                     var MainLayer : IMoMapLayer;
                         MapSetupObject : TMapSetupObject;
                         Map : TMap) : IMOMapLayer;

Procedure DisplayAutoLoadLayers(    MapSetupObject : TMapSetupObject;
                                    Map : TMap;
                                var MainLayer : IMoMapLayer;
                                    ImageLayer : IMoImageLayer;
                                var MainLayerName : String;
                                var MainLayerFileName : String;
                                var MainLayerLocation : String;
                                    LoadOrthographicLayer : Boolean;
                                var HasImageLayer : Boolean);

Function GetLayerTypePrefix(LayerType : String) : String;

Function DetermineLabelBaseline(Polygon : IMoPolygon;
                                TextBaseLine : IMoLine) : Extended;

Function MapExtentsSame(Extent1 : IMORectangle;
                        Extent2 : IMORectangle) : Boolean;

Procedure FillInMapRangeList(MapRangeList : TList;
                             MapRangeRec : MapRangeRecord;
                             RangeType : Integer;
                             IntegerValuesOnly : Boolean;
                             SelectedCodesList : TStringList);

Function FindRangeColorForValue(    MapRangeList : TList;
                                    Value : String;
                                    Numeric : Boolean;
                                    DefaultColor : TColor;
                                var ValueInRange : Boolean) : LongInt;

Function ParcelMeetsLegalAddressCriteria(ParcelTable : TTable;
                                         LegalAddress,
                                         LegalAddressNumberStart,
                                         LegalAddressNumberEnd : String;
                                         AllLegalAddressNumbers,
                                         ToEndOfLegalAddressNumbers : Boolean) : Boolean;

Function GetSymbolHeight(BaseLineLength : Extended;
                         TempStr : String) : Extended;

Function FindCondominium(MapCondoTable : TTable;
                         SwisSBLKey : String) : Boolean;

Function FindCondominiumForMapRecord(MapCondoTable : TTable;
                                     MapSetupObject : TMapSetupObject;
                                     FieldValue : String) : Boolean;

Procedure AddCondoUnitsToListForBaseCondoID(ParcelTable : TTable;
                                            BaseSwisSBLKey : String;
                                            AssessmentYear : String;
                                            CondominiumUnitList : TStringList);

Function GetAV_SP_DecimalDisplayFormat(MapSetupObject : TMapSetupObject) : String;

Function GetScale(    Form : TForm;
                      CurrentRect : IMoRectangle;
                      Map : TMap;
                  var ScaleX : Extended;
                  var ScaleY : Extended) : Extended;

type
  CurrentMouseModeSetType = set of (msZoomRectangle, msIdentifyParcel,
                                    msSelectParcel, msDistanceMeasure,
                                    msModifyParcel);

implementation

uses MapLabelOptionsDialogUnit;

{==========================================================================}
Function ConvertSBLToLB_SBLFormat(SBLKey : String) : String;

var
  SBLRec : SBLRecord;

begin
  Result := '';
  SBLRec := ExtractSBLFromSBLKey(SBLKey);

  with SBLRec do
    begin
      Result := Result + DezeroOnLeft(Section) + ' ';

      If (Deblank(DezeroOnLeft(Subsection)) <> '')
        then Result := Result + DezeroOnLeft(Subsection) + ' ';

      If (Deblank(DezeroOnLeft(Block)) <> '')
        then Result := Result + DezeroOnLeft(Block) + ' ';

      If (Deblank(DezeroOnLeft(Lot)) <> '')
        then Result := Result + DezeroOnLeft(Lot) + ' ';

      If (Deblank(DezeroOnLeft(Sublot)) <> '')
        then Result := Result + DezeroOnLeft(Sublot) + ' ';

      If (Deblank(DezeroOnLeft(Suffix)) <> '')
        then Result := Result + DezeroOnLeft(Suffix) + ' ';

      Result := Trim(Result);

    end;  {with SBLRec do}

end;  {ConvertSBLToLB_SBLFormat}

{==========================================================================}
Function ConvertLB_SBLToSBLFormat(MapParcelID : String) : String;

var
  BlankPos : Integer;

begin
  Result := '';

    {Section and subsection}

  BlankPos := Pos(' ', MapParcelID);
  Result := Result + ShiftRightAddZeroes(Take(3, Copy(MapParcelID, 1, (BlankPos - 1)))) +
                     '000';  {No subsection}
  Delete(MapParcelId, 1, BlankPos);

    {Block}

  BlankPos := Pos(' ', MapParcelID);
  Result := Result + ShiftRightAddZeroes(Take(4, Copy(MapParcelID, 1, (BlankPos - 1))));
  Delete(MapParcelId, 1, BlankPos);

    {Lot - its just the rest}

  Result := Result + ShiftRightAddZeroes(Take(3, Copy(MapParcelID, 1, 3)));

    {No sublot or suffix}

  Result := Result + '0000000';

end;  {ConvertSBLToLB_SBLFormat}

{==========================================================================}
Function GetParcelIDFromMapFile(MapParcelID : String;
                                MapSetupObject : TMapSetupObject) : SBLRecord;

var
  ValidEntry : Boolean;

begin
  If (Length(MapParcelID) = 26)
    then Result := ExtractSwisSBLFromSwisSBLKey(MapParcelID)
    else
      If (MapSetupObject.PASKeyField = 'LB_SBL')
        then Result := ExtractSBLFromSBLKey(ConvertLB_SBLToSBLFormat(MapParcelID))
        else
          If MapSetupObject.DashDotSBLFormat
            then
              begin
                Result := ConvertDashDotSBLToSegmentSBL(MapParcelID, ValidEntry);

                If not ValidEntry
                  then InitializeSBLRecord(Result);

              end
            else Result := ExtractSBLFromSBLKey(MapParcelID);

end;  {GetParcelIDFromMapFile}

{==========================================================================}
Function FindParcelForMapRecord(ParcelLookupTable : TTable;
                                MapParcelIDFormatTable : TTable;
                                AssessmentYearControlTable : TTable;
                                MapSetupObject : TMapSetupObject;
                                FieldValue : String;
                                AssessmentYear : String) : Boolean;

var
  SBLRec : SBLRecord;

begin
  Result := False;

    {CHG10062003-1: Allow for a different parcel ID format in order to accomodate
                    different IDs coming from the map source file.}

  If MapSetupObject.UseMapParcelIDFormat
    then SetGlobalSBLSegmentFormats(MapParcelIDFormatTable);

  If (ANSIUpperCase(MapSetupObject.PASIndex) = 'BYTAXROLLYR_SBLKEY')
    then
      begin
        SBLRec := GetParcelIDFromMapFile(FieldValue, MapSetupObject);
        ForceSBLRecordFormat(SBLRec);

        with SBLRec do
          Result := FindKeyOld(ParcelLookupTable,
                               ['TaxRollYr', 'Section', 'Subsection', 'Block',
                                'Lot', 'Sublot', 'Suffix'],
                               [AssessmentYear, Section, Subsection,
                                Block, Lot, Sublot, Suffix]);

      end;  {If (ANSIUpperCase(MapSetupObject.PASIndex) = 'BYTAXROLLYR_SBLKEY')}

  If (ANSIUpperCase(MapSetupObject.PASIndex) = 'BYTAXROLLYR_SWISSBLKEY')
    then
      begin
        SBLRec := GetParcelIDFromMapFile(FieldValue, MapSetupObject);
        ForceSBLRecordFormat(SBLRec);

        with SBLRec do
          Result := FindKeyOld(ParcelLookupTable,
                               ['TaxRollYr', 'SwisCode', 'Section', 'Subsection', 'Block',
                                'Lot', 'Sublot', 'Suffix'],
                               [AssessmentYear, SwisCode, Section, Subsection,
                                Block, Lot, Sublot, Suffix]);

      end;  {If (ANSIUpperCase(MapSetupObject.PASIndex) = 'BYTAXROLLYR_SBLKEY')}

  If ((Deblank(FieldValue) <> '') and
      (ANSIUpperCase(MapSetupObject.PASIndex) = 'BYACCOUNTNO'))
    then Result := FindKeyOld(ParcelLookupTable, ['AccountNo'],
                              [FieldValue]);

    {Switch back to normal format.}

  If MapSetupObject.UseMapParcelIDFormat
    then SetGlobalSBLSegmentFormats(AssessmentYearControlTable);

end;  {FindParcelForMapRecord}

{==========================================================================}
Procedure SetMapOptions(MappingSetupName : String;
                        DefaultSetup : Boolean;
                        MappingHeaderTable,
                        MappingDetailTable,
                        MapLayersAvailableTable,
                        MapParcelIDFormatTable : TTable;
                        MapSetupObject : TMapSetupObject);

var
  FirstTimeThrough, Done, Autoload : Boolean;

begin
    {Sometimes the tables get closed as they are passed into this procedure.}

  If not MappingHeaderTable.Active
    then MappingHeaderTable.Open;

  If not MappingDetailTable.Active
    then MappingDetailTable.Open;

  If not MapLayersAvailableTable.Active
    then MapLayersAvailableTable.Open;

  Done := False;
  FirstTimeThrough := True;

  MappingHeaderTable.First;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else MappingHeaderTable.Next;

    If MappingHeaderTable.EOF
      then Done := True;

    If not Done
      then
        with MappingHeaderTable do
          begin
            If (FieldByName('Default').AsBoolean and
                ((Deblank(MappingSetupName) = '') or
                 DefaultSetup))
              then Done := True;

            If (Take(30, MappingSetupName) = Take(30, FieldByName('MappingSetupName').Text))
              then Done := True;

          end;  {with MappingHeaderTable do}

  until Done;

    {We are now on the layer they want, set the options.}

  with MappingHeaderTable, MapSetupObject do
    begin
      DefaultZoomPercentToDrawDetails := FieldByName('ZoomPctToShowDtls').AsFloat;
      MapFileKeyField := FieldByName('MapFileKeyField').Text;
      PASKeyField := FieldByName('PASKeyField').Text;
      PASIndex := FieldByName('PASIndexName').Text;
      LabelColor := FieldByName('LabelColor').AsInteger;
      SetupName := FieldByName('MappingSetupName').Text;
      LabelType := FieldByName('LabelType').AsInteger;
      FillColor := FieldByName('FillColor').AsInteger;
      FillType := FieldByName('FillType').AsInteger;

      try
        DashDotSBLFormat := FieldByName('DashDotSBLFormat').AsBoolean;
      except
        DashDotSBLFormat := False;
      end;

      try
        UseMapParcelIDFormat := MapParcelIDFormatTable.FieldByName('UseMapParcelID').AsBoolean;
      except
        UseMapParcelIDFormat := False;
      end;

      try
        AV_SP_Ratio_Decimals := FieldByName('AV_SP_Ratio_Decimals').AsInteger;
      except
        AV_SP_Ratio_Decimals := 2;
      end;

    end;  {with MappingHeaderTable do}

    {Now get the load all layers and mark the ones to load.}

  Done := False;
  FirstTimeThrough := True;

  MapLayersAvailableTable.First;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else MapLayersAvailableTable.Next;

    If MapLayersAvailableTable.EOF
      then Done := True;

    If not Done
      then
        begin
          AutoLoad := FindKeyOld(MappingDetailTable, ['MappingSetupName', 'LayerName'],
                                 [MappingHeaderTable.FieldByName('MappingSetupName').Text,
                                  MapLayersAvailableTable.FieldByName('LayerName').Text]);

            {CHG08052004-1(M1.5): Add fill type and layer order.}

          with MapLayersAvailableTable do
            MapSetupObject.AddLayer(FieldByName('LayerName').Text,
                                    FieldByName('LayerLocation').Text,
                                    FieldByName('MainLayer').AsBoolean,
                                    FieldByName('LayerColor').AsInteger,
                                    Autoload,
                                    FieldByName('Transparent').AsBoolean,
                                    FieldByName('LayerType').Text,
                                    FieldByName('FillType').AsInteger,
                                    FieldByName('LayerOrder').AsInteger,
                                    FieldByName('UseLabelPlacer').AsBoolean,
                                    FieldByName('UseLabelRenderer').AsBoolean,
                                    FieldByName('TextField').Text,
                                    FieldByName('XOffsetField').Text,
                                    FieldByName('YOffsetField').Text,
                                    FieldByName('RotationField').Text,
                                    FieldByName('SplinedText').AsBoolean,
                                    FieldByName('Flip').AsBoolean,
                                    FieldByName('DrawBackground').AsBoolean,
                                    FieldByName('HeightField').Text,
                                    FieldByName('SymbolField').Text,
                                    FieldByName('LevelField').Text,
                                    FieldByName('PlaceAbove').AsBoolean,
                                    FieldByName('PlaceBelow').AsBoolean,
                                    FieldByName('PlaceOn').AsBoolean);

        end;  {If not Done}

  until Done;

    {CHG08052004-1(M1.5): Add fill type and layer order.}
    {Now sort by layer order.}

  MapSetupObject.SortLayersByLayerOrder;

end;  {SetMapOptions}

{==========================================================}
Function ConvertPASKeyFieldToMapKeyField(ParcelTable : TTable;
                                         MapParcelIDFormatTable : TTable;
                                         AssessmentYearControlTable : TTable;
                                         SwisSBLKey : String;
                                         AssessmentYear : String;
                                         MapSetupObject : TMapSetupObject;
                                         ConvertIfNotLocated : Boolean) : String;

var
  SBLRec : SBLRecord;
  _Found : Boolean;

begin
  Result := '';

    {CHG10062003-1: Allow for a different parcel ID format in order to accomodate
                    different IDs coming from the map source file.}

  If MapSetupObject.UseMapParcelIDFormat
    then SetGlobalSBLSegmentFormats(MapParcelIDFormatTable);

  SBLRec := ExtractSwisSBLFromSwisSBLKey(SwisSBLKey);

  with SBLRec do
    _Found := FindKeyOld(ParcelTable,
                         ['TaxRollYr', 'SwisCode', 'Section',
                          'Subsection', 'Block', 'Lot', 'Sublot', 'Suffix'],
                         [AssessmentYear, SwisCode, Section, Subsection,
                          Block, Lot, Sublot, Suffix]);

  If (_Found or ConvertIfNotLocated)
    then
      begin
        If Utilitys._Compare(MapSetupObject.PASKeyField, 'AccountNo', coEqual)
          then Result := ParcelTable.FieldByName('AccountNo').Text
          else
            If (MapSetupObject.PASKeyField = 'LB_SBL')
              then Result := ConvertSBLToLB_SBLFormat(Copy(SwisSBLKey, 7, 20))
              else
                If MapSetupObject.DashDotSBLFormat
                  then Result := ConvertSwisSBLToDashDotNoSwis(SwisSBLKey)
                  else Result := Copy(SwisSBLKey, 7, 20);

      end  {If _Found}
    else Result := SwisSBLKey;

    {Switch back to normal format.}

  If MapSetupObject.UseMapParcelIDFormat
    then SetGlobalSBLSegmentFormats(AssessmentYearControlTable);

end;  {ConvertPASKeyFieldToMapKeyField}

{==========================================================}
Procedure LoadLayersIntoLayerBox(LayersCheckListBox : TCheckListBox;
                                 MappingSetupName : String;
                                 MapLayersAvailableTable,
                                 MappingDetailTable : TTable);

var
  FirstTimeThrough, Done : Boolean;
  TempItem : String;
  I : Integer;

begin
  SetRangeOld(MappingDetailTable, ['MappingSetupName', 'LayerName'],
              [MappingSetupName, Take(10, '')],
              [MappingSetupName, 'ZZZZZZZZZZ']);

  FirstTimeThrough := True;
  Done := False;

  MapLayersAvailableTable.First;

  LayersCheckListBox.Items.Clear;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else MapLayersAvailableTable.Next;

    If MapLayersAvailableTable.EOF
      then Done := True;

    If not Done
      then
        with MapLayersAvailableTable do
          begin
            TempItem := FieldByName('LayerName').Text;

              {Always make the main layer the first item.}

            If FieldByName('MainLayer').AsBoolean
              then
                begin
                  TempItem := TempItem + ' (Main)';
                  LayersCheckListBox.Items.Insert(0, TempItem);
                  LayersCheckListBox.Checked[0] := True;
                end
              else LayersCheckListBox.Items.Add(TempItem);

          end;  {with MapLayersAvailableTable do}

  until Done;

    {Now go back through the layers (skipping the main layer) and
     see which ones are selected.}

  For I := 1 to (LayersCheckListBox.Items.Count - 1) do
    LayersCheckListBox.Checked[I] := FindKeyOld(MappingDetailTable, ['MappingSetupName', 'LayerName'],
                                                [MappingSetupName, LayersCheckListBox.Items[I]]);

    {FXX10192004-1(2.8.0.14[1955]): Make sure to cancel the range so that it doesn't get in the way of
                                    loading the default layers.}

  MappingDetailTable.CancelRange;

end;  {LoadLayersIntoLayerBox}

{==========================================================}
Procedure LoadLayersIntoLayerListBox(LayersListBox : TListBox;
                                     MapLayersAvailableTable,
                                     MappingDetailTable : TTable;
                                     InactiveOnly : Boolean);

var
  AddLayer, FirstTimeThrough, Done : Boolean;
  TempItem : String;

begin
  FirstTimeThrough := True;
  Done := False;

  MapLayersAvailableTable.First;
  MappingDetailTable.IndexName := 'ByLayerName';

  LayersListBox.Items.Clear;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else MapLayersAvailableTable.Next;

    If MapLayersAvailableTable.EOF
      then Done := True;

    If not Done
      then
        with MapLayersAvailableTable do
          begin
            TempItem := FieldByName('LayerName').Text;
            AddLayer := True;

            If InactiveOnly
              then AddLayer := not FindKeyOld(MappingDetailTable, ['LayerName'],
                                              [TempItem]);

              {Always make the main layer the first item.}

            If AddLayer
              then
                If FieldByName('MainLayer').AsBoolean
                  then
                    begin
                      TempItem := TempItem + ' (Main)';
                      LayersListBox.Items.Insert(0, TempItem);
                    end
                  else LayersListBox.Items.Add(TempItem);

          end;  {with MapLayersAvailableTable do}

  until Done;

end;  {LoadLayersIntoLayerBox}

{============================================================================}
Function AddOneLayer(    LayerName : String;
                     var MainLayer : IMoMapLayer;
                         MapSetupObject : TMapSetupObject;
                         Map : TMap) : IMOMapLayer;

var
  dc : IMoDataConnection;
  TempFieldName, LayerFileName, LayerDatabaseName : OLEVariant;
  MapLayer : IMoMapLayer;
  LabelPlacer : IMoLabelPlacer;
  LabelRenderer : IMOLabelRenderer;

begin
  dc := IMoDataConnection(CreateOleObject('MapObjects2.DataConnection'));

  LayerDatabaseName := MapSetupObject.GetLayerDatabaseName(LayerName);
  dc.database := GetLayerTypePrefix(MapSetupObject.GetLayerType(LayerName)) +
                                    LayerDatabaseName;
  MapLayer := IMoMapLayer(CreateOleObject('MapObjects2.MapLayer'));
  LayerFileName := MapSetupObject.GetLayerLocation(LayerName);
  MapLayer.Geodataset := dc.FindGeoDataset(LayerFileName);

    {If this is a CADText layer, we need to use a LabelPlacer to
     actually display the text.}

    {CHG02172005-1(M1.6): Add label \ renderer options to layers.}

  If ((not MapSetupObject.UseLabelRenderer(LayerName) and
      (ANSIUpperCase(MapSetupObject.GetLayerType(LayerName)) = ANSIUpperCase(ltCADText)) or
       MapSetupObject.UseLabelPlacer(LayerName)))
    then
      begin
        LabelPlacer := IMoLabelPlacer(CreateOleObject('MapObjects2.LabelPlacer'));

        with LabelPlacer do
          begin
            DefaultSymbol.Color := MapSetupObject.GetLayerColor(LayerName);
            TempFieldName := MapSetupObject.GetTextFieldName(LayerName);

            If (Trim(TempFieldName) = '')
              then TempFieldName := 'Text';

            Field := TempFieldName;
            PlaceAbove := True;
            DrawBackground := False;
            MaskLabels := True;
            MaskColor := Map.BackColor;

            try
              Symbol[0].Height := 10;
            except
            end;

          end;  {with LabelPlacer do}

        MapLayer.Renderer := LabelPlacer;

      end;  {If (MapSetupObject.GetLayerType(LayerName) = ltCADText)}

  If MapSetupObject.UseLabelRenderer(LayerName)
    then
      begin
        LabelRenderer := IMoLabelRenderer(CreateOleObject('MapObjects2.LabelRenderer'));

        with LabelRenderer do
          begin
            try
              Symbol[0].Color := MapSetupObject.GetLayerColor(LayerName);
            except
            end;

            TempFieldName := MapSetupObject.GetTextFieldName(LayerName);

            If (Trim(TempFieldName) = '')
              then TempFieldName := 'Text';

            Field := TempFieldName;
            DrawBackground := False;
            XOffsetField := MapSetupObject.GetXOffsetFieldName(LayerName);
            YOffsetField := MapSetupObject.GetYOffsetFieldName(LayerName);
            RotationField := MapSetupObject.GetRotationFieldName(LayerName);
            Symbol[0].Height := 10;
            SplinedText := True;

          end;  {with LabelPlacer do}

        MapLayer.Renderer := LabelRenderer;

      end;  {If MapSetupObject.UseLabelRenderer(LayerName)

    {The tag is used to later remove a layer if needed.}

  MapLayer.Tag := LayerName;

    {CHG08052004-1(M1.5): Add fill type and layer order.}

  try
    MapLayer.Symbol.Style := MapSetupObject.GetLayerFillType(LayerName);
  except
  end;

    {CHG11112003-2(M1.4): Add the ability to make a layer transparent.}

  If MapSetupObject.MapLayerIsTransparent(LayerName)
    then MapLayer.Symbol.Style := moTransparentFill;

  Map.Layers.Add(MapLayer);
  MapLayer.Symbol.Color := MapSetupObject.GetLayerColor(LayerName);

  If MapSetupObject.IsMainLayer(LayerName)
    then MainLayer := MapLayer;

  Result := MapLayer;

end;  {AddOneLayer}

{==========================================================================}
Procedure DisplayAutoLoadLayers(    MapSetupObject : TMapSetupObject;
                                    Map : TMap;
                                var MainLayer : IMoMapLayer;
                                    ImageLayer : IMoImageLayer;
                                var MainLayerName : String;
                                var MainLayerFileName : String;
                                var MainLayerLocation : String;
                                    LoadOrthographicLayer : Boolean;
                                var HasImageLayer : Boolean);

var
  LayerName, LayerDatabaseName, LayerFileName : String;
  I : Integer;
  MapLayer : IMOMapLayer;

begin
    {Go through the Map Setup Object to load the layers so that they are
     loaded in the correct order.}

    {CHG03042003-1: Add support for MrSID images.  Load them first}

  If LoadOrthographicLayer
    then
      For I := 0 to (MapSetupObject.GetLayerCount - 1) do
        If MapSetupObject.MapLayerIsVisible(MapSetupObject.GetLayerName(I))
          then
            begin
              LayerName := MapSetupObject.GetLayerName(I);
              LayerDatabaseName := MapSetupObject.GetLayerDatabaseName(LayerName);

              If (MapSetupObject.GetLayerType(LayerName) = ltMRSID)
                then
                  begin
                    ImageLayer := IMoImageLayer(CreateOleObject('MapObjects2.ImageLayer'));
                    LayerFileName := MapSetupObject.GetLayerLocation(LayerName);
                    ImageLayer.File_ := LayerDatabaseName + LayerFileName;
                    ImageLayer.Tag := LayerName;

                    try
                      Map.Layers.Add(ImageLayer);
                      IMoMapLayer(Map.Layers.Item(0)).Tag := LayerName;
                      HasImageLayer := True;
                    except
                      MessageDlg('Error loading image layer ' + LayerFileName + '.',
                                 mtError, [mbOK], 0);
                    end;

                  end;  {If (MapSetupObject.GetLayerType(LayerName) = ltMRSID)}

            end;  {If MapSetupObject.MapLayerIsVisible(MapSetupObject.GetLayerName(I))}

    {Now do the non-image layers.}
    {FXX01232006-1(2.9.5.1): Don't load MRSID layers here since they were loaded above.}

  with MapSetupObject do
    For I := 0 to (GetLayerCount - 1) do
      If (MapLayerIsVisible(GetLayerName(I)) and
          _Compare(GetLayerType(GetLayerName(I)), ltMRSID, coNotEqual))
        then
          begin
            LayerName := GetLayerName(I);
            LayerDatabaseName := GetLayerDatabaseName(LayerName);
            LayerFileName := GetLayerLocation(LayerName);

            MapLayer := AddOneLayer(LayerName, MainLayer, MapSetupObject, Map);

            If IsMainLayer(LayerName)
              then
                begin
                  If HasImageLayer
                    then MainLayer.Symbol.Style := moTransparentFill;

                  MainLayerName := LayerName;
                  MainLayerFileName := LayerFileName;
                  MainLayerLocation := LayerDatabaseName;

                end;  {IsMainLayer(LayerName)}

          end;  {For I := 0 to (GetLayerCount - 1) do}

end;  {DisplayAutoLoadLayers}

{==========================================================================}
Function GetLayerTypePrefix(LayerType : String) : String;

begin
  Result := '';

  If (LayerType = ltArcInfo)
    then Result := '[arc]';

  If (ANSIUpperCase(LayerType) = ANSIUpperCase(ltCADArea))
    then Result := '[CADAREA]';

  If (ANSIUpperCase(LayerType) = ANSIUpperCase(ltCADText))
    then Result := '[CADTEXT]';

end;  {GetLayerTypePrefix}

{================================================================}
Function DetermineLabelBaseline(Polygon : IMoPolygon;
                                TextBaseLine : IMoLine) : Extended;

{Returns the size.}

var
  BaseLinePoint, CrossSectionPoint,
  LargestDistanceLeftPoint, LargestDistanceRightPoint : IMoPoint;
  Intersection, BaseLinePoints, CrossSectionPoints : IMoPoints;
  CrossSectionLine : IMoLine;
  Distance, LargestDistance : Extended;
  TopPoint, BottomPoint : LongInt;
  I, J, LeftIndex, RightIndex : Integer;
  UseCentroidMethod : Boolean;

begin
  Result := 0;
  UseCentroidMethod := True;
  BaseLinePoint := IMoPoint(CreateOleObject('MapObjects2.Point'));
  BaseLinePoints := IMoPoints(CreateOleObject('MapObjects2.Points'));

  CrossSectionPoint := IMoPoint(CreateOleObject('MapObjects2.Point'));
  CrossSectionPoints := IMoPoints(CreateOleObject('MapObjects2.Points'));
  CrossSectionLine := IMoLine(CreateOleObject('MapObjects2.Line'));

  LargestDistanceLeftPoint := IMoPoint(CreateOleObject('MapObjects2.Point'));
  LargestDistanceRightPoint := IMoPoint(CreateOleObject('MapObjects2.Point'));
  LargestDistance := 0;

  Intersection := IMoPoints(CreateOleObject('MapObjects2.Points'));

  try
    TopPoint := Round(Polygon.Extent.Top - 10);
  except
    TopPoint := 0;
  end;

  try
    BottomPoint := Round(Polygon.Extent.Bottom + 10);
  except
    BottomPoint := 0;
  end;

  try
    CrossSectionPoint.X := Polygon.Extent.Left;
    CrossSectionPoint.Y := Polygon.Centroid.Y;
    CrossSectionPoints.Add(CrossSectionPoint);

    CrossSectionPoint.X := Polygon.Extent.Right;
    CrossSectionPoint.Y := Polygon.Centroid.Y;
    CrossSectionPoints.Add(CrossSectionPoint);

    CrossSectionLine.Parts.Add(CrossSectionPoints);

    Intersection := Polygon.GetCrossings(CrossSectionLine);

      {FXX10202003-1: Take care of case where the cross section line intersects the
                      parcel in multiple points.  Always take the first and last intersection points.}

    Distance := Abs(Intersection.Item(Intersection.Count - 1).X - Intersection.Item(0).X);

    If (Distance > LargestDistance)
      then
        begin
          LargestDistance := Distance;

            {Which point is actually the left point?}
            {Here's what we are going to do (after sorting the points from left to right:
               1. If there are 2 points, no problem.
               2. If there are 3 points, this is probably a case where the centroid baseline
                  intersects a jagged upshoot from the bottom of the parcel at a single point,
                  so take the set of points (0->1 or 1->2) that yields the greatest distance.
               3. If there are 4 points, this is the case where the parcel has "legs",
                  so take the set of points (0->1 or 2->3) that yields the greatest
                  distance.  Note that we omit the interior set 1->2 since it is
                  assumed that this is a different parcel.
               4. > 4 points, egads.  Just do between points 0->1 since we don't really
                  know the geometry of the parcel.  This may not put it in the optimal
                  place, but it is better than being on the wrong parcel.}



          If (Intersection.Item(Intersection.Count - 1).X > Intersection.Item(0).X)
            then
              begin
                LeftIndex := 0;
                RightIndex := Intersection.Count - 1;
              end
            else
              begin
                LeftIndex := Intersection.Count - 1;
                RightIndex := 0;
              end;

          LargestDistanceLeftPoint.X := Intersection.Item(LeftIndex).X + 10;
          LargestDistanceLeftPoint.Y := Polygon.Centroid.Y;;

          LargestDistanceRightPoint.X := Intersection.Item(RightIndex).X - 10;
          LargestDistanceRightPoint.Y := Polygon.Centroid.Y;;

        end;  {If (Distance > LargestDistance)}

    For J := (Intersection.Count - 1) downto 0 do
      Intersection.Remove(J);

    For J := (CrossSectionPoints.Count - 1) downto 0 do
      CrossSectionPoints.Remove(J);

    For J := (CrossSectionLine.Parts.Count - 1) downto 0 do
      CrossSectionLine.Parts.Remove(J);

  except
    UseCentroidMethod := False;
  end;

  If not UseCentroidMethod
    then
      For I := TopPoint downto BottomPoint do
        If not Odd(I)
          then
            begin
              CrossSectionPoint.X := Polygon.Extent.Left;
              CrossSectionPoint.Y := I;
              CrossSectionPoints.Add(CrossSectionPoint);

              CrossSectionPoint.X := Polygon.Extent.Right;
              CrossSectionPoint.Y := I;
              CrossSectionPoints.Add(CrossSectionPoint);

              CrossSectionLine.Parts.Add(CrossSectionPoints);

              Intersection := Polygon.GetCrossings(CrossSectionLine);

              If (Intersection.Count = 2)
                then
                  begin
                    Distance := Abs(Intersection.Item(1).X - Intersection.Item(0).X);

                    If (Distance > LargestDistance)
                      then
                        begin
                          LargestDistance := Distance;

                            {Which point is actually the left pont?}

                          If (Intersection.Item(1).X > Intersection.Item(0).X)
                            then
                              begin
                                LeftIndex := 0;
                                RightIndex := 1;
                              end
                            else
                              begin
                                LeftIndex := 1;
                                RightIndex := 0;
                              end;

                          LargestDistanceLeftPoint.X := Intersection.Item(LeftIndex).X + 10;
                          LargestDistanceLeftPoint.Y := I;

                          LargestDistanceRightPoint.X := Intersection.Item(RightIndex).X - 10;
                          LargestDistanceRightPoint.Y := I;

                        end;  {If (Distance > LargestDistance)}

                  end;  {If (Intersection.Count = 2)}

              For J := (Intersection.Count - 1) downto 0 do
                Intersection.Remove(J);

              For J := (CrossSectionPoints.Count - 1) downto 0 do
                CrossSectionPoints.Remove(J);

              For J := (CrossSectionLine.Parts.Count - 1) downto 0 do
                CrossSectionLine.Parts.Remove(J);

            end;  {For I := Polygon.Extent.Top downto Polygon.Extent.Bottom do}

  If (LargestDistance > 0)
    then
      begin
        BaseLinePoint.X := LargestDistanceLeftPoint.X;
        BaseLinePoint.Y := LargestDistanceLeftPoint.Y;
        BaseLinePoints.Add(BaseLinePoint);

        BaseLinePoint.X := LargestDistanceRightPoint.X;
        BaseLinePoint.Y := LargestDistanceRightPoint.Y;
        BaseLinePoints.Add(BaseLinePoint);

        TextBaseLine.Parts.Add(BaseLinePoints);

        Result := Abs(LargestDistance);

      end;  {If (LargestDistance > 0)}

end;  {DetermineLabelBaseline}

{========================================================================}
Function MapExtentsSame(Extent1 : IMORectangle;
                        Extent2 : IMORectangle) : Boolean;

begin
  Result := ((Extent1.Left = Extent2.Left) and
             (Extent1.Right = Extent2.Right) and
             (Extent1.Top = Extent2.Top) and
             (Extent1.Bottom = Extent2.Bottom))

end;  {MapExtentsSame}

{===============================================================}
Procedure FillInMapRangeList(MapRangeList : TList;
                             MapRangeRec : MapRangeRecord;
                             RangeType : Integer;
                             IntegerValuesOnly : Boolean;
                             SelectedCodesList : TStringList);

{Given a start value, ending value, starting color, ending color and increment,
 return a list with the high and low value increments and gradate the color.}

var
  I, Index : Integer;
  CurrentColor : TColor;
  CurrentStartValue, CurrentEndValue, Interval : Double;
  TempNumberOfIncrements,
  LowRedAmount, LowGreenAmount, LowBlueAmount,
  HighRedAmount, HighGreenAmount, HighBlueAmount,
  CurrentRedAmount, CurrentGreenAmount, CurrentBlueAmount,
  RedAmountInterval, GreenAmountInterval, BlueAmountInterval : Integer;
  MapRangeItemPtr : MapRangeItemPointer;
  DisplayFormat : String;

begin
  Index := 0;
  ClearTList(MapRangeList, SizeOf(MapRangeItemRecord));
  CurrentStartValue := 0;
  CurrentEndValue := 0;
  TempNumberOfIncrements := 0;
  Interval := 0;

  with MapRangeRec do
    begin
      case RangeType of
        rtLandValue,
        rtAssessedValue,
        rtAssessmentChange,
        rtSalesPrice,
        rtAssessedValue_SalesPrice_Ratio :
          begin
            TempNumberOfIncrements := NumberOfIncrements;
            Interval := (EndValue - StartValue) / TempNumberOfIncrements;
            CurrentStartValue := StartValue;
            CurrentEndValue := CurrentStartValue + Interval;

          end;  {rtLandValue,...}

        rtZoningCodes,
        rtNeighborhoodCodes,
        rtSwisCodes,
        rtSchoolCodes,
        rtPropertyClass : TempNumberOfIncrements := SelectedCodesList.Count;

      end;  {case RangeType of}

        {Set the initial colors.}

      GetRGBValues(StartColor, LowRedAmount, LowGreenAmount, LowBlueAmount);
      GetRGBValues(EndColor, HighRedAmount, HighGreenAmount, HighBlueAmount);

      RedAmountInterval := (HighRedAmount - LowRedAmount) DIV (TempNumberOfIncrements - 1);
      GreenAmountInterval := (HighGreenAmount - LowGreenAmount) DIV (TempNumberOfIncrements - 1);
      BlueAmountInterval := (HighBlueAmount - LowBlueAmount) DIV (TempNumberOfIncrements - 1);

      CurrentRedAmount := LowRedAmount;
      CurrentGreenAmount := LowGreenAmount;
      CurrentBlueAmount := LowBlueAmount;

        {Fill in the first value.}

      CurrentColor := HexToInt(IntToHex(CurrentBlueAmount, 2) +
                               IntToHex(CurrentGreenAmount, 2) +
                               IntToHex(CurrentRedAmount, 2));

      New(MapRangeItemPtr);

      with MapRangeItemPtr^ do
        begin
          case RangeType of
            rtLandValue,
            rtAssessedValue,
            rtAssessmentChange,
            rtSalesPrice,
            rtAssessedValue_SalesPrice_Ratio :
              begin
                If IntegerValuesOnly
                  then DisplayFormat := NoDecimalDisplay
                  else DisplayFormat := DecimalEditDisplay;

                LowValue := FormatFloat(DisplayFormat,
                                        CurrentStartValue);
                HighValue := FormatFloat(DisplayFormat,
                                         CurrentEndValue);

                CurrentStartValue := CurrentEndValue;

              end;  {rtLandValue, ...}

            rtZoningCodes,
            rtNeighborhoodCodes,
            rtSwisCodes,
            rtSchoolCodes,
            rtPropertyClass :
              begin
                LowValue := SelectedCodesList[0];
                HighValue := '';
              end;  {rtZoningCodes ...}

          end;  {case RangeType of}

          Color := CurrentColor;

        end;  {with MapRangeItemPtr^ do}

      MapRangeList.Add(MapRangeItemPtr);

      For I := 2 to TempNumberOfIncrements do
        begin

            {Now figure out the color.}

          CurrentRedAmount := CurrentRedAmount + RedAmountInterval;
          If (RedAmountInterval < 0)
            then
              begin
                If (CurrentRedAmount < HighRedAmount)
                  then CurrentRedAmount := HighRedAmount;
              end
            else
              begin
                If (CurrentRedAmount > HighRedAmount)
                  then CurrentRedAmount := HighRedAmount;

              end;  {If (RedAmountInterval < 0) ...}

          CurrentGreenAmount := CurrentGreenAmount + GreenAmountInterval;
          If (GreenAmountInterval < 0)
            then
              begin
                If (CurrentGreenAmount < HighGreenAmount)
                  then CurrentGreenAmount := HighGreenAmount;
              end
            else
              begin
                If (CurrentGreenAmount > HighGreenAmount)
                  then CurrentGreenAmount := HighGreenAmount;

              end;  {If (GreenAmountInterval < 0) ...}

          CurrentBlueAmount := CurrentBlueAmount + BlueAmountInterval;
          If (BlueAmountInterval < 0)
            then
              begin
                If (CurrentBlueAmount < HighBlueAmount)
                  then CurrentBlueAmount := HighBlueAmount;
              end
            else
              begin
                If (CurrentBlueAmount > HighBlueAmount)
                  then CurrentBlueAmount := HighBlueAmount;

              end;  {If (BlueAmountInterval < 0) ...}

          case RangeType of
            rtLandValue,
            rtAssessedValue,
            rtAssessmentChange,
            rtSalesPrice,
            rtAssessedValue_SalesPrice_Ratio :
              begin
                  {First figure out the high and low value for this range.}

                CurrentEndValue := CurrentStartValue + Interval;

                If IntegerValuesOnly
                  then CurrentEndValue := Roundoff(CurrentEndValue, 0);

                If (CurrentEndValue > EndValue)
                  then CurrentEndValue := EndValue;

              end;  {rtLandValue,...}

            rtZoningCodes,
            rtNeighborhoodCodes,
            rtSwisCodes,
            rtSchoolCodes,
            rtPropertyClass : Index := Index + 1;

          end;  {case RangeType of}

          CurrentColor := HexToInt(IntToHex(CurrentBlueAmount, 2) +
                                   IntToHex(CurrentGreenAmount, 2) +
                                   IntToHex(CurrentRedAmount, 2));

          New(MapRangeItemPtr);

          with MapRangeItemPtr^ do
            begin
              case RangeType of
                rtLandValue,
                rtAssessedValue,
                rtAssessmentChange,
                rtSalesPrice,
                rtAssessedValue_SalesPrice_Ratio :
                  begin
                    If IntegerValuesOnly
                      then DisplayFormat := NoDecimalDisplay
                      else DisplayFormat := DecimalEditDisplay;

                    LowValue := FormatFloat(DisplayFormat,
                                            CurrentStartValue);
                    HighValue := FormatFloat(DisplayFormat,
                                             CurrentEndValue);

                  end;  {rtLandValue, ...}

                rtZoningCodes,
                rtNeighborhoodCodes,
                rtSwisCodes,
                rtSchoolCodes,
                rtPropertyClass :
                  begin
                    LowValue := SelectedCodesList[Index];
                    HighValue := '';
                  end;  {rtZoningCodes ...}

              end;  {case RangeType of}

              Color := CurrentColor;

            end;  {with MapRangeItemPtr^ do}

          MapRangeList.Add(MapRangeItemPtr);

          case RangeType of
            rtLandValue,
            rtAssessedValue,
            rtAssessmentChange,
            rtSalesPrice,
            rtAssessedValue_SalesPrice_Ratio : CurrentStartValue := CurrentEndValue;

          end;  {case RangeType of}

        end;  {For I := 1 to NumberOfIncrements do}

    end;  {with MapRangeRec do}

end;  {FillInMapRangeList}

{=====================================================================}
Function FindRangeColorForValue(    MapRangeList : TList;
                                    Value : String;
                                    Numeric : Boolean;
                                    DefaultColor : TColor;
                                var ValueInRange : Boolean) : LongInt;

var
  I : Integer;

begin
  Result := DefaultColor;
  ValueInRange := False;

  For I := 0 to (MapRangeList.Count - 1) do
    with MapRangeItemPointer(MapRangeList[I])^ do
      begin
        If Numeric
          then
            begin
              try
                If ((StrToFloat(Value) >= StrToFloat(LowValue)) and
                    (StrToFloat(Value) <= StrToFloat(HighValue)))
                  then
                    begin
                      Result := Color;
                      ValueInRange := True;
                    end;

              except
              end;

            end
          else
            If (Value = LowValue)
              then
                begin
                  Result := Color;
                  ValueInRange := True;
                end;

      end;  {with MapRangeItemPointer(MapRangeList[I])^ do}

end;  {FindRangeColorForValue}

{=======================================================================}
Function StandardizeAddress(Address : String) : String;

{Try to format addresses so that 2 dissimilar ones that are really the same
 come out as matching, i.e. 'S MAPLE AVE.' vs. 'SOUTH MAPLE AVENUE'.}

var
  TempStr : String;

begin
  Result := '';

  TempStr := GetNextWord(Address);

  while (TempStr <> '') do
    begin
      If (TempStr[Length(TempStr)] = '.')
        then Delete(TempStr, Length(TempStr), 1);

      TempStr := ExpandStreetNameType(TempStr);

      Result := Result + TempStr;
      TempStr := GetNextWord(Address);

    end;  {while (TempStr <> '') do}

  Result := StringReplace(Result, ' ', '', [rfReplaceAll]);

end;  {StandardizeAddress}

{=======================================================================}
Function ParcelMeetsLegalAddressCriteria(ParcelTable : TTable;
                                         LegalAddress,
                                         LegalAddressNumberStart,
                                         LegalAddressNumberEnd : String;
                                         AllLegalAddressNumbers,
                                         ToEndOfLegalAddressNumbers : Boolean) : Boolean;

var
  LegalAddr, LegalAddrNo : String;

begin
  Result := True;

  LegalAddress := StandardizeAddress(LegalAddress);

  with ParcelTable do
    begin
      LegalAddr := StandardizeAddress(FieldByName('LegalAddr').Text);
      LegalAddrNo := FieldByName('LegalAddrNo').Text;

      try
        If (LegalAddr[Length(LegalAddr)] = '.')
          then System.Delete(LegalAddr, Length(LegalAddr), 1);
      except
      end;

      If (Trim(LegalAddr) <> Trim(LegalAddress))
        then Result := False;

      If (Result and
          (not AllLegalAddressNumbers))
        then
          begin
            If (Trim(LegalAddrNo) < Trim(LegalAddressNumberStart))
              then Result := False;

            If (Result and
                (not ToEndOfLegalAddressNumbers) and
                (Trim(LegalAddrNo) > Trim(LegalAddressNumberEnd)))
              then Result := False;

          end;  {If (Result and...}

    end;  {with ParcelTable do}

end;  {ParcelMeetsLegalAddressCriteria}

{=======================================================================}
Function GetSymbolHeight(BaseLineLength : Extended;
                         TempStr : String) : Extended;

{Now scale the text symbol height based on the text base line length.
 To do this, reduce the line lengt by about 5% to allow margin,
 then divide by 1.2 times the number of characters in the label.}

begin
  If (Length(Trim(TempStr)) <= 3)
    then
      try
        If (Length(Trim(TempStr)) = 0)
          then Result := 0
          else Result := (BaseLineLength * 0.7) / (0.9 * Length(Trim(TempStr)));
      except
        Result := 0;
      end
    else
      try
        Result := (BaseLineLength * 0.95) / (0.9 * Length(Trim(TempStr)));
      except
        Result := 0;
      end;

end;  {GetSymbolHeight}

{==================================================================}
Function FindCondominiumForMapRecord(MapCondoTable : TTable;
                                     MapSetupObject : TMapSetupObject;
                                     FieldValue : String) : Boolean;

var
  SBLRec : SBLRecord;
  SBL : String;

begin
  Result := False;

  If (ANSIUpperCase(MapSetupObject.PASIndex) = 'BYTAXROLLYR_SBLKEY')
    then
      begin
        SBLRec := GetParcelIDFromMapFile(FieldValue, MapSetupObject);
        ForceSBLRecordFormat(SBLRec);

        with SBLRec do
          SBL := Section + Subsection + Block +
                 Lot + Sublot + Suffix;

        MapCondoTable.IndexName := 'BySBL';

        Result := FindKeyOld(MapCondoTable, ['SBL'], [SBL]);

      end;  {If (ANSIUpperCase(MapSetupObject.PASIndex) = 'BYTAXROLLYR_SBLKEY')}

  If (ANSIUpperCase(MapSetupObject.PASIndex) = 'BYTAXROLLYR_SWISSBLKEY')
    then
      begin
        SBLRec := GetParcelIDFromMapFile(FieldValue, MapSetupObject);
        ForceSBLRecordFormat(SBLRec);

        with SBLRec do
          SBL := Section + Subsection + Block +
                 Lot + Sublot + Suffix;

        MapCondoTable.IndexName := 'BySwisCode_SBL';

        Result := FindKeyOld(MapCondoTable, ['SwisCode', 'SBL'], [SBLRec.SwisCode, SBL]);

      end;  {If (ANSIUpperCase(MapSetupObject.PASIndex) = 'BYTAXROLLYR_SBLKEY')}

end;  {FindCondominiumForMapRecord}

{==================================================================}
Function FindCondominium(MapCondoTable : TTable;
                         SwisSBLKey : String) : Boolean;

begin
  MapCondoTable.IndexName := 'BySwisCode_SBL';
  Result := _Locate(MapCondoTable, [Copy(SwisSBLKey, 1, 6), Copy(SwisSBLKey, 7, 30)], '', []);

end;  {FindCondominium}

{==================================================================}
Procedure AddCondoUnitsToListForBaseCondoID(ParcelTable : TTable;
                                            BaseSwisSBLKey : String;
                                            AssessmentYear : String;
                                            CondominiumUnitList : TStringList);

var
  Done, FirstTimeThrough : Boolean;

begin
  CondominiumUnitList.Clear;
  _Locate(ParcelTable, [AssessmentYear, BaseSwisSBLKey], '', [loParseSwisSBLKey, loPartialKey]);

  Done := False;
  FirstTimeThrough := True;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else ParcelTable.Next;

    If ParcelTable.EOF
      then Done := True;

    If ((not Done) and
        (Take(19, BaseSwisSBLKey) = Take(19, ExtractSSKey(ParcelTable))))
      then CondominiumUnitList.Add(ExtractSSKey(ParcelTable))
      else Done := True;

  until Done;

end;  {AddCondoUnitsToListForBaseCondoID}

{====================================================================================}
Function GetAV_SP_DecimalDisplayFormat(MapSetupObject : TMapSetupObject) : String;

begin
  Result := '0.' +
            ConstStr('0', MapSetupObject.AV_SP_Ratio_Decimals) +
            ';0.' +
            ConstStr('0', MapSetupObject.AV_SP_Ratio_Decimals) + ';' +
            '''' + '''';

end;  {GetAV_SP_DecimalDisplayFormat}

{====================================================================================}
Function GetScale(    Form : TForm;
                      CurrentRect : IMoRectangle;
                      Map : TMap;
                  var ScaleX : Extended;
                  var ScaleY : Extended) : Extended;

{Since this is only used for display purposes, we will set the result to the X scale.}

var
  PixelsPerInch : Integer;
  ControlInchesX, ControlInchesY,
  MapExtentX, MapExtentY : Extended;

begin
  MapExtentX := CurrentRect.Extent.Width;
  MapExtentY := CurrentRect.Extent.Height;
  PixelsPerInch := Form.PixelsPerInch;
  ControlInchesX := (Map.Width / PixelsPerInch);
  ControlInchesY := (Map.Height / PixelsPerInch);

  ScaleX := MapExtentX / ControlInchesX;
  ScaleY := MapExtentY / ControlInchesY;

  Result := ScaleX;

end;  {GetScale}

end.
