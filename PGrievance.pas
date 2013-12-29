unit PGrievance;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  StdCtrls, ExtCtrls, Forms, Dialogs, DB, Grids, DBGrids,
  DBTables, Mask, DBCtrls, Wwtable, Wwdatsrc, Wwdbcomb, Wwdbigrd, Wwdbgrid,
  Btrvdlg, Types, wwdblook, Buttons, Tabs;

type
  TGrievanceForm = class(TForm)
    MainDataSource: TwwDataSource;
    MainTable: TwwTable;
    Panel1: TPanel;
    TitleLabel: TLabel;
    Panel2: TPanel;
    ParcelDataSource: TDataSource;
    ParcelTable: TTable;
    YearLabel: TLabel;
    InactiveLabel: TLabel;
    Label53: TLabel;
    Label55: TLabel;
    TotalAVLabel: TLabel;
    LandAVLabel: TLabel;
    MainTableTaxRollYr: TStringField;
    MainTableSwisSBLKey: TStringField;
    MainTableGrievanceNumber: TIntegerField;
    MainTableCurrentName1: TStringField;
    MainTableCurrentName2: TStringField;
    MainTableCurrentAddress1: TStringField;
    MainTableCurrentAddress2: TStringField;
    MainTableCurrentStreet: TStringField;
    MainTableCurrentCity: TStringField;
    MainTableCurrentState: TStringField;
    MainTableCurrentZip: TStringField;
    MainTableCurrentZipPlus4: TStringField;
    MainTableLawyerCode: TStringField;
    MainTablePetitName1: TStringField;
    MainTablePetitName2: TStringField;
    MainTablePetitAddress1: TStringField;
    MainTablePetitAddress2: TStringField;
    MainTablePetitStreet: TStringField;
    MainTablePetitCity: TStringField;
    MainTablePetitState: TStringField;
    MainTablePetitZip: TStringField;
    MainTablePetitZipPlus4: TStringField;
    MainTablePetitPhoneNumber: TStringField;
    MainTablePriorLandValue: TIntegerField;
    MainTablePriorTotalValue: TIntegerField;
    MainTableCurrentLandValue: TIntegerField;
    MainTableCurrentTotalValue: TIntegerField;
    MainTableCurrentFullMarketVal: TIntegerField;
    MainTablePetitLandValue: TIntegerField;
    MainTablePetitTotalValue: TIntegerField;
    MainTablePetitFullMarketVal: TIntegerField;
    MainTablePetitAssessedPct: TFloatField;
    MainTablePetitEXClaimed: TStringField;
    MainTablePetitEXAmount: TIntegerField;
    MainTablePetitReason: TStringField;
    MainTablePropertyClassCode: TStringField;
    MainTableOwnershipCode: TStringField;
    MainTableResidentialPercent: TFloatField;
    MainTableRollSection: TStringField;
    MainTableHomesteadCode: TStringField;
    MainTableLegalAddr: TStringField;
    MainTableLegalAddrNo: TStringField;
    MainTableNotes: TMemoField;
    PartialAssessmentLabel: TLabel;
    GrievanceLookupTable: TTable;
    PriorAssessmentTable: TTable;
    CurrentAssessmentTable: TTable;
    SwisCodeTable: TTable;
    CurrentExemptionsTable: TTable;
    CurrentSpecialDistrictsTable: TTable;
    GrievanceExemptionsTable: TTable;
    GrievanceSpecialDistrictsTable: TTable;
    LawyerCodeTable: TTable;
    GrievanceResultsTable: TTable;
    MainTableAppearanceNumber: TIntegerField;
    MainTablePetitSubreasonCode: TStringField;
    MainTablePetitSubreason: TMemoField;
    GrievanceDispositionCodeTable: TTable;
    GrievanceExemptionsAskedTable: TwwTable;
    GrievanceBoardTable: TTable;
    MainTablePreventUpdate: TBooleanField;
    MainTableGrievanceStatus: TStringField;
    MainTableNoHearing: TBooleanField;
    MainTableNoHearingLabel: TStringField;
    MainTableGrievanceNumberDisplay: TStringField;
    RenumberGrievancePanel: TPanel;
    Label1: TLabel;
    CancelButton: TBitBtn;
    OKButton: TBitBtn;
    EditNewGrievanceNumber: TEdit;
    MainTableOldParcelID: TStringField;
    MainTableLegalAddrInt: TIntegerField;
    ParcelLookupTable: TTable;
    AssessmentLookupTable: TTable;
    SwisCodeLookupTable: TTable;
    MainTableAttyName1: TStringField;
    MainTableAttyName2: TStringField;
    MainTableAttyAddress1: TStringField;
    MainTableAttyAddress2: TStringField;
    MainTableAttyStreet: TStringField;
    MainTableAttyCity: TStringField;
    MainTableAttyState: TStringField;
    MainTableAttyZip: TStringField;
    MainTableAttyZipPlus4: TStringField;
    MainTableAttyPhoneNumber: TStringField;
    Panel5: TPanel;
    GrievanceGrid: TwwDBGrid;
    Panel3: TPanel;
    Label7: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    EditLocation: TEdit;
    EditSBL: TMaskEdit;
    EditName: TDBEdit;
    pnl_Buttons: TPanel;
    NewGrievanceButton: TBitBtn;
    DeleteGrievanceButton: TBitBtn;
    RenumberGrievanceButton: TBitBtn;
    CopyGrievanceButton: TBitBtn;
    CloseButton: TBitBtn;

    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CloseButtonClick(Sender: TObject);
    procedure NewGrievanceButtonClick(Sender: TObject);
    procedure GrievanceGridDblClick(Sender: TObject);
    procedure MainTableCalcFields(DataSet: TDataSet);
    procedure DeleteGrievanceButtonClick(Sender: TObject);
    procedure GrievanceGridCalcCellColors(Sender: TObject; Field: TField;
      State: TGridDrawState; Highlight: Boolean; AFont: TFont;
      ABrush: TBrush);
    procedure RenumberGrievanceButtonClick(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject);
    procedure CopyGrievanceButtonClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  public
    { public declarations }
    UnitName : String;  {For use with error dialog box.}

      {These will be set in the ParcelTabForm.}

    EditMode : Char;  {A = Add; M = Modify; V = View}
    TaxRollYr, SwisSBLKey : String;
    GrievanceYear : String;
    iOriginalGridWidth, GrievanceProcessingType : Integer;
    PriorAssessmentFound : Boolean;
    ParcelTabSet : TTabSet;  {The tabs along the bottom. We need them for
                              so that we can refresh the tabs when
                              the first exemption denial or removal is added.}
    TabTypeList : TStringList; {The corresponding tab processing types. "  "   "  "}

    FormIsInitializing : Boolean;  {Is the form being initialized right now?}
    ClosingForm : Boolean;  {Are we closing a form right now?}

    FormAccessRights : Integer;  {Read only or read write, based on security level?}
                                {Values = raReadOnly, raReadWrite}
      {because these routines are placed at the form object def. level,}
      {they have access to all variables on form (no need to Var in)   }
    Procedure InitializeForm;
    Procedure SetRangeForTable(Table : TTable);
      {What is the code table name for this lookup?}

  end;    {end form object definition}

