unit Pexdeny;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  StdCtrls, ExtCtrls, Forms, Dialogs, DB, Grids, DBGrids,
  DBTables, Mask, DBCtrls, Wwtable, Wwdatsrc, Wwdbcomb, Wwdbigrd, Wwdbgrid,
  Btrvdlg, Types, wwdblook, Buttons;

type
  TDeniedExemptionsForm = class(TForm)
    MainDataSource: TwwDataSource;
    MainTable: TwwTable;
    Panel1: TPanel;
    TitleLabel: TLabel;
    Panel2: TPanel;
    ScrollBox: TScrollBox;
    ExemptionDenialGrid: TwwDBGrid;
    ParcelDataSource: TDataSource;
    ParcelTable: TTable;
    Label5: TLabel;
    EditName: TDBEdit;
    EditSBL: TMaskEdit;
    YearLabel: TLabel;
    EditLocation: TEdit;
    Label7: TLabel;
    Label4: TLabel;
    CloseButton: TBitBtn;
    Navigator: TDBNavigator;
    ParcelTableTaxRollYr: TStringField;
    ParcelTableSwisCode: TStringField;
    ParcelTableSection: TStringField;
    ParcelTableSubsection: TStringField;
    ParcelTableBlock: TStringField;
    ParcelTableLot: TStringField;
    ParcelTableSublot: TStringField;
    ParcelTableSuffix: TStringField;
    ParcelTableName1: TStringField;
    ParcelTableLegalAddrNo: TStringField;
    ParcelTableLegalAddr: TStringField;
    ParcelTableLastChangeDate: TDateField;
    ParcelTableLastChangeByName: TStringField;
    EXCodeTable: TwwTable;
    EXCodeLookupCombo: TwwDBLookupCombo;
    MainTableTaxRollYr: TStringField;
    MainTableSwisSBLKey: TStringField;
    MainTableExemptionCode: TStringField;
    MainTableDenialPrinted: TBooleanField;
    MainTablePrintedDate: TDateField;
    MainTableDenialDate: TDateField;
    Label53: TLabel;
    InactiveLabel: TLabel;
    LandAVLabel: TLabel;
    Label55: TLabel;
    TotalAVLabel: TLabel;
    ParcelTableActiveFlag: TStringField;
    OldParcelIDLabel: TLabel;
    AssessmentYearControlTable: TTable;
    ParcelTableRemapOldSBL: TStringField;
    MainTableReason: TMemoField;
    MainTableProrata: TBooleanField;
    PartialAssessmentLabel: TLabel;

    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure CloseButtonClick(Sender: TObject);
    procedure MainTableBeforePost(DataSet: TDataset);
    procedure MainTableAfterPost(DataSet: TDataset);
    procedure MainTableAfterDelete(DataSet: TDataset);
    procedure MainTableNewRecord(DataSet: TDataset);
    procedure FormActivate(Sender: TObject);

  protected
    procedure CreateParams(var Params: TCreateParams); override;
  public
    { public declarations }
    UnitName : String;  {For use with error dialog box.}

      {These will be set in the ParcelTabForm.}

    EditMode : Char;  {A = Add; M = Modify; V = View}
    TaxRollYr, SwisSBLKey : String;
    ProcessingType : Integer;

    FormIsInitializing : Boolean;  {Is the form being initialized right now?}
    ClosingForm : Boolean;  {Are we closing a form right now?}

      {Have there been any changes?}

    ParcelChanged : Boolean;

    FormAccessRights : Integer;  {Read only or read write, based on security level?}
                                {Values = raReadOnly, raReadWrite}
      {because these routines are placed at the form object def. level,}
      {they have access to all variables on form (no need to Var in)   }
    Procedure InitializeForm;
    Procedure SetRangeForTable(Table : TTable);
      {What is the code table name for this lookup?}

  end;    {end form object definition}

implementation

uses GlblVars, PASTypes, WinUtils, PASUtils, Utilitys,
     GlblCnst, DataAccessUnit;


{$R *.DFM}

{=====================================================================}
Procedure TDeniedExemptionsForm.CreateParams(var Params: TCreateParams);

