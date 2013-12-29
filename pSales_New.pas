unit pSales_New;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  StdCtrls, ExtCtrls, Forms, Dialogs, DB, Grids, DBGrids,
  DBTables, Mask, DBCtrls, Wwtable, Wwdatsrc, Wwdbcomb, Wwdbigrd, Wwdbgrid,
  Btrvdlg, Types, wwdblook, Buttons, RPFiler, RPBase, RPCanvas, RPrinter,
  Printrng, RPMemo, RPDBUtil, RPDefine, Progress, wwMemo, ComCtrls;

type
  TSales_NewForm = class(TForm)
    Panel1: TPanel;
    TitleLabel: TLabel;
    Panel2: TPanel;
    ScrollBox: TScrollBox;
    ParcelDataSource: TDataSource;
    ParcelTable: TTable;
    YearLabel: TLabel;
    InactiveLabel: TLabel;
    Label53: TLabel;
    Label55: TLabel;
    TotalAVLabel: TLabel;
    LandAVLabel: TLabel;
    AssessmentYearControlTable: TTable;
    OldParcelIDLabel: TLabel;
    PartialAssessmentLabel: TLabel;
    FooterPanel: TPanel;
    CloseButton: TBitBtn;
    Panel4: TPanel;
    StatusPanel: TPanel;
    Panel5: TPanel;
    Label5: TLabel;
    Label7: TLabel;
    Label4: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label6: TLabel;
    EditName: TDBEdit;
    EditSBL: TMaskEdit;
    EditLocation: TEdit;
    EditLastChangeDate: TDBEdit;
    EditLastChangeByName: TDBEdit;
    MainListView: TListView;
    NewButton: TBitBtn;
    DeleteButton: TBitBtn;
    SetFocusTimer: TTimer;
    MainQuery: TQuery;
    SalesInventoryButton: TButton;
    OwnerProgressionButton: TButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CloseButtonClick(Sender: TObject);
    procedure PrintButtonClick(Sender: TObject);
    procedure ReportPrinterPrintHeader(Sender: TObject);
    procedure ReportFilerPrint(Sender: TObject);
    procedure SetFocusTimerTimer(Sender: TObject);
    procedure MainListViewClick(Sender: TObject);
    procedure MainListViewKeyPress(Sender: TObject; var Key: Char);
    procedure NewButtonClick(Sender: TObject);
    procedure DeleteButtonClick(Sender: TObject);
    procedure MainListViewCompare(Sender: TObject; Item1, Item2: TListItem;
      Data: Integer; var Compare: Integer);
    procedure MainListViewColumnClick(Sender: TObject;
      Column: TListColumn);
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  public
    { public declarations }
    UnitName : String;  {For use with error dialog box.}

      {These will be set in the ParcelTabForm.}

    EditMode : Char;  {A = Add; M = Modify; V = View}
    TaxRollYr, SwisSBLKey : String;
    ProcessingType, ColumnToSort : Integer;  {NextYear, ThisYear, History}

    FormAccessRights : Integer;  {Read only or read write, based on security level?}
                                {Values = raReadOnly, raReadWrite}

    Procedure FillInMainListView;
    Procedure ShowSubform(_SwisSBLKey : String;
                          _SaleNumber : Integer;
                          _EditMode : String);
    Procedure InitializeForm;
  end;

implementation

uses GlblVars, PASTypes, WinUtils, PASUTILS, Utilitys,
     GlblCnst, DataAccessUnit, PSales_New_Subform;

{$R *.DFM}

const
  MainSortField = 'SaleNumber';

{=====================================================================}
Procedure TSales_NewForm.CreateParams(var Params: TCreateParams);

begin
 inherited CreateParams(Params);

  with Params do
    begin
      WndParent := Application.Mainform.Handle;
      Style := (Style or WS_Child) and not WS_Popup;
    end;

end;  {CreateParams}

