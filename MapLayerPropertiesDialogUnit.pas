unit MapLayerPropertiesDialogUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, DBTables, Wwtable, StdCtrls, Mask, wwdbedit, Buttons, ExtCtrls,
  ComCtrls;

type
  TMappingOptionsSetupAddLayerDialog = class(TForm)
    LayerInformationGroupBox: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    FindLayerButton: TBitBtn;
    LocationEdit: TwwDBEdit;
    LayerNameEdit: TwwDBEdit;
    MapLayersAvailableTable: TwwTable;
    ClassificationOptionsRadioGroup: TRadioGroup;
    Label3: TLabel;
    LayerTypeEdit: TwwDBEdit;
    Panel1: TPanel;
    ClassificationNotebook: TNotebook;
    Label8: TLabel;
    Label9: TLabel;
    FillStyleComboBox: TComboBox;
    FillColorButton: TButton;
    EditSingleSymbolColor: TEdit;
    Panel2: TPanel;
    Label4: TLabel;
    Panel3: TPanel;
    Label5: TLabel;
    MapFieldComboBox: TComboBox;
    Label6: TLabel;
    UniqueValuesListView: TListView;
    Label7: TLabel;
    DisplayOutlineCheckBox: TCheckBox;
    DisplayTextCheckBox: TCheckBox;
    procedure ClassificationOptionsRadioGroupClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }

    Procedure Initialize(LayerName : String;
                         EditMode : Char);

  end;

var
  MappingOptionsSetupAddLayerDialog: TMappingOptionsSetupAddLayerDialog;

implementation

{$R *.DFM}

uses GlblCnst, DataAccessUnit;

const
  pgSingleSymbol = 0;
  pgUniqueValues = 1;
  pgClassBreaks = 2;
  pgStandardLabels = 3;
  pgNoOverlappingLabels = 4;

{======================================================================}
Procedure TMappingOptionsSetupAddLayerDialog.Initialize(LayerName : String;
                                                        EditMode : Char);

begin
  If (EditMode = emBrowse)
    then
      begin
        MapLayersTable.ReadOnly := True;
      end;

  MapLayersAvailableTable.Open;

  case EditMode of
    emEdit,
    emBrowse : _Locate(MapLayersAvailableTable, [LayerName], '', []);

    emInsert : begin
               end;

  end;  {case EditMode of}

end;  {Initialize}

{================================================================================}
Procedure TMappingOptionsSetupAddLayerDialog.ClassificationOptionsRadioGroupClick(Sender: TObject);

begin
  ClassificationNotebook.PageIndex := ClassificationOptionsRadioGroup.ItemIndex;
end;

end.
