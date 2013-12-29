unit InquireOnlyUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, Db, Logindlg, ExtCtrls, DBTables, StdCtrls, Btrvdlg, DLL96V1,
  wwTable, Tabs, Printers;

type
  TMainForm = class(TForm)
    UserInfoPanel: TPanel;
    LogoImage: TImage;
    TitleLabel: TLabel;
    VersionLabel: TLabel;
    MunicipalityLabel: TLabel;
    GroupBox1: TGroupBox;
    UserIDLabel: TLabel;
    CurrentTaxYearLabel: TLabel;
    DateLabel: TLabel;
    AssessorsOfficeTable: TTable;
    SysRecTable: TTable;
    InstalledPrinterTable: TTable;
    InstalledPrinterTablePrinterName: TStringField;
    InstalledPrinterTableLaser: TBooleanField;
    InstalledPrinterTableReserved: TStringField;
    PrinterSetupDialog: TPrinterSetupDialog;
    OpenTablesInDataModuleTimer: TTimer;
    LoginDlg: TLoginDlg;
    UserProfileTable: TTable;
    Timer: TTimer;
    MainMenu1: TMainMenu;
    Inquire: TMenuItem;
    Exit: TMenuItem;
    TabSet: TTabSet;
    ChangeThisYearandNextYearTogether: TMenuItem;
    SystemMenuItem: TMenuItem;
    MaintainSystemRecord1: TMenuItem;
    UserProfile1: TMenuItem;
    procedure InquireClick(Sender: TObject);
    procedure ExitClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure OpenTablesInDataModuleTimerTimer(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure NormalMenuItemClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    UnitName : String;
    DataModuleComponentIndex : Integer;
    FormCaptions : TStringList;
    AppicationIsClosing : Boolean;

    Procedure PASExceptionHandler(Sender : TObject;
                                  E : Exception);
    {This is the exception handler that will be assigned to the overall application.
     So, rather than a regular message dlg. being shown, we will display our own
     message and can customize it based on what type of exception it is.
     This exception handler is assigned to be the default application exception
     handler in the create of this form.}

    Procedure PASMessageHandler(var Msg: TMsg;
                                var Handled: Boolean);
    {Intercept the print screen key and print.}

    Procedure ApplicationActivate(Sender : TObject);
    Procedure ActiveFormChange(Sender : TObject);
  end;

var
  MainForm: TMainForm;

implementation

uses GlblVars, ParclTab, GlblCnst, PASUtils, Utilitys, WinUtils, DataModule,
     UserProf,
     SysRcMnt,
     ChosTxYr;  {Choose tax year}

{$R *.DFM}

const
  ShowLogin = True;  {For development only!}

var
  ChildFormHeight,
  ChildFormWidth : Integer;

{====================================================================}
Procedure TMainForm.PASExceptionHandler(Sender : TObject;
                                        E : Exception);

{This is the exception handler that will be assigned to the overall application.
 So, rather than a regular message dlg. being shown, we will display our own
 message and can customize it based on what type of exception it is.
 This exception handler is assigned to be the default application exception
 handler in the create of this form.}

const
  EDatasetNotInEditMode = 'Dataset not in edit or insert mode';
var
  TempStr : String;
  TempPtr : Pointer;

begin
  TempPtr := ExceptAddr;
  TempStr := E.Message;

  If (E.Message = EDatasetNotInEditMode)
    then TempStr := 'Please click insert or edit on the navigator bar' + #13 +
                    'before making any changes to this information.';

    {FXX06291999-7: Filter out error code 84 and 85.}
    {FXX07201999-1: Actually, just filter out the 85 - filtering the 84 crashes the system.}

  If (Pos('85', TempStr) <> 0)
    then
      begin
        LogException(E.Message, E.ClassName, '', ExceptAddr);
        (*Abort;*)
      end
    else
      begin
        MessageDlg(TempStr, mtError, [mbOK], 0);

        LogException(E.Message, E.ClassName, '', ExceptAddr);

      end;

    {FXX03031998-7: If there is an exception while the cursor is an hourglass,
                    let's be sure to set it back.}

  Screen.ActiveForm.Cursor := crDefault;

end;  {PASExceptionHandler}

{====================================================================}
Procedure TMainForm.PASMessageHandler(var Msg: TMsg;
                                      var Handled: Boolean);

{Intercept the print screen key and print.}
{CHG02271998-1: Allow print screen from all screens.}

{Note that the parcel screen printing must be done in ParcelTab itself
 because of the way the forms are shown - ParcelTabForm is always the
 active form. To do this, we will give a special tag to the ParcelTabForm
 exclusively so we can tell that that is the active form and don't process
 it in MainForm.  We cannot tell by the caption since the caption changes
 to reflect the mode and parcel ID.}

var
  TempNum : Word;
  I : Integer;
  TempFieldName, DataSourceName, TableName : String;
  Table : TTable;
  Form : TForm;

begin
    {FXX02091999-2: After a page up or down, the screen.activeform.tag equals
                    the tag of the child form displayed on the parcel tab notebook,
                    but the below instruction was supposed to filter out parcel
                    prints, and it was not.  So, we are also filtering out any screen
                    tag corresponding to a parcel page.}

  If ((Msg.Message = WM_KeyDown) and
      (Msg.wParam = VK_F3) and
      (Screen.ActiveForm.Tag <> ParcelTabFormTag) and
      ((Screen.ActiveForm.Tag < SummaryFormNumber) or
       (Screen.ActiveForm.Tag > PermitsFormNumber)))
    then
      begin
        PrintScreen(Application, Screen.ActiveForm);
        Handled := True;
      end;

end;  {PASMessageHandler}

{====================================================}
Procedure TMainForm.ActiveFormChange(Sender : TObject);

begin
  If ((not AppicationIsClosing) and
      (MDIChildCount = 0))
    then UserInfoPanel.Visible := True;
    
end;  {ActiveFormChange}

{====================================================}
Procedure TMainForm.FormCreate(Sender: TObject);

var
  Quit : Boolean;
  TempStr : String;
  AssessmentYearControlTable : TTable;
  I, ItemCount : Integer;
  MenuList : TList;

begin
  FormCaptions := TStringList.Create;
  AppicationIsClosing := False;

    {FXX03262001-1: Make sure the icon is loaded.}

  try
    Application.Icon.LoadFromFile('PAS32.ICO');
  except
  end;

  GlblApplicationIsClosing := False;

    {FXX10231998-2: In order to fix the problem that Peggy has been having, we will make a universal
                    dialogboxshowing var and not worry about the individual kind.}

  GlblDialogBoxShowing := False;

    {Replace the default exception handler with our own.}

  Application.OnException := PASExceptionHandler;

  Application.OnMessage := PASMessageHandler;

  UnitName := 'InquireOnlyUnit';
  GlblChildWindowCreateFailed := False;
  GlblApplicationIsClosing := False;
  GlblChangingTaxYear := False;
  GlblTaxYearFlg := ' ';

    {Initialize the global error dialog box.}

  GlblErrorDlgBox := TSCAErrorDialogBox.Create(Self);
  GlblErrorDlgBox.ShowSCAPhoneNumbers := True;

  GlblLastSwisSBLKey := '';
  GlblLastLocateKey := 1;

  SetTableNameToFastOpen(SysRecTable);

  try
    SysrecTable.Open;
  except
      {If they can not even open the system record, there are very
       serious problems. They probably are not connected to the
       network or they don't have rights because they are not logged
       in with the correct ID. So, we will tell them and terminate
       the application.}

    MessageDlg('Can not access network.' + #13 +
               'Please check that you are connected ' + #13 +
               'to the network with the proper user ID.' + #13 +
               'Please correct the problem and try again.',
               mtError, [mbOK], 0);
    LogException('', '', 'BTrieve error: ' + IntToStr(GetBtrieveError(SysRecTable)), nil);
    Application.Terminate;
  end;

    {Set up the date and time formats.}

  LongTimeFormat := 'h:mm AMPM';
  ShortDateFormat := 'm/d/yyyy';
  (*DateSeparator := '\';*)

    {Set up the dimensions for child forms.}

  ChildFormWidth := ClientWidth;
  ChildFormHeight := ClientHeight;

    {CHG10211997-4: Make it so that progress panel does not prevent
                    people from going to other apps.}

  Application.OnActivate := ApplicationActivate;

  try
    SysrecTable.First;
  except
    SystemSupport(001, SysRecTable, 'Error getting system record.',
                  UnitName, GlblErrorDlgBox);
    Application.Terminate;
  end;

    {FXX02091999-2: Move the setting of global system vars to
                    one proc.}

  SetGlobalSystemVariables(SysRecTable);

    {CHG10122000-1: In order to fix the print screen, I had to use Multi Image
                    and there are 2 DLLs - CRDE2000.DLL and ISP2000.DLL which
                    we will put in the application directory.  The following
                    variable allows us to put the DLLs where we want.}

  DLLPathName := ExpandPASPath(GlblProgramDir);

  VersionLabel.Caption := 'Version ' + GlblVersion;
(*  VersionLabel.Left := TitleLabel.Left + (TitleLabel.Width - VersionLabel.Width) DIV 2;*)

  with MunicipalityLabel do
    begin
      Caption := GetMunicipalityName;

      Left := (UserInfoPanel.Width - Width) DIV 2;

      Visible := True;

    end;  {with MunicipalityLabel do}

  MunicipalityLabel.Visible := True;

    {Now set the error file directory based on the system
     record.}

  GlblErrorDlgBox.ErrorFileDirectory := GlblDrive + ':' + GlblErrorFileDir;

  SysRecTable.Close;  {Close right away so hopefully don't get in use errors when all go in at once.}

  try
    GlblNameAddressTraceTable := TTable.Create(Self);

    OpenTableForProcessingType(GlblNameAddressTraceTable, 'AuditNameAddress',
                               GlblProcessingType, Quit);
    GlblNameAddressTraceTable.IndexName := 'BySwisSBLKey_Date_Time';
  except
    NonBtrvSystemSupport(003, 999, 'Error creating name \ address trace table.', UnitName, GlblErrorDlgBox);
    Application.Terminate;
  end;
  Screen.OnActiveFormChange := ActiveFormChange;
  Timer.Enabled := True;

end;  {FormCreate}

{====================================================}
Procedure TMainForm.OpenTablesInDataModuleTimerTimer(Sender: TObject);

{Open the tables in the data module on a timer so that they do not
 slow down the open.}

begin
  with PASDataModule do
    begin
      If ((Components[DataModuleComponentIndex] is TwwTable) and
          (Deblank(TwwTable(Components[DataModuleComponentIndex]).TableName) <> ''))
        then TwwTable(Components[DataModuleComponentIndex]).Open;

      DataModuleComponentIndex := DataModuleComponentIndex + 1;

      If (DataModuleComponentIndex > (ComponentCount - 1))
        then OpenTablesInDataModuleTimer.Enabled := False;

    end;  {with PASDataModule do}

end;  {OpenTablesInDataModuleTimerTimer}

{====================================================}
Procedure TMainForm.TimerTimer(Sender: TObject);

var
  Quit, Cancelled, Found, Laser : Boolean;
  I, ReturnCode : Integer;

begin
  Cancelled := False;
  Quit := False;
  Timer.Enabled := False;
  SetTableNameToFastOpen(UserProfileTable);

  try
    UserProfileTable.Open;
  except
    SystemSupport(005, UserProfileTable, 'Error opening user profile table.',
                  UnitName, GlblErrorDlgBox);
    Application.Terminate;
  end;

    {Now bring up the login dialog box. If they do not login successfully,
     terminate the application.}

  DataModuleComponentIndex := 0;
  OpenTablesInDataModuleTimer.Enabled := True;

  If LoginDlg.Execute
    then SetGlobalUserDefaults(UserProfileTable)
    else
      begin
        Application.Terminate;
        Cancelled := True;
      end;  {else of If LoginDlg.Execute}

  If not Cancelled
    then
      begin
          {CHG09172001-1: Allow the user profile and system record to be changed in the inquire.}

        If (Take(10, GlblUserName) = 'SUPERVISOR')
          then SystemMenuItem.Enabled := True;

          {Now show the tax year selection form and set appropriately.}
          {CHG11101997-1: Allow user to set dual processing.}

        ChooseTaxYearForm.CurrentTaxYearLabel := CurrentTaxYearLabel;
        ChooseTaxYearForm.MainFormTabSet := TabSet;
        ChooseTaxYearForm.FormCaptions := FormCaptions;
        ChooseTaxYearForm.ChangeThisYearandNextYearTogether := ChangeThisYearandNextYearTogether;
        ChooseTaxYearForm.ShowModal;

        Cancelled := (ChooseTaxYearForm.CloseResult = idCancel);

          {If they hit the cancel button, then we will close the
           application.}

        If Cancelled
          then Application.Terminate;

        GlblDisplaySystemExemptionConfirmation := True;

      end;  {If not Cancelled}

  If not Cancelled
    then
      begin
        UserIDLabel.Caption := 'ID = ' + GlblUserName;
        UserIDLabel.Left := (UserInfoPanel.Width - UserIDLabel.Width) DIV 2;
        UserIDLabel.Visible := True;
        CurrentTaxYearLabel.Caption := GetTaxYrLbl;
        CurrentTaxYearLabel.Visible := True;
        DateLabel.Caption := DateToStr(Date);
        DateLabel.Visible := True;

      end;  {If not Cancelled}

    {CHG10131998-1: Check for new printers.}

  If not Cancelled
    then
      begin
        InstalledPrinterTable.Open;

        For I := 0 to (Printer.Printers.Count - 1) do
          begin
            Found := FindKeyOld(InstalledPrinterTable,
                                ['PrinterName'],
                                [Trim(Printer.Printers[I])]);

            If not Found
              then
                begin
                  Laser := (MessageDlg('PAS detected a new printer or printer driver.' + #13 + #13 +
                                       'New Printer: ' + Printer.Printers[I] + #13 + #13 +
                                       'Is this printer a laser printer?', mtConfirmation,
                                       [mbYes, mbNo], 0) = mrYes);

                  with InstalledPrinterTable do
                    try
                      Insert;
                      FieldByName('PrinterName').Text := Printer.Printers[I];
                      FieldByName('Laser').AsBoolean := Laser;
                      Post;
                    except
                      SystemSupport(008, InstalledPrinterTable, 'Error adding rec to installed printer table.',
                                    UnitName, GlblErrorDlgBox);
                    end;

                end;  {If not Found}

          end;  {For I := 0 to (Printer.Printers.Count - 1) do}

        InstalledPrinterTable.Close;

      end;  {If not Cancelled}

    {FXX05021999-1: Place on page where to start address for windowed
                    envelope.}

  If not Cancelled
    then
      begin
        AssessorsOfficeTable.Open;
        SetGlobalAssessorsOfficeVariables(AssessorsOfficeTable);

      end;  {If not Cancelled}

    {CHG05131999-2: Let people look up parcels from the parcel list.}

  GlblLocateParcelFromList := False;

end;  {TimerTimer}

{====================================================}
Procedure TMainForm.ApplicationActivate(Sender: TObject);

var
  I : Integer;

begin
end;  {ApplicationActivate}

{====================================================================}
Function FindNumOccurrences(TabName : String) : Integer;

{Look through the list of Tabs for this Tab name. Note that the Tabs
 may have multiple occurrences of the same name, but it will have the
 instance number at the end, i.e. "Property Maintenance 2".}

var
  I, NumOccurrences : Integer;

begin
  NumOccurrences := 0;

  with MainForm do
    For I := 0 to (TabSet.Tabs.Count - 1) do
         {find the occurenc of Tabname string in Tabs string list}
         {excluding any qualifier such as 1,2,3 or owner name, etc }
      If (Pos(TabName, TabSet.Tabs[I]) <> 0)
        then NumOccurrences := NumOccurrences + 1;

  Result := NumOccurrences;

end;  {FindNumOccurrences}

{====================================================================}
Procedure ShowOccurrence(TabName : String);

{Show the form corresponding to this Tab name. To do this, we will search
 through the list of Tabs for the index of this Tab name. Then we will look in
 the form caption list to get the caption of the form. Then we will loop through the
 MDI children list to find the child with this caption. Once we find it, we will
 show it.}

var
  I, Index : Integer;
  Found : Boolean;
  TempStr : String;

begin
  Index := -1;

  with MainForm do
    begin
       {First get the index of the Tab with this name.}

      For I := 0 to (TabSet.Tabs.Count - 1) do
        If (TabName = TabSet.Tabs[I])
          then Index := I;

       {Now search for the child form with the caption corresponding to this
        Tab.}

      I := 0;
      Found := False;
                {MDICHIldcount = prop of MDI form}
            {FXX10071998-1: Must select which form to go to - if let Delphi do it,
                            sometimes get out of synch.}

      while ((I < MDIChildCount) and
             (not Found) and
             (MDIChildren[I] <> nil)) do
        begin
                                       {SCA memory list}
          If (Pos(FormCaptions[Index], MDIChildren[I].Caption) <> 0)
            then
              begin
                TempStr := ActiveMDIChild.Caption;

                  {Only show the form if it is not already the active form.}

                If ((Deblank(ActiveMDIChild.Caption) = '') or
                    (ActiveMDIChild.Caption <> MDIChildren[I].Caption))
                  then
                    begin
                        {Make sure that we hide the user info panel.}

                      If UserInfoPanel.Visible
                        then UserInfoPanel.Visible := False;

                      LockWindowUpdate(Handle);

                        {CHG05131999-2: Let people look up parcels from the parcel list.}
                        {Keep track of a parcel maint if it is active.}

                      If (MDIChildren[I] is TParcelTabForm)
                        then GlblParcelMaintenance := MDIChildren[I]
                        else GlblParcelMaintenance := nil;

                      MDIChildren[I].Show;
                      LockWindowUpdate(0);

                    end;  {If (ActiveMDIChild.Caption <> MDIChildren[I].Caption)}

                Found := True;

              end;  {If (MDIChildren[I].Caption = FormCaptions[Index])}

          I := I + 1;

        end;  {while ((I < MDIChildCount) and ...}

    end;  {with MainPASForm do}

end;  {ShowOccurrence}

{====================================================================}
Procedure AddTab(TabName, FormCaption : String);

{Add a new Tab at the end of the list. Also, we want to keep a list
 corresponding the Tab names to the caption names of the form that
 the Tab switches to. This way, we don't have to rely on the order of
 the MDI children.}

begin
  with MainForm do
    begin
      TabSet.Tabs.Add(TabName);
      FormCaptions.Add(FormCaption);
    end;

end;  {AddTab}

{====================================================================}
Procedure SelectTab(TabName : String);

{Based on the Tabname, highlight this Tab in the Tab set.}

var
  I : Integer;

begin
  with MainForm do
    For I := 0 to (TabSet.Tabs.Count - 1) do
      If (TabName = TabSet.Tabs[I])
           {setting the Tabset.TabIndex automatically hilites the Tab}
        then TabSet.TabIndex := I;

end;  {SelectTab}

{====================================================}
Procedure TMainForm.InquireClick(Sender: TObject);

var
  Child: TParcelTabForm;   {CCCCCCC}
  AllowMoreThanOneInstance : Boolean;
  TabName, Caption : String;
  Avail, NumOccurrences : Integer;

begin
  try
    LockWindowUpdate(Handle);  {Prevent drawing of child to avoid flicker.}
    Child := TParcelTabForm.Create(Application);   {CCCCCC}
    TParcelTabForm(Child).FormAccessRights := raReadOnly;
  except
    (*Abort;*)
  end;

  If GlblChildWindowCreateFailed
    then Child.Free
    else
      begin
        Child.WindowState := wsMaximized; {make child fit in parent window}

        Child.Caption := 'Parcel View:';

          {Set the Mode (A/M/V) property in the ParcelTabForm.}

        TParcelTabForm(Child)._EditMode := 'V';

          {If the user info panel is visible, then we want to hide it so
           that it does not show on top.}

        If UserInfoPanel.Visible
          then UserInfoPanel.Visible := False;

          {CHG05131999-2: Let people look up parcels from the parcel list.}
          {Keep track of a parcel maint if it is active.}

        GlblParcelMaintenance := Child;

        Child.Show;        {this shows my form}

      end;  {else of If GlblChildWindowCreateFailed}

  LockWindowUpdate(0);  {Now draw the child.}

  If GlblChildWindowCreateFailed
    then GlblChildWindowCreateFailed := False;

end;  {InquireClick}

{====================================================}
Procedure TMainForm.NormalMenuItemClick(Sender: TObject);

{CHG09172001-1: Allow the user profile and system record to be changed in the inquire.}

const
  UserProfile = 10020;
  SysRecMaint = 11020;

var
  Child: TForm;   {CCCCCC}
  Aborted, AllowMoreThanOneInstance : Boolean;
  TabName, Caption : String;
  I, Tag, NumOccurrences : Integer;

begin
  Tag := TComponent(Sender).Tag;
  Aborted := False;

  case Tag of
    UserProfile:
      begin
        AllowMoreThanOneInstance := False;
        TabName := 'User Profile';  {instance name for this form }
      end;

    SysRecMaint:
      begin
        AllowMoreThanOneInstance := False;     {CCCCCC}
        TabName := 'Sys Rec Maint';  {instance name for this form }  {CCCCCC}
      end;

  end;  {case Tag of}

  NumOccurrences := FindNumOccurrences(TabName);

    {Now if there are no forms of this type already visible, or there is and
     we allow multiple instances of this form, then create a new form. Otherwise,
     find the existing form and show it.}

  If ((NumOccurrences = 0) or
      ((NumOccurrences > 0) and
        AllowMoreThanOneInstance))
    then
      begin
        try
          Cursor := crHourglass;
          Application.ProcessMessages;
          LockWindowUpdate(Handle);

            {Create the form based on what kind we want. Also,
             each form has a public property called FormAccessRights
             which will be either raReadOnly or raReadWrite.
             (Note that it will not be raNoAccess since the menu
              item is disabled if there is no access). Then we
              will call the procedure InitializeForm. We are using
              this procedure rather than OnShow so that we can
              control the order of execution.}

          case Tag of {mmm}
            UserProfile:
              begin
                Child := TUserProfileForm.Create(Application);
                TUserProfileForm(Child).FormAccessRights := raReadWrite;
                TUserProfileForm(Child).InitializeForm;
              end;  {UserProfile}

            SysRecMaint:
              begin
                Child := TSysRecForm.Create(Application);
                TSysRecForm(Child).FormAccessRights := raReadWrite;
                TSysRecForm(Child).InitializeForm;
              end;  {SysRecMaint}

          end;  {case Tag of}

        except
          NonBtrvSystemSupport(011, 0, 'Error creating form.',
                               UnitName, GlblErrorDlgBox);
          (*Child.Free;*)
          Aborted := True;
        end;

        If not Aborted
          then
            begin
              Child.WindowState := wsMaximized; {make child fit in parent window}
              NumOccurrences := NumOccurrences + 1;

                {Now, if there is more than one occurrence of this form, then
                 we want to label the Tab and caption of the form with the number
                 of this occurrence.}

              If AllowMoreThanOneInstance
                then
                  begin
                    Child.Caption := Child.Caption + ' ' + IntToStr(NumOccurrences);
                    TabName := TabName + ' ' + IntToStr(NumOccurrences);
                  end;

                {Now add this Tab to the Tab set, and select it.}

              AddTab(TabName, Child.Caption);
              SelectTab(TabName);
                {If the user info panel is visible, then we want to hide it so
                 that it does not show on top.}

              If UserInfoPanel.Visible
                then UserInfoPanel.Visible := False;

                {CHG05131999-2: Let people look up parcels from the parcel list.}
                {Keep track of a parcel maint if it is active.}

              GlblParcelMaintenance := nil;

              Child.Show;        {this shows my form}
              LockWindowUpdate(0);  {Now draw the child.}
              Cursor := crDefault;

            end;  {If not Aborted}

      end
    else
      begin
        ShowOccurrence(TabName);
        SelectTab(TabName);
      end;

end;  {NormalMenuItemClick}

{====================================================}
Procedure TMainForm.ExitClick(Sender: TObject);

begin
  Close;
end;

{====================================================}
Procedure TMainForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);

begin
  CanClose := (MessageDlg('Are you sure you want to exit the Property Assessment System?',
                          mtConfirmation, [mbYes, mbNo], 0) = idYes)
end;

{====================================================}
Procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);

begin
  AppicationIsClosing := True;
  FormCaptions.Free;

  GlblNameAddressTraceTable.Close;
  GlblNameAddressTraceTable.Free;
  
  GlblApplicationIsClosing := True;
  GlblErrorDlgBox.Free;

end;  {FormClose}






end.
