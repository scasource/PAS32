unit PTaxInformation;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  StdCtrls, ExtCtrls, Forms, Dialogs, DB, Grids, DBGrids,
  DBTables, Mask, DBCtrls, Wwtable, Wwdatsrc, Wwdbcomb, Wwdbigrd, Wwdbgrid,
  Btrvdlg, Types, wwdblook, Buttons, ComCtrls;

type
  TfmTaxInformation = class(TForm)
    tbBillCycleHeader: TwwTable;
    Panel2: TPanel;
    tbParcels: TTable;
    bBillCycleDetails: TTable;
    Panel5: TPanel;
    lvTaxInformation: TListView;
    Panel4: TPanel;
    btnClose: TBitBtn;
    Panel3: TPanel;
    Label5: TLabel;
    Label7: TLabel;
    Label4: TLabel;
    edOwner: TDBEdit;
    edParcelID: TMaskEdit;
    edLocation: TEdit;
    dsParcels: TDataSource;

    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnCloseClick(Sender: TObject);
    procedure lvTaxInformationClick(Sender: TObject);
    procedure lvTaxInformationKeyPress(Sender: TObject;
      var Key: Char);

  protected
    procedure CreateParams(var Params: TCreateParams); override;
  public
    { public declarations }
    sUnitName, sSwisSBLKey : String;

    Procedure InitializeForm;
    Procedure FillInListView;
    Procedure ShowSubform(sSwisSBLKey : String;
                          sTaxYear : String;
                          sCollectionType : String
                          iCollectionNumber : Integer);

  end;    {end form object definition}

implementation

uses GlblVars, PASTypes, WinUtils, PASUTILS, UTILEXSD,  Utilitys,
     GlblCnst, DataAccessUnit, DlgNameAddressUnit;


{$R *.DFM}

{=====================================================================}
Procedure TfmTaxInformation.CreateParams(var Params: TCreateParams);

begin
 inherited CreateParams(Params);

  with Params do
    begin
      WndParent := Application.Mainform.Handle;
      Style := (Style or WS_Child) and not WS_Popup;
    end;

end;  {CreateParams}


{====================================================================}
Procedure TfmTaxInformation.FillInAdditionalOwnersListView;

var
  Done, FirstTimeThrough : Boolean;
  NAddrArray : NameAddrArray;

begin
  FirstTimeThrough := True;
  _SetRange(AdditionalOwnersTable, [SwisSBLKey, '0'], [SwisSBLKey, '999'], '', []);
  AdditionalOwnersListView.Items.Clear;

  with AdditionalOwnersTable do
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
              GetNameAddress(AdditionalOwnersTable, NAddrArray);
              FillInListViewRow(AdditionalOwnersListView,
                                [FieldByName('OwnerNumber').Text,
                                 NAddrArray[1], NAddrArray[2], NAddrArray[3], NAddrArray[4]],
                                False);

            end;  {If not Done}

      until Done;

    end;  {with AdditionalOwnersTable do}

end;  {FillInAdditionalOwnersListView}

{====================================================================}
Procedure TfmTaxInformation.InitializeForm;

var
  Found : Boolean;

