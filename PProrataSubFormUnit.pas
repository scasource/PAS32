unit PProrataSubFormUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Mask, DBCtrls, Grids, Wwdbigrd, Wwdbgrid, Buttons, ExtCtrls,
  ComCtrls, Db, Wwdatsrc, DBTables, Wwtable;

type
  TProrataSubform = class(TForm)
    ProrataDetailPageControl: TPageControl;
    GeneralInformationTabSheet: TTabSheet;
    DetailsTabSheet: TTabSheet;
    Panel1: TPanel;
    Panel3: TPanel;
    NewDetailButton: TBitBtn;
    DeleteDetailButton: TBitBtn;
    Panel4: TPanel;
    ProrataDetailsGrid: TwwDBGrid;
    Panel2: TPanel;
    OwnerGroupBox: TGroupBox;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    SwisLabel: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label28: TLabel;
    EditName: TDBEdit;
    EditName2: TDBEdit;
    EditAddress: TDBEdit;
    EditAddress2: TDBEdit;
    EditStreet: TDBEdit;
    EditCity: TDBEdit;
    EditState: TDBEdit;
    EditZip: TDBEdit;
    EditZipPlus4: TDBEdit;
    Panel5: TPanel;
    Panel6: TPanel;
    Panel7: TPanel;
    ProrataExemptionGrid: TwwDBGrid;
    Label1: TLabel;
    NewExemptionButton: TBitBtn;
    DeleteExemptionButton: TBitBtn;
    ProrataHeaderTable: TwwTable;
    ProrataDetailsTable: TwwTable;
    ProrataExemptionsTable: TwwTable;
    ProrataHeaderDataSource: TwwDataSource;
    ProrataDetailsDataSource: TwwDataSource;
    ProrataExemptionsDataSource: TwwDataSource;
    ProrataInformationGroupBox: TGroupBox;
    Label2: TLabel;
    EditSalesDate: TDBEdit;
    Label3: TLabel;
    EditCalculationDate: TDBEdit;
    Label4: TLabel;
    EditRemovalDate: TDBEdit;
    tb_ProrataDetailsLookup: TwwTable;
    tb_ProrataExemptionsLookup: TwwTable;
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure DeleteExemptionButtonClick(Sender: TObject);
    procedure NewExemptionButtonClick(Sender: TObject);
    procedure DeleteDetailButtonClick(Sender: TObject);
    procedure NewDetailButtonClick(Sender: TObject);
    procedure ProrataExemptionGridDblClick(Sender: TObject);
    procedure ProrataDetailsGridDblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    InitializingForm : Boolean;
    ProrataYear, SwisSBLKey, Category, UnitName, EditMode : String;
    Procedure InitializeForm;
    Procedure FillInDaysStringGrid;
    Procedure LoadProrataInformation;
  end;

var
  ProrataSubform: TProrataSubform;

implementation

{$R *.DFM}

uses PASUtils, WinUtils, Utilitys, DataAccessUnit, PASTypes, GlblVars, GlblCnst,
     dlg_ProrataNewExemptionUnit, dlg_ProrataNewDetailUnit;

{==================================================================}
Procedure TProrataSubform.FillInDaysStringGrid;

begin
end;  {FillInDaysStringGrid}

{==================================================================}
Procedure TProrataSubform.LoadProrataInformation;

begin
  _SetRange(ProrataDetailsTable,
            [SwisSBLKey, ProrataYear, Category, '', ''],
            [SwisSBLKey, ProrataYear, Category, 'zzzz', ''], '', []);

  _SetRange(ProrataExemptionsTable,
            [SwisSBLKey, ProrataYear, Category, '', ''],
            [SwisSBLKey, ProrataYear, Category, '9999', ''], '', []);

  FillInDaysStringGrid;

end;  {LoadProrataInformation}

{==================================================================}
Procedure TProrataSubform.InitializeForm;

