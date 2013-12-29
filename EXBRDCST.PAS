unit EXbrdcst;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, DBCtrls, DBTables, DB, Buttons, Grids,
  Wwdbigrd, Wwdbgrid, ExtCtrls, Wwtable, Wwdatsrc, Menus, wwdblook,
  TabNotBk, Types, RPFiler, RPDefine, RPBase, RPCanvas, RPrinter, ComCtrls(*, Progress*);

type
  TExemptionBroadcastForm = class(TForm)
    EXCodeTable: TwwTable;
    Panel1: TPanel;
    Panel2: TPanel;
    ScrollBox1: TScrollBox;
    TitleLabel: TLabel;
    ParcelEXTable: TTable;
    Notebook: TTabbedNotebook;
    AssessmentYearRadioGroup: TRadioGroup;
    BroadcastMethodRadioGroup: TRadioGroup;
    PropertiesGroupBox: TGroupBox;
    Label1: TLabel;
    Label3: TLabel;
    Label6: TLabel;
    EXCodeLookupCombo: TwwDBLookupCombo;
    AmountEdit: TEdit;
    PercentageEdit: TEdit;
    SelectExistingEXGroupBox: TGroupBox;
    SelectParcelIDGroupBox: TGroupBox;
    EXCodeTable2: TwwTable;
    SelectedEXCodeLookupCombo: TwwDBLookupCombo;
    PropertyClassSelectionGroupBox: TGroupBox;
    PropertyClassTable: TwwTable;
    PropertyClassLookupCombo: TwwDBLookupCombo;
    Label8: TLabel;
    Label9: TLabel;
    StartParcelIDEdit: TEdit;
    EndParcelIDEdit: TEdit;
    SwisCodeSelectionGroupBox: TGroupBox;
    SwisCodeListBox: TListBox;
    ParcelTable: TTable;
    TrialRunCheckBox: TCheckBox;
    PrintDialog: TPrintDialog;
    ReportPrinter: TReportPrinter;
    ReportFiler: TReportFiler;
    SwisCodeTable: TTable;
    Label7: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    ParcelEXLookupTable: TTable;
    NotebookChangeTimer: TTimer;
    AssessmentTable: TTable;
    ExemptionTable: TTable;
    ExemptionCodeTable: TTable;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label22: TLabel;
    AuditEXChangeTable: TTable;
    OpenDialog: TOpenDialog;
    Label2: TLabel;
    ClassTable: TTable;
    Label4: TLabel;
    PrintNotBroadcastedCheckBox: TCheckBox;
    Panel3: TPanel;
    StartButton: TBitBtn;
    CloseButton: TBitBtn;
    tbRemovedExemptions: TTable;
    tbAudit: TTable;
    tbExemptionDenials: TTable;
    gbDenialProperties: TGroupBox;
    cbxCreateDenialRecord: TCheckBox;
    edDenialMessage: TEdit;
    Label5: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure StartButtonClick(Sender: TObject);
    procedure NotebookChange(Sender: TObject; NewTab: Integer;
      var AllowChange: Boolean);
    procedure PrintHeader(Sender: TObject);
    procedure ReportPrint(Sender: TObject);
    procedure AssessmentYearRadioGroupClick(Sender: TObject);
    procedure NotebookChangeTimerTimer(Sender: TObject);
    procedure DecimalFieldEditExit(Sender: TObject);
    procedure BroadcastMethodRadioGroupClick(Sender: TObject);
    procedure EXCodeLookupComboCloseUp(Sender: TObject; LookupTable,
      FillTable: TDataSet; modified: Boolean);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    UnitName : String;

    AssessmentYear,
    BroadcastMethod : Integer;
    TemplateEXCode : String;
    OwnerPercent, TemplatePercent : Real;
    TemplateAmount : Comp;
    SelectedSwisCodes : TStringList;
    SelectedPropertyClass : String;
    StartParcelID, EndParcelID, ImportFileName : String;
    BroadcastToParcelsWithEX : String;
    TrialRun, ReportCancelled : Boolean;
    CurrentAssessmentYear : String;
    LastPage0Control : TWinControl;
    PrintExemptionsNotBroadcasted, bCreateDenialRecord : Boolean;
    sDenialMessage : String;

    Procedure InitializeForm;  {Open the tables and setup.}

    Procedure SetReadOnlyFields;
    {Set the fields read only or required depending on the type of sd.}

    Function ValidSelections : Boolean;

    Procedure AddEXCode(    Sender : TObject;
                            ParcelTable,
                            ParcelEXTable,
                            ParcelEXLookupTable : TTable;
                            AssessmentYear : String;
                            SwisSBLKey : String;
                            EXExists : Boolean;
                        var NumParcelsPrinted : LongInt;
                        var FirstCodeAdded : Boolean;
                            EXExistsList,
                            STARExistsList,
                            CoopOrMobileHomeList : TStringList);
    {Add a exemption to this parcel and print it out.}

    Procedure AddEXCodesBySwisCode(    Sender : TObject;
                                       ParcelTable,
                                       ParcelEXTable,
                                       ParcelEXLookupTable : TTable;
                                       AssessmentYear : String;
                                   var NumParcelsPrinted : LongInt);
    {Add the template exemption to each parcel in the selected swis codes.}

    Procedure AddEXCodesByParcelID(    Sender : TObject;
                                       ParcelTable,
                                       ParcelEXTable,
                                       ParcelEXLookupTable : TTable;
                                       AssessmentYear : String;
                                   var NumParcelsPrinted : LongInt);
    {Add the template exemption to each parcel in the selected parcel ID
     range.}

    Procedure AddEXCodesByPropertyClass(    Sender : TObject;
                                            ParcelTable,
                                            ParcelEXTable,
                                            ParcelEXLookupTable : TTable;
                                            AssessmentYear : String;
                                        var NumParcelsPrinted : LongInt);
    {Add the template exemption to each parcel with the specified
     property class.}

    Procedure AddEXCodesByPreviousEX(    Sender : TObject;
                                         ParcelTable,
                                         ParcelEXTable,
                                         ParcelEXLookupTable : TTable;
                                         AssessmentYear : String;
                                     var NumParcelsPrinted : LongInt);
    {Add the template exemption to each parcel which already has the specified
     EX.}

    Procedure ReplaceExemption(    Sender : TObject;
                                   ParcelTable,
                                   ParcelEXTable,
                                   ParcelEXLookupTable : TTable;
                                   AssessmentYear : String;
                               var NumParcelsPrinted : LongInt);

    Procedure AddEXCodesByImportFile(    Sender : TObject;
                                         ParcelTable,
                                         ParcelEXTable,
                                         ParcelEXLookupTable : TTable;
                                         AssessmentYear : String;
                                     var NumParcelsPrinted : LongInt);
    {Add the exemptions in an extract file.}
    {CHG06171998-1: Add the option to import from a file.}

    Procedure AddEXCodesByParcelList(    Sender : TObject;
                                         ParcelTable,
                                         ParcelEXTable,
                                         ParcelEXLookupTable : TTable;
                                         AssessmentYear : String;
                                     var NumParcelsPrinted : LongInt);
    {Add the template exemption to each parcel in the selected parcel ID
     range.}

    Procedure DeleteOneEXCode(    Sender : TObject;
                                  ParcelTable,
                                  ParcelEXTable,
                                  ParcelEXLookupTable,
                                  tbExemptionDenials,
                                  tbExemptionRemovals : TTable;
                                  AssessmentYear : String;
                                  sExemptionCode : String;
                                  sDenialMessage : String;
                                  SwisSBLKey : String;
                                  bCreateDenialRecord : Boolean;
                                  bTrialRun : Boolean;
                              var bFirstCodeDeleted : Boolean;
                              var NumParcelsPrinted : Integer);

    Procedure DeleteEXCodeByParcelList(    Sender : TObject;
                                           ParcelTable,
                                           ParcelEXTable,
                                           ParcelEXLookupTable,
                                           tbExemptionDenials,
                                           tbExemptionRemovals : TTable;
                                           AssessmentYear : String;
                                           sExemptionCode : String;
                                           sDenialMessage : String;
                                           bCreateDenialRecord : Boolean;
                                           bTrialRun : Boolean;
                                       var NumParcelsPrinted : LongInt);

    Procedure DeleteEXCode(    Sender : TObject;
                               ParcelTable,
                               ParcelEXTable,
                               ParcelEXLookupTable : TTable;
                               AssessmentYear : String;
                           var NumParcelsPrinted : LongInt);

    Procedure PrintExistingEXs(Sender : TObject;
                               EXExistsList,
                               STARExistsList,
                               CoopOrMobileHomeList : TStringList);

    {If any parcels already had this EX, then print it out.}

  end;

implementation

uses GlblVars, WinUtils, Utilitys, UTILEXSD, GlblCnst, PASUtils,
     UTILRTOT, RTCalcul,
     PRCLLIST,  {Parcel list}
     Prog, DataAccessUnit,
     Preview, PASTypes;

const
    {Assessment Years}
  ayThisYear = 0;
  ayNextYear = 1;
  ayBothYears = 2;

    {Broadcast methods}

  bmSwisCode = 0;
  bmParcelIDRange = 1;
  bmPropertyClass = 2;
  bmParcelsWithCertainEX = 3;
  bmImportFile = 4;
  bmParcelList = 5;
  bmDeleteEX = 6;
  bmReplaceExemption = 7;
  bmDeleteExemptionByParcelList = 8;

  NumColumns = 3;

{$R *.DFM}

{========================================================}
Procedure TExemptionBroadcastForm.FormActivate(Sender: TObject);

begin
  SetFormStateMaximized(Self);
end;

{========================================================}
Procedure TExemptionBroadcastForm.InitializeForm;

var
  Done, FirstTimeThrough : Boolean;

begin
  UnitName := 'EXBRDCST';  {mmm}

  OpenTablesForForm(Self, GlblProcessingType);

    {Now fill the swis, school, and neighborhood codes.}

  SwisCodeTable.First;

  FirstTimeThrough := True;
  Done := False;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else SwisCodeTable.Next;

    If SwisCodeTable.EOF
       then Done := True;

    If not Done
      then
        with SwisCodeTable do
          SwisCodeListBox.Items.Add(FieldByName('SwisCode').Text + ' - ' +
                                    Take(15, FieldByName('MunicipalityName').Text));

  until Done;

end;  {InitializeForm}

{===================================================================}
Procedure TExemptionBroadcastForm.FormKeyPress(    Sender: TObject;
                                     var Key: Char);

