unit NewLawyerDialog;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, Wwdatsrc, DBTables, Wwtable, StdCtrls, Mask, DBCtrls, Buttons;

type
  TNewLawyerForm = class(TForm)
    LawyerDataSource: TwwDataSource;
    UndoButton: TBitBtn;
    GroupBox1: TGroupBox;
    LawyerTable: TwwTable;
    MainCodeLabel: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    SwisLabel: TLabel;
    Label17: TLabel;
    Label3: TLabel;
    Label28: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    MainCodeEdit: TDBEdit;
    EditName: TDBEdit;
    EditName2: TDBEdit;
    EditAddress: TDBEdit;
    EditAddress2: TDBEdit;
    EditStreet: TDBEdit;
    EditCity: TDBEdit;
    EditState: TDBEdit;
    EditZip: TDBEdit;
    EditZipPlus4: TDBEdit;
    EditPhoneNumber: TDBEdit;
    EditFaxNumber: TDBEdit;
    EditAttorneyName: TDBEdit;
    EditEmail: TDBEdit;
    SaveButton: TBitBtn;
    LawyerCodeLookupTable: TwwTable;
    procedure SaveButtonClick(Sender: TObject);
    procedure UndoButtonClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
    LawyerSelected : String;
    Procedure InitializeForm;
  end;

var
  NewLawyerForm: TNewLawyerForm;

implementation

{$R *.DFM}

uses PASUtils, WinUtils, GlblVars;

{=========================================================================}
Procedure TNewLawyerForm.InitializeForm;

begin
  LawyerSelected := '';
  OpenTablesForForm(Self, GlblProcessingType);

  try
    LawyerTable.Insert;
  except
  end;

end;  {InitializeForm}

{=========================================================================}
Procedure TNewLawyerForm.FormKeyPress(Sender: TObject; var Key: Char);

begin
  If (Key = #13)
    then
      begin
        Key := #0;
        Perform(WM_NEXTDLGCTL, 0, 0);
      end;

end;  {FormKeyPress}

{=========================================================================}
Procedure TNewLawyerForm.UndoButtonClick(Sender: TObject);

begin
  LawyerTable.Cancel;
  ModalResult := mrCancel;
end;

{=========================================================================}
Procedure TNewLawyerForm.SaveButtonClick(Sender: TObject);

begin
  case LawyerTable.State of
    dsEdit :
      try
        LawyerTable.Post;
        LawyerSelected := LawyerTable.FieldByName('Code').Text;
        ModalResult := mrOK;
      except
      end;

    dsInsert :
      begin
          {FXX02022004-1(2.07l): Need to check for duplicates on a lookup table.}
          
        If FindKeyOld(LawyerCodeLookupTable, ['Code'], [LawyerTable.FieldByName('Code').Text])
          then
            begin
              MessageDlg('A representative already exists with the code ' +
                         LawyerTable.FieldByName('Code').Text + '.' + #13 +
                         'Please enter a different code.',
                         mtError, [mbOK], 0);
              MainCodeEdit.SetFocus;
            end
          else
            try
              LawyerTable.Post;
              LawyerSelected := LawyerTable.FieldByName('Code').Text;
              ModalResult := mrOK;
            except
            end;

      end;  {dsInsert}

  end;  {case LawyerTable.State of}
  
end;  {SaveButtonClick}

{=========================================================================}
Procedure TNewLawyerForm.FormCloseQuery(    Sender: TObject;
                                       var CanClose: Boolean);

begin
  SaveButtonClick(Sender);
end;


end.
