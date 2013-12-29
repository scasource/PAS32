unit TaskListReminder;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  StdCtrls, ExtCtrls, Forms, Dialogs, DB, Grids, DBGrids,
  DBTables, Mask, DBCtrls, Wwtable, Wwdatsrc, Wwdbcomb, Wwdbigrd, Wwdbgrid,
  Btrvdlg, Types, wwdblook, Buttons, RPFiler, RPBase, RPCanvas, RPrinter,
  Printrng, RPMemo, RPDBUtil, Gauges, RPDefine(*, Progress*);

type
  TTaskListReminderDialog = class(TForm)
    OKBtn: TBitBtn;
    Label1: TLabel;
    Panel1: TPanel;
    NotesGrid: TwwDBGrid;
    TaskListDataSource: TwwDataSource;
    TaskListTable: TwwTable;
    DBNavigator1: TDBNavigator;
    Label2: TLabel;
    procedure OKBtnClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
    UnitName : String;
    Procedure SetFilter;
  end;

var
  TaskListReminderDialog: TTaskListReminderDialog;

implementation

uses Utilitys, PASUTILS, UTILEXSD,  GlblCnst, Glblvars, WinUtils, PASTypes;

{$R *.DFM}

{================================================================}
Procedure TTaskListReminderDialog.FormShow(Sender: TObject);

var
  I : Integer;

begin
  UnitName := 'TaskListReminder';

  try
    TaskListTable.Open;
  except
    SystemSupport(001, TaskListTable, 'Error opening task list table.',
                  UnitName, GlblErrorDlgBox);
  end;

  SetFilter;

    {CHG05112001-1: Allow them to click off the done.}

  with TaskListTable do
    For I := 0 to (FieldCount - 1) do
      Fields[I].ReadOnly := True;

  TaskListTable.FieldByName('Done').ReadOnly := False;

end;  {FormShow}

{=====================================================================}
Procedure TTaskListReminderDialog.SetFilter;

const
  DblQuote = '"';

begin
  with TaskListTable do
    begin
      wwFilter.Clear;
      wwFilter.Add('(Done = False) and');
      wwFilter.Add('(ReminderDate <= ' + DblQuote + DateToStr(Date) + DblQuote + ')');
      FilterActivate;

    end;  {with NotesTable do}

end;  {SetFilter}

{================================================================}
Procedure TTaskListReminderDialog.OKBtnClick(Sender: TObject);

begin
  Close;
end;

{=========================================================================}
Procedure TTaskListReminderDialog.FormClose(    Sender: TObject;
                                         var Action: TCloseAction);

begin
  If (TaskListTable.State = dsEdit)
    then TaskListTable.Post;

  TaskListTable.Close;

end;  {FormClose}


end.