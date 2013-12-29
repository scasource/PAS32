unit PSplitSchoolDistricts;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  StdCtrls, ExtCtrls, Forms, Dialogs, DB, Grids, DBGrids,
  DBTables, Mask, DBCtrls, Wwtable, Wwdatsrc, Wwdbcomb, Wwdbigrd, Wwdbgrid,
  Btrvdlg, Types, wwdblook, Buttons, ComCtrls;

type
  TfmSplitSchoolDistrictSBLs = class(TForm)
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
    tbParcels: TTable;
    Panel5: TPanel;
    lvSplitSchoolDistrictSBLs: TListView;
    Panel4: TPanel;
    CloseButton: TBitBtn;
    Panel3: TPanel;
    Label5: TLabel;
    Label7: TLabel;
    Label4: TLabel;
    EditName: TDBEdit;
    EditSBL: TMaskEdit;
    EditLocation: TEdit;
    tbAssessments: TTable;
    lbTotalLandAV: TLabel;
    lbTotalAV: TLabel;
    lbTotalAcreage: TLabel;

    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CloseButtonClick(Sender: TObject);

  protected
    procedure CreateParams(var Params: TCreateParams); override;
  public
    { public declarations }
    UnitName : String;  {For use with error dialog box.}

      {These will be set in the ParcelTabForm.}

    TaxRollYr : String;
    SwisSBLKey : String;

    FormAccessRights : Integer;
    Procedure InitializeForm;
    Procedure FillInSplitSchoolDistrictSBLsListView(sSplitSchoolDistrictGroup : String);

  end;    {end form object definition}

implementation

uses GlblVars, PASTypes, WinUtils, PASUTILS, Utilitys,
     GlblCnst, DataAccessUnit;


{$R *.DFM}

{=====================================================================}
Procedure TfmSplitSchoolDistrictSBLs.CreateParams(var Params: TCreateParams);

begin
 inherited CreateParams(Params);

  with Params do
    begin
      WndParent := Application.Mainform.Handle;
      Style := (Style or WS_Child) and not WS_Popup;
    end;

end;  {CreateParams}

{====================================================================}
Procedure TfmSplitSchoolDistrictSBLs.FillInSplitSchoolDistrictSBLsListView(sSplitSchoolDistrictGroup : String);

var
  sSwisSBLKey : String;
  iTotalLandAV, iTotalAV : LongInt;
  iTotalAcreage : Double;

begin
  iTotalLandAV := 0;
  iTotalAV := 0;
  iTotalAcreage := 0;

  with tbParcels do
    begin
      IndexName := 'BySplitSchool';
      _SetRange(tbParcels, [sSplitSchoolDistrictGroup], [], '', [loSameEndingRange]);
      First;

      while (not EOF) do
        begin
          sSwisSBLKey := ExtractSSKey(tbParcels);
          _Locate(tbAssessments, [TaxRollYr, sSwisSBLKey], '', []);

          FillInListViewRow(lvSplitSchoolDistrictSBLs,
                            [ConvertSwisSBLToDashDot(sSwisSBLKey),
                             FieldByName('SchoolCode').AsString,
                             FieldByName('Name1').AsString,
                             GetLegalAddressFromTable(tbParcels),
                             FormatFloat(_3DecimalDisplay, FieldByName('Acreage').AsFloat),
                             FormatFloat(IntegerDisplay, tbAssessments.FieldByName('LandAssessedVal').AsInteger),
                             FormatFloat(IntegerDisplay, tbAssessments.FieldByName('TotalAssessedVal').AsInteger)],
                            False);

          iTotalLandAV := iTotalLandAV + tbAssessments.FieldByName('LandAssessedVal').AsInteger;
          iTotalAV := iTotalAV + tbAssessments.FieldByName('TotalAssessedVal').AsInteger;
          iTotalAcreage := iTotalAcreage + FieldByName('Acreage').AsFloat;

          Next;

        end;  {while (not EOF) do}

    end;  {with tbParcels do}

  lbTotalLandAV.Caption := 'Total Land: ' + FormatFloat(IntegerDisplay, iTotalLandAV);
  lbTotalAV.Caption := 'Total AV: ' + FormatFloat(IntegerDisplay, iTotalAV);
  lbTotalAcreage.Caption := 'Total Acreage: ' + FormatFloat(_3DecimalDisplay, iTotalAcreage);

end;  {FillInSplitSchoolDistrictSBLsListView}

{====================================================================}
Procedure TfmSplitSchoolDistrictSBLs.InitializeForm;

var
  Found : Boolean;

begin
  UnitName := 'PSplitSchoolDistricts';

  If (Deblank(SwisSBLKey) <> '')
    then
      begin
        OpenTablesForForm(Self, GlblProcessingType);

        Found := _Locate(ParcelTable, [TaxRollYr, SwisSBLKey], '', [loParseSwisSBLKey]);

        If not Found
          then SystemSupport(001, ParcelTable, 'Error finding key in parcel table.', UnitName, GlblErrorDlgBox);

        TitleLabel.Left := (Panel1.Width - TitleLabel.Width) DIV 2;
        EditLocation.Text := GetLegalAddressFromTable(ParcelTable);
        EditSBL.Text := ConvertSwisSBLToDashDot(SwisSBLKey);

        FillInSplitSchoolDistrictSBLsListView(ParcelTable.FieldByName('SplitSchoolDistrictGroup').AsString);

      end;  {If (Deblank(SwisSBLKey) <> '')}

end;  {InitializeForm}

{===============================================================================}
Procedure TfmSplitSchoolDistrictSBLs.CloseButtonClick(Sender: TObject);

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
Procedure TfmSplitSchoolDistrictSBLs.FormClose(    Sender: TObject;
                                                var Action: TCloseAction);

begin
  CloseTablesForForm(Self);
  Action := caFree;

end;  {FormClose}

end.
