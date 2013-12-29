unit PProrata;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  StdCtrls, ExtCtrls, Forms, Dialogs, DB, Grids, DBGrids,
  DBTables, Mask, DBCtrls, Wwtable, Wwdatsrc, Wwdbcomb, Wwdbigrd, Wwdbgrid,
  Btrvdlg, Types, wwdblook, Buttons, Tabs;

type
  TProrataForm = class(TForm)
    ProrataDataSource: TwwDataSource;
    ProrataTable: TwwTable;
    Panel1: TPanel;
    TitleLabel: TLabel;
    Panel2: TPanel;
    ParcelDataSource: TDataSource;
    ParcelTable: TTable;
    YearLabel: TLabel;
    InactiveLabel: TLabel;
    Label53: TLabel;
    Label55: TLabel;
    TotalAVLabel: TLabel;
    LandAVLabel: TLabel;
    PartialAssessmentLabel: TLabel;
    ProrataTableCategory: TStringField;
    ProrataTableName1: TStringField;
    ProrataTableSchoolCode: TStringField;
    ProrataTableProrataYear: TStringField;
    ProrataTableSaleDate: TDateField;
    ProrataTableLetterPrintedDate: TDateField;
    ProrataDetailsTable: TTable;
    ProrataTableTaxAmount: TFloatField;
    ProrataTableSwisSBLKey: TStringField;
    SetFocusTimer: TTimer;
    ProrataExemptionsTable: TTable;
    Panel4: TPanel;
    Label5: TLabel;
    Label7: TLabel;
    Label4: TLabel;
    EditName: TDBEdit;
    EditSBL: TMaskEdit;
    EditLocation: TEdit;
    Panel3: TPanel;
    NewProrataButton: TBitBtn;
    DeleteProrataButton: TBitBtn;
    PrintProrataButton: TBitBtn;
    CloseButton: TBitBtn;
    ProrataGrid: TwwDBGrid;
    tb_ProrataLookup: TwwTable;

    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CloseButtonClick(Sender: TObject);
    procedure NewProrataButtonClick(Sender: TObject);
    procedure ProrataGridDblClick(Sender: TObject);
    procedure DeleteProrataButtonClick(Sender: TObject);
    procedure PrintProrataButtonClick(Sender: TObject);
    procedure ProrataTableCalcFields(DataSet: TDataSet);
    procedure ProrataGridKeyPress(Sender: TObject; var Key: Char);
    procedure SetFocusTimerTimer(Sender: TObject);
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  public
    { public declarations }
    UnitName : String;  {For use with error dialog box.}

    EditMode : Char;  {A = Add; M = Modify; V = View}
    SwisSBLKey, TaxRollYr : String;

    FormIsInitializing : Boolean;  {Is the form being initialized right now?}
    FormAccessRights : Integer;  {Read only or read write, based on security level?}
                                {Values = raReadOnly, raReadWrite}

    Procedure InitializeForm;

  end;    {end form object definition}

implementation

uses GlblVars, PASTypes, WinUtils, PASUTILS, UTILEXSD,  Utilitys,
     GlblCnst, DataAccessUnit, PProrataSubformUnit, dlg_ProrataNewUnit;

{$R *.DFM}

{=====================================================================}
Procedure TProrataForm.CreateParams(var Params: TCreateParams);

begin
 inherited CreateParams(Params);

  with Params do
    begin
      WndParent := Application.Mainform.Handle;
      Style := (Style or WS_Child) and not WS_Popup;
    end;

end;  {CreateParams}

{====================================================================}
Procedure TProrataForm.InitializeForm;

var
  Found : Boolean;

