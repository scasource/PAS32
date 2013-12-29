unit pSmallClaims;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  StdCtrls, ExtCtrls, Forms, Dialogs, DB, Grids, DBGrids,
  DBTables, Mask, DBCtrls, Wwtable, Wwdatsrc, Wwdbcomb, Wwdbigrd, Wwdbgrid,
  Btrvdlg, Types, wwdblook, Buttons, Tabs, TMultiP, ComCtrls,
  GrievanceNotesFrameUnit;

type
  TSmallClaimsForm = class(TForm)
    MainDataSource: TwwDataSource;
    MainTable: TwwTable;
    Panel1: TPanel;
    TitleLabel: TLabel;
    ParcelDataSource: TDataSource;
    ParcelTable: TTable;
    YearLabel: TLabel;
    InactiveLabel: TLabel;
    Label53: TLabel;
    Label55: TLabel;
    TotalAVLabel: TLabel;
    LandAVLabel: TLabel;
    PartialAssessmentLabel: TLabel;
    SmallClaimsLookupTable: TTable;
    PriorAssessmentTable: TTable;
    CurrentAssessmentTable: TTable;
    SwisCodeTable: TTable;
    CurrentExemptionsTable: TTable;
    CurrentSpecialDistrictsTable: TTable;
    SmallClaimsExemptionsTable: TTable;
    SmallClaimsSpecialDistrictsTable: TTable;
    LawyerCodeTable: TTable;
    CurrentSalesTable: TTable;
    SmallClaimsCalenderTable: TTable;
    SmallClaimsAppraisalTable: TTable;
    SmallClaimsDocumentTable: TTable;
    SmallClaimsSalesTable: TTable;
    SmallClaimsExemptionsAskedTable: TTable;
    MainTableTaxRollYr: TStringField;
    MainTableSwisSBLKey: TStringField;
    MainTableArticleType: TStringField;
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
    MainTablePetitFaxNumber: TStringField;
    MainTablePetitEmail: TStringField;
    MainTablePetitAttorneyName: TStringField;
    MainTablePriorLandValue: TIntegerField;
    MainTablePriorTotalValue: TIntegerField;
    MainTableCurrentLandValue: TIntegerField;
    MainTableCurrentTotalValue: TIntegerField;
    MainTableCurrentTentativeValue: TIntegerField;
    MainTableCurrentFullMarketVal: TIntegerField;
    MainTableCurrentEqRate: TFloatField;
    MainTableCurrentUniformPercent: TFloatField;
    MainTableCurrentRAR: TFloatField;
    MainTablePetitLandValue: TIntegerField;
    MainTablePetitTotalValue: TIntegerField;
    MainTablePetitFullMarketVal: TIntegerField;
    MainTablePropertyClassCode: TStringField;
    MainTableOwnershipCode: TStringField;
    MainTableResidentialPercent: TFloatField;
    MainTableRollSection: TStringField;
    MainTableHomesteadCode: TStringField;
    MainTableLegalAddr: TStringField;
    MainTableLegalAddrNo: TStringField;
    MainTableOldParcelID: TStringField;
    MainTableSchoolCode: TStringField;
    MainTableNotes: TMemoField;
    MainTableNumberOfParcels: TIntegerField;
    MainTableNoticeOfPetition: TDateField;
    MainTableNoteOfIssue: TDateField;
    MainTableResolutionNumber: TStringField;
    MainTableFinalOrderDate: TDateField;
    MainTableGrantedFullMarketVal: TIntegerField;
    HistorySwisCodeTable: TTable;
    MainTablePriorFullMarketVal: TIntegerField;
    MainTablePetitReason: TStringField;
    MainTablePetitSubreasonCode: TStringField;
    MainTablePetitSubreason: TMemoField;
    MainTablePostTrialMemo: TDateField;
    MainTableGrantedLandValue: TIntegerField;
    MainTableGrantedTotalValue: TIntegerField;
    MainTableGrantedEXCode: TStringField;
    MainTableGrantedEXAmount: TIntegerField;
    MainTableGrantedEXPercent: TFloatField;
    PriorSwisCodeTable: TTable;
    MainTableDisposition: TStringField;
    MainTableResultsReason: TMemoField;
    MainTableDispositionDate: TDateField;
    MainTableIndexNumber: TIntegerField;
    MainTableGrievanceDecision: TStringField;
    MainTableStatus: TStringField;
    MainTableLegalAddrInt: TIntegerField;
    RenumberSmallClaimsPanel: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    CancelButton: TBitBtn;
    OKButton: TBitBtn;
    EditNewSmallClaimsNumber: TEdit;
    EditNewSmallClaimsYear: TEdit;
    Panel21: TPanel;
    CloseRenumberCertiorariPanelTopButton: TButton;
    SetFocusTimer: TTimer;
    SwisCodeLookupTable: TTable;
    ParcelLookupTable: TTable;
    AssessmentLookupTable: TTable;
    Panel2: TPanel;
    Label5: TLabel;
    Label7: TLabel;
    Label4: TLabel;
    EditName: TDBEdit;
    EditSBL: TMaskEdit;
    EditLocation: TEdit;
    PageControl: TPageControl;
    SummaryTabSheet: TTabSheet;
    pnl_Buttons: TPanel;
    Panel5: TPanel;
    NotesTabSheet: TTabSheet;
    GrievanceNotesFrame: TGrievanceNotesFrame;
    SmallClaimsGrid: TwwDBGrid;
    NewSmallClaimsButton: TBitBtn;
    RenumberSmallClaimsButton: TBitBtn;
    CopySmallClaimsButton: TBitBtn;
    CloseButton: TBitBtn;
    NumberOfNotesTimer: TTimer;
    DeleteSmallClaimsButton: TBitBtn;

    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CloseButtonClick(Sender: TObject);
    procedure NewSmallClaimsButtonClick(Sender: TObject);
    procedure SmallClaimsGridDblClick(Sender: TObject);
    procedure MainTableCalcFields(DataSet: TDataSet);
    procedure RenumberSmallClaimsButtonClick(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject);
    procedure SetFocusTimerTimer(Sender: TObject);
    procedure CopySmallClaimsButtonClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure NumberOfNotesTimerTimer(Sender: TObject);
    procedure DeleteSmallClaimsButtonClick(Sender: TObject);
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  public
    { public declarations }
    UnitName : String;  {For use with error dialog box.}

      {These will be set in the ParcelTabForm.}

    EditMode : Char;  {A = Add; M = Modify; V = View}
    TaxRollYr, SwisSBLKey : String;
    SmallClaimsYear,
    PriorYear : String;
    SmallClaimsProcessingType,
    iOriginalGridWidth, PriorProcessingType : Integer;
    PriorAssessmentFound : Boolean;

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
     GlblCnst, PSmallClaimsSubFormUnit, SmallClaimsAddDialogUnit,
     SmallClaimsCondoCopyDialogUnit, GrievanceUtilitys,
     DataAccessUnit, DocumentTypeDialog, FullScrn, UtilOLE;


