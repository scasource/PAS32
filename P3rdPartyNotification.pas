unit P3rdPartyNotification;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  StdCtrls, ExtCtrls, Forms, Dialogs, DB, Grids, DBGrids,
  DBTables, Mask, DBCtrls, Wwtable, Wwdatsrc, Wwdbcomb, Wwdbigrd, Wwdbgrid,
  Btrvdlg, Types, wwdblook, Buttons, ComCtrls;

type
  TThirdPartyNotificationForm = class(TForm)
    ThirdPartyNotificationTable: TwwTable;
    Panel1: TPanel;
    TitleLabel: TLabel;
    Panel2: TPanel;
    ParcelDataSource: TDataSource;
    ParcelTable: TTable;
    InactiveLabel: TLabel;
    Label53: TLabel;
    Label55: TLabel;
    TotalAVLabel: TLabel;
    LandAVLabel: TLabel;
    PartialAssessmentLabel: TLabel;
    LookupTable: TTable;
    SetFocusTimer: TTimer;
    Panel5: TPanel;
    ThirdPartyNotificationListView: TListView;
    Panel4: TPanel;
    NewButton: TBitBtn;
    DeleteButton: TBitBtn;
    CloseButton: TBitBtn;
    Panel3: TPanel;
    Label5: TLabel;
    Label7: TLabel;
    Label4: TLabel;
    EditName: TDBEdit;
    EditSBL: TMaskEdit;
    EditLocation: TEdit;

    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CloseButtonClick(Sender: TObject);
    procedure ThirdPartyNotificationListViewClick(Sender: TObject);
    procedure NewButtonClick(Sender: TObject);
    procedure DeleteButtonClick(Sender: TObject);
    procedure ThirdPartyNotificationListViewKeyPress(Sender: TObject;
      var Key: Char);
    procedure SetFocusTimerTimer(Sender: TObject);

  protected
    procedure CreateParams(var Params: TCreateParams); override;
  public
    { public declarations }
    UnitName : String;  {For use with error dialog box.}

      {These will be set in the ParcelTabForm.}

    EditMode : Char;  {A = Add; M = Modify; V = View}
    TaxRollYr : String;
    SwisSBLKey : String;

    FormAccessRights : Integer;
    Procedure InitializeForm;
    Procedure FillInThirdPartyNotificationListView;
    Procedure ShowSubform(_SwisSBLKey : String;
                          _NotificationNumber : Integer;
                          _EditMode : String);

  end;    {end form object definition}

implementation

uses GlblVars, PASTypes, WinUtils, PASUTILS, UTILEXSD,  Utilitys,
     GlblCnst, DataAccessUnit, DlgNameAddressUnit;


{$R *.DFM}

{=====================================================================}
Procedure TThirdPartyNotificationForm.CreateParams(var Params: TCreateParams);

begin
 inherited CreateParams(Params);

  with Params do
    begin
      WndParent := Application.Mainform.Handle;
      Style := (Style or WS_Child) and not WS_Popup;
    end;

end;  {CreateParams}

{====================================================================}
Procedure TThirdPartyNotificationForm.SetFocusTimerTimer(Sender: TObject);

begin
  SetFocusTimer.Enabled := False;
  ThirdPartyNotificationListView.SetFocus;
  SelectListViewItem(ThirdPartyNotificationListView, 0);

end;  {SetFocusTimerTimer}

{====================================================================}
Procedure TThirdPartyNotificationForm.FillInThirdPartyNotificationListView;

var
  Done, FirstTimeThrough : Boolean;
  NAddrArray : NameAddrArray;

begin
  FirstTimeThrough := True;
  _SetRange(ThirdPartyNotificationTable, [SwisSBLKey, '0'], [SwisSBLKey, '999'], '', []);
  ThirdPartyNotificationListView.Items.Clear;

  with ThirdPartyNotificationTable do
    begin
      First;

      repeat
        If FirstTimeThrough
          then FirstTimeThrough := False
          else Next;

        Done := EOF;

        If not Done
          then
            begin
              GetNameAddress(ThirdPartyNotificationTable, NAddrArray);
              FillInListViewRow(ThirdPartyNotificationListView,
                                [FieldByName('NoticeNumber').Text,
                                 NAddrArray[1], NAddrArray[2], NAddrArray[3], NAddrArray[4]],
                                False);

            end;  {If not Done}

      until Done;

    end;  {with ThirdPartyNotificationTable do}

end;  {FillInThirdPartyNotificationListView}

{====================================================================}
Procedure TThirdPartyNotificationForm.InitializeForm;

var
  Found : Boolean;

