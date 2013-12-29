unit Userprof;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, DBCtrls, DBTables, DB, Buttons, Grids,
  Wwdbigrd, Wwdbgrid, ExtCtrls, Wwtable, Wwdatsrc, Menus, Mask,
  LoginUnt, Wwdbedit, Wwdotdot, Wwdbcomb, wwdblook, wwidlg, wwDialog,
  ComCtrls, RPCanvas, RPrinter, RPDefine, RPBase, RPFiler;

type
  TUserProfileForm = class(TForm)
    UserProfileDataSource: TwwDataSource;
    UserProfileTable: TwwTable;
    SwisCodeLookupTable: TwwTable;
    SwisCodeLookupTableMunicipalityName: TStringField;
    LocateSearchDialog: TwwSearchDialog;
    UserProfileLookupTable: TwwTable;
    UserProfileTableUserID: TStringField;
    UserProfileTablePassword: TStringField;
    UserProfileTableSecurityLevel: TIntegerField;
    UserProfileTableUserName: TStringField;
    UserProfileTableShowHints: TBooleanField;
    UserProfileTableAskSaveOnParcelPage: TBooleanField;
    UserProfileTableInterleaveParcelTabs: TBooleanField;
    UserProfileTableNotesPurgableDefault: TBooleanField;
    UserProfileTableThisYearAccess: TIntegerField;
    UserProfileTableNextYearAccess: TIntegerField;
    UserProfileTableHistoryAccess: TBooleanField;
    UserProfileTableDefaultSwisCode: TStringField;
    UserProfileTableSearcher: TBooleanField;
    UserProfileTableConfirmOnExit: TBooleanField;
    UserProfileTableDefaultPreviewZoomPercent: TIntegerField;
    UserProfileTableSameTabDuringScroll: TBooleanField;
    UserProfileTableShowZeroesAsBlanks: TBooleanField;
    UserProfileTableStartingParcelPage: TIntegerField;
    UserProfileTableShowVetMaxMessage: TBooleanField;
    UserProfileTablePrintToScreenDefault: TBooleanField;
    UserProfileTableNameAddrUpdateOnly: TBooleanField;
    UserProfileTableSelectAllComps: TBooleanField;
    UserProfileTableUpdateParcelIDAsGo: TBooleanField;
    UserProfileTableRemindForWidePrint: TBooleanField;
    UserProfileTableDefaultSrchPrclType: TIntegerField;
    UserProfileTableShowRptDialog: TBooleanField;
    UserProfileTableReserved: TStringField;
    SwisCodeLookupTableSwisCode: TStringField;
    UserProfileTableCanDoValueChanges: TBooleanField;
    UserProfileTableUseParcelToolbar: TBooleanField;
    UserProfileTableShowAVChangeAmount: TBooleanField;
    UserProfileTableAllowParcelYearSwitch: TBooleanField;
    UserProfileTablePersistantDualTabs: TBooleanField;
    UserProfileTableCertiorariOnly: TBooleanField;
    UserProfileTableCanSeeCertiorari: TBooleanField;
    UserProfileTableCanSeeCertNotes: TBooleanField;
    UserProfileTableCanSeeCertAppraisals: TBooleanField;
    UserProfileTableStartingViewPage: TIntegerField;
    UserProfileTableUseTFormScreenPrint: TBooleanField;
    UserProfileTableUserCannotChangeExemptions: TBooleanField;
    UserProfileTableUsesPrivateNotes: TBooleanField;
    UserProfileTableSkipUnusedSalesFields: TBooleanField;
    UserProfileTableNextSalesFieldAfterCond: TIntegerField;
    UserProfileTableDefaultLocateMethod: TIntegerField;
    UserProfileTableCanChangeOwnerOverride: TBooleanField;
    UserProfileTableBankCodeChangesOnly: TBooleanField;
    UserProfileTablePrintScreenMethod: TBooleanField;
    UserProfileTableUserCantDeleteExemptions: TBooleanField;
    SecurityPage: TPageControl;
    TabSheet3: TTabSheet;
    Label8: TLabel;
    Label2: TLabel;
    Label1: TLabel;
    ThisYearAccessRadioGroup: TDBRadioGroup;
    NextYearAccessRadioGroup: TDBRadioGroup;
    EditUserID: TDBEdit;
    EditPassword: TEdit;
    EditName: TDBEdit;
    UserRightsPageControl: TPageControl;
    GeneralRightsTabSheet: TTabSheet;
    Label3: TLabel;
    CanMakeValueChangesCheckBox: TDBCheckBox;
    ParcelYearFlipCheckBox: TDBCheckBox;
    CheckBoxHistoryAccess: TDBCheckBox;
    NameAddressUpdateOnlyCheckBox: TDBCheckBox;
    SearcherCheckBox: TDBCheckBox;
    ReportDialogCheckBox: TDBCheckBox;
    EditSecurityLevel: TDBEdit;
    PreventExemptionChangesCheckBox: TDBCheckBox;
    CanViewAndEnterPrivateNotesCheckBox: TDBCheckBox;
    CanMakeOwnerChangeCheckBox: TDBCheckBox;
    BankCodeUpdateOnlyCheckBox: TDBCheckBox;
    DBCheckBox1: TDBCheckBox;
    GrievanceRightsTabSheet: TTabSheet;
    CertiorariOnlyCheckBox: TDBCheckBox;
    CanSeeCertiorariCheckBox: TDBCheckBox;
    CanSeeCertAppraisalsCheckBox: TDBCheckBox;
    CanSeeCertiorariNotesCheckBox: TDBCheckBox;
    VerifyPasswordPanel: TPanel;
    Label7: TLabel;
    ConfirmPasswordEdit: TEdit;
    UserOptionsPage: TTabSheet;
    Label4: TLabel;
    Label5: TLabel;
    Label9: TLabel;
    Label11: TLabel;
    Label13: TLabel;
    Label15: TLabel;
    Label17: TLabel;
    Label16: TLabel;
    Label12: TLabel;
    Label14: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    CheckBoxShowHints: TDBCheckBox;
    CheckBoxAskSave: TDBCheckBox;
    CheckBoxInterleaveTabs: TDBCheckBox;
    SwisCodeLookupCombo: TwwDBLookupCombo;
    ConfirmExitCheckBox: TDBCheckBox;
    FirstPageInParcelNotebookComboBox: TwwDBComboBox;
    ShowVetMaxWarningMsgCheckBox: TDBCheckBox;
    ShowParcelToolbarCheckBox: TDBCheckBox;
    PrintDestinationCombobox: TwwDBComboBox;
    RemindForWideCarriageCheckBox: TDBCheckBox;
    ShowAVChangeInfoCheckBox: TDBCheckBox;
    DefaultViewPageComboBox: TwwDBComboBox;
    AlternatePrintScreenCheckBox: TDBCheckBox;
    SkipUnusedSalesFieldsCheckBox: TDBCheckBox;
    NextFieldAfterSalesConditionComboBox: TwwDBComboBox;
    DefaultParcelLocateComboBox: TwwDBComboBox;
    Panel1: TPanel;
    btnPrint: TBitBtn;
    LocateButton: TBitBtn;
    SaveButton: TBitBtn;
    CancelButton: TBitBtn;
    CloseButton: TBitBtn;
    pnlUsers: TPanel;
    btnDelete: TBitBtn;
    grdUsers: TwwDBGrid;
    PrintDialog: TPrintDialog;
    ReportFiler: TReportFiler;
    ReportPrinter: TReportPrinter;
    btnAdd: TBitBtn;
    cbxViewPermits: TDBCheckBox;
    UserProfileTableUserCanViewPermits: TBooleanField;
    dbSupervisorEquivalent: TDBCheckBox;
    UserProfileTableUsesParcelToolbar: TBooleanField;
    UserProfileTableUserCanDeleteExemptions: TBooleanField;
    UserProfileTableSupervisorEquivalent: TBooleanField;
    UserProfileTableSuppressPrintSizePrompts: TBooleanField;
    UserProfileTableAutoDuplex: TBooleanField;
    UserProfileTableAutoVerticalDuplex: TBooleanField;
    GroupBox1: TGroupBox;
    dbDefaultLetterSize: TDBCheckBox;
    bcDefaultDuplex: TDBCheckBox;
    dbDefaultToVerticalDuplex: TDBCheckBox;
    UserProfileTableShowSketchWithComments: TBooleanField;
    Label6: TLabel;
    DBCheckBox2: TDBCheckBox;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure UserProfileTableBeforeDelete(DataSet: TDataset);
    procedure SaveButtonClick(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject);
    procedure UserProfileTableAfterInsert(DataSet: TDataset);
    procedure UserProfileTableBeforePost(DataSet: TDataset);
    procedure UserProfileDataSourceDataChange(Sender: TObject;
      Field: TField);
    procedure EditPasswordExit(Sender: TObject);
    procedure ConfirmPasswordEditExit(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure EditPasswordEnter(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure UserProfileTableAfterPost(DataSet: TDataset);
    procedure UserProfileTableAfterEdit(DataSet: TDataset);
    procedure LocateButtonClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnPrintClick(Sender: TObject);
    procedure ReportPrintHeader(Sender: TObject);
    procedure ReportPrint(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
  private
    { Private declarations }
    UnitName : String;

  public
    { Public declarations }
    FormAccessRights : Integer;  {Read only or read write, based on security level?}
                                {Values = raReadOnly, raReadWrite}
    ExitingPasswordPanel : Boolean;  {If they are exiting the password panel, we don't
                                      want to process the carriage return because it
                                      will make us skip a field.}
    ClosingForm : Boolean;  {Are we closing the form right now?}

    Procedure InitializeForm;  {Open the tables and setup.}
  end;

implementation

uses GlblVars, WinUtils, Utilitys, PASUTILS, UTILEXSD,  GlblCnst, Types, UtilPrcl,
  Preview, PASTypes;

const
  MinPasswordLength = 3;

{$R *.DFM}

{========================================================}
Procedure TUserProfileForm.FormActivate(Sender: TObject);

begin
  SetFormStateMaximized(Self);
end;

{========================================================}
Procedure TUserProfileForm.InitializeForm;

var
  I : Integer;

begin
  UnitName := 'USERPROF';
  ExitingPasswordPanel := False;
  ClosingForm := False;

    {Set up the screen by turning off most options for modification.
     At this point, all they can change is password, ask save,
     show hints (10/4/96).}

  EditUserID.ReadOnly := True;
  EditUserID.Color := clBtnFace;
  EditSecurityLevel.ReadOnly := True;
  EditSecurityLevel.Color := clBtnFace;

  UserRightsPageControl.ActivePage := GeneralRightsTabSheet;

  If not GlblUsesGrievances
    then GrievanceRightsTabSheet.TabVisible := False;

    {Note that since this does not have anything to do with tax
     roll year, the only thing that determines the access rights
     for this form are the menu security levels.}

  If (FormAccessRights = raReadOnly)
    then UserProfileTable.ReadOnly := True;

  OpenTablesForForm(Self, GlblProcessingType);

    {CHG03232004-5(2.08): Private notes feature.}

  If not GlblUsePrivateNotes
    then CanViewAndEnterPrivateNotesCheckBox.Visible := False;

    {If this is the supervisor or the SCA exclusive password,
     they will have access to all users and the navigator bar.}

    {CHG06092010-3(2.26.1)[I7208]: Allow for supervisor equivalents.}

  If UserIsSupervisor(GlblUserName)
    then
      begin
(*        LocateButton.Visible := True; *)
        pnlUsers.Visible := True;
        btnPrint.Visible := True;
        btnDelete.Visible := True;
        btnAdd.Visible := True;
        EditUserID.ReadOnly := False;
        EditUserID.Color := clWindow;
        EditSecurityLevel.ReadOnly := False;
        EditSecurityLevel.Color := clWindow;

          {Allow the supervisor to do all options.
           Note there is no common ancestor for a check box,
           edit and radio group that has the ReadOnly property.}

        For I := 0 to (ComponentCount - 1) do
          begin
            If Components[I] is TDBEdit
              then TDBEdit(Components[I]).ReadOnly := False;

            If Components[I] is TDBCheckBox
              then TDBCheckBox(Components[I]).ReadOnly := False;

            If Components[I] is TDBRadioGroup
              then TDBRadioGroup(Components[I]).ReadOnly := False;

          end;  {For I := 0 to (ComponentCount - 1) do}

      end
    else
      begin
        UserProfileTable.SetRange([Take(10, GlblUserName)], [Take(10, GlblUserName)]);
      end;

    {Set up the password text.}

  If (UserProfileTable.RecordCount > 0)
    then EditPassword.Text := RTrim(UserProfileTable.FieldByName('Password').Text);

end;  {InitializeForm}

{===========================================================}
Procedure TUserProfileForm.FormKeyPress(    Sender: TObject;
                                        var Key: Char);

begin
  If ((Key = #13) and
      (not ExitingPasswordPanel)) {If they are exiting the password panel, we don't
                                      want to process the carriage return because it
                                      will make us skip a field.}
    then
      begin
        Perform(WM_NEXTDLGCTL, 0, 0);
        Key := #0;
      end;

  ExitingPasswordPanel := False;

end;  {FormKeyPress}

{===========================================================}
Procedure TUserProfileForm.btnAddClick(Sender: TObject);

begin
  UserProfileTable.Append;
end;

{===========================================================}
Procedure TUserProfileForm.UserProfileDataSourceDataChange(Sender: TObject;
                                                           Field: TField);

{Update the password edit as they scroll.}

begin
  If (Field = nil)
    then EditPassword.Text := RTrim(UserProfileTable.FieldByName('Password').Text);

end;  {UserProfileDataSourceDataChange}

{===========================================================}
Procedure TUserProfileForm.EditPasswordEnter(Sender: TObject);

begin
  EditPassword.SelectAll;
end;  {EditPasswordEnter}

{===========================================================}
Procedure TUserProfileForm.EditPasswordExit(Sender: TObject);

{If there has been a change in the password, have them verify it.
 If it does not match, we will not save the new password.}

begin
  If (Deblank(EditPassword.Text) = '')
    then
      begin
        MessageDlg('Please enter a password.', mtError, [mbOK], 0);
        EditPassword.SetFocus;
      end
    else  {If any change was done, we need to verify it.}
      If (Take(10, EditPassword.Text) <>
          Take(10, UserProfileTable.FieldByName('Password').Text))
        then
          If (Length(EditPassword.Text) < MinPasswordLength)
            then
              begin
                MessageDlg('Passwords must be at least ' + IntToStr(MinPasswordLength) + ' characters.', mtError, [mbOK], 0);
                EditPassword.SetFocus;
              end
            else
              begin
                  {There has been a change in password, so we will
                   make them verify it.}

                MessageBeep(MB_ICONQUESTION);
                VerifyPasswordPanel.Show;
                ConfirmPasswordEdit.SetFocus;

              end;  {If (Take(10, Encrypt(EditPassword.Text)) <> ...}

end;  {EditPasswordExit}

{===========================================================}
Procedure TUserProfileForm.ConfirmPasswordEditExit(Sender: TObject);

var
  Valid : Boolean;

begin
  If (Take(10, Encrypt(EditPassword.Text)) =
      Take(10, Encrypt(ConfirmPasswordEdit.Text)))
    then
      begin
          {They verified it correctly. Change the password in the
           table.}

        MessageDlg('The password has been changed.', mtInformation, [mbOK], 0);

          {Note that since the password edits are not data aware, they might not
           be in edit mode yet, so we will put them in it if they are not.}

        If not (UserProfileTable.State in [dsEdit, dsInsert])
          then UserProfileTable.Edit;

          {FXX10271997-3: After putting the table in edit mode, the password
                          field went back to the original, which we were trying
                          to encrypt again and it did not work.}

        UserProfileTable.FieldByName('Password').Text := Take(10, Encrypt(ConfirmPasswordEdit.Text));
        Valid := True;
      end
    else
      begin
          {Incorrect verification - set them back to the old password.}

        MessageDlg('The password was not retyped correctly.' + #13 +
                   'The password was not changed.' + #13 +
                   'Please try again.', mtWarning, [mbOK], 0);
        EditPassword.Text := RTrim(UserProfileTable.FieldByName('Password').Text);
        Valid := False;

      end;  {else of If (Take(10, Encrypt(EditPassword.Text)) = ...}

  VerifyPasswordPanel.Visible := False;

  ExitingPasswordPanel := True;

  If not Valid
    (*then EditSecurityLevel.SetFocus*)
    then EditPassword.SetFocus;

end;  {ConfirmPasswordEditExit}

{===========================================================}
Procedure TUserProfileForm.UserProfileTableBeforePost(DataSet: TDataset);

{Check that they have a password.}

var
  TempStr : String;
  ProceedWithPost : Boolean;
  ReturnCode : Integer;

begin
  ProceedWithPost := False;

  If (GlblAskSave or ClosingForm)
    then
      begin
          {FXX11061997-2: Remove the "save before exiting" prompt because it
                          is confusing. Use only "Do you want to save.}

        ReturnCode := MessageDlg('Do you wish to save your user profile changes?', mtConfirmation,
                                 [mbYes, mbNo, mbCancel], 0);

        case ReturnCode of
          idYes : ProceedWithPost := True;

          idNo : If (UserProfileTable.State = dsInsert)
                   then UserProfileTable.Cancel
                   else RefreshNoPost(UserProfileTable);

          idCancel : (*Abort;*)

        end;  {case ReturnCode of}

      end  {If GlblAskSave}
    else ProceedWithPost := True;

  If ProceedWithPost
    then
      begin
          {Make sure that they entered a password.}

        If (Deblank(EditPassword.Text) = '')
          then
            begin
              MessageDlg('Please enter a password.', mtError, [mbOK], 0);
              UserProfileTable.Cancel;
              EditPassword.SetFocus;
              (*Abort;*)

            end;  {If (Deblank(EditPassword.Text) = '')}

          {Make sure that the password is at least 4 characters.}

        If (Length(EditPassword.Text) < MinPasswordLength)
          then
            begin
              MessageDlg('Passwords must be at least ' + IntToStr(MinPasswordLength) + ' characters.',
                         mtError, [mbOK], 0);
              UserProfileTable.Cancel;
              EditPassword.SetFocus;
              (*Abort;*)

            end;  {If (Deblank(EditPassword.Text) = '')}

          {Make sure that the user ID is 10 chars.}

        TempStr := Take(10, UserProfileTable.FieldByName('UserID').Text);
        UserProfileTable.FieldByName('UserID').Text := TempStr;

      end;  {If ProceedWithPost}

end;  {UserProfileTableBeforePost}

{===========================================================}
Procedure TUserProfileForm.UserProfileTableAfterPost(DataSet: TDataset);

{If the user just changed their own profile, update the global show hints,
 ask save, and interleave tabs.}

begin
  If (Take(10, UserProfileTableUserId.Text) = Take(10, GlblUserName))
    then SetGlobalUserDefaults(UserProfileTable);

  EditUserID.ReadOnly := True;
  EditUserID.Color := clBtnFace;

end;  {UserProfileTableAfterPost}

{===========================================================}
Procedure TUserProfileForm.LocateButtonClick(Sender: TObject);

begin
  LocateSearchDialog.Execute;
end;

{===========================================================}
Procedure TUserProfileForm.SaveButtonClick(Sender: TObject);

begin
    {FXX04082003-1(2.06r): Don't try to post unless in edit or insert mode.}

  If ((UserProfileTable.State in [dsEdit, dsInsert]) and
      UserProfileTable.Modified)
    then
      try
        UserProfileTable.Post;
      except
        SystemSupport(002, UserProfileTable, 'Error posting user profile record.',
                      UnitName, GlblErrorDlgBox);
      end;

end;  {SaveButtonClick}

{==========================================================}
Procedure TUserProfileForm.CancelButtonClick(Sender: TObject);

begin
  If ((UserProfileTable.State in [dsEdit, dsInsert]) and
      UserProfileTable.Modified)
    then UserProfileTable.Cancel;

end;  {CancelButtonClick}

{====================================================================}
Procedure TUserProfileForm.UserProfileTableAfterInsert(DataSet: TDataset);

begin
  EditPassword.Text := '';
  ConfirmPasswordEdit.Text := '';
  EditUserID.ReadOnly := False;
  EditUserID.Color := clWindow;
  UserProfileTableDefaultPreviewZoomPercent.AsInteger := 100;  {Default}

end;  {UserProfileTableAfterInsert}

{=====================================================================}
Procedure TUserProfileForm.UserProfileTableAfterEdit(DataSet: TDataset);

begin
  EditUserID.ReadOnly := True;
  EditUserID.Color := clBtnFace;
end;

{====================================================================}
Procedure TUserProfileForm.UserProfileTableBeforeDelete(DataSet: TDataset);

{They can not delete 'SUPERVISOR'.}

begin
  If (Take(10, UserProfileTable.FieldByName('UserID').Text) = Take(10, 'SUPERVISOR'))
    then
      begin
        MessageDlg('You can not delete this user.', mtError, [mbOK], 0);
        UserProfileTable.Cancel;
      end;

end;  {UserProfileTableBeforeDelete}

{===================================================================}
Procedure TUserProfileForm.btnDeleteClick(Sender: TObject);

begin
  If _Compare(MessageDlg('Are you sure you want to delete ' + UserProfileTable.FieldByName('UserID').AsString + '?',
                         mtConfirmation, [mbYes, mbNo], 0), idYes, coEqual)
    then UserProfileTable.Delete;

end;  {btnDeleteClick}

{==================================================================}
Procedure TUserProfileForm.ReportPrintHeader(Sender: TObject);

begin
  with Sender as TBaseReport do
    begin
        {Print the date and page number.}

      SectionTop := 0.25;
      SectionLeft := 0.5;
      SectionRight := PageWidth - 0.5;
      SetFont('Times New Roman',8);
      PrintHeader('Page: ' + IntToStr(CurrentPage), pjRight);
      PrintHeader('Date: ' + DateToStr(Date) + '  Time: ' + TimeToStr(Now), pjLeft);

      SectionTop := 0.5;
      SetFont('Times New Roman',10);
      Bold := True;
      Home;
      PrintCenter('User Settings', (PageWidth / 2));
      Bold := False;
      CRLF;
      CRLF;

      ClearTabs;
      Println('');
      Bold := True;

      ClearTabs;
      SetTab(0.4, pjCenter, 0.8, 5, BOXLINENOBOTTOM, 25);   {User ID}
      SetTab(1.2, pjCenter, 0.5, 5, BOXLINENOBOTTOM, 25);   {Level}
      SetTab(1.7, pjCenter, 0.6, 5, BOXLINENOBOTTOM, 25);   {TY Access}
      SetTab(2.3, pjCenter, 0.6, 5, BOXLINENOBOTTOM, 25);   {NY Access}
      SetTab(2.9, pjCenter, 0.6, 5, BOXLINENOBOTTOM, 25);   {Searcher}
      SetTab(3.5, pjCenter, 0.6, 5, BOXLINENOBOTTOM, 25);   {History}
      SetTab(4.1, pjCenter, 1.0, 5, BOXLINENOBOTTOM, 25);   {Name \ Addr Only}
      SetTab(5.1, pjCenter, 0.8, 5, BOXLINENOBOTTOM, 25);   {Cert Access}

      Println(#9 + 'User ID ' +
              #9 + 'Level' +
              #9 + 'TY Access' +
              #9 + 'NY Access' +
              #9 + 'Searcher' +
              #9 + 'History' +
              #9 + 'Name\Addr Only' +
              #9 + 'Cert Access');

      ClearTabs;
      SetTab(0.4, pjLeft, 0.8, 5, BOXLINEALL, 0);   {User ID}
      SetTab(1.2, pjCenter, 0.5, 5, BOXLINEALL, 0);   {Level}
      SetTab(1.7, pjCenter, 0.6, 5, BOXLINEALL, 0);   {TY Access}
      SetTab(2.3, pjCenter, 0.6, 5, BOXLINEALL, 0);   {NY Access}
      SetTab(2.9, pjCenter, 0.6, 5, BOXLINEALL, 0);   {Searcher}
      SetTab(3.5, pjCenter, 0.6, 5, BOXLINEALL, 0);   {History}
      SetTab(4.1, pjCenter, 1.0, 5, BOXLINEALL, 0);   {Name \ Addr Only}
      SetTab(5.1, pjCenter, 0.8, 5, BOXLINEALL, 0);   {Cert Access}
      Underline := False;
      Bold := False;

    end;  {with Sender as TBaseReport do}

end;  {ReportPrintHeader}

{==================================================================}
Function GetAccessString(iAccessRights : Integer) : String;

begin
  Result := '';

  case iAccessRights of
    raNoAccess : Result := 'None';
    raReadOnly : Result := 'Read Only';
    raReadWrite : Result := 'Full';

  end;

end;  {GetAccessString}

{==================================================================}
Procedure TUserProfileForm.ReportPrint(Sender: TObject);

var
  Quit : Boolean;

begin
  Quit := False;
  UserProfileLookupTable.First;

  with Sender as TBaseReport, UserProfileLookupTable do
    while ((not EOF) or Quit) do
      begin
        Println(#9 + FieldByName('UserID').AsString +
                #9 + FieldByName('SecurityLevel').AsString +
                #9 + GetAccessString(FieldByName('ThisYearAccess').AsInteger) +
                #9 + GetAccessString(FieldByName('NextYearAccess').AsInteger) +
                #9 + BoolToChar_Blank_Y(FieldByName('Searcher').AsBoolean) +
                #9 + BoolToChar_Blank_Y(FieldByName('HistoryAccess').AsBoolean) +
                #9 + BoolToChar_Blank_Y(FieldByName('NameAddrUpdateOnly').AsBoolean) +
                #9 + BoolToChar_Blank_Y(FieldByName('CanSeeCertiorari').AsBoolean));

        If (LinesLeft < 5)
          then NewPage;

        Next;

      end;  {while ((not EOF) or Quit) do}

end;  {ReportPrint}

{==================================================================}
Procedure TUserProfileForm.btnPrintClick(Sender: TObject);

var
  Quit : Boolean;
  NewFileName : String;

begin
  Quit := False;

  If PrintDialog.Execute
    then
      begin
        btnPrint.Enabled := False;

        AssignPrinterSettings(PrintDialog, ReportPrinter, ReportFiler, [ptBoth], False, Quit);

        If not Quit
          then
            If PrintDialog.PrintToFile
              then
                begin
                  NewFileName := GetPrintFileName(Self.Caption, True);
                  ReportFiler.FileName := NewFileName;
                  GlblPreviewPrint := True;

                  try
                    PreviewForm := TPreviewForm.Create(self);
                    PreviewForm.FilePrinter.FileName := NewFileName;
                    PreviewForm.FilePreview.FileName := NewFileName;

                    ReportFiler.Execute;
                    PreviewForm.ShowModal;
                  finally
                    PreviewForm.Free;

                      {Now delete the file.}
                    try
                      Chdir(GlblReportDir);
                      OldDeleteFile(NewFileName);
                    finally
                      {We don't care if it does not get deleted, so we won't put up an
                       error message.}

                      ChDir(GlblProgramDir);
                    end;

                  end;  {try PreviewForm := ...}

                end  {If PrintDialog.PrintToFile}
              else ReportPrinter.Execute;

        btnPrint.Enabled := True;

      end;  {If PrintDialog.Execute}

end;  {PrintButtonClick}

{===================================================================}
Procedure TUserProfileForm.FormCloseQuery(    Sender: TObject;
                                          var CanClose: Boolean);

begin
  ClosingForm := True;

  If ((not UserProfileTable.ReadOnly) and
      (UserProfileTable.State in [dsEdit, dsInsert]) and
      UserProfileTable.Modified)
    then
      begin
        try
          UserProfileTable.Post;
        except
          CanClose := False;
          ClosingForm := False;
        end;

      end;  {If ((not UserProfileTable.ReadOnly) and ...}

end;  {FormCloseQuery}

{===================================================================}
Procedure TUserProfileForm.FormClose(    Sender: TObject;
                                      var Action: TCloseAction);

begin
  UserProfileTable.Close;

    {Free up the child window and set the ClosingAForm Boolean to
     true so that we know to delete the tab.}

  Action := caFree;
  GlblClosingAForm := True;
  GlblClosingFormCaption := Caption;

end;  {FormClose}

end.