begin
  UnitName := 'PAdditionalOwners';

  If (Deblank(SwisSBLKey) <> '')
    then
      begin
          {If this is the history file, or they do not have read access,
           then we want to set the files to read only.}

        If ((not ModifyAccessAllowed(FormAccessRights)) or
            _Compare(EditMode, 'V', coEqual))
          then
            begin
              AdditionalOwnersTable.ReadOnly := True;
              NewButton.Enabled := False;
              DeleteButton.Enabled := False;

            end;  {If ((not ModifyAccessAllowed(FormAccessRights)) or ...}

        OpenTablesForForm(Self, GlblProcessingType);

        Found := _Locate(ParcelTable, [TaxRollYr, SwisSBLKey], '', [loParseSwisSBLKey]);

        If not Found
          then SystemSupport(001, ParcelTable, 'Error finding key in parcel table.', UnitName, GlblErrorDlgBox);

        TitleLabel.Left := (Panel1.Width - TitleLabel.Width) DIV 2;
        EditLocation.Text := GetLegalAddressFromTable(ParcelTable);
        EditSBL.Text := ConvertSwisSBLToDashDot(SwisSBLKey);

        FillInAdditionalOwnersListView;

      end;  {If (Deblank(SwisSBLKey) <> '')}

  SetFocusTimer.Enabled := True;

end;  {InitializeForm}

{==============================================================}
Procedure TfmTaxInformation.ShowSubform(_SwisSBLKey : String;
                                            _OwnerNumber : Integer;
                                            _EditMode : String);

begin
  try
    NameAddressDialogForm := TNameAddressDialogForm.Create(nil);

    NameAddressDialogForm.InitializeForm(_SwisSBLKey, AdditionalOwnersTableName, 'BYSBL_OWNERNUMBER',
                                         _OwnerNumber, 'OwnerNumber',
                                         _EditMode, 'Additional owner', True);

    If (NameAddressDialogForm.ShowModal = idOK)
      then FillInAdditionalOwnersListView;

  finally
    NameAddressDialogForm.Free;
  end;

end;  {ShowSubform}

{==============================================================}
Procedure TfmTaxInformation.lvTaxInformationClick(Sender: TObject);

var
  OwnerNumber : Integer;
  EditMode : String;

begin
  try
    OwnerNumber := StrToInt(GetColumnValueForItem(AdditionalOwnersListView, 0, -1));
  except
    OwnerNumber := 0;
  end;

  If _Compare(OwnerNumber, 0, coGreaterThan)
    then
      begin
        If AdditionalOwnersTable.ReadOnly
          then EditMode := emBrowse
          else EditMode := emEdit;

        ShowSubform(SwisSBLKey, OwnerNumber, EditMode);

      end;  {If _Compare(OwnerNumber, 0, coGreaterThan)}

end;  {AdditionalOwnersListViewClick}

{==============================================================}
Procedure TfmTaxInformation.lvTaxInformationKeyPress(    Sender: TObject;
                                                                             var Key: Char);

begin
  If (Key = #13)
    then
      begin
        Key := #0;
        AdditionalOwnersListViewClick(Sender);
      end;

end;  {AdditionalOwnersListViewKeyPress}

{==============================================================}
Procedure TfmTaxInformation.NewButtonClick(Sender: TObject);

var
  OwnerNumber : Integer;

begin
  _SetRange(LookupTable, [SwisSBLKey, '0'], [SwisSBLKey, '999'], '', []);
  LookupTable.First;

  If LookupTable.EOF
    then OwnerNumber := 1
    else
      begin
        LookupTable.Last;
        OwnerNumber := LookupTable.FieldByName('OwnerNumber').AsInteger + 1;
      end;

  ShowSubform(SwisSBLKey, OwnerNumber, emInsert);

end;  {NewButtonClick}

{==============================================================}
Procedure TfmTaxInformation.DeleteButtonClick(Sender: TObject);

var
  OwnerNumber : Integer;

begin
  try
    OwnerNumber := StrToInt(GetColumnValueForItem(AdditionalOwnersListView, 0, -1));
  except
    OwnerNumber := 0;
  end;

  If (_Compare(OwnerNumber, 0, coGreaterThan) and
      _Locate(AdditionalOwnersTable, [SwisSBLKey, OwnerNumber], '', []) and
      (MessageDlg('Do you want to delete notification #' + IntToStr(OwnerNumber) + '?',
                  mtConfirmation, [mbYes, mbNo], 0) = idYes))
    then
      begin
        AdditionalOwnersTable.Delete;
        FillInAdditionalOwnersListView;

      end;  {If _Compare(OwnerNumber, 0, coGreaterThan)}

end;  {DeleteButtonClick}

{===============================================================================}
Procedure TfmTaxInformation.btnCloseClick(Sender: TObject);

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
Procedure TfmTaxInformation.FormClose(    Sender: TObject;
                                                var Action: TCloseAction);

begin
  CloseTablesForForm(Self);
  Action := caFree;

end;  {FormClose}

end.