{$R *.DFM}

{=====================================================================}
Procedure TSmallClaimsForm.CreateParams(var Params: TCreateParams);

begin
 inherited CreateParams(Params);

  with Params do
    begin
      WndParent := Application.Mainform.Handle;
      Style := (Style or WS_Child) and not WS_Popup;
    end;

end;  {CreateParams}

{========================================================================}
Procedure TSmallClaimsForm.SetRangeForTable(Table : TTable);

{Now set the range on this table so that it is sychronized to this parcel. Note
 that all segments of the key must be set.}
{mmm4 - Make sure to set range on all keys.}

begin
  SetRangeOld(Table, ['SwisSBLKey', 'TaxRollYr'],
              [SwisSBLKey, '1950'],
              [SwisSBLKey, '3999']);

end;  {SetRangeForTable}

{====================================================================}
Procedure TSmallClaimsForm.InitializeForm;

var
  Quit : Boolean;

begin
  UnitName := 'PSmallClaims';  {mmm1}
  ClosingForm := False;
  FormIsInitializing := True;
  iOriginalGridWidth := SmallClaimsGrid.Width;

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

          {FXX10062002-1: Actually certs are entered on This Year in Westchester.}

          {CHG10172011-1(2.28.1v): Allow for a small claims default year.}

        SmallClaimsYear := glblSmallClaimsDefaultYear;
        SmallClaimsProcessingType := GetProcessingTypeForTaxRollYear(SmallClaimsYear);

        If _Compare(SmallClaimsProcessingType, NextYear, coEqual)
        then
        begin
          PriorYear := GlblThisYear;
          PriorProcessingType := ThisYear;
        end;

        If _Compare(SmallClaimsProcessingType, ThisYear, coEqual)
        then
        begin
          PriorYear := IntToStr(StrToInt(SmallClaimsYear) - 1);
          PriorProcessingType := History;
        end;

