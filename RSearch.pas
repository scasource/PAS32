unit Rsearch;

{$H+}
interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, DBCtrls, DBTables, DB, Buttons, Grids,
  Wwdbigrd, Wwdbgrid, ExtCtrls, Wwtable, Wwdatsrc, Menus, (*Progress,*)
  RPCanvas, RPrinter, RPDefine, RPBase, RPFiler, Types, TabNotBk, RPTXFilr,
  Zipcopy, ComCtrls, FileCtrl, ExpandedPrintDialog, PASTypes;

type
  NumberOfColumnsForEachFieldRecord = record
    SpecialDistricts : Integer;
    Exemptions : Integer;
    ExemptionsDenied : Integer;
    ExemptionsRemoved : Integer;
    Notes : Integer;
    ResSites : Integer;
    ResBldgs : Integer;
    ResLands : Integer;
    ResImprovements : Integer;
    Sales : Integer;
    ComSites : Integer;
    ComBuildings : Integer;
    ComLands : Integer;
    ComImprovements : Integer;
    ComUses : Integer;
    ComIncomeExpenses : Integer;
    Grievance : Integer;
    GrievanceResults : Integer;
    GrievanceExemptionsAsked : Integer;
    Certiorari : Integer;
    CertiorariNotes : Integer;
    CertiorariAppraisals : Integer;
    CertiorariCalendar : Integer;
    SmallClaims : Integer;
    SmallClaimsNotes : Integer;
    SmallClaimsAppraisals : Integer;
    SmallClaimsCalendar : Integer;

  end;  {NumberOfColumnsForEachFieldRecord = record}

  TSearchReportForm = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    ScrollBox1: TScrollBox;
    TitleLabel: TLabel;
    ParcelTable: TTable;
    ScreenLabelTable: TTable;
    SearchSelectionPanel: TPanel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    ScreenListBox: TListBox;
    LabelListBox: TListBox;
    ComparisonTypeRadioGroup: TRadioGroup;
    DoneSelectionButton: TBitBtn;
    CancelSelectionButton: TBitBtn;
    PrintDialog: TPrintDialog;
    ReportFiler: TReportFiler;
    ReportPrinter: TReportPrinter;
    FieldsToPrintPanel: TPanel;
    Label1: TLabel;
    Label9: TLabel;
    Label11: TLabel;
    FieldsToPrintScreenListBox: TListBox;
    FieldsToPrintLabelListBox: TListBox;
    DoneFieldsButton: TBitBtn;
    CancelFieldsButton: TBitBtn;
    SelectionsNotebook: TTabbedNotebook;
    GroupBox1: TGroupBox;
    SelectionGrid: TStringGrid;
    GroupBox2: TGroupBox;
    FieldsToPrintGrid: TStringGrid;
    PrintOrderRadioBox: TRadioGroup;
    GroupBox3: TGroupBox;
    TotalsToPrintGrid: TStringGrid;
    ChooseTaxYearRadioGroup: TRadioGroup;
    EditHistoryYear: TEdit;
    Label10: TLabel;
    SwisCodeListBox: TListBox;
    SwisCodeTable: TTable;
    TotalsToPrintPanel: TPanel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    TotalsToPrintScreenListBox: TListBox;
    TotalsToPrintLabelListBox: TListBox;
    DoneTotalsButton: TBitBtn;
    CancelTotalsButton: TBitBtn;
    SaveDialog: TSaveDialog;
    OpenDialog: TOpenDialog;
    SaveExportDialog: TSaveDialog;
    ZipCopyDlg: TZipCopyDlg;
    TruncateFieldsCheckBox: TCheckBox;
    ValuesStringGrid: TStringGrid;
    ExemptionListBox: TListBox;
    SpecialDistrictListBox: TListBox;
    SDCodeTable: TTable;
    ExemptionCodeTable: TTable;
    ParcelExemptionTable: TTable;
    ParcelSDTable: TTable;
    UserFieldDefinitionTable: TTable;
    Label21: TLabel;
    SchoolCodeListBox: TListBox;
    GroupBox4: TGroupBox;
    Label17: TLabel;
    Label18: TLabel;
    CreateParcelListCheckBox: TCheckBox;
    LoadFromParcelListCheckBox: TCheckBox;
    SpaceBetweenParcelsCheckBox: TCheckBox;
    SchoolCodeTable: TTable;
    Label22: TLabel;
    IncludeSwisOnParcelIDCheckBox: TCheckBox;
    AssessmentYearControlTable: TTable;
    ExtractTypeRadioGroup: TRadioGroup;
    SBLGroupBox: TGroupBox;
    Label23: TLabel;
    Label24: TLabel;
    StartSBLEdit: TEdit;
    EndSBLEdit: TEdit;
    AllSBLCheckBox: TCheckBox;
    ToEndOfSBLCheckBox: TCheckBox;
    ActiveStatusRadioGroup: TRadioGroup;
    GroupBox5: TGroupBox;
    IncludeParcelIDCheckBox: TCheckBox;
    IncludeLegalAddrCheckBox: TCheckBox;
    IncludeOwnerCheckBox: TCheckBox;
    ExtractToExcelCheckBox: TCheckBox;
    FirstLineIsHeadersCheckBox: TCheckBox;
    NullBlanksCheckBox: TCheckBox;
    RecordsToPrintOrExtractRadioGroup: TRadioGroup;
    InstalledPrinterTable: TTable;
    BlankLinesBetweenCoopsCheckBox: TCheckBox;
    CriteriaCombinationGroupBox: TGroupBox;
    Label7: TLabel;
    CombinationRadioGroup: TRadioGroup;
    PrintLabelCheckBox: TCheckBox;
    ReportLabelPrinter: TReportPrinter;
    ReportLabelFiler: TReportFiler;
    NumberOfForcedColumnsPageControl: TPageControl;
    RegularForcedColumnsTabSheet: TTabSheet;
    GroupBox6: TGroupBox;
    Label25: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    Label29: TLabel;
    Label30: TLabel;
    Label32: TLabel;
    Label33: TLabel;
    Label34: TLabel;
    Label35: TLabel;
    Label36: TLabel;
    Label37: TLabel;
    Label38: TLabel;
    Label40: TLabel;
    Label41: TLabel;
    Label42: TLabel;
    Label31: TLabel;
    SDColumnsEdit: TEdit;
    EXColumnsEdit: TEdit;
    EXDeniedColumnsEdit: TEdit;
    EXRemovedColumnsEdit: TEdit;
    ResSiteColumnsEdit: TEdit;
    ResLandColumnsEdit: TEdit;
    ResImprovementColumnsEdit: TEdit;
    ComIncExpColumnsEdit: TEdit;
    ComRentColumnsEdit: TEdit;
    ComImprovementColumnsEdit: TEdit;
    ComLandColumnsEdit: TEdit;
    ComBuildingColumnsEdit: TEdit;
    ComSiteColumnsEdit: TEdit;
    SalesColumnsEdit: TEdit;
    ResBuildingColumnsEdit: TEdit;
    GrievanceForcedColumnsTabSheet: TTabSheet;
    GroupBox7: TGroupBox;
    Label43: TLabel;
    Label45: TLabel;
    Label46: TLabel;
    Label47: TLabel;
    Label48: TLabel;
    Label59: TLabel;
    GrievanceColumnsEdit: TEdit;
    CertiorariColumnsEdit: TEdit;
    CertiorariCalendarColumnsEdit: TEdit;
    CertiorariNotesColumnsEdit: TEdit;
    CertiorariAppraisalsColumnsEdit: TEdit;
    EnhancedPrintDialog: TEnhancedPrintDialog;
    Label6: TLabel;
    EditLeftMargin: TEdit;
    Panel3: TPanel;
    ClearButton: TBitBtn;
    LoadButton: TBitBtn;
    SaveButton: TBitBtn;
    PrintButton: TBitBtn;
    CloseButton: TBitBtn;
    Panel4: TPanel;
    Label20: TLabel;
    Panel5: TPanel;
    Label19: TLabel;
    Panel6: TPanel;
    AddSelectionButton: TButton;
    DeleteSelectionButton: TButton;
    ClearSelectionsButton: TButton;
    ChangeSelectionButton: TButton;
    Panel7: TPanel;
    MailingAddressCheckBox: TCheckBox;
    WordSalutationGroupBox: TGroupBox;
    Label39: TLabel;
    EditSalutation: TEdit;
    Panel8: TPanel;
    AddFieldToPrintButton: TButton;
    DeleteFieldToPrintButton: TButton;
    ClearFieldsToPrintButton: TButton;
    ChangeFieldToPrintButton: TButton;
    Panel9: TPanel;
    Label16: TLabel;
    NewPageOnBreakCheckBox: TCheckBox;
    TotalsOnlyCheckBox: TCheckBox;
    Panel10: TPanel;
    AddTotalToPrintButton: TButton;
    DeleteTotalToPrintButton: TButton;
    ClearTotalToPrintButton: TButton;
    ChangeTotalToPrintButton: TButton;
    cbForceLetterSize: TCheckBox;
    Label8: TLabel;
    Label12: TLabel;
    SmallClaimsColumnsEdit: TEdit;
    Label44: TLabel;
    SmallClaimsAppraisalsColumnsEdit: TEdit;
    Label49: TLabel;
    Label50: TLabel;
    SmallClaimsNotesColumnsEdit: TEdit;
    SmallClaimsCalendarColumnsEdit: TEdit;
    Label51: TLabel;
    NotesColumnsEdit: TEdit;
    cbMeanMedian: TCheckBox;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure CancelSelectionButtonClick(Sender: TObject);
    procedure DoneSelectionButtonClick(Sender: TObject);
    procedure FieldsToPrintPanelExit(Sender: TObject);
    procedure AddSelectionButtonClick(Sender: TObject);
    procedure DeleteSelectionButtonClick(Sender: TObject);
    procedure ClearSelectionsButtonClick(Sender: TObject);
    procedure PrintButtonClick(Sender: TObject);
    procedure ReportFilerBeforePrint(Sender: TObject);
    procedure ReportFilerPrintHeader(Sender: TObject);
    procedure ReportFilerPrint(Sender: TObject);
    procedure ScreenListBoxClick(Sender: TObject);
    procedure AddFieldToPrintButtonClick(Sender: TObject);
    procedure DeleteFieldToPrintButtonClick(Sender: TObject);
    procedure ClearFieldsToPrintButtonClick(Sender: TObject);
    procedure CancelFieldsToPrintButtonClick(Sender: TObject);
    procedure SearchSelectionPanelExit(Sender: TObject);
    procedure DoneFieldsButtonClick(Sender: TObject);
    procedure FieldsToPrintScreenListBoxClick(Sender: TObject);
    procedure ChangeSelectionButtonClick(Sender: TObject);
    procedure ChangeFieldToPrintButtonClick(Sender: TObject);
    procedure AddTotalToPrintButtonClick(Sender: TObject);
    procedure ChangeTotalToPrintButtonClick(Sender: TObject);
    procedure DeleteTotalToPrintButtonClick(Sender: TObject);
    procedure ClearTotalToPrintButtonClick(Sender: TObject);
    procedure TotalsToPrintScreenListBoxClick(Sender: TObject);
    procedure CancelTotalsButtonClick(Sender: TObject);
    procedure DoneTotalsButtonClick(Sender: TObject);
    procedure TotalsToPrintPanelExit(Sender: TObject);
    procedure SaveButtonClick(Sender: TObject);
    procedure LoadButtonClick(Sender: TObject);
    procedure ClearButtonClick(Sender: TObject);
    procedure ChooseTaxYearRadioGroupClick(Sender: TObject);
    procedure SelectionGridDblClick(Sender: TObject);
    procedure ValuesStringGridKeyPress(Sender: TObject; var Key: Char);
    procedure FieldsToPrintGridDblClick(Sender: TObject);
    procedure TotalsToPrintGridDblClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure AllSBLCheckBoxClick(Sender: TObject);
    procedure ReportLabelPrintHeader(Sender: TObject);
    procedure ReportLabelPrint(Sender: TObject);
    procedure MSWordMergeButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    UnitName : String;
    ProcessingType : Integer;  {ThisYear, NextYear, History}
    AssessmentYear : String;  {What year do they want to see the data for?}

    ScreenLabelList, CriteriaList,
    FieldsToPrintList,
    TotalsToPrintList : TList;

      {CHG11181997-2: Justify the columns based on type.}

    JustificationList : TStringList;

      {CHG11181997-4: Make the field widths dynamic.}

    ActualFieldWidths,
    FieldWidths : TStringList;

    SearchTableList : TList;
    FieldsToPrintTableList : TList;
    TotalsToPrintTableList : TList;
    ValuesList : TList;

    ActiveStatus : Integer;
    PrintAllExemptions,
    PrintAllSpecialDistricts,
    ShowDetails,  {We may need to create a details part for each
                   parcel (i.e. if they want to see something like exemptions
                   which can have several entries).}
    AddSelection,
    AddFieldToPrint,
    AddTotalToPrint,
    PrintingCancelled,
    SearchPanelButtonPressed,
    FieldsToPrintPanelButtonPressed,
    TotalsToPrintPanelButtonPressed : Boolean;

    FieldWidthInt : Integer;
    SBLFieldWidth,
    DefaultFieldWidth, Field1Pos, Field2Pos, Field3Pos,
    Field4Pos, Field5Pos, Field6Pos : Real;

      {CHG11231997-2: Let the user select which swis codes they want
                      so we can skip the swis codes they don't want.}

    SelectedSwisCodes : TStringList;

    ExtractFileType,
    BreakCodeType : Integer;
    LastBreakCode, NewBreakCode : String;
    ExtractFile : TextFile;
    PrintMailingAddress,
    TruncateFields,
    LoadFromParcelList,
    CreateParcelList, TotalsOnly : Boolean;

    SelectedSchoolCodes,
    SelectedExemptionCodes,
    SelectedSpecialDistricts : TStringList;
    RecordsToPrintOrExtract,
    EnhancedSTARType : Integer;
    BookmarkList : TList;
    IncludeSwisOnParcelID : Boolean;
    IncludeLegalAddrInExtract,
    IncludeOwnerInExtract,
    IncludeParcelIDInExtract : Boolean;

    StartSwisSBLKey, EndSwisSBLKey : String;
    PrintAllParcelIDs, PrintToEndOfParcelIDs,
    PrintHeadersOnFirstLineOfExtract, NullBlanks : Boolean;
    ExtractToExcel : Boolean;
    SpreadsheetFileName : String;
    BlankLinesBetweenCoops, _PrintLabels, bForceLetterSize, bMeanMedian : Boolean;

      {Label variables}

    LabelOptions : TLabelOptions;
    ParcelListForLabels : TStringList;
    Salutation : String;
    IVPEnrollmentStatusType : Integer;
    LeftMargin : Double;

    Procedure InitializeForm;  {Open the tables and setup.}

    Function FormatValue(Value : String;
                         LabelName : String) : String;

    Procedure LoadCriteriaListFromGrid(CriteriaList : TList);
    {Transfer the data in the criteria grid to a TList for easier use.}

    Procedure LoadFieldsToPrintFromGrid(FieldsToPrint : TList;
                                        JustificationList,
                                        FieldWidths : TStringList);
    {Load the fields to print.}
    Procedure LoadTotalsToPrintFromGrid(TotalsToPrintList : TList);
   {Load the Totals to print.}

    Procedure WriteFieldToExtractFile(    FieldValue : String;
                                      var ExtractFile : TextFile;
                                          ExtractFileType : Integer;
                                          FieldWidth : Real;
                                          FirstFieldOnLine : Boolean;
                                          Justification,
                                          _ScreenName,
                                          _FieldName : String;
                                          ExtractFileList,
                                          ExtractFieldList : TList);

    Procedure FillInNumberOfForcedColsRec(var NumberOfColumnsForEachFieldRec : NumberOfColumnsForEachFieldRecord);

    Procedure CreateExtractFieldList(ExtractFieldList : TList);

    Procedure WriteLineToExtractFile(var ExtractFile : TextFile;
                                         ExtractFileType : Integer;
                                         ExtractFileList,
                                         ExtractFieldList : TList);

    Function ParcelMeetsCriteria : Boolean;
    {For each criteria that they specified, get the record(s) for this parcel and
     look in the appropriate table at the field they choose to see if it matches.
     If it matches, then we will return the value of each field in the criteria
     list.}

    Function ParcelMeetsEX_SD_Criteria(SwisSBLKey : String) : Boolean;

    Procedure PrintOneFieldValue(Sender : TObject;  {ReportPrinter}
                                 FieldsToPrintList : TList;
                                 Index,
                                 ColumnWidthPos : Integer;
                                 SwisSBLKey : String;
                                 ExtractFileList,
                                 ExtractFieldList : TList);

    Procedure SetReportTabs(Sender : TObject;
                            TabsForHeaderTitles : Boolean);
    {Set the main tabs for the report (not individual detail).}

    Procedure PrintDetails(    Sender : TObject;
                               FieldsToPrintList,
                               FieldsToPrintTableList : TList;
                               SwisSBLKey : String;
                               ExtractFileList,
                               ExtractFieldList : TList;
                           var Quit : Boolean);
    {Print the details as indented information. Each field will have one line
     or lines with up to 5 values per line. We will store all the info in
     string lists until we are ready to print.}

    Procedure UpdateTotals(    TotalsToPrintList,
                               TotalsToPrintTableList : TList;
                               SwisSBLKey : String;
                           var Quit : Boolean);
    {CHG12051997-2: Allow the user to choose totals.}
    {Update the totals that they want to see.}

  end;

implementation

uses GlblVars, WinUtils, Utilitys, GlblCnst, PASUTILS, UTILEXSD,
     ENSTARTY,  {Enhanced STAR type}
     Preview, PRCLLIST, Prog, RPTDialg, DataModule, DataAccessUnit;

type
    {Layout of criteria record - info for one criteria.}

  CriteriaRecord = record
    SearchTableNumber : Integer;  {Which search table are we using?}
    TableName : String;
    ScreenName : String;
    LabelName : String;
    FieldName : String;
    ComparisonType : Integer;
    (*ComparisonValue : TStringList;*)
  end;  {CriteriaRecord = record}

  CriteriaPtr = ^CriteriaRecord;

   {Info needed to obtain and print the value of one field that the
    person wants to see.}

  FieldsToPrintRecord = record
    ScreenName : String;
    TableName : String;
    LabelName : String;
    FieldName : String;
    SearchTableNumber : Integer;  {Which search table are we using?}
    CanHaveMoreThanOneValue : Boolean;  {Can this type of field have more than one value,
                                         i.e. Exemptions, SD, Inv.}
  end;  {FieldsToPrintRec = record}

  FieldsToPrintPtr = ^FieldsToPrintRecord;

    {CHG12051997-2: Allow the user to choose totals.}

   {Info needed to obtain and print the value of one field that the
    person wants to see.}

  TotalsToPrintRecord = record
    ScreenName : String;
    TableName : String;
    LabelName : String;
    FieldName : String;
    SearchTableNumber : Integer;  {Which search table are we using?}
    SubTotal,
    GrandTotal : Double;
    Values : TStringList;
  end;  {TotalsToPrintRec = record}

  TotalsToPrintPtr = ^TotalsToPrintRecord;

    {This list stores the actual data found for a parcel along with the
     screen and field name.}

  ExtractFileListRecord = record
    OutputStr : String;
    ScreenName : String;
    FieldName : String;
  end;

  ExtractFileListPointer = ^ExtractFileListRecord;


    {This list stores the potential field list to extract i.e. if they want
     to see Exemption code and amount and Sales Price and amount and the
     number of forced columns is 4 and 3 respectively, we will store
     Exemption Code and exemption Amount each 4 times (total of 8) and then
     Sales price and amount each 3 times (total of 6).  This is what the
     extract file should look like.}

  ExtractFieldListRecord = record
    ScreenName : String;
    FieldName : String;
  end;

  ExtractFieldListPointer = ^ExtractFieldListRecord;

const
    {Break code type}

  btNone = 0;
  btSwisCode = 1;
  btRollSection = 2;

    {Extract file types}

  tfNone = 0;
  tfColumnar = 1;
  tfCommaDelimited = 2;
  tfSpreadsheetOnly = 3;

  asActive = 0;
  asInactive = 1;
  asEither = 2;

  rtAll = 0;
  rtFirstRecordOnly = 1;
  rtLastRecordOnly = 2;

    {CHG04192001-2: Format the parcel ID segments.}

  SectionFieldName = 'Sec';
  SubsectionFieldName = 'Sbs';
  BlockFieldName = 'Block';
  LotFieldName = 'Lot';
  SublotFieldName = 'Subl';
  SuffixFieldName = 'Sfx';

  SpecialScreenName = 'Special Criteria';
  MailingAndLegalAddressEqualLabel = 'Mailing Addr = Legal Addr';
  MailingAndLegalAddressNotEqualLabel = 'Mailing Addr not = Legal Addr';
  DoesNotHavePictures = 'Does not have picture';
  DoesNotHaveDocuments = 'Does not have document';
    {CHG11072013(MPT): Add special properties "DoesNotHave(Sketch/PropertyCard)}
  DoesNotHaveSketch = 'Does not have sketch';
  DoesNotHavePropertyCard = 'Does not have property card';

  flImprovementValue = 'ImprovementValue';

    {Screen name constants}

  BaseInformationScreenName = 'Base Information';
  ExemptionScreenName = 'Exemption';
  ComBuildingsScreenName = 'Commercial Building';
  ComLandsScreenName = 'Commercial Land';
  ComImprovementsScreenName = 'Commercial Improvements';
  ComIncomeExpensesScreenName = 'Commercial Income Expense';
  ComRentsScreenName = 'Commercial Rent';
  ComSitesScreenName = 'Commercial Sites';
  ResBuildingsScreenName = 'Residential Building';
  ResLandsScreenName = 'Residential Land';
  ResImprovementsScreenName = 'Residential Improvements';
  ResSitesScreenName = 'Residential Sites';
  SalesScreenName = 'Sales';
  ExemptionsDeniedScreenName = 'Exemptions Denied';
  ExemptionsRemovedScreenName = 'Exemptions Removed';
  SpecialDistrictScreenName = 'Special District';
  PermitScreenName = 'Permits';

var
  NumberOfColumnsForEachFieldRec : NumberOfColumnsForEachFieldRecord;


{$R *.DFM}

{========================================================}
Procedure TSearchReportForm.FormActivate(Sender: TObject);

begin
  SetFormStateMaximized(Self);
end;

{========================================================}
Procedure AddItemToScreenLabelList(ScreenLabelList : TList;
                                   _ScreenName : String;
                                   _LabelName : String;
                                   _TableName : String;
                                   _FieldName : String);

var
  ScreenLblPtr : ScreenLabelPtr;

begin
  New(ScreenLblPtr);

  with ScreenLblPtr^ do
    begin
      ScreenName := _ScreenName;
      LabelName := _LabelName;
      TableName := _TableName;
      FieldName := _FieldName;
    end;

  ScreenLabelList.Add(ScreenLblPtr);

end;  {AddItemToScreenLabelList}

{========================================================}
Procedure TSearchReportForm.InitializeForm;

var
  Found : Boolean;
  I, J : Integer;

begin
  UnitName := 'RSEARCH.PAS';  {mmm}
  PrintingCancelled := False;

  OpenTablesForForm(Self, GlblProcessingType);

      {CHG11231997-2: Let the user select which swis codes they want
                      so we can skip the swis codes they don't want.}

    {Fill in the swis code list.}

  SelectedSwisCodes := TStringList.Create;
  SelectedSchoolCodes := TStringList.Create;

    {create list to store pointers to all screen/label elements}
    {FXX11191999-7: Add user defined fields to search, audit, broadcast.}

  If (GlblProcessingType = History)
    then SetRangeOld(UserFieldDefinitionTable,
                     ['TaxRollYr', 'DisplayOrder'],
                     [GlblHistYear, '0'],
                     [GlblHistYear, '9999']);

  ScreenLabelList := TList.Create;

  LoadScreenLabelList(ScreenLabelList, ScreenLabelTable, UserFieldDefinitionTable, True,
                      True, True, [slAll]);

  If GlblUsesPASPermits
    then
      begin
        AddItemToScreenLabelList(ScreenLabelList, PermitScreenName, 'Permit Number',
                                 PASPermitsTableName, 'PermitNumber');
        AddItemToScreenLabelList(ScreenLabelList, PermitScreenName, 'Permit Date',
                                 PASPermitsTableName, 'PermitDate');
        AddItemToScreenLabelList(ScreenLabelList, PermitScreenName, 'Cost',
                                 PASPermitsTableName, 'Cost');
        AddItemToScreenLabelList(ScreenLabelList, PermitScreenName, 'Work Description',
                                 PASPermitsTableName, 'WorkDescription');
        AddItemToScreenLabelList(ScreenLabelList, PermitScreenName, 'Entered',
                                 PASPermitsTableName, 'Entered');
        AddItemToScreenLabelList(ScreenLabelList, PermitScreenName, 'Inspected',
                                 PASPermitsTableName, 'Inspected');
        AddItemToScreenLabelList(ScreenLabelList, PermitScreenName, 'C\O Issued',
                                 PASPermitsTableName, 'COIssued');

      end;  {If GlblUsesPASPermits}

    {Now fill in the combo boxes.}

  For J := 0 to (ScreenLabelList.Count - 1) do
    with ScreenLabelPtr(ScreenLabelList[J])^ do
      begin
        Found := False;

          {then add the screen name to the screen string list if it is not}
          {already there}

        For I := 0 to (ScreenListBox.Items.Count - 1) do
          If (Take(30, ScreenListBox.Items[I]) = Take(30, ScreenName))
            then Found := True;

        If not Found
          then ScreenListBox.Items.Add(Take(30, ScreenName));

        Found := False;

        For I := 0 to (FieldsToPrintScreenListBox.Items.Count - 1) do
          If (Take(30, FieldsToPrintScreenListBox.Items[I]) = Take(30, ScreenName))
            then Found := True;

        If not Found
          then FieldsToPrintScreenListBox.Items.Add(Take(30, ScreenName));

          {CHG12051997-2: Allow the user to choose totals.}

        Found := False;

        For I := 0 to (TotalsToPrintScreenListBox.Items.Count - 1) do
          If (Take(30, TotalsToPrintScreenListBox.Items[I]) = Take(30, ScreenName))
            then Found := True;

        If not Found
          then TotalsToPrintScreenListBox.Items.Add(Take(30, ScreenName));

      end;  {with ScreenLabelPtr(ScreenLabelList[I])^ do}

    {CHG04302001-1: Create a special section for specialized searches.}

  ScreenListBox.Items.Add(SpecialScreenName);

  AddItemToScreenLabelList(ScreenLabelList, SpecialScreenName, MailingAndLegalAddressEqualLabel,
                           ParcelTableName, MailingAndLegalAddressEqualLabel);

  AddItemToScreenLabelList(ScreenLabelList, SpecialScreenName, MailingAndLegalAddressNotEqualLabel,
                           ParcelTableName, MailingAndLegalAddressNotEqualLabel);

    {CHG04102003-2(2.06r): Add feature to find parcels without pictures or documents.}

  AddItemToScreenLabelList(ScreenLabelList, SpecialScreenName, DoesNotHavePictures,
                           ParcelTableName, DoesNotHavePictures);

  AddItemToScreenLabelList(ScreenLabelList, SpecialScreenName, DoesNotHaveDocuments,
                           ParcelTableName, DoesNotHaveDocuments);

    {CHG11072013(MPT): Add special properties "DoesNotHave(Sketch/PropertyCard)}

  AddItemToScreenLabelList(ScreenLabelList, SpecialScreenName, DoesNotHaveSketch,
                           ParcelTableName, DoesNotHaveSketch);

  AddItemToScreenLabelList(ScreenLabelList, SpecialScreenName, DoesNotHavePropertyCard,
                           ParcelTableName, DoesNotHavePropertyCard);
    {Add the column headers.}

  with SelectionGrid do
    begin
      Cells[0, 0] := 'Screen';
      Cells[1, 0] := 'Field';
      Cells[2, 0] := 'Comparison';
      Cells[3, 0] := 'Value';

    end;  {with FieldsToPrintGrid do}

  with FieldsToPrintGrid do
    begin
      Cells[0, 0] := 'Screen';
      Cells[1, 0] := 'Field';
    end;  {with FieldsToPrintGird do}

  with TotalsToPrintGrid do
    begin
      Cells[0, 0] := 'Screen';
      Cells[1, 0] := 'Field';
    end;  {with TotalsToPrintGird do}

    {Center the FieldsToPrint panel.}

  FieldsToPrintPanel.Left := 36;
  FieldsToPrintPanel.Top := 48;
  TotalsToPrintPanel.Left := 36;
  TotalsToPrintPanel.Top := 48;
  SearchSelectionPanel.Left := 35;
  SearchSelectionPanel.Top := 22;

    {Change the radio group to include the year.}

  ChooseTaxYearRadioGroup.Items.Clear;
  ChooseTaxYearRadioGroup.Items.Add('Next Year (' + GlblNextYear + ')');
  ChooseTaxYearRadioGroup.Items.Add('This Year (' + GlblThisYear + ')');
  ChooseTaxYearRadioGroup.Items.Add('History');


  with ChooseTaxYearRadioGroup do
    case GlblProcessingType of
      ThisYear : begin
                   ItemIndex := 1;
                   ProcessingType := ThisYear;
                   AssessmentYear := GlblThisYear;
                 end;

      NextYear : begin
                   ItemIndex := 0;
                   ProcessingType := NextYear;
                   AssessmentYear := GlblNextYear;
                 end;

      History :
        begin
          ItemIndex := 2;
          EditHistoryYear.Text := GlblHistYear;
          ProcessingType := History;
          AssessmentYear := GlblHistYear;
        end;

    end;  {case GlblProcessingType of}

    {FXX12211998-1: Default initial extract dir.}

  SaveDialog.InitialDir := ExpandPASPath(GlblExportDir);

  ValuesList := TList.Create;

    {FXX11241999-1: If this is history, set a range so that only codes from that
                    year are displayed.}

  FillOneListBox(ExemptionListBox, ExemptionCodeTable, 'EXCode',
                 'Description', 10, True, False, ProcessingType, AssessmentYear);

  FillOneListBox(SpecialDistrictListBox, SDCodeTable, 'SDistCode',
                 'Description', 10, True, False, ProcessingType, AssessmentYear);

  FillOneListBox(SwisCodeListBox, SwisCodeTable, 'SwisCode',
                 'MunicipalityName', 25, True, True, ProcessingType, AssessmentYear);

  FillOneListBox(SchoolCodeListBox, SchoolCodeTable, 'SchoolCode',
                 'SchoolName', 25, True, True, ProcessingType, AssessmentYear);

  SelectItemsInListBox(ExemptionListBox);
  SelectItemsInListBox(SpecialDistrictListBox);
  SelectItemsInListBox(SwisCodeListBox);
  SelectItemsInListBox(SchoolCodeListBox);

    {CHG12151999-1: Allow user to set default of parcel type.}

  ActiveStatusRadioGroup.ItemIndex := GlblSearchReportDefaultParcelType;

  If GlblIsCoopRoll
    then BlankLinesBetweenCoopsCheckBox.Visible := True;

    {CHG11182003-5(2.07k): If there is only one swis code, default print swis on parcel IDs to false.}

  IncludeSwisOnParcelIDCheckBox.Checked := (SwisCodeTable.RecordCount > 1);

    {CHG03042004-1(2.07l2): Add support for grievance \ certs to search report.}

  If not GlblUsesGrievances
    then GrievanceForcedColumnsTabSheet.TabVisible := False;

  SelectionsNotebook.PageIndex := 0;

end;  {InitializeForm}

{===================================================================}
Procedure TSearchReportForm.FormKeyPress(    Sender: TObject;
                                     var Key: Char);

begin
  (*If (Key = #13)
    then
      begin
        Key := #0;
        Perform(WM_NEXTDLGCTL, 0, 0);
      end;*)

end;  {FormKeyPress}

{===================================================================}
Procedure TSearchReportForm.ClearButtonClick(Sender: TObject);

{FXX06291999-3: Add a button to the search screen to clear the options.}

var
  I, J : Integer;

begin
   {FXX10191999-2: Don't use ClearStringGrid since it blanks out the first row.}

  with SelectionGrid do
    For I := 1 to (RowCount - 1) do
      For J := 0 to (ColCount - 1) do
        Cells[J, I] := '';

  with FieldsToPrintGrid do
    For I := 1 to (RowCount - 1) do
      For J := 0 to (ColCount - 1) do
        Cells[J, I] := '';

  with TotalsToPrintGrid do
    For I := 1 to (RowCount - 1) do
      For J := 0 to (ColCount - 1) do
        Cells[J, I] := '';

  For I := 0 to (SwisCodeListBox.Items.Count - 1) do
    SwisCodeListBox.Selected[I] := True;
  PrintOrderRadioBox.ItemIndex := 0;
  CreateParcelListCheckBox.Checked := False;
  LoadFromParcelListCheckBox.Checked := False;
  SpaceBetweenParcelsCheckBox.Checked := False;
  ExtractTypeRadioGroup.ItemIndex := 0;
  CombinationRadioGroup.ItemIndex := 0;
  EditHistoryYear.Text := '';

  with ChooseTaxYearRadioGroup do
    case GlblProcessingType of
      ThisYear : ItemIndex := 1;
      NextYear : ItemIndex := 0;
      History :
        begin
          ItemIndex := 2;
          EditHistoryYear.Text := GlblHistYear;
        end;

    end;  {case GlblProcessingType of}

  For I := (ValuesList.Count - 1) downto 0 do
    begin
      TStringList(ValuesList[I]).Free;
      ValuesList[I] := nil;  {Force to nil so Pack works.}
    end;

  ValuesList.Pack;

end;  {ClearButtonClick}

{===================================================================}
Procedure TSearchReportForm.CancelFieldsToPrintButtonClick(Sender: TObject);

begin
  FieldsToPrintPanelButtonPressed := True;
  FieldsToPrintPanel.Visible := False;
end;  {CancelFieldsToPrintButtonClick}

{===================================================================}
Procedure TSearchReportForm.DoneFieldsButtonClick(Sender: TObject);

{Make sure that they have selected from all four criteria.
 If so, put the entry in a grid.}

var
  OKToExit, ScreenSelected, LabelSelected : Boolean;
  I, J, Index, ScreenIndex, LabelIndex : Integer;

begin
  ScreenSelected := False;
  LabelSelected := False;
  ScreenIndex := 0;
  LabelIndex := 0;

    {CHG06092003-2(2.07c): Allow for multiselect of fields.}

  with FieldsToPrintScreenListBox do
    For I := 0 to (Items.Count - 1) do
      If Selected[I]
        then
          begin
            ScreenSelected := True;
            ScreenIndex := I;
          end;

  with FieldsToPrintLabelListBox do
    For I := 0 to (Items.Count - 1) do
      If Selected[I]
        then LabelSelected := True;

  OKToExit := (ScreenSelected and LabelSelected);

  If OKToExit
    then
      begin
        FieldsToPrintPanelButtonPressed := True;
        FieldsToPrintPanel.Visible := False;

          {Now insert it at the end.}

        with FieldsToPrintGrid do
          begin
              {CHG10191997-5: Allow for modification of selections.}

            If AddFieldToPrint
              then
                begin
                  with FieldsToPrintLabelListBox do
                    For I := 0 to (Items.Count - 1) do
                      If Selected[I]
                        then
                          begin
                              {First find the first open line.}
                            Index := 0;

                            For J := 1 to (RowCount - 1) do
                              If (Deblank(Cells[0, J]) <> '')
                                then Index := J;

                            Index := Index + 1;

                            Cells[0, Index] := FieldsToPrintScreenListBox.Items[ScreenIndex];
                            Cells[1, Index] := FieldsToPrintLabelListBox.Items[I];

                          end;  {If Selected[I]}
                end
              else
                begin
                  Index := Row;

                  Cells[0, Index] := FieldsToPrintScreenListBox.Items[ScreenIndex];
                  Cells[1, Index] := FieldsToPrintLabelListBox.Items[LabelIndex];

                end;  {If AddFieldToPrint}

          end;  {with FieldsToPrintGrid do}

      end  {If OKToExit}
    else MessageDlg('Please enter a screen and label.',
                    mtError, [mbOK], 0);

end;  {DoneFieldsButtonClick}

{===================================================================}
Procedure TSearchReportForm.CancelSelectionButtonClick(Sender: TObject);

begin
  SearchPanelButtonPressed := True;
  SearchSelectionPanel.Visible := False;
end;  {CancelSelectionButtonClick}

{===================================================================}
Procedure TSearchReportForm.ScreenListBoxClick(Sender: TObject);

{Fill in the fields for this screen.}

var
  _ScreenName : String;
  I : Integer;

begin
  LabelListBox.Items.Clear;

  with ScreenListBox do
    For I := 0 to (Items.Count - 1) do
      If Selected[I]
        then _ScreenName := Items[I];

  If (Trim(_ScreenName) = SpecialScreenName)
    then LabelListBox.Columns := 0
    else LabelListBox.Columns := 4;

   {CHG04302001-1: Create a special section for specialized searches.}

  For I := 0 to (ScreenLabelList.Count - 1) do
    with ScreenLabelPtr(ScreenLabelList[I])^ do
      If (RTrim(ScreenName) = RTrim(_ScreenName))
        then LabelListBox.Items.Add(LabelName);

end;  {ScreenListBoxClick}

{===================================================================}
Procedure TSearchReportForm.FieldsToPrintScreenListBoxClick(Sender: TObject);

{Fill in the fields for this screen.}

var
  _ScreenName : String;
  I : Integer;

begin
  FieldsToPrintLabelListBox.Items.Clear;

  with FieldsToPrintScreenListBox do
    For I := 0 to (Items.Count - 1) do
      If Selected[I]
        then _ScreenName := Items[I];

  For I := 0 to (ScreenLabelList.Count - 1) do
    with ScreenLabelPtr(ScreenLabelList[I])^ do
      If (RTrim(ScreenName) = RTrim(_ScreenName))
        then FieldsToPrintLabelListBox.Items.Add(LabelName);

end;  {FieldsToPrintScreenListBoxClick}

{===================================================================}
Function TSearchReportForm.FormatValue(Value : String;
                                       LabelName : String) : String;

{CHG04192001-2: Format the parcel ID segments.}

{$H-}
var
  sShortValue : String;

begin
  LabelName := Trim(LabelName);

  sShortValue := Copy(Value, 1, 4);

  If (UpcaseStr(SectionFieldName) = UpcaseStr(LabelName))
    then FormatSegment('section', sShortValue, 3,
                       GlblSectionFormat, False);

  If (UpcaseStr(SubsectionFieldName) = UpcaseStr(LabelName))
    then FormatSegment('subsection', sShortValue, 3,
                       GlblSubsectionFormat, False);

  If (UpcaseStr(BlockFieldName) = UpcaseStr(LabelName))
    then FormatSegment('block', sShortValue, 4,
                       GlblBlockFormat, False);

  If (UpcaseStr(LotFieldName) = UpcaseStr(LabelName))
    then FormatSegment('lot', sShortValue, 3,
                       GlblLotFormat, False);

  If (UpcaseStr(SublotFieldName) = UpcaseStr(LabelName))
    then FormatSegment('sublot', sShortValue, 3,
                       GlblSublotFormat, False);

  If (UpcaseStr(SuffixFieldName) = UpcaseStr(LabelName))
    then FormatSegment('suffix', sShortValue, 4,
                       GlblSuffixFormat, False);

  {$H+}

  Result := Value;

end;  {FormatValue}

{===================================================================}
Procedure TSearchReportForm.DoneSelectionButtonClick(Sender: TObject);

{Make sure that they have selected from all four criteria.
 If so, put the entry in a grid.}

var
  OKToExit, ScreenSelected, LabelSelected,
  ComparisonTypeSelected, ValueFilledIn : Boolean;
  I, Index, ScreenIndex, LabelIndex : Integer;
  TempStr, ScreenName : String;
  TempStringList : TStringList;

begin
  ScreenSelected := False;
  LabelSelected := False;
  ScreenIndex := 0;
  LabelIndex := 0;
  ComparisonTypeSelected := False;
  ValueFilledIn := False;

  with ScreenListBox do
    For I := 0 to (Items.Count - 1) do
      If Selected[I]
        then
          begin
            ScreenSelected := True;
            ScreenIndex := I;
            ScreenName := Items[I];
          end;

  with LabelListBox do
    For I := 0 to (Items.Count - 1) do
      If Selected[I]
        then
          begin
            LabelSelected := True;
            LabelIndex := I;
          end;

  If (ComparisonTypeRadioGroup.ItemIndex <> - 1)
    then ComparisonTypeSelected := True;

    {CHG10181999-1: Allow for more than 1 value.}

  If (NumEntriesInGridCol(ValuesStringGrid, 0) > 0)
    then ValueFilledIn := True;

     {CHG11251997-2: Allow for selection on blank or not blank.}
     {No value required for blank, not blank.}

  If (ComparisonTypeRadioGroup.ItemIndex in [coBlank, coNotBlank])
    then ValueFilledIn := True;

    {CHG04302001-1: Add special items section - don't need value or
                    comparison type.}

  OKToExit := ((ScreenSelected and LabelSelected and
                ComparisonTypeSelected and ValueFilledIn) or
               ((Trim(ScreenName) = SpecialScreenName) and
                LabelSelected));

  If OKToExit
    then
      begin
        SearchPanelButtonPressed := True;
        SearchSelectionPanel.Visible := False;

          {Now insert it at the end.}

        with SelectionGrid do
          begin
              {CHG10191997-5: Allow for modification of selections.}
              {First find the first open line.}

            If AddSelection
              then
                begin
                  Index := 0;

                  For I := 1 to (RowCount - 1) do
                    If (Deblank(Cells[0, I]) <> '')
                      then Index := I;

                  Index := Index + 1;
                end
              else Index := Row;

            Cells[0, Index] := ScreenListBox.Items[ScreenIndex];
            Cells[1, Index] := LabelListBox.Items[LabelIndex];

            If (RTrim(ScreenName) <> SpecialScreenName)
              then Cells[2, Index] := ComparisonTypeRadioGroup.Items[ComparisonTypeRadioGroup.ItemIndex];

            with ValuesStringGrid do
              If (ComparisonTypeRadioGroup.ItemIndex = coBetween)
                then TempStr := Cells[0, 0] + ' & ' + Cells[0, 1]
                else
                  begin
                    TempStr := '';

                    For I := 0 to (RowCount - 1) do
                      If (Deblank(Cells[0, I]) <> '')
                        then TempStr := TempStr +
                                        RTrim(FormatValue(Cells[0, I],
                                                          SelectionGrid.Cells[1, Index])) + ' ';
                  end;  {else of If (ComparisonTypeRadioGroup.ItemIndex = caBetween)}

            Cells[3, Index] := TempStr;

            If AddSelection
              then TempStringList := TStringList.Create
              else
                begin
                  TempStringList := TStringList(ValuesList[Index - 1]);
                  TempStringList.Clear;
                end;

              {CHG04192001-2: Format the parcel ID segments.}
              {CHG06102010-1(2.26.1)[I7404]: Allow commas for numeric entries.}

            with ValuesStringGrid do
              For I := 0 to (ValuesStringGrid.RowCount - 1) do
                If (Deblank(ValuesStringGrid.Cells[0, I]) <> '')
                  then TempStringList.Add(FormatValue(StringReplace(ValuesStringGrid.Cells[0, I], ',', '', [rfReplaceAll]),
                                                      SelectionGrid.Cells[1, Index]));

            If AddSelection
              then ValuesList.Add(TempStringList);

            ComparisonTypeRadioGroup.ItemIndex := -1;
            ClearStringGrid(ValuesStringGrid);

          end;  {with SelectionGrid do}

      end  {If OKToExit}
    else MessageDlg('Please enter a screen, label, comparison type, and value.',
                    mtError, [mbOK], 0);

end;  {DoneSelectionButtonClick}

{===================================================================}
Procedure TSearchReportForm.FieldsToPrintPanelExit(Sender: TObject);

{Make sure they don't leave the panel without pressing a button.}

begin
  If not FieldsToPrintPanelButtonPressed
    then FieldsToPrintPanel.SetFocus;

end;  {FieldsToPrintPanelExit}

{===================================================================}
Procedure TSearchReportForm.SearchSelectionPanelExit(Sender: TObject);

{Make sure they don't leave the panel without pressing a button.}

begin
  If not SearchPanelButtonPressed
    then SearchSelectionPanel.SetFocus;

end;  {SearchSelectionPanelExit}

{===================================================================}
Procedure TSearchReportForm.ValuesStringGridKeyPress(    Sender: TObject;
                                                     var Key: Char);

{FXX11021999-5: Make sure the characters are upper case.}

begin
  Key := Upcase(Key);

    {FXX11021999-7: Accept the carriage return in the values string grid.}

  with ValuesStringGrid do
    If (Key = #13)
      then
        If (Row = (RowCount - 1))
          then
            begin  {Not a grid.}
              Perform(WM_NEXTDLGCTL, 0, 0);
              Key := #0;
            end
          else Row := Row + 1;  {Move to the next row.}

end;  {ValuesStringGridKeyPress}

{===================================================================}
Procedure TSearchReportForm.SelectionGridDblClick(Sender: TObject);

{FXX11021999-3: Allow double clicking of grid line to modify or add.}

begin
  with SelectionGrid do
    If (Deblank(Cells[1, Row]) = '')
      then AddSelectionButtonClick(SelectionGrid)
      else ChangeSelectionButtonClick(SelectionGrid);

end;  {SelectionGridDblClick}

{===================================================================}
Procedure TSearchReportForm.AddSelectionButtonClick(Sender: TObject);

begin
  SearchPanelButtonPressed := False;
  SearchSelectionPanel.Visible := True;
  ClearStringGrid(ValuesStringGrid);
  SearchSelectionPanel.SetFocus;
  AddSelection := True;

end;  {AddSelectionButtonClick}

{===================================================================}
Procedure TSearchReportForm.ChangeSelectionButtonClick(Sender: TObject);

{CHG10191997-5: Allow for modification of selections.}

var
  I, Index : Integer;

begin
  AddSelection := False;

    {Set up the values in the grid.}

  with SelectionGrid do
    begin
      ScreenListBox.ItemIndex := ScreenListBox.Items.IndexOf(Cells[0, Row]);

        {Set the fields.}
      ScreenListBoxClick(Sender);

      LabelListBox.ItemIndex := LabelListBox.Items.IndexOf(Cells[1, Row]);
      ComparisonTypeRadioGroup.ItemIndex := ComparisonTypeRadioGroup.Items.IndexOf(Cells[2, Row]);

        {Load the values grid from the list.}

      ClearStringGrid(ValuesStringGrid);
      Index := 0;

      For I := 0 to (TStringList(ValuesList[Row - 1]).Count - 1) do
        begin
          ValuesStringGrid.Cells[0, Index] := TStringList(ValuesList[Row - 1])[I];
          Index := Index + 1;
        end;

    end;  {with SelectionGrid do}

  SearchPanelButtonPressed := False;
  SearchSelectionPanel.Visible := True;
  SearchSelectionPanel.SetFocus;

end;  {ChangeSelectionButtonClick}

{===================================================================}
Procedure TSearchReportForm.DeleteSelectionButtonClick(Sender: TObject);

{Delete the line that they are on and move all the other ones up.}

var
  I, J : Integer;

begin
  with SelectionGrid do
    begin
      TStringList(ValuesList[Row - 1]).Free;
      ValuesList[Row - 1] := nil;
      ValuesList.Pack;  {Remove nils}

      For I := Row to (RowCount - 2) do  {Don't clear the header.}
        For J := 0 to (ColCount - 1) do
          Cells[J, I] := Cells[J, (I + 1)];

        {Make sure to clear the last line.}

      For J := 0 to (ColCount - 1) do
        Cells[J, (RowCount - 1)] := '';

    end;  {with FieldsToPrintGrid do}

end;  {DeleteFieldsToPrintButtonClick}

{===================================================================}
Procedure TSearchReportForm.ClearSelectionsButtonClick(Sender: TObject);

{Clear all the FieldsToPrints in the grid.}

var
  I, J : Integer;

begin
  with SelectionGrid do
    For I := 1 to (RowCount - 1) do  {Don't clear the header.}
      For J := 0 to (ColCount - 1) do
        Cells[J, I] := '';

    {FXX11021999-6: Be sure to clear out the values lists too.}

  For I := (ValuesList.Count - 1) downto 0 do
    begin
      TStringList(ValuesList[I]).Free;
      ValuesList[I] := nil;  {Force to nil so Pack works.}
    end;

  ValuesList.Pack;

end;  {ClearSelectionsButtonClick}

{===================================================================}
Procedure TSearchReportForm.FieldsToPrintGridDblClick(Sender: TObject);

{FXX11021999-3: Allow double clicking of grid line to modify or add.}

begin
  with FieldsToPrintGrid do
    If (Deblank(Cells[0, Row]) = '')
      then AddFieldToPrintButtonClick(FieldsToPrintGrid)
      else ChangeFieldToPrintButtonClick(FieldsToPrintGrid);

end;  {FieldsToPrintGridDblClick}

{===================================================================}
Procedure TSearchReportForm.AddFieldToPrintButtonClick(Sender: TObject);

begin
  AddFieldToPrint := True;
  FieldsToPrintPanelButtonPressed := False;
  FieldsToPrintPanel.Visible := True;
  FieldsToPrintPanel.SetFocus;

end;  {AddFieldToPrintButtonClick}

{===================================================================}
Procedure TSearchReportForm.ChangeFieldToPrintButtonClick(Sender: TObject);

{CHG10191997-5: Allow for modification of selections.}

begin
    {Set up the values in the grid.}

  with FieldsToPrintGrid do
    begin
      FieldsToPrintScreenListBox.ItemIndex := FieldsToPrintScreenListBox.Items.IndexOf(Cells[0, Row]);

        {Set the fields.}
      FieldsToPrintScreenListBoxClick(Sender);

      FieldsToPrintLabelListBox.ItemIndex := FieldsToPrintLabelListBox.Items.IndexOf(Cells[1, Row]);

    end;  {with SelectionGrid do}

  AddFieldToPrint := False;
  FieldsToPrintPanelButtonPressed := False;
  FieldsToPrintPanel.Visible := True;
  FieldsToPrintPanel.SetFocus;

end;  {ChangeFieldToPrintButtonClick}

{===================================================================}
Procedure TSearchReportForm.DeleteFieldToPrintButtonClick(Sender: TObject);

{Delete the line that they are on and move all the other ones up.}

var
  I, J : Integer;

begin
  with FieldsToPrintGrid do
    begin
      For I := Row to (RowCount - 2) do  {Don't clear the header.}
        For J := 0 to (ColCount - 1) do
          Cells[J, I] := Cells[J, (I + 1)];

        {Make sure to clear the last line.}

      For J := 0 to (ColCount - 1) do
        Cells[J, (RowCount - 1)] := '';

    end;  {with FieldsToPrintGrid do}

end;  {DeleteFieldToPrintButtonClick}

{===================================================================}
Procedure TSearchReportForm.ClearFieldsToPrintButtonClick(Sender: TObject);

{Clear all the FieldsToPrints in the grid.}

var
  I, J : Integer;

begin
  with FieldsToPrintGrid do
    For I := 1 to (RowCount - 1) do  {Don't clear the header.}
      For J := 0 to (ColCount - 1) do
        Cells[J, I] := '';

end;  {ClearFieldsToPrintButtonClick}

{====================================================================}
Procedure TSearchReportForm.MSWordMergeButtonClick(Sender: TObject);

{CHG07062003-1(2.07f): Automatically add fields needed for MS word merge letter.
                       Also allow for a salutation different than Name 1 and Name 2.}

var
  I : Integer;

begin
  WordSalutationGroupBox.Visible := True;
  ClearFieldsToPrintButtonClick(Sender);

  with FieldsToPrintGrid do
    begin
      For I := 1 to 8 do
        Cells[0, I] := 'Base Information';

      Cells[1, 1] := 'Name 1';
      Cells[1, 2] := 'Name 2';
      Cells[1, 3] := 'Addr 1';
      Cells[1, 4] := 'Addr 2';
      Cells[1, 5] := 'Street';
      Cells[1, 6] := 'City';
      Cells[1, 7] := 'State';
      Cells[1, 8] := 'Zip';

    end;  {with FieldsToPrintGrid do}

end;  {MSWordMergeButtonClick}

{====================================================================}
Procedure TSearchReportForm.TotalsToPrintGridDblClick(Sender: TObject);

{FXX11021999-3: Allow double clicking of grid line to modify or add.}

begin
  with TotalsToPrintGrid do
    If (Deblank(Cells[0, Row]) = '')
      then AddTotalToPrintButtonClick(TotalsToPrintGrid)
      else ChangeTotalToPrintButtonClick(TotalsToPrintGrid);

end;  {TotalsToPrintGridDblClick}

{CHG12051997-2: Allow the user to select totals to print.}
{====================================================================}
Procedure TSearchReportForm.AddTotalToPrintButtonClick(Sender: TObject);

begin
  AddTotalToPrint := True;
  TotalsToPrintPanelButtonPressed := False;
  TotalsToPrintPanel.Visible := True;
  TotalsToPrintPanel.SetFocus;

end;  {AddTotalToPrintButtonClick}

{====================================================================}
Procedure TSearchReportForm.ChangeTotalToPrintButtonClick(Sender: TObject);

begin
    {Set up the values in the grid.}

  with TotalsToPrintGrid do
    begin
      TotalsToPrintScreenListBox.ItemIndex := TotalsToPrintScreenListBox.Items.IndexOf(Cells[0, Row]);

        {Set the Totals.}
      TotalsToPrintScreenListBoxClick(Sender);

      TotalsToPrintLabelListBox.ItemIndex := TotalsToPrintLabelListBox.Items.IndexOf(Cells[1, Row]);

    end;  {with SelectionGrid do}

  AddTotalToPrint := False;
  TotalsToPrintPanelButtonPressed := False;
  TotalsToPrintPanel.Visible := True;
  TotalsToPrintPanel.SetFocus;

end;  {ChangeTotalToPrintButtonClick}

{====================================================================}
Procedure TSearchReportForm.DeleteTotalToPrintButtonClick(Sender: TObject);

{Delete the line that they are on and move all the other ones up.}

var
  I, J : Integer;

begin
  with TotalsToPrintGrid do
    begin
      For I := Row to (RowCount - 2) do  {Don't clear the header.}
        For J := 0 to (ColCount - 1) do
          Cells[J, I] := Cells[J, (I + 1)];

        {Make sure to clear the last line.}

      For J := 0 to (ColCount - 1) do
        Cells[J, (RowCount - 1)] := '';

    end;  {with TotalsToPrintGrid do}

end;  {DeleteTotalToPrintButtonClick}

{====================================================================}
Procedure TSearchReportForm.ClearTotalToPrintButtonClick(Sender: TObject);

{Clear all the TotalsToPrints in the grid.}

var
  I, J : Integer;

begin
  with TotalsToPrintGrid do
    For I := 1 to (RowCount - 1) do  {Don't clear the header.}
      For J := 0 to (ColCount - 1) do
        Cells[J, I] := '';

end;  {ClearTotalToPrintButtonClick}

{====================================================================}
Procedure TSearchReportForm.TotalsToPrintScreenListBoxClick(Sender: TObject);

{Fill in the Totals for this screen.}

var
  _ScreenName : String;
  I : Integer;

begin
  TotalsToPrintLabelListBox.Items.Clear;

  with TotalsToPrintScreenListBox do
    For I := 0 to (Items.Count - 1) do
      If Selected[I]
        then _ScreenName := Items[I];

  For I := 0 to (ScreenLabelList.Count - 1) do
    with ScreenLabelPtr(ScreenLabelList[I])^ do
      If (RTrim(ScreenName) = RTrim(_ScreenName))
        then TotalsToPrintLabelListBox.Items.Add(LabelName);

end;  {TotalsToPrintScreenListBoxClick}

{====================================================================}
Procedure TSearchReportForm.CancelTotalsButtonClick(Sender: TObject);

begin
  TotalsToPrintPanelButtonPressed := True;
  TotalsToPrintPanel.Visible := False;
end;  {CancelTotalsButtonClick}

{====================================================================}
Procedure TSearchReportForm.DoneTotalsButtonClick(Sender: TObject);

{Make sure that they have selected from all the criteria.
 If so, put the entry in a grid.}

var
  OKToExit, ScreenSelected, LabelSelected : Boolean;
  I, Index, ScreenIndex, LabelIndex : Integer;

begin
  ScreenSelected := False;
  LabelSelected := False;
  ScreenIndex := 0;
  LabelIndex := 0;

  with TotalsToPrintScreenListBox do
    For I := 0 to (Items.Count - 1) do
      If Selected[I]
        then
          begin
            ScreenSelected := True;
            ScreenIndex := I;
          end;

  with TotalsToPrintLabelListBox do
    For I := 0 to (Items.Count - 1) do
      If Selected[I]
        then
          begin
            LabelSelected := True;
            LabelIndex := I;
          end;

  OKToExit := (ScreenSelected and LabelSelected);

  If OKToExit
    then
      begin
        TotalsToPrintPanelButtonPressed := True;
        TotalsToPrintPanel.Visible := False;

          {Now insert it at the end.}

        with TotalsToPrintGrid do
          begin
              {CHG10191997-5: Allow for modification of selections.}

            If AddTotalToPrint
              then
                begin
                    {First find the first open line.}
                  Index := 0;

                  For I := 1 to (RowCount - 1) do
                    If (Deblank(Cells[0, I]) <> '')
                      then Index := I;

                  Index := Index + 1;
                end
              else Index := Row;

            Cells[0, Index] := TotalsToPrintScreenListBox.Items[ScreenIndex];
            Cells[1, Index] := TotalsToPrintLabelListBox.Items[LabelIndex];

          end;  {with TotalsToPrintGrid do}

      end  {If OKToExit}
    else MessageDlg('Please enter a screen and label.',
                    mtError, [mbOK], 0);

end;  {DoneTotalsButtonClick}

{====================================================================}
Procedure TSearchReportForm.TotalsToPrintPanelExit(Sender: TObject);

{Make sure they don't leave the panel without pressing a button.}

begin
  If not TotalsToPrintPanelButtonPressed
    then TotalsToPrintPanel.SetFocus;

end;  {TotalsToPrintPanelExit}

{====================================================================}
Procedure TSearchReportForm.SaveButtonClick(Sender: TObject);

{FXX04091999-8: Add ability to save and load search report options.}

var
  I, J : Integer;
  TempFile : TextFile;

begin
  SaveReportOptions(Self, OpenDialog, SaveDialog, 'search.src', 'Search Report');

    {FXX11021999-8: Need special logic for search report to save and load ValuesList.}

  AssignFile(TempFile, SaveDialog.FileName);
  Append(TempFile);

  For I := 0 to (ValuesList.Count - 1) do
    begin
      Write(TempFile, 'ValuesList' + IntToStr(I) + ',' + 'TList' + ',');

      For J := 0 to (TStringList(ValuesList[I]).Count - 1) do
        Write(TempFile, TStringList(ValuesList[I])[J], ',');

      Writeln(TempFile);

    end;  {For I := 0 to (ValuesList.Count - 1) do}

  CloseFile(TempFile);

end;  {SaveButtonClick}

{====================================================================}
Procedure TSearchReportForm.LoadButtonClick(Sender: TObject);

{FXX04091999-8: Add ability to save and load search report options.}

var
  I : Integer;
  TempFile : TextFile;
  Value, TempStr : String;
  TempStringList : TStringList;
  Done : Boolean;

begin
    {FXX04202001-1: Don't continue processing if they cancelled.}

  If LoadReportOptions(Self, OpenDialog, 'search.src', 'Search Report')
    then
      begin
          {FXX11021999-8: Need special logic for search report to save and load ValuesList.}
          {Clear the values list.}

        For I := (ValuesList.Count - 1) downto 0 do
          begin
            TStringList(ValuesList[I]).Free;
            ValuesList[I] := nil;  {Force to nil so Pack works.}
          end;

        ValuesList.Pack;

          {Now go through the file and find the entries.}

        AssignFile(TempFile, OpenDialog.FileName);
        Reset(TempFile);

        Readln(TempFile, TempStr);

        Done := False;

        repeat
          Readln(TempFile, TempStr);

          If EOF(TempFile)
            then Done := True;

          If (Pos('ValuesList', TempStr) > 0)
            then
              begin
                  {Delete the first two columns.}

                TempStr := DeleteUpToChar(',', TempStr, True);
                TempStr := DeleteUpToChar(',', TempStr, True);
                TempStringList := TStringList.Create;

                repeat
                  Value := GetUpToChar(',', TempStr, False);
                  TempStringList.Add(Value);
                  TempStr := DeleteUpToChar(',', TempStr, True);

                until (Deblank(TempStr) = '');

                ValuesList.Add(TempStringList);

              end;  {If (Pos('ValuesList', TempStr > 0)}

        until Done;

        CloseFile(TempFile);

      end;  {If LoadReportOptions(Self, OpenDialog, 'search.src', 'Search Report')}

end;  {LoadButtonClick}

{============================================================================}
Function DetermineComparisonType(ComparisonStr : String) : Integer;

begin
  Result := -1;

    {FXX10271997-1: I had changed the screen text from 'equals' to 'equal to'
                    for readability but had not changed it here so
                    the ComparisonType was no being found.}

  If (ComparisonStr = 'equal to')
    then Result := coEqual;

  If (ComparisonStr = 'greater than')
    then Result := coGreaterThan;

  If (ComparisonStr = 'less than')
    then Result := coLessThan;

  If (ComparisonStr = 'greater than or equal to')
    then Result := coGreaterThanOrEqual;

  If (ComparisonStr = 'less than or equal to')
    then Result := coLessThanOrEqual;

  If (ComparisonStr = 'not equal to')
    then Result := coNotEqual;

  If (ComparisonStr = 'is blank')
    then Result := coBlank;

  If (ComparisonStr = 'is not blank')
    then Result := coNotBlank;

    {CHG10091998-2: Check for partial strings}

  If (ComparisonStr = 'contains')
    then Result := coContains;

    {CHG09111999-1: Add starts with.}

  If (ComparisonStr = 'starts with')
    then Result := coStartsWith;

  If (ComparisonStr = 'ends with')
    then Result := coEndsWith;

  If (ComparisonStr = 'between')
    then Result := coBetween;

end;  {DetermineComparisonType}

{====================================================================}
Procedure TSearchReportForm.LoadCriteriaListFromGrid(CriteriaList : TList);

{Transfer the data in the criteria grid to a TList for easier use.}

var
  PCriteria : CriteriaPtr;
  I, J, LastSearchTableIndex : Integer;
  Found, Quit : Boolean;

begin
    {Set up the arrays of conditions they want and open the
     corresponding tables.}

  with SelectionGrid do
    For I := 1 to (RowCount - 1) do
      If (Deblank(Cells[0, I]) <> '')  {Make sure this line is filled in}
        then
          begin
            New(PCriteria);

            with PCriteria^ do
              begin
                ScreenName := Cells[0, I];
                LabelName := Cells[1, I];
                TableName := GetTableNameFromScreenName(ScreenLabelList, ScreenName, LabelName);
                FieldName := GetFieldNameForScreenLabel(ScreenLabelList, ScreenName, LabelName);
                ComparisonType := DetermineComparisonType(Cells[2, I]);

                  {The values are now stored in ValuesList where the entry
                   in ValuesList corresponds to the entry in the CriteriaList.}

                (*TempStringList := TStringList(ValuesList[I - 1]);
                ComparisonValue := TStringList.Create;

                  {CHG10181999-1: Allow for more than 1 entry in values.}

                For J := 0 to (TStringList(ValuesList[I - 1]).Count - 1) do
                  ComparisonValue.Add(TStringList(ValuesList[I - 1])[J]);*)

                  {Figure out which search table to use and open it.}

                If (TableName = ParcelTableName)
                  then SearchTableNumber := -1  {For the parcel table, we use the existing one.}
                  else
                    begin
                      Found := False;
                      LastSearchTableIndex := -1;

                      For J := 0 to (CriteriaList.Count - 1) do
                        begin
                            {Keep track of the highest search table used
                             so far.}

                          with CriteriaPtr(CriteriaList[J])^ do
                            If (SearchTableNumber > LastSearchTableIndex)
                              then LastSearchTableIndex := SearchTableNumber;

                            {Now check to see if the search table for this
                             criteria matches the criteria we are looking
                             at. If so, we will just share the search tables.}

                          If (CriteriaPtr(CriteriaList[J])^.TableName = TableName)
                            then
                              begin
                                Found := True;
                                SearchTableNumber := CriteriaPtr(CriteriaList[J])^.SearchTableNumber;
                              end;

                        end;  {For J := 0 to (CriteriaList.Count - 1) do}

                        {If this table is not already being used by another
                         criteria, then we will assign a new one and open it.}

                      If not Found
                        then
                          begin
                            LastSearchTableIndex := LastSearchTableIndex + 1;

                            SearchTableNumber := LastSearchTableIndex;

                            OpenTableForProcessingType(TTable(SearchTableList[LastSearchTableIndex]),
                                                       TableName, ProcessingType,
                                                       Quit);

                              {FXX04032002-1: Need to account for other tables
                                              that do not have the tax roll year in
                                              their key.}
                              {CHG03042004-1(2.07l2): Add support for grievance search.}

                            If TableIsYearBasedTable(TableName)
                              then TTable(SearchTableList[LastSearchTableIndex]).IndexName := 'BYTAXROLLYR_SWISSBLKEY'
                              else TTable(SearchTableList[LastSearchTableIndex]).IndexName := 'BYSWISSBLKEY';

                          end;  {If not Found}

                    end;  {else of If (TableName = ParcelTableName)}

              end;  {with PCriteria do}

            CriteriaList.Add(PCriteria);

          end;  {If (Deblank(Cells[0, I]) <> '')}

end;  {LoadCriteriaListFromGrid}

{========================================================================}
Procedure AddOneFieldToPrint(FieldsToPrintGrid : TStringGrid;
                             Screen,
                             Field : String);

var
  I, Index : Integer;
  BlankFound : Boolean;

begin
  BlankFound := False;
  Index := -1;

  with FieldsToPrintGrid do
    begin
      For I := 0 to (RowCount - 1) do
        If ((not BlankFound) and
            (Deblank(Cells[0, I]) = ''))
          then
            begin
              Index := I;
              BlankFound := True;
            end;

      If not BlankFound
        then
          begin
            RowCount := RowCount + 1;
            Index := RowCount - 1;
          end;

      Cells[0, Index] := Screen;
      Cells[1, Index] := Field;

    end;  {with FieldsToPrintGrid do}

end;  {AddFieldToPrint}

{========================================================================}
Procedure TSearchReportForm.LoadFieldsToPrintFromGrid(FieldsToPrint : TList;
                                                      JustificationList,
                                                      FieldWidths : TStringList);

{Load the fields to print.}
{CHG11181997-2: Justify the columns based on type.}
{CHG11181997-4: Make the field widths dynamic.}

var
  PFieldToPrint : FieldsToPrintPtr;
  I, J, LastSearchTableIndex : Integer;
  Quit, Found : Boolean;
  FieldType : TFieldType;
  ColumnWidth, FieldWidth : Integer;
  TempBookmarkList : TList;

begin
  Quit := False;
  FieldWidth := 1;
  FieldType := ftString;

    {Set up the arrays of conditions they want and open the
     corresponding tables.}
    {FXX09201999-2: Do mailing addr differently.}

(*  If MailingAddressCheckBox.Checked
    then
      begin
        AddOneFieldToPrint(FieldsToPrintGrid, 'Base Information', 'Name 2');
        AddOneFieldToPrint(FieldsToPrintGrid, 'Base Information', 'Addr 1');
        AddOneFieldToPrint(FieldsToPrintGrid, 'Base Information', 'Addr 2');
        AddOneFieldToPrint(FieldsToPrintGrid, 'Base Information', 'City');
        AddOneFieldToPrint(FieldsToPrintGrid, 'Base Information', 'State');
        AddOneFieldToPrint(FieldsToPrintGrid, 'Base Information', 'Zip');
        AddOneFieldToPrint(FieldsToPrintGrid, 'Base Information', 'Zip Plus 4');

      end;  {If MailingAddressCheckBox.Checked}  *)

  PrintMailingAddress := MailingAddressCheckBox.Checked;

  with FieldsToPrintGrid do
    For I := 1 to (RowCount - 1) do
      If (Deblank(Cells[0, I]) <> '')  {Make sure this line is filled in}
        then
          begin
            New(PFieldToPrint);

            with PFieldToPrint^ do
              begin
                ScreenName := Cells[0, I];
                LabelName := Cells[1, I];
                TableName := GetTableNameFromScreenName(ScreenLabelList, ScreenName, LabelName);
                FieldName := GetFieldNameForScreenLabel(ScreenLabelList, ScreenName, LabelName);

                  {CHG10041999-2: Allow searching and printing of assessment notes
                                  and letter texts.}
                  {FXX03062000-1: Had sales table as being only 1 value.}

                If ((TableName = ParcelTableName) or
                    (TableName = AssessmentTableName) or
                    (TableName = ClassTableName) or
                    (TableName = AssessmentNotesTableName) or
                    (TableName = AssessmentLetterTextTableName))
                  then CanHaveMoreThanOneValue := False
                  else CanHaveMoreThanOneValue := True;

                  {Figure out which search table to use and open it.}

                If (TableName = ParcelTableName)
                  then
                    begin
                      SearchTableNumber := -1;  {For the parcel table, we use the existing one.}

                      If (ParcelTable.FindField(FieldName) <> nil)
                        then
                          begin
                            FieldType := ParcelTable.FieldByName(FieldName).DataType;
                            FieldWidth :=ParcelTable.FieldByName(FieldName).DataSize;
                          end
                        else
                          begin
                            FieldType := ftString;
                            FieldWidth := 20;
                          end;

                    end
                  else
                    begin
                      Found := False;
                      LastSearchTableIndex := -1;

                      For J := 0 to (FieldsToPrintList.Count - 1) do
                        begin
                            {Keep track of the highest search table used
                             so far.}

                          with FieldsToPrintPtr(FieldsToPrintList[J])^ do
                            If (SearchTableNumber > LastSearchTableIndex)
                              then LastSearchTableIndex := SearchTableNumber;

                            {Now check to see if the search table for this
                             fields to print matches the table for the fields
                             to print we are looking
                             at. If so, we will just share the search tables.}

                          If (FieldsToPrintPtr(FieldsToPrintList[J])^.TableName = TableName)
                            then
                              begin
                                Found := True;
                                SearchTableNumber := FieldsToPrintPtr(FieldsToPrintList[J])^.SearchTableNumber;

                                  {FXX02061998-6: Need to look at search table # index instead of
                                                  the jth index.}

                                try
                                  FieldType :=
                                    TTable(FieldsToPrintTableList[SearchTableNumber]).FieldByName(FieldName).DataType;
                                  FieldWidth :=
                                    TTable(FieldsToPrintTableList[SearchTableNumber]).FieldByName(FieldName).DataSize;
                                except
                                  FieldType := ftInteger;
                                  FieldWidth := 8;
                                end;

                              end;  {If (FieldsToPrintPtr(...}

                        end;  {For J := 0 to (FieldsToPrintList.Count - 1) do}

                        {If this table is not already being used by another
                         criteria, then we will assign a new one and open it.}

                      If not Found
                        then
                          begin
                            LastSearchTableIndex := LastSearchTableIndex + 1;

                            SearchTableNumber := LastSearchTableIndex;

                            OpenTableForProcessingType(TTable(FieldsToPrintTableList[LastSearchTableIndex]),
                                                       TableName, ProcessingType,
                                                       Quit);

                              {FXX04032002-1: Need to account for other tables
                                              that do not have the tax roll year in
                                              their key.}
                              {CHG03042004-1(2.07l2): Add support for grievance search.}

                            If TableIsYearBasedTable(TableName)
                              then TTable(FieldsToPrintTableList[LastSearchTableIndex]).IndexName := 'BYTAXROLLYR_SWISSBLKEY'
                              else TTable(FieldsToPrintTableList[LastSearchTableIndex]).IndexName := 'BYSWISSBLKEY';

                            with TTable(FieldsToPrintTableList[LastSearchTableIndex]) do
                              try
                                FieldType := FieldByName(FieldName).DataType;
                                FieldWidth := FieldByName(FieldName).DataSize;
                              except
                                FieldType := ftInteger;
                                FieldWidth := 8;
                              end;


                              {FXX03052000-1: Make it so that only recs that meet criteria
                                              are displayed.}
                              {Create a place holder for each table.}

                            TempBookmarkList := TList.Create;
                            BookmarkList.Add(TempBookmarkList);

                          end;  {If not Found}

                    end;  {else of If (TableName = ParcelTableName)}

                case FieldType of
                  ftMemo,
                  ftString : JustificationList.Add('pjLeft');

                  ftSmallInt,
                  ftInteger,
                  ftWord,
                  ftFloat,
                  ftCurrency,
                  ftDate,
                  ftTime,
                  ftDateTime : JustificationList.Add('pjRight');

                  ftBoolean : JustificationList.Add('pjCenter');

                end;  {case FieldType of}

                  {Make the width of the field the greater of
                   the label and the data size. Note that since 4-6
                   use the same columns as 1-3 respectively, we
                   need to do max of existing column.}

                (*ColumnWidth := MaxInt(FieldWidth, Length(Trim(LabelName))); *)

                  {FXX05032000-2: If this is a string, there is a length byte and
                                  we need to get rid of it for columnar extracts.}

                If (FieldType = ftString)
                  then FieldWidth := FieldWidth - 1;

                ActualFieldWidths.Add(IntToStr(FieldWidth));

                (*If (FieldWidths.Count > 3)
                  then ColumnWidth := MaxInt(ColumnWidth, StrToInt(FieldWidths[(FieldWidths.Count - 1) MOD 4]));

                If (ColumnWidth > Trunc(DefaultFieldWidth * 10))
                  then ColumnWidth := Trunc(DefaultFieldWidth * 10); *)

                ColumnWidth := Trunc(DefaultFieldWidth * 10);
                FieldWidths.Add(IntToStr(ColumnWidth));

              end;  {with PFieldToPrint do}

            FieldsToPrint.Add(PFieldToPrint);

          end;  {If (Deblank(Cells[0, I]) <> '')}

    {Divide the field widths by ten to go from chars to inches,
     assuming 10cpi.}

  For I := 0 to (FieldWidths.Count - 1) do
    FieldWidths[I] := FloatToStr(StrToFloat(FieldWidths[I]) / 10);

end;  {LoadFieldsToPrintFromGrid}

{========================================================================}
Procedure TSearchReportForm.LoadTotalsToPrintFromGrid(TotalsToPrintList : TList);

{Load the Totals to print.}
{CHG12051997-2: Allow the user to choose totals.}

var
  PTotalToPrint : TotalsToPrintPtr;
  I, J, LastSearchTableIndex : Integer;
  Quit, Found : Boolean;

begin
  Quit := False;

    {Set up the arrays of conditions they want and open the
     corresponding tables.}

  with TotalsToPrintGrid do
    For I := 1 to (RowCount - 1) do
      If (Deblank(Cells[0, I]) <> '')  {Make sure this line is filled in}
        then
          begin
            New(PTotalToPrint);

            with PTotalToPrint^ do
              begin
                ScreenName := Cells[0, I];
                LabelName := Cells[1, I];
                TableName := GetTableNameFromScreenName(ScreenLabelList, ScreenName, LabelName);
                FieldName := GetFieldNameForScreenLabel(ScreenLabelList, ScreenName, LabelName);
                Values := TStringList.Create;

                  {Figure out which search table to use and open it.}

                If (TableName = ParcelTableName)
                  then SearchTableNumber := -1  {For the parcel table, we use the existing one.}
                  else
                    begin
                      Found := False;
                      LastSearchTableIndex := -1;

                      For J := 0 to (TotalsToPrintList.Count - 1) do
                        begin
                            {Keep track of the highest search table used
                             so far.}

                          with TotalsToPrintPtr(TotalsToPrintList[J])^ do
                            If (SearchTableNumber > LastSearchTableIndex)
                              then LastSearchTableIndex := SearchTableNumber;

                            {Now check to see if the search table for this
                             Totals to print matches the table for the Totals
                             to print we are looking
                             at. If so, we will just share the search tables.}

                          If (TotalsToPrintPtr(TotalsToPrintList[J])^.TableName = TableName)
                            then
                              begin
                                Found := True;
                                SearchTableNumber := TotalsToPrintPtr(TotalsToPrintList[J])^.SearchTableNumber;
                              end;  {If (TotalsToPrintPtr(...}

                        end;  {For J := 0 to (TotalsToPrintList.Count - 1) do}

                        {If this table is not already being used by another
                         criteria, then we will assign a new one and open it.}

                      If not Found
                        then
                          begin
                            LastSearchTableIndex := LastSearchTableIndex + 1;

                            SearchTableNumber := LastSearchTableIndex;

                            OpenTableForProcessingType(TTable(TotalsToPrintTableList[LastSearchTableIndex]),
                                                       TableName, ProcessingType,
                                                       Quit);

                         {FXX04032002-1: Need to account for other tables
                                              that do not have the tax roll year in
                                              their key.}
                              {CHG03042004-1(2.07l2): Add support for grievance search.}

                            If TableIsYearBasedTable(TableName)
                              then TTable(TotalsToPrintTableList[LastSearchTableIndex]).IndexName := 'BYTAXROLLYR_SWISSBLKEY'
                              else TTable(TotalsToPrintTableList[LastSearchTableIndex]).IndexName := 'BYSWISSBLKEY';

                          end;  {If not Found}

                    end;  {else of If (TableName = ParcelTableName)}

                Subtotal := 0;
                GrandTotal := 0;

              end;  {with PTotalToPrint do}

            TotalsToPrintList.Add(PTotalToPrint);

          end;  {If (Deblank(Cells[0, I]) <> '')}

end;  {LoadTotalsToPrintFromGrid}

{========================================================================}
Procedure TSearchReportForm.ChooseTaxYearRadioGroupClick(Sender: TObject);

{FXX09111999-2: Make history search work.}

begin
  case ChooseTaxYearRadioGroup.ItemIndex of
    0, 1 : begin
             EditHistoryYear.Text := '';
             EditHistoryYear.Visible := False;
           end;

    2 : EditHistoryYear.Visible := True;

  end;  {case ChooseTaxYearRadioGroup.ItemIndex of}

end;  {ChooseTaxYearRadioGroupClick}

{========================================================================}
Procedure TSearchReportForm.FillInNumberOfForcedColsRec(var NumberOfColumnsForEachFieldRec : NumberOfColumnsForEachFieldRecord);

begin
  with NumberOfColumnsForEachFieldRec do
    begin
      Exemptions := StrToInt(EXColumnsEdit.Text);
      ComBuildings := StrToInt(ComBuildingColumnsEdit.Text);
      ComLands := StrToInt(ComLandColumnsEdit.Text);
      ComImprovements := StrToInt(ComImprovementColumnsEdit.Text);
      ComIncomeExpenses := StrToInt(ComIncExpColumnsEdit.Text);
      ComUses := StrToInt(ComRentColumnsEdit.Text);
      ComSites := StrToInt(ComSiteColumnsEdit.Text);
      ResBldgs := StrToInt(ResBuildingColumnsEdit.Text);
      ResLands := StrToInt(ResLandColumnsEdit.Text);
      ResImprovements := StrToInt(ResImprovementColumnsEdit.Text);
      ResSites := StrToInt(ResSiteColumnsEdit.Text);
      Sales := StrToInt(SalesColumnsEdit.Text);
      ExemptionsDenied := StrToInt(EXDeniedColumnsEdit.Text);
      ExemptionsRemoved := StrToInt(EXRemovedColumnsEdit.Text);
      SpecialDistricts := StrToInt(SDColumnsEdit.Text);

        {CHG03042004-1(2.07l2): Add support for grievance \ certs to search report.}
        {CHG06052004-1(2.07l5): Add support for grievance exemptions asked.}

      Grievance := StrToInt(GrievanceColumnsEdit.Text);
      GrievanceResults := StrToInt(GrievanceColumnsEdit.Text);  {Same as grievance}
      GrievanceExemptionsAsked := StrToInt(GrievanceColumnsEdit.Text);  {Same as grievance}
      Certiorari := StrToInt(CertiorariColumnsEdit.Text);
      CertiorariNotes := StrToInt(CertiorariNotesColumnsEdit.Text);
      CertiorariAppraisals := StrToInt(CertiorariAppraisalsColumnsEdit.Text);
      CertiorariCalendar := StrToInt(CertiorariCalendarColumnsEdit.Text);
      SmallClaims := StrToInt(SmallClaimsColumnsEdit.Text);
      SmallClaimsNotes := StrToInt(SmallClaimsNotesColumnsEdit.Text);
      SmallClaimsAppraisals := StrToInt(SmallClaimsAppraisalsColumnsEdit.Text);
      SmallClaimsCalendar := StrToInt(SmallClaimsCalendarColumnsEdit.Text);

      Notes := StrToInt(NotesColumnsEdit.Text);

    end;  {with NumberOfColumnsForEachFieldRec do}

end;  {FillInNumberOfForcedColsRec}

{========================================================================}
Procedure TSearchReportForm.AllSBLCheckBoxClick(Sender: TObject);

{FXX02122002-3: Clicking "All Parcel IDs" did not work.}

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

end;  {AllSBLCheckBoxClick}

{========================================================================}
Procedure TSearchReportForm.PrintButtonClick(Sender: TObject);

var
  NewFileName : String;
  TempFile : File;
  I : Integer;
  ValidEntry, WideCarriage, Cancel, Quit : Boolean;
  NewLabelFileName : String;

begin
  Quit := False;
  bForceLetterSize := cbForceLetterSize.Checked;
  bMeanMedian := cbMeanMedian.Checked;

    {CHG10121998-1: Add user options for default destination and show vet max msg.}

(*  SetPrintToScreenDefault(PrintDialog);*)

  PrintHeadersOnFirstLineOfExtract := FirstLineIsHeadersCheckBox.Checked;
  NullBlanks := NullBlanksCheckBox.Checked;

    {CHG11091999-1: Allow select of exemptions and special districts.}

  SelectedExemptionCodes := TStringList.Create;
  SelectedSpecialDistricts := TStringList.Create;

  PrintAllExemptions := False;
  PrintAllSpecialDistricts := False;

  with ExemptionListBox do
    If (SelCount = Items.Count)
      then PrintAllExemptions := True
      else
        For I := 0 to (Items.Count - 1) do
          If Selected[I]
            then SelectedExemptionCodes.Add(Take(5, Items[I]));

  with SpecialDistrictListBox do
    If (SelCount = Items.Count)
      then PrintAllSpecialDistricts := True
      else
        For I := 0 to (Items.Count - 1) do
          If Selected[I]
            then SelectedSpecialDistricts.Add(Take(5, Items[I]));

    {FXX11101999-1: Add more refinement to the choice of STARs.}

  If ((SelectedExemptionCodes.Count = 1) and
      (SelectedExemptionCodes[0] = '41834'))
    then
      begin
        EnhancedSTARTypeDialog.ShowModal;
        EnhancedSTARType := EnhancedSTARTypeDialog.EnhancedSTARType;

          {CHG01212004-1(2.08): Add ability to select IVP enrollment status as a choice.}

        IVPEnrollmentStatusType := EnhancedSTARTypeDialog.IVPEnrollmentStatusType;

      end;  {If ((SelectedExemptionCodes.Count = 1) and ...}

    {CHG12022004-6(2.8.1.1): Use enhanced print dialog for Search report.}

  If (LoadFromParcelListCheckBox.Checked and
      CreateParcelListCheckBox.Checked)
    then MessageDlg('Sorry, you can not choose to both load from the parcel list and' + #13 +
                    'create a new parcel list.', mtError, [mbOK], 0)
    else
      If ((GlblUseEnhancedPrintDialog and
           EnhancedPrintDialog.Execute) or
          ((not GlblUseEnhancedPrintDialog) and
           PrintDialog.Execute))
        then
          begin
            Cancel := False;
            SaveExportDialog.InitialDir := GlblExportDir;
            IncludeSwisOnParcelID := IncludeSwisOnParcelIDCheckBox.Checked;

            IncludeLegalAddrInExtract := IncludeLegalAddrCheckBox.Checked;
            IncludeOwnerInExtract := IncludeOwnerCheckBox.Checked;
            IncludeParcelIDInExtract := IncludeParcelIDCheckBox.Checked;

              {FXX12151998-1: Allow print of search report in totals only mode.}

            TotalsOnly := TotalsOnlyCheckBox.Checked;

            CreateParcelList := CreateParcelListCheckBox.Checked;

              {FXX05281999-2: Add load from parcel list.}

            LoadFromParcelList := LoadFromParcelListCheckBox.Checked;

            FillInNumberOfForcedColsRec(NumberOfColumnsForEachFieldRec);

              {CHG04202001-1: Let them enter a parcel ID range.}

            StartSwisSBLKey := '';
            EndSwisSBLKey := '';
            PrintAllParcelIDs := False;
            PrintToEndOfParcelIDs := False;

              {FXX02122002-3: Checking "All Parcel IDs" did not work.}

            If ((Deblank(StartSBLEdit.Text) = '') and
                (Deblank(EndSBLEdit.Text) = '') and
                (not (AllSBLCheckBox.Checked or
                      ToEndOfSBLCheckBox.Checked)))
              then
                begin
                  PrintAllParcelIDs := True;
                  AllSBLCheckBox.Checked := True;
                end
              else
                If AllSBLCheckBox.Checked
                  then PrintAllParcelIDs := True
                  else
                    begin
                      StartSwisSBLKey := ConvertSwisDashDotToSwisSBL(StartSBLEdit.Text,
                                                                     SwisCodeTable, ValidEntry);

                      If ToEndOfSBLCheckBox.Checked
                        then PrintToEndOfParcelIDs := True
                        else EndSwisSBLKey := ConvertSwisDashDotToSwisSBL(EndSBLEdit.Text,
                                                                          SwisCodeTable, ValidEntry);

                    end;  {else of If AllSBLCheckBox.Checked}

            If CreateParcelList
              then ParcelListDialog.ClearParcelGrid(True);

              {CHG02242001-1: Allow them to select how to extract multiple record types.}

            RecordsToPrintOrExtract := RecordsToPrintOrExtractRadioGroup.ItemIndex;

              {CHG10081998-1: Add extract file capability.}

            ExtractFileType := ExtractTypeRadioGroup.ItemIndex;

            If (ExtractFileType in [tfColumnar, tfCommaDelimited])
              then
                If SaveExportDialog.Execute
                  then
                    begin
                      AssignFile(ExtractFile, SaveExportDialog.FileName);
                      Rewrite(ExtractFile);
                    end
                  else Cancel := True;

              {If they want to print to Excel but are not printing to an
               extract file, we need to force an extract file.}

            If GlblUseEnhancedPrintDialog
              then ExtractToExcel := (EnhancedPrintDialog.PrintToExcel or ExtractToExcelCheckBox.Checked)
              else ExtractToExcel := ExtractToExcelCheckBox.Checked;

              {CHG04102003-1(2.06r): Allow for blank lines between coops in extracts and spreadsheets.}
              {Note that this can only be done if it is in parcel ID order.}

            BlankLinesBetweenCoops := (BlankLinesBetweenCoopsCheckBox.Checked and
                                       (PrintOrderRadioBox.ItemIndex = 0));

            If GlblUseEnhancedPrintDialog
              then _PrintLabels := (EnhancedPrintDialog.PrintLabels or PrintLabelCheckBox.Checked)
              else _PrintLabels := PrintLabelCheckBox.Checked;
            ParcelListForLabels := TStringList.Create;

              {CHG07062003-1(2.07f): Automatically add fields needed for MS word merge letter.
                                     Also allow for a salutation different than Name 1 and Name 2.}

            Salutation := Trim(EditSalutation.Text);

            If ExtractToExcel
              then
                If (ExtractFileType = tfNone)
                  then
                    begin
                      SpreadsheetFileName := GetPrintFileName(Self.Caption, True);
                      ExtractFileType := tfSpreadsheetOnly;
                      PrintHeadersOnFirstLineOfExtract := True;
                      AssignFile(ExtractFile, SpreadsheetFileName);
                      Rewrite(ExtractFile);

                    end  {If ((ExtractFileType = tfNone) and ...}
                  else SpreadsheetFileName := SaveExportDialog.FileName;

            If not Cancel
              then
                begin
                  Quit := False;

                  If not Quit
                    then
                      begin
                          {CHG02052005-1(2.8.3.4): Add the ability to alter the left margin.}

                        try
                          LeftMargin := StrToFloat(EditLeftMargin.Text);
                        except
                          LeftMargin := 0.3;
                        end;

                        SBLFieldWidth := 1.3;

                          {FXX11231997-5: Make sure to reset PrintingCancelled so can
                                          run 2x.}

                        PrintingCancelled := False;

                          {FXX11181997-4: Free and open the tables and lists each time
                                          so don't have problems running > 1 time without
                                          closing.}

                        CriteriaList := TList.Create;
                        FieldsToPrintList := TList.Create;
                        TotalsToPrintList := TList.Create;
                        JustificationList := TStringList.Create;
                        FieldWidths := TStringList.Create;
                        ActualFieldWidths := TStringList.Create;

                          {Create the tables for the search and fields to print lists and
                           put them in lists for easy reference.}

                        SearchTableList := TList.Create;
                        For I := 1 to 10 do
                          SearchTableList.Add(TTable.Create(nil));

                        FieldsToPrintTableList := TList.Create;
                        For I := 1 to 10 do
                          FieldsToPrintTableList.Add(TTable.Create(nil));

                          {CHG12051997-2: Allow the user to choose totals.}

                        TotalsToPrintTableList := TList.Create;
                        For I := 1 to 10 do
                          TotalsToPrintTableList.Add(TTable.Create(nil));

                        BookmarkList := TList.Create;

                          {Set the processing type.}

                        with ChooseTaxYearRadioGroup do
                          case ItemIndex of
                            0 : begin
                                  ProcessingType := NextYear;
                                  AssessmentYear := GlblNextYear;
                                end;

                            1 : begin
                                  ProcessingType := ThisYear;
                                  AssessmentYear := GlblThisYear;
                                end;

                            2 : begin
                                  ProcessingType := History;
                                  AssessmentYear := EditHistoryYear.Text;
                                end;

                          end;  {case GlblProcessingType of}

                          {FXX10091998-4: Reopen the table for the assessment year selected.}

                        OpenTableForProcessingType(ParcelTable, ParcelTableName,
                                                   ProcessingType, Quit);

                          {CHG11091999-1: Allow select of exemptions and special districts.}

                        OpenTableForProcessingType(ParcelExemptionTable, ExemptionsTableName,
                                                   ProcessingType, Quit);

                        OpenTableForProcessingType(ParcelSDTable, SpecialDistrictTableName,
                                                   ProcessingType, Quit);

                          {Set up the arrays of conditions they want and open the
                           corresponding tables. Note that the tables are opened here.}

                        LoadCriteriaListFromGrid(CriteriaList);

                        DefaultFieldWidth := 2.2;

                        LoadFieldsToPrintFromGrid(FieldsToPrintList, JustificationList,
                                                  FieldWidths);

                           {CHG12051997-2: Allow the user to choose totals.}

                        LoadTotalsToPrintFromGrid(TotalsToPrintList);

                          {Now see if we will need to create a details part for each
                           parcel (i.e. if they want to see something like exemptions
                           which can have several entries) or if it will all fit on a
                           row or two.}

                        ShowDetails := False;

                        For I := 0 to (FieldsToPrintList.Count - 1) do
                          with FieldsToPrintPtr(FieldsToPrintList[I])^ do
                            If CanHaveMoreThanOneValue
                              then ShowDetails := True;

                      {CHG11231997-2: Let the user select which swis codes they want
                                      so we can skip the swis codes they don't want.}

                        SelectedSwisCodes.Clear;

                        For I := 0 to (SwisCodeListBox.Items.Count - 1) do
                          If SwisCodeListBox.Selected[I]
                            then SelectedSwisCodes.Add(Take(6, SwisCodeListBox.Items[I]));

                          {CHG12091999-1: Allow users to select school and active status.}

                        SelectedSchoolCodes.Clear;

                        For I := 0 to (SchoolCodeListBox.Items.Count - 1) do
                          If SchoolCodeListBox.Selected[I]
                            then SelectedSchoolCodes.Add(Take(6, SchoolCodeListBox.Items[I]));

                        ActiveStatus := ActiveStatusRadioGroup.ItemIndex;

                          {CHG10131998-1: Set the printer settings based on what printer they selected
                                          only - they no longer need to worry about paper or landscape
                                          mode.}

                          {CHG12022004-6(2.8.1.1): Use enhanced print dialog for Search report.}

                        If not GlblUseEnhancedPrintDialog
                          then
                            begin
                              WideCarriage := (FieldsToPrintList.Count > 1);
                              AssignPrinterSettings(PrintDialog, ReportPrinter,
                                                    ReportFiler, [ptLaser],
                                                    WideCarriage, Quit);

                              If WideCarriage
                                then ReportPrinter.Orientation := RPDefine.poLandscape;

                            end;  {If not GlblUseEnhancedPrintDialog}

                        If bForceLetterSize
                        then
                        begin
                          ReportPrinter.SetPaperSize(dmPaper_Letter, 0, 0);
                          ReportFiler.SetPaperSize(dmPaper_Letter, 0, 0);
                        end;

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

                        If ((GlblUseEnhancedPrintDialog and
                             EnhancedPrintDialog.PrintToScreen) or
                            PrintDialog.PrintToFile)
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

                                  {CHG01182000-3: Allow them to choose a different name or copy right away.}
                                  {However, we can only do it if they print to screen first since
                                   report printer does not generate a file.}

                                ShowReportDialog('SEARCH.RPT', NewFileName, True);

                              finally
                                PreviewForm.Free;
                              end;  {If PrintRangeDlg.PreviewPrint}

                            end  {They did not select preview, so we will go
                                  right to the printer.}
                          else ReportPrinter.Execute;

                        ProgressDialog.Finish;

                          {FXX10111999-3: Tell people that printing is starting and
                                          done.}

                        (*DisplayPrintingFinishedMessage(PrintDialog.PrintToFile);*)

                          {FXX11181997-4: Free and open the tables and lists each time
                                          so don't have problems running > 1 time without
                                          closing.}
                          {FXX11231997-3: We should not have been freeing the screen labels
                                          list here since it would make running a second
                                          time impossible.}

                        FreeTList(CriteriaList, SizeOf(CriteriaRecord));
                        FreeTList(FieldsToPrintList, SizeOf(FieldsToPrintRecord));

                        For I := 0 to (TotalsToPrintList.Count - 1) do
                          with TotalsToPrintPtr(TotalsToPrintList[I])^ do
                          Values.Free;

                        FreeTList(TotalsToPrintList, SizeOf(TotalsToPrintRecord));

                        For I := 0 to 9 do
                          with TTable(SearchTableList[I]) do
                            begin
                              If Active
                                then Close;
                              Free;
                            end;

                        For I := 0 to 9 do
                          with TTable(FieldsToPrintTableList[I]) do
                            begin
                              If Active
                                then Close;
                              Free;
                            end;

                          {CHG12051997-2: Allow the user to choose totals.}

                        For I := 0 to 9 do
                          with TTable(TotalsToPrintTableList[I]) do
                            begin
                              If Active
                                then Close;
                              Free;
                            end;

                        For I := (BookmarkList.Count - 1) downto 0 do
                          TList(BookmarkList[I]).Free;
                        BookmarkList.Free;

                        SearchTableList.Free;
                        FieldsToPrintTableList.Free;
                        TotalsToPrintTableList.Free;
                        FieldWidths.Free;
                        ActualFieldWidths.Free;

                          {CHG06072003-1(2.07c): Allow for label print from Search Report.}

                        If (_PrintLabels and
                            ExecuteLabelOptionsDialog(LabelOptions) and
                            PrintDialog.Execute)
                          then
                            begin
                                {FXX10102003-1(2.07j1): Make sure to reset to letter paper after printing the
                                                        search report.}

                              ReportLabelFiler.SetPaperSize(dmPaper_Letter, 0, 0);
                              ReportLabelPrinter.SetPaperSize(dmPaper_Letter, 0, 0);

                              If PrintDialog.PrintToFile
                                then
                                  begin
                                    NewLabelFileName := GetPrintFileName(Self.Caption, True);
                                    GlblPreviewPrint := True;
                                    GlblDefaultPreviewZoomPercent := 70;
                                    ReportLabelFiler.FileName := NewLabelFileName;

                                    try
                                      PreviewForm := TPreviewForm.Create(self);
                                      PreviewForm.FilePrinter.FileName := NewLabelFileName;
                                      PreviewForm.FilePreview.FileName := NewLabelFileName;
                                      ReportLabelFiler.Execute;
                                      PreviewForm.ShowModal;
                                    finally
                                      PreviewForm.Free;

                                        {Now delete the file.}
                                      try

                                        AssignFile(TempFile, NewLabelFileName);
                                        OldDeleteFile(NewLabelFileName);

                                      finally
                                        {We don't care if it does not get deleted, so we won't put up an
                                         error message.}

                                        ChDir(GlblProgramDir);
                                      end;

                                    end;  {If PrintRangeDlg.PreviewPrint}

                                  end  {They did not select preview, so we will go
                                        right to the printer.}
                                else ReportLabelPrinter.Execute;

                            end;  {If ((mptLabels in MapPrintTypeDialog.PrintType) and ...}

                          {FXX11231997-2: We were not freeing the justification list.}

                        JustificationList.Free;

                        If (ExtractFileType <> tfNone)
                          then CloseFile(ExtractFile);

                        If (ExtractFileType in [tfColumnar, tfCommaDelimited])
                          then
                            begin
                                {CHG03232004-4(2.08): Change the email sending process and add it to all needed places.}

(*                              If (MessageDlg('Do you want to email the extract file?', mtConfirmation, [mbYes, mbNo], 0) = idYes)
                                then
                                  begin
                                    SelectedFiles := TStringList.Create;

                                    MailSubject := Trim(GlblMunicipalityName) + ' extract ' + DateToStr(Date);

                                    EMailFile(Self, ReturnPath(SaveExportDialog.FileName), '',
                                              StripPath(SaveExportDialog.FileName), MailSubject, SelectedFiles, False);
                                    SelectedFiles.Free;

                                  end;  {If (MessageDlg('Do you want to email this file?' + #13 +} *)

                                {CHG05131999-3: See if they want to copy\zip the file.}

                              If (MessageDlg('The extract file ' + SaveExportDialog.FileName +
                                             ' has been created.' + #13 +
                                             'Do you want to copy\zip the file to another drive or disk?',
                                             mtConfirmation, [mbYes, mbNo], 0) = idYes)
                                then
                                  begin
                                    with ZipCopyDlg do
                                      begin
                                        SelectFile(SaveExportDialog.FileName);
                                        FileName := SaveExportDialog.FileName;
                                        Execute;

                                      end;  {with ZipCopyDlg do}

                                  end;  {If (MessageDlg ...}

                            end;  {If (ExtractFileType in [tfColumnar, tfCommaDelimited])}

                        If ExtractToExcel
                          then
                            begin
                              SendTextFileToExcelSpreadsheet(SpreadsheetFileName, True,
                                                             False, '');

                                {If we created a temporary file to send to Excel, delete it.}

                              If (ExtractFileType = tfSpreadsheetOnly)
                                then
                                  try
                                    Chdir(GlblReportDir);
                                    OldDeleteFile(SpreadsheetFileName);
                                  except
                                  end;

                            end;  {If ExtractToExcel}

                      end;  {If not Quit}

                end;  {If not Cancel}

            ResetPrinter(ReportPrinter);
            If CreateParcelList
              then ParcelListDialog.Show;

            SelectedExemptionCodes.Free;
            SelectedSpecialDistricts.Free;
            ParcelListForLabels.Free;

          end;  {If PrintDialog.Execute}

end;  {PrintButtonClick}

{===================================================================}
Procedure TSearchReportForm.ReportLabelPrintHeader(Sender: TObject);

begin
  PrintLabelHeader(Sender, LabelOptions);
end;  {ReportLabelPrintHeader}

{===================================================================}
Procedure TSearchReportForm.ReportLabelPrint(Sender: TObject);

begin
  PrintLabels(Sender, ParcelListForLabels, ParcelTable,
              SwisCodeTable, AssessmentYearControlTable,
              AssessmentYear, LabelOptions);
end;  {ReportLabelPrint}

{===================================================================}
Procedure TSearchReportForm.FormClose(    Sender: TObject;
                                  var Action: TCloseAction);

var
  I : Integer;

begin
  CloseTablesForForm(Self);
  FreeTList(ScreenLabelList, SizeOf(ScreenLabelRecord));
  SelectedSwisCodes.Free;
  SelectedSchoolCodes.Free;

    {Free up the child window and set the ClosingAForm Boolean to
     true so that we know to delete the tab.}

  Action := caFree;
  GlblClosingAForm := True;
  GlblClosingFormCaption := Caption;

  For I := (ValuesList.Count - 1) downto 0 do
    TStringList(ValuesList[I]).Free;

  ValuesList.Pack;
  ValuesList.Free;

end;  {FormClose}

{============================================================================}
{========================  PRINTING LOGIC ===================================}
{============================================================================}
Function FormatNumberField(Number : String) : String;

{FXX01292000-1: Strip and $ or , from numeric fields.}

begin
  Number := StripChar(Number, ',', ' ', False);
  Result := StripChar(Number, '$', ' ', False);
end;

{============================================================================}
Function OneCriteriaMet(TempTable : TTable;
                        FieldName : String;
                        ComparisonValues : TStringList;
                        Comparison : Integer) : Boolean;

{Does the record of this particular table meet the given criteria.}

var
  I, FieldLength : Integer;
  iImprovementValue : LongInt;

begin
  Result := False;

    {CHG10181999-1: Allow for more than 1 entry in values.}

  If _Compare(FieldName, flImprovementValue, coEqual)
  then
    begin
      with TempTable do
        iImprovementValue := FieldByName('TotalAssessedVal').AsInteger -
                             FieldByName('LandAssessedVal').AsInteger;

      If (Comparison = coBetween)
        then
          begin
            Result := _Compare(iImprovementValue,
                               StrToInt(FormatNumberField(ComparisonValues[0])),
                               coGreaterThanOrEqual);

            Result := Result and
                      _Compare(iImprovementValue,
                               StrToInt(FormatNumberField(ComparisonValues[1])),
                               coLessThanOrEqual);

          end
        else
          For I := 0 to (ComparisonValues.Count - 1) do
            Result := Result or
                      _Compare(iImprovementValue,
                               StrToInt(FormatNumberField(ComparisonValues[I])), Comparison);
    end
  else
    try
      case TempTable.FieldByName(FieldName).DataType of
        ftString :
          begin
            (*FieldLength := TempTable.FieldByName(FieldName).Size; *)

            If (Comparison = coBetween)
              then
                begin
                  Result := _Compare(TempTable.FieldByName(FieldName).Text,
                                     ComparisonValues[0], coGreaterThanOrEqual);

                  Result := Result and
                            _Compare(TempTable.FieldByName(FieldName).Text,
                                     ComparisonValues[1], coLessThanOrEqual);

                end
              else
                begin
                    {FXX11031999-2: Was not working for blank compares
                                    since there were no entries in the Comparison values
                                    list.}

                  If ((ComparisonValues.Count = 0) and
                      (Comparison in [coBlank, coNotBlank]))
                    then ComparisonValues.Add('');

                  For I := 0 to (ComparisonValues.Count - 1) do
                    Result := Result or
                              _Compare(TempTable.FieldByName(FieldName).Text,
                                       ComparisonValues[I], Comparison)

                end;  {else of If (Comparison = caBetween)}

          end;  {ftString}

          {FXX01292000-2: Strip and $ or , from numeric fields.}

        ftSmallInt,
        ftInteger,
        ftWord :
          If (Comparison = coBetween)
            then
              begin
                Result := _Compare(TempTable.FieldByName(FieldName).AsInteger,
                                   StrToInt(FormatNumberField(ComparisonValues[0])),
                                   coGreaterThanOrEqual);

                Result := Result and
                          _Compare(TempTable.FieldByName(FieldName).AsInteger,
                                   StrToInt(FormatNumberField(ComparisonValues[1])),
                                   coLessThanOrEqual);

              end
            else
              For I := 0 to (ComparisonValues.Count - 1) do
                Result := Result or
                          _Compare(TempTable.FieldByName(FieldName).AsInteger,
                                   StrToInt(FormatNumberField(ComparisonValues[I])), Comparison);

        ftFloat,
        ftCurrency :
          If (Comparison = coBetween)
            then
              begin
                Result := _Compare(TempTable.FieldByName(FieldName).AsFloat,
                                   StrToFloat(FormatNumberField(ComparisonValues[0])),
                                   coGreaterThanOrEqual);

                Result := Result and
                          _Compare(TempTable.FieldByName(FieldName).AsFloat,
                                   StrToFloat(FormatNumberField(ComparisonValues[1])),
                                   coLessThanOrEqual);

              end
            else
              For I := 0 to (ComparisonValues.Count - 1) do
                Result := Result or
                          _Compare(TempTable.FieldByName(FieldName).AsFloat,
                                   StrToFloat(FormatNumberField(ComparisonValues[I])), Comparison);

        ftBoolean :
            Result := _Compare(TempTable.FieldByName(FieldName).AsBoolean,
                               ComparisonValues[0], Comparison);

          {FXX12221997-5: Forgot to include data type ftDate.}

        ftDate,
        ftDateTime,
        ftTime :
          If (Comparison = coBetween)
            then
              begin
                Result := _Compare(TempTable.FieldByName(FieldName).AsDateTime,
                                   StrToDateTime(ComparisonValues[0]), coGreaterThanOrEqual);

                Result := Result and
                          _Compare(TempTable.FieldByName(FieldName).AsDateTime,
                                   StrToDateTime(ComparisonValues[1]), coLessThanOrEqual);

              end
            else
              For I := 0 to (ComparisonValues.Count - 1) do
                Result := Result or
                          _Compare(TempTable.FieldByName(FieldName).AsDateTime,
                                   StrToDateTime(ComparisonValues[I]), Comparison);

          {FXX06101999-2: Allow users to search on memos.}

        ftMemo :
          begin
  (*          FieldLength := TempTable.FieldByName(FieldName).Size;

              {Restrict to 255 chars for now.}

            If (FieldLength > 255)
              then FieldLength := 255; *)

              {FXX04012002-1: Not working in dBase to do above, so we will
                              just treat it as a text string (i.e. only search
                              255 chars.).}

            FieldLength := 255;

              {FXX12201999-3: Was not working for blank compares
                              since there were no entries in the Comparison values
                              list.}

            If ((ComparisonValues.Count = 0) and
                (Comparison in [coBlank, coNotBlank]))
              then ComparisonValues.Add('');

            For I := 0 to (ComparisonValues.Count - 1) do
              Result := Result or
                        _Compare(Take(FieldLength, TempTable.FieldByName(FieldName).AsString),
                                 Take(FieldLength, ComparisonValues[I]),
                                 Comparison)

          end;  {ftMemo}

      end;  {case TempTable.FieldByName(FieldName).DataType of}
    except
      Result := False;
    end;

end;  {OneCriteriaMet}

{============================================================================}
Function OneSpecialCriteriaMet(AssessmentYear : String;
                               Table,
                               SwisCodeTable : TTable;
                               SwisSBLKey : String;
                               FieldName : String) : Boolean;

{CHG04302001-1: Add special criteria area.}

begin
  Result := False;

  If (FieldName = MailingAndLegalAddressEqualLabel)
    then Result := MailingAndLegalAddressEqual(Table, SwisCodeTable);

  If (FieldName = MailingAndLegalAddressNotEqualLabel)
    then Result := not MailingAndLegalAddressEqual(Table, SwisCodeTable);

    {CHG04102003-2(2.06r): Create a special section for specialized searches.}

  If (FieldName = DoesNotHavePictures)
    then
      begin
        FindNearestOld(PASDataModule.PictureTable,
                       ['SwisSBLKey', 'PictureNumber'],
                       [SwisSBLKey, '0']);

        Result := _Compare(PASDataModule.PictureTable.FieldByName('SwisSBLKey').Text, SwisSBLKey, coNotEqual);

      end;  {If (FieldName = DoesNotHavePictures)}

  If (FieldName = DoesNotHaveDocuments)
    then
      begin
        FindNearestOld(PASDataModule.DocumentTable,
                       ['SwisSBLKey', 'DocumentNumber'],
                       [SwisSBLKey, '0']);

        Result := _Compare(PASDataModule.DocumentTable.FieldByName('SwisSBLKey').Text, SwisSBLKey, coNotEqual);

      end;  {If (FieldName = DoesNotHaveDocuments)}

      {CHG11072013(MPT): Add special properties "DoesNotHave(Sketch/PropertyCard)}

  If (FieldName = DoesNotHaveSketch)
    then
      begin
        FindNearestOld(PASDataModule.SketchTable,
                       ['SwisSBLKey', 'SketchNumber'],
                       [SwisSBLKey, '0']);

        Result := _Compare(PASDataModule.SketchTable.FieldByName('SwisSBLKey').Text, SwisSBLKey, coNotEqual);

      end;  {If (FieldName = DoesNotHaveSketch)}

  If (FieldName = DoesNotHavePropertyCard)
    then
      begin
        FindNearestOld(PASDataModule.PropertyCardTable,
                       ['SwisSBLKey', 'DocumentNumber'],
                       [SwisSBLKey, '0']);

        Result := _Compare(PASDataModule.PropertyCardTable.FieldByName('SwisSBLKey').Text, SwisSBLKey, coNotEqual);

      end;  {If (FieldName = DoesNotHaveDocuments)}

end;  {OneSpecialCriteriaMet}

{============================================================================}
Function ParcelMeetsActiveStatusCriteria(ParcelTable : TTable;
                                         ActiveStatus : Integer) : Boolean;

begin
  Result := ((ActiveStatus = asEither) or
             ((ParcelTable.FieldByName('ActiveFlag').Text = InactiveParcelFlag) and
              (ActiveStatus = asInactive)) or
             ((ParcelTable.FieldByName('ActiveFlag').Text <> InactiveParcelFlag) and
              (ActiveStatus = asActive)));

end;  {ParcelMeetsActiveStatusCriteria}

{============================================================================}
Procedure ClearBookmarks(BookmarkList : TList;
                         TempTable : TTable);

{FXX04242000-2: Make sure to clear the bookmarks if have one criteria
                successful, but not another.}

var
  I, J : Integer;

begin
  For J := 0 to (BookmarkList.Count - 1) do
    begin
      For I := (TList(BookmarkList[J]).Count - 1) downto 0 do
        TempTable.FreeBookmark(TBookmark(TList(BookmarkList[J])[I]));

        {Make sure to remove any pointers that were just freed.}

      TList(BookmarkList[J]).Clear;
      TList(BookmarkList[J]).Pack;

    end;  {For J := 0 to (BookmarkList.Count - 1) do}

end;  {ClearBookmarks}

{============================================================================}
Function TSearchReportForm.ParcelMeetsCriteria : Boolean;

{For each criteria that they specified, get the record(s) for this parcel and
 look in the appropriate table at the field they choose to see if it matches.
 If it matches, then we will return the value of each field in the criteria
 list.}

const
  _and = 0;
  _or = 1;

var
  OrigCriteriaIndex,
  OrigSearchTableNumber,
  ComparisonType, CriteriaIndex,
  I, J, K, Index, FieldTableIndex, CombinationType : Integer;
  Value, FieldName, TempStr : String;
  SwisSBLKey : String;
  TempTable : TTable;
  CriteriaMetForThisRecord,
  CriteriaMetForAtLeastOneRecord,
  CriteriaMet, TestCriteria,
  Done, Found, FirstTimeThrough, GoodRecordFound : Boolean;
  TempPtr : Pointer;
  Bookmark : TBookmark;

begin
  SwisSBLKey := ExtractSSKey(ParcelTable);
  CombinationType := CombinationRadioGroup.ItemIndex;
  Found := False;
  Result := False;
  TempTable := nil;

    {If there is no criteria which is possible if they just select an exemption
     code, return true.}
    {FXX07022008-1(2.13.1.21)[D1297]: The SBL range was not working if there was no criteria.
                                      The following statement has to be first.}

  If (CriteriaList.Count = 0)
    then Result := True;

     {CHG04202001-1: Let them enter a parcel ID range.}
     {FXX08132007-4(2.11.3.1)[I1030]: The parcel range was not being checked if there was no criteria.}

  If PrintAllParcelIDs
    then Result := True
    else
      begin
        Result := False;

        If ((SwisSBLKey >= StartSwisSBLKey) and
            (PrintToEndOfParcelIDs or
             (SwisSBLKey <= EndSwisSBLKey)))
          then Result := True;

      end;  {If not PrintAllParcelIDs}

    {FXX12281999-3: Make sure to apply all criteria to same rec. if have multiple recs.}

  If Result
    then
      begin
          {FXX06262001-1: The value of Result depending on the combination type
                          needs to be set here.}
          {CHG10191997-1: Allow the user to choose if the lines will be combined
                          by "and" or "or". Note that if it is "and", we want to
                          start with true since if all the criteria are true, if
                          we anded with False, we would get False.}

        If (CombinationType = _and)
          then Result := True
          else Result := False;

        CriteriaIndex := 0;

          {Sort the criteria list by table.}

        For I := 0 to (CriteriaList.Count - 1) do
          For J := (I + 1) to (CriteriaList.Count - 1) do
            If (CriteriaPtr(CriteriaList[J])^.TableName < CriteriaPtr(CriteriaList[I])^.TableName)
              then
                begin
                  TempPtr := CriteriaList[J];
                  CriteriaList[J] := CriteriaList[I];
                  CriteriaList[I] := TempPtr;

                    {Also switch around the values lists.}

                  TempPtr := ValuesList[J];
                  ValuesList[J] := ValuesList[I];
                  ValuesList[I] := TempPtr;

                    {Switch the criteria display cells, too.}

                  with SelectionGrid do
                    For K := 0 to (ColCount - 1) do
                      begin
                        TempStr := Cells[K, (J + 1)];
                        Cells[K, (J + 1)] := Cells[K, (I + 1)];
                        Cells[K, (I + 1)] := TempStr;
                      end;

                end;  {If (CriteriaPtr(CriteriaList[J])^.TableName < ...}

          {CHG12091999-1: Allow users to select school and active status.}
          {FXX04302001-1: Also need to check swis code in case they selected
                          an individual swis but are not printing in swis order.}

        If ((SelectedSchoolCodes.IndexOf(ParcelTable.FieldByName('SchoolCode').Text) = -1) or
            (SelectedSwisCodes.IndexOf(ParcelTable.FieldByName('SwisCode').Text) = -1) or
            (not ParcelMeetsActiveStatusCriteria(ParcelTable, ActiveStatus)))
          then Result := False
          else
            begin
              while (CriteriaIndex < CriteriaList.Count) do
                with CriteriaPtr(CriteriaList[CriteriaIndex])^ do
                  begin
                      {First figure out which table we are going to use
                       for this comparison. If this is a comparison on a parcel
                       field, we will just use the existing parcel table. Otherwise,
                       we will use one of the search tables.}

                    If (SearchTableNumber = -1)
                      then
                        begin
                            {CHG04302001-1: Add special criteria area.}

                          If (RTrim(ScreenName) = SpecialScreenName)
                            then CriteriaMet := OneSpecialCriteriaMet(AssessmentYear,
                                                                      ParcelTable,
                                                                      SwisCodeTable,
                                                                      SwisSBLKey,
                                                                      RTrim(FieldName))
                            else CriteriaMet := OneCriteriaMet(ParcelTable, RTrim(FieldName),
                                                               ValuesList[CriteriaIndex], ComparisonType);

                          If (CombinationType = _and)
                            then Result := Result and CriteriaMet
                            else Result := Result or CriteriaMet;

                          CriteriaIndex := CriteriaIndex + 1;

                        end
                      else
                        begin
                            {We will use the table pointed to in the search list.}

                          TempTable := TTable(SearchTableList[SearchTableNumber]);

                            {Now set a range for this swis\sbl code since
                             there may be more than one record of this
                             type and we want to look through all of them
                             for this value. For example if they want
                             to find parcels with SD code 'FD001', we have to
                             search all SD code records for this parcel.}

                          Done := False;
                          FirstTimeThrough := True;
                          CriteriaMetForAtLeastOneRecord := False;
                          Value := '';

                            {FXX10191997-1: If this is the sales table, set key only on
                                            the swis sbl key.}
                            {FXX02012000-2: Allow them to search on the notes table, too.}

                              {FXX04032002-1: Need to account for other tables
                                              that do not have the tax roll year in
                                              their key.}

                            {CHG03042004-1(2.07l2): Add support for grievance search.}

                          If TableIsYearBasedTable(TableName)
                            then SetRangeOld(TempTable,
                                             ['TaxRollYr', 'SwisSBLKey'],
                                             [AssessmentYear, SwisSBLKey],
                                             [AssessmentYear, SwisSBLKey])
                            else SetRangeOld(TempTable, ['SwisSBLKey'], [SwisSBLKey], [SwisSBLKey]);

                          OrigSearchTableNumber := CriteriaPtr(CriteriaList[CriteriaIndex])^.SearchTableNumber;

                             {CHG02242001-1: Allow them to select how to extract multiple record types.}

                          If (RecordsToPrintOrExtract = rtLastRecordOnly)
                            then TempTable.Last
                            else TempTable.First;

                          GoodRecordFound := False;

                          repeat
                            If FirstTimeThrough
                              then FirstTimeThrough := False
                              else
                                If (RecordsToPrintOrExtract = rtLastRecordOnly)
                                  then TempTable.Prior
                                  else TempTable.Next;

                            case RecordsToPrintOrExtract of
                              rtLastRecordOnly :
                                If (TempTable.BOF or
                                    GoodRecordFound)
                                  then Done := True;

                              rtFirstRecordOnly:
                                If (TempTable.EOF or
                                    GoodRecordFound)
                                  then Done := True;

                              rtAll :
                                If TempTable.EOF
                                  then Done := True;

                            end;  {case RecordToPrintOrExtract of}

                            If not Done
                              then
                                begin
                                  TestCriteria := True;
                                  CriteriaMetForThisRecord := False;

                                    {CHG11091999-1: Allow select of exemptions and special districts.}
                                    {FXX11191999-1: This logic not working when all exemptions or SDs were selected.}

                                  If ((not PrintAllExemptions) and
                                      (Pos('ExemptionRec', TempTable.TableName) > 0) and
                                      (SelectedExemptionCodes.IndexOf(TempTable.FieldByName('ExemptionCode').Text) = -1))
                                    then TestCriteria := False;

                                  If ((not PrintAllSpecialDistricts) and
                                      (Pos('SpclDistRec', TempTable.TableName) > 0) and
                                      (SelectedSpecialDistricts.IndexOf(TempTable.FieldByName('SDistCode').Text) = -1))
                                    then TestCriteria := False;

                                    {FXX11161999-2: Do not set Found to false if not TestCritera
                                                    initialize to False outside the loop.}
                                    {FXX12281999-3: Make sure to apply all criteria to same rec. if have multiple recs.}

                                  If TestCriteria
                                    then
                                      begin
                                        If (CombinationType = _and)
                                          then CriteriaMetForThisRecord := True
                                          else CriteriaMetForThisRecord := False;

                                        OrigCriteriaIndex := CriteriaIndex;

                                        while ((CriteriaIndex < CriteriaList.Count) and
                                               (CriteriaPtr(CriteriaList[CriteriaIndex])^.SearchTableNumber =
                                                OrigSearchTableNumber)) do
                                          begin
                                            with CriteriaPtr(CriteriaList[CriteriaIndex])^ do
                                              If OneCriteriaMet(TempTable, RTrim(FieldName),
                                                                ValuesList[CriteriaIndex], ComparisonType)
                                                then
                                                  begin
                                                    If _Compare(FieldName, flImprovementValue, coEqual)
                                                    then Value := FormatFloat(IntegerDisplay,
                                                                              (TempTable.FieldByName('TotalAssessedVal').AsInteger -
                                                                               TempTable.FieldByName('LandAssessedVal').AsInteger))
                                                    else Value := TempTable.FieldByName(FieldName).Text;

                                                    If (CombinationType = _and)
                                                      then CriteriaMetForThisRecord := CriteriaMetForThisRecord and True
                                                      else CriteriaMetForThisRecord := True;

                                                  end  {If OneCriteriaMet}
                                                else
                                                  If (CombinationType = _and)
                                                    then CriteriaMetForThisRecord := False;

                                            CriteriaIndex := CriteriaIndex + 1;

                                          end;  {while ((CriteriaIndex < CriteriaList.Count) and ...}

                                          {FXX03052000-1: Only display fields from records
                                                          that actually met the criteria.}

                                        If CriteriaMetForThisRecord
                                          then
                                            begin
                                              CriteriaMetForAtLeastOneRecord := True;

                                                {First see if this criteria table is also
                                                 in the print list.}

                                              FieldTableIndex := -1;

                                              For I := 0 to (FieldsToPrintTableList.Count - 1) do
                                                If (TTable(FieldsToPrintTableList[I]).TableName = TempTable.TableName)
                                                  then FieldTableIndex := I;

                                              If (FieldTableIndex > -1)
                                                then
                                                  begin
                                                    Bookmark := TempTable.GetBookmark;
                                                    TList(BookmarkList[FieldTableIndex]).Add(Bookmark);
                                                  end;

                                            end;  {If CriteriaMetForThisRecord}

                                        CriteriaIndex := OrigCriteriaIndex;

                                      end;  {If TestCriteria}

                                end;  {If not Done}

                          until Done;

                            {All criteria for the last search table has been tested, so move to the
                             criteria for the next search table.}

                          while ((CriteriaIndex < CriteriaList.Count) and
                                 (CriteriaPtr(CriteriaList[CriteriaIndex])^.SearchTableNumber = OrigSearchTableNumber)) do
                            CriteriaIndex := CriteriaIndex + 1;

                          If (CombinationType = _and)
                            then Result := Result and CriteriaMetForAtLeastOneRecord
                            else Result := Result or CriteriaMetForAtLeastOneRecord;

                          If Result
                            then GoodRecordFound := True;

                        end;  {If (SearchTableNumber = -1)}

                  end;  {with CriteriaPtr(CriteriaList)^ do}

               {FXX04242000-2: Make sure to clear the bookmarks if have one criteria
                               successful, but not another.}
               {FXX03132001-1: Don't clear the bookmarks if the parcel
                               didn't even meet active or school criteria
                               since the temp table was never set.}

              If not Result
                then ClearBookmarks(BookmarkList, TempTable);

            end;  {else of If ((SelectedSchoolCodes. ...}

      end;  {If Result}

end;  {ParcelMeetsCriteria}

{============================================================================}
Function TSearchReportForm.ParcelMeetsEX_SD_Criteria(SwisSBLKey : String) : Boolean;

var
  HasSenior, MeetsEXCriteria, MeetsSDCriteria : Boolean;
  TempSelectedExemptionCodes : TStringList;

{CHG11091999-1: Allow select of exemptions and special districts.}

begin
    {FXX11101999-1: Add more refinement to the choice of STARs.}

  If PrintAllExemptions
    then MeetsEXCriteria := True
    else
      begin
        MeetsEXCriteria := FindValueInRange(AssessmentYear,
                                            SwisSBLKey, ParcelExemptionTable,
                                            'ExemptionCode', SelectedExemptionCodes,
                                            False);

        If (MeetsEXCriteria and
            (SelectedExemptionCodes.Count = 1) and
            (SelectedExemptionCodes[0] = '41834') and
            (EnhancedSTARType <> enAnySeniorSTAR))  {If they don't care, then don't need to do this.}
          then
            begin
              TempSelectedExemptionCodes := TStringList.Create;
              TempSelectedExemptionCodes.Add('4180');

              HasSenior := FindValueInRange(AssessmentYear,
                                            SwisSBLKey, ParcelExemptionTable,
                                            'ExemptionCode',
                                            TempSelectedExemptionCodes,
                                            True);

              TempSelectedExemptionCodes.Free;

              If ((EnhancedSTARType = enSeniorSTAROnly) and
                  HasSenior)
                then MeetsEXCriteria := False;

              If ((EnhancedSTARType = enWithSeniorandSTARExemption) and
                  (not HasSenior))
                then MeetsEXCriteria := False;

            end;  {If ((SelectedExemptionCodes.Count = 1) and ...}

          {CHG01212004-1(2.08): Add ability to select IVP enrollment status as a choice.}

        If (MeetsEXCriteria and
            (SelectedExemptionCodes.Count = 1) and
            (SelectedExemptionCodes[0] = '41834') and
            (IVPEnrollmentStatusType <> ivpIgnoreEnrollmentStatus))
          then
            begin
              ParcelExemptionTable.IndexName := 'BYYEAR_SWISSBLKEY_EXCODE';

              If FindKeyOld(ParcelExemptionTable, ['TaxRollYr', 'SwisSBLKey', 'ExemptionCode'],
                            [AssessmentYear, SwisSBLKey, EnhancedSTARExemptionCode])
                then
                  case IVPEnrollmentStatusType of
                    ivpEnrolledOnly : MeetsEXCriteria := ParcelExemptionTable.FieldByName('AutoRenew').AsBoolean;
                    ivpNotEnrolledOnly : MeetsEXCriteria := (not ParcelExemptionTable.FieldByName('AutoRenew').AsBoolean);
                  end;  {case IVPEnrollmentStatusType of}

              ParcelExemptionTable.IndexName := 'BYTAXROLLYR_SWISSBLKEY';

            end;  {If (MeetsEXCriteria and...}

      end;  {else of If PrintAllExemptions}

  If PrintAllSpecialDistricts
    then MeetsSDCriteria := True
    else MeetsSDCriteria := FindValueInRange(AssessmentYear,
                                             SwisSBLKey, ParcelSDTable,
                                             'SDistCode', SelectedSpecialDistricts,
                                             False);

  Result := MeetsEXCriteria and MeetsSDCriteria;

end;  {ParcelMeetsEX_SD_Criteria}

{======================================================================}
Function FormatField(TempVal : String;
                     FieldType : TFieldType) : String;

{FXX12202001-1: Need try..except around the conversion to avoid
                floating point errors.}

begin
  case FieldType of
      {FXX11181997-3: Not setting the result for dates and times.}

    ftMemo,
    ftString,
    ftDate,
    ftTime,
    ftDateTime : try
                   Result := TempVal;
                 except
                   Result := '0';
                 end;

    ftInteger,
    ftWord,
    ftSmallInt : try
                   Result := TempVal;
                 except
                   Result := '0';
                 end;

    ftFloat : try
                Result := FormatFloat(DecimalDisplay, StrToFloat(TempVal));
              except
                Result := '0';
              end;

      {FXX12011998-8: For now, don't print $ sign until can distinguish btw
                      dollar and non-dollar amounts.}
      {FXX12111998-1: Show decimal points too, as per above.}

    ftCurrency :  try
                    Result := FormatFloat(DecimalDisplay, StrToFloat(TempVal));
                  except
                    Result := '0';
                  end;

      {CHG11181997-3: Print Boolean as 'X' or blank.}

    ftBoolean : If (TempVal = 'True')
                  then Result := 'X'
                  else Result := '';

  end;  {case FieldType of}

end;  {FormatField}

{=====================================================================}
Procedure TSearchReportForm.WriteFieldToExtractFile(    FieldValue : String;
                                                    var ExtractFile : TextFile;
                                                        ExtractFileType : Integer;
                                                        FieldWidth : Real;
                                                        FirstFieldOnLine : Boolean;
                                                        Justification,
                                                        _ScreenName,
                                                        _FieldName : String;
                                                        ExtractFileList,
                                                        ExtractFieldList : TList);

{CHG10081998-1: Add extract file capabilities.}

var
  ColWidth : Integer;
  ExtractFileListPtr : ExtractFileListPointer;

begin
  FieldValue := StripChar(FieldValue, '$', ' ', False);

    {FXX10192009-1(2.20.1.21)[I6593]: Make sure that any rich text is written out to Excel in plain text.}

  If StringContainsRichText(FieldValue)
    then FieldValue := ConvertRichTextStringToString(FieldValue, Self);

    {FXX02122002-1: Don't strip commas.}

(*  FieldValue := StripChar(FieldValue, ',', ' ', False); *)

  If (ExtractFileType = tfCommaDelimited)
    then
      begin
(*        If not FirstFieldOnLine
          then Write(ExtractFile, ',');

        Write(ExtractFile, '"' + FieldValue + '"');*)

      end;  {If (ExtractFileType = tfCommaDelimited)}

  If (ExtractFileType = tfColumnar)
    then
      begin
//        ColWidth := Round(FieldWidth * 10);
        ColWidth := 30;

        FieldValue := Take(ColWidth, FieldValue);

        If (Justification = 'pjRight')
          then FieldValue := ShiftRightAddBlanks(FieldValue);

(*        Write(ExtractFile, FieldValue); *)

      end;  {If (ExtractFileType = tfColumnar)}

    {CHG11062001-2: Allow columns from a screen to be padded.}

  New(ExtractFileListPtr);

  with ExtractFileListPtr^ do
    begin
      OutputStr := FieldValue;
      ScreenName := _ScreenName;
      FieldName := _FieldName;
    end;

  ExtractFileList.Add(ExtractFileListPtr);

end;  {WriteFieldToExtractFile}

{======================================================================}
Procedure TSearchReportForm.PrintOneFieldValue(Sender : TObject;  {ReportPrinter}
                                               FieldsToPrintList : TList;
                                               Index,
                                               ColumnWidthPos : Integer;
                                               SwisSBLKey : String;
                                               ExtractFileList,
                                               ExtractFieldList : TList);

{Print one field value is only for tables that do not have more than one
 record for a parcel, i.e. class, assessment and parcel.}
var
  TempTable : TTable;
  _ScreenName, _FieldName, TempVal : String;
  FieldType : TFieldType;
  Found : Boolean;

begin
  FieldType := ftString;

  with Sender as TBaseReport do
    begin
      with FieldsToPrintPtr(FieldsToPrintList[Index])^ do
        begin
          _ScreenName := ScreenName;
          _FieldName := FieldName;

          If (SearchTableNumber = -1)
            then
              begin
                  {Use the parcel table.}

                try
                  If (ParcelTable.FindField(FieldName) <> nil)
                    then TempVal := ParcelTable.FieldByName(FieldName).Text;
                except
                  TempVal := '';
                end;

                  {CHG05082000-1: Format old SBL.}

                If (GlblLocateByOldParcelID and
                    (FieldName = 'RemapOldSBL'))
                  then
                    begin
                      TempVal := ParcelTable.FieldByName('RemapOldSBL').AsString;

                      If _Compare(Length(TempVal), 26, coEqual)
                        then TempVal := ConvertSwisSBLToOldDashDotNoSwis(TempVal,
                                                                         AssessmentYearControlTable);

                      FieldType := ParcelTable.FieldByName(FieldName).DataType;
                    end
                  else FieldType := ftString;

                  {CHG02222001-1: Print the 26 char parcel ID.}

                If (FieldName = 'SwisSBLKey')
                  then TempVal := ExtractSSKey(ParcelTable);

                  {FXX07232007(2.11.2.7)[D942]: The SBL Only field was not printing.  There was an extra space.
                                                I changed it to allow for both with and without a space.}

                If (_Compare(FieldName, 'SBLOnly', coEqual) or
                    _Compare(FieldName, 'SBL Only', coEqual))
                  then TempVal := Copy(ExtractSSKey(ParcelTable), 7, 20);

              end
            else
              begin
                TempTable := TTable(FieldsToPrintTableList[SearchTableNumber]);

                  {FXX04191999-1: For sales file, do not look up
                                  with assessment year as first part of
                                  the key.}

                If (Pos('sales', TempTable.TableName) > 0)
                  then
                    begin
                      FindNearestOld(TempTable, ['SwisSBLKey'], [SwisSBLKey]);

                      Found := (Take(26, TempTable.FieldByName('SwisSBLKey').Text) =
                                Take(26, SwisSBLKey));
                    end
                  else
                    begin
                      FindNearestOld(TempTable, ['TaxRollYr', 'SwisSBLKey'],
                                     [AssessmentYear, SwisSBLKey]);

                      Found := ((TempTable.FieldByName('TaxRollYr').Text =
                                 AssessmentYear) and
                                (Take(26, TempTable.FieldByName('SwisSBLKey').Text) =
                                 Take(26, SwisSBLKey)));

                    end;  {else of If (Pos('sales', TempTable.TableName) > 0)}

                If Found
                  then
                    begin
                      try
                        FieldType := TempTable.FieldByName(FieldName).DataType;
                      except
                        FieldType := ftInteger;
                      end;

                        {FXX04012002-2: For memo fields, cast AsString, otherwise
                                        get '(MEMO)'}

                      with TempTable do
                        If (FieldType = ftMemo)
                        then TempVal := FieldByName(FieldName).AsString
                        else
                          If _Compare(FieldName, flImprovementValue, coEqual)
                          then TempVal := FormatFloat(IntegerDisplay,
                                                      (FieldByName('TotalAssessedVal').AsInteger - FieldByName('LandAssessedVal').AsInteger))
                          else TempVal := FieldByName(FieldName).Text;

                    end
                  else TempVal := 'N/A';

              end;  {If (SearchTableNumber = -1)}

        end;  {with FieldsToPrintPtr(FieldsToPrintList[Index])^ do}

        {Format this field.}

      If (TempVal <> 'N/A')
        then TempVal := FormatField(TempVal, FieldType);

      If (Index >= 4)
        then Index := Index MOD 4;

        {FXX10192009-1(2.20.1.21)[I6593]: Make sure that any rich text is written out to Excel in plain text.}

      If StringContainsRichText(TempVal)
        then TempVal := ConvertRichTextStringToString(TempVal, Self);

      Print(#9 + ClipText(TempVal, Canvas, StrToFloat(FieldWidths[Index])));

        {CHG10081998-1: Add extract file capabilities.}
        {FXX05032000-3: Need index into field width list for
                        colmnar extract - otherwise uses columns
                        as appear on report, but these wrap.}

        {CHG07062003-1(2.07f): Automatically add fields needed for MS word merge letter.
                               Also allow for a salutation different than Name 1 and Name 2.}

      If ((_FieldName = 'Name 1') and
          (Salutation <> ''))
        then TempVal := Salutation;

      If ((_FieldName = 'Name 2') and
          (Salutation <> ''))
        then TempVal := '';

      WriteFieldToExtractFile(TempVal, ExtractFile, ExtractFileType,
                              (StrToFloat(ActualFieldWidths[ColumnWidthPos]) / 10), False,
                              JustificationList[ColumnWidthPos], _ScreenName,
                              _FieldName, ExtractFileList, ExtractFieldList);

    end;  {with Sender as TBaseReport do}

end;  {PrintOneFieldValue}

{============================================================================}
Function GetPrintJustification(Justification : String;
                               TabsForHeaderTitles : Boolean) : TPrintJustify;

begin
  Result := pjLeft;
  If (Justification = 'pjLeft')
    then Result := pjLeft;

  If (Justification = 'pjCenter')
    then Result := pjCenter;

  If (Justification = 'pjRight')
    then Result := pjRight;

    {Always center justify column headers.}

  If TabsForHeaderTitles
    then Result := pjCenter;

end;  {GetPrintJustification}

{============================================================================}
Procedure TSearchReportForm.SetReportTabs(Sender : TObject;
                                          TabsForHeaderTitles : Boolean);

{Set the main tabs for the report (not individual detail).}

var
  UnderlineType : Integer;
  Justification : TPrintJustify;

begin
  If TabsForHeaderTitles
    then UnderlineType := BoxLineBottom
    else UnderlineType := BoxLineNone;

  with Sender as TBaseReport do
    begin
      ClearTabs;

      If TabsForHeaderTitles
        then Justification := pjCenter
        else Justification := pjLeft;

        {CHG02052005-1(2.8.3.4): Add the ability to alter the left margin.}

      SetTab(LeftMargin, Justification, SBLFieldWidth, 0, UnderlineType, 0);   {SBL}
      SetTab(Field1Pos, Justification, DefaultFieldWidth, 0, UnderlineType, 0);   {Name}
      SetTab(Field2Pos, Justification, DefaultFieldWidth, 0, UnderlineType, 0);   {Legal Addr}

      If (FieldsToPrintList.Count > 0)
        then SetTab(Field3Pos, GetPrintJustification(JustificationList[0], TabsForHeaderTitles),
                    StrToFloat(FieldWidths[0]), 0, UnderlineType, 0);   {Value 1\5}

      If (FieldsToPrintList.Count > 1)
        then SetTab(Field4Pos, GetPrintJustification(JustificationList[1], TabsForHeaderTitles),
                    StrToFloat(FieldWidths[1]), 0, UnderlineType, 0);   {Value 2\6}

      If (FieldsToPrintList.Count > 2)
        then SetTab(Field5Pos, GetPrintJustification(JustificationList[2], TabsForHeaderTitles),
                    StrToFloat(FieldWidths[2]), 0, UnderlineType, 0);   {Value 3\7}

      If (FieldsToPrintList.Count > 3)
        then SetTab(Field6Pos, GetPrintJustification(JustificationList[3], TabsForHeaderTitles),
                    StrToFloat(FieldWidths[3]), 0, UnderlineType, 0);   {Value 4\8}

    end;  {with Sender as TBaseReport do}

end;  {SetReportTabs}

{============================================================================}
Procedure TSearchReportForm.PrintDetails(    Sender : TObject;
                                             FieldsToPrintList,
                                             FieldsToPrintTableList : TList;
                                             SwisSBLKey : String;
                                             ExtractFileList,
                                             ExtractFieldList : TList;
                                         var Quit : Boolean);

{Print the details as indented information. Each field will have one line
 or lines with up to 5 values per line. We will store all the info in
 string lists until we are ready to print.}


var
  FieldValuesList : TList;
  I, J, BookmarkIndex, Index,
  StartIndex, EndIndex, TempSearchTableNumber : Integer;
  UseBookmarks, Done, FirstTimeThrough : Boolean;
  FieldValue : String;
  TempTable : TTable;

begin
  TempTable := nil;
  BookmarkIndex := -1;
  FieldValuesList := TList.Create;

  For I := 1 to 100 do
    FieldValuesList.Add(TStringList.Create);

    {First fill in the values.}

  For I := 0 to (FieldsToPrintList.Count - 1) do
    with FieldsToPrintPtr(FieldsToPrintList[I])^ do
      begin
        If (SearchTableNumber = -1)
          then
            begin
              try
                FieldValue := ParcelTable.FieldByName(FieldName).Text;
                FieldValue := FormatField(FieldValue, ParcelTable.FieldByName(FieldName).DataType);
              except
                FieldValue := '';
              end;

                {FXX06242002-1: Need to put SBL Only and SwisSBLKey here.}
                {CHG02222001-1: Print the 26 char parcel ID.}

              If (FieldName = 'SwisSBLKey')
                then FieldValue := ExtractSSKey(ParcelTable);

                {FXX06232010-1[I7657](2.27.1): Accomodate 'SBLOnly' and 'SBL Only' as a field name.}

              If (_Compare(FieldName, 'SBLOnly', coEqual) or
                  _Compare(FieldName, 'SBL Only', coEqual))
              then FieldValue := Copy(ExtractSSKey(ParcelTable), 7, 20);

                {CHG05082000-1: Format old SBL.}

              If (GlblLocateByOldParcelID and
                  (FieldName = 'RemapOldSBL'))
                then FieldValue := ConvertSwisSBLToOldDashDotNoSwis(ParcelTable.FieldByName(FieldName).Text,
                                                                    AssessmentYearControlTable);

              TStringList(FieldValuesList[I]).Add(FieldValue);
            end
          else
            begin
                {We will use the table pointed to in the search list.}

              TempTable := TTable(FieldsToPrintTableList[SearchTableNumber]);

              UseBookmarks := (TList(BookmarkList[SearchTableNumber]).Count > 0);

                {Now set a range for this swis\sbl code since
                 there may be more than one record of this
                 type and we want to look through all of them
                 for this value. For example if they want
                 to find parcels with SD code 'FD001', we have to
                 search all SD code records for this parcel.}

              Done := False;
              FirstTimeThrough := True;

                {FXX02042000-1: If this is the sales or notes table, don't set
                                the first part of the range on the assessment year.}

              If UseBookmarks
                then
                  begin
                    BookmarkIndex := 0;
                    TempTable.GotoBookmark(TBookmark(TList(BookmarkList[SearchTableNumber])[BookmarkIndex]));
                  end
                else
                  begin
                    If (_Compare(TempTable.TableName, SalesTableName, coEqual) or
                        _Compare(TempTable.TableName, NotesTableName, coEqual) or
                        _Compare(TempTable.TableName, PASPermitsTableName, coEqual))
                      then _SetRange(TempTable, [SwisSBLKey], [], '', [loSameEndingRange])
                      else _SetRange(TempTable, [AssessmentYear, SwisSBLKey], [], '', [loSameEndingRange]);

                    TempTable.First;

                  end;

              repeat
                If FirstTimeThrough
                  then FirstTimeThrough := False
                  else
                    If UseBookmarks
                      then
                        begin
                          BookmarkIndex := BookmarkIndex + 1;

                          If (BookmarkIndex <= (TList(BookmarkList[SearchTableNumber]).Count - 1))
                            then TempTable.GotoBookmark(TBookmark(TList(BookmarkList[SearchTableNumber])[BookmarkIndex]));
                        end
                      else TempTable.Next;

                If ((UseBookmarks and
                     (BookmarkIndex = TList(BookmarkList[SearchTableNumber]).Count)) or
                    ((not UseBookmarks) and
                     (TempTable.EOF or
                      (Take(26, SwisSBLKey) <> Take(26, TempTable.FieldByName('SwisSBLKey').Text)))))
                  then Done := True;

                If ((not Done) or
                    ((RecordsToPrintOrExtract = rtLastRecordOnly) and
                     (Deblank(TempTable.FieldByName('SwisSBLKey').Text) <> '')))
                  then
                    begin
                        {The text property of a memo field comes out as (MEMO).}

                      If (TempTable.FieldByName(FieldName).DataType = ftMemo)
                        then FieldValue := TempTable.FieldByName(FieldName).Value
                        else FieldValue := TempTable.FieldByName(FieldName).Text;
                      FieldValue := FormatField(FieldValue, TempTable.FieldByName(FieldName).DataType);
                      TStringList(FieldValuesList[I]).Add(FieldValue);

                    end;  {If not Done}

              until Done;

            end;  {If (SearchTableNumber = -1)}

      end;  {with FieldsToPrintPtr(FieldsToPrintList[I])^ do}

    {Clear all the bookmarks for this parcel for this table.}

  ClearBookmarks(BookmarkList, TempTable);

  with Sender as TBaseReport do
    begin
      ClearTabs;
      SetTab(0.7, pjLeft, 1.0, 0, BoxLineNone, 0);   {Detail hdr}
      SetTab(1.8, pjRight, 1.1, 0, BoxLineNone, 0);   {Value 1}
      SetTab(3.0, pjRight, 1.1, 0, BoxLineNone, 0);   {Value 2}
      SetTab(4.2, pjRight, 1.1, 0, BoxLineNone, 0);   {Value 3}
      SetTab(5.4, pjRight, 1.1, 0, BoxLineNone, 0);   {Value 4}
      SetTab(6.6, pjRight, 1.1, 0, BoxLineNone, 0);   {Value 5}

        {Now print the values.}

      Println('');

      For I := 0 to (FieldsToPrintList.Count - 1) do
        with FieldsToPrintPtr(FieldsToPrintList[I])^ do
          If (TStringList(FieldValuesList[I]).Count > 0)
            then
              begin
                  {CHG11251997-1: Make the detail labels bold.}

                Bold := True;
                Print(#9 + ClipText(LabelName, Canvas, 1.1));
                Bold := False;

                For J := 0 to (TStringList(FieldValuesList[I]).Count - 1) do
                  begin
                    If ((J > 0) and
                       ((J MOD 5) = 0))
                      then Println('');

                    Print(#9 + ClipText(TStringList(FieldValuesList[I])[J], Canvas, 1.0));

                  end;  {For J := 0 to (TStringList(FieldValuesList[J]).Count - 1) do}

                Println('');

              end;  {If (Count > 0)}

        {FXX03052000-1: Do all fields for this screen at the same time.}

      Index := 0;

      while (Index <= (FieldsToPrintList.Count - 1)) do
        If (FieldsToPrintPtr(FieldsToPrintList[Index])^.SearchTableNumber = -1)
          then
            begin
              WriteFieldToExtractFile(TStringList(FieldValuesList[Index])[0],
                                      ExtractFile,
                                      ExtractFileType, 1.0, False,
                                      JustificationList[Index],
                                      FieldsToPrintPtr(FieldsToPrintList[Index])^.ScreenName,
                                      FieldsToPrintPtr(FieldsToPrintList[Index])^.FieldName,
                                      ExtractFileList, ExtractFieldList);
              Index := Index + 1;
            end
          else
            begin
              TempSearchTableNumber := FieldsToPrintPtr(FieldsToPrintList[Index])^.SearchTableNumber;

              StartIndex := Index;
              EndIndex := Index;

                {Figure out how many consecutive fields have the same table.}

              while ((EndIndex < (FieldsToPrintList.Count - 1)) and
                     (TempSearchTableNumber = FieldsToPrintPtr(FieldsToPrintList[EndIndex])^.SearchTableNumber)) do
                EndIndex := EndIndex + 1;

                {If we got to a different search table, then the actual end of index is one less.}

              If (TempSearchTableNumber <> FieldsToPrintPtr(FieldsToPrintList[EndIndex])^.SearchTableNumber)
                then EndIndex := EndIndex - 1;

                {Note that since these fields are from the same table, they should
                 all have the same number of values.}

              For J := 0 to (TStringList(FieldValuesList[StartIndex]).Count - 1) do
                For I := StartIndex to EndIndex do
                  WriteFieldToExtractFile(TStringList(FieldValuesList[I])[J],
                                          ExtractFile,
                                          ExtractFileType, 1.0, False,
                                          JustificationList[I],
                                          FieldsToPrintPtr(FieldsToPrintList[I])^.ScreenName,
                                          FieldsToPrintPtr(FieldsToPrintList[I])^.FieldName,
                                          ExtractFileList, ExtractFieldList);

              Index := EndIndex + 1;

            end;  {else of while (Index <= (FieldsToPrintList.Count - 1)) do}

      Println('');

        {FXX12011998-7: Only write cr to extract file if actually doing extract file.}

      If (ExtractFileType <> tfNone)
        then WriteLineToExtractFile(ExtractFile,
                                    ExtractFileType,
                                    ExtractFileList, ExtractFieldList);

        {Reset the tabs.}

      SetReportTabs(Sender, False);

    end;  {with Sender as TBaseReport do}

  For I := 0 to 99 do
    TStringList(FieldValuesList[I]).Free;

  FieldValuesList.Free;

end;  {PrintDetails}

{============================================================================}
Procedure TSearchReportForm.UpdateTotals(    TotalsToPrintList,
                                             TotalsToPrintTableList : TList;
                                             SwisSBLKey : String;
                                         var Quit : Boolean);

{CHG12051997-2: Allow the user to choose totals.}
{Update the totals that they want to see.}

var
  I : Integer;
  Done, FirstTimeThrough : Boolean;
  FieldValue : String;
  TempTable : TTable;

begin
    {First fill in the values.}

  For I := 0 to (TotalsToPrintList.Count - 1) do
    with TotalsToPrintPtr(TotalsToPrintList[I])^ do
      begin
        If (SearchTableNumber = -1)
          then
            begin
              FieldValue := ParcelTable.FieldByName(FieldName).Text;

              try
                GrandTotal := GrandTotal + StrToFloat(FieldValue);
                Subtotal := Subtotal + StrToFloat(FieldValue);
                Values.Add(FieldValue);
              except
              end;

            end
          else
            begin
                {We will use the table pointed to in the search list.}

              TempTable := TTable(TotalsToPrintTableList[SearchTableNumber]);

                {Now set a range for this swis\sbl code since
                 there may be more than one record of this
                 type and we want to look through all of them
                 for this value. For example if they want
                 to find parcels with SD code 'FD001', we have to
                 search all SD code records for this parcel.}

              Done := False;
              FirstTimeThrough := True;

              SetRangeOld(TempTable,
                          ['TaxRollYr', 'SwisSBLKey'],
                          [AssessmentYear, SwisSBLKey],
                          [AssessmentYear, SwisSBLKey]);

              TempTable.First;

              repeat
                If FirstTimeThrough
                  then FirstTimeThrough := False
                  else TempTable.Next;

                If (TempTable.EOF or
                    (Take(26, SwisSBLKey) <> Take(26, TempTable.FieldByName('SwisSBLKey').Text)))
                  then Done := True;

                If not Done
                  then
                    begin
                      FieldValue := TempTable.FieldByName(FieldName).Text;

                      try
                        GrandTotal := GrandTotal + StrToFloat(FieldValue);
                        Subtotal := Subtotal + StrToFloat(FieldValue);
                        Values.Add(FieldValue);
                      except
                      end;

                    end;  {If not Done}

              until Done;

            end;  {If (SearchTableNumber = -1)}

      end;  {with TotalsToPrintPtr(TotalsToPrintList[I])^ do}

end;  {UpdateTotals}

{============================================================================}
Procedure PrintTotals(    Sender : TObject;
                          BreakCode : String;
                          TotalsToPrintList : TList;
                          BreakCodeType : Integer;
                          NumParcelsFound : LongInt;
                          IsGrandTotal,
                          IssuePageBreak,
                          bMeanMedian : Boolean);

{CHG12051997-2: Allow the user to choose totals.}
{Print the totals for this section or overall.}

var
  I : Integer;
  fMedian, fMean, fCOD : Double;

begin
  If (NumParcelsFound > 0)
    then
      with Sender as TBaseReport do
        begin
          If (LinesLeft < 6)
            then NewPage;

          Println('');
          Bold := True;

            {Note: subtotals are only printed for reports by swis code
                   and roll section.}

          If IsGrandTotal
            then Println(#9 + '       OVERALL TOTALS ')
            else
              begin
                Print(#9 + '       TOTALS FOR ');

                case BreakCodeType of
                  btSwisCode : Println('SWIS CODE ' + BreakCode);
                  btRollSection : Println('ROLL SECTION ' + BreakCode);
                end;

              end;  {else of If IsGrandTotal}

          Bold := False;
          ClearTabs;
          SetTab(0.3, pjLeft, 7.0, 0, BoxLineNone, 0);   {Totals lines}

          Println(#9 + 'Number of Parcels = ' + IntToStr(NumParcelsFound));

          For I := 0 to (TotalsToPrintList.Count - 1) do
            with TotalsToPrintPtr(TotalsToPrintList[I])^ do
              begin
                Print(#9 + Trim(LabelName) + ' = ');

                If IsGrandTotal
                  then
                  begin
                    Println(FormatFloat(DecimalDisplay, GrandTotal));

                    If bMeanMedian
                    then
                    begin
                      SortListAndGetStats(Values, fMedian, fMean, fCOD);
                      Print(#9 + Trim(LabelName) + ' (Mean) = ');
                      Println(FormatFloat(DecimalDisplay, fMean));
                      Print(#9 + Trim(LabelName) + ' (Median) = ');
                      Println(FormatFloat(DecimalDisplay, fMedian));
                    end;

                  end
                  else Println(FormatFloat(DecimalDisplay, SubTotal));

                  {Clear out the subtotal for the next section.}

                SubTotal := 0;

              end;  {with TotalsToPrintPtr(TotalsToPrintList[I])^ do}

          Println('-----------------------------------');
          Println('');

          If IssuePageBreak
            then NewPage;

        end;  {with Sender as TBaseReport do}

end;  {PrintTotals}

{============================================================================}
Function NumberOfForcedColumnsForScreen(ScreenName : String;
                                        NumPrintedThisScreen,
                                        NumFieldsThisScreen : Integer) : Integer;

var
  NumberOfForcedColumns : Integer;

begin
  Result := 0;
  NumberOfForcedColumns := 0;

  with NumberOfColumnsForEachFieldRec do
    begin
      If (Trim(ScreenName) = ExemptionScreenName)
        then NumberOfForcedColumns := Exemptions;

      If (Trim(ScreenName) = ComBuildingsScreenName)
        then NumberOfForcedColumns := ComBuildings;

      If (Trim(ScreenName) = ComLandsScreenName)
        then NumberOfForcedColumns := ComLands;

      If (Trim(ScreenName) = ComImprovementsScreenName)
        then NumberOfForcedColumns := ComImprovements;

      If (Trim(ScreenName) = ComIncomeExpensesScreenName)
        then NumberOfForcedColumns := ComIncomeExpenses;

      If (Trim(ScreenName) = ComRentsScreenName)
        then NumberOfForcedColumns := ComUses;

      If (Trim(ScreenName) = ComSitesScreenName)
        then NumberOfForcedColumns := ComSites;

      If (Trim(ScreenName) = ResBuildingsScreenName)
        then NumberOfForcedColumns := ResBldgs;

      If (Trim(ScreenName) = ResLandsScreenName)
        then NumberOfForcedColumns := ResLands;

      If (Trim(ScreenName) = ResImprovementsScreenName)
        then NumberOfForcedColumns := ResImprovements;

      If (Trim(ScreenName) = ResSitesScreenName)
        then NumberOfForcedColumns := ResSites;

      If (Trim(ScreenName) = SalesScreenName)
        then NumberOfForcedColumns := Sales;

      If (Trim(ScreenName) = ExemptionsDeniedScreenName)
        then NumberOfForcedColumns := ExemptionsDenied;

      If (Trim(ScreenName) = ExemptionsRemovedScreenName)
        then NumberOfForcedColumns := ExemptionsRemoved;

      If (Trim(ScreenName) = SpecialDistrictScreenName)
        then NumberOfForcedColumns := SpecialDistricts;

      If (Trim(ScreenName) = GrievanceScreenName)
        then NumberOfForcedColumns := Grievance;

      If (Trim(ScreenName) = GrievanceResultsScreenName)
        then NumberOfForcedColumns := GrievanceResults;

        {CHG06052004-1(2.07l5): Add support for grievance exemptions asked.}

      If (Trim(ScreenName) = GrievanceExemptionsAskedScreenName)
        then NumberOfForcedColumns := GrievanceResults;

      If (Trim(ScreenName) = CertiorariScreenName)
        then NumberOfForcedColumns := Certiorari;

      If (Trim(ScreenName) = CertiorariNotesScreenName)
        then NumberOfForcedColumns := CertiorariNotes;

      If (Trim(ScreenName) = CertiorariAppraisalsScreenName)
        then NumberOfForcedColumns := CertiorariAppraisals;

      If (Trim(ScreenName) = CertiorariCalendarScreenName)
        then NumberOfForcedColumns := CertiorariCalendar;

      If (Trim(ScreenName) = SmallClaimsScreenName)
        then NumberOfForcedColumns := SmallClaims;

      If (Trim(ScreenName) = SmallClaimsNotesScreenName)
        then NumberOfForcedColumns := SmallClaimsNotes;

      If (Trim(ScreenName) = SmallClaimsAppraisalsScreenName)
        then NumberOfForcedColumns := SmallClaimsAppraisals;

      If (Trim(ScreenName) = SmallClaimsCalendarScreenName)
        then NumberOfForcedColumns := SmallClaimsCalendar;

      If (Trim(ScreenName) = NoteScreenName)
        then NumberOfForcedColumns := Notes;

      If _Compare(ScreenName, PermitsScreenName, coEqual)
        then NumberOfForcedColumns := 8;

    end;  {with NumberOfColumnsForEachFieldRecord do}

  If ((NumFieldsThisScreen = 0) or
      (NumberOfForcedColumns = 0))
    then Result := 0
    else
      try
        Result := NumberOfForcedColumns -
                  (NumPrintedThisScreen DIV NumFieldsThisScreen);
      except
        Result := 0;
      end;

end;  {NumberOfForcedColumnsForScreen}

{============================================================================}
Procedure TSearchReportForm.WriteLineToExtractFile(var ExtractFile : TextFile;
                                                       ExtractFileType : Integer;
                                                       ExtractFileList,
                                                       ExtractFieldList : TList);

var
  I, J, FileListIndex : Integer;
  Found : Boolean;
  TempStr : String;

begin
  FileListIndex := 0;

  For I := 0 to (ExtractFieldList.Count - 1) do
    with ExtractFieldListPointer(ExtractFieldList[I])^ do
      begin
          {Find this screen\field in the ExtractFileList.}

        Found := False;
        TempStr := '';

        For J := FileListIndex to (ExtractFileList.Count - 1) do
          If ((not Found) and
              (Trim(FieldName) = Trim(ExtractFileListPointer(ExtractFileList[J])^.FieldName)) and
              (Trim(ScreenName) = Trim(ExtractFileListPointer(ExtractFileList[J])^.ScreenName)))
            then
              begin
                TempStr := ExtractFileListPointer(ExtractFileList[J])^.OutputStr;
                FileListIndex := FileListIndex + 1;
                Found := True;

              end;  {If ((not Found) and ...}

          {Now write the information out to a file.}

        case ExtractFileType of
          tfColumnar : Write(ExtractFile, TempStr);
          tfCommaDelimited,
          tfSpreadsheetOnly :
            begin
              If (I > 0)
                then Write(ExtractFile, ',');

                {CHG11142001-2: Allow for null blanks.}

              If ((not NullBlanks) or
                  (NullBlanks and
                   (Deblank(TempStr) <> '')))
                then Write(ExtractFile, '"', TempStr, '"');

            end;  {case ExtractFileType of}

        end;  {case ExtractFileType of}

      end;  {with ExtractFieldListPointer(ExtractFieldList[I])^ do}

  Writeln(ExtractFile, '');

  ClearTList(ExtractFileList, SizeOf(ExtractFileListRecord));

end;  {WriteLineToExtractFile}

{============================================================================}
Procedure TSearchReportForm.CreateExtractFieldList(ExtractFieldList : TList);

var
  I, J, K,
  ColumnsToPad, NumPrintedThisScreen : Integer;
  ExtractFieldListPtr : ExtractFieldListPointer;
  CurrentScreenName, FieldName : String;
  FieldsThisScreen : TStringList;

begin
  I := 0;
  NumPrintedThisScreen := 0;
  FieldsThisScreen := TStringList.Create;

  If IncludeParcelIDInExtract
    then
      begin
        New(ExtractFieldListPtr);
        ExtractFieldListPtr^.ScreenName := 'Base Information';
        ExtractFieldListPtr^.FieldName := 'Parcel ID';
        ExtractFieldList.Add(ExtractFieldListPtr);

      end;  {If IncludeParcelIDInExtract}

  If (IncludeOwnerInExtract and
      (not PrintMailingAddress))
    then
      begin
        New(ExtractFieldListPtr);
        ExtractFieldListPtr^.ScreenName := 'Base Information';
        ExtractFieldListPtr^.FieldName := 'Owner';
        ExtractFieldList.Add(ExtractFieldListPtr);

      end;  {If IncludeOwnerInExtract}

  If IncludeLegalAddrInExtract
    then
      begin
        New(ExtractFieldListPtr);
        ExtractFieldListPtr^.ScreenName := 'Base Information';
        ExtractFieldListPtr^.FieldName := 'Legal Address';
        ExtractFieldList.Add(ExtractFieldListPtr);

      end;  {If IncludeLegalAddrInExtract}

    {FXX02122002-2: Have to reserve fields for mailing address print.
                    When we show details, i.e. multiple records, the
                    mailing address goes before the extra info.}
    {FXX02252002-1: Putting out mailing addr fields whenever showing details -
                    need to do it just when printing mailing address.}

  If (ShowDetails and
      PrintMailingAddress)
    then
      For J := 1 to 6 do
        begin
          New(ExtractFieldListPtr);
          ExtractFieldListPtr^.ScreenName := 'Base Information';
          ExtractFieldListPtr^.FieldName := 'Mail Addr_' + IntToStr(J);
          ExtractFieldList.Add(ExtractFieldListPtr);

        end;  {For J := 1 to 6 do}

  If (FieldsToPrintList.Count > 0)
    then CurrentScreenName := FieldsToPrintPtr(FieldsToPrintList[I])^.ScreenName;

  while (I <= (FieldsToPrintList.Count - 1)) do
    begin
        {If this is the last field to print, be sure to load it into the list
         before padding spaces.}

      If (I = (FieldsToPrintList.Count - 1))
        then
          begin
            NumPrintedThisScreen := NumPrintedThisScreen + 1;
            FieldName := FieldsToPrintPtr(FieldsToPrintList[I])^.FieldName;
            New(ExtractFieldListPtr);

              {FXX02252002-1: Don't forget to check to see if the screen name changed on
                              the last item.}

            If (CurrentScreenName <> FieldsToPrintPtr(FieldsToPrintList[I])^.ScreenName)
              then
                begin
                  NumPrintedThisScreen := 0;
                  FieldsThisScreen.Clear;
                  CurrentScreenName := FieldsToPrintPtr(FieldsToPrintList[I])^.ScreenName;

                end;  {If (CurrentScreenName <> FieldsToPrintPtr(FieldsToPrintList[I])^.ScreenName)}

            ExtractFieldListPtr^.ScreenName := FieldsToPrintPtr(FieldsToPrintList[I])^.ScreenName;
            ExtractFieldListPtr^.FieldName := FieldName;
            ExtractFieldList.Add(ExtractFieldListPtr);

            If (FieldsThisScreen.IndexOf(FieldName) = -1)
              then FieldsThisScreen.Add(FieldName);

          end;  {If (I = (FieldsToPrintList.Count - 1))}

        {Have we switched screens or are we on the last field?}

      If ((CurrentScreenName <> FieldsToPrintPtr(FieldsToPrintList[I])^.ScreenName) or
          (I = 0) or
          (I = (FieldsToPrintList.Count - 1)))
        then
          begin
            ColumnsToPad := NumberOfForcedColumnsForScreen(CurrentScreenName,
                                                           NumPrintedThisScreen,
                                                           FieldsThisScreen.Count);

            For J := 1 to ColumnsToPad do
              For K := 1 to FieldsThisScreen.Count do
                begin
                  New(ExtractFieldListPtr);
                  ExtractFieldListPtr^.ScreenName := CurrentScreenName;
                  ExtractFieldListPtr^.FieldName := FieldsThisScreen[K - 1];
                  ExtractFieldList.Add(ExtractFieldListPtr);

                end;  {For K := 1 to FieldsThisScreen.Count do}

            CurrentScreenName := FieldsToPrintPtr(FieldsToPrintList[I])^.ScreenName;
            NumPrintedThisScreen := 0;
            FieldsThisScreen.Clear;

          end;  {If ((CurrentScreen <> FieldsToPrintPtr(FieldsToPrintList[I])^.ScreenName)}

      NumPrintedThisScreen := NumPrintedThisScreen + 1;
      CurrentScreenName := FieldsToPrintPtr(FieldsToPrintList[I])^.ScreenName;
      FieldName := FieldsToPrintPtr(FieldsToPrintList[I])^.FieldName;

      If (FieldsThisScreen.IndexOf(FieldName) = -1)
        then FieldsThisScreen.Add(FieldName);

      If (I < (FieldsToPrintList.Count - 1))
        then
          begin
            New(ExtractFieldListPtr);
            ExtractFieldListPtr^.ScreenName := CurrentScreenName;
            ExtractFieldListPtr^.FieldName := FieldName;
            ExtractFieldList.Add(ExtractFieldListPtr);

          end;  {If (I < (FieldsToPrintList.Count - 1))}

      I := I + 1;

    end;  {while (I <= (FieldsToPrintList.Count - 1)) do}

    {FXX02122002-2: Have to reserve fields for mailing address print.
                    When we don't show details, i.e. base and assessment info,
                    mailing address goes after the extra info.}
    {FXX04012002-6: This should not be done unless the mailing address
                    is being printed.}

  If ((not ShowDetails) and
      PrintMailingAddress)
    then
      For J := 1 to 6 do
        begin
          New(ExtractFieldListPtr);
          ExtractFieldListPtr^.ScreenName := 'Base Information';
          ExtractFieldListPtr^.FieldName := 'Mail Addr_' + IntToStr(J);
          ExtractFieldList.Add(ExtractFieldListPtr);

        end;  {For J := 1 to 6 do}


  FieldsThisScreen.Free;

end;  {CreateExtractFieldList}

{============================================================================}
Procedure TSearchReportForm.ReportFilerBeforePrint(Sender: TObject);

begin
  with Sender as TBaseReport do
    begin
      MarginTop := 0.5;
      MarginBottom := 0.75;

        {FXX06192001-2: The index was missing for by roll section.}
        {FXX03262002-1: Make the legal address indices by legal addr #.}
        {CHG02012004-2(2.08): Add parcel ID only sort.}

      with ParcelTable do
        case PrintOrderRadioBox.ItemIndex of
          0 : IndexName := 'BYTAXROLLYR_SWISSBLKEY';
          1 : IndexName := 'BYYEAR_NAME';
          2 : IndexName := 'BYYEAR_LEGALADDRINT_LEGALADDR';
          3 : IndexName := 'BYYEAR_LEGALADDR_LEGALADDRINT';
          4 : IndexName := 'BYYEAR_RS_SWISSBLKEY';
          5 : IndexName := 'BYTAXROLLYR_SBLKEY';

        end;  {case PrintOrderRadioGroup of}

         {Get the first record.}

      try
        ParcelTable.First;
      except
        SystemSupport(012, ParcelTable, 'Error getting first parcel record.',
                      UnitName, GlblErrorDlgBox);
      end;

    end;  {with Sender as TBaseReport do}

    {FXX12111998-3: handle selection of certain swis codes better.}

  If (PrintOrderRadioBox.ItemIndex = 0)
    then FindNearestOld(ParcelTable,
                        ['TaxRollYr', 'SwisCode', 'Section', 'Subsection',
                         'Block', 'Lot', 'Sublot', 'Suffix'],
                        [AssessmentYear, SelectedSwisCodes[0], '', '',
                         '', '', '', '']);

  LastBreakCode := '';
  NewBreakCode := '';

    {FXX11231997-4: Make sure to start off with the first record
                    each time.}

    {CHG10191997-2: Totals and breaks.}

  case PrintOrderRadioBox.ItemIndex of
    0 : BreakCodeType := btSwisCode;
    4 : BreakCodeType := btRollSection;

    else BreakCodeType := btNone;

  end;  {case PrintOrderRadioBox.ItemIndex of}

  case BreakCodeType of
    btSwisCode : LastBreakCode := ParcelTable.FieldByName('SwisCode').Text;
    btRollSection : LastBreakCode := ParcelTable.FieldByName('RollSection').Text;
  end;

  NewBreakCode := LastBreakCode;

    {CHG10201997-1: Scale the size of the fields based on
                    the number of fields to print.}

(*  If TruncateFields
    then DefaultFieldWidth := Roundoff((6.2 / (FieldsToPrintList.Count + 2)), 1)
    else DefaultFieldWidth := 2.5; *)
  FieldWidthInt := Trunc(DefaultFieldWidth * 10);

    {CHG02052005-1(2.8.3.4): Add the ability to alter the left margin.}

  Field1Pos := LeftMargin + 1.5;
  Field2Pos := Field1Pos + DefaultFieldWidth + 0.1;
  Field3Pos := Field2Pos + DefaultFieldWidth + 0.1;

  If (FieldWidths.Count > 0)
    then Field4Pos := Field3Pos + StrToFloat(FieldWidths[0]) + 0.1;

  If (FieldWidths.Count > 1)
    then Field5Pos := Field4Pos + StrToFloat(FieldWidths[1]) + 0.1;

  If (FieldWidths.Count > 2)
    then Field6Pos := Field5Pos + StrToFloat(FieldWidths[2]) + 0.1;

  If ((FieldWidths.Count = 1) and
      (Field4Pos > (8.5 - LeftMargin)))
    then FieldWidths[0] := FloatToStr(8.5 - LeftMargin - Field3Pos);

end;  {ReportFilerBeforePrint}

{===========================================================================}
Procedure TSearchReportForm.ReportFilerPrintHeader(Sender: TObject);

var
  I, Index : Integer;
  TempStr : String;

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
      SetFont('Arial',12);
      Bold := True;
      Home;
      PrintCenter('Search Results', (PageWidth / 2));
      SetFont('Times New Roman', 9);
      CRLF;

      Underline := False;
      ClearTabs;
      SetTab(0.5, pjLeft, 0.5, 0, BOXLINENONE, 0);   {Index}
      SetTab(1.1, pjLeft, 2.0, 0, BOXLINENONE, 0);   {Criteria}
      SetTab(3.3, pjLeft, 0.6, 0, BOXLINENONE, 0);   {Index}
      SetTab(4.0, pjLeft, 1.0, 0, BOXLINENONE, 0);   {Criteria}

      case ProcessingType of
        NextYear : TempStr := 'Next Year';
        ThisYear : TempStr := 'This Year';
        History : TempStr := 'History (' + AssessmentYear + ')';
      end;

      Bold := True;
      Print(#9 + 'Year: ');
      Bold := False;
      Print(#9 + TempStr);

      case ActiveStatus of
        asActive : TempStr := 'Active Parcels';
        asInactive : TempStr := 'Inactive Parcels';
        asEither : TempStr := 'Active & Inactive Parcels';
      end;

      Bold := True;
      Print(#9 + 'Status: ');
      Bold := False;
      Println(#9 + TempStr);

        {Print the FieldsToPrint information.}

      ClearTabs;
      SetTab(0.5, pjLeft, 0.5, 0, BOXLINENONE, 0);   {Desc}
      SetTab(1.1, pjLeft, 5.0, 0, BOXLINENONE, 0);   {Criteria}

      Bold := True;
      Print(#9 + 'Index:  ');
      Bold := False;

      case PrintOrderRadioBox.ItemIndex of
        0 : Print(#9 + ' Section\Block\Lot');
        1 : Print(#9 + ' Name');
        2 : Print(#9 + ' Address Number \ Name');
        3 : Print(#9 + ' Address Name \ Number');
      end;  {case PrintOrderRadioGroup of}

      Println('');

        {Print criteria}

      ClearTabs;
      SetTab(0.5, pjLeft, 0.5, 0, BOXLINENONE, 0);   {Desc}
      SetTab(1.1, pjLeft, 5.0, 0, BOXLINENONE, 0);   {Criteria}

      Bold := True;
      Print(#9 + 'Criteria:');
      Bold := False;

      with SelectionGrid do
        For I := 1 to (RowCount - 1) do
          If (Deblank(Cells[0, I]) <> '')
            then
              begin
                If (I > 1)
                  then Print(#9);

                Println(#9 + 'From screen ' + Trim(Cells[0, I]) +
                         ': ' + Trim(Cells[1, I]) + ' ' + Trim(Cells[2, I]) +
                         ' ' + Trim(Cells[3, I]));

              end;  {If (Deblank(Cells[0, I]) <> '')}

      Bold := True;

      case BreakCodeType of
        btSwisCode : Println(#9 + 'Swis Code: ' + NewBreakCode);
        btRollSection : Println(#9 + 'Roll Section: ' + NewBreakCode);
      end;

        {FXX11151999-4: Make sure to print any selected exemptions or SD codes.}

      ClearTabs;
      SetTab(0.5, pjLeft, 1.2, 0, BOXLINENONE, 0);   {Desc}
      SetTab(1.8, pjLeft, 0.5, 0, BOXLINENONE, 0);   {Code 1}
      SetTab(2.4, pjLeft, 0.5, 0, BOXLINENONE, 0);   {Code 2}
      SetTab(3.0, pjLeft, 0.5, 0, BOXLINENONE, 0);   {Code 3}
      SetTab(3.6, pjLeft, 0.5, 0, BOXLINENONE, 0);   {Code 4}
      SetTab(4.2, pjLeft, 0.5, 0, BOXLINENONE, 0);   {Code 5}
      SetTab(4.8, pjLeft, 0.5, 0, BOXLINENONE, 0);   {Code 6}
      SetTab(5.4, pjLeft, 0.5, 0, BOXLINENONE, 0);   {Code 7}
      SetTab(6.1, pjLeft, 0.5, 0, BOXLINENONE, 0);   {Code 8}
      SetTab(6.7, pjLeft, 0.5, 0, BOXLINENONE, 0);   {Code 9}
      SetTab(7.3, pjLeft, 0.5, 0, BOXLINENONE, 0);   {Code 10}

      If not PrintAllExemptions
        then
          begin
            Print(#9 + 'Exemptions: ');

            For I := 0 to (SelectedExemptionCodes.Count - 1) do
              begin
                Print(#9 + SelectedExemptionCodes[I]);

                If (((I + 1) MOD 10) = 0)
                  then
                    begin
                      Println('');
                      Print(#9);
                    end;

              end;  {For I := 0 to (SelectionsExemptionCodes.Count - 1) do}

            Println('')

          end;  {If not PrintAllExemptions}

      If not PrintAllSpecialDistricts
        then
          begin
            Print(#9 + 'Sp Dists: ');

            For I := 0 to (SelectedSpecialDistricts.Count - 1) do
              begin
                Print(#9 + SelectedSpecialDistricts[I]);

                If (((I + 1) MOD 10) = 0)
                  then
                    begin
                      Println('');
                      Print(#9);
                    end;

              end;  {For I := 0 to (SelectionedSpecialDistricts.Count - 1) do}

            Println('')

          end;  {If not PrintAllSpecialDistricts}

      If (SelectedSchoolCodes.Count <> SchoolCodeListBox.Items.Count)
        then
          begin
            ClearTabs;
            SetTab(0.5, pjLeft, 1.2, 0, BOXLINENONE, 0);   {Desc}
            SetTab(1.8, pjLeft, 0.6, 0, BOXLINENONE, 0);   {Code 1}
            SetTab(2.5, pjLeft, 0.6, 0, BOXLINENONE, 0);   {Code 2}
            SetTab(3.2, pjLeft, 0.6, 0, BOXLINENONE, 0);   {Code 3}
            SetTab(3.9, pjLeft, 0.6, 0, BOXLINENONE, 0);   {Code 4}
            SetTab(4.6, pjLeft, 0.6, 0, BOXLINENONE, 0);   {Code 5}
            SetTab(5.3, pjLeft, 0.6, 0, BOXLINENONE, 0);   {Code 6}
            SetTab(6.0, pjLeft, 0.6, 0, BOXLINENONE, 0);   {Code 7}
            SetTab(6.7, pjLeft, 0.6, 0, BOXLINENONE, 0);   {Code 8}
            SetTab(7.4, pjLeft, 0.6, 0, BOXLINENONE, 0);   {Code 9}

            Print(#9 + 'Schools: ');

            For I := 0 to (SelectedSchoolCodes.Count - 1) do
              begin
                Print(#9 + SelectedSchoolCodes[I]);

                If (((I + 1) MOD 9) = 0)
                  then
                    begin
                      Println('');
                      Print(#9);
                    end;

              end;  {For I := 0 to (SelectionsSchoolCodes.Count - 1) do}

            Println('')

          end;  {If (SelectedSchoolCodes.Count <> SchoolCodeListBox.Items.Count)}

      Bold := False;

        {Print column headers.}

      CRLF;
      SetPen(clBlack, psSolid, 1, pmCopy); { Set pen to 1 dot width }
      Bold := True;
      Underline := False;
      ClearTabs;

        {CHG10201997-1: Scale the size of the fields based on
                        the number of fields to print.}

      SetReportTabs(Sender, True);

        {If we are showing details (i.e. 2+ exemptions), then we will just
         put the parcel id, name, and addr header and the other stuff will
         be a subheader.}
        {FXX09241999: Do mailing addr differently (cont).}

      If PrintMailingAddress
        then TempStr := 'Mailing Address'
        else TempStr := 'Name';

      If ShowDetails
        then Println(#9 + 'Parcel ID' +
                     #9 + TempStr +
                     #9 + 'Legal Address')
        else
          begin
              {Otherwise, there is only one value per field, so we can string
               them across.}
              {If there are more than 4 fields to print, we will need two
               lines.}

            Index := 0;

            If (FieldsToPrintList.Count > 0)
              then
                begin
                  Print(#9 + 'Parcel ID' +
                        #9 + TempStr +
                        #9 + 'Legal Address');

                    {FXX09291999-2: Problem printing search report with on field to print.}

                  For I := 0 to 1 do
                    begin
                      If (I <= (FieldsToPrintList.Count - 1))
                        then Print(#9 + ClipText(FieldsToPrintPtr(FieldsToPrintList[Index])^.LabelName,
                                                 Canvas, StrToFloat(FieldWidths[I])));
                      Index := Index + 1;

                    end;  {For I := 0 to 3 do}

                  Println('');

                    {FXX11021999-6: Missing a tab, so 2nd line was wrong.}

                  If (FieldsToPrintList.Count > 1)
                    then Print(#9 + #9);

                end  {If (FieldsToPrint.Count > 4)}
             else
               begin
                 Print(#9 + 'Parcel ID' +
                       #9 + TempStr +
                       #9 + 'Legal Address');

                end;  {else of If (FieldsToPrint.Count > 4)}

            while (Index <= (FieldsToPrintList.Count - 1)) do
              begin
                For I := 3 to 5 do
                  If (Index <= (FieldsToPrintList.Count - 1))
                    then
                      begin
                        Print(#9 + ClipText(FieldsToPrintPtr(FieldsToPrintList[Index])^.LabelName,
                                            Canvas, StrToFloat(FieldWidths[I - 1])));
                        Index := Index + 1;

                      end;  {If (Index <= (FieldsToPrint.Count - 1))}

                Println('');

                If (Index < (FieldsToPrintList.Count - 1))
                  then Print(#9 + #9);

              end;  {while (Index <= (FieldsToPrintList.Count - 1)) do}

          end;  {else of If ShowDetails}

      Underline := False;
      Bold := False;
      Println('');

        {Set the tabs for the printing of the data.}

      SetReportTabs(Sender, False);

    end;  {with Sender as TBaseReport do}

end;  {ReportFilerPrintHeader}

{==================================================================}
Procedure TSearchReportForm.ReportFilerPrint(Sender: TObject);

var
  NewPageAfterSubtotals,
  Quit, Done, FirstTimeThrough, LastBreakTotalsPrinted : Boolean;
  SwisCodeIndex, I, Index, TempIndex, ColumnWidthPos,
  SubtotalNumMatched, TotalNumMatched, MailAddrIndex : Integer;
  SwisSBLKey : String;
  SBLRec : SBLRecord;
  TempStr, ThisCoopSwisSBLKey, LastCoopSwisSBLKey : String;
  NAddrArray : NameAddrArray;
  ExtractFileList, ExtractFieldList : TList;

begin
  Index := 1;
  LastCoopSwisSBLKey := Take(20, ExtractSSKey(ParcelTable));
  NewPageAfterSubtotals := NewPageOnBreakCheckBox.Checked;
  ExtractFileList := TList.Create;
  ExtractFieldList := TList.Create;

  CreateExtractFieldList(ExtractFieldList);

    {CHG11142001-1: Allow them to include the column headers on the first line.}

  If ((ExtractFileType in [tfCommaDelimited, tfSpreadsheetOnly]) and
      PrintHeadersOnFirstLineOfExtract)
    then
      begin
        For I := 0 to (ExtractFieldList.Count - 1) do
          with ExtractFieldListPointer(ExtractFieldList[I])^ do
            begin
              If (I > 0)
                then Write(ExtractFile, ',');

              Write(ExtractFile, '"', FieldName, '"');

          end;  {For I := 0 to (ExtractFieldList.Count - 1) do}

          Writeln(ExtractFile, '');

        end;  {If ((ExtractFileType = tfCommaDelimited) and ...}

  with Sender as TBaseReport do
    begin
      TotalNumMatched := 0;
      SubtotalNumMatched := 0;
      Quit := False;
      Done := False;
      FirstTimeThrough := True;
      SwisCodeIndex := 0;
      LastBreakTotalsPrinted := False;
      ProgressDialog.UserLabelCaption := 'Number Found = ' + IntToStr(TotalNumMatched);

        {FXX05281999-2: Add load from parcel list.}

      If LoadFromParcelList
        then
          begin
            ParcelListDialog.GetParcel(ParcelTable, Index);
            ProgressDialog.Start(ParcelListDialog.NumItems, True, True);
          end
        else ProgressDialog.Start(GetRecordCount(ParcelTable), True, True);

      repeat
        Application.ProcessMessages;

        If FirstTimeThrough
          then FirstTimeThrough := False
          else
            If LoadFromParcelList
              then
                begin
                  Index := Index + 1;
                  ParcelListDialog.GetParcel(ParcelTable, Index);
                end
              else ParcelTable.Next;

        If (ParcelTable.EOF or
            (LoadFromParcelList and
             (Index > ParcelListDialog.NumItems)))
          then Done := True;

        case BreakCodeType of
          btSwisCode : NewBreakCode := ParcelTable.FieldByName('SwisCode').Text;
          btRollSection : NewBreakCode := ParcelTable.FieldByName('RollSection').Text;
        end;

        ThisCoopSwisSBLKey := Take(20, ExtractSSKey(ParcelTable));

          {CHG04102003-1(2.06r): Allow for blank lines between coops in extracts and spreadsheets.}

        If (BlankLinesBetweenCoops and
            (LastCoopSwisSBLKey <> ThisCoopSwisSBLKey) and
            (ExtractFileType <> tfNone))
          then Writeln(ExtractFile);

        LastCoopSwisSBLKey := ThisCoopSwisSBLKey;

          {CHG11231997-2: Let the user select which swis codes they want
                          so we can skip the swis codes they don't want.}
          {FXX01282008-1(2.11.7.3): I'm not sure wtf this is supposed to do,
                                    but it messes up a load from a parcel list
                                    if there is nothing in the first swis code.
                                    So, I am getting rid of it.}

(*        If ((BreakCodeType = btSwisCode) and
            (LastBreakCode <> NewBreakCode))
          then
            If (SelectedSwisCodes.Count = (SwisCodeIndex + 1))
              then Done := True
              else
                begin
                  SwisCodeIndex := SwisCodeIndex + 1;

                    {See if they want this swis code. If not, go to the
                     first parcel of the next swis code.}

                  If (Take(6, SelectedSwisCodes[SwisCodeIndex]) <> NewBreakCode)
                    then
                      begin
                        NewBreakCode := Take(6, SelectedSwisCodes[SwisCodeIndex]);

                        FindNearestOld(ParcelTable,
                                       ['TaxRollYr', 'SwisCode', 'Section', 'Subsection',
                                        'Block', 'Lot', 'Sublot', 'Suffix'],
                                       [AssessmentYear, NewBreakCode, '', '',
                                        '', '', '', '']);

                      end;  {If (SelectedSwisCodes[SwisCodeIndex] <> NewBreakCode)}

                end;  {else of If (SelectedSwisCodes.Count = (SwisCodeIndex + 1))} *)

          {If they changed break codes, print the totals.}

        If ((LastBreakCode <> NewBreakCode) and
            (BreakCodeType <> btNone))
          then
            begin
              PrintTotals(Sender, LastBreakCode, TotalsToPrintList,
                          BreakCodeType, SubtotalNumMatched, False,
                          NewPageAfterSubtotals, bMeanMedian);
              NewBreakCode := LastBreakCode;
              SubtotalNumMatched := 0;
              LastBreakTotalsPrinted := True;

                {FXX06291998-4: Reset the report tabs after a break.}

              SetReportTabs(Sender, False);

            end;  {If (LastBreakCode <> NewBreakCode)}

        If not (Done or Quit or PrintingCancelled)
          then
            If LoadFromParcelList
              then ProgressDialog.Update(Self, ParcelListDialog.GetParcelID(Index))
              else
                with ParcelTable do
                  case PrintOrderRadioBox.ItemIndex of
                    0 : ProgressDialog.Update(Self,
                                              ConvertSwisSBLToDashDot(ExtractSSKey(ParcelTable)));
                    1 : ProgressDialog.Update(Self, FieldByName('Name1').Text);
                    2 : ProgressDialog.Update(Self,
                                              Trim(FieldByName('LegalAddrNo').Text) + ' ' +
                                              Trim(FieldByName('LegalAddr').Text));
                    3 : ProgressDialog.Update(Self,
                                              Trim(FieldByName('LegalAddr').Text) + ' ' +
                                              Trim(FieldByName('LegalAddrNo').Text));
                    4 : ProgressDialog.Update(Self,
                                              'RS ' + FieldByName('RollSection').Text + ': ' +
                                              ConvertSwisSBLToDashDot(ExtractSSKey(ParcelTable)));

                  end;  {case PrintOrderRadioGroup of}

          {If this parcel fits the criteria, then print it.}
          {CHG11091999-1: Allow select of exemptions and special districts.}

        SwisSBLKey := ExtractSSKey(ParcelTable);

        If ((not (Done or Quit or PrintingCancelled)) and
            _Compare(ParcelTable.FieldByName('TaxRollYr').AsString, AssessmentYear, coEqual) and
            ParcelMeetsEX_SD_Criteria(SwisSBLKey) and
            ParcelMeetsCriteria)
          then
            begin
                {CHG06072003-1(2.07c): Allow for label print from Search Report.}

              If (_PrintLabels and
                  (ParcelListForLabels.IndexOf(SwisSBLKey) = -1))
                then ParcelListForLabels.Add(SwisSBLKey);

              TotalNumMatched := TotalNumMatched + 1;
              SubtotalNumMatched := SubtotalNumMatched + 1;
              ProgressDialog.UserLabelCaption := 'Number Found = ' + IntToStr(TotalNumMatched);
              LastBreakTotalsPrinted := False;

                {FXX05042000-1: Uninitialized name address array caused garbage to print.}

              For I := 1 to 6 do
                NAddrArray[I] := '';

                {FXX09241999: Do mailing addr differently (cont).}

              If PrintMailingAddress
                then GetNameAddress(ParcelTable, NAddrArray);

                {CHG01251999-1: Send info to a list.}

              If CreateParcelList
                then ParcelListDialog.AddOneParcel(ExtractSSKey(ParcelTable));

                {See if we have enough room to print this entry.}

              If ShowDetails
                then
                  begin
                      {Make sure there is enough room to print the details.}

                    If ((LinesLeft - FieldsToPrintList.Count) < 3)
                      then NewPage;

                  end
                else
                  If (LinesLeft < 5)
                    then NewPage;

               {CHG10081998-1: Add extract file capabilities.}
               {FXX12151998-1: Allow print of search report in totals only mode.}

              If not TotalsOnly
                then
                  begin
                    with ParcelTable do
                       begin
                           {CHG04052000-1: Allow them to decide whether or not
                                           to print the swis.}
                           {FXX02212001-1: Not including swis on parcel ID did not work.}

                            {CHG05112001-3: Allow selection of whether or not to include
                                            parcel ID, legal addr, or owner in extract.}

                         If IncludeSwisOnParcelID
                           then TempStr := ConvertSwisSBLToDashDot(SwisSBLKey)
                           else TempStr := ConvertSwisSBLToDashDotNoSwis(SwisSBLKey);
                         Print(#9 + TempStr);
                         If IncludeParcelIDInExtract
                           then WriteFieldToExtractFile(TempStr, ExtractFile, ExtractFileType,
                                                        2.0, True, 'pjLeft',
                                                        BaseInformationScreenName, 'Parcel ID',
                                                        ExtractFileList, ExtractFieldList);

                           {FXX08021999-1: Swap name and legal addr fields.}
                           {FXX09201999-5: Swap them back.}

                         MailAddrIndex := 2;

                           {FXX09241999: Do mailing addr differently (cont).}

                         If PrintMailingAddress
                           then TempStr := NAddrArray[1]
                           else TempStr := FieldByName('Name1').Text;

                         Print(#9 + ClipText(TempStr, Canvas, DefaultFieldWidth));

                         If (IncludeOwnerInExtract and
                             (not PrintMailingAddress))
                           then WriteFieldToExtractFile(TempStr, ExtractFile, ExtractFileType,
                                                        2.4, False, 'pjLeft',
                                                        BaseInformationScreenName, 'Owner',
                                                        ExtractFileList, ExtractFieldList);

                         TempStr := GetLegalAddressFromTable(ParcelTable);
                         Print(#9 + ClipText(TempStr, Canvas, DefaultFieldWidth));
                         If IncludeLegalAddrInExtract
                           then WriteFieldToExtractFile(TempStr, ExtractFile, ExtractFileType,
                                                        2.4, False, 'pjLeft',
                                                        BaseInformationScreenName, 'Legal Address',
                                                        ExtractFileList, ExtractFieldList);

                           {FXX04182001-3: If they are printing details and mailing address,
                                           there are no more columns on this line and we
                                           need to issue a line feed.}

                         If ShowDetails
                           then Println('');

                       end;  {with ParcelTable do}

                      {Now print the info.}

                    If ShowDetails
                      then
                        begin
                          If PrintMailingAddress
                            then
                              begin
                                For I := MailAddrIndex to 6 do
                                  If (Deblank(NAddrArray[I]) <> '')
                                    then Println(#9 + #9 + NAddrArray[I]);

                                If (ExtractFileType in [tfColumnar, tfCommaDelimited,
                                                        tfSpreadsheetOnly])
                                  then
                                    For I := 1 to 6 do
                                      WriteFieldToExtractFile(NAddrArray[I], ExtractFile,
                                                              ExtractFileType, 3.0,
                                                              False, 'pjLeft',
                                                              BaseInformationScreenName,
                                                              'Mail Addr_' + IntToStr(I),
                                                              ExtractFileList, ExtractFieldList);

                              end;  {If PrintMailingAddress}

                          PrintDetails(Sender, FieldsToPrintList,
                                       FieldsToPrintTableList, SwisSBLKey,
                                       ExtractFileList, ExtractFieldList, Quit);

                        end
                      else
                        begin
                          TempIndex := 0;

                            {FXX05032000-3: Need index into field width list for
                                            colmnar extract - otherwise uses columns
                                            as appear on report, but these wrap.}

                          ColumnWidthPos := 0;

                            {FXX08181999-5: Need to update index in the first 2 fields
                                            printed on 1st line.}

                          For I := 0 to 1 do
                            If (I <= (FieldsToPrintList.Count - 1))
                              then
                                begin
                                  PrintOneFieldValue(Sender, FieldsToPrintList, I,
                                                     ColumnWidthPos, SwisSBLKey,
                                                     ExtractFileList, ExtractFieldList);
                                  TempIndex := TempIndex + 1;
                                  ColumnWidthPos := ColumnWidthPos + 1;
                                end;

                          Println('');

                           {Do we need to do a second line for more field values?}

                          If (FieldsToPrintList.Count > 0)
                            then
                              while (TempIndex <= (FieldsToPrintList.Count - 1)) do
                                begin
                                  Print(#9);

                                    {FXX03022004-1(2.07l2): If they are printing many lines of info,
                                                            make sure that the mail addr index does not
                                                            go over 6.}

                                  If (MailAddrIndex <= 6)
                                    then Print(#9 + NAddrArray[MailAddrIndex])
                                    else Print(#9);

                                  MailAddrIndex := MailAddrIndex + 1;

                                  For I := 3 to 5 do
                                    If (TempIndex <= (FieldsToPrintList.Count - 1))
                                      then
                                        begin
                                          PrintOneFieldValue(Sender, FieldsToPrintList,
                                                             TempIndex,
                                                             ColumnWidthPos, SwisSBLKey,
                                                             ExtractFileList, ExtractFieldList);
                                          TempIndex := TempIndex + 1;
                                          ColumnWidthPos := ColumnWidthPos + 1;
                                        end;

                                  Println('');

                                 (* If (TempIndex <= (FieldsToPrintList.Count - 1))
                                    then Print(#9); *)

                                end;  {while (Index <= (FieldsToPrintList.Count - 1)) do}

                            {Finish up printing the mailing addr.}

                          If PrintMailingAddress
                            then
                              begin
                                For I := MailAddrIndex to 6 do
                                  If (Deblank(NAddrArray[I]) <> '')
                                    then Println(#9 + #9 + NAddrArray[I]);

                                If (ExtractFileType in [tfColumnar, tfCommaDelimited,
                                                        tfSpreadsheetOnly])
                                  then
                                    For I := 1 to 6 do
                                      WriteFieldToExtractFile(NAddrArray[I], ExtractFile,
                                                              ExtractFileType, 3.0,
                                                              False, 'pjLeft',
                                                              BaseInformationScreenName,
                                                              'Mail Addr_' + IntToStr(I),
                                                              ExtractFileList, ExtractFieldList);

                              end;  {If PrintMailingAddress}

                            {CHG10081998-1: Add extract file capability.}

(*                          If (ExtractFileType in [tfColumnar, tfCommaDelimited])
                            then Writeln(ExtractFile, ''); *)

                          If (ExtractFileType <> tfNone)
                            then WriteLineToExtractFile(ExtractFile,
                                                        ExtractFileType,
                                                        ExtractFileList, ExtractFieldList);

                        end;  {else of If ShowDetails}

                  end;  {If not TotalsOnly}

                {CHG08021999-1: Allow them to put one blank space between parcels.}

              If SpaceBetweenParcelsCheckBox.Checked
                then Println('');

              UpdateTotals(TotalsToPrintList, TotalsToPrintTableList,
                           SwisSBLKey, Quit);

            end;  {If not (Done or Quit or PrintingCancelled)) and ...}

          {CHG11231997-2: Let the user select which swis codes they want
                          so we can skip the swis codes they don't want.}

        case BreakCodeType of
          btSwisCode : LastBreakCode := ParcelTable.FieldByName('SwisCode').Text;
          btRollSection : LastBreakCode := ParcelTable.FieldByName('RollSection').Text;
        end;

      until (Done or Quit or ProgressDialog.Cancelled);

        {Print the totals.}
        {CHG12051997-2: Allow the user to choose totals.}

      If not LastBreakTotalsPrinted
        then PrintTotals(Sender, LastBreakCode, TotalsToPrintList,
                         BreakCodeType, SubtotalNumMatched,
                         False, NewPageAfterSubtotals, bMeanMedian);

      PrintTotals(Sender, LastBreakCode, TotalsToPrintList, BreakCodeType,
                  TotalNumMatched, True, False, bMeanMedian);

    end;  {with Sender as TBaseReport do}

(*  ProgressDialog.StartPrinting(PrintDialog.PrintToFile);*)

  FreeTList(ExtractFileList, SizeOf(ExtractFileListRecord));
  FreeTList(ExtractFieldList, SizeOf(ExtractFieldListRecord));

end;  {ReportFilerPrint}


end.