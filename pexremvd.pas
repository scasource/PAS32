unit Pexremvd;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  StdCtrls, ExtCtrls, Forms, Dialogs, DB, Grids, DBGrids,
  DBTables, Mask, DBCtrls, Wwtable, Wwdatsrc, Wwdbcomb, Wwdbigrd, Wwdbgrid,
  Btrvdlg, Types, wwdblook, Buttons;

type
  TRemovedExemptionsForm = class(TForm)
    dsrc_Main: TwwDataSource;
    tb_Main: TwwTable;
    Panel1: TPanel;
    TitleLabel: TLabel;
    dsrc_Parcel: TDataSource;
    tb_Parcel: TTable;
    YearLabel: TLabel;
    tb_EXCode: TwwTable;
    Label53: TLabel;
    InactiveLabel: TLabel;
    LandAVLabel: TLabel;
    Label55: TLabel;
    TotalAVLabel: TLabel;
    OldParcelIDLabel: TLabel;
    tb_AssessmentYearControl: TTable;
    PartialAssessmentLabel: TLabel;
    gd_ExemptionsRemoved: TwwDBGrid;
    lcmb_EXCode: TwwDBLookupCombo;
    Panel3: TPanel;
    Label4: TLabel;
    Label7: TLabel;
    Label5: TLabel;
    ed_Location: TEdit;
    ed_SBL: TMaskEdit;
    ed_Name: TDBEdit;
    Panel4: TPanel;
    btn_Close: TBitBtn;
    btn_New: TBitBtn;
    btn_Delete: TBitBtn;
    btn_Save: TBitBtn;

    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure btn_CloseClick(Sender: TObject);
    procedure tb_MainBeforePost(DataSet: TDataset);
    procedure tb_MainAfterPost(DataSet: TDataset);
    procedure tb_MainAfterDelete(DataSet: TDataset);
    procedure tb_MainNewRecord(DataSet: TDataset);
    procedure btn_NewClick(Sender: TObject);
    procedure btn_SaveClick(Sender: TObject);
    procedure btn_DeleteClick(Sender: TObject);
    procedure tb_MainAfterEdit(DataSet: TDataSet);
    procedure tb_MainBeforeDelete(DataSet: TDataSet);

  protected
    procedure CreateParams(var Params: TCreateParams); override;
  public
    { public declarations }
    UnitName : String;  {For use with error dialog box.}

      {These will be set in the ParcelTabForm.}

    EditMode : Char;  {A = Add; M = Modify; V = View}
    TaxRollYr : String;
    ProcessingType : Integer;
    SwisSBLKey : String;

    FormIsInitializing : Boolean;  {Is the form being initialized right now?}
    ClosingForm : Boolean;  {Are we closing a form right now?}
    FieldTraceInformationList : TList;

      {Have there been any changes?}

    ParcelChanged : Boolean;

    FormAccessRights : Integer;  {Read only or read write, based on security level?}
                                {Values = raReadOnly, raReadWrite}
    Procedure InitializeForm;
    Procedure SetRangeForTable(Table : TTable);

  end;    {end form object definition}

implementation

uses GlblVars, PASTypes, WinUtils, PASUtils, Utilitys,
     GlblCnst, DataAccessUnit;

{$R *.DFM}

{=====================================================================}
Procedure TRemovedExemptionsForm.CreateParams(var Params: TCreateParams);

begin
 inherited CreateParams(Params);

  with Params do
    begin
      WndParent := Application.Mainform.Handle;
      Style := (Style or WS_Child) and not WS_Popup;
    end;

end;  {CreateParams}

{========================================================================}
Procedure TRemovedExemptionsForm.SetRangeForTable(Table : TTable);