begin
 inherited CreateParams(Params);

  with Params do
    begin
      WndParent := Application.Mainform.Handle;
      Style := (Style or WS_Child) and not WS_Popup;
    end;

end;  {CreateParams}

{========================================================================}
Procedure TDeniedExemptionsForm.FormActivate(Sender: TObject);

begin
  Refresh;
end;

{========================================================================}
Procedure TDeniedExemptionsForm.SetRangeForTable(Table : TTable);

{Now set the range on this table so that it is sychronized to this parcel. Note
 that all segments of the key must be set.}
{mmm4 - Make sure to set range on all keys.}

begin
  try
    SetRangeOld(Table, ['TaxRollYr', 'SwisSBLKey'],
                [TaxRollYr, SwisSBLKey], [TaxRollYr, SwisSBLKey]);
  except
    SystemSupport(001, Table, 'Error setting range in ' + Table.Name, UnitName, GlblErrorDlgBox);
  end;

end;  {SetRangeForTable}

{====================================================================}
Procedure TDeniedExemptionsForm.InitializeForm;

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
  Found : Boolean;
  SBLRec : SBLRecord;

begin
  UnitName := 'PEXDENY';  {mmm1}
  ParcelChanged := False;
  ClosingForm := False;
  FormIsInitializing := True;

  If (Deblank(SwisSBLKey) <> '')
    then
      begin
        If (ParcelTable.FieldByName('ActiveFlag').Text = InactiveParcelFlag)
          then InactiveLabel.Visible := True;

          {If this is the history file, or they do not have read access,
           then we want to set the files to read only.}

        If not ModifyAccessAllowed(FormAccessRights)
          then MainTable.ReadOnly := True;

          {If this is inquire let's open it in
           readonly mode. Hist access is blocked at menu level}

        If (EditMode = 'V')
          then MainTable.ReadOnly := True;

        OpenTablesForForm(Self, ProcessingType);

          {First let's find this parcel in the parcel table.}

        SBLRec := ExtractSwisSBLFromSwisSBLKey(SwisSBLKey);

        with SBLRec do
          Found := FindKeyOld(ParcelTable,
                              ['TaxRollYr', 'SwisCode', 'Section',
                               'Subsection', 'Block', 'Lot', 'Sublot',
                               'Suffix'],
                              [TaxRollYr, SwisCode, Section,
                               SubSection, Block, Lot, Sublot, Suffix]);

        If not Found
          then SystemSupport(005, ParcelTable, 'Error finding key in parcel table.', UnitName, GlblErrorDlgBox);

          {Set the range.}

        SetRangeForTable(MainTable);  {This is a method that we have written to avoid having two copies of the setrange.}

          {Now, for some reason the table is marked as
           Modified after we do a set range in modify mode.
           So, we will cancel the modify and set it in
           the proper mode.}

        If ((not MainTable.ReadOnly) and
            (EditMode = 'M'))
          then
            begin
              MainTable.Edit;
              MainTable.Cancel;
            end;

          {Note that we will not automatically put them
           in edit mode or insert mode. We will make them
           take that action themselves since even though
           they are in an edit or insert session, they
           may not want to actually make any changes, and
           if they do not, they should not have to cancel.}

        case EditMode of
          'V' : begin
                    {Disable any navigator button that does
                     not apply in inquire mode.}

                  Navigator.VisibleButtons := [nbFirst, nbPrior, nbNext, nbLast];

                    {We will allow a width of 30 per button and
                     resize and recenter the navigator.}

                  Navigator.Width := 120;
                  Navigator.Left := (ScrollBox.Width - Navigator.Width) DIV 2;

                end;  {Inquire}

        end;  {case EditMode of}

          {Set the location label.}

        EditLocation.Text := GetLegalAddressFromTable(ParcelTable);

          {Now set the year label.}

        YearLabel.Caption := GetTaxYrLbl;

          {Set the SBL in the SBL edit so that it is visible.
           Note that it is not data aware since if there are
           no records, we have nothing to get the SBL from.}

        EditSBL.Text := ConvertSwisSBLToDashDot(SwisSBLKey);;

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
Procedure TDeniedExemptionsForm.MainTableAfterDelete(DataSet: TDataset);

{After a delete, we should always reset the range.}

begin
  MainTable.DisableControls;
  MainTable.CancelRange;
  SetRangeForTable(MainTable);  {This is a method that we have written to avoid having two copies of the setrange.}
  MainTable.EnableControls;

end;  {MainTableAfterDelete}

{==============================================================}
Procedure TDeniedExemptionsForm.MainTableNewRecord(DataSet: TDataset);

begin
    {FXX11142003-1: Make sure that all float and integer fields are initialized to 0.}
    
  InitializeFieldsForRecord(DataSet);

  MainTable.FieldByName('TaxRollYr').Text  := Take(4, TaxRollYr);
  MainTable.FieldByName('SwisSBLKey').Text := Take(26, SwisSBLKey);
  MainTable.FieldByName('DenialDate').AsDateTime := Date;

  ExemptionDenialGrid.SetFocus;
  ExemptionDenialGrid.SetActiveField('ExemptionCode');

end;  {MainTableNewRecord}

{==============================================================}
Procedure TDeniedExemptionsForm.MainTableBeforePost(DataSet: TDataset);

{If this is insert state, then fill in the SBL key and the
 tax roll year.}

var
  ReturnCode : Integer;

begin
  If ((not FormIsInitializing) and
      (MainTable.State = dsInsert))
    then
      begin
        If (GlblAskSave or ClosingForm)
          then
            begin
              If ClosingForm
                then ReturnCode := MessageDlg('Do you wish to save your changes before exiting?', mtConfirmation,
                                              [mbYes, mbNo, mbCancel], 0)
                else ReturnCode := MessageDlg('Do you wish to save your changes?', mtConfirmation,
                                              [mbYes, mbNo, mbCancel], 0);

              case ReturnCode of
                idNo : If (MainTable.State = dsInsert)
                         then MainTable.Cancel
                         else RefreshNoPost(MainTable);

                idCancel : Abort;

              end;  {case ReturnCode of}

            end;  {If GlblAskSave}

      end;  {If ((not FormIsInitializing) and ...}

end;  {MainTableBeforePost}

{==============================================================}
Procedure TDeniedExemptionsForm.MainTableAfterPost(DataSet: TDataset);

{Now let's call RecordChanges which will insert a record into the trace file if any differences
 exist.
 Note that RecordChanges returns an integer saying how many changes there
 were. If this number is greater than 0, then we will update the
 name and date changed fields of the parcel record.}

begin
  ParcelChanged := True;

end;  {MainTableAfterPost}

{==============================================================}
Procedure TDeniedExemptionsForm.CloseButtonClick(Sender: TObject);

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
Procedure TDeniedExemptionsForm.FormCloseQuery(    Sender: TObject;
                                         var CanClose: Boolean);

begin
  GlblParcelPageCloseCancelled := False;
  CanClose := True;
  ClosingForm := True;

    {First see if anything needs to be saved. In order to
     determine if there are any changes, we need to sychronize
     the fields with what is in the DB edit boxes. To do this,
     we call the UpdateRecord. Then, if there are any changes,
     the Modified flag will be set to True.}

  If (MainTable.State in [dsInsert, dsEdit])
    then MainTable.UpdateRecord;

    {Now, if they are closing the table, let's see if they want to
     save any changes. However, we won't check this if
     they are in inquire mode.}

    {FXX12131999-2: If deleted denial, could not exit tab - was saying table modified.}

  If (((EditMode = 'M') or
       (EditMode = 'A')) and
      (MainTable.State in [dsInsert, dsEdit]) and
      MainTable.Modified)
    then
      begin
        try
          MainTable.Post;
        except
          CanClose := False;
          GlblParcelPageCloseCancelled := True;
        end;

      end;  {If Modified}

  ClosingForm := False;

end;  {FormCloseQuery}

{====================================================================}
Procedure TDeniedExemptionsForm.FormClose(    Sender: TObject;
                                    var Action: TCloseAction);

begin
    {Now, if the parcel changed, then update the parcel table.}

  If ParcelChanged
    then MarkRecChanged(ParcelTable, UnitName);

    {Close all tables here.}

  CloseTablesForForm(Self);

  Action := caFree;

end;  {FormClose}


end.