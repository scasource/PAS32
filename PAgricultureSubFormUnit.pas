unit PAgricultureSubFormUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Mask, DBCtrls, Grids, Wwdbigrd, Wwdbgrid, Buttons, ExtCtrls,
  ComCtrls, Db, Wwdatsrc, DBTables, Wwtable, wwdblook;

type
  TAgricultureSubform = class(TForm)
    AgriculturePageControl: TPageControl;
    SoilsTabSheet: TTabSheet;
    DetailsTabSheet: TTabSheet;
    Panel5: TPanel;
    Panel6: TPanel;
    gdAgricultureSoils: TwwDBGrid;
    tbAgriculture: TwwTable;
    dsAgricultureSoils: TwwDataSource;
    tbAgricultureSoils: TwwTable;
    btnNewSoil: TBitBtn;
    btnDeleteSoil: TBitBtn;
    Panel2: TPanel;
    tbAgricultureSoilsSoilGroupCode: TStringField;
    tbAgricultureSoilsAgAcreage: TFloatField;
    tbAgricultureSoilsAssessmentPerAcre: TIntegerField;
    tbAgricultureSoilsAssessment: TIntegerField;
    tbSoilRatings: TwwTable;
    dsSoilRatings: TwwDataSource;
    lcbxSoilRating: TwwDBLookupCombo;
    Label3: TLabel;
    edLandValue: TEdit;
    edImprovementValue: TEdit;
    Label1: TLabel;
    edEligibleAcres: TEdit;
    Label2: TLabel;
    edCertifiedAssessment: TEdit;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    edTotalValue: TEdit;
    edTotalHomesteadValue: TEdit;
    edTotalFarmStructureValue: TEdit;
    edTotalOtherStructureValue: TEdit;
    edIneligibleWoodlandsAcreage: TEdit;
    edIneligibleWoodlandsLandValue: TEdit;
    edTotalIneligibleLandValue2: TEdit;
    edTotalIneligibleAcreage: TEdit;
    edTotalIneligibleLandValue: TEdit;
    edTotalIneligibleImprovements: TEdit;
    edTotalIneligibleValue: TEdit;
    edTotalAcres: TEdit;
    edAssessedValueEligible: TEdit;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    edTotalAgricultureAssessment: TEdit;
    Label19: TLabel;
    edTotalAgricultureExemption: TEdit;
    edTotalIneligibleWoodlands: TEdit;
    edResidentialAcreage: TDBEdit;
    dsAgriculture: TDataSource;
    edResidentialLand: TDBEdit;
    edResidentialBuilding: TDBEdit;
    edFarmStructureValue: TDBEdit;
    edOtherStructureValue: TDBEdit;
    edIneligibleAcreage: TDBEdit;
    edIneligibleLand: TDBEdit;
    edAssessedSupportStructure: TDBEdit;
    tbParcel: TTable;
    tbAssess: TTable;
    tbSwis: TTable;
    tbExemption: TwwTable;
    Label20: TLabel;
    edExemption: TEdit;
    btnUpdateExemption: TBitBtn;
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnDeleteSoilClick(Sender: TObject);
    procedure btnNewSoilClick(Sender: TObject);
    procedure tbAgricultureSoilsCalcFields(DataSet: TDataSet);
    procedure AgValueEditExit(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    InitializingForm : Boolean;
    Agriculture_ID, AssessmentYear, SwisSBLKey, Category, UnitName, EditMode : String;
    Procedure InitializeForm(sSwisSBLKey : String;
                             iAgricultureID : Integer;
                             sEditMode : String);
    Procedure LoadAgricultureInformation;
    Function GetEligibleAcreage : Double;
    Function GetCertifiedAssessment : LongInt;
    Procedure DisplaySoilTotals;
  end;

var
  AgricultureSubform: TAgricultureSubform;

implementation

{$R *.DFM}

uses PASUtils, WinUtils, Utilitys, DataAccessUnit, PASTypes, GlblVars, GlblCnst;



{==================================================================}
Procedure TAgricultureSubform.LoadAgricultureInformation;

begin
  _SetRange(tbAgricultureSoils,
            [Agriculture_ID, ''],
            [Agriculture_ID, '999'], '', []);

  _Locate(tbAgriculture, [Agriculture_ID], '', []);

end;  {LoadAgricultureInformation}

{================================================================}
Procedure TAgricultureSubform.DisplaySoilTotals;

var
  iIneligibleValue, iEligibleValue, iCertifiedAssessment,
  iTotalAgricultureAssessment, iTotalAgricultureExemption,
  iIneligibleImprovements  : LongInt;
  dEqualizationRate : Double;

begin
  iCertifiedAssessment := GetCertifiedAssessment;
  dEqualizationRate := tbSwis.FieldByName('EqualizationRate').AsFloat;

  edEligibleAcres.Text := FormatFloat(DecimalDisplay, GetEligibleAcreage);
  edCertifiedAssessment.Text := FormatFloat(IntegerDisplay, iCertifiedAssessment);
  edLandValue.Text := FormatFloat(IntegerDisplay, tbAssess.FieldByName('LandAssessedVal').AsInteger);
  edImprovementValue.Text := FormatFloat(IntegerDisplay, (tbAssess.FieldByName('TotalAssessedVal').AsInteger - tbAssess.FieldByName('LandAssessedVal').AsInteger));
  edIneligibleWoodlandsAcreage.Text := FormatFloat(DecimalDisplay, 0);
  edIneligibleWoodlandsLandValue.Text := FormatFloat(IntegerDisplay, tbAgriculture.FieldByName('Woodland50').AsInteger);

  with tbAgriculture do
  begin
    iIneligibleImprovements := FieldByName('ResidentialBuilding').AsInteger +
                               FieldByName('FarmStructureValue').AsInteger +
                               FieldByName('OtherStructureValue').AsInteger;
    iIneligibleValue := FieldByName('IneligibleLand').AsInteger +
                        iIneligibleImprovements;

  end;

  edTotalIneligibleAcreage.Text := FormatFloat(DecimalDisplay, tbAgriculture.FieldByName('IneligibleAcreage').AsFloat);
  edTotalIneligibleLandValue.Text := FormatFloat(IntegerDisplay, tbAgriculture.FieldByName('IneligibleLand').AsInteger);
  edTotalIneligibleImprovements.Text := FormatFloat(IntegerDisplay, iIneligibleImprovements);
  edTotalAcres.Text := FormatFloat(DecimalDisplay, tbParcel.FieldByName('Acreage').AsFloat);
  edTotalValue.Text := FormatFloat(IntegerDisplay, tbAssess.FieldByName('TotalAssessedVal').AsInteger);
  edTotalHomesteadValue.Text := FormatFloat(IntegerDisplay, tbAgriculture.FieldByName('ResidentialBuilding').AsInteger);
  edTotalFarmStructureValue.Text := FormatFloat(IntegerDisplay, tbAgriculture.FieldByName('FarmStructureValue').AsInteger);
  edTotalOtherStructureValue.Text := FormatFloat(IntegerDisplay, tbAgriculture.FieldByName('OtherStructureValue').AsInteger);
  edTotalIneligibleLandValue2.Text := FormatFloat(IntegerDisplay, tbAgriculture.FieldByName('IneligibleLand').AsInteger);
  edTotalIneligibleWoodlands.Text := FormatFloat(IntegerDisplay, tbAgriculture.FieldByName('Woodland50').AsInteger);

  iEligibleValue := tbAssess.FieldByName('TotalAssessedVal').AsInteger - iIneligibleValue;
  iTotalAgricultureAssessment := Trunc(iCertifiedAssessment  * (dEqualizationRate / 100));
  iTotalAgricultureExemption := iEligibleValue - iTotalAgricultureAssessment;


  edTotalIneligibleValue.Text := FormatFloat(IntegerDisplay, iIneligibleValue);

  edAssessedValueEligible.Text := FormatFloat(IntegerDisplay, iEligibleValue);
  edTotalAgricultureAssessment.Text := FormatFloat(IntegerDisplay, iTotalAgricultureAssessment);
  edTotalAgricultureExemption.Text := FormatFloat(IntegerDisplay, iTotalAgricultureExemption);

end;  {DisplaySoilTotals}

{==================================================================}
Procedure TAgricultureSubform.InitializeForm(sSwisSBLKey : String;
                                             iAgricultureID : Integer;
                                             sEditMode : String);

var
  sAssessmentYear : String;

begin
  WindowState := Application.MainForm.WindowState;

  InitializingForm := True;
  sAssessmentYear := GetTaxRlYr;
  UnitName := 'PAgricultureSubformUnit';
  Caption := 'Agriculture Worksheet (' + ConvertSwisSBLToDashDot(sSwisSBLKey) + ' - ' + sAssessmentYear + ')';

  If (sEditMode = 'V')
    then
      begin
        tbAgriculture.ReadOnly := True;
        tbAgricultureSoils.ReadOnly := True;
        btnNewSoil.Enabled := False;
        btnDeleteSoil.Enabled := False;

      end;  {If (EditMode = 'V')}

  OpenTablesForForm(Self, GlblProcessingType);

  _Locate(tbParcel, [sAssessmentYear, sSwisSBLKey], '', [loParseSwisSBLKey]);
  _Locate(tbAssess, [sAssessmentYear, sSwisSBLKey], '', []);
  _Locate(tbSwis, [Copy(sSwisSBLKey, 1, 6)], '', []);

  edExemption.Text := tbAgriculture.FieldByName('ExemptionCode').AsString;

  InitializingForm := False;
  tbAgricultureSoils.Refresh;

  DisplaySoilTotals;

end;  {InitializeForm}

{================================================================}
Procedure TAgricultureSubform.FormKeyPress(    Sender: TObject;
                                       var Key: Char);

begin
  If (Key = #13)
    then
      begin
        Perform(WM_NextDlgCtl, 0, 0);
        Key := #0;
      end;  {If (Key = #13)}

end;  {FormKeyPress}

{============================================================================}
Function TAgricultureSubform.GetEligibleAcreage : Double;

begin
  Result := 0;

  with tbAgricultureSoils do
  begin
    DisableControls;
    First;

    while not EOF do
    begin
      Result := Result + FieldByName('AgAcreage').AsFloat;
      Next;
    end;

  end;  {with tbAgricultureSoils do}

end;  {GetEligibleAcreage}

{============================================================================}
Function TAgricultureSubform.GetCertifiedAssessment : LongInt;

begin
  Result := 0;

  with tbAgricultureSoils do
  begin
    DisableControls;
    First;

    while not EOF do
    begin
      Result := Result + FieldByName('Assessment').AsInteger;
      Next;
    end;

  end;  {with tbAgricultureSoils do}

end;  {GetCertifiedAssessment}

{============================================================================}
Procedure TAgricultureSubform.tbAgricultureSoilsCalcFields(DataSet: TDataSet);

begin
  If not InitializingForm
    then
      with Dataset as TwwTable do
        begin
          _Locate(tbSoilRatings, [FieldByName('SoilGroupCode').AsString], '', []);

          FieldByName('AssessmentPerAcre').AsInteger := tbSoilRatings.FieldByName('ValuePerAcre').AsInteger;

          FieldByName('Assessment').AsInteger := Trunc(FieldByName('AgAcreage').AsFloat * FieldByName('AssessmentPerAcre').AsInteger);

        end;  {with Sender as TwwTable do}

end;  {tbAgricultureSoilsCalcFields}

{============================================================================}
Procedure TAgricultureSubform.btnNewSoilClick(Sender: TObject);

begin
  tbAgricultureSoils.Append;
end;  {btnNewSoilClick}

{============================================================================}
Procedure TAgricultureSubform.btnDeleteSoilClick(Sender: TObject);

begin
  with tbAgricultureSoils do
    If (MessageDlg('Are you sure you want to delete soil ' +
                   FieldByName('SoilGroupCode').AsString + '?',
                   mtConfirmation, [mbYes, mbNo], 0) = idYes)
      then
        try
          Delete;
          LoadAgricultureInformation;
        except
        end;

end;  {btnDeleteSoilClick}

{============================================================================}
Procedure TAgricultureSubform.FormClose(    Sender: TObject;
                                    var Action: TCloseAction);

begin
  try
    tbAgriculture.Post;
  except
  end;

  CloseTablesForForm(Self);
end;

{============================================================================}
Procedure TAgricultureSubform.AgValueEditExit(Sender: TObject);

begin
  DisplaySoilTotals;
end;

end.
