unit ParcelToolbar;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Buttons, OleServer, ParcelVanViewCOM_TLB, ShellAPI;

type
  TParcelToolbarForm = class(TForm)
    CompsSpeedButton: TSpeedButton;
    PrintScreenSpeedButton: TSpeedButton;
    PrintParcelSpeedButton: TSpeedButton;
    AddToParcelListSpeedButton: TSpeedButton;
    AuditSpeedButton: TSpeedButton;
    btn_LetterPrint: TSpeedButton;
    btn_Pictometry: TSpeedButton;
    btnGIS: TSpeedButton;
    procedure PrintScreenSpeedButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure PrintParcelSpeedButtonClick(Sender: TObject);
    procedure CompsSpeedButtonClick(Sender: TObject);
    procedure AuditSpeedButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure AddToParcelListSpeedButtonClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btn_LetterPrintClick(Sender: TObject);
    procedure btn_PictometryClick(Sender: TObject);
    procedure btnGISClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    InitialPositionSet : Boolean;
  end;

var
  ParcelToolbarForm: TParcelToolbarForm;

implementation

{$R *.DFM}

uses GlblVars, ParclTab, Prcllist, EstimatedTaxLetterUnit, PASUtils, DataAccessUnit,
  DataModule;

{======================================================================}
Procedure TParcelToolbarForm.FormShow(Sender: TObject);

begin
  If not InitialPositionSet
    then
      begin
        InitialPositionSet := True;
(*        GetCurrentPositionEx(Application.Handle, Point);
        WindowPlace.Length := SizeOf(WINDOWPLACEMENT);
        ReturnVal := GetWindowPlacement(Application.Mainform.Canvas.Handle, @WindowPlace);

        Rect := WindowPlace.rcNormalPosition;

        ReturnVal := GetWindowOrgEx(Application.Mainform.Canvas.Handle, Point);

        If ReturnVal
          then MessageDlg('X: ' + IntToStr(Point.X) +
                          '  Y: ' + IntToStr(Point.Y), mtInformation, [mbOK], 0);

        SystemParametersInfo(SPI_GETWORKAREA, 0, @Rect, 0);

        MessageDlg('Left: ' + IntToStr(Rect.Left) +
                   'Top: ' + IntToStr(Rect.Top) +
                   'Right: ' + IntToStr(Rect.Right) +
                   'Bottom: ' + IntToStr(Rect.Bottom),
                   mtInformation, [mbOK], 0);

        Top := 0;
        Left := Application.MainForm.Width - Self.Width - 30;

        Top := Rect.Top;
        Left := Rect.Left +
                Application.MainForm.Width - Self.Width - 30; *)

        Left := GetSystemMetrics(SM_CXSMSIZE);

        Top := Application.MainForm.ClientOrigin.Y -
               GetSystemMetrics(SM_CYBORDER) - {Subtract the border of the window}
               GetSystemMetrics(SM_CYCAPTION) - {Subtract the caption of the window}
               GetSystemMetrics(SM_CYMENU);  {Subtract the menu height}
        Left := Application.MainForm.ClientOrigin.X +
                Application.MainForm.Width -
                Self.Width -  {subtract size of the toolbar}
                3 * GetSystemMetrics(SM_CXSMSIZE) - {Subtract the size of 3 buttons}
                20;  {Fudge factor}

        If not GlblUserCanSeeComparables
          then CompsSpeedButton.Enabled := False;

        If not GlblUserCanRunAudits
          then AuditSpeedButton.Enabled := False;

        If GlblUserIsSearcher
          then AddToParcelListSpeedButton.Enabled := False;

        If not GlblAllowLetterPrint
          then
            begin
              Width := 185;
              btn_LetterPrint.Visible := False;

              btn_Pictometry.Left := 120;
              btnGIS.Left := 144;
            end;

        If GlblUsesPictometry
        then btn_Pictometry.Visible := True;

        If glblToolbarLaunchesGIS
        then btnGIS.Visible := True;

      end;  {If not InitialPositionSet}

end;  {FormShow}

{======================================================================}
Procedure TParcelToolbarForm.FormCreate(Sender: TObject);

begin
  InitialPositionSet := False;
  GlblParcelToolbarIsCreated := True;
end;  {FormCreate}

{===================================================================}
Procedure TParcelToolbarForm.CompsSpeedButtonClick(Sender: TObject);

var
  TempComparablesCommandLine : String;
  ComparablesPChar : PChar;
  TempLen : Integer;

begin
  TempComparablesCommandLine := 'PASComparables.EXE TYPE=SALES ' +
                                'PARCELID="' +
                                TParcelTabForm(GlblParcelMaintenance).CurrentSwisSBLKey + '"';

  TempLen := Length(TempComparablesCommandLine);
  ComparablesPChar := StrAlloc(TempLen + 1);
  StrPCopy(ComparablesPChar, TempComparablesCommandLine);

  WinExec(ComparablesPChar, SW_SHOW);
  StrDispose(ComparablesPChar);

  SendToBack;

