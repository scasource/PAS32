unit Raudnmad;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, DBCtrls,  DB, Buttons, Grids,
  Wwdbigrd, Wwdbgrid, ExtCtrls, Wwdatsrc, Menus,
  DBTables, Wwtable, Btrvdlg, RPFiler, RPBase, RPCanvas, RPrinter, Mask,
  Gauges, RPMemo, RPDBUtil, RPDefine, (*Progress,*) Types, RPTXFilr, PASTypes,
  Progress, TabNotBk, ComCtrls;

type
  TRptNameAddressAuditTrailForm = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    TitleLabel: TLabel;
    ReportPrinter: TReportPrinter;
    ReportFiler: TReportFiler;
    PrintDialog: TPrintDialog;
    SwisCodeTable: TwwTable;
    AuditNameAddressTrailTable: TwwTable;
    TextFiler: TTextFiler;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    SchoolCodeTable: TTable;
    ParcelTable: TTable;
    Panel3: TPanel;
    LoadButton: TBitBtn;
    SaveButton: TBitBtn;
    PrintButton: TBitBtn;
    CloseButton: TBitBtn;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    UserIDGroupBox: TGroupBox;
    Label9: TLabel;
    Label10: TLabel;
    StartUserEdit: TEdit;
    AllUsersCheckBox: TCheckBox;
    ToEndOfUsersCheckBox: TCheckBox;
    EndUserEdit: TEdit;
    SBLGroupBox: TGroupBox;
    Label11: TLabel;
    Label12: TLabel;
    StartSBLEdit: TEdit;
    EndSBLEdit: TEdit;
    AllSBLCheckBox: TCheckBox;
    ToEndOfSBLCheckBox: TCheckBox;
    DateGroupBox: TGroupBox;
    Label7: TLabel;
    Label8: TLabel;
    AllDatesCheckBox: TCheckBox;
    ToEndofDatesCheckBox: TCheckBox;
    EndDateEdit: TMaskEdit;
    StartDateEdit: TMaskEdit;
    IndexRadioGroup: TRadioGroup;
    CreateParcelListCheckBox: TCheckBox;
    TabSheet2: TTabSheet;
    Label6: TLabel;
    SwisCodeListBox: TListBox;
    SchoolCodeListBox: TListBox;
    Label21: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure TextReportBeforePrint(Sender: TObject);
    procedure TextReportPrintHeader(Sender: TObject);
    procedure SBLEditExit(Sender: TObject);
    procedure PrintButtonClick(Sender: TObject);
    procedure DateGroupBoxClick(Sender: TObject);
    procedure AllSBLCheckBoxClick(Sender: TObject);
    procedure AllUsersCheckBoxClick(Sender: TObject);
    procedure AllDatesCheckBoxClick(Sender: TObject);
    procedure CloseButtonClick(Sender: TObject);
    procedure TextReportPrint(Sender: TObject);
    procedure ReportPrint(Sender: TObject);
    procedure LoadButtonClick(Sender: TObject);
    procedure SaveButtonClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    ReportCancelled : Boolean;

    { Public declarations }
    UnitName : String;
    FormAccessRights : Integer;  {Read only or read write, based on security level?}
                                {Values = raReadOnly, raReadWrite}

    PrintAllUsers,
    PrintToEndOfUsers,
    CreateParcelList : Boolean;
    StartUser,
    EndUser : String;

    StartingSwisSBL,
    EndingSwisSBL : String;
    SelectedSchoolCodes,
    SelectedSwisCodes : TStringList;

    Procedure InitializeForm;  {Open the ScreenLabelTables and setup.}

    Function ValidSelectionInformation : Boolean;
    {Have they filled in enough information in the selection boxes to print?}

    Function RecordInRange(TempDate : TDateTime;
                           SwisSBLKey : String;
                           SchoolCode : String;
                           User : String) : Boolean;
    {Does this record fall within the set of parameters that they selected?}


  end;

implementation
Uses Utilitys,  {General utilitys}
     PASUTILS, UTILEXSD,   {PAS specific utilitys}
     GlblCnst,  {Global constants}
     GlblVars,  {Global variables}
     WinUtils,  {General Windows utilitys}
     Prog,
     RptDialg,
     PRCLLIST,
     Preview;

{$R *.DFM}

{========================================================}
Procedure TRptNameAddressAuditTrailForm.FormActivate(Sender: TObject);

