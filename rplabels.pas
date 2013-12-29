unit Rplabels;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Printers, DBCtrls, DBTables, DB, Buttons, Grids,
  Wwdbigrd, Wwdbgrid, ExtCtrls, Wwtable, Wwdatsrc, Menus,pastypes,
  GlblCnst,Types, RPFiler, RPBase, RPCanvas, (*Progress,*) RPDefine,
  DBGrids, DBLookup, TabNotBk, RPTXFilr, RPrinter, ComCtrls,
  Zipcopy;

type
  TLabelsForm = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    ScrollBox1: TScrollBox;
    TitleLabel: TLabel;
    LabelPrinter: TReportPrinter;
    LabelFiler: TReportFiler;
    PrintDialog: TPrintDialog;
    ExemptionCodeTable: TTable;
    ParcelTable: TTable;
    ParcelExemptionTable: TTable;
    LetterTextDataSource: TDataSource;
    SDCodeTable: TTable;
    SwisCodeTable: TTable;
    SchoolCodeTable: TTable;
    PropertyClassTable: TTable;
    ParcelSDTable: TTable;
    SortTable: TTable;
    ReportPrinter: TReportPrinter;
    ReportFiler: TReportFiler;
    AssessmentTable: TTable;
    AlignmentPrinter: TReportPrinter;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    AssessmentYearControlTable: TTable;
    SaveExportDialog: TSaveDialog;
    ZipCopyDlg: TZipCopyDlg;
    Panel3: TPanel;
    CloseButton: TBitBtn;
    PrintButton: TBitBtn;
    SaveReportOptionsButton: TBitBtn;
    LoadButton: TBitBtn;
    PageControl: TPageControl;
    OptionsTabSheet: TTabSheet;
    PrintOrderRadioGroup: TRadioGroup;
    ReportTypeRadioGroup: TRadioGroup;
    AssessmentYearRadioGroup: TRadioGroup;
    PrintSuborderRadioGroup: TRadioGroup;
    LabelTypeRadioGroup: TRadioGroup;
    TabSheet1: TTabSheet;
    ParcelTypeRadioGroup: TRadioGroup;
    TabSheet2: TTabSheet;
    OptionsGroupBox: TGroupBox;
    Label10: TLabel;
    FontSizeLabel: TLabel;
    FontSizeAdditionalLinesLabel: TLabel;
    PrintDuplicatesCheckBox: TCheckBox;
    LaserTopMarginEdit: TEdit;
    PrintLabelsBoldCheckBox: TCheckBox;
    PrintSwisCodeOnParcelIDCheckBox: TCheckBox;
    ResidentLabelsCheckBox: TCheckBox;
    LegalAddressLabelsCheckBox: TCheckBox;
    FontSizeEdit: TEdit;
    FontSizeAdditionalLinesEdit: TEdit;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    TabSheet5: TTabSheet;
    TabSheet6: TTabSheet;
    TabSheet7: TTabSheet;
    TabSheet8: TTabSheet;
    Panel4: TPanel;
    ExemptionListBox: TListBox;
    Panel5: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    ExemptionInclusionRadioGroup: TRadioGroup;
    Panel6: TPanel;
    Label3: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    SDInclusionRadioGroup: TRadioGroup;
    Panel7: TPanel;
    SpecialDistrictListBox: TListBox;
    TabSheet9: TTabSheet;
    Panel8: TPanel;
    Label9: TLabel;
    Panel9: TPanel;
    PropertyClassListBox: TListBox;
    Label13: TLabel;
    Label14: TLabel;
    Label21: TLabel;
    AllBanksCheckBox: TCheckBox;
    BanksStringGrid: TStringGrid;
    RollSectionListBox: TListBox;
    Label7: TLabel;
    Label8: TLabel;
    ZipCodesStringGrid: TStringGrid;
    Label5: TLabel;
    Label6: TLabel;
    SchoolCodeListBox: TListBox;
    SwisCodeListBox: TListBox;
    EditLinesToPrintBold: TEdit;
    LabelFormatRadioGroup: TRadioGroup;
    FirstLineRadioGroup: TRadioGroup;
    SelectLinesToBoldLabel: TLabel;
    UnderlineCheckBox: TCheckBox;
    EditLinesToUnderline: TEdit;
    UnderlineOptionLabel: TLabel;
    GroupBox1: TGroupBox;
    LoadFromParcelListCheckBox: TCheckBox;
    PrintBySwisCodeCheckBox: TCheckBox;
    CreateParcelListCheckBox: TCheckBox;
    ExtractToExcelCheckBox: TCheckBox;
    CreateCommaDelimitedExtractCheckBox: TCheckBox;
    ItalicizeCheckBox: TCheckBox;
    EditLinesToItalicize: TEdit;
    ItalicizeOptionLabel: TLabel;
    Panel10: TPanel;
    Panel11: TPanel;
    RoadRangeListView: TListView;
    AddStreetRangeButton: TBitBtn;
    RemoveStreetRangeButton: TBitBtn;
    ReportFormatRadioGroup: TRadioGroup;
    SBLGroupBox: TGroupBox;
    Label23: TLabel;
    Label24: TLabel;
    StartSBLEdit: TEdit;
    EndSBLEdit: TEdit;
    AllSBLCheckBox: TCheckBox;
    ToEndOfSBLCheckBox: TCheckBox;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CloseButtonClick(Sender: TObject);
    procedure PrintButtonClick(Sender: TObject);
    procedure LabelPrinterPrint(Sender: TObject);
    procedure ReportPrintHeader(Sender: TObject);
    procedure ReportPrint(Sender: TObject);
    procedure AllBanksCheckBoxClick(Sender: TObject);
    procedure BanksStringGridSetEditText(Sender: TObject; ACol,
      ARow: Longint; const Value: String);
    procedure LabelPrintHeader(Sender: TObject);
    procedure LoadButtonClick(Sender: TObject);
    procedure SaveReportOptionsButtonClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure LabelFormatRadioGroupClick(Sender: TObject);
    procedure PrintLabelsBoldCheckBoxClick(Sender: TObject);
    procedure UnderlineCheckBoxClick(Sender: TObject);
    procedure ItalicizeCheckBoxClick(Sender: TObject);
    procedure AddStreetRangeButtonClick(Sender: TObject);
    procedure RemoveStreetRangeButtonClick(Sender: TObject);
    procedure RoadRangeListViewDblClick(Sender: TObject);
    procedure AllSBLCheckBoxClick(Sender: TObject);
  private
    { Private declarations }
  public

    { Public declarations }
    UnitName : String;
    NumLabelsPrinted : LongInt;

    LabelsCancelled : Boolean; {cancels print job}

      {Report selections}

    PrintAllExemptions,
    PrintAllSpecialDistricts,
    PrintAllBankCodes,
    PrintAllSwisCodes,
    PrintAllSchoolCodes,
    PrintAllRollSections,
    PrintAllPropertyClasses,
    PrintBySwisCode,
    PrintDuplicates,
    PrintLabelsBold,
    PrintLabelsUnderline,
    PrintLabelsItalicized,
    PrintOldAndNewParcelIDs,
    PrintOldAndNewParcelIDsShortForm,
    PrintSwisCodeOnParcelIDs : Boolean;

    SelectedExemptionCodes,
    SelectedSpecialDistricts,
    SelectedSchoolCodes,
    SelectedBankCodes,
    SelectedSwisCodes,
    SelectedRollSections,
    SelectedPropertyClasses,
    SelectedZipCodes : TStringList;

    AssessmentYear : String;

    EnhancedSTARType,
    ReportType,
    PrintOrder,
    PrintSuborder,
    ParcelType,
    LabelType,
    NumLinesPerLabel,
    NumLabelsPerPage,
    NumColumnsPerPage,
    SingleParcelFontSize : Integer;

    LastSwisCode : String;
    LastSchoolCode : String;
    LastRollSection : String;
    LastExemptionCode : String;
    LastSDCode : String;
    LastBankCode : String;
    LastPropertyClass : String;

    RollSectionList,
    SchoolCodeList,
    SwisCodeList,
    ExemptionCodeList,
    SDCodeList,
    PropertyClassList : TList;
    LoadFromParcelList,
    CreateParcelList,

      {CHG03011999-1: Allow user to print exemption or SD code on 1st line.}

    ResidentLabels, LegalAddressLabels,
    PrintExemptionCode, PrintSDCode,
    PrintAccountNumber_OldIDOnFirstLine,
    PrintParcelIDOnlyOnFirstLine : Boolean;
    IncludeExemptions,
    IncludeSpecialDistricts : Integer;

      {FXX03011999-1: Let user adjust top margin.}

    LaserTopMargin : Real;

    PrintParcelID_PropertyClass : Boolean;
    OrigSortFileName : String;
    LabelFormat : Integer;
    bSuppressNonRenewExemptions,
    ExtractToExcel, ExtractToCommaDelimitedFile : Boolean;
    FontSizeAdditionalLines : Integer;
    ExtractFile : TextFile;
    IVPEnrollmentStatusType : Integer;
    LinesToBold, LinesToUnderline, LinesToItalicize : TStringList;
    ReportFormat, LinesAtBottom : Integer;
    RoadRangeList : TList;

    StartSwisSBLKey, EndSwisSBLKey : String;
    PrintAllParcelIDs, PrintToEndOfParcelIDs : Boolean;

    Procedure InitializeForm;  {Open the tables and setup.}

    Procedure FillListBoxes(AssessmentYear : String);

    Function ValidSelections : Boolean;

    Function RecordInRange(ParcelTable : TTable;
                           ExemptionList,
                           SDList : TStringList) : Boolean;

    Procedure InsertOneSortRecord(SortTable,
                                  ParcelTable : TTable;
                                  SwisSBLKey : String;
                                  EXCode : String;
                                  SDCode : String;
                                  PrintBySwisCode : Boolean);

    Procedure SortFiles;
    {Fill a sort file with any parcels in range.}

    Procedure PrintSelectionPage(Sender : TObject);

    Procedure PrintAlignment(Sender : TObject);
    {Print 2 alignment labels until they are satisfied or quit.}

    Procedure PrintExemptionOrSDCode(    SwisSBLKey : String;
                                     var NAddrArray : NameAddrArray);

  end;

{$R *.DFM}

implementation

uses GlblVars, WinUtils, Utilitys,PASUTILS, UTILEXSD, Preview,
     Prog, EnStarTy, RptDialg, dlg_StreetRange, DataAccessUnit,
     PRCLLIST;  {Parcel list}

const
    {Report type constants}
  rtLabels = 0;
  rtReport = 1;
  rtBoth = 2;

    {Report formats}
  rfNormal = 0;
  rfAccountNumber_ParcelID_Address = 1;
  rfMailingAddress = 2;

    {Print orders}
  poParcelID = 0;
  poRollSection = 1;
  poSchoolCode = 2;
  poExemptionCode = 3;
  poSpecialDistrict = 4;
  poBankCode = 5;
  poPropertyClass = 6;
  poName = 7;
  poAddress = 8;
  poAccountNumber = 9;

    {Property suborder}
  psParcelID = 0;
  psAddress = 1;
  psName = 2;
  psZipCode = 3;

    {Parcel types}
  ptAllParcels = 0;
  ptComInvParcels = 1;
  ptResInvParcels = 2;
  ptNoInventory = 3;

  TrialRun = False;

    {Selection types for ex\sd codes.}

  stHasCode = 0;
  stDoesNotHaveCode = 1;
  stOnlyHasCode = 2;

  lfNormal = 0;
  lfParcelIDOnly = 1;
  lfParcelID_LegalAddress = 2;
  lfOwner_LegalAddress_PrintKey = 3;
  lfOwner_ExemptionCode_LegalAddress_PrintKey = 4;
  lfParcelAccountNumber_LegalAddress_OldID_ParcelID = 5;
  lfParcelID_OldID_LegalAddress = 6;
  lfParcelID_OldID = 7;
  lfParcelID_OldID_ShortForm = 8;

type
  TotalsRecord = record
    LandVal,
    AssessedVal : Comp;
    Acres : Extended;
    Count : LongInt;
  end;

{========================================================}
Procedure TLabelsForm.FormActivate(Sender: TObject);

begin
  SetFormStateMaximized(Self);
end;

{========================================================}
Procedure TLabelsForm.FillListBoxes(AssessmentYear : String);

{Fill in all the list boxes on the various notebook pages.}

var
  ProcessingType : Integer;

begin
    {FXX11241999-1: If this is history, set a range so that only codes from that
                    year are displayed.}

  ProcessingType := GetProcessingTypeForTaxRollYear(AssessmentYear);

  FillOneListBox(ExemptionListBox, ExemptionCodeTable, 'EXCode',
                 'Description', 10, True, False, ProcessingType, AssessmentYear);

  FillOneListBox(SpecialDistrictListBox, SDCodeTable, 'SDistCode',
                 'Description', 10, True, False, ProcessingType, AssessmentYear);

  FillOneListBox(SwisCodeListBox, SwisCodeTable, 'SwisCode',
                 'MunicipalityName', 15, True, True, ProcessingType, AssessmentYear);

  FillOneListBox(SchoolCodeListBox, SchoolCodeTable, 'SchoolCode',
                 'SchoolName', 15, True, True, ProcessingType, AssessmentYear);

  FillOneListBox(PropertyClassListBox, PropertyClassTable, 'MainCode',
                 'Description', 17, True, True, ProcessingType, AssessmentYear);

    {Select all items}

  SelectItemsInListBox(RollSectionListBox);
  SelectItemsInListBox(ExemptionListBox);
  SelectItemsInListBox(SpecialDistrictListBox);
  SelectItemsInListBox(SwisCodeListBox);
  SelectItemsInListBox(SchoolCodeListBox);
  SelectItemsInListBox(PropertyClassListBox);

end;  {FillListBoxes}

{========================================================}
Procedure TLabelsForm.InitializeForm;

