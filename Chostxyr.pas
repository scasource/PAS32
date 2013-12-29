unit Chostxyr;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, ExtCtrls, Buttons, DB, DBTables,
  Tabs, Menus, GlblCnst;

type
  TChooseTaxYearForm = class(TForm)
    CancelButton: TBitBtn;
    OKButton: TBitBtn;
    ChooseTaxYearRadioGroup: TRadioGroup;
    UserProfileTable: TTable;
    EditHistoryYear: TEdit;
    ParcelTable: TTable;
    AssessmentYearControlTable: TTable;
    procedure CancelButtonClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
    procedure EditHistoryYearEnter(Sender: TObject);
    procedure EditHistoryYearExit(Sender: TObject);
    procedure ChooseTaxYearRadioGroupClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    OrigTaxYearFlg : Char;
    CurrentTaxYearLabel : TLabel;  {The tax year label on the user info panel.}
    MainFormTabSet : TTabSet;  {The tab set from the main from in case we need to close
                                all of the menu items.}
    FormCaptions : TStringList; {The form captions of all open mdi children - we will
                                 have to clear it if they change tax years.}
    CloseResult : Integer;  {Did they cancel or accept?}
    UnitName : String;  {For error dialog box.}
    HaveAccess : Boolean;
    ChangeThisYearandNextYearTogether : TMenuItem;

  end;

var
  ChooseTaxYearForm : TChooseTaxYearForm;

implementation

{$R *.DFM}

uses WinUtils, PASUTILS, UTILEXSD,  GlblVars, Utilitys, MainForm, Types;

{=========================================================}
Procedure TChooseTaxYearForm.FormActivate(Sender: TObject);

begin
  UnitName := 'CHOSTXYR.PAS';

  try
    UserProfileTable.Open;
  except
    SystemSupport(001, UserProfileTable, 'Error opening user profile table.',
                  UnitName, GlblErrorDlgBox);
  end;

    {Change the radio group to include the year.}

  ChooseTaxYearRadioGroup.Items.Clear;
  ChooseTaxYearRadioGroup.Items.Add('Next Year (' + GlblNextYear + ')');
  ChooseTaxYearRadioGroup.Items.Add('This Year (' + GlblThisYear + ')');
  ChooseTaxYearRadioGroup.Items.Add('History');

  OrigTaxYearFlg := GlblTaxYearFlg;

    {Set the button to the right spot in the radio group.}

  case OrigTaxYearFlg of
    'H' : ChooseTaxYearRadioGroup.ItemIndex := 2;
    'T' : ChooseTaxYearRadioGroup.ItemIndex := 1;
    'N' : ChooseTaxYearRadioGroup.ItemIndex := 0;

  end;  {case OrigTaxYearFlg of}

end;  {FormActivate}

{================================================================}
Procedure TChooseTaxYearForm.CancelButtonClick(Sender: TObject);

begin
  CloseResult := idCancel;
  Close;
end;

{==================================================================}
Procedure TChooseTaxYearForm.OKButtonClick(Sender: TObject);

{See if they changed tax years. If they did, check to see if they are allowed
 to have access to this tax year. If they are, then close any open jobs and
 put them in the new processing status.}

var
  CanClose, Proceed, UserFound, Quit : Boolean;
  NewTaxYearFlg : Char;
  I : Integer;
  YearStr : String;
  OrigHistYear : String;

