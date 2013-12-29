unit Ltrtxmnt;

{To convert this maintenance to a new one, do the following:

  1. Save the file under it's new name.
  2. In the object inspector, change the form and caption name.
     Also, change the form style to MDIChild.
  3. In the object insepctor, change the caption of the title
     label and the incremental search.
  4. In the object inspector, change the DatabaseName and
     TableName of the MainTable to point to the new table.
     Then go into the fields editor and clear all fields.
     Then add all the new ones.
  5. Repeat #4 for the LookupTable.
  6. In the object insepctor, change the Visible property of the
     MainTableTaxYear and MainTableDescription TStringFields
     to False.
  7. In the code window, change the SWISSwisCodeName constant.
     Do not include the word "code" in the constant, and leave
     a space between a two word code name.
     Note that all items that need to be changed in the code
     window are marked with "mmm".
  8. In the code window, change the UnitName to the new name
     of the unit.
  9. In the code window, change the SRAZ constant if this code
     should be shifted right and zeroes added.

 If the field names are different, then delete the fields
 in the fields editor for both tables. Then add the new fields.
 Set the FieldName in the edit boxes to match the new fields.
 Also, do a replace on "SWISSwisCode" with the FieldName of the
 main code and "Description" with the FieldName of the
 description.

 If there are more than 2 fields, then do the process above
 for different field names. Then move the description edit box
 down, and add in the necessary edit boxes, linking them to
 the correct field. Then adjust the tab order. Only if
 there must be validity checks on these extra fields, do you
 need to worry about creating event handlers for them.}


interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, ExtCtrls, Menus, Mask, DBCtrls,
  Wwkeycb, DB, DBTables, Wwtable, Wwdatsrc, Printrng, Btrvdlg, Grids,
  DBGrids, DBLookup, RPBase, RPCanvas, RPrinter, Wwdbigrd, Wwdbgrid,
  TabNotBk, RPFiler, DBIProcs, RPDefine, ComCtrls, wwriched, wwrichedspell;

type
  TLetterTextMaintForm = class(TForm)
    ScrollBox1: TScrollBox;
    Panel1: TPanel;
    TitleLabel: TLabel;
    MainDataSource: TDataSource;
    Panel2: TPanel;
    ExitButton: TBitBtn;
    Navigator: TDBNavigator;
    MainTable: TTable;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    LetterTextDBGrid: TDBGrid;
    Label4: TLabel;
    LetterTextDBMemo: TwwDBRichEditMSWord;
    Label23: TLabel;
    LetterCodeDBEdit: TDBEdit;
    procedure ExitButtonClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure LetterCodeDBEditEnter(Sender: TObject);
    procedure MainTableAfterInsert(DataSet: TDataset);
    procedure FormActivate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure LetterTextDBMemoKeyPress(Sender: TObject; var Key: Char);
    procedure LetterTextDBMemoClick(Sender: TObject);

  private
    UnitName : String; {For error dialog box}
  public
    FormAccessRights : Integer; {Read only or read write, based on security level?}
                                {Values = raReadOnly, raReadWrite}
    Procedure InitializeForm;
  end;

var
  LetterTextMaintForm: TLetterTextMaintForm;

implementation

{$R *.DFM}

uses
  Preview,   {Print preview form}
  Types,     {Constants, types}
  Utilitys,  {General utilities}
  GlblVars,  {Global variables}
  GlblCnst,
  PASUTILS, UTILEXSD,   {PAS specific utilites}
  WinUtils;  {Windows specific utilities}


{======================================================================}
Procedure TLetterTextMaintForm.FormActivate(Sender: TObject);

begin
  SetFormStateMaximized(Self);
end;

{======================================================================}
Procedure TLetterTextMaintForm.InitializeForm;

begin
  UnitName := 'LTRTXMNT.PAS';  {mmm}

    {FXX05131999-8: Only set to read only if they can not alter due to security level,
                    not year access settings.}

  If (FormAccessRights = raReadOnly)
    then MainTable.ReadOnly := True;

    {Open the main table.}

  OpenTablesForForm(Self, GlblProcessingType);

    {If for some reason there is no letter text yet, let's insert it now.
     This should really only happen while we are testing.}

  If ((MainTable.RecordCount = 0) and
      (not MainTable.ReadOnly))
    then MainTable.Insert;