begin
  UnitName := 'RPLABELS';

  OpenTablesForForm(Self, GlblProcessingType);

  AssessmentYear := GetTaxRlYr;

  FillListBoxes(AssessmentYear);

    {CHG11172003-1(2.07k): Add a label format box to accomodate printing parcel id \ legal address labels.}

  If not GlblLocateByOldParcelID
    then
      with LabelFormatRadioGroup.Items do
        begin
          Delete(lfParcelID_OldID_ShortForm);
          Delete(lfParcelID_OldID);
          Delete(lfParcelID_OldID_LegalAddress);

        end;  {with LabelFormatRadioGroup.Items do}

  OrigSortFileName := SortTable.TableName;

    {CHG11182003-5(2.07k): If there is only one swis code, default print swis on parcel IDs to false.}

  PrintSwisCodeOnParcelIDCheckBox.Checked := (SwisCodeTable.RecordCount > 1);
  PageControl.ActivePage := OptionsTabSheet;

end;  {InitializeForm}

{===================================================================}
Procedure TLabelsForm.LabelFormatRadioGroupClick(Sender: TObject);

{CHG11172003-1(2.07k): Add a label format box to accomodate printing parcel id \ legal address labels.}
{CHG12292004-1(2.8.1.7): Allow for font size to be altered even for non-parcel labels.}