begin
  UnitName := 'P3rdPartyNotification';  {mmm1}

  If (Deblank(SwisSBLKey) <> '')
    then
      begin
          {If this is the history file, or they do not have read access,
           then we want to set the files to read only.}

        If ((not ModifyAccessAllowed(FormAccessRights)) or
            _Compare(EditMode, 'V', coEqual))
          then
            begin
              ThirdPartyNotificationTable.ReadOnly := True;
              NewButton.Enabled := False;
              DeleteButton.Enabled := False;

            end;  {If ((not ModifyAccessAllowed(FormAccessRights)) or ...}

        OpenTablesForForm(Self, GlblProcessingType);

        Found := _Locate(ParcelTable, [TaxRollYr, SwisSBLKey], '', [loParseSwisSBLKey]);

        If not Found
          then SystemSupport(005, ParcelTable, 'Error finding key in parcel table.', UnitName, GlblErrorDlgBox);

        TitleLabel.Left := (Panel1.Width - TitleLabel.Width) DIV 2;
        EditLocation.Text := GetLegalAddressFromTable(ParcelTable);
        EditSBL.Text := ConvertSwisSBLToDashDot(SwisSBLKey);

        FillInThirdPartyNotificationListView;

      end;  {If (Deblank(SwisSBLKey) <> '')}

  SetFocusTimer.Enabled := True;

end;  {InitializeForm}

{==============================================================}
Procedure TThirdPartyNotificationForm.ShowSubform(_SwisSBLKey : String;
                                                  _NotificationNumber : Integer;
                                                  _EditMode : String);

begin
  try
    NameAddressDialogForm := TNameAddressDialogForm.Create(nil);

    NameAddressDialogForm.InitializeForm(_SwisSBLKey, ThirdPartyNotificationTableName, 'BYSWISSBLKEY_NOTICENUMBER',
                                         _NotificationNumber, 'NoticeNumber',
                                         _EditMode, '3rd party notification', False);

    If (NameAddressDialogForm.ShowModal = idOK)
      then FillInThirdPartyNotificationListView;

  finally
    NameAddressDialogForm.Free;
  end;

end;  {ShowSubform}

{==============================================================}
Procedure TThirdPartyNotificationForm.ThirdPartyNotificationListViewClick(Sender: TObject);

var
  NotificationNumber : Integer;
  EditMode : String;

begin
  try
    NotificationNumber := StrToInt(GetColumnValueForItem(ThirdPartyNotificationListView, 0, -1));
  except
    NotificationNumber := 0;
  end;

  If _Compare(NotificationNumber, 0, coGreaterThan)
    then
      begin
        If ThirdPartyNotificationTable.ReadOnly
          then EditMode := emBrowse
          else EditMode := emEdit;

        ShowSubform(SwisSBLKey, NotificationNumber, EditMode);

      end;  {If _Compare(NotificationNumber, 0, coGreaterThan)}

end;  {ThirdPartyNotificationListViewClick}

{==============================================================}
Procedure TThirdPartyNotificationForm.ThirdPartyNotificationListViewKeyPress(    Sender: TObject;
                                                                             var Key: Char);

begin
  If (Key = #13)
    then
      begin
        Key := #0;
        ThirdPartyNotificationListViewClick(Sender);
      end;

end;  {ThirdPartyNotificationListViewKeyPress}

{==============================================================}
Procedure TThirdPartyNotificationForm.NewButtonClick(Sender: TObject);

var
  NotificationNumber : Integer;

begin
  _SetRange(LookupTable, [SwisSBLKey, '0'], [SwisSBLKey, '999'], '', []);
  LookupTable.First;

  If LookupTable.EOF
    then NotificationNumber := 1
    else
      begin
        LookupTable.Last;
        NotificationNumber := LookupTable.FieldByName('NoticeNumber').AsInteger + 1;
      end;

  ShowSubform(SwisSBLKey, NotificationNumber, emInsert);

end;  {NewButtonClick}

{==============================================================}
Procedure TThirdPartyNotificationForm.DeleteButtonClick(Sender: TObject);

var
  NotificationNumber : Integer;

begin
  try
    NotificationNumber := StrToInt(GetColumnValueForItem(ThirdPartyNotificationListView, 0, -1));
  except
    NotificationNumber := 0;
  end;

  If (_Compare(NotificationNumber, 0, coGreaterThan) and
      _Locate(ThirdPartyNotificationTable, [SwisSBLKey, NotificationNumber], '', []) and
      (MessageDlg('Do you want to delete notification #' + IntToStr(NotificationNumber) + '?',
                  mtConfirmation, [mbYes, mbNo], 0) = idYes))
    then
      begin
        ThirdPartyNotificationTable.Delete;
        FillInThirdPartyNotificationListView;

      end;  {If _Compare(NotificationNumber, 0, coGreaterThan)}

end;  {DeleteButtonClick}

{===============================================================================}
Procedure TThirdPartyNotificationForm.CloseButtonClick(Sender: TObject);

{Note that the close button is a close for the whole
 parcel maintenance.}

{To close the whole parcel maintenance, we will once again use
 the base popup menu. We will simulate a click on the
 "Exit Parcel Maintenance" of the BasePopupMenu which will
 then call the Close of ParcelTabForm. See the locate button
 click above for more information on how this works.}

var
  I : Integer;

begin
    {Search for the name of the menu item that has "Exit"
     in it, and click it.}

  For I := 0 to (PopupMenu.Items.Count - 1) do
    If (Pos('Exit', PopupMenu.Items[I].Name) <> 0)
      then PopupMenu.Items[I].Click;

end;  {CloseButtonClick}

{====================================================================}
Procedure TThirdPartyNotificationForm.FormClose(    Sender: TObject;
                                                var Action: TCloseAction);

begin
  CloseTablesForForm(Self);
  Action := caFree;

end;  {FormClose}

end.
