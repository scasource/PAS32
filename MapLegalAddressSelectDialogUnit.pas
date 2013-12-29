unit MapLegalAddressSelectDialogUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Buttons;

type
  TMapLegalAddressSelectDialog = class(TForm)
    OKButton: TBitBtn;
    CancelButton: TBitBtn;
    Label1: TLabel;
    LegalAddressEdit: TEdit;
    NumberGroupBox: TGroupBox;
    Label9: TLabel;
    Label10: TLabel;
    StartNumberEdit: TEdit;
    AllNumbersCheckBox: TCheckBox;
    ToEndOfNumbersCheckBox: TCheckBox;
    EndNumberEdit: TEdit;
    procedure AllNumbersCheckBoxClick(Sender: TObject);
    procedure ToEndOfNumbersCheckBoxClick(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    LegalAddress : String;
    LegalAddressNumberStart, LegalAddressNumberEnd : String;
    AllLegalAddressNumbers, ToEndOfLegalAddressNumbers : Boolean;
  end;

var
  MapLegalAddressSelectDialog: TMapLegalAddressSelectDialog;

implementation

{$R *.DFM}


uses WinUtils;

{==========================================================}
Procedure TMapLegalAddressSelectDialog.AllNumbersCheckBoxClick(Sender: TObject);

begin
 If AllNumbersCheckBox.Checked
    then
      begin
        ToEndofNumbersCheckBox.Checked := False;
        ToEndofNumbersCheckBox.Enabled := False;
        StartNumberEdit.Text := '';
        StartNumberEdit.Enabled := False;
        StartNumberEdit.Color := clBtnFace;
        EndNumberEdit.Text := '';
        EndNumberEdit.Enabled := False;
        EndNumberEdit.Color := clBtnFace;
      end
    else EnableSelectionsInGroupBoxOrPanel(NumberGroupBox);

end;  {AllNumbersCheckBoxClick}

{=============================================================}
Procedure TMapLegalAddressSelectDialog.ToEndOfNumbersCheckBoxClick(Sender: TObject);

begin
 If ToEndOfNumbersCheckBox.Checked
    then
      begin
        EndNumberEdit.Text := '';
        EndNumberEdit.Enabled := False;
        EndNumberEdit.Color := clBtnFace;
      end
    else EnableSelectionsInGroupBoxOrPanel(NumberGroupBox);

end;  {ToEndOfNumbersCheckBoxClick}

{=========================================================}
Procedure TMapLegalAddressSelectDialog.OKButtonClick(Sender: TObject);

var
  Continue : Boolean;

begin
  Continue := True;

  If (Trim(LegalAddressEdit.Text) = '')
    then
      begin
        Continue := False;
        MessageDlg('Please enter a legal address street to search for.',
                   mtError, [mbOK], 0);
        LegalAddressEdit.SetFocus;

      end;  {If (Trim(LegalAddressEdit.Text) = '')}

  If Continue
    then
      begin
        If ((Trim(StartNumberEdit.Text) = '') and
            (Trim(EndNumberEdit.Text) = '') and
            (not ToEndOfNumbersCheckBox.Checked))
          then AllNumbersCheckBox.Checked := True;

        AllLegalAddressNumbers := AllNumbersCheckBox.Checked;
        ToEndOfLegalAddressNumbers := ToEndOfNumbersCheckBox.Checked;
        LegalAddress := LegalAddressEdit.Text;

        If not AllLegalAddressNumbers
          then
            begin
              LegalAddressNumberStart := StartNumberEdit.Text;
              LegalAddressNumberEnd := EndNumberEdit.Text;

            end;  {If not AllLegalAddressNumbers}

        ModalResult := mrOK;

      end;  {If Continue}

end;  {OKButtonClick}

end.