{====================================================================}
Procedure TSales_NewForm.SetFocusTimerTimer(Sender: TObject);

begin
  SetFocusTimer.Enabled := False;
  MainListView.SetFocus;
  SelectListViewItem(MainListView, 0);

end;  {SetFocusTimerTimer}

{====================================================================}
Procedure TSales_NewForm.MainListViewCompare(    Sender : TObject;
                                                 Item1,
                                                 Item2 : TListItem;
                                                 Data : Integer;
                                             var Compare : Integer);

var
  Index, Int1, Int2 : Integer;

begin
  If _Compare(ColumnToSort, 0, coEqual)
    then
      begin
        try
          Int1 := StrToInt(Item1.Caption);
        except
          Int1 := 0;
        end;

        try
          Int2 := StrToInt(Item2.Caption);
        except
          Int2 := 0;
        end;

        If _Compare(Int1, Int2, coLessThan)
          then Compare := -1;

        If _Compare(Int1, Int2, coEqual)
          then Compare := 0;

        If _Compare(Int1, Int2, coGreaterThan)
          then Compare := 1;

      end
    else
      begin
        Index := ColumnToSort - 1;
        Compare := CompareText(Item1.SubItems[Index], Item2.SubItems[Index]);
      end;

end;  {MainListViewCompare}

{====================================================================}
Procedure TSales_NewForm.MainListViewColumnClick(Sender : TObject;
                                                 Column : TListColumn);
begin
  ColumnToSort := Column.Index;
  (Sender as TCustomListView).AlphaSort;
end;

{====================================================================}
Procedure LoadDataForParcel(MainQuery : TQuery;
                            SwisSBLKey : String);

