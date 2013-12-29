unit PNotes_New_Subform;

{$H+}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, DBTables, Wwtable, wwdblook, Buttons, ToolWin, ComCtrls,
  Mask, ExtCtrls, StdCtrls;

type
  TNotesEntryDialogForm = class(TForm)
    UserTable: TwwTable;
    MainToolBar: TToolBar;
    SaveButton: TSpeedButton;
    CancelButton: TSpeedButton;
    EntryInformationGroupBox: TGroupBox;
    DateEntered: TEdit;
    TimeEntered: TEdit;
    EnteredByUserID: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    NoteInformationGroupBox: TGroupBox;
    TransactionCode: TwwDBLookupCombo;
    NoteTypeCode: TwwDBLookupCombo;
    UserResponsible: TwwDBLookupCombo;
    Note: TMemo;
    DueDate1: TMaskEdit;
    NoteOpen: TCheckBox;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    NotesTransactionCodeTable: TTable;
    NotesTypeCodeTable: TTable;
    MainQuery: TQuery;
    ButtonsStateTimer: TTimer;
    SaveAndExitButton: TSpeedButton;
    DueDate2: TDateTimePicker;
    DueDate: TEdit;
    procedure EditChange(Sender: TObject);
    procedure ButtonsStateTimerTimer(Sender: TObject);
    procedure SaveButtonClick(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure SaveAndExitButtonClick(Sender: TObject);
    procedure DueDateExit(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }

    DataChanged : Boolean;
    UnitName, SwisSBLKey, EditMode : String;
    NoteNumber : Integer;

    Procedure Load;
    Function MeetsRequirements : Boolean;
    Function Save : Boolean;
    Procedure SetReadOnlyFields;
    Procedure InitializeForm(_SwisSBLKey : String;
                             _NoteNumber : Integer;
                             _EditMode : String);
  end;

var
  NotesEntryDialogForm: TNotesEntryDialogForm;

implementation

{$R *.DFM}

uses PASUtils, DataAccessUnit, GlblCnst, Utilitys, GlblVars, WinUtils;

const
  TicklerNoteType = 'T';

{=========================================================================}
Procedure TNotesEntryDialogForm.Load;

begin
  with MainQuery do
    try
      SQL.Clear;
      SQL.Add('Select * from PNotesRec');
      SQL.Add('where (SwisSBLKey = ' + FormatSQLString(SwisSBLKey) + ') and');
      SQL.Add('(NoteNumber = ' + IntToStr(NoteNumber) + ')');
      Open;
    except
    end;

  DatasetLoadToForm(Self, MainQuery);

end;  {Load}

{=========================================================================}
Function TNotesEntryDialogForm.MeetsRequirements : Boolean;

begin
  Result := True;

  If (_Compare(NoteTypeCode.Text, TicklerNoteType, coEqual) and
      _Compare(UserResponsible.Text, coBlank))
    then
      begin
        Result := False;
        MessageDlg('Please enter the user responsible for this tickler note.', mtError, [mbOK], 0);
        UserResponsible.SetFocus;
      end;

end;  {MeetsRequirements}

{=========================================================================}
Function TNotesEntryDialogForm.Save : Boolean;

begin
  Result := False;

  If (DataChanged and
      MeetsRequirements)
    then Result := SQLUpdateFromForm(Self, MainQuery, 'PNotesRec',
                                     '(SwisSBLKey = ' + FormatSQLString(SwisSBLKey) + ') and ' +
                                     '(NoteNumber = ' + IntToStr(NoteNumber) + ')');
  DataChanged := False;

end;  {Save}

{=========================================================================}
Procedure TNotesEntryDialogForm.EditChange(Sender: TObject);

begin
  DataChanged := GetDataChangedStateForComponent(Sender);

  If _Compare(TWinControl(Sender).Name, 'NoteTypeCode', coEqual)
    then
      begin
        SetReadOnlyFields;

        NoteOpen.Checked := _Compare(NoteTypeCode.Text, TicklerNoteType, coEqual);

      end;  {If ((Sender is TCustomEdit) and...}

end;  {EditChange}

{=========================================================================}
Procedure TNotesEntryDialogForm.ButtonsStateTimerTimer(Sender: TObject);

var
  Enabled : Boolean;

begin
  Enabled := DataChanged;

  SaveButton.Enabled := Enabled;
  CancelButton.Enabled := Enabled;
  SaveAndExitButton.Enabled := Enabled;

end;  {ButtonsStateTimerTimer}

{=========================================================================}
Procedure TNotesEntryDialogForm.SetReadOnlyFields;

var
  Enabled : Boolean;

begin
  Enabled := _Compare(NoteTypeCode.Text, TicklerNoteType, coEqual);
  UserResponsible.Enabled := Enabled;

end;  {SetReadOnlyFields}

{=========================================================================}
Procedure TNotesEntryDialogForm.InitializeForm(_SwisSBLKey : String;
                                               _NoteNumber : Integer;
                                               _EditMode : String);

var
  ReadOnlyStatus : Boolean;

begin
  UnitName := 'PNotes_New_Subform';
  NoteNumber := _NoteNumber;
  SwisSBLKey := _SwisSBLKey;

  Caption := 'Note #' + IntToStr(NoteNumber) +
             ' for parcel ' + ConvertSwisSBLToDashDot(SwisSBLKey);

  _OpenTablesForForm(Self, NoProcessingType, []);

  If _Compare(_EditMode, emInsert, coEqual)
    then
      with MainQuery do
        try
          SQL.Add('Insert into PNotesRec (SwisSBLKey, DateEntered, TimeEntered, NoteNumber, EnteredByUserID)');
          SQL.Add('Values (' + '''' + SwisSBLKey + '''' + ',' +
                               '''' + DateToStr(Date) + '''' + ',' +
                               '''' + TimeToStr(Now) + '''' + ',' +
                               '''' + IntToStr(NoteNumber) + '''' + ',' +
                               '''' + GlblUserName + '''' + ')');
          ExecSQL;
        except
        end;

  Load;

    {Don't automatically stop at the open on a new note.}

  If _Compare(_EditMode, emInsert, coEqual)
    then NoteOpen.TabStop := False;

  ReadOnlyStatus := _Compare(_EditMode, emBrowse, coEqual);

    {If they are not allowed to modify each others notes and they are not
     the supervisor, person responsible, or the person who entered it,
     they can't touch it.}

  with MainQuery do
    If (_Compare(_EditMode, emEdit, coEqual) and
        (not GlblModifyOthersNotes) and
        _Compare(GlblUserName, 'SUPERVISOR', coNotEqual) and
        _Compare(FieldByName('EnteredByUserID').Text, GlblUserName, coNotEqual) and
        _Compare(FieldByName('UserResponsible').Text, GlblUserName, coNotEqual))
      then ReadOnlyStatus := True;

  If ReadOnlyStatus
    then SetComponentsToReadOnly(Self)
    else SetReadOnlyFields;

    {CHG04302003-1(2.07): Allow users to turn Open on and off even
                          if they are not allowed to modify each other's notes.}

  If (_Compare(_EditMode, emEdit, coEqual) and
       GlblAnyUserCanChangeOpenNoteStatus)
    then NoteOpen.Enabled := True;

  DataChanged := False;

  ButtonsStateTimer.Enabled := True;

end;  {InitializeForm}

{=========================================================================}
Procedure TNotesEntryDialogForm.FormKeyPress(    Sender: TObject;
                                             var Key: Char);

begin
  If ((Key = #13) and
      (not (ActiveControl is TMemo)))
    then
      begin
        Perform(WM_NEXTDLGCTL, 0, 0);
        Key := #0;
      end;

end;  {FormKeyPress}

{=========================================================================}
Procedure TNotesEntryDialogForm.DueDateExit(Sender: TObject);

begin
  try
    If (_Compare(DueDate.Text, BlankMaskDate, coNotEqual) and
        _Compare(DueDate.Text, BlankMaskDateUnderscore, coNotEqual) and
        _Compare(DueDate.Text, coNotBlank))
      then StrToDate(DueDate.Text);
  except
    MessageDlg(DueDate.Text + ' is not a valid date.', mtError, [mbOK], 0);
    DueDate.SetFocus;
  end;

end;  {DueDateExit}

{=========================================================================}
Procedure TNotesEntryDialogForm.SaveAndExitButtonClick(Sender: TObject);

begin
  If Save
    then Close;
end;

{=========================================================================}
Procedure TNotesEntryDialogForm.SaveButtonClick(Sender: TObject);

begin
  Save;
end;

{=========================================================================}
Procedure TNotesEntryDialogForm.CancelButtonClick(Sender: TObject);

begin
  If DataChanged
    then
      begin
        If (MessageDlg('Do you want to cancel your changes?', mtConfirmation, [mbYes, mbNo], 0) = idYes)
          then
            begin
              DataChanged := False;
              ModalResult := mrCancel;
            end;
      end
    else ModalResult := mrCancel;

end;  {CancelButtonClick}

{=========================================================================}
Procedure TNotesEntryDialogForm.FormCloseQuery(    Sender: TObject;
                                               var CanClose: Boolean);

var
  ReturnCode : Integer;

begin
  If DataChanged
    then
      begin
        ReturnCode := MessageDlg('Do you want to save your changes?', mtConfirmation, [mbYes, mbNo, mbCancel], 0);

        case ReturnCode of
          idYes : begin
                    Save;
                    ModalResult := mrOK;
                  end;

          idNo : ModalResult := mrCancel;

          idCancel : CanClose := False;

        end;  {case ReturnCode of}

      end;  {If DataChanged}

end;  {FormCloseQuery}

end.
