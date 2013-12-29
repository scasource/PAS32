unit Prclocat;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Mask, DBCtrls, ExtCtrls, Grids, DBGrids,
  Buttons, DB, DBTables, wwdblook, Wwtable, Wwdatsrc, Wwdbigrd, Wwdbgrid,
  Types, PASTypes, ComCtrls, MinModal;

type
  TLocateParcelForm = class(TForm)
    SwisCodeTable: TwwTable;
    ParcelTable: TwwTable;
    ParcelDataSource: TwwDataSource;
    ParcelTableTaxRollYr: TStringField;
    ParcelTableSwisCode: TStringField;
    ParcelTableSection: TStringField;
    ParcelTableSubsection: TStringField;
    ParcelTableBlock: TStringField;
    ParcelTableLot: TStringField;
    ParcelTableSublot: TStringField;
    ParcelTableSuffix: TStringField;
    ParcelTableName1: TStringField;
    ParcelTableLegalAddrNo: TStringField;
    ParcelTableLegalAddr: TStringField;
    SwisCodeTableMunicipalityName: TStringField;
    ParcelLookupTable: TTable;
    ParcelTableInactiveParcel: TStringField;
    ParcelTableActiveFlag: TStringField;
    ParcelTableOldParcelID: TStringField;
    ParcelTableNewParcelID: TStringField;
    AssessmentYearControlTable: TTable;
    ParcelTableRemapOldSBL: TStringField;
    AssessmentTable: TTable;
    ParcelTablePropertyClassCode: TStringField;
    SwisCodeTableTaxRollYr: TStringField;
    SwisCodeTableSwisCode: TStringField;
    SwisCodeTableSWISShortCode: TStringField;
    ParcelTableLegalAddrInt: TIntegerField;
    GrievanceDataSource: TwwDataSource;
    GrievanceTable: TwwTable;
    GrievanceTableTaxRollYr: TStringField;
    GrievanceTableSwisSBLKey: TStringField;
    GrievanceTableGrievanceNumber: TIntegerField;
    GrievanceTableCurrentName1: TStringField;
    GrievanceTablePetitName1: TStringField;
    GrievanceTableLegalAddr: TStringField;
    GrievanceTableLegalAddrNo: TStringField;
    GrievanceTableParcelID: TStringField;
    GrievanceTableNoHearingLabel: TStringField;
    GrievanceTableNoHearing: TBooleanField;
    GrievanceTableGrievanceNumberDisplay: TStringField;
    CertiorariTable: TwwTable;
    CertiorariDataSource: TwwDataSource;
    CertiorariTableTaxRollYr: TStringField;
    CertiorariTableSwisSBLKey: TStringField;
    CertiorariTableCertiorariNumber: TIntegerField;
    CertiorariTableCurrentName1: TStringField;
    CertiorariTableParcelID: TStringField;
    SetFocusTimer: TTimer;
    SmallClaimsTable: TwwTable;
    SmallClaimsDataSource: TwwDataSource;
    CertiorariTableAddress: TStringField;
    CertiorariTableCalcPetitionerName: TStringField;
    SmallClaimsTableTaxRollYr: TStringField;
    SmallClaimsTableSwisSBLKey: TStringField;
    SmallClaimsTableIndexNumber: TIntegerField;
    SmallClaimsTableCurrentName1: TStringField;
    SmallClaimsTableLawyerCode: TStringField;
    SmallClaimsTablePetitName1: TStringField;
    SmallClaimsTableLegalAddr: TStringField;
    SmallClaimsTableLegalAddrNo: TStringField;
    SmallClaimsTableOldParcelID: TStringField;
    SmallClaimsTableAddress: TStringField;
    SmallClaimsTableCalcPetitionerName: TStringField;
    SmallClaimsTableParcelID: TStringField;
    GrievanceTableAddress: TStringField;
    GrievanceTableCalcPetitionerName: TStringField;
    CertiorariTableLawyerCode: TStringField;
    CertiorariTablePetitName1: TStringField;
    CertiorariTableLegalAddr: TStringField;
    CertiorariTableLegalAddrNo: TStringField;
    CertiorariTableOldParcelID: TStringField;
    GrievanceTableLawyerCode: TStringField;
    SmallClaimsTableLegalAddrInt: TIntegerField;
    CertiorariTableLegalAddrInt: TIntegerField;
    GrievanceTableLegalAddrInt: TIntegerField;
    GrievanceTableOldParcelID: TStringField;
    CertiorariTableAlternateID: TStringField;
    RestrictedParcelTable: TTable;
    ParcelTableAccountNo: TStringField;
    ParcelTableOwnershipCode: TStringField;
    Panel1: TPanel;
    Label11: TLabel;
    AsteriskLegendLabel: TLabel;
    OldParcelIDLabel: TLabel;
    LandAssessedValueLabel: TLabel;
    TotalAssessedValueLabel: TLabel;
    PropertyClassLabel: TLabel;
    OKButton: TBitBtn;
    CancelButton: TBitBtn;
    Navigator: TDBNavigator;
    ExitButton: TBitBtn;
    Panel2: TPanel;
    PageControl: TPageControl;
    ParcelTabSheet: TTabSheet;
    GrievanceTabSheet: TTabSheet;
    SmallClaimsTabSheet: TTabSheet;
    CertiorariTabSheet: TTabSheet;
    Panel3: TPanel;
    ParcelRadioGroup: TRadioGroup;
    ParcelGroupBox: TGroupBox;
    ParcelNotebook: TNotebook;
    Label2: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label16: TLabel;
    MunicNameLabel: TLabel;
    EditSection: TEdit;
    EditSubsection: TEdit;
    EditBlock: TEdit;
    EditLot: TEdit;
    EditSublot: TEdit;
    EditSuffix: TEdit;
    SwisLookupCombo: TwwDBLookupCombo;
    Label9: TLabel;
    Label10: TLabel;
    MunicNameLabel2: TLabel;
    EditDashDot: TEdit;
    SwisLookupCombo2: TwwDBLookupCombo;
    Label1: TLabel;
    Label3: TLabel;
    EditLegalAddrNo: TEdit;
    EditLegalAddr: TEdit;
    EditStreetName: TEdit;
    EditName: TEdit;
    EditAccountNumber: TEdit;
    Panel4: TPanel;
    ParcelGrid: TwwDBGrid;
    Panel5: TPanel;
    GrievanceKeyRadioGroup: TRadioGroup;
    GrievanceGroupBox: TGroupBox;
    GrievanceLookupNotebook: TNotebook;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    EditGrievanceParcelID: TEdit;
    GrievanceSwisLookupCombo: TwwDBLookupCombo;
    Label24: TLabel;
    Label25: TLabel;
    EditGrievanceLegalAddrNumber: TEdit;
    EditGrievanceLegalAddrName: TEdit;
    EditGrievanceStreetNameOnly: TEdit;
    EditGrievanceOwnerName: TEdit;
    EditGrievanceNumber: TEdit;
    EditGrievancePetitionerName: TEdit;
    GrievanceYearSelectionGroupBox: TGroupBox;
    Label12: TLabel;
    Label13: TLabel;
    GrievanceSpecificYearEdit: TEdit;
    GrievanceAllYearsCheckBox: TCheckBox;
    Panel6: TPanel;
    GrievanceGrid: TwwDBGrid;
    Panel7: TPanel;
    SmallClaimsKeyRadioGroup: TRadioGroup;
    SmallClaimsGroupBox: TGroupBox;
    SmallClaimsLookupNotebook: TNotebook;
    Label14: TLabel;
    Label15: TLabel;
    Label17: TLabel;
    EditSmallClaimsParcelID: TEdit;
    SmallClaimsSwisLookupCombo: TwwDBLookupCombo;
    Label18: TLabel;
    Label19: TLabel;
    EditSmallClaimsLegalAddrNumber: TEdit;
    EditSmallClaimsLegalAddrName: TEdit;
    EditSmallClaimsStreetNameOnly: TEdit;
    EditSmallClaimsOwnerName: TEdit;
    EditSmallClaimsNumber: TEdit;
    EditSmallClaimsPetitionerName: TEdit;
    GroupBox2: TGroupBox;
    Label20: TLabel;
    Label26: TLabel;
    SmallClaimsSpecificYearEdit: TEdit;
    SmallClaimsAllYearsCheckBox: TCheckBox;
    Panel8: TPanel;
    SmallClaimsGrid: TwwDBGrid;
    Panel9: TPanel;
    CertiorariKeyRadioGroup: TRadioGroup;
    CertiorariGroupBox: TGroupBox;
    CertiorariLookupNotebook: TNotebook;
    Label27: TLabel;
    Label28: TLabel;
    Label29: TLabel;
    EditCertiorariParcelID: TEdit;
    CertiorariSwisLookupCombo: TwwDBLookupCombo;
    Label30: TLabel;
    Label31: TLabel;
    EditCertiorariLegalAddrNumber: TEdit;
    EditCertiorariLegalAddrName: TEdit;
    EditCertiorariStreetNameOnly: TEdit;
    EditCertiorariOwnerName: TEdit;
    EditCertiorariNumber: TEdit;
    EditCertiorariPetitionerName: TEdit;
    EditCertiorariAlternateID: TEdit;
    GroupBox4: TGroupBox;
    Label32: TLabel;
    Label33: TLabel;
    CertiorariSpecificYearEdit: TEdit;
    CertiorariAllYearsCheckBox: TCheckBox;
    Panel10: TPanel;
    CertiorariGrid: TwwDBGrid;
    edRawOldSBL: TEdit;
    ParcelTablePrintKey: TStringField;
    ParcelTableAssessedValue: TStringField;
    procedure ParcelRadioGroupClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure SBLSegmentExit(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure EditDashDotExit(Sender: TObject);
    procedure LegalAddrChange(Sender: TObject);
    procedure StreetNameChange(Sender: TObject);
    procedure NameChange(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
    procedure ParcelDataSourceDataChange(Sender: TObject; Field: TField);
    procedure ExitButtonClick(Sender: TObject);
    procedure ParcelTableCalcFields(DataSet: TDataset);
    procedure ParcelGridCalcCellColors(Sender: TObject; Field: TField;
      State: TGridDrawState; highlight: Boolean; AFont: TFont;
      ABrush: TBrush);
    procedure SwisLookupCombo2Exit(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure ParcelGridTitleButtonClick(Sender: TObject;
      AFieldName: String);
    procedure SwisLookupCombo2CloseUp(Sender: TObject; LookupTable,
      FillTable: TDataSet; modified: Boolean);
    procedure SwisLookupComboCloseUp(Sender: TObject; LookupTable,
      FillTable: TDataSet; modified: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure GrievanceTableCalcFields(DataSet: TDataSet);
    procedure GrievanceGridCalcCellColors(Sender: TObject; Field: TField;
      State: TGridDrawState; Highlight: Boolean; AFont: TFont;
      ABrush: TBrush);
    procedure SetFocusTimerTimer(Sender: TObject);
    procedure PageControlChange(Sender: TObject);
    procedure GrievanceRadioGroupClick(Sender: TObject);
    procedure EditGrievanceParcelIDChange(Sender: TObject);
    procedure GrievanceSwisLookupComboCloseUp(Sender: TObject; LookupTable,
      FillTable: TDataSet; modified: Boolean);
    procedure EditGrievanceLegalAddrChange(Sender: TObject);
    procedure EditGrievanceStreetNameOnlyChange(Sender: TObject);
    procedure EditGrievanceOwnerNameChange(Sender: TObject);
    procedure EditGrievanceNumberChange(Sender: TObject);
    procedure EditGrievancePetitionerNameChange(Sender: TObject);
    procedure GrievanceAllYearsCheckBoxClick(Sender: TObject);
    procedure GrievanceSpecificYearEditChange(Sender: TObject);
    procedure EditGrievanceAlternateIDChange(Sender: TObject);
    procedure GrievanceTableAfterScroll(DataSet: TDataSet);
    procedure ParcelTableFilterRecord(DataSet: TDataSet;
      var Accept: Boolean);
    procedure EditAccountNumberChange(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure CancelButtonClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure edRawOldSBLChange(Sender: TObject);
  private
    { Private declarations }
    PresentIndex : Integer;  {What is the present index?}
  public
    UnitName : String;
    FirstTimeResizing,
    InitializingForm,
    EnterOrTabPressed,
    ChangingIndexes : Boolean;
    OldApplicationState : TWindowState;
    SetFocusControl : TWinControl;
    lcpAccountNumber : Integer;

    TempGrievanceTable : TwwTable;
    TempGrievanceSwisCode,
    IndexNumberFieldName, IndexNumberIndexName : String;
    TempGrievanceRadioGroup : TRadioGroup;
    TempGrievanceGrid : TwwDBGrid;
    TempGrievanceGroupBox : TGroupBox;
    TempGrievanceNotebook : TNotebook;
    TempGrievanceAllYearsCheckBox : TCheckBox;
    TempGrievanceSwisLookupCombo : TwwDBLookupCombo;
    TempGrievanceAlternateIDEdit,
    TempGrievanceSpecificYearEdit, TempGrievanceParcelIDEdit,
    TempGrievanceLegalAddrNumEdit, TempGrievanceLegalAddrEdit,
    TempGrievanceStreetNameEdit, TempGrievanceOwnerNameEdit,
    TempGrievancePetitionerNameEdit, TempGrievanceIndexNumberEdit : TEdit;

    AllowMultiSelect : Boolean;
    SwisSBLKeyList : TStringList;
    OriginalParcelGridWidth : Integer;
    ButtonClicked : Boolean;

    { Public declarations }
    procedure SetParcelGridForIndex(IndexType : Integer);

  end;

  Procedure FindThisParcel(Table : TTable;
                           SwisSBLKey : String);

  Procedure RelocateParcelByGrievanceTable(TempGrievanceTable : TTable;
                                           Index : Integer;
                                           IndexNumberFieldName : String;
                                           GlblLastLocateInfoRec : GlblLastLocateInfoRecord);

  Procedure SetLastLocateInfoRec(var GlblLastLocateInfoRec : GlblLastLocateInfoRecord;
                                     LocatePage : Char;
                                     LocateKey : Integer;
                                     TempTable : TTable;
                                     IndexNumberFieldName : String;
                                     SpecificGrievanceYear : String);

var
  LocateParcelForm: TLocateParcelForm;

implementation

uses GlblVars, PASUTILS, UTILEXSD,  Utilitys, WinUtils, GlblCnst,
     ParcelToolbar, GrievanceUtilitys;

{$R *.DFM}

const
  AccountNumberLocateLabel = ' Account Number';

{===============================================================}
Procedure FindThisParcel(Table : TTable;
                         SwisSBLKey : String);

{Scroll forward in this key until we find this Swis SBL - could happen if
 there is more than one JONES MARY for example.}

var
  Done, _Found : Boolean;
  TempSwisSBLKey : String;

begin
  _Found := False;
  Done := False;

  repeat
    Table.Next;

    If Table.EOF
      then Done := True;

    If (Pos('Parcel', Table.TableName) > 0)
      then TempSwisSBLKey := ExtractSSKey(Table)
      else TempSwisSBLKey := Table.FieldByName('SwisSBLKey').Text;

    If (Take(26, TempSwisSBLKey) = Take(26, SwisSBLKey))
      then _Found := True;

  until (_Found or Done);

end;  {FindThisParcel}

{=====================================================================}
Procedure RelocateParcelByGrievanceTable(TempGrievanceTable : TTable;
                                         Index : Integer;
                                         IndexNumberFieldName : String;
                                         GlblLastLocateInfoRec : GlblLastLocateInfoRecord);

begin
  case Index of
    lcGParcelID : FindNearestOld(TempGrievanceTable, ['SwisSBLKey'],
                                 [GlblLastLocateInfoRec.LastSwisSBLKey]);

    lcGLegalAddress :
          begin
            FindNearestOld(TempGrievanceTable, ['LegalAddrInt', 'LegalAddr'],
                           [IntToStr(GlblLastLocateInfoRec.LastLegalAddrInt),
                            GlblLastLocateInfoRec.LastLegalAddr]);

            If (TempGrievanceTable.FieldByName('SwisSBLKey').Text <>
                GlblLastLocateInfoRec.LastSwisSBLKey)
              then FindThisParcel(TempGrievanceTable,
                                  GlblLastLocateInfoRec.LastSwisSBLKey);

          end;  {Legal address}

    lcGStreetName :
          begin
            FindNearestOld(TempGrievanceTable, ['LegalAddr', 'LegalAddrInt'],
                           [GlblLastLocateInfoRec.LastLegalAddr,
                            IntToStr(GlblLastLocateInfoRec.LastLegalAddrInt)]);

            If (TempGrievanceTable.FieldByName('SwisSBLKey').Text <>
                GlblLastLocateInfoRec.LastSwisSBLKey)
              then FindThisParcel(TempGrievanceTable,
                                  GlblLastLocateInfoRec.LastSwisSBLKey);

          end;  {Street name}

    lcGOwnerName :
          begin
            FindNearestOld(TempGrievanceTable, ['CurrentName1'],
                           [GlblLastLocateInfoRec.LastOwnerName]);


            If (TempGrievanceTable.FieldByName('SwisSBLKey').Text <>
                GlblLastLocateInfoRec.LastSwisSBLKey)
              then FindThisParcel(TempGrievanceTable,
                                  GlblLastLocateInfoRec.LastSwisSBLKey);

          end;  {By petitioner name}

    lcGOldParcelID :
          begin
            FindNearestOld(TempGrievanceTable, ['OldParcelID'],
                           [GlblLastLocateInfoRec.LastSwisSBLKey]);

          end;  {Old Parcel ID}

    lcGPetitionerName :
          begin
            FindNearestOld(TempGrievanceTable, ['PetitName1'],
                           [GlblLastLocateInfoRec.LastPetitionerName]);


            If (TempGrievanceTable.FieldByName('SwisSBLKey').Text <>
                GlblLastLocateInfoRec.LastSwisSBLKey)
              then FindThisParcel(TempGrievanceTable,
                                  GlblLastLocateInfoRec.LastSwisSBLKey);

          end;  {By petitioner name}

    lcGIndexNumber : FindNearestOld(TempGrievanceTable, [IndexNumberFieldName],
                                    [IntToStr(GlblLastLocateInfoRec.LastIndexNumber)]);

  end;  {case Index of}

end;  {RelocateParcelByGrievanceTable}

{===============================================================}
Procedure TLocateParcelForm.FormCreate(Sender: TObject);

{FXX06102001-1: Move the FirstTimeResizing variable to here so
                that it never gets reset.}

begin
  FirstTimeResizing := True;
  OldParcelIDLabel.Caption := '';
  LandAssessedValueLabel.Caption := '';
  TotalAssessedValueLabel.Caption := '';
  PropertyClassLabel.Caption := '';
  OriginalParcelGridWidth := ParcelGrid.Width;

end;  {FormCreate}

{===============================================================}
Procedure SetHistoryRangeForParcelTable(ParcelTable : TTable;
                                        TaxRollYr : String;
                                        CurrentIndex : Integer);

{FXX03192003-1(2.06q1): Sometimes the history range was not being set for on the parcel table.}

begin
  case CurrentIndex of
    lcPParcelLongFormat,
    lcPParcelID : SetRangeOld(ParcelTable,
                              ['TaxRollYr', 'SwisCode', 'Section', 'Subsection',
                               'Block', 'Lot', 'Sublot', 'Suffix'],
                              [TaxRollYr, '      ', '', '', '', '', '', ''],
                              [TaxRollYr, '999999', '', '', '', '', '', '']);

    lcPLegalAddress : SetRangeOld(ParcelTable,
                                  ['TaxRollYr', 'LegalAddrInt', 'LegalAddr'],
                                  [TaxRollYr, '0', ''],
                                  [TaxRollYr, '999999', '']);

    lcPStreetName : SetRangeOld(ParcelTable,
                                ['TaxRollYr', 'LegalAddr', 'LegalAddrInt'],
                                [TaxRollYr, Take(25, ''), '0'],
                                [TaxRollYr, ConstStr('Z', 25), '999999']);

    lcPOwnerName : SetRangeOld(ParcelTable, ['TaxRollYr', 'Name1'],
                               [TaxRollYr, Take(30, '')],
                               [TaxRollYr, ConstStr('Z', 30)]);

    lcPParcelID_No_Swis : SetRangeOld(ParcelTable,
                              ['TaxRollYr', 'Section', 'Subsection',
                               'Block', 'Lot', 'Sublot', 'Suffix'],
                              [TaxRollYr, '', '', '', '', '', ''],
                              [TaxRollYr, '999', '', '', '', '', '']);

  end;  {case CurrentIndex of}

end;  {SetHistoryRangeForParcelTable}

{===============================================================}
Procedure TLocateParcelForm.FormShow(Sender: TObject);

var
  I : Integer;
  SBLRec : SBLRecord;
  FirstParcelLookup : Boolean;
  TempStr : String;
  ShortSwis : String;

begin
    {CHG12022004-8(2.8.1.1): Display acct # instead of swis code.}

  If GlblParcelMaint_DisplayAccountNumber
    then ParcelTable.FieldByName('SwisCode').Visible := False
    else ParcelTable.FieldByName('AccountNo').Visible := False;

    {CHG11092004-1(2.8.0.19)[1972]: Prevent the searcher from exiting.}

  ButtonClicked := False;

  If (GlblUserIsSearcher and
      GlblPreventSearcherExit)
    then ExitButton.Visible := False;

  lcpAccountNumber := -2;
  FirstParcelLookup := True;
    {FXX02232000-2: Problem with large fonts - the screen is cut off.}
    {However, don't maximize for mapping.}

  If ((Application.MainForm.WindowState = wsMaximized) and
      (Pos('Map', Application.Title) = 0))
    then WindowState := wsMaximized;

  UnitName := 'PRCLOCAT';
  InitializingForm := True;
  ChangingIndexes := False;
  OldApplicationState := Application.MainForm.WindowState;

    {CHG08252003-1(2.07i): Allow for multi-select in parcel locate for condo copy and parcel list.}

  If AllowMultiSelect
    then
      begin
        ParcelGrid.MultiSelectOptions := [msoShiftSelect];
        ParcelGrid.Options := ParcelGrid.Options + [dgMultiSelect];
      end  {If AllowMultiSelect}
    else
      begin
        ParcelGrid.MultiSelectOptions := [];
        ParcelGrid.Options := ParcelGrid.Options - [dgMultiSelect];
      end;  {else of If AllowMultiSelect}

    {If this is the history file, then we want to
     set the files to read only. We also want to set a filter
     to only include the year that they have selected for history.}

     {Note that we do not have to filter any tables where the tax roll year
      is already used as part of the lookup or set range key
      (i.e. the parcel table).}

  If (GlblTaxYearFlg = 'H')
    then
      begin
        (*SetFilterForTaxYear(ParcelTable);
        SetFilterForTaxYear(SwisCodeTable);*)
      end;  {If (GlblTaxYearFlg = 'History')}

    {There are so many tables on this form, we will
     set the table name and open them implicitly (except the
     trace table. OpenTablesForForm is a method in PASUTILS}

  CloseTablesForForm(Self);

    {FXX04071998-1: Be sure to reset the table names back to
                    the DDF's so that they can be set to
                    the proper year in case the person is
                    switching back and forth between years.}

  SwisCodeTable.TableName := SwisCodeTableName;
  ParcelLookupTable.TableName := ParcelTableName;
  ParcelTable.TableName := ParcelTableName;
  AssessmentYearControlTable.TableName := AssessmentYearControlTableName;
  AssessmentTable.TableName := AssessmentTableName;
  GrievanceTable.TableName := '';
  CertiorariTable.TableName := '';
  SmallClaimsTable.TableName := '';
  RestrictedParcelTable.TableName := '';
  ParcelTable.Filtered := False;

  OpenTablesForForm(Self, GlblProcessingType);

    {CHG04102003-5(2.07): Restrict parcels for the searcher.}

  If (GlblUseRestrictSearcherParcelsFeature and
      GlblUserIsSearcher)
    then
      try
        RestrictedParcelTable.TableName := 'RestrictedParcelTable';
        RestrictedParcelTable.Open;
        ParcelTable.Filtered := True;
      except
      end;

  If GlblUsesGrievances
    then
      begin
        GrievanceTable.TableName := GrievanceTableName;
        CertiorariTable.TableName := CertiorariTableName;
        SmallClaimsTable.TableName := SmallClaimsTableName;

        try
          GrievanceTable.Open;
        except
          SystemSupport(001, GrievanceTable, 'Error opening grievance table.',
                        UnitName, GlblErrorDlgBox);
        end;

        try
          CertiorariTable.Open;
        except
          SystemSupport(002, CertiorariTable, 'Error opening Certiorari table.',
                        UnitName, GlblErrorDlgBox);
        end;

        try
          SmallClaimsTable.Open;
        except
          SystemSupport(003, SmallClaimsTable,  'Error opening small claims table.',
                        UnitName, GlblErrorDlgBox);
        end;


      end;  {If GlblUsesGrievances}

  ParcelGrid.RefreshDisplay;

    {CHG03202000-1: For Ramapo remapping.}

  If GlblLocateByOldParcelID
    then
      begin
        If (ParcelRadioGroup.Items.IndexOf(' Old Parcel ID') < 0)
          then ParcelRadioGroup.Items.Add(' Old Parcel ID');

        If (GrievanceKeyRadioGroup.Items.IndexOf(' Old Parcel ID') < 0)
          then GrievanceKeyRadioGroup.Items.Add(' Old Parcel ID');

        If (SmallClaimsKeyRadioGroup.Items.IndexOf(' Old Parcel ID') < 0)
          then SmallClaimsKeyRadioGroup.Items.Add(' Old Parcel ID');

        If (CertiorariKeyRadioGroup.Items.IndexOf(' Old Parcel ID') < 0)
          then CertiorariKeyRadioGroup.Items.Insert(lcGOldParcelID, ' Old Parcel ID');

      end;  {If GlblLocateByOldParcelID}

  If (GlblUseAccountNumberLookup and
      (ParcelRadioGroup.Items.IndexOf(AccountNumberLocateLabel) = -1))
    then ParcelRadioGroup.Items.Add(AccountNumberLocateLabel);

  If GlblUseAccountNumberLookup
    then lcpAccountNumber := ParcelRadioGroup.Items.IndexOf(AccountNumberLocateLabel);

  If GlblLocateByOldParcelID
    then OldParcelIDLabel.Visible := True;

    {CHG05132002-1: Let them lookup by grievance number.}
    {FXX11192002-1: Use TabVisible property not visible.}

  If ((not GlblUsesGrievances) or
      GlblUserIsSearcher)
    then
      begin
        GrievanceTabSheet.TabVisible := False;
        SmallClaimsTabSheet.TabVisible := False;
        CertiorariTabSheet.TabVisible := False;
      end;

    {CHG12202002-1: Additional security for certs.}

  If not GlblCanSeeCertiorari
    then CertiorariTabSheet.TabVisible := False;

    {CHG11162004-5(2.8.0.21)[]: User can choose default parcel ID lookup.}

  If (Trim(GlblLastLocateInfoRec.LastSwisSBLKey) = '')
    then
      begin
        case GlblParcelLocateDefault of
          pldParcelID : PresentIndex := lcPParcelID;
          pldParcelIDLongFormat : PresentIndex := lcPParcelLongFormat;
          pldLegalAddress : PresentIndex := lcPLegalAddress;
          pldStreetName : PresentIndex := lcPStreetName;
          pldOwnerName : PresentIndex := lcPOwnerName;
          pldOldParcelID : PresentIndex := lcPOldParcelID;
          pldAccountNumber : PresentIndex := lcpAccountNumber;

        end;  {case GlblParcelLocateDefault of}

        ParcelRadioGroup.ItemIndex := PresentIndex;
      end
    else PresentIndex := GlblLastLocateInfoRec.LastLocateKey;

  PageControl.ActivePage := ParcelTabSheet;

  with PageControl do
    case GlblLastLocateInfoRec.LastLocatePage of
      'P' : ActivePage := ParcelTabSheet;
      'G' : ActivePage := GrievanceTabSheet;
      'S' : ActivePage := SmallClaimsTabSheet;
      'C' : ActivePage := CertiorariTabSheet;

    end;  {case GlblLastLocateInfoRec.LastLocatePage of}

    {CHG11042002-2: If this is the first time in and the user
                    is a cert only user, default to the cert page.}

  If (GlblCertiorariOnly and
      (GlblLastLocateInfoRec.LastLocatePage = ' '))
    then PageControl.ActivePage := CertiorariTabSheet;

  PageControlChange(Sender);

    {FXX08262003-2(2.07i): Make sure the grievance, small claims and certiorari grids
                           get refreshed.}

  If (Deblank(GlblLastLocateInfoRec.LastSwisSBLKey) <> '')
    then FirstParcelLookup := False;

    {Setup of parcel info.}

  If (PageControl.ActivePage = ParcelTabSheet)
    then
      begin
        with ParcelTable do
          begin
              {Set up the titles for the columns.}

            FieldByName('SwisCode').DisplayLabel := 'Swis';
            FieldByName('Section').DisplayLabel := 'Sec';
            FieldByName('Subsection').DisplayLabel := 'Sbs';
            FieldByName('Block').DisplayLabel := 'Blk';
            FieldByName('Lot').DisplayLabel := 'Lot';
            FieldByName('Sublot').DisplayLabel := 'Sbl';
            FieldByName('Suffix').DisplayLabel := 'Sfx';
            FieldByName('Name1').DisplayLabel := 'Name';
            FieldByName('LegalAddrNo').DisplayLabel := 'Addr #';
            FieldByName('LegalAddr').DisplayLabel := 'Address';
            FieldByName('AccountNo').DisplayLabel := 'Acct #';
            FieldByName('PrintKey').DisplayLabel := 'Print Key';
            FieldByName('PropertyClassCode').DisplayLabel := 'Cls';
            FieldByName('AssessedValue').DisplayLabel := 'AV';

              {Set up the lengths for the SBL parts - they will be constant.}

            FieldByName('SwisCode').DisplayWidth := 6;
            FieldByName('Section').DisplayWidth := 4;
            FieldByName('Subsection').DisplayWidth := 4;
            FieldByName('Block').DisplayWidth := 5;
            FieldByName('Lot').DisplayWidth := 4;
            FieldByName('Sublot').DisplayWidth := 4;
            FieldByName('Suffix').DisplayWidth := 5;
            FieldByName('PrintKey').DisplayWidth := 15;
            FieldByName('PropertyClassCode').DisplayWidth := 4;
            FieldByName('AssessedValue').DisplayWidth := 9;

          end;  {with ParcelTable do}

        Navigator.DataSource := ParcelDataSource;

        If (GlblLastLocateInfoRec.LastLocateKey = -1)
          then ParcelRadioGroup.ItemIndex := lcPParcelID
          else ParcelRadioGroup.ItemIndex := GlblLastLocateInfoRec.LastLocateKey;

        If GlblLocateByOldParcelID
          then OldParcelIDLabel.Visible := True;

          {Clear all edit boxes.}

        For I := 0 to (ComponentCount - 1) do
          If (Components[I] is TEdit)
            then TEdit(Components[I]).Text := '';

        SetParcelGridForIndex(PresentIndex);

          {FXX11191999-6: Swis code is showing twice in swis code table - need range.
                          As it turns out, parcel tables had same problem, but no one knew
                          because all of one year appeared together since 1st part of
                          index is year.}
          {FXX01132000-5: Still showing duplicate swis codes in history.  This is
                          because the index does not have the history year as a segment
                          so must use a filter.}

        SwisCodeTable.wwFilter.Clear;

        If (GlblProcessingType = History)
          then
            begin
              SwisCodeTable.wwFilter.Add('TaxRollYr = ' + GlblHistYear);

                {FXX03192003-1(2.06q1): Sometimes the history range was not being set for on the parcel table.}

              SetHistoryRangeForParcelTable(ParcelTable, GlblHistYear, PresentIndex);

              SwisCodeTable.FilterActivate;

            end;  {If (ProcessingType = 'H')}

          {If there was a previous parcel looked up, look it up and fill in
           the edit boxes with the info.}

        If (Trim(GlblLastLocateInfoRec.LastSwisSBLKey) <> '')
          then
            begin
              FirstParcelLookup := False;
              SBLRec := ExtractSwisSBLFromSwisSBLKey(GlblLastLocateInfoRec.LastSwisSBLKey);

              try
                If (GlblLocateByOldParcelID and
                    (ParcelRadioGroup.ItemIndex = lcPOldParcelID))
                  then
                    begin
                      ParcelLookupTable.IndexName := 'BYREMAPOLDSBL';

                        {FXX01292003-1: Lookup on the old parcel ID, not the
                                        main swis sbl key.}

                      FindKeyOld(ParcelLookupTable, ['RemapOldSBL'],
                                 [GlblLastLocateInfoRec.LastOldParcelID]);
                    end
                  else
                    begin
                      ParcelLookupTable.IndexName := ParcelTable_Year_Swis_SBLKey;
                      with SBLRec do
                        FindKeyOld(ParcelLookupTable,
                                   ['TaxRollYr', 'SwisCode',
                                    'Section', 'Subsection',
                                    'Block', 'Lot', 'Sublot', 'Suffix'],
                                   [GetTaxRlYr, SwisCode, Section, Subsection,
                                    Block, Lot, Sublot, Suffix]);
                    end;
              except
                SystemSupport(005, ParcelLookupTable, 'Error getting parcel record.',
                              UnitName, GlblErrorDlgBox);
              end;

              with ParcelTable do
                begin
                  case ParcelRadioGroup.ItemIndex of
                    lcPParcelLongFormat :
                        begin  {Long format SBL}
                          GotoCurrent(ParcelLookupTable);

                          ShortSwis := Copy(FieldByName('SwisCode').Text, 5, 2);
                          SwisLookupCombo.Text := ShortSwis;
                          FindKeyOld(SwisCodeTable, ['SWISShortCode'],
                                     [ShortSwis]);

                            {FXX04071998-2: Make sure the municipality label
                                            is synched up always.}

                          MunicNameLabel.Caption := SwisCodeTableMunicipalityName.Text;

                          EditSection.Text := FieldByName('Section').Text;
                          EditSubsection.Text := FieldByName('Subsection').Text;
                          EditBlock.Text := FieldByName('Block').Text;
                          EditLot.Text := FieldByName('Lot').Text;
                          EditSublot.Text := FieldByName('Sublot').Text;
                          EditSuffix.Text := FieldByName('Suffix').Text;
                          EditSection.SetFocus;

                        end;  {Long format SBL}

                    lcPParcelID,
                    lcPOldParcelID :
                        begin  {Dash dot format}
                            {FXX05312002-1: Make sure that the
                                            page is set correctly for
                                            the old parcel ID lookup.}

                          If ((ParcelRadioGroup.ItemIndex = lcPParcelID) or
                              GlblLocateByOldParcelID)
                            then
                              begin
                                ParcelNotebook.PageIndex := 1;
                                GotoCurrent(ParcelLookupTable);
                                TempStr := ExtractSSKey(ParcelTable);

                                ShortSwis := Copy(FieldByName('SwisCode').Text, 5, 2);
                                SwisLookupCombo2.Text := ShortSwis;
                                FindKeyOld(SwisCodeTable, ['SWISShortCode'],
                                           [ShortSwis]);

                                  {FXX04071998-2: Make sure the municipality label
                                                  is synched up always.}

                                MunicNameLabel2.Caption := SwisCodeTableMunicipalityName.Text;

                                  {CHG03202000-1: For Ramapo remapping.}

                                If (GlblLocateByOldParcelID and
                                    (ParcelRadioGroup.ItemIndex = lcPOldParcelID))
                                  then EditDashDot.Text := ConvertSwisSBLToOldDashDotNoSwis(GlblLastLocateInfoRec.LastOldParcelID,
                                                                                            AssessmentYearControlTable)
                                  else EditDashDot.Text := ConvertSwisSBLToDashDotNoSwis(GlblLastLocateInfoRec.LastSwisSBLKey);
                                EditDashDot.SetFocus;

                              end;  {If ((ParcelRadioGroup.ItemIndex = lcPParcelID) or ...}

                        end;   {Dash dot format}

                    lcPLegalAddress :
                        begin  {Legal addr \ no}
                          FindKeyOld(ParcelTable,
                                     ['TaxRollYr', 'LegalAddrInt', 'LegalAddr'],
                                     [GetTaxRlYr, ParcelLookupTable.FieldByName('LegalAddrInt').Text,
                                      Take(30, ParcelLookupTable.FieldByName('LegalAddr').Text)]);

                            {We may need to scroll to find this parcel.}

                          If (ExtractSSKey(ParcelTable) <> GlblLastLocateInfoRec.LastSwisSBLKey)
                            then FindThisParcel(ParcelTable, GlblLastLocateInfoRec.LastSwisSBLKey);

                          ShortSwis := Copy(FieldByName('SwisCode').Text, 5, 2);
                          SwisLookupCombo.Text := Copy(GlblDefaultSwisCode, 5, 2);
                          SwisLookupCombo2.Text := Copy(GlblDefaultSwisCode, 5, 2);
                          FindKeyOld(SwisCodeTable, ['SWISShortCode'],
                                     [ShortSwis]);

                          EditLegalAddrNo.Text := FieldByName('LegalAddrInt').Text;
                          EditLegalAddr.Text := FieldByName('LegalAddr').Text;
                          EditLegalAddrNo.SetFocus;

                        end;   {Legal addr \ no}

                    lcPStreetName :
                         begin  {Legal addr}
                           FindKeyOld(ParcelTable,
                                      ['TaxRollYr', 'LegalAddr', 'LegalAddrInt'],
                                      [GetTaxRlYr, Take(30, ParcelLookupTable.FieldByName('LegalAddr').Text),
                                       ParcelLookupTable.FieldByName('LegalAddrInt').Text]);

                            {We may need to scroll to find this parcel.}

                          If (ExtractSSKey(ParcelTable) <> GlblLastLocateInfoRec.LastSwisSBLKey)
                            then FindThisParcel(ParcelTable, GlblLastLocateInfoRec.LastSwisSBLKey);

                          ShortSwis := Copy(GlblDefaultSwisCode, 5, 2);
                          SwisLookupCombo.Text := ShortSwis;
                          SwisLookupCombo2.Text := ShortSwis;
                          FindKeyOld(SwisCodeTable, ['SWISShortCode'],
                                     [ShortSwis]);
                          EditStreetName.Text := FieldByName('LegalAddr').Text;
                          EditStreetName.SetFocus;

                        end;   {Legal addr}

                    lcPOwnerName :
                        begin  {Name}
                          FindKeyOld(ParcelTable, ['TaxRollYr', 'Name1'],
                                     [GetTaxRlYr, Take(30, ParcelLookupTable.FieldByName('Name1').Text)]);

                            {We may need to scroll to find this parcel.}

                          If (ExtractSSKey(ParcelTable) <> GlblLastLocateInfoRec.LastSwisSBLKey)
                            then FindThisParcel(ParcelTable, GlblLastLocateInfoRec.LastSwisSBLKey);

                          TempStr := ExtractSSKey(ParcelTable);

                          ShortSwis := Copy(GlblDefaultSwisCode, 5, 2);
                          SwisLookupCombo.Text := ShortSwis;
                          SwisLookupCombo2.Text := ShortSwis;
                          FindKeyOld(SwisCodeTable, ['SWISShortCode'],
                                     [ShortSwis]);

                          EditName.Text := FieldByName('Name1').Text;
                          EditName.SetFocus;

                        end;   {Name}

                  end;  {case ParcelRadioGroup.ItemIndex of}

                    {Note that the account number is a variable since it can
                     be in different positions in the index list and so it can't appear above.}
                     {CHG04222003-1(2.07): Locate parcel by account number.}

                  If (ParcelRadioGroup.ItemIndex = lcpAccountNumber)
                    then
                      begin
                        FindKeyOld(ParcelTable, ['AccountNo'],
                                   [ParcelLookupTable.FieldByName('AccountNo').Text]);

                          {We may need to scroll to find this parcel.}

                        If (ExtractSSKey(ParcelTable) <> GlblLastLocateInfoRec.LastSwisSBLKey)
                          then FindThisParcel(ParcelTable, GlblLastLocateInfoRec.LastSwisSBLKey);

                        TempStr := ExtractSSKey(ParcelTable);

                        ShortSwis := Copy(GlblDefaultSwisCode, 5, 2);
                        SwisLookupCombo.Text := ShortSwis;
                        SwisLookupCombo2.Text := ShortSwis;
                        FindKeyOld(SwisCodeTable, ['SWISShortCode'],
                                   [ShortSwis]);

                        EditAccountNumber.Text := FieldByName('AccountNo').Text;
                        EditAccountNumber.SetFocus;

                      end;  {If (ParcelRadioGroup.ItemIndex = lcpAccountNumber)}

                end;  {with ParcelTable do}

            end
          else
            begin
              SwisLookupCombo.Text := Copy(GlblDefaultSwisCode, 5, 2);
              SwisLookupCombo2.Text := Copy(GlblDefaultSwisCode, 5, 2);

                {FXX11211997-4: Make sure that the swis code table is synched
                                up with the default.}

              FindKeyOld(SwisCodeTable, ['SWISShortCode'],
                         [SwisLookupCombo.Text]);

              If (Deblank(SwisLookupCombo2.Text) = '')
                then MunicNameLabel2.Caption := ''
                else MunicNameLabel2.Caption := SwisCodeTableMunicipalityName.Text;

              If (Deblank(SwisLookupCombo.Text) = '')
                then MunicNameLabel.Caption := ''
                else MunicNameLabel.Caption := SwisCodeTableMunicipalityName.Text;

                {FXX03021998-9: Make sure swis code is selected.}

              If (ParcelRadioGroup.ItemIndex = lcpAccountNumber)
                then EditAccountNumber.SetFocus
                else
                  case ParcelRadioGroup.ItemIndex of
                    lcPParcelLongFormat :
                        begin
                          SwisLookupCombo.SetFocus;
                          SwisLookupCombo.SelectAll;
                        end;

                    lcPParcelID :
                        begin
                          SwisLookupCombo2.SetFocus;
                          SwisLookupCombo2.SelectAll;
                        end;

                    lcPLegalAddress : EditLegalAddrNo.SetFocus;
                    lcPStreetName : EditStreetName.SetFocus;
                    lcPOwnerName : EditName.SetFocus;

                  end;  {case RadioGroup.ItemIndex of}

            end;  {else of If _Found}

          {If there is just one swis, then we will fill it in.}

        TempStr := ExtractSSKey(ParcelTable);

          {CHG06222003-1(2.07e): Allow for lookup without swis code if system option is on.
                                 As long as all parcel IDs are unique, this is OK.}

        If ((SwisCodeTable.RecordCount = 1) or
            GlblDefaultToNoSwisRequiredOnParcelIDLookup)
          then
            begin
              If (SwisCodeTable.RecordCount = 1)
                then
                  begin
                    SwisLookupCombo.Text := SwisCodeTable.FieldByName('SwisShortCode').Text;
                    SwisLookupCombo2.Text := SwisCodeTable.FieldByName('SwisShortCode').Text;
                  end
                else
                  begin
                    SwisLookupCombo.Text := '';
                    SwisLookupCombo2.Text := '';
                  end;

              case ParcelRadioGroup.ItemIndex of
                lcPParcelLongFormat : EditSection.SetFocus;
                lcPParcelID : EditDashDot.SetFocus;

              end;  {case RadioGroup.ItemIndex of}

            end;  {If (SwisCodeTable.RecordCount = 1)}

          {CHG11181997-1: For the searcher, need a way to exit parcel view.}
          {CHG11231997-1: Now, whether or not the cancel or exit button is visible
                          is passed into ExecuteParcelLocateDialog.}

        GlblUserPressedParcelExit := False;

        ParcelGrid.Visible := True;
        TempStr := ExtractSSKey(ParcelTable);

      end;  {If (ActivePage = ParcelTabSheet)}
      
    {If this is the first time in to the parcel locate, default
     what information shows in the grievance pages.}

  If (GlblUsesGrievances and
      (GlblLastLocateInfoRec.LastLocatePage = ' '))
    then
      begin
        GrievanceTable.Last;
        TempGrievanceAllYearsCheckBox := GrievanceAllYearsCheckBox;
        TempGrievanceTable := GrievanceTable;
(*        TempGrievanceSpecificYearEdit := GrievanceSpecificYearEdit;
        GrievanceSpecificYearEdit.Text := GrievanceTable.FieldByName('TaxRollYr').Text; *)

        TempGrievanceAllYearsCheckBox := SmallClaimsAllYearsCheckBox;
        TempGrievanceTable := SmallClaimsTable;
        TempGrievanceSpecificYearEdit := SmallClaimsSpecificYearEdit;
        SmallClaimsSpecificYearEdit.Text := GrievanceTable.FieldByName('TaxRollYr').Text;

        TempGrievanceAllYearsCheckBox := CertiorariAllYearsCheckBox;
        TempGrievanceTable := CertiorariTable;
        TempGrievanceSpecificYearEdit := CertiorariSpecificYearEdit;
        CertiorariAllYearsCheckBox.Checked := True;

        GrievanceTable.First;

      end;  {If (GlblUsesGrievances and...}
      
  If ((PageControl.ActivePage = GrievanceTabSheet) or
      (PageControl.ActivePage = SmallClaimsTabSheet) or
      (PageControl.ActivePage = CertiorariTabSheet))
    then
      begin
        If (GlblLastLocateInfoRec.LastLocatePage <> ' ')
          then
            begin
              GrievanceRadioGroupClick(Sender);
              TempGrievanceNotebook.PageIndex := TempGrievanceRadioGroup.ItemIndex;

              RelocateParcelByGrievanceTable(TempGrievanceTable, PresentIndex,
                                             IndexNumberFieldName,
                                             GlblLastLocateInfoRec);

            end;  {If (GlblLastLocatePage <> ' ')}

      end;  {If ((ActivePage = GrievanceTabSheet) or...}

  InitializingForm := False;
  EnterOrTabPressed := False;

    {FXX03192003-4(2.06q1): Make sure to refresh the parcel information when come back to
                            look up another parcel.}
    {FXX07012003-3(2.07e): Make sure to refresh the grid for all tabs.}

  If not FirstParcelLookup
    then
      begin
        If (PageControl.ActivePage = ParcelTabSheet)
          then ParcelDataSourceDataChange(Sender, nil);

        If (PageControl.ActivePage = GrievanceTabSheet)
          then
            begin
              GrievanceTable.Refresh;
              GrievanceTableAfterScroll(GrievanceTable);
              GrievanceGrid.Refresh;
            end;

        If (PageControl.ActivePage = SmallClaimsTabSheet)
          then
            begin
              SmallClaimsTable.Refresh;
              GrievanceTableAfterScroll(SmallClaimsTable);
            end;

        If (PageControl.ActivePage = CertiorariTabSheet)
          then
            begin
              CertiorariTable.Refresh;
              GrievanceTableAfterScroll(CertiorariTable);
            end;

      end;  {If not FirstParcelLookup}

    {FXX06032008-1(2.13.1.7)[I3159]: The parcel locate show minimizes the main app.
                                     This seems to only happen in XP and is because the
                                     parcel grid is creating with a width 8 below the
                                     resized (via Align = alClient) version.
                                     I could not solve this, hence the crap below.}

  If _Compare(Abs(ParcelGrid.Width - OriginalParcelGridWidth), 10, coGreaterThan)
    then FormResize(Sender);

end;  {FormShow}

{===============================================================}
Procedure TLocateParcelForm.ParcelTableFilterRecord(    DataSet: TDataSet;
                                                    var Accept: Boolean);

var
  SwisSBLKey : String;

begin
  Accept := True;

    {CHG04102003-5(2.07): Restrict parcels for the searcher.}
    {FXX02012005-1(2.8.3.3): Do not try to filter the parcel table if the parcel table is not open.}

  If (GlblUseRestrictSearcherParcelsFeature and
      GlblUserIsSearcher and
      ParcelTable.Active and
      RestrictedParcelTable.Active)
    then
      begin
        SwisSBLKey := ExtractSSKey(ParcelTable);
        Accept := not FindKeyOld(RestrictedParcelTable, ['SwisSBLKey'], [SwisSBLKey]);
      end;

end;  {ParcelTableFilterRecord}

{===============================================================}
Procedure TLocateParcelForm.SetParcelGridForIndex(IndexType : Integer);

{Based on whatever key they select, set the index, change the order
 of the columns, and change the column sizes.}
{FXX03261998-1: Add inactive to lookup.}

begin
  with ParcelTable do
    begin
      Filter := '';
      Filtered := False;
      FieldByName('Section').Visible := True;
      FieldByName('Subsection').Visible := True;
      FieldByName('Block').Visible := True;
      FieldByName('Lot').Visible := True;
      FieldByName('Sublot').Visible := True;
      FieldByName('Suffix').Visible := True;
      FieldByName('Name1').Visible := True;
      FieldByName('LegalAddrNo').Visible := True;
      FieldByName('LegalAddr').Visible := True;
      FieldByName('NewParcelID').Visible := False;
      FieldByName('OldParcelID').Visible := False;
      FieldByName('PrintKey').Visible := False;
      FieldByName('PropertyClassCode').Visible := False;
      FieldByName('AssessedValue').Visible := False;

      If not GlblParcelMaint_DisplayAccountNumber
        then FieldByName('AccountNo').Visible := False;

        {CHG03042001-1: Look up by LegalAddrInt instead of the text addr #.}

      case IndexType of
        lcPParcelLongFormat,
        lcPParcelID :
              begin {Swis / SBL code}
                If glblUseExactPrintKey
                then IndexName := 'ByPrintKey'
                else IndexName := ParcelTable_Year_Swis_SBLKey;

                FieldByName('InactiveParcel').Index := 0;

                  {CHG12022004-8(2.8.1.1): Display acct # instead of swis code.}

                If GlblParcelMaint_DisplayAccountNumber
                  then FieldByName('AccountNo').Index := 1
                  else FieldByName('SwisCode').Index := 1;

                FieldByName('Section').Index := 2;
                FieldByName('Subsection').Index := 3;
                FieldByName('Block').Index := 4;
                FieldByName('Lot').Index := 5;
                FieldByName('Sublot').Index := 6;
                FieldByName('Suffix').Index := 7;
                FieldByName('Name1').Index := 8;
                FieldByName('LegalAddrNo').Index := 9;
                FieldByName('LegalAddr').Index := 10;

                FieldByName('Name1').DisplayWidth := 19;
                FieldByName('LegalAddrNo').DisplayWidth := 5;
                FieldByName('LegalAddr').DisplayWidth := 18;

              end;  {Swis \ S/B/L}

        lcPParcelID_No_Swis :
              begin {SBL \ swis code}
                IndexName := 'BYTAXROLLYr_SBLKEY';

                FieldByName('InactiveParcel').Index := 0;
                FieldByName('Section').Index := 1;
                FieldByName('Subsection').Index := 2;
                FieldByName('Block').Index := 3;
                FieldByName('Lot').Index := 4;
                FieldByName('Sublot').Index := 5;
                FieldByName('Suffix').Index := 6;

                  {CHG12022004-8(2.8.1.1): Display acct # instead of swis code.}

                If GlblParcelMaint_DisplayAccountNumber
                  then FieldByName('AccountNo').Index := 7
                  else FieldByName('SwisCode').Index := 7;

                FieldByName('Name1').Index := 8;
                FieldByName('LegalAddrNo').Index := 9;
                FieldByName('LegalAddr').Index := 10;

                FieldByName('Name1').DisplayWidth := 19;
                FieldByName('LegalAddrNo').DisplayWidth := 5;
                FieldByName('LegalAddr').DisplayWidth := 18;

              end;  {SBL \ swis code}

        lcPLegalAddress :
              begin {Legal address}
                IndexName := 'BYYEAR_LEGALADDRINT_LEGALADDR';
                FieldByName('InactiveParcel').Index := 0;
                FieldByName('LegalAddrNo').Index := 1;
                FieldByName('LegalAddr').Index := 2;

                  {CHG12022004-8(2.8.1.1): Display acct # instead of swis code.}

                If GlblParcelMaint_DisplayAccountNumber
                  then FieldByName('AccountNo').Index := 3
                  else FieldByName('SwisCode').Index := 3;

                FieldByName('Section').Index := 4;
                FieldByName('Subsection').Index := 5;
                FieldByName('Block').Index := 6;
                FieldByName('Lot').Index := 7;
                FieldByName('Sublot').Index := 8;
                FieldByName('Suffix').Index := 9;
                FieldByName('Name1').Index := 10;

                FieldByName('Name1').DisplayWidth := 13;
                FieldByName('LegalAddrNo').DisplayWidth := 6;
                FieldByName('LegalAddr').DisplayWidth := 24;

              end;  {Legal address}

        lcPStreetName :
              begin {Street name}
                IndexName := 'BYYEAR_LEGALADDR_LEGALADDRINT';

                FieldByName('InactiveParcel').Index := 0;
                FieldByName('LegalAddr').Index := 1;
                FieldByName('LegalAddrNo').Index := 2;

                  {CHG12022004-8(2.8.1.1): Display acct # instead of swis code.}

                If GlblParcelMaint_DisplayAccountNumber
                  then FieldByName('AccountNo').Index := 3
                  else FieldByName('SwisCode').Index := 3;

                FieldByName('Section').Index := 4;
                FieldByName('Subsection').Index := 5;
                FieldByName('Block').Index := 6;
                FieldByName('Lot').Index := 7;
                FieldByName('Sublot').Index := 8;
                FieldByName('Suffix').Index := 9;
                FieldByName('Name1').Index := 10;

                FieldByName('Name1').DisplayWidth := 13;
                FieldByName('LegalAddrNo').DisplayWidth := 6;
                FieldByName('LegalAddr').DisplayWidth := 24;

              end;  {Street name}

        lcPOwnerName :
              begin  {Name}
                IndexName := 'BYYEAR_NAME';

                  {FXX03261998-2: Fixed problem of fields being in wrong
                                  order when switch from street name to
                                  name index by setting field indices in
                                  ascending order.}

                FieldByName('InactiveParcel').Index := 0;
                FieldByName('Name1').Index := 1;

                  {CHG12022004-8(2.8.1.1): Display acct # instead of swis code.}

                If GlblParcelMaint_DisplayAccountNumber
                  then FieldByName('AccountNo').Index := 2
                  else FieldByName('SwisCode').Index := 2;

                FieldByName('Section').Index := 3;
                FieldByName('Subsection').Index := 4;
                FieldByName('Block').Index := 5;
                FieldByName('Lot').Index := 6;
                FieldByName('Sublot').Index := 7;
                FieldByName('Suffix').Index := 8;
                FieldByName('LegalAddrNo').Index := 9;
                FieldByName('LegalAddr').Index := 10;

                FieldByName('Name1').DisplayWidth := 25;
                FieldByName('LegalAddrNo').DisplayWidth := 6;
                FieldByName('LegalAddr').DisplayWidth := 12;

              end;  {Name}

        lcPOldParcelID :
              begin {Old Parcel ID}
                IndexName := 'BYREMAPOLDSBL';

                FieldByName('Section').Visible := False;
                FieldByName('Subsection').Visible := False;
                FieldByName('Block').Visible := False;
                FieldByName('Lot').Visible := False;
                FieldByName('Sublot').Visible := False;
                FieldByName('Suffix').Visible := False;
                FieldByName('Name1').Visible := True;
                FieldByName('LegalAddrNo').Visible := False;
                FieldByName('LegalAddr').Visible := False;
                FieldByName('NewParcelID').Visible := True;
                FieldByName('OldParcelID').Visible := True;

                FieldByName('InactiveParcel').Index := 0;
                FieldByName('SwisCode').Index := 1;
                FieldByName('OldParcelID').Index := 2;
                FieldByName('NewParcelID').Index := 3;
                FieldByName('Name1').Index := 4;

                FieldByName('Name1').DisplayWidth := 23;

              end;  {Swis \ S/B/L}

      end;  {case IndexType of}

      If glblLocateDisplaysPrintKey
      then
      begin
        FieldByName('SwisCode').Visible := False;
        FieldByName('Section').Visible := False;
        FieldByName('Subsection').Visible := False;
        FieldByName('Block').Visible := False;
        FieldByName('Lot').Visible := False;
        FieldByName('Sublot').Visible := False;
        FieldByName('Suffix').Visible := False;
        FieldByName('PrintKey').Visible := True;
        FieldByName('PropertyClassCode').Visible := True;
        FieldByName('AssessedValue').Visible := True;

        FieldByName('PrintKey').Index := 1;
        FieldByName('Name1').Index := 2;
        FieldByName('LegalAddrNo').Index := 3;
        FieldByName('LegalAddr').Index := 4;
        FieldByName('PropertyClassCode').Index := 5;
        FieldByName('AssessedValue').Index := 6;

        FieldByName('LegalAddr').DisplayWidth := 24;

      end;  {If glblLocateDisplaysPrintKey}
      

        {Note that the account number is a variable since it can
         be in different positions in the index list and so it can't appear above.}
        {CHG04222003-1(2.07): Locate parcel by account number.}

      If (IndexType = lcPAccountNumber)
        then
          begin
            IndexName := 'BYACCOUNTNO';

              {FXX01172007-1(2.11.1.9): History locate by account number did not work
                                        because the assessment year was not part of the index.}

            If (GlblProcessingType = History)
              then
                begin
                  Filter := 'TaxRollYr = ' + FormatFilterString(GlblHistYear);
                  Filtered := True;
                end;

            FieldByName('Section').Visible := False;
            FieldByName('Subsection').Visible := False;
            FieldByName('Block').Visible := False;
            FieldByName('Lot').Visible := False;
            FieldByName('Sublot').Visible := False;
            FieldByName('Suffix').Visible := False;
            FieldByName('Name1').Visible := True;
            FieldByName('LegalAddrNo').Visible := True;
            FieldByName('LegalAddr').Visible := True;
            FieldByName('NewParcelID').Visible := True;
            FieldByName('OldParcelID').Visible := False;
            FieldByName('AccountNo').Visible := True;

            FieldByName('InactiveParcel').Index := 0;
            FieldByName('AccountNo').Index := 1;
            FieldByName('NewParcelID').Index := 2;
            FieldByName('Name1').Index := 2;
            FieldByName('LegalAddrNo').Index := 3;
            FieldByName('LegalAddr').Index := 4;

            FieldByName('AccountNo').DisplayWidth := 10;
            FieldByName('Name1').DisplayWidth := 18;
            FieldByName('LegalAddrNo').DisplayWidth := 6;
            FieldByName('LegalAddr').DisplayWidth := 20;

            FieldByName('NewParcelID').DisplayLabel := 'Parcel ID';

          end;  {If (IndexType = lcPAccountNumber)}

      ParcelTable.First;
      ParcelGrid.RefreshDisplay;

    end;  {with ParcelTable do}

  PresentIndex := IndexType;

end;  {SetParcelGridForIndex}

{===============================================================}
Procedure TLocateParcelForm.ParcelGridTitleButtonClick(Sender: TObject;
                                                       AFieldName: String);

{CHG05022000-1: Clicking the field in the grid switches to that key.}

begin
  If ((AFieldName = 'SwisCode') or
      (AFieldName = 'Section') or
      (AFieldName = 'Subsection') or
      (AFieldName = 'Block') or
      (AFieldName = 'Lot') or
      (AFieldName = 'Sublot') or
      (AFieldName = 'Suffix'))
    then ParcelRadioGroup.ItemIndex := 1;

  If (AFieldName = 'LegalAddrNo')
    then ParcelRadioGroup.ItemIndex := 2;

  If (AFieldName = 'LegalAddr')
    then ParcelRadioGroup.ItemIndex := 3;

  If (AFieldName = 'Name1')
    then ParcelRadioGroup.ItemIndex := 4;

  If (AFieldName = 'AccountNo')
    then ParcelRadioGroup.ItemIndex := lcpAccountNumber;

end;  {ParcelGridTitleButtonClick}

{===============================================================}
Procedure TLocateParcelForm.SetFocusTimerTimer(Sender: TObject);

begin
  SetFocusTimer.Enabled := False;
  SetFocusControl.SetFocus;
end;

{===============================================================}
Procedure TLocateParcelForm.ParcelRadioGroupClick(Sender: TObject);

var
  I : Integer;

begin
  If GlblLocateByOldParcelID
    then OldParcelIDLabel.Visible := True;

  If ((ParcelRadioGroup.ItemIndex <> ParcelNotebook.PageIndex) or
      ((PresentIndex = lcPOldParcelID) and
       (ParcelRadioGroup.ItemIndex = lcPParcelID)) or
      ((PresentIndex = lcPParcelID) and
       (ParcelRadioGroup.ItemIndex = lcPOldParcelID)))
    then
      begin
        ChangingIndexes := True;
        LockWindowUpdate(Handle);

          {Clear all edit boxes.}

        For I := 0 to (ComponentCount - 1) do
          If (Components[I] is TEdit)
            then TEdit(Components[I]).Text := '';

          {Now synchronize the notebook with the radio button.}

        ParcelNotebook.PageIndex := ParcelRadioGroup.ItemIndex;

        If _Compare(ParcelRadioGroup.ItemIndex, lcpAccountNumber, coEqual)
          then ParcelNotebook.PageIndex := 5;

        If (GlblLocateByOldParcelID and
            (ParcelRadioGroup.ItemIndex = lcPOldParcelID))
          then ParcelNotebook.PageIndex := 6;

        case ParcelNotebook.PageIndex of
          lcPParcelLongFormat :
              begin  {Long SBL Format}
                ParcelGroupBox.Caption := ' Enter Parcel ID: ';

                  {If they were in the other SBL format, we don't
                   need to set up the grid again.}

                If (PresentIndex <> lcPParcelID)
                  then SetParcelGridForIndex(lcPParcelID);

                  {CHG06222003-1(2.07e): Allow for lookup without swis code if system option is on.
                                         As long as all parcel IDs are unique, this is OK.}

                If ((SwisCodeTable.RecordCount = 1) or
                    GlblDefaultToNoSwisRequiredOnParcelIDLookup)
                  then EditSection.SetFocus
                  else SwisLookupCombo.SetFocus;

              end;  {Long SBL Format}

          lcPParcelID :
              begin  {Dash Dot format}
                ParcelGroupBox.Caption := ' Enter Parcel ID: ';

                  {If they were in the other SBL format, we don't
                   need to set up the grid again.}

                If ((PresentIndex <> lcPParcelID) and
                    (ParcelRadioGroup.ItemIndex = lcPParcelID))
                  then SetParcelGridForIndex(lcPParcelID);

                If ((PresentIndex <> lcPOldParcelID) and
                    (ParcelRadioGroup.ItemIndex = lcPOldParcelID) and
                    GlblLocateByOldParcelID)
                  then SetParcelGridForIndex(lcPOldParcelID);

                  {FXX03282002-1: If there is only 1 swis code, when
                                  switch indices be sure to skip swis
                                  code box.}

                  {CHG06222003-1(2.07e): Allow for lookup without swis code if system option is on.
                                         As long as all parcel IDs are unique, this is OK.}

                If ((SwisCodeTable.RecordCount = 1) or
                    GlblDefaultToNoSwisRequiredOnParcelIDLookup)
                  then EditDashDot.SetFocus
                  else SwisLookupCombo2.SetFocus;

              end;   {Dash Dot format}

          lcPLegalAddress :
              begin {Legal address}
                ParcelGroupBox.Caption := ' Enter Legal Address: ';
                SetParcelGridForIndex(lcPLegalAddress);
                EditLegalAddrNo.SetFocus;

              end;  {Legal address}

          lcPStreetName :
              begin {Street Name}
                ParcelGroupBox.Caption := ' Enter Street Name: ';
                SetParcelGridForIndex(lcPStreetName);
                EditStreetName.SetFocus;

              end;  {Street Name}

          lcPOwnerName :
              begin  {Name}
                ParcelGroupBox.Caption := ' Enter Name: ';
                SetParcelGridForIndex(lcPOwnerName);
                EditName.SetFocus;

              end;  {Name}

          lcPOldSBLRaw :
              begin  {Raw old SBL}
                ParcelGroupBox.Caption := ' Enter Old SBL: ';
                SetParcelGridForIndex(lcPOldParcelID);
                edRawOldSBL.SetFocus;

              end;  {Raw old SBL}

        end;  {case Notebook.Page of}

          {Note that the account number is a variable since it can
           be in different positions in the index list and so it can't appear above.}
          {CHG04222003-1(2.07): Locate parcel by account number.}

        If _Compare(ParcelRadioGroup.ItemIndex, lcpAccountNumber, coEqual)
          then
            begin  {Account Number}
              ParcelGroupBox.Caption := ' Enter Account Number: ';
              SetParcelGridForIndex(lcpAccountNumber);
              EditAccountNumber.SetFocus;

            end;  {Account Number}

          {FXX03192003-1(2.06q1): Sometimes the history range was not being set for on the parcel table.}

        If (GlblProcessingType = History)
          then SetHistoryRangeForParcelTable(ParcelTable, GlblHistYear, ParcelNotebook.PageIndex);

        LockWindowUpdate(0);
        ChangingIndexes := False;

      end;  {If (RadioGroup.ItemIndex <> Notebook.PageIndex)}

end;  {RadioGroupClick}

{=======================================================================}
Procedure TLocateParcelForm.ParcelTableCalcFields(DataSet: TDataset);

{FXX03261998-1: Display inactive field in parcel locate.}

var
  SwisSBLKey : String;

begin
  If (ParcelTable.FieldByName('ActiveFlag').Text = InactiveParcelFlag)
    then ParcelTableInactiveParcel.Text := '*'
    else ParcelTableInactiveParcel.Text := '';

    {CHG03202000-1: For Ramapo remapping.}

  If ((PresentIndex = lcPOldParcelID) and
      AssessmentYearControlTable.Active)
    then
      begin
        SwisSBLKey := ParcelTable.FieldByName('RemapOldSBL').Text;

          {If the swis sbl key is not 26, it is not an actual remapped SBL - it
           is old data and this was not matched.}

        If _Compare(SwisSBLKey, coBlank)
          then
            begin
                {Not yet converted.}
              SwisSBLKey := ExtractSSKey(ParcelTable);
              ParcelTableOldParcelID.Text := ConvertSBLOnlyToOldDashDot(Copy(SwisSBLKey, 7, 20),
                                                                        AssessmentYearControlTable);
            end
          else
            (*If _Compare(SwisSBLKey, ['.', '/', '-'], coContains)
            then *)
              begin
                If _Compare(Copy(SwisSBLKey, 1, 4), Copy(SwisCodeTable.FieldByName('SwisCode').AsString, 1, 4), coEqual)
                then SwisSBLKey := Copy(SwisSBLKey, 7, 20);

                ParcelTableOldParcelID.Text := ConvertSBLOnlyToOldDashDot(SwisSBLKey,
                                                                          AssessmentYearControlTable);
                SwisSBLKey := ExtractSSKey(ParcelTable);
                ParcelTableNewParcelID.Text := ConvertSBLOnlyToDashDot(Copy(SwisSBLKey, 7, 20));
              end;
      (*        else
                begin
                  ParcelTableOldParcelID.Text := ParcelTable.FieldByName('RemapOldSBL').AsString;
                  SwisSBLKey := ExtractSSKey(ParcelTable);

                  If _Compare(Copy(SwisSBLKey, 1, 4), Copy(SwisCodeTable.FieldByName('SwisCode').AsString, 1, 4), coEqual)
                  then SwisSBLKey := Copy(SwisSBLKey, 7, 20);

                  ParcelTableNewParcelID.Text := ConvertSBLOnlyToDashDot(SwisSBLKey);
                end;    *)

      end;  {If (PresentIndex = 'O')}

    {CHG04222003-1(2.07): Locate parcel by account number.}

  SwisSBLKey := ExtractSSKey(ParcelTable);

  If (PresentIndex = lcpAccountNumber)
    then ParcelTableNewParcelID.Text := ConvertSBLOnlyToDashDot(Copy(SwisSBLKey, 7, 20));

  If (*((not InitializingForm) and *)
      FindKeyOld(AssessmentTable, ['TaxRollYr', 'SwisSBLKey'], [GetTaxRlYr, SwisSBLKey])
  then ParcelTableAssessedValue.Text := FormatFloat(IntegerDisplay, AssessmentTable.FieldByName('TotalAssessedVal').AsInteger);

end;  {ParcelTableCalcFields}

{==================================================================}
Procedure TLocateParcelForm.GrievanceGridCalcCellColors(Sender: TObject;
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

{==================================================================}
Procedure TLocateParcelForm.GrievanceTableCalcFields(DataSet: TDataSet);

var
  TempStr : String;

begin
  If not InitializingForm
    then
      with Dataset as TwwTable do
        begin
            {If the SwisSBLKey is not real, then just show it as is.}

          If (PresentIndex = lcgAlternateID)
            then
              begin
                If (TableName = CertiorariTableName)
                  then FieldByName('ParcelID').Text := FieldByName('AlternateID').Text;
              end
            else
              If (Length(FieldByName('SwisSBLKey').Text) = 26)
                then FieldByName('ParcelID').Text := ConvertSwisSBLToDashDot(FieldByName('SwisSBLKey').Text)
                else FieldByName('ParcelID').Text := FieldByname('SwisSBLKey').Text;

          FieldByName('Address').Text := GetLegalAddressFromTable(TwwTable(DataSet));

          TempStr := Trim(FieldByName('LawyerCode').Text);

          If (Deblank(TempStr) <> '')
            then TempStr := '(' + TempStr + ')-';

          TempStr := TempStr + FieldByName('PetitName1').Text;
          FieldByname('CalcPetitionerName').Text := TempStr;

          If (TwwTable(Dataset).TableName = GrievanceTableName)
            then FieldByName('GrievanceNumberDisplay').Text := GetGrievanceNumberToDisplay(GrievanceTable);

        end;  {with Sender as TwwTable do}

end;  {GrievanceTableCalcFields}

{==================================================================}
Procedure TLocateParcelForm.ParcelGridCalcCellColors(Sender: TObject;
                                                     Field: TField;
                                                     State: TGridDrawState;
                                                     highlight: Boolean;
                                                     AFont: TFont;
                                                     ABrush: TBrush);

{FXX03261998-1: Display inactive field in parcel locate.}

begin
  If (Field.FieldName = 'InactiveParcel')
    then
      begin
        AFont.Color := clRed;
        AFont.Size := 16;
        AFont.Style := [fsBold];
      end;  {If (Field.FieldName = 'InactiveParcel')}

end;  {LocateGridCalcCellColors}

{==================================================================}
Procedure TLocateParcelForm.FormKeyDown(    Sender: TObject;
                                        var Key: Word;
                                            Shift: TShiftState);

{CHG11092004-1(2.8.0.19)[1972]: Prevent the searcher from exiting.}

begin
  If (GlblUserIsSearcher and
      GlblPreventSearcherExit and
      (Shift = [ssShift]) and
      (Key = VK_F9))
    then
      begin
        Key := 0;
        ExitButtonClick(Sender);
      end;

end;  {FormKeyDown}

{==================================================================}
Procedure TLocateParcelForm.FormKeyPress(    Sender: TObject;
                                         var Key: Char);

begin
    {FXX01211998-8: Need to know how they are exiting an entry field -
                    if they are clicking out, do not synch grid to
                    what they entered. Otherwise, do.}

  EnterOrTabPressed := False;

  If (Key = #13)
    then
      begin
          {If they hit enter in the grid, then go to that parcel.}

        If ((Screen.ActiveControl.Name = 'ParcelGrid') or
            (Screen.ActiveControl.Name = 'GrievanceGrid') or
            (Screen.ActiveControl.Name = 'CertiorariGrid'))
          then OKButtonClick(Sender)
          else
            begin
              Key := #0;
              EnterOrTabPressed := True;
              Perform(WM_NEXTDLGCTL, 0, 0);
            end;

      end;  {If (Key = #13)}

  If (Key = #9)
    then EnterOrTabPressed := True;

end;  {FormKeyPress}

{==============================================================}
Procedure TLocateParcelForm.SwisLookupComboCloseUp(Sender: TObject;
                                                   LookupTable,
                                                   FillTable: TDataSet;
                                                   modified: Boolean);

{Set the municipality name.}

begin
  If (Deblank(SwisLookupCombo.Text) = '')
    then MunicNameLabel.Caption := ''
    else MunicNameLabel.Caption := SwisCodeTableMunicipalityName.Text;

end;  {SwisLookupComboCloseUp}

{============================================================}
Procedure TLocateParcelForm.SwisLookupCombo2CloseUp(Sender: TObject;
                                                    LookupTable,
                                                    FillTable: TDataSet;
                                                    modified: Boolean);

{Set the municipality name.}

begin
  If (Deblank(SwisLookupCombo2.Text) = '')
    then MunicNameLabel2.Caption := ''
    else MunicNameLabel2.Caption := SwisCodeTableMunicipalityName.Text;

end;  {SwisLookupCombo2CloseUp}

{==============================================================}
Procedure TLocateParcelForm.SwisLookupCombo2Exit(Sender: TObject);

{FXX05131999-7: If the person changes the swis last, then pressed OK, want to make sure
                that the correct parcel is _Found.}

begin
  If (Screen.ActiveControl.Name = 'OKButton')
    then EditDashDotExit(Sender);

end;  {SwisLookupCombo2Exit}

{==============================================================}
Procedure TLocateParcelForm.SBLSegmentExit(Sender: TObject);

var
  ValidEntry : Boolean;
  TempStr : String;

begin
  ValidEntry := True;

  with Sender as TEdit do
    begin
      TempStr := Text;

      case Tag of
        0: ValidEntry := FormatSegment('section', TempStr, 3,
                                       GlblSectionFormat, True);
        1: ValidEntry := FormatSegment('subsection', TempStr, 3,
                                       GlblSubsectionFormat, True);
        2: ValidEntry := FormatSegment('block', TempStr, 4,
                                       GlblBlockFormat, True);
        3: ValidEntry := FormatSegment('lot', TempStr, 3,
                                       GlblLotFormat, True);
        4: ValidEntry := FormatSegment('sublot', TempStr, 3,
                                       GlblSublotFormat, True);
        5: ValidEntry := FormatSegment('suffix', TempStr, 4,
                                       GlblSuffixFormat, True);

      end;  {case Tag of}

      Text := TempStr;

      Refresh;

    end;  {with Sender as TEdit do}

    {If we just exited the suffix field, then look up the SBL.}
    {ENH10081996 - If they don't enter a swis code, then we will lookup on the
                   key SBL\swis code. Otherwise we will lookup on the swis/sbl code.
                   Note that we will adjust the grid to the way that they are looking
                   up.}

    {CHG06222003-1(2.07e): Allow for lookup without swis code if system option is on.
                           As long as all parcel IDs are unique, this is OK.}
                          {Also add scroll as enter each segment.}

  If ValidEntry
    then
      begin
        If (TEdit(Sender).Tag = 5)
          then
            begin
              SwisLookupCombo.SetFocus;
              SwisLookupCombo.SelectAll;
            end;

        If (Deblank(SwisLookupCombo.Text) = '')
          then
            begin
                {Do we need to change to the SBL\swis key and grid?}

              If (PresentIndex <> lcPParcelID_No_Swis)
                then SetParcelGridForIndex(lcPParcelID_No_Swis);

              try
                FindNearestOld(ParcelTable,
                               ['TaxRollYr', 'Section', 'Subsection',
                                'Block', 'Lot', 'Sublot', 'Suffix'],
                               [ParcelTableTaxRollYr.Text,
                                Take(3, EditSection.Text),
                                Take(3, EditSubsection.Text),
                                Take(4, EditBlock.Text),
                                Take(3, EditLot.Text),
                                Take(3, EditSublot.Text),
                                Take(4, EditSuffix.Text)]);
              except
                MessageDlg('That parcel ID could not be located.' + #13 +
                           'Please try again.', mtError, [mbOK], 0);
              end;

              If (TEdit(Sender).Tag = 5)
                then ParcelGrid.SetFocus;

            end
          else
            begin
                {Do we need to change to the swis\SBL key and grid?}
                {FXX04272001-1: Not doing long format lookup correctly.}

              If (PresentIndex <> lcPParcelID)
                then SetParcelGridForIndex(lcPParcelID);

              try
                FindNearestOld(ParcelTable,
                               ['TaxRollYr', 'SwisCode',
                                'Section', 'Subsection',
                                'Block', 'Lot', 'Sublot',
                                'Suffix'],
                               [ParcelTableTaxRollYr.Text,
                                SwisCodeTableSwisCode.Text,
                                Take(3, EditSection.Text),
                                Take(3, EditSubsection.Text),
                                Take(4, EditBlock.Text),
                                Take(3, EditLot.Text),
                                Take(3, EditSublot.Text),
                                Take(4, EditSuffix.Text)]);
              except
                MessageDlg('That parcel ID could not be located.' + #13 +
                           'Please try again.', mtError, [mbOK], 0);
              end;

              If (TEdit(Sender).Tag = 5)
                then ParcelGrid.SetFocus;

            end;  {else of If (Deblank(SwisLookupCombo.Text) = '')}

      end;  {If (ValidEntry and ...}

end;  {SBLSegmentExit}

{===============================================================}
Procedure TLocateParcelForm.EditDashDotExit(Sender: TObject);

var
  SBLRec : SBLRecord;
  ValidEntry : Boolean;
  SwisSBLKey, sAssessmentYear, sPrintKey : String;

begin
    {CHG01022013 - Option to use the exact print key.}

  If (glblUseExactPrintKey and
      _Compare(ParcelTable.IndexName, 'ByPrintKey', coEqual))
  then FindNearestOld(ParcelTable, ['PrintKey'], [EditDashDot.Text])
  else
  begin
    {FXX01211998-8: Need to know how they are exiting an entry field -
                    if they are clicking out, do not synch grid to
                    what they entered. Otherwise, do.}
    {FXX02061998-7: If the user clicked OK we want to process the SBL too.}
    {CHG03262001-2: Allow for active lookup.}

(*  If ((EnterOrTabPressed or
      (Screen.ActiveControl.Name = 'OKButton'))
    then
      begin *)
        ValidEntry := False;

          {CHG03202000-1: For Ramapo remapping.}

        sPrintKey := EditDashDot.Text;

        try
          If _Compare(TEdit(Sender).Name, 'edRawOldSBL', coEqual)
          then sPrintKey := edRawOldSBL.Text;
        except
        end;

        If _Compare(sPrintKey, coNotBlank)
          then
            If (PresentIndex = lcPOldParcelID)
              then SBLRec := ConvertOldDashDotSBLToSegmentSBL(sPrintKey,
                                                              AssessmentYearControlTable,
                                                              ValidEntry)
              else SBLRec := ConvertDashDotSBLToSegmentSBL(sPrintKey,
                                                           ValidEntry);

        If ValidEntry
          then
            begin
              If ((Deblank(SwisLookupCombo2.Text) = '') and
                  (PresentIndex <> lcPOldParcelID)) 
                then
                  begin
                      {Do we need to change to the SBL\swis key and grid?}

                    If (PresentIndex <> lcPParcelID_No_Swis)
                      then SetParcelGridForIndex(lcPParcelID_No_Swis);

(*                    FindKeyOld(SwisCodeTable, ['SWISShortCode'],
                               [SwisLookupCombo2.Text]);*)

                      {FXX12201999-2: Lookup by just SBL did not work because
                                      swis code was in search key.}
                      {FXX06192001-1: Still didn't work because SwisCode was
                                      part of the tabel index.}

                    case GlblProcessingType of
                      ThisYear : sAssessmentYear := GlblThisYear;
                      NextYear : sAssessmentYear := GlblNextYear;
                      History : sAssessmentYear := GlblHistYear;
                    end;

                    try
                      with SBLRec do
                        FindNearestOld(ParcelTable,
                                      ['TaxRollYr',
                                        'Section', 'Subsection',
                                        'Block', 'Lot', 'Sublot', 'Suffix'],
                                       [sAssessmentYear,
                                        Take(3,Section),
                                        Take(3,Subsection),
                                        Take(4,Block),
                                        Take(3,Lot),
                                        Take(3,Sublot),
                                        Take(4,Suffix)]);
                    except
                      MessageDlg('That parcel ID could not be located.' + #13 +
                                 'Please try again.', mtError, [mbOK], 0);
                    end;

                  end
                else
                  begin
                      {Do we need to change to the swis\SBL key and grid?}

                    If ((PresentIndex <> lcPParcelID) and
                        (PresentIndex <> lcPOldParcelID))
                      then SetParcelGridForIndex(lcPParcelID);

                      {FXX04161999-2: Need to make sure we get the current swis code.}

                    FindKeyOld(SwisCodeTable, ['SWISShortCode'],
                               [SwisLookupCombo2.Text]);

                      {CHG03202000-1: For Ramapo remapping.}

                    If (GlblLocateByOldParcelID and
                        (PresentIndex = lcPOldParcelID))
                      then
                        begin
                            {FXX04242000-6: In lookup had sublot in suffix pos.}

                          with SBLRec do
                            SwisSBLKey := Take(6, SwisCodeTableSwisCode.Text) +
                                          Take(3, Section) +
                                          Take(3, Subsection) + Take(4, Block) +
                                          Take(3, Lot) + Take(3, Sublot) +
                                          Take(4, Suffix);

                          If not glblRemapOldSBLHasSwis
                          then SwisSBLKey := Copy(SwisSBLKey, 7, 20);

                          FindNearestOld(ParcelTable, ['RemapOldSBL'],
                                         [SwisSBLKey]);
                        end
                      else
                        try
                          with SBLRec do
                            FindNearestOld(ParcelTable,
                                           ['TaxRollYr', 'SwisCode',
                                            'Section', 'Subsection',
                                            'Block', 'Lot', 'Sublot', 'Suffix'],
                                           [ParcelTableTaxRollYr.Text,
                                            SwisCodeTableSwisCode.Text,
                                            Take(3,Section),
                                            Take(3,Subsection),
                                            Take(4,Block),
                                            Take(3,Lot),
                                            Take(3,Sublot),
                                            Take(4,Suffix)]);
                        except
                          MessageDlg('That parcel ID could not be located.' + #13 +
                                     'Please try again.', mtError, [mbOK], 0);
                        end;

                  end;  {else of If (Deblank(SwisLookupCombo2.Text) = '')}

            end  {If ValidEntry}
          else SetFocus;

        EnterOrTabPressed := False;

  end;  {else of If glblUseExactPrintKey}
  
(*      end;  {If EnterOrTabPressed}*)

end;  {EditDashDotExit}

{===========================================================}
Procedure TLocateParcelForm.LegalAddrChange(Sender: TObject);

{Key sensitive lookup.}
{CHG06102001-2: Allow for lookup by legal addr # with letter.}

var
  LetterPos : Integer;
  TempLegalAddrNo : String;

begin
  If not (InitializingForm or ChangingIndexes)
    then
      begin
        LetterPos := FindFirstNonNumberInText(EditLegalAddrNo.Text);

        case LetterPos of
          0 : TempLegalAddrNo := EditLegalAddrNo.Text;
          1 : TempLegalAddrNo := '0';
          else TempLegalAddrNo := Copy(EditLegalAddrNo.Text, 1, (LetterPos - 1));

        end;  {case LetterPos of}

        FindNearestOld(ParcelTable,
                       ['TaxRollYr', 'LegalAddrInt', 'LegalAddr'],
                       [ParcelTableTaxRollYr.Text,
                        TempLegalAddrNo,
                        EditLegalAddr.Text]);

      end;  {If not (InitializingForm or ChangingIndexes)}

end;  {LegalAddrChange}

{===========================================================}
Procedure TLocateParcelForm.StreetNameChange(Sender: TObject);

begin
  If not (InitializingForm or ChangingIndexes)
    then FindNearestOld(ParcelTable, ['TaxRollYr', 'LegalAddr'],
                        [ParcelTableTaxRollYr.Text,
                         EditStreetName.Text]);
end;

{===========================================================}
Procedure TLocateParcelForm.NameChange(Sender: TObject);

begin
  If not (InitializingForm or ChangingIndexes)
    then FindNearestOld(ParcelTable, ['TaxRollYr', 'Name1'],
                        [ParcelTableTaxRollYr.Text,
                         EditName.Text]);
end;

{===========================================================}
Procedure TLocateParcelForm.EditAccountNumberChange(Sender: TObject);

begin
  If not (InitializingForm or ChangingIndexes)
    then FindNearestOld(ParcelTable, ['AccountNo'],
                        [EditAccountNumber.Text]);

end;  {EditAccountNumberChange}

{===========================================================}
Procedure TLocateParcelForm.ParcelDataSourceDataChange(Sender: TObject;
                                                 Field: TField);

{Refresh the SBL display if they are looking up by SBL.}

var
  SwisSBLKey, FormatString : String;
  _Found : Boolean;

begin
  If (GlblLocateByOldParcelID and
      (not InitializingForm) and
      (Field = nil))
    then SetOldParcelIDLabel(OldParcelIDLabel, ParcelTable,
                             AssessmentYearControlTable);

    {CHG04262000-2: Display total, assessed values for selected parcel.}

  If ((not InitializingForm) and
      (Field = nil))
    then
      begin
        SwisSBLKey := ExtractSSKey(ParcelTable);
        _Found := FindKeyOld(AssessmentTable, ['TaxRollYr', 'SwisSBLKey'],
                             [GetTaxRlYr, SwisSBLKey]);

        If _Found
          then
            with AssessmentTable do
              begin
                  {CHG04262007-1(2.11.1.26): Allow for option to suppress $ on assessments.}

                FormatString := GetAssessmentDisplayFormat;

                LandAssessedValueLabel.Caption := 'Land: ' +
                                                  FormatFloat(FormatString,
                                                              FieldByName('LandAssessedVal').AsFloat);
                TotalAssessedValueLabel.Caption := 'Total: ' +
                                                    FormatFloat(FormatString,
                                                                FieldByName('TotalAssessedVal').AsFloat);
              end;  {with AssessmentTable do}

          {CHG12082003-1(2.07k1): Include the ownership code on the property class.}

        PropertyClassLabel.Caption := 'Cls: ' + ParcelTable.FieldByName('PropertyClassCode').Text +
                                      ParcelTable.FieldByName('OwnershipCode').Text;


      end;  {If ((not InitializingForm) and ...}

end;  {ParcelDataSourceDataChange}

{=========================================================}
Procedure TLocateParcelForm.PageControlChange(Sender: TObject);

{Show or hide the extra display labels depending on what tab they are on.}

var
  ExtraLabelsVisible : Boolean;

begin
  ExtraLabelsVisible := (PageControl.ActivePage = ParcelTabSheet);

  LandAssessedValueLabel.Visible := ExtraLabelsVisible;
  TotalAssessedValueLabel.Visible := ExtraLabelsVisible;
  PropertyClassLabel.Visible := ExtraLabelsVisible;

  with PageControl do
    begin
      If (ActivePage = ParcelTabSheet)
        then Navigator.DataSource := ParcelDataSource;

      If (ActivePage = GrievanceTabSheet)
        then
          begin
            Navigator.DataSource := GrievanceDataSource;
            TempGrievanceTable := GrievanceTable;
            IndexNumberFieldName := 'GrievanceNumber';
            IndexNumberIndexName := 'BYGREVNUM';
            TempGrievanceRadioGroup := GrievanceKeyRadioGroup;
            TempGrievanceGrid := GrievanceGrid;
            TempGrievanceGroupBox := GrievanceGroupBox;
            TempGrievanceNotebook := GrievanceLookupNotebook;
            TempGrievanceAllYearsCheckBox := GrievanceAllYearsCheckBox;
            TempGrievanceSpecificYearEdit := GrievanceSpecificYearEdit;
            TempGrievanceSwisLookupCombo := GrievanceSwisLookupCombo;
            TempGrievanceParcelIDEdit := EditGrievanceParcelID;
            TempGrievanceLegalAddrNumEdit := EditGrievanceLegalAddrNumber;
            TempGrievanceLegalAddrEdit := EditGrievanceLegalAddrName;
            TempGrievanceStreetNameEdit := EditGrievanceStreetNameOnly;
            TempGrievanceOwnerNameEdit := EditGrievanceOwnerName;
            TempGrievancePetitionerNameEdit := EditGrievancePetitionerName;
            TempGrievanceIndexNumberEdit := EditGrievanceNumber;
            TempGrievanceAlternateIDEdit := nil;

          end;  {If (ActivePage = GrievanceTabSheet)}

      If (ActivePage = SmallClaimsTabSheet)
        then
          begin
            Navigator.DataSource := SmallClaimsDataSource;
            TempGrievanceTable := SmallClaimsTable;
            IndexNumberFieldName := 'IndexNumber';
            IndexNumberIndexName := 'BYINDEXNUM';
            TempGrievanceRadioGroup := SmallClaimsKeyRadioGroup;
            TempGrievanceGrid := SmallClaimsGrid;
            TempGrievanceGroupBox := SmallClaimsGroupBox;
            TempGrievanceNotebook := SmallClaimsLookupNotebook;
            TempGrievanceAllYearsCheckBox := SmallClaimsAllYearsCheckBox;
            TempGrievanceSpecificYearEdit := SmallClaimsSpecificYearEdit;
            TempGrievanceSwisLookupCombo := SmallClaimsSwisLookupCombo;
            TempGrievanceParcelIDEdit := EditSmallClaimsParcelID;
            TempGrievanceLegalAddrNumEdit := EditSmallClaimsLegalAddrNumber;
            TempGrievanceLegalAddrEdit := EditSmallClaimsLegalAddrName;
            TempGrievanceStreetNameEdit := EditSmallClaimsStreetNameOnly;
            TempGrievanceOwnerNameEdit := EditSmallClaimsOwnerName;
            TempGrievancePetitionerNameEdit := EditSmallClaimsPetitionerName;
            TempGrievanceIndexNumberEdit := EditSmallClaimsNumber;
            TempGrievanceAlternateIDEdit := nil;

          end;  {If (ActivePage = SmallClaimsTabSheet)}

      If (ActivePage = CertiorariTabSheet)
        then
          begin
            Navigator.DataSource := CertiorariDataSource;
            TempGrievanceTable := CertiorariTable;
            IndexNumberFieldName := 'CertiorariNumber';
            IndexNumberIndexName := 'BYCERTNUM';
            TempGrievanceRadioGroup := CertiorariKeyRadioGroup;
            TempGrievanceGrid := CertiorariGrid;
            TempGrievanceGroupBox := CertiorariGroupBox;
            TempGrievanceNotebook := CertiorariLookupNotebook;
            TempGrievanceAllYearsCheckBox := CertiorariAllYearsCheckBox;
            TempGrievanceSpecificYearEdit := CertiorariSpecificYearEdit;
            TempGrievanceSwisLookupCombo := CertiorariSwisLookupCombo;
            TempGrievanceParcelIDEdit := EditCertiorariParcelID;
            TempGrievanceLegalAddrNumEdit := EditCertiorariLegalAddrNumber;
            TempGrievanceLegalAddrEdit := EditCertiorariLegalAddrName;
            TempGrievanceStreetNameEdit := EditCertiorariStreetNameOnly;
            TempGrievanceOwnerNameEdit := EditCertiorariOwnerName;
            TempGrievancePetitionerNameEdit := EditCertiorariPetitionerName;
            TempGrievanceIndexNumberEdit := EditCertiorariNumber;
            TempGrievanceAlternateIDEdit := EditCertiorariAlternateID;

          end;  {If (ActivePage = CertiorariTabSheet)}

        {FXX12162002-1: Synch up the PresentIndex with the index is
                        selected when they switch pages.}
        {FXX08262003-2(2.07i): Make sure to refresh the view when switching tabs.}

      If (ActivePage <> ParcelTabSheet)
        then
          begin
            GrievanceRadioGroupClick(Sender);
            TempGrievanceTable.Refresh;
          end;

    end;  {with PageControl do}

end;  {PageControlChange}

{====================================================================}
Procedure TLocateParcelForm.GrievanceRadioGroupClick(Sender: TObject);

var
  TempStr, ParcelColumnLabel : String;

begin
  If (TempGrievanceRadioGroup.ItemIndex = lcGOldParcelID)
    then TempGrievanceNotebook.PageIndex := 0
    else
      If (TempGrievanceRadioGroup.ItemIndex = lcGAlternateID)
        then TempGrievanceNotebook.PageIndex := 6
        else TempGrievanceNotebook.PageIndex := TempGrievanceRadioGroup.ItemIndex;

  PresentIndex := TempGrievanceRadioGroup.ItemIndex;

  case TempGrievanceRadioGroup.ItemIndex of
    lcGParcelID :
      begin
        TempGrievanceTable.IndexName := 'BySwisSBLKey';
        TempGrievanceGroupBox.Caption := ' Enter Parcel ID: ';

          {CHG06222003-1(2.07e): Allow for lookup without swis code if system option is on.
                                 As long as all parcel IDs are unique, this is OK.}

        If ((SwisCodeTable.RecordCount = 1) or
            GlblDefaultToNoSwisRequiredOnParcelIDLookup)
          then
            begin
              SetFocusControl := TempGrievanceParcelIDEdit;
              TempGrievanceSwisCode := SwisCodeTable.FieldByName('SwisCode').Text;
            end
          else SetFocusControl := TempGrievanceSwisLookupCombo;

      end;  {lcGParcelID}

    lcGLegalAddress :
      begin
        TempGrievanceTable.IndexName := 'BYLEGALADDRINT_LEGALADDR';
        TempGrievanceGroupBox.Caption := ' Enter Legal Address: ';

        SetFocusControl := TempGrievanceLegalAddrNumEdit;

      end;  {lcGLegalAddress}

    lcGStreetName :
      begin
        TempGrievanceTable.IndexName := 'BYLEGALADDR_LEGALADDRINT';
        TempGrievanceGroupBox.Caption := ' Enter Street Name: ';
        SetFocusControl := TempGrievanceStreetNameEdit;

      end;  {lcGStreetName}

    lcGOwnerName :
      begin
        TempGrievanceTable.IndexName := 'ByOwnerName';
        TempGrievanceGroupBox.Caption := ' Enter Owner Name: ';
        SetFocusControl := TempGrievanceOwnerNameEdit;

      end;  {lcGOwnerName}

    lcGPetitionerName :
      begin
        TempGrievanceTable.IndexName := 'ByPetitionerName';
        TempGrievanceGroupBox.Caption := ' Enter Petitioner Name: ';
        SetFocusControl := TempGrievancePetitionerNameEdit;

      end;  {lcGPetitionerName}

    lcGIndexNumber :
      begin
        TempGrievanceTable.IndexName := IndexNumberIndexName;
        If (PageControl.ActivePage = GrievanceTabSheet)
          then TempStr := ' Enter Grievance Number: '
          else TempStr := ' Enter Index Number: ';

        TempGrievanceGroupBox.Caption := TempStr;
        SetFocusControl := TempGrievanceIndexNumberEdit;

      end;  {lcGIndexNumber}

    lcGOldParcelID :
      begin
        TempGrievanceTable.IndexName := 'BYREMAPOLDSBL';
        TempGrievanceGroupBox.Caption := ' Enter Old Parcel ID: ';

        If (SwisCodeTable.RecordCount = 1)
          then
            begin
              SetFocusControl := TempGrievanceParcelIDEdit;
              TempGrievanceSwisCode := SwisCodeTable.FieldByName('SwisCode').Text;
            end
          else SetFocusControl := TempGrievanceSwisLookupCombo;

      end;  {lcOldGParcelID}

    lcGAlternateID :
      begin
        TempGrievanceTable.IndexName := 'ByAlternateID';
        TempGrievanceGroupBox.Caption := ' Enter Alternate ID: ';
        SetFocusControl := TempGrievanceAlternateIDEdit;

      end;  {lcGAlternateID}

  end;  {case TempGrievanceRadioGroup.ItemIndex of}

  case TempGrievanceRadioGroup.ItemIndex of
    lcGOldParcelID : ParcelColumnLabel := 'Old Parcel ID';
    lcGAlternateID : ParcelColumnLabel := 'Alternate ID';
    else ParcelColumnLabel := 'Parcel ID';
  end;

  TempGrievanceTable.FieldByName('ParcelID').DisplayLabel := ParcelColumnLabel;

  If (SetFocusControl <> nil)
    then SetFocusTimer.Enabled := True;

end;  {GrievanceRadioGroupClick}

{=========================================================}
Procedure TLocateParcelForm.FormResize(Sender: TObject);

{FXX12301999-4: Minimize whole app if minimize locate.}

begin
(*  If (WindowState = wsMinimized)
    then
      begin
        OldApplicationState := Application.MainForm.WindowState;
        Application.MainForm.WindowState := wsMinimized;
      end;

    {FXX01132000-4: Only restore main form if is minimized.}

  If ((WindowState in [wsNormal, wsMaximized]) and
      (Application.MainForm.WindowState = wsMinimized))
    then Application.MainForm.WindowState := OldApplicationState; *)

    {FXX04032001-1: Fix the minimize.}

    {Don't do this if we are calling it from maps.}

  If (Pos('Map', Application.Title) = 0)
    then
      If FirstTimeResizing
        then FirstTimeResizing := False
        else
          begin
              {FXX03052002-1: Make sure the parcel toolbar minimizes and maximizes properly.}

            If (WindowState = wsMinimized)
              then
                begin
                  Application.MainForm.WindowState := OldApplicationState;

                  If GlblUserWantsParcelToolbar
                    then ParcelToolbarForm.Visible := True;

                end;  {If (WindowState = wsMinimized)}

              {FXX01132000-4: Only restore main form if is minimized.}

            If ((WindowState in [wsNormal, wsMaximized]) and
                (Application.MainForm.WindowState = wsNormal))
              then
                begin
                  OldApplicationState := Application.MainForm.WindowState;
                  Application.MainForm.WindowState := wsMinimized;
                  ParcelToolbarForm.Visible := False;

                end;  {If ((WindowState in [wsNormal, wsMaximized]) and}

          end;  {If FormShowing}

    {CHG02082004-5(2.08): Add resize ability to parcel locate.}

  Navigator.Left := (Self.Width - Navigator.Width) DIV 2;
  OKButton.Left := (Self.Width - OKButton.Width) DIV 2;
  OldParcelIDLabel.Left := Self.Width - 200;
  LandAssessedValueLabel.Left := Self.Width - 200;
  TotalAssessedValueLabel.Left := Self.Width - 200;
  PropertyClassLabel.Left := Self.Width - 200;
  ExitButton.Left := Self.Width - 120;

    {CHG09102004-1(2.8.0.11): Resize the grid font for a change.}

  If (ParcelTable.Active and
      (ParcelGrid.Width <> OriginalParcelGridWidth))
    then
      begin
        ResizeGridFontForWidthChange(ParcelGrid, OriginalParcelGridWidth);

        OriginalParcelGridWidth := ParcelGrid.Width;

      end;  {If ((not FormIsInitializing) and ...}

end;  {FormResize}

{====================================================================}
Procedure SetLastLocateInfoRec(var GlblLastLocateInfoRec : GlblLastLocateInfoRecord;
                                   LocatePage : Char;
                                   LocateKey : Integer;
                                   TempTable : TTable;
                                   IndexNumberFieldName : String;
                                   SpecificGrievanceYear : String);

begin
  with GlblLastLocateInfoRec, TempTable do
    begin
      LastLocateKey := LocateKey;
      LastLocatePage := LocatePage;

      LastSwisSBLKey := FieldByName('SwisSBLKey').Text;
      LastLegalAddrInt := FieldByName('LegalAddrInt').AsInteger;
      LastLegalAddr := FieldByName('LegalAddr').Text;
      LastOwnerName := FieldByName('CurrentName1').Text;
      LastPetitionerName := FieldByName('PetitName1').Text;
      LastIndexNumber := FieldByName(IndexNumberFieldName).AsInteger;
      LastOldParcelID := FieldByName('OldParcelID').Text;
      LastSpecificGrievanceYear := SpecificGrievanceYear;

    end;  {with GlblLastLocateInfoRec do}

end;  {SetLastLocateInfoRec}

{====================================================================}
Procedure TLocateParcelForm.OKButtonClick(Sender: TObject);

var
  TempLocatePage : Char;
  I : Integer;

begin
  ButtonClicked := True;
  InitGlblLastLocateInfoRec(GlblLastLocateInfoRec);

  If (PageControl.ActivePage = ParcelTabSheet)
    then
      with GlblLastLocateInfoRec do
        begin
          LastSwisSBLKey := ExtractSSKey(ParcelTable);

          If (GlblLocateByOldParcelID and
              (ParcelRadioGroup.ItemIndex = lcPOldParcelID))
            then LastOldParcelID := ParcelTable.FieldByName('RemapOldSBL').Text;

           LastLocateKey := ParcelRadioGroup.ItemIndex;
           LastLocatePage := 'P';

              {CHG08252003-1(2.07i): Allow for multi-select in parcel locate for condo copy and parcel list.}

            If AllowMultiSelect
              then
                begin
                  SwisSBLKeyList.Clear;

                  ParcelTable.DisableControls; {Disable controls to improve performance}

                  with ParcelGrid do
		    For I := 0 to (SelectedList.Count - 1) do
                      begin
			ParcelTable.GotoBookmark(SelectedList[I]);
                        SwisSBLKeyList.Add(ExtractSSKey(ParcelTable));
                      end;

  		  ParcelTable.EnableControls;  { Re-enable controls }

                    {FXX05182005-1(2.8.4.5)[2126]: Make sure to unhighlight any selected parcels.}

                  ParcelGrid.UnselectAll;

                end;  {If AllowMultiSelect}

         end;  {with GlblLastLocateInfoRec do}

  If ((PageControl.ActivePage = GrievanceTabSheet) or
      (PageControl.ActivePage = SmallClaimsTabSheet) or
      (PageControl.ActivePage = CertiorariTabSheet))
    then
      begin
        TempLocatePage := 'G';
        If (PageControl.ActivePage = GrievanceTabSheet)
          then TempLocatePage := 'G';
        If (PageControl.ActivePage = SmallClaimsTabSheet)
          then TempLocatePage := 'S';
        If (PageControl.ActivePage = CertiorariTabSheet)
          then TempLocatePage := 'C';

        SetLastLocateInfoRec(GlblLastLocateInfoRec, TempLocatePage,
                             TempGrievanceRadioGroup.ItemIndex,
                             TempGrievanceTable,
                             IndexNumberFieldName,
                             TempGrievanceSpecificYearEdit.Text);

      end;  {If ((PageControl.ActivePage = GrievanceTabSheet) or ...}

  ModalResult := mrOK;

end;  {OKButtonClick}

{====================================================================}
Procedure TLocateParcelForm.ExitButtonClick(Sender: TObject);

begin
  ButtonClicked := True;

    {CHG11181997-1: For the searcher, need a way to exit parcel view.}

  GlblUserPressedParcelExit := True;
  ModalResult := mrCancel;

end;  {ExitButtonClick}

{=====================================================================}
Procedure TLocateParcelForm.GrievanceSwisLookupComboCloseUp(Sender: TObject;
                                                            LookupTable,
                                                            FillTable: TDataSet;
                                                            modified: Boolean);

begin
  FindKeyOld(SwisCodeTable, ['SWISShortCode'], [TempGrievanceSwisLookupCombo.Text]);
  TempGrievanceSwisCode := SwisCodeTable.FieldByName('SwisCode').Text;

end;  {GrievanceSwisLookupComboCloseUp}

{=====================================================================}
Procedure TLocateParcelForm.EditGrievanceParcelIDChange(Sender: TObject);

var
  TempSBLKey, TempSwisSBLKey : String;
  ValidEntry : Boolean;
  SBLRec : SBLRecord;

begin
  If not (InitializingForm or ChangingIndexes)
    then
      begin
        TempSBLKey := TempGrievanceParcelIDEdit.Text;

          {FXX01162003-2: Had wrong parcel ID box as the argument.}

        If (PresentIndex = lcGOldParcelID)
          then SBLRec := ConvertOldDashDotSBLToSegmentSBL(TempGrievanceParcelIDEdit.Text,
                                                          AssessmentYearControlTable,
                                                          ValidEntry)
          else SBLRec := ConvertDashDotSBLToSegmentSBL(TempGrievanceParcelIDEdit.Text,
                                                       ValidEntry);

        with SBLRec do
          TempSwisSBLKey := TempGrievanceSwisCode +
                            Section + Subsection + Block +
                            Lot + Sublot + Suffix;

        If (PresentIndex = lcGParcelID)
          then FindNearestOld(TempGrievanceTable, ['SwisSBLKey'], [TempSwisSBLKey])
          else FindNearestOld(TempGrievanceTable, ['OldParcelID'], [TempSwisSBLKey]);

      end;  {If not (InitializingForm or ChangingIndexes)}

end;  {EditGrievanceParcelIDChange}

{=====================================================================}
Procedure TLocateParcelForm.EditGrievanceLegalAddrChange(Sender: TObject);

var
  LetterPos : Integer;
  TempLegalAddrNo : String;

begin
  If not (InitializingForm or ChangingIndexes)
    then
      begin
        LetterPos := FindFirstNonNumberInText(TempGrievanceLegalAddrNumEdit.Text);

        case LetterPos of
          0 : TempLegalAddrNo := TempGrievanceLegalAddrNumEdit.Text;
          1 : TempLegalAddrNo := '0';
          else TempLegalAddrNo := Copy(TempGrievanceLegalAddrNumEdit.Text, 1, (LetterPos - 1));

        end;  {case LetterPos of}

        FindNearestOld(TempGrievanceTable, ['LegalAddrInt', 'LegalAddr'],
                       [TempLegalAddrNo,
                        TempGrievanceLegalAddrEdit.Text]);

      end;  {If not (InitializingForm or ChangingIndexes)}

end;  {EditGrievanceLegalAddrChange}

{=====================================================================}
Procedure TLocateParcelForm.EditGrievanceStreetNameOnlyChange(Sender: TObject);

begin
  If not (InitializingForm or ChangingIndexes)
    then FindNearestOld(TempGrievanceTable, ['LegalAddr', 'LegalAddrInt'],
                       [TempGrievanceStreetNameEdit.Text, '0']);

end;  {EditGrievanceStreetNameOnlyChange}

{=====================================================================}
Procedure TLocateParcelForm.EditGrievanceOwnerNameChange(Sender: TObject);

begin
  If not (InitializingForm or ChangingIndexes)
    then FindNearestOld(TempGrievanceTable, ['CurrentName1'],
                       [TempGrievanceOwnerNameEdit.Text]);

end;  {EditGrievanceOwnerNameChange}

{=====================================================================}
Procedure TLocateParcelForm.EditGrievanceNumberChange(Sender: TObject);

begin
  If not (InitializingForm or ChangingIndexes)
    then FindNearestOld(TempGrievanceTable, [IndexNumberFieldName],
                       [TempGrievanceIndexNumberEdit.Text]);

end;  {EditGrievanceNumberChange}

{=====================================================================}
Procedure TLocateParcelForm.EditGrievancePetitionerNameChange(Sender: TObject);

begin
  If not (InitializingForm or ChangingIndexes)
    then FindNearestOld(TempGrievanceTable, ['PetitName1'],
                       [TempGrievancePetitionerNameEdit.Text]);

end;  {EditGrievancePetitionerNameChange}

{=====================================================================}
Procedure TLocateParcelForm.EditGrievanceAlternateIDChange(Sender: TObject);

begin
  If not (InitializingForm or ChangingIndexes)
    then FindNearestOld(TempGrievanceTable, ['AlternateID'],
                       [TempGrievanceAlternateIDEdit.Text]);

end;  {EditGrievanceAlternateIDChange}

{=====================================================================}
Procedure TLocateParcelForm.GrievanceAllYearsCheckBoxClick(Sender: TObject);

begin
  If TempGrievanceAllYearsCheckBox.Checked
    then
      begin
        TempGrievanceTable.Filtered := False;
        TempGrievanceSpecificYearEdit.Text := '';
      end;

end;  {GrievanceAllYearsCheckBoxClick}

{=====================================================================}
Procedure TLocateParcelForm.GrievanceSpecificYearEditChange(Sender: TObject);

begin
  If ((Length(TempGrievanceSpecificYearEdit.Text) = 4) and
      _Compare(TempGrievanceSpecificYearEdit.Text, coNotBlank))
    then
      begin
        TempGrievanceAllYearsCheckBox.Checked := False;

        with TempGrievanceTable do
          try
            Filter := 'TaxRollYr = ' + TempGrievanceSpecificYearEdit.Text;
            Filtered := True;
          except
          end;

      end;  {If (Length(TempGrievanceSpecificYearEdit.Text) = 4)}

end;  {GrievanceSpecificYearEditChange}

{===============================================================}
Procedure TLocateParcelForm.GrievanceTableAfterScroll(DataSet: TDataSet);

begin
    {FXX07012003-5(2.07e) Make sure to blank out old parcel ID if can't find one
                          for this parcel.}

  If OldParcelIDLabel.Visible
    then
      with DataSet as TwwTable do
        try
          If (FieldByName('OldParcelID').Text <> '')
            then OldParcelIDLabel.Caption := 'Old ID: ' +
                                             ConvertSwisSBLToOldDashDotNoSwis(FieldByName('OldParcelID').Text,
                                                                              AssessmentYearControlTable)
            else OldParcelIDLabel.Caption := '';
        except
          OldParcelIDLabel.Caption := '';
        end;

end;  {GrievanceTableAfterScroll}

{================================================================}
Procedure TLocateParcelForm.CancelButtonClick(Sender: TObject);

begin
  ButtonClicked := True;
end;

{=================================================================}
Procedure TLocateParcelForm.FormCloseQuery(    Sender: TObject;
                                           var CanClose: Boolean);


begin
    {If the searcher is trying to exit by clicking the 'X' and the
     prevent searcher from exiting option is on, prevent them.}

  If (GlblUserIsSearcher and
      GlblPreventSearcherExit and
      (not ButtonClicked))
    then CanClose := False;

end;  {FormCloseQuery}

{=========================================================}
Procedure TLocateParcelForm.edRawOldSBLChange(Sender: TObject);

begin
  If not (InitializingForm or ChangingIndexes)
    then EditDashDotExit(Sender);

    //FindNearestOld(ParcelTable, ['RemapOldSBL'], [edRawOldSBL.Text]);

end;

end.