end;  {CompsSpeedButtonClick}

{======================================================================}
Procedure TParcelToolbarForm.PrintScreenSpeedButtonClick(Sender: TObject);

var
  Key : Word;

begin
  Key := VK_F3;

  try
    TParcelTabForm(GlblParcelMaintenance).FormKeyDown(Sender, Key, []);
  except
  end;

end;  {PrintScreenSpeedButtonClick}

{======================================================================}
Procedure TParcelToolbarForm.PrintParcelSpeedButtonClick(Sender: TObject);

var
  Key : Word;

begin
  Key := VK_F5;

  try
    TParcelTabForm(GlblParcelMaintenance).FormKeyDown(Sender, Key, []);
  except
  end;

end;  {PrintParcelSpeedButtonClick}

{================================================================}
Procedure TParcelToolbarForm.AuditSpeedButtonClick(Sender: TObject);

var
  Key : Word;

begin
  Key := VK_F8;

  try
    TParcelTabForm(GlblParcelMaintenance).FormKeyDown(Sender, Key, []);
  except
  end;

end;  {AuditSpeedButtonClick}

{================================================================}
Procedure TParcelToolbarForm.AddToParcelListSpeedButtonClick(Sender: TObject);

var
  SwisSBLKey : String;

begin
  SwisSBLKey := TParcelTabForm(GlblParcelMaintenance).CurrentSwisSBLKey;

  If not ParcelListDialog.Visible
    then ParcelListDialog.Show;

  If not ParcelListDialog.ParcelExistsInList(SwisSBLKey)
    then ParcelListDialog.AddOneParcel(SwisSBLKey);

end;  {AddToParcelListSpeedButtonClick}

{=================================================================}
Procedure TParcelToolbarForm.btn_LetterPrintClick(Sender: TObject);

begin
  try
    EstimatedTaxLetterForm := TEstimatedTaxLetterForm.Create(Application);
    EstimatedTaxLetterForm.SwisSBLKey := GlblCurrentSwisSBLKey;
    EstimatedTaxLetterForm.ShowModal;
  finally
    EstimatedTaxLetterForm.Free;
  end;

end;  {btn_LetterPrintClick}

{===========================================================================}
Procedure TParcelToolbarForm.FormClose(    Sender: TObject;
                                       var Action: TCloseAction);

{FXX07312003-1(2.07h): Make sure not to try to bring toolbar to front if it is closed.}

begin
  GlblParcelToolbarIsCreated := False;
end;

{=================================================================}
procedure TParcelToolbarForm.btn_PictometryClick(Sender: TObject);

var
  ParcelVanViewCOM1: TParcelVanViewCOM;
  sSwisSBLKey, sFacetSBL : String;
  iReturnCode : Integer;

begin
  try
    ParcelVanViewCOM1 := TParcelVanViewCOM.Create(nil);

    with ParcelVanViewCOM1 do
    begin
      sSwisSBLKey := TParcelTabForm(GlblParcelMaintenance).CurrentSwisSBLKey;

      If glblUsesPictometry_FullSBL
      then sFacetSBL := sSwisSBLKey
      else sFacetSBL := Copy(sSwisSBLKey, 1, 6) + ConvertSBLOnlyToDashDot(Copy(sSwisSBLKey, 7, 20));

      If glblUsesPictometry_OldPrintKey
      then
      begin
        _Locate(PASDataModule.NYParcelTable, [GlblNextYear, sSwisSBLKey], '', [loParseSwisSBLKey]);

        sFacetSBL := Copy(sSwisSBLKey, 1, 6) + PASDataModule.NYParcelTable.FieldByName('PrintKey').AsString;
      end;
      
      ConnectKind := ckRunningOrNew;
      AutoConnect := False;
      iReturnCode := ShowParcel(sFacetSBL);
      (*ShowMessage(IntToStr(iReturnCode) + ' SBL: ' + sFacetSBL);*)

    end;

  finally
    ParcelVanViewCOM1.Free;
  end;

end;

{====================================================================}
Procedure TParcelToolbarForm.btnGISClick(Sender: TObject);

begin
  try
    ShellExecute(0, 'open',
                 PChar('https://www.municitygis.com/NorthCastle.html?user=GIS&pw=GIS&pid=' +
                       PASDataModule.NYParcelTable.FieldByName('PrintKey').AsString),
                 nil, nil, SW_NORMAL);
  except
    MessageDlg('Unable to connect to website.',
               mtError, [mbOk], 0);
  end;


end;

end.
