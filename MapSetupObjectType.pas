unit MapSetupObjectType;

interface

uses Graphics, Classes, WinUtils, MapObjects2_TLB, Dialogs, SysUtils, GlblCnst,
     FileCtrl;

type
  LayerRecord = record
    LayerName : String;
    LayerFileName : String;
    LayerPathName : String;
    MainLayer : Boolean;
    Visible : Boolean;
    Transparent : Boolean;
    LayerColor : LongInt;
    LayerType : String;
    FillType : LongInt;
    LayerOrder : LongInt;
    UseLabelPlacer : Boolean;
    UseLabelRenderer : Boolean;
    TextField : String;
    XOffsetField : String;
    YOffsetField : String;
    RotationField : String;
    SplinedText : Boolean;
    Flip : Boolean;
    DrawBackground : Boolean;
    HeightField : String;
    SymbolField : String;
    LevelField : String;
    PlaceAbove : Boolean;
    PlaceBelow : Boolean;
    PlaceOn : Boolean;
  end;

  LayerPointer = ^LayerRecord;

  TMapSetupObject = class
  private
    FLayerList : TList;
  public
    SetupName : String;
    DefaultZoomPercentToDrawDetails : Double;
    MapFileKeyField : String;
    PASKeyField : String;
    PASIndex : String;
    LabelColor : LongInt;
    LabelType : Integer;
    FillColor : LongInt;
    FillType : Integer;
    DashDotSBLFormat : Boolean;
    UseMapParcelIDFormat : Boolean;
    AV_SP_Ratio_Decimals : Integer;

    Constructor Create;
    Function GetLayerCount : Integer;
    Procedure AddLayer(_LayerName : String;
                       _LayerFile : String;
                       _MainLayer : Boolean;
                       _LayerColor : LongInt;
                       _Visible : Boolean;
                       _Transparent : Boolean;
                       _LayerType : String;
                       _FillType : LongInt;
                       _LayerOrder : LongInt;
                       _UseLabelPlacer : Boolean;
                       _UseLabelRenderer : Boolean;
                       _TextField : String;
                       _XOffsetField : String;
                       _YOffsetField : String;
                       _RotationField : String;
                       _SplinedText : Boolean;
                       _Flip : Boolean;
                       _DrawBackground : Boolean;
                       _HeightField : String;
                       _SymbolField : String;
                       _LevelField : String;
                       _PlaceAbove : Boolean;
                       _PlaceBelow : Boolean;
                       _PlaceOn : Boolean);

    Function GetLayerName(I : Integer) : String;
    Function GetLayerColor(LayerName : String) : LongInt;
    Function GetLayerLocation(LayerName : String) : String;
    Function GetLayerType(LayerName : String) : String;
    Function GetLayerDatabaseName(LayerName : String) : String;
    Function GetLayerFillType(LayerName : String) : LongInt;
    Function GetLayerOrder(LayerName : String) : LongInt;
    Function GetTextFieldName(LayerName : String) : String;
    Function GetXOffsetFieldName(LayerName : String) : String;
    Function GetYOffsetFieldName(LayerName : String) : String;
    Function GetRotationFieldName(LayerName : String) : String;
    Function UseLabelPlacer(LayerName : String) : Boolean;
    Function UseLabelRenderer(LayerName : String) : Boolean;
    Function IsMainLayer(LayerName : String) : Boolean;
    Function MapLayerIsVisible(LayerName : String) : Boolean;
    Function MapLayerIsTransparent(LayerName : String) : Boolean;
    Procedure SetLayerVisible(LayerName : String;
                              IsVisible : Boolean);
    Procedure SortLayersByLayerOrder;
    Procedure Clear;
    Destructor Destroy; override;
  end;

const
  lyMain = -1;

implementation

uses Utilitys;

{=============================================================}
Constructor TMapSetupObject.Create;

begin
  inherited Create;
  FLayerList := TList.Create;
end;  {Create}

{=============================================================}
Function TMapSetupObject.GetLayerCount : Integer;

