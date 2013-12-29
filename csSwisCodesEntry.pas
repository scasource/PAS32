unit csSwisCodesEntry;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Mask, DBCtrls, Db, DBTables, Wwtable, Buttons, ToolWin,
  ComCtrls, ExtCtrls, wwdblook, Wwdatsrc;

type
  TfmSwisCodesEntry = class(TForm)
    gbxSwisCode: TGroupBox;
    MainToolBar: TToolBar;
    SaveButton: TSpeedButton;
    CancelButton: TSpeedButton;
    tmrButtonsState: TTimer;
    dsMain: TwwDataSource;
    tbMain: TwwTable;
    tbVeteranLimits: TwwTable;
    tbVeteranLimitsCode: TStringField;
    tbVeteranLimitsEligibleFundsLimit: TIntegerField;
    tbVeteranLimitsBasicVetLimit: TIntegerField;
    tbVeteranLimitsCombatVetLimit: TIntegerField;
    tbVeteranLimitsDisabledVetLimit: TIntegerField;
    tbVeteranLimitsReserved: TStringField;
    MainCodeLabel: TLabel;
    MunNameLabel: TLabel;
    EqualLabel: TLabel;
    ResAssmntLabel: TLabel;
    Label1: TLabel;
    Label3: TLabel;
    Label7: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label4: TLabel;
    MainCodeEdit: TDBEdit;
    MunicipalName: TDBEdit;
    EditEqualizationRate: TDBEdit;
    EditResidentialAssessmentRatio: TDBEdit;
    EditShortSwisCode: TDBEdit;
    ClassifiedCheckBox: TDBCheckBox;
    MunicipalityLookupCombo: TwwDBLookupCombo;
    EditSplitVillageCode: TDBEdit;
    AssessingVillageCheckBox: TDBCheckBox;
    UniformPercentOfValueEdit: TDBEdit;
    ZipCodeEdit: TDBEdit;
    gbxMunicipalVeteranLimits: TGroupBox;
    DisabledVetLabel: TLabel;
    VetMaxLabel: TLabel;
    CombatVetlbl: TLabel;
    Label21: TLabel;
    edMunicipalDisabledVetLimit: TDBEdit;
    edMunicipalBasicVetLimit: TDBEdit;
    edMunicipalCombatVetLimit: TDBEdit;
    cbxVeteranLimitSet: TwwDBLookupCombo;
    gbxMunicipalColdWarVeteranLimits: TGroupBox;
    Label5: TLabel;
    Label6: TLabel;
    Label2: TLabel;
    Label13: TLabel;
    edDisabledColdWarVeteranLimit: TDBEdit;
    edBasicColdWarVeteranLimit: TDBEdit;
    edColdWarBasicCountyPercent: TDBEdit;
    cbxMunicipalColdWarVeteranLimitCode: TwwDBLookupCombo;
    tbColdWarVeteranLimits: TwwTable;
    dsColdWarVeteranLimits: TwwDataSource;
    procedure SaveButtonClick(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject);
    procedure tmrButtonsStateTimer(Sender: TObject);
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
  fmSwisCodesEntry: TfmSwisCodesEntry;

implementation

{$R *.DFM}

uses DataAccessUnit, Utilitys, GlblCnst, WinUtils, GlblVars;

{=========================================================================}
Procedure TfmSwisCodesEntry.tmrButtonsStateTimer(Sender: TObject);

var
  Enabled : Boolean;

begin
  Enabled := ThirdPartyNotificationTable.Modified;

  SaveButton.Enabled := Enabled;
  CancelButton.Enabled := Enabled;

end;  {ButtonsStateTimerTimer}

{=========================================================================}
Procedure TfmSwisCodesEntry.InitializeForm(_SwisSBLKey : String;
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
Procedure TfmSwisCodesEntry.FormKeyPress(    Sender: TObject;
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
Procedure TfmSwisCodesEntry.SaveButtonClick(Sender: TObject);

begin
  try
    ThirdPartyNotificationTable.Post;
    ModalResult := mrOK;
  except
    SystemSupport(1, ThirdPartyNotificationTable, 'Error posting record.', UnitName, GlblErrorDlgBox);
  end;

end;  {SaveButtonClick}

{==========================================================}
Procedure TfmSwisCodesEntry.CancelButtonClick(Sender: TObject);

begin
  ThirdPartyNotificationTable.Cancel;
  ModalResult := mrCancel;

end;  {CancelButtonClick}

{=======================================================================}
Procedure TfmSwisCodesEntry.EditZipPlus4Exit(Sender: TObject);

begin
  Close;
end;

{=======================================================================}
Procedure TfmSwisCodesEntry.FormCloseQuery(    Sender: TObject;
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
