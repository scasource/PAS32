unit MapExtractMainLayerInformationDialogUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Buttons, StdCtrls, ExtCtrls, PASTypes, Mask, Db, DBTables, MapObjects2_TLB,
  OleCtrls, ComObj;

type
  TExtractMainLayerInformationDialog = class(TForm)
    OKButton: TBitBtn;
    CancelButton: TBitBtn;
    Panel1: TPanel;
    MapSizeRadioGroup: TRadioGroup;
    PASFieldsToExtractListBox: TListBox;
    Label1: TLabel;
    GISFieldsToExtractListBox: TListBox;
    Label2: TLabel;
    ScreenLabelTable: TTable;
    procedure OKButtonClick(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    MainLayerFieldsToExtractList,
    ParcelTableFieldsToExtractList : TStringList;
    UseFullMapExtent : Boolean;
    ScreenLabelList : TList;

    Procedure InitializeForm(_MainLayerFieldsToExtractList : TStringList;
                             _ParcelTableFieldsToExtractList : TStringList;
                             MainLayerRecordset : IMORecordSet);

  end;

var
  ExtractMainLayerInformationDialog: TExtractMainLayerInformationDialog;

implementation


{$R *.DFM}

uses WinUtils, PASUtils, GlblCnst, GlblVars, Utilitys;

{================================================================}
Procedure TExtractMainLayerInformationDialog.InitializeForm(_MainLayerFieldsToExtractList : TStringList;
                                                            _ParcelTableFieldsToExtractList : TStringList;
                                                            MainLayerRecordset : IMORecordSet);

var
  I : Integer;
  TableDescription : IMoTableDesc;
  Fields : IMoFields;

begin
  MainLayerFieldsToExtractList := _MainLayerFieldsToExtractList;
  ParcelTableFieldsToExtractList := _ParcelTableFieldsToExtractList;

  ScreenLabelTable.Open;

    {Fill in the PAS fields available.}

  ScreenLabelList := TList.Create;

  LoadScreenLabelList(ScreenLabelList, ScreenLabelTable, nil, False,
                      True, True, [slBaseInformation]);

  For I := 0 to (ScreenLabelList.Count - 1) do
    PASFieldsToExtractListBox.Items.Add(ScreenLabelPtr(ScreenLabelList[I])^.LabelName);

    {Fill in the GIS fields available.}

  TableDescription := IMoTableDesc(CreateOleObject('MapObjects2.TableDesc'));
  TableDescription := MainLayerRecordset.TableDesc;
  Fields := MainLayerRecordset.Fields;

  For I := 0 to (TableDescription.FieldCount - 1) do
    GISFieldsToExtractListBox.Items.Add(Fields.Item(TableDescription.FieldName[I]).Name);

  ScreenLabelTable.Close;

end;  {InitializeForm}

{================================================================}
Procedure TExtractMainLayerInformationDialog.OKButtonClick(Sender: TObject);

var
  I : Integer;

begin
  UseFullMapExtent := (MapSizeRadioGroup.ItemIndex = 1);

  MainLayerFieldsToExtractList.Clear;
  ParcelTableFieldsToExtractList.Clear;

  with PASFieldsToExtractListBox do
    For I := 0 to (Items.Count - 1) do
      If Selected[I]
        then ParcelTableFieldsToExtractList.Add(Trim(ScreenLabelPtr(ScreenLabelList[I])^.FieldName));

  with GISFieldsToExtractListBox do
    For I := 0 to (Items.Count - 1) do
      If Selected[I]
        then MainLayerFieldsToExtractList.Add(Trim(Items[I]));

  FreeTList(ScreenLabelList, SizeOf(ScreenLabelRecord));
  ModalResult := mrOK;

end;  {OKButtonClick}

{==================================================================}
Procedure TExtractMainLayerInformationDialog.CancelButtonClick(Sender: TObject);

begin
  ModalResult := mrCancel;
end;


end.
