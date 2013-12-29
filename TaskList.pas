unit TaskList;

{To use this template:
  1. Save the form it under a new name.
  2. Rename the form in the Object Inspector.
  3. Rename the table in the Object Inspector. Then switch
     to the code and do a blanket replace of "Table" with the new name.
  4. Change UnitName to the new unit name.}

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, DBCtrls, DBTables, DB, Buttons, Grids,
  Wwdbigrd, Wwdbgrid, ExtCtrls, Wwtable, Wwdatsrc, Menus, DBGrids, ComCtrls,
  wwdblook;

type
  TTaskListForm = class(TForm)
    DataSource: TwwDataSource;
    TaskListTable: TwwTable;
    Panel1: TPanel;
    Panel2: TPanel;
    ScrollBox1: TScrollBox;
    CloseButton: TBitBtn;
    TitleLabel: TLabel;
    PrintButton: TBitBtn;
    TaskUserListTable: TTable;
    UserTable: TTable;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TaskDBGrid: TwwDBGrid;
    TaskUserListDataSource: TDataSource;
    TaskListTableDescription: TStringField;
    TaskListTableReminderDate: TDateField;
    TaskListTableDone: TBooleanField;
    AvailableUserListBox: TListBox;
    UsersToGetTasksListBox: TListBox;
    AddUsersButton: TBitBtn;
    RemoveUsersButton: TBitBtn;
    Label1: TLabel;
    Label2: TLabel;
    AddTaskReminder: TBitBtn;
    DeleteTaskButton: TBitBtn;
    SaveTaskButton: TBitBtn;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure TaskListTableAfterInsert(DataSet: TDataSet);
    procedure AddUsersButtonClick(Sender: TObject);
    procedure RemoveUsersButtonClick(Sender: TObject);
    procedure UsersToGetTasksListBoxKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure AvailableUserListBoxKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure UsersToGetTasksListBoxStartDrag(Sender: TObject;
      var DragObject: TDragObject);
    procedure AvailableUserListBoxDragDrop(Sender, Source: TObject; X,
      Y: Integer);
    procedure AvailableUserListBoxStartDrag(Sender: TObject;
      var DragObject: TDragObject);
    procedure UsersToGetTasksListBoxDragDrop(Sender, Source: TObject; X,
      Y: Integer);
    procedure AvailableUserListBoxDragOver(Sender, Source: TObject; X,
      Y: Integer; State: TDragState; var Accept: Boolean);
    procedure UsersToGetTasksListBoxDragOver(Sender, Source: TObject; X,
      Y: Integer; State: TDragState; var Accept: Boolean);
    procedure DeleteTaskButtonClick(Sender: TObject);
    procedure SaveTaskButtonClick(Sender: TObject);
    procedure AddTaskReminderClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    UnitName : String;
    AddUserDrag, RemoveUserDrag : Boolean;
    FormAccessRights : Integer;  {Read only or read write, based on security level?}
                                {Values = raReadOnly, raReadWrite}
    Procedure InitializeForm;  {Open the tables and setup.}

  end;

implementation

uses GlblVars, WinUtils, Utilitys, GlblCnst, PASUtils;

{$R *.DFM}

{=======================================================}
Procedure LoadUserListBoxes(AvailableUserListBox : TListBox;
                            AssignedUsersListBox : TListBox;
                            UserTable : TTable;
                            AssignedUserTable : TTable;
                            AssignedUserFieldName : String);

var
  Done, FirstTimeThrough : Boolean;
  UserID : String;

begin
  Done := False;
  FirstTimeThrough := True;

  UserTable.First;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else UserTable.Next;

    If UserTable.EOF
      then Done := True;

    If not Done
      then
        begin
          UserID := UserTable.FieldByName('UserID').Text;

          If FindKeyOld(AssignedUserTable, [AssignedUserFieldName],
                        [UserID])
            then AssignedUsersListBox.Items.Add(UserID)
            else AvailableUserListBox.Items.Add(UserID);

        end;  {If not Done}

  until Done;

end;  {LoadUserListBoxes}

{========================================================}
Procedure TTaskListForm.InitializeForm;

begin
  UnitName := 'TaskList';  {mmm}
  RemoveUserDrag := False;
  AddUserDrag := False;

  If (FormAccessRights = raReadOnly)
    then
      begin
        TaskListTable.ReadOnly := True;  {mmm}
        TaskUserListTable.ReadOnly := True;
        AddUsersButton.Enabled := False;
        RemoveUsersButton.Enabled := False;
        AvailableUserListBox.Enabled := False;
        UsersToGetTasksListBox.Enabled := False;

      end;  {If (FormAccessRights = raReadOnly)}

    {The tables are year independant, but start with 'T', so only open as this year.}

  OpenTablesForForm(Self, ThisYear);

  LoadUserListBoxes(AvailableUserListBox, UsersToGetTasksListBox,
                    UserTable, TaskUserListTable, 'UserName');

end;  {InitializeForm}

{===================================================================}
Procedure TTaskListForm.FormKeyPress(    Sender: TObject;
                                     var Key: Char);

