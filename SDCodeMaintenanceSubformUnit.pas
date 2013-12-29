unit SDCodeMaintenanceSubformUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, DBCtrls, Mask, wwdbedit, Db, Wwdatsrc, DBTables, Wwtable,
  Buttons, wwdblook, Wwdotdot, Wwdbcomb, ToolWin, ComCtrls;

type
  TSpecialDistrictCodeMaintenanceSubform = class(TForm)
    MainGroupBox: TGroupBox;
    SpecialDistrictCodeTable: TwwTable;
    SpecialDistrictDataSource: TwwDataSource;
    Label1: TLabel;
    EditSpecialDistrictCode: TwwDBEdit;
    Label2: TLabel;
    DescriptionEdit: TwwDBEdit;
    OptionsGroupBox: TGroupBox;
    HomesteadCheckBox: TDBCheckBox;
    Section490DBCheckBox: TDBCheckBox;
    AppliesToSchoolDBCheckBox: TDBCheckBox;
    Chapter562CheckBox: TDBCheckBox;
    VolunteerAmbulance_Fire_Exemption_AppliesCheckBox: TDBCheckBox;
    Label3: TLabel;
    DistrictTypeComboBox: TwwDBComboBox;
    ExtensionGroupBox: TGroupBox;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    ExtensionCodeLookupTable: TwwTable;
    ExtensionCodeLookupTableTaxRollYr: TStringField;
    ExtensionCodeLookupTableMainCode: TStringField;
    ExtensionCodeLookupTableDescription: TStringField;
    ExtensionCodeLookupTableCategory: TStringField;
    Label9: TLabel;
    Label10: TLabel;
    ExtensionCode1Lookup: TwwDBLookupCombo;
    ExtensionCode2Lookup: TwwDBLookupCombo;
    ExtensionFlag2Lookup: TwwDBComboBox;
    ExtensionCode3Lookup: TwwDBLookupCombo;
    ExtensionFlag3Lookup: TwwDBComboBox;
    ExtensionCode4Lookup: TwwDBLookupCombo;
    ExtensionFlag4Lookup: TwwDBComboBox;
    ExtensionCode5Lookup: TwwDBLookupCombo;
    ExtensionFlag5Lookup: TwwDBComboBox;
    DefaultsGroupBox: TGroupBox;
    Label11: TLabel;
    Label12: TLabel;
    DefaultUnitsEdit: TwwDBEdit;
    DefaultSecondUnitsEdit: TwwDBEdit;
    StepAmountsGroupBox: TGroupBox;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    StepAmount1Edit: TwwDBEdit;
    StepAmount2Edit: TwwDBEdit;
    StepAmount3Edit: TwwDBEdit;
    OppositeYearSDCodeTable: TTable;
    ExtensionFlag1Lookup: TwwDBComboBox;
    MainToolBar: TToolBar;
    btnSave: TSpeedButton;
    btnCancel: TSpeedButton;
    edExtensionDescription1: TDBEdit;
    tbBillPrintGroup: TTable;
    edExtensionGroupOrder1: TDBEdit;
    Label16: TLabel;
    Label17: TLabel;
    edExtensionDescription2: TDBEdit;
    edExtensionGroupOrder2: TDBEdit;
    edExtensionDescription3: TDBEdit;
    edExtensionGroupOrder3: TDBEdit;
    edExtensionDescription4: TDBEdit;
    edExtensionGroupOrder4: TDBEdit;
    edExtensionDescription5: TDBEdit;
    edExtensionGroupOrder5: TDBEdit;
    Label18: TLabel;
    cbxBillPrintGroup: TwwDBLookupCombo;
    GroupBox1: TGroupBox;
    RollSection9CheckBox: TDBCheckBox;
    Prorata_Omitted_CheckBox: TDBCheckBox;
    LateralDistrictCheckBox: TDBCheckBox;
    OperatingDistrictCheckBox: TDBCheckBox;
    TreatmentDistrictCheckBox: TDBCheckBox;
    FireDistrictCheckBox: TDBCheckBox;
    cbxSewerDistrict: TDBCheckBox;
    cbxSolidWasteDistrict: TDBCheckBox;
    cbxWaterDistrict: TDBCheckBox;
    procedure CancelButtonClick(Sender: TObject);
    procedure SaveButtonClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SpecialDistrictCodeTableNewRecord(DataSet: TDataSet);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure EditChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }

    InsertingCode : Boolean;
    ProcessingType : Integer;
    UnitName, SpecialDistrictCode : String;

    Procedure SetButtonsState(Enabled : Boolean);

    Procedure InitializeForm(_SpecialDistrictCode : String;
                             _ProcessingType : Integer;
                             _ReadOnly : Boolean);

    Procedure CopySpecialDistrictCodeChangeToNextYear;

  end;

var
  SpecialDistrictCodeMaintenanceSubform: TSpecialDistrictCodeMaintenanceSubform;

implementation

{$R *.DFM}

uses WinUtils, PASUtils, Utilitys, GlblCnst, GlblVars, DataAccessUnit;

{=========================================================================}
Procedure TSpecialDistrictCodeMaintenanceSubform.SetButtonsState(Enabled : Boolean);

begin
  btnSave.Enabled := Enabled;
  btnCancel.Enabled := Enabled;
end;  {SetButtonsState}

{=========================================================================}
Procedure TSpecialDistrictCodeMaintenanceSubform.EditChange(Sender: TObject);

begin
  SetButtonsState(True);
end;

