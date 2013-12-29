unit SeniorIncomeLimitsMaintenance;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, DBCtrls, DBTables, DB, Buttons, Grids,
  Wwdbigrd, Wwdbgrid, ExtCtrls, Wwtable, Wwdatsrc, Menus;

type
  TSeniorIncomeLimitsMaintenance = class(TForm)
    SeniorIncomeLevelsDataSource: TwwDataSource;
    SeniorIncomeLevelsTable: TwwTable;
    Panel1: TPanel;
    Panel2: TPanel;
    ScrollBox1: TScrollBox;
    SeniorIncomeLimitsGrid: TwwDBGrid;
    CloseButton: TBitBtn;
    DBNavigator: TDBNavigator;
    TitleLabel: TLabel;
    SeniorIncomeLimtsLookupTable: TTable;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure SeniorIncomeLevelsTableNewRecord(DataSet: TDataSet);
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
Procedure TSeniorIncomeLimitsMaintenance.InitializeForm;

begin
  UnitName := 'SeniorIncomeLimitsMaintenance';

  If (FormAccessRights = raReadOnly)
    then SeniorIncomeLevelsTable.ReadOnly := True;  {mmm}

  OpenTablesForForm(Self, GlblProcessingType);

end;  {InitializeForm}

{===================================================================}
Procedure TSeniorIncomeLimitsMaintenance.FormKeyPress(    Sender: TObject;
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
Procedure TSeniorIncomeLimitsMaintenance.SeniorIncomeLevelsTableNewRecord(DataSet: TDataSet);

begin
    {Set the next level number.}

  with SeniorIncomeLimtsLookupTable do
    If (RecordCount = 0)
      then SeniorIncomeLevelsTable.FieldByName('Level').AsInteger := 1
      else
        begin
          Last;
          SeniorIncomeLevelsTable.FieldByName('Level').AsInteger := FieldByName('Level').AsInteger + 1;
        end;

    {Put them in the lower income limit box.}

  SeniorIncomeLimitsGrid.SetActiveField('LowLimit');

end;  {SeniorIncomeLevelsTableNewRecord}

{===================================================================}
Procedure TSeniorIncomeLimitsMaintenance.FormClose(    Sender: TObject;
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
