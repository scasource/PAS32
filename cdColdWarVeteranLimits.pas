unit cdColdWarVeteranLimits;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, DBCtrls, DBTables, DB, Buttons, Grids,
  Wwdbigrd, Wwdbgrid, ExtCtrls, Wwtable, Wwdatsrc, Menus;

type
  TfmColdWarVeteranLimits = class(TForm)
    dsColdWarVeteranLimits: TwwDataSource;
    tbColdWarVeteranLimits: TwwTable;
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
    procedure tbColdWarVeteranLimitsBeforePost(DataSet: TDataset);
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
Procedure TfmColdWarVeteranLimits.FormActivate(Sender: TObject);

begin
  SetFormStateMaximized(Self);
end;

{========================================================}
Procedure TfmColdWarVeteranLimits.InitializeForm;

begin
  UnitName := 'cdColdWarVeteranLimits';

  If (FormAccessRights = raReadOnly)
    then tbColdWarVeteranLimits.ReadOnly := True;

  OpenTablesForForm(Self, GlblProcessingType);

    {Set the display format for the fields.}

   TFloatField(tbColdWarVeteranLimits.FieldByName('BasicLimit')).DisplayFormat := CurrencyEditDisplay;
   TFloatField(tbColdWarVeteranLimits.FieldByName('BasicPercent')).DisplayFormat := CurrencyEditDisplay;
   TFloatField(tbColdWarVeteranLimits.FieldByName('DisabledVetLimit')).DisplayFormat := CurrencyEditDisplay;

end;  {InitializeForm}

{===================================================================}
Procedure TfmColdWarVeteranLimits.FormKeyPress(    Sender: TObject;
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
Procedure TfmColdWarVeteranLimits.tbColdWarVeteranLimitsBeforePost(DataSet: TDataset);

begin
  If (tbColdWarVeteranLimits.State = dsInsert)
    then tbColdWarVeteranLimits.FieldByName('Code').AsString := ANSIUpperCase(tbColdWarVeteranLimits.FieldByName('Code').AsString);

end;

{===================================================================}
Procedure TfmColdWarVeteranLimits.btn_NewCodeClick(Sender: TObject);

begin
  try
    tbColdWarVeteranLimits.Append;
  except
  end;

end;

{===================================================================}
Procedure TfmColdWarVeteranLimits.btn_DeleteCodeClick(Sender: TObject);

begin
  try
    tbColdWarVeteranLimits.Delete;
  except
  end;

end;

{===================================================================}
Procedure TfmColdWarVeteranLimits.btn_SaveCodeClick(Sender: TObject);

begin
  try
    tbColdWarVeteranLimits.Post;
  except
  end;

end;

{===================================================================}
Procedure TfmColdWarVeteranLimits.FormClose(    Sender: TObject;
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