begin
  SetFormStateMaximized(Self);
end;

{========================================================}
Procedure TRptNameAddressAuditTrailForm.InitializeForm;

begin
  UnitName := 'RAUDNMAD.PAS';  {mmm}

  OpenTablesForForm(Self, GlblProcessingType);

    {FXX01201998-10: Only let user Supervisor choose other users to
                     see the changes for.}

    {CHG06092010-3(2.26.1)[I7208]: Allow for supervisor equivalents.}

  If ((not UserIsSupervisor(GlblUserName)) and
      (not GlblAllowAuditAccessToAll))
    then
      begin
        UserIDGroupBox.Visible := False;

          {If not the supervisor, set the start and end ranges the same.}

        PrintAllUsers := False;
        PrintToEndOfUsers := False;
        StartUser := Take(10, GlblUserName);
        EndUser := Take(10, GlblUserName);

      end;  {If (GlblUserName <> 'SUPERVISOR')}

    {CHG12291999-1: Add swis \ school selection to audit reports.}

  FillOneListBox(SwisCodeListBox, SwisCodeTable, 'SwisCode',
                 'MunicipalityName', 25, True, True, GlblProcessingType, GetTaxRlYr);

  FillOneListBox(SchoolCodeListBox, SchoolCodeTable, 'SchoolCode',
                 'SchoolName', 25, True, True, GlblProcessingType, GetTaxRlYr);

end;  {InitializeForm}

{===================================================================}
Procedure TRptNameAddressAuditTrailForm.FormKeyPress(    Sender: TObject;
                                     var Key: Char);