{FXX07252008-1(2.14.1.5): Don't have a starting date in the beginning rage for the effective date.} 

begin
  _SetRange(Table, [SwisSBLKey, '', ''], [SwisSBLKey, '1/1/3000', ''], '', []);
end;  {SetRangeForTable}

{====================================================================}
Procedure TRemovedExemptionsForm.InitializeForm;

begin
  UnitName := 'PEXREMVD';
  ParcelChanged := False;
  ClosingForm := False;
  FormIsInitializing := True;

  If _Compare(SwisSBLKey, coNotBlank)
    then
      begin
        FieldTraceInformationList := TList.Create;
        
          {If this is the history file, or they do not have read access,
           then we want to set the files to read only.}
          {FXX07012007(2.11.1.44)[D867]: Removed exemption security should not
                                         depend on the assessment year.}

        If _Compare(EditMode, 'V', coEqual)
          then tb_Main.ReadOnly := True;

        If tb_Main.ReadOnly
          then
            begin
              btn_New.Enabled := False;
              btn_Save.Enabled := False;
              btn_Delete.Enabled := False;

            end;  {If tb_Main.ReadOnly}

        OpenTablesForForm(Self, GlblProcessingType);

        If (tb_Parcel.FieldByName('ActiveFlag').Text = InactiveParcelFlag)
          then InactiveLabel.Visible := True;

        If not _Locate(tb_Parcel, [TaxRollYr, SwisSBLKey], '', [loParseSwisSBLKey])
          then SystemSupport(005, tb_Parcel, 'Error finding key in parcel table.', UnitName, GlblErrorDlgBox);

        SetRangeForTable(tb_Main);

        ed_Location.Text := GetLegalAddressFromTable(tb_Parcel);

        YearLabel.Caption := GetTaxYrLbl;

        ed_SBL.Text := ConvertSwisSBLToDashDot(SwisSBLKey);;
        TDateTimeField(tb_Main.FieldByName('InitialDate')).DisplayFormat := DateFormat;

        If GlblLocateByOldParcelID
          then SetOldParcelIDLabel(OldParcelIDLabel, tb_Parcel,
                                   tb_AssessmentYearControl);

      end;  {If (Deblank(SwisSBLKey) <> '')}

    {CHG11162004-7(2.8.0.21): Option to make the close button locate.}

  If GlblCloseButtonIsLocate
    then MakeCloseButtonLocate(btn_Close);

  FormIsInitializing := False;

end;  {InitializeForm}

{=============================================================}
Procedure TRemovedExemptionsForm.btn_NewClick(Sender: TObject);

begin
  tb_Main.Append;
end;

{=============================================================}
Procedure TRemovedExemptionsForm.btn_SaveClick(Sender: TObject);

begin
  If tb_Main.Modified
    then tb_Main.Post;

end;  {btn_SaveClick}

{=============================================================}
Procedure TRemovedExemptionsForm.btn_DeleteClick(Sender: TObject);

begin
  If _Compare(MessageDlg('Are you sure you want to permanently delete this removal record?',
                         mtWarning, [mbYes, mbNo], 0), idYes, coEqual)
    then tb_Main.Delete;

end;  {btn_DeleteClick}

{==============================================================}
Procedure TRemovedExemptionsForm.tb_MainBeforeDelete(DataSet: TDataSet);

begin
  AddToTraceFile(SwisSBLKey, ExemptionRemovalScreenName, 'Exemption Code',
                 tb_Main.FieldByName('ExemptionCode').AsString,
                 '(Deleted)', Time, tb_Main);

end;  {tb_MainBeforeDelete}

{==============================================================}
Procedure TRemovedExemptionsForm.tb_MainAfterDelete(DataSet: TDataset);

{After a delete, we should always reset the range.}

begin
  tb_Main.DisableControls;
  tb_Main.CancelRange;
  SetRangeForTable(tb_Main);  {This is a method that we have written to avoid having two copies of the setrange.}
  tb_Main.EnableControls;
  ParcelChanged := True;

    {Now, if the parcel changed, then update the parcel table.}
    {FXX10152004-2(2.8.0.14): Move the call to MarkRecChanged to after post so that it updates right away.}

  If ParcelChanged
    then MarkRecChanged(tb_Parcel, UnitName);

end;  {tb_MainAfterDelete}

{==============================================================}
Procedure TRemovedExemptionsForm.tb_MainAfterEdit(DataSet: TDataSet);

{CHG09232006-1(2.10.1.12): Add auditing to exemption removals.}

begin
  If not FormIsInitializing
    then CreateFieldValuesAndLabels(Self, tb_Main, FieldTraceInformationList);

end;  {tb_MainAfterEdit}

{==============================================================}
Procedure TRemovedExemptionsForm.tb_MainNewRecord(DataSet: TDataset);

begin
  InitializeFieldsForRecord(DataSet);

  with tb_Main do
    begin
      FieldByName('SwisSBLKey').AsString := SwisSBLKey;
      FieldByName('ActualDateRemoved').AsDateTime := Date;
      FieldByName('EffectiveDateRemoved').AsDateTime := Date;
      FieldByName('RemovedBy').AsString := GlblUserName;

    end;  {with tb_Main do}

  gd_ExemptionsRemoved.SetFocus;
  gd_ExemptionsRemoved.SetActiveField('ExemptionCode');

end;  {tb_MainNewRecord}

{==============================================================}
Procedure TRemovedExemptionsForm.tb_MainBeforePost(DataSet: TDataset);

{If this is insert state, then fill in the SBL key and the
 tax roll year.}

var
  ReturnCode : Integer;

begin
  If ((not FormIsInitializing) and
      (tb_Main.State = dsInsert))
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
                idNo : If (tb_Main.State = dsInsert)
                         then tb_Main.Cancel
                         else RefreshNoPost(tb_Main);

                idCancel : Abort;

              end;  {case ReturnCode of}

            end;  {If GlblAskSave}

      end;  {If ((not FormIsInitializing) and ...}

end;  {tb_MainBeforePost}

{==============================================================}
Procedure TRemovedExemptionsForm.tb_MainAfterPost(DataSet: TDataset);

begin
   If _Compare(RecordChanges(Self, ExemptionRemovalScreenName, tb_Main, SwisSBLKey,
                             FieldTraceInformationList), 0, coGreaterThan)
    then ParcelChanged := True;

end;  {tb_MainAfterPost}

{==============================================================}
Procedure TRemovedExemptionsForm.btn_CloseClick(Sender: TObject);

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
Procedure TRemovedExemptionsForm.FormCloseQuery(    Sender: TObject;
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

  If (tb_Main.State in [dsInsert, dsEdit])
    then tb_Main.UpdateRecord;

    {Now, if they are closing the table, let's see if they want to
     save any changes. However, we won't check this if
     they are in inquire mode.}

    {FXX12131999-2: If deleted denial, could not exit tab - was saying table modified.}

  If (((EditMode = 'M') or
       (EditMode = 'A')) and
      (tb_Main.State in [dsInsert, dsEdit]) and
      tb_Main.Modified)
    then
      begin
        try
          tb_Main.Post;
        except
          CanClose := False;
          GlblParcelPageCloseCancelled := True;
        end;

      end;  {If Modified}

  ClosingForm := False;

end;  {FormCloseQuery}

{====================================================================}
Procedure TRemovedExemptionsForm.FormClose(    Sender: TObject;
                                    var Action: TCloseAction);

begin
  FreeTList(FieldTraceInformationList, SizeOf(FieldTraceInformationRecord));
  CloseTablesForForm(Self);
  Action := caFree;

end;  {FormClose}

end.