(*        If GlblIsWestchesterCounty
          then
            begin
              SmallClaimsYear := GlblNextYear;
              PriorYear := GlblThisYear;
              SmallClaimsProcessingType := NextYear;
              PriorProcessingType := ThisYear;
            end
          else
            begin
              SmallClaimsYear := GlblThisYear;
              PriorYear := IntToStr(StrToInt(SmallClaimsYear) - 1);
              SmallClaimsProcessingType := ThisYear;
              PriorProcessingType := History;
(           end;*)

        OpenTablesForForm(Self, SmallClaimsProcessingType);

          {First let's find this parcel in the parcel table.}

        If not _Locate(ParcelTable, [SmallClaimsYear, SwisSBLKey], '', [loParseSwisSBLKey])
          then SystemSupport(001, ParcelTable, 'Error finding key in parcel table.', UnitName, GlblErrorDlgBox);

        SetRangeForTable(MainTable);  {This is a method that we have written to avoid having two copies of the setrange.}

          {Also, set the title label to reflect the mode.
           We will then center it in the panel.}

        case EditMode of   {mmm5}
          'A',
          'M' : TitleLabel.Caption := 'Small Claims Add\Modify';
          'V' : TitleLabel.Caption := 'Small Claims View';
        end;  {case EditMode of}

        TitleLabel.Left := (Panel1.Width - TitleLabel.Width) DIV 2;

          {Note that we will not automatically put them
           in edit mode or insert mode. We will make them
           take that action themselves since even though
           they are in an edit or insert session, they
           may not want to actually make any changes, and
           if they do not, they should not have to cancel.}
          {FXX02022004-2(2.07l): Make sure the copy grievance, etc. button is disabled in view mode.}

        If MainTable.ReadOnly
          then
            begin
              NewSmallClaimsButton.Enabled := False;
              DeleteSmallClaimsButton.Enabled := False;
              RenumberSmallClaimsButton.Enabled := False;
              CopySmallClaimsButton.Enabled := False;

            end;  {If MainTable.ReadOnly}

          {Set the location label.}

        EditLocation.Text := GetLegalAddressFromTable(ParcelTable);
        EditSBL.Text := ConvertSwisSBLToDashDot(SwisSBLKey);
        SetTaxYearLabelForProcessingType(YearLabel, GlblProcessingType);

          {FXX12101997-1: Make sure that all pages have the inactive label.}

        If (ParcelTable.FieldByName('ActiveFlag').Text = InactiveParcelFlag)
          then InactiveLabel.Visible := True;

        OpenTableForProcessingType(SwisCodeTable, SwisCodeTableName,
                                   SmallClaimsProcessingType, Quit);

        OpenTableForProcessingType(CurrentAssessmentTable, AssessmentTableName,
                                   SmallClaimsProcessingType, Quit);

        OpenTableForProcessingType(PriorSwisCodeTable, SwisCodeTableName,
                                   PriorProcessingType, Quit);

        OpenTableForProcessingType(PriorAssessmentTable, AssessmentTableName,
                                   PriorProcessingType, Quit);

        OpenTableForProcessingType(CurrentExemptionsTable, ExemptionsTableName,
                                   SmallClaimsProcessingType, Quit);

        OpenTableForProcessingType(CurrentSpecialDistrictsTable, SpecialDistrictTableName,
                                   SmallClaimsProcessingType, Quit);

        FindKeyOld(SwisCodeTable, ['SwisCode'], [Copy(SwisSBLKey, 1, 6)]);

        FindKeyOld(CurrentAssessmentTable, ['TaxRollYr', 'SwisSBLKey'],
                   [SmallClaimsYear, SwisSBLKey]);

        PriorAssessmentFound := FindKeyOld(PriorAssessmentTable,
                                           ['TaxRollYr', 'SwisSBLKey'],
                                           [PriorYear, SwisSBLKey]);

        SetRangeOld(CurrentExemptionsTable, ['TaxRollYr', 'SwisSBLKey'],
                    [SmallClaimsYear, SwisSBLKey], [SmallClaimsYear, SwisSBLKey]);

        SetRangeOld(CurrentSpecialDistrictsTable, ['TaxRollYr', 'SwisSBLKey'],
                    [SmallClaimsYear, SwisSBLKey], [SmallClaimsYear, SwisSBLKey]);

        SetRangeOld(CurrentSalesTable, ['SwisSBLKey', 'SaleNumber'],
                    [SwisSBLKey, '0'], [SwisSBLKey, '9999']);

        TFloatField(MainTable.FieldByName('CurrentTotalValue')).DisplayFormat := CurrencyDisplayNoDollarSign;
        TFloatField(MainTable.FieldByName('CurrentFullMarketVal')).DisplayFormat := CurrencyDisplayNoDollarSign;
        TFloatField(MainTable.FieldByName('PetitTotalValue')).DisplayFormat := CurrencyDisplayNoDollarSign;

        If GlblCanSeeSmallClaimsNotes
          then
            begin
              GrievanceNotesFrame.InitializeForm(SwisSBLKey, SmallClaimsNotesTableName);
              NumberOfNotesTimer.Enabled := True;
            end
          else NotesTabSheet.TabVisible := False;

      end;  {If (Deblank(SwisSBLKey) <> '')}

    {CHG11162004-7(2.8.0.21): Option to make the close button locate.}

  If GlblCloseButtonIsLocate
    then MakeCloseButtonLocate(CloseButton);

  FormIsInitializing := False;

  MainTable.Refresh;

end;  {InitializeForm}

{======================================================================}
Procedure TSmallClaimsForm.NumberOfNotesTimerTimer(Sender: TObject);

begin
  NotesTabSheet.Caption := 'Notes (' + IntToStr(GrievanceNotesFrame.GetNumberOfNotes) + ')';
end;

{==============================================================}
Procedure TSmallClaimsForm.MainTableCalcFields(DataSet: TDataSet);

var
  StatusCode : Integer;

begin
  If not FormIsInitializing
    then MainTableStatus.Text := GetCert_Or_SmallClaimStatus(MainTable, StatusCode);

end;  {MainTableCalcFields}

{==============================================================}
Procedure TSmallClaimsForm.SmallClaimsGridDblClick(Sender: TObject);

{Go to this SmallClaims in the subform.}

begin
  GlblDialogBoxShowing := True;

  try
    SmallClaimsSubform := TSmallClaimsSubform.Create(nil);

    SmallClaimsSubform.SwisSBLKey := MainTable.FieldByName('SwisSBLKey').Text;
    SmallClaimsSubform.SmallClaimsYear := MainTable.FieldByName('TaxRollYr').Text;
    SmallClaimsSubform.IndexNumber := MainTable.FieldByName('IndexNumber').AsInteger;
    SmallClaimsSubform.SmallClaimsProcessingType := SmallClaimsProcessingType;
    SmallClaimsSubform.EditMode := EditMode;

    SmallClaimsSubform.InitializeForm;

    SmallClaimsSubform.ShowModal;

    MainTable.Refresh;

  finally
    SmallClaimsSubform.Free;
  end;

  GlblDialogBoxShowing := False;

end;  {SmallClaimsGridDblClick}

{==============================================================}
Procedure TSmallClaimsForm.NewSmallClaimsButtonClick(Sender: TObject);

var
  IndexNumber, TempProcessingType : Integer;
  Continue, AddNewSmallClaims,
  _Found, InitializationInformationFound, Quit : Boolean;
  TempAssessmentYear,
  LawyerCode, EnteredSmallClaimsYear : String;
  TempParcelTable, TempAssessmentTable, TempSwisCodeTable : TTable;
  SBLRec : SBLRecord;

begin
  TempParcelTable := nil;
  TempSwisCodeTable := nil;
  TempAssessmentTable := nil;
  IndexNumber := 0;
  AddNewSmallClaims := False;
  Continue := True;
  GlblDialogBoxShowing := True;

    {FXX10072003-1(2.07j): Make it so that history cert and small claims entry picks up
                           as much info as it can.}

  try
    SmallClaimsAddDialog := TSmallClaimsAddDialog.Create(nil);
    SmallClaimsAddDialog.SmallClaimsYear := SmallClaimsYear;
    SmallClaimsAddDialog.PriorYear := PriorYear;
    SmallClaimsAddDialog.SmallClaimsProcessingType := SmallClaimsProcessingType;
    SmallClaimsAddDialog.PriorProcessingType := PriorProcessingType;
    SmallClaimsAddDialog.SwisSBLKey := SwisSBLKey;

    case SmallClaimsAddDialog.ShowModal of
      idOK :
        begin
          LawyerCode := SmallClaimsAddDialog.LawyerCode;
          IndexNumber := SmallClaimsAddDialog.IndexNumber;
          EnteredSmallClaimsYear := SmallClaimsAddDialog.SmallClaimsYear;

        end;

      idCancel : Continue := False;

    end;  {case SmallClaimsLawyerCodeDialog.ShowModal of}

    If Continue
      then AddNewSmallClaims := not SmallClaimsAddDialog.AlreadyCopied;

  finally
    SmallClaimsAddDialog.Free;
  end;

  GlblDialogBoxShowing := False;

  If (Continue and
      AddNewSmallClaims)
    then
      begin
        with MainTable do
          try
            Append;
            FieldByName('TaxRollYr').Text := EnteredSmallClaimsYear;
            FieldByName('IndexNumber').AsInteger := IndexNumber;
            FieldByName('SwisSBLKey').Text := SwisSBLKey;
            FieldByName('LawyerCode').Text := LawyerCode;
            FieldByName('OldParcelID').Text := ParcelTable.FieldByName('RemapOldSBL').Text;

            InitializationInformationFound := False;

            If (SmallClaimsYear = EnteredSmallClaimsYear)
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
                  If (EnteredSmallClaimsYear = GlblThisYear)
                    then
                      begin
                        TempProcessingType := ThisYear;
                        TempAssessmentYear := GlblThisYear;
                      end
                    else
                      If (EnteredSmallClaimsYear = GlblNextYear)
                        then
                          begin
                            TempProcessingType := NextYear;
                            TempAssessmentYear := GlblNextYear;
                          end
                        else
                          begin
                            TempProcessingType := History;
                            TempAssessmentYear := EnteredSmallClaimsYear;
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

                  If (Deblank(LawyerCode) = '')
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
                                                                                          GlblUseRAR));
                  If ((EnteredSmallClaimsYear = SmallClaimsYear) and
                      PriorAssessmentFound)
                    then
                      begin
                        FindKeyOld(PriorSwisCodeTable, ['TaxRollYr', 'SwisCode'],
                                   [PriorYear, Copy(SwisSBLKey, 1, 6)]);
                        FieldByName('PriorLandValue').AsInteger := PriorAssessmentTable.FieldByName('LandAssessedVal').AsInteger;
                        FieldByName('PriorTotalValue').AsInteger := PriorAssessmentTable.FieldByName('TotalAssessedVal').AsInteger;

                        try
                          FieldByName('PriorFullMarketVal').AsInteger := Round(ComputeFullValue(PriorAssessmentTable.FieldByName('TotalAssessedVal').AsInteger,
                                                                                                HistorySwisCodeTable,
                                                                                                ParcelTable.FieldByName('PropertyClassCode').Text,
                                                                                                ParcelTable.FieldByName('OwnershipCode').Text,
                                                                                                GlblUseRAR));
                        except
                        end;

                      end;  {If PriorAssessmentFound}

                  FieldByName('CurrentEqRate').AsFloat := TempSwisCodeTable.FieldByName('EqualizationRate').AsFloat;
                  FieldByName('CurrentUniformPercent').AsFloat := TempSwisCodeTable.FieldByName('UniformPercentValue').AsFloat;
                  FieldByName('CurrentRAR').AsFloat := TempSwisCodeTable.FieldByName('ResAssmntRatio').AsFloat;
                  FieldByName('SchoolCode').Text := TempParcelTable.FieldByName('SchoolCode').Text;
                  FieldByName('NumberOfParcels').AsInteger := 1;

                  Post;

                  If (EnteredSmallClaimsYear = SmallClaimsYear)
                    then
                      begin
                        CopyTableRange(CurrentExemptionsTable, SmallClaimsExemptionsTable,
                                       'TaxRollYr', ['IndexNumber'], [IntToStr(IndexNumber)]);

                        CopyTableRange(CurrentSpecialDistrictsTable, SmallClaimsSpecialDistrictsTable,
                                       'TaxRollYr', ['IndexNumber'], [IntToStr(IndexNumber)]);

                        CopyTableRange(CurrentSalesTable, SmallClaimsSalesTable,
                                       'SwisSBLKey', ['IndexNumber'], [IntToStr(IndexNumber)]);

                      end;  {If (EnteredSmallClaimsYear = SmallClaimsYear)}

                end
              else Post;

          except
            Continue := False;
            SystemSupport(002, MainTable, 'Error adding small claims # ' + IntToStr(IndexNumber) + '.',
                          UnitName, GlblErrorDlgBox);
          end;

      end;  {If Continue}

  If Continue
    then
      begin
        MainTable.Refresh;
        SetRangeForTable(MainTable);

          {FXX08272003-1(2.07i): Need to make sure we are pointed at the right cert at this point.}

        _Found := FindKeyOld(SmallClaimsLookupTable, ['TaxRollYr', 'SwisSBLKey', 'IndexNumber'],
                             [EnteredSmallClaimsYear, SwisSBLKey, IntToStr(IndexNumber)]);

        If _Found
          then
            begin
              MainTable.GotoCurrent(SmallClaimsLookupTable);
              SmallClaimsGridDblClick(Sender);
            end
          else SystemSupport(009, SmallClaimsLookupTable,
                             'Error reaccessing SmallClaims ' + IntToStr(IndexNumber) + '.',
                             UnitName, GlblErrorDlgBox);

      end;  {If Continue}

