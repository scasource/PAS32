unit MapPrintTypeDialogUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Buttons;

type
  MapPrintTypes = (mptMap, mptLabels, mptParcelList);
  MapPrintTypeSet = set of MapPrintTypes;

type
  TMapPrintTypeDialog = class(TForm)
    OKButton: TBitBtn;
    CancelButton: TBitBtn;
    PrintGroupBox: TGroupBox;
    MapCheckBox: TCheckBox;
    LabelsCheckBox: TCheckBox;
    ParcelListCheckBox: TCheckBox;
    procedure OKButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    PrintType : MapPrintTypeSet;
  end;

var
  MapPrintTypeDialog: TMapPrintTypeDialog;

implementation

{$R *.DFM}

{==========================================================}
Procedure TMapPrintTypeDialog.OKButtonClick(Sender: TObject);

begin
  PrintType := [];

  If MapCheckBox.Checked
    then PrintType := PrintType + [mptMap];

  If LabelsCheckBox.Checked
    then PrintType := PrintType + [mptLabels];

  If ParcelListCheckBox.Checked
    then PrintType := PrintType + [mptParcelList];

  ModalResult := mrOK;

end;  {OKButtonClick}

end.
