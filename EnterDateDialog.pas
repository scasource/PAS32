unit EnterDateDialog;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, Db, DBTables, Mask;

type
  TEnterDateDialogForm = class(TForm)
    PromptLabel: TLabel;
    OKButton: TBitBtn;
    CancelButton: TBitBtn;
    DateEdit: TMaskEdit;
    procedure OKButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    DateEntered : TDateTime;
  end;

var
  EnterDateDialogForm: TEnterDateDialogForm;

implementation

{$R *.DFM}

uses GlblVars, WinUtils;

{===============================================}
Procedure TEnterDateDialogForm.OKButtonClick(Sender: TObject);

var
  DateOK : Boolean;

begin
  If (DateEdit.Text = '  /  /    ')
    then
      begin
        MessageDlg('Please enter a date.', mtError,
                   [mbOK], 0);
        DateEdit.SetFocus;
      end
    else
      begin
        DateOK := True;

        try
          DateEntered := StrToDate(DateEdit.Text);
        except
          MessageDlg(DateEdit.Text + ' is not a valid date.' + #13 +
                     'Please re-enter.', mtInformation, [mbOK], 0);
        end;

        If DateOK
          then ModalResult := idOK;

      end;  {else of If (DateEdit.Text = '  /  /    ')}

end;  {OKButtonClick}

end.
