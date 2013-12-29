Unit Presimpr;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  StdCtrls, ExtCtrls, Forms, Dialogs, DB, Grids, DBGrids,
  DBTables, Mask, DBCtrls, Wwtable, Wwdatsrc, Wwdbcomb, Wwdbigrd, Wwdbgrid,
  Btrvdlg, Types, wwdblook, Buttons;

type
  TParcelResidentialImprovementsForm = class(TForm)
    MainDataSource: TwwDataSource;
    MainTable: TwwTable;
    Panel1: TPanel;
    TitleLabel: TLabel;
    Panel2: TPanel;
    ScrollBox: TScrollBox;
    ParcelDataSource: TDataSource;
    ParcelTable: TTable;
    YearLabel: TLabel;
    ResidentialSiteTable: TTable;
    ResidentialSiteDataSource: TDataSource;
    InactiveLabel: TLabel;
    OppositeYearResImprovementTable: TTable;
    Label41: TLabel;
    Label44: TLabel;
    TotalAVLabel: TLabel;
    LandAVLabel: TLabel;
    Label6: TLabel;
    AssessmentYearControlTable: TTable;
    OldParcelIDLabel: TLabel;
    PartialAssessmentLabel: TLabel;
    Panel3: TPanel;
    NewImprovementButton: TBitBtn;
    DeleteImprovementButton: TBitBtn;
    CloseButton: TBitBtn;
    Panel4: TPanel;
    Label4: TLabel;
    Label7: TLabel;
    Label21: TLabel;
    SaleNumberLabel: TLabel;
    Label5: TLabel;
    Label3: TLabel;
    Label33: TLabel;
    Label29: TLabel;
    Label30: TLabel;
    EditSBL: TMaskEdit;
    EditLocation: TEdit;
    EditSalesNumber: TEdit;
    EditName: TDBEdit;
    EditLastChangeDate: TDBEdit;
    EditLastChangeByName: TDBEdit;
    EditNumResSites: TEdit;
    EditNumComSites: TEdit;
    EditSite: TEdit;
    Panel5: TPanel;
    Grid: TwwDBGrid;

    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure GridDblClick(Sender: TObject);
    procedure CloseButtonClick(Sender: TObject);
    procedure NewImprovementButtonClick(Sender: TObject);
    procedure DeleteImprovementButtonClick(Sender: TObject);

  protected
    procedure CreateParams(var Params: TCreateParams); override;
  public
    { public declarations }
    UnitName : String;  {For use with error dialog box.}

      {These will be set in the ParcelTabForm.}

    EditMode : Char;  {A = Add; M = Modify; V = View}
    OppositeTaxYear, TaxRollYr, SwisSBLKey : String;
    SalesNumber : Integer;  {What sales number are we on - only for use if Processing Type = SalesInv.}
    Site : Integer; {What site are we on?}
    OppositeProcessingType, ProcessingType : Integer;  {NextYear, ThisYear, History, SalesInventory}
    NumResSites,
    NumComSites : Integer;  {Number of commercial and residential sites for this
                             parcel.}

    FormIsInitializing : Boolean;  {Are we initializing the form?}
    ClosingForm : Boolean;  {Are we closing a form right now?}
    ParcelChanged, OppositeYearParcelChanged : Boolean;
    FormAccessRights : Integer;  {Read only or read write, based on security level?}
                                {Values = raReadOnly, raReadWrite}

    Procedure InitializeForm;
    Procedure SetRangeForTable(Table : TTable);

  end;    {end form object definition}


implementation

uses GlblVars, PASTypes, WinUtils, PASUTILS, Utilitys,
     PRESIMPS, DataAccessUnit, GlblCnst;

{$R *.DFM}

{=====================================================================}
Procedure TParcelResidentialImprovementsForm.CreateParams(var Params: TCreateParams);

begin
 inherited CreateParams(Params);

  with Params do
    begin
      WndParent := Application.Mainform.Handle;
      Style := (Style or WS_Child) and not WS_Popup;
    end;

end;  {CreateParams}

{========================================================================}
Procedure TParcelResidentialImprovementsForm.SetRangeForTable(Table : TTable);

{Now set the range on this table so that it is sychronized to this parcel. Note
 that all segments of the key must be set.}
{For residential improvements the key is Taxyear\SwisSBL\Site\YearBuilt.}

begin
  Table.CancelRange;
  try
    If (ProcessingType = SalesInventory)
      then SetRangeOld(Table,
                       ['SwisSBLKey', 'SalesNumber', 'Site',
                        'ImprovementNumber'],
                       [SwisSBLKey, IntToStr(SalesNumber), IntToStr(Site), '0'],
                       [SwisSBLKey, IntToStr(SalesNumber), IntToStr(Site), '32000'])
      else SetRangeOld(Table,
                       ['TaxRollYr', 'SwisSBLKey', 'Site',
                        'ImprovementNumber'],
                       [TaxRollYr, SwisSBLKey, IntToStr(Site), '0'],
                       [TaxRollYr, SwisSBLKey, IntToStr(Site), '32000']);
  except
    SystemSupport(001, Table, 'Error setting range in ' + Table.Name, UnitName, GlblErrorDlgBox);
  end;