begin
  If (Key = #13)
    then
      begin
        Key := #0;
        Perform(WM_NEXTDLGCTL, 0, 0);
      end;

end;  {FormKeyPress}

{================================================================}
Function TRptNameAddressAuditTrailForm.RecordInRange(TempDate : TDateTime;
                                                     SwisSBLKey : String;
                                                     SchoolCode : String;
                                                     User : String) : Boolean;

{Does this record fall within the set of parameters that they selected?}
{CHG01211998-3: Allow tracking of EX, SD deletions.}

var
  FieldName : String;
  SwisCode : String;

begin
  Result := True;
  SwisCode := Take(6, SwisSBLKey);

    {Now see if they are in the date range (if any) specified.}

  If not AllDatesCheckBox.Checked
    then
      begin
      FieldName := 'Date';

        If (TempDate < StrToDate(StartDateEdit.Text))
          then Result := False;

        If ((not ToEndOfDatesCheckBox.Checked) and
            (TempDate > StrToDate(EndDateEdit.Text)))
          then Result := False;

      end;  {else of If AllDatesCheckBox.Checked}

    {Now see if they are in the notes code range (if any) specified.}

  If not AllSBLCheckBox.Checked
    then
      begin
        If (Take(26, SwisSBLKey) < Take(26, StartingSWISSBL))
          then Result := False;

        If ((not ToEndOfSBLCheckBox.Checked) and
            (Take(26, SwisSBLKey) > Take(26, EndingSWISSBL)))
          then Result := False;

      end;  {else of If AllNotesCodesCheckBox.Checked}

    {Now see if they are in the user range (if any) specified.}

  If not PrintAllUsers
    then
      begin
        If (Take(10, User) < StartUser)
          then Result := False;

        If ((not ToEndOfUsersCheckBox.Checked) and
            (Take(10, User) > EndUser))
          then Result := False;

      end;  {else of If AllUsersCheckBox.Checked}

    {CHG12291999-1: Allow swis \ school selections in audits.}

  If (Result and
      ((SelectedSwisCodes.IndexOf(SwisCode) = -1) or
       (SelectedSchoolCodes.IndexOf(SchoolCode) = -1)))
    then Result := False;

end;  {RecordInRange}

{=====================================================================}
Function TRptNameAddressAuditTrailForm.ValidSelectionInformation : Boolean;

{Have they filled in enough information in the selection boxes to print?}

begin
  Result := True;

    {If they selected tickler or both note types, they need to fill in a notes
     status.}

  If ((Result and
      (IndexRadioGroup.ItemIndex = -1)))
    then
      begin
        MessageDlg('Please select a sort order (SBL, Date, or User)',
                   mtError, [mbOK], 0);
        Result := False;
      end;

    {Now make sure that the selections that they chose make sense. Note that if they do not
     select anything in a box, all is assumed, so we will check it.}

  If Result
    then
      If ((StartDateEdit.Text <> '  /  /    ') or
           (EndDateEdit.Text <> '  /  /    ') or
           AllDatesCheckBox.Checked or
           ToEndofDatesCheckBox.Checked)
        then
          begin
              {Make sure if they clicked to end of range that they put in a start range.}

            If ((ToEndofDatesCheckBox.Checked or
                 (EndDateEdit.Text <> '  /  /    ')) and
                (StartDateEdit.Text = '  /  /    '))
              then
                begin
                  MessageDlg('Please select a starting date or chose all dates.', mtError, [mbOK], 0);
                  Result := False;
                end;

              {Make sure that if they entered a start range, there is an end range.}

            If ((StartDateEdit.Text <> '  /  /    ') and
                ((EndDateEdit.Text = '  /  /    ') and
                 (not ToEndofDatesCheckBox.Checked)))
              then
                begin
                  MessageDlg('Please select an ending date or chose to print to the end of the dates on file.',
                             mtError, [mbOK], 0);
                  Result := False;
                end;

          end
        else AllDatesCheckBox.Checked := True;

  If Result
    then
      If ((Deblank(StartSBLEdit.Text) <> '') or
       (Deblank(EndSBLEdit.Text) <> '') or
       AllSBLCheckBox.Checked or
       ToEndofSBLCheckBox.Checked)
        then
          begin
              {Make sure if they clicked to end of range that they put in a start range.}

            If ((ToEndofSBLCheckBox.Checked or
                 (Deblank(EndSBLEdit.Text) <> '')) and
                (Deblank(StartSBLEdit.Text) = ''))
              then
                begin
                  MessageDlg('Please select a starting SBL or chose all SBL"s.', mtError, [mbOK], 0);
                  Result := False;
                end;

              {Make sure that if they entered a start range, there is an end range.}

            If ((Deblank(StartSBLEdit.Text) <> '') and
                ((Deblank(EndSBLEdit.Text) = '') and
                 (not ToEndofSBLCheckBox.Checked)))
              then
                begin
                  MessageDlg('Please select an ending SBL or chose to print to the end of the SBL"s on file.',
                             mtError, [mbOK], 0);
                  Result := False;
                end;

          end
        else AllSBLCheckBox.Checked := True;

    {Now check the user selections.}

  If Result
    then
      If ((Deblank(StartUserEdit.Text) <> '') or
           (Deblank(EndUserEdit.Text) <> '') or
           AllUsersCheckBox.Checked or
           ToEndofUsersCheckBox.Checked)
        then
          begin
              {Make sure if they clicked to end of range that they put in a start range.}

            If ((ToEndofUsersCheckBox.Checked or
                 (Deblank(EndUserEdit.Text) <> '')) and
                (Deblank(StartUserEdit.Text) = ''))
              then
                begin
                  MessageDlg('Please select a starting user or chose all users.', mtError, [mbOK], 0);
                  Result := False;
                end;

              {Make sure that if they entered a start range, there is an end range.}

            If ((Deblank(StartUserEdit.Text) <> '') and
                ((Deblank(EndUserEdit.Text) = '') and
                 (not ToEndofUsersCheckBox.Checked)))
              then
                begin
                  MessageDlg('Please select an ending user or chose to print to the end of the users on file.',
                             mtError, [mbOK], 0);
                  Result := False;
                end;

          end
        else AllUsersCheckBox.Checked := True;

end;  {ValidSelectionInformation}

{===================================================================}
Procedure TRptNameAddressAuditTrailForm.SBLEditExit(Sender: TObject);

var
  SwisSBLKey, SwisSBLEntry : String;
  ValidEntry : Boolean;

begin
  SwisSBLEntry := UpcaseStr(StartSBLEdit.Text);
  If (Deblank(SwisSBLENtry) <> '')
   then
   begin
   SwisSBLKey := ConvertSwisDashDotToSwisSBL(SwisSBLEntry,
           SwisCodeTable, ValidEntry);

   If NOT ValidEntry
     then
     begin
     MessageDlg('Invalid SBL. Please Re-Enter.',
                          mtError, [mbOK], 0);
     With Sender As Tedit do SetFocus;
     Abort;
     end;
   end;
end;

{===============================================================}
Procedure TRptNameAddressAuditTrailForm.DateGroupBoxClick(Sender: TObject);

begin
 If AllDatesCheckBox.Checked
    then
      begin
        ToEndofDatesCheckBox.Checked := False;
        ToEndofDatesCheckBox.Enabled := False;
        StartDateEdit.Text := '';
        StartDateEdit.Enabled := False;
        StartDateEdit.Color := clBtnFace;
        EndDateEdit.Text := '';
        EndDateEdit.Enabled := False;
        EndDateEdit.Color := clBtnFace;
      end
    else EnableSelectionsInGroupBoxOrPanel(DateGroupBox);

end;

{===========================================================================}
Procedure TRptNameAddressAuditTrailForm.AllSBLCheckBoxClick(Sender: TObject);

begin
 If AllSBLCheckBox.Checked
    then
      begin
        ToEndofSBLCheckBox.Checked := False;
        ToEndofSBLCheckBox.Enabled := False;
        StartSBLEdit.Text := '';
        StartSBLEdit.Enabled := False;
        StartSBLEdit.Color := clBtnFace;
        EndSBLEdit.Text := '';
        EndSBLEdit.Enabled := False;
        EndSBLEdit.Color := clBtnFace;
      end
    else EnableSelectionsInGroupBoxOrPanel(SBLGroupBox);

end;

{======================================================================}
Procedure TRptNameAddressAuditTrailForm.AllUsersCheckBoxClick(Sender: TObject);

begin
  If AllUsersCheckBox.Checked
    then
      begin
        ToEndofUsersCheckBox.Checked := False;
        ToEndofUsersCheckBox.Enabled := False;
        StartUserEdit.Text := '';
        StartUserEdit.Enabled := False;
        StartUserEdit.Color := clBtnFace;
        EndUserEdit.Text := '';
        EndUserEdit.Enabled := False;
        EndUserEdit.Color := clBtnFace;
      end
    else EnableSelectionsInGroupBoxOrPanel(UserIdGroupBox);

end;

{==========================================================================}
Procedure TRptNameAddressAuditTrailForm.AllDatesCheckBoxClick(Sender: TObject);

begin
 If AllDatesCheckBox.Checked
    then
      begin
        ToEndofDatesCheckBox.Checked := False;
        ToEndofDatesCheckBox.Enabled := False;
        StartDateEdit.Text := '';
        StartDateEdit.Enabled := False;
        StartDateEdit.Color := clBtnFace;
        EndDateEdit.Text := '';
        EndDateEdit.Enabled := False;
        EndDateEdit.Color := clBtnFace;
      end
    else EnableSelectionsInGroupBoxOrPanel(DateGroupBox);

end;

{===============================================================}
Procedure TRptNameAddressAuditTrailForm.CloseButtonClick(Sender: TObject);

begin
  Close;
end;

{====================================================================}
Procedure TRptNameAddressAuditTrailForm.SaveButtonClick(Sender: TObject);

{FXX04091999-8: Add ability to save and load search report options.}

begin
  SaveReportOptions(Self, OpenDialog, SaveDialog, 'nmaudit.nad', 'Name \ Address Audit Trail Report');

end;  {SaveButtonClick}

{====================================================================}
Procedure TRptNameAddressAuditTrailForm.LoadButtonClick(Sender: TObject);

{FXX04091999-8: Add ability to save and load search report options.}

begin
  LoadReportOptions(Self, OpenDialog, 'nmaudit.nam', 'Name \ Address Audit Trail Report');

end;  {LoadButtonClick}

{========================================================================}
{==================  PRINTING  ==========================================}
{======================================================================}
Procedure TRptNameAddressAuditTrailForm.PrintButtonClick(Sender: TObject);

var
  TextFileName, NewFileName : String;
  Quit : Boolean;
  I : Integer;

begin
  ReportCancelled := False;
  Quit := False;

    {CHG10121998-1: Add user options for default destination and show vet max msg.}

  SetPrintToScreenDefault(PrintDialog);

  If (ValidSelectionInformation and
      PrintDialog.Execute)
    then
      begin
        CreateParcelList := CreateParcelListCheckBox.Checked;
        If CreateParcelList
          then ParcelListDialog.ClearParcelGrid(True);

        SelectedSwisCodes := TStringList.Create;
        SelectedSchoolCodes := TStringList.Create;

          {CHG12291999-1: Allow for school \ swis selection.}

        SelectedSwisCodes.Clear;

        For I := 0 to (SwisCodeListBox.Items.Count - 1) do
          If SwisCodeListBox.Selected[I]
            then SelectedSwisCodes.Add(Take(6, SwisCodeListBox.Items[I]));

        SelectedSchoolCodes.Clear;

        For I := 0 to (SchoolCodeListBox.Items.Count - 1) do
          If SchoolCodeListBox.Selected[I]
            then SelectedSchoolCodes.Add(Take(6, SchoolCodeListBox.Items[I]));

          {FXX10071999-1: To solve the problem of printing to the high speed,
                          we need to set the font to a TrueType even though it
                          doesn't matter in the actual printing.  The reason for this
                          is that without setting it, the default font is System for
                          the Generic printer which has a baseline descent of 0.5
                          which messes up printing to a text file.  We needed a font
                          with no descent.}

        TextFiler.SetFont('Courier New', 10);

          {CHG10131998-1: Set the printer settings based on what printer they selected
                          only - they no longer need to worry about paper or landscape
                          mode.}

        AssignPrinterSettings(PrintDialog, ReportPrinter, ReportFiler, [ptBoth], False, Quit);

        If not Quit
          then
            begin
              ProgressDialog.UserLabelCaption := '';
              ProgressDialog.Start(GetRecordCount(AuditNameAddressTrailTable), True, True);

               {FXX01201998-10: Only let user Supervisor choose other users to
                                see the changes for.}

                {CHG06092010-3(2.26.1)[I7208]: Allow for supervisor equivalents.}

              If UserIsSupervisor(GlblUserName)
                then
                  begin
                    PrintAllUsers := AllUsersCheckBox.Checked;
                    PrintToEndOfUsers := ToEndOfUsersCheckBox.Checked;
                    StartUser := Take(10, StartUserEdit.Text);
                    EndUser := Take(10, EndUserEdit.Text);

                  end;  {If (GlblUserName = Take(10, 'SUPERVISOR')}

                {CHG02282001-1: Allow everybody to everyone elses changes.}

              If GlblAllowAuditAccessToAll
                then PrintAllUsers := True;

                {Now print the report.}

              If not (Quit or ReportCancelled)
                then
                  begin
                    GlblPreviewPrint := False;

                      {If they want to preview the print (i.e. have it
                       go to the screen), then we need to come up with
                       a unique file name to tell the ReportFiler
                       component where to put the output.
                       Once we have done that, we will execute the
                       report filer which will print the report to
                       that file. Then we will create and show the
                       preview print form and give it the name of the
                       file. When we are done, we will delete the file
                       and make sure that we go back to the original
                       directory.}

                      {FXX07221998-1: So that more than one person can run the report
                                      at once, use a time based name first and then
                                      rename.}

                    TextFileName := GetPrintFileName(Self.Caption, True);
                    TextFiler.FileName := TextFileName;

                      {FXX01211998-1: Need to set the LastPage property so that
                                      long rolls aren't a problem.}

                    TextFiler.LastPage := 30000;

                    TextFiler.Execute;
                    ProgressDialog.StartPrinting(PrintDialog.PrintToFile);

                      {If they want to see it on the screen, start the preview.}

                    If PrintDialog.PrintToFile
                      then
                        begin
                          GlblPreviewPrint := True;
                          NewFileName := GetPrintFileName(Self.Caption, True);
                          ReportFiler.FileName := NewFileName;

                          try
                            PreviewForm := TPreviewForm.Create(self);
                            PreviewForm.FilePrinter.FileName := NewFileName;
                            PreviewForm.FilePreview.FileName := NewFileName;

                            PreviewForm.FilePreview.ZoomFactor := 130;

                            ReportFiler.Execute;

                              {FXX09071999-6: Tell people that printing is starting and
                                              done.}

                            ProgressDialog.StartPrinting(PrintDialog.PrintToFile);

                            PreviewForm.ShowModal;
                          finally
                            PreviewForm.Free;
                          end;

                            {Delete the report printer file.}

                          try
                            Chdir(GlblReportDir);
                            OldDeleteFile(NewFileName);
                          except
                          end;

                        end
                      else ReportPrinter.Execute;

                      {CHG01182000-3: Allow them to choose a different name or copy right away.}

                    ShowReportDialog('AUDNMADR.RPT', TextFiler.FileName, True);

                  end;  {If not Quit}

                {Clear the selections.}

              ProgressDialog.Finish;

                {FXX09071999-6: Tell people that printing is starting and
                                done.}

              DisplayPrintingFinishedMessage(PrintDialog.PrintToFile);


              If CreateParcelList
                then ParcelListDialog.Show;

            end;  {If not Quit}

        SelectedSwisCodes.Free;
        SelectedSchoolCodes.Free;

        ResetPrinter(ReportPrinter);

      end;  {If PrintDialog.Execute}

end;  {PrintButtonClick}

{====================================================================}
Procedure TRptNameAddressAuditTrailForm.TextReportBeforePrint(Sender: TObject);

var
  ValidEntry : Boolean;

begin
  If not AllSBLCheckBox.Checked
    then
      begin
        StartingSwisSBL := ConvertSwisDashDotToSwisSBL(StartSBLEdit.Text,
                                                       SwisCodeTable, ValidEntry);

        If ToEndOfSBLCheckBox.Checked
          then EndingSwisSBL := TAke(26,'ZZZZZZZZZZZZZZZZZZZZZZZZZZ')
          else EndingSwisSBL := ConvertSwisDashDotToSwisSBL(EndSBLEdit.Text,
                                                            SwisCodeTable, ValidEntry);
      end;

     {FXX01211998-9: Removed taxrollyear from key - they want to see
                     changes from either year.}
     {CHG01211998-3: Allow tracking of EX, SD deletions.}

  with Sender as TBaseReport do
    begin
      with AuditNameAddressTrailTable do
        case IndexRadioGroup.ItemIndex of
          0 : begin  {SBL}
                IndexName := 'BYSWISSBLKEY_DATE_TIME';

                If not AllSBLCheckBox.Checked
                  then SetRangeOld(AuditNameAddressTrailTable,
                                   ['SwisSBLKey', 'Date', 'Time'],
                                   [StartingSwisSBL, '1/1/1900', ''],
                                   [EndingSwisSBL, '1/1/2300', '']);

              end;   {SBL}

          1 : begin  {Date }
                IndexName := 'BYDATE_TIME_SWISSBLKEY';

                  {Set a range if they specified a range.}
                  {FXX01132000-1: Don't put an end range if they want to end of range.}
                  {FXX01132000-2: Actually as a Y2K fix, will just search until after end of
                                  end date.}

                If not AllDatesCheckBox.Checked
                  then FindNearestOld(AuditNameAddressTrailTable,
                                      ['Date', 'Time', 'SwisSBLKey'],
                                      [StartDateEdit.Text, '', '']);

              end;   {Date }

          2 : begin  {User}
                IndexName := 'BYUSER_DATE_TIME';

                  {Set a range if they specified a range.}

                If not AllUsersCheckBox.Checked
                  then
                   If ToEndofDatesCheckBox.Checked
                      then SetRangeOld(AuditNameAddressTrailTable,
                                       ['User', 'Date', 'Time'],
                                       [StartUserEdit.Text, '1/1/1900', ''],
                                       [EndUserEdit.Text, '1/1/2300', ''])
                      else SetRangeOld(AuditNameAddressTrailTable,
                                       ['User', 'Date', 'Time'],
                                       [StartUserEdit.Text, '1/1/1900', ''],
                                       [EndUserEdit.Text, '1/1/2300', '']);

              end; {User}

        end;  {case IndexRadioGroup of}

         {Get the first record.}

      If ((IndexRadioGroup.ItemIndex in [0, 2]) or
          AllDatesCheckBox.Checked)
        then AuditNameAddressTrailTable.First;

    end;  {with Sender as TBaseReport do}

end;  {ReportFilerBeforePrint}

{====================================================================}
Procedure TRptNameAddressAuditTrailForm.TextReportPrintHeader(Sender: TObject);

begin
  with Sender as TBaseReport do
    begin
      ClearTabs;
      SetTab(0.3, pjLeft, 8.0, 0, BoxLineNone, 0);

        {Print the date and page number.}

      Println(#9 + UpcaseStr(Take(26, GetMunicipalityName)) +
              Center('Name \ Address Audit Trail Report', 27) +
              RightJustify('Page: ' + IntToStr(CurrentPage), 27));

      Println(#9 + RightJustify('Date: ' + DateToStr(Date) +
                           '  Time: ' + FormatDateTime(TimeFormat, Now), 78));

      ClearTabs;
      SetTab(0.4, pjLeft, 8, 0, BOXLINENONE, 0);   {Index}

        {Print the selection information.}

      Print(#9 + 'Index:  ');
      case IndexRadioGroup.ItemIndex of
        0 : Println(' SBL');
        1 : Println(' Date');
        2 : Println(' User');
      end;  {case IndexRadioGroup of}

      Print(#9 + 'For Dates: ');
      If AllDatesCheckBox.Checked
        then Println(' All')
        else
          begin
            Println(' ' + StartDateEdit.Text + ' to ');

            If ToEndOfDatesCheckBox.Checked
              then Println(' End')
              else Println(' ' + EndDateEdit.Text);

          end;  {else of If AllDatesCheckBox.Checked}

      Print(#9 + 'For Users: ');
      If PrintAllUsers
        then Println(' All')
        else
          begin
            Print(' ' + RTrim(StartUser) + ' to ');

            If PrintToEndOfUsers
              then Println(' End')
              else Println(' ' + EndUser);

          end;  {else of If PrintAllUsers}

      Print(#9 + 'For Parcel IDs: ');

      If AllSBLCheckBox.Checked
        then Println(' All')
        else
          begin
            Print(' ' + RTrim(StartSBlEdit.Text) + ' to ');

            If ToEndOfSBLCheckBox.Checked
              then Println(' End')
              else Println(' ' + EndSBLEdit.Text);

          end;  {else of If AllSBLSCheckBox.Checked}

      Println('');

    end;  {with Sender as TBaseReport do}

end;  {ReportFilerPrintHeader}

{====================================================================}
Procedure TRptNameAddressAuditTrailForm.TextReportPrint(Sender: TObject);

var
  Done, FirstTimeThrough, Quit : Boolean;
  SwisSBLKey : String;
  SBLRec : SBLRecord;
  TempDate : TDateTime;
  OldNameAddrArray, NewNameAddrArray : NameAddrArray;
  I : Integer;
  NumChanged : LongInt;

begin
  Done := False;
  FirstTimeThrough := True;
  Quit := False;
  NumChanged := 0;

    {CHG03161998-1: Track exemption, SD adds, av changes, parcel add/del.}

  with Sender as TBaseReport do
    begin
        {First print the individual changes.}

      repeat
        If FirstTimeThrough
          then FirstTimeThrough := False
          else AuditNameAddressTrailTable.Next;

        TempDate := AuditNameAddressTrailTable.FieldByName('Date').AsDateTime;

        If (AuditNameAddressTrailTable.EOF or
            ((IndexRadioGroup.ItemIndex = 1) and
             (not AllDatesCheckBox.Checked) and
             (not ToEndofDatesCheckBox.Checked) and
             (TempDate > StrToDate(EndDateEdit.Text))))
          then Done := True;

          {Print the present record.}

        If not (Done or Quit)
          then
            begin
              Application.ProcessMessages;

              {Update the progress panel.}

              with AuditNameAddressTrailTable do
                case IndexRadioGroup.ItemIndex of
                  0 : ProgressDialog.Update(Self,
                                            ConvertSwisSBLToDashDot(FieldByName('SwisSBLKey').Text));
                  1 : ProgressDialog.Update(Self, FieldByName('Date').Text);
                  2 : ProgressDialog.Update(Self, FieldByName('User').Text);

                end;  {case IndexRadioGroup.ItemIndex of}

              SBLRec := ExtractSwisSBLFromSwisSBLKey(AuditNameAddressTrailTable.FieldByName('SwisSBLKey').Text);

              with SBLRec do
                FindKeyOld(ParcelTable,
                           ['TaxRollYr', 'SwisCode', 'Section',
                            'Subsection', 'Block', 'Lot',
                            'Sublot', 'Suffix'],
                           [GetTaxRlYr, SwisCode, Section, Subsection,
                            Block, Lot, Sublot, Suffix]);

              with AuditNameAddressTrailTable do
                If RecordInRange(FieldByName('Date').AsDateTime,
                                 FieldByName('SwisSBLKey').Text,
                                 ParcelTable.FieldByName('SchoolCode').Text,
                                 FieldByName('User').Text)
                  then
                    begin
                      NumChanged := NumChanged + 1;
                      ClearTabs;
                      SetTab(0.4, pjLeft, 3.0, 0, BOXLINENONE, 0);   {Col 1}
                      Println(#9 + ConstStr('-', 10) + '  ' +
                                   ConvertSwisSBLToDashDot(FieldByName('SwisSBLKey').Text) + '  ' +
                                   ConstStr('-', 40));

                      ClearTabs;
                      SetTab(0.4, pjLeft, 4.0, 0, BOXLINENONE, 0);   {Col 1}
                      SetTab(4.2, pjLeft, 4.0, 0, BOXLINENONE, 0);   {Col 2}
                      Println(#9 + 'User: ' + FieldByName('User').Text +
                              #9 + 'Date\Time Changed: ' + FieldByName('Date').Text +
                                   ' ' + FormatDateTime(TimeFormat, FieldByName('Time').AsDateTime));
                      Println(#9 + 'Date Checked Off: ' + FieldByName('DateCheckedOff').Text);

                      Println('');
                      ClearTabs;
                      SetTab(0.4, pjCenter, 3.0, 0, BOXLINENONE, 0);   {Col 1}
                      SetTab(4.0, pjCenter, 3.0, 0, BOXLINENONE, 0);   {Col 2}
                      Println(#9 + 'Old Address' +
                              #9 + 'New Address');

                      ClearTabs;
                      SetTab(0.4, pjLeft, 3.0, 0, BOXLINENONE, 0);   {Col 1}
                      SetTab(4.0, pjLeft, 3.0, 0, BOXLINENONE, 0);   {Col 2}

                      FillInNameAddrArray(FieldByName('OldName1').Text,
                                          FieldByName('OldName2').Text,
                                          FieldByName('OldAddress1').Text,
                                          FieldByName('OldAddress2').Text,
                                          FieldByName('OldStreet').Text,
                                          FieldByName('OldCity').Text,
                                          FieldByName('OldState').Text,
                                          FieldByName('OldZip').Text,
                                          FieldByName('OldZipPlus4').Text,
                                          True, False, OldNameAddrArray);

                      FillInNameAddrArray(FieldByName('NewName1').Text,
                                          FieldByName('NewName2').Text,
                                          FieldByName('NewAddress1').Text,
                                          FieldByName('NewAddress2').Text,
                                          FieldByName('NewStreet').Text,
                                          FieldByName('NewCity').Text,
                                          FieldByName('NewState').Text,
                                          FieldByName('NewZip').Text,
                                          FieldByName('NewZipPlus4').Text,
                                          True, False, NewNameAddrArray);

                      For I := 1 to 6 do
                        If ((Deblank(OldNameAddrArray[I]) <> '') or
                            (Deblank(NewNameAddrArray[I]) <> ''))
                          then Println(#9 + OldNameAddrArray[I] +
                                       #9 + NewNameAddrArray[I]);

                      Println('');

                      If (CreateParcelList and
                          (not ParcelListDialog.ParcelExistsInList(SwisSBLKey)))
                        then ParcelListDialog.AddOneParcel(SwisSBLKey);

                    end;  {with AuditNameAddressTrailTable do}

                {If there is only one line left to print, then we
                 want to go to the next page.}

              If (LinesLeft < 14)
                then NewPage;

              SwisSBLKey := AuditNameAddressTrailTable.FieldByName('SwisSBLKey').Text;

            end;  {If not (Done or Quit)}

        ReportCancelled := ProgressDialog.Cancelled;

      until (Done or Quit or ReportCancelled);

        {FXX01231998-5: Tell them if nothing in range.}

      If (NumChanged = 0)
        then Println('None.');

    end;  {with Sender as TBaseReport do}

end;  {ReportPrinterPrint}

{===========================================================}
Procedure TRptNameAddressAuditTrailForm.ReportPrint(Sender: TObject);

{FXX02181999-3: Changed the audit trail so it could go to dot matrix.}

var
  ReportTextFile : TextFile;

begin
  AssignFile(ReportTextFile, TextFiler.FileName);
  Reset(ReportTextFile);

        {CHG12211998-1: Add ability to select print range.}

  PrintTextReport(Sender, ReportTextFile, PrintDialog.FromPage,
                  PrintDialog.ToPage);

  CloseFile(ReportTextFile);

end;  {ReportPrint}

{===================================================================}
Procedure TRptNameAddressAuditTrailForm.FormClose(    Sender: TObject;
                                  var Action: TCloseAction);

begin
  CloseTablesForForm(Self);

    {Free up the child window and set the ClosingAForm Boolean to
     true so that we know to delete the tab.}

  Action := caFree;

  GlblClosingAForm := True;
  GlblClosingFormCaption := Caption;

end;  {FormClose}


end.