unit RGrievance_SmallClaims_Certiorari_NotesReport;

{To use this template:
  1. Save the form it under a new name.
  2. Rename the form in the Object Inspector.
  3. Rename the table in the Object Inspector. Then switch
     to the code and do a blanket replace of "Table" with the new name.
  4. Change UnitName to the new unit name.}

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  StdCtrls, ExtCtrls, Forms, Dialogs, DB, Grids, DBGrids,
  DBTables, Mask, DBCtrls, Wwtable, Wwdatsrc, Wwdbcomb, Wwdbigrd, Wwdbgrid,
  Btrvdlg, Types, wwdblook, Buttons, RPFiler, RPBase, RPCanvas, RPrinter,
  Printrng, RPMemo, RPDBUtil, Gauges, RPDefine, TabNotBk, ComCtrls(*, Progress*);

type
  TGrievance_SmallClaims_Certiorari_NotesReportForm = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    ScrollBox: TScrollBox;
    CloseButton: TBitBtn;
    TitleLabel: TLabel;
    PrintButton: TBitBtn;
    ClearButton: TBitBtn;
    PrintDialog: TPrintDialog;
    ReportPrinter: TReportPrinter;
    ReportFiler: TReportFiler;
    NotesTable: TTable;
    UserTable: TwwTable;
    LoadButton: TBitBtn;
    SaveButton: TBitBtn;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    ParcelTable: TTable;
    Panel3: TPanel;
    ScrollBox1: TScrollBox;
    Label3: TLabel;
    Label14: TLabel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    SchoolCodeTable: TTable;
    SwisCodeTable: TTable;
    TabbedNotebook: TTabbedNotebook;
    IndexRadioGroup: TRadioGroup;
    DateGroupBox: TGroupBox;
    Label4: TLabel;
    Label5: TLabel;
    AllDatesCheckBox: TCheckBox;
    ToEndofDatesCheckBox: TCheckBox;
    StartDateEdit: TMaskEdit;
    EndDateEdit: TMaskEdit;
    UserIDGroupBox: TGroupBox;
    Label6: TLabel;
    Label7: TLabel;
    AllUsersCheckBox: TCheckBox;
    ToEndOfUsersCheckBox: TCheckBox;
    StartUserDropdown: TwwDBLookupCombo;
    EndUserDropdown: TwwDBLookupCombo;
    NotesXActCodeGroupBox: TGroupBox;
    Label8: TLabel;
    Label9: TLabel;
    StartNotesCodeEdit: TEdit;
    EndNotesCodeEdit: TEdit;
    AllNotesCodesCheckBox: TCheckBox;
    ToEndOfNotesCodesCheckBox: TCheckBox;
    NoteTypeRadioGroup: TRadioGroup;
    TicklerNotesStatusRadioGroup: TRadioGroup;
    MiscOptionsGroupBox: TGroupBox;
    LoadFromParcelListCheckBox: TCheckBox;
    CreateParcelListCheckBox: TCheckBox;
    Label1: TLabel;
    Label2: TLabel;
    SwisCodeListBox: TListBox;
    SchoolCodeListBox: TListBox;
    PrintToExcelCheckBox: TCheckBox;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure IndexRadioGroupClick(Sender: TObject);
    procedure PrintButtonClick(Sender: TObject);
    procedure ReportPrintHeader(Sender: TObject);
    procedure NoteTypeRadioGroupClick(Sender: TObject);
    procedure AllDatesCheckBoxClick(Sender: TObject);
    procedure ToEndofDatesCheckBoxClick(Sender: TObject);
    procedure AllNotesCodesCheckBoxClick(Sender: TObject);
    procedure ToEndOfNotesCodesCheckBoxClick(Sender: TObject);
    procedure AllUsersCheckBoxClick(Sender: TObject);
    procedure ToEndOfUsersCheckBoxClick(Sender: TObject);
    procedure DateEditExit(Sender: TObject);
    procedure ClearButtonClick(Sender: TObject);
    procedure LoadButtonClick(Sender: TObject);
    procedure SaveButtonClick(Sender: TObject);
    procedure ReportPrint(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    UnitName, AssessmentYear : String;
    FormAccessRights : Integer;  {Read only or read write, based on security level?}
                                {Values = raReadOnly, raReadWrite}

    ReportCancelled : Boolean;
    LoadFromParcelList,
    CreateParcelList : Boolean;
    SelectedSchoolCodes,
    SelectedSwisCodes : TStringList;  {What swis codes did they select?}
    PrintToExcel : Boolean;
    ExtractFile : TextFile;
    GrievanceType : Char;  {(G)rievance
                            (S)mall Claims
                            (C)ertiorari}

    Procedure InitializeForm;  {Open the tables and setup.}

    Function ValidSelectionInformation : Boolean;
    {Have they filled in enough information in the selection boxes to print?}

    Function RecordInRange(SwisCode : String;
                           SchoolCode : String;
                           ParcelFound : Boolean) : Boolean;
    {Does this record fall within the set of parameters that they selected?}

  end;

implementation

uses GlblVars, WinUtils, Utilitys, GlblCnst, PASUTILS, UTILEXSD,
     Prog, Preview, PASTypes, RptDialg, PRCLLIST;

{$R *.DFM}

{========================================================}
Procedure TGrievance_SmallClaims_Certiorari_NotesReportForm.FormActivate(Sender: TObject);

begin
  SetFormStateMaximized(Self);
end;

{========================================================}
Procedure TGrievance_SmallClaims_Certiorari_NotesReportForm.InitializeForm;

begin
  UnitName := 'RGrievance_SmallClaims_Certiorari_NotesReport';  {mmm}
  AssessmentYear := GlblNextYear;

  case GrievanceType of
    'C' : begin
            NotesTable.TableName := CertiorariNotesTableName;
            TitleLabel.Caption := 'Certiorari Notes Report';
            TitleLabel.Left := (Panel1.Width - TitleLabel.Width) DIV 2;
            Caption := TitleLabel.Caption;

          end;  {Certiorari}

  end;  {case GrievanceType of}

    {There are so many tables on this form, we will
     set the table name and open them implicitly.
     OpenTablesForForm is a method in PASUTILS.}

  OpenTablesForForm(Self, NextYear);

  DisableSelectionsInGroupBoxOrPanel(NotesXActCodeGroupBox);
  DisableSelectionsInGroupBoxOrPanel(DateGroupBox);
  DisableSelectionsInGroupBoxOrPanel(UserIDGroupBox);

    {CHG12112002-1: Add swis and school selection to notes report.}

  FillOneListBox(SwisCodeListBox, SwisCodeTable, 'SwisCode',
                 'MunicipalityName', 25, True, True, GlblProcessingType,
                 GetTaxRlYr);

  FillOneListBox(SchoolCodeListBox, SchoolCodeTable, 'SchoolCode',
                 'SchoolName', 25, True, True, GlblProcessingType,
                 GetTaxRlYr);

  SelectItemsInListBox(SwisCodeListBox);
  SelectItemsInListBox(SchoolCodeListBox);

end;  {InitializeForm}

{===================================================================}
Procedure TGrievance_SmallClaims_Certiorari_NotesReportForm.FormKeyPress(    Sender: TObject;
                                     var Key: Char);

begin
  If (Key = #13)
    then
      begin
        Key := #0;
        Perform(WM_NEXTDLGCTL, 0, 0);
      end;

end;  {FormKeyPress}

{========================================================================}
Procedure TGrievance_SmallClaims_Certiorari_NotesReportForm.IndexRadioGroupClick(Sender: TObject);

begin
  NoteTypeRadioGroup.Enabled := True;

  If (NoteTypeRadioGroup.ItemIndex in [1,2])  {Tickler or both}
    then TicklerNotesStatusRadioGroup.Enabled := True
    else TicklerNotesStatusRadioGroup.Enabled := False;

  EnableSelectionsInGroupBoxOrPanel(DateGroupBox);
  EnableSelectionsInGroupBoxOrPanel(NotesXActCodeGroupBox);

  If (NoteTypeRadioGroup.ItemIndex in [1,2])  {Tickler or both}
    then EnableSelectionsInGroupBoxOrPanel(UserIDGroupBox)
    else DisableSelectionsInGroupBoxOrPanel(UserIDGroupBox);

    {If they have regular notes selected and they change to date due or
     user responsible key, then we will unselect regular notes type since this
     does not make sense.}

  If ((IndexRadioGroup.ItemIndex in [1, 3]) and
      (NoteTypeRadioGroup.ItemIndex = 0))
    then NoteTypeRadioGroup.ItemIndex := -1;

end;  {IndexRadioGroupClick}

{===============================================================================}
Procedure TGrievance_SmallClaims_Certiorari_NotesReportForm.NoteTypeRadioGroupClick(Sender: TObject);

{If they clicked to show only regular notes, disable the tickler notes status
 and user ID selections. If they clicked on tickler or both, re-enable the tickler
 notes status and user ID selections.}

begin
  If (NoteTypeRadioGroup.ItemIndex = 0)
    then
      begin  {Regular notes}
        If (IndexRadioGroup.ItemIndex in [1,3])
          then
            begin
              MessageDlg('You can not print only regular notes and sort the ' +
                         'report by date due or user responsible.', mtError, [mbOK], 0);
              NoteTypeRadioGroup.ItemIndex := -1;
            end
          else
            If TicklerNotesStatusRadioGroup.Enabled
              then
                begin
                  TicklerNotesStatusRadioGroup.Enabled := False;
                  TicklerNotesStatusRadioGroup.ItemIndex := -1;
                end;

            If UserIDGroupBox.Enabled
              then DisableSelectionsInGroupBoxOrPanel(UserIDGroupBox);

      end
    else
      begin  {Tickler notes or both.}
        If not TicklerNotesStatusRadioGroup.Enabled
          then TicklerNotesStatusRadioGroup.Enabled := True;

        If not UserIDGroupBox.Enabled
          then EnableSelectionsInGroupBoxOrPanel(UserIDGroupBox);

      end;  {else of If (NoteTypeRadioGroup.ItemIndex = 0)}

end;  {NoteTypeRadioGroupClick}

{==================================================================}
Procedure TGrievance_SmallClaims_Certiorari_NotesReportForm.AllDatesCheckBoxClick(Sender: TObject);

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

{==============================================================}
Procedure TGrievance_SmallClaims_Certiorari_NotesReportForm.DateEditExit(Sender: TObject);

{Validate the date entry unless they are closing or clearing the selections.}

begin
  If ((Screen.ActiveControl.Name <> 'CloseButton') and
      (Screen.ActiveControl.Name <> 'ClearButton') and
      (Screen.ActiveControl.Name <> 'AllDatesCheckBox'))
    then
      try
        StrToDate(TEdit(Sender).Text);
      except
        If (TEdit(Sender).Text <> '__/__/____')
          then
            begin
              MessageDlg(TEdit(Sender).Text + ' is not a valid date.' + #13 + 'Please re-enter.',
                         mtError, [mbOK], 0);
              TEdit(Sender).SetFocus;
            end;

      end;

end;  {DateEditExit}

{==============================================================}
Procedure TGrievance_SmallClaims_Certiorari_NotesReportForm.ToEndofDatesCheckBoxClick(Sender: TObject);

begin
  If ToEndOfDatesCheckBox.Checked
    then
      begin
        EndDateEdit.Text := '';
        EndDateEdit.Enabled := False;
        EndDateEdit.Color := clBtnFace;
      end
    else
      begin
        EndDateEdit.Enabled := True;
        EndDateEdit.Color := clWindow;
      end;

end;  {ToEndofDatesCheckBoxClick}

{==================================================================}
Procedure TGrievance_SmallClaims_Certiorari_NotesReportForm.AllNotesCodesCheckBoxClick(Sender: TObject);

begin
  If AllNotesCodesCheckBox.Checked
    then
      begin
        ToEndofNotesCodesCheckBox.Checked := False;
        ToEndofNotesCodesCheckBox.Enabled := False;
        StartNotesCodeEdit.Text := '';
        StartNotesCodeEdit.Enabled := False;
        StartNotesCodeEdit.Color := clBtnFace;
        EndNotesCodeEdit.Text := '';
        EndNotesCodeEdit.Enabled := False;
        EndNotesCodeEdit.Color := clBtnFace;
      end
    else EnableSelectionsInGroupBoxOrPanel(NotesXActCodeGroupBox);

end;  {AllNotesCodesCheckBoxClick}

{==============================================================}
Procedure TGrievance_SmallClaims_Certiorari_NotesReportForm.ToEndofNotesCodesCheckBoxClick(Sender: TObject);

begin
  If ToEndOfNotesCodesCheckBox.Checked
    then
      begin
        EndNotesCodeEdit.Text := '';
        EndNotesCodeEdit.Enabled := False;
        EndNotesCodeEdit.Color := clBtnFace;
      end
    else
      begin
        EndNotesCodeEdit.Enabled := True;
        EndNotesCodeEdit.Color := clWindow;
      end;

end;  {ToEndofNoteCodesCheckBoxClick}

{==================================================================}
Procedure TGrievance_SmallClaims_Certiorari_NotesReportForm.AllUsersCheckBoxClick(Sender: TObject);

begin
  If AllUsersCheckBox.Checked
    then
      begin
        ToEndofUsersCheckBox.Checked := False;
        ToEndofUsersCheckBox.Enabled := False;
        StartUserDropdown.Text := '';
        StartUserDropdown.Enabled := False;
        StartUserDropdown.Color := clBtnFace;
        EndUserDropdown.Text := '';
        EndUserDropdown.Enabled := False;
        EndUserDropdown.Color := clBtnFace;
      end
    else EnableSelectionsInGroupBoxOrPanel(UserIDGroupBox);

end;  {AllUserIDCheckBoxClick}

{==============================================================}
Procedure TGrievance_SmallClaims_Certiorari_NotesReportForm.ToEndofUsersCheckBoxClick(Sender: TObject);

begin
  If ToEndOfUsersCheckBox.Checked
    then
      begin
        EndUserDropdown.Text := '';
        EndUserDropdown.Enabled := False;
        EndUserDropdown.Color := clBtnFace;
      end
    else
      begin
        EndUserDropdown.Enabled := True;
        EndUserDropdown.Color := clWindow;
      end;

end;  {ToEndofUserIDCheckBoxClick}

{=====================================================================}
Procedure TGrievance_SmallClaims_Certiorari_NotesReportForm.ClearButtonClick(Sender: TObject);

{Clear the selections.}

begin
  IndexRadioGroup.ItemIndex := -1;
  NoteTypeRadioGroup.ItemIndex := -1;
  NoteTypeRadioGroup.Enabled := False;
  TicklerNotesStatusRadioGroup.ItemIndex := -1;
  TicklerNotesStatusRadioGroup.Enabled := False;
  DisableSelectionsInGroupBoxOrPanel(NotesXActCodeGroupBox);
  DisableSelectionsInGroupBoxOrPanel(DateGroupBox);
  DisableSelectionsInGroupBoxOrPanel(UserIDGroupBox);

end;  {ClearButtonClick}

{====================================================================}
Procedure TGrievance_SmallClaims_Certiorari_NotesReportForm.SaveButtonClick(Sender: TObject);

{FXX04091999-8: Add ability to save and load search report options.}

begin
  SaveReportOptions(Self, OpenDialog, SaveDialog, 'notesrpt.not', 'Notes Report');

end;  {SaveButtonClick}

{====================================================================}
Procedure TGrievance_SmallClaims_Certiorari_NotesReportForm.LoadButtonClick(Sender: TObject);

{FXX04091999-8: Add ability to save and load search report options.}

begin
  LoadReportOptions(Self, OpenDialog, 'notesrpt.not', 'Notes Report');

(*StartUserDropdown.Text := 'MIKE';*)

end;  {LoadButtonClick}

{=====================================================================}
Function TGrievance_SmallClaims_Certiorari_NotesReportForm.ValidSelectionInformation : Boolean;

{Have they filled in enough information in the selection boxes to print?}

begin
  Result := True;

    {They have to select a type of note to print.}

  If (NoteTypeRadioGroup.ItemIndex = -1)
    then
      begin
        MessageDlg('Please select a note type to print:' + #13 +
                   'regular, tickler, or both.', mtError, [mbOK], 0);
        Result := False;
      end;

    {If they selected tickler or both note types, they need to fill in a notes
     status.}

  If ((Result and
      (NoteTypeRadioGroup.ItemIndex in [1, 2]) and
      (TicklerNotesStatusRadioGroup.ItemIndex = -1)))
    then
      begin
        MessageDlg('Please select the tickler note status to print:' + #13 +
                   'open, closed, or both.', mtError, [mbOK], 0);
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
      If ((Deblank(StartNotesCodeEdit.Text) <> '') or
       (Deblank(EndNotesCodeEdit.Text) <> '') or
       AllNotesCodesCheckBox.Checked or
       ToEndofNotesCodesCheckBox.Checked)
        then
          begin
              {Make sure if they clicked to end of range that they put in a start range.}

            If ((ToEndofNotesCodesCheckBox.Checked or
                 (Deblank(EndNotesCodeEdit.Text) <> '')) and
                (Deblank(StartNotesCodeEdit.Text) = ''))
              then
                begin
                  MessageDlg('Please select a starting notes code or chose all notes codes.', mtError, [mbOK], 0);
                  Result := False;
                end;

              {Make sure that if they entered a start range, there is an end range.}

            If ((Deblank(StartNotesCodeEdit.Text) <> '') and
                ((Deblank(EndNotesCodeEdit.Text) = '') and
                 (not ToEndofNotesCodesCheckBox.Checked)))
              then
                begin
                  MessageDlg('Please select an ending notes code or chose to print to the end of the notes codes on file.',
                             mtError, [mbOK], 0);
                  Result := False;
                end;

          end
        else AllNotesCodesCheckBox.Checked := True;

    {Now check the user selections.}

  If Result
    then
      If ((Deblank(StartUserDropdown.Text) <> '') or
           (Deblank(EndUserDropdown.Text) <> '') or
           AllUsersCheckBox.Checked or
           ToEndofUsersCheckBox.Checked)
        then
          begin
              {Make sure if they clicked to end of range that they put in a start range.}

            If ((ToEndofUsersCheckBox.Checked or
                 (Deblank(EndUserDropdown.Text) <> '')) and
                (Deblank(StartUserDropdown.Text) = ''))
              then
                begin
                  MessageDlg('Please select a starting user or chose all users.', mtError, [mbOK], 0);
                  Result := False;
                end;

              {Make sure that if they entered a start range, there is an end range.}

            If ((Deblank(StartUserDropdown.Text) <> '') and
                ((Deblank(EndUserDropdown.Text) = '') and
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
Procedure TGrievance_SmallClaims_Certiorari_NotesReportForm.PrintButtonClick(Sender: TObject);

var
  NewFileName : String;
  Quit : Boolean;
  I : Integer;
  SpreadsheetFileName : String;

begin
  ReportCancelled := False;
  PrintToExcel := PrintToExcelCheckBox.Checked;

  Quit := False;

    {CHG10121998-1: Add user options for default destination and show vet max msg.}

  SetPrintToScreenDefault(PrintDialog);

  If (ValidSelectionInformation and
      PrintDialog.Execute)
    then
      begin
        CreateParcelList := CreateParcelListCheckBox.Checked;

          {CHG10131998-1: Set the printer settings based on what printer they selected
                          only - they no longer need to worry about paper or landscape
                          mode.}

        AssignPrinterSettings(PrintDialog, ReportPrinter, ReportFiler, [ptLaser], False, Quit);

        If not Quit
          then
            begin
              ProgressDialog.Start(GetRecordCount(NotesTable), True, True);

              SelectedSwisCodes := TStringList.Create;
              SelectedSchoolCodes := TStringList.Create;

              For I := 0 to (SwisCodeListBox.Items.Count - 1) do
                If SwisCodeListBox.Selected[I]
                  then SelectedSwisCodes.Add(Take(6, SwisCodeListBox.Items[I]));

                {CHG05162000-1: Add school codes option.}

              For I := 0 to (SchoolCodeListBox.Items.Count - 1) do
                If SchoolCodeListBox.Selected[I]
                  then SelectedSchoolCodes.Add(Take(6, SchoolCodeListBox.Items[I]));

              If PrintToExcel
                then
                  begin
                    SpreadsheetFileName := GetPrintFileName('NT', True);
                    AssignFile(ExtractFile, SpreadsheetFileName);
                    Rewrite(ExtractFile);

                      {Write the headers.}

                    Writeln(ExtractFile, 'Parcel ID,',
                                         'Date Entered,',
                                         'Note #,',
                                         'User,',
                                         'Note Code,',
                                         'Type,',
                                         'Date Due,',
                                         'User Resp,',
                                         'Open?,',
                                         'Note');

                  end;  {If PrintToExcel}

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

              If PrintDialog.PrintToFile
                then
                  begin
                    NewFileName := GetPrintFileName(Self.Caption, True);
                    ReportFiler.FileName := NewFileName;

                    try
                      PreviewForm := TPreviewForm.Create(self);
                      PreviewForm.FilePrinter.FileName := NewFileName;
                      PreviewForm.FilePreview.FileName := NewFileName;

                      ReportFiler.Execute;

                        {FXX10111999-3: Tell people that printing is starting and
                                        done.}

                      ProgressDialog.StartPrinting(PrintDialog.PrintToFile);

                      PreviewForm.ShowModal;
                    finally
                      PreviewForm.Free;

                        {CHG01182000-3: Allow them to choose a different name or copy right away.}
                        {However, we can only do it if they print to screen first since
                         report printer does not generate a file.}

                      ShowReportDialog('NOTES.RPT', ReportFiler.FileName, True);

                    end;  {If PrintRangeDlg.PreviewPrint}

                  end  {They did not select preview, so we will go
                        right to the printer.}
                else ReportPrinter.Execute;

                {FXX06181999-10: Do not clear selections automatically.}
                {Clear the selections.}

              (* ClearButtonClick(Sender);*)
                {FXX10111999-3: Tell people that printing is starting and
                                done.}

              ProgressDialog.Finish;
              DisplayPrintingFinishedMessage(PrintDialog.PrintToFile);

              If CreateParcelList
                then ParcelListDialog.Show;

              SelectedSwisCodes.Free;
              SelectedSchoolCodes.Free;

              If PrintToExcel
                then
                  begin
                    CloseFile(ExtractFile);
                    SendTextFileToExcelSpreadsheet(SpreadsheetFileName, True,
                                                   False, '');

                  end;  {If PrintToExcel}

            end;  {If not Quit}

        ResetPrinter(ReportPrinter);

      end;  {If PrintDialog.Execute}

end;  {PrintButtonClick}

{===================================================================}
Procedure TGrievance_SmallClaims_Certiorari_NotesReportForm.FormClose(    Sender: TObject;
                                  var Action: TCloseAction);

begin
  CloseTablesForForm(Self);

    {Free up the child window and set the ClosingAForm Boolean to
     true so that we know to delete the tab.}

  Action := caFree;
  GlblClosingAForm := True;
  GlblClosingFormCaption := Caption;

end;  {FormClose}

{=============================================================================}
{===============   PRINTING LOGIC  ===========================================}
{=============================================================================}
Function TGrievance_SmallClaims_Certiorari_NotesReportForm.RecordInRange(SwisCode : String;
                                        SchoolCode : String;
                                        ParcelFound : Boolean) : Boolean;

{Does this record fall within the set of parameters that they selected?}

var
  FieldName : String;

begin
  Result := True;
    {First, we will check and see if the note is in the type that they asked for:
     regular, tickler, or noth.}

  case NoteTypeRadioGroup.ItemIndex of
    0 : If (NotesTable.FieldByName('NoteTypeCode').Text = 'T')  {Want regular, not tickler}
          then Result := False;

    1 : If (NotesTable.FieldByName('NoteTypeCode').Text = 'R')  {Want tickler, not regular}
          then Result := False;

  end;  {case NoteTypeRadioGroup.ItemIndex of}

    {If they selected tickler or both notes types, let's check the status : Open, Close, or Both.}

  If (NoteTypeRadioGroup.ItemIndex in [1, 2])
    then
      case TicklerNotesStatusRadioGroup.ItemIndex of
        0 : If not TBooleanField(NotesTable.FieldByName('NoteOpen')).AsBoolean  {Want open, not closed}
              then Result := False;

        1 : If TBooleanField(NotesTable.FieldByName('NoteOpen')).AsBoolean  {Want closed, not open}
              then Result := False;

      end;  {case TicklerNotesStatusRadioGroup.ItemIndex of}

    {Now see if they are in the date range (if any) specified.}

  If not AllDatesCheckBox.Checked
    then
      begin
        If (IndexRadioGroup.ItemIndex in [1, 3])
          then FieldName := 'DueDate'
          else FieldName := 'DateEntered';

        If (TDateField(NotesTable.FieldByName(FieldName)).AsDateTime < StrToDate(StartDateEdit.Text))
          then Result := False;

        If ((not ToEndOfDatesCheckBox.Checked) and
            (TDateField(NotesTable.FieldByName(FieldName)).AsDateTime > StrToDate(EndDateEdit.Text)))
          then Result := False;

      end;  {else of If AllDatesCheckBox.Checked}

    {Now see if they are in the notes code range (if any) specified.}

  If not AllNotesCodesCheckBox.Checked
    then
      begin
        If (Take(10, NotesTable.FieldByName('TransactionCode').Text) < Take(10, StartNotesCodeEdit.Text))
          then Result := False;

        If ((not ToEndOfNotesCodesCheckBox.Checked) and
            (Take(10, NotesTable.FieldByName('TransactionCode').Text) > Take(10, EndNotesCodeEdit.Text)))
          then Result := False;

      end;  {else of If AllNotesCodesCheckBox.Checked}

    {Now see if they are in the user range (if any) specified.}

  If not AllUsersCheckBox.Checked
    then
      begin
        If (Take(10, NotesTable.FieldByName('UserResponsible').Text) < Take(10, StartUserDropdown.Text))
          then Result := False;

        If ((not ToEndOfUsersCheckBox.Checked) and
            (Take(10, NotesTable.FieldByName('UserResponsible').Text) > Take(10, EndUserDropdown.Text)))
          then Result := False;

      end;  {else of If AllUsersCheckBox.Checked}

  If (ParcelFound and
      (SelectedSwisCodes.IndexOf(SwisCode) = -1))
    then Result := False;

  If (ParcelFound and
      (SelectedSchoolCodes.IndexOf(SchoolCode) = -1))
    then Result := False;

  If LoadFromParcelList
    then Result := True;

end;  {RecordInRange}

{=============================================================================}
Procedure TGrievance_SmallClaims_Certiorari_NotesReportForm.ReportPrintHeader(Sender: TObject);

begin
  with Sender as TBaseReport do
    begin
        {Print the date and page number.}

      SectionTop := 0.25;
      SectionLeft := 0.5;
      SectionRight := PageWidth - 0.5;
      SetFont('Times New Roman',8);
      PrintHeader('Page: ' + IntToStr(CurrentPage), pjRight);
      PrintHeader('Date: ' + DateToStr(Date) +
                  '  Time: ' + FormatDateTime(TimeFormat, Now), pjLeft);

      SectionTop := 0.5;
      SetFont('Arial',14);
      Underline := True;
      Home;
      CRLF;
      PrintCenter('Notes Report', (PageWidth / 2));
      SetFont('Times New Roman', 12);
      CRLF;
      CRLF;

      Underline := False;
      ClearTabs;
      SetTab(0.5, pjLeft, 1.7, 0, BOXLINENONE, 0);   {Index}
      SetTab(2.5, pjLeft, 1.5, 0, BOXLINENONE, 0);   {Notes Type}
      SetTab(4.5, pjLeft, 1.5, 0, BOXLINENONE, 0);   {Tickler Status}

        {Print the selection information.}

      Bold := True;
      Print(#9 + 'Index:  ');
      Bold := False;

      case IndexRadioGroup.ItemIndex of
        0 : Print(' Date Entered');
        1 : Print(' Date Due');
        2 : Print(' Notes Code');
        3 : Print(' User Responsible');
      end;  {case IndexRadioGroup of}

      Bold := True;
      Print(#9 + 'Note Type:  ');
      Bold := False;

      case NoteTypeRadioGroup.ItemIndex of
        0 : Print(' Regular');
        1 : Print(' Tickler');
        2 : Print(' Both');
      end;  {case NoteTypeRadioGroup.ItemIndex of}

      If (NoteTypeRadioGroup.ItemIndex in [1, 2])
        then
          begin
            Bold := True;
            Print(#9 + 'Tickler Status:  ');
            Bold := False;

            case TicklerNotesStatusRadioGroup.ItemIndex of
              0 : Println(' Open');
              1 : Println(' Closed');
              2 : Println(' Both');
            end;  {case TicklerNotesStatusRadioGroup.ItemIndex of}

          end  {If (NoteTypeRadioGroup.ItemIndex in [1, 2])}
        else Println('');

      Bold := True;
      Print(#9 + 'For Dates: ');
      Bold := False;

      If AllDatesCheckBox.Checked
        then Println(' All')
        else
          begin
            Print(' ' + StartDateEdit.Text + ' to ');

            If ToEndOfDatesCheckBox.Checked
              then Println(' End')
              else Println(' ' + EndDateEdit.Text);

          end;  {else of If AllDatesCheckBox.Checked}

      Bold := True;
      Print(#9 + 'For Notes Codes: ');
      Bold := False;

      If AllNotesCodesCheckBox.Checked
        then Println(' All')
        else
          begin
            Print(' ' + StartNotesCodeEdit.Text + ' to ');

            If ToEndOfNotesCodesCheckBox.Checked
              then Println(' End')
              else Println(' ' + EndNotesCodeEdit.Text);

          end;  {else of If AllNotesCodesCheckBox.Checked}

      Bold := True;
      Print(#9 + 'For Users: ');
      Bold := False;

      If AllUsersCheckBox.Checked
        then Println(' All')
        else
          begin
            Print(' ' + StartUserDropdown.Text + ' to ');

            If ToEndOfUsersCheckBox.Checked
              then Println(' End')
              else Println(' ' + EndUserDropdown.Text);

          end;  {else of If AllUsersCheckBox.Checked}

      SectionTop := 2.0;

        {Print column headers.}

      CRLF;
      CRLF;
      Home;
      SetPen(clBlack, psSolid, 1, pmCopy); { Set pen to 1 dot width }
      SetFont('Times New Roman', 10);
      Bold := True;
      ClearTabs;
      SetTab(0.4, pjCenter, 1.4, 0, BOXLINEBOTTOM, 0);   {SBL}
      SetTab(1.85, pjCenter, 0.8, 0, BOXLINEBOTTOM, 0);   {Date Entered}
      SetTab(2.70, pjCenter, 0.3, 0, BOXLINEBOTTOM, 0);   {Note Number}
      SetTab(3.1, pjCenter, 1.0, 0, BOXLINEBOTTOM, 0);   {User}
      SetTab(4.2, pjCenter, 1.0, 0, BOXLINEBOTTOM, 0);   {Xact Cd}
      SetTab(5.3, pjCenter, 0.3, 0, BOXLINEBOTTOM, 0);   {Note Type}
      SetTab(5.7, pjCenter, 0.8, 0, BOXLINEBOTTOM, 0);   {Date due}
      SetTab(6.6, pjCenter, 1.0, 0, BOXLINEBOTTOM, 0);   {User responsible}
      SetTab(7.7, pjCenter, 0.3, 0, BOXLINEBOTTOM, 0);   {Open?}

      Println(#9 + 'Parcel ID' +
              #9 + 'Date Ent' +
              #9 + 'Num' +
              #9 + 'User' +
              #9 + 'Xact Cd' +
              #9 + 'Note' +
              #9 + 'Date Due' +
              #9 + 'Responsible' +
              #9 + 'Open?');
      Println('');

      Bold := False;

        {Set up the tabs for the info.}

      ClearTabs;
      SetPen(clBlack, psSolid, 1, pmCopy); { Set pen to 1 dot width }
      SetTab(0.4, pjLeft, 1.4, 0, BoxLineNone, 0);   {SBL}
      SetTab(1.85, pjLeft, 0.8, 0, BoxLineNone, 0);   {Date Entered}
      SetTab(2.7, pjLeft, 0.3, 0, BoxLineNone, 0);   {Note Number}
      SetTab(3.1, pjLeft, 1.0, 0, BoxLineNone, 0);   {User}
      SetTab(4.2, pjLeft, 1.0, 0, BoxLineNone, 0);   {Xact Cd}
      SetTab(5.3, pjLeft, 0.3, 0, BoxLineNone, 0);   {Note Type}
      SetTab(5.7, pjLeft, 0.8, 0, BoxLineNone, 0);   {Date due}
      SetTab(6.6, pjLeft, 1.0, 0, BoxLineNone, 0);   {User responsible}
      SetTab(7.7, pjCenter, 0.3, 0, BoxLineNone, 0);   {Open?}

    end;  {with Sender as TBaseReport do}

end;  {ReportPrinterPrintHeader}

{================================================================}
Procedure TGrievance_SmallClaims_Certiorari_NotesReportForm.ReportPrint(Sender: TObject);

var
  Done, ParcelFound, FirstTimeThrough : Boolean;
  DBMemoBuf: TDBMemoBuf;
  TempStr : String;
  TempDate : TDateTime;
  SBLRec : SBLRecord;

begin
  Done := False;
  FirstTimeThrough := True;

    {CHG03101999-1: Send info to a list or load from a list.}

  If CreateParcelList
    then ParcelListDialog.ClearParcelGrid(True);

  with Sender as TBaseReport do
    begin
      MarginTop := 0.5;
      MarginBottom := 0.75;
    end;

  NotesTable.CancelRange;

  with NotesTable do
    case IndexRadioGroup.ItemIndex of
      0 : begin  {Date Entered}
            IndexName := 'BYDATEENTERED_SBL_NOTENUM';

              {Set a range if they specified a range.}
              {FXX01132000-1: Don't put an end range if they want to end of range.}
              {FXX01132000-2: Actually as a Y2K fix, will just search until after end of
                              end date.}

            If not AllDatesCheckBox.Checked
              then FindNearestOld(NotesTable, ['DateEntered'],
                                  [StartDateEdit.Text]);

            TempStr := NotesTable.FieldByName('DateEntered').Text;

          end;   {Date Entered}

      1 : begin  {Date Due}
            IndexName := 'BYDATEDUE_SWISSBLKEY_NOTENUMBER';

              {Set a range if they specified a range.}

            If not AllDatesCheckBox.Checked
              then FindNearestOld(NotesTable, ['DueDate'],
                                  [StartDateEdit.Text]);

          end;   {Date Due}

      2 : begin  {Notes XAct Code}
            IndexName := 'BYXACTCODE_SBL_NOTENUM';

              {Set a range if they specified a range.}
              {FXX04022001-1: The range was not being set properly for
                              the transaction code.}

            If not AllNotesCodesCheckBox.Checked
              then
                If ToEndofNotesCodesCheckBox.Checked
                  then SetRangeOld(NotesTable,
                                   ['TransactionCode', 'SwisSBLKey', 'NoteNumber'],
                                   [Take(10, StartNotesCodeEdit.Text), '', '0'],
                                   ['ZZZZZZZZZZ', '', '0'])
                  else SetRangeOld(NotesTable,
                                   ['TransactionCode', 'SwisSBLKey', 'NoteNumber'],
                                   [Take(10, StartNotesCodeEdit.Text), '', '0'],
                                   [Take(10, EndNotesCodeEdit.Text), ConstStr('Z', 26), '0']);

          end;   {Notes XAct Code}

      3 : begin  {User}
            IndexName := 'BYUSER_DUEDATE_SBL_NOTENUM';

              {Set a range if they specified a range.}

            If not AllUsersCheckBox.Checked
              then
                If ToEndofUsersCheckBox.Checked
                  then SetRangeOld(NotesTable,
                                   ['UserResponsible', 'DueDate', 'SwisSBLKey', 'NoteNumber'],
                                   [Take(10, StartUserDropdown.Text), '', '', ''],
                                   ['ZZZZZZZZZZ', '1/1/3000', '', ''])
                  else SetRangeOld(NotesTable,
                                   ['UserResponsible', 'DueDate', 'SwisSBLKey', 'NoteNumber'],
                                   [Take(10, StartUserDropdown.Text), '', '', ''],
                                   [Take(10, EndUserDropdown.Text), '1/1/3000', '', '']);

          end;   {User}

    end;  {case IndexRadioGroup of}

    {If the end of range is all dates, we already did a find nearest.}

  If ((IndexRadioGroup.ItemIndex in [2,3]) or
      AllDatesCheckBox.Checked)
    then NotesTable.First;

  with Sender as TBaseReport do
    repeat
      If FirstTimeThrough
        then FirstTimeThrough := False
        else NotesTable.Next;

        {FXX07211999-7: For some reason, doing the report by date due with
                        a starting and ending date range caused an EOF, but this
                        takes care of it.}

      If (IndexRadioGroup.ItemIndex = 0)
        then TempDate := NotesTable.FieldByName('DateEntered').AsDateTime
        else TempDate := NotesTable.FieldByName('DueDate').AsDateTime;

        {If we have printed all the records, then we are done.}

      If (NotesTable.EOF or
          ((IndexRadioGroup.ItemIndex in [0,1]) and
           (not AllDatesCheckBox.Checked) and
           (not ToEndofDatesCheckBox.Checked) and
           (TempDate > StrToDate(EndDateEdit.Text))))
        then Done := True;

       {Update the progress panel.}

      with NotesTable do
        case IndexRadioGroup.ItemIndex of
          0 : ProgressDialog.Update(Self, FieldByName('DateEntered').Text);
          1 : ProgressDialog.Update(Self, FieldByName('DueDate').Text);
          2 : ProgressDialog.Update(Self, FieldByName('TransactionCode').Text);
          3 : ProgressDialog.Update(Self, FieldByName('UserResponsible').Text);

        end;  {case IndexRadioGroup.ItemIndex of}

      SBLRec := ExtractSwisSBLFromSwisSBLKey(NotesTable.FieldByName('SwisSBLKey').Text);

      with SBLRec do
        ParcelFound := FindKeyOld(ParcelTable,
                                  ['TaxRollYr', 'SwisCode', 'Section', 'Subsection',
                                   'Block', 'Lot', 'Sublot', 'Suffix'],
                                  [AssessmentYear, SwisCode, Section, Subsection,
                                   Block, Lot, Sublot, Suffix]);

      If ((not Done) and
          RecordInRange(ParcelTable.FieldByName('SwisCode').Text,
                        ParcelTable.FieldByName('SchoolCode').Text, ParcelFound))
        then
          with NotesTable do
            begin
              If (LinesLeft < 3)
                then NewPage;

              Print(#9 + ConvertSwisSBLToDashDot(FieldByName('SwisSBLKey').Text) +
                    #9 + FieldByName('DateEntered').Text +
                    #9 + FieldByName('NoteNumber').Text +
                    #9 + FieldByName('EnteredByUserID').Text +
                    #9 + FieldByName('TransactionCode').Text +
                    #9 + FieldByName('NoteTypeCode').Text +
                    #9 + FieldByName('DueDate').Text +
                    #9 + FieldByName('UserResponsible').Text);

              If (FieldByName('NoteOpen').Text = 'True')
                then Println(#9 + 'X')
                else Println('');

                {CHG07222003-1(2.07g): Add extract to Excel to notes report.}

              If PrintToExcel
                then
                  begin
                    Write(ExtractFile, ConvertSwisSBLToDashDot(FieldByName('SwisSBLKey').Text) +
                                       FormatExtractField(FieldByName('DateEntered').Text) +
                                       FormatExtractField(FieldByName('NoteNumber').Text) +
                                       FormatExtractField(FieldByName('EnteredByUserID').Text) +
                                       FormatExtractField(FieldByName('TransactionCode').Text) +
                                       FormatExtractField(FieldByName('NoteTypeCode').Text) +
                                       FormatExtractField(FieldByName('DueDate').Text) +
                                       FormatExtractField(FieldByName('UserResponsible').Text));

                    TempStr := '';
                    If FieldByName('NoteOpen').AsBoolean
                      then TempStr := 'X';

                    {$H+}
                    Writeln(ExtractFile, FormatExtractField(TempStr),
                                         FormatExtractField(ExtractPlainTextFromRichText(FieldByName('Note').AsString, True)));
                    {$H-}

                  end;  {If PrintToExcel}


(*              GetMem(Buffer, FieldByName('Note').Size);
              FieldByName('Note').GetData(Buffer);
              TempStr := StrPas(Buffer);

              LineFeedFound := False;
              I := 1;

              while ((I <= Length(TempStr)) and
                     (not LineFeedFound)) do
                begin
                  If (TempStr[I] = #13)
                    then
                      begin
                        LineFeedFound := True;
                        Println('');
                      end
                    else
                      If (TempStr[I] <> #10)
                        then Print(TempStr[I]);

                  I := I + 1;

                end;  {while ((I <= Length(TempStr)) and ...}

              Println('');
              Println('');
              FreeMem(Buffer, FieldByName('Note').Size); *)

                {FXX05162000-1: Make sure to print all of the note.}

              DBMemoBuf := TDBMemoBuf.Create;
              DBMemoBuf.Field := TMemoField(NotesTable.FieldByName('Note'));

              DBMemoBuf.PrintStart := 0.5;
              DBMemoBuf.PrintEnd := 7.9;

              PrintMemo(DBMemoBuf, 0, False);
              DBMemoBuf.Free;
              Println('');

                {FXX12112002-1: Don't add an item to the parcel list if it no longer exists.}

              If (ParcelFound and
                  CreateParcelList and
                  (not ParcelListDialog.ParcelExistsInList(FieldByName('SwisSBLKey').Text)))
                then ParcelListDialog.AddOneParcel(FieldByName('SwisSBLKey').Text);

            end;  {with NotesTable do}

        ReportCancelled := ProgressDialog.Cancelled;

    until (Done or ReportCancelled);

end;  {ReportPrinterPrint}


end.