begin
  WindowState := Application.MainForm.WindowState;

  InitializingForm := True;
  UnitName := 'PProrataSubform';
  ProrataDetailPageControl.ActivePage := GeneralInformationTabSheet;

  If (EditMode = 'V')
    then
      begin
        ProrataHeaderTable.ReadOnly := True;
        ProrataDetailsTable.ReadOnly := True;
        ProrataExemptionsTable.ReadOnly := True;
        NewDetailButton.Enabled := False;
        DeleteExemptionButton.Enabled := False;
        NewDetailButton.Enabled := False;
        DeleteDetailButton.Enabled := False;

      end;  {If (EditMode = 'V')}

  OpenTablesForForm(Self, GlblProcessingType);

  If not _Locate(ProrataHeaderTable, [SwisSBLKey, ProrataYear], '', [])
    then SystemSupport(001, ProrataHeaderTable,
                       'Error finding prorata ' + ProrataYear + '\' +
                       SwisSBLKey + '.',
                       UnitName, GlblErrorDlgBox);

  Caption := 'Prorata Details for parcel ' +
             ConvertSwisSBLToDashDot(SwisSBLKey) + ' \ ' + ProrataYear;

  LoadProrataInformation;
  InitializingForm := False;

end;  {InitializeForm}

{================================================================}
Procedure TProrataSubform.FormKeyPress(    Sender: TObject;
                                       var Key: Char);

