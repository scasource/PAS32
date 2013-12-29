unit MapRangeEditItemDialogUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Buttons, PASTypes;

type
  TMapRangeEditItemDialog = class(TForm)
    OKButton: TBitBtn;
    CancelButton: TBitBtn;
    LowValueLabel: TLabel;
    LowValueEdit: TEdit;
    HighValueLabel: TLabel;
    HighValueEdit: TEdit;
    Label4: TLabel;
    ColorShape: TShape;
    ColorButton: TButton;
    ColorDialog: TColorDialog;
    procedure FormShow(Sender: TObject);
    procedure ColorButtonClick(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    MapRangeItemRec : MapRangeItemRecord;
  end;

var
  MapRangeEditItemDialog: TMapRangeEditItemDialog;

implementation

{$R *.DFM}

{===================================================}
Procedure TMapRangeEditItemDialog.FormShow(Sender: TObject);

begin
  with MapRangeItemRec do
    begin
      LowValueEdit.Text := LowValue;
      HighValueEdit.Text := HighValue;
      ColorShape.Brush.Color := Color;
      ColorShape.Refresh;
    end;  {with MapRangeItemRec do}

end;  {FormShow}

{===================================================}
Procedure TMapRangeEditItemDialog.ColorButtonClick(Sender: TObject);

begin
  ColorDialog.Color := ColorShape.Brush.Color;
  If ColorDialog.Execute
    then
      begin
        ColorShape.Brush.Color := ColorDialog.Color;
        ColorShape.Refresh;
      end;

end;  {ColorButtonClick}

{===================================================}
Procedure TMapRangeEditItemDialog.OKButtonClick(Sender: TObject);

begin
  with MapRangeItemRec do
    begin
      LowValue := LowValueEdit.Text;
      HighValue := HighValueEdit.Text;
      Color := ColorShape.Brush.Color;
    end;

end;  {OKButtonClick}

end.
