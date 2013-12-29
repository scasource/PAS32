unit MappingSetupOptions;

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
  DBGrids, Wwdbigrd, Wwdbgrid, ExtCtrls, Wwtable, Wwdatsrc, Menus, Mask, ComCtrls,
  CheckLst, wwdblook, wwdbedit, Wwdotdot, Wwdbcomb, RPFiler, RPDefine,
  RPBase, RPCanvas, RPrinter, EditDialog;

type
  TMappingOptionsForm = class(TForm)
    MapLayersAvailableDataSource: TwwDataSource;
    MappingDetailTable : TTable;
    Panel2: TPanel;
    ScrollBox1: TScrollBox;
    ColorDialog: TColorDialog;
    MappingHeaderTable: TTable;
    MappingHeaderDataSource: TDataSource;
    PageControl: TPageControl;
    MapSetupsTabSheet: TTabSheet;
    LayersAvailableTabSheet: TTabSheet;
    OpenDialog: TOpenDialog;
    MapLayersAvailableTable: TwwTable;
    MapTypeLookupCombo: TwwDBLookupCombo;
    MapTypeCodeTable: TwwTable;
    MapLayersAvailableTableLayerName: TStringField;
    MapLayersAvailableTableLayerLocation: TStringField;
    MapLayersAvailableTableLayerColor: TIntegerField;
    MapLayersAvailableTableMainLayer: TBooleanField;
    MapLayersAvailableTableLayerType: TStringField;
    MapLayersAvailableTableAutoIncrement: TAutoIncField;
    MapLayersAvailableTableCalcLayerColor: TIntegerField;
    CloseTimer: TTimer;
    BaseCondosTabSheet: TTabSheet;
    MapCondoTable: TwwTable;
    MapCondoDataSource: TwwDataSource;
    MapCondoTableSwisCode: TStringField;
    MapCondoTableSBL: TStringField;
    MapCondoTableCondoName: TStringField;
    MapCondoTableParcelID: TStringField;
    SwisCodeTable: TwwTable;
    SwisCodeLookupCombo: TwwDBLookupCombo;
    ReportPrinter: TReportPrinter;
    ReportFiler: TReportFiler;
    PrintDialog: TPrintDialog;
    ParcelIDFormatTabSheet: TTabSheet;
    SeperatorsGroupBox: TGroupBox;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    EditLotSeparator: TDBEdit;
    EditSectionSeparator: TDBEdit;
    EditBlockSeparator: TDBEdit;
    EditSubsectionSeparator: TDBEdit;
    EditSublotSeparator: TDBEdit;
    SBLSegmentGrid: TStringGrid;
    Label14: TLabel;
    MapParcelIDTable: TwwTable;
    MapParcelIDDataSource: TwwDataSource;
    DBCheckBox1: TDBCheckBox;
    SaveParcelIDFormatButton: TBitBtn;
    CancelParcelIDFormatButton: TBitBtn;
    MapParcelIDTableUseMapParcelID: TBooleanField;
    MapParcelIDTableSectionLJust: TBooleanField;
    MapParcelIDTableSectionRJust: TBooleanField;
    MapParcelIDTableSectionNumeric: TBooleanField;
    MapParcelIDTableSectionAlphaNum: TBooleanField;
    MapParcelIDTableSectionAlpha: TBooleanField;
    MapParcelIDTableSectionSRAZ: TBooleanField;
    MapParcelIDTableSubsectionLJust: TBooleanField;
    MapParcelIDTableSubsectionRJust: TBooleanField;
    MapParcelIDTableSubsectionNumeric: TBooleanField;
    MapParcelIDTableSubsectionAlphaNum: TBooleanField;
    MapParcelIDTableSubsectionAlpha: TBooleanField;
    MapParcelIDTableSubsectionSRAZ: TBooleanField;
    MapParcelIDTableBlockLJust: TBooleanField;
    MapParcelIDTableBlockRJust: TBooleanField;
    MapParcelIDTableBlockNumeric: TBooleanField;
    MapParcelIDTableBlockAlphaNum: TBooleanField;
    MapParcelIDTableBlockAlpha: TBooleanField;
    MapParcelIDTableBlockSRAZ: TBooleanField;
    MapParcelIDTableLotLJust: TBooleanField;
    MapParcelIDTableLotRJust: TBooleanField;
    MapParcelIDTableLotNumeric: TBooleanField;
    MapParcelIDTableLotAlphaNum: TBooleanField;
    MapParcelIDTableLotAlpha: TBooleanField;
    MapParcelIDTableLotSRAZ: TBooleanField;
    MapParcelIDTableSublotLJust: TBooleanField;
    MapParcelIDTableSublotRJust: TBooleanField;
    MapParcelIDTableSublotNumeric: TBooleanField;
    MapParcelIDTableSublotAlphaNum: TBooleanField;
    MapParcelIDTableSublotAlpha: TBooleanField;
    MapParcelIDTableSublotSRAZ: TBooleanField;
    MapParcelIDTableSuffixLJust: TBooleanField;
    MapParcelIDTableSuffixRJust: TBooleanField;
    MapParcelIDTableSuffixNumeric: TBooleanField;
    MapParcelIDTableSuffixAlphaNum: TBooleanField;
    MapParcelIDTableSuffixAlpha: TBooleanField;
    MapParcelIDTableSuffixSRAZ: TBooleanField;
    MapParcelIDTableSectionSeparator: TStringField;
    MapParcelIDTableSubsectionSeparator: TStringField;
    MapParcelIDTableBlockSeparator: TStringField;
    MapParcelIDTableLotSeparator: TStringField;
    MapParcelIDTableSublotSeparator: TStringField;
    MapParcelIDTableSectionDigits: TIntegerField;
    MapParcelIDTableSubsectionDigits: TIntegerField;
    MapParcelIDTableBlockDigits: TIntegerField;
    MapParcelIDTableLotDigits: TIntegerField;
    MapParcelIDTableSublotDigits: TIntegerField;
    MapParcelIDTableSuffixDigits: TIntegerField;
    MapLayersAvailableTableTransparent: TBooleanField;
    MappingHeaderLookupTable: TTable;
    EditNewCondoParcelIDDialogBox: TEditDialogBox;
    Panel1: TPanel;
    SaveButton: TBitBtn;
    AddLayerFileButton: TBitBtn;
    RemoveLayerFileButton: TBitBtn;
    Panel3: TPanel;
    LayersDBGrid: TwwDBGrid;
    Panel4: TPanel;
    SaveCondoIDButton: TBitBtn;
    AddCondoIDButton: TBitBtn;
    RemoveCondoIDButton: TBitBtn;
    PrintCondoIDsButton: TBitBtn;
    Panel5: TPanel;
    CondoIDGrid: TwwDBGrid;
    Panel6: TPanel;
    VersionLabel: TLabel;
    NewMapSetupButton: TBitBtn;
    RemoveMapSetupButton: TBitBtn;
    CancelMapSetupButton: TBitBtn;
    SaveSetupButton: TBitBtn;
    Panel7: TPanel;
    Panel8: TPanel;
    Panel9: TPanel;
    GroupBox3: TGroupBox;
    PresetMapCodesGrid: TwwDBGrid;
    MappingHeaderPageControl: TPageControl;
    OptionsTabSheet: TTabSheet;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    LabelColorGraphic: TShape;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    FillColorGraphic: TShape;
    Label10: TLabel;
    Label12: TLabel;
    MappingSetupEdit: TDBEdit;
    ZoomPercentEdit: TDBEdit;
    DefaultSetupCheckbox: TDBCheckBox;
    ChooseLabelColorDialogButton: TButton;
    ChooseFillColorDialogButton: TButton;
    DefaultLabelComboBox: TwwDBComboBox;
    FillTypeComboBox: TwwDBComboBox;
    DashDotSBlFormatCheckBox: TDBCheckBox;
    Edit_AC_SP_Ratio_Decimals: TDBEdit;
    AutoloadLayersTabSheet: TTabSheet;
    MapLinkingTabSheet: TTabSheet;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    MapFileKeyFieldEdit: TDBEdit;
    PASKeyFieldEdit: TDBEdit;
    PASIndexNameEdit: TDBEdit;
    Panel10: TPanel;
    Label11: TLabel;
    Panel11: TPanel;
    LayersCheckListBox: TCheckListBox;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure AddLayerFileButtonClick(Sender: TObject);
    procedure RemoveLayerFileButtonClick(Sender: TObject);
    procedure LabelColorEditClick(Sender: TObject);
    procedure MappingHeaderTableAfterScroll(DataSet: TDataSet);
    procedure SaveButtonClick(Sender: TObject);
    procedure LayersDBGridDblClick(Sender: TObject);
    procedure MappingHeaderDataSourceDataChange(Sender: TObject;
      Field: TField);
    procedure ChooseColorDialogButtonClick(Sender: TObject);
    procedure LayersDBGridCalcCellColors(Sender: TObject; Field: TField;
      State: TGridDrawState; Highlight: Boolean; AFont: TFont;
      ABrush: TBrush);
    procedure MappingHeaderTableAfterInsert(DataSet: TDataSet);
    procedure PageControlChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure CloseTimerTimer(Sender: TObject);
    procedure AddCondoIDButtonClick(Sender: TObject);
    procedure SaveCondoIDButtonClick(Sender: TObject);
    procedure RemoveCondoIDButtonClick(Sender: TObject);
    procedure MapCondoTableCalcFields(DataSet: TDataSet);
    procedure ReportPrint(Sender: TObject);
    procedure ReportPrintHeader(Sender: TObject);
    procedure PrintCondoIDsButtonClick(Sender: TObject);
    procedure SBLSegmentGridDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure SBLSegmentGridClick(Sender: TObject);
    procedure SaveParcelIDFormatButtonClick(Sender: TObject);
    procedure CancelParcelIDFormatButtonClick(Sender: TObject);
    procedure NewMapSetupButtonClick(Sender: TObject);
    procedure RemoveMapSetupButtonClick(Sender: TObject);
    procedure CancelMapSetupButtonClick(Sender: TObject);
    procedure SaveSetupButtonClick(Sender: TObject);
    procedure PresetMapCodesGridDblClick(Sender: TObject);
    procedure MappingHeaderTableNewRecord(DataSet: TDataSet);
  private
    { Private declarations }
  public
    { Public declarations }
    UnitName : String;
    CloseOnStart : Boolean;
    ReturnSetupName : String;
    FormAccessRights : Integer;  {Read only or read write, based on security level?}
    OnlyBaseCondominiumParcelIdIsEncoded : Boolean;
    FirstSBLFormatFieldOffset : Integer;  {Where is the first field of the SBL format fields?}
    MapVersion : String;
    OriginalSetupName : String;

    Procedure InitializeForm;  {Open the tables and setup.}
    Procedure SaveAutoloadLayers;
    Procedure FillInSBLFormatGrid;

  end;


