unit Asofcmnt;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, ExtCtrls, Menus, Mask, DBCtrls,
  Wwkeycb, DB, DBTables, Wwtable, Wwdatsrc, Printrng, Btrvdlg, Grids,
  DBGrids, DBLookup, RPBase, RPCanvas, RPrinter, Wwdbigrd, Wwdbgrid,
  TabNotBk, RPFiler, DBIProcs, RPDefine;

type
  TAssessorOfficeMaintForm = class(TForm)
    ScrollBox1: TScrollBox;
    Panel1: TPanel;
    TitleLabel: TLabel;
    MainDataSource: TDataSource;
    Panel2: TPanel;
    SaveButton: TBitBtn;
    ExitButton: TBitBtn;
    CancelButton: TBitBtn;
    MainTable: TTable;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    FaxDBEdit: TDBEdit;
    Label10: TLabel;
    InterNetDBEdit: TDBEdit;
    Label11: TLabel;
    MunCodeEdit: TDBEdit;
    Label12: TLabel;
    ZipDBEdit: TDBEdit;
    Address2DBEdit: TDBEdit;
    Address1DBEdit: TDBEdit;
    AssessorNameDBEdit: TDBEdit;
    TitleDBEdit: TDBEdit;
    MunNameDBEdit: TDBEdit;
    Address3DBEdit: TDBEdit;
    CityDBEdit: TDBEdit;
    StateDBEdit: TDBEdit;
    PhoneDBEdit: TDBEdit;
    Label13: TLabel;
    LetterheadHeightEdit: TDBEdit;
    Label14: TLabel;
    EnvelopeWindowHeightEdit: TDBEdit;
    Label15: TLabel;
    Label16: TLabel;
    LetterLeftMarginEdit: TDBEdit;
    Label17: TLabel;
    EditLinesLeftDotMatrix: TDBEdit;
    Label18: TLabel;
    EditLinesLeftLaserJet: TDBEdit;
    Label19: TLabel;
    Label20: TLabel;
    EditMunicipalAttorney: TDBEdit;
    Label21: TLabel;
    EditReprintLeftMargin: TDBEdit;
    procedure SaveButtonClick(Sender: TObject);
    procedure ExitButtonClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure CancelButtonClick(Sender: TObject);
    procedure MainTableAfterPost(DataSet: TDataset);
    procedure FormActivate(Sender: TObject);

  private
    UnitName : String; {For error dialog box}
  public
    FormAccessRights : Integer; {Read only or read write, based on security level?}
                                {Values = raReadOnly, raReadWrite}
    Procedure InitializeForm;
  end;

implementation

{$R *.DFM}

uses
  Preview,   {Print preview form}
  Types,     {Constants, types}
  Utilitys,  {General utilities}
  GlblVars,  {Global variables}
  GlblCnst,
  PASUTILS, UTILEXSD,   {PAS specific utilites}
  WinUtils;  {Windows specific utilities}


{======================================================================}
Procedure TAssessorOfficeMaintForm.FormActivate(Sender: TObject);

begin
  SetFormStateMaximized(Self);
end;

{======================================================================}
Procedure TAssessorOfficeMaintForm.InitializeForm;

{Open the tables.}

begin
  UnitName := 'ASOFCMNT.PAS';  {mmm}

  If not ModifyAccessAllowed(FormAccessRights)
    then
      begin
        MainTable.ReadOnly := True;
        SaveButton.Enabled := False;

      end;  {If (GlblTaxYearFlg = 'History')}

    {Open the main table.}

  OpenTablesForForm(Self, GlblProcessingType);

    {If for some reason there is no assessment year yet, let's insert it now.
     This should really only happen while we are testing.}

  If ((MainTable.RecordCount = 0) and
      (not MainTable.ReadOnly))
    then MainTable.Insert;

    {FXX05041999-2: Set display format for real fields.}

  TFloatField(MainTable.FieldByName('LetterheadHeight')).DisplayFormat := DecimalDisplay_BlankZero;
  TFloatField(MainTable.FieldByName('EnvWindowHeight')).DisplayFormat := DecimalDisplay_BlankZero;