begin
  If (Key = #13)
    then
      If (not ((ActiveControl is TDBGrid) or
               (ActiveControl is TwwDBGrid)))
        then
          begin
           {not a grid so go to next control on form}
            Perform(WM_NEXTDLGCTL, 0, 0);
            Key := #0;
          end;

end;  {FormKeyPress}

{===================================================================}
Procedure TTaskListForm.AddTaskReminderClick(Sender: TObject);

begin
  try
    TaskListTable.Append;
    TaskDBGrid.SetFocus;
    TaskDBGrid.SetActiveField('Description');
  except
  end;

end;  {AddTaskReminderClick}

{===================================================================}
Procedure TTaskListForm.DeleteTaskButtonClick(Sender: TObject);

begin
  TaskListTable.Delete;
end;

{===================================================================}
Procedure TTaskListForm.SaveTaskButtonClick(Sender: TObject);

begin
  If (TaskListTable.State in [dsEdit, dsInsert])
    then
      try
        TaskListTable.Post;
      except
        SystemSupport(001, TaskListTable, 'Error saving task list record.',
                      UnitName, GlblErrorDlgBox);
      end;

end;  {SaveTaskButtonClick}

{===================================================================}
Procedure TTaskListForm.TaskListTableAfterInsert(DataSet: TDataSet);

begin
  TaskDBGrid.SetActiveField('Description');
end;  {TaskListTableAfterInsert}

{===================================================================}
Procedure TTaskListForm.AddUsersButtonClick(Sender: TObject);

var
  I : Integer;

begin
  For I := (AvailableUserListBox.Items.Count - 1) downto 0 do
    If AvailableUserListBox.Selected[I]
      then
        begin
          UsersToGetTasksListBox.Items.Add(AvailableUserListBox.Items[I]);
          AvailableUserListBox.Items.Delete(I);
        end;

end;  {AddUsersButtonClick}

{==============================================================}
Procedure TTaskListForm.AvailableUserListBoxStartDrag(    Sender: TObject;
                                                      var DragObject: TDragObject);
begin
  AddUserDrag := True;
end;

{=============================================================}
Procedure TTaskListForm.UsersToGetTasksListBoxDragDrop(Sender,
                                                       Source: TObject;
                                                       X, Y: Integer);

begin
  If AddUserDrag
    then
      begin
        AddUsersButtonClick(Sender);
        AddUserDrag := False;
      end;

end;  {UsersToGetTasksListBoxDragDrop}
{===================================================================}
Procedure TTaskListForm.AvailableUserListBoxKeyDown(    Sender: TObject;
                                                    var Key: Word;
                                                        Shift: TShiftState);

begin
  If (Key = VK_Insert)
    then
      begin
        Key := 0;
        AddUsersButtonClick(Sender);
      end;

end;  {AvailableUserListBoxKeyDown}

{===================================================================}
Procedure TTaskListForm.UsersToGetTasksListBoxDragOver(    Sender,
                                                           Source: TObject;
                                                           X, Y: Integer;
                                                           State: TDragState;
                                                       var Accept: Boolean);

begin
  Accept := (Source is TListBox);
end;

{===================================================================}
Procedure TTaskListForm.RemoveUsersButtonClick(Sender: TObject);

var
  I : Integer;

begin
  For I := (UsersToGetTasksListBox.Items.Count - 1) downto 0 do
    If UsersToGetTasksListBox.Selected[I]
      then
        begin
          AvailableUserListBox.Items.Add(UsersToGetTasksListBox.Items[I]);
          UsersToGetTasksListBox.Items.Delete(I);
        end;

end;  {RemoveUsersButtonClick}

{==================================================================}
Procedure TTaskListForm.UsersToGetTasksListBoxStartDrag(    Sender: TObject;
                                                        var DragObject: TDragObject);

begin
  RemoveUserDrag := True;
end;  {UsersToGetTasksListBoxStartDrag}

{==================================================================}
Procedure TTaskListForm.AvailableUserListBoxDragDrop(Sender,
                                                     Source: TObject;
                                                     X, Y: Integer);

begin
  If RemoveUserDrag
    then
      begin
        RemoveUserDrag := False;
        RemoveUsersButtonClick(Sender);
      end;

end;  {AvailableUserListBoxDragDrop}

{===================================================================}
Procedure TTaskListForm.UsersToGetTasksListBoxKeyDown(    Sender: TObject;
                                                      var Key: Word;
                                                          Shift: TShiftState);

begin
  If (Key = VK_Delete)
    then
      begin
        Key := 0;
        RemoveUsersButtonClick(Sender);
      end;

end;  {UsersToGetTasksListBoxKeyDown}

{===================================================================}
Procedure TTaskListForm.AvailableUserListBoxDragOver(    Sender,
                                                         Source: TObject;
                                                         X, Y: Integer;
                                                         State: TDragState;
                                                     var Accept: Boolean);

begin
  Accept := (Source is TListBox);
end;

{===================================================================}
Procedure TTaskListForm.FormClose(    Sender: TObject;
                                  var Action: TCloseAction);

var
  I : Integer;

begin
    {Save the users list.}

  DeleteTable(TaskUserListTable);

  with UsersToGetTasksListBox, TaskUserListTable do
    For I := 0 to (Items.Count - 1) do
      try
        Insert;
        FieldByName('UserName').Text := Items[I];
        Post;
      except
        SystemSupport(003, TaskUserListTable, 'Error adding user to User Task List table.',
                      UnitName, GlblErrorDlgBox);
      end;

  CloseTablesForForm(Self);

    {Free up the child window and set the ClosingAForm Boolean to
     true so that we know to delete the tab.}

  Action := caFree;
  GlblClosingAForm := True;
  GlblClosingFormCaption := Caption;

end;  {FormClose}

end.
