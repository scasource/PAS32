unit Upayedit;

interface

uses
   SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, DB, DBTables, Wwtable, Wwdatsrc,BtrvDlg,
  Buttons, Types, ExtCtrls,Mask, Wwdbedit, Progress, Utilitys, Grids,
  Wwdbigrd, Wwdbgrid, BtrConv, DBCtrls;

type
  TUPayFileEditForm = class(TForm)
    CloseButton: TBitBtn;
    PayFile: TwwTable;
    PayDataSource: TwwDataSource;
    wwDBGrid1: TwwDBGrid;
    DBNavigator1: TDBNavigator;
    IndexGroup: TRadioGroup;
    procedure CloseButtonClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure IndexGroupClick(Sender: TObject);
  private
    { Private declarations }
    REcordCount : Integer;


  public
    Procedure InitializeForm;  {Open the tables and setup.}




{Get one field from the extract record based on the length, start and stop position.}

    { Public declarations }
  end;

var
  UPayFileEditForm: TUPayFileEditForm;



implementation
Uses WINUTILS, Glblvars,TaxUtil1, Glblcnst;
{$R *.DFM}
CONST
  Unitname = 'RPSIMPRT.PAS';
  debug = false;

{========================================================}

Procedure TUPayFileEditForm.InitializeForm;

var
  I : Integer;
  Quit : Boolean;

begin
  opentablesforform(self);

  If take(10,GlblUserName) <> take(10,'SUPERVISOR') THEN
    begin
    PayFile.readonly := true;
    messagedlg('Only the supervisor can edit this file, you can only read.',
                  mtinformation,[mbOK],0);
    end;

end;  {InitializeForm}

{============================================================================}

procedure TUPayFileEditForm.CloseButtonClick(Sender: TObject);
begin
  Close;
end;
{=================================================================}

procedure TUPayFileEditForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
CloseTablesForForm(Self);
Action := caFree;
GlblClosingAForm := True;
end;
{=================================================================}
procedure TUPayFileEditForm.IndexGroupClick(Sender: TObject);
begin
PayFile.indexName := IndexGroup.items[IndexGroup.itemIndex];
end;
{=================================================================}
end.