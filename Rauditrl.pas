unit Rauditrl;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, DBCtrls,  DB, Buttons, Grids,
  Wwdbigrd, Wwdbgrid, ExtCtrls, Wwdatsrc, Menus,
  DBTables, Wwtable, Btrvdlg, RPFiler, RPBase, RPCanvas, RPrinter, Mask,
  Gauges, RPMemo, RPDBUtil, RPDefine, (*Progress,*) Types, RPTXFilr, PASTypes,
  Progress, TabNotBk, ComCtrls;

type
  TRptAuditTrailForm = class(TForm)
    DataSource: TwwDataSource;
    Panel1: TPanel;
    Panel2: TPanel;
    ScrollBox: TScrollBox;
    CloseButton: TBitBtn;
    TitleLabel: TLabel;
    ScreenLabelTable: TwwTable;
    ReportPrinter: TReportPrinter;
    ReportFiler: TReportFiler;
    PrintDialog: TPrintDialog;
    SwisCodeTable: TwwTable;
    AuditTrailTable: TwwTable;
    PrintButton: TBitBtn;
    ScreenLabelPanel: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    ScreenListBox: TListBox;
    LabelListBox: TListBox;
    FinalizeFieldButton: TButton;
    SelectedStringGrid: TStringGrid;
    ClearRptSelectionsBtn: TButton;
    CloseScreenLabelPanel: TButton;
    TextFiler: TTextFiler;
    LoadButton: TBitBtn;
    SaveButton: TBitBtn;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    UserFieldDefinitionTable: TTable;
    TabbedNotebook1: TTabbedNotebook;
    TaxYearRadioGroup: TRadioGroup;
    IndexRadioGroup: TRadioGroup;
    ChooseFieldsToPrintGroupBox: TGroupBox;
    Label4: TLabel;
    Label5: TLabel;
    ScreenLblButton: TButton;
    PrintAllChangesCheckBox: TCheckBox;
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
    ParcelTable: TTable;
    AuditQuery: TQuery;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure ScreenListBoxClick(Sender: TObject);
    procedure FinalizeFieldButtonClick(Sender: TObject);
    procedure ClearRptSelectionsBtnClick(Sender: TObject);
    procedure TextReportPrintHeader(Sender: TObject);
    procedure ScreenLblButtonClick(Sender: TObject);
    procedure SBLEditExit(Sender: TObject);
    procedure PrintButtonClick(Sender: TObject);
    procedure DateGroupBoxClick(Sender: TObject);
    procedure AllSBLCheckBoxClick(Sender: TObject);
    procedure AllUsersCheckBoxClick(Sender: TObject);
    procedure AllDatesCheckBoxClick(Sender: TObject);
    procedure CloseButtonClick(Sender: TObject);
    procedure CloseScreenLabelPanelClick(Sender: TObject);
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

    PrintChangesForAllScreens,
    PrintAllUsers,
    PrintToEndOfUsers,
    CreateParcelList : Boolean;
    StartUser,
    EndUser : String;
    AssessmentYearChoosen : Integer;

    ScrLblPtr : ScreenLabelPtr;

    ScrLblList : Tlist;  {list of record = ScreenLabelLIst}

    StartingSwisSBL,
    EndingSwisSBL : String;
    SelectedSchoolCodes,
    SelectedSwisCodes : TStringList;

    Procedure InitializeForm;  {Open the ScreenLabelTables and setup.}

    Function ValidSelectionInformation : Boolean;
    {Have they filled in enough information in the selection boxes to print?}

    Function RecordInRange(TempDataSet : TDataSet;
                           TempDate : TDateTime;
                           SwisSBLKey : String;
                           SchoolCode : String;
                           Users : String;
                           AssessmentYear : String;
                           PrintChangesForAllScreens : Boolean) : Boolean;
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

const
  ayThisYear = 0;
  ayNextYear = 1;
  ayAllYears = 2;

{$R *.DFM}

{========================================================}
Procedure TRptAuditTrailForm.FormActivate(Sender: TObject);

begin
  SetFormStateMaximized(Self);
end;

{========================================================}
Procedure TRptAuditTrailForm.InitializeForm;

Var
  Lidx, I : Integer;
  Found : Boolean;