var
  MappingOptionsForm : TMappingOptionsForm;

implementation

uses GlblVars, WinUtils, Utilitys, GlblCnst, PASUtils, MapUtilitys, PASTypes,
     Preview, Types;

{$R *.DFM}

type
  SBLSegmentArrayType = Array[1..6, 1..6] of Boolean;
  SBLSegmentTextArrayType = Array[1..6, 1..7] of String;

var
  SBLSegmentArray : SBLSegmentArrayType;
  SBLSegmentTextArray : SBLSegmentTextArrayType;

{========================================================}
Procedure TMappingOptionsForm.FormShow(Sender: TObject);

begin
  If CloseOnStart
    then CloseTimer.Enabled := True;

end;

{========================================================}
Procedure TMappingOptionsForm.CloseTimerTimer(Sender: TObject);

begin
  CloseTimer.Enabled := False;
  ModalResult := mrOK;
end;

{========================================================}
Procedure TMappingOptionsForm.SaveAutoloadLayers;

var
  I : Integer;
  TempStr : String;

begin
    {Delete the old selected items first.}

  SetRangeOld(MappingDetailTable, ['MappingSetupName', 'LayerName'],
              [MappingHeaderTable.FieldByName('MappingSetupName').Text,
               Take(10, '')],
              [MappingHeaderTable.FieldByName('MappingSetupName').Text,
               'ZZZZZZZZZZ']);

  DeleteTableRange(MappingDetailTable);

  For I := 0 to (LayersCheckListBox.Items.Count - 1) do
    If LayersCheckListBox.Checked[I]
      then
        with MappingDetailTable do
          try
            Insert;
            FieldByName('MappingSetupName').Text := MappingHeaderTable.FieldByName('MappingSetupName').Text;

            TempStr := LayersCheckListBox.Items[I];
            StringReplace(TempStr, ' (Main)', '', [rfReplaceAll, rfIgnoreCase]);

            FieldByName('LayerName').Text := TempStr;
            Post;
          except
            MessageDlg('Error saving layer detail ' + TempStr + '.',
                       mtInformation, [mbOK], 0);
          end;

    {Now go through and add the currently selected items.}

  LoadLayersIntoLayerBox(LayersCheckListBox,
                         MappingHeaderTable.FieldByName('MappingSetupName').Text,
                         MapLayersAvailableTable,
                         MappingDetailTable);

