unit pAgriculture;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  StdCtrls, ExtCtrls, Forms, Dialogs, DB, Grids, DBGrids,
  DBTables, Mask, DBCtrls, Wwtable, Wwdatsrc, Wwdbcomb, Wwdbigrd, Wwdbgrid,
  Btrvdlg, Types, wwdblook, Buttons, ComCtrls;

type
  TfmAgriculture = class(TForm)
    tbAgricultureHeader: TwwTable;
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
    lvAgriculture: TListView;
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
    procedure lvAgricultureClick(Sender: TObject);
    procedure NewButtonClick(Sender: TObject);
    procedure DeleteButtonClick(Sender: TObject);
    procedure lvAgricultureKeyPress(Sender: TObject;
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
    Procedure FillInAgricultureListView;
    Procedure ShowSubform(_SwisSBLKey : String;
                          _AgricultureLandNumber : Integer;
                          _EditMode : String);

  end;    {end form object definition}

implementation

uses GlblVars, PASTypes, WinUtils, PASUTILS, UTILEXSD,  Utilitys,
     GlblCnst, DataAccessUnit, PAgricultureSubFormUnit;


{$R *.DFM}

{=====================================================================}
Procedure TfmAgriculture.CreateParams(var Params: TCreateParams);

begin
 inherited CreateParams(Params);

  with Params do
    begin
      WndParent := Application.Mainform.Handle;
      Style := (Style or WS_Child) and not WS_Popup;
    end;

end;  {CreateParams}

{====================================================================}
Procedure TfmAgriculture.SetFocusTimerTimer(Sender: TObject);

begin
  SetFocusTimer.Enabled := False;
  lvAgriculture.SetFocus;
  SelectListViewItem(lvAgriculture, 0);

end;  {SetFocusTimerTimer}

{====================================================================}
Procedure TfmAgriculture.FillInAgricultureListView;

var
  Done, FirstTimeThrough : Boolean;

begin
  FirstTimeThrough := True;
  _SetRange(tbAgricultureHeader, [TaxRollYr, SwisSBLKey], [TaxRollYr, SwisSBLKey], '', []);
  lvAgriculture.Items.Clear;

  with tbAgricultureHeader do
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
              FillInListViewRow(lvAgriculture,
                                [FieldByName('Agriculture_ID').Text,
                                 FormatFloat(DecimalDisplay_BlankZero, FieldByName('IneligibleAcreage').AsFloat),
                                 FormatFloat(IntegerEditDisplay_NoBlankZero, FieldByName('IneligibleLand').AsFloat),
                                 FormatFloat(DecimalDisplay_BlankZero, FieldByName('ResidentialAcreage').AsFloat),
                                 FormatFloat(IntegerEditDisplay_NoBlankZero, FieldByName('ResidentialLand').AsFloat),
                                 FormatFloat(IntegerEditDisplay_NoBlankZero, FieldByName('ResidentialBuilding').AsFloat)],
                                False);

            end;  {If not Done}

      until Done;

    end;  {with tbAgricultureHeader do}

end;  {FillInAgricultureListView}

{====================================================================}
Procedure TfmAgriculture.InitializeForm;

var
  Found : Boolean;

begin
  UnitName := 'PAgriculture';  {mmm1}

  If (Deblank(SwisSBLKey) <> '')
    then
      begin
          {If this is the history file, or they do not have read access,
           then we want to set the files to read only.}

        If ((not ModifyAccessAllowed(FormAccessRights)) or
            _Compare(EditMode, 'V', coEqual))
          then
            begin
              tbAgricultureHeader.ReadOnly := True;
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

        FillInAgricultureListView;

      end;  {If (Deblank(SwisSBLKey) <> '')}

  SetFocusTimer.Enabled := True;

end;  {InitializeForm}

{==============================================================}
Procedure TfmAgriculture.ShowSubform(_SwisSBLKey : String;
                                          _AgricultureLandNumber : Integer;
                                          _EditMode : String);

begin
  try
    AgricultureSubform := TAgricultureSubform.Create(nil);

    AgricultureSubform.InitializeForm(_SwisSBLKey, _AgricultureLandNumber, _EditMode);

    If (AgricultureSubform.ShowModal = idOK)
      then FillInAgricultureListView;

  finally
    AgricultureSubform.Free;
  end;

end;  {ShowSubform}

{==============================================================}
Procedure TfmAgriculture.lvAgricultureClick(Sender: TObject);

var
  AgricultureLandNumber : Integer;
  EditMode : String;

begin
  try
    AgricultureLandNumber := StrToInt(GetColumnValueForItem(lvAgriculture, 0, -1));
  except
    AgricultureLandNumber := 0;
  end;

  If _Compare(AgricultureLandNumber, 0, coGreaterThan)
    then
      begin
        If tbAgricultureHeader.ReadOnly
          then EditMode := emBrowse
          else EditMode := emEdit;

        ShowSubform(SwisSBLKey, AgricultureLandNumber, EditMode);

      end;  {If _Compare(AgricultureLandNumber, 0, coGreaterThan)}

end;  {AgricultureListViewClick}

{==============================================================}
Procedure TfmAgriculture.lvAgricultureKeyPress(    Sender: TObject;
                                                                             var Key: Char);

begin
  If (Key = #13)
    then
      begin
        Key := #0;
        lvAgricultureClick(Sender);
      end;

end;  {AgricultureListViewKeyPress}

{==============================================================}
Procedure TfmAgriculture.NewButtonClick(Sender: TObject);

var
  AgricultureLandNumber : Integer;

begin
  _SetRange(LookupTable, [SwisSBLKey, '0'], [SwisSBLKey, '999'], '', []);
  LookupTable.First;

  If LookupTable.EOF
    then AgricultureLandNumber := 1
    else
      begin
        LookupTable.Last;
        AgricultureLandNumber := LookupTable.FieldByName('LandNumber').AsInteger + 1;
      end;

  ShowSubform(SwisSBLKey, AgricultureLandNumber, emInsert);

end;  {NewButtonClick}

{==============================================================}
Procedure TfmAgriculture.DeleteButtonClick(Sender: TObject);

var
  AgricultureLandNumber : Integer;

begin
  try
    AgricultureLandNumber := StrToInt(GetColumnValueForItem(lvAgriculture, 0, -1));
  except
    AgricultureLandNumber := 0;
  end;

  If (_Compare(AgricultureLandNumber, 0, coGreaterThan) and
      _Locate(tbAgricultureHeader, [SwisSBLKey, AgricultureLandNumber], '', []) and
      (MessageDlg('Do you want to delete ag land #' + IntToStr(AgricultureLandNumber) + '?',
                  mtConfirmation, [mbYes, mbNo], 0) = idYes))
    then
      begin
        tbAgricultureHeader.Delete;
        FillInAgricultureListView;

      end;  {If _Compare(AgricultureLandNumber, 0, coGreaterThan)}

end;  {DeleteButtonClick}

{===============================================================================}
Procedure TfmAgriculture.CloseButtonClick(Sender: TObject);

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
Procedure TfmAgriculture.FormClose(    Sender: TObject;
                                                var Action: TCloseAction);

begin
  CloseTablesForForm(Self);
  Action := caFree;

end;  {FormClose}

end.