begin
  UnitName := 'RAUDITRL.PAS';  {mmm}

  OpenTablesForForm(Self, GlblProcessingType);

    {FXX11191999-7: Add user defined fields to search, audit, broadcast.}

  If (GlblProcessingType = History)
    then UserFieldDefinitionTable.SetRange([GlblHistYear], [GlblHistYear]);

  ScrLblList := TList.Create;

  LoadScreenLabelList(ScrLblList, ScreenLabelTable, UserFieldDefinitionTable, True,
                      False, False, [slAll]);

    {Now fill in the combo boxes.}

  For I := 0 to (ScrLblList.Count - 1) do
    with ScreenLabelPtr(ScrLblList[I])^ do
      begin
        Found := False;

         {then add the screen name to the screen string list if it is not}
         {already there}

        For Lidx := 0 to (ScreenListBox.Items.Count-1) do
          If (Take(30,ScreenListBox.Items[Lidx]) = Take(30, ScreenName))
            then Found := True;

        If not Found
          then ScreenListBox.Items.Add(Take(30, ScreenName));

       end;  {with ScreenLabelPtr(ScreenLabelList[I])^ do}

  ScreenListBox.Repaint;  {show the list}

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

    {FXX02011998-3: Hardcode the panel position so don't forget to set it.}

  with ScreenLabelPanel do
    begin
      Left := 30;
      Top := 50;
    end;

    {CHG12291999-1: Add swis \ school selection to audit reports.}

  FillOneListBox(SwisCodeListBox, SwisCodeTable, 'SwisCode',
                 'MunicipalityName', 25, True, True, GlblProcessingType, GetTaxRlYr);

  FillOneListBox(SchoolCodeListBox, SchoolCodeTable, 'SchoolCode',
                 'SchoolName', 25, True, True, GlblProcessingType, GetTaxRlYr);

end;  {InitializeForm}

{===================================================================}
Procedure TRptAuditTrailForm.FormKeyPress(    Sender: TObject;
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
Function TRptAuditTrailForm.RecordInRange(TempDataSet : TDataSet;
                                          TempDate : TDateTime;
                                          SwisSBLKey : String;
                                          SchoolCode : String;
                                          Users : String;
                                          AssessmentYear : String;
                                          PrintChangesForAllScreens : Boolean) : Boolean;

var
  I : Integer;
  SwisCode : String;

begin
  Result := True;
  SwisCode := Take(6, SwisSBLKey);

    {Now see if they are in the date range (if any) specified.}

  If not AllDatesCheckBox.Checked
    then
      begin
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

  If (Result and
      (not PrintChangesForAllScreens))
    then
      begin
        Result := False;  {no match yet}

        with TempDataSet, SelectedStringGrid do
          For I := 1 to RowCount do
            If (_Compare(Cells[0, I], FieldByName('ScreenName').Text, coEqual) and
                _Compare(Cells[1, I], FieldByName('LabelName').Text, coEqual))
              then Result := True;

     end;  {If (Result and ...}

  If (Result and
      (AssessmentYearChoosen <> ayAllYears))
    then
      begin
        Result := False;

        If ((AssessmentYearChoosen = ayThisYear) and
            (AssessmentYear = GlblThisYear))
          then Result := True;

        If ((AssessmentYearChoosen = ayNextYear) and
            (AssessmentYear = GlblNextYear))
          then Result := True;

      end;  {If (Result and}

    {CHG12291999-1: Allow swis \ school selections in audits.}

  If (Result and
      _Compare(Length(SwisSBLKey), 10, coGreaterThan) and
      (((Deblank(SwisCode) <> '') and
         (SelectedSwisCodes.IndexOf(SwisCode) = -1)) or
       (SelectedSchoolCodes.IndexOf(SchoolCode) = -1)))
    then Result := False;

end;  {RecordInRange}

{=====================================================================}
Function TRptAuditTrailForm.ValidSelectionInformation : Boolean;

{Have they filled in enough information in the selection boxes to print?}

begin
  Result := True;

    {They have to select a type of note to print.}

  If (TaxYearRadioGroup.ItemIndex = -1)
    then
      begin
        MessageDlg('Please select an assessment year. ', mtError, [mbOK], 0);
        Result := False;
      end;

    {If they selected tickler or both note types, they need to fill in a notes
     status.}

  If ((Result and
      (TaxYearRadioGroup.ItemIndex in [1, 2]) and
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
Procedure TRptAuditTrailForm.ScreenListBoxClick(Sender: TObject);

Var
  Lidx, SelIdx : Integer;

begin
LabelListBox.Clear;  {clear label list of any prior labels from prev }
                     {screen selection}

  {get the current screen which is selected and fill in labels list}
  {for the currently selected screen}
SelIdx := ScreenListBox.ItemIndex;
For Lidx := 0 to  (ScrLblList.Count-1)
    do If (Take(30,ScreenLabelPtr(ScrLblList[LIdx])^.ScreenName))
                               =
          (Take(30,ScreenListBox.Items[SelIdx]))
      then LabelListBox.Items.Add((Take(30,ScreenLabelPtr(ScrLblList[LIdx])^.LabelName)));
LabelListBox.Repaint;

end;

procedure TRptAuditTrailForm.FinalizeFieldButtonClick(Sender: TObject);

Var
Ridx,
I,
SelScrIdx,
Lidx : Integer;
Quit,
Found : Boolean;

begin
Quit := False;
SelScrIdx := ScreenListBox.ItemIndex;  {current Screen}

{First remove any scr/lbl occurences not selected in the current}
{scr/lbl selection sequence from the report selectiion str grid}

   {look at each line of str grid, if not empty, see if it is }
   {selected in scr/lbl list boxes, if not delete it}

 RIdx := 1;
 Repeat
 If (Deblank(SelectedStringGrid.cells[0, Ridx]) <> '' )
                       AND
          {if screen name is the one we are working on...}
    (  (Take(30,SelectedStringGrid.cells[0, Ridx]))
                        =
          (Take(30,ScreenListBox.Items[SelScrIdx]))
    )
       then
       begin
         {screen name the same so see if label needs to be}
         {deselected}
       For Lidx := 0 to (LabelListBox.Items.Count-1)
              {if the select lbl = lbl list box but its not sel}
              {in lbllist box, remove it from selected grid}
           do If ( (Take(30,SelectedStringGrid.Cells[1,Ridx])
                          =
                  Take(30,LabelListBox.Items[Lidx]))
                 )
                          AND

                ( NOT LabelListBox.Selected[Lidx])


                then
                begin
                SelectedStringGrid.cells[0, Ridx] := '';
                SelectedStringGrid.cells[1, Ridx] := '';
                end;
       end
       else; {skip, row emppty}
 Ridx := Ridx + 1;
 Until Ridx > (SelectedStringGrid.Rowcount );


 {now put all labels selected in selected grid}
Lidx := 0;
Repeat
  {if selected in lable list, see if its in selelct grid, if not}
  {select it}
If  LabelListBox.Selected[Lidx]
   then
   begin
   Found := False;
   {if item already in list do not save it}
   For I :=  1 to (SelectedStringGrid.Rowcount )
    Do if (  ( (Take(30,SelectedStringGrid.cells[0, I])) =
               (Take(30,ScreenListBox.Items[SelScrIdx]))
             )                AND
             ( (Take(30,SelectedStringGrid.cells[1, I])) =
               (Take(30,LabelListBox.Items[LIdx]))
             )
          )
          then Found := True;
      {find empty slot in grid and store scr/lbls}
   If NOT Found
     then
     begin
     Found := False;
     I := 1;
     Repeat
     If (Deblank(SelectedStringGrid.cells[0, I]) = '')
                        AND
      (Deblank(SelectedStringGrid.cells[1, I]) = '')
      then
      begin
        {save the screen and label name in the tstring grid}
      SelectedStringGrid.cells[0, I] :=
        (Take(30,ScreenListBox.Items[SelScrIdx]));
      SelectedStringGrid.cells[1, I] :=
        (Take(30,LabelListBox.Items[LIdx]));
       Found := True;

      end
      else I := I + 1;
     If I > SelectedStringGrid.RowCount
      then
      begin
      MessageDlg('You Have Exceeded The Allowed Number of' + #13
              + 'Selected Fields for This Report',
                          mtError, [mbOK], 0);
      Quit := True;
      end;
     Until Found Or Quit;
     end;
   end;  {end lable list is selected}
Lidx := Lidx + 1;
Until Lidx >  (LabelListBox.Items.Count-1);

SelectedStringGrid.Repaint;
end;

procedure TRptAuditTrailForm.ClearRptSelectionsBtnClick(Sender: TObject);
Var
   Ridx : Integer;

begin
 For Ridx := 1 to  (SelectedStringGrid.Rowcount )

  do
  begin
   SelectedStringGrid.cells[0, Ridx] := '';
   SelectedStringGrid.cells[1, Ridx] := '';
  end;
SelectedStringGrid.Repaint;
end;

{=======================================================================}
Procedure TRptAuditTrailForm.ScreenLblButtonClick(Sender: TObject);

begin
  ScreenLabelPanel.Show;
end;

procedure TRptAuditTrailForm.SBLEditExit(Sender: TObject);
Var
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
     (*Abort;*)
     end;
   end;
end;

procedure TRptAuditTrailForm.DateGroupBoxClick(Sender: TObject);
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

procedure TRptAuditTrailForm.AllSBLCheckBoxClick(Sender: TObject);
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

procedure TRptAuditTrailForm.AllUsersCheckBoxClick(Sender: TObject);
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

procedure TRptAuditTrailForm.AllDatesCheckBoxClick(Sender: TObject);
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

procedure TRptAuditTrailForm.CloseButtonClick(Sender: TObject);
begin
Close;
end;

procedure TRptAuditTrailForm.CloseScreenLabelPanelClick(Sender: TObject);
begin
  {FXX02011998-2: Make sure that the check box is not checked if
                  they select individual fields.}

PrintAllChangesCheckBox.Checked := False;

ScreenLabelPanel.Hide;
PrintButton.SetFocus;

end;

{====================================================================}
Procedure TRptAuditTrailForm.SaveButtonClick(Sender: TObject);

{FXX04091999-8: Add ability to save and load search report options.}

begin
  SaveReportOptions(Self, OpenDialog, SaveDialog, 'audit.aud', 'Audit Trail Report');

end;  {SaveButtonClick}

{====================================================================}
Procedure TRptAuditTrailForm.LoadButtonClick(Sender: TObject);

{FXX04091999-8: Add ability to save and load search report options.}

begin
  LoadReportOptions(Self, OpenDialog, 'audit.aud', 'Audit Trail Report');

end;  {LoadButtonClick}

{========================================================================}
{==================  PRINTING  ==========================================}
{======================================================================}
Procedure TRptAuditTrailForm.PrintButtonClick(Sender: TObject);

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

        AssignPrinterSettings(PrintDialog, ReportPrinter, ReportFiler, [ptBoth], True, Quit);

          {CHG03122007-1(MDT)[2.11.1.18]: Prompt for letter size print.}

        If (ReportPrinter.Orientation = poLandscape)
          then PromptForLetterSize(ReportPrinter, ReportFiler, 80, 80, 1.5);

        If not Quit
          then
            begin
              ProgressDialog.UserLabelCaption := '';

               {FXX01201998-11: Allow them to print all changes.}

              PrintChangesForAllScreens := PrintAllChangesCheckBox.Checked;

               {FXX01201998-10: Only let user Supervisor choose other users to
                                see the changes for.}

                {CHG06092010-3(2.26.1)[I7208]: Allow for supervisor equivalents.}
                
              PrintAllUsers := AllUsersCheckBox.Checked;
              PrintToEndOfUsers := ToEndOfUsersCheckBox.Checked;
              StartUser := Take(10, StartUserEdit.Text);
              EndUser := Take(10, EndUserEdit.Text);

                {CHG02282001-1: Allow everybody to everyone elses changes.}


                {FXX03021998-1: Choose based on year that they selected.}

              AssessmentYearChoosen := TaxYearRadioGroup.ItemIndex;

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

                    ShowReportDialog('AUDITTRL.RPT', TextFiler.FileName, True);

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
Procedure SetupMainSection(Sender : TObject;
                           _PrintHeader : Boolean);

{FXX03021998-2: Only set the tabs and header in one place.}

begin
  with Sender as TBaseReport do
    begin
      ClearTabs;

      If _PrintHeader
        then
          begin
            ClearTabs;
            SetTab(10.5, pjLeft, 2.2, 0, BOXLINENONE, 0);   {Old Value}
            Println(#9 + 'Old Value');

            ClearTabs;
            SetTab(0.2, pjCenter, 2.0, 0, BOXLINEBOTTOM, 0);   {SBL}
            SetTab(2.3, pjCenter, 1.0, 0, BOXLINEBOTTOM, 0);   {Date Entered}
            SetTab(3.5, pjCenter, 0.8, 0, BOXLINEBOTTOM, 0);   {Time}
            SetTab(4.4, pjCenter, 1.0, 0, BOXLINEBOTTOM, 0);   {User}
            SetTab(5.5, pjCenter, 0.4, 0, BOXLINEBOTTOM, 0);   {Year}
            SetTab(6.0, pjLeft, 1.9, 0, BOXLINEBOTTOM, 0);   {FormName}
            SetTab(8.0, pjLeft, 2.4, 0, BOXLINEBOTTOM, 0);   {Label Name}
            SetTab(10.5, pjLeft, 2.5, 0, BOXLINEBOTTOM, 0);   {Old Value}

            Println(#9 + 'Parcel ID' +
                    #9 + 'Date ' +
                    #9 + 'Time' +
                    #9 + 'User' +
                    #9 + 'Yr' +
                    #9 + 'Screen' +
                    #9 + 'Field' +
                    #9 + 'New Value');

            Println('');

          end;  {If _PrintHeader}

      ClearTabs;
      SetTab(0.2, pjLeft, 2.0, 0, BOXLINEBOTTOM, 0);   {SBL}
      SetTab(2.3, pjLeft, 1.0, 0, BOXLINEBOTTOM, 0);   {Date Entered}
      SetTab(3.5, pjLeft, 0.8, 0, BOXLINEBOTTOM, 0);   {Time}
      SetTab(4.4, pjLeft, 1.0, 0, BOXLINEBOTTOM, 0);   {User}
      SetTab(5.5, pjLeft, 0.4, 0, BOXLINEBOTTOM, 0);   {Year}
      SetTab(6.0, pjLeft, 1.9, 0, BOXLINEBOTTOM, 0);   {FormName}
      SetTab(8.0, pjLeft, 2.4, 0, BOXLINEBOTTOM, 0);   {Label Name}
      SetTab(10.5, pjLeft, 2.5, 0, BOXLINEBOTTOM, 0);   {Old Value}

    end;  {with Sender as TBaseReport do}

end;  {SetupMainSection}

{====================================================================}
Procedure TRptAuditTrailForm.TextReportPrintHeader(Sender: TObject);

Var
  FirstLine,
  Done : boolean;
  I,
  LabelPos : Integer;
  CurScreen : String;

begin
  with Sender as TBaseReport do
    begin
      ClearTabs;
      SetTab(0.3, pjLeft, 13.0, 0, BoxLineNone, 0);

        {Print the date and page number.}

      Println(Take(43, GetMunicipalityName) +
              Center('Audit Trail Report', 43) +
              RightJustify('Date: ' + DateToStr(Date) +
                           '  Time: ' + FormatDateTime(TimeFormat, Now), 43));

      Println(RightJustify('Page: ' + IntToStr(CurrentPage), 129));

      ClearTabs;
      SetTab(0.4, pjLeft, 90, 0, BOXLINENONE, 0);   {Index}

        {Print the selection information.}

      Print(#9 + 'Index:  ');
      case IndexRadioGroup.ItemIndex of
        0 : Println(' SBL');
        1 : Println(' Date');
        2 : Println(' User');
      end;  {case IndexRadioGroup of}

      Print(#9 + 'Assessment Year:');
      case TaxYearRadioGroup.ItemIndex of
        0 : Println(' This Year');
        1 : Println(' Next Year');
        2 : Println(' All');
      end;  {case NoteTypeRadioGroup.ItemIndex of}

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

      Print(#9 + 'For Data Fields: ');

      If PrintChangesForAllScreens
        then Println('All')
        else
          begin
            Println('');
            ClearTabs;
            SetTab(0.5, pjLeft, 1.5, 0, BOXLINENONE, 0);   {scrname}
            SetTab(2.5, pjLeft, 1.5, 0, BOXLINENONE, 0);   {lbl 1}
            SetTab(4.0, pjLeft, 1.5, 0, BOXLINENONE, 0);   {lbl 2}
            SetTab(5.5, pjLeft, 1.5, 0, BOXLINENONE, 0);   {lbl 3}
            SetTab(7.0, pjLeft, 1.5, 0, BOXLINENONE, 0);   {lbl 4}

            LabelPos := 1;  {start in 1st lblb pos. & go over 4}
            Done := False;
            I := 1;
            CurScreen := Take(30,' ');
            FirstLine := True;
            Repeat
            If (Deblank(SelectedStringGrid.Cells[0,I]) <> '')
                    {if a new screen name, process new line}
                then If (  (Take(30,CurScreen)) <>
                           (Take(30,SelectedStringGrid.Cells[0,I]))
                        )
                    then
                    begin
                    LabelPos := 1;
                    If FirstLine
                       then FirstLine := False   {no new line for first scrn/lbl}
                       else PrintLn('');      {new line}
                       {print screen name}
                    Print(#9 + Take(13, Rtrim(SelectedStringGrid.Cells[0,I])) + ':');
                       {print label}
                    Print(#9 + Take(13, SelectedStringGrid.Cells[1,I]));
                      {go left to right}
                    LabelPos := LabelPos + 1;
                      {set new screen name}
                    CurScreen := Take(30,SelectedStringGrid.Cells[0,I]);
                    end
                    else
                     {same screen name, put out another label on same or nxt line}
                    begin
                      {if at end of line, go to next line with same scr name}
                      {diff label name}
                    If LabelPos > 3
                       then
                       BEGIN
                       Println('');
                       Print(#9);
                       LabelPos := 1;
                       END;
                    Print(#9 + Take(13, SelectedStringGrid.Cells[1,I]));
                    LabelPos := LabelPos + 1;

                    end;

            I := I + 1;
            If I > SelectedStringGrid.Rowcount
               then Done := True;
            Until Done;

            Println('');

          end;  {else of If PrintChangesForAllScreens}

      SetupMainSection(Sender, True);

    end;  {with Sender as TBaseReport do}

end;  {ReportFilerPrintHeader}

{====================================================================}
Procedure TRptAuditTrailForm.TextReportPrint(Sender: TObject);

var
  TempStr : String;
  Done, FirstTimeThrough, Quit, SQLCase, ValidEntry : Boolean;
  NumChanged : LongInt;
  PreviousDate, PreviousTime, PreviousUser,
  PreviousParcelID, PreviousScreen, PreviousTaxRollYr : String;
  SwisSBLKey : String;
  SBLRec : SBLRecord;
  StartingUser, EndingUser : String;
  StartingDate, EndingDate, DateEntered : TDateTime;
  TempDataSet : TDataSet;

begin
  Done := False;
  FirstTimeThrough := True;
  Quit := False;
  NumChanged := 0;
  StartingSwisSBL := '';
  EndingSwisSBL := '999999';
  StartingDate := StrToDate('1/1/1950');
  EndingDate := StrToDate('1/1/2900');
  StartingUser := '';
  EndingUser := 'ZZZZZ';

  If not AllDatesCheckBox.Checked
    then
      begin
        try
          StartingDate := StrToDate(StartDateEdit.Text);
        except
        end;

        If not ToEndofDatesCheckBox.Checked
          then
            try
              EndingDate := StrToDate(EndDateEdit.Text);
            except
            end;

      end;  {If not AllDatesCheckBox.Checked}

  If not AllUsersCheckBox.Checked
    then
      begin
        try
          StartingUser := StartUserEdit.Text;
        except
        end;

        If not ToEndofUsersCheckBox.Checked
          then
            try
              EndingUser := EndUserEdit.Text;
            except
            end;

      end;  {If not AllUsersCheckBox.Checked}

  If not AllSBLCheckBox.Checked
    then
      begin
        StartingSwisSBL := ConvertSwisDashDotToSwisSBL(StartSBLEdit.Text,
                                                       SwisCodeTable, ValidEntry);

        If not ToEndOfSBLCheckBox.Checked
          then EndingSwisSBL := ConvertSwisDashDotToSwisSBL(EndSBLEdit.Text,
                                                            SwisCodeTable, ValidEntry);
      end;  {If not AllSBLCheckBox.Checked}

  with AuditTrailTable do
    begin
      IndexDefs.Update;
      SQLCase := False;

      If _Compare(IndexDefs.Count, 0, coEqual)
        then
          begin
            SQLCase := True;

              {FXX06012007-1(2.11.1.35): Correct the SQL statement so that
                                         it takes all parameters into account.}

            with AuditQuery.SQL do
              begin
                Clear;
                Add('Select * from AuditTable where');
                Add('(SwisSBLKey >= ' + FormatSQLString(StartingSwisSBL) + ') and');
                Add('(SwisSBLKey <= ' + FormatSQLString(EndingSwisSBL) + ') and');
                Add('(DateEntered >= ' + FormatSQLString(DateToStr(StartingDate)) + ') and');
                Add('(DateEntered <= ' + FormatSQLString(DateToStr(EndingDate)) + ') and');
                Add('(UserEnteredBy >= ' + FormatSQLString(StartingUser) + ') and');
                Add('(UserEnteredBy <= ' + FormatSQLString(EndingUser) + ')');

              end;  {with AuditQuery.SQL do}

            with AuditQuery do
              try
                case IndexRadioGroup.ItemIndex of
                  0 : SQL.Add('Order By SwisSBLKey, DateEntered, TimeEntered');
                  1 : SQL.Add('Order By DateEntered, TimeEntered, SwisSBLKey');
                  2 : SQL.Add('Order By UserEnteredBy, DateEntered, TimeEntered');

                end;  {case IndexRadioGroup.ItemIndex of}

                Open;
              except
              end;

            ProgressDialog.Start(AuditQuery.RecordCount, True, True);

          end
        else
          begin
            case IndexRadioGroup.ItemIndex of
              0 : begin  {SBL}
                    IndexName := 'BYSBL_DATE_TIME';

                    If not AllSBLCheckBox.Checked
                      then SetRangeOld(AuditTrailTable,
                                       ['SwisSBLKey', 'Date', 'Time'],
                                       [StartingSwisSBL, '1/1/1900', ''],
                                       [EndingSwisSBL, '1/1/2300', '']);

                  end;   {SBL}

              1 : begin  {Date }
                    IndexName := 'BYDATE_TIME_SBL';

                      {Set a range if they specified a range.}
                      {FXX01132000-1: Don't put an end range if they want to end of range.}
                      {FXX01132000-2: Actually as a Y2K fix, will just search until after end of
                                      end date.}

                    If not AllDatesCheckBox.Checked
                      then FindNearestOld(AuditTrailTable,
                                          ['Date', 'Time', 'SwisSBLKey'],
                                          [StartDateEdit.Text, '', '']);

                  end;   {Date }

              2 : begin  {User}
                    IndexName := 'BYUSER_DATE_TIME';

                      {Set a range if they specified a range.}

                    If not AllUsersCheckBox.Checked
                      then
                        If ToEndofDatesCheckBox.Checked
                          then SetRangeOld(AuditTrailTable, ['User', 'Date', 'Time'],
                                           [StartUserEdit.Text, '1/1/1900', ''],
                                           [EndUserEdit.Text, '1/1/2300', ''])
                          else SetRangeOld(AuditTrailTable, ['User', 'Date', 'Time'],
                                           [StartUserEdit.Text, '1/1/1900', ''],
                                           [EndUserEdit.Text, '1/1/2300', '']);

                  end; {User}

            end;  {case IndexRadioGroup of}

            ProgressDialog.Start(GetRecordCount(AuditTrailTable), True, True);

               {Get the first record.}

            If ((IndexRadioGroup.ItemIndex in [0, 2]) or
                AllDatesCheckBox.Checked)
              then AuditTrailTable.First;

          end;  {else of If _Compare(IndexDefs.Count, 0, coEqual)}

    end;  {with AuditTrailTable do}

    {CHG03161998-1: Track exemption, SD adds, av changes, parcel add/del.}

  with Sender as TBaseReport do
    begin
      PreviousDate := '';
      PreviousTime := '';
      PreviousUser := '';
      PreviousParcelID := '';
      PreviousScreen := '';
      PreviousTaxRollYr := '';

      If SQLCase
        then TempDataSet := AuditQuery
        else TempDataSet := AuditTrailTable;

        {First print the individual changes.}


      repeat
        If FirstTimeThrough
          then FirstTimeThrough := False
          else TempDataSet.Next;

        If SQLCase
          then DateEntered := TempDataSet.FieldByName('DateEntered').AsDateTime
          else DateEntered := TempDataSet.FieldByName('Date').AsDateTime;

        If (TempDataSet.EOF or
            ((not SQLCase) and
             (IndexRadioGroup.ItemIndex = 1) and
             (not AllDatesCheckBox.Checked) and
             (not ToEndofDatesCheckBox.Checked) and
             (DateEntered > StrToDate(EndDateEdit.Text))))
          then Done := True;

          {Print the present record.}

        If not (Done or Quit)
          then
            begin
              Application.ProcessMessages;

              {Update the progress panel.}

              with TempDataSet do
                case IndexRadioGroup.ItemIndex of
                  0 : ProgressDialog.Update(Self,
                                            ConvertSwisSBLToDashDot(FieldByName('SwisSBLKey').Text));
                  1 : ProgressDialog.Update(Self, DateToStr(DateEntered));
                  2 : ProgressDialog.Update(Self, FieldByName('User').Text);

                end;  {case IndexRadioGroup.ItemIndex of}

                {CHG01211998-3: Allow tracking of EX, SD deletions.}

              SBLRec := ExtractSwisSBLFromSwisSBLKey(TempDataSet.FieldByName('SwisSBLKey').Text);

              with SBLRec do
                FindKeyOld(ParcelTable,
                           ['TaxRollYr', 'SwisCode', 'Section',
                            'Subsection', 'Block', 'Lot',
                            'Sublot', 'Suffix'],
                           [GetTaxRlYr, SwisCode, Section, Subsection,
                            Block, Lot, Sublot, Suffix]);

              with TempDataSet do
                If RecordInRange(TempDataSet,
                                 DateEntered,
                                 FieldByName('SwisSBLKey').Text,
                                 ParcelTable.FieldByName('SchoolCode').Text,
                                 FieldByName('User').Text,
                                 FieldByName('TaxRollYr').Text,
                                 PrintChangesForAllScreens)
                  then
                    begin
                      NumChanged := NumChanged + 1;
                      TempStr := FieldByName('OldValue').Text;

                      If (Deblank(TempStr) = '')
                        then TempStr := '{none}';

                        {FXX11171997-3: The field "FormName" was being printed
                                        out, but should be "ScreenName".}

                        {FXX12221998-3: If the parcel ID, user year, date and time are all the
                                        same, then print as one change.}

                      If ((PreviousDate = DateToStr(DateEntered)) and
                          (PreviousTime = AuditTrailTable.FieldByName('Time').Text) and
                          (Take(30, PreviousScreen) = Take(30, AuditTrailTable.FieldByName('ScreenName').Text)) and
                          (Take(26, PreviousParcelID) = Take(26, AuditTrailTable.FieldByName('SwisSBLKey').Text)) and
                          (Take(10, PreviousUser) = Take(10, AuditTrailTable.FieldByName('User').Text)) and
                          (Take(4, PreviousTaxRollYr) = Take(4, AuditTrailTable.FieldByName('TaxRollYr').Text)))
                        then Print(#9 + #9 + #9 + #9 + #9 + #9)
                        else Print(#9 + ConvertSwisSBLToDashDot(FieldByName('SwisSBLKey').Text) +
                                   #9 + DateToStr(DateEntered) +
                                   #9 + FormatDateTime(TimeFormat, FieldByName('Time').AsDateTime) +
                                   #9 + FieldByName('User').Text +
                                   #9 + FieldByName('TaxRollYr').Text +
                                   #9 + FieldByName('ScreenName').Text);

                      Println(#9 + FieldByName('LabelName').Text +
                              #9 + TempStr);

                      TempStr := FieldByName('NewValue').Text;

                      If (Deblank(TempStr) = '')
                        then TempStr := '{none}';

                      Println(#9 +
                              #9 +
                              #9 +
                              #9 +
                              #9 +
                              #9 +
                              #9 +
                              #9 + TempStr);
                      Println('');

                        {FXX12221998-3: If the parcel ID, user year, date and time are all the
                                        same, then print as one change.}
                        {FXX08061999-1: Only update the previous info if it actually changed.}

                      PreviousDate := DateToStr(DateEntered);
                      PreviousTime := FieldByName('Time').Text;
                      PreviousScreen := FieldByName('ScreenName').Text;
                      PreviousUser := FieldByName('User').Text;
                      PreviousParcelID := FieldByName('SwisSBLKey').Text;
                      PreviousTaxRollYr := FieldByName('TaxRollYr').Text;

                        {CHG11151999-3: Add create parcel list to audits, ex letters.}
                        {FXX12291999-2: Every parcel was being added to the list - was
                                        in wrong place.}

                      If (CreateParcelList and
                          (not ParcelListDialog.ParcelExistsInList(SwisSBLKey)))
                        then ParcelListDialog.AddOneParcel(SwisSBLKey);

                    end;  {with AuditTrailTable do}

                {If there is only one line left to print, then we
                 want to go to the next page.}
                {FXX03242007-1(2.11.1.21): Make sure to make the new page
                                           comparison <= in case GlblLinesLeftOnRollDotMatrix is 0.} 

              If (LinesLeft <= GlblLinesLeftOnRollDotMatrix)
                then NewPage;

              SwisSBLKey := TempDataSet.FieldByName('SwisSBLKey').Text;

            end;  {If not (Done or Quit)}

        ReportCancelled := ProgressDialog.Cancelled;

      until (Done or Quit or ReportCancelled);

        {FXX01231998-5: Tell them if nothing in range.}

      If (NumChanged = 0)
        then Println('None.');

    end;  {with Sender as TBaseReport do}

end;  {ReportPrinterPrint}

{===========================================================}
Procedure TRptAuditTrailForm.ReportPrint(Sender: TObject);

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
Procedure TRptAuditTrailForm.FormClose(    Sender: TObject;
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