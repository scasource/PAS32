unit P3rdPartyNotificationSubUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Mask, DBCtrls, Db, DBTables, Wwtable, Buttons, ToolWin,
  ComCtrls, ExtCtrls;

type
  TThirdPartyNotificationSubForm = class(TForm)
    ThirdPartyNotificationGroupBox: TGroupBox;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    SwisLabel: TLabel;
    Label17: TLabel;
    Label3: TLabel;
    Label28: TLabel;
    EditName1: TDBEdit;
    EditName2: TDBEdit;
    EditAddress: TDBEdit;
    EditAddress2: TDBEdit;
    EditStreet: TDBEdit;
    EditCity: TDBEdit;
    EditState: TDBEdit;
    EditZip: TDBEdit;
    EditZipPlus4: TDBEdit;
    MainToolBar: TToolBar;
    SaveButton: TSpeedButton;
    CancelButton: TSpeedButton;
    ThirdPartyNotificationTable: TwwTable;
    ThirdPartyNotificationDataSource: TDataSource;
    ButtonsStateTimer: TTimer;
    procedure SaveButtonClick(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject);
    procedure ButtonsStateTimerTimer(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure EditZipPlus4Exit(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
    UnitName : String;
    Procedure InitializeForm(_SwisSBLKey : String;
                             _NotificationNumber : Integer;
                             _EditMode : String);
  end;

var
  ThirdPartyNotificationSubForm: TThirdPartyNotificationSubForm;

implementation

{$R *.DFM}

uses DataAccessUnit, Utilitys, GlblCnst, WinUtils, GlblVars;

{=========================================================================}
Procedure TThirdPartyNotificationSubForm.ButtonsStateTimerTimer(Sender: TObject);

var
  Enabled : Boolean;

begin
  Enabled := ThirdPartyNotificationTable.Modified;

  SaveButton.Enabled := Enabled;
  CancelButton.Enabled := Enabled;

end;  {ButtonsStateTimerTimer}

{=========================================================================}
Procedure TThirdPartyNotificationSubForm.InitializeForm(_SwisSBLKey : String;
                                                        _NotificationNumber : Integer;
                                                        _EditMode : String);

begin
  UnitName := 'P3rdPartyNotificationSubUnit';
  If _Compare(_EditMode, emBrowse, coEqual)
    then ThirdPartyNotificationTable.ReadOnly := True;

  ThirdPartyNotificationTable.Open;

  If _Compare(_EditMode, [emBrowse, emEdit], coEqual)
    then
      begin
        _Locate(ThirdPartyNotificationTable, [_SwisSBLKey, _NotificationNumber], '', []);

        If _Compare(_EditMode, emEdit, coEqual)
          then ThirdPartyNotificationTable.Edit;

      end
    else _InsertRecord(ThirdPartyNotificationTable, ['SwisSBLKey', 'NoticeNumber'],
                       [_SwisSBLKey, _NotificationNumber], [irSuppressPost]);

  ThirdPartyNotificationGroupBox.Caption := ' Third pary notification #' + IntToStr(_NotificationNumber) + ': ';

  ButtonsStateTimer.Enabled := True;

end;  {InitializeForm}

{==========================================================}
Procedure TThirdPartyNotificationSubForm.FormKeyPress(    Sender: TObject;
                                                      var Key: Char);

begin
  If (Key = #13)
    then
      begin
        Perform(WM_NEXTDLGCTL, 0, 0);
        Key := #0;
      end;

end;  {FormKeyPress}

{==========================================================}
Procedure TThirdPartyNotificationSubForm.SaveButtonClick(Sender: TObject);

begin
  try
    ThirdPartyNotificationTable.Post;
    ModalResult := mrOK;
  except
    SystemSupport(1, ThirdPartyNotificationTable, 'Error posting record.', UnitName, GlblErrorDlgBox);
  end;

end;  {SaveButtonClick}

{==========================================================}
Procedure TThirdPartyNotificationSubForm.CancelButtonClick(Sender: TObject);

begin
  ThirdPartyNotificationTable.Cancel;
  ModalResult := mrCancel;

end;  {CancelButtonClick}

{=======================================================================}
Procedure TThirdPartyNotificationSubForm.EditZipPlus4Exit(Sender: TObject);

begin
  Close;
end;

{=======================================================================}
Procedure TThirdPartyNotificationSubForm.FormCloseQuery(    Sender: TObject;
                                                        var CanClose: Boolean);

var
  Selection : Integer;

begin
  CanClose := True;
  If ThirdPartyNotificationTable.Modified
    then
      begin
        Selection := MessageDlg('Do you want to save the changes?', mtConfirmation, [mbYes, mbNo, mbCancel], 0);

        case Selection of
          idYes : SaveButtonClick(Sender);
          idNo : CancelButtonClick(Sender);
          idCancel : CanClose := False;
        end;

      end;  {If ThirdPartyNotificationTable.Modified}

end;  {FormCloseQuery}

end.
