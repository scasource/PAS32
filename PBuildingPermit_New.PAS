unit PBuildingPermit_New;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  StdCtrls, ExtCtrls, Forms, Dialogs, DB, Grids, DBGrids,
  DBTables, Mask, DBCtrls, Wwtable, Wwdatsrc, Wwdbcomb, Wwdbigrd, Wwdbgrid,
  Btrvdlg, Types, wwdblook, Buttons, (*BseMain, BtrMain, *)ComCtrls, wwriched,
  wwrichedspell;

type
  TBuildingPermitNewForm = class(TForm)
    BigBuildingDataSource: TwwDataSource;
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
    PartialAssessmentLabel: TLabel;
    BigBuildingPermitTable: TTable;
    SmallBuildingPermitTable: TTable;
    SmallBuildingPermitDataSource: TDataSource;
    SetFocusTimer: TTimer;
    Panel3: TPanel;
    CloseButton: TBitBtn;
    Panel4: TPanel;
    Label5: TLabel;
    Label7: TLabel;
    Label4: TLabel;
    EditName: TDBEdit;
    EditSBL: TMaskEdit;
    EditLocation: TEdit;
    Panel5: TPanel;
    PermitNotebook: TNotebook;
    BigBuildingGrid: TwwDBGrid;
    SmallBuildingGrid: TwwDBGrid;

    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CloseButtonClick(Sender: TObject);
    procedure BigBuildingGridDblClick(Sender: TObject);
    procedure SmallBuildingGridDblClick(Sender: TObject);
    procedure BigBuildingGridKeyPress(Sender: TObject; var Key: Char);
    procedure SetFocusTimerTimer(Sender: TObject);
    procedure SmallBuildingGridKeyPress(Sender: TObject; var Key: Char);
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  public
    { public declarations }
    UnitName : String;  {For use with error dialog box.}
    SetFocusControl : TWinControl;

      {These will be set in the ParcelTabForm.}

    EditMode : Char;  {A = Add; M = Modify; V = View}
    TaxRollYr : String;
    SwisSBLKey : String;
    FormAccessRights : Integer;  {Read only or read write, based on security level?}
                                {Values = raReadOnly, raReadWrite}
    Procedure InitializeForm;

  end;    {end form object definition}

implementation

uses GlblVars, PASTypes, WinUtils, PASUTILS, UTILEXSD,  Utilitys,
     GlblCnst, DataAccessUnit,
     PBuildingPermit_New_Big_Subform,
     PBuildingPermit_New_Small_Subform;

{$R *.DFM}

{=====================================================================}
Procedure TBuildingPermitNewForm.CreateParams(var Params: TCreateParams);

begin
 inherited CreateParams(Params);

  with Params do
    begin
      WndParent := Application.Mainform.Handle;
      Style := (Style or WS_Child) and not WS_Popup;
    end;

end;  {CreateParams}

{=====================================================================}
Procedure TBuildingPermitNewForm.InitializeForm;

var
  Quit, _Found : Boolean;
  ProcessingType : Integer;
  TempSBL : String;