begin
  If (Key = #13)
    then
      begin
        Perform(WM_NextDlgCtl, 0, 0);
        Key := #0;
      end;  {If (Key = #13)}

end;  {FormKeyPress}

{============================================================================}
Procedure TProrataSubform.NewExemptionButtonClick(Sender: TObject);

var
  dlg_ProrataNewExemption : Tdlg_ProrataNewExemption;

begin
  GlblDialogBoxShowing := True;
  dlg_ProrataNewExemption := nil;

  try
    dlg_ProrataNewExemption := Tdlg_ProrataNewExemption.Create(nil);

    with dlg_ProrataNewExemption do
      begin
        EditMode := emInsert;

        If (ShowModal = idOK)
          then
            begin
              _InsertRecord(tb_ProrataExemptionsLookup,
                            ['SwisSBLKey', 'ProrataYear', 'Category', 'TaxRollYr',
                             'ExemptionCode', 'HomesteadCode', 'CountyAmount', 'TownAmount',
                             'SchoolAmount'],
                            [SwisSBLKey, ProrataYear, Category, RollYear,
                             ExemptionCode, HomesteadCode, CountyAmount, MunicipalAmount,
                             SchoolAmount], []);

              LoadProrataInformation;

            end;  {If (ShowModal = idOK)}

      end;  {with dlg_ProrataNewExemption do}

  finally
    dlg_ProrataNewExemption.Free;
  end;

  GlblDialogBoxShowing := False;

end;  {NewExemptionButtonClick}

{============================================================================}Procedure TProrataSubform.ProrataExemptionGridDblClick(Sender: TObject);

var
  dlg_ProrataNewExemption : Tdlg_ProrataNewExemption;

begin
  GlblDialogBoxShowing := True;
  dlg_ProrataNewExemption := nil;

  If not ProrataHeaderTable.ReadOnly
    then
      If _Compare(ProrataExemptionsTable.RecordCount, 0, coEqual)
        then NewExemptionButtonClick(nil)
        else
          try
            dlg_ProrataNewExemption := Tdlg_ProrataNewExemption.Create(nil);

            tb_ProrataExemptionsLookup.GotoCurrent(ProrataExemptionsTable);

            with dlg_ProrataNewExemption, tb_ProrataExemptionsLookup do
              begin
                EditMode := emEdit;
                RollYear := FieldByName('TaxRollYr').AsString;
                ExemptionCode := FieldByName('ExemptionCode').AsString;
                HomesteadCode := FieldByName('HomesteadCode').AsString;
                CountyAmount := FieldByName('CountyAmount').AsInteger;
                MunicipalAmount := FieldByName('TownAmount').AsInteger;
                SchoolAmount := FieldByName('SchoolAmount').AsInteger;

                If (ShowModal = idOK)
                  then
                    begin
                      _UpdateRecord(tb_ProrataExemptionsLookup,
                                    ['ExemptionCode', 'HomesteadCode', 'CountyAmount', 'TownAmount',
                                     'SchoolAmount'],
                                    [ExemptionCode, HomesteadCode, CountyAmount, MunicipalAmount,
                                     SchoolAmount], []);

                      LoadProrataInformation;

                    end;  {If (ShowModal = idOK)}

              end;  {with dlg_ProrataNewExemption do}

          finally
            dlg_ProrataNewExemption.Free;
          end;

  GlblDialogBoxShowing := False;

end;  {ProrataExemptionGridDblClick}

{============================================================================}
Procedure TProrataSubform.DeleteExemptionButtonClick(Sender: TObject);

begin
  with ProrataExemptionsTable do
    If (MessageDlg('Are you sure you want to delete prorated exemption ' +
                   FieldByName('ExemptionCode').AsString + '?',
                   mtConfirmation, [mbYes, mbNo], 0) = idYes)
      then
        try
          Delete;
          LoadProrataInformation;
        except
        end;

end;  {DeleteExemptionButtonClick}

{============================================================================}
Procedure TProrataSubform.NewDetailButtonClick(Sender: TObject);

var
  dlg_ProrataNewDetail : Tdlg_ProrataNewDetail;

begin
  GlblDialogBoxShowing := True;
  dlg_ProrataNewDetail := nil;

  try
    dlg_ProrataNewDetail := Tdlg_ProrataNewDetail.Create(nil);

    with dlg_ProrataNewDetail do
      begin
        EditMode := emInsert;

        If (ShowModal = idOK)
          then
            begin
              _InsertRecord(tb_ProrataDetailsLookup,
                            ['SwisSBLKey', 'ProrataYear', 'Category', 'TaxRollYr',
                             'GeneralTaxType', 'LevyDescription', 'HomesteadCode', 'Days',
                             'TaxRate', 'ExemptionAmount', 'TaxAmount'],
                            [SwisSBLKey, ProrataYear, Category, RollYear,
                             GeneralTaxType, LevyDescription, HomesteadCode, Days,
                             TaxRate, ExemptionAmount, TaxAmount], []);

              LoadProrataInformation;

            end;  {If (ShowModal = idOK)}

      end;  {with dlg_ProrataNewDetail do}

  finally
    dlg_ProrataNewDetail.Free;
  end;

  GlblDialogBoxShowing := False;

end;  {NewDetailButtonClick}

{============================================================================}
Procedure TProrataSubform.ProrataDetailsGridDblClick(Sender: TObject);

var
  dlg_ProrataNewDetail : Tdlg_ProrataNewDetail;

begin
  GlblDialogBoxShowing := True;
  dlg_ProrataNewDetail := nil;

  If not ProrataHeaderTable.ReadOnly
    then
      If _Compare(ProrataDetailsTable.RecordCount, 0, coEqual)
        then NewDetailButtonClick(nil)
        else
          try
            dlg_ProrataNewDetail := Tdlg_ProrataNewDetail.Create(nil);
            tb_ProrataDetailsLookup.GotoCurrent(ProrataDetailsTable);

            with dlg_ProrataNewDetail, tb_ProrataDetailsLookup do
              begin
                EditMode := emEdit;

                RollYear := FieldByName('TaxRollYr').AsString;
                GeneralTaxType := FieldByName('GeneralTaxType').AsString;
                LevyDescription := FieldByName('LevyDescription').AsString;
                HomesteadCode := FieldByName('HomesteadCode').AsString;
                Days := FieldByName('Days').AsInteger;
                TaxRate := FieldByName('TaxRate').AsFloat;
                ExemptionAmount := FieldByName('ExemptionAmount').AsInteger;
                TaxAmount := FieldByName('TaxAmount').AsFloat;

                If (ShowModal = idOK)
                  then
                    begin
                      _UpdateRecord(tb_ProrataDetailsLookup,
                                    ['GeneralTaxType', 'LevyDescription', 'HomesteadCode', 'Days',
                                     'TaxRate', 'ExemptionAmount', 'TaxAmount'],
                                    [GeneralTaxType, LevyDescription, HomesteadCode, Days,
                                     TaxRate, ExemptionAmount, TaxAmount], []);

                      LoadProrataInformation;

                    end;  {If (ShowModal = idOK)}

              end;  {with dlg_ProrataNewDetail do}

          finally
            dlg_ProrataNewDetail.Free;
          end;

  GlblDialogBoxShowing := False;

end;  {ProrataDetailsGridDblClick}

{============================================================================}
Procedure TProrataSubform.DeleteDetailButtonClick(Sender: TObject);

begin
  with ProrataDetailsTable do
    If (MessageDlg('Are you sure you want to delete prorated detail ' +
                   FieldByName('ProrataYear').AsString + '\' +
                   FieldByName('LevyDescription').AsString + '?',
                   mtConfirmation, [mbYes, mbNo], 0) = idYes)
      then
        try
          Delete;
          LoadProrataInformation;
        except
        end;

end;  {DeleteDetailButtonClick}

{============================================================================}
Procedure TProrataSubform.FormClose(    Sender: TObject;
                                    var Action: TCloseAction);

begin
  CloseTablesForForm(Self);
end;

end.