begin
  Result := FLayerList.Count;
end;

{=============================================================}
Procedure TMapSetupObject.AddLayer(_LayerName : String;
                                   _LayerFile : String;
                                   _MainLayer : Boolean;
                                   _LayerColor : LongInt;
                                   _Visible : Boolean;
                                   _Transparent : Boolean;
                                   _LayerType : String;
                                   _FillType : LongInt;
                                   _LayerOrder : LongInt;
                                   _UseLabelPlacer : Boolean;
                                   _UseLabelRenderer : Boolean;
                                   _TextField : String;
                                   _XOffsetField : String;
                                   _YOffsetField : String;
                                   _RotationField : String;
                                   _SplinedText : Boolean;
                                   _Flip : Boolean;
                                   _DrawBackground : Boolean;
                                   _HeightField : String;
                                   _SymbolField : String;
                                   _LevelField : String;
                                   _PlaceAbove : Boolean;
                                   _PlaceBelow : Boolean;
                                   _PlaceOn : Boolean);


var
  LayerPtr : LayerPointer;

begin
  New(LayerPtr);

  with LayerPtr^ do
    begin
      LayerName := _LayerName;
      LayerFileName := StripPath(_LayerFile);
      LayerPathName := ReturnPath(_LayerFile);

        {FXX04302003-2(2.07): If the directory does not exist, try locally.}

      If not DirectoryExists(LayerPathName)
        then LayerPathName := ChangeLocationToLocalDrive(LayerPathName);

      MainLayer := _MainLayer;
      LayerColor := _LayerColor;
      Visible := _Visible;
      Transparent := _Transparent;
      LayerType := _LayerType;

        {CHG08052004-1(M1.5): Add fill type and layer order.}

      FillType := _FillType;
      LayerOrder := _LayerOrder;

         {CHG02172005-1(M1.6): Add label \ renderer options t layers.}

       UseLabelPlacer := _UseLabelPlacer;
       UseLabelRenderer := _UseLabelRenderer;
       TextField := _TextField;
       XOffsetField := _XOffsetField;
       YOffsetField := _YOffsetField;

       RotationField := _RotationField;
       SplinedText := _SplinedText;
       Flip := _Flip;
       DrawBackground := _DrawBackground;
       HeightField := _HeightField;
       SymbolField := _SymbolField;
       LevelField := _LevelField;
       PlaceAbove := _PlaceAbove;
       PlaceBelow := _PlaceBelow;
       PlaceOn := _PlaceOn;

    end;  {with LayerPtr^ do}

    {Always make sure the main layer is the first layer in the list.}

  If _MainLayer
    then FLayerList.Insert(0, LayerPtr)
    else FLayerList.Add(LayerPtr);

end;  {AddLayer}

{===================================================}
Function TMapSetupObject.GetLayerName(I : Integer) : String;

begin
  try
    Result := LayerPointer(FLayerList[I])^.LayerName;
  except
    MessageDlg('Can not get layer name for layer # ' + IntToStr(I) + '.',
               mtError, [mbOK], 0);
    Abort;
  end;

end;  {GetLayerName}

{===================================================}
Function TMapSetupObject.GetLayerDatabaseName(LayerName : String) : String;

var
  I : Integer;

begin
  Result := '';

  For I := 0 to (FLayerList.Count - 1) do
    If ((LayerPointer(FLayerList[I])^.LayerName = LayerName) or
        ((LayerName = 'MAIN') and
          LayerPointer(FLayerList[I])^.MainLayer))
      then Result := LayerPointer(FLayerList[I])^.LayerPathName;

end;  {GetLayerDatabaseName}

{===================================================}
Function TMapSetupObject.GetLayerLocation(LayerName : String) : String;

var
  I : Integer;

begin
  Result := '';

  For I := 0 to (FLayerList.Count - 1) do
    If ((LayerPointer(FLayerList[I])^.LayerName = LayerName) or
        ((LayerName = 'MAIN') and
          LayerPointer(FLayerList[I])^.MainLayer))
      then Result := LayerPointer(FLayerList[I])^.LayerFileName;