end;  {InitializeForm}

{===================================================================}
Procedure TAssessorOfficeMaintForm.FormKeyPress(Sender: TObject;
                                        var Key: Char);

{Change carriage return into tab.}

begin
 If (Key = #13)
    then
      begin
        If (NOT (Screen.ActiveControl is TDBMemo))
          then
          begin
          Perform(WM_NextDlgCtl, 0, 0);
          Key := #0;
          End;
      end;  {If (Key = #13)}

end;  {FormKeyPress}

{==================================================================================}
Procedure TAssessorOfficeMaintForm.SaveButtonClick(Sender: TObject);

begin
  If (MainTable.Modified and  {Table is modified.}
      (MainTable.State in [dsEdit, dsInsert]) and
      ((not GlblAskSave) or     {We should not confirm a save or...}
       (GlblAskSave and        {We should confirm a save and...}
        (MessageDlg('Do you want to save?', mtConfirmation,
                    [mbYes, mbCancel], 0) = mrYes))))  {They want to save it.}
    then
      try
        MainTable.Post;
      except
        SystemSupport(001, MainTable, 'Error posting letter text file.',
                      UnitName, GlblErrorDlgBox);
      end;

end;  {SaveButtonClick}

{======================================================================}
Procedure TAssessorOfficeMaintForm.MainTableAfterPost(DataSet: TDataset);

{FXX05021999-1: Place on page where to start address for windowed
                envelope.}

begin
  SetGlobalAssessorsOfficeVariables(MainTable);
end;

{======================================================================}
Procedure TAssessorOfficeMaintForm.CancelButtonClick(Sender: TObject);

begin
  If ((not MainTable.ReadOnly) and
      (MainTable.Modified) and
      (MainTable.State in [dsEdit, dsInsert]))
    then
      If (MessageDlg('You will lose all changes.' + #13 +
                     'Do you want to cancel anyway?', mtConfirmation, [mbYes, mbNo], 0) = mrYes)
        then MainTable.Cancel;

end;  {CancelButtonClick}

{===================================================================}
Procedure TAssessorOfficeMaintForm.ExitButtonClick(Sender: TObject);

begin
  Close;
end;

{===================================================================}
Procedure TAssessorOfficeMaintForm.FormCloseQuery(    Sender: TObject;
                                            var CanClose: Boolean);

{If there are any changes, let's ask them if they want to save
 them (or cancel).}

var
  ReturnCode : Integer;

begin
    {First see if anything needs to be saved. In order to
     determine if there are any changes, we need to sychronize
     the fields with what is in the DB edit boxes. To do this,
     we call the UpdateRecord. Then, if there are any changes,
     the Modified flag will be set to True.}

  If (MainTable.State in [dsInsert, dsEdit])
    then MainTable.UpdateRecord;

  If ((not MainTable.ReadOnly) and
      (MainTable.State in [dsEdit, dsInsert]) and
      MainTable.Modified)
    then
      begin
        ReturnCode := MessageDlg('Do you wish to save your changes?', mtConfirmation,
                                 [mbYes, mbNo, mbCancel], 0);

        case ReturnCode of
          idYes : MainTable.Post;

          idNo : MainTable.Cancel;

          idCancel : CanClose := False;

        end;  {case ReturnCode of}

      end;  {If ((not MainTable.ReadOnly) and ...}

end;  {FormCloseQuery}

{===================================================================}
Procedure TAssessorOfficeMaintForm.FormClose(    Sender: TObject;
                                       var Action: TCloseAction);

{Note that if we get here, we are definately closing the form
 since the CloseQuery event is called first. In CloseQuery, if
 there are any modifications, they have a chance to cancel
 then.}

begin
    {Make sure that we close the tables.}

  CloseTablesForForm(Self);

    {Free up the child window and set the ClosingAForm Boolean to
     true so that we know to delete the tab.}

  Action := caFree;
  GlblClosingAForm := True;
  GlblClosingFormCaption := Caption;

end;  {FormClose}

end.