unit MapCriteriaSearchDialogUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Buttons;

type
  TMapCriteriaSearchDialog = class(TForm)
    ProceedButton: TBitBtn;
    CancelButton: TBitBtn;
    MapSizeRadioGroup: TRadioGroup;
    LimitExtentCheckBox: TCheckBox;
    Label1: TLabel;
    procedure ProceedButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    LimitExtent : Boolean;
    ExpandToFullSize : Boolean;
  end;


var
  MapCriteriaSearchDialog: TMapCriteriaSearchDialog;

implementation

{$R *.DFM}

{=================================================================}
Procedure TMapCriteriaSearchDialog.ProceedButtonClick(Sender: TObject);

begin
  LimitExtent := LimitExtentCheckBox.Checked;
  ExpandToFullSize := (MapSizeRadioGroup.ItemIndex = 1);
  ModalResult := mrOK;

end;  {ProceedButtonClick}

end.
