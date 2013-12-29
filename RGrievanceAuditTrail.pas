unit RGrievanceAuditTrail;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, DBCtrls,  DB, Buttons, Grids,
  Wwdbigrd, Wwdbgrid, ExtCtrls, Wwdatsrc, Menus,
  DBTables, Wwtable, Btrvdlg, RPFiler, RPBase, RPCanvas, RPrinter, Mask,
  Gauges, RPMemo, RPDBUtil, RPDefine, (*Progress,*) Types, RPTXFilr, PASTypes,
  Progress, TabNotBk, ComCtrls;

type
  TGrievanceAuditTrailForm = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    ScrollBox: TScrollBox;
    CloseButton: TBitBtn;
    TitleLabel: TLabel;
    ReportPrinter: TReportPrinter;
    ReportFiler: TReportFiler;
    PrintDialog: TPrintDialog;
    SwisCodeTable: TwwTable;
    PrintButton: TBitBtn;
    LoadButton: TBitBtn;
    SaveButton: TBitBtn;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    TabbedNotebook1: TTabbedNotebook;
    IndexRadioGroup: TRadioGroup;
    CreateParcelListCheckBox: TCheckBox;
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
    Label6: TLabel;
    SwisCodeListBox: TListBox;
    SchoolCodeListBox: TListBox;
    Label21: TLabel;
    SchoolCodeTable: TTable;
    Label4: TLabel;
    GrievanceYearEdit: TEdit;
    ParcelTable: TTable;
    GrievanceAuditTrailTable: TwwTable;
    ShowValueChangeDetailsCheckBox: TCheckBox;
    GrievanceResultsTable: TwwTable;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure ReportPrintHeader(Sender: TObject);
    procedure SBLEditExit(Sender: TObject);
    procedure PrintButtonClick(Sender: TObject);
    procedure AllSBLCheckBoxClick(Sender: TObject);
    procedure AllUsersCheckBoxClick(Sender: TObject);
    procedure AllDatesCheckBoxClick(Sender: TObject);
    procedure CloseButtonClick(Sender: TObject);
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

    PrintAllUsers,
    PrintToEndOfUsers,
    CreateParcelList : Boolean;
    StartUser,
    EndUser : String;

    StartingSwisSBL,
    EndingSwisSBL : String;
    SelectedSchoolCodes,
    SelectedSwisCodes : TStringList;

    GrievanceYear : String;
    ShowDetails : Boolean;

    Procedure InitializeForm;  {Open the ScreenLabelTables and setup.}

    Function ValidSelectionInformation : Boolean;
    {Have they filled in enough information in the selection boxes to print?}

    Function RecordInRange(TempDate : TDateTime;
                           SwisSBLKey : String;
                           SchoolCode : String;
                           Users : String;
                           _GrievanceYear : String) : Boolean;
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
     GrievanceUtilitys,
     Preview;

const
  ayThisYear = 0;
  ayNextYear = 1;
  ayAllYears = 2;

{$R *.DFM}

{========================================================}
Procedure TGrievanceAuditTrailForm.FormActivate(Sender: TObject);

begin
  SetFormStateMaximized(Self);
end;

{========================================================}
Procedure TGrievanceAuditTrailForm.InitializeForm;