begin
  UnitName := 'PProrata';  {mmm1}
  FormIsInitializing := True;

  If (Deblank(SwisSBLKey) <> '')
    then
      begin
          {If this is the history file, or they do not have read access,
           then we want to set the files to read only.}

        If not ModifyAccessAllowed(FormAccessRights)
          then ProrataTable.ReadOnly := True;

          {If this is inquire let's open it in
           readonly mode. Hist access is blocked at menu level}

        If (EditMode = 'V')
          then
            begin
              ProrataTable.ReadOnly := True;
              NewProrataButton.Enabled := False;
              DeleteProrataButton.Enabled := False;
            end;

        OpenTablesForForm(Self, GlblProcessingType);

          {First let's find this parcel in the parcel table.}

        Found := _Locate(ParcelTable, [TaxRollYr, SwisSBLKey], '', [loParseSwisSBLKey]);

        If not Found
          then SystemSupport(005, ParcelTable, 'Error finding key in parcel table.', UnitName, GlblErrorDlgBox);

        _SetRange(ProrataTable, [SwisSBLKey, ''], [SwisSBLKey, '9999'], '', []);

          {Also, set the title label to reflect the mode.
           We will then center it in the panel.}

        case EditMode of   {mmm5}
          'A',
          'M' : TitleLabel.Caption := 'Prorata Add\Modify';
          'V' : TitleLabel.Caption := 'Prorata View';
        end;  {case EditMode of}

        TitleLabel.Left := (Panel1.Width - TitleLabel.Width) DIV 2;

        If ProrataTable.ReadOnly
          then
            begin
              NewProrataButton.Enabled := False;
              DeleteProrataButton.Enabled := False;

            end;  {If ProrataTable.ReadOnly}

          {Set the location label.}

        EditLocation.Text := GetLegalAddressFromTable(ParcelTable);
        EditSBL.Text := ConvertSwisSBLToDashDot(SwisSBLKey);
        SetTaxYearLabelForProcessingType(YearLabel, GlblProcessingType);

          {FXX12101997-1: Make sure that all pages have the inactive label.}

        If (ParcelTable.FieldByName('ActiveFlag').Text = InactiveParcelFlag)
          then InactiveLabel.Visible := True;

        TFloatField(ProrataTable.FieldByName('TaxAmount')).DisplayFormat := DecimalDisplay;

      end;  {If (Deblank(SwisSBLKey) <> '')}

    {CHG11162004-7(2.8.0.21): Option to make the close button locate.}

  If GlblCloseButtonIsLocate
    then MakeCloseButtonLocate(CloseButton);

  FormIsInitializing := False;

  ProrataTable.Refresh;
  SetFocusTimer.Enabled := True;

end;  {InitializeForm}

{==============================================================}
Procedure TProrataForm.SetFocusTimerTimer(Sender: TObject);

begin
  SetFocusTimer.Enabled := False;
  ProrataGrid.SetFocus;
end;

{==============================================================}
Procedure TProrataForm.ProrataTableCalcFields(DataSet: TDataSet);

begin
  If not FormIsInitializing
    then
      with ProrataTable do
        begin
          _SetRange(ProrataDetailsTable,
                    [SwisSBLKey, FieldByName('ProrataYear').Text, FieldByName('Category').Text],
                    [], '', [loSameEndingRange]);

          FieldByName('TaxAmount').AsFloat := SumTableColumn(ProrataDetailsTable, 'TaxAmount');

        end;  {If not FormIsInitializing}

end;  {ProrataTableCalcFields}

{==============================================================}
Procedure TProrataForm.ProrataGridDblClick(Sender: TObject);

{Go to this Prorata in the subform.}

begin
  GlblDialogBoxShowing := True;

  try
    ProrataSubform := TProrataSubform.Create(nil);

    ProrataSubform.SwisSBLKey := ProrataTable.FieldByName('SwisSBLKey').Text;
    ProrataSubform.ProrataYear := ProrataTable.FieldByName('ProrataYear').Text;
    ProrataSubform.Category := ProrataTable.FieldByName('Category').Text;

      {FXX09282003-3(2.07j): Make sure that read only status is carried through
                            the Proratas.}

    If ProrataTable.ReadOnly
      then ProrataSubform.EditMode := 'V'
      else ProrataSubform.EditMode := EditMode;

    ProrataSubform.InitializeForm;

    ProrataSubform.ShowModal;

    ProrataTable.Refresh;

  finally
    ProrataSubform.Free;
  end;

  GlblDialogBoxShowing := False;

end;  {ProrataGridDblClick}

{==============================================================}
Procedure TProrataForm.ProrataGridKeyPress(    Sender: TObject;
                                           var Key: Char);

begin
  If (Key = #13)
    then ProrataGridDblClick(Sender);

end;  {ProrataGridKeyPress}

{==============================================================}
Procedure TProrataForm.NewProrataButtonClick(Sender: TObject);

var
  dlg_ProrataNew : Tdlg_ProrataNew;
  Continue : Boolean;

begin
  Continue := False;
  GlblDialogBoxShowing := True;
  dlg_ProrataNew := nil;

  try
    dlg_ProrataNew := Tdlg_ProrataNew.Create(nil);

    with dlg_ProrataNew do
      begin
        ProrataYear := GlblThisYear;

        If (ShowModal = idOK)
          then
            begin
              with ParcelTable do
                _InsertRecord(tb_ProrataLookup,
                              ['SwisSBLKey', 'ProrataYear', 'Name1', 'Name2',
                               'Address1', 'Address2', 'Street', 'City',
                               'State', 'Zip', 'ZipPlus4', 'CalculationDate',
                               'RemovalDate', 'SaleDate', 'SchoolCode', 'Category',
                               'ManualEntry'],
                              [SwisSBLKey, ProrataYear, FieldByName('Name1').Text, FieldByName('Name2').Text,
                               FieldByName('Address1').Text, FieldByName('Address2').Text, FieldByName('Street').Text, FieldByName('City').Text,
                               FieldByName('State').Text, FieldByName('Zip').Text, FieldByName('ZipPlus4').Text, DateToStr(CalculationDate),
                               DateToStr(RemovalDate), DateToStr(EffectiveDate), FieldByName('SchoolCode').Text, Category,
                               'True'], []);

              Continue := True;

            end;  {If (ShowModal = idOK)}

      end;  {with dlg_ProrataNew do}

  finally
    dlg_ProrataNew.Free;
  end;

  GlblDialogBoxShowing := False;

  If Continue
    then
      begin
        ProrataTable.GotoCurrent(tb_ProrataLookup);
        ProrataGridDblClick(nil);
      end;

end;  {NewProrataButtonClick}

{==============================================================}
Procedure TProrataForm.DeleteProrataButtonClick(Sender: TObject);

var
  ProrataYear, Category : String;

begin
  with ProrataTable do
    begin
      ProrataYear := FieldByName('ProrataYear').AsString;
      Category := FieldByName('Category').AsString;

      If (MessageDlg('Do you want to delete the prorata for ' + ProrataYear + '\' + Category + '?',
                     mtConfirmation, [mbYes, mbNo], 0) = idYes)
        then
          begin
            _SetRange(ProrataDetailsTable, [SwisSBLKey, ProrataYear, Category], [], '', [loSameEndingRange]);
            _SetRange(ProrataExemptionsTable, [SwisSBLKey, ProrataYear, Category], [], '', [loSameEndingRange]);
            DeleteTableRange(ProrataDetailsTable);
            DeleteTableRange(ProrataExemptionsTable);

            try
              Delete;
            except
            end;

            MessageDlg('The prorata for ' + ProrataYear + '\' + Category + ' has been deleted.',
                       mtInformation, [mbOK], 0);

          end;  {If (MessageDlg('Do you want to delete the prorata for ' ...}

    end;  {with ProrataTable do}

end;  {DeleteProrataButtonClick}

{==============================================================}
Procedure TProrataForm.PrintProrataButtonClick(Sender: TObject);

begin

end;  {PrintProrataButtonClick}

{==============================================================}
Procedure TProrataForm.CloseButtonClick(Sender: TObject);

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
Procedure TProrataForm.FormClose(    Sender: TObject;
                                    var Action: TCloseAction);

begin
    {Close all tables here.}

  CloseTablesForForm(Self);
  Action := caFree;

end;  {FormClose}


end.