begin
  If (LabelFormatRadioGroup.ItemIndex in [lfParcelIDOnly, lfParcelID_LegalAddress, lfParcelID_OldID_LegalAddress])
    then
      begin
        FontSizeEdit.Text := '16';
        FontSizeAdditionalLinesEdit.Text := '14';
      end
    else
      begin
        FontSizeEdit.Text := '10';
        FontSizeAdditionalLinesEdit.Text := '10';
      end;  {else of If (LabelFormatRadioGroup.ItemIndex...}

end;  {LabelFormatRadioGroupClick}

{===================================================================}
Procedure TLabelsForm.PrintLabelsBoldCheckBoxClick(Sender: TObject);

begin
  SelectLinesToBoldLabel.Enabled := PrintLabelsBoldCheckBox.Checked;
  EditLinesToPrintBold.Enabled := PrintLabelsBoldCheckBox.Checked;

end;  {PrintLabelsBoldCheckBoxClick}

{===================================================================}
Procedure TLabelsForm.UnderlineCheckBoxClick(Sender: TObject);

{CHG12302004-2(2.8.1.7): Add option to underline labels.}

begin
  UnderlineOptionLabel.Enabled := UnderlineCheckBox.Checked;
  EditLinesToUnderline.Enabled := UnderlineCheckBox.Checked;
end;  {UnderlineCheckBoxClick}

{===================================================================}
Procedure TLabelsForm.ItalicizeCheckBoxClick(Sender: TObject);

{CHG12302004-3(2.8.1.7): Add option to italicize labels.}

begin
  ItalicizeOptionLabel.Enabled := ItalicizeCheckBox.Checked;
  EditLinesToItalicize.Enabled := ItalicizeCheckBox.Checked;
end;  {ItalicizeCheckBoxClick}

{===================================================================}
Procedure TLabelsForm.AllBanksCheckBoxClick(Sender: TObject);

{Get rid of any bank codes already entered.}

var
  I, J : Integer;

begin
  If AllBanksCheckBox.Checked
    then
      with BanksStringGrid do
        For I := 0 to (ColCount - 1) do
          For J := 0 to (RowCount - 1) do
            Cells[I, J] := '';

end;  {AllBanksCheckBoxClick}

{===================================================================}
Procedure TLabelsForm.BanksStringGridSetEditText(Sender: TObject;
                                                 ACol, ARow: Longint;
                                                 const Value: String);
begin
  AllBanksCheckBox.Checked := False;
end;

{===================================================================}
Procedure TLabelsForm.AddStreetRangeButtonClick(Sender: TObject);

var
  StreetRangeDialog : TStreetRangeDialog;

begin
  StreetRangeDialog := nil;

  try
    StreetRangeDialog := TStreetRangeDialog.Create(nil);

    with StreetRangeDialog do
      If _Compare(ShowModal, idOK, coEqual)
        then FillInListViewRow(RoadRangeListView,
                               [StartingStreetNumber, StartingStreet,
                                EndingStreetNumber, EndingStreet], True);
  finally
    StreetRangeDialog.Free;
  end;

end;  {AddStreetRangeButtonClick}

{===================================================================}
Procedure TLabelsForm.RemoveStreetRangeButtonClick(Sender: TObject);

begin
  DeleteSelectedListViewRow(RoadRangeListView);
end;  {RemoveStreetRangeButtonClick}

{===================================================================}
Procedure TLabelsForm.RoadRangeListViewDblClick(Sender: TObject);

var
  StreetRangeDialog : TStreetRangeDialog;
  ValuesList : TStringList;

begin
  StreetRangeDialog := nil;
  ValuesList := TStringList.Create;

  GetColumnValuesForItem(RoadRangeListView, ValuesList, -1);

  try
    StreetRangeDialog := TStreetRangeDialog.Create(nil);

    with StreetRangeDialog do
      begin
        Load(ValuesList[0], ValuesList[1], ValuesList[2], ValuesList[3]);

        If _Compare(ShowModal, idOK, coEqual)
          then FillInListViewRow(RoadRangeListView,
                                 [StartingStreetNumber, StartingStreet,
                                  EndingStreetNumber, EndingStreet], True);

      end;  {with StreetRangeDialog do}

  finally
    StreetRangeDialog.Free;
  end;

end;  {RoadRangeListViewDblClick}

{=======================================================}
Procedure TLabelsForm.AllSBLCheckBoxClick(Sender: TObject);

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

{===================================================================}
Function TLabelsForm.ValidSelections : Boolean;

var
  I, J, NumBanks : Integer;

begin
  Result := True;

  If (AssessmentYearRadioGroup.ItemIndex = -1)
    then
      begin
        MessageDlg('Please select an assessment year before printing.',
                   mtError, [mbOK], 0);
        Result := False;
      end;

  If (Result and
      (ReportTypeRadioGroup.ItemIndex = -1))
    then
      begin
        MessageDlg('Please select a report type before printing.',
                   mtError, [mbOK], 0);
        Result := False;
      end;

  If (Result and
      (PrintOrderRadioGroup.ItemIndex = -1))
    then
      begin
        MessageDlg('Please select a print order before printing.',
                   mtError, [mbOK], 0);
        Result := False;
      end;

    {FXX09071999-1: Add print by name and addr.}

  If (Result and
      (PrintSuborderRadioGroup.ItemIndex = -1) and
      (not (PrintOrderRadioGroup.ItemIndex in [poParcelID, poName, poAddress, poAccountNumber])))
    then
      begin
        MessageDlg('Please select a print sub order before printing.',
                   mtError, [mbOK], 0);
        Result := False;
      end;

    {CHG07281999-1: Allow users to select parcels that exclusively have a given ex or sd.}

  If (Result and
      (ExemptionListBox.SelCount > 1) and
      (ExemptionInclusionRadioGroup.ItemIndex = stOnlyHasCode))
    then
      begin
        MessageDlg('Please select only one exemption code to search exclusively for.',
                   mtError, [mbOK], 0);
        Result := False;
      end;

    {FXX06181999-4: Allow printing for munic with no special districts.}

  If (Result and
      (SpecialDistrictListBox.SelCount = 0) and
      _Compare(SpecialDistrictListBox.Items.Count, 0, coGreaterThan))
    then
      begin
        MessageDlg('Please select one or more special district codes before printing.',
                   mtError, [mbOK], 0);
        Result := False;
      end;

    {CHG07281999-1: Allow users to select parcels that exclusively have a given ex or sd.}

  If (Result and
      (SpecialDistrictListBox.SelCount > 1) and
      (SDInclusionRadioGroup.ItemIndex = stOnlyHasCode))
    then
      begin
        MessageDlg('Please select only one special district code to search exclusively for.',
                   mtError, [mbOK], 0);
        Result := False;
      end;

  If (Result and
      (SwisCodeListBox.SelCount = 0))
    then
      begin
        MessageDlg('Please select one or more swis codes before printing.',
                   mtError, [mbOK], 0);
        Result := False;
      end;

  If (Result and
      (SchoolCodeListBox.SelCount = 0))
    then
      begin
        MessageDlg('Please select one or more school codes before printing.',
                   mtError, [mbOK], 0);
        Result := False;
      end;

  If (Result and
      (PropertyClassListBox.SelCount = 0))
    then
      begin
        MessageDlg('Please select one or more property class codes before printing.',
                   mtError, [mbOK], 0);
        Result := False;
      end;

  If (Result and
      (RollSectionListBox.SelCount = 0))
    then
      begin
        MessageDlg('Please select one or more roll sections before printing.',
                   mtError, [mbOK], 0);
        Result := False;
      end;

  NumBanks := 0;
  with BanksStringGrid do
    For I := 0 to (ColCount - 1) do
      For J := 0 to (RowCount - 1) do
        If (Deblank(Cells[I, J]) <> '')
          then NumBanks := NumBanks + 1;

   If (Result and
       (not (AllBanksCheckBox.Checked or
            (NumBanks > 0))))
     then
       begin
         MessageDlg('Please either select all banks or enter one or more bank codes.',
                    mtError, [mbOK], 0);
         Result := False;
       end;

     {FXX03191999-3: Make sure they select a label type.}
     {FXX06181999-3: Don't make them choose a label type if report only.}

  If (Result and
      (ReportTypeRadioGroup.ItemIndex in [rtLabels, rtBoth]) and
      (LabelTypeRadioGroup.ItemIndex = -1))
    then
      begin
        MessageDlg('Please select a type of label to print.', mtError, [mbOK], 0);
        Result := False;
      end;

  If (Result and
      LoadFromParcelListCheckBox.Checked and
      CreateParcelListCheckBox.Checked)
    then
      begin
        MessageDlg('Sorry, you can not choose to both load from the parcel list and' + #13 +
                   'create a new parcel list.', mtError, [mbOK], 0);
        Result := False;
      end;

end;  {ValidSelections}

{===================================================================}
Function TLabelsForm.RecordInRange(ParcelTable : TTable;
                                   ExemptionList,
                                   SDList : TStringList) : Boolean;

var
  MeetsRoadRangeCriteria, MeetsParcelIDRange,
  ParcelHasSenior, ZipCodeFound,
  SwisCodeFound, BankCodeFound, SchoolCodeFound,
  PropertyClassFound, RollSectionFound,
  ExemptionFound, SpecialDistrictFound,
  HasCommercialInventory, HasResidentialInventory,
  MeetsExemptionCriteria, MeetsSpecialDistrictCriteria,
  FirstTimeThrough, CorrectParcelType, Done, InactiveParcel : Boolean;
  SwisSBLKey, AssessmentYear : String;
  I, ProcessingType, ZipCodeLength : Integer;
  CommercialSiteTable, ResidentialSiteTable : TTable;
  ValuesList : TStringList;

begin
  ExemptionList.Clear;
  SDList.Clear;

  with ParcelTable do
    begin
        {FXX09301998-2: Do not print labels for inactive parcels.}

      InactiveParcel := (FieldByName('ActiveFlag').Text = InactiveParcelFlag);

      SwisCodeFound := False;
      If PrintAllSwisCodes
        then SwisCodeFound := True
        else
          For I := 0 to (SelectedSwisCodes.Count - 1) do
            If (FieldByName('SwisCode').Text = SelectedSwisCodes[I])
              then SwisCodeFound := True;

      SchoolCodeFound := False;
      If PrintAllSchoolCodes
        then SchoolCodeFound := True
        else
          For I := 0 to (SelectedSchoolCodes.Count - 1) do
            If (FieldByName('SchoolCode').Text = SelectedSchoolCodes[I])
              then SchoolCodeFound := True;

      BankCodeFound := False;
      If PrintAllBankCodes
        then BankCodeFound := True
        else
          For I := 0 to (SelectedBankCodes.Count - 1) do
            If (FieldByName('BankCode').Text = SelectedBankCodes[I])
              then BankCodeFound := True;

        {CHG02252004-3(2.08): Allow them to select zip codes.}

      ZipCodeFound := False;
      If (SelectedZipCodes.Count = 0)
        then ZipCodeFound := True
        else
          For I := 0 to (SelectedZipCodes.Count - 1) do
            begin
              ZipCodeLength := Length(Trim(SelectedZipCodes[I]));

              If (Take(ZipCodeLength, FieldByName('Zip').Text) =
                  Take(ZipCodeLength, SelectedZipCodes[I]))
                then ZipCodeFound := True;

            end;  {For I := 0 to (SelectedZipCodes.Count - 1) do}

      RollSectionFound := False;
      If PrintAllRollSections
        then RollSectionFound := True
        else
          For I := 0 to (SelectedRollSections.Count - 1) do
            If (FieldByName('RollSection').Text = SelectedRollSections[I])
              then RollSectionFound := True;

      PropertyClassFound := False;
      If PrintAllPropertyClasses
        then PropertyClassFound := True
        else
          For I := 0 to (SelectedPropertyClasses.Count - 1) do
            If (FieldByName('PropertyClassCode').Text = SelectedPropertyClasses[I])
              then PropertyClassFound := True;

    end;  {with ParcelTable do}

  SwisSBLKey := ExtractSSKey(ParcelTable);
  AssessmentYear := ParcelTable.FieldByName('TaxRollYr').Text;
  ProcessingType := GetProcessingTypeForTaxRollYear(AssessmentYear);

    {CHG07281999-1: Allow user to look exclusively for an exemption or SD.}
    {FXX11241999-2: If they want to print the exemption or sd code on the first line,
                    then need to get ex, sd list, even if all selected.}

  If ((IncludeExemptions = stHasCode) and
      PrintAllExemptions and
      (not PrintExemptionCode))
    then ExemptionFound := True
    else
      begin
        ExemptionFound := False;

        FirstTimeThrough := True;
        Done := False;
        ParcelExemptionTable.CancelRange;
        SetRangeOld(ParcelExemptionTable,
                    ['TaxRollYr', 'SwisSBLKey', 'ExemptionCode'],
                    [AssessmentYear, SwisSBLKey, '     '],
                    [AssessmentYear, SwisSBLKey, 'ZZZZZ']);

        repeat
          If FirstTimeThrough
            then FirstTimeThrough := False
            else ParcelExemptionTable.Next;

          If ParcelExemptionTable.EOF
            then Done := True;

          If not Done
            then ExemptionList.Add(ParcelExemptionTable.FieldByName('ExemptionCode').Text);

        until Done;

          {CHG11011999-2: If they just selected 41834 to print, ask if
                          they want seniors too.}

        ParcelHasSenior := False;

        For I := 0 to (ExemptionList.Count - 1) do
          If (Take(4, ExemptionList[I]) = '4180')
            then ParcelHasSenior := True;

          {FXX12281999-1: Use the enhanced STAR dialog.}

        If ((SelectedExemptionCodes.Count = 1) and
            (SelectedExemptionCodes[0] = EnhancedSTARExemptionCode))
          then
            begin
              case EnhancedSTARType of
                enSeniorSTAROnly :
                      ExemptionFound := ((ExemptionList.IndexOf(EnhancedSTARExemptionCode) > -1) and
                                         (not ParcelHasSenior));
                enWithSeniorandSTARExemption :
                      ExemptionFound := ((ExemptionList.IndexOf(EnhancedSTARExemptionCode) > -1) and
                                         ParcelHasSenior);
                enAnySeniorSTAR :
                      ExemptionFound := (ExemptionList.IndexOf(EnhancedSTARExemptionCode) > -1);

              end;  {case EnhancedSTARType of}

                {CHG01212004-1(2.08): Add ability to select IVP enrollment status as a choice.}

              If ExemptionFound
                then
                  begin
                    FindKeyOld(ParcelExemptionTable,
                               ['TaxRollYr', 'SwisSBLKey', 'ExemptionCode'],
                               [AssessmentYear, SwisSBLKey, EnhancedSTARExemptionCode]);

                    case IVPEnrollmentStatusType of
                      ivpEnrolledOnly : ExemptionFound := ParcelExemptionTable.FieldByName('AutoRenew').AsBoolean;
                      ivpNotEnrolledOnly : ExemptionFound := (not ParcelExemptionTable.FieldByName('AutoRenew').AsBoolean);
                    end;  {case IVPEnrollmentStatusType of}

                  end;  {If ExemptionFound}

            end
          else
            For I := 0 to (ExemptionList.Count - 1) do
              If (SelectedExemptionCodes.IndexOf(ExemptionList[I]) <> -1)
                then
                  begin
                    If (bSuppressNonRenewExemptions and
                        ExemptionIsVolunteerFirefighter(ExemptionList[I]))
                      then
                        begin
                          If (_Locate(ParcelExemptionTable, [AssessmentYear, SwisSBLKey, ExemptionList[I]], '', []) and
                              (not ParcelExemptionTable.FieldByName('PreventRenewal').AsBoolean))
                            then ExemptionFound := True;

                        end
                      else ExemptionFound := True;

                  end;  {If (SelectedExemptionCodes.IndexOf(ExemptionList[I]) <> -1)}

          {FXX12131999-3: Did not work to say print parcels with no exemptions or SDs.}

        If (PrintAllExemptions and
            ((IncludeExemptions = stHasCode) or  {Wants all regardless of exemptions.}
             ((IncludeExemptions = stDoesNotHaveCode) and  {Wants parcels without an exemption.}
              (ExemptionList.Count > 0))))
          then ExemptionFound := True;

      end;  {else of IfPrintAllExemptions}

  MeetsExemptionCriteria := ((IncludeExemptions = stHasCode) and  {They want any parcel with selected ex code.}
                             ExemptionFound) or
                            ((IncludeExemptions = stDoesNotHaveCode) and {Want parcels without selected ex code.}
                             (not ExemptionFound)) or
                            ((IncludeExemptions = stOnlyHasCode) and  {Only the 1 selected.}
                             (ExemptionList.Count = 1) and
                             ExemptionFound);

  If ((IncludeSpecialDistricts = stHasCode) and
       PrintAllSpecialDistricts and
      (not PrintSDCode))
    then SpecialDistrictFound := True
    else
      begin
        SpecialDistrictFound := False;

        FirstTimeThrough := True;
        Done := False;
        ParcelSDTable.CancelRange;
        SetRangeOld(ParcelSDTable,
                    ['TaxRollYr', 'SwisSBLKey', 'SDistCode'],
                    [AssessmentYear, SwisSBLKey, '     '],
                    [AssessmentYear, SwisSBLKey, 'ZZZZZ']);

        repeat
          If FirstTimeThrough
            then FirstTimeThrough := False
            else ParcelSDTable.Next;

          If ParcelSDTable.EOF
            then Done := True;

          If not Done
            then SDList.Add(ParcelSDTable.FieldByName('SDistCode').Text);

        until Done;

        For I := 0 to (SDList.Count - 1) do
          If (SelectedSpecialDistricts.IndexOf(SDList[I]) > - 1)
            then SpecialDistrictFound := True;

          {FXX12131999-3: Did not work to say print parcels with no Exemptions or SDs.}

        If (PrintAllSpecialDistricts and
            ((IncludeSpecialDistricts = stHasCode) or  {Wants all regardless of SpecialDistricts.}
             ((IncludeSpecialDistricts = stDoesNotHaveCode) and  {Wants parcels without an SpecialDistrict.}
              (SDList.Count > 0))))
          then SpecialDistrictFound := True;

      end;  {else of IfPrintAllSpecialDistricts}

    {FXX07172008-1(2.14.1.3)[D1309]: If the municipality does not special districts, then don't consider them.}

  MeetsSpecialDistrictCriteria := _Compare(SelectedSpecialDistricts.Count, 0, coEqual) or
                                  ((IncludeSpecialDistricts = stHasCode) and  {They want any parcel with selected SD code.}
                                   SpecialDistrictFound) or
                                  ((IncludeSpecialDistricts = stDoesNotHaveCode) and {Want parcels without selected SD code.}
                                   (not SpecialDistrictFound)) or
                                  ((IncludeSpecialDistricts = stOnlyHasCode) and  {Only the 1 selected.}
                                   (SDList.Count = 1) and
                                   SpecialDistrictFound);

    {FXX07161998-1: Add filter for parcel type.}
    {CHG06252002-1: Selection for no inventory.}

  CorrectParcelType := False;
  HasCommercialInventory := False;
  HasResidentialInventory := False;

  If (ParcelType = ptAllParcels)
    then CorrectParcelType := True;

    {FXX05112001-2: Hook up the commercial and residential inventory
                    option.}

  If (ParcelType in [ptComInvParcels, ptNoInventory])
    then
      begin
        CommercialSiteTable := FindTableInDataModuleForProcessingType(DataModuleCommercialSiteTableName,
                                                                      ProcessingType);

        CommercialSiteTable.CancelRange;
        FindNearestOld(CommercialSiteTable, ['TaxRollYr', 'SwisSBLKey'],
                       [AssessmentYear, SwisSBLKey]);

        HasCommercialInventory := (Take(26, CommercialSiteTable.FieldByName('SwisSBLKey').Text) =
                                   Take(26, SwisSBLKey));

        CorrectParcelType := HasCommercialInventory;

      end;  {If (ParcelType = ptComInvParcels)}

  If (ParcelType in [ptResInvParcels, ptNoInventory])
    then
      begin
        ResidentialSiteTable := FindTableInDataModuleForProcessingType(DataModuleResidentialSiteTableName,
                                                                       ProcessingType);

        ResidentialSiteTable.CancelRange;
        FindNearestOld(ResidentialSiteTable, ['TaxRollYr', 'SwisSBLKey'],
                       [AssessmentYear, SwisSBLKey]);

        HasResidentialInventory := (Take(26, ResidentialSiteTable.FieldByName('SwisSBLKey').Text) =
                                    Take(26, SwisSBLKey));

        CorrectParcelType := HasResidentialInventory;

      end;  {If (ParcelType = ptResInvParcels)}

  If (ParcelType = ptNoInventory)
    then CorrectParcelType := (not (HasCommercialInventory or HasResidentialInventory));

  MeetsRoadRangeCriteria := True;

  with RoadRangeList do
    If _Compare(Count, 0, coGreaterThan)
      then
        begin
          MeetsRoadRangeCriteria := False;

          For I := 0 to (Count - 1) do
            with RoadRangePointer(RoadRangeList[I])^ do
              MeetsRoadRangeCriteria := MeetsRoadRangeCriteria or
                                        AddressMeetsRangeCriteria(ParcelTable.FieldByName('LegalAddrInt').AsInteger,
                                                                  ParcelTable.FieldByName('LegalAddr').AsString,
                                                                  StartingStreetNumber,
                                                                  StartingStreet,
                                                                  EndingStreetNumber,
                                                                  EndingStreet);

        end;  {If _Compare(Count, 0, coGreaterThan)}

    {CHG07022008-1(2.13.1.21)[F1297]: Let them enter a parcel ID range.}

  If PrintAllParcelIDs
    then MeetsParcelIDRange := True
    else
      begin
        MeetsParcelIDRange := False;

        If ((SwisSBLKey >= StartSwisSBLKey) and
            (PrintToEndOfParcelIDs or
             (SwisSBLKey <= EndSwisSBLKey)))
          then MeetsParcelIDRange := True;

      end;  {else of If PrintAllParcelIDs}

    {FXX05161999-1: Don't make being loaded from parcel list an automatic
                    qualification for RecordInRange - it has to go through
                    the tests also - this makes it more flexible.
                    If they want exactly that list, then leave all
                    options selected.}

    {FXX12082004-3(2.8.1.2): Do not print labels for inactive parcels.}

  Result := ((not InactiveParcel) and
             SwisCodeFound and
             BankCodeFound and
             ZipCodeFound and
             SchoolCodeFound and
             PropertyClassFound and
             RollSectionFound and
             MeetsExemptionCriteria and
             MeetsSpecialDistrictCriteria and
             CorrectParcelType and
             MeetsRoadRangeCriteria and
             MeetsParcelIDRange{ or
             LoadFromParcelList});

end;  {RecordInRange}

{===================================================================}
Procedure TLabelsForm.InsertOneSortRecord(SortTable,
                                          ParcelTable : TTable;
                                          SwisSBLKey : String;
                                          EXCode : String;
                                          SDCode : String;
                                          PrintBySwisCode : Boolean);

begin
  with SortTable do
    try
      Insert;

      FieldByName('SwisCode').Text := Copy(SwisSBLKey, 1, 6);

        {Only fill in the swis code key if they are printing by swis code.
         Otherwise, it will be blank and will not affect the keys.}

      If PrintBySwisCode
        then FieldByName('SwisCodeKey').Text := FieldByName('SwisCode').Text;

      FieldByName('SBLKey').Text := Copy(SwisSBLKey, 7, 20);
      FieldByName('SchoolCode').Text := ParcelTable.FieldByName('SchoolCode').Text;
      FieldByName('Name1').Text := ParcelTable.FieldByName('Name1').Text;
      FieldByName('LegalAddrNo').Text := ParcelTable.FieldByName('LegalAddrNo').Text;
      FieldByName('LegalAddr').Text := ParcelTable.FieldByName('LegalAddr').Text;
      try
        FieldByName('LegalAddrInt').AsInteger := ParcelTable.FieldByName('LegalAddrInt').AsInteger;
      except
      end;
      
      FieldByName('ZipCode').Text := ParcelTable.FieldByName('Zip').Text;
      FieldByName('ZipPlus4').Text := ParcelTable.FieldByName('ZipPlus4').Text;
      FieldByName('RollSection').Text := ParcelTable.FieldByName('RollSection').Text;
      FieldByName('PropertyClass').Text := ParcelTable.FieldByName('PropertyClassCode').Text;
      FieldByName('BankCode').Text := ParcelTable.FieldByName('BankCode').Text;
      FieldByName('SDCode').Text := SDCode;
      FieldByName('EXCode').Text := EXCode;

      try
        FieldByName('AccountNo').Text := ParcelTable.FieldByName('AccountNo').Text
      except
      end;

      Post;
    except
      SystemSupport(023, SortTable, 'Error inserting sort record.', UnitName, GlblErrorDlgBox);
    end;

end;  {InsertOneSortRecord}

{===================================================================}
Procedure TLabelsForm.SortFiles;

{Fill a sort file with any parcels in range.}

var
  Found, FirstTimeThrough, Done : Boolean;
  ExemptionList, SDList : TStringList;
  SwisSBLKey : String;
  I, Index : Integer;
  NumFound : LongInt;

begin
  Index := 1;
  NumFound := 0;
  FirstTimeThrough := True;
  Done := False;

    {CHG03101999-1: Send info to a list.}

  If CreateParcelList
    then ParcelListDialog.ClearParcelGrid(True);

  If LoadFromParcelList
    then ParcelListDialog.GetParcel(ParcelTable, Index)
    else ParcelTable.First;

  ExemptionList := TStringList.Create;
  SDList := TStringList.Create;

  If LoadFromParcelList
    then ProgressDialog.Start(ParcelListDialog.NumItems, True, True)
    else ProgressDialog.Start(GetRecordCount(ParcelTable), True, True);

  ProgressDialog.UserLabelCaption := 'Sorting files.';

  repeat
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
         (Index > ParcelListDialog.NumItems)) or
        (TrialRun and
         (NumFound = 25)))
      then Done := True;

    Application.ProcessMessages;

    If LoadFromParcelList
      then ProgressDialog.Update(Self, ParcelListDialog.GetParcelID(Index))
      else ProgressDialog.Update(Self, ConvertSwisSBLToDashDot(ExtractSSKey(ParcelTable)));

    If ((not Done) and
        RecordInRange(ParcelTable, ExemptionList, SDList))
      then
        begin
          NumFound := NumFound + 1;
          SwisSBLKey := ExtractSSKey(ParcelTable);

            {FXX09221999-1: Had an unitialized var - was causing no labels to print.}

          Found := False;

          ProgressDialog.UserLabelCaption := 'Number Found = ' + IntToStr(NumFound);

             {CHG03101999-1: Send info to a list.}

           If CreateParcelList
             then ParcelListDialog.AddOneParcel(SwisSBLKey);

           {If they want duplicates and they are printing in sd or ex order, then put in one
            for each selected exemption or sd.  Otherwise, just insert the first matching one.}

           {FXX09071999-6: Store ex and sd code if they want to see it on the first line.}

          If (PrintDuplicates and
              (PrintOrder in [poExemptionCode, poSpecialDistrict]))
            then
              begin
                If ((PrintOrder = poExemptionCode) or
                    PrintExemptionCode)
                  then
                    For I := 0 to (ExemptionList.Count - 1) do
                      If (SelectedExemptionCodes.IndexOf(ExemptionList[I]) > -1)
                        then InsertOneSortRecord(SortTable, ParcelTable, SwisSBLKey, ExemptionList[I],
                                                 '', PrintBySwisCode);

                If ((PrintOrder = poSpecialDistrict) or
                    PrintSDCode)
                  then
                    For I := 0 to (SDList.Count - 1) do
                      If (SelectedSpecialDistricts.IndexOf(SDList[I]) > -1)
                        then InsertOneSortRecord(SortTable, ParcelTable, SwisSBLKey, '', SDList[I], PrintBySwisCode);

              end
            else
              begin
                  {Only insert for one exemption or special district even if more
                   than one matches.}
                  {FXX11241999-2: If they want to print the exemption or sd code on the first line,
                                  then need to get ex, sd list, even if all selected.}

                If ((PrintOrder = poExemptionCode) or
                    _Compare(LabelFormat, lfOwner_ExemptionCode_LegalAddress_PrintKey, coEqual) or
                    PrintExemptionCode)
                  then
                    begin
                      Found := False;

                      For I := 0 to (ExemptionList.Count - 1) do
                        If ((PrintAllExemptions or
                             (SelectedExemptionCodes.IndexOf(ExemptionList[I]) > -1)) and
                            (not Found))
                          then
                            begin
                              Found := True;
                              InsertOneSortRecord(SortTable, ParcelTable, SwisSBLKey, ExemptionList[I],
                                                   '', PrintBySwisCode);
                            end;  {If ((SelectedExemptionCodes.IndexOf(ExemptionList[I]) > -1) and...}

                    end;  {If (PrintOrder = poExemptionCode)}

                If ((PrintOrder = poSpecialDistrict) or
                    PrintSDCode)
                  then
                    begin
                      Found := False;

                      For I := 0 to (SDList.Count - 1) do
                        If ((PrintAllSpecialDistricts or
                             (SelectedSpecialDistricts.IndexOf(SDList[I]) > -1)) and
                            (not Found))
                          then
                            begin
                              Found := True;
                              InsertOneSortRecord(SortTable, ParcelTable, SwisSBLKey, '',
                                                  SDList[I], PrintBySwisCode);
                            end;  {If ((SelectedSpecialDistricts.IndexOf(SDList[I]) > -1) and...}

                    end;  {If (PrintOrder = poSpecialDistrictCode)}

                If ((not (Found or
                         (PrintOrder in [poExemptionCode, poSpecialDistrict]))) and
                    _Compare(LabelFormat, lfOwner_ExemptionCode_LegalAddress_PrintKey, coNotEqual))
                  then InsertOneSortRecord(SortTable, ParcelTable, SwisSBLKey,
                                           '', '', PrintBySwisCode);

              end;  {If (PrintDuplicates and...}

        end;  {If ((not Done) and ...}

    LabelsCancelled := ProgressDialog.Cancelled;

  until (Done or LabelsCancelled);

  ExemptionList.Free;
  SDList.Free;

end;  {SortFiles}

{====================================================================}
Procedure TLabelsForm.SaveReportOptionsButtonClick(Sender: TObject);

{FXX04091999-8: Add ability to save and load search report options.}

begin
  SaveReportOptions(Self, OpenDialog, SaveDialog, 'labels.lab', 'Labels');

end;  {SaveButtonClick}

{====================================================================}
Procedure TLabelsForm.LoadButtonClick(Sender: TObject);

{FXX04091999-8: Add ability to save and load search report options.}

begin
  LoadReportOptions(Self, OpenDialog, 'labels.lab', 'Labels');

end;  {LoadButtonClick}

{===================================================================}
Procedure LoadLinesToPrint(LinesList : TStringList;
                           LinesToPrint : String;
                           UseFeature : Boolean);

var
  I, TempInt : Integer;

begin
  If UseFeature
    then
      If _Compare(LinesToPrint, 'ALL', coEqual)
        then
          For I := 1 to 6 do
            LinesList.Add(IntToStr(I))
        else
          begin
            For I := 1 to Length(Trim(LinesToPrint)) do
              try
                TempInt := StrToInt(LinesToPrint[I]);
                LinesList.Add(IntToStr(TempInt));
              except
              end;

          end;  {else of If _Compare(LinesToPrint, 'ALL', coEqual)}

end;  {LoadLinesToPrint}

{===================================================================}
Procedure TLabelsForm.PrintButtonClick(Sender: TObject);

var
  SpreadsheetFileName, SortFileName,
  TempIndex, NewFileName : String;
  TempFile : File;
  I, J, ProcessingType : Integer;
  Quit, Cancelled, ValidEntry,
  WideCarriage, bUserSelectedNonRenewExemption : Boolean;
  ValuesList : TStringList;
  RoadRangePtr : RoadRangePointer;

begin
  Quit := False;
  LinesToBold := TStringList.Create;
  LinesToUnderline := TStringList.Create;
  LinesToItalicize := TStringList.Create;
  ReportFormat := ReportFormatRadioGroup.ItemIndex;

    {FXX09301998-1: Disable print button after clicking to avoid clicking twice.}

  PrintButton.Enabled := False;
  Application.ProcessMessages;

    {CHG10121998-1: Add user options for default destination and show vet max msg.}

  SetPrintToScreenDefault(PrintDialog);

  If ValidSelections
    then
      begin
        SelectedExemptionCodes := TStringList.Create;
        SelectedSpecialDistricts := TStringList.Create;
        SelectedBankCodes := TStringList.Create;
        SelectedSwisCodes := TStringList.Create;
        SelectedRollSections := TStringList.Create;
        SelectedPropertyClasses := TStringList.Create;
        SelectedSchoolCodes := TStringList.Create;
        SelectedZipCodes := TStringList.Create;

        PrintAllExemptions := False;
        PrintAllSpecialDistricts := False;
        PrintAllBankCodes := False;
        PrintAllSwisCodes := False;
        PrintAllSchoolCodes := False;
        PrintAllRollSections := False;
        PrintAllPropertyClasses := False;

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

        with SwisCodeListBox do
          If (SelCount = Items.Count)
            then PrintAllSwisCodes := True
            else
              For I := 0 to (Items.Count - 1) do
                If Selected[I]
                  then SelectedSwisCodes.Add(Take(6, Items[I]));

        with SchoolCodeListBox do
          If (SelCount = Items.Count)
            then PrintAllSchoolCodes := True
            else
              For I := 0 to (Items.Count - 1) do
                If Selected[I]
                  then SelectedSchoolCodes.Add(Take(6, Items[I]));

        with RollSectionListBox do
          If (SelCount = Items.Count)
            then PrintAllRollSections := True
            else
              For I := 0 to (Items.Count - 1) do
                If Selected[I]
                  then SelectedRollSections.Add(Take(1, Items[I]));

        with PropertyClassListBox do
          If (SelCount = Items.Count)
            then PrintAllPropertyClasses := True
            else
              For I := 0 to (Items.Count - 1) do
                If Selected[I]
                  then SelectedPropertyClasses.Add(Take(3, Items[I]));

        If AllBanksCheckBox.Checked
          then PrintAllBankCodes := True
          else
            with BanksStringGrid do
              For I := 0 to (ColCount - 1) do
                For J := 0 to (RowCount - 1) do
                  If (Deblank(Cells[I, J]) <> '')
                    then SelectedBankCodes.Add(Trim(Cells[I, J]));

          {CHG02252004-3(2.08): Allow them to select zip codes.}

        with ZipCodesStringGrid do
          For I := 0 to (ColCount - 1) do
            For J := 0 to (RowCount - 1) do
              If (Deblank(Cells[I, J]) <> '')
                then SelectedZipCodes.Add(Trim(Cells[I, J]));

        PrintBySwisCode := PrintBySwisCodeCheckBox.Checked;
        PrintDuplicates := PrintDuplicatesCheckBox.Checked;

          {FXX10041999-2: Allow print labels bold.}

        PrintLabelsBold := PrintLabelsBoldCheckBox.Checked;
        PrintLabelsUnderline := UnderlineCheckBox.Checked;
        PrintLabelsItalicized := ItalicizeCheckBox.Checked;

        If (AssessmentYearRadioGroup.ItemIndex = 0)
          then AssessmentYear := GlblThisYear
          else AssessmentYear := GlblNextYear;

          {CHG07022008-1(2.13.1.21)[F1297]: Let them enter a parcel ID range.}

        StartSwisSBLKey := '';
        EndSwisSBLKey := '';
        PrintAllParcelIDs := False;
        PrintToEndOfParcelIDs := False;

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

          {CHG01212006-1(2.9.5.1): Add road selection ability.}

        ValuesList := TStringList.Create;
        RoadRangeList := TList.Create;

        with RoadRangeListView do
          For I := 0 to (Items.Count - 1) do
            begin
              GetColumnValuesForItem(RoadRangeListView, ValuesList, I);

              New(RoadRangePtr);

              with RoadRangePtr^ do
                begin
                  StartingStreetNumber := ValuesList[0];
                  StartingStreet := ValuesList[1];
                  EndingStreetNumber := ValuesList[2];
                  EndingStreet := ValuesList[3];

                end;  {with RoadRangePtr^ do}

              RoadRangeList.Add(RoadRangePtr);

            end;  {For I := 0 to (Items.Count - 1) do}

        ValuesList.Free;

        ReportType := ReportTypeRadioGroup.ItemIndex;
        PrintOrder := PrintOrderRadioGroup.ItemIndex;
        PrintSuborder := PrintSuborderRadioGroup.ItemIndex;
        ParcelType := ParcelTypeRadioGroup.ItemIndex;
        LabelType := LabelTypeRadioGroup.ItemIndex;
        LoadFromParcelList := LoadFromParcelListCheckBox.Checked;
        CreateParcelList := CreateParcelListCheckBox.Checked;

          {CHG03011999-1: Allow user to print exemption or SD code on 1st line.}
          {FXX09071999-2: Make the first line printed into a radio group.}
          {CHG07272001-1: Allow for the first line to be parcel ID only.}

        PrintExemptionCode := (FirstLineRadioGroup.ItemIndex = flExemptionCode);
        PrintSDCode := (FirstLineRadioGroup.ItemIndex = flSDCode);;
        PrintParcelID_PropertyClass := (FirstLineRadioGroup.ItemIndex = flPropertyClass);
        PrintParcelIDOnlyOnFirstLine := (FirstLineRadioGroup.ItemIndex = flParcelIDOnly);
        PrintAccountNumber_OldIDOnFirstLine := (FirstLineRadioGroup.ItemIndex = flAccountNumber_OldID);

          {CHG06092000-1: Print new/old labels.  Also option of whether or not to print
                          the swis code on the parcel id.}

        PrintSwisCodeOnParcelIDs := PrintSwisCodeOnParcelIDCheckBox.Checked;
(*        PrintOldAndNewParcelIDs := OldAndNewLabelCheckBox.Checked;

          {CHG07232003-1(2.07g): Option to print old \ new labels that only have old and new ID, legal addr.}

        PrintOldAndNewParcelIDsShortForm := OldAndNewShortFormLabelCheckBox.Checked; *)

          {CHG07192000-1: Allow them to print labels with just parcel IDs.}

(*        PrintParcelIDOnly := PrintParcelIDOnlyCheckBox.Checked;*)

          {CHG11172003-1(2.07k): Add a label format box to accomodate printing parcel id \ legal address labels.}

        LabelFormat := LabelFormatRadioGroup.ItemIndex;

          {CHG11042000-1(MDT): Resident labels.}

        ResidentLabels := ResidentLabelsCheckBox.Checked;

          {CHG04102001-2: Legal address labels.}

        LegalAddressLabels := LegalAddressLabelsCheckBox.Checked;

        try
          SingleParcelFontSize := StrToInt(FontSizeEdit.Text);
        except
          SingleParcelFontSize := 16;
        end;

          {FXX03011999-1: Let user adjust top margin.}

        try
          LaserTopMargin := StrToFloat(LaserTopMarginEdit.Text);
        except
          LaserTopMargin := 0.66;
        end;

        case LabelType of
          lbDotMatrix :
            begin
              NumLinesPerLabel := 12;
              NumLabelsPerPage := 6;
              NumColumnsPerPage := 1;
            end;

          lbLaser5161 :
            begin
              NumLinesPerLabel := 6;
              NumLabelsPerPage := 20;
              NumColumnsPerPage := 2;
            end;

          lbLaser5160 :
            begin
              NumLinesPerLabel := 6;
              NumLabelsPerPage := 30;
              NumColumnsPerPage := 3;
            end;

          lbLaser1Liner :
            begin
              NumLinesPerLabel := 1;
              NumLabelsPerPage := 8;
              NumColumnsPerPage := 1;
            end;

            {CHG12021999-1: Allow print to envelopes.}

          lbEnvelope :
            begin
              NumLinesPerLabel := 6;
              NumLabelsPerPage := 1;
              NumColumnsPerPage := 1;
            end;

        end;  {case LabelType of}

        LabelsCancelled := False;

          {CHG02021999-1: Allow user to either include or exclude selected
                          exemptions or special districts.}
          {CHG07281999-1: Allow user to look exclusively for an exemption or SD.}

        IncludeExemptions := ExemptionInclusionRadioGroup.ItemIndex;
        IncludeSpecialDistricts := SDInclusionRadioGroup.ItemIndex;

          {CHG12182007-1(2.11.6.2)[738]: If not all exemptions are selected and they
                                         selected a firefighter, then ask about renewals.}

        bSuppressNonRenewExemptions := False;

        If _Compare(SelectedExemptionCodes.Count, ExemptionListBox.Items.Count, coNotEqual)
          then
            begin
              bUserSelectedNonRenewExemption := False;

              For I := 0 to (SelectedExemptionCodes.Count - 1) do
                If ExemptionIsVolunteerFirefighter(SelectedExemptionCodes[I])
                  then bUserSelectedNonRenewExemption := True;

              If bUserSelectedNonRenewExemption
                then bSuppressNonRenewExemptions := (MessageDlg('Do you want to print labels for volunteer firefighters \ ambulance personnel that no longer need to renew?' + #13 + #13 +
                                                                '(Yes = Print labels for all exemption recipients,' + #13 +
                                                                ' No  = Print labels for only exemption recipients that need to renew.)' ,
                                                                mtConfirmation, [mbYes, mbNo], 0) = idNo);

            end;  {If _Compare(SelectedExemptionCodes.Count, ExemptionListBox.Items.Count, coNotEqual)}


          {FXX12281999-1: Use the enhanced STAR dialog.}

        If ((SelectedExemptionCodes.Count = 1) and
            (SelectedExemptionCodes[0] = '41834'))
          then
            begin
              EnhancedSTARTypeDialog.ShowModal;
              EnhancedSTARType := EnhancedSTARTypeDialog.EnhancedSTARType;

                {CHG01212004-1(2.08): Add ability to select IVP enrollment status as a choice.}

              IVPEnrollmentStatusType := EnhancedSTARTypeDialog.IVPEnrollmentStatusType;

            end;

        ExtractToExcel := ExtractToExcelCheckBox.Checked;
        ExtractToCommaDelimitedFile := CreateCommaDelimitedExtractCheckBox.Checked;

        try
          FontSizeAdditionalLines := StrToInt(FontSizeAdditionalLinesEdit.Text);
        except
          FontSizeAdditionalLines := 14;
        end;

          {CHG12272004-1(2.8.1.6): Option to bold individual lines of the label.}
          {CHG12302004-2(2.8.1.7): Add option to underline labels.}
          {CHG12302004-3(2.8.1.7): Add option to italicize labels.}

        LoadLinesToPrint(LinesToBold, EditLinesToPrintBold.Text, PrintLabelsBold);
        LoadLinesToPrint(LinesToUnderline, EditLinesToUnderline.Text, PrintLabelsUnderline);
        LoadLinesToPrint(LinesToItalicize, EditLinesToItalicize.Text, PrintLabelsItalicized);

        If PrintDialog.Execute
          then
            begin
              RollSectionList := TList.Create;
              SchoolCodeList := TList.Create;
              SwisCodeList := TList.Create;
              PropertyClassList := TList.Create;
              ExemptionCodeList := TList.Create;
              SDCodeList := TList.Create;

              LoadCodeList(RollSectionList, 'ZRollSectionTbl',
                           'MainCode', 'Description', Quit);
              LoadCodeList(SchoolCodeList, SchoolCodeTableName,
                           'SchoolCode', 'SchoolName', Quit);
              LoadCodeList(SwisCodeList, SwisCodeTableName,
                           'SwisCode', 'MunicipalityName', Quit);
              LoadCodeList(PropertyClassList, 'ZPropClsTbl',
                           'MainCode', 'Description', Quit);
              LoadCodeList(ExemptionCodeList, ExemptionCodesTableName,
                           'EXCode', 'Description', Quit);
              LoadCodeList(SDCodeList, SdistCodeTableName,
                           'SDistCode', 'Description', Quit);

                {Set the index for the sort table.}

              //TempIndex := 'SwisCodeKey+';

              case PrintOrder of
                poParcelID : TempIndex := TempIndex + 'SBLKey';
                poRollSection : TempIndex := TempIndex + 'RollSection';
                poSchoolCode : TempIndex := TempIndex + 'SchoolCode';
                poExemptionCode : TempIndex := TempIndex + 'EXCode';
                poSpecialDistrict : TempIndex := TempIndex + 'SDCode';
                poBankCode : TempIndex := TempIndex + 'BankCode';
                poPropertyClass : TempIndex := TempIndex + 'PropertyClass';

                  {FXX09071999-1: Add print by name and addr.}

                poName : TempIndex := TempIndex + 'Name1';
                poAddress : TempIndex := TempIndex + 'LegalAddr+STR(LegalAddrInt)';

                  {CHG01042005-1(2.8.2.1)[]: Option to print in account # order.}

                poAccountNumber : TempIndex := 'AccountNo';

              end;  {case PrintOrder of}

              If not (PrintOrder in [poParcelID, poName, poAddress, poAccountNumber])
                then
                  case PrintSuborder of
                    psParcelID : TempIndex := TempIndex + '+SBLKey';
                    psAddress : TempIndex := TempIndex + '+LegalAddr+LegalAddrNo';
                    psName : TempIndex := TempIndex + '+Name1';
                    psZipCode : TempIndex := TempIndex + '+ZipCode+ZipPlus4';

                  end;  {case PrintSuborder of}

                {Make sure that the tables are open for the correct assessment year and
                 copy and open the sort file.}

              SortTable.IndexName := '';
              CopyAndOpenSortFile(SortTable, 'Labels',
                                  OrigSortFileName, SortFileName,
                                  True, True, Quit);

              SortTable.AddIndex('LettersSearchIndex',
                                 TempIndex, [ixExpression]);
              SortTable.IndexName := 'LettersSearchIndex';

              If not Quit
                then
                  begin
                    ProcessingType := GetProcessingTypeForTaxRollYear(AssessmentYear);

                    OpenTableForProcessingType(ParcelTable, ParcelTableName, ProcessingType, Quit);
                    OpenTableForProcessingType(AssessmentTable, AssessmentTableName, ProcessingType, Quit);
                    OpenTableForProcessingType(ParcelExemptionTable, ExemptionsTableName, ProcessingType, Quit);
                    OpenTableForProcessingType(ParcelSDTable, SpecialDistrictTableName, ProcessingType, Quit);

                  end;  {If not Quit}

              If not Quit
                then SortFiles;

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

                {FXX07131998-2: Each section has its own report printer components.}

              If (ReportType = rtBoth)
                then MessageDlg('Since you wish to print both labels and reports, the labels' + #13 +
                                'will completely print first.  Then you will have an opportunity' + #13 +
                                'choose the settings for the report section (print to screen or a' + #13 +
                                'particular printer).' + #13 + #13 +
                                'Click OK to start printing the labels.', mtInformation, [mbOK], 0);

              ProgressDialog.Reset;
              ProgressDialog.TotalNumRecords := GetRecordCount(SortTable);
              GlblPreviewPrint := False;

                {Print the Labels.}

              If (ReportType in [rtLabels, rtBoth])
                then
                  begin
                      {CHG12062003-1(2.07k1): Add extract to Excel or comma delimited file to labels.}
                      {FXX03042004-1(2.07l2): If they are saving to comma delimited and Excel, just use the
                                              extract file name they already specified.}

                    If ExtractToExcel
                      then
                        If ExtractToCommaDelimitedFile
                          then SpreadsheetFileName := SaveExportDialog.FileName
                          else
                            begin
                              SpreadsheetFileName := GetPrintFileName(Self.Caption, True);
                              AssignFile(ExtractFile, SpreadsheetFileName);
                              Rewrite(ExtractFile);

                            end;  {If ExtractToExcel}

                    If ExtractToCommaDelimitedFile
                      then
                        begin
                          SaveExportDialog.InitialDir := GlblDrive + ':' + GlblExportDir;

                          If SaveExportDialog.Execute
                            then
                              begin
                                AssignFile(ExtractFile, SaveExportDialog.FileName);
                                Rewrite(ExtractFile);
                              end;

                        end;  {If ExtractToCommaDelimitedFile}

                      {CHG10131998-1: Set the printer settings based on what printer they selected
                                      only - they no longer need to worry about paper or landscape
                                      mode.}

                    AssignPrinterSettings(PrintDialog, LabelPrinter, LabelFiler, [ptBoth], False, Quit);
                    AssignPrinterSettings(PrintDialog, AlignmentPrinter, LabelFiler, [ptBoth], False, Quit);

                       {CHG12021999-1: Allow print to envelopes.}

                    If (LabelType = lbEnvelope)
                      then
                        begin
                          LabelPrinter.SetPaperSize(DMPAPER_ENV_10, 0, 0);
                          LabelFiler.SetPaperSize(DMPAPER_ENV_10, 0, 0);
                          LabelPrinter.Orientation := poLandscape;
                          LabelFiler.Orientation := poLandscape;

                        end;  {If (LabelType = lbEnvelope)}

                    LabelPrinter.Copies := PrintDialog.Copies;
                    LabelFiler.Copies := PrintDialog.Copies;

                    GlblCurrentTabNo := 1;
                    GlblCurrentLinePos := 1;

                    If PrintDialog.PrintToFile
                      then
                        begin
                          NewFileName := GetPrintFileName(Self.Caption, True);
                          LabelFiler.FileName := NewFileName;
                          GlblPreviewPrint := True;

                          try
                            PreviewForm := TPreviewForm.Create(self);
                            PreviewForm.FilePrinter.FileName := NewFileName;
                            PreviewForm.FilePreview.FileName := NewFileName;

                            LabelFiler.Execute;

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
                      else LabelPrinter.Execute;

                    ShowReportDialog('LABELS.LBL', NewFileName, True);

                    If ExtractToExcel
                      then
                        begin
                          CloseFile(ExtractFile);
                          SendTextFileToExcelSpreadsheet(SpreadsheetFileName, True,
                                                         False, '');

                        end;  {If PrintToExcel}

                  end;  {If (ReportType in [rtLabels, rtBoth])}

              If (ReportType in [rtReport, rtBoth])
                then
                  begin
                    Cancelled := False;

                    If ExtractToExcel
                      then
                        If ExtractToCommaDelimitedFile
                          then SpreadsheetFileName := SaveExportDialog.FileName
                          else
                            begin
                              SpreadsheetFileName := GetPrintFileName(Self.Caption, True);
                              AssignFile(ExtractFile, SpreadsheetFileName);
                              Rewrite(ExtractFile);

                              WritelnCommaDelimitedLine(ExtractFile,
                                                        ['Parcel ID',
                                                         'Owner',
                                                         'Legal Address',
                                                         'School',
                                                         'RS',
                                                         'Land Value',
                                                         'Assessed Value',
                                                         'Res %',
                                                         'Prop Cls',
                                                         'Homestead',
                                                         'Bank',
                                                         'Acreage',
                                                         'Ownership']);

                            end;  {If ExtractToExcel}

                    ProgressDialog.Reset;
                    ProgressDialog.TotalNumRecords := GetRecordCount(SortTable);

                      {If they printed Labels, put up the dialog box again since they
                       will need to go to a different printer or choose different paper.}

                    If (ReportType = rtBoth)
                      then
                        begin
                          MessageDlg('The report will now be printed.' + #13 +
                                     'After clicking OK, the print option box will appear and' + #13 +
                                     'let you select different paper or a different printer.',
                                     mtInformation, [mbOK], 0);

                          Cancelled := not PrintDialog.Execute;

                        end;  {If (ReportType = rtBoth)}

                      {Print the report.}

                    If not Cancelled
                      then
                        begin
                          WideCarriage := _Compare(ReportFormat, [rfNormal, rfMailingAddress], coEqual);
                          AssignPrinterSettings(PrintDialog, ReportPrinter, ReportFiler, [ptBoth], WideCarriage, Quit);

                          If (ReportPrinter.Orientation = poLandscape)
                            then
                              begin
                                If (MessageDlg('Do you want to print on letter size paper?',
                                               mtConfirmation, [mbYes, mbNo], 0) = idYes)
                                  then
                                    begin
                                      ReportPrinter.SetPaperSize(dmPaper_Letter, 0, 0);
                                      ReportFiler.SetPaperSize(dmPaper_Letter, 0, 0);
                                      ReportPrinter.Orientation := poLandscape;
                                      ReportFiler.Orientation := poLandscape;
                                      ReportPrinter.ScaleX := 90;
                                      ReportPrinter.ScaleY := 90;
                                      ReportPrinter.SectionLeft := 1.0;
                                      ReportFiler.ScaleX := 90;
                                      ReportFiler.ScaleY := 90;
                                      ReportFiler.SectionLeft := 1.0;
                                      LinesAtBottom := GlblLinesLeftOnRollDotMatrix;
                                    end
                                  else LinesAtBottom := GlblLinesLeftOnRollLaserJet;

                              end
                            else LinesAtBottom := GlblLinesLeftOnRollDotMatrix;

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

                                  PreviewForm.FilePreview.ZoomFactor := 100;

                                  ReportFiler.Execute;

                                  ProgressDialog.StartPrinting(PrintDialog.PrintToFile);

                                  PreviewForm.ShowModal;
                                finally
                                  PreviewForm.Free;
                                end;

                              end
                            else ReportPrinter.Execute;

                        end;  {If not Cancelled}

                    If ExtractToExcel
                      then
                        begin
                          CloseFile(ExtractFile);
                          SendTextFileToExcelSpreadsheet(SpreadsheetFileName, True,
                                                         False, '');

                        end;  {If PrintToExcel}

                  end;  {If (ReportType in [rtReport, rtBoth])}

              SortTable.Close;

              try
                Chdir(GlblDataDir);
                OldDeleteFile(SortFileName);
              except
              end;

                {CHG12062003-1(2.07k1): Add extract to Excel or comma delimited file to labels.}

              If ExtractToCommaDelimitedFile
                then
                  begin
                    CloseFile(ExtractFile);

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

                  end;  {If ExtractToCommaDelimitedFile}

              FreeTList(RollSectionList, SizeOf(CodeRecord));
              FreeTList(SchoolCodeList, SizeOf(CodeRecord));
              FreeTList(SwisCodeList, SizeOf(CodeRecord));
              FreeTList(PropertyClassList, SizeOf(CodeRecord));
              FreeTList(ExemptionCodeList, SizeOf(CodeRecord));
              FreeTList(SDCodeList, SizeOf(CodeRecord));

              ProgressDialog.Finish;

              ResetPrinter(ReportPrinter);
              If CreateParcelList
                then ParcelListDialog.Show;

                {FXX10111999-3: Tell people that printing is starting and
                                done.}

              DisplayPrintingFinishedMessage(PrintDialog.PrintToFile);

            end;  {If PrintDialog.Execute}

        SelectedExemptionCodes.Free;
        SelectedSpecialDistricts.Free;
        SelectedBankCodes.Free;
        SelectedSwisCodes.Free;
        SelectedRollSections.Free;
        SelectedPropertyClasses.Free;
        SelectedSchoolCodes.Free;
        SelectedZipCodes.Free;

        FreeTList(RoadRangeList, SizeOf(RoadRangeRecord));

      end;  {If ValidSelections}

  PrintButton.Enabled := True;
  LinesToBold.Free;
  LinesToUnderline.Free;
  LinesToItalicize.Free;

end;  {PrintButtonClick}

{========================================================================}
Procedure TLabelsForm.PrintSelectionPage(Sender : TObject);

{FXX08041998-1: Add selection page.}

var
  TempStr : String;

begin
  with Sender as TBaseReport do
    begin
      If (LabelType <> lbDotMatrix)
        then NewPage;

      ClearTabs;
      SetTab(0.4, pjLeft, 7.0, 0, BoxLineNone, 0);  {Header}

        {FXX11191999-8: Left of selections wre being cut off.}

      Println('');
      Println(#9 + '  SELECTIONS CHOOSEN:  ');
      Println('');
      Println(#9 + 'Labels Printed = ' + IntToStr(NumLabelsPrinted));
      Println('');

      If LabelsCancelled
        then
          begin
            Println(#9 + '>>> The Label printing was cancelled. <<<');
            Println('');
          end;

      Println(#9 + 'Assessment Year: ' + AssessmentYear);

      case ReportType of
        rtLabels : TempStr := 'Labels Only.';
        rtReport : TempStr := 'Report Only';
        rtBoth : TempStr := 'Labels and Report';
      end;
      Println(#9 + 'Report Type: ' + TempStr);

      case PrintOrder of
        poParcelID : TempStr := 'Parcel ID';
        poRollSection : TempStr := 'Roll Section';
        poSchoolCode : TempStr := 'School Code';
        poExemptionCode : TempStr := 'Exemption Code';
        poSpecialDistrict : TempStr := 'Special District';
        poBankCode : TempStr := 'Bank Code';
        poPropertyClass : TempStr := 'Property Class';

          {FXX09071999-1: Add print by name and addr.}

        poName : TempStr := 'Name';
        poAddress : TempStr := 'Legal Address';
        poAccountNumber : TempStr := 'Account Number';

      end;  {case PrintOrder of}

      case PrintSuborder of
        psParcelID : TempStr := TempStr + ' \ Parcel ID';
        psAddress : TempStr := TempStr + ' \ Address';
        psName : TempStr := TempStr + ' \ Name';
        psZipCode : TempStr := TempStr + ' \ Zip Code';
      end;
      Println(#9 + 'Print Order: ' + TempStr);

      case ParcelType of
        ptAllParcels : TempStr := 'All Parcels.';
        ptComInvParcels : TempStr := 'Parcels with Com Inv';
        ptResInvParcels : TempStr := 'Parcels with Res Inv';
      end;
      Println(#9 + 'Parcel Type : ' + TempStr);

      If PrintBySwisCode
        then Println(#9 + 'Print by swis code');

      If PrintDuplicates
        then Println(#9 + 'Print Duplicates.');

      If PrintAllExemptions
        then Println(#9 + 'Print all exemptions.')
        else PrintSelectedList(Sender, SelectedExemptionCodes, 'exemptions');

      case IncludeExemptions of
        stHasCode : Println(#9 + '    Parcels that have the listed exemptions will be printed.');
        stDoesNotHaveCode : Println(#9 + '    Parcels that do not have any of the listed exemptions will be printed.');
        stOnlyHasCode : Println(#9 + '    Parcels that have only the selected exemption will be printed.');
      end;

      If PrintAllSpecialDistricts
        then Println(#9 + 'Print all special districts.')
        else PrintSelectedList(Sender, SelectedSpecialDistricts, 'special districts');

      case IncludeSpecialDistricts of
        stHasCode : Println(#9 + '    Parcels that have the listed special districts will be printed.');
        stDoesNotHaveCode : Println(#9 + '    Parcels that do not have any of the listed special ' +
                                         'districts will be printed.');
        stOnlyHasCode : Println(#9 + '    Parcels that only have the selected special district will be printed.');
      end;

      If PrintAllBankCodes
        then Println(#9 + 'Print all bank codes.')
        else PrintSelectedList(Sender, SelectedBankCodes, 'bank codes');

        {CHG02252004-3(2.08): Allow them to select zip codes.}

      If (SelectedZipCodes.Count = 0)
        then Println(#9 + 'Print all zip codes.')
        else PrintSelectedList(Sender, SelectedZipCodes, 'zip codes');

      If PrintAllSchoolCodes
        then Println(#9 + 'Print all school codes.')
        else PrintSelectedList(Sender, SelectedSchoolCodes, 'school codes');

      If PrintAllSwisCodes
        then Println(#9 + 'Print all swis codes.')
        else PrintSelectedList(Sender, SelectedSwisCodes, 'swis codes');

      If PrintAllRollSections
        then Println(#9 + 'Print all roll sections.')
        else PrintSelectedList(Sender, SelectedRollSections, 'roll sections');

      If PrintAllPropertyClasses
        then Println(#9 + 'Print all property classes.')
        else PrintSelectedList(Sender, SelectedPropertyClasses, 'property classes');

      If ((SelectedExemptionCodes.Count = 1) and
          (SelectedExemptionCodes[0] = '41834'))
        then
          case EnhancedSTARType of
            enSeniorSTAROnly : Println(#9 + 'Print parcels with senior STAR but no senior exemption.');
            enWithSeniorandSTARExemption : Println(#9 + 'Print parcels with both senior STAR and senior exemptions.');
          end;

    end;  {with Sender as TBaseReport do}

end;  {PrintSelectionPage}

{================================================================================}
Procedure InitTotalsRec(var TotalsRec : TotalsRecord);

begin
  with TotalsRec do
    begin
      LandVal := 0;
      AssessedVal := 0;
      Acres := 0;
      Count := 0;
    end;  {with TotalsRec do}

end;  {InitTotalsRec}

{================================================================================}
Procedure UpdateTotals(var TotalsRec : TotalsRecord;
                           ParcelTable,
                           AssessmentTable : TTable);

begin
  with TotalsRec do
    begin
      LandVal := LandVal + AssessmentTable.FieldByName('LandAssessedVal').AsFloat;
      AssessedVal := AssessedVal + AssessmentTable.FieldByName('TotalAssessedVal').AsFloat;
      Acres := Acres + ParcelTable.FieldByName('Acreage').AsFloat;
      Count := Count + 1;
    end;  {with TotalsRec do}

end;  {UpdateTotals}

{================================================================================}
Procedure PrintTotals(Sender : TObject;
                      TotalsRec : TotalsRecord;
                      Header : String);

begin
  with Sender as TBaseReport, TotalsRec do
    begin
      ClearTabs;
      SetTab(0.2, pjLeft, 4.5, 0, BoxLineNone, 0);  {Header}
      SetTab(4.9, pjLeft, 7.0, 0, BoxLineNone, 0);  {Count}
      SetTab(7.9, pjRight, 1.0, 0, BoxLineNone, 0);  {Land value}
      SetTab(9.0, pjRight, 1.2, 0, BoxLineNone, 0);  {Assessed value}
      SetTab(12.2, pjRight, 0.8, 0, BoxLineNone, 0);  {Acres}

      Println(#9 + 'TOTALS FOR ' + Trim(Header) + ':' +
              #9 + 'COUNT: ' + IntToStr(Count) +
              #9 + FormatFloat(CurrencyDisplayNoDollarSign, LandVal) +
              #9 + FormatFloat(CurrencyDisplayNoDollarSign, AssessedVal) +
              #9 + FormatFloat(DecimalDisplay_BlankZero, Acres));

    end;  {with Sender as TBaseReport, TotalsRec do}

end;  {PrintTotals}

{================================================================================}
Procedure TLabelsForm.ReportPrintHeader(Sender: TObject);

var
  (*TempSwisCode, *) ReportTypeString : String;

begin
  with Sender as TBaseReport do
    begin
      SectionTop := 0.25;
      SectionLeft := 0.5;
      SectionRight := PageWidth - 0.5;
      SetFont('Times New Roman',8);
      PrintHeader('Page: ' + IntToStr(CurrentPage), pjRight);
      PrintHeader('Date: ' + DateToStr(Date) + '  Time: ' + TimeToStr(Now), pjLeft);

      SectionTop := 0.5;

      SetFont('Times New Roman',14);
      Bold := True;
      Home;
      Println('');
      PrintCenter('Label Print Report', (PageWidth / 2));

      case PrintOrder of
        poParcelID : ReportTypeString := 'Parcel ID';
        poRollSection : ReportTypeString := 'Roll Section';
        poSchoolCode :  ReportTypeString := 'School District';
        poExemptionCode :  ReportTypeString := 'Exemption Code';
        poSpecialDistrict :  ReportTypeString := 'Special District';
        poBankCode :  ReportTypeString := 'Bank Code';
        poPropertyClass : ReportTypeString := 'Property Class';
        poName : ReportTypeString := 'Name';
        poAddress : ReportTypeString := 'Address';
        poAccountNumber : ReportTypeString := 'Account Number';

      end;  {case PrintOrder of}

      If (PrintOrder in [poRollSection, poPropertyClass])
        then
          case PrintSuborder of
            psParcelID : ReportTypeString := ReportTypeString + '\Parcel ID';
            psAddress : ReportTypeString := ReportTypeString + '\Address';
            psName : ReportTypeString := ReportTypeString + '\Name';
            psZipCode : ReportTypeString := ReportTypeString + '\Zip Code';

          end;  {case PrintSuborder of}

      ReportTypeString := ReportTypeString + ' Order';

      Println('');
      SetFont('Times New Roman',12);
      Bold := True;
      PrintCenter(ReportTypeString, (PageWidth / 2));
      Bold := False;
      Println('');

      (*If PrintBySwisCode
        then TempSwisCode := LastSwisCode
        else TempSwisCode := Take(4, LastSwisCode); *)

      SetFont('Times New Roman', 10);
      Println('');

    end;  {with Sender as TBaseReport do}

    {Set the tabs for the header.}

  with Sender as TBaseReport do
    case ReportFormat of
      rfNormal :
        begin
          ClearTabs;
          Bold := True;
          SetTab(0.2, pjCenter, 1.5, 0, BoxLineNone, 0);  {Parcel ID}
          SetTab(1.8, pjCenter, 2.0, 0, BoxLineNone, 0);  {Name}
          SetTab(3.9, pjCenter, 2.0, 0, BoxLineNone, 0);  {Address}
          SetTab(6.0, pjCenter, 0.6, 0, BoxLineNone, 0);  {School}
          SetTab(6.7, pjCenter, 0.1, 0, BoxLineNone, 0);  {RS}
          SetTab(6.9, pjCenter, 0.8, 0, BoxLineNone, 0);  {Land value}
          SetTab(7.8, pjCenter, 1.0, 0, BoxLineNone, 0);  {Assessed value}
          SetTab(8.9, pjCenter, 0.3, 0, BoxLineNone, 0);  {Res %}
          SetTab(9.3, pjCenter, 0.3, 0, BoxLineNone, 0);  {Prop class}
          SetTab(9.7, pjCenter, 0.1, 0, BoxLineNone, 0);  {HC}
          SetTab(9.9, pjCenter, 0.7, 0, BoxLineNone, 0);  {Bank}
          SetTab(10.7, pjCenter, 0.8, 0, BoxLineNone, 0);  {Acres}
          SetTab(11.6, pjCenter, 0.1, 0, BoxLineNone, 0);  {Ownership code}

          Println(#9 + #9 + #9 +
                  #9 + 'School' +
                  #9 + 'R' +
                  #9 + 'Land' +
                  #9 + 'Assessed' +
                  #9 + 'Res' +
                  #9 + 'Prp' +
                  #9 + 'H' +
                  #9 + 'Bank' +
                  #9 +
                  #9 + 'O');

          ClearTabs;
          SetTab(0.2, pjCenter, 1.5, 0, BoxLineBottom, 0);  {Parcel ID}
          SetTab(1.8, pjCenter, 2.0, 0, BoxLineBottom, 0);  {Name}
          SetTab(3.9, pjCenter, 2.0, 0, BoxLineBottom, 0);  {Address}
          SetTab(6.0, pjCenter, 0.6, 0, BoxLineBottom, 0);  {School}
          SetTab(6.7, pjCenter, 0.1, 0, BoxLineBottom, 0);  {RS}
          SetTab(6.9, pjCenter, 0.8, 0, BoxLineBottom, 0);  {Land value}
          SetTab(7.8, pjCenter, 1.0, 0, BoxLineBottom, 0);  {Assessed value}
          SetTab(8.9, pjCenter, 0.3, 0, BoxLineBottom, 0);  {Res %}
          SetTab(9.3, pjCenter, 0.3, 0, BoxLineBottom, 0);  {Prop class}
          SetTab(9.7, pjCenter, 0.1, 0, BoxLineBottom, 0);  {HC}
          SetTab(9.9, pjCenter, 0.7, 0, BoxLineBottom, 0);  {Bank}
          SetTab(10.7, pjCenter, 0.8, 0, BoxLineBottom, 0);  {Acres}
          SetTab(11.6, pjCenter, 0.1, 0, BoxLineBottom, 0);  {Ownership code}

          Println(#9 + 'Parcel ID' +
                  #9 + 'Owner Name' +
                  #9 + 'Address' +
                  #9 + 'Code' +
                  #9 + 'S' +
                  #9 + 'Value' +
                  #9 + 'Value' +
                  #9 + ' %' +
                  #9 + 'Cls' +
                  #9 + 'C' +
                  #9 + 'Code' +
                  #9 + 'Acres' +
                  #9 + 'C');

          Bold := False;

          ClearTabs;
          SetTab(0.2, pjLeft, 1.5, 0, BoxLineNone, 0);  {Parcel ID}
          SetTab(1.8, pjLeft, 2.0, 0, BoxLineNone, 0);  {Name}
          SetTab(3.9, pjLeft, 2.0, 0, BoxLineNone, 0);  {Address}
          SetTab(6.0, pjLeft, 0.6, 0, BoxLineNone, 0);  {School}
          SetTab(6.7, pjLeft, 0.1, 0, BoxLineNone, 0);  {RS}
          SetTab(6.9, pjRight, 0.8, 0, BoxLineNone, 0);  {Land value}
          SetTab(7.8, pjRight, 1.0, 0, BoxLineNone, 0);  {Assessed value}
          SetTab(8.9, pjRight, 0.3, 0, BoxLineNone, 0);  {Res %}
          SetTab(9.3, pjLeft, 0.3, 0, BoxLineNone, 0);  {Prop class}
          SetTab(9.7, pjLeft, 0.1, 0, BoxLineNone, 0);  {HC}
          SetTab(9.9, pjLeft, 0.7, 0, BoxLineNone, 0);  {Bank}
          SetTab(10.7, pjRight, 0.8, 0, BoxLineNone, 0);  {Acres}
          SetTab(11.6, pjLeft, 0.1, 0, BoxLineNone, 0);  {Ownership code}

        end;  {rfNormal}

      rfAccountNumber_ParcelID_Address :
        begin
          Bold := True;
          ClearTabs;
          SetTab(0.4, pjCenter, 1.1, 0, BoxLineBottom, 0);  {Acct #}
          SetTab(1.6, pjCenter, 2.0, 0, BoxLineBottom, 0);  {Parcel ID}
          SetTab(3.7, pjCenter, 2.5, 0, BoxLineBottom, 0);  {Address}

          Println(#9 + 'Account #' +
                  #9 + 'Parcel ID' +
                  #9 + 'Legal Address');

          Bold := False;

          ClearTabs;
          SetTab(0.4, pjLeft, 1.1, 0, BoxLineNone, 0);  {Acct #}
          SetTab(1.6, pjLeft, 2.0, 0, BoxLineNone, 0);  {Parcel ID}
          SetTab(3.7, pjLeft, 2.5, 0, BoxLineNone, 0);  {Address}

        end;  {rfAccountNumber_ParcelID_Address}

      rfMailingAddress :
        begin
          Bold := True;
          ClearTabs;
          SetTab(0.3, pjCenter, 1.4, 0, BoxLineBottom, 0);  {Parcel ID}
          SetTab(1.8, pjCenter, 2.5, 0, BoxLineBottom, 0);  {Owner}
          SetTab(4.4, pjCenter, 2.5, 0, BoxLineBottom, 0);  {Mail addr 1}
          SetTab(7.0, pjCenter, 2.5, 0, BoxLineBottom, 0);  {Mail addr 2}
          SetTab(9.6, pjCenter, 2.5, 0, BoxLineBottom, 0);  {Mail addr 3}

          Println(#9 + 'Parcel ID' +
                  #9 + 'Owner' +
                  #9 + 'Mailing Address' +
                  #9 + 'Mailing Address' +
                  #9 + 'Mailing Address');

          Bold := False;

          ClearTabs;
          SetTab(0.3, pjLeft, 1.4, 0, BoxLineNone, 0);  {Parcel ID}
          SetTab(1.8, pjLeft, 2.5, 0, BoxLineNone, 0);  {Owner}
          SetTab(4.4, pjLeft, 2.5, 0, BoxLineNone, 0);  {Mail addr 1}
          SetTab(7.0, pjLeft, 2.5, 0, BoxLineNone, 0);  {Mail addr 2}
          SetTab(9.6, pjLeft, 2.5, 0, BoxLineNone, 0);  {Mail addr 3}

        end;  {rfMailingAddress}

    end;  {case ReportFormat of}

end;  {ReportPrinterPrintHeader}

{================================================================================}
Procedure TLabelsForm.ReportPrint(Sender: TObject);

var
  GroupChanged,
  FirstTimeThrough, Done, SwisCodesDifferent : Boolean;
  ParcelsPrinted : LongInt;
  SwisSBLKey, Header : String;
  GroupTotalsRec, SwisTotalsRec, OverallTotalsRec : TotalsRecord;
  NameAddressArray : NameAddrArray;

begin
  FirstTimeThrough := True;
  Done := False;
  ParcelsPrinted := 0;

  SortTable.First;
  LastSwisCode := SortTable.FieldByName('SwisCode').Text;

  ProgressDialog.UserLabelCaption := 'Printing report.';
  LastSchoolCode := SortTable.FieldByName('SchoolCode').Text;
  LastRollSection := SortTable.FieldByName('RollSection').Text;
  LastExemptionCode := SortTable.FieldByName('EXCode').Text;
  LastSDCode := SortTable.FieldByName('SDCode').Text;
  LastBankCode := SortTable.FieldByName('BankCode').Text;
  LastPropertyClass := SortTable.FieldByName('PropertyClass').Text;

  InitTotalsRec(GroupTotalsRec);
  InitTotalsRec(SwisTotalsRec);
  InitTotalsRec(OverallTotalsRec);

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else SortTable.Next;

    If SortTable.EOF
      then Done := True;

    Application.ProcessMessages;
    ProgressDialog.Update(Self, 'Parcels Printed = ' + IntToStr(ParcelsPrinted));

    SwisSBLKey := SortTable.FieldByName('SwisCode').Text +
                  SortTable.FieldByName('SBLKey').Text;
    ParcelsPrinted := ParcelsPrinted + 1;

    with Sender as TBaseReport do
      begin
        SwisCodesDifferent := (LastSwisCode <> SortTable.FieldByName('SwisCode').Text);
        GroupChanged := False;

        with SortTable do
          case PrintOrder of
            poRollSection : If ((LastRollSection <> FieldByName('RollSection').Text) or
                                Done)
                              then
                                begin
                                  Header := 'RS ' + LastRollSection +  ' (' +
                                            Trim(GetDescriptionFromList(LastRollSection, RollSectionList)) + ')';
                                  GroupChanged := True;
                                end;

            poSchoolCode :  If ((LastSchoolCode <> FieldByName('SchoolCode').Text) or
                                Done)
                              then
                                begin
                                  Header := 'SCHOOL ' + LastSchoolCode + ' (' +
                                            Trim(GetDescriptionFromList(LastSchoolCode, SchoolCodeList)) + ')';

                                  GroupChanged := True;
                                end;

            poExemptionCode :  If ((LastExemptionCode <> FieldByName('EXCode').Text) or
                                   Done)
                                 then
                                   begin
                                     Header := 'EXEMPTION ' + LastExemptionCode + ' (' +
                                               Trim(GetDescriptionFromList(LastExemptionCode, ExemptionCodeList)) + ')';
                                     GroupChanged := True;
                                   end;

            poSpecialDistrict :  If ((LastSDCode <> FieldByName('SDCode').Text) or
                                     Done)
                                   then
                                     begin
                                       Header := 'SD CODE ' + LastSDCode + ' (' +
                                                 Trim(GetDescriptionFromList(LastSDCode, SDCodeList)) + ')';
                                       GroupChanged := True;
                                     end;

            poBankCode :  If ((LastBankCode <> FieldByName('BankCode').Text) or
                              Done)
                            then
                              begin
                                Header := 'BANK ' + LastBankCode;
                                GroupChanged := True;
                              end;

            poPropertyClass :  If ((LastPropertyClass <> FieldByName('PropertyClass').Text) or
                                   Done)
                                 then
                                   begin
                                     Header := 'PROP CLS ' + LastPropertyClass + ' (' +
                                               Trim(GetDescriptionFromList(LastPropertyClass, PropertyClassList)) + ')';
                                     GroupChanged := True;
                                   end;

          end;  {case PrintSuborder of}

           {Print group totals, but never for by parcel id.}

        If ((PrintOrder <> poParcelID) and
            GroupChanged)
          then
            begin
              Println('');
              PrintTotals(Sender, GroupTotalsRec, Header);
              InitTotalsRec(GroupTotalsRec);

                {Go to a new page if not going to print swis totals.}

              If (not ((SwisCodesDifferent and
                        PrintBySwisCode) or
                       Done))
                then NewPage;

            end;  {If (GroupChanged or Done)}

          {Print swis totals.}

        If (PrintBySwisCode and
            (SwisCodesDifferent or
             Done))
          then
            begin
              Println('');
              PrintTotals(Sender, SwisTotalsRec,
                          'SWIS ' + LastSwisCode + ' (' +
                          Trim(GetDescriptionFromList(LastSwisCode, SwisCodeList)) + ')');
              InitTotalsRec(SwisTotalsRec);

              If not Done
                then NewPage;

            end;  {If ((SwisCodeDifferent and ...}

        If (LinesLeft < 4)
          then NewPage;

          {Update the break codes.}

        LastSwisCode := SortTable.FieldByName('SwisCode').Text;
        LastSchoolCode := SortTable.FieldByName('SchoolCode').Text;
        LastRollSection := SortTable.FieldByName('RollSection').Text;
        LastExemptionCode := SortTable.FieldByName('EXCode').Text;
        LastSDCode := SortTable.FieldByName('SDCode').Text;
        LastBankCode := SortTable.FieldByName('BankCode').Text;
        LastPropertyClass := SortTable.FieldByName('PropertyClass').Text;

        _Locate(ParcelTable, [AssessmentYear, SwisSBLKey], '', [loParseSwisSBLKey]);
        _Locate(AssessmentTable, [AssessmentYear, SwisSBLKey], '', []);

        If not Done
          then
            begin
              with ParcelTable do
                case ReportFormat of
                  rfNormal :
                    begin
                      Println(#9 + ConvertSwisSBLToDashDot(SwisSBLKey) +
                              #9 + Take(19, FieldByName('Name1').Text) +
                              #9 + Take(19, GetLegalAddressFromTable(SortTable)) +
                              #9 + FieldByName('SchoolCode').Text +
                              #9 + FieldByName('RollSection').Text +
                              #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                                               AssessmentTable.FieldByName('LandAssessedVal').AsFloat) +
                              #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                                               AssessmentTable.FieldByName('TotalAssessedVal').AsFloat) +
                              #9 + FormatFloat(CurrencyEditDisplay,
                                               FieldByName('ResidentialPercent').AsFloat) +
                              #9 + FieldByName('PropertyClassCode').Text +
                              #9 + FieldByName('HomesteadCode').Text +
                              #9 + FieldByName('BankCode').Text +
                              #9 + FormatFloat(DecimalDisplay_BlankZero,
                                               FieldByName('Acreage').AsFloat) +
                              #9 + FieldByName('OwnershipCode').Text);

                        {FXX10082009-1(2.20.1.19)[I6549]: Running in report mode gives an I\O 103.}

                      If ExtractToExcel
                        then WritelnCommaDelimitedLine(ExtractFile,
                                                       [ConvertSwisSBLToDashDot(SwisSBLKey),
                                                        FieldByName('Name1').AsString,
                                                        GetLegalAddressFromTable(SortTable),
                                                        FieldByName('SchoolCode').AsString,
                                                        FieldByName('RollSection').AsString,
                                                        AssessmentTable.FieldByName('LandAssessedVal').AsFloat,
                                                        AssessmentTable.FieldByName('TotalAssessedVal').AsFloat,
                                                        FieldByName('ResidentialPercent').AsFloat,
                                                        FieldByName('PropertyClassCode').AsString,
                                                        FieldByName('HomesteadCode').AsString,
                                                        FieldByName('BankCode').AsString,
                                                        FormatFloat(DecimalDisplay_BlankZero,
                                                                    FieldByName('Acreage').AsFloat),
                                                        FieldByName('OwnershipCode').AsString]);

                    end;  {rfNormal}

                  rfAccountNumber_ParcelID_Address :
                    Println(#9 + FieldByName('AccountNo').Text +
                            #9 + ConvertSwisSBLToDashDot(SwisSBLKey) +
                            #9 + GetLegalAddressFromTable(SortTable));

                  rfMailingAddress :
                    begin
                      GetNameAddress(ParcelTable, NameAddressArray);

                      Println(#9 + ConvertSwisSBLToDashDot(SwisSBLKey) +
                              #9 + NameAddressArray[1] +
                              #9 + NameAddressArray[2] +
                              #9 + NameAddressArray[3] +
                              #9 + NameAddressArray[4]);

                      If (_Compare(NameAddressArray[5], coNotBlank) or
                          _Compare(NameAddressArray[6], coNotBlank))
                        then
                          begin
                            Println(#9 + #9 +
                                    #9 + NameAddressArray[5] +
                                    #9 + NameAddressArray[6]);

                            Println('');

                          end;  {If (_Compare(NameAddressArray[4], coNotBlank) or ...}

                    end;  {rfMailingAddress}

                end;  {case ReportFormat of}

              UpdateTotals(GroupTotalsRec, ParcelTable, AssessmentTable);
              UpdateTotals(SwisTotalsRec, ParcelTable, AssessmentTable);
              UpdateTotals(OverallTotalsRec, ParcelTable, AssessmentTable);

            end;  {If not Done}

      end;  {with Sender as TBaseReport do}

    LabelsCancelled := ProgressDialog.Cancelled;

  until (Done or LabelsCancelled);

    {Print final totals.}
    {FXX02052006-1(2.9.5.4): Don't print the totals for the mailing address format.}

  If _Compare(ReportFormat, rfMailingAddress, coNotEqual)
    then
      with Sender as TBaseReport do
        begin
          Println('');
          PrintTotals(Sender, OverallTotalsRec, Take(4, SortTable.FieldByname('SwisCode').Text));
        end;

end;  {ReportPrint}

{================================================================================}
Procedure TLabelsForm.LabelPrintHeader(Sender: TObject);

begin
  PrintLabelHeaderOld(Sender, LabelType,
                      LaserTopMargin, PrintLabelsBold);

end;  {LabelPrintHeader}

{========================================================}
Procedure TLabelsForm.PrintAlignment(Sender : TObject);

{Print 2 alignment labels until they are satisfied or quit.}

var
  NAddrArray : NameAddrArray;
  PNAddrArray : PNameAddrArray;
  I : Integer;
  LabelList : TList;

begin
(*  If (MessageDlg('Do you want to print 2 alignment labels?',
                 mtConfirmation, [mbYes, mbNo], 0) = idYes)
    then
      repeat *)

        LabelList := TList.Create;

        For I := 1 to 6 do
          NAddrArray[I] := ConstStr('X', 30);

        For I := 1 to 4 do
          begin
            New(PNAddrArray);
            PNAddrArray^ := NAddrArray;
            LabelList.Add(PNAddrArray);
          end;

        PrintLabelsOld(Sender, LabelList, LabelType,
                       False, PrintLabelsBold,
                       NumLinesPerLabel, NumLabelsPerPage,
                       NumColumnsPerPage, SingleParcelFontSize,
                       FontSizeAdditionalLines, nil,
                       PrintLabelsUnderline, nil,
                       PrintLabelsItalicized, nil);

        FreeTList(LabelList, SizeOf(NameAddrArray));

(*        with Sender as TBaseReport do
          Escape(Printer.Handle, FlushOutput, 0, nil, nil);

        ReturnCode := MessageDlg('Do you want to print more alignment labels?' + #13 +
                                 '(To cancel label printing completely, click Cancel.)',
                                 mtConfirmation, [mbYes, mbNo, mbCancel], 0);

        case ReturnCode of
          idNo : Done := True;
          idCancel : LabelsCancelled := True;
        end;

      until (Done or LabelsCancelled); *)

end;  {PrintAlignment}

{========================================================}
Procedure TLabelsForm.PrintExemptionOrSDCode(    SwisSBLKey : String;
                                             var NAddrArray : NameAddrArray);

var
  I : Integer;
  TempStr : String;

begin
   {CHG06092000-1: Print new/old labels.  Also option of whether or not to print
                        the swis code on the parcel id.}

  If PrintSwisCodeOnParcelIDs
    then TempStr := ConvertSwisSBLToDashDot(SwisSBLKey)
    else TempStr := ConvertSBLOnlyToDashDot(Copy(SwisSBLKey, 7, 20));

    {CHG03011999-1: Allow user to print exemption or SD code on 1st line.}
    {FXX06272007-1(2.11.1.39)[D870]: First line Parcel ID \ EX code should not include property class.}

  If PrintExemptionCode
    then
      begin
        For I := 6 downto 2 do
          NAddrArray[I] := NAddrArray[I-1];

        NAddrArray[1] := SortTable.FieldByName('EXCode').Text + '  ' +
                         TempStr;
      end;

  If PrintSDCode
    then
      begin
        For I := 6 downto 2 do
          NAddrArray[I] := NAddrArray[I-1];

        NAddrArray[1] := SortTable.FieldByName('SDCode').Text + '  ' +
                         TempStr + '  ' +
                         SortTable.FieldByName('PropertyClass').Text;
      end;

end;  {PrintExemptionOrSDCode}

{========================================================}
Procedure TLabelsForm.LabelPrinterPrint(Sender: TObject);

var
  PrintParcelIDOnly, FirstTimeThrough, Done,
  Name2FilledIn, BlankLabel : Boolean;
  SwisSBLKey, TempStr : String;
  PSwisSBLKey : PSwisSBLKeyType;
  I, J, StartIndex : Integer;
  LabelList : TList;
  PNAddrArray : PNameAddrArray;
  SBLRec : SBLRecord;

begin
    {CHG10271999-1: Make labels more flexible.}

  LabelsCancelled := False;
  LabelList := TList.Create;
  If (LabelType = lbDotMatrix)
    then PrintAlignment(Sender);

  FirstTimeThrough := True;
  Done := False;
  NumLabelsPrinted := 0;

    {First go through and make a list of all the labels.}

  SortTable.First;
  ProgressDialog.UserLabelCaption := 'Printing Labels.';

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else SortTable.Next;

    If SortTable.EOF
      then Done := True;

    If not Done
      then
        begin
          with SortTable do
            SwisSBLKey := FieldByName('SwisCode').Text + FieldByName('SBLKey').Text;

          SBLRec := ExtractSwisSBLFromSwisSBLKey(SwisSBLKey);

          with SBLRec do
            FindKeyOld(ParcelTable,
                       ['TaxRollYr', 'SwisCode', 'Section',
                        'Subsection', 'Block', 'Lot', 'Sublot',
                        'Suffix'],
                       [AssessmentYear, SwisCode, Section, Subsection,
                        Block, Lot, Sublot, Suffix]);

            {CHG03261999-1: Let them print parcel ID and class on the first line.}
            {CHG10271999-1: Make labels more flexible.}
            {CHG06092000-1: Print new/old labels.  Also option of whether or not to print
                           the swis code on the parcel id.}

          If (LabelType = lbLaser1Liner)
            then
              begin
                New(PSwisSBLKey);
                If PrintSwisCodeOnParcelIDs
                  then PSwisSBLKey^ := ConvertSwisSBLToDashDot(SwisSBLKey)
                  else PSwisSBLKey^ := ConvertSBLOnlyToDashDot(Copy(SwisSBLKey, 7, 20));

                LabelList.Add(PSwisSBLKey);
              end
            else
              begin
                New(PNAddrArray);
                GetNameAddress(ParcelTable, PNAddrArray^);

                  {CHG11042000-1(MDT): Resident labels.}

                If ResidentLabels
                  then
                    begin
                      Name2FilledIn := (Deblank(ParcelTable.FieldByName('Name2').Text) <> '');

                      PNAddrArray^[1] := 'RESIDENT';

                        {If name 2 is filled in then move everything from
                         the 3rd line up one since 'RESIDENT' replaces the
                         name.  So, we are assuming the 2nd line is name
                         info and not address.}

                      If Name2FilledIn
                        then
                          begin
                            For I := 3 to 6 do
                              PNAddrArray^[I-1] := PNAddrArray^[I];

                            PNAddrArray^[6] := '';

                          end;  {If Name2FilledIn}

                    end;  {If ResidentLabels}

                  {CHG04102001-2: Legal address labels.}

                If LegalAddressLabels
                  then
                    begin
                        {FXX07242003-1(2.07g): If they are printing Resident and Legal Address labels
                                               and Name 2 was filled in, it can sometimes cause 2
                                               addresses to appear (the mailing street and the legal
                                               address). If this is the case, Name2Filled in should be False
                                               here since the second name was taken care of above.}

                      Name2FilledIn := ((Deblank(ParcelTable.FieldByName('Name2').Text) <> '') and
                                        (not (ResidentLabels and LegalAddressLabels)));

                      If Name2FilledIn
                        then StartIndex := 3
                        else StartIndex := 2;

                        {Clear out everything after the name.}

                      For I := StartIndex to 6 do
                        PNAddrArray^[I] := '';

                      PNAddrArray^[StartIndex] := GetLegalAddressFromTable(ParcelTable);

                        {CHG12192008-1: Legal city \ zip.}

                      If (ParcelTable.FindField('LegalCity') = nil)
                        then
                          begin
                            FindKeyOld(SwisCodeTable, ['SwisCode'], [ParcelTable.FieldByName('SwisCode').Text]);

                            with SwisCodeTable do
                              PNAddrArray^[StartIndex + 1] := Trim(FieldByName('MunicipalityName').Text) +
                                                              ', NY ' +
                                                              FieldByName('ZipCode').Text;
                          end
                        else PNAddrArray^[StartIndex + 1] := Trim(ParcelTable.FieldByName('LegalCity').AsString) +
                                                             ', NY ' +
                                                             ParcelTable.FieldByName('LegalZip').AsString;

                    end;  {If LegalAddressLabels}

                  {CHG07192000-1: Allow them to print labels with just parcel IDs.}
                  {CHG11172003-1(2.07k): Add a label format box to accomodate printing parcel id \ legal address labels.}

                case LabelFormat of
                  lfNormal :
                    begin
                      PrintExemptionOrSDCode(SwisSBLKey, PNAddrArray^);

                        {FXX06182002-1: Had wrong name for property class code in sort table.}

                      If PrintParcelID_PropertyClass
                        then PrintLabelParcelID_Class(SwisSBLKey, PNAddrArray^, True,
                                                      PrintSwisCodeOnParcelIDs,
                                                      SortTable.FieldByName('PropertyClass').Text);

                        {CHG07272001-1: Allow for the first line to be parcel ID only.}

                      If PrintParcelIDOnlyOnFirstLine
                        then PrintLabelParcelID_Class(SwisSBLKey, PNAddrArray^, False,
                                                      PrintSwisCodeOnParcelIDs,
                                                      SortTable.FieldByName('PropertyClass').Text);

                      If PrintAccountNumber_OldIDOnFirstLine
                        then
                          with ParcelTable do
                            PrintLabelAccountNumber_OldID(PNAddrArray^,
                                                          FieldByName('AccountNo').Text,
                                                          FieldByName('RemapOldSBL').Text);

                    end;  {lfNormal}

                  lfParcelIDOnly :
                    begin
                      For I := 1 to 6 do
                        PNAddrArray^[I] := '';

                      If PrintSwisCodeOnParcelIDs
                        then PNAddrArray^[3] := ConvertSwisSBLToDashDot(SwisSBLKey)
                        else PNAddrArray^[3] := ConvertSBLOnlyToDashDot(Copy(SwisSBLKey, 7, 20));

                   end;  {lfParcelIDOnly}

                  lfParcelID_LegalAddress :
                    begin
                      For I := 1 to 6 do
                        PNAddrArray^[I] := '';

                      If PrintSwisCodeOnParcelIDs
                        then PNAddrArray^[1] := ConvertSwisSBLToDashDot(SwisSBLKey)
                        else PNAddrArray^[1] := ConvertSBLOnlyToDashDot(Copy(SwisSBLKey, 7, 20));

                      PNAddrArray^[2] := GetLegalAddressFromTable(ParcelTable);

                    end;  {lfParcelID_LegalAddress}

                  lfParcelID_OldID_LegalAddress :
                    begin
                      For I := 1 to 6 do
                        PNAddrArray^[I] := '';

                      If PrintSwisCodeOnParcelIDs
                        then PNAddrArray^[1] := ConvertSwisSBLToDashDot(SwisSBLKey)
                        else PNAddrArray^[1] := ConvertSBLOnlyToDashDot(Copy(SwisSBLKey, 7, 20));

                      TempStr := ConvertSwisSBLToOldDashDotNoSwis(ParcelTable.FieldByName('RemapOldSBL').Text,
                                                                  AssessmentYearControlTable);

                      If PrintSwisCodeOnParcelIDs
                        then TempStr := Copy(SwisSBLKey, 5, 2) + '/' + TempStr;

                      PNAddrArray^[2] := 'Old: ' + TempStr;
                      PNAddrArray^[3] := GetLegalAddressFromTable(ParcelTable);

                    end;  {lfParcelID_OldID_LegalAddress}

                  lfParcelID_OldID :
                    PrintLabelOldAndNewParcelID(SwisSBLKey, PNAddrArray^,
                                                ParcelTable,
                                                AssessmentYearControlTable,
                                                PrintSwisCodeOnParcelIDs, False);

                    {CHG07232003-1(2.07g): Option to print old \ new labels that only have old and new ID, legal addr.}

                  lfParcelID_OldID_ShortForm :
                    PrintLabelOldAndNewParcelID(SwisSBLKey, PNAddrArray^,
                                                ParcelTable,
                                                AssessmentYearControlTable,
                                                PrintSwisCodeOnParcelIDs, True);

                    {CHG12082004-3(2.8.1.2)[2016]: New label format.}

                  lfParcelAccountNumber_LegalAddress_OldID_ParcelID :
                    PrintLabelAcctNum_Addr_OldID_ParcelID(SwisSBLKey, PNAddrArray^,
                                                          ParcelTable,
                                                          PrintSwisCodeOnParcelIDs);

                  lfOwner_ExemptionCode_LegalAddress_PrintKey :
                    PrintOwner_ExemptionCode_LegalAddress_PrintKey(SwisSBLKey, PNAddrArray^,
                                                                   ParcelTable,
                                                                   SortTable.FieldByName('EXCode').AsString,
                                                                   PrintSwisCodeOnParcelIDs);

                    {CHG05292007-1(2.11.1.34): Add Owner \ Legal Address \ Print Key label format.}

                  lfOwner_LegalAddress_PrintKey :
                    PrintOwner_LegalAddress_PrintKey(SwisSBLKey, PNAddrArray^,
                                                     ParcelTable,
                                                     PrintSwisCodeOnParcelIDs);

                end;  {case LabelFormat of}

                  {Make sure this label is not blank.}

                BlankLabel := True;

                For I := 1 to 6 do
                  If _Compare(PNAddrArray^[I], '', coNotEqual)
                    then BlankLabel := False;

                If not BlankLabel
                  then LabelList.Add(PNAddrArray);

              end;  {else of If (LabelType = lbLaser1Liner)}

          NumLabelsPrinted := NumLabelsPrinted + 1;

        end;  {If not Done}

    Application.ProcessMessages;
    ProgressDialog.Update(Self, 'Num Labels Printed = ' + IntToStr(NumLabelsPrinted));
    LabelsCancelled := ProgressDialog.Cancelled;

  until (Done or LabelsCancelled);

  If not LabelsCancelled
    then
      begin
          {CHG12062003-1(2.07k1): Add extract to Excel to labels.}

        If (ExtractToExcel or ExtractToCommaDelimitedFile)
          then
            For I := 0 to (LabelList.Count - 1) do
              begin
                For J := 1 to 6 do
                  If (J = 1)
                    then Write(ExtractFile, Trim(PNameAddrArray(LabelList[I])^[J]))
                    else Write(ExtractFile, FormatExtractField(Trim(PNameAddrArray(LabelList[I])^[J])));

                Writeln(ExtractFile);

              end;  {If (ExtractToExcel or ExtractToCommaDelimitedFile)}

        PrintParcelIDOnly := (LabelFormat in [lfParcelIDOnly, lfParcelID_LegalAddress, lfParcelID_OldID_LegalAddress]);

          {CHG12062003-3(2.07k1): Allow for different font size for additional lines on parcel ID only labels.}
          {CHG12292004-1(2.8.1.7): Allow for font size to be altered even for non-parcel labels.}

(*        If not PrintParcelIDOnly
          then FontSizeAdditionalLines := 0; *)

        PrintLabelsOld(Sender, LabelList, LabelType,
                       PrintParcelIDOnly, PrintLabelsBold,
                       NumLinesPerLabel, NumLabelsPerPage,
                       NumColumnsPerPage, SingleParcelFontSize,
                       FontSizeAdditionalLines, LinesToBold,
                       PrintLabelsUnderline, LinesToUnderline,
                       PrintLabelsItalicized, LinesToItalicize);

          {FXX08041998-1: Add selection page.}
          {FXX01282004-4(2.08): Ask them whether or not they want a selection page.}

        If ((ReportType = rtLabels) and
            (MessageDlg('Do you want to print a page listing the selections used for this label run?' + #13 +
                        'If you do, please put a blank sheet of paper in the printer.',
                        mtConfirmation, [mbYes, mbNo], 0) = idYes))
          then PrintSelectionPage(Sender);

      end;  {If not LabelsCancelled}

  If (LabelType = lbLaser1Liner)
    then FreeTList(LabelList, 26)
    else FreeTList(LabelList, SizeOf(NameAddrArray));

end;  {LabelPrinterPrint}

{===================================================================}
Procedure TLabelsForm.CloseButtonClick(Sender: TObject);

begin
  Close;
end;

{===================================================================}
Procedure TLabelsForm.FormClose(    Sender: TObject;
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