begin
  If (Key = #13)
    then
      begin
        Key := #0;
        Perform(WM_NEXTDLGCTL, 0, 0);
      end;

end;  {FormKeyPress}

{==================================================================}
Procedure TExemptionBroadcastForm.AssessmentYearRadioGroupClick(Sender: TObject);

{Switch the lookup tables based on which year they want. Note that for
 BothYears, we will use ThisYear lookup tables.}
{FXX10061999-5: Need to reopen all tables for the correct year.}

var
  Quit : Boolean;

begin
  case AssessmentYearRadioGroup.ItemIndex of
    ayThisYear,
    ayBothYears :
      begin
        OpenTableForProcessingType(EXCodeTable, ExemptionCodesTableName,
                                   ThisYear, Quit);

        OpenTableForProcessingType(EXCodeTable2, ExemptionCodesTableName,
                                   ThisYear, Quit);

      end;  {ayThisYear, ayBothYears}

    ayNextYear :
      begin
        OpenTableForProcessingType(EXCodeTable, ExemptionCodesTableName,
                                   NextYear, Quit);

        OpenTableForProcessingType(EXCodeTable2, ExemptionCodesTableName,
                                   NextYear, Quit);

      end;  {ayNextYear}

  end;  {case AssessmentYearRadioGroup.ItemIndex of}

end;  {AssessmentYearRadioGroupClick}

{==================================================================}
Procedure TExemptionBroadcastForm.BroadcastMethodRadioGroupClick(Sender: TObject);

begin
  If _Compare(BroadcastMethodRadioGroup.ItemIndex, [bmDeleteEX, bmDeleteExemptionByParcelList], coEqual)
    then PropertiesGroupBox.Caption := ' Select Exemption Code to Delete'
    else PropertiesGroupBox.Caption := ' Select Properties of Broadcasted Exemption: ';

  gbDenialProperties.Visible := _Compare(BroadcastMethodRadioGroup.ItemIndex, bmDeleteExemptionByParcelList, coEqual);
  
end;  {BroadcastMethodRadioGroupClick}

{==================================================================}
Procedure TExemptionBroadcastForm.DecimalFieldEditExit(Sender: TObject);

{Make sure that they entered a number in the amount, unit, secondary unit
 or percentage field.}

var
  EditOK : Boolean;
  TempNum : Double;

begin
  EditOK := True;
  TempNum := 0;

  with Sender as TEdit do
    begin
      try
        TempNum := StrToFloat(Text);
      except
        If (Deblank(Text) <> '')
          then
            begin
              MessageDlg('Please enter a number.', mtError, [mbOK], 0);
              SetFocus;
              EditOK := False;
            end;

      end;  {try}

        {Reformat with two decimals.}

      If EditOK
        then
          If (Name = 'PercentageEdit')
            then Text := FormatFloat(NoDecimalDisplay_BlankZero, TempNum)
            else Text := FormatFloat(DecimalDisplay_BlankZero, TempNum);

    end;  {with Sender as TEdit do}

end;  {DecimalFieldEditExit}

{==================================================================}
Procedure TExemptionBroadcastForm.NotebookChange(    Sender: TObject;
                                                    NewTab: Integer;
                                                var AllowChange: Boolean);

{Don't allow change if range type not selected. If selected, setup
 range page.}

begin
  If (NewTab = 1)
    then
      begin
        If (BroadcastMethodRadioGroup.ItemIndex = -1)
          then
            begin
              MessageDlg('Please select the broadcast method before selecting the range.',
                         mtError, [mbOK], 0);
              AllowChange := False;
            end
          else
            begin
              SwisCodeSelectionGroupBox.Visible := False;
              PropertyClassSelectionGroupBox.Visible := False;
              SelectExistingEXGroupBox.Visible := False;
              SelectParcelIDGroupBox.Visible := False;

              case BroadcastMethodRadioGroup.ItemIndex of
                bmSwisCode : SwisCodeSelectionGroupBox.Visible := True;
                bmParcelIDRange : SelectParcelIDGroupBox.Visible := True;
                bmPropertyClass : PropertyClassSelectionGroupBox.Visible := True;
                bmParcelsWithCertainEX,
                bmReplaceExemption : SelectExistingEXGroupBox.Visible := True;
              end;  {case BroadcastMethodRadioGroup.ItemIndex of}

            end;  {else of If (BroadcastMethodRadioGroup.ItemIndex = -1)}

        LastPage0Control := Screen.ActiveControl

      end;  {If (NewTab = 1)}

  NotebookChangeTimer.Enabled := True;

end;  {TabbedNotebookChange}

{==============================================================}
Procedure TExemptionBroadcastForm.NotebookChangeTimerTimer(Sender: TObject);

{FXX04281998-5: Set focus to the relevant field on the page.}

begin
  NotebookChangeTimer.Enabled := False;

  case Notebook.PageIndex of
    0 : LastPage0Control.SetFocus;
    1 : case BroadcastMethodRadioGroup.ItemIndex of
          bmSwisCode : SwisCodeListBox.SetFocus;
          bmParcelIDRange : StartParcelIDEdit.SetFocus;
          bmPropertyClass : PropertyClassLookupCombo.SetFocus;
          bmParcelsWithCertainEX,
          bmReplaceExemption : SelectedEXCodeLookupCombo.SetFocus;

        end;  {case BroadcastMethodRadioGroup.ItemIndex of}

  end;  {case Notebook.PageIndex of}

end;  {NotebookChangeTimerTimer}

{==============================================================}
Procedure SetEditReadOnlyStatus(Sender : TObject);

begin
  If (Sender is TwwDBLookupCombo)
    then
      with Sender as TwwDBLookupCombo do
        If ReadOnly
          then
            begin
              Color := clBtnFace;
              Text := '';
            end
          else Color := clWindow;

  If (Sender is TEdit)
    then
      with Sender as TEdit do
        If ReadOnly
          then
            begin
              Color := clBtnFace;
              Text := '';
            end
          else Color := clWindow;

end;  {SetEditReadOnlyStatus}

{==============================================================}
Procedure TExemptionBroadcastForm.SetReadOnlyFields;

{Set the fields read only or required depending on the type of EX.}

begin
    {If this is a percentage based exemption, allow them to edit the percentage.
     If this is an amount based exemption, allow them to enter the amount.
     Otherwise, just the code.}

  AmountEdit.ReadOnly := True;
  PercentageEdit.ReadOnly := True;

  If ((EXCodeTable.FieldByName('CalcMethod').Text = EXCMethO) and
      (Take(4, EXCodeLookupCombo.Text) = '4180'))  {% for senior only}
    then PercentageEdit.ReadOnly := False;

  If (EXCodeTable.FieldByName('CalcMethod').Text = EXCMethV)
    then AmountEdit.ReadOnly := False;

    {Now based on the stuff above, set the edit boxes to readonly or not.}

  SetEditReadOnlyStatus(AmountEdit);
  SetEditReadOnlyStatus(PercentageEdit);

end;  {SetReadOnlyFields}

{==============================================================}
Procedure TExemptionBroadcastForm.EXCodeLookupComboCloseUp(Sender: TObject;
                                                           LookupTable,
                                                           FillTable: TDataSet;
                                                           modified: Boolean);

{FXX04281998-8: Enforce valid entry of EX amounts based on extensions.}

begin
  If (BroadcastMethodRadioGroup.ItemIndex <> bmDeleteEX)
    then
      begin
        SetReadOnlyFields;

          {FXX10061999-1: If they want a veterans exemption, set the default %.}

        If (Take(4, EXCodeTable.FieldByName('EXCode').Text) = '4112')
          then
            begin
              PercentageEdit.ReadOnly := False;
              PercentageEdit.Text := SwisCodeTable.FieldByName('VeteranCalcPercent').Text;
              PercentageEdit.ReadOnly := True;
            end;

        If (Take(4, EXCodeTable.FieldByName('EXCode').Text) = '4113')
          then
            begin
              PercentageEdit.ReadOnly := False;
              PercentageEdit.Text := SwisCodeTable.FieldByName('CombatVetCalcPercent').Text;
              PercentageEdit.ReadOnly := True;
            end;

      end;  {If (BroadcastMethodRadioGroup.ItemIndex <> bmDeleteEX)}

end;  {EXCodeLookupComboCloseUp}

{==============================================================}
Function TExemptionBroadcastForm.ValidSelections : Boolean;

{Have they entered everything they need for this EX broadcast?}

var
  I, NumSelected : Integer;

begin
  Result := True;

    {CHG06171998-1: Add feature to import by file.}

  If (BroadcastMethodRadioGroup.ItemIndex <> bmImportFile)
    then
      begin
        If (Deblank(EXCodeLookupCombo.Text) = '')
          then
            begin
              MessageDlg('Please enter the exemption code that you wish to broadcast.',
                         mtError, [mbOK], 0);

                {Set focus back to the EX combo box, changing pages if necessary.}

              If (Notebook.PageIndex = 0)
                then EXCodeLookupCombo.SetFocus
                else
                  begin
                    LastPage0Control := EXCodeLookupCombo;
                    Notebook.PageIndex := 0;
                  end;

              Result := False;

            end;  {If (Deblank(EXCodeLookupCombo.Text) = '')}

          {Make sure they selected an assessment year.}

        If (Result and
            (AssessmentYearRadioGroup.ItemIndex = -1))
          then
            begin
              MessageDlg('Please select the assessment year(s).',
                         mtError, [mbOK], 0);

                {Set focus back to the assessment radio box, changing pages if necessary.}

              If (Notebook.PageIndex = 0)
                then AssessmentYearRadioGroup.SetFocus
                else
                  begin
                    LastPage0Control := AssessmentYearRadioGroup;
                    Notebook.PageIndex := 0;
                  end;

              Result := False;

            end;  {If (Result and ...}

          {Make sure they selected a range.}

        If Result
          then
            case BroadcastMethodRadioGroup.ItemIndex of
              bmSwisCode :
                begin
                  NumSelected := 0;

                  For I := 0 to (SwisCodeListBox.Items.Count - 1) do
                    If SwisCodeListBox.Selected[I]
                      then NumSelected := NumSelected + 1;

                  If (NumSelected = 0)
                    then
                      begin
                        MessageDlg('Please select the swis code(s) to broadcast to.',
                                   mtError, [mbOK], 0);

                          {Set focus on the swis list box, changing notebook pages
                           if necessary.}

                        If (Notebook.PageIndex = 0)
                          then Notebook.PageIndex := 1
                          else SwisCodeListBox.SetFocus;

                        Result := False;

                      end;  {If (NumSelected = 0)}

                end;  {bmSwisCode}

              bmParcelIDRange :
                begin
                  If ((Deblank(StartParcelIDEdit.Text) = '') or
                      (Deblank(EndParcelIDEdit.Text) = ''))
                    then
                      begin
                        MessageDlg('Please select the parcel ID range to broadcast to.',
                                   mtError, [mbOK], 0);

                          {Set focus on the start parcel ID box, changing notebook pages
                           if necessary.}

                        If (Notebook.PageIndex = 0)
                          then Notebook.PageIndex := 1
                          else StartParcelIDEdit.SetFocus;

                        Result := False;

                      end;  {If ((Deblank(StartParcelIDEdit.Text) = '') or ...}

                end;  {bmParcelIDRange}

              bmPropertyClass :
                begin
                  If (Deblank(PropertyClassLookupCombo.Text) = '')
                    then
                      begin
                        MessageDlg('Please select the property class to broadcast to.',
                                   mtError, [mbOK], 0);

                          {Set focus on the property class combo, changing notebook pages
                           if necessary.}

                        If (Notebook.PageIndex = 0)
                          then Notebook.PageIndex := 1
                          else PropertyClassLookupCombo.SetFocus;

                        Result := False;

                      end;  {If (Deblank(PropertyClassLookupCombo.Text) = '')}

                end;  {bmPropertyClass}

              bmParcelsWithCertainEX :
                begin
                  If (Deblank(SelectedEXCodeLookupCombo.Text) = '')
                    then
                      begin
                        MessageDlg('Please select the existing exemption code to broadcast to.',
                                   mtError, [mbOK], 0);

                          {Set focus on the existing EX combo, changing notebook pages
                           if necessary.}

                        If (Notebook.PageIndex = 0)
                          then Notebook.PageIndex := 1
                          else SelectedEXCodeLookupCombo.SetFocus;

                        Result := False;

                      end;  {If (Deblank(SelectedEXCodeLookupCombo.Text) = '')}

                end;  {bmParcelsWithCertainEX}

              bmReplaceExemption:
                begin
                  If _Compare(SelectedEXCodeLookupCombo.Text, coBlank)
                    then
                      begin
                        MessageDlg('Please select the existing exemption code to replace.',
                                   mtError, [mbOK], 0);

                          {Set focus on the existing EX combo, changing notebook pages
                           if necessary.}

                        If (Notebook.PageIndex = 0)
                          then Notebook.PageIndex := 1
                          else SelectedEXCodeLookupCombo.SetFocus;

                        Result := False;

                      end;  {If (Deblank(SelectedEXCodeLookupCombo.Text) = '')}

                end;  {bmReplaceExemption}

            end;  {case BroadcastMethodRadioGroup.ItemIndex of}

      end;  {If (BroadcastMethodRadioGroup.ItemIndex <> bmImportFile)}

end;  {ValidSelections}

{==============================================================}
Procedure TExemptionBroadcastForm.StartButtonClick(Sender: TObject);

var
  I : Integer;
  TempStr, NewFileName : String;
  Quit, Cancelled : Boolean;

begin
  bCreateDenialRecord := cbxCreateDenialRecord.Checked;
  sDenialMessage := edDenialMessage.Text;
  BroadcastMethod := BroadcastMethodRadioGroup.ItemIndex;
  ProgressDialog.UserLabelCaption := '';

  If (ValidSelections and
      ((BroadcastMethod <> bmDeleteEX) or
       ((BroadcastMethod = bmDeleteEX) and
        (MessageDlg('Are you sure you want to delete special exemption ' +
                    EXCodeLookupCombo.Text + '?', mtConfirmation, [mbYes, mbNo], 0) = idYes))))
    then
      begin
        If (BroadcastMethod = bmDeleteEX)
          then TempStr := 'from which the exemption is deleted.'
          else TempStr := 'that receive the exemption.';

(*        MessageDlg('The exemption broadcast prints a list of all' + #13 +
                   'parcels ' + TempStr + #13 +
                   'Please select where the print output should go in the' + #13 +
                   'following Print dialog box which will appear after you press OK.',
                   mtInformation, [mbOK], 0); *)

          {CHG10121998-1: Add user options for default destination and show vet max msg.}

        SetPrintToScreenDefault(PrintDialog);

        If PrintDialog.Execute
          then
            begin
                {CHG10131998-1: Set the printer settings based on what printer they selected
                                only - they no longer need to worry about paper or landscape
                                mode.}

              AssignPrinterSettings(PrintDialog, ReportPrinter, ReportFiler, [ptBoth], False, Quit);

              AssessmentYear := AssessmentYearRadioGroup.ItemIndex;

                {Template information}

              TemplateEXCode := EXCodeLookupCombo.Text;

              try
                TemplateAmount := StrToFloat(AmountEdit.Text);
              except
                TemplateAmount := 0;
              end;

              try
                TemplatePercent := StrToFloat(PercentageEdit.Text);
              except
                TemplatePercent := 0;
              end;

                 {Range information}

              SelectedSwisCodes := TStringList.Create;

              For I := 0 to (SwisCodeListBox.Items.Count - 1) do
                If SwisCodeListBox.Selected[I]
                  then SelectedSwisCodes.Add(Take(6, SwisCodeListBox.Items[I]));

              SelectedPropertyClass := PropertyClassLookupCombo.Text;
              StartParcelID := StartParcelIDEdit.Text;
              EndParcelID := EndParcelIDEdit.Text;
              BroadcastToParcelsWithEX := SelectedEXCodeLookupCombo.Text;

              TrialRun := TrialRunCheckBox.Checked;
              ReportCancelled := False;

                {Now print the report and do the EX broadcast.}

              GlblPreviewPrint := False;

                {FXX04281998-7: Need to set the assessment year before printing
                                so that it shows on the first page.}

              If (AssessmentYear in [ayThisYear, ayBothYears])
                then CurrentAssessmentYear := GlblThisYear
                else CurrentAssessmentYear := GlblNextYear;

              PrintExemptionsNotBroadcasted  := PrintNotBroadcastedCheckBox.Checked;

                {CHG06171998-1: Option to load exemptions from file.}

              Cancelled := False;

              If (BroadcastMethod = bmImportFile)
                then
                  If OpenDialog.Execute
                    then ImportFileName := OpenDialog.FileName
                    else Cancelled := True;

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

                {If they want to see it on the screen, start the preview.}

              If not Cancelled
                then
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
                          PreviewForm.ShowModal;
                        finally
                          PreviewForm.Free;
                        end

                      end
                    else ReportPrinter.Execute;

              SelectedSwisCodes.Free;

            end;  {If PrintDialog.Execute}

      end;  {If ValidSelections}

end;  {StartButtonClick}

{===================================================================}
Procedure TExemptionBroadcastForm.PrintHeader(Sender: TObject);

{FXX05041998-1: Print selected information in header.}

var
  TempStr : String;
  I : Integer;

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
      PrintCenter('Exemption Broadcast', (PageWidth / 2));
      Bold := False;
      CRLF;
      CRLF;

        {Selected options}

      ClearTabs;
      SetTab(0.3, pjLeft, 7.5, 0, BOXLINENONE, 0);   {hdr}

      SetFont('Times New Roman',10);
      Println(#9 + 'Assessment Year: ' + CurrentAssessmentYear);

      case BroadcastMethod of
        bmImportFile : Println(#9 + 'Import from file: ' + ImportFileName);
        bmDeleteEX,
        bmDeleteExemptionByParcelList : Println(#9 + 'Deleted exemption: ' + TemplateEXCode);
        else Println(#9 + 'Broadcasted EX -> Code: ' + TemplateEXCode +
                     '  Amt: ' + FormatFloat(DecimalDisplay, TemplateAmount) +
                     '  Percent: ' + FormatFloat(DecimalDisplay, TemplatePercent));

      end;  {case BroadcastMethod of}

      case BroadcastMethod of
        bmSwisCode :
          begin
            TempStr := '';
            For I := 0 to (SelectedSwisCodes.Count - 1) do
              TempStr := TempStr + SelectedSwisCodes[I] + ' ';

            Println(#9 + 'Broadcast To: Parcel in swis code(s): ' + TempStr);

          end;  {bmSwisCode}

        bmParcelIDRange : Println(#9 + 'Broadcast To: Start SBL: ' + StartParcelID +
                                       '   End SBL: ' + EndParcelID);
        bmPropertyClass : Println(#9 + 'Broadcast To: Property Class ' +
                                   SelectedPropertyClass);
        bmParcelsWithCertainEX : Println(#9 + 'Broadcast To: Parcels with EX code ' +
                                         BroadcastToParcelsWithEX);
        bmReplaceExemption : Println(#9 + 'Replace exemption ' + BroadcastToParcelsWithEX +
                                          ' with exemption ' + TemplateEXCode);

     end;  {case BoradcastMethod of}

     Println('');

     Underline := False;
     ClearTabs;
     SetTab(0.3, pjLeft, 2.3, 0, BOXLINENONE, 0);   {SBL 1}
     SetTab(2.7, pjLeft, 2.3, 0, BOXLINENONE, 0);   {SBL 2}
     SetTab(5.1, pjLeft, 2.3, 0, BOXLINENONE, 0);   {SBL 3}

    end;  {with Sender as TBaseReport do}

end;  {PrintHeader}

{===================================================================}
Procedure TExemptionBroadcastForm.PrintExistingEXs(Sender : TObject;
                                                   EXExistsList,
                                                   STARExistsList,
                                                   CoopOrMobileHomeList : TStringList);

{If any parcels already had this EX, then print it out.}

var
  I : Integer;

begin
  If ((EXExistsList.Count > 0) and
      PrintExemptionsNotBroadcasted)
    then
      with Sender as TBaseReport do
        begin
          If (LinesLeft < 10)
            then NewPage;

          Println('');
          Bold := True;
          Underline := True;
          Println('The following parcels already had the broadcasted exemption:');
          Bold := False;
          Underline := False;

          For I := 0 to (EXExistsList.Count - 1) do
            begin
              If (LinesLeft < 5)
                then NewPage;

                {We will print probably 3 columns across, so if this is a new
                 line, issue a carriage return for the last line.}

              If (((I + 1) MOD NumColumns) = 1)
                then Println('');

              Print(#9 + ConvertSwisSBLToDashDot(EXExistsList[I]));

            end;  {with Sender as TBaseReport do}

          Println('');

        end;  {with Sender as TBaseReport do}

    {Print any STAR duplicates.}

  If (STARExistsList.Count > 0)
    then
      with Sender as TBaseReport do
        begin
          If (LinesLeft < 10)
            then NewPage;

          Bold := True;

          Println('');
          Println('The exemption code ' + TemplateEXCode +
                  ' was not added because');

          Underline := True;

          If (TemplateEXCode = BasicSTARExemptionCode)
            then Println('the following parcels already had the enhanced STAR exemption:')
            else Println('the following parcels already had the basic STAR exemption:');

          Bold := False;
          Underline := False;

          For I := 0 to (STARExistsList.Count - 1) do
            begin
              If (LinesLeft < 5)
                then NewPage;

                {We will print probably 3 columns across, so if this is a new
                 line, issue a carriage return for the last line.}

              If (((I + 1) MOD NumColumns) = 1)
                then Println('');

              Print(#9 + ConvertSwisSBLToDashDot(STARExistsList[I]));

            end;  {with Sender as TBaseReport do}

            {FXX06171999-1: Need to carriage return to print out last line.}

          Println('');

        end;  {with Sender as TBaseReport do}

    {FXX10061999-3: If the broadcast is to a coop or mobile home and
                    the exemption is one that is a flat rate for these classes,
                    then report it.}

    {Print any STAR duplicates.}

  If (CoopOrMobileHomeList.Count > 0)
    then
      with Sender as TBaseReport do
        begin
          If (LinesLeft < 10)
            then NewPage;

          Bold := True;

          Println('');

          Println('The following parcels received the exemption but the exemption was not');
          Underline := True;
          Println('calculated because the parcel is a coop or mobile home.  Please review:');

          Bold := False;
          Underline := False;

          For I := 0 to (CoopOrMobileHomeList.Count - 1) do
            begin
              If (LinesLeft < 5)
                then NewPage;

                {We will print probably 3 columns across, so if this is a new
                 line, issue a carriage return for the last line.}

              If (((I + 1) MOD NumColumns) = 1)
                then Println('');

              Print(#9 + ConvertSwisSBLToDashDot(CoopOrMobileHomeList[I]));

            end;  {with Sender as TBaseReport do}

            {FXX06171999-1: Need to carriage return to print out last line.}

          Println('');

        end;  {with Sender as TBaseReport do}

end;  {PrintExistingEXs}

{===================================================================}
Procedure PrintRejects(Sender : TObject;
                       RejectList : TStringList);

{If any parcels were not found in the import, print them out.}

var
  I : Integer;

begin
  If (RejectList.Count > 0)
    then
      with Sender as TBaseReport do
        begin
          If (LinesLeft < 10)
            then NewPage;

          Println('');
          Bold := True;
          Underline := True;
          Println('The following parcels in the import were not found:');
          Bold := False;
          Underline := False;

          For I := 0 to (RejectList.Count - 1) do
            begin
              If (LinesLeft < 5)
                then NewPage;

                {We will print probably 3 columns across, so if this is a new
                 line, issue a carriage return for the last line.}

              If (((I + 1) MOD NumColumns) = 1)
                then Println('');

              Print(#9 + ConvertSwisSBLToDashDot(RejectList[I]));

            end;  {with Sender as TBaseReport do}

        end;  {with Sender as TBaseReport do}

end;  {PrintRejects}

{===================================================================}
Procedure TExemptionBroadcastForm.AddEXCode(    Sender : TObject;
                                                ParcelTable,
                                                ParcelEXTable,
                                                ParcelEXLookupTable : TTable;
                                                AssessmentYear : String;
                                                SwisSBLKey : String;
                                                EXExists : Boolean;
                                            var NumParcelsPrinted : LongInt;
                                            var FirstCodeAdded : Boolean;
                                                EXExistsList,
                                                STARExistsList,
                                                CoopOrMobileHomeList : TStringList);

{Add a exemption to this parcel and print it out.}
{FXX04281998-3: Pass in the SwisSBL since not always driven on the parcel table.}

var
  OppositeSTARExists : Boolean;
  OrigExemptionCodes,
  OrigResidentialTypes,
  OrigExemptionHomesteadCodes,
  OrigCountyExemptionAmounts,
  OrigTownExemptionAmounts,
  OrigSchoolExemptionAmounts,
  OrigVillageExemptionAmounts,
  NewExemptionCodes,
  NewResidentialTypes,
  NewExemptionHomesteadCodes,
  NewCountyExemptionAmounts,
  NewTownExemptionAmounts,
  NewSchoolExemptionAmounts,
  NewVillageExemptionAmounts : TStringList;
  OrigBasicSTARAmount, OrigEnhancedSTARAmount,
  NewBasicSTARAmount, NewEnhancedSTARAmount : Comp;
  AuditEXList, SDAmounts : TList;
  Found : Boolean;
  TempStr : String;

begin
  OppositeSTARExists := False;

  TempStr := ConvertSwisSBLToDashDot(SwisSBLKey);

    {Special rules for STAR exemptions.  Do not allow enhanced
     STAR on STAR with basic and vice-versa.}

  If ((TemplateEXCode = BasicSTARExemptionCode) or
      (TemplateEXCode = EnhancedSTARExemptionCode))
    then
      begin
        If ((TemplateEXCode = BasicSTARExemptionCode) and
            FindKeyOld(ParcelEXLookupTable,
                       ['TaxRollYr', 'SwisSBLKey', 'ExemptionCode'],
                       [AssessmentYear, SwisSBLKey,
                        EnhancedSTARExemptionCode]))
          then
            begin
              OppositeSTARExists := True;
              STARExistsList.Add(SwisSBLKey);
            end;

        Found := FindKeyOld(ParcelEXLookupTable,
                            ['TaxRollYr', 'SwisSBLKey', 'ExemptionCode'],
                            [AssessmentYear, SwisSBLKey,
                             BasicSTARExemptionCode]);

        If ((TemplateEXCode = EnhancedSTARExemptionCode) and
            Found)
          then
            begin
              OppositeSTARExists := True;
              STARExistsList.Add(SwisSBLKey);
            end;

      end;  {If ((TemplateExemptionCode = BasicSTARExemptionCode) or ...}

    {FXX10061999-3: If the broadcast is to a coop or mobile home and
                    the exemption is one that is a flat rate for these classes,
                    then report it.}
    {CHG08132008-1(2.15.1.5): Add 4191x as a low income disabled exemption.}

  If (((TemplateEXCode = BasicSTARExemptionCode) or
       (TemplateEXCode = EnhancedSTARExemptionCode) or
       (Take(4, TemplateEXCode) = '4112') or
       (Take(4, TemplateEXCode) = '4113') or
       (Take(4, TemplateEXCode) = '4114') or
       (Take(4, TemplateEXCode) = '4180') or
       (Take(4, TemplateEXCode) = '4190') or
       ExemptionIsLowIncomeDisabled(TemplateEXCode)) and
(*       (Take(4, TemplateEXCode) = '4193')) and *)
      PropertyIsCoopOrMobileHomePark(ParcelTable))
    then CoopOrMobileHomeList.Add(SwisSBLKey);

  TempStr := ParcelTable.FieldByName('PropertyClassCode').Text;
  TempStr := ParcelTable.FieldByName('OwnershipCode').Text;

  If EXExists
    then EXExistsList.Add(SwisSBLKey);

  If not (EXExists or OppositeSTARExists)
    then
      begin
        If not TrialRun
          then
            begin
              AuditEXList := TList.Create;
              GetAuditEXList(SwisSBLKey, AssessmentYear, ParcelEXLookupTable, AuditEXList);
              InsertAuditEXChanges(SwisSBLKey, AssessmentYear, AuditEXList,
                                   AuditEXChangeTable, 'B');

                {FXX04281998-6: Add roll total adjustments and audit trail
                                entries.}
                {Note that for the parcel EX and EX code tables, we use yet another
                 copy to make sure that we don't lose position in the tables we
                 are using.}

              OrigExemptionCodes := TStringList.Create;
              OrigResidentialTypes := TStringList.Create;
              OrigExemptionHomesteadCodes := TStringList.Create;
              OrigCountyExemptionAmounts := TStringList.Create;
              OrigTownExemptionAmounts := TStringList.Create;
              OrigSchoolExemptionAmounts := TStringList.Create;
              OrigVillageExemptionAmounts := TStringList.Create;

              NewExemptionCodes := TStringList.Create;
              NewResidentialTypes := TStringList.Create;
              NewExemptionHomesteadCodes := TStringList.Create;
              NewCountyExemptionAmounts := TStringList.Create;
              NewTownExemptionAmounts := TStringList.Create;
              NewSchoolExemptionAmounts := TStringList.Create;
              NewVillageExemptionAmounts := TStringList.Create;
              SDAmounts := TList.Create;

              FindKeyOld(AssessmentTable,
                         ['TaxRollYr', 'SwisSBLKey'],
                         [AssessmentYear, SwisSBLKey]);

              TotalExemptionsForParcel(AssessmentYear, SwisSBLKey,
                                       ParcelExTable,
                                       EXCodeTable,
                                       ParcelTable.FieldByName('HomesteadCode').Text,
                                       'A',
                                       OrigExemptionCodes,
                                       OrigExemptionHomesteadCodes,
                                       OrigResidentialTypes,
                                       OrigCountyExemptionAmounts,
                                       OrigTownExemptionAmounts,
                                       OrigSchoolExemptionAmounts,
                                       OrigVillageExemptionAmounts,
                                       OrigBasicSTARAmount,
                                       OrigEnhancedSTARAmount);

              with ParcelEXTable do
                begin
                  Insert;

                  FieldByName('TaxRollYr').Text := AssessmentYear;
                  FieldByName('SwisSBLKey').Text := SwisSBLKey;
                  FieldByName('ExemptionCode').Text := TemplateEXCode;
                  FieldByName('Percent').AsFloat := TemplatePercent;
                  FieldByName('Amount').AsFloat := TemplateAmount;
                  FieldByName('InitialDate').AsDateTime := Date;
                  FieldByName('ExemptionApproved').AsBoolean := True;

                    {FXX11221999-3: Make sure to carry owner percent forward.}

                  FieldByName('OwnerPercent').AsFloat := OwnerPercent;

                  try
                    Post;
                  except
                    SystemSupport(001, ParcelEXTable, 'Error posting EX record: ' +
                                  ConvertSwisSBLToDashDot(SwisSBLKey) + '.',
                                  UnitName, GlblErrorDlgBox);
                  end;

                end;  {with ParcelEXTable}

                {Since there has been a change to one exemption, we will
                 have to recalculate all exemptions, thus we will have to
                 recalculate the swis and school totals since these might
                 be affected, too.}

              RecalculateExemptionsForParcel(EXCodeTable,
                                             ParcelEXTable,
                                             AssessmentTable,
                                             ClassTable,
                                             SwisCodeTable,
                                             ParcelTable,
                                             AssessmentYear, SwisSBLKey, nil,
                                             0, 0, False);

              TotalExemptionsForParcel(AssessmentYear, SwisSBLKey,
                                       ParcelExTable,
                                       EXCodeTable,
                                       ParcelTable.FieldByName('HomesteadCode').Text,
                                       'A',
                                       NewExemptionCodes,
                                       NewExemptionHomesteadCodes,
                                       NewResidentialTypes,
                                       NewCountyExemptionAmounts,
                                       NewTownExemptionAmounts,
                                       NewSchoolExemptionAmounts,
                                       NewVillageExemptionAmounts,
                                       NewBasicSTARAmount,
                                       NewEnhancedSTARAmount);

                 {This is the after picture.}

               ClearTList(AuditEXList, SizeOf(AuditEXRecord));
               GetAuditEXList(SwisSBLKey, AssessmentYear,
                              ParcelEXLookupTable, AuditEXList);
               InsertAuditEXChanges(SwisSBLKey, AssessmentYear, AuditEXList,
                                    AuditEXChangeTable, 'A');

                {Delete all the old roll totals for this parcel.
                 We are only going to adjust the exemption roll
                 totals since these are the only totals affected by
                 an EX change.}

              AdjustRollTotalsForParcel(AssessmentYear,
                                        ParcelTable.FieldByName('SwisCode').Text,
                                        ParcelTable.FieldByName('SchoolCode').Text,
                                        ParcelTable.FieldByName('HomesteadCode').Text,
                                        ParcelTable.FieldByName('RollSection').Text,
                                        0, 0, 0, 0,
                                        OrigExemptionCodes,
                                        OrigExemptionHomesteadCodes,
                                        OrigCountyExemptionAmounts,
                                        OrigTownExemptionAmounts,
                                        OrigSchoolExemptionAmounts,
                                        OrigVillageExemptionAmounts,
                                        ParcelTable,
                                        OrigBasicSTARAmount,
                                        OrigEnhancedSTARAmount,
                                        SDAmounts,
                                        ['E', 'S', 'C', 'D'],  {EX}
                                        'D');  {Delete the totals.}

                {Add the new roll totals for this parcel.}

              AdjustRollTotalsForParcel(AssessmentYear,
                                        ParcelTable.FieldByName('SwisCode').Text,
                                        ParcelTable.FieldByName('SchoolCode').Text,
                                        ParcelTable.FieldByName('HomesteadCode').Text,
                                        ParcelTable.FieldByName('RollSection').Text,
                                        0, 0, 0, 0,
                                        NewExemptionCodes,
                                        NewExemptionHomesteadCodes,
                                        NewCountyExemptionAmounts,
                                        NewTownExemptionAmounts,
                                        NewSchoolExemptionAmounts,
                                        NewVillageExemptionAmounts,
                                        ParcelTable,
                                        NewBasicSTARAmount,
                                        NewEnhancedSTARAmount,
                                        SDAmounts,
                                        ['E', 'S', 'C', 'D'],  {EX}
                                        'A');  {Add the totals.}

              OrigExemptionCodes.Free;
              OrigResidentialTypes.Free;
              OrigExemptionHomesteadCodes.Free;
              OrigCountyExemptionAmounts.Free;
              OrigTownExemptionAmounts.Free;
              OrigSchoolExemptionAmounts.Free;
              OrigVillageExemptionAmounts.Free;

              NewExemptionCodes.Free;
              NewResidentialTypes.Free;
              NewExemptionHomesteadCodes.Free;
              NewCountyExemptionAmounts.Free;
              NewTownExemptionAmounts.Free;
              NewSchoolExemptionAmounts.Free;
              NewVillageExemptionAmounts.Free;

              FreeTList(SDAmounts, SizeOf(ParcelSDValuesRecord));

              FreeTList(AuditEXList, SizeOf(AuditEXRecord));

            end;  {If not TrialRun}

                  {Now print out the parcel.}

        with Sender as TBaseReport do
          begin
            If FirstCodeAdded
              then
                begin
                  Bold := True;
                  Underline := True;
                  Println(#9 + 'The following exemptions were added:');
                  Bold := False;
                  Underline := False;
                  FirstCodeAdded := False;

                end;  {If FirstCodeAdded}

            If (LinesLeft < 5)
              then NewPage;

              {We will print probably 3 columns across, so if this is a new
               line, issue a carriage return for the last line.}

            If ((NumParcelsPrinted MOD NumColumns) = 1)
              then Println('');

            Print(#9 + ConvertSwisSBLToDashDot(SwisSBLKey));

          end;  {with Sender as TBaseReport do}

        NumParcelsPrinted := NumParcelsPrinted + 1;

      end;  {else of If EXExists}

end;  {AddEXCode}

{===================================================================}
Procedure TExemptionBroadcastForm.AddEXCodesBySwisCode(    Sender : TObject;
                                                           ParcelTable,
                                                           ParcelEXTable,
                                                           ParcelEXLookupTable : TTable;
                                                           AssessmentYear : String;
                                                       var NumParcelsPrinted : LongInt);

{Add the template exemption to each parcel in the selected swis codes.}

var
  I : Integer;
  SwisCode : String;
  FirstCodeAdded,
  EXExists, Done, FirstTimeThrough : Boolean;
  EXExistsList, STARExistsList, CoopOrMobileHomeList : TStringList;
  SwisSBLKey : String;
  NumParcelsThisSwisCode : LongInt;

begin
  EXExistsList := TStringList.Create;
  STARExistsList := TStringList.Create;
  CoopOrMobileHomeList := TStringList.Create;
  FirstCodeAdded := True;

  ProgressDialog.Start(GetRecordCount(ParcelTable), True, True);

  If TrialRun
    then ProgressDialog.UserLabelCaption := 'Num Found = ' + IntToStr(NumParcelsPrinted)
    else ProgressDialog.UserLabelCaption := 'Num Broadcasted = ' + IntToStr(NumParcelsPrinted);

  For I := 0 to (SelectedSwisCodes.Count - 1) do
    begin
      NumParcelsThisSwisCode := 0;
      SwisCode := SelectedSwisCodes[I];
      ParcelTable.CancelRange;
      SetRangeOld(ParcelTable,
                  ['TaxRollYr', 'SwisCode', 'Section',
                   'Subsection', 'Block', 'Lot', 'Sublot',
                   'Suffix'],
                  [AssessmentYear, SwisCode, '   ', '', '', '', '', ''],
                  [AssessmentYear, SwisCode, 'ZZZ', '', '', '', '', '']);

        {Don't add an EX code to an inactive parcel.}

      FirstTimeThrough := True;
      Done := False;

      ParcelTable.First;

      repeat
        If FirstTimeThrough
          then FirstTimeThrough := False
          else ParcelTable.Next;

        If ParcelTable.EOF
          then Done := True;

          {FXX04281998-4: Don't copy to roll section 9.}

        If ((not (Done or ReportCancelled)) and
            (ParcelTable.FieldByName('RollSection').Text <> '9') and
            (ParcelTable.FieldByName('ActiveFlag').Text <> InactiveParcelFlag))
          then
            begin
              SwisSBLKey := ExtractSSKey(ParcelTable);

              If TrialRun
                then ProgressDialog.UserLabelCaption := 'Num Found = ' + IntToStr(NumParcelsPrinted)
                else ProgressDialog.UserLabelCaption := 'Num Broadcasted = ' + IntToStr(NumParcelsPrinted);

                 {FXX04281998-2: Use the EX lookup table to see if the EX
                                 already exists.}

              EXExists := FindKeyOld(ParcelEXLookupTable,
                                     ['TaxRollYr', 'SwisSBLKey', 'ExemptionCode'],
                                     [AssessmentYear, SwisSBLKey, TemplateEXCode]);

              AddEXCode(Sender, ParcelTable, ParcelEXTable,
                        ParcelEXLookupTable, AssessmentYear,
                        SwisSBLKey, EXExists, NumParcelsPrinted,
                        FirstCodeAdded, EXExistsList, STARExistsList,
                        CoopOrMobileHomeList);

              NumParcelsThisSwisCode := NumParcelsThisSwisCode + 1;

            end;  {If ((not Done) and ...}

        ProgressDialog.Update(Self, ConvertSwisSBLToDashDot(SwisSBLKey));
        Application.ProcessMessages;
        ReportCancelled := ProgressDialog.Cancelled;

      until (Done or ReportCancelled);

      with Sender as TBaseReport do
        begin
          Println('');
          Println('');
          Bold := True;
          Println(#9 + 'Exemptions Added for ' + SwisCode + ' = ' +
                  IntToStr(NumParcelsThisSwisCode));
          Println('');
          Bold := False;

        end;  {with Sender as TBaseReport do}

    end;  {For I := 0 to (SelectedSwisCodes.Count - 1) do}

    {If any parcels already had this EX, then print it out.}

  PrintExistingEXs(Sender, EXExistsList, STARExistsList, CoopOrMobileHomeList);

  EXExistsList.Free;
  STARExistsList.Free;
  CoopOrMobileHomeList.Free;

  ProgressDialog.Finish;

end;  {AddEXCodesBySwisCode}

{===================================================================}
Procedure TExemptionBroadcastForm.AddEXCodesByParcelID(    Sender : TObject;
                                                           ParcelTable,
                                                           ParcelEXTable,
                                                           ParcelEXLookupTable : TTable;
                                                           AssessmentYear : String;
                                                       var NumParcelsPrinted : LongInt);

{Add the template exemption to each parcel in the selected parcel ID
 range.}

var
  FirstCodeAdded,
  ValidEntry, EXExists, Done, FirstTimeThrough : Boolean;
  EXExistsList, STARExistsList, CoopOrMobileHomeList : TStringList;
  EndSwisSBLKey, CurrentSwisSBLKey : String;
  StartSBLRec : SBLRecord;

begin
  FirstCodeAdded := True;
  EXExistsList := TStringList.Create;
  STARExistsList := TStringList.Create;
  CoopOrMobileHomeList := TStringList.Create;

  ProgressDialog.Start(GetRecordCount(ParcelTable), True, True);

  If TrialRun
    then ProgressDialog.UserLabelCaption := 'Num Found = ' + IntToStr(NumParcelsPrinted)
    else ProgressDialog.UserLabelCaption := 'Num Broadcasted = ' + IntToStr(NumParcelsPrinted);

    {FXX05281999-1: Start parcel ID was looking at the end parcel ID.}

  StartSBLRec := ExtractSwisSBLFromSwisSBLKey(ConvertSwisDashDotToSwisSBL(StartParcelID,
                                              SwisCodeTable, ValidEntry));
  EndSwisSBLKey := ConvertSwisDashDotToSwisSBL(EndParcelID,
                                               SwisCodeTable, ValidEntry);

  with StartSBLRec do
    FindNearestOld(ParcelTable,
                   ['TaxRollYr', 'SwisCode', 'Section',
                    'Subsection', 'Block', 'Lot', 'Sublot',
                    'Suffix'],
                   [AssessmentYear, SwisCode, Section, Subsection,
                    Block, Lot, Sublot, Suffix]);

    {Don't add an EX code to an inactive parcel.}

  FirstTimeThrough := True;
  Done := False;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else ParcelTable.Next;

    CurrentSwisSBLKey := ExtractSSKey(ParcelTable);

    If (ParcelTable.EOF or
        (CurrentSwisSBLKey > EndSwisSBLKey))
      then Done := True;

      {FXX04281998-4: Don't copy to roll section 9.}

    If ((not (Done or ReportCancelled)) and
        (ParcelTable.FieldByName('RollSection').Text <> '9') and
        (ParcelTable.FieldByName('ActiveFlag').Text <> InactiveParcelFlag))
      then
        begin
          If TrialRun
            then ProgressDialog.UserLabelCaption := 'Num Found = ' + IntToStr(NumParcelsPrinted)
            else ProgressDialog.UserLabelCaption := 'Num Broadcasted = ' + IntToStr(NumParcelsPrinted);

                 {FXX04281998-2: Use the EX lookup table to see if the EX
                                 already exists.}

          EXExists := FindKeyOld(ParcelEXLookupTable,
                                 ['TaxRollYr', 'SwisSBLKey', 'ExemptionCode'],
                                 [AssessmentYear, CurrentSwisSBLKey,
                                  TemplateEXCode]);

          AddEXCode(Sender, ParcelTable, ParcelEXTable,
                    ParcelEXLookupTable, AssessmentYear,
                    CurrentSwisSBLKey, EXExists, NumParcelsPrinted,
                    FirstCodeAdded, EXExistsList, STARExistsList,
                    CoopOrMobileHomeList);

        end;  {If ((not Done) and ...}

    ProgressDialog.Update(Self, ConvertSwisSBLToDashDot(CurrentSwisSBLKey));
    Application.ProcessMessages;
    ReportCancelled := ProgressDialog.Cancelled;

  until (Done or ReportCancelled);

    {If any parcels already had this EX, then print it out.}

  PrintExistingEXs(Sender, EXExistsList, STARExistsList, CoopOrMobileHomeList);

  EXExistsList.Free;
  STARExistsList.Free;
  CoopOrMobileHomeList.Free;

  ProgressDialog.Finish;

end;  {AddEXCodesByParcelID}

{===================================================================}
Procedure TExemptionBroadcastForm.AddEXCodesByPropertyClass(    Sender : TObject;
                                                                ParcelTable,
                                                                ParcelEXTable,
                                                                ParcelEXLookupTable : TTable;
                                                                AssessmentYear : String;
                                                            var NumParcelsPrinted : LongInt);

{Add the template exemption to each parcel with the specified
 property class.}

var
  FirstCodeAdded,
  EXExists, Done, FirstTimeThrough : Boolean;
  EXExistsList, STARExistsList, CoopOrMobileHomeList : TStringList;
  SwisSBLKey : String;

begin
  FirstCodeAdded := True;
  EXExistsList := TStringList.Create;
  STARExistsList := TStringList.Create;
  CoopOrMobileHomeList := TStringList.Create;

  ProgressDialog.Start(GetRecordCount(ParcelTable), True, True);

  If TrialRun
    then ProgressDialog.UserLabelCaption := 'Num Found = ' + IntToStr(NumParcelsPrinted)
    else ProgressDialog.UserLabelCaption := 'Num Broadcasted = ' + IntToStr(NumParcelsPrinted);

  ParcelTable.First;

    {Don't add an EX code to an inactive parcel.}

  FirstTimeThrough := True;
  Done := False;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else ParcelTable.Next;

    SwisSBLKey := ExtractSSKey(ParcelTable);

    If ParcelTable.EOF
      then Done := True;

      {FXX04281998-4: Don't copy to roll section 9.}

    If ((not (Done or ReportCancelled)) and
        (ParcelTable.FieldByName('RollSection').Text <> '9') and
        (ParcelTable.FieldByName('ActiveFlag').Text <> InactiveParcelFlag) and
        (ParcelTable.FieldByName('PropertyClassCode').Text = SelectedPropertyClass))
      then
        begin
          If TrialRun
            then ProgressDialog.UserLabelCaption := 'Num Found = ' + IntToStr(NumParcelsPrinted)
            else ProgressDialog.UserLabelCaption := 'Num Broadcasted = ' + IntToStr(NumParcelsPrinted);

                 {FXX04281998-2: Use the EX lookup table to see if the EX
                                 already exists.}

          EXExists := FindKeyOld(ParcelEXLookupTable,
                                 ['TaxRollYr', 'SwisSBLKey', 'ExemptionCode'],
                                 [AssessmentYear, SwisSBLKey,
                                  TemplateEXCode]);

          AddEXCode(Sender, ParcelTable, ParcelEXTable,
                    ParcelEXLookupTable, AssessmentYear,
                    SwisSBLKey, EXExists, NumParcelsPrinted,
                    FirstCodeAdded, EXExistsList, STARExistsList,
                    CoopOrMobileHomeList);

        end;  {If ((not Done) and ...}

    ProgressDialog.Update(Self, ConvertSwisSBLToDashDot(SwisSBLKey));
    Application.ProcessMessages;
    ReportCancelled := ProgressDialog.Cancelled;

  until (Done or ReportCancelled);

    {If any parcels already had this EX, then print it out.}

  PrintExistingEXs(Sender, EXExistsList, STARExistsList, CoopOrMobileHomeList);

  EXExistsList.Free;
  STARExistsList.Free;
  CoopOrMobileHomeList.Free;

  ProgressDialog.Finish;

end;  {AddEXCodesByPropertyClass}

{===================================================================}
Procedure TExemptionBroadcastForm.AddEXCodesByPreviousEX(    Sender : TObject;
                                                             ParcelTable,
                                                             ParcelEXTable,
                                                             ParcelEXLookupTable : TTable;
                                                             AssessmentYear : String;
                                                         var NumParcelsPrinted : LongInt);

{Add the template exemption to each parcel which already has the specified
 EX.}

var
  FirstCodeAdded,
  EXExists, Done, FirstTimeThrough : Boolean;
  EXExistsList, STARExistsList, CoopOrMobileHomeList : TStringList;
  SwisSBLKey : String;
  SBLRec : SBLRecord;

begin
  FirstCodeAdded := True;
  EXExistsList := TStringList.Create;
  STARExistsList := TStringList.Create;
  CoopOrMobileHomeList := TStringList.Create;

  ProgressDialog.Start(GetRecordCount(ParcelEXTable), True, True);

  If TrialRun
    then ProgressDialog.UserLabelCaption := 'Num Found = ' + IntToStr(NumParcelsPrinted)
    else ProgressDialog.UserLabelCaption := 'Num Broadcasted = ' + IntToStr(NumParcelsPrinted);

  ParcelEXTable.First;

    {Don't add an EX code to an inactive parcel.}

  FirstTimeThrough := True;
  Done := False;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else ParcelEXTable.Next;

    SwisSBLKey := ParcelEXTable.FieldByName('SwisSBLKey').Text;

    If ParcelEXTable.EOF
      then Done := True;

    If ((not Done) and
        (ParcelEXTable.FieldByName('ExemptionCode').Text = BroadcastToParcelsWithEX))
      then
        begin
            {Get the parcel for this EX record to see if active.}

          SBLRec := ExtractSwisSBLFromSwisSBLKey(SwisSBLKey);

            {FXX10111999-2: Missing suffix in lookup.}

          with SBLRec do
            FindKeyOld(ParcelTable,
                       ['TaxRollYr', 'SwisCode', 'Section',
                        'Subsection', 'Block', 'Lot', 'Sublot', 'Suffix'],
                       [AssessmentYear, SwisCode, Section, Subsection,
                        Block, Lot, Sublot, Suffix]);

          {FXX04281998-4: Don't copy to roll section 9.}

          If ((ParcelTable.FieldByName('RollSection').Text <> '9') and
              (ParcelTable.FieldByName('ActiveFlag').Text <> InactiveParcelFlag))
            then
              begin
                If TrialRun
                  then ProgressDialog.UserLabelCaption := 'Num Found = ' + IntToStr(NumParcelsPrinted)
                  else ProgressDialog.UserLabelCaption := 'Num Broadcasted = ' + IntToStr(NumParcelsPrinted);

                 {FXX04281998-2: Use the EX lookup table to see if the EX
                                 already exists.}

                EXExists := FindKeyOld(ParcelEXLookupTable,
                                       ['TaxRollYr', 'SwisSBLKey', 'ExemptionCode'],
                                       [AssessmentYear, SwisSBLKey,
                                        TemplateEXCode]);

                  {FXX11191999-10: If broadcasting a variable percent exemption
                                   (i.e. disabled vet or senior), transfer the
                                   percent.}
                  {CHG08132008-1(2.15.1.5): Add 4191x as a low income disabled exemption.}

                If ((Take(4, BroadcastToParcelsWithEX) = '4114') or {Disabled vet}
                    (Take(4, BroadcastToParcelsWithEX) = '4180') or {Senior}
                    ExemptionIsLowIncomeDisabled(BroadcastToParcelsWithEX))
(*                    (Take(4, BroadcastToParcelsWithEX) = '4190') or {Low income phys disab}
                    (Take(4, BroadcastToParcelsWithEX) = '4193')) *)
                  then TemplatePercent := ParcelEXTable.FieldByName('Percent').AsFloat;

                  {FXX11221999-3: Make sure to carry owner percent forward.}

                OwnerPercent := ParcelEXTable.FieldByName('OwnerPercent').AsFloat;

                  {FXX04281998-1: For inserting the new exemptions
                                  when searching by existing EX, must use diff
                                  table than search table so position in file
                                  does not get messed up.}

                AddEXCode(Sender, ParcelTable, ParcelEXLookupTable,
                          ParcelEXLookupTable, AssessmentYear,
                          SwisSBLKey, EXExists, NumParcelsPrinted,
                          FirstCodeAdded, EXExistsList, STARExistsList,
                          CoopOrMobileHomeList);

              end;  {If (ParcelTable.FieldByName('ActiveFlag').Text <> InactiveParcelFlag)}

        end;  {If ((not Done) and ...}

    ProgressDialog.Update(Self, ConvertSwisSBLToDashDot(SwisSBLKey));
    Application.ProcessMessages;
    ReportCancelled := ProgressDialog.Cancelled;

  until (Done or ReportCancelled);

    {If any parcels already had this EX, then print it out.}

  PrintExistingEXs(Sender, EXExistsList, STARExistsList, CoopOrMobileHomeList);

  EXExistsList.Free;
  STARExistsList.Free;
  CoopOrMobileHomeList.Free;

  ProgressDialog.Finish;

end;  {AddEXCodesByPreviousEX}

{===================================================================}
Procedure TExemptionBroadcastForm.ReplaceExemption(    Sender : TObject;
                                                       ParcelTable,
                                                       ParcelEXTable,
                                                       ParcelEXLookupTable : TTable;
                                                       AssessmentYear : String;
                                                   var NumParcelsPrinted : LongInt);

{Replace an exemption with the template exemption.}

var
  EXExistsList, STARExistsList, CoopOrMobileHomeList : TStringList;
  SwisSBLKey : String;
  EXExists, FirstCodeAdded : Boolean;
  ExemptionsNotRecalculatedList : TStringList;
  iProcessingType : Integer;

begin
  iProcessingType := GetProcessingTypeForTaxRollYear(AssessmentYear);
  EXExists := False;
  FirstCodeAdded := False;
  EXExistsList := TStringList.Create;
  STARExistsList := TStringList.Create;
  CoopOrMobileHomeList := TStringList.Create;
  ExemptionsNotRecalculatedList := TStringList.Create;

  ProgressDialog.Start(GetRecordCount(ParcelTable), True, True);

  If TrialRun
    then ProgressDialog.UserLabelCaption := 'Num Found = ' + IntToStr(NumParcelsPrinted)
    else ProgressDialog.UserLabelCaption := 'Num Broadcasted = ' + IntToStr(NumParcelsPrinted);

  ParcelTable.First;

  with ParcelTable do
    while (not EOF) do
      begin
        SwisSBLKey := ExtractSSKey(ParcelTable);
        ProgressDialog.Update(Self, ConvertSwisSBLToDashDot(SwisSBLKey));
        Application.ProcessMessages;
        ReportCancelled := ProgressDialog.Cancelled;

        If (_Compare(FieldByName('RollSection').AsString, '9', coNotEqual) and
            ParcelIsActive(ParcelTable) and
            _Locate(ParcelEXTable, [AssessmentYear, SwisSBLKey, BroadcastToParcelsWithEX], '', []))
          then
            begin
              If TrialRun
                then ProgressDialog.UserLabelCaption := 'Num Found = ' + IntToStr(NumParcelsPrinted)
                else
                  begin
                    ProgressDialog.UserLabelCaption := 'Num Broadcasted = ' + IntToStr(NumParcelsPrinted);

                    If (_Compare(BroadcastToParcelsWithEX, '4114', coStartsWith) or {Disabled vet}
                        _Compare(BroadcastToParcelsWithEX, '4180', coStartsWith) or {Senior}
                        ExemptionIsLowIncomeDisabled(BroadcastToParcelsWithEX))
                      then TemplatePercent := ParcelEXTable.FieldByName('Percent').AsFloat;

                    OwnerPercent := ParcelEXTable.FieldByName('OwnerPercent').AsFloat;

                    DeleteAnExemption(ParcelEXTable,
                                      ParcelEXLookupTable,
                                      tbRemovedExemptions,
                                      AuditEXChangeTable,
                                      tbAudit,
                                      AssessmentTable,
                                      ClassTable,
                                      SwisCodeTable,
                                      ParcelTable,
                                      EXCodeTable,
                                      AssessmentYear,
                                      SwisSBLKey,
                                      ExemptionsNotRecalculatedList);

                    AddEXCode(Sender, ParcelTable, ParcelEXLookupTable,
                              ParcelEXLookupTable, AssessmentYear,
                              SwisSBLKey, EXExists, NumParcelsPrinted,
                              FirstCodeAdded, EXExistsList, STARExistsList,
                              CoopOrMobileHomeList);

                  end;  {else of If TrialRun}

            end;  {If (_Compare(ParcelTable.FieldByName('RollSection').AsString ...}

        Next;

      end;  {while (not EOF) do}

  EXExistsList.Free;
  STARExistsList.Free;
  CoopOrMobileHomeList.Free;
  ExemptionsNotRecalculatedList.Free;

  If not TrialRun
    then CreateRollTotals(iProcessingType, AssessmentYear,
                          ProgressDialog, Self,
                          False, False);

  ProgressDialog.Finish;

end;  {ReplaceExemption}

{===================================================================}
Procedure TExemptionBroadcastForm.AddEXCodesByImportFile(    Sender : TObject;
                                                             ParcelTable,
                                                             ParcelEXTable,
                                                             ParcelEXLookupTable : TTable;
                                                             AssessmentYear : String;
                                                         var NumParcelsPrinted : LongInt);

{Add the exemptions in an extract file.}
{CHG06171998-1: Add the option to import from a file.}

var
  FirstCodeAdded,
  EXExists, Found, Done : Boolean;
  EXExistsList, RejectList, STARExistsList, CoopOrMobileHomeList : TStringList;
  SwisSBLKey : String;
  EXImportFile : TextFile;
  ImportLine : String;
  NumImported, NumFound : LongInt;
  SBLRec : SBLRecord;
  TotalAmount, TotalUnits : Extended;

begin
  FirstCodeAdded := True;
  NumImported := 0;
  NumFound := 0;
  TotalAmount := 0;
  TotalUnits := 0;
  Done := False;
  EXExistsList := TStringList.Create;
  RejectList := TStringList.Create;
  STARExistsList := TStringList.Create;
  CoopOrMobileHomeList := TStringList.Create;

  ProgressDialog.Start(GetRecordCount(ParcelTable), True, True);

  AssignFile(EXImportFile, ImportFileName);
  Reset(EXImportFile);

  repeat
    Readln(EXImportFile, ImportLine);

    If EOF(EXImportFile)
      then Done := True;

    If TrialRun
      then ProgressDialog.UserLabelCaption := 'Num Found = ' + IntToStr(NumFound)
      else ProgressDialog.UserLabelCaption := 'Num Broadcasted = ' + IntToStr(NumImported);

      {Process one line.}

     {FXX04281998-4: Don't copy to roll section 9.}

   SwisSBLKey := Copy(ImportLine, 4, 26);
   SBLRec := ExtractSwisSBLFromSwisSBLKey(SwisSBLKey);

   with SBLRec do
     Found := FindKeyOld(ParcelTable,
                         ['TaxRollYr', 'SwisCode', 'Section',
                          'Subsection', 'Block', 'Lot', 'Sublot',
                          'Suffix'],
                         [AssessmentYear, SwisCode, Section, Subsection,
                          Block, Lot, Sublot, Suffix]);

   If ((not (Done or ReportCancelled)) and
       Found and
       (ParcelTable.FieldByName('RollSection').Text <> '9') and
       (ParcelTable.FieldByName('ActiveFlag').Text <> InactiveParcelFlag))
     then
       begin
         NumFound := NumFound + 1;

         Application.ProcessMessages;

         TemplateEXCode := Copy(ImportLine, 48, 5);

         try
           TemplateAmount := StrToFloat(Copy(ImportLine, 66, 13));
         except
           TemplateAmount := 0;
         end;

         try
           TemplatePercent := StrToFloat(Copy(ImportLine, 60, 5)) / 100;
         except
           TemplatePercent := 0;
         end;

         If TrialRun
           then ProgressDialog.UserLabelCaption := 'Num Found = ' + IntToStr(NumImported)
           else ProgressDialog.UserLabelCaption := 'Num Broadcasted = ' + IntToStr(NumFound);

          {FXX04281998-2: Use the EX lookup table to see if the EX
                          already exists.}

         EXExists := FindKeyOld(ParcelEXLookupTable,
                                ['TaxRollYr', 'SwisSBLKey', 'ExemptionCode'],
                                [AssessmentYear, SwisSBLKey,
                                 TemplateEXCode]);

           {FXX04281998-1: For inserting the new exemptions
                           when searching by existing EX, must use diff
                           table than search table so position in file
                           does not get messed up.}

         AddEXCode(Sender, ParcelTable, ParcelEXLookupTable,
                   ParcelEXLookupTable, AssessmentYear,
                   SwisSBLKey, EXExists, NumImported,
                   FirstCodeAdded, EXExistsList, STARExistsList,
                   CoopOrMobileHomeList);

         If not EXExists
           then TotalAmount := TotalAmount + TemplateAmount;

       end;  {If ((not (Done or ReportCancelled)) and}

    If not Found
      then RejectList.Add(SwisSBLKey);

    Application.ProcessMessages;
    ProgressDialog.Update(Self, ConvertSwisSBLToDashDot(SwisSBLKey));
    ReportCancelled := ProgressDialog.Cancelled;

  until (Done or ReportCancelled);

  CloseFile(EXImportFile);

  with Sender as TBaseReport do
    begin
      Println('');
      Println('');
      Bold := True;
      Println(#9 + 'exemptions Imported = ' +
              IntToStr(NumImported));
      Println(#9 + 'Total EX Amount Imported = $' +
              FormatFloat(DecimalDisplay, TotalAmount));
      Println(#9 + 'Total EX Units Imported = ' +
              FormatFloat(DecimalDisplay, TotalUnits));
      Println('');
      Bold := False;

    end;  {with Sender as TBaseReport do}

    {If any parcels already had this EX, then print it out.}

  PrintExistingEXs(Sender, EXExistsList, STARExistsList, CoopOrMobileHomeList);

    {Now print any rejects.}

  PrintRejects(Sender, RejectList);

  EXExistsList.Free;
  RejectList.Free;
  STARExistsList.Free;
  CoopOrMobileHomeList.Free;

  ProgressDialog.Finish;

  NumParcelsPrinted := NumImported;

end;  {AddEXCodesByImportFile}

{===================================================================}
Procedure TExemptionBroadcastForm.AddEXCodesByParcelList(    Sender : TObject;
                                                             ParcelTable,
                                                             ParcelEXTable,
                                                             ParcelEXLookupTable : TTable;
                                                             AssessmentYear : String;
                                                         var NumParcelsPrinted : LongInt);

{Add the template exemption to each parcel in the selected parcel ID
 range.}

var
  Index : Integer;
  FirstCodeAdded,
  EXExists, Done, FirstTimeThrough : Boolean;
  EXExistsList, STARExistsList, CoopOrMobileHomeList : TStringList;
  SwisSBLKey : String;
  SBLRec : SBLRecord;

begin
  Index := 1;
  FirstCodeAdded := True;
  EXExistsList := TStringList.Create;
  STARExistsList := TStringList.Create;
  CoopOrMobileHomeList := TStringList.Create;

  ParcelListDialog.GetParcel(ParcelTable, Index);

  ProgressDialog.Start(ParcelListDialog.NumItems, True, True);

  If TrialRun
    then ProgressDialog.UserLabelCaption := 'Num Found = ' + IntToStr(NumParcelsPrinted)
    else ProgressDialog.UserLabelCaption := 'Num Broadcasted = ' + IntToStr(NumParcelsPrinted);

    {Don't add an EX code to an inactive parcel.}

  FirstTimeThrough := True;
  Done := False;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else
        begin
          Index := Index + 1;
          ParcelListDialog.GetParcel(ParcelTable, Index);
        end;

    If (Index > ParcelListDialog.NumItems)
      then Done := True;

    SwisSBLKey := ExtractSSKey(ParcelTable);

    SBLRec := ExtractSwisSBLFromSwisSBLKey(SwisSBLKey);

    with SBLRec do
      FindKeyOld(ParcelTable,
                 ['TaxRollYr', 'SwisCode', 'Section',
                  'Subsection', 'Block', 'Lot', 'Sublot',
                  'Suffix'],
                 [AssessmentYear, SwisCode, Section, Subsection, Block,
                  Lot, Sublot, Suffix]);

      {FXX04281998-4: Don't copy to roll section 9.}

    If ((not (Done or ReportCancelled)) and
        (ParcelTable.FieldByName('RollSection').Text <> '9') and
        (ParcelTable.FieldByName('ActiveFlag').Text <> InactiveParcelFlag))
      then
        begin
          If TrialRun
            then ProgressDialog.UserLabelCaption := 'Num Found = ' + IntToStr(NumParcelsPrinted)
            else ProgressDialog.UserLabelCaption := 'Num Broadcasted = ' + IntToStr(NumParcelsPrinted);

                 {FXX04281998-2: Use the EX lookup table to see if the EX
                                 already exists.}

          EXExists := FindKeyOld(ParcelEXLookupTable,
                                 ['TaxRollYr', 'SwisSBLKey', 'ExemptionCode'],
                                 [AssessmentYear, SwisSBLKey,
                                  TemplateEXCode]);

          AddEXCode(Sender, ParcelTable, ParcelEXTable,
                    ParcelEXLookupTable, AssessmentYear,
                    SwisSBLKey, EXExists, NumParcelsPrinted,
                    FirstCodeAdded, EXExistsList, STARExistsList,
                    CoopOrMobileHomeList);

        end;  {If ((not Done) and ...}

    ProgressDialog.Update(Self, ConvertSwisSBLToDashDot(SwisSBLKey));
    Application.ProcessMessages;
    ReportCancelled := ProgressDialog.Cancelled;

  until (Done or ReportCancelled);

    {If any parcels already had this EX, then print it out.}

  PrintExistingEXs(Sender, EXExistsList, STARExistsList, CoopOrMobileHomeList);

  EXExistsList.Free;
  STARExistsList.Free;
  CoopOrMobileHomeList.Free;

  ProgressDialog.Finish;

end;  {AddEXCodesByParcelList}

{===================================================================}
Procedure TExemptionBroadcastForm.DeleteOneEXCode(    Sender : TObject;
                                                      ParcelTable,
                                                      ParcelEXTable,
                                                      ParcelEXLookupTable,
                                                      tbExemptionDenials,
                                                      tbExemptionRemovals : TTable;
                                                      AssessmentYear : String;
                                                      sExemptionCode : String;
                                                      sDenialMessage : String;
                                                      SwisSBLKey : String;
                                                      bCreateDenialRecord : Boolean;
                                                      bTrialRun : Boolean;
                                                  var bFirstCodeDeleted : Boolean;
                                                  var NumParcelsPrinted : Integer);

{Delete an exemption from this parcel and print it out.}
{FXX04281998-3: Pass in the SwisSBL since not always driven on the parcel table.}

var
  OrigExemptionCodes,
  OrigResidentialTypes,
  OrigExemptionHomesteadCodes,
  OrigCountyExemptionAmounts,
  OrigTownExemptionAmounts,
  OrigSchoolExemptionAmounts,
  OrigVillageExemptionAmounts,
  NewExemptionCodes,
  NewResidentialTypes,
  NewExemptionHomesteadCodes,
  NewCountyExemptionAmounts,
  NewTownExemptionAmounts,
  NewSchoolExemptionAmounts,
  NewVillageExemptionAmounts : TStringList;
  OrigBasicSTARAmount, OrigEnhancedSTARAmount,
  NewBasicSTARAmount, NewEnhancedSTARAmount : Comp;
  AuditEXList, SDAmounts : TList;
  TempStr : String;

begin
  TempStr := ConvertSwisSBLToDashDot(SwisSBLKey);

  If ((not bTrialRun) and
      _Locate(ParcelExTable, [AssessmentYear, SwisSBLKey, sExemptionCode], '', []))
  then
  begin
    AuditEXList := TList.Create;
    GetAuditEXList(SwisSBLKey, AssessmentYear, ParcelEXLookupTable, AuditEXList);
    InsertAuditEXChanges(SwisSBLKey, AssessmentYear, AuditEXList,
                         AuditEXChangeTable, 'B');

    OrigExemptionCodes := TStringList.Create;
    OrigResidentialTypes := TStringList.Create;
    OrigExemptionHomesteadCodes := TStringList.Create;
    OrigCountyExemptionAmounts := TStringList.Create;
    OrigTownExemptionAmounts := TStringList.Create;
    OrigSchoolExemptionAmounts := TStringList.Create;
    OrigVillageExemptionAmounts := TStringList.Create;

    NewExemptionCodes := TStringList.Create;
    NewResidentialTypes := TStringList.Create;
    NewExemptionHomesteadCodes := TStringList.Create;
    NewCountyExemptionAmounts := TStringList.Create;
    NewTownExemptionAmounts := TStringList.Create;
    NewSchoolExemptionAmounts := TStringList.Create;
    NewVillageExemptionAmounts := TStringList.Create;
    SDAmounts := TList.Create;

    FindKeyOld(AssessmentTable,
               ['TaxRollYr', 'SwisSBLKey'],
               [AssessmentYear, SwisSBLKey]);

    TotalExemptionsForParcel(AssessmentYear, SwisSBLKey,
                             ParcelExTable,
                             EXCodeTable,
                             ParcelTable.FieldByName('HomesteadCode').Text,
                             'A',
                             OrigExemptionCodes,
                             OrigExemptionHomesteadCodes,
                             OrigResidentialTypes,
                             OrigCountyExemptionAmounts,
                             OrigTownExemptionAmounts,
                             OrigSchoolExemptionAmounts,
                             OrigVillageExemptionAmounts,
                             OrigBasicSTARAmount,
                             OrigEnhancedSTARAmount);

    with tbExemptionRemovals do
    try
      Insert;
      FieldByName('SwisSBLKey').Text := SwisSBLKey;
      FieldByName('ActualDateRemoved').AsDateTime := Date;
      FieldByName('RemovedBy').Text := GlblUserName;
      FieldByName('ExemptionCode').Text := sExemptionCode;
      FieldByName('CountyAmount').AsFloat := ParcelEXTable.FieldByName('CountyAmount').AsInteger;
      FieldByName('TownAmount').AsFloat := ParcelEXTable.FieldByName('TownAmount').AsInteger;
      FieldByName('SchoolAmount').AsFloat := ParcelEXTable.FieldByName('SchoolAmount').AsInteger;
      FieldByName('VillageAmount').AsFloat := ParcelEXTable.FieldByName('VillageAmount').AsInteger;
      FieldByName('YearRemovedFrom').Text := AssessmentYear;
      FieldByName('EffectiveDateRemoved').AsDateTime := Date;

      try
        FieldByName('InitialDate').AsDateTime := ParcelEXTable.FieldByName('InitialDate').AsDateTime;
      except
      end;

      try
        FieldByName('Percent').AsFloat := ParcelEXTable.FieldByName('Percent').AsFloat;
      except
      end;

      Post;
    except
    end;

    If bCreateDenialRecord
    then
      with tbExemptionDenials do
      try
        Insert;
        FieldByName('TaxRollYr').AsString := AssessmentYear;
        FieldByName('SwisSBLKey').AsString := SwisSBLKey;
        FieldByName('ExemptionCode').AsString := sExemptionCode;
        FieldByName('DenialDate').AsDateTime := Date;
        TMemoField(FieldByName('Reason')).AsString := sDenialMessage;
        Post;
      except
      end;


    If _Locate(ParcelExTable, [AssessmentYear, SwisSBLKey, sExemptionCode], '', [])
    then
      with ParcelEXTable do
      try
        Delete;
      except;
        SystemSupport(010, ParcelEXTable, 'Error deleting EX record: ' +
                      ConvertSwisSBLToDashDot(SwisSBLKey) + '.',
                      UnitName, GlblErrorDlgBox);
      end;

      {Since there has been a change to one exemption, we will
       have to recalculate all exemptions, thus we will have to
       recalculate the swis and school totals since these might
       be affected, too.}

    RecalculateExemptionsForParcel(EXCodeTable,
                                   ParcelEXTable,
                                   AssessmentTable,
                                   ClassTable,
                                   SwisCodeTable,
                                   ParcelTable,
                                   AssessmentYear, SwisSBLKey, nil,
                                   0, 0, False);

    TotalExemptionsForParcel(AssessmentYear, SwisSBLKey,
                             ParcelExTable,
                             EXCodeTable,
                             ParcelTable.FieldByName('HomesteadCode').Text,
                             'A',
                             NewExemptionCodes,
                             NewExemptionHomesteadCodes,
                             NewResidentialTypes,
                             NewCountyExemptionAmounts,
                             NewTownExemptionAmounts,
                             NewSchoolExemptionAmounts,
                             NewVillageExemptionAmounts,
                             NewBasicSTARAmount,
                             NewEnhancedSTARAmount);

       {This is the after picture.}

     ClearTList(AuditEXList, SizeOf(AuditEXRecord));
     GetAuditEXList(SwisSBLKey, AssessmentYear,
                    ParcelEXLookupTable, AuditEXList);
     InsertAuditEXChanges(SwisSBLKey, AssessmentYear, AuditEXList,
                          AuditEXChangeTable, 'A');

      {Delete all the old roll totals for this parcel.
       We are only going to adjust the exemption roll
       totals since these are the only totals affected by
       an EX change.}

    AdjustRollTotalsForParcel(AssessmentYear,
                              ParcelTable.FieldByName('SwisCode').Text,
                              ParcelTable.FieldByName('SchoolCode').Text,
                              ParcelTable.FieldByName('HomesteadCode').Text,
                              ParcelTable.FieldByName('RollSection').Text,
                              0, 0, 0, 0,
                              OrigExemptionCodes,
                              OrigExemptionHomesteadCodes,
                              OrigCountyExemptionAmounts,
                              OrigTownExemptionAmounts,
                              OrigSchoolExemptionAmounts,
                              OrigVillageExemptionAmounts,
                              ParcelTable,
                              OrigBasicSTARAmount,
                              OrigEnhancedSTARAmount,
                              SDAmounts,
                              ['E', 'S', 'C', 'D'],  {EX}
                              'D');  {Delete the totals.}

      {Add the new roll totals for this parcel.}

    AdjustRollTotalsForParcel(AssessmentYear,
                              ParcelTable.FieldByName('SwisCode').Text,
                              ParcelTable.FieldByName('SchoolCode').Text,
                              ParcelTable.FieldByName('HomesteadCode').Text,
                              ParcelTable.FieldByName('RollSection').Text,
                              0, 0, 0, 0,
                              NewExemptionCodes,
                              NewExemptionHomesteadCodes,
                              NewCountyExemptionAmounts,
                              NewTownExemptionAmounts,
                              NewSchoolExemptionAmounts,
                              NewVillageExemptionAmounts,
                              ParcelTable,
                              NewBasicSTARAmount,
                              NewEnhancedSTARAmount,
                              SDAmounts,
                              ['E', 'S', 'C', 'D'],  {EX}
                              'A');  {Add the totals.}

    OrigExemptionCodes.Free;
    OrigResidentialTypes.Free;
    OrigExemptionHomesteadCodes.Free;
    OrigCountyExemptionAmounts.Free;
    OrigTownExemptionAmounts.Free;
    OrigSchoolExemptionAmounts.Free;
    OrigVillageExemptionAmounts.Free;

    NewExemptionCodes.Free;
    NewResidentialTypes.Free;
    NewExemptionHomesteadCodes.Free;
    NewCountyExemptionAmounts.Free;
    NewTownExemptionAmounts.Free;
    NewSchoolExemptionAmounts.Free;
    NewVillageExemptionAmounts.Free;

    FreeTList(SDAmounts, SizeOf(ParcelSDValuesRecord));

    FreeTList(AuditEXList, SizeOf(AuditEXRecord));

  end;  {If not TrialRun}

    {Now print out the parcel.}

  with Sender as TBaseReport do
    begin
      If bFirstCodeDeleted
        then
          begin
            Bold := True;
            Underline := True;
            Println(#9 + 'The following exemptions were deleted:');
            Bold := False;
            Underline := False;
            bFirstCodeDeleted := False;

          end;  {If FirstCodeAdded}

      If (LinesLeft < 5)
        then NewPage;

        {We will print probably 3 columns across, so if this is a new
         line, issue a carriage return for the last line.}

      If ((NumParcelsPrinted MOD NumColumns) = 1)
        then Println('');

      Print(#9 + ConvertSwisSBLToDashDot(SwisSBLKey));

    end;  {with Sender as TBaseReport do}

  NumParcelsPrinted := NumParcelsPrinted + 1;

end;  {DeleteOneEXCode}

{===================================================================}
Procedure TExemptionBroadcastForm.DeleteEXCodeByParcelList(    Sender : TObject;
                                                               ParcelTable,
                                                               ParcelEXTable,
                                                               ParcelEXLookupTable,
                                                               tbExemptionDenials,
                                                               tbExemptionRemovals : TTable;
                                                               AssessmentYear : String;
                                                               sExemptionCode : String;
                                                               sDenialMessage : String;
                                                               bCreateDenialRecord : Boolean;
                                                               bTrialRun : Boolean;
                                                           var NumParcelsPrinted : LongInt);

{Add the template exemption to each parcel in the selected parcel ID
 range.}

var
  Index : Integer;
  bFirstCodeDeleted,
  EXExists, Done, FirstTimeThrough : Boolean;
  SwisSBLKey : String;
  SBLRec : SBLRecord;

begin
  Index := 1;
  bFirstCodeDeleted := True;

  ParcelListDialog.GetParcel(ParcelTable, Index);

  ProgressDialog.Start(ParcelListDialog.NumItems, True, True);

  If TrialRun
    then ProgressDialog.UserLabelCaption := 'Num Found = ' + IntToStr(NumParcelsPrinted)
    else ProgressDialog.UserLabelCaption := 'Num Deleted = ' + IntToStr(NumParcelsPrinted);

    {Don't add an EX code to an inactive parcel.}

  FirstTimeThrough := True;
  Done := False;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else
        begin
          Index := Index + 1;
          ParcelListDialog.GetParcel(ParcelTable, Index);
        end;

    If (Index > ParcelListDialog.NumItems)
      then Done := True;

    SwisSBLKey := ExtractSSKey(ParcelTable);

    SBLRec := ExtractSwisSBLFromSwisSBLKey(SwisSBLKey);

    with SBLRec do
      FindKeyOld(ParcelTable,
                 ['TaxRollYr', 'SwisCode', 'Section',
                  'Subsection', 'Block', 'Lot', 'Sublot',
                  'Suffix'],
                 [AssessmentYear, SwisCode, Section, Subsection, Block,
                  Lot, Sublot, Suffix]);

      {FXX04281998-4: Don't copy to roll section 9.}

    If ((not (Done or ReportCancelled)) and
        (ParcelTable.FieldByName('RollSection').Text <> '9') and
        (ParcelTable.FieldByName('ActiveFlag').Text <> InactiveParcelFlag))
      then
        begin
          If TrialRun
            then ProgressDialog.UserLabelCaption := 'Num Found = ' + IntToStr(NumParcelsPrinted)
            else ProgressDialog.UserLabelCaption := 'Num Deleted = ' + IntToStr(NumParcelsPrinted);

                 {FXX04281998-2: Use the EX lookup table to see if the EX
                                 already exists.}

          EXExists := FindKeyOld(ParcelEXLookupTable,
                                 ['TaxRollYr', 'SwisSBLKey', 'ExemptionCode'],
                                 [AssessmentYear, SwisSBLKey,
                                  TemplateEXCode]);


          If EXExists
          then DeleteOneEXCode(Sender, ParcelTable, ParcelEXTable,
                               ParcelEXLookupTable, tbExemptionDenials,
                               tbExemptionRemovals, AssessmentYear,
                               sExemptionCode, sDenialMessage,
                               SwisSBLKey, bCreateDenialRecord,
                               bTrialRun, bFirstCodeDeleted, NumParcelsPrinted);

        end;  {If ((not Done) and ...}

    ProgressDialog.Update(Self, ConvertSwisSBLToDashDot(SwisSBLKey));
    Application.ProcessMessages;
    ReportCancelled := ProgressDialog.Cancelled;

  until (Done or ReportCancelled);

  ProgressDialog.Finish;

end;  {DeleteEXCodesByParcelList}

{===================================================================}
Procedure TExemptionBroadcastForm.DeleteEXCode(    Sender : TObject;
                                                   ParcelTable,
                                                   ParcelEXTable,
                                                   ParcelEXLookupTable : TTable;
                                                   AssessmentYear : String;
                                               var NumParcelsPrinted : LongInt);

{Delete EX Code.}

var
  FirstCodeDeleted, Done, FirstTimeThrough : Boolean;
  SwisSBLKey : String;
  SBLRec : SBLRecord;
  OrigExemptionCodes,
  OrigResidentialTypes,
  OrigExemptionHomesteadCodes,
  OrigCountyExemptionAmounts,
  OrigTownExemptionAmounts,
  OrigSchoolExemptionAmounts,
  OrigVillageExemptionAmounts,
  NewExemptionCodes,
  NewResidentialTypes,
  NewExemptionHomesteadCodes,
  NewCountyExemptionAmounts,
  NewTownExemptionAmounts,
  NewSchoolExemptionAmounts,
  NewVillageExemptionAmounts : TStringList;
  OrigBasicSTARAmount, OrigEnhancedSTARAmount,
  NewBasicSTARAmount, NewEnhancedSTARAmount : Comp;
  AuditEXList, SDAmounts : TList;

begin
  FirstCodeDeleted := True;
  ProgressDialog.Start(GetRecordCount(ParcelEXTable), True, True);

  If TrialRun
    then ProgressDialog.UserLabelCaption := 'Num Found = ' + IntToStr(NumParcelsPrinted)
    else ProgressDialog.UserLabelCaption := 'Num Deleted = ' + IntToStr(NumParcelsPrinted);

  ParcelEXTable.IndexName := 'BYEXEMPTIONCODE';

  FirstTimeThrough := True;
  Done := False;

  If TrialRun
    then
      begin
        ParcelEXTable.CancelRange;
        SetRangeOld(ParcelEXTable, ['ExemptionCode'],
                    [TemplateEXCode], [TemplateEXCode]);
        ParcelEXTable.First;

      end;  {If TrialRun}

    {FXX06302003-3(2.07e): Cancel the range and reset it each time to make sure all exemption are deleted.}

  repeat
    If TrialRun
      then
        begin
          If FirstTimeThrough
            then FirstTimeThrough := False
            else ParcelEXTable.Next;
        end
      else
        begin
          ParcelEXTable.CancelRange;
          SetRangeOld(ParcelEXTable, ['ExemptionCode'],
                      [TemplateEXCode], [TemplateEXCode]);
          ParcelEXTable.First;

        end;  {else of If TrialRun}

    SwisSBLKey := ParcelEXTable.FieldByName('SwisSBLKey').Text;

    If ParcelEXTable.EOF
      then Done := True;

    If (not (Done or ReportCancelled))
      then
        begin
          If TrialRun
            then ProgressDialog.UserLabelCaption := 'Num Found = ' + IntToStr(NumParcelsPrinted)
            else
              begin
                ProgressDialog.UserLabelCaption := 'Num Deleted = ' + IntToStr(NumParcelsPrinted);

                FindKeyOld(AssessmentTable,
                           ['TaxRollYr', 'SwisSBLKey'],
                           [AssessmentYear, SwisSBLKey]);
                SBLRec := ExtractSwisSBLFromSwisSBLKey(SwisSBLKey);

                with SBLRec do
                  FindKeyOld(ParcelTable,
                             ['TaxRollYr', 'SwisCode', 'Section',
                              'Subsection', 'Block', 'Lot', 'Sublot',
                              'Suffix'],
                             [AssessmentYear, SwisCode, Section, Subsection,
                              Block, Lot, Sublot, Suffix]);

                AuditEXList := TList.Create;
                GetAuditEXList(SwisSBLKey, AssessmentYear, ParcelEXLookupTable, AuditEXList);
                InsertAuditEXChanges(SwisSBLKey, AssessmentYear, AuditEXList,
                                     AuditEXChangeTable, 'B');

                  {FXX04281998-6: Add roll total adjustments and audit trail
                                  entries.}
                  {Note that for the parcel EX and EX code tables, we use yet another
                   copy to make sure that we don't lose position in the tables we
                   are using.}

                OrigExemptionCodes := TStringList.Create;
                OrigResidentialTypes := TStringList.Create;
                OrigExemptionHomesteadCodes := TStringList.Create;
                OrigCountyExemptionAmounts := TStringList.Create;
                OrigTownExemptionAmounts := TStringList.Create;
                OrigSchoolExemptionAmounts := TStringList.Create;
                OrigVillageExemptionAmounts := TStringList.Create;

                NewExemptionCodes := TStringList.Create;
                NewResidentialTypes := TStringList.Create;
                NewExemptionHomesteadCodes := TStringList.Create;
                NewCountyExemptionAmounts := TStringList.Create;
                NewTownExemptionAmounts := TStringList.Create;
                NewSchoolExemptionAmounts := TStringList.Create;
                NewVillageExemptionAmounts := TStringList.Create;
                SDAmounts := TList.Create;

                FindKeyOld(AssessmentTable,
                           ['TaxRollYr', 'SwisSBLKey'],
                           [AssessmentYear, SwisSBLKey]);

                TotalExemptionsForParcel(AssessmentYear, SwisSBLKey,
                                         ExemptionTable,
                                         EXCodeTable,
                                         ParcelTable.FieldByName('HomesteadCode').Text,
                                         'A',
                                         OrigExemptionCodes,
                                         OrigExemptionHomesteadCodes,
                                         OrigResidentialTypes,
                                         OrigCountyExemptionAmounts,
                                         OrigTownExemptionAmounts,
                                         OrigSchoolExemptionAmounts,
                                         OrigVillageExemptionAmounts,
                                         OrigBasicSTARAmount,
                                         OrigEnhancedSTARAmount);

                try
                  ParcelEXTable.Delete;
                except
                  SystemSupport(032, ParcelEXTable,
                                'Error deleting ' + TemplateEXCode + ' from ' + SwisSBLKey,
                                UnitName, GlblErrorDlgBox);
                end;

                  {Since there has been a change to one exemption, we will
                   have to recalculate all exemptions, thus we will have to
                   recalculate the swis and school totals since these might
                   be affected, too.}

                RecalculateExemptionsForParcel(EXCodeTable,
                                               ExemptionTable,
                                               AssessmentTable,
                                               ClassTable,
                                               SwisCodeTable,
                                               ParcelTable,
                                               AssessmentYear, SwisSBLKey, nil,
                                               0, 0, False);

                TotalExemptionsForParcel(AssessmentYear, SwisSBLKey,
                                         ExemptionTable,
                                         EXCodeTable,
                                         ParcelTable.FieldByName('HomesteadCode').Text,
                                         'A',
                                         NewExemptionCodes,
                                         NewExemptionHomesteadCodes,
                                         NewResidentialTypes,
                                         NewCountyExemptionAmounts,
                                         NewTownExemptionAmounts,
                                         NewSchoolExemptionAmounts,
                                         NewVillageExemptionAmounts,
                                         NewBasicSTARAmount,
                                         NewEnhancedSTARAmount);

                   {This is the after picture.}

                 ClearTList(AuditEXList, SizeOf(AuditEXRecord));
                 GetAuditEXList(SwisSBLKey, AssessmentYear, ExemptionTable, AuditEXList);
                 InsertAuditEXChanges(SwisSBLKey, AssessmentYear, AuditEXList,
                                      AuditEXChangeTable, 'A');

                  {Delete all the old roll totals for this parcel.
                   We are only going to adjust the exemption roll
                   totals since these are the only totals affected by
                   an EX change.}

                AdjustRollTotalsForParcel(AssessmentYear,
                                          ParcelTable.FieldByName('SwisCode').Text,
                                          ParcelTable.FieldByName('SchoolCode').Text,
                                          ParcelTable.FieldByName('HomesteadCode').Text,
                                          ParcelTable.FieldByName('RollSection').Text,
                                          0, 0, 0, 0,
                                          OrigExemptionCodes,
                                          OrigExemptionHomesteadCodes,
                                          OrigCountyExemptionAmounts,
                                          OrigTownExemptionAmounts,
                                          OrigSchoolExemptionAmounts,
                                          OrigVillageExemptionAmounts,
                                          ParcelTable,
                                          OrigBasicSTARAmount,
                                          OrigEnhancedSTARAmount,
                                          SDAmounts,
                                          ['E', 'S', 'C', 'D'],  {EX}
                                          'D');  {Delete the totals.}

                  {Add the new roll totals for this parcel.}

                AdjustRollTotalsForParcel(AssessmentYear,
                                          ParcelTable.FieldByName('SwisCode').Text,
                                          ParcelTable.FieldByName('SchoolCode').Text,
                                          ParcelTable.FieldByName('HomesteadCode').Text,
                                          ParcelTable.FieldByName('RollSection').Text,
                                          0, 0, 0, 0,
                                          NewExemptionCodes,
                                          NewExemptionHomesteadCodes,
                                          NewCountyExemptionAmounts,
                                          NewTownExemptionAmounts,
                                          NewSchoolExemptionAmounts,
                                          NewVillageExemptionAmounts,
                                          ParcelTable,
                                          NewBasicSTARAmount,
                                          NewEnhancedSTARAmount,
                                          SDAmounts,
                                          ['E', 'S', 'C', 'D'],  {EX}
                                          'A');  {Add the totals.}

                OrigExemptionCodes.Free;
                OrigResidentialTypes.Free;
                OrigExemptionHomesteadCodes.Free;
                OrigCountyExemptionAmounts.Free;
                OrigTownExemptionAmounts.Free;
                OrigSchoolExemptionAmounts.Free;
                OrigVillageExemptionAmounts.Free;

                NewExemptionCodes.Free;
                NewResidentialTypes.Free;
                NewExemptionHomesteadCodes.Free;
                NewCountyExemptionAmounts.Free;
                NewTownExemptionAmounts.Free;
                NewSchoolExemptionAmounts.Free;
                NewVillageExemptionAmounts.Free;

                FreeTList(SDAmounts, SizeOf(ParcelSDValuesRecord));
                FreeTList(AuditEXList, SizeOf(AuditEXRecord));

              end;  {else of If TrialRun}

           {Now print out the parcel.}

          with Sender as TBaseReport do
            begin
              If FirstCodeDeleted
                then
                  begin
                    Bold := True;
                    Underline := True;
                    Println(#9 + 'Exemption ' + TemplateEXCode + ' was deleted ' +
                                 'from the following parcels:');
                    Bold := False;
                    Underline := False;
                    FirstCodeDeleted := False;

                  end;  {If FirstCodeAdded}

              If (LinesLeft < 5)
                then NewPage;

                {We will print probably 3 columns across, so if this is a new
                 line, issue a carriage return for the last line.}

              If ((NumParcelsPrinted MOD NumColumns) = 1)
                then Println('');

              Print(#9 + ConvertSwisSBLToDashDot(SwisSBLKey));

            end;  {with Sender as TBaseReport do}

          NumParcelsPrinted := NumParcelsPrinted + 1;

        end;  {If ((not Done) and ...}

    ProgressDialog.Update(Self, ConvertSwisSBLToDashDot(SwisSBLKey));
    Application.ProcessMessages;
    ReportCancelled := ProgressDialog.Cancelled;

  until (Done or ReportCancelled);

  ProgressDialog.Finish;
  ParcelEXTable.IndexName := 'BYYEAR_SWISSBLKEY_EXCODE';

end;  {DeleteEXCode}

{===================================================================}
Procedure PrintTotalNumPrinted(Sender : TObject;
                               AssessmentYear : String;
                               NumParcelsPrinted : LongInt;
                               BroadcastMethod : Integer);

begin
  with Sender as TBaseReport do
    begin
      Println('');
      Println('');
      Bold := True;

      If (BroadcastMethod in [bmDeleteEX, bmDeleteExemptionByParcelList])
        then Println(#9 + 'Exemptions Deleted for Assessment Year ' + AssessmentYear + ' = ' +
                     IntToStr(NumParcelsPrinted))
        else Println(#9 + 'Exemptions Added for Assessment Year ' + AssessmentYear + ' = ' +
                     IntToStr(NumParcelsPrinted));

      Println('');
      Bold := False;

    end;  {with Sender as TBaseReport do}

end;  {PrintTotalNumPrinted}

{===================================================================}
Procedure TExemptionBroadcastForm.ReportPrint(Sender: TObject);

var
  NumTYParcelsPrinted, NumNYParcelsPrinted : LongInt;
  Quit : Boolean;

begin
  Quit := False;
  NumTYParcelsPrinted := 0;
  NumNYParcelsPrinted := 0;

  case BroadcastMethod of
    bmSwisCode :
      begin
          {Add EX to all the parcels in the swis code that they
           choose.}

        If (AssessmentYear in [ayThisYear, ayBothYears])
          then
            begin
              CurrentAssessmentYear := GlblThisYear;
              OpenTableForProcessingType(ParcelTable, ParcelTableName,
                                         ThisYear, Quit);
              OpenTableForProcessingType(ParcelEXTable, ExemptionsTableName,
                                         ThisYear, Quit);
              OpenTableForProcessingType(ParcelEXLookupTable, ExemptionsTableName,
                                         ThisYear, Quit);
              OpenTableForProcessingType(ExemptionTable, ExemptionsTableName,
                                         ThisYear, Quit);
              OpenTableForProcessingType(AssessmentTable, AssessmentTableName,
                                         ThisYear, Quit);
              OpenTableForProcessingType(SwisCodeTable, SwisCodeTableName,
                                         ThisYear, Quit);

              AddEXCodesBySwisCode(Sender, ParcelTable, ParcelEXTable,
                                   ParcelEXLookupTable,
                                   GlblThisYear, NumTYParcelsPrinted);

            end;  {If (AssessmentYear in [ayThisYear, ayBothYears])}

        If (AssessmentYear in [ayNextYear, ayBothYears])
          then
            begin
                {If we already printed ThisYear, go to the next page.}

              CurrentAssessmentYear := GlblNextYear;
              If (AssessmentYear = ayBothYears)
                then
                  with Sender as TBaseReport do
                    NewPage;

              OpenTableForProcessingType(ParcelTable, ParcelTableName,
                                         NextYear, Quit);
              OpenTableForProcessingType(ParcelEXTable, ExemptionsTableName,
                                         NextYear, Quit);
              OpenTableForProcessingType(ParcelEXLookupTable, ExemptionsTableName,
                                         NextYear, Quit);
              OpenTableForProcessingType(ExemptionTable, ExemptionsTableName,
                                         NextYear, Quit);
              OpenTableForProcessingType(AssessmentTable, AssessmentTableName,
                                         NextYear, Quit);
              OpenTableForProcessingType(SwisCodeTable, SwisCodeTableName,
                                         NextYear, Quit);

              AddEXCodesBySwisCode(Sender, ParcelTable, ParcelEXTable,
                                   ParcelEXLookupTable,
                                   GlblNextYear, NumNYParcelsPrinted);

            end;  {If (AssessmentYear in [ayNextYear, ayBothYears])}

      end;  {bmSwisCode}

    bmParcelIDRange :
      begin
          {Add EX to all the parcels in the range that they specified.}

        If (AssessmentYear in [ayThisYear, ayBothYears])
          then
            begin
              CurrentAssessmentYear := GlblThisYear;
              OpenTableForProcessingType(ParcelTable, ParcelTableName,
                                         ThisYear, Quit);
              OpenTableForProcessingType(ParcelEXTable, ExemptionsTableName,
                                         ThisYear, Quit);
              OpenTableForProcessingType(ParcelEXLookupTable, ExemptionsTableName,
                                         ThisYear, Quit);
              OpenTableForProcessingType(ExemptionTable, ExemptionsTableName,
                                         ThisYear, Quit);
              OpenTableForProcessingType(AssessmentTable, AssessmentTableName,
                                         ThisYear, Quit);
              OpenTableForProcessingType(SwisCodeTable, SwisCodeTableName,
                                         ThisYear, Quit);

              AddEXCodesByParcelID(Sender, ParcelTable, ParcelEXTable,
                                   ParcelEXLookupTable,
                                   GlblThisYear, NumTYParcelsPrinted);

            end;  {If (AssessmentYear in [ayThisYear, ayBothYears])}

        If (AssessmentYear in [ayNextYear, ayBothYears])
          then
            begin
                {If we already printed ThisYear, go to the next page.}

              If (AssessmentYear = ayBothYears)
                then
                  with Sender as TBaseReport do
                    NewPage;

              CurrentAssessmentYear := GlblNextYear;

              OpenTableForProcessingType(ParcelTable, ParcelTableName,
                                         NextYear, Quit);
              OpenTableForProcessingType(ParcelEXTable, ExemptionsTableName,
                                         NextYear, Quit);
              OpenTableForProcessingType(ParcelEXLookupTable, ExemptionsTableName,
                                         NextYear, Quit);
              OpenTableForProcessingType(ExemptionTable, ExemptionsTableName,
                                         NextYear, Quit);
              OpenTableForProcessingType(AssessmentTable, AssessmentTableName,
                                         NextYear, Quit);
              OpenTableForProcessingType(SwisCodeTable, SwisCodeTableName,
                                         NextYear, Quit);

              AddEXCodesByParcelID(Sender, ParcelTable, ParcelEXTable,
                                   ParcelEXLookupTable,
                                   GlblNextYear, NumNYParcelsPrinted);

            end;  {If (AssessmentYear in [ayNextYear, ayBothYears])}

      end;  {bmParcelIDRange}

    bmPropertyClass :
      begin
          {Add EX to all parcels with property class that they specified.}

        If (AssessmentYear in [ayThisYear, ayBothYears])
          then
            begin
              CurrentAssessmentYear := GlblThisYear;
              OpenTableForProcessingType(ParcelTable, ParcelTableName,
                                         ThisYear, Quit);
              OpenTableForProcessingType(ParcelEXTable, ExemptionsTableName,
                                         ThisYear, Quit);
              OpenTableForProcessingType(ParcelEXLookupTable, ExemptionsTableName,
                                         ThisYear, Quit);
              OpenTableForProcessingType(ExemptionTable, ExemptionsTableName,
                                         ThisYear, Quit);
              OpenTableForProcessingType(AssessmentTable, AssessmentTableName,
                                         ThisYear, Quit);
              OpenTableForProcessingType(SwisCodeTable, SwisCodeTableName,
                                         ThisYear, Quit);

              AddEXCodesByPropertyClass(Sender, ParcelTable, ParcelEXTable,
                                        ParcelEXLookupTable,
                                        GlblThisYear, NumTYParcelsPrinted);

            end;  {If (AssessmentYear in [ayThisYear, ayBothYears])}

        If (AssessmentYear in [ayNextYear, ayBothYears])
          then
            begin
                {If we already printed ThisYear, go to the next page.}

              If (AssessmentYear = ayBothYears)
                then
                  with Sender as TBaseReport do
                    NewPage;

              CurrentAssessmentYear := GlblNextYear;

              OpenTableForProcessingType(ParcelTable, ParcelTableName,
                                         NextYear, Quit);
              OpenTableForProcessingType(ParcelEXTable, ExemptionsTableName,
                                         NextYear, Quit);
              OpenTableForProcessingType(ParcelEXLookupTable, ExemptionsTableName,
                                         NextYear, Quit);
              OpenTableForProcessingType(ExemptionTable, ExemptionsTableName,
                                         NextYear, Quit);
              OpenTableForProcessingType(AssessmentTable, AssessmentTableName,
                                         NextYear, Quit);
              OpenTableForProcessingType(SwisCodeTable, SwisCodeTableName,
                                         NextYear, Quit);

              AddEXCodesByPropertyClass(Sender, ParcelTable, ParcelEXTable,
                                        ParcelEXLookupTable,
                                        GlblNextYear, NumNYParcelsPrinted);

            end;  {If (AssessmentYear in [ayNextYear, ayBothYears])}

      end;  {bmPropertyClass}

    bmParcelsWithCertainEX :
      begin
          {Add EX to all parcels with a certain EX.}
          {FXX04281998-1: For inserting the new exemptions
                when searching by existing EX, must use diff
                table than search table so position in file
                does not get messed up.}


        If (AssessmentYear in [ayThisYear, ayBothYears])
          then
            begin
              CurrentAssessmentYear := GlblThisYear;
              OpenTableForProcessingType(ParcelTable, ParcelTableName,
                                         ThisYear, Quit);
              OpenTableForProcessingType(ParcelEXTable, ExemptionsTableName,
                                         ThisYear, Quit);
              OpenTableForProcessingType(ParcelEXLookupTable, ExemptionsTableName,
                                         ThisYear, Quit);
              OpenTableForProcessingType(ExemptionTable, ExemptionsTableName,
                                         ThisYear, Quit);
              OpenTableForProcessingType(AssessmentTable, AssessmentTableName,
                                         ThisYear, Quit);
              OpenTableForProcessingType(SwisCodeTable, SwisCodeTableName,
                                         ThisYear, Quit);

              AddEXCodesByPreviousEX(Sender, ParcelTable, ParcelEXTable,
                                     ParcelEXLookupTable,
                                     GlblThisYear, NumTYParcelsPrinted);

            end;  {If (AssessmentYear in [ayThisYear, ayBothYears])}

        If (AssessmentYear in [ayNextYear, ayBothYears])
          then
            begin
                {If we already printed ThisYear, go to the next page.}

              If (AssessmentYear = ayBothYears)
                then
                  with Sender as TBaseReport do
                    NewPage;

              CurrentAssessmentYear := GlblNextYear;

              OpenTableForProcessingType(ParcelTable, ParcelTableName,
                                         NextYear, Quit);
              OpenTableForProcessingType(ParcelEXTable, ExemptionsTableName,
                                         NextYear, Quit);
              OpenTableForProcessingType(ParcelEXLookupTable, ExemptionsTableName,
                                         NextYear, Quit);
              OpenTableForProcessingType(ExemptionTable, ExemptionsTableName,
                                         ThisYear, Quit);
              OpenTableForProcessingType(AssessmentTable, AssessmentTableName,
                                         NextYear, Quit);
              OpenTableForProcessingType(SwisCodeTable, SwisCodeTableName,
                                         NextYear, Quit);

              AddEXCodesByPreviousEX(Sender, ParcelTable, ParcelEXTable,
                                     ParcelEXLookupTable,
                                     GlblNextYear, NumNYParcelsPrinted);

            end;  {If (AssessmentYear in [ayNextYear, ayBothYears])}

      end;  {bmParcelsWithCertainEX}

    bmReplaceExemption :
      begin
          {Add EX to all parcels with a certain EX.}
          {FXX04281998-1: For inserting the new exemptions
                when searching by existing EX, must use diff
                table than search table so position in file
                does not get messed up.}


        If (AssessmentYear in [ayThisYear, ayBothYears])
          then
            begin
              CurrentAssessmentYear := GlblThisYear;
              OpenTableForProcessingType(ParcelTable, ParcelTableName,
                                         ThisYear, Quit);
              OpenTableForProcessingType(ParcelEXTable, ExemptionsTableName,
                                         ThisYear, Quit);
              OpenTableForProcessingType(ParcelEXLookupTable, ExemptionsTableName,
                                         ThisYear, Quit);
              OpenTableForProcessingType(ExemptionTable, ExemptionsTableName,
                                         ThisYear, Quit);
              OpenTableForProcessingType(AssessmentTable, AssessmentTableName,
                                         ThisYear, Quit);
              OpenTableForProcessingType(SwisCodeTable, SwisCodeTableName,
                                         ThisYear, Quit);

              ReplaceExemption(Sender, ParcelTable, ParcelEXTable,
                               ParcelEXLookupTable,
                               GlblThisYear, NumTYParcelsPrinted);

            end;  {If (AssessmentYear in [ayThisYear, ayBothYears])}

        If (AssessmentYear in [ayNextYear, ayBothYears])
          then
            begin
                {If we already printed ThisYear, go to the next page.}

              If (AssessmentYear = ayBothYears)
                then
                  with Sender as TBaseReport do
                    NewPage;

              CurrentAssessmentYear := GlblNextYear;

              OpenTableForProcessingType(ParcelTable, ParcelTableName,
                                         NextYear, Quit);
              OpenTableForProcessingType(ParcelEXTable, ExemptionsTableName,
                                         NextYear, Quit);
              OpenTableForProcessingType(ParcelEXLookupTable, ExemptionsTableName,
                                         NextYear, Quit);
              OpenTableForProcessingType(ExemptionTable, ExemptionsTableName,
                                         ThisYear, Quit);
              OpenTableForProcessingType(AssessmentTable, AssessmentTableName,
                                         NextYear, Quit);
              OpenTableForProcessingType(SwisCodeTable, SwisCodeTableName,
                                         NextYear, Quit);

              ReplaceExemption(Sender, ParcelTable, ParcelEXTable,
                               ParcelEXLookupTable,
                               GlblNextYear, NumNYParcelsPrinted);

            end;  {If (AssessmentYear in [ayNextYear, ayBothYears])}

      end;  {bmReplaceExemption}

    bmDeleteExemptionByParcelList :
      begin
        If (AssessmentYear in [ayThisYear, ayBothYears])
          then
            begin
              CurrentAssessmentYear := GlblThisYear;
              OpenTableForProcessingType(ParcelTable, ParcelTableName,
                                         ThisYear, Quit);
              OpenTableForProcessingType(ParcelEXTable, ExemptionsTableName,
                                         ThisYear, Quit);
              OpenTableForProcessingType(ParcelEXLookupTable, ExemptionsTableName,
                                         ThisYear, Quit);
              OpenTableForProcessingType(ExemptionTable, ExemptionsTableName,
                                         ThisYear, Quit);
              OpenTableForProcessingType(AssessmentTable, AssessmentTableName,
                                         ThisYear, Quit);
              OpenTableForProcessingType(SwisCodeTable, SwisCodeTableName,
                                         ThisYear, Quit);
              OpenTableForProcessingType(tbExemptionDenials, ExemptionsDenialTableName,
                                         ThisYear, Quit);

              DeleteEXCodeByParcelList(Sender, ParcelTable, ParcelEXTable,
                                       ParcelEXLookupTable, tbExemptionDenials, tbRemovedExemptions,
                                       GlblThisYear, TemplateEXCode, sDenialMessage,
                                       bCreateDenialRecord, TrialRun,
                                       NumTYParcelsPrinted);

            end;  {If (AssessmentYear in [ayThisYear, ayBothYears])}

        If (AssessmentYear in [ayNextYear, ayBothYears])
          then
            begin
                {If we already printed ThisYear, go to the next page.}

              CurrentAssessmentYear := GlblNextYear;
              If (AssessmentYear = ayBothYears)
                then
                  with Sender as TBaseReport do
                    NewPage;

              OpenTableForProcessingType(ParcelTable, ParcelTableName,
                                         NextYear, Quit);
              OpenTableForProcessingType(ParcelEXTable, ExemptionsTableName,
                                         NextYear, Quit);
              OpenTableForProcessingType(ParcelEXLookupTable, ExemptionsTableName,
                                         NextYear, Quit);
              OpenTableForProcessingType(ExemptionTable, ExemptionsTableName,
                                         ThisYear, Quit);
              OpenTableForProcessingType(AssessmentTable, AssessmentTableName,
                                         NextYear, Quit);
              OpenTableForProcessingType(SwisCodeTable, SwisCodeTableName,
                                         NextYear, Quit);
              OpenTableForProcessingType(tbExemptionDenials, ExemptionsDenialTableName,
                                         NextYear, Quit);

              DeleteEXCodeByParcelList(Sender, ParcelTable, ParcelEXTable,
                                       ParcelEXLookupTable, tbExemptionDenials, tbRemovedExemptions,
                                       GlblNextYear, TemplateEXCode, sDenialMessage,
                                       bCreateDenialRecord, TrialRun,
                                       NumNYParcelsPrinted);

            end;  {If (AssessmentYear in [ayNextYear, ayBothYears])}

      end;  {bmDeleteExemptionByParcelList}

      {FXX06171998-1: Add option to import from file.}

    bmImportFile :
      begin
          {Add EX to all the parcels in the swis code that they
           choose.}

        If (AssessmentYear in [ayThisYear, ayBothYears])
          then
            begin
              CurrentAssessmentYear := GlblThisYear;
              OpenTableForProcessingType(ParcelTable, ParcelTableName,
                                         ThisYear, Quit);
              OpenTableForProcessingType(ParcelEXTable, ExemptionsTableName,
                                         ThisYear, Quit);
              OpenTableForProcessingType(ParcelEXLookupTable, ExemptionsTableName,
                                         ThisYear, Quit);
              OpenTableForProcessingType(ExemptionTable, ExemptionsTableName,
                                         ThisYear, Quit);
              OpenTableForProcessingType(AssessmentTable, AssessmentTableName,
                                         ThisYear, Quit);
              OpenTableForProcessingType(SwisCodeTable, SwisCodeTableName,
                                         ThisYear, Quit);

              AddEXCodesByImportFile(Sender, ParcelTable, ParcelEXTable,
                                     ParcelEXLookupTable,
                                     GlblThisYear, NumTYParcelsPrinted);

            end;  {If (AssessmentYear in [ayThisYear, ayBothYears])}

        If (AssessmentYear in [ayNextYear, ayBothYears])
          then
            begin
                {If we already printed ThisYear, go to the next page.}

              If (AssessmentYear = ayBothYears)
                then
                  with Sender as TBaseReport do
                    NewPage;

              CurrentAssessmentYear := GlblNextYear;

              OpenTableForProcessingType(ParcelTable, ParcelTableName,
                                         NextYear, Quit);
              OpenTableForProcessingType(ParcelEXTable, ExemptionsTableName,
                                         NextYear, Quit);
              OpenTableForProcessingType(ParcelEXLookupTable, ExemptionsTableName,
                                         NextYear, Quit);
              OpenTableForProcessingType(ExemptionTable, ExemptionsTableName,
                                         NextYear, Quit);
              OpenTableForProcessingType(AssessmentTable, AssessmentTableName,
                                         NextYear, Quit);
              OpenTableForProcessingType(SwisCodeTable, SwisCodeTableName,
                                         NextYear, Quit);

              AddEXCodesByImportFile(Sender, ParcelTable, ParcelEXTable,
                                     ParcelEXLookupTable,
                                     GlblNextYear, NumNYParcelsPrinted);

            end;  {If (AssessmentYear in [ayNextYear, ayBothYears])}

      end;  {bmImportFile}

    bmParcelList :
      begin
          {Add EX to all the parcels in the swis code that they
           choose.}

        If (AssessmentYear in [ayThisYear, ayBothYears])
          then
            begin
              CurrentAssessmentYear := GlblThisYear;
              OpenTableForProcessingType(ParcelTable, ParcelTableName,
                                         ThisYear, Quit);
              OpenTableForProcessingType(ParcelEXTable, ExemptionsTableName,
                                         ThisYear, Quit);
              OpenTableForProcessingType(ParcelEXLookupTable, ExemptionsTableName,
                                         ThisYear, Quit);
              OpenTableForProcessingType(ExemptionTable, ExemptionsTableName,
                                         ThisYear, Quit);
              OpenTableForProcessingType(AssessmentTable, AssessmentTableName,
                                         ThisYear, Quit);
              OpenTableForProcessingType(SwisCodeTable, SwisCodeTableName,
                                         ThisYear, Quit);

              AddEXCodesByParcelList(Sender, ParcelTable, ParcelEXTable,
                                     ParcelEXLookupTable,
                                     GlblThisYear, NumTYParcelsPrinted);

            end;  {If (AssessmentYear in [ayThisYear, ayBothYears])}

        If (AssessmentYear in [ayNextYear, ayBothYears])
          then
            begin
                {If we already printed ThisYear, go to the next page.}

              If (AssessmentYear = ayBothYears)
                then
                  with Sender as TBaseReport do
                    NewPage;

              CurrentAssessmentYear := GlblNextYear;

              OpenTableForProcessingType(ParcelTable, ParcelTableName,
                                         NextYear, Quit);
              OpenTableForProcessingType(ParcelEXTable, ExemptionsTableName,
                                         NextYear, Quit);
              OpenTableForProcessingType(ParcelEXLookupTable, ExemptionsTableName,
                                         NextYear, Quit);
              OpenTableForProcessingType(ExemptionTable, ExemptionsTableName,
                                         NextYear, Quit);
              OpenTableForProcessingType(AssessmentTable, AssessmentTableName,
                                         NextYear, Quit);
              OpenTableForProcessingType(SwisCodeTable, SwisCodeTableName,
                                         NextYear, Quit);

              AddEXCodesByParcelList(Sender, ParcelTable, ParcelEXTable,
                                     ParcelEXLookupTable,
                                     GlblNextYear, NumNYParcelsPrinted);

            end;  {If (AssessmentYear in [ayNextYear, ayBothYears])}

      end;  {bmImportFile}

      {CHG12271999-1: Allow delete of exemptions.}

    bmDeleteEX :
      begin
        If (AssessmentYear in [ayThisYear, ayBothYears])
          then
            begin
              CurrentAssessmentYear := GlblThisYear;
              OpenTableForProcessingType(ParcelTable, ParcelTableName,
                                         ThisYear, Quit);
              OpenTableForProcessingType(ParcelEXTable, ExemptionsTableName,
                                         ThisYear, Quit);
              OpenTableForProcessingType(ExemptionTable, ExemptionsTableName,
                                         ThisYear, Quit);
              OpenTableForProcessingType(ParcelEXLookupTable, ExemptionsTableName,
                                         ThisYear, Quit);
              OpenTableForProcessingType(AssessmentTable, AssessmentTableName,
                                         ThisYear, Quit);
              OpenTableForProcessingType(SwisCodeTable, SwisCodeTableName,
                                         ThisYear, Quit);

              DeleteEXCode(Sender, ParcelTable, ParcelEXTable,
                           ParcelEXLookupTable,
                           GlblThisYear, NumTYParcelsPrinted);

            end;  {If (AssessmentYear in [ayThisYear, ayBothYears])}

        If (AssessmentYear in [ayNextYear, ayBothYears])
          then
            begin
                {If we already printed ThisYear, go to the next page.}

              If (AssessmentYear = ayBothYears)
                then
                  with Sender as TBaseReport do
                    NewPage;

              CurrentAssessmentYear := GlblNextYear;

              OpenTableForProcessingType(ParcelTable, ParcelTableName,
                                         NextYear, Quit);
              OpenTableForProcessingType(ParcelEXTable, ExemptionsTableName,
                                         NextYear, Quit);
              OpenTableForProcessingType(ExemptionTable, ExemptionsTableName,
                                         NextYear, Quit);
              OpenTableForProcessingType(ParcelEXLookupTable, ExemptionsTableName,
                                         NextYear, Quit);
              OpenTableForProcessingType(AssessmentTable, AssessmentTableName,
                                         NextYear, Quit);
              OpenTableForProcessingType(SwisCodeTable, SwisCodeTableName,
                                         NextYear, Quit);

              DeleteEXCode(Sender, ParcelTable, ParcelEXTable,
                           ParcelEXLookupTable,
                           GlblNextYear, NumNYParcelsPrinted);

            end;  {If (AssessmentYear in [ayNextYear, ayBothYears])}

      end;  {bmDeleteEX}

  end;  {case BroadcastMethod of}

  If (AssessmentYear in [ayThisYear, ayBothYears])
    then PrintTotalNumPrinted(Sender, GlblThisYear, NumTYParcelsPrinted, BroadcastMethod);

  with Sender as TBaseReport do
    If (LinesLeft < 5)
      then NewPage;

  If (AssessmentYear in [ayNextYear, ayBothYears])
    then PrintTotalNumPrinted(Sender, GlblNextYear, NumNYParcelsPrinted, BroadcastMethod);

end;  {ReportPrint}

{===================================================================}
Procedure TExemptionBroadcastForm.FormClose(    Sender: TObject;
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