end;  {NewSmallClaimsButtonClick}

{====================================================================}
Procedure TSmallClaimsForm.SetFocusTimerTimer(Sender: TObject);

begin
  SetFocusTimer.Enabled := False;
  EditNewSmallClaimsYear.SetFocus;
end;

{====================================================================}
Procedure TSmallClaimsForm.RenumberSmallClaimsButtonClick(Sender: TObject);

begin
  RenumberSmallClaimsPanel.Visible := True;
  SetFocusTimer.Enabled := True;
end;

{====================================================================}
Procedure TSmallClaimsForm.CopySmallClaimsButtonClick(Sender: TObject);

{CHG10092003-2(2.07j1): Allow them to copy a SmallClaims to multiple parcels.}

begin
  try
    SmallClaimsCondoCopyDialog := TSmallClaimsCondoCopyDialog.Create(nil);
    SmallClaimsCondoCopyDialog.IndexNumber := MainTable.FieldByName('IndexNumber').AsInteger;
    SmallClaimsCondoCopyDialog.SmallClaimsYear := MainTable.FieldByName('TaxRollYr').Text;
    SmallClaimsCondoCopyDialog.LawyerCode := MainTable.FieldByName('LawyerCode').Text;
    SmallClaimsCondoCopyDialog.OriginalSwisSBLKey := SwisSBLKey;

    SmallClaimsCondoCopyDialog.ShowModal;

  finally
    SmallClaimsCondoCopyDialog.Free;
  end;