end;  {GetLayerLocation}

{===================================================}
Function TMapSetupObject.GetLayerColor(LayerName : String) : LongInt;

var
  I : Integer;

begin
  Result := moPaleYellow;

  For I := 0 to (FLayerList.Count - 1) do
    If ((LayerPointer(FLayerList[I])^.LayerName = LayerName) or
        ((LayerName = 'MAIN') and
          LayerPointer(FLayerList[I])^.MainLayer))
      then Result := LayerPointer(FLayerList[I])^.LayerColor;

end;  {GetLayerColor}

{===================================================}
Function TMapSetupObject.GetLayerType(LayerName : String) : String;

var
  I : Integer;

begin
  Result := '';

  For I := 0 to (FLayerList.Count - 1) do
    If ((LayerPointer(FLayerList[I])^.LayerName = LayerName) or
        ((LayerName = 'MAIN') and
          LayerPointer(FLayerList[I])^.MainLayer))
      then Result := LayerPointer(FLayerList[I])^.LayerType;

end;  {GetLayerType}

{===================================================}
Function TMapSetupObject.GetLayerFillType(LayerName : String) : LongInt;

var
  I : Integer;

begin
  Result := moTransparentFill;

  For I := 0 to (FLayerList.Count - 1) do
    If ((LayerPointer(FLayerList[I])^.LayerName = LayerName) or
        ((LayerName = 'MAIN') and
          LayerPointer(FLayerList[I])^.MainLayer))
      then Result := LayerPointer(FLayerList[I])^.FillType;

end;  {GetLayerFillType}

{===================================================}
Function TMapSetupObject.GetLayerOrder(LayerName : String) : LongInt;

var
  I : Integer;

begin
  Result := 0;

  For I := 0 to (FLayerList.Count - 1) do
    If ((LayerPointer(FLayerList[I])^.LayerName = LayerName) or
        ((LayerName = 'MAIN') and
          LayerPointer(FLayerList[I])^.MainLayer))
      then Result := LayerPointer(FLayerList[I])^.LayerOrder;

end;  {GetLayerOrder}

{===================================================}
Function TMapSetupObject.GetTextFieldName(LayerName : String) : String;

var
  I : Integer;

begin
  Result := '';

  For I := 0 to (FLayerList.Count - 1) do
    If ((LayerPointer(FLayerList[I])^.LayerName = LayerName) or
        ((LayerName = 'MAIN') and
          LayerPointer(FLayerList[I])^.MainLayer))
      then Result := LayerPointer(FLayerList[I])^.TextField;

end;  {GetTextFieldName}

{===================================================}
Function TMapSetupObject.GetXOffsetFieldName(LayerName : String) : String;

var
  I : Integer;

begin
  Result := '';

  For I := 0 to (FLayerList.Count - 1) do
    If ((LayerPointer(FLayerList[I])^.LayerName = LayerName) or
        ((LayerName = 'MAIN') and
          LayerPointer(FLayerList[I])^.MainLayer))
      then Result := LayerPointer(FLayerList[I])^.XOffsetField;

end;  {GetXOffsetFieldName}

{===================================================}
Function TMapSetupObject.GetYOffsetFieldName(LayerName : String) : String;

var
  I : Integer;

begin
  Result := '';

  For I := 0 to (FLayerList.Count - 1) do
    If ((LayerPointer(FLayerList[I])^.LayerName = LayerName) or
        ((LayerName = 'MAIN') and
          LayerPointer(FLayerList[I])^.MainLayer))
      then Result := LayerPointer(FLayerList[I])^.YOffsetField;

end;  {GetYOffsetFieldName}

{===================================================}
Function TMapSetupObject.GetRotationFieldName(LayerName : String) : String;

var
  I : Integer;

begin
  Result := '';

  For I := 0 to (FLayerList.Count - 1) do
    If ((LayerPointer(FLayerList[I])^.LayerName = LayerName) or
        ((LayerName = 'MAIN') and
          LayerPointer(FLayerList[I])^.MainLayer))
      then Result := LayerPointer(FLayerList[I])^.RotationField;

