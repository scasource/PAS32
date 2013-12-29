unit MappingForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  OleCtrls, MapObjects2_TLB, ExtCtrls, ComCtrls,
  Buttons, StdCtrls, ComObj, ActiveX, Db, DBTables, DLL96V1, Wwtable,
  MapSetupObjectType;

type
  TMappingForm = class(TForm)
    Panel1: TPanel;
    Splitter: TSplitter;
    Map: TMap;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    PropTabSheet3: TTabSheet;
    Label19: TLabel;
    ExemptionListBox: TListBox;
    SpecialDistrictListBox: TListBox;
    Label1: TLabel;
    Label21: TLabel;
    RollSectionListBox: TListBox;
    ToolbarPanel: TPanel;
    PanUpButton: TSpeedButton;
    SBZoomIn: TSpeedButton;
    SBZoomOut: TSpeedButton;
    PrintMapSpeedButton: TSpeedButton;
    PanDownButton: TSpeedButton;
    PanLeftButton: TSpeedButton;
    PanRightButton: TSpeedButton;
    ApplySpeedButton: TSpeedButton;
    LoadLayerButton: TBitBtn;
    ClearLayerButton: TBitBtn;
    ClearAllButton: TBitBtn;
    LoadFromParcelListButton: TBitBtn;
    CreateParcelListButton: TBitBtn;
    MapTimer: TTimer;
    LoadingPanel: TPanel;
    ProgressBar: TProgressBar;
    Label2: TLabel;
    OpenDialog: TOpenDialog;
    ExemptionCodeTable: TTable;
    SDCodeTable: TTable;
    TabSheet3: TTabSheet;
    Label3: TLabel;
    SwisCodeListBox: TListBox;
    Label4: TLabel;
    SchoolCodeListBox: TListBox;
    SchoolCodeTable: TTable;
    SwisCodeTable: TTable;
    ChooseAssessmentYearRadioGroup: TRadioGroup;
    EditHistoryYear: TEdit;
    PropertyClassListBox: TListBox;
    Label5: TLabel;
    PropertyClassTable: TTable;
    ParcelLookupTable: TTable;
    CloseMappingButton: TBitBtn;
    FullSizeButton: TSpeedButton;
    SysRecTable: TTable;
    AssessmentYearControlTable: TTable;
    ParcelEXTable: TTable;
    ParcelSDTable: TTable;
    MappingSetupButton: TBitBtn;
    MappingHeaderTable: TTable;
    MappingDetailTable: TwwTable;
    procedure MapTimerTimer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure PanButtonClick(Sender: TObject);
    procedure SBZoomInClick(Sender: TObject);
    procedure SBZoomOutClick(Sender: TObject);
    procedure ApplySpeedButtonClick(Sender: TObject);
    procedure ClearAllButtonClick(Sender: TObject);
    procedure LoadLayerButtonClick(Sender: TObject);
    procedure MapMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure MapAfterLayerDraw(Sender: TObject; index: Smallint;
      canceled: WordBool; hDC: Cardinal);
    procedure ClearLayerButtonClick(Sender: TObject);
    procedure CreateParcelListButtonClick(Sender: TObject);
    procedure LoadFromParcelListButtonClick(Sender: TObject);
    procedure CloseMappingButtonClick(Sender: TObject);
    procedure FullSizeButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure PrintMapSpeedButtonClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    MainLayer : IMoMapLayer;
    dc : IMoDataConnection;
    LoadingComps, CreateParcelList,
    LoadFromParcelList, ApplyingChanges : Boolean;

    SelectedSwisCodes, SelectedSchoolCodes,
    SelectedPropertyClasses, SelectedRollSections,
    SelectedSDCodes, SelectedEXCodes : TStringList;
    MapInfoFormList : TList;

    ProcessingType : Integer;
    CompsFileName, AssessmentYear : String;
    LayerList : TStringList;
    FullSizeRect : IMoRectangle;

    MapSetupObject : TMapSetupObject;

    Procedure SetMapOptions(MappingSetupName : String;
                            DefaultSetup : Boolean);
    Function ParcelMeetsCriteria(ParcelLookupTable : TTable) : Boolean;
  end;

var
  MapForm : TMappingForm;

implementation

{$R *.DFM}

uses WinUtils, PASUtils, GlblVars, Glblcnst, MapParcelInfoDialog,
     PrclList, Utilitys;