{===================================================================}
Procedure TSpecialDistrictCodeMaintenanceSubform.InitializeForm(_SpecialDistrictCode : String;
                                                                _ProcessingType : Integer;
                                                                _ReadOnly : Boolean);

var
  Quit : Boolean;

begin
  UnitName := 'SDCodeMaintenanceSubformUnit';
  SpecialDistrictCode := _SpecialDistrictCode;
  ProcessingType := _ProcessingType;

  If _ReadOnly
    then
      begin
        SpecialDistrictCodeTable.ReadOnly := True;
        btnSave.Enabled := False;
      end;  {If _ReadOnly}

  OpenTablesForForm(Self, ProcessingType);
  OpenTableForProcessingType(OppositeYearSDCodeTable, SdistCodeTableName, NextYear, Quit);

  If _Compare(SpecialDistrictCode, coBlank)
    then
      begin
        InsertingCode := True;
        Caption := 'New Special District';
        MainGroupBox.Caption := ' Enter information for new district: ';
      end
    else
      begin
        InsertingCode := False;
        Caption := 'Special District ' + SpecialDistrictCode;
        MainGroupBox.Caption := 'Edit information for district ' +
                                SpecialDistrictCode + ': ';

      end;  {else of _Compare}

  Caption := Caption + ' (' + GetTaxRollYearForProcessingType(ProcessingType) + ')';

  If InsertingCode
    then
      begin
        SpecialDistrictCodeTable.Insert;
        ActiveControl := EditSpecialDistrictCode;
      end
    else
      begin
        _Locate(SpecialDistrictCodeTable, [SpecialDistrictCode], '', []);
        SpecialDistrictCodeTable.Edit;
        EditSpecialDistrictCode.Enabled := False;
        ActiveControl := DescriptionEdit;

      end;  {If InsertingCode}

end;  {InitializeForm}

{===================================================================}
Procedure TSpecialDistrictCodeMaintenanceSubform.FormKeyPress(    Sender: TObject;
                                                              var Key: Char);

begin
  If (Key = #13)
    then
      begin
        Perform(WM_NEXTDLGCTL, 0, 0);
        Key := #0;
      end;

end;  {FormKeyPress}

{===================================================================}
Procedure TSpecialDistrictCodeMaintenanceSubform.SpecialDistrictCodeTableNewRecord(DataSet: TDataSet);

begin
  SpecialDistrictCodeTable.FieldByName('TaxRollYr').Text := GetTaxRollYearForProcessingType(ProcessingType)
end;

{===================================================================}
Procedure TSpecialDistrictCodeMaintenanceSubform.CancelButtonClick(Sender: TObject);

begin
  If not (SpecialDistrictCodeTable.State in [dsBrowse])
    then
      try
        SpecialDistrictCodeTable.Cancel;
      except
      end;

  ModalResult := mrCancel;

end;  {CancelButtonClick}

{===================================================================}
Procedure TSpecialDistrictCodeMaintenanceSubform.CopySpecialDistrictCodeChangeToNextYear;

var
  TempStr : String;

begin
  If InsertingCode
    then TempStr := 'Do you want this special district to also be on the ' + GlblNextYear + ' roll?'
    else TempStr := 'Do you want this special district code change to appear on the ' + GlblNextYear + ' roll?';

  If (MessageDlg(TempStr, mtConfirmation, [mbYes, mbNo], 0) = idYes)
    then
      begin
        If _Locate(OppositeYearSDCodeTable, [SpecialDistrictCode], '', [])
          then OppositeYearSDCodeTable.Delete;

        CopyTable_OneRecord(SpecialDistrictCodeTable, OppositeYearSDCodeTable, ['TaxRollYr'], [GlblNextYear]);

      end;  {If ((MessageDlg(TempStr ...}

end;  {CopySpecialDistrictCodeChangeToNextYear}

{===================================================================}
Procedure TSpecialDistrictCodeMaintenanceSubform.SaveButtonClick(Sender: TObject);

begin
  with SpecialDistrictCodeTable do
    If _Compare(FieldByName('SDistCode').Text, coBlank)
      then
        begin
          MessageDlg('Please enter a special district code.', mtError, [mbOK], 0);
          EditSpecialDistrictCode.SetFocus;
          Abort;
        end
      else
        If Modified
          then
            begin
              try
                Post;
              except
                SystemSupport(001, SpecialDistrictCodeTable,
                              'Error posting change in SD code table.',
                              UnitName, GlblErrorDlgBox);
              end;

              If (ProcessingType = ThisYear)
                then
                  begin
                    SpecialDistrictCode := FieldByName('SDistCode').Text;
                    CopySpecialDistrictCodeChangeToNextYear;
                  end;

              ModalResult := mrOK;

            end;  {If SpecialDistrictCodeTable.Modified}

end;  {SaveButtonClick}

{============================================================}
Procedure TSpecialDistrictCodeMaintenanceSubform.FormCloseQuery(    Sender: TObject;
                                                                var CanClose: Boolean);

begin
  If SpecialDistrictCodeTable.Modified
    then
      case MessageDlg('Do you want to save your changes?', mtConfirmation, [mbYes, mbNo, mbCancel], 0) of
        idYes : SaveButtonClick(Sender);
        idNo : try
                 SpecialDistrictCodeTable.Cancel;
               except
               end;

        idCancel : Abort;

      end;  {case MessageDlg ...}

end;  {FormCloseQuery}

{================================================================}
Procedure TSpecialDistrictCodeMaintenanceSubform.FormClose(    Sender: TObject;
                                                           var Action: TCloseAction);

begin
  CloseTablesForForm(Self);
end;

end.
