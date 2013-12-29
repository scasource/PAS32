unit PPermits_Subform;

{$H+}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, DBTables, Wwtable, wwdblook, Buttons, ToolWin, ComCtrls,
  Mask, ExtCtrls, StdCtrls;

type
  TPermitsEntryDialogForm = class(TForm)
    MainToolBar: TToolBar;
    SaveButton: TSpeedButton;
    CancelButton: TSpeedButton;
    NoteInformationGroupBox: TGroupBox;
    WorkDescription: TMemo;
    Label4: TLabel;
    Label6: TLabel;
    SaveAndExitButton: TSpeedButton;
    PermitNumber: TEdit;
    Entered: TCheckBox;
    Inspected: TCheckBox;
    MainQuery: TQuery;
    ButtonsStateTimer: TTimer;
    PermitDate: TMaskEdit;
    Label1: TLabel;
    Cost: TEdit;
    COIssued: TCheckBox;
    procedure EditChange(Sender: TObject);
    procedure ButtonsStateTimerTimer(Sender: TObject);
    procedure SaveButtonClick(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure SaveAndExitButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }

    DataChanged : Boolean;
    UnitName, SwisSBLKey, EditMode, _TableName : String;
    Permit_ID : Integer;

    Procedure Load;
    Function MeetsRequirements : Boolean;
    Function Save : Boolean;
    Procedure InitializeForm(_SwisSBLKey : String;
                             _Permit_ID : Integer;
                             _EditMode : String);
  end;

var
  PermitsEntryDialogForm: TPermitsEntryDialogForm;

implementation

{$R *.DFM}

uses PASUtils, DataAccessUnit, GlblCnst, Utilitys, GlblVars, WinUtils;

{=========================================================================}
Procedure TPermitsEntryDialogForm.Load;

begin
  with MainQuery do
    try
      SQL.Clear;
      SQL.Add('Select * from ' + _TableName);
      SQL.Add('where (Permit_ID = ' + IntToStr(Permit_ID) + ')');
      Open;
    except
    end;

  DatasetLoadToForm(Self, MainQuery);

end;  {Load}

{=========================================================================}
Function TPermitsEntryDialogForm.MeetsRequirements : Boolean;

begin
  Result := True;
end;  {MeetsRequirements}

{=========================================================================}
Function TPermitsEntryDialogForm.Save : Boolean;

begin
  Result := False;

  If (DataChanged and
      MeetsRequirements)
    then Result := SQLUpdateFromForm(Self, MainQuery, _TableName,
                                     '(Permit_ID = ' + IntToStr(Permit_ID) + ')');
  DataChanged := False;

end;  {Save}

{=========================================================================}
Procedure TPermitsEntryDialogForm.EditChange(Sender: TObject);

begin
  DataChanged := GetDataChangedStateForComponent(Sender);
end;  {EditChange}

{=========================================================================}
Procedure TPermitsEntryDialogForm.ButtonsStateTimerTimer(Sender: TObject);

var
  Enabled : Boolean;

begin
  Enabled := DataChanged;

  SaveButton.Enabled := Enabled;
  CancelButton.Enabled := Enabled;
  SaveAndExitButton.Enabled := Enabled;

end;  {ButtonsStateTimerTimer}

{=========================================================================}
Procedure TPermitsEntryDialogForm.InitializeForm(_SwisSBLKey : String;
                                                 _Permit_ID : Integer;
                                                 _EditMode : String);

begin
  UnitName := 'PPermits_Subform';
  Permit_ID := _Permit_ID;
  SwisSBLKey := _SwisSBLKey;
  _TableName := 'PBuildingPermits';

  If _Compare(_EditMode, emInsert, coEqual)
    then
      begin
        with MainQuery do
         try
           SQL.Add('Insert into ' + _TableName + ' (SwisSBLKey)');
           SQL.Add('Values (' + FormatSQLString(SwisSBLKey) + ')');
           ExecSQL;
         except
         end;

        with MainQuery do
          try
            SQL.Clear;
            SQL.Add('Select MAX(Permit_ID) as PermitCount from ' + _TableName);
            Open;
          except
          end;

        Permit_ID := MainQuery.FieldByName('PermitCount').AsInteger;

      end;  {If _Compare(_EditMode, emInsert, coEqual)}

  Load;

  Caption := 'Permit #' + MainQuery.FieldByName('PermitNumber').AsString +
             ' for parcel ' + ConvertSwisSBLToDashDot(SwisSBLKey);

  If _Compare(_EditMode, emBrowse, coEqual)
    then SetComponentsToReadOnly(Self);

  DataChanged := False;

  ButtonsStateTimer.Enabled := True;

end;  {InitializeForm}

{=========================================================================}
Procedure TPermitsEntryDialogForm.FormKeyPress(    Sender: TObject;
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
Procedure TPermitsEntryDialogForm.SaveAndExitButtonClick(Sender: TObject);

begin
  If Save
    then Close;

end;  {SaveAndExitButtonClick}

{=========================================================================}
Procedure TPermitsEntryDialogForm.SaveButtonClick(Sender: TObject);

begin
  Save;
end;

{=========================================================================}
Procedure TPermitsEntryDialogForm.CancelButtonClick(Sender: TObject);

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
Procedure TPermitsEntryDialogForm.FormCloseQuery(    Sender: TObject;
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
