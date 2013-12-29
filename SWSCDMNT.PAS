unit Swscdmnt;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, ExtCtrls, Menus, Mask, DBCtrls,
  Wwkeycb, DB, DBTables, Wwtable, Wwdatsrc, Printrng, Btrvdlg, Grids,
  DBGrids, DBLookup, RPBase, RPCanvas, RPrinter, Wwdbigrd, Wwdbgrid,
  TabNotBk, RPDefine, RPFiler, DBIProcs, wwdblook, Prog, Types;

type
  TSwisCodeMaintForm = class(TForm)
    Panel1: TPanel;
    TitleLabel: TLabel;
    MainDataSource: TwwDataSource;
    PrintRangeDlg: TPrintRangeDlg;
    LookupTable: TwwTable;
    ReportPrinter: TReportPrinter;
    ReportFiler: TReportFiler;
    YearLabel: TLabel;
    Panel2: TPanel;
    ScrollBox1: TScrollBox;
    MainCodeLabel: TLabel;
    MunNameLabel: TLabel;
    EqualLabel: TLabel;
    ResAssmntLabel: TLabel;
    Label1: TLabel;
    DisabledVetLabel: TLabel;
    VetMaxLabel: TLabel;
    CombatVetlbl: TLabel;
    Label2: TLabel;
    PctLabel: TLabel;
    Label5: TLabel;
    Label3: TLabel;
    Label7: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    DBNavigator: TDBNavigator;
    InsertButton: TBitBtn;
    DeleteButton: TBitBtn;
    PrintButton: TBitBtn;
    SaveButton: TBitBtn;
    ExitButton: TBitBtn;
    MainCodeEdit: TDBEdit;
    RefreshButton: TBitBtn;
    LookupGrid: TDBGrid;
    MunicipalName: TDBEdit;
    EditEqualizationRate: TDBEdit;
    EditResidentialAssessmentRatio: TDBEdit;
    EditShortSwisCode: TDBEdit;
    EditDisabledVetTownCityMax: TDBEdit;
    EditVetTownCityMax: TDBEdit;
    EditCombatVetTownCityMax: TDBEdit;
    CombatPctDBEdit: TDBEdit;
    VetPectDBEdit: TDBEdit;
    ClassifiedCheckBox: TDBCheckBox;
    MunicipalityLookupCombo: TwwDBLookupCombo;
    EditSplitVillageCode: TDBEdit;
    AssessingVillageCheckBox: TDBCheckBox;
    MunicLookupTable: TwwTable;
    Label11: TLabel;
    UniformPercentOfValueEdit: TDBEdit;
    Label8: TLabel;
    VeteransMaximumLookupComboBox: TwwDBLookupCombo;
    VeteransLimitTable: TwwTable;
    MainTable: TwwTable;
    MainTableSWISShortCode: TStringField;
    MainTableMunicipalityName: TStringField;
    MainTableEqualizationRate: TFloatField;
    MainTableResAssmntRatio: TFloatField;
    MainTableFloorEqualRate: TFloatField;
    MainTableVeteransLimitSet: TStringField;
    MainTableEligibleFundsTownMax: TIntegerField;
    MainTableVeteranTownMax: TIntegerField;
    MainTableCombatVetTownMax: TIntegerField;
    MainTableDisabledVetTownMax: TIntegerField;
    MainTableVeteranCalcPercent: TFloatField;
    MainTableCombatVetCalcPercent: TFloatField;
    MainTableMunicipalTypeCode: TStringField;
    MainTableMunicipalTypeDesc: TStringField;
    MainTableAssessingVillage: TBooleanField;
    MainTableClassified: TBooleanField;
    MainTableSplitVillageCode: TStringField;
    MainTableUniformPercentValue: TFloatField;
    MainTableReserved: TStringField;
    LookupTableSWISShortCode: TStringField;
    LookupTableMunicipalityName: TStringField;
    LookupTableEqualizationRate: TFloatField;
    LookupTableResAssmntRatio: TFloatField;
    LookupTableFloorEqualRate: TFloatField;
    LookupTableVeteransLimitSet: TStringField;
    LookupTableEligibleFundsTownMax: TIntegerField;
    LookupTableVeteranTownMax: TIntegerField;
    LookupTableCombatVetTownMax: TIntegerField;
    LookupTableDisabledVetTownMax: TIntegerField;
    LookupTableVeteranCalcPercent: TFloatField;
    LookupTableCombatVetCalcPercent: TFloatField;
    LookupTableMunicipalTypeCode: TStringField;
    LookupTableMunicipalTypeDesc: TStringField;
    LookupTableAssessingVillage: TBooleanField;
    LookupTableClassified: TBooleanField;
    LookupTableSplitVillageCode: TStringField;
    LookupTableUniformPercentValue: TFloatField;
    LookupTableReserved: TStringField;
    VeteransLimitTableCode: TStringField;
    VeteransLimitTableEligibleFundsLimit: TIntegerField;
    VeteransLimitTableBasicVetLimit: TIntegerField;
    VeteransLimitTableCombatVetLimit: TIntegerField;
    VeteransLimitTableDisabledVetLimit: TIntegerField;
    VeteransLimitTableReserved: TStringField;
    MainTableTaxRollYr: TStringField;
    MainTableSwisCode: TStringField;
    LookupTableTaxRollYr: TStringField;
    LookupTableSwisCode: TStringField;
    Label4: TLabel;
    ZipCodeEdit: TDBEdit;
    MainTableZipCode: TStringField;
    procedure InsertButtonClick(Sender: TObject);
    procedure DeleteButtonClick(Sender: TObject);
    procedure PrintButtonClick(Sender: TObject);
    procedure SaveButtonClick(Sender: TObject);
    procedure ExitButtonClick(Sender: TObject);
    procedure MainCodeEditExit(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure RefreshButtonClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure MainTableBeforePost(DataSet: TDataset);
    procedure ReportPrinterPrintHeader(Sender: TObject);
    procedure MainTableAfterPost(DataSet: TDataset);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure MunicipalityLookupComboChange(Sender: TObject);
    procedure EditEqualizationRateExit(Sender: TObject);
    procedure ReportPrinterPrint(Sender: TObject);
    procedure VeteransMaximumLookupComboBoxChange(Sender: TObject);
    procedure MainTableBeforeEdit(DataSet: TDataset);
    procedure FormActivate(Sender: TObject);

  private
    UnitName : String; {For error dialog box}
    Inserting : Boolean;  {Are we presently in insert mode?}
    FormIsInitializing, ClosingForm : Boolean;
    CancelledPost : Boolean;  {Did they answer cancel to the
                               'Do you want to post question?'}
    OriginalUniformPercentOfValue,
    OriginalEqualizationRate : Extended;
    OriginalVeteransSet : String;

  public
    FormAccessRights : Integer; {Read only or read write, based on security level?}
                                {Values = raReadOnly, raReadWrite}
    procedure InitializeForm;  {Open the tables.}
    Procedure PrintOneEntry(Sender : TObject);
    {Print the information for one swis code entry.}

  end;

implementation

{$R *.DFM}

uses
  Preview,   {Print preview form}
  Utilitys,  {General utilities}
  GlblVars,  {Global variables}
  GlblCnst,
  RTCalcul,  {Recalculate roll totals.}
  PASUTILS, UTILEXSD,   {PAS specific utilites}
  WinUtils;  {Windows specific utilities}

{======================================================================}
Procedure TSwisCodeMaintForm.FormActivate(Sender: TObject);

begin
  SetFormStateMaximized(Self);
end;

{======================================================================}
Procedure TSwisCodeMaintForm.InitializeForm;

{Open the tables.}

begin
  ClosingForm := False;
  UnitName := 'SWSCDMNT.PAS';  {mmm}
  FormIsInitializing := True;

    {If this is the history file, or they do not have read access,
     then we want to set the files to read only.
     We also want to set a filter to only include the year
     that they have selected for history.}

  If not ModifyAccessAllowed(FormAccessRights)
    then
      begin
        MainTable.ReadOnly := True;
        InsertButton.Enabled := False;
        DeleteButton.Enabled := False;
        SaveButton.Enabled := False;
        RefreshButton.Enabled := False;

      end;  {If not ModifyAccessAllowed(FormAccessRights)}

  OpenTablesForForm(Self, GlblProcessingType);

  If (GlblTaxYearFlg = 'H')
    then
      begin
        SetRangeForHistoryTaxYear(MainTable, 'TaxRollYr', 'SwisCode');
        SetRangeForHistoryTaxYear(LookupTable, 'TaxRollYr', 'SwisCode');
      end;

    {Set a label in the upper right to indicate if they
     are doing this year, next year, or history.}

  YearLabel.Caption := GetTaxYrLbl;

  Inserting := False;

     {Disable the code edit box. They will only be allowed in
      this field in insert mode.}

  If not MainCodeEdit.ReadOnly
    then
      begin
        MainCodeEdit.ReadOnly := True;
        MainCodeEdit.TabStop := False;
        MainCodeEdit.Color := clBtnFace;
      end;

    {CHG10091997-1: Display blanks for zeroes.}
  SetDisplayFormatForCurrencyFields(Self, False);

     {FXX08061998-1: Set the uniform percent of value format.}
     {FXX10211998-1: Set format for equalization rate and res assmt ratio.}

  MainTableUniformPercentValue.DisplayFormat := DecimalDisplay_BlankZero;
  MainTableEqualizationRate.DisplayFormat := DecimalDisplay_BlankZero;
  MainTableResAssmntRatio.DisplayFormat := DecimalDisplay_BlankZero;
  FormIsInitializing := False;

end;  {InitializeForm}

{===================================================================}
Procedure TSwisCodeMaintForm.FormKeyPress(Sender: TObject;
                                        var Key: Char);

{Change carriage return into tab.}

begin
  If (Key = #13)
    then
      begin
        Perform(WM_NextDlgCtl, 0, 0);
        Key := #0;
      end;  {If (Key = #13)}

end;  {FormKeyPress}

{===================================================================}
Procedure TSwisCodeMaintForm.MainTableBeforeEdit(DataSet: TDataset);

{FXX11191999-2: Automatically recalculate exemptions and roll totals if needed.}

begin
  OriginalEqualizationRate := MainTable.FieldByName('EqualizationRate').AsFloat;
  OriginalVeteransSet := MainTable.FieldByName('VeteransLimitSet').Text;

    {CHG04032001-3: If they change eq rate or uniform % of value,
                    broadcast to all swis codes.}

  OriginalUniformPercentOfValue := MainTable.FieldByName('UniformPercentValue').AsFloat;

end;  {MainTableBeforeEdit}

{===================================================================}
Procedure TSwisCodeMaintForm.MainTableBeforePost(DataSet: TDataset);

var
  ReturnCode : Integer;

begin
  CancelledPost := False;
  ReturnCode := idYes;

    {Let's ask confirm whether or not they want to save this
     record. The choices are yes, no, and cancel.
     Yes means save and process whatever they just did.
       (i.e. They made some changes and clicked Print. If
             they select yes, save the record and then bring
             up the print dialog box.)

     No means don't save and process whatever they just did.
       (i.e. They made some changes and clicked Print. If
             they select no, don't save the record and then bring
             up the print dialog box.)

     Cancel means don't save this record and cancel whatever
       action they just selected. They will be placed where
       they used to be.
       (i.e. They made some changes and clicked Print. If
             they select cancel, don't save the record and
             put them back in the description edit field.)}

  case MainTable.State of
    dsInsert : ReturnCode := MessageDlg('Do you want to insert Swis code ' +
                                        MainTableSWISCode.Text + '?',
                                        mtConfirmation,
                                        mbYesNoCancel, 0);

    dsEdit : ReturnCode := MessageDlg('Do you want to save Swis code ' +
                                      MainTableSWISCode.Text + '?',
                                      mtConfirmation,
                                      mbYesNoCancel, 0);

  end;  {case MainTable.State of}

    {Test the return code.}

  case ReturnCode of
    idNo : If (MainTable.State = dsInsert)
             then
               begin
                   {In insert mode, we will cancel this record,
                    which throws away this record. Then we will
                    call Cleanup to restore the form to normal
                    state. Finally, we will call Abort to prevent
                    the post.}

                 MainTable.Cancel;
                 (*Abort;*)
               end
             else
               begin
                   {In the edit case, we will call RefreshNoPost
                    which is a procedure in WinUtils which reloads
                    the present record without trying to post first.
                    We do not need to worry about preventing the
                    post from continuing, though, since it will
                    post back the same information now.}

                 RefreshNoPost(MainTable);

               end;  {idNo : If (MainTable.State = dsInsert)}

    idCancel : begin
                   {In the cancel case, we will put them back in
                    the description edit field, and set a var
                    saying that they cancelled the post. We need
                    to set a variable so when the exception is
                    raised by the Abort to prevent post, we can
                    distinguish the exception as being a cancel
                    answer rather than a "no" answer to the
                    "Do you want to post?" question.}

                 MunicipalName.SetFocus;
                 CancelledPost := True;
                 (*Abort;*)
               end;

  end;  {case ReturnCode of}

end;  {MainTableBeforePost}

{===================================================================}
Procedure TSwisCodeMaintForm.MainTableAfterPost(DataSet: TDataset);

{After the post, let's make sure that we set the form back to it's original
 state and reset the vars.}

var
  Quit : Boolean;

begin
  Inserting := False;
  CancelledPost := False;

    {CHG04032001-3: If they change eq rate or uniform % of value,
                    broadcast to all swis codes.}

  If ((Roundoff(OriginalEqualizationRate, 4) <>
       Roundoff(MainTable.FieldByName('EqualizationRate').AsFloat, 4)) and
      (MainTable.RecordCount > 1) and
      (MessageDlg('Do you want all swis codes to have this equalization rate?',
                  mtConfirmation, [mbYes, mbNo], 0) = idYes))
    then UpdateFieldForTable(LookupTable, 'EqualizationRate',
                             MainTable.FieldByName('EqualizationRate').Text);

  If ((Roundoff(OriginalUniformPercentOfValue, 4) <>
       Roundoff(MainTable.FieldByName('UniformPercentValue').AsFloat, 4)) and
      (MainTable.RecordCount > 1) and
      (MessageDlg('Do you want all swis codes to have this uniform percent of value?',
                  mtConfirmation, [mbYes, mbNo], 0) = idYes))
    then UpdateFieldForTable(LookupTable, 'UniformPercentValue',
                             MainTable.FieldByName('UniformPercentValue').Text);

  MainTable.Refresh;

    {FXX11191999-2: Automatically recalculate exemptions and roll totals if needed.}

  If ((Roundoff(OriginalEqualizationRate, 4) <>
       Roundoff(MainTable.FieldByName('EqualizationRate').AsFloat, 4)) or
      (Take(1, OriginalVeteransSet) <>
       Take(1, MainTable.FieldByName('VeteransLimitSet').Text)))
    then
      If (MessageDlg('The exemptions and roll totals must be recalculated due' + #13 +
                     'to a change in equalization rate or veteran''s limit.' + #13 +
                     'Do you want to recalculate now?' + #13 +
                     'If you do not, you will need to do it manually later.',
                     mtConfirmation, [mbYes, mbNo], 0) = idYes)
        then
          begin
            ProgressDialog.Start(1, False, False);
            RecalculateAllExemptions(Self, ProgressDialog,
                                     GlblProcessingType, GetTaxRlYr, True, Quit);
            CreateRollTotals(GlblProcessingType, GetTaxRlYr, ProgressDialog, Self,
                             False, True);

          end;  {If (MessageDlg('The exemptions ...}

end;  {MainTableAfterPost}

{===================================================================}
Procedure TSwisCodeMaintForm.MainCodeEditExit(Sender: TObject);

{They just entered a new main code, so let's make sure that it does
 not already exist in the file.}

var
  Found : Boolean;
  TempStr : String;

begin
  TempStr := (Sender as TComponent).Name;

  If ((ActiveControl.Name <> 'ExitButton') and
      (ActiveControl.Name <> 'InsertButton') and
      (ActiveControl.Name <> 'RefreshButton') and
      (MainTable.State = dsInsert))
    then
      If (Deblank(MainCodeEdit.Text) = '')
        then
          begin
            MessageDlg('Please enter a swis code.', mtError, [mbOK], 0);
            MainCodeEdit.SetFocus;
          end
        else
          begin
            Found := False;

            try
              Found := FindKeyOld(LookupTable, ['SWISCode'], [MainCodeEdit.Text]);
            except
              If (GetBtrieveError(LookupTable) <> BRC_EndOfFile)
                then SystemSupport(002 ,MainTable, 'Error looking up swis ' +
                                   ' table record.', UnitName, GlblErrorDlgBox);
            end;

            If Found
              then
                begin
                  MessageDlg('Swis code ' + MainCodeEdit.Text +
                             ' already exists.' + #13 +
                             'Please enter a different code.', mtError, [mbOK], 0);
                  MainCodeEdit.SetFocus;
                  (*Abort;*)
                end
              else
                begin
                     {Do a take to make sure it is the
                      correct length, and a shift right add zeroes
                      if we need it.}

                   with MainTableSWISCode do
                     begin
                       Text := Take(Size, Text);
                       Text := ShiftRightAddZeroes(Text);

                     end;  {with MainTableSWISSwisCode do}

                end;  {else of If Found}

          end;  {else of If (Deblank(MainCodeEdit.Text) = '')}

end;  {MainCodeEditExit}

{===================================================================}
Procedure TSwisCodeMaintForm.MunicipalityLookupComboChange(Sender: TObject);

{Make sure that the code and description are synched up.}

begin
  If ((not FormIsInitializing) and
      (MainTable.State in [dsEdit, dsInsert]))
    then MainTable.FieldByName('MunicipalTypeCode').Text := MunicLookupTable.FieldByName('MainCode').Text;

end;  {MunicipalityLookupComboChange}

{===================================================================}
Procedure TSwisCodeMaintForm.EditEqualizationRateExit(Sender: TObject);

{Make sure to roundoff the rate.}

begin
  MainTableEqualizationRate.AsFloat := Roundoff(MainTableEqualizationRate.AsFloat, 3);
end;  {EditEqualizationRateExit}

{=======================================================================}
Procedure TSwisCodeMaintForm.VeteransMaximumLookupComboBoxChange(Sender: TObject);

{FXX06241998-1: The veterans maximums need to be at the county and swis level.}
{Set the town limits according to the new vet limit set.}

begin
    {FXX04042001-1: Scrolling among swis codes caused dataset not in edit mode.}
    
  If ((not (FormIsInitializing or ClosingForm)) and
      (MainTable.State in [dsInsert, dsEdit]))
    then
      with MainTable do
        begin
          FieldByName('EligibleFundsTownMax').AsFloat := VeteransLimitTable.FieldByName('EligibleFundsLimit').AsFloat;
          FieldByName('VeteranTownmax').AsFloat := VeteransLimitTable.FieldByName('BasicVetLimit').AsFloat;
          FieldByName('CombatVetTownMax').AsFloat := VeteransLimitTable.FieldByName('CombatVetLimit').AsFloat;
          FieldByName('DisabledVetTownMax').AsFloat := VeteransLimitTable.FieldByName('DisabledVetLimit').AsFloat;

            {FXX04032001-2: Make sure the % gets set.}

          FieldByName('VeteranCalcPercent').AsFloat := 15;
          FieldByName('CombatVetCalcPercent').AsFloat := 25;

        end;  {with VeteransLimitTable, MainTable do}

end;  {VeteransMaximumLookupComboBoxChange}

{===================================================================}
Procedure TSwisCodeMaintForm.InsertButtonClick(Sender: TObject);

{Put the table into insert state. If the table is modified, then save
 the information first.}

var
  Status : Integer;

begin
    {First save any unposted information.}

  If MainTable.Modified
    then
      try
        MainTable.Post;
      except
        If not RecordIsLocked(MainTable)
          then
            begin
              MunicipalName.SetFocus;

                {If the person cancels or says they
                 do not want to post, we can get an exception with
                 an error code 0 or 9, and we want to ignore them.}

              Status := GetBtrieveError(MainTable);

              If ((Status <> BRC_OK) and
                  (Status <> BRC_EndOfFile))
                then SystemSupport(004, MainTable, 'Error attempting to post.',
                                   UnitName, GlblErrorDlgBox);

            end;  {If RecordIsLocked(MainTable)}

      end;  {except}

    {Set the variable saying that we are now in insert state.}

  Inserting := True;

    {Now insert a new record.}

  try
    MainTable.Append;
  except
    SystemSupport(006, MainTable, 'Error putting Swis ' +
                  ' table in insert state.', UnitName,
                  GlblErrorDlgBox);
  end;

    {Set the tax year.}

  MainTableTaxRollYr.Text := GetTaxRlYr;

    {Make sure that they can get into the main code edit box
     to edit the field.}

  MainCodeEdit.ReadOnly := False;
  MainCodeEdit.TabStop := True;
  MainCodeEdit.Color := clWindow;
  MainCodeEdit.SetFocus;

    {Turn off the delete button.}

  DeleteButton.Enabled := False;

end;  {InsertButtonClick}

{===================================================================}
Procedure TSwisCodeMaintForm.DeleteButtonClick(Sender: TObject);

begin
  If (MessageDlg('Do you want to delete Swis code ' +
                 MainTableSWISCode.Text + '?',
                 mtConfirmation,
                 [mbYes, mbNo], 0) = idYes)
    then
      begin
        try
          MainTable.Delete;
        except
          SystemSupport(007, MainTable, 'Error deleting Swis ' +
                        ' table record.', UnitName, GlblErrorDlgBox);
        end;

      end  {If (MessageDlg('Do you want to delete code ' + ...}
    else MunicipalName.SetFocus;

end;  {DeleteButtonClick}

{===================================================================}
Procedure TSwisCodeMaintForm.PrintButtonClick(Sender: TObject);

var
  NewFileName : String;
  TempFile : File;
  Status : Integer;
  ExceptionRaised : Boolean;

begin
  ExceptionRaised := False;

    {First check to see if they need to post any changes.}

  If MainTable.Modified
    then
      try
        MainTable.Post;
      except
          {If they cancelled the post, then we want to
           make sure that we do not process the print.
           Otherwise, they said no to the post, so we still
           want to print.

           Note that the ReportFiler and ReportPrinter components
           share event handlers, so that a call to the
           execute method of ReportPrinter and ReportFiler both
           execute the same code, and no further direct reference
           to the ReportFiler or ReportPrinter components is
           need after calling their Execute method.}

        If CancelledPost
          then ExceptionRaised := True;

        If not RecordIsLocked(MainTable)
          then
            begin
              MunicipalName.SetFocus;

                {If the person cancels or says they
                 do not want to post, we can get an exception with
                 an error code 0 or 9, and we want to ignore them.}

              Status := GetBtrieveError(MainTable);

              If ((Status <> BRC_OK) and
                  (Status <> BRC_EndOfFile))
                then SystemSupport(008, MainTable, 'Error attempting to post.',
                                   UnitName, GlblErrorDlgBox);

            end;  {If RecordIsLocked(MainTable)}

      end;  {except}

    {Now do the actual printing. To do this, we will first
     execute the print range dialog to let them select the
     range that they want to print and the printer.}

  If not ExceptionRaised
    then
      If PrintRangeDlg.Execute
        then
          begin
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

            If PrintRangeDlg.PreviewPrint
              then
                begin
                  NewFileName := GetPrintFileName(Self.Caption, True);
                  ReportFiler.FileName := NewFileName;

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
                      AssignFile(TempFile, NewFileName);
                      OldDeleteFile(NewFileName);
                    finally
                      {We don't care if it does not get deleted, so we won't put up an
                       error message.}

                      ChDir(GlblProgramDir);
                    end;

                  end;  {If PrintRangeDlg.PreviewPrint}

                end  {They did not select preview, so we will go
                      right to the printer.}
              else ReportPrinter.Execute;

          end  {If PrintRangeDlg.Execute}
        else MunicipalName.SetFocus

    else MunicipalName.SetFocus;

end;  {PrintButtonClick}

{==================================================================================}
Procedure TSwisCodeMaintForm.SaveButtonClick(Sender: TObject);

var
  Status : Integer;

begin
  If MainTable.Modified
    then
      try
        MainTable.Post;
      except
        If not RecordIsLocked(MainTable)
          then
            begin
              MunicipalName.SetFocus;

                {If the person cancels or says they
                 do not want to post, we can get an exception with
                 an error code 0 or 9, and we want to ignore them.}

              Status := GetBtrieveError(MainTable);

              If ((Status <> BRC_OK) and
                  (Status <> BRC_EndOfFile))
                then SystemSupport(009, MainTable, 'Error attempting to post.',
                                   UnitName, GlblErrorDlgBox);

            end;  {If RecordIsLocked(MainTable)}

      end;  {except}

  MunicipalName.SetFocus;

end;  {SaveButtonClick}

{===================================================================}
Procedure TSwisCodeMaintForm.RefreshButtonClick(Sender: TObject);

{Do they want to throw away any changes that they just made. If
 they are in insert mode, this means that the whole record will
 be thrown away.}

var
  ReturnCode : Integer;

begin
  If MainTable.Modified
    then
      begin
        ReturnCode := MessageDlg('Do you want to discard changes to Swis code ' +
                                 MainTableSWISCode.Text + '?',
                                 mtConfirmation,
                                 [mbYes, mbNo], 0);

        case ReturnCode of
          idNo : MunicipalName.SetFocus;

          idYes : begin
                    try
                        {If they are in the middle of an insert, then we just
                         want to cancel what they are doing. Otherwise,
                         we want to refresh without a post
                         (i.e. reload).}

                      If (MainTable.State = dsInsert)
                        then MainTable.Cancel
                        else RefreshNoPost(MainTable);
                    except
                      SystemSupport(010, MainTable, 'Error posting Swis ' +
                                    ' table record.', UnitName,
                                    GlblErrorDlgBox);
                    end;

                  end;  {idYes : begin}

        end;  {case ReturnCode of}

      end;  {If MainTable.Modified}

end;  {RefreshButtonClick}

{===================================================================}
Procedure TSwisCodeMaintForm.ExitButtonClick(Sender: TObject);

begin
  Close;
end;

{===================================================================}
Procedure TSwisCodeMaintForm.FormCloseQuery(    Sender: TObject;
                                            var CanClose: Boolean);

{If there are any changes, let's ask them if they want to save
 them (or cancel).}

var
  Status : Integer;
  CancelClose,
  IgnoreException : Boolean;

begin
  ClosingForm := True;
    {First see if anything needs to be saved. In order to
     determine if there are any changes, we need to sychronize
     the fields with what is in the DB edit boxes. To do this,
     we call the UpdateRecord. Then, if there are any changes,
     the Modified flag will be set to True.}

  If (MainTable.State in [dsInsert, dsEdit])
    then MainTable.UpdateRecord;

  If ((MainTable.State in [dsInsert, dsEdit]) and
      (not MainTable.ReadOnly) and
      MainTable.Modified)
    then
      try
        MainTable.Post;
      except
        If not RecordIsLocked(MainTable)
          then
            begin
              MunicipalName.SetFocus;
              CancelClose := False;
              IgnoreException := False;

                {An exception will be raised in the following
                 cases:
                   1. The person is in insert mode, and they
                      answered "cancel" to "Do you want to post?".
                      In this case, we want to prevent the close.

                   2. The person is in insert mode, and they
                      answered "no" to "Do you want to post?".
                      In this case, we want to ignore the exception
                      and close anyway.

                   3. The person is in edit mode, and they
                      answered "cancel" to "Do you want to post?".
                      In this case, we want to prevent the close.

                    Note that we make use of the variables Inserting
                    and CancelledPost which are set when the person
                    clicks Add and answers "Cancel", respectively.

                    We need the Inserting variable because once the Post
                    is Aborted in either Insert or Edit mode, the state of the
                    table is set to Browse. So, in order to know what state
                    the table was in before the call to post, we need
                    to set this variable.

                    We need the CancelledPost variable because this is the
                    only way we have of knowing if the person answered
                    "Cancel" to "Do you want to post?"}

              Status := GetBtrieveError(MainTable);

              If Inserting
                then
                  If CancelledPost
                    then CancelClose := True  {Case 1}
                    else IgnoreException := True;  {Case 2}

                {Case 3}

              If ((not Inserting) and
                  (Status = BRC_OK))
                then CancelClose := True;

                {If they cancelled the close, then we want to make
                 sure that we do not close (set Action to caNone)
                 and abort out of this exit handler before any
                 of the closes are done.}

              If CancelClose
                then CanClose := False;

                {If we did not set IgnoreException or CancelClose,
                 then this was a real BTrieve error.}

              If not (IgnoreException or CancelClose)
                then SystemSupport(011, MainTable, 'Error attempting to post.',
                                   UnitName, GlblErrorDlgBox);

            end;  {If RecordIsLocked(MainTable)}

      end;  {except}

  ClosingForm := False;

end;  {FormCloseQuery}

{===================================================================}
Procedure TSwisCodeMaintForm.FormClose(    Sender: TObject;
                                       var Action: TCloseAction);

{Note that if we get here, we are definately closing the form
 since the CloseQuery event is called first. In CloseQuery, if
 there are any modifications, they have a chance to cancel
 then.}

begin
  ClosingForm := True;
    {Make sure that we close the tables.}

  CloseTablesForForm(Self);

    {Free up the child window and set the ClosingAForm Boolean to
     true so that we know to delete the tab.}

  Action := caFree;
  GlblClosingAForm := True;
  GlblClosingFormCaption := Caption;
  ClosingForm := False;

end;  {FormClose}

{=============================================================================}
{===============   PRINTING LOGIC  ===========================================}
{=============================================================================}
Procedure TSwisCodeMaintForm.ReportPrinterPrintHeader(Sender: TObject);

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
      SetFont('Arial',16);
      Home;
      CRLF;
      Bold := True;
      PrintCenter('Swis Codes', (PageWidth / 2));
      SetFont('Times New Roman', 10);
      CRLF;

      SectionTop := 1.0;

    end;  {with Sender as TBaseReport do}

end;  {ReportPrinterPrintHeader}

{=============================================================================}
Procedure TSwisCodeMaintForm.PrintOneEntry(Sender : TObject);

{Print the information for one swis code entry.}

begin
  with Sender as TBaseReport do
    begin
      ClearTabs;
      SetPen(clBlack, psSolid, 1, pmCopy); { Set pen to 1 dot width }
      SetTab(0.3, pjLeft, 2.0, 0, BOXLINENONE, 0);    {1st col}
      SetTab(2.5, pjLeft, 2.0, 0, BOXLINENONE, 0);    {2nd col}

      Println(#9 + ConstStr('-', 180));

      Bold := True;
      Print(#9 + 'Swis Code: ' + LookupTableSwisCode.Text);
      Bold := False;
      Println(#9 + 'Short Code: ' + LookupTableSwisShortCode.Text);
      Println(#9 + 'Municipality: ' + RTrim(LookupTableMunicipalityName.Text) +
              #9 + 'Type: ' + RTrim(LookupTableMunicipalTypeDesc.Text));
      Println(#9 + 'Split Village: ' + Take(4, LookupTableSplitVillageCode.Text) +
              #9 + 'Assessing Village: ' + BoolToChar(LookupTableAssessingVillage.AsBoolean));
      Println(#9 + 'Equalization Rate: ' + FormatFloat(ExtendedDecimalDisplay, LookupTableEqualizationRate.AsFloat) +
              #9 + 'Res. Assess. Rate: ' + FormatFloat(ExtendedDecimalDisplay, LookupTableResAssmntRatio.AsFloat));
      Println(#9 + 'Classified: ' + BoolToChar(LookupTableClassified.AsBoolean));
      Println(#9 + 'Uniform % of Value: ' + FormatFloat(ExtendedDecimalDisplay,
                                                        LookupTableUniformPercentValue.AsFloat));

      Println('');

      ClearTabs;

      SetTab(0.5, pjLeft, 2.0, 0, BOXLINENONE, 0);    {Description}
      SetTab(2.6, pjLeft, 1.0, 0, BOXLINENONE, 0);    {City}
      SetTab(7.0, pjLeft, 1.0, 0, BOXLINENONE, 0);    {Percent}

        {Now print the vet limits.}

      Bold := True;
      Underline := True;
      Println(#9 + #9 + 'Town\City' + #9 + 'Percent');
      Bold := False;
      Underline := False;

      Println(#9 + 'Eligible Funds Max:' + #9 +
              FormatFloat(CurrencyNormalDisplay, LookupTableEligibleFundsTownMax.Value));
      Println(#9 + 'Veteran Max:' + #9 +
              FormatFloat(CurrencyNormalDisplay, LookupTableVeteranTownMax.Value) + #9 +
              LookupTableVeteranCalcPercent.Text);
      Println(#9 + 'Combat Veteran Max:' + #9 +
              FormatFloat(CurrencyNormalDisplay, LookupTableCombatVetTownMax.Value) + #9 +
              LookupTableCombatVetCalcPercent.Text);
      Println(#9 + 'Disabled Veteran Max:' + #9 +
              FormatFloat(CurrencyNormalDisplay, LookupTableDisabledVetTownMax.Value));

    end;  {with Sender as TBaseReport do}

end;   {PrintOneEntry}

{=============================================================================}
Procedure TSwisCodeMaintForm.ReportPrinterPrint(Sender: TObject);

var
  FirstTimeThrough, Done, Quit : Boolean;
  NumPrinted : Integer;

begin
  NumPrinted := 0;
  FirstTimeThrough := True;
  Done := False;
  Quit := False;

  try
    LookupTable.First;
  except
    Quit := True;
    SystemSupport(001, LookupTable, 'Error getting first swis code record.',
                  UnitName, GlblErrorDlgBox);
  end;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else
        try
          LookupTable.Next;
        except
          Quit := True;
          SystemSupport(050, LookupTable, 'Error getting next swis code record.',
                        UnitName, GlblErrorDlgBox);
        end;

    If LookupTable.EOF
      then Done := True;

    If not (Done or Quit)
      then
        begin
            {Only print 2 per page, so if this is swis # 3, 5, 7, go to a
             new page first.}

          If ((NumPrinted > 0) and
              ((NumPrinted / 2) = (NumPrinted DIV 2)))
            then
              with Sender as TBaseReport do
                NewPage;

          PrintOneEntry(Sender);
          NumPrinted := NumPrinted + 1;

        end;  {If not (Done or Quit)}

  until (Done or Quit);

end;  {ReportPrinterPrint}





end.