end;  {InitializeForm}

{===================================================================}
Procedure TLetterTextMaintForm.FormKeyPress(Sender: TObject;
                                        var Key: Char);

{Change carriage return into tab.}

begin
 If (Key = #13)
    then
      begin
        If (NOT (Screen.ActiveControl is TDBMemo))
          then
          begin
          Perform(WM_NextDlgCtl, 0, 0);
          Key := #0;
          End;
      end;  {If (Key = #13)}


end;  {FormKeyPress}

{===================================================================}
Procedure TLetterTextMaintForm.FormKeyDown(    Sender: TObject;
                                           var Key: Word;
                                               Shift: TShiftState);

{If they press F2 anywhere on the letter tab, bring up the edit memo.}

begin
  If ((Key = VK_F2) and
      (MainTable.RecordCount > 0))
    then LetterTextDBMemo.Execute;

end;  {FormKeyDown}

{===================================================================}
Procedure TLetterTextMaintForm.LetterTextDBMemoKeyPress(    Sender: TObject;
                                                        var Key: Char);

{If they press any key in the memo box, bring up the edit memo.}

begin
  If (MainTable.RecordCount > 0)
    then
      begin
        Key := #0;
        LetterTextDBMemo.Execute;
      end;

end;  {LetterTextDBMemoKeyPress}

{===================================================================}
Procedure TLetterTextMaintForm.LetterTextDBMemoClick(Sender: TObject);

{If they click or double click in the memo, bring up the edit memo.}

begin
  If (MainTable.RecordCount > 0)
    then LetterTextDBMemo.Execute;

end;  {LetterTextDBMemoClick}

{===================================================================}
Procedure TLetterTextMaintForm.MainTableAfterInsert(DataSet: TDataset);

{FXX05191998-9: Set focus to letter text code.}

begin
  LetterCodeDBEdit.SetFocus;
end;

{===================================================================}
Procedure TLetterTextMaintForm.LetterCodeDBEditEnter(Sender: TObject);

begin
  If not MainTable.ReadOnly
    then MainTable.Insert;

end;  {LetterCodeDBEditEnter}

{===================================================================}
Procedure TLetterTextMaintForm.ExitButtonClick(Sender: TObject);

begin
  Close;
end;

{===================================================================}
Procedure TLetterTextMaintForm.FormCloseQuery(    Sender: TObject;
                                            var CanClose: Boolean);

{If there are any changes, let's ask them if they want to save
 them (or cancel).}

var
  ReturnCode : Integer;

begin
    {First see if anything needs to be saved. In order to
     determine if there are any changes, we need to sychronize
     the fields with what is in the DB edit boxes. To do this,
     we call the UpdateRecord. Then, if there are any changes,
     the Modified flag will be set to True.}

  If (MainTable.State in [dsInsert, dsEdit])
    then MainTable.UpdateRecord;

  If ((not MainTable.ReadOnly) and
      (MainTable.State in [dsEdit, dsInsert]) and
      MainTable.Modified)
    then
      begin
        ReturnCode := MessageDlg('Do you wish to save your letter changes?', mtConfirmation,
                                 [mbYes, mbNo, mbCancel], 0);

        case ReturnCode of
          idYes : MainTable.Post;

          idNo : MainTable.Cancel;

          idCancel : CanClose := False;

        end;  {case ReturnCode of}

      end;  {If ((not MainTable.ReadOnly) and ...}

end;  {FormCloseQuery}

{===================================================================}
Procedure TLetterTextMaintForm.FormClose(    Sender: TObject;
                                       var Action: TCloseAction);

{Note that if we get here, we are definately closing the form
 since the CloseQuery event is called first. In CloseQuery, if
 there are any modifications, they have a chance to cancel
 then.}

begin
    {Make sure that we close the tables.}

  CloseTablesForForm(Self);

    {Free up the child window and set the ClosingAForm Boolean to
     true so that we know to delete the tab.}

  Action := caFree;
  GlblClosingAForm := True;
  GlblClosingFormCaption := Caption;

end;  {FormClose}

end.