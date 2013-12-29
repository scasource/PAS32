unit DlgNameAddressUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Mask, DBCtrls, Db, DBTables, Wwtable, Buttons, ToolWin,
  ComCtrls, ExtCtrls;

type
  TNameAddressDialogForm = class(TForm)
    NameAddressGroupBox: TGroupBox;
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
    NameAddressTable: TwwTable;
    NameAddressDataSource: TDataSource;
    ButtonsStateTimer: TTimer;
    lbl_PhoneNumber: TLabel;
    edt_PhoneNumber: TDBEdit;
    procedure SaveButtonClick(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject);
    procedure ButtonsStateTimerTimer(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure EditZipPlus4Exit(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure edt_PhoneNumberExit(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    UnitName : String;
    ShowPhoneNumber : Boolean;
    Procedure InitializeForm(_SwisSBLKey : String;
                             _TableName : String;
                             _IndexName : String;
                             _RecordNumber : Integer;
                             _RecordNumberFieldName : String;
                             _EditMode : String;
                             _Title : String;
                             _ShowPhoneNumber : Boolean);
  end;

var
  NameAddressDialogForm : TNameAddressDialogForm;

implementation

{$R *.DFM}

uses DataAccessUnit, Utilitys, GlblCnst, WinUtils, GlblVars;

{=========================================================================}
Procedure TNameAddressDialogForm.ButtonsStateTimerTimer(Sender: TObject);

var
  Enabled : Boolean;

begin
  Enabled := NameAddressTable.Modified;

  SaveButton.Enabled := Enabled;
  CancelButton.Enabled := Enabled;

end;  {ButtonsStateTimerTimer}

{=========================================================================}
Procedure TNameAddressDialogForm.InitializeForm(_SwisSBLKey : String;
                                                _TableName : String;
                                                _IndexName : String;
                                                _RecordNumber : Integer;
                                                _RecordNumberFieldName : String;
                                                _EditMode : String;
                                                _Title : String;
                                                _ShowPhoneNumber : Boolean);

begin
  UnitName := 'DlgNameAddressUnit';

  with NameAddressTable do
    try
      If _Compare(_EditMode, emBrowse, coEqual)
        then ReadOnly := True;

      TableName := _TableName;
      IndexName := _IndexName;
      Open;
    except
    end;

  If _Compare(_EditMode, [emBrowse, emEdit], coEqual)
    then
      begin
        _Locate(NameAddressTable, [_SwisSBLKey, _RecordNumber], '', []);

        If _Compare(_EditMode, emEdit, coEqual)
          then NameAddressTable.Edit;

      end
    else _InsertRecord(NameAddressTable, ['SwisSBLKey', _RecordNumberFieldName],
                       [_SwisSBLKey, _RecordNumber], [irSuppressPost]);

  Caption := _Title;
  NameAddressGroupBox.Caption := ' ' + _Title + ' #' + IntToStr(_RecordNumber) + ': ';
  ShowPhoneNumber := _ShowPhoneNumber;

  If ShowPhoneNumber
    then
      begin
        lbl_PhoneNumber.Visible := True;
        edt_PhoneNumber.Visible := True;
        edt_PhoneNumber.DataField := 'PhoneNumber';

      end;  {If ShowPhoneNumber}

  ButtonsStateTimer.Enabled := True;

end;  {InitializeForm}

{==========================================================}
Procedure TNameAddressDialogForm.FormKeyPress(    Sender: TObject;
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
Procedure TNameAddressDialogForm.SaveButtonClick(Sender: TObject);

begin
  try
    NameAddressTable.Post;
    ModalResult := mrOK;
  except
    SystemSupport(1, NameAddressTable, 'Error posting record.', UnitName, GlblErrorDlgBox);
  end;

end;  {SaveButtonClick}

{==========================================================}
Procedure TNameAddressDialogForm.CancelButtonClick(Sender: TObject);

begin
  NameAddressTable.Cancel;
  ModalResult := mrCancel;

end;  {CancelButtonClick}

{=======================================================================}
Procedure TNameAddressDialogForm.EditZipPlus4Exit(Sender: TObject);

begin
  If not ShowPhoneNumber
    then Close;

end;  {EditZipPlus4Exit}

{=======================================================================}
Procedure TNameAddressDialogForm.edt_PhoneNumberExit(Sender: TObject);

begin
  Close;
end;

{=======================================================================}
Procedure TNameAddressDialogForm.FormCloseQuery(    Sender: TObject;
                                                var CanClose: Boolean);

var
  Selection : Integer;

begin
  CanClose := True;
  If NameAddressTable.Modified
    then
      begin
        Selection := MessageDlg('Do you want to save the changes?', mtConfirmation, [mbYes, mbNo, mbCancel], 0);

        case Selection of
          idYes : SaveButtonClick(Sender);
          idNo : CancelButtonClick(Sender);
          idCancel : CanClose := False;
        end;

      end;  {If NameAddressTable.Modified}

end;  {FormCloseQuery}


end.
