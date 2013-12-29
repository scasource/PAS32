unit Security;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, DBCtrls, DBTables, DB, Buttons, Grids,
  Wwdbigrd, Wwdbgrid, ExtCtrls, Wwtable, Wwdatsrc, Menus, RPCanvas,
  RPrinter, RPDefine, RPBase, RPFiler;

type
  TMenuSecurityForm = class(TForm)
    MenuSecurityDataSource: TwwDataSource;
    MenuSecurityTable: TwwTable;
    Panel1: TPanel;
    Panel2: TPanel;
    TitleLabel: TLabel;
    MenuSecurityTableMenuID: TSmallintField;
    MenuSecurityTableMenuDescription: TStringField;
    MenuSecurityTableSecurityLevel: TSmallintField;
    MenuSecurityTableDisableIfUnderAccess: TBooleanField;
    ReportFiler: TReportFiler;
    ReportPrinter: TReportPrinter;
    PrintDialog: TPrintDialog;
    Panel3: TPanel;
    PrintButton: TBitBtn;
    DBNavigator: TDBNavigator;
    SynchButton: TButton;
    CloseButton: TBitBtn;
    MenuSecurityDBGrid: TwwDBGrid;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SynchButtonClick(Sender: TObject);
    procedure MenuSecurityTableSecurityLevelValidate(Sender: TField);
    procedure PrintButtonClick(Sender: TObject);
    procedure ReportPrintHeader(Sender: TObject);
    procedure ReportPrint(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
    UnitName : String;
  public
    { Public declarations }
    MainMenuIDs,
    MainMenuDescriptions : TStringList;
    FormAccessRights : Integer;  {Read only or read write, based on security level?}
                                {Values = raReadOnly, raReadWrite}
    Procedure InitializeForm;  {Open the tables and setup.}
  end;

var
  MenuSecurityForm: TMenuSecurityForm;

implementation

uses GlblVars, WinUtils, Utilitys, PASUTILS, UTILEXSD,  GlblCnst, ParclTab, UtilPrcl,
     Preview, PASTypes;

{$R *.DFM}

{========================================================}
Procedure TMenuSecurityForm.FormActivate(Sender: TObject);

begin
  SetFormStateMaximized(Self);
end;

{========================================================}
Procedure TMenuSecurityForm.InitializeForm;

begin
  UnitName := 'SECURITY.PAS';

    {Note that since this does not have anything to do with tax
     roll year, the only thing that determines the access rights
     for this form are the menu security levels.}

  If (FormAccessRights = raReadOnly)
    then MenuSecurityTable.ReadOnly := True;

  OpenTablesForForm(Self, GlblProcessingType);

    {If this is the SCA user ID, then we will allow insert on
     the navigator bar so that we can add menu ID's for the parcel
     popup menu.}

    {FXX01211998-5: Actually allow the supervisor to do this since no
                    backdoor has been created.}

    {CHG06092010-3(2.26.1)[I7208]: Allow for supervisor equivalents.}

  If UserIsSupervisor(GlblUserName)
    then
      begin
        DBNavigator.VisibleButtons := DBNavigator.VisibleButtons + [nbInsert, nbDelete];
        MenuSecurityTableMenuID.ReadOnly := False;
        MenuSecurityTableMenuDescription.ReadOnly := False;
        SynchButton.Visible := True;

      end;  {If (GlblUserName = Take(10, 'SCABOAT'))}

end;  {InitializeForm}

{===================================================================}
Procedure TMenuSecurityForm.SynchButtonClick(Sender: TObject);

var
  I, MenuID : Integer;
  Done, FirstTimeThrough, Found : Boolean;
  Form : TForm;
  TempStr : String;

begin
  Found := False;
  
   {CHG10191997-4: Add security entries for parcel pages.}

  Form := TParcelTabForm.Create(nil);

  with TParcelTabForm(Form) do
    For I := 0 to (ComponentCount - 1) do
      If ((Components[I] is TMenuItem) and
          (Components[I].Tag > 0))
        then
          with Components[I] as TMenuItem do
            begin
              MainMenuIDs.Add(IntToStr(Tag));

              TempStr := LTrim(Caption);

                {Add tags for residential and commercial.}

              If ((Tag >= ResidentialSiteFormNumber) and
                  (Tag <= ResidentialImprovementsFormNumber))
                then TempStr := 'Residential ' + TempStr;

              If ((Tag >= CommercialSiteFormNumber) and
                  (Tag <= CommercialIncomeExpenseFormNumber))
                then TempStr := 'Commercial ' + TempStr;

              MainMenuDescriptions.Add(StripChar(TempStr, '&', ' ', False));

            end;  {with Components[I] as TMenuItem do}

  Form.Free;

  MenuSecurityTableMenuID.ReadOnly := False;
  MenuSecurityTableMenuDescription.ReadOnly := False;
  MenuSecurityTable.DisableControls;

  For I := 0 to (MainMenuIDs.Count - 1) do
    begin
      MenuID := StrToInt(MainMenuIDs[I]);

      If ((MenuID > 0) and
          (MenuID < 20000))  {SCA system functions}
        then
          begin
            try
              Found := FindKeyOld(MenuSecurityTable, ['MenuID'],
                                  [IntToStr(MenuID)]);
            except
              SystemSupport(002, MenuSecurityTable, 'Error getting security record.',
                            UnitName, GlblErrorDlgBox);
            end;

              {FXX02191999-2: Fix duplicates error when doing synchronize.}

            If Found
              then
                begin
                    {If the name changed associated with this menu item, store the new name.}

                  If (MenuSecurityTableMenuDescription.Text <> Take(40, MainMenuDescriptions[I]))
                    then
                      begin
                        MenuSecurityTable.Edit;

                        MenuSecurityTableMenuDescription.Text := Take(40, MainMenuDescriptions[I]);
                        MenuSecurityTableSecurityLevel.AsInteger := 5;
                        MenuSecurityTableDisableIfUnderAccess.AsBoolean := False;

                        try
                          MenuSecurityTable.Post;
                        except
                          SystemSupport(003, MenuSecurityTable, 'Error posting to security table.',
                                        UnitName, GlblErrorDlgBox);
                          MenuSecurityTable.Cancel;
                        end;

                      end;  {If (MenuSecurityTableMenuDescription.Text <> Take(40, MainMenuDescriptions[I])}

                end
              else
                begin
                  MenuSecurityTable.Insert;

                  MenuSecurityTableMenuID.AsInteger := MenuID;
                  MenuSecurityTableMenuDescription.Text := Take(40, MainMenuDescriptions[I]);
                  MenuSecurityTableSecurityLevel.AsInteger := 5;
                  MenuSecurityTableDisableIfUnderAccess.AsBoolean := False;

                  try
                    MenuSecurityTable.Post;
                  except
                    SystemSupport(004, MenuSecurityTable, 'Error posting to security table.',
                                  UnitName, GlblErrorDlgBox);
                    MenuSecurityTable.Cancel;
                  end;

                end;  {If not Found}

          end;  {If (MenuID > 0)}

    end;  {with MainFormComponents[I] as TMenuItem}

    {Now we will go through the file and look in the list for
     these IDs. If they are not there, we will delete the record.
     This is for menu items that have been deleted.}

  FirstTimeThrough := True;
  Done := False;

  try
    MenuSecurityTable.First;
  except
    SystemSupport(005, MenuSecurityTable, 'Error getting 1st record in security table.',
                  UnitName, GlblErrorDlgBox);
  end;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else
        try
          MenuSecurityTable.Next;
        except
          SystemSupport(006, MenuSecurityTable, 'Error getting next record in security table.',
                        UnitName, GlblErrorDlgBox);
        end;

    If MenuSecurityTable.EOF
      then Done := True;

    If (MainMenuIDs.IndexOf(MenuSecurityTableMenuID.AsString) = -1)
      then
        try
          MenuSecurityTable.Delete;
        except
          SystemSupport(007, MenuSecurityTable, 'Error deleting record in security table.',
                        UnitName, GlblErrorDlgBox);
        end;

  until Done;

  MenuSecurityTableMenuID.ReadOnly := True;
  MenuSecurityTableMenuDescription.ReadOnly := True;
  MenuSecurityTable.First;
  MenuSecurityTable.EnableControls;

end;  {SynchButtonClick}

{==============================================================}
Procedure TMenuSecurityForm.MenuSecurityTableSecurityLevelValidate(Sender: TField);

begin
  If not (MenuSecurityTableSecurityLevel.AsInteger in [1..10])
    then
      begin
        MessageDlg('The security level must be between 1 and 10.', mtError, [mbOK], 0);
        RefreshNoPost(MenuSecurityTable);
      end;

end;  {MenuSecurityTableSecurityLevelValidate}

{=====================================================================}
Procedure TMenuSecurityForm.PrintButtonClick(Sender: TObject);

{FXX02191999-3: Add print capability to security levels.}

var
  Quit : Boolean;
  NewFileName : String;

begin
  Quit := False;

  If PrintDialog.Execute
    then
      begin
        PrintButton.Enabled := False;
        MenuSecurityTable.DisableControls;
        MenuSecurityTable.First;

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

        MenuSecurityTable.EnableControls;
        PrintButton.Enabled := True;

      end;  {If PrintDialog.Execute}

end;  {PrintButtonClick}

{=================================================================}
Procedure TMenuSecurityForm.ReportPrintHeader(Sender: TObject);

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
      PrintCenter('Menu Security Settings', (PageWidth / 2));
      Bold := False;
      CRLF;
      CRLF;

      Underline := True;
      ClearTabs;
      SetTab(0.3, pjLeft, 0.5, 0, BOXLINENONE, 0);   {Menu ID}
      SetTab(1.0, pjLeft, 3.0, 0, BOXLINENONE, 0);   {Desc}
      SetTab(4.1, pjLeft, 0.5, 0, BOXLINENONE, 0);   {Level}
      SetTab(4.7, pjLeft, 1.0, 0, BOXLINENONE, 0);   {Disable}

      Println(#9 + 'Menu ID' +
              #9 + 'Description' +
              #9 + 'Level' +
              #9 + 'Disable?');

      Underline := False;
      ClearTabs;
      SetTab(0.3, pjLeft, 0.5, 0, BOXLINENONE, 0);   {Menu ID}
      SetTab(1.0, pjLeft, 3.0, 0, BOXLINENONE, 0);   {Desc}
      SetTab(4.1, pjCenter, 0.5, 0, BOXLINENONE, 0);   {Level}
      SetTab(4.7, pjCenter, 1.0, 0, BOXLINENONE, 0);   {Disable}

    end;  {with Sender as TBaseReport do}

end;  {ReportPrintHeader}

{==============================================================}
Procedure TMenuSecurityForm.ReportPrint(Sender: TObject);

var
  TempStr : String;
  Done, FirstTimeThrough, Quit : Boolean;

begin
  Done := False;
  FirstTimeThrough := True;
  Quit := False;
  MenuSecurityTable.First;

  with Sender as TBaseReport do
    begin
        {First print the individual changes.}

      repeat
        If FirstTimeThrough
         then FirstTimeThrough := False
          else
            try
              MenuSecurityTable.Next;
            except
              Quit := True;
              SystemSupport(050, MenuSecurityTable, 'Error getting special fee rate record.',
                            UnitName, GlblErrorDlgBox);
            end;

        If MenuSecurityTable.EOF
          then Done := True;

          {Print the present record.}

        If not (Done or Quit)
          then
            begin
              with MenuSecurityTable do
                begin
                  TempStr := '';

                  If FieldByName('DisableIfUnderAccess').AsBoolean
                    then TempStr := 'X';

                  Println(#9 + FieldByName('MenuID').Text +
                          #9 + FieldByName('MenuDescription').Text +
                          #9 + FieldByName('SecurityLevel').Text +
                          #9 + TempStr);

                end;  {with MenuSecurityTable do}

                {If there is only one line left to print, then we
                 want to go to the next page.}

              If (LinesLeft < 3)
                then NewPage;

            end;  {If not (Done or Quit)}

      until (Done or Quit);

    end;  {with Sender as TBaseReport do}

end;  {ReportPrint}

{===================================================================}
Procedure TMenuSecurityForm.FormClose(    Sender: TObject;
                                      var Action: TCloseAction);

begin
  CloseTablesForForm(Self);

  MainMenuIDs.Free;
  MainMenuDescriptions.Free;

    {Free up the child window and set the ClosingAForm Boolean to
     true so that we know to delete the tab.}

  Action := caFree;
  GlblClosingAForm := True;
  GlblClosingFormCaption := Caption;

end;  {FormClose}



end.