end;  {SaveAutoloadLayers}

{========================================================}
Procedure TMappingOptionsForm.FillInSBLFormatGrid;

var
  TempRow, TempCol, FieldPos : Integer;

begin
  For TempCol := 1 to 6 do
    For TempRow := 1 to 6 do
      SBLSegmentArray[TempCol, TempRow] := False;

    {Now fill in the array. Note that this is based on the order
     of the fields in the FieldsEditor, so DO NOT CHANGE THE ORDER!}
    {FXX11021999-12: Allow the # of forced digits in each segment to be specified.}

  For TempCol := 1 to 6 do
    For TempRow := 1 to 7 do
      begin
        FieldPos := FirstSBLFormatFieldOffset + (TempRow + (TempCol - 1) * 7) - 1;

        If (TempRow <= 6)
          then SBLSegmentArray[TempCol, TempRow] := MapParcelIDTable.Fields[FieldPos].AsBoolean;

      end;  {For TempRow := 1 to 6 do}

  For TempCol := 1 to 6 do
    For TempRow := 1 to 7 do
      begin
        FieldPos := FirstSBLFormatFieldOffset + (TempRow + (TempCol - 1) * 7) - 1;

        SBLSegmentTextArray[TempCol, TempRow] := MapParcelIDTable.Fields[FieldPos].AsString;

        If (TempRow = 7)
          then SBLSegmentGrid.Cells[TempCol, TempRow] := SBLSegmentTextArray[TempCol, TempRow];

      end;  {For TempRow := 1 to 7 do}

end;  {FillInSBLFormatGrid}

{========================================================}
Procedure TMappingOptionsForm.InitializeForm;

begin
  UnitName := 'MappingSetupOptions';  {mmm}
  MapVersion := 'Version 1.5';
  VersionLabel.Caption := MapVersion;

  If (FormAccessRights = raReadOnly)
    then
      begin
        MappingHeaderTable.ReadOnly := True;  {mmm}
        MapLayersAvailableTable.ReadOnly := True;
      end;

  OpenTablesForForm(Self, GlblProcessingType);

  FindKeyOld(MappingHeaderTable, ['MappingSetupName'], [OriginalSetupName]);

  OnlyBaseCondominiumParcelIdIsEncoded := True;
  try
    MapCondoTable.TableName := 'MapCondoTable';
    MapCondoTable.Open;
  except
    OnlyBaseCondominiumParcelIdIsEncoded := False;
    BaseCondosTabSheet.Visible := False;
  end;

  If (LayersCheckListBox.Items.Count = 0)
    then MappingHeaderTableAfterScroll(MappingDetailTable);

    {CHG10062003-1: Allow for a different parcel ID format in order to accomodate
                    different IDs coming from the map source file.}

  try
    MapParcelIDTable.TableName := 'mapparcelidtable';
    MapParcelIDTable.Open;

      {Where is the first field of the SBL format fields?}

    FirstSBLFormatFieldOffset := MapParcelIDTable.FindField('SectionLJust').Index;
    FillInSBLFormatGrid;

  except
    MapParcelIDTable.Close;
    ParcelIDFormatTabSheet.Visible := False;
  end;

end;  {InitializeForm}

{===================================================================}
Procedure TMappingOptionsForm.FormKeyPress(    Sender: TObject;
                                     var Key: Char);

begin
  If (Key = #13)
    then
      begin
        Key := #0;
        Perform(WM_NEXTDLGCTL, 0, 0);
      end;

end;  {FormKeyPress}

{==================================================================}
Procedure TMappingOptionsForm.MappingHeaderTableNewRecord(DataSet: TDataSet);

{CHG12102003-3(M1.41): A new mapping setup should copy the header information from the
                       default setup.}

var
  Done, FirstTimeThrough : Boolean;
  I : Integer;

begin
    {First look for the default setup.}

  Done := False;
  FirstTimeThrough := True;
  MappingHeaderLookupTable.First;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else MappingHeaderLookupTable.Next;

    If MappingHeaderLookupTable.EOF
      then Done := True;

    If ((not Done) and
        MappingHeaderLookupTable.FieldByName('Default').AsBoolean)
      then
        begin
          Done := True;

          with MappingHeaderLookupTable do
            For I := 0 to (FieldCount - 1) do
              try
                MappingHeaderTable.FieldByName(Fields[I].FieldName).Text := FieldByName(Fields[I].FieldName).Text;
              except
                MappingHeaderTable.FieldByName(Fields[I].FieldName).Text := '';
              end;

          MappingHeaderTable.FieldByName('Default').AsBoolean := False;
          MappingHeaderTable.FieldByName('MappingSetupName').Text := '';

        end;  {If ((not Done) and ...}

  until Done;

end;  {MappingHeaderTableNewRecord}

{==================================================================}
Procedure TMappingOptionsForm.MappingHeaderTableAfterInsert(DataSet: TDataSet);

begin
  MappingSetupEdit.SetFocus;
end;

{==================================================================}
Procedure TMappingOptionsForm.AddLayerFileButtonClick(Sender: TObject);

begin
  If OpenDialog.Execute
    then
      begin
        MapLayersAvailableTable.Insert;
        MapLayersAvailableTable.FieldByName('LayerLocation').Text := OpenDialog.FileName;
        LayersDBGrid.SetActiveField('LayerName');
      end
    else MapLayersAvailableTable.Cancel;

end;  {AddLayerFileButtonClick}

{==================================================================}
Procedure TMappingOptionsForm.RemoveLayerFileButtonClick(Sender: TObject);

begin
  MapLayersAvailableTable.Delete;
end;

{===============================================================}
Procedure TMappingOptionsForm.SaveButtonClick(Sender: TObject);

begin
  with MapLayersAvailableTable do
    If (State in [dsEdit, dsInsert])
      then
        begin
          try
            Post;
          except
            MessageDlg('Error saving changes to map layer information.', mtError, [mbOK], 0);
          end;

        end;  {If (State in [dsEdit, dsInsert])}

end;  {SaveButtonClick}

{===============================================================}
Procedure TMappingOptionsForm.LabelColorEditClick(Sender: TObject);

begin
  ColorDialog.Color := MappingHeaderTable.FieldByName('LabelColor').AsInteger;

  If ColorDialog.Execute
    then
      with MappingHeaderTable do
        try
          If (State = dsBrowse)
            then Edit;

          FieldByName('LabelColor').AsInteger := ColorDialog.Color;
        except
          SystemSupport(1, MappingHeaderTable, 'Error converting color.',
                        UnitName, GlblErrorDlgBox);
        end;

end;  {LabelColorEditClick}

{===================================================================}
Procedure TMappingOptionsForm.MappingHeaderTableAfterScroll(DataSet: TDataSet);

begin
  If (MappingHeaderTable.Active and
      MappingDetailTable.Active and
      MapLayersAvailableTable.Active)
    then LoadLayersIntoLayerBox(LayersCheckListBox,
                                MappingHeaderTable.FieldByName('MappingSetupName').Text,
                                MapLayersAvailableTable,
                                MappingDetailTable);

end;  {MappingHeaderTableAfterScroll}

{============================================================}
Procedure TMappingOptionsForm.ChooseColorDialogButtonClick(Sender: TObject);

var
  Color : LongInt;
  FieldName : String;

begin
  If ColorDialog.Execute
    then
      begin
        If (MappingHeaderTable.State = dsBrowse)
          then MappingHeaderTable.Edit;

        Color := ColorDialog.Color;

        If (TButton(Sender).Name = 'ChooseLabelColorDialogButton')
          then FieldName := 'LabelColor'
          else FieldName := 'FillColor';

        MappingHeaderTable.FieldByName(FieldName).AsInteger := Color;

        MappingHeaderDataSourceDataChange(Sender, nil);

      end;  {If ColorDialog.Execute}

end;  {ChooseColorDialogButtonClick}

{============================================================}
Procedure TMappingOptionsForm.LayersDBGridDblClick(Sender: TObject);

var
  LayerColor : LongInt;

begin
  If ColorDialog.Execute
    then
      begin
        If (MapLayersAvailableTable.State = dsBrowse)
          then MapLayersAvailableTable.Edit;

        LayerColor := ColorDialog.Color;

        MapLayersAvailableTable.FieldByName('LayerColor').AsInteger := LayerColor;

        LayersDBGrid.Refresh;

      end;  {If ColorDialog.Execute}

end;  {LayersDBGridDblClick}

{===============================================================}
Procedure TMappingOptionsForm.MappingHeaderDataSourceDataChange(Sender: TObject;
                                                                Field: TField);

begin
  If (MappingHeaderTable.Active and
      (Field = nil))
    then
      begin
        try
          LabelColorGraphic.Brush.Color := MappingHeaderTable.FieldByName('LabelColor').AsInteger;
          FillColorGraphic.Brush.Color := MappingHeaderTable.FieldByName('FillColor').AsInteger;
        except
        end;

        FillColorGraphic.Refresh;

      end;  {If MappingHeaderTable.Active}

end;  {MappingHeaderDataSourceDataChange}

{===================================================================}
Procedure TMappingOptionsForm.LayersDBGridCalcCellColors(Sender: TObject;
                                                         Field: TField;
                                                         State: TGridDrawState;
                                                         Highlight: Boolean;
                                                         AFont: TFont;
                                                         ABrush: TBrush);

begin
  If (Field.FieldName = 'CalcLayerColor')
    then
      try
        ABrush.Color := MapLayersAvailableTable.FieldByName('LayerColor').AsInteger;
      except
        ABrush.Color := clWhite;
      end;

end;  {LayersDBGridCalcCellColors}

{===================================================================}
Procedure TMappingOptionsForm.PageControlChange(Sender: TObject);

{Refresh the layers available on the map setup page or save when
 they exit the first page.}

begin
  If (PageControl.ActivePage = LayersAvailableTabSheet)
    then SaveAutoloadLayers;

  If (PageControl.ActivePage = MapSetupsTabSheet)
    then LoadLayersIntoLayerBox(LayersCheckListBox,
                                MappingHeaderTable.FieldByName('MappingSetupName').Text,
                                MapLayersAvailableTable,
                                MappingDetailTable);

end;  {PageControl1Change}

{===================================================================}
Procedure TMappingOptionsForm.NewMapSetupButtonClick(Sender: TObject);

begin
  MappingHeaderTable.Append;
end;

{===================================================================}
Procedure TMappingOptionsForm.RemoveMapSetupButtonClick(Sender: TObject);

begin
  If (MessageDlg('Are you sure you want to delete setup ' +
                 MappingHeaderTable.FieldByName('MappingSetupName').Text + '?',
                 mtConfirmation, [mbYes, mbNo], 0) = idYes)
    then
      try
        MappingHeaderTable.Delete;
      except
        SystemSupport(002, MappingHeaderTable,
                      'Error deleting mapping setup ' +
                      MappingHeaderTable.FieldByName('MappingSetupName').Text + '.',
                      'MappingSetupOptions', GlblErrorDlgBox);
      end;

end;  {RemoveMapSetupButtonClick}

{===================================================================}
Procedure TMappingOptionsForm.CancelMapSetupButtonClick(Sender: TObject);

begin
  MappingHeaderTable.Cancel;
end;

{===================================================================}
Procedure TMappingOptionsForm.SaveSetupButtonClick(Sender: TObject);

begin
  If MappingHeaderTable.Modified
    then
      try
        MappingHeaderTable.Post;
        SaveAutoloadLayers;
      except
        SystemSupport(001, MappingHeaderTable,
                      'Error saving mapping header record ' +
                      MappingHeaderTable.FieldByName('MappingSetupName').Text + '.',
                      'MappingSetupOptions', GlblErrorDlgBox);
      end;

end;  {SaveSetupButtonClick}

{===================================================================}
Procedure TMappingOptionsForm.ReportPrintHeader(Sender: TObject);

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
      PrintCenter('Base Condominium Parcel IDs', (PageWidth / 2));
      Println('');
      Println('');

      SetFont('Times New Roman',10);
      ClearTabs;

      ClearTabs;
      SetTab(0.4, pjCenter, 0.8, 0, BoxLineBottom, 0);   {Swis Code}
      SetTab(1.2, pjCenter, 1.6, 0, BoxLineBottom, 0);   {Parcel ID}
      SetTab(3.0, pjCenter, 5.0, 0, BoxLineBottom, 0);   {Condo Name}

      Bold := True;
      Println(#9 + 'Parcel ID' +
              #9 + 'Owner' +
              #9 + 'Legal Address' +
              #9 + 'Cls');
      Bold := False;

      ClearTabs;
      SetTab(0.4, pjLeft, 0.8, 0, BoxLineNone, 0);   {Swis Code}
      SetTab(1.2, pjLeft, 1.6, 0, BoxLineNone, 0);   {Parcel ID}
      SetTab(3.0, pjLeft, 5.0, 0, BoxLineNone, 0);   {Condo Name}

    end;  {with Sender as TBaseReport do}

end;  {ReportPrintHeader}

{===================================================================}
Procedure TMappingOptionsForm.ReportPrint(Sender: TObject);

var
  Done, FirstTimeThrough : Boolean;

begin
  Done := False;
  FirstTimeThrough := True;

  MapCondoTable.DisableControls;
  MapCondoTable.First;

  with Sender as TBaseReport do
    repeat
      If FirstTimeThrough
        then FirstTimeThrough := False
        else MapCondoTable.Next;

      If MapCondoTable.EOF
        then Done := True;

      If not Done
        then
          begin
            If (LinesLeft < 5)
              then NewPage;

            with MapCondoTable do
              Println(#9 + FieldByName('SwisCode').Text +
                      #9 + ConvertSBLOnlyToDashDot(FieldByName('SBL').Text) +
                      #9 + FieldByName('CondoName').Text);

          end;  {If not Done}

    until Done;

  MapCondoTable.EnableControls;

end;  {ReportPrint}

{===================================================================}
Procedure TMappingOptionsForm.PrintCondoIDsButtonClick(Sender: TObject);

var
  Quit : Boolean;
  NewFileName : String;

begin
  If PrintDialog.Execute
    then
      begin
        AssignPrinterSettings(PrintDialog, ReportPrinter, ReportFiler, [ptLaser],
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
                    ReportFiler.FileName := NewFileName;

                    try
                      PreviewForm := TPreviewForm.Create(self);
                      PreviewForm.FilePrinter.FileName := NewFileName;
                      PreviewForm.FilePreview.FileName := NewFileName;

                      PreviewForm.FilePreview.ZoomFactor := 70;

                      ReportFiler.Execute;

                      PreviewForm.ShowModal;
                    finally
                      PreviewForm.Free;
                    end;

                  end
                else ReportPrinter.Execute;

            end;  {If not Quit}

      end;  {PrintDialog.Execute}

end;  {PrintCondoIDsButtonClick}

{===================================================================}
Procedure TMappingOptionsForm.MapCondoTableCalcFields(DataSet: TDataSet);

begin
  MapCondoTable.FieldByName('ParcelID').Text := ConvertSBLOnlyToDashDot(MapCondoTable.FieldByName('SBL').Text);
end;

{===================================================================}
Procedure TMappingOptionsForm.AddCondoIDButtonClick(Sender: TObject);

var
  ValidEntry : Boolean;
  SBLRec : SBLRecord;

begin
  try
    MapCondoTable.Append;

      {MFXX02022004-1(M1.42): Can't add a new condo since ParcelID is calculated.}

    If EditNewCondoParcelIDDialogBox.Execute
      then
        begin
          SBLRec := ConvertDashDotSBLToSegmentSBL(EditNewCondoParcelIDDialogBox.Value,
                                                  ValidEntry);

          with SBLRec do
            MapCondoTable.FieldByName('SBL').Text := Section + Subsection + Block +
                                                     Lot + Sublot + Suffix;

          If (SwisCodeTable.RecordCount = 1)
            then
              begin
                MapCondoTable.FieldByName('SwisCode').Text := SwisCodeTable.FieldByName('SwisCode').Text;
                SwisCodeLookupCombo.Text := MapCondoTable.FieldByName('SwisCode').Text;

                CondoIDGrid.SetActiveField('CondoName');
              end
            else CondoIDGrid.SetActiveField('SwisCode');

          CondoIDGrid.SetFocus;

        end
      else MapCondoTable.Cancel;

  except
    MessageDlg('Error adding new condo ID.', mtError, [mbOK], 0);
  end;

end;  {AddCondoIDButtonClick}

{===================================================================}
Procedure TMappingOptionsForm.SaveCondoIDButtonClick(Sender: TObject);

begin
  If (MapCondoTable.State in [dsEdit, dsInsert])
    then
      try
        MapCondoTable.Post;
      except
        MessageDlg('Error saving condo ID.', mtError, [mbOK], 0);
      end;

end;  {SaveCondoIDButtonClick}

{===================================================================}
Procedure TMappingOptionsForm.RemoveCondoIDButtonClick(Sender: TObject);

begin
  If (MessageDlg('Are you sure you want to remove base condominium ID ' + MapCondoTable.FieldByName('ParcelID').Text + '?',
                 mtConfirmation, [mbYes, mbNo], 0) = idYes)
    then
      try
        MapCondoTable.Delete;
      except
        MessageDlg('Error deleting condo ID.', mtError, [mbOK], 0);
      end;

end;  {RemoveCondoIDButtonClick}

{===================================================================}
Procedure TMappingOptionsForm.SBLSegmentGridDrawCell(Sender: TObject;
                                                     ACol, ARow: Integer;
                                                     Rect: TRect;
                                                     State: TGridDrawState);

var
  DrawRow, DrawCol : Integer;

begin
  DrawRow := ARow;
  DrawCol := ACol;

    {FXX11021999-12: Allow the # of forced digits in each segment to be specified.}

  with SBLSegmentGrid do
  If (DrawRow = 0)
    then
      begin
           {Fill in the headers.}

        Font.Size := 10;
        Font.Color := clBlack;
        Font.Style := [fsBold];
        Canvas.Brush.Color := clBtnFace;

        case DrawCol of
          0 : CenterText(Rect, Canvas, '', True, False, clBlue);
          1 : CenterText(Rect, Canvas, 'Section', True, False, clBlue);
          2 : CenterText(Rect, Canvas, 'Subsect', True, False, clBlue);
          3 : CenterText(Rect, Canvas, 'Block', True, False, clBlue);
          4 : CenterText(Rect, Canvas, 'Lot', True, False, clBlue);
          5 : CenterText(Rect, Canvas, 'Sublot', True, False, clBlue);
          6 : CenterText(Rect, Canvas, 'Suffix', True, False, clBlue);

        end;  {case DrawRow of}

      end
    else
      begin
        case DrawCol of
          0 : begin  {Row headers}
                case DrawRow of
                  1 : CenterText(Rect, Canvas, 'L Just', True, False, clBlue);
                  2 : CenterText(Rect, Canvas, 'R Just', True, False, clBlue);
                  3 : CenterText(Rect, Canvas, 'Numeric', True, False, clBlue);
                  4 : CenterText(Rect, Canvas, 'AlphaNum', True, False, clBlue);
                  5 : CenterText(Rect, Canvas, 'Alpha', True, False, clBlue);
                  6 : CenterText(Rect, Canvas, 'SRAZ', True, False, clBlue);
                  7 : CenterText(Rect, Canvas, 'Digits', True, False, clBlue);

                end;  {case Row of}

              end;   {Row headers}

          1..6 :
            If (DrawRow = 7)
              then
                begin
                  Canvas.Brush.Color := clWindow;
                  RightJustifyText(Rect, Canvas,
                                   Cells[DrawCol, DrawRow],
                                   True, False, clBlue, 1);
                end
              else
                begin  {Each of the segments}
                  If SBLSegmentArray[DrawCol, DrawRow]
                    then Canvas.Brush.Color := clGreen
                    else Canvas.Brush.Color := clWindow;

                  CenterText(Rect, Canvas, '',
                             True, False, clBlue);

                 end;  {Each of the segments}

        end;  {case Col of}

      end;  {else of If (Row = 0)}

end;  {SBLSegmentGridDrawCell}

{===================================================================}
Procedure TMappingOptionsForm.SBLSegmentGridClick(Sender: TObject);

begin
  with SBLSegmentGrid do
    If ((Row in [1..6]) and
        (Col in [1..6]))
      then
        begin
          SBLSegmentArray[Col, Row] := not SBLSegmentArray[Col, Row];

          SBLSegmentGridDrawCell(SBLSegmentGrid, Col, Row, CellRect(Col, Row), []);

        end;  {If ((Row in [1..6]) and ...}

end;  {SBLSegmentGridClick}

{=============================================================}
Procedure TMappingOptionsForm.SaveParcelIDFormatButtonClick(Sender: TObject);

var
  Col, Row, FieldPos : Integer;

begin
  If (MapParcelIDTable.State = dsBrowse)
    then MapParcelIDTable.Edit;

  For Col := 1 to 6 do
    For Row := 1 to 7 do
      begin
        FieldPos := FirstSBLFormatFieldOffset + (Row + (Col - 1) * 7) - 1;

        If (Row <= 6)
          then MapParcelIDTable.Fields[FieldPos].AsBoolean := SBLSegmentArray[Col, Row]
          else
            try
              MapParcelIDTable.Fields[FieldPos].AsInteger := StrToInt(SBLSegmentGrid.Cells[Col, Row]);
            except
              MapParcelIDTable.Fields[FieldPos].AsInteger := 0;
            end;

      end;  {For Row := 1 to 6 do}

  with MapParcelIDTable do
    try
      FieldByName('SectionSeparator').Text := Take(1, FieldByName('SectionSeparator').Text);
      FieldByName('SubsectionSeparator').Text := Take(1, FieldByName('SubsectionSeparator').Text);
      FieldByName('BlockSeparator').Text := Take(1, FieldByName('BlockSeparator').Text);
      FieldByName('LotSeparator').Text := Take(1, FieldByName('LotSeparator').Text);
      FieldByName('SublotSeparator').Text := Take(1, FieldByName('SublotSeparator').Text);

      Post;
    except
      SystemSupport(005, MapParcelIDTable,
                    'Error saving parcel ID format.',
                    UnitName, GlblErrorDlgBox);
    end;

end;  {SaveParcelIDFormatButtonClick}

{=============================================================}
Procedure TMappingOptionsForm.CancelParcelIDFormatButtonClick(Sender: TObject);

begin
  If (MapParcelIDTable.State = dsEdit)
    then
      begin
        MapParcelIDTable.Cancel;
        FillInSBLFormatGrid;
      end;

end;  {CancelParcelIDFormatButtonClick}

{===================================================================}
Procedure TMappingOptionsForm.PresetMapCodesGridDblClick(Sender: TObject);

{CHG11112003-5(M1.4): Change to the map preset that they chose.}

begin
  Close;
end;

{===================================================================}
Procedure TMappingOptionsForm.FormClose(    Sender: TObject;
                                  var Action: TCloseAction);

begin
  If not CloseOnStart
    then
      begin
        ReturnSetupName := MappingHeaderTable.FieldByName('MappingSetupName').Text;

        SaveAutoloadLayers;

        CloseTablesForForm(Self);

      end;  {If not CloseOnStart}

end;  {FormClose}

end.
