unit ApexActionDialogUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls;

type
  TApexActionDialogForm = class(TForm)
    Label2: TLabel;
    ApexSketchRadioGroup: TRadioGroup;
    OKButton: TBitBtn;
    CancelButton: TBitBtn;
    procedure OKButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    ApexActionType : Integer;
  end;

var
  ApexActionDialogForm: TApexActionDialogForm;

const
  apExistingSketch = 0;
  apNewSketch = 1;
  
implementation

{$R *.DFM}

{====================================================================}
Procedure TApexActionDialogForm.OKButtonClick(Sender: TObject);

begin
  ApexActionType := ApexSketchRadioGroup.ItemIndex;
end;

end.
