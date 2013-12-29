unit dlg_StreetRange;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ToolWin, ComCtrls;

type
  TStreetRangeDialog = class(TForm)
    MainToolBar: TToolBar;
    SaveAndExitButton: TSpeedButton;
    CancelButton: TSpeedButton;
    StartingRangeGroupBox: TGroupBox;
    edt_StartingStreetNumber: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    edt_StartingStreet: TEdit;
    EndingStreetGroupBox: TGroupBox;
    Label3: TLabel;
    Label4: TLabel;
    edt_EndingStreetNumber: TEdit;
    edt_EndingStreet: TEdit;
    procedure SaveAndExitButtonClick(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
    StartingStreetNumber,
    StartingStreet,
    EndingStreetNumber,
    EndingStreet : String;

    Procedure Load(_StartingStreetNumber : String;
                   _StartingStreet : String;
                   _EndingStreetNumber : String;
                   _EndingStreet : String);

    Procedure Save;

  end;

var
  StreetRangeDialog: TStreetRangeDialog;

implementation

{$R *.DFM}

uses Utilitys, GlblCnst;

{===============================================================}
Procedure TStreetRangeDialog.FormKeyPress(    Sender: TObject;
                                          var Key: Char);

begin
  If _Compare(Key, #13, coEqual)
    then
      begin
        Key := #0;
        Perform(WM_NEXTDLGCTL, 0, 0);
      end;

end;  {FormKeyPress}

{===============================================================}
Procedure TStreetRangeDialog.Load(_StartingStreetNumber : String;
                                  _StartingStreet : String;
                                  _EndingStreetNumber : String;
                                  _EndingStreet : String);

begin
  edt_StartingStreetNumber.Text := _StartingStreetNumber;
  edt_StartingStreet.Text := _StartingStreet;
  edt_EndingStreetNumber.Text := _EndingStreetNumber;
  edt_EndingStreet.Text := _EndingStreet;

end;  {Load}

{===============================================================}
Procedure TStreetRangeDialog.Save;

begin
  StartingStreetNumber := edt_StartingStreetNumber.Text;
  StartingStreet := edt_StartingStreet.Text;
  EndingStreetNumber := edt_EndingStreetNumber.Text;
  EndingStreet := edt_EndingStreet.Text;

end;  {Save}

{===============================================================}
Procedure TStreetRangeDialog.SaveAndExitButtonClick(Sender: TObject);

begin
  Save;
  ModalResult := mrOK;

end;  {SaveAndExitButtonClick}

{===============================================================}
Procedure TStreetRangeDialog.CancelButtonClick(Sender: TObject);

begin
  ModalResult := mrCancel;
end;

end.
