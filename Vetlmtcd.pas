unit Vetlmtcd;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, DBCtrls, DBTables, DB, Buttons, Grids,
  Wwdbigrd, Wwdbgrid, ExtCtrls, Wwtable, Wwdatsrc, Menus;

type
  TVeteransLimitsCodesForm = class(TForm)
    DataSource: TwwDataSource;
    VeteransLimitTable: TwwTable;
    Panel1: TPanel;
    Panel2: TPanel;
    ScrollBox1: TScrollBox;
    VeteransCodeGrid: TwwDBGrid;
    TitleLabel: TLabel;
    Panel3: TPanel;
    CloseButton: TBitBtn;
    btn_SaveCode: TBitBtn;
    btn_DeleteCode: TBitBtn;
    btn_NewCode: TBitBtn;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure VeteransLimitTableBeforePost(DataSet: TDataset);
    procedure FormActivate(Sender: TObject);
    procedure btn_NewCodeClick(Sender: TObject);
    procedure btn_DeleteCodeClick(Sender: TObject);
    procedure btn_SaveCodeClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    UnitName : String;
    FormAccessRights : Integer;  {Read only or read write, based on security level?}
                                {Values = raReadOnly, raReadWrite}
    Procedure InitializeForm;  {Open the tables and setup.}

  end;

implementation

uses GlblVars, WinUtils, Utilitys, GlblCnst, PASUtils;

{$R *.DFM}

{========================================================}
Procedure TVeteransLimitsCodesForm.FormActivate(Sender: TObject);

begin
  SetFormStateMaximized(Self);
end;

{========================================================}
Procedure TVeteransLimitsCodesForm.InitializeForm;

begin
  UnitName := 'VETLMTCD';

  If (FormAccessRights = raReadOnly)
    then VeteransLimitTable.ReadOnly := True;

  OpenTablesForForm(Self, GlblProcessingType);

    {Set the display format for the fields.}

   TFloatField(VeteransLimitTable.FieldByName('EligibleFundsLimit')).DisplayFormat := CurrencyEditDisplay;
   TFloatField(VeteransLimitTable.FieldByName('BasicVetLimit')).DisplayFormat := CurrencyEditDisplay;
   TFloatField(VeteransLimitTable.FieldByName('CombatVetLimit')).DisplayFormat := CurrencyEditDisplay;
   TFloatField(VeteransLimitTable.FieldByName('DisabledVetLimit')).DisplayFormat := CurrencyEditDisplay;

end;  {InitializeForm}

{===================================================================}
Procedure TVeteransLimitsCodesForm.FormKeyPress(    Sender: TObject;
                                     var Key: Char);

begin
  If (Key = #13)
    then
      begin
        Key := #0;
        Perform(WM_NEXTDLGCTL, 0, 0);
      end;

end;  {FormKeyPress}

{===================================================================}
Procedure TVeteransLimitsCodesForm.VeteransLimitTableBeforePost(DataSet: TDataset);

begin
  If (VeteransLimitTable.State = dsInsert)
    then VeteransLimitTable.FieldByName('Code').AsString := ANSIUpperCase(VeteransLimitTable.FieldByName('Code').AsString);

end;

{===================================================================}
Procedure TVeteransLimitsCodesForm.btn_NewCodeClick(Sender: TObject);

begin
  try
    VeteransLimitTable.Append;
  except
  end;

end;

{===================================================================}
Procedure TVeteransLimitsCodesForm.btn_DeleteCodeClick(Sender: TObject);

begin
  try
    VeteransLimitTable.Delete;
  except
  end;

end;

{===================================================================}
Procedure TVeteransLimitsCodesForm.btn_SaveCodeClick(Sender: TObject);

begin
  try
    VeteransLimitTable.Post;
  except
  end;

end;

{===================================================================}
Procedure TVeteransLimitsCodesForm.FormClose(    Sender: TObject;
                                             var Action: TCloseAction);

begin
  CloseTablesForForm(Self);

    {Free up the child window and set the ClosingAForm Boolean to
     true so that we know to delete the tab.}

  Action := caFree;
  GlblClosingAForm := True;
  GlblClosingFormCaption := Caption;

end;  {FormClose}

end.
