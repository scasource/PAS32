unit EmailAddressMaintenance;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, Db, Wwdatsrc, DBTables, Wwtable, Grids, Wwdbigrd,
  Wwdbgrid;

type
  TEmailAddressesForm = class(TForm)
    EmailAddressGrid: TwwDBGrid;
    EmailAddressTable: TwwTable;
    EmailAddressDataSource: TwwDataSource;
    NewButton: TBitBtn;
    RemoveButton: TBitBtn;
    SaveButton: TBitBtn;
    Label1: TLabel;
    procedure NewButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure RemoveButtonClick(Sender: TObject);
    procedure SaveButtonClick(Sender: TObject);
    procedure EmailAddressGridDblClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
    EmailAddress : String;
  end;

var
  EmailAddressesForm: TEmailAddressesForm;

implementation

{$R *.DFM}

{==========================================================================}
Procedure TEmailAddressesForm.FormCreate(Sender: TObject);

begin
  try
    EmailAddressTable.Open;
  except
    MessageDlg('Error opening email address table.', mtError, [mbOK], 0);
  end;

end;  {FormCreate}

{==========================================================================}
Procedure TEmailAddressesForm.NewButtonClick(Sender: TObject);

begin
  try
    EmailAddressTable.Append;
    EmailAddressGrid.SetActiveField('Person');
    EmailAddressGrid.SetFocus;
  except
    MessageDlg('Error adding a new email address.', mtError, [mbOK], 0);
  end;

end;  {NewButtonClick}

{==========================================================================}
Procedure TEmailAddressesForm.RemoveButtonClick(Sender: TObject);

begin
  If (MessageDlg('Are you sure you want to remove ' +
                 Trim(EmailAddressTable.FieldByName('Person').Text) + '?',
                 mtConfirmation, [mbYes, mbNo], 0) = idYes)
    then
      try
        EmailAddressTable.Delete;
      except
        MessageDlg('Error removing email address.', mtError, [mbOK], 0);
      end;

end;  {RemoveButtonClick}

{==========================================================================}
Procedure TEmailAddressesForm.SaveButtonClick(Sender: TObject);

begin
  If (EmailAddressTable.State in [dsEdit, dsInsert])
    then
      try
        EmailAddressTable.Post;
      except
        MessageDlg('Error saving email address.', mtError, [mbOK], 0);
      end;

end;  {SaveButtonClick}

{==========================================================================}
Procedure TEmailAddressesForm.EmailAddressGridDblClick(Sender: TObject);

begin
  ModalResult := mrOK;
  Close;
end;

{==========================================================================}
Procedure TEmailAddressesForm.FormClose(    Sender: TObject;
                                        var Action: TCloseAction);

begin
  SaveButtonClick(Sender);
  EmailAddress := EmailAddressTable.FieldByName('EmailAddress').Text;
end;

end.