begin
  UnitName := 'RGrievanceAuditTrail';  {mmm}
  GrievanceYearEdit.Text := DetermineGrievanceYear;

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
Procedure TGrievanceAuditTrailForm.FormKeyPress(    Sender: TObject;
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
Function TGrievanceAuditTrailForm.RecordInRange(TempDate : TDateTime;
                                                SwisSBLKey : String;
                                                SchoolCode : String;
                                                Users : String;
                                                _GrievanceYear : String) : Boolean;

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
        If (Take(10, Users) < StartUser)
          then Result := False;

        If ((not ToEndOfUsersCheckBox.Checked) and
            (Take(10, Users) > EndUser))
          then Result := False;

      end;  {else of If AllUsersCheckBox.Checked}

    {CHG12291999-1: Allow swis \ school selections in audits.}

  If (Result and
      (((Deblank(SwisCode) <> '') and
         (SelectedSwisCodes.IndexOf(SwisCode) = -1)) or
       (SelectedSchoolCodes.IndexOf(SchoolCode) = -1)))
    then Result := False;

  If (Result and
      (GrievanceYear <> _GrievanceYear))
    then Result := False;

end;  {RecordInRange}

{=====================================================================}
Function TGrievanceAuditTrailForm.ValidSelectionInformation : Boolean;

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

{=====================================================================}
Procedure TGrievanceAuditTrailForm.SBLEditExit(Sender: TObject);

var
  SwisSBLKey, SwisSBLEntry : String;
  ValidEntry : Boolean;

begin
  SwisSBLEntry := UpcaseStr(StartSBLEdit.Text);

  If (Deblank(SwisSBLEntry) <> '')
    then
      begin
        SwisSBLKey := ConvertSwisDashDotToSwisSBL(SwisSBLEntry,
                                                  SwisCodeTable, ValidEntry);

       If not ValidEntry
         then
           begin
             MessageDlg('Invalid SBL. Please Re-Enter.',
                        mtError, [mbOK], 0);
             with Sender as TEdit do
               SetFocus;

           end;  {If not ValidEntry}

      end;  {If (Deblank(SwisSBLEntry) <> '')}

end;  {SBLEditExit}

{=====================================================================}
Procedure TGrievanceAuditTrailForm.AllSBLCheckBoxClick(Sender: TObject);

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

end;  {AllSBLCheckBoxClick}

{=====================================================================}
Procedure TGrievanceAuditTrailForm.AllUsersCheckBoxClick(Sender: TObject);

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

end;  {AllUsersCheckBoxClick}

{=====================================================================}
Procedure TGrievanceAuditTrailForm.AllDatesCheckBoxClick(Sender: TObject);

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

end;  {AllDatesCheckBoxClick}

{====================================================================}
Procedure TGrievanceAuditTrailForm.SaveButtonClick(Sender: TObject);

{FXX04091999-8: Add ability to save and load search report options.}

begin
  SaveReportOptions(Self, OpenDialog, SaveDialog, 'Grievance Audit.GAD', 'Grievance Audit Trail Report');

end;  {SaveButtonClick}

{====================================================================}
Procedure TGrievanceAuditTrailForm.LoadButtonClick(Sender: TObject);

{FXX04091999-8: Add ability to save and load search report options.}

begin
  LoadReportOptions(Self, OpenDialog, 'Grievance Audit.GAD', 'Grievance Audit Trail Report');

end;  {LoadButtonClick}

{========================================================================}
{==================  PRINTING  ==========================================}
{======================================================================}
Procedure TGrievanceAuditTrailForm.PrintButtonClick(Sender: TObject);

var
  NewFileName : String;
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

        ShowDetails := ShowValueChangeDetailsCheckBox.Checked;
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

          {CHG10131998-1: Set the printer settings based on what printer they selected
                          only - they no longer need to worry about paper or landscape
                          mode.}

        AssignPrinterSettings(PrintDialog, ReportPrinter, ReportFiler, [ptBoth], True, Quit);

        If not Quit
          then
            begin
              ProgressDialog.UserLabelCaption := '';
              ProgressDialog.Start(GetRecordCount(GrievanceAuditTrailTable), True, True);

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

              GrievanceYear := GrievanceYearEdit.Text;

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

                    ShowReportDialog('Grievance Audit Trail.RPT', ReportFiler.FileName, True);

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
Procedure TGrievanceAuditTrailForm.ReportPrintHeader(Sender: TObject);

begin
  with Sender as TBaseReport do
    begin
      ClearTabs;
      Bold := True;

      SetTab(0.3, pjLeft, 13.0, 0, BoxLineNone, 0);

        {Print the date and page number.}

      SectionTop := 0.25;
      SectionLeft := 0.5;
      SectionRight := PageWidth - 0.5;
      SetFont('Times New Roman',8);
      PrintHeader('Page: ' + IntToStr(CurrentPage), pjRight);
      PrintHeader('Date: ' + DateToStr(Date) + '  Time: ' + TimeToStr(Now), pjLeft);
      Println('');

      SetFont('Times New Roman',14);
      ClearTabs;
      SetTab(0.3, pjCenter, 13.0, 0, BoxLineNone, 0);
      Println(#9 + 'Grievance Audit Trail Report');
      ClearTabs;
      SetTab(0.4, pjLeft, 90, 0, BOXLINENONE, 0);   {Index}
      SetFont('Times New Roman',10);

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

        {Print the headers.}

      ClearTabs;
      SetTab(0.2, pjCenter, 1.2, 0, BOXLINENone, 0);   {SBL}
      SetTab(1.5, pjCenter, 0.8, 0, BOXLINENone, 0);   {Date Entered}
      SetTab(2.4, pjCenter, 0.8, 0, BOXLINENone, 0);   {Time}
      SetTab(3.3, pjCenter, 1.0, 0, BOXLINENone, 0);   {User}
      SetTab(4.4, pjCenter, 1.3, 0, BoxLineNone, 0);   {Description}
      SetTab(5.8, pjCenter, 0.8, 0, BOXLINENone, 0);   {Decision Date}
      SetTab(6.7, pjCenter, 1.0, 0, BOXLINENone, 0);   {Disposition}
      SetTab(7.8, pjCenter, 1.0, 0, BOXLINENone, 0);   {land Val}
      SetTab(8.9, pjCenter, 1.2, 0, BOXLINENone, 0);   {Total Val}
      SetTab(10.2, pjCenter, 0.5, 0, BOXLINENone, 0);   {EX Code}
      SetTab(10.8, pjCenter, 0.4, 0, BOXLINENone, 0);   {EX %}
      SetTab(11.3, pjCenter, 1.1, 0, BOXLINENone, 0);   {EX Amt}
      SetTab(12.5, pjCenter, 0.7, 0, BOXLINENone, 0);   {Updated}

      Println(#9 +
              #9 + 'Date' +
              #9 + #9 + #9 +
              #9 + 'Decision' +
              #9 +
              #9 + 'Granted' +
              #9 + 'Granted' +
              #9 + 'Granted' +
              #9 + 'Granted' +
              #9 + 'Granted');

      ClearTabs;
      SetTab(0.2, pjCenter, 1.2, 0, BOXLINEBottom, 0);   {SBL}
      SetTab(1.5, pjCenter, 0.8, 0, BOXLINEBottom, 0);   {Date Entered}
      SetTab(2.4, pjCenter, 0.8, 0, BOXLINEBottom, 0);   {Time}
      SetTab(3.3, pjCenter, 1.0, 0, BOXLINEBottom, 0);   {User}
      SetTab(4.4, pjCenter, 1.3, 0, BoxLineBottom, 0);   {Description}
      SetTab(5.8, pjCenter, 0.8, 0, BOXLINEBottom, 0);   {Decision Date}
      SetTab(6.7, pjCenter, 1.0, 0, BOXLINEBottom, 0);   {Disposition}
      SetTab(7.8, pjCenter, 1.0, 0, BOXLINEBottom, 0);   {land Val}
      SetTab(8.9, pjCenter, 1.2, 0, BOXLINEBottom, 0);   {Total Val}
      SetTab(10.2, pjCenter, 0.5, 0, BOXLINEBottom, 0);   {EX Code}
      SetTab(10.8, pjCenter, 0.4, 0, BOXLINEBottom, 0);   {EX %}
      SetTab(11.3, pjCenter, 1.1, 0, BOXLINEBottom, 0);   {EX Amt}
      SetTab(12.5, pjCenter, 0.7, 0, BOXLINEBottom, 0);   {Updated}

      Println(#9 + 'Parcel ID' +
              #9 + 'Entered' +
              #9 + 'Time' +
              #9 + 'User' +
              #9 + 'Description' +
              #9 + 'Date' +
              #9 + 'Disposition' +
              #9 + 'Land Val' +
              #9 + 'Total Val' +
              #9 + 'EX Cd' +
              #9 + 'EX %' +
              #9 + 'EX Amt' +
              #9 + 'Updated');

      ClearTabs;
      SetTab(0.2, pjLeft, 1.2, 0, BOXLINENone, 0);   {SBL}
      SetTab(1.5, pjLeft, 0.8, 0, BOXLINENone, 0);   {Date Entered}
      SetTab(2.4, pjLeft, 0.8, 0, BOXLINENone, 0);   {Time}
      SetTab(3.3, pjLeft, 1.0, 0, BOXLINENone, 0);   {User}
      SetTab(4.4, pjLeft, 1.3, 0, BoxLineNone, 0);   {Description}
      SetTab(5.8, pjLeft, 0.8, 0, BOXLINENone, 0);   {Decision Date}
      SetTab(6.7, pjLeft, 1.0, 0, BOXLINENone, 0);   {Disposition}
      SetTab(7.8, pjRight, 1.0, 0, BOXLINENone, 0);   {land Val}
      SetTab(8.9, pjRight, 1.2, 0, BOXLINENone, 0);   {Total Val}
      SetTab(10.2, pjLeft, 0.5, 0, BOXLINENone, 0);   {EX Code}
      SetTab(10.8, pjRight, 0.4, 0, BOXLINENone, 0);   {EX %}
      SetTab(11.3, pjRight, 1.1, 0, BOXLINENone, 0);   {EX Amt}
      SetTab(12.5, pjCenter, 0.7, 0, BOXLINENone, 0);   {Updated}
      Bold := False;

    end;  {with Sender as TBaseReport do}

end;  {ReportPrintHeader}

{====================================================================}
Procedure TGrievanceAuditTrailForm.ReportPrint(Sender: TObject);

var
  Done, FirstTimeThrough, Quit, ValidEntry : Boolean;
  NumFound : LongInt;
  SwisSBLKey : String;
  SBLRec : SBLRecord;
  TempDate : TDateTime;

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

  with GrievanceAuditTrailTable do
    case IndexRadioGroup.ItemIndex of
      0 : begin  {SBL}
            IndexName := 'BYSBL_DATE_TIME';

            If not AllSBLCheckBox.Checked
              then SetRangeOld(GrievanceAuditTrailTable,
                               ['SwisSBLKey', 'Date', 'Time'],
                               [StartingSwisSBL, '1/1/1900', ''],
                               [EndingSwisSBL, '1/1/2300', '']);

          end;   {SBL}

      1 : begin  {Date }
            IndexName := 'BYDATE_TIME_SBL';

              {Set a range if they specified a range.}

            If not AllDatesCheckBox.Checked
              then FindNearestOld(GrievanceAuditTrailTable,
                                  ['Date', 'Time', 'SwisSBLKey'],
                                  [StartDateEdit.Text, '', '']);

          end;   {Date }

      2 : begin  {User}
            IndexName := 'BYUSER_DATE_TIME';

              {Set a range if they specified a range.}

            If not AllUsersCheckBox.Checked
              then
                If ToEndofDatesCheckBox.Checked
                  then SetRangeOld(GrievanceAuditTrailTable, ['User', 'Date', 'Time'],
                                   [StartUserEdit.Text, '1/1/1900', ''],
                                   [EndUserEdit.Text, '1/1/2300', ''])
                  else SetRangeOld(GrievanceAuditTrailTable, ['User', 'Date', 'Time'],
                                   [StartUserEdit.Text, '1/1/1900', ''],
                                   [EndUserEdit.Text, '1/1/2300', '']);

          end; {User}

    end;  {case IndexRadioGroup of}

     {Get the first record.}

  If ((IndexRadioGroup.ItemIndex in [0, 2]) or
      AllDatesCheckBox.Checked)
    then GrievanceAuditTrailTable.First;

  Done := False;
  FirstTimeThrough := True;
  Quit := False;
  NumFound := 0;

  with Sender as TBaseReport do
    begin
      repeat
        If FirstTimeThrough
          then FirstTimeThrough := False
          else GrievanceAuditTrailTable.Next;

        TempDate := GrievanceAuditTrailTable.FieldByName('Date').AsDateTime;

        If (GrievanceAuditTrailTable.EOF or
            ((IndexRadioGroup.ItemIndex = 1) and
             (not AllDatesCheckBox.Checked) and
             (not ToEndofDatesCheckBox.Checked) and
             (TempDate > StrToDate(EndDateEdit.Text))))
          then Done := True;

          {Print the present record.}

        If not (Done or Quit)
          then
            begin
              {Update the progress panel.}

              with GrievanceAuditTrailTable do
                case IndexRadioGroup.ItemIndex of
                  0 : ProgressDialog.Update(Self,
                                            ConvertSwisSBLToDashDot(FieldByName('SwisSBLKey').Text));
                  1 : ProgressDialog.Update(Self, FieldByName('Date').Text);
                  2 : ProgressDialog.Update(Self, FieldByName('User').Text);

                end;  {case IndexRadioGroup.ItemIndex of}

              Application.ProcessMessages;

                {CHG01211998-3: Allow tracking of EX, SD deletions.}

              SBLRec := ExtractSwisSBLFromSwisSBLKey(GrievanceAuditTrailTable.FieldByName('SwisSBLKey').Text);

              with SBLRec do
                FindKeyOld(ParcelTable,
                           ['TaxRollYr', 'SwisCode', 'Section',
                            'Subsection', 'Block', 'Lot',
                            'Sublot', 'Suffix'],
                           [GetTaxRlYr, SwisCode, Section, Subsection,
                            Block, Lot, Sublot, Suffix]);

              with GrievanceAuditTrailTable do
                If RecordInRange(FieldByName('Date').AsDateTime,
                                 FieldByName('SwisSBLKey').Text,
                                 ParcelTable.FieldByName('SchoolCode').Text,
                                 FieldByName('User').Text,
                                 FieldByName('TaxRollYr').Text)
                  then
                    begin
                      NumFound := NumFound + 1;

                      with GrievanceAuditTrailTable do
                        FindKeyOld(GrievanceResultsTable,
                                   ['TaxRollYr', 'SwisSBLKey',
                                    'GrievanceNumber', 'ResultNumber'],
                                   [FieldByName('TaxRollYr').Text,
                                    FieldByName('SwisSBLKey').Text,
                                    FieldByName('GrievanceNumber').Text,
                                    FieldByName('ResultNumber').Text]);

                      Println(#9 + ConvertSwisSBLToDashDot(FieldByName('SwisSBLKey').Text) +
                              #9 + FieldByName('Date').Text +
                              #9 + FormatDateTime(TimeFormat, FieldByName('Time').AsDateTime) +
                              #9 + FieldByName('User').Text +
                              #9 + GrievanceResultsTable.FieldByName('ComplaintReason').Text +
                              #9 + FieldByName('DecisionDate').Text +
                              #9 + FieldByName('Disposition').Text +
                              #9 + FormatFloat(NoDecimalDisplay_BlankZero,
                                               FieldByName('NewGrantedLandVal').AsFloat) +
                              #9 + FormatFloat(NoDecimalDisplay_BlankZero,
                                               FieldByName('NewGrantedTotalVal').AsFloat) +
                              #9 + FieldByName('NewGrantedEXCode').Text +
                              #9 + FormatFloat(PercentDisplay_BlankZero,
                                               FieldByName('NewGrantedEXPercent').AsFloat) +
                              #9 + FormatFloat(NoDecimalDisplay_BlankZero,
                                               FieldByName('NewGrantedEXAmt').AsFloat) +
                              #9 + BoolToChar_Blank_Y(GrievanceResultsTable.FieldByName('ValuesTransferred').AsBoolean));

                      If (CreateParcelList and
                          (not ParcelListDialog.ParcelExistsInList(SwisSBLKey)))
                        then ParcelListDialog.AddOneParcel(SwisSBLKey);

                    end;  {with GrievanceAuditTrailTable do}

                {If there is only one line left to print, then we
                 want to go to the next page.}

              If (LinesLeft < 8)
                then NewPage;

              SwisSBLKey := GrievanceAuditTrailTable.FieldByName('SwisSBLKey').Text;

            end;  {If not (Done or Quit)}

        ReportCancelled := ProgressDialog.Cancelled;

      until (Done or Quit or ReportCancelled);

      If (NumFound = 0)
        then Println('None.');

    end;  {with Sender as TBaseReport do}

end;  {ReportPrinterPrint}

{=====================================================================}
Procedure TGrievanceAuditTrailForm.CloseButtonClick(Sender: TObject);

begin
  Close;
end;

{===================================================================}
Procedure TGrievanceAuditTrailForm.FormClose(    Sender: TObject;
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