begin
  OrigHistYear := GlblHistYear;
  UserFound := True;
  NewTaxYearFlg := ' ';

  case ChooseTaxYearRadioGroup.ItemIndex of
    -1 : begin
           MessageDlg('Please choose a tax year or click Cancel to end.', mtError, [mbOK], 0);
         end;

    0 : begin
          NewTaxYearFlg := 'N';
          YearStr := 'Next Year';
        end;

    1 : If (MessageDlg('Are you sure that you want to switch to the' + #13 +
                       'This Year (' + GlblThisYear + ') assessment roll?', mtConfirmation, [mbYes, mbNo], 0) = idYes)
          then
            begin
              NewTaxYearFlg := 'T';
              YearStr := 'This Year';
            end;

    2 : begin
          HaveAccess := False;
          OpenTableForProcessingType(ParcelTable, ParcelTableName, History, Quit);

          FindNearestOld(ParcelTable, ['TaxRollYr', 'Name1'],
                         [EditHistoryYear.Text, '']);

          If ((not ParcelTable.EOF) and
              (Take(4, EditHistoryYear.Text) =
               Take(4, ParcelTable.FieldByName('TaxRollYr').AsString)))
            then
              begin
                HaveAccess := True;
                GlblHistYear := EditHistoryYear.Text;
                NewTaxYearFlg := 'H';
                YearStr := 'History';

              end;  {If ((not ParcelTable.EOF) and ...}

          If not HaveAccess
            then
              begin
                MessageDlg('Invalid Assessement History Year. ' + #13 +
                           'Please try again.', mtWarning,  [mbOK], 0);
                EditHistoryYear.SetFocus;
              end;

          ParcelTable.Close;

        end;  {History}

  end;  {case ChooseTaxYearRadioGroup.ItemIndex of}

    {Did they change tax years?}
    {FXX11191999-11: Problem switching from one year of history to another.}

  If (ChooseTaxYearRadioGroup.ItemIndex <> -1)
    then
      If ((NewTaxYearFlg <> OrigTaxYearFlg) or
          ((NewTaxYearFlg = 'H') and
           (OrigHistYear <> GlblHistYear)))
        then
          begin
            HaveAccess := False;
            GlblDialogBoxShowing := True;

            try
              UserProfileTable.FindNearest([Take(10, GlblUserName)]);
            except
              SystemSupport(002, UserProfileTable, 'Error getting user profile record.',
                            UnitName, GlblErrorDlgBox);
            end;

            If _Compare(GlblUserName, UserProfileTable.FieldByName('UserID').Text, coEqual)
              then
                begin
                    {Determine if they have access to this tax year.}

                  If (NewTaxYearFlg = 'H')
                    then
                      If UserProfileTable.FieldByName('HistoryAccess').AsBoolean
                        then HaveAccess := True
                        else MessageDlg('Sorry. You do not have history access.' + #13 +
                                        'Please chose a different tax year.', mtWarning,
                                        [mbOK], 0);

                  If (NewTaxYearFlg = 'T')
                    then
                      If _Compare(UserProfileTable.FieldByName('ThisYearAccess').AsInteger, 0, coGreaterThan)
                        then HaveAccess := True
                        else MessageDlg('Sorry. You do not have this year access.' + #13 +
                                        'Please chose a different tax year.', mtWarning,
                                        [mbOK], 0);

                  If (NewTaxYearFlg = 'N')
                    then
                      If _Compare(UserProfileTable.FieldByName('NextYearAccess').AsInteger, 0, coGreaterThan)
                        then HaveAccess := True
                        else MessageDlg('Sorry. You do not have next year access.' + #13 +
                                        'Please chose a different tax year.', mtWarning,
                                        [mbOK], 0);

                end
              else
                begin
                  HaveAccess := False;
                  UserFound := False;
                end;

              {If we found the user record and they have access to this tax year, then
               let's close all other jobs, display a message saying that they are now in
               the new year, actually change the new year, and then close.}

            If (UserFound and HaveAccess)
              then
                begin
                  Proceed := True;

                    {If there is only one MDI child then it is this form, and we don't need to
                     ask them about closing all the open menu items.}

                  If (Application.MainForm.MDIChildCount > 0)
                    then
                      begin
                          {FXX11131997-1: Still having problems with
                                          closing all children, so don't
                                          let them for now.}

                        MessageDlg('Please close all open menu items before changing assessment year.',
                                   mtInformation, [mbOK], 0);

                        Proceed := False;

                        (*ReturnCode := MessageDlg('Warning! To change to a new tax year, ' + #13 +
                                                 'all open menu items will be closed.' + #13 +
                                                 'Do you want to proceed?', mtWarning,
                                                 [mbYes, mbNo], 0);

                        Proceed := (ReturnCode = idYes);*)

                      end;  {If (Application.MainForm.MDIChildCount > 1)}

                  If Proceed
                    then
                      begin
                        CanClose := True;

                          {Close all the other jobs.}

                        with Application.MainForm do
                          begin
                            I := 0;

                              {First let's go through each child form and make sure that it
                               is ok to close it by calling the CloseQuery method.
                               If CloseQuery comes back True for all forms, then we will
                               close the forms. However, if CloseQuery comes back False for
                               any form, we will not close any forms, and no tax year change
                               will be done.}

                            while (CanClose and
                                   (I <= (MDIChildCount - 1))) do
                              begin
                                CanClose := MDIChildren[I].CloseQuery;
                                I := I + 1;

                              end;  {while (CanClose and ...}

                              {FXX10281997-1: Try to fix GPF problem when
                               switching between years
                               by moving the close to the main form.}
                              {FXX11131997-2: Move the close of children
                                              back here since moving it
                                              to main form did not work.}

                              {All form's CloseQuery returned True, so now close all the
                               child forms. Note that this is not a child form.}

                            If CanClose
                              then
                                For I := 0 to (MDIChildCount - 1) do
                                  MDIChildren[I].Close;

                          end;  {with Application.MainForm do}

                          {If we were able to close all child forms except this one, then
                           change the tax year flag, update the label on the main form,
                           and display a message.}

                        If CanClose
                          then
                            begin
                              GlblTaxYearFlg := NewTaxYearFlg;
                              GlblProcessingType := DetermineProcessingType(GlblTaxYearFlg);

                                {CHG11101997-1: Allow user to set dual processing.}

                              If not GlblUserIsSearcher
                                then
                                  If (GlblProcessingType = ThisYear)
                                    then
                                      begin
                                        ChangeThisYearandNextYearTogether.Enabled := True;

                                          {FXX04071998-6: Must keep track of whether or not
                                                          dual processing mode is on for TY.}

                                        If GlblModifyBothYearsCheckedInTY
                                          then ChangeThisYearandNextYearTogether.Checked := True;

                                          {FXX04071998-5: If are switching back to TY from
                                                          NY, need to determine if
                                                          global processing mode on.}

                                         GlblModifyBothYears := ChangeThisYearandNextYearTogether.Checked;
                                      end
                                    else
                                      begin
                                          {FXX04071998-6: Must keep track of whether or not
                                                          dual processing mode is on for TY.}

                                          {FXX01312006-1(2.9.5.3): Don't reset the modify TY & NY flag if they switch years.
                                                                   Always put it back to the default when they come back to TY.} 

                                        (*GlblModifyBothYearsCheckedInTY := ChangeThisYearandNextYearTogether.Checked;*)
                                        ChangeThisYearandNextYearTogether.Enabled := False;
                                        ChangeThisYearandNextYearTogether.Checked := False;

                                          {FXX11151998-1: Must turn off glbl modify in NY so
                                                          don't modify backwards.}

                                        GlblModifyBothYears := False;

                                      end;  {else of If (GlblProcessingType = ThisYear)}

                                {FXX06241998-1: The veterans maximums need to be
                                                at the county and swis level.}

                              OpenTableForProcessingType(AssessmentYearControlTable,
                                                         AssessmentYearControlTableName,
                                                         GlblProcessingType,
                                                         Quit);

                                {FXX02101999-3 Split the SBL format into a by year item.}

                              SetGlobalSBLSegmentFormats(AssessmentYearControlTable);

                              with AssessmentYearControlTable do
                                begin
                                  GlblCountyVeteransMax := FieldByName('VeteranCntyMax').AsFloat;
                                  GlblCountyCombatVeteransMax := FieldByName('CombatVetCntyMax').AsFloat;
                                  GlblCountyDisabledVeteransMax := FieldByName('DisabledVetCntyMax').AsFloat;
                                end;  {with AssessmentYearControlTable do}

                              AssessmentYearControlTable.Close;

                              MainFormTabSet.Tabs.Clear;
                              FormCaptions.Clear;

                                {Change the tax year label on the user info panel on
                                 the main form.}

                              SetTaxYearLabelForProcessingType(CurrentTaxYearLabel,
                                                               DetermineProcessingType(GlblTaxYearFlg));

                              MessageDlg('You are now processing in ' + YearStr + '.',
                                         mtInformation, [mbOK], 0);

                              GlblDialogBoxShowing := False;
                              CloseResult := idOK;
                              Close;

                            end;  {If CloseSuccessful}

                      end;  {If Proceed}

                end;  {If (UserFound and HaveAccess)}

            GlblDialogBoxShowing := False;

          end  {If (NewTaxYearFlg <> OrigTaxYearFlg)}
        else
          begin
              {There was no change, so just close the form and continue.}

            CloseResult := idOK;
            Close;
          end;

end;  {OKButtonClick}

{=================================================================}
Procedure TChooseTaxYearForm.EditHistoryYearEnter(Sender: TObject);

begin
  If (ChooseTaxYearRadioGroup.ItemIndex <> 2)
    then MessageDlg('Sorry. You can only select a year if you select ' + #13 +
                    'a History Tax Year. Please try again.', mtWarning,
                    [mbOK], 0);

end;  {EditHistoryYearEnter}

{=================================================================}
Procedure TChooseTaxYearForm.EditHistoryYearExit(Sender: TObject);

var
  Quit : Boolean;

begin
  {FXX01201998-13: Don't try to open any tables unless they filled in
                   a history tax year.}

  If ((ChooseTaxYearRadioGroup.ItemIndex = 2) and
      (Deblank(EditHistoryYear.Text) <> ''))
    then
      begin
        HaveAccess := False;
        OpenTableForProcessingType(ParcelTable, ParcelTableName, History, Quit);

        FindNearestOld(ParcelTable, ['TaxRollYr', 'Name1'],
                       [EditHistoryYear.Text, '']);

        If (ParcelTable.EOF or
            (Take(4, EditHistoryYear.Text) <>
             Take(4, ParcelTable.FieldByName('TaxRollYr').AsString)))
          then
            begin
              MessageDlg('Invalid Assessement History Year. ' + #13 +
                         'Please try again.', mtWarning,  [mbOK], 0);
              EditHistoryYear.SetFocus;

            end;  {If not HaveAccess}

        ParcelTable.Close;

      end;  {If ((ChooseTaxYearRadioGroup.ItemIndex = 2) and ...}

end;  {EditHistoryYearExit}

{=================================================================}
Procedure TChooseTaxYearForm.ChooseTaxYearRadioGroupClick(Sender: TObject);

begin
If ChooseTaxYearRadioGroup.ItemIndex = 2
    then
    begin
    EditHistoryYear.Visible := True;
    EditHistoryYear.SetFocus;

    end
    else EditHistoryYear.Visible := False;
end;

end.