end;  {SetRangeForTable}

{====================================================================}
Procedure TParcelResidentialImprovementsForm.InitializeForm;

{This procedure opens the tables for this form and synchronizes
 them to this parcel. Also, we set the title and year
 labels.

 Note that this code is in this seperate procedure rather
 than any of the OnShow events so that we could have
 complete control over when this procedure is run.
 The problem with any of the OnShow events is that when
 the form is created, they are called, but it is not possible to
 have the SwisSBLKey, etc. set.
 This way, we can call InitializeForm after we know that
 the SwisSBLKey, etc. has been set.}

var
  Quit : Boolean;

begin
  UnitName := 'PRESIMPR.PAS';  {mmm1}
  ParcelChanged := False;
  OppositeYearParcelChanged := False;
  ClosingForm := False;
  FormIsInitializing := True;
  ParcelChanged := False;
  OppositeYearParcelChanged := False;

  If (Deblank(SwisSBLKey) <> '')
    then
      begin
          {If this is the history file, or they do not have read access,
           then we want to set the files to read only.}

        If not ModifyAccessAllowed(FormAccessRights)
          then MainTable.ReadOnly := True;

            {If this is inquire mode or the processing type is not the the
             main (i.e. Glbl Tax Year), let's open it in
             readonly mode.}

          {CHG06302012-1(2.28.4.33)[PAS-412]:  Allow for sales inventory editing.}

        If not MainTable.ReadOnly
        then MainTable.ReadOnly := not DetermineEditStatusForInventoryForm(EditMode, ProcessingType, GlblTaxYearFlg, glblAllowSalesInventoryEdit);

          {If this is sales inventory, then let's set the index to include the
           sales number. Otherwise, let's do the index without the sales number.}

        If (ProcessingType = SalesInventory)
          then MainTable.IndexName := 'BYSBL_SALENO_SITE_IMPNO'
          else MainTable.IndexName := 'BYTAXROLLYR_SBL_SITE_IMPNO';

          {There are so many tables on this form, we will
           set the table name and open them implicitly.
           OpenTablesForForm is a method in PASUTILS.}

        OpenTablesForForm(Self, ProcessingType);

        If not _Locate(ParcelTable, [TaxRollYr, SwisSBLKey], '', [loParseSwisSBLKey])
          then SystemSupport(005, ParcelTable, 'Error finding key in parcel table.', UnitName, GlblErrorDlgBox);

        SetRangeForTable(MainTable);  {This is a method that we have written to avoid having two copies of the setrange.}

        _Locate(ResidentialSiteTable, [TaxRollYr, SwisSBLKey, Site], '', []);

        TitleLabel.Caption := 'Res Improvement';
        TitleLabel.Left := (Panel1.Width - TitleLabel.Width) DIV 2;

        If MainTable.ReadOnly
          then
            begin
              NewImprovementButton.Enabled := False;
              DeleteImprovementButton.Enabled := False;

            end;  {If MainTable.ReadOnly}

        EditLocation.Text := GetLegalAddressFromTable(ParcelTable);
        SetTaxYearLabelForProcessingType(YearLabel, ProcessingType);
        EditSBL.Text := ConvertSwisSBLToDashDot(SwisSBLKey);

          {We will fill in the site manually rather than based on the improvement table because
           if we did it base on the improvement table, they would not be able to see the site
           until they inserted the first record.}

        EditSite.Text := IntToStr(Site);
        EditNumResSites.Text := IntToStr(NumResSites);
        EditNumComSites.Text := IntToStr(NumComSites);

        SetDisplayFormatForCurrencyFields(Self, False);

          {If this is sales inventory, then let's fill in the sales number edit.
           Otherwise, we will hide the sales edit and label.}

        If (ProcessingType = SalesInventory)
          then EditSalesNumber.Text := IntToStr(SalesNumber)
          else
            begin
              SaleNumberLabel.Visible := False;
              EditSalesNumber.Visible := False;
            end;

        If (ParcelTable.FieldByName('ActiveFlag').Text = InactiveParcelFlag)
          then InactiveLabel.Visible := True;

          {CHG10281997-1: Continue the dual mode processing work.}

        If (ProcessingType = ThisYear)
          then OppositeProcessingType := NextYear
          else OppositeProcessingType := ThisYear;

        OppositeTaxYear := GetTaxRollYearForProcessingType(OppositeProcessingType);

        OpenTableForProcessingType(OppositeYearResImprovementTable,
                                   ResidentialImprovementsTableName,
                                   OppositeProcessingType, Quit);

        If GlblLocateByOldParcelID
          then SetOldParcelIDLabel(OldParcelIDLabel, ParcelTable,
                                   AssessmentYearControlTable);

      end;  {If (Deblank(SwisSBLKey) <> '')}

    {CHG11162004-7(2.8.0.21): Option to make the close button locate.}

  If GlblCloseButtonIsLocate
    then MakeCloseButtonLocate(CloseButton);

  FormIsInitializing := False;

end;  {InitializeForm}

{==============================================================}
Procedure TParcelResidentialImprovementsForm.NewImprovementButtonClick(Sender: TObject);

var
  ResidentialImprovementsSubform : TResidentialImprovementsSubform;
  Quit : Boolean;

begin
  ResidentialImprovementsSubform := nil;
  If _Compare(TWinControl(Sender).Name, 'NewImprovementButton', coEqual)
    then EditMode := emInsert
    else
      If MainTable.ReadOnly
        then EditMode := emBrowse
        else EditMode := emEdit;

  try
    GlblDialogBoxShowing := True;

    ResidentialImprovementsSubform := TResidentialImprovementsSubform.Create(nil);

    with ResidentialImprovementsSubform do
      begin
        ProcessingType := Self.ProcessingType;
        SwisSBLKey := Self.SwisSBLKey;
        FormAccessRights := Self.FormAccessRights;
        Site := Self.Site;
        ImprovementNumber := Self.MainTable.FieldByName('ImprovementNumber').AsInteger;
        TaxRollYr := Self.TaxRollYr;
        SalesNumber := Self.SalesNumber;
        MainCaption := Self.Caption;
        EditMode := Self.EditMode;

        InitializeForm;

        ShowModal;
        Self.ParcelChanged := ParcelChanged;
        Self.OppositeYearParcelChanged := OppositeYearParcelChanged;

      end;  {with ResidentialImprovementsSubform do}

    finally
      ResidentialImprovementsSubform.Free;
    end;

  GlblDialogBoxShowing := False;

  If (ParcelChanged and
      (ProcessingType <> SalesInventory))
    then
      begin
        MarkRecChanged(ParcelTable, UnitName);
        MarkRecChanged(ResidentialSiteTable, UnitName);

      end;  {If ParcelChanged}

    {CHG10281997-1: Continue the dual mode processing work.}

  If OppositeYearParcelChanged
    then
      begin
          {Close the parcel and site table and reopen them for the
           opposite year.}

        ParcelTable.Close;
        ResidentialSiteTable.Close;

        OpenTableForProcessingType(ParcelTable, ParcelTableName,
                                   OppositeProcessingType, Quit);

        OpenTableForProcessingType(ResidentialSiteTable, ResidentialSiteTableName,
                                   OppositeProcessingType, Quit);

        If _Locate(ParcelTable, [OppositeTaxYear, SwisSBLKey], '', [loParseSwisSBLKey])
          then MarkRecChanged(ParcelTable, UnitName);

        If _Locate(ResidentialSiteTable, [OppositeTaxYear, SwisSBLKey, Site], '', [])
          then MarkRecChanged(ResidentialSiteTable, UnitName);

      end;  {If OppositeYearParcelChanged}

    {FXX12162004-1(2.8.1.3)[2024]: The grid was displaying all fields after
                                   closing and reopening main table.
                                   Just refresh it instead.}

  MainTable.Refresh;

end;  {NewImprovementButtonClick}

{================================================================}
Procedure TParcelResidentialImprovementsForm.DeleteImprovementButtonClick(Sender: TObject);

var
  DeletedSiteNum,
  DeletedImprovementNum : Integer;

begin
  DeletedSiteNum := MainTable.FieldByName('Site').AsInteger;
  DeletedImprovementNum := MainTable.FieldByName('ImprovementNumber').AsInteger;

  If (MessageDlg('Are you sure you want to delete improvement number ' +
                 IntToStr(DeletedImprovementNum) + '?', mtConfirmation, [mbYes, mbNo], 0) = idYes)
    then
      begin
        try
          MainTable.Delete;
        except
        end;

        If (GlblModifyBothYears and
            _Locate(OppositeYearResImprovementTable,
                    [OppositeTaxYear, SwisSBLKey, DeletedSiteNum, DeletedImprovementNum], '', []))
          then
            try
              OppositeYearResImprovementTable.Delete;
            except

            end;  {If GlblModifyBothYears}

      end;  {If (MessageDlg('Are you sure ...}

end;  {DeleteImprovementButtonClick}

{==============================================================}
Procedure TParcelResidentialImprovementsForm.GridDblClick(Sender: TObject);

begin
  NewImprovementButtonClick(Sender);
end;  {GridDblClick}

{==============================================================}
Procedure TParcelResidentialImprovementsForm.CloseButtonClick(Sender: TObject);

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
Procedure TParcelResidentialImprovementsForm.FormClose(    Sender: TObject;
                                                       var Action: TCloseAction);

begin
  CloseTablesForForm(Self);

  Action := caFree;

end;  {FormClose}

end.