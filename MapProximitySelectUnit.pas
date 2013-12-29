unit MapProximitySelectUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls;

type
  TMapProximitySelectDialog = class(TForm)
    ProximityTypeRadioGroup: TRadioGroup;
    LocateButton: TBitBtn;
    OKButton: TBitBtn;
    CancelButton: TBitBtn;
    PrintLabelsCheckBox: TCheckBox;
    Label2: TLabel;
    ProximityRadiusEdit: TEdit;
    Label1: TLabel;
    UseAlreadySelectedParcelsCheckBox: TCheckBox;
    procedure OKButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject);
    procedure LocateButtonClick(Sender: TObject);
  private
    { Private declarations }
    OriginalSwisSBLKey : String;
  public
    { Public declarations }
    SwisSBLKey : String;
    ProximityRadius : Double;
    ProximityType : Integer;
    PrintLabels : Boolean;
    UseAlreadySelectedParcels : Boolean;

    Procedure SetCaption;
  end;

var
  MapProximitySelectDialog: TMapProximitySelectDialog;

implementation

{$R *.DFM}

uses PASUtils, Prclocat, Utilitys;

{====================================================================}
Procedure TMapProximitySelectDialog.SetCaption;

begin
  If (SwisSBLKey = '')
    then Caption := 'Highlight proximate parcels'
    else Caption := 'Proximate parcels from ' +
                    ConvertSwisSBLToDashDot(SwisSBLKey);

end;  {SetCaption}

{====================================================================}
Procedure TMapProximitySelectDialog.FormShow(Sender: TObject);

begin
  OriginalSwisSBLKey := SwisSBLKey;
  SetCaption;
end;  {FormShow}

{====================================================================}
Procedure TMapProximitySelectDialog.LocateButtonClick(Sender: TObject);

begin
  LocateParcelForm.WindowState := wsNormal;
  If ExecuteParcelLocateDialog(SwisSBLKey, True, False, 'Locate a Parcel', False, nil)
    then SetCaption;

end;  {LocateButtonClick}

{====================================================================}
Procedure TMapProximitySelectDialog.OKButtonClick(Sender: TObject);

var
  Continue : Boolean;

begin
  Continue := True;
  ProximityType := ProximityTypeRadioGroup.ItemIndex;
  PrintLabels := PrintLabelsCheckBox.Checked;
  UseAlreadySelectedParcels := UseAlreadySelectedParcelsCheckBox.Checked;

  try
    ProximityRadius := StrToFloat(ProximityRadiusEdit.Text);
  except
    Continue := False;
    MessageDlg('Please enter a valid number of feet for the proximity.',
               mtError, [mbOK], 0);
  end;

  If (Deblank(SwisSBLKey) = '')
    then
      begin
        Continue := False;
        MessageDlg('Please select a parcel to find the distance from.',
                   mtError, [mbOK], 0);
        LocateButton.SetFocus;

      end;  {If (Deblank(SwisSBLKey) = '')}

  If Continue
    then ModalResult := mrOK;

end;  {OKButtonClick}

{====================================================================}
Procedure TMapProximitySelectDialog.CancelButtonClick(Sender: TObject);

begin
  SwisSBLKey := OriginalSwisSBLKey;
  ModalResult := mrCancel;
end;


end.