begin
  MainQuery.SQL.Clear;
  MainQuery.SQL.Add('Select * from ' + SalesTableName);
  MainQuery.SQL.Add('where SwisSBLKey = ' + '''' + SwisSBLKey + '''');
  MainQuery.Open;

end;  {LoadDataForParcel}

{====================================================================}
Procedure TSales_NewForm.FillInMainListView;

begin
  LoadDataForParcel(MainQuery, SwisSBLKey);

  FillInListView(MainListView, MainQuery,
                 ['SaleNumber', 'DateEntered', 'TimeEntered', 'EnteredByUserID',
                  'TransactionCode', 'NoteTypeCode', 'DueDate', 'UserResponsible',
                  'NoteOpen', 'Note'],
                 True);

  MainListViewColumnClick(MainListView, MainListView.Columns[0]);

end;  {FillInMainListView}

{====================================================================}
Procedure TSales_NewForm.InitializeForm;

var
  Found : Boolean;

begin
  UnitName := 'pSales_New';

  If (Deblank(SwisSBLKey) <> '')
    then
      begin
        If ((not ModifyAccessAllowed(FormAccessRights)) or
            _Compare(EditMode, emBrowse, coEqual))
          then
            begin
              NewButton.Enabled := False;
              DeleteButton.Enabled := False;
            end;

        OpenTablesForForm(Self, ProcessingType);

        Found := _Locate(ParcelTable, [TaxRollYr, SwisSBLKey], '', [loParseSwisSBLKey]);

        If not Found
          then SystemSupport(001, ParcelTable, 'Error finding key in parcel table.', UnitName, GlblErrorDlgBox);

        EditLocation.Text := GetLegalAddressFromTable(ParcelTable);
        YearLabel.Caption := GetTaxYrLbl;
        EditSBL.Text := ConvertSwisSBLToDashDot(SwisSBLKey);

        If (ParcelTable.FieldByName('ActiveFlag').Text = InactiveParcelFlag)
          then InactiveLabel.Visible := True;

        If GlblLocateByOldParcelID
          then SetOldParcelIDLabel(OldParcelIDLabel, ParcelTable,
                                   AssessmentYearControlTable);

        FillInMainListView;

      end;  {If (Deblank(SwisSBLKey) <> '')}

  If GlblCloseButtonIsLocate
    then MakeCloseButtonLocate(CloseButton);

  SetFocusTimer.Enabled := True;

end;  {InitializeForm}

{==============================================================}
Procedure TSales_NewForm.ShowSubform(_SwisSBLKey : String;
                                     _SaleNumber : Integer;
                                     _EditMode : String);

begin
  try
    SalesEntryDialogForm := TSalesEntryDialogForm.Create(nil);

    SalesEntryDialogForm.InitializeForm(_SwisSBLKey, _SaleNumber, _EditMode);

    If (SalesEntryDialogForm.ShowModal <> idCancel)
      then FillInMainListView;

  finally
    SalesEntryDialogForm.Free;
  end;

end;  {ShowSubform}

{==============================================================}
Procedure TSales_NewForm.MainListViewClick(Sender: TObject);

var
  SaleNumber : Integer;
  _EditMode : String;

begin
  try
    SaleNumber := StrToInt(GetColumnValueForSelectedItem(MainListView, 0));
  except
    SaleNumber := 0;
  end;

  If _Compare(SaleNumber, 0, coGreaterThan)
    then
      begin
        If (ModifyAccessAllowed(FormAccessRights) and
            _Compare(EditMode, emEdit, coEqual))
          then _EditMode := emEdit
          else _EditMode := emBrowse;

        ShowSubform(SwisSBLKey, SaleNumber, _EditMode);
        FillInMainListView;
        SelectListViewItem(MainListView, SaleNumber);

      end;  {If _Compare(SaleNumber, 0, coGreaterThan)}

end;  {MainListViewClick}

{==============================================================}
Procedure TSales_NewForm.MainListViewKeyPress(    Sender: TObject;
                                              var Key: Char);

begin
  If (Key = #13)
    then
      begin
        Key := #0;
        MainListViewClick(Sender);
      end;

end;  {MainListViewKeyPress}

{==============================================================}
Procedure TSales_NewForm.NewButtonClick(Sender: TObject);

var
  SaleNumber : Integer;

begin
  LoadDataForParcel(MainQuery, SwisSBLKey);

  with MainQuery do
    begin
      First;

      If EOF
        then SaleNumber := 1
        else
          begin
            Last;
            SaleNumber := FieldByName(MainSortField).AsInteger + 1;
          end;

    end;  {with MainQuery do}

  ShowSubform(SwisSBLKey, SaleNumber, emInsert);
  FillInMainListView;

end;  {NewButtonClick}

{==============================================================}
Procedure TSales_NewForm.DeleteButtonClick(Sender: TObject);

var
  SaleNumber : Integer;

begin
  try
    SaleNumber := StrToInt(GetColumnValueForSelectedItem(MainListView, 0));
  except
    SaleNumber := 0;
  end;

  with MainQuery do
    If _Compare(SaleNumber, 0, coGreaterThan)
      then
        If (MessageDlg('Do you want to delete sale #' + IntToStr(SaleNumber) + '?',
                       mtConfirmation, [mbYes, mbNo], 0) = idYes)
          then
            begin
              with MainQuery do
                try
                  SQL.Clear;
                  SQL.Add('Delete from PNotesRec');
                  SQL.Add('where (SwisSBLKey = ' + '''' + SwisSBLKey + '''' + ') and');
                  SQL.Add('(' + MainSortField + ' = ' + '''' + IntToStr(SaleNumber) + '''' + ')');
                except
                end;

              MainQuery.ExecSQL;
              FillInMainListView;

            end;  {If _Compare(SaleNumber, 0, coGreaterThan)}

end;  {DeleteButtonClick}

{==============================================================}
Procedure TSales_NewForm.CloseButtonClick(Sender: TObject);

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
Procedure TSales_NewForm.FormClose(    Sender: TObject;
                               var Action: TCloseAction);

begin
  CloseTablesForForm(Self);
  Action := caFree;

end;  {FormClose}

end.