const
  ptThisYear = 1;
  ptNextYear = 0;
  ptHistory = 2;

{==========================================================================}
Procedure TMappingForm.SetMapOptions(MappingSetupName : String;
                                     DefaultSetup : Boolean);

var
  FirstTimeThrough, Done : Boolean;
  DefaultLayerName, LayerName : String;
  LayerPtr : LayerPointer;

begin
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

    end;  {with MappingHeaderTable do}

    {Now get the autoload layers.}

  Done := False;
  FirstTimeThrough := True;

  MappingDetailTable.First;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else MappingDetailTable.Next;

    If MappingDetailTable.EOF
      then Done := True;

    If not Done
      then
        with MappingDetailTable do
          MapSetupObject.AddLayer(FieldByName('LayerName').Text,
                                  FieldByName('MainLayer').AsBoolean);

  until Done;

end;  {SetMapOptions}

{==========================================================================}
Procedure TMappingForm.FormCreate(Sender: TObject);

var
  I : Integer;
  TempStr : String;
  EqualsPos : Integer;

begin
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

  SysRecTable.Close;  {Close right away so hopefully don't get in use errors when all go in at once.}

  OpenTablesForForm(Self, GlblProcessingType);

  SetGlobalSBLSegmentFormats(AssessmentYearControlTable);

(*  SetFormStateMaximized(Self); *)
  ApplyingChanges := False;
  LoadFromParcelList := False;
  CreateParcelList := False;

  LayerList := TStringList.Create;

  GlblProcessingType := NextYear;
  GlblTaxYearFlg := 'N';

  AssessmentYear := GetTaxRlYr;

  SelectedSwisCodes := TStringList.Create;
  SelectedSchoolCodes := TStringList.Create;
  SelectedPropertyClasses := TStringList.Create;
  SelectedRollSections := TStringList.Create;
  SelectedSDCodes := TStringList.Create;
  SelectedEXCodes := TStringList.Create;

  FillOneListBox(ExemptionListBox, ExemptionCodeTable, 'EXCode',
                 'Description', 10, True, True, GlblProcessingType, AssessmentYear);
  FillOneListBox(SpecialDistrictListBox, SDCodeTable, 'SDistCode',
                 'Description', 10, True, True, GlblProcessingType, AssessmentYear);
  FillOneListBox(SwisCodeListBox, SwisCodeTable, 'SwisCode',
                 'MunicipalityName', 10, True, True, GlblProcessingType, AssessmentYear);
  FillOneListBox(SchoolCodeListBox, SchoolCodeTable, 'SchoolCode',
                 'SchoolName', 10, True, True, GlblProcessingType, AssessmentYear);
  FillOneListBox(PropertyClassListBox, PropertyClassTable,
                 'MainCode', 'Description',
                 10, True, True, GlblProcessingType, AssessmentYear);

  SelectItemsInListBox(RollSectionListBox);

  case GlblProcessingType of
    ThisYear : ChooseAssessmentYearRadioGroup.ItemIndex := ptThisYear;
    NextYear : ChooseAssessmentYearRadioGroup.ItemIndex := ptNextYear;
    History :
      begin
        ChooseAssessmentYearRadioGroup.ItemIndex := ptHistory;
        EditHistoryYear.Text := GlblHistYear;
        EditHistoryYear.Visible := True;
      end;

  end;  {case GlblProcessingType of}

  MapTimer.Enabled := True;
  MapInfoFormList := TList.Create;

  WindowState := wsMaximized;
  CompsFileName := '';
  LoadingComps := False;

  For I := 1 to ParamCount do
    begin
      TempStr := ParamStr(I);

      If (Pos('COMPS', ANSIUppercase(TempStr)) > 0)
        then
          begin
            EqualsPos := Pos('=', TempStr);
            CompsFileName := Trim(Copy(TempStr, (EqualsPos + 1), 200));
            LoadingComps := True;

          end;  {If (Pos('COMPS', ANSIUppercase(TempStr)) > 0)}

    end;  {For I := 1 to ParamCount do}

    {Set the default map setup options.}

  MapSetupObject := TMapSetupObject.Create;

  SetMapOptions('', True);

  ParcelTable.IndexName := MapSetupObject.PASIndex;

end;  {FormCreate}

{==========================================================================}
Procedure TMappingForm.MapTimerTimer(Sender: TObject);

begin
  MapTimer.Enabled := False;
  dc := IMoDataConnection(CreateOleObject('MapObjects2.DataConnection'));
  dc.database := GlblMapDirectory;
  MainLayer := IMoMapLayer(CreateOleObject('MapObjects2.Maplayer'));
  MainLayer.Geodataset := dc.FindGeoDataset(MapSetupObject.GetLayerName(lyMain));

  Map.Layers.Add(MainLayer);
  FullSizeRect := IMoRectangle(CreateOleObject('MapObjects2.Rectangle'));
  FullSizeRect := Map.Extent;

end;  {MapTimerTimer}

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
  recs : IMoRecordset;
  fld  : IMoField;
  p : IMoPolygon;
  CompsAreaRect, CurrentRect : IMoRectangle;
  tsym   : IMoTextSymbol;
  sym   : IMoSymbol;
  ft    : TFont;
  oleFt : variant;
  CurrentZoomPercent : Double;
  TextBaseLine : IMoLine;
  Point : IMoPoint;
  CompNumber, RecCount : LongInt;
  Points : IMoPoints;
  CompsFile : TextFile;
  CompsList : TStringList;
  TempStr, TempSearchStr : String;
  Done, Continue, FirstComp : Boolean;
  MapInfoForm : TMapParcelInfoForm;

begin
  If LoadFromParcelList
    then
      begin
        CurrentRect := IMoRectangle(CreateOleObject('MapObjects2.Rectangle'));
        CurrentRect := Map.Extent;
        recs := MainLayer.SearchShape(CurrentRect, moAreaIntersect, '');
        recs.MoveFirst;

        LoadingPanel.Visible := True;
        Application.ProcessMessages;
        RecCount := 0;
        ProgressBar.Max := GetRecordCount(ParcelLookupTable);

        while not Recs.EOF do
          begin
            If (FindKeyOld(ParcelLookupTable, [MapSetupObject.PASKeyField],
                           [Recs.Fields.Item(MapSetupObject.MapFileKeyField).Value]) and
                ParcelListDialog.ParcelExistsInList(ExtractSSKey(ParcelLookupTable)))
              then
                begin
                  fld := recs.Fields.item('Shape');
                  p := IMoPolygon(CreateOleObject('MapObjects2.Polygon'));
                  p :=IMoPolygon(IDispatch(fld.value));

                  sym :=IMoSymbol(CreateOleObject('MapObjects2.Symbol'));
                  sym.Style := moDiagonalCrossFill;
                  sym.color :=clBlue;

                  Map.DrawShape(p, sym);

                end;  {If (FindKeyOld(ParcelLookupTable, ['AccountNo'], ...}

            RecCount := RecCount + 1;
            ProgressBar.Position := RecCount;
            Application.ProcessMessages;

            recs.MoveNext;

          end;  {while not Recs.EOF do}

        LoadingPanel.Visible := False;

      end;  {If LoadFromParcelList}

  If ApplyingChanges
    then
      begin
        CurrentRect := IMoRectangle(CreateOleObject('MapObjects2.Rectangle'));
        CurrentRect := Map.Extent;
        recs := MainLayer.SearchShape(CurrentRect, moAreaIntersect, '');
        recs.MoveFirst;
        LoadingPanel.Visible := True;
        Application.ProcessMessages;
        RecCount := 0;
        ProgressBar.Max := GetRecordCount(ParcelLookupTable);

        while not Recs.EOF do
          begin
            If (FindKeyOld(ParcelLookupTable, [MapSetupObject.PASKeyField],
                           [Recs.Fields.Item('Acct_Num').Value]) and
                ParcelMeetsCriteria(ParcelLookupTable))
              then
                begin
                  fld := recs.Fields.item('Shape');
                  p := IMoPolygon(CreateOleObject('MapObjects2.Polygon'));
                  p :=IMoPolygon(IDispatch(fld.value));

                  sym :=IMoSymbol(CreateOleObject('MapObjects2.Symbol'));
                  sym.Style := moDiagonalCrossFill;
                  sym.color :=clBlue;

                  Map.DrawShape(p, sym);

                  If CreateParcelList
                    then ParcelListDialog.AddOneParcel(ExtractSSKey(ParcelLookupTable));

                end;  {If (FindKeyOld(ParcelLookupTable, ['AccountNo'], ...}

            RecCount := RecCount + 1;
            ProgressBar.Position := RecCount;
            Application.ProcessMessages;

            recs.MoveNext;

          end;  {while not Recs.EOF do}

        LoadingPanel.Visible := False;
        CreateParcelList := False;
        ApplyingChanges := False;

      end;  {If ApplyingChanges}

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

  If not (ApplyingChanges or LoadFromParcelList or LoadingComps)
    then
      begin
        with Map do
          CurrentZoomPercent := Extent.Height / FullExtent.Height;

        If (CurrentZoomPercent < MapSetupObject.DefaultZoomPercentToDrawDetails)
          then
            begin
              CurrentRect := IMoRectangle(CreateOleObject('MapObjects2.Rectangle'));
              CurrentRect := Map.Extent;

              ft := TFont.Create;
              ft.Name := 'Courier';
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

                  Point.X := P.Extent.Right;
                  Point.Y := P.Extent.Top - P.Extent.Height/3;
                  Points.Add(Point);

                  Point.X := P.Extent.Left;
                  Point.Y := P.Extent.Top - P.Extent.Height/3;
                  Points.Add(Point);

                  TextBaseLine.Parts.Add(Points);
                  tsym :=IMoTextSymbol(CreateOleObject('MapObjects2.TextSymbol'));

                  tsym.color :=clBlue;
                  tsym.HorizontalAlignment := moAlignCenter;
                  tsym.VerticalAlignment := moAlignCenter;
                  tsym.Fitted := False;
                  tsym.Height := 0;
                  tsym.Font := IFontDisp(IDispatch(oleFt));

                  FindNearestOld(ParcelLookupTable, [MapSetupObject.PASKeyField],
                                 [Recs.Fields.Item('Acct_Num').Value]);

                  If CreateParcelList
                    then ParcelListDialog.AddOneParcel(ExtractSSKey(ParcelLookupTable));

                  Map.DrawText(ConvertSwisSBLToDashDot(ExtractSSKey(ParcelLookupTable)),
                               TextBaseLine,tsym);

                  recs.MoveNext;

                end;  {while not Recs.EOF do}

            end;  {If (CurrentZoomPercent < 0.01)}

        CreateParcelList := False;

      end;  {else of If ApplyingChanges}

end;  {MapAfterLayerDraw}

{========================================================}
Procedure TMappingForm.PanButtonClick(Sender: TObject);

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
  Map.Enabled := False;
  Map.Enabled := True;

end;  {PanButtonClick}

{========================================================}
Procedure TMappingForm.SBZoomInClick(Sender: TObject);

var
  ZoomInRect : IMoRectangle;

begin
  ZoomInRect := IMoRectangle(CreateOleObject('MapObjects2.Rectangle'));
  ZoomInRect := Map.Extent;
  ZoomInRect.ScaleRectangle(variant(0.5));
  Map.Extent := ZoomInrect;
  Map.Enabled := False;
  Map.Enabled := True;

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
(*  Map.RefreshLayer(0, Map.Extent);*)
  Map.RefreshRect(Map.Extent);
  Map.Enabled := False;
  Map.Enabled := True;

end;  {SBZoomOutClick}

{========================================================}
Procedure TMappingForm.LoadLayerButtonClick(Sender: TObject);

var
  Layer : IMoMapLayer;

begin
  If OpenDialog.Execute
    then
      begin
        Layer := IMoMapLayer(CreateOleObject('MapObjects2.Maplayer'));
        Layer.Geodataset := dc.FindGeoDataset(StripPath(OpenDialog.FileName));
        LayerList.Add(StripPath(OpenDialog.FileName));
        ApplyingChanges := False;

        Map.Layers.Add(Layer);

      end;  {If OpenDialog}

end;  {LoadLayerButtonClick}

{========================================================}
Procedure TMappingForm.ClearLayerButtonClick(Sender: TObject);

var
  Index : Integer;

begin
(*  If ChooseItemInListDialog.Execute
    then
      begin
        Index := ChooseItemInListDialog.Index;
        Map.Layers.Remover(Index);
        LayerList.Delete(Index);

      end;  {If ChooseItemInListDialog.Execute} *)

end;  {ClearLayerButtonClick}

{========================================================}
Procedure TMappingForm.ClearAllButtonClick(Sender: TObject);

var
  I : Integer;

begin
  For I := 0 to (Map.Layers.Count - 1) do
    Map.Layers.Remove(0);

  LayerList.Clear;

    {Load back the main layer.}

  MapTimerTimer(Sender);

end;  {ClearAllButtonClick}

{========================================================}
Procedure TMappingForm.ApplySpeedButtonClick(Sender: TObject);

{Clear the map and adjust to the SDs\Ex\RS\Property classes they selected.}

var
  Quit : Boolean;

begin
  ApplyingChanges := True;
  LoadFromParcelList := False;
  CreateParcelList := False;

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
    0 : begin
          ProcessingType := ThisYear;
          AssessmentYear := GlblThisYear;
        end;

    1 : begin
          ProcessingType := NextYear;
          AssessmentYear := GlblNextYear;
        end;

    2 : begin
          ProcessingType := History;
          AssessmentYear := EditHistoryYear.Text;;
        end;

  end;  {case ChooseAssessmentYearRadioGroup.ItemIndex of}

  OpenTableForProcessingType(ParcelEXTable, ExemptionsTableName,
                             ProcessingType, Quit);
  OpenTableForProcessingType(ParcelSDTable, SpecialDistrictTableName,
                             ProcessingType, Quit);

  Map.Refresh;

end;  {ApplySpeedButtonClick}

{========================================================}
Procedure TMappingForm.FullSizeButtonClick(Sender: TObject);

begin
  Map.Extent := FullSizeRect;
end;  {FullSizeButtonClick}

{========================================================}
Procedure TMappingForm.MapMouseDown(Sender: TObject;
                                    Button: TMouseButton;
                                    Shift: TShiftState;
                                    X, Y: Integer);

var
  P : IMoPoint;
  recs : IMoRecordset;
  MapInfoForm : TMapParcelInfoForm;

begin
  LockWindowUpdate(Handle);
  MapInfoForm := TMapParcelInfoForm.Create(Application);

  with MapInfoForm do
    begin
      Left := Mouse.CursorPos.X;
      Top := Mouse.CursorPos.Y;

      p := IMoPoint(CreateOleObject('MapObjects2.Point'));
      p := Map.ToMapPoint(x,y);

      recs := MainLayer.SearchShape(p,12,'');

      If not Recs.EOF
        then
          begin
            Recs.MoveFirst;

            FindKeyOld(ParcelLookupTable, ['AccountNo'],
                       [Recs.Fields.Item('Acct_Num').Value]);

            FillInParcelInformation(ParcelLookupTable);

          end;  {If not Recs.EOF}

      Show;

    end;  {with MapParcelInfoForm do}

  MapInfoFormList.Add(MapInfoForm);

  LockWindowUpdate(0);

end;  {MapMouseDown}

{========================================================}
Procedure TMappingForm.LoadFromParcelListButtonClick(Sender: TObject);

begin
  LoadFromParcelList := True;
  CreateParcelList := False;
  ApplyingChanges := False;
  Map.Refresh;

end;  {LoadFromParcelListButtonClick}

{========================================================}
Procedure TMappingForm.CreateParcelListButtonClick(Sender: TObject);

begin
  ParcelListDialog.ClearParcelGrid(True);
  CreateParcelList := True;
  LoadFromParcelList := False;

  Map.Refresh;
  ParcelListDialog.Show;

end;  {CreateParcelListClick}

{========================================================}
Procedure TMappingForm.PrintMapSpeedButtonClick(Sender: TObject);

begin
  Map.PrintMap('Map', '', False);
end;  {PrintMapSpeedButtonClick}

{========================================================}
Procedure TMappingForm.FormResize(Sender: TObject);

{Make sure the loading panel appears in the right place.}

begin
  LoadingPanel.Left := Map.Left + 1;
end;  {FormResize}

{========================================================}
Procedure TMappingForm.CloseMappingButtonClick(Sender: TObject);

begin
  Close;
end;

{========================================================}
Procedure TMappingForm.FormClose(    Sender: TObject;
                                 var Action: TCloseAction);

var
  I : Integer;

begin
  SelectedSwisCodes.Free;
  SelectedSchoolCodes.Free;
  SelectedPropertyClasses.Free;
  SelectedRollSections.Free;
  SelectedSDCodes.Free;
  SelectedEXCodes.Free;

  For I := 0 to (MapInfoFormList.Count - 1) do
    try
      TForm(MapInfoFormList[I]).Free;
    except
    end;

  MapSetupObject.Free;

  CloseTablesForForm(Self);

    {Free up the child window and set the ClosingAForm Boolean to
     true so that we know to delete the tab.}

  Action := caFree;
  GlblClosingAForm := True;
  GlblClosingFormCaption := Caption;

end;  {FormClose}


end.