implementation

uses GlblVars, PASTypes, WinUtils, PASUTILS, UTILEXSD,  Utilitys,
     GlblCnst, PGrievanceSubFormUnit, GrievanceAddDialogUnit,
     GrievanceCondoCopyDialogUnit, GrievanceUtilitys;


{$R *.DFM}

{=====================================================================}
Procedure TGrievanceForm.CreateParams(var Params: TCreateParams);

begin
 inherited CreateParams(Params);

  with Params do
    begin
      WndParent := Application.Mainform.Handle;
      Style := (Style or WS_Child) and not WS_Popup;
    end;

end;  {CreateParams}

{========================================================================}
Procedure TGrievanceForm.SetRangeForTable(Table : TTable);

{Now set the range on this table so that it is sychronized to this parcel. Note
 that all segments of the key must be set.}
{mmm4 - Make sure to set range on all keys.}

begin
   {CHG10062002-1: All grievances from any year should display on this page.}

  SetRangeOld(Table, ['SwisSBLKey', 'TaxRollYr', 'GrievanceNumber'],
              [SwisSBLKey, '1950', '0'],
              [SwisSBLKey, '3999', '9999']);

end;  {SetRangeForTable}

{====================================================================}
Procedure TGrievanceForm.InitializeForm;

{This procedure opens the tables for this form and synchronizes
 them to this parcel. Also, we set the title and year
 labels.

 Note that this code is in this seperate procedure rather
 than any of the OnShow events so that we could have
 complete control over when this procedure is run.
 The problem with any of the OnShow events is that when
 the form is created, they are called, but it is not possible to
 have the SwisSBLKey, etc. set.
 This way, we can call InitializeForm after we know that
 the SwisSBLKey, etc. has been set.}

var
  Found, Quit : Boolean;
  SBLRec : SBLRecord;
  PriorProcessingType : Integer;
  PriorYear : String;

