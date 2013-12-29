unit cdSwisCodesEntry;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Mask, DBCtrls, Db, DBTables, Wwtable, Buttons, ToolWin,
  ComCtrls, ExtCtrls, wwdblook, Wwdatsrc;

type
  TfmSwisCodesEntry = class(TForm)
    gbxSwisCode: TGroupBox;
    MainToolBar: TToolBar;
    btnSave: TSpeedButton;
    btnCancel: TSpeedButton;
    tmrButtonsState: TTimer;
    dsMain: TwwDataSource;
    tbMain: TwwTable;
    tbVeteranLimits: TwwTable;
    tbVeteranLimitsCode: TStringField;
    tbVeteranLimitsEligibleFundsLimit: TIntegerField;
    tbVeteranLimitsBasicVetLimit: TIntegerField;
    tbVeteranLimitsCombatVetLimit: TIntegerField;
    tbVeteranLimitsDisabledVetLimit: TIntegerField;
    tbVeteranLimitsReserved: TStringField;
    MainCodeLabel: TLabel;
    MunNameLabel: TLabel;
    EqualLabel: TLabel;
    ResAssmntLabel: TLabel;
    Label1: TLabel;
    Label3: TLabel;
    Label7: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label4: TLabel;
    edMainCode: TDBEdit;
    edMunicipalName: TDBEdit;
    EditEqualizationRate: TDBEdit;
    EditResidentialAssessmentRatio: TDBEdit;
    EditShortSwisCode: TDBEdit;
    ClassifiedCheckBox: TDBCheckBox;
    MunicipalityLookupCombo: TwwDBLookupCombo;
    EditSplitVillageCode: TDBEdit;
    AssessingVillageCheckBox: TDBCheckBox;
    UniformPercentOfValueEdit: TDBEdit;
    ZipCodeEdit: TDBEdit;
    gbxMunicipalVeteranLimits: TGroupBox;
    DisabledVetLabel: TLabel;
    VetMaxLabel: TLabel;
    CombatVetlbl: TLabel;
    Label21: TLabel;
    edMunicipalDisabledVetLimit: TDBEdit;
    edMunicipalBasicVetLimit: TDBEdit;
    edMunicipalCombatVetLimit: TDBEdit;
    cbxVeteranLimitSet: TwwDBLookupCombo;
    gbxMunicipalColdWarVeteranLimits: TGroupBox;
    Label5: TLabel;
    Label6: TLabel;
    Label2: TLabel;
    Label13: TLabel;
    edDisabledColdWarVeteranLimit: TDBEdit;
    edBasicColdWarVeteranLimit: TDBEdit;
    edColdWarBasicCountyPercent: TDBEdit;
    cbxMunicipalColdWarVeteranLimitCode: TwwDBLookupCombo;
    tbColdWarVeteranLimits: TwwTable;
    dsColdWarVeteranLimits: TwwDataSource;
    tbMunicipalTypes: TwwTable;
    tbSwisCodeLookup: TTable;
    procedure btnSaveClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure tmrButtonsStateTimer(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure tbMainAfterPost(DataSet: TDataSet);
    procedure tbMainAfterEdit(DataSet: TDataSet);
    procedure EditChange(Sender: TObject);
    procedure cbxVeteranLimitSetCloseUp(Sender: TObject; LookupTable,
      FillTable: TDataSet; modified: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
    UnitName : String;
    bInitializingForm, bRecalculate : Boolean;
    fOriginalEqualizationRate, fOriginalUniformPercentOfValue : Double;
    sOriginalVeteransLimitSet, sOriginalColdWarVeteransLimitSet : String;
    slOriginalFieldValues : TStringList;
    lFieldTraceInformationList : TList;

    Procedure InitializeForm(sSwisCode : String;
                             sAssessmentYear : String;
                             sEditMode : String);

    Procedure SetButtonsState(Enabled : Boolean);
  end;

implementation

{$R *.DFM}

uses DataAccessUnit, Utilitys, GlblCnst, WinUtils, GlblVars, UtilExSD, PASUtils,
     PASTypes, Prog;

{=========================================================================}
Procedure TfmSwisCodesEntry.SetButtonsState(Enabled : Boolean);

begin
  btnSave.Enabled := Enabled;
  btnCancel.Enabled := Enabled;
end;  {SetButtonsState}

{=========================================================================}
Procedure TfmSwisCodesEntry.tmrButtonsStateTimer(Sender: TObject);

begin
  (*SetButtonsState(tbMain.Modified); *)
end;  {ButtonsStateTimerTimer}

{=========================================================================}
Procedure TfmSwisCodesEntry.EditChange(Sender: TObject);

{FXX06012008-2(2.13.1.5)[1273]: Better button highlighting.}

begin
  If not bInitializingForm
    then SetButtonsState(True);
end;

{=========================================================================}
Procedure TfmSwisCodesEntry.InitializeForm(sSwisCode : String;
                                           sAssessmentYear : String;
                                           sEditMode : String);

begin
  UnitName := 'cdSwisCodesEntry';
  bInitializingForm := True;
  bRecalculate := False;
  slOriginalFieldValues := TStringList.Create;
  lFieldTraceInformationList := TList.Create;

  If _Compare(sEditMode, emBrowse, coEqual)
    then
      begin
        tbMain.ReadOnly := True;
        btnSave.Enabled := False;
      end;

  _OpenTablesForForm(Self, GlblProcessingType, []);

  If _Compare(sEditMode, [emBrowse, emEdit], coEqual)
    then
      begin
        _Locate(tbMain, [sSwisCode], '', []);

        If _Compare(sEditMode, emEdit, coEqual)
          then tbMain.Edit;

        edMainCode.ReadOnly := True;
        ActiveControl := edMunicipalName;

      end
    else
      begin
        fOriginalEqualizationRate := 0;
        fOriginalUniformPercentOfValue := 0;
        sOriginalVeteransLimitSet := '';
        sOriginalColdWarVeteransLimitSet := '';

        _InsertRecord(tbMain, ['TaxRollYr'],
                      [sAssessmentYear], [irSuppressPost]);

        ActiveControl := edMainCode;

      end;  {else of If _Compare(sEditMode, [emBrowse, emEdit], coEqual)}

  _Locate(tbColdWarVeteranLimits, [tbMain.FieldByName('ColdWarVetMunicLimitSet').AsString], '', []);

  gbxSwisCode.Caption := ' Swis Code ' + sSwisCode + ' (' + sAssessmentYear + '): ';

  bInitializingForm := False;
(*  tmrButtonsState.Enabled := True; *)

end;  {InitializeForm}

{==========================================================}
Procedure TfmSwisCodesEntry.FormKeyPress(    Sender: TObject;
                                                      var Key: Char);

begin
  If (Key = #13)
    then
      begin
        Perform(WM_NEXTDLGCTL, 0, 0);
        Key := #0;
      end;

end;  {FormKeyPress}

{==========================================================}
Procedure TfmSwisCodesEntry.btnSaveClick(Sender: TObject);

begin
  try
    tbMain.Post;
    ModalResult := mrOK;
  except
    SystemSupport(1, tbMain, 'Error posting record.', UnitName, GlblErrorDlgBox);
  end;

end;  {btnSaveClick}

{==========================================================}
Procedure TfmSwisCodesEntry.btnCancelClick(Sender: TObject);

begin
  tbMain.Cancel;
  ModalResult := mrCancel;

end;  {btnCancelClick}

{=======================================================================}
Procedure TfmSwisCodesEntry.FormCloseQuery(    Sender: TObject;
                                                        var CanClose: Boolean);

var
  iSelection : Integer;

begin
  CanClose := True;
  If tbMain.Modified
    then
      begin
        iSelection := MessageDlg('Do you want to save the changes?', mtConfirmation, [mbYes, mbNo, mbCancel], 0);

        case iSelection of
          idYes : btnSaveClick(Sender);
          idNo : btnCancelClick(Sender);
          idCancel : CanClose := False;
        end;

      end;  {If tbMain.Modified}

end;  {FormCloseQuery}

{====================================================================}
Procedure TfmSwisCodesEntry.tbMainAfterEdit(DataSet: TDataSet);

var
  I : Integer;

begin
  with tbMain do
    begin
      fOriginalEqualizationRate := FieldByName('EqualizationRate').AsFloat;
      fOriginalUniformPercentOfValue := FieldByName('UniformPercentValue').AsFloat;
      sOriginalVeteransLimitSet := FieldByName('VeteransLimitSet').AsString;
      sOriginalColdWarVeteransLimitSet := FieldByName('ColdWarVetMunicLimitSet').AsString;

    end;  {with tbMain do}

    {CHG07272008-1(2.15.1.1): Add additional auditing.}

  CreateFieldValuesAndLabels(Self, tbMain, lFieldTraceInformationList);

  slOriginalFieldValues.Clear;

  with tbMain do
    For I := 0 to (FieldCount - 1) do
      slOriginalFieldValues.Add(Fields[I].AsString);

end;  {tbMainAfterEdit}

{====================================================================}
Procedure TfmSwisCodesEntry.cbxVeteranLimitSetCloseUp(Sender: TObject;
                                                      LookupTable, FillTable: TDataSet;
                                                      modified: Boolean);

begin
    {FXX05272009-2(2.20.1.1)[D489]: Make sure to update the alternative vet fields on a code change.}
    
  with tbMain do
    try
      FieldByName('EligibleFundsTownMax').AsInteger := tbVeteranLimits.FieldByName('EligibleFundsLimit').AsInteger;
      FieldByName('VeteranTownMax').AsInteger := tbVeteranLimits.FieldByName('BasicVetLimit').AsInteger;
      FieldByName('CombatVetTownMax').AsInteger := tbVeteranLimits.FieldByName('CombatVetLimit').AsInteger;
      FieldByName('DisabledVetTownMax').AsInteger := tbVeteranLimits.FieldByName('DisabledVetLimit').AsInteger;
    except
    end;

end;  {cbxVeteranLimitSetCloseUp}

{====================================================================}
Procedure TfmSwisCodesEntry.tbMainAfterPost(DataSet: TDataSet);

begin
  with tbMain do
    begin
      If (_Compare(fOriginalEqualizationRate, FieldByName('EqualizationRate').AsFloat, coNotEqual) and
          _Compare(RecordCount, 1, coGreaterThan) and
          (MessageDlg('Do you want all swis codes to have this equalization rate?',
                      mtConfirmation, [mbYes, mbNo], 0) = idYes))
        then UpdateFieldForTable(tbSwisCodeLookup, 'EqualizationRate',
                                 FieldByName('EqualizationRate').Text);

      If (_Compare(fOriginalUniformPercentOfValue, FieldByName('UniformPercentValue').AsFloat, coNotEqual) and
          _Compare(RecordCount, 1, coGreaterThan) and
         (MessageDlg('Do you want all swis codes to have this uniform percent of value?',
                     mtConfirmation, [mbYes, mbNo], 0) = idYes))
        then UpdateFieldForTable(tbSwisCodeLookup, 'UniformPercentValue',
                                 FieldByName('UniformPercentValue').Text);

      If (_Compare(sOriginalVeteransLimitSet, FieldByName('VeteransLimitSet').AsString, coNotEqual) and
          _Compare(RecordCount, 1, coGreaterThan) and
         (MessageDlg('Do you want all swis codes to have this alternative veterans limit set?',
                     mtConfirmation, [mbYes, mbNo], 0) = idYes))
        then
          begin
            UpdateFieldForTable(tbSwisCodeLookup, 'VeteransLimitSet',
                                FieldByName('VeteransLimitSet').AsString);
            UpdateFieldForTable(tbSwisCodeLookup, 'EligibleFundsTownMax',
                                FieldByName('EligibleFundsTownMax').AsString);
            UpdateFieldForTable(tbSwisCodeLookup, 'VeteranTownMax',
                                FieldByName('VeteranTownMax').AsString);
            UpdateFieldForTable(tbSwisCodeLookup, 'CombatVetTownMax',
                                FieldByName('CombatVetTownMax').AsString);
            UpdateFieldForTable(tbSwisCodeLookup, 'DisabledVetTownMax',
                                FieldByName('DisabledVetTownMax').AsString);

          end;

      If (_Compare(sOriginalColdWarVeteransLimitSet, FieldByName('ColdWarVetMunicLimitSet').AsString, coNotEqual) and
          _Compare(RecordCount, 1, coGreaterThan) and
         (MessageDlg('Do you want all swis codes to have this Cold War veterans limit set?',
                     mtConfirmation, [mbYes, mbNo], 0) = idYes))
        then UpdateFieldForTable(tbSwisCodeLookup, 'ColdWarVetMunicLimitSet',
                                 FieldByName('ColdWarVetMunicLimitSet').AsString);

        {FXX06012008-1(2.13.1.5)[1272]: The following If statement was incorrect.}

      If (_Compare(fOriginalEqualizationRate, FieldByName('EqualizationRate').AsFloat, coNotEqual) or
          _Compare(sOriginalVeteransLimitSet, FieldByName('VeteransLimitSet').AsString, coNotEqual) or
          _Compare(sOriginalColdWarVeteransLimitSet, FieldByName('ColdWarVetMunicLimitSet').AsString, coNotEqual))
        then
          If (MessageDlg('The exemptions and roll totals must be recalculated due' + #13 +
                        'to a change in equalization rate or veteran''s limit.' + #13 +
                        'Do you want to recalculate now?' + #13 +
                        'If you do not, you will need to do it manually later.',
                        mtConfirmation, [mbYes, mbNo], 0) = idYes)
            then bRecalculate := True
            else AddToTraceFile('', 'Swis Code',
                                'Recalculate?', 'EX Recalculate', 'Denied', Time,
                                tbMain);

    end;  {with tbMain do}

    {CHG07272008-1(2.15.1.1): Add additional auditing.}

  RecordChanges(Self, 'Swis Code', tbMain, tbMain.FieldByName('SwisCode').AsString,
                lFieldTraceInformationList);
    
  FreeTList(lFieldTraceInformationList, SizeOf(FieldTraceInformationRecord));
  slOriginalFieldValues.Free;

  Close;

end;  {tbMainAfterPost}

end.
