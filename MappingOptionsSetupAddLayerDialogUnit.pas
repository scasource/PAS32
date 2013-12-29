unit MappingOptionsSetupAddLayerDialogUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, DBTables, Wwtable, StdCtrls, Mask, wwdbedit, Buttons, ExtCtrls;

type
  TMappingOptionsSetupAddLayerDialog = class(TForm)
    LayerInformationGroupBox: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    FindLayerButton: TBitBtn;
    wwDBEdit1: TwwDBEdit;
    wwDBEdit2: TwwDBEdit;
    MapLayersAvailableTable: TwwTable;
    RadioGroup1: TRadioGroup;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MappingOptionsSetupAddLayerDialog: TMappingOptionsSetupAddLayerDialog;

implementation

{$R *.DFM}

end.