end;  {GetRotationFieldName}

{===================================================}
Function TMapSetupObject.UseLabelPlacer(LayerName : String) : Boolean;

var
  I : Integer;

begin
  Result := False;

  For I := 0 to (FLayerList.Count - 1) do
    If ((LayerPointer(FLayerList[I])^.LayerName = LayerName) or
        ((LayerName = 'MAIN') and
          LayerPointer(FLayerList[I])^.MainLayer))
      then Result := LayerPointer(FLayerList[I])^.UseLabelPlacer;

end;  {UseLabelPlacer}

{===================================================}
Function TMapSetupObject.UseLabelRenderer(LayerName : String) : Boolean;

var
  I : Integer;

begin
  Result := False;

  For I := 0 to (FLayerList.Count - 1) do
    If ((LayerPointer(FLayerList[I])^.LayerName = LayerName) or
        ((LayerName = 'MAIN') and
          LayerPointer(FLayerList[I])^.MainLayer))
      then Result := LayerPointer(FLayerList[I])^.UseLabelRenderer;

end;  {UseLabelRenderer}

{======================================================}
Function TMapSetupObject.IsMainLayer(LayerName : String) : Boolean;


var
  I : Integer;

begin
  Result := False;

  For I := 0 to (FLayerList.Count - 1) do
    If ((LayerPointer(FLayerList[I])^.LayerName = LayerName) and
        LayerPointer(FLayerList[I])^.MainLayer)
      then Result := True;

end;  {IsMainLayer}

{======================================================}
Function TMapSetupObject.MapLayerIsVisible(LayerName : String) : Boolean;


var
  I : Integer;

begin
  Result := False;

  For I := 0 to (FLayerList.Count - 1) do
    If ((LayerPointer(FLayerList[I])^.LayerName = LayerName) and
        (LayerPointer(FLayerList[I])^.Visible or
         LayerPointer(FLayerList[I])^.MainLayer))
      then Result := True;

end;  {MapLayerIsVisible}

{======================================================}
Function TMapSetupObject.MapLayerIsTransparent(LayerName : String) : Boolean;


var
  I : Integer;

begin
  Result := False;

  For I := 0 to (FLayerList.Count - 1) do
    If ((LayerPointer(FLayerList[I])^.LayerName = LayerName) and
        (LayerPointer(FLayerList[I])^.Transparent or
         LayerPointer(FLayerList[I])^.MainLayer))
      then Result := True;

end;  {MapLayerIsTransparent}

{=======================================================}
Procedure TMapSetupObject.SortLayersByLayerOrder;

var
  I, J : Integer;
  TempPointer : Pointer;

begin
  For I := 0 to (FLayerList.Count - 1) do
    For J := (I + 1) to (FLayerList.Count - 1) do
      If (LayerPointer(FLayerList[J])^.LayerOrder < LayerPointer(FLayerList[I])^.LayerOrder)
        then
          begin
            TempPointer := FLayerList[I];
            FLayerList[I] := FLayerList[J];
            FLayerList[J] := TempPointer;
          end;

end;  {SortLayersByLayerOrder}

{=======================================================}
Procedure TMapSetupObject.SetLayerVisible(LayerName : String;
                                          IsVisible : Boolean);

var
  I : Integer;

begin
  For I := 0 to (FLayerList.Count - 1) do
    If (LayerPointer(FLayerList[I])^.LayerName = LayerName)
      then LayerPointer(FLayerList[I])^.Visible := IsVisible;

end;  {SetLayerVisible}

{===================================================}
Procedure TMapSetupObject.Clear;

begin
  ClearTList(FLayerList, SizeOf(LayerRecord));
end;

{===================================================}
Destructor TMapSetupObject.Destroy;

begin
  FreeTList(FLayerList, SizeOf(LayerRecord));
  inherited Destroy;

end;  {Destroy}


end.