end;  {CopySmallClaimsButtonClick}

{====================================================================}
Procedure TSmallClaimsForm.OKButtonClick(Sender: TObject);

var
  NewIndexNumber, CurrentIndexNumber : Integer;
  NewSmallClaimsYear, CurrentSmallClaimsYear : String;
  Continue : Boolean;

begin
  Continue := True;
  NewIndexNumber := 0;
  CurrentIndexNumber := MainTable.FieldByName('IndexNumber').AsInteger;
  CurrentSmallClaimsYear := MainTable.FieldByName('TaxRollYr').Text;

  try
    NewIndexNumber := StrToInt(EditNewSmallClaimsNumber.Text);
  except
    Continue := False;
    MessageDlg('Sorry, ' + EditNewSmallClaimsNumber.Text + ' is not a valid small claims number.',
               mtError, [mbOK], 0);
    EditNewSmallClaimsNumber.SetFocus;
  end;

  NewSmallClaimsYear := Trim(EditNewSmallClaimsYear.Text);

    {CHG10062002-2: Don't allow them to delete or renumber SmallClaimss from prior years.}

  If Continue
    then
      If (MessageDlg('Are you sure you want to change the number of this small claims from ' +
                     IntToStr(CurrentIndexNumber) + ' to ' +
                     IntToStr(NewIndexNumber) + '?', mtConfirmation, [mbYes, mbNo], 0) = idYes)
        then
          begin
            SetRangeOld(SmallClaimsExemptionsAskedTable,
                        ['SwisSBLKey', 'TaxRollYr', 'IndexNumber', 'ExemptionCode'],
                        [SwisSBLKey, CurrentSmallClaimsYear, IntToStr(CurrentIndexNumber), '     '],
                        [SwisSBLKey, CurrentSmallClaimsYear, IntToStr(CurrentIndexNumber), '99999']);
            UpdateFieldForTable(SmallClaimsExemptionsAskedTable,
                                'IndexNumber', IntToStr(NewIndexNumber));
            If ((Deblank(NewSmallClaimsYear) <> '') and
                (NewSmallClaimsYear <> CurrentSmallClaimsYear))
              then
                begin
                  SetRangeOld(SmallClaimsExemptionsAskedTable,
                              ['SwisSBLKey', 'TaxRollYr', 'IndexNumber', 'ExemptionCode'],
                              [SwisSBLKey, CurrentSmallClaimsYear, IntToStr(NewIndexNumber), '     '],
                              [SwisSBLKey, CurrentSmallClaimsYear, IntToStr(NewIndexNumber), '99999']);
                  UpdateFieldForTable(SmallClaimsExemptionsAskedTable,
                                      'TaxRollYr', NewSmallClaimsYear);

                end;  {If ((Deblank(NewSmallClaimsYear) <> '') and ..}

            SetRangeOld(SmallClaimsExemptionsTable,
                        ['SwisSBLKey', 'TaxRollYr', 'IndexNumber', 'ExemptionCode'],
                        [SwisSBLKey, SmallClaimsYear, IntToStr(CurrentIndexNumber), '     '],
                        [SwisSBLKey, SmallClaimsYear, IntToStr(CurrentIndexNumber), '99999']);
            UpdateFieldForTable(SmallClaimsExemptionsTable,
                                'IndexNumber', IntToStr(NewIndexNumber));
            If ((Deblank(NewSmallClaimsYear) <> '') and
                (NewSmallClaimsYear <> CurrentSmallClaimsYear))
              then
                begin
                  SetRangeOld(SmallClaimsExemptionsTable,
                              ['SwisSBLKey', 'TaxRollYr', 'IndexNumber', 'ExemptionCode'],
                              [SwisSBLKey, SmallClaimsYear, IntToStr(NewIndexNumber), '     '],
                              [SwisSBLKey, SmallClaimsYear, IntToStr(NewIndexNumber), '99999']);

                  UpdateFieldForTable(SmallClaimsExemptionsTable,
                                      'TaxRollYr', NewSmallClaimsYear);

                end;  {If ((Deblank(NewSmallClaimsYear) <> '') and ...}

            SetRangeOld(SmallClaimsSpecialDistrictsTable,
                        ['SwisSBLKey', 'TaxRollYr', 'IndexNumber', 'SDistCode'],
                        [SwisSBLKey, SmallClaimsYear, IntToStr(CurrentIndexNumber), '     '],
                        [SwisSBLKey, SmallClaimsYear, IntToStr(CurrentIndexNumber), 'ZZZZZ']);
            UpdateFieldForTable(SmallClaimsSpecialDistrictsTable,
                                'IndexNumber', IntToStr(NewIndexNumber));
            If ((Deblank(NewSmallClaimsYear) <> '') and
                (NewSmallClaimsYear <> CurrentSmallClaimsYear))
              then
                begin
                  SetRangeOld(SmallClaimsSpecialDistrictsTable,
                              ['SwisSBLKey', 'TaxRollYr', 'IndexNumber', 'SDistCode'],
                              [SwisSBLKey, SmallClaimsYear, IntToStr(NewIndexNumber), '     '],
                              [SwisSBLKey, SmallClaimsYear, IntToStr(NewIndexNumber), 'ZZZZZ']);

                  UpdateFieldForTable(SmallClaimsSpecialDistrictsTable,
                                      'TaxRollYr', NewSmallClaimsYear);

                end;  {If ((Deblank(NewSmallClaimsYear) <> '') and ...}

            SetRangeOld(SmallClaimsSalesTable,
                        ['SwisSBLKey', 'IndexNumber', 'SaleNumber'],
                        [SwisSBLKey, IntToStr(CurrentIndexNumber), '1'],
                        [SwisSBLKey, IntToStr(CurrentIndexNumber), '99999']);
            UpdateFieldForTable(SmallClaimsSalesTable,
                                'IndexNumber', IntToStr(NewIndexNumber));

            SetRangeOld(SmallClaimsAppraisalTable,
                        ['TaxRollYr', 'SwisSBLKey', 'IndexNumber', 'DateAuthorized'],
                        [CurrentSmallClaimsYear, SwisSBLKey, IntToStr(CurrentIndexNumber), '1/1/1900'],
                        [CurrentSmallClaimsYear, SwisSBLKey, IntToStr(CurrentIndexNumber), '1/1/3000']);
            UpdateFieldForTable(SmallClaimsAppraisalTable,
                                'IndexNumber', IntToStr(NewIndexNumber));
            If ((Deblank(NewSmallClaimsYear) <> '') and
                (NewSmallClaimsYear <> CurrentSmallClaimsYear))
              then
                begin
                  SetRangeOld(SmallClaimsAppraisalTable,
                              ['TaxRollYr', 'SwisSBLKey', 'IndexNumber', 'DateAuthorized'],
                              [CurrentSmallClaimsYear, SwisSBLKey, IntToStr(NewIndexNumber), '1/1/1900'],
                              [CurrentSmallClaimsYear, SwisSBLKey, IntToStr(NewIndexNumber), '1/1/3000']);
                  UpdateFieldForTable(SmallClaimsAppraisalTable,
                                      'TaxRollYr', NewSmallClaimsYear);

                end;  {If ((Deblank(NewSmallClaimsYear) <> '') and ..}

            SetRangeOld(SmallClaimsCalenderTable,
                        ['TaxRollYr', 'SwisSBLKey', 'IndexNumber', 'Date'],
                        [CurrentSmallClaimsYear, SwisSBLKey, IntToStr(CurrentIndexNumber), '1/1/1900'],
                        [CurrentSmallClaimsYear, SwisSBLKey, IntToStr(CurrentIndexNumber), '1/1/3000']);
            UpdateFieldForTable(SmallClaimsCalenderTable,
                                'IndexNumber', IntToStr(NewIndexNumber));
            If ((Deblank(NewSmallClaimsYear) <> '') and
                (NewSmallClaimsYear <> CurrentSmallClaimsYear))
              then
                begin
                  SetRangeOld(SmallClaimsCalenderTable,
                              ['TaxRollYr', 'SwisSBLKey', 'IndexNumber', 'Date'],
                              [CurrentSmallClaimsYear, SwisSBLKey, IntToStr(NewIndexNumber), '1/1/1900'],
                              [CurrentSmallClaimsYear, SwisSBLKey, IntToStr(NewIndexNumber), '1/1/3000']);
                  UpdateFieldForTable(SmallClaimsCalenderTable,
                                      'TaxRollYr', NewSmallClaimsYear);

                end;  {If ((Deblank(NewSmallClaimsYear) <> '') and ..}

            with SmallClaimsLookupTable do
              try
                GotoCurrent(MainTable);
                Edit;
                FieldByName('IndexNumber').AsInteger := NewIndexNumber;

                If ((Deblank(NewSmallClaimsYear) <> '') and
                    (NewSmallClaimsYear <> CurrentSmallClaimsYear))
                  then FieldByName('TaxRollYr').Text := NewSmallClaimsYear;

                Post;
              except
                SystemSupport(003, SmallClaimsLookupTable, 'Error changing small claims number.',
                              UnitName, GlblErrorDlgBox);
              end;

            RenumberSmallClaimsPanel.Visible := False;
            SetRangeForTable(MainTable);
            MainTable.Refresh;

            MessageDlg('This small claims has been changed from ' +
                       IntToStr(CurrentIndexNumber) + ' to ' +
                       IntToStr(NewIndexNumber) + '.', mtInformation, [mbOK], 0);

            MainTable.Refresh;

          end;  {If (MessageDlg('Are you sure you want ...}

end;  {OKButtonClick}

{====================================================================}
Procedure TSmallClaimsForm.DeleteSmallClaimsButtonClick(Sender: TObject);

var
  IndexNumber : Integer;

begin
  IndexNumber := MainTable.FieldByName('IndexNumber').AsInteger;

    {FXX04232009-15(4.20.1.1)[D1491]: Had to recreate the event handler in order to get the
                                      remove button to work.  In addition, I made it so they could delete
                                      TY and NY.}
    {CHG05272009-1(4.20.1.1)[D1491]: Allow the supervisor to delete any year.}

  If (UserIsSupervisor(GlblUserName) or
      (_Compare(MainTable.FieldByName('TaxRollYr').AsString, GlblThisYear, coEqual) or
      _Compare(MainTable.FieldByName('TaxRollYr').AsString, GlblNextYear, coEqual)))
    then
      If (MessageDlg('Are you sure you want to delete small claims ' +
                     IntToStr(IndexNumber) + '?',
                     mtConfirmation, [mbYes, mbNo], 0) = idYes)
        then
          begin
            SetRangeOld(SmallClaimsExemptionsTable,
                        ['SwisSBLKey', 'TaxRollYr', 'IndexNumber', 'ExemptionCode'],
                        [SwisSBLKey, SmallClaimsYear, IntToStr(IndexNumber), '     '],
                        [SwisSBLKey, SmallClaimsYear, IntToStr(IndexNumber), '99999']);

            SetRangeOld(SmallClaimsExemptionsAskedTable,
                        ['SwisSBLKey', 'TaxRollYr', 'IndexNumber', 'ExemptionCode'],
                        [SwisSBLKey, SmallClaimsYear, IntToStr(IndexNumber), '     '],
                        [SwisSBLKey, SmallClaimsYear, IntToStr(IndexNumber), '99999']);

            SetRangeOld(SmallClaimsSpecialDistrictsTable,
                        ['SwisSBLKey', 'TaxRollYr', 'IndexNumber', 'SDistCode'],
                        [SwisSBLKey, SmallClaimsYear, IntToStr(IndexNumber), '     '],
                        [SwisSBLKey, SmallClaimsYear, IntToStr(IndexNumber), 'ZZZZZ']);

            SetRangeOld(SmallClaimsSalesTable,
                        ['SwisSBLKey', 'IndexNumber', 'SaleNumber'],
                        [SwisSBLKey, IntToStr(IndexNumber), '0'],
                        [SwisSBLKey, IntToStr(IndexNumber), '9999']);

            SetRangeOld(SmallClaimsCalenderTable,
                        ['SwisSBLKey', 'TaxRollYr', 'IndexNumber', 'Date'],
                        [SwisSBLKey, SmallClaimsYear, IntToStr(IndexNumber), '1/1/1990'],
                        [SwisSBLKey, SmallClaimsYear, IntToStr(IndexNumber), '1/1/3000']);

            SetRangeOld(SmallClaimsAppraisalTable,
                        ['SwisSBLKey', 'TaxRollYr', 'IndexNumber', 'DateAuthorized'],
                        [SwisSBLKey, SmallClaimsYear, IntToStr(IndexNumber), '1/1/1990'],
                        [SwisSBLKey, SmallClaimsYear, IntToStr(IndexNumber), '1/1/3000']);

            SetRangeOld(SmallClaimsDocumentTable,
                        ['SwisSBLKey', 'TaxRollYr', 'IndexNumber', 'DocumentNumber'],
                        [SwisSBLKey, SmallClaimsYear, IntToStr(IndexNumber), '0'],
                        [SwisSBLKey, SmallClaimsYear, IntToStr(IndexNumber), '9999']);

            DeleteTableRange(SmallClaimsExemptionsTable);
            DeleteTableRange(SmallClaimsExemptionsAskedTable);
            DeleteTableRange(SmallClaimsSpecialDistrictsTable);
            DeleteTableRange(SmallClaimsSalesTable);
            DeleteTableRange(SmallClaimsCalenderTable);
            DeleteTableRange(SmallClaimsAppraisalTable);
            DeleteTableRange(SmallClaimsDocumentTable);

            try
              MainTable.Delete;
            except
              SystemSupport(060, MainTable,
                            'Error deleting small claims ' + IntToStr(IndexNumber) + '.',
                            UnitName, GlblErrorDlgBox);
            end;

          end  {If (MessageDlg ...}
        else MessageDlg('You can not delete SmallClaims from a prior year.',
                        mtError, [mboK], 0);

end;  {DeleteSmallClaimsButtonClick}

{===================================================================}
Procedure TSmallClaimsForm.FormResize(Sender: TObject);

var
  iAvailableSpace, iSpacing : Integer;

begin
  iAvailableSpace := pnl_Buttons.Width -
                     (NewSmallClaimsButton.Width +
                      DeleteSmallClaimsButton.Width +
                      RenumberSmallClaimsButton.Width +
                      CopySmallClaimsButton.Width +
                      CloseButton.Width);

  iSpacing := iAvailableSpace DIV 6;

  NewSmallClaimsButton.Left := iSpacing;
  DeleteSmallClaimsButton.Left := NewSmallClaimsButton.Left + NewSmallClaimsButton.Width + iSpacing;
  RenumberSmallClaimsButton.Left := DeleteSmallClaimsButton.Left + DeleteSmallClaimsButton.Width + iSpacing;
  CopySmallClaimsButton.Left := RenumberSmallClaimsButton.Left + RenumberSmallClaimsButton.Width + iSpacing;
  CloseButton.Left := CopySmallClaimsButton.Left + CopySmallClaimsButton.Width + iSpacing;

  If (MainTable.Active and
      (SmallClaimsGrid.Width <> iOriginalGridWidth))
    then
      begin
        ResizeGridFontForWidthChange(SmallClaimsGrid, iOriginalGridWidth);

        iOriginalGridWidth := SmallClaimsGrid.Width;

      end;

end;  {FormResize}

{===================================================================}
Procedure TSmallClaimsForm.CancelButtonClick(Sender: TObject);

begin
  RenumberSmallClaimsPanel.Visible := False;
end;

{==============================================================}
Procedure TSmallClaimsForm.CloseButtonClick(Sender: TObject);

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
Procedure TSmallClaimsForm.FormClose(    Sender: TObject;
                                    var Action: TCloseAction);

begin
    {Close all tables here.}

  CloseTablesForForm(Self);
  Action := caFree;

end;  {FormClose}

end.
