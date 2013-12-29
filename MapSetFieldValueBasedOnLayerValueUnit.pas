unit MapSetFieldValueBasedOnLayerValueUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, wwdblook, RPFiler, RPDefine, RPBase, ComObj,
  RPCanvas, RPrinter, Db, DBTables, Wwtable, MapObjects2_TLB, MapSetupObjectType,
  ComCtrls, Grids;

type
  TSetFieldValueFromMapLayerDialog = class(TForm)
    ScreenLabelTable: TTable;
    TempTable: TTable;
    ReportPrinter: TReportPrinter;
    ReportFiler: TReportFiler;
    PrintDialog: TPrintDialog;
    UserFieldDefinitionTable: TTable;
    MapLayersAvailableTable: TwwTable;
    AssessmentYearControlTable: TTable;
    MapParcelIDFormatTable: TTable;
    ProgressBar: TProgressBar;
    ParcelLookupTable: TTable;
    CommercialSiteTable: TTable;
    ResidentialSiteTable: TTable;
    ResidentialBldgTable: TTable;
    CommercialBldgTable: TTable;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    SourceGroupBox: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    MapFieldComboBox: TComboBox;
    MapLayersLookupCombo: TwwDBLookupCombo;
    DestinationGroupBox: TGroupBox;
    Label5: TLabel;
    Label6: TLabel;
    ScreenComboBox: TComboBox;
    FieldComboBox: TComboBox;
    GroupBox1: TGroupBox;
    TrialRunCheckBox: TCheckBox;
    AssessmentYearRadioGroup: TRadioGroup;
    AddInventoryIfNeededCheckBox: TCheckBox;
    cb_CommercialParcelsOnly: TCheckBox;
    cb_ResidentialParcelsOnly: TCheckBox;
    Panel1: TPanel;
    StartButton: TBitBtn;
    CancelButton: TBitBtn;
    TabSheet2: TTabSheet;
    GroupBox2: TGroupBox;
    Label3: TLabel;
    ed_FieldToExcludeOn: TEdit;
    sg_Exclusions: TStringGrid;
    Label4: TLabel;
    procedure ScreenComboBoxChange(Sender: TObject);
    procedure MapLayersLookupComboCloseUp(Sender: TObject; LookupTable,
      FillTable: TDataSet; modified: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure StartButtonClick(Sender: TObject);
    procedure ReportPrintHeader(Sender: TObject);
    procedure ReportPrint(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    ScreenLabelList : TList;
    MapSetupObject : TMapSetupObject;
    SourceLayer, ParcelLayer : IMoMapLayer;
    FieldToExcludeOn,
    DestinationFieldName, DestinationTableName,
    SourceLayerName, SourceFieldName, AssessmentYear, UnitName : String;
    AddInventoryRecordsIfNeeded, TrialRun, Cancelled,
    CommercialParcelsOnly, ResidentialParcelsOnly : Boolean;
    ReportSection, ProcessingType : Integer;
    Map : TMap;
    ExclusionsList : TStringList;

    Procedure InitializeForm;

    Procedure AddInventorySite(AssessmentYear : String;
                               TableName : String;
                               SwisSBLKey : String);

  end;

var
  SetFieldValueFromMapLayerDialog: TSetFieldValueFromMapLayerDialog;

implementation

{$R *.DFM}

uses PASUtils, Prclocat, Utilitys, PASTypes, DataAccessUnit,
     GlblVars, GlblCnst, MapUtilitys, WinUtils, Preview;

const
  rsMain = 0;
  rsMultipleMatch = 1;

{========================================================}
Procedure FillChangeBoxes(ScreenComboBox,
                          FieldComboBox : TComboBox;
                          ScreenLabelList : TList;
                          FillScreenBox,
                          FillFieldBox : Boolean);

var
  I : Integer;

begin
    {Add blank items to the front of the list to blank it out.}

  If FillScreenBox
    then
      begin
        ScreenComboBox.Items.Clear;

        For I := 0 to (ScreenLabelList.Count - 1) do
          If (ScreenComboBox.Items.IndexOf(RTrim(ScreenLabelPtr(ScreenLabelList[I])^.ScreenName)) = -1)
            then ScreenComboBox.Items.Add(RTrim(ScreenLabelPtr(ScreenLabelList[I])^.ScreenName));

        ScreenComboBox.Items.Insert(0, '');

      end;  {If FillScreenBox}

  If FillFieldBox
    then
      begin
        FieldComboBox.Items.Clear;

        For I := 0 to (ScreenLabelList.Count - 1) do
          If (RTrim(ScreenLabelPtr(ScreenLabelList[I])^.ScreenName) =
              ScreenComboBox.Items[ScreenComboBox.ItemIndex])
            then FieldComboBox.Items.Add(RTrim(ScreenLabelPtr(ScreenLabelList[I])^.LabelName));

        FieldComboBox.Items.Insert(0, '');

      end;  {If FillFieldBox}

end;  {FillChangeBoxes}

{==================================================================}
Procedure TSetFieldValueFromMapLayerDialog.InitializeForm;

begin
  OpenTablesForForm(Self, NextYear);
  ScreenLabelList := TList.Create;
  UnitName := 'MapSetFieldValueBasedOnLayerValueUnit';
  ReportSection := rsMain;
  ExclusionsList := TStringList.Create;

  LoadScreenLabelList(ScreenLabelList, ScreenLabelTable, UserFieldDefinitionTable, True,
                      True, True, [slAll]);

  FillChangeBoxes(ScreenComboBox, FieldComboBox, ScreenLabelList, True, False);

end;  {InitializeForm}

{====================================================================}
Procedure TSetFieldValueFromMapLayerDialog.ScreenComboBoxChange(Sender: TObject);

{Synchronize the field combo box with the screen combo box.}

begin
  with Sender as TComboBox do
    If (Deblank(Text) = '')
      then FieldComboBox.ItemIndex := 0  {The first value is blank.}
      else FillChangeBoxes(TComboBox(Sender), FieldComboBox,
                           ScreenLabelList, False, True);

end;  {ScreenComboBoxChange}

{====================================================================}
Procedure TSetFieldValueFromMapLayerDialog.MapLayersLookupComboCloseUp(Sender: TObject;
                                                                       LookupTable,
                                                                       FillTable: TDataSet;
                                                                       modified: Boolean);

var
  dc : IMoDataConnection;
  LayerFileName, LayerDatabaseName : OLEVariant;
  RecordSet : IMORecordSet;
  FieldList : TStringList;
  TableDescription : IMoTableDesc;
  Fields : IMoFields;
  Field : IMoField;
  I : Integer;

begin
  SourceLayerName := MapLayersAvailableTable.FieldByName('LayerName').Text;
  dc := IMoDataConnection(CreateOleObject('MapObjects2.DataConnection'));

  LayerDatabaseName := MapSetupObject.GetLayerDatabaseName(SourceLayerName);
  dc.database := GetLayerTypePrefix(MapSetupObject.GetLayerType(SourceLayerName)) +
                 LayerDatabaseName;
  SourceLayer := IMoMapLayer(CreateOleObject('MapObjects2.MapLayer'));
  LayerFileName := MapSetupObject.GetLayerLocation(SourceLayerName);
  SourceLayer.Geodataset := dc.FindGeoDataset(LayerFileName);

  FieldList := TStringList.Create;

    {Go through based on the source layer.}

  RecordSet := SourceLayer.Records;
  Fields := RecordSet.Fields;
  TableDescription := IMoTableDesc(CreateOleObject('MapObjects2.TableDesc'));
  TableDescription := RecordSet.TableDesc;
  Fields := RecordSet.Fields;

  For I := 0 to (TableDescription.FieldCount - 1) do
    begin
      Field := Fields.Item(TableDescription.FieldName[I]);
      FieldList.Add(Field.Name);

    end;  {For I := 0 to (TableDescription.FieldCount - 1) do}

  MapFieldComboBox.Items.Assign(FieldList);
  FieldList.Free;

end;  {MapLayersLookupComboCloseUp}

{==================================================================}
Procedure TSetFieldValueFromMapLayerDialog.StartButtonClick(Sender: TObject);

var
  _ScreenName, _LabelName, NewFileName : String;
  I : Integer;
  Quit : Boolean;

begin
  CancelButton.Enabled := True;
  TrialRun := TrialRunCheckBox.Checked;
  ParcelLookupTable.IndexName := MapSetupObject.PASIndex;
  AddInventoryRecordsIfNeeded := AddInventoryIfNeededCheckBox.Checked;
  CommercialParcelsOnly := cb_CommercialParcelsOnly.Checked;
  ResidentialParcelsOnly := cb_ResidentialParcelsOnly.Checked;

  GetValuesFromStringGrid(sg_Exclusions, ExclusionsList, True);
  FieldToExcludeOn := ed_FieldToExcludeOn.Text;

  _ScreenName := ScreenComboBox.Items[ScreenComboBox.ItemIndex];
  _LabelName := FieldComboBox.Items[FieldComboBox.ItemIndex];

  For I := 0 to (ScreenLabelList.Count - 1) do
    If (_Compare(ScreenLabelPtr(ScreenLabelList[I])^.LabelName, _LabelName, coEqual) and
        _Compare(ScreenLabelPtr(ScreenLabelList[I])^.ScreenName, _ScreenName, coEqual))
      then
        begin
          DestinationTableName := Trim(ScreenLabelPtr(ScreenLabelList[I])^.TableName);
          DestinationFieldName := Trim(ScreenLabelPtr(ScreenLabelList[I])^.FieldName);
        end;

  case AssessmentYearRadioGroup.ItemIndex of
    0 : begin
          ProcessingType := ThisYear;
          AssessmentYear := GlblThisYear;
        end;

    1 : begin
          ProcessingType := NextYear;
          AssessmentYear := GlblNextYear;
        end;

  end;  {case AssessmentYearRadioGroup.ItemIndex of}

  OpenTableForProcessingType(TempTable, DestinationTableName, ProcessingType, Quit);
  OpenTableForProcessingType(ResidentialSiteTable, ResidentialSiteTableName, ProcessingType, Quit);
  OpenTableForProcessingType(ResidentialBldgTable, ResidentialBldgTableName, ProcessingType, Quit);
  OpenTableForProcessingType(CommercialSiteTable, CommercialSiteTableName, ProcessingType, Quit);
  OpenTableForProcessingType(CommercialBldgTable, CommercialBldgTableName, ProcessingType, Quit);

  SourceFieldName := MapFieldComboBox.Items[MapFieldComboBox.ItemIndex];

  If PrintDialog.Execute
    then
      begin
        AssignPrinterSettings(PrintDialog, ReportPrinter, ReportFiler, [ptBoth], False, Quit);

        Cancelled := False;
        GlblPreviewPrint := False;

        If not Cancelled
          then
            If PrintDialog.PrintToFile
              then
                begin
                  GlblPreviewPrint := True;
                  NewFileName := GetPrintFileName(Self.Caption, True);
                  ReportFiler.FileName := NewFileName;
                  GlblDefaultPreviewZoomPercent := 100;

                  try
                    PreviewForm := TPreviewForm.Create(Self);
                    PreviewForm.FilePrinter.FileName := NewFileName;
                    PreviewForm.FilePreview.FileName := NewFileName;

                    ReportFiler.Execute;
                    PreviewForm.ShowModal;
                  finally
                    PreviewForm.Free;
                  end

                end
              else ReportPrinter.Execute;

      end;  {If PrintDialog.Execute}

end;  {StartButtonClick}

{==================================================================}
Procedure SetReportTabs(Sender : TObject);

begin
  with Sender as TBaseReport do
    begin
      ClearTabs;
      SetTab(0.4, pjCenter, 2.2, 5, BOXLINEAll, 25);   {Parcel ID 1}
      SetTab(2.6, pjCenter, 1.5, 5, BOXLINEAll, 25);   {Value 1}
      SetTab(4.3, pjCenter, 2.2, 5, BOXLINEAll, 25);   {Parcel ID 1}
      SetTab(6.5, pjCenter, 1.5, 5, BOXLINEAll, 25);   {Value 1}

      Println(#9 + 'Parcel ID' +
              #9 + 'New Value' +
              #9 + 'Parcel ID' +
              #9 + 'New Value');

      ClearTabs;
      SetTab(0.4, pjLeft, 2.2, 5, BOXLINEAll, 0);   {Parcel ID 1}
      SetTab(2.6, pjLeft, 1.5, 5, BOXLINEAll, 0);   {Value 1}
      SetTab(4.3, pjLeft, 2.2, 5, BOXLINEAll, 0);   {Parcel ID 1}
      SetTab(6.5, pjLeft, 1.5, 5, BOXLINEAll, 0);   {Value 1}

    end;  {with Sender as TBaseReport do}

end;  {SetReportTabs}

{==================================================================}
Procedure PrintMultipleMatchSectionHeader(Sender : TObject);

begin
  with Sender as TBaseReport do
    begin
      Underline := True;
      Bold := True;
      Println(#9 + 'Parcels with multiple matches in the layer:');
      Underline := False;
      Bold := False;
      Println('');
      SetReportTabs(Sender);

    end;  {with Sender as TBaseReport do}

end;  {PrintMultipleMatchSectionHeader}

{==================================================================}
Procedure TSetFieldValueFromMapLayerDialog.ReportPrintHeader(Sender: TObject);

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
      SetFont('Times New Roman',10);
      Bold := True;
      Home;
      PrintCenter('Set Data Field Value from Map Layer', (PageWidth / 2));
      Bold := False;
      CRLF;
      CRLF;

      ClearTabs;
      SetTab(0.3, pjLeft, 7.5, 0, BOXLINENONE, 0);
      Println(#9 + 'Source: Layer = ' + Trim(SourceLayerName) + ', Field = ' + SourceFieldName);
      Println(#9 + 'Set value for table ' + Trim(TempTable.TableName) +
                   ' \ field ' + Trim(DestinationFieldName));
      Println('');

      If _Compare(ReportSection, rsMultipleMatch, coEqual)
        then PrintMultipleMatchSectionHeader(Sender)
        else SetReportTabs(Sender);

    end;  {with Sender as TBaseReport do}

end;  {ReportPrintHeader}

{====================================================================}
Procedure TSetFieldValueFromMapLayerDialog.AddInventorySite(AssessmentYear : String;
                                                            TableName : String;
                                                            SwisSBLKey : String);

var
  AddSiteRecord : Boolean;

begin
  If _Compare(TableName, 'PRes', coContains)
    then
      begin
        AddSiteRecord := False;

        If _Compare(Copy(TableName, 2, 200), Copy(ResidentialSiteTableName, 2, 200), coEqual)
          then AddSiteRecord := True;

        If AddSiteRecord
          then
            begin
              with ResidentialSiteTable do
                try
                  Insert;
                  FieldByName('TaxRollYr').Text := AssessmentYear;
                  FieldByName('SwisSBLKey').Text := SwisSBLKey;
                  FieldByName('Site').AsInteger := 1;
                  Post;
                except
                  Cancel;
                  SystemSupport(001, ResidentialSiteTable,
                                'Error inserting residential site record for parcel ' + SwisSBLKey +
                                '.', UnitName, GlblErrorDlgBox);
                end;

                {If we add a site record, we must add a building record.}

              with ResidentialBldgTable do
                try
                  Insert;
                  FieldByName('TaxRollYr').Text := AssessmentYear;
                  FieldByName('SwisSBLKey').Text := SwisSBLKey;
                  FieldByName('Site').AsInteger := 1;
                  Post;
                except
                  Cancel;
                end;

            end;  {If ((UpcaseStr(RTrim(ChangeRec.TableName)) = UpcaseStr(ResidentialSiteTableName)) or}

          {Now, if this is not the site, insert the subrecord.}

        If _Compare(Copy(TableName, 2, 200), Copy(ResidentialSiteTableName, 2, 200), coNotEqual)
          then
            with TempTable do
              try
                Insert;
                FieldByName('TaxRollYr').Text := AssessmentYear;
                FieldByName('SwisSBLKey').Text := SwisSBLKey;
                FieldByName('Site').AsInteger := 1;

                If _Compare(Copy(TableName, 2, 200), Copy(ResidentialLandTableName, 2, 200), coEqual)
                  then FieldByName('LandNumber').AsInteger := 1;

                If _Compare(Copy(TableName, 2, 200), Copy(ResidentialForestTableName, 2, 200), coEqual)
                  then FieldByName('ForestNumber').AsInteger := 1;

                If _Compare(Copy(TableName, 2, 200), Copy(ResidentialImprovementsTableName, 2, 200), coEqual)
                  then FieldByName('ImprovementNumber').AsInteger := 1;

                Post;
              except
                Cancel;
                SystemSupport(003, TempTable,
                              'Error inserting record for table ' + TempTable.TableName +
                              ' Parcel ' + SwisSBLKey + '.',
                              UnitName, GlblErrorDlgBox);
              end;

      end;  {If (UpcaseStr(Take(5, ChangeRec.TableName)) = 'TPRES')}

  If _Compare(TableName, 'PCOM', coContains)
    then
      begin
       AddSiteRecord := False;

        If _Compare(Copy(TableName, 2, 200), Copy(CommercialSiteTableName, 2, 200), coEqual)
          then AddSiteRecord := True;

        If AddSiteRecord
          then
            begin
              with CommercialSiteTable do
                try
                  Insert;
                  FieldByName('TaxRollYr').Text := AssessmentYear;
                  FieldByName('SwisSBLKey').Text := SwisSBLKey;
                  FieldByName('Site').AsInteger := 1;
                  Post;
                except
                  Cancel;
                  SystemSupport(004, CommercialSiteTable,
                                'Error inserting commercial site record for parcel ' + SwisSBLKey +
                                '.', UnitName, GlblErrorDlgBox);
                end;

              If not _Locate(CommercialBldgTable, [AssessmentYear, SwisSBLKey, 1, 1, 1], '', [])
                then
                  with CommercialBldgTable do
                    try
                      Insert;
                      FieldByName('TaxRollYr').Text := AssessmentYear;
                      FieldByName('SwisSBLKey').Text := SwisSBLKey;
                      FieldByName('Site').AsInteger := 1;
                      FieldByName('BuildingNumber').AsInteger := 1;
                      FieldByName('BuildingSection').AsInteger := 1;
                      Post;
                    except
                      Cancel;
                    end;

            end;  {If ((UpcaseStr(RTrim(ChangeRec.TableName)) = ...}

          {Now, if this is not the site, insert the subrecord.}

        If _Compare(Copy(TableName, 2, 200), Copy(CommercialSiteTableName, 2, 200), coNotEqual)
          then
            with TempTable do
              try
                Insert;
                FieldByName('TaxRollYr').Text := AssessmentYear;
                FieldByName('SwisSBLKey').Text := SwisSBLKey;
                FieldByName('Site').AsInteger := 1;

                If _Compare(Copy(TableName, 2, 200), Copy(CommercialLandTableName, 2, 200), coEqual)
                  then FieldByName('LandNumber').AsInteger := 1;

                If _Compare(Copy(TableName, 2, 200), Copy(CommercialBldgTableName, 2, 200), coEqual)
                  then
                    begin
                      FieldByName('BuildingNumber').AsInteger := 1;
                      FieldByName('BuildingSection').AsInteger := 1;
                    end;

                If _Compare(Copy(TableName, 2, 200), Copy(CommercialImprovementsTableName, 2, 200), coEqual)
                  then FieldByName('ImprovementNumber').AsInteger := 1;

                If _Compare(Copy(TableName, 2, 200), Copy(CommercialRentTableName, 2, 200), coEqual)
                  then FieldByName('UseNumber').AsInteger := 1;

                Post;
              except
                Cancel;
                SystemSupport(006, TempTable,
                              'Error inserting record for table ' + TempTable.TableName +
                              ' Parcel ' + SwisSBLKey + '.',
                              UnitName, GlblErrorDlgBox);
              end;

      end;  {If (UpcaseStr(Take(5, ChangeRec.TableName)) = 'TPCOM')}

end;  {AddInventorySite}

{==================================================================}
Function MeetsCriteria(ParcelTable : TDataSet;
                       ResidentialParcelsOnly : Boolean;
                       CommercialParcelsOnly : Boolean) : Boolean;

begin
  Result := True;

  If ResidentialParcelsOnly
    then Result := PropertyIsResidential(ParcelTable.FieldByName('PropertyClassCode').Text);

  If CommercialParcelsOnly
    then Result := not PropertyIsResidential(ParcelTable.FieldByName('PropertyClassCode').Text);

end;  {MeetsCriteria}

{==================================================================}
Procedure TSetFieldValueFromMapLayerDialog.ReportPrint(Sender: TObject);

var
  Done, FirstTimeThrough : Boolean;
  SourceRecordSet, ParcelRecordSet : IMORecordSet;
  ParcelLayerPolygon : IMOPolygon;
  LinkFieldName : OLEVariant;
  ExclusionValue,
  NewValue, SwisSBLKey, FirstMatch : String;
  ValuesMatched, NumberChanged, NumberPrintedThisPage : LongInt;
  MultipleMatchList : TStringList;
  I, ColonPos : Integer;
  ParcelLayerField : IMOField;

begin
  MultipleMatchList := TStringList.Create;
  Done := False;
  FirstTimeThrough := True;

    {For each parcel, find the centroid in the source layer.}

  ParcelRecordSet := ParcelLayer.Records;
  LinkFieldName := MapSetupObject.MapFileKeyField;
  NumberChanged := 0;
  NumberPrintedThisPage := 0;
  ProgressBar.Position := 0;
  ProgressBar.Max := ParcelRecordSet.Count - 1;
  ParcelRecordSet.MoveFirst;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else ParcelRecordSet.MoveNext;

    If ParcelRecordSet.EOF
      then Done := True;

    ProgressBar.Position := ProgressBar.Position + 1;
    Application.ProcessMessages;

    If not Done
      then
        begin
          ParcelLayerField := ParcelRecordSet.Fields.Item('Shape');
          ParcelLayerPolygon := IMoPolygon(CreateOleObject('MapObjects2.Polygon'));
          ParcelLayerPolygon := IMoPolygon(IDispatch(ParcelLayerField.Value));
          (*Map.FlashShape(ParcelLayerPolygon, 2);*)

            {We will only set the value if the centroid of the parcel is in the source layer
             area.  This eliminates parcels that split across areas - usually only by a little.}

          SourceRecordSet := SourceLayer.SearchShape(ParcelLayerPolygon.Centroid, moContainedBy, '');

          SourceRecordSet.MoveFirst;
          ValuesMatched := 0;
          FirstMatch := '';

          while (not SourceRecordSet.EOF) do
            begin
              If (FindParcelForMapRecord(ParcelLookupTable,
                                         MapParcelIDFormatTable, AssessmentYearControlTable,
                                         MapSetupObject,
                                         ParcelRecordSet.Fields.Item(LinkFieldName).Value,
                                         AssessmentYear) and
                  MeetsCriteria(ParcelLookupTable,
                                ResidentialParcelsOnly,
                                CommercialParcelsOnly))
                then
                  begin
                    SwisSBLKey := ExtractSSKey(ParcelLookupTable);
                    NewValue := SourceRecordSet.Fields.Item(SourceFieldName).Value;

                    If _Compare(FieldToExcludeOn, coBlank)
                      then ExclusionValue := ''
                      else ExclusionValue := SourceRecordSet.Fields.Item(FieldToExcludeOn).Value;

                    If _Compare(ExclusionsList.IndexOf(ExclusionValue), -1, coEqual)
                      then
                        begin
                          Inc(ValuesMatched);

                          If _Compare(ValuesMatched, 1, coGreaterThan)
                            then
                              begin
                                If _Compare(ValuesMatched, 2, coEqual)
                                  then MultipleMatchList.Append('*' + FirstMatch);

                                MultipleMatchList.Append(ConvertSwisSBLToDashDot(SwisSBLKey) + ':' +
                                                         NewValue);
                              end
                            else
                              begin
                                If ((not _Locate(TempTable, [AssessmentYear, SwisSBLKey], '', [])) and
                                    AddInventoryRecordsIfNeeded)
                                  then AddInventorySite(AssessmentYear, TempTable.TableName, SwisSBLKey);

                                If _Locate(TempTable, [AssessmentYear, SwisSBLKey], '', [])
                                  then
                                    begin
                                      Inc(NumberChanged);
                                      Inc(NumberPrintedThisPage);

                                      with Sender as TBaseReport do
                                        begin
                                          If (_Compare(NumberPrintedThisPage, 1, coGreaterThan) and
                                              Odd(NumberPrintedThisPage))
                                            then
                                              begin
                                                Println('');

                                                If (LinesLeft < 5)
                                                  then
                                                    begin
                                                      NewPage;
                                                      NumberPrintedThisPage := 1;
                                                    end;

                                              end;  {If ((NumberChanged > 1) and ...}

                                          Print(#9 + ConvertSwisSBLToDashDot(SwisSBLKey) +
                                                #9 + NewValue);

                                        end;  {with Sender as TBaseReport do}

                                      If not TrialRun
                                        then
                                          with TempTable do
                                            try
                                              Edit;
                                              FieldByName(DestinationFieldName).Text := NewValue;
                                              Post;
                                            except
                                            end;

                                      FirstMatch := ConvertSwisSBLToDashDot(SwisSBLKey) + ':' +
                                                    NewValue;

                                    end;  {If _Locate(TempTable, [AssessmentYear, SwisSBLKey], '', [])}

                              end;  {else of If _Compare(ValuesMatched, 1, coGreaterThan)}

                        end;  {If _Compare(ExclusionList.IndexOf(ExclusionValue), -1, coEqual)}
                        
                  end;  {If FindParcelForMapRecord(ParcelLookupTable, ...}

              SourceRecordSet.MoveNext;

            end;  {while (not SourceRecordSet.EOF) do}

        end;  {If ((not Done) and ...}

  until (Done or Cancelled);

    {Search by Source layer.}

(*  SourceRecordSet := SourceLayer.Records;
  LinkFieldName := MapSetupObject.MapFileKeyField;
  NumberChanged := 0;
  NumberPrintedThisPage := 0;
  ProgressBar.Position := 0;
  ProgressBar.Max := SourceRecordSet.Count - 1;
  SourceRecordSet.MoveFirst;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else SourceRecordSet.MoveNext;

    If SourceRecordSet.EOF
      then Done := True;

    ProgressBar.Position := ProgressBar.Position + 1;
    Application.ProcessMessages;

    If ((not Done) and
        ((not ContinuousLineType) or
         _Compare(SourceRecordSet.Fields.Item('LineType').Value, 'Continuous', coEqual)))
      then
        begin
          SourceLayerField := SourceRecordSet.Fields.Item('Shape');
          SourceLayerPolygon := IMoPolygon(CreateOleObject('MapObjects2.Polygon'));
          SourceLayerPolygon := IMoPolygon(IDispatch(SourceLayerField.Value));
          Map.FlashShape(SourceLayerPolygon, 3);

            {We will only set the value if the centroid of the parcel is in the source layer
             area.  This eliminates parcels that split across areas - usually only by a little.}

          SearchRecordSet := ParcelLayer.SearchShape(SourceLayerPolygon, moCentroidInPolygon, '');

          SearchRecordSet.MoveFirst;

          while (not SearchRecordSet.EOF) do
            begin
              If FindParcelForMapRecord(ParcelLookupTable,
                                        MapParcelIDFormatTable, AssessmentYearControlTable,
                                        MapSetupObject,
                                        SearchRecordSet.Fields.Item(LinkFieldName).Value,
                                        AssessmentYear)
                then
                  begin
                    ParcelLayerField := SearchRecordSet.Fields.Item('Shape');
                    ParcelLayerPolygon := IMoPolygon(CreateOleObject('MapObjects2.Polygon'));
                    ParcelLayerPolygon := IMoPolygon(IDispatch(ParcelLayerField.Value));

                    SwisSBLKey := ExtractSSKey(ParcelLookupTable);

                    If ((not _Locate(TempTable, [AssessmentYear, SwisSBLKey], '', [])) and
                        AddInventoryRecordsIfNeeded)
                      then AddInventorySite(AssessmentYear, TempTable.TableName, SwisSBLKey);

                    If _Locate(TempTable, [AssessmentYear, SwisSBLKey], '', [])
                      then
                        begin
                          Inc(NumberChanged);
                          Inc(NumberPrintedThisPage);
                          NewValue := SourceRecordSet.Fields.Item(SourceFieldName).Value;

                          with Sender as TBaseReport do
                            begin
                              If ((NumberPrintedThisPage > 1) and
                                  Odd(NumberPrintedThisPage))
                                then
                                  begin
                                    Println('');

                                    If (LinesLeft < 5)
                                      then
                                        begin
                                          NewPage;
                                          NumberPrintedThisPage := 0;
                                        end;

                                  end;  {If ((NumberChanged > 1) and ...}

                              Print(#9 + ConvertSwisSBLToDashDot(SwisSBLKey) +
                                    #9 + NewValue);

                            end;  {with Sender as TBaseReport do}

                          If not TrialRun
                            then
                              with TempTable do
                                try
                                  Edit;
                                  FieldByName(DestinationFieldName).Text := NewValue;
                                  Post;
                                except
                                end;

                        end;  {If _Locate(TempTable, [AssessmentYear, SwisSBLKey], '', [])}

                  end;  {If FindParcelForMapRecord(ParcelLookupTable, ...}

              SearchRecordSet.MoveNext;

            end;  {while (not SearchRecordSet.EOF) do}

        end;  {If ((not Done) and ...}

  until (Done or Cancelled);  *)

  with Sender as TBaseReport do
    begin
      Println('');
      ClearTabs;
      SetTab(0.3, pjLeft, 7.5, 0, BOXLINENONE, 0);
      Bold := True;
      Println(#9 + 'Total Changed = ' + IntToStr(NumberChanged));
      Bold := False;

      If (MultipleMatchList.Count > 0)
        then
          begin
            ReportSection := rsMultipleMatch;

            If (LinesLeft < 10)
              then NewPage
              else PrintMultipleMatchSectionHeader(Sender);

            For I := 0 to (MultipleMatchList.Count - 1) do
              begin
                ColonPos := Pos(':', MultipleMatchList[I]);
                SwisSBLKey := Copy(MultipleMatchList[I], 1, (ColonPos - 1));
                NewValue := Copy(MultipleMatchList[I], (ColonPos + 1), 200);

                If ((I > 0) and
                    Odd(I + 1))
                  then
                    begin
                      Println('');

                      If (LinesLeft < 5)
                        then NewPage;

                    end;  {If ((I > 0) and ...}

                Print(#9 + SwisSBLKey +
                      #9 + NewValue);

              end;  {For I := 0 to (MultipleMatchList.Count - 1) do}

            Println('');

          end;  {If (MultipleMatchList.Count > 0)}

    end;  {with Sender as TBaseReport do}

  MultipleMatchList.Free;
  Close;

end;  {ReportPrint}

{==============================================================================}
Procedure TSetFieldValueFromMapLayerDialog.CancelButtonClick(Sender: TObject);

begin
  Cancelled := True;
end;

{==================================================================}
Procedure TSetFieldValueFromMapLayerDialog.FormClose(    Sender: TObject;
                                                     var Action: TCloseAction);

begin
  ExclusionsList.Free;
  CloseTablesForForm(Self);
  Action := caFree;
end;


end.