begin
  UnitName := 'PGrievancePage';  {mmm1}
  ClosingForm := False;
  FormIsInitializing := True;
  iOriginalGridWidth := GrievanceGrid.Width;

  If (Deblank(SwisSBLKey) <> '')
    then
      begin
          {If this is the history file, or they do not have read access,
           then we want to set the files to read only.}

        If not ModifyAccessAllowed(FormAccessRights)
          then MainTable.ReadOnly := True;

          {If this is inquire let's open it in
           readonly mode. Hist access is blocked at menu level}

        If (EditMode = 'V')
          then MainTable.ReadOnly := True;

        If GlblIsWestchesterCounty
          then
            begin
              GrievanceYear := GlblNextYear;
              PriorYear := GlblThisYear;
              GrievanceProcessingType := NextYear;
              PriorProcessingType := ThisYear;
            end
          else
            begin
              GrievanceYear := GlblThisYear;
              PriorYear := IntToStr(StrToInt(GrievanceYear) - 1);
              GrievanceProcessingType := ThisYear;
              PriorProcessingType := History;
            end;

        OpenTablesForForm(Self, GrievanceProcessingType);

          {First let's find this parcel in the parcel table.}

        SBLRec := ExtractSwisSBLFromSwisSBLKey(SwisSBLKey);

        with SBLRec do
          Found := FindKeyOld(ParcelTable,
                              ['TaxRollYr', 'SwisCode', 'Section',
                               'Subsection', 'Block', 'Lot', 'Sublot',
                               'Suffix'],
                              [GrievanceYear, SwisCode, Section,
                               SubSection, Block, Lot, Sublot, Suffix]);

        If not Found
          then SystemSupport(005, ParcelTable, 'Error finding key in parcel table.', UnitName, GlblErrorDlgBox);

          {Set the range.}

        SetRangeForTable(MainTable);  {This is a method that we have written to avoid having two copies of the setrange.}

          {Also, set the title label to reflect the mode.
           We will then center it in the panel.}

        case EditMode of   {mmm5}
          'A',
          'M' : TitleLabel.Caption := 'Grievance Add\Modify';
          'V' : TitleLabel.Caption := 'Grievance View';
        end;  {case EditMode of}

        TitleLabel.Left := (Panel1.Width - TitleLabel.Width) DIV 2;

          {Note that we will not automatically put them
           in edit mode or insert mode. We will make them
           take that action themselves since even though
           they are in an edit or insert session, they
           may not want to actually make any changes, and
           if they do not, they should not have to cancel.}
          {FXX09282003-3(2.07j): Make sure that read only status is carried through
                                 the grievances.}
          {FXX02022004-2(2.07l): Make sure the copy grievance, etc. button is disabled in view mode.}

        If MainTable.ReadOnly
          then
            begin
              NewGrievanceButton.Enabled := False;
              DeleteGrievanceButton.Enabled := False;
              RenumberGrievanceButton.Enabled := False;
              CopyGrievanceButton.Enabled := False;

            end;  {If MainTable.ReadOnly}

          {Set the location label.}

        EditLocation.Text := GetLegalAddressFromTable(ParcelTable);
        EditSBL.Text := ConvertSwisSBLToDashDot(SwisSBLKey);
        SetTaxYearLabelForProcessingType(YearLabel, GlblProcessingType);

          {FXX12101997-1: Make sure that all pages have the inactive label.}

        If (ParcelTable.FieldByName('ActiveFlag').Text = InactiveParcelFlag)
          then InactiveLabel.Visible := True;

        OpenTableForProcessingType(SwisCodeTable, SwisCodeTableName,
                                   GrievanceProcessingType, Quit);

        OpenTableForProcessingType(CurrentAssessmentTable, AssessmentTableName,
                                   GrievanceProcessingType, Quit);

        OpenTableForProcessingType(PriorAssessmentTable, AssessmentTableName,
                                   PriorProcessingType, Quit);

        OpenTableForProcessingType(CurrentExemptionsTable, ExemptionsTableName,
                                   GrievanceProcessingType, Quit);

        OpenTableForProcessingType(CurrentSpecialDistrictsTable, SpecialDistrictTableName,
                                   GrievanceProcessingType, Quit);

        FindKeyOld(SwisCodeTable, ['SwisCode'], [Copy(SwisSBLKey, 1, 6)]);

        FindKeyOld(CurrentAssessmentTable, ['TaxRollYr', 'SwisSBLKey'],
                   [GrievanceYear, SwisSBLKey]);

        with SBLRec do
          PriorAssessmentFound := FindKeyOld(PriorAssessmentTable,
                                             ['TaxRollYr', 'SwisSBLKey'],
                                             [PriorYear, SwisSBLKey]);

        SetRangeOld(CurrentExemptionsTable, ['TaxRollYr', 'SwisSBLKey'],
                    [GrievanceYear, SwisSBLKey], [GrievanceYear, SwisSBLKey]);

        SetRangeOld(CurrentSpecialDistrictsTable, ['TaxRollYr', 'SwisSBLKey'],
                    [GrievanceYear, SwisSBLKey], [GrievanceYear, SwisSBLKey]);

        TFloatField(MainTable.FieldByName('CurrentTotalValue')).DisplayFormat := CurrencyDisplayNoDollarSign;
        TFloatField(MainTable.FieldByName('CurrentFullMarketVal')).DisplayFormat := CurrencyDisplayNoDollarSign;
        TFloatField(MainTable.FieldByName('PetitTotalValue')).DisplayFormat := CurrencyDisplayNoDollarSign;

      end;  {If (Deblank(SwisSBLKey) <> '')}

    {CHG11162004-7(2.8.0.21): Option to make the close button locate.}

  If GlblCloseButtonIsLocate
    then MakeCloseButtonLocate(CloseButton);

  FormIsInitializing := False;

  MainTable.Refresh;

end;  {InitializeForm}

{==============================================================}
Procedure TGrievanceForm.MainTableCalcFields(DataSet: TDataSet);

var
  StatusStr : String;

begin
  If not FormIsInitializing
    then
      begin
          {CHG10062002-1: All grievances from any year should display on this page.}

        GetGrievanceStatus(MainTable, GrievanceExemptionsAskedTable,
                           GrievanceResultsTable, GrievanceDispositionCodeTable,
                           MainTable.FieldByName('TaxRollYr').Text, SwisSBLKey,
                           False, StatusStr);

        MainTableGrievanceStatus.Text := StatusStr;

        MainTableGrievanceNumberDisplay.Text := GetGrievanceNumberToDisplay(MainTable);

      end;  {If not FormIsInitializing}

end;  {MainTableCalcFields}

{==============================================================}
Procedure TGrievanceForm.GrievanceGridCalcCellColors(Sender: TObject;
                                                     Field: TField;
                                                     State: TGridDrawState;
                                                     Highlight: Boolean;
                                                     AFont: TFont;
                                                     ABrush: TBrush);

begin
  If (Field.FieldName = 'NoHearing')
    then
      begin
        AFont.Color := clRed;
        AFont.Size := 16;
        AFont.Style := [fsBold];
      end;  {If (Field.FieldName = 'NoHearing')}

end;  {GrievanceGridCalcCellColors}

{==============================================================}
Procedure TGrievanceForm.GrievanceGridDblClick(Sender: TObject);

{Go to this grievance in the subform.}

begin
  GlblDialogBoxShowing := True;

  try
    GrievanceSubform := TGrievanceSubform.Create(nil);

    GrievanceSubform.SwisSBLKey := MainTable.FieldByName('SwisSBLKey').Text;
    GrievanceSubform.GrievanceYear := MainTable.FieldByName('TaxRollYr').Text;
    GrievanceSubform.GrievanceNumber := MainTable.FieldByName('GrievanceNumber').AsInteger;
    GrievanceSubform.GrievanceProcessingType := GrievanceProcessingType;

      {FXX09282003-3(2.07j): Make sure that read only status is carried through
                            the grievances.}

    If MainTable.ReadOnly
      then GrievanceSubform.EditMode := 'V'
      else GrievanceSubform.EditMode := EditMode;

    GrievanceSubform.ParcelTabSet := ParcelTabSet;
    GrievanceSubform.TabTypeList := TabTypeList;

    GrievanceSubform.InitializeForm;

    GrievanceSubform.ShowModal;

    MainTable.Refresh;

    with CurrentAssessmentTable do
      begin
        Refresh;
        TotalAVLabel.Caption := FormatFloat(CurrencyNormalDisplay,
                                            FieldByName('TotalAssessedVal').AsFloat);
        LandAVLabel.Caption := FormatFloat(CurrencyNormalDisplay,
                                           FieldByName('LandAssessedVal').AsFloat);

      end;  {with CurrentAssessmentTable do}

  finally
    GrievanceSubform.Free;
  end;

  GlblDialogBoxShowing := False;

end;  {GrievanceGridDblClick}

{==============================================================}
Procedure TGrievanceForm.NewGrievanceButtonClick(Sender: TObject);

var
  GrievanceNumber, TempProcessingType : Integer;
  Continue, InitializationInformationFound, Quit : Boolean;
  TempAssessmentYear,
  EnteredGrievanceYear, LawyerCode : String;
  TempParcelTable, TempAssessmentTable, TempSwisCodeTable : TTable;
  SBLRec : SBLRecord;

begin
  TempParcelTable := nil;
  TempAssessmentTable := nil;
  TempSwisCodeTable := nil;

    {First make sure that there is not already a grievance on this year.}

  SetRangeOld(GrievanceLookupTable, ['TaxRollYr', 'GrievanceNumber'],
              [GrievanceYear, '0'], [GrievanceYear, '99999']);

  GrievanceLookupTable.Last;

  GrievanceNumber := GrievanceLookupTable.FieldByName('GrievanceNumber').AsInteger + 1;

  Continue := True;
  GlblDialogBoxShowing := True;

  try
    GrievanceAddDialog := TGrievanceAddDialog.Create(nil);
    GrievanceAddDialog.GrievanceNumber := GrievanceNumber;
    GrievanceAddDialog.AssessmentYear := GrievanceYear;

    case GrievanceAddDialog.ShowModal of
      idOK :
        begin
          LawyerCode := GrievanceAddDialog.LawyerCode;
          GrievanceNumber := GrievanceAddDialog.GrievanceNumber;
          EnteredGrievanceYear := GrievanceAddDialog.AssessmentYear;
        end;

      idCancel : Continue := False;

    end;  {case GrievanceLawyerCodeDialog.ShowModal of}

  finally
    GrievanceAddDialog.Free;
  end;

  GlblDialogBoxShowing := False;

  If Continue
    then
      begin
        with MainTable do
          try
            Append;
            FieldByName('TaxRollYr').Text := EnteredGrievanceYear;
            FieldByName('GrievanceNumber').AsInteger := GrievanceNumber;
            FieldByName('SwisSBLKey').Text := SwisSBLKey;
            FieldByName('LawyerCode').Text := LawyerCode;

              {CHG10062002-3: Only enter the following information if this is
                              not a history grievance year.}
              {CHG09222003-3(2.07j): Better grievance history entry.}

            InitializationInformationFound := False;

            If (GrievanceYear = EnteredGrievanceYear)
              then
                begin
                  TempParcelTable := ParcelTable;
                  TempAssessmentTable := CurrentAssessmentTable;
                  TempSwisCodeTable := SwisCodeTable;
                  InitializationInformationFound := True;

                end;  {If (GrievanceYear = EnteredGrievanceYear)}

            If not InitializationInformationFound
              then
                begin
                  If (EnteredGrievanceYear = GlblThisYear)
                    then
                      begin
                        TempProcessingType := ThisYear;
                        TempAssessmentYear := GlblThisYear;
                      end
                    else
                      begin
                        TempProcessingType := History;
                        TempAssessmentYear := EnteredGrievanceYear;
                      end;

                  OpenTableForProcessingType(ParcelLookupTable, ParcelTableName,
                                             TempProcessingType, Quit);

                  OpenTableForProcessingType(AssessmentLookupTable, AssessmentTableName,
                                             TempProcessingType, Quit);

                  OpenTableForProcessingType(SwisCodeLookupTable, SwisCodeTableName,
                                             TempProcessingType, Quit);

                  SBLRec := ExtractSwisSBLFromSwisSBLKey(SwisSBLKey);

                  with SBLRec do
                    InitializationInformationFound := FindKeyOld(ParcelLookupTable,
                                                                 ['TaxRollYr', 'SwisCode', 'Section',
                                                                  'Subsection', 'Block', 'Lot', 'Sublot',
                                                                  'Suffix'],
                                                                 [TempAssessmentYear, SwisCode, Section,
                                                                  SubSection, Block, Lot, Sublot, Suffix]);

                  FindKeyOld(AssessmentLookupTable, ['TaxRollYr', 'SwisSBLKey'],
                             [TempAssessmentYear, SwisSBLKey]);

                  FindKeyOld(SwisCodeLookupTable, ['TaxRollYr', 'SwisCode'],
                             [TempAssessmentYear, SBLRec.SwisCode]);

                  TempParcelTable := ParcelLookupTable;
                  TempAssessmentTable := AssessmentLookupTable;
                  TempSwisCodeTable := SwisCodeLookupTable;

                end;  {If not InitializationInformationFound}

            If InitializationInformationFound
              then
                begin
                  FieldByName('CurrentName1').Text := TempParcelTable.FieldByName('Name1').Text;
                  FieldByName('CurrentName2').Text := TempParcelTable.FieldByName('Name2').Text;
                  FieldByName('CurrentAddress1').Text := TempParcelTable.FieldByName('Address1').Text;
                  FieldByName('CurrentAddress2').Text := TempParcelTable.FieldByName('Address2').Text;
                  FieldByName('CurrentStreet').Text := TempParcelTable.FieldByName('Street').Text;
                  FieldByName('CurrentCity').Text := TempParcelTable.FieldByName('City').Text;
                  FieldByName('CurrentState').Text := TempParcelTable.FieldByName('State').Text;
                  FieldByName('CurrentZip').Text := TempParcelTable.FieldByName('Zip').Text;
                  FieldByName('CurrentZipPlus4').Text := TempParcelTable.FieldByName('ZipPlus4').Text;

                    {CHG05252004-1(2.08): Option to have attorney information seperate.}

                  FieldByName('AttyName1').Text := '';
                  FieldByName('AttyName2').Text := '';
                  FieldByName('AttyAddress1').Text := '';
                  FieldByName('AttyAddress2').Text := '';
                  FieldByName('AttyStreet').Text := '';
                  FieldByName('AttyCity').Text := '';
                  FieldByName('AttyState').Text := '';
                  FieldByName('AttyZip').Text := '';
                  FieldByName('AttyZipPlus4').Text := '';

                  If ((Deblank(LawyerCode) = '') or
                      GlblGrievanceSeperateRepresentativeInfo)
                    then
                      begin
                          {They are representing themselves.}

                        FieldByName('PetitName1').Text := TempParcelTable.FieldByName('Name1').Text;
                        FieldByName('PetitName2').Text := TempParcelTable.FieldByName('Name2').Text;
                        FieldByName('PetitAddress1').Text := TempParcelTable.FieldByName('Address1').Text;
                        FieldByName('PetitAddress2').Text := TempParcelTable.FieldByName('Address2').Text;
                        FieldByName('PetitStreet').Text := TempParcelTable.FieldByName('Street').Text;
                        FieldByName('PetitCity').Text := TempParcelTable.FieldByName('City').Text;
                        FieldByName('PetitState').Text := TempParcelTable.FieldByName('State').Text;
                        FieldByName('PetitZip').Text := TempParcelTable.FieldByName('Zip').Text;
                        FieldByName('PetitZipPlus4').Text := TempParcelTable.FieldByName('ZipPlus4').Text;

                      end
                    else SetPetitionerNameAndAddress(MainTable, LawyerCodeTable, LawyerCode);

                  If ((Deblank(LawyerCode) <> '') and
                      GlblGrievanceSeperateRepresentativeInfo)
                    then SetAttorneyNameAndAddress(MainTable, LawyerCodeTable, LawyerCode);

                  FieldByName('PropertyClassCode').Text := TempParcelTable.FieldByName('PropertyClassCode').Text;
                  FieldByName('OwnershipCode').Text := TempParcelTable.FieldByName('OwnershipCode').Text;
                  FieldByName('ResidentialPercent').AsFloat := TempParcelTable.FieldByName('ResidentialPercent').AsFloat;
                  FieldByName('RollSection').Text := TempParcelTable.FieldByName('RollSection').Text;
                  FieldByName('HomesteadCode').Text := TempParcelTable.FieldByName('HomesteadCode').Text;
                  FieldByName('LegalAddr').Text := TempParcelTable.FieldByName('LegalAddr').Text;
                  FieldByName('LegalAddrNo').Text := TempParcelTable.FieldByName('LegalAddrNo').Text;

                    {FXX01162003-3: Need to include the legal address integer.}

                  try
                    FieldByName('LegalAddrInt').AsInteger := TempParcelTable.FieldByName('LegalAddrInt').AsInteger;
                  except
                  end;

                  FieldByName('CurrentLandValue').AsInteger := TempAssessmentTable.FieldByName('LandAssessedVal').AsInteger;
                  FieldByName('CurrentTotalValue').AsInteger := TempAssessmentTable.FieldByName('TotalAssessedVal').AsInteger;
                  FieldByName('CurrentFullMarketVal').AsInteger := Round(ComputeFullValue(TempAssessmentTable.FieldByName('TotalAssessedVal').AsInteger,
                                                                                          TempSwisCodeTable,
                                                                                          TempParcelTable.FieldByName('PropertyClassCode').Text,
                                                                                          TempParcelTable.FieldByName('OwnershipCode').Text,
                                                                                          False));

                    {Don't enter prior values for history grievance entry since there
                     isn't a good way of knowing the AV at the time of grievance.}

                  If ((GrievanceYear = EnteredGrievanceYear) and
                      PriorAssessmentFound)
                    then
                      begin
                        FieldByName('PriorLandValue').AsInteger := PriorAssessmentTable.FieldByName('LandAssessedVal').AsInteger;
                        FieldByName('PriorTotalValue').AsInteger := PriorAssessmentTable.FieldByName('TotalAssessedVal').AsInteger;
                      end;

                  Post;

                    {Don't record EXs or SDs for history grievance entry since there
                     isn't a good way of knowing them at the time of grievance.}

                  If (GrievanceYear = EnteredGrievanceYear)
                    then
                      begin
                        CopyTableRange(CurrentExemptionsTable, GrievanceExemptionsTable,
                                       'TaxRollYr', ['GrievanceNumber'], [IntToStr(GrievanceNumber)]);

                        CopyTableRange(CurrentSpecialDistrictsTable, GrievanceSpecialDistrictsTable,
                                       'TaxRollYr', ['GrievanceNumber'], [IntToStr(GrievanceNumber)]);

                      end;  {If (GrievanceYear = EnteredGrievanceYear)}

                end
              else Post;

            GrievanceGridDblClick(Sender);

          except
            SystemSupport(002, MainTable, 'Error adding grievance # ' + IntToStr(GrievanceNumber) + '.',
                          UnitName, GlblErrorDlgBox);
          end;

      end;  {If Continue}

end;  {NewGrievanceButtonClick}

{==============================================================}
Procedure TGrievanceForm.DeleteGrievanceButtonClick(Sender: TObject);

var
  GrievanceNumber : Integer;
  Continue : Boolean;

begin
  Continue := True;
  GrievanceNumber := MainTable.FieldByName('GrievanceNumber').AsInteger;

    {CHG10062002-2: Don't allow them to delete or renumber grievances from prior years.}
    {CHG09222003-2(2.07j): Allow them to delete prior years, but give an extra warning.}

  If ((MainTable.FieldByName('TaxRollYr').Text <> GrievanceYear) and
      (MessageDlg('Warning!  You are deleting a grievance from a prior year.' + #13 +
                  'Is this correct?', mtWarning, [mbYes, mbNo], 0) = idNo))
    then Continue := False;

  If Continue
    then
      begin
        If (MessageDlg('Are you sure you want to delete grievance ' +
                       GetGrievanceNumberToDisplay(MainTable) + '?',
                       mtConfirmation, [mbYes, mbNo], 0) = idYes)
          then
            begin
              SetRangeOld(GrievanceResultsTable,
                          ['TaxRollYr', 'SwisSBLKey', 'GrievanceNumber', 'ResultNumber'],
                          [MainTable.FieldByName('TaxRollYr').Text, SwisSBLKey, IntToStr(GrievanceNumber), '0'],
                          [MainTable.FieldByName('TaxRollYr').Text, SwisSBLKey, IntToStr(GrievanceNumber), '9999']);

              SetRangeOld(GrievanceBoardTable,
                          ['SwisSBLKey', 'TaxRollYr', 'GrievanceNumber', 'ResultNumber', 'BoardMember'],
                          [SwisSBLKey, MainTable.FieldByName('TaxRollYr').Text, IntToStr(GrievanceNumber),
                           '0', ''],
                          [SwisSBLKey, MainTable.FieldByName('TaxRollYr').Text, IntToStr(GrievanceNumber),
                           '99999', '']);

              SetRangeOld(GrievanceExemptionsAskedTable,
                          ['SwisSBLKey', 'TaxRollYr', 'GrievanceNumber', 'ExemptionCode'],
                          [SwisSBLKey, MainTable.FieldByName('TaxRollYr').Text, IntToStr(GrievanceNumber), '     '],
                          [SwisSBLKey, MainTable.FieldByName('TaxRollYr').Text, IntToStr(GrievanceNumber), '99999']);

              SetRangeOld(GrievanceExemptionsTable,
                          ['SwisSBLKey', 'TaxRollYr', 'GrievanceNumber', 'ExemptionCode'],
                          [SwisSBLKey, MainTable.FieldByName('TaxRollYr').Text, IntToStr(GrievanceNumber), '     '],
                          [SwisSBLKey, MainTable.FieldByName('TaxRollYr').Text, IntToStr(GrievanceNumber), '99999']);

              SetRangeOld(GrievanceSpecialDistrictsTable,
                          ['SwisSBLKey', 'TaxRollYr', 'GrievanceNumber', 'SDistCode'],
                          [SwisSBLKey, MainTable.FieldByName('TaxRollYr').Text, IntToStr(GrievanceNumber), '     '],
                          [SwisSBLKey, MainTable.FieldByName('TaxRollYr').Text, IntToStr(GrievanceNumber), 'ZZZZZ']);

              DeleteTableRange(GrievanceResultsTable);
              DeleteTableRange(GrievanceBoardTable);
              DeleteTableRange(GrievanceExemptionsAskedTable);
              DeleteTableRange(GrievanceExemptionsTable);
              DeleteTableRange(GrievanceSpecialDistrictsTable);

              try
                MainTable.Delete;
              except
                SystemSupport(060, MainTable,
                              'Error deleting grievance ' + IntToStr(GrievanceNumber) + '.',
                              UnitName, GlblErrorDlgBox);
              end;

            end;  {If (MessageDlg ...}

      end;  {If Continue}

end;  {DeleteGrievanceButtonClick}

{==============================================================}
Procedure TGrievanceForm.RenumberGrievanceButtonClick(Sender: TObject);

begin
  RenumberGrievancePanel.Visible := True;
end;

{==============================================================}
Procedure TGrievanceForm.CopyGrievanceButtonClick(Sender: TObject);

{CHG08252003-2(2.07i): Allow them to copy a grievance to multiple parcels.}

begin
  try
    GrievanceCondoCopyDialog := TGrievanceCondoCopyDialog.Create(nil);
    GrievanceCondoCopyDialog.GrievanceNumber := MainTable.FieldByName('GrievanceNumber').AsInteger;
    GrievanceCondoCopyDialog.GrievanceYear := MainTable.FieldByName('TaxRollYr').Text;
    GrievanceCondoCopyDialog.LawyerCode := MainTable.FieldByName('LawyerCode').Text;
    GrievanceCondoCopyDialog.OriginalSwisSBLKey := SwisSBLKey;

    GrievanceCondoCopyDialog.ShowModal;

  finally
    GrievanceCondoCopyDialog.Free;
  end;

end;  {CopyGrievanceButtonClick}

{==============================================================}
Procedure TGrievanceForm.OKButtonClick(Sender: TObject);

var
  NewGrievanceNumber, CurrentGrievanceNumber : Integer;
  Continue : Boolean;

begin
  Continue := True;
  CurrentGrievanceNumber := MainTable.FieldByName('GrievanceNumber').AsInteger;

  try
    NewGrievanceNumber := StrToInt(EditNewGrievanceNumber.Text);
  except
    NewGrievanceNumber := 9999;
    Continue := False;
    MessageDlg('Sorry, ' + EditNewGrievanceNumber.Text + ' is not a valid grievance number.',
               mtError, [mbOK], 0);
    EditNewGrievanceNumber.SetFocus;
  end;

    {CHG10062002-2: Don't allow them to delete or renumber grievances from prior years.}

  If Continue
    then
      If (MainTable.FieldByName('TaxRollYr').Text = GrievanceYear)
        then
          begin
            If (MessageDlg('Are you sure you want to change the number of this grievance from ' +
                           IntToStr(CurrentGrievanceNumber) + ' to ' +
                           IntToStr(NewGrievanceNumber) + '?', mtConfirmation, [mbYes, mbNo], 0) = idYes)
              then
                begin
                  SetRangeOld(GrievanceExemptionsAskedTable,
                              ['SwisSBLKey', 'TaxRollYr', 'GrievanceNumber', 'ExemptionCode'],
                              [SwisSBLKey, GrievanceYear, IntToStr(CurrentGrievanceNumber), '     '],
                              [SwisSBLKey, GrievanceYear, IntToStr(CurrentGrievanceNumber), '99999']);
                  UpdateFieldForTable(GrievanceExemptionsAskedTable,
                                      'GrievanceNumber', IntToStr(NewGrievanceNumber));

                  GrievanceExemptionsTable.IndexName := 'BYTAXROLLYR_SWISSBLKEY';
                  SetRangeOld(GrievanceExemptionsTable,
                              ['SwisSBLKey', 'TaxRollYr'],
                              [SwisSBLKey, GrievanceYear],
                              [SwisSBLKey, GrievanceYear]);
                  UpdateFieldForTable(GrievanceExemptionsTable,
                                      'GrievanceNumber', IntToStr(NewGrievanceNumber));

                  GrievanceSpecialDistrictsTable.IndexName := 'BYTAXROLLYR_SWISSBLKEY';
                  SetRangeOld(GrievanceSpecialDistrictsTable,
                              ['SwisSBLKey', 'TaxRollYr'],
                              [SwisSBLKey, GrievanceYear],
                              [SwisSBLKey, GrievanceYear]);
                  UpdateFieldForTable(GrievanceSpecialDistrictsTable,
                                      'GrievanceNumber', IntToStr(NewGrievanceNumber));

                  with GrievanceLookupTable do
                    try
                      GotoCurrent(MainTable);
                      Edit;
                      FieldByName('GrievanceNumber').AsInteger := NewGrievanceNumber;
                      Post;
                    except
                      SystemSupport(003, GrievanceLookupTable, 'Error changing grievance number.',
                                    UnitName, GlblErrorDlgBox);
                    end;

                  RenumberGrievancePanel.Visible := False;
                  SetRangeForTable(MainTable);
                  MainTable.Refresh;

                  MessageDlg('This grievance has been changed from ' +
                             IntToStr(CurrentGrievanceNumber) + ' to ' +
                             IntToStr(NewGrievanceNumber) + '.', mtInformation, [mbOK], 0);

                  GrievanceExemptionsTable.IndexName := 'BYYEAR_SWISSBLKEY_EXCODE';
                  GrievanceSpecialDistrictsTable.IndexName := 'BYYEAR_SBL_GRVNUM_SD';

                end;  {If (MessageDlg('Are you sure you want ...}

          end
        else MessageDlg('Sorry, you can not renumber grievances from prior years.',
                        mtError, [mbOK], 0);

end;  {OKButtonClick}

{==============================================================}
Procedure TGrievanceForm.FormResize(Sender: TObject);

var
  iAvailableSpace, iSpacing : Integer;

begin
  iAvailableSpace := pnl_Buttons.Width -
                     (NewGrievanceButton.Width +
                      DeleteGrievanceButton.Width +
                      RenumberGrievanceButton.Width +
                      CopyGrievanceButton.Width +
                      CloseButton.Width);

  iSpacing := iAvailableSpace DIV 6;

  NewGrievanceButton.Left := iSpacing;
  DeleteGrievanceButton.Left := NewGrievanceButton.Left + NewGrievanceButton.Width + iSpacing;
  RenumberGrievanceButton.Left := DeleteGrievanceButton.Left + DeleteGrievanceButton.Width + iSpacing;
  CopyGrievanceButton.Left := RenumberGrievanceButton.Left + RenumberGrievanceButton.Width + iSpacing;
  CloseButton.Left := CopyGrievanceButton.Left + CopyGrievanceButton.Width + iSpacing;

  If (MainTable.Active and
      (GrievanceGrid.Width <> iOriginalGridWidth))
    then
      begin
        ResizeGridFontForWidthChange(GrievanceGrid, iOriginalGridWidth);

        iOriginalGridWidth := GrievanceGrid.Width;

      end;

end;  {FormResize}

{==============================================================}
Procedure TGrievanceForm.CancelButtonClick(Sender: TObject);

begin
  RenumberGrievancePanel.Visible := False;
end;

{==============================================================}
Procedure TGrievanceForm.CloseButtonClick(Sender: TObject);

{Note that the close button is a close for the whole
 parcel maintenance.}

{To close the whole parcel maintenance, we will once again use
 the base popup menu. We will simulate a click on the
 "Exit Parcel Maintenance" of the BasePopupMenu which will
 then call the Close of ParcelTabForm. See the locate button
 click above for more information on how this works.}

var
  I : Integer;

begin
    {Search for the name of the menu item that has "Exit"
     in it, and click it.}

  For I := 0 to (PopupMenu.Items.Count - 1) do
    If (Pos('Exit', PopupMenu.Items[I].Name) <> 0)
      then PopupMenu.Items[I].Click;

end;  {CloseButtonClick}

{====================================================================}
Procedure TGrievanceForm.FormClose(    Sender: TObject;
                                    var Action: TCloseAction);

begin
    {Close all tables here.}

  CloseTablesForForm(Self);
  Action := caFree;

end;  {FormClose}




end.