begin
  UnitName := 'PBuildingPermit_New';

  If (Deblank(SwisSBLKey) <> '')
    then
      begin
          {If this is the history file, or they do not have read access,
           then we want to set the files to read only.}

        If ((not ModifyAccessAllowed(FormAccessRights)) or
            (EditMode = 'V'))
          then
            begin
              BigBuildingPermitTable.ReadOnly := True;
              SmallBuildingPermitTable.ReadOnly := True;
            end;

          {First let's find this parcel in the parcel table.}
          {FXX03282000-1: Fix up building permit processing.}

        ProcessingType := GetProcessingTypeForTaxRollYear(TaxRollYr);

        OpenTableForProcessingType(ParcelTable, ParcelTableName,
                                   ProcessingType, Quit);

        _Found := _Locate(ParcelTable, [TaxRollYr, SwisSBLKey], '', [loParseSwisSBLKey]);

        If not _Found
          then SystemSupport(005, ParcelTable, 'Error finding key in parcel table.', UnitName, GlblErrorDlgBox);

        case GlblBuildingSystemLinkType of
          bldLargeBuilding :
            begin
              PermitNotebook.PageIndex := 0;
              SetFocusControl := BigBuildingGrid;

              with BigBuildingPermitTable do
                try
                  DatabaseName := GlblBuildingSystemDatabaseName;
                  TableName := GlblBuildingSystemTableName;
                  IndexName := GlblBuildingSystemIndexName;
                  Open;
                except
                  MessageDlg('Error opening table ' + GlblBuildingSystemTableName +
                             ' in database ' + GlblBuildingSystemDatabaseName +
                             ' for index ' + GlblBuildingSystemIndexName + '.',
                             mtError, [mbOK], 0);
                end;

                {FXX04262004-1(2.07l3): Convert back and forth between PAS and building in Glen Cove
                                        due to incompatibilities in the format.}

              If GlblUseGlenCoveFormatForCodeEnforcement
                then TempSBL := ConvertFrom_PAS_To_GlenCoveTax_Building_SBL(Copy(SwisSBLKey, 7, 20))
                else TempSBL := Copy(SwisSBLKey, 7, 20);

              If BigBuildingPermitTable.Active
                then SetRangeOld(BigBuildingPermitTable,
                                 ['SwisCode', 'SBL'],
                                 [Copy(SwisSBLKey, 1, 6), TempSBL],
                                 [Copy(SwisSBLKey, 1, 6), TempSBL]);

            end;  {bldLargeBuilding}

          bldSmallBuilding :
            begin
              PermitNotebook.PageIndex := 1;
              SetFocusControl := SmallBuildingGrid;

              with SmallBuildingPermitTable do
                try
                  DatabaseName := GlblBuildingSystemDatabaseName;
                  TableName := GlblBuildingSystemTableName;
                  IndexName := GlblBuildingSystemIndexName;
                  Open;
                except
                  MessageDlg('Error opening table ' + GlblBuildingSystemTableName +
                             ' in database ' + GlblBuildingSystemDatabaseName +
                             ' for index ' + GlblBuildingSystemIndexName + '.',
                             mtError, [mbOK], 0);
                end;

              SetRangeOld(SmallBuildingPermitTable, ['SwisSBLKey'], [SwisSBLKey], [SwisSBLKey]);

            end;  {bldSmallBuilding}

        end;  {case GlblBuildingSystemLinkType of}

        EditLocation.Text := GetLegalAddressFromTable(ParcelTable);

        YearLabel.Caption := GetTaxYrLbl;

        EditSBL.Text := ConvertSwisSBLToDashDot(SwisSBLKey);
        SetFocusTimer.Enabled := True;

      end;  {If (Deblank(SwisSBLKey) <> '')}

end;  {InitializeForm}

{====================================================================}
Procedure TBuildingPermitNewForm.SetFocusTimerTimer(Sender: TObject);

begin
  SetFocusTimer.Enabled := False;

  try
    SetFocusControl.SetFocus;
  except
  end;

end;  {SetFocusTimerTimer}

{====================================================================}
Procedure TBuildingPermitNewForm.BigBuildingGridKeyPress(    Sender: TObject;
                                                         var Key: Char);

begin
  If (Key = #13)
    then BigBuildingGridDblClick(Sender);

end;  {BigBuildingGridKeyPress}

{==============================================================}
Procedure TBuildingPermitNewForm.BigBuildingGridDblClick(Sender: TObject);

begin
  try
    BigBuildingPermitSubform := TBigBuildingPermitSubform.Create(Application);

    with BigBuildingPermitTable do
      BigBuildingPermitSubform.InitializeForm(FieldByName('PermitType').Text,
                                              FieldByName('ApplicaNo').Text, EditMode);
    BigBuildingPermitSubform.ShowModal;

  finally
    BigBuildingPermitSubform.Free;
  end;

  BigBuildingPermitTable.Refresh;

end;  {BigBuildingGridDblClick}

{==============================================================}
Procedure TBuildingPermitNewForm.SmallBuildingGridKeyPress(    Sender: TObject;
                                                           var Key: Char);

begin
  If (Key = #13)
    then SmallBuildingGridDblClick(Sender);

end;  {SmallBuildingGridKeyPress}

{==============================================================}
Procedure TBuildingPermitNewForm.SmallBuildingGridDblClick(Sender: TObject);

begin
  try
    SmallBuildingPermitSubform := TSmallBuildingPermitSubform.Create(Application);
    SmallBuildingPermitSubform.InitializeForm(SmallBuildingPermitTable.FieldByName('PermitNo').Text, EditMode);
    SmallBuildingPermitSubform.ShowModal;

  finally
    SmallBuildingPermitSubform.Free;
  end;

  SmallBuildingPermitTable.Refresh;

end;  {SmallBuildingGridDblClick}

{==============================================================}
Procedure TBuildingPermitNewForm.CloseButtonClick(Sender: TObject);

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
Procedure TBuildingPermitNewForm.FormClose(    Sender: TObject;
                                    var Action: TCloseAction);

begin
  CloseTablesForForm(Self);
  Action := caFree;
end;  {